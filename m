Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B91B79AC0
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388470AbfG2VNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:13:17 -0400
Received: from mail-eopbgr10050.outbound.protection.outlook.com ([40.107.1.50]:5933
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387803AbfG2VNR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 17:13:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hteXCrKIFq0Gy6wFppLXkaAjzgHvbH/pJEnTW2qkKqMqUyEB4fXiD49+lIPcn7LZ8CSgGeucBtWVPg/r8FEQ8ZjZoXwuh1/WDsaieWQGQzO8BFDijK1E0H+8KEaB3ATI9MjRFImgdn7dFjhwuXr5GBkIEA6rY1r0moxXtEmDSvA+9CGrd7l0ZValQQhVLjuGVfV+MrBxlJ7aA62IsIBDppVTMt6eM+D8QyvT/wUnPF/u6/dWEQgp/SM4hv6igIU/YzEJ1ys1MRn3EbiYWx4zig0WYtFUfZfCYAZU49X1RufATkt0YP5exz+S6XtehQHO9oMwQoUE+dGSUNNPW54jmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aa7SrWt4Izf5ymGltyfrSyvzDbJcO4Z5hiwC/1R2fpI=;
 b=QcjT+YaQSW+74OUqc+huM2Nzwo6m5e2ZFomSwLLyQjs7ReTlJodDtVQZ4xgKpSo3x1nlfikkCOqAQVc3RtypFer7zlqQ8DVEhItcs+MyyYgU8pGyPCkJOUFp+QOCNBQFzg4PtUJah7tWY4wS5pzsmL0pHZ+rrMcdhfLEgYZGElXckGmHr7pL73lj5bTKlPylYFLE5GCaPDFA0OQRFgMjMX57UQDqHAZIo+JamvqMY9dXyElG+/Bkg6NCZcrCqo2aFC0xeuljYfZ/fTiX90ZDlkcpkq9UDIT8wBfNqyhjPAPztqKxyO0ErHP6AU8dMW9lwaOwMRPuUAvSBX+1I2bcTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aa7SrWt4Izf5ymGltyfrSyvzDbJcO4Z5hiwC/1R2fpI=;
 b=ewirsGBQX6qOle95+eRCxG31WNe/pDM+oPTKtlg6XckSKcSZEXS6Dt3AaGTtmZtoawTVSXQMzmI0W0PtfXsrr1vDDFiudMHmOZDT8OsYOawDfl0SFrt4ZzaH4HM4jlZ0Fr/S1S3w/IUE9uCODFQvjAZTVehpVucTj59NcaAw8hE=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2375.eurprd05.prod.outlook.com (10.168.72.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Mon, 29 Jul 2019 21:13:00 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 21:13:00 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
CC:     Eli Cohen <eli@mellanox.com>, Paul Blakey <paulb@mellanox.com>
Subject: [PATCH mlx5-next 05/11] net/mlx5: E-Switch, Verify support QoS
 element type
Thread-Topic: [PATCH mlx5-next 05/11] net/mlx5: E-Switch, Verify support QoS
 element type
Thread-Index: AQHVRlJmWxzTFuXbIkyV0t86aZ45Yw==
Date:   Mon, 29 Jul 2019 21:13:00 +0000
Message-ID: <20190729211209.14772-6-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: e3d35eb0-af05-45ac-707c-08d71469892a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2375;
x-ms-traffictypediagnostic: DB6PR0501MB2375:
x-microsoft-antispam-prvs: <DB6PR0501MB2375C07670ACD8964A648993BEDD0@DB6PR0501MB2375.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1169;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(199004)(189003)(50226002)(14444005)(5660300002)(6116002)(3846002)(486006)(446003)(86362001)(81156014)(186003)(36756003)(81166006)(8936002)(26005)(25786009)(316002)(71190400001)(71200400001)(110136005)(54906003)(64756008)(76176011)(66556008)(2906002)(66946007)(66446008)(99286004)(66476007)(1076003)(386003)(6506007)(102836004)(256004)(7736002)(6486002)(14454004)(66066001)(2501003)(8676002)(305945005)(6436002)(4326008)(11346002)(68736007)(52116002)(2616005)(476003)(478600001)(6512007)(450100002)(2201001)(107886003)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2375;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LEtvU0tJ2rc4Twr8I1+drpf2lUCk6l/N/ZcIo6FYiOa7+lZGGYLQ8FCzDNflOXUkDs0O8275ts3bGtWkfZSMZeyFTSejlKY/qFz3UT1roboMQxsxLukFGDeQ6OsywOmdLt7xlXfTDneXdyUkKAWTUgNLJG4PDVQ0Lb6s/139r6G4HwsbUwUucoGkeu6pbHnr5RSmYUOko4zE63PHQ3MRmLPNawunou8/ZsjNpXnyQRepEd/cvAmdpzrwdadTVzqr3CNf1o9BtcMrFEjZm+C77BRsaNfghix8vtxAX34iB5Bo0djd+HjIQG+lDrzuqXOap7npaMq4/MYYa7FuYoAtYqof5NgFpE+6yg7DXtqYg4bVKYXPwr6Lkw6nm/qO3ZyaPFtZbhhYIc/YsKG5sFmeMTGFZnLBfN80hLVwWR96vxs=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3d35eb0-af05-45ac-707c-08d71469892a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 21:13:00.3115
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

From: Eli Cohen <eli@mellanox.com>

Check if firmware supports the requested element type before
attempting to create the element type.
In addition, explicitly specify the request element type and tsar type.

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 31 +++++++++++++++++++
 include/linux/mlx5/mlx5_ifc.h                 |  7 +++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 1f3891fde2eb..2927fa1da92f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1393,19 +1393,50 @@ static int esw_vport_egress_config(struct mlx5_eswi=
tch *esw,
 	return err;
 }
=20
+static bool element_type_supported(struct mlx5_eswitch *esw, int type)
+{
+	struct mlx5_core_dev *dev =3D esw->dev =3D esw->dev;
+
+	switch (type) {
+	case SCHEDULING_CONTEXT_ELEMENT_TYPE_TSAR:
+		return MLX5_CAP_QOS(dev, esw_element_type) &
+		       ELEMENT_TYPE_CAP_MASK_TASR;
+	case SCHEDULING_CONTEXT_ELEMENT_TYPE_VPORT:
+		return MLX5_CAP_QOS(dev, esw_element_type) &
+		       ELEMENT_TYPE_CAP_MASK_VPORT;
+	case SCHEDULING_CONTEXT_ELEMENT_TYPE_VPORT_TC:
+		return MLX5_CAP_QOS(dev, esw_element_type) &
+		       ELEMENT_TYPE_CAP_MASK_VPORT_TC;
+	case SCHEDULING_CONTEXT_ELEMENT_TYPE_PARA_VPORT_TC:
+		return MLX5_CAP_QOS(dev, esw_element_type) &
+		       ELEMENT_TYPE_CAP_MASK_PARA_VPORT_TC;
+	}
+	return false;
+}
+
 /* Vport QoS management */
 static int esw_create_tsar(struct mlx5_eswitch *esw)
 {
 	u32 tsar_ctx[MLX5_ST_SZ_DW(scheduling_context)] =3D {0};
 	struct mlx5_core_dev *dev =3D esw->dev;
+	__be32 *attr;
 	int err;
=20
 	if (!MLX5_CAP_GEN(dev, qos) || !MLX5_CAP_QOS(dev, esw_scheduling))
 		return 0;
=20
+	if (!element_type_supported(esw, SCHEDULING_CONTEXT_ELEMENT_TYPE_TSAR))
+		return 0;
+
 	if (esw->qos.enabled)
 		return -EEXIST;
=20
+	MLX5_SET(scheduling_context, tsar_ctx, element_type,
+		 SCHEDULING_CONTEXT_ELEMENT_TYPE_TSAR);
+
+	attr =3D MLX5_ADDR_OF(scheduling_context, tsar_ctx, element_attributes);
+	*attr =3D cpu_to_be32(TSAR_ELEMENT_TSAR_TYPE_DWRR << 16);
+
 	err =3D mlx5_create_scheduling_element_cmd(dev,
 						 SCHEDULING_HIERARCHY_E_SWITCH,
 						 tsar_ctx,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 9265c84ad353..30d15e80bcc7 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -2957,6 +2957,13 @@ enum {
 	SCHEDULING_CONTEXT_ELEMENT_TYPE_PARA_VPORT_TC =3D 0x3,
 };
=20
+enum {
+	ELEMENT_TYPE_CAP_MASK_TASR		=3D 1 << 0,
+	ELEMENT_TYPE_CAP_MASK_VPORT		=3D 1 << 1,
+	ELEMENT_TYPE_CAP_MASK_VPORT_TC		=3D 1 << 2,
+	ELEMENT_TYPE_CAP_MASK_PARA_VPORT_TC	=3D 1 << 3,
+};
+
 struct mlx5_ifc_scheduling_context_bits {
 	u8         element_type[0x8];
 	u8         reserved_at_8[0x18];
--=20
2.21.0

