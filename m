Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F16E2C4238
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 23:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfJAVBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 17:01:24 -0400
Received: from mail-eopbgr140100.outbound.protection.outlook.com ([40.107.14.100]:29762
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726402AbfJAVBX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 17:01:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C8DZd2YT7GB345RVPgGQ7Zuap2vHKO16Vu2/+4kSBiS5i/kavwYK55tqC8esSUSC5fGY0BltTMa8rLqaQqVbhYB4AzGpUTeLB5/U51vdspn7qzaD8kmtJFRnid2QzVmv7in/wCmtKkYphSetnVGZFeN2X3yvTiyT84FlsxWM1qU7bc5GyJORXsfLjSUB/ARKqoVa5bUDKz9l5yO4bSsTsuNWtP4Zytc99kqhzuOeQV2nUHFon2poAFbXSvaE6K69VKfwL1QefHpQwVVJWeZy+UwmhYpGRAg7krMYKvjXmkvkjePXxEw7KcUkwEvgULsfDG2Y4C1/ASApw0tUol9VRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M9jLVWQpzSxz+CW0yxnhVPOgx5RK1JiXzqj3iaI1qCk=;
 b=dNsSTBfS15LvOu2wq5446u0+58MFyoZ/g5Wfe+Dt2/BZA4Rii2/qLUOm81RXRccGvP8sPqKjJSUkLIpEaxtszu+7ToywTJqNkVRGfiXoXWGquT1WHbx9rWr19p/h4G3KWE4D7zRZRCELFgWTmbJq8loYzUxqEV/S8jyyCf8Demizaluw49XGLHA15tOzXO2hMb/XAfBeiUqbTDtN+0GRQGBLrFMadotDfgw751VtXAaS/c+EGRX5UfSNQ3AVQKgYlP2/B41uJg62DLBoGvxGySojkkxV4Omv2MYtg43YsQqKlPvh9XZl6J86C3WdQZ+4IxIwUJFjQJBUXXKj75uBng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=victronenergy.com; dmarc=pass action=none
 header.from=victronenergy.com; dkim=pass header.d=victronenergy.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=victronenergy.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M9jLVWQpzSxz+CW0yxnhVPOgx5RK1JiXzqj3iaI1qCk=;
 b=RHyVuaYelVcbxD8fDc1e70IhKq/r+5NcSLlhxpxeR1xqAj/neiJdCGI+zdGAAN+T0w3txCDhZYB9JBgVD0PckoAc7GE3qzLA323/2COHnWG5d6uhChz+98wLkMYOFCXmFsip1uxCk2+UxW3FDi9VE5yU8/cqsBwPbg8DTLtZbRQ=
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com (10.173.82.19) by
 VI1PR0701MB2813.eurprd07.prod.outlook.com (10.173.71.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.15; Tue, 1 Oct 2019 21:01:20 +0000
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::dc92:2e0d:561a:fbb1]) by VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::dc92:2e0d:561a:fbb1%8]) with mapi id 15.20.2305.017; Tue, 1 Oct 2019
 21:01:20 +0000
