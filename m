Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79A095DF07
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 09:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbfGCHjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 03:39:33 -0400
Received: from mail-eopbgr00088.outbound.protection.outlook.com ([40.107.0.88]:30325
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727134AbfGCHjd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 03:39:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zn86HiLqa3Hg6VVVOmEKxZOGGFlUk+KJ22UmCSt6k8A=;
 b=PvTbMv3/P+5ikohWps2F1C4NmMd+5/yHHVJc+odoi3Vx0XpgOSXReu+WFCLkKE9xv4+9kzEheAI61QCJW33prfhk2aqm0h/AtgWvRX6wWe5xPlHOnWNi5C/ZzNJDrgCpG8ERWGnmqurQLnoDEcpc648u//CiBJfXoxjnD3pq4Ok=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2309.eurprd05.prod.outlook.com (10.168.55.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Wed, 3 Jul 2019 07:39:28 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c%4]) with mapi id 15.20.2032.019; Wed, 3 Jul 2019
 07:39:28 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 2/5] net/mlx5: E-Switch prepare functions change
 handler to be modular
Thread-Topic: [PATCH mlx5-next 2/5] net/mlx5: E-Switch prepare functions
 change handler to be modular
Thread-Index: AQHVMXJxXtOfVAOYN0mtQ7EGhXZ0vg==
Date:   Wed, 3 Jul 2019 07:39:28 +0000
Message-ID: <20190703073909.14965-3-saeedm@mellanox.com>
References: <20190703073909.14965-1-saeedm@mellanox.com>
In-Reply-To: <20190703073909.14965-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:a03:54::23) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b00d143-f5cb-4d9f-5748-08d6ff899410
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2309;
x-ms-traffictypediagnostic: DB6PR0501MB2309:
x-microsoft-antispam-prvs: <DB6PR0501MB2309B40DF95D71806EF6F741BEFB0@DB6PR0501MB2309.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1303;
x-forefront-prvs: 00872B689F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(199004)(189003)(66556008)(66946007)(66446008)(6512007)(64756008)(73956011)(66476007)(107886003)(5660300002)(1076003)(52116002)(54906003)(71200400001)(2906002)(66066001)(256004)(99286004)(76176011)(14444005)(3846002)(7736002)(6116002)(53936002)(6436002)(71190400001)(4326008)(6486002)(68736007)(81156014)(110136005)(305945005)(26005)(36756003)(316002)(2616005)(50226002)(8676002)(478600001)(476003)(8936002)(25786009)(86362001)(486006)(450100002)(386003)(6506007)(81166006)(186003)(11346002)(446003)(14454004)(6636002)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2309;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ck/MnoEOiR3TfbFbcGFPbo1WaO5CoCV51h93DDxzDvPeL6uZH82pxPSZ9d4ilejiv11hXiSwv4LWH9O6rCdNdCNiiP0IAimYMMpwbLd6gU8TqynvPIMZEB4RhZg61FELp53Bc+lwJ5Xoa0zIRzlcg74IFweW3l1JG3G3bmdEc5AGc0NwXbkMC11yWAx8o1prFwsem+a37bFe7eHeeynSjG0RkpKoknCa/91r1HRk4YB1ciivehRS1UMIXiE6+7gLZAQkWWczGgdEYgXAqcVVdE7xNPEbHmO1fFSt0OJTK5TvEWURIa5PzSyrnBzngupSQCuCv6RjgsnZdyGL0uA7i89XdFhic7reBUmnp4aN6IUKoWP2WFvmOy2TYzWprgaEXBDuFbPWkBG30ZN8+QrmGK+AyvH4zU2SW25gNLQJ2pQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b00d143-f5cb-4d9f-5748-08d6ff899410
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2019 07:39:28.3838
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2309
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Eswitch function change handler will service multiple type of events for
VFs and non VF functions update.
Hence, introduce and use the helper function
esw_vfs_changed_event_handler() for handling change in num VFs to improve
the code readability.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 44 ++++++++++++-------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 5c8fb2597bfa..42c0db585561 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2046,38 +2046,48 @@ static void esw_offloads_steering_cleanup(struct ml=
x5_eswitch *esw)
 	esw_destroy_offloads_acl_tables(esw);
 }
=20
-static void esw_functions_changed_event_handler(struct work_struct *work)
+static void
+esw_vfs_changed_event_handler(struct mlx5_eswitch *esw, const u32 *out)
 {
-	u32 out[MLX5_ST_SZ_DW(query_esw_functions_out)] =3D {};
-	struct mlx5_host_work *host_work;
-	struct mlx5_eswitch *esw;
 	bool host_pf_disabled;
-	u16 num_vfs =3D 0;
-	int err;
-
-	host_work =3D container_of(work, struct mlx5_host_work, work);
-	esw =3D host_work->esw;
+	u16 new_num_vfs;
=20
-	err =3D mlx5_esw_query_functions(esw->dev, out, sizeof(out));
-	num_vfs =3D MLX5_GET(query_esw_functions_out, out,
-			   host_params_context.host_num_of_vfs);
+	new_num_vfs =3D MLX5_GET(query_esw_functions_out, out,
+			       host_params_context.host_num_of_vfs);
 	host_pf_disabled =3D MLX5_GET(query_esw_functions_out, out,
 				    host_params_context.host_pf_disabled);
-	if (err || host_pf_disabled || num_vfs =3D=3D esw->esw_funcs.num_vfs)
-		goto out;
+
+	if (new_num_vfs =3D=3D esw->esw_funcs.num_vfs || host_pf_disabled)
+		return;
=20
 	/* Number of VFs can only change from "0 to x" or "x to 0". */
 	if (esw->esw_funcs.num_vfs > 0) {
 		esw_offloads_unload_vf_reps(esw, esw->esw_funcs.num_vfs);
 	} else {
-		err =3D esw_offloads_load_vf_reps(esw, num_vfs);
+		int err;
=20
+		err =3D esw_offloads_load_vf_reps(esw, new_num_vfs);
 		if (err)
-			goto out;
+			return;
 	}
+	esw->esw_funcs.num_vfs =3D new_num_vfs;
+}
+
+static void esw_functions_changed_event_handler(struct work_struct *work)
+{
+	u32 out[MLX5_ST_SZ_DW(query_esw_functions_out)] =3D {};
+	struct mlx5_host_work *host_work;
+	struct mlx5_eswitch *esw;
+	int err;
+
+	host_work =3D container_of(work, struct mlx5_host_work, work);
+	esw =3D host_work->esw;
=20
-	esw->esw_funcs.num_vfs =3D num_vfs;
+	err =3D mlx5_esw_query_functions(esw->dev, out, sizeof(out));
+	if (err)
+		goto out;
=20
+	esw_vfs_changed_event_handler(esw, out);
 out:
 	kfree(host_work);
 }
--=20
2.21.0

