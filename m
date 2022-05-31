Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50211538D28
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 10:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244963AbiEaIsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 04:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244908AbiEaIsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 04:48:03 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC7B3E5F8;
        Tue, 31 May 2022 01:48:02 -0700 (PDT)
Received: from fraeml708-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LC5W25ffgz6H7q1;
        Tue, 31 May 2022 16:47:10 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml708-chm.china.huawei.com (10.206.15.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 31 May 2022 10:47:59 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2375.024;
 Tue, 31 May 2022 10:47:59 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] libbpf: Retry map access with read-only permission
Thread-Topic: [PATCH 1/2] libbpf: Retry map access with read-only permission
Thread-Index: AQHYdAGr6HbH9aP+3U6x+kyoxSOBpK031lIAgADW9rA=
Date:   Tue, 31 May 2022 08:47:59 +0000
Message-ID: <8473aece18f64fbea2d27ddd30036685@huawei.com>
References: <20220530084514.10170-1-roberto.sassu@huawei.com>
 <20220530084514.10170-2-roberto.sassu@huawei.com>
 <4089f118-662c-4ea2-131f-c8a9b702b6ca@iogearbox.net>
In-Reply-To: <4089f118-662c-4ea2-131f-c8a9b702b6ca@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.204.63.21]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBEYW5pZWwgQm9ya21hbm4gW21haWx0bzpkYW5pZWxAaW9nZWFyYm94Lm5ldF0NCj4g
U2VudDogTW9uZGF5LCBNYXkgMzAsIDIwMjIgMTE6NTUgUE0NCj4gT24gNS8zMC8yMiAxMDo0NSBB
TSwgUm9iZXJ0byBTYXNzdSB3cm90ZToNCj4gPiBSZXRyeSBtYXAgYWNjZXNzIHdpdGggcmVhZC1v
bmx5IHBlcm1pc3Npb24sIGlmIGFjY2VzcyB3YXMgZGVuaWVkIHdoZW4gYWxsDQo+ID4gcGVybWlz
c2lvbnMgd2VyZSByZXF1ZXN0ZWQgKG9wZW5fZmxhZ3MgaXMgc2V0IHRvIHplcm8pLiBXcml0ZSBh
Y2Nlc3MgbWlnaHQNCj4gPiBoYXZlIGJlZW4gZGVuaWVkIGJ5IHRoZSBicGZfbWFwIHNlY3VyaXR5
IGhvb2suDQo+ID4NCj4gPiBTb21lIG9wZXJhdGlvbnMsIHN1Y2ggYXMgc2hvdyBhbmQgZHVtcCwg
ZG9uJ3QgbmVlZCB3cml0ZSBwZXJtaXNzaW9ucywgc28NCj4gPiB0aGVyZSBpcyBhIGdvb2QgY2hh
bmNlIG9mIHN1Y2Nlc3Mgd2l0aCByZXRyeWluZy4NCj4gPg0KPiA+IFByZWZlciB0aGlzIHNvbHV0
aW9uIHRvIGV4dGVuZGluZyB0aGUgQVBJLCBhcyBvdGhlcndpc2UgYSBuZXcgbWVjaGFuaXNtDQo+
ID4gd291bGQgbmVlZCB0byBiZSBpbXBsZW1lbnRlZCB0byBkZXRlcm1pbmUgdGhlIHJpZ2h0IHBl
cm1pc3Npb25zIGZvciBhbg0KPiA+IG9wZXJhdGlvbi4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6
IFJvYmVydG8gU2Fzc3UgPHJvYmVydG8uc2Fzc3VAaHVhd2VpLmNvbT4NCj4gPiAtLS0NCj4gPiAg
IHRvb2xzL2xpYi9icGYvYnBmLmMgfCA1ICsrKysrDQo+ID4gICAxIGZpbGUgY2hhbmdlZCwgNSBp
bnNlcnRpb25zKCspDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvdG9vbHMvbGliL2JwZi9icGYuYyBi
L3Rvb2xzL2xpYi9icGYvYnBmLmMNCj4gPiBpbmRleCAyNDAxODZhYWM4ZTYuLmI0ZWVjMzkwMjFh
NCAxMDA2NDQNCj4gPiAtLS0gYS90b29scy9saWIvYnBmL2JwZi5jDQo+ID4gKysrIGIvdG9vbHMv
bGliL2JwZi9icGYuYw0KPiA+IEBAIC0xMDU2LDYgKzEwNTYsMTEgQEAgaW50IGJwZl9tYXBfZ2V0
X2ZkX2J5X2lkKF9fdTMyIGlkKQ0KPiA+ICAgCWF0dHIubWFwX2lkID0gaWQ7DQo+ID4NCj4gPiAg
IAlmZCA9IHN5c19icGZfZmQoQlBGX01BUF9HRVRfRkRfQllfSUQsICZhdHRyLCBzaXplb2YoYXR0
cikpOw0KPiA+ICsJaWYgKGZkIDwgMCkgew0KPiA+ICsJCWF0dHIub3Blbl9mbGFncyA9IEJQRl9G
X1JET05MWTsNCj4gPiArCQlmZCA9IHN5c19icGZfZmQoQlBGX01BUF9HRVRfRkRfQllfSUQsICZh
dHRyLCBzaXplb2YoYXR0cikpOw0KPiA+ICsJfQ0KPiA+ICsNCj4gDQo+IEJ1dCB0aGVuIHdoYXQg
YWJvdXQgYnBmX29ial9nZXQoKSBBUEkgaW4gbGliYnBmPyBhdHRyLmZpbGVfZmxhZ3MgaGFzIHNp
bWlsYXINCj4gcHVycG9zZSBhcyBhdHRyLm9wZW5fZmxhZ3MgaW4gdGhpcyBjYXNlLg0KDQpPaywg
SSBtaXNzZWQgaXQuDQoNCj4gVGhlIG90aGVyIGlzc3VlIGlzIHRoYXQgdGhpcyBjb3VsZCBoYXZl
IHVwZ3JhZGUgaW1wbGljYXRpb25zLCBlLmcuIHdoZXJlIGFuDQo+IGFwcGxpY2F0aW9uIGJhaWxl
ZCBvdXQgYmVmb3JlLCBpdCBpcyBub3cgcGFzc2luZyB3cnQgYnBmX21hcF9nZXRfZmRfYnlfaWQo
KSwNCj4gYnV0IHRoZW4gc3VkZGVubHkgZmFpbGluZyBkdXJpbmcgbWFwIHVwZGF0ZSBjYWxscy4N
Cg0KR29vZCBwb2ludC4NCg0KPiBJbWhvLCBpdCBtaWdodCBiZSBiZXR0ZXIgdG8gYmUgZXhwbGlj
aXQgYWJvdXQgdXNlciBpbnRlbnQgdy9vIHRoZSBsaWIgZG9pbmcNCj4gZ3Vlc3Mgd29yayB1cG9u
IGZhaWx1cmUgY2FzZXMgKC4uLiBvciBoYXZlIHRoZSBCUEYgTFNNIHNldCB0aGUgYXR0ci5vcGVu
X2ZsYWdzDQo+IHRvIEJQRl9GX1JET05MWSBmcm9tIHdpdGhpbiB0aGUgQlBGIHByb2cpLg0KDQpV
aG0sIEkgZG9uJ3QgbGlrZSB0aGF0IHRoZSB1c2VycyBzaG91bGQgYmUgYXdhcmUgb2YgcGVybWlz
c2lvbnMgYXNzaWduZWQNCnRvIG1hcHMgdGhhdCB0aGV5IGRvbid0IG93bi4NCg0KTWF5YmUsIGJl
dHRlciB0aGUgb3JpZ2luYWwgaWRlYSwgcmVxdWVzdCByZWFkLW9ubHkgcGVybWlzc2lvbiBmb3Ig
dGhlDQpsaXN0IGFuZCBkdW1wIG9wZXJhdGlvbnMuDQoNClJvYmVydG8NCg0KSFVBV0VJIFRFQ0hO
T0xPR0lFUyBEdWVzc2VsZG9yZiBHbWJILCBIUkIgNTYwNjMNCk1hbmFnaW5nIERpcmVjdG9yOiBM
aSBQZW5nLCBaaG9uZyBSb25naHVhDQo=
