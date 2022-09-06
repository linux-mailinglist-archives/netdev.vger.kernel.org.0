Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 950415AE26B
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 10:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234099AbiIFI0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 04:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234080AbiIFI0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 04:26:08 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6624F43315
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 01:26:03 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-322-4VmOFDB4OwqP28iks9tnLA-1; Tue, 06 Sep 2022 09:26:01 +0100
X-MC-Unique: 4VmOFDB4OwqP28iks9tnLA-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Tue, 6 Sep
 2022 09:25:59 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.040; Tue, 6 Sep 2022 09:25:59 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Alexey Dobriyan' <adobriyan@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: RE: setns() affecting other threads in 5.10.132 and 6.0
Thread-Topic: setns() affecting other threads in 5.10.132 and 6.0
Thread-Index: AdjAZGr2bm2+BO9aR228APTLkn1hUgApqGgQAA6DpAAAIG7lAA==
Date:   Tue, 6 Sep 2022 08:25:59 +0000
Message-ID: <958649bb1d76442d8aa76067e0a3e0b6@AcuMS.aculab.com>
References: <d9f7a7d26eb5489e93742e57e55ebc02@AcuMS.aculab.com>
 <fcf51181f86e417285a101059d559382@AcuMS.aculab.com>
 <YxYytPTFwYr7vBTo@localhost.localdomain>
