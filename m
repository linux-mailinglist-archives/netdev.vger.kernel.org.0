Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D39A0BC50E
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 11:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504329AbfIXJmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 05:42:08 -0400
Received: from mail-eopbgr50054.outbound.protection.outlook.com ([40.107.5.54]:10630
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2504288AbfIXJmI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 05:42:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hYPWh+MxymVAKG1swgwD31Zzh3fUcfUM54zw46YlstTkrR7XykQKCTXgJXq3nNVc5M3Aa7AytslpG/jpD5p/xLPwXFNYV17U7nKmTYR60pBmvuyGhdV4PhZWY7LkfNp/G8+bJdXpQPVCuekIJoeBWUKXs8BHXWYlPWyx/4NUBzr9S+V0CUEDPLptZvth25hOhOtpdtET6NM4FR9dm2HbwQvxak9Co7JvBYdMt1tHOPa9y++RYDPxYVZ+3Ku/Tjtb8vrswgRLkiTx7Q6oyH73+FlATiiyA2J1vmzuHXkuqBDUafDaPm8zeF80OB6ESqD3/8o6lm+lAKNOVNl9ZsxhqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b19HwK1yIGf0PJaam75FjC+JAV9VBnI1EKtEkeo6OpI=;
 b=PorNLbh7bsNvkgZ2CvPryGtDz0CjeK7QJDyo1XR6VfL69lATYtzGX+BFYhUenkIuQx083g6etvHB2zz6JCPeVvzGvOq+1KqNhonVHgruMlteafNxWCw0OMKmm2M1oeUwftTxuLkd9BuZIKBonmCDIrnIEdoTzsbLt+fmGUgcR4aj56Jh4HiawKyP0YT6AU3jMGuY46IV59wqQH0whaQQkcqOM8UXUL0JPyWXQHv51b8zVOMryFu80qiQpueaxqR8NUZ3eZBL6EFuQ42yu1EcAmtxrbFZNek/QJlVXJoSvHcmiMsM6/sa+1pjA0C8UyMYzwm5Ty3biNQwQIU3jXZhcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b19HwK1yIGf0PJaam75FjC+JAV9VBnI1EKtEkeo6OpI=;
 b=kNbOW2fQK8i/Cy6zG21kjavGr8m8j4evtpFQydOiqJH676+Vb0nIUehWiut4QqFVd75qzqRp4kiqpepiiBskufrKLxFYCv3u/9TZ4cO5zbe6J00wPZyDV5Bymo0mjw1B7dDdynUn09JNYxzSsOfJY2SAbke9pJ6nKN2AGPX2ZDY=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2671.eurprd05.prod.outlook.com (10.172.14.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.21; Tue, 24 Sep 2019 09:41:23 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9%5]) with mapi id 15.20.2284.023; Tue, 24 Sep 2019
 09:41:23 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 1/7] net/mlx5: DR, Fix SW steering HW bits and definitions
