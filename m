Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B52D140082
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 01:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387896AbgAQAHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 19:07:09 -0500
Received: from mail-eopbgr70079.outbound.protection.outlook.com ([40.107.7.79]:19560
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387697AbgAQAHI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 19:07:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UUF/kLvPqp8Efvxr1kDM4epoabekyvU50TITSLxG4/MIg/3ooUUjnccvMl96XjNGKmDpuOjMzTTyowDwSquN9KzvTWeZZKQ4nfHQ1xZAFGOiVwh8X/FCT66cEXlNoxGqdv19knEpeUnuVQQZ4nwvp2EZYZDhC5c6EVY+3F1T0fVRq413X3/0LQcEbVYSSr5qcJPjOMDT8fDanyiNpETQdlniZ1bwd5au+JUlw46DVsK+/bni9in/qyQIuK4jnmjSXk7X1An+8zZMrYZoM+9pk9MFqoq0WeSytQERILJhJhpfIovR1OFiCv7KYW0P+iSKQMf1ouViE3/t3/csImwt9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HrKpO9pJbTiSPJorF8vAjwlZjz/XIP12xAD1ywebICo=;
 b=Aym8+kXVCz0InHng+aBoCGoy7sUw2SKjAf0Uk51Gne/3B0F300Gt+o7dBOF+d3+RELM9W4ZLNrFFqDU2MoXrXtDTLTbM7AR6q0RbbSMQmOqtfjUVHB/gUMxsGlwreribIj+F9pOAtmKSypqb4AMDcumH0Zf4TtBb7A411XU/Q39PApGcVAr3zn+IqzqwlaJWUislW2TD7QuWkpchENSCElxLz4WYUpONFF5CnKoF/Q23O426x74ZC36wuh0T6C4wkUYQxux9mCp7rN3gkJhRu/PMdG1YCGfYpAmaRDmQpd8jnkyDKGOaaynkzxmDP6/kxcSKVoFgLR3OtWceT8RWvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HrKpO9pJbTiSPJorF8vAjwlZjz/XIP12xAD1ywebICo=;
 b=BAU+wdRlbQaUmkLZXzFbMfuNTLDW7vgLe0I71LPZrnhPT4SpfFxiw8uZHlAWSroI0OvlansXRk0L0Odi8bBF1ZLPJ/LDsckKYsNvXuMitCLUUUx3Z5mUbs7Sz2bPjvPGgwYkLDyuRb6KcTsMB2HUvfNLLhpD41aub5D3VQVqaMY=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4990.eurprd05.prod.outlook.com (20.177.49.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Fri, 17 Jan 2020 00:07:04 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.015; Fri, 17 Jan 2020
 00:07:04 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR03CA0003.namprd03.prod.outlook.com (2603:10b6:a02:a8::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Fri, 17 Jan 2020 00:07:01 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [mlx5-next 06/16] net/mlx5: Add mlx5_ifc definitions for connection
 tracking support
Thread-Topic: [mlx5-next 06/16] net/mlx5: Add mlx5_ifc definitions for
 connection tracking support
Thread-Index: AQHVzMoMkIr5leAf0Eu13Mq+WwvR8A==
Date:   Fri, 17 Jan 2020 00:07:03 +0000
Message-ID: <20200117000619.696775-7-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: b079a954-173d-4e7f-fa66-08d79ae12ea5
x-ms-traffictypediagnostic: VI1PR05MB4990:|VI1PR05MB4990:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4990F9533961413938059E14BE310@VI1PR05MB4990.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0285201563
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(366004)(39860400002)(136003)(346002)(189003)(199004)(64756008)(6512007)(52116002)(66476007)(26005)(81166006)(86362001)(16526019)(316002)(81156014)(8676002)(2616005)(66556008)(186003)(6486002)(956004)(71200400001)(36756003)(508600001)(66446008)(54906003)(1076003)(5660300002)(2906002)(6506007)(4326008)(110136005)(8936002)(66946007)(107886003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4990;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4UHenS+gyqW5tXFRnpwF3atNbSOkvEvpsEtFgiECkVzfEM0gQ4ChVF3QItOFyPrVGAncei8dRidAJt01N7mVmtmjeg4HupQLGKoMmB/YjlV0jLY5RO39/jTdfUMEZGR39f/0L1hd80i8095123BtH/is0Tt+SFp219VN7jhEVXnYvvxPUChRGGStiXY7o3HGFq4vhdRuW78R78fCg80gvF1SQILFCuLuOulJJggvs8axhG9sDLlFSGGC6lSQaBlZMuF88RoBqPXrJ9+f53imVc9MXOhBfmK+J5bpBt4uE9El3Y8QH06yg+504rT5AqRhU7lIdZ5ufi0Ss/DFPt/t8sEgD2dQnxBz/iYmwKlP3kei++BC96P23Xecx7ty/dxZZbh02E6rFgXBBG1I/FrCLn74ZYuGPZmNUFKmayV7Vzbft8Hac1n7UDj3dpuPCdDE4QIdWRhw/HPJwM8F1L7oRlDNjdJ3MC+1Kz7iciX81keVWiyIow1OaeTMklvVPvLe3xR922wYRVn/VBskJ0ILySHtqu+Pr7hZ5vUgnwqFBxs=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b079a954-173d-4e7f-fa66-08d79ae12ea5
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2020 00:07:03.9241
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ktYlVyPf4uRnZY831XcOAzVKIUaXfmtc/cc729n1Wx+6EjJWoeFuwyyyBMX+vV+VXFRV5uFo8syUyJM2a7DZJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4990
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Add the required hardware definitions to mlx5_ifc:
ignore_flow_level, registers, copy_header, and fwd_and_modify cap.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Oz Sholomo <ozsh@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 23613a6ea51c..e9c165ffe3f9 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -375,8 +375,17 @@ struct mlx5_ifc_flow_table_fields_supported_bits {
 	u8	   outer_esp_spi[0x1];
 	u8         reserved_at_58[0x2];
 	u8         bth_dst_qp[0x1];
+	u8         reserved_at_5b[0x5];
=20
-	u8         reserved_at_5b[0x25];
+	u8         reserved_at_60[0x18];
+	u8         metadata_reg_c_7[0x1];
+	u8         metadata_reg_c_6[0x1];
+	u8         metadata_reg_c_5[0x1];
+	u8         metadata_reg_c_4[0x1];
+	u8         metadata_reg_c_3[0x1];
+	u8         metadata_reg_c_2[0x1];
+	u8         metadata_reg_c_1[0x1];
+	u8         metadata_reg_c_0[0x1];
 };
=20
 struct mlx5_ifc_flow_table_prop_layout_bits {
@@ -401,7 +410,8 @@ struct mlx5_ifc_flow_table_prop_layout_bits {
 	u8	   reformat_l3_tunnel_to_l2[0x1];
 	u8	   reformat_l2_to_l3_tunnel[0x1];
 	u8	   reformat_and_modify_action[0x1];
-	u8         reserved_at_15[0x2];
+	u8	   ignore_flow_level[0x1];
+	u8         reserved_at_16[0x1];
 	u8	   table_miss_action_domain[0x1];
 	u8         termination_table[0x1];
 	u8         reserved_at_19[0x7];
@@ -722,7 +732,9 @@ enum {
=20
 struct mlx5_ifc_flow_table_eswitch_cap_bits {
 	u8      fdb_to_vport_reg_c_id[0x8];
-	u8      reserved_at_8[0xf];
+	u8      reserved_at_8[0xd];
+	u8      fdb_modify_header_fwd_to_table[0x1];
+	u8      reserved_at_16[0x1];
 	u8      flow_source[0x1];
 	u8      reserved_at_18[0x2];
 	u8      multi_fdb_encap[0x1];
@@ -4141,7 +4153,8 @@ struct mlx5_ifc_set_fte_in_bits {
 	u8         reserved_at_a0[0x8];
 	u8         table_id[0x18];
=20
-	u8         reserved_at_c0[0x18];
+	u8         ignore_flow_level[0x1];
+	u8         reserved_at_c1[0x17];
 	u8         modify_enable_mask[0x8];
=20
 	u8         reserved_at_e0[0x20];
@@ -5627,6 +5640,7 @@ struct mlx5_ifc_copy_action_in_bits {
 union mlx5_ifc_set_action_in_add_action_in_auto_bits {
 	struct mlx5_ifc_set_action_in_bits set_action_in;
 	struct mlx5_ifc_add_action_in_bits add_action_in;
+	struct mlx5_ifc_copy_action_in_bits copy_action_in;
 	u8         reserved_at_0[0x40];
 };
=20
@@ -5669,6 +5683,8 @@ enum {
 	MLX5_ACTION_IN_FIELD_METADATA_REG_C_3  =3D 0x54,
 	MLX5_ACTION_IN_FIELD_METADATA_REG_C_4  =3D 0x55,
 	MLX5_ACTION_IN_FIELD_METADATA_REG_C_5  =3D 0x56,
+	MLX5_ACTION_IN_FIELD_METADATA_REG_C_6  =3D 0x57,
+	MLX5_ACTION_IN_FIELD_METADATA_REG_C_7  =3D 0x58,
 	MLX5_ACTION_IN_FIELD_OUT_TCP_SEQ_NUM   =3D 0x59,
 	MLX5_ACTION_IN_FIELD_OUT_TCP_ACK_NUM   =3D 0x5B,
 };
--=20
2.24.1

