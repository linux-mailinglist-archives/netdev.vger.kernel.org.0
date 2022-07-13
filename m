Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7B0C5736AD
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 14:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234672AbiGMMxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 08:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234676AbiGMMxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 08:53:41 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04AC96587;
        Wed, 13 Jul 2022 05:53:38 -0700 (PDT)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Ljcvj45v7zlVnv;
        Wed, 13 Jul 2022 20:52:01 +0800 (CST)
Received: from dggpeml500026.china.huawei.com (7.185.36.106) by
 canpemm500007.china.huawei.com (7.192.104.62) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 13 Jul 2022 20:53:36 +0800
Received: from dggpeml500026.china.huawei.com ([7.185.36.106]) by
 dggpeml500026.china.huawei.com ([7.185.36.106]) with mapi id 15.01.2375.024;
 Wed, 13 Jul 2022 20:53:36 +0800
From:   shaozhengchao <shaozhengchao@huawei.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        "sdf@google.com" <sdf@google.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "martin.lau@linux.dev" <martin.lau@linux.dev>,
        "song@kernel.org" <song@kernel.org>, "yhs@fb.com" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "weiyongjun (A)" <weiyongjun1@huawei.com>,
        yuehaibing <yuehaibing@huawei.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggYnBmLW5leHRdIGJwZjogRG9uJ3QgcmVkaXJlY3Qg?=
 =?utf-8?Q?packets_with_invalid_pkt=5Flen?=
Thread-Topic: [PATCH bpf-next] bpf: Don't redirect packets with invalid
 pkt_len
Thread-Index: AQHYleaLL8MWGRM12UO/vrEEAw5EYq16b1qAgAA2GQCAAYwHcA==
Date:   Wed, 13 Jul 2022 12:53:36 +0000
Message-ID: <d7f22715be8d477cbc3e6e545c219048@huawei.com>
References: <20220712120158.56325-1-shaozhengchao@huawei.com>
 <Ys2oPzt7Yn1oMou8@google.com>
 <f0bf3e9a-15e6-f5c8-1b2a-7866acfcb71b@iogearbox.net>
In-Reply-To: <f0bf3e9a-15e6-f5c8-1b2a-7866acfcb71b@iogearbox.net>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.178.66]
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

