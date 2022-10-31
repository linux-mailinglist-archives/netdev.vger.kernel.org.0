Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C96A66139FD
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 16:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbiJaP1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 11:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbiJaP1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 11:27:12 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ECEA263B
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 08:27:11 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-116-ZgOqlFTPPOq0OlbjIZXOPQ-1; Mon, 31 Oct 2022 15:27:09 +0000
X-MC-Unique: ZgOqlFTPPOq0OlbjIZXOPQ-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 31 Oct
 2022 15:27:07 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.042; Mon, 31 Oct 2022 15:27:07 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Horatiu Vultur' <horatiu.vultur@microchip.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH net v2 0/3] net: lan966x: Fixes for when MTU is changed
Thread-Topic: [PATCH net v2 0/3] net: lan966x: Fixes for when MTU is changed
Thread-Index: AQHY7Kcu7Ao/FHDvc0OFOxRqKUrPo64oT9IwgABKM4CAAAFVEA==
Date:   Mon, 31 Oct 2022 15:27:07 +0000
Message-ID: <219ebe83a5ad4467937545ee5a0e77e4@AcuMS.aculab.com>
References: <20221030213636.1031408-1-horatiu.vultur@microchip.com>
 <b75a7136030846f587e555763ef2750e@AcuMS.aculab.com>
 <20221031150133.2be5xr7cmuhr4gng@soft-dev3-1>
