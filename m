Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA561282BD
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 20:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727462AbfLTTbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 14:31:19 -0500
Received: from mail-eopbgr70089.outbound.protection.outlook.com ([40.107.7.89]:34755
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727402AbfLTTbS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Dec 2019 14:31:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fJeu3TvvkB9v7BNI+hkJZl50PITsqmw108CXFBqrPHeY7SXiP2iYou+1n6YPryM33ChRjwibWnEzVrLMsCKkmRZfEKsslUhEXeL0+JnvKoFnc6lrCUE0GdyAXVSdGp3luWTlHui20TeV8EpZMSM5OnLm+0SpRCl0pvDX5ByFdC8MnWAYrOKUBsECPoukmlWl7hyBnvrFrEh5lyCNkGlDpS1Y76aIz2MEAUSW+YCsch6ak963oTf2dIwT4SpmU1QKt557OQO2/4HeY0ZKKHbrOBj6zyd5g9o37vWCML3Fu2+kjr22bN9FbH7UzHivI2qzL8fU7r3+bFJo7eLYAC8gfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lccFWoAvYTJAtmgVGZWiZYzDECeiEo2EkfSBlaOi6go=;
 b=fOQ8L6FqrOq8o/zHHcQJL7xBmBCJthvLwM5Bi6vzQN6kAAIva1lW79tdkmklN3JJ4jjXAVdLoptdHxBZyP+bB3VhVyawYaoUwJeqvSXim+vUUVwIbHtUj5yvxb2q8X0lbJ+cWOIcvffEdAblUQqRV7f/9YEAO0L96hJSlsTTeao6QpIprPx2N7vti6ACt9JkZViHKOuUVkQndec6BnNWcnpyPygZiQ7a5tlrazjOLeo3cAUvL/ZztYO5E9r7rXGJOi1RPQslFX4ol3eRyggx4q1m9dXRw2Co7YAgeQAYm8ofpYIpDJJMnGf60CSkv5c7oyhffivJ1iqAoYzDeMx6hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lccFWoAvYTJAtmgVGZWiZYzDECeiEo2EkfSBlaOi6go=;
 b=InXeQI/7Tt0eQOyyMn+Vlc72ZZWEIh1LRtRcI+nNYKnEpk1vfKKWYmwfNTDcvlwwMTVUst2ubGnN1R0UOiLmjkzxwW7N5/PC0giAVojo4R0wlWsYCnXPK1lZgea0KnzbieS+OjrBJxW4d+ulwLU4QGhAhefeb43DLhHbmrYzd7c=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4432.eurprd05.prod.outlook.com (52.134.122.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Fri, 20 Dec 2019 19:29:31 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881%5]) with mapi id 15.20.2559.016; Fri, 20 Dec 2019
 19:29:31 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jiri@resnulli.us" <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Aya Levin <ayal@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Moshe Shemesh <moshe@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Michael Guralnik <michaelgur@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>, "leon@kernel.org" <leon@kernel.org>
Subject: Re: [patch net-next 3/4] net: introduce dev_net notifier
 register/unregister variants
Thread-Topic: [patch net-next 3/4] net: introduce dev_net notifier
 register/unregister variants
Thread-Index: AQHVtzIDse/QUVZ6d02dTQ9cGoasSKfDaSqA
Date:   Fri, 20 Dec 2019 19:29:31 +0000
Message-ID: <2f2b193761ed53f8a529a146e544179864076ce2.camel@mellanox.com>
References: <20191220123542.26315-1-jiri@resnulli.us>
         <20191220123542.26315-4-jiri@resnulli.us>
