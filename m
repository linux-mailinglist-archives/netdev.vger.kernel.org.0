Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2755C559D6B
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 17:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbiFXPcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 11:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbiFXPci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 11:32:38 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA57F517D0;
        Fri, 24 Jun 2022 08:32:35 -0700 (PDT)
Received: from fraeml709-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LV1KJ1zLSz687Z8;
        Fri, 24 Jun 2022 23:30:28 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml709-chm.china.huawei.com (10.206.15.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 24 Jun 2022 17:32:33 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2375.024;
 Fri, 24 Jun 2022 17:32:33 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "kafai@fb.com" <kafai@fb.com>, "yhs@fb.com" <yhs@fb.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v5 2/5] bpf: Add bpf_lookup_user_key() and bpf_key_put()
 helpers
Thread-Topic: [PATCH v5 2/5] bpf: Add bpf_lookup_user_key() and bpf_key_put()
 helpers
Thread-Index: AQHYhY1k21fgeQJHrk6eeuiL0ORSsa1aUQkAgACxApCAAeingIAAb3WAgAFNKjA=
Date:   Fri, 24 Jun 2022 15:32:33 +0000
Message-ID: <27e25756f96548aeb56d1af5c94197f6@huawei.com>
References: <20220621163757.760304-1-roberto.sassu@huawei.com>
 <20220621163757.760304-3-roberto.sassu@huawei.com>
 <20220621223248.f6wgyewajw6x4lgr@macbook-pro-3.dhcp.thefacebook.com>
 <796b55c79be142cab6a22dd281fdb9fa@huawei.com>
 <f2d3da08e7774df9b44cc648dda7d0b8@huawei.com>
 <CAADnVQKVx9o1PcCV_F3ywJCzDTPtQG4MTKM2BmwdCwNvyxdNPg@mail.gmail.com>
In-Reply-To: <CAADnVQKVx9o1PcCV_F3ywJCzDTPtQG4MTKM2BmwdCwNvyxdNPg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.221.98.153]
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

