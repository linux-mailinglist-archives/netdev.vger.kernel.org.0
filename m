Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4DD55A04F
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 20:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbiFXRj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 13:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232604AbiFXRj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 13:39:28 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA917C857;
        Fri, 24 Jun 2022 10:39:02 -0700 (PDT)
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LV47B4Qzqz686PB;
        Sat, 25 Jun 2022 01:36:54 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 24 Jun 2022 19:38:59 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2375.024;
 Fri, 24 Jun 2022 19:38:59 +0200
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
Thread-Index: AQHYhY1k21fgeQJHrk6eeuiL0ORSsa1aUQkAgACxApCAAeingIAAb3WAgAFNKjCAAAEDgIAAJZqA
Date:   Fri, 24 Jun 2022 17:38:59 +0000
Message-ID: <a01f79b1a3874ab796b4d3d270e53618@huawei.com>
References: <20220621163757.760304-1-roberto.sassu@huawei.com>
 <20220621163757.760304-3-roberto.sassu@huawei.com>
 <20220621223248.f6wgyewajw6x4lgr@macbook-pro-3.dhcp.thefacebook.com>
 <796b55c79be142cab6a22dd281fdb9fa@huawei.com>
 <f2d3da08e7774df9b44cc648dda7d0b8@huawei.com>
 <CAADnVQKVx9o1PcCV_F3ywJCzDTPtQG4MTKM2BmwdCwNvyxdNPg@mail.gmail.com>
 <27e25756f96548aeb56d1af5c94197f6@huawei.com>
 <CAADnVQ+PnTOK-6dE2LMsjUU_OPksX=QVxZ-QvvaxDWTw7rRR5Q@mail.gmail.com>
