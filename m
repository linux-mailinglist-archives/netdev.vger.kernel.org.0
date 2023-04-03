Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5AD6D3D50
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 08:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbjDCG1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 02:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjDCG1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 02:27:53 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF42C869B;
        Sun,  2 Apr 2023 23:27:51 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 3336RQjm013056;
        Mon, 3 Apr 2023 01:27:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1680503246;
        bh=IUjGDRnpRzPURCV8uSTZlVgPtZ8lAY7F0OvRLdEU+aM=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=CfaFxK6qbYDNWlbgSSFb9bNnYY5VOW5Wcd2i7FhxaSb8m8FW4zJWxUY9rnB9E/TNu
         GcGpYYjzDvUrVhbRYmhqtJYPPiTZ32ZRFaou5Fkmhid8Uw+HnxSqrfc6D3uXyg2bOU
         YxbMtHaeQh6wAk9SZMZX0xu2kl8Mkj48lPjrkoSA=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 3336RQrG028255
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 3 Apr 2023 01:27:26 -0500
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 3
 Apr 2023 01:27:25 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 3 Apr 2023 01:27:25 -0500
Received: from [172.24.145.61] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 3336RM9E011886;
        Mon, 3 Apr 2023 01:27:22 -0500
Message-ID: <be166ab3-29f9-a18d-bbbd-34e7828453e4@ti.com>
Date:   Mon, 3 Apr 2023 11:57:21 +0530
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
 <54c3964b-5dd8-c55e-08db-61df4a07797c@ti.com>
 <ZCaYve8wYl15YRxh@shell.armlinux.org.uk>
 <7a9c96f4-6a94-4a2c-18f5-95f7246e10d5@ti.com>
 <ZCasBMNxaWk2+XVO@shell.armlinux.org.uk>
 <dea9ae26-e7f2-1052-58cd-f7975165aa96@ti.com>
 <ZCbAE7IIc8HcOdxl@shell.armlinux.org.uk>
 <1477e0c3-bb92-72b0-9804-0393c34571d3@ti.com>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <1477e0c3-bb92-72b0-9804-0393c34571d3@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.9 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Russell,

