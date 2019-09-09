Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6835FADD02
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 18:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387465AbfIIQYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 12:24:07 -0400
Received: from mail-eopbgr140072.outbound.protection.outlook.com ([40.107.14.72]:24383
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726410AbfIIQYH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 12:24:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H6LyivWQdJjwks7ike8F1qI7YFP6YdjJDtbtHMcgP6Ge992PZzvGAE9iLvonF8xtEtcNVd1KsG2iOUZMEt0oeV44Ksb/eiYPHseKICCd/GQvtdzzBNQY8TK8j9qTKsSOqs0km9Wvgtr6Ke0YA28DDNJgNTQOxpUM5NeQHaRM/P+g1vwY8kHzJxIu2Mupwg09FNtoYfRw2qwn8rxPbhqHFgxce+pc7EK/wcPqjJBaHFqmt6XJhCJmKG2NAXsxzRdq0hIVloHwOEA97r+dXQ8qz2U64+rZOTNulHn8VT5yTVyafh/c4rmUPpR5n3VsjaqyL12wD0s1ufJIyi34hZbopA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5su9NZ/NwaG1zqC2JvyJwqP3GvJE4UNs6s8PxplbFCg=;
 b=FSPxZp52xZb3z7N7sPjdfOEfR9UzkW5E1rqCxqZNCwWCfSlaKPc6jeGRFTFC7GLmHKF/InU6ZyO6KAlj+O30WZkeClTQwpV/jgYpqI73z7dlb41vlQqhwE8MdGNH9ZGe6wHv4U1Eq9TkbVevXyuNWm62JkKG5HP705UfAKkDIiMCrE+zrTfmfXsZiGJhSeRSywHFWQVvilH9SVPNCTG893pEeJiibN1Pbobf5VDBpjLhTqg3UZTzWqKjwF5MD+gM0IiYWIWz9Vp+vnefWG9wHNCcTfuQV7PWJ+3u1Ny4VZz+gZb4S5frx+MpL/hD+lSY8jvJWrTrq5yu8M3S7v8fXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5su9NZ/NwaG1zqC2JvyJwqP3GvJE4UNs6s8PxplbFCg=;
 b=EXscjluluixXhyulB5Rme3wGKfANcznFOGeCHHTFcILfYYlo/tz3t/W9/9abMBj0j6YiWxedGVG/im6OYgh4UvIzLM/vjpe2CUkvFO3iAcCavVnT8t3CbrjDnkTbIVqeyiGxdpCxLocluuXTLKqmQua+OFNV9JpAF0lV/KavnjA=
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com (20.177.49.153) by
 VI1PR04MB3183.eurprd04.prod.outlook.com (10.170.229.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Mon, 9 Sep 2019 16:24:01 +0000
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::484a:7cd1:5d31:db4d]) by VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::484a:7cd1:5d31:db4d%6]) with mapi id 15.20.2241.018; Mon, 9 Sep 2019
 16:24:01 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S . Miller" <davem@davemloft.net>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 1/5] enetc: Fix if_mode extraction
Thread-Topic: [PATCH net-next 1/5] enetc: Fix if_mode extraction
Thread-Index: AQHVZL2XLm4ULc70SkKGxUWVBUt4yKcfETWAgARtDSA=
Date:   Mon, 9 Sep 2019 16:24:01 +0000
Message-ID: <VI1PR04MB48803DB044AB6CF66CACB89E96B70@VI1PR04MB4880.eurprd04.prod.outlook.com>
References: <1567779344-30965-1-git-send-email-claudiu.manoil@nxp.com>
 <1567779344-30965-2-git-send-email-claudiu.manoil@nxp.com>
 <20190906195743.GD2339@lunn.ch>
