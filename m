Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97A77987D7
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 01:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731462AbfHUX2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 19:28:46 -0400
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:35598
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730432AbfHUX2p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 19:28:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cvn/SHqKPrNkI7UeLHH9Ns3eIjCm0wcyYbBET58noubugLNxi7BasuQdJbfMQ1FZ9rWGhbgRqg26yt9voPsAYIX7RICk2yXHfzuI1I4ZN/6meQjCGKCrkzHFehNjGgYRiknFF8MijYMT/q5crIC2yXxiGcPlKC1u7RpFSBkshxwp5dlFk+U7b8QUNMOQjDvmr/cXmYny9IBIc8+v5xskH7x/alMd1WEj/0W5TG8GOTeM+2x/KQQOLZ9ikNJ8ErY9MneQl4JBXGJ8K/YL2y1Nkauijwv2GC40ua5jsUBTqREpxVZ5rL7Wfr/6E2sRnaUR5gRUGX3JYhxr+241Vzh3og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4QHlqT758gHY+TTD9TJx2VJXDMI3s72W61RIkqaLbmQ=;
 b=ZRUzMAr9wY/cWuhASV9Zp3dejIjaG3sZ6tgHm+gT07cnAEmS+3AXwPlLxKYfqdqHp6w1RkDmv1YTKwuFF3eAvg9yICSdPf1iE79MwfDj0QQA7m39RM0yd7ka0ooQg+9kkQNQwLuTr9uCnxuBJ3IElFw6l+0/m4mqS7vJREdmvJU47hCQKOAXweN3fMPbfaoo0m+ykYCjBC3LQYMT00j+Q/LSWdYarzHYR8F0HlG4PV3Sy4DFjUPeoF/cJ99Ya85HW/hFKsRJkH0Xy5L25HBQdInRTKGgm2uXlS5ugfdpVjXGbXWExxo0g9R5HJoaRv1wfUOFF/XM2dV3h2jIoLlLYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4QHlqT758gHY+TTD9TJx2VJXDMI3s72W61RIkqaLbmQ=;
 b=LXQJ5GPYblw4fFnSLWpvmbIZo1ofynECzzBHJb5Oymt0pAEVJw4Gy9cD8zg4wEue+QxvtP7nYA28Ay//Tg58M5vIF/ZLiXTWZXLy/tXrrBxH2UjYFJrzDt/l9mHYm7ozV90oGEhtRKsLCmq7h1EVwqedz+rAXra3NiKEUn8GPlU=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2674.eurprd05.prod.outlook.com (10.172.221.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 21 Aug 2019 23:28:40 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2178.020; Wed, 21 Aug 2019
 23:28:40 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 04/11] net/mlx5e: Refactor
 mlx5e_neigh_update_table->encap_lock
Thread-Topic: [net-next 04/11] net/mlx5e: Refactor
 mlx5e_neigh_update_table->encap_lock
Thread-Index: AQHVWHgq9fi+1cFcy0CGimaHZshRaw==
Date:   Wed, 21 Aug 2019 23:28:40 +0000
Message-ID: <20190821232806.21847-5-saeedm@mellanox.com>
References: <20190821232806.21847-1-saeedm@mellanox.com>
In-Reply-To: <20190821232806.21847-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0032.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::45) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 07a3f339-220b-4508-c470-08d7268f4c7c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR0501MB2674;
x-ms-traffictypediagnostic: AM4PR0501MB2674:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB26749731F8813304E7BD449ABEAA0@AM4PR0501MB2674.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(50226002)(5660300002)(6512007)(86362001)(3846002)(6116002)(305945005)(14444005)(66946007)(66556008)(7736002)(66476007)(256004)(66446008)(64756008)(66066001)(1076003)(71200400001)(71190400001)(5024004)(4326008)(478600001)(6916009)(8936002)(6486002)(107886003)(2906002)(2616005)(81156014)(81166006)(8676002)(476003)(6506007)(386003)(99286004)(52116002)(26005)(486006)(53936002)(76176011)(316002)(36756003)(25786009)(186003)(54906003)(14454004)(102836004)(446003)(6436002)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2674;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: p91tN6hhjXuyGkE4fbDzonmepaLI1z0fJC1isXOaJvep1QW25On56gpsB5P6lbjSfGB88qpMTTb/LVAQraAGG6fWIOPOAsOtz86ESj6ifrkKrio399FP3WE10ueJaqxb4nArZcBR69YydFf3NkbXrqjyh4ZYGxD274xY5WUt7NIbePpRC9u8mW6BLjUmta66MHhlTbiCo5xOChEcOKd8KtiPlBDvgf2+BFQ+oW5+HX21iLBgHDMJfMY7EeHI55GmlkoFaQN2ove0ymvH1wamgaFUuhX0a/tnlPhp9LkLHAPTnncfUzrC0eZ+lUPvAnh8KLx5ZhuR0JlkkSinHTkxY20rAbLeXdU0B/tWcH4cGopz4BwWbbYi052344IB+QDXgqR4evpxrRrULvVxjyYjSPosZgCcJrvvEqBxjDG8bg8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07a3f339-220b-4508-c470-08d7268f4c7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 23:28:40.3787
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r7EKoiVCoBD9z/Lh9Pfdp/iOWxurfZPN7HV5oEOhOUJdj1zddyt/WXIh61mD3WpDb5PejZBKgh/SW4ejYgB94g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2674
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

