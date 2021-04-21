Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46D54366655
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 09:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237042AbhDUHmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 03:42:14 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3405 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235209AbhDUHmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 03:42:13 -0400
Received: from dggeml406-hub.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4FQC8k4991z5sHp;
        Wed, 21 Apr 2021 15:38:30 +0800 (CST)
Received: from dggpeml100022.china.huawei.com (7.185.36.176) by
 dggeml406-hub.china.huawei.com (10.3.17.50) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Wed, 21 Apr 2021 15:41:16 +0800
Received: from lhreml703-chm.china.huawei.com (10.201.108.52) by
 dggpeml100022.china.huawei.com (7.185.36.176) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 21 Apr 2021 15:41:15 +0800
Received: from lhreml703-chm.china.huawei.com ([10.201.68.198]) by
 lhreml703-chm.china.huawei.com ([10.201.68.198]) with mapi id 15.01.2176.012;
 Wed, 21 Apr 2021 08:41:13 +0100
From:   Salil Mehta <salil.mehta@huawei.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
CC:     "linuxarm@openeuler.org" <linuxarm@openeuler.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH V2 net] ice: Re-organizes reqstd/avail
 {R, T}XQ check/code for efficiency+readability
Thread-Topic: [Intel-wired-lan] [PATCH V2 net] ice: Re-organizes reqstd/avail
 {R, T}XQ check/code for efficiency+readability
Thread-Index: AQHXNnA44ik22M7HZEWiZd3JF/ZDoKq+hESg
Date:   Wed, 21 Apr 2021 07:41:13 +0000
Message-ID: <418702bdb5244eb4811a2a1a536c55c0@huawei.com>
References: <20210413224446.16612-1-salil.mehta@huawei.com>
 <7974e665-73bd-401c-f023-9da568e1dffc@molgen.mpg.de>
