Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5438E79ACA
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388545AbfG2VN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:13:28 -0400
Received: from mail-eopbgr10050.outbound.protection.outlook.com ([40.107.1.50]:5933
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388516AbfG2VNZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 17:13:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iVU1eeSSb6wHlpzarLaY5/oUphekP/NcI+X5evsr76hR0Qu0GU2VdT3rwjA/WKRLhwfgO+8urMyDGgMBZZV64Gvq3PCiCQiS92hMkr/o9AcB838bELivMGN7rfox5/SbYtOIllbGahzifNeIsKz5KlprN9KBIl0FGEYd6w4oxH3gRqozw2XR8v/kRre2w4g35o1saJng7eJU92fem5vl4HCoERD62LCVpW5+Tn2pWEzWxrudWfC5U0QFgEsTqMXhEGBFBg4lmnpNO3F/5IMu9jooD8HkOMfyRIWD/ADjTNNINFS0MWq00Gkb01St+3Bol61X0Lcf7MkC9bVGCpQkBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qmvxowdFsHXTPJLou6VQ5AzCi2qFquy/aEsxLenIPw4=;
 b=TrYqUfpDsn08r6iV8cLD1qoOEiTXHcratqILUFcToBCVvf1KqsprrAfqMxjnHfFmhDmBeZKQsNxMTY6rfA/xH2lFOe835FColAWwuz2HPtE21es6keWViU5w9rd2dFwrC2KCYMkhWRJ4OjwCaaMiGyKQdVEC1GSLdS+Uec4JQW8hQSq+Awn+jQcWEI2x8V4S147BSoE7lntuaV7slpTQKdHXfn5igStNw+5+ysHhGbCToiRySB0+c1JBTuU+AypRKeoX/9rn2FYQyUbj/u0m7QYCfvcHtExTp+c1iH5F65rj1JU7DnR9EfkHw5GHPUZdQCyuq2xSPT8so9JCrx9QBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qmvxowdFsHXTPJLou6VQ5AzCi2qFquy/aEsxLenIPw4=;
 b=rOWxpdyjJ2cf2prkXzIp7xQeiSxGIL1uS1skSklaEnKtcIPVF6sDjuiIP9iVu6nnb0jpviFidyhz6wWJd3JfzF2znvOGLYNQ/qKTrSx2eqRwnNSujmJ9cuLIpGYolaeSRSRK1GI0mqKkISr4qSVsXjyFXInSYBzhE+889GwUj/Y=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2375.eurprd05.prod.outlook.com (10.168.72.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Mon, 29 Jul 2019 21:13:10 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 21:13:10 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
CC:     Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 10/11] net/mlx5: E-Switch, Remove redundant
 mc_promisc NULL check
Thread-Topic: [PATCH mlx5-next 10/11] net/mlx5: E-Switch, Remove redundant
 mc_promisc NULL check
Thread-Index: AQHVRlJsEOiWNpMm00mWvxla2CilQg==
Date:   Mon, 29 Jul 2019 21:13:10 +0000
Message-ID: <20190729211209.14772-11-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 1be83d54-88d2-4fa0-9c05-08d714698ee4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2375;
x-ms-traffictypediagnostic: DB6PR0501MB2375:
x-microsoft-antispam-prvs: <DB6PR0501MB2375A9ED88B8463EF3314C6CBEDD0@DB6PR0501MB2375.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1850;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(199004)(189003)(50226002)(14444005)(5660300002)(6116002)(3846002)(486006)(446003)(86362001)(81156014)(186003)(36756003)(81166006)(8936002)(26005)(25786009)(316002)(71190400001)(71200400001)(110136005)(64756008)(76176011)(66556008)(2906002)(66946007)(66446008)(99286004)(66476007)(1076003)(386003)(6506007)(102836004)(256004)(7736002)(6486002)(14454004)(66066001)(2501003)(8676002)(305945005)(6436002)(4326008)(11346002)(68736007)(52116002)(2616005)(476003)(478600001)(6512007)(450100002)(2201001)(107886003)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2375;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6KK5iIuDkrBJPqfleTDmVKozj/9LgdsC9q8V3AvkPP4M077WY3LTS7UUjo5adj5huY9wManofuv9e+t2nx9eZB8CVwCffn1+xw/6r6iw9Ku9YvLR4J5iwZYl7+qr52LmTpt2DmTy/vjMA9TnSf3ePghOQFFmrs57zeJ+T4Xshsi9ShEOe8PYPC+eOgLYp+J+0h2bkTADV/RusYVvQtpcrebnl+e+GTJz4bQxNqqr2Bd+zKKkpDoSRemXpFQN2rmtYeZdyv+/ireUCGDNQUd94UrB2awBaaAJFipVpnJ7SiS9MOLuBFMEfHitnLxNDT6V1/mAO+W/8I7f0DV0qt2ryyz6gkFpdkUb7yufEPsmRFwB4XISkdjnEhkfCkQkFor9QEcSF22OOyjAr7niAdWlZI9zrjOKAW80uNZ+HoNt9BU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1be83d54-88d2-4fa0-9c05-08d714698ee4
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 21:13:10.0541
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

mc_promisc pointer points to an instance of struct esw_mc_addr allocated
as part of the esw structure.
Hence it cannot be NULL.
Removed such redundant check and assign where it is actually used.

While at it, add comment around legacy mode fields and move mc_promisc
close to other legacy mode structures to improve code redability.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 17fb982b3489..90d150be237b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1900,12 +1900,12 @@ void mlx5_eswitch_disable(struct mlx5_eswitch *esw)
 		 esw->mode =3D=3D MLX5_ESWITCH_LEGACY ? "LEGACY" : "OFFLOADS",
 		 esw->esw_funcs.num_vfs, esw->enabled_vports);
=20
-	mc_promisc =3D &esw->mc_promisc;
 	mlx5_eswitch_event_handlers_unregister(esw);
=20
 	mlx5_eswitch_disable_pf_vf_vports(esw);
=20
-	if (mc_promisc && mc_promisc->uplink_rule)
+	mc_promisc =3D &esw->mc_promisc;
+	if (mc_promisc->uplink_rule)
 		mlx5_del_flow_rules(mc_promisc->uplink_rule);
=20
 	if (esw->mode =3D=3D MLX5_ESWITCH_LEGACY)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.h
index 3103a34c619c..51b6d29466f1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -214,8 +214,11 @@ enum {
 struct mlx5_eswitch {
 	struct mlx5_core_dev    *dev;
 	struct mlx5_nb          nb;
+	/* legacy data structures */
 	struct mlx5_eswitch_fdb fdb_table;
 	struct hlist_head       mc_table[MLX5_L2_ADDR_HASH_SIZE];
+	struct esw_mc_addr mc_promisc;
+	/* end of legacy */
 	struct workqueue_struct *work_queue;
 	struct mlx5_vport       *vports;
 	u32 flags;
@@ -225,7 +228,6 @@ struct mlx5_eswitch {
 	 * and async SRIOV admin state changes
 	 */
 	struct mutex            state_lock;
-	struct esw_mc_addr	mc_promisc;
=20
 	struct {
 		bool            enabled;
--=20
2.21.0

