Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9C6C96A5D
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 22:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731150AbfHTUZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 16:25:33 -0400
Received: from mail-eopbgr140043.outbound.protection.outlook.com ([40.107.14.43]:15333
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730930AbfHTUYg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 16:24:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N3fiNLBDmu8Lw8RjGqI+BmpY0rB8ZNIg5CtUNhx6Ctqk1m4e2aXGkChIROF3CTyEYHFd62QZor/GVwRmcn2sqmhozrMxJfdHZyWTqN5g0qiXVTd7jdJ1vYOpd6M6lrWrZ7v1AWf4P0hQLqaw/5vLi6fQtdBA6d9UbrdaL48N+W1W9if8gzkiUFisT1FcolTUNSxgWnmpqairxlDDhZA/pVdC/jn3/RCJY/8RUINFF3+Ekuxk0DMk7aGRrH7naiTkPoO9tAk6GzJ4YbANgTJW77egE4v1ld6/vinoRik/vSdAnRBxQHB4LiVjiJIpXtgo7HXgKRiJ3K8Q1XYtvco23w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eOayp1E25JFgKzZ20eCj8LPD9JyYmuu0mlf47ukyxaw=;
 b=AJ55DesOGPXed2Yfav+rDr+qy6HWLijZzcJb2Yw0EaR3MleijC3DfaiJfx0xsbTQkV0qcnKx0vKTeZ38Oi3KATaPhmBgcpN/xfoiBcCbTeRCRXel9acDH/FKY5DUMsbRn/iHbfgJXt/dqnrFpqjsB8LjFSg5sFkHgjUXU1eEojK5SglMp490855Mankm4DM/I7A19WcheQmCbQbj3csjHP8qJS2fMQihzLmbwlwB1husZCF/xEy3dTaupB8zWpPaxjkvVODRLHyMyFPM/OLxCFNEy+2oYkmAjVIE5/9ODGgZ3bSpa5gqN1W0or69auc/PPdYYGv5AoCieP+nQZt5tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eOayp1E25JFgKzZ20eCj8LPD9JyYmuu0mlf47ukyxaw=;
 b=jEn6ObfcuKLKNWj0ryu6WM8NU1K2S27WgipB99cFwwBRBOlVks1+5q8Q5hvtRTkxzvSKYaK17Az+bLahVSbF8kCPAkZZdznKUgwdJU/7i9b7VRc3j150iEKWGFbI5fa0irw1KAqnMycnZ16jmPz7S9gU8NM0m1NLjGtQOlzdxQ8=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2680.eurprd05.prod.outlook.com (10.172.226.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Tue, 20 Aug 2019 20:24:20 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 20:24:20 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next v2 05/16] net/mlx5e: Extend tx reporter diagnostics output
Thread-Topic: [net-next v2 05/16] net/mlx5e: Extend tx reporter diagnostics
 output
Thread-Index: AQHVV5U/fhF4cTO4ckm10eRXmeuQhg==
Date:   Tue, 20 Aug 2019 20:24:20 +0000
Message-ID: <20190820202352.2995-6-saeedm@mellanox.com>
References: <20190820202352.2995-1-saeedm@mellanox.com>
In-Reply-To: <20190820202352.2995-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:a03:54::23) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d8ad9e9d-9bf9-4a30-609c-08d725ac61d0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2680;
x-ms-traffictypediagnostic: DB6PR0501MB2680:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB2680A0226CA67A8DCFFF126BBEAB0@DB6PR0501MB2680.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:454;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(39860400002)(396003)(199004)(189003)(446003)(11346002)(486006)(86362001)(476003)(8676002)(14454004)(81156014)(8936002)(25786009)(26005)(6486002)(102836004)(386003)(53936002)(6506007)(5660300002)(36756003)(6436002)(478600001)(7736002)(186003)(52116002)(99286004)(76176011)(6512007)(81166006)(66066001)(2906002)(2616005)(50226002)(4326008)(14444005)(1076003)(64756008)(66556008)(256004)(66446008)(6116002)(66946007)(3846002)(6916009)(66476007)(316002)(71190400001)(71200400001)(107886003)(305945005)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2680;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: s4Fz7SA4XVKwWGM6b9ff+RT3rStL/ad6jVQ2Jt00jnRP014l3HMZBCdeLCnXr11Jwq11/p43rkZA45JcfPUSV0rDl3rDhNiWjuDscSby06FOapmihr5xFVPKebbb4jH1qDHOM8adt28gFg1dYbe74N+KK1g6pN7aFHqzMUrhRXA/47xldK8ql31ADhnGJHxw2qT1wS09M/krJQHRubmnD4h9vAc6d6TjEjBbxdDy6yJwGQFIYc5RvOXYds5s71HrJPMhMQ94XCktLWEdcHfLgbYBX1NwVX5RooONg7ZquS1DdmTwPy+b2o+FO7gYarxc7ejuXdgWMAtgY0tYtrvEsfYZjVFZ8KxwZfF5cqmSzmIHxlPwDJHOwm0Jep0sERZzdGW9+Gp/8Z8fO0EUw05lPQlnSOB9EtLJD67rM6NLeMo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8ad9e9d-9bf9-4a30-609c-08d725ac61d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 20:24:20.3602
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EMS8m0jqh4h7R8KII8aSRvtu9ESfFnH0rdsOVIobkr6i6n71S4i5zSv5jvY9jtIigPL280SZaP2BIxU0gZu5og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2680
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Enhance tx reporter's diagnostics output to include: information common
to all SQs: SQ size, SQ stride size.
In addition add channel ix, tc, txq ix, cc and pc.

