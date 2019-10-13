Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10745D5852
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 23:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729433AbfJMV05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 17:26:57 -0400
Received: from mail-eopbgr150117.outbound.protection.outlook.com ([40.107.15.117]:46859
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726264AbfJMV04 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Oct 2019 17:26:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j1U1IaOqh7QSDwA+7OL5hny6dAcPYFUV7wppw54/2uBj2Q45uLjy47dpo77GG6Al7GP8X09Z8uq7WL7k6SP7Ar9LpcbfHSQq45PCQ3X+L4kgUOH7+Wy2x2ywDjyK7BOA32pve/uD9l2bgLVGIevrrUN9O7ty9I7jAZOnEGV8QdAgXZKrxQm9zI+IChkFTCHUStfa4SwC+BQdNV6hmrhm+/tdJ6iJUTIGFVMjqaOuCBB43SKeEnDuSnabbWFYNwCtfl7I1xSTMXuar7nvXMa9o7IY9AnsUbP8mId5vTRlprgZE5BmqdwHZk16AYUH0uRyjMujwZpdZhTt8ONvWzqw9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NKGNnMfbEjay2Dkfh9PgHUfSlrIlAf+8lbTdeus0biI=;
 b=PpEKna4xV4owz92xp4EVEqWxpmRq8wdo01vVF4GDA8FVghzjzByMQxey2sRmlG1gCTi9hIKs3QGfZELmbck33LvKqwFJ17LScccswk2mGX8Rtex0a94X4oSrz2SLbIqNItQj6Qkl8Ko+fqEauXBdhZi9hPiEByFYoiVKV/+gHMvSx97YoV5Hp2HY53iIAL7vn/+GMMcnScZCRm+Da9qI15FjXUkDmqD4LUx9T3aHwzTgRzb0l62czfinODCZGHN68Cz4TkjEAk5/AFCSumcuxZ1nY+jBzC+OtRttDZW288Q80R4L5ZW4a/j9RB4/0eLjRkbBZEYDdN6PBlqnDrgLLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=victronenergy.com; dmarc=pass action=none
 header.from=victronenergy.com; dkim=pass header.d=victronenergy.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=victronenergy.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NKGNnMfbEjay2Dkfh9PgHUfSlrIlAf+8lbTdeus0biI=;
 b=cqMtsHzJNdhXWS8Wl4Pdm0ec7XIkmb64cdpaHpoWR2TVCy2yQ6X7TESdlyDpoaylpzDqvywS7mn3JlMYxaGIvatA2i0EcOrXgUU3o63/IhFBt8gGzQsCKe2OU/S4qNK32yi8E0bEgBv/iOLBUQjz7HVLNPzBNl4f9h7G8Xmvcwo=
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com (10.173.82.19) by
 VI1PR0701MB2143.eurprd07.prod.outlook.com (10.169.133.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.13; Sun, 13 Oct 2019 21:26:50 +0000
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::49b7:a244:d3e4:396c]) by VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::49b7:a244:d3e4:396c%9]) with mapi id 15.20.2347.021; Sun, 13 Oct 2019
 21:26:50 +0000
From:   Jeroen Hofstee <jhofstee@victronenergy.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] can: rx-offload: continue on error
Thread-Topic: [PATCH 1/7] can: rx-offload: continue on error
Thread-Index: AQHVcwhCgRg367Eiu0mUgNTGybynuadSYe8AgAbR1wA=
Date:   Sun, 13 Oct 2019 21:26:50 +0000
Message-ID: <f9da9ffb-f4c0-fcc2-17e6-7d11d7aec14f@victronenergy.com>
References: <20190924184437.10607-1-jhofstee@victronenergy.com>
 <20190924184437.10607-2-jhofstee@victronenergy.com>
 <134ddb8e-a231-922d-f554-ca77ce0c16af@pengutronix.de>
