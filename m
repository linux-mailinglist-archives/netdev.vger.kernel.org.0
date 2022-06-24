Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5983C559DF0
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 18:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiFXP7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 11:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiFXP7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 11:59:40 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B15052513;
        Fri, 24 Jun 2022 08:59:38 -0700 (PDT)
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LV1tN2nTsz67T9q;
        Fri, 24 Jun 2022 23:55:40 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 24 Jun 2022 17:59:36 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2375.024;
 Fri, 24 Jun 2022 17:59:35 +0200
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
Thread-Index: AQHYhY1k21fgeQJHrk6eeuiL0ORSsa1aUQkAgACxApCAAeingIAAb3WAgAFNKjCAABQPcA==
Date:   Fri, 24 Jun 2022 15:59:35 +0000
Message-ID: <ef48c1fd292f47b6ae2ca0dcbe8c98af@huawei.com>
References: <20220621163757.760304-1-roberto.sassu@huawei.com>
 <20220621163757.760304-3-roberto.sassu@huawei.com>
 <20220621223248.f6wgyewajw6x4lgr@macbook-pro-3.dhcp.thefacebook.com>
 <796b55c79be142cab6a22dd281fdb9fa@huawei.com>
 <f2d3da08e7774df9b44cc648dda7d0b8@huawei.com>
 <CAADnVQKVx9o1PcCV_F3ywJCzDTPtQG4MTKM2BmwdCwNvyxdNPg@mail.gmail.com> 
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

