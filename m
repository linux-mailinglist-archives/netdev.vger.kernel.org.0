Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7ABA1AE884
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 01:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbgDQXJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 19:09:08 -0400
Received: from mail-am6eur05on2071.outbound.protection.outlook.com ([40.107.22.71]:29313
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726036AbgDQXJH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 19:09:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=enLvHDi29jKdSiysGJ8RB1vTNvcOy4ovUeu5Mnoq9p3n3jtxSB6vQucNX1hge9KsMe2DM8SbbpVONcuPlsQFbulptwIoUUA5Eu9eb1dJoaUfN/Gxxs9gfKN/2bYd+3AJRbhchH9vYSEDl9KUsVDcl85/i+TYCiyAvC0egRoMjRsZ6KoQfInr0CyBwO2v+qtbwTLuq1u0/K0aMpMGlkwfS7atOH4ks/NlIGEGNASBYhb2vR+7PJl3fHzHxJ025mxGC5WpLCNmE96lWb2teqNtecwP5B4ylu29OXYp19dd73kcm5AxI2VgPaoukvMQ1PLqI09nqun9RZu1lmtNkD1U6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WsaY1XQPlxUw4A9F1En1d1KfcghoiOkPd6GQOL8PmqE=;
 b=VSWkKzcdyWkXk6kDGkUbw4/m3xZRE4axr3DiqekLFmqQW9z00ONjijfhTCIgGUpJuDfwGp0JBfM1IiXgV223j9qel20Pxhzdfi6S+GGLZrol9mULTH+a+aXwL4gT+9ypvevgcu8veRVFnovLJpwXn+B5Xacvnwnq+Tutl2urFQ193397OibT1nKSoacdtPvyLOf9maN9mhPvrk4ht0XPBUnFkH8zbK5QeeXJSCZLwHj8HEmdXShSeiFs4Mc28Ru7kABpEnSpjj3OcRqDdFTl9lr/CrsGPWerg23jiIib4eToZcwkLjOJHzyj9izMEyiqHPqVuL64QHYJYzGuIpmkOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WsaY1XQPlxUw4A9F1En1d1KfcghoiOkPd6GQOL8PmqE=;
 b=O8Apu0MdN47N24Xi9Fnta/k5ocOEaexBAP/ttCAnbfN+5R0laf0ceo2jygHJDTBh7u6/HrJCtpexmyMMy7k9dT4TC7rm8KcHri3MozInXzG65M5Xm0SxV6mbvv8QxBON9F0N+XhYDcwWpw9nhYxCE3PBZSqQLloMEtEAUGFWhkg=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5199.eurprd05.prod.outlook.com (2603:10a6:803:b0::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.20; Fri, 17 Apr
 2020 23:09:02 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2900.030; Fri, 17 Apr 2020
 23:09:02 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "brouer@redhat.com" <brouer@redhat.com>
CC:     "akiyano@amazon.com" <akiyano@amazon.com>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "borkmann@iogearbox.net" <borkmann@iogearbox.net>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "toke@redhat.com" <toke@redhat.com>,
        "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>,
        "gtzalik@amazon.com" <gtzalik@amazon.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "sameehj@amazon.com" <sameehj@amazon.com>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "zorik@amazon.com" <zorik@amazon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "lorenzo@kernel.org" <lorenzo@kernel.org>
Subject: Re: [PATCH RFC v2 01/33] xdp: add frame size to xdp_buff
Thread-Topic: [PATCH RFC v2 01/33] xdp: add frame size to xdp_buff
Thread-Index: AQHWDZv32mnm8kot3EKhksvfBkWZN6hv9mAAgAvNAwCAAjvAAA==
Date:   Fri, 17 Apr 2020 23:09:02 +0000
Message-ID: <eb6f2f9c62d57525312ddf74e57efdc578736ebf.camel@mellanox.com>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
         <158634663936.707275.3156718045905620430.stgit@firesoul>
         <7fb99df47a9eae1fd0fc8dc85336f7df2c120744.camel@mellanox.com>
         <20200416150238.40560372@carbon>
In-Reply-To: <20200416150238.40560372@carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b7266ef2-0244-478f-6c69-08d7e32451d8
x-ms-traffictypediagnostic: VI1PR05MB5199:
x-microsoft-antispam-prvs: <VI1PR05MB5199C4EE9F0786CBC12EF782BED90@VI1PR05MB5199.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0376ECF4DD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(396003)(39860400002)(346002)(136003)(376002)(2616005)(91956017)(8936002)(76116006)(71200400001)(6916009)(66556008)(6512007)(54906003)(2906002)(66476007)(186003)(64756008)(4326008)(66946007)(6486002)(478600001)(5660300002)(8676002)(26005)(86362001)(36756003)(316002)(7416002)(81156014)(6506007)(66446008);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wfdmGO6mbCRhGbFAZtxipmBVyzffjThm6KoeiecUUF/n59CGDSL7GdIH6LdvS8E17vZ8hsL0ufNw1luqFlGcxV7sKOQJZz3lrq4us4hYdo3roYqcZdMVDVBQCrLw+NvJIjjzvvvIGO3nwxMAtF6qUqlyip/cFx/5fIRJjLVp1GRa6sVT2BfXnZbtwLS62/6FZpz5Fqbwyi0LKoCHh1G7oVk43M3poqm99mMcWyBgj+UuoYMxzwBaYmsqCjdyMVLpMfpBP/zq6baZEdsVxqZHp5W0SU4o9Xq9jEBjeaCAZUOzCakT8jfwEtxOlqR1/iN90SBQjbOk6T7Rhp+M5ebZzXWknnzAOwIf5QGW5TqVniNWV0ywla4aEt81EyUAuUHiMaWNZZ4J36AhVVk3oT/b2DsoaZOg4JLK0eP5hREvtPs8ieqKO1pd4O9uOrxAvSZ9
x-ms-exchange-antispam-messagedata: ar2uCY3zsRli38VZlOvPEpFPzQ0kAYTb420kNSalbRI+I1ghYsPITX/fvWvtZ5T68bEpxkiiI6+GK4skNWkZyUKvZTmTymBoC+TfQQWGNURrG7cT7dFLxHU1HWOdBi4YCBQbN/pxhUiFOWKBagdZ1g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <40A6CDF25C2B0B479584B6471E8992AB@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7266ef2-0244-478f-6c69-08d7e32451d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2020 23:09:02.6001
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vT9zG++DZU24YIKRBguKf+rKBACMVjbnB4SjK4eJzedIu3QOTtZNK4caybyfclpsNIu8wjRfS7B/rQd8eTxUXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5199
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA0LTE2IGF0IDE1OjAyICswMjAwLCBKZXNwZXIgRGFuZ2FhcmQgQnJvdWVy
IHdyb3RlOg0KPiBPbiBUaHUsIDkgQXByIDIwMjAgMDA6NTA6MDIgKzAwMDANCj4gU2FlZWQgTWFo
YW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+IHdyb3RlOg0KPiANCj4gPiBPbiBXZWQsIDIwMjAt
MDQtMDggYXQgMTM6NTAgKzAyMDAsIEplc3BlciBEYW5nYWFyZCBCcm91ZXIgd3JvdGU6DQo+ID4g
PiBYRFAgaGF2ZSBldm9sdmVkIHRvIHN1cHBvcnQgc2V2ZXJhbCBmcmFtZSBzaXplcywgYnV0IHhk
cF9idWZmIHdhcw0KPiA+ID4gbm90DQo+ID4gPiB1cGRhdGVkIHdpdGggdGhpcyBpbmZvcm1hdGlv
bi4gVGhlIGZyYW1lIHNpemUgKGZyYW1lX3N6KSBtZW1iZXINCj4gPiA+IG9mDQo+ID4gPiB4ZHBf
YnVmZiBpcyBpbnRyb2R1Y2VkIHRvIGtub3cgdGhlIHJlYWwgc2l6ZSBvZiB0aGUgbWVtb3J5IHRo
ZQ0KPiA+ID4gZnJhbWUNCj4gPiA+IGlzDQo+ID4gPiBkZWxpdmVyZWQgaW4uDQo+ID4gPiANCj4g
PiA+IFdoZW4gaW50cm9kdWNpbmcgdGhpcyBhbHNvIG1ha2UgaXQgY2xlYXIgdGhhdCBzb21lIHRh
aWxyb29tIGlzDQo+ID4gPiByZXNlcnZlZC9yZXF1aXJlZCB3aGVuIGNyZWF0aW5nIFNLQnMgdXNp
bmcgYnVpbGRfc2tiKCkuDQo+ID4gPiANCj4gPiA+IEl0IHdvdWxkIGFsc28gaGF2ZSBiZWVuIGFu
IG9wdGlvbiB0byBpbnRyb2R1Y2UgYSBwb2ludGVyIHRvDQo+ID4gPiBkYXRhX2hhcmRfZW5kICh3
aXRoIHJlc2VydmVkIG9mZnNldCkuIFRoZSBhZHZhbnRhZ2Ugd2l0aCBmcmFtZV9zeg0KPiA+ID4g
aXMNCj4gPiA+IHRoYXQgKGxpa2UgcnhxKSBkcml2ZXJzIG9ubHkgbmVlZCB0byBzZXR1cC9hc3Np
Z24gdGhpcyB2YWx1ZSBvbmNlDQo+ID4gPiBwZXINCj4gPiA+IE5BUEkgY3ljbGUuIER1ZSB0byBY
RFAtZ2VuZXJpYyAoYW5kIHNvbWUgZHJpdmVycykgaXQncyBub3QNCj4gPiA+IHBvc3NpYmxlDQo+
ID4gPiB0bw0KPiA+ID4gc3RvcmUgZnJhbWVfc3ogaW5zaWRlIHhkcF9yeHFfaW5mbywgYmVjYXVz
ZSBpdCdzIHZhcmllcyBwZXINCj4gPiA+IHBhY2tldCBhcw0KPiA+ID4gaXQNCj4gPiA+IGNhbiBi
ZSBiYXNlZC9kZXBlbmQgb24gcGFja2V0IGxlbmd0aC4NCj4gPiA+IA0KPiA+ID4gU2lnbmVkLW9m
Zi1ieTogSmVzcGVyIERhbmdhYXJkIEJyb3VlciA8YnJvdWVyQHJlZGhhdC5jb20+DQo+ID4gPiAt
LS0NCj4gPiA+ICBpbmNsdWRlL25ldC94ZHAuaCB8ICAgMTcgKysrKysrKysrKysrKysrKysNCj4g
PiA+ICAxIGZpbGUgY2hhbmdlZCwgMTcgaW5zZXJ0aW9ucygrKQ0KPiA+ID4gDQo+ID4gPiBkaWZm
IC0tZ2l0IGEvaW5jbHVkZS9uZXQveGRwLmggYi9pbmNsdWRlL25ldC94ZHAuaA0KPiA+ID4gaW5k
ZXggNDBjNmQzMzk4NDU4Li45OWY0Mzc0ZjYyMTQgMTAwNjQ0DQo+ID4gPiAtLS0gYS9pbmNsdWRl
L25ldC94ZHAuaA0KPiA+ID4gKysrIGIvaW5jbHVkZS9uZXQveGRwLmgNCj4gPiA+IEBAIC02LDYg
KzYsOCBAQA0KPiA+ID4gICNpZm5kZWYgX19MSU5VWF9ORVRfWERQX0hfXw0KPiA+ID4gICNkZWZp
bmUgX19MSU5VWF9ORVRfWERQX0hfXw0KPiA+ID4gIA0KPiA+ID4gKyNpbmNsdWRlIDxsaW51eC9z
a2J1ZmYuaD4gLyogc2tiX3NoYXJlZF9pbmZvICovDQo+ID4gPiArICANCj4gPiANCj4gPiBJIHRo
aW5rIGl0IGlzIHdyb25nIHRvIG1ha2UgeGRwLmggZGVwZW5kIG9uIHNrYnVmZi5oDQo+ID4gd2Ug
bXVzdCBrZWVwIHhkcC5oIG1pbmltYWwgYW5kIGluZGVwZW5kZW50LA0KPiANCj4gSSBhZ3JlZSwg
dGhhdCBpdCBzZWVtcyBzdHJhbmdlIHRvIGhhdmUgeGRwLmggaW5jbHVkZSBza2J1ZmYuaCwgYW5k
DQo+IEknbQ0KPiBub3QgaGFwcHkgd2l0aCB0aGF0IGFwcHJvYWNoIG15c2VsZiwgYnV0IHRoZSBh
bHRlcm5hdGl2ZXMgYWxsIGxvb2tlZA0KPiBraW5kIG9mIHVnbHkuDQo+IA0KPiA+IHRoZSBuZXcg
bWFjcm9zIHNob3VsZCBiZSBkZWZpbmVkIGluIHNrYnVmZi5oIA0KPiANCj4gTW92aW5nICNkZWZp
bmUgeGRwX2RhdGFfaGFyZF9lbmQoeGRwKSBpbnRvIHNrYnVmZi5oIGFsc28gc2VlbXMNCj4gc3Ry
YW5nZS4NCj4gDQoNClNvIG1heWJlIHdlIHNob3VsZG4ndCBoYXZlIGFueSBkZXBlbmRlbmNpZXMg
YnkgZGVzaWduLCBhbmQgbGV0IHRoZQ0KZHJpdmVycyBkZWNpZGUgaG93IG11Y2ggdGFpbHJvb20g
dGhleSB3YW50IHRvIHByZXNlcnZlLCBhbmQgcmVtb3ZlIHRoZQ0KaGFyZGNvZGVkIHNpemVvZihz
a2Jfc2hpbmZvKS4uIA0KDQptYXliZSBwZXIgcnhxID8gb24gbWVtb3J5IG1vZGVsIHJlZ2lzdHJh
dGlvbiA/DQoNCg0KPiANCj4gPiA+ICAvKioNCj4gPiA+ICAgKiBET0M6IFhEUCBSWC1xdWV1ZSBp
bmZvcm1hdGlvbg0KPiA+ID4gICAqDQo+ID4gPiBAQCAtNzAsOCArNzIsMjMgQEAgc3RydWN0IHhk
cF9idWZmIHsNCj4gPiA+ICAJdm9pZCAqZGF0YV9oYXJkX3N0YXJ0Ow0KPiA+ID4gIAl1bnNpZ25l
ZCBsb25nIGhhbmRsZTsNCj4gPiA+ICAJc3RydWN0IHhkcF9yeHFfaW5mbyAqcnhxOw0KPiA+ID4g
Kwl1MzIgZnJhbWVfc3o7IC8qIGZyYW1lIHNpemUgdG8gZGVkdWN0IGRhdGFfaGFyZF9lbmQvcmVz
ZXJ2ZWQNCj4gPiA+IHRhaWxyb29tKi8gIA0KPiA+IA0KPiA+IHdoeSB1MzIgPyB1MTYgc2hvdWxk
IGJlIG1vcmUgdGhhbiBlbm91Z2guLiANCj4gDQo+IE5vcGUuICBJdCBuZWVkIHRvIGJlIGFibGUg
dG8gc3RvcmUgUEFHRV9TSVpFID09IDY1NTM2Lg0KPiANCj4gJCBlY2hvICQoKDE8PDEyKSkNCj4g
NDA5Ng0KPiAkIGVjaG8gJCgoMTw8MTYpKQ0KPiA2NTUzNg0KPiANCj4gJCBwcmludGYgIjB4JVhc
biIgNjU1MzYNCj4gMHgxMDAwMA0KPiANCg0KOigNCg0KPiANCj4gPiA+ICB9Ow0KPiA+ID4gIA0K
PiA+ID4gKy8qIFJlc2VydmUgbWVtb3J5IGFyZWEgYXQgZW5kLW9mIGRhdGEgYXJlYS4NCj4gPiA+
ICsgKg0KPiA+ID4gKyAqIFRoaXMgbWFjcm8gcmVzZXJ2ZXMgdGFpbHJvb20gaW4gdGhlIFhEUCBi
dWZmZXIgYnkgbGltaXRpbmcNCj4gPiA+IHRoZQ0KPiA+ID4gKyAqIFhEUC9CUEYgZGF0YSBhY2Nl
c3MgdG8gZGF0YV9oYXJkX2VuZC4gIE5vdGljZSBzYW1lIGFyZWEgKGFuZA0KPiA+ID4gc2l6ZSkN
Cj4gPiA+ICsgKiBpcyB1c2VkIGZvciBYRFBfUEFTUywgd2hlbiBjb25zdHJ1Y3RpbmcgdGhlIFNL
QiB2aWENCj4gPiA+IGJ1aWxkX3NrYigpLg0KPiA+ID4gKyAqLw0KPiA+ID4gKyNkZWZpbmUgeGRw
X2RhdGFfaGFyZF9lbmQoeGRwKQkJCQlcDQo+ID4gPiArCSgoeGRwKS0+ZGF0YV9oYXJkX3N0YXJ0
ICsgKHhkcCktPmZyYW1lX3N6IC0JXA0KPiA+ID4gKwkgU0tCX0RBVEFfQUxJR04oc2l6ZW9mKHN0
cnVjdCBza2Jfc2hhcmVkX2luZm8pKSkNCj4gPiA+ICsgIA0KPiA+IA0KPiA+IHRoaXMgbWFjcm8g
aXMgbm90IHNhZmUgd2hlbiB1bmFyeSBvcGVyYXRvcnMgYXJlIGJlaW5nIHVzZWQNCj4gDQo+IFRo
ZSBwYXJlbnRoZXNlcyByb3VuZCAoeGRwKSBkb2VzIG1ha2UgeGRwX2RhdGFfaGFyZF9lbmQoJnhk
cCkgd29yaw0KPiBjb3JyZWN0bHkuIFdoYXQgb3RoZXIgY2FzZXMgYXJlIHlvdSB3b3JyaWVkIGFi
b3V0Pw0KPiANCj4gDQoNCmNvbnNpZGVyOiANCnhkcF9kYXRhX2hhcmRfZW5kKHhkcF9wdHIrKykN
Cg==
