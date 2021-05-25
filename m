Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49BF390216
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 15:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233212AbhEYNYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 09:24:01 -0400
Received: from mail-mw2nam12on2070.outbound.protection.outlook.com ([40.107.244.70]:34016
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233205AbhEYNXo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 09:23:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQqwmrH3JLV30bVajkQTCWN3Kq3mi24W1BFhRes1MUIjmsVHGL53cbgT2ge8SaqD2gRVEGfRIBfr8o9syTvv6T9AHCFRKJHvynMbXWIDGe1hivykSF0dM0D00FJZaTcIbPsBu9KH6Nz706kwDi5N3Do604MjfxVh8SiYBKAm6MRs7GGBUaWra1VwM8FzhkZKsIfvHiBkvAR0H4dgoj0IeJcllWkgoFIRX+ezdvXxxDZGVVrMmsUook2GEyIg7pd6PvpU3zRscjWgW9zqKq6oahHFq1zuHMoZfNKvVvPPx3KhlpM4VqmBYgl3/Dh+sw4yYe0cP0GeS3PI0B+eWMMPyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PuUQiUJz/ajCYjEjNBHHGoPA4UMC7vk/UFz/bl/yC3s=;
 b=i3wqwMCmeiRhz3pp/5ngTLOsUPusm1oYprDdEq2xgLmul01uoFv3YzPL3T0LRR5hItF/UUmQ/6xfdOShzj7osmL+AI574b/NWE/XoBA1O1r2aZRPPKnWYTAvQHd91DtVHDoGk2RsiYHnaB+T6RtRBcSa41IFL46YEcJgfppTCrtvV4I7u3ENa/SX9lN6ASlqlrr2gBQ5QI/OjJX/Us3dtUAxKS9q9binoBC/AzZg4TNJaqhLMcOLzbGpmILH2eqTw+O8G8pJ4Pwr6VGvqbIAwsNzMBuMdS4dubjF9JtS5nKuFBh0ASTwEztjevJ8IYSF3A6ouPip+d4ZnHIVLZIC8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=mojatatu.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PuUQiUJz/ajCYjEjNBHHGoPA4UMC7vk/UFz/bl/yC3s=;
 b=tsLAKwERO/fcbH1sGWxp5w9koAT+VmOGE2BOZupDwkW0FwyNWZMMxpl5hRKmo/N5Dogtv5vekJc3JPlrJW+dZUHlXREK8RJ7NQVx44jucJ+7aLnGZuCB0j/uM9vhu/KckCKEMLbOsg2WnyGz0vI2AP0IVy9ibH82kLbYTgNeK+683XnvXNJRH+KwkuD4xRfUGUV2FjyuuKL8QXjFl4MXchfY+ginDNDKuKzituS+XFSzpgFRP06KhVng4MmbEBnxoyIm9eq5KqpQzAxG3XFP/zmm5ItgJo+1bqWCEZq6GbIL+UYVFl3qIGY89vmbdgMkbVqMTrhW4+LMqoP1cELWoA==
Received: from CO2PR05CA0060.namprd05.prod.outlook.com (2603:10b6:102:2::28)
 by DM5PR12MB1676.namprd12.prod.outlook.com (2603:10b6:4:8::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4150.26; Tue, 25 May 2021 13:22:13 +0000
Received: from CO1NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:102:2:cafe::42) by CO2PR05CA0060.outlook.office365.com
 (2603:10b6:102:2::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12 via Frontend
 Transport; Tue, 25 May 2021 13:22:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT038.mail.protection.outlook.com (10.13.174.231) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Tue, 25 May 2021 13:22:12 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 25 May
 2021 13:22:12 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 25 May
 2021 13:22:12 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 25 May 2021 13:22:09 +0000
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <jhs@mojatatu.com>, <jiri@resnulli.us>, <xiyou.wangcong@gmail.com>,
        <saeedm@mellanox.com>, <fw@strlen.de>, <wenxu@ucloud.cn>,
        <netdev@vger.kernel.org>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net v2] net: zero-initialize tc skb extension on allocation
Date:   Tue, 25 May 2021 16:21:52 +0300
Message-ID: <20210525132152.2589420-1-vladbu@nvidia.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf7fa63c-e8ab-4408-0d71-08d91f801b9d
X-MS-TrafficTypeDiagnostic: DM5PR12MB1676:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1676B4AD424E6FDA7C546EB2A0259@DM5PR12MB1676.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c8WedQm3ULKIlWWcQcdtycvr23zQeHEKF5hVOl4zABtLmqIkgzyNF/jCxWWV3sOl2fuHOylFLE5AfRVNCGunSMq1y2TvSRdOdvU6TRHxPkhRKfIjNjn0VCyDOe+kbzzxXS3NOc0+Bl+KGa5WqSMe8SoBwAXC7sCK/qq0ER/xN1Ah3oqJw9wRLgxMEf+T1+RNgd+lScheG7PDSgqIAifhf9ZNHzNeFkpqy+XF+KFOJc91Tb1SPJletbQTvtC5eQDxOaN+Qxo4dUDi7lIHtMHiStVzYCmkiFOSMzrsqpZ30a5/TjPp5/bxnGfxxQXy4SrTdbpLiSPq8wvXFdbx0FwfINUk3pB8ovlOlYgXjKUgQvozCuGgxvU7A9HApn4E42UgQUEHjXcKdYp3k7Co8Vc6riE/dfqgcjDqfSk2sirclTaptZd91Z4kxuGeW+++bT+C3FixnijsZP7ps03U3rOnvb3w2kGahUrLDUZNduEzOBzj9TMXEK5pKpTqam3Cjx5uMRSFtT7Xu39JSCCJD+pfPy8YMUSYV+SOOvb63at7c0jf3r9/QfOVKMoGvYa2jmrE35w01DfOsdhom7krlot5W0ks3asUPocNKsUO40TyJvt4OejQfrQRZAx7UUoHO6+oqgyBgXH+ROTnyw4V4rX+5TJRJJ2DDvUE7DzM4IK+2X0=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(376002)(136003)(46966006)(36840700001)(107886003)(8936002)(5660300002)(82740400003)(70586007)(4326008)(6666004)(7636003)(478600001)(2906002)(356005)(36756003)(83380400001)(70206006)(8676002)(47076005)(7696005)(1076003)(186003)(26005)(336012)(54906003)(36860700001)(110136005)(316002)(426003)(86362001)(2616005)(36906005)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 13:22:12.7858
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf7fa63c-e8ab-4408-0d71-08d91f801b9d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1676
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function skb_ext_add() doesn't initialize created skb extension with any
value and leaves it up to the user. However, since extension of type
TC_SKB_EXT originally contained only single value tc_skb_ext->chain its
users used to just assign the chain value without setting whole extension
memory to zero first. This assumption changed when TC_SKB_EXT extension was
extended with additional fields but not all users were updated to
initialize the new fields which leads to use of uninitialized memory
afterwards. UBSAN log:

[  778.299821] UBSAN: invalid-load in net/openvswitch/flow.c:899:28
[  778.301495] load of value 107 is not a valid value for type '_Bool'
[  778.303215] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.12.0-rc7+ #2
[  778.304933] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[  778.307901] Call Trace:
[  778.308680]  <IRQ>
[  778.309358]  dump_stack+0xbb/0x107
[  778.310307]  ubsan_epilogue+0x5/0x40
[  778.311167]  __ubsan_handle_load_invalid_value.cold+0x43/0x48
[  778.312454]  ? memset+0x20/0x40
[  778.313230]  ovs_flow_key_extract.cold+0xf/0x14 [openvswitch]
[  778.314532]  ovs_vport_receive+0x19e/0x2e0 [openvswitch]
[  778.315749]  ? ovs_vport_find_upcall_portid+0x330/0x330 [openvswitch]
[  778.317188]  ? create_prof_cpu_mask+0x20/0x20
[  778.318220]  ? arch_stack_walk+0x82/0xf0
[  778.319153]  ? secondary_startup_64_no_verify+0xb0/0xbb
[  778.320399]  ? stack_trace_save+0x91/0xc0
[  778.321362]  ? stack_trace_consume_entry+0x160/0x160
[  778.322517]  ? lock_release+0x52e/0x760
[  778.323444]  netdev_frame_hook+0x323/0x610 [openvswitch]
[  778.324668]  ? ovs_netdev_get_vport+0xe0/0xe0 [openvswitch]
[  778.325950]  __netif_receive_skb_core+0x771/0x2db0
[  778.327067]  ? lock_downgrade+0x6e0/0x6f0
[  778.328021]  ? lock_acquire+0x565/0x720
[  778.328940]  ? generic_xdp_tx+0x4f0/0x4f0
[  778.329902]  ? inet_gro_receive+0x2a7/0x10a0
[  778.330914]  ? lock_downgrade+0x6f0/0x6f0
[  778.331867]  ? udp4_gro_receive+0x4c4/0x13e0
[  778.332876]  ? lock_release+0x52e/0x760
[  778.333808]  ? dev_gro_receive+0xcc8/0x2380
[  778.334810]  ? lock_downgrade+0x6f0/0x6f0
[  778.335769]  __netif_receive_skb_list_core+0x295/0x820
[  778.336955]  ? process_backlog+0x780/0x780
[  778.337941]  ? mlx5e_rep_tc_netdevice_event_unregister+0x20/0x20 [mlx5_core]
[  778.339613]  ? seqcount_lockdep_reader_access.constprop.0+0xa7/0xc0
[  778.341033]  ? kvm_clock_get_cycles+0x14/0x20
[  778.342072]  netif_receive_skb_list_internal+0x5f5/0xcb0
[  778.343288]  ? __kasan_kmalloc+0x7a/0x90
[  778.344234]  ? mlx5e_handle_rx_cqe_mpwrq+0x9e0/0x9e0 [mlx5_core]
[  778.345676]  ? mlx5e_xmit_xdp_frame_mpwqe+0x14d0/0x14d0 [mlx5_core]
[  778.347140]  ? __netif_receive_skb_list_core+0x820/0x820
[  778.348351]  ? mlx5e_post_rx_mpwqes+0xa6/0x25d0 [mlx5_core]
[  778.349688]  ? napi_gro_flush+0x26c/0x3c0
[  778.350641]  napi_complete_done+0x188/0x6b0
[  778.351627]  mlx5e_napi_poll+0x373/0x1b80 [mlx5_core]
[  778.352853]  __napi_poll+0x9f/0x510
[  778.353704]  ? mlx5_flow_namespace_set_mode+0x260/0x260 [mlx5_core]
[  778.355158]  net_rx_action+0x34c/0xa40
[  778.356060]  ? napi_threaded_poll+0x3d0/0x3d0
[  778.357083]  ? sched_clock_cpu+0x18/0x190
[  778.358041]  ? __common_interrupt+0x8e/0x1a0
[  778.359045]  __do_softirq+0x1ce/0x984
[  778.359938]  __irq_exit_rcu+0x137/0x1d0
[  778.360865]  irq_exit_rcu+0xa/0x20
[  778.361708]  common_interrupt+0x80/0xa0
[  778.362640]  </IRQ>
[  778.363212]  asm_common_interrupt+0x1e/0x40
[  778.364204] RIP: 0010:native_safe_halt+0xe/0x10
[  778.365273] Code: 4f ff ff ff 4c 89 e7 e8 50 3f 40 fe e9 dc fe ff ff 48 89 df e8 43 3f 40 fe eb 90 cc e9 07 00 00 00 0f 00 2d 74 05 62 00 fb f4 <c3> 90 e9 07 00 00 00 0f 00 2d 64 05 62 00 f4 c3 cc cc 0f 1f 44 00
[  778.369355] RSP: 0018:ffffffff84407e48 EFLAGS: 00000246
[  778.370570] RAX: ffff88842de46a80 RBX: ffffffff84425840 RCX: ffffffff83418468
[  778.372143] RDX: 000000000026f1da RSI: 0000000000000004 RDI: ffffffff8343af5e
[  778.373722] RBP: fffffbfff0884b08 R08: 0000000000000000 R09: ffff88842de46bcb
[  778.375292] R10: ffffed1085bc8d79 R11: 0000000000000001 R12: 0000000000000000
[  778.376860] R13: ffffffff851124a0 R14: 0000000000000000 R15: dffffc0000000000
[  778.378491]  ? rcu_eqs_enter.constprop.0+0xb8/0xe0
[  778.379606]  ? default_idle_call+0x5e/0xe0
[  778.380578]  default_idle+0xa/0x10
[  778.381406]  default_idle_call+0x96/0xe0
[  778.382350]  do_idle+0x3d4/0x550
[  778.383153]  ? arch_cpu_idle_exit+0x40/0x40
[  778.384143]  cpu_startup_entry+0x19/0x20
[  778.385078]  start_kernel+0x3c7/0x3e5
[  778.385978]  secondary_startup_64_no_verify+0xb0/0xbb

Fix the issue by providing new function tc_skb_ext_alloc() that allocates
tc skb extension and initializes its memory to 0 before returning it to the
caller. Change all existing users to use new API instead of calling
skb_ext_add() directly.

Fixes: 038ebb1a713d ("net/sched: act_ct: fix miss set mru for ovs after defrag in act_ct")
Fixes: d29334c15d33 ("net/sched: act_api: fix miss set post_ct for ovs after do conntrack in act_ct")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---

Notes:
    Changes V1 -> V2:
    
    - Create a wrapper for tc skb extension allocation instead of modifying
    skb_ext_add() - suggested by Florian Westphal.

 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c     |  2 +-
 include/net/pkt_cls.h                               | 11 +++++++++++
 net/sched/cls_api.c                                 |  2 +-
 4 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index 6cdc52d50a48..311382261840 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -626,7 +626,7 @@ static bool mlx5e_restore_skb(struct sk_buff *skb, u32 chain, u32 reg_c1,
 		struct mlx5_eswitch *esw;
 		u32 zone_restore_id;
 
-		tc_skb_ext = skb_ext_add(skb, TC_SKB_EXT);
+		tc_skb_ext = tc_skb_ext_alloc(skb);
 		if (!tc_skb_ext) {
 			WARN_ON(1);
 			return false;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index bccdb43a880b..2c776e7a7692 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -5090,7 +5090,7 @@ bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe,
 
 	if (mapped_obj.type == MLX5_MAPPED_OBJ_CHAIN) {
 		chain = mapped_obj.chain;
-		tc_skb_ext = skb_ext_add(skb, TC_SKB_EXT);
+		tc_skb_ext = tc_skb_ext_alloc(skb);
 		if (WARN_ON(!tc_skb_ext))
 			return false;
 
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 255e4f4b521f..ec7823921bd2 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -709,6 +709,17 @@ tc_cls_common_offload_init(struct flow_cls_common_offload *cls_common,
 		cls_common->extack = extack;
 }
 
+#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+static inline struct tc_skb_ext *tc_skb_ext_alloc(struct sk_buff *skb)
+{
+	struct tc_skb_ext *tc_skb_ext = skb_ext_add(skb, TC_SKB_EXT);
+
+	if (tc_skb_ext)
+		memset(tc_skb_ext, 0, sizeof(*tc_skb_ext));
+	return tc_skb_ext;
+}
+#endif
+
 enum tc_matchall_command {
 	TC_CLSMATCHALL_REPLACE,
 	TC_CLSMATCHALL_DESTROY,
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 40fbea626dfd..279f9e2a2319 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1624,7 +1624,7 @@ int tcf_classify_ingress(struct sk_buff *skb,
 
 	/* If we missed on some chain */
 	if (ret == TC_ACT_UNSPEC && last_executed_chain) {
-		ext = skb_ext_add(skb, TC_SKB_EXT);
+		ext = tc_skb_ext_alloc(skb);
 		if (WARN_ON_ONCE(!ext))
 			return TC_ACT_SHOT;
 		ext->chain = last_executed_chain;
-- 
2.29.2

