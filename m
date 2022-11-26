Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6A0639420
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 08:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbiKZHM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 02:12:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiKZHM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 02:12:57 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3601D65B;
        Fri, 25 Nov 2022 23:12:52 -0800 (PST)
Received: from canpemm100009.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NK2wv6NqNz15MkT;
        Sat, 26 Nov 2022 15:12:15 +0800 (CST)
Received: from canpemm500010.china.huawei.com (7.192.105.118) by
 canpemm100009.china.huawei.com (7.192.105.213) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 26 Nov 2022 15:12:50 +0800
Received: from canpemm500010.china.huawei.com ([7.192.105.118]) by
 canpemm500010.china.huawei.com ([7.192.105.118]) with mapi id 15.01.2375.031;
 Sat, 26 Nov 2022 15:12:50 +0800
From:   "liujian (CE)" <liujian56@huawei.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
CC:     Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        davem <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [bug report] one possible out-of-order issue in sockmap
Thread-Topic: [bug report] one possible out-of-order issue in sockmap
Thread-Index: AdjPzwrK0RHLCS69QbyGLr5ej4bpUwA+hnmAAB7NriAAGXJbAAAayViQAEQKloALkDiJgA==
Date:   Sat, 26 Nov 2022 07:12:50 +0000
Message-ID: <f9fa9c53a31e4b9eafacba3c678eb7df@huawei.com>
References: <061d068ccd6f4db899d095cd61f52114@huawei.com>
 <YzCdHXtgKPciEusR@pop-os.localdomain>
 <fb254c963d3549a19c066b6bd2acf9c7@huawei.com>
 <6332169a699f8_4dfb7208e4@john.notmuch>
 <0dc1f0f9a8064ec3abd12bdcb069aaaf@huawei.com>
 <633492fb8ddc2_2944220881@john.notmuch>
