Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA4535813B2
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 14:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbiGZM6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 08:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbiGZM6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 08:58:37 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49DB25C78;
        Tue, 26 Jul 2022 05:58:35 -0700 (PDT)
Received: from fraeml708-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LscNv1f6hz6HHxp;
        Tue, 26 Jul 2022 20:56:31 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml708-chm.china.huawei.com (10.206.15.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Jul 2022 14:58:33 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2375.024;
 Tue, 26 Jul 2022 14:58:33 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "Florian Westphal" <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "Lorenzo Bianconi" <lorenzo@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: RE: [PATCH bpf-next v7 04/13] bpf: Add support for forcing kfunc args
 to be trusted
Thread-Topic: [PATCH bpf-next v7 04/13] bpf: Add support for forcing kfunc
 args to be trusted
Thread-Index: AQHYnQf5YGGK69PM90+FORw5bILjSq2O3aiggAFrZ4CAACjgMIAAEHYAgAAiMbA=
Date:   Tue, 26 Jul 2022 12:58:33 +0000
Message-ID: <afabc18be104482ba5464817ac4f8729@huawei.com>
References: <20220721134245.2450-1-memxor@gmail.com>
 <20220721134245.2450-5-memxor@gmail.com>
 <64f5b92546c14b69a20e9007bb31146b@huawei.com>
 <CAP01T7683DcToXdYPPZ5gQxiksuJRyrf_=k8PvQGtwNXt0+S-w@mail.gmail.com>
 <e612d596b547456797dfee98f23bbd62@huawei.com>
 <CAP01T74s8E0-60ZtviLcTDR8sY3hUsAiTc2oTii_i4XeW3J2xw@mail.gmail.com>
In-Reply-To: <CAP01T74s8E0-60ZtviLcTDR8sY3hUsAiTc2oTii_i4XeW3J2xw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.221.98.153]
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

