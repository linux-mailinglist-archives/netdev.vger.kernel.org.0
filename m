Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4720AAE0A
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 23:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731771AbfIEVvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 17:51:07 -0400
Received: from mail-eopbgr140087.outbound.protection.outlook.com ([40.107.14.87]:28743
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388381AbfIEVvF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 17:51:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IwS6Uk0FK8knwBIuIsyDQSiW6A6xtO0UZlAP9v+gnON5Jf/JAIakI6H+l/TKwoaVL+RI9SdFvXmcDOkC2ja517gebp+r+KBxdK3Mhp/pHfKJWfS4eWReNqC6c7IfzH8MlFLVLTBVDm57ib5oxuUC927Qkq97SqIFZvOpsoX7BufZ7QWv3/oi1drMeHkUILJsnU9R0YypcLt+n5YF3GE0YjBTl5qndciXO5yPP14+/Nuq0ByQ7RfraXd+ij/wlQ7aNNOylY+3s2w7HxoI8rV9UDTTphlGlem03F0NWRn6Ie/q84Ymq1D5LfH0jsQ+UwKOUKQjoVPltr+uuLMu7uUxfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9l4tJXcF/R9oz9JrjAOs2B42CS2dVD9bREBCpxXdZ4U=;
 b=LxtDTRhuodHbTEc3+7QhLyhU/bDGfCpv/jDQb8TxFMtdpxfbiLi5oLjrf6co0fbhSs+P92dhRW0yEIymx6AL/DC2ilufgZ3RfoHs3GSS84ZIlmCWq6dJpnFr+Znk3UmjHv5SMHvV45ocrfuSYHiXlO0tPyOME0qvYZ8A4qlmBUjroch/TnvMnELR1hIA1mOjDLvhjWstALxfIVqflOkdBuXQWqbDX0ePQIEcTw9phlnhIM6AAHXBbNj1Qhp+7Vghtwnba/0PpgKIbVr6koNddsBWSbN8errzdg/n9dhlX+3szI4zXfWKVpsTjqUgjEtE+YZdj7QdP+GNAjlV6Ywl4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9l4tJXcF/R9oz9JrjAOs2B42CS2dVD9bREBCpxXdZ4U=;
 b=fXgru99FAD+CE+bX6zeIUnlpaNkWpISwmkdndQbVbrxMmt4shihAdftolxOslLR/fb2J75rO9PydCN0jypX/PQOi4AzopSIZkPV0J1cTDisFl7/ecw/a5aFbzk86lm1Do84Hh0sBs6y25ntxF+yGjs10ugL1Bh+P3Hyc09wHwnM=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2191.eurprd05.prod.outlook.com (10.169.134.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Thu, 5 Sep 2019 21:50:58 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9%5]) with mapi id 15.20.2220.022; Thu, 5 Sep 2019
 21:50:58 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Walter Harms <wharms@bfs.de>, Mark Bloch <markb@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>
Subject: [net-next 03/14] net/mlx5e: Use ipv6_stub to avoid dependency with
 ipv6 being a module
Thread-Topic: [net-next 03/14] net/mlx5e: Use ipv6_stub to avoid dependency
 with ipv6 being a module
