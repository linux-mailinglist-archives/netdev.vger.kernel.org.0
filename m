Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01B5B27425
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 03:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729808AbfEWBzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 21:55:31 -0400
Received: from mail-eopbgr10082.outbound.protection.outlook.com ([40.107.1.82]:16859
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727305AbfEWBzb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 21:55:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oMZQThgYW5ZlTuOLlsH82EegKDL0ckvUwytQO8RY2ZA=;
 b=b+Qr5jX8HlnRnZGYSGiYb+sDRb9rJz/ZESjTIMCb7dJzCD6Aze7dvI7q+0SNJsclRzvsVpCMEKpTb4uABGXCUclQsV6Uzyl1MEPqCbabjO9aRT8e21jMH5P2NoJa1skXkxjwWs1SCCMqR3LUi2ZP6MvXq56itJn95aDL38MuVk0=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.5.23) by
 VI1PR0402MB3408.eurprd04.prod.outlook.com (52.134.3.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Thu, 23 May 2019 01:55:28 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::4c3e:205:bec9:54ef]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::4c3e:205:bec9:54ef%4]) with mapi id 15.20.1922.013; Thu, 23 May 2019
 01:55:28 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "baruch@tkos.co.il" <baruch@tkos.co.il>,
        Andy Duan <fugang.duan@nxp.com>
Subject: [PATCH net,stable 1/1] net: fec: fix the clk mismatch in failed_reset
 path
Thread-Topic: [PATCH net,stable 1/1] net: fec: fix the clk mismatch in
 failed_reset path
Thread-Index: AQHVEQqYAL104EYqpUagO4lQdTUShQ==
Date:   Thu, 23 May 2019 01:55:28 +0000
Message-ID: <1558576444-25080-2-git-send-email-fugang.duan@nxp.com>
References: <1558576444-25080-1-git-send-email-fugang.duan@nxp.com>
In-Reply-To: <1558576444-25080-1-git-send-email-fugang.duan@nxp.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.7.4
x-clientproxiedby: HK0PR03CA0046.apcprd03.prod.outlook.com
 (2603:1096:203:2f::34) To VI1PR0402MB3600.eurprd04.prod.outlook.com
 (2603:10a6:803:a::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 43392ced-3fd1-48b0-6e48-08d6df21ba98
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3408;
x-ms-traffictypediagnostic: VI1PR0402MB3408:
x-microsoft-antispam-prvs: <VI1PR0402MB3408466F85A83CB4E9CE08A8FF010@VI1PR0402MB3408.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(376002)(39860400002)(346002)(136003)(366004)(189003)(199004)(6436002)(4744005)(316002)(66066001)(2501003)(53936002)(86362001)(68736007)(14454004)(5660300002)(478600001)(6486002)(14444005)(36756003)(6512007)(5640700003)(256004)(71190400001)(71200400001)(2906002)(73956011)(66946007)(66446008)(476003)(2616005)(11346002)(446003)(486006)(64756008)(66556008)(4326008)(66476007)(8676002)(8936002)(186003)(99286004)(50226002)(54906003)(26005)(52116002)(3846002)(305945005)(6116002)(81166006)(81156014)(25786009)(1730700003)(102836004)(6506007)(386003)(76176011)(6916009)(2351001)(7736002)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3408;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tdT1OcXMj69CrjxYzICn++smEWZWjh80hgKbZDS0ydulgcy6LX4Q/GXg20fq7+YRWmAQ1RRMbmyNEiaZGy1ZzaOm7XCcE1N/rL0vZeRBs5G+leYaGWLE9L1RZtU+D3vd8tsGZnhyEshVbKmuxKMOch9Dv7PficvCvZjmlv+BndpB0XIFCkwGHJrqR7UEUnWkKiChE9CaDyEU5iRP2fIfnDMoMQXwk+7ySuMjJ3ORjfkJJEwZ9wcJpJe5eFYWAQrN80P77xgirrCDL4bQPuL33lSHHxJaWv8RI3/O4H2wY7YvK7hCIoXguXUPvo7eAymUlN0MBOb9bAslyre1XLl1nPCUn7r7w1BkZxxkSPk1wJ6dEZx39QohdVrBOXMWiwZ1Ls7rxc8QhdQesgAwzefvuBQ/qJpRcmYP17IsfuLuibM=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43392ced-3fd1-48b0-6e48-08d6df21ba98
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 01:55:28.3057
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rml4IHRoZSBjbGsgbWlzbWF0Y2ggaW4gdGhlIGVycm9yIHBhdGggImZhaWxlZF9yZXNldCIgYmVj
YXVzZQ0KYmVsb3cgZXJyb3IgcGF0aCB3aWxsIGRpc2FibGUgY2xrX2FoYiBhbmQgY2xrX2lwZyBk
aXJlY3RseSwgaXQNCnNob3VsZCB1c2UgcG1fcnVudGltZV9wdXRfbm9pZGxlKCkgaW5zdGVhZCBv
ZiBwbV9ydW50aW1lX3B1dCgpDQp0byBhdm9pZCB0byBjYWxsIHJ1bnRpbWUgcmVzdW1lIGNhbGxi
YWNrLg0KDQpSZXBvcnRlZC1ieTogQmFydWNoIFNpYWNoIDxiYXJ1Y2hAdGtvcy5jby5pbD4NClNp
Z25lZC1vZmYtYnk6IEZ1Z2FuZyBEdWFuIDxmdWdhbmcuZHVhbkBueHAuY29tPg0KLS0tDQogZHJp
dmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2ZlY19tYWluLmMgfCAyICstDQogMSBmaWxlIGNo
YW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2ZyZWVzY2FsZS9mZWNfbWFpbi5jDQppbmRleCBmNjNlYjJiLi44NDhkZWZhIDEwMDY0NA0K
LS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2ZlY19tYWluLmMNCisrKyBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNfbWFpbi5jDQpAQCAtMzU1NSw3ICszNTU1
LDcgQEAgZmVjX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQogCWlmIChmZXAt
PnJlZ19waHkpDQogCQlyZWd1bGF0b3JfZGlzYWJsZShmZXAtPnJlZ19waHkpOw0KIGZhaWxlZF9y
ZXNldDoNCi0JcG1fcnVudGltZV9wdXQoJnBkZXYtPmRldik7DQorCXBtX3J1bnRpbWVfcHV0X25v
aWRsZSgmcGRldi0+ZGV2KTsNCiAJcG1fcnVudGltZV9kaXNhYmxlKCZwZGV2LT5kZXYpOw0KIGZh
aWxlZF9yZWd1bGF0b3I6DQogCWNsa19kaXNhYmxlX3VucHJlcGFyZShmZXAtPmNsa19haGIpOw0K
LS0gDQoyLjcuNA0KDQo=
