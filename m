Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0F8C2D5A1
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 08:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbfE2Gm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 02:42:58 -0400
Received: from mail-eopbgr10096.outbound.protection.outlook.com ([40.107.1.96]:46323
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725879AbfE2Gm6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 02:42:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w3j75qo9DUU32O1C1xvnYyKE5F15xjAwqYc92XxQqxQ=;
 b=guHPpIZltYPQHgGsvyUTg9BpeKc94rGA2zrFJnEMkGcMpHHYtX32ITK33g3ApB1MqWlAvNLSgRZnGoOWzdnUj9By3hIC0U+9ZNcGb9Rix6Hg0zSnwpMajc7DrCuzlEgUwRyGGCQ7Vx2LKgTolbCf5wEuJsE7+TabQ5Kg5gWPu7k=
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM (20.178.126.80) by
 VI1PR10MB2399.EURPRD10.PROD.OUTLOOK.COM (20.177.62.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Wed, 29 May 2019 06:42:53 +0000
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5]) by VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5%6]) with mapi id 15.20.1922.021; Wed, 29 May 2019
 06:42:53 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: dsa: mv88e6xxx: fix handling of upper half of
 STATS_TYPE_PORT
Thread-Topic: [PATCH] net: dsa: mv88e6xxx: fix handling of upper half of
 STATS_TYPE_PORT
Thread-Index: AQHVFVeoJSehSdMxnEmrURHzmpsI7aaAjGQAgAEcZAA=
Date:   Wed, 29 May 2019 06:42:53 +0000
Message-ID: <dc84827e-6bac-7a01-f998-609cfe9a33ec@prevas.dk>
References: <20190528131701.23912-1-rasmus.villemoes@prevas.dk>
 <20190528134458.GE18059@lunn.ch>