In-Reply-To: <CAADnVQ+PnTOK-6dE2LMsjUU_OPksX=QVxZ-QvvaxDWTw7rRR5Q@mail.gmail.com>
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
aWwuY29tXQ0KPiBTZW50OiBGcmlkYXksIEp1bmUgMjQsIDIwMjIgNjo1MCBQTQ0KPiBPbiBGcmks
IEp1biAyNCwgMjAyMiBhdCA4OjMyIEFNIFJvYmVydG8gU2Fzc3UgPHJvYmVydG8uc2Fzc3VAaHVh
d2VpLmNvbT4NCj4gd3JvdGU6DQo+ID4NCj4gPiA+IEZyb206IEFsZXhlaSBTdGFyb3ZvaXRvdiBb
bWFpbHRvOmFsZXhlaS5zdGFyb3ZvaXRvdkBnbWFpbC5jb21dDQo+ID4gPiBTZW50OiBUaHVyc2Rh
eSwgSnVuZSAyMywgMjAyMiAxMDo1NCBQTQ0KPiA+ID4gT24gVGh1LCBKdW4gMjMsIDIwMjIgYXQg
NTozNiBBTSBSb2JlcnRvIFNhc3N1DQo+IDxyb2JlcnRvLnNhc3N1QGh1YXdlaS5jb20+DQo+ID4g
PiB3cm90ZToNCj4gPiA+ID4NCj4gPiA+ID4gPiBGcm9tOiBSb2JlcnRvIFNhc3N1IFttYWlsdG86
cm9iZXJ0by5zYXNzdUBodWF3ZWkuY29tXQ0KPiA+ID4gPiA+IFNlbnQ6IFdlZG5lc2RheSwgSnVu
ZSAyMiwgMjAyMiA5OjEyIEFNDQo+ID4gPiA+ID4gPiBGcm9tOiBBbGV4ZWkgU3Rhcm92b2l0b3Yg
W21haWx0bzphbGV4ZWkuc3Rhcm92b2l0b3ZAZ21haWwuY29tXQ0KPiA+ID4gPiA+ID4gU2VudDog
V2VkbmVzZGF5LCBKdW5lIDIyLCAyMDIyIDEyOjMzIEFNDQo+ID4gPiA+ID4gPiBPbiBUdWUsIEp1
biAyMSwgMjAyMiBhdCAwNjozNzo1NFBNICswMjAwLCBSb2JlcnRvIFNhc3N1IHdyb3RlOg0KPiA+
ID4gPiA+ID4gPiBBZGQgdGhlIGJwZl9sb29rdXBfdXNlcl9rZXkoKSBhbmQgYnBmX2tleV9wdXQo
KSBoZWxwZXJzLCB0bw0KPiByZXNwZWN0aXZlbHkNCj4gPiA+ID4gPiA+ID4gc2VhcmNoIGEga2V5
IHdpdGggYSBnaXZlbiBzZXJpYWwsIGFuZCByZWxlYXNlIHRoZSByZWZlcmVuY2UgY291bnQgb2YN
Cj4gdGhlDQo+ID4gPiA+ID4gPiA+IGZvdW5kIGtleS4NCj4gPiA+ID4gPiA+ID4NCj4gPiA+ID4g
PiA+ID4gU2lnbmVkLW9mZi1ieTogUm9iZXJ0byBTYXNzdSA8cm9iZXJ0by5zYXNzdUBodWF3ZWku
Y29tPg0KPiA+ID4gPiA+ID4gPiAtLS0NCj4gPiA+ID4gPiA+ID4gIGluY2x1ZGUvdWFwaS9saW51
eC9icGYuaCAgICAgICB8IDE2ICsrKysrKysrKysrKw0KPiA+ID4gPiA+ID4gPiAga2VybmVsL2Jw
Zi9icGZfbHNtLmMgICAgICAgICAgIHwgNDYNCj4gPiA+ICsrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysNCj4gPiA+ID4gPiA+ID4gIGtlcm5lbC9icGYvdmVyaWZpZXIuYyAgICAgICAg
ICB8ICA2ICsrKy0tDQo+ID4gPiA+ID4gPiA+ICBzY3JpcHRzL2JwZl9kb2MucHkgICAgICAgICAg
ICAgfCAgMiArKw0KPiA+ID4gPiA+ID4gPiAgdG9vbHMvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5o
IHwgMTYgKysrKysrKysrKysrDQo+ID4gPiA+ID4gPiA+ICA1IGZpbGVzIGNoYW5nZWQsIDg0IGlu
c2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+ID4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiA+
IGRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmggYi9pbmNsdWRlL3VhcGkvbGlu
dXgvYnBmLmgNCj4gPiA+ID4gPiA+ID4gaW5kZXggZTgxMzYyODkxNTk2Li43YmJjZjJjZDEwNWQg
MTAwNjQ0DQo+ID4gPiA+ID4gPiA+IC0tLSBhL2luY2x1ZGUvdWFwaS9saW51eC9icGYuaA0KPiA+
ID4gPiA+ID4gPiArKysgYi9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmgNCj4gPiA+ID4gPiA+ID4g
QEAgLTUzMjUsNiArNTMyNSwyMCBAQCB1bmlvbiBicGZfYXR0ciB7DQo+ID4gPiA+ID4gPiA+ICAg
KiAgICAgICAgICAgICAgICoqLUVBQ0NFUyoqIGlmIHRoZSBTWU4gY29va2llIGlzIG5vdCB2YWxp
ZC4NCj4gPiA+ID4gPiA+ID4gICAqDQo+ID4gPiA+ID4gPiA+ICAgKiAgICAgICAgICAgICAgICoq
LUVQUk9UT05PU1VQUE9SVCoqIGlmIENPTkZJR19JUFY2IGlzIG5vdCBidWlsdGluLg0KPiA+ID4g
PiA+ID4gPiArICoNCj4gPiA+ID4gPiA+ID4gKyAqIHN0cnVjdCBrZXkgKmJwZl9sb29rdXBfdXNl
cl9rZXkodTMyIHNlcmlhbCwgdW5zaWduZWQgbG9uZyBmbGFncykNCj4gPiA+ID4gPiA+ID4gKyAq
ICAgICAgIERlc2NyaXB0aW9uDQo+ID4gPiA+ID4gPiA+ICsgKiAgICAgICAgICAgICAgIFNlYXJj
aCBhIGtleSB3aXRoIGEgZ2l2ZW4gKnNlcmlhbCogYW5kIHRoZSBwcm92aWRlZA0KPiAqZmxhZ3Mq
LA0KPiA+ID4gYW5kDQo+ID4gPiA+ID4gPiA+ICsgKiAgICAgICAgICAgICAgIGluY3JlbWVudCB0
aGUgcmVmZXJlbmNlIGNvdW50IG9mIHRoZSBrZXkuDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4g
V2h5IHBhc3NpbmcgJ2ZsYWdzJyBpcyBvayB0byBkbz8NCj4gPiA+ID4gPiA+IFBsZWFzZSB0aGlu
ayB0aHJvdWdoIGV2ZXJ5IGxpbmUgb2YgdGhlIHBhdGNoLg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4g
VG8gYmUgaG9uZXN0LCBJIHRob3VnaHQgYWJvdXQgaXQuIFByb2JhYmx5IHllcywgSSBzaG91bGQg
ZG8gc29tZQ0KPiA+ID4gPiA+IHNhbml0aXphdGlvbiwgbGlrZSBJIGRpZCBmb3IgdGhlIGtleXJp
bmcgSUQuIFdoZW4gSSBjaGVja2VkDQo+ID4gPiA+ID4gbG9va3VwX3VzZXJfa2V5KCksIEkgc2F3
IHRoYXQgZmxhZ3MgYXJlIGNoZWNrZWQgaW5kaXZpZHVhbGx5LCBzbw0KPiA+ID4gPiA+IGFuIGFy
Yml0cmFyeSB2YWx1ZSBwYXNzZWQgdG8gdGhlIGhlbHBlciBzaG91bGQgbm90IGNhdXNlIGhhcm0u
DQo+ID4gPiA+ID4gV2lsbCBkbyBzYW5pdGl6YXRpb24sIGlmIHlvdSBwcmVmZXIuIEl0IGlzIGp1
c3QgdGhhdCB3ZSBoYXZlIHRvIGtlZXANCj4gPiA+ID4gPiB0aGUgZUJQRiBjb2RlIGluIHN5bmMg
d2l0aCBrZXkgZmxhZyBkZWZpbml0aW9uICh1bmxlc3Mgd2UgaGF2ZQ0KPiA+ID4gPiA+IGEgJ2xh
c3QnIGZsYWcpLg0KPiA+ID4gPg0KPiA+ID4gPiBJJ20gbm90IHN1cmUgdGhhdCBoYXZpbmcgYSBo
ZWxwZXIgZm9yIGxvb2t1cF91c2VyX2tleSgpIGFsb25lIGlzDQo+ID4gPiA+IGNvcnJlY3QuIEJ5
IGhhdmluZyBzZXBhcmF0ZSBoZWxwZXJzIGZvciBsb29rdXAgYW5kIHVzYWdlIG9mIHRoZQ0KPiA+
ID4gPiBrZXksIG5vdGhpbmcgd291bGQgcHJldmVudCBhbiBlQlBGIHByb2dyYW0gdG8gYXNrIGZv
ciBhDQo+ID4gPiA+IHBlcm1pc3Npb24gdG8gcGFzcyB0aGUgYWNjZXNzIGNvbnRyb2wgY2hlY2ss
IGFuZCB0aGVuIHVzZSB0aGUNCj4gPiA+ID4ga2V5IGZvciBzb21ldGhpbmcgY29tcGxldGVseSBk
aWZmZXJlbnQgZnJvbSB3aGF0IGl0IHJlcXVlc3RlZC4NCj4gPiA+ID4NCj4gPiA+ID4gTG9va2lu
ZyBhdCBob3cgbG9va3VwX3VzZXJfa2V5KCkgaXMgdXNlZCBpbiBzZWN1cml0eS9rZXlzL2tleWN0
bC5jLA0KPiA+ID4gPiBpdCBzZWVtcyBjbGVhciB0aGF0IGl0IHNob3VsZCBiZSB1c2VkIHRvZ2V0
aGVyIHdpdGggdGhlIG9wZXJhdGlvbg0KPiA+ID4gPiB0aGF0IG5lZWRzIHRvIGJlIHBlcmZvcm1l
ZC4gT25seSBpbiB0aGlzIHdheSwgdGhlIGtleSBwZXJtaXNzaW9uDQo+ID4gPiA+IHdvdWxkIG1h
a2Ugc2Vuc2UuDQo+ID4gPg0KPiA+ID4gbG9va3VwIGlzIHJvdWdobHkgZXF1aXZhbGVudCB0byBv
cGVuIHdoZW4gYWxsIHBlcm1pc3Npb24gY2hlY2tzIGFyZSBkb25lLg0KPiA+ID4gQW5kIHVzaW5n
IHRoZSBrZXkgaXMgcmVhZC93cml0ZS4NCj4gPg0KPiA+IEZvciBicGZfdmVyaWZ5X3BrY3M3X3Np
Z25hdHVyZSgpLCB3ZSBuZWVkIHRoZSBzZWFyY2ggcGVybWlzc2lvbg0KPiA+IG9uIHRoZSBrZXly
aW5nIGNvbnRhaW5pbmcgdGhlIGtleSB1c2VkIGZvciBzaWduYXR1cmUgdmVyaWZpY2F0aW9uLg0K
PiANCj4geW91IG1lYW4gbG9va3VwX3VzZXJfa2V5KHNlcmlhbCwgZmxhZ3MsIEtFWV9ORUVEX1NF
QVJDSCkgPw0KPiANCj4gcmlnaHQuIGFuZCA/IHdoYXQncyB5b3VyIHBvaW50Pw0KDQpJdCBpcyBo
YXJkY29kZWQuIERvZXMgbm90IG5lY2Vzc2FyaWx5IHJlZmxlY3QgdGhlIG9wZXJhdGlvbg0KdGhh
dCB3aWxsIGJlIHBlcmZvcm1lZCBvbiB0aGUga2V5Lg0KDQpPbiB0aGUgb3RoZXIgaGFuZCwgaWYg
SSBhZGQgdGhlIHBlcm1pc3Npb24gYXMgcGFyYW1ldGVyIHRvDQpicGZfbG9va3VwX3VzZXJfa2V5
KCksIGFuIGVCUEYgcHJvZ3JhbSBjYW4gcGFzcyBhbiBhcmJpdHJhcnkNCnZhbHVlLCBhbmQgdGhl
biBkbyBzb21ldGhpbmcgY29tcGxldGVseSBkaWZmZXJlbnQgd2l0aCB0aGUga2V5Lg0KDQpSb2Jl
cnRvDQo=
