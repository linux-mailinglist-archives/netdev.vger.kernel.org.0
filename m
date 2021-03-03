Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D73F632C448
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388962AbhCDAMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:12:23 -0500
Received: from mail6.tencent.com ([220.249.245.26]:40384 "EHLO
        mail6.tencent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358186AbhCCL5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 06:57:17 -0500
X-Greylist: delayed 4183 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Mar 2021 06:57:10 EST
Received: from EX-SZ018.tencent.com (unknown [10.28.6.39])
        by mail6.tencent.com (Postfix) with ESMTP id BCE37CC18E;
        Wed,  3 Mar 2021 17:28:11 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tencent.com;
        s=s202002; t=1614763691;
        bh=0DHu7YSHfuZpObjRsOBKHAFPCxsRH9TW5j6O5SKoe9k=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=X+pEBCV/6eYCwRgDue7cZsWhG3wPeimxju3wmtzIT8Ljm49YAZj2bml/1VKhUoNUc
         RPkQWkwQaEfmbBhPkGNgD/DBn7ioIry6I3KtsJBHt4pOv1/T0VhHHjW80k6PXDViUI
         egcZE1A/LZ4D+dT1VPMjhZmCJ8smK08WyrRxIGxw=
Received: from EX-SZ001.tencent.com (10.28.6.13) by EX-SZ018.tencent.com
 (10.28.6.39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Wed, 3 Mar 2021
 17:28:11 +0800
Received: from EX-SZ008.tencent.com (10.28.6.32) by EX-SZ001.tencent.com
 (10.28.6.13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Wed, 3 Mar 2021
 17:28:11 +0800
Received: from EX-SZ008.tencent.com ([fe80::a445:9f31:1c10:bf51]) by
 EX-SZ008.tencent.com ([fe80::a445:9f31:1c10:bf51%10]) with mapi id
 15.01.2106.002; Wed, 3 Mar 2021 17:28:11 +0800
From:   =?utf-8?B?a2l5aW4o5bC55LquKQ==?= <kiyin@tencent.com>
To:     Xiaoming Ni <nixiaoming@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "stefan@datenfreihafen.org" <stefan@datenfreihafen.org>,
        "matthieu.baerts@tessares.net" <matthieu.baerts@tessares.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "wangle6@huawei.com" <wangle6@huawei.com>,
        "xiaoqian9@huawei.com" <xiaoqian9@huawei.com>
Subject: RE: [PATCH 4/4] nfc: Avoid endless loops caused by repeated
 llcp_sock_connect()(Internet mail)
Thread-Topic: [PATCH 4/4] nfc: Avoid endless loops caused by repeated
 llcp_sock_connect()(Internet mail)
Thread-Index: AQHXD/Teu1rU3sSMBUSAy4tsrXSR0apx/YwQ
Date:   Wed, 3 Mar 2021 09:28:11 +0000
Message-ID: <2965a9b88d254b7f8e7f4356875bbedb@tencent.com>
References: <20210303061654.127666-1-nixiaoming@huawei.com>
 <20210303061654.127666-5-nixiaoming@huawei.com>
In-Reply-To: <20210303061654.127666-5-nixiaoming@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.14.87.252]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgeGlhb21pbmcsDQogIHRoZSBwYXRoIGNhbiBvbmx5IGZpeCB0aGUgZW5kbGVzcyBsb29wIHBy
b2JsZW0uIGl0IGNhbid0IGZpeCB0aGUgbWVhbmluZ2xlc3MgbGxjcF9zb2NrLT5zZXJ2aWNlX25h
bWUgcHJvYmxlbS4NCiAgaWYgd2Ugc2V0IGxsY3Bfc29jay0+c2VydmljZV9uYW1lIHRvIG1lYW5p
bmdsZXNzIHN0cmluZywgdGhlIGNvbm5lY3Qgd2lsbCBiZSBmYWlsZWQuIGFuZCBzay0+c2tfc3Rh
dGUgd2lsbCBub3QgYmUgTExDUF9DT05ORUNURUQuIHRoZW4gd2UgY2FuIGNhbGwgbGxjcF9zb2Nr
X2Nvbm5lY3QoKSBtYW55IHRpbWVzLiB0aGF0IGxlYWtzIGV2ZXJ5dGhpbmc6IGxsY3Bfc29jay0+
ZGV2LCBsbGNwX3NvY2stPmxvY2FsLCBsbGNwX3NvY2stPnNzYXAsIGxsY3Bfc29jay0+c2Vydmlj
ZV9uYW1lLi4uDQoNClJlZ2FyZHMsDQpraXlpbi4NCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2Ut
LS0tLQ0KPiBGcm9tOiBYaWFvbWluZyBOaSBbbWFpbHRvOm5peGlhb21pbmdAaHVhd2VpLmNvbV0N
Cj4gU2VudDogV2VkbmVzZGF5LCBNYXJjaCAzLCAyMDIxIDI6MTcgUE0NCj4gVG86IGxpbnV4LWtl
cm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGtpeWluKOWwueS6rikgPGtpeWluQHRlbmNlbnQuY29tPjsN
Cj4gc3RhYmxlQHZnZXIua2VybmVsLm9yZzsgZ3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc7IHNh
bWVvQGxpbnV4LmludGVsLmNvbTsNCj4gbGludmlsbGVAdHV4ZHJpdmVyLmNvbTsgZGF2ZW1AZGF2
ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOw0KPiBta2xAcGVuZ3V0cm9uaXguZGU7IHN0ZWZh
bkBkYXRlbmZyZWloYWZlbi5vcmc7DQo+IG1hdHRoaWV1LmJhZXJ0c0B0ZXNzYXJlcy5uZXQ7IG5l
dGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IG5peGlhb21pbmdAaHVhd2VpLmNvbTsgd2FuZ2xl
NkBodWF3ZWkuY29tOyB4aWFvcWlhbjlAaHVhd2VpLmNvbQ0KPiBTdWJqZWN0OiBbUEFUQ0ggNC80
XSBuZmM6IEF2b2lkIGVuZGxlc3MgbG9vcHMgY2F1c2VkIGJ5IHJlcGVhdGVkDQo+IGxsY3Bfc29j
a19jb25uZWN0KCkoSW50ZXJuZXQgbWFpbCkNCj4gDQo+IFdoZW4gc29ja193YWl0X3N0YXRlKCkg
cmV0dXJucyAtRUlOUFJPR1JFU1MsICJzay0+c2tfc3RhdGUiIGlzDQo+IExMQ1BfQ09OTkVDVElO
Ry4gSW4gdGhpcyBjYXNlLCBsbGNwX3NvY2tfY29ubmVjdCgpIGlzIHJlcGVhdGVkbHkgaW52b2tl
ZCwNCj4gIG5mY19sbGNwX3NvY2tfbGluaygpIHdpbGwgYWRkIHNrIHRvIGxvY2FsLT5jb25uZWN0
aW5nX3NvY2tldHMgdHdpY2UuDQo+ICBzay0+c2tfbm9kZS0+bmV4dCB3aWxsIHBvaW50IHRvIGl0
c2VsZiwgdGhhdCB3aWxsIG1ha2UgYW4gZW5kbGVzcyBsb29wICBhbmQNCj4gaGFuZy11cCB0aGUg
c3lzdGVtLg0KPiBUbyBmaXggaXQsIGNoZWNrIHdoZXRoZXIgc2stPnNrX3N0YXRlIGlzIExMQ1Bf
Q09OTkVDVElORyBpbg0KPiAgbGxjcF9zb2NrX2Nvbm5lY3QoKSB0byBhdm9pZCByZXBlYXRlZCBp
bnZva2luZy4NCj4gDQo+IGZpeCBDVkUtMjAyMC0yNTY3Mw0KPiBGaXhlczogYjQwMTEyMzlhMDhl
ICgiTkZDOiBsbGNwOiBGaXggbm9uIGJsb2NraW5nIHNvY2tldHMgY29ubmVjdGlvbnMiKQ0KPiBS
ZXBvcnRlZC1ieTogImtpeWluKOWwueS6rikiIDxraXlpbkB0ZW5jZW50LmNvbT4NCj4gTGluazog
aHR0cHM6Ly93d3cub3BlbndhbGwuY29tL2xpc3RzL29zcy1zZWN1cml0eS8yMDIwLzExLzAxLzEN
Cj4gQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPiAjdjMuMTENCj4gU2lnbmVkLW9mZi1ieTog
WGlhb21pbmcgTmkgPG5peGlhb21pbmdAaHVhd2VpLmNvbT4NCj4gLS0tDQo+ICBuZXQvbmZjL2xs
Y3Bfc29jay5jIHwgNCArKysrDQo+ICAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspDQo+
IA0KPiBkaWZmIC0tZ2l0IGEvbmV0L25mYy9sbGNwX3NvY2suYyBiL25ldC9uZmMvbGxjcF9zb2Nr
LmMgaW5kZXgNCj4gNTkxNzI2MTRiMjQ5Li5hM2I0NmY4ODg4MDMgMTAwNjQ0DQo+IC0tLSBhL25l
dC9uZmMvbGxjcF9zb2NrLmMNCj4gKysrIGIvbmV0L25mYy9sbGNwX3NvY2suYw0KPiBAQCAtNjcz
LDYgKzY3MywxMCBAQCBzdGF0aWMgaW50IGxsY3Bfc29ja19jb25uZWN0KHN0cnVjdCBzb2NrZXQg
KnNvY2ssDQo+IHN0cnVjdCBzb2NrYWRkciAqX2FkZHIsDQo+ICAJCXJldCA9IC1FSVNDT05OOw0K
PiAgCQlnb3RvIGVycm9yOw0KPiAgCX0NCj4gKwlpZiAoc2stPnNrX3N0YXRlID09IExMQ1BfQ09O
TkVDVElORykgew0KPiArCQlyZXQgPSAtRUlOUFJPR1JFU1M7DQo+ICsJCWdvdG8gZXJyb3I7DQo+
ICsJfQ0KPiANCj4gIAlkZXYgPSBuZmNfZ2V0X2RldmljZShhZGRyLT5kZXZfaWR4KTsNCj4gIAlp
ZiAoZGV2ID09IE5VTEwpIHsNCj4gLS0NCj4gMi4yNy4wDQo+IA0KDQo=
