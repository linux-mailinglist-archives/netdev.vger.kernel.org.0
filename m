Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0D6B6E1078
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 16:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbjDMO5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 10:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbjDMO5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 10:57:21 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED028A6F
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 07:57:19 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-283-VYiBd9UaPUGp8ziWiCEyvQ-1; Thu, 13 Apr 2023 15:57:17 +0100
X-MC-Unique: VYiBd9UaPUGp8ziWiCEyvQ-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 13 Apr
 2023 15:57:15 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Thu, 13 Apr 2023 15:57:15 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Willem de Bruijn' <willemdebruijn.kernel@gmail.com>,
        Breno Leitao <leitao@debian.org>
CC:     Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        "Willem de Bruijn" <willemb@google.com>,
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
        "matthieu.baerts@tessares.net" <matthieu.baerts@tessares.net>,
        "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>
Subject: RE: [PATCH 0/5] add initial io_uring_cmd support for sockets
Thread-Topic: [PATCH 0/5] add initial io_uring_cmd support for sockets
Thread-Index: AQHZbhOpyiioZyVNEkW7nkcDZ6Um0a8pUhFA
Date:   Thu, 13 Apr 2023 14:57:15 +0000
Message-ID: <ccd3418b232c4d06b1729e84c2762dc4@AcuMS.aculab.com>
References: <75e3c434-eb8b-66e5-5768-ca0f906979a1@kernel.org>
 <67831406-8d2f-feff-f56b-d0f002a95d96@kernel.dk>
 <643573df81e20_11117c2942@willemb.c.googlers.com.notmuch>
 <036c80e5-4844-5c84-304c-7e553fe17a9b@kernel.dk>
 <64357608c396d_113ebd294ba@willemb.c.googlers.com.notmuch>
 <19c69021-dce3-1a4a-00eb-920d1f404cfc@kernel.dk>
 <64357bb97fb19_114b22294c4@willemb.c.googlers.com.notmuch>
 <20cb4641-c765-e5ef-41cb-252be7721ce5@kernel.dk> <ZDa32u9RNI4NQ7Ko@gmail.com>
 <6436c01979c9b_163b6294b4@willemb.c.googlers.com.notmuch>
 <ZDdGl/JGDoRDL8ja@gmail.com>
 <6438109fe8733_13361929472@willemb.c.googlers.com.notmuch>
In-Reply-To: <6438109fe8733_13361929472@willemb.c.googlers.com.notmuch>
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

RnJvbTogV2lsbGVtIGRlIEJydWlqbg0KPiBTZW50OiAxMyBBcHJpbCAyMDIzIDE1OjI1DQouLi4N
Cj4gPiBGb3IgaW5zdGFuY2UgdGhlIHJhd19pb2N0bCgpL3Jhd3Y2X2lvY3RsKCkgY2FzZS4gVGhl
ICJhcmciIGFyZ3VtZW50IGlzDQo+ID4gdXNlZCBpbiBkaWZmZXJlbnQgd2F5cyAob25lIGZvciBp
bnB1dCBhbmQgb25lIGZvciBvdXRwdXQpOg0KPiA+DQo+ID4gICAxKSBJZiBjbWQgPT0gU0lPQ09V
VFEgb3IgU0lPQ0lOUSwgdGhlbiB0aGUgcmV0dXJuIHZhbHVlIHdpbGwgYmUNCj4gPiAgIHJldHVy
bmVkIHRvIHVzZXJzcGFjZToNCj4gPiAgIAlwdXRfdXNlcihhbW91bnQsIChpbnQgX191c2VyICop
YXJnKQ0KDQpUaGVyZSBpcyBhbHdheXMgdGhlIG9wdGlvbiBvZiBkZWZpbmluZyBhbHRlcm5hdGUg
aW9jdGwNCidjbWQnIGNvZGVzIHRoYXQgdXNlciBJT1IoKSBhbmQgSU9XKCkgYW5kIHJlcXVpcmlu
ZyB0aGF0DQppb191cmluZyBhcHBsaWNhdGlvbnMgdXNlIHRoZSBhbHRlcm5hdGUgZm9ybXMuDQoN
ClRoZW4gaGF2ZSB0d28gJ2lvY3RsJyBmdW5jdGlvbnMgd2l0aCBhIG5ldyBvbmUgZm9yIElPUigp
DQp0eXBlIGNvbW1hbmRzIGFuZCB0aGUgZXhpc3Rpbmcgb25lIGZvciBjb21wYXRpYmlsaXR5DQp0
aGF0IG1pZ2h0IGp1c3QgZG8gYSB0cmFuc2xhdGlvbiAob3IgcmV0dXJuIGEgdHJhbnNsYXRlZA0K
Y29tbWFuZCB0byBhdm9pZCBleHRyYSBzdGFjayB1c2UpLg0KDQpZb3UgbWF5IHN0aWxsIHdhbnQg
dG8gcGFzcyB0aHJvdWdoIGJvdGggdGhlIGtlcm5lbCBhbmQNCnVzZXIgKGlmIGEgdXNlciByZXF1
ZXN0KSBidWZmZXIgYWRkcmVzc2VzIHRvIGFsbG93IGZvcg0KdGhvc2UgYnJva2VuIHJlcXVlc3Rz
IHdoZXJlIHRoZSBidWZmZXIgZGlyZWN0aW9uIGJpdHMNCmFyZSB3cm9uZy4NCg0KCURhdmlkDQoN
Ci0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJt
LCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChX
YWxlcykNCg==

