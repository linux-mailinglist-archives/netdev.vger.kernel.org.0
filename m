Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F35D1079F1
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 22:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfKVV1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 16:27:00 -0500
Received: from mail-eopbgr50063.outbound.protection.outlook.com ([40.107.5.63]:59697
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726620AbfKVV07 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 16:26:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GfTFEzYOuACAAF1NGEReLAms6XXJ2GG4cOFyKbXgVcxfMhw/IQ1xDcEm3n3GKYp1agHIGcARpGAwDjck05U/RDFz29gbMTDMUv9AYg6Sfns20T0fO9Jkuy9tAhriC3R9UC2ANKiS/nxUebTo43yZw7dmVt21rjr9cYnLSIoGdjPu0rntqntGnTP6xCQ3nlTUTAsxPpUvlMkpNE60Z/KfGVSKx/88fnLaKI5WxZwEP8fJe4/5ZY/4YTO0KJLQ/7mcNbfUQCZ5pvQg6sigzH85g/QO9kYKiWvxvYOG91YTPW+QCNBanKQMpemIbNeIlek5zSp/IenbEVtLSZ6lPi2Q9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kwlQLRh+9UPt9Xk1IzxbB59CaNSLhmlTqrMQY3ULjrs=;
 b=jD/0l7C2JKR6GIONgD1yZtDGOcZidaF9A+SiO44P34O9odCA5tclbZfe04GfwAXogtCRnB4CHQ2ktFQjct8nF5hbbySreueaveOlzm8NCsblGmaXWK+tIAjKhctvahumzoDEWk60XmLx4mqWoZ4djQevOTQhPR/8q71qTYDy3IkOH7LSLOduAuPvqWB9HSyAOcwSFFIwYANaOEFPLXG0d11BTczS1PeLEKlVHYY2leyeK3eZssb6pPq7NWdvfFaQHZzz8LShSfhDvNByEIujTkC6/FFstboGzbHMx63HxHZLhEp6jd/rgxRLGh8BumAvdRcCVo2QOdC9JUMozrkdRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kwlQLRh+9UPt9Xk1IzxbB59CaNSLhmlTqrMQY3ULjrs=;
 b=P2tlBkyR0YYS9ZBXa8i+w7RaO/ZepclrWbaLSbq8luIxLRwbHkbbhg4ZGiOc9qRQdqAd/EBu9b17Gg6ncFcf6F+TXv+lqd1H1WEWH3lFYWuz4v8HSiUwxLDDsFECo7Vokj2fbys0LB1bvVMQPAtW3jMo6WReOXQZAWRUK55PuVU=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4350.eurprd05.prod.outlook.com (52.134.31.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.21; Fri, 22 Nov 2019 21:26:51 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.019; Fri, 22 Nov 2019
 21:26:51 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 3/6] net/mlx5: DR, Add HW bits and definitions for Geneve
 flex parser
Thread-Topic: [net-next 3/6] net/mlx5: DR, Add HW bits and definitions for
 Geneve flex parser
Thread-Index: AQHVoXuOTURccay46k+gcjU0yy5iZA==
Date:   Fri, 22 Nov 2019 21:26:51 +0000
Message-ID: <20191122212541.17715-4-saeedm@mellanox.com>
References: <20191122212541.17715-1-saeedm@mellanox.com>
In-Reply-To: <20191122212541.17715-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::26) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2876cdeb-2a1e-4976-d1ca-08d76f92b0ac
x-ms-traffictypediagnostic: VI1PR05MB4350:|VI1PR05MB4350:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB43509130B1A1EA4CB5568844BE490@VI1PR05MB4350.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(136003)(346002)(376002)(39860400002)(189003)(199004)(256004)(6512007)(1076003)(76176011)(107886003)(66946007)(50226002)(6506007)(66476007)(86362001)(52116002)(66066001)(8676002)(6916009)(386003)(81166006)(25786009)(64756008)(8936002)(4326008)(99286004)(66556008)(66446008)(81156014)(6436002)(6486002)(5660300002)(36756003)(2906002)(54906003)(102836004)(316002)(7736002)(71200400001)(71190400001)(3846002)(6116002)(305945005)(186003)(26005)(478600001)(2616005)(14454004)(11346002)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4350;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P9zalsLFn7EedA0u442/CvLdCRZkkLkXJcluYVMmm3MieA/2wB8ZG8CRYVis+3DVW5c2FvXJIeRZ5T9WWCLKjlZJc2WldDYhdiPv4cpaLPAdzwoTjf37AGauoQQhDhu2k+w8E8np9F0CMJPor/lIWpdk5ySlSrURfO8AZPaGluxr6Y5MgUltTdExN4FuNDmsgDz93vzsjOjrZFcoi+NTAi5i+xlhKvTUiLiRJdg0EL+Ff/iiVwhoiRt11OmX8u+FtdIe0NWpTa7qM1Gzk8T/zTivFD3UFZM81+0kRP9AoHm6pt3YBVjmVNaOfkXwZXvIKtCsobYUpxIq3k/4VEWl4j27r1FRvCpVu2qj8FyWL+3cgbZCZSbLqQ4oSmUgHbpsXOXGCDAe9P5ozYyzWgJbgMmfQOThoNqmq5zgOEZ+4ktR/Yhs2qcDfEm+DhTjfxnh
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2876cdeb-2a1e-4976-d1ca-08d76f92b0ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 21:26:51.7308
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wEVi0MNLv6ilaSlHcBia8ej9rDRNqoN200COI0/iYd4uqSObBP/J9J5O/Ew0tKY07VBlCN1KdT74c/ViHZ3TEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4350
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@mellanox.com>

Add definition for flex parser tunneling header for Geneve.

Signed-off-by: Yevgeny Kliteynik <kliteyn@mellanox.com>
Reviewed-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/mlx5_ifc_dr.h       | 13 +++++++++++++
 include/linux/mlx5/mlx5_ifc.h                       |  1 +
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h=
 b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
index 6d78b027fe56..1722f4668269 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
@@ -559,6 +559,19 @@ struct mlx5_ifc_ste_flex_parser_tnl_vxlan_gpe_bits {
 	u8         reserved_at_40[0x40];
 };
=20
+struct mlx5_ifc_ste_flex_parser_tnl_geneve_bits {
+	u8         reserved_at_0[0x2];
+	u8         geneve_opt_len[0x6];
+	u8         geneve_oam[0x1];
+	u8         reserved_at_9[0x7];
+	u8         geneve_protocol_type[0x10];
+
+	u8         geneve_vni[0x18];
+	u8         reserved_at_38[0x8];
+
+	u8         reserved_at_40[0x40];
+};
+
 struct mlx5_ifc_ste_general_purpose_bits {
 	u8         general_purpose_lookup_field[0x20];
=20
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 4f912d4e67bc..5d54fccf87fc 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1110,6 +1110,7 @@ enum {
 };
=20
 enum {
+	MLX5_FLEX_PARSER_GENEVE_ENABLED		=3D 1 << 3,
 	MLX5_FLEX_PARSER_VXLAN_GPE_ENABLED	=3D 1 << 7,
 	MLX5_FLEX_PARSER_ICMP_V4_ENABLED	=3D 1 << 8,
 	MLX5_FLEX_PARSER_ICMP_V6_ENABLED	=3D 1 << 9,
--=20
2.21.0

