Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0E9F96CE
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 18:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbfKLROH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 12:14:07 -0500
Received: from mail-eopbgr60074.outbound.protection.outlook.com ([40.107.6.74]:60022
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726645AbfKLROG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 12:14:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GaAnpL9qXglky4aVOfDjcOOrjlK1KuBVlO3gEEDKsq/hfKmzDlOaAcbfzkumv8N7UGMa8++lhs+i8wK+xM1RA47iJ63PprnjYKs7djmaowFTXYLRpbb+c3is/kb8+QSLKCAOj9qv400A30sW9q0IbzQ4wrfuSmTjvi1KNL/NCDZ3EtLqvbpO6RdkhdLsV0tEwEtqRalCwOyv5oSosYjAI4AyK0LZ2snUxDzOwU9cGzdVnHsrtWnc5KUBkSxVlKgfcSRVaVM7aRZQCDPD99ufZMuvUV55Hs7IEfkJrqCjkKHMSI/LZ2x9a//h13QACq9ap410Ff+QQaopG/LBTC6clg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3sQi+Y4SAmyLTd0pQlzHjI/oaZXOCJ/c/diABNW6aSE=;
 b=ctOFDHi8Gz5Ub9BHfqy5jb43msytTmWPsMqiiBRoYDoQZtwTwyyBZCV2bQA9ohaOGiq9siSG5lowRcYDyG9drqJriDEjbDqVb2jn1sJnlXWbmL8C9zSSj0uu9cb6Hu2DdYhtGDdsYMzSFmg+vyJPKyajOVL3TwzbJ/1OEen9Tsvn/OiALI8NCqBt0nQngoiDdDdn1lFgdZ+mIYmwBaWaOr66KVJDF19jirzx9PTSrBgAGvbwWipvh8QDCcO7+drrNGQVZoupMh+bSyl8UJAHPv05nJkF6saiMbFMZq9mrQDE2QK1nm5SpnS9w4wDzULupPXFPimKGZUzB9yi8cA+og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3sQi+Y4SAmyLTd0pQlzHjI/oaZXOCJ/c/diABNW6aSE=;
 b=c9lIoLhGasbZovAROWbzin/HQXLxAKTnfI+mVtmsxxlRQ1v4cro6k6Mq8sTOKYHe1wciF/BE/nU8mXSDpdMElodOtkwy0RM5fhbUyeZ6d53kvBXRI4Dr+SNIGxAU7fAQxAiiI19lE2x/98j2HR8AYqfzfJgCKMbg1c9XDiyARXo=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6078.eurprd05.prod.outlook.com (20.178.125.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.22; Tue, 12 Nov 2019 17:13:48 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 17:13:48 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 5/8] net/mlx5e: Set netdev name space on creation
Thread-Topic: [net-next 5/8] net/mlx5e: Set netdev name space on creation
Thread-Index: AQHVmXyLR4ZHA7wgsEGARkmDXgVG2g==
Date:   Tue, 12 Nov 2019 17:13:47 +0000
Message-ID: <20191112171313.7049-6-saeedm@mellanox.com>
References: <20191112171313.7049-1-saeedm@mellanox.com>
In-Reply-To: <20191112171313.7049-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0059.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::36) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: df3cc613-e817-4ead-98ef-08d76793ae29
x-ms-traffictypediagnostic: VI1PR05MB6078:|VI1PR05MB6078:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6078ED0C9B93B070A367886CBE770@VI1PR05MB6078.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(366004)(396003)(376002)(39860400002)(199004)(189003)(71200400001)(446003)(71190400001)(11346002)(3846002)(76176011)(6506007)(386003)(52116002)(256004)(316002)(476003)(2616005)(486006)(6116002)(5024004)(66446008)(1076003)(102836004)(66946007)(54906003)(6512007)(64756008)(66556008)(66476007)(86362001)(5660300002)(305945005)(2906002)(6916009)(7736002)(8676002)(81166006)(50226002)(8936002)(6436002)(478600001)(6486002)(14454004)(81156014)(36756003)(26005)(186003)(25786009)(99286004)(4326008)(107886003)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6078;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZuU0nn7RMuad7kRAAhDhEdOdcF9MF17EbjgczI1KlJjzkE6lG2nN5lhd6+IF5xLQGP0GwtNuZRf3o8ZZxI8mVFL1+lejr+CLet9r4mPFuqV/fzyNroh78Kfc/COitZ0pZVT4GlqWKJ1gSIsjZuo3tXxZHcYHBSeqF9vttzSVAk8QmStOsBMdj7hPsU694kC93x6xXMIRgnFliU+xq8GzQBDbxrrQWxtCwJIv9Q2ZrH9+AtGhOOrsEMowLQtyYtgks26W0dCfdZai1KT47UxzhHZFom7Ek0xtbV6AjiBay4EtQGxxIW0DTKVDj8bEXT2ESAepX8RCtO68PE2WTkpYA8owMM8FItvxTHD8639tdu9IMyFPD4bvKMRxJuZ354Sffr2CybsyyVhj2s0faYU1dLH6sfqzNnSkAkT3phezNi1cBumPUJFkMNI8jFkbqwWE
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df3cc613-e817-4ead-98ef-08d76793ae29
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 17:13:47.9457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6fFZLIijjKEjkm8iKHju+bIJLlvWWH/yIC7+dv2YTolbXk8LK+nv78GCkZ/JymzUGf9DuU+G435kYurS39WNqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6078
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

