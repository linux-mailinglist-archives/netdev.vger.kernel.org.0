Return-Path: <netdev+bounces-327-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 817B16F71CD
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 20:17:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D1741C21243
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 18:17:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27FEDBE7B;
	Thu,  4 May 2023 18:17:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152FBBE7C
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 18:17:15 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2080.outbound.protection.outlook.com [40.107.93.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9578965B9
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 11:17:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oOdCCqJB5qSW9qoeQU4y1fGm5jwBmDdkRWYcHBC9V5Effl9hFWil+Dulyr9wZIJHmZlvo/AKzt5rYA7hlqdN6Glh267t9NBXK+DX9lRbSC78KA2jhxg/nX2/rAycOLB6T+wkGM6WIEvygb3Qa2Zc4+1ASk65Acny8GMXi9JTAmGF+ijDllpjXlfMCjCgFkxMFq3i2fxSO1neIlx6Ovu7TaADJAheSqcHpC46pICyj6ATaNTZ55j52N7UhyDW722sduKBx29OeIVIlGo2FBo6Mt+H/foM7Tlpr4xZXaJ0JuvXe9tVWY3vuKzwqZNfI9KmL8Hcsn/4SUxSPa+EDM9gnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qmscuNXb/rtdt2xNGi4c+YWKOWNP9wpFX1nLEqV8BQc=;
 b=ArRbPYNaEuGcpI1OwTxLx2nd6aVL7KqOUNXe45RZZSyHDqJM1NGdSfb8JHQk7leAhZV3QGlCG0w9OFpLXn8USD/dZTCn2nuEjn7NPOH7B38267a8Gre0ZpNtEUYq/Aug3B20+UFny7PCdy7t1i0p5tobdzf+tAJhR6TgONL97xkzk3bHqOOra7WLbbRInrUdXKAfszW1/2MbefPlCMv8NNA7pdciokXVa8dbmJrTLrt/zZzTtMKHDjdVRk2JKaTxFmoo58V0eLZoCxC/w+2usnXM1ay+F/nHphc3DE37WqaZJEZfw6NK2fMVj8tZho4jjhWDnhn/xVbwbML/W5MyBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qmscuNXb/rtdt2xNGi4c+YWKOWNP9wpFX1nLEqV8BQc=;
 b=qAUHcgBTCQcN2BOzNsa1S68kjPSQY+a03HxXX83EHIRj5D2otrYFYCJjcAAJ+OnPHOurpUO3O3Dzp2yiVYlbIv+vWDexhUvulZQK56EkeuRkQMPlGZrhEx7sG4GjkvnRX5fDm+xKIREbWFUH9TKngbV5I1R85Xa6LIMIPqlMDzq/i8sGwUyEqtzMh36cZpNvEE1bdeII90xcJTdiKBs8eo0bTZPKTmm3jjb9ytJ5ZM6Pm+NK6zAPxxY7F9xXselKhfL/ca0udPz7Zf67PdW6IrutG6p4vWNJzaO91Fv5invg8mXqFT8CN3brMZ1u1zaCwa9QaR8oEMnTp4QbqXUGeQ==
Received: from MN2PR22CA0003.namprd22.prod.outlook.com (2603:10b6:208:238::8)
 by DM4PR12MB5165.namprd12.prod.outlook.com (2603:10b6:5:394::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22; Thu, 4 May
 2023 18:17:10 +0000
Received: from BL02EPF000145B8.namprd05.prod.outlook.com
 (2603:10b6:208:238:cafe::4d) by MN2PR22CA0003.outlook.office365.com
 (2603:10b6:208:238::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26 via Frontend
 Transport; Thu, 4 May 2023 18:17:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF000145B8.mail.protection.outlook.com (10.167.241.208) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.21 via Frontend Transport; Thu, 4 May 2023 18:17:10 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 4 May 2023
 11:16:59 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 4 May 2023
 11:16:58 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Thu, 4 May
 2023 11:16:55 -0700
From: Vlad Buslov <vladbu@nvidia.com>
To: <pabeni@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC: <netdev@vger.kernel.org>, <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>,
	<jiri@resnulli.us>, <marcelo.leitner@gmail.com>, <paulb@nvidia.com>,
	<simon.horman@corigine.com>, <ivecera@redhat.com>, <pctammela@mojatatu.com>,
	Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net v2 1/3] net/sched: flower: fix filter idr initialization
Date: Thu, 4 May 2023 20:16:14 +0200
Message-ID: <20230504181616.2834983-2-vladbu@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504181616.2834983-1-vladbu@nvidia.com>
References: <20230504181616.2834983-1-vladbu@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000145B8:EE_|DM4PR12MB5165:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f320916-2823-41c5-d882-08db4ccbc70a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6zifCFyF14AJFsS4EAQgwVCfO5WObhtvuuhEwlXSTWvLOBR1txrMxKa4qsGx3n2gvQILUSDcTyve27hYkSDQhmxi+Ktq/4uPCyTqIQMFHVXT4jebalwZL8lGlh7Qh45CmZ69Qt6gcRR6wBF+g1YY7cKmp2hH3pF9aHL6vcA/M7UWoX2AyiYEX4p23DurueGSx28FHwYUeClTMgi6ZfDmPc9mLu1OCzCGcF92xg7bFcQgc87IRMJO0TiAwaNJhUJ2OHvTv801WqtXdb8yX5AlLF07irmKwSNoLXStUuwH6tl3xux/0Qfz2YFJGm2O9nQf8KI6UKL51etRTq9YGiJmTpVVB5lOw9oSM/J/iOrrJKH5PqiugYSSRRugLsOGG9tp2WNvROvVXxCIDRw8GmoLdYfkn26a5pJmI/qtUI7n8jUohRgczYQznMQYt1cYEt4Zq1+F/98fFKC2qry4LI9pBI8TjKW40dtd1r/IJe2DZU24kYyN39ufn/X6S0GSdJ72FJPD34hEA2/H+SlbThJxMuraP0kSSiUPY9F+qEJHBp1TcvPrFmq4a5AOrDYcTEJBdyJg5yFht8wp3j9wFhglhjabydqC/0ldakIUkfr3y0uaPfQqA6mMxdw3z2NAWoML4cHqirUHAinN+1qfJ5QZIYbVeX1exP87DZS0j7V07xUFLmddRuE93I3BkGy8UsoAe1Y+JHCZubG6ok1cVzHISg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(39860400002)(396003)(451199021)(40470700004)(36840700001)(46966006)(7416002)(40460700003)(7636003)(5660300002)(8936002)(8676002)(36860700001)(2906002)(426003)(47076005)(83380400001)(336012)(2616005)(36756003)(356005)(186003)(82740400003)(82310400005)(86362001)(26005)(1076003)(40480700001)(316002)(107886003)(41300700001)(70586007)(70206006)(4326008)(45080400002)(478600001)(7696005)(110136005)(54906003)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 18:17:10.2630
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f320916-2823-41c5-d882-08db4ccbc70a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF000145B8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5165
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The cited commit moved idr initialization too early in fl_change() which
allows concurrent users to access the filter that is still being
initialized and is in inconsistent state, which, in turn, can cause NULL
pointer dereference [0]. Since there is no obvious way to fix the ordering
without reverting the whole cited commit, alternative approach taken to
first insert NULL pointer into idr in order to allocate the handle but
still cause fl_get() to return NULL and prevent concurrent users from
seeing the filter while providing miss-to-action infrastructure with valid
handle id early in fl_change().

[  152.434728] general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN
[  152.436163] KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
[  152.437269] CPU: 4 PID: 3877 Comm: tc Not tainted 6.3.0-rc4+ #5
[  152.438110] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[  152.439644] RIP: 0010:fl_dump_key+0x8b/0x1d10 [cls_flower]
[  152.440461] Code: 01 f2 02 f2 c7 40 08 04 f2 04 f2 c7 40 0c 04 f3 f3 f3 65 48 8b 04 25 28 00 00 00 48 89 84 24 00 01 00 00 48 89 c8 48 c1 e8 03 <0f> b6 04 10 84 c0 74 08 3c 03 0f 8e 98 19 00 00 8b 13 85 d2 74 57
[  152.442885] RSP: 0018:ffff88817a28f158 EFLAGS: 00010246
[  152.443851] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[  152.444826] RDX: dffffc0000000000 RSI: ffffffff8500ae80 RDI: ffff88810a987900
[  152.445791] RBP: ffff888179d88240 R08: ffff888179d8845c R09: ffff888179d88240
[  152.446780] R10: ffffed102f451e48 R11: 00000000fffffff2 R12: ffff88810a987900
[  152.447741] R13: ffffffff8500ae80 R14: ffff88810a987900 R15: ffff888149b3c738
[  152.448756] FS:  00007f5eb2a34800(0000) GS:ffff88881ec00000(0000) knlGS:0000000000000000
[  152.449888] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  152.450685] CR2: 000000000046ad19 CR3: 000000010b0bd006 CR4: 0000000000370ea0
[  152.451641] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  152.452628] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  152.453588] Call Trace:
[  152.454032]  <TASK>
[  152.454447]  ? netlink_sendmsg+0x7a1/0xcb0
[  152.455109]  ? sock_sendmsg+0xc5/0x190
[  152.455689]  ? ____sys_sendmsg+0x535/0x6b0
[  152.456320]  ? ___sys_sendmsg+0xeb/0x170
[  152.456916]  ? do_syscall_64+0x3d/0x90
[  152.457529]  ? entry_SYSCALL_64_after_hwframe+0x46/0xb0
[  152.458321]  ? ___sys_sendmsg+0xeb/0x170
[  152.458958]  ? __sys_sendmsg+0xb5/0x140
[  152.459564]  ? do_syscall_64+0x3d/0x90
[  152.460122]  ? entry_SYSCALL_64_after_hwframe+0x46/0xb0
[  152.460852]  ? fl_dump_key_options.part.0+0xea0/0xea0 [cls_flower]
[  152.461710]  ? _raw_spin_lock+0x7a/0xd0
[  152.462299]  ? _raw_read_lock_irq+0x30/0x30
[  152.462924]  ? nla_put+0x15e/0x1c0
[  152.463480]  fl_dump+0x228/0x650 [cls_flower]
[  152.464112]  ? fl_tmplt_dump+0x210/0x210 [cls_flower]
[  152.464854]  ? __kmem_cache_alloc_node+0x1a7/0x330
[  152.465592]  ? nla_put+0x15e/0x1c0
[  152.466160]  tcf_fill_node+0x515/0x9a0
[  152.466766]  ? tc_setup_offload_action+0xf0/0xf0
[  152.467463]  ? __alloc_skb+0x13c/0x2a0
[  152.468067]  ? __build_skb_around+0x330/0x330
[  152.468814]  ? fl_get+0x107/0x1a0 [cls_flower]
[  152.469503]  tc_del_tfilter+0x718/0x1330
[  152.470115]  ? is_bpf_text_address+0xa/0x20
[  152.470765]  ? tc_ctl_chain+0xee0/0xee0
[  152.471335]  ? __kernel_text_address+0xe/0x30
[  152.471948]  ? unwind_get_return_address+0x56/0xa0
[  152.472639]  ? __thaw_task+0x150/0x150
[  152.473218]  ? arch_stack_walk+0x98/0xf0
[  152.473839]  ? __stack_depot_save+0x35/0x4c0
[  152.474501]  ? stack_trace_save+0x91/0xc0
[  152.475119]  ? security_capable+0x51/0x90
[  152.475741]  rtnetlink_rcv_msg+0x2c1/0x9d0
[  152.476387]  ? rtnl_calcit.isra.0+0x2b0/0x2b0
[  152.477042]  ? __sys_sendmsg+0xb5/0x140
[  152.477664]  ? do_syscall_64+0x3d/0x90
[  152.478255]  ? entry_SYSCALL_64_after_hwframe+0x46/0xb0
[  152.479010]  ? __stack_depot_save+0x35/0x4c0
[  152.479679]  ? __stack_depot_save+0x35/0x4c0
[  152.480346]  netlink_rcv_skb+0x12c/0x360
[  152.480929]  ? rtnl_calcit.isra.0+0x2b0/0x2b0
[  152.481517]  ? do_syscall_64+0x3d/0x90
[  152.482061]  ? netlink_ack+0x1550/0x1550
[  152.482612]  ? rhashtable_walk_peek+0x170/0x170
[  152.483262]  ? kmem_cache_alloc_node+0x1af/0x390
[  152.483875]  ? _copy_from_iter+0x3d6/0xc70
[  152.484528]  netlink_unicast+0x553/0x790
[  152.485168]  ? netlink_attachskb+0x6a0/0x6a0
[  152.485848]  ? unwind_next_frame+0x11cc/0x1a10
[  152.486538]  ? arch_stack_walk+0x61/0xf0
[  152.487169]  netlink_sendmsg+0x7a1/0xcb0
[  152.487799]  ? netlink_unicast+0x790/0x790
[  152.488355]  ? iovec_from_user.part.0+0x4d/0x220
[  152.488990]  ? _raw_spin_lock+0x7a/0xd0
[  152.489598]  ? netlink_unicast+0x790/0x790
[  152.490236]  sock_sendmsg+0xc5/0x190
[  152.490796]  ____sys_sendmsg+0x535/0x6b0
[  152.491394]  ? import_iovec+0x7/0x10
[  152.491964]  ? kernel_sendmsg+0x30/0x30
[  152.492561]  ? __copy_msghdr+0x3c0/0x3c0
[  152.493160]  ? do_syscall_64+0x3d/0x90
[  152.493706]  ___sys_sendmsg+0xeb/0x170
[  152.494283]  ? may_open_dev+0xd0/0xd0
[  152.494858]  ? copy_msghdr_from_user+0x110/0x110
[  152.495541]  ? __handle_mm_fault+0x2678/0x4ad0
[  152.496205]  ? copy_page_range+0x2360/0x2360
[  152.496862]  ? __fget_light+0x57/0x520
[  152.497449]  ? mas_find+0x1c0/0x1c0
[  152.498026]  ? sockfd_lookup_light+0x1a/0x140
[  152.498703]  __sys_sendmsg+0xb5/0x140
[  152.499306]  ? __sys_sendmsg_sock+0x20/0x20
[  152.499951]  ? do_user_addr_fault+0x369/0xd80
[  152.500595]  do_syscall_64+0x3d/0x90
[  152.501185]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[  152.501917] RIP: 0033:0x7f5eb294f887
[  152.502494] Code: 0a 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b9 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
[  152.505008] RSP: 002b:00007ffd2c708f78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[  152.506152] RAX: ffffffffffffffda RBX: 00000000642d9472 RCX: 00007f5eb294f887
[  152.507134] RDX: 0000000000000000 RSI: 00007ffd2c708fe0 RDI: 0000000000000003
[  152.508113] RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
[  152.509119] R10: 00007f5eb2808708 R11: 0000000000000246 R12: 0000000000000001
[  152.510068] R13: 0000000000000000 R14: 00007ffd2c70d1b8 R15: 0000000000485400
[  152.511031]  </TASK>
[  152.511444] Modules linked in: cls_flower sch_ingress openvswitch nsh mlx5_vdpa vringh vhost_iotlb vdpa mlx5_ib mlx5_core rpcrdma rdma_ucm ib_iser libiscsi scsi_transport_iscsi ib_umad rdma_cm ib_ipoib iw_cm ib_cm ib_uverbs ib_core xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype iptable_nat nf_nat br_netfilter overlay zram zsmalloc fuse [last unloaded: mlx5_core]
[  152.515720] ---[ end trace 0000000000000000 ]---

