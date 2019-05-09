Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9024183F7
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 05:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfEIDHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 23:07:16 -0400
Received: from mail-eopbgr150043.outbound.protection.outlook.com ([40.107.15.43]:61743
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725842AbfEIDHQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 23:07:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nd5mo/ba/LWzkeYGZMFdJsAqytsXGbqwD+pqUGfjiNY=;
 b=c1EYCe79bZjhRczJoaQoVEOzKCUE5xf6FsmtTg7qeImhYo6crDtG5tvUI9zN1TiYWJl0XRCC9QNtBk8kYW0dBz6FEHZelbMuOvTwKViKkP5gNRnFKSzx0+pZOd2cymPx+/PxJg2a8VqBFZC1NfUk/GDqyaOqM7e/Lvdvyg9Tc04=
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com (10.169.132.138) by
 VI1PR0401MB2672.eurprd04.prod.outlook.com (10.168.66.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.20; Thu, 9 May 2019 03:07:12 +0000
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::b091:6395:e853:5986]) by VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::b091:6395:e853:5986%3]) with mapi id 15.20.1878.019; Thu, 9 May 2019
 03:07:12 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        David Miller <davem@davemloft.net>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>
Subject: [PATCH] ptp_qoriq: fix NULL access if ptp dt node missing
Thread-Topic: [PATCH] ptp_qoriq: fix NULL access if ptp dt node missing
Thread-Index: AQHVBhRLhQejDMysqkaJHFxI9olVsQ==
Date:   Thu, 9 May 2019 03:07:12 +0000
Message-ID: <20190509030845.36713-1-yangbo.lu@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HK2PR0401CA0006.apcprd04.prod.outlook.com
 (2603:1096:202:2::16) To VI1PR0401MB2237.eurprd04.prod.outlook.com
 (2603:10a6:800:27::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b3e8ce44-690f-4991-e4de-08d6d42b6e28
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0401MB2672;
x-ms-traffictypediagnostic: VI1PR0401MB2672:
x-microsoft-antispam-prvs: <VI1PR0401MB267288C879875154B23986D8F8330@VI1PR0401MB2672.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1186;
x-forefront-prvs: 003245E729
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(346002)(396003)(39860400002)(376002)(199004)(189003)(26005)(486006)(476003)(2616005)(6512007)(186003)(53936002)(99286004)(6116002)(3846002)(6486002)(4326008)(6436002)(478600001)(36756003)(386003)(25786009)(102836004)(6506007)(14454004)(4744005)(64756008)(66476007)(66946007)(66556008)(256004)(66066001)(86362001)(2501003)(68736007)(52116002)(1076003)(66446008)(316002)(50226002)(8676002)(81156014)(81166006)(8936002)(71190400001)(71200400001)(7736002)(305945005)(54906003)(73956011)(5660300002)(110136005)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0401MB2672;H:VI1PR0401MB2237.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0WieLwX1sv7cPYRpGVRh5J5t+oAYQI0FGk0Rlt26VaGkq12HQbXDLbCaaHq20XB9amUXl61VXiZdaA3WffajZ6ko2zbRsEgVeOSFDL444LXEDpf5z0wKzLDKSItD7h4dlhv2N3L4YgyV4+y8SoAFJBvq0TyNC7x4vezvWm0LBRubQ0sPnfQ8Hz0DrlOaqQ9d2Y9TfUVYy6YGsXT7V0cW73NGNGdcgf6g8wozNp7GSJSGiMGWhjs5Ii8EICbbgNJJ30z/9ovglic2CPEYkYwBe8M8DdsRmkSU80PMGwJu+4I08MmtOT7WHwGu2AKiFOOWifhAzeI/tptlfOHG5e+jI0UFollkDRu3yrNgEyj8EGO7acTGdgy6YlfjGa5sQH96wEbhHsXU5w4JGbSOkab+yDZtxBMgODzXlr9pbmcROZE=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3e8ce44-690f-4991-e4de-08d6d42b6e28
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2019 03:07:12.1704
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2672
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQ2xhdWRpdSBNYW5vaWwgPGNsYXVkaXUubWFub2lsQG54cC5jb20+DQoNCk1ha2Ugc3Vy
ZSBwdHAgZHQgbm9kZSBleGlzdHMgYmVmb3JlIGFjY2Vzc2luZyBpdCBpbiBjYXNlDQpvZiBOVUxM
IHBvaW50ZXIgY2FsbCB0cmFjZS4NCg0KU2lnbmVkLW9mZi1ieTogQ2xhdWRpdSBNYW5vaWwgPGNs
YXVkaXUubWFub2lsQG54cC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBZYW5nYm8gTHUgPHlhbmdiby5s
dUBueHAuY29tPg0KLS0tDQogZHJpdmVycy9wdHAvcHRwX3FvcmlxLmMgfCAzICsrKw0KIDEgZmls
ZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvcHRwL3B0
cF9xb3JpcS5jIGIvZHJpdmVycy9wdHAvcHRwX3FvcmlxLmMNCmluZGV4IDUzNzc1MzYyYWFjNi4u
ZTEwNjQyNDAzYjI1IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9wdHAvcHRwX3FvcmlxLmMNCisrKyBi
L2RyaXZlcnMvcHRwL3B0cF9xb3JpcS5jDQpAQCAtNDY3LDYgKzQ2Nyw5IEBAIGludCBwdHBfcW9y
aXFfaW5pdChzdHJ1Y3QgcHRwX3FvcmlxICpwdHBfcW9yaXEsIHZvaWQgX19pb21lbSAqYmFzZSwN
CiAJdW5zaWduZWQgbG9uZyBmbGFnczsNCiAJdTMyIHRtcl9jdHJsOw0KIA0KKwlpZiAoIW5vZGUp
DQorCQlyZXR1cm4gLUVOT0RFVjsNCisNCiAJcHRwX3FvcmlxLT5iYXNlID0gYmFzZTsNCiAJcHRw
X3FvcmlxLT5jYXBzID0gKmNhcHM7DQogDQotLSANCjIuMTcuMQ0KDQo=
