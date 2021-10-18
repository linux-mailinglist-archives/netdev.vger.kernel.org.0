Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C5A432786
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 21:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbhJRT1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 15:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbhJRT1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 15:27:13 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47678C06161C;
        Mon, 18 Oct 2021 12:25:02 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id i5so5738253pla.5;
        Mon, 18 Oct 2021 12:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Drs89GFgspu8i4Uc+iYNMuN22dvP7BlrsfI6iK2TGR8=;
        b=FmEVucq9zag99yad9Plh9sIC2y8GbQUOZB0lvv+0eLleyi4yaJrrJ9J0Nteyy20LYs
         qQcby3tNuSrSJRxWwTucZL+lz8aWw/SAo8e7jGB/3zXwLg7aYgo+VeZtOI0vBNlVgDSp
         3eZbXLckcNwYe2q6HrG646/wULOUMUl2DK105L9dkoZ76RCGGhI4U08KNtbn3q+H1N1s
         TD/wFiJCCpGi4WF1drHO6lOFQlc3NML72UtCFGyaFJjP6SpEtHO+0c29Vnl+ELJTCFNv
         jkspY8OHkv12WIROTPXoxlNIa4+V/Bes9+lKyZPDGDKToRnhriHZ0Pm0HKlfHLqZ39U5
         kq/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Drs89GFgspu8i4Uc+iYNMuN22dvP7BlrsfI6iK2TGR8=;
        b=RHoZyld4ak1Gp82ZfXgpWSUvsMVBUPx5+d7EHrX04UV+aL6wmBGWXkynPNDjrVDfQg
         iWYFmVEP5pe582S0tk/Mc7VIGj3GSfjioJKQHKMjZcStOn3/BuoSOfP1RM01cKbZ/pOw
         y9ygtk2HNtPMy8sU8wKummn/lgl6Rn77R9/nhgn9CBz44g6/K7oK7AWQ6GkrMZqUkAPg
         uaS+rT50UE4motJJ7RXcGMrY9Rfyis2IHSn1nquUE2JNiAJgT5c9muSuxUuGSfn/r+Ai
         ZVds2esJ9x1zbzxnw7irgh7Zf0h61VCetNSxoPBiMLBq6m6P/xBpwsNstgKrZAuAdNJ/
         GO/Q==
X-Gm-Message-State: AOAM533PcN8msyQLt6xCsKtKwgKYODruy6Vbgsrx8HA576w9sFxhdrwo
        A3l8Waq198/g1ZMWuHb2JRQ=
X-Google-Smtp-Source: ABdhPJz8QNhL7opuGZSO/REXJsu2rXOCzD/T3fCclKzhIh1RCS+2zompcdkVv8bgVvZk3O0jPNB/dA==
X-Received: by 2002:a17:90b:4d0b:: with SMTP id mw11mr919783pjb.135.1634585101698;
        Mon, 18 Oct 2021 12:25:01 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id s7sm14687376pfu.139.2021.10.18.12.25.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 12:25:01 -0700 (PDT)
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
 <d991d8a9-207d-e840-4167-39e58b3901cc@gmail.com>
