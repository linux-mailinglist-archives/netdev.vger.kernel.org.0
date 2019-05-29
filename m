Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7422D76F
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 10:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfE2IMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 04:12:37 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:32970 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725987AbfE2IMh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 04:12:37 -0400
Received: from LHREML712-CAH.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id B955EF4EA408DABF67B7;
        Wed, 29 May 2019 09:12:35 +0100 (IST)
Received: from lhreml703-chm.china.huawei.com (10.201.108.52) by
 LHREML712-CAH.china.huawei.com (10.201.108.35) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 29 May 2019 09:12:35 +0100
Received: from lhreml702-chm.china.huawei.com (10.201.108.51) by
 lhreml703-chm.china.huawei.com (10.201.108.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Wed, 29 May 2019 09:12:35 +0100
Received: from lhreml702-chm.china.huawei.com ([10.201.68.197]) by
 lhreml702-chm.china.huawei.com ([10.201.68.197]) with mapi id 15.01.1713.004;
 Wed, 29 May 2019 09:12:35 +0100
From:   Salil Mehta <salil.mehta@huawei.com>
To:     linyunsheng <linyunsheng@huawei.com>,
        Stephen Hemminger <stephen@networkplumber.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>
Subject: RE: [PATCH net-next] net: link_watch: prevent starvation when
 processing linkwatch wq
Thread-Topic: [PATCH net-next] net: link_watch: prevent starvation when
 processing linkwatch wq
Thread-Index: AQHVFC5nEodOM+qRr0+2+lmmmK658aZ/ADQAgACpOACAAhO6YA==
Date:   Wed, 29 May 2019 08:12:35 +0000
Message-ID: <cddd414bbf454cbaa8321a92f0d1b9b2@huawei.com>
References: <1558921674-158349-1-git-send-email-linyunsheng@huawei.com>
 <20190527075838.5a65abf9@hermes.lan>
 <a0fe690b-2bfa-7d1a-40c5-5fb95cf57d0b@huawei.com>
In-Reply-To: <a0fe690b-2bfa-7d1a-40c5-5fb95cf57d0b@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.226.43]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBuZXRkZXYtb3duZXJAdmdlci5rZXJuZWwub3JnIFttYWlsdG86bmV0ZGV2LW93bmVy
QHZnZXIua2VybmVsLm9yZ10gT24gQmVoYWxmIE9mIFl1bnNoZW5nIExpbg0KPiBTZW50OiBUdWVz
ZGF5LCBNYXkgMjgsIDIwMTkgMjowNCBBTQ0KPiANCj4gT24gMjAxOS81LzI3IDIyOjU4LCBTdGVw
aGVuIEhlbW1pbmdlciB3cm90ZToNCj4gPiBPbiBNb24sIDI3IE1heSAyMDE5IDA5OjQ3OjU0ICsw
ODAwDQo+ID4gWXVuc2hlbmcgTGluIDxsaW55dW5zaGVuZ0BodWF3ZWkuY29tPiB3cm90ZToNCj4g
Pg0KPiA+PiBXaGVuIHVzZXIgaGFzIGNvbmZpZ3VyZWQgYSBsYXJnZSBudW1iZXIgb2YgdmlydHVh
bCBuZXRkZXYsIHN1Y2gNCj4gPj4gYXMgNEsgdmxhbnMsIHRoZSBjYXJyaWVyIG9uL29mZiBvcGVy
YXRpb24gb2YgdGhlIHJlYWwgbmV0ZGV2DQo+ID4+IHdpbGwgYWxzbyBjYXVzZSBpdCdzIHZpcnR1
YWwgbmV0ZGV2J3MgbGluayBzdGF0ZSB0byBiZSBwcm9jZXNzZWQNCj4gPj4gaW4gbGlua3dhdGNo
LiBDdXJyZW50bHksIHRoZSBwcm9jZXNzaW5nIGlzIGRvbmUgaW4gYSB3b3JrIHF1ZXVlLA0KPiA+
PiB3aGljaCBtYXkgY2F1c2Ugd29ya2VyIHN0YXJ2YXRpb24gcHJvYmxlbSBmb3Igb3RoZXIgd29y
ayBxdWV1ZS4NCg0KDQpJIHRoaW5rIHdlIGhhZCBhbHJlYWR5IGRpc2N1c3NlZCBhYm91dCB0aGlz
IGludGVybmFsbHkgYW5kIHVzaW5nIHNlcGFyYXRlDQp3b3JrcXVldWUgd2l0aCBXUV9VTkJPVU5E
IHNob3VsZCBzb2x2ZSB0aGlzIHByb2JsZW0uIEhOUzMgZHJpdmVyIHdhcyBzaGFyaW5nDQp3b3Jr
cXVldWUgd2l0aCB0aGUgc3lzdGVtIHdvcmtxdWV1ZS4gDQoNCg0KPiA+PiBUaGlzIHBhdGNoIHJl
bGVhc2VzIHRoZSBjcHUgd2hlbiBsaW5rIHdhdGNoIHdvcmtlciBoYXMgcHJvY2Vzc2VkDQo+ID4+
IGEgZml4ZWQgbnVtYmVyIG9mIG5ldGRldicgbGluayB3YXRjaCBldmVudCwgYW5kIHNjaGVkdWxl
IHRoZQ0KPiA+PiB3b3JrIHF1ZXVlIGFnYWluIHdoZW4gdGhlcmUgaXMgc3RpbGwgbGluayB3YXRj
aCBldmVudCByZW1haW5pbmcuDQoNCg0KV2UgbmVlZCBwcm9wZXIgZXhhbXBsZXMvdXNlLWNhc2Vz
IGJlY2F1c2Ugb2Ygd2hpY2ggd2UgcmVxdWlyZSBhYm92ZQ0Ka2luZCBvZiBjby1vcGVyYXRpdmUg
c2NoZWR1bGluZy4gVG91Y2hpbmcgdGhlIGNvbW1vbiBzaGFyZWQgcXVldWUgbG9naWMNCndoaWNo
IHNvbGlkIGFyZ3VtZW50IG1pZ2h0IGludml0ZSBmb3IgbW9yZSBwcm9ibGVtIHRvIG90aGVyIG1v
ZHVsZXMuDQoNCg0KPiA+PiBTaWduZWQtb2ZmLWJ5OiBZdW5zaGVuZyBMaW4gPGxpbnl1bnNoZW5n
QGh1YXdlaS5jb20+DQo+ID4NCj4gPiBXaHkgbm90IHB1dCBsaW5rIHdhdGNoIGluIGl0cyBvd24g
d29ya3F1ZXVlIHNvIGl0IGlzIHNjaGVkdWxlZA0KPiA+IHNlcGFyYXRlbHkgZnJvbSB0aGUgc3lz
dGVtIHdvcmtxdWV1ZT8NCj4gDQo+IEZyb20gdGVzdGluZyBhbmQgZGVidWdpbmcsIHRoZSB3b3Jr
cXVldWUgcnVucyBvbiB0aGUgY3B1IHdoZXJlIHRoZQ0KPiB3b3JrcXVldWUgaXMgc2NoZWR1bGUg
d2hlbiB1c2luZyBub3JtYWwgd29ya3F1ZXVlLCBldmVuIHVzaW5nIGl0cw0KPiBvd24gd29ya3F1
ZXVlIGluc3RlYWQgb2Ygc3lzdGVtIHdvcmtxdWV1ZS4gU28gaWYgdGhlIGNwdSBpcyBidXN5DQo+
IHByb2Nlc3NpbmcgdGhlIGxpbmt3YXRjaCBldmVudCwgaXQgaXMgbm90IGFibGUgdG8gcHJvY2Vz
cyBvdGhlcg0KPiB3b3JrcXVldWUnIHdvcmsgd2hlbiB0aGUgd29ya3F1ZXVlIGlzIHNjaGVkdWxl
ZCBvbiB0aGUgc2FtZSBjcHUuDQo+IA0KPiBVc2luZyB1bmJvdW5kIHdvcmtxdWV1ZSBtYXkgc29s
dmUgdGhlIGNwdSBzdGFydmF0aW9uIHByb2JsZW0uDQoNClsuLi5dDQoNCj4gQnV0IHRoZSBfX2xp
bmt3YXRjaF9ydW5fcXVldWUgaXMgY2FsbGVkIHdpdGggcnRubF9sb2NrLCBzbyBpZiBpdA0KPiB0
YWtlcyBhIGxvdCB0aW1lIHRvIHByb2Nlc3MsIG90aGVyIG5lZWQgdG8gdGFrZSB0aGUgcnRubF9s
b2NrIG1heQ0KPiBub3QgYmUgYWJsZSB0byBtb3ZlIGZvcndhcmQuDQoNClBsZWFzZSBoZWxwIG1l
IGluIHVuZGVyc3RhbmRpbmcsIEFyZSB5b3UgdHJ5aW5nIHRvIHBpdGNoIHRoaXMgcGF0Y2gNCnRv
IHNvbHZlIG1vcmUgZ2VuZXJhbCBzeXN0ZW0gaXNzdWUgT1Igc3RpbGwgeW91ciBhcmd1bWVudC9j
b25jZXJuDQppcyByZWxhdGVkIHRvIHRoZSBITlMzIGRyaXZlciBwcm9ibGVtIG1lbnRpb25lZCBp
biB0aGlzIHBhdGNoPw0KDQpTYWxpbC4NCg0KDQoNCg0KDQoNCg0K