On 31/03/23 19:16, Siddharth Vadapalli wrote:
> 
> 
> On 31-03-2023 16:42, Russell King (Oracle) wrote:
>> On Fri, Mar 31, 2023 at 04:23:16PM +0530, Siddharth Vadapalli wrote:
>>>
>>>
>>> On 31/03/23 15:16, Russell King (Oracle) wrote:
>>>> On Fri, Mar 31, 2023 at 02:55:56PM +0530, Siddharth Vadapalli wrote:
>>>>> Russell,
>>>>>
>>>>> On 31/03/23 13:54, Russell King (Oracle) wrote:
>>>>>> On Fri, Mar 31, 2023 at 01:35:10PM +0530, Siddharth Vadapalli wrote:
>>>>>>> Hello Russell,
>>>>>>>
>>>>>>> Thank you for reviewing the patch.
>>>>>>>
>>>>>>> On 31/03/23 13:27, Russell King (Oracle) wrote:
>>>>>>>> On Fri, Mar 31, 2023 at 12:21:10PM +0530, Siddharth Vadapalli wrote:
>>>>>>>>> TI's J784S4 SoC supports USXGMII mode. Add USXGMII mode to the
>>>>>>>>> extra_modes member of the J784S4 SoC data. Additionally, configure the
>>>>>>>>> MAC Control register for supporting USXGMII mode. Also, for USXGMII
>>>>>>>>> mode, include MAC_5000FD in the "mac_capabilities" member of struct
>>>>>>>>> "phylink_config".
>>>>>>>>
>>>>>>>> I don't think TI "get" phylink at all...
>>>>>>>>
>>>>>>>>> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>>>>>>>>> index 4b4d06199b45..ab33e6fe5b1a 100644
>>>>>>>>> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>>>>>>>>> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>>>>>>>>> @@ -1555,6 +1555,8 @@ static void am65_cpsw_nuss_mac_link_up(struct phylink_config *config, struct phy
>>>>>>>>>  		mac_control |= CPSW_SL_CTL_GIG;
>>>>>>>>>  	if (interface == PHY_INTERFACE_MODE_SGMII)
>>>>>>>>>  		mac_control |= CPSW_SL_CTL_EXT_EN;
>>>>>>>>> +	if (interface == PHY_INTERFACE_MODE_USXGMII)
>>>>>>>>> +		mac_control |= CPSW_SL_CTL_XGIG | CPSW_SL_CTL_XGMII_EN;
>>>>>>>>
>>>>>>>> The configuration of the interface mode should *not* happen in
>>>>>>>> mac_link_up(), but should happen in e.g. mac_config().
>>>>>>>
>>>>>>> I will move all the interface mode associated configurations to mac_config() in
>>>>>>> the v2 series.
>>>>>>
>>>>>> Looking at the whole of mac_link_up(), could you please describe what
>>>>>> effect these bits are having:
>>>>>>
>>>>>> 	CPSW_SL_CTL_GIG
>>>>>> 	CPSW_SL_CTL_EXT_EN
>>>>>> 	CPSW_SL_CTL_IFCTL_A
>>>>>
>>>>> CPSW_SL_CTL_GIG corresponds to enabling Gigabit mode (full duplex only).
>>>>> CPSW_SL_CTL_EXT_EN when set enables in-band mode of operation and when cleared
>>>>> enables forced mode of operation.
>>>>> CPSW_SL_CTL_IFCTL_A is used to set the RMII link speed (0=10 mbps, 1=100 mbps).
>>>>
>>>> Okay, so I would do in mac_link_up():
>>>>
>>>> 	/* RMII needs to be manually configured for 10/100Mbps */
>>>> 	if (interface == PHY_INTERFACE_MODE_RMII && speed == SPEED_100)
>>>> 		mac_control |= CPSW_SL_CTL_IFCTL_A;
>>>>
>>>> 	if (speed == SPEED_1000)
>>>> 		mac_control |= CPSW_SL_CTL_GIG;
>>>> 	if (duplex)
>>>> 		mac_control |= CPSW_SL_CTL_FULLDUPLEX;
>>>>
>>>> I would also make mac_link_up() do a read-modify-write operation to
>>>> only affect the bits that it is changing.
>>>
>>> This is the current implementation except for the SGMII mode associated
>>> operation that I had recently added. I will fix that. Also, the
>>> cpsw_sl_ctl_set() function which writes the mac_control value performs a read
>>> modify write operation.
>>>
>>>>
>>>> Now, for SGMII, I would move setting CPSW_SL_CTL_EXT_EN to mac_config()
>>>> to enable in-band mode - don't we want in-band mode enabled all the
>>>> time while in SGMII mode so the PHY gets the response from the MAC?
>>>
>>> Thank you for pointing it out. I will move that to mac_config().
>>>
>>>>
>>>> Lastly, for RGMII at 10Mbps, you seem to suggest that you need RGMII
>>>> in-band mode enabled for that - but if you need RGMII in-band for
>>>> 10Mbps, wouldn't it make sense for the other speeds as well? If so,
>>>> wouldn't that mean that CPSW_SL_CTL_EXT_EN can always be set for
>>>> RGMII no matter what speed is being used?
>>>
>>> The CPSW MAC does not support forced mode at 10 Mbps RGMII. For this reason, if
>>> RGMII 10 Mbps is requested, it is set to in-band mode.
>>
>> What I'm saying is that if we have in-band signalling that is reliable
>> for a particular interface mode, why not always use it, rather than
>> singling out one specific speed as an exception? Does it not work in
>> 100Mbps and 1Gbps?

While the CPSW MAC supports RGMII in-band status operation, the link partner
might not support it. I have also observed that forced mode is preferred to
in-band mode as implemented for another driver:
commit ade64eb5be9768e40c90ecb01295416abb2ddbac
net: dsa: microchip: Disable RGMII in-band status on KSZ9893

and in the mail thread at:
https://lore.kernel.org/netdev/20200905160647.GJ3164319@lunn.ch/
based on Andrew's suggestion, using forced mode appears to be better.

Additionally, I have verified that switching to in-band status causes a
regression. Thus, I will prefer keeping it in forced mode for 100 and 1000 Mbps
RGMII mode which is the existing implementation in the driver. Please let me know.

Regards,
Siddharth.

> 
> In-band RGMII is supported for speeds of 10, 100 and 1000 Mbps.
> Unfortunately, I am not aware of the reason why RGMII at speeds 100 and
> 1000 Mbps was implemented in the driver in forced mode. As suggested by
> you, I will work on implementing it in in-band mode for all speeds and
> verify that it works, following which I will post the v2 of this series,
> with the following changes based on your feedback:
> 1. All interface mode specific configuration will be moved to mac_config().
> 2. Since CPSW MAC supports USXGMII mode, MAC_5000FD will be added to the
> list of mac_capabilites unconditionally, unlike the current implementation.
> 3. In-band mode of operation will be enabled for all interface modes by
> default.
> 
> Regards,
> Siddharth.
