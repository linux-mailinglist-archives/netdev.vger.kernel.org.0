Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD0B45FCC4
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 20:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbfGDSQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 14:16:08 -0400
Received: from mail-eopbgr60046.outbound.protection.outlook.com ([40.107.6.46]:28482
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727188AbfGDSQG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 14:16:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wr1hznPh3mghbOczZI4rB+JfNKj1ZYQaDbkMoqiF034=;
 b=ffx9qgtpEVMautTvCQlRcW+2X7MppD0/wuaqkXAzNv+dOHOFYrWppWkuleAQed897yrTuieV5R8EgXmcfrPcoK9/JEBWaq1NyV1NxYMh41QxHD/7AQDFR77k1Isv8UG71YRhUJ28zsReYkfQ4y5H7qmy6PCCeJr6azBV/3H4Mlc=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2584.eurprd05.prod.outlook.com (10.168.74.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Thu, 4 Jul 2019 18:15:55 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c%4]) with mapi id 15.20.2032.019; Thu, 4 Jul 2019
 18:15:55 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 05/14] net/mlx5: Add crypto library to support
 create/destroy encryption key
Thread-Topic: [net-next 05/14] net/mlx5: Add crypto library to support
 create/destroy encryption key
Thread-Index: AQHVMpSFsw43vvNOdUid/VKyYc6B8A==
Date:   Thu, 4 Jul 2019 18:15:55 +0000
Message-ID: <20190704181235.8966-6-saeedm@mellanox.com>
References: <20190704181235.8966-1-saeedm@mellanox.com>
In-Reply-To: <20190704181235.8966-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.148.53.10]
x-clientproxiedby: BYAPR06CA0061.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::38) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c4cf2e45-3683-433b-58d3-08d700aba77f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2584;
x-ms-traffictypediagnostic: DB6PR0501MB2584:
x-microsoft-antispam-prvs: <DB6PR0501MB2584F958F4A9989CE351BFE5BEFA0@DB6PR0501MB2584.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(199004)(189003)(486006)(14454004)(186003)(305945005)(26005)(6916009)(71200400001)(6486002)(7736002)(86362001)(256004)(14444005)(8936002)(81156014)(386003)(76176011)(8676002)(81166006)(6116002)(52116002)(2906002)(6436002)(3846002)(102836004)(71190400001)(2616005)(476003)(446003)(11346002)(6506007)(99286004)(73956011)(25786009)(1076003)(107886003)(66946007)(66556008)(66476007)(68736007)(66446008)(64756008)(5660300002)(478600001)(4326008)(50226002)(6512007)(54906003)(66066001)(316002)(36756003)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2584;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: V4wgOqyTKO+QykAx2Nk/ktjC13N5rjVMI+fThO726aedPBWrTaOblrL0vcrzX5dRY+tjcHjTUGw5ASxlv8VhzA+GfWs1nkmL83t7OnTiUnfi9RbCZGfuBcQUyy2pN8PNSfTy5d2MwUe/baGrb+v8WshKMgwOhXPTEoi/NhnLRCyIdCL5L9mYOiYeRAyJn5kfLSK1ksP75TEVu4n80+hhkeE4RPeyuERl+sf/lSp7TjL3s8Ip7G/IKjahKH2TIOEDl8Xzz8O16menDgwdI/+31VhjFbXQ+JfK5P3B1WoJ/+SG4ERIw60ZJA+vq94+inN4SSlp9DbGgCnkXufwfR0ZDqVHC5h451vaiwQafWGwDvvetvnR8ViGYPnX1iudpU2tuV+PFRT8jWW9mPHg0cy/1CmV9nWir+QX51q7N08D6D4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4cf2e45-3683-433b-58d3-08d700aba77f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 18:15:55.2058
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2584
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Encryption key create / destroy is done via
CREATE_GENERAL_OBJECT / DESTROY_GENERAL_OBJECT commands.

To be used in downstream patches by TLS API wrappers, to configure
the TIS context with the encryption key.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  2 +-
 .../ethernet/mellanox/mlx5/core/lib/crypto.c  | 72 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/lib/mlx5.h    |  5 ++
 3 files changed, 78 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net=
