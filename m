Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40D9FEF50C
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 06:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbfKEFgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 00:36:38 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40014 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbfKEFgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 00:36:38 -0500
Received: by mail-pf1-f196.google.com with SMTP id r4so14286680pfl.7
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 21:36:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=LQdiNaQy8651RwgfBxyjR2YwVV2LURf+7/wnX0os4R4=;
        b=nMZz6CXx+F8qCY19Bcv/XeAAIhpcHqJz8QY8L+c9yfam/F3iIYkqo3Flg+N6M1xvxW
         0/hzsF3eI+kMnyBVM8i7KMBAyKA0egRkifk2rbeXcAGppd55qBo4qP/QtWcDF1cJ7IS+
         c6S92WD/7o09il//YIxZWein7n7pxZ6nnIpkHzgfQwWkfbqP3ptvZGY7d0B3kd8uPa9k
         axCS3PlEhUakd6rO0a8nb1RUOVe63CApvTdskxV7i0quBLpM+S8Q2VJv8YiPuK3s+zHd
         rgCqhzClhbiRnwJOKMkWoxP5/a6MdK+Rtoa+pAYS8olHmsWS+MO5/BYEKLEOvRQ5Kkwh
         4tXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LQdiNaQy8651RwgfBxyjR2YwVV2LURf+7/wnX0os4R4=;
        b=Vw4ero4nZUmMDRE2kA1CtNu501qCxi9AStSW2hViRoH9o3eSUKdU3Pw1z3HZltx8iV
         ucvhkiLWPUbcAZ5g8p4IWY0dOV+u/OHfd8+6GGVvPc+lGWW++ngdSvEF8EP6zqitfX4l
         hP1Z7n40rITKr58DMSu7KSNr2o9ECVEdiWQKPZuLsLpYr76yfh6NGvpKIGpWV5LQdbLf
         H6zbY5MVu2/9CxZgZoPzAz9XRnUCxws5woxtPgeIAkZAt1VtlN1Lr/cCvJdE2XbALMID
         y/vyKjHXaKS+j4YLORHwomma8sBTCSRt+pCfy0bJc0NmSfeprHxZ8bwubLNYF7QQ1aPB
         Fl7A==
X-Gm-Message-State: APjAAAX0jzyAqYiA+nEpBlnIDP49gC5N10dLKwc5eSowLmm0TqZN9qB/
        uofhhcwHKnkU0pQ0F3wTdw/x43ZqeT8zpA==
X-Google-Smtp-Source: APXvYqw0MWFfH7RjIo0dCoEACK5cIR7RKkl9sipBvs7xrMpSnVGawJLTPQyt25Z/+YmQfTYVrqmcCg==
X-Received: by 2002:a17:90a:3390:: with SMTP id n16mr3846711pjb.53.1572932196931;
        Mon, 04 Nov 2019 21:36:36 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id a25sm1827502pff.50.2019.11.04.21.36.36
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 21:36:36 -0800 (PST)
Date:   Mon, 4 Nov 2019 21:36:28 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Re: [Bug 205427] New: Qdisc running seqcount may cause performance
 issues
