Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 766CB27A56B
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 04:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgI1C3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 22:29:17 -0400
Received: from mail-db8eur05on2054.outbound.protection.outlook.com ([40.107.20.54]:12640
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726328AbgI1C3R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Sep 2020 22:29:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MACfYqgGs86dbQ7OwRB5mUywfx2VTPT7iO5NDk8DcQBGMOD3jWPBEf/0EcJC9pasxQCUvMgXmU5+KsQEvHf5fGoRseqil6hwrtGDj/ujSMLJNGr+RByOo2pdKYlxFcY0qBBkikjzhBs5GgdiSRCvOLH9FBnctRR1l9nxPo6N3uWGng5ZmpYSevpqLizDPVD8QqUpPv6zEjjz0ol2BO3tvItZ01/OvB4J89uo14g5+iXgBVAKUk4hgrpYzJN/kF202BSqBW/eaZZm7CQ7PIRiW8PeEeG04Uj+T3McXNJgnIgg3gi/s9bVhULep7o/Zm+ALi4bUO7RpjfSQXcBMsJosw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lmAUef2Vx9j+5961u+8skpFTi70MHq58hgeh7kfUXkA=;
 b=bl024uyYsp1Fsd6MceiDyvtiH0OO1SSX+FhPijJFrz++XrjXJT8PHy8uOXKd+XW2NsIGVrdUI28MAlOKrCYSwiIG0MQ7LxyQAP2RgE+rhnTcdVZxULhlvJMI53ZxxL6rAl4hiLr6+T0KHUKv4P6lodREnzbaKPBj4WFflPb7jUPM4AcDrI8MOBBCp/F1myLGHcMIJEMLN1b6inGlbYeHpjy+V7FbT+4eefYxd2nP1d6+mdqvgwlCbi+kMRJaG3ZEv4Xbwoyz7SJYSSnrwFjl7zluOmlDY3JPWNO/xdS8OEeUWWngNqcrV2BSfgACPwX4MqSjMFXz0MqX+9RUAWWUaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lmAUef2Vx9j+5961u+8skpFTi70MHq58hgeh7kfUXkA=;
 b=E6slRh3zZHfJrZPHDMhV2mSS6LehPuuvM+ldhnqEH0T2DhR9oXTDOX9sMMNv3zuCC3494hNz3ay7X1IQtYYbGhnOrGx3hyTHF/fa8cYJKMsGdTClQamxQ59E+pKvxxy+J1a7as2Cpq2EnFZQYWucfbtr4Qb66lTZ+FcC7+VpikU=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB5788.eurprd04.prod.outlook.com (2603:10a6:10:b1::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Mon, 28 Sep
 2020 02:29:14 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.029; Mon, 28 Sep 2020
 02:29:14 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH V2 1/3] can: flexcan: initialize all flexcan memory for
 ECC function
Thread-Topic: [PATCH V2 1/3] can: flexcan: initialize all flexcan memory for
 ECC function
Thread-Index: AQHWlKVNGxBuk+dVOE+HzIioencc0Kl8564AgABtCyA=
Date:   Mon, 28 Sep 2020 02:29:14 +0000
Message-ID: <DB8PR04MB6795C350DB0CCFF56787561CE6350@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20200927160801.28569-1-qiangqing.zhang@nxp.com>
 <20200927160801.28569-2-qiangqing.zhang@nxp.com>
 <34240503-1d9e-9b8c-cdd0-28482ea60fbf@pengutronix.de>
In-Reply-To: <34240503-1d9e-9b8c-cdd0-28482ea60fbf@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 75d39b37-2353-4017-134b-08d863564ab7
x-ms-traffictypediagnostic: DB8PR04MB5788:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB5788056EE9E7E58D504D0B4EE6350@DB8PR04MB5788.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Sxo9mfpxMPPNLXTVj00/lNg2am5njuRSzoXiFS6JYPfF/fcWOkceQ9S5+xdb1cV0PFpRArfNxKNtFkaSRYGUNF15sBVfQlQ4AK+zNtoZoPXpIOg9LdogP04dui0+SStvK1ACd8pseVMvukPyvjTfRrvJX2FsRTw3aD/1q+vOt83ubDfse/BcrPkp4Hp+2/OhR9DIlXxUL3qUkFn1dDOFEhPGI47d+Vl+H0MU+QWkKfnPwz8AAszBxmeMOjXa3LPnFyPWN/wuJRo3qnuC3MW3ZyOxwtxRb5xJE51GBBT1V7ddAHdZW1QfMKptiOd3plzuIYnT6pqthfndwgmslK7gHQuZBjU4ra1AZkV4QWME3Vf3O34B0nmmz9Us7/3HOwNTc1xshMuHYOvcgYYc7+5YrLx2055ZO+DyiIXee4HTNx9FvbPyOs7vj4bWLYO+CjJgwbeB1lR5M1blesjVyYjkdA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(346002)(366004)(136003)(9686003)(76116006)(66446008)(64756008)(4326008)(8676002)(66556008)(66476007)(54906003)(7696005)(83380400001)(66946007)(186003)(55016002)(8936002)(52536014)(83080400001)(316002)(110136005)(26005)(478600001)(33656002)(5660300002)(86362001)(966005)(71200400001)(2906002)(53546011)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: IxaT5fTF2j0E3m8RT9LS2rufq5she2X+SJStm5yicllYVaT2lLgPBdGFU9uhg78XraiSJx/PL1UogafqBYSP+0kbPSyIrzbX7YvmpJsi2wvkTDPGDaWEUzucJLYW4Yqrx/DF9V6TX4xRczbdRxfpqVLsMMnjfqgNgNe7DeaoKI6sk0AYQpt8K0ag9xL4rfwJHurBytijOSL6mcmkDNGF1aTdbb52/U4leLceymzblrq7PuM5KmZhTPzklvZoo0g0OiOk9+gJIemFFet+OzzWBunu5ToDtMSdxubla1n6wlCAzZty4eSvY8leMs4ry7rEwQ7sSTsFnhcB25uTVxSqM94Ak7YROfR5a6ErcTSWEm7YqxuYjonoCxUtVCLomH0t2NAYq7Cc0ORm6l7HBERAWt5+ck/OKA8ZLqD9Q5XDpuzlwZzh3FBfsrgweqWxhoUj5d5gCsOsnDHBn67ogxbkrC/muo7kDXbCB9G5hpfWGxim0/HkThjAraC71EbB6rGgwDhihRGXkMARswD7FCYDIjX7LZH8KPFHJO/6wvJUWB3MDAJaEAyjJ/1W7HyRHdpsWNNsXh+o8lZYBy+3wwAhcsodUUAqxltzWMmv8P/VRY9nyd2GDQ9rLM0DB9XMpInLmcuVeqLVCv6rM741RkFIBw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75d39b37-2353-4017-134b-08d863564ab7
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2020 02:29:14.4047
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +Gyjg7AKPRTuewHW1lYCSKnbPj7muZlUwy5vlRO/BlsJeNHXdcXaVlDn379QG6hoEKVLer3xVNHSV96vL8OzIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5788
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMgS2xlaW5lLUJ1ZGRl
IDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMjDlubQ55pyIMjjml6UgMzo1OA0KPiBU
bzogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT47IGxpbnV4LWNhbkB2Z2Vy
Lmtlcm5lbC5vcmcNCj4gQ2M6IGRsLWxpbnV4LWlteCA8bGludXgtaW14QG54cC5jb20+OyBuZXRk
ZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggVjIgMS8zXSBjYW46IGZs
ZXhjYW46IGluaXRpYWxpemUgYWxsIGZsZXhjYW4gbWVtb3J5IGZvciBFQ0MNCj4gZnVuY3Rpb24N
Cj4gDQo+IE9uIDkvMjcvMjAgNjowNyBQTSwgSm9ha2ltIFpoYW5nIHdyb3RlOg0KPiBbLi4uXQ0K
PiANCj4gPiArc3RhdGljIHZvaWQgZmxleGNhbl9pbml0X3JhbShzdHJ1Y3QgbmV0X2RldmljZSAq
ZGV2KSB7DQo+ID4gKwlzdHJ1Y3QgZmxleGNhbl9wcml2ICpwcml2ID0gbmV0ZGV2X3ByaXYoZGV2
KTsNCj4gPiArCXN0cnVjdCBmbGV4Y2FuX3JlZ3MgX19pb21lbSAqcmVncyA9IHByaXYtPnJlZ3M7
DQo+ID4gKwl1MzIgcmVnX2N0cmwyOw0KPiA+ICsJaW50IGk7DQo+ID4gKw0KPiA+ICsJLyogMTEu
OC4zLjEzIERldGVjdGlvbiBhbmQgY29ycmVjdGlvbiBvZiBtZW1vcnkgZXJyb3JzOg0KPiA+ICsJ
ICogQ1RSTDJbV1JNRlJaXSBncmFudHMgd3JpdGUgYWNjZXNzIHRvIGFsbCBtZW1vcnkgcG9zaXRp
b25zIHRoYXQNCj4gPiArCSAqIHJlcXVpcmUgaW5pdGlhbGl6YXRpb24sIHJhbmdpbmcgZnJvbSAw
eDA4MCB0byAweEFERiBhbmQNCj4gPiArCSAqIGZyb20gMHhGMjggdG8gMHhGRkYgd2hlbiB0aGUg
Q0FOIEZEIGZlYXR1cmUgaXMgZW5hYmxlZC4NCj4gPiArCSAqIFRoZSBSWE1HTUFTSywgUlgxNE1B
U0ssIFJYMTVNQVNLLCBhbmQgUlhGR01BU0sgcmVnaXN0ZXJzDQo+IG5lZWQgdG8NCj4gPiArCSAq
IGJlIGluaXRpYWxpemVkIGFzIHdlbGwuIE1DUltSRkVOXSBtdXN0IG5vdCBiZSBzZXQgZHVyaW5n
IG1lbW9yeQ0KPiA+ICsJICogaW5pdGlhbGl6YXRpb24uDQo+ID4gKwkgKi8NCj4gPiArCXJlZ19j
dHJsMiA9IHByaXYtPnJlYWQoJnJlZ3MtPmN0cmwyKTsNCj4gPiArCXJlZ19jdHJsMiB8PSBGTEVY
Q0FOX0NUUkwyX1dSTUZSWjsNCj4gPiArCXByaXYtPndyaXRlKHJlZ19jdHJsMiwgJnJlZ3MtPmN0
cmwyKTsNCj4gPiArDQo+ID4gKwlmb3IgKGkgPSAwOyBpIDwgcmFtX2luaXRbMF0ubGVuOyBpKysp
DQo+ID4gKwkJcHJpdi0+d3JpdGUoMCwgKHZvaWQgX19pb21lbSAqKXJlZ3MgKyByYW1faW5pdFsw
XS5vZmZzZXQgKw0KPiA+ICtzaXplb2YodTMyKSAqIGkpOw0KPiANCj4gQXMgdGhlIHdyaXRlIGZ1
bmN0aW9uIG9ubHkgZG9lcyBlbmRpYW4gY29udmVyc2lvbiwgYW5kIHlvdSdyZSB3cml0aW5nIDAg
aGVyZS4NCj4gV2hhdCBhYm91dCB1c2luZyBpb3dyaXRlMzJfcmVwKCkgYW5kIGdldCByaWQgb2Yg
dGhlIGZvciBsb29wPw0KDQpUaGFua3MgZm9yIHRoaXMgcG9pbnQsIEkgd2lsbCB1cGRhdGUgaW4g
bmV4dCB2ZXJzaW9uLg0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCj4gTWFyYw0KPiAN
Cj4gLS0NCj4gUGVuZ3V0cm9uaXggZS5LLiAgICAgICAgICAgICAgICAgfCBNYXJjIEtsZWluZS1C
dWRkZSAgICAgICAgICAgfA0KPiBFbWJlZGRlZCBMaW51eCAgICAgICAgICAgICAgICAgICB8IGh0
dHBzOi8vd3d3LnBlbmd1dHJvbml4LmRlICB8DQo+IFZlcnRyZXR1bmcgV2VzdC9Eb3J0bXVuZCAg
ICAgICAgIHwgUGhvbmU6ICs0OS0yMzEtMjgyNi05MjQgICAgIHwNCj4gQW10c2dlcmljaHQgSGls
ZGVzaGVpbSwgSFJBIDI2ODYgfCBGYXg6ICAgKzQ5LTUxMjEtMjA2OTE3LTU1NTUgfA0KDQo=
