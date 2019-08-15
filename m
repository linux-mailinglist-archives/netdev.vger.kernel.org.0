Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5545C8F42F
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732795AbfHOTKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:10:34 -0400
Received: from mail-eopbgr00076.outbound.protection.outlook.com ([40.107.0.76]:17437
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726008AbfHOTKd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 15:10:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XrSv1UY4xfi7JL3bnt86GNzvJxQZZUD1XHcowZ+2YBl586m72cvuiZyOiBQSd3jxjkBwaAdFkZEcNMzrB8B746VOjKwT95ZKsTXRnxEyz59eleNAcO8XAtV63gG02FD9pAdjUDE3gqKE1fiNcyuc/a+f7KdW/pq5b6EukHXMFu7D7ye739QaI3eH51yVabE3WwRXevWLE5RBomVcxoeSa+kLHQkLvuaLlTYvN6nVr2qhItHHUHnBmAK1sVZeYiz2Y7MocJML0OkItLccdcjXJnt6oPapljqviAffQNI8PAEjByGRN2oa14jefx7xYKoJWFmBACQDL9GQlEDGD2pKrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UVWFF1pjGVux2S/Mbhj5mxtMkGI6EfVJ56yn0RKuj7s=;
 b=LqLABFmWf9h96vyEJ3cOrW2pcbxMeLnVogIvVyv2okOvezaXPtRoDy7QoFxRZMjKoHpeVRMQ66JlW1dXYAwh6dMOKX66EwdaxeAuUMjuTaN629/zBR7PekgeD4Iz25J9Uadf/kfTjO9HpkVqQr2qJ2Im52yCFuuBh7uMCYjXyryzJHms3BYkDvS2VIUQxDWj9gE5BWsKnfEgON5lgK4uEd+lCE6c0G91EBiT21Yi0SgdfEnF9t/imYqcj/Mgzyp3XnL62p/Ow0wZK/cTplYZ6hlR2EahzKqdUvDw2xHm6X/+vMCuMixwvGjom7EZewRRVackeTf8N2s0GvDRpVOnUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UVWFF1pjGVux2S/Mbhj5mxtMkGI6EfVJ56yn0RKuj7s=;
 b=hEcEFQuZBaMg2xLpjMVkIqloybI4iajBua9dWp/DfoDvdkg2KuAME5w1mBkBHkpIpcw5oTOklN6WN2dYgiEp2STY6LSwG0S86ZGyqJVXjnV6Rau6ywM3jG8a+7lKWi2G3sEoNLg9Sdx5ACXDtDAl9QtcnuUVjbx10HPw/+mG5Eo=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2440.eurprd05.prod.outlook.com (10.168.71.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Thu, 15 Aug 2019 19:09:58 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.016; Thu, 15 Aug 2019
 19:09:58 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 06/16] net/mlx5e: Add cq info to tx reporter diagnose
Thread-Topic: [net-next 06/16] net/mlx5e: Add cq info to tx reporter diagnose
Thread-Index: AQHVU50HaFg4KMUPT02wjfUkmj4UPg==
Date:   Thu, 15 Aug 2019 19:09:58 +0000
Message-ID: <20190815190911.12050-7-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 22fca4bf-9465-4b88-cd1d-08d721b42a2f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2440;
x-ms-traffictypediagnostic: DB6PR0501MB2440:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB24409D352F9E9D17D61656FFBEAC0@DB6PR0501MB2440.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:220;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(199004)(189003)(6916009)(2616005)(36756003)(446003)(76176011)(186003)(11346002)(52116002)(305945005)(386003)(7736002)(478600001)(476003)(102836004)(6506007)(99286004)(486006)(14454004)(3846002)(6116002)(8676002)(8936002)(5660300002)(81156014)(81166006)(66066001)(26005)(256004)(50226002)(6486002)(6436002)(107886003)(71200400001)(6512007)(54906003)(71190400001)(316002)(1076003)(2906002)(66446008)(53936002)(66946007)(66556008)(66476007)(64756008)(25786009)(86362001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2440;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uH6lzLiHy/7uTyN6AwRIlusiADMkMDBIXTwNeGKx66b8Q6w/As1Hvg6IbaBX8vVdMfJtcfEFzdL6rHP0If+swbFpxGTJPf1TtuL3bjn968LE312vRfPVHKbZpdLKUqeng67RMCLNk7ptyMF75xG38+jpZeaDOdxEwX4LdLoa8/DannOFekD3Mlcu+gxUzXyNq3MV9em4QuqO3JQ4o8taWNtF3WzArhHswAVrHirP/lR36KYy6DnSrLBWv4OVoUf5UNk86xO9xGiXtxYrpvrjYdhC2/6mnSFnvPddsbj0q/1cfBxkVNIxhMg2/QtDR4c9dnWwKP0m7cjfhUZhjVi4rAZMrQ/jeupE3FhCm+1Bm4iTl2ycxKsrYd/d1PEPSukN2Nweyb8c4s1+mXO9h5UKjMQWUCCBCGmKWyT2mX3zZcs=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22fca4bf-9465-4b88-cd1d-08d721b42a2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 19:09:58.2959
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TTgBdKMXoSBrsE0xfdOcpFEEEQwIXG4JrnfyZSGwrDG6F/804Z2pBVzYpwqUjGtdoLfyMM7qaPswjTQ1jNep5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2440
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Add cq information to general diagnose output: CQ size and stride size.
Per SQ add information about the related CQ: cqn and CQ's HW status.

$ devlink health diagnose pci/0000:00:0b.0 reporter tx
 Common Config:
   SQ:
     stride size: 64 size: 1024
   CQ:
     stride size: 64 size: 1024
 SQs:
   channel ix: 0 tc: 0 txq ix: 0 sqn: 4307 HW state: 1 stopped: false cc: 0=
 pc: 0
   CQ:
     cqn: 1030 HW status: 0
   channel ix: 1 tc: 0 txq ix: 1 sqn: 4312 HW state: 1 stopped: false cc: 0=
 pc: 0
   CQ:
     cqn: 1034 HW status: 0
   channel ix: 2 tc: 0 txq ix: 2 sqn: 4317 HW state: 1 stopped: false cc: 0=
 pc: 0
   CQ:
     cqn: 1038 HW status: 0
   channel ix: 3 tc: 0 txq ix: 3 sqn: 4322 HW state: 1 stopped: false cc: 0=
 pc: 0
   CQ:
     cqn: 1042 HW status: 0

$ devlink health diagnose pci/0000:00:0b.0 reporter tx -jp
{
    "Common Config": {
        "SQ": {
            "stride size": 64,
            "size": 1024
        },
        "CQ": {
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
            "pc": 0,
            "CQ": {
                "cqn": 1030,
                "HW status": 0
            }
        },{
            "channel ix": 1,
            "tc": 0,
            "txq ix": 1,
            "sqn": 4312,
            "HW state": 1,
            "stopped": false,
            "cc": 0,
            "pc": 0,
            "CQ": {
                "cqn": 1034,
                "HW status": 0
            }
        },{
            "channel ix": 2,
            "tc": 0,
            "txq ix": 2,
            "sqn": 4317,
            "HW state": 1,
            "stopped": false,
            "cc": 0,
            "pc": 0,
            "CQ": {
                "cqn": 1038,
                "HW status": 0
            }
        },{
            "channel ix": 3,
            "tc": 0,
            "txq ix": 3,
            "sqn": 4322,
            "HW state": 1,
            "stopped": false,
            "cc": 0,
            "pc": 0,
            "CQ": {
                "cqn": 1042,
                "HW status": 0
        } ]
}

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/health.c   | 62 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en/health.h   |  2 +
 .../mellanox/mlx5/core/en/reporter_tx.c       |  8 +++
 drivers/net/ethernet/mellanox/mlx5/core/wq.c  |  5 ++
 drivers/net/ethernet/mellanox/mlx5/core/wq.h  |  1 +
 5 files changed, 78 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/health.c
index 1d9a138f02ab..63bf94cd5b67 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -34,6 +34,68 @@ int mlx5e_reporter_named_obj_nest_end(struct devlink_fms=
g *fmsg)
 	return 0;
 }
=20
+int mlx5e_reporter_cq_diagnose(struct mlx5e_cq *cq, struct devlink_fmsg *f=
msg)
+{
+	struct mlx5e_priv *priv =3D cq->channel->priv;
+	u32 out[MLX5_ST_SZ_DW(query_cq_out)] =3D {};
+	u8 hw_status;
+	void *cqc;
+	int err;
+
+	err =3D mlx5_core_query_cq(priv->mdev, &cq->mcq, out, sizeof(out));
+	if (err)
+		return err;
+
+	cqc =3D MLX5_ADDR_OF(query_cq_out, out, cq_context);
+	hw_status =3D MLX5_GET(cqc, cqc, status);
+
+	err =3D mlx5e_reporter_named_obj_nest_start(fmsg, "CQ");
+	if (err)
+		return err;
+
+	err =3D devlink_fmsg_u32_pair_put(fmsg, "cqn", cq->mcq.cqn);
+	if (err)
+		return err;
+
+	err =3D devlink_fmsg_u8_pair_put(fmsg, "HW status", hw_status);
+	if (err)
+		return err;
+
+	err =3D mlx5e_reporter_named_obj_nest_end(fmsg);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+int mlx5e_reporter_cq_common_diagnose(struct mlx5e_cq *cq, struct devlink_=
fmsg *fmsg)
+{
+	u8 cq_log_stride;
+	u32 cq_sz;
+	int err;
+
+	cq_sz =3D mlx5_cqwq_get_size(&cq->wq);
+	cq_log_stride =3D mlx5_cqwq_get_log_stride_size(&cq->wq);
+
+	err =3D mlx5e_reporter_named_obj_nest_start(fmsg, "CQ");
+	if (err)
+		return err;
+
+	err =3D devlink_fmsg_u64_pair_put(fmsg, "stride size", BIT(cq_log_stride)=
);
+	if (err)
+		return err;
+
+	err =3D devlink_fmsg_u32_pair_put(fmsg, "size", cq_sz);
+	if (err)
+		return err;
+
+	err =3D mlx5e_reporter_named_obj_nest_end(fmsg);
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
index 112771ad516c..6725d417aaf5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -11,6 +11,8 @@ void mlx5e_reporter_tx_destroy(struct mlx5e_priv *priv);
 void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq);
 int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq);
=20
+int mlx5e_reporter_cq_diagnose(struct mlx5e_cq *cq, struct devlink_fmsg *f=
msg);
+int mlx5e_reporter_cq_common_diagnose(struct mlx5e_cq *cq, struct devlink_=
fmsg *fmsg);
 int mlx5e_reporter_named_obj_nest_start(struct devlink_fmsg *fmsg, char *n=
ame);
 int mlx5e_reporter_named_obj_nest_end(struct devlink_fmsg *fmsg);
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 1fe6da1dea5b..f37c8a88cb74 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -185,6 +185,10 @@ mlx5e_tx_reporter_build_diagnose_output(struct devlink=
_fmsg *fmsg,
 	if (err)
 		return err;
=20
+	err =3D mlx5e_reporter_cq_diagnose(&sq->cq, fmsg);
+	if (err)
+		return err;
+
 	err =3D devlink_fmsg_obj_nest_end(fmsg);
 	if (err)
 		return err;
@@ -229,6 +233,10 @@ static int mlx5e_tx_reporter_diagnose(struct devlink_h=
ealth_reporter *reporter,
 	if (err)
 		goto unlock;
=20
+	err =3D mlx5e_reporter_cq_common_diagnose(&generic_sq->cq, fmsg);
+	if (err)
+		goto unlock;
+
 	err =3D mlx5e_reporter_named_obj_nest_end(fmsg);
 	if (err)
 		goto unlock;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wq.c b/drivers/net/eth=
ernet/mellanox/mlx5/core/wq.c
index 953cc8efba69..dd2315ce4441 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/wq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/wq.c
@@ -44,6 +44,11 @@ u32 mlx5_cqwq_get_size(struct mlx5_cqwq *wq)
 	return wq->fbc.sz_m1 + 1;
 }
=20
+u8 mlx5_cqwq_get_log_stride_size(struct mlx5_cqwq *wq)
+{
+	return wq->fbc.log_stride;
+}
+
 u32 mlx5_wq_ll_get_size(struct mlx5_wq_ll *wq)
 {
 	return (u32)wq->fbc.sz_m1 + 1;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wq.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/wq.h
index f1ec58c9e9e3..55791f71a778 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/wq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/wq.h
@@ -89,6 +89,7 @@ int mlx5_cqwq_create(struct mlx5_core_dev *mdev, struct m=
lx5_wq_param *param,
 		     void *cqc, struct mlx5_cqwq *wq,
 		     struct mlx5_wq_ctrl *wq_ctrl);
 u32 mlx5_cqwq_get_size(struct mlx5_cqwq *wq);
+u8 mlx5_cqwq_get_log_stride_size(struct mlx5_cqwq *wq);
=20
 int mlx5_wq_ll_create(struct mlx5_core_dev *mdev, struct mlx5_wq_param *pa=
ram,
 		      void *wqc, struct mlx5_wq_ll *wq,
--=20
2.21.0

