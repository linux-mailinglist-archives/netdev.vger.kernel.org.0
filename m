Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B99BC5BA722
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 09:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiIPHE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 03:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiIPHEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 03:04:55 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E831113E2C
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 00:04:51 -0700 (PDT)
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MTQ4j5QfrzBsPJ;
        Fri, 16 Sep 2022 15:02:45 +0800 (CST)
Received: from canpemm500010.china.huawei.com (7.192.105.118) by
 canpemm500009.china.huawei.com (7.192.105.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 16 Sep 2022 15:04:49 +0800
Received: from canpemm500010.china.huawei.com ([7.192.105.118]) by
 canpemm500010.china.huawei.com ([7.192.105.118]) with mapi id 15.01.2375.031;
 Fri, 16 Sep 2022 15:04:49 +0800
From:   "liujian (CE)" <liujian56@huawei.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     davem <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev <netdev@vger.kernel.org>
Subject: RE: [PATCH net v2] tun: Check tun device queue status in
 tun_chr_write_iter
Thread-Topic: [PATCH net v2] tun: Check tun device queue status in
 tun_chr_write_iter
Thread-Index: AQHYyP9nvmBFbYGOpkqq8SJtjCePoa3gxwqAgADYWAA=
Date:   Fri, 16 Sep 2022 07:04:49 +0000
Message-ID: <fa004a0ba281415a886f2e93d4da8f85@huawei.com>
References: <20220915123539.35956-1-liujian56@huawei.com>
 <CACGkMEsXYAHTb40jbtr35=O2NgJHHNkC_E2b8bqxygrmLOtRbQ@mail.gmail.com>
In-Reply-To: <CACGkMEsXYAHTb40jbtr35=O2NgJHHNkC_E2b8bqxygrmLOtRbQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.93]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFzb24gV2FuZyBbbWFp
bHRvOmphc293YW5nQHJlZGhhdC5jb21dDQo+IFNlbnQ6IEZyaWRheSwgU2VwdGVtYmVyIDE2LCAy
MDIyIDk6NTcgQU0NCj4gVG86IGxpdWppYW4gKENFKSA8bGl1amlhbjU2QGh1YXdlaS5jb20+DQo+
IENjOiBkYXZlbSA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEVyaWMgRHVtYXpldA0KPiA8ZWR1bWF6
ZXRAZ29vZ2xlLmNvbT47IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBQYW9sbyBB
YmVuaQ0KPiA8cGFiZW5pQHJlZGhhdC5jb20+OyBBbGV4ZWkgU3Rhcm92b2l0b3YgPGFzdEBrZXJu
ZWwub3JnPjsgRGFuaWVsDQo+IEJvcmttYW5uIDxkYW5pZWxAaW9nZWFyYm94Lm5ldD47IEplc3Bl
ciBEYW5nYWFyZCBCcm91ZXINCj4gPGhhd2tAa2VybmVsLm9yZz47IEpvaG4gRmFzdGFiZW5kIDxq
b2huLmZhc3RhYmVuZEBnbWFpbC5jb20+OyBuZXRkZXYNCj4gPG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmc+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0IHYyXSB0dW46IENoZWNrIHR1biBkZXZpY2Ug
cXVldWUgc3RhdHVzIGluDQo+IHR1bl9jaHJfd3JpdGVfaXRlcg0KPiANCj4gT24gVGh1LCBTZXAg
MTUsIDIwMjIgYXQgODozNCBQTSBMaXUgSmlhbiA8bGl1amlhbjU2QGh1YXdlaS5jb20+IHdyb3Rl
Og0KPiA+DQo+ID4gc3l6Ym90IGZvdW5kIGJlbG93IHdhcm5pbmc6DQo+ID4NCj4gPiAtLS0tLS0t
LS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0NCj4gPiBnZW5ldmUwIHJlY2VpdmVkIHBhY2tl
dCBvbiBxdWV1ZSAzLCBidXQgbnVtYmVyIG9mIFJYIHF1ZXVlcyBpcyAzDQo+ID4gV0FSTklORzog
Q1BVOiAxIFBJRDogMjk3MzQgYXQgbmV0L2NvcmUvZGV2LmM6NDYxMSBuZXRpZl9nZXRfcnhxdWV1
ZQ0KPiA+IG5ldC9jb3JlL2Rldi5jOjQ2MTEgW2lubGluZV0NCj4gPiBXQVJOSU5HOiBDUFU6IDEg
UElEOiAyOTczNCBhdCBuZXQvY29yZS9kZXYuYzo0NjExDQo+ID4gbmV0aWZfcmVjZWl2ZV9nZW5l
cmljX3hkcCsweGIxMC8weGI1MCBuZXQvY29yZS9kZXYuYzo0NjgzIE1vZHVsZXMNCj4gbGlua2Vk
IGluOg0KPiA+IENQVTogMSBQSUQ6IDI5NzM0IENvbW06IHN5ei1leGVjdXRvci4wIE5vdCB0YWlu
dGVkIDUuMTAuMCAjNSBIYXJkd2FyZQ0KPiA+IG5hbWU6IGxpbnV4LGR1bW15LXZpcnQgKERUKQ0K
PiA+IHBzdGF0ZTogNjA0MDAwMDUgKG5aQ3YgZGFpZiArUEFOIC1VQU8gLVRDTyBCVFlQRT0tLSkg
cGMgOg0KPiA+IG5ldGlmX2dldF9yeHF1ZXVlIG5ldC9jb3JlL2Rldi5jOjQ2MTEgW2lubGluZV0g
cGMgOg0KPiA+IG5ldGlmX3JlY2VpdmVfZ2VuZXJpY194ZHArMHhiMTAvMHhiNTAgbmV0L2NvcmUv
ZGV2LmM6NDY4MyBsciA6DQo+ID4gbmV0aWZfZ2V0X3J4cXVldWUgbmV0L2NvcmUvZGV2LmM6NDYx
MSBbaW5saW5lXSBsciA6DQo+ID4gbmV0aWZfcmVjZWl2ZV9nZW5lcmljX3hkcCsweGIxMC8weGI1
MCBuZXQvY29yZS9kZXYuYzo0NjgzIHNwIDoNCj4gPiBmZmZmYTAwMDE2MTI3NzcwDQo+ID4geDI5
OiBmZmZmYTAwMDE2MTI3NzcwIHgyODogZmZmZjNmNDYwN2Q2YWNiNA0KPiA+IHgyNzogZmZmZjNm
NDYwN2Q2YWNiMCB4MjY6IGZmZmYzZjQ2MDdkNmFkMjANCj4gPiB4MjU6IGZmZmYzZjQ2MWRlM2Mw
MDAgeDI0OiBmZmZmM2Y0NjA3ZDZhZDI4DQo+ID4geDIzOiBmZmZmYTAwMDEwMDU5MDAwIHgyMjog
ZmZmZjNmNDYwODcxOTEwMA0KPiA+IHgyMTogMDAwMDAwMDAwMDAwMDAwMyB4MjA6IGZmZmZhMDAw
MTYxMjc4YTANCj4gPiB4MTk6IGZmZmYzZjQ2MDdkNmFjNDAgeDE4OiAwMDAwMDAwMDAwMDAwMDAw
DQo+ID4geDE3OiAwMDAwMDAwMDAwMDAwMDAwIHgxNjogMDAwMDAwMDBmMmYyZjIwNA0KPiA+IHgx
NTogMDAwMDAwMDBmMmYyMDAwMCB4MTQ6IDY0NjU3NjY5NjU2MzY1NzINCj4gPiB4MTM6IDIwMzA2
NTc2NjU2ZTY1NjcgeDEyOiBmZmZmOThiOGVkM2I5MjRkDQo+ID4geDExOiAxZmZmZjhiOGVkM2I5
MjRjIHgxMDogZmZmZjk4YjhlZDNiOTI0Yw0KPiA+IHg5IDogZmZmZmM1Yzc2NTI1YzljNCB4OCA6
IDAwMDAwMDAwMDAwMDAwMDANCj4gPiB4NyA6IDAwMDAwMDAwMDAwMDAwMDEgeDYgOiBmZmZmOThi
OGVkM2I5MjRjDQo+ID4geDUgOiBmZmZmM2Y0NjBmM2IyOWMwIHg0IDogZGZmZmEwMDAwMDAwMDAw
MA0KPiA+IHgzIDogZmZmZmM1Yzc2NTAwMDAwMCB4MiA6IDAwMDAwMDAwMDAwMDAwMDANCj4gPiB4
MSA6IDAwMDAwMDAwMDAwMDAwMDAgeDAgOiBmZmZmM2Y0NjBmM2IyOWMwIENhbGwgdHJhY2U6DQo+
ID4gIG5ldGlmX2dldF9yeHF1ZXVlIG5ldC9jb3JlL2Rldi5jOjQ2MTEgW2lubGluZV0NCj4gPiAg
bmV0aWZfcmVjZWl2ZV9nZW5lcmljX3hkcCsweGIxMC8weGI1MCBuZXQvY29yZS9kZXYuYzo0Njgz
DQo+ID4gZG9feGRwX2dlbmVyaWMgbmV0L2NvcmUvZGV2LmM6NDc3NyBbaW5saW5lXQ0KPiA+ICBk
b194ZHBfZ2VuZXJpYysweDljLzB4MTkwIG5ldC9jb3JlL2Rldi5jOjQ3NzANCj4gPiAgdHVuX2dl
dF91c2VyKzB4ZDk0LzB4MjAxMCBkcml2ZXJzL25ldC90dW4uYzoxOTM4DQo+ID4gIHR1bl9jaHJf
d3JpdGVfaXRlcisweDk4LzB4MTAwIGRyaXZlcnMvbmV0L3R1bi5jOjIwMzYgIGNhbGxfd3JpdGVf
aXRlcg0KPiA+IGluY2x1ZGUvbGludXgvZnMuaDoxOTYwIFtpbmxpbmVdDQo+ID4gIG5ld19zeW5j
X3dyaXRlKzB4MjYwLzB4MzcwIGZzL3JlYWRfd3JpdGUuYzo1MTUgIHZmc193cml0ZSsweDUxYy8w
eDYxYw0KPiA+IGZzL3JlYWRfd3JpdGUuYzo2MDINCj4gPiAga3N5c193cml0ZSsweGZjLzB4MjAw
IGZzL3JlYWRfd3JpdGUuYzo2NTUgIF9fZG9fc3lzX3dyaXRlDQo+ID4gZnMvcmVhZF93cml0ZS5j
OjY2NyBbaW5saW5lXSAgX19zZV9zeXNfd3JpdGUgZnMvcmVhZF93cml0ZS5jOjY2NA0KPiA+IFtp
bmxpbmVdDQo+ID4gIF9fYXJtNjRfc3lzX3dyaXRlKzB4NTAvMHg2MCBmcy9yZWFkX3dyaXRlLmM6
NjY0ICBfX2ludm9rZV9zeXNjYWxsDQo+ID4gYXJjaC9hcm02NC9rZXJuZWwvc3lzY2FsbC5jOjM2
IFtpbmxpbmVdICBpbnZva2Vfc3lzY2FsbA0KPiA+IGFyY2gvYXJtNjQva2VybmVsL3N5c2NhbGwu
Yzo0OCBbaW5saW5lXQ0KPiA+ICBlbDBfc3ZjX2NvbW1vbi5jb25zdHByb3AuMCsweGY0LzB4NDE0
IGFyY2gvYXJtNjQva2VybmVsL3N5c2NhbGwuYzoxNTUNCj4gPiBkb19lbDBfc3ZjKzB4NTAvMHgx
MWMgYXJjaC9hcm02NC9rZXJuZWwvc3lzY2FsbC5jOjIxNw0KPiA+ICBlbDBfc3ZjKzB4MjAvMHgz
MCBhcmNoL2FybTY0L2tlcm5lbC9lbnRyeS1jb21tb24uYzozNTMNCj4gPiAgZWwwX3N5bmNfaGFu
ZGxlcisweGU0LzB4MWUwIGFyY2gvYXJtNjQva2VybmVsL2VudHJ5LWNvbW1vbi5jOjM2OQ0KPiA+
ICBlbDBfc3luYysweDE0OC8weDE4MCBhcmNoL2FybTY0L2tlcm5lbC9lbnRyeS5TOjY4Mw0KPiA+
DQo+ID4gVGhpcyBpcyBiZWNhdXNlIHRoZSBkZXRhY2hlZCBxdWV1ZSBpcyB1c2VkIHRvIHNlbmQg
ZGF0YS4gVGhlcmVmb3JlLCB3ZQ0KPiA+IG5lZWQgdG8gY2hlY2sgdGhlIHF1ZXVlIHN0YXR1cyBp
biB0aGUgdHVuX2Nocl93cml0ZV9pdGVyIGZ1bmN0aW9uLg0KPiA+DQo+ID4gRml4ZXM6IGNkZThi
MTVmMWFhYiAoInR1bnRhcDogYWRkIGlvY3RsIHRvIGF0dGFjaCBvciBkZXRhY2ggYSBmaWxlDQo+
ID4gZm9ybSB0dW50YXAgZGV2aWNlIikNCj4gDQo+IE5vdCBzdXJlIHRoaXMgZGVzZXJ2ZXMgYSBz
dGFibGUuDQo+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IExpdSBKaWFuIDxsaXVqaWFuNTZAaHVhd2Vp
LmNvbT4NCj4gPiAtLS0NCj4gPiB2MS0+djI6IGFkZCBmaXhlcyB0YWcNCj4gPiAgZHJpdmVycy9u
ZXQvdHVuLmMgfCA1ICsrKysrDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKykN
Cj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC90dW4uYyBiL2RyaXZlcnMvbmV0L3R1
bi5jIGluZGV4DQo+ID4gMjU5YjJiODRiMmIzLi4yNjE0MTFjMWE2YmIgMTAwNjQ0DQo+ID4gLS0t
IGEvZHJpdmVycy9uZXQvdHVuLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC90dW4uYw0KPiA+IEBA
IC0yMDE5LDYgKzIwMTksMTEgQEAgc3RhdGljIHNzaXplX3QgdHVuX2Nocl93cml0ZV9pdGVyKHN0
cnVjdCBraW9jYg0KPiAqaW9jYiwgc3RydWN0IGlvdl9pdGVyICpmcm9tKQ0KPiA+ICAgICAgICAg
aWYgKCF0dW4pDQo+ID4gICAgICAgICAgICAgICAgIHJldHVybiAtRUJBREZEOw0KPiA+DQo+ID4g
KyAgICAgICBpZiAodGZpbGUtPmRldGFjaGVkKSB7DQo+IA0KPiB0ZmlsZS0+ZGV0YWNoZWQgaXMg
c3luY2hyb25pemVkIHRocm91Z2ggcnRubF9sb2NrIHdoaWNoIGlzIHByb2JhYmx5DQo+IG5vdCBz
dWl0YWJsZSBmb3IgdGhlIGRhdGFwYXRoLiBXZSBwcm9iYWJseSBuZWVkIHRvIHJjdWlmeSB0aGlz
Lg0KPiANCj4gPiArICAgICAgICAgICAgICAgdHVuX3B1dCh0dW4pOw0KPiA+ICsgICAgICAgICAg
ICAgICByZXR1cm4gLUVORVRET1dOOw0KPiANCj4gQW5vdGhlciBxdWVzdGlvbiBpcyB0aGF0IGNh
biBzb21lIHVzZXIgc3BhY2UgZGVwZW5kIG9uIHRoaXMgYmVoYXZpb3VyPw0KPiBJIHdvbmRlciBp
ZiBpdCdzIG1vcmUgc2FmZSB0byBwcmV0ZW5kIHRoZSBwYWNrZXQgd2FzIHJlY2VpdmVkIGhlcmU/
DQo+IA0KVGhhbmtzIGZvciB5b3VyIHJldmlldy4gSSBkb24ndCBrbm93IHdoZXRoZXIgdGhlcmUg
d2FzIGFueSBkZXBlbmQgb24gdGhpcyBiZWhhdmlvci4NCklmIHRoYXQncyB0aGUgY2FzZSwgSSB0
aGluayBpdCdzIGJldHRlciB0byBrZWVwIHRoaXMgd2FybmluZy4NCldoYXQgaXMgeW91ciBvcGlu
aW9uIG9uIHRoaXMgd2FybmluZz8NCg0KPiBUaGFua3MNCj4gDQo+ID4gKyAgICAgICB9DQo+ID4g
Kw0KPiA+ICAgICAgICAgaWYgKChmaWxlLT5mX2ZsYWdzICYgT19OT05CTE9DSykgfHwgKGlvY2It
PmtpX2ZsYWdzICYgSU9DQl9OT1dBSVQpKQ0KPiA+ICAgICAgICAgICAgICAgICBub2Jsb2NrID0g
MTsNCj4gPg0KPiA+IC0tDQo+ID4gMi4xNy4xDQo+ID4NCg0K
