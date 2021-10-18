Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBAEF4324F1
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 19:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234061AbhJRRZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 13:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234057AbhJRRZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 13:25:34 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A99C06161C;
        Mon, 18 Oct 2021 10:23:23 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id i5so5494474pla.5;
        Mon, 18 Oct 2021 10:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hLDHeDLR9sweLfVAyTlcUqMbZFfUddaQHjQtPR1ETdo=;
        b=QFjaquk4UVOQdJnETV14okN6lMvUqewO+Mr4MgqI0qvGyBfZOYhPZ4dmi1TsvoUoI5
         G2AVXbjOrqkinVykBpi0LhrBzmYV2jelu7GJEY1VoOdprIGPgvBCVj/ARrmhbc4MQCkf
         sFrgWCCjQKSMlavysw732Jq0zBgB5BcrDcigkswdJYM9Y6kh5uLoyWHM4CrAzi0ew7Ax
         yXrvk2GxhggtgKr6K8V2FKTwiXJEDwNQLmIjeSMlTDjMguV+Voi1V6NzKWFT+2DPD9Gs
         +/CLcLFOLV2CyyBu7s8noOam9A1gi9GIMZub04mvb3IaNkiYBX56Hxi34JaYZ8qrAZK2
         ACiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hLDHeDLR9sweLfVAyTlcUqMbZFfUddaQHjQtPR1ETdo=;
        b=M9GNI3WM/6CF5+jAUvxnXfgLR2J0wTSZo231Z8qCDo50h6+8K4Ze5fGmB6XoN04yh+
         r8eztua+5CN0z4M1QPXVhcTn9gLFov8XLsCXeGq4q8FsGhZLMq4Y1Vv2V9CTG6zySP51
         KGyM7nTWOlNaLUkcE+zQleAMd8+LD3t4CwPD/4Eg3AgvNoq465yW0E+78NHbFhi5qUXa
         jSmxslFGE17/Bk0krhplHDGmzKL22TcCMMCshBXh0Sc1ZgFIyzrGJkoGkevBiIrHD1D7
         1BC+pYFrxTDxwQHDts5WtAh/hfs19A2HyqI2M4/qxara05Sxp6GH82tIS6zr+z1GtgNi
         OFfA==
X-Gm-Message-State: AOAM532ngVSnyJsmfWFxUhuE3lO9Qj00fHyJxbLweFZKMfGehodTYZWo
        fcvAadVICDMc0S/2UIYNn6I=
X-Google-Smtp-Source: ABdhPJyCxgZnxwSbLxxdXAz5BQyxfRb2wcBvXV/NdOTZ9rFsF6KAh/SYQU1ex8z3PyEhlvJXulZi+g==
X-Received: by 2002:a17:903:228d:b0:13f:45d4:fa8b with SMTP id b13-20020a170903228d00b0013f45d4fa8bmr27907754plh.21.1634577802658;
        Mon, 18 Oct 2021 10:23:22 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id s3sm3208464pfu.84.2021.10.18.10.23.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 10:23:22 -0700 (PDT)
Subject: Re: [PATCH net-next 9/9] net: sched: Remove Qdisc::running sequence
 counter
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
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <1cdc197a-f9c8-34e4-b19c-132dbbbcafb5@gmail.com>
Date:   Mon, 18 Oct 2021 10:23:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211016084910.4029084-10-bigeasy@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/16/21 1:49 AM, Sebastian Andrzej Siewior wrote:
> From: "Ahmed S. Darwish" <a.darwish@linutronix.de>
> 
> The Qdisc::running sequence counter has two uses:
> 
>   1. Reliably reading qdisc's tc statistics while the qdisc is running
>      (a seqcount read/retry loop at gnet_stats_add_basic()).
> 
>   2. As a flag, indicating whether the qdisc in question is running
>      (without any retry loops).
> 
> For the first usage, the Qdisc::running sequence counter write section,
> qdisc_run_begin() => qdisc_run_end(), covers a much wider area than what
> is actually needed: the raw qdisc's bstats update. A u64_stats sync
> point was thus introduced (in previous commits) inside the bstats
> structure itself. A local u64_stats write section is then started and
> stopped for the bstats updates.
> 
> Use that u64_stats sync point mechanism for the bstats read/retry loop
> at gnet_stats_add_basic().
> 
> For the second qdisc->running usage, a __QDISC_STATE_RUNNING bit flag,
> accessed with atomic bitops, is sufficient. Using a bit flag instead of
> a sequence counter at qdisc_run_begin/end() and qdisc_is_running() leads
> to the SMP barriers implicitly added through raw_read_seqcount() and
> write_seqcount_begin/end() getting removed. All call sites have been
> surveyed though, and no required ordering was identified.
> 
> Now that the qdisc->running sequence counter is no longer used, remove
> it.
> 
> Note, using u64_stats implies no sequence counter protection for 64-bit
> architectures. This can lead to the qdisc tc statistics "packets" vs.
> "bytes" values getting out of sync on rare occasions. The individual
> values will still be valid.
> 
> Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>


