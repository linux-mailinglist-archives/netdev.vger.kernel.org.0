Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 565B5131C75
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 00:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbgAFXgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 18:36:38 -0500
Received: from mail-eopbgr20053.outbound.protection.outlook.com ([40.107.2.53]:32391
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727315AbgAFXgi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 18:36:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dXnXL8lH0noah9BKgRJoUW59tLWrLqtEmCoj7IiWnjYLS3AqG93aWX+6dCe+STg5OZEcpspuTj/zv/B6VX4nDVtfLxmCegQ3OgGSloyo6cga63ybFZGxmUb+udriyPTNvbVmcoDmmuy3ECyNnGuNpIc9uWMX8vzcr085BgQw62mvi+bpWeoUW6ozZZb96oJg7OSVjfTMUsXcSiYNc2p24/zOnnnRf4RsRuLDEtQO95D2EMXAL4Gxoa0Y8y8yRydUU7U8QCiWIsMGgZkRHP6QFVC3GgR3I+ukdYKLblNlINAha75BbUEFXWqcAuOFmcqa3VwwHoljjSIBjNZ7BzvUXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wW4TwmDBUwV0LaLFXCfHkZS2LJNqxr4i3+qCmetB0SU=;
 b=IpkKWlNDuVX81qKUqySydVCoTRcUVSogkrULisVqAx07t5pPMJaz4n4IEN9an8onhwuKdIqtkNHOyL57ZNdjmxBbpjMjNkPnPunKXqgTRwvXlIpJ+k4Gtk0cu8/Sf6/h/EkVlkdpXBQP4dpbCq/NuhxU3Xjv+JfdjonzAgKt+kQL/dxwrNxXxrtfdRtSFMrfjNuv7FBkZ/yOyu2zSiWlldoXBvV1zL3JqjlAJgNMZQdT/+LILFqTEMpPn0qBxV6NahkVpYXCEs+/+DdPChVXo7qYAX87FfLT32GoSFi8MODx2pF+v1pEQwkNJl0kvo6i/p9vQlbtIL8aNdTM5t4ibQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wW4TwmDBUwV0LaLFXCfHkZS2LJNqxr4i3+qCmetB0SU=;
 b=JyMh05NxS3hJmjVPiF3j9p4ZJ6+iFlS/R8VZsMU/KQxAlH2GCLhQjfAA7fbTJslpRj51qcxSJ9y6pezURpjAIg4u/yOg9V2hzEB5BWWVjd15rhSyR/vmr+9hwqpqN6mp8zYjTxWnV/POccwjSwiCdVx1BXRHbbsOTzX7ydbeNdM=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6397.eurprd05.prod.outlook.com (20.179.25.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.15; Mon, 6 Jan 2020 23:36:29 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2602.015; Mon, 6 Jan 2020
 23:36:29 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR05CA0090.namprd05.prod.outlook.com (2603:10b6:a03:e0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.3 via Frontend Transport; Mon, 6 Jan 2020 23:36:27 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 4/7] Revert "net/mlx5: Support lockless FTE read lookups"
Thread-Topic: [net 4/7] Revert "net/mlx5: Support lockless FTE read lookups"
Thread-Index: AQHVxOoeNukwDfUzf0u4VQM8/7J7Dw==
Date:   Mon, 6 Jan 2020 23:36:29 +0000
Message-ID: <20200106233248.58700-5-saeedm@mellanox.com>
References: <20200106233248.58700-1-saeedm@mellanox.com>
In-Reply-To: <20200106233248.58700-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0090.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::31) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 036e12f0-b88a-44c9-90ae-08d7930140fb
x-ms-traffictypediagnostic: VI1PR05MB6397:|VI1PR05MB6397:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6397B201F5632E8022FFCF3CBE3C0@VI1PR05MB6397.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:451;
x-forefront-prvs: 0274272F87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(189003)(199004)(4326008)(5660300002)(2616005)(956004)(6916009)(54906003)(8936002)(478600001)(6512007)(26005)(107886003)(81166006)(8676002)(71200400001)(81156014)(64756008)(66946007)(66446008)(66476007)(66556008)(52116002)(6486002)(6506007)(1076003)(86362001)(316002)(36756003)(16526019)(2906002)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6397;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F9dQCugmN6Rwr2TGRVghdZpwOy9qT4F6jVynjdA0x5jynSPwP4zkOPFVCLuVQTFhS8QYNYhdSDTXtLej9dw5ZIeJ5gJ78WMy4UeLio4VW92kBXQCG3gSqwZ8Lo9Aj9iyLmJmhkunwd+9efxZVGEsQ9/Uh95kFcIaqK5TqqY3OrYWjWeBtjBv+gUrBld4zylxWQckE2cDGt+mVGqrplDnUayTTv3ZQgDIBzG+knWPZtCbPYNNd8s3lpxKhlk1tfrJIJpsWTiuU6xkd3iDPCL8JlmUG4D2so6MDy1gyjCytUg4uaKGXp2iN+4lvBO9NDYp6ma0h5I/lGmNB8EehPNC4MnSu89nCMWkt6ZQbBDt8Crvmyd81Eqo2T035t9X3IgosuAjPrWhRYzMsumoqnPDliwetEek8A6K2buHc0P6lbNtILqGkMoKR1f9TcgIpSvMZd/wA8J/1CHlsHvanYeX33QnN6AzWrSAgqXOw1RF2D2Y4C8VnW6Kr+epH4qlkXgrnYaWqVPZG2WfWRPtPZfRqh3/S9Pfofpl8rPmCfo0txg=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 036e12f0-b88a-44c9-90ae-08d7930140fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2020 23:36:29.3971
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: II3w8S7u11uzO/aJHEms3VBJ3NeQD1dOMKqCskwkR56iK4KgNQTBg/yNy5XpvRJODVsXn1NMjsbOuyFen0uLHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6397
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

This reverts commit 7dee607ed0e04500459db53001d8e02f8831f084.

During cleanup path, FTE's parent node group is removed which is
referenced by the FTE while freeing the FTE.
Hence FTE's lockless read lookup optimization done in cited commit is
not possible at the moment.

Hence, revert the commit.

This avoid below KAZAN call trace.

[  110.390896] BUG: KASAN: use-after-free in find_root.isra.14+0x56/0x60
[mlx5_core]
[  110.391048] Read of size 4 at addr ffff888c19e6d220 by task
swapper/12/0

[  110.391219] CPU: 12 PID: 0 Comm: swapper/12 Not tainted 5.5.0-rc1+
[  110.391222] Hardware name: HP ProLiant DL380p Gen8, BIOS P70
08/02/2014
[  110.391225] Call Trace:
[  110.391229]  <IRQ>
[  110.391246]  dump_stack+0x95/0xd5
[  110.391307]  ? find_root.isra.14+0x56/0x60 [mlx5_core]
[  110.391320]  print_address_description.constprop.5+0x20/0x320
[  110.391379]  ? find_root.isra.14+0x56/0x60 [mlx5_core]
[  110.391435]  ? find_root.isra.14+0x56/0x60 [mlx5_core]
[  110.391441]  __kasan_report+0x149/0x18c
[  110.391499]  ? find_root.isra.14+0x56/0x60 [mlx5_core]
[  110.391504]  kasan_report+0x12/0x20
[  110.391511]  __asan_report_load4_noabort+0x14/0x20
[  110.391567]  find_root.isra.14+0x56/0x60 [mlx5_core]
[  110.391625]  del_sw_fte_rcu+0x4a/0x100 [mlx5_core]
[  110.391633]  rcu_core+0x404/0x1950
[  110.391640]  ? rcu_accelerate_cbs_unlocked+0x100/0x100
[  110.391649]  ? run_rebalance_domains+0x201/0x280
[  110.391654]  rcu_core_si+0xe/0x10
[  110.391661]  __do_softirq+0x181/0x66c
[  110.391670]  irq_exit+0x12c/0x150
[  110.391675]  smp_apic_timer_interrupt+0xf0/0x370
[  110.391681]  apic_timer_interrupt+0xf/0x20
[  110.391684]  </IRQ>
[  110.391695] RIP: 0010:cpuidle_enter_state+0xfa/0xba0
[  110.391703] Code: 3d c3 9b b5 50 e8 56 75 6e fe 48 89 45 c8 0f 1f 44
00 00 31 ff e8 a6 94 6e fe 45 84 ff 0f 85 f6 02 00 00 fb 66 0f 1f 44 00
00 <45> 85 f6 0f 88 db 06 00 00 4d 63 fe 4b 8d 04 7f 49 8d 04 87 49 8d
[  110.391706] RSP: 0018:ffff888c23a6fce8 EFLAGS: 00000246 ORIG_RAX:
ffffffffffffff13
[  110.391712] RAX: dffffc0000000000 RBX: ffffe8ffff7002f8 RCX:
000000000000001f
[  110.391715] RDX: 1ffff11184ee6cb5 RSI: 0000000040277d83 RDI:
ffff888c277365a8
[  110.391718] RBP: ffff888c23a6fd40 R08: 0000000000000002 R09:
0000000000035280
[  110.391721] R10: ffff888c23a6fc80 R11: ffffed11847485d0 R12:
ffffffffb1017740
[  110.391723] R13: 0000000000000003 R14: 0000000000000003 R15:
0000000000000000
[  110.391732]  ? cpuidle_enter_state+0xea/0xba0
[  110.391738]  cpuidle_enter+0x4f/0xa0
[  110.391747]  call_cpuidle+0x6d/0xc0
[  110.391752]  do_idle+0x360/0x430
[  110.391758]  ? arch_cpu_idle_exit+0x40/0x40
[  110.391765]  ? complete+0x67/0x80
[  110.391771]  cpu_startup_entry+0x1d/0x20
[  110.391779]  start_secondary+0x2f3/0x3c0
[  110.391784]  ? set_cpu_sibling_map+0x2500/0x2500
[  110.391795]  secondary_startup_64+0xa4/0xb0

[  110.391841] Allocated by task 290:
[  110.391917]  save_stack+0x21/0x90
[  110.391921]  __kasan_kmalloc.constprop.8+0xa7/0xd0
[  110.391925]  kasan_kmalloc+0x9/0x10
[  110.391929]  kmem_cache_alloc_trace+0xf6/0x270
[  110.391987]  create_root_ns.isra.36+0x58/0x260 [mlx5_core]
[  110.392044]  mlx5_init_fs+0x5fd/0x1ee0 [mlx5_core]
[  110.392092]  mlx5_load_one+0xc7a/0x3860 [mlx5_core]
[  110.392139]  init_one+0x6ff/0xf90 [mlx5_core]
[  110.392145]  local_pci_probe+0xde/0x190
[  110.392150]  work_for_cpu_fn+0x56/0xa0
[  110.392153]  process_one_work+0x678/0x1140
[  110.392157]  worker_thread+0x573/0xba0
[  110.392162]  kthread+0x341/0x400
[  110.392166]  ret_from_fork+0x1f/0x40

[  110.392218] Freed by task 2742:
[  110.392288]  save_stack+0x21/0x90
[  110.392292]  __kasan_slab_free+0x137/0x190
[  110.392296]  kasan_slab_free+0xe/0x10
[  110.392299]  kfree+0x94/0x250
[  110.392357]  tree_put_node+0x257/0x360 [mlx5_core]
[  110.392413]  tree_remove_node+0x63/0xb0 [mlx5_core]
[  110.392469]  clean_tree+0x199/0x240 [mlx5_core]
[  110.392525]  mlx5_cleanup_fs+0x76/0x580 [mlx5_core]
[  110.392572]  mlx5_unload+0x22/0xc0 [mlx5_core]
[  110.392619]  mlx5_unload_one+0x99/0x260 [mlx5_core]
[  110.392666]  remove_one+0x61/0x160 [mlx5_core]
[  110.392671]  pci_device_remove+0x10b/0x2c0
[  110.392677]  device_release_driver_internal+0x1e4/0x490
[  110.392681]  device_driver_detach+0x36/0x40
[  110.392685]  unbind_store+0x147/0x200
[  110.392688]  drv_attr_store+0x6f/0xb0
[  110.392693]  sysfs_kf_write+0x127/0x1d0
[  110.392697]  kernfs_fop_write+0x296/0x420
[  110.392702]  __vfs_write+0x66/0x110
[  110.392707]  vfs_write+0x1a0/0x500
[  110.392711]  ksys_write+0x164/0x250
[  110.392715]  __x64_sys_write+0x73/0xb0
[  110.392720]  do_syscall_64+0x9f/0x3a0
[  110.392725]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 7dee607ed0e0 ("net/mlx5: Support lockless FTE read lookups")
Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 70 ++++---------------
 .../net/ethernet/mellanox/mlx5/core/fs_core.h |  1 -
 2 files changed, 15 insertions(+), 56 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/fs_core.c
index 9a48c4310887..8c5df6c7d7b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -531,16 +531,9 @@ static void del_hw_fte(struct fs_node *node)
 	}
 }
