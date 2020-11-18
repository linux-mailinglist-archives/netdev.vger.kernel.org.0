Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E2B2B7433
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 03:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgKRCeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 21:34:05 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:49606 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgKRCeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 21:34:05 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 0AI2XngrE029377, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb05.realtek.com.tw[172.21.6.98])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 0AI2XngrE029377
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 18 Nov 2020 10:33:49 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXMB05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Wed, 18 Nov 2020 10:33:49 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Wed, 18 Nov 2020 10:33:49 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa]) by
 RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa%3]) with mapi id
 15.01.2044.006; Wed, 18 Nov 2020 10:33:49 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "baijiaju1990@gmail.com" <baijiaju1990@gmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] rtlwifi: rtl8188ee: avoid accessing the data mapped to streaming DMA
Thread-Topic: [PATCH v2 1/4] rtlwifi: rtl8188ee: avoid accessing the data
 mapped to streaming DMA
Thread-Index: AQHWvU2rgo4QMM0k1kuIsMYwqSTPC6nMpXgA
Date:   Wed, 18 Nov 2020 02:33:48 +0000
Message-ID: <1605666764.7490.1.camel@realtek.com>
References: <20201118015314.4979-1-baijiaju1990@gmail.com>
In-Reply-To: <20201118015314.4979-1-baijiaju1990@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.213]
Content-Type: text/plain; charset="utf-8"
Content-ID: <F376166834A78D4BB5D032F1C78958CD@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTExLTE4IGF0IDA5OjUzICswODAwLCBKaWEtSnUgQmFpIHdyb3RlOg0KPiBJ
biBydGw4OGVlX3R4X2ZpbGxfY21kZGVzYygpLCBza2ItPmRhdGEgaXMgbWFwcGVkIHRvIHN0cmVh
bWluZyBETUEgb24NCj4gbGluZSA2Nzc6DQo+IMKgIGRtYV9hZGRyX3QgbWFwcGluZyA9IGRtYV9t
YXBfc2luZ2xlKC4uLiwgc2tiLT5kYXRhLCAuLi4pOw0KPiANCj4gT24gbGluZSA2ODAsIHNrYi0+
ZGF0YSBpcyBhc3NpZ25lZCB0byBoZHIgYWZ0ZXIgY2FzdDoNCj4gwqAgc3RydWN0IGllZWU4MDIx
MV9oZHIgKmhkciA9IChzdHJ1Y3QgaWVlZTgwMjExX2hkciAqKShza2ItPmRhdGEpOw0KPiANCj4g
VGhlbiBoZHItPmZyYW1lX2NvbnRyb2wgaXMgYWNjZXNzZWQgb24gbGluZSA2ODE6DQo+IMKgIF9f
bGUxNiBmYyA9IGhkci0+ZnJhbWVfY29udHJvbDsNCj4gDQo+IFRoaXMgRE1BIGFjY2VzcyBtYXkg
Y2F1c2UgZGF0YSBpbmNvbnNpc3RlbmN5IGJldHdlZW4gQ1BVIGFuZCBoYXJkd3JlLg0KPiANCj4g
VG8gZml4IHRoaXMgYnVnLCBoZHItPmZyYW1lX2NvbnRyb2wgaXMgYWNjZXNzZWQgYmVmb3JlIHRo
ZSBETUEgbWFwcGluZy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEppYS1KdSBCYWkgPGJhaWppYWp1
MTk5MEBnbWFpbC5jb20+DQoNClRoaXMgcGF0Y2hzZXQgbG9va3MgZ29vZCB0byBtZS4NClRoYW5r
IHlvdS4NCg0KQWNrZWQtYnk6IFBpbmctS2UgU2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPg0KDQo+
IC0tLQ0KPiDCoGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9ydGw4MTg4ZWUv
dHJ4LmMgfCA2ICsrKy0tLQ0KPiDCoDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMg
ZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVh
bHRlay9ydGx3aWZpL3J0bDgxODhlZS90cnguYw0KPiBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3Jl
YWx0ZWsvcnRsd2lmaS9ydGw4MTg4ZWUvdHJ4LmMNCj4gaW5kZXggYjk3NzVlZWM0YzU0Li5jOTQ4
ZGFmYTBjODAgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRs
d2lmaS9ydGw4MTg4ZWUvdHJ4LmMNCj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRl
ay9ydGx3aWZpL3J0bDgxODhlZS90cnguYw0KPiBAQCAtNjc0LDEyICs2NzQsMTIgQEAgdm9pZCBy
dGw4OGVlX3R4X2ZpbGxfY21kZGVzYyhzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywNCj4gwqAJdTgg
ZndfcXVldWUgPSBRU0xUX0JFQUNPTjsNCj4gwqAJX19sZTMyICpwZGVzYyA9IChfX2xlMzIgKilw
ZGVzYzg7DQo+IMKgDQo+IC0JZG1hX2FkZHJfdCBtYXBwaW5nID0gZG1hX21hcF9zaW5nbGUoJnJ0
bHBjaS0+cGRldi0+ZGV2LCBza2ItPmRhdGEsDQo+IC0JCQkJCcKgwqDCoMKgc2tiLT5sZW4sIERN
QV9UT19ERVZJQ0UpOw0KPiAtDQo+IMKgCXN0cnVjdCBpZWVlODAyMTFfaGRyICpoZHIgPSAoc3Ry
dWN0IGllZWU4MDIxMV9oZHIgKikoc2tiLT5kYXRhKTsNCj4gwqAJX19sZTE2IGZjID0gaGRyLT5m
cmFtZV9jb250cm9sOw0KPiDCoA0KPiArCWRtYV9hZGRyX3QgbWFwcGluZyA9IGRtYV9tYXBfc2lu
Z2xlKCZydGxwY2ktPnBkZXYtPmRldiwgc2tiLT5kYXRhLA0KPiArCQkJCQnCoMKgwqDCoHNrYi0+
bGVuLCBETUFfVE9fREVWSUNFKTsNCj4gKw0KPiDCoAlpZiAoZG1hX21hcHBpbmdfZXJyb3IoJnJ0
bHBjaS0+cGRldi0+ZGV2LCBtYXBwaW5nKSkgew0KPiDCoAkJcnRsX2RiZyhydGxwcml2LCBDT01Q
X1NFTkQsIERCR19UUkFDRSwNCj4gwqAJCQkiRE1BIG1hcHBpbmcgZXJyb3JcbiIpOw0KDQoNCg0K
