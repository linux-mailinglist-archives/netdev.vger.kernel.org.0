Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC3728F433
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732837AbfHOTKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:10:42 -0400
Received: from mail-eopbgr00085.outbound.protection.outlook.com ([40.107.0.85]:9262
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731697AbfHOTKj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 15:10:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SHfmVj5Q/YTQiVtS6meMb0S9IcwpukosW+yoVSa7E7LD3nYY24aizY/vGKCjrfqtD/jbiI3y+2Qwm0B+b407BIgWNv7Cxr4KqscUIkgAqUf8r1tQw4ZMAnBwf4Ys8GrIcUyWbUN76T/PE2XEAS0OsRDbS70Z1rFEBG/rSe+kpyw3tYU7AmCU7i62uUi3eoy/kFmt7UelDXP52Uz+7UwdwxEboiZgWUBCYuBXS0lcyU7FZFHE3U5mxynFfSAmLoEVfKoL7j2uYprRLSuXkMKpqacifqac394S/olq9T/fHBJ3nyMYKAgh+Fq/UeoX/kwU6cS1NqbxLKWeTxRdl51evg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=liUP+mioL0mKicZojEp+bl06uSZLvOMhX29dATmX64Q=;
 b=hUovQxxk/+uD5HgW5ny7T933UDNWjTWIXXciDk6Gjs9zDSvtxB5HMye9VNfYx54Wiqj20X289nQxdthSc/893A4fWWooPA7WaMHQpSbWI3KzsyVVLcUaKqhwQI8z8RDD+CMcKfaQaOfz9a//tbjas+gzHiVgUOL6NPDabCa23TL6sZ5nvKrTxrOFEn2kF6Yr6J74XPD2d7PlQ2Gat9VOOSUCUhEozQ/DD/MyIK3mXiwXXNVlzoTOuyKF9d/9VAXzAtU4Plx3uOvfwhl4iLQOx/E1HiK106V1O1zqhIo3MLLX8XPZ3VvKl0ewJJnLd0gqHkw975EBe9tUg9PxX9xrlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=liUP+mioL0mKicZojEp+bl06uSZLvOMhX29dATmX64Q=;
 b=gb0e8Kzj3cRslA5jIDsw3k8EXKkmNXk4jfN44Ntg7rQFu/pDqwq/uqgSzq8aYe7Ocx/QIH4OQol9V/TDxv/gzJahZ4yxOqwlFpYYVZK4paIEjqenBfduBLRHmt/y2Ir7hzNKY72iN1TodggemkDPR0ia2kO1wUV+CHrdhiiCx68=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2440.eurprd05.prod.outlook.com (10.168.71.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Thu, 15 Aug 2019 19:10:02 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.016; Thu, 15 Aug 2019
 19:10:02 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 08/16] net/mlx5e: Add support to rx reporter diagnose
Thread-Topic: [net-next 08/16] net/mlx5e: Add support to rx reporter diagnose
Thread-Index: AQHVU50JTaidP9w7q0ytbg2sCxDnxA==
Date:   Thu, 15 Aug 2019 19:10:02 +0000
Message-ID: <20190815190911.12050-9-saeedm@mellanox.com>
References: <20190815190911.12050-1-saeedm@mellanox.com>
In-Reply-To: <20190815190911.12050-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR04CA0017.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::27) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f296faa5-09bc-4130-c447-08d721b42c60
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2440;
x-ms-traffictypediagnostic: DB6PR0501MB2440:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB2440072E9A06CD70B558A8E6BEAC0@DB6PR0501MB2440.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:136;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(199004)(189003)(6916009)(5024004)(2616005)(36756003)(446003)(76176011)(186003)(11346002)(52116002)(305945005)(386003)(7736002)(478600001)(476003)(102836004)(6506007)(99286004)(486006)(14454004)(3846002)(6116002)(14444005)(8676002)(8936002)(5660300002)(81156014)(81166006)(66066001)(26005)(30864003)(256004)(50226002)(6486002)(6436002)(107886003)(71200400001)(6512007)(54906003)(71190400001)(316002)(1076003)(2906002)(66446008)(53936002)(66946007)(66556008)(66476007)(64756008)(25786009)(86362001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2440;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JqrS0Dh7ty+F6+cnzM54axdWcFoAc8roVzFY5LoonU3hha/407RZ/4CIEjw+UWKsL5OIsGCxH9CzpavjdLmLetjjXL8HxkHu8gAHHY8fCz9jbQyzOHcVLE1AeLg/PHQl8QA2QAcNgOgqBJfE/OAz6NlIEaqehYnpdMEv6k2JJOnKMXF1aX1kCEk3B1vn0dvqD9RRQNg9RJrpWwsmAFhwHclbgBlYj5fnw3KQ+V1DpIlWAtcB6rH3m7K0IHo3ZERzE3Xsz2JlTpoMVdI6KJiLFnf5vepmys9c47OOZgdgDDXlbVnaYV2/Q45r+QLdGp1FNFijjtzyvq3dBQsBMdLosadHkWfGnY12cqCxfD7aeVQnh0Ji0A/IlAhhp6taRsLqyGQ2hjVuO6sAvpyrFWbsGHMo0kRO1/DzVSTj983uWGw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f296faa5-09bc-4130-c447-08d721b42c60
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 19:10:02.0382
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lh6LZfmnE6hsfumUX5DKiwHRcjvuBB/BN+AZZQHhJ7Q6a/MZdWTGHAWWJ3cIWlUHYV7FFsJ/z7arxRrcZVqeGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2440
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Add rx reporter, which supports diagnose call-back. Diagnostics output
include: information common to all RQs: RQ type, RQ size, RQ stride
size, CQ size and CQ stride size. In addition advertise information per
RQ and its related icosq and attached CQ.

$ devlink health diagnose pci/0000:00:0b.0 reporter rx
 Common config:
   RQ:
     type: 2 stride size: 2048 size: 8
   CQ:
     stride size: 64 size: 1024
 RQs:
   channel ix: 0 rqn: 4308 HW state: 1 SW state: 3 posted WQEs: 7 cc: 7 ICO=
SQ HW state: 1
   CQ:
     cqn: 1032 HW status: 0
   channel ix: 1 rqn: 4313 HW state: 1 SW state: 3 posted WQEs: 7 cc: 7 ICO=
SQ HW state: 1
   CQ:
     cqn: 1036 HW status: 0
   channel ix: 2 rqn: 4318 HW state: 1 SW state: 3 posted WQEs: 7 cc: 7 ICO=
SQ HW state: 1
   CQ:
     cqn: 1040 HW status: 0
   channel ix: 3 rqn: 4323 HW state: 1 SW state: 3 posted WQEs: 7 cc: 7 ICO=
SQ HW state: 1
   CQ:
     cqn: 1044 HW status: 0

$ devlink health diagnose pci/0000:00:0b.0 reporter rx -jp
{
    "Common config": {
        "RQ": {
            "type": 2,
            "stride size": 2048,
            "size": 8
        },
        "CQ": {
            "stride size": 64,
            "size": 1024
        }
    },
    "RQs": [ {
            "channel ix": 0,
            "rqn": 4308,
            "HW state": 1,
            "SW state": 3,
            "posted WQEs": 7,
            "cc": 7,
            "ICOSQ HW state": 1,
            "CQ": {
                "cqn": 1032,
                "HW status": 0
            }
        },{
            "channel ix": 1,
            "rqn": 4313,
            "HW state": 1,
            "SW state": 3,
            "posted WQEs": 7,
            "cc": 7,
            "ICOSQ HW state": 1,
            "CQ": {
                "cqn": 1036,
                "HW status": 0
            }
        },{
            "channel ix": 2,
            "rqn": 4318,
            "HW state": 1,
            "SW state": 3,
            "posted WQEs": 7,
            "cc": 7,
            "ICOSQ HW state": 1,
            "CQ": {
                "cqn": 1040,
                "HW status": 0
            }
        },{
            "channel ix": 3,
            "rqn": 4323,
            "HW state": 1,
            "SW state": 3,
            "posted WQEs": 7,
            "cc": 7,
            "ICOSQ HW state": 1,
            "CQ": {
                "cqn": 1044,
                "HW status": 0
            }
        } ]
}

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  21 ++
 .../ethernet/mellanox/mlx5/core/en/health.c   |  16 +-
 .../ethernet/mellanox/mlx5/core/en/health.h   |   3 +
 .../mellanox/mlx5/core/en/reporter_rx.c       | 195 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  20 --
 6 files changed, 236 insertions(+), 23 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.=
c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net=
/ethernet/mellanox/mlx5/core/Makefile
index 23d566a45a30..a3b9659649a8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -24,8 +24,8 @@ mlx5_core-y :=3D	main.o cmd.o debugfs.o fw.o eq.o uar.o p=
agealloc.o \
 mlx5_core-$(CONFIG_MLX5_CORE_EN) +=3D en_main.o en_common.o en_fs.o en_eth=
tool.o \
 		en_tx.o en_rx.o en_dim.o en_txrx.o en/xdp.o en_stats.o \
 		en_selftest.o en/port.o en/monitor_stats.o en/health.o \
-		en/reporter_tx.o en/params.o en/xsk/umem.o en/xsk/setup.o \
-		en/xsk/rx.o en/xsk/tx.o
+		en/reporter_tx.o en/reporter_rx.o en/params.o en/xsk/umem.o \
+		en/xsk/setup.o en/xsk/rx.o en/xsk/tx.o
=20
 #
 # Netdev extra
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index 0807992090b8..de234650ba57 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -841,6 +841,7 @@ struct mlx5e_priv {
 	struct mlx5e_tls          *tls;
 #endif
 	struct devlink_health_reporter *tx_reporter;
+	struct devlink_health_reporter *rx_reporter;
 	struct mlx5e_xsk           xsk;
 };
=20
@@ -882,6 +883,26 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_bu=
dget);
 int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int budget);
 void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq);
