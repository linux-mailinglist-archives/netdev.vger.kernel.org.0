Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F66014936F
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 06:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgAYFLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 00:11:38 -0500
Received: from mail-db8eur05on2084.outbound.protection.outlook.com ([40.107.20.84]:50912
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726338AbgAYFLh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 00:11:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LwULQMzp+0cKU+Vd/qnf0CxR0j3im6wnnrHXAhpBvXgYt+1RAZi4anp5SY2ojDUYenw/VXGo0sBjM2Og5tzQo29OxPOBUzxDSsFZwsF+K2nOp1GjN0VvCxlEGiHZp/SFMMW4A90fB2ac+ujeDoDuCURRTgIivtlzxud823cY4NShf6q/i93/1s6tkP++G2j6AImwNLK7kro8tlqCZEfoDIpqMsFc/op2rVJg5H4FV/upyk/jS2yDZT+LaYJU5UZF/CoGno0YEx9T2l5TbVk0hgvmXskRiqRp0m/35dED3mBF5ewJbYlEPwi+uU5r/GprzkTPoI13y5rnsUMnUy2trg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bxE7iF7C3IfQGdb9HviTHfIjVaTbe02XyCgjrh774dE=;
 b=L5kth0f/tmuE+Q8K0fqNkQTNUkSzlKJjfu/vTKKNWAjIxPPkHGRC2slwLAIM+JIPaW+HZKR3DYgEH7bhkInPBWvzopWCwGHIZPu6d+v338gZJ4Zkwg7JCNzX6TfTfyhQeB2cqXFY0PGopwFD1wlvST/8tpjHtAS9LCxhRi/3FbLAf/Ep4yyC5ZS9jLdE3gyRu1zBli7sayy02OoM2hDQKk2ZQeZOJQGOFpEuot2G8FMkw9hJJXpBemE57R2gpdCG8pJ9BepQR54BWfzOmg0uc3u7UXM2nHzA7UX3LvDrlVbIltNFrl0hlo2617vrfHzU2i0bomsE5Ps7EzIGOXMqTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bxE7iF7C3IfQGdb9HviTHfIjVaTbe02XyCgjrh774dE=;
 b=hSFsYlug6JAcOSuY3vG1g+GnxjkyiSgzifl0wquPpLQSPCn9jaYQ4i3iVcLwJ9SYyHWGtX/YjaylG1wpe9nSF5QLgwrsPtMmsxcTVP1SUQUlP3OlmsrXfmBt3S7+ETgfPSkdeGZJ+5kxdlQxsEL/1tvyosavKzvySNoiYrRvvg0=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1SPR01MB0394.eurprd05.prod.outlook.com (10.186.159.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Sat, 25 Jan 2020 05:11:19 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Sat, 25 Jan 2020
 05:11:18 +0000
Received: from smtp.office365.com (73.15.39.150) by BY5PR16CA0025.namprd16.prod.outlook.com (2603:10b6:a03:1a0::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend Transport; Sat, 25 Jan 2020 05:11:16 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 05/14] net/mlx5e: Support dump callback in RX reporter
Thread-Topic: [net-next V2 05/14] net/mlx5e: Support dump callback in RX
 reporter
Thread-Index: AQHV0z3gWwTL0dA1A0OwQnV9RCUgEg==
Date:   Sat, 25 Jan 2020 05:11:18 +0000
Message-ID: <20200125051039.59165-6-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: b9460a9e-ab44-4a65-7047-08d7a1550272
x-ms-traffictypediagnostic: VI1SPR01MB0394:|VI1SPR01MB0394:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1SPR01MB0394155063DE17E30FED6D97BE090@VI1SPR01MB0394.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0293D40691
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(199004)(189003)(1076003)(30864003)(71200400001)(8936002)(316002)(16526019)(6916009)(186003)(2616005)(956004)(478600001)(54906003)(5660300002)(6486002)(4326008)(107886003)(86362001)(52116002)(2906002)(36756003)(66946007)(66476007)(81166006)(66446008)(64756008)(8676002)(26005)(81156014)(6506007)(66556008)(6512007)(54420400002)(505234006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB0394;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xdkxE18ERyjpfDmvBVwcxKcV0UFPVCKZhBgZULNzTPj2JIuBEzy23k/GPg0gOcT2j0VBml3C7PPzxb/INBrnq+NSMWikN7IZT3TDvKGnAVBVfZ2v7p5OOg1vD6L+14Zer1/ozY+kwC3TntkBqX9YR7JaaPdyc+JGq5q/CBsIFJmts+qJykhEQXUYMopHxTGN4SIu4EOdaOvDzfNRgWmu9hSZq8b17goUI+vV4Mj6Nq0MrSB6xrQ19HClvlrxIPPCEW42PuUDShz9QoW4B9eACAlOKE2H2gzENSjV9RmLDTlqpDECMz8uw2jUsLn/PB9hC4peadKttHyR+nnhRCDBRBHcF+RgLcgILMpW8mc/YtosdPQGNXNrcuYM511xU3r//IXFC6If5HVbb2dorOIPCUPbz/fqX8AZZaDnz9U6ePnguW3s6Isl3qoXqYBpFvzbY4qhuERLKhLUcVrhnspGS2CklM8ygK9gTd90850yjj1DAw4l0xswzzpEYs73ZszZU5CvmP4PX2lbSgrfqyoRASsfgwO3U9sYlRCryewXwGzyQ93lqFiSpMGwW71Kno14
x-ms-exchange-antispam-messagedata: JdueY39tbutY4N/yG4EnwfgAzTaMSlEmwDT+R+e4hINSOVwlaF1CdSp1OHhUpci5D0bWRNi5f96wsci1lAzB2To1VaRAPkDr1fglK47tT4UVorbEY2LR68g237dGe6oKpdsRqtLLIEfjXZrlacCw8Q==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9460a9e-ab44-4a65-7047-08d7a1550272
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2020 05:11:18.8576
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ye++iHbVd3mKBkN/SxrMF1pGiHgZ1x+21xhynjxP0APMuO6w5YBKFBrF71u7z2M9pe9Ms5l2YB97c08oKPxpzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0394
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

