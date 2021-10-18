Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB4A431EFA
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 16:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbhJROJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 10:09:07 -0400
Received: from mail-mw2nam10on2062.outbound.protection.outlook.com ([40.107.94.62]:20544
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234941AbhJROGx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 10:06:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kb3F48BLgUSehAxCR7YskRDH80hJMjGyK07/4pJvsgwZ4UglkLQThfdBA61FpW6lGCCBo40HrOnk/XpaSJHKIC1IPdMznk5H9bb2Np37IbTAVlhFTVckpRZlzMxEIRvGR9OQue0cF/+AnO18Ev2oNQgJ3QGNgPuJF5W4ZlTgjyTIzdn2ppcOx4T2zgoY1RE9GG9zhJEzv87DrYoSybg1LuevNrH5z59O+zr88dkAYkjVMYDn64HKXPRXF/w1t65xzSEaiOwWKq4hVwv/8mNm3XMaZsfEpPE5g+flvGk2MPdiIQ17zLR7stbEI0sz6y7khIwMmSu1gmdS0PlS0iyPKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uUpesByHO5h6Xu9GhbdMd+5ZgNbtJn676dh+XKBjxnc=;
 b=avJgzypjVlrbGTvGBBCnJ6LDctMEszkkjppwNeVHxAVdrPJEolMDRDw1wG72UiN3/5PICaoxrNifCzGCayDWzyHQKDur4uzolVwHAqlHWzxzP0bx8Z8ohEfZ+KXjdt6R8IifpC7TTMUt60ZUSLR/hinr0xDAmXSx9+JqcXrWjyZzTSb6N0vV2qdr5GKN2GoIFLCQ+I6OSeRJK1KhSUpIQvZDYY35asshV74HEDPd66YlzkQ8YGJU+x4wn+uYgNLHr0Djgw8z/MmfNpnsMe+y5ET7/izzPdF4t5ICz4VAp9nQhVbOX267meJBeoP6y9gO35EQ8/4XcXXfQxOTv0Gucw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uUpesByHO5h6Xu9GhbdMd+5ZgNbtJn676dh+XKBjxnc=;
 b=eilbvXsouzxe64aHMwkMghvje/yrmAas2cXIOp96QuLJpuTRMxYNaJyCfho/KNJBKz6eNnbQni1ZHtsbuhiBmvzHsyqHROkycdBftWXVp6/ezaPKZCR3bdHU117g3g/3i031aEMH3X3USSbYXinEHPDJLie7AzpxTYlKEsdYQpsiDhmFzCzIhn9tP26EDsZbwUWDUr8w2EV6s6PHa/uISputu/VAoGaBIBKbhCIaBcEUgVsuFotypPw6VNu6Ny2Q2I57R3oYm8EXyu0Wxn/v2A1yTeDOMe/i3zWq0niwzrmQjDEEOzyTAVCrkFk1XEsHAzUvs5dLU3O5uIg4RjBLNg==
Received: from BN6PR21CA0005.namprd21.prod.outlook.com (2603:10b6:404:8e::15)
 by DM5PR12MB1196.namprd12.prod.outlook.com (2603:10b6:3:74::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Mon, 18 Oct
 2021 14:04:38 +0000
Received: from BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:8e:cafe::8d) by BN6PR21CA0005.outlook.office365.com
 (2603:10b6:404:8e::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.1 via Frontend
 Transport; Mon, 18 Oct 2021 14:04:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT010.mail.protection.outlook.com (10.13.177.53) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Mon, 18 Oct 2021 14:04:36 +0000
Received: from localhost.localdomain.nvidia.com (172.20.187.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Mon, 18 Oct 2021 14:04:22 +0000
References: <0000000000005639cd05ce3a6d4d@google.com>
 <f821df00-b3e9-f5a8-3dcb-a235dd473355@iogearbox.net>
 <f3cc125b2865cce2ea4354b3c93f45c86193545a.camel@redhat.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     syzbot <syzbot+62e474dd92a35e3060d8@syzkaller.appspotmail.com>,
        <andrii@kernel.org>, <ast@kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <kafai@fb.com>, <kpsingh@kernel.org>,
        <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <songliubraving@fb.com>,
        <syzkaller-bugs@googlegroups.com>, <yhs@fb.com>, <toke@toke.dk>,
        <joamaki@gmail.com>, Saeed Mahameed <saeedm@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: Re: [syzbot] BUG: corrupted list in netif_napi_add
In-Reply-To: <f3cc125b2865cce2ea4354b3c93f45c86193545a.camel@redhat.com>
Date:   Mon, 18 Oct 2021 17:04:19 +0300
Message-ID: <ygnh5ytubfa4.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a832e32-770b-4428-2e80-08d992403881
X-MS-TrafficTypeDiagnostic: DM5PR12MB1196:
X-Microsoft-Antispam-PRVS: <DM5PR12MB119662245CF3E32B559C03F7A0BC9@DM5PR12MB1196.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TUZjhTfUsBFyjlvCpRortmPPQNrCL/PzSzAVCzkzwtpmhNCCaoyVwyMA6MLPCMhFnsaucrXrey22GVdwvHsB8mCTQmB82DxvadNy+VuFrQzZh7B+0VyknDMvY5eMb18dbSE3FNBdC3DqGxDUNEEUcsiLevYjhf6jCZcnEY5O4lcuxIcQHbpRPCi41SgRZDPgXnFx30U/De8Sy/rIu2j0PfgU+qjJDwt8Y9EcCv58/F3g3x3kjVUtwSjLq+jhueYrg9uTqqkBmafEKT49ogB/L5T/kUZaZi2gdGSxJumyULpSgrQ93nf3d5JVkkCmVHWT01LM8TjBfdGpLXm3jTG/RcEGO6EF8KgLkjDGTa0oA37X8NPwZAdm9YzWeFD3WIMPPz9jzas1rQiwrfGCpybvefbbQX5/7oNWViBqRpi36suAZxGmSIz5ORdxGXGoUsM93R4Yf0BoG2EVkbTSyG9tRWYLMIRHJ6GBz433nXCGmdegyXlBc+SdUMp9zf9ecRFilCNQfCV8CHL/T5tlTNFsdD6idTZ2dtEyHoTvklOpi6YTzkNUDDPQwxY/L4/4ZjeMfwoDZXzeOb8PhD0jQ9MHSBt+k+/bFryDcXmwMLuQxz1sb15RcTf0CEK4nrZ+fejE4AUFPmxcRJ+6Rkw4LeE8jfUZ9cQRcrBlNSMf19Gdptz0ZGWKyZBsHVNZF8nVsA0zmYb4Z4czgtdsMvRYVaRdHA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(7696005)(2906002)(8936002)(186003)(7416002)(6666004)(70206006)(36756003)(70586007)(4001150100001)(53546011)(7636003)(356005)(26005)(508600001)(5660300002)(47076005)(426003)(82310400003)(316002)(336012)(36860700001)(107886003)(54906003)(30864003)(8676002)(110136005)(83380400001)(16526019)(86362001)(2616005)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 14:04:36.7281
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a832e32-770b-4428-2e80-08d992403881
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1196
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu 14 Oct 2021 at 16:50, Paolo Abeni <pabeni@redhat.com> wrote:
> On Wed, 2021-10-13 at 15:35 +0200, Daniel Borkmann wrote:
>> On 10/13/21 1:40 PM, syzbot wrote:
>> > Hello,
>> > 
>> > syzbot found the following issue on:
>> 
>> [ +Paolo/Toke wrt veth/XDP, +Jussi wrt bond/XDP, please take a look, thanks! ]
>
> For the records: Toke and me are actively investigating this issue and
> the other recent related one. So far we could not find anything
> relevant. 
>
> The onluy note is that the reproducer is not extremelly reliable - I
> could not reproduce locally, and multiple syzbot runs on the same code
> give different results. Anyhow, so far the issue was only observerable
> on a specific 'next' commit which is currently "not reachable" from any
> branch. I'm wondering if the issue was caused by some incosistent
> status of such tree.

Hi,

We got a use-after-free with very similar trace [0] during nightly
regression. The issue happens when ip link up/down state is flipped
several times in loop and doesn't reproduce for me manually. The fact
that it didn't reproduce for me after running test ten times suggests
that it is either very hard to reproduce or that it is a result of some
interaction between several tests in our suite.

[0]:

[ 3187.779569] mlx5_core 0000:08:00.0 enp8s0f0: Link up
 [ 3187.890694] ==================================================================
 [ 3187.892518] BUG: KASAN: use-after-free in __list_add_valid+0xc3/0xf0
 [ 3187.894132] Read of size 8 at addr ffff8881150b3fb8 by task ip/119618
 [ 3187.895683] 
 [ 3187.896209] CPU: 0 PID: 119618 Comm: ip Not tainted 5.15.0-rc5_for_upstream_debug_2021_10_17_12_06 #1
 [ 3187.898445] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
 [ 3187.901075] Call Trace:
 [ 3187.901858]  dump_stack_lvl+0x57/0x7d
 [ 3187.902899]  print_address_description.constprop.0+0x1f/0x140
 [ 3187.904346]  ? __list_add_valid+0xc3/0xf0
 [ 3187.905439]  ? __list_add_valid+0xc3/0xf0
 [ 3187.906565]  kasan_report.cold+0x83/0xdf
 [ 3187.907619]  ? __list_add_valid+0xc3/0xf0
 [ 3187.908693]  __list_add_valid+0xc3/0xf0
 [ 3187.909765]  netif_napi_add+0x399/0x9a0
 [ 3187.910794]  ? kmalloc_order_trace+0x6a/0x120
 [ 3187.911944]  mlx5e_open_channels+0x91b/0x2e10 [mlx5_core]
 [ 3187.913872]  ? rwlock_bug.part.0+0x90/0x90
 [ 3187.914959]  ? mlx5e_close_cq+0x80/0x80 [mlx5_core]
 [ 3187.916584]  ? mutex_is_locked+0x13/0x50
 [ 3187.917703]  mlx5e_open_locked+0x6a/0x1f0 [mlx5_core]
 [ 3187.919368]  mlx5e_open+0x35/0xb0 [mlx5_core]
 [ 3187.920863]  __dev_open+0x22f/0x420
 [ 3187.921852]  ? dev_set_rx_mode+0x80/0x80
 [ 3187.922920]  ? __mlx5_eswitch_set_vport_vlan+0x290/0x290 [mlx5_core]
 [ 3187.924866]  ? __local_bh_enable_ip+0xa2/0x100
 [ 3187.926148]  ? trace_hardirqs_on+0x32/0x120
 [ 3187.927270]  __dev_change_flags+0x451/0x670
 [ 3187.928387]  ? dev_set_allmulti+0x10/0x10
 [ 3187.929480]  ? rtnl_fill_vfinfo+0x936/0xdb0
 [ 3187.930592]  dev_change_flags+0x8b/0x150
 [ 3187.931651]  do_setlink+0x820/0x2d60
 [ 3187.932631]  ? rtnetlink_put_metrics+0x490/0x490
 [ 3187.933852]  ? lock_release+0x460/0x750
 [ 3187.934881]  ? kvm_async_pf_task_wake+0x410/0x410
 [ 3187.936122]  ? lock_downgrade+0x6e0/0x6e0
 [ 3187.937203]  ? do_raw_spin_unlock+0x54/0x220
 [ 3187.938351]  ? memset+0x20/0x40
 [ 3187.939246]  ? __nla_validate_parse+0xb2/0x22c0
 [ 3187.940426]  ? do_raw_spin_lock+0x126/0x270
 [ 3187.941568]  ? push_cpu_stop+0x830/0x830
 [ 3187.942638]  ? rwlock_bug.part.0+0x90/0x90
 [ 3187.943733]  ? devlink_compat_switch_id_get+0xbb/0x100
 [ 3187.945065]  ? nla_get_range_signed+0x540/0x540
 [ 3187.946272]  ? memcpy+0x39/0x60
 [ 3187.947162]  ? memset+0x20/0x40
 [ 3187.948058]  ? memset+0x20/0x40
 [ 3187.948943]  __rtnl_newlink+0xac0/0x1370
 [ 3187.950038]  ? entry_SYSCALL_64_after_hwframe+0x44/0xae
 [ 3187.951380]  ? rtnl_setlink+0x330/0x330
 [ 3187.952417]  ? deref_stack_reg+0x160/0x160
 [ 3187.953534]  ? deref_stack_reg+0xe6/0x160
 [ 3187.954619]  ? rcu_read_lock_sched_held+0x12/0x70
 [ 3187.955848]  ? lock_release+0x460/0x750
 [ 3187.956886]  ? is_bpf_text_address+0x54/0x110
 [ 3187.958047]  ? lock_downgrade+0x6e0/0x6e0
 [ 3187.959133]  ? entry_SYSCALL_64_after_hwframe+0x44/0xae
 [ 3187.960469]  ? deref_stack_reg+0x160/0x160
 [ 3187.961592]  ? is_bpf_text_address+0x73/0x110
 [ 3187.962759]  ? kernel_text_address+0xda/0x100
 [ 3187.963920]  ? __kernel_text_address+0xe/0x30
 [ 3187.965069]  ? unwind_get_return_address+0x56/0xa0
 [ 3187.966334]  ? __thaw_task+0x70/0x70
 [ 3187.967320]  ? arch_stack_walk+0x98/0xf0
 [ 3187.968405]  ? lock_downgrade+0x6e0/0x6e0
 [ 3187.969510]  ? trace_hardirqs_on+0x32/0x120
 [ 3187.970644]  ? rcu_read_lock_sched_held+0x12/0x70
 [ 3187.971883]  rtnl_newlink+0x5f/0x90
 [ 3187.972866]  rtnetlink_rcv_msg+0x32b/0x950
 [ 3187.973968]  ? deref_stack_reg+0x160/0x160
 [ 3187.975088]  ? rtnl_fdb_dump+0x830/0x830
 [ 3187.976160]  ? rcu_read_lock_sched_held+0x12/0x70
 [ 3187.977393]  ? lock_acquire+0x38d/0x4c0
 [ 3187.978443]  ? rcu_read_lock_sched_held+0x12/0x70
 [ 3187.979685]  ? lock_acquire+0x38d/0x4c0
 [ 3187.980733]  netlink_rcv_skb+0x11d/0x340
 [ 3187.981812]  ? rtnl_fdb_dump+0x830/0x830
 [ 3187.982862]  ? rcu_read_lock_sched_held+0x12/0x70
 [ 3187.984105]  ? netlink_ack+0x930/0x930
 [ 3187.985136]  ? netlink_deliver_tap+0x140/0xb10
 [ 3187.986316]  ? netlink_deliver_tap+0x14c/0xb10
 [ 3187.987495]  ? _copy_from_iter+0x282/0xbe0
 [ 3187.988597]  netlink_unicast+0x433/0x700
 [ 3187.989693]  ? netlink_attachskb+0x740/0x740
 [ 3187.990819]  ? __alloc_skb+0x117/0x2c0
 [ 3187.991855]  netlink_sendmsg+0x707/0xbf0
 [ 3187.992921]  ? netlink_unicast+0x700/0x700
 [ 3187.994024]  ? netlink_unicast+0x700/0x700
 [ 3187.995121]  sock_sendmsg+0xb0/0xe0
 [ 3187.996091]  ____sys_sendmsg+0x4fa/0x6d0
 [ 3187.997163]  ? iovec_from_user+0x136/0x280
 [ 3187.998276]  ? kernel_sendmsg+0x30/0x30
 [ 3188.012806]  ? __import_iovec+0x51/0x610
 [ 3188.013858]  ___sys_sendmsg+0x12e/0x1b0
 [ 3188.014875]  ? do_recvmmsg+0x500/0x500
 [ 3188.015877]  ? get_max_files+0x10/0x10
 [ 3188.016866]  ? kasan_record_aux_stack+0xab/0xc0
 [ 3188.018108]  ? call_rcu+0x87/0xd40
 [ 3188.019041]  ? task_work_run+0xc5/0x160
 [ 3188.020044]  ? exit_to_user_mode_prepare+0x1d9/0x1e0
 [ 3188.021271]  ? syscall_exit_to_user_mode+0x19/0x50
 [ 3188.022563]  ? do_syscall_64+0x4a/0x90
 [ 3188.023559]  ? entry_SYSCALL_64_after_hwframe+0x44/0xae
 [ 3188.024858]  ? rcu_read_lock_sched_held+0x12/0x70
 [ 3188.026121]  ? lock_release+0x460/0x750
 [ 3188.027174]  ? mntput_no_expire+0x113/0xb40
 [ 3188.028302]  ? lock_downgrade+0x6e0/0x6e0
 [ 3188.029398]  ? rwlock_bug.part.0+0x90/0x90
 [ 3188.030555]  ? rcu_read_lock_sched_held+0x12/0x70
 [ 3188.031812]  ? mntput_no_expire+0x132/0xb40
 [ 3188.032940]  ? __fget_light+0x51/0x220
 [ 3188.033986]  __sys_sendmsg+0xa4/0x120
 [ 3188.034992]  ? __sys_sendmsg_sock+0x20/0x20
 [ 3188.036115]  ? call_rcu+0x543/0xd40
 [ 3188.037084]  ? syscall_enter_from_user_mode+0x1d/0x50
 [ 3188.038406]  ? trace_hardirqs_on+0x32/0x120
 [ 3188.039515]  do_syscall_64+0x3d/0x90
 [ 3188.040502]  entry_SYSCALL_64_after_hwframe+0x44/0xae
 [ 3188.041896] RIP: 0033:0x7f904ec94c17
 [ 3188.042891] Code: 0c 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
 [ 3188.047412] RSP: 002b:00007ffc1a6c4a98 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
 [ 3188.049361] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f904ec94c17
 [ 3188.051121] RDX: 0000000000000000 RSI: 00007ffc1a6c4b00 RDI: 0000000000000003
 [ 3188.052881] RBP: 00000000616c5eef R08: 0000000000000001 R09: 00007f904ed55a40
 [ 3188.054645] R10: fffffffffffff3d6 R11: 0000000000000246 R12: 0000000000000001
 [ 3188.056403] R13: 00007ffc1a6c51b0 R14: 00007ffc1a6c6c87 R15: 000000000048f520
 [ 3188.058189] 
 [ 3188.058732] The buggy address belongs to the page:
 [ 3188.059996] page:000000003ccb70fc refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1150b3
 [ 3188.062378] flags: 0x8000000000000000(zone=2)
 [ 3188.063551] raw: 8000000000000000 0000000000000000 dead000000000122 0000000000000000
 [ 3188.065548] raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
 [ 3188.067518] page dumped because: kasan: bad access detected
 [ 3188.068930] 
 [ 3188.069481] Memory state around the buggy address:
 [ 3188.070730]  ffff8881150b3e80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 [ 3188.072618]  ffff8881150b3f00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 [ 3188.074508] >ffff8881150b3f80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 [ 3188.076378]                                         ^
 [ 3188.077711]  ffff8881150b4000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 [ 3188.079584]  ffff8881150b4080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 [ 3188.081470] ==================================================================
 [ 3188.083406] ==================================================================
 [ 3188.085280] BUG: KASAN: use-after-free in netif_napi_add+0x8b7/0x9a0
 [ 3188.086952] Write of size 8 at addr ffff8881150b3fb8 by task ip/119618
 [ 3188.089181] 
 [ 3188.089987] CPU: 0 PID: 119618 Comm: ip Tainted: G    B             5.15.0-rc5_for_upstream_debug_2021_10_17_12_06 #1
 [ 3188.092659] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
 [ 3188.095481] Call Trace:
 [ 3188.096222]  dump_stack_lvl+0x57/0x7d
 [ 3188.097238]  print_address_description.constprop.0+0x1f/0x140
 [ 3188.098764]  ? netif_napi_add+0x8b7/0x9a0
 [ 3188.099862]  ? netif_napi_add+0x8b7/0x9a0
 [ 3188.100940]  kasan_report.cold+0x83/0xdf
 [ 3188.102041]  ? netif_napi_add+0x8b7/0x9a0
 [ 3188.103140]  netif_napi_add+0x8b7/0x9a0
 [ 3188.104180]  ? kmalloc_order_trace+0x6a/0x120
 [ 3188.105336]  mlx5e_open_channels+0x91b/0x2e10 [mlx5_core]
 [ 3188.107145]  ? rwlock_bug.part.0+0x90/0x90
 [ 3188.108238]  ? mlx5e_close_cq+0x80/0x80 [mlx5_core]
 [ 3188.109882]  ? mutex_is_locked+0x13/0x50
 [ 3188.110985]  mlx5e_open_locked+0x6a/0x1f0 [mlx5_core]
 [ 3188.112644]  mlx5e_open+0x35/0xb0 [mlx5_core]
 [ 3188.114215]  __dev_open+0x22f/0x420
 [ 3188.115186]  ? dev_set_rx_mode+0x80/0x80
 [ 3188.116247]  ? __mlx5_eswitch_set_vport_vlan+0x290/0x290 [mlx5_core]
 [ 3188.118252]  ? __local_bh_enable_ip+0xa2/0x100
 [ 3188.119438]  ? trace_hardirqs_on+0x32/0x120
 [ 3188.120554]  __dev_change_flags+0x451/0x670
 [ 3188.121705]  ? dev_set_allmulti+0x10/0x10
 [ 3188.122828]  ? rtnl_fill_vfinfo+0x936/0xdb0
 [ 3188.123943]  dev_change_flags+0x8b/0x150
 [ 3188.124995]  do_setlink+0x820/0x2d60
 [ 3188.126023]  ? rtnetlink_put_metrics+0x490/0x490
 [ 3188.127233]  ? lock_release+0x460/0x750
 [ 3188.128269]  ? kvm_async_pf_task_wake+0x410/0x410
 [ 3188.129502]  ? lock_downgrade+0x6e0/0x6e0
 [ 3188.130620]  ? do_raw_spin_unlock+0x54/0x220
 [ 3188.131781]  ? memset+0x20/0x40
 [ 3188.132663]  ? __nla_validate_parse+0xb2/0x22c0
 [ 3188.133894]  ? do_raw_spin_lock+0x126/0x270
 [ 3188.135066]  ? push_cpu_stop+0x830/0x830
 [ 3188.136136]  ? rwlock_bug.part.0+0x90/0x90
 [ 3188.137230]  ? devlink_compat_switch_id_get+0xbb/0x100
 [ 3188.138585]  ? nla_get_range_signed+0x540/0x540
 [ 3188.139780]  ? memcpy+0x39/0x60
 [ 3188.140683]  ? memset+0x20/0x40
 [ 3188.141580]  ? memset+0x20/0x40
 [ 3188.142517]  __rtnl_newlink+0xac0/0x1370
 [ 3188.143579]  ? entry_SYSCALL_64_after_hwframe+0x44/0xae
 [ 3188.144914]  ? rtnl_setlink+0x330/0x330
 [ 3188.145974]  ? deref_stack_reg+0x160/0x160
 [ 3188.147078]  ? deref_stack_reg+0xe6/0x160
 [ 3188.148157]  ? rcu_read_lock_sched_held+0x12/0x70
 [ 3188.149378]  ? lock_release+0x460/0x750
 [ 3188.150490]  ? is_bpf_text_address+0x54/0x110
 [ 3188.151648]  ? lock_downgrade+0x6e0/0x6e0
 [ 3188.152725]  ? entry_SYSCALL_64_after_hwframe+0x44/0xae
 [ 3188.154075]  ? deref_stack_reg+0x160/0x160
 [ 3188.155176]  ? is_bpf_text_address+0x73/0x110
 [ 3188.156353]  ? kernel_text_address+0xda/0x100
 [ 3188.157510]  ? __kernel_text_address+0xe/0x30
 [ 3188.158707]  ? unwind_get_return_address+0x56/0xa0
 [ 3188.159992]  ? __thaw_task+0x70/0x70
 [ 3188.160979]  ? arch_stack_walk+0x98/0xf0
 [ 3188.162072]  ? lock_downgrade+0x6e0/0x6e0
 [ 3188.163167]  ? trace_hardirqs_on+0x32/0x120
 [ 3188.164295]  ? rcu_read_lock_sched_held+0x12/0x70
 [ 3188.165546]  rtnl_newlink+0x5f/0x90
 [ 3188.166558]  rtnetlink_rcv_msg+0x32b/0x950
 [ 3188.167677]  ? deref_stack_reg+0x160/0x160
 [ 3188.168782]  ? rtnl_fdb_dump+0x830/0x830
 [ 3188.169857]  ? rcu_read_lock_sched_held+0x12/0x70
 [ 3188.171089]  ? lock_acquire+0x38d/0x4c0
 [ 3188.172131]  ? rcu_read_lock_sched_held+0x12/0x70
 [ 3188.173367]  ? lock_acquire+0x38d/0x4c0
 [ 3188.174472]  netlink_rcv_skb+0x11d/0x340
 [ 3188.175531]  ? rtnl_fdb_dump+0x830/0x830
 [ 3188.176592]  ? rcu_read_lock_sched_held+0x12/0x70
 [ 3188.177824]  ? netlink_ack+0x930/0x930
 [ 3188.178848]  ? netlink_deliver_tap+0x140/0xb10
 [ 3188.180013]  ? netlink_deliver_tap+0x14c/0xb10
 [ 3188.181188]  ? _copy_from_iter+0x282/0xbe0
 [ 3188.182351]  netlink_unicast+0x433/0x700
 [ 3188.183418]  ? netlink_attachskb+0x740/0x740
 [ 3188.184552]  ? __alloc_skb+0x117/0x2c0
 [ 3188.185606]  netlink_sendmsg+0x707/0xbf0
 [ 3188.186672]  ? netlink_unicast+0x700/0x700
 [ 3188.187783]  ? netlink_unicast+0x700/0x700
 [ 3188.188882]  sock_sendmsg+0xb0/0xe0
 [ 3188.189862]  ____sys_sendmsg+0x4fa/0x6d0
 [ 3188.190971]  ? iovec_from_user+0x136/0x280
 [ 3188.192074]  ? kernel_sendmsg+0x30/0x30
 [ 3188.193130]  ? __import_iovec+0x51/0x610
 [ 3188.194225]  ___sys_sendmsg+0x12e/0x1b0
 [ 3188.195267]  ? do_recvmmsg+0x500/0x500
 [ 3188.196301]  ? get_max_files+0x10/0x10
 [ 3188.197333]  ? kasan_record_aux_stack+0xab/0xc0
 [ 3188.198558]  ? call_rcu+0x87/0xd40
 [ 3188.199519]  ? task_work_run+0xc5/0x160
 [ 3188.200557]  ? exit_to_user_mode_prepare+0x1d9/0x1e0
 [ 3188.201872]  ? syscall_exit_to_user_mode+0x19/0x50
 [ 3188.203134]  ? do_syscall_64+0x4a/0x90
 [ 3188.204152]  ? entry_SYSCALL_64_after_hwframe+0x44/0xae
 [ 3188.205511]  ? rcu_read_lock_sched_held+0x12/0x70
 [ 3188.206782]  ? lock_release+0x460/0x750
 [ 3188.207870]  ? mntput_no_expire+0x113/0xb40
 [ 3188.209025]  ? lock_downgrade+0x6e0/0x6e0
 [ 3188.210272]  ? rwlock_bug.part.0+0x90/0x90
 [ 3188.211864]  ? rcu_read_lock_sched_held+0x12/0x70
 [ 3188.213644]  ? mntput_no_expire+0x132/0xb40
 [ 3188.215253]  ? __fget_light+0x51/0x220
 [ 3188.216535]  __sys_sendmsg+0xa4/0x120
 [ 3188.217574]  ? __sys_sendmsg_sock+0x20/0x20
 [ 3188.218707]  ? call_rcu+0x543/0xd40
 [ 3188.219679]  ? syscall_enter_from_user_mode+0x1d/0x50
 [ 3188.221004]  ? trace_hardirqs_on+0x32/0x120
 [ 3188.235475]  do_syscall_64+0x3d/0x90
 [ 3188.236463]  entry_SYSCALL_64_after_hwframe+0x44/0xae
 [ 3188.237744] RIP: 0033:0x7f904ec94c17
 [ 3188.238693] Code: 0c 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
 [ 3188.242968] RSP: 002b:00007ffc1a6c4a98 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
 [ 3188.244834] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f904ec94c17
 [ 3188.246604] RDX: 0000000000000000 RSI: 00007ffc1a6c4b00 RDI: 0000000000000003
 [ 3188.248362] RBP: 00000000616c5eef R08: 0000000000000001 R09: 00007f904ed55a40
 [ 3188.250140] R10: fffffffffffff3d6 R11: 0000000000000246 R12: 0000000000000001
 [ 3188.251889] R13: 00007ffc1a6c51b0 R14: 00007ffc1a6c6c87 R15: 000000000048f520
 [ 3188.253667] 
 [ 3188.254215] The buggy address belongs to the page:
 [ 3188.255460] page:000000003ccb70fc refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1150b3
 [ 3188.257812] flags: 0x8000000000000000(zone=2)
 [ 3188.258985] raw: 8000000000000000 0000000000000000 dead000000000122 0000000000000000
 [ 3188.260971] raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
 [ 3188.262993] page dumped because: kasan: bad access detected
 [ 3188.264413] 
 [ 3188.264943] Memory state around the buggy address:
 [ 3188.266203]  ffff8881150b3e80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 [ 3188.268082]  ffff8881150b3f00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 [ 3188.269957] >ffff8881150b3f80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 [ 3188.271818]                                         ^
 [ 3188.273122]  ffff8881150b4000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 [ 3188.275000]  ffff8881150b4080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 [ 3188.276862] ==================================================================
 [ 3188.371511] mlx5_core 0000:08:00.0 enp8s0f0: Link up
 [ 3188.376126] IPv6: ADDRCONF(NETDEV_CHANGE): enp8s0f0: link becomes ready
 [ 3188.430532] ==================================================================
 [ 3188.432378] BUG: KASAN: use-after-free in __list_del_entry_valid+0x14b/0x180
 [ 3188.434254] Read of size 8 at addr ffff8881150b3fb8 by task ip/119619
 [ 3188.435826] 
 [ 3188.436365] CPU: 3 PID: 119619 Comm: ip Tainted: G    B             5.15.0-rc5_for_upstream_debug_2021_10_17_12_06 #1
 [ 3188.439688] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
 [ 3188.442423] Call Trace:
 [ 3188.443172]  dump_stack_lvl+0x57/0x7d
 [ 3188.444186]  print_address_description.constprop.0+0x1f/0x140
 [ 3188.445703]  ? __list_del_entry_valid+0x14b/0x180
 [ 3188.447004]  ? __list_del_entry_valid+0x14b/0x180
 [ 3188.448255]  kasan_report.cold+0x83/0xdf
 [ 3188.449323]  ? __list_del_entry_valid+0x14b/0x180
 [ 3188.450670]  __list_del_entry_valid+0x14b/0x180
 [ 3188.451887]  ? _raw_spin_unlock+0x1f/0x30
 [ 3188.452969]  __netif_napi_del.part.0+0xec/0x4a0
 [ 3188.454453]  mlx5e_close_channel+0x7d/0xd0 [mlx5_core]
 [ 3188.456988]  mlx5e_close_channels+0xf9/0x200 [mlx5_core]
 [ 3188.459599]  mlx5e_close_locked+0x101/0x130 [mlx5_core]
 [ 3188.462156]  mlx5e_close+0xad/0x100 [mlx5_core]
 [ 3188.463961]  __dev_close_many+0x18e/0x2b0
 [ 3188.465045]  ? list_netdevice+0x3a0/0x3a0
 [ 3188.466187]  ? __mlx5_eswitch_set_vport_vlan+0x290/0x290 [mlx5_core]
 [ 3188.468156]  ? __local_bh_enable_ip+0xa2/0x100
 [ 3188.469333]  ? trace_hardirqs_on+0x32/0x120
 [ 3188.470496]  __dev_change_flags+0x254/0x670
 [ 3188.471605]  ? dev_set_allmulti+0x10/0x10
 [ 3188.472692]  ? rtnl_fill_vfinfo+0x936/0xdb0
 [ 3188.473854]  dev_change_flags+0x8b/0x150
 [ 3188.474965]  do_setlink+0x820/0x2d60
 [ 3188.475950]  ? rtnetlink_put_metrics+0x490/0x490
 [ 3188.477165]  ? lock_release+0x460/0x750
 [ 3188.478306]  ? kvm_async_pf_task_wake+0x410/0x410
 [ 3188.479542]  ? lock_downgrade+0x6e0/0x6e0
 [ 3188.480615]  ? do_raw_spin_unlock+0x54/0x220
 [ 3188.481790]  ? memset+0x20/0x40
 [ 3188.482963]  ? __nla_validate_parse+0xb2/0x22c0
 [ 3188.484167]  ? do_raw_spin_lock+0x126/0x270
 [ 3188.485281]  ? push_cpu_stop+0x830/0x830
 [ 3188.486457]  ? rwlock_bug.part.0+0x90/0x90
 [ 3188.487557]  ? devlink_compat_switch_id_get+0xbb/0x100
 [ 3188.488894]  ? nla_get_range_signed+0x540/0x540
 [ 3188.490168]  ? memcpy+0x39/0x60
 [ 3188.491083]  ? memset+0x20/0x40
 [ 3188.491966]  ? memset+0x20/0x40
 [ 3188.492855]  __rtnl_newlink+0xac0/0x1370
 [ 3188.493987]  ? entry_SYSCALL_64_after_hwframe+0x44/0xae
 [ 3188.495384]  ? rtnl_setlink+0x330/0x330
 [ 3188.496446]  ? deref_stack_reg+0x160/0x160
 [ 3188.497551]  ? deref_stack_reg+0xe6/0x160
 [ 3188.498713]  ? rcu_read_lock_sched_held+0x12/0x70
 [ 3188.499929]  ? lock_release+0x460/0x750
 [ 3188.501232]  ? is_bpf_text_address+0x54/0x110
 [ 3188.502735]  ? lock_downgrade+0x6e0/0x6e0
 [ 3188.503831]  ? entry_SYSCALL_64_after_hwframe+0x44/0xae
 [ 3188.505157]  ? deref_stack_reg+0x160/0x160
 [ 3188.506298]  ? is_bpf_text_address+0x73/0x110
 [ 3188.507459]  ? kernel_text_address+0xda/0x100
 [ 3188.508615]  ? __kernel_text_address+0xe/0x30
 [ 3188.509776]  ? unwind_get_return_address+0x56/0xa0
 [ 3188.511047]  ? __thaw_task+0x70/0x70
 [ 3188.512033]  ? arch_stack_walk+0x98/0xf0
 [ 3188.513059]  ? lock_downgrade+0x6e0/0x6e0
 [ 3188.514191]  ? trace_hardirqs_on+0x32/0x120
 [ 3188.515303]  ? rcu_read_lock_sched_held+0x12/0x70
 [ 3188.516524]  rtnl_newlink+0x5f/0x90
 [ 3188.517513]  rtnetlink_rcv_msg+0x32b/0x950
 [ 3188.518652]  ? deref_stack_reg+0x160/0x160
 [ 3188.519761]  ? rtnl_fdb_dump+0x830/0x830
 [ 3188.520816]  ? rcu_read_lock_sched_held+0x12/0x70
 [ 3188.522119]  ? lock_acquire+0x38d/0x4c0
 [ 3188.523211]  ? rcu_read_lock_sched_held+0x12/0x70
 [ 3188.524435]  ? lock_acquire+0x38d/0x4c0
 [ 3188.525498]  netlink_rcv_skb+0x11d/0x340
 [ 3188.526649]  ? rtnl_fdb_dump+0x830/0x830
 [ 3188.527722]  ? rcu_read_lock_sched_held+0x12/0x70
 [ 3188.528949]  ? netlink_ack+0x930/0x930
 [ 3188.530055]  ? netlink_deliver_tap+0x140/0xb10
 [ 3188.531347]  ? netlink_deliver_tap+0x14c/0xb10
 [ 3188.532549]  ? _copy_from_iter+0x282/0xbe0
 [ 3188.533711]  netlink_unicast+0x433/0x700
 [ 3188.534845]  ? netlink_attachskb+0x740/0x740
 [ 3188.535987]  ? __alloc_skb+0x117/0x2c0
 [ 3188.537006]  netlink_sendmsg+0x707/0xbf0
 [ 3188.538150]  ? netlink_unicast+0x700/0x700
 [ 3188.539337]  ? netlink_unicast+0x700/0x700
 [ 3188.540448]  sock_sendmsg+0xb0/0xe0
 [ 3188.541424]  ____sys_sendmsg+0x4fa/0x6d0
 [ 3188.542743]  ? iovec_from_user+0x136/0x280
 [ 3188.543932]  ? kernel_sendmsg+0x30/0x30
 [ 3188.544963]  ? __import_iovec+0x51/0x610
 [ 3188.546063]  ___sys_sendmsg+0x12e/0x1b0
 [ 3188.547189]  ? do_recvmmsg+0x500/0x500
 [ 3188.548209]  ? get_max_files+0x10/0x10
 [ 3188.549226]  ? kasan_record_aux_stack+0xab/0xc0
 [ 3188.550547]  ? call_rcu+0x87/0xd40
 [ 3188.551509]  ? task_work_run+0xc5/0x160
 [ 3188.552546]  ? exit_to_user_mode_prepare+0x1d9/0x1e0
 [ 3188.553896]  ? syscall_exit_to_user_mode+0x19/0x50
 [ 3188.555195]  ? do_syscall_64+0x4a/0x90
 [ 3188.556206]  ? entry_SYSCALL_64_after_hwframe+0x44/0xae
 [ 3188.557634]  ? rcu_read_lock_sched_held+0x12/0x70
 [ 3188.558903]  ? lock_release+0x460/0x750
 [ 3188.559948]  ? mntput_no_expire+0x113/0xb40
 [ 3188.561059]  ? lock_downgrade+0x6e0/0x6e0
 [ 3188.562231]  ? rwlock_bug.part.0+0x90/0x90
 [ 3188.563338]  ? rcu_read_lock_sched_held+0x12/0x70
 [ 3188.564583]  ? mntput_no_expire+0x132/0xb40
 [ 3188.565731]  ? __fget_light+0x51/0x220
 [ 3188.566858]  __sys_sendmsg+0xa4/0x120
 [ 3188.567878]  ? __sys_sendmsg_sock+0x20/0x20
 [ 3188.568995]  ? call_rcu+0x543/0xd40
 [ 3188.570047]  ? syscall_enter_from_user_mode+0x1d/0x50
 [ 3188.571387]  ? trace_hardirqs_on+0x32/0x120
 [ 3188.572502]  do_syscall_64+0x3d/0x90
 [ 3188.573491]  entry_SYSCALL_64_after_hwframe+0x44/0xae
 [ 3188.574916] RIP: 0033:0x7fc68ffd4c17
 [ 3188.575900] Code: 0c 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
 [ 3188.580625] RSP: 002b:00007ffd26634f18 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
 [ 3188.582945] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fc68ffd4c17
 [ 3188.585684] RDX: 0000000000000000 RSI: 00007ffd26634f80 RDI: 0000000000000003
 [ 3188.587965] RBP: 00000000616c5eef R08: 0000000000000001 R09: 00007fc690095a40
 [ 3188.589788] R10: fffffffffffff3d6 R11: 0000000000000246 R12: 0000000000000001
 [ 3188.591618] R13: 00007ffd26635630 R14: 00007ffd26635c85 R15: 000000000048f520
 [ 3188.593365] 
 [ 3188.593953] The buggy address belongs to the page:
 [ 3188.595288] page:000000003ccb70fc refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1150b3
 [ 3188.597966] flags: 0x8000000000000000(zone=2)
 [ 3188.599643] raw: 8000000000000000 0000000000000000 dead000000000122 0000000000000000
 [ 3188.601766] raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
 [ 3188.603786] page dumped because: kasan: bad access detected
 [ 3188.622507] 
 [ 3188.623291] Memory state around the buggy address:
 [ 3188.625031]  ffff8881150b3e80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 [ 3188.627617]  ffff8881150b3f00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 [ 3188.630275] >ffff8881150b3f80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 [ 3188.632956]                                         ^
 [ 3188.634838]  ffff8881150b4000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 [ 3188.637544]  ffff8881150b4080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 [ 3188.640221] ==================================================================

[...]
