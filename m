Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66445BDA56
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 10:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732047AbfIYI67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 04:58:59 -0400
Received: from mail-eopbgr20117.outbound.protection.outlook.com ([40.107.2.117]:46101
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730048AbfIYI6u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 04:58:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mLJIkwBCAPJ7HVsjmxGn0Z19hzBUpXqaaz2heBSm08xQG//pqhmQL4UlyjCNu/7xAXJLv3VqS0HfIUm3/5TTWgY8zgGPCsA978tyxm8FoHS9MA3sb/XUDBhN/bodGbVwA+pafN+keIYzIFZJcB/bnCFpD29HZwBcW01APfn+Z6/VIq7dUlAiB1xVtoWeVAFhD7IO5inqNBJ521sjMuAU+Lmsvy28eB6NNKJeEclgeRaPcYkb6wFKAczZizpRttPi9Ay2Gc0vEddrdOckF1IGuY5LUEj6hYBIicvwVPJi8JYMamc5TQawAaESZ/wZwfMvII9WzUhEhmX7JMY+LC4z+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joJMWMYl6OickdL6ydA4gp8/4e8Gr7ixcgLiqvj646c=;
 b=MrHI22tQbuk6bbk7jGwpfbLg7N/z3TxVv0Ub2UKkYJQGallPIb336WQDtcY+ijMSH3Nd6Id0g2szVIO1yVQXb+R58ddpFyw0rX1RtjhPEZxlY6K24gQzRIi5db0JAHVpfW2UDtg6YNN8HO63PQJc7BYEIU3haxfBrYLPM/HVA53baYxX1HdeOS6DwHs15tUSHtMBzCwa/u88l/IOnrZx2mKEv4f9OJR8Ww9jZAXJnojyAPadjnGx3vROw6pESIqmEXjU/bnpIxEC7hxqLxgr6Pcp81gQMnnGVVpVnouISW2Swt+QW+8bU2GmjQQnMW5G5Mygdmg7R57IjhsYBoKmpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=victronenergy.com; dmarc=pass action=none
 header.from=victronenergy.com; dkim=pass header.d=victronenergy.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=victronenergy.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joJMWMYl6OickdL6ydA4gp8/4e8Gr7ixcgLiqvj646c=;
 b=LYi9R2q0LK+cOoIuls7dmMRytfo0Cq2RWNMZnDiH+Y+Z7IVP4sSaWm6uiivf2MUwjfVXxhIpmtYSBSGQU80qqFrt/xhF6fLgZDqeGuaDhA1bgdVwG3yhmcPMe1nCKgvsTpisGGCATF8mA05wpcKk8BzLHAE3HrNC6FEt7KtDxLo=
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com (10.173.82.19) by
 VI1PR0701MB2095.eurprd07.prod.outlook.com (10.169.131.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.15; Wed, 25 Sep 2019 08:58:45 +0000
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::dc92:2e0d:561a:fbb1]) by VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::dc92:2e0d:561a:fbb1%8]) with mapi id 15.20.2305.013; Wed, 25 Sep 2019
 08:58:45 +0000
