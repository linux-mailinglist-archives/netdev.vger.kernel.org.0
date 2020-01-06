Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E987131C77
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 00:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbgAFXgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 18:36:46 -0500
Received: from mail-eopbgr20053.outbound.protection.outlook.com ([40.107.2.53]:32391
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727315AbgAFXgq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 18:36:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ItwTYqBuYzmgrQCukirAuYI66Jzl/JM9chjoXPTfnnyczADHoGa2Ln8xwFRW5Dk2D+hf0y53P/TeuYY7nNizLdQsWYIxR/TpA+dzHkE78vrt2R7WFV+fVHfSKnII0twGLQ2id0TElwhMVEShrfl9x8Ih0VeuBmuvUS925KHxCvn8unERIeNMPJZUxV1KfYbdNr6JHB2Xe7YKjQnEfTZ9k1QlATidLE6IJbAl/WlaB6Ssj9U5qHT778eH4E0NJNl0lwqXW20qh/sqUhcQlQK5HWCko36p3Uf7sKRKZh50g61k/jYLJ5YDYtDGQkrJ66h0upOVYhva+Z0Ubtob+4gH0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JCPXvwjy2TchSoNTRqgANNwzbYQIoON24o5bAl5FDKc=;
 b=cN2VXutv4xNQ/jl9q3KhamqiGTaG+Udy1zy1/UDkrOwF14/TxsuHQMg9MaEmAE1fePPU78Tn9wUYVMDTE4jq0NX/eojGskzVSIsw1McVhDkcU6A2Cy9/HRXPK/jcoPO5uJ58w3nLCsjjlizVIRAyABtPLWTUpys4jAPl1HCPp4TQHDxoM/LqgLmSJNw/kxlFoEr20UARcG4uJ7lnCcmHxd7gNQN1cmFd7KUfTnYAE1gFFvmi14NlZgqg20NkfZBq3osHFIVxf4wzaecy/XHtEKcrEmsi0yhNdw62Ff6LT1qGk1XAkXUO9Bdm24acbj4MedSF+7d1s7PXu7zVUv881g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JCPXvwjy2TchSoNTRqgANNwzbYQIoON24o5bAl5FDKc=;
 b=Q1fNJuaA5D+dPrRco0Cz8qE2obhYpGq+1975Ed5sfzFguZl3959lMeC/9Lj+Cs4KDWiQxmqVt/27mXo58DViZZw9OYdjwo6hdOFAPhL0Hx3yFk8GUDnj4eOQ+nPfZQ+uWKPmlTN2B3IpvYFLPtgWHmLP2fg6GGpu/lgpNK8elxc=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6397.eurprd05.prod.outlook.com (20.179.25.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.15; Mon, 6 Jan 2020 23:36:33 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2602.015; Mon, 6 Jan 2020
 23:36:33 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR05CA0090.namprd05.prod.outlook.com (2603:10b6:a03:e0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.3 via Frontend Transport; Mon, 6 Jan 2020 23:36:31 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eli Cohen <eli@mellanox.com>, Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 6/7] net/mlx5e: Fix hairpin RSS table size
Thread-Topic: [net 6/7] net/mlx5e: Fix hairpin RSS table size
Thread-Index: AQHVxOohhQa5pSl6s022N+4GiZZUlA==
Date:   Mon, 6 Jan 2020 23:36:33 +0000
Message-ID: <20200106233248.58700-7-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 2e2daa37-9c58-4a03-6656-08d793014371
x-ms-traffictypediagnostic: VI1PR05MB6397:|VI1PR05MB6397:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6397B6FC9C176466EBE09C45BE3C0@VI1PR05MB6397.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0274272F87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(189003)(199004)(4326008)(5660300002)(2616005)(956004)(6916009)(54906003)(8936002)(498600001)(6512007)(26005)(107886003)(81166006)(8676002)(71200400001)(81156014)(64756008)(66946007)(66446008)(66476007)(66556008)(52116002)(6486002)(6506007)(1076003)(86362001)(36756003)(16526019)(2906002)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6397;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AZoMEqaqdCL9od5DfiWhEN/8IB/ih8hZe/KInqeidsfBq8MeWNtGIkoU+cv/9c4ethz2QayXzLWD+KsbbKwulYvKsCGkbsk4NXFq7nqZoPetLBKTyL4SyDtt5OYJgaXwvpr0Uw5iYqycXH4JGFvYya/EPm56b10LgWNfGwAXkJjfQ+2YOXpseJfhfVR4LgrkYEyID0A/BkqAbfqDIP+n7RO4l09xe/l9FoBRt1MtDaOdrQfK6lIo74JvyCWsSkNSl17iWAw8sN7JGHHYCTGQbmf80uJYd9RYsKzv71fc5gIDfevCIW39KPA0Y/CVL3RD8SkLhQQJ3j9csCVBE1KzQuO76xfHkl8pzXmvALDAl3Xq+Smb8rcxNxI091JdLbxJQvbi7per7XVu894i7zNrVxqjYXkDzp6yycpXOOOHoz0l1krIs/3KK5owyxiueW5NLJEk2pTMdKYwSRgJGmuMWDfh8K+tK/Lg3vcPYHhFEPrpTu2WUm1cBawbk2t31GawmMVZOViWRsgNL4AZj70H4uDpsTwTyPEzsz/d+ccv3iM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e2daa37-9c58-4a03-6656-08d793014371
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2020 23:36:33.5308
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iHpWwJeja8kcpIrd2HKULhkgOl0Qy1wfM3L62ZOM/rG90TmmMmohYpy6jHftI00kii7KjBjWAXL49V/hNBCZHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6397
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

Set hairpin table size to the corret size, based on the groups that
would be created in it. Groups are laid out on the table such that a
group occupies a range of entries in the table. This implies that the
group ranges should have correspondence to the table they are laid upon.

The patch cited below  made group 1's size to grow hence causing
overflow of group range laid on the table.

Fixes: a795d8db2a6d ("net/mlx5e: Support RSS for IP-in-IP and IPv6 tunneled=
 packets")
Signed-off-by: Eli Cohen <eli@mellanox.com>
Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h | 16 ++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c | 16 ----------------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c |  2 +-
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/=
ethernet/mellanox/mlx5/core/en/fs.h
index 68d593074f6c..d48292ccda29 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -122,6 +122,22 @@ enum {
 #endif
 };
=20
+#define MLX5E_TTC_NUM_GROUPS	3
+#define MLX5E_TTC_GROUP1_SIZE	(BIT(3) + MLX5E_NUM_TUNNEL_TT)
+#define MLX5E_TTC_GROUP2_SIZE	 BIT(1)
+#define MLX5E_TTC_GROUP3_SIZE	 BIT(0)
+#define MLX5E_TTC_TABLE_SIZE	(MLX5E_TTC_GROUP1_SIZE +\
+				 MLX5E_TTC_GROUP2_SIZE +\
+				 MLX5E_TTC_GROUP3_SIZE)
+
+#define MLX5E_INNER_TTC_NUM_GROUPS	3
+#define MLX5E_INNER_TTC_GROUP1_SIZE	BIT(3)
+#define MLX5E_INNER_TTC_GROUP2_SIZE	BIT(1)
+#define MLX5E_INNER_TTC_GROUP3_SIZE	BIT(0)
+#define MLX5E_INNER_TTC_TABLE_SIZE	(MLX5E_INNER_TTC_GROUP1_SIZE +\
+					 MLX5E_INNER_TTC_GROUP2_SIZE +\
+					 MLX5E_INNER_TTC_GROUP3_SIZE)
+
 #ifdef CONFIG_MLX5_EN_RXNFC
=20
 struct mlx5e_ethtool_table {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_fs.c
index 15b7f0f1427c..73d3dc07331f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -904,22 +904,6 @@ static int mlx5e_generate_ttc_table_rules(struct mlx5e=
_priv *priv,
 	return err;
 }
=20
-#define MLX5E_TTC_NUM_GROUPS	3
-#define MLX5E_TTC_GROUP1_SIZE	(BIT(3) + MLX5E_NUM_TUNNEL_TT)
-#define MLX5E_TTC_GROUP2_SIZE	 BIT(1)
-#define MLX5E_TTC_GROUP3_SIZE	 BIT(0)
-#define MLX5E_TTC_TABLE_SIZE	(MLX5E_TTC_GROUP1_SIZE +\
-				 MLX5E_TTC_GROUP2_SIZE +\
-				 MLX5E_TTC_GROUP3_SIZE)
-
-#define MLX5E_INNER_TTC_NUM_GROUPS	3
-#define MLX5E_INNER_TTC_GROUP1_SIZE	BIT(3)
-#define MLX5E_INNER_TTC_GROUP2_SIZE	BIT(1)
-#define MLX5E_INNER_TTC_GROUP3_SIZE	BIT(0)
-#define MLX5E_INNER_TTC_TABLE_SIZE	(MLX5E_INNER_TTC_GROUP1_SIZE +\
-					 MLX5E_INNER_TTC_GROUP2_SIZE +\
-					 MLX5E_INNER_TTC_GROUP3_SIZE)
-
 static int mlx5e_create_ttc_table_groups(struct mlx5e_ttc_table *ttc,
 					 bool use_ipv)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index fe83886f5435..024e1cddfd0e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -592,7 +592,7 @@ static void mlx5e_hairpin_set_ttc_params(struct mlx5e_h=
airpin *hp,
 	for (tt =3D 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
 		ttc_params->indir_tirn[tt] =3D hp->indir_tirn[tt];
=20
-	ft_attr->max_fte =3D MLX5E_NUM_TT;
+	ft_attr->max_fte =3D MLX5E_TTC_TABLE_SIZE;
 	ft_attr->level =3D MLX5E_TC_TTC_FT_LEVEL;
 	ft_attr->prio =3D MLX5E_TC_PRIO;
 }
--=20
2.24.1

