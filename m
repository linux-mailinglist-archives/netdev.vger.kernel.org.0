Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AABFAAE13
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 23:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391050AbfIEVvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 17:51:31 -0400
Received: from mail-eopbgr150045.outbound.protection.outlook.com ([40.107.15.45]:23041
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390949AbfIEVv2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 17:51:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=anPWYANOyCORqWN38PWjIHrm/j8e2zFOqd4Bll17sCkh/4AJ5MLgQk5cMXTfl3x2DOQdaUy/GdwGSw7N4RIleJ5f1AZILAkUflrm6yeh1aTMPclXTfjaNt7PV3bA9sabEIu3R3hcZeUw1EjAsuJVpvoVZxK23pRc7yPnpO3ivio6TuZgddBhgvT7538kIDyCQ6bNNKKk1to48kv27PBUHybneboFdQw0Th1Zd0SCH4xSToPbIknqly5DrXYAUbkE1cXNJkQq515cfeCcjMHkjCd9jE5Elq2F/ZBZ27FUKEmmUl8BUMXhASrabNF2B688jz76tuNmezz9Rm1EhWgXFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Ppte+FYjzkLIK/um8eHkg04xR3ihyQw2GioCol8APA=;
 b=S8+9J1XmUjYjqSDfhPdOKFi5+PDH6m5+Wm4eOTpFVuzzMsZTc83d15PiMJmxetIiJnCZtB2yefH71ba+vfcbQSMDfZfHYe7DVTTY1R2C5qGkQqzCqtR6sXhsT1xieXC45DppDFbn9usDVqJyRhN3Vyx6CRAPRE3KG51QaAHS5jlZ7BH54RHxtXY9vW7i2/jgb5q9HM53XBoNnYYW+y4ROnudd+tDpHPirTTv4T53ycZ66fYBQd2NOoNSaBOP5caJsAXcej/wD9fAa/CO2UQQuFqpBskp74ZtnviyjrDcbsX0Hv4fctQoLz3YAMrcHOcbYcLMCNlHaGItrFlfhY70tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Ppte+FYjzkLIK/um8eHkg04xR3ihyQw2GioCol8APA=;
 b=ZDf96AMRT1/RMKA2BLriL94iHkSr9oiNq9/WAHKXTHuLFg2KVZEpS4tPr2vXP5mlh9xDrQLBHE76AmKpMplMe9q9bn8R+hR/MG3FEUBc88GOZr6SxyzAl0Bh5s7T9pbAgw9CF5BAPh+NPMASrRGbKorg53UkLhIkJ6L4+WxHjtY=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2768.eurprd05.prod.outlook.com (10.172.81.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Thu, 5 Sep 2019 21:51:18 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9%5]) with mapi id 15.20.2220.022; Thu, 5 Sep 2019
 21:51:18 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 13/14] net/mlx5: Expose HW capability bits for port buffer
 per priority congestion counters
Thread-Topic: [net-next 13/14] net/mlx5: Expose HW capability bits for port
 buffer per priority congestion counters