In-Reply-To: <7974e665-73bd-401c-f023-9da568e1dffc@molgen.mpg.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.66.69]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBQYXVsIE1lbnplbCBbbWFpbHRvOnBtZW56ZWxAbW9sZ2VuLm1wZy5kZV0NCj4gU2Vu
dDogV2VkbmVzZGF5LCBBcHJpbCAyMSwgMjAyMSA2OjM2IEFNDQo+IFRvOiBTYWxpbCBNZWh0YSA8
c2FsaWwubWVodGFAaHVhd2VpLmNvbT4NCj4gQ2M6IGxpbnV4YXJtQG9wZW5ldWxlci5vcmc7IG5l
dGRldkB2Z2VyLmtlcm5lbC5vcmc7IExpbnV4YXJtDQo+IDxsaW51eGFybUBodWF3ZWkuY29tPjsg
bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgSmVmZiBLaXJzaGVyDQo+IDxqZWZmcmV5LnQu
a2lyc2hlckBpbnRlbC5jb20+OyBpbnRlbC13aXJlZC1sYW5AbGlzdHMub3N1b3NsLm9yZzsgRGF2
aWQgUy4NCj4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgSmFrdWIgS2ljaW5za2kgPGt1
YmFAa2VybmVsLm9yZz4NCj4gU3ViamVjdDogUmU6IFtJbnRlbC13aXJlZC1sYW5dIFtQQVRDSCBW
MiBuZXRdIGljZTogUmUtb3JnYW5pemVzIHJlcXN0ZC9hdmFpbA0KPiB7UiwgVH1YUSBjaGVjay9j
b2RlIGZvciBlZmZpY2llbmN5K3JlYWRhYmlsaXR5DQo+IA0KPiBEZWFyIFNhbGlsLA0KPiANCj4g
DQo+IFRoYW5rIHlvdSB2ZXJ5IG11Y2ggZm9yIHlvdXIgcGF0Y2guDQoNClRoYW5rcyBmb3IgdGhl
IHJldmlldy4NCg0KPiBJbiB0aGUgZ2l0IGNvbW1pdCBtZXNzYWdlIHN1bW1hcnksIGNvdWxkIHlv
dSBwbGVhc2UgdXNlIGltcGVyYXRpdmUgbW9vZCBbMV0/DQoNCk5vIGlzc3Vlcy4gVGhlcmUgaXMg
YWx3YXlzIGEgc2NvcGUgb2YgaW1wcm92ZW1lbnQuDQoNCg0KPiA+IFJlLW9yZ2FuaXplIHJlcXN0
ZC9hdmFpbCB7UiwgVH1YUSBjaGVjay9jb2RlIGZvciBlZmZpY2llbmN5K3JlYWRhYmlsaXR5DQo+
IA0KPiBJdOKAmXMgYSBiaXQgbG9uZyB0aG91Z2guIE1heWJlOg0KPiANCj4gQXZvaWQgdW5uZWNl
c3NhcnkgYXNzaWdubWVudCB3aXRoIHVzZXIgc3BlY2lmaWVkIHtSLFR9WFFzDQoNClVtbS4uYWJv
dmUgY29udmV5cyB0aGUgd3JvbmcgbWVhbmluZyBhcyB0aGlzIGlzIG5vdCB3aGF0IHBhdGNoIGlz
IGRvaW5nLiANCg0KSWYgeW91IHNlZSB0aGUgY29kZSwgaW4gdGhlIHByZXNlbmNlIG9mIHRoZSB1
c2VyIHNwZWNpZmllZCB7UixUfVhRcyBpdA0KYXZvaWRzIGZldGNoaW5nIGF2YWlsYWJsZSB7UixU
fVhRIGNvdW50LiANCg0KV2hhdCBhYm91dCBiZWxvdz8NCg0KIkF2b2lkIHVubmVjZXNzYXJ5IGF2
YWlsX3tyLHR9eHEgYXNzaWdubWVudHMgaWYgdXNlciBoYXMgc3BlY2lmaWVkIFFzIg0KDQoNCj4g
QW0gMTQuMDQuMjEgdW0gMDA6NDQgc2NocmllYiBTYWxpbCBNZWh0YToNCj4gPiBJZiB1c2VyIGhh
cyBleHBsaWNpdGx5IHJlcXVlc3RlZCB0aGUgbnVtYmVyIG9mIHtSLFR9WFFzLCB0aGVuIGl0IGlz
DQo+ID4gdW5uZWNlc3NhcnkgdG8gZ2V0IHRoZSBjb3VudCBvZiBhbHJlYWR5IGF2YWlsYWJsZSB7
UixUfVhRcyBmcm9tIHRoZQ0KPiA+IFBGIGF2YWlsX3tyLHR9eHFzIGJpdG1hcC4gVGhpcyB2YWx1
ZSB3aWxsIGdldCBvdmVycmlkZGVuIGJ5IHVzZXIgc3BlY2lmaWVkDQo+ID4gdmFsdWUgaW4gYW55
IGNhc2UuDQo+ID4NCj4gPiBUaGlzIHBhdGNoIGRvZXMgbWlub3IgcmUtb3JnYW5pemF0aW9uIG9m
IHRoZSBjb2RlIGZvciBpbXByb3ZpbmcgdGhlIGZsb3cNCj4gPiBhbmQgcmVhZGFiaWx0aXkuIFRo
aXMgc2NvcGUgb2YgaW1wcm92ZW1lbnQgd2FzIGZvdW5kIGR1cmluZyB0aGUgcmV2aWV3IG9mDQo+
IA0KPiByZWFkYWJpbCppdCp5DQoNCg0KVGhhbmtzLiBNaXNzZWQgdGhhdCBlYXJsaWVyLiBNeSBz
aGFreSBmaW5nZXJzIDooDQoNCiANCj4gPiB0aGUgSUNFIGRyaXZlciBjb2RlLg0KPiA+DQo+ID4g
RllJLCBJIGNvdWxkIG5vdCB0ZXN0IHRoaXMgY2hhbmdlIGR1ZSB0byB1bmF2YWlsYWJpbGl0eSBv
ZiB0aGUgaGFyZHdhcmUuDQo+ID4gSXQgd291bGQgYmUgaGVscGZ1bCBpZiBzb21lYm9keSBjYW4g
dGVzdCB0aGlzIHBhdGNoIGFuZCBwcm92aWRlIFRlc3RlZC1ieQ0KPiA+IFRhZy4gTWFueSB0aGFu
a3MhDQo+IA0KPiBUaGlzIHNob3VsZCBnbyBvdXRzaWRlIHRoZSBjb21taXQgbWVzc2FnZSAoYmVs
b3cgdGhlIC0tLSBmb3IgZXhhbXBsZSkuDQoNCkFncmVlZC4NCg0KPiA+IEZpeGVzOiA4NzMyNGU3
NDdmZGUgKCJpY2U6IEltcGxlbWVudCBldGh0b29sIG9wcyBmb3IgY2hhbm5lbHMiKQ0KPiANCj4g
RGlkIHlvdSBjaGVjayB0aGUgYmVoYXZpb3IgYmVmb3JlIGlzIGFjdHVhbGx5IGEgYnVnPyBPciBp
cyBpdCBqdXN0IGZvcg0KPiB0aGUgZGV0ZWN0aW9uIGhldXJpc3RpYyBmb3IgY29tbWl0cyB0byBi
ZSBhcHBsaWVkIHRvIHRoZSBzdGFibGUgc2VyaWVzPw0KDQpSaWdodCwgbGF0ZXIgd2FzIHRoZSBp
ZGVhLiANCg0KIA0KPiA+IENjOiBpbnRlbC13aXJlZC1sYW5AbGlzdHMub3N1b3NsLm9yZw0KPiA+
IENjOiBKZWZmIEtpcnNoZXIgPGplZmZyZXkudC5raXJzaGVyQGludGVsLmNvbT4NCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBTYWxpbCBNZWh0YSA8c2FsaWwubWVodGFAaHVhd2VpLmNvbT4NCj4gPiAtLQ0K
PiA+IENoYW5nZSBWMS0+VjINCj4gPiAgICgqKSBGaXhlZCB0aGUgY29tbWVudHMgZnJvbSBBbnRo
b255IE5ndXllbihJbnRlbCkNCj4gPiAgICAgICBMaW5rOiBodHRwczovL2xrbWwub3JnL2xrbWwv
MjAyMS80LzEyLzE5OTcNCj4gPiAtLS0NCj4gPiAgIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVs
L2ljZS9pY2VfbGliLmMgfCAxNCArKysrKysrKy0tLS0tLQ0KPiA+ICAgMSBmaWxlIGNoYW5nZWQs
IDggaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX2xpYi5jDQo+IGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9saWIuYw0KPiA+IGluZGV4IGQxM2M3ZmM4ZmIwYS4uZDc3
MTMzZDZiYWE3IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lj
ZS9pY2VfbGliLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNl
X2xpYi5jDQo+ID4gQEAgLTE2MSwxMiArMTYxLDEzIEBAIHN0YXRpYyB2b2lkIGljZV92c2lfc2V0
X251bV9xcyhzdHJ1Y3QgaWNlX3ZzaSAqdnNpLCB1MTYNCj4gdmZfaWQpDQo+ID4NCj4gPiAgIAlz
d2l0Y2ggKHZzaS0+dHlwZSkgew0KPiA+ICAgCWNhc2UgSUNFX1ZTSV9QRjoNCj4gPiAtCQl2c2kt
PmFsbG9jX3R4cSA9IG1pbjMocGYtPm51bV9sYW5fbXNpeCwNCj4gPiAtCQkJCSAgICAgIGljZV9n
ZXRfYXZhaWxfdHhxX2NvdW50KHBmKSwNCj4gPiAtCQkJCSAgICAgICh1MTYpbnVtX29ubGluZV9j
cHVzKCkpOw0KPiA+ICAgCQlpZiAodnNpLT5yZXFfdHhxKSB7DQo+ID4gICAJCQl2c2ktPmFsbG9j
X3R4cSA9IHZzaS0+cmVxX3R4cTsNCj4gPiAgIAkJCXZzaS0+bnVtX3R4cSA9IHZzaS0+cmVxX3R4
cTsNCj4gPiArCQl9IGVsc2Ugew0KPiA+ICsJCQl2c2ktPmFsbG9jX3R4cSA9IG1pbjMocGYtPm51
bV9sYW5fbXNpeCwNCj4gPiArCQkJCQkgICAgICBpY2VfZ2V0X2F2YWlsX3R4cV9jb3VudChwZiks
DQo+ID4gKwkJCQkJICAgICAgKHUxNiludW1fb25saW5lX2NwdXMoKSk7DQo+ID4gICAJCX0NCj4g
DQo+IEkgYW0gY3VyaW91cywgZGlkIHlvdSBjaGVjayB0aGUgY29tcGlsZXIgYWN0dWFsbHkgY3Jl
YXRlcyBkaWZmZXJlbnQNCj4gY29kZSwgb3IgZGlkIGl0IG5vdGljZSB0aGUgaW5lZmZpY2llbmN5
IGJ5IGl0c2VsZiBhbmQgb3B0aW1pemVkIGl0IGFscmVhZHk/DQoNCkkgaGF2ZSBub3QgbG9va2Vk
IGludG8gdGhhdCBkZXRhaWwgYnV0IGlycmVzcGVjdGl2ZSBvZiB3aGF0IGNvbXBpbGVyIGdlbmVy
YXRlcw0KSSB3b3VsZCBsaWtlIHRvIGtlZXAgdGhlIGNvZGUgaW4gYSBzaGFwZSB3aGljaCBpcyBt
b3JlIGVmZmljaWVudCBhbmQgbW9yZSByZWFkYWJsZS4NCg0KSSBkbyB1bmRlcnN0YW5kIGluIGNl
cnRhaW4gY2FzZXMgd2UgaGF2ZSB0byBkbyB0cmFkZW9mZiBiZXR3ZWVuIGVmZmljaWVuY3kNCmFu
ZCByZWFkYWJpbGl0eSBidXQgSSBkbyBub3Qgc2VlIHRoYXQgaGVyZS4NCg0KDQo+ID4gICAJCXBm
LT5udW1fbGFuX3R4ID0gdnNpLT5hbGxvY190eHE7DQo+ID4gQEAgLTE3NSwxMiArMTc2LDEzIEBA
IHN0YXRpYyB2b2lkIGljZV92c2lfc2V0X251bV9xcyhzdHJ1Y3QgaWNlX3ZzaSAqdnNpLCB1MTYN
Cj4gdmZfaWQpDQo+ID4gICAJCWlmICghdGVzdF9iaXQoSUNFX0ZMQUdfUlNTX0VOQSwgcGYtPmZs
YWdzKSkgew0KPiA+ICAgCQkJdnNpLT5hbGxvY19yeHEgPSAxOw0KPiA+ICAgCQl9IGVsc2Ugew0K
PiA+IC0JCQl2c2ktPmFsbG9jX3J4cSA9IG1pbjMocGYtPm51bV9sYW5fbXNpeCwNCj4gPiAtCQkJ
CQkgICAgICBpY2VfZ2V0X2F2YWlsX3J4cV9jb3VudChwZiksDQo+ID4gLQkJCQkJICAgICAgKHUx
NiludW1fb25saW5lX2NwdXMoKSk7DQo+ID4gICAJCQlpZiAodnNpLT5yZXFfcnhxKSB7DQo+ID4g
ICAJCQkJdnNpLT5hbGxvY19yeHEgPSB2c2ktPnJlcV9yeHE7DQo+ID4gICAJCQkJdnNpLT5udW1f
cnhxID0gdnNpLT5yZXFfcnhxOw0KPiA+ICsJCQl9IGVsc2Ugew0KPiA+ICsJCQkJdnNpLT5hbGxv
Y19yeHEgPSBtaW4zKHBmLT5udW1fbGFuX21zaXgsDQo+ID4gKwkJCQkJCSAgICAgIGljZV9nZXRf
YXZhaWxfcnhxX2NvdW50KHBmKSwNCj4gPiArCQkJCQkJICAgICAgKHUxNiludW1fb25saW5lX2Nw
dXMoKSk7DQo+ID4gICAJCQl9DQo+ID4gICAJCX0NCj4gPg0KPiANCj4gDQo+IEtpbmQgcmVnYXJk
cywNCj4gDQo+IFBhdWwNCg==
