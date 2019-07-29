Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02CF079ABB
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388441AbfG2VNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:13:01 -0400
Received: from mail-eopbgr10054.outbound.protection.outlook.com ([40.107.1.54]:2445
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388415AbfG2VNB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 17:13:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CHvdlfa4pQaAkcWipZm2Rh7Z4XXztQV2XlYF2YI4fHzUa70g2I07uQl90SagGTl4P9gn9vvBpntbZDAyr91JHTszJyUhP0hLwiBruGGEGuTCDqaBo/YmXlN9mhdPyCma/B28JQGwHS2pt8honYMuLfHpzKo8boiXWxRkOmRWUH2z1/MniWeoV8aV3AsTiF0Cb0p68A443x+NB1UMRnxvHNYSdMr1aJkYSK3salptHr8NwS47DbyKfnV0YOJI5DohA8qr2KJ1UxtlbG5hUq3qTdb+fEwzVGWFx5QlZI+ulJlCjF4BTPliETvCjMQN+NTeeELkizzKwbMW9k7U+LMqyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zd58+mrw/Hm5qU8twYSx9ViD4FRzW2EDClHRct0eOzg=;
 b=QNjbYdm6PNIi6IEaBjiEdx8k+3XHWma6RstTKF2CuJw6Kh2Y+X+p3oOijqUYZhmK2lguTWHGGUi6bRKkE8H5EnVh3KzrfJeQA3963LL+g+D4ZMw796qy0aB7hlggOokkrjD5NtDxSBXgS5Mc1dBfCwp4/Yr29ZPFPNt6RDRCu0BWsRAc5Zx8fwwgxNEmLZqOzPMs+IAOhcxKGEGj0XRs/ur9gY8YZpBr96V037ZvtYY9RrnZtZawrCHkwy5/Qitevj9oZxfdkrzOTYb2SozCe/iPM3cjYb2A9Vh1pbRQFGylKhwyp9WXMZFf+ykp/tmgfNVLxpNxwP6KQrU+aBYXkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zd58+mrw/Hm5qU8twYSx9ViD4FRzW2EDClHRct0eOzg=;
 b=VAVxbxPa5uR6xOrMIFKxxUO3P/NTvpHwC0TFkGhvgvDeSACuQLYre6Evvt3UMiVKGqo3hk1ScnIzUZwCnY+4LSmolSJEctDPDB4pMJl0P9bx6o/6uK1L2CxtMQ6W5vval1iHBPzR1ojU6+NohW0121BTayth6QdvXE/jrJUAk/U=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2375.eurprd05.prod.outlook.com (10.168.72.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Mon, 29 Jul 2019 21:12:54 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 21:12:54 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
CC:     Gavi Teitz <gavi@mellanox.com>, Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH mlx5-next 02/11] net/mlx5: Add flow counter bulk allocation
 hardware bits and command
Thread-Topic: [PATCH mlx5-next 02/11] net/mlx5: Add flow counter bulk
 allocation hardware bits and command
Thread-Index: AQHVRlJjzIz4a/kgFESfERMyVLc2wQ==
Date:   Mon, 29 Jul 2019 21:12:54 +0000
Message-ID: <20190729211209.14772-3-saeedm@mellanox.com>
References: <20190729211209.14772-1-saeedm@mellanox.com>
In-Reply-To: <20190729211209.14772-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0081.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::22) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b84c1f6e-7016-4228-2e26-08d7146985c2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2375;
x-ms-traffictypediagnostic: DB6PR0501MB2375:
x-microsoft-antispam-prvs: <DB6PR0501MB23750568E346676400616257BEDD0@DB6PR0501MB2375.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(199004)(189003)(50226002)(14444005)(5660300002)(6116002)(3846002)(486006)(446003)(86362001)(81156014)(186003)(36756003)(81166006)(8936002)(26005)(25786009)(316002)(71190400001)(71200400001)(110136005)(54906003)(64756008)(76176011)(66556008)(2906002)(66946007)(66446008)(99286004)(66476007)(1076003)(386003)(6506007)(102836004)(256004)(7736002)(6486002)(14454004)(66066001)(2501003)(8676002)(305945005)(6436002)(4326008)(11346002)(68736007)(52116002)(2616005)(476003)(478600001)(6512007)(450100002)(2201001)(107886003)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2375;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ke4mZPSSCQp1X3PEjZQ0TegPX9WIEoeqBm9QJaRh9Qb6q0nhDUsB6XcbKefvnOUbDoloO8jGpToXftUcplv1k5xK+3mrB6kkZHfmDuRfIc2QyY8a43SMxJK1SoXXuVDYrDKwG6X9fssFIZot3iF174mwnGSyNjti7wBg/c7itMR0BXyj0ZgLRF7SbZ7R+Hg1Dfzpb2wqlqrp59AkHJp12E5uKswAjcxXSI9nIMlZYIsK+A9Zr5qtftWsKSFuU+L0b6CfJvEZSRaKIoDpcPFvbXvq0ZuXU9z96oWweVvXobCfNDRfENlFvFf5DogPZVMTABpMwcFIAtYFt0fgNsVjfBHa/iBG9k2+fIndp5Qaj1d9A/YkSnlm38dXHIaQQ8Y5h6PPZYqxGiGho0eQ/hudEy3ShlMzJLasCD7ashDFhYg=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b84c1f6e-7016-4228-2e26-08d7146985c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 21:12:54.7650
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2375
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gavi Teitz <gavi@mellanox.com>

