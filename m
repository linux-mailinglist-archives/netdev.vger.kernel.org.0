Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2217D7E3A0
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 22:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388849AbfHAT5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 15:57:11 -0400
Received: from mail-eopbgr130040.outbound.protection.outlook.com ([40.107.13.40]:64391
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388825AbfHAT5L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 15:57:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oCQLMVWL+50aHnCFDi+IdtmXwB076njs/G9J/TY/3aEOuTE5TVwoQW+t9atnSeVWY74gAoAPx8IH1EqjHjBocr+lQNZCtIGh1t6/V3ap1FyaV2L58ZJLCK5jOOHdvFC8cwMAoFq1FZ8DSZI3HiDRltPNIhaR7D8Yoz5CcmMNpubDGBXzCsFttbmPAC/XCu+FB8kal4KUo+dR7g37vSr/PamOUZwLcH1MVmb0AqkoBS7ok8jvR5vkAdKisxRKkzJEVtFZR72vg+oLEpT8WFNnxAWOn/OfQot2/msBEOVRl3i6XDqbXvMOXQoH/F6wRH5T84g2H2iwzgWj43vyuyInSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l1AGtWCwkYgwxM7BfJVsevmN9zTb2dCTkMgSFjXu1u0=;
 b=GhIlsflx0zd8oSMcwL4rnqJsTRC0mhTka/6ncwm0jC0S8q2zJzNewQeM4OGlNbIMGObq+any9Ta0gJm3gI03PNRemYfo7bPRN8TX6ZOtPH2RZMsEAE2KVSX8u8qG+CC2ZW/7cd3H3Y58b/c0DEV9vFf6PmLsIdVSln9r1rGZhwZ8gcz79QulJf11x16JeGcEZyPkLmI4CWbYeZPKv9d2p/RijIGf2gC131QrsRYSVjs3cWoZ07g1zgV1D5WqWiCk2nMNfczVLhbWLyJX1umfZkEwokaOFdxuqjJ2YhKNC/GCXJitIK+BVJ/O0/JlZeRuEFuMB2VOWnfIa6rO/PGOhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l1AGtWCwkYgwxM7BfJVsevmN9zTb2dCTkMgSFjXu1u0=;
 b=TxJ5XskGS4DJPkapqzzguU84vIquUC+vX7QgBjl+HHQqadSPa5pruuL6DEzBPafYsfHS+lKcN64l5C1CsTO1saQAuZp9rqE/gTKDgU0N9ohs1FaYIW+06+xAkrw3Fwcow9fuDxpqwOYwHkPU8Liwkqohhmm6BLGAk+oKzEhbcMg=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Thu, 1 Aug 2019 19:56:55 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Thu, 1 Aug 2019
 19:56:55 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Gavi Teitz <gavi@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 03/12] net/mlx5: Add flow counter pool
Thread-Topic: [net-next 03/12] net/mlx5: Add flow counter pool
Thread-Index: AQHVSKNFYWF8eWmvvUSOBGjyQoefiQ==
Date:   Thu, 1 Aug 2019 19:56:55 +0000
Message-ID: <20190801195620.26180-4-saeedm@mellanox.com>
References: <20190801195620.26180-1-saeedm@mellanox.com>
In-Reply-To: <20190801195620.26180-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: MWHPR22CA0034.namprd22.prod.outlook.com
 (2603:10b6:300:69::20) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 12579465-d4e5-496e-4297-08d716ba67a9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2759;
