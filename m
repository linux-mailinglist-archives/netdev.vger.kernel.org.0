Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7083453B675
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 11:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233269AbiFBJ7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 05:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233072AbiFBJ7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 05:59:47 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9388FDF18;
        Thu,  2 Jun 2022 02:59:45 -0700 (PDT)
Received: from canpemm100010.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LDM0r3d5tzjXNk;
        Thu,  2 Jun 2022 17:58:52 +0800 (CST)
Received: from dggpeml500026.china.huawei.com (7.185.36.106) by
 canpemm100010.china.huawei.com (7.192.104.38) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 2 Jun 2022 17:59:43 +0800
Received: from dggpeml500026.china.huawei.com ([7.185.36.106]) by
 dggpeml500026.china.huawei.com ([7.185.36.106]) with mapi id 15.01.2375.024;
 Thu, 2 Jun 2022 17:59:43 +0800
From:   shaozhengchao <shaozhengchao@huawei.com>
To:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>
CC:     "weiyongjun (A)" <weiyongjun1@huawei.com>,
        yuehaibing <yuehaibing@huawei.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggdjUsYnBmLW5leHRdIHNhbXBsZXMvYnBmOiBjaGVj?=
 =?utf-8?Q?k_detach_prog_exist_or_not_in_xdp=5Ffwd?=
Thread-Topic: [PATCH v5,bpf-next] samples/bpf: check detach prog exist or not
 in xdp_fwd
Thread-Index: AQHYdh3mfF3YsnAkakOXItICkqOZQK07SqEAgACXBnA=
Date:   Thu, 2 Jun 2022 09:59:43 +0000
Message-ID: <f7e88b843e964632919c8efe16368786@huawei.com>
References: <20220602011915.264431-1-shaozhengchao@huawei.com>
 <87v8tjsavb.fsf@toke.dk>
In-Reply-To: <87v8tjsavb.fsf@toke.dk>
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

