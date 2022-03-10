Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 543344D5501
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 00:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344530AbiCJXHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 18:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235887AbiCJXG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 18:06:59 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B16C190B6F
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 15:05:57 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-95-j_DIc5ZRPHOyWYg3TK3RZg-1; Thu, 10 Mar 2022 23:05:54 +0000
X-MC-Unique: j_DIc5ZRPHOyWYg3TK3RZg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Thu, 10 Mar 2022 23:05:53 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Thu, 10 Mar 2022 23:05:53 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Willem de Bruijn' <willemdebruijn.kernel@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David Ahern" <dsahern@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, "Yonghong Song" <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        "syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com" 
        <syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com>,
        Willem de Bruijn <willemb@google.com>
Subject: RE: [PATCH v2] net: ipv6: fix skb_over_panic in __ip6_append_data
Thread-Topic: [PATCH v2] net: ipv6: fix skb_over_panic in __ip6_append_data
Thread-Index: AQHYNNA9n/GFN1e7cUOoZGj2dooiCKy5O9cQ
Date:   Thu, 10 Mar 2022 23:05:53 +0000
Message-ID: <6871999c8e8640beae53f230681b3ce2@AcuMS.aculab.com>
References: <CA+FuTScPUVpyK6WYXrePTg_533VF2wfPww4MOJYa17v0xbLeGQ@mail.gmail.com>
 <20220310221328.877987-1-tadeusz.struk@linaro.org>
 <20220310143011.00c21f53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAF=yD-LrVjvY8wAqZtUTFS8V9ng2AD3jB1DOZvkagPOp3Sbq-g@mail.gmail.com>
In-Reply-To: <CAF=yD-LrVjvY8wAqZtUTFS8V9ng2AD3jB1DOZvkagPOp3Sbq-g@mail.gmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogV2lsbGVtIGRlIEJydWlqbg0KPiBTZW50OiAxMCBNYXJjaCAyMDIyIDIyOjQzDQo+IA0K
PiBPbiBUaHUsIE1hciAxMCwgMjAyMiBhdCA1OjMwIFBNIEpha3ViIEtpY2luc2tpIDxrdWJhQGtl
cm5lbC5vcmc+IHdyb3RlOg0KPiA+DQo+ID4gT24gVGh1LCAxMCBNYXIgMjAyMiAxNDoxMzoyOCAt
MDgwMCBUYWRldXN6IFN0cnVrIHdyb3RlOg0KPiA+ID4gZGlmZiAtLWdpdCBhL25ldC9pcHY2L2lw
Nl9vdXRwdXQuYyBiL25ldC9pcHY2L2lwNl9vdXRwdXQuYw0KPiA+ID4gaW5kZXggNDc4OGY2YjM3
MDUzLi42ZDQ1MTEyMzIyYTAgMTAwNjQ0DQo+ID4gPiAtLS0gYS9uZXQvaXB2Ni9pcDZfb3V0cHV0
LmMNCj4gPiA+ICsrKyBiL25ldC9pcHY2L2lwNl9vdXRwdXQuYw0KPiA+ID4gQEAgLTE2NDksNiAr
MTY0OSwxNiBAQCBzdGF0aWMgaW50IF9faXA2X2FwcGVuZF9kYXRhKHN0cnVjdCBzb2NrICpzaywN
Cj4gPiA+ICAgICAgICAgICAgICAgICAgICAgICBza2ItPnByb3RvY29sID0gaHRvbnMoRVRIX1Bf
SVBWNik7DQo+ID4gPiAgICAgICAgICAgICAgICAgICAgICAgc2tiLT5pcF9zdW1tZWQgPSBjc3Vt
bW9kZTsNCj4gPiA+ICAgICAgICAgICAgICAgICAgICAgICBza2ItPmNzdW0gPSAwOw0KPiA+ID4g
Kw0KPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgIC8qDQo+ID4gPiArICAgICAgICAgICAgICAg
ICAgICAgICogICAgICBDaGVjayBpZiB0aGVyZSBpcyBzdGlsbCByb29tIGZvciBwYXlsb2FkDQo+
ID4gPiArICAgICAgICAgICAgICAgICAgICAgICovDQo+ID4NCj4gPiBUQkggSSB0aGluayB0aGUg
Y2hlY2sgaXMgc2VsZi1leHBsYW5hdG9yeS4gTm90IHdvcnRoIGEgYmFubmVyIGNvbW1lbnQsDQo+
ID4gZm9yIHN1cmUuDQo+ID4NCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgICBpZiAoZnJhZ2hl
YWRlcmxlbiA+PSBtdHUpIHsNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGVy
ciA9IC1FTVNHU0laRTsNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGtmcmVl
X3NrYihza2IpOw0KPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZ290byBlcnJv
cjsNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgICB9DQo+ID4NCj4gPiBOb3Qgc3VyZSBpZiBX
aWxsZW0gcHJlZmVycyB0aGlzIHBsYWNlbWVudCwgYnV0IHNlZW1zIGxpa2Ugd2UgY2FuIGxpZnQN
Cj4gPiB0aGlzIGNoZWNrIG91dCBvZiB0aGUgbG9vcCwgYXMgc29vbiBhcyBmcmFnaGVhZGVybGVu
IGFuZCBtdHUgYXJlIGtub3duLg0KPiA+DQo+ID4gPiAgICAgICAgICAgICAgICAgICAgICAgLyog
cmVzZXJ2ZSBmb3IgZnJhZ21lbnRhdGlvbiBhbmQgaXBzZWMgaGVhZGVyICovDQo+ID4gPiAgICAg
ICAgICAgICAgICAgICAgICAgc2tiX3Jlc2VydmUoc2tiLCBoaF9sZW4gKyBzaXplb2Yoc3RydWN0
IGZyYWdfaGRyKSArDQo+ID4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZHN0
X2V4dGhkcmxlbik7DQo+IA0KPiBKdXN0IHVwZGF0aW5nIHRoaXMgYm91bmRhcnkgY2hlY2sgd2ls
bCBkbz8NCj4gDQo+ICAgICAgICAgaWYgKG10dSA8IGZyYWdoZWFkZXJsZW4gfHwNCj4gICAgICAg
ICAgICAgKChtdHUgLSBmcmFnaGVhZGVybGVuKSAmIH43KSArIGZyYWdoZWFkZXJsZW4gPA0KPiBz
aXplb2Yoc3RydWN0IGZyYWdfaGRyKSkNCj4gICAgICAgICAgICAgICAgIGdvdG8gZW1zZ3NpemU7
DQoNCkJvdGggdGhvc2UgPCBzaG91bGQgYmUgPD0NCg0KQnV0IEkgdGhpbmsgSSdkIGNoZWNrOg0K
CWlmIChmcmFnaGVhZGVybGVuID49IDEyODAgLSBzaXplb2YgKHN0cnVjdCBmcmFnX2hkcikpDQoJ
CWdvdG8gZW1zZ3NpemU7DQpmaXJzdCAob3Igb25seSEpDQoNCglEYXZpZA0KDQotDQpSZWdpc3Rl
cmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtl
eW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