Message-ID: <e2b59e47-8276-2c14-3102-15ec0c76c719@gmail.com>
Date:   Mon, 18 Oct 2021 12:24:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <d991d8a9-207d-e840-4167-39e58b3901cc@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/18/21 11:30 AM, Eric Dumazet wrote:
> 
> 
> On 10/18/21 10:23 AM, Eric Dumazet wrote:
>>
>>
>> On 10/16/21 1:49 AM, Sebastian Andrzej Siewior wrote:
>>> From: "Ahmed S. Darwish" <a.darwish@linutronix.de>
>>>
>>> The Qdisc::running sequence counter has two uses:
>>>
>>>   1. Reliably reading qdisc's tc statistics while the qdisc is running
>>>      (a seqcount read/retry loop at gnet_stats_add_basic()).
>>>
>>>   2. As a flag, indicating whether the qdisc in question is running
>>>      (without any retry loops).
>>>
>>> For the first usage, the Qdisc::running sequence counter write section,
>>> qdisc_run_begin() => qdisc_run_end(), covers a much wider area than what
>>> is actually needed: the raw qdisc's bstats update. A u64_stats sync
>>> point was thus introduced (in previous commits) inside the bstats
>>> structure itself. A local u64_stats write section is then started and
>>> stopped for the bstats updates.
>>>
>>> Use that u64_stats sync point mechanism for the bstats read/retry loop
>>> at gnet_stats_add_basic().
>>>
>>> For the second qdisc->running usage, a __QDISC_STATE_RUNNING bit flag,
>>> accessed with atomic bitops, is sufficient. Using a bit flag instead of
>>> a sequence counter at qdisc_run_begin/end() and qdisc_is_running() leads
>>> to the SMP barriers implicitly added through raw_read_seqcount() and
>>> write_seqcount_begin/end() getting removed. All call sites have been
>>> surveyed though, and no required ordering was identified.
>>>
>>> Now that the qdisc->running sequence counter is no longer used, remove
>>> it.
>>>
>>> Note, using u64_stats implies no sequence counter protection for 64-bit
>>> architectures. This can lead to the qdisc tc statistics "packets" vs.
>>> "bytes" values getting out of sync on rare occasions. The individual
>>> values will still be valid.
>>>
>>> Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
>>> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>>
>>
>> I see this has been merged this week end before we could test this thing during work days :/
>>
>> Just add a rate estimator on a qdisc:
>>
>> tc qd add dev lo root est 1sec 4sec pfifo
>>
>> then :
>>
>> [  140.824352] ------------[ cut here ]------------
>> [  140.824361] WARNING: CPU: 15 PID: 0 at net/core/gen_stats.c:157 gnet_stats_add_basic+0x97/0xc0
>> [  140.824378] Modules linked in: ipvlan bonding vfat fat w1_therm i2c_mux_pca954x i2c_mux ds2482 wire cdc_acm ehci_pci ehci_hcd bnx2x mdio xt_TCPMSS ip6table_mangle ip6_tables ipv6
>> [  140.824413] CPU: 15 PID: 0 Comm: swapper/15 Not tainted 5.15.0-smp-DEV #73
>> [  140.824415] Hardware name: Intel RML,PCH/Ibis_QC_18, BIOS 2.48.0 10/02/2019
>> [  140.824417] RIP: 0010:gnet_stats_add_basic+0x97/0xc0
>> [  140.824420] Code: 2c 38 4a 03 5c 38 08 48 c7 c6 68 15 51 a4 e8 60 00 c7 ff 44 39 e0 72 db 89 d8 eb 05 31 c0 45 31 ed 4d 01 2e 49 01 46 08 eb 17 <0f> 0b 4d 85 ff 75 96 48 8b 02 48 8b 4a 08 49 01 06 89 c8 49 01 46
>> [  140.824432] RSP: 0018:ffff99415fbc5e08 EFLAGS: 00010206
>> [  140.824434] RAX: 0000000080000100 RBX: ffff9939812f41d0 RCX: 0000000000000001
>> [  140.824436] RDX: ffff99399705e0b0 RSI: 0000000000000000 RDI: ffff99415fbc5e40
>> [  140.824438] RBP: ffff99415fbc5e30 R08: 0000000000000000 R09: 0000000000000000
>> [  140.824440] R10: 0000000000000000 R11: ffffffffffffffff R12: ffff99415fbd7740
>> [  140.824441] R13: dead000000000122 R14: ffff99415fbc5e40 R15: 0000000000000000
>> [  140.824443] FS:  0000000000000000(0000) GS:ffff99415fbc0000(0000) knlGS:0000000000000000
>> [  140.824445] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  140.824447] CR2: 000000000087fff0 CR3: 0000000f11610006 CR4: 00000000000606e0
>> [  140.824449] Call Trace:
>> [  140.824450]  <IRQ>
>> [  140.824453]  ? local_bh_enable+0x20/0x20
>> [  140.824457]  est_timer+0x5e/0x130
>> [  140.824460]  call_timer_fn+0x2c/0x110
>> [  140.824464]  expire_timers+0x4c/0xf0
>> [  140.824467]  __run_timers+0x16f/0x1b0
>> [  140.824470]  run_timer_softirq+0x1d/0x40
>> [  140.824473]  __do_softirq+0x142/0x2a1
>> [  140.824477]  irq_exit_rcu+0x6b/0xb0
>> [  140.824480]  sysvec_apic_timer_interrupt+0x79/0x90
>> [  140.824483]  </IRQ>
>> [  140.824493]  asm_sysvec_apic_timer_interrupt+0x12/0x20
>> [  140.824497] RIP: 0010:cpuidle_enter_state+0x19b/0x300
>> [  140.824502] Code: ff 45 84 e4 74 20 48 c7 45 c8 00 00 00 00 9c 8f 45 c8 f7 45 c8 00 02 00 00 0f 85 e4 00 00 00 31 ff e8 c9 0d 88 ff fb 8b 45 bc <85> c0 78 52 48 89 de 89 c3 48 6b d3 68 48 8b 4c 16 48 4c 2b 6d b0
>> [  140.824503] RSP: 0018:ffff99398089be60 EFLAGS: 00000246
>> [  140.824505] RAX: 0000000000000004 RBX: ffffffffa446cb28 RCX: 000000000000001f
>> [  140.824506] RDX: 000000000000000f RSI: 0000000000000000 RDI: 0000000000000000
>> [  140.824507] RBP: ffff99398089beb0 R08: 0000000000000002 R09: 00000020cf9326e4
>> [  140.824508] R10: 0000000000638824 R11: 0000000000000000 R12: 0000000000000000
>> [  140.824509] R13: 00000020c9c8d180 R14: ffffc4733fbe1c50 R15: 0000000000000004
>> [  140.824511]  cpuidle_enter+0x2e/0x40
>> [  140.824514]  do_idle+0x19f/0x240
>> [  140.824517]  cpu_startup_entry+0x25/0x30
>> [  140.824519]  start_secondary+0x7c/0x80
>> [  140.824521]  secondary_startup_64_no_verify+0xc3/0xcb
>> [  140.824525] ---[ end trace d64fa4b3dc94b292 ]---
>>
>>
> 
> Is it just me, or is net-next broken ?
> 
> Pinging the default gateway from idle host shows huge and variable delays.
> 
> Other hosts still using older kernels are just fine.
> 
> It looks we miss real qdisc_run() or something.
> 
> lpk43:~# ping6 fe80::1%eth0
> PING fe80::1%eth0(fe80::1) 56 data bytes
> 64 bytes from fe80::1: icmp_seq=1 ttl=64 time=0.177 ms
> 64 bytes from fe80::1: icmp_seq=2 ttl=64 time=0.138 ms
> 64 bytes from fe80::1: icmp_seq=3 ttl=64 time=118 ms
> 64 bytes from fe80::1: icmp_seq=4 ttl=64 time=394 ms
> 64 bytes from fe80::1: icmp_seq=5 ttl=64 time=0.146 ms
> 64 bytes from fe80::1: icmp_seq=6 ttl=64 time=823 ms
> 64 bytes from fe80::1: icmp_seq=7 ttl=64 time=77.1 ms
> 64 bytes from fe80::1: icmp_seq=8 ttl=64 time=0.165 ms
> 64 bytes from fe80::1: icmp_seq=9 ttl=64 time=0.181 ms
> 64 bytes from fe80::1: icmp_seq=10 ttl=64 time=276 ms
> 64 bytes from fe80::1: icmp_seq=11 ttl=64 time=0.159 ms
> 64 bytes from fe80::1: icmp_seq=12 ttl=64 time=17.3 ms
> 64 bytes from fe80::1: icmp_seq=13 ttl=64 time=0.134 ms
> 64 bytes from fe80::1: icmp_seq=14 ttl=64 time=0.210 ms
> 64 bytes from fe80::1: icmp_seq=15 ttl=64 time=0.134 ms
> 64 bytes from fe80::1: icmp_seq=16 ttl=64 time=414 ms
> 64 bytes from fe80::1: icmp_seq=17 ttl=64 time=443 ms
> 64 bytes from fe80::1: icmp_seq=18 ttl=64 time=0.142 ms
> 64 bytes from fe80::1: icmp_seq=19 ttl=64 time=0.137 ms
> 64 bytes from fe80::1: icmp_seq=20 ttl=64 time=121 ms
> 64 bytes from fe80::1: icmp_seq=21 ttl=64 time=169 ms
> ^C
> --- fe80::1%eth0 ping statistics ---
> 21 packets transmitted, 21 received, 0% packet loss, time 20300ms
> rtt min/avg/max/mdev = 0.134/136.098/823.204/213.070 ms
> 

Reverting 29cbcd858283 ("net: sched: Remove Qdisc::running sequence counter")
solves the issue for me.

I wonder if this patch has been tested with normal qdiscs (ie not pfifo_fast which is lockless)



