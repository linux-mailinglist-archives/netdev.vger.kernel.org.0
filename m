Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE4E5BA8F6
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 11:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbiIPJEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 05:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbiIPJEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 05:04:30 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873062EC;
        Fri, 16 Sep 2022 02:04:26 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 28G93TM3094011;
        Fri, 16 Sep 2022 04:03:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1663319009;
        bh=l0yzlJ3VRMyHn0c+evjmOZziDl/jyYHZXoy+RPAZVdM=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=eJRu0kkW24ozs/jtJW/PYVEugEbz2ay/34uU2ygzirMc5nQdG05EhffOWwfr8ZuXC
         Olszw/35kOgWvKBhyrZu8qJYaeJNcZufdioCFwT9uehW91esMzumEmXTxw3yiqSUG8
         oj38/d00b9A0F9uUYHFQroho+0UgBwATb66gJt4A=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 28G93Thh016060
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 16 Sep 2022 04:03:29 -0500
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Fri, 16
 Sep 2022 04:03:28 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Fri, 16 Sep 2022 04:03:28 -0500
Received: from [10.24.69.241] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 28G93NF6100788;
        Fri, 16 Sep 2022 04:03:24 -0500
Message-ID: <85398274-c0fb-6ef6-29b3-ad8d2465f8e4@ti.com>
Date:   Fri, 16 Sep 2022 14:33:23 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <vladimir.oltean@nxp.com>,
        <grygorii.strashko@ti.com>, <vigneshr@ti.com>, <nsekhar@ti.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kishon@ti.com>,
        <s-vadapalli@ti.com>
Subject: Re: [PATCH 5/8] net: ethernet: ti: am65-cpsw: Add support for
 fixed-link configuration
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
References: <20220914095053.189851-1-s-vadapalli@ti.com>
 <20220914095053.189851-6-s-vadapalli@ti.com>
 <YyH8us424n3dyLYT@shell.armlinux.org.uk>
 <ab683d52-d469-35cf-b3b5-50c9edfc173b@ti.com>
 <YyL5WyA74/QRe/Y4@shell.armlinux.org.uk>
 <c76fdb7a-a95f-53c6-6e0e-d9283dd2de2d@ti.com>
 <YyQjqU7O5WRfrush@shell.armlinux.org.uk>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <YyQjqU7O5WRfrush@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Russell,