In-Reply-To: <633492fb8ddc2_2944220881@john.notmuch>
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9obiBGYXN0YWJlbmQg
W21haWx0bzpqb2huLmZhc3RhYmVuZEBnbWFpbC5jb21dDQo+IFNlbnQ6IFRodXJzZGF5LCBTZXB0
ZW1iZXIgMjksIDIwMjIgMjozMSBBTQ0KPiBUbzogbGl1amlhbiAoQ0UpIDxsaXVqaWFuNTZAaHVh
d2VpLmNvbT47IEpvaG4gRmFzdGFiZW5kDQo+IDxqb2huLmZhc3RhYmVuZEBnbWFpbC5jb20+OyBD
b25nIFdhbmcgPHhpeW91Lndhbmdjb25nQGdtYWlsLmNvbT4NCj4gQ2M6IEpha3ViIFNpdG5pY2tp
IDxqYWt1YkBjbG91ZGZsYXJlLmNvbT47IEVyaWMgRHVtYXpldA0KPiA8ZWR1bWF6ZXRAZ29vZ2xl
LmNvbT47IGRhdmVtIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsNCj4geW9zaGZ1amlAbGludXgtaXB2
Ni5vcmc7IGRzYWhlcm5Aa2VybmVsLm9yZzsgSmFrdWIgS2ljaW5za2kNCj4gPGt1YmFAa2VybmVs
Lm9yZz47IFBhb2xvIEFiZW5pIDxwYWJlbmlAcmVkaGF0LmNvbT47IG5ldGRldg0KPiA8bmV0ZGV2
QHZnZXIua2VybmVsLm9yZz47IGJwZkB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUkU6IFti
dWcgcmVwb3J0XSBvbmUgcG9zc2libGUgb3V0LW9mLW9yZGVyIGlzc3VlIGluIHNvY2ttYXANCj4g
DQo+IGxpdWppYW4gKENFKSB3cm90ZToNCj4gPg0KPiA+DQo+ID4gPiAtLS0tLU9yaWdpbmFsIE1l
c3NhZ2UtLS0tLQ0KPiA+ID4gRnJvbTogSm9obiBGYXN0YWJlbmQgW21haWx0bzpqb2huLmZhc3Rh
YmVuZEBnbWFpbC5jb21dDQo+ID4gPiBTZW50OiBUdWVzZGF5LCBTZXB0ZW1iZXIgMjcsIDIwMjIg
NToxNiBBTQ0KPiA+ID4gVG86IGxpdWppYW4gKENFKSA8bGl1amlhbjU2QGh1YXdlaS5jb20+OyBD
b25nIFdhbmcNCj4gPiA+IDx4aXlvdS53YW5nY29uZ0BnbWFpbC5jb20+DQo+ID4gPiBDYzogSm9o
biBGYXN0YWJlbmQgPGpvaG4uZmFzdGFiZW5kQGdtYWlsLmNvbT47IEpha3ViIFNpdG5pY2tpDQo+
ID4gPiA8amFrdWJAY2xvdWRmbGFyZS5jb20+OyBFcmljIER1bWF6ZXQgPGVkdW1hemV0QGdvb2ds
ZS5jb20+Ow0KPiBkYXZlbQ0KPiA+ID4gPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyB5b3NoZnVqaUBs
aW51eC1pcHY2Lm9yZzsgZHNhaGVybkBrZXJuZWwub3JnOw0KPiA+ID4gSmFrdWIgS2ljaW5za2kg
PGt1YmFAa2VybmVsLm9yZz47IFBhb2xvIEFiZW5pIDxwYWJlbmlAcmVkaGF0LmNvbT47DQo+ID4g
PiBuZXRkZXYgPG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+OyBicGZAdmdlci5rZXJuZWwub3JnDQo+
ID4gPiBTdWJqZWN0OiBSRTogW2J1ZyByZXBvcnRdIG9uZSBwb3NzaWJsZSBvdXQtb2Ytb3JkZXIg
aXNzdWUgaW4gc29ja21hcA0KPiA+ID4NCj4gPiA+IGxpdWppYW4gKENFKSB3cm90ZToNCj4gPiA+
ID4NCj4gPiA+ID4NCj4gPiA+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4g
PiA+IEZyb206IENvbmcgV2FuZyBbbWFpbHRvOnhpeW91Lndhbmdjb25nQGdtYWlsLmNvbV0NCj4g
PiA+ID4gPiBTZW50OiBNb25kYXksIFNlcHRlbWJlciAyNiwgMjAyMiAyOjI2IEFNDQo+ID4gPiA+
ID4gVG86IGxpdWppYW4gKENFKSA8bGl1amlhbjU2QGh1YXdlaS5jb20+DQo+ID4gPiA+ID4gQ2M6
IEpvaG4gRmFzdGFiZW5kIDxqb2huLmZhc3RhYmVuZEBnbWFpbC5jb20+OyBKYWt1YiBTaXRuaWNr
aQ0KPiA+ID4gPiA+IDxqYWt1YkBjbG91ZGZsYXJlLmNvbT47IEVyaWMgRHVtYXpldCA8ZWR1bWF6
ZXRAZ29vZ2xlLmNvbT47DQo+ID4gPiBkYXZlbQ0KPiA+ID4gPiA+IDxkYXZlbUBkYXZlbWxvZnQu
bmV0PjsgeW9zaGZ1amlAbGludXgtaXB2Ni5vcmc7DQo+ID4gPiA+ID4gZHNhaGVybkBrZXJuZWwu
b3JnOyBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgUGFvbG8NCj4gPiA+ID4gPiBB
YmVuaSA8cGFiZW5pQHJlZGhhdC5jb20+OyBuZXRkZXYgPG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+
Ow0KPiA+ID4gPiA+IGJwZkB2Z2VyLmtlcm5lbC5vcmcNCj4gPiA+ID4gPiBTdWJqZWN0OiBSZTog
W2J1ZyByZXBvcnRdIG9uZSBwb3NzaWJsZSBvdXQtb2Ytb3JkZXIgaXNzdWUgaW4NCj4gPiA+ID4g
PiBzb2NrbWFwDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBPbiBTYXQsIFNlcCAyNCwgMjAyMiBhdCAw
Nzo1OToxNUFNICswMDAwLCBsaXVqaWFuIChDRSkgd3JvdGU6DQo+ID4gPiA+ID4gPiBIZWxsbywN
Cj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBJIGhhZCBhIHNjcCBmYWlsdXJlIHByb2JsZW0gaGVy
ZS4gSSBhbmFseXplIHRoZSBjb2RlLCBhbmQgdGhlDQo+ID4gPiA+ID4gPiByZWFzb25zIG1heQ0K
PiA+ID4gPiA+IGJlIGFzIGZvbGxvd3M6DQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gRnJvbSBj
b21taXQgZTdhNWYxZjFjZDAwICgiYnBmL3NvY2ttYXA6IFJlYWQgcHNvY2sgaW5ncmVzc19tc2cN
Cj4gPiA+ID4gPiBiZWZvcmUNCj4gPiA+ID4gPiA+IHNrX3JlY2VpdmVfcXVldWUiLCBpZiB3ZSB1
c2Ugc29ja29wcw0KPiA+ID4gPiA+ID4gKEJQRl9TT0NLX09QU19BQ1RJVkVfRVNUQUJMSVNIRURf
Q0INCj4gPiA+ID4gPiA+IGFuZCBCUEZfU09DS19PUFNfUEFTU0lWRV9FU1RBQkxJU0hFRF9DQikg
dG8gZW5hYmxlIHNvY2tldCdzDQo+ID4gPiA+ID4gc29ja21hcA0KPiA+ID4gPiA+ID4gZnVuY3Rp
b24sIGFuZCBkb24ndCBlbmFibGUgc3RycGFyc2UgYW5kIHZlcmRpY3QgZnVuY3Rpb24sIHRoZQ0K
PiA+ID4gPiA+ID4gb3V0LW9mLW9yZGVyIHByb2JsZW0gbWF5IG9jY3VyIGluIHRoZSBmb2xsb3dp
bmcgcHJvY2Vzcy4NCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBjbGllbnQgU0sgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHNlcnZlciBTSw0KPiA+ID4gPiA+ID4gLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4g
PiA+ID4gPiA+IC0tLS0NCj4gPiA+ID4gPiA+IC0tLS0NCj4gPiA+ID4gPiA+IC0tLS0NCj4gPiA+
ID4gPiA+IHRjcF9yY3Zfc3luc2VudF9zdGF0ZV9wcm9jZXNzDQo+ID4gPiA+ID4gPiAgIHRjcF9m
aW5pc2hfY29ubmVjdA0KPiA+ID4gPiA+ID4gICAgIHRjcF9pbml0X3RyYW5zZmVyDQo+ID4gPiA+
ID4gPiAgICAgICB0Y3Bfc2V0X3N0YXRlKHNrLCBUQ1BfRVNUQUJMSVNIRUQpOw0KPiA+ID4gPiA+
ID4gICAgICAgLy8gaW5zZXJ0IFNLIHRvIHNvY2ttYXANCj4gPiA+ID4gPiA+ICAgICB3YWtlIHVw
IHdhaXR0ZXINCj4gPiA+ID4gPiA+ICAgICB0Y3Bfc2VuZF9hY2sNCj4gPiA+ID4gPiA+DQo+ID4g
PiA+ID4gPiB0Y3BfYnBmX3NlbmRtc2cobXNnQSkNCj4gPiA+ID4gPiA+IC8vIG1zZ0Egd2lsbCBn
byB0Y3Agc3RhY2sNCj4gPiA+ID4gPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgdGNwX3Jjdl9zdGF0ZV9wcm9jZXNzDQo+ID4gPiA+ID4gPiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdGNwX2luaXRfdHJhbnNmZXINCj4g
PiA+ID4gPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IC8vaW5zZXJ0IFNLIHRvIHNvY2ttYXANCj4gPiA+ID4gPiA+ICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICB0Y3Bfc2V0X3N0YXRlKHNrLA0KPiA+ID4gPiA+ID4g
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBUQ1Bf
RVNUQUJMSVNIRUQpDQo+ID4gPiA+ID4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgd2FrZSB1cCB3YWl0dGVyDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBIZXJl
IGFmdGVyIHRoZSBzb2NrZXQgaXMgaW5zZXJ0ZWQgdG8gYSBzb2NrbWFwLCBpdHMNCj4gPiA+ID4g
PiAtPnNrX2RhdGFfcmVhZHkoKSBpcyBhbHJlYWR5IHJlcGxhY2VkIHdpdGgNCj4gPiA+ID4gPiBz
a19wc29ja192ZXJkaWN0X2RhdGFfcmVhZHkoKSwgc28gbXNnQSBzaG91bGQgZ28gdG8gc29ja21h
cCwgbm90DQo+ID4gPiA+ID4gVENQDQo+ID4gPiBzdGFjaz8NCj4gPiA+ID4gPg0KPiA+ID4gPiBJ
dCBpcyBUQ1Agc3RhY2suICBIZXJlIEkgb25seSBlbmFibGUgQlBGX1NLX01TR19WRVJESUNUIHR5
cGUuDQo+ID4gPiA+IGJwZnRvb2wgcHJvZyBsb2FkIGJwZl9yZWRpci5vIC9zeXMvZnMvYnBmL2Jw
Zl9yZWRpciBtYXAgbmFtZQ0KPiA+ID4gPiBzb2NrX29wc19tYXAgcGlubmVkIC9zeXMvZnMvYnBm
L3NvY2tfb3BzX21hcCBicGZ0b29sIHByb2cgYXR0YWNoDQo+ID4gPiA+IHBpbm5lZCAvc3lzL2Zz
L2JwZi9icGZfcmVkaXIgbXNnX3ZlcmRpY3QgcGlubmVkDQo+ID4gPiA+IC9zeXMvZnMvYnBmL3Nv
Y2tfb3BzX21hcA0KPiA+ID4NCj4gPiA+IElzIHRoZSBzZW5kZXIgdXNpbmcgRkFTVF9PUEVOIGJ5
IGFueSBjaGFuY2U/IFdlIGtub3cgdGhpcyBidWcgZXhpc3RzDQo+ID4gPiBpbiB0aGlzIGNhc2Uu
IEZpeCB0YmQuDQo+ID4NCj4gPiBGQVNUX09QRU4gaXMgbm90IHVzZWQuDQo+IA0KPiBPSyB0aGFu
a3MgZm9yIHRoZSByZXByb2R1Y2VyIEknbGwgdGFrZSBhIGxvb2sgdGhpcyBhZnRlcm5vb24uDQpI
ZXksIEpvaG4gYW5kIGV2ZXJ5b25lLCBjb3VsZCB5b3UgdGFrZSBhIGxvb2sgYXQgdGhpcyBvbmUg
YWdhaW4/DQpJZiB0aGVyZSdzIGFueXRoaW5nIG5lZWQgbWUgdG8gdGVzdCwgcGxlYXNlIGxldCBt
ZSBrbm93Lg0K
