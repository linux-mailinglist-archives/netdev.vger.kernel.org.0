Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E645F5BE620
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 14:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbiITMnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 08:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiITMng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 08:43:36 -0400
Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8530975CC7;
        Tue, 20 Sep 2022 05:43:32 -0700 (PDT)
Received: from [192.168.1.103] (31.173.87.161) by msexch01.omp.ru
 (10.188.4.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.14; Tue, 20 Sep
 2022 15:43:22 +0300
Subject: Re: [PATCH] net: ravb: Fix PHY state warning splat during system
 resume
To:     Geert Uytterhoeven <geert@linux-m68k.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <8ec796f47620980fdd0403e21bd8b7200b4fa1d4.1663598796.git.geert+renesas@glider.be>
 <00e5b86b-fe51-98c9-92b7-349b6a03fc1b@omp.ru>
 <CAMuHMdX7tn4EgG5YCN8FZTmY3+42zLGAxoUnCt5GNk24Hs+c5w@mail.gmail.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <93dba3e6-4aed-ff1a-8e78-f38661b0d636@omp.ru>
Date:   Tue, 20 Sep 2022 15:43:22 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAMuHMdX7tn4EgG5YCN8FZTmY3+42zLGAxoUnCt5GNk24Hs+c5w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [31.173.87.161]
X-ClientProxiedBy: msexch01.omp.ru (10.188.4.12) To msexch01.omp.ru
 (10.188.4.12)
X-KSE-ServerInfo: msexch01.omp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 09/20/2022 12:17:32
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 59
X-KSE-AntiSpam-Info: Lua profiles 172809 [Sep 20 2022]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: s.shtylyov@omp.ru
X-KSE-AntiSpam-Info: LuaCore: 499 499 6614d57ea7c6ac2e38ef0272e2cc77f73b9aae18
X-KSE-AntiSpam-Info: {rep_avail}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: {relay has no DNS name}
X-KSE-AntiSpam-Info: {SMTP from is not routable}
X-KSE-AntiSpam-Info: {Found in DNSBL: 31.173.87.161 in (user)
 b.barracudacentral.org}
X-KSE-AntiSpam-Info: {Found in DNSBL: 31.173.87.161 in (user)
 dbl.spamhaus.org}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;31.173.87.161:7.1.2;omp.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: ApMailHostAddress: 31.173.87.161
X-KSE-AntiSpam-Info: {DNS response errors}
X-KSE-AntiSpam-Info: Rate: 59
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dmarc=temperror header.from=omp.ru;spf=temperror
 smtp.mailfrom=omp.ru;dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 09/20/2022 12:21:00
X-KSE-AttachmentFiltering-Interceptor-Info: protection disabled
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 9/20/2022 10:54:00 AM
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/20/22 10:07 AM, Geert Uytterhoeven wrote:

[...]
>>> Since commit 744d23c71af39c7d ("net: phy: Warn about incorrect
>>> mdio_bus_phy_resume() state"), a warning splat is printed during system
>>> resume with Wake-on-LAN disabled:
>>>
>>>         WARNING: CPU: 0 PID: 1197 at drivers/net/phy/phy_device.c:323 mdio_bus_phy_resume+0xbc/0xc8
>>>
>>> As the Renesas Ethernet AVB driver already calls phy_{stop,start}() in
>>> its suspend/resume callbacks, it is sufficient to just mark the MAC
>>> responsible for managing the power state of the PHY.
>>>
>>> Fixes: fba863b816049b03 ("net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM")
>>> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>>
>> Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
> 
> Thanks for your review!

   My duty! :-)

>>> --- a/drivers/net/ethernet/renesas/ravb_main.c
>>> +++ b/drivers/net/ethernet/renesas/ravb_main.c
>>> @@ -1449,6 +1449,8 @@ static int ravb_phy_init(struct net_device *ndev)
>>>               phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);
>>>       }
>>>
>>> +     /* Indicate that the MAC is responsible for managing PHY PM */
>>> +     phydev->mac_managed_pm = true;
>>
>>    Hm, this field is declared as *unsigned*...
> 
> True, I copied this from drivers/net/ethernet/broadcom/genet/bcmmii.c.
> But true/false are fully compatible with single-bit values.

   Yes, however these 2 drivers do use 1 for setting the single bit fields...

> The linuxdoc suggests to use true, like for all other single-bit fields used
> as booleans:
> 
> include/linux/phy.h: * @mac_managed_pm: Set true if MAC driver takes

   Hah, here's the error I noticed: missing "care " here! :-)

> of suspending/resuming PHY
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
[...]

MBR, Sergey