On 16/09/22 12:50, Russell King (Oracle) wrote:
> On Fri, Sep 16, 2022 at 10:24:48AM +0530, Siddharth Vadapalli wrote:
>> On 15/09/22 15:37, Russell King (Oracle) wrote:
>>> Hi,
>>>
>>> On Thu, Sep 15, 2022 at 02:58:52PM +0530, Siddharth Vadapalli wrote:
>>>> Hello Russell,
>>>>
>>>> On 14/09/22 21:39, Russell King (Oracle) wrote:
>>>>> On Wed, Sep 14, 2022 at 03:20:50PM +0530, Siddharth Vadapalli wrote:
>>>>>> Check for fixed-link in am65_cpsw_nuss_mac_config() using struct
>>>>>> am65_cpsw_slave_data's phy_node property to obtain fwnode. Since
>>>>>> am65_cpsw_nuss_mac_link_up() is not invoked in fixed-link mode, perform
>>>>>> the relevant operations in am65_cpsw_nuss_mac_config() itself.
>>>>>
>>>>> Further to my other comments, you also fail to explain that, when in
>>>>> fixed-link SGMII mode, you _emulate_ being a PHY - which I deduce
>>>>> since you are sending the duplex setting and speed settings via the
>>>>> SGMII control word. Also, as SGMII was invented for a PHY to be able
>>>>> to communicate the media negotiation resolution to the MAC, SGMII
>>>>> defines that the PHY fills in the speed and duplex information in
>>>>> the control word to pass it to the MAC, and the MAC acknowledges this
>>>>> information. There is no need (and SGMII doesn't permit) the MAC to
>>>>> advertise what it's doing.
>>>>>
>>>>> Maybe this needs to be explained in the commit message?
>>>>
>>>> I had tested SGMII fixed-link mode using a bootstrapped ethernet layer-1
>>>> PHY. Based on your clarification in the previous mails that there is an
>>>> issue with the fixed-link mode which I need to debug, I assume that what
>>>> you are referring to here also happens to be a consequence of that.
>>>> Please let me know if I have misunderstood what you meant to convey.
>>>
>>> I think what you're saying is that you have this setup:
>>>
>>>   ethernet MAC <--SGMII link--> ethernet PHY <---> media
>>>
>>> which you are operating in fixed link mode?
>>
>> Yes, and the other end is connected to my PC's ethernet port.
>>
>>>
>>> From the SGMII specification: "This is achieved by using the Auto-
>>> Negotiation functionality defined in Clause 37 of the IEEE
>>> Specification 802.3z. Instead of the ability advertisement, the PHY
>>> sends the control information via its tx_config_Reg[15:0] as specified
>>> in Table 1 whenever the control information changes. Upon receiving
>>> control information, the MAC acknowledges the update of the control
>>> information by asserting bit 14 of its tx_config_reg{15:0] as specified
>>> in Table 1."
>>>
>>> For the control word sent from the MAC to the PHY, table 1 specifies a
>>> value of 0x4001. All the zero bits in that word which are zero are
>>> marked as "Reserved for future use." There are no fields for speed and
>>> duplex in this acknowledgement word to the PHY.
>>>
>>> I hope this clears up my point.
>>
>> Thank you for the detailed explanation. After reading the above, my
>> understanding is that even in the fixed-link mode, the ethernet MAC is
>> not supposed to advertise the speed and duplex settings. The ethernet
>> MACs present on both ends of the connection are supposed to be set to
>> the same speed and duplex settings via the devicetree node. Thus, only
>> for my setup which happens to be a special case of fixed-link mode where
>> the ethernet PHY is present, I am having to send the control word due to
>> the presence of a PHY in between.
> 
> In SGMII, the control word is only passed between the ethernet MAC and
> the ethernet PHY. It is not conveyed across the media.
> 
>> And, I am supposed to mention this in
>> the commit message, which I haven't done. Please let me know if this is
>> what I was supposed to understand.
> 
> If you implement this conventionally, then you don't need to mention it
> in the commit message, because you're following the standard.
> 
>> I am planning to change to a proper fixed-link setup without any
>> ethernet PHY between the MACs, for debugging the driver's fixed-link
>> mode where the "mac_link_up()" is not invoked.
> 
> SGMII is designed for the setup in the diagram I provided in my previous
> email. It is not designed for two MACs to talk direct to each other
> without any ethernet PHY because of the asymmetric nature of the control
> word.
> 
> The PHY sends e.g. a control word of 0x9801 for 1G full duplex. On
> reception of that, the MAC responds with 0x4001. Finally, the PHY
> responds with 0xd801 to acknowledge the receipt of the MAC response.
> 
> If both ends of the link are SGMII, both ends will be waiting for
> the control word from a PHY which is not present, and the link will
> not come up.
> 
> 1000base-X is a symmetric protocol where both ends of the link
> advertise their capabilities, acknowledge each others abilities and
> resolve the duplex and pause settings.
> 
> SGMII is a Cisco proprietary modification of 1000base-X designed for
> communicating the results of media autonegotiation between an
> ethernet PHY and ethernet MAC.


I will try to implement and test SGMII mode in the conventional way with
both the MAC and the PHY present. If I am unable to do so, I will revert
to the current set of patches for the special case where the MAC
emulates a PHY, and mention this setup in the commit message of the v2
series. I hope this approach would be fine to proceed with. Please let
me know in case of any suggestions.

Regards,
Siddharth.
