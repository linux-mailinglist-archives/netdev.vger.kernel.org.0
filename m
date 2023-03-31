Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3B36D21AC
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 15:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbjCaNre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 09:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbjCaNr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 09:47:26 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B57C5;
        Fri, 31 Mar 2023 06:47:23 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32VDkxSe108404;
        Fri, 31 Mar 2023 08:46:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1680270419;
        bh=SWPIzGPRGAu6t63g7pLGQ9b7TThlwDUoaymWmbCwIoM=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=vUodkCK9JoPurw4zcxVw+iJDjLJgjbzpteH17amMWyrdfIvmy3Enn2Rdox4kXTrzL
         oxm+86wbin6SHyQUpumoQ8hdYH3LbV4bK/tO7sEBusjeJD04NWxcX0b84gPfwTjZo2
         iRn+q5WSI9NVLCrrfdcyGILKLQXuZeWiE97Ab18o=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32VDkx5r015850
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 31 Mar 2023 08:46:59 -0500
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Fri, 31
 Mar 2023 08:46:59 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Fri, 31 Mar 2023 08:46:59 -0500
Received: from [10.249.131.130] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32VDktuq001841;
        Fri, 31 Mar 2023 08:46:56 -0500
Message-ID: <1477e0c3-bb92-72b0-9804-0393c34571d3@ti.com>
Date:   Fri, 31 Mar 2023 19:16:55 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <rogerq@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: Re: [PATCH net-next 2/2] net: ethernet: ti: am65-cpsw: Enable USXGMII
 mode for J784S4 CPSW9G
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
Content-Language: en-US
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <ZCbAE7IIc8HcOdxl@shell.armlinux.org.uk>
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



On 31-03-2023 16:42, Russell King (Oracle) wrote:
> On Fri, Mar 31, 2023 at 04:23:16PM +0530, Siddharth Vadapalli wrote:
>>
>>
>> On 31/03/23 15:16, Russell King (Oracle) wrote:
>>> On Fri, Mar 31, 2023 at 02:55:56PM +0530, Siddharth Vadapalli wrote:
>>>> Russell,
>>>>
>>>> On 31/03/23 13:54, Russell King (Oracle) wrote:
>>>>> On Fri, Mar 31, 2023 at 01:35:10PM +0530, Siddharth Vadapalli wrote:
>>>>>> Hello Russell,
>>>>>>
>>>>>> Thank you for reviewing the patch.
>>>>>>
>>>>>> On 31/03/23 13:27, Russell King (Oracle) wrote:
>>>>>>> On Fri, Mar 31, 2023 at 12:21:10PM +0530, Siddharth Vadapalli wrote:
>>>>>>>> TI's J784S4 SoC supports USXGMII mode. Add USXGMII mode to the
>>>>>>>> extra_modes member of the J784S4 SoC data. Additionally, configure the
>>>>>>>> MAC Control register for supporting USXGMII mode. Also, for USXGMII
>>>>>>>> mode, include MAC_5000FD in the "mac_capabilities" member of struct
>>>>>>>> "phylink_config".
>>>>>>>
>>>>>>> I don't think TI "get" phylink at all...
>>>>>>>
>>>>>>>> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>>>>>>>> index 4b4d06199b45..ab33e6fe5b1a 100644
>>>>>>>> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>>>>>>>> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>>>>>>>> @@ -1555,6 +1555,8 @@ static void am65_cpsw_nuss_mac_link_up(struct phylink_config *config, struct phy
>>>>>>>>  		mac_control |= CPSW_SL_CTL_GIG;
>>>>>>>>  	if (interface == PHY_INTERFACE_MODE_SGMII)
>>>>>>>>  		mac_control |= CPSW_SL_CTL_EXT_EN;
>>>>>>>> +	if (interface == PHY_INTERFACE_MODE_USXGMII)
>>>>>>>> +		mac_control |= CPSW_SL_CTL_XGIG | CPSW_SL_CTL_XGMII_EN;
>>>>>>>
>>>>>>> The configuration of the interface mode should *not* happen in
>>>>>>> mac_link_up(), but should happen in e.g. mac_config().
>>>>>>
>>>>>> I will move all the interface mode associated configurations to mac_config() in
>>>>>> the v2 series.
>>>>>
>>>>> Looking at the whole of mac_link_up(), could you please describe what
>>>>> effect these bits are having:
>>>>>
>>>>> 	CPSW_SL_CTL_GIG
>>>>> 	CPSW_SL_CTL_EXT_EN
>>>>> 	CPSW_SL_CTL_IFCTL_A
>>>>
>>>> CPSW_SL_CTL_GIG corresponds to enabling Gigabit mode (full duplex only).
>>>> CPSW_SL_CTL_EXT_EN when set enables in-band mode of operation and when cleared
>>>> enables forced mode of operation.
>>>> CPSW_SL_CTL_IFCTL_A is used to set the RMII link speed (0=10 mbps, 1=100 mbps).
>>>
>>> Okay, so I would do in mac_link_up():
>>>
>>> 	/* RMII needs to be manually configured for 10/100Mbps */
>>> 	if (interface == PHY_INTERFACE_MODE_RMII && speed == SPEED_100)
>>> 		mac_control |= CPSW_SL_CTL_IFCTL_A;
>>>
>>> 	if (speed == SPEED_1000)
>>> 		mac_control |= CPSW_SL_CTL_GIG;
>>> 	if (duplex)
>>> 		mac_control |= CPSW_SL_CTL_FULLDUPLEX;
>>>
>>> I would also make mac_link_up() do a read-modify-write operation to
>>> only affect the bits that it is changing.
>>
>> This is the current implementation except for the SGMII mode associated
>> operation that I had recently added. I will fix that. Also, the
>> cpsw_sl_ctl_set() function which writes the mac_control value performs a read
>> modify write operation.
>>
>>>
>>> Now, for SGMII, I would move setting CPSW_SL_CTL_EXT_EN to mac_config()
>>> to enable in-band mode - don't we want in-band mode enabled all the
>>> time while in SGMII mode so the PHY gets the response from the MAC?
>>
>> Thank you for pointing it out. I will move that to mac_config().
>>
>>>
>>> Lastly, for RGMII at 10Mbps, you seem to suggest that you need RGMII
>>> in-band mode enabled for that - but if you need RGMII in-band for
>>> 10Mbps, wouldn't it make sense for the other speeds as well? If so,
>>> wouldn't that mean that CPSW_SL_CTL_EXT_EN can always be set for
>>> RGMII no matter what speed is being used?
>>
>> The CPSW MAC does not support forced mode at 10 Mbps RGMII. For this reason, if
>> RGMII 10 Mbps is requested, it is set to in-band mode.
> 
> What I'm saying is that if we have in-band signalling that is reliable
> for a particular interface mode, why not always use it, rather than
> singling out one specific speed as an exception? Does it not work in
> 100Mbps and 1Gbps?

In-band RGMII is supported for speeds of 10, 100 and 1000 Mbps.
Unfortunately, I am not aware of the reason why RGMII at speeds 100 and
1000 Mbps was implemented in the driver in forced mode. As suggested by
you, I will work on implementing it in in-band mode for all speeds and
verify that it works, following which I will post the v2 of this series,
with the following changes based on your feedback:
1. All interface mode specific configuration will be moved to mac_config().
2. Since CPSW MAC supports USXGMII mode, MAC_5000FD will be added to the
list of mac_capabilites unconditionally, unlike the current implementation.
3. In-band mode of operation will be enabled for all interface modes by
default.

Regards,
Siddharth.