$ devlink health diagnose pci/0000:00:0b.0 reporter tx
 Common config:
   SQ:
     stride size: 64 size: 1024
 SQs:
   channel ix: 0 tc: 0 txq ix: 0 sqn: 4307 HW state: 1 stopped: false cc: 0=
 pc: 0
   channel ix: 1 tc: 0 txq ix: 1 sqn: 4312 HW state: 1 stopped: false cc: 0=
 pc: 0
   channel ix: 2 tc: 0 txq ix: 2 sqn: 4317 HW state: 1 stopped: false cc: 0=
 pc: 0
   channel ix: 3 tc: 0 txq ix: 3 sqn: 4322 HW state: 1 stopped: false cc: 0=
 pc: 0

$ devlink health diagnose pci/0000:00:0b.0 reporter tx -jp
{
    "Common config": {
        "SQ": {
            "stride size": 64,
            "size": 1024
        }
    },
    "SQs": [ {
            "channel ix": 0,
            "tc": 0,
            "txq ix": 0,
            "sqn": 4307,
            "HW state": 1,
            "stopped": false,
            "cc": 0,
            "pc": 0
        },{
            "channel ix": 1,
            "tc": 0,
            "txq ix": 1,
            "sqn": 4312,
            "HW state": 1,
            "stopped": false,
            "cc": 0,
            "pc": 0
        },{
            "channel ix": 2,
            "tc": 0,
            "txq ix": 2,
            "sqn": 4317,
            "HW state": 1,
            "stopped": false,
            "cc": 0,
            "pc": 0
        },{
            "channel ix": 3,
            "tc": 0,
            "txq ix": 3,
            "sqn": 4322,
            "HW state": 1,
            "stopped": false,
            "cc": 0,
            "pc": 0
         } ]
}

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/health.c   | 30 ++++++++
 .../ethernet/mellanox/mlx5/core/en/health.h   |  3 +
 .../mellanox/mlx5/core/en/reporter_tx.c       | 69 ++++++++++++++++---
 3 files changed, 94 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/health.c
index fc3112921bd3..dab563f07157 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -4,6 +4,36 @@
 #include "health.h"
 #include "lib/eq.h"