x-ms-traffictypediagnostic: DB6PR0501MB2759:
x-microsoft-antispam-prvs: <DB6PR0501MB2759B0BEBC55272E6120702ABEDE0@DB6PR0501MB2759.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 01165471DB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(71200400001)(71190400001)(5660300002)(6916009)(4326008)(107886003)(1076003)(6116002)(3846002)(476003)(486006)(256004)(14444005)(66066001)(86362001)(11346002)(446003)(25786009)(30864003)(2616005)(66446008)(64756008)(66556008)(66476007)(66946007)(478600001)(14454004)(53936002)(316002)(7736002)(6486002)(76176011)(52116002)(99286004)(54906003)(36756003)(50226002)(386003)(6506007)(102836004)(305945005)(2906002)(81166006)(81156014)(186003)(8676002)(8936002)(6512007)(68736007)(6436002)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2759;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OyskW1SsRkANSQ5V3b6gITwG6nQVT8U3f86tzJnPdAFW+0Fcm4t6+EA8EeDHXUpN5QPjKFtBFycVtX4X75yIN3IH4X4eWVyuLcFFyHpEk9JWECZnwO1T/63TobRSQ5oIHttDB6B/svmaeg7vTmOj6O9rb/E4L/wCJZ1PVEPGtm5S3gEfaDTc4+sJV7OASEqIdMNGoau1aexUNG4OFsH03XKAMEgmm1jRC/o90G9OoJYwcKwOTjLmeY5LRXq5NifwvIHS1Pb/1wurLaqU5ZL5j5HqXw7GZKrSPJNRNKN2xOMxR/1UniQ7wLbcG2Q86spmTmT35KLZJdR8s2noJvofGsqxZOm+fY0pv4lTFbsycvB/MEoqTwAWu86ODQS/4dMSEyeF6DoqYK/hvuWlcYmWuBcX7kGCIzqbDMLii01mrRU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12579465-d4e5-496e-4297-08d716ba67a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2019 19:56:55.7607
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2759
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gavi Teitz <gavi@mellanox.com>

Add a pool of flow counters, based on flow counter bulks, removing the
need to allocate a new counter via a costly FW command during the flow
creation process. The time it takes to acquire/release a flow counter
is cut from ~50 [us] to ~50 [ns].

The pool is part of the mlx5 driver instance, and provides flow
counters for aging flows. mlx5_fc_create() was modified to provide
counters for aging flows from the pool by default, and
mlx5_destroy_fc() was modified to release counters back to the pool
for later reuse. If bulk allocation is not supported or fails, and for
non-aging flows, the fallback behavior is to allocate and free
individual counters.

The pool is comprised of three lists of flow counter bulks, one of
fully used bulks, one of partially used bulks, and one of unused
bulks. Counters are provided from the partially used bulks first, to
help limit bulk fragmentation.

The pool maintains a threshold, and strives to maintain the amount of
available counters below it. The pool is increased in size when a
counter acquisition request is made and there are no available
counters, and it is decreased in size when the last counter in a bulk
is released and there are more available counters than the threshold.
All pool size changes are done in the context of the
acquiring/releasing process.

The value of the threshold is directly correlated to the amount of
used counters the pool is providing, while constrained by a hard
maximum, and is recalculated every time a bulk is allocated/freed.
This ensures that the pool only consumes large amounts of memory for
available counters if the pool is being used heavily. When fully
populated and at the hard maximum, the buffer of available counters
consumes ~40 [MB].

Signed-off-by: Gavi Teitz <gavi@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/fs_counters.c | 231 ++++++++++++++++--
 include/linux/mlx5/driver.h                   |  12 +
 2 files changed, 218 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c b/driver=
s/net/ethernet/mellanox/mlx5/core/fs_counters.c
index 3e734e62a6cd..51f1736c455d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
@@ -40,6 +40,8 @@
 #define MLX5_FC_STATS_PERIOD msecs_to_jiffies(1000)
 /* Max number of counters to query in bulk read is 32K */
 #define MLX5_SW_MAX_COUNTERS_BULK BIT(15)
