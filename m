Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68BF21722BD
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 17:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729879AbgB0QDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 11:03:20 -0500
Received: from mail-eopbgr150078.outbound.protection.outlook.com ([40.107.15.78]:40086
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729153AbgB0QDT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 11:03:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fCIEPeG/FXRMzA4qXdLnoJCqNBpkTd216W6wu6Krr7DDEYMsAcy0kCUd6mfRTe9CuDY+vw8rDEc0JamHe8aVhyrkdQ9SDyBrCxhVLXUjnuWjnbCHya4gS0SDUx9O42DUfXO8AFzEjaVd2UeW0JEvkKQY6q2hlR4+ZQ/9lhU8z7zZ3zmEL3Ibi57tqE5N1b5hHeMQnJYTs1jnVdkjNZ7cLQydlPjozZQxRKr5jwPPUnDCEUKjqY9vlYx4K+ddjlMYL9bJZTAswNHIUq+H7RHyca6OXcKAZ0WDQIKatu7zN1xHZqkaECF2vmcrjkmuwp/cEAie9XnZisdqi+FMC7VD0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3RAmcBpoDKOUWoOOfpnFcFY9nfHjeq+g5DpxsXYSTw=;
 b=eqD7jE1B3fvfLT6w9igaMoBrVTBjbT1McP+JwMVRitvqAIyq4m0jsrg/JfJOzbtmAamBGExDsgkuFmshFBGUOEgx/9wI+4b/e0e2jpLzjwdhPRxoqpMMbGMRGTGU3z5F26AuCgjJ06Jx9El8idqbNywQg8cMDg/92Y4xRC6G2CNJ0WGuugh1Ji0wFaJpugt5AtheomtBc9ASIyn6AhnlOuJh9E//8o1lDgTEmVUwt46ez11HjsgOwk0hABIyZZsT0oqbvlrxpUytkJaMHYSGosqqvdWDqY4oroTXk5zO6PngW71GF+xHifbCtqaqinnZ/88GdbccC3IMpU7iBm6IgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3RAmcBpoDKOUWoOOfpnFcFY9nfHjeq+g5DpxsXYSTw=;
 b=dXpoGXXJcU+Jz1p1vWd0tEJlstC/TV/JMY9zFJ1AR6tZG1rBttGFa4sE15l7QRCQs5CG/HDoIFHoz5OpJJ+K5bbWsR16lGIheyvpIAVL40Kz2udYPCkXf3HbKOtHQ1FAeHBTgSwOQuxnEIMmrS969JwkZZ1+zj+q5pMm7xw2Xsw=
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com (52.133.240.149) by
 DB8PR04MB5659.eurprd04.prod.outlook.com (20.179.10.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Thu, 27 Feb 2020 16:03:16 +0000
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::9484:81c6:c73b:2697]) by DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::9484:81c6:c73b:2697%6]) with mapi id 15.20.2750.024; Thu, 27 Feb 2020
 16:03:16 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