Thread-Index: AQHVZDQAWGXJs33Yd0mFlxcvjY93uw==
Date:   Thu, 5 Sep 2019 21:50:58 +0000
Message-ID: <20190905215034.22713-4-saeedm@mellanox.com>
References: <20190905215034.22713-1-saeedm@mellanox.com>
In-Reply-To: <20190905215034.22713-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0023.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::36) To VI1PR0501MB2765.eurprd05.prod.outlook.com
 (2603:10a6:800:9a::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e955b3a4-2504-4d36-e510-08d7324b2283
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2191;
x-ms-traffictypediagnostic: VI1PR0501MB2191:|VI1PR0501MB2191:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB219178B91079E100D51FBFAEBEBB0@VI1PR0501MB2191.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:204;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(346002)(39860400002)(396003)(136003)(199004)(189003)(54906003)(316002)(2906002)(256004)(8936002)(14444005)(8676002)(6486002)(305945005)(99286004)(7736002)(5660300002)(81156014)(81166006)(50226002)(1076003)(478600001)(6512007)(11346002)(26005)(25786009)(36756003)(86362001)(4326008)(14454004)(6436002)(53936002)(102836004)(486006)(6506007)(386003)(66066001)(2616005)(476003)(446003)(186003)(107886003)(71190400001)(6916009)(71200400001)(52116002)(6116002)(66446008)(64756008)(66556008)(66476007)(66946007)(3846002)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2191;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5qfhkxROJFKJ7va2cD+3yo463uKeXeUpWeSP2FoxJ5WFMWnS8MGYcPZRow9SBBBYr4AsxeoRlcjmOcHnGCoVemS7WZppL378cfKphOzKL5MJ3S3wa69jsiBAgC/MevdT/YOGfBSSo8tc1xH7yYoLM4TUui4brmF3Q9NGLlwtdZ5ucjFy315yST7Ac+Xf7E9bcGJc+SppFBpT42oSJA5VJxcCYnTaD4X1Oe6TD6C4I3KaqYrHEx76/N5Ko9Swdy/VP20ZXfE+sT9BmpBlnwS9NjNsAz7z375yQL+muTojYx91ohDzkZgbz0pH36BqHE44EdlgY4tegP0jbW2Oc/VOVEw7xL0ozSdOrgrDJXsl02sbthcR5beOp/YLa8TbBwKcE2PCM9poT+K0jiaKHaumrD8rVxNtJ5ATWSI7aESlBw4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e955b3a4-2504-4d36-e510-08d7324b2283
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 21:50:58.4267
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1VbFrjT+EXkAAqYJanftR0QVqEPD+TLuVP5ewgpMjsWA+YS05DEZ8zKjx8s3GL0IyRqUUNUyPQNUtoJdWzDI9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2191
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mlx5 is dependent on IPv6 tristate since we use ipv6's nd_tbl directly,
alternatively we can use ipv6_stub->nd_tbl and remove the dependency.

Reported-by: Walter Harms <wharms@bfs.de>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Kconfig   |  1 -
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 23 +++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  2 +-
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/=
ethernet/mellanox/mlx5/core/Kconfig
index a496f2ac20b0..0dba272a5b2f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -33,7 +33,6 @@ config MLX5_FPGA
 config MLX5_CORE_EN
 	bool "Mellanox 5th generation network adapters (ConnectX series) Ethernet=
 support"
 	depends on NETDEVICES && ETHERNET && INET && PCI && MLX5_CORE
-	depends on IPV6=3Dy || IPV6=3Dn || MLX5_CORE=3Dm
 	select PAGE_POOL
 	select DIMLIB
 	default n
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.c
index 1623cd32f303..95892a3b63a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -38,6 +38,7 @@
 #include <net/netevent.h>
 #include <net/arp.h>
 #include <net/devlink.h>
+#include <net/ipv6_stubs.h>
=20
 #include "eswitch.h"
 #include "en.h"
@@ -499,16 +500,18 @@ void mlx5e_remove_sqs_fwd_rules(struct mlx5e_priv *pr=
iv)
 	mlx5e_sqs2vport_stop(esw, rep);
 }
=20
+static unsigned long mlx5e_rep_ipv6_interval(void)
+{
+	if (IS_ENABLED(CONFIG_IPV6) && ipv6_stub->nd_tbl)
+		return NEIGH_VAR(&ipv6_stub->nd_tbl->parms, DELAY_PROBE_TIME);
+
+	return ~0UL;
+}
+
 static void mlx5e_rep_neigh_update_init_interval(struct mlx5e_rep_priv *rp=
riv)
 {
-#if IS_ENABLED(CONFIG_IPV6)
-	unsigned long ipv6_interval =3D NEIGH_VAR(&nd_tbl.parms,
-						DELAY_PROBE_TIME);
-#else
-	unsigned long ipv6_interval =3D ~0UL;
-#endif
-	unsigned long ipv4_interval =3D NEIGH_VAR(&arp_tbl.parms,
-						DELAY_PROBE_TIME);
+	unsigned long ipv4_interval =3D NEIGH_VAR(&arp_tbl.parms, DELAY_PROBE_TIM=
E);
+	unsigned long ipv6_interval =3D mlx5e_rep_ipv6_interval();
 	struct net_device *netdev =3D rpriv->netdev;
 	struct mlx5e_priv *priv =3D netdev_priv(netdev);
=20
@@ -917,7 +920,7 @@ static int mlx5e_rep_netevent_event(struct notifier_blo=
ck *nb,
 	case NETEVENT_NEIGH_UPDATE:
 		n =3D ptr;
 #if IS_ENABLED(CONFIG_IPV6)
-		if (n->tbl !=3D &nd_tbl && n->tbl !=3D &arp_tbl)
+		if (n->tbl !=3D ipv6_stub->nd_tbl && n->tbl !=3D &arp_tbl)
 #else
 		if (n->tbl !=3D &arp_tbl)
 #endif
@@ -944,7 +947,7 @@ static int mlx5e_rep_netevent_event(struct notifier_blo=
ck *nb,
 		 * done per device delay prob time parameter.
 		 */
 #if IS_ENABLED(CONFIG_IPV6)
-		if (!p->dev || (p->tbl !=3D &nd_tbl && p->tbl !=3D &arp_tbl))
+		if (!p->dev || (p->tbl !=3D ipv6_stub->nd_tbl && p->tbl !=3D &arp_tbl))
 #else
 		if (!p->dev || p->tbl !=3D &arp_tbl)
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 30d26eba75a3..98d1f7a48304 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1492,7 +1492,7 @@ void mlx5e_tc_update_neigh_used_value(struct mlx5e_ne=
igh_hash_entry *nhe)
 		tbl =3D &arp_tbl;
 #if IS_ENABLED(CONFIG_IPV6)
 	else if (m_neigh->family =3D=3D AF_INET6)
-		tbl =3D &nd_tbl;
+		tbl =3D ipv6_stub->nd_tbl;
 #endif
 	else
 		return;
--=20
2.21.0