From:   Jeroen Hofstee <jhofstee@victronenergy.com>
To:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     Jeroen Hofstee <jhofstee@victronenergy.com>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH] can: peakcan: report bus recovery as well
Thread-Topic: [PATCH] can: peakcan: report bus recovery as well
Thread-Index: AQHVc39v0tTWHby5B0usrbVxGOnW3Q==
Date:   Wed, 25 Sep 2019 08:58:45 +0000
Message-ID: <20190925085824.4708-1-jhofstee@victronenergy.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [213.126.8.10]
x-clientproxiedby: AM4PR05CA0017.eurprd05.prod.outlook.com (2603:10a6:205::30)
 To VI1PR0701MB2623.eurprd07.prod.outlook.com (2603:10a6:801:b::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhofstee@victronenergy.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a9bd05d1-0421-426a-0ee6-08d74196923b
x-ms-traffictypediagnostic: VI1PR0701MB2095:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0701MB2095938EB9C47D7B2F5F2003C0870@VI1PR0701MB2095.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 01713B2841
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(366004)(396003)(39850400004)(346002)(376002)(189003)(199004)(6486002)(3846002)(2501003)(316002)(71200400001)(8676002)(66476007)(66446008)(386003)(71190400001)(6506007)(8936002)(2351001)(66946007)(36756003)(2906002)(81166006)(64756008)(26005)(52116002)(25786009)(7416002)(50226002)(7736002)(186003)(86362001)(66556008)(66066001)(4326008)(5660300002)(81156014)(478600001)(6916009)(2616005)(476003)(5640700003)(54906003)(305945005)(102836004)(99286004)(256004)(6512007)(14454004)(14444005)(486006)(1076003)(6116002)(6436002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR0701MB2095;H:VI1PR0701MB2623.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: victronenergy.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5WwiJFfoY91coQWmyHXbG3Y2ltBdvR76TNUgn7PSDZ6fBaoBRjb/2mWZEmx+CWGDO6L9+LEho9BY2khoFxeV5ITtaa5PQGEodEL/VGjCUeaXfhswoJJ80an/v6/Mo03XDhRtI7bQEjrdPwXeCSRcYrI/uHVwJkanc8/5VWkUraNP17oO7bq48JkKRfGDEVJ/erTpDjsJNvOyNrBhRAQ5u/iANWuomMzIIxaI+Cok/FiEzEqsNeOZvjhMUje7ooJ2kK6Btp42IS+bonD1kOyxoKvRychoxhwn1SkFpMQrR2EGtpaCaK5SXdliKsclfuRVsbFfEIPwNgagCOrggS6anaq1aki4CDDhvuhxLnzEnpRh3xyqkAC4CrNi0QkEBIGScjW3rT/78Zl92hoZkUbEJTDlsktfmCUxKJbapyk8DrU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: victronenergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9bd05d1-0421-426a-0ee6-08d74196923b
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2019 08:58:45.2837
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 60b95f08-3558-4e94-b0f8-d690c498e225
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sN+I546nx7q3rU/9hiNhfI4y8rEMmKsCv1N4Yt3fYz0xZSsc3RSAhXFKw2zcRJt/cexsR/dVSmjFz4Eddr/q01HZY2i9PmROhFay51HB1cE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0701MB2095
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While the state changes are reported when the error counters increase
and decrease, there is no event when the bus recovers and the error
counters decrease again. So add those as well.

Change the state going downward to be ERROR_PASSIVE -> ERROR_WARNING ->
ERROR_ACTIVE instead of directly to ERROR_ACTIVE again.

Signed-off-by: Jeroen Hofstee <jhofstee@victronenergy.com>
Cc: Stephane Grosjean <s.grosjean@peak-system.com>
---
 drivers/net/can/usb/peak_usb/pcan_usb.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/usb/=
peak_usb/pcan_usb.c
index 617da295b6c1..dd2a7f529012 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -436,8 +436,8 @@ static int pcan_usb_decode_error(struct pcan_usb_msg_co=
ntext *mc, u8 n,
 		}
 		if ((n & PCAN_USB_ERROR_BUS_LIGHT) =3D=3D 0) {
 			/* no error (back to active state) */
-			mc->pdev->dev.can.state =3D CAN_STATE_ERROR_ACTIVE;
-			return 0;
+			new_state =3D CAN_STATE_ERROR_ACTIVE;
+			break;
 		}
 		break;
=20
@@ -460,9 +460,9 @@ static int pcan_usb_decode_error(struct pcan_usb_msg_co=
ntext *mc, u8 n,
 		}
=20
 		if ((n & PCAN_USB_ERROR_BUS_HEAVY) =3D=3D 0) {
-			/* no error (back to active state) */
-			mc->pdev->dev.can.state =3D CAN_STATE_ERROR_ACTIVE;
-			return 0;
+			/* no error (back to warning state) */
+			new_state =3D CAN_STATE_ERROR_WARNING;
+			break;
 		}
 		break;
=20
@@ -501,6 +501,11 @@ static int pcan_usb_decode_error(struct pcan_usb_msg_c=
ontext *mc, u8 n,
 		mc->pdev->dev.can.can_stats.error_warning++;
 		break;
=20
+	case CAN_STATE_ERROR_ACTIVE:
+		cf->can_id |=3D CAN_ERR_CRTL;
+		cf->data[1] =3D CAN_ERR_CRTL_ACTIVE;
+		break;
+
 	default:
 		/* CAN_STATE_MAX (trick to handle other errors) */
 		cf->can_id |=3D CAN_ERR_CRTL;
--=20
2.17.1

