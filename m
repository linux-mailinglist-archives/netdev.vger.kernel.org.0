Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFF135D9FF
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 10:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbhDMI02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 04:26:28 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:2839 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbhDMI00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 04:26:26 -0400
Received: from fraeml710-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FKJQw67r3z688K3;
        Tue, 13 Apr 2021 16:18:48 +0800 (CST)
Received: from lhreml707-chm.china.huawei.com (10.201.108.56) by
 fraeml710-chm.china.huawei.com (10.206.15.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Tue, 13 Apr 2021 10:26:01 +0200
Received: from lhreml703-chm.china.huawei.com (10.201.108.52) by
 lhreml707-chm.china.huawei.com (10.201.108.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Tue, 13 Apr 2021 09:25:58 +0100
Received: from lhreml703-chm.china.huawei.com ([10.201.68.198]) by
 lhreml703-chm.china.huawei.com ([10.201.68.198]) with mapi id 15.01.2106.013;
 Tue, 13 Apr 2021 09:25:58 +0100
From:   Salil Mehta <salil.mehta@huawei.com>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>,
        "Tieman, Henry W" <henry.w.tieman@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        Linuxarm <linuxarm@huawei.com>
Subject: RE: [PATCH net] ice: Re-organizes reqstd/avail {R,T}XQ check/code for
 efficiency+readability
Thread-Topic: [PATCH net] ice: Re-organizes reqstd/avail {R,T}XQ check/code
 for efficiency+readability
Thread-Index: AQHXLnSYr3LSh1DDV0C/ZapTpipD6KqxbBIAgACyFoA=
Date:   Tue, 13 Apr 2021 08:25:58 +0000
Message-ID: <8fd160b556fc4d45bff2d607918aad33@huawei.com>
References: <20210411014530.25060-1-salil.mehta@huawei.com>
 <03655fb6faa595a20a1143fb3b01561042cd317f.camel@intel.com>
In-Reply-To: <03655fb6faa595a20a1143fb3b01561042cd317f.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.73.132]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW50aG9ueSwNClRoYW5rcyBmb3IgcmV2aWV3aW5nIQ0KDQo+IEZyb206IE5ndXllbiwgQW50
aG9ueSBMIFttYWlsdG86YW50aG9ueS5sLm5ndXllbkBpbnRlbC5jb21dDQo+IFNlbnQ6IE1vbmRh
eSwgQXByaWwgMTIsIDIwMjEgMTE6NDEgUE0NCj4gVG86IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1
YmFAa2VybmVsLm9yZzsgU2FsaWwgTWVodGEgPHNhbGlsLm1laHRhQGh1YXdlaS5jb20+DQo+IENj
OiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBC
cmFuZGVidXJnLCBKZXNzZQ0KPiA8amVzc2UuYnJhbmRlYnVyZ0BpbnRlbC5jb20+OyBsaW51eGFy
bUBvcGVuZXVsZXIub3JnOyBUaWVtYW4sIEhlbnJ5IFcNCj4gPGhlbnJ5LncudGllbWFuQGludGVs
LmNvbT47IExpbnV4YXJtIDxsaW51eGFybUBodWF3ZWkuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BB
VENIIG5ldF0gaWNlOiBSZS1vcmdhbml6ZXMgcmVxc3RkL2F2YWlsIHtSLFR9WFEgY2hlY2svY29k
ZSBmb3INCj4gZWZmaWNpZW5jeStyZWFkYWJpbGl0eQ0KPiANCj4gT24gU3VuLCAyMDIxLTA0LTEx
IGF0IDAyOjQ1ICswMTAwLCBTYWxpbCBNZWh0YSB3cm90ZToNCj4gPiBJZiB1c2VyIGhhcyBleHBs
aWNpdGx5IHJlcXVlc3RlZCB0aGUgbnVtYmVyIG9mIHtSLFR9WFFzLCB0aGVuIGl0IGlzDQo+ID4g
dW5uZWNlc3NhcnkNCj4gPiB0byBnZXQgdGhlIGNvdW50IG9mIGFscmVhZHkgYXZhaWxhYmxlIHtS
LFR9WFFzIGZyb20gdGhlIFBGDQo+ID4gYXZhaWxfe3IsdH14cXMNCj4gPiBiaXRtYXAuIFRoaXMg
dmFsdWUgd2lsbCBnZXQgb3ZlcnJpZGVuIGJ5IHVzZXIgc3BlY2lmaWVkIHZhbHVlIGluIGFueQ0K
PiANCj4gcy9vdmVycmlkZW4vb3ZlcnJpZGRlbg0KDQpPay4NCg0KPiANCj4gPiBjYXNlLg0KPiA+
DQo+ID4gVGhpcyBwYXRjaCBkb2VzIG1pbm9yIHJlLW9yZ2FuaXphdGlvbiBvZiB0aGUgY29kZSBm
b3IgaW1wcm92aW5nIHRoZQ0KPiA+IGZsb3cgYW5kDQo+ID4gcmVhZGFiaWx0aXkuIFRoaXMgc2Nv
cGUgb2YgaW1wcm92ZW1lbnQgd2FzIGZvdW5kIGR1cmluZyB0aGUgcmV2aWV3IG9mDQo+ID4gdGhl
IElDRQ0KPiA+IGRyaXZlciBjb2RlLg0KPiANCj4gVGhlIGNoYW5nZXMgdGhlbXNlbHZlcyBsb29r
IG9rLCBidXQgdGhlcmUgYXJlIHNvbWUgY2hlY2twYXRjaCBpc3N1ZXMuDQo+IEFsc28sIGNvdWxk
IHlvdSBpbmNsdWRlIGludGVsLXdpcmVkLWxhbkBsaXN0cy5vc3Vvc2wub3JnDQoNClN1cmUuIHdp
bGwgZml4IHRoZW0uDQoNCj4gDQo+ID4gRllJLCBJIGNvdWxkIG5vdCB0ZXN0IHRoaXMgY2hhbmdl
IGR1ZSB0byB1bmF2YWlsYWJpbGl0eSBvZiB0aGUNCj4gPiBoYXJkd2FyZS4gSXQNCj4gPiB3b3Vs
ZCBoZWxwZnVsIGlmIHNvbWVib2R5IGNhbiB0ZXN0IHRoaXMgYW5kIHByb3ZpZGUgVGVzdGVkLWJ5
IFRhZy4NCj4gPiBNYW55IHRoYW5rcyENCj4gPg0KPiA+IEZpeGVzOiAxMWI3NTUxZTA5NmQgKCJp
Y2U6IEltcGxlbWVudCBldGh0b29sIG9wcyBmb3IgY2hhbm5lbHMiKQ0KPiANCj4gVGhpcyBjb21t
aXQgaWQgZG9lc24ndCBleGlzdC4NCg0KV2lsbCBmaXguIFNvcnJ5IGFib3V0IHRoaXMuDQoNCj4g
DQo+ID4gU2lnbmVkLW9mZi1ieTogU2FsaWwgTWVodGEgPHNhbGlsLm1laHRhQGh1YXdlaS5jb20+
DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfbGliLmMg
fCAxNCArKysrKysrKy0tLS0tLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCsp
LCA2IGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2ludGVsL2ljZS9pY2VfbGliLmMNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVs
L2ljZS9pY2VfbGliLmMNCj4gPiBpbmRleCBkMTNjN2ZjOGZiMGEuLjE2MWU4ZGZlNTQ4YyAxMDA2
NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX2xpYi5jDQo+
ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9saWIuYw0KPiA+IEBA
IC0xNjEsMTIgKzE2MSwxMyBAQCBzdGF0aWMgdm9pZCBpY2VfdnNpX3NldF9udW1fcXMoc3RydWN0
IGljZV92c2kNCj4gPiAqdnNpLCB1MTYgdmZfaWQpDQo+ID4NCj4gPiAgCXN3aXRjaCAodnNpLT50
eXBlKSB7DQo+ID4gIAljYXNlIElDRV9WU0lfUEY6DQo+ID4gLQkJdnNpLT5hbGxvY190eHEgPSBt
aW4zKHBmLT5udW1fbGFuX21zaXgsDQo+ID4gLQkJCQkgICAgICBpY2VfZ2V0X2F2YWlsX3R4cV9j
b3VudChwZiksDQo+ID4gLQkJCQkgICAgICAodTE2KW51bV9vbmxpbmVfY3B1cygpKTsNCj4gPiAg
CQlpZiAodnNpLT5yZXFfdHhxKSB7DQo+ID4gIAkJCXZzaS0+YWxsb2NfdHhxID0gdnNpLT5yZXFf
dHhxOw0KPiA+ICAJCQl2c2ktPm51bV90eHEgPSB2c2ktPnJlcV90eHE7DQo+ID4gKwkJfSBlbHNl
IHsNCj4gPiArCQkJdnNpLT5hbGxvY190eHEgPSBtaW4zKHBmLT5udW1fbGFuX21zaXgsDQo+ID4g
KwkJCQkJIGljZV9nZXRfYXZhaWxfdHhxX2NvdW50KHBmKSwNCj4gPiArCQkJCQkgKHUxNiludW1f
b25saW5lX2NwdXMoKSk7DQo+IA0KPiBBbGlnbm1lbnQgaXMgaW5jb3JyZWN0Lg0KDQpPay4gV2ls
bCBjaGVjaywgcGVyaGFwcyB0aGUgY2F1c2Ugb2YgdGhlIGNoZWNrcGF0Y2gucGwgZXJyb3JzLg0K
DQo+IA0KPiA+ICAJCX0NCj4gPg0KPiA+ICAJCXBmLT5udW1fbGFuX3R4ID0gdnNpLT5hbGxvY190
eHE7DQo+ID4gQEAgLTE3NSwxMiArMTc2LDEzIEBAIHN0YXRpYyB2b2lkIGljZV92c2lfc2V0X251
bV9xcyhzdHJ1Y3QgaWNlX3ZzaQ0KPiA+ICp2c2ksIHUxNiB2Zl9pZCkNCj4gPiAgCQlpZiAoIXRl
c3RfYml0KElDRV9GTEFHX1JTU19FTkEsIHBmLT5mbGFncykpIHsNCj4gPiAgCQkJdnNpLT5hbGxv
Y19yeHEgPSAxOw0KPiA+ICAJCX0gZWxzZSB7DQo+ID4gLQkJCXZzaS0+YWxsb2NfcnhxID0gbWlu
MyhwZi0+bnVtX2xhbl9tc2l4LA0KPiA+IC0JCQkJCSAgICAgIGljZV9nZXRfYXZhaWxfcnhxX2Nv
dW50KHANCj4gPiBmKSwNCj4gPiAtCQkJCQkgICAgICAodTE2KW51bV9vbmxpbmVfY3B1cygpKTsN
Cj4gPiAgCQkJaWYgKHZzaS0+cmVxX3J4cSkgew0KPiA+ICAJCQkJdnNpLT5hbGxvY19yeHEgPSB2
c2ktPnJlcV9yeHE7DQo+ID4gIAkJCQl2c2ktPm51bV9yeHEgPSB2c2ktPnJlcV9yeHE7DQo+ID4g
KwkJCX0gZWxzZSB7DQo+ID4gKwkJCQl2c2ktPmFsbG9jX3J4cSA9IG1pbjMocGYtPm51bV9sYW5f
bXNpeCwNCj4gPiArCQkJCQkJIGljZV9nZXRfYXZhaWxfcnhxX2NvdW4NCj4gPiB0KHBmKSwNCj4g
PiArCQkJCQkJICh1MTYpbnVtX29ubGluZV9jcHVzKCkNCj4gDQo+IFNhbWUsIGFsaWdubWVudCBp
cyBpbmNvcnJlY3QuDQoNCk9rLiBXaWxsIGZpeC4NCg0KVGhhbmtzDQpTYWxpbC4NCg==
