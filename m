Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3CF35503FB
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 12:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbiFRKQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 06:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiFRKQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 06:16:14 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF22F2870C;
        Sat, 18 Jun 2022 03:16:12 -0700 (PDT)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LQBYY6nCCzBrjR;
        Sat, 18 Jun 2022 18:12:49 +0800 (CST)
Received: from dggpeml500011.china.huawei.com (7.185.36.84) by
 kwepemi500008.china.huawei.com (7.221.188.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 18 Jun 2022 18:16:10 +0800
Received: from dggpeml500011.china.huawei.com ([7.185.36.84]) by
 dggpeml500011.china.huawei.com ([7.185.36.84]) with mapi id 15.01.2375.024;
 Sat, 18 Jun 2022 18:16:10 +0800
From:   "zhudi (E)" <zhudi2@huawei.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Chenxiang (EulerOS)" <rose.chen@huawei.com>,
        "syzbot+7a12909485b94426aceb@syzkaller.appspotmail.com" 
        <syzbot+7a12909485b94426aceb@syzkaller.appspotmail.com>
Subject: Re: [PATCH] bpf: Don't redirect packets with pkt_len 0
Thread-Topic: [PATCH] bpf: Don't redirect packets with pkt_len 0
Thread-Index: AdiCIxVtWh2F13e8R+GdQJ4vMdgHbA==
Date:   Sat, 18 Jun 2022 10:16:10 +0000
Message-ID: <a7c3605fa1ee4b899175fbdc36fe2799@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.136.114.155]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiBGcmksIEp1biAxNywgMjAyMiBhdCA5OjE5IEFNIERpIFpodSA8emh1ZGkyQGh1YXdlaS5j
b20+IHdyb3RlOg0KPiA+DQo+ID4gU3l6Ym90IGZvdW5kIGFuIGlzc3VlIFsxXTogZnFfY29kZWxf
ZHJvcCgpIHRyeSB0byBkcm9wIGEgZmxvdyB3aGl0b3V0IGFueQ0KPiA+IHNrYnMsIHRoYXQgaXMs
IHRoZSBmbG93LT5oZWFkIGlzIG51bGwuDQo+ID4gVGhlIHJvb3QgY2F1c2UsIGFzIHRoZSBbMl0g
c2F5cywgaXMgYmVjYXVzZSB0aGF0IGJwZl9wcm9nX3Rlc3RfcnVuX3NrYigpDQo+ID4gcnVuIGEg
YnBmIHByb2cgd2hpY2ggcmVkaXJlY3RzIGVtcHR5IHNrYnMuDQo+ID4gU28gd2Ugc2hvdWxkIGRl
dGVybWluZSB3aGV0aGVyIHRoZSBsZW5ndGggb2YgdGhlIHBhY2tldCBtb2RpZmllZCBieSBicGYN
Cj4gPiBwcm9nIG9yIG90aGVycyBsaWtlIGJwZl9wcm9nX3Rlc3QgaXMgMCBiZWZvcmUgZm9yd2Fy
ZGluZyBpdCBkaXJlY3RseS4NCj4gPg0KPiA+IExJTks6IFsxXQ0KPiBodHRwczovL3N5emthbGxl
ci5hcHBzcG90LmNvbS9idWc/aWQ9MGI4NGRhODBjMjkxNzc1NzkxNWFmYTg5Zjc3MzhhOWQxNmUN
Cj4gYzk2YzUNCj4gPiBMSU5LOiBbMl0gaHR0cHM6Ly93d3cuc3Bpbmljcy5uZXQvbGlzdHMvbmV0
ZGV2L21zZzc3NzUwMy5odG1sDQo+ID4NCj4gPiBSZXBvcnRlZC1ieTogc3l6Ym90KzdhMTI5MDk0
ODViOTQ0MjZhY2ViQHN5emthbGxlci5hcHBzcG90bWFpbC5jb20NCj4gPiBTaWduZWQtb2ZmLWJ5
OiBEaSBaaHUgPHpodWRpMkBodWF3ZWkuY29tPg0KPiA+IC0tLQ0KPiA+ICBuZXQvY29yZS9maWx0
ZXIuYyB8IDMgKysrDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykNCj4gPg0K
PiA+IGRpZmYgLS1naXQgYS9uZXQvY29yZS9maWx0ZXIuYyBiL25ldC9jb3JlL2ZpbHRlci5jDQo+
ID4gaW5kZXggNWFmNThlYjQ4NTg3Li5jN2ZiZmE5MDg5OGEgMTAwNjQ0DQo+ID4gLS0tIGEvbmV0
L2NvcmUvZmlsdGVyLmMNCj4gPiArKysgYi9uZXQvY29yZS9maWx0ZXIuYw0KPiA+IEBAIC0yMTU2
LDYgKzIxNTYsOSBAQCBzdGF0aWMgaW50IF9fYnBmX3JlZGlyZWN0X2NvbW1vbihzdHJ1Y3Qgc2tf
YnVmZg0KPiAqc2tiLCBzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LA0KPiA+ICBzdGF0aWMgaW50IF9f
YnBmX3JlZGlyZWN0KHN0cnVjdCBza19idWZmICpza2IsIHN0cnVjdCBuZXRfZGV2aWNlICpkZXYs
DQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICB1MzIgZmxhZ3MpDQo+ID4gIHsNCj4gPiAr
ICAgICAgIGlmICh1bmxpa2VseShza2ItPmxlbiA9PSAwKSkNCj4gPiArICAgICAgICAgICAgICAg
cmV0dXJuIC1FSU5WQUw7DQo+ID4gKw0KPiANCj4gWW91IGZvY3VzIGFnYWluIG9uIGZxX2NvZGVs
LCBidXQgd2UgaGF2ZSBhIG1vcmUgZ2VuZXJpYyBpc3N1ZSBhdCBoYW5kLg0KPiANCj4gSSBzYWlk
IHRoYXQgbW9zdCBkcml2ZXJzIHdpbGwgYXNzdW1lIHBhY2tldHMgYXJlIEV0aGVybmV0IG9uZXMs
IGhhdmluZw0KPiBhdCBsZWFzdCBhbiBFdGhlcm5ldCBoZWFkZXIgaW4gdGhlbS4NCg0KSSBvbmx5
IGZvY3VzZWQgb24gdGhpcyBwYXJ0aWN1bGFyIHRlc3QgY2FzZS4uLg0KdGhlIHN1Ym1pc3Npb24g
aW5mb3JtYXRpb24gc2hvdWxkIGJlIG1vZGlmaWVkIHRvIGRlc2NyaWJlIGEgZ2VuZXJhbCBwcm9i
bGVtLg0KIA0KPiBBbHNvIHJldHVybmluZyAtRUlOVkFMIHdpbGwgbGVhayB0aGUgc2tiIDovDQoN
Clllcy4uLiANCg0KPiANCj4gSSB0aGluayBhIGJldHRlciBmaXggd291bGQgYmUgdG8gbWFrZSBz
dXJlIHRoZSBza2IgY2FycmllcyBhbiBleHBlY3RlZA0KPiBwYWNrZXQgbGVuZ3RoLA0KPiBhbmQg
dGhpcyBwcm9iYWJseSBkaWZmZXJzIGluIF9fYnBmX3JlZGlyZWN0X2NvbW1vbigpIGFuZA0KPiBf
X2JwZl9yZWRpcmVjdF9ub19tYWMoKSA/DQoNCkRvZXMgdGhlIG5vIG1hYyBkZXZpY2UgbmVlZCB0
byBjaGVjayB0aGUgbGVuZ3RoIG9mIHRoZSBwYWNrYWdlPw0KDQo+IEN1cnJlbnQgdGVzdCBpbiBf
X2JwZl9yZWRpcmVjdF9jb21tb24oKSBzZWVtcyBub3QgZ29vZCBlbm91Z2guDQo+IA0KPiArICAg
ICAgIC8qIFZlcmlmeSB0aGF0IGEgbGluayBsYXllciBoZWFkZXIgaXMgY2FycmllZCAqLw0KPiAr
ICAgICAgIGlmICh1bmxpa2VseShza2ItPm1hY19oZWFkZXIgPj0gc2tiLT5uZXR3b3JrX2hlYWRl
cikpIHsNCj4gKyAgICAgICAgICAgICAgIGtmcmVlX3NrYihza2IpOw0KPiArICAgICAgICAgICAg
ICAgcmV0dXJuIC1FUkFOR0U7DQo+ICsgICAgICAgfQ0KPiArDQo+IA0KPiBJdCBzaG91bGQgY2hl
Y2sgdGhhdCB0aGUgbGluayBsYXllciBoZWFkZXIgc2l6ZSBpcyA+PSBkZXYtPm1pbl9oZWFkZXJf
bGVuDQoNCkl0IGlzIG9ubHkgdmFsaWQgZm9yIGRldmljZSB3aXRoIG1hYyBoZWFkZXIuIHN1Y2gg
YXMgaXAgdHVubmVsIGRldmljZSwgZGV2LT5taW5faGVhZGVyX2xlbg0KaGFzIG5vdCBzZXQuDQoN
Cj4gDQo+IA0KPiA+ICAgICAgICAgaWYgKGRldl9pc19tYWNfaGVhZGVyX3htaXQoZGV2KSkNCj4g
PiAgICAgICAgICAgICAgICAgcmV0dXJuIF9fYnBmX3JlZGlyZWN0X2NvbW1vbihza2IsIGRldiwg
ZmxhZ3MpOw0KPiA+ICAgICAgICAgZWxzZQ0KPiA+IC0tDQo+ID4gMi4yNy4wDQo+ID4NCg==
