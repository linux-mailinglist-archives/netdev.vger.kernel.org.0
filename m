Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5C28BD20D
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 20:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730482AbfIXSq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 14:46:27 -0400
Received: from mail-eopbgr150119.outbound.protection.outlook.com ([40.107.15.119]:15758
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2441712AbfIXSqR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 14:46:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l9RzrqfJgrSWfyQBJ/E8Pa6LsRacq3JtGy93ke0G0ScSiDE4Yi4mbtHhKm1jKXR+hjaCaTPJk2iAd9KcfPTVag0kXOsPqSYc0NXZc6Q+5NuhEHqEH8Zp/Ubl41fNtFhj1iDzVIHxZVyhX7Th/5ERsehJOYekfcQ3KviL9jwS5LE05x9wfXahWRheUqb2WkHk3Mc9gSaJHp20ghSTbc1Sl7enTVsuZe4Xb6MWy2D49cxiGZNwbRkL0LdwF2iIZFFOQ5ivL6ReVKk8/34ZCf8y7ox77OrOP/FMcGu4Ks9lYCYuTo1OuQ9lzChmCI6k6EHuBnHwWpOUtX0t7ksL+fraCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZpGfrvwGYP+IlQpLYptN100mTuNKGbYwHtuM60Utivc=;
 b=EztkBnb35lSh3cTFQATRKper2Fn5Aut02Ccmad7EyJnlZypn0udIzqBtL4j1vb4/ihptQP7gaX6tSEP+qiLjCnj6PtsiKink+jSP3Ivv+hqgSpCFawCKxWlVhB6rX1by9oI5eJujmNzV8K8LzsrWyQi89X07L7sD7Oxt4/xLN5D739M+I6/weUZeNW6tVxiIU7qKsaVBeIg0AXauijh+wSECL+kt6ZuKXlGr29eej9qO3I7qYPIcjdl/j2YL6AF/3uEle7O/FIh7zwUTxh8fi4RCghEjqHgBgRuzn3lE/z/0eE9LmObMhro+SqY7k5g7v6mulD2AmxXplxrmsp90HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=victronenergy.com; dmarc=pass action=none
 header.from=victronenergy.com; dkim=pass header.d=victronenergy.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=victronenergy.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZpGfrvwGYP+IlQpLYptN100mTuNKGbYwHtuM60Utivc=;
 b=s/eArL3cZ5NrudfN7k3I/1r3HQZu3nlsMYocFRO9ZdXae6WS9D3qvE7KGgWP7pH/TLFAY7alPSdBuiH8k30W4X7Fh6YtmGaZP+wDLW2awrN777x4e9S/H9DRa2AXJ7zOBLvBFj8WdPDH1d4Pl0QHM29810qzxg+dMKxRgU+NTiw=
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com (10.173.82.19) by
 VI1PR0701MB2847.eurprd07.prod.outlook.com (10.173.70.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.15; Tue, 24 Sep 2019 18:46:07 +0000
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::dc92:2e0d:561a:fbb1]) by VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::dc92:2e0d:561a:fbb1%8]) with mapi id 15.20.2305.013; Tue, 24 Sep 2019
 18:46:07 +0000