DQoNCi0tLS0t6YKu5Lu25Y6f5Lu2LS0tLS0NCuWPkeS7tuS6ujogRGFuaWVsIEJvcmttYW5uIFtt
YWlsdG86ZGFuaWVsQGlvZ2VhcmJveC5uZXRdIA0K5Y+R6YCB5pe26Ze0OiAyMDIy5bm0N+aciDEz
5pelIDQ6MTINCuaUtuS7tuS6ujogc2RmQGdvb2dsZS5jb207IHNoYW96aGVuZ2NoYW8gPHNoYW96
aGVuZ2NoYW9AaHVhd2VpLmNvbT4NCuaKhOmAgTogYnBmQHZnZXIua2VybmVsLm9yZzsgbmV0ZGV2
QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgZGF2ZW1AZGF2
ZW1sb2Z0Lm5ldDsgZWR1bWF6ZXRAZ29vZ2xlLmNvbTsga3ViYUBrZXJuZWwub3JnOyBwYWJlbmlA
cmVkaGF0LmNvbTsgaGF3a0BrZXJuZWwub3JnOyBhc3RAa2VybmVsLm9yZzsgYW5kcmlpQGtlcm5l
bC5vcmc7IG1hcnRpbi5sYXVAbGludXguZGV2OyBzb25nQGtlcm5lbC5vcmc7IHloc0BmYi5jb207
IGpvaG4uZmFzdGFiZW5kQGdtYWlsLmNvbTsga3BzaW5naEBrZXJuZWwub3JnOyB3ZWl5b25nanVu
IChBKSA8d2VpeW9uZ2p1bjFAaHVhd2VpLmNvbT47IHl1ZWhhaWJpbmcgPHl1ZWhhaWJpbmdAaHVh
d2VpLmNvbT4NCuS4u+mimDogUmU6IFtQQVRDSCBicGYtbmV4dF0gYnBmOiBEb24ndCByZWRpcmVj
dCBwYWNrZXRzIHdpdGggaW52YWxpZCBwa3RfbGVuDQoNCk9uIDcvMTIvMjIgNjo1OCBQTSwgc2Rm
QGdvb2dsZS5jb20gd3JvdGU6DQo+IE9uIDA3LzEyLCBaaGVuZ2NoYW8gU2hhbyB3cm90ZToNCj4+
IFN5emJvdCBmb3VuZCBhbiBpc3N1ZSBbMV06IGZxX2NvZGVsX2Ryb3AoKSB0cnkgdG8gZHJvcCBh
IGZsb3cgd2hpdG91dCANCj4+IGFueSBza2JzLCB0aGF0IGlzLCB0aGUgZmxvdy0+aGVhZCBpcyBu
dWxsLg0KPj4gVGhlIHJvb3QgY2F1c2UsIGFzIHRoZSBbMl0gc2F5cywgaXMgYmVjYXVzZSB0aGF0
IA0KPj4gYnBmX3Byb2dfdGVzdF9ydW5fc2tiKCkgcnVuIGEgYnBmIHByb2cgd2hpY2ggcmVkaXJl
Y3RzIGVtcHR5IHNrYnMuDQo+PiBTbyB3ZSBzaG91bGQgZGV0ZXJtaW5lIHdoZXRoZXIgdGhlIGxl
bmd0aCBvZiB0aGUgcGFja2V0IG1vZGlmaWVkIGJ5IA0KPj4gYnBmIHByb2cgb3Igb3RoZXJzIGxp
a2UgYnBmX3Byb2dfdGVzdCBpcyB2YWxpZCBiZWZvcmUgZm9yd2FyZGluZyBpdCBkaXJlY3RseS4N
Cj4gDQo+PiBMSU5LOiBbMV0gDQo+PiBodHRwczovL3N5emthbGxlci5hcHBzcG90LmNvbS9idWc/
aWQ9MGI4NGRhODBjMjkxNzc1NzkxNWFmYTg5Zjc3MzhhOWQNCj4+IDE2ZWM5NmM1DQo+PiBMSU5L
OiBbMl0gaHR0cHM6Ly93d3cuc3Bpbmljcy5uZXQvbGlzdHMvbmV0ZGV2L21zZzc3NzUwMy5odG1s
DQo+IA0KPj4gUmVwb3J0ZWQtYnk6IHN5emJvdCs3YTEyOTA5NDg1Yjk0NDI2YWNlYkBzeXprYWxs
ZXIuYXBwc3BvdG1haWwuY29tDQo+PiBTaWduZWQtb2ZmLWJ5OiBaaGVuZ2NoYW8gU2hhbyA8c2hh
b3poZW5nY2hhb0BodWF3ZWkuY29tPg0KPj4gLS0tDQo+PiDCoCBuZXQvY29yZS9maWx0ZXIuYyB8
IDkgKysrKysrKystDQo+PiDCoCAxIGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCAxIGRl
bGV0aW9uKC0pDQo+IA0KPj4gZGlmZiAtLWdpdCBhL25ldC9jb3JlL2ZpbHRlci5jIGIvbmV0L2Nv
cmUvZmlsdGVyLmMgaW5kZXggDQo+PiA0ZWY3N2VjNTI1NWUuLjI3ODAxYjMxNDk2MCAxMDA2NDQN
Cj4+IC0tLSBhL25ldC9jb3JlL2ZpbHRlci5jDQo+PiArKysgYi9uZXQvY29yZS9maWx0ZXIuYw0K
Pj4gQEAgLTIxMjIsNiArMjEyMiwxMSBAQCBzdGF0aWMgaW50IF9fYnBmX3JlZGlyZWN0X25vX21h
YyhzdHJ1Y3QgDQo+PiBza19idWZmICpza2IsIHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsDQo+PiDC
oCB7DQo+PiDCoMKgwqDCoMKgIHVuc2lnbmVkIGludCBtbGVuID0gc2tiX25ldHdvcmtfb2Zmc2V0
KHNrYik7DQo+IA0KPj4gK8KgwqDCoCBpZiAodW5saWtlbHkoc2tiLT5sZW4gPT0gMCkpIHsNCj4+
ICvCoMKgwqDCoMKgwqDCoCBrZnJlZV9za2Ioc2tiKTsNCj4+ICvCoMKgwqDCoMKgwqDCoCByZXR1
cm4gLUVJTlZBTDsNCj4+ICvCoMKgwqAgfQ0KPj4gKw0KPj4gwqDCoMKgwqDCoCBpZiAobWxlbikg
ew0KPj4gwqDCoMKgwqDCoMKgwqDCoMKgIF9fc2tiX3B1bGwoc2tiLCBtbGVuKTsNCj4gDQo+PiBA
QCAtMjE0Myw3ICsyMTQ4LDkgQEAgc3RhdGljIGludCBfX2JwZl9yZWRpcmVjdF9jb21tb24oc3Ry
dWN0IHNrX2J1ZmYgDQo+PiAqc2tiLCBzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LA0KPj4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHUzMiBmbGFncykNCj4+IMKgIHsNCj4+IMKg
wqDCoMKgwqAgLyogVmVyaWZ5IHRoYXQgYSBsaW5rIGxheWVyIGhlYWRlciBpcyBjYXJyaWVkICov
DQo+PiAtwqDCoMKgIGlmICh1bmxpa2VseShza2ItPm1hY19oZWFkZXIgPj0gc2tiLT5uZXR3b3Jr
X2hlYWRlcikpIHsNCj4+ICvCoMKgwqAgaWYgKHVubGlrZWx5KHNrYi0+bWFjX2hlYWRlciA+PSBz
a2ItPm5ldHdvcmtfaGVhZGVyKSB8fA0KPj4gK8KgwqDCoMKgwqDCoMKgIChtaW5fdCh1MzIsIHNr
Yl9tYWNfaGVhZGVyX2xlbihza2IpLCBza2ItPmxlbikgPA0KPj4gK8KgwqDCoMKgwqDCoMKgwqAg
KHUzMilkZXYtPm1pbl9oZWFkZXJfbGVuKSkgew0KPiANCj4gV2h5IGNoZWNrIHNrYi0+bGVuICE9
IDAgYWJvdmUgYnV0IHNrYi0+bGVuIDwgZGV2LT5taW5faGVhZGVyX2xlbiBoZXJlPw0KPiBJIGd1
ZXNzIGl0IGRvZXNuJ3QgbWFrZSBzZW5zZSBpbiBfX2JwZl9yZWRpcmVjdF9ub19tYWMgYmVjYXVz
ZSB3ZSBrbm93IA0KPiB0aGF0IG1hYyBpcyBlbXB0eSwgYnV0IHdoeSBkbyB3ZSBjYXJlIGluIF9f
YnBmX3JlZGlyZWN0X2NvbW1vbj8NCj4gV2h5IG5vdCBwdXQgdGhpcyBjaGVjayBpbiB0aGUgY29t
bW9uIF9fYnBmX3JlZGlyZWN0Pw0KPiANCj4gQWxzbywgaXQncyBzdGlsbCBub3QgY2xlYXIgdG8g
bWUgd2hldGhlciB3ZSBzaG91bGQgYmFrZSBpdCBpbnRvIHRoZSANCj4gY29yZSBzdGFjayB2cyBo
YXZpbmcgc29tZSBzcGVjaWFsIGNoZWNrcyBmcm9tIHRlc3RfcHJvZ19ydW4gb25seS4gSSdtIA0K
PiBhc3N1bWluZyB0aGUgaXNzdWUgaXMgdGhhdCB3ZSBjYW4gY29uc3RydWN0IGlsbGVnYWwgc2ti
cyB3aXRoIHRoYXQgDQo+IHRlc3RfcHJvZ19ydW4gaW50ZXJmYWNlLCBzbyBtYXliZSBzdGFydCBi
eSBmaXhpbmcgdGhhdD8NCg0KQWdyZWUsIGlkZWFsbHkgd2UgY2FuIHByZXZlbnQgaXQgcmlnaHQg
YXQgdGhlIHNvdXJjZSByYXRoZXIgdGhhbiBhZGRpbmcgbW9yZSB0ZXN0cyBpbnRvIHRoZSBmYXN0
LXBhdGguDQoNCj4gRGlkIHlvdSBoYXZlIGEgY2hhbmNlIHRvIGxvb2sgYXQgdGhlIHJlcHJvZHVj
ZXIgbW9yZSBjbG9zZWx5PyBXaGF0IA0KPiBleGFjdGx5IGlzIGl0IGRvaW5nPw0KPiANCj4+IMKg
wqDCoMKgwqDCoMKgwqDCoCBrZnJlZV9za2Ioc2tiKTsNCj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBy
ZXR1cm4gLUVSQU5HRTsNCj4+IMKgwqDCoMKgwqAgfQ0KPj4gLS0NCj4+IDIuMTcuMQ0KDQo+IA0K
DQoNCkhpIERhbmllbCBhbmQgc2RmOg0KCVRoYW5rIHlvdSBmb3IgeW91ciByZXBseS4gSSByZWFk
IHRoZSBwb2MgY29kZSBjYXJlZnVsbHksIGFuZCBJIHRoaW5rIHRoZSBjdXJyZW50IGNhbGwgc3Rh
Y2sgaXMgbGlrZToNCnN5c19icGYoQlBGX1BST0dfVEVTVF9SVU4sICZhdHRyLCBzaXplb2YoYXR0
cikpIC0+IGJwZl9wcm9nX3Rlc3RfcnVuLT5icGZfcHJvZ190ZXN0X3J1bl9za2IuDQoNCkluIGZ1
bmN0aW9uIGJwZl9wcm9nX3Rlc3RfcnVuX3NrYiwgcHJvY2VkdXJlIHdpbGwgdXNlIGJ1aWxkX3Nr
YiB0byBnZW5lcmF0ZSBhIG5ldyBza2IuIFBvYyBjb2RlIHBhc3MNCmEgMTRCeXRlIHBhY2tldCBm
b3IgZGlyZWN0LiBGaXJzdCAsc2tiLT5sZW4gPSAxNCwgYnV0IGFmdGVyIHRyYW5zIGV0aCB0eXBl
LCB0aGUgbGVuID0gMDsgYnV0IGlzX2wyIGlzIGZhbHNlLCANCnNvIGxlbj0wIHdoZW4gcnVuIGJw
Zl90ZXN0X3J1bi4gSXMgaXQgcG9zc2libGUgdG8gYWRkIGNoZWNrIGluIGNvbnZlcnRfX19za2Jf
dG9fc2tiPyBXaGVuIHNrYi0+bGVuPTAsDQp3ZSBkcm9wIHRoZSBwYWNrZXQuDQoNCkJ1dCwgaWYg
c29tZSBvdGhlciBwYXRocyBjYWxsIGJwZiByZWRpcmVjdCB3aXRoIHNrYi0+bGVuPTAsIHRoaXMg
aXMgbm90IGVmZmVjdGl2ZSwgc3VjaCBhcyBzb21lIGRyaXZlciBjYWxsIHJlZGlyZWN0IGZ1Y3Rp
b24uDQpJIGRvbid0IGtub3cgaWYgSSdtIHRoaW5raW5nIHJpZ2h0Lg0KDQpUaGFuayB5b3UuDQoN
ClpoZW5nY2hhbyBTaGFvDQoNCg0K
