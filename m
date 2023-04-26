Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99F3E6EF41A
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 14:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240672AbjDZMOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 08:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240807AbjDZMOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 08:14:49 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12hn2032c.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB0A4EC0
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 05:14:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SgjeGzkEITlcBGhx1fLImw8gWbKuoiPjCxUUBy1CnSsygROvSGFDWknC003iB4jiDdNe4EZfGBWm1L/yFdoptX5iaplxDAU/zNadeFqx1Y8C07PwOcUEx/K9lxcYbKd/vUZqwtkpLzYRRghst8IDYQcSxzfX8H+uK5BjEWMG7lYtVGIkRg7//D7YmOe/rWyKD3nRc0JMm6PrmIvMJRsj7Yu9+5RxkUbQxjp8AQFPjRW9YZqFYrvGo86p1k2dM594FXGbx2fWIFKEdtJPKhIFUwOPghZl/ZJnlizTOWp6Myv7wNWVHoC1RkN0iB8+5hBkt6OBe5jfuzZF/1H86ffj9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4/DkS2acqUmOtUK91qYnhRDeY4lK4ekh6Y8N0gMu+/g=;
 b=TSINM7lQantQehnjWUlWWi/JMZo20VaVcsOF2ChlLCcIS8aSVzaSYiBQtoIPAfKq3o9HKuWMj46rqcf1nXq1c6W4X+hy4eVlgbVjEBIuMQAs+Xjnn3ByGNkwnZcZbpWRIkBCveUO8xc/UdCM8U6o7VntUZeqYMgjXJkRaizvFOQEL98JRax9NWBQvQxKCR0ucx3mK2jH6SV7n4pnrTmCYJxZe7Ckd8nxBbl41ki2xsLJT4Q0nxHIJwBwa9G1ZEGj/uwbJGDHPkM+aI+s2c9pX7Q7o3iJoh6zJGMUtKOj+cKWQNu0wcg3GRePv70fufawNmsSRIXgTO6793R0Xs3HxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/DkS2acqUmOtUK91qYnhRDeY4lK4ekh6Y8N0gMu+/g=;
 b=i6I2Fx3Fag9i35H154+vStdXyzzbSWXbLMJjVZ7VhzuFQeT+RLqhztoNB76DKQaR9cR4JO6kb9bcWVbffCVbIXbPYb81R8Zj3FNzlmGlDLBV/bW7eSfiHUXyaYe4r/QCzcmp7jZKjoRd9EnH76m8yUQ7zsaSWB/M1DaUp7hlg0H3zz1M6RlHZbV3JRHYsY3OZbAWb0ZVyAnju7GqieDLU3i8FjGJbD6frYDfclsUtUBkHu+QKG3i/4pDENBDSV5X630/1Gfo/g7CIsEGuOGi4/bGvN35sLlvu3OSyPR7QePmFBlUwQDruxuPfo8pUyRp4dwbPOR8FT9PxdjWl6UM+A==
Received: from MW4PR03CA0219.namprd03.prod.outlook.com (2603:10b6:303:b9::14)
 by CY5PR12MB6432.namprd12.prod.outlook.com (2603:10b6:930:38::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Wed, 26 Apr
 2023 12:14:44 +0000
Received: from CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b9:cafe::a7) by MW4PR03CA0219.outlook.office365.com
 (2603:10b6:303:b9::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21 via Frontend
 Transport; Wed, 26 Apr 2023 12:14:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT016.mail.protection.outlook.com (10.13.175.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.21 via Frontend Transport; Wed, 26 Apr 2023 12:14:43 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 26 Apr 2023
 05:14:32 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 26 Apr
 2023 05:14:31 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Wed, 26 Apr
 2023 05:14:28 -0700
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <marcelo.leitner@gmail.com>, <paulb@nvidia.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net 1/2] net/sched: flower: fix filter idr initialization
Date:   Wed, 26 Apr 2023 14:14:14 +0200
Message-ID: <20230426121415.2149732-2-vladbu@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230426121415.2149732-1-vladbu@nvidia.com>
References: <20230426121415.2149732-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT016:EE_|CY5PR12MB6432:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b60a7d3-f82c-4428-5421-08db464fd1e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0m73K16TLwrwGSar8tZsw5Oe0kxTqfHfTyM+gQD3f4X9LQ2SdIDu52+3o/kpncKm2/wGbnS5Ch+/12Cuon6gcxnsh4QXIHI/1IdyXDgc87uhBc1KYep+WkxIsNBWW16LWAapcLECM/mcLml1BSf43SVlIklWAJxN0HjfYsMGGlahzw9mbWB0mY5PYBg9LLyv27b57dMitQR6C7aCQ7tadJ2MDzbHNP7IWwm1Lsg7AXg6LYanOHGdYkdlmTerk/Z+DnXcu0l7B/UFY3DFtJHB1QuYhPchdkHMYY4AwFBvDUEPIZKdNLb8rwtF0QjvOcYIAqyZjaRfMz3/caRh1YEFwSsBFruUcZjl4hROLkEXhm4JrTwciGftewW1ZdBnXdE1A0ADnBQPGVeyvIlKDC+ZnSes7xmzB6mtGeoAvDNBBmAyWEjLvCIpiSiyuiNuMGTfnWf5pL8Bo/Dsi3R/o/lzK+qtP68KJgUK7PuagUKyy4IsPRm1yF74JbFSP1ozFNVwcfNOCiB3QwCQUrh1J0Z13x8min/hJzQda1ffvhu5ZvpYP5nkDVEtK0F14GkEUcWF88HKleAuNOyL1FDe9zjwhE6kQCq+yuEetBPlOVmusH16l/e5FloVTYGzk1GnbYmrvnTPK56ZB6YX6TktIJgy18m+QqSuV2kkjPsaySrXeY+B+Tvrk/HGGIKEWkvmdAjCAOqKHyijke0iGHj5p9VxFVkSpMokpwdB7ncmmTXVjsByt5F1cVMP3fb591PgP6YRNsw6LGTMi0/89aER2NiorQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(346002)(39860400002)(451199021)(5400799015)(46966006)(36840700001)(40470700004)(8676002)(8936002)(2906002)(7636003)(86362001)(40460700003)(356005)(5660300002)(82310400005)(36756003)(41300700001)(107886003)(40480700001)(7696005)(6666004)(26005)(1076003)(54906003)(34020700004)(45080400002)(36860700001)(2616005)(83380400001)(478600001)(47076005)(426003)(336012)(82740400003)(186003)(316002)(70586007)(4326008)(110136005)(70206006)(12100799030);DIR:OUT;SFP:1501;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 12:14:43.9216
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b60a7d3-f82c-4428-5421-08db464fd1e1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6432
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
index 475fe222a855..1844545bef37 100644
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

