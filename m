Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1438510D61
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 02:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356473AbiD0Asw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 20:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356465AbiD0Asw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 20:48:52 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA1921254;
        Tue, 26 Apr 2022 17:45:41 -0700 (PDT)
Received: from canpemm500008.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Kp0Q626LMz1JBhs;
        Wed, 27 Apr 2022 08:44:46 +0800 (CST)
Received: from dggpeml500026.china.huawei.com (7.185.36.106) by
 canpemm500008.china.huawei.com (7.192.105.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 27 Apr 2022 08:45:39 +0800
Received: from dggpeml500026.china.huawei.com ([7.185.36.106]) by
 dggpeml500026.china.huawei.com ([7.185.36.106]) with mapi id 15.01.2375.024;
 Wed, 27 Apr 2022 08:45:39 +0800
From:   shaozhengchao <shaozhengchao@huawei.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "weiyongjun (A)" <weiyongjun1@huawei.com>,
        yuehaibing <yuehaibing@huawei.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggYnBmLW5leHRdIHNhbXBsZXMvYnBmOiBkZXRhY2gg?=
 =?utf-8?B?eGRwIHByb2cgd2hlbiBwcm9ncmFtIGV4aXRzIHVuZXhwZWN0ZWRseSBpbiB4?=
 =?utf-8?B?ZHBfcnhxX2luZm9fdXNlcg==?=
Thread-Topic: [PATCH bpf-next] samples/bpf: detach xdp prog when program exits
 unexpectedly in xdp_rxq_info_user
Thread-Index: AQHYVXhnj2mrrLYF+0mSlUsKYgSQOq0BHPyAgAHXDHA=
Date:   Wed, 27 Apr 2022 00:45:39 +0000
Message-ID: <2ba194b97a514384aeca0323c3bd7461@huawei.com>
References: <20220421120925.330160-1-shaozhengchao@huawei.com>
 <CAEf4BzY=VajaEH_09FX0-wuPFCJ6te=shZa0jj2Jc7ukL-WzMQ@mail.gmail.com>
In-Reply-To: <CAEf4BzY=VajaEH_09FX0-wuPFCJ6te=shZa0jj2Jc7ukL-WzMQ@mail.gmail.com>
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmsgeW91IGZvciB5b3VyIHJlcGx5Lg0KDQpJIHdpbGwgZml4IHRoZSBjb21waWxhdGlvbiB3
YXJuaW5nIGZpcnN0bHksIGFuZCB0aGVuIGNvbnZlcnQgdGhpcyBzYW1wbGUgdG8gc2tlbGV0b24u
IFRoYW5rIHlvdSB2ZXJ5IG11Y2guDQoNCi0tLS0t6YKu5Lu25Y6f5Lu2LS0tLS0NCuWPkeS7tuS6
ujogQW5kcmlpIE5ha3J5aWtvIFttYWlsdG86YW5kcmlpLm5ha3J5aWtvQGdtYWlsLmNvbV0gDQrl
j5HpgIHml7bpl7Q6IDIwMjLlubQ05pyIMjbml6UgMTI6MzUNCuaUtuS7tuS6ujogc2hhb3poZW5n
Y2hhbyA8c2hhb3poZW5nY2hhb0BodWF3ZWkuY29tPg0K5oqE6YCBOiBicGYgPGJwZkB2Z2VyLmtl
cm5lbC5vcmc+OyBOZXR3b3JraW5nIDxuZXRkZXZAdmdlci5rZXJuZWwub3JnPjsgb3BlbiBsaXN0
IDxsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnPjsgQWxleGVpIFN0YXJvdm9pdG92IDxhc3RA
a2VybmVsLm9yZz47IERhbmllbCBCb3JrbWFubiA8ZGFuaWVsQGlvZ2VhcmJveC5uZXQ+OyBEYXZp
ZCBTLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBKYWt1YiBLaWNpbnNraSA8a3ViYUBr
ZXJuZWwub3JnPjsgSmVzcGVyIERhbmdhYXJkIEJyb3VlciA8aGF3a0BrZXJuZWwub3JnPjsgam9o
biBmYXN0YWJlbmQgPGpvaG4uZmFzdGFiZW5kQGdtYWlsLmNvbT47IEFuZHJpaSBOYWtyeWlrbyA8
YW5kcmlpQGtlcm5lbC5vcmc+OyBNYXJ0aW4gTGF1IDxrYWZhaUBmYi5jb20+OyBTb25nIExpdSA8
c29uZ2xpdWJyYXZpbmdAZmIuY29tPjsgWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT47IEtQIFNp
bmdoIDxrcHNpbmdoQGtlcm5lbC5vcmc+OyB3ZWl5b25nanVuIChBKSA8d2VpeW9uZ2p1bjFAaHVh
d2VpLmNvbT47IHl1ZWhhaWJpbmcgPHl1ZWhhaWJpbmdAaHVhd2VpLmNvbT4NCuS4u+mimDogUmU6
IFtQQVRDSCBicGYtbmV4dF0gc2FtcGxlcy9icGY6IGRldGFjaCB4ZHAgcHJvZyB3aGVuIHByb2dy
YW0gZXhpdHMgdW5leHBlY3RlZGx5IGluIHhkcF9yeHFfaW5mb191c2VyDQoNCk9uIFRodSwgQXBy
IDIxLCAyMDIyIGF0IDU6MDcgQU0gWmhlbmdjaGFvIFNoYW8gPHNoYW96aGVuZ2NoYW9AaHVhd2Vp
LmNvbT4gd3JvdGU6DQo+DQo+IFdoZW4geGRwX3J4cV9pbmZvX3VzZXIgcHJvZ3JhbSBleGl0cyB1
bmV4cGVjdGVkbHksIGl0IGRvZXNuJ3QgZGV0YWNoIA0KPiB4ZHAgcHJvZyBvZiBkZXZpY2UsIGFu
ZCBvdGhlciB4ZHAgcHJvZyBjYW4ndCBiZSBhdHRhY2hlZCB0byB0aGUgDQo+IGRldmljZS4gU28g
Y2FsbCBpbml0X2V4aXQoKSB0byBkZXRhY2ggeGRwIHByb2cgd2hlbiBwcm9ncmFtIGV4aXRzIHVu
ZXhwZWN0ZWRseS4NCj4NCj4gU2lnbmVkLW9mZi1ieTogWmhlbmdjaGFvIFNoYW8gPHNoYW96aGVu
Z2NoYW9AaHVhd2VpLmNvbT4NCj4gLS0tDQo+ICBzYW1wbGVzL2JwZi94ZHBfcnhxX2luZm9fdXNl
ci5jIHwgMjEgKysrKysrKysrKysrKysrLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMTUgaW5z
ZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCj4NCg0KeW91IGFyZSBpbnRyb2R1Y2luZyBhIG5l
dyBjb21waWxhdGlvbiB3YXJuaW5nLCBwbGVhc2UgZml4IGl0DQoNCg0KL2RhdGEvdXNlcnMvYW5k
cmlpbi9saW51eC9zYW1wbGVzL2JwZi94ZHBfcnhxX2luZm9fdXNlci5jOiBJbiBmdW5jdGlvbg0K
4oCYb3B0aW9uczJzdHLigJk6DQovZGF0YS91c2Vycy9hbmRyaWluL2xpbnV4L3NhbXBsZXMvYnBm
L3hkcF9yeHFfaW5mb191c2VyLmM6MTUzOjE6DQp3YXJuaW5nOiBjb250cm9sIHJlYWNoZXMgZW5k
IG9mIG5vbi12b2lkIGZ1bmN0aW9uIFstV3JldHVybi10eXBlXQ0KICAxNTMgfCB9DQogICAgICB8
IF4NCg0KSXQgYWxzbyB3b3VsZCBiZSBnb29kIHRvIGluc3RlYWQgdXNlIGJwZl9saW5rLWJhc2Vk
IFhEUCBhdHRhY2htZW50IHRoYXQgd291bGQgYmUgYXV0by1kZXRhY2hlZCBhdXRvbWF0aWNhbGx5
IG9uIHByb2Nlc3MgY3Jhc2gNCihicGZfbGlua19jcmVhdGUoKSBGVFcpLiBQbGVhc2UgY29uc2lk
ZXIgYWxzbyBjb252ZXJ0aW5nIHRoaXMgc2FtcGxlIHRvIHNrZWxldG9uIChhbmQgdGhlbiBicGZf
cHJvZ3JhbV9fYXR0YWNoX3hkcCgpIGFzIGhpZ2gtbGV2ZWwgYWx0ZXJuYXRpdmUgdG8gYnBmX2xp
bmtfY3JlYXRlKCkpLg0KDQo+IGRpZmYgLS1naXQgYS9zYW1wbGVzL2JwZi94ZHBfcnhxX2luZm9f
dXNlci5jIA0KPiBiL3NhbXBsZXMvYnBmL3hkcF9yeHFfaW5mb191c2VyLmMgaW5kZXggZjJkOTBj
YmE1MTY0Li42Mzc4MDA3ZTA4NWEgDQo+IDEwMDY0NA0KPiAtLS0gYS9zYW1wbGVzL2JwZi94ZHBf
cnhxX2luZm9fdXNlci5jDQo+ICsrKyBiL3NhbXBsZXMvYnBmL3hkcF9yeHFfaW5mb191c2VyLmMN
Cj4gQEAgLTE4LDcgKzE4LDcgQEAgc3RhdGljIGNvbnN0IGNoYXIgKl9fZG9jX18gPSAiIFhEUCBS
WC1xdWV1ZSBpbmZvIGV4dHJhY3QgZXhhbXBsZVxuXG4iDQo+ICAjaW5jbHVkZSA8Z2V0b3B0Lmg+
DQo+ICAjaW5jbHVkZSA8bmV0L2lmLmg+DQo+ICAjaW5jbHVkZSA8dGltZS5oPg0KDQpbLi4uXQ0K
