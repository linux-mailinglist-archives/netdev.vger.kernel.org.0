Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A5041BC98
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 04:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243730AbhI2CJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 22:09:56 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:23184 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242761AbhI2CJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 22:09:52 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HK09m2r80z1DHQb;
        Wed, 29 Sep 2021 10:06:52 +0800 (CST)
Received: from dggema721-chm.china.huawei.com (10.3.20.85) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 10:08:10 +0800
Received: from dggema772-chm.china.huawei.com (10.1.198.214) by
 dggema721-chm.china.huawei.com (10.3.20.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Wed, 29 Sep 2021 10:08:10 +0800
Received: from dggema772-chm.china.huawei.com ([10.9.128.138]) by
 dggema772-chm.china.huawei.com ([10.9.128.138]) with mapi id 15.01.2308.008;
 Wed, 29 Sep 2021 10:08:10 +0800
From:   "liujian (CE)" <liujian56@huawei.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: RE: [PATCH v3] skmsg: lose offset info in sk_psock_skb_ingress
Thread-Topic: [PATCH v3] skmsg: lose offset info in sk_psock_skb_ingress
Thread-Index: AQHXr5TEvqMbfOjFUkOFMdZlBki+lKu4dLMAgAHZdMA=
Date:   Wed, 29 Sep 2021 02:08:10 +0000
Message-ID: <329a2008cf5f47629451ad0699ef3305@huawei.com>
References: <20210922093259.164013-1-liujian56@huawei.com>
 <CAM_iQpVDiA8-GHXYrNs8A4gBaDioWMPeQR=2u4OKn2ZCyzu8Lg@mail.gmail.com>
In-Reply-To: <CAM_iQpVDiA8-GHXYrNs8A4gBaDioWMPeQR=2u4OKn2ZCyzu8Lg@mail.gmail.com>
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQ29uZyBXYW5nIFttYWls
dG86eGl5b3Uud2FuZ2NvbmdAZ21haWwuY29tXQ0KPiBTZW50OiBUdWVzZGF5LCBTZXB0ZW1iZXIg
MjgsIDIwMjEgMTo1MiBQTQ0KPiBUbzogbGl1amlhbiAoQ0UpIDxsaXVqaWFuNTZAaHVhd2VpLmNv
bT4NCj4gQ2M6IEpvaG4gRmFzdGFiZW5kIDxqb2huLmZhc3RhYmVuZEBnbWFpbC5jb20+OyBEYW5p
ZWwgQm9ya21hbm4NCj4gPGRhbmllbEBpb2dlYXJib3gubmV0PjsgSmFrdWIgU2l0bmlja2kgPGph
a3ViQGNsb3VkZmxhcmUuY29tPjsgTG9yZW56DQo+IEJhdWVyIDxsbWJAY2xvdWRmbGFyZS5jb20+
OyBEYXZpZCBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBKYWt1Yg0KPiBLaWNpbnNraSA8
a3ViYUBrZXJuZWwub3JnPjsgQWxleGVpIFN0YXJvdm9pdG92IDxhc3RAa2VybmVsLm9yZz47IEFu
ZHJpaQ0KPiBOYWtyeWlrbyA8YW5kcmlpQGtlcm5lbC5vcmc+OyBNYXJ0aW4gS2FGYWkgTGF1IDxr
YWZhaUBmYi5jb20+OyBTb25nIExpdQ0KPiA8c29uZ2xpdWJyYXZpbmdAZmIuY29tPjsgWW9uZ2hv
bmcgU29uZyA8eWhzQGZiLmNvbT47IEtQIFNpbmdoDQo+IDxrcHNpbmdoQGtlcm5lbC5vcmc+OyBM
aW51eCBLZXJuZWwgTmV0d29yayBEZXZlbG9wZXJzDQo+IDxuZXRkZXZAdmdlci5rZXJuZWwub3Jn
PjsgYnBmIDxicGZAdmdlci5rZXJuZWwub3JnPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYzXSBz
a21zZzogbG9zZSBvZmZzZXQgaW5mbyBpbiBza19wc29ja19za2JfaW5ncmVzcw0KPiANCj4gT24g
V2VkLCBTZXAgMjIsIDIwMjEgYXQgMjozMiBBTSBMaXUgSmlhbiA8bGl1amlhbjU2QGh1YXdlaS5j
b20+IHdyb3RlOg0KPiA+ICBzdGF0aWMgdm9pZCBza19wc29ja19za2Jfc3RhdGUoc3RydWN0IHNr
X3Bzb2NrICpwc29jaywgQEAgLTYwNCw2DQo+ID4gKzYwOCw5IEBAIHN0YXRpYyB2b2lkIHNrX3Bz
b2NrX2JhY2tsb2coc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKSAgew0KPiA+ICAgICAgICAgc3Ry
dWN0IHNrX3Bzb2NrICpwc29jayA9IGNvbnRhaW5lcl9vZih3b3JrLCBzdHJ1Y3Qgc2tfcHNvY2ss
IHdvcmspOw0KPiA+ICAgICAgICAgc3RydWN0IHNrX3Bzb2NrX3dvcmtfc3RhdGUgKnN0YXRlID0g
JnBzb2NrLT53b3JrX3N0YXRlOw0KPiA+ICsjaWYgSVNfRU5BQkxFRChDT05GSUdfQlBGX1NUUkVB
TV9QQVJTRVIpDQo+ID4gKyAgICAgICBzdHJ1Y3Qgc3RycF9tc2cgKnN0bSA9IE5VTEw7DQo+ID4g
KyNlbmRpZg0KPiA+ICAgICAgICAgc3RydWN0IHNrX2J1ZmYgKnNrYiA9IE5VTEw7DQo+ID4gICAg
ICAgICBib29sIGluZ3Jlc3M7DQo+ID4gICAgICAgICB1MzIgbGVuLCBvZmY7DQo+ID4gQEAgLTYy
NCw2ICs2MzEsMTMgQEAgc3RhdGljIHZvaWQgc2tfcHNvY2tfYmFja2xvZyhzdHJ1Y3Qgd29ya19z
dHJ1Y3QNCj4gKndvcmspDQo+ID4gICAgICAgICB3aGlsZSAoKHNrYiA9IHNrYl9kZXF1ZXVlKCZw
c29jay0+aW5ncmVzc19za2IpKSkgew0KPiA+ICAgICAgICAgICAgICAgICBsZW4gPSBza2ItPmxl
bjsNCj4gPiAgICAgICAgICAgICAgICAgb2ZmID0gMDsNCj4gPiArI2lmIElTX0VOQUJMRUQoQ09O
RklHX0JQRl9TVFJFQU1fUEFSU0VSKQ0KPiA+ICsgICAgICAgICAgICAgICBpZiAoc2tiX2JwZl9z
dHJwYXJzZXIoc2tiKSkgew0KPiANCj4gSWYgQ09ORklHX0JQRl9TVFJFQU1fUEFSU0VSIGlzIGRp
c2FibGVkLCB0aGlzIHNob3VsZCBhbHdheXMgcmV0dXJuIGZhbHNlLA0KPiBoZW5jZSB5b3UgZG9u
J3QgbmVlZCB0aGlzICNpZmRlZi4NCj4gT3IgYWx0ZXJuYXRpdmVseSwgeW91IGNhbiBhdCBsZWFz
dCBkZWZpbmUgZm9yIG5vcCBmb3INCj4gc2tiX2JwZl9zdHJwYXJzZXIoKSBpZiAhQ09ORklHX0JQ
Rl9TVFJFQU1fUEFSU0VSLg0KPiBBbmQgeW91IGNhbiBtb3ZlIHRoZSBhYm92ZSAic3RtIiBkb3du
IGhlcmUgdG9vLg0KPiANClY0IGhhcyBiZWVuIHNlbnQsIHRoYW5rIHlvdX4NCg0KPiAoRGl0dG8g
Zm9yIHRoZSBvdGhlciBwbGFjZSBiZWxvdy4pDQo+IA0KPiBUaGFua3MuDQo=