Fixes: 08a0063df3ae ("net/sched: flower: Move filter handle initialization earlier")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 net/sched/cls_flower.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 6ab6aadc07b8..4dc3a9007f30 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -2210,10 +2210,10 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 		spin_lock(&tp->lock);
 		if (!handle) {
 			handle = 1;
-			err = idr_alloc_u32(&head->handle_idr, fnew, &handle,
+			err = idr_alloc_u32(&head->handle_idr, NULL, &handle,
 					    INT_MAX, GFP_ATOMIC);
 		} else {
-			err = idr_alloc_u32(&head->handle_idr, fnew, &handle,
+			err = idr_alloc_u32(&head->handle_idr, NULL, &handle,
 					    handle, GFP_ATOMIC);
 
 			/* Filter with specified handle was concurrently
@@ -2378,7 +2378,7 @@ static void fl_walk(struct tcf_proto *tp, struct tcf_walker *arg,
 	rcu_read_lock();
 	idr_for_each_entry_continue_ul(&head->handle_idr, f, tmp, id) {
 		/* don't return filters that are being deleted */
-		if (!refcount_inc_not_zero(&f->refcnt))
+		if (!f || !refcount_inc_not_zero(&f->refcnt))
 			continue;
 		rcu_read_unlock();
 
-- 
2.39.2


