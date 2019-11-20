Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E46A9104660
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 23:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbfKTWWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 17:22:32 -0500
Received: from mail-eopbgr10048.outbound.protection.outlook.com ([40.107.1.48]:31714
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726554AbfKTWWb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 17:22:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fvM1XZxDYvB5esmccSBPJUtiJBHSYgE15px8dNTa70vYMLm+W7dRWJsFdyPnNVaJg2+o9I5i598FCYmol9j5RMqhvrbFQfoFK2Cd3Y78P+G+nFpfKdHu/3gMiqpv57eFhyXEJ8IyVq/QYqN9wNqoFuOoOileuGTrrlNGzc5jROuOSd1tKYDN+huuH5mKs0TK0D9sXQwESJWZdcFmNseu5xKyX6q1J149t275rcYIyNNNWq2VJp+NmA09+EVEj1CkqDfaR0PlVkyrCWGeuXLMRZMPwkLm7U6yGsR2Eq/Ruq1eSlNxmlQjppmTlzdTlJ/oyqQhvzPpS4g1N01Scsn3Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1wLwQtUMejEZwKVbHuO4XQ3vo1/1o83sb9R6/E43I4=;
 b=QGS8smm/HHljO40XxvQdbDaMf73oEubCHB68ubFTWlVDiwksW/46F3qneYnUN5bWeadl0uErYUirEZPqEutVpju1BvicFbUh4jLf6xb0MDKazPnMjQeC6gz+4CaJgxDla5JJENXODu0zKbdcl+y1j/gMnshC1kvkh8e6QDSFRuCD9k8RkeJO76eu0pGyDH+nR3X0As3a/p9c97MOyjDpU5GePJUAayuuncM3C5YKgdDm0huDu7UNCodSFjfKWg6F2iY5r8y8fPO9MWnjrijfHYepiTmETXZNecaz4EIZpCEEhtqBwriyQLN5NxiIMrpJlvjr1ZebtZ6+p/7WxSnakQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1wLwQtUMejEZwKVbHuO4XQ3vo1/1o83sb9R6/E43I4=;
 b=Lre9pJkRIin1XRor9gtcBBS5MZ90+d+62Pt6hWFOL83kh/uSK7+UxASIaTGY3fbJVI8wXFBwIia8mDuLevF11HSILWIpKI0RdZyZxbcVtPzNYi63w5jT0n20ToWY/WqdKIiXNgdBxXml8HyN0EvBFwb+/EaQFBnYwsw5Tot+qec=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5341.eurprd05.prod.outlook.com (20.178.8.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Wed, 20 Nov 2019 22:22:24 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.015; Wed, 20 Nov 2019
 22:22:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>
Subject: [PATCH mlx5-next 2/5] net/mlx5: Read MCAM register groups 1 and 2
Thread-Topic: [PATCH mlx5-next 2/5] net/mlx5: Read MCAM register groups 1 and
 2
Thread-Index: AQHVn/D8gEdtHUKizEicEYR92flD6w==
Date:   Wed, 20 Nov 2019 22:22:24 +0000
Message-ID: <20191120222128.29646-3-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: c63636b1-a8ab-487c-e827-08d76e081e73
x-ms-traffictypediagnostic: VI1PR05MB5341:|VI1PR05MB5341:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5341877B5223709F2F4CB147BE4F0@VI1PR05MB5341.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(366004)(396003)(39860400002)(376002)(199004)(189003)(476003)(102836004)(316002)(99286004)(66476007)(76176011)(8936002)(14454004)(386003)(2906002)(6506007)(52116002)(110136005)(6436002)(446003)(6486002)(66556008)(54906003)(2616005)(66446008)(478600001)(64756008)(66066001)(66946007)(6636002)(5660300002)(11346002)(486006)(50226002)(81166006)(71190400001)(71200400001)(7736002)(186003)(305945005)(81156014)(36756003)(25786009)(8676002)(4326008)(6512007)(450100002)(14444005)(256004)(86362001)(6116002)(3846002)(1076003)(107886003)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5341;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p/+QHhwvw28DULJWxKXCbn5/+cGEY2jewUi9KFhF9tESCWt0JW3Tu5/2WGMt8oGfVNSxrzPIVPcMOa6k7YLRcB+cLZyBu84xl2ObunzJYQl0FYTIlwlpEE8HfxfyYdyHfflMj25TE5M7+vI4ZKYpdpGXm8ENNrjhUJcNGIiRLhNOUN4n3GAPgmyA7PwuVvyohDUZKKD95BqC/6yoNTq4RRfCp0ImXElV7819LAL+xFAgKgsj9iJtBQNKEWpKy3J4NiHI6JKUSDLdQiU99tkZlrt54sm6PgphVdH2P/QvHNNSGnEnqf0y1LJMxIaynnnawoPz0L+Ixv7+FK3mixD8Fzm/CaR3FXuTA1RQhmR8AYVcLatWGLc00o3HP/Q4DjRgyzOqZcGD/EaIW8QpCh6a4x02GuNoAp5z36fTzs7Vj8I5TA7y8lb+VflI/QzLbGGq
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c63636b1-a8ab-487c-e827-08d76e081e73
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 22:22:24.7459
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xos1X8N6yKaxH8P2FO2+1ShL+5ScU7KY8Qtd299BqQ13xFK/6L8PIWvuwXcsVmE2Ar226daae9DFktynQJ1AjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5341
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

On load, Driver caches MCAM (Management Capabilities Mask Register)
registers. In addition to the only MCAM register group (0) the driver
already reads, here we add support for reading groups 1 and 2.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw.c | 15 +++++++++------
 include/linux/mlx5/device.h                  | 14 +++++++++++++-
 include/linux/mlx5/driver.h                  |  2 +-
 3 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/eth=
ernet/mellanox/mlx5/core/fw.c
index a19790dee7b2..1723229a9259 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -131,11 +131,11 @@ static int mlx5_get_pcam_reg(struct mlx5_core_dev *de=
v)
 				   MLX5_PCAM_REGS_5000_TO_507F);
 }
