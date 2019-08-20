Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D98795C09
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 12:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729395AbfHTKMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 06:12:15 -0400
Received: from mail-eopbgr150071.outbound.protection.outlook.com ([40.107.15.71]:22277
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728414AbfHTKMO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 06:12:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AGFbcu7c3EVLnKClahCzZxWf0qQRUgbNp7pvioAot4NntzF0QOHMMiAutafhDbQOVB6joR5Y8WS/l6G/Dl2T4bsVTC4bqHQtwUNcdovvFBRgS+KCxq5gQfmcWdkiY/6SuDI6Zp1spAf4bGWEVAKlkfH4QNDW7ri+2b4asd3huSJ8SQcgBnJeqY1zqORhPoSKDdgR6cMRQI7edwHtxvbHYmIMifEkLHAq6xmRD1VhJKTBfFmDprA0pDPhqJSgWKjHbgPqtbn47pwnipLb7vr0SqWhMYbpXhWvnXgGA0lOOyQ0QrI2mH1FhBNPqtSTlyFY5t8UW7nnBPbZv45310ynCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o4liLgULSPCJjamHUmOfv+igLYE7QKhC2Kfj7yp9WGc=;
 b=SKpLu/QTBTzmUtDvDBtt+PUixEJgTpwT+ACfGuT4fZ8NKBFNF/VaB4TBjcNXSHcqQF0wS9CtnaWsTYynsh6/utVZrqhRfc/n6IEQtXkaF2vu9OrxOyChDW8mmQNbHFUBhKmAXhKkCICNArxCM0OsGglV2L27Bi5111htBPvxotIlb9FaFf1d0mcVmmPyut46EPAPhM9579wo5uu2sYFzpKRoEx0fkiGsRKC0bX+M0EwDukRoN3G08huUnSFo2pUuYfPYVvN1nou+RfemLofLwZ+kE07tCzaAhnLfrWdAorjHFkqc50IdywStM1qZzFYQ00F/m5CTDVei23WQjvfC8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o4liLgULSPCJjamHUmOfv+igLYE7QKhC2Kfj7yp9WGc=;
 b=O/ijceSE/Sbup69Q8WYEzt/JD86to/O6WY4QirLVY/aRw4yrnrdNiB9eLtN0ACdMZYZbztNm1sgcVzlyaKAvO9/9qMAR4K/BJ/13wsASbYh5PIrPye2kwpAiRnHnARyx9Z4PHnYVcyJTUW/6C/3NYZqcOEuqd9jMqemHp5ojHHw=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4586.eurprd04.prod.outlook.com (52.135.139.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Tue, 20 Aug 2019 10:12:10 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::c8ca:1c9c:6c3:fb6f]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::c8ca:1c9c:6c3:fb6f%4]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 10:12:10 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Sean Nyekjaer <sean@geanix.com>,
        =?utf-8?B?TWFydGluIEh1bmRlYsO4bGw=?= <martin@geanix.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] can: flexcan: free error skb if enqueueing failed
Thread-Topic: [PATCH] can: flexcan: free error skb if enqueueing failed
Thread-Index: AQHVOz6WqaYXqa5m9EaSoEbJSx8JbacEArUAgAAE/EA=
Date:   Tue, 20 Aug 2019 10:12:10 +0000
Message-ID: <DB7PR04MB46189C38B1747F1C3AC4E58FE6AB0@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20190715185308.104333-1-martin@geanix.com>
 <6bddb702-e9ba-1c9e-7d7a-eb974d2e0fdd@geanix.com>
