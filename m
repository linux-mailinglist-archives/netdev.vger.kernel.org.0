Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE3F2EBBA2
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 02:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729119AbfKABSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 21:18:41 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:40749 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbfKABSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 21:18:40 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID xA11IGQS014947, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id xA11IGQS014947
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 1 Nov 2019 09:18:17 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCAS11.realtek.com.tw ([fe80::7c6d:ced5:c4ff:8297%15]) with mapi id
 14.03.0468.000; Fri, 1 Nov 2019 09:18:16 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Stefan Wahren <wahrenst@gmx.net>,
        Larry Finger <Larry.Finger@lwfinger.net>
CC:     "colin.king@canonical.com" <colin.king@canonical.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: rtlwifi: Memory leak in rtl92c_set_fw_rsvdpagepkt()
Thread-Topic: rtlwifi: Memory leak in rtl92c_set_fw_rsvdpagepkt()
Thread-Index: AQHVj/MKeJQWm1dmOEa/SZ8Z/gwmHKd1gfzA
Date:   Fri, 1 Nov 2019 01:18:15 +0000
Message-ID: <5B2DA6FDDF928F4E855344EE0A5C39D1D5C90CAD@RTITMBSVM04.realtek.com.tw>
References: <989debc9-8602-0ce3-71a7-2bf783b2c22b@gmx.net>
In-Reply-To: <989debc9-8602-0ce3-71a7-2bf783b2c22b@gmx.net>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.95]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU3RlZmFuIFdhaHJlbiBb
bWFpbHRvOndhaHJlbnN0QGdteC5uZXRdDQo+IFNlbnQ6IFRodXJzZGF5LCBPY3RvYmVyIDMxLCAy
MDE5IDk6NTcgUE0NCj4gVG86IFBrc2hpaDsgTGFycnkgRmluZ2VyDQo+IENjOiBjb2xpbi5raW5n
QGNhbm9uaWNhbC5jb207IGt2YWxvQGNvZGVhdXJvcmEub3JnOyBsaW51eC13aXJlbGVzc0B2Z2Vy
Lmtlcm5lbC5vcmc7DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogcnRsd2lm
aTogTWVtb3J5IGxlYWsgaW4gcnRsOTJjX3NldF9md19yc3ZkcGFnZXBrdCgpDQo+IA0KPiBIaSwN
Cj4gDQo+IGkgdGVzdGVkIHRoZSBFRElNQVggRVctNzYxMiBvbiBSYXNwYmVycnkgUGkgM0IrIHdp
dGggTGludXggNS40LXJjNQ0KPiAobXVsdGlfdjdfZGVmY29uZmlnICsgcnRsd2lmaSArIGttZW1s
ZWFrKSBhbmQgbm90aWNlZCBhIHNpbmdsZSBtZW1vcnkNCj4gbGVhayBkdXJpbmcgcHJvYmU6DQo+
IA0KPiB1bnJlZmVyZW5jZWQgb2JqZWN0IDB4ZWMxM2VlNDAgKHNpemUgMTc2KToNCj4gwqAgY29t
bSAia3dvcmtlci91ODoxIiwgcGlkIDM2LCBqaWZmaWVzIDQyOTQ5MzkzMjEgKGFnZSA1NTgwLjc5
MHMpDQo+IMKgIGhleCBkdW1wIChmaXJzdCAzMiBieXRlcyk6DQo+IMKgwqDCoCAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMMKgIC4uLi4uLi4uLi4uLi4uLi4N
Cj4gwqDCoMKgIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
wqAgLi4uLi4uLi4uLi4uLi4uLg0KPiDCoCBiYWNrdHJhY2U6DQo+IMKgwqDCoCBbPGZjMWJiYjNl
Pl0gX19uZXRkZXZfYWxsb2Nfc2tiKzB4OWMvMHgxNjQNCj4gwqDCoMKgIFs8ODYzZGZhNmU+XSBy
dGw5MmNfc2V0X2Z3X3JzdmRwYWdlcGt0KzB4MjU0LzB4MzQwIFtydGw4MTkyY19jb21tb25dDQo+
IMKgwqDCoCBbPDk1NzJiZTBkPl0gcnRsOTJjdV9zZXRfaHdfcmVnKzB4ZjQ4LzB4ZmE0IFtydGw4
MTkyY3VdDQo+IMKgwqDCoCBbPDExNmRmNGQ4Pl0gcnRsX29wX2Jzc19pbmZvX2NoYW5nZWQrMHgy
MzQvMHg5NmMgW3J0bHdpZmldDQo+IMKgwqDCoCBbPDg5MzM1NzVmPl0gaWVlZTgwMjExX2Jzc19p
bmZvX2NoYW5nZV9ub3RpZnkrMHhiOC8weDI2NCBbbWFjODAyMTFdDQo+IMKgwqDCoCBbPGQ0MDYx
ZTg2Pl0gaWVlZTgwMjExX2Fzc29jX3N1Y2Nlc3MrMHg5MzQvMHgxNzk4IFttYWM4MDIxMV0NCj4g
wqDCoMKgIFs8ZTU1YWRiNTY+XSBpZWVlODAyMTFfcnhfbWdtdF9hc3NvY19yZXNwKzB4MTc0LzB4
MzE0IFttYWM4MDIxMV0NCj4gwqDCoMKgIFs8NTk3NDYyOWU+XSBpZWVlODAyMTFfc3RhX3J4X3F1
ZXVlZF9tZ210KzB4M2Y0LzB4N2YwIFttYWM4MDIxMV0NCj4gwqDCoMKgIFs8ZDkxMDkxYzY+XSBp
ZWVlODAyMTFfaWZhY2Vfd29yaysweDIwOC8weDMxOCBbbWFjODAyMTFdDQo+IMKgwqDCoCBbPGFj
NWZjYWU0Pl0gcHJvY2Vzc19vbmVfd29yaysweDIyYy8weDU2NA0KPiDCoMKgwqAgWzxmNWU2ZDNi
Nj5dIHdvcmtlcl90aHJlYWQrMHg0NC8weDVkOA0KPiDCoMKgwqAgWzw4MmM3YjA3Mz5dIGt0aHJl
YWQrMHgxNTAvMHgxNTQNCj4gwqDCoMKgIFs8YjQzZTFiN2Q+XSByZXRfZnJvbV9mb3JrKzB4MTQv
MHgyYw0KPiDCoMKgwqAgWzw3OTRkZmYzMD5dIDB4MA0KPiANCj4gSXQgbG9va3MgbGlrZSB0aGUg
YWxsb2NhdGVkIHNrZCBpcyBuZXZlciBmcmVlZC4NCj4gDQo+IFdvdWxkIGJlIG5pY2UgdG8gZ2V0
IHRoaXMgZml4ZWQuDQo+IA0KDQpIaSwNCg0KVGhpcyBpcyBkdWUgdG8gODE5MmN1IGRvZXNuJ3Qg
aW1wbGVtZW50IHVzYl9jbWRfc2VuZF9wYWNrZXQoKS4gQ291bGQgeW91IGhlbHANCmZvbGxvd2lu
ZyBwYXRjaD8NCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRs
d2lmaS9ydGw4MTkyY3UvaHcuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lm
aS9ydGw4MTkyY3UvaHcuYw0KaW5kZXggNTZjYzNiYzMwODYwLi5mMDcwZjI1YmI3MzUgMTAwNjQ0
DQotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODE5MmN1L2h3
LmMNCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9ydGw4MTkyY3Uv
aHcuYw0KQEAgLTE1NDAsNiArMTU0MCw4IEBAIHN0YXRpYyBib29sIHVzYl9jbWRfc2VuZF9wYWNr
ZXQoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBza19idWZmICpza2IpDQogICAgKiBU
aGlzIGlzIG1heWJlIG5lY2Vzc2FyeToNCiAgICAqIHJ0bHByaXYtPmNmZy0+b3BzLT5maWxsX3R4
X2NtZGRlc2MoaHcsIGJ1ZmZlciwgMSwgMSwgc2tiKTsNCiAgICAqLw0KKyAgICAgICBkZXZfa2Zy
ZWVfc2tiKHNrYik7DQorDQogICAgICAgIHJldHVybiB0cnVlOw0KIH0NCg0KVGhpcyBwYXRjaCBq
dXN0IGZyZWVzIHRoZSBza2IgdG8gcmVzb2x2ZSBtZW1sZWFrIHByb2JsZW0uIFNpbmNlIDgxOTJj
dSBkb2Vzbid0DQp0dXJuIG9uIGZ3Y3RybF9scHMgdGhhdCBuZWVkcyB0byBkb3dubG9hZCBjb21t
YW5kIHBhY2tldCB0byBmaXJtd2FyZSwgYXBwbHkNCnRoaXMgcGF0Y2ggaXNuJ3Qgd29yc2UgdGhh
biBiZWZvcmUuDQoNCi0tLQ0KUEsNCg0K
