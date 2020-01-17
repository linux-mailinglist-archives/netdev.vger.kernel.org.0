Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6B514007D
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 01:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387444AbgAQAG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 19:06:59 -0500
Received: from mail-eopbgr70079.outbound.protection.outlook.com ([40.107.7.79]:19560
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728982AbgAQAG6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 19:06:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ijyEGgpE1YPO+I0BQSAiaAPRk4vxDwPgdfUkZ5pyyvfQFZhzjKSROjAdwLbFvb1vc1LmCv/2mEbWwrxMu9RFa2VxQfpxMBWQVaokJ81Rore5Q3pOwHCcvSmihYOhzSUsO7AzZ5LEvWnh3Jbm80dWz/4dI4ksjbwiF36Iic8XtRVwUH/4Qo1JKEZX59yeFONopGHZMTt3ttXLHVCeKU15OuOoe5h+H0ekgD+WLAj3ISKCF3/xh3bQbN4ygtRpBbXnH/V8rzCnLNnIxBDoTGwA+5k7dvGq3unHnUWVFZSC1DGFYbCh5NOs8mb3lOIojhFaKD07BNq+LRD9QSCAhV0POg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rh4Dv7FmfNA+TY07u9XwmaQ5E/6rBg6vJ6/4K6dYl9k=;
 b=T3L3IO03s+P3dffguXE8xsGbCPIls9gcsz5Hsc/fDdRj9ubvUO0Q/Ou6slx7XP7tm6mO70yUBuLewSO8TqTXNyz9c29rAIRIGjGNFVyS0cqVUFbr6yGJownoxFA2WKTr8JF4OEblGPZN6sYa8RvQKFdvaZD9zlGSzj6f9ioM6KTZfdLZGN9cPN6RE7vhap1U4PzV0wf4NNQa1bHeq7bc5ZhuuBlSEEdkv9hDYtnkCd7VrJQ2EVK7sGHfTwrQSWVwePWeXNJ770YBHLi376RG2H4EGUv1oFuqMU0Buu1QWFh1u8cON3md3UhA34eChKz3wLG8BSNuakSVUqjxCuq6XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rh4Dv7FmfNA+TY07u9XwmaQ5E/6rBg6vJ6/4K6dYl9k=;
 b=JxDuCtI1Ts7QV9ubkhyM4w+gkyN5IIFlqmHfTeR7913joZJ5/dWyeIyTvSVUkvu/pG6EsCJI6bY7QggHwh/u+LDrSKWqA+QKlcmC3jbCmdSnkQXniTrT0J3lWiSCh6q7lynX3WcMo0G2nEv/taaNsvxmi8fnkBCLRn/QVpEZtmk=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4990.eurprd05.prod.outlook.com (20.177.49.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Fri, 17 Jan 2020 00:06:53 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.015; Fri, 17 Jan 2020
 00:06:53 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR03CA0003.namprd03.prod.outlook.com (2603:10b6:a02:a8::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Fri, 17 Jan 2020 00:06:51 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [mlx5-next 01/16] net/mlx5: Add structures layout for new MCAM access
 reg groups
Thread-Topic: [mlx5-next 01/16] net/mlx5: Add structures layout for new MCAM
 access reg groups
Thread-Index: AQHVzMoFStSKZXIHDUa6Ux4tBEmGeg==
Date:   Fri, 17 Jan 2020 00:06:53 +0000
Message-ID: <20200117000619.696775-2-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: d6c4b7a2-3cfd-4dda-a4bf-08d79ae12833
x-ms-traffictypediagnostic: VI1PR05MB4990:|VI1PR05MB4990:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB499088762179A6538BC41B73BE310@VI1PR05MB4990.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-forefront-prvs: 0285201563
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(366004)(39860400002)(136003)(346002)(189003)(199004)(64756008)(6512007)(52116002)(66476007)(26005)(81166006)(86362001)(16526019)(316002)(81156014)(8676002)(2616005)(66556008)(186003)(6486002)(956004)(71200400001)(36756003)(508600001)(66446008)(54906003)(1076003)(5660300002)(2906002)(6506007)(4326008)(110136005)(8936002)(66946007)(107886003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4990;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wzd9gibKqmivF9ohoYOYQZFj/u5wLnSSuwhRRoGwaixOwsk6Wf967qbvs5yr8zBAoN0fHFjYeZ3NGGRwlwCRHrjx2AcFyio9O2cvPnt59BMlmX1VEYSMR39YakzYi87w2xkjm+B+ViKaR4bSJfmF4NwJf/VUSz6HvPdHrHoTwZIfcHwlQaLkGF6UA9GoA+OulGbeQc3zJGgK7jCufYV6zRI/sio9xAtz9fFZOmAHavm2h07Gmf0OSzAteVAQq//UpTFzktqhsRp5C8rBh1MQfHJcO3f7aA7NvB75TvMFK2TTbTtn8dOzrSddmVD6RZGdmQfq7TllOc2U+mG9uT4/xgX6hj1vO837v85IngCa1WHUVWlxtZ6j2U/28ZdGJsiKCsmBdnhOmblQ8jxC8xAD/ufSm7jI0t6GQ1EM5zx0mr1ms/V1XEAnKZDrtyG4lC1Sn1tMTbfpPZsZyOqx8B6pji+Ol8/qKfAtnKsMLm21DA0vK/7ilpWFdMhjiNdQkPPaOvlkN9WxeFYyPa3XpAVxnoPsENT0ZO3u3B38ZXbBpxk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6c4b7a2-3cfd-4dda-a4bf-08d79ae12833
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2020 00:06:53.2334
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wPzmPyNtv7U6vVF+7EEbYFt2OmJo5h61iyEwBwDwjs4YIU7ll9uCbsuLHNAxk8UN8+28ASnUAy6sQhnPMxiJ1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4990
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

MCAM has 3 access_reg_groups (0-2). Defines data structures in order to
read and parse access_reg_groups #1 and #2.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index c6abaf4f1c55..43cdf9211747 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -8832,6 +8832,28 @@ struct mlx5_ifc_mcam_access_reg_bits {
 	u8         regs_31_to_0[0x20];
 };
=20
+struct mlx5_ifc_mcam_access_reg_bits1 {
+	u8         regs_127_to_96[0x20];
+
+	u8         regs_95_to_64[0x20];
+
+	u8         regs_63_to_32[0x20];
+
+	u8         regs_31_to_0[0x20];
+};
+
+struct mlx5_ifc_mcam_access_reg_bits2 {
+	u8         regs_127_to_99[0x1d];
+	u8         mirc[0x1];
+	u8         regs_97_to_96[0x2];
+
+	u8         regs_95_to_64[0x20];
+
+	u8         regs_63_to_32[0x20];
+
+	u8         regs_31_to_0[0x20];
+};
+
 struct mlx5_ifc_mcam_reg_bits {
 	u8         reserved_at_0[0x8];
 	u8         feature_group[0x8];
@@ -8842,6 +8864,8 @@ struct mlx5_ifc_mcam_reg_bits {
=20
 	union {
 		struct mlx5_ifc_mcam_access_reg_bits access_regs;
+		struct mlx5_ifc_mcam_access_reg_bits1 access_regs1;
+		struct mlx5_ifc_mcam_access_reg_bits2 access_regs2;
 		u8         reserved_at_0[0x80];
 	} mng_access_reg_cap_mask;
=20
--=20
2.24.1

