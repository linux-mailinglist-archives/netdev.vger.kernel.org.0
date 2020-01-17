Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3650014007F
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 01:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387621AbgAQAHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 19:07:03 -0500
Received: from mail-eopbgr70079.outbound.protection.outlook.com ([40.107.7.79]:19560
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728982AbgAQAHC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 19:07:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fBQg8tJBpBtv3hugjvrbT7MOzUAFKTppkmLah3b/V/fNUdq+Xv9W9Cvrym9LFtcw3D2he8WOvCZ7WU4t4uznCHqPJwCvUu7NHeI0meM0sFVcKi8iDGN+XQBh880ebeKfjqlmv8CMueW+AsrVnq/aGOSj4hCbL4ZrnLkfsxbENxf+e65vYVEonD+LnyYfE54H8icSVwgitMfNJkwk38+SXQ/8TTqt7sFT0yyhxRxxkcxa69ITk+obpVLp0ZJPMUwbFluJKsvY0GDVqBfy2Mv19NZGMruw9Byhqbedy6/5eMXeAN5p94wBU8hB4htIpbnySIIX535GPcpjkGUCG6t0dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=johDOm5RQj4Mronh+WccjQV6cMKJOfnmwcQBYoY1wuI=;
 b=LauW+puXddaoBjueXOcP/X7ygtzD1s736cKKCdFiDL8ikg/0SOPZoYQ9dYzFFEqNHnM/Y3gqkqfgu3ehKa+UUp4K/S5B5yxUdNEbLwc264Pvyiy8wUtsJ/WvI+GzzVtlLlgqMno0kh8TSu/vdBwJtBdDNQoPAW06sT4YysnuvK56DXLZ7YM1heYuQPZxsK68vydf7qa3iDRPAZg5pSbqHS2TiOmc5FpY6gyz5sb2bImwYS3ofLO0ii1m75FUCSrxBwzOmQ/DCs530fX/+wTC41XnWjMMBX/cEEAVOrU5RmJtxWw1hLKF6E7QJRntcMcarItnsc7wQugx9FtjKKGXRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=johDOm5RQj4Mronh+WccjQV6cMKJOfnmwcQBYoY1wuI=;
 b=DBK/9zyUnYWPrM1cPGL8bGypg4pfCAUPT6mAlsEW6+RDHwLIVR/YNntX5KHpNyV55CLjYfE4G7vefLkxhlfEFfcZv/ufmyFpr4S/BwAl5vAHEjGtuVM+dEsoTkfEpKroUO6rMs9jrYLfalzS2AXkmi8XdTmYGKHYqLspN0kFCcg=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4990.eurprd05.prod.outlook.com (20.177.49.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Fri, 17 Jan 2020 00:06:57 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.015; Fri, 17 Jan 2020
 00:06:57 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR03CA0003.namprd03.prod.outlook.com (2603:10b6:a02:a8::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Fri, 17 Jan 2020 00:06:55 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [mlx5-next 03/16] net/mlx5: Add structures and defines for MIRC
 register
Thread-Topic: [mlx5-next 03/16] net/mlx5: Add structures and defines for MIRC
 register
Thread-Index: AQHVzMoIJP5fKxR9rUWeemq1d03eSQ==
Date:   Fri, 17 Jan 2020 00:06:57 +0000
Message-ID: <20200117000619.696775-4-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 52a8cbf1-ade5-4436-ccf7-08d79ae12aa5
x-ms-traffictypediagnostic: VI1PR05MB4990:|VI1PR05MB4990:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB49908A057FB433045628A402BE310@VI1PR05MB4990.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0285201563
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(366004)(39860400002)(136003)(346002)(189003)(199004)(64756008)(6512007)(52116002)(66476007)(26005)(81166006)(86362001)(16526019)(316002)(81156014)(8676002)(2616005)(66556008)(186003)(6486002)(956004)(71200400001)(36756003)(508600001)(66446008)(54906003)(1076003)(5660300002)(2906002)(6506007)(4326008)(110136005)(8936002)(66946007)(107886003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4990;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J2Naxe4OtkBJZv4qjIqV/k8ZS8PzHWHXUS8dwuUCPhq5Bo3SNE+ChEpi5v3zTaHHnom5+Hdbnf80yx8/kwAq7NsqLcBrwufARSfMNXvLNaPZ6vitNHkMqbj+jAkAMEaROUPWTKlY2SQNOwiNVU1vmi7eLPiOwCUGDaZ2G2RY/PJTz5y/svkgrXGTvM0y2qvhN1ExNQ/Weks1gDYxrZJO9yJgkv01F0KZQaNqhk7KqERD/wzbvQSazW5VdH/syKVs/kMbb8jUhmg+f17nJoM9OxEqD4a1Ts+Bc0Mf9BRUUc0lq77mkyhXCc77y/BwSlgm4RpjMIUTzFOTJNFwrTnLJfdOrB9hpP2fKsQCEy02RKweSQEWBqcrIYZrwJx0Pa7dhZFMlno1u4/xkqnvM78CS3/5iem9GA1RrAZQ4XrpqlezgfYOJMctO8aVL7N3p897hYNPQpwt6S0R2u5u5peduP7kjKh5bo7LeDcaig7y9N+hiBpG9tI9YyX+M5uhsDjADr+Q1m2DZc1cELcAV06xI/rHpbfgSqpn7gjjBqUXw3Q=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52a8cbf1-ade5-4436-ccf7-08d79ae12aa5
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2020 00:06:57.2191
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j5BoS6g4yrkWCvKSu4li6BG9jE/wdeYl6OWWNNAyBFjC/9WVqyneYD9kk1e6CYxF9YXOtypPP9JLLfItS7JWLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4990
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
index dc3c725be092..5bbdbeb21ab6 100644
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
index 43cdf9211747..a133583c3e4f 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -9471,6 +9471,13 @@ struct mlx5_ifc_mcda_reg_bits {
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
@@ -9526,6 +9533,7 @@ union mlx5_ifc_ports_control_registers_document_bits =
{
 	struct mlx5_ifc_mcqi_reg_bits mcqi_reg;
 	struct mlx5_ifc_mcc_reg_bits mcc_reg;
 	struct mlx5_ifc_mcda_reg_bits mcda_reg;
+	struct mlx5_ifc_mirc_reg_bits mirc_reg;
 	u8         reserved_at_0[0x60e0];
 };
=20
--=20
2.24.1

