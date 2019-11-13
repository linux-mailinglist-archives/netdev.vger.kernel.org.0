Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20C0FFBBC8
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 23:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfKMWlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 17:41:46 -0500
Received: from mail-eopbgr150048.outbound.protection.outlook.com ([40.107.15.48]:22577
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726251AbfKMWlp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 17:41:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d45/CI0sHHaAf/Hcu1/ykv/f4OzodGlAjp3q09dnKsyYwMoU+L3Xx+zerqxN45vijG21uFEN2eBoXbP6mVfNuORPUe04QY9g39OvaOGAJLKAQd0NWFFbJxeJZRG98oPahqsTLoWdm+RuQT3qb8bQCyO04aW8yNp7ktk78y8c/iUvVAD0NaBj50LN8uwZc1hDBxzUYkTq/O+UAeTd3H7aPc5A1Ve7jDUBnW2RU/FedXoNo+0VDQXIQWXaz9jGW584IYy9p2tPb5Azr3cSc6kJ6Uoc7/1qldpvgBlQUdFDiZDorZ/jvKzE56rKkT9lPhq6JG5euq9Dwhg91QXojCI7cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3sQi+Y4SAmyLTd0pQlzHjI/oaZXOCJ/c/diABNW6aSE=;
 b=GMpsPZJsIfUe3bC92nCsMGMr59ZC4ip296MBmC7E0CNbHfQtMGqLT231BWtbEJ54zXsuxg2FQdHt50rnHhggNl7ZazhR6IK6cB0y8s+69Fm66lUmHpHm1/YYiUbgDGH3FbSG5VEPqxZ5FfrtL2bXgo191Rrxc0CFk+d6zmx8ar7olWK1jUQXF+ohy9vjr/aAl29AJ/WYWraOsNFdruYmSzt4Z472Q6nUeSTnqPXsr1tSmaF/Ol98qnVxCj4qGxZaIkLOWPkUam1te5Fw4pWt66iXT3A04f3Txnv1baGn1GZj9vdKJ0YU9ieGGA2rfrG5zwTRtAlNzThBwES7waWSdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3sQi+Y4SAmyLTd0pQlzHjI/oaZXOCJ/c/diABNW6aSE=;
 b=gjImSD86dv0U+OFV+dv+XVGqEPq/GMpo04OMf668XozqqHSJ/2gE+ezJuesRR3odeP6092EqjTgyo6yHQSGO8/1IQTXkC1lp5JKCeBSG/kNxInNeNYJ0GNiRIG3CDHMOZeT4pvFlGuLI0Rnn4d8jcgFCnN2NKhUwkH+vVwKPzZc=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5135.eurprd05.prod.outlook.com (20.178.11.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 13 Nov 2019 22:41:40 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2430.028; Wed, 13 Nov 2019
 22:41:40 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 5/7] net/mlx5e: Set netdev name space on creation
Thread-Topic: [net-next V2 5/7] net/mlx5e: Set netdev name space on creation
Thread-Index: AQHVmnODujZItWLyrEK78Ilshqo/IA==
Date:   Wed, 13 Nov 2019 22:41:40 +0000
Message-ID: <20191113224059.19051-6-saeedm@mellanox.com>
References: <20191113224059.19051-1-saeedm@mellanox.com>
In-Reply-To: <20191113224059.19051-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::32) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b6b7aa11-1048-4cd0-e918-08d7688aa65f
x-ms-traffictypediagnostic: VI1PR05MB5135:|VI1PR05MB5135:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5135962A0B594470E992B700BE760@VI1PR05MB5135.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(376002)(39860400002)(396003)(346002)(189003)(199004)(26005)(3846002)(6116002)(54906003)(66946007)(64756008)(66556008)(66476007)(2906002)(66446008)(36756003)(316002)(99286004)(81166006)(81156014)(8936002)(8676002)(50226002)(5660300002)(1076003)(102836004)(186003)(6512007)(6486002)(6436002)(386003)(478600001)(52116002)(25786009)(76176011)(7736002)(6506007)(14454004)(305945005)(86362001)(486006)(107886003)(256004)(4326008)(66066001)(5024004)(2616005)(6916009)(11346002)(71200400001)(71190400001)(446003)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5135;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8OXPZ43vHYM8UO/y/2XdesUTOibd7FPbC78eZYqGTNJbHKRIgUJy2RrqyUv/ccSD8Xr1IP16oGsqvTtLqn2KIWj+uRxVsYdHP08TBXaRstLDBWv5ntSlsWEyd4OYm8HqMwHtmz7YRx9tSWStpMPVEQ79oph/ZBWupwsfySENksEn9yTr5jOk6G83/XHmoJpfzBnY2PgqpweK8lQdv4fomc+9DKSWz6WxLuIdTLfubzlxIbX9+zk4WLCY9RI24tPUPds3TOezzVrn2s64wk32QklCKT46iW5OHQuzIQNcUwoY7Y/QwSxZ5IkePTA1eLdPt+UXW2p9V6mCRJJ7FHE2TYzMnLMDVUMbOwJsHbhfE483mo9BB9PuUBowHG2lFyDVyRXeBcXirxVUdwQX7RZXfWqC8naLl46nikVnLlsCI96Vpsnu+vcssluVB/ZAhQlT
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6b7aa11-1048-4cd0-e918-08d7688aa65f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 22:41:40.4012
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G1035KBMt1WB0KElpOq1gP35Ck7/7b+6nbTV/nYTprz8FK9K2exBWzJQ2HVotv6mKR3uICbBExqzLGg5tLJ9Tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

