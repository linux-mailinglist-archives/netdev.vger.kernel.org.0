Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3926DECB9
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 09:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbjDLHjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 03:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjDLHjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 03:39:33 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE564E5D
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 00:39:31 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-180-BM_HQVsgMWedE-uoB0ILog-1; Wed, 12 Apr 2023 08:39:29 +0100
X-MC-Unique: BM_HQVsgMWedE-uoB0ILog-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 12 Apr
 2023 08:39:26 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Wed, 12 Apr 2023 08:39:26 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'David Ahern' <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        "Breno Leitao" <leitao@debian.org>
CC:     Willem de Bruijn <willemb@google.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "leit@fb.com" <leit@fb.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dccp@vger.kernel.org" <dccp@vger.kernel.org>,
        "mptcp@lists.linux.dev" <mptcp@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "matthieu.baerts@tessares.net" <matthieu.baerts@tessares.net>,
        "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>
Subject: RE: [PATCH 0/5] add initial io_uring_cmd support for sockets
Thread-Topic: [PATCH 0/5] add initial io_uring_cmd support for sockets
Thread-Index: AQHZbIo9yiioZyVNEkW7nkcDZ6Um0a8nR9fA
Date:   Wed, 12 Apr 2023 07:39:26 +0000
Message-ID: <d25962b44b2d4204a7251d97c331fcf8@AcuMS.aculab.com>
References: <20230406144330.1932798-1-leitao@debian.org>
 <CA+FuTSeKpOJVqcneCoh_4x4OuK1iE0Tr6f3rSNrQiR-OUgjWow@mail.gmail.com>
 <ZC7seVq7St6UnKjl@gmail.com>
 <CA+FuTSf9LEhzjBey_Nm_-vN0ZjvtBSQkcDWS+5uBnLmr8Qh5uA@mail.gmail.com>
 <e576f6fe-d1f3-93cd-cb94-c0ae115299d8@kernel.org>
 <ZDVLyi1PahE0sfci@gmail.com>
 <75e3c434-eb8b-66e5-5768-ca0f906979a1@kernel.org>
 <67831406-8d2f-feff-f56b-d0f002a95d96@kernel.dk>
 <ea36790d-b2fe-0b4d-1bfc-be7b20b1614b@kernel.org>
 <b56c03b3-d948-2fdf-bc5d-635ecfdf1592@kernel.dk>
 <a9858183-8f69-7aff-51ac-122f627ba66f@kernel.org>
In-Reply-To: <a9858183-8f69-7aff-51ac-122f627ba66f@kernel.org>
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgQWhlcm4NCj4gU2VudDogMTEgQXByaWwgMjAyMyAxNjoyOA0KLi4uLg0KPiBD
aHJpc3RvcGgncyBwYXRjaCBzZXQgYSBmZXcgeWVhcnMgYmFjayB0aGF0IHJlbW92ZWQgc2V0X2Zz
IGJyb2tlIHRoZQ0KPiBhYmlsaXR5IHRvIGRvIGluLWtlcm5lbCBpb2N0bCBhbmQge3MsZ31zZXRz
b2Nrb3B0IGNhbGxzLiBJIGRpZCBub3QNCj4gZm9sbG93IHRoYXQgY2hhbmdlOyB3YXMgaXQgYSBk
ZWxpYmVyYXRlIGludGVudCB0byBub3QgYWxsb3cgdGhlc2UNCj4gaW4ta2VybmVsIGNhbGxzIHZz
IHdhbnRpbmcgdG8gcmVtb3ZlIHRoZSBzZXRfZnM/IGUuZy4sIGNhbiB3ZSBhZGQgYQ0KPiBraW9j
dGwgdmFyaWFudCBmb3IgaW4ta2VybmVsIHVzZSBvZiB0aGUgQVBJcz8NCg0KSSB0aGluayB0aGF0
IHdhcyBhIHNpZGUgZWZmZWN0LCBhbmQgd2l0aCBubyBpbi10cmVlIGluLWtlcm5lbA0KdXNlcnMg
KGFwYXJ0IGZyb20gbGltaXRlZCBjYWxscyBpbiBicGYpIGl0IHdhcyBkZWVtZWQgYWNjZXB0YWJs
ZS4NCihJdCBpcyBhIFBJVEEgZm9yIGFueSBjb2RlIHRyeWluZyB0byB1c2UgU0NUUCBpbiBrZXJu
ZWwuKQ0KDQpPbmUgcHJvYmxlbSBpcyB0aGF0IG5vdCBhbGwgc29ja29wdCBjYWxscyBwYXNzIHRo
ZSBjb3JyZWN0IGxlbmd0aC4NCkFuZCBzb21lIG9mIHRoZW0gY2FuIGhhdmUgdmVyeSBsb25nIGJ1
ZmZlcnMuDQpOb3QgdG8gbWVudGlvbiB0aGUgb25lcyB0aGF0IGFyZSByZWFkLW1vZGlmeS13cml0
ZS4NCg0KQSBwbGF1c2libGUgc29sdXRpb24gaXMgdG8gcGFzcyBhICdmYXQgcG9pbnRlcicgdGhh
dCBjb250YWlucw0Kc29tZSwgb3IgYWxsLCBvZjoNCgktIEEgdXNlcnNwYWNlIGJ1ZmZlciBwb2lu
dGVyLg0KCS0gQSBrZXJuZWwgYnVmZmVyIHBvaW50ZXIuDQoJLSBUaGUgbGVuZ3RoIHN1cHBsaWVk
IGJ5IHRoZSB1c2VyLg0KCS0gVGhlIGxlbmd0aCBvZiB0aGUga2VybmVsIGJ1ZmZlci4NCgk9IFRo
ZSBudW1iZXIgb2YgYnl0ZXMgdG8gY29weSBvbiBjb21wbGV0aW9uLg0KRm9yIHNpbXBsZSB1c2Vy
IHJlcXVlc3RzIHRoZSBzeXNjYWxsIGVudHJ5L2V4aXQgY29kZQ0Kd291bGQgY29weSB0aGUgZGF0
YSB0byBhIHNob3J0IG9uLXN0YWNrIGJ1ZmZlci4NCktlcm5lbCB1c2VycyBqdXN0IHBhc3MgdGhl
IGtlcm5lbCBhZGRyZXNzLg0KT2RkIHJlcXVlc3RzIGNhbiBqdXN0IHVzZSB0aGUgdXNlciBwb2lu
dGVyLg0KDQpQcm9iYWJseSBuZWVkcyBhY2Nlc3NvcnMgdGhhdCBhZGQgaW4gYW4gb2Zmc2V0Lg0K
DQpJdCBtaWdodCBhbHNvIGJlIHRoYXQgc29tZSBvZiB0aGUgcHJvYmxlbWF0aWMgc29ja29wdA0K
d2VyZSBpbiBkZWNuZXQgLSBub3cgcmVtb3ZlZC4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQg
QWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVz
LCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

