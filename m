Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C457C423B
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 23:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbfJAVBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 17:01:30 -0400
Received: from mail-eopbgr140139.outbound.protection.outlook.com ([40.107.14.139]:8538
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726973AbfJAVB2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 17:01:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hVlmhPhi6RIODzhAy40mZ7FgPNFQHFk/YSOFxwiHFfFN6/O7Ur5ioiY8xYlnVjPnTVypm/VS5THINd5twm/gJZOlJUBfZQzDWlBm+zBAD+IT3b5EwUcoF54Md5ozQ8A/AQ1NYelO8qPqQUTCqhptEGK54Ttpph8KzwiZfyS02VFHCjpgCf/tzQCnGVVA4ik9O/XqKXy7V8uJANi1nE59YeTLRfR4mRW1t6DGcuEfVYYzmKP7Lf9IjI+iTm1JZHpUz/qrqWBjGE+Q+TCdVL0UM61bqV95UZd9J8WSbKZpTLhghzlE3XyUJ85lkQ0ps0k+OY9lPUeNvhx6MpXXAXua5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NDinrLYU/wk20kHj6EjeGYsAhRnYvw98zkoHY3Qy3So=;
 b=NBXgiMc/sDXoPUjAwuo7auM9VlYgs2ipifyCwcUCj/38LUKjBSc5/WSd4NPp2f4LiHh84NhoB5XdFN2QjzlY4jEszigPxQyJKH2MZ+LGZGRHCGrbAJuCCOVa45lW3JzBY6RVK4LZTBeYEvRoqjzk3TN/sU6MxqbdqYlnBRKZxvOnu+G7wUMAXO3Q6trrqV8SZG+zU8D60tNEbRXElMv+vVD8grJyIllrvu56sV/cf+deToAhneq+rZL7LBnmxuoMFNTZEqA0PER0Z+39X6Un/YYeDZXeYlKMDWzpxyN4427UaUz9XwVuJdU0BR0S5V3c1y/IqJEkNMeWpVmQ5pszrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=victronenergy.com; dmarc=pass action=none
 header.from=victronenergy.com; dkim=pass header.d=victronenergy.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=victronenergy.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NDinrLYU/wk20kHj6EjeGYsAhRnYvw98zkoHY3Qy3So=;
 b=NAVDgB4DEntFfI8XC6IyHXjd9o5AB1EYpIgT/6cgkNngoPGZtsDtbfFw+lawMr354W1KjTvAaQOkJZh6HwsOdEeLXXeV9obzw6t8eiRIm0Y3upXc+NZXmAlOoVqL2W87ZPVUTCJDadcZaKKkTmYok7rRpk2HbOjv40xQC+KfLjs=
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com (10.173.82.19) by
 VI1PR0701MB2813.eurprd07.prod.outlook.com (10.173.71.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.15; Tue, 1 Oct 2019 21:01:25 +0000
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::dc92:2e0d:561a:fbb1]) by VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::dc92:2e0d:561a:fbb1%8]) with mapi id 15.20.2305.017; Tue, 1 Oct 2019
 21:01:25 +0000
