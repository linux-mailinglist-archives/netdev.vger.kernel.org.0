Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4878F42A
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732617AbfHOTKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:10:14 -0400
Received: from mail-eopbgr00076.outbound.protection.outlook.com ([40.107.0.76]:17437
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726008AbfHOTKO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 15:10:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HF1uInddBl4ATE9+YCT+bQLvwUzPzIBHjybJ9xCDusZeJgFeTkJ+SgyQKxR5c5tl9czBtz7oEDEU7P0Mxc++Y89USbNIZINnvgU2WxNP6YSORn2AJtlce6NoI8BwLEos1PPALPDsyxAN7KwonWqMjd1zzB3MQrOJaDFAQgEvUt94gWLS86XiHfcnY+u9YZwr2R5M66g25mhWNyHP0huhzJRBrp4+XxJxJLYqwW3uwdTjQCGTFoDteOnDnj2JoTX4Lwge+kSFAnv2wNhvptv/Rfv4S2lrlmMbrKKCXqPJjuR8y5Zc1Zd4NxbnoGQeh1r7Jbq9DpDP0QLBZzmg6RIgJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m3DXcEy3A2rU+IDnee/Luh36qWglZhb1d+okH68lDNQ=;
 b=aGhOdi1Z7HA45AJZFKPCjovTQ6qkQm7PZIXe6YhGClpIBpDbloO/NIrrLhaQwt41OlardmL9tKt4mQzt1hVm4xQWJrceioZSaVWAGO5dnIh9tmlw900yBIRW6eAKkYrw2APo6NMdCR8F5hcb86NxSGhROZbyjtwYhUuQinUCKTThR/xbxf5bYAJKtKUckhAfnVvoQw29oFGk7HDDU/2AD4uVp6ks+6T0w/uKzNq0CgrWxz5/xk/P8x5t/AwfYoYiXPsP9D2ON0MnNUgIy/OwvuJ7B6Dv4T/tpWgXanyT69IWm2AG0PTsz/q4gOm3KPtpjx5/IQYLQ4UIMLXgoNm+ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m3DXcEy3A2rU+IDnee/Luh36qWglZhb1d+okH68lDNQ=;
 b=CObulULrPfDICp1TVAshRZfjzwAkQDdhU3QM5MxF2mJFRTptvn+6Tq1Y6h7ht/ihginM6ZpTakVhoU/mrEEzFkxpMzt2A6GHHw11WpGYxrygRqmpYla8+xgdsYePUX65qVzv7j1cOlBRx88kcR4HikWyrFwbx5S1ywMf1FDaFDw=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2440.eurprd05.prod.outlook.com (10.168.71.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Thu, 15 Aug 2019 19:09:56 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.016; Thu, 15 Aug 2019
 19:09:56 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 05/16] net/mlx5e: Extend tx reporter diagnostics output
Thread-Topic: [net-next 05/16] net/mlx5e: Extend tx reporter diagnostics
 output
Thread-Index: AQHVU50GoHgALzdtIEGEGwsOLk/6Lg==
Date:   Thu, 15 Aug 2019 19:09:56 +0000
Message-ID: <20190815190911.12050-6-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: fcb2b84e-fa9c-4166-e5ee-08d721b42900
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2440;
x-ms-traffictypediagnostic: DB6PR0501MB2440:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB2440914CA062904D97DAE6A2BEAC0@DB6PR0501MB2440.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:454;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(199004)(189003)(6916009)(2616005)(36756003)(446003)(76176011)(186003)(11346002)(52116002)(305945005)(386003)(7736002)(478600001)(476003)(102836004)(6506007)(99286004)(486006)(14454004)(3846002)(6116002)(14444005)(8676002)(8936002)(5660300002)(81156014)(81166006)(66066001)(26005)(256004)(50226002)(6486002)(6436002)(107886003)(71200400001)(6512007)(54906003)(71190400001)(316002)(1076003)(2906002)(66446008)(53936002)(66946007)(66556008)(66476007)(64756008)(25786009)(86362001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2440;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZDGsuE4q5L2Xh9K0ViWSl96yKm8m+idpP1jRVvKOkBbnIpU6kimJRQ6jqyv6poHN8/HZ4jEKbRMAN+Ors5p+Xj7mM2F8Mhdcb+V4h9W1rEPJCbjGyiU6MNtX4XV3FOVq8ER1jUQ1W4jGdLvt63iELrzhC2KR+Bm8jNG6nw31nBN1PXjioFQv+Y6Vrwm1yFCWrEA0QdgnfMuBnnVyptPkXIG0JemubaYVINccCTBpuvyiQdOry+KMVwq4U4W5/lm4mDNL02HHzqlsWk9RlJynSuiZ9z84Ii7nZAQyc72qUMlMY+7Vqowe4unIFXsILQEV+xXKn5TToYjTeyrChpFsp2tzEWFm3ePfw1qYS9CYSwZYxaJojG0XZApX7M+pXVsd2zniWW4rQJAZBI9hzkvT67L9LLF1fz0+XaKnLrffZCU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcb2b84e-fa9c-4166-e5ee-08d721b42900
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 19:09:56.4517
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 56wv10s5bUEVD9Sib8LJ2bvHrltDDbhuoTOYHad7wkI5Jf7REUifcP+QOOHZo2h4DlNs0K+/D25NiRSYoPdcdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2440
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
index 60166e5432ae..1d9a138f02ab 100644
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
index 411813a457a7..1fe6da1dea5b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -138,7 +138,7 @@ static int mlx5e_tx_reporter_recover(struct devlink_hea=
lth_reporter *reporter,
=20
 static int
 mlx5e_tx_reporter_build_diagnose_output(struct devlink_fmsg *fmsg,
-					struct mlx5e_txqsq *sq)
+					struct mlx5e_txqsq *sq, int tc)
 {
 	struct mlx5e_priv *priv =3D sq->channel->priv;
 	bool stopped =3D netif_xmit_stopped(sq->txq);
@@ -153,6 +153,18 @@ mlx5e_tx_reporter_build_diagnose_output(struct devlink=
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
@@ -165,6 +177,14 @@ mlx5e_tx_reporter_build_diagnose_output(struct devlink=
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
@@ -176,24 +196,57 @@ static int mlx5e_tx_reporter_diagnose(struct devlink_=
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

