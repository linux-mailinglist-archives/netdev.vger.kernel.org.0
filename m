Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10DE8758EE
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 22:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbfGYUgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 16:36:42 -0400
Received: from mail-eopbgr20081.outbound.protection.outlook.com ([40.107.2.81]:36366
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726195AbfGYUgk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 16:36:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d0QQ4sfnkHc9r9yTlLSEa5Vx5zVhwH5B11LapufxU4ZtCE6sD4nRBsf1UMNxwrJjC+hGsn4Bw9BIoZEJwavTNCArQIeJnhwrUARPNW9YJyn5RuX8h9NCX9vqq9JF7i/1wfP4Z1f3i0IqarkPKM/fl4kwvXA3+YRf+dslbqU3Bx5tffnrmpNDDXQ5GQYheOeWnJlloW3+ibKofENnMJtZuGfpZnn6LGGR+i+g6baMG0BbDk3TBfTb0MbrwSXJ7CDb+LjD0ripQYOyWQ/FsN+8AV/H5Gioc4RpwO5XJaFPvJisZbYl2+b0kUZYIGlGtxYOL2R4WxKx6uXnnh1hqJbn4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y2Ks1EVp7mWoKiBW0P7WvMSC08JF16ggUzoxD0IFS98=;
 b=ahFKTqgs84rMK7el+MvwLtZcjtxHJvWu79itC/oCcqZtNfy1Yf4ZhuBjT0SFVJm6l5n19g0OGyvz+ccYnFziD2V5ASgU807F59h/CrbWHQQH0DD6DnjD8Wy4Jnqu/fgrm6z0GHcNjTzAomzQk/AvyeXCF7CR2ysf8UmMFgEV+lk7JBw3NpP5kYwPi2QIK1Gays90O/pmYZl5fQ3Ya78d18MZA4zARJRBE+RFUMyQcoY2w/d1lNB7nFZESSFMMnvHgSo52iUeXRSA7ErKZJ45k622qWeMeFH+UjxnPRwbe5lgUTu58caas2pSUPijaZxu4+IO12LWAVGwjMWunq5ykQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y2Ks1EVp7mWoKiBW0P7WvMSC08JF16ggUzoxD0IFS98=;
 b=Fap8K8ohqA1I/49xgIWL65d8Jx1/+1hQYmW1yHgyKo9oghwMbD30HLR2BTJfC0f70h+1CDu9MfX2JMSOpFy5d5TTiCzaV+lbP574PjRHPUxLieaaTbIAXUk0gHzGA7qlBfvu+vY3kstEvhk+aoCke4HRVgRWJC/TMAW24RcLsUc=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2504.eurprd05.prod.outlook.com (10.168.76.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Thu, 25 Jul 2019 20:36:37 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Thu, 25 Jul 2019
 20:36:37 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 2/9] net/mlx5: Add missing RDMA_RX capabilities
Thread-Topic: [net 2/9] net/mlx5: Add missing RDMA_RX capabilities
Thread-Index: AQHVQyiowEFKQlAxrEyH38snockIKg==
Date:   Thu, 25 Jul 2019 20:36:37 +0000
Message-ID: <20190725203618.11011-3-saeedm@mellanox.com>
References: <20190725203618.11011-1-saeedm@mellanox.com>
In-Reply-To: <20190725203618.11011-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0042.namprd02.prod.outlook.com
 (2603:10b6:a03:54::19) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b0c8e6a-a2bb-437c-67e8-08d7113fca90
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2504;
x-ms-traffictypediagnostic: DB6PR0501MB2504:
x-microsoft-antispam-prvs: <DB6PR0501MB2504C9D04A31D11D30A1C159BEC10@DB6PR0501MB2504.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(189003)(199004)(2906002)(6512007)(25786009)(305945005)(81166006)(7736002)(8936002)(53936002)(71190400001)(107886003)(476003)(6436002)(2616005)(50226002)(186003)(52116002)(1076003)(71200400001)(386003)(99286004)(6506007)(6116002)(36756003)(14444005)(256004)(81156014)(478600001)(316002)(446003)(11346002)(64756008)(86362001)(66446008)(14454004)(6916009)(8676002)(66946007)(66476007)(4326008)(54906003)(68736007)(66556008)(26005)(76176011)(6486002)(66066001)(486006)(5660300002)(102836004)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2504;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QFLf98Oqj39I/WBdwl86Pi6i5Q+MD+kPpVFL/zC2OZfAcEr7lMUfD0+fBolvbuBlLdcALCYJCR0gOYxZ8qJ+N+2YzW73TfTzwFYFSfe0dm2UB4Ti3CKYyV57etNzb8togriDLVxc+6WNoXekfcGoFXsTRWcJpyFzHkAUrKbY/Nn+q9EEg3pRQi25jG+sVQfiz94turiU+Q4koVV5NqS0lDLTBb7zs/rM6StMX5S8JSjKhKUGPy47myED/P3b3VQ0TuhTav7ExZYR3icWA54AS/HknuLRN0+P4RxajgGWp9mFwnxRkDhaA9RmtlWHhcAc//OcP623k/VaMjJUz025THw9oL49L2FyZuIr3HWVgpKOzQNoSk77rHRf46qK/2j1wNBUg5W3xdG53NV9+xRSyCxhZPr93Fc1A1uXNjiokPk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b0c8e6a-a2bb-437c-67e8-08d7113fca90
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 20:36:37.7146
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2504
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

New flow table type RDMA_RX was added but the MLX5_CAP_FLOW_TABLE_TYPE
didn't handle this new flow table type.
This means that MLX5_CAP_FLOW_TABLE_TYPE returns an empty capability to
this flow table type.

Update both the macro and the maximum supported flow table type to
RDMA_RX.

Fixes: d83eb50e29de ("net/mlx5: Add support in RDMA RX steering")
Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/fs_core.h
index c48c382f926f..c1252d6be0ef 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -68,7 +68,7 @@ enum fs_flow_table_type {
 	FS_FT_SNIFFER_RX	=3D 0X5,
 	FS_FT_SNIFFER_TX	=3D 0X6,
 	FS_FT_RDMA_RX		=3D 0X7,
-	FS_FT_MAX_TYPE =3D FS_FT_SNIFFER_TX,
+	FS_FT_MAX_TYPE =3D FS_FT_RDMA_RX,
 };
=20
 enum fs_flow_table_op_mod {
@@ -275,7 +275,8 @@ void mlx5_cleanup_fs(struct mlx5_core_dev *dev);
 	(type =3D=3D FS_FT_FDB) ? MLX5_CAP_ESW_FLOWTABLE_FDB(mdev, cap) :		\
 	(type =3D=3D FS_FT_SNIFFER_RX) ? MLX5_CAP_FLOWTABLE_SNIFFER_RX(mdev, cap)=
 :		\
 	(type =3D=3D FS_FT_SNIFFER_TX) ? MLX5_CAP_FLOWTABLE_SNIFFER_TX(mdev, cap)=
 :		\
-	(BUILD_BUG_ON_ZERO(FS_FT_SNIFFER_TX !=3D FS_FT_MAX_TYPE))\
+	(type =3D=3D FS_FT_RDMA_RX) ? MLX5_CAP_FLOWTABLE_RDMA_RX(mdev, cap) :		\
+	(BUILD_BUG_ON_ZERO(FS_FT_RDMA_RX !=3D FS_FT_MAX_TYPE))\
 	)
=20
 #endif
--=20
2.21.0

