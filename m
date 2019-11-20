Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B56E710465D
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 23:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfKTWW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 17:22:29 -0500
Received: from mail-eopbgr10048.outbound.protection.outlook.com ([40.107.1.48]:31714
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726510AbfKTWW2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 17:22:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J+1mMlQ+6d2l/jYoV0tLRTWexJgQhZdCGxyrr3OPaHFxOz7sdmcfrxSHE0BlberEGdPGOibgHhdOUGBR94sArVUH/c8WgfYjp7sxj5Bee6v6rXWPZzkhDcZvCMejSBQyDqfKsfLmyFvazdnnBmq4iIVWYH1xO/vG8liQx3amBttE5DwcfF6riz8Uyu7RlRnsKW7G7obrFMAxph12R76FhNjJKvctYR6gSM8CmG5FDrTVL4Ctl+EdUv/OpFayzj0xuFS6OcvNRwM3Dybz53IwhJXlz/3bAYS4fsoMCIw1N6Gl01RDx3hfNXWKRwzV1j7uh//ckGvfnvJ19ECFSH/3gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zf8i3H5pptsM9h+KbkbyCzCTpTPVwjvHLU/9qVDerNE=;
 b=P9mr4E3MYDbouLkwArzq6DACfxHqKLDNCYH0xMgfkVIlzbcIttRk1ZxUuIvdO0IOqB6S9qEvNXKhHYr6ZTONmAm20bBVShvYoDvZ99TZZIkDqbwFFxH/arXQoZkq7oBpBSDDh8DVw01fSU8J2ZObmBuWuG5+oK3R9/5eEjL7DClzvJTscmGfiGpLoAFAJj9RiXWleELzgGVcvOdPvYg38t8oS+umeJzbju0HxtMfbeosLXyHXPf5jFpGdptT1JzpaCiAwWjeZwVD/cBjtkjZ81niHg83uJFIz3TKeWph4SS+gHQMBWnf15jRGjmzhGU+ZlDtQ0rcnOzwkp8vnLGtaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zf8i3H5pptsM9h+KbkbyCzCTpTPVwjvHLU/9qVDerNE=;
 b=AjllDKP9OLGOc6Kf++VxqHnVMsPTTEz9HPfpLIN9pLsRktrxM5G4NRdGzq/jKl9bqmxI0131ZfQzvx71Yk+1SnUnHNst8xBjp6Kvi9CzgQn98xEo9vG4qeGBp69bE+r45XrpOvF72vg970kFZPDecKGK1b+7LYeAPEWQQeDcD7Y=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5341.eurprd05.prod.outlook.com (20.178.8.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Wed, 20 Nov 2019 22:22:23 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.015; Wed, 20 Nov 2019
 22:22:23 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>
Subject: [PATCH mlx5-next 1/5] net/mlx5: Add structures layout for new MCAM
 access reg groups
Thread-Topic: [PATCH mlx5-next 1/5] net/mlx5: Add structures layout for new
 MCAM access reg groups
Thread-Index: AQHVn/D7IM6mURFJ0EmIIOfcx+NM5A==
Date:   Wed, 20 Nov 2019 22:22:22 +0000
Message-ID: <20191120222128.29646-2-saeedm@mellanox.com>
References: <20191120222128.29646-1-saeedm@mellanox.com>
In-Reply-To: <20191120222128.29646-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 44a8635e-bb92-4ac7-709c-08d76e081d66
x-ms-traffictypediagnostic: VI1PR05MB5341:|VI1PR05MB5341:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB534157C088109270DFEEDBA7BE4F0@VI1PR05MB5341.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(366004)(396003)(39860400002)(376002)(199004)(189003)(476003)(102836004)(316002)(99286004)(66476007)(76176011)(8936002)(14454004)(386003)(2906002)(6506007)(52116002)(110136005)(6436002)(446003)(6486002)(66556008)(54906003)(2616005)(66446008)(478600001)(64756008)(66066001)(66946007)(6636002)(5660300002)(11346002)(486006)(50226002)(81166006)(71190400001)(71200400001)(7736002)(186003)(305945005)(81156014)(36756003)(25786009)(8676002)(4326008)(6512007)(450100002)(14444005)(256004)(86362001)(6116002)(3846002)(1076003)(107886003)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5341;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HEUW1a95xRdeeuWRTofXSC6/RUafyIo7CDd8l7odaoU8sCBlb/80bT/0zmf3BxacCZtOc2WZZfFLzbSLI9nf4BFrAFOpWulvGau43dYUi446Zq4cS+z6cLO9avKTVmrE7ExDHiT9B3FKp8torHHrcXqFpXEnwZAf4FW3uLtqSKuzUuZfWrgih2/jpYf7L7aO9LDg2Zd2wkzNUveRw/FQMYB1IWBehbQcVL/zLudxQvjlGV+VVafHDbxTOG4GsDZ9HHYHLWE9ei8VjpfG2UuoAYKNOb2DLk+WqTegQTBRw/P2EulhJ0LKs5JBgQU20ipGZg72TB8vX3W8j7PRg9gBhlrGjttjuZ3YfzVywBN3CUVcr1TYco4QV322LqeNRQfEqLikJWcK0do/geOeeuw4WVomQv6ObBJpz2UuIpWzpBziH27STl8mpkLyMBMNW95R
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44a8635e-bb92-4ac7-709c-08d76e081d66
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 22:22:22.9960
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S/42KwmV+A8nCAtbunDg0xj9yqRFE3TIihv7Ktuzqy0haCLxUdxtQ65vY0ZxpiPIXXG5N1nwV541V6YUb++2VA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5341
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

MCAM has 3 access_reg_groups (0-2). Defines data structures in order to
read and parse access_reg_groups #1 and #2.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index c0bfb1d90dd2..97acbe8cebf8 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -8817,6 +8817,28 @@ struct mlx5_ifc_mcam_access_reg_bits {
 	u8         regs_31_to_0[0x20];
 };
=20
+struct mlx5_ifc_mcam_access_reg_bits1 {
+	u8         regs_127_to_96[0x20];
+
+	u8         regs_95_to_64[0x20];
+
+	u8         regs_63_to_32[0x20];
+
+	u8         regs_31_to_0[0x20];
+};
+
+struct mlx5_ifc_mcam_access_reg_bits2 {
+	u8         regs_127_to_99[0x1d];
+	u8         mirc[0x1];
+	u8         regs_97_to_96[0x2];
+
+	u8         regs_95_to_64[0x20];
+
+	u8         regs_63_to_32[0x20];
+
+	u8         regs_31_to_0[0x20];
+};
+
 struct mlx5_ifc_mcam_reg_bits {
 	u8         reserved_at_0[0x8];
 	u8         feature_group[0x8];
@@ -8827,6 +8849,8 @@ struct mlx5_ifc_mcam_reg_bits {
=20
 	union {
 		struct mlx5_ifc_mcam_access_reg_bits access_regs;
+		struct mlx5_ifc_mcam_access_reg_bits1 access_regs1;
+		struct mlx5_ifc_mcam_access_reg_bits2 access_regs2;
 		u8         reserved_at_0[0x80];
 	} mng_access_reg_cap_mask;
=20
--=20
2.21.0

