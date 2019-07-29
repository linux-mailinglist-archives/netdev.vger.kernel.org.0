Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2046F79AC5
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388514AbfG2VNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:13:24 -0400
Received: from mail-eopbgr10054.outbound.protection.outlook.com ([40.107.1.54]:2445
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388472AbfG2VNX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 17:13:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z5FnfSiZycjAaG0qFVscSP9B2vp/j+xUCuTzlKL661a7Xrub+2XzehXAm4dO7i7B70BjNGbf+ru8dTv36jtbpBa85VbIVx+GoLVl6JO2yH6LpczqiMugU0+U0hUp8SEgCbA9SHdMUyjIN/Wr4aacDskFbPKV9N0jkAFrwxxRCS2L2VXoE4DzhAt6+70nA3skwY2YQHOXmhj+pJq/W1apAOGstr/4HSkfcHjXaDC4b725Q0dQxtoZ87R4F0XyDDgplTdG9U6GDj09p5xBOlQf+AHJ+43sA44Yef79UCpfOARNHBAZpEvq99p5doKbB8NZdaqrA4yRO+mP7aSKhcNrOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I3cb+p0cbBhNE2HiO9qUVufeIq2ORh3A5ksuPEW8Tgs=;
 b=SyfZK98zzRT6S5e/KpEwGbyRltrN03ICM6/ecxlqTCRIf+Xk30FhrYx0dqKe7LbljPs2GlX1+QMTb6DgRUupFIgZU8Gu67qUB3mczkhJafAP2QHshNe7PSP4RJxCJd++oM0XREigrxbgsBEYajxIne7CnPYc6b8FVC4nV9Mz54NhFBt6pPrbU6+UucyHFFFK6AvvWKabm/9REQft3SqOqJ+UqG4D+tJ+jiRfM0JwKFefhNPX6keDkXkPkALX4JTj5spLzqKg6Swi8o+W4yWZ+FgQ1Q9hD93DxT2zDRuinWG1SIL3S97EzCp9nadUBrWqOi7iRvDcRKyWW8FxZdnIeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I3cb+p0cbBhNE2HiO9qUVufeIq2ORh3A5ksuPEW8Tgs=;
 b=pwP77nAnuaD6axbvqsiIkS5/uYG31EHz71DCLFCdL6UCuYlZRQjqlIhLD6la4d2aoAh/TIbxmbUZ9Jh9cAxQVCkagjw2e8ECr5HeQnAQszCGNwjV4sGFQPTnyergDpCJ4Exd997ngfpkOF9IJx095J90jDxOHtbLqts2nEU37Vg=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2375.eurprd05.prod.outlook.com (10.168.72.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Mon, 29 Jul 2019 21:13:04 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 21:13:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
CC:     Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 07/11] net/mlx5: E-switch, Initialize TSAR Qos
 hardware block before its user vports
Thread-Topic: [PATCH mlx5-next 07/11] net/mlx5: E-switch, Initialize TSAR Qos
 hardware block before its user vports
Thread-Index: AQHVRlJph95keMFpHE+RU8yZrj0QYQ==
Date:   Mon, 29 Jul 2019 21:13:04 +0000
Message-ID: <20190729211209.14772-8-saeedm@mellanox.com>
References: <20190729211209.14772-1-saeedm@mellanox.com>
In-Reply-To: <20190729211209.14772-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0081.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::22) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7d3dab05-4431-490e-59fd-08d714698b73
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2375;
x-ms-traffictypediagnostic: DB6PR0501MB2375:
x-microsoft-antispam-prvs: <DB6PR0501MB2375347106717B81DCE7DD4FBEDD0@DB6PR0501MB2375.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(199004)(189003)(50226002)(14444005)(5660300002)(6116002)(3846002)(486006)(446003)(86362001)(81156014)(186003)(36756003)(81166006)(8936002)(26005)(25786009)(316002)(71190400001)(71200400001)(110136005)(64756008)(76176011)(66556008)(2906002)(66946007)(66446008)(99286004)(66476007)(1076003)(386003)(6506007)(102836004)(256004)(7736002)(6486002)(14454004)(66066001)(2501003)(8676002)(305945005)(6436002)(4326008)(11346002)(68736007)(52116002)(2616005)(476003)(478600001)(6512007)(450100002)(2201001)(107886003)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2375;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: S/jL6n/2l4AK/lxdzTjeKxuV9+5MWxsk9kivSVPn8yAa8XcNsdsI/FjtgnzJPeByDjIOncDaGv/BMvaA/cFpIKa0k4/TzRJybh7rwM45K1GM58NdOJ1tK6Q73AdT20ZI1vcL3IZDtae46SBgvmkTo45xe3flUuP5XmLNNMiMFq++RSU8Pd25jTEYcLhT5Ww1ZxNwT0/ia+JmVyKc2puc/A3cM22pKfACr8o9Zc4Va+oqJ6RFKK9I9yXospPfrcuFo3Ch4x23Z+KykGTE8CyNUlT1jqYwZaPqF+UCLg/hd7gNg0S6hacZBG8YazsY8dq7/GswK2//hG66WtRS+aMKS2Lug6W+13GS9d6x5a3R5H9XwSGkdoCkRoNupEZd0/Ho+S0bO9+otKJPaD+jAAC0S1+euh8wG3hnm4RoPJNb2Ro=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d3dab05-4431-490e-59fd-08d714698b73
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 21:13:04.3067
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2375
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

