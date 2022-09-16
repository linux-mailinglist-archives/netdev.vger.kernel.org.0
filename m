Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6FDB5BA621
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 06:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiIPEzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 00:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiIPEzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 00:55:21 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF58B6A4B1;
        Thu, 15 Sep 2022 21:55:19 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 28G4ssqA060056;
        Thu, 15 Sep 2022 23:54:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1663304094;
        bh=DhgXN/2x1D5jdbzbm9/WulTVv5Ky25v+z/2Qoh7HaAQ=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=kc56b1znp3iRWDdvyMyUFqCPpR9Bq2ZrDX9vEnPx0d/XbDU+TUp1q7hurCLF8S5P/
         jxtvMBXb/xq4FIBAIO/Nq071EHDNUxPdQWv2pbWrU4K0gExmyIzSQAquOmiFEaKElg
         GfkXm2c3Q1iDwsKU4yNfT4YUp7a9Lk1rYOm84rIE=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 28G4ssCe065132
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Sep 2022 23:54:54 -0500
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Thu, 15
 Sep 2022 23:54:54 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Thu, 15 Sep 2022 23:54:54 -0500
Received: from [10.24.69.241] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 28G4smf0018522;
        Thu, 15 Sep 2022 23:54:49 -0500
Message-ID: <c76fdb7a-a95f-53c6-6e0e-d9283dd2de2d@ti.com>
Date:   Fri, 16 Sep 2022 10:24:48 +0530
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
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <YyL5WyA74/QRe/Y4@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Russell,

On 15/09/22 15:37, Russell King (Oracle) wrote:
> Hi,
> 
> On Thu, Sep 15, 2022 at 02:58:52PM +0530, Siddharth Vadapalli wrote:
>> Hello Russell,
>>
>> On 14/09/22 21:39, Russell King (Oracle) wrote:
>>> On Wed, Sep 14, 2022 at 03:20:50PM +0530, Siddharth Vadapalli wrote:
>>>> Check for fixed-link in am65_cpsw_nuss_mac_config() using struct
>>>> am65_cpsw_slave_data's phy_node property to obtain fwnode. Since
>>>> am65_cpsw_nuss_mac_link_up() is not invoked in fixed-link mode, perform
>>>> the relevant operations in am65_cpsw_nuss_mac_config() itself.
>>>
>>> Further to my other comments, you also fail to explain that, when in
>>> fixed-link SGMII mode, you _emulate_ being a PHY - which I deduce
>>> since you are sending the duplex setting and speed settings via the
>>> SGMII control word. Also, as SGMII was invented for a PHY to be able
>>> to communicate the media negotiation resolution to the MAC, SGMII
>>> defines that the PHY fills in the speed and duplex information in
>>> the control word to pass it to the MAC, and the MAC acknowledges this
>>> information. There is no need (and SGMII doesn't permit) the MAC to
>>> advertise what it's doing.
>>>
>>> Maybe this needs to be explained in the commit message?
>>
>> I had tested SGMII fixed-link mode using a bootstrapped ethernet layer-1
>> PHY. Based on your clarification in the previous mails that there is an
>> issue with the fixed-link mode which I need to debug, I assume that what
>> you are referring to here also happens to be a consequence of that.
>> Please let me know if I have misunderstood what you meant to convey.
> 
> I think what you're saying is that you have this setup:
> 
>   ethernet MAC <--SGMII link--> ethernet PHY <---> media
> 
> which you are operating in fixed link mode?

Yes, and the other end is connected to my PC's ethernet port.

> 
> From the SGMII specification: "This is achieved by using the Auto-
> Negotiation functionality defined in Clause 37 of the IEEE
> Specification 802.3z. Instead of the ability advertisement, the PHY
> sends the control information via its tx_config_Reg[15:0] as specified
> in Table 1 whenever the control information changes. Upon receiving
> control information, the MAC acknowledges the update of the control
> information by asserting bit 14 of its tx_config_reg{15:0] as specified
> in Table 1."
> 
> For the control word sent from the MAC to the PHY, table 1 specifies a
> value of 0x4001. All the zero bits in that word which are zero are
> marked as "Reserved for future use." There are no fields for speed and
> duplex in this acknowledgement word to the PHY.
> 
> I hope this clears up my point.

Thank you for the detailed explanation. After reading the above, my
understanding is that even in the fixed-link mode, the ethernet MAC is
not supposed to advertise the speed and duplex settings. The ethernet
MACs present on both ends of the connection are supposed to be set to
the same speed and duplex settings via the devicetree node. Thus, only
for my setup which happens to be a special case of fixed-link mode where
the ethernet PHY is present, I am having to send the control word due to
the presence of a PHY in between. And, I am supposed to mention this in
the commit message, which I haven't done. Please let me know if this is
what I was supposed to understand.

I am planning to change to a proper fixed-link setup without any
ethernet PHY between the MACs, for debugging the driver's fixed-link
mode where the "mac_link_up()" is not invoked. Additionally, with this
new setup, my MAC will not have to emulate being an ethernet PHY,
thereby making my patch cleaner in the process. The v2 series will be
based on the new setup. I hope that this is fine.

Regards,
Siddharth.