From:   Jeroen Hofstee <jhofstee@victronenergy.com>
To:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     Jeroen Hofstee <jhofstee@victronenergy.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/2] can: D_CAN: perform a sofware reset on open
Thread-Topic: [PATCH v2 1/2] can: D_CAN: perform a sofware reset on open
Thread-Index: AQHVeJtgUvI7Atix90eiuhnIdlHYLA==
Date:   Tue, 1 Oct 2019 21:01:20 +0000
Message-ID: <20191001210054.14588-2-jhofstee@victronenergy.com>
References: <20191001210054.14588-1-jhofstee@victronenergy.com>
In-Reply-To: <20191001210054.14588-1-jhofstee@victronenergy.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:1c01:3bc5:4e00:5c2:1c3a:9351:514c]
x-clientproxiedby: AM0PR05CA0028.eurprd05.prod.outlook.com
 (2603:10a6:208:55::41) To VI1PR0701MB2623.eurprd07.prod.outlook.com
 (2603:10a6:801:b::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhofstee@victronenergy.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 56c368e7-6c91-452d-f161-08d746b2828c
x-ms-traffictypediagnostic: VI1PR0701MB2813:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0701MB2813B7C8370188376044083DC09D0@VI1PR0701MB2813.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0177904E6B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(396003)(366004)(39850400004)(136003)(376002)(199004)(189003)(99286004)(316002)(46003)(6436002)(6486002)(386003)(6506007)(6916009)(76176011)(5640700003)(186003)(102836004)(7736002)(54906003)(305945005)(52116002)(86362001)(14454004)(478600001)(966005)(4326008)(6306002)(25786009)(8936002)(6512007)(81166006)(81156014)(8676002)(66446008)(66556008)(66946007)(36756003)(2351001)(50226002)(64756008)(1076003)(66476007)(256004)(446003)(11346002)(2906002)(486006)(5660300002)(476003)(2616005)(71200400001)(2501003)(6116002)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR0701MB2813;H:VI1PR0701MB2623.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: victronenergy.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O16yubd9EIv4R2W9112TOd6PBKFq2/GJTXkqYQfZNUyA+F1Fd0H3AbEBwX8fAJi7BCl3BZezsby5CjdBJKGDkowmevp7ftCh6roI6ng0PmSrlEC1GorFTtc1Iybfcgnq3TTYlENK3KybuUnx6Vdojrf3cuERDbYRYIF5k3TCahNbEy3Ywa4IsUjSaUO47lIdTD7sxt+00IcHrqLu//bdpaCiv8fCw3DYS1GjwqMFGFowmfKUcrNp3a01GUmtajAJ1iVyQkGqkkgwdF/Jw1z4nrNpxSi6JJUH3hap/Q8K2ACXWZ1yMVWXT0Rni3H3g1B04jEX71dObMVZbKf6i/8xjL+i74N3CYZlaQVHq7r7q6OEWBtaaISx6HHhvqg4Xnz4fAb1hFVPiJRNw6KRMMF0rqBxLSZW02SIFkeylAXuLmbHV+9mzNXa/JewBdEUdKHQxOH6wNLYwREDWF3FyUJJpQ==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: victronenergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56c368e7-6c91-452d-f161-08d746b2828c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2019 21:01:20.7361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 60b95f08-3558-4e94-b0f8-d690c498e225
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SrgP8tdMRHVRmKiW7h31BUWzmLU2DyXGiuSZxpJqPj1eIciJ5jJDC+u7LKHLYnvw0vwbIXyFjRihnpuBtgrEXr3VBVauzc0d0Clra4uGpo8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0701MB2813
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the C_CAN interface is closed it is put in power down mode, but
does not reset the error counters / state. So reset the D_CAN on open,
so the reported state and the actual state match.

According to [1], the C_CAN module doesn't have the software reset.

[1] http://www.bosch-semiconductors.com/media/ip_modules/pdf_2/c_can_fd8/us=
ers_manual_c_can_fd8_r210_1.pdf

Signed-off-by: Jeroen Hofstee <jhofstee@victronenergy.com>
---
 drivers/net/can/c_can/c_can.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 606b7d8ffe13..2332687fa6dc 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -52,6 +52,7 @@
 #define CONTROL_EX_PDR		BIT(8)
=20
 /* control register */
+#define CONTROL_SWR		BIT(15)
 #define CONTROL_TEST		BIT(7)
 #define CONTROL_CCE		BIT(6)
 #define CONTROL_DISABLE_AR	BIT(5)
@@ -569,6 +570,26 @@ static void c_can_configure_msg_objects(struct net_dev=
ice *dev)
 				   IF_MCONT_RCV_EOB);
 }
=20
+static int c_can_software_reset(struct net_device *dev)
+{
+	struct c_can_priv *priv =3D netdev_priv(dev);
+	int retry =3D 0;
+
+	if (priv->type !=3D BOSCH_D_CAN)
+		return 0;
+
+	priv->write_reg(priv, C_CAN_CTRL_REG, CONTROL_SWR | CONTROL_INIT);
+	while (priv->read_reg(priv, C_CAN_CTRL_REG) & CONTROL_SWR) {
+		msleep(20);
+		if (retry++ > 100) {
+			netdev_err(dev, "CCTRL: software reset failed\n");
+			return -EIO;
+		}
+	}
+
+	return 0;
+}
+
 /*
  * Configure C_CAN chip:
  * - enable/disable auto-retransmission
@@ -578,6 +599,11 @@ static void c_can_configure_msg_objects(struct net_dev=
ice *dev)
 static int c_can_chip_config(struct net_device *dev)
 {
 	struct c_can_priv *priv =3D netdev_priv(dev);
+	int err;
+
+	err =3D c_can_software_reset(dev);
+	if (err)
+		return err;
=20
 	/* enable automatic retransmission */
 	priv->write_reg(priv, C_CAN_CTRL_REG, CONTROL_ENABLE_AR);
--=20
2.17.1

