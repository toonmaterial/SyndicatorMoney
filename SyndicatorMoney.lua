local Syndicator = _G["Syndicator"]

local function getMoneyString(money)
	return WHITE_FONT_COLOR:WrapTextInColorCode(GetMoneyString(money, true))
end

local function showMoneyTooltip(mf)
	GameTooltip:SetOwner(mf, "ANCHOR_TOPRIGHT")

	GameTooltip:AddLine("Money")
	GameTooltip:AddLine(" ")

	local total = 0

	for _, fullname in ipairs(Syndicator.API.GetAllCharacters()) do
		local character = Syndicator.API.GetCharacter(fullname)

		if not character.details.hidden then
			total = total + character.money

			GameTooltip:AddDoubleLine(
				RAID_CLASS_COLORS[character.details.className]:WrapTextInColorCode(fullname),
				getMoneyString(character.money))
		end
	end

	do
		local warband = Syndicator.API.GetWarband()

		total = total + warband.money

		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine("Warband", getMoneyString(warband.money))
	end

	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine("Total", getMoneyString(total))

	GameTooltip:Show()
end

for _, container in ipairs { ContainerFrame1, ContainerFrameCombinedBags } do
	local mf = container.MoneyFrame

	local function show() showMoneyTooltip(mf) end
	local function hide() GameTooltip:Hide() end

	mf:HookScript("OnEnter", show)
	mf:HookScript("OnLeave", hide)

	for _, button in ipairs { mf.GoldButton, mf.SilverButton, mf.CopperButton } do
		button:HookScript("OnEnter", show)
		button:HookScript("OnLeave", hide)
	end
end
