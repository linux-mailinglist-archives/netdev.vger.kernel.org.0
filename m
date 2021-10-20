Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B194345EA
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 09:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhJTHfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 03:35:20 -0400
Received: from mail-mw2nam10on2061.outbound.protection.outlook.com ([40.107.94.61]:14304
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229491AbhJTHfU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 03:35:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b/MDsNFOWDbvd6X8/QJHO6DmL5sJ0mtPn5m85NJYtd48+4gPEnctiLpH9QqMAVY1xAyYAN6j/HDzdq1mUJ8d76rOnKhBbs0s5jTeQ+ETkjfxtnYDDtbLaji2C0IpcdHSA2sbN5ZymRww+zxRlFv/vVQYp3NGa2MR5N00da4VuFeOv60Z3NTdIRKadd3/oBUDwzGc963Jt3JmXhFsmmRDio0GKYaav734KRDFfsO5JIq95nn7RDyuYTTiuxhN0V2TB4ZHiOErYve1FONzncJ2w0yF1YV9dJyhnqELe8sAlORjammT5TboSsQhWgg//RoK09EnDQQ9Z/BU2UveRXugJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q2MLnJrzdazFRErUuMq+LDK/lemmsngvqeve4lC7rUk=;
 b=CKYyC6sCN/wVBeWF6zWJTwmATVhmq0mlLrqwQH+HeYkYAFU4bHW/8dXnMiy3TIEEM1DpyRS1AnbweU3Y1mLBfWB4kP7D6ThI8FSHNmEWoWZlkrUUuhEl9e6hZDUu6Ns7E3fHm89Go6YMb0wQ/SvFZFSt+0FoMiLTwKvgT4BEeZdEXhf8/2+50+5wr+SE97i2BqPchDZRRlT2zhu4wE8yadHXM/3IOhD1TKg7utpBR1xb+bZxmfOPvCcCIBRlpUx7BnmwtL/Y8iGrgJ63c+86gUGEX1q4VeW0ooyUud30OyOIEBCt8PWFsMLXrXuz9dBhG0wo0iKuWO7Yl22HFXNcug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q2MLnJrzdazFRErUuMq+LDK/lemmsngvqeve4lC7rUk=;
 b=XW8OFfXsoCKYNOvfk7sZx52ZksiiMh8ls6Z7hBSkuJivqoK/lGdfR6VlWw8sLwmv7b7tRcFMqW3zPar7wgsq8TMLxxTrp7JgE45MS6ChFoFiKLM4gjL+rc9CcsTzsksO24L9eMqqSnyofAHUY56CXO8NVyokidE9t4PKVAnZ9+5X4GehwVTtvUTLlVelVP1rBtVNhdWbjfrk6Ph6pWtQEJIgGNmLk8BmHBfqJS9MAODsTnmFVwF41dvp42S5lC9+U1SToAFkaRnFpZaj1mm/X13C2m9DNpkSPnUuw0FeDFKgGlhxhsC6C1NSOeLELoo/UtZUbf7sPUntGqjuoQ1O3A==
Received: from DM6PR02CA0157.namprd02.prod.outlook.com (2603:10b6:5:332::24)
 by BY5PR12MB4801.namprd12.prod.outlook.com (2603:10b6:a03:1b1::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Wed, 20 Oct
 2021 07:33:04 +0000
Received: from DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::3b) by DM6PR02CA0157.outlook.office365.com
 (2603:10b6:5:332::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18 via Frontend
 Transport; Wed, 20 Oct 2021 07:33:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT030.mail.protection.outlook.com (10.13.172.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 07:33:03 +0000
Received: from localhost.localdomain.nvidia.com (172.20.187.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Wed, 20 Oct 2021 07:32:58 +0000
References: <20211019003402.2110017-1-eric.dumazet@gmail.com>
 <20211019003402.2110017-2-eric.dumazet@gmail.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH net-next 1/2] net: sched: fix logic error in
 qdisc_run_begin()
In-Reply-To: <20211019003402.2110017-2-eric.dumazet@gmail.com>
Date:   Wed, 20 Oct 2021 10:32:53 +0300
Message-ID: <ygnhzgr49mmy.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d14e6bea-9f63-4323-c848-08d9939bda0a
X-MS-TrafficTypeDiagnostic: BY5PR12MB4801:
X-Microsoft-Antispam-PRVS: <BY5PR12MB48019F19B8E96E084B391BE4A0BE9@BY5PR12MB4801.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Uw4IeXkJPvKgG+zZ7Oj+K2/eES5dc9r1aoDHtLhju5Ollp8qro8meMXjWxiNFRvdf+n/kulf5f7DBpQ8vscXhYVCDWtC8ySvGLdipt+jKpEWebEKmFNrGGBiQDRs0L/LkEIsB49VMnMztamRUAWhSZ6d0Dy/VZPTVbmCsvPJo3NGqz4W53tfndF4TZYs4rZIVTKoZWTlO7TQm6iUzpIYI/VlFnJUcvuvpJIfJNwOr3aQXd8i4iDF1tvNHX39OFkpafmc5RssH228sgfXd4wPUXa6p7g9aa7A19DlAogeblepQrWmcks6b01AX4p7jTt6HI7rJlYGLRWINpJjBM9eaksfPcgOh880N4HvGJHpgSBf6wrS2zKX6g8BUTTKYZjrwR2THGK3r8K+P3lAS6OWPaK70WVMv/DFWe9XGDbudXE/9gh3z7SBHtjG3ZrpK4n7yTWxeisXhpsNW60QL79SCUdNWl2Jl2ChnNvPREBjwAOiozEs9ZIssTOehhhMTpgHBo16rXmFG6aFfnl9Trew+agydQJXJgIUmpzuchgeuzZx7sHmJ1g/bWwmDyYf39QmY6O+OJkvSrXydnqMFqMj9SwYVLl2biFVgDxdKIwdwG9vRC3BMQHfgSEhHgIdg6zZW66CmHeuLFapmNduGZI8CFhlOujh4owvUI0eBbek3mZF07PSLTGWzc0uuNjkExN92fdeBsonjzbFTsRL6YR8w==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(70586007)(70206006)(7636003)(336012)(82310400003)(356005)(426003)(8936002)(2906002)(5660300002)(2616005)(83380400001)(4326008)(36756003)(54906003)(186003)(16526019)(45080400002)(26005)(6666004)(110136005)(8676002)(508600001)(316002)(47076005)(86362001)(7696005)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 07:33:03.5920
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d14e6bea-9f63-4323-c848-08d9939bda0a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4801
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 19 Oct 2021 at 03:34, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> From: Eric Dumazet <edumazet@google.com>
>
> For non TCQ_F_NOLOCK qdisc, qdisc_run_begin() tries to set
> __QDISC_STATE_RUNNING and should return true if the bit was not set.
>
> test_and_set_bit() returns old bit value, therefore we need to invert.
>
> Fixes: 29cbcd858283 ("net: sched: Remove Qdisc::running sequence counter")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Ahmed S. Darwish <a.darwish@linutronix.de>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---

We've got a warning[0] in today's regression that was added by commit that
this patch fixes. I can't reproduce it manually and from changelog it is
hard to determine whether the fix is for the issue we experiencing or
something else. WDYT?

[0]:
[Wed Oct 20 09:08:06 2021] ------------[ cut here ]------------
[Wed Oct 20 09:08:06 2021] WARNING: CPU: 4 PID: 0 at net/core/gen_stats.c:157 gnet_stats_add_basic+0x1d9/0x240
[Wed Oct 20 09:08:06 2021] Modules linked in: act_vlan cls_flower act_tunnel_key sch_ingress openvswitch nsh mlx5_ib mlx5_core xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink rpcrdma rdma_ucm ib_iser libiscsi scsi_transport_iscsi rdma_cm ib_umad iw_cm ib_ipoib ib_cm xt_addrtype iptable_nat nf_nat br_netfilter ib_uverbs ib_core overlay fuse [last unloaded: mlx5_core]
[Wed Oct 20 09:08:06 2021] CPU: 4 PID: 0 Comm: swapper/4 Not tainted 5.15.0-rc6_for_upstream_debug_2021_10_19_17_13 #1
[Wed Oct 20 09:08:06 2021] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[Wed Oct 20 09:08:06 2021] RIP: 0010:gnet_stats_add_basic+0x1d9/0x240
[Wed Oct 20 09:08:06 2021] Code: 25 a0 19 1e 02 0f 82 4a ff ff ff 48 8b 44 24 20 4c 01 28 44 8b 24 24 4c 01 60 08 48 83 c4 28 5b 5d 41 5c 41 5d 41 5e 41 5f c3 <0f> 0b e9 d1 fe ff ff 48 89 df e8 d8 4c 07 ff e9 62 fe ff ff 48 89
[Wed Oct 20 09:08:06 2021] RSP: 0018:ffff8882a4209b80 EFLAGS: 00010206
[Wed Oct 20 09:08:06 2021] RAX: 0000000080000102 RBX: ffff888116bda450 RCX: 0000000000000000
[Wed Oct 20 09:08:06 2021] RDX: ffff888116bda450 RSI: 0000607d5b844340 RDI: ffff8882a4209c90
[Wed Oct 20 09:08:06 2021] RBP: 0000607d5b844340 R08: 0000000000000001 R09: 0000000000000003
[Wed Oct 20 09:08:06 2021] R10: ffffed105484136e R11: 0000000000000001 R12: ffff888122b10608
[Wed Oct 20 09:08:06 2021] R13: ffff888122b10680 R14: ffff888122b10680 R15: ffff888122b10621
[Wed Oct 20 09:08:06 2021] FS:  0000000000000000(0000) GS:ffff8882a4200000(0000) knlGS:0000000000000000
[Wed Oct 20 09:08:06 2021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Wed Oct 20 09:08:06 2021] CR2: 0000561dba20e5b8 CR3: 0000000004026003 CR4: 0000000000370ea0
[Wed Oct 20 09:08:06 2021] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[Wed Oct 20 09:08:06 2021] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[Wed Oct 20 09:08:06 2021] Call Trace:
[Wed Oct 20 09:08:06 2021]  <IRQ>
[Wed Oct 20 09:08:06 2021]  ? rcu_core+0x642/0x1fd0
[Wed Oct 20 09:08:06 2021]  est_fetch_counters+0xc8/0x150
[Wed Oct 20 09:08:06 2021]  ? __do_softirq+0x282/0x94e
[Wed Oct 20 09:08:06 2021]  ? __irq_exit_rcu+0x11f/0x170
[Wed Oct 20 09:08:06 2021]  est_timer+0x95/0x6f0
[Wed Oct 20 09:08:06 2021]  ? rcu_read_lock_sched_held+0x12/0x70
[Wed Oct 20 09:08:06 2021]  ? lock_acquire+0x38d/0x4c0
[Wed Oct 20 09:08:06 2021]  ? rcu_read_lock_sched_held+0x12/0x70
[Wed Oct 20 09:08:06 2021]  ? lockdep_hardirqs_on_prepare+0x400/0x400
[Wed Oct 20 09:08:06 2021]  ? est_fetch_counters+0x150/0x150
[Wed Oct 20 09:08:06 2021]  ? lock_release+0x460/0x750
[Wed Oct 20 09:08:06 2021]  ? scheduler_tick+0x290/0x860
[Wed Oct 20 09:08:06 2021]  ? est_fetch_counters+0x150/0x150
[Wed Oct 20 09:08:06 2021]  ? call_timer_fn+0x178/0x490
[Wed Oct 20 09:08:06 2021]  call_timer_fn+0x178/0x490
[Wed Oct 20 09:08:06 2021]  ? lock_release+0x460/0x750
[Wed Oct 20 09:08:06 2021]  ? msleep_interruptible+0x130/0x130
[Wed Oct 20 09:08:07 2021]  ? lock_downgrade+0x6e0/0x6e0
[Wed Oct 20 09:08:07 2021]  ? __next_timer_interrupt+0xfc/0x200
[Wed Oct 20 09:08:07 2021]  ? est_fetch_counters+0x150/0x150
[Wed Oct 20 09:08:07 2021]  __run_timers.part.0+0x545/0x890
[Wed Oct 20 09:08:07 2021]  ? call_timer_fn+0x490/0x490
[Wed Oct 20 09:08:07 2021]  ? lock_downgrade+0x6e0/0x6e0
[Wed Oct 20 09:08:07 2021]  ? kvm_clock_get_cycles+0x14/0x20
[Wed Oct 20 09:08:07 2021]  ? ktime_get+0xb3/0x180
[Wed Oct 20 09:08:07 2021]  ? lapic_next_deadline+0x3c/0x90
[Wed Oct 20 09:08:07 2021]  ? clockevents_program_event+0x1dc/0x2f0
[Wed Oct 20 09:08:07 2021]  run_timer_softirq+0x6a/0x100
[Wed Oct 20 09:08:07 2021]  __do_softirq+0x282/0x94e
[Wed Oct 20 09:08:07 2021]  __irq_exit_rcu+0x11f/0x170
[Wed Oct 20 09:08:07 2021]  irq_exit_rcu+0xa/0x20
[Wed Oct 20 09:08:07 2021]  sysvec_apic_timer_interrupt+0x6f/0x90
[Wed Oct 20 09:08:07 2021]  </IRQ>
[Wed Oct 20 09:08:07 2021]  asm_sysvec_apic_timer_interrupt+0x12/0x20
[Wed Oct 20 09:08:07 2021] RIP: 0010:default_idle+0x53/0x70
[Wed Oct 20 09:08:07 2021] Code: c1 83 e0 07 48 c1 e9 03 83 c0 03 0f b6 14 11 38 d0 7c 04 84 d2 75 14 8b 05 3a 9f f4 01 85 c0 7e 07 0f 00 2d 6f a7 4c 00 fb f4 <c3> 48 c7 c7 a0 d5 2c 85 e8 c0 52 57 fe eb de 66 66 2e 0f 1f 84 00
[Wed Oct 20 09:08:07 2021] RSP: 0018:ffff888100c57df8 EFLAGS: 00000246
[Wed Oct 20 09:08:07 2021] RAX: 0000000000000000 RBX: ffff888100c42000 RCX: 1ffffffff0a59ab4
[Wed Oct 20 09:08:07 2021] RDX: 0000000000000004 RSI: 0000000000000004 RDI: ffffffff852cd5a0
[Wed Oct 20 09:08:07 2021] RBP: 0000000000000004 R08: 0000000000000000 R09: 0000000000000003
[Wed Oct 20 09:08:07 2021] R10: fffffbfff0a59ab4 R11: 0000000000000001 R12: ffffed1020188400
[Wed Oct 20 09:08:07 2021] R13: ffffffff84a65440 R14: 0000000000000000 R15: dffffc0000000000
[Wed Oct 20 09:08:07 2021]  ? default_idle+0x16/0x70
[Wed Oct 20 09:08:07 2021]  default_idle_call+0x8c/0xd0
[Wed Oct 20 09:08:07 2021]  do_idle+0x394/0x450
[Wed Oct 20 09:08:07 2021]  ? arch_cpu_idle_exit+0x40/0x40
[Wed Oct 20 09:08:07 2021]  cpu_startup_entry+0x19/0x20
[Wed Oct 20 09:08:07 2021]  start_secondary+0x229/0x2f0
[Wed Oct 20 09:08:07 2021]  ? set_cpu_sibling_map+0x1830/0x1830
[Wed Oct 20 09:08:07 2021]  secondary_startup_64_no_verify+0xb0/0xbb
[Wed Oct 20 09:08:07 2021] irq event stamp: 4163175
[Wed Oct 20 09:08:07 2021] hardirqs last  enabled at (4163175): [<ffffffff83383ba4>] default_idle_call+0x54/0xd0
[Wed Oct 20 09:08:07 2021] hardirqs last disabled at (4163174): [<ffffffff813dc286>] do_idle+0x126/0x450
[Wed Oct 20 09:08:07 2021] softirqs last  enabled at (4163146): [<ffffffff813491bf>] __irq_exit_rcu+0x11f/0x170
[Wed Oct 20 09:08:07 2021] softirqs last disabled at (4163141): [<ffffffff813491bf>] __irq_exit_rcu+0x11f/0x170
[Wed Oct 20 09:08:07 2021] ---[ end trace 522aedc0980d5e9b ]---

>  include/net/sch_generic.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
> index baad2ab4d971cd3fdc8d59acdd72d39fa6230370..e0988c56dd8fd7aa3dff6bd971da3c81f1a20626 100644
> --- a/include/net/sch_generic.h
> +++ b/include/net/sch_generic.h
> @@ -217,7 +217,7 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
>  		 */
>  		return spin_trylock(&qdisc->seqlock);
>  	}
> -	return test_and_set_bit(__QDISC_STATE_RUNNING, &qdisc->state);
> +	return !test_and_set_bit(__QDISC_STATE_RUNNING, &qdisc->state);
>  }
>  
>  static inline void qdisc_run_end(struct Qdisc *qdisc)

