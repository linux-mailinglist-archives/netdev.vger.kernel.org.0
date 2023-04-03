Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 691016D3F39
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 10:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbjDCIle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 04:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbjDCIlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 04:41:31 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D25F7A96;
        Mon,  3 Apr 2023 01:41:28 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 3338fDiA060195;
        Mon, 3 Apr 2023 03:41:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1680511273;
        bh=T9A2pM3JjcyPu1X6ZFo4ztB36jbGIbbaklmXO/SWmcs=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=ZH0BlIm4tvdmvLh61T32CSVr0RHKoSUUti6fClncXlixfyLbMDvWbTpgk0kNWF/xo
         LquKibjXZE8JbS9y2BnKbLMyAn6H/VJiDJ48jBKF9JrLdh9XyqF0GGTKt2fipEWqt2
         EKTFU2fTVBWtP2Sz49oaiMiMEjeytj2XTKHDZrR4=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 3338fDhN019262
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 3 Apr 2023 03:41:13 -0500
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 3
 Apr 2023 03:41:12 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 3 Apr 2023 03:41:12 -0500
Received: from [172.24.145.61] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 3338f9pK107643;
        Mon, 3 Apr 2023 03:41:09 -0500
Message-ID: <5114b342-6727-b27c-bc8c-c770ed4baa31@ti.com>
Date:   Mon, 3 Apr 2023 14:11:08 +0530
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
References: <20230331065110.604516-3-s-vadapalli@ti.com>
 <ZCaSXQFZ/e/JIDEj@shell.armlinux.org.uk>
 <54c3964b-5dd8-c55e-08db-61df4a07797c@ti.com>
 <ZCaYve8wYl15YRxh@shell.armlinux.org.uk>
 <7a9c96f4-6a94-4a2c-18f5-95f7246e10d5@ti.com>
 <ZCasBMNxaWk2+XVO@shell.armlinux.org.uk>
 <dea9ae26-e7f2-1052-58cd-f7975165aa96@ti.com>
 <ZCbAE7IIc8HcOdxl@shell.armlinux.org.uk>
 <1477e0c3-bb92-72b0-9804-0393c34571d3@ti.com>
 <be166ab3-29f9-a18d-bbbd-34e7828453e4@ti.com>
 <ZCqPHM2/qismCaaN@shell.armlinux.org.uk>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <ZCqPHM2/qismCaaN@shell.armlinux.org.uk>
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



