Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7157E61463E
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 10:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiKAJEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 05:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiKAJED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 05:04:03 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306D0111B
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 02:04:00 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-185-Vrhm70DvNdKDrYI_nwBrAw-1; Tue, 01 Nov 2022 09:03:58 +0000
X-MC-Unique: Vrhm70DvNdKDrYI_nwBrAw-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 1 Nov
 2022 09:03:56 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.042; Tue, 1 Nov 2022 09:03:56 +0000
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
Thread-Index: AQHY7Kcu7Ao/FHDvc0OFOxRqKUrPo64oT9IwgABKM4CAAAFVEIABGvgAgAAOPSA=
Date:   Tue, 1 Nov 2022 09:03:56 +0000
Message-ID: <de73370512334c76b1500e12cfd33005@AcuMS.aculab.com>
References: <20221030213636.1031408-1-horatiu.vultur@microchip.com>
 <b75a7136030846f587e555763ef2750e@AcuMS.aculab.com>
 <20221031150133.2be5xr7cmuhr4gng@soft-dev3-1>
 <219ebe83a5ad4467937545ee5a0e77e4@AcuMS.aculab.com>
 <20221101075906.ets6zsti3c54idae@soft-dev3-1>
In-Reply-To: <20221101075906.ets6zsti3c54idae@soft-dev3-1>
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

