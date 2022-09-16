Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25FF85BA9C4
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 11:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbiIPJ4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 05:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbiIPJ4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 05:56:07 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD4FA74D1;
        Fri, 16 Sep 2022 02:56:05 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 28G9tcQ3065273;
        Fri, 16 Sep 2022 04:55:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1663322138;
        bh=3UE0aBXJzijV4j63hDjBLnZQXGBaoaq9ZOB+7kpHIhc=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=wmhftObzH6kVA2WcpETW3INNxPYY+kGrYEUiuqvQjfBNTq4PBjHwiWRsfMgFB1Z7u
         4K5UxT+7kHfHFjuv/WK87GsDmPXkbh9EhVFxoscQbs2AIHY88rX8Ag2WKTYaDzXWm6
         HqRKjxYFdJuZh0MkwcAGeEpYRUvIbJhAieKmPW9U=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 28G9tcL2002869
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 16 Sep 2022 04:55:38 -0500
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Fri, 16
 Sep 2022 04:55:38 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Fri, 16 Sep 2022 04:55:38 -0500
Received: from [10.24.69.241] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 28G9tWld015902;
        Fri, 16 Sep 2022 04:55:33 -0500
Message-ID: <5be6de72-ba90-472e-7714-93940260b2ae@ti.com>
Date:   Fri, 16 Sep 2022 15:25:32 +0530
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
 <85398274-c0fb-6ef6-29b3-ad8d2465f8e4@ti.com>
 <YyQ+h4o9hqO+paUL@shell.armlinux.org.uk>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <YyQ+h4o9hqO+paUL@shell.armlinux.org.uk>
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

On 16/09/22 14:44, Russell King (Oracle) wrote:
> On Fri, Sep 16, 2022 at 02:33:23PM +0530, Siddharth Vadapalli wrote:
>> Hello Russell,
>>
>> On 16/09/22 12:50, Russell King (Oracle) wrote:
>>> SGMII is designed for the setup in the diagram I provided in my previous
>>> email. It is not designed for two MACs to talk direct to each other
>>> without any ethernet PHY because of the asymmetric nature of the control
>>> word.
>>>
>>> The PHY sends e.g. a control word of 0x9801 for 1G full duplex. On
>>> reception of that, the MAC responds with 0x4001. Finally, the PHY
>>> responds with 0xd801 to acknowledge the receipt of the MAC response.
>>>
>>> If both ends of the link are SGMII, both ends will be waiting for
>>> the control word from a PHY which is not present, and the link will
>>> not come up.
>>>
>>> 1000base-X is a symmetric protocol where both ends of the link
>>> advertise their capabilities, acknowledge each others abilities and
>>> resolve the duplex and pause settings.
>>>
>>> SGMII is a Cisco proprietary modification of 1000base-X designed for
>>> communicating the results of media autonegotiation between an
>>> ethernet PHY and ethernet MAC.
>>
>> I will try to implement and test SGMII mode in the conventional way with
>> both the MAC and the PHY present. If I am unable to do so, I will revert
>> to the current set of patches for the special case where the MAC
>> emulates a PHY, and mention this setup in the commit message of the v2
>> series. I hope this approach would be fine to proceed with. Please let
>> me know in case of any suggestions.
> 
> What exact setups are you trying to support with this patch set?
> 
> If you're looking to only add support for SGMII, then all you need
> to do is to make sure it works with a PHY. Fixed-link in SGMII only
> makes sense if you're directly connected to something like a network
> switch, but even then, network switches tend to use 1000base-X in a
> fixed-link mode rather than SGMII.

I plan to support the standard MAC2PHY based SGMII mode. However, the
SGMII ethernet PHY that I have with me has issues which is why I had
tried the unconventional fixed-link SGMII mode with the MAC emulating
the ethernet PHY. I will try to obtain a functional SGMII ethernet PHY
and test the standard SGMII mode.

Thank you for patiently answering my questions and helping me understand
the SGMII mode better :)

Regards,
Siddharth.
