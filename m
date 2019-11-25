Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0870110892B
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 08:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfKYHaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 02:30:11 -0500
Received: from mail-oln040092254074.outbound.protection.outlook.com ([40.92.254.74]:30144
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725535AbfKYHaK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Nov 2019 02:30:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c5jh7gQQ3nNlHpoVn+P1Ww/goxidvZr1WZ8zFswSSq8+oQ8gsk2Rlt9/8isnHbDeFkEf9QpI3ClqGU0Zz5Kc2HqQBREE7wNTHy1TaiHuK8sXhiMKWCn+6O9mMDBu5/a9tuUnQUAzkR4U7yx7DGhFSaoAQo+drz9C3xnkA+73IvE/qPQ6l8255fa8ltt44Kk5o6tGerKF31G0lHvqtdEcMXAgXAGBvmvYxVhtQoowfGe5YZ0oQr+q+ExuL5yOvYRKoXxzFOLgZikzMSppFBilRGQIcoFjWmqCdBIDLnu1SNfY/1bMfm4PALajhS4zHxlJW9KN1EDFbVvaA13Nk75qVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xcP02Sb2wnaZxslUX8Qr4XWcRssGIf2cnwWz+QSYioI=;
 b=VsxMGZaeB5ou/mc2P3n3x74r9ekzK0Cf4QoGffl13agTA+aprT1YLa4dkRtYwzWhUHHxOvlKRQTSVTmNPA5L/jILpMRrpdFwqwbUSxA6boNkznWXb/yOTDczBsmDcbAnsx2b1Rst8H0HNsVzlEKNlQwvY5YzPRTeMKnRnCPeWrRuzM7PADqs7vaM04kaQ2HCnZ+jzxDOdpI1Bq8jVRbueKzfrI8JCDTJ3uryXikLdcZJPfjsBpzsa8ivtlSR2aB9vzegzyd9ddNM5sJ8gRYryM2vEN2bwydhOai0modcbOQLlc70dfji1KI3TaaZu783tLXjhDIEvkj+EkCZztdO4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from PU1APC01FT049.eop-APC01.prod.protection.outlook.com
 (10.152.252.58) by PU1APC01HT037.eop-APC01.prod.protection.outlook.com
 (10.152.253.63) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2474.17; Mon, 25 Nov
 2019 07:29:22 +0000
Received: from PSXP216MB0438.KORP216.PROD.OUTLOOK.COM (10.152.252.56) by
 PU1APC01FT049.mail.protection.outlook.com (10.152.253.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17 via Frontend Transport; Mon, 25 Nov 2019 07:29:22 +0000
Received: from PSXP216MB0438.KORP216.PROD.OUTLOOK.COM
 ([fe80::b880:961e:dd88:8b5d]) by PSXP216MB0438.KORP216.PROD.OUTLOOK.COM
 ([fe80::b880:961e:dd88:8b5d%12]) with mapi id 15.20.2474.023; Mon, 25 Nov
 2019 07:29:22 +0000
From:   Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>
To:     Alexander Lobakin <alobakin@dlink.ru>
CC:     David Miller <davem@davemloft.net>,
        "ecree@solarflare.com" <ecree@solarflare.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "petrm@mellanox.com" <petrm@mellanox.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jaswinder.singh@linaro.org" <jaswinder.singh@linaro.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net-next] net: core: use listified Rx for GRO_NORMAL in
 napi_gro_receive()
Thread-Topic: [PATCH v2 net-next] net: core: use listified Rx for GRO_NORMAL
 in napi_gro_receive()
Thread-Index: AQHVo2IFW7miydWzwUGig6GEl/Vj4w==
Date:   Mon, 25 Nov 2019 07:29:22 +0000
Message-ID: <PSXP216MB04388962C411CD0B17A86F47804A0@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
References: <20191014080033.12407-1-alobakin@dlink.ru>
 <20191015.181649.949805234862708186.davem@davemloft.net>
 <7e68da00d7c129a8ce290229743beb3d@dlink.ru>
In-Reply-To: <7e68da00d7c129a8ce290229743beb3d@dlink.ru>
Accept-Language: en-AU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: ME1PR01CA0144.ausprd01.prod.outlook.com
 (2603:10c6:200:1b::29) To PSXP216MB0438.KORP216.PROD.OUTLOOK.COM
 (2603:1096:300:d::20)
x-incomingtopheadermarker: OriginalChecksum:A10A8C8E97311F6253E04FD31A42E8D9E0E7D855278257EBC4ADF17D8EFDD14F;UpperCasedChecksum:3EF3C3FFC560212A3850FB9FE22FD0A106375CD5209D5F446A364730E1E68E7D;SizeAsReceived:8067;Count:49
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [toJvcZYP1YT1qPRSzEeMSTv6bj4hxqDs]
x-microsoft-original-message-id: <20191125072856.GA3088@nicholas-usb>
x-ms-publictraffictype: Email
x-incomingheadercount: 49
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 719374c2-9a24-48f9-6750-08d7717930dd
x-ms-traffictypediagnostic: PU1APC01HT037:
x-ms-exchange-purlcount: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aqfiC/D3Grzmf6Jjqby/fIJRLenNQnd49XJiFUMhdk9MN1hs1lRNtiTlmDv5aMZXSTeJKqUMP6XNwrz1D0tv8aQooOmhMNg6iDymlqr7TERc88hBiYqpciNnd429COqAuFihG3y79JhIr7K9bJO72lqvOBDagsaT0d7tmRJxBl3xXjG4P8jqfJYqdpVK5E/C/oPf2R/pFrTwkgsdGzU8r2hh8rG+Sy3LqmDMqG8vc08=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <1602B7F11225044E90E6F6A152870352@KORP216.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 719374c2-9a24-48f9-6750-08d7717930dd
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2019 07:29:22.8339
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1APC01HT037
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCk9uIFdlZCwgT2N0IDE2LCAyMDE5IGF0IDEwOjMxOjMxQU0gKzAzMDAsIEFsZXhhbmRl
ciBMb2Jha2luIHdyb3RlOg0KPiBEYXZpZCBNaWxsZXIgd3JvdGUgMTYuMTAuMjAxOSAwNDoxNjoN
Cj4gPiBGcm9tOiBBbGV4YW5kZXIgTG9iYWtpbiA8YWxvYmFraW5AZGxpbmsucnU+DQo+ID4gRGF0
ZTogTW9uLCAxNCBPY3QgMjAxOSAxMTowMDozMyArMDMwMA0KPiA+IA0KPiA+ID4gQ29tbWl0IDMy
M2ViYjYxZTMyYjQgKCJuZXQ6IHVzZSBsaXN0aWZpZWQgUlggZm9yIGhhbmRsaW5nIEdST19OT1JN
QUwNCj4gPiA+IHNrYnMiKSBtYWRlIHVzZSBvZiBsaXN0aWZpZWQgc2tiIHByb2Nlc3NpbmcgZm9y
IHRoZSB1c2VycyBvZg0KPiA+ID4gbmFwaV9ncm9fZnJhZ3MoKS4NCj4gPiA+IFRoZSBzYW1lIHRl
Y2huaXF1ZSBjYW4gYmUgdXNlZCBpbiBhIHdheSBtb3JlIGNvbW1vbiBuYXBpX2dyb19yZWNlaXZl
KCkNCj4gPiA+IHRvIHNwZWVkIHVwIG5vbi1tZXJnZWQgKEdST19OT1JNQUwpIHNrYnMgZm9yIGEg
d2lkZSByYW5nZSBvZiBkcml2ZXJzDQo+ID4gPiBpbmNsdWRpbmcgZ3JvX2NlbGxzIGFuZCBtYWM4
MDIxMSB1c2Vycy4NCj4gPiA+IFRoaXMgc2xpZ2h0bHkgY2hhbmdlcyB0aGUgcmV0dXJuIHZhbHVl
IGluIGNhc2VzIHdoZXJlIHNrYiBpcyBiZWluZw0KPiA+ID4gZHJvcHBlZCBieSB0aGUgY29yZSBz
dGFjaywgYnV0IGl0IHNlZW1zIHRvIGhhdmUgbm8gaW1wYWN0IG9uIHJlbGF0ZWQNCj4gPiA+IGRy
aXZlcnMnIGZ1bmN0aW9uYWxpdHkuDQo+ID4gPiBncm9fbm9ybWFsX2JhdGNoIGlzIGxlZnQgdW50
b3VjaGVkIGFzIGl0J3MgdmVyeSBpbmRpdmlkdWFsIGZvciBldmVyeQ0KPiA+ID4gc2luZ2xlIHN5
c3RlbSBjb25maWd1cmF0aW9uIGFuZCBtaWdodCBiZSB0dW5lZCBpbiBtYW51YWwgb3JkZXIgdG8N
Cj4gPiA+IGFjaGlldmUgYW4gb3B0aW1hbCBwZXJmb3JtYW5jZS4NCj4gPiA+IA0KPiA+ID4gU2ln
bmVkLW9mZi1ieTogQWxleGFuZGVyIExvYmFraW4gPGFsb2Jha2luQGRsaW5rLnJ1Pg0KPiA+ID4g
QWNrZWQtYnk6IEVkd2FyZCBDcmVlIDxlY3JlZUBzb2xhcmZsYXJlLmNvbT4NCj4gPiANCj4gPiBB
cHBsaWVkLCB0aGFuayB5b3UuDQo+IA0KPiBEYXZpZCwgRWR3YXJkLCBFcmljLCBJbGlhcywNCj4g
dGhhbmsgeW91IGZvciB5b3VyIHRpbWUuDQo+IA0KPiBSZWdhcmRzLA0KPiDhmrcg4ZuWIOGaoiDh
mqYg4ZqgIOGasQ0KDQpJIGFtIHZlcnkgc29ycnkgdG8gYmUgdGhlIGJlYXJlciBvZiBiYWQgbmV3
cy4gSXQgYXBwZWFycyB0aGF0IHRoaXMNCmNvbW1pdCBpcyBjYXVzaW5nIGEgcmVncmVzc2lvbiBp
biBMaW51eCA1LjQuMC1yYzgtbmV4dC0yMDE5MTEyMiwNCnByZXZlbnRpbmcgbWUgZnJvbSBjb25u
ZWN0aW5nIHRvIFdpLUZpIG5ldHdvcmtzLiBJIGhhdmUgYSBEZWxsIFhQUyA5MzcwDQooSW50ZWwg
Q29yZSBpNy04NjUwVSkgd2l0aCBJbnRlbCBXaXJlbGVzcyA4MjY1IFs4MDg2OjI0ZmRdLg0KDQpJ
IGRpZCBhIGJpc2VjdCwgYW5kIHRoaXMgY29tbWl0IHdhcyBuYW1lZCB0aGUgY3VscHJpdC4gSSB0
aGVuIGFwcGxpZWQNCnRoZSByZXZlcnNlIHBhdGNoIG9uIGFub3RoZXIgY2xvbmUgb2YgTGludXgg
bmV4dC0yMDE5MTEyMiwgYW5kIGl0DQpzdGFydGVkIHdvcmtpbmcuDQoNCjY1NzBiYzc5YzBkZmZm
MGYyMjhiN2FmZDJkZTcyMGZiNGU4NGQ2MWQNCm5ldDogY29yZTogdXNlIGxpc3RpZmllZCBSeCBm
b3IgR1JPX05PUk1BTCBpbiBuYXBpX2dyb19yZWNlaXZlKCkNCg0KWW91IGNhbiBzZWUgbW9yZSBh
dCB0aGUgYnVnIHJlcG9ydCBJIGZpbGVkIGF0IFswXS4NCg0KWzBdDQpodHRwczovL2J1Z3ppbGxh
Lmtlcm5lbC5vcmcvc2hvd19idWcuY2dpP2lkPTIwNTY0Nw0KDQpJIGNhbGxlZCBvbiBvdGhlcnMg
YXQgWzBdIHRvIHRyeSB0byByZXByb2R1Y2UgdGhpcyAtIHlvdSBzaG91bGQgbm90IHB1bGwgDQph
IHBhdGNoIGJlY2F1c2Ugb2YgYSBzaW5nbGUgcmVwb3J0ZXIgLSBhcyBJIGNvdWxkIGJlIHdyb25n
Lg0KDQpQbGVhc2UgbGV0IG1lIGtub3cgaWYgeW91IHdhbnQgbWUgdG8gZ2l2ZSBtb3JlIGRlYnVn
Z2luZyBpbmZvcm1hdGlvbiBvciANCnRlc3QgYW55IHBvdGVudGlhbCBmaXhlcy4gSSBhbSBoYXBw
eSB0byBoZWxwIHRvIGZpeCB0aGlzLiA6KQ0KDQpLaW5kIHJlZ2FyZHMsDQpOaWNob2xhcyBKb2hu
c29uDQo=