First enable TSAR Qos hardware block in device before enabling its
user vports.

This refactor is needed so that vports can be enabled before their
representor netdevice can be created.

While at it, esw_create_tsar() returns error code which was used only to
print error. However esw_create_tsar() already prints warning if it hits
an error.
Hence, remove the redundant warning.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 21 ++++++++-----------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 2927fa1da92f..820970911f8b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1415,7 +1415,7 @@ static bool element_type_supported(struct mlx5_eswitc=
h *esw, int type)
 }
=20
 /* Vport QoS management */
-static int esw_create_tsar(struct mlx5_eswitch *esw)
+static void esw_create_tsar(struct mlx5_eswitch *esw)
 {
 	u32 tsar_ctx[MLX5_ST_SZ_DW(scheduling_context)] =3D {0};
 	struct mlx5_core_dev *dev =3D esw->dev;
@@ -1423,13 +1423,13 @@ static int esw_create_tsar(struct mlx5_eswitch *esw=
)
 	int err;
=20
 	if (!MLX5_CAP_GEN(dev, qos) || !MLX5_CAP_QOS(dev, esw_scheduling))
-		return 0;
+		return;
=20
 	if (!element_type_supported(esw, SCHEDULING_CONTEXT_ELEMENT_TYPE_TSAR))
-		return 0;
+		return;
=20
 	if (esw->qos.enabled)
-		return -EEXIST;
+		return;
=20
 	MLX5_SET(scheduling_context, tsar_ctx, element_type,
 		 SCHEDULING_CONTEXT_ELEMENT_TYPE_TSAR);
@@ -1443,11 +1443,10 @@ static int esw_create_tsar(struct mlx5_eswitch *esw=
)
 						 &esw->qos.root_tsar_id);
 	if (err) {
 		esw_warn(esw->dev, "E-Switch create TSAR failed (%d)\n", err);
-		return err;
+		return;
 	}
=20
 	esw->qos.enabled =3D true;
-	return 0;
 }
=20
 static void esw_destroy_tsar(struct mlx5_eswitch *esw)
@@ -1819,6 +1818,8 @@ int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int=
 mode)
 	if (!MLX5_CAP_ESW_EGRESS_ACL(esw->dev, ft_support))
 		esw_warn(esw->dev, "engress ACL is not supported by FW\n");
=20
+	esw_create_tsar(esw);
+
 	esw->mode =3D mode;
=20
 	mlx5_lag_update(esw->dev);
@@ -1836,10 +1837,6 @@ int mlx5_eswitch_enable(struct mlx5_eswitch *esw, in=
t mode)
 	if (err)
 		goto abort;
=20
-	err =3D esw_create_tsar(esw);
-	if (err)
-		esw_warn(esw->dev, "Failed to create eswitch TSAR");
-
 	enabled_events =3D (mode =3D=3D MLX5_ESWITCH_LEGACY) ? SRIOV_VPORT_EVENTS=
 :
 		UC_ADDR_CHANGE;
=20
@@ -1899,13 +1896,13 @@ void mlx5_eswitch_disable(struct mlx5_eswitch *esw)
 	if (mc_promisc && mc_promisc->uplink_rule)
 		mlx5_del_flow_rules(mc_promisc->uplink_rule);
=20
-	esw_destroy_tsar(esw);
-
 	if (esw->mode =3D=3D MLX5_ESWITCH_LEGACY)
 		esw_destroy_legacy_table(esw);
 	else if (esw->mode =3D=3D MLX5_ESWITCH_OFFLOADS)
 		esw_offloads_cleanup(esw);
=20
+	esw_destroy_tsar(esw);
+
 	old_mode =3D esw->mode;
 	esw->mode =3D MLX5_ESWITCH_NONE;
=20
--=20
2.21.0

