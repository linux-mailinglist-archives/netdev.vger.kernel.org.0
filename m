Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6E46D4633
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 15:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbjDCNvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 09:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232642AbjDCNvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 09:51:03 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9244B113EA;
        Mon,  3 Apr 2023 06:50:45 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 333DoQGw052221;
        Mon, 3 Apr 2023 08:50:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1680529826;
        bh=V8TasBvGKPUbNJjH0UVyLMntViaGjNuLhuNAJPFzazM=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=nUR4rPb4YCM3+Rctoq+bd/lQKXUJnb06/a0tj3idYad0OjTzD6tmCki/9Kdih5anR
         mah8PWqenZ+B7DIqLT1wEpdbpiAdlwgY8aUjByu4UXTjbBr8C+Wc5I2PoW492GaOo0
         5XM531q6IkWdjRF20escf262FYNXZs4fN5qWUdo4=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 333DoQks023751
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 3 Apr 2023 08:50:26 -0500
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 3
 Apr 2023 08:50:26 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 3 Apr 2023 08:50:26 -0500
Received: from [10.249.131.130] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 333DoMjJ130751;
        Mon, 3 Apr 2023 08:50:22 -0500
Message-ID: <a6dba95a-03ae-12ec-3ef4-c9544073c7a2@ti.com>
Date:   Mon, 3 Apr 2023 19:20:21 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
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
 <3a62f5cf-ebba-1603-50a0-7a873973534d@ti.com>
 <ZCrQ3lPjEmxXc9a2@shell.armlinux.org.uk>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <ZCrQ3lPjEmxXc9a2@shell.armlinux.org.uk>
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



