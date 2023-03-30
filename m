Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90A2D6D0C34
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 19:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbjC3RGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 13:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbjC3RGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 13:06:20 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6898C1BF3
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 10:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rXwsDwi7w6rIJnVkjZfZ79No3YslN+EGlDN/Gd+RGao=; b=dmR8hiniVzPFeVfzNl9grGhacl
        WISLNJ3w2KkQFjjPRXnfSXj9ZArcD9xXpaV0FW/AJHNB4tijo6J8K/ilDieZbP8yaPRAKyBDQCv8I
        afxS6hWAqyG0GGxniGZFC3z1MDHJYa5yPw/u+xPEojIihYqWdzGfn1uq3TYl4NPDidBs=;
Received: from p200300daa7147b005dccec29876cbc1f.dip0.t-ipconnect.de ([2003:da:a714:7b00:5dcc:ec29:876c:bc1f] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1phvj4-008abh-1k; Thu, 30 Mar 2023 19:06:14 +0200
Message-ID: <2e778829-d2a9-3606-3769-e50ab23836dc@nbd.name>
Date:   Thu, 30 Mar 2023 19:06:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: Aw: Re: Re: Re: Re: [PATCH net] net: ethernet: mtk_eth_soc: fix
 tx throughput regression with direct 1G links
Content-Language: en-US
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     netdev@vger.kernel.org, Daniel Golle <daniel@makrotopia.org>
References: <20230324140404.95745-1-nbd@nbd.name>
 <trinity-84b79570-2de7-496a-870e-a9678a55f4a4-1679736481816@3c-app-gmx-bap48>
 <2e7464a7-a020-f270-4bc7-c8ef47188dcd@nbd.name>
 <trinity-30bf2ced-ef19-4ce1-9738-07015a93dede-1679850603745@3c-app-gmx-bap64>
 <4a67ee73-f4ee-2099-1b5b-8d6b74acf429@nbd.name>
 <trinity-6b2ecbe5-7ad8-4740-b691-8b9868fae223-1679852966887@3c-app-gmx-bap64>
 <956879eb-a902-73dd-2574-1e6235571647@nbd.name>
 <trinity-79a1a243-0b80-402f-8c65-4bda591d6aa1-1679938094805@3c-app-gmx-bs30>
 <8bb00052-2e12-9767-27b9-f5a33a93fcc8@nbd.name>
 <trinity-283297c1-e5fc-4d90-9f4b-505ebf8c82cb-1680184695162@3c-app-gmx-bap58>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <trinity-283297c1-e5fc-4d90-9f4b-505ebf8c82cb-1680184695162@3c-app-gmx-bap58>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.03.23 15:58, Frank Wunderlich wrote:
> something ist still strange...i get a rcu stall again with this patch...reverted it and my r2 boots again.
> 
> [   29.772755] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
> [   29.778689] rcu:     2-...0: (1 GPs behind) idle=547c/1/0x40000000 softirq=251/258 fqs=427
> [   29.786697] rcu:     (detected by 1, t=2104 jiffies, g=-875, q=29 ncpus=4)
> [   29.793308] Sending NMI from CPU 1 to CPUs 2:
> [   34.492968] vusb: disabling
> [   34.495828] vmc: disabling
> [   34.498587] vmch: disabling
> [   34.501433] vgp1: disabling
> [   34.504426] vcamaf: disabling
> [   39.797579] rcu: rcu_sched kthread timer wakeup didn't happen for 994 jiffies! g-875 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402
> [   39.808619] rcu:     Possible timer handling issue on cpu=1 timer-softirq=493
> [   39.815487] rcu: rcu_sched kthread starved for 995 jiffies! g-875 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402 ->cpu=1
> [   39.825571] rcu:     Unless rcu_sched kthread gets sufficient CPU time, OOM is now expected behavior.
> [   39.834520] rcu: RCU grace-period kthread stack dump:
> [   39.839564] task:rcu_sched       state:I stack:0     pid:14    ppid:2      flags:0x00000000
> [   39.847928]  __schedule from schedule+0x54/0xe8
> [   39.852472]  schedule from schedule_timeout+0x94/0x158
> [   39.857619]  schedule_timeout from rcu_gp_fqs_loop+0x12c/0x50c
> [   39.863467]  rcu_gp_fqs_loop from rcu_gp_kthread+0x194/0x21c
> [   39.869135]  rcu_gp_kthread from kthread+0xc8/0xcc
> [   39.873931]  kthread from ret_from_fork+0x14/0x2c
> [   39.878639] Exception stack(0xf0859fb0 to 0xf0859ff8)
> [   39.883690] 9fa0:                                     00000000 00000000 00000000 00000000
> [   39.891864] 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [   39.900037] 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000
> [   39.906645] rcu: Stack dump where RCU GP kthread last ran:
> [   39.912125] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 6.3.0-rc1-bpi-r2-rc-net #2
> [   39.919518] Hardware name: Mediatek Cortex-A7 (Device Tree)
> [   39.925082] PC is at default_idle_call+0x1c/0xb0
> [   39.929698] LR is at ct_kernel_enter.constprop.0+0x48/0x11c
> [   39.935267] pc : [<c0d105ec>]    lr : [<c0d0ffa4>]    psr: 600e0013
> [   39.941527] sp : f0861fb0  ip : c15721e0  fp : 00000000
> [   39.946746] r10: 00000000  r9 : 410fc073  r8 : 8000406a
> [   39.951964] r7 : c1404f74  r6 : c19e0900  r5 : c15727e0  r4 : c19e0900
> [   39.958486] r3 : 00000000  r2 : 2da0a000  r1 : 00000001  r0 : 00008cfc
> [   39.965007] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
> [   39.972138] Control: 10c5387d  Table: 84f4806a  DAC: 00000051
> [   39.977878]  default_idle_call from cpuidle_idle_call+0x24/0x68
> [   39.983805]  cpuidle_idle_call from do_idle+0x9c/0xd0
> [   39.988863]  do_idle from cpu_startup_entry+0x20/0x24
> [   39.993921]  cpu_startup_entry from secondary_start_kernel+0x118/0x138
> [   40.000457]  secondary_start_kernel from 0x801017a0
> 
> maybe i need additional patch or did anything else wrong?
> 
> still working on 6.3-rc1
> https://github.com/frank-w/BPI-Router-Linux/commits/6.3-rc-net
Can you try applying this patch to a stable kernel instead? These hangs 
don't make any sense to me, especially the one triggered by an earlier 
patch that should definitely have been a no-op because of the wrong 
config symbol.
It really looks to me like you have an issue in that kernel triggered by 
spurious code changes.

- Felix