From:   Jeroen Hofstee <jhofstee@victronenergy.com>
To:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     Jeroen Hofstee <jhofstee@victronenergy.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/7] can: ti_hecc: add missing state changes
Thread-Topic: [PATCH 7/7] can: ti_hecc: add missing state changes
Thread-Index: AQHVcwhTFZN1+Mcc4kSaj9AaNLf19Q==
Date:   Tue, 24 Sep 2019 18:46:06 +0000
Message-ID: <20190924184437.10607-8-jhofstee@victronenergy.com>
References: <20190924184437.10607-1-jhofstee@victronenergy.com>
In-Reply-To: <20190924184437.10607-1-jhofstee@victronenergy.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:1c01:3bc5:4e00:c415:8ca2:43df:451e]
x-clientproxiedby: AM0PR01CA0121.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::26) To VI1PR0701MB2623.eurprd07.prod.outlook.com
 (2603:10a6:801:b::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhofstee@victronenergy.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a152517a-45aa-4291-69ed-08d7411f7584
x-ms-traffictypediagnostic: VI1PR0701MB2847:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0701MB2847B1259127234CF27380C5C0840@VI1PR0701MB2847.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0170DAF08C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(366004)(39850400004)(346002)(136003)(396003)(189003)(199004)(81156014)(86362001)(2906002)(2351001)(14454004)(305945005)(478600001)(8676002)(2501003)(36756003)(7736002)(6116002)(25786009)(8936002)(50226002)(81166006)(46003)(76176011)(11346002)(66476007)(6506007)(6916009)(446003)(102836004)(186003)(2616005)(1076003)(6486002)(66946007)(64756008)(486006)(476003)(66556008)(66446008)(5660300002)(54906003)(71200400001)(71190400001)(14444005)(5640700003)(6436002)(52116002)(386003)(4326008)(256004)(316002)(99286004)(6512007);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR0701MB2847;H:VI1PR0701MB2623.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: victronenergy.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SZDYbQVtxLgwQOx0mH80XFAo5mrW6Af/RzR98UMSF3hIMXn22nfvvoGWz/rQD31aQY05RBIJFd9V3rIx2jq5x3OIAjN8mX9UjBqLsO+XQCv0zbJik2iV6alZnlEZvpjhs6Oa/oFmYxYtL7zAxYb5eWHZgMOp7HBzxsN3y8kCm22pm7H4iqavr4MBlxAyiu8ucNdEc6TId2W2ju8ZtW/2MbtU9vGDt+lj8A06Qydrsm0rrv46dYywsa+WkSkFertx96PGNf5+Pd4TaVgLnw4unMBHZCSFnmEQuL1D51RTjEPUBhxG9LMqxTR0FdcnFo7E4DNzYeQ3kJAOQmtkvAY9SUXRaeCYYtfRYWBUn8s1UXYZAqiEwaJr8ugu/w/kIAJRV5fzex8gGLIqofablv3Qr9Y6odYv5eFScG7XjTVi5YE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: victronenergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a152517a-45aa-4291-69ed-08d7411f7584
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2019 18:46:07.0387
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 60b95f08-3558-4e94-b0f8-d690c498e225
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7+5/e2BQifdr6Sf5H3s8ymxoHXpcScFkTPjXWwd58hvENysxBoPr4Bj4uCmZsdK2q2pky66TblL7+I+kMeo3mjN1G9KLUd5YT2d0U7KUPqE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0701MB2847
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While the ti_hecc has interrupts to report when the error counters increase
to a certain level and which change state it doesn't handle the case that
the error counters go down again, so the reported state can actually be
wrong. Since there is no interrupt for that, do update state based on the
error counters, when the state is not error active and goes down again.

Signed-off-by: Jeroen Hofstee <jhofstee@victronenergy.com>
---
 drivers/net/can/ti_hecc.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index 6098725bfdea..c7c866da9c6a 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -689,6 +689,23 @@ static irqreturn_t ti_hecc_interrupt(int irq, void *de=
v_id)
 			can_bus_off(ndev);
 			change_state(priv, rx_state, tx_state);
 		}
+	} else if (unlikely(priv->can.state !=3D CAN_STATE_ERROR_ACTIVE)) {
+		enum can_state new_state, tx_state, rx_state;
+		u32 rec =3D hecc_read(priv, HECC_CANREC);
+		u32 tec =3D hecc_read(priv, HECC_CANTEC);
+
+		if (rec >=3D 128 || tec >=3D 128)
+			new_state =3D CAN_STATE_ERROR_PASSIVE;
+		else if (rec >=3D 96 || tec >=3D 96)
+			new_state =3D CAN_STATE_ERROR_WARNING;
+		else
+			new_state =3D CAN_STATE_ERROR_ACTIVE;
+
+		if (new_state < priv->can.state) {
+			rx_state =3D rec >=3D tec ? new_state : 0;
+			tx_state =3D rec <=3D tec ? new_state : 0;
+			change_state(priv, rx_state, tx_state);
+		}
 	}
=20
 	if (int_status & HECC_CANGIF_GMIF) {
--=20
2.17.1