On 03-04-2023 18:43, Russell King (Oracle) wrote:
> On Mon, Apr 03, 2023 at 06:31:52PM +0530, Siddharth Vadapalli wrote:
>>
>>
>> On 03-04-2023 16:38, Russell King (Oracle) wrote:
>>> On Mon, Apr 03, 2023 at 04:31:04PM +0530, Siddharth Vadapalli wrote:
>>>> Move the interface mode specific configuration to the mac_config()
>>>> callback am65_cpsw_nuss_mac_config().
>>>>
>>>> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
>>>> ---
>>>>  drivers/net/ethernet/ti/am65-cpsw-nuss.c | 10 +++++++---
>>>>  1 file changed, 7 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>>>> index d17757ecbf42..74e099828978 100644
>>>> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>>>> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>>>> @@ -1504,12 +1504,17 @@ static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned in
>>>>  							  phylink_config);
>>>>  	struct am65_cpsw_port *port = container_of(slave, struct am65_cpsw_port, slave);
>>>>  	struct am65_cpsw_common *common = port->common;
>>>> +	u32 mac_control = 0;
>>>>  
>>>>  	if (common->pdata.extra_modes & BIT(state->interface)) {
>>>> -		if (state->interface == PHY_INTERFACE_MODE_SGMII)
>>>> +		if (state->interface == PHY_INTERFACE_MODE_SGMII) {
>>>> +			mac_control |= CPSW_SL_CTL_EXT_EN;
>>>>  			writel(ADVERTISE_SGMII,
>>>>  			       port->sgmii_base + AM65_CPSW_SGMII_MR_ADV_ABILITY_REG);
>>>> +		}
>>>>  
>>>> +		if (mac_control)
>>>> +			cpsw_sl_ctl_set(port->slave.mac_sl, mac_control);
>>>>  		writel(AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE,
>>>>  		       port->sgmii_base + AM65_CPSW_SGMII_CONTROL_REG);
>>>>  	}
>>>> @@ -1553,8 +1558,7 @@ static void am65_cpsw_nuss_mac_link_up(struct phylink_config *config, struct phy
>>>>  
>>>>  	if (speed == SPEED_1000)
>>>>  		mac_control |= CPSW_SL_CTL_GIG;
>>>> -	if (interface == PHY_INTERFACE_MODE_SGMII)
>>>> -		mac_control |= CPSW_SL_CTL_EXT_EN;
>>>> +	/* TODO: Verify whether in-band is necessary for 10 Mbps RGMII */
>>>>  	if (speed == SPEED_10 && phy_interface_mode_is_rgmii(interface))
>>>>  		/* Can be used with in band mode only */
>>>>  		mac_control |= CPSW_SL_CTL_EXT_EN;
>>>
>>> I'm afraid I can see you haven't thought this patch through properly.
>>>
>>> am65_cpsw_nuss_mac_link_down() will call
>>> cpsw_sl_ctl_reset(port->slave.mac_sl); which has the effect of clearing
>>> to zero the entire MAC control register. This will clear
>>> CPSW_SL_CTL_EXT_EN that was set in am65_cpsw_nuss_mac_config() which is
>>> not what you want to be doing.
>>>
>>> Given that we have the 10Mbps issue with RGMII, I think what you want
>>> to be doing is:
>>>
>>> 1. Set CPSW_SL_CTL_EXT_EN in am65_cpsw_nuss_mac_config() if in SGMII
>>>    mode, otherwise clear this bit.
>>>
>>> 2. Clear the mac_control register in am65_cpsw_nuss_mac_link_down()
>>>    if in RMGII mode, otherwise preserve the state of
>>>    CPSW_SL_CTL_EXT_EN but clear all other bits.
>>>
>>> 3. Set CPSW_SL_CTL_EXT_EN in am65_cpsw_nuss_mac_link_up() if in
>>>    RGMII mode and 10Mbps.
>>
>> I plan to implement it as follows:
>> 1. Add a member "u32 mode_config" to "struct am65_cpsw_slave_data" in
>> "am65-cpsw-nuss.h".
>> 2. In am65_cpsw_nuss_mac_config(), store the value of mac_control in
>> "port->slave.mode_config".
>> 3. In am65_cpsw_nuss_mac_link_down(), after the reset via
>> cpsw_sl_ctl_reset(), execute:
>> cpsw_sl_ctl_set(port->slave.mac_sl, port->slave.mode_config) in order to
>> restore the configuration performed in am65_cpsw_nuss_mac_config().
>>
>> Please let me know in case of any suggestions to implement it in a
>> better manner.
> 
> Do you think this complexity is really worth it?
> 
> Let's look at what's available:
> 
> cpsw_sl_ctl_set() - sets bits in the mac control register
> cpsw_sl_ctl_clr() - clears bits in the mac control register
> cpsw_sl_ctl_reset() - sets the mac control register to zero
> 
> So, in mac_config(), we can do:
> 
> 	if (interface == SGMII)
> 		cpsw_sl_ctl_set(CPSW_SL_CTL_EXT_EN);
> 	else
> 		cpsw_sl_ctl_clr(CPSW_SL_CTL_EXT_EN);

While this will work for patch 1/3, once I add support for USXGMII mode
as in patch 3/3, I believe that I have to invert it, beginning by
invoking a cpsw_sl_ctl_clr(CPSW_SL_CTL_EXT_EN) at the start in
mac_config() followed by switching through the modes. If the mode is
SGMII, then I invoke cpsw_sl_ctl_set(CPSW_SL_CTL_EXT_EN), along with the
write to the MR_ADV_ABILITY_REG register to advertise SGMII. If the mode
is USXGMII, then I invoke:
cpsw_sl_ctl_set(CPSW_SL_CTL_XGIG | CPSW_SL_CTL_XGMII_EN)

> 
> 
> in mac_link_down():
> 
> 	u32 ctl;
> 
> 	ctl = CPSW_SL_CTL_GMII_EN | CPSW_SL_CTL_GIG |
> 	      CPSW_SL_CTL_IFCTL_A | CPSW_SL_CTL_FULLDUPLEX |
> 	      CPSW_SL_CTL_RX_FLOW_EN | CPSW_SL_CTL_TX_FLOW_EN;
> 	if (phy_interface_mode_is_rgmii(interface))
> 		ctl |= CPSW_SL_CTL_EXT_EN;
> 
> 	cpsw_sl_ctl_clr(ctl);
> 
> This ensures that we don't touch any bits in mac_link_down() which we
> aren't modifying in the corresponding mac_link_up() implementation.

This is very helpful. Thank you for the suggestion :)

> 
> Q: do we really need to clear the mac control register on link down?
> If we don't, then we can do better, but we need an additional helper
> which allows read-modify-write of the mac control register using a
> mask value and a value of bits to set. Then we can have mac_link_up()
> setting and clearing the bits as necessary - but I would still keep
> the clearing of CPSW_SL_CTL_EXT_EN for RGMII modes in mac_link_down()
> for now.

Clearing the entire register is not necessary. As long as those bits
that were set during mac_link_up() are cleared, it should be sufficient.

For now, I will implement the changes assuming that the mac control
register will be cleared on link down, based on the above suggestions
provided by you.

Regards,
Siddharth.
