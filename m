Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBFB241ACF
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 14:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbgHKMLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 08:11:38 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3012 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728423AbgHKMLZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Aug 2020 08:11:25 -0400
Received: from dggeme753-chm.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 2FEF98870F8A34B11D91;
        Tue, 11 Aug 2020 20:10:50 +0800 (CST)
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme753-chm.china.huawei.com (10.3.19.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Tue, 11 Aug 2020 20:10:49 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1913.007;
 Tue, 11 Aug 2020 20:10:49 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pshelar@ovn.org" <pshelar@ovn.org>,
        "martin.varghese@nokia.com" <martin.varghese@nokia.com>,
        "fw@strlen.de" <fw@strlen.de>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "steffen.klassert@secunet.com" <steffen.klassert@secunet.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "shmulik@metanetworks.com" <shmulik@metanetworks.com>,
        "kyk.segfault@gmail.com" <kyk.segfault@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: eliminate meaningless memcpy to data in
 pskb_carve_inside_nonlinear()
Thread-Topic: [PATCH] net: eliminate meaningless memcpy to data in
 pskb_carve_inside_nonlinear()
Thread-Index: AdZv1p8z2cljr2j1QqmBFzhMwq+yDA==
Date:   Tue, 11 Aug 2020 12:10:49 +0000
Message-ID: <40a0b4ba22ff499686a2521998767ae5@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.252]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RXJpYyBEdW1hemV0IDxlcmljLmR1bWF6ZXRAZ21haWwuY29tPiB3cm90ZToNCj4gT24gOC8xMC8y
MCA1OjI4IEFNLCBNaWFvaGUgTGluIHdyb3RlOg0KPj4gVGhlIHNrYl9zaGFyZWRfaW5mbyBwYXJ0
IG9mIHRoZSBkYXRhIGlzIGFzc2lnbmVkIGluIHRoZSBmb2xsb3dpbmcgDQo+PiBsb29wLiBJdCBp
cyBtZWFuaW5nbGVzcyB0byBkbyBhIG1lbWNweSBoZXJlLg0KPj4gDQo+DQo+UmVtaW5kZXIgOiBu
ZXQtbmV4dCBpcyBDTE9TRUQuDQo+DQoNClRoYW5rcyBmb3IgeW91ciByZW1pbmQuIEkgd291bGQg
d2FpdCBmb3IgaXQgb3Blbi4NCg0KPlRoaXMgaXMgbm90IGNvcnJlY3QuIFdlIHN0aWxsIGhhdmUg
dG8gY29weSBfc29tZXRoaW5nXw0KPg0KPlNvbWV0aGluZyBsaWtlIDoNCj4NCj5kaWZmIC0tZ2l0
IGEvbmV0L2NvcmUvc2tidWZmLmMgYi9uZXQvY29yZS9za2J1ZmYuYyBpbmRleCAyODI4ZjZkNWJh
ODk4YTVlNTBjY2NlNDU1ODliZjEzNzBlNDc0YjBmLi4xYzA1MTk0MjZjN2JhNGIwNDM3N2ZjODA1
NGM0MjIzYzEzNTg3OWFiIDEwMDY0NA0KPi0tLSBhL25ldC9jb3JlL3NrYnVmZi5jDQo+KysrIGIv
bmV0L2NvcmUvc2tidWZmLmMNCj5AQCAtNTk1Myw4ICs1OTUzLDggQEAgc3RhdGljIGludCBwc2ti
X2NhcnZlX2luc2lkZV9ub25saW5lYXIoc3RydWN0IHNrX2J1ZmYgKnNrYiwgY29uc3QgdTMyIG9m
ZiwNCj4gICAgICAgIHNpemUgPSBTS0JfV0lUSF9PVkVSSEVBRChrc2l6ZShkYXRhKSk7DQo+IA0K
PiAgICAgICAgbWVtY3B5KChzdHJ1Y3Qgc2tiX3NoYXJlZF9pbmZvICopKGRhdGEgKyBzaXplKSwN
Cj4tICAgICAgICAgICAgICBza2Jfc2hpbmZvKHNrYiksIG9mZnNldG9mKHN0cnVjdCBza2Jfc2hh
cmVkX2luZm8sDQo+LSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBmcmFn
c1tza2Jfc2hpbmZvKHNrYiktPm5yX2ZyYWdzXSkpOw0KPisgICAgICAgICAgICAgIHNrYl9zaGlu
Zm8oc2tiKSwgb2Zmc2V0b2Yoc3RydWN0IHNrYl9zaGFyZWRfaW5mbywgDQo+KyBmcmFnc1swXSkp
Ow0KPisNCj4gICAgICAgIGlmIChza2Jfb3JwaGFuX2ZyYWdzKHNrYiwgZ2ZwX21hc2spKSB7DQo+
ICAgICAgICAgICAgICAgIGtmcmVlKGRhdGEpOw0KPiAgICAgICAgICAgICAgICByZXR1cm4gLUVO
T01FTTsNCj4NCg0KVGhpcyBsb29rcyBnb29kLiBXaWxsIHNlbmQgYSBwYXRjaCB2MiBzb29uLiBN
YXkgSSBhZGQgYSBzdWdnZXN0ZWQtYnkgdGFnIG9mIHlvdSA/DQpNYW55IHRoYW5rcy4NCg0K
