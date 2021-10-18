Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D6B43265D
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 20:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbhJRScQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 14:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbhJRScP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 14:32:15 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A865C06161C;
        Mon, 18 Oct 2021 11:30:04 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id oa4so12830438pjb.2;
        Mon, 18 Oct 2021 11:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pk4Bd9uLLzoMSVpNB0areexeJVu9IABjllvoFhI7Png=;
        b=jjmLPzyU4A+IfVHF+oqbSThYtvZqj0uGseuQsM2x0UdDv6R9nf7y24Ftzciy3riM7Q
         ARX7FdVpiQDuQXfwvhyHOnqWqNwY9cvKvOv72PR5oudMvuEv8JfCl+E6zYIHxelRMr+G
         sGpEm9svn8cVDMIBMwwv+bXBL5lZ9FvLgr7Hu/+O3HHB8W93FWkVtga4/TNiEUW19CCZ
         TAp6WsDviX+N9jXgW1TRzM5Ot5WxC93pP+1wWL45yZpi47xcJ9Bqt1vkdHeFeSqkQA0C
         rbT3thQoogBDUZjbvVDPowb3erp/CDsiRdBSX1PET1z05V+MHiSq3xZMm6ByPlbl8WJT
         cNgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pk4Bd9uLLzoMSVpNB0areexeJVu9IABjllvoFhI7Png=;
        b=7KymDy0kxGgiorY4PwPI3y4ujBvwv1TtCbTiYB9pvhSZUXBwUQqpWcLPGzzxwX2nWe
         0d1s5IIb5kPvPIbW743lgRCr1tcL9iUrQiRjBIwLZ51B1Og1faU+WsS4XJLwHlNVRJg7
         tEOs65palzsblDPHXgpwZjm9ILpZpft9v7c9a57PwqcLU4MlWtToNjYjsiT//Vf7JIkH
         YouqEB8UiLxKHR5MmKhyxtp3hMP5/2USAdJ7Hr0zKT2fKSzgGhRxumVSKzG9gxW9QMyj
         O3Z9/+6nhehReKw7ciVjOAF9qxwJIMo8+Mo5k+duayJTiZLzSf64Rd1fjM9qi5Rhdg70
         AGNw==
X-Gm-Message-State: AOAM533Zunp2xvKRjMz7dXHIbnACx+WV/boUqeOSC3z3oToyzUOwrjuJ
        dMzc3EFcisOd2oDssKSQD8A=
X-Google-Smtp-Source: ABdhPJzeV0Wn5lVmtZnpPQWewoCB0jnhcoCUXiw+MRGUYpNqU4y+kI42BQrENJUzaVYZ5NAnzEjwwA==
X-Received: by 2002:a17:902:da8f:b0:13e:fcb9:2371 with SMTP id j15-20020a170902da8f00b0013efcb92371mr28680438plx.72.1634581803454;
        Mon, 18 Oct 2021 11:30:03 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id u4sm121542pjg.54.2021.10.18.11.30.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 11:30:03 -0700 (PDT)
Subject: Re: [PATCH net-next 9/9] net: sched: Remove Qdisc::running sequence
 counter
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20211016084910.4029084-1-bigeasy@linutronix.de>
 <20211016084910.4029084-10-bigeasy@linutronix.de>
 <1cdc197a-f9c8-34e4-b19c-132dbbbcafb5@gmail.com>
