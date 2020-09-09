Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2149E262DB1
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 13:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728551AbgIILOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 07:14:19 -0400
Received: from mail-eopbgr1310049.outbound.protection.outlook.com ([40.107.131.49]:63680
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729129AbgIILLO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 07:11:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hk845b/m+jtC8YjNKWwZocxzwBpMhD8CyMfA26QnhBlL4PQgu8c9E985SNVb6tiEKWGIeJ3TeWoJmRr8QmJvdn7dcLtSkiMmwjuw7khdzwChSsO1j1nrF2CCUByQSPbhxAdDKxiJY+7kQYNRQNzcvMEEr8LbZun2nPuef8sJJP/76iwKu+TU8dw2IeS/Bl97GgvzM/A+9amymboosOTVXuCDl2saGPMJ5adpmvbAbwbOk8098KwTxsxMaKoA/KPxC0VJsNX6GKkDelLgF4Wzv2IznoXKaR2E4Ae8cOCgh78Yt42FsNJxohyr1MqcizDw/nxK2Rq/untII7uBtU4tnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pR8LVV80dBYkOpjf3daMrzGDJBGrwyRMrt9wnurt+sY=;
 b=k/lINHHrAS6W9vrxqpaYKLA4j72nkFzLe9wMcsE9CzlVMS6p5kRpCoTQ/JJNwAvSxoiR5uRS+djZZ6g068t/d2psc8XBWy1eSA2t+OoUvQ5G5tVLSXwY1v3P/IJBSVuCjvrIbq7KyefYfJpVaPcz8gnmGUz4zuS/KD7XNwe6N+QvkHVoIM3OoygqEYBya5l3T3bRcSlmUfoQFqXfIxb9FlC2RfnHTEsKvdVntFOPPpaw74nFmkBHa83wWatIW7WIT0UcjGv4Q5YbDSIbfC6b+ARUpfopSyb2HRS8egUjT/lKIe77KIs8ZeauFVqvPouIrUDl9gaac/7cifQsMLl2vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quectel.com; dmarc=pass action=none header.from=quectel.com;
 dkim=pass header.d=quectel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quectel.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pR8LVV80dBYkOpjf3daMrzGDJBGrwyRMrt9wnurt+sY=;
 b=eKqIvgVcVHPIVQWcXi91MxPxqfejWrx+PjYs4Tj7vV7IihNyQ5AV/p/+pHI+TO4ejo0sc4CmPc4XDDPZMiG9QbIMLW5kBnrBX1dgEP8fbHhw9rpDPZUf0yzicUUzwwx62eT6sv4JrIrs3YPC6vbW6d89pIV1TrM/qd+Hb2/tngM=
Received: from HK2PR06MB3507.apcprd06.prod.outlook.com (2603:1096:202:3e::14)
 by HK0PR06MB2850.apcprd06.prod.outlook.com (2603:1096:203:30::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Wed, 9 Sep
 2020 11:09:04 +0000
Received: from HK2PR06MB3507.apcprd06.prod.outlook.com
 ([fe80::d5a0:efbd:fd01:3d37]) by HK2PR06MB3507.apcprd06.prod.outlook.com
 ([fe80::d5a0:efbd:fd01:3d37%5]) with mapi id 15.20.3370.016; Wed, 9 Sep 2020
 11:09:04 +0000
From:   =?utf-8?B?Q2FybCBZaW4o5q635byg5oiQKQ==?= <carl.yin@quectel.com>
To:     Daniele Palmas <dnlplm@gmail.com>,
        =?utf-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC:     Kristian Evensen <kristian.evensen@gmail.com>,
        Paul Gildea <paul.gildea@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggbmV0LW5leHQgMS8xXSBuZXQ6IHVzYjogcW1pX3d3?=
 =?utf-8?B?YW46IGFkZCBkZWZhdWx0IHJ4X3VyYl9zaXpl?=
Thread-Topic: [PATCH net-next 1/1] net: usb: qmi_wwan: add default rx_urb_size
Thread-Index: AQHWhom0yoQF//qW/E+nUHr9aPCUA6lgHrTg
Date:   Wed, 9 Sep 2020 11:09:04 +0000
Message-ID: <HK2PR06MB35077179EE3FDE04A1EB612786260@HK2PR06MB3507.apcprd06.prod.outlook.com>
References: <20200909091302.20992-1-dnlplm@gmail.com>
In-Reply-To: <20200909091302.20992-1-dnlplm@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=quectel.com;
x-originating-ip: [223.119.199.7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 64ab2e5c-55ab-4c0f-6d7c-08d854b0c3a4
x-ms-traffictypediagnostic: HK0PR06MB2850:
x-microsoft-antispam-prvs: <HK0PR06MB2850174BABD22B8D5D1D9C8386260@HK0PR06MB2850.apcprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6/oM5eQS47V1Ix5L+B3LCx/a9xx9o47+fzHuBYC1YKWWecqQzsKiSz1GVmMykkGJZuAKxsnMfck+gfzd2WbHi2E7nAdJjt9Tto/nhfhGJyMNI0qz8AKrT7dFP5C6H5rIa3KjNgGNTJS/HNte/knRCdvoJ+v7VJIODr5v5paVB6JrlL4u41m1wGqJufefnWdFOS9j4n53uAJXQgv3JoLfXJjgXKKFrwPxVNeSdm0dHTsS2v+bFaLpn0vSfjAXjdiRkgTPLgd4PX6v3xMBLAo7V9S8l0A/jH2q5Hlvb9DaLrykmALVHykBRJlIDqU4NYTItjhLaSZApIoOY60WiKvBALGe3WwOLnJSiVTDUQUTv2RTu9dhdHq6DrPEDl5quC9hLozUaYu9pQU4RmAVf7WZsA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3507.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(366004)(346002)(396003)(478600001)(66574015)(224303003)(66946007)(76116006)(83380400001)(26005)(5660300002)(110136005)(55016002)(66446008)(66556008)(66476007)(64756008)(186003)(4326008)(85182001)(71200400001)(6506007)(7696005)(966005)(2906002)(52536014)(54906003)(86362001)(316002)(8936002)(33656002)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: X3Gq7pnrnYGAwY4jqG1vXxvB/foK34HY6X8cB0NND5u81t7rb3bAnY3LO71gH2Eb+ZbAiyWjeO9rI9PRE8ixRFk61noULTgCIN201fLFN0i5m/t1PvnYtEkwrpvfNdng6/oieHcTEER1kGAKOlXpQ31eB+kuAJFnzVvpXl1Locc+d4IU2V3ZFchgkzC9M+HTbgt/JjTk7uLagBYLa7hmdicuPUhDn999FPQUuXUbGlI50Z2APhCr9pic6iR2wA5c+Y2TaNf8PCy/xATOKZ8fd8QYEeZOFb2Lomh7oHCzIgVtEKa0TKXzSwWwPxy8R/WuuQcdnyDyle6H5IklmEO3qcdcplxOxDuZZX4MZ3o31MXI0QjRiGX5taU7lO/Lg0H55AmxNMO05SEsLZZKuiL8/RLf16JUufEqRaYfkQ1cyuOcJdbc77SQkgHbnh6miysus9TdLw9xPGcV3BPCbXilcL+cwAixRqOrppQI+QZyyaLIpn1c/pQ8m1fwY58SL65uP0UqOyyevPZKMk/RRtoY3mu0JSGIHPNQmqrxTNDpSRtXb7Vrk2ExwC7Zi/vqjiOgFQC5vEXrr3YNQ4/iN9mY+LWuRBMIoUB+5bq/JmMHm52Ok3SzCBRVFkErmVoQ4QL/33GeJWfWo8k9CDrYYjLG5Q==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: quectel.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3507.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64ab2e5c-55ab-4c0f-6d7c-08d854b0c3a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2020 11:09:04.4876
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7730d043-e129-480c-b1ba-e5b6a9f476aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F33g4/3e0FNmNFM48d458YrsV6vde9bnHKp5i8uQTNtPZM7pWlJiAjrzmboqYYvJYLcSPplWy40RAhXiqcJ+0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR06MB2850
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGVuaWVsZToNCg0KCUkgaGF2ZSBhbiBpZGVhLCBieSBub3cgaW4gb3JkZXIgdG8gdXNlIFFN
QVAsIA0KCW11c3QgZXhlY3V0ZSBzaGVsbCBjb21tYW5kICdlY2hvIG11eF9pZCA+IC9zeXMvY2xh
c3MvbmV0LzxpZmFjZT4vYWRkX211eCcgaW4gdXNlciBzcGFjZSwNCgltYXliZSB3ZSBjYW4gZXhw
YW5kIHVzYWdlIG9mIHN5cyBhdHRyaWJ1dGUgJ2FkZF9tdXgnLCBsaWtlIG5leHQ6DQoJJ2VjaG8g
bXV4X2lkIG11eF9zaXplIG11eF92ZXJzaW9uID4gL3N5cy9jbGFzcy9uZXQvPGlmYWNlPi9hZGRf
bXV4Jy4NCglVc2VycyBjYW4gc2V0IGNvcnJlY3QgJ211eF9zaXplIGFuZCBtdXhfdmVyc2lvbicg
YWNjb3JkaW5nIHRvIHRoZSByZXNwb25zZSBvZiAnUU1JX1dEQV9TRVRfREFUQV9GT1JNQVQgJy4N
CglJZiAnbXV4X3NpemUgYW5kIG11eF92ZXJzaW9uJyBtaXNzLCBxbWlfd3dhbiBjYW4gdXNlIGRl
ZmF1bHQgdmFsdWVzLg0KDQoJSWYgZml4ZWQgc2V0IGFzIDMyS0IsIGJ1dCBNRE05eDA3IGNoaXBz
IG9ubHkgc3VwcG9ydCA0S0IsIG9yIHVzZXMgZG8gbm90IGVuYWJsZSBRTUFQLA0KCU1heWJlIGNh
bm5vdCByZWFjaCBtYXggdGhyb3VnaHB1dCBmb3Igbm8gZW5vdWdoIHJ4IHVyYnMuDQoJDQoNCj4g
LS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IERhbmllbGUgUGFsbWFzIFttYWls
dG86ZG5scGxtQGdtYWlsLmNvbV0NCj4g5Y+R6YCB5pe26Ze0OiBXZWRuZXNkYXksIFNlcHRlbWJl
ciAwOSwgMjAyMCA1OjEzIFBNDQo+IOaUtuS7tuS6ujogQmrDuHJuIE1vcmsgPGJqb3JuQG1vcmsu
bm8+DQo+IOaKhOmAgTogS3Jpc3RpYW4gRXZlbnNlbiA8a3Jpc3RpYW4uZXZlbnNlbkBnbWFpbC5j
b20+OyBQYXVsIEdpbGRlYQ0KPiA8cGF1bC5naWxkZWFAZ21haWwuY29tPjsgQ2FybCBZaW4o5q63
5byg5oiQKSA8Y2FybC55aW5AcXVlY3RlbC5jb20+OyBEYXZpZCBTIC4NCj4gTWlsbGVyIDxkYXZl
bUBkYXZlbWxvZnQubmV0PjsgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47DQo+IG5l
dGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LXVzYkB2Z2VyLmtlcm5lbC5vcmc7IERhbmllbGUg
UGFsbWFzDQo+IDxkbmxwbG1AZ21haWwuY29tPg0KPiDkuLvpopg6IFtQQVRDSCBuZXQtbmV4dCAx
LzFdIG5ldDogdXNiOiBxbWlfd3dhbjogYWRkIGRlZmF1bHQgcnhfdXJiX3NpemUNCj4gDQo+IEFk
ZCBkZWZhdWx0IHJ4X3VyYl9zaXplIHRvIHN1cHBvcnQgUU1BUCBkb3dubG9hZCBkYXRhIGFnZ3Jl
Z2F0aW9uIHdpdGhvdXQNCj4gbmVlZGluZyBhZGRpdGlvbmFsIHNldHVwIHN0ZXBzIGluIHVzZXJz
cGFjZS4NCj4gDQo+IFRoZSB2YWx1ZSBjaG9zZW4gaXMgdGhlIGN1cnJlbnQgaGlnaGVzdCBvbmUg
c2VlbiBpbiBhdmFpbGFibGUgbW9kZW1zLg0KPiANCj4gVGhlIHBhdGNoIGhhcyB0aGUgc2lkZS1l
ZmZlY3Qgb2YgZml4aW5nIGEgYmFiYmxlIGlzc3VlIGluIHJhdy1pcCBtb2RlIHJlcG9ydGVkIGJ5
DQo+IG11bHRpcGxlIHVzZXJzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogRGFuaWVsZSBQYWxtYXMg
PGRubHBsbUBnbWFpbC5jb20+DQo+IC0tLQ0KPiBSZXNlbmRpbmcgd2l0aCBtYWlsaW5nIGxpc3Rz
IGFkZGVkOiBzb3JyeSBmb3IgdGhlIG5vaXNlLg0KPiANCj4gSGkgQmrDuHJuIGFuZCBhbGwsDQo+
IA0KPiB0aGlzIHBhdGNoIHRyaWVzIHRvIGFkZHJlc3MgdGhlIGlzc3VlIHJlcG9ydGVkIGluIHRo
ZSBmb2xsb3dpbmcgdGhyZWFkcw0KPiANCj4gaHR0cHM6Ly93d3cuc3Bpbmljcy5uZXQvbGlzdHMv
bmV0ZGV2L21zZzYzNTk0NC5odG1sDQo+IGh0dHBzOi8vd3d3LnNwaW5pY3MubmV0L2xpc3RzL2xp
bnV4LXVzYi9tc2cxOTg4NDYuaHRtbA0KPiBodHRwczovL3d3dy5zcGluaWNzLm5ldC9saXN0cy9s
aW51eC11c2IvbXNnMTk4MDI1Lmh0bWwNCj4gDQo+IHNvIEknbSBhZGRpbmcgdGhlIHBlb3BsZSBp
bnZvbHZlZCwgbWF5YmUgeW91IGNhbiBnaXZlIGl0IGEgdHJ5IHRvIGRvdWJsZSBjaGVjayBpZg0K
PiB0aGlzIGlzIGdvb2QgZm9yIHlvdS4NCj4gDQo+IE9uIG15IHNpZGUsIEkgcGVyZm9ybWVkIHRl
c3RzIHdpdGggZGlmZmVyZW50IFFDIGNoaXBzZXRzIHdpdGhvdXQgZXhwZXJpZW5jaW5nDQo+IHBy
b2JsZW1zLg0KPiANCj4gVGhhbmtzLA0KPiBEYW5pZWxlDQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQv
dXNiL3FtaV93d2FuLmMgfCA0ICsrKysNCj4gIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMo
KykNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC91c2IvcW1pX3d3YW4uYyBiL2RyaXZl
cnMvbmV0L3VzYi9xbWlfd3dhbi5jIGluZGV4DQo+IDA3YzQyYzA3MTlmNS4uOTJkNTY4Zjk4MmI2
IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC91c2IvcW1pX3d3YW4uYw0KPiArKysgYi9kcml2
ZXJzL25ldC91c2IvcW1pX3d3YW4uYw0KPiBAQCAtODE1LDYgKzgxNSwxMCBAQCBzdGF0aWMgaW50
IHFtaV93d2FuX2JpbmQoc3RydWN0IHVzYm5ldCAqZGV2LCBzdHJ1Y3QNCj4gdXNiX2ludGVyZmFj
ZSAqaW50ZikNCj4gIAl9DQo+ICAJZGV2LT5uZXQtPm5ldGRldl9vcHMgPSAmcW1pX3d3YW5fbmV0
ZGV2X29wczsNCj4gIAlkZXYtPm5ldC0+c3lzZnNfZ3JvdXBzWzBdID0gJnFtaV93d2FuX3N5c2Zz
X2F0dHJfZ3JvdXA7DQo+ICsNCj4gKwkvKiBTZXQgcnhfdXJiX3NpemUgdG8gYWxsb3cgUU1BUCBy
eCBkYXRhIGFnZ3JlZ2F0aW9uICovDQo+ICsJZGV2LT5yeF91cmJfc2l6ZSA9IDMyNzY4Ow0KPiAr
DQo+ICBlcnI6DQo+ICAJcmV0dXJuIHN0YXR1czsNCj4gIH0NCj4gLS0NCj4gMi4xNy4xDQoNCg==