I see this has been merged this week end before we could test this thing during work days :/

Just add a rate estimator on a qdisc:

tc qd add dev lo root est 1sec 4sec pfifo

then :

[  140.824352] ------------[ cut here ]------------
[  140.824361] WARNING: CPU: 15 PID: 0 at net/core/gen_stats.c:157 gnet_stats_add_basic+0x97/0xc0
[  140.824378] Modules linked in: ipvlan bonding vfat fat w1_therm i2c_mux_pca954x i2c_mux ds2482 wire cdc_acm ehci_pci ehci_hcd bnx2x mdio xt_TCPMSS ip6table_mangle ip6_tables ipv6
[  140.824413] CPU: 15 PID: 0 Comm: swapper/15 Not tainted 5.15.0-smp-DEV #73
[  140.824415] Hardware name: Intel RML,PCH/Ibis_QC_18, BIOS 2.48.0 10/02/2019
[  140.824417] RIP: 0010:gnet_stats_add_basic+0x97/0xc0
[  140.824420] Code: 2c 38 4a 03 5c 38 08 48 c7 c6 68 15 51 a4 e8 60 00 c7 ff 44 39 e0 72 db 89 d8 eb 05 31 c0 45 31 ed 4d 01 2e 49 01 46 08 eb 17 <0f> 0b 4d 85 ff 75 96 48 8b 02 48 8b 4a 08 49 01 06 89 c8 49 01 46
[  140.824432] RSP: 0018:ffff99415fbc5e08 EFLAGS: 00010206
[  140.824434] RAX: 0000000080000100 RBX: ffff9939812f41d0 RCX: 0000000000000001
[  140.824436] RDX: ffff99399705e0b0 RSI: 0000000000000000 RDI: ffff99415fbc5e40
[  140.824438] RBP: ffff99415fbc5e30 R08: 0000000000000000 R09: 0000000000000000
[  140.824440] R10: 0000000000000000 R11: ffffffffffffffff R12: ffff99415fbd7740
[  140.824441] R13: dead000000000122 R14: ffff99415fbc5e40 R15: 0000000000000000
[  140.824443] FS:  0000000000000000(0000) GS:ffff99415fbc0000(0000) knlGS:0000000000000000
[  140.824445] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  140.824447] CR2: 000000000087fff0 CR3: 0000000f11610006 CR4: 00000000000606e0
[  140.824449] Call Trace:
[  140.824450]  <IRQ>
[  140.824453]  ? local_bh_enable+0x20/0x20
[  140.824457]  est_timer+0x5e/0x130
[  140.824460]  call_timer_fn+0x2c/0x110
[  140.824464]  expire_timers+0x4c/0xf0
[  140.824467]  __run_timers+0x16f/0x1b0
[  140.824470]  run_timer_softirq+0x1d/0x40
[  140.824473]  __do_softirq+0x142/0x2a1
[  140.824477]  irq_exit_rcu+0x6b/0xb0
[  140.824480]  sysvec_apic_timer_interrupt+0x79/0x90
[  140.824483]  </IRQ>
[  140.824493]  asm_sysvec_apic_timer_interrupt+0x12/0x20
[  140.824497] RIP: 0010:cpuidle_enter_state+0x19b/0x300
[  140.824502] Code: ff 45 84 e4 74 20 48 c7 45 c8 00 00 00 00 9c 8f 45 c8 f7 45 c8 00 02 00 00 0f 85 e4 00 00 00 31 ff e8 c9 0d 88 ff fb 8b 45 bc <85> c0 78 52 48 89 de 89 c3 48 6b d3 68 48 8b 4c 16 48 4c 2b 6d b0
[  140.824503] RSP: 0018:ffff99398089be60 EFLAGS: 00000246
[  140.824505] RAX: 0000000000000004 RBX: ffffffffa446cb28 RCX: 000000000000001f
[  140.824506] RDX: 000000000000000f RSI: 0000000000000000 RDI: 0000000000000000
[  140.824507] RBP: ffff99398089beb0 R08: 0000000000000002 R09: 00000020cf9326e4
[  140.824508] R10: 0000000000638824 R11: 0000000000000000 R12: 0000000000000000
[  140.824509] R13: 00000020c9c8d180 R14: ffffc4733fbe1c50 R15: 0000000000000004
[  140.824511]  cpuidle_enter+0x2e/0x40
[  140.824514]  do_idle+0x19f/0x240
[  140.824517]  cpu_startup_entry+0x25/0x30
[  140.824519]  start_secondary+0x7c/0x80
[  140.824521]  secondary_startup_64_no_verify+0xc3/0xcb
[  140.824525] ---[ end trace d64fa4b3dc94b292 ]---


