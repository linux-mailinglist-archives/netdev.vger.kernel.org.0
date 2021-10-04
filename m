Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171C8420533
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 06:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbhJDEXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 00:23:22 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:27959 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbhJDEXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 00:23:21 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HN6qp1j3Dzbmvq;
        Mon,  4 Oct 2021 12:17:10 +0800 (CST)
Received: from dggema722-chm.china.huawei.com (10.3.20.86) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.8; Mon, 4 Oct 2021 12:21:31 +0800
Received: from dggema772-chm.china.huawei.com (10.1.198.214) by
 dggema722-chm.china.huawei.com (10.3.20.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Mon, 4 Oct 2021 12:21:30 +0800
Received: from dggema772-chm.china.huawei.com ([10.9.128.138]) by
 dggema772-chm.china.huawei.com ([10.9.128.138]) with mapi id 15.01.2308.008;
 Mon, 4 Oct 2021 12:21:30 +0800
From:   "liujian (CE)" <liujian56@huawei.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "jakub@cloudflare.com" <jakub@cloudflare.com>,
        "lmb@cloudflare.com" <lmb@cloudflare.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [PATCH] tcp_bpf: Fix one concurrency problem in the
 tcp_bpf_send_verdict function
Thread-Topic: [PATCH] tcp_bpf: Fix one concurrency problem in the
 tcp_bpf_send_verdict function
Thread-Index: AQHXtQ5U4fcmLA6PRkmX5jNtsbYaTKu8o+WAgAWdDIA=
Date:   Mon, 4 Oct 2021 04:21:30 +0000
Message-ID: <dfed692354c94efab9c83dee2cd5cf16@huawei.com>
References: <20210929084529.96583-1-liujian56@huawei.com>
 <61563953e731f_6c4e420814@john-XPS-13-9370.notmuch>
In-Reply-To: <61563953e731f_6c4e420814@john-XPS-13-9370.notmuch>
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
W21haWx0bzpqb2huLmZhc3RhYmVuZEBnbWFpbC5jb21dDQo+IFNlbnQ6IEZyaWRheSwgT2N0b2Jl
ciAxLCAyMDIxIDY6MjUgQU0NCj4gVG86IGxpdWppYW4gKENFKSA8bGl1amlhbjU2QGh1YXdlaS5j
b20+OyBqb2huLmZhc3RhYmVuZEBnbWFpbC5jb207DQo+IGRhbmllbEBpb2dlYXJib3gubmV0OyBq
YWt1YkBjbG91ZGZsYXJlLmNvbTsgbG1iQGNsb3VkZmxhcmUuY29tOw0KPiBlZHVtYXpldEBnb29n
bGUuY29tOyBkYXZlbUBkYXZlbWxvZnQubmV0OyB5b3NoZnVqaUBsaW51eC1pcHY2Lm9yZzsNCj4g
ZHNhaGVybkBrZXJuZWwub3JnOyBrdWJhQGtlcm5lbC5vcmc7IGFzdEBrZXJuZWwub3JnOyBhbmRy
aWlAa2VybmVsLm9yZzsNCj4ga2FmYWlAZmIuY29tOyBzb25nbGl1YnJhdmluZ0BmYi5jb207IHlo
c0BmYi5jb207IGtwc2luZ2hAa2VybmVsLm9yZzsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsg
YnBmQHZnZXIua2VybmVsLm9yZw0KPiBDYzogbGl1amlhbiAoQ0UpIDxsaXVqaWFuNTZAaHVhd2Vp
LmNvbT4NCj4gU3ViamVjdDogUkU6IFtQQVRDSF0gdGNwX2JwZjogRml4IG9uZSBjb25jdXJyZW5j
eSBwcm9ibGVtIGluIHRoZQ0KPiB0Y3BfYnBmX3NlbmRfdmVyZGljdCBmdW5jdGlvbg0KPiANCj4g
TGl1IEppYW4gd3JvdGU6DQo+ID4gSW4gdGhlIGZvbGxvd2luZyBjYXNlczoNCj4gPiBXZSBuZWVk
IHRvIHJlZGlyZWN0IHRoZSBmaXJzdCBtc2cgdG8gc29jazEgYW5kIHRoZSBzZWNvbmQgbXNnIHRv
IHNvY2syLg0KPiA+IFRoZSBzb2NrIGxvY2sgbmVlZHMgdG8gYmUgcmVsZWFzZWQgYXQgX19TS19S
RURJUkVDVCBhbmQgdG8gZ2V0IGFub3RoZXINCj4gPiBzb2NrIGxvY2ssIHRoaXMgd2lsbCBjYXVz
ZSB0aGUgcHJvYmFiaWxpdHkgdGhhdCBwc29jay0+ZXZhbCBpcyBub3Qgc2V0DQo+ID4gdG8gX19T
S19OT05FIHdoZW4gdGhlIHNlY29uZCBtc2cgY29tZXMuDQo+ID4NCj4gPiBJZiBwc29jayBkb2Vz
IG5vdCBzZXQgYXBwbGUgYnl0ZXMsIGZpeCB0aGlzIGJ5IGRvIHRoZSBjbGVhbnVwIGJlZm9yZQ0K
PiA+IHJlbGVhc2luZyB0aGUgc29jayBsb2NrLiBBbmQga2VlcCB0aGUgb3JpZ2luYWwgbG9naWMg
aW4gb3RoZXIgY2FzZXMuDQo+IA0KPiBJdCB0b29rIG1lIHNvbWV0aW1lIHRvIGZpZ3VyZSBvdXQg
dGhlIGFib3ZlIGRlc2NyaXB0aW9uLiBQbGVhc2UgaW5jbHVkZSBhIGJpdA0KPiBtb3JlIGRldGFp
bHMgaGVyZSB0aGlzIG5lZWRzIHRvIGJlIGJhY2twb3J0ZWQgc28gd2Ugd2FudCB0byBiZSB2ZXJ5
IGNsZWFyDQo+IHdoYXQgdGhlIGVycm9yICBpcyBhbmQgaG93IHRvIHRyaWdnZXIgaXQuDQo+IA0K
PiBJbiB0aGlzIGNhc2Ugd2Ugc2hvdWxkIGxpc3QgdGhlIGZsb3cgdG8gc2hvdyBob3cgdGhlIGlu
dGVybGVhdmluZyBvZiBtc2dzDQo+IGJyZWFrcy4NCj4gDQo+ICINCj4gV2l0aCB0d28gTXNncywg
bXNnQSBhbmQgbXNnQiBhbmQgYSB1c2VyIGRvaW5nIG5vbmJsb2NraW5nIHNlbmRtc2cgY2FsbHMN
Cj4gKG9yIG11bHRpcGxlIGNvcmVzKSBvbiBhIHNpbmdsZSBzb2NrZXQgJ3NrJyB3ZSBjb3VsZCBn
ZXQgdGhlIGZvbGxvd2luZyBmbG93Lg0KPiANCj4gIG1zZ0EsIHNrICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIG1zZ0IsIHNrDQo+ICAtLS0tLS0tLS0tLSAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAtLS0tLS0tLS0tLS0tLS0NCj4gIHRjcF9icGZfc2VuZG1zZygpDQo+ICBsb2NrKHNr
KQ0KPiAgcHNvY2sgPSBzay0+cHNvY2sNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHRjcF9icGZfc2VuZG1zZygpDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBsb2NrKHNrKSAuLi4gYmxvY2tpbmcgIHRjcF9icGZfc2VuZF92ZXJkaWN0
ICBpZiAocHNvY2stDQo+ID5ldmFsID09IE5PTkUpDQo+ICAgIHBzb2NrLT5ldmFsID0gc2tfcHNv
Y2tfbXNnX3ZlcmRpY3QNCj4gIC4uDQo+ICA8IGhhbmRsZSBTS19SRURJUkVDVCBjYXNlID4NCj4g
ICAgcmVsZWFzZV9zb2NrKHNrKSAgICAgICAgICAgICAgICAgICAgIDwgbG9jayBkcm9wcGVkIHNv
IGdyYWIgaGVyZSA+DQo+ICAgIHJldCA9IHRjcF9icGZfc2VuZG1zZ19yZWRpcg0KPiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcHNvY2sgPSBzay0+cHNvY2sNCj4gICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHRjcF9icGZfc2VuZF92ZXJkaWN0
DQo+ICBsb2NrX3NvY2soc2spIC4uLiBibG9ja2luZyBvbiBCDQo+ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBpZiAocHNvY2stPmV2YWwgPT0gTk9ORSkgPC0gYm9vbS4N
Cj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBwc29jay0+ZXZhbCB3
aWxsIGhhdmUgbXNnQSBzdGF0ZQ0KPiANCj4gVGhlIHByb2JsZW0gaGVyZSBpcyB3ZSBkcm9wcGVk
IHRoZSBsb2NrIG9uIG1zZ0EgYW5kIGdyYWJiZWQgaXQgd2l0aCBtc2dCLg0KPiBOb3cgd2UgaGF2
ZSBvbGQgc3RhdGUgaW4gcHNvY2sgYW5kIGltcG9ydGFudGx5IHBzb2NrLT5ldmFsIGhhcyBub3Qg
YmVlbg0KPiBjbGVhcmVkLiBTbyBtc2dCIHdpbGwgcnVuIHdoYXRldmVyIGFjdGlvbiB3YXMgZG9u
ZSBvbiBBIGFuZCB0aGUgdmVyZGljdA0KPiBwcm9ncmFtIG1heSBuZXZlciBzZWUgaXQuDQo+ICIN
Cj4gDQo+IFNob3dpbmcgdGhlIGZsb3cgbWFrZXMgaXQgcGFpbmZ1bGx5IG9idmlvdXMgd2h5IGRy
b3BwaW5nIHRoYXQgbG9jayB3aXRoIG9sZA0KPiBzdGF0ZSBpcyBicm9rZW4uDQo+IA0KVGhhbmtz
IGEgbG90IGZvciBzdWNoIGEgZGV0YWlsZWQgZXhhbXBsZS4NCj4gDQo+ID4NCj4gPiBTaWduZWQt
b2ZmLWJ5OiBMaXUgSmlhbiA8bGl1amlhbjU2QGh1YXdlaS5jb20+DQo+IA0KPiBXZSBuZWVkIGEg
Zml4ZXMgdGFnIGFzIHdlbGwgc28gd2UgY2FuIGJhY2twb3J0IHRoaXMuDQogSSB3aWxsIGFkZCBp
dC4NCj4gDQo+ID4gLS0tDQo+ID4gIG5ldC9pcHY0L3RjcF9icGYuYyB8IDEyICsrKysrKysrKysr
Kw0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAt
LWdpdCBhL25ldC9pcHY0L3RjcF9icGYuYyBiL25ldC9pcHY0L3RjcF9icGYuYyBpbmRleA0KPiA+
IGQzZTkzODZiNDkzZS4uMDI0NDJlNDNhYzRkIDEwMDY0NA0KPiA+IC0tLSBhL25ldC9pcHY0L3Rj
cF9icGYuYw0KPiA+ICsrKyBiL25ldC9pcHY0L3RjcF9icGYuYw0KPiA+IEBAIC0yMzIsNiArMjMy
LDcgQEAgc3RhdGljIGludCB0Y3BfYnBmX3NlbmRfdmVyZGljdChzdHJ1Y3Qgc29jayAqc2ssDQo+
IHN0cnVjdCBza19wc29jayAqcHNvY2ssDQo+ID4gIAlib29sIGNvcmsgPSBmYWxzZSwgZW5vc3Bj
ID0gc2tfbXNnX2Z1bGwobXNnKTsNCj4gPiAgCXN0cnVjdCBzb2NrICpza19yZWRpcjsNCj4gPiAg
CXUzMiB0b3NlbmQsIGRlbHRhID0gMDsNCj4gPiArCXUzMiBldmFsID0gX19TS19OT05FOw0KPiA+
ICAJaW50IHJldDsNCj4gPg0KPiA+ICBtb3JlX2RhdGE6DQo+ID4gQEAgLTI3NCw2ICsyNzUsMTIg
QEAgc3RhdGljIGludCB0Y3BfYnBmX3NlbmRfdmVyZGljdChzdHJ1Y3Qgc29jayAqc2ssDQo+IHN0
cnVjdCBza19wc29jayAqcHNvY2ssDQo+ID4gIAkJYnJlYWs7DQo+ID4gIAljYXNlIF9fU0tfUkVE
SVJFQ1Q6DQo+ID4gIAkJc2tfcmVkaXIgPSBwc29jay0+c2tfcmVkaXI7DQo+ID4gKwkJaWYgKCFw
c29jay0+YXBwbHlfYnl0ZXMpIHsNCj4gPiArCQkJLyogQ2xlYW4gdXAgYmVmb3JlIHJlbGVhc2lu
ZyB0aGUgc29jayBsb2NrLiAqLw0KPiA+ICsJCQlldmFsID0gcHNvY2stPmV2YWw7DQo+ID4gKwkJ
CXBzb2NrLT5ldmFsID0gX19TS19OT05FOw0KPiA+ICsJCQlwc29jay0+c2tfcmVkaXIgPSBOVUxM
Ow0KPiA+ICsJCX0NCj4gDQo+IFdlIG5lZWQgdG8gbW92ZSBhYm92ZSBjaHVuayBiZWxvdyBza19t
c2dfYXBwbHlfYnl0ZXMoKSBzbyB3ZSBhY2NvdW50DQo+IGZvciB0aGUgYnl0ZXMgYW5kIGlmIHdl
IHplcm8gYXBwbHkgYnl0ZXMgd2l0aCB0aGlzIHNlbmQgd2UgY2xlYXIgdGhlIHBzb2NrDQo+IHN0
YXRlLiBPdGhlcndpc2Ugd2UgY291bGQgaGF2ZSB0aGUgc2FtZSBpc3N1ZSB3aXRoIHN0YWxlIHN0
YXRlIG9uIHRoZQ0KPiBib3VuZGFyeSB3aGVyZSBhcHBseSBieXRlcyBpcyBtZXQuDQo+IA0KPiA+
ICAJCXNrX21zZ19hcHBseV9ieXRlcyhwc29jaywgdG9zZW5kKTsNCj4gDQo+IDwtLSBwdXQgYWJv
dmUgY2h1bmsgaGVyZS4NCnllcywgaGVyZSBsb29rcyBiZXR0ZXIuIA0KPiANCj4gPiAgCQlpZiAo
cHNvY2stPmNvcmspIHsNCj4gPiAgCQkJY29yayA9IHRydWU7DQo+IA0KPiBJbnRlcmVzdGluZ2x5
LCBJIGNhdWdodCB0aGUgcmFjZSB3aXRoIGNvcmsgc3RhdGUsIGJ1dCBtaXNzZWQgaXQgd2l0aCB0
aGUgZXZhbA0KPiBjYXNlLiBMaWtlbHkgYmVjYXVzZSBvdXIgcHJvZ3JhbSByZWRpcmVjdGVkIHRv
IGEgc2luZ2xlIHNrLg0KPiANClllcy4gDQo+ID4gQEAgLTI4MSw3ICsyODgsMTIgQEAgc3RhdGlj
IGludCB0Y3BfYnBmX3NlbmRfdmVyZGljdChzdHJ1Y3Qgc29jayAqc2ssDQo+IHN0cnVjdCBza19w
c29jayAqcHNvY2ssDQo+ID4gIAkJfQ0KPiA+ICAJCXNrX21zZ19yZXR1cm4oc2ssIG1zZywgdG9z
ZW5kKTsNCj4gPiAgCQlyZWxlYXNlX3NvY2soc2spOw0KPiA+ICsNCj4gPiAgCQlyZXQgPSB0Y3Bf
YnBmX3NlbmRtc2dfcmVkaXIoc2tfcmVkaXIsIG1zZywgdG9zZW5kLCBmbGFncyk7DQo+ID4gKw0K
PiA+ICsJCWlmIChldmFsID09IF9fU0tfUkVESVJFQ1QpDQo+IA0KPiBJcyB0aGUgJ2lmJyBuZWVk
ZWQ/IHdlIGFyZSBpbiB0aGlzIGNhc2UgYmVjYXVzZSBldmFsIGlzIFNLX1JFRElSRUNULg0KPiAN
Ck5lZWQgaXQsIGJlY2F1c2UgSWYgdGhlICJhcHBseSBieXRlcyIgaXMgbm90IHplcm8sIGkgZGlk
IG5vdCBjaGFuZ2UgdGhlIGxvZ2ljLg0KPiA+ICsJCQlzb2NrX3B1dChza19yZWRpcik7DQo+ID4g
Kw0KPiA+ICAJCWxvY2tfc29jayhzayk7DQo+ID4gIAkJaWYgKHVubGlrZWx5KHJldCA8IDApKSB7
DQo+ID4gIAkJCWludCBmcmVlID0gc2tfbXNnX2ZyZWVfbm9jaGFyZ2Uoc2ssIG1zZyk7DQo+ID4g
LS0NCj4gPiAyLjE3LjENCj4gPg0K