=20
-static void del_sw_fte_rcu(struct rcu_head *head)
-{
-	struct fs_fte *fte =3D container_of(head, struct fs_fte, rcu);
-	struct mlx5_flow_steering *steering =3D get_steering(&fte->node);
-
-	kmem_cache_free(steering->ftes_cache, fte);
-}
-
 static void del_sw_fte(struct fs_node *node)
 {
+	struct mlx5_flow_steering *steering =3D get_steering(node);
 	struct mlx5_flow_group *fg;
 	struct fs_fte *fte;
 	int err;
@@ -553,8 +546,7 @@ static void del_sw_fte(struct fs_node *node)
 				     rhash_fte);
 	WARN_ON(err);
 	ida_simple_remove(&fg->fte_allocator, fte->index - fg->start_index);
-
-	call_rcu(&fte->rcu, del_sw_fte_rcu);
+	kmem_cache_free(steering->ftes_cache, fte);
 }
=20
 static void del_hw_flow_group(struct fs_node *node)
@@ -1633,47 +1625,22 @@ static u64 matched_fgs_get_version(struct list_head=
 *match_head)
 }
=20
 static struct fs_fte *
-lookup_fte_for_write_locked(struct mlx5_flow_group *g, const u32 *match_va=
lue)
+lookup_fte_locked(struct mlx5_flow_group *g,
+		  const u32 *match_value,
+		  bool take_write)
 {
 	struct fs_fte *fte_tmp;
=20
-	nested_down_write_ref_node(&g->node, FS_LOCK_PARENT);
-
-	fte_tmp =3D rhashtable_lookup_fast(&g->ftes_hash, match_value, rhash_fte)=
;
-	if (!fte_tmp || !tree_get_node(&fte_tmp->node)) {
-		fte_tmp =3D NULL;
-		goto out;
-	}
-
-	if (!fte_tmp->node.active) {
-		tree_put_node(&fte_tmp->node, false);
-		fte_tmp =3D NULL;
-		goto out;
-	}
-	nested_down_write_ref_node(&fte_tmp->node, FS_LOCK_CHILD);
-
-out:
-	up_write_ref_node(&g->node, false);
-	return fte_tmp;
-}
-
-static struct fs_fte *
-lookup_fte_for_read_locked(struct mlx5_flow_group *g, const u32 *match_val=
ue)
-{
-	struct fs_fte *fte_tmp;
-
-	if (!tree_get_node(&g->node))
-		return NULL;
-
-	rcu_read_lock();
-	fte_tmp =3D rhashtable_lookup(&g->ftes_hash, match_value, rhash_fte);
+	if (take_write)
+		nested_down_write_ref_node(&g->node, FS_LOCK_PARENT);
+	else
+		nested_down_read_ref_node(&g->node, FS_LOCK_PARENT);
+	fte_tmp =3D rhashtable_lookup_fast(&g->ftes_hash, match_value,
+					 rhash_fte);
 	if (!fte_tmp || !tree_get_node(&fte_tmp->node)) {
-		rcu_read_unlock();
 		fte_tmp =3D NULL;
 		goto out;
 	}
-	rcu_read_unlock();
-
 	if (!fte_tmp->node.active) {
 		tree_put_node(&fte_tmp->node, false);
 		fte_tmp =3D NULL;
@@ -1681,19 +1648,12 @@ lookup_fte_for_read_locked(struct mlx5_flow_group *=
g, const u32 *match_value)
 	}
=20
 	nested_down_write_ref_node(&fte_tmp->node, FS_LOCK_CHILD);
-
 out:
-	tree_put_node(&g->node, false);
-	return fte_tmp;
-}
-
-static struct fs_fte *
-lookup_fte_locked(struct mlx5_flow_group *g, const u32 *match_value, bool =
write)
-{
-	if (write)
-		return lookup_fte_for_write_locked(g, match_value);
+	if (take_write)
+		up_write_ref_node(&g->node, false);
 	else
-		return lookup_fte_for_read_locked(g, match_value);
+		up_read_ref_node(&g->node);
+	return fte_tmp;
 }
=20
 static struct mlx5_flow_handle *
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/fs_core.h
index e8cd997f413e..c2621b911563 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -203,7 +203,6 @@ struct fs_fte {
 	enum fs_fte_status		status;
 	struct mlx5_fc			*counter;
 	struct rhash_head		hash;
-	struct rcu_head	rcu;
 	int				modify_mask;
 };
=20
--=20
2.24.1