CC:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] dpaa2-eth: add support for mii ioctls
Thread-Topic: [PATCH] dpaa2-eth: add support for mii ioctls
Thread-Index: AQHV7WWBfucVrYx+6UCkpi6ll70YaqgvM9HQ
Date:   Thu, 27 Feb 2020 16:03:15 +0000
Message-ID: <DB8PR04MB682813BEA5BF8D3F9A2E3F26E0EB0@DB8PR04MB6828.eurprd04.prod.outlook.com>
References: <E1j7Hq1-0004Fc-MX@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1j7Hq1-0004Fc-MX@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2f94c28a-308c-4add-68a8-08d7bb9e8e31
x-ms-traffictypediagnostic: DB8PR04MB5659:
x-microsoft-antispam-prvs: <DB8PR04MB56591F36EBC8186CE2175B3BE0EB0@DB8PR04MB5659.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1303;
x-forefront-prvs: 03264AEA72
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(396003)(39860400002)(346002)(376002)(199004)(189003)(55016002)(71200400001)(9686003)(54906003)(316002)(86362001)(2906002)(66446008)(66476007)(7696005)(4326008)(66946007)(33656002)(81156014)(5660300002)(8676002)(52536014)(81166006)(66556008)(8936002)(478600001)(76116006)(26005)(6506007)(44832011)(186003)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB5659;H:DB8PR04MB6828.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: apfPh6nKuRb4Guz5uVrbvtiCsdz/0kFmnZ2dM2femzGFyuJkIAWUX4jFPQsma///7tdKdJXzpOiNlVc55WEKjuWPZiWVmQ9U8IdJOpP/o3j05O+y5qHsaIn6KKpsGn7ldfyYPZsRDXMZOB9I8rlEjJ7cJIB+o5S71enj8nD45ImoDDZ9Nox9MNMdM40vmxiA7jI9ODkBeFNa+pB6/phwytwSJWtkW4F6n/7I7lCfrVEQ2Rtc5zmjMkHVol267JVEzfzDi+9WKWeP8H1buR+8IbKuwaJDocWW1o3Zm+aEeh2oyqB6jRvpmSdBjZCfOLpln8BvgtsRTa5kXYeUh9e1K2EWHZW/E60KTYSJGgbRi4Fd/ka59tcB0jW9yP6UZQx7Q4OdLHf1QQLg0cjtIEjjdprtbARtKLiCHj7KvWHq1mkqBy4dr2mv61fBb6tpzKsi
x-ms-exchange-antispam-messagedata: 1XnGzSjw0jfmGIUIqw4SSaZrkdBby0wotVVVQXT617pzYSifkqfGVhZOsKzls+gVTjNl3uSgtvmrC/VH11DBhf8KpFNzjc15PCZAo3PcBMQoh72FBPB5SkmbokepBSRbvJu7zoJbHsgxQMbyXwLFEQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f94c28a-308c-4add-68a8-08d7bb9e8e31
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2020 16:03:15.9978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GSDnozrBs0JwCHTNKeEuVlvq295jB6h2eO40MhlDc71yTjHQN918YXJdwjUCY/spdO6tNEktfiO86uqe9rxg7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5659
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBTdWJqZWN0OiBbUEFUQ0hdIGRwYWEyLWV0aDogYWRkIHN1cHBvcnQgZm9yIG1paSBpb2N0bHMN
Cj4gDQo+IFNpZ25lZC1vZmYtYnk6IFJ1c3NlbGwgS2luZyA8cm1rK2tlcm5lbEBhcm1saW51eC5v
cmcudWs+DQoNCkFja2VkLWJ5OiBJb2FuYSBDaW9ybmVpIDxpb2FuYS5jaW9ybmVpQG54cC5jb20+
DQoNCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZHBhYTIvZHBhYTIt
ZXRoLmMgfCA3ICsrKysrKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDEg
ZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVl
c2NhbGUvZHBhYTIvZHBhYTItZXRoLmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2Nh
bGUvZHBhYTIvZHBhYTItZXRoLmMNCj4gaW5kZXggNDAyOTBmZWE5ZTM2Li5mMWFiNmJiNWRiNWQg
MTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9kcGFhMi9kcGFh
Mi1ldGguYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZHBhYTIvZHBh
YTItZXRoLmMNCj4gQEAgLTE3MDQsMTAgKzE3MDQsMTUgQEAgc3RhdGljIGludCBkcGFhMl9ldGhf
dHNfaW9jdGwoc3RydWN0IG5ldF9kZXZpY2UNCj4gKmRldiwgc3RydWN0IGlmcmVxICpycSwgaW50
IGNtZCkNCj4gDQo+ICBzdGF0aWMgaW50IGRwYWEyX2V0aF9pb2N0bChzdHJ1Y3QgbmV0X2Rldmlj
ZSAqZGV2LCBzdHJ1Y3QgaWZyZXEgKnJxLCBpbnQgY21kKSAgew0KPiArCXN0cnVjdCBkcGFhMl9l
dGhfcHJpdiAqcHJpdiA9IG5ldGRldl9wcml2KGRldik7DQo+ICsNCj4gIAlpZiAoY21kID09IFNJ
T0NTSFdUU1RBTVApDQo+ICAJCXJldHVybiBkcGFhMl9ldGhfdHNfaW9jdGwoZGV2LCBycSwgY21k
KTsNCj4gDQo+IC0JcmV0dXJuIC1FSU5WQUw7DQo+ICsJaWYgKHByaXYtPm1hYykNCj4gKwkJcmV0
dXJuIHBoeWxpbmtfbWlpX2lvY3RsKHByaXYtPm1hYy0+cGh5bGluaywgcnEsIGNtZCk7DQo+ICsN
Cj4gKwlyZXR1cm4gLUVPUE5PVFNVUFA7DQo+ICB9DQo+IA0KPiAgc3RhdGljIGJvb2wgeGRwX210
dV92YWxpZChzdHJ1Y3QgZHBhYTJfZXRoX3ByaXYgKnByaXYsIGludCBtdHUpDQo+IC0tDQo+IDIu
MjAuMQ0KDQo=