In-Reply-To: <134ddb8e-a231-922d-f554-ca77ce0c16af@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
x-originating-ip: [2001:1c01:3bc5:4e00:fc62:6962:688d:c507]
x-clientproxiedby: AM0PR0102CA0067.eurprd01.prod.exchangelabs.com
 (2603:10a6:208::44) To VI1PR0701MB2623.eurprd07.prod.outlook.com
 (2603:10a6:801:b::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhofstee@victronenergy.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba91a5c2-843b-4bbe-96fe-08d750240f4e
x-ms-traffictypediagnostic: VI1PR0701MB2143:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR0701MB21436759AE48BA13CA8C3A0EC0910@VI1PR0701MB2143.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01894AD3B8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39840400004)(346002)(396003)(136003)(366004)(376002)(199004)(189003)(14444005)(54906003)(66446008)(316002)(256004)(229853002)(2501003)(6436002)(71200400001)(71190400001)(66476007)(65806001)(6486002)(11346002)(5660300002)(66556008)(476003)(2616005)(64756008)(65956001)(46003)(58126008)(110136005)(486006)(66946007)(446003)(4326008)(305945005)(7736002)(31686004)(14454004)(25786009)(6512007)(76176011)(86362001)(386003)(6246003)(53546011)(6506007)(102836004)(6306002)(99286004)(36756003)(186003)(966005)(6116002)(31696002)(52116002)(2906002)(8936002)(81156014)(8676002)(81166006)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR0701MB2143;H:VI1PR0701MB2623.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: victronenergy.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CVJHaQE21oJ/HJUtNmI6VLFu2VoAIlu40aiVEke6DKENISCL8+7IKV3S9lZyKalWAR2BTjkZt41QVo5xvNEtoqarnW4hsAwzeFm0DXQ1Dn1Sei1VM4g2CM76zIMYAway4ev842sb+6bqmHdhDE6aVleOy763ypqS2qwHXzEAnsfP/2I9TvHE/ziUyKsFTnWVTMi8nnZ8fcfCINeokhE6H3v/kjMDYj7lGpqZ1k7kFtPuxxrAz1uX961hE+3RTZ3lwUjdMERjBYY0VFQWze/odJwAfTIYjqZ+mTIWQNAMnXUTT40XseonSD1B/FrHVGFowFSObF6pMmBGuzIvdsl7n1cobNg1RpWybU6KRhLndmq0yX5ngLDJfjOpkT6LWiRCw0ghS0LZTxVKE/JmFZfWDr35NulmjScZ6Cwv/UXD41lIK8Mgv1Eh3YcrFy5sXJDql7QaAm/4fQbbUUdb+C2qbw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <3F76F3EB4EE6FA4EA8E7041D135B190F@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: victronenergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba91a5c2-843b-4bbe-96fe-08d750240f4e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2019 21:26:50.4346
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 60b95f08-3558-4e94-b0f8-d690c498e225
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rKid6927SkBEYf3EZMMAneq2HkI2/2adex/6sHFcCb1/Ttaw6WoyfmVGce2UazSUszdXLj8N8bn7iydWmFy3wSY0A/1iDjyUVJzCuY7M8K0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0701MB2143
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8gTWFyYywNCg0KT24gMTAvOS8xOSAzOjE4IFBNLCBNYXJjIEtsZWluZS1CdWRkZSB3cm90
ZToNCj4gSGVsbG8gSmVyb2VuLA0KPg0KPiBJJ20gY3VycmVudGx5IGxvb2tpbmcgYXQgdGhlIHJ4
LW9mZmxvYWQgZXJyb3IgaGFuZGxpbmcgaW4gZGV0YWlsLg0KPg0KPiBUTERSOiBJJ3ZlIGFkZGVk
IHRoZSBwYXRjaCB0byBsaW51eC1jYW4uDQo+DQo+IFRoYW5rcywNCj4gTWFyYw0KPg0KPiBGb3Ig
dGhlIHJlY29yZCwgdGhlIGRldGFpbHM6DQo+DQo+IE9uIDkvMjQvMTkgODo0NSBQTSwgSmVyb2Vu
IEhvZnN0ZWUgd3JvdGU6DQo+PiBXaGlsZSBjYW5fcnhfb2ZmbG9hZF9vZmZsb2FkX29uZSB3aWxs
IGNhbGwgbWFpbGJveF9yZWFkIHRvIGRpc2NhcmQNCj4+IHRoZSBtYWlsYm94IGluIGNhc2Ugb2Yg
YW4gZXJyb3IsDQo+IFllcy4NCj4NCj4gY2FuX3J4X29mZmxvYWRfb2ZmbG9hZF9vbmUoKSB3aWxs
IHJlYWQgaW50byB0aGUgZGlzY2FyZCBtYWlsYm94IGluIGNhc2UNCj4gb2YgYW4gZXJyb3IuDQo+
DQo+IEN1cnJlbnRseSB0aGVyZSBhcmUgdHdvIGtpbmRzIG9mIGVycm9yczoNCj4gMSkgdGhlIHJ4
LW9mZm9hZCBza2IgcXVldWUgKGJldHdlZW4gdGhlIElSUSBoYW5kbGVyIGFuZCB0aGUgTkFQSSkN
Cj4gICAgIGlzIGZ1bGwNCj4gMikgYWxsb2NfY2FuX3NrYigpIGZhaWxzIHRvIGFsbG9jYXRlIGEg
c2tiLCBkdWUgdG8gT09NDQo+DQo+PiBjYW5fcnhfb2ZmbG9hZF9pcnFfb2ZmbG9hZF90aW1lc3Rh
bXAgYmFpbHMgb3V0IGluIHRoZSBlcnJvciBjYXNlLg0KPiBZZXMsIGluIGNhc2Ugb2YgYW4gZXJy
b3IgYm90aCBjYW5fcnhfb2ZmbG9hZF9pcnFfb2ZmbG9hZF90aW1lc3RhbXAoKSBhbmQNCj4gY2Fu
X3J4X29mZmxvYWRfaXJxX29mZmxvYWRfZmlmbygpIHdpbGwgc3RvcCByZWFkaW5nIG1haWxib3hl
cywgYWRkIHRoZQ0KPiBhbHJlYWR5IGZpbGxlZCBza2JzIHRvIHRoZSBxdWV1ZSBhbmQgc2NoZWR1
bGUgTkFQSSBpZiBuZWVkZWQuDQo+DQo+IEN1cnJlbnRseSBib3RoIGNhbl9yeF9vZmZsb2FkX2ly
cV9vZmZsb2FkX3RpbWVzdGFtcCgpIGFuZA0KPiBjYW5fcnhfb2ZmbG9hZF9pcnFfb2ZmbG9hZF9m
aWZvKCkgd2lsbCByZXR1cm4gdGhlIG51bWJlciBvZiBxdWV1ZWQNCj4gbWFpbGJveGVzLg0KPg0K
PiBUaGlzIG1lYW5zIGluIGNhc2Ugb2YgcXVldWUgb3ZlcmZsb3cgb3IgT09NLCBvbmx5IG9uZSBt
YWlsYm94IGlzDQo+IGRpc2NhZGVkLCBiZWZvcmUgY2FuX3J4X29mZmxvYWRfaXJxX29mZmxvYWRf
KigpIHJldHVybmluZyB0aGUgbnVtYmVyIG9mDQo+IHN1Y2Nlc3NmdWxseSBxdWV1ZWQgbWFpbGJv
eGVzIHNvIGZhci4NCj4NCj4gTG9va2luZyBhdCB0aGUgZmxleGNhbiBkcml2ZXI6DQo+DQo+IGh0
dHBzOi8vZWxpeGlyLmJvb3RsaW4uY29tL2xpbnV4L2xhdGVzdC9zb3VyY2UvZHJpdmVycy9uZXQv
Y2FuL2ZsZXhjYW4uYyNMODY3DQo+DQo+PiAJCXdoaWxlICgocmVnX2lmbGFnID0gZmxleGNhbl9y
ZWFkX3JlZ19pZmxhZ19yeChwcml2KSkpIHsNCj4+IAkJCWhhbmRsZWQgPSBJUlFfSEFORExFRDsN
Cj4+IAkJCXJldCA9IGNhbl9yeF9vZmZsb2FkX2lycV9vZmZsb2FkX3RpbWVzdGFtcCgmcHJpdi0+
b2ZmbG9hZCwNCj4+IAkJCQkJCQkJICAgcmVnX2lmbGFnKTsNCj4+IAkJCWlmICghcmV0KQ0KPj4g
CQkJCWJyZWFrOw0KPj4gCQl9DQo+IFsuLi5dDQo+PiAJCWlmIChyZWdfaWZsYWcxICYgRkxFWENB
Tl9JRkxBR19SWF9GSUZPX0FWQUlMQUJMRSkgew0KPj4gCQkJaGFuZGxlZCA9IElSUV9IQU5ETEVE
Ow0KPj4gCQkJY2FuX3J4X29mZmxvYWRfaXJxX29mZmxvYWRfZmlmbygmcHJpdi0+b2ZmbG9hZCk7
DQo+PiAJCX0NCj4gVGhpcyBtZWFucyBmb3IgdGhlIHRpbWVzdGFtcCBtb2RlLCBhdCBsZWFzdCBv
bmUgbWFpbGJveCBpcyBkaXNjYXJkZWQgb3INCj4gaWYgdGhlIGVycm9yIG9jY3VycmVkIGFmdGVy
IHJlYWRpbmcgb25lIG9yIG1vcmUgbWFpbGJveGVzIHRoZSB3aGlsZSBsb29wDQo+IHdpbGwgdHJ5
IGFnYWluLiBJZiB0aGUgZXJyb3IgcGVyc2lzdHMgYSBzZWNvbmQgbWFpbGJveCBpcyBkaXNjYXJk
ZWQuDQo+DQo+IEZvciB0aGUgZmlmbyBtb2RlLCBvbmx5IG9uZSBtYWlsYm94IGlzIGRpc2NhcmRl
ZC4NCj4NCj4gVGhlbiB0aGUgZmxleGNhbidzIElSUSBpcyBleGl0ZWQuIElmIHRoZXJlIGFyZSBt
ZXNzYWdlcyBpbiBtYWlsYm94ZXMgYXJlDQo+IHBlbmRpbmcgYW5vdGhlciBJUlEgaXMgdHJpZ2dl
cmVkLi4uLiBJIGRvdWJ0IHRoYXQgdGhpcyBpcyBhIGdvb2QgaWRlYS4NCj4NCj4gT24gdGhlIG90
aGVyIGhhbmQgdGhlIHRpX2hlY2MgZHJpdmVyOg0KPg0KPj4gCQkvKiBvZmZsb2FkIFJYIG1haWxi
b3hlcyBhbmQgbGV0IE5BUEkgZGVsaXZlciB0aGVtICovDQo+PiAJCXdoaWxlICgocnhfcGVuZGlu
ZyA9IGhlY2NfcmVhZChwcml2LCBIRUNDX0NBTlJNUCkpKSB7DQo+PiAJCQljYW5fcnhfb2ZmbG9h
ZF9pcnFfb2ZmbG9hZF90aW1lc3RhbXAoJnByaXYtPm9mZmxvYWQsDQo+PiAJCQkJCQkJICAgICBy
eF9wZW5kaW5nKTsNCj4+IAkJCWhlY2Nfd3JpdGUocHJpdiwgSEVDQ19DQU5STVAsIHJ4X3BlbmRp
bmcpOw0KPj4gCQl9DQo+IFRoZSBlcnJvciBpcyBpZ25vcmVkIGFuZCB0aGUgX2FsbF8gbWFpbGJv
eGVzIGFyZSBkaXNjYXJkZWQgKGdpdmVuIHRoZQ0KPiBlcnJvciBwZXJzaXN0cykuDQo+DQo+PiBT
aW5jZSBpdCBpcyB0eXBpY2FsbHkgY2FsbGVkIGZyb20gYSB3aGlsZSBsb29wLCBhbGwgbWVzc2Fn
ZSB3aWxsDQo+PiBldmVudHVhbGx5IGJlIGRpc2NhcmRlZC4gU28gbGV0cyBjb250aW51ZSBvbiBl
cnJvciBpbnN0ZWFkIHRvIGRpc2NhcmQNCj4+IHRoZW0gZGlyZWN0bHkuDQo+IEFmdGVyIHJlYWRp
bmcgbXkgb3duIGNvZGUgYW5kIHdyaXRpbmcgaXQgdXAsIHlvdXIgcGF0Y2ggdG90YWxseSBtYWtl
cyBzZW5zZS4NCj4NCj4gSWYgdGhlcmUgaXMgYSBzaG9ydGFnZSBvZiByZXNvdXJjZXMsIHF1ZXVl
IG92ZXJydW4gb3IgT09NLCBpdCBtYWtlcyBubw0KPiBzZW5zZSB0byByZXR1cm4gZnJvbSB0aGUg
SVJRIGhhbmRsZXIsIGlmIGEgbWFpbGJveCBpcyBzdGlsbCBhY3RpdmUgYXMgaXQNCj4gd2lsbCB0
cmlnZ2VyIHRoZSBJUlEgYWdhaW4uIEVudGVyaW5nIHRoZSBJUlEgaGFuZGxlciBhZ2FpbiBwcm9i
YWJseQ0KPiBkb2Vzbid0IGdpdmUgdGhlIHN5c3RlbSB0aW1lIHRvIHJlY292ZXIgZnJvbSB0aGUg
cmVzb3VyY2UgcHJvYmxlbS4NCg0KDQpJbmRlZWQsIEkgaGF2ZSBub3RoaW5nIHRvIGNvbW1lbnQg
b24gdGhhdCwgYmVzaWRlcyB0aGFua3MgZm9yDQpiZWluZyB3aWxsaW5nIHRvIHJlY29uc2lkZXIg
eW91ciBvd24gY29kZS4NCg0KV2l0aCBraW5kIHJlZ2FyZHMsDQoNCkplcm9lbg0KDQoNCg==
