Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE4A76C90D5
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 21:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbjCYU4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 16:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjCYU4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 16:56:20 -0400
Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B60A5CB;
        Sat, 25 Mar 2023 13:56:18 -0700 (PDT)
Received: from [192.168.1.103] (178.176.79.104) by msexch01.omp.ru
 (10.188.4.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.14; Sat, 25 Mar
 2023 23:56:10 +0300
Subject: Re: [PATCH net-next] sh_eth: remove open coded netif_running()
To:     Geert Uytterhoeven <geert@linux-m68k.org>
CC:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <linux-kernel@vger.kernel.org>
References: <20230321065826.2044-1-wsa+renesas@sang-engineering.com>
 <79d945a4-e105-4bc4-3e73-64971731660e@omp.ru>
 <CAMuHMdUt_kTH3tnrdF=oKBLyjrstei8PLsyr+dFXVoPEyxTLAA@mail.gmail.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <346b2451-6862-011e-9842-284a43fcf337@omp.ru>
Date:   Sat, 25 Mar 2023 23:56:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAMuHMdUt_kTH3tnrdF=oKBLyjrstei8PLsyr+dFXVoPEyxTLAA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [178.176.79.104]
X-ClientProxiedBy: msexch01.omp.ru (10.188.4.12) To msexch01.omp.ru
 (10.188.4.12)
X-KSE-ServerInfo: msexch01.omp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.59, Database issued on: 03/25/2023 20:40:46
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 59
X-KSE-AntiSpam-Info: Lua profiles 176289 [Mar 24 2023]
X-KSE-AntiSpam-Info: Version: 5.9.59.0
X-KSE-AntiSpam-Info: Envelope from: s.shtylyov@omp.ru
X-KSE-AntiSpam-Info: LuaCore: 507 507 08d345461d9bcca7095738422a5279ab257bb65a
X-KSE-AntiSpam-Info: {rep_avail}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: {relay has no DNS name}
X-KSE-AntiSpam-Info: {SMTP from is not routable}
X-KSE-AntiSpam-Info: {Found in DNSBL: 178.176.79.104 in (user)
 dbl.spamhaus.org}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;178.176.79.104:7.4.1,7.7.3;omp.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: {iprep_blacklist}
X-KSE-AntiSpam-Info: ApMailHostAddress: 178.176.79.104
X-KSE-AntiSpam-Info: {DNS response errors}
X-KSE-AntiSpam-Info: Rate: 59
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dmarc=temperror header.from=omp.ru;spf=temperror
 smtp.mailfrom=omp.ru;dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 03/25/2023 20:43:00
X-KSE-AttachmentFiltering-Interceptor-Info: protection disabled
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 3/25/2023 6:14:00 PM
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-Spam-Status: No, score=-0.0 required=5.0 tests=NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 3/23/23 11:32 AM, Geert Uytterhoeven wrote:
[...]
>>> It had a purpose back in the days, but today we have a handy helper.
>>
>>    Well, the is_opened flag doesn't get set/cleared at the same time as
>> __LINK_STATE_START. I'm not sure they are interchangeable...
>>
>>> Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
>>> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> 
>>> --- a/drivers/net/ethernet/renesas/sh_eth.c
>>> +++ b/drivers/net/ethernet/renesas/sh_eth.c
>>> @@ -2441,8 +2441,6 @@ static int sh_eth_open(struct net_device *ndev)
>>>
>>>       netif_start_queue(ndev);
>>>
>>> -     mdp->is_opened = 1;
>>> -
>>
>>    __LINK_STATE_START gets set before the ndo_open() method call, so
>> before the RPM call that enbales the clocks...
>>
>>>       return ret;
>>>
>>>  out_free_irq:
>>> @@ -2565,7 +2563,7 @@ static struct net_device_stats *sh_eth_get_stats(struct net_device *ndev)
>>>       if (mdp->cd->no_tx_cntrs)
>>>               return &ndev->stats;
>>>
>>> -     if (!mdp->is_opened)
>>> +     if (!netif_running(ndev))
>>>               return &ndev->stats;
>>
>>    I guess mdp->is_opened is checked here to avoid reading the counter
>> regs when RPM hasn't been called yet to enable the clocks...
> 
> Exactly, cfr. commit 7fa2955ff70ce453 ("sh_eth: Fix sleeping function
> called from invalid context").

   Yeah, pm_runtime_get_sync() couldn't be called in this case as
netstat_show() invoked read_lock() that ensued calling preempt_disable()...

> So you mean sh_eth_get_stats() can now be called after setting
> __LINK_STATE_START, but before RPM has enabled the clocks?

   Yes, probably...

> Is there some protection against parallel execution of ndo_open()
> and get_stats()?

   Haven't seen it (yet?)...

> Gr{oetje,eeting}s,
> 
>                         Geert

MBR, Sergey
