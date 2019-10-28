Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75B64E7D00
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 00:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732048AbfJ1Xf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 19:35:29 -0400
Received: from mail-eopbgr140084.outbound.protection.outlook.com ([40.107.14.84]:57509
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731587AbfJ1Xf2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 19:35:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Im8VPR5DKUTGSzGcH+ckWqYyWNpnLXYDYyY/j+Ga3f7gehDHRBImQie4vb2bJE4d6baNp9MgByquxAZ+sHMRHcZY2IaOtyy7hArgcHH0eoVKsi/t2UI0o2Lej7bBbbItSTDmZFvsO8MSM5Pqe+BYXXn9dqL1CcZOgw2jXbfIjySM6Wq1V8IyP6kXFdp+cjti1bl/2kdM1RAhDe8jTjkvIABk+qxJlUF28VOBpuYy50BZ738hxn7Ja1ZycXh8+vKuNjUx8meSOK7qJxor0kmH6uWeCv6yfV+mzdifdcVXpDDeXFNzYe4EzV+VmMYJRmuwLZ4MihfU+z0APeypJU37Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cIpwDeKTAPRLC9eBA+hNQuLKBJVSf3+yHXypPup+2EU=;
 b=BGj/tPcOe5beaQy4ln/YaAsqr5Wx87I2quKUX/HihRBsETkXA8/JHdx5S8g0yYsLQodAm0th8z6ZGhQ0j/AaWJdMN3uTqJcUbVShij9sgNyiS5Q19woKmDxX6KdBa0xTkWwK2+mtr0blYfru8Kw6f5CGkLzXvoVWAfKxLhXYe3h75qE1AWkQweeR/FrUWnr9dhnl9+yJbpHtgFZCg6Y57EDB7/w5OveBNefIp7T2py9dTz10Hn4OnJIw8wFK1a41qpykClg+WRN2lpEuOCGP3FMGlEZV1uD3JIsiR8Ey0TyiP0hSBTLjZHDq855fzG0oe9c3rBRgcxAk8sEBKx1hfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cIpwDeKTAPRLC9eBA+hNQuLKBJVSf3+yHXypPup+2EU=;
 b=WQkd74JQC+7eM7/F+5jdi+TqIZrFBF/XI7P0nU+9zqvY/cLFh8oglKVmJNyyE30/YkIVKBVJpEm+p1EpBDZOx0nK+9pGrsLwgxhZOaQvSEPxUIzM55y5JWf8w5lng1tP3Hs/0/F9LUPWvAwh1hOK84znNKNdTgEq9QjBB8X4WLU=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6413.eurprd05.prod.outlook.com (20.179.27.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Mon, 28 Oct 2019 23:35:24 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2387.027; Mon, 28 Oct 2019
 23:35:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>
Subject: [PATCH mlx5-next 15/18] net/mlx5: Restrict metadata disablement to
 offloads mode
Thread-Topic: [PATCH mlx5-next 15/18] net/mlx5: Restrict metadata disablement
 to offloads mode
Thread-Index: AQHVjehfsQfgGdWh20mfbouKlOlwiQ==
Date:   Mon, 28 Oct 2019 23:35:24 +0000
Message-ID: <20191028233440.5564-16-saeedm@mellanox.com>
References: <20191028233440.5564-1-saeedm@mellanox.com>
In-Reply-To: <20191028233440.5564-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:a03:180::34) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0cab6245-e5ea-4f84-a7dc-08d75bff8196
x-ms-traffictypediagnostic: VI1PR05MB6413:|VI1PR05MB6413:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6413866AA04495623313F013BE660@VI1PR05MB6413.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:785;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(199004)(189003)(71200400001)(256004)(316002)(6636002)(14444005)(2906002)(6436002)(446003)(8936002)(50226002)(11346002)(6486002)(8676002)(486006)(14454004)(110136005)(36756003)(81166006)(6116002)(81156014)(54906003)(3846002)(86362001)(7736002)(66066001)(99286004)(450100002)(102836004)(6512007)(1076003)(5660300002)(6506007)(4326008)(478600001)(386003)(476003)(186003)(26005)(66476007)(66556008)(64756008)(66946007)(66446008)(305945005)(76176011)(71190400001)(52116002)(107886003)(25786009)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6413;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L3DBTqln3gLLt0JY4yu7tbtgWIObrDMxOtLKfJdNW5qDRC9Frwmii2oMPUCQ9KtRSTowf/Vvb7w4jvjRHd8fNYwg1Z4m0rEkCHPKztYZxnzQMlW1o33/rmrPU17R9SakJ/x9iJDkdjyN7r3HmOBxbRJb8XVb0TaQiDxRMuXXRzp6TeMPFSs+pc4cM7NGVvDkg8x0nvZOQpMJOEQGppz8JgUh7BXC5lbQp5Rmjwp9vfzgXYzFsvMZQgntMBozszy78VPalpliUiBwNmFU8WDowQaMhvl8L+FDToA4Qd84Ztnulz0acvurS1xS08ChaDZWRt9WyRG10Qr82vvzmD4uxP9bbY4Yu12vsWsChDOffF4KBlk5TgyLNmMpdHnFBvHICAZTfdo90Kv7Pgb4AIQZ/r/ED4Yu9s/LodUSdmq1WGebyTkTEdpZ7VWoW9PrZr1n
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cab6245-e5ea-4f84-a7dc-08d75bff8196
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 23:35:24.6965
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rHLJhquKHW2HPKAipFLbCPyYY942kG9YYwUm9+hzNiYXC1TCD0/vg8HBpiPz5YEuttHEzofJvN0DqUJLrvcMjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6413
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Now that there is clear separation for acl setup/cleanup between legacy
and offloads mode, limit metdata disablement to offloads mode.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Vu Pham <vuhuong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c        | 2 --
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h        | 2 --
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c   | 9 ++++++---
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 1ce6ae1c446e..61459c06f56c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1214,8 +1214,6 @@ void esw_vport_cleanup_ingress_rules(struct mlx5_eswi=
tch *esw,
 		mlx5_del_flow_rules(vport->ingress.allow_rule);
 		vport->ingress.allow_rule =3D NULL;
 	}
-
-	esw_vport_del_ingress_acl_modify_metadata(esw, vport);
 }
