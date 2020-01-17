Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7168F14008F
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 01:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729337AbgAQAHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 19:07:35 -0500
Received: from mail-eopbgr70079.outbound.protection.outlook.com ([40.107.7.79]:19560
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388414AbgAQAHb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 19:07:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ihf9yu+gdDS3NHAh+3CX/kaMOzjK9QR+apQTQPmioUM4fMjvAU32NBMvQ0EOTWWJ5e+TwGYKTTZaux8K6wZjGrWokHlj6Vfn8FhNDFfqRj7SCqgQ6ZFSZMEfqtmfw1+d4PCZ09ZZdUEl/LYybFbWdb3wGEncCkXR/V29uwj4FbTzRb3rjWK9xHjFsOt2NpHLAHux9nAtu0bc0C32isQLfumUp4ZNZPlmWrr5s1iiXvk31MQ1kpp3RIvB7uU+2QTnYip4bcwq0TZLIgPxnZ2x69wWVwEqU6XIGPCq+k43motfTeSxd8J23q5W5F6VVNfZOEv6Fgx+m+QBB2yBVBpUmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vX7MTfdxH03HltA66HsZlDs9H3pCd2odDigUXoSUlEo=;
 b=nXu7kGzFlE2tCdonbPaRLPxXEPzwoCbzzLRuZ4AswoN2myhslKDX1fomXrmH9SYOD4cak8eCCUX4tkfRe1vIaYTKNx83GM29ejdfO6g0mB95gjqD7rppzb3jSxrLLhvChlfmEBkJCGEdOmtnhoOuBzJj+iVNnaRKrNRXEZSE4JnevTMCHNPqJvfS8EfJmOsjPEHu9uYsnJ/9NoWaY+NRSdIrAYXDtglGeKtwCmQ68AWZDq4YXIsKTTkfwezglFbjB37katcKrnTAvMWNdUFhN5KFpklRFfq1k9fZbqG+o715yCAjATpHdu0gyxHdrCM7+4dsoXmJ86JgJx0dpnQ4KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vX7MTfdxH03HltA66HsZlDs9H3pCd2odDigUXoSUlEo=;
 b=YUxkRZVSdFR+MY+E2eivuWDapOX3s4ETrEyamMaETlSHyMm5ve5ks5fvAyq7jmC8MFXFEYR1t9tsYgC3pDJL1J6MrNQe5fGFcs27s8fminOdBTNJSpk3ILwSKjgmnqqimPTB3DW5xnh8gwSoBJ++LGExbrgpFKurfbJOWNgqSiE=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4990.eurprd05.prod.outlook.com (20.177.49.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Fri, 17 Jan 2020 00:07:23 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.015; Fri, 17 Jan 2020
 00:07:23 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR03CA0003.namprd03.prod.outlook.com (2603:10b6:a02:a8::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Fri, 17 Jan 2020 00:07:21 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 14/16] net/mlx5: ft: Check prio and chain sanity for ft
 offload
Thread-Topic: [net-next 14/16] net/mlx5: ft: Check prio and chain sanity for
 ft offload
Thread-Index: AQHVzMoXVLdZWosjF0KoSgrPDOOrww==
Date:   Fri, 17 Jan 2020 00:07:23 +0000
Message-ID: <20200117000619.696775-15-saeedm@mellanox.com>
References: <20200117000619.696775-1-saeedm@mellanox.com>
In-Reply-To: <20200117000619.696775-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::16) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 486248c7-390b-4ff2-3fbf-08d79ae13a16
x-ms-traffictypediagnostic: VI1PR05MB4990:|VI1PR05MB4990:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4990A5149C553AD7C398A0A2BE310@VI1PR05MB4990.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0285201563
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(366004)(39860400002)(136003)(346002)(189003)(199004)(64756008)(6512007)(52116002)(66476007)(26005)(81166006)(86362001)(16526019)(316002)(81156014)(8676002)(2616005)(66556008)(186003)(6486002)(956004)(71200400001)(36756003)(508600001)(66446008)(54906003)(1076003)(5660300002)(2906002)(6506007)(4326008)(110136005)(8936002)(66946007)(107886003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4990;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UR4S8plgbF4J2npb85Lehpbzc5zxJJ7+/8R9ZgoHXYmjiCOONjuIj34CEQo08+16Tz7S2De9CFTJJ2S+pgA3jvjICDdUFLR/W0cmZ0iAQ3EtJMAK2Qy2v/oinwRLc84K4dd1+6Mrn0L5VQoAsBRF4nEPXzNKErSEG/vtzuWEZcE/+9UYBYKYF6UJW3doJe9BI5d+SfAAdC0OMQOCJeY6q6CRmpsyIzKgw0r3bv4P0DKCrDADsoOdqxTzCVrsb8bvkY2lKvLTbqEbd+h0S0zHD6BWZumx5X3VYBo+zt88/zIapJJTim4eIXol4h5LB1pWU3yqlq47qruD8EZlAWTuc0yzJcPxWSbsFl7t6fl/s/FzNIN2QT7c09XXucNGihJDG1u5S+F40W9I2+6tENwmrNM0VzowawsCr/WRKUAtYfaNUcxXYnkl+EWNYTMGW/89Jyg0UbveK1uYjgBFbo7HjWtOEta6Lw2MR+1MRg28OtsaOOFFj66t5dL4IjPMe076tW7VvYvGNHMXJPwF52nSZYrUrrMjD+24PgD7xUM64Ps=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 486248c7-390b-4ff2-3fbf-08d79ae13a16
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2020 00:07:23.4487
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0YhYcHwXgEDS5/M5skRzdZKZLY80GSY2uEPRoh6tCh98rmQvEJp4RkOUYHigojUW+rUSirFm4s6YwtbHriGzcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4990
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Before changing the chain from original chain to ft offload chain,
make sure user doesn't actually use chains.

While here, normalize the prio range to that which we support.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 27 ++++++++++++++-----
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.c
index d85b56452ee1..5d93c506ae8b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1247,8 +1247,7 @@ static int mlx5e_rep_setup_tc_cb(enum tc_setup_type t=
ype, void *type_data,
 static int mlx5e_rep_setup_ft_cb(enum tc_setup_type type, void *type_data,
 				 void *cb_priv)
 {
-	struct flow_cls_offload *f =3D type_data;
-	struct flow_cls_offload cls_flower;
+	struct flow_cls_offload tmp, *f =3D type_data;
 	struct mlx5e_priv *priv =3D cb_priv;
 	struct mlx5_eswitch *esw;
 	unsigned long flags;
@@ -1261,16 +1260,30 @@ static int mlx5e_rep_setup_ft_cb(enum tc_setup_type=
 type, void *type_data,
=20
 	switch (type) {
 	case TC_SETUP_CLSFLOWER:
-		if (!mlx5_eswitch_prios_supported(esw) || f->common.chain_index)
+		memcpy(&tmp, f, sizeof(*f));
+
+		if (!mlx5_eswitch_prios_supported(esw) ||
+		    tmp.common.chain_index)
 			return -EOPNOTSUPP;
=20
 		/* Re-use tc offload path by moving the ft flow to the
 		 * reserved ft chain.
+		 *
+		 * FT offload can use prio range [0, INT_MAX], so we
+		 * normalize it to range [1, mlx5_eswitch_get_prio_range(esw)]
+		 * as with tc, where prio 0 isn't supported.
+		 *
+		 * We only support chain 0 of FT offload.
 		 */
-		memcpy(&cls_flower, f, sizeof(*f));
-		cls_flower.common.chain_index =3D mlx5_eswitch_get_ft_chain(esw);
-		err =3D mlx5e_rep_setup_tc_cls_flower(priv, &cls_flower, flags);
-		memcpy(&f->stats, &cls_flower.stats, sizeof(f->stats));
+		if (tmp.common.prio >=3D mlx5_eswitch_get_prio_range(esw))
+			return -EOPNOTSUPP;
+		if (tmp.common.chain_index !=3D 0)
+			return -EOPNOTSUPP;
+
+		tmp.common.chain_index =3D mlx5_eswitch_get_ft_chain(esw);
+		tmp.common.prio++;
+		err =3D mlx5e_rep_setup_tc_cls_flower(priv, &tmp, flags);
+		memcpy(&f->stats, &tmp.stats, sizeof(f->stats));
 		return err;
 	default:
 		return -EOPNOTSUPP;
--=20
2.24.1

