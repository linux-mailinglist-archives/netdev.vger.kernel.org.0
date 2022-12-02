Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7FE964117E
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 00:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbiLBX3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 18:29:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233221AbiLBX3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 18:29:12 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0F2CEFAD
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 15:29:11 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id o13so14912057ejm.1
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 15:29:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FlZmpsvcB9zb2R2tDTklavxONJ8h3E6CMZNTQMgPMCU=;
        b=NiU+p5Ja/D4n94OIOlNUg6dyipJu9fQ80q28OxU9zvQBPZptUJ9rnRb5jlPlJkry0j
         5yih7NpRoe3MhXyglsiVvF/DS2Rup/xIaZRNiMSBbnIYI7L1jnBUeEttEGHhzh31hcXQ
         xK1Mf5TIlz6ZYTb1SD/UHNWuqa1dQTsbhvm4SjvsI3rLv8RWB1xA+bj9QZQZWhn+uP7Y
         C1v3LgsOsVpjSM8N6vfOhZx++hqaHmAwJN60/xP/JpCAbDGNgTaWAR4ychRUChYO8heg
         7o4oXpbhYrEEmTw4Ol9+4Irsc4JjBZUvatPFMlNaH0D6TlxFJmeA+S57Ee6VjN0xfVij
         sJ0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FlZmpsvcB9zb2R2tDTklavxONJ8h3E6CMZNTQMgPMCU=;
        b=7P5RtTkEWKZzvm2yEvcBmZ9G9vTDI59du474sRDOVAUAESOY0ZClWfqyww9+mUONHt
         TnP+M717NsJ+044SAIJWn73cHodjynbgpgj0C+haK5SLvDtoJYkkUYbWbj5ZaQVnsc+A
         qMFmjsewdENaydwZL5jFDCcGMvD/HXb/u0CdE78qOsW8H5aXOAJeOYmFcan3yGCoM94X
         lVHyEPh/hpQl9Ids79vpp9P3qvT9NnyT42lyVqfkxtR7y312oqETHA4QbXP7VFH+Iq4X
         h86U0PmNnP4Kl6lP2LKstsJPgqdhXUq+lNs0wYzc9pALXLWBAFVq/jc+0CH1GISPK/x9
         zs2Q==
X-Gm-Message-State: ANoB5pkKfV28cvHA4kUg+qKrSSYExDTloHGMD3AZfc50pgiQv0WeJvn6
        sNtOnOkfo8bURg9Y8Vafx2E=
X-Google-Smtp-Source: AA0mqf5dk3dPPqgaP6FxYQO+00H/OVUtqvAd0v4DyfVc4ZeWwp4qXFEToyxvrccKU9lVzTzDMI1Hmw==
X-Received: by 2002:a17:906:5a94:b0:7bc:34d3:31fe with SMTP id l20-20020a1709065a9400b007bc34d331femr34392589ejq.427.1670023749280;
        Fri, 02 Dec 2022 15:29:09 -0800 (PST)
Received: from ?IPV6:2a01:c23:c0bd:c300:8000:63f:1f0b:d5d2? (dynamic-2a01-0c23-c0bd-c300-8000-063f-1f0b-d5d2.c23.pool.telefonica.de. [2a01:c23:c0bd:c300:8000:63f:1f0b:d5d2])
        by smtp.googlemail.com with ESMTPSA id la8-20020a170907780800b00788c622fa2csm3500390ejc.135.2022.12.02.15.29.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 15:29:08 -0800 (PST)
Message-ID: <d9950cdd-2964-692d-3c10-91168cf99878@gmail.com>
Date:   Sat, 3 Dec 2022 00:29:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
To:     Andrew Lunn <andrew@lunn.ch>,
        Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
References: <20221202083558.57618-1-mengyuanlou@net-swift.com>
 <Y4p0dQWijzQMlBmW@lunn.ch>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next] net: ngbe: Add mdio bus driver.
