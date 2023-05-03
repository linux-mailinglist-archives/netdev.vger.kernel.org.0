Return-Path: <netdev+bounces-161-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C077F6F5913
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 15:27:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63622281598
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 13:27:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33B96D530;
	Wed,  3 May 2023 13:27:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228EA4A11
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 13:27:54 +0000 (UTC)
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04842E67
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 06:27:48 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-272-JMRr_rtRNKmaWdX7u8fSMw-1; Wed, 03 May 2023 14:27:46 +0100
X-MC-Unique: JMRr_rtRNKmaWdX7u8fSMw-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 3 May
 2023 14:27:44 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Wed, 3 May 2023 14:27:44 +0100
From: David Laight <David.Laight@ACULAB.COM>
To: 'Adrien Delorme' <delorme.ade@outlook.com>, Pavel Begunkov
	<asml.silence@gmail.com>
CC: "axboe@kernel.dk" <axboe@kernel.dk>, "davem@davemloft.net"
	<davem@davemloft.net>, "dccp@vger.kernel.org" <dccp@vger.kernel.org>,
	"dsahern@kernel.org" <dsahern@kernel.org>, "edumazet@google.com"
	<edumazet@google.com>, "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"kuba@kernel.org" <kuba@kernel.org>, "leit@fb.com" <leit@fb.com>,
	"leitao@debian.org" <leitao@debian.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "marcelo.leitner@gmail.com"
	<marcelo.leitner@gmail.com>, "matthieu.baerts@tessares.net"
	<matthieu.baerts@tessares.net>, "mptcp@lists.linux.dev"
	<mptcp@lists.linux.dev>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "willemb@google.com"
	<willemb@google.com>, "willemdebruijn.kernel@gmail.com"
	<willemdebruijn.kernel@gmail.com>
Subject: RE: [PATCH 0/5] add initial io_uring_cmd support for sockets
Thread-Topic: [PATCH 0/5] add initial io_uring_cmd support for sockets
Thread-Index: AQHZfPcbeWikE8uGs0CEhT1cqCE61a9Ido9ggAASYTA=
Date: Wed, 3 May 2023 13:27:44 +0000
Message-ID: <9233101ff5794556a0873832ebad4445@AcuMS.aculab.com>
References: <GV1P193MB200533CC9A694C4066F4807CEA6F9@GV1P193MB2005.EURP193.PROD.OUTLOOK.COM>
 <49866ae2-db19-083c-6498-e7d9d62e8267@gmail.com>
 <GV1P193MB2005214F383309B8466C6361EA6C9@GV1P193MB2005.EURP193.PROD.OUTLOOK.COM>
In-Reply-To: <GV1P193MB2005214F383309B8466C6361EA6C9@GV1P193MB2005.EURP193.PROD.OUTLOOK.COM>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