PiBGcm9tOiBLdW1hciBLYXJ0aWtleWEgRHdpdmVkaSBbbWFpbHRvOm1lbXhvckBnbWFpbC5jb21d
DQo+IFNlbnQ6IFR1ZXNkYXksIEp1bHkgMjYsIDIwMjIgMjo1NiBQTQ0KPiBPbiBUdWUsIDI2IEp1
bCAyMDIyIGF0IDEyOjAyLCBSb2JlcnRvIFNhc3N1IDxyb2JlcnRvLnNhc3N1QGh1YXdlaS5jb20+
DQo+IHdyb3RlOg0KPiA+DQo+ID4gPiBGcm9tOiBLdW1hciBLYXJ0aWtleWEgRHdpdmVkaSBbbWFp
bHRvOm1lbXhvckBnbWFpbC5jb21dDQo+ID4gPiBTZW50OiBUdWVzZGF5LCBKdWx5IDI2LCAyMDIy
IDExOjMwIEFNDQo+ID4gPiBPbiBNb24sIDI1IEp1bCAyMDIyIGF0IDExOjUyLCBSb2JlcnRvIFNh
c3N1IDxyb2JlcnRvLnNhc3N1QGh1YXdlaS5jb20+DQo+ID4gPiB3cm90ZToNCj4gPiA+ID4NCj4g
PiA+ID4gPiBGcm9tOiBLdW1hciBLYXJ0aWtleWEgRHdpdmVkaSBbbWFpbHRvOm1lbXhvckBnbWFp
bC5jb21dDQo+ID4gPiA+ID4gU2VudDogVGh1cnNkYXksIEp1bHkgMjEsIDIwMjIgMzo0MyBQTQ0K
PiA+ID4gPiA+IFRlYWNoIHRoZSB2ZXJpZmllciB0byBkZXRlY3QgYSBuZXcgS0ZfVFJVU1RFRF9B
UkdTIGtmdW5jIGZsYWcsIHdoaWNoDQo+ID4gPiA+ID4gbWVhbnMgZWFjaCBwb2ludGVyIGFyZ3Vt
ZW50IG11c3QgYmUgdHJ1c3RlZCwgd2hpY2ggd2UgZGVmaW5lIGFzIGENCj4gPiA+ID4gPiBwb2lu
dGVyIHRoYXQgaXMgcmVmZXJlbmNlZCAoaGFzIG5vbi16ZXJvIHJlZl9vYmpfaWQpIGFuZCBhbHNv
IG5lZWRzIHRvDQo+ID4gPiA+ID4gaGF2ZSBpdHMgb2Zmc2V0IHVuY2hhbmdlZCwgc2ltaWxhciB0
byBob3cgcmVsZWFzZSBmdW5jdGlvbnMgZXhwZWN0IHRoZWlyDQo+ID4gPiA+ID4gYXJndW1lbnQu
IFRoaXMgYWxsb3dzIGEga2Z1bmMgdG8gcmVjZWl2ZSBwb2ludGVyIGFyZ3VtZW50cyB1bmNoYW5n
ZWQNCj4gPiA+ID4gPiBmcm9tIHRoZSByZXN1bHQgb2YgdGhlIGFjcXVpcmUga2Z1bmMuDQo+ID4g
PiA+ID4NCj4gPiA+ID4gPiBUaGlzIGlzIHJlcXVpcmVkIHRvIGVuc3VyZSB0aGF0IGtmdW5jIHRo
YXQgb3BlcmF0ZSBvbiBzb21lIG9iamVjdCBvbmx5DQo+ID4gPiA+ID4gd29yayBvbiBhY3F1aXJl
ZCBwb2ludGVycyBhbmQgbm90IG5vcm1hbCBQVFJfVE9fQlRGX0lEIHdpdGggc2FtZQ0KPiB0eXBl
DQo+ID4gPiA+ID4gd2hpY2ggY2FuIGJlIG9idGFpbmVkIGJ5IHBvaW50ZXIgd2Fsa2luZy4gVGhl
IHJlc3RyaWN0aW9ucyBhcHBsaWVkIHRvDQo+ID4gPiA+ID4gcmVsZWFzZSBhcmd1bWVudHMgYWxz
byBhcHBseSB0byB0cnVzdGVkIGFyZ3VtZW50cy4gVGhpcyBpbXBsaWVzIHRoYXQNCj4gPiA+ID4g
PiBzdHJpY3QgdHlwZSBtYXRjaGluZyAobm90IGRlZHVjaW5nIHR5cGUgYnkgcmVjdXJzaXZlbHkg
Zm9sbG93aW5nIG1lbWJlcnMNCj4gPiA+ID4gPiBhdCBvZmZzZXQpIGFuZCBPQkpfUkVMRUFTRSBv
ZmZzZXQgY2hlY2tzIChlbnN1cmluZyB0aGV5IGFyZSB6ZXJvKSBhcmUNCj4gPiA+ID4gPiB1c2Vk
IGZvciB0cnVzdGVkIHBvaW50ZXIgYXJndW1lbnRzLg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gU2ln
bmVkLW9mZi1ieTogS3VtYXIgS2FydGlrZXlhIER3aXZlZGkgPG1lbXhvckBnbWFpbC5jb20+DQo+
ID4gPiA+ID4gLS0tDQo+ID4gPiA+ID4gIGluY2x1ZGUvbGludXgvYnRmLmggfCAzMiArKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ID4gPiA+ICBrZXJuZWwvYnBmL2J0Zi5jICAg
IHwgMTcgKysrKysrKysrKysrKystLS0NCj4gPiA+ID4gPiAgbmV0L2JwZi90ZXN0X3J1bi5jICB8
ICA1ICsrKysrDQo+ID4gPiA+ID4gIDMgZmlsZXMgY2hhbmdlZCwgNTEgaW5zZXJ0aW9ucygrKSwg
MyBkZWxldGlvbnMoLSkNCj4gPiA+ID4gPg0KPiA+ID4gPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRl
L2xpbnV4L2J0Zi5oIGIvaW5jbHVkZS9saW51eC9idGYuaA0KPiA+ID4gPiA+IGluZGV4IDZkZmM2
ZWFmN2Y4Yy4uY2I2M2FhNzFlODJmIDEwMDY0NA0KPiA+ID4gPiA+IC0tLSBhL2luY2x1ZGUvbGlu
dXgvYnRmLmgNCj4gPiA+ID4gPiArKysgYi9pbmNsdWRlL2xpbnV4L2J0Zi5oDQo+ID4gPiA+ID4g
QEAgLTE3LDYgKzE3LDM4IEBADQo+ID4gPiA+ID4gICNkZWZpbmUgS0ZfUkVMRUFTRSAgICgxIDw8
IDEpIC8qIGtmdW5jIGlzIGEgcmVsZWFzZSBmdW5jdGlvbiAqLw0KPiA+ID4gPiA+ICAjZGVmaW5l
IEtGX1JFVF9OVUxMICAoMSA8PCAyKSAvKiBrZnVuYyByZXR1cm5zIGEgcG9pbnRlciB0aGF0IG1h
eSBiZQ0KPiBOVUxMDQo+ID4gPiAqLw0KPiA+ID4gPiA+ICAjZGVmaW5lIEtGX0tQVFJfR0VUICAo
MSA8PCAzKSAvKiBrZnVuYyByZXR1cm5zIHJlZmVyZW5jZSB0byBhIGtwdHIgKi8NCj4gPiA+ID4g
PiArLyogVHJ1c3RlZCBhcmd1bWVudHMgYXJlIHRob3NlIHdoaWNoIGFyZSBtZWFudCB0byBiZSBy
ZWZlcmVuY2VkDQo+ID4gPiBhcmd1bWVudHMNCj4gPiA+ID4gPiB3aXRoDQo+ID4gPiA+ID4gKyAq
IHVuY2hhbmdlZCBvZmZzZXQuIEl0IGlzIHVzZWQgdG8gZW5mb3JjZSB0aGF0IHBvaW50ZXJzIG9i
dGFpbmVkIGZyb20NCj4gPiA+IGFjcXVpcmUNCj4gPiA+ID4gPiArICoga2Z1bmNzIHJlbWFpbiB1
bm1vZGlmaWVkIHdoZW4gYmVpbmcgcGFzc2VkIHRvIGhlbHBlcnMgdGFraW5nDQo+IHRydXN0ZWQN
Cj4gPiA+IGFyZ3MuDQo+ID4gPiA+ID4gKyAqDQo+ID4gPiA+ID4gKyAqIENvbnNpZGVyDQo+ID4g
PiA+ID4gKyAqICAgc3RydWN0IGZvbyB7DQo+ID4gPiA+ID4gKyAqICAgICAgICAgICBpbnQgZGF0
YTsNCj4gPiA+ID4gPiArICogICAgICAgICAgIHN0cnVjdCBmb28gKm5leHQ7DQo+ID4gPiA+ID4g
KyAqICAgfTsNCj4gPiA+ID4gPiArICoNCj4gPiA+ID4gPiArICogICBzdHJ1Y3QgYmFyIHsNCj4g
PiA+ID4gPiArICogICAgICAgICAgIGludCBkYXRhOw0KPiA+ID4gPiA+ICsgKiAgICAgICAgICAg
c3RydWN0IGZvbyBmOw0KPiA+ID4gPiA+ICsgKiAgIH07DQo+ID4gPiA+ID4gKyAqDQo+ID4gPiA+
ID4gKyAqICAgc3RydWN0IGZvbyAqZiA9IGFsbG9jX2ZvbygpOyAvLyBBY3F1aXJlIGtmdW5jDQo+
ID4gPiA+ID4gKyAqICAgc3RydWN0IGJhciAqYiA9IGFsbG9jX2JhcigpOyAvLyBBY3F1aXJlIGtm
dW5jDQo+ID4gPiA+ID4gKyAqDQo+ID4gPiA+ID4gKyAqIElmIGEga2Z1bmMgc2V0X2Zvb19kYXRh
KCkgd2FudHMgdG8gb3BlcmF0ZSBvbmx5IG9uIHRoZSBhbGxvY2F0ZWQNCj4gb2JqZWN0LA0KPiA+
ID4gaXQNCj4gPiA+ID4gPiArICogd2lsbCBzZXQgdGhlIEtGX1RSVVNURURfQVJHUyBmbGFnLCB3
aGljaCB3aWxsIHByZXZlbnQgdW5zYWZlIHVzYWdlDQo+IGxpa2U6DQo+ID4gPiA+ID4gKyAqDQo+
ID4gPiA+ID4gKyAqICAgc2V0X2Zvb19kYXRhKGYsIDQyKTsgICAgICAgLy8gQWxsb3dlZA0KPiA+
ID4gPiA+ICsgKiAgIHNldF9mb29fZGF0YShmLT5uZXh0LCA0Mik7IC8vIFJlamVjdGVkLCBub24t
cmVmZXJlbmNlZCBwb2ludGVyDQo+ID4gPiA+ID4gKyAqICAgc2V0X2Zvb19kYXRhKCZmLT5uZXh0
LCA0Mik7Ly8gUmVqZWN0ZWQsIHJlZmVyZW5jZWQsIGJ1dCBiYWQgb2Zmc2V0DQo+ID4gPiA+ID4g
KyAqICAgc2V0X2Zvb19kYXRhKCZiLT5mLCA0Mik7ICAgLy8gUmVqZWN0ZWQsIHJlZmVyZW5jZWQs
IGJ1dCB3cm9uZyB0eXBlDQo+ID4gPiA+ID4gKyAqDQo+ID4gPiA+ID4gKyAqIEluIHRoZSBmaW5h
bCBjYXNlLCB1c3VhbGx5IGZvciB0aGUgcHVycG9zZXMgb2YgdHlwZSBtYXRjaGluZywgaXQgaXMN
Cj4gZGVkdWNlZA0KPiA+ID4gPiA+ICsgKiBieSBsb29raW5nIGF0IHRoZSB0eXBlIG9mIHRoZSBt
ZW1iZXIgYXQgdGhlIG9mZnNldCwgYnV0IGR1ZSB0byB0aGUNCj4gPiA+ID4gPiArICogcmVxdWly
ZW1lbnQgb2YgdHJ1c3RlZCBhcmd1bWVudCwgdGhpcyBkZWR1Y3Rpb24gd2lsbCBiZSBzdHJpY3Qg
YW5kIG5vdA0KPiA+ID4gZG9uZQ0KPiA+ID4gPiA+ICsgKiBmb3IgdGhpcyBjYXNlLg0KPiA+ID4g
PiA+ICsgKi8NCj4gPiA+ID4gPiArI2RlZmluZSBLRl9UUlVTVEVEX0FSR1MgKDEgPDwgNCkgLyog
a2Z1bmMgb25seSB0YWtlcyB0cnVzdGVkIHBvaW50ZXINCj4gPiA+ID4gPiBhcmd1bWVudHMgKi8N
Cj4gPiA+ID4NCj4gPiA+ID4gSGkgS3VtYXINCj4gPiA+ID4NCj4gPiA+ID4gd291bGQgaXQgbWFr
ZSBzZW5zZSB0byBpbnRyb2R1Y2UgcGVyLXBhcmFtZXRlciBmbGFncz8gSSBoYXZlIGEgZnVuY3Rp
b24NCj4gPiA+ID4gdGhhdCBoYXMgc2V2ZXJhbCBwYXJhbWV0ZXJzLCBidXQgb25seSBvbmUgaXMg
cmVmZXJlbmNlZC4NCj4gPiA+ID4NCj4gPiA+DQo+ID4gPiBJIGhhdmUgYSBwYXRjaCBmb3IgdGhh
dCBpbiBteSBsb2NhbCBicmFuY2gsIEkgY2FuIGZpeCBpdCB1cCBhbmQgcG9zdA0KPiA+ID4gaXQu
IEJ1dCBmaXJzdCwgY2FuIHlvdSBnaXZlIGFuIGV4YW1wbGUgb2Ygd2hlcmUgeW91IHRoaW5rIHlv
dSBuZWVkIGl0Pw0KPiA+DQo+ID4gSSBoYXZlIHB1c2hlZCB0aGUgY29tcGxldGUgcGF0Y2ggc2V0
IGhlcmUsIGZvciB0ZXN0aW5nOg0KPiA+DQo+ID4gaHR0cHM6Ly9naXRodWIuY29tL3JvYmVydG9z
YXNzdS92bXRlc3QvdHJlZS9icGYtdmVyaWZ5LXNpZy12OS90cmF2aXMtY2kvZGlmZnMNCj4gPg0K
PiA+IEkgcmViYXNlZCB0byBicGYtbmV4dC9tYXN0ZXIsIGFuZCBpbnRyb2R1Y2VkIEtGX1NMRUVQ
QUJMRSAoc2ltaWxhcg0KPiA+IGZ1bmN0aW9uYWxpdHkgb2YgIiBidGY6IEFkZCBhIG5ldyBrZnVu
YyBzZXQgd2hpY2ggYWxsb3dzIHRvIG1hcmsNCj4gPiBhIGZ1bmN0aW9uIHRvIGJlIHNsZWVwYWJs
ZSIgZnJvbSBCZW5qYW1pbiBUaXNzb2lyZXMpLg0KPiA+DQo+ID4gVGhlIHBhdGNoIHdoZXJlIEkg
d291bGQgdXNlIHBlci1wYXJhbWV0ZXIgS0ZfVFJVU1RFRF9BUkdTIGlzDQo+ID4gbnVtYmVyIDgu
IEkgYWxzbyB1c2VkIHlvdXIgbmV3IEFQSSBpbiBwYXRjaCA3IGFuZCBpdCB3b3JrcyB3ZWxsLg0K
PiA+DQo+IA0KPiBPaywgbG9va3MgbGlrZSB5b3UnbGwgbmVlZCBpdCBmb3IgdGhlIHN0cnVjdCBr
ZXkgKiBhcmd1bWVudCBhcyB0aGVyZQ0KPiBhcmUgbXVsdGlwbGUgcG9pbnRlcnMgaW4gdGhlIGFy
Z3VtZW50IGxpc3QgYW5kIG5vdCBhbGwgb2YgdGhlbSBuZWVkIHRvDQo+IGJlIHRydXN0ZWQuIEkg
d2lsbCBjbGVhbiB1cCBhbmQgcG9zdCB0aGUgcGF0Y2ggd2l0aCBhIHRlc3QgbGF0ZXIgdG9kYXkN
Cj4gdG8gdGhlIGxpc3QuDQoNClllcywgdGhhbmtzIGEgbG90IQ0KDQpSb2JlcnRvDQo=