In-Reply-To: <6bddb702-e9ba-1c9e-7d7a-eb974d2e0fdd@geanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 51a6881b-79f0-4a0a-921d-08d72556dd72
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB4586;
x-ms-traffictypediagnostic: DB7PR04MB4586:
x-microsoft-antispam-prvs: <DB7PR04MB45864F21EFAC9E3A0788E843E6AB0@DB7PR04MB4586.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:374;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(346002)(366004)(39860400002)(136003)(13464003)(199004)(189003)(81156014)(81166006)(5660300002)(53936002)(26005)(4326008)(186003)(256004)(6246003)(53546011)(6506007)(305945005)(33656002)(8676002)(102836004)(6116002)(3846002)(25786009)(2906002)(476003)(11346002)(486006)(7736002)(71190400001)(478600001)(8936002)(71200400001)(74316002)(446003)(229853002)(76176011)(14454004)(99286004)(2501003)(110136005)(76116006)(7696005)(86362001)(54906003)(6436002)(66446008)(9686003)(64756008)(66476007)(52536014)(55016002)(66556008)(66066001)(66946007)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4586;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YjvpybF6DCYV4zLOOupDS0QhTWuqXxPRLuAtTcAdwoHZ8DQvw2OrRJzv+K+rRHj2fB7FotGKtceOBKdf/0Q3FJhIW8Lum5ZzB27+kqVbsb2Pn9VMKcbNcsWalTTQKhefhkSdWNs9y1d7cSj1ExtEdnKTFE7L8+QsOfUIeFhEHkfCAyYt1UwKZ9KpQrXCkc+vSlsgs2/bbHEdE1j+xVCmA/fa2t85oFTGwtJ5vQp+pZ51wMX4/mKUVvfvA44iMq1UrLvYVejxaMN/WgGTXLR1IVEgNw85tM5KLWWQH4+uyxVU0b9jZZiK5odrO7Mi05qt6qd1vP3oreRhj4owWTAREkJoKA97M3RT2KSrE7kQvyI0BsQS3tp7rw4UOke2xXUpR6Qft9XOwTDlzQhNdHE2ItnqoIjm1SRlzpY81ZU6cx4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51a6881b-79f0-4a0a-921d-08d72556dd72
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 10:12:10.7685
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AkEOZGLRnztoiyJX1NoIj4APl563DeNIx6FYM0x4vYP8NoAE0Eitv55sp+WO8H1fAcTTj0s7N3SiiMWnKd6CxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4586
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFNlYW4gTnlla2phZXIgPHNl
YW5AZ2Vhbml4LmNvbT4NCj4gU2VudDogMjAxOeW5tDjmnIgyMOaXpSAxNzo1MA0KPiBUbzogTWFy
dGluIEh1bmRlYsO4bGwgPG1hcnRpbkBnZWFuaXguY29tPjsgV29sZmdhbmcgR3JhbmRlZ2dlcg0K
PiA8d2dAZ3JhbmRlZ2dlci5jb20+OyBNYXJjIEtsZWluZS1CdWRkZSA8bWtsQHBlbmd1dHJvbml4
LmRlPjsNCj4gbGludXgtY2FuQHZnZXIua2VybmVsLm9yZw0KPiBDYzogRGF2aWQgUyAuIE1pbGxl
ciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IEpvYWtpbQ0K
PiBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0hd
IGNhbjogZmxleGNhbjogZnJlZSBlcnJvciBza2IgaWYgZW5xdWV1ZWluZyBmYWlsZWQNCj4gDQo+
IENDJ2luZyBKb2FraW0gWmhhbmcNCg0KTG9va3MgZ29vZCwgc28gYWRkIG15IHRhZzoNCkFja2Vk
LWJ5OiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KDQpCZXN0IFJlZ2Fy
ZHMsDQpKb2FraW0gWmhhbmcNCj4gT24gMTUvMDcvMjAxOSAyMC41MywgTWFydGluIEh1bmRlYsO4
bGwgd3JvdGU6DQo+ID4gSWYgdGhlIGNhbGwgdG8gY2FuX3J4X29mZmxvYWRfcXVldWVfc29ydGVk
KCkgZmFpbHMsIHRoZSBwYXNzZWQgc2tiDQo+ID4gaXNuJ3QgY29uc3VtZWQsIHNvIHRoZSBjYWxs
ZXIgbXVzdCBkbyBzby4NCj4gPg0KPiA+IEZpeGVzOiAzMDE2NDc1OWRiMWIgKCJjYW46IGZsZXhj
YW46IG1ha2UgdXNlIG9mIHJ4LW9mZmxvYWQncw0KPiA+IGlycV9vZmZsb2FkX2ZpZm8iKQ0KPiA+
IFNpZ25lZC1vZmYtYnk6IE1hcnRpbiBIdW5kZWLDuGxsIDxtYXJ0aW5AZ2Vhbml4LmNvbT4NCj4g
PiAtLS0NCj4gPiAgIGRyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMgfCA2ICsrKystLQ0KPiA+ICAg
MSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPg0KPiA+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jIGIvZHJpdmVycy9uZXQvY2Fu
L2ZsZXhjYW4uYw0KPiA+IGluZGV4IDFjNjZmYjJhZDc2Yi4uMjFmMzllODA1ZDQyIDEwMDY0NA0K
PiA+IC0tLSBhL2RyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMNCj4gPiArKysgYi9kcml2ZXJzL25l
dC9jYW4vZmxleGNhbi5jDQo+ID4gQEAgLTY4OCw3ICs2ODgsOCBAQCBzdGF0aWMgdm9pZCBmbGV4
Y2FuX2lycV9idXNfZXJyKHN0cnVjdCBuZXRfZGV2aWNlDQo+ICpkZXYsIHUzMiByZWdfZXNyKQ0K
PiA+ICAgCWlmICh0eF9lcnJvcnMpDQo+ID4gICAJCWRldi0+c3RhdHMudHhfZXJyb3JzKys7DQo+
ID4NCj4gPiAtCWNhbl9yeF9vZmZsb2FkX3F1ZXVlX3NvcnRlZCgmcHJpdi0+b2ZmbG9hZCwgc2ti
LCB0aW1lc3RhbXApOw0KPiA+ICsJaWYgKGNhbl9yeF9vZmZsb2FkX3F1ZXVlX3NvcnRlZCgmcHJp
di0+b2ZmbG9hZCwgc2tiLCB0aW1lc3RhbXApKQ0KPiA+ICsJCWtmcmVlX3NrYihza2IpOw0KPiA+
ICAgfQ0KPiA+DQo+ID4gICBzdGF0aWMgdm9pZCBmbGV4Y2FuX2lycV9zdGF0ZShzdHJ1Y3QgbmV0
X2RldmljZSAqZGV2LCB1MzIgcmVnX2VzcikNCj4gPiBAQCAtNzMyLDcgKzczMyw4IEBAIHN0YXRp
YyB2b2lkIGZsZXhjYW5faXJxX3N0YXRlKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsDQo+IHUzMiBy
ZWdfZXNyKQ0KPiA+ICAgCWlmICh1bmxpa2VseShuZXdfc3RhdGUgPT0gQ0FOX1NUQVRFX0JVU19P
RkYpKQ0KPiA+ICAgCQljYW5fYnVzX29mZihkZXYpOw0KPiA+DQo+ID4gLQljYW5fcnhfb2ZmbG9h
ZF9xdWV1ZV9zb3J0ZWQoJnByaXYtPm9mZmxvYWQsIHNrYiwgdGltZXN0YW1wKTsNCj4gPiArCWlm
IChjYW5fcnhfb2ZmbG9hZF9xdWV1ZV9zb3J0ZWQoJnByaXYtPm9mZmxvYWQsIHNrYiwgdGltZXN0
YW1wKSkNCj4gPiArCQlrZnJlZV9za2Ioc2tiKTsNCj4gPiAgIH0NCj4gPg0KPiA+ICAgc3RhdGlj
IGlubGluZSBzdHJ1Y3QgZmxleGNhbl9wcml2ICpyeF9vZmZsb2FkX3RvX3ByaXYoc3RydWN0DQo+
ID4gY2FuX3J4X29mZmxvYWQgKm9mZmxvYWQpDQo+ID4NCg==