From:   Jeroen Hofstee <jhofstee@victronenergy.com>
To:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     Jeroen Hofstee <jhofstee@victronenergy.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/2] can: C_CAN: add bus recovery events
Thread-Topic: [PATCH v2 2/2] can: C_CAN: add bus recovery events
Thread-Index: AQHVeJtihUjcrRUQAUmkCgXOis19pg==
Date:   Tue, 1 Oct 2019 21:01:24 +0000
Message-ID: <20191001210054.14588-3-jhofstee@victronenergy.com>
References: <20191001210054.14588-1-jhofstee@victronenergy.com>
In-Reply-To: <20191001210054.14588-1-jhofstee@victronenergy.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:1c01:3bc5:4e00:5c2:1c3a:9351:514c]
x-clientproxiedby: AM4PR0202CA0019.eurprd02.prod.outlook.com
 (2603:10a6:200:89::29) To VI1PR0701MB2623.eurprd07.prod.outlook.com
 (2603:10a6:801:b::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhofstee@victronenergy.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e422f6e-c731-41b1-f8a8-08d746b2851f
x-ms-traffictypediagnostic: VI1PR0701MB2813:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0701MB2813247C3C2101DC96F9463AC09D0@VI1PR0701MB2813.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:138;
x-forefront-prvs: 0177904E6B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(396003)(366004)(39850400004)(136003)(376002)(199004)(189003)(99286004)(316002)(46003)(6436002)(6486002)(386003)(6506007)(6916009)(76176011)(5640700003)(186003)(102836004)(7736002)(54906003)(305945005)(52116002)(86362001)(14454004)(478600001)(4326008)(25786009)(8936002)(6512007)(81166006)(81156014)(8676002)(66446008)(66556008)(14444005)(66946007)(36756003)(2351001)(50226002)(64756008)(1076003)(66476007)(256004)(446003)(11346002)(2906002)(486006)(5660300002)(476003)(2616005)(71200400001)(2501003)(6116002)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR0701MB2813;H:VI1PR0701MB2623.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: victronenergy.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EryyMXjjGneXcEp3hxCJZzrHMV75kRQklkUHK8XjSwTdRoqYeQlIE7K4SOEs9vADjAGb7lt+PI2PSJJjCdlHEiLih4tg0VYz+dIF+QiY+aGfaMI151UkTqozVtlZPOWK8194kmxZI2neB2WzJMXHm/z8pDW3kjURCoxyncQ2vWtVgGiJ0VwU7lNZPSSGaM7uHTgcRx540m5QDu0npdyLASGAPzqLny09jmtLQu5rCCrqtsAUasgYwh8FR0xNPQmILMkyLn+z4L+9IQETS9xdSaaYVuiMQOQS70sIy06ku2jzxr0cIFgFYy7Y/iJbZWvqeFhxNUB80cjs6AsAW3CtutR82S/kFfkXf59JRtFOvywc3g/npgll5y3Oiax3nrwaksyTDbPLJtrcDi9/718+cFkKIPxsZzR3ZeWGngxOXUE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: victronenergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e422f6e-c731-41b1-f8a8-08d746b2851f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2019 21:01:24.9991
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 60b95f08-3558-4e94-b0f8-d690c498e225
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eu9hKfv/OhZefdmQXCMUwmaxBdHlK+/+UA8WnA63bJ91RzN76f5/8Mkz+FbprsiYxRyEm3uYBjYhwRnGf0UvDUYSExdi8Sujhkh2FWR3bcg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0701MB2813
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While the state is updated when the error counters increase and decrease,
there is no event when the bus recovers and the error counters decrease
again. So add that event as well.

Change the state going downward to be ERROR_PASSIVE -> ERROR_WARNING ->
ERROR_ACTIVE instead of directly to ERROR_ACTIVE again.

Signed-off-by: Jeroen Hofstee <jhofstee@victronenergy.com>
Acked-by: Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
Tested-by: Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
---
 drivers/net/can/c_can/c_can.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 2332687fa6dc..e1e9b87dd4d2 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -912,6 +912,9 @@ static int c_can_handle_state_change(struct net_device =
*dev,
 	struct can_berr_counter bec;
=20
 	switch (error_type) {
+	case C_CAN_NO_ERROR:
+		priv->can.state =3D CAN_STATE_ERROR_ACTIVE;
+		break;
 	case C_CAN_ERROR_WARNING:
 		/* error warning state */
 		priv->can.can_stats.error_warning++;
@@ -942,6 +945,13 @@ static int c_can_handle_state_change(struct net_device=
 *dev,
 				ERR_CNT_RP_SHIFT;
=20
 	switch (error_type) {
+	case C_CAN_NO_ERROR:
+		/* error warning state */
+		cf->can_id |=3D CAN_ERR_CRTL;
+		cf->data[1] =3D CAN_ERR_CRTL_ACTIVE;
+		cf->data[6] =3D bec.txerr;
+		cf->data[7] =3D bec.rxerr;
+		break;
 	case C_CAN_ERROR_WARNING:
 		/* error warning state */
 		cf->can_id |=3D CAN_ERR_CRTL;
@@ -1080,11 +1090,17 @@ static int c_can_poll(struct napi_struct *napi, int=
 quota)
 	/* handle bus recovery events */
 	if ((!(curr & STATUS_BOFF)) && (last & STATUS_BOFF)) {
 		netdev_dbg(dev, "left bus off state\n");
-		priv->can.state =3D CAN_STATE_ERROR_ACTIVE;
+		work_done +=3D c_can_handle_state_change(dev, C_CAN_ERROR_PASSIVE);
 	}
+
 	if ((!(curr & STATUS_EPASS)) && (last & STATUS_EPASS)) {
 		netdev_dbg(dev, "left error passive state\n");
-		priv->can.state =3D CAN_STATE_ERROR_ACTIVE;
+		work_done +=3D c_can_handle_state_change(dev, C_CAN_ERROR_WARNING);
+	}
+
+	if ((!(curr & STATUS_EWARN)) && (last & STATUS_EWARN)) {
+		netdev_dbg(dev, "left error warning state\n");
+		work_done +=3D c_can_handle_state_change(dev, C_CAN_NO_ERROR);
 	}
=20
 	/* handle lec errors on the bus */
--=20
2.17.1