To remove dependency on rtnl lock, always take neigh update encap lock when
modifying neigh update hash table and list. Originally, this lock was only
used to synchronize with netevent handler function, which is called from bh
context and cannot use rtnl lock for synchronization. Take lock in encap
entry attach function to prevent concurrent modifications of neigh update
hash table and list.

Taking the encap lock when creating new nhe introduces a problem that we
need to allocate new entry with sleeping GFP_KERNEL flag while holding a
spinlock. However, since previous patch in this series has already
converted lookup in netevent handler function to user rcu read lock instead
of encap lock, we can safely convert the lock type to mutex.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c    | 17 ++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/en_rep.h    |  3 ++-
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.c
index a294dc6b5a0c..218772d5c062 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -973,7 +973,7 @@ static int mlx5e_rep_neigh_init(struct mlx5e_rep_priv *=
rpriv)
 		return err;
=20
 	INIT_LIST_HEAD(&neigh_update->neigh_list);
-	spin_lock_init(&neigh_update->encap_lock);
+	mutex_init(&neigh_update->encap_lock);
 	INIT_DELAYED_WORK(&neigh_update->neigh_stats_work,
 			  mlx5e_rep_neigh_stats_work);
 	mlx5e_rep_neigh_update_init_interval(rpriv);
@@ -1000,6 +1000,7 @@ static void mlx5e_rep_neigh_cleanup(struct mlx5e_rep_=
priv *rpriv)
=20
 	cancel_delayed_work_sync(&rpriv->neigh_update.neigh_stats_work);
=20
+	mutex_destroy(&neigh_update->encap_lock);
 	rhashtable_destroy(&neigh_update->neigh_ht);
 }
=20
@@ -1024,18 +1025,18 @@ static void mlx5e_rep_neigh_entry_remove(struct mlx=
5e_neigh_hash_entry *nhe)
 {
 	struct mlx5e_rep_priv *rpriv =3D nhe->priv->ppriv;
=20
-	spin_lock_bh(&rpriv->neigh_update.encap_lock);
+	mutex_lock(&rpriv->neigh_update.encap_lock);
=20
 	list_del_rcu(&nhe->neigh_list);
=20
 	rhashtable_remove_fast(&rpriv->neigh_update.neigh_ht,
 			       &nhe->rhash_node,
 			       mlx5e_neigh_ht_params);
-	spin_unlock_bh(&rpriv->neigh_update.encap_lock);
+	mutex_unlock(&rpriv->neigh_update.encap_lock);
 }
=20
-/* This function must only be called under RTNL lock or under the
- * representor's encap_lock in case RTNL mutex can't be held.
+/* This function must only be called under the representor's encap_lock or
+ * inside rcu read lock section.
  */
 static struct mlx5e_neigh_hash_entry *
 mlx5e_rep_neigh_entry_lookup(struct mlx5e_priv *priv,
@@ -1088,17 +1089,23 @@ int mlx5e_rep_encap_entry_attach(struct mlx5e_priv =
*priv,
 	err =3D mlx5_tun_entropy_refcount_inc(tun_entropy, e->reformat_type);
 	if (err)
 		return err;
+
+	mutex_lock(&rpriv->neigh_update.encap_lock);
 	nhe =3D mlx5e_rep_neigh_entry_lookup(priv, &e->m_neigh);
 	if (!nhe) {
 		err =3D mlx5e_rep_neigh_entry_create(priv, e, &nhe);
 		if (err) {
+			mutex_unlock(&rpriv->neigh_update.encap_lock);
 			mlx5_tun_entropy_refcount_dec(tun_entropy,
 						      e->reformat_type);
 			return err;
 		}
 	}
+
 	e->nhe =3D nhe;
 	list_add(&e->encap_list, &nhe->encap_list);
+	mutex_unlock(&rpriv->neigh_update.encap_lock);
+
 	return 0;
 }
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.h
index d057e401b0de..8fa27832bd81 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -35,6 +35,7 @@
=20
 #include <net/ip_tunnels.h>
 #include <linux/rhashtable.h>
+#include <linux/mutex.h>
 #include "eswitch.h"
 #include "en.h"
 #include "lib/port_tun.h"
@@ -48,7 +49,7 @@ struct mlx5e_neigh_update_table {
 	 */
 	struct list_head	neigh_list;
 	/* protect lookup/remove operations */
-	spinlock_t              encap_lock;
+	struct mutex		encap_lock;
 	struct notifier_block   netevent_nb;
 	struct delayed_work     neigh_stats_work;
 	unsigned long           min_interval; /* jiffies */
--=20
2.21.0

