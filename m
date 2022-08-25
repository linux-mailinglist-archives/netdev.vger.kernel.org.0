Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 810175A18B6
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 20:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243020AbiHYSV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 14:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243019AbiHYSV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 14:21:56 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94757B0B0C
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 11:21:54 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-150-G_II5gCTOkS2O3ljaQjJ3Q-1; Thu, 25 Aug 2022 19:21:51 +0100
X-MC-Unique: G_II5gCTOkS2O3ljaQjJ3Q-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.38; Thu, 25 Aug 2022 19:21:50 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.040; Thu, 25 Aug 2022 19:21:50 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'David Ahern' <dsahern@kernel.org>,
        Dmitry Safonov <dima@arista.com>,
        "Eric Dumazet" <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: [PATCH 08/31] net/tcp: Introduce TCP_AO setsockopt()s
Thread-Topic: [PATCH 08/31] net/tcp: Introduce TCP_AO setsockopt()s
Thread-Index: AQHYuJfcgHvrZq++JEml2fBqCEeqMK2/7X7w
Date:   Thu, 25 Aug 2022 18:21:50 +0000
Message-ID: <f3d46a4f232444378fae886fa7a0293a@AcuMS.aculab.com>
References: <20220818170005.747015-1-dima@arista.com>
 <20220818170005.747015-9-dima@arista.com>
 <97dc2f1d-081e-a182-cc4d-57e3df4742a0@kernel.org>
