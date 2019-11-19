Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9286B101286
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 05:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbfKSEgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 23:36:32 -0500
Received: from mail-eopbgr00047.outbound.protection.outlook.com ([40.107.0.47]:56718
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726647AbfKSEgc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 23:36:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ez6Rnj63SFwClRlXXmv1OADs+IrKqeBnjCPKB9KVobatzsAs97LSmIK8W+lTXcp3OTM15aDVQSFdO4nQvzx1L6XX0R3guhUzOfzasfqN72Az7UNHsUOQAMUF+pUmOBIKBUTT0/JluT1my5KI+pY+/DmaivYPlT9N4gPr22xSlJ7KL9Kcnls5ykqC4rGAmtmjdCvERFRjDmeYfdpGFhLZieiOIrucrlcCI8R+0I69xG0x+kCl47Dp3lkakNdoukEgQqbbggUkKbDcHllyiIHONGWj0VLXbqqBnfZ7FIW/ZT4wGORWKutOCdcrFcbaQvBPzgO5CHWrmVcgJCTNf18y/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GmKYl7AtorzVWnOlbNdx+NPxFOiichKUZ7hMp1HqYSY=;
 b=KEyJQ++21Uqy8g+kBowfF+GtfVzIyOlNe274/ZOtX+jwL1QlpEIZTjrFg0SaDOmXPZ5rcO0PSXgGD4h2GhCT/E+Gjn8MUh/SqzCDOk2pmTDlypksS6YZVgCMers3Bvd3tmNqE/vozJkSm534kBYmqeFxFJlw3kBP+vQDogSjiNs9XkwJ4qMSJyG+K7rfY8r7JtpFMGq9Zm3znJ/dHd0AVtbtrlgrKWu08oqPPcnPTufLVeAiVoFziccXk7TU6QTJunpNU8b6gBnbR83mlQANHVmqfRUs3FeWl4OoLk92IwKREhs1YmbqTasndK2AhCGeuZH9Ty9evtRNJoWpSU3qTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GmKYl7AtorzVWnOlbNdx+NPxFOiichKUZ7hMp1HqYSY=;
 b=hXC40sKGU/sKe7Ke0tW7J2zderrQvzDqrN/H1DEZFGEFbVPHXJMpiPKNdxfuW+LpHRe7rm/bOdHBFPtVbl5VlWA/v8rHYjRhYFAFrVYoaA1u60/MCZotCEeFgCZqoCeHtomvmUpcDB9DzcVqbFtPYmWIWZt5QLBirnhFP6jtENg=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4354.eurprd05.prod.outlook.com (52.134.90.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.27; Tue, 19 Nov 2019 04:36:28 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2451.029; Tue, 19 Nov 2019
 04:36:28 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jason Wang <jasowang@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Dave Ertman <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, Kiran Patil <kiran.patil@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Bie, Tiwei" <tiwei.bie@intel.com>
Subject: RE: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Topic: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Index: AQHVnATItanP+SK9PEuJkGaYy2/dTKeM1NrAgAURC4CAAAcf0A==
Date:   Tue, 19 Nov 2019 04:36:27 +0000
Message-ID: <AM0PR05MB4866C40A177D3D60BFC558F7D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com>
 <AM0PR05MB4866CF61828A458319899664D1700@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <a40c09ee-0915-f10c-650e-7539726a887b@redhat.com>
In-Reply-To: <a40c09ee-0915-f10c-650e-7539726a887b@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [68.203.16.89]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7d2ed223-958e-4bee-b21b-08d76caa0aff
x-ms-traffictypediagnostic: AM0PR05MB4354:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM0PR05MB435407643E49712EE3E9F47DD14C0@AM0PR05MB4354.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 022649CC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(199004)(189003)(446003)(256004)(186003)(99286004)(5024004)(305945005)(14454004)(76116006)(11346002)(71190400001)(71200400001)(102836004)(81156014)(81166006)(66946007)(26005)(966005)(7736002)(86362001)(5660300002)(8676002)(478600001)(229853002)(2201001)(66476007)(66556008)(64756008)(66446008)(476003)(7696005)(4326008)(6506007)(9686003)(76176011)(486006)(33656002)(55016002)(6306002)(25786009)(54906003)(52536014)(2906002)(6246003)(316002)(74316002)(6116002)(2501003)(110136005)(3846002)(6436002)(8936002)(66066001)(7416002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4354;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A8W+9SsHkE5pUhrIqZ+OQTQazEjLcKPzmQut6/zSD/wMDqm7V0ciadq/BKj/0/wvIzIYstggn2M9Wn5fx2J9IjjIOoxugz8RbRiRj70fFQHo2kOzEa1asEtLjLtZnY+SoKSIIvUm2iffYmeqXDmoYH74gNrNOHWmOhHofKmsJ20LB7MhuhID4sUmW0NsQ8GpBeDtYedPmySRPAKCri6vHjPX87eYNJgjDRYNQyzOaX9LLQ1OIjHatuspu5ZCG9RG7aTRllD5W3/CXNxbHn0phGPuolnaCT0j9GqIMSsfUfOURs/iawTH7Tz75Z4ULFJoKgs6wZuKe6QGlaMPwGPSL7r37F58KNls8dcqrqekSmt819/sLAkj5fTiTFlfjqRGR7+9p/tmU4Xw+SwSlSc1ultFt0jxAquUc0gw16zp8Vnx1ShLF0fnpFjRIyV5iKJhXBdKfpMFRLDdv/10/I7Gq9ABbasru1ew4dwBGQI6DSQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d2ed223-958e-4bee-b21b-08d76caa0aff
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2019 04:36:27.9574
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I07Rdww9EH5WDflKkBlxKtzItic9Uasy6MtVl0K4s9W1BJygWXGunCIa7Zj+L9FwfZXMpmXrFublIqRPjocHGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4354
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmFzb24gV2FuZywNCg0KPiBGcm9tOiBKYXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRoYXQuY29t
Pg0KPiBTZW50OiBNb25kYXksIE5vdmVtYmVyIDE4LCAyMDE5IDEwOjA4IFBNDQo+IA0KPiBPbiAy
MDE5LzExLzE2IOS4iuWNiDc6MjUsIFBhcmF2IFBhbmRpdCB3cm90ZToNCj4gPiBIaSBKZWZmLA0K
PiA+DQo+ID4+IEZyb206IEplZmYgS2lyc2hlciA8amVmZnJleS50LmtpcnNoZXJAaW50ZWwuY29t
Pg0KPiA+PiBTZW50OiBGcmlkYXksIE5vdmVtYmVyIDE1LCAyMDE5IDQ6MzQgUE0NCj4gPj4NCj4g
Pj4gRnJvbTogRGF2ZSBFcnRtYW4gPGRhdmlkLm0uZXJ0bWFuQGludGVsLmNvbT4NCj4gPj4NCj4g
Pj4gVGhpcyBpcyB0aGUgaW5pdGlhbCBpbXBsZW1lbnRhdGlvbiBvZiB0aGUgVmlydHVhbCBCdXMs
IHZpcnRidXNfZGV2aWNlDQo+ID4+IGFuZCB2aXJ0YnVzX2RyaXZlci4gIFRoZSB2aXJ0dWFsIGJ1
cyBpcyBhIHNvZnR3YXJlIGJhc2VkIGJ1cyBpbnRlbmRlZA0KPiA+PiB0byBzdXBwb3J0IGxpZ2h0
d2VpZ2h0IGRldmljZXMgYW5kIGRyaXZlcnMgYW5kIHByb3ZpZGUgbWF0Y2hpbmcNCj4gPj4gYmV0
d2VlbiB0aGVtIGFuZCBwcm9iaW5nIG9mIHRoZSByZWdpc3RlcmVkIGRyaXZlcnMuDQo+ID4+DQo+
ID4+IFRoZSBwcmltYXJ5IHB1cnBvc2Ugb2YgdGhlIHZpcnVhbCBidXMgaXMgdG8gcHJvdmlkZSBt
YXRjaGluZyBzZXJ2aWNlcw0KPiA+PiBhbmQgdG8gcGFzcyB0aGUgZGF0YSBwb2ludGVyIGNvbnRh
aW5lZCBpbiB0aGUgdmlydGJ1c19kZXZpY2UgdG8gdGhlDQo+ID4+IHZpcnRidXNfZHJpdmVyIGR1
cmluZyBpdHMgcHJvYmUgY2FsbC4gIFRoaXMgd2lsbCBhbGxvdyB0d28gc2VwYXJhdGUNCj4gPj4g
a2VybmVsIG9iamVjdHMgdG8gbWF0Y2ggdXAgYW5kIHN0YXJ0IGNvbW11bmljYXRpb24uDQo+ID4+
DQo+ID4gSXQgaXMgZnVuZGFtZW50YWwgdG8ga25vdyB0aGF0IHJkbWEgZGV2aWNlIGNyZWF0ZWQg
YnkgdmlydGJ1c19kcml2ZXIgd2lsbCBiZQ0KPiBhbmNob3JlZCB0byB3aGljaCBidXMgZm9yIGFu
IG5vbiBhYnVzaXZlIHVzZS4NCj4gPiB2aXJ0YnVzIG9yIHBhcmVudCBwY2kgYnVzPw0KPiA+IEkg
YXNrZWQgdGhpcyBxdWVzdGlvbiBpbiB2MSB2ZXJzaW9uIG9mIHRoaXMgcGF0Y2guDQo+ID4NCj4g
PiBBbHNvIHNpbmNlIGl0IHNheXMgLSAndG8gc3VwcG9ydCBsaWdodHdlaWdodCBkZXZpY2VzJywg
ZG9jdW1lbnRpbmcgdGhhdA0KPiBpbmZvcm1hdGlvbiBpcyBjcml0aWNhbCB0byBhdm9pZCBhbWJp
Z3VpdHkuDQo+ID4NCj4gPiBTaW5jZSBmb3IgYSB3aGlsZSBJIGFtIHdvcmtpbmcgb24gdGhlIHN1
YmJ1cy9zdWJkZXZfYnVzL3hidXMvbWRldiBbMV0NCj4gd2hhdGV2ZXIgd2Ugd2FudCB0byBjYWxs
IGl0LCBpdCBvdmVybGFwcyB3aXRoIHlvdXIgY29tbWVudCBhYm91dCAndG8gc3VwcG9ydA0KPiBs
aWdodHdlaWdodCBkZXZpY2VzJy4NCj4gPiBIZW5jZSBsZXQncyBtYWtlIHRoaW5ncyBjcnlzdGFs
IGNsZWFyIHdlYXRoZXIgdGhlIHB1cnBvc2UgaXMgJ29ubHkgbWF0Y2hpbmcNCj4gc2VydmljZScg
b3IgYWxzbyAnbGlnaHR3ZWlnaHQgZGV2aWNlcycuDQo+ID4gSWYgdGhpcyBpcyBvbmx5IG1hdGNo
aW5nIHNlcnZpY2UsIGxldHMgcGxlYXNlIHJlbW92ZSBsaWdodHdlaWdodCBkZXZpY2VzIHBhcnQu
Lg0KPiANCj4gDQo+IFllcywgaWYgaXQncyBtYXRjaGluZyArIGxpZ2h0d2VpZ2h0IGRldmljZSwg
aXRzIGZ1bmN0aW9uIGlzIGFsbW9zdCBhIGR1cGxpY2F0aW9uIG9mDQo+IG1kZXYuIEFuZCBJJ20g
d29ya2luZyBvbiBleHRlbmRpbmcgbWRldlsxXSB0byBiZSBhIGdlbmVyaWMgbW9kdWxlIHRvDQo+
IHN1cHBvcnQgYW55IHR5cGVzIG9mIHZpcnR1YWwgZGV2aWNlcyBhIHdoaWxlLiBUaGUgYWR2YW50
YWdlIG9mIG1kZXYgaXM6DQo+IA0KPiAxKSByZWFkeSBmb3IgdGhlIHVzZXJzcGFjZSBkcml2ZXIg
KFZGSU8gYmFzZWQpDQo+IDIpIGhhdmUgYSBzeXNmcy9HVUlEIGJhc2VkIG1hbmFnZW1lbnQgaW50
ZXJmYWNlDQo+IA0KPiBTbyBmb3IgMSwgaXQncyBub3QgY2xlYXIgdGhhdCBob3cgdXNlcnNwYWNl
IGRyaXZlciB3b3VsZCBiZSBzdXBwb3J0ZWQgaGVyZSwgb3INCj4gaXQncyBjb21wbGV0ZWx5IG5v
dCBiZWluZyBhY2NvdW50ZWQgaW4gdGhpcyBzZXJpZXM/IEZvciAyLCBpdCBsb29rcyB0byBtZSB0
aGF0IHRoaXMNCj4gc2VyaWVzIGxlYXZlIGl0IHRvIHRoZSBpbXBsZW1lbnRhdGlvbiwgdGhpcyBt
ZWFucyBtYW5hZ2VtZW50IHRvIGxlYXJuIHNldmVyYWwNCj4gdmVuZG9yIHNwZWNpZmljIGludGVy
ZmFjZXMgd2hpY2ggc2VlbXMgYSBidXJkZW4uDQo+IA0KPiBOb3RlLCB0ZWNobmljYWxseSBWaXJ0
dWFsIEJ1cyBjb3VsZCBiZSBpbXBsZW1lbnRlZCBvbiB0b3Agb2YgWzFdIHdpdGggdGhlIGZ1bGwN
Cj4gbGlmZWN5Y2xlIEFQSS4NCj4gDQo+IFsxXSBodHRwczovL2xrbWwub3JnL2xrbWwvMjAxOS8x
MS8xOC8yNjENCj4gDQo+IA0KPiA+DQo+ID4gWW91IGFkZGl0aW9uYWxseSBuZWVkIG1vZHBvc3Qg
c3VwcG9ydCBmb3IgaWQgdGFibGUgaW50ZWdyYXRpb24gdG8gbW9kaWZvLA0KPiBtb2Rwcm9iZSBh
bmQgb3RoZXIgdG9vbHMuDQo+ID4gQSBzbWFsbCBwYXRjaCBzaW1pbGFyIHRvIHRoaXMgb25lIFsy
XSBpcyBuZWVkZWQuDQo+ID4gUGxlYXNlIGluY2x1ZGUgaW4gdGhlIHNlcmllcy4NCj4gPg0KPiA+
IFsuLl0NCj4gDQo+IA0KPiBBbmQgcHJvYmFibHkgYSB1ZXZlbnQgbWV0aG9kLiBCdXQgcmV0aGlu
a2luZyBvZiB0aGlzLCBtYXRjaGluZyB0aHJvdWdoIGENCj4gc2luZ2xlIHZpcnR1YWwgYnVzIHNl
ZW1zIG5vdCBnb29kLiBXaGF0IGlmIGRyaXZlciB3YW50IHRvIGRvIHNvbWUgc3BlY2lmaWMNCj4g
bWF0Y2hpbmc/IEUuZyBmb3IgdmlydGlvLCB3ZSBtYXkgd2FudCBhIHZob3N0LW5ldCBkcml2ZXIg
dGhhdCBvbmx5IG1hdGNoDQo+IG5ldHdvcmtpbmcgZGV2aWNlLiBXaXRoIGEgc2luZ2xlIGJ1cywg
aXQgcHJvYmFibHkgbWVhbnMgeW91IG5lZWQgYW5vdGhlciBidXMNCj4gb24gdG9wIGFuZCBwcm92
aWRlIHRoZSB2aXJ0aW8gc3BlY2lmaWMgbWF0Y2hpbmcgdGhlcmUuDQo+IFRoaXMgbG9va3Mgbm90
IHN0cmFpZ2h0Zm9yd2FyZCBhcyBhbGxvd2luZyBtdWx0aXBsZSB0eXBlIG9mIGJ1c2VzLg0KPiAN
ClRoZSBwdXJwb3NlIG9mIHRoZSBidXMgaXMgdG8gYXR0YWNoIHR3byBkcml2ZXJzLCBtbHg1X2Nv
cmUgKGNyZWF0b3Igb2YgbmV0ZGV2aWNlcykgYW5kIG1seDVfaWIgKGNyZWF0ZSBvZiByZG1hIGRl
dmljZXMpIG9uIHNpbmdsZSBQQ0kgZnVuY3Rpb24uDQpNZWFuaW5nICdtdWx0aXBsZSBjbGFzc2Vz
IG9mIGRldmljZXMnIGFyZSBjcmVhdGVkIG9uIHRvcCBvZiBzaW5nbGUgdW5kZXJseWluZyBwYXJl
bnQgZGV2aWNlLg0KDQpTbyBidXMgaXMganVzdCB0aGUgJ21hdGNoaW5nIHNlcnZpY2UnIGFuZCBu
b3RoaW5nIG1vcmUuIEl0IGlzIG5vdCBtZWFudCB0byBhZGRyZXNzIHZpcnRpbywgbWRldiwgc3Vi
IGZ1bmN0aW9ucyB1c2VjYXNlcy4NCg==
