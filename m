Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAA75148F44
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 21:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404334AbgAXUVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 15:21:16 -0500
Received: from mail-eopbgr40044.outbound.protection.outlook.com ([40.107.4.44]:63396
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387421AbgAXUVN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 15:21:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QqmOk3JOKz7pGrWoDElbFkgxZ2l2fGRBAi8hYQiIfYEe3tNhKdALod2yNsgDXLWoIKkMB+HhhJoAGqT7QMKewZ+uYpUfvyi8UdfXgqkMZ5LtU6IhFTNdyFB6s5dtHMJYS2+i/cAETvlYjN24vGqCbMotmiZvQdyFXL+QbhRo7ByG6mHSRik/EiFHF+3b/I2YHf1VBR0+uH5WpvpoXAeAQzTWOx2wB3iviU9e63qd6nO4F42xbDVdD8u9RQitnYSpxAf4+UTAJ4wQEAxaXUEa0H8vkcKqUfcCA6R77lBrnaAJ/IWDvquldCtGBNxIDGkaFZnZ9ghB4l5uIVs3TVXoew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VDN2FCD+UvJ6LXZkBfDmORKL5dQt2obyLFH8H32iVDM=;
 b=IouDru6kLjNLvAZW4OnxUwCY6Mf1plgn6zXapzW4JdYbOC+faGFXoUAbzPULoPFSGNMYz4YDzN0QtngDhw9bXYnoqCUGjLWQrBBEfqyRPJbM7pk+7BhI3MElqKA9v+NDuUMLqKNoCYU1YxnrRAkvhGpdP7DwjXvZcI/I7XfRMhp3edXQHSA1dljlOBDVC3t3MVge3jd7TSiw/pGwIMSkhz1HoxfWu0zUIP9l0pPwwT4SAvQU6V+Zs9ZPYeOWjxxdNOFUS1F9sjMh+mp5AmQFj3bEAIH6nV6ClgksBIBR8c5TGf1LSkJRx/yl8gI9P5wtGnMsEssGI2YrxbDbuu0Nqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VDN2FCD+UvJ6LXZkBfDmORKL5dQt2obyLFH8H32iVDM=;
 b=IT6KeA8mQ2ikoVQQHAiawtTsJc5z1NWMJ+by1LAyZkXADuzmIJsbfkUgoVkcKjNGZUgp2AzrmxH9+TFhuv7DyYl5k66DZaRpHm9TEvQ8w58BxQn5JwVo03ax7XBwkZ3iGo3GUuSsFapWGaxor1nHtgeu1BHyXs0FbARD05sod8M=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5552.eurprd05.prod.outlook.com (20.177.202.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.20; Fri, 24 Jan 2020 20:21:04 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Fri, 24 Jan 2020
 20:21:04 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR01CA0071.prod.exchangelabs.com (2603:10b6:a03:94::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.21 via Frontend Transport; Fri, 24 Jan 2020 20:21:02 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 8/9] net/mlx5e: kTLS, Remove redundant posts in TX resync flow
Thread-Topic: [net 8/9] net/mlx5e: kTLS, Remove redundant posts in TX resync
 flow
Thread-Index: AQHV0vPNmiMlyMQhdkaBHYLs0ya35w==
Date:   Fri, 24 Jan 2020 20:21:03 +0000
Message-ID: <20200124202033.13421-9-saeedm@mellanox.com>
References: <20200124202033.13421-1-saeedm@mellanox.com>
In-Reply-To: <20200124202033.13421-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0071.prod.exchangelabs.com (2603:10b6:a03:94::48)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: def5b318-acc7-4c92-1a95-08d7a10aef7e
x-ms-traffictypediagnostic: VI1PR05MB5552:|VI1PR05MB5552:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5552C04764EB9A35C6FEFB11BE0E0@VI1PR05MB5552.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(396003)(39850400004)(199004)(189003)(64756008)(66446008)(66946007)(4326008)(66476007)(107886003)(66556008)(316002)(1076003)(6512007)(6916009)(71200400001)(54906003)(16526019)(186003)(52116002)(26005)(6486002)(6506007)(956004)(2616005)(2906002)(478600001)(5660300002)(86362001)(36756003)(81156014)(81166006)(8936002)(8676002)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5552;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H94nURYD0QWDu5QAVSsIk3PogOUHNQQnH8mYUmbjnI6orY5+e1/aTF4iAwvjnyYLXN+dd4uMxwAvzKCpoulP2zalxVmw7okZRIzyHOovPL1SQlTrEMGsNnUn+BOVgczh6UBWE8gtbUMGaFq8lsv2U728MvQ5HV7MgI5uA+APCRuhNOCf5GhEQ4PAWQRWiBj7JgSP79TUkFyLNX88Bq7grBbxrxALwaMWKtZmUP1vmzrlOOr1OhFyQo02Rk5ptsZI7Tjf0rSru+5IYkUTjCsp1m2yJ784j7Gs1arSdBkY3YR5vdhWVfqO1yLpehXTy1y060Vfa5rIWEcNlhHHgRneo6SqH+iV6J3kRPY5VOJg6B9z8dyBA8gcaOL3oNY/AjXiENgLu5DneYygrL6ectSs6obfrukwbPJK62b8YZnfh1rKS4YweysDNDlZMke8Tp08z15FSsh87hCiS98daVk9MWL3iyLPdZruNX8a8aKgzuN5tQ0cnmN52JIYgWSx2GN4gyLQt28v4wNV3vntKwUDl2VZFzHGceom24i8Pux/h30=
x-ms-exchange-antispam-messagedata: qkBK/Tam/4tDcQuXv9bEPcQYpSa0tNTTfX+2WBjqK9Zh+sUGwSoXxA7uwBF4ojExkEk+vFjJC2KsUeBKCkom9lB9uHLvltIZxcqtgcryIB680FeRVD279KFlv5lm62gYtb7xL7ALSeEM6Q6ripEtIg==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: def5b318-acc7-4c92-1a95-08d7a10aef7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 20:21:04.0005
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 304VvGSZRPCDvUF56moD1rGOIDRyJGHlTSDM5EBd6ItUlKrpue/IaEgyScxSceBfxUFa06jCODudvw4+oXrFVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5552
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

The call to tx_post_resync_params() is done earlier in the flow,
the post of the control WQEs is unnecessarily repeated. Remove it.

Fixes: 700ec4974240 ("net/mlx5e: kTLS, Fix missing SQ edge fill")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 8dbb92176bd7..592e921aa167 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -383,8 +383,6 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_cont=
ext_tx *priv_tx,
 	if (unlikely(contig_wqebbs_room < num_wqebbs))
 		mlx5e_fill_sq_frag_edge(sq, wq, pi, contig_wqebbs_room);
=20
-	tx_post_resync_params(sq, priv_tx, info.rcd_sn);
-
 	for (; i < info.nr_frags; i++) {
 		unsigned int orig_fsz, frag_offset =3D 0, n =3D 0;
 		skb_frag_t *f =3D &info.frags[i];
--=20
2.24.1

