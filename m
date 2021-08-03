Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79E753DE449
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 04:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbhHCCRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 22:17:34 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:12438 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233200AbhHCCRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 22:17:33 -0400
Received: from dggeme701-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Gdz242zxnzckD1;
        Tue,  3 Aug 2021 10:13:48 +0800 (CST)
Received: from dggpemm500021.china.huawei.com (7.185.36.109) by
 dggeme701-chm.china.huawei.com (10.1.199.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 3 Aug 2021 10:17:21 +0800
Received: from dggpemm500021.china.huawei.com ([7.185.36.109]) by
 dggpemm500021.china.huawei.com ([7.185.36.109]) with mapi id 15.01.2176.012;
 Tue, 3 Aug 2021 10:17:21 +0800
From:   "zhudi (J)" <zhudi21@huawei.com>
To:     Nicholas Richardson <richardsonnick@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "nrrichar@ncsu.edu" <nrrichar@ncsu.edu>,
        "arunkaly@google.com" <arunkaly@google.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "yebin (H)" <yebin10@huawei.com>,
        Yejune Deng <yejune.deng@gmail.com>,
        Leesoo Ahn <dev@ooseel.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggdjNdIHBrdGdlbjogRml4IGludmFsaWQgY2xvbmVf?=
 =?utf-8?Q?skb_override?=
Thread-Topic: [PATCH v3] pktgen: Fix invalid clone_skb override
Thread-Index: AQHXh8tQ8xg7Med4W06C+qfPmCpoyKthAu9g
Date:   Tue, 3 Aug 2021 02:17:20 +0000
Message-ID: <47e01747a5c648c8809c77055e981e80@huawei.com>
References: <20210802102100.5292367a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210802182057.2199810-1-richardsonnick@google.com>
In-Reply-To: <20210802182057.2199810-1-richardsonnick@google.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.136.114.155]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBOaWNrIFJpY2hhcmRzb24gPHJpY2hhcmRzb25uaWNrQGdvb2dsZS5jb20+DQo+IA0K
PiBXaGVuIHRoZSBuZXRpZl9yZWNlaXZlIHhtaXRfbW9kZSBpcyBzZXQsIGEgbGluZSBpcyBzdXBw
b3NlZCB0byBzZXQNCj4gY2xvbmVfc2tiIHRvIGEgZGVmYXVsdCAwIHZhbHVlLiBUaGlzIGxpbmUg
aXMgbWFkZSByZWR1bmRhbnQgZHVlIHRvIGENCj4gcHJlY2VkaW5nIGxpbmUgdGhhdCBjaGVja3Mg
aWYgY2xvbmVfc2tiIGlzIG1vcmUgdGhhbiB6ZXJvIGFuZCByZXR1cm5zDQo+IC1FTk9UU1VQUC4N
Cj4gDQo+IE9ubHkgdGhlIHBvc2l0aXZlIGNhc2UgZm9yIGNsb25lX3NrYiBuZWVkcyB0byBiZSBj
aGVja2VkLiBJdA0KPiBpcyBpbXBvc3NpYmxlIGZvciBhIHVzZXIgdG8gc2V0IGNsb25lX3NrYiB0
byBhIG5lZ2F0aXZlIG51bWJlci4NCj4gV2hlbiBhIHVzZXIgcGFzc2VzIGEgbmVnYXRpdmUgdmFs
dWUgZm9yIGNsb25lX3NrYiwgdGhlIG51bV9hcmcoKQ0KPiBmdW5jdGlvbiBzdG9wcyBwYXJzaW5n
IGF0IHRoZSBmaXJzdCBub25udW1lcmljIHZhbHVlLg0KPiANCj4gRm9yIGV4YW1wbGU6ICJjbG9u
ZV9za2IgLTIwMCIgd291bGQgc3RvcCBwYXJzaW5nIGF0IHRoZQ0KPiBmaXJzdCBjaGFyICgnLScp
IGFuZCByZXR1cm4gemVybyBmb3IgdGhlIG5ldyBjbG9uZV9za2IgdmFsdWUuDQo+IA0KPiBUaGUg
dmFsdWUgcmVhZCBieSBudW1fYXJnKCkgY2Fubm90IGJlIG92ZXJmbG93LWVkIGludG8gdGhlIG5l
Z2F0aXZlDQo+IHJhbmdlLCBzaW5jZSBpdCBpcyBhbiB1bnNpZ25lZCBsb25nLg0KPiANCg0KbW9k
dWxlX3BhcmFtKHBnX2Nsb25lX3NrYl9kLCBpbnQsIDApOw0KDQpUaGlzIGtlcm5lbCBwYXJhbWV0
ZXIgY2FuIGFsc28gc2V0IHRoZSB2YWx1ZSBvZiBwa3RfZGV2LT5jbG9uZV9za2INCkluIHBrdGdl
bl9hZGRfZGV2aWNlKCkgYW5kIHRoZSB2YWx1ZSBjYW4gYmUgbmVnYXRpdmUuDQoNCg0KPiBSZW1v
dmUgcmVkdW5kYW50IGxpbmUgdGhhdCBzZXRzIGNsb25lX3NrYiB0byB6ZXJvLiBJZiBjbG9uZV9z
a2IgaXMNCj4gZXF1YWwgdG8gemVybyB0aGVuIHNldCB4bWl0X21vZGUgdG8gbmV0aWZfcmVjZWl2
ZSBhcyB1c3VhbCBhbmQgcmV0dXJuDQo+IG5vIGVycm9yLg0KPiANCj4gU2lnbmVkLW9mZi1ieTog
TmljayBSaWNoYXJkc29uIDxyaWNoYXJkc29ubmlja0Bnb29nbGUuY29tPg0KPiAtLS0NCj4gIG5l
dC9jb3JlL3BrdGdlbi5jIHwgNSAtLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDUgZGVsZXRpb25z
KC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvbmV0L2NvcmUvcGt0Z2VuLmMgYi9uZXQvY29yZS9wa3Rn
ZW4uYw0KPiBpbmRleCA3ZTI1OGQyNTVlOTAuLjMxNGY5N2FjZjM5ZCAxMDA2NDQNCj4gLS0tIGEv
bmV0L2NvcmUvcGt0Z2VuLmMNCj4gKysrIGIvbmV0L2NvcmUvcGt0Z2VuLmMNCj4gQEAgLTExOTAs
MTEgKzExOTAsNiBAQCBzdGF0aWMgc3NpemVfdCBwa3RnZW5faWZfd3JpdGUoc3RydWN0IGZpbGUg
KmZpbGUsDQo+ICAJCQkgKiBwa3RnZW5feG1pdCgpIGlzIGNhbGxlZA0KPiAgCQkJICovDQo+ICAJ
CQlwa3RfZGV2LT5sYXN0X29rID0gMTsNCj4gLQ0KPiAtCQkJLyogb3ZlcnJpZGUgY2xvbmVfc2ti
IGlmIHVzZXIgcGFzc2VkIGRlZmF1bHQgdmFsdWUNCj4gLQkJCSAqIGF0IG1vZHVsZSBsb2FkaW5n
IHRpbWUNCj4gLQkJCSAqLw0KPiAtCQkJcGt0X2Rldi0+Y2xvbmVfc2tiID0gMDsNCj4gIAkJfSBl
bHNlIGlmIChzdHJjbXAoZiwgInF1ZXVlX3htaXQiKSA9PSAwKSB7DQo+ICAJCQlwa3RfZGV2LT54
bWl0X21vZGUgPSBNX1FVRVVFX1hNSVQ7DQo+ICAJCQlwa3RfZGV2LT5sYXN0X29rID0gMTsNCj4g
LS0NCj4gMi4zMi4wLjU1NC5nZTFiMzI3MDZkOC1nb29nDQoNCg==