RnJvbTogJ0hvcmF0aXUgVnVsdHVyJw0KPiBTZW50OiAwMSBOb3ZlbWJlciAyMDIyIDA3OjU5DQo+
IA0KPiBUaGUgMTAvMzEvMjAyMiAxNToyNywgRGF2aWQgTGFpZ2h0IHdyb3RlOg0KPiA+DQo+ID4g
RnJvbTogJ0hvcmF0aXUgVnVsdHVyJw0KPiA+ID4gU2VudDogMzEgT2N0b2JlciAyMDIyIDE1OjAy
DQo+ID4gPg0KPiA+ID4gVGhlIDEwLzMxLzIwMjIgMTA6NDMsIERhdmlkIExhaWdodCB3cm90ZToN
Cj4gPiA+ID4NCj4gPiA+ID4gRnJvbTogSG9yYXRpdSBWdWx0dXINCj4gPiA+ID4gPiBTZW50OiAz
MCBPY3RvYmVyIDIwMjIgMjE6MzcNCj4gPiA+DQo+ID4gPiBIaSBEYXZpZCwNCj4gPiA+DQo+ID4g
PiA+ID4NCj4gPiA+ID4gPiBUaGVyZSB3ZXJlIG11bHRpcGxlIHByb2JsZW1zIGluIGRpZmZlcmVu
dCBwYXJ0cyBvZiB0aGUgZHJpdmVyIHdoZW4NCj4gPiA+ID4gPiB0aGUgTVRVIHdhcyBjaGFuZ2Vk
Lg0KPiA+ID4gPiA+IFRoZSBmaXJzdCBwcm9ibGVtIHdhcyB0aGF0IHRoZSBIVyB3YXMgbWlzc2lu
ZyB0byBjb25maWd1cmUgdGhlIGNvcnJlY3QNCj4gPiA+ID4gPiB2YWx1ZSwgaXQgd2FzIG1pc3Np
bmcgRVRIX0hMRU4gYW5kIEVUSF9GQ1NfTEVOLiBUaGUgc2Vjb25kIHByb2JsZW0gd2FzDQo+ID4g
PiA+ID4gd2hlbiB2bGFuIGZpbHRlcmluZyB3YXMgZW5hYmxlZC9kaXNhYmxlZCwgdGhlIE1SVSB3
YXMgbm90IGFkanVzdGVkDQo+ID4gPiA+ID4gY29ycmV0bHkuIFdoaWxlIHRoZSBsYXN0IGlzc3Vl
IHdhcyB0aGF0IHRoZSBGRE1BIHdhcyBjYWxjdWxhdGVkIHdyb25nbHkNCj4gPiA+ID4gPiB0aGUg
Y29ycmVjdCBtYXhpbXVtIE1UVS4NCj4gPiA+ID4NCj4gPiA+ID4gSUlSQyBhbGwgdGhlc2UgbGVu
Z3RocyBhcmUgMTUxNCwgMTUxOCBhbmQgbWF5YmUgMTUyMj8NCj4gPiA+DQo+ID4gPiBBbmQgYWxz
byAxNTI2LCBpZiB0aGUgZnJhbWUgaGFzIDIgdmxhbiB0YWdzLg0KPiA+ID4NCj4gPiA+ID4gSG93
IGxvbmcgYXJlIHRoZSBhY3R1YWwgcmVjZWl2ZSBidWZmZXJzPw0KPiA+ID4gPiBJJ2QgZ3Vlc3Mg
dGhleSBoYXZlIHRvIGJlIHJvdW5kZWQgdXAgdG8gYSB3aG9sZSBudW1iZXIgb2YgY2FjaGUgbGlu
ZXMNCj4gPiA+ID4gKGVzcGVjaWFsbHkgb24gbm9uLWNvaGVyZW50IHN5c3RlbXMpIHNvIGFyZSBw
cm9iYWJseSAxNTM2IGJ5dGVzLg0KPiA+ID4NCj4gPiA+IFRoZSByZWNlaXZlIGJ1ZmZlcnMgY2Fu
IGJlIGRpZmZlcmVudCBzaXplcywgaXQgY2FuIGJlIHVwIHRvIDY1ay4NCj4gPiA+IFRoZXkgYXJl
IGN1cnJlbnRseSBhbGxpZ24gdG8gcGFnZSBzaXplLg0KPiA+DQo+ID4gSXMgdGhhdCBuZWNlc3Nh
cnk/DQo+IA0KPiBIVyByZXF1aXJlcyB0byBoYXZlIHRoZSBzdGFydCBvZiBmcmFtZSBhbGxpZ25l
ZCB0byAxMjggYnl0ZXMuDQoNCk5vdCBhIHJlYWwgcHJvYmxlbS4NCkV2ZW4gZG1hX2FsbG9jX2Nv
aGVyZW50KCkgZ3VhcmFudGVlcyBhbGlnbm1lbnQuDQoNCkknbSBub3QgMTAwJSBzdXJlIG9mIGFs
bCB0aGUgb3B0aW9ucyBvZiB0aGUgTGludXggc3RhY2suDQpCdXQgZm9yIH4xNTAwIGJ5dGUgbXR1
IEknZCBoYXZlIHRob3VnaHQgdGhhdCByZWNlaXZpbmcNCmRpcmVjdGx5IGludG8gYW4gc2tiIHdv
dWxkIGJlIGJlc3QgKDEgcGFnZSBhbGxvY2F0ZWQgZm9yIGFuIHNrYikuDQpGb3IgbGFyZ2UgbXR1
IChhbmQgaGFyZHdhcmUgcmVjZWl2ZSBjb2FsZXNjaW5nKSByZWNlaXZpbmcNCmludG8gcGFnZXMg
aXMgcHJvYmFibHkgYmV0dGVyIC0gYnV0IG5vdCBoaWdoIG9yZGVyIGFsbG9jYXRpb25zLg0KDQou
Li4NCj4gPiBJZiB0aGUgYnVmZmVyIGlzIGVtYmVkZGVkIGluIGFuIHNrYiB5b3UgcmVhbGx5IHdh
bnQgdGhlIHNrYg0KPiA+IHRvIGJlIHVuZGVyIDRrIChJIGRvbid0IHRoaW5rIGEgMTUwMCBieXRl
IG10dSBjYW4gZml0IGluIDJrKS4NCj4gPg0KPiA+IEJ1dCB5b3UgbWlnaHQgYXMgd2VsbCB0ZWxs
IHRoZSBoYXJkd2FyZSB0aGUgYWN0dWFsIGJ1ZmZlciBsZW5ndGgNCj4gPiAocmVtZW1iZXIgdG8g
YWxsb3cgZm9yIHRoZSBjcmMgYW5kIGFueSBhbGlnbm1lbnQgaGVhZGVyKS4NCj4gDQo+IEkgYW0g
YWxyZWFkeSBkb2luZyB0aGF0IGhlcmUgWzJdDQo+IEFuZCBJIG5lZWQgdG8gZG8gaXQgZm9yIGVh
Y2ggZnJhbWUgaXQgY2FuIHJlY2VpdmVkLg0KDQpUaGF0IGlzIHRoZSBsZW5ndGggb2YgdGhlIGJ1
ZmZlci4NCk5vdCB0aGUgbWF4aW11bSBmcmFtZSBsZW5ndGggLSB3aGljaCBzZWVtcyB0byBiZSBl
bHNld2hlcmUuDQpJIHN1c3BlY3QgdGhhdCBoYXZpbmcgdGhlIG1heGltdW0gZnJhbWUgbGVuZ3Ro
IGxlc3MgdGhhbiB0aGUNCmJ1ZmZlciBzaXplIHN0b3BzIHRoZSBkcml2ZXIgaGF2aW5nIHRvIGhh
bmRsZSBsb25nIGZyYW1lcw0KdGhhdCBzcGFuIG11bHRpcGxlIGJ1ZmZlcnMuDQooYW5kIHZlcnkg
bG9uZyBmcmFtZXMgdGhhdCBhcmUgbG9uZ2VyIHRoYW4gYWxsIHRoZSBidWZmZXJzISkNCg0KLi4u
DQo+ID4gSSdkIHNldCB0aGUgYnVmZmVyIGxhcmdlIGVub3VnaCBmb3IgdGhlIG10dSBidXQgbGV0
IHRoZSBoYXJkd2FyZSBmaWxsDQo+ID4gdGhlIGVudGlyZSBidWZmZXIuDQo+IA0KPiBJIGFtIG5v
dCAxMDAlIHN1cmUgSSBmb2xsb3cgaXQuIENhbiB5b3UgZXhwZW5kIG9uIHRoaXMgYSBsaXR0bGUg
Yml0Pw0KDQpBdCB0aGUgbW9tZW50IEkgdGhpbmsgdGhlIHJlY2VpdmUgYnVmZmVyIGRlc2NyaXB0
b3JzIGhhdmUgYSBsZW5ndGgNCm9mIDRrLiBCdXQgeW91IGFyZSBzZXR0aW5nIGFub3RoZXIgJ21h
eGltdW0gZnJhbWUgbGVuZ3RoJyByZWdpc3Rlcg0KdG8gKGVnKSAxNTE4IHNvIHRoYXQgdGhlIGhh
cmR3YXJlIHJlamVjdHMgbG9uZyBmcmFtZXMuDQpCdXQgeW91IGNhbiBzZXQgdGhlICdtYXhpbXVt
IGZyYW1lIGxlbmd0aCcgcmVnaXN0ZXIgdG8gKGp1c3QgdW5kZXIpDQo0ayBzbyB0aGF0IGxvbmdl
ciBmcmFtZXMgYXJlIHJlY2VpdmVkIG9rIGJ1dCB3aXRob3V0IHRoZSBkcml2ZXINCmhhdmluZyB0
byB3b3JyeSBhYm91dCBmcmFtZXMgc3Bhbm5pbmcgbXVsdGlwbGUgYnVmZmVyIGZyYWdtZW50cy4N
Cg0KVGhlIG5ldHdvcmsgc3RhY2sgbWlnaHQgY2hvb3NlIHRvIGRpc2NhcmQgZnJhbWVzIHdpdGgg
YW4gb3ZlcmxvbmcgbXR1Lg0KQnV0IHRoYXQgY2FuIGJlIGRvbmUgYWZ0ZXIgYWxsIHRoZSBoZWFk
ZXJzIGhhdmUgYmVlbiByZW1vdmVkLg0KDQouLi4NCj4gQnV0IGFsbCB0aGVzZSBwb3NzaWJsZSBj
aGFuZ2VzIHdpbGwgbmVlZCB0byBnbyB0aHJvdWdoIG5ldC1uZXh0Lg0KDQpJbmRlZWQuDQoNCglE
YXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91
bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5
NzM4NiAoV2FsZXMpDQo=