+#define MLX5_FC_POOL_MAX_THRESHOLD BIT(18)
+#define MLX5_FC_POOL_USED_BUFF_RATIO 10
=20
 struct mlx5_fc_cache {
 	u64 packets;
@@ -65,6 +67,11 @@ struct mlx5_fc {
 	struct mlx5_fc_cache cache ____cacheline_aligned_in_smp;
 };
=20
+static void mlx5_fc_pool_init(struct mlx5_fc_pool *fc_pool, struct mlx5_co=
re_dev *dev);
+static void mlx5_fc_pool_cleanup(struct mlx5_fc_pool *fc_pool);
+static struct mlx5_fc *mlx5_fc_pool_acquire_counter(struct mlx5_fc_pool *f=
c_pool);
+static void mlx5_fc_pool_release_counter(struct mlx5_fc_pool *fc_pool, str=
uct mlx5_fc *fc);
+
 /* locking scheme:
  *
  * It is the responsibility of the user to prevent concurrent calls or bad
@@ -202,13 +209,22 @@ static void mlx5_fc_stats_query_counter_range(struct =
mlx5_core_dev *dev,
 	}
 }
=20
-static void mlx5_free_fc(struct mlx5_core_dev *dev,
-			 struct mlx5_fc *counter)
+static void mlx5_fc_free(struct mlx5_core_dev *dev, struct mlx5_fc *counte=
r)
 {
 	mlx5_cmd_fc_free(dev, counter->id);
 	kfree(counter);
 }
=20
+static void mlx5_fc_release(struct mlx5_core_dev *dev, struct mlx5_fc *cou=
nter)
+{
+	struct mlx5_fc_stats *fc_stats =3D &dev->priv.fc_stats;
+
+	if (counter->bulk)
+		mlx5_fc_pool_release_counter(&fc_stats->fc_pool, counter);
+	else
+		mlx5_fc_free(dev, counter);
+}
+
 static void mlx5_fc_stats_work(struct work_struct *work)
 {
 	struct mlx5_core_dev *dev =3D container_of(work, struct mlx5_core_dev,
@@ -232,7 +248,7 @@ static void mlx5_fc_stats_work(struct work_struct *work=
)
 	llist_for_each_entry_safe(counter, tmp, dellist, dellist) {
 		mlx5_fc_stats_remove(dev, counter);
=20
-		mlx5_free_fc(dev, counter);
+		mlx5_fc_release(dev, counter);
 	}
=20
 	if (time_before(now, fc_stats->next_query) ||
@@ -248,26 +264,56 @@ static void mlx5_fc_stats_work(struct work_struct *wo=
rk)
 	fc_stats->next_query =3D now + fc_stats->sampling_interval;
 }
=20
-struct mlx5_fc *mlx5_fc_create(struct mlx5_core_dev *dev, bool aging)
+static struct mlx5_fc *mlx5_fc_single_alloc(struct mlx5_core_dev *dev)
 {
-	struct mlx5_fc_stats *fc_stats =3D &dev->priv.fc_stats;
 	struct mlx5_fc *counter;
 	int err;
=20
 	counter =3D kzalloc(sizeof(*counter), GFP_KERNEL);
 	if (!counter)
 		return ERR_PTR(-ENOMEM);
-	INIT_LIST_HEAD(&counter->list);
=20
 	err =3D mlx5_cmd_fc_alloc(dev, &counter->id);
-	if (err)
-		goto err_out;
+	if (err) {
+		kfree(counter);
+		return ERR_PTR(err);
+	}
+
+	return counter;
+}
+
+static struct mlx5_fc *mlx5_fc_acquire(struct mlx5_core_dev *dev, bool agi=
ng)
+{
+	struct mlx5_fc_stats *fc_stats =3D &dev->priv.fc_stats;
+	struct mlx5_fc *counter;
+
+	if (aging && MLX5_CAP_GEN(dev, flow_counter_bulk_alloc) !=3D 0) {
+		counter =3D mlx5_fc_pool_acquire_counter(&fc_stats->fc_pool);
+		if (!IS_ERR(counter))
+			return counter;
+	}
+
+	return mlx5_fc_single_alloc(dev);
+}
+
+struct mlx5_fc *mlx5_fc_create(struct mlx5_core_dev *dev, bool aging)
+{
+	struct mlx5_fc *counter =3D mlx5_fc_acquire(dev, aging);
+	struct mlx5_fc_stats *fc_stats =3D &dev->priv.fc_stats;
+	int err;
+
+	if (IS_ERR(counter))
+		return counter;
+
+	INIT_LIST_HEAD(&counter->list);
+	counter->aging =3D aging;
=20
 	if (aging) {
 		u32 id =3D counter->id;
=20
 		counter->cache.lastuse =3D jiffies;
-		counter->aging =3D true;
+		counter->lastbytes =3D counter->cache.bytes;
+		counter->lastpackets =3D counter->cache.packets;
=20
 		idr_preload(GFP_KERNEL);
 		spin_lock(&fc_stats->counters_idr_lock);
@@ -288,10 +334,7 @@ struct mlx5_fc *mlx5_fc_create(struct mlx5_core_dev *d=
ev, bool aging)
 	return counter;
=20
 err_out_alloc:
-	mlx5_cmd_fc_free(dev, counter->id);
-err_out:
-	kfree(counter);
-
+	mlx5_fc_release(dev, counter);
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL(mlx5_fc_create);
@@ -315,7 +358,7 @@ void mlx5_fc_destroy(struct mlx5_core_dev *dev, struct =
mlx5_fc *counter)
 		return;
 	}
=20
-	mlx5_free_fc(dev, counter);
+	mlx5_fc_release(dev, counter);
 }
 EXPORT_SYMBOL(mlx5_fc_destroy);
=20
@@ -344,6 +387,7 @@ int mlx5_init_fc_stats(struct mlx5_core_dev *dev)
 	fc_stats->sampling_interval =3D MLX5_FC_STATS_PERIOD;
 	INIT_DELAYED_WORK(&fc_stats->work, mlx5_fc_stats_work);
=20
+	mlx5_fc_pool_init(&fc_stats->fc_pool, dev);
 	return 0;
=20
 err_wq_create:
@@ -358,6 +402,7 @@ void mlx5_cleanup_fc_stats(struct mlx5_core_dev *dev)
 	struct mlx5_fc *counter;
 	struct mlx5_fc *tmp;
=20
+	mlx5_fc_pool_cleanup(&fc_stats->fc_pool);
 	cancel_delayed_work_sync(&dev->priv.fc_stats.work);
 	destroy_workqueue(dev->priv.fc_stats.wq);
 	dev->priv.fc_stats.wq =3D NULL;
@@ -368,10 +413,10 @@ void mlx5_cleanup_fc_stats(struct mlx5_core_dev *dev)
=20
 	tmplist =3D llist_del_all(&fc_stats->addlist);
 	llist_for_each_entry_safe(counter, tmp, tmplist, addlist)
-		mlx5_free_fc(dev, counter);
+		mlx5_fc_release(dev, counter);
=20
 	list_for_each_entry_safe(counter, tmp, &fc_stats->counters, list)
-		mlx5_free_fc(dev, counter);
+		mlx5_fc_release(dev, counter);
 }
=20
 int mlx5_fc_query(struct mlx5_core_dev *dev, struct mlx5_fc *counter,
@@ -417,14 +462,15 @@ void mlx5_fc_update_sampling_interval(struct mlx5_cor=
e_dev *dev,
 /* Flow counter bluks */
=20
 struct mlx5_fc_bulk {
+	struct list_head pool_list;
 	u32 base_id;
 	int bulk_len;
 	unsigned long *bitmask;
 	struct mlx5_fc fcs[0];
 };
=20
-static void
-mlx5_fc_init(struct mlx5_fc *counter, struct mlx5_fc_bulk *bulk, u32 id)
+static void mlx5_fc_init(struct mlx5_fc *counter, struct mlx5_fc_bulk *bul=
k,
+			 u32 id)
 {
 	counter->bulk =3D bulk;
 	counter->id =3D id;
@@ -435,8 +481,7 @@ static int mlx5_fc_bulk_get_free_fcs_amount(struct mlx5=
_fc_bulk *bulk)
 	return bitmap_weight(bulk->bitmask, bulk->bulk_len);
 }
=20
-static struct mlx5_fc_bulk __attribute__((unused))
-*mlx5_fc_bulk_create(struct mlx5_core_dev *dev)
+static struct mlx5_fc_bulk *mlx5_fc_bulk_create(struct mlx5_core_dev *dev)
 {
 	enum mlx5_fc_bulk_alloc_bitmask alloc_bitmask;
 	struct mlx5_fc_bulk *bulk;
@@ -479,7 +524,7 @@ static struct mlx5_fc_bulk __attribute__((unused))
 	return ERR_PTR(err);
 }
=20
-static int __attribute__((unused))
+static int
 mlx5_fc_bulk_destroy(struct mlx5_core_dev *dev, struct mlx5_fc_bulk *bulk)
 {
 	if (mlx5_fc_bulk_get_free_fcs_amount(bulk) < bulk->bulk_len) {
@@ -494,8 +539,7 @@ mlx5_fc_bulk_destroy(struct mlx5_core_dev *dev, struct =
mlx5_fc_bulk *bulk)
 	return 0;
 }
=20
-static struct mlx5_fc __attribute__((unused))
-*mlx5_fc_bulk_acquire_fc(struct mlx5_fc_bulk *bulk)
+static struct mlx5_fc *mlx5_fc_bulk_acquire_fc(struct mlx5_fc_bulk *bulk)
 {
 	int free_fc_index =3D find_first_bit(bulk->bitmask, bulk->bulk_len);
=20
@@ -506,8 +550,7 @@ static struct mlx5_fc __attribute__((unused))
 	return &bulk->fcs[free_fc_index];
 }
=20
-static int __attribute__((unused))
-mlx5_fc_bulk_release_fc(struct mlx5_fc_bulk *bulk, struct mlx5_fc *fc)
+static int mlx5_fc_bulk_release_fc(struct mlx5_fc_bulk *bulk, struct mlx5_=
fc *fc)
 {
 	int fc_index =3D fc->id - bulk->base_id;
=20
@@ -517,3 +560,141 @@ mlx5_fc_bulk_release_fc(struct mlx5_fc_bulk *bulk, st=
ruct mlx5_fc *fc)
 	set_bit(fc_index, bulk->bitmask);
 	return 0;
 }
+
+/* Flow counters pool API */
+
+static void mlx5_fc_pool_init(struct mlx5_fc_pool *fc_pool, struct mlx5_co=
re_dev *dev)
+{
+	fc_pool->dev =3D dev;
+	mutex_init(&fc_pool->pool_lock);
+	INIT_LIST_HEAD(&fc_pool->fully_used);
+	INIT_LIST_HEAD(&fc_pool->partially_used);
+	INIT_LIST_HEAD(&fc_pool->unused);
+	fc_pool->available_fcs =3D 0;
+	fc_pool->used_fcs =3D 0;
+	fc_pool->threshold =3D 0;
+}
+
+static void mlx5_fc_pool_cleanup(struct mlx5_fc_pool *fc_pool)
+{
+	struct mlx5_core_dev *dev =3D fc_pool->dev;
+	struct mlx5_fc_bulk *bulk;
+	struct mlx5_fc_bulk *tmp;
+
+	list_for_each_entry_safe(bulk, tmp, &fc_pool->fully_used, pool_list)
+		mlx5_fc_bulk_destroy(dev, bulk);
+	list_for_each_entry_safe(bulk, tmp, &fc_pool->partially_used, pool_list)
+		mlx5_fc_bulk_destroy(dev, bulk);
+	list_for_each_entry_safe(bulk, tmp, &fc_pool->unused, pool_list)
+		mlx5_fc_bulk_destroy(dev, bulk);
+}
+
+static void mlx5_fc_pool_update_threshold(struct mlx5_fc_pool *fc_pool)
+{
+	fc_pool->threshold =3D min_t(int, MLX5_FC_POOL_MAX_THRESHOLD,
+				   fc_pool->used_fcs / MLX5_FC_POOL_USED_BUFF_RATIO);
+}
+
+static struct mlx5_fc_bulk *
+mlx5_fc_pool_alloc_new_bulk(struct mlx5_fc_pool *fc_pool)
+{
+	struct mlx5_core_dev *dev =3D fc_pool->dev;
+	struct mlx5_fc_bulk *new_bulk;
+
+	new_bulk =3D mlx5_fc_bulk_create(dev);
+	if (!IS_ERR(new_bulk))
+		fc_pool->available_fcs +=3D new_bulk->bulk_len;
+	mlx5_fc_pool_update_threshold(fc_pool);
+	return new_bulk;
+}
+
+static void
+mlx5_fc_pool_free_bulk(struct mlx5_fc_pool *fc_pool, struct mlx5_fc_bulk *=
bulk)
+{
+	struct mlx5_core_dev *dev =3D fc_pool->dev;
+
+	fc_pool->available_fcs -=3D bulk->bulk_len;
+	mlx5_fc_bulk_destroy(dev, bulk);
+	mlx5_fc_pool_update_threshold(fc_pool);
+}
+
+static struct mlx5_fc *
+mlx5_fc_pool_acquire_from_list(struct list_head *src_list,
+			       struct list_head *next_list,
+			       bool move_non_full_bulk)
+{
+	struct mlx5_fc_bulk *bulk;
+	struct mlx5_fc *fc;
+
+	if (list_empty(src_list))
+		return ERR_PTR(-ENODATA);
+
+	bulk =3D list_first_entry(src_list, struct mlx5_fc_bulk, pool_list);
+	fc =3D mlx5_fc_bulk_acquire_fc(bulk);
+	if (move_non_full_bulk || mlx5_fc_bulk_get_free_fcs_amount(bulk) =3D=3D 0=
)
+		list_move(&bulk->pool_list, next_list);
+	return fc;
+}
+
+static struct mlx5_fc *
+mlx5_fc_pool_acquire_counter(struct mlx5_fc_pool *fc_pool)
+{
+	struct mlx5_fc_bulk *new_bulk;
+	struct mlx5_fc *fc;
+
+	mutex_lock(&fc_pool->pool_lock);
+
+	fc =3D mlx5_fc_pool_acquire_from_list(&fc_pool->partially_used,
+					    &fc_pool->fully_used, false);
+	if (IS_ERR(fc))
+		fc =3D mlx5_fc_pool_acquire_from_list(&fc_pool->unused,
+						    &fc_pool->partially_used,
+						    true);
+	if (IS_ERR(fc)) {
+		new_bulk =3D mlx5_fc_pool_alloc_new_bulk(fc_pool);
+		if (IS_ERR(new_bulk)) {
+			fc =3D ERR_CAST(new_bulk);
+			goto out;
+		}
+		fc =3D mlx5_fc_bulk_acquire_fc(new_bulk);
+		list_add(&new_bulk->pool_list, &fc_pool->partially_used);
+	}
+	fc_pool->available_fcs--;
+	fc_pool->used_fcs++;
+
+out:
+	mutex_unlock(&fc_pool->pool_lock);
+	return fc;
+}
+
+static void
+mlx5_fc_pool_release_counter(struct mlx5_fc_pool *fc_pool, struct mlx5_fc =
*fc)
+{
+	struct mlx5_core_dev *dev =3D fc_pool->dev;
+	struct mlx5_fc_bulk *bulk =3D fc->bulk;
+	int bulk_free_fcs_amount;
+
+	mutex_lock(&fc_pool->pool_lock);
+
+	if (mlx5_fc_bulk_release_fc(bulk, fc)) {
+		mlx5_core_warn(dev, "Attempted to release a counter which is not acquire=
d\n");
+		goto unlock;
+	}
+
+	fc_pool->available_fcs++;
+	fc_pool->used_fcs--;
+
+	bulk_free_fcs_amount =3D mlx5_fc_bulk_get_free_fcs_amount(bulk);
+	if (bulk_free_fcs_amount =3D=3D 1)
+		list_move_tail(&bulk->pool_list, &fc_pool->partially_used);
+	if (bulk_free_fcs_amount =3D=3D bulk->bulk_len) {
+		list_del(&bulk->pool_list);
+		if (fc_pool->available_fcs > fc_pool->threshold)
+			mlx5_fc_pool_free_bulk(fc_pool, bulk);
+		else
+			list_add(&bulk->pool_list, &fc_pool->unused);
+	}
+
+unlock:
+	mutex_unlock(&fc_pool->pool_lock);
+}
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 267b2bc0ca4a..d8f348ef9c33 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -477,6 +477,17 @@ struct mlx5_core_sriov {
 	u16			max_vfs;
 };
=20
+struct mlx5_fc_pool {
+	struct mlx5_core_dev *dev;
+	struct mutex pool_lock; /* protects pool lists */
+	struct list_head fully_used;
+	struct list_head partially_used;
+	struct list_head unused;
+	int available_fcs;
+	int used_fcs;
+	int threshold;
+};
+
 struct mlx5_fc_stats {
 	spinlock_t counters_idr_lock; /* protects counters_idr */
 	struct idr counters_idr;
@@ -489,6 +500,7 @@ struct mlx5_fc_stats {
 	unsigned long next_query;
 	unsigned long sampling_interval; /* jiffies */
 	u32 *bulk_query_out;
+	struct mlx5_fc_pool fc_pool;
 };
=20
 struct mlx5_events;
--=20
2.21.0

