Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7337E29E113
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 02:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728740AbgJ2BxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 21:53:08 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:39447 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728387AbgJ1V5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:57:41 -0400
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 09S4fO121001014, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb03.realtek.com.tw[172.21.6.96])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 09S4fO121001014
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 28 Oct 2020 12:41:24 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Wed, 28 Oct 2020 12:41:24 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa]) by
 RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa%3]) with mapi id
 15.01.2044.006; Wed, 28 Oct 2020 12:41:24 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "baijiaju1990@gmail.com" <baijiaju1990@gmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "straube.linux@gmail.com" <straube.linux@gmail.com>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtl8192ce: avoid accessing the data mapped to streaming DMA
Thread-Topic: [PATCH] rtl8192ce: avoid accessing the data mapped to streaming
 DMA
Thread-Index: AQHWpcVKJ30NZbw/gky3yTJLE0YXfKmr90+A
Date:   Wed, 28 Oct 2020 04:41:24 +0000
Message-ID: <1603860037.8609.4.camel@realtek.com>
References: <20201019030931.4796-1-baijiaju1990@gmail.com>
In-Reply-To: <20201019030931.4796-1-baijiaju1990@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.213]
Content-Type: text/plain; charset="utf-8"
Content-ID: <1774CA54F780E34FA8A502B26F15290C@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTEwLTE5IGF0IDExOjA5ICswODAwLCBKaWEtSnUgQmFpIHdyb3RlOg0KPiBJ
biBydGw5MmNlX3R4X2ZpbGxfY21kZGVzYygpLCBza2ItPmRhdGEgaXMgbWFwcGVkIHRvIHN0cmVh
bWluZyBETUEgb24NCj4gbGluZSA1MzA6DQo+IMKgIGRtYV9hZGRyX3QgbWFwcGluZyA9IGRtYV9t
YXBfc2luZ2xlKC4uLiwgc2tiLT5kYXRhLCAuLi4pOw0KPiANCj4gT24gbGluZSA1MzMsIHNrYi0+
ZGF0YSBpcyBhc3NpZ25lZCB0byBoZHIgYWZ0ZXIgY2FzdDoNCj4gwqAgc3RydWN0IGllZWU4MDIx
MV9oZHIgKmhkciA9IChzdHJ1Y3QgaWVlZTgwMjExX2hkciAqKShza2ItPmRhdGEpOw0KPiANCj4g
VGhlbiBoZHItPmZyYW1lX2NvbnRyb2wgaXMgYWNjZXNzZWQgb24gbGluZSA1MzQ6DQo+IMKgIF9f
bGUxNiBmYyA9IGhkci0+ZnJhbWVfY29udHJvbDsNCj4gDQo+IFRoaXMgRE1BIGFjY2VzcyBtYXkg
Y2F1c2UgZGF0YSBpbmNvbnNpc3RlbmN5IGJldHdlZW4gQ1BVIGFuZCBoYXJkd3JlLg0KPiANCj4g
VG8gZml4IHRoaXMgYnVnLCBoZHItPmZyYW1lX2NvbnRyb2wgaXMgYWNjZXNzZWQgYmVmb3JlIHRo
ZSBETUEgbWFwcGluZy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEppYS1KdSBCYWkgPGJhaWppYWp1
MTk5MEBnbWFpbC5jb20+DQo+IC0tLQ0KPiDCoGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsv
cnRsd2lmaS9ydGw4MTkyY2UvdHJ4LmMgfCA2ICsrKy0tLQ0KPiDCoDEgZmlsZSBjaGFuZ2VkLCAz
IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDgxOTJjZS90cnguYw0KPiBiL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9ydGw4MTkyY2UvdHJ4LmMNCj4gaW5kZXgg
YzA2MzUzMDlhOTJkLi40MTY1MTc1Y2Y1YzAgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9ydGw4MTkyY2UvdHJ4LmMNCj4gKysrIGIvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDgxOTJjZS90cnguYw0KPiBAQCAtNTI3LDEy
ICs1MjcsMTIgQEAgdm9pZCBydGw5MmNlX3R4X2ZpbGxfY21kZGVzYyhzdHJ1Y3QgaWVlZTgwMjEx
X2h3ICpodywNCj4gwqAJdTggZndfcXVldWUgPSBRU0xUX0JFQUNPTjsNCj4gwqAJX19sZTMyICpw
ZGVzYyA9IChfX2xlMzIgKilwZGVzYzg7DQo+IMKgDQo+IC0JZG1hX2FkZHJfdCBtYXBwaW5nID0g
ZG1hX21hcF9zaW5nbGUoJnJ0bHBjaS0+cGRldi0+ZGV2LCBza2ItPmRhdGEsDQo+IC0JCQkJCcKg
wqDCoMKgc2tiLT5sZW4sIERNQV9UT19ERVZJQ0UpOw0KPiAtDQo+IMKgCXN0cnVjdCBpZWVlODAy
MTFfaGRyICpoZHIgPSAoc3RydWN0IGllZWU4MDIxMV9oZHIgKikoc2tiLT5kYXRhKTsNCj4gwqAJ
X19sZTE2IGZjID0gaGRyLT5mcmFtZV9jb250cm9sOw0KPiDCoA0KPiArCWRtYV9hZGRyX3QgbWFw
cGluZyA9IGRtYV9tYXBfc2luZ2xlKCZydGxwY2ktPnBkZXYtPmRldiwgc2tiLT5kYXRhLA0KPiAr
CQkJCQnCoMKgwqDCoHNrYi0+bGVuLCBETUFfVE9fREVWSUNFKTsNCj4gKw0KPiDCoAlpZiAoZG1h
X21hcHBpbmdfZXJyb3IoJnJ0bHBjaS0+cGRldi0+ZGV2LCBtYXBwaW5nKSkgew0KPiDCoAkJcnRs
X2RiZyhydGxwcml2LCBDT01QX1NFTkQsIERCR19UUkFDRSwNCj4gwqAJCQkiRE1BIG1hcHBpbmcg
ZXJyb3JcbiIpOw0KDQpUaGUgY2hhbmdlcyBvZiB0aGUgc2VyaWVzIHBhdGNoZXMgYXJlIGdvb2Qg
dG8gbWUuwqANCkJ1dCwgcGxlYXNlIHVzZSAncnRsd2lmaTogJyBhcyBzdWJqZWN0IHByZWZpeCwg
bGlrZSAicnRsd2lmaTrCoHJ0bDgxOTJjZTogLi4uIiwNCmFuZCBzZW5kIHRoZW0gYXMgYSBwYXRj
aHNldCBJIHRoaW5rIHRoaXMgd291bGQgYmUgYmV0dGVyIHRvIG1haW50YWluZXIuDQoNClRoYW5r
IHlvdQ0KDQotLS0NClBLDQo=
