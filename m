Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B72AB14007E
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 01:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387494AbgAQAHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 19:07:01 -0500
Received: from mail-eopbgr70079.outbound.protection.outlook.com ([40.107.7.79]:19560
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730092AbgAQAHA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 19:07:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cXZpVKZ/ybfJ725vwecyZLe63+jjXy84yKmbXT3lej0vXPpi7C8f+l9jQQ4QRbMihIHzL/qtl8FUfxbs+frAezLeTA+TIiHKFkt9aTEXjGQ2QP/0YU/46GOloOBKZMF2gKAF7Ehd/7ROO5geE1X0n8BllehTMDJHOamSa9qs9s4FzpWaUu2kt8O3m16YVdBXINoaFz/lyAk0NtGw+lkow4aCRKIGmhVwBInVZO6gYzSAmpEYn7OEjv2fiMEDlVVip1Y6STWPAfe/mhqEXfYeH9X1f6lEsw3I3lGFkNeBMgZGDA8A1NsptJCFqzhyqnUgYtqw7abfkBIHYxtgDJuOCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BW3wELKYBJChFG+VLKLBOXkE9Ujwar4X/rKsqzKHAlg=;
 b=D+Wy1cs7YKTHKWO85NyIIUzi3p5EOUORx6U41SPjuWDkUuRVSYxUBR8uLcy3uY8yqwrJkiaJvGV88WvsCX3sZ1BDmT3FDPPOFEaG7Tj7IekUj19a70kEfPx9wGY05z3hePbHygdnG6SLyNhRR3WIau9+zrSrtNNeoRHtsG/HxKxvYSy4rSaolwN71tut3JDw5Z5e/6bgvyJdElyyeyHwyxbRNb5GCJXyWgwkzlN6xCcO5c60i9FAYdB/12rQbVby9fWepMhB4Obe3FkqajeBNErldHSZfYxusQFEOtODB3KkTFhrEAg2EMGVLVBEDYIireqUGQjEYN0QhWc+/jhzLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BW3wELKYBJChFG+VLKLBOXkE9Ujwar4X/rKsqzKHAlg=;
 b=RhbB6gBlZypEZgbwuBLepZiBAy+PaII5uPJGMa90hJJZhulyD52osIS5YxuMH4I7cL01C/jFtLb6ssw4z3WMQVqbvAUQZQ/hhj2OBY0LN115mUABAOzC5CYC2mlKqFCs553OtVhh84F3bApU4tEu3Czs9W5slxVvW0m584ahTtk=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4990.eurprd05.prod.outlook.com (20.177.49.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Fri, 17 Jan 2020 00:06:55 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.015; Fri, 17 Jan 2020
 00:06:55 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR03CA0003.namprd03.prod.outlook.com (2603:10b6:a02:a8::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Fri, 17 Jan 2020 00:06:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [mlx5-next 02/16] net/mlx5: Read MCAM register groups 1 and 2
Thread-Topic: [mlx5-next 02/16] net/mlx5: Read MCAM register groups 1 and 2
Thread-Index: AQHVzMoHB+6IwMMAWECyO53oRZfq4A==
Date:   Fri, 17 Jan 2020 00:06:55 +0000
Message-ID: <20200117000619.696775-3-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 26298ed5-73f6-4ce8-8b51-08d79ae12989
x-ms-traffictypediagnostic: VI1PR05MB4990:|VI1PR05MB4990:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4990D473A71B8A3B9E9D678CBE310@VI1PR05MB4990.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 0285201563
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(366004)(39860400002)(136003)(346002)(189003)(199004)(64756008)(6512007)(52116002)(66476007)(26005)(81166006)(86362001)(16526019)(316002)(81156014)(8676002)(2616005)(66556008)(186003)(6486002)(956004)(71200400001)(36756003)(508600001)(66446008)(54906003)(1076003)(5660300002)(2906002)(6506007)(4326008)(110136005)(8936002)(66946007)(107886003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4990;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HnAQ0xdl7iScEzmZdLq2Au3fSl0YYYCBuX5N4qZ6mIN8kdEc8T9JfTXtL0Kf22LO5R9zcnzIE8OerWsvr5kTxuAyeq8RRH8YAbnU8Q+5bae5lcX+kIvwR6bJAzT6YZ3rWpKQghsmsf1Do1WcNS1RSDnm6j1VEVSgmxIDIrvYP+V25NfrXOLnrkoTa1r0KPdpP6A2W98q1C5m1uIxJNJ0j2S7PkUjuRnuEBANRDtb93jgTRtT5iRYI7f6HXtP7DVXjVuhWPdBNnhczINS1yGmD8M0I+fz/ECV7By5zPhLWHsG2ZHubBju33QeNmMnB+/9fjfjh2y+Kdv/OYGOqmjEKmQgn4teoleHXJAwu/+ioHQcTskIRw09L7jDrqPnL26V2t7saOZOreymanYofTJyX6BtA07br2qgpwLCHP+GAyVNpvRYqnFp7lum3pJ+uNrzxhRtQMSwwmh4P1wQ/FFmDYJiApCGR9/fPrKvmyLPGcSRlRY6M69iFKQQLiHilD6OKQCUa/t+O9PRMcBOolqQEUrMF0v/Gj+tiYpANO/p4jk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26298ed5-73f6-4ce8-8b51-08d79ae12989
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2020 00:06:55.4601
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kT5oR6xxrztfCnvXm67ou/+g1F6ggSyW2XZnEYltapBtXvqtyRveHAyuPqdRki4Ac4KJn4q6KX+L1WqTvLIweQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4990
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

On load, Driver caches MCAM (Management Capabilities Mask Register)
registers. in addition to the only MCAM register group (0) the driver
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
index c375edfe528c..d89ff1d09119 100644
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
index 1a1c53f0262d..0e62c3db45e5 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1121,6 +1121,9 @@ enum mlx5_pcam_feature_groups {
=20
 enum mlx5_mcam_reg_groups {
 	MLX5_MCAM_REGS_FIRST_128                    =3D 0x0,
+	MLX5_MCAM_REGS_0x9080_0x90FF                =3D 0x1,
+	MLX5_MCAM_REGS_0x9100_0x917F                =3D 0x2,
+	MLX5_MCAM_REGS_NUM                          =3D 0x3,
 };
=20
 enum mlx5_mcam_feature_groups {
@@ -1269,7 +1272,16 @@ enum mlx5_qcam_feature_groups {
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
index 59cff380f41a..dc3c725be092 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -684,7 +684,7 @@ struct mlx5_core_dev {
 		u32 hca_cur[MLX5_CAP_NUM][MLX5_UN_SZ_DW(hca_cap_union)];
 		u32 hca_max[MLX5_CAP_NUM][MLX5_UN_SZ_DW(hca_cap_union)];
 		u32 pcam[MLX5_ST_SZ_DW(pcam_reg)];
-		u32 mcam[MLX5_ST_SZ_DW(mcam_reg)];
+		u32 mcam[MLX5_MCAM_REGS_NUM][MLX5_ST_SZ_DW(mcam_reg)];
 		u32 fpga[MLX5_ST_SZ_DW(fpga_cap)];
 		u32 qcam[MLX5_ST_SZ_DW(qcam_reg)];
 		u8  embedded_cpu;
--=20
2.24.1