Thread-Topic: [net 1/7] net/mlx5: DR, Fix SW steering HW bits and definitions
Thread-Index: AQHVcrw5Jx2zO9KQsUC2Ui6YLyCnVA==
Date:   Tue, 24 Sep 2019 09:41:22 +0000
Message-ID: <20190924094047.15915-2-saeedm@mellanox.com>
References: <20190924094047.15915-1-saeedm@mellanox.com>
In-Reply-To: <20190924094047.15915-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [193.47.165.251]
x-clientproxiedby: BYAPR03CA0031.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::44) To VI1PR0501MB2765.eurprd05.prod.outlook.com
 (2603:10a6:800:9a::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: de273d1d-c1bc-4c7b-44e3-08d740d35c35
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0501MB2671;
x-ms-traffictypediagnostic: VI1PR0501MB2671:|VI1PR0501MB2671:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB267144E063F52D2DBFDED638BE840@VI1PR0501MB2671.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0170DAF08C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(189003)(199004)(386003)(256004)(6512007)(186003)(6116002)(3846002)(50226002)(99286004)(36756003)(25786009)(107886003)(486006)(6436002)(102836004)(52116002)(26005)(76176011)(8676002)(4326008)(316002)(81156014)(81166006)(2616005)(54906003)(476003)(11346002)(6916009)(6506007)(86362001)(1076003)(5660300002)(66476007)(2906002)(66556008)(6486002)(66446008)(64756008)(66946007)(14454004)(478600001)(305945005)(7736002)(66066001)(71190400001)(446003)(71200400001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2671;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: DksoFyj3Rw+yIQJ3952YeskMT+JbMFcog8CBY0vRLRmEH+RKYW1vY614H5yfXPdsXmhFA6YMJ3A0bW+1rL9Q/RjKYo+929vV0GKSZzxTmqPnWkIHYz6NKRdD+M+Kn4OArMU+eaw1slQtAfkZ+CCCodlwN/PBugYm4XeY+mzffwE2wgYZ15bYYRq3VAR4u1HG7MnJkauDFe4CT+07RBUl1R65uv8jpaTQUgCzkD5QoiWq6Fh4zzACQa8i2CniUmFKWgp1ofePaMZ9ohToKYxm0GwuRi3O/lF/KmAfZzoy/PsVfrf6XS1wSrUWwBHntvXT7EhN22vwUZSx8A0uJjc0VkDdn8tl34C/ceIJG+gaLxItCbB8BuXydbxMrKArDy9xXhTSD3ig84l1iff+WA3AU5Wr9U/bct59C7aRmiI4+u0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de273d1d-c1bc-4c7b-44e3-08d740d35c35
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2019 09:41:23.0084
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NCEYz+/TphvBC5nQu4H5lOfDwaU34geT4i8vNCYEUg9Bs0K9iuS3HNxBVZy2qF7k6/hGzY54xUE5CWk0Rx8ikg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2671
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@mellanox.com>

Fix wrong reserved bits offsets.

Fixes: 97b5484ed608 ("net/mlx5: Add HW bits and definitions required for SW=
 steering")
Signed-off-by: Yevgeny Kliteynik <kliteyn@mellanox.com>
Reviewed-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index a487b681b516..138c50d5a353 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -282,7 +282,6 @@ enum {
 	MLX5_CMD_OP_ALLOC_MODIFY_HEADER_CONTEXT   =3D 0x940,
 	MLX5_CMD_OP_DEALLOC_MODIFY_HEADER_CONTEXT =3D 0x941,
 	MLX5_CMD_OP_QUERY_MODIFY_HEADER_CONTEXT   =3D 0x942,
-	MLX5_CMD_OP_SYNC_STEERING                 =3D 0xb00,
 	MLX5_CMD_OP_FPGA_CREATE_QP                =3D 0x960,
 	MLX5_CMD_OP_FPGA_MODIFY_QP                =3D 0x961,
 	MLX5_CMD_OP_FPGA_QUERY_QP                 =3D 0x962,
@@ -296,6 +295,7 @@ enum {
 	MLX5_CMD_OP_DESTROY_UCTX                  =3D 0xa06,
 	MLX5_CMD_OP_CREATE_UMEM                   =3D 0xa08,
 	MLX5_CMD_OP_DESTROY_UMEM                  =3D 0xa0a,
+	MLX5_CMD_OP_SYNC_STEERING                 =3D 0xb00,
 	MLX5_CMD_OP_MAX
 };
=20
@@ -487,7 +487,7 @@ union mlx5_ifc_gre_key_bits {
=20
 struct mlx5_ifc_fte_match_set_misc_bits {
 	u8         gre_c_present[0x1];
-	u8         reserved_auto1[0x1];
+	u8         reserved_at_1[0x1];
 	u8         gre_k_present[0x1];
 	u8         gre_s_present[0x1];
 	u8         source_vhca_port[0x4];
@@ -5054,50 +5054,50 @@ struct mlx5_ifc_query_hca_cap_in_bits {
=20
 struct mlx5_ifc_other_hca_cap_bits {
 	u8         roce[0x1];
-	u8         reserved_0[0x27f];
+	u8         reserved_at_1[0x27f];
 };
=20
 struct mlx5_ifc_query_other_hca_cap_out_bits {
 	u8         status[0x8];
-	u8         reserved_0[0x18];
+	u8         reserved_at_8[0x18];
=20
 	u8         syndrome[0x20];
=20
-	u8         reserved_1[0x40];
+	u8         reserved_at_40[0x40];
=20
 	struct     mlx5_ifc_other_hca_cap_bits other_capability;
 };
=20
 struct mlx5_ifc_query_other_hca_cap_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_0[0x10];
+	u8         reserved_at_10[0x10];
=20
-	u8         reserved_1[0x10];
+	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
=20
-	u8         reserved_2[0x10];
+	u8         reserved_at_40[0x10];
 	u8         function_id[0x10];
=20
-	u8         reserved_3[0x20];
+	u8         reserved_at_60[0x20];
 };
=20
 struct mlx5_ifc_modify_other_hca_cap_out_bits {
 	u8         status[0x8];
-	u8         reserved_0[0x18];
+	u8         reserved_at_8[0x18];
=20
 	u8         syndrome[0x20];
=20
-	u8         reserved_1[0x40];
+	u8         reserved_at_40[0x40];
 };
=20
 struct mlx5_ifc_modify_other_hca_cap_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_0[0x10];
+	u8         reserved_at_10[0x10];
=20
-	u8         reserved_1[0x10];
+	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
=20
-	u8         reserved_2[0x10];
+	u8         reserved_at_40[0x10];
 	u8         function_id[0x10];
 	u8         field_select[0x20];
=20
--=20
2.21.0