=20
 void esw_vport_disable_ingress_acl(struct mlx5_eswitch *esw,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.h
index d926bdacbdcc..aa3588446cba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -267,8 +267,6 @@ void esw_vport_disable_egress_acl(struct mlx5_eswitch *=
esw,
 				  struct mlx5_vport *vport);
 void esw_vport_disable_ingress_acl(struct mlx5_eswitch *esw,
 				   struct mlx5_vport *vport);
-void esw_vport_del_ingress_acl_modify_metadata(struct mlx5_eswitch *esw,
-					       struct mlx5_vport *vport);
 int mlx5_esw_modify_vport_rate(struct mlx5_eswitch *esw, u16 vport_num,
 			       u32 rate_mbps);
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index ce30ead90617..b536c8fa0061 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1847,8 +1847,8 @@ static int esw_vport_add_ingress_acl_modify_metadata(=
struct mlx5_eswitch *esw,
 	return err;
 }
=20
-void esw_vport_del_ingress_acl_modify_metadata(struct mlx5_eswitch *esw,
-					       struct mlx5_vport *vport)
+static void esw_vport_del_ingress_acl_modify_metadata(struct mlx5_eswitch =
*esw,
+						      struct mlx5_vport *vport)
 {
 	if (vport->ingress.offloads.modify_metadata_rule) {
 		mlx5_del_flow_rules(vport->ingress.offloads.modify_metadata_rule);
@@ -1962,8 +1962,10 @@ esw_vport_create_offloads_acl_tables(struct mlx5_esw=
itch *esw,
=20
 	if (mlx5_eswitch_is_vf_vport(esw, vport->vport)) {
 		err =3D esw_vport_egress_config(esw, vport);
-		if (err)
+		if (err) {
+			esw_vport_del_ingress_acl_modify_metadata(esw, vport);
 			esw_vport_disable_ingress_acl(esw, vport);
+		}
 	}
 	return err;
 }
@@ -1973,6 +1975,7 @@ esw_vport_destroy_offloads_acl_tables(struct mlx5_esw=
itch *esw,
 				      struct mlx5_vport *vport)
 {
 	esw_vport_disable_egress_acl(esw, vport);
+	esw_vport_del_ingress_acl_modify_metadata(esw, vport);
 	esw_vport_disable_ingress_acl(esw, vport);
 }
=20
--=20
2.21.0

