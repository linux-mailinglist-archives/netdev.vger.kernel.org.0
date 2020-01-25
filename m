Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4EF14936E
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 06:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgAYFLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 00:11:20 -0500
Received: from mail-db8eur05on2084.outbound.protection.outlook.com ([40.107.20.84]:50912
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725267AbgAYFLU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 00:11:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aMTFhUyNjrp0M+Jh6jWhca1PQ+y4F33dGz2KEMC6LMxGosD2lD7ypFA/RYUzRZiQDtAtlKZr8T0LH5AmV0SSTgQNLm1Gc06jqxYk1obiDF3g9F6zeJA9hhlYx4nEjtN0zw6BNoYYI+eU1LxlXKqQkTU2yHtPrKXE0FNUbKDhAnbmLQZIWXNfxbvVOxO/RaAF1OhzF82DPg7y5shpbkVZHeDOjlJRqSU8kn4j16qDAY/XY5e5jm+8aOT/KmS9+IWDYEJSX4H4wq2Mi1DhR+JgFIt7zCx/CoVEAGAYn0+ZDEqssZamULik2wLmdAAedS6zCti9KKoBa4O3tezREtgXug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yZZT/45EZ/A8khfgBe/w/cbnAOPkUMjdATZYtzUDJyw=;
 b=hqNMZJ1iUPhrJOeQEaQzzzRvjzoSsRfAhhpYUqCPPl0nIfwKWlEpPzwr64nYk76VIbcUfXHzoJu3nGVa/ECATiH/0rPNdrwiOKWAuy2U523N3wTnqKqpfwpmiiws8xdv6Fg+iD6SvNQmWyImubo4lkZSxiC0ttTEap5jzZwsQ3HoUPraCEr0PCziFl/rAfYlor5PI39t3p5M9lGiCj7kRHNSM7f0Ra2k0NbazOmqRQs7+ChFiTmSrA3d9Cp4Gep4cOdV4VUUGk3MyyCQff0ZtpYqWQhRIU8NksRUml6y5XzBYVJ6budi2qBRD8dbbFQc44O7SiDeSBN+2GomwGTmOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yZZT/45EZ/A8khfgBe/w/cbnAOPkUMjdATZYtzUDJyw=;
 b=JcfxXmXJhEethRRuL8ZHhG7Sncfrny47grlqYAtTa+0uHc1zfPNT1iw40dfHwwrvDE4GUfyre8x2TTpcPo4YACrEwEcoC8UqgZ/NnLEkh2YqALWcjR2PCmQ70leABozqodk+Iv3cm0k3glR7048rbtbEQ/w+r0BhA4wImccdCfc=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1SPR01MB0394.eurprd05.prod.outlook.com (10.186.159.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Sat, 25 Jan 2020 05:11:16 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Sat, 25 Jan 2020
 05:11:16 +0000
Received: from smtp.office365.com (73.15.39.150) by BY5PR16CA0025.namprd16.prod.outlook.com (2603:10b6:a03:1a0::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend Transport; Sat, 25 Jan 2020 05:11:12 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 04/14] net/mlx5e: Support dump callback in TX reporter
Thread-Topic: [net-next V2 04/14] net/mlx5e: Support dump callback in TX
 reporter
Thread-Index: AQHV0z3eILGvOzbhNEWQuav2vTjTLw==
Date:   Sat, 25 Jan 2020 05:11:15 +0000
Message-ID: <20200125051039.59165-5-saeedm@mellanox.com>
References: <20200125051039.59165-1-saeedm@mellanox.com>
In-Reply-To: <20200125051039.59165-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BY5PR16CA0025.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::38) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b4d1f4bd-324c-484c-2b49-08d7a154ffbd
x-ms-traffictypediagnostic: VI1SPR01MB0394:|VI1SPR01MB0394:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1SPR01MB039451F1635BE9F7C22E73D8BE090@VI1SPR01MB0394.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:849;
x-forefront-prvs: 0293D40691
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(199004)(189003)(1076003)(30864003)(71200400001)(8936002)(316002)(16526019)(6916009)(186003)(2616005)(956004)(478600001)(54906003)(5660300002)(6486002)(4326008)(107886003)(86362001)(52116002)(2906002)(36756003)(66946007)(66476007)(81166006)(66446008)(64756008)(8676002)(26005)(81156014)(6506007)(66556008)(6512007)(54420400002)(505234006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB0394;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4Z/9bDl+T/lucWN4OUKeFRw8umQjr6x0VYyZOIOMpokxrc9Qubo3U9D1WZYzDoaPn1mJL5vZoakSZWkubqylpN674jRduwwi7j6Ib1oMwJXnaGPq8ftRGCA0AagwJno+W7utMm2p/IaY7NOOgNPdTFnCRF7K1IgYGt7JO9tR5wBYE1iSbREhuknGD7Dpu9fSALS2a0QJPQRnn9IlSOr+HGVb+sA/ox865x7AGBSknIami3W/R/aDKPl+WdbsYsOrsFjqds7QXhOwkzBeDJWiFNLyugp2UQkORvXNwg3X7Od/JcTBnjpbr4sJ0CcBRWGflBBVEXWLjKFzudjBcQbVjWcRlGL0UXG4GzhqcDl5v9gb8hF4/jVuAvnSClXFYyMgRQUBrih2emmo5vda6Umhad/zXzYiE/kBX6JGWk391uEvSVhoyKOmLvKQvCf9pluF1I9nqLrUD4w4qam5XPzoPRvgPz15l4VKkfCqmhKhvX3gBfHiJDW0XmsgJA3Ibkv46HDdJiEPcEStsy3nxqP6v8dsgPdFpiOY015oMsjudi1MXO8URPIFuP2aTwUW4s2G
x-ms-exchange-antispam-messagedata: xX+v8+sgfqgtBBGGPA3+tYbPvLZPeToC//VmC/StxjWtssncsj/bud8IfZpSXbKYeDb1+hhBdP6fWc1p26B5ruqq5MrGkw/Ilz9ttTMuXsroYXR5LF2SrKmcFNN2KX2whOPrfQrSBLqEpHvXazPY+w==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4d1f4bd-324c-484c-2b49-08d7a154ffbd
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2020 05:11:15.8663
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7yEamuFSySE9Mldq5HQaFQN9ksQiUPjBsq7ofMG+8LUORE/Xn79jog5NoVG2nXfJYmfljGQupYqfgbr0mk4OuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0394
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Add support for SQ's FW dump on TX reporter's events. Use Resource dump
API to retrieve the relevant data: SX slice, SQ dump and SQ buffer. Wrap
it in formatted messages and store the binary output in devlink core.

Example:
$ devlink health dump show pci/0000:00:0b.0 reporter tx
SX Slice:
   data:
     00 00 00 00 00 00 00 80 00 01 00 00 00 00 ad de
     22 01 00 00 00 00 ad de 00 00 00 00 00 00 00 00
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
     ff ff ff ff 01 00 00 00 00 00 00 00 00 00 00 00
     00 02 01 00 00 00 00 80 00 01 00 00 00 00 ad de
     22 01 00 00 00 00 ad de 00 20 40 90 81 88 ff ff
     00 00 00 00 00 00 00 00 15 00 15 00 00 00 00 00
     ff ff ff ff 01 00 00 00 00 00 00 00 00 00 00 00
     00 00 00 00 00 00 00 80 81 ae 41 06 00 ea ff ff
  SQs:
    SQ:
      index: 1511
      data:
        00 00 00 00 00 00 00 80 00 01 00 00 00 00 ad de
        22 01 00 00 00 00 ad de 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
        ff ff ff ff 01 00 00 00 00 00 00 00 00 00 00 00
        00 02 01 00 00 00 00 80 00 01 00 00 00 00 ad de
        22 01 00 00 00 00 ad de 00 20 40 90 81 88 ff ff
        00 00 00 00 00 00 00 00 15 00 15 00 00 00 00 00
        ff ff ff ff 01 00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 80 81 ae 41 06 00 ea ff ff
    SQ:
      index: 1516
      data:
        00 00 00 00 00 00 00 80 00 01 00 00 00 00 ad de
        22 01 00 00 00 00 ad de 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
        ff ff ff ff 01 00 00 00 00 00 00 00 00 00 00 00
        00 02 01 00 00 00 00 80 00 01 00 00 00 00 ad de
        22 01 00 00 00 00 ad de 00 20 40 90 81 88 ff ff
        00 00 00 00 00 00 00 00 15 00 15 00 00 00 00 00
        ff ff ff ff 01 00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 80 81 ae 41 06 00 ea ff ff

$ devlink health dump show pci/0000:00:0b.0 reporter tx -jp
{
    "SX Slice": {
    	"data": [ 0,0,0,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,0,173,222,0=
,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,1,0,0,0,0,0,=
0,0,0,0,0,0,0,2,1,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,0,173,222,0,32=
,64,144,129,136,255,255,0,0,0,0,0,0,0,0,21,0,21,0,0,0,0,0,255,255,255,255,1=
,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,129,174,65,6,0,234,255,255],
    	},
    "SQs": [ {
            "SQ": {
                "index": 1511,
                "data": [ 0,0,0,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,=
0,173,222,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,1=
,0,0,0,0,0,0,0,0,0,0,0,0,2,1,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,0,1=
73,222,0,32,64,144,129,136,255,255,0,0,0,0,0,0,0,0,21,0,21,0,0,0,0,0,255,25=
5,255,255,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,129,174,65,6,0,234,255,=
255]
            }
        },{
            "SQ": {
                "index": 1516,
                "data": [ 0,0,0,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,=
0,173,222,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,1=
,0,0,0,0,0,0,0,0,0,0,0,0,2,1,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,0,1=
73,222,0,32,64,144,129,136,255,255,0,0,0,0,0,0,0,0,21,0,21,0,0,0,0,0,255,25=
5,255,255,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,129,174,65,6,0,234,255,=
255]
            }
        } ]
}

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/health.c   | 105 +++++++++++++++
 .../ethernet/mellanox/mlx5/core/en/health.h   |   8 +-
 .../mellanox/mlx5/core/en/reporter_tx.c       | 123 ++++++++++++++++++
 3 files changed, 234 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/health.c
index 3a975641f902..7178f421d2cb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -3,6 +3,7 @@
=20
 #include "health.h"
 #include "lib/eq.h"
+#include "lib/mlx5.h"
=20
 int mlx5e_reporter_named_obj_nest_start(struct devlink_fmsg *fmsg, char *n=
ame)
 {
@@ -204,3 +205,107 @@ int mlx5e_health_report(struct mlx5e_priv *priv,
=20
 	return devlink_health_report(reporter, err_str, err_ctx);
 }
+
+#define MLX5_HEALTH_DEVLINK_MAX_SIZE 1024
+static int mlx5e_health_rsc_fmsg_binary(struct devlink_fmsg *fmsg,
+					const void *value, u32 value_len)
+
+{
+	u32 data_size;
+	u32 offset;
+	int err;
+
+	for (offset =3D 0; offset < value_len; offset +=3D data_size) {
+		data_size =3D value_len - offset;
+		if (data_size > MLX5_HEALTH_DEVLINK_MAX_SIZE)
+			data_size =3D MLX5_HEALTH_DEVLINK_MAX_SIZE;
+		err =3D devlink_fmsg_binary_put(fmsg, value + offset, data_size);
+		if (err)
+			break;
+	}
+	return err;
+}
+
+int mlx5e_health_rsc_fmsg_dump(struct mlx5e_priv *priv, struct mlx5_rsc_ke=
y *key,
+			       struct devlink_fmsg *fmsg)
+{
+	struct mlx5_core_dev *mdev =3D priv->mdev;
+	struct mlx5_rsc_dump_cmd *cmd;
+	struct page *page;
+	int cmd_err, err;
+	int end_err;
+	int size;
+
+	if (IS_ERR_OR_NULL(mdev->rsc_dump))
+		return -EOPNOTSUPP;
+
+	page =3D alloc_page(GFP_KERNEL);
+	if (!page)
+		return -ENOMEM;
+
+	err =3D devlink_fmsg_binary_pair_nest_start(fmsg, "data");
+	if (err)
+		return err;
+
+	cmd =3D mlx5_rsc_dump_cmd_create(mdev, key);
+	if (IS_ERR(cmd)) {
+		err =3D PTR_ERR(cmd);
+		goto free_page;
+	}
+
+	do {
+		cmd_err =3D mlx5_rsc_dump_next(mdev, cmd, page, &size);
+		if (cmd_err < 0) {
+			err =3D cmd_err;
+			goto destroy_cmd;
+		}
+
+		err =3D mlx5e_health_rsc_fmsg_binary(fmsg, page_address(page), size);
+		if (err)
+			goto destroy_cmd;
+
+	} while (cmd_err > 0);
+
+destroy_cmd:
+	mlx5_rsc_dump_cmd_destroy(cmd);
+	end_err =3D devlink_fmsg_binary_pair_nest_end(fmsg);
+	if (end_err)
+		err =3D end_err;
+free_page:
+	__free_page(page);
+	return err;
+}
+
+int mlx5e_health_queue_dump(struct mlx5e_priv *priv, struct devlink_fmsg *=
fmsg,
+			    int queue_idx, char *lbl)
+{
+	struct mlx5_rsc_key key =3D {};
+	int err;
+
+	key.rsc =3D MLX5_SGMT_TYPE_FULL_QPC;
+	key.index1 =3D queue_idx;
+	key.size =3D PAGE_SIZE;
+	key.num_of_obj1 =3D 1;
+
+	err =3D devlink_fmsg_obj_nest_start(fmsg);
+	if (err)
+		return err;
+
+	err =3D mlx5e_reporter_named_obj_nest_start(fmsg, lbl);
+	if (err)
+		return err;
+
+	err =3D devlink_fmsg_u32_pair_put(fmsg, "index", queue_idx);
+	if (err)
+		return err;
+
+	err =3D mlx5e_health_rsc_fmsg_dump(priv, &key, fmsg);
+	if (err)
+		return err;
+
+	err =3D mlx5e_reporter_named_obj_nest_end(fmsg);
+	if (err)
+		return err;
+
+	return devlink_fmsg_obj_nest_end(fmsg);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/=
net/ethernet/mellanox/mlx5/core/en/health.h
index d3693fa547ac..e90e3aec422f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -5,6 +5,7 @@
 #define __MLX5E_EN_HEALTH_H
=20
 #include "en.h"
+#include "diag/rsc_dump.h"
=20
 #define MLX5E_RX_ERR_CQE(cqe) (get_cqe_opcode(cqe) !=3D MLX5_CQE_RESP_SEND=
)
=20
@@ -36,6 +37,7 @@ void mlx5e_reporter_rx_timeout(struct mlx5e_rq *rq);
=20
 struct mlx5e_err_ctx {
 	int (*recover)(void *ctx);
+	int (*dump)(struct mlx5e_priv *priv, struct devlink_fmsg *fmsg, void *ctx=
);
 	void *ctx;
 };
=20
@@ -48,6 +50,8 @@ int mlx5e_health_report(struct mlx5e_priv *priv,
 int mlx5e_health_create_reporters(struct mlx5e_priv *priv);
 void mlx5e_health_destroy_reporters(struct mlx5e_priv *priv);
 void mlx5e_health_channels_update(struct mlx5e_priv *priv);
-
-
+int mlx5e_health_rsc_fmsg_dump(struct mlx5e_priv *priv, struct mlx5_rsc_ke=
y *key,
+			       struct devlink_fmsg *fmsg);
+int mlx5e_health_queue_dump(struct mlx5e_priv *priv, struct devlink_fmsg *=
fmsg,
+			    int queue_idx, char *lbl);
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 623c949db54c..1772c9ce3938 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -246,6 +246,126 @@ static int mlx5e_tx_reporter_diagnose(struct devlink_=
health_reporter *reporter,
 	return err;
 }
=20
+static int mlx5e_tx_reporter_dump_sq(struct mlx5e_priv *priv, struct devli=
nk_fmsg *fmsg,
+				     void *ctx)
+{
+	struct mlx5_rsc_key key =3D {};
+	struct mlx5e_txqsq *sq =3D ctx;
+	int err;
+
+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
+		return 0;
+
+	err =3D mlx5e_reporter_named_obj_nest_start(fmsg, "SX Slice");
+	if (err)
+		return err;
+
+	key.size =3D PAGE_SIZE;
+	key.rsc =3D MLX5_SGMT_TYPE_SX_SLICE_ALL;
+	err =3D mlx5e_health_rsc_fmsg_dump(priv, &key, fmsg);
+	if (err)
+		return err;
+
+	err =3D mlx5e_reporter_named_obj_nest_end(fmsg);
+	if (err)
+		return err;
+
+	err =3D mlx5e_reporter_named_obj_nest_start(fmsg, "SQ");
+	if (err)
+		return err;
+
+	err =3D mlx5e_reporter_named_obj_nest_start(fmsg, "QPC");
+	if (err)
+		return err;
+
+	key.rsc =3D MLX5_SGMT_TYPE_FULL_QPC;
+	key.index1 =3D sq->sqn;
+	key.num_of_obj1 =3D 1;
+
+	err =3D mlx5e_health_rsc_fmsg_dump(priv, &key, fmsg);
+	if (err)
+		return err;
+
+	err =3D mlx5e_reporter_named_obj_nest_end(fmsg);
+	if (err)
+		return err;
+
+	err =3D mlx5e_reporter_named_obj_nest_start(fmsg, "send_buff");
+	if (err)
+		return err;
+
+	key.rsc =3D MLX5_SGMT_TYPE_SND_BUFF;
+	key.num_of_obj2 =3D MLX5_RSC_DUMP_ALL;
+	err =3D mlx5e_health_rsc_fmsg_dump(priv, &key, fmsg);
+	if (err)
+		return err;
+
+	err =3D mlx5e_reporter_named_obj_nest_end(fmsg);
+	if (err)
+		return err;
+
+	return mlx5e_reporter_named_obj_nest_end(fmsg);
+}
+
+static int mlx5e_tx_reporter_dump_all_sqs(struct mlx5e_priv *priv,
+					  struct devlink_fmsg *fmsg)
+{
+	struct mlx5_rsc_key key =3D {};
+	int i, tc, err;
+
+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
+		return 0;
+
+	err =3D mlx5e_reporter_named_obj_nest_start(fmsg, "SX Slice");
+	if (err)
+		return err;
+
+	key.size =3D PAGE_SIZE;
+	key.rsc =3D MLX5_SGMT_TYPE_SX_SLICE_ALL;
+	err =3D mlx5e_health_rsc_fmsg_dump(priv, &key, fmsg);
+	if (err)
+		return err;
+
+	err =3D mlx5e_reporter_named_obj_nest_end(fmsg);
+	if (err)
+		return err;
+
+	err =3D devlink_fmsg_arr_pair_nest_start(fmsg, "SQs");
+	if (err)
+		return err;
+
+	for (i =3D 0; i < priv->channels.num; i++) {
+		struct mlx5e_channel *c =3D priv->channels.c[i];
+
+		for (tc =3D 0; tc < priv->channels.params.num_tc; tc++) {
+			struct mlx5e_txqsq *sq =3D &c->sq[tc];
+
+			err =3D mlx5e_health_queue_dump(priv, fmsg, sq->sqn, "SQ");
+			if (err)
+				return err;
+		}
+	}
+	return devlink_fmsg_arr_pair_nest_end(fmsg);
+}
+
+static int mlx5e_tx_reporter_dump_from_ctx(struct mlx5e_priv *priv,
+					   struct mlx5e_err_ctx *err_ctx,
+					   struct devlink_fmsg *fmsg)
+{
+	return err_ctx->dump(priv, fmsg, err_ctx->ctx);
+}
+
+static int mlx5e_tx_reporter_dump(struct devlink_health_reporter *reporter=
,
+				  struct devlink_fmsg *fmsg, void *context,
+				  struct netlink_ext_ack *extack)
+{
+	struct mlx5e_priv *priv =3D devlink_health_reporter_priv(reporter);
+	struct mlx5e_err_ctx *err_ctx =3D context;
+
+	return err_ctx ? mlx5e_tx_reporter_dump_from_ctx(priv, err_ctx, fmsg) :
+			 mlx5e_tx_reporter_dump_all_sqs(priv, fmsg);
+}
+
 void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq)
 {
 	struct mlx5e_priv *priv =3D sq->channel->priv;
@@ -254,6 +374,7 @@ void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq)
=20
 	err_ctx.ctx =3D sq;
 	err_ctx.recover =3D mlx5e_tx_reporter_err_cqe_recover;
+	err_ctx.dump =3D mlx5e_tx_reporter_dump_sq;
 	sprintf(err_str, "ERR CQE on SQ: 0x%x", sq->sqn);
=20
 	mlx5e_health_report(priv, priv->tx_reporter, err_str, &err_ctx);
@@ -267,6 +388,7 @@ int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq)
=20
 	err_ctx.ctx =3D sq;
 	err_ctx.recover =3D mlx5e_tx_reporter_timeout_recover;
+	err_ctx.dump =3D mlx5e_tx_reporter_dump_sq;
 	sprintf(err_str,
 		"TX timeout on queue: %d, SQ: 0x%x, CQ: 0x%x, SQ Cons: 0x%x SQ Prod: 0x%=
x, usecs since last trans: %u\n",
 		sq->channel->ix, sq->sqn, sq->cq.mcq.cqn, sq->cc, sq->pc,
@@ -279,6 +401,7 @@ static const struct devlink_health_reporter_ops mlx5_tx=
_reporter_ops =3D {
 		.name =3D "tx",
 		.recover =3D mlx5e_tx_reporter_recover,
 		.diagnose =3D mlx5e_tx_reporter_diagnose,
+		.dump =3D mlx5e_tx_reporter_dump,
 };
=20
 #define MLX5_REPORTER_TX_GRACEFUL_PERIOD 500
--=20
2.24.1