Thread-Index: AQHVZDQMDJ+uILItMk6CSCgz3VIBMQ==
Date:   Thu, 5 Sep 2019 21:51:18 +0000
Message-ID: <20190905215034.22713-14-saeedm@mellanox.com>
References: <20190905215034.22713-1-saeedm@mellanox.com>
In-Reply-To: <20190905215034.22713-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0023.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::36) To VI1PR0501MB2765.eurprd05.prod.outlook.com
 (2603:10a6:800:9a::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 842d2290-0358-468b-baa7-08d7324b2e92
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0501MB2768;
x-ms-traffictypediagnostic: VI1PR0501MB2768:|VI1PR0501MB2768:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB27683B37F7A6F72E48FC7FA7BEBB0@VI1PR0501MB2768.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:935;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(199004)(189003)(478600001)(86362001)(14454004)(446003)(486006)(2616005)(11346002)(7736002)(256004)(6916009)(305945005)(71190400001)(71200400001)(102836004)(476003)(6506007)(66066001)(6512007)(386003)(2906002)(81156014)(52116002)(66476007)(66446008)(3846002)(36756003)(316002)(6436002)(53936002)(54906003)(107886003)(66946007)(8936002)(4326008)(64756008)(99286004)(81166006)(26005)(8676002)(186003)(5660300002)(50226002)(25786009)(6116002)(1076003)(6486002)(66556008)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2768;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TuvQrMJTcTIV/lAokDzBbOVuMXvXWGDuYwAbhUE/cmxiZjOCUGS78qgl+y2JH4NgZUIoXrh/yw9sEl/jrfX3GfksXNTsthSaqqqWr4/mngE3LJFa3XuGGKnIcSye4Cj06qrJuUMkGlP9veyZxDd5ktyOaagwXwLgw14RvvzNp+0JFKwd9E4aFl7mF0s3nvHX3u2SCVk+JJYVEZRJcddGeO50laL35pi1LjID46GyWMMbFE/02vp6GiRipt3NUpfywZShqbnRlGVo9YdwtXm0rQviWFLfcUVcBhfkz4zbDHnN5WebF8pLcFzmk2tkoLEvbrZRErzV0o9cF3Ls5tu3o3XgH2VW7vExi96A5BRbkCdk2z49kwkCf+fFL4InUisvq/rXDBSF4uGGmHSHtuj6WrL1Z0Dv3sFFStIE21ceEDE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 842d2290-0358-468b-baa7-08d7324b2e92
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 21:51:18.4522
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9RC1fsmaRY2L6NxsnuZ/H3uXeFadMy9FH2QriNCG17fJN2Ol4U6VWpBpzjbeiujqCYysNYISNq3VoRnEesdjww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2768
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Map capability bit indicating that HCA supports port buffer's congestion
counters. Also map registers with the corresponding counters.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/device.h   |  1 +
 include/linux/mlx5/mlx5_ifc.h | 29 ++++++++++++++++++++++++-----
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 8dd081051a79..f3773e8536bb 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1316,6 +1316,7 @@ enum {
 	MLX5_PER_PRIORITY_COUNTERS_GROUP      =3D 0x10,
 	MLX5_PER_TRAFFIC_CLASS_COUNTERS_GROUP =3D 0x11,
 	MLX5_PHYSICAL_LAYER_COUNTERS_GROUP    =3D 0x12,
+	MLX5_PER_TRAFFIC_CLASS_CONGESTION_GROUP =3D 0x13,
 	MLX5_PHYSICAL_LAYER_STATISTICAL_GROUP =3D 0x16,
 	MLX5_INFINIBAND_PORT_COUNTERS_GROUP   =3D 0x20,
 };
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 7d65c0578ac9..a487b681b516 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1196,7 +1196,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         rts2rts_qp_counters_set_id[0x1];
 	u8         reserved_at_16a[0x2];
 	u8         vnic_env_int_rq_oob[0x1];
-	u8         reserved_at_16d[0x2];
+	u8         sbcam_reg[0x1];
+	u8         reserved_at_16e[0x1];
 	u8         qcam_reg[0x1];
 	u8         gid_table_size[0x10];
=20
@@ -1960,12 +1961,28 @@ struct mlx5_ifc_ib_port_cntrs_grp_data_layout_bits =
{
 	u8         port_xmit_wait[0x20];
 };
=20
-struct mlx5_ifc_eth_per_traffic_grp_data_layout_bits {
+struct mlx5_ifc_eth_per_tc_prio_grp_data_layout_bits {
 	u8         transmit_queue_high[0x20];
=20
 	u8         transmit_queue_low[0x20];
=20
-	u8         reserved_at_40[0x780];
+	u8         no_buffer_discard_uc_high[0x20];
+
+	u8         no_buffer_discard_uc_low[0x20];
+
+	u8         reserved_at_80[0x740];
+};
+
+struct mlx5_ifc_eth_per_tc_congest_prio_grp_data_layout_bits {
+	u8         wred_discard_high[0x20];
+
+	u8         wred_discard_low[0x20];
+
+	u8         ecn_marked_tc_high[0x20];
+
+	u8         ecn_marked_tc_low[0x20];
+
+	u8         reserved_at_80[0x740];
 };
=20
 struct mlx5_ifc_eth_per_prio_grp_data_layout_bits {
@@ -3642,7 +3659,8 @@ union mlx5_ifc_eth_cntrs_grp_data_layout_auto_bits {
 	struct mlx5_ifc_eth_3635_cntrs_grp_data_layout_bits eth_3635_cntrs_grp_da=
ta_layout;
 	struct mlx5_ifc_eth_extended_cntrs_grp_data_layout_bits eth_extended_cntr=
s_grp_data_layout;
 	struct mlx5_ifc_eth_per_prio_grp_data_layout_bits eth_per_prio_grp_data_l=
ayout;
-	struct mlx5_ifc_eth_per_traffic_grp_data_layout_bits eth_per_traffic_grp_=
data_layout;
+	struct mlx5_ifc_eth_per_tc_prio_grp_data_layout_bits eth_per_tc_prio_grp_=
data_layout;
+	struct mlx5_ifc_eth_per_tc_congest_prio_grp_data_layout_bits eth_per_tc_c=
ongest_prio_grp_data_layout;
 	struct mlx5_ifc_ib_port_cntrs_grp_data_layout_bits ib_port_cntrs_grp_data=
_layout;
 	struct mlx5_ifc_phys_layer_cntrs_bits phys_layer_cntrs;
 	struct mlx5_ifc_phys_layer_statistical_cntrs_bits phys_layer_statistical_=
cntrs;
@@ -9422,7 +9440,8 @@ union mlx5_ifc_ports_control_registers_document_bits =
{
 	struct mlx5_ifc_eth_802_3_cntrs_grp_data_layout_bits eth_802_3_cntrs_grp_=
data_layout;
 	struct mlx5_ifc_eth_extended_cntrs_grp_data_layout_bits eth_extended_cntr=
s_grp_data_layout;
 	struct mlx5_ifc_eth_per_prio_grp_data_layout_bits eth_per_prio_grp_data_l=
ayout;
-	struct mlx5_ifc_eth_per_traffic_grp_data_layout_bits eth_per_traffic_grp_=
data_layout;
+	struct mlx5_ifc_eth_per_tc_prio_grp_data_layout_bits eth_per_tc_prio_grp_=
data_layout;
+	struct mlx5_ifc_eth_per_tc_congest_prio_grp_data_layout_bits eth_per_tc_c=
ongest_prio_grp_data_layout;
 	struct mlx5_ifc_lane_2_module_mapping_bits lane_2_module_mapping;
 	struct mlx5_ifc_pamp_reg_bits pamp_reg;
 	struct mlx5_ifc_paos_reg_bits paos_reg;
--=20
2.21.0

