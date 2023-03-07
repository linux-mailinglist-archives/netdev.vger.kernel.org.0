Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7DE96AD448
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 02:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjCGBux convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 6 Mar 2023 20:50:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjCGBuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 20:50:52 -0500
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3685E3B3F7;
        Mon,  6 Mar 2023 17:50:50 -0800 (PST)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by fd01.gateway.ufhost.com (Postfix) with ESMTP id 01C8D24E154;
        Tue,  7 Mar 2023 09:50:49 +0800 (CST)
Received: from EXMBX162.cuchost.com (172.16.6.72) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 7 Mar
 2023 09:50:48 +0800
Received: from [192.168.120.42] (171.223.208.138) by EXMBX162.cuchost.com
 (172.16.6.72) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 7 Mar
 2023 09:50:47 +0800
Message-ID: <b02466fa-9c9d-3d8a-9112-2b52f14460d7@starfivetech.com>
Date:   Tue, 7 Mar 2023 09:50:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v5 08/12] net: stmmac: starfive_dmac: Add phy interface
 settings
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Emil Renner Berthing <emil.renner.berthing@canonical.com>
CC:     <linux-riscv@lists.infradead.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
References: <20230303085928.4535-1-samin.guo@starfivetech.com>
 <20230303085928.4535-9-samin.guo@starfivetech.com>
 <CAJM55Z-3CCY8xx81Qr9UqSSQ+gOer3XXJzOvnAe7yyESk23pQw@mail.gmail.com>
 <bc79afab-17d1-8789-3325-8e6d62123dce@starfivetech.com>
 <CAJM55Z8zYUQc33r9tJB1du-FSp+uDf40720taMuGTuPcPU+aZg@mail.gmail.com>
 <52822ce5-0712-48e5-81e0-c6ac09d6a6ee@lunn.ch>
From:   Guo Samin <samin.guo@starfivetech.com>
In-Reply-To: <52822ce5-0712-48e5-81e0-c6ac09d6a6ee@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS061.cuchost.com (172.16.6.21) To EXMBX162.cuchost.com
 (172.16.6.72)
X-YovoleRuleAgent: yovoleflag
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2023/3/6 21:06:20, Andrew Lunn 写道:
>> Ugh, you're right. Both the syscon block, the register offset and the
>> bit position in those registers are different from gmac0 to gmac1, and
>> since we need a phandle to the syscon block anyway passing those two
>> other parameters as arguments is probably the nicest solution. For the
>> next version I'd change the 2nd argument from mask to the bit position
>> though. It seems the field is always 3 bits wide and this makes it a
>> little clearer that we're not just putting register values in the
>> device tree.
> 
> I prefer bit position over mask.
> 
> But please fully document this in the device tree. This is something a
> board developer is going to get wrong, because they assume MAC blocks
> are identical, and normally need identical configuration.
> 
> I assume this is also a hardware 'bug', and the next generation of the
> silicon will have this fixed? So this will go away?
> 
> 	Andrew


Hi Andrew, Yes, the hardware design does not take into account the feasibility of the software.
The next version will be fixed. Thank you. 
I will use bit position instead of mask, which is described in detail in the document.

Best regards,
Samin

-- 
Best regards,
Samin