In-Reply-To: <20191220123542.26315-4-jiri@resnulli.us>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.5 (3.32.5-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2bca1fcf-6fc4-4d06-b290-08d78582eff8
x-ms-traffictypediagnostic: VI1PR05MB4432:|VI1PR05MB4432:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB44329C2901418D9DF914B528BE2D0@VI1PR05MB4432.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 025796F161
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(39860400002)(366004)(136003)(396003)(199004)(189003)(76116006)(66946007)(26005)(91956017)(64756008)(6506007)(186003)(4001150100001)(66476007)(110136005)(6512007)(66556008)(2616005)(66446008)(54906003)(81156014)(8676002)(81166006)(316002)(4326008)(36756003)(2906002)(71200400001)(8936002)(478600001)(86362001)(6486002)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4432;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H4eh8l0RkuzQeUiRc8syguMlj30MYuta63yjMK9WEDK/iwaBY+7S4scYMJem+VWEr+fFeEqdZ1EeJshh5bOsCxRmZFbwyrKoFl1coF0TkTVIq7L1opbLLxHdZFB5dLzKITvzZjXxNPKMkjBsFbC7fNYZROCTCgC0dCnMs6puBo933vfcPx2DBv7Y5sX5UjhOyQvKa6C/RY7wMUiNS6K/gt++Vui700XBqJVrwEqTJmstu8iw+r9u0MgS/02NrXHFQmudn6rlI62pT2r1U9jA3kXVCQphz79UBb8tbqGhkqV49HYd9sBPwFm0lD0LpHzXozJAkxdmvF3Zeka0hT42atQNOdx5MNre+0ZTeIBNYwWm6zvhLK6PIjtHpm4glU/drXNvJeiaxZWzjUiHHXYZxl3lZlU4jgZdMia35UtsSIYVeFcAK7Hyam13OA7mHD7W
Content-Type: text/plain; charset="utf-8"
Content-ID: <F006FAA8263A3A42BF102BF04B446262@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bca1fcf-6fc4-4d06-b290-08d78582eff8
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2019 19:29:31.3161
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fVEaboSYDJP/mXjHii1c7U1QnhmykMUb8ZxRSUWvY+f/jQQnuePzieuB0kwISDJfoqI+MlLwZHTYiicNRdrrGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4432
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTEyLTIwIGF0IDEzOjM1ICswMTAwLCBKaXJpIFBpcmtvIHdyb3RlOg0KPiBG
cm9tOiBKaXJpIFBpcmtvIDxqaXJpQG1lbGxhbm94LmNvbT4NCj4gDQo+IEludHJvZHVjZSBkZXZf
bmV0IHZhcmlhbnRzIG9mIG5ldGRldiBub3RpZmllciByZWdpc3Rlci91bnJlZ2lzdGVyDQo+IGZ1
bmN0aW9ucw0KPiBhbmQgYWxsb3cgcGVyLW5ldCBub3RpZmllciB0byBmb2xsb3cgdGhlIG5ldGRl
dmljZSBpbnRvIHRoZSBuYW1lc3BhY2UNCj4gaXQgaXMNCj4gbW92ZWQgdG8uDQo+IA0KPiBTaWdu
ZWQtb2ZmLWJ5OiBKaXJpIFBpcmtvIDxqaXJpQG1lbGxhbm94LmNvbT4NCj4gLS0tDQo+ICBpbmNs
dWRlL2xpbnV4L25ldGRldmljZS5oIHwgMTcgKysrKysrKysrKysrKysrDQo+ICBuZXQvY29yZS9k
ZXYuYyAgICAgICAgICAgIHwgNDYNCj4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDYzIGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYg
LS1naXQgYS9pbmNsdWRlL2xpbnV4L25ldGRldmljZS5oIGIvaW5jbHVkZS9saW51eC9uZXRkZXZp
Y2UuaA0KPiBpbmRleCA3YThlZDExZjVkNDUuLjg5Y2NkNGM4ZDllYSAxMDA2NDQNCj4gLS0tIGEv
aW5jbHVkZS9saW51eC9uZXRkZXZpY2UuaA0KPiArKysgYi9pbmNsdWRlL2xpbnV4L25ldGRldmlj
ZS5oDQo+IEBAIC05MzcsNiArOTM3LDExIEBAIHN0cnVjdCBuZXRkZXZfbmFtZV9ub2RlIHsNCj4g
IGludCBuZXRkZXZfbmFtZV9ub2RlX2FsdF9jcmVhdGUoc3RydWN0IG5ldF9kZXZpY2UgKmRldiwg
Y29uc3QgY2hhcg0KPiAqbmFtZSk7DQo+ICBpbnQgbmV0ZGV2X25hbWVfbm9kZV9hbHRfZGVzdHJv
eShzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LCBjb25zdCBjaGFyDQo+ICpuYW1lKTsNCj4gIA0KPiAr
c3RydWN0IG5ldGRldl9uZXRfbm90aWZpZXIgew0KPiArCXN0cnVjdCBsaXN0X2hlYWQgbGlzdDsN
Cj4gKwlzdHJ1Y3Qgbm90aWZpZXJfYmxvY2sgKm5iOw0KPiArfTsNCj4gKw0KPiAgLyoNCj4gICAq
IFRoaXMgc3RydWN0dXJlIGRlZmluZXMgdGhlIG1hbmFnZW1lbnQgaG9va3MgZm9yIG5ldHdvcmsg
ZGV2aWNlcy4NCj4gICAqIFRoZSBmb2xsb3dpbmcgaG9va3MgY2FuIGJlIGRlZmluZWQ7IHVubGVz
cyBub3RlZCBvdGhlcndpc2UsIHRoZXkNCj4gYXJlDQo+IEBAIC0xNzkwLDYgKzE3OTUsMTAgQEAg
ZW51bSBuZXRkZXZfcHJpdl9mbGFncyB7DQo+ICAgKg0KPiAgICoJQHdvbF9lbmFibGVkOglXYWtl
LW9uLUxBTiBpcyBlbmFibGVkDQo+ICAgKg0KPiArICoJQG5ldF9ub3RpZmllcl9saXN0OglMaXN0
IG9mIHBlci1uZXQgbmV0ZGV2IG5vdGlmaWVyIGJsb2NrDQo+ICsgKgkJCQl0aGF0IGZvbGxvdyB0
aGlzIGRldmljZSB3aGVuIGl0IGlzDQo+IG1vdmVkDQo+ICsgKgkJCQl0byBhbm90aGVyIG5ldHdv
cmsgbmFtZXNwYWNlLg0KPiArICoNCj4gICAqCUZJWE1FOiBjbGVhbnVwIHN0cnVjdCBuZXRfZGV2
aWNlIHN1Y2ggdGhhdCBuZXR3b3JrIHByb3RvY29sDQo+IGluZm8NCj4gICAqCW1vdmVzIG91dC4N
Cj4gICAqLw0KPiBAQCAtMjA4MCw2ICsyMDg5LDggQEAgc3RydWN0IG5ldF9kZXZpY2Ugew0KPiAg
CXN0cnVjdCBsb2NrX2NsYXNzX2tleQlhZGRyX2xpc3RfbG9ja19rZXk7DQo+ICAJYm9vbAkJCXBy
b3RvX2Rvd247DQo+ICAJdW5zaWduZWQJCXdvbF9lbmFibGVkOjE7DQo+ICsNCj4gKwlzdHJ1Y3Qg
bGlzdF9oZWFkCW5ldF9ub3RpZmllcl9saXN0Ow0KPiAgfTsNCj4gICNkZWZpbmUgdG9fbmV0X2Rl
dihkKSBjb250YWluZXJfb2YoZCwgc3RydWN0IG5ldF9kZXZpY2UsIGRldikNCj4gIA0KPiBAQCAt
MjUyMyw2ICsyNTM0LDEyIEBAIGludCB1bnJlZ2lzdGVyX25ldGRldmljZV9ub3RpZmllcihzdHJ1
Y3QNCj4gbm90aWZpZXJfYmxvY2sgKm5iKTsNCj4gIGludCByZWdpc3Rlcl9uZXRkZXZpY2Vfbm90
aWZpZXJfbmV0KHN0cnVjdCBuZXQgKm5ldCwgc3RydWN0DQo+IG5vdGlmaWVyX2Jsb2NrICpuYik7
DQo+ICBpbnQgdW5yZWdpc3Rlcl9uZXRkZXZpY2Vfbm90aWZpZXJfbmV0KHN0cnVjdCBuZXQgKm5l
dCwNCj4gIAkJCQkgICAgICBzdHJ1Y3Qgbm90aWZpZXJfYmxvY2sgKm5iKTsNCj4gK2ludCByZWdp
c3Rlcl9uZXRkZXZpY2Vfbm90aWZpZXJfZGV2X25ldChzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LA0K
PiArCQkJCQlzdHJ1Y3Qgbm90aWZpZXJfYmxvY2sgKm5iLA0KPiArCQkJCQlzdHJ1Y3QgbmV0ZGV2
X25ldF9ub3RpZmllcg0KPiAqbm4pOw0KPiAraW50IHVucmVnaXN0ZXJfbmV0ZGV2aWNlX25vdGlm
aWVyX2Rldl9uZXQoc3RydWN0IG5ldF9kZXZpY2UgKmRldiwNCj4gKwkJCQkJICBzdHJ1Y3Qgbm90
aWZpZXJfYmxvY2sgKm5iLA0KPiArCQkJCQkgIHN0cnVjdCBuZXRkZXZfbmV0X25vdGlmaWVyDQo+
ICpubik7DQo+ICANCj4gIHN0cnVjdCBuZXRkZXZfbm90aWZpZXJfaW5mbyB7DQo+ICAJc3RydWN0
IG5ldF9kZXZpY2UJKmRldjsNCj4gZGlmZiAtLWdpdCBhL25ldC9jb3JlL2Rldi5jIGIvbmV0L2Nv
cmUvZGV2LmMNCj4gaW5kZXggOTMyZWUxMzFjOGM5Li5mNTlkMjExNmRiOGQgMTAwNjQ0DQo+IC0t
LSBhL25ldC9jb3JlL2Rldi5jDQo+ICsrKyBiL25ldC9jb3JlL2Rldi5jDQo+IEBAIC0xODc0LDYg
KzE4NzQsNDggQEAgaW50IHVucmVnaXN0ZXJfbmV0ZGV2aWNlX25vdGlmaWVyX25ldChzdHJ1Y3QN
Cj4gbmV0ICpuZXQsDQo+ICB9DQo+ICBFWFBPUlRfU1lNQk9MKHVucmVnaXN0ZXJfbmV0ZGV2aWNl
X25vdGlmaWVyX25ldCk7DQo+ICANCj4gK2ludCByZWdpc3Rlcl9uZXRkZXZpY2Vfbm90aWZpZXJf
ZGV2X25ldChzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LA0KPiArCQkJCQlzdHJ1Y3Qgbm90aWZpZXJf
YmxvY2sgKm5iLA0KPiArCQkJCQlzdHJ1Y3QgbmV0ZGV2X25ldF9ub3RpZmllciAqbm4pDQo+ICt7
DQo+ICsJaW50IGVycjsNCj4gKw0KPiArCXJ0bmxfbG9jaygpOw0KPiArCWVyciA9IF9fcmVnaXN0
ZXJfbmV0ZGV2aWNlX25vdGlmaWVyX25ldChkZXZfbmV0KGRldiksIG5iLA0KPiBmYWxzZSk7DQo+
ICsJaWYgKCFlcnIpIHsNCj4gKwkJbm4tPm5iID0gbmI7DQoNCmxvb2tzIGxpa2UgdGhlcmUgaXMg
MSB0byAxIG1hcHBpbmcgYmV0d2VlbiBubiBhbmQgbmIsIA0KdG8gc2F2ZSB0aGUgZHJpdmVyIGRl
dmVsb3BlcnMgdGhlIGhlYWRhY2hlIG9mIGRlYWxpbmcgd2l0aCB0d28gb2JqZWN0cw0KanVzdCBl
bWJlZCB0aGUgbmIgb2JqZWN0IGludG8gdGhlIG5uIG9iamVjdCBhbmQgbGV0IHRoZSBkcml2ZXIg
ZGVhbA0Kd2l0aCBubiBvYmplY3RzIG9ubHkuDQoNCj4gKwkJbGlzdF9hZGQoJm5uLT5saXN0LCAm
ZGV2LT5uZXRfbm90aWZpZXJfbGlzdCk7DQo+ICsJfQ0KPiArCXJ0bmxfdW5sb2NrKCk7DQo+ICsJ
cmV0dXJuIGVycjsNCj4gK30NCj4gK0VYUE9SVF9TWU1CT0wocmVnaXN0ZXJfbmV0ZGV2aWNlX25v
dGlmaWVyX2Rldl9uZXQpOw0KPiArDQo+ICtpbnQgdW5yZWdpc3Rlcl9uZXRkZXZpY2Vfbm90aWZp
ZXJfZGV2X25ldChzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LA0KPiArCQkJCQkgIHN0cnVjdCBub3Rp
Zmllcl9ibG9jayAqbmIsDQo+ICsJCQkJCSAgc3RydWN0IG5ldGRldl9uZXRfbm90aWZpZXINCj4g
Km5uKQ0KPiArew0KPiArCWludCBlcnI7DQo+ICsNCj4gKwlydG5sX2xvY2soKTsNCj4gKwlsaXN0
X2RlbCgmbm4tPmxpc3QpOw0KPiArCWVyciA9IF9fdW5yZWdpc3Rlcl9uZXRkZXZpY2Vfbm90aWZp
ZXJfbmV0KGRldl9uZXQoZGV2KSwgbmIpOw0KPiArCXJ0bmxfdW5sb2NrKCk7DQo+ICsJcmV0dXJu
IGVycjsNCj4gK30NCj4gK0VYUE9SVF9TWU1CT0wodW5yZWdpc3Rlcl9uZXRkZXZpY2Vfbm90aWZp
ZXJfZGV2X25ldCk7DQo+ICsNCj4gK3N0YXRpYyB2b2lkIG1vdmVfbmV0ZGV2aWNlX25vdGlmaWVy
c19kZXZfbmV0KHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsDQo+ICsJCQkJCSAgICAgc3RydWN0IG5l
dCAqbmV0KQ0KPiArew0KPiArCXN0cnVjdCBuZXRkZXZfbmV0X25vdGlmaWVyICpubjsNCj4gKw0K
PiArCWxpc3RfZm9yX2VhY2hfZW50cnkobm4sICZkZXYtPm5ldF9ub3RpZmllcl9saXN0LCBsaXN0
KSB7DQo+ICsJCV9fdW5yZWdpc3Rlcl9uZXRkZXZpY2Vfbm90aWZpZXJfbmV0KGRldl9uZXQoZGV2
KSwgbm4tDQo+ID5uYik7DQo+ICsJCV9fcmVnaXN0ZXJfbmV0ZGV2aWNlX25vdGlmaWVyX25ldChu
ZXQsIG5uLT5uYiwgdHJ1ZSk7DQo+ICsJfQ0KPiArfQ0KPiArDQo+ICAvKioNCj4gICAqCWNhbGxf
bmV0ZGV2aWNlX25vdGlmaWVyc19pbmZvIC0gY2FsbCBhbGwgbmV0d29yayBub3RpZmllcg0KPiBi
bG9ja3MNCj4gICAqCUB2YWw6IHZhbHVlIHBhc3NlZCB1bm1vZGlmaWVkIHRvIG5vdGlmaWVyIGZ1
bmN0aW9uDQo+IEBAIC05NzcwLDYgKzk4MTIsNyBAQCBzdHJ1Y3QgbmV0X2RldmljZSAqYWxsb2Nf
bmV0ZGV2X21xcyhpbnQNCj4gc2l6ZW9mX3ByaXYsIGNvbnN0IGNoYXIgKm5hbWUsDQo+ICAJSU5J
VF9MSVNUX0hFQUQoJmRldi0+YWRqX2xpc3QubG93ZXIpOw0KPiAgCUlOSVRfTElTVF9IRUFEKCZk
ZXYtPnB0eXBlX2FsbCk7DQo+ICAJSU5JVF9MSVNUX0hFQUQoJmRldi0+cHR5cGVfc3BlY2lmaWMp
Ow0KPiArCUlOSVRfTElTVF9IRUFEKCZkZXYtPm5ldF9ub3RpZmllcl9saXN0KTsNCj4gICNpZmRl
ZiBDT05GSUdfTkVUX1NDSEVEDQo+ICAJaGFzaF9pbml0KGRldi0+cWRpc2NfaGFzaCk7DQo+ICAj
ZW5kaWYNCj4gQEAgLTEwMDMxLDYgKzEwMDc0LDkgQEAgaW50IGRldl9jaGFuZ2VfbmV0X25hbWVz
cGFjZShzdHJ1Y3QNCj4gbmV0X2RldmljZSAqZGV2LCBzdHJ1Y3QgbmV0ICpuZXQsIGNvbnN0IGNo
YXINCj4gIAlrb2JqZWN0X3VldmVudCgmZGV2LT5kZXYua29iaiwgS09CSl9SRU1PVkUpOw0KPiAg
CW5ldGRldl9hZGphY2VudF9kZWxfbGlua3MoZGV2KTsNCj4gIA0KPiArCS8qIE1vdmUgcGVyLW5l
dCBuZXRkZXZpY2Ugbm90aWZpZXJzIHRoYXQgYXJlIGZvbGxvd2luZyB0aGUNCj4gbmV0ZGV2aWNl
ICovDQo+ICsJbW92ZV9uZXRkZXZpY2Vfbm90aWZpZXJzX2Rldl9uZXQoZGV2LCBuZXQpOw0KPiAr
DQo+ICAJLyogQWN0dWFsbHkgc3dpdGNoIHRoZSBuZXR3b3JrIG5hbWVzcGFjZSAqLw0KPiAgCWRl
dl9uZXRfc2V0KGRldiwgbmV0KTsNCj4gIAlkZXYtPmlmaW5kZXggPSBuZXdfaWZpbmRleDsNCg==
