Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 677BF66822
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 10:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbfGLIDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 04:03:06 -0400
Received: from mail-eopbgr00084.outbound.protection.outlook.com ([40.107.0.84]:19328
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726264AbfGLIDF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jul 2019 04:03:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ME0LANpUQ+gFscR8FDTWr/i3GvOO8a5Z8wRMUpDIJ14zxmy81JmzRXJxQOBhy/La2FOPdMFGav1RmyKpkDFz8uqpaYO5+wXZZ+796+kGuuhnixJJUqv1v62Am+bDr2sXtPyPq2VyGBkqHJ/DYWpZIDsLWBEHHevZqQqA0LtxbJVpYqDWXiAy/8VWnu7wS8tq8xM0P2iSjikmGgLWN8PctB9uperAnjoEptgzwb2F6cViL3HHzmG/gvmwO7vUQvege8tUshsmV8nvETNVTo7V0j8yu6gmEbIeWvm0mu/SPGuL0nj1D4BeMpFsr+NCwVhnv4erOs07QFuqURDslZ6fKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J9wElbHE6ivuEHDRHCQN1uRPAFt9RZaUoJDDACigGHs=;
 b=Sg9v4VkTzhoJQcz+Ibcb7gBrhd5QtFAkq1YMWxyXtcZ+PG8NRiLLKJG7PTGD/9Ps/XHYFH5uWqXvejC4uckw9U+9wsgxIOegDOeKyTFYEY4zvm8pXluxmJhaiR12G+N+rLqGx5Vvc4uL0aQCyCxCDpAIrG2ggzikHPm2D85H6TytHO5XCzd8wuRSjA92rSFSSTjoNkyyI6u8uCN9nmbGIjsDT03QxZALd/t//x3jtB+7+Hq1iYtBzX/3IKltBx5TOquWDzDE2msW9l54Es8WxSxDH6VJBkoedeKWbJ7VOZz7DQxk/v0W/kaHRyz2qjCe06g+GG8lMAGHrh91YDzTug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J9wElbHE6ivuEHDRHCQN1uRPAFt9RZaUoJDDACigGHs=;
 b=LRXVqYmEBDB5CvN5ZPXbSlnNkm8LFucjeK+seieP3eih2Potij09Milorf0PYf4Us556IZe69C0Wb8mJcZE1VQOPvKPvO6WFdFZ+HKyxKX6U3Jz0NkvLJ5F5ATbp/mvgYdsHwEnwzalZp0MtNeZEgCBYBWQm1U0UIJbuK4OSrl8=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4330.eurprd04.prod.outlook.com (52.134.108.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Fri, 12 Jul 2019 08:02:59 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::6553:8d04:295c:774b]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::6553:8d04:295c:774b%5]) with mapi id 15.20.2073.008; Fri, 12 Jul 2019
 08:02:59 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH 7/8] can: flexcan: add imx8qm support
Thread-Topic: [PATCH 7/8] can: flexcan: add imx8qm support
Thread-Index: AQHVOIg4lseoYZpR80+sd5Szdt11Og==
Date:   Fri, 12 Jul 2019 08:02:59 +0000
Message-ID: <20190712075926.7357-8-qiangqing.zhang@nxp.com>
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
x-ms-office365-filtering-correlation-id: 65834dbc-d14d-4ac8-b36b-08d7069f5abb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB4330;
x-ms-traffictypediagnostic: DB7PR04MB4330:
x-microsoft-antispam-prvs: <DB7PR04MB4330F382E49AD05FE15C52A6E6F20@DB7PR04MB4330.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:205;
x-forefront-prvs: 00963989E5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(396003)(136003)(376002)(199004)(189003)(110136005)(25786009)(1076003)(54906003)(305945005)(3846002)(6116002)(7736002)(316002)(71200400001)(4326008)(66066001)(2906002)(66446008)(5660300002)(64756008)(66556008)(66476007)(71190400001)(2501003)(478600001)(66946007)(2616005)(6506007)(102836004)(26005)(386003)(6436002)(186003)(6486002)(86362001)(50226002)(68736007)(256004)(446003)(476003)(11346002)(486006)(8936002)(52116002)(76176011)(36756003)(53936002)(99286004)(14454004)(81156014)(81166006)(6512007)(8676002)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4330;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: p6H7tx5ac8gV1+/SQIAojB8aZpdqkbcgS8EcY9aYmvTqW7LTlHxMWu6foO/IAZWGMaD/+bixah4rsJN+9F7NaokwBU1umOJrgSwwzMUdh8DQupgTVZoZ/1xQv8zBGm2CGNdXIDCGWyP/qVIoOnI5sNWumTTSKRz9OFtZpTwg29LZAh1eRrMEEL5jlRbtfG1Vy2Z9Y31xDNRtqLwDKIzEl9jv+BkKOb1St2/z5Rg1RLSWU/YDkYH2CBmm/uxIA/mrLyYzwel4UufTxUMxK31KiJWpxO0uQUuLn9mBkx/dk7dyXmCzg7gIaaWRrSNNuyqNusrEfPAiuZ9D5U6z8jCwEnEYixf9ze25fHwzoxBEkPgHVI5wDy5oO3j8TyMiWkmgUIzroU08OOxd6h868nItM6luQnGlmpJ25AIpuxErKkg=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65834dbc-d14d-4ac8-b36b-08d7069f5abb
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2019 08:02:59.0160
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

The Flexcan on i.MX8QM supports CAN FD protocol.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 2c48151e431f..f1fdaae52ef4 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -346,6 +346,12 @@ static const struct flexcan_devtype_data fsl_imx6q_dev=
type_data =3D {
 		FLEXCAN_QUIRK_SETUP_STOP_MODE,
 };
=20
+static struct flexcan_devtype_data fsl_imx8qm_devtype_data =3D {
+	.quirks =3D FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
+		FLEXCAN_QUIRK_USE_OFF_TIMESTAMP | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
+		FLEXCAN_QUIRK_TIMESTAMP_SUPPORT_FD,
+};
+
 static const struct flexcan_devtype_data fsl_vf610_devtype_data =3D {
 	.quirks =3D FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
 		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_USE_OFF_TIMESTAMP |
@@ -1703,6 +1709,7 @@ static int flexcan_setup_stop_mode(struct platform_de=
vice *pdev)
 }
=20
 static const struct of_device_id flexcan_of_match[] =3D {
+	{ .compatible =3D "fsl,imx8qm-flexcan", .data =3D &fsl_imx8qm_devtype_dat=
a, },
 	{ .compatible =3D "fsl,imx6q-flexcan", .data =3D &fsl_imx6q_devtype_data,=
 },
 	{ .compatible =3D "fsl,imx28-flexcan", .data =3D &fsl_imx28_devtype_data,=
 },
 	{ .compatible =3D "fsl,imx53-flexcan", .data =3D &fsl_imx25_devtype_data,=
 },
--=20
2.17.1

