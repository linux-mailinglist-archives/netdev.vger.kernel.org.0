Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68CDF587A62
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 12:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236497AbiHBKMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 06:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233387AbiHBKMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 06:12:07 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CACE4B0F9;
        Tue,  2 Aug 2022 03:12:06 -0700 (PDT)
Received: from fraeml710-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LxrJK1LVNz67gb0;
        Tue,  2 Aug 2022 18:07:13 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml710-chm.china.huawei.com (10.206.15.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 2 Aug 2022 12:12:04 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2375.024;
 Tue, 2 Aug 2022 12:12:04 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Hao Luo <haoluo@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        KP Singh <kpsingh@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Michal Koutny <mkoutny@suse.com>,
        "Roman Gushchin" <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Yosry Ahmed <yosryahmed@google.com>
Subject: RE: [PATCH bpf-next v6 1/8] btf: Add a new kfunc flag which allows to
 mark a function to be sleepable
Thread-Topic: [PATCH bpf-next v6 1/8] btf: Add a new kfunc flag which allows
 to mark a function to be sleepable
Thread-Index: AQHYpc/QHd6pQm3GSkK+4jcMX6ARwK2bZJZw
Date:   Tue, 2 Aug 2022 10:12:04 +0000
Message-ID: <8924d019684340ecb2f6c9e3e99a5287@huawei.com>
References: <20220801175407.2647869-1-haoluo@google.com>
 <20220801175407.2647869-2-haoluo@google.com>
In-Reply-To: <20220801175407.2647869-2-haoluo@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.81.210.42]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBIYW8gTHVvIFttYWlsdG86aGFvbHVvQGdvb2dsZS5jb21dDQo+IFNlbnQ6IE1vbmRh
eSwgQXVndXN0IDEsIDIwMjIgNzo1NCBQTQ0KPiBGcm9tOiBCZW5qYW1pbiBUaXNzb2lyZXMgPGJl
bmphbWluLnRpc3NvaXJlc0ByZWRoYXQuY29tPg0KPiANCj4gRnJvbTogQmVuamFtaW4gVGlzc29p
cmVzIDxiZW5qYW1pbi50aXNzb2lyZXNAcmVkaGF0LmNvbT4NCj4gDQo+IFRoaXMgYWxsb3dzIHRv
IGRlY2xhcmUgYSBrZnVuYyBhcyBzbGVlcGFibGUgYW5kIHByZXZlbnRzIGl0cyB1c2UgaW4NCj4g
YSBub24gc2xlZXBhYmxlIHByb2dyYW0uDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBCZW5qYW1pbiBU
aXNzb2lyZXMgPGJlbmphbWluLnRpc3NvaXJlc0ByZWRoYXQuY29tPg0KPiBDby1kZXZlbG9wZWQt
Ynk6IFlvc3J5IEFobWVkIDx5b3NyeWFobWVkQGdvb2dsZS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6
IFlvc3J5IEFobWVkIDx5b3NyeWFobWVkQGdvb2dsZS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEhh
byBMdW8gPGhhb2x1b0Bnb29nbGUuY29tPg0KDQpUaGFua3MsIGhlbHBmdWwgYWxzbyBmb3IgbWUu
DQoNClJldmlld2VkLWJ5OiBSb2JlcnRvIFNhc3N1IDxyb2JlcnRvLnNhc3N1QGh1YXdlaS5jb20+
DQoNClJvYmVydG8NCg0KPiAtLS0NCj4gIERvY3VtZW50YXRpb24vYnBmL2tmdW5jcy5yc3QgfCA2
ICsrKysrKw0KPiAgaW5jbHVkZS9saW51eC9idGYuaCAgICAgICAgICB8IDEgKw0KPiAga2VybmVs
L2JwZi9idGYuYyAgICAgICAgICAgICB8IDkgKysrKysrKysrDQo+ICAzIGZpbGVzIGNoYW5nZWQs
IDE2IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2JwZi9r
ZnVuY3MucnN0IGIvRG9jdW1lbnRhdGlvbi9icGYva2Z1bmNzLnJzdA0KPiBpbmRleCBjMGI3ZGFl
NmRiZjUuLmM4YjIxZGUxYzc3MiAxMDA2NDQNCj4gLS0tIGEvRG9jdW1lbnRhdGlvbi9icGYva2Z1
bmNzLnJzdA0KPiArKysgYi9Eb2N1bWVudGF0aW9uL2JwZi9rZnVuY3MucnN0DQo+IEBAIC0xNDYs
NiArMTQ2LDEyIEBAIHRoYXQgb3BlcmF0ZSAoY2hhbmdlIHNvbWUgcHJvcGVydHksIHBlcmZvcm0g
c29tZQ0KPiBvcGVyYXRpb24pIG9uIGFuIG9iamVjdCB0aGF0DQo+ICB3YXMgb2J0YWluZWQgdXNp
bmcgYW4gYWNxdWlyZSBrZnVuYy4gU3VjaCBrZnVuY3MgbmVlZCBhbiB1bmNoYW5nZWQgcG9pbnRl
ciB0bw0KPiAgZW5zdXJlIHRoZSBpbnRlZ3JpdHkgb2YgdGhlIG9wZXJhdGlvbiBiZWluZyBwZXJm
b3JtZWQgb24gdGhlIGV4cGVjdGVkIG9iamVjdC4NCj4gDQo+ICsyLjQuNiBLRl9TTEVFUEFCTEUg
ZmxhZw0KPiArLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gKw0KPiArVGhlIEtGX1NMRUVQQUJM
RSBmbGFnIGlzIHVzZWQgZm9yIGtmdW5jcyB0aGF0IG1heSBzbGVlcC4gU3VjaCBrZnVuY3MgY2Fu
IG9ubHkNCj4gK2JlIGNhbGxlZCBieSBzbGVlcGFibGUgQlBGIHByb2dyYW1zIChCUEZfRl9TTEVF
UEFCTEUpLg0KPiArDQo+ICAyLjUgUmVnaXN0ZXJpbmcgdGhlIGtmdW5jcw0KPiAgLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0NCj4gDQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2J0Zi5o
IGIvaW5jbHVkZS9saW51eC9idGYuaA0KPiBpbmRleCBjZGIzNzZkNTMyMzguLjk3NmNiZGQyOTgx
ZiAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS9saW51eC9idGYuaA0KPiArKysgYi9pbmNsdWRlL2xp
bnV4L2J0Zi5oDQo+IEBAIC00OSw2ICs0OSw3IEBADQo+ICAgKiBmb3IgdGhpcyBjYXNlLg0KPiAg
ICovDQo+ICAjZGVmaW5lIEtGX1RSVVNURURfQVJHUyAoMSA8PCA0KSAvKiBrZnVuYyBvbmx5IHRh
a2VzIHRydXN0ZWQgcG9pbnRlcg0KPiBhcmd1bWVudHMgKi8NCj4gKyNkZWZpbmUgS0ZfU0xFRVBB
QkxFICAgKDEgPDwgNSkgLyoga2Z1bmMgbWF5IHNsZWVwICovDQo+IA0KPiAgc3RydWN0IGJ0ZjsN
Cj4gIHN0cnVjdCBidGZfbWVtYmVyOw0KPiBkaWZmIC0tZ2l0IGEva2VybmVsL2JwZi9idGYuYyBi
L2tlcm5lbC9icGYvYnRmLmMNCj4gaW5kZXggN2U2NDQ0NzY1OWYzLi5kM2U0Yzg2YjhmY2QgMTAw
NjQ0DQo+IC0tLSBhL2tlcm5lbC9icGYvYnRmLmMNCj4gKysrIGIva2VybmVsL2JwZi9idGYuYw0K
PiBAQCAtNjE3NSw2ICs2MTc1LDcgQEAgc3RhdGljIGludCBidGZfY2hlY2tfZnVuY19hcmdfbWF0
Y2goc3RydWN0DQo+IGJwZl92ZXJpZmllcl9lbnYgKmVudiwNCj4gIHsNCj4gIAllbnVtIGJwZl9w
cm9nX3R5cGUgcHJvZ190eXBlID0gcmVzb2x2ZV9wcm9nX3R5cGUoZW52LT5wcm9nKTsNCj4gIAli
b29sIHJlbCA9IGZhbHNlLCBrcHRyX2dldCA9IGZhbHNlLCB0cnVzdGVkX2FyZyA9IGZhbHNlOw0K
PiArCWJvb2wgc2xlZXBhYmxlID0gZmFsc2U7DQo+ICAJc3RydWN0IGJwZl92ZXJpZmllcl9sb2cg
KmxvZyA9ICZlbnYtPmxvZzsNCj4gIAl1MzIgaSwgbmFyZ3MsIHJlZl9pZCwgcmVmX29ial9pZCA9
IDA7DQo+ICAJYm9vbCBpc19rZnVuYyA9IGJ0Zl9pc19rZXJuZWwoYnRmKTsNCj4gQEAgLTYyMTIs
NiArNjIxMyw3IEBAIHN0YXRpYyBpbnQgYnRmX2NoZWNrX2Z1bmNfYXJnX21hdGNoKHN0cnVjdA0K
PiBicGZfdmVyaWZpZXJfZW52ICplbnYsDQo+ICAJCXJlbCA9IGtmdW5jX2ZsYWdzICYgS0ZfUkVM
RUFTRTsNCj4gIAkJa3B0cl9nZXQgPSBrZnVuY19mbGFncyAmIEtGX0tQVFJfR0VUOw0KPiAgCQl0
cnVzdGVkX2FyZyA9IGtmdW5jX2ZsYWdzICYgS0ZfVFJVU1RFRF9BUkdTOw0KPiArCQlzbGVlcGFi
bGUgPSBrZnVuY19mbGFncyAmIEtGX1NMRUVQQUJMRTsNCj4gIAl9DQo+IA0KPiAgCS8qIGNoZWNr
IHRoYXQgQlRGIGZ1bmN0aW9uIGFyZ3VtZW50cyBtYXRjaCBhY3R1YWwgdHlwZXMgdGhhdCB0aGUN
Cj4gQEAgLTY0MTksNiArNjQyMSwxMyBAQCBzdGF0aWMgaW50IGJ0Zl9jaGVja19mdW5jX2FyZ19t
YXRjaChzdHJ1Y3QNCj4gYnBmX3ZlcmlmaWVyX2VudiAqZW52LA0KPiAgCQkJZnVuY19uYW1lKTsN
Cj4gIAkJcmV0dXJuIC1FSU5WQUw7DQo+ICAJfQ0KPiArDQo+ICsJaWYgKHNsZWVwYWJsZSAmJiAh
ZW52LT5wcm9nLT5hdXgtPnNsZWVwYWJsZSkgew0KPiArCQlicGZfbG9nKGxvZywgImtlcm5lbCBm
dW5jdGlvbiAlcyBpcyBzbGVlcGFibGUgYnV0IHRoZSBwcm9ncmFtIGlzDQo+IG5vdFxuIiwNCj4g
KwkJCWZ1bmNfbmFtZSk7DQo+ICsJCXJldHVybiAtRUlOVkFMOw0KPiArCX0NCj4gKw0KPiAgCS8q
IHJldHVybnMgYXJndW1lbnQgcmVnaXN0ZXIgbnVtYmVyID4gMCBpbiBjYXNlIG9mIHJlZmVyZW5j
ZSByZWxlYXNlDQo+IGtmdW5jICovDQo+ICAJcmV0dXJuIHJlbCA/IHJlZl9yZWdubyA6IDA7DQo+
ICB9DQo+IC0tDQo+IDIuMzcuMS40NTUuZzAwODUxOGI0ZTUtZ29vZw0KDQo=
