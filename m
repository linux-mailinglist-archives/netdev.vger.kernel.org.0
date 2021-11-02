Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C654425C2
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 03:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbhKBC6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 22:58:03 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:25338 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhKBC6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 22:58:02 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HjvXd2w1VzbhWk;
        Tue,  2 Nov 2021 10:50:41 +0800 (CST)
Received: from kwepeml100005.china.huawei.com (7.221.188.221) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 2 Nov 2021 10:55:17 +0800
Received: from kwepeml500002.china.huawei.com (7.221.188.128) by
 kwepeml100005.china.huawei.com (7.221.188.221) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 2 Nov 2021 10:55:16 +0800
Received: from kwepeml500002.china.huawei.com ([7.221.188.128]) by
 kwepeml500002.china.huawei.com ([7.221.188.128]) with mapi id 15.01.2308.015;
 Tue, 2 Nov 2021 10:55:16 +0800
From:   huangguobin <huangguobin4@huawei.com>
To:     Julian Wiedmann <jwi@linux.ibm.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH -next] bonding: Fix a use-after-free problem when
 bond_sysfs_slave_add() failed
Thread-Topic: [PATCH -next] bonding: Fix a use-after-free problem when
 bond_sysfs_slave_add() failed
Thread-Index: AQHXzywi8OO9Gir3ZUGCSM3T8JXbNqvuiXYAgAD75SA=
Date:   Tue, 2 Nov 2021 02:55:16 +0000
Message-ID: <5c02fbac130941a1a8578965975116b5@huawei.com>
References: <1635777273-46028-1-git-send-email-huangguobin4@huawei.com>
 <d6cd47b1-3b46-fc44-3a8d-b2444af527e6@linux.ibm.com>
