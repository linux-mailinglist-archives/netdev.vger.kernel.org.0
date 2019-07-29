Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEB379D11
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 01:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730010AbfG2Xux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 19:50:53 -0400
Received: from mail-eopbgr130088.outbound.protection.outlook.com ([40.107.13.88]:24063
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729922AbfG2Xuu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 19:50:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AkMp93ma5NHdlfzKCqyBPih6eGgLdTmqxg1K1soCPeQ5Z9iKeVMKmTxP6o0JeOLMSl4EtxNmX9W5Roxp2+Wau4vFoUJvj0Npidfm++SAaKGwtyaqvjijCMTCg5UlvVKNTF36ZbF5WOxUiqAlHsMG8Kuupuj+ywhUNKeJJkkMgyT8ZzgipA+hq/3qeYyq9E9zQgoLtt0CEw6i+AgPQyBvPhvqQ5Lwythm4rGknBTEPbpVZg+y0ArSUCp8qzhFrYHDjHJYXaOqW0w7r96ahqhOxJzmFj5suhWIf3prETr0gMvzZoxK+H3Hk7stIer5VNW3tj+Ceq19hQhUH7ANbKBt5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ls2sMziSBxM8rzMiqLGWyqllbDDO9Rcvowrr+vRw97k=;
 b=e1hcTV+PmR2OXDufID8PSwLTxCTiG1lX7SBVQCEutEQK4esEUYaVbXkkKDCno9u/1QUnPiuu/CLB8MmwJPWb6arkOIeNGn+LEdioOL5S5P2/vYFnCVr1MI+n6NaT2gI/nXpkgeKSU+yLYmXrdZ29LicXekQt2ugNb22KwpLvR72IhFS15IAWvgw0O6UKgEfkvPfQoazQVwUxLD5f+P08QxTbS5E5edJS05aEKkwbG3mc6sd/9hVvPTIDwTUOhobSWxEBzvw1z6oJtwYQKGmlWY/85pxIUufmd7iJ/ikkzO2QKEBq1jvivzqifJTTr9347/GjUNxE5RlG9MgcCsYjwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ls2sMziSBxM8rzMiqLGWyqllbDDO9Rcvowrr+vRw97k=;
 b=GeNd0kwY54yleJCnZG+ExMbwKUMN4H0cWV966GessrZOKdrwGpZcOV059IZbQw0scj6cCNcNCeWCu+spThI03YFLjlCCRIzrdKQ1901xwPdwKoM8UJNZOASZBe5Xi/p2jVXbmhnICyVHqbIrqSJeIHV4LtvTjBLdYmj10vsojT8=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2343.eurprd05.prod.outlook.com (10.168.56.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Mon, 29 Jul 2019 23:50:31 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 23:50:31 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/13] net/mlx5e: Eswitch, change offloads num_flows type
 to atomic64
Thread-Topic: [net-next 10/13] net/mlx5e: Eswitch, change offloads num_flows
 type to atomic64
Thread-Index: AQHVRmho2OdGL6r+lE+oLJwka+afkw==
Date:   Mon, 29 Jul 2019 23:50:31 +0000
Message-ID: <20190729234934.23595-11-saeedm@mellanox.com>
References: <20190729234934.23595-1-saeedm@mellanox.com>
In-Reply-To: <20190729234934.23595-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::28) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1309ca1a-aa59-4b47-97b1-08d7147f8a72
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2343;
x-ms-traffictypediagnostic: DB6PR0501MB2343:
x-microsoft-antispam-prvs: <DB6PR0501MB2343324D8EE73ABB06741863BEDD0@DB6PR0501MB2343.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(199004)(189003)(14454004)(25786009)(71190400001)(71200400001)(386003)(6506007)(6512007)(81166006)(81156014)(76176011)(8936002)(6436002)(8676002)(6486002)(316002)(102836004)(54906003)(6916009)(7736002)(478600001)(52116002)(186003)(26005)(99286004)(14444005)(256004)(476003)(5660300002)(1076003)(66446008)(66066001)(66556008)(66476007)(64756008)(36756003)(53936002)(486006)(86362001)(305945005)(107886003)(66946007)(68736007)(446003)(2616005)(11346002)(50226002)(6116002)(3846002)(4326008)(2906002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2343;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NYFQnPjJG4XTitY6ckk6TvcKJt13mFzMgzfhjJoUUucjM6QPNvC7CiGbc73KJeYzfBgjhfP4/uo7jUMGF4CEX1KLbknxHbdB1gP8VaD68J7Vv9rQ2hEy+uNH2EAaZm2I95TI2fQgOz1LWeaiIVRZWOgLc59X69YjQ7mghs+EKLX0TELFFG3i3719/SW/3AizZjkyu+biS6fOHpLNi+EHbyFG5YmgpagPLwLfHG2pu2/EhpgYsaDyNfu+GrPJbWcybfUSXSXGXa1Rr9fZq4KS3tE9u6V9vdEt0B+O/NPSWM2NhCPjDbwRnkiaQoWrGrQzAt+TPDz3Qh3a3G5DXBgJu/pcZOWnBRwmmSYK61DJH599bVm3qeShn6tznFa+6tT0gem5wTsV1BkXlfmE45jSDTx7bPxO8IOGyouYceqWKYA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1309ca1a-aa59-4b47-97b1-08d7147f8a72
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 23:50:31.4881
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2343
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

Eswitch implements its own locking by means of state_lock mutex and
multiple fine-grained lock in containing data structures, and is supposed
to not rely on rtnl lock. However, eswitch offloads num_flows type is a
regular long long integer and cannot be modified concurrently. This is an
implicit assumptions that mlx5 tc is serialized (by rtnl lock or any other
means). In order to remove implicit dependency on rtnl lock, change
num_flows type to atomic64 to allow concurrent modifications.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c      |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h      |  3 ++-
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 10 +++++-----
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 1f3891fde2eb..d365551d2f10 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1933,6 +1933,7 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
=20
 	hash_init(esw->offloads.encap_tbl);
 	hash_init(esw->offloads.mod_hdr_tbl);
+	atomic64_set(&esw->offloads.num_flows, 0);
 	mutex_init(&esw->state_lock);
=20
 	mlx5_esw_for_all_vports(esw, i, vport) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.h
index a38e8a3c7c9a..60f0c62b447b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -35,6 +35,7 @@
=20
 #include <linux/if_ether.h>
 #include <linux/if_link.h>
+#include <linux/atomic.h>
 #include <net/devlink.h>
 #include <linux/mlx5/device.h>
 #include <linux/mlx5/eswitch.h>
@@ -179,7 +180,7 @@ struct mlx5_esw_offload {
 	struct mutex termtbl_mutex; /* protects termtbl hash */
 	const struct mlx5_eswitch_rep_ops *rep_ops[NUM_REP_TYPES];
 	u8 inline_mode;
-	u64 num_flows;
+	atomic64_t num_flows;
 	enum devlink_eswitch_encap_mode encap;
 };
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 089ae4d48a82..244ad1893691 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -233,7 +233,7 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *es=
w,
 	if (IS_ERR(rule))
 		goto err_add_rule;
 	else
-		esw->offloads.num_flows++;
+		atomic64_inc(&esw->offloads.num_flows);
=20
 	return rule;
=20
@@ -298,7 +298,7 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 	if (IS_ERR(rule))
 		goto add_err;
=20
-	esw->offloads.num_flows++;
+	atomic64_inc(&esw->offloads.num_flows);
=20
 	return rule;
 add_err:
@@ -326,7 +326,7 @@ __mlx5_eswitch_del_rule(struct mlx5_eswitch *esw,
 			mlx5_eswitch_termtbl_put(esw, attr->dests[i].termtbl);
 	}
=20
-	esw->offloads.num_flows--;
+	atomic64_dec(&esw->offloads.num_flows);
=20
 	if (fwd_rule)  {
 		esw_put_prio_table(esw, attr->chain, attr->prio, 1);
@@ -2349,7 +2349,7 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devli=
nk *devlink, u8 mode,
 		break;
 	}
=20
-	if (esw->offloads.num_flows > 0) {
+	if (atomic64_read(&esw->offloads.num_flows) > 0) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Can't set inline mode when flows are configured");
 		return -EOPNOTSUPP;
@@ -2459,7 +2459,7 @@ int mlx5_devlink_eswitch_encap_mode_set(struct devlin=
k *devlink,
 	if (esw->offloads.encap =3D=3D encap)
 		return 0;
=20
-	if (esw->offloads.num_flows > 0) {
+	if (atomic64_read(&esw->offloads.num_flows) > 0) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Can't set encapsulation when flows are configured");
 		return -EOPNOTSUPP;
--=20
2.21.0

