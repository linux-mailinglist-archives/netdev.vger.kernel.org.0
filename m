Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A83AF163B10
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 04:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgBSDXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 22:23:20 -0500
Received: from mail-db8eur05on2089.outbound.protection.outlook.com ([40.107.20.89]:22272
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726682AbgBSDXT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 22:23:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dgF3XZtQY1v+OnvQJW5waT1l/72UKMTl9fRA9OeV8HPcV2chgBIFNSpmXOK5kz4xpKYk5Rr3JEsFcNJzs1g0kiWWIG33N5SwTT/cxAODoX1JtTiofF3NZP5VoUywj2zPLjJk0ukXfFkNpR2+PDFjtwI/rTY71dp606VeqUKQcsM2G4pHES4Jljdr6VfZNOyb82MkGCk29PZIzdsIBSquXcjgqcYn+N/KyWkkEtOoGevJzUbRwhNvr36XqQvqp7avbDvyBAo8ufiwk+3XFVAW2hHJ3y2GhEL07f3i0UOXpQi3CI/BBaoZFm3IE3f9HH5JECYMHOzLR2BmNXKsDRkHsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bxE7iF7C3IfQGdb9HviTHfIjVaTbe02XyCgjrh774dE=;
 b=NLdRd7JUQn1FtwewnJG+Ik8IWaCMQ5kBJiqnO6phvzHJDOsJUCIZxYD6kdcK8PtWRFZVi7TMSIfQO7MzlRZh4Iaj1Dx2QQOwwSgRCY2MGv+Tt5i/09+SJ3YX0In+mr5WDCCMFBPKmWgXNTgGxfjU7Ye0VRjiRYcPqh69zn7WcpM/xRTTf6EreHlE/eNy6aGsy1pcHNaI3FHNajEtNGHjakGZxvh4Ac/ZLyIi7l0iSxMKQF+IKmZUS7SG0xYVflSTBvrG7lRdoxNeuSq/MLsn86q8LbEROQKHLPdirIhaqQgZDWhlWAHVNeixRX5eCnxZBEQ02A7/5Hd2ERw8IIoq3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bxE7iF7C3IfQGdb9HviTHfIjVaTbe02XyCgjrh774dE=;
 b=sVhpEHw6LctcM8f0Vebu7O99zF7ybbHEId4A8XlTwJnSGp69eWjZ+Ptpn3oQRl3EkkZ2BXp3BAAS6toJfckc7JFBs8NDkowEDCtiRpGYY09lpl3Kv9MX4Gcan+O9r/kIwqblGmHTVZ7TJlA/JMUDIixfP7aP3jDnhIq9v28BWaE=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4590.eurprd05.prod.outlook.com (20.176.5.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.27; Wed, 19 Feb 2020 03:23:11 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.028; Wed, 19 Feb 2020
 03:23:10 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR02CA0001.namprd02.prod.outlook.com (2603:10b6:a02:ee::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Wed, 19 Feb 2020 03:23:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V4 05/13] net/mlx5e: Support dump callback in RX reporter
Thread-Topic: [net-next V4 05/13] net/mlx5e: Support dump callback in RX
 reporter
Thread-Index: AQHV5tPpO5hVhgGvy0ai/tj/3SXAFQ==
Date:   Wed, 19 Feb 2020 03:23:10 +0000
Message-ID: <20200219032205.15264-6-saeedm@mellanox.com>
References: <20200219032205.15264-1-saeedm@mellanox.com>
In-Reply-To: <20200219032205.15264-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR02CA0001.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 10289013-a897-45d8-bde9-08d7b4eb0bcd
x-ms-traffictypediagnostic: VI1PR05MB4590:|VI1PR05MB4590:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB45902A02F9EA554E6232AC01BE100@VI1PR05MB4590.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0318501FAE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(376002)(396003)(136003)(39860400002)(189003)(199004)(2616005)(956004)(16526019)(186003)(478600001)(66446008)(6666004)(66556008)(71200400001)(26005)(86362001)(66946007)(66476007)(6512007)(36756003)(6486002)(64756008)(107886003)(4326008)(110136005)(8676002)(2906002)(5660300002)(316002)(54906003)(8936002)(52116002)(30864003)(81156014)(81166006)(6506007)(1076003)(54420400002)(505234006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4590;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AH/MU5o61laC3/o0qdKD49G9/STsKlQrDX5MbeiCc+o/a2ZUdA+UylQx6cFZC+ws+tkl65OXK8/YQ7o5Ii6rHqVCy4IkwWJbDcIzQT0Q9yq8lsXpMtFvq9GnPCRhxp2vv5TV5pBHenLwsDnH82UzFMGZu2svcZUBTnK5+n16PlacK5hISG4C6kQxk5Gl5eStwjc7bPcNW3k6k+23uAhW5OwaZkp/dgu5NA+9nSM/8/kfXtCXypM5mtzhpF7pf8/Erd4CsrbL7PpmTiuoHtB4OxsLU6u30Zkyxfjg50ubSi8kGzYLX1H3VwGQ2oSlwQTJCLdtWWb5W/HujQNPcSMFYYa6foX0xKSt2Gs7A2DiSY3Phu7UDD2bclgQbxU1f0pKaGmgCjW3h4/ifw4QHiC1/x8HBEMblHYkHhcou+1lRyuUDRBleAKVHa3akQXH3GpWBrd987ww5EW4bAuA+yalwGRZD9u2C7ViFzNvp5IC0/RRFTy68Dv4TGxR/M0Uswo8PImNz0lwEzFL/pF5gnzpFLJK12hM6EsWiVgSsFCk3XWQuvGYmS32wTjJZ5odso1z
x-ms-exchange-antispam-messagedata: Bxz/xRbQS4HYhmez87jRYyXlAJffatwJX55lEHqIeSatGY546Mvy87/LGQF/39FEAOGOLD7dWtTfpeqvRhTrjHNpSw0g87PTKAQE6c1SIsCGyJfhn1zYUFSyxbvzi+imcrqX72dV2kXcUH2PVaNKLA==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10289013-a897-45d8-bde9-08d7b4eb0bcd
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2020 03:23:10.6180
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rJ71Bb4y1tAC3AjUdAx41Y89//aOhZzz4dnXlczfTQ/fUlXezQ5csDNBSZBZqk7ziSBgIdPAFUH/pJr4DIyQTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4590
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Add support for SQ's FW dump on RX reporter's events. Use Resource dump
API to retrieve the relevant data: RX slice, RQ dump, RX buffer and
ICOSQ dump (depends on the error). Wrap it in formatted messages and
store the binary output in devlink core.

Example:
$ devlink health dump show pci/0000:00:0b.0 reporter rx
RX Slice:
   data:
     00 00 00 00 00 00 00 80 00 01 00 00 00 00 ad de
     22 01 00 00 00 00 ad de 00 00 00 00 00 00 00 00
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
     ff ff ff ff 01 00 00 00 00 00 00 00 00 00 00 00
     00 00 00 00 00 00 00 80 00 01 00 00 00 00 ad de
     22 01 00 00 00 00 ad de 00 00 00 00 00 00 00 00
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
     ff ff ff ff 01 00 00 00 00 00 00 00 00 00 00 00
     00 00 00 00 00 00 00 80 00 01 00 00 00 00 ad de
  RQs:
    RQ:
      rqn: 1512
      data:
        00 00 00 00 00 00 00 80 00 01 00 00 00 00 ad de
        22 01 00 00 00 00 ad de 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
        ff ff ff ff 01 00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 80 00 01 00 00 00 00 ad de
        22 01 00 00 00 00 ad de 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
        ff ff ff ff 01 00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 80 00 01 00 00 00 00 ad de
    RQ:
      rqn: 1517
      data:
        00 00 00 00 00 00 00 80 00 01 00 00 00 00 ad de
        22 01 00 00 00 00 ad de 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
        ff ff ff ff 01 00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 80 00 01 00 00 00 00 ad de
        22 01 00 00 00 00 ad de 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
        ff ff ff ff 01 00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 80 00 01 00 00 00 00 ad de

$ devlink health dump show pci/0000:00:0b.0 reporter rx -jp
{
    "RX Slice": {
    	"data":[ 0,0,0,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,0,173,222,0,=
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,1,0,0,0,0,0,0=
,0,0,0,0,0,0,0,0,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,0,173,222,0,0,0=
,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,1,0,0,0,0,0,0,0,=
0,0,0,0,0,0,0,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,0,173,222,0,0,0,0,=
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,1,0,0,0,0,0,0,0,0,0=
,0,0,0,0,0,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,0,173,222,0,0,0,0,0,0=
,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,1,0,0,0,0,0,0,0,0,0,0,=
0,0,0,0,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,0,173,222,0,0,0,0,0,0,0,=
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,1,0,0,0,0,0,0,0,0,0,0,0,0=
,2,1,0,0,0,0,128,0,1,0,0,0,0,173,222]
    },
    "RQs": [ {
            "RQ": {
                "index": 1512,
                "data": [ 0,0,0,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,=
0,173,222,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,1=
,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,0,1=
73,222,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,1,0,=
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,0,173,=
222,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,1,0,0,0=
,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,0,173,222=
,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,1,0,0,0,0,=
0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,0,173,222,0,=
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,1,0,0,0,0,0,0=
,0,0,0,0,0,0,2,1,0,0,0,0,128,0,1,0,0,0,0,173,222]
            }
        },{
            "RQ": {
                "index": 1517,
                "data": [ 0,0,0,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,=
0,173,222,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,1=
,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,0,1=
73,222,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,1,0,=
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,0,173,=
222,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,1,0,0,0=
,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,0,173,222=
,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,1,0,0,0,0,=
0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,0,1,0,0,0,0,173,222,34,1,0,0,0,0,173,222,0,=
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,1,0,0,0,0,0,0=
,0,0,0,0,0,0,2,1,0,0,0,0,128,0,1,0,0,0,0,173]
            }
        } ]
}

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/en/reporter_rx.c       | 183 ++++++++++++++++++
 1 file changed, 183 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index cfa6941fca6b..9599fdd620a8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -330,6 +330,185 @@ static int mlx5e_rx_reporter_diagnose(struct devlink_=
health_reporter *reporter,
 	return err;
 }
=20
+static int mlx5e_rx_reporter_dump_icosq(struct mlx5e_priv *priv, struct de=
vlink_fmsg *fmsg,
+					void *ctx)
+{
+	struct mlx5e_txqsq *icosq =3D ctx;
+	struct mlx5_rsc_key key =3D {};
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
+	err =3D mlx5e_reporter_named_obj_nest_start(fmsg, "ICOSQ");
+	if (err)
+		return err;
+
+	err =3D mlx5e_reporter_named_obj_nest_start(fmsg, "QPC");
+	if (err)
+		return err;
+
+	key.rsc =3D MLX5_SGMT_TYPE_FULL_QPC;
+	key.index1 =3D icosq->sqn;
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
+
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
+static int mlx5e_rx_reporter_dump_rq(struct mlx5e_priv *priv, struct devli=
nk_fmsg *fmsg,
+				     void *ctx)
+{
+	struct mlx5_rsc_key key =3D {};
+	struct mlx5e_rq *rq =3D ctx;
+	int err;
+
+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
+		return 0;
+
+	err =3D mlx5e_reporter_named_obj_nest_start(fmsg, "RX Slice");
+	if (err)
+		return err;
+
+	key.size =3D PAGE_SIZE;
+	key.rsc =3D MLX5_SGMT_TYPE_RX_SLICE_ALL;
+	err =3D mlx5e_health_rsc_fmsg_dump(priv, &key, fmsg);
+	if (err)
+		return err;
+
+	err =3D mlx5e_reporter_named_obj_nest_end(fmsg);
+	if (err)
+		return err;
+
+	err =3D mlx5e_reporter_named_obj_nest_start(fmsg, "RQ");
+	if (err)
+		return err;
+
+	err =3D mlx5e_reporter_named_obj_nest_start(fmsg, "QPC");
+	if (err)
+		return err;
+
+	key.rsc =3D MLX5_SGMT_TYPE_FULL_QPC;
+	key.index1 =3D rq->rqn;
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
+	err =3D mlx5e_reporter_named_obj_nest_start(fmsg, "receive_buff");
+	if (err)
+		return err;
+
+	key.rsc =3D MLX5_SGMT_TYPE_RCV_BUFF;
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
+static int mlx5e_rx_reporter_dump_all_rqs(struct mlx5e_priv *priv,
+					  struct devlink_fmsg *fmsg)
+{
+	struct mlx5_rsc_key key =3D {};
+	int i, err;
+
+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
+		return 0;
+
+	err =3D mlx5e_reporter_named_obj_nest_start(fmsg, "RX Slice");
+	if (err)
+		return err;
+
+	key.size =3D PAGE_SIZE;
+	key.rsc =3D MLX5_SGMT_TYPE_RX_SLICE_ALL;
+	err =3D mlx5e_health_rsc_fmsg_dump(priv, &key, fmsg);
+	if (err)
+		return err;
+
+	err =3D mlx5e_reporter_named_obj_nest_end(fmsg);
+	if (err)
+		return err;
+
+	err =3D devlink_fmsg_arr_pair_nest_start(fmsg, "RQs");
+	if (err)
+		return err;
+
+	for (i =3D 0; i < priv->channels.num; i++) {
+		struct mlx5e_rq *rq =3D &priv->channels.c[i]->rq;
+
+		err =3D mlx5e_health_queue_dump(priv, fmsg, rq->rqn, "RQ");
+		if (err)
+			return err;
+	}
+
+	return devlink_fmsg_arr_pair_nest_end(fmsg);
+}
+
+static int mlx5e_rx_reporter_dump_from_ctx(struct mlx5e_priv *priv,
+					   struct mlx5e_err_ctx *err_ctx,
+					   struct devlink_fmsg *fmsg)
+{
+	return err_ctx->dump(priv, fmsg, err_ctx->ctx);
+}
+
+static int mlx5e_rx_reporter_dump(struct devlink_health_reporter *reporter=
,
+				  struct devlink_fmsg *fmsg, void *context,
+				  struct netlink_ext_ack *extack)
+{
+	struct mlx5e_priv *priv =3D devlink_health_reporter_priv(reporter);
+	struct mlx5e_err_ctx *err_ctx =3D context;
+
+	return err_ctx ? mlx5e_rx_reporter_dump_from_ctx(priv, err_ctx, fmsg) :
+			 mlx5e_rx_reporter_dump_all_rqs(priv, fmsg);
+}
+
 void mlx5e_reporter_rx_timeout(struct mlx5e_rq *rq)
 {
 	struct mlx5e_icosq *icosq =3D &rq->channel->icosq;
@@ -339,6 +518,7 @@ void mlx5e_reporter_rx_timeout(struct mlx5e_rq *rq)
=20
 	err_ctx.ctx =3D rq;
 	err_ctx.recover =3D mlx5e_rx_reporter_timeout_recover;
+	err_ctx.dump =3D mlx5e_rx_reporter_dump_rq;
 	sprintf(err_str, "RX timeout on channel: %d, ICOSQ: 0x%x RQ: 0x%x, CQ: 0x=
%x\n",
 		icosq->channel->ix, icosq->sqn, rq->rqn, rq->cq.mcq.cqn);
=20
@@ -353,6 +533,7 @@ void mlx5e_reporter_rq_cqe_err(struct mlx5e_rq *rq)
=20
 	err_ctx.ctx =3D rq;
 	err_ctx.recover =3D mlx5e_rx_reporter_err_rq_cqe_recover;
+	err_ctx.dump =3D mlx5e_rx_reporter_dump_rq;
 	sprintf(err_str, "ERR CQE on RQ: 0x%x", rq->rqn);
=20
 	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
@@ -366,6 +547,7 @@ void mlx5e_reporter_icosq_cqe_err(struct mlx5e_icosq *i=
cosq)
=20
 	err_ctx.ctx =3D icosq;
 	err_ctx.recover =3D mlx5e_rx_reporter_err_icosq_cqe_recover;
+	err_ctx.dump =3D mlx5e_rx_reporter_dump_icosq;
 	sprintf(err_str, "ERR CQE on ICOSQ: 0x%x", icosq->sqn);
=20
 	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
@@ -375,6 +557,7 @@ static const struct devlink_health_reporter_ops mlx5_rx=
_reporter_ops =3D {
 	.name =3D "rx",
 	.recover =3D mlx5e_rx_reporter_recover,
 	.diagnose =3D mlx5e_rx_reporter_diagnose,
+	.dump =3D mlx5e_rx_reporter_dump,
 };
=20
 #define MLX5E_REPORTER_RX_GRACEFUL_PERIOD 500
--=20
2.24.1

