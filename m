Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAB3FE231F
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 21:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390262AbfJWTJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 15:09:17 -0400
Received: from mail-eopbgr50061.outbound.protection.outlook.com ([40.107.5.61]:50350
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389752AbfJWTJQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 15:09:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZCUPTRqwQJGfUkrfViuG82uK+BkrqvjHgcrARlqxLHj0N0C5QO/+0KkT9htcloqKTqgyrmgsBs0EwtiQAUX/3KPFE977l9NDF17ielH450hPdyqKsZzSq+TZ3HV6u1HWi8doEHCKDNzswa9y0apKpEX06oeWRQeyZIPDOUbDTznqJaRvxMZ9vfAguTpkwTZTg0B84wIuIP/MUwSiys0mfgevHjKBtONXE0xlwhQfEbi6VWHts5/XxcWFWSfWS0P/p79FdnmdpYWMj6qg/jp+cBjxCvEKpokGvsjGYqkRnZN5DbbAU4SLzLNliI8VL7JCIL4o4TfzJn5UFbCWGWptvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6CzAkPqCHjSxZQWer10L8Lnhfye5glqPC1yjaqab+0Q=;
 b=jMDj2StfO/iW8TsOECONlH0TIM5WNOGIOW5NGOTv/oOsd9c9+UNAJI2lUql9NwXRSndVJk9y5Tk6lX+z0SP/mBSinozmOO3HB+RQaje6VV6gEj8Q+wNhrEWlhYtQ29Zv6uGlVOpujNVI+9s6Byfcmy+Eeeni+RpwS0Feo7um4dzNa2OTYdsCvrJXCqgJ9PKPYc3LiVIyVezj8TfJkRHyLKunOsiUsTXLyN4jVjH5aCx4zBbfzD31QH5lDL8BJ4Wt9YvXcNBmLPikauidwLbLgt7oOP2xnuYpmAxJ75VwzCyKFFPdSOcpv+cdJ1LHv4Js0rAShlTvi5MCIAKNi7Rshw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6CzAkPqCHjSxZQWer10L8Lnhfye5glqPC1yjaqab+0Q=;
 b=dIJmhlybakYSjh6yDnUwXt6m5JAeuFpuIyotIFemwsfyZxOECzoKHI/eqMf/y/0lPBTsR9+WId2P1HCFZsbKwF0u4ji+meEclZ0WsszObzPovXUY0zvvwcBDjCFlod7twmiiReDhmDhtKUnr5z6SUChXuR24kqSwkTvadVhtna8=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4541.eurprd05.prod.outlook.com (20.176.2.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Wed, 23 Oct 2019 19:09:10 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.029; Wed, 23 Oct 2019
 19:09:10 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "brouer@redhat.com" <brouer@redhat.com>
CC:     "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>
Subject: Re: [PATCH net-next 2/4] page_pool: Don't recycle non-reusable pages
Thread-Topic: [PATCH net-next 2/4] page_pool: Don't recycle non-reusable pages
Thread-Index: AQHViJNfDryJ+xPlQUSOm+5NjxXjMqdokQeAgAAIggA=
Date:   Wed, 23 Oct 2019 19:09:10 +0000
Message-ID: <f4d8cd220f020a6483a70cf2044b73031102b9c1.camel@mellanox.com>
References: <20191022044343.6901-1-saeedm@mellanox.com>
         <20191022044343.6901-3-saeedm@mellanox.com>
         <20191023203841.21234946@carbon>
In-Reply-To: <20191023203841.21234946@carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2cda8490-f0b7-4e4b-7b81-08d757ec7c8a
x-ms-traffictypediagnostic: VI1PR05MB4541:
x-microsoft-antispam-prvs: <VI1PR05MB454132CDAF4634A71687ADE5BE6B0@VI1PR05MB4541.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(376002)(39860400002)(396003)(136003)(199004)(189003)(52314003)(102836004)(14454004)(76116006)(7736002)(86362001)(91956017)(446003)(486006)(8676002)(118296001)(2906002)(2351001)(66946007)(26005)(36756003)(99286004)(66066001)(81156014)(1730700003)(186003)(81166006)(64756008)(66556008)(66446008)(8936002)(305945005)(2616005)(4001150100001)(66476007)(476003)(6116002)(3846002)(54906003)(6436002)(25786009)(58126008)(14444005)(11346002)(316002)(256004)(6512007)(6486002)(2501003)(71190400001)(5660300002)(478600001)(71200400001)(6916009)(76176011)(5640700003)(229853002)(4326008)(6246003)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4541;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Sh6AiuACImkzlzi3f85lg7eLehzlmraK8FFro8IkSUmsN7w2SiCVfbOzZioxim7NWKhvwaHVuJcA60BamemK+mJrUINtEnAzN6EuB8OeqdWFpUhPfEG4D3FjL8+Nfib0PUj0BnmU/gLwLFrf6JiLELZUW99psC7qRDxFWFdxbD47SmybYGrgzmownYQuNpxDztGQreCmZpb9xfGTQwrHwXoPQJr3YSfoUrVOe/IY5hkUJU4s0itsikuMsxk2eR2HydimdlmMPgv2rAp4uhwBBDlYJOuCcTMl4n+zyjWpQnubB/2qPWnerSDlv0Dhq4bLvOSyxblNiFHRSwPKAYSzEhLXxyfyUX7kuKZ7JtkoQCetnwRmqc74B+zIa64dZMfW8lKgEu89LrOxd0eWtONyYRajwVJzXYFepK90QHU7IHrqUMADSpUbUqRohKqW0hQ4
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <7BFC1AADF18CB14B85AC07EBBD6054F4@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cda8490-f0b7-4e4b-7b81-08d757ec7c8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 19:09:10.8433
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1mIWHPU5Yh4F7bmjMxatEkd9V2GejLvFdziybNQwKKzuXFHSPLd8nK4OO4/tPIJSeQUbn1slpCBNhPtxnlwBYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4541
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTEwLTIzIGF0IDIwOjM4ICswMjAwLCBKZXNwZXIgRGFuZ2FhcmQgQnJvdWVy
IHdyb3RlOg0KPiBPbiBUdWUsIDIyIE9jdCAyMDE5IDA0OjQ0OjIxICswMDAwDQo+IFNhZWVkIE1h
aGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPiB3cm90ZToNCj4gDQo+ID4gQSBwYWdlIGlzIE5P
VCByZXVzYWJsZSB3aGVuIGF0IGxlYXN0IG9uZSBvZiB0aGUgZm9sbG93aW5nIGlzIHRydWU6DQo+
ID4gMSkgYWxsb2NhdGVkIHdoZW4gc3lzdGVtIHdhcyB1bmRlciBzb21lIHByZXNzdXJlLg0KPiA+
IChwYWdlX2lzX3BmbWVtYWxsb2MpDQo+ID4gMikgYmVsb25ncyB0byBhIGRpZmZlcmVudCBOVU1B
IG5vZGUgdGhhbiBwb29sLT5wLm5pZC4NCj4gPiANCj4gPiBUbyB1cGRhdGUgcG9vbC0+cC5uaWQg
dXNlcnMgc2hvdWxkIGNhbGwgcGFnZV9wb29sX3VwZGF0ZV9uaWQoKS4NCj4gPiANCj4gPiBIb2xk
aW5nIG9uIHRvIHN1Y2ggcGFnZXMgaW4gdGhlIHBvb2wgd2lsbCBodXJ0IHRoZSBjb25zdW1lcg0K
PiA+IHBlcmZvcm1hbmNlDQo+ID4gd2hlbiB0aGUgcG9vbCBtaWdyYXRlcyB0byBhIGRpZmZlcmVu
dCBudW1hIG5vZGUuDQo+ID4gDQo+ID4gUGVyZm9ybWFuY2UgdGVzdGluZzoNCj4gPiBYRFAgZHJv
cC90eCByYXRlIGFuZCBUQ1Agc2luZ2xlL211bHRpIHN0cmVhbSwgb24gbWx4NSBkcml2ZXINCj4g
PiB3aGlsZSBtaWdyYXRpbmcgcnggcmluZyBpcnEgZnJvbSBjbG9zZSB0byBmYXIgbnVtYToNCj4g
PiANCj4gPiBtbHg1IGludGVybmFsIHBhZ2UgY2FjaGUgd2FzIGxvY2FsbHkgZGlzYWJsZWQgdG8g
Z2V0IHB1cmUgcGFnZSBwb29sDQo+ID4gcmVzdWx0cy4NCj4gPiANCj4gPiBDUFU6IEludGVsKFIp
IFhlb24oUikgQ1BVIEU1LTI2MDMgdjQgQCAxLjcwR0h6DQo+ID4gTklDOiBNZWxsYW5veCBUZWNo
bm9sb2dpZXMgTVQyNzcwMCBGYW1pbHkgW0Nvbm5lY3RYLTRdICgxMDBHKQ0KPiA+IA0KPiA+IFhE
UCBEcm9wL1RYIHNpbmdsZSBjb3JlOg0KPiA+IE5VTUEgIHwgWERQICB8IEJlZm9yZSAgICB8IEFm
dGVyDQo+ID4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4gQ2xv
c2UgfCBEcm9wIHwgMTEgICBNcHBzIHwgMTAuOCBNcHBzDQo+ID4gRmFyICAgfCBEcm9wIHwgNC40
ICBNcHBzIHwgNS44ICBNcHBzDQo+ID4gDQo+ID4gQ2xvc2UgfCBUWCAgIHwgNi41IE1wcHMgIHwg
Ni41IE1wcHMNCj4gPiBGYXIgICB8IFRYICAgfCA0ICAgTXBwcyAgfCAzLjUgIE1wcHMNCj4gPiAN
Cj4gPiBJbXByb3ZlbWVudCBpcyBhYm91dCAzMCUgZHJvcCBwYWNrZXQgcmF0ZSwgMTUlIHR4IHBh
Y2tldCByYXRlIGZvcg0KPiA+IG51bWENCj4gPiBmYXIgdGVzdC4NCj4gPiBObyBkZWdyYWRhdGlv
biBmb3IgbnVtYSBjbG9zZSB0ZXN0cy4NCj4gPiANCj4gPiBUQ1Agc2luZ2xlL211bHRpIGNwdS9z
dHJlYW06DQo+ID4gTlVNQSAgfCAjY3B1IHwgQmVmb3JlICB8IEFmdGVyDQo+ID4gLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gPiBDbG9zZSB8IDEgICAgfCAxOCBHYnBz
IHwgMTggR2Jwcw0KPiA+IEZhciAgIHwgMSAgICB8IDE1IEdicHMgfCAxOCBHYnBzDQo+ID4gQ2xv
c2UgfCAxMiAgIHwgODAgR2JwcyB8IDgwIEdicHMNCj4gPiBGYXIgICB8IDEyICAgfCA2OCBHYnBz
IHwgODAgR2Jwcw0KPiA+IA0KPiA+IEluIGFsbCB0ZXN0IGNhc2VzIHdlIHNlZSBpbXByb3ZlbWVu
dCBmb3IgdGhlIGZhciBudW1hIGNhc2UsIGFuZCBubw0KPiA+IGltcGFjdCBvbiB0aGUgY2xvc2Ug
bnVtYSBjYXNlLg0KPiA+IA0KPiA+IFRoZSBpbXBhY3Qgb2YgYWRkaW5nIGEgY2hlY2sgcGVyIHBh
Z2UgaXMgdmVyeSBuZWdsaWdpYmxlLCBhbmQgc2hvd3MNCj4gPiBubw0KPiA+IHBlcmZvcm1hbmNl
IGRlZ3JhZGF0aW9uIHdoYXRzb2V2ZXIsIGFsc28gZnVuY3Rpb25hbGl0eSB3aXNlIGl0DQo+ID4g
c2VlbXMgbW9yZQ0KPiA+IGNvcnJlY3QgYW5kIG1vcmUgcm9idXN0IGZvciBwYWdlIHBvb2wgdG8g
dmVyaWZ5IHdoZW4gcGFnZXMgc2hvdWxkDQo+ID4gYmUNCj4gPiByZWN5Y2xlZCwgc2luY2UgcGFn
ZSBwb29sIGNhbid0IGd1YXJhbnRlZSB3aGVyZSBwYWdlcyBhcmUgY29taW5nDQo+ID4gZnJvbS4N
Cj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94
LmNvbT4NCj4gPiBBY2tlZC1ieTogSm9uYXRoYW4gTGVtb24gPGpvbmF0aGFuLmxlbW9uQGdtYWls
LmNvbT4NCj4gPiAtLS0NCj4gPiAgbmV0L2NvcmUvcGFnZV9wb29sLmMgfCAxNCArKysrKysrKysr
KysrLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMTMgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigt
KQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9uZXQvY29yZS9wYWdlX3Bvb2wuYyBiL25ldC9jb3Jl
L3BhZ2VfcG9vbC5jDQo+ID4gaW5kZXggMDhjYTk5MTVjNjE4Li44MTIwYWVjOTk5Y2UgMTAwNjQ0
DQo+ID4gLS0tIGEvbmV0L2NvcmUvcGFnZV9wb29sLmMNCj4gPiArKysgYi9uZXQvY29yZS9wYWdl
X3Bvb2wuYw0KPiA+IEBAIC0yODMsNiArMjgzLDE3IEBAIHN0YXRpYyBib29sIF9fcGFnZV9wb29s
X3JlY3ljbGVfZGlyZWN0KHN0cnVjdA0KPiA+IHBhZ2UgKnBhZ2UsDQo+ID4gIAlyZXR1cm4gdHJ1
ZTsNCj4gPiAgfQ0KPiA+ICANCj4gPiArLyogcGFnZSBpcyBOT1QgcmV1c2FibGUgd2hlbjoNCj4g
PiArICogMSkgYWxsb2NhdGVkIHdoZW4gc3lzdGVtIGlzIHVuZGVyIHNvbWUgcHJlc3N1cmUuDQo+
ID4gKHBhZ2VfaXNfcGZtZW1hbGxvYykNCj4gPiArICogMikgYmVsb25ncyB0byBhIGRpZmZlcmVu
dCBOVU1BIG5vZGUgdGhhbiBwb29sLT5wLm5pZC4NCj4gPiArICoNCj4gPiArICogVG8gdXBkYXRl
IHBvb2wtPnAubmlkIHVzZXJzIG11c3QgY2FsbCBwYWdlX3Bvb2xfdXBkYXRlX25pZC4NCj4gPiAr
ICovDQo+ID4gK3N0YXRpYyBib29sIHBvb2xfcGFnZV9yZXVzYWJsZShzdHJ1Y3QgcGFnZV9wb29s
ICpwb29sLCBzdHJ1Y3QgcGFnZQ0KPiA+ICpwYWdlKQ0KPiA+ICt7DQo+ID4gKwlyZXR1cm4gIXBh
Z2VfaXNfcGZtZW1hbGxvYyhwYWdlKSAmJiBwYWdlX3RvX25pZChwYWdlKSA9PSBwb29sLQ0KPiA+
ID5wLm5pZDsNCj4gDQo+IEkgdGhpbmsgd2UgaGF2ZSBkaXNjdXNzZWQgdGhpcyBiZWZvcmUuIFlv
dSBhcmUgYWRkaW5nIHRoZQ0KPiBwYWdlX2lzX3BmbWVtYWxsb2MocGFnZSkgbWVtb3J5IHByZXNz
dXJlIHRlc3QsIGV2ZW4tdGhvdWdoIHRoZQ0KPiBhbGxvY2F0aW9uIHNpZGUgb2YgcGFnZV9wb29s
IHdpbGwgbm90IGdpdmUgdXMgdGhlc2Uga2luZCBvZiBwYWdlcy4NCj4gDQo+IEknbSBnb2luZyB0
byBhY2NlcHQgdGhpcyBhbnl3YXksIGFzIGl0IGlzIGEgZ29vZCBzYWZlZ3VhcmQsIGFzIGl0IGlz
DQo+IGENCj4gdmVyeSBiYWQgdGhpbmcgdG8gcmVjeWNsZSBzdWNoIGEgcGFnZS4gIFBlcmZvcm1h
bmNlIHdpc2UsIHlvdSBoYXZlDQo+IHNob3dlZCBpdCBoYXZlIGFsbW9zdCB6ZXJvIGltcGFjdCwg
d2hpY2ggSSBndWVzcyBpcyBiZWNhdXNlIHdlIGFyZQ0KPiBhbHJlYWR5IHJlYWRpbmcgdGhlIHN0
cnVjdCBwYWdlIGFyZWEgaGVyZS4NCg0KWWVzLCB0aGF0IGlzIHRoZSBjYXNlLCBhbmQgc2luY2Ug
dGhlIHBhZ2UgcG9vbCBhbGxvd3MgY29uc3VtZXJzIHRvDQpyZXR1cm4gYW55IHBhZ2UgdG8gdGhl
IHBvb2wgKGV2ZW4gcGFnZXMgdGhhdCB3ZXJlbid0IGFsbG9jYXRlZCB1c2luZw0KdGhlIHBvb2wg
QVBJcyksIGl0IHNlZW1zIG5lY2Vzc2FyeSB0byBkbyBzdWNoIGNoZWNrcy4NCg0KDQo=