In-Reply-To: <YxYytPTFwYr7vBTo@localhost.localdomain>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQWxleGV5IERvYnJpeWFuDQo+IFNlbnQ6IDA1IFNlcHRlbWJlciAyMDIyIDE4OjMzDQo+
IA0KPiBPbiBNb24sIFNlcCAwNSwgMjAyMiBhdCAwOTo1NDozNEFNICswMDAwLCBEYXZpZCBMYWln
aHQgd3JvdGU6DQo+ID4gNzA1NTE5NzcwNTcwOWM1OWI4YWI3N2U2YTVjN2Q0NmQ2MWVkZDk2ZQ0K
PiA+IEF1dGhvcjogQWxleGV5IERvYnJpeWFuIDxhZG9icml5YW5AZ21haWwuY29tPg0KPiA+ICAg
ICBDYzogQWwgVmlybyA8dmlyb0B6ZW5pdi5saW51eC5vcmcudWs+DQo+ID4gICAgIFNpZ25lZC1v
ZmYtYnk6IEFuZHJldyBNb3J0b24gPGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmc+DQo+ID4gYzZj
NzVkZWRhODEzDQo+ID4gMWZkZTZmMjFkOTBmDQo+ID4NCj4gPiA+IC0tLS0tT3JpZ2luYWwgTWVz
c2FnZS0tLS0tDQo+ID4gPiBGcm9tOiBEYXZpZCBMYWlnaHQgPERhdmlkLkxhaWdodEBBQ1VMQUIu
Q09NPg0KPiA+ID4gU2VudDogMDQgU2VwdGVtYmVyIDIwMjIgMTU6MDUNCj4gPiA+DQo+ID4gPiBT
b21ldGltZSBhZnRlciA1LjEwLjEwNSAoNS4xMC4xMzIgYW5kIDYuMCkgdGhlcmUgaXMgYSBjaGFu
Z2UgdGhhdA0KPiA+ID4gbWFrZXMgc2V0bnMob3BlbigiL3Byb2MvMS9ucy9uZXQiKSkgaW4gdGhl
IG1haW4gcHJvY2VzcyBjaGFuZ2UNCj4gPiA+IHRoZSBiZWhhdmlvdXIgb2Ygb3RoZXIgcHJvY2Vz
cyB0aHJlYWRzLg0KPiANCj4gTm90IGFnYWluLi4uDQoNClRoZSBiaXNlY3Rpb24gZ2F2ZSBhIHdo
YWNrLWEtbW9sZSBwYXRjaCA6LSkNCg0KPiA+ID4gSSBkb24ndCBrbm93IGhvdyBtdWNoIGlzIGJy
b2tlbiwgYnV0IHRoZSBmb2xsb3dpbmcgZmFpbHMuDQo+ID4gPg0KPiA+ID4gQ3JlYXRlIGEgbmV0
d29yayBuYW1lc3BhY2UgKGVnICJ0ZXN0IikuDQo+ID4gPiBDcmVhdGUgYSAnYm9uZCcgaW50ZXJm
YWNlIChlZyAidGVzdDAiKSBpbiB0aGUgbmFtZXNwYWNlLg0KPiA+ID4NCj4gPiA+IFRoZW4gL3By
b2MvbmV0L2JvbmRpbmcvdGVzdDAgb25seSBleGlzdHMgaW5zaWRlIHRoZSBuYW1lc3BhY2UuDQo+
ID4gPg0KPiA+ID4gSG93ZXZlciBpZiB5b3UgcnVuIGEgcHJvZ3JhbSBpbiB0aGUgInRlc3QiIG5h
bWVzcGFjZSB0aGF0IGRvZXM6DQo+ID4gPiAtIGNyZWF0ZSBhIHRocmVhZC4NCj4gPiA+IC0gY2hh
bmdlIHRoZSBtYWluIHRocmVhZCB0byBpbiAiaW5pdCIgbmFtZXNwYWNlLg0KPiA+ID4gLSB0cnkg
dG8gb3BlbiAvcHJvYy9uZXQvYm9uZGluZy90ZXN0MCBpbiB0aGUgdGhyZWFkLg0KPiA+ID4gdGhl
biB0aGUgb3BlbiBmYWlscy4NCj4gPiA+DQo+ID4gPiBJIGRvbid0IGtub3cgaG93IG11Y2ggZWxz
ZSBpcyBhZmZlY3RlZCBhbmQgaGF2ZW4ndCB0cmllZA0KPiA+ID4gdG8gYmlzZWN0IChJIGNhbid0
IGNyZWF0ZSBib25kcyBvbiBteSBub3JtYWwgdGVzdCBrZXJuZWwpLg0KPiA+DQo+ID4gSSd2ZSBu
b3cgYmlzZWN0ZWQgaXQuDQo+ID4gUHJpb3IgdG8gY2hhbmdlIDcwNTUxOTc3MDU3MDljNTliOGFi
NzdlNmE1YzdkNDZkNjFlZGQ5NmUNCj4gPiAgICAgcHJvYzogZml4IGRlbnRyeS9pbm9kZSBvdmVy
aW5zdGFudGlhdGluZyB1bmRlciAvcHJvYy8ke3BpZH0vbmV0DQo+ID4gdGhlIHNldG5zKCkgaGFk
IG5vIGVmZmVjdCBvZiBlaXRoZXIgdGhyZWFkLg0KPiA+IEFmdGVyd2FyZHMgYm90aCB0aHJlYWRz
IHNlZSB0aGUgZW50cmllcyBpbiB0aGUgaW5pdCBuYW1lc3BhY2UuDQo+ID4NCj4gPiBIb3dldmVy
IEkgdGhpbmsgdGhhdCBpbiA1LjEwLjEwNSB0aGUgc2V0bnMoKSBkaWQgYWZmZWN0DQo+ID4gdGhl
IHRocmVhZCBpdCB3YXMgcnVuIGluLg0KPiA+IFRoYXQgbWlnaHQgYmUgdGhlIGJlaGF2aW91ciBi
ZWZvcmUgYzZjNzVkZWRhODEzLg0KPiA+ICAgICBwcm9jOiBmaXggbG9va3VwIGluIC9wcm9jL25l
dCBzdWJkaXJlY3RvcmllcyBhZnRlciBzZXRucygyKQ0KPiA+DQo+ID4gVGhlcmUgaXMgYWxzbyB0
aGUgZWFybGllciAxZmRlNmYyMWQ5MGYNCj4gPiAgICAgcHJvYzogZml4IC9wcm9jL25ldC8qIGFm
dGVyIHNldG5zKDIpDQo+ID4NCj4gPiBGcm9tIHRoZSBjb21taXQgbWVzc2FnZXMgaXQgZG9lcyBs
b29rIGFzIHRob3VnaCBzZXRucygpIHNob3VsZA0KPiA+IGNoYW5nZSB3aGF0IGlzIHNlZW4sIGJ1
dCBqdXN0IGZvciB0aGUgY3VycmVudCB0aHJlYWQuDQo+ID4gU28gaXQgaXMgY3VycmVudGx5IGJy
b2tlbiAtIGFuZCBoYXMgYmVlbiBzaW5jZSA1LjE4LjAtcmM0DQo+ID4gYW5kIHdoaWNoZXZlciBz
dGFibGUgYnJhbmNoZXMgdGhlIGNoYW5nZSB3YXMgYmFja3BvcnRlZCB0by4NCj4gPg0KPiA+IAlE
YXZpZA0KPiA+DQo+ID4gPg0KPiA+ID4gVGhlIHRlc3QgcHJvZ3JhbSBiZWxvdyBzaG93cyB0aGUg
cHJvYmxlbS4NCj4gPiA+IENvbXBpbGUgYW5kIHJ1biBhczoNCj4gPiA+ICMgaXAgbmV0bnMgZXhl
YyB0ZXN0IHN0cmFjZSAtZiB0ZXN0X3Byb2cgL3Byb2MvbmV0L2JvbmRpbmcvdGVzdDANCj4gPiA+
DQo+ID4gPiBUaGUgc2Vjb25kIG9wZW4gYnkgdGhlIGNoaWxkIHNob3VsZCBzdWNjZWVkLCBidXQg
ZmFpbHMuDQo+ID4gPg0KPiA+ID4gSSBjYW4ndCBzZWUgYW55IGNoYW5nZXMgdG8gdGhlIGJvbmRp
bmcgY29kZSwgc28gSSBzdXNwZWN0DQo+ID4gPiBpdCBpcyBzb21ldGhpbmcgbXVjaCBtb3JlIGZ1
bmRhbWVudGFsLg0KPiA+ID4gSXQgbWlnaHQgb25seSBhZmZlY3QgL3Byb2MvbmV0LCBidXQgaXQg
bWlnaHQgYWxzbyBhZmZlY3QNCj4gPiA+IHdoaWNoIG5hbWVzcGFjZSBzb2NrZXRzIGdldCBjcmVh
dGVkIGluLg0KPiANCj4gSG93PyBzZXRucygyKSBhY3RzIG9uICJjdXJyZW50IiwgYW5kIHNvY2tl
dHMgYXJlIGNyZWF0ZWQgZnJvbQ0KPiBjdXJyZW50LT5uc3Byb3h5LT5uZXRfbnM/DQoNCkkgd2Fz
IHdvcnJpZWQgdGhhdCB0aGluZ3MgbWlnaHQgYmUgcmVhbGx5IGJhZGx5IGJyb2tlbi4NClRoZSBi
aXNlY3Rpb24gaW1wbGllZCAvcHJvYy9uZXQgcmF0aGVyIHRoYW4gbmFtZXNwYWNlIHNldHVwIGl0
c2VsZi4NCg0KPiA+ID4gSUlSQyBscyAtbCAvcHJvYy9uL3Rhc2svKi9ucyBnaXZlcyB0aGUgY29y
cmVjdCBuYW1lc3BhY2VzLg0KPiANCj4gPiA+DQo+ID4gPiAJRGF2aWQNCj4gPiA+DQo+ID4gPg0K
PiA+ID4gI2RlZmluZSBfR05VX1NPVVJDRQ0KPiA+ID4NCj4gPiA+ICNpbmNsdWRlIDxmY250bC5o
Pg0KPiA+ID4gI2luY2x1ZGUgPHVuaXN0ZC5oPg0KPiA+ID4gI2luY2x1ZGUgPHBvbGwuaD4NCj4g
PiA+ICNpbmNsdWRlIDxwdGhyZWFkLmg+DQo+ID4gPiAjaW5jbHVkZSA8c2NoZWQuaD4NCj4gPiA+
DQo+ID4gPiAjZGVmaW5lIGRlbGF5KHNlY3MpIHBvbGwoMCwwLCAoc2VjcykgKiAxMDAwKQ0KPiA+
ID4NCj4gPiA+IHN0YXRpYyB2b2lkICp0aHJlYWRfZm4odm9pZCAqZmlsZSkNCj4gPiA+IHsNCj4g
PiA+ICAgICAgICAgZGVsYXkoMik7DQo+ID4gPiAgICAgICAgIG9wZW4oZmlsZSwgT19SRE9OTFkp
Ow0KPiA+ID4NCj4gPiA+ICAgICAgICAgZGVsYXkoNSk7DQo+ID4gPiAgICAgICAgIG9wZW4oZmls
ZSwgT19SRE9OTFkpOw0KPiA+ID4NCj4gPiA+ICAgICAgICAgcmV0dXJuIE5VTEw7DQo+ID4gPiB9
DQo+ID4gPg0KPiA+ID4gaW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKiphcmd2KQ0KPiA+ID4gew0K
PiA+ID4gICAgICAgICBwdGhyZWFkX3QgaWQ7DQo+ID4gPg0KPiA+ID4gICAgICAgICBwdGhyZWFk
X2NyZWF0ZSgmaWQsIE5VTEwsIHRocmVhZF9mbiwgYXJndlsxXSk7DQo+ID4gPg0KPiA+ID4gICAg
ICAgICBkZWxheSgxKTsNCj4gPiA+ICAgICAgICAgb3Blbihhcmd2WzFdLCBPX1JET05MWSk7DQo+
ID4gPg0KPiA+ID4gICAgICAgICBkZWxheSgyKTsNCj4gPiA+ICAgICAgICAgc2V0bnMob3Blbigi
L3Byb2MvMS9ucy9uZXQiLCBPX1JET05MWSksIDApOw0KPiA+ID4NCj4gPiA+ICAgICAgICAgZGVs
YXkoMSk7DQo+ID4gPiAgICAgICAgIG9wZW4oYXJndlsxXSwgT19SRE9OTFkpOw0KPiA+ID4NCj4g
PiA+ICAgICAgICAgZGVsYXkoNCk7DQo+ID4gPg0KPiA+ID4gICAgICAgICByZXR1cm4gMDsNCj4g
PiA+IH0NCj4gDQo+IENhbiB5b3UgdGVzdCBiZWZvcmUgdGhpcyBvbmU/IFRoaXMgaXMgd2hlcmUg
aXQgYWxsIHN0YXJ0ZWQuDQo+IA0KPiAJY29tbWl0IDFkYTRkMzc3Zjk0M2ZlNDE5NGZmYjlmYjlj
MjZjYzU4ZmFkNGRkMjQNCg0KVGhhdCBvbmUgcmVhbGx5IGRvZXNuJ3Qgd2FudCB0byBidWlsZCB3
aXRoIHRoZSB0b29sY2hhaW4gSSdtIHVzaW5nLg0KZ2NjIGdlbmVyYXRlcyBhIGxvdCBvZiB3YXJu
aW5ncyAobW9zdGx5IGFib3V0IGZ1bmN0aW9uIHBvaW50ZXINCnR5cGVzKSBhbmQgdGhlbiBvYmp0
b29sIGZhaWxzIHRoZSBidWlsZC4NCg0KVGhlIGNoYW5nZXMgc2VlbSB0byBiZSBhYm91dCBmbHVz
aGluZyB0aGUgZG5sYy4NCkluIG15IGNhc2UgZXZlcnl0aGluZyBpcyBwcmV0dHkgc3RhdGljLg0K
VGhlIG5hbWVzcGFjZSBpcyBjcmVhdGVkIG9uY2UganVzdCBhZnRlciBib290Lg0KVGhlIHJlYWwg
ZmFpbGluZyBwcm9ncmFtIGp1c3QgZG9lczoNCglpcCBuZXRucyBleGVjIG5hbWVzcGFjZSBwcm9n
cmFtIDM8L3N5cy9jbGFzcy9uZXQNCglwcm9jZXNzOiBjbG9uZSgpDQoJcHJvY2Vzczogc2V0bnMo
KQ0KCXRocmVhZDogb3BlbigiL3Byb2MvbmV0L2JvbmRpbmcvbm90X2luX25hbWVzcGFjZSIpDQph
bmQgZXhwZWN0cyB0aGUgb3BlbigpIHRvIGZhaWwuDQpTbyBpdCBhY3R1YWxseSBsb29rcyBsaWtl
IHRoZSB3cm9uZyBuYW1lc3BhY2UgaXMgYmVpbmcgdXNlZC4NCg0KSXQgaXMgaW50ZXJlc3Rpbmcg
dGhhdCAvcHJvYy9uZXQgaXMgYWZmZWN0ZWQgYnkgc2V0bnMoKQ0Kd2hlcmVhcyB5b3UgaGF2ZSB0
byBnbyB0aHJvdWdoIGhvb3BzIHRvIGFjY2VzcyAvc3lzL2NsYXNzL25ldC4NCldlIHBhc3MgYW4g
b3BlbiBmZCB0byAvc3lzL2NsYXNzL25ldCBpbiB0aGUgaW5pdCBuYW1lc3BhY2UNCnRocm91Z2gg
dG8gdGhlIHByb2dyYW0gc28gaXQgY2FuIHVzZSBvcGVuYXQoMywgLi4uKSB0bw0Kc2VlIGVudHJp
ZXMgaW4gYm90aCBuYW1lc3BhY2VzLg0KDQpUaGUgbmFtZXNwYWNlIGV4aXN0cyB0byBzZXBhcmF0
ZSBuZXR3b3JrIHRyYWZmaWMsIG5vdCBpc29sYXRlDQphcHBsaWNhdGlvbnMuDQoNCglEYXZpZA0K
DQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFy
bSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAo
V2FsZXMpDQo=

