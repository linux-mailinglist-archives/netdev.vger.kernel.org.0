Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 464E55EBBC5
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 09:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbiI0HmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 03:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbiI0HmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 03:42:00 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD039A9FB
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 00:41:58 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-14-jMsfJ6V8OjGSAZiFmgYF0g-1; Tue, 27 Sep 2022 08:41:55 +0100
X-MC-Unique: jMsfJ6V8OjGSAZiFmgYF0g-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Tue, 27 Sep
 2022 08:41:52 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.040; Tue, 27 Sep 2022 08:41:52 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'Jason A. Donenfeld'" <Jason@zx2c4.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Sherry Yang <sherry.yang@oracle.com>,
        Paul Webb <paul.x.webb@oracle.com>,
        Phillip Goerl <phillip.goerl@oracle.com>,
        Jack Vogel <jack.vogel@oracle.com>,
        Nicky Veitch <nicky.veitch@oracle.com>,
        Colm Harrington <colm.harrington@oracle.com>,
        Ramanan Govindarajan <ramanan.govindarajan@oracle.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tejun Heo <tj@kernel.org>,
        Sultan Alsawaf <sultan@kerneltoast.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] random: use immediate per-cpu timer rather than
 workqueue for mixing fast pool
Thread-Topic: [PATCH v2] random: use immediate per-cpu timer rather than
 workqueue for mixing fast pool
Thread-Index: AQHY0fQr7t6Ylvgn6ECciijyeMbEm63y5QKQ
Date:   Tue, 27 Sep 2022 07:41:52 +0000
Message-ID: <62ae29f10d65401ab79e9bdb6af1576a@AcuMS.aculab.com>
References: <20220922165528.3679479-1-Jason@zx2c4.com>
 <20220926220457.1517120-1-Jason@zx2c4.com>
In-Reply-To: <20220926220457.1517120-1-Jason@zx2c4.com>
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

