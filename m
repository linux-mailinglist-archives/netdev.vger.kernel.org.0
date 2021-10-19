Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B11432C07
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 05:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbhJSDF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 23:05:59 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:13952 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbhJSDF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 23:05:58 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HYJS54t2GzZcPh;
        Tue, 19 Oct 2021 11:01:57 +0800 (CST)
Received: from dggema722-chm.china.huawei.com (10.3.20.86) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.15; Tue, 19 Oct 2021 11:03:42 +0800
Received: from dggema772-chm.china.huawei.com (10.1.198.214) by
 dggema722-chm.china.huawei.com (10.3.20.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.15; Tue, 19 Oct 2021 11:03:42 +0800
Received: from dggema772-chm.china.huawei.com ([10.9.128.138]) by
 dggema772-chm.china.huawei.com ([10.9.128.138]) with mapi id 15.01.2308.015;
 Tue, 19 Oct 2021 11:03:42 +0800
From:   "liujian (CE)" <liujian56@huawei.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
CC:     "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "lmb@cloudflare.com" <lmb@cloudflare.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [PATCH] bpf, sockmap: Do not read sk_receive_queue in
 tcp_bpf_recvmsg if strparser enabled
Thread-Topic: [PATCH] bpf, sockmap: Do not read sk_receive_queue in
 tcp_bpf_recvmsg if strparser enabled
Thread-Index: AQHXwZpygzOnNyA0s0aKrXrj6DNL3qvX8kKAgABTfQCAAUoU4A==
Date:   Tue, 19 Oct 2021 03:03:41 +0000
Message-ID: <21313b79ef0c4059a0d9cfa3fd8746fd@huawei.com>
References: <20211015080142.43424-1-liujian56@huawei.com>
 <87v91ug1bi.fsf@cloudflare.com>
 <616d7c5aa492a_1eb12084b@john-XPS-13-9370.notmuch>
In-Reply-To: <616d7c5aa492a_1eb12084b@john-XPS-13-9370.notmuch>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.93]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9obiBGYXN0YWJlbmQg
W21haWx0bzpqb2huLmZhc3RhYmVuZEBnbWFpbC5jb21dDQo+IFNlbnQ6IE1vbmRheSwgT2N0b2Jl
ciAxOCwgMjAyMSA5OjU0IFBNDQo+IFRvOiBKYWt1YiBTaXRuaWNraSA8amFrdWJAY2xvdWRmbGFy
ZS5jb20+OyBsaXVqaWFuIChDRSkNCj4gPGxpdWppYW41NkBodWF3ZWkuY29tPg0KPiBDYzogam9o
bi5mYXN0YWJlbmRAZ21haWwuY29tOyBkYW5pZWxAaW9nZWFyYm94Lm5ldDsgbG1iQGNsb3VkZmxh
cmUuY29tOw0KPiBlZHVtYXpldEBnb29nbGUuY29tOyBkYXZlbUBkYXZlbWxvZnQubmV0OyBrdWJh
QGtlcm5lbC5vcmc7DQo+IHlvc2hmdWppQGxpbnV4LWlwdjYub3JnOyBkc2FoZXJuQGtlcm5lbC5v
cmc7IGFzdEBrZXJuZWwub3JnOw0KPiBhbmRyaWlAa2VybmVsLm9yZzsga2FmYWlAZmIuY29tOyBz
b25nbGl1YnJhdmluZ0BmYi5jb207IHloc0BmYi5jb207DQo+IGtwc2luZ2hAa2VybmVsLm9yZzsg
bmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgYnBmQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBS
ZTogW1BBVENIXSBicGYsIHNvY2ttYXA6IERvIG5vdCByZWFkIHNrX3JlY2VpdmVfcXVldWUgaW4N
Cj4gdGNwX2JwZl9yZWN2bXNnIGlmIHN0cnBhcnNlciBlbmFibGVkDQo+IA0KPiBKYWt1YiBTaXRu
aWNraSB3cm90ZToNCj4gPiBPbiBGcmksIE9jdCAxNSwgMjAyMSBhdCAxMDowMSBBTSBDRVNULCBM
aXUgSmlhbiB3cm90ZToNCj4gPiA+IElmIHRoZSBzdHJwYXJzZXIgZnVuY3Rpb24gb2Ygc2sgaXMg
dHVybmVkIG9uLCBhbGwgcmVjZWl2ZWQgZGF0YQ0KPiA+ID4gbmVlZHMgdG8gYmUgcHJvY2Vzc2Vk
IGJ5IHN0cnBhcnNlciBmaXJzdC4NCj4gPiA+DQo+ID4gPiBGaXhlczogNjA0MzI2YjQxYTZmYiAo
ImJwZiwgc29ja21hcDogY29udmVydCB0byBnZW5lcmljIHNrX21zZw0KPiA+ID4gaW50ZXJmYWNl
IikNCj4gPiA+IFNpZ25lZC1vZmYtYnk6IExpdSBKaWFuIDxsaXVqaWFuNTZAaHVhd2VpLmNvbT4N
Cj4gPiA+IC0tLQ0KPiA+DQo+ID4gWy4uLl0NCj4gPg0KPiA+ID4gIG5ldC9jb3JlL3NrbXNnLmMg
ICAgICB8IDUgKysrKysNCj4gPiA+ICBuZXQvaXB2NC90Y3BfYnBmLmMgICAgfCA5ICsrKysrKy0t
LQ0KPiA+ID4gIDMgZmlsZXMgY2hhbmdlZCwgMTcgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMo
LSkNCj4gPiA+DQo+ID4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9za21zZy5oIGIvaW5j
bHVkZS9saW51eC9za21zZy5oIGluZGV4DQo+ID4gPiA5NGUyYTFmNmU1OGQuLjI1ZTkyZGZmMDRh
YSAxMDA2NDQNCj4gPiA+IC0tLSBhL2luY2x1ZGUvbGludXgvc2ttc2cuaA0KPiA+ID4gKysrIGIv
aW5jbHVkZS9saW51eC9za21zZy5oDQo+ID4gPiBAQCAtMzkwLDYgKzM5MCw3IEBAIHZvaWQgc2tf
cHNvY2tfc3RvcChzdHJ1Y3Qgc2tfcHNvY2sgKnBzb2NrLCBib29sDQo+ID4gPiB3YWl0KTsgIGlu
dCBza19wc29ja19pbml0X3N0cnAoc3RydWN0IHNvY2sgKnNrLCBzdHJ1Y3Qgc2tfcHNvY2sNCj4g
PiA+ICpwc29jayk7ICB2b2lkIHNrX3Bzb2NrX3N0YXJ0X3N0cnAoc3RydWN0IHNvY2sgKnNrLCBz
dHJ1Y3Qgc2tfcHNvY2sNCj4gPiA+ICpwc29jayk7ICB2b2lkIHNrX3Bzb2NrX3N0b3Bfc3RycChz
dHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBza19wc29jaw0KPiA+ID4gKnBzb2NrKTsNCj4gPiA+ICti
b29sIHNrX3Bzb2NrX3N0cnBhcnNlcl9zdGFydGVkKHN0cnVjdCBzb2NrICpzayk7DQo+ID4gPiAg
I2Vsc2UNCj4gPiA+ICBzdGF0aWMgaW5saW5lIGludCBza19wc29ja19pbml0X3N0cnAoc3RydWN0
IHNvY2sgKnNrLCBzdHJ1Y3QNCj4gPiA+IHNrX3Bzb2NrICpwc29jaykgIHsgQEAgLTQwMyw2ICs0
MDQsMTEgQEAgc3RhdGljIGlubGluZSB2b2lkDQo+ID4gPiBza19wc29ja19zdGFydF9zdHJwKHN0
cnVjdCBzb2NrICpzaywgc3RydWN0IHNrX3Bzb2NrICpwc29jaykgIHN0YXRpYw0KPiA+ID4gaW5s
aW5lIHZvaWQgc2tfcHNvY2tfc3RvcF9zdHJwKHN0cnVjdCBzb2NrICpzaywgc3RydWN0IHNrX3Bz
b2NrDQo+ID4gPiAqcHNvY2spICB7ICB9DQo+ID4gPiArDQo+ID4gPiArc3RhdGljIGlubGluZSBi
b29sIHNrX3Bzb2NrX3N0cnBhcnNlcl9zdGFydGVkKHN0cnVjdCBzb2NrICpzaykgew0KPiA+ID4g
KwlyZXR1cm4gZmFsc2U7DQo+ID4gPiArfQ0KPiA+ID4gICNlbmRpZg0KPiA+ID4NCj4gPiA+ICB2
b2lkIHNrX3Bzb2NrX3N0YXJ0X3ZlcmRpY3Qoc3RydWN0IHNvY2sgKnNrLCBzdHJ1Y3Qgc2tfcHNv
Y2sNCj4gPiA+ICpwc29jayk7IGRpZmYgLS1naXQgYS9uZXQvY29yZS9za21zZy5jIGIvbmV0L2Nv
cmUvc2ttc2cuYyBpbmRleA0KPiA+ID4gZTg1YjdmODQ5MWI5Li5kZDY0ZWY4NTRmM2UgMTAwNjQ0
DQo+ID4gPiAtLS0gYS9uZXQvY29yZS9za21zZy5jDQo+ID4gPiArKysgYi9uZXQvY29yZS9za21z
Zy5jDQo+ID4gPiBAQCAtMTEwNSw2ICsxMTA1LDExIEBAIHZvaWQgc2tfcHNvY2tfc3RhcnRfc3Ry
cChzdHJ1Y3Qgc29jayAqc2ssDQo+IHN0cnVjdCBza19wc29jayAqcHNvY2spDQo+ID4gPiAgCXNr
LT5za193cml0ZV9zcGFjZSA9IHNrX3Bzb2NrX3dyaXRlX3NwYWNlOyAgfQ0KPiA+ID4NCj4gPiA+
ICtib29sIHNrX3Bzb2NrX3N0cnBhcnNlcl9zdGFydGVkKHN0cnVjdCBzb2NrICpzaykgew0KPiA+
ID4gKwlyZXR1cm4gc2stPnNrX2RhdGFfcmVhZHkgPT0gc2tfcHNvY2tfc3RycF9kYXRhX3JlYWR5
Ow0KPiA+DQo+ID4gV2hhdCBpZiBrVExTIGlzIGNvbmZpZ3VyZWQgb24gdGhlIHNvY2tldD8gSSB0
aGluayB0aGlzIGNoZWNrIHdvbid0IHdvcmsgdGhlbi4NCj4gDQo+IExpdSwgZGlkIHlvdSBzZWUg
dGhpcy4gSSB0aGluayBpdHMgYSBiaXQgY2xlYW5lciwgYXZvaWRzIHRoZSBleHRyYSBwYXJzZXIg
Y2hlY2sgaW4NCj4gaG90cGF0aCwgYW5kIHNob3VsZCBzb2x2ZSB0aGUgaXNzdWU/DQo+IA0KPiBo
dHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL3Byb2plY3QvbmV0ZGV2YnBmL3BhdGNoLzIwMjEx
MDExMTkxNjQ3LjQxOA0KPiA3MDQtMy1qb2huLmZhc3RhYmVuZEBnbWFpbC5jb20vDQo+IA0KPiBJ
IHRoaW5rIGl0IHNob3VsZCBhbHNvIGFkZHJlc3MgSmFrdWIncyBjb25jZXJuLg0KPiANCkkgYW0g
c29ycnksIEkgZGlkIG5vdCBzZWUgdGhlIHBhdGNoIGJlZm9yZS4NCkkgdGhpbmsgaXQgY2FuIHNv
bHZlIG15IGlzc3VlLCBwbGVhc2UgaWdub3JlIG15IHBhdGNoLg0KVGhhbmtzLg0KDQo+IFRoYW5r
cywNCj4gSm9obg0KPiANCj4gPg0KPiA+ID4gK30NCj4gPiA+ICsNCj4gPiA+ICB2b2lkIHNrX3Bz
b2NrX3N0b3Bfc3RycChzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBza19wc29jayAqcHNvY2spICB7
DQo+ID4gPiAgCWlmICghcHNvY2stPnNhdmVkX2RhdGFfcmVhZHkpDQo+ID4NCj4gPiBbLi4uXQ0K
PiANCg0K