Message-ID: <d991d8a9-207d-e840-4167-39e58b3901cc@gmail.com>
Date:   Mon, 18 Oct 2021 11:30:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1cdc197a-f9c8-34e4-b19c-132dbbbcafb5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/18/21 10:23 AM, Eric Dumazet wrote:
> 
> 
> On 10/16/21 1:49 AM, Sebastian Andrzej Siewior wrote:
>> From: "Ahmed S. Darwish" <a.darwish@linutronix.de>
>>
>> The Qdisc::running sequence counter has two uses:
>>
>>   1. Reliably reading qdisc's tc statistics while the qdisc is running
>>      (a seqcount read/retry loop at gnet_stats_add_basic()).
>>
>>   2. As a flag, indicating whether the qdisc in question is running
>>      (without any retry loops).
>>
>> For the first usage, the Qdisc::running sequence counter write section,
>> qdisc_run_begin() => qdisc_run_end(), covers a much wider area than what
>> is actually needed: the raw qdisc's bstats update. A u64_stats sync
>> point was thus introduced (in previous commits) inside the bstats
>> structure itself. A local u64_stats write section is then started and
>> stopped for the bstats updates.
>>
>> Use that u64_stats sync point mechanism for the bstats read/retry loop
>> at gnet_stats_add_basic().
>>
>> For the second qdisc->running usage, a __QDISC_STATE_RUNNING bit flag,
>> accessed with atomic bitops, is sufficient. Using a bit flag instead of
>> a sequence counter at qdisc_run_begin/end() and qdisc_is_running() leads
>> to the SMP barriers implicitly added through raw_read_seqcount() and
>> write_seqcount_begin/end() getting removed. All call sites have been
>> surveyed though, and no required ordering was identified.
>>
>> Now that the qdisc->running sequence counter is no longer used, remove
>> it.
>>
>> Note, using u64_stats implies no sequence counter protection for 64-bit
>> architectures. This can lead to the qdisc tc statistics "packets" vs.
>> "bytes" values getting out of sync on rare occasions. The individual
>> values will still be valid.
>>
>> Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
>> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> 
> I see this has been merged this week end before we could test this thing during work days :/
> 
> Just add a rate estimator on a qdisc:
> 
> tc qd add dev lo root est 1sec 4sec pfifo
> 
> then :
> 
> [  140.824352] ------------[ cut here ]------------
> [  140.824361] WARNING: CPU: 15 PID: 0 at net/core/gen_stats.c:157 gnet_stats_add_basic+0x97/0xc0
> [  140.824378] Modules linked in: ipvlan bonding vfat fat w1_therm i2c_mux_pca954x i2c_mux ds2482 wire cdc_acm ehci_pci ehci_hcd bnx2x mdio xt_TCPMSS ip6table_mangle ip6_tables ipv6
> [  140.824413] CPU: 15 PID: 0 Comm: swapper/15 Not tainted 5.15.0-smp-DEV #73
> [  140.824415] Hardware name: Intel RML,PCH/Ibis_QC_18, BIOS 2.48.0 10/02/2019
> [  140.824417] RIP: 0010:gnet_stats_add_basic+0x97/0xc0
> [  140.824420] Code: 2c 38 4a 03 5c 38 08 48 c7 c6 68 15 51 a4 e8 60 00 c7 ff 44 39 e0 72 db 89 d8 eb 05 31 c0 45 31 ed 4d 01 2e 49 01 46 08 eb 17 <0f> 0b 4d 85 ff 75 96 48 8b 02 48 8b 4a 08 49 01 06 89 c8 49 01 46
> [  140.824432] RSP: 0018:ffff99415fbc5e08 EFLAGS: 00010206
> [  140.824434] RAX: 0000000080000100 RBX: ffff9939812f41d0 RCX: 0000000000000001
> [  140.824436] RDX: ffff99399705e0b0 RSI: 0000000000000000 RDI: ffff99415fbc5e40
> [  140.824438] RBP: ffff99415fbc5e30 R08: 0000000000000000 R09: 0000000000000000
> [  140.824440] R10: 0000000000000000 R11: ffffffffffffffff R12: ffff99415fbd7740
> [  140.824441] R13: dead000000000122 R14: ffff99415fbc5e40 R15: 0000000000000000
> [  140.824443] FS:  0000000000000000(0000) GS:ffff99415fbc0000(0000) knlGS:0000000000000000
> [  140.824445] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  140.824447] CR2: 000000000087fff0 CR3: 0000000f11610006 CR4: 00000000000606e0
> [  140.824449] Call Trace:
> [  140.824450]  <IRQ>
> [  140.824453]  ? local_bh_enable+0x20/0x20
> [  140.824457]  est_timer+0x5e/0x130
> [  140.824460]  call_timer_fn+0x2c/0x110
> [  140.824464]  expire_timers+0x4c/0xf0
> [  140.824467]  __run_timers+0x16f/0x1b0
> [  140.824470]  run_timer_softirq+0x1d/0x40
> [  140.824473]  __do_softirq+0x142/0x2a1
> [  140.824477]  irq_exit_rcu+0x6b/0xb0
> [  140.824480]  sysvec_apic_timer_interrupt+0x79/0x90
> [  140.824483]  </IRQ>
> [  140.824493]  asm_sysvec_apic_timer_interrupt+0x12/0x20
> [  140.824497] RIP: 0010:cpuidle_enter_state+0x19b/0x300
> [  140.824502] Code: ff 45 84 e4 74 20 48 c7 45 c8 00 00 00 00 9c 8f 45 c8 f7 45 c8 00 02 00 00 0f 85 e4 00 00 00 31 ff e8 c9 0d 88 ff fb 8b 45 bc <85> c0 78 52 48 89 de 89 c3 48 6b d3 68 48 8b 4c 16 48 4c 2b 6d b0
> [  140.824503] RSP: 0018:ffff99398089be60 EFLAGS: 00000246
> [  140.824505] RAX: 0000000000000004 RBX: ffffffffa446cb28 RCX: 000000000000001f
> [  140.824506] RDX: 000000000000000f RSI: 0000000000000000 RDI: 0000000000000000
> [  140.824507] RBP: ffff99398089beb0 R08: 0000000000000002 R09: 00000020cf9326e4
> [  140.824508] R10: 0000000000638824 R11: 0000000000000000 R12: 0000000000000000
> [  140.824509] R13: 00000020c9c8d180 R14: ffffc4733fbe1c50 R15: 0000000000000004
> [  140.824511]  cpuidle_enter+0x2e/0x40
> [  140.824514]  do_idle+0x19f/0x240
> [  140.824517]  cpu_startup_entry+0x25/0x30
> [  140.824519]  start_secondary+0x7c/0x80
> [  140.824521]  secondary_startup_64_no_verify+0xc3/0xcb
> [  140.824525] ---[ end trace d64fa4b3dc94b292 ]---
> 
> 

