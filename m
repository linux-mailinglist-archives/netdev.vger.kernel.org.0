Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECF266826
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 10:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfGLIDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 04:03:09 -0400
Received: from mail-eopbgr00084.outbound.protection.outlook.com ([40.107.0.84]:19328
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726365AbfGLIDH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jul 2019 04:03:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BiOE6N7VmBsXW6Ulf1iAZRl4m/Z/qX+puYPnDT3oK/s3QTv5vSb7ENOV0mHcmDqVBB1s7xFu8tVEQMb1Ldnktbmg/E5y1hsbzgzzpDNCRBtncdVxFerM1ToaUKwfyWTYJH9HmORe+Db3cTSjR8hxhf4VmI6Y6twkhteE5GoYeMA67yaful5zAspbTF8wdDWklSjWMgjVxej8zrUKf+XIhFWrk1apoqvym19oCG1MWZVNUzKQm4bJni+YDq1xBtBaalvt6iwvgNWFRKDcHFVfLhHtb0G4lOVq5Lmc/TccSDpnc1SPw+HQYdAkB3FD7Ml5XVBq+sfpu/OSXLmDaOWcVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yczdpAWu2vACiaf/NCHrgsQwZO4ASQEmmBp5BHQUXnM=;
 b=bA45mq3ts9zKQ3xdGn6yLRNjuoo14qpkNRfbpNUhd9vCLAzdmC1iq+yniRiSgGdsit4fp9QIY0bGy6Y2VcMyQj5xxU6ufdY7OyemSmPmJFalyGczVCVWPzY5v/BPRg/yZ/NL97Z0fA5M5t3uJF0fCEruO75l37wSScvaadlC+UkIpK928e7nwykXGTGMJr+dLE0nOmcjt93A5Mf7Aq36Hi/3Mh0N2OKVyhSEdAReCR1+on64JQu6uMpRmQIqB8P8VXNIaG3G6NX4vB633GXkB2YngxC3f90L3HLjLBuyXeybAgsJTxVza5inpNdXyiu1KAOlYHYjvM6d9iy2NNlaaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yczdpAWu2vACiaf/NCHrgsQwZO4ASQEmmBp5BHQUXnM=;
 b=j45Nc5Iu80tQGEe5j9ZDYtoJYbp9pURjQPmYyyyWB0UE+J64V02PYy4plm/SINXSK+j0Gl+3liUUH3IXlSFNq3XFqHLeQNsGi9UccNe8ksxkc62Y2iyWMYVUQ4YmDUdO0sYf1vALFR09H1J1O/3rJkeHWdevdkjDeoYaK2ZIMuQ=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4330.eurprd04.prod.outlook.com (52.134.108.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Fri, 12 Jul 2019 08:03:02 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::6553:8d04:295c:774b]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::6553:8d04:295c:774b%5]) with mapi id 15.20.2073.008; Fri, 12 Jul 2019
 08:03:02 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH 8/8] can: flexcan: add lx2160ar1 support
Thread-Topic: [PATCH 8/8] can: flexcan: add lx2160ar1 support
Thread-Index: AQHVOIg6+iIbdFBIN0Sg2HDn1PbbUg==
Date:   Fri, 12 Jul 2019 08:03:01 +0000
Message-ID: <20190712075926.7357-9-qiangqing.zhang@nxp.com>
References: <20190712075926.7357-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20190712075926.7357-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR02CA0061.apcprd02.prod.outlook.com
 (2603:1096:4:54::25) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:38::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 08f05eab-2218-4edb-3bfe-08d7069f5c6f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB4330;
x-ms-traffictypediagnostic: DB7PR04MB4330:
x-microsoft-antispam-prvs: <DB7PR04MB4330A34B5C7072DC0A82336FE6F20@DB7PR04MB4330.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:398;
x-forefront-prvs: 00963989E5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(39860400002)(346002)(366004)(396003)(136003)(376002)(199004)(189003)(110136005)(25786009)(1076003)(54906003)(305945005)(3846002)(6116002)(7736002)(316002)(71200400001)(4326008)(66066001)(2906002)(66446008)(5660300002)(64756008)(66556008)(66476007)(71190400001)(2501003)(478600001)(66946007)(2616005)(6506007)(102836004)(26005)(386003)(6436002)(186003)(6486002)(86362001)(50226002)(68736007)(256004)(446003)(476003)(11346002)(486006)(8936002)(52116002)(76176011)(36756003)(53936002)(99286004)(14454004)(81156014)(81166006)(6512007)(8676002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4330;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kZUcDqfLVYWRDPcvoJUy5eN0uxmITplljQhta4aPoe6UKVQxR1GYHqOHRdFOliZL3LYkqaA1fZWgSiFOjFtK+LZ6/YD+cM4YahNfDCpDSD2H7b1+2gPNdXcndmmCGtSxjpcRrlwz7/BjsQKSvC/+RHahuhm0uy71iZ47FbnhWovvL6f4kZlfDfdRv5tSCY/NS2oqjtiWtvvQxq8w/8CpUKFjsh1+b1LA1kWkKDphy0UIabAzpanvE5DSCcMANiRIGTAq5509+sSGfReQhn718ORJdEb2SB+IJwPJ7cyTWqjijyoGdEImO5/v2EHMVzC1IGQbVcadXrRbEbjkf9zcVLrmG9W/KCf0SeC70M/U2pMB6s+p6GW05atRsun1yQ+sIAhPOdH206A4+dXea1BgOC8hQIHa4K3IZIgeD4mKFVI=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08f05eab-2218-4edb-3bfe-08d7069f5c6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2019 08:03:01.8953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qiangqing.zhang@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4330
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Flexcan on lx2160ar1 supports CAN FD protocol.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index f1fdaae52ef4..f5c66f284c70 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -358,6 +358,12 @@ static const struct flexcan_devtype_data fsl_vf610_dev=
type_data =3D {
 		FLEXCAN_QUIRK_BROKEN_PERR_STATE,
 };
=20
+static const struct flexcan_devtype_data fsl_lx2160a_r1_devtype_data =3D {
+	.quirks =3D FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
+		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
+		FLEXCAN_QUIRK_USE_OFF_TIMESTAMP | FLEXCAN_QUIRK_TIMESTAMP_SUPPORT_FD,
+};
+
 static const struct flexcan_devtype_data fsl_ls1021a_r2_devtype_data =3D {
 	.quirks =3D FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
 		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
@@ -1709,6 +1715,7 @@ static int flexcan_setup_stop_mode(struct platform_de=
vice *pdev)
 }
=20
 static const struct of_device_id flexcan_of_match[] =3D {
+	{ .compatible =3D "fsl,lx2160ar1-flexcan", .data =3D &fsl_lx2160a_r1_devt=
ype_data, },
 	{ .compatible =3D "fsl,imx8qm-flexcan", .data =3D &fsl_imx8qm_devtype_dat=
a, },
 	{ .compatible =3D "fsl,imx6q-flexcan", .data =3D &fsl_imx6q_devtype_data,=
 },
 	{ .compatible =3D "fsl,imx28-flexcan", .data =3D &fsl_imx28_devtype_data,=
 },
--=20
2.17.1

