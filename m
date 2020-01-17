Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD23140083
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 01:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387987AbgAQAHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 19:07:13 -0500
Received: from mail-eopbgr70079.outbound.protection.outlook.com ([40.107.7.79]:19560
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728982AbgAQAHL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 19:07:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OMKuYm0Qk98MuV1nXAd+CE0rDwyRqYLWXu/YFn2tVfMKOcrgkTpy5GqrsB7P+ld+kO/GZPTBvODio5sE+riwP1RBZeqew/i3G7dYks8ik5dbDje4kkqm+nk2HN5cNvPAIh45jEC2kmYOXavHnkeJMoiQ+wIMs973ZnDt0FD5WXepSCkeU2FZSYGZypSADp7ZuytOIaTLx2vPIq0jhrUFXVXUz8g6VvibB8mUm/G1lZX619xEM3AZcMgLroY7Mxd1U17iw+NNPHiTrECCdNZ2xhPpo3mBM6xoGRl0RkK22wPcfqmHdEKnW1iLbrDjiNQwkaJLkY3msejlHoOBIDG2pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6TJeBIfXvLc8lPYXMDGMBpVuzjlV+EaUmUBp1RKxCN4=;
 b=mLEMFbEjuuCUOSbWpTwdRUdrLflXdCuC0U0+JPWJbfcnbukG2vipTG3Wl+9+MzgXhOHs9kMbq9t0GDMEliuwDzMWVZCOx8ZAozdLD57Axqzd/t6kQ8xVuWpDTPPCQhESHtCFgrqhGNJFiSiX+VZPMx6TePH0toX7BK2X3rjssgvQkn1Mi+mLY7ZHI9qiSvEIexmLYdBQKWfr3QJV9zXzBzp6cTNiF57AR+YdtscBGvUNO9D6ELW31uAbHUDbBx318c66ABzIwj6eh+U3dCLjcm0y5sSw5F/htodwDwSJkh7uNeOwPvZjS5bPecd7qwc2Qx5UwH5fPvUrpg+9opN4FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6TJeBIfXvLc8lPYXMDGMBpVuzjlV+EaUmUBp1RKxCN4=;
 b=AZBbCrGa2HSq8tF6TWtR9sgrWZGPZWciITcCfIX5MW+wygKIRmY4lxXiGcbW1SpJsnANvvRNQYTiHwNVCOBAUnuyv+dD9BFFtlTBsB3bM4XF8ngY509pwGsS3WeF/JbBVGQVampANdPb9f04JXR4HpHdVTcTHtNyLugdLGBf0lg=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4990.eurprd05.prod.outlook.com (20.177.49.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Fri, 17 Jan 2020 00:07:06 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.015; Fri, 17 Jan 2020
 00:07:06 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR03CA0003.namprd03.prod.outlook.com (2603:10b6:a02:a8::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Fri, 17 Jan 2020 00:07:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [mlx5-next 07/16] net/mlx5e: Expose FEC feilds and related capability
 bit
Thread-Topic: [mlx5-next 07/16] net/mlx5e: Expose FEC feilds and related
 capability bit
Thread-Index: AQHVzMoNziFCttEWx0yW6PtaNyDX4Q==
Date:   Fri, 17 Jan 2020 00:07:05 +0000
Message-ID: <20200117000619.696775-8-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: d35ed17c-2141-4c57-2814-08d79ae12fe5
x-ms-traffictypediagnostic: VI1PR05MB4990:|VI1PR05MB4990:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4990579704475B610834579ABE310@VI1PR05MB4990.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-forefront-prvs: 0285201563
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(366004)(39860400002)(136003)(346002)(189003)(199004)(64756008)(6512007)(52116002)(66476007)(26005)(81166006)(86362001)(16526019)(316002)(81156014)(8676002)(2616005)(66556008)(186003)(6486002)(956004)(71200400001)(36756003)(508600001)(66446008)(54906003)(1076003)(5660300002)(2906002)(6506007)(4326008)(110136005)(8936002)(66946007)(107886003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4990;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LqwyQ+FMZkfstLdEqkkkgief5+cZb1Hes8CC6FwEdtoufoU3Sd7kPgQxJ8vquT3y3nFjxN7AEz6b8rNC059ZQj27clhRHkTrRfed26urWp/H8cWwo8xOH2AShnQXygi9TO6Oq46RoIs08e2TRjkcjgSNIQtofKf8/yJcMNItfExWPwbSYZ2QfkHqXfkRtpDy4sbnPyn0pg4b0vrYmtDVShBJXVCVKrBgV4frzi4WkO5l1pT/e6ket/NakNhq14akW0Zj6c6Tew7jbyesn1H7Zog1qrlVDcwDA1QRjLEJpFr8pBDWuFckYUFgg63/Q1W7lsOGyMROr/I5c28T2WAQyp32u+X4J/ApAwqOkcM9ujrfL3c8Yq06S8K1ba84+0yONfSGrytgGcovs7hwvldRQUrgWN1O0JFy7dXvg7L/IDCWUpASbikNTWiSh/oX/881ZTqGXGpN/iBRNIYvHFTghC2H3D47eC7hmKWygMFAKQUyZOgiMPFBsbMeQpNwbu47U1GUlnGnmXr0Mvh6kbASHggCbl0ys4MalTsZZIO2qls=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d35ed17c-2141-4c57-2814-08d79ae12fe5
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2020 00:07:05.9889
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tBT214+ex4Zj3S+eUxrSuHDpIwaqEPIybmQifJ4NqKTtJ++xa9vs6U7OBHdnYwyTowJtLQR9QDpNjNh5AGyQcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4990
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Introduce 50G per lane FEC modes capability bit and newly supported
fields in PPLM register which allow this configuration.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index e9c165ffe3f9..2ab4562b4851 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -8581,6 +8581,18 @@ struct mlx5_ifc_pplm_reg_bits {
 	u8	   fec_override_admin_50g[0x4];
 	u8	   fec_override_admin_25g[0x4];
 	u8	   fec_override_admin_10g_40g[0x4];
+
+	u8         fec_override_cap_400g_8x[0x10];
+	u8         fec_override_cap_200g_4x[0x10];
+
+	u8         fec_override_cap_100g_2x[0x10];
+	u8         fec_override_cap_50g_1x[0x10];
+
+	u8         fec_override_admin_400g_8x[0x10];
+	u8         fec_override_admin_200g_4x[0x10];
+
+	u8         fec_override_admin_100g_2x[0x10];
+	u8         fec_override_admin_50g_1x[0x10];
 };
=20
 struct mlx5_ifc_ppcnt_reg_bits {
@@ -8907,7 +8919,9 @@ struct mlx5_ifc_mpegc_reg_bits {
 };
=20
 struct mlx5_ifc_pcam_enhanced_features_bits {
-	u8         reserved_at_0[0x6d];
+	u8         reserved_at_0[0x68];
+	u8         fec_50G_per_lane_in_pplm[0x1];
+	u8         reserved_at_69[0x4];
 	u8         rx_icrc_encapsulated_counter[0x1];
 	u8	   reserved_at_6e[0x4];
 	u8         ptys_extended_ethernet[0x1];
--=20
2.24.1