=20
-static int mlx5_get_mcam_reg(struct mlx5_core_dev *dev)
+static int mlx5_get_mcam_access_reg_group(struct mlx5_core_dev *dev,
+					  enum mlx5_mcam_reg_groups group)
 {
-	return mlx5_query_mcam_reg(dev, dev->caps.mcam,
-				   MLX5_MCAM_FEATURE_ENHANCED_FEATURES,
-				   MLX5_MCAM_REGS_FIRST_128);
+	return mlx5_query_mcam_reg(dev, dev->caps.mcam[group],
+				   MLX5_MCAM_FEATURE_ENHANCED_FEATURES, group);
 }
=20
 static int mlx5_get_qcam_reg(struct mlx5_core_dev *dev)
@@ -221,8 +221,11 @@ int mlx5_query_hca_caps(struct mlx5_core_dev *dev)
 	if (MLX5_CAP_GEN(dev, pcam_reg))
 		mlx5_get_pcam_reg(dev);
=20
-	if (MLX5_CAP_GEN(dev, mcam_reg))
-		mlx5_get_mcam_reg(dev);
+	if (MLX5_CAP_GEN(dev, mcam_reg)) {
+		mlx5_get_mcam_access_reg_group(dev, MLX5_MCAM_REGS_FIRST_128);
+		mlx5_get_mcam_access_reg_group(dev, MLX5_MCAM_REGS_0x9080_0x90FF);
+		mlx5_get_mcam_access_reg_group(dev, MLX5_MCAM_REGS_0x9100_0x917F);
+	}
=20
 	if (MLX5_CAP_GEN(dev, qcam_reg))
 		mlx5_get_qcam_reg(dev);
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index cc1c230f10ee..1715252b2f74 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1120,6 +1120,9 @@ enum mlx5_pcam_feature_groups {
=20
 enum mlx5_mcam_reg_groups {
 	MLX5_MCAM_REGS_FIRST_128                    =3D 0x0,
+	MLX5_MCAM_REGS_0x9080_0x90FF                =3D 0x1,
+	MLX5_MCAM_REGS_0x9100_0x917F                =3D 0x2,
+	MLX5_MCAM_REGS_NUM                          =3D 0x3,
 };
=20
 enum mlx5_mcam_feature_groups {
@@ -1268,7 +1271,16 @@ enum mlx5_qcam_feature_groups {
 	MLX5_GET(pcam_reg, (mdev)->caps.pcam, port_access_reg_cap_mask.regs_5000_=
to_507f.reg)
=20
 #define MLX5_CAP_MCAM_REG(mdev, reg) \
-	MLX5_GET(mcam_reg, (mdev)->caps.mcam, mng_access_reg_cap_mask.access_regs=
.reg)
+	MLX5_GET(mcam_reg, (mdev)->caps.mcam[MLX5_MCAM_REGS_FIRST_128], \
+		 mng_access_reg_cap_mask.access_regs.reg)
+
+#define MLX5_CAP_MCAM_REG1(mdev, reg) \
+	MLX5_GET(mcam_reg, (mdev)->caps.mcam[MLX5_MCAM_REGS_0x9080_0x90FF], \
+		 mng_access_reg_cap_mask.access_regs1.reg)
+
+#define MLX5_CAP_MCAM_REG2(mdev, reg) \
+	MLX5_GET(mcam_reg, (mdev)->caps.mcam[MLX5_MCAM_REGS_0x9100_0x917F], \
+		 mng_access_reg_cap_mask.access_regs2.reg)
=20
 #define MLX5_CAP_MCAM_FEATURE(mdev, fld) \
 	MLX5_GET(mcam_reg, (mdev)->caps.mcam, mng_feature_cap_mask.enhanced_featu=
res.fld)
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 1884513aac90..462c67e2dc13 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -686,7 +686,7 @@ struct mlx5_core_dev {
 		u32 hca_cur[MLX5_CAP_NUM][MLX5_UN_SZ_DW(hca_cap_union)];
 		u32 hca_max[MLX5_CAP_NUM][MLX5_UN_SZ_DW(hca_cap_union)];
 		u32 pcam[MLX5_ST_SZ_DW(pcam_reg)];
-		u32 mcam[MLX5_ST_SZ_DW(mcam_reg)];
+		u32 mcam[MLX5_MCAM_REGS_NUM][MLX5_ST_SZ_DW(mcam_reg)];
 		u32 fpga[MLX5_ST_SZ_DW(fpga_cap)];
 		u32 qcam[MLX5_ST_SZ_DW(qcam_reg)];
 		u8  embedded_cpu;
--=20
2.21.0

