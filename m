Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E59B149081
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 22:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729014AbgAXVzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 16:55:20 -0500
Received: from mail-eopbgr40047.outbound.protection.outlook.com ([40.107.4.47]:56737
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726612AbgAXVzT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 16:55:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gbhjpGrakDLkBYVVUudyJXZebvmINJQdDqbHzBndIGsw/Db6IS3irGiCTxw2UD88yzbCTB2WyWDYoj0xNN13zOMvCliBfsw3PGUEfxhxvILX8caBqHe+QfL67OSD+BdyfdIXgksJ8ziF6ZHhxN7m5vPe9CB8YjyQ17LGOg51jkHIm1bUsmjpigrvp2m9Db4xGfjOUWkFRVnjg54hHzEAaJNywPbAFN5srKbO5E53ADvqpoaBp4XA7gE1eHweRUAj2AdIfmOHiBDeOYusBvKnk2byIXdf50vOs12AU1NhUM0rXqLrWV1xVZLGhtF4T+wwDO2plWj5uqgXM3rIfGUWmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bxE7iF7C3IfQGdb9HviTHfIjVaTbe02XyCgjrh774dE=;
 b=MJtNfcyyY3ji5jAkE6EPjD4Qff7za2d2s+Jg84/hZv36hCAFFn9JtZmKGutdC6SdOjxRZovw2idxug2R6dfaWLNsLZvDe5+cd4X4QJHsTSfBNbt5tHjwuQyTNvOtnWyvXqOldh8vs3emyggWg2fwmDjcU6eEtUrcW9bVR7Wg9xTvRezqJ+vrjhhyy7vZxT2hYBYeVHLOqXUS1laPHqk/ZyWhqvTYHy4lK2+NbpHlRvomnPcZ0JVUw3R6DhKE1IK8V2bYA9j6l6jsbmOGJKYGqRU8NjmiNbdMTZAsW2asgcUeGZ82b2nCfmIVd/M6KWpyixq91V+c0LMjIdXYU2E3pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bxE7iF7C3IfQGdb9HviTHfIjVaTbe02XyCgjrh774dE=;
 b=rdo4CSclmmxLlQwEibyJZ7zMmqpQJ0Bq9QFG/5TTzM8wNWS1LXXqXp68wcjYrUjHBN0qd0ZVV5tEXkRxULGp+ff9kL834ODYF9flVIlkBhov5OMm9UXChUZ5VthP2p0D5YD6b395IncgNA6urZlAEKU7x+zbd8D/NVX9u+UsjF4=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5456.eurprd05.prod.outlook.com (20.177.201.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Fri, 24 Jan 2020 21:55:07 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Fri, 24 Jan 2020
 21:55:07 +0000
Received: from smtp.office365.com (209.116.155.178) by BY5PR17CA0038.namprd17.prod.outlook.com (2603:10b6:a03:167::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.21 via Frontend Transport; Fri, 24 Jan 2020 21:55:03 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 05/14] net/mlx5e: Support dump callback in RX reporter
Thread-Topic: [net-next 05/14] net/mlx5e: Support dump callback in RX reporter
Thread-Index: AQHV0wDvXRfuqDUeh0CYI7L4bErl9A==
Date:   Fri, 24 Jan 2020 21:55:05 +0000
Message-ID: <20200124215431.47151-6-saeedm@mellanox.com>
References: <20200124215431.47151-1-saeedm@mellanox.com>
In-Reply-To: <20200124215431.47151-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR17CA0038.namprd17.prod.outlook.com
 (2603:10b6:a03:167::15) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: aed94169-95b9-4e29-33c1-08d7a118121e
x-ms-traffictypediagnostic: VI1PR05MB5456:|VI1PR05MB5456:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB54561123FA87B3DC9A359E48BE0E0@VI1PR05MB5456.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(199004)(189003)(956004)(4326008)(107886003)(5660300002)(316002)(54906003)(478600001)(8936002)(2616005)(6916009)(26005)(52116002)(6506007)(36756003)(8676002)(81166006)(81156014)(86362001)(16526019)(186003)(1076003)(66946007)(66476007)(66556008)(64756008)(66446008)(30864003)(2906002)(6486002)(71200400001)(6512007)(54420400002)(505234006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5456;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: piFVl3oNB59EiB3dUB6GNd+LFWVuHxCA4TJB0SKS8vbdXuDmVRiDJUWtY9oRXMUupCAReBA31VfQonRtriPN43HW8B9AyGTLp0nqYXqumJ3m4aX+HcIVbV0qKu1Gl8ZhaCcBN7mgQRU/ZIIGurjGUSnLc98JdLb4LlUejKlLwNFXEF1Y/K1uZyQ9w13qkV2P81Fsfjk8piBDi5G3qXgu0Ez3gsXe04RXz/wJAk5tGjZ7k1expkNHknJ5eMI7qw1JPZSne2CLEDwUTygZKexEqZIZYC2AlvGQkB2QDOh1ArD3PxBIyt8Qc4Prgen9qxIal+uKDPE5/7HAPZZaBdxkftQV7eJKFKWG4+Tko2yRwrC0xX5SWimODXNTE5QYIyUQmjQUbd4arLxYcXA4mTeymvQvORebEIuhspjQ+LoGzczI/McGS0Hg+9N+q6AQfnoKK4h5qA0Yx/cUWAgaCO5lnxUwcXwioeCtB5FRLNKBvYfwUTOywM2pI8SIWa1B1e0fHvR5zVTtQDwPMYK/LdLebwM1PEdbkL8RReIoOcleynBNZrL8bBUqdNp3/k9oDV9f
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aed94169-95b9-4e29-33c1-08d7a118121e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 21:55:05.5398
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8BOdkulzCUgBcKpmVfMmSG8kzStvnEGpyLki/VmFQfND9BIelBnep9aGEE1cDZSwuZ8hOKiVP5Hig7/DmlN36g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5456
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