In-Reply-To: <97dc2f1d-081e-a182-cc4d-57e3df4742a0@kernel.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgQWhlcm4NCj4gU2VudDogMjUgQXVndXN0IDIwMjIgMTY6MzINCj4gDQo+IE9u
IDgvMTgvMjIgOTo1OSBBTSwgRG1pdHJ5IFNhZm9ub3Ygd3JvdGU6DQo+ID4gZGlmZiAtLWdpdCBh
L2luY2x1ZGUvdWFwaS9saW51eC90Y3AuaCBiL2luY2x1ZGUvdWFwaS9saW51eC90Y3AuaA0KPiA+
IGluZGV4IDg0OWJiZjJkM2MzOC4uNTM2OTQ1OGFlODlmIDEwMDY0NA0KPiA+IC0tLSBhL2luY2x1
ZGUvdWFwaS9saW51eC90Y3AuaA0KPiA+ICsrKyBiL2luY2x1ZGUvdWFwaS9saW51eC90Y3AuaA0K
PiA+IEBAIC0xMjksNiArMTI5LDkgQEAgZW51bSB7DQo+ID4NCj4gPiAgI2RlZmluZSBUQ1BfVFhf
REVMQVkJCTM3CS8qIGRlbGF5IG91dGdvaW5nIHBhY2tldHMgYnkgWFggdXNlYyAqLw0KPiA+DQo+
ID4gKyNkZWZpbmUgVENQX0FPCQkJMzgJLyogKEFkZC9TZXQgTUtUKSAqLw0KPiA+ICsjZGVmaW5l
IFRDUF9BT19ERUwJCTM5CS8qIChEZWxldGUgTUtUKSAqLw0KPiA+ICsjZGVmaW5lIFRDUF9BT19N
T0QJCTQwCS8qIChNb2RpZnkgTUtUKSAqLw0KPiA+DQo+ID4gICNkZWZpbmUgVENQX1JFUEFJUl9P
TgkJMQ0KPiA+ICAjZGVmaW5lIFRDUF9SRVBBSVJfT0ZGCQkwDQo+ID4gQEAgLTM0NCw2ICszNDcs
MzggQEAgc3RydWN0IHRjcF9kaWFnX21kNXNpZyB7DQo+ID4NCj4gPiAgI2RlZmluZSBUQ1BfQU9f
TUFYS0VZTEVOCTgwDQo+ID4NCj4gPiArI2RlZmluZSBUQ1BfQU9fQ01ERl9DVVJSCSgxIDw8IDAp
CS8qIE9ubHkgY2hlY2tzIGZpZWxkIHNuZGlkICovDQo+ID4gKyNkZWZpbmUgVENQX0FPX0NNREZf
TkVYVAkoMSA8PCAxKQkvKiBPbmx5IGNoZWNrcyBmaWVsZCByY3ZpZCAqLw0KPiA+ICsNCj4gPiAr
c3RydWN0IHRjcF9hbyB7IC8qIHNldHNvY2tvcHQoVENQX0FPKSAqLw0KPiA+ICsJc3RydWN0IF9f
a2VybmVsX3NvY2thZGRyX3N0b3JhZ2UgdGNwYV9hZGRyOw0KPiA+ICsJY2hhcgl0Y3BhX2FsZ19u
YW1lWzY0XTsNCj4gPiArCV9fdTE2CXRjcGFfZmxhZ3M7DQo+ID4gKwlfX3U4CXRjcGFfcHJlZml4
Ow0KPiA+ICsJX191OAl0Y3BhX3NuZGlkOw0KPiA+ICsJX191OAl0Y3BhX3JjdmlkOw0KPiA+ICsJ
X191OAl0Y3BhX21hY2xlbjsNCj4gPiArCV9fdTgJdGNwYV9rZXlmbGFnczsNCj4gPiArCV9fdTgJ
dGNwYV9rZXlsZW47DQo+ID4gKwlfX3U4CXRjcGFfa2V5W1RDUF9BT19NQVhLRVlMRU5dOw0KPiA+
ICt9IF9fYXR0cmlidXRlX18oKGFsaWduZWQoOCkpKTsNCj4gPiArDQo+ID4gK3N0cnVjdCB0Y3Bf
YW9fZGVsIHsgLyogc2V0c29ja29wdChUQ1BfQU9fREVMKSAqLw0KPiA+ICsJc3RydWN0IF9fa2Vy
bmVsX3NvY2thZGRyX3N0b3JhZ2UgdGNwYV9hZGRyOw0KPiA+ICsJX191MTYJdGNwYV9mbGFnczsN
Cj4gPiArCV9fdTgJdGNwYV9wcmVmaXg7DQo+ID4gKwlfX3U4CXRjcGFfc25kaWQ7DQo+ID4gKwlf
X3U4CXRjcGFfcmN2aWQ7DQo+ID4gKwlfX3U4CXRjcGFfY3VycmVudDsNCj4gPiArCV9fdTgJdGNw
YV9ybmV4dDsNCj4gPiArfSBfX2F0dHJpYnV0ZV9fKChhbGlnbmVkKDgpKSk7DQo+ID4gKw0KPiA+
ICtzdHJ1Y3QgdGNwX2FvX21vZCB7IC8qIHNldHNvY2tvcHQoVENQX0FPX01PRCkgKi8NCj4gPiAr
CV9fdTE2CXRjcGFfZmxhZ3M7DQo+ID4gKwlfX3U4CXRjcGFfY3VycmVudDsNCj4gPiArCV9fdTgJ
dGNwYV9ybmV4dDsNCj4gPiArfSBfX2F0dHJpYnV0ZV9fKChhbGlnbmVkKDgpKSk7DQo+ID4gKw0K
PiA+ICAvKiBzZXRzb2Nrb3B0KGZkLCBJUFBST1RPX1RDUCwgVENQX1pFUk9DT1BZX1JFQ0VJVkUs
IC4uLikgKi8NCj4gPg0KPiA+ICAjZGVmaW5lIFRDUF9SRUNFSVZFX1pFUk9DT1BZX0ZMQUdfVExC
X0NMRUFOX0hJTlQgMHgxDQo+IA0KPiANCj4gSSBkbyBub3Qgc2VlIGFueXRoaW5nIGluIHRoZSB1
YXBpIHRoYXQgd291bGQgc3BlY2lmeSB0aGUgVlJGIGZvciB0aGUNCj4gYWRkcmVzcy4NCg0KKEhh
dmluZyBub3Qgc3BvdHRlZCB0aGUgb3JpZ2luYWwuLi4pDQoNCllvdSd2ZSBhbHNvIGdvdCBpbXBs
aWNpdCBwYWRkaW5nIGluIHRoZSBBUEkgc3RydWN0dXJlcy4NClRoYXQgaXMgZ2VuZXJhbGx5IGEg
cmVjaXBlIGZvciBkaXNhc3Rlci4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBM
YWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBU
LCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

