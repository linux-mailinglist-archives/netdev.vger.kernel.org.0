Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6905219BDD
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 12:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbfEJKt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 06:49:58 -0400
Received: from mail-eopbgr10042.outbound.protection.outlook.com ([40.107.1.42]:52548
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727025AbfEJKt6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 May 2019 06:49:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9pNz6vNP2CsDC2k5YiEyT4zvoIV6DNq7AWeZpJwsLVk=;
 b=F/02K0aN+/75HHTloxL54k82gHZ/vgRC1y7T1LSm+7DLxBdijegNUzqFMA4c9bekAZ+cAyZYBXRcgX4Q/VOYgxAyTOWqfCSSei5fsU5D2e2tMF5Cc0PJjU7Ke0Y/McvyT3HmUZ5Dfxzmi0JJRGWY3l4c939B0DAxVUqgZsAmYqU=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.138.152) by
 DB7PR04MB4220.eurprd04.prod.outlook.com (52.135.131.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.12; Fri, 10 May 2019 10:49:53 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::dcff:11e1:ab70:bb81]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::dcff:11e1:ab70:bb81%5]) with mapi id 15.20.1878.022; Fri, 10 May 2019
 10:49:53 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Stefan-gabriel Mirea <stefan-gabriel.mirea@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH V3 0/7] can: flexcan: add CAN FD support for i.MX8
Thread-Topic: [PATCH V3 0/7] can: flexcan: add CAN FD support for i.MX8
Thread-Index: AQHVBx4ZJVETzfIIYUuGFrAohCJp6g==
Date:   Fri, 10 May 2019 10:49:53 +0000
Message-ID: <20190510104639.15170-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR01CA0105.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::31) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:36::24)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cddd029b-ac9f-41ce-3525-08d6d5353b61
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB4220;
x-ms-traffictypediagnostic: DB7PR04MB4220:
x-microsoft-antispam-prvs: <DB7PR04MB42208EBF689B85616B9D56C0E60C0@DB7PR04MB4220.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0033AAD26D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(396003)(136003)(366004)(39860400002)(346002)(189003)(199004)(64756008)(73956011)(3846002)(66556008)(66476007)(53936002)(66446008)(66946007)(6116002)(8936002)(50226002)(6512007)(81156014)(305945005)(25786009)(386003)(102836004)(6506007)(2906002)(6486002)(4326008)(81166006)(6436002)(8676002)(66066001)(4744005)(5660300002)(476003)(316002)(99286004)(52116002)(256004)(14444005)(36756003)(110136005)(54906003)(14454004)(478600001)(186003)(86362001)(26005)(7736002)(2616005)(71190400001)(71200400001)(486006)(68736007)(1076003)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4220;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: sCaU+aOX9GnwnrxVk0o8tomQZp8n8egLrZP1FAoRnnrzdSQV4XYaZw41hFspV8YImtm7GcKFHznGDClDNSg9kZeHOu/dW2Aomi57ia+pM4h/9XUEM6hih8TA59k+HFzrW2IB3OyEjAVVK9q0MFyVVz66RgD8rUFQikstMT7PCUn00QS180M5E0SPGhszrqGVhHeas0JHzjiEqCi557sZ6T3+pbA+Z0+dTIelzneDhM++OQMLyM1gYlMAimVPw3dYU+VIYn0RjMA7X+D/Rs5SmcdRUj666ehgrZ5eB0XmINlK1sHiICggnW4Ip/VWa1MJYTABQZoziChL+q5c2QbR84BK64NeqVkmJ2ptWnYqHp+5/BxobdUW7r8413cKZ5nc3My3v3PYRINYjJXx12DCMwOX8vzBQQhbd8DLo+vDLi4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cddd029b-ac9f-41ce-3525-08d6d5353b61
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2019 10:49:53.1066
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4220
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyYywNCg0KU3RlZmFuLWdhYnJpZWwgTWlyZWEgd2FzIHN1Y2Nlc3NmdWxseSB2YWxpZGF0
ZWQgdGhpcyBwYXRjaCBzZXQgb24gYW4gUzMyVjIzNA0KYmFzZWQgYm9hcmQsIGFuZCBJIGhhdmUg
aW1wcm92ZWQgdGhlIGRyaXZlciB3aXRoIGhpcyB2YWx1YWJsZSBmZWVkYmFjay4NCg0KSSBhbHNv
IHNwbGl0IHRoZSBwYXRjaCBzZXQgaW50byBzbWFsbCBwYXJ0aWNsZSBzaXplIHRoYXQgd2lsbCBl
YXN5IHlvdXINCnBhdGNoIHJldmlldy4NCg0KUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0KDQpEb25n
IEFpc2hlbmcgKDMpOg0KICBjYW46IGZsZXhjYW46IGltcHJvdmUgYml0dGltaW5nIHNldHRpbmcg
Zm9yIGZkIG1vZGUNCiAgY2FuOiBmbGV4Y2FuOiBhZGQgQ0FORkQgQlJTIHN1cHBvcnQNCiAgY2Fu
OiBmbGV4Y2FuOiBhZGQgaW14OHFtIHN1cHBvcnQNCg0KSm9ha2ltIFpoYW5nICg0KToNCiAgY2Fu
OiBmbGV4Y2FuOiBhbGxvY2F0ZSBza2IgaW4gbWFpbGJveF9yZWFkDQogIGNhbjogZmxleGNhbjog
dXNlIHN0cnVjdCBjYW5mZF9mcmFtZSBmb3Igbm9ybWFsIENBTiBmcmFtZQ0KICBjYW46IGZsZXhj
YW46IGFkZCBDQU4gRkQgbW9kZSBzdXBwb3J0DQogIGNhbjogZmxleGNhbjogYWRkIElTTyBDQU4g
RkQgZmVhdHVyZSBzdXBwb3J0DQoNCiBkcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jICAgICAgfCAy
ODMgKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tDQogZHJpdmVycy9uZXQvY2FuL3J4
LW9mZmxvYWQuYyAgIHwgIDMzICsrLS0NCiBpbmNsdWRlL2xpbnV4L2Nhbi9yeC1vZmZsb2FkLmgg
fCAgIDUgKy0NCiAzIGZpbGVzIGNoYW5nZWQsIDI1NSBpbnNlcnRpb25zKCspLCA2NiBkZWxldGlv
bnMoLSkNCg0KLS0gDQoyLjE3LjENCg0K
