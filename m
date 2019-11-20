Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 055F5104662
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 23:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfKTWWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 17:22:34 -0500
Received: from mail-eopbgr10048.outbound.protection.outlook.com ([40.107.1.48]:31714
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725878AbfKTWWe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 17:22:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kPLXJ6CgyX922CmKVUCnFd7EybaPR7xis9Pq4AynROjFzjV2TWRmqOUMzATUqSsMLS7dIIJdFfpM5aj0ni/i8ynYgjX9el8cl0H18GJJ6u9jyQTFqLFyGezgs/5C+10n3fkrt6K5NDwTWJjPo4QC3dB6D5caeSSfc0+CqrRxHmxtnKQn5o+GRGxHNBNZxNKhZPynzz3TIgWLb6dXgHoVCz1ymjq1o5ddtfXqL1AiFngHRYpKFgYAWX/tagZW5V1fYAT8v1L65CJ5M0xfZyw1BVgLxu9tPSHS4/qluSrb/HJ8GqP2J1aXBXPeKMYCpQ/s95pHTICUOhGpfIwcRYhsAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C1OGHsLvOjCx7dhlB/4ZlOoHtRYj5jCN8uem7rVbES8=;
 b=OfQgivWlCuq7zlFlO1usO1KNsWgmzDLf6/S8qOJxVtWDcYzI1+S/y4DQBxpZlvizJHcCDW9mU9RzVlPNwNfKOD8XS8HW2KNd/8o8v9Phmj4rf8PkqEwaeuGwoUSkXNifB6CywqFgd9lrbnbKjA1IlrsOoF9KooVtBwR1iv3XboSbg/wJKZPvXqm1kbBwYvW4rkub60MujHME3O56DZvmxG6DtZiUDO0nu1XFB9uaG/gygzGENB1OXh0Qbc1JiYJqghhUiO2PdLjAm+giT8PUFFBy1t7slAdULqygQAGT4SZDW60otnxWV708Bzk4GwJrhaJVf4EyYQPPuc0V6pCAwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C1OGHsLvOjCx7dhlB/4ZlOoHtRYj5jCN8uem7rVbES8=;
 b=XU5jIf9BZz99lXmoHv9pTqvYORTrhzInM5Edfl/XdUPYjmszG+fZsaUlvGyLMZVaDfXgEBeo6FrRPxzVztRnsN/JL2PlrCzSdUD1aGvSJvVyPtsFlHJAUVWe/MmBuuhrlOBeLQN9LWJOi04GogrWhsEkkagv0XtzeEKfSCqyqiY=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5341.eurprd05.prod.outlook.com (20.178.8.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Wed, 20 Nov 2019 22:22:26 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.015; Wed, 20 Nov 2019
 22:22:26 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>
Subject: [PATCH mlx5-next 3/5] net/mlx5: Add structures and defines for MIRC
 register
Thread-Topic: [PATCH mlx5-next 3/5] net/mlx5: Add structures and defines for
 MIRC register
Thread-Index: AQHVn/D93Ukm8FsYbEqaPnVEB/F2cg==
Date:   Wed, 20 Nov 2019 22:22:26 +0000
Message-ID: <20191120222128.29646-4-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 26aeebf4-a503-43e1-48ae-08d76e081f94
x-ms-traffictypediagnostic: VI1PR05MB5341:|VI1PR05MB5341:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB53418802CDFDE12B1D751C4FBE4F0@VI1PR05MB5341.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(366004)(396003)(39860400002)(376002)(199004)(189003)(476003)(102836004)(316002)(99286004)(66476007)(76176011)(8936002)(14454004)(386003)(2906002)(6506007)(52116002)(110136005)(6436002)(446003)(6486002)(66556008)(54906003)(2616005)(66446008)(478600001)(64756008)(66066001)(66946007)(6636002)(5660300002)(11346002)(486006)(50226002)(81166006)(71190400001)(71200400001)(7736002)(186003)(305945005)(81156014)(36756003)(25786009)(8676002)(4326008)(6512007)(450100002)(14444005)(256004)(86362001)(6116002)(3846002)(1076003)(107886003)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5341;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BGKorlEDOTeeoI33/Q1JtqGHPy7ScOoHVBps9Rt38e6U0d6ALZinGoLJbAnNqTKNOSotB3PoKnl4SyZGYUXv5zsTM6CxpryjlNc4u1f7Mr9DLV9NfznT2l6OKXfalLGB3PKWLmldLk5IMyBF+17SrYYJBhkF3AcV8iIX+4/BxPJyz7ZWaex5WhkiazabfxaY+VbOtldsAq2sn/c56ZkTuM/U0PTdN/oeF3h3bLbNg4kJCokL3irrtPQJ8KHthQgTIvep7NplcvY0aVxyjKS0j/lkHConC35ByAEAMXxBg2NOBekva1ReD5Qy/xf/AATpvM/z6Q4V4djSongBrWIUNuP4ph/CDsECIsvu7UiaHMnfe/OzshSQbv4ZmdzXIA8PX5e4aUle6KaE3oCvb4hgilbrHOFNO1HjQMcZUfGr3wD7m9zgPdRVL6rP9wvmkmfC
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26aeebf4-a503-43e1-48ae-08d76e081f94
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 22:22:26.6309
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z1RcBiTbnCbPevqqik08eq0mObKAtI4dUUKM4GP6MWyCrJoqOA/8tkUtCkWxiwVdWwd6Dhmh+uZieLwFCX/X0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5341
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Add needed structures, layouts and defines for MIRC (Management Image
Re-activation Control) register. This structure will be used for the FSM
reactivation flow in the downstream patches.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/driver.h   | 1 +
 include/linux/mlx5/mlx5_ifc.h | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 462c67e2dc13..d479c5e48295 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -145,6 +145,7 @@ enum {
 	MLX5_REG_MCC		 =3D 0x9062,
 	MLX5_REG_MCDA		 =3D 0x9063,
 	MLX5_REG_MCAM		 =3D 0x907f,
+	MLX5_REG_MIRC		 =3D 0x9162,
 };
=20
 enum mlx5_qpts_trust_state {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 97acbe8cebf8..9107c032062f 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -9456,6 +9456,13 @@ struct mlx5_ifc_mcda_reg_bits {
 	u8         data[0][0x20];
 };
=20
+struct mlx5_ifc_mirc_reg_bits {
+	u8         reserved_at_0[0x18];
+	u8         status_code[0x8];
+
+	u8         reserved_at_20[0x20];
+};
+
 union mlx5_ifc_ports_control_registers_document_bits {
 	struct mlx5_ifc_bufferx_reg_bits bufferx_reg;
 	struct mlx5_ifc_eth_2819_cntrs_grp_data_layout_bits eth_2819_cntrs_grp_da=
ta_layout;
@@ -9511,6 +9518,7 @@ union mlx5_ifc_ports_control_registers_document_bits =
{
 	struct mlx5_ifc_mcqi_reg_bits mcqi_reg;
 	struct mlx5_ifc_mcc_reg_bits mcc_reg;
 	struct mlx5_ifc_mcda_reg_bits mcda_reg;
+	struct mlx5_ifc_mirc_reg_bits mirc_reg;
 	u8         reserved_at_0[0x60e0];
 };
=20
--=20
2.21.0