Is it just me, or is net-next broken ?

Pinging the default gateway from idle host shows huge and variable delays.

Other hosts still using older kernels are just fine.

It looks we miss real qdisc_run() or something.

lpk43:~# ping6 fe80::1%eth0
PING fe80::1%eth0(fe80::1) 56 data bytes
64 bytes from fe80::1: icmp_seq=1 ttl=64 time=0.177 ms
64 bytes from fe80::1: icmp_seq=2 ttl=64 time=0.138 ms
64 bytes from fe80::1: icmp_seq=3 ttl=64 time=118 ms
64 bytes from fe80::1: icmp_seq=4 ttl=64 time=394 ms
64 bytes from fe80::1: icmp_seq=5 ttl=64 time=0.146 ms
64 bytes from fe80::1: icmp_seq=6 ttl=64 time=823 ms
64 bytes from fe80::1: icmp_seq=7 ttl=64 time=77.1 ms
64 bytes from fe80::1: icmp_seq=8 ttl=64 time=0.165 ms
64 bytes from fe80::1: icmp_seq=9 ttl=64 time=0.181 ms
64 bytes from fe80::1: icmp_seq=10 ttl=64 time=276 ms
64 bytes from fe80::1: icmp_seq=11 ttl=64 time=0.159 ms
64 bytes from fe80::1: icmp_seq=12 ttl=64 time=17.3 ms
64 bytes from fe80::1: icmp_seq=13 ttl=64 time=0.134 ms
64 bytes from fe80::1: icmp_seq=14 ttl=64 time=0.210 ms
64 bytes from fe80::1: icmp_seq=15 ttl=64 time=0.134 ms
64 bytes from fe80::1: icmp_seq=16 ttl=64 time=414 ms
64 bytes from fe80::1: icmp_seq=17 ttl=64 time=443 ms
64 bytes from fe80::1: icmp_seq=18 ttl=64 time=0.142 ms
64 bytes from fe80::1: icmp_seq=19 ttl=64 time=0.137 ms
64 bytes from fe80::1: icmp_seq=20 ttl=64 time=121 ms
64 bytes from fe80::1: icmp_seq=21 ttl=64 time=169 ms
^C
--- fe80::1%eth0 ping statistics ---
21 packets transmitted, 21 received, 0% packet loss, time 20300ms
rtt min/avg/max/mdev = 0.134/136.098/823.204/213.070 ms
