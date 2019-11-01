Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9716ECAAA
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 23:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbfKAV7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 17:59:38 -0400
Received: from mail-eopbgr70089.outbound.protection.outlook.com ([40.107.7.89]:20086
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727707AbfKAV7h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 17:59:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SmU3OHBflZNWQ0JrTx82919GOeVj05XtKa/B8VPddxqXyRhL9Ms9rt+EvLolyRYo3GPE3qRKb9KMpp3WaKpnZryO0WZYUL7dSir2h/d3cdrVb1vqBjicgMJzY0t7w7K2rWg6ZQlXEF4tjdcJAkqROzsc50Upq2LUAHr/H1iokZf5OkEbGsTmh3uWdq3lQGm5YrOc6OMpO656NsYtygrwLezPJ4Wygr4d/CNelsHcU+hKhbG0TF63PKUlN5Le8n6TgARnT9aCjX0Pg3jsL4iyYF/gyYnDBfpv/y5aGUuuiLXU2JzOUUjiuUM/Pnzb5shJLjj8ikxkXEvqm9FP2d1azg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Stu9fyL4IxrGedFkF1qhcMT5QAG78wCTkwhMu5sHAaE=;
 b=TH3r1NuvIafReN9GRBL3KH1uzgcc++M0NZzZiBlddSoK2W9d1qirk/1/zQ/6WUN6nMEmEJouc609RZFriDx78xrAeT9clFOS9pFrnY0FQqnY9vmZm+E4RMR1PUjeTUVclEVf7OgKAXJ13mkb1kiWa0Ie8eg4W0fJhyG+Aw1/PMrZDe4n6N32rt4EPp5pfWXzBE2/E2c1Tgw+hoL/Tcin66Ng1BkuGZbV39Wp/sr7dZQUM+UzSSfo++T8Xe7Uvo+8eyNBiBzQrX/cra/rHRd9Qp3CT8d0KpZNzjsamXMtr3iqgDtHQjQxr3/nZXYhoExuFKy9zkUtaP22rsNw44ouYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Stu9fyL4IxrGedFkF1qhcMT5QAG78wCTkwhMu5sHAaE=;
 b=dRUx2LgogGwA4m/b8CAjjph6e3w9cqZNKd4/SCF8hVZMoOrUZdflSXli23K4Uefw4Y21ZjTJ54Xno/sdZ/C5rq88HvifZTBSlzm4FikjxR9GqNzFf+UpTFxDG92VNlYN+u5EMSBmsOq12EyUlwwzLW3oZd9icMoOoF29aiN0shc=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5679.eurprd05.prod.outlook.com (20.178.121.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 1 Nov 2019 21:59:22 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 21:59:22 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Erez Alfasi <ereza@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 14/15] net/mlx5: LAG, Use affinity type enumerators
Thread-Topic: [net-next 14/15] net/mlx5: LAG, Use affinity type enumerators
Thread-Index: AQHVkP+eJuwit3V/IkeIfeEgUeVKKA==
Date:   Fri, 1 Nov 2019 21:59:22 +0000
Message-ID: <20191101215833.23975-15-saeedm@mellanox.com>
References: <20191101215833.23975-1-saeedm@mellanox.com>
In-Reply-To: <20191101215833.23975-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0076.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::17) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f5c830a8-750e-4bf0-7ef6-08d75f16c070
x-ms-traffictypediagnostic: VI1PR05MB5679:|VI1PR05MB5679:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB56797F46798471AE02683AAABE620@VI1PR05MB5679.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(189003)(199004)(4326008)(99286004)(316002)(2616005)(2906002)(6116002)(476003)(6512007)(3846002)(1076003)(36756003)(66946007)(14454004)(25786009)(54906003)(66066001)(66556008)(64756008)(486006)(11346002)(446003)(81156014)(6916009)(76176011)(305945005)(7736002)(26005)(66476007)(66446008)(86362001)(5660300002)(102836004)(386003)(6506007)(50226002)(6486002)(6436002)(81166006)(71190400001)(71200400001)(478600001)(8676002)(256004)(8936002)(14444005)(107886003)(52116002)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5679;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WT8jDFKTzZJ0sAFztSX1bV5POBmx/bv8ZXl+Qin0zGiwJUpmSJ6FE6qIfGS3at2UvissZgqHAEEgx4l067iZPBrybniCOQ64pDa2vNzzmc5sayqis2OHkvlrJ94TFtaYoZwGhCFmJd3PEHSb90DL5eiorVhnn2CQrUjT0wEBoYYlcLTM6LrgV0lbqsqLhZdtKWhzRXssUuQVUTtuGNvgW0ImajrfrdFwi0n7Oc2AMeeRsTKNTGGRekgQTVxt3KcPq9KQmHQvJqr9q0t0PDCjy6ss1LWlQOKznuUIaMb4u15rNsKLQcgTTb3dd4mXXK6jcDPby8JMUGRRdRW1if3eqxnUm3qKHkrCxXKmaBjFlgeHOyvG1GHYv0J+2n8VDq/ze3vL+AbdmwtiCTmhRd25iczLHMjDy29GAhgbIq+R101LmhggAmBEWro4b1t5c/s4
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5c830a8-750e-4bf0-7ef6-08d75f16c070
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 21:59:22.0270
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F4dk1nqb8SnmXdb1Bcl2uyNmhLBS1PpzLt5aPSrE86tDzN+E2LPwcFYWQlr65cKqOLqPdit09nyFmHo94GQTtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5679
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Erez Alfasi <ereza@mellanox.com>

