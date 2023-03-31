Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5886F6D1956
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjCaIGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbjCaIF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:05:59 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48EE1A956;
        Fri, 31 Mar 2023 01:05:36 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32V85EdP042994;
        Fri, 31 Mar 2023 03:05:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1680249914;
        bh=izWZ7+jy/m/3WOeD2gRVdDzMX7JkPg6p1HHfgyCiHHk=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=N8BlmowpJ5RtOPbv/sfnQID6vGOAbYBDc8Tz0D2y4tsL/9Ig/OS7q6l+M2ANJctfx
         XhJM7rLQdabf1Tz+0ImVKYNZCSa4sAOHru39QK0WZDjgGwAcZf52CATfnR+EZzxemd
         iUKBrz9OoZKwT6dsxtQJN7jErbfyXJ3hPNktJMmE=
Received: from DLEE103.ent.ti.com (dlee103.ent.ti.com [157.170.170.33])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32V85ENM126044
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 31 Mar 2023 03:05:14 -0500
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Fri, 31
 Mar 2023 03:05:13 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Fri, 31 Mar 2023 03:05:13 -0500
Received: from [172.24.145.61] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32V85Acf089564;
        Fri, 31 Mar 2023 03:05:11 -0500
Message-ID: <54c3964b-5dd8-c55e-08db-61df4a07797c@ti.com>
Date:   Fri, 31 Mar 2023 13:35:10 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <rogerq@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: Re: [PATCH net-next 2/2] net: ethernet: ti: am65-cpsw: Enable USXGMII
 mode for J784S4 CPSW9G
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
References: <20230331065110.604516-1-s-vadapalli@ti.com>
 <20230331065110.604516-3-s-vadapalli@ti.com>
 <ZCaSXQFZ/e/JIDEj@shell.armlinux.org.uk>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <ZCaSXQFZ/e/JIDEj@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Russell,

Thank you for reviewing the patch.

On 31/03/23 13:27, Russell King (Oracle) wrote:
> On Fri, Mar 31, 2023 at 12:21:10PM +0530, Siddharth Vadapalli wrote:
>> TI's J784S4 SoC supports USXGMII mode. Add USXGMII mode to the
>> extra_modes member of the J784S4 SoC data. Additionally, configure the
>> MAC Control register for supporting USXGMII mode. Also, for USXGMII
>> mode, include MAC_5000FD in the "mac_capabilities" member of struct
>> "phylink_config".
> 
> I don't think TI "get" phylink at all...
> 
>> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> index 4b4d06199b45..ab33e6fe5b1a 100644
>> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> @@ -1555,6 +1555,8 @@ static void am65_cpsw_nuss_mac_link_up(struct phylink_config *config, struct phy
>>  		mac_control |= CPSW_SL_CTL_GIG;
>>  	if (interface == PHY_INTERFACE_MODE_SGMII)
>>  		mac_control |= CPSW_SL_CTL_EXT_EN;
>> +	if (interface == PHY_INTERFACE_MODE_USXGMII)
>> +		mac_control |= CPSW_SL_CTL_XGIG | CPSW_SL_CTL_XGMII_EN;
> 
> The configuration of the interface mode should *not* happen in
> mac_link_up(), but should happen in e.g. mac_config().

I will move all the interface mode associated configurations to mac_config() in
the v2 series.

> 
>>  	if (speed == SPEED_10 && phy_interface_mode_is_rgmii(interface))
>>  		/* Can be used with in band mode only */
>>  		mac_control |= CPSW_SL_CTL_EXT_EN;
>> @@ -2175,6 +2177,7 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
>>  
>>  	case PHY_INTERFACE_MODE_QSGMII:
>>  	case PHY_INTERFACE_MODE_SGMII:
>> +	case PHY_INTERFACE_MODE_USXGMII:
>>  		if (common->pdata.extra_modes & BIT(port->slave.phy_if)) {
>>  			__set_bit(port->slave.phy_if,
>>  				  port->slave.phylink_config.supported_interfaces);
>> @@ -2182,6 +2185,9 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
>>  			dev_err(dev, "selected phy-mode is not supported\n");
>>  			return -EOPNOTSUPP;
>>  		}
>> +		/* For USXGMII mode, enable MAC_5000FD */
>> +		if (port->slave.phy_if == PHY_INTERFACE_MODE_USXGMII)
>> +			port->slave.phylink_config.mac_capabilities |= MAC_5000FD;
> 
> MAC capabilities should not be conditional in the interface mode.
> Phylink already knows the capabilities of each interface mode, and
> will mask the mac_capabilities accordingly. Phylink wants to know
> what speeds the MAC itself is capable of unbound by the interface
> mode.
> 
> The interface modes that you already support (RGMII, RMII, QSGMII
> and SGMII) do not support anything faster than 1G, so only
> mac_capabilities up to and including 1G speeds will be permitted
> for those interface modes internally by phylink.
> 
> So, making this conditional on USXGMII is just repeating logic that
> is already present internally in phylink.

Thank you for clarifying. I will fix this in the v2 series.

Regards,
Siddharth.