In-Reply-To: <20221031150133.2be5xr7cmuhr4gng@soft-dev3-1>
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogJ0hvcmF0aXUgVnVsdHVyJw0KPiBTZW50OiAzMSBPY3RvYmVyIDIwMjIgMTU6MDINCj4g
DQo+IFRoZSAxMC8zMS8yMDIyIDEwOjQzLCBEYXZpZCBMYWlnaHQgd3JvdGU6DQo+ID4NCj4gPiBG
cm9tOiBIb3JhdGl1IFZ1bHR1cg0KPiA+ID4gU2VudDogMzAgT2N0b2JlciAyMDIyIDIxOjM3DQo+
IA0KPiBIaSBEYXZpZCwNCj4gDQo+ID4gPg0KPiA+ID4gVGhlcmUgd2VyZSBtdWx0aXBsZSBwcm9i
bGVtcyBpbiBkaWZmZXJlbnQgcGFydHMgb2YgdGhlIGRyaXZlciB3aGVuDQo+ID4gPiB0aGUgTVRV
IHdhcyBjaGFuZ2VkLg0KPiA+ID4gVGhlIGZpcnN0IHByb2JsZW0gd2FzIHRoYXQgdGhlIEhXIHdh
cyBtaXNzaW5nIHRvIGNvbmZpZ3VyZSB0aGUgY29ycmVjdA0KPiA+ID4gdmFsdWUsIGl0IHdhcyBt
aXNzaW5nIEVUSF9ITEVOIGFuZCBFVEhfRkNTX0xFTi4gVGhlIHNlY29uZCBwcm9ibGVtIHdhcw0K
PiA+ID4gd2hlbiB2bGFuIGZpbHRlcmluZyB3YXMgZW5hYmxlZC9kaXNhYmxlZCwgdGhlIE1SVSB3
YXMgbm90IGFkanVzdGVkDQo+ID4gPiBjb3JyZXRseS4gV2hpbGUgdGhlIGxhc3QgaXNzdWUgd2Fz
IHRoYXQgdGhlIEZETUEgd2FzIGNhbGN1bGF0ZWQgd3JvbmdseQ0KPiA+ID4gdGhlIGNvcnJlY3Qg
bWF4aW11bSBNVFUuDQo+ID4NCj4gPiBJSVJDIGFsbCB0aGVzZSBsZW5ndGhzIGFyZSAxNTE0LCAx
NTE4IGFuZCBtYXliZSAxNTIyPw0KPiANCj4gQW5kIGFsc28gMTUyNiwgaWYgdGhlIGZyYW1lIGhh
cyAyIHZsYW4gdGFncy4NCj4gDQo+ID4gSG93IGxvbmcgYXJlIHRoZSBhY3R1YWwgcmVjZWl2ZSBi
dWZmZXJzPw0KPiA+IEknZCBndWVzcyB0aGV5IGhhdmUgdG8gYmUgcm91bmRlZCB1cCB0byBhIHdo
b2xlIG51bWJlciBvZiBjYWNoZSBsaW5lcw0KPiA+IChlc3BlY2lhbGx5IG9uIG5vbi1jb2hlcmVu
dCBzeXN0ZW1zKSBzbyBhcmUgcHJvYmFibHkgMTUzNiBieXRlcy4NCj4gDQo+IFRoZSByZWNlaXZl
IGJ1ZmZlcnMgY2FuIGJlIGRpZmZlcmVudCBzaXplcywgaXQgY2FuIGJlIHVwIHRvIDY1ay4NCj4g
VGhleSBhcmUgY3VycmVudGx5IGFsbGlnbiB0byBwYWdlIHNpemUuDQoNCklzIHRoYXQgbmVjZXNz
YXJ5Pw0KSSBkb24ndCBrbm93IHdoZXJlIHRoZSBidWZmZXJzIGFyZSBhbGxvY2F0ZWQsIGJ1dCBl
dmVuIDRrIHNlZW1zDQphIGJpdCBwcm9mbGlnYXRlIGZvciBub3JtYWwgZXRoZXJuZXQgbXR1Lg0K
SWYgdGhlIHBhZ2Ugc2l6ZSBpZiBsYXJnZXIgaXQgaXMgZXZlbiBzaWxsaWVyLg0KDQpJZiB0aGUg
YnVmZmVyIGlzIGVtYmVkZGVkIGluIGFuIHNrYiB5b3UgcmVhbGx5IHdhbnQgdGhlIHNrYg0KdG8g
YmUgdW5kZXIgNGsgKEkgZG9uJ3QgdGhpbmsgYSAxNTAwIGJ5dGUgbXR1IGNhbiBmaXQgaW4gMmsp
Lg0KDQpCdXQgeW91IG1pZ2h0IGFzIHdlbGwgdGVsbCB0aGUgaGFyZHdhcmUgdGhlIGFjdHVhbCBi
dWZmZXIgbGVuZ3RoDQoocmVtZW1iZXIgdG8gYWxsb3cgZm9yIHRoZSBjcmMgYW5kIGFueSBhbGln
bm1lbnQgaGVhZGVyKS4NCg0KPiA+DQo+ID4gSWYgZHJpdmVyIGRvZXMgc3VwcG9ydCA4aysganVt
Ym8gZnJhbWVzIGp1c3Qgc2V0IHRoZSBoYXJkd2FyZQ0KPiA+IGZyYW1lIGxlbmd0aCB0byBtYXRj
aCB0aGUgcmVjZWl2ZSBidWZmZXIgc2l6ZS4NCj4gDQo+IEluIHRoYXQgY2FzZSBJIHNob3VsZCBh
bHdheXMgYWxsb2NhdGUgbWF4aW11bSBmcmFtZSBzaXplKDY1aykgZm9yIGFsbA0KPiByZWdhcmRs
ZXNzIG9mIHRoZSBNVFU/DQoNClRoYXQgd291bGQgYmUgdmVyeSB3YXN0ZWZ1bC4gSSdkIHNldCB0
aGUgYnVmZmVyIGxhcmdlIGVub3VnaCBmb3INCnRoZSBtdHUgYnV0IGxldCB0aGUgaGFyZHdhcmUg
ZmlsbCB0aGUgZW50aXJlIGJ1ZmZlci4NCg0KQWxsb2NhdGluZyA2NGsgYnVmZmVycyBmb3IgYmln
IGp1bWJvIGZyYW1lcyBkb2Vzbid0IHNlZW0gcmlnaHQuDQpJZiB0aGUgbXR1IGlzIDY0ayB0aGVu
IGttYWxsb2MoKSB3aWxsIGFsbG9jYXRlIDEyOGsuDQpUaGlzIGlzIGdvaW5nIHRvIGNhdXNlICdv
ZGRpdGllcycgd2l0aCBzbWFsbCBwYWNrZXRzIHdoZXJlDQp0aGUgJ3RydWVfc2l6ZScgaXMgbWFz
c2l2ZWx5IG1vcmUgdGhhbiB0aGUgZGF0YSBzaXplLg0KDQpJc24ndCB0aGVyZSBhIHNjaGVtZSB3
aGVyZSB5b3UgY2FuIGNyZWF0ZSBhbiBza2IgZnJvbSBhIHBhZ2UNCmxpc3QgdGhhdCBjb250YWlu
cyBmcmFnbWVudHMgb2YgdGhlIGV0aGVybmV0IGZyYW1lPw0KSW4gd2hpY2ggY2FzZSBJJ2QgaGF2
ZSB0aG91Z2h0IHlvdSdkIHdhbnQgdG8gZmlsbCB0aGUgcmluZw0Kd2l0aCBwYWdlIHNpemUgYnVm
ZmVycyBhbmQgdGhlbiBoYW5kbGUgdGhlIGhhcmR3YXJlIHdyaXRpbmcNCmEgbG9uZyBmcmFtZSB0
byBtdWx0aXBsZSBidWZmZXJzL2Rlc2NyaXB0b3JzLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJl
ZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXlu
ZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