On 03/04/23 14:02, Russell King (Oracle) wrote:
> On Mon, Apr 03, 2023 at 11:57:21AM +0530, Siddharth Vadapalli wrote:
>> Hello Russell,
>>
>> On 31/03/23 19:16, Siddharth Vadapalli wrote:
>>>
>>>
>>> On 31-03-2023 16:42, Russell King (Oracle) wrote:
>>>> On Fri, Mar 31, 2023 at 04:23:16PM +0530, Siddharth Vadapalli wrote:
>>>>>
>>>>>
>>>>> On 31/03/23 15:16, Russell King (Oracle) wrote:
>>>>>> On Fri, Mar 31, 2023 at 02:55:56PM +0530, Siddharth Vadapalli wrote:
>>>>>>> Russell,
>>>>>>>
>>>>>>> On 31/03/23 13:54, Russell King (Oracle) wrote:
>>>>>>>> On Fri, Mar 31, 2023 at 01:35:10PM +0530, Siddharth Vadapalli wrote:
>>>>>>>>> Hello Russell,
>>>>>>>>>
>>>>>>>>> Thank you for reviewing the patch.
>>>>>>>>>
>>>>>>>>> On 31/03/23 13:27, Russell King (Oracle) wrote:
>>>>>>>>>> On Fri, Mar 31, 2023 at 12:21:10PM +0530, Siddharth Vadapalli wrote:
>>>>>>>>>>> TI's J784S4 SoC supports USXGMII mode. Add USXGMII mode to the
>>>>>>>>>>> extra_modes member of the J784S4 SoC data. Additionally, configure the
>>>>>>>>>>> MAC Control register for supporting USXGMII mode. Also, for USXGMII
>>>>>>>>>>> mode, include MAC_5000FD in the "mac_capabilities" member of struct
>>>>>>>>>>> "phylink_config".
>>>>>>>>>>
>>>>>>>>>> I don't think TI "get" phylink at all...
>>>>>>>>>>
>>>>>>>>>>> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>>>>>>>>>>> index 4b4d06199b45..ab33e6fe5b1a 100644
>>>>>>>>>>> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>>>>>>>>>>> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>>>>>>>>>>> @@ -1555,6 +1555,8 @@ static void am65_cpsw_nuss_mac_link_up(struct phylink_config *config, struct phy
>>>>>>>>>>>  		mac_control |= CPSW_SL_CTL_GIG;
>>>>>>>>>>>  	if (interface == PHY_INTERFACE_MODE_SGMII)
>>>>>>>>>>>  		mac_control |= CPSW_SL_CTL_EXT_EN;
>>>>>>>>>>> +	if (interface == PHY_INTERFACE_MODE_USXGMII)
>>>>>>>>>>> +		mac_control |= CPSW_SL_CTL_XGIG | CPSW_SL_CTL_XGMII_EN;
>>>>>>>>>>
>>>>>>>>>> The configuration of the interface mode should *not* happen in
>>>>>>>>>> mac_link_up(), but should happen in e.g. mac_config().
>>>>>>>>>
>>>>>>>>> I will move all the interface mode associated configurations to mac_config() in
>>>>>>>>> the v2 series.
>>>>>>>>
>>>>>>>> Looking at the whole of mac_link_up(), could you please describe what
>>>>>>>> effect these bits are having:
>>>>>>>>
>>>>>>>> 	CPSW_SL_CTL_GIG
>>>>>>>> 	CPSW_SL_CTL_EXT_EN
>>>>>>>> 	CPSW_SL_CTL_IFCTL_A
>>>>>>>
>>>>>>> CPSW_SL_CTL_GIG corresponds to enabling Gigabit mode (full duplex only).
>>>>>>> CPSW_SL_CTL_EXT_EN when set enables in-band mode of operation and when cleared
>>>>>>> enables forced mode of operation.
>>>>>>> CPSW_SL_CTL_IFCTL_A is used to set the RMII link speed (0=10 mbps, 1=100 mbps).
>>>>>>
>>>>>> Okay, so I would do in mac_link_up():
>>>>>>
>>>>>> 	/* RMII needs to be manually configured for 10/100Mbps */
>>>>>> 	if (interface == PHY_INTERFACE_MODE_RMII && speed == SPEED_100)
>>>>>> 		mac_control |= CPSW_SL_CTL_IFCTL_A;
>>>>>>
>>>>>> 	if (speed == SPEED_1000)
>>>>>> 		mac_control |= CPSW_SL_CTL_GIG;
>>>>>> 	if (duplex)
>>>>>> 		mac_control |= CPSW_SL_CTL_FULLDUPLEX;
>>>>>>
>>>>>> I would also make mac_link_up() do a read-modify-write operation to
>>>>>> only affect the bits that it is changing.
>>>>>
>>>>> This is the current implementation except for the SGMII mode associated
>>>>> operation that I had recently added. I will fix that. Also, the
>>>>> cpsw_sl_ctl_set() function which writes the mac_control value performs a read
>>>>> modify write operation.
>>>>>
>>>>>>
>>>>>> Now, for SGMII, I would move setting CPSW_SL_CTL_EXT_EN to mac_config()
>>>>>> to enable in-band mode - don't we want in-band mode enabled all the
>>>>>> time while in SGMII mode so the PHY gets the response from the MAC?
>>>>>
>>>>> Thank you for pointing it out. I will move that to mac_config().
>>>>>
>>>>>>
>>>>>> Lastly, for RGMII at 10Mbps, you seem to suggest that you need RGMII
>>>>>> in-band mode enabled for that - but if you need RGMII in-band for
>>>>>> 10Mbps, wouldn't it make sense for the other speeds as well? If so,
>>>>>> wouldn't that mean that CPSW_SL_CTL_EXT_EN can always be set for
>>>>>> RGMII no matter what speed is being used?
>>>>>
>>>>> The CPSW MAC does not support forced mode at 10 Mbps RGMII. For this reason, if
>>>>> RGMII 10 Mbps is requested, it is set to in-band mode.
>>>>
>>>> What I'm saying is that if we have in-band signalling that is reliable
>>>> for a particular interface mode, why not always use it, rather than
>>>> singling out one specific speed as an exception? Does it not work in
>>>> 100Mbps and 1Gbps?
>>
>> While the CPSW MAC supports RGMII in-band status operation, the link partner
>> might not support it. I have also observed that forced mode is preferred to
>> in-band mode as implemented for another driver:
>> commit ade64eb5be9768e40c90ecb01295416abb2ddbac
>> net: dsa: microchip: Disable RGMII in-band status on KSZ9893
>>
>> and in the mail thread at:
>> https://lore.kernel.org/netdev/20200905160647.GJ3164319@lunn.ch/
>> based on Andrew's suggestion, using forced mode appears to be better.
>>
>> Additionally, I have verified that switching to in-band status causes a
>> regression. Thus, I will prefer keeping it in forced mode for 100 and 1000 Mbps
>> RGMII mode which is the existing implementation in the driver. Please let me know.
> 
> Okay, so what this seems to mean is if you have a PHY that does not
> support in-band status in RGMII mode, then 10Mbps isn't possible -
> because the MAC requires in-band status mode to select 10Mbps.
> To put it another way, in such a combination, 10Mbps link modes
> should not be advertised, nor should they be reported to userspace
> as being supported.
> 
> Is that correct?

Yes, if the PHY does not support in-band status, 10 Mbps RGMII will not work,
despite the MAC supporting 10 Mbps in-band RGMII. However, I notice the following:
If the RGMII interface speed is set to 10 Mbps via ethtool, but the:
managed = "in-band-status";
property is not mentioned in the device-tree, the interface is able to work with
10 Mbps mode with the PHY. This is with the CPSW MAC configured for in-band mode
of operation at 10 Mbps RGMII mode. Please let me know what this indicates,
since it appears to me that 10 Mbps is functional in this special case (It might
be an erroneous configuration).

Regards,
Siddharth.