Instead of using explicit indexes, simply use affinity
type enumerators to make the code more readable.

Fixes: 544fe7c2e654 ("net/mlx5e: Activate HW multipath and handle port affi=
nity based on FIB events")
Signed-off-by: Erez Alfasi <ereza@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c | 13 +++++++------
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h |  6 ++++++
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c b/drivers/net=
/ethernet/mellanox/mlx5/core/lag_mp.c
index 5169864dd656..b70afa310ad2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
@@ -44,7 +44,8 @@ bool mlx5_lag_is_multipath(struct mlx5_core_dev *dev)
  *     2 - set affinity to port 2.
  *
  **/
-static void mlx5_lag_set_port_affinity(struct mlx5_lag *ldev, int port)
+static void mlx5_lag_set_port_affinity(struct mlx5_lag *ldev,
+				       enum mlx5_lag_port_affinity port)
 {
 	struct lag_tracker tracker;
=20
@@ -52,19 +53,19 @@ static void mlx5_lag_set_port_affinity(struct mlx5_lag =
*ldev, int port)
 		return;
=20
 	switch (port) {
-	case 0:
+	case MLX5_LAG_NORMAL_AFFINITY:
 		tracker.netdev_state[MLX5_LAG_P1].tx_enabled =3D true;
 		tracker.netdev_state[MLX5_LAG_P2].tx_enabled =3D true;
 		tracker.netdev_state[MLX5_LAG_P1].link_up =3D true;
 		tracker.netdev_state[MLX5_LAG_P2].link_up =3D true;
 		break;
-	case 1:
+	case MLX5_LAG_P1_AFFINITY:
 		tracker.netdev_state[MLX5_LAG_P1].tx_enabled =3D true;
 		tracker.netdev_state[MLX5_LAG_P1].link_up =3D true;
 		tracker.netdev_state[MLX5_LAG_P2].tx_enabled =3D false;
 		tracker.netdev_state[MLX5_LAG_P2].link_up =3D false;
 		break;
-	case 2:
+	case MLX5_LAG_P2_AFFINITY:
 		tracker.netdev_state[MLX5_LAG_P1].tx_enabled =3D false;
 		tracker.netdev_state[MLX5_LAG_P1].link_up =3D false;
 		tracker.netdev_state[MLX5_LAG_P2].tx_enabled =3D true;
@@ -159,7 +160,7 @@ static void mlx5_lag_fib_route_event(struct mlx5_lag *l=
dev,
 		mlx5_activate_lag(ldev, &tracker, MLX5_LAG_FLAG_MULTIPATH);
 	}
=20
-	mlx5_lag_set_port_affinity(ldev, 0);
+	mlx5_lag_set_port_affinity(ldev, MLX5_LAG_NORMAL_AFFINITY);
 	mp->mfi =3D fi;
 }
=20
@@ -184,7 +185,7 @@ static void mlx5_lag_fib_nexthop_event(struct mlx5_lag =
*ldev,
 		}
 	} else if (event =3D=3D FIB_EVENT_NH_ADD &&
 		   fib_info_num_path(fi) =3D=3D 2) {
-		mlx5_lag_set_port_affinity(ldev, 0);
+		mlx5_lag_set_port_affinity(ldev, MLX5_LAG_NORMAL_AFFINITY);
 	}
 }
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h b/drivers/net=
/ethernet/mellanox/mlx5/core/lag_mp.h
index 6d14b1100be9..79be89e9c7a4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h
@@ -7,6 +7,12 @@
 #include "lag.h"
 #include "mlx5_core.h"
=20
+enum mlx5_lag_port_affinity {
+	MLX5_LAG_NORMAL_AFFINITY,
+	MLX5_LAG_P1_AFFINITY,
+	MLX5_LAG_P2_AFFINITY,
+};
+
 struct lag_mp {
 	struct notifier_block     fib_nb;
 	struct fib_info           *mfi; /* used in tracking fib events */
--=20
2.21.0

