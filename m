Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD1064DEE0
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 17:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbiLOQn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 11:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbiLOQn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 11:43:57 -0500
Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1435331EF4;
        Thu, 15 Dec 2022 08:43:54 -0800 (PST)
Received: from [192.168.1.103] (178.176.74.151) by msexch01.omp.ru
 (10.188.4.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.14; Thu, 15 Dec
 2022 19:43:43 +0300
Subject: Re: [PATCH net v2] ravb: Fix "failed to switch device to config mode"
 message during unbind
To:     <patchwork-bot+netdevbpf@kernel.org>,
        Biju Das <biju.das.jz@bp.renesas.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <p.zabel@pengutronix.de>,
        <geert+renesas@glider.be>, <liuhangbin@gmail.com>,
        <mitsuhiro.kimura.kc@renesas.com>, <netdev@vger.kernel.org>,
        <linux-renesas-soc@vger.kernel.org>,
        <fabrizio.castro.jz@renesas.com>, <stable@vger.kernel.org>,
        <leonro@nvidia.com>
References: <20221214105118.2495313-1-biju.das.jz@bp.renesas.com>
 <167111521604.32410.3850134562584373463.git-patchwork-notify@kernel.org>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <b9afb491-73a9-5ffb-bef7-4f29dda6efe0@omp.ru>
Date:   Thu, 15 Dec 2022 19:43:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <167111521604.32410.3850134562584373463.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [178.176.74.151]
X-ClientProxiedBy: msexch01.omp.ru (10.188.4.12) To msexch01.omp.ru
 (10.188.4.12)
X-KSE-ServerInfo: msexch01.omp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.59, Database issued on: 12/15/2022 16:24:15
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 59
X-KSE-AntiSpam-Info: Lua profiles 174213 [Dec 15 2022]
X-KSE-AntiSpam-Info: Version: 5.9.59.0
X-KSE-AntiSpam-Info: Envelope from: s.shtylyov@omp.ru
X-KSE-AntiSpam-Info: LuaCore: 502 502 69dee8ef46717dd3cb3eeb129cb7cc8dab9e30f6
X-KSE-AntiSpam-Info: {rep_avail}
X-KSE-AntiSpam-Info: {Tracking_arrow_text}
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: {relay has no DNS name}
X-KSE-AntiSpam-Info: {SMTP from is not routable}
X-KSE-AntiSpam-Info: {Found in DNSBL: 178.176.74.151 in (user)
 b.barracudacentral.org}
X-KSE-AntiSpam-Info: git.kernel.org:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;omp.ru:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: ApMailHostAddress: 178.176.74.151
X-KSE-AntiSpam-Info: {DNS response errors}
X-KSE-AntiSpam-Info: Rate: 59
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dmarc=temperror header.from=omp.ru;spf=temperror
 smtp.mailfrom=omp.ru;dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 12/15/2022 16:27:00
X-KSE-AttachmentFiltering-Interceptor-Info: protection disabled
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 12/15/2022 10:28:00 AM
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/15/22 5:40 PM, patchwork-bot+netdevbpf@kernel.org wrote:

> Hello:
> 
> This patch was applied to netdev/net.git (master)
> by Paolo Abeni <pabeni@redhat.com>:
> 
> On Wed, 14 Dec 2022 10:51:18 +0000 you wrote:
>> This patch fixes the error "ravb 11c20000.ethernet eth0: failed to switch
>> device to config mode" during unbind.
>>
>> We are doing register access after pm_runtime_put_sync().
>>
>> We usually do cleanup in reverse order of init. Currently in
>> remove(), the "pm_runtime_put_sync" is not in reverse order.
>>
>> [...]
> 
> Here is the summary with links:
>   - [net,v2] ravb: Fix "failed to switch device to config mode" message during unbind
>     https://git.kernel.org/netdev/net/c/c72a7e42592b
> 
> You are awesome, thank you!

   Oops, was going to review the patch tonight, now that I'm back from the hospitals.

MBR, Sergey