Add a handle to invoke the new FW capability of allocating a bulk of
flow counters.

Signed-off-by: Gavi Teitz <gavi@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  | 10 ++++++++-
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.h  |  3 +++
 include/linux/mlx5/mlx5_ifc.h                 | 21 +++++++++++++++++--
 3 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net=
/ethernet/mellanox/mlx5/core/fs_cmd.c
index 51f6972f4c70..b84a225bbe86 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -566,7 +566,9 @@ static int mlx5_cmd_delete_fte(struct mlx5_flow_root_na=
mespace *ns,
 	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 }
=20
-int mlx5_cmd_fc_alloc(struct mlx5_core_dev *dev, u32 *id)
+int mlx5_cmd_fc_bulk_alloc(struct mlx5_core_dev *dev,
+			   enum mlx5_fc_bulk_alloc_bitmask alloc_bitmask,
+			   u32 *id)
 {
 	u32 in[MLX5_ST_SZ_DW(alloc_flow_counter_in)]   =3D {0};
 	u32 out[MLX5_ST_SZ_DW(alloc_flow_counter_out)] =3D {0};
@@ -574,6 +576,7 @@ int mlx5_cmd_fc_alloc(struct mlx5_core_dev *dev, u32 *i=
d)
=20
 	MLX5_SET(alloc_flow_counter_in, in, opcode,
 		 MLX5_CMD_OP_ALLOC_FLOW_COUNTER);
+	MLX5_SET(alloc_flow_counter_in, in, flow_counter_bulk, alloc_bitmask);
=20
 	err =3D mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 	if (!err)
@@ -581,6 +584,11 @@ int mlx5_cmd_fc_alloc(struct mlx5_core_dev *dev, u32 *=
id)
 	return err;
 }
=20
+int mlx5_cmd_fc_alloc(struct mlx5_core_dev *dev, u32 *id)
+{
+	return mlx5_cmd_fc_bulk_alloc(dev, 0, id);
+}
+
 int mlx5_cmd_fc_free(struct mlx5_core_dev *dev, u32 id)
 {
 	u32 in[MLX5_ST_SZ_DW(dealloc_flow_counter_in)]   =3D {0};
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h b/drivers/net=
/ethernet/mellanox/mlx5/core/fs_cmd.h
index db49eabba98d..bc4606306009 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h
@@ -78,6 +78,9 @@ struct mlx5_flow_cmds {
 };
=20
 int mlx5_cmd_fc_alloc(struct mlx5_core_dev *dev, u32 *id);
+int mlx5_cmd_fc_bulk_alloc(struct mlx5_core_dev *dev,
+			   enum mlx5_fc_bulk_alloc_bitmask alloc_bitmask,
+			   u32 *id);
 int mlx5_cmd_fc_free(struct mlx5_core_dev *dev, u32 id);
 int mlx5_cmd_fc_query(struct mlx5_core_dev *dev, u32 id,
 		      u64 *packets, u64 *bytes);
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index b3d5752657d9..196987f14a3f 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1040,6 +1040,21 @@ enum {
 	MLX5_UCTX_CAP_INTERNAL_DEV_RES =3D 1UL << 1,
 };
=20
+#define MLX5_FC_BULK_SIZE_FACTOR 128
+
+enum mlx5_fc_bulk_alloc_bitmask {
+	MLX5_FC_BULK_128   =3D (1 << 0),
+	MLX5_FC_BULK_256   =3D (1 << 1),
+	MLX5_FC_BULK_512   =3D (1 << 2),
+	MLX5_FC_BULK_1024  =3D (1 << 3),
+	MLX5_FC_BULK_2048  =3D (1 << 4),
+	MLX5_FC_BULK_4096  =3D (1 << 5),
+	MLX5_FC_BULK_8192  =3D (1 << 6),
+	MLX5_FC_BULK_16384 =3D (1 << 7),
+};
+
+#define MLX5_FC_BULK_NUM_FCS(fc_enum) (MLX5_FC_BULK_SIZE_FACTOR * (fc_enum=
))
+
 struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         reserved_at_0[0x30];
 	u8         vhca_id[0x10];
@@ -1244,7 +1259,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         reserved_at_2e0[0x7];
 	u8         max_qp_mcg[0x19];
=20
-	u8         reserved_at_300[0x18];
+	u8         reserved_at_300[0x10];
+	u8         flow_counter_bulk_alloc[0x8];
 	u8         log_max_mcg[0x8];
=20
 	u8         reserved_at_320[0x3];
@@ -7815,7 +7831,8 @@ struct mlx5_ifc_alloc_flow_counter_in_bits {
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
=20
-	u8         reserved_at_40[0x40];
+	u8         reserved_at_40[0x38];
+	u8         flow_counter_bulk[0x8];
 };
=20
 struct mlx5_ifc_add_vxlan_udp_dport_out_bits {
--=20
2.21.0