RnJvbTogQWRyaWVuIERlbG9ybWUNCj4gU2VudDogMDMgTWF5IDIwMjMgMTQ6MTENCj4gDQo+IEZy
b20gQWRyaWVuIERlbG9ybWUNCj4gPiBGcm9twqA6IFBhdmVsIEJlZ3Vua292DQo+ID4gU2VudCA6
IDIgTWF5IDIwMjMgMTU6MDQNCj4gPiBPbiA1LzIvMjMgMTA6MjEsIEFkcmllbiBEZWxvcm1lIHdy
b3RlOg0KPiA+ID4gIEZyb20gQWRyaWVuIERlbG9ybWUNCj4gPiA+DQo+ID4gPj4gRnJvbTogRGF2
aWQgQWhlcm4NCj4gPiA+PiBTZW50OiAxMiBBcHJpbCAyMDIzIDc6MzkNCj4gPiA+Pj4gU2VudDog
MTEgQXByaWwgMjAyMyAxNjoyOA0KPiA+ID4+IC4uLi4NCj4gPiA+PiBPbmUgcHJvYmxlbSBpcyB0
aGF0IG5vdCBhbGwgc29ja29wdCBjYWxscyBwYXNzIHRoZSBjb3JyZWN0IGxlbmd0aC4NCj4gPiA+
PiBBbmQgc29tZSBvZiB0aGVtIGNhbiBoYXZlIHZlcnkgbG9uZyBidWZmZXJzLg0KPiA+ID4+IE5v
dCB0byBtZW50aW9uIHRoZSBvbmVzIHRoYXQgYXJlIHJlYWQtbW9kaWZ5LXdyaXRlLg0KPiA+ID4+
DQo+ID4gPj4gQSBwbGF1c2libGUgc29sdXRpb24gaXMgdG8gcGFzcyBhICdmYXQgcG9pbnRlcicg
dGhhdCBjb250YWlucyBzb21lLA0KPiA+ID4+IG9yIGFsbCwgb2Y6DQo+ID4gPj4gICAgICAgIC0g
QSB1c2Vyc3BhY2UgYnVmZmVyIHBvaW50ZXIuDQo+ID4gPj4gICAgICAgIC0gQSBrZXJuZWwgYnVm
ZmVyIHBvaW50ZXIuDQo+ID4gPj4gICAgICAgIC0gVGhlIGxlbmd0aCBzdXBwbGllZCBieSB0aGUg
dXNlci4NCj4gPiA+PiAgICAgICAgLSBUaGUgbGVuZ3RoIG9mIHRoZSBrZXJuZWwgYnVmZmVyLg0K
PiA+ID4+ICAgICAgICA9IFRoZSBudW1iZXIgb2YgYnl0ZXMgdG8gY29weSBvbiBjb21wbGV0aW9u
Lg0KPiA+ID4+IEZvciBzaW1wbGUgdXNlciByZXF1ZXN0cyB0aGUgc3lzY2FsbCBlbnRyeS9leGl0
IGNvZGUgd291bGQgY29weSB0aGUNCj4gPiA+PiBkYXRhIHRvIGEgc2hvcnQgb24tc3RhY2sgYnVm
ZmVyLg0KPiA+ID4+IEtlcm5lbCB1c2VycyBqdXN0IHBhc3MgdGhlIGtlcm5lbCBhZGRyZXNzLg0K
PiA+ID4+IE9kZCByZXF1ZXN0cyBjYW4ganVzdCB1c2UgdGhlIHVzZXIgcG9pbnRlci4NCj4gPiA+
Pg0KPiA+ID4+IFByb2JhYmx5IG5lZWRzIGFjY2Vzc29ycyB0aGF0IGFkZCBpbiBhbiBvZmZzZXQu
DQo+ID4gPj4NCj4gPiA+PiBJdCBtaWdodCBhbHNvIGJlIHRoYXQgc29tZSBvZiB0aGUgcHJvYmxl
bWF0aWMgc29ja29wdCB3ZXJlIGluIGRlY25ldA0KPiA+ID4+IC0gbm93IHJlbW92ZWQuDQo+ID4g
Pg0KPiA+ID4gSGVsbG8gZXZlcnlvbmUsDQo+ID4gPg0KPiA+ID4gSSdtIGN1cnJlbnRseSB3b3Jr
aW5nIG9uIGFuIGltcGxlbWVudGF0aW9uIG9mIHtnZXQsc2V0fSBzb2Nrb3B0Lg0KPiA+ID4gU2lu
Y2UgdGhpcyB0aHJlYWQgaXMgYWxyZWFkeSB0YWxraW5nIGFib3V0IGl0LCBJIGhvcGUgdGhhdCBJ
IHJlcGx5aW5nIGF0IHRoZQ0KPiA+IGNvcnJlY3QgcGxhY2UuDQo+ID4NCj4gPiBIaSBBZHJpZW4s
IEkgYmVsaWV2ZSBCcmVubyBpcyB3b3JraW5nIG9uIHNldC9nZXRzb2Nrb3B0IGFzIHdlbGwgYW5k
IGhhZA0KPiA+IHNpbWlsYXIgcGF0Y2hlcyBmb3IgYXdoaWxlLCBidXQgdGhhdCB3b3VsZCBuZWVk
IGZvciBzb21lIHByb2JsZW1zIHRvIGJlDQo+ID4gc29sdmVkIGZpcnN0LCBlLmcuIHRyeSBhbmQg
ZGVjaWRlIHdoZXRoZXIgaXQgY29waWVzIHRvIGEgcHRyIGFzIHRoZSBzeXNjYWxsDQo+ID4gdmVy
c2lvbnMgb3Igd291bGQgZ2V0L3JldHVybiBvcHR2YWwgZGlyZWN0bHkgaW4gc3FlL2NxZS4gQW5k
IGFsc28gd2hlcmUgdG8NCj4gPiBzdG9yZSBiaXRzIHRoYXQgeW91IHBhc3MgaW4gc3RydWN0IGFy
Z3Nfc2V0c29ja29wdF91cmluZywgYW5kIHdoZXRoZXIgdG8gcmVseQ0KPiA+IG9uIFNRRTEyOCBv
ciBub3QuDQo+ID4NCj4gDQo+IEhlbGxvIFBhdmVsLA0KPiBUaGF0IGlzIGdvb2QgdG8gaGVhci4g
SWYgcG9zc2libGUgSSB3b3VsZCBsaWtlIHRvIHByb3ZpZGUgc29tZSBoZWxwLg0KPiBJIGxvb2tl
ZCBhdCB0aGUgZ2V0c29ja29wdCBpbXBsZW1lbnRhdGlvbi4gRnJvbSB3aGF0IEknbSBzZWVpbmcs
IEkgYmVsaWV2ZSB0aGF0IGl0IHdvdWxkIGJlIGVhc2llciB0bw0KPiBjb3BpZXMgdG8gYSBwdHIg
YXMgdGhlIHN5c2NhbGwuDQo+IFRoZSBsZW5ndGggb2YgdGhlIG91dHB1dCBpcyB1c3VhbGx5IDQg
Ynl0ZXMgKHNvbWV0aW1lcyBsZXNzKSBidXQgaW4gYSBsb3Qgb2YgY2FzZXMsIHRoaXMgbGVuZ3Ro
IGlzDQo+IHZhcmlhYmxlLiBTb21ldGltZSBpdCBjYW4gZXZlbiBiZSBiaWdnZXIgdGhhdCB0aGUg
U1FFMTI4IHJpbmcuDQo+IA0KPiBIZXJlIGlzIGEgbm9uLWV4aGF1c3RpdmUgbGlzdCBvZiB0aG9z
ZSBjYXNlcyA6DQo+IC9uZXQvaXB2NC90Y3AuYyA6IGludCBkb190Y3BfZ2V0c29ja29wdCguLi4p
DQo+ICAgLSBUQ1BfSU5GTyA6IHVwIHRvIDI0MCBieXRlcw0KPiAgIC0gVENQX0NDX0lORk8gYW5k
IFRDUF9SRVBBSVJfV0lORE9XIDogdXAgdG8gMjAgYnl0ZXMNCj4gICAtIFRDUF9DT05HRVNUSU9O
IGFuZCBUQ1BfVUxQIDogdXAgdG8gMTYgYnl0ZXMNCj4gICAtIFRDUF9aRVJPQ1BPWV9SRUNFSVZF
IDogdXAgdG8gNjQgYnl0ZXMNCj4gL25ldC9hdG0vY29tbXVuLmMgOiBpbnQgdmNjX2dldHNvY2tv
cHQoLi4uKQ0KPiAgIC0gU09fQVRNUU9TIDogdXAgdG8gODggYnl0ZXMNCj4gICAtIFNPX0FUTVBW
QyA6IHVwIHRvIDE2IGJ5dGVzDQo+IC9uZXQvaXB2NC9pb19zb2NrZ2x1ZS5jIDogaW50IGRvX2lw
X2dldHNvY2tvcHQoLi4uKQ0KPiAgIC0gTUNBU1RfTVNGSUxURVIgOiB1cCB0byAxNDQgYnl0ZXMN
Cj4gICAtIElQX01TRklMVEVSIDogMTYgYnl0ZXMgbWluaW11bQ0KPiANCj4gSSB3aWxsIGxvb2sg
aW50byBzZXRzb2Nrb3B0IGJ1dCBJIGJlbGlldmUgaXQgbWlnaHQgYmUgdGhlIHNhbWUuDQo+IElm
IG5lZWRlZCBJIGNhbiBhbHNvIGNvbXBsZXRlIHRoaXMgbGlzdC4NCj4gSG93ZXZlciB0aGVyZSBh
cmUgc29tZSBjYXNlcyB3aGVyZSBpdCBpcyBoYXJkIHRvIGRldGVybWluYXRlIGEgbWF4aW11bSBh
bW91bnQgb2YgYnl0ZXMgaW4gYWR2YW5jZS4NCg0KQWxzbyBsb29rIGF0IFNDVFAgLSBpdCBoYXMg
c29tZSB2ZXJ5IGxvbmcgYnVmZmVycy4NCkFsbW9zdCBhbnkgY29kZSB0aGF0IHVzZXMgU0NUUCBu
ZWVkcyB0byB1c2UgdGhlIFNDVFBfU1RBVFVTDQpyZXF1ZXN0IHRvIGdldCB0aGUgbmVnb3RpYXRl
ZCBudW1iZXIgb2YgZGF0YSBzdHJlYW1zDQoodGhhdCBvbmUgaXMgcmVsYXRpdmVseSBzaG9ydCku
DQpJSVJDIHRoZXJlIGFyZSBhbHNvIGdldHNvY2tvcHQoKSB0aGF0IGFyZSByZWFkL21vZGlmeS93
cml0ZSENCg0KVGhlcmUgd2lsbCBhbHNvIGJlIHVzZXIgY29kZSB0aGF0IHN1cHBsaWVzIGEgdmVy
eSBsb25nIGJ1ZmZlcg0KKHRvbyBsb25nIHRvIGFsbG9jYXRlIGluIGtlcm5lbCkgZm9yIHNvbWUg
dmFyaWFibGUgbGVuZ3RoIHJlcXVlc3RzLg0KDQpTbyB0aGUgZ2VuZXJpYyBzeXN0ZW0gY2FsbCBj
b2RlIGNhbiBhbGxvY2F0ZSBhIHNob3J0IChlZyBvbi1zdGFjaykNCmJ1ZmZlciBmb3Igc2hvcnQg
cmVxdWVzdHMgYW5kIHRoZW4gcGFzcyBib3RoIHRoZSB1c2VyIGFuZCBrZXJuZWwNCmFkZHJlc3Nl
cyAoYW5kIGxlbmd0aHMpIHRocm91Z2ggdG8gdGhlIHByb3RvY29sIGZ1bmN0aW9ucy4NCkFueXRo
aW5nIHRoYXQgbmVlZHMgYSBiaWcgYnVmZmVyIGNhbiBkaXJlY3RseSBjb3B5IHRvL2Zyb20NCmFu
ZCB1c2VyIGJ1ZmZlcnMsIGtlcm5lbCBjYWxsZXJzIHdvdWxkIG5lZWQgdG8gcGFzcyBhIGJpZyBl
bm91Z2gNCmJ1ZmZlci4NCg0KQnV0IHRoZSBjb2RlIGZvciBzbWFsbCBidWZmZXJzIHdvdWxkIGJl
IG11Y2ggc2ltcGxpZmllZCBmb3INCmJvdGgga2VybmVsIGFuZCB1c2VyIGFjY2Vzcy4NCg0KCURh
dmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3Vu
dCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3
Mzg2IChXYWxlcykNCg==