In-Reply-To: <20190528134458.GE18059@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR05CA0210.eurprd05.prod.outlook.com
 (2603:10a6:3:f9::34) To VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:e1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [81.216.59.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d0d2ad7c-317b-4fee-5e84-08d6e400e023
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR10MB2399;
x-ms-traffictypediagnostic: VI1PR10MB2399:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR10MB23997AEA5B9E06B506F57DC08A1F0@VI1PR10MB2399.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0052308DC6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(136003)(376002)(396003)(39850400004)(199004)(189003)(71200400001)(71190400001)(81166006)(81156014)(478600001)(186003)(8936002)(6506007)(386003)(14454004)(54906003)(72206003)(8676002)(66476007)(64756008)(6512007)(66446008)(102836004)(53936002)(66946007)(6246003)(73956011)(256004)(66556008)(42882007)(3846002)(11346002)(4326008)(446003)(68736007)(486006)(2906002)(6116002)(2616005)(26005)(476003)(44832011)(31686004)(66066001)(8976002)(6916009)(74482002)(25786009)(31696002)(36756003)(229853002)(76176011)(5660300002)(15974865002)(6486002)(305945005)(316002)(7736002)(6436002)(52116002)(99286004)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR10MB2399;H:VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MK5X/TnGp8gp4bPN3UlWV+9bu4XpWlQnoOpKIFOi0iXChLuUARMXf/49W1bWMbIWH6+yzzlxVCTY6+YRDkQE0aCcemf+/Eegi02XDcy8e+Z/oVAKcXUHxBpCq9pIw3GzOkqVJ4u2v1IPEkui2uvbp/ub0P9lFfUcYysPjmYSjffLWCjnVdnRUAvrxoO8cJvDHS5TdCe5Jj6CDaZcunnlnCFIM37p5VGY52d/6aIebvIJEytSn/M3wlhX2W2pDf/2csJfEkTZdsyK7Y3eMrwCE8jC7swYpj+DoAulk2Q0VbhvnV6f6AT5/S0WT+KA9I5l+yAOkqJDPjtbdIa9IR9YTWcdhw6s53hzvjHg5IH8QjvRR0aoLjaOHJHFWkgEgVp3Fr20xqmmmYA6vkRinpeSnbe/H9oLMILC4haWixFE25o=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EB3950DE425EDA42B35744514C260087@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: d0d2ad7c-317b-4fee-5e84-08d6e400e023
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2019 06:42:53.5638
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rasmus.Villemoes@prevas.dk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB2399
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjgvMDUvMjAxOSAxNS40NCwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+IE9uIFR1ZSwgTWF5IDI4
LCAyMDE5IGF0IDAxOjE3OjEwUE0gKzAwMDAsIFJhc211cyBWaWxsZW1vZXMgd3JvdGU6DQo+PiBD
dXJyZW50bHksIHRoZSB1cHBlciBoYWxmIG9mIGEgNC1ieXRlIFNUQVRTX1RZUEVfUE9SVCBzdGF0
aXN0aWMgZW5kcw0KPj4gdXAgaW4gYml0cyA0NzozMiBvZiB0aGUgcmV0dXJuIHZhbHVlLCBpbnN0
ZWFkIG9mIGJpdHMgMzE6MTYgYXMgdGhleQ0KPj4gc2hvdWxkLg0KPj4NCj4+IFNpZ25lZC1vZmYt
Ynk6IFJhc211cyBWaWxsZW1vZXMgPHJhc211cy52aWxsZW1vZXNAcHJldmFzLmRrPg0KPiANCj4g
SGkgUmFzbXVzDQo+IA0KPiBQbGVhc2UgaW5jbHVkZSBhIEZpeGVzIHRhZywgdG8gaW5kaWNhdGUg
d2hlcmUgdGhlIHByb2JsZW0gd2FzDQo+IGludHJvZHVjZWQuIEluIHRoaXMgY2FzZSwgaSB0aGlu
ayBpdCB3YXM6DQo+IA0KPiBGaXhlczogNmU0NmUyZDgyMWJiICgibmV0OiBkc2E6IG12ODhlNnh4
eDogRml4IHU2NCBzdGF0aXN0aWNzIikNCj4gDQo+IEFuZCBzZXQgdGhlIFN1YmplY3QgdG8gW1BB
VENIIG5ldF0gdG8gaW5kaWNhdGUgdGhpcyBzaG91bGQgYmUgYXBwbGllZA0KPiB0byB0aGUgbmV0
IHRyZWUuDQoNCldpbGwgZG8uDQoNCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvbXY4
OGU2eHh4L2NoaXAuYyBiL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvY2hpcC5jDQo+PiBpbmRl
eCAzNzA0MzRiZGJkYWIuLjMxNzU1M2QyY2IyMSAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvbmV0
L2RzYS9tdjg4ZTZ4eHgvY2hpcC5jDQo+PiArKysgYi9kcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4
L2NoaXAuYw0KPj4gQEAgLTc4NSw3ICs3ODUsNyBAQCBzdGF0aWMgdWludDY0X3QgX212ODhlNnh4
eF9nZXRfZXRodG9vbF9zdGF0KHN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCwNCj4+ICAJCQll
cnIgPSBtdjg4ZTZ4eHhfcG9ydF9yZWFkKGNoaXAsIHBvcnQsIHMtPnJlZyArIDEsICZyZWcpOw0K
Pj4gIAkJCWlmIChlcnIpDQo+PiAgCQkJCXJldHVybiBVNjRfTUFYOw0KPj4gLQkJCWhpZ2ggPSBy
ZWc7DQo+PiArCQkJbG93IHw9ICgodTMyKXJlZykgPDwgMTY7DQo+PiAgCQl9DQo+PiAgCQlicmVh
azsNCj4+ICAJY2FzZSBTVEFUU19UWVBFX0JBTksxOg0KPiANCj4gV2hhdCBpIGRvbid0IGxpa2Ug
YWJvdXQgdGhpcyBpcyBob3cgdGhlIGZ1bmN0aW9uIGZpbmlzaGVzOg0KPiANCj4gICAgICAgIAl9
DQo+ICAgICAgICAgdmFsdWUgPSAoKCh1NjQpaGlnaCkgPDwgMzIpIHwgbG93Ow0KPiAgICAgICAg
IHJldHVybiB2YWx1ZTsNCj4gfQ0KPiANCj4gQSBiZXR0ZXIgZml4IG1pZ2h0IGJlDQo+IA0KPiAt
CQlicmVhaw0KPiArCQl2YWx1ZSA9ICgoKHU2NCloaWdoKSA8PCAxNiB8IGxvdzsNCj4gKwkJcmV0
dXJuIHZhbHVlOw0KDQpXaHk/IEl0J3Mgb2RkIHRvIGhhdmUgdGhlIHUzMiAiaGlnaCIgc29tZXRp
bWVzIHJlcHJlc2VudCB0aGUgaGlnaCAzMg0KYml0cywgc29tZXRpbWVzIHRoZSB0aGlyZCAxNiBi
aXRzLiBJdCB3b3VsZCBtYWtlIGl0IGhhcmRlciB0byBzdXBwb3J0IGFuDQo4LWJ5dGUgU1RBVFNf
VFlQRV9QT1JUIHN0YXRpc3RpYy4gSSB0aGluayB0aGUgY29kZSBpcyBtdWNoIGNsZWFuZXIgaWYN
CmVhY2ggY2FzZSBpcyBqdXN0IHJlc3BvbnNpYmxlIGZvciBwcm92aWRpbmcgdGhlIHVwcGVyL2xv
d2VyIDMyIGJpdHMsDQp0aGVuIGhhdmUgdGhlIGNvbW1vbiBjYXNlIGNvbWJpbmUgdGhlbTsgLiBJ
dCdzIGp1c3QgdGhhdCBpbiB0aGUNClNUQVRTX1RZUEVfQkFOSyBjYXNlcywgdGhlIDMyIGJpdHMg
YXJlIGFzc2VtYmxlZCBmcm9tIHR3byAxNiBiaXQgdmFsdWVzDQpieSBhIGhlbHBlciAobXY4OGU2
eHh4X2cxX3N0YXRzX3JlYWQpLCB3aGlsZSBpdCBpcyAib3Blbi1jb2RlZCIgaW4gdGhlDQpmaXJz
dCBjYXNlLg0KDQpJJ2xsIHJlc2VuZCBteSBwYXRjaCB3aXRoIHRoZSBmaXhlcyB0YWcgKHRoYW5r
cyBmb3IgZmluZGluZyB0aGF0OyBJIGhhZA0KYWxyZWFkeSBkdWcgd2F5IHRvbyBkZWVwIHBhc3Qg
dGhhdCBvbmUpIGFuZCBmaXhlZCBzdWJqZWN0Lg0KDQpSYXNtdXMNCg0KDQo+IAlBbmRyZXcJDQo+
IA0KDQoNCi0tIA0KUmFzbXVzIFZpbGxlbW9lcw0KU29mdHdhcmUgRGV2ZWxvcGVyDQpQcmV2YXMg
QS9TDQpIZWRlYWdlciAzDQpESy04MjAwIEFhcmh1cyBODQorNDUgNTEyMTAyNzQNCnJhc211cy52
aWxsZW1vZXNAcHJldmFzLmRrDQp3d3cucHJldmFzLmRrDQo=