Use devlink instance name space to set the netdev net namespace.

Preparation patch for devlink reload implementation.

Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h | 5 +++++
 3 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 772bfdbdeb9c..06a592fb62bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -63,6 +63,7 @@
 #include "en/xsk/rx.h"
 #include "en/xsk/tx.h"
 #include "en/hv_vhca_stats.h"
+#include "lib/mlx5.h"
=20
=20
 bool mlx5e_check_fragmented_striding_rq_cap(struct mlx5_core_dev *mdev)
@@ -5427,6 +5428,7 @@ static void *mlx5e_add(struct mlx5_core_dev *mdev)
 		return NULL;
 	}
=20
+	dev_net_set(netdev, mlx5_core_net(mdev));
 	priv =3D netdev_priv(netdev);
=20
 	err =3D mlx5e_attach(mdev, priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.c
index cd9bb7c7b341..c7f98f1fd9b1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -47,6 +47,7 @@
 #include "en/tc_tun.h"
 #include "fs_core.h"
 #include "lib/port_tun.h"
+#include "lib/mlx5.h"
 #define CREATE_TRACE_POINTS
 #include "diag/en_rep_tracepoint.h"
=20
@@ -1877,6 +1878,7 @@ mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struc=
t mlx5_eswitch_rep *rep)
 		return -EINVAL;
 	}
=20
+	dev_net_set(netdev, mlx5_core_net(dev));
 	rpriv->netdev =3D netdev;
 	rep->rep_data[REP_ETH].priv =3D rpriv;
 	INIT_LIST_HEAD(&rpriv->vport_sqs_list);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h b/drivers/n=
et/ethernet/mellanox/mlx5/core/lib/mlx5.h
index b99d469e4e64..249539247e2e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
@@ -84,4 +84,9 @@ int mlx5_create_encryption_key(struct mlx5_core_dev *mdev=
,
 			       void *key, u32 sz_bytes, u32 *p_key_id);
 void mlx5_destroy_encryption_key(struct mlx5_core_dev *mdev, u32 key_id);
=20
+static inline struct net *mlx5_core_net(struct mlx5_core_dev *dev)
+{
+	return devlink_net(priv_to_devlink(dev));
+}
+
 #endif
--=20
2.21.0