In-Reply-To: <20190906195743.GD2339@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=claudiu.manoil@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 26c03c9c-9eff-4de0-8052-08d735421fd5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB3183;
x-ms-traffictypediagnostic: VI1PR04MB3183:|VI1PR04MB3183:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB3183152E02C014FAD0CA359896B70@VI1PR04MB3183.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(366004)(136003)(396003)(346002)(39860400002)(376002)(199004)(189003)(13464003)(9686003)(6116002)(11346002)(229853002)(478600001)(8676002)(6506007)(81166006)(81156014)(54906003)(256004)(66446008)(52536014)(66476007)(76116006)(55016002)(86362001)(71200400001)(66556008)(64756008)(74316002)(71190400001)(7736002)(7696005)(561944003)(44832011)(53936002)(186003)(446003)(305945005)(476003)(3846002)(66946007)(486006)(5660300002)(316002)(14454004)(4326008)(76176011)(25786009)(66066001)(99286004)(6916009)(33656002)(8936002)(2906002)(102836004)(26005)(6436002)(6246003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB3183;H:VI1PR04MB4880.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kc5s+pQANmzDtOyjP+JgvMBkSgN/fFnRftjdmSNHTA40WgH9WorIHrtyBmTdLBVq7Tmi4goYwP/CEltqB5pNxhmXjuoXJG37rSLNgd53o0GBiuptnEJq8DwhPaie/mOUdOIn82X6dyi+zYtULyXYlkEV8QWfL5Cm7GropD7M12dQbVYD7CCg/EXbag0xBogY59AcvRSGRYpKip2n6q9qZ3lCD7xQ6MKF/DQvK5uUV41HRaUGAsWSPt2WjaN8758+ZX/6BEpBuKD+60DS2nYMTVOmkkJZEGi2CkhEpTZu2WeIx3yYrF8hiL6Wg1Zp3+pIhpocIIgL9evXYQAJovFdWIxaishP5IvuirLKkTUrT1fpHhEN6gXifWf0xwS8z/fTPDgajhF8PQ3nItrsliBz8oNJR164oaENsg3Wn8+PS3I=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26c03c9c-9eff-4de0-8052-08d735421fd5
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2019 16:24:01.2894
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vMjbjtrnsoQ411jdymx0Yj4xKQK6rvHz6PPQWEu73Z0WYhy4GvwkHIXyT0Sn4wkVkNkfl+TsCk1B7jJuSOE1aQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3183
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+RnJvbTogQW5kcmV3IEx1bm4gPGFuZHJld0Bs
dW5uLmNoPg0KPlNlbnQ6IEZyaWRheSwgU2VwdGVtYmVyIDYsIDIwMTkgMTA6NTggUE0NCj5Ubzog
Q2xhdWRpdSBNYW5vaWwgPGNsYXVkaXUubWFub2lsQG54cC5jb20+DQo+Q2M6IERhdmlkIFMgLiBN
aWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBBbGV4YW5kcnUgTWFyZ2luZWFuDQo+PGFsZXhh
bmRydS5tYXJnaW5lYW5AbnhwLmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj5TdWJqZWN0
OiBSZTogW1BBVENIIG5ldC1uZXh0IDEvNV0gZW5ldGM6IEZpeCBpZl9tb2RlIGV4dHJhY3Rpb24N
Cj4NCj5PbiBGcmksIFNlcCAwNiwgMjAxOSBhdCAwNToxNTo0MFBNICswMzAwLCBDbGF1ZGl1IE1h
bm9pbCB3cm90ZToNCj4+IEZpeCBoYW5kbGluZyBvZiBlcnJvciByZXR1cm4gY29kZS4gQmVmb3Jl
IHRoaXMgZml4LA0KPj4gdGhlIGVycm9yIGNvZGUgd2FzIGhhbmRsZWQgYXMgdW5zaWduZWQgdHlw
ZS4NCj4+IEFsc28sIG9uIHRoaXMgcGF0aCBpZiBpZl9tb2RlIG5vdCBmb3VuZCB0aGVuIGp1c3Qg
aGFuZGxlDQo+PiBpdCBhcyBmaXhlZCBsaW5rIChpLmUgbWFjMm1hYyBjb25uZWN0aW9uKS4NCj4+
DQo+PiBTaWduZWQtb2ZmLWJ5OiBDbGF1ZGl1IE1hbm9pbCA8Y2xhdWRpdS5tYW5vaWxAbnhwLmNv
bT4NCj4+IC0tLQ0KPj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9lbmV0Yy9lbmV0
Y19wZi5jIHwgMTcgKysrKysrLS0tLS0tLS0tLS0NCj4+ICAxIGZpbGUgY2hhbmdlZCwgNiBpbnNl
cnRpb25zKCspLCAxMSBkZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2VuZXRjL2VuZXRjX3BmLmMNCj5iL2RyaXZlcnMvbmV0L2V0
aGVybmV0L2ZyZWVzY2FsZS9lbmV0Yy9lbmV0Y19wZi5jDQo+PiBpbmRleCA3ZDY1MTNmZjg1MDcu
LjNhNTU2NjQ2YTJmYiAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVz
Y2FsZS9lbmV0Yy9lbmV0Y19wZi5jDQo+PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVl
c2NhbGUvZW5ldGMvZW5ldGNfcGYuYw0KPj4gQEAgLTc1MSw2ICs3NTEsNyBAQCBzdGF0aWMgaW50
IGVuZXRjX29mX2dldF9waHkoc3RydWN0IGVuZXRjX25kZXZfcHJpdg0KPipwcml2KQ0KPj4gIAlz
dHJ1Y3QgZW5ldGNfcGYgKnBmID0gZW5ldGNfc2lfcHJpdihwcml2LT5zaSk7DQo+PiAgCXN0cnVj
dCBkZXZpY2Vfbm9kZSAqbnAgPSBwcml2LT5kZXYtPm9mX25vZGU7DQo+PiAgCXN0cnVjdCBkZXZp
Y2Vfbm9kZSAqbWRpb19ucDsNCj4+ICsJaW50IHBoeV9tb2RlOw0KPj4gIAlpbnQgZXJyOw0KPj4N
Cj4+ICAJaWYgKCFucCkgew0KPj4gQEAgLTc4NCwxNyArNzg1LDExIEBAIHN0YXRpYyBpbnQgZW5l
dGNfb2ZfZ2V0X3BoeShzdHJ1Y3QgZW5ldGNfbmRldl9wcml2DQo+KnByaXYpDQo+PiAgCQl9DQo+
PiAgCX0NCj4+DQo+PiAtCXByaXYtPmlmX21vZGUgPSBvZl9nZXRfcGh5X21vZGUobnApOw0KPj4g
LQlpZiAocHJpdi0+aWZfbW9kZSA8IDApIHsNCj4+IC0JCWRldl9lcnIocHJpdi0+ZGV2LCAibWlz
c2luZyBwaHkgdHlwZVxuIik7DQo+PiAtCQlvZl9ub2RlX3B1dChwcml2LT5waHlfbm9kZSk7DQo+
PiAtCQlpZiAob2ZfcGh5X2lzX2ZpeGVkX2xpbmsobnApKQ0KPj4gLQkJCW9mX3BoeV9kZXJlZ2lz
dGVyX2ZpeGVkX2xpbmsobnApOw0KPj4gLQkJZWxzZQ0KPj4gLQkJCWVuZXRjX21kaW9fcmVtb3Zl
KHBmKTsNCj4+IC0NCj4+IC0JCXJldHVybiAtRUlOVkFMOw0KPj4gLQl9DQo+DQo+SGkgQ2xhdWRp
dQ0KPg0KPkl0IGlzIG5vdCBjbGVhciB0byBtZSB3aHkgaXQgaXMgbm8gbG9uZ2VyIG5lY2Vzc2Fy
eSB0byBkZXJlZ2lzdGVyIHRoZQ0KPmZpeGVkIGxpbmssIG9yIHJlbW92ZSB0aGUgbWRpbyBidXM/
DQo+DQo+PiArCXBoeV9tb2RlID0gb2ZfZ2V0X3BoeV9tb2RlKG5wKTsNCj4+ICsJaWYgKHBoeV9t
b2RlIDwgMCkNCj4+ICsJCXByaXYtPmlmX21vZGUgPSBQSFlfSU5URVJGQUNFX01PREVfTkE7IC8q
IGZpeGVkIGxpbmsgKi8NCj4+ICsJZWxzZQ0KPj4gKwkJcHJpdi0+aWZfbW9kZSA9IHBoeV9tb2Rl
Ow0KPg0KDQpIaSBBbmRyZXcsDQoNClRoZSBNQUMyTUFDIGNvbm5lY3Rpb25zIGFyZSBkZWZpbmVk
IGFzIGZpeGVkLWxpbmsgdG9vLCBidXQgd2l0aG91dA0KcGh5LW1vZGUvcGh5LWNvbm5lY3Rpb24t
dHlwZSBwcm9wZXJ0aWVzLiAgV2UgZG9uJ3Qgd2FudCB0byBkZS1yZWdpc3Rlcg0KdGhlc2UgbGlu
a3MuICBJbml0aWFsIGNvZGUgd2FzIGJvZ3VzIGluIHRoaXMgcmVnYXJkLiAgU28gdGhpcyBNT0RF
X05BIGludGVyZmFjZQ0KbW9kZSBpcyByZXNlcnZlZCBmb3IgdGhlIGN1cnJlbnQgcmVwcmVzZW50
YXRpb24gb2YgZW5ldGMgZXRoZXJuZXQgcG9ydHMNCnRoYXQgYXJlIE1BQzJNQUMgY29ubmVjdGVk
IHdpdGggc3dpdGNoIHBvcnRzLiAgQWxzbyB0cnVlIHRoYXQgdGhlIGN1cnJlbnQNCnVwc3RyZWFt
IGRyaXZlciBkb2VzIG5vdCBoYXZlIHRoZSBNQUMyTUFDIGNvbm5lY3Rpb25zIGVuYWJsZWQuDQoN
CllvdXIgcXVlc3Rpb24gaG93ZXZlciBsZWFkcyB0byB0aGUgZm9sbG93aW5nIGRpc2N1c3Npb24g
8J+Yii4gIFRoZSBMUzEwMjggU29DDQpoYXMgaW50ZXJuYWwgTUFDMk1BQyBjb25uZWN0aW9ucyBi
ZXR3ZWVuIGVuZXRjIGV0aCBwb3J0cyBhbmQgc3dpdGNoIHBvcnRzLg0KSG93ZXZlciB0aGUgc3dp
dGNoIGRyaXZlciBmb3IgTFMxMDI4YSBpcyBub3QgYXZhaWxhYmxlIHVwc3RyZWFtIHlldCwgaXQg
bmVlZHMNCnRvIGJlIHJlLXdvcmtlZCBhcyBhIERTQSBkcml2ZXIgYXMgeW91IGtub3cgKGlmIHlv
dSByZW1lbWJlciB0aGUgZGlzY3Vzc2lvbnMNCndlIGhhZCBvbiBzd2l0Y2hkZXYgdnMgRFNBIGZv
ciB0aGUgRmVsaXggZHJpdmVyKS4gIE5vdyB0aGF0IHdlJ3JlIGF0IGl0LCBob3cNCndvdWxkIHlv
dSBsaWtlIHRvIHJlcHJlc2VudCB0aGVzZSBNQUMyTUFDIGNvbm5lY3Rpb25zPw0KDQpDdXJyZW50
IHByb3Bvc2FsIGlzOg0KCQkJZXRoZXJuZXRAMCwyIHsgLyogU29DIGludGVybmFsLCBjb25uZWN0
ZWQgdG8gc3dpdGNoIHBvcnQgNCAqLw0KCQkJCWNvbXBhdGlibGUgPSAiZnNsLGVuZXRjIjsNCgkJ
CQlyZWcgPSA8MHgwMDAyMDAgMCAwIDAgMD47DQoJCQkJZml4ZWQtbGluayB7DQoJCQkJCXNwZWVk
ID0gPDEwMDA+Ow0KCQkJCQlmdWxsLWR1cGxleDsNCgkJCQl9Ow0KCQkJfTsNCgkJCXN3aXRjaEAw
LDUgew0KCQkJCWNvbXBhdGlibGUgPSAibXNjYyxmZWxpeC1zd2l0Y2giOw0KCQkJCVsuLi5dDQoJ
CQkJcG9ydHMgew0KCQkJCQkjYWRkcmVzcy1jZWxscyA9IDwxPjsNCgkJCQkJI3NpemUtY2VsbHMg
PSA8MD47DQoNCgkJCQkJLyogZXh0ZXJuYWwgcG9ydHMgKi8NCgkJCQkJWy4uLl0NCgkJCQkJLyog
aW50ZXJuYWwgU29DIHBvcnRzICovDQoJCQkJCXBvcnRANCB7IC8qIGNvbm5lY3RlZCB0byBFTkVU
QyBwb3J0MiAqLw0KCQkJCQkJcmVnID0gPDQ+Ow0KCQkJCQkJZml4ZWQtbGluayB7DQoJCQkJCQkJ
c3BlZWQgPSA8MTAwMD47DQoJCQkJCQkJZnVsbC1kdXBsZXg7DQoJCQkJCQl9Ow0KCQkJCQl9Ow0K
CQkJCQlwb3J0QDUgeyAvKiBDUFUgcG9ydCwgY29ubmVjdGVkIHRvIEVORVRDIHBvcnQzICovDQoJ
CQkJCQlyZWcgPSA8NT47DQoJCQkJCQlldGhlcm5ldCA9IDwmZW5ldGNfcG9ydDM+Ow0KCQkJCQkJ
Zml4ZWQtbGluayB7DQoJCQkJCQkJc3BlZWQgPSA8MTAwMD47DQoJCQkJCQkJZnVsbC1kdXBsZXg7
DQoJCQkJCQl9Ow0KCQkJCQl9Ow0KCQkJCX07DQoJCQl9Ow0KCQkJZW5ldGNfcG9ydDM6IGV0aGVy
bmV0QDAsNiB7IC8qIFNvQyBpbnRlcm5hbCBjb25uZWN0ZWQgdG8gc3dpdGNoIHBvcnQgNSAqLw0K
CQkJCWNvbXBhdGlibGUgPSAiZnNsLGVuZXRjIjsNCgkJCQlyZWcgPSA8MHgwMDA2MDAgMCAwIDAg
MD47DQoJCQkJZml4ZWQtbGluayB7DQoJCQkJCXNwZWVkID0gPDEwMDA+Ow0KCQkJCQlmdWxsLWR1
cGxleDsNCgkJCQl9Ow0KCQkJfTsNCgkJfTsNCg0KVGhhbmtzLg0KDQpDbGF1ZGl1DQo=