Message-ID: <20191104213628.1e9c38cb@hermes.lan>
In-Reply-To: <bug-205427-100@https.bugzilla.kernel.org/>
References: <bug-205427-100@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Tue, 05 Nov 2019 05:27:57 +0000
bugzilla-daemon@bugzilla.kernel.org wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=205427
> 
>             Bug ID: 205427
>            Summary: Qdisc running seqcount may cause performance issues
>            Product: Networking
>            Version: 2.5
>     Kernel Version: 4.9
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: IPV4
>           Assignee: stephen@networkplumber.org
>           Reporter: yellowriver2010@hotmail.com
>         Regression: No
> 
> [ 1261.949409] NMI watchdog: BUG: soft lockup - CPU#80 stuck for 23s!
> [tc:12076]
> [ 1261.956565] Modules linked in: kpatch_D871570(O) kpatch(OE) intel_rapl
> iosf_mbi x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass
> crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel lrw glue_helper
> ablk_helper cryptd iTCO_wdt iTCO_vendor_support pcspkr iohub_sriov(O) mei_me
> ioatdma i2c_i801 lpc_ich ipmi_si mei dca shpchp mfd_core i2c_smbus wmi
> ipmi_msghandler acpi_power_meter acpi_pad ip_tables ext4 jbd2 mbcache
> virtio_net virtio_blk i2c_algo_bit drm_kms_helper crc32c_intel syscopyarea
> sysfillrect sysimgblt fb_sys_fops ttm ahci virtio_pci drm virtio_ring(E)
> libahci virtio libata nvme nvme_core i2c_core
> [ 1262.014116] CPU: 80 PID: 12076 Comm: tc Tainted: G           OE K
> 4.9.151-015.ali3000.alios7.x86_64 #1
> [ 1262.023437] Hardware name: Alibaba Alibaba Cloud ECS/Alibaba Cloud ECS, BIOS
> 3.23.34 02/14/2019
> [ 1262.032154] task: ffff887f48dc8000 task.stack: ffffc90037128000
> [ 1262.038091] RIP: 0010:[<ffffffff8160fbee>]  [<ffffffff8160fbee>]
> __gnet_stats_copy_basic+0x8e/0x90
> [ 1262.047093] RSP: 0018:ffffc9003712b930  EFLAGS: 00000202
> [ 1262.052418] RAX: 000000000011845b RBX: ffffc9003712b9a0 RCX:
> ffff887f4e39b2b0
> [ 1262.059569] RDX: 0000000000000000 RSI: ffffc9003712b93c RDI:
> ffff887f4e3950bc
> [ 1262.066871] RBP: ffffc9003712b968 R08: 0000000000000004 R09:
> ffff887f5252bf7c
> [ 1262.074166] R10: ffff887f58718100 R11: 0000000000000008 R12:
> 0000000000000000
> [ 1262.081465] R13: ffff887f5252bf4c R14: ffff887f4e39b200 R15:
> ffff887f4e39b2b0
> [ 1262.088765] FS:  00007f0a974cd740(0000) GS:ffff887f7f000000(0000)
> knlGS:0000000000000000
> [ 1262.097157] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1262.103067] CR2: 00000000006474c0 CR3: 0000007f50006000 CR4:
> 00000000007606f0
> [ 1262.110368] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [ 1262.117665] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [ 1262.124962] PKRU: 55555554
> [ 1262.127822] Stack:
> [ 1262.129985]  ffffffff8160fce8 0000000000000009 0000000000000000
> ffffffff8160ff24
> [ 1262.137779]  ffff887f58718100 d0e0e5e734dba31b ffff887f58718100
> ffffc9003712ba30
> [ 1262.145574]  ffffffff8164d383 0000000000000009 0000000000000000
> 0000000000000000
> [ 1262.153363] Call Trace:
> [ 1262.155968]  [<ffffffff8160fce8>] ? gnet_stats_copy_basic+0x38/0xe0
> [ 1262.162397]  [<ffffffff8160ff24>] ? gnet_stats_start_copy_compat+0x94/0x100
> [ 1262.169527]  [<ffffffff8164d383>] tc_fill_qdisc+0x283/0x400
> [ 1262.175258]  [<ffffffff8164d635>] tc_dump_qdisc_root+0x135/0x1a0
> [ 1262.181430]  [<ffffffff8164d744>] tc_dump_qdisc+0xa4/0x150
> [ 1262.187077]  [<ffffffff81654eb1>] netlink_dump+0x231/0x2c0
> [ 1262.192721]  [<ffffffff81655d68>] __netlink_dump_start+0x168/0x1a0
> [ 1262.199067]  [<ffffffff8164d6a0>] ? tc_dump_qdisc_root+0x1a0/0x1a0
> [ 1262.205413]  [<ffffffff81634093>] rtnetlink_rcv_msg+0x1c3/0x230
> [ 1262.211494]  [<ffffffff8164d6a0>] ? tc_dump_qdisc_root+0x1a0/0x1a0
> [ 1262.217835]  [<ffffffff81633ed0>] ? rtnl_newlink+0x860/0x860
> [ 1262.223651]  [<ffffffff81657b64>] netlink_rcv_skb+0xa4/0xc0
> [ 1262.229387]  [<ffffffff8162e785>] rtnetlink_rcv+0x15/0x20
> [ 1262.234942]  [<ffffffff8165754c>] netlink_unicast+0x18c/0x220
> [ 1262.240844]  [<ffffffff8165793b>] netlink_sendmsg+0x35b/0x3b0
> [ 1262.246758]  [<ffffffff815fca58>] sock_sendmsg+0x38/0x50
> [ 1262.252233]  [<ffffffff815fd4ad>] ___sys_sendmsg+0x29d/0x2b0
> [ 1262.258060]  [<ffffffff811ed21f>] ? do_wp_page+0x39f/0x850
> [ 1262.263708]  [<ffffffff811f04ea>] ? handle_mm_fault+0x6da/0xd50
> [ 1262.269791]  [<ffffffff815fde04>] __sys_sendmsg+0x54/0x90
> [ 1262.275359]  [<ffffffff815fde52>] SyS_sendmsg+0x12/0x20
> [ 1262.280744]  [<ffffffff81003c04>] do_syscall_64+0x74/0x180
> [ 1262.286387]  [<ffffffff81741c8e>] entry_SYSCALL_64_after_swapgs+0x58/0xc6
> [ 1262.293337] Code: 85 ff 74 18 8b 07 a8 01 75 1f 48 8b 11 48 89 16 8b 51 08
> 89 56 08 39 07 75 ea f3 c3 48 8b 01 48 89 06 8b 41 08 89 46 08 c3 f3 90 <eb> d7
> 0f 1f 44 00 00 55 48 89 e5 41 55 41 54 53 8b 47 1c 48 89 
> [ 1262.314295] Kernel panic - not syncing: softlockup: hung tasks
> [ 1262.320291] CPU: 80 PID: 12076 Comm: tc Tainted: G           OELK
> 4.9.151-015.ali3000.alios7.x86_64 #1
> [ 1262.329904] Hardware name: Alibaba Alibaba Cloud ECS/Alibaba Cloud ECS, BIOS
> 3.23.34 02/14/2019
> [ 1262.338904]  ffff887f7f003e50 ffffffff8139f342 0000000000000000
> ffffffff81a4f7f1
> [ 1262.346674]  ffff887f7f003ed8 ffffffff811b2245 ffffc90000000008
> ffff887f7f003ee8
> [ 1262.354456]  ffff887f7f003e80 d0e0e5e734dba31b ffff887f7f003ea7
> 0000000000000000
> [ 1262.362249] Call Trace:
> [ 1262.364846]  <IRQ> 
> [ 1262.366785]  [<ffffffff8139f342>] dump_stack+0x63/0x81
> [ 1262.372095]  [<ffffffff811b2245>] panic+0xf8/0x244
> [ 1262.377049]  [<ffffffff81158296>] watchdog_timer_fn+0x226/0x230
> [ 1262.383126]  [<ffffffff81158070>] ? watchdog_park_threads+0x70/0x70
> [ 1262.389555]  [<ffffffff811085e3>] __hrtimer_run_queues+0xf3/0x270
> [ 1262.395807]  [<ffffffff81108d8a>] hrtimer_interrupt+0x9a/0x180
> [ 1262.401796]  [<ffffffff810580f8>] local_apic_timer_interrupt+0x38/0x60
> [ 1262.408491]  [<ffffffff81745405>] smp_apic_timer_interrupt+0x45/0x60
> [ 1262.415006]  [<ffffffff81743b90>] apic_timer_interrupt+0xa0/0xb0
> [ 1262.421177]  <EOI> 
> [ 1262.423118]  [<ffffffff8160fbee>] ? __gnet_stats_copy_basic+0x8e/0x90
> [ 1262.429871]  [<ffffffff8160fce8>] ? gnet_stats_copy_basic+0x38/0xe0
> [ 1262.436301]  [<ffffffff8160ff24>] ? gnet_stats_start_copy_compat+0x94/0x100
> [ 1262.443428]  [<ffffffff8164d383>] tc_fill_qdisc+0x283/0x400
> [ 1262.449164]  [<ffffffff8164d635>] tc_dump_qdisc_root+0x135/0x1a0
> [ 1262.455329]  [<ffffffff8164d744>] tc_dump_qdisc+0xa4/0x150
> [ 1262.460978]  [<ffffffff81654eb1>] netlink_dump+0x231/0x2c0
> [ 1262.466620]  [<ffffffff81655d68>] __netlink_dump_start+0x168/0x1a0
> [ 1262.472965]  [<ffffffff8164d6a0>] ? tc_dump_qdisc_root+0x1a0/0x1a0
> [ 1262.479311]  [<ffffffff81634093>] rtnetlink_rcv_msg+0x1c3/0x230
> [ 1262.485394]  [<ffffffff8164d6a0>] ? tc_dump_qdisc_root+0x1a0/0x1a0
> [ 1262.491737]  [<ffffffff81633ed0>] ? rtnl_newlink+0x860/0x860
> [ 1262.497560]  [<ffffffff81657b64>] netlink_rcv_skb+0xa4/0xc0
> [ 1262.503295]  [<ffffffff8162e785>] rtnetlink_rcv+0x15/0x20
> [ 1262.508854]  [<ffffffff8165754c>] netlink_unicast+0x18c/0x220
> [ 1262.514760]  [<ffffffff8165793b>] netlink_sendmsg+0x35b/0x3b0
> [ 1262.520666]  [<ffffffff815fca58>] sock_sendmsg+0x38/0x50
> [ 1262.526140]  [<ffffffff815fd4ad>] ___sys_sendmsg+0x29d/0x2b0
> [ 1262.531960]  [<ffffffff811ed21f>] ? do_wp_page+0x39f/0x850
> [ 1262.537607]  [<ffffffff811f04ea>] ? handle_mm_fault+0x6da/0xd50
> [ 1262.543691]  [<ffffffff815fde04>] __sys_sendmsg+0x54/0x90
> [ 1262.549360]  [<ffffffff815fde52>] SyS_sendmsg+0x12/0x20
> [ 1262.554750]  [<ffffffff81003c04>] do_syscall_64+0x74/0x180
> [ 1262.560402]  [<ffffffff81741c8e>] entry_SYSCALL_64_after_swapgs+0x58/0xc6
> 
> 
> CPU 80                                                                  CPU 1
> execute : tc qd show dev bond0                                 netperf
> 
> rtnetlink_rcv (acquired rtnl_mutex)
> ...
> ...                                                            __dev_xmit_skb
> __gnet_stats_copy_basic       
> 
> 
> 
> 
> If netperf on CPU 1 runs for a long time, the tc program may repeatedly acquire
> seqcount for a long time, resulting in softlockup. At this time, the tc program
> holds the large lock of rtnl_mutex, which also affects other programs in the
> system.
> 