/ethernet/mellanox/mlx5/core/Makefile
index da7adac6b4a7..cf2b342b7566 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -55,7 +55,7 @@ mlx5_core-$(CONFIG_MLX5_CORE_IPOIB) +=3D ipoib/ipoib.o ip=
oib/ethtool.o ipoib/ipoib
 #
 mlx5_core-$(CONFIG_MLX5_FPGA_IPSEC) +=3D fpga/ipsec.o
 mlx5_core-$(CONFIG_MLX5_FPGA_TLS)   +=3D fpga/tls.o
-mlx5_core-$(CONFIG_MLX5_ACCEL)      +=3D accel/tls.o accel/ipsec.o
+mlx5_core-$(CONFIG_MLX5_ACCEL)      +=3D lib/crypto.o accel/tls.o accel/ip=
sec.o
=20
 mlx5_core-$(CONFIG_MLX5_FPGA) +=3D fpga/cmd.o fpga/core.o fpga/conn.o fpga=
/sdk.o
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c b/drivers=
/net/ethernet/mellanox/mlx5/core/lib/crypto.c
new file mode 100644
index 000000000000..823a0f5f76e2
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
@@ -0,0 +1,72 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2019 Mellanox Technologies.
+
+#include "mlx5_core.h"
+
+int mlx5_create_encryption_key(struct mlx5_core_dev *mdev,
+			       void *key, u32 sz_bytes,
+			       u32 *p_key_id)
+{
+	u32 in[MLX5_ST_SZ_DW(create_encryption_key_in)] =3D {};
+	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
+	u32 sz_bits =3D sz_bytes * BITS_PER_BYTE;
+	u8  general_obj_key_size;
+	u64 general_obj_types;
+	void *obj, *key_p;
+	int err;
+
+	obj =3D MLX5_ADDR_OF(create_encryption_key_in, in, encryption_key_object)=
;
+	key_p =3D MLX5_ADDR_OF(encryption_key_obj, obj, key);
+
+	general_obj_types =3D MLX5_CAP_GEN_64(mdev, general_obj_types);
+	if (!(general_obj_types &
+	      MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY))
+		return -EINVAL;
+
+	switch (sz_bits) {
+	case 128:
+		general_obj_key_size =3D
+			MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_KEY_SIZE_128;
+		break;
+	case 256:
+		general_obj_key_size =3D
+			MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_KEY_SIZE_256;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	memcpy(key_p, key, sz_bytes);
+
+	MLX5_SET(encryption_key_obj, obj, key_size, general_obj_key_size);
+	MLX5_SET(encryption_key_obj, obj, key_type,
+		 MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_DEK);
+	MLX5_SET(general_obj_in_cmd_hdr, in, opcode,
+		 MLX5_CMD_OP_CREATE_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type,
+		 MLX5_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY);
+	MLX5_SET(encryption_key_obj, obj, pd, mdev->mlx5e_res.pdn);
+
+	err =3D mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+	if (!err)
+		*p_key_id =3D MLX5_GET(general_obj_out_cmd_hdr, out, obj_id);
+
+	/* avoid leaking key on the stack */
+	memset(in, 0, sizeof(in));
+
+	return err;
+}
+
+void mlx5_destroy_encryption_key(struct mlx5_core_dev *mdev, u32 key_id)
+{
+	u32 in[MLX5_ST_SZ_DW(general_obj_in_cmd_hdr)] =3D {};
+	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
+
+	MLX5_SET(general_obj_in_cmd_hdr, in, opcode,
+		 MLX5_CMD_OP_DESTROY_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type,
+		 MLX5_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, key_id);
+
+	mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h b/drivers/n=
et/ethernet/mellanox/mlx5/core/lib/mlx5.h
index d918e44491f4..b99d469e4e64 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
@@ -79,4 +79,9 @@ struct mlx5_pme_stats {
 void mlx5_get_pme_stats(struct mlx5_core_dev *dev, struct mlx5_pme_stats *=
stats);
 int mlx5_notifier_call_chain(struct mlx5_events *events, unsigned int even=
t, void *data);
=20
+/* Crypto */
+int mlx5_create_encryption_key(struct mlx5_core_dev *mdev,
+			       void *key, u32 sz_bytes, u32 *p_key_id);
+void mlx5_destroy_encryption_key(struct mlx5_core_dev *mdev, u32 key_id);
+
 #endif
--=20
2.21.0