In-Reply-To: <Y4p0dQWijzQMlBmW@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.12.2022 22:56, Andrew Lunn wrote:
>> --- a/drivers/net/ethernet/wangxun/Kconfig
>> +++ b/drivers/net/ethernet/wangxun/Kconfig
>> @@ -25,6 +25,9 @@ config NGBE
>>  	tristate "Wangxun(R) GbE PCI Express adapters support"
>>  	depends on PCI
>>  	select LIBWX
>> +	select PHYLIB
>> +	select MARVELL_PHY
>> +	select MOTORCOMM_PHY
> 
> Don't select specific PHYs. Distros build them all as modules.
> 
>> +int ngbe_phy_led_oem_hostif(struct ngbe_hw *hw, u32 *data)
>> +{
>> +	struct wx_hic_read_shadow_ram buffer;
>> +	struct wx_hw *wxhw = &hw->wxhw;
>> +	int status;
> 
> Please break the patch up into smaller chunks and write good commit
> messages. I've no idea what this has to do with MDIO or PHY. Something
> to do with controlling the PHYs LEDS?
> 
> It seems like you could have one patch adding the MDIO bus support,
> and one patch adding calls to phylib. And then try to break the rest
> up into logical collections of changes.
> 
>> +	ret = wx_stop_adapter(wxhw);
>> +	if (ret != 0)
>> +		return ret;
>> +	val = WX_MIS_RST_LAN_RST(wxhw->bus.func);
>> +	wr32(wxhw, WX_MIS_RST, val | rd32(wxhw, WX_MIS_RST));
>> +
>> +	ret = read_poll_timeout(rd32, val,
>> +				!(val & (BIT(9) << wxhw->bus.func)), 1000,
>> +				100000, false, wxhw, 0x10028);
>> +	if (ret)
>> +		wx_dbg(wxhw, "Lan reset exceed s maximum times.\n");
>> +
>> +	wr32(wxhw, NGBE_PHY_CONFIG(0x1f), 0xa43);
>> +	ret = read_poll_timeout(rd32, val, val & 0x20, 1000,
>> +				100000, false, wxhw, NGBE_PHY_CONFIG(0x1d));
>> +	if (ret)
>> +		wx_dbg(wxhw, "Gphy reset failed.\n");
> 
> What is this doing? Toggling a GPIO which is connected to the PHY
> reset input?
> 
>> -	/* reset num_rar_entries to 128 */
>> +	/* reset num_rar_entries to 32 */
> 
> This looks like an unrelated change, nothing to do with MDIO or PHY.
> 
>>  	switch (type_mask) {
>>  	case NGBE_SUBID_M88E1512_SFP:
>>  	case NGBE_SUBID_LY_M88E1512_SFP:
>> -		hw->phy.type = ngbe_phy_m88e1512_sfi;
>> +		hw->phy.type = ngbe_phy_mv_sfi;
>>  		break;
>>  	case NGBE_SUBID_M88E1512_RJ45:
>> -		hw->phy.type = ngbe_phy_m88e1512;
>> +		hw->phy.type = ngbe_phy_mv;
>>  		break;
>>  	case NGBE_SUBID_M88E1512_MIX:
>> -		hw->phy.type = ngbe_phy_m88e1512_unknown;
>> +		hw->phy.type = ngbe_phy_mv_mix;
>>  		break;
>>  	case NGBE_SUBID_YT8521S_SFP:
>>  	case NGBE_SUBID_YT8521S_SFP_GPIO:
>>  	case NGBE_SUBID_LY_YT8521S_SFP:
>> -		hw->phy.type = ngbe_phy_yt8521s_sfi;
>> +		hw->phy.type = ngbe_phy_yt_mix;
>>  		break;
>>  	case NGBE_SUBID_INTERNAL_YT8521S_SFP:
>>  	case NGBE_SUBID_INTERNAL_YT8521S_SFP_GPIO:
>> -		hw->phy.type = ngbe_phy_internal_yt8521s_sfi;
>> +		hw->phy.type = ngbe_phy_internal_yt_sfi;
>>  		break;
>>  	case NGBE_SUBID_RGMII_FPGA:
>>  	case NGBE_SUBID_OCP_CARD:
> 
> Generally, a MAC driver does not care what sort of PHY is connected to
> it. The PHY driver does all that is needed. So it is not clear to me
> why you need this.
> 
> 
>> @@ -481,6 +539,8 @@ static int ngbe_probe(struct pci_dev *pdev,
>>  		   "PHY: %s, PBA No: Wang Xun GbE Family Controller\n",
>>  		   hw->phy.type == ngbe_phy_internal ? "Internal" : "External");
>>  	netif_info(adapter, probe, netdev, "%pM\n", netdev->dev_addr);
>> +	/* print PCI link speed and width */
>> +	pcie_print_link_status(pdev);
> 
> Also seems unrelated.
> 
>> +static int ngbe_phy_read_reg_mdi(struct mii_bus *bus, int phy_addr, int regnum)
>> +{
>> +	u32 command = 0, device_type = 0;
>> +	struct ngbe_hw *hw = bus->priv;
>> +	struct wx_hw *wxhw = &hw->wxhw;
>> +	u32 phy_data = 0;
>> +	u32 val = 0;
>> +	int ret = 0;
>> +
>> +	/* setup and write the address cycle command */
>> +	command = NGBE_MSCA_RA(regnum) |
>> +		  NGBE_MSCA_PA(phy_addr) |
>> +		  NGBE_MSCA_DA(device_type);
>> +	wr32(wxhw, NGBE_MSCA, command);
>> +
>> +	command = NGBE_MSCC_CMD(NGBE_MSCA_CMD_READ) |
>> +		  NGBE_MSCC_BUSY |
>> +		  NGBE_MDIO_CLK(6);
>> +	wr32(wxhw, NGBE_MSCC, command);
> 
> It looks like you don't support C45? If so, please return -EOPNOTSUPP
> if asked to do a C45 transaction.
> 
>> +static int ngbe_phy_read_reg(struct mii_bus *bus, int phy_addr, int regnum)
>> +{
>> +	struct ngbe_hw *hw = bus->priv;
>> +	u16 phy_data = 0;
>> +
>> +	if (hw->mac_type == ngbe_mac_type_mdi)
>> +		phy_data = ngbe_phy_read_reg_internal(bus, phy_addr, regnum);
>> +	else if (hw->mac_type == ngbe_mac_type_rgmii)
>> +		phy_data = ngbe_phy_read_reg_mdi(bus, phy_addr, regnum);
> 
> Do you have two mdio busses?
> 
>> +static void ngbe_gphy_wait_mdio_access_on(struct phy_device *phydev)
>> +{
>> +	u16 val;
>> +	int ret;
>> +
>> +	/* select page to 0xa43*/
>> +	phy_write(phydev, 0x1f, 0x0a43);
>> +	/* wait to phy can access */
>> +	ret = read_poll_timeout(phy_read, val, val & 0x20, 100,
>> +				2000, false, phydev, 0x1d);
> 
> What is this doing? The MAC should not be directly accessing the PHY.
> 

This seems to be call
phy_read_paged(phydev, 0xa43, RTL8211F_INSR);
from rtl8211f_ack_interrupt() in the Realtek PHY driver.
Looks to me like the assumption here is that a specific
Realtek PHY is attached.

>> +
>> +	if (ret)
>> +		phydev_err(phydev, "Access to phy timeout\n");
>> +}
>> +
>> +static void ngbe_gphy_dis_eee(struct phy_device *phydev)
>> +{
>> +	phy_write(phydev, 0x1f, 0x0a4b);
>> +	phy_write(phydev, 0x11, 0x1110);
>> +	phy_write(phydev, 0x1f, 0x0000);
>> +	phy_write(phydev, 0xd, 0x0007);
>> +	phy_write(phydev, 0xe, 0x003c);
>> +	phy_write(phydev, 0xd, 0x4007);
>> +	phy_write(phydev, 0xe, 0x0000);
> 
> Again, the MAC should not be accessing the PHY. From the name, i'm
> guessing your MAC does not support EEE? So you want to stop the PHY
> advertising EEE?
> 
> This is how other MAC drivers do this:
> 
> 	/* disable EEE autoneg, EEE not supported by TSNEP */
> 	memset(&ethtool_eee, 0, sizeof(ethtool_eee));
> 	phy_ethtool_set_eee(adapter->phydev, &ethtool_eee);
> 
> Please delete all code which directly access the PHY. You might need
> to add new functionality to the PHY driver, but in general, it is not
> needed, the existing PHY drivers should do what you need.
> 
>> +int ngbe_phy_connect(struct ngbe_hw *hw)
>> +{
>> +	struct ngbe_adapter *adapter = container_of(hw,
>> +						    struct ngbe_adapter,
>> +						    hw);
>> +	int ret;
>> +
>> +	ret = phy_connect_direct(adapter->netdev,
>> +				 hw->phydev,
>> +				 ngbe_handle_link_change,
>> +				 PHY_INTERFACE_MODE_RGMII);
> 
> Who is responsible for RGMII delays? In general, the PHY adds the
> delay, so you pass PHY_INTERFACE_MODE_RGMII_ID here.
> 
>> +int ngbe_mdio_init(struct ngbe_hw *hw)
>> +{
>> +	struct pci_dev *pdev = hw->wxhw.pdev;
>> +	int ret;
>> +
>> +	hw->mii_bus = devm_mdiobus_alloc(&pdev->dev);
>> +	if (!hw->mii_bus)
>> +		return -ENOMEM;
>> +
>> +	hw->mii_bus->name = "ngbe_mii_bus";
>> +	hw->mii_bus->read = &ngbe_phy_read_reg;
>> +	hw->mii_bus->write = &ngbe_phy_write_reg;
>> +	hw->mii_bus->phy_mask = 0xfffffffe;
>> +	hw->mii_bus->parent = &pdev->dev;
>> +	hw->mii_bus->priv = hw;
>> +
>> +	snprintf(hw->mii_bus->id, MII_BUS_ID_SIZE, "ngbe-%x",
>> +		 (pdev->bus->number << 8) |
>> +		 pdev->devfn);
>> +
>> +	ret = devm_mdiobus_register(&pdev->dev, hw->mii_bus);
>> +	if (ret)
>> +		return ret;
>> +
>> +	hw->phydev = mdiobus_get_phy(hw->mii_bus, 0);
> 
> Is this a hardware limitation? Only address 0 is supported?
> 
>> +	if (!hw->phydev) {
>> +		return -ENODEV;
>> +	} else if (!hw->phydev->drv) {
>> +		wx_err(&hw->wxhw,
>> +		       "No dedicated PHY driver found for PHY ID 0x%08x.\n",
>> +		       hw->phydev->phy_id);
>> +		return -EUNATCH;
>> +	}
> 

This code seems to be copied from r8169_mdio_register() in the r8169
MAC driver. There we deal with internal PHY's only. Once we know the
MAC version, we know the PHY version.

In r8169 the motivation for the check is that access to registers
MII_MMD_CTRL/MII_MMD_DATA causes a hang on certain PHY versions
with the genphy driver. These PHY versions have vendor-specific
registers at addresses MII_MMD_CTRL/MII_MMD_DATA.

Author should explain what's his motivation here.

> That is probably wrong. The module could still be loading. It is only
> when you connect the MAC to the PHY does it need to have a PHY
> driver. At that point, if there is no driver loaded it will fall back
> to the generic PHY driver. You don't see any other MAC driver with
> code like this.
> 
> As a general comment, if you do something which no other driver does,
> you are probably doing something you should not do.
> 
>     Andrew
> 
Heiner