RnJvbTogSmFzb24gQS4gRG9uZW5mZWxkDQo+IFNlbnQ6IDI2IFNlcHRlbWJlciAyMDIyIDIzOjA1
DQo+IA0KPiBQcmV2aW91c2x5LCB0aGUgZmFzdCBwb29sIHdhcyBkdW1wZWQgaW50byB0aGUgbWFp
biBwb29sIHBlcm9pZGljYWxseSBpbg0KPiB0aGUgZmFzdCBwb29sJ3MgaGFyZCBJUlEgaGFuZGxl
ci4gVGhpcyB3b3JrZWQgZmluZSBhbmQgdGhlcmUgd2VyZW4ndA0KPiBwcm9ibGVtcyB3aXRoIGl0
LCB1bnRpbCBSVCBjYW1lIGFyb3VuZC4gU2luY2UgUlQgY29udmVydHMgc3BpbmxvY2tzIGludG8N
Cj4gc2xlZXBpbmcgbG9ja3MsIHByb2JsZW1zIGNyb3BwZWQgdXAuIFJhdGhlciB0aGFuIHN3aXRj
aGluZyB0byByYXcNCj4gc3BpbmxvY2tzLCB0aGUgUlQgZGV2ZWxvcGVycyBwcmVmZXJyZWQgd2Ug
bWFrZSB0aGUgdHJhbnNmb3JtYXRpb24gZnJvbQ0KPiBvcmlnaW5hbGx5IGRvaW5nOg0KPiANCj4g
ICAgIGRvX3NvbWVfc3R1ZmYoKQ0KPiAgICAgc3Bpbl9sb2NrKCkNCj4gICAgIGRvX3NvbWVfb3Ro
ZXJfc3R1ZmYoKQ0KPiAgICAgc3Bpbl91bmxvY2soKQ0KPiANCj4gdG8gZG9pbmc6DQo+IA0KPiAg
ICAgZG9fc29tZV9zdHVmZigpDQo+ICAgICBxdWV1ZV93b3JrX29uKHNvbWVfb3RoZXJfc3R1ZmZf
d29ya2VyKQ0KPiANCj4gVGhpcyBpcyBhbiBvcmRpbmFyeSBwYXR0ZXJuIGRvbmUgYWxsIG92ZXIg
dGhlIGtlcm5lbC4gSG93ZXZlciwgU2hlcnJ5DQo+IG5vdGljZWQgYSAxMCUgcGVyZm9ybWFuY2Ug
cmVncmVzc2lvbiBpbiBxcGVyZiBUQ1Agb3ZlciBhIDQwZ2Jwcw0KPiBJbmZpbmlCYW5kIGNhcmQu
IFF1b3RpbmcgaGVyIG1lc3NhZ2U6DQo+IA0KPiA+IE1UMjc1MDAgRmFtaWx5IFtDb25uZWN0WC0z
XSBjYXJkczoNCj4gPiBJbmZpbmliYW5kIGRldmljZSAnbWx4NF8wJyBwb3J0IDEgc3RhdHVzOg0K
PiA+IGRlZmF1bHQgZ2lkOiBmZTgwOjAwMDA6MDAwMDowMDAwOjAwMTA6ZTAwMDowMTc4OjllYjEN
Cj4gPiBiYXNlIGxpZDogMHg2DQo+ID4gc20gbGlkOiAweDENCj4gPiBzdGF0ZTogNDogQUNUSVZF
DQo+ID4gcGh5cyBzdGF0ZTogNTogTGlua1VwDQo+ID4gcmF0ZTogNDAgR2Ivc2VjICg0WCBRRFIp
DQo+ID4gbGlua19sYXllcjogSW5maW5pQmFuZA0KPiA+DQo+ID4gQ2FyZHMgYXJlIGNvbmZpZ3Vy
ZWQgd2l0aCBJUCBhZGRyZXNzZXMgb24gcHJpdmF0ZSBzdWJuZXQgZm9yIElQb0lCDQo+ID4gcGVy
Zm9ybWFuY2UgdGVzdGluZy4NCj4gPiBSZWdyZXNzaW9uIGlkZW50aWZpZWQgaW4gdGhpcyBidWcg
aXMgaW4gVENQIGxhdGVuY3kgaW4gdGhpcyBzdGFjayBhcyByZXBvcnRlZA0KPiA+IGJ5IHFwZXJm
IHRjcF9sYXQgbWV0cmljOg0KPiA+DQo+ID4gV2UgaGF2ZSBvbmUgc3lzdGVtIGxpc3RlbiBhcyBh
IHFwZXJmIHNlcnZlcjoNCj4gPiBbcm9vdEB5b3VyUXBlcmZTZXJ2ZXIgfl0jIHFwZXJmDQo+ID4N
Cj4gPiBIYXZlIHRoZSBvdGhlciBzeXN0ZW0gY29ubmVjdCB0byBxcGVyZiBzZXJ2ZXIgYXMgYSBj
bGllbnQgKGluIHRoaXMNCj4gPiBjYXNlLCBpdOKAmXMgWDcgc2VydmVyIHdpdGggTWVsbGFub3gg
Y2FyZCk6DQo+ID4gW3Jvb3RAeW91clFwZXJmQ2xpZW50IH5dIyBudW1hY3RsIC1tMCAtTjAgcXBl
cmYgMjAuMjAuMjAuMTAxIC12IC11dSAtdWIgLS10aW1lIDYwIC0td2FpdF9zZXJ2ZXIgMjAgLQ0K
PiBvbyBtc2dfc2l6ZTo0SzoxMDI0SzoqMiB0Y3BfbGF0DQo+IA0KPiBSYXRoZXIgdGhhbiBpbmN1
ciB0aGUgc2NoZWR1bGluZyBsYXRlbmN5IGZyb20gcXVldWVfd29ya19vbiwgd2UgY2FuDQo+IGlu
c3RlYWQgc3dpdGNoIHRvIHJ1bm5pbmcgb24gdGhlIG5leHQgdGltZXIgdGljaywgb24gdGhlIHNh
bWUgY29yZSwNCj4gZGVmZXJyYWJseSBzby4gVGhpcyBhbHNvIGJhdGNoZXMgdGhpbmdzIGEgYml0
IG1vcmUgLS0gb25jZSBwZXIgamlmZnkgLS0NCj4gd2hpY2ggaXMgcHJvYmFibHkgb2theSBub3cg
dGhhdCBtaXhfaW50ZXJydXB0X3JhbmRvbW5lc3MoKSBjYW4gY3JlZGl0DQo+IG11bHRpcGxlIGJp
dHMgYXQgb25jZS4gSXQgc3RpbGwgcHV0cyBhIGJpdCBvZiBwcmVzc3VyZSBvbiBmYXN0X21peCgp
LA0KPiBidXQgaG9wZWZ1bGx5IHRoYXQncyBhY2NlcHRhYmxlLg0KDQpJIHRob3VnaCBOT0haIHN5
c3RlbXMgZGlkbid0IHRha2UgYSB0aW1lciBpbnRlcnJ1cHQgZXZlcnkgJ2ppZmZ5Jy4NCklmIHRo
YXQgaXMgdHJ1ZSB3aGF0IGFjdHVhbGx5IGhhcHBlbnM/DQoNCglEYXZpZA0KDQotDQpSZWdpc3Rl
cmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtl
eW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

