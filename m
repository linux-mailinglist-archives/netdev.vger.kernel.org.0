Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B24A138E0F5
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 08:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbhEXGVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 02:21:52 -0400
Received: from mail-bn8nam12on2046.outbound.protection.outlook.com ([40.107.237.46]:45185
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231605AbhEXGVv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 02:21:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fy7/W77ymjslESWYS0V4RGr6jkwJGoTDll7ASAGryr2THH6vl682tEhPyzhbeXLWn5G5q9nXEoPH1k1a3xfUx2b3N6mtOh3c+JOsicfYCaFa4cEm3toCpMon7Yde1Rw/uQUbWTEwpRdRseVGqqTDB+1PFIunae3tABbw56QuzVzydiWyR5KX1lWAnq5cYlS5pfbjmIVTkGFBE/hYAyulMxjIJR39QvTJQVo215bP+MuyybtiurKH9gmANmScz0hZPrYvwyM6LVlmVHNJf/8xWjJFTgJuWRIU+l5ytwm6Pm+Z6jfpYN76R1VYr827Ga9n+gJB8po+UxT2tMbn+PFlQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T5Jg7UyDVt62WBh4bNvoWszPQnkyNSGRyq1tZ2lf8Zs=;
 b=QBxHm+pOf/mIvlknPvaY85wb0QwgsoBOl/AT8s9UA469AtP6Q984SMzknRFpOoMiohtr9gvq9OkHV9TrLaO7+W9alseisyFi5py41O9mbswkgOAlRTfmzEdU5xaEgjXjS2XJAoLxPj7Fuykv7tHa16p7c6PD4QRS+yHzr72vsSsnpsQmxb9Rqxro9r/omLpD+uof/AJMvOxjSu0it7vjeoLN7ntStNy9+QejqmcsNlaYfdVIdNL/K8J8yVsubFeZF8fo0tDPGcWfqEBC2SlYQiPw9zOgf6Y1jgzZDNY+XR2EXG/MmJUK3QBGeBXUk5/QQ8/J3Mpbj76q1atNrorajg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T5Jg7UyDVt62WBh4bNvoWszPQnkyNSGRyq1tZ2lf8Zs=;
 b=qU0UDLDoddo/fZZhqgs/xm5x5bAEVInqtjIfmkH3RIPBoQTgLkdgbt45cFQCzeSMoGlx7/ja17bZxm3fvWIxA7e7f4lTVn46ChfC2pOTIHcmDc3ZaB5RnPwMSjHU2NJJF8H8s0HmkndRasmdteC8ObbYoQKtzlqtNkehK2bQre0EvStzENwp1v9JCGpYcK7IIgLHmQSqYqX9iuvnljMdGcH6IZtGzdnrd1x4jjYdXRBczysFH5WSdwcLlTkhOpTThQkcpfaMbAUCRsP+5qhIXBl/5Pw96gOrwf/ZpPH/C5NmBHSD2SPzSiS23Q0+U+WH3RaWucP6bnCk1GQ2uQvRww==
Received: from DM5PR2001CA0002.namprd20.prod.outlook.com (2603:10b6:4:16::12)
 by DM6PR12MB3945.namprd12.prod.outlook.com (2603:10b6:5:1c2::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Mon, 24 May
 2021 06:20:22 +0000
Received: from DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:16:cafe::e8) by DM5PR2001CA0002.outlook.office365.com
 (2603:10b6:4:16::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend
 Transport; Mon, 24 May 2021 06:20:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT044.mail.protection.outlook.com (10.13.173.185) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 24 May 2021 06:20:21 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 24 May
 2021 06:20:21 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 24 May 2021 06:20:18 +0000
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pablo@netfilter.org>,
        <mathew.j.martineau@linux.intel.com>,
        <matthieu.baerts@tessares.net>, <steffen.klassert@secunet.com>,
        <herbert@gondor.apana.org.au>
CC:     <saeedm@mellanox.com>, <fw@strlen.de>, <netdev@vger.kernel.org>,
        "Vlad Buslov" <vladbu@nvidia.com>
Subject: [PATCH net] net: zero-initialize skb extensions on allocation
Date:   Mon, 24 May 2021 09:19:59 +0300
Message-ID: <20210524061959.2349342-1-vladbu@nvidia.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da5c2269-5924-4fc4-ca60-08d91e7c02b6
X-MS-TrafficTypeDiagnostic: DM6PR12MB3945:
X-Microsoft-Antispam-PRVS: <DM6PR12MB39454B56409EE8398DFF70D7A0269@DM6PR12MB3945.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qLki08NeD7gxuOWddPf5BrCraJ7nV3DdHHZ6LnJz9daqiHGcaIALEmS3FDebsvdoT8zZ2EAgN/o2T2TdW0U6biuLVX7f0gpfVWXuL9emaatrTGNDrVGOCdc68ZOCHHnDbkQ9U27SVE9ReSJIoR+cF5OlvaOKKeUg70WSVvWp5KPwlP8syIxaGxi8phYeYZ0hI766d7Nr8BiMMcaCkNxgJS7Ka54DVgJOFsxIGOK6dsqrmr+/JRZU/xxVp8iQDX0husd6rYX1lO7jfccN864OnVtP44NWuhOuywC+pEkH+y2Zxs24BNXQ3HFPVN7wR/p8Wm059/zFZFld3vj5A9axJoftWRjbMRvcMVoXYtoPeTV/fWSVgt53XZLBjIJN6WCkEzuM3hquVyIlYFwjrJiFhrGcjnd0uQyctbnb7m0YCo+l4l2LvguodDzCVjn6T6jYRbzcLMpYdkyFhVcQXYTdgbvPJQ26y7zlj238Fzc1hD9hOHQrUdKk2Qa10674pmIqJ2rFQpYOSNsKs4nrKArSaOeOFmDitJ8gKG7fbJc/rNMPBGTyCHVSq7qBs8S40a7dY/kek1sscEMNIQDhQJ0QdWVvjPRAGOaGqNJZtXUkSHEcxOSxR6QZc9ZgFjHcI8pfBpQ2hqzhhUIdjm5Mqhrl7IG4QBosmejjyDCyuyGMnV2YN3wp7GL+y26rtT+qtEzV
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(346002)(396003)(46966006)(36840700001)(1076003)(36906005)(316002)(54906003)(110136005)(26005)(7696005)(36756003)(4326008)(47076005)(82310400003)(8936002)(5660300002)(8676002)(107886003)(86362001)(83380400001)(426003)(186003)(36860700001)(478600001)(82740400003)(2906002)(336012)(70586007)(356005)(7636003)(70206006)(6666004)(2616005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2021 06:20:21.8838
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: da5c2269-5924-4fc4-ca60-08d91e7c02b6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3945
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

Fix the issue by changing __skb_ext_alloc() function to request
zero-initialized memory from kmem cache. Note that skb extension allocation
in skb_ext_maybe_cow() is not changed because newly allocated memory is
immediately overwritten with content of old skb extension so there is no
need to pre-initialize it.

Multiple users of skb extension API have already been manually setting
newly allocated skb extension memory to zero. Remove such code and rely on
skb extension API instead.

Fixes: 038ebb1a713d ("net/sched: act_ct: fix miss set mru for ovs after defrag in act_ct")
Fixes: d29334c15d33 ("net/sched: act_api: fix miss set post_ct for ovs after do conntrack in act_ct")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 include/net/netfilter/br_netfilter.h |  7 +------
 net/core/skbuff.c                    |  6 ++----
 net/mptcp/options.c                  |  2 --
 net/xfrm/xfrm_input.c                | 16 +---------------
 4 files changed, 4 insertions(+), 27 deletions(-)

diff --git a/include/net/netfilter/br_netfilter.h b/include/net/netfilter/br_netfilter.h
index 371696ec11b2..d4a6521ca8c3 100644
--- a/include/net/netfilter/br_netfilter.h
+++ b/include/net/netfilter/br_netfilter.h
@@ -9,12 +9,7 @@
 static inline struct nf_bridge_info *nf_bridge_alloc(struct sk_buff *skb)
 {
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
-	struct nf_bridge_info *b = skb_ext_add(skb, SKB_EXT_BRIDGE_NF);
-
-	if (b)
-		memset(b, 0, sizeof(*b));
-
-	return b;
+	return skb_ext_add(skb, SKB_EXT_BRIDGE_NF);
 #else
 	return NULL;
 #endif
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 3ad22870298c..f94614ec2d41 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6316,12 +6316,10 @@ static void *skb_ext_get_ptr(struct skb_ext *ext, enum skb_ext_id id)
  */
 struct skb_ext *__skb_ext_alloc(gfp_t flags)
 {
-	struct skb_ext *new = kmem_cache_alloc(skbuff_ext_cache, flags);
+	struct skb_ext *new = kmem_cache_zalloc(skbuff_ext_cache, flags);
 
-	if (new) {
-		memset(new->offset, 0, sizeof(new->offset));
+	if (new)
 		refcount_set(&new->refcnt, 1);
-	}
 
 	return new;
 }
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 99fc21406168..aaa467b055c8 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1078,8 +1078,6 @@ void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb)
 	if (!mpext)
 		return;
 
-	memset(mpext, 0, sizeof(*mpext));
-
 	if (mp_opt.use_map) {
 		if (mp_opt.mpc_map) {
 			/* this is an MP_CAPABLE carrying MPTCP data
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 1158cd0311d7..281d134e0f34 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -116,21 +116,7 @@ static int xfrm_rcv_cb(struct sk_buff *skb, unsigned int family, u8 protocol,
 
 struct sec_path *secpath_set(struct sk_buff *skb)
 {
-	struct sec_path *sp, *tmp = skb_ext_find(skb, SKB_EXT_SEC_PATH);
-
-	sp = skb_ext_add(skb, SKB_EXT_SEC_PATH);
-	if (!sp)
-		return NULL;
-
-	if (tmp) /* reused existing one (was COW'd if needed) */
-		return sp;
-
-	/* allocated new secpath */
-	memset(sp->ovec, 0, sizeof(sp->ovec));
-	sp->olen = 0;
-	sp->len = 0;
-
-	return sp;
+	return skb_ext_add(skb, SKB_EXT_SEC_PATH);
 }
 EXPORT_SYMBOL(secpath_set);
 
-- 
2.29.2