DQoNCi0tLS0t6YKu5Lu25Y6f5Lu2LS0tLS0NCuWPkeS7tuS6ujogVG9rZSBIw7hpbGFuZC1Kw7hy
Z2Vuc2VuIFttYWlsdG86dG9rZUBrZXJuZWwub3JnXSANCuWPkemAgeaXtumXtDogMjAyMuW5tDbm
nIgy5pelIDE2OjU1DQrmlLbku7bkuro6IHNoYW96aGVuZ2NoYW8gPHNoYW96aGVuZ2NoYW9AaHVh
d2VpLmNvbT47IGJwZkB2Z2VyLmtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxp
bnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGFzdEBrZXJuZWwub3JnOyBkYW5pZWxAaW9nZWFy
Ym94Lm5ldDsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOyBoYXdrQGtlcm5l
bC5vcmc7IGpvaG4uZmFzdGFiZW5kQGdtYWlsLmNvbTsgYW5kcmlpQGtlcm5lbC5vcmc7IGthZmFp
QGZiLmNvbTsgc29uZ2xpdWJyYXZpbmdAZmIuY29tOyB5aHNAZmIuY29tOyBrcHNpbmdoQGtlcm5l
bC5vcmcNCuaKhOmAgTogd2VpeW9uZ2p1biAoQSkgPHdlaXlvbmdqdW4xQGh1YXdlaS5jb20+OyBz
aGFvemhlbmdjaGFvIDxzaGFvemhlbmdjaGFvQGh1YXdlaS5jb20+OyB5dWVoYWliaW5nIDx5dWVo
YWliaW5nQGh1YXdlaS5jb20+DQrkuLvpopg6IFJlOiBbUEFUQ0ggdjUsYnBmLW5leHRdIHNhbXBs
ZXMvYnBmOiBjaGVjayBkZXRhY2ggcHJvZyBleGlzdCBvciBub3QgaW4geGRwX2Z3ZA0KDQpaaGVu
Z2NoYW8gU2hhbyA8c2hhb3poZW5nY2hhb0BodWF3ZWkuY29tPiB3cml0ZXM6DQoNCj4gQmVmb3Jl
IGRldGFjaCB0aGUgcHJvZywgd2Ugc2hvdWxkIGNoZWNrIGRldGFjaCBwcm9nIGV4aXN0IG9yIG5v
dC4NCj4NCj4gU2lnbmVkLW9mZi1ieTogWmhlbmdjaGFvIFNoYW8gPHNoYW96aGVuZ2NoYW9AaHVh
d2VpLmNvbT4NCg0KWW91IG1pc3NlZCBvbmUgJ3JldHVybiBlcnJubycsIHNlZSBiZWxvdzoNCg0K
PiAtLS0NCj4gIHNhbXBsZXMvYnBmL3hkcF9md2RfdXNlci5jIHwgNTUgDQo+ICsrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKy0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgNDkgaW5zZXJ0
aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCj4NCj4gZGlmZiAtLWdpdCBhL3NhbXBsZXMvYnBmL3hk
cF9md2RfdXNlci5jIGIvc2FtcGxlcy9icGYveGRwX2Z3ZF91c2VyLmMgDQo+IGluZGV4IDE4Mjg0
ODdiYWU5YS4uZDMyMWU2YWE5MzY0IDEwMDY0NA0KPiAtLS0gYS9zYW1wbGVzL2JwZi94ZHBfZndk
X3VzZXIuYw0KPiArKysgYi9zYW1wbGVzL2JwZi94ZHBfZndkX3VzZXIuYw0KPiBAQCAtNDcsMTcg
KzQ3LDYwIEBAIHN0YXRpYyBpbnQgZG9fYXR0YWNoKGludCBpZHgsIGludCBwcm9nX2ZkLCBpbnQg
bWFwX2ZkLCBjb25zdCBjaGFyICpuYW1lKQ0KPiAgCXJldHVybiBlcnI7DQo+ICB9DQo+ICANCj4g
LXN0YXRpYyBpbnQgZG9fZGV0YWNoKGludCBpZHgsIGNvbnN0IGNoYXIgKm5hbWUpDQo+ICtzdGF0
aWMgaW50IGRvX2RldGFjaChpbnQgaWZpbmRleCwgY29uc3QgY2hhciAqaWZuYW1lLCBjb25zdCBj
aGFyIA0KPiArKmFwcF9uYW1lKQ0KPiAgew0KPiAtCWludCBlcnI7DQo+ICsJTElCQlBGX09QVFMo
YnBmX3hkcF9hdHRhY2hfb3B0cywgb3B0cyk7DQo+ICsJc3RydWN0IGJwZl9wcm9nX2luZm8gcHJv
Z19pbmZvID0ge307DQo+ICsJY2hhciBwcm9nX25hbWVbQlBGX09CSl9OQU1FX0xFTl07DQo+ICsJ
X191MzIgaW5mb19sZW4sIGN1cnJfcHJvZ19pZDsNCj4gKwlpbnQgcHJvZ19mZDsNCj4gKwlpbnQg
ZXJyID0gMTsNCj4gKw0KPiArCWlmIChicGZfeGRwX3F1ZXJ5X2lkKGlmaW5kZXgsIHhkcF9mbGFn
cywgJmN1cnJfcHJvZ19pZCkpIHsNCj4gKwkJcHJpbnRmKCJFUlJPUjogYnBmX3hkcF9xdWVyeV9p
ZCBmYWlsZWQgKCVzKVxuIiwNCj4gKwkJICAgICAgIHN0cmVycm9yKGVycm5vKSk7DQo+ICsJCXJl
dHVybiBlcnI7DQo+ICsJfQ0KPiAgDQo+IC0JZXJyID0gYnBmX3hkcF9kZXRhY2goaWR4LCB4ZHBf
ZmxhZ3MsIE5VTEwpOw0KPiAtCWlmIChlcnIgPCAwKQ0KPiAtCQlwcmludGYoIkVSUk9SOiBmYWls
ZWQgdG8gZGV0YWNoIHByb2dyYW0gZnJvbSAlc1xuIiwgbmFtZSk7DQo+ICsJaWYgKCFjdXJyX3By
b2dfaWQpIHsNCj4gKwkJcHJpbnRmKCJFUlJPUjogZmxhZ3MoMHgleCkgeGRwIHByb2cgaXMgbm90
IGF0dGFjaGVkIHRvICVzXG4iLA0KPiArCQkgICAgICAgeGRwX2ZsYWdzLCBpZm5hbWUpOw0KPiAr
CQlyZXR1cm4gZXJyOw0KPiArCX0NCj4gIA0KPiArCWluZm9fbGVuID0gc2l6ZW9mKHByb2dfaW5m
byk7DQo+ICsJcHJvZ19mZCA9IGJwZl9wcm9nX2dldF9mZF9ieV9pZChjdXJyX3Byb2dfaWQpOw0K
PiArCWlmIChwcm9nX2ZkIDwgMCkgew0KPiArCQlwcmludGYoIkVSUk9SOiBicGZfcHJvZ19nZXRf
ZmRfYnlfaWQgZmFpbGVkICglcylcbiIsDQo+ICsJCSAgICAgICBzdHJlcnJvcihlcnJubykpOw0K
PiArCQlyZXR1cm4gZXJybm87DQoNClRoaXMgc2hvdWxkIGp1c3QgYmUgJyByZXR1cm4gcHJvZ19m
ZCAnIHRvIHByb3BhZ2F0ZSB0aGUgZXJyb3IuLi4NCg0KLVRva2UNCg0KDQpIaSBUb2tlOg0KCVVz
ZSAncmV0dXJuIHByb2dfZmQnIGluc3RlYWQgb2YgJ3JldHVybiBlcnJubycgZmlyc3QuIEFuZCBX
aGljaCBwb3NpdGlvbiBtaXNzZWQgb25lICdyZXR1cm4gZXJybm8nPw0KDQotWmhlbmdjaGFvIFNo
YW8NCg==
