Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A60E096A3D
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 22:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730999AbfHTUYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 16:24:35 -0400
Received: from mail-eopbgr50051.outbound.protection.outlook.com ([40.107.5.51]:14918
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730966AbfHTUYe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 16:24:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lYc8sxyDWnA/vWrlOIzw1p1c3lXkKx0bmEH72Ebk/K5Y4xm2XD3yp51MDwnhF3mLvchkBRvb8xXkmE4iuQAtl/Y/AOYSf1xQHk3/J4XlqH6ksNq80001zWmdEDBCe598oj2p9jOjGBZOmDuhcjqVTWaKnDlIjBIaNlJx7CSgMlDhb1a+KqHU7ESibOTgvdwQGoHD5xgOvdR+0wwKS4Ret4MjHefzA4df0Oq8MQ5BPQ7QwwemJYhQ1orRaIKFUM/70+EUaW/Dm0ez4oY9VLyxBZ6lis186Ac7GJw7QCVp2pXlHTOeRt9REWuqwMvriSYzz8yOWCOeV9aB+RVquEIU0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHuSZm4xPNJxRFW+5KqbEPMLYRI7B+MKT8udes0VinM=;
 b=lrqX26AqW3wXzY0YN9ER9FdvPT4OmYMtrQMbfvAhC+cvig7c/T5/X42FoFS9/O4YwqeF2RURscAMJuNUXRR4osVyGpnJpDjQdsOnNyfkl3sQGFu8Dp1tvBgcdwR8Rrzmw0LjkaD4M8rScLpGIfTi30VEtSqGP3ZeEbCA0TeYpO6wuf+IkcEvDvCToSmny6i1xtSKEnKGElsTrYfyNlCoWWJYuzmhFe1PRsQNG4r96DAyTksQF4iF/86fXHJG4RxXP2iB1VYlONNzzbPzn9UJgGp2Af6+jYjeB0sJmZBiseaVtC5oK8eRkth7ErlwyI8Mq4d9mVSte9xiH1sKZZjxrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHuSZm4xPNJxRFW+5KqbEPMLYRI7B+MKT8udes0VinM=;
 b=AEhHkpyetwcMxZfTUUGkGSimbpk/HwCKNG0Njj2Sm+TiUvKUcEBynNaBwP1S99w7lIesZQFiTfnboF35p1QiGqeLICRC6zUELyuhxXIRZqsclwcGBEQIsp9/l82eE+lYVk5j6+5yMvnvKJH/QUkiBTOtlEaulPEzm+8Jm+9Uzok=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2680.eurprd05.prod.outlook.com (10.172.226.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Tue, 20 Aug 2019 20:24:22 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 20:24:22 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next v2 06/16] net/mlx5e: Add cq info to tx reporter diagnose
Thread-Topic: [net-next v2 06/16] net/mlx5e: Add cq info to tx reporter
 diagnose
Thread-Index: AQHVV5VAX8S8rA9HxEWLdl/j3ZmBuA==
Date:   Tue, 20 Aug 2019 20:24:22 +0000
Message-ID: <20190820202352.2995-7-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: bea77efb-0c9a-4f46-f90f-08d725ac6319
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2680;
x-ms-traffictypediagnostic: DB6PR0501MB2680:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB2680F0963C0C93AD7BDF781EBEAB0@DB6PR0501MB2680.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:220;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(39860400002)(396003)(199004)(189003)(446003)(11346002)(486006)(86362001)(476003)(8676002)(14454004)(81156014)(8936002)(25786009)(26005)(6486002)(102836004)(386003)(53936002)(6506007)(5660300002)(36756003)(6436002)(478600001)(7736002)(186003)(52116002)(99286004)(76176011)(6512007)(81166006)(66066001)(2906002)(2616005)(50226002)(4326008)(1076003)(64756008)(66556008)(256004)(66446008)(6116002)(66946007)(3846002)(6916009)(66476007)(316002)(71190400001)(71200400001)(107886003)(305945005)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2680;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: V//8+hk4lhnF/KiwwrQtu/JxXGqmMWlQszebJ3vA6kuL12HRfZClh0Ptt7yivK6kQ4CV3v4vU5FICr54pLF7LFqY5rCGXaI0Mi7OI3bQ91cH9H0pQ9cMz+OwCgC11uQIZ9tkYBIHL8SR8aafJpmov7ZgqQlawswTiysqmBfTigOlkvMJYolLWJrpBaMVB1z+4jVA/b0gjD9kEf3FYP0TM+X9uzhnpDmTG7vOcMgCLNiMy+E2s0bCEhcM5KSOua+/MBZJRHFRHIZgqiAOlBU1aQV/ZSaR+lS2Lq/sk2hWFE1R2bCZ25GvuyQfl5uhcaZePzEcm3L3RtWNzpcQz/Zo52tw5R44nO6mbw2EaUKVT5LHgu42/TOpEPnWRJSEUt8UG50+1D2nTi2Uc8+HeOGyMlwb1KxUVfgXufOAT9jNZJw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bea77efb-0c9a-4f46-f90f-08d725ac6319
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 20:24:22.4903
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3XJhEw5iVu+lXPMjsW6rtB8ocyh281N3H/TE8njDNM4rrH2gOBT0MsbuE7HEMhp0Poj3wZBeZ3e2tfB23fyagg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2680
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
index dab563f07157..ffd9a7a165a2 100644
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
index a5d0fcbb85af..bfed558637c2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -193,6 +193,10 @@ mlx5e_tx_reporter_build_diagnose_output(struct devlink=
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
@@ -233,6 +237,10 @@ static int mlx5e_tx_reporter_diagnose(struct devlink_h=
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