=20
+static inline u32 mlx5e_rqwq_get_size(struct mlx5e_rq *rq)
+{
+	switch (rq->wq_type) {
+	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
+		return mlx5_wq_ll_get_size(&rq->mpwqe.wq);
+	default:
+		return mlx5_wq_cyc_get_size(&rq->wqe.wq);
+	}
+}
+
+static inline u32 mlx5e_rqwq_get_cur_sz(struct mlx5e_rq *rq)
+{
+	switch (rq->wq_type) {
+	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
+		return rq->mpwqe.wq.cur_sz;
+	default:
+		return rq->wqe.wq.cur_sz;
+	}
+}
+
 bool mlx5e_check_fragmented_striding_rq_cap(struct mlx5_core_dev *mdev);
 bool mlx5e_striding_rq_possible(struct mlx5_core_dev *mdev,
 				struct mlx5e_params *params);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/health.c
index c003757fbec0..191d609b0d99 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -98,11 +98,22 @@ int mlx5e_reporter_cq_common_diagnose(struct mlx5e_cq *=
cq, struct devlink_fmsg *
=20
 int mlx5e_health_create_reporters(struct mlx5e_priv *priv)
 {
-	return  mlx5e_reporter_tx_create(priv);
+	int err;
+
+	err =3D mlx5e_reporter_tx_create(priv);
+	if (err)
+		return err;
+
+	err =3D mlx5e_reporter_rx_create(priv);
+	if (err)
+		return err;
+
+	return 0;
 }
=20
 void mlx5e_health_destroy_reporters(struct mlx5e_priv *priv)
 {
+	mlx5e_reporter_rx_destroy(priv);
 	mlx5e_reporter_tx_destroy(priv);
 }
=20
@@ -111,6 +122,9 @@ void mlx5e_health_channels_update(struct mlx5e_priv *pr=
iv)
 	if (priv->tx_reporter)
 		devlink_health_reporter_state_update(priv->tx_reporter,
 						     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
+	if (priv->rx_reporter)
+		devlink_health_reporter_state_update(priv->rx_reporter,
+						     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
 }
=20
 int mlx5e_health_sq_to_ready(struct mlx5e_channel *channel, u32 sqn)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/=
net/ethernet/mellanox/mlx5/core/en/health.h
index b2c0ccc79b22..a751c5316baf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -16,6 +16,9 @@ int mlx5e_reporter_cq_common_diagnose(struct mlx5e_cq *cq=
, struct devlink_fmsg *
 int mlx5e_reporter_named_obj_nest_start(struct devlink_fmsg *fmsg, char *n=
ame);
 int mlx5e_reporter_named_obj_nest_end(struct devlink_fmsg *fmsg);
=20
+int mlx5e_reporter_rx_create(struct mlx5e_priv *priv);
+void mlx5e_reporter_rx_destroy(struct mlx5e_priv *priv);
+
 #define MLX5E_REPORTER_PER_Q_MAX_LEN 256
=20
 struct mlx5e_err_ctx {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
new file mode 100644
index 000000000000..66611c50e1c9
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -0,0 +1,195 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Mellanox Technologies.
+
+#include "health.h"
+#include "params.h"
+
+static int mlx5e_query_rq_state(struct mlx5_core_dev *dev, u32 rqn, u8 *st=
ate)
+{
+	int outlen =3D MLX5_ST_SZ_BYTES(query_rq_out);
+	void *out;
+	void *rqc;
+	int err;
+
+	out =3D kvzalloc(outlen, GFP_KERNEL);
+	if (!out)
+		return -ENOMEM;
+
+	err =3D mlx5_core_query_rq(dev, rqn, out);
+	if (err)
+		goto out;
+
+	rqc =3D MLX5_ADDR_OF(query_rq_out, out, rq_context);
+	*state =3D MLX5_GET(rqc, rqc, state);
+
+out:
+	kvfree(out);
+	return err;
+}
+
+static int mlx5e_rx_reporter_build_diagnose_output(struct mlx5e_rq *rq,
+						   struct devlink_fmsg *fmsg)
+{
+	struct mlx5e_priv *priv =3D rq->channel->priv;
+	struct mlx5e_params *params =3D &priv->channels.params;
+	struct mlx5e_icosq *icosq =3D &rq->channel->icosq;
+	u8 icosq_hw_state;
+	int wqes_sz;
+	u8 hw_state;
+	u16 wq_head;
+	int err;
+
+	err =3D mlx5e_query_rq_state(priv->mdev, rq->rqn, &hw_state);
+	if (err)
+		return err;
+
+	err =3D mlx5_core_query_sq_state(priv->mdev, icosq->sqn, &icosq_hw_state)=
;
+	if (err)
+		return err;
+
+	wqes_sz =3D mlx5e_rqwq_get_cur_sz(rq);
+	wq_head =3D params->rq_wq_type =3D=3D MLX5_WQ_TYPE_LINKED_LIST_STRIDING_R=
Q ?
+		  rq->mpwqe.wq.head : mlx5_wq_cyc_get_head(&rq->wqe.wq);
+
+	err =3D devlink_fmsg_obj_nest_start(fmsg);
+	if (err)
+		return err;
+
+	err =3D devlink_fmsg_u32_pair_put(fmsg, "channel ix", rq->channel->ix);
+	if (err)
+		return err;
+
+	err =3D devlink_fmsg_u32_pair_put(fmsg, "rqn", rq->rqn);
+	if (err)
+		return err;
+
+	err =3D devlink_fmsg_u8_pair_put(fmsg, "HW state", hw_state);
+	if (err)
+		return err;
+
+	err =3D devlink_fmsg_u8_pair_put(fmsg, "SW state", rq->state);
+	if (err)
+		return err;
+
+	err =3D devlink_fmsg_u32_pair_put(fmsg, "posted WQEs", wqes_sz);
+	if (err)
+		return err;
+
+	err =3D devlink_fmsg_u32_pair_put(fmsg, "cc", wq_head);
+	if (err)
+		return err;
+
+	err =3D devlink_fmsg_u8_pair_put(fmsg, "ICOSQ HW state", icosq_hw_state);
+	if (err)
+		return err;
+
+	err =3D mlx5e_reporter_cq_diagnose(&rq->cq, fmsg);
+	if (err)
+		return err;
+
+	err =3D devlink_fmsg_obj_nest_end(fmsg);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static int mlx5e_rx_reporter_diagnose(struct devlink_health_reporter *repo=
rter,
+				      struct devlink_fmsg *fmsg)
+{
+	struct mlx5e_priv *priv =3D devlink_health_reporter_priv(reporter);
+	struct mlx5e_params *params =3D &priv->channels.params;
+	struct mlx5e_rq *generic_rq;
+	u32 rq_stride, rq_sz;
+	int i, err =3D 0;
+
+	mutex_lock(&priv->state_lock);
+
+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
+		goto unlock;
+
+	generic_rq =3D &priv->channels.c[0]->rq;
+	rq_sz =3D mlx5e_rqwq_get_size(generic_rq);
+	rq_stride =3D BIT(mlx5e_mpwqe_get_log_stride_size(priv->mdev, params, NUL=
L));
+
+	err =3D mlx5e_reporter_named_obj_nest_start(fmsg, "Common config");
+	if (err)
+		goto unlock;
+
+	err =3D mlx5e_reporter_named_obj_nest_start(fmsg, "RQ");
+	if (err)
+		goto unlock;
+
+	err =3D devlink_fmsg_u8_pair_put(fmsg, "type", params->rq_wq_type);
+	if (err)
+		goto unlock;
+
+	err =3D devlink_fmsg_u64_pair_put(fmsg, "stride size", rq_stride);
+	if (err)
+		goto unlock;
+
+	err =3D devlink_fmsg_u32_pair_put(fmsg, "size", rq_sz);
+	if (err)
+		goto unlock;
+
+	err =3D mlx5e_reporter_named_obj_nest_end(fmsg);
+	if (err)
+		goto unlock;
+
+	err =3D mlx5e_reporter_cq_common_diagnose(&generic_rq->cq, fmsg);
+	if (err)
+		goto unlock;
+
+	err =3D mlx5e_reporter_named_obj_nest_end(fmsg);
+	if (err)
+		goto unlock;
+
+	err =3D devlink_fmsg_arr_pair_nest_start(fmsg, "RQs");
+	if (err)
+		goto unlock;
+
+	for (i =3D 0; i < priv->channels.num; i++) {
+		struct mlx5e_rq *rq =3D &priv->channels.c[i]->rq;
+
+		err =3D mlx5e_rx_reporter_build_diagnose_output(rq, fmsg);
+		if (err)
+			goto unlock;
+	}
+	err =3D devlink_fmsg_arr_pair_nest_end(fmsg);
+	if (err)
+		goto unlock;
+unlock:
+	mutex_unlock(&priv->state_lock);
+	return err;
+}
+
+static const struct devlink_health_reporter_ops mlx5_rx_reporter_ops =3D {
+	.name =3D "rx",
+	.diagnose =3D mlx5e_rx_reporter_diagnose,
+};
+
+int mlx5e_reporter_rx_create(struct mlx5e_priv *priv)
+{
+	struct devlink_health_reporter *reporter;
+	struct mlx5_core_dev *mdev =3D priv->mdev;
+	struct devlink *devlink =3D priv_to_devlink(mdev);
+
+	reporter =3D devlink_health_reporter_create(devlink,
+						  &mlx5_rx_reporter_ops,
+						  0, false, priv);
+	if (IS_ERR(reporter)) {
+		netdev_warn(priv->netdev, "Failed to create rx reporter, err =3D %ld\n",
+			    PTR_ERR(reporter));
+		return PTR_ERR(reporter);
+	}
+	priv->rx_reporter =3D reporter;
+	return 0;
+}
+
+void mlx5e_reporter_rx_destroy(struct mlx5e_priv *priv)
+{
+	if (!priv->rx_reporter)
+		return;
+
+	devlink_health_reporter_destroy(priv->rx_reporter);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 656e9be4f301..006e33e718d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -247,26 +247,6 @@ static inline void mlx5e_build_umr_wqe(struct mlx5e_rq=
 *rq,
 	ucseg->mkey_mask     =3D cpu_to_be64(MLX5_MKEY_MASK_FREE);
 }
=20
-static u32 mlx5e_rqwq_get_size(struct mlx5e_rq *rq)
-{
-	switch (rq->wq_type) {
-	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
-		return mlx5_wq_ll_get_size(&rq->mpwqe.wq);
-	default:
-		return mlx5_wq_cyc_get_size(&rq->wqe.wq);
-	}
-}
-
-static u32 mlx5e_rqwq_get_cur_sz(struct mlx5e_rq *rq)
-{
-	switch (rq->wq_type) {
-	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
-		return rq->mpwqe.wq.cur_sz;
-	default:
-		return rq->wqe.wq.cur_sz;
-	}
-}
-
 static int mlx5e_rq_alloc_mpwqe_info(struct mlx5e_rq *rq,
 				     struct mlx5e_channel *c)
 {
--=20
2.21.0

