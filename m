Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4F36D433F
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 13:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbjDCLSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 07:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbjDCLSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 07:18:11 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105867DA8;
        Mon,  3 Apr 2023 04:18:06 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 333BHqM2092732;
        Mon, 3 Apr 2023 06:17:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1680520672;
        bh=bYhcyFvgcpJ9BPr8J6LZgLhC/TZiRbK1lHHFBaXBodU=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=C7lsuUtAupiXitiX2Xd293T7EijikjPHFLL90yAT5+NBpgPF53NiMB/BXgo9rX5eq
         bJVMZ2bMa8U6PKYaRM3JNHQ1vwirWjRnQlFCGG+ToayKMKlgQdTdsWdeyolgxZh3tO
         D5oJkhG0g1C16Qq1cNw7moo/FVr/hKSeGu0Ss8D8=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 333BHqRN023741
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 3 Apr 2023 06:17:52 -0500
Received: from DFLE113.ent.ti.com (10.64.6.34) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 3
 Apr 2023 06:17:52 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 3 Apr 2023 06:17:52 -0500
Received: from [172.24.145.61] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 333BHnXu092633;
        Mon, 3 Apr 2023 06:17:49 -0500
Message-ID: <4d322eb3-987e-4a20-0c24-7074064f5a97@ti.com>
Date:   Mon, 3 Apr 2023 16:47:48 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <rogerq@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: Re: [PATCH net-next v2 1/3] net: ethernet: ti: am65-cpsw: Move mode
 specific config to mac_config()
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
References: <20230403110106.983994-1-s-vadapalli@ti.com>
 <20230403110106.983994-2-s-vadapalli@ti.com>
 <ZCqzuwDLGuBDMHQG@shell.armlinux.org.uk>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <ZCqzuwDLGuBDMHQG@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-3.9 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
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

On 03/04/23 16:38, Russell King (Oracle) wrote:
> On Mon, Apr 03, 2023 at 04:31:04PM +0530, Siddharth Vadapalli wrote:
>> Move the interface mode specific configuration to the mac_config()
>> callback am65_cpsw_nuss_mac_config().
>>
>> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
>> ---
>>  drivers/net/ethernet/ti/am65-cpsw-nuss.c | 10 +++++++---
>>  1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> index d17757ecbf42..74e099828978 100644
>> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> @@ -1504,12 +1504,17 @@ static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned in
>>  							  phylink_config);
>>  	struct am65_cpsw_port *port = container_of(slave, struct am65_cpsw_port, slave);
>>  	struct am65_cpsw_common *common = port->common;
>> +	u32 mac_control = 0;
>>  
>>  	if (common->pdata.extra_modes & BIT(state->interface)) {
>> -		if (state->interface == PHY_INTERFACE_MODE_SGMII)
>> +		if (state->interface == PHY_INTERFACE_MODE_SGMII) {
>> +			mac_control |= CPSW_SL_CTL_EXT_EN;
>>  			writel(ADVERTISE_SGMII,
>>  			       port->sgmii_base + AM65_CPSW_SGMII_MR_ADV_ABILITY_REG);
>> +		}
>>  
>> +		if (mac_control)
>> +			cpsw_sl_ctl_set(port->slave.mac_sl, mac_control);
>>  		writel(AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE,
>>  		       port->sgmii_base + AM65_CPSW_SGMII_CONTROL_REG);
>>  	}
>> @@ -1553,8 +1558,7 @@ static void am65_cpsw_nuss_mac_link_up(struct phylink_config *config, struct phy
>>  
>>  	if (speed == SPEED_1000)
>>  		mac_control |= CPSW_SL_CTL_GIG;
>> -	if (interface == PHY_INTERFACE_MODE_SGMII)
>> -		mac_control |= CPSW_SL_CTL_EXT_EN;
>> +	/* TODO: Verify whether in-band is necessary for 10 Mbps RGMII */
>>  	if (speed == SPEED_10 && phy_interface_mode_is_rgmii(interface))
>>  		/* Can be used with in band mode only */
>>  		mac_control |= CPSW_SL_CTL_EXT_EN;
> 
> I'm afraid I can see you haven't thought this patch through properly.
> 
> am65_cpsw_nuss_mac_link_down() will call
> cpsw_sl_ctl_reset(port->slave.mac_sl); which has the effect of clearing
> to zero the entire MAC control register. This will clear
> CPSW_SL_CTL_EXT_EN that was set in am65_cpsw_nuss_mac_config() which is
> not what you want to be doing.

Right! I missed noticing this. It appeared to me that simply moving the code
from mac_link_up() to mac_config() would suffice. However, as rightly pointed
out by you, it doesn't account for the case where the interface state is toggled.

> 
> Given that we have the 10Mbps issue with RGMII, I think what you want
> to be doing is:
> 
> 1. Set CPSW_SL_CTL_EXT_EN in am65_cpsw_nuss_mac_config() if in SGMII
>    mode, otherwise clear this bit.
> 
> 2. Clear the mac_control register in am65_cpsw_nuss_mac_link_down()
>    if in RMGII mode, otherwise preserve the state of
>    CPSW_SL_CTL_EXT_EN but clear all other bits.
> 
> 3. Set CPSW_SL_CTL_EXT_EN in am65_cpsw_nuss_mac_link_up() if in
>    RGMII mode and 10Mbps.
> 

I will implement these changes and post the v3 series. Thank you for the
feedback. Please let me know if I may add a "Suggested-by" tag.

Regards,
Siddharth.
