Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7E2BECA9C
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 22:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbfKAV7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 17:59:21 -0400
Received: from mail-eopbgr70089.outbound.protection.outlook.com ([40.107.7.89]:20086
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727381AbfKAV7T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 17:59:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C1oibvjJJ0+Eafd/zFMWkZR7p12CB4nsQsBdbEC1M4N/68hU5lxmyq/9VSF6l/DlX65ZcxzWzacDbzPr086cag5D2nXXxEYrVpoFE74eNYzq1YyV8sn8ZLSOHT+6XMWzktGd0Bu6UWSH7Bz0JAR0XsNrUWkYKzx/YWS9CvhzbciGQM4gAtUfmiS066WNNDtRrTbbj9mYsORsZG1h4j8rPCmP9mhXeou2xU+Mfy3StKU/KCwHfbJ+iS8SyMk6+PyX1N/ZSO+bxUgWR65G5q5JsanMun6N7lXuwDFAI4uCUbR5+iETQP8HhNyEbb0+mp7ajHgjQpauiVvX4y6F3wFzyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LYUq5XJZ4M2oOVUBUeseOUx8Wb+F/g3tnCrDKegTvxo=;
 b=a9w6L0kQPYQGqkG+RqnqTizCeX8Wp88lJi8f5/JtJo/OQmcDWvzKc8iahiznz3Xp7bWSCi/0g98g0S9pRdEy75Rt10uiBp20hAGueEUpKnohAETuibeNEvbK5SlqBnJYs/DpsLb8KXm7JxthgQV70XQ5JXP9JKg0O6OLeDAQHlfvBBusT5J9DUmPs54XZOQkpki5hqmb7jS5v7CqA3BhbshMwsGK8H6xwRTxAVGuGSDlpOT+dJXrAezerZb4iNmRd23q/hAEJdiM1IdJokLoExILvDeOBQ4K32lQZEddGFCCsAs81w1LwDFRsdp0uSgx5c8daOt+l8PUtmE+5SMoGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LYUq5XJZ4M2oOVUBUeseOUx8Wb+F/g3tnCrDKegTvxo=;
 b=HBOpWyiOJSCiEoyZeAi9AchDhbDxOdO36NprK3fdI8gAbn8RyBNRpJ6ErW2xRr4bCnQqVx6mk8n+xZOhgBvusgRqkQxZ6j6Jh07N4Aos4xRycE/OKBfwUiPNDgOd/nSiGOOOpLrEDxROYiv84jkAPbcpJClnxu+IavfT0FBrBHc=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5679.eurprd05.prod.outlook.com (20.178.121.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 1 Nov 2019 21:59:13 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 21:59:13 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 09/15] net/mlx5: WQ, Move short getters into header file
Thread-Topic: [net-next 09/15] net/mlx5: WQ, Move short getters into header
 file
Thread-Index: AQHVkP+YouD5slYLGkuY1H1+oVy2Cg==
Date:   Fri, 1 Nov 2019 21:59:13 +0000
Message-ID: <20191101215833.23975-10-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 159fde75-3117-474d-98ce-08d75f16bb26
x-ms-traffictypediagnostic: VI1PR05MB5679:|VI1PR05MB5679:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5679C29FA746ED601DD57BF3BE620@VI1PR05MB5679.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:49;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(189003)(199004)(4326008)(99286004)(316002)(2616005)(2906002)(6116002)(476003)(6512007)(3846002)(1076003)(36756003)(66946007)(14454004)(25786009)(54906003)(66066001)(66556008)(64756008)(486006)(11346002)(446003)(81156014)(6916009)(76176011)(305945005)(7736002)(26005)(66476007)(66446008)(86362001)(5660300002)(102836004)(386003)(6506007)(50226002)(6486002)(6436002)(81166006)(71190400001)(71200400001)(478600001)(8676002)(256004)(8936002)(107886003)(52116002)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5679;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: omXb2v7K9B0MWcOcdcn1vufuzb9OXBB/0YZptgTNkFy3itN9+KY1E+ZYcemfogh4otXO26ubSHqSO1oTpdjUxiBBfNDTpOSQIligHRGBbdMfzDYP7xzaitu/aEX9v7HLnPv1GiF7HUkBieieq3X0AKGBJWVgdd31Yjg+vpGTxFxdieSj5ZwxKFsXanIRnjuQKy8AkNVe5H2ooX+j4YSJu3p7+kTyM3rYPParPhx8VWyva/OjP4PIMwEYfyfqAhZrcCderA9z+lexwqyeNS/HQ0H1snLwHwcp1Yi2AM5goyTudmhEi8eO/NFKZf1F7YFJNuzpN/TBDOFCydBRqFvbXDwBAZhfOFFX1v7WMmr6AMbqzNOEIOrMLw+P27o3x3IFqpK0BQ+s8wLuuzMC86sE7V4V+hhrPATbWTQxDjQ4NsaCU+z7SZgA0VnXcPFI/WpJ
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 159fde75-3117-474d-98ce-08d75f16bb26
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 21:59:13.2241
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +gfQV69KhJ567apixEWh25/XGPaOz0O1E2W0LCR3L0TrV5/WzxB8jAW7kY3y02gZ6VNfK5L+Zi6cx7yHdozPYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5679
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Move short Work Queue API getter functions into the WQ
header file.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/wq.c | 20 ----------------
 drivers/net/ethernet/mellanox/mlx5/core/wq.h | 24 ++++++++++++++++----
 2 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wq.c b/drivers/net/eth=
ernet/mellanox/mlx5/core/wq.c
index dab2625e1e59..f2a0e72285ba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/wq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/wq.c
@@ -34,26 +34,6 @@
 #include "wq.h"
 #include "mlx5_core.h"
=20
-u32 mlx5_wq_cyc_get_size(struct mlx5_wq_cyc *wq)
-{
-	return (u32)wq->fbc.sz_m1 + 1;
-}
-
-u32 mlx5_cqwq_get_size(struct mlx5_cqwq *wq)
-{
-	return wq->fbc.sz_m1 + 1;
-}
-
-u8 mlx5_cqwq_get_log_stride_size(struct mlx5_cqwq *wq)
-{
-	return wq->fbc.log_stride;
-}
-
-u32 mlx5_wq_ll_get_size(struct mlx5_wq_ll *wq)
-{
-	return (u32)wq->fbc.sz_m1 + 1;
-}
-
 static u32 wq_get_byte_sz(u8 log_sz, u8 log_stride)
 {
 	return ((u32)1 << log_sz) << log_stride;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wq.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/wq.h
index 27338c3c6136..d9a94bc223c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/wq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/wq.h
@@ -80,7 +80,6 @@ int mlx5_wq_cyc_create(struct mlx5_core_dev *mdev, struct=
 mlx5_wq_param *param,
 		       void *wqc, struct mlx5_wq_cyc *wq,
 		       struct mlx5_wq_ctrl *wq_ctrl);
 void mlx5_wq_cyc_wqe_dump(struct mlx5_wq_cyc *wq, u16 ix, u8 nstrides);
-u32 mlx5_wq_cyc_get_size(struct mlx5_wq_cyc *wq);
=20
 int mlx5_wq_qp_create(struct mlx5_core_dev *mdev, struct mlx5_wq_param *pa=
ram,
 		      void *qpc, struct mlx5_wq_qp *wq,
@@ -89,16 +88,18 @@ int mlx5_wq_qp_create(struct mlx5_core_dev *mdev, struc=
t mlx5_wq_param *param,
 int mlx5_cqwq_create(struct mlx5_core_dev *mdev, struct mlx5_wq_param *par=
am,
 		     void *cqc, struct mlx5_cqwq *wq,
 		     struct mlx5_wq_ctrl *wq_ctrl);
-u32 mlx5_cqwq_get_size(struct mlx5_cqwq *wq);
-u8 mlx5_cqwq_get_log_stride_size(struct mlx5_cqwq *wq);
=20
 int mlx5_wq_ll_create(struct mlx5_core_dev *mdev, struct mlx5_wq_param *pa=
ram,
 		      void *wqc, struct mlx5_wq_ll *wq,
 		      struct mlx5_wq_ctrl *wq_ctrl);
-u32 mlx5_wq_ll_get_size(struct mlx5_wq_ll *wq);
=20
 void mlx5_wq_destroy(struct mlx5_wq_ctrl *wq_ctrl);
=20
+static inline u32 mlx5_wq_cyc_get_size(struct mlx5_wq_cyc *wq)
+{
+	return (u32)wq->fbc.sz_m1 + 1;
+}
+
 static inline int mlx5_wq_cyc_is_full(struct mlx5_wq_cyc *wq)
 {
 	return wq->cur_sz =3D=3D wq->sz;
@@ -169,6 +170,16 @@ static inline int mlx5_wq_cyc_cc_bigger(u16 cc1, u16 c=
c2)
 	return !equal && !smaller;
 }
=20
+static inline u32 mlx5_cqwq_get_size(struct mlx5_cqwq *wq)
+{
+	return wq->fbc.sz_m1 + 1;
+}
+
+static inline u8 mlx5_cqwq_get_log_stride_size(struct mlx5_cqwq *wq)
+{
+	return wq->fbc.log_stride;
+}
+
 static inline u32 mlx5_cqwq_ctr2ix(struct mlx5_cqwq *wq, u32 ctr)
 {
 	return ctr & wq->fbc.sz_m1;
@@ -225,6 +236,11 @@ static inline struct mlx5_cqe64 *mlx5_cqwq_get_cqe(str=
uct mlx5_cqwq *wq)
 	return cqe;
 }
=20
+static inline u32 mlx5_wq_ll_get_size(struct mlx5_wq_ll *wq)
+{
+	return (u32)wq->fbc.sz_m1 + 1;
+}
+
 static inline int mlx5_wq_ll_is_full(struct mlx5_wq_ll *wq)
 {
 	return wq->cur_sz =3D=3D wq->fbc.sz_m1;
--=20
2.21.0