PiBGcm9tOiBSb2JlcnRvIFNhc3N1DQo+IFNlbnQ6IEZyaWRheSwgSnVuZSAyNCwgMjAyMiA1OjMz
IFBNDQo+ID4gRnJvbTogQWxleGVpIFN0YXJvdm9pdG92IFttYWlsdG86YWxleGVpLnN0YXJvdm9p
dG92QGdtYWlsLmNvbV0NCj4gPiBTZW50OiBUaHVyc2RheSwgSnVuZSAyMywgMjAyMiAxMDo1NCBQ
TQ0KPiA+IE9uIFRodSwgSnVuIDIzLCAyMDIyIGF0IDU6MzYgQU0gUm9iZXJ0byBTYXNzdSA8cm9i
ZXJ0by5zYXNzdUBodWF3ZWkuY29tPg0KPiA+IHdyb3RlOg0KPiA+ID4NCj4gPiA+ID4gRnJvbTog
Um9iZXJ0byBTYXNzdSBbbWFpbHRvOnJvYmVydG8uc2Fzc3VAaHVhd2VpLmNvbV0NCj4gPiA+ID4g
U2VudDogV2VkbmVzZGF5LCBKdW5lIDIyLCAyMDIyIDk6MTIgQU0NCj4gPiA+ID4gPiBGcm9tOiBB
bGV4ZWkgU3Rhcm92b2l0b3YgW21haWx0bzphbGV4ZWkuc3Rhcm92b2l0b3ZAZ21haWwuY29tXQ0K
PiA+ID4gPiA+IFNlbnQ6IFdlZG5lc2RheSwgSnVuZSAyMiwgMjAyMiAxMjozMyBBTQ0KPiA+ID4g
PiA+IE9uIFR1ZSwgSnVuIDIxLCAyMDIyIGF0IDA2OjM3OjU0UE0gKzAyMDAsIFJvYmVydG8gU2Fz
c3Ugd3JvdGU6DQo+ID4gPiA+ID4gPiBBZGQgdGhlIGJwZl9sb29rdXBfdXNlcl9rZXkoKSBhbmQg
YnBmX2tleV9wdXQoKSBoZWxwZXJzLCB0bw0KPiByZXNwZWN0aXZlbHkNCj4gPiA+ID4gPiA+IHNl
YXJjaCBhIGtleSB3aXRoIGEgZ2l2ZW4gc2VyaWFsLCBhbmQgcmVsZWFzZSB0aGUgcmVmZXJlbmNl
IGNvdW50IG9mIHRoZQ0KPiA+ID4gPiA+ID4gZm91bmQga2V5Lg0KPiA+ID4gPiA+ID4NCj4gPiA+
ID4gPiA+IFNpZ25lZC1vZmYtYnk6IFJvYmVydG8gU2Fzc3UgPHJvYmVydG8uc2Fzc3VAaHVhd2Vp
LmNvbT4NCj4gPiA+ID4gPiA+IC0tLQ0KPiA+ID4gPiA+ID4gIGluY2x1ZGUvdWFwaS9saW51eC9i
cGYuaCAgICAgICB8IDE2ICsrKysrKysrKysrKw0KPiA+ID4gPiA+ID4gIGtlcm5lbC9icGYvYnBm
X2xzbS5jICAgICAgICAgICB8IDQ2DQo+ID4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKw0KPiA+ID4gPiA+ID4gIGtlcm5lbC9icGYvdmVyaWZpZXIuYyAgICAgICAgICB8ICA2ICsr
Ky0tDQo+ID4gPiA+ID4gPiAgc2NyaXB0cy9icGZfZG9jLnB5ICAgICAgICAgICAgIHwgIDIgKysN
Cj4gPiA+ID4gPiA+ICB0b29scy9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmggfCAxNiArKysrKysr
KysrKysNCj4gPiA+ID4gPiA+ICA1IGZpbGVzIGNoYW5nZWQsIDg0IGluc2VydGlvbnMoKyksIDIg
ZGVsZXRpb25zKC0pDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gZGlmZiAtLWdpdCBhL2luY2x1
ZGUvdWFwaS9saW51eC9icGYuaCBiL2luY2x1ZGUvdWFwaS9saW51eC9icGYuaA0KPiA+ID4gPiA+
ID4gaW5kZXggZTgxMzYyODkxNTk2Li43YmJjZjJjZDEwNWQgMTAwNjQ0DQo+ID4gPiA+ID4gPiAt
LS0gYS9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmgNCj4gPiA+ID4gPiA+ICsrKyBiL2luY2x1ZGUv
dWFwaS9saW51eC9icGYuaA0KPiA+ID4gPiA+ID4gQEAgLTUzMjUsNiArNTMyNSwyMCBAQCB1bmlv
biBicGZfYXR0ciB7DQo+ID4gPiA+ID4gPiAgICogICAgICAgICAgICAgICAqKi1FQUNDRVMqKiBp
ZiB0aGUgU1lOIGNvb2tpZSBpcyBub3QgdmFsaWQuDQo+ID4gPiA+ID4gPiAgICoNCj4gPiA+ID4g
PiA+ICAgKiAgICAgICAgICAgICAgICoqLUVQUk9UT05PU1VQUE9SVCoqIGlmIENPTkZJR19JUFY2
IGlzIG5vdCBidWlsdGluLg0KPiA+ID4gPiA+ID4gKyAqDQo+ID4gPiA+ID4gPiArICogc3RydWN0
IGtleSAqYnBmX2xvb2t1cF91c2VyX2tleSh1MzIgc2VyaWFsLCB1bnNpZ25lZCBsb25nIGZsYWdz
KQ0KPiA+ID4gPiA+ID4gKyAqICAgICAgIERlc2NyaXB0aW9uDQo+ID4gPiA+ID4gPiArICogICAg
ICAgICAgICAgICBTZWFyY2ggYSBrZXkgd2l0aCBhIGdpdmVuICpzZXJpYWwqIGFuZCB0aGUgcHJv
dmlkZWQgKmZsYWdzKiwNCj4gPiBhbmQNCj4gPiA+ID4gPiA+ICsgKiAgICAgICAgICAgICAgIGlu
Y3JlbWVudCB0aGUgcmVmZXJlbmNlIGNvdW50IG9mIHRoZSBrZXkuDQo+ID4gPiA+ID4NCj4gPiA+
ID4gPiBXaHkgcGFzc2luZyAnZmxhZ3MnIGlzIG9rIHRvIGRvPw0KPiA+ID4gPiA+IFBsZWFzZSB0
aGluayB0aHJvdWdoIGV2ZXJ5IGxpbmUgb2YgdGhlIHBhdGNoLg0KPiA+ID4gPg0KPiA+ID4gPiBU
byBiZSBob25lc3QsIEkgdGhvdWdodCBhYm91dCBpdC4gUHJvYmFibHkgeWVzLCBJIHNob3VsZCBk
byBzb21lDQo+ID4gPiA+IHNhbml0aXphdGlvbiwgbGlrZSBJIGRpZCBmb3IgdGhlIGtleXJpbmcg
SUQuIFdoZW4gSSBjaGVja2VkDQo+ID4gPiA+IGxvb2t1cF91c2VyX2tleSgpLCBJIHNhdyB0aGF0
IGZsYWdzIGFyZSBjaGVja2VkIGluZGl2aWR1YWxseSwgc28NCj4gPiA+ID4gYW4gYXJiaXRyYXJ5
IHZhbHVlIHBhc3NlZCB0byB0aGUgaGVscGVyIHNob3VsZCBub3QgY2F1c2UgaGFybS4NCj4gPiA+
ID4gV2lsbCBkbyBzYW5pdGl6YXRpb24sIGlmIHlvdSBwcmVmZXIuIEl0IGlzIGp1c3QgdGhhdCB3
ZSBoYXZlIHRvIGtlZXANCj4gPiA+ID4gdGhlIGVCUEYgY29kZSBpbiBzeW5jIHdpdGgga2V5IGZs
YWcgZGVmaW5pdGlvbiAodW5sZXNzIHdlIGhhdmUNCj4gPiA+ID4gYSAnbGFzdCcgZmxhZykuDQo+
ID4gPg0KPiA+ID4gSSdtIG5vdCBzdXJlIHRoYXQgaGF2aW5nIGEgaGVscGVyIGZvciBsb29rdXBf
dXNlcl9rZXkoKSBhbG9uZSBpcw0KPiA+ID4gY29ycmVjdC4gQnkgaGF2aW5nIHNlcGFyYXRlIGhl
bHBlcnMgZm9yIGxvb2t1cCBhbmQgdXNhZ2Ugb2YgdGhlDQo+ID4gPiBrZXksIG5vdGhpbmcgd291
bGQgcHJldmVudCBhbiBlQlBGIHByb2dyYW0gdG8gYXNrIGZvciBhDQo+ID4gPiBwZXJtaXNzaW9u
IHRvIHBhc3MgdGhlIGFjY2VzcyBjb250cm9sIGNoZWNrLCBhbmQgdGhlbiB1c2UgdGhlDQo+ID4g
PiBrZXkgZm9yIHNvbWV0aGluZyBjb21wbGV0ZWx5IGRpZmZlcmVudCBmcm9tIHdoYXQgaXQgcmVx
dWVzdGVkLg0KPiA+ID4NCj4gPiA+IExvb2tpbmcgYXQgaG93IGxvb2t1cF91c2VyX2tleSgpIGlz
IHVzZWQgaW4gc2VjdXJpdHkva2V5cy9rZXljdGwuYywNCj4gPiA+IGl0IHNlZW1zIGNsZWFyIHRo
YXQgaXQgc2hvdWxkIGJlIHVzZWQgdG9nZXRoZXIgd2l0aCB0aGUgb3BlcmF0aW9uDQo+ID4gPiB0
aGF0IG5lZWRzIHRvIGJlIHBlcmZvcm1lZC4gT25seSBpbiB0aGlzIHdheSwgdGhlIGtleSBwZXJt
aXNzaW9uDQo+ID4gPiB3b3VsZCBtYWtlIHNlbnNlLg0KPiA+DQo+ID4gbG9va3VwIGlzIHJvdWdo
bHkgZXF1aXZhbGVudCB0byBvcGVuIHdoZW4gYWxsIHBlcm1pc3Npb24gY2hlY2tzIGFyZSBkb25l
Lg0KPiA+IEFuZCB1c2luZyB0aGUga2V5IGlzIHJlYWQvd3JpdGUuDQo+IA0KPiBGb3IgYnBmX3Zl
cmlmeV9wa2NzN19zaWduYXR1cmUoKSwgd2UgbmVlZCB0aGUgc2VhcmNoIHBlcm1pc3Npb24NCj4g
b24gdGhlIGtleXJpbmcgY29udGFpbmluZyB0aGUga2V5IHVzZWQgZm9yIHNpZ25hdHVyZSB2ZXJp
ZmljYXRpb24uDQo+IA0KPiBUaGFua3MNCj4gDQo+IFJvYmVydG8NCj4gDQo+IChJIHdhcyBub3Qg
dG9sZCBvdGhlcndpc2UsIEkgdXNlIG15IGNvcnBvcmF0ZSBlbWFpbCB0byBzZW5kDQo+IHdvcmsg
dG8gb3V0c2lkZSwgc28gSSBoYXZlIHRvIGtlZXAgdGhlIG5vdGljZSkJDQoNCkkgY2FuIHJlbW92
ZSBpdC4gSnVzdCB0byBsZXQgeW91IGtub3cuDQoNClJvYmVydG8NCg==