PiBGcm9tOiBBbGV4ZWkgU3Rhcm92b2l0b3YgW21haWx0bzphbGV4ZWkuc3Rhcm92b2l0b3ZAZ21h
aWwuY29tXQ0KPiBTZW50OiBUaHVyc2RheSwgSnVuZSAyMywgMjAyMiAxMDo1NCBQTQ0KPiBPbiBU
aHUsIEp1biAyMywgMjAyMiBhdCA1OjM2IEFNIFJvYmVydG8gU2Fzc3UgPHJvYmVydG8uc2Fzc3VA
aHVhd2VpLmNvbT4NCj4gd3JvdGU6DQo+ID4NCj4gPiA+IEZyb206IFJvYmVydG8gU2Fzc3UgW21h
aWx0bzpyb2JlcnRvLnNhc3N1QGh1YXdlaS5jb21dDQo+ID4gPiBTZW50OiBXZWRuZXNkYXksIEp1
bmUgMjIsIDIwMjIgOToxMiBBTQ0KPiA+ID4gPiBGcm9tOiBBbGV4ZWkgU3Rhcm92b2l0b3YgW21h
aWx0bzphbGV4ZWkuc3Rhcm92b2l0b3ZAZ21haWwuY29tXQ0KPiA+ID4gPiBTZW50OiBXZWRuZXNk
YXksIEp1bmUgMjIsIDIwMjIgMTI6MzMgQU0NCj4gPiA+ID4gT24gVHVlLCBKdW4gMjEsIDIwMjIg
YXQgMDY6Mzc6NTRQTSArMDIwMCwgUm9iZXJ0byBTYXNzdSB3cm90ZToNCj4gPiA+ID4gPiBBZGQg
dGhlIGJwZl9sb29rdXBfdXNlcl9rZXkoKSBhbmQgYnBmX2tleV9wdXQoKSBoZWxwZXJzLCB0byBy
ZXNwZWN0aXZlbHkNCj4gPiA+ID4gPiBzZWFyY2ggYSBrZXkgd2l0aCBhIGdpdmVuIHNlcmlhbCwg
YW5kIHJlbGVhc2UgdGhlIHJlZmVyZW5jZSBjb3VudCBvZiB0aGUNCj4gPiA+ID4gPiBmb3VuZCBr
ZXkuDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBTaWduZWQtb2ZmLWJ5OiBSb2JlcnRvIFNhc3N1IDxy
b2JlcnRvLnNhc3N1QGh1YXdlaS5jb20+DQo+ID4gPiA+ID4gLS0tDQo+ID4gPiA+ID4gIGluY2x1
ZGUvdWFwaS9saW51eC9icGYuaCAgICAgICB8IDE2ICsrKysrKysrKysrKw0KPiA+ID4gPiA+ICBr
ZXJuZWwvYnBmL2JwZl9sc20uYyAgICAgICAgICAgfCA0Ng0KPiArKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrDQo+ID4gPiA+ID4gIGtlcm5lbC9icGYvdmVyaWZpZXIuYyAgICAgICAg
ICB8ICA2ICsrKy0tDQo+ID4gPiA+ID4gIHNjcmlwdHMvYnBmX2RvYy5weSAgICAgICAgICAgICB8
ICAyICsrDQo+ID4gPiA+ID4gIHRvb2xzL2luY2x1ZGUvdWFwaS9saW51eC9icGYuaCB8IDE2ICsr
KysrKysrKysrKw0KPiA+ID4gPiA+ICA1IGZpbGVzIGNoYW5nZWQsIDg0IGluc2VydGlvbnMoKyks
IDIgZGVsZXRpb25zKC0pDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVk
ZS91YXBpL2xpbnV4L2JwZi5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oDQo+ID4gPiA+ID4g
aW5kZXggZTgxMzYyODkxNTk2Li43YmJjZjJjZDEwNWQgMTAwNjQ0DQo+ID4gPiA+ID4gLS0tIGEv
aW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oDQo+ID4gPiA+ID4gKysrIGIvaW5jbHVkZS91YXBpL2xp
bnV4L2JwZi5oDQo+ID4gPiA+ID4gQEAgLTUzMjUsNiArNTMyNSwyMCBAQCB1bmlvbiBicGZfYXR0
ciB7DQo+ID4gPiA+ID4gICAqICAgICAgICAgICAgICAgKiotRUFDQ0VTKiogaWYgdGhlIFNZTiBj
b29raWUgaXMgbm90IHZhbGlkLg0KPiA+ID4gPiA+ICAgKg0KPiA+ID4gPiA+ICAgKiAgICAgICAg
ICAgICAgICoqLUVQUk9UT05PU1VQUE9SVCoqIGlmIENPTkZJR19JUFY2IGlzIG5vdCBidWlsdGlu
Lg0KPiA+ID4gPiA+ICsgKg0KPiA+ID4gPiA+ICsgKiBzdHJ1Y3Qga2V5ICpicGZfbG9va3VwX3Vz
ZXJfa2V5KHUzMiBzZXJpYWwsIHVuc2lnbmVkIGxvbmcgZmxhZ3MpDQo+ID4gPiA+ID4gKyAqICAg
ICAgIERlc2NyaXB0aW9uDQo+ID4gPiA+ID4gKyAqICAgICAgICAgICAgICAgU2VhcmNoIGEga2V5
IHdpdGggYSBnaXZlbiAqc2VyaWFsKiBhbmQgdGhlIHByb3ZpZGVkICpmbGFncyosDQo+IGFuZA0K
PiA+ID4gPiA+ICsgKiAgICAgICAgICAgICAgIGluY3JlbWVudCB0aGUgcmVmZXJlbmNlIGNvdW50
IG9mIHRoZSBrZXkuDQo+ID4gPiA+DQo+ID4gPiA+IFdoeSBwYXNzaW5nICdmbGFncycgaXMgb2sg
dG8gZG8/DQo+ID4gPiA+IFBsZWFzZSB0aGluayB0aHJvdWdoIGV2ZXJ5IGxpbmUgb2YgdGhlIHBh
dGNoLg0KPiA+ID4NCj4gPiA+IFRvIGJlIGhvbmVzdCwgSSB0aG91Z2h0IGFib3V0IGl0LiBQcm9i
YWJseSB5ZXMsIEkgc2hvdWxkIGRvIHNvbWUNCj4gPiA+IHNhbml0aXphdGlvbiwgbGlrZSBJIGRp
ZCBmb3IgdGhlIGtleXJpbmcgSUQuIFdoZW4gSSBjaGVja2VkDQo+ID4gPiBsb29rdXBfdXNlcl9r
ZXkoKSwgSSBzYXcgdGhhdCBmbGFncyBhcmUgY2hlY2tlZCBpbmRpdmlkdWFsbHksIHNvDQo+ID4g
PiBhbiBhcmJpdHJhcnkgdmFsdWUgcGFzc2VkIHRvIHRoZSBoZWxwZXIgc2hvdWxkIG5vdCBjYXVz
ZSBoYXJtLg0KPiA+ID4gV2lsbCBkbyBzYW5pdGl6YXRpb24sIGlmIHlvdSBwcmVmZXIuIEl0IGlz
IGp1c3QgdGhhdCB3ZSBoYXZlIHRvIGtlZXANCj4gPiA+IHRoZSBlQlBGIGNvZGUgaW4gc3luYyB3
aXRoIGtleSBmbGFnIGRlZmluaXRpb24gKHVubGVzcyB3ZSBoYXZlDQo+ID4gPiBhICdsYXN0JyBm
bGFnKS4NCj4gPg0KPiA+IEknbSBub3Qgc3VyZSB0aGF0IGhhdmluZyBhIGhlbHBlciBmb3IgbG9v
a3VwX3VzZXJfa2V5KCkgYWxvbmUgaXMNCj4gPiBjb3JyZWN0LiBCeSBoYXZpbmcgc2VwYXJhdGUg
aGVscGVycyBmb3IgbG9va3VwIGFuZCB1c2FnZSBvZiB0aGUNCj4gPiBrZXksIG5vdGhpbmcgd291
bGQgcHJldmVudCBhbiBlQlBGIHByb2dyYW0gdG8gYXNrIGZvciBhDQo+ID4gcGVybWlzc2lvbiB0
byBwYXNzIHRoZSBhY2Nlc3MgY29udHJvbCBjaGVjaywgYW5kIHRoZW4gdXNlIHRoZQ0KPiA+IGtl
eSBmb3Igc29tZXRoaW5nIGNvbXBsZXRlbHkgZGlmZmVyZW50IGZyb20gd2hhdCBpdCByZXF1ZXN0
ZWQuDQo+ID4NCj4gPiBMb29raW5nIGF0IGhvdyBsb29rdXBfdXNlcl9rZXkoKSBpcyB1c2VkIGlu
IHNlY3VyaXR5L2tleXMva2V5Y3RsLmMsDQo+ID4gaXQgc2VlbXMgY2xlYXIgdGhhdCBpdCBzaG91
bGQgYmUgdXNlZCB0b2dldGhlciB3aXRoIHRoZSBvcGVyYXRpb24NCj4gPiB0aGF0IG5lZWRzIHRv
IGJlIHBlcmZvcm1lZC4gT25seSBpbiB0aGlzIHdheSwgdGhlIGtleSBwZXJtaXNzaW9uDQo+ID4g
d291bGQgbWFrZSBzZW5zZS4NCj4gDQo+IGxvb2t1cCBpcyByb3VnaGx5IGVxdWl2YWxlbnQgdG8g
b3BlbiB3aGVuIGFsbCBwZXJtaXNzaW9uIGNoZWNrcyBhcmUgZG9uZS4NCj4gQW5kIHVzaW5nIHRo
ZSBrZXkgaXMgcmVhZC93cml0ZS4NCg0KRm9yIGJwZl92ZXJpZnlfcGtjczdfc2lnbmF0dXJlKCks
IHdlIG5lZWQgdGhlIHNlYXJjaCBwZXJtaXNzaW9uDQpvbiB0aGUga2V5cmluZyBjb250YWluaW5n
IHRoZSBrZXkgdXNlZCBmb3Igc2lnbmF0dXJlIHZlcmlmaWNhdGlvbi4NCg0KVGhhbmtzDQoNClJv
YmVydG8NCg0KKEkgd2FzIG5vdCB0b2xkIG90aGVyd2lzZSwgSSB1c2UgbXkgY29ycG9yYXRlIGVt
YWlsIHRvIHNlbmQNCndvcmsgdG8gb3V0c2lkZSwgc28gSSBoYXZlIHRvIGtlZXAgdGhlIG5vdGlj
ZSkNCg0KSFVBV0VJIFRFQ0hOT0xPR0lFUyBEdWVzc2VsZG9yZiBHbWJILCBIUkIgNTYwNjMNCk1h
bmFnaW5nIERpcmVjdG9yOiBMaSBQZW5nLCBZYW5nIFhpLCBMaSBIZQ0K