=20
+int mlx5e_reporter_named_obj_nest_start(struct devlink_fmsg *fmsg, char *n=
ame)
+{
+	int err;
+
+	err =3D devlink_fmsg_pair_nest_start(fmsg, name);
+	if (err)
+		return err;
+
+	err =3D devlink_fmsg_obj_nest_start(fmsg);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+int mlx5e_reporter_named_obj_nest_end(struct devlink_fmsg *fmsg)
+{
+	int err;
+
+	err =3D devlink_fmsg_obj_nest_end(fmsg);
+	if (err)
+		return err;
+
+	err =3D devlink_fmsg_pair_nest_end(fmsg);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 int mlx5e_health_sq_to_ready(struct mlx5e_channel *channel, u32 sqn)
 {
 	struct mlx5_core_dev *mdev =3D channel->mdev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/=
net/ethernet/mellanox/mlx5/core/en/health.h
index 386bda6104aa..112771ad516c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -11,6 +11,9 @@ void mlx5e_reporter_tx_destroy(struct mlx5e_priv *priv);
 void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq);
 int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq);
=20
+int mlx5e_reporter_named_obj_nest_start(struct devlink_fmsg *fmsg, char *n=
ame);
+int mlx5e_reporter_named_obj_nest_end(struct devlink_fmsg *fmsg);
+
 #define MLX5E_REPORTER_PER_Q_MAX_LEN 256
=20
 struct mlx5e_err_ctx {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index b9429ff8d9c4..a5d0fcbb85af 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -146,7 +146,7 @@ static int mlx5e_tx_reporter_recover(struct devlink_hea=
lth_reporter *reporter,
=20
 static int
 mlx5e_tx_reporter_build_diagnose_output(struct devlink_fmsg *fmsg,
-					struct mlx5e_txqsq *sq)
+					struct mlx5e_txqsq *sq, int tc)
 {
 	struct mlx5e_priv *priv =3D sq->channel->priv;
 	bool stopped =3D netif_xmit_stopped(sq->txq);
@@ -161,6 +161,18 @@ mlx5e_tx_reporter_build_diagnose_output(struct devlink=
_fmsg *fmsg,
 	if (err)
 		return err;
=20
+	err =3D devlink_fmsg_u32_pair_put(fmsg, "channel ix", sq->ch_ix);
+	if (err)
+		return err;
+
+	err =3D devlink_fmsg_u32_pair_put(fmsg, "tc", tc);
+	if (err)
+		return err;
+
+	err =3D devlink_fmsg_u32_pair_put(fmsg, "txq ix", sq->txq_ix);
+	if (err)
+		return err;
+
 	err =3D devlink_fmsg_u32_pair_put(fmsg, "sqn", sq->sqn);
 	if (err)
 		return err;
@@ -173,6 +185,14 @@ mlx5e_tx_reporter_build_diagnose_output(struct devlink=
_fmsg *fmsg,
 	if (err)
 		return err;
=20
+	err =3D devlink_fmsg_u32_pair_put(fmsg, "cc", sq->cc);
+	if (err)
+		return err;
+
+	err =3D devlink_fmsg_u32_pair_put(fmsg, "pc", sq->pc);
+	if (err)
+		return err;
+
 	err =3D devlink_fmsg_obj_nest_end(fmsg);
 	if (err)
 		return err;
@@ -184,24 +204,57 @@ static int mlx5e_tx_reporter_diagnose(struct devlink_=
health_reporter *reporter,
 				      struct devlink_fmsg *fmsg)
 {
 	struct mlx5e_priv *priv =3D devlink_health_reporter_priv(reporter);
-	int i, err =3D 0;
+	struct mlx5e_txqsq *generic_sq =3D priv->txq2sq[0];
+	u32 sq_stride, sq_sz;
+
+	int i, tc, err =3D 0;
=20
 	mutex_lock(&priv->state_lock);
=20
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
 		goto unlock;
=20
+	sq_sz =3D mlx5_wq_cyc_get_size(&generic_sq->wq);
+	sq_stride =3D MLX5_SEND_WQE_BB;
+
+	err =3D mlx5e_reporter_named_obj_nest_start(fmsg, "Common Config");
+	if (err)
+		goto unlock;
+
+	err =3D mlx5e_reporter_named_obj_nest_start(fmsg, "SQ");
+	if (err)
+		goto unlock;
+
+	err =3D devlink_fmsg_u64_pair_put(fmsg, "stride size", sq_stride);
+	if (err)
+		goto unlock;
+
+	err =3D devlink_fmsg_u32_pair_put(fmsg, "size", sq_sz);
+	if (err)
+		goto unlock;
+
+	err =3D mlx5e_reporter_named_obj_nest_end(fmsg);
+	if (err)
+		goto unlock;
+
+	err =3D mlx5e_reporter_named_obj_nest_end(fmsg);
+	if (err)
+		goto unlock;
+
 	err =3D devlink_fmsg_arr_pair_nest_start(fmsg, "SQs");
 	if (err)
 		goto unlock;
=20
-	for (i =3D 0; i < priv->channels.num * priv->channels.params.num_tc;
-	     i++) {
-		struct mlx5e_txqsq *sq =3D priv->txq2sq[i];
+	for (i =3D 0; i < priv->channels.num; i++) {
+		struct mlx5e_channel *c =3D priv->channels.c[i];
+
+		for (tc =3D 0; tc < priv->channels.params.num_tc; tc++) {
+			struct mlx5e_txqsq *sq =3D &c->sq[tc];
=20
-		err =3D mlx5e_tx_reporter_build_diagnose_output(fmsg, sq);
-		if (err)
-			goto unlock;
+			err =3D mlx5e_tx_reporter_build_diagnose_output(fmsg, sq, tc);
+			if (err)
+				goto unlock;
+		}
 	}
 	err =3D devlink_fmsg_arr_pair_nest_end(fmsg);
 	if (err)
--=20
2.21.0