In-Reply-To: <d6cd47b1-3b46-fc44-3a8d-b2444af527e6@linux.ibm.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.177.139]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SSB0aGluayBib25kX3N5c2ZzX3NsYXZlX2RlbCBzaG91bGQgbm90IGJlIHVzZWQgaW4gdGhlIGVy
cm9yIGhhbmRsaW5nIHByb2Nlc3MsIGJlY2F1c2UgYm9uZF9zeXNmc19zbGF2ZV9kZWwgd2lsbCB0
cmF2ZXJzZSBhbGwgc2xhdmVfYXR0cnMgYW5kIHJlbGVhc2UgdGhlbS4gV2hlbiBzeXNmc19jcmVh
dGVfZmlsZSBmYWlscywgb25seSBzb21lIGF0dHJpYnV0ZXMgbWF5IGJlIGNyZWF0ZWQgc3VjY2Vz
c2Z1bGx5Lg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IEp1bGlhbiBXaWVkbWFu
biBbbWFpbHRvOmp3aUBsaW51eC5pYm0uY29tXSANClNlbnQ6IFR1ZXNkYXksIE5vdmVtYmVyIDIs
IDIwMjEgMzozMSBBTQ0KVG86IGh1YW5nZ3VvYmluIDxodWFuZ2d1b2JpbjRAaHVhd2VpLmNvbT47
IGoudm9zYnVyZ2hAZ21haWwuY29tOyB2ZmFsaWNvQGdtYWlsLmNvbTsgYW5keUBncmV5aG91c2Uu
bmV0OyBkYXZlbUBkYXZlbWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmcNCkNjOiBuZXRkZXZAdmdl
ci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQpTdWJqZWN0OiBSZTog
W1BBVENIIC1uZXh0XSBib25kaW5nOiBGaXggYSB1c2UtYWZ0ZXItZnJlZSBwcm9ibGVtIHdoZW4g
Ym9uZF9zeXNmc19zbGF2ZV9hZGQoKSBmYWlsZWQNCg0KT24gMDEuMTEuMjEgMTU6MzQsIEh1YW5n
IEd1b2JpbiB3cm90ZToNCj4gV2hlbiBJIGRvIGZ1enogdGVzdCBmb3IgYm9uZGluZyBkZXZpY2Ug
aW50ZXJmYWNlLCBJIGdvdCB0aGUgZm9sbG93aW5nIA0KPiB1c2UtYWZ0ZXItZnJlZSBDYWxsdHJh
Y2U6DQo+IA0KDQpbLi4uXQ0KDQo+IEZpeGVzOiA3YWZjYWVjNDk2OTYgKGJvbmRpbmc6IHVzZSBr
b2JqZWN0X3B1dCBpbnN0ZWFkIG9mIF9kZWwgYWZ0ZXIgDQo+IGtvYmplY3RfYWRkKQ0KPiBTaWdu
ZWQtb2ZmLWJ5OiBIdWFuZyBHdW9iaW4gPGh1YW5nZ3VvYmluNEBodWF3ZWkuY29tPg0KPiAtLS0N
Cj4gIGRyaXZlcnMvbmV0L2JvbmRpbmcvYm9uZF9zeXNmc19zbGF2ZS5jIHwgMTEgKysrKysrKyst
LS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+
IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvYm9uZGluZy9ib25kX3N5c2ZzX3NsYXZlLmMg
DQo+IGIvZHJpdmVycy9uZXQvYm9uZGluZy9ib25kX3N5c2ZzX3NsYXZlLmMNCj4gaW5kZXggZmQw
NzU2MS4uZDFhNWIzZiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvYm9uZGluZy9ib25kX3N5
c2ZzX3NsYXZlLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvYm9uZGluZy9ib25kX3N5c2ZzX3NsYXZl
LmMNCj4gQEAgLTEzNywxOCArMTM3LDIzIEBAIHN0YXRpYyBzc2l6ZV90IHNsYXZlX3Nob3coc3Ry
dWN0IGtvYmplY3QgKmtvYmosDQo+ICANCj4gIGludCBib25kX3N5c2ZzX3NsYXZlX2FkZChzdHJ1
Y3Qgc2xhdmUgKnNsYXZlKSAgew0KPiAtCWNvbnN0IHN0cnVjdCBzbGF2ZV9hdHRyaWJ1dGUgKiph
Ow0KPiArCWNvbnN0IHN0cnVjdCBzbGF2ZV9hdHRyaWJ1dGUgKiphLCAqKmI7DQo+ICAJaW50IGVy
cjsNCj4gIA0KPiAgCWZvciAoYSA9IHNsYXZlX2F0dHJzOyAqYTsgKythKSB7DQo+ICAJCWVyciA9
IHN5c2ZzX2NyZWF0ZV9maWxlKCZzbGF2ZS0+a29iaiwgJigoKmEpLT5hdHRyKSk7DQo+ICAJCWlm
IChlcnIpIHsNCj4gLQkJCWtvYmplY3RfcHV0KCZzbGF2ZS0+a29iaik7DQo+IC0JCQlyZXR1cm4g
ZXJyOw0KPiArCQkJZ290byBlcnJfcmVtb3ZlX2ZpbGU7DQo+ICAJCX0NCj4gIAl9DQo+ICANCj4g
IAlyZXR1cm4gMDsNCj4gKw0KPiArZXJyX3JlbW92ZV9maWxlOg0KPiArCWZvciAoYiA9IHNsYXZl
X2F0dHJzOyBiIDwgYTsgKytiKQ0KPiArCQlzeXNmc19yZW1vdmVfZmlsZSgmc2xhdmUtPmtvYmos
ICYoKCpiKS0+YXR0cikpOw0KPiArDQo+ICsJcmV0dXJuIGVycjsNCj4gIH0NCj4gIA0KDQpUaGlz
IGxvb2tzIGxpa2UgYSBjYW5kaWRhdGUgZm9yIHN5c2ZzX2NyZWF0ZV9maWxlcygpLCBubz8NCg0K
PiAgdm9pZCBib25kX3N5c2ZzX3NsYXZlX2RlbChzdHJ1Y3Qgc2xhdmUgKnNsYXZlKQ0KPiANCg0K
