Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41B065ACF3E
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 11:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237229AbiIEJyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 05:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237257AbiIEJym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 05:54:42 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911C6658F
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 02:54:39 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-401-VgGwiLkVPyyGbA9Btd8BWw-1; Mon, 05 Sep 2022 10:54:37 +0100
X-MC-Unique: VgGwiLkVPyyGbA9Btd8BWw-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Mon, 5 Sep
 2022 10:54:34 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.040; Mon, 5 Sep 2022 10:54:34 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Eric Dumazet <edumazet@google.com>,
        "'adobriyan@gmail.com'" <adobriyan@gmail.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: RE: setns() affecting other threads in 5.10.132 and 6.0
Thread-Topic: setns() affecting other threads in 5.10.132 and 6.0
Thread-Index: AdjAZGr2bm2+BO9aR228APTLkn1hUgApqGgQ
Date:   Mon, 5 Sep 2022 09:54:34 +0000
Message-ID: <fcf51181f86e417285a101059d559382@AcuMS.aculab.com>
References: <d9f7a7d26eb5489e93742e57e55ebc02@AcuMS.aculab.com>
In-Reply-To: <d9f7a7d26eb5489e93742e57e55ebc02@AcuMS.aculab.com>
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

NzA1NTE5NzcwNTcwOWM1OWI4YWI3N2U2YTVjN2Q0NmQ2MWVkZDk2ZQ0KQXV0aG9yOiBBbGV4ZXkg
RG9icml5YW4gPGFkb2JyaXlhbkBnbWFpbC5jb20+DQogICAgQ2M6IEFsIFZpcm8gPHZpcm9AemVu
aXYubGludXgub3JnLnVrPg0KICAgIFNpZ25lZC1vZmYtYnk6IEFuZHJldyBNb3J0b24gPGFrcG1A
bGludXgtZm91bmRhdGlvbi5vcmc+DQpjNmM3NWRlZGE4MTMNCjFmZGU2ZjIxZDkwZg0KDQo+IC0t
LS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IERhdmlkIExhaWdodCA8RGF2aWQuTGFp
Z2h0QEFDVUxBQi5DT00+DQo+IFNlbnQ6IDA0IFNlcHRlbWJlciAyMDIyIDE1OjA1DQo+IA0KPiBT
b21ldGltZSBhZnRlciA1LjEwLjEwNSAoNS4xMC4xMzIgYW5kIDYuMCkgdGhlcmUgaXMgYSBjaGFu
Z2UgdGhhdA0KPiBtYWtlcyBzZXRucyhvcGVuKCIvcHJvYy8xL25zL25ldCIpKSBpbiB0aGUgbWFp
biBwcm9jZXNzIGNoYW5nZQ0KPiB0aGUgYmVoYXZpb3VyIG9mIG90aGVyIHByb2Nlc3MgdGhyZWFk
cy4NCj4gDQo+IEkgZG9uJ3Qga25vdyBob3cgbXVjaCBpcyBicm9rZW4sIGJ1dCB0aGUgZm9sbG93
aW5nIGZhaWxzLg0KPiANCj4gQ3JlYXRlIGEgbmV0d29yayBuYW1lc3BhY2UgKGVnICJ0ZXN0Iiku
DQo+IENyZWF0ZSBhICdib25kJyBpbnRlcmZhY2UgKGVnICJ0ZXN0MCIpIGluIHRoZSBuYW1lc3Bh
Y2UuDQo+IA0KPiBUaGVuIC9wcm9jL25ldC9ib25kaW5nL3Rlc3QwIG9ubHkgZXhpc3RzIGluc2lk
ZSB0aGUgbmFtZXNwYWNlLg0KPiANCj4gSG93ZXZlciBpZiB5b3UgcnVuIGEgcHJvZ3JhbSBpbiB0
aGUgInRlc3QiIG5hbWVzcGFjZSB0aGF0IGRvZXM6DQo+IC0gY3JlYXRlIGEgdGhyZWFkLg0KPiAt
IGNoYW5nZSB0aGUgbWFpbiB0aHJlYWQgdG8gaW4gImluaXQiIG5hbWVzcGFjZS4NCj4gLSB0cnkg
dG8gb3BlbiAvcHJvYy9uZXQvYm9uZGluZy90ZXN0MCBpbiB0aGUgdGhyZWFkLg0KPiB0aGVuIHRo
ZSBvcGVuIGZhaWxzLg0KPiANCj4gSSBkb24ndCBrbm93IGhvdyBtdWNoIGVsc2UgaXMgYWZmZWN0
ZWQgYW5kIGhhdmVuJ3QgdHJpZWQNCj4gdG8gYmlzZWN0IChJIGNhbid0IGNyZWF0ZSBib25kcyBv
biBteSBub3JtYWwgdGVzdCBrZXJuZWwpLg0KDQpJJ3ZlIG5vdyBiaXNlY3RlZCBpdC4NClByaW9y
IHRvIGNoYW5nZSA3MDU1MTk3NzA1NzA5YzU5YjhhYjc3ZTZhNWM3ZDQ2ZDYxZWRkOTZlDQogICAg
cHJvYzogZml4IGRlbnRyeS9pbm9kZSBvdmVyaW5zdGFudGlhdGluZyB1bmRlciAvcHJvYy8ke3Bp
ZH0vbmV0DQp0aGUgc2V0bnMoKSBoYWQgbm8gZWZmZWN0IG9mIGVpdGhlciB0aHJlYWQuDQpBZnRl
cndhcmRzIGJvdGggdGhyZWFkcyBzZWUgdGhlIGVudHJpZXMgaW4gdGhlIGluaXQgbmFtZXNwYWNl
Lg0KDQpIb3dldmVyIEkgdGhpbmsgdGhhdCBpbiA1LjEwLjEwNSB0aGUgc2V0bnMoKSBkaWQgYWZm
ZWN0DQp0aGUgdGhyZWFkIGl0IHdhcyBydW4gaW4uDQpUaGF0IG1pZ2h0IGJlIHRoZSBiZWhhdmlv
dXIgYmVmb3JlIGM2Yzc1ZGVkYTgxMy4NCiAgICBwcm9jOiBmaXggbG9va3VwIGluIC9wcm9jL25l
dCBzdWJkaXJlY3RvcmllcyBhZnRlciBzZXRucygyKQ0KDQpUaGVyZSBpcyBhbHNvIHRoZSBlYXJs
aWVyIDFmZGU2ZjIxZDkwZg0KICAgIHByb2M6IGZpeCAvcHJvYy9uZXQvKiBhZnRlciBzZXRucygy
KQ0KDQpGcm9tIHRoZSBjb21taXQgbWVzc2FnZXMgaXQgZG9lcyBsb29rIGFzIHRob3VnaCBzZXRu
cygpIHNob3VsZA0KY2hhbmdlIHdoYXQgaXMgc2VlbiwgYnV0IGp1c3QgZm9yIHRoZSBjdXJyZW50
IHRocmVhZC4NClNvIGl0IGlzIGN1cnJlbnRseSBicm9rZW4gLSBhbmQgaGFzIGJlZW4gc2luY2Ug
NS4xOC4wLXJjNA0KYW5kIHdoaWNoZXZlciBzdGFibGUgYnJhbmNoZXMgdGhlIGNoYW5nZSB3YXMg
YmFja3BvcnRlZCB0by4NCg0KCURhdmlkDQoNCj4gDQo+IFRoZSB0ZXN0IHByb2dyYW0gYmVsb3cg
c2hvd3MgdGhlIHByb2JsZW0uDQo+IENvbXBpbGUgYW5kIHJ1biBhczoNCj4gIyBpcCBuZXRucyBl
eGVjIHRlc3Qgc3RyYWNlIC1mIHRlc3RfcHJvZyAvcHJvYy9uZXQvYm9uZGluZy90ZXN0MA0KPiAN
Cj4gVGhlIHNlY29uZCBvcGVuIGJ5IHRoZSBjaGlsZCBzaG91bGQgc3VjY2VlZCwgYnV0IGZhaWxz
Lg0KPiANCj4gSSBjYW4ndCBzZWUgYW55IGNoYW5nZXMgdG8gdGhlIGJvbmRpbmcgY29kZSwgc28g
SSBzdXNwZWN0DQo+IGl0IGlzIHNvbWV0aGluZyBtdWNoIG1vcmUgZnVuZGFtZW50YWwuDQo+IEl0
IG1pZ2h0IG9ubHkgYWZmZWN0IC9wcm9jL25ldCwgYnV0IGl0IG1pZ2h0IGFsc28gYWZmZWN0DQo+
IHdoaWNoIG5hbWVzcGFjZSBzb2NrZXRzIGdldCBjcmVhdGVkIGluLg0KPiBJSVJDIGxzIC1sIC9w
cm9jL24vdGFzay8qL25zIGdpdmVzIHRoZSBjb3JyZWN0IG5hbWVzcGFjZXMuDQo+IA0KPiAJRGF2
aWQNCj4gDQo+IA0KPiAjZGVmaW5lIF9HTlVfU09VUkNFDQo+IA0KPiAjaW5jbHVkZSA8ZmNudGwu
aD4NCj4gI2luY2x1ZGUgPHVuaXN0ZC5oPg0KPiAjaW5jbHVkZSA8cG9sbC5oPg0KPiAjaW5jbHVk
ZSA8cHRocmVhZC5oPg0KPiAjaW5jbHVkZSA8c2NoZWQuaD4NCj4gDQo+ICNkZWZpbmUgZGVsYXko
c2VjcykgcG9sbCgwLDAsIChzZWNzKSAqIDEwMDApDQo+IA0KPiBzdGF0aWMgdm9pZCAqdGhyZWFk
X2ZuKHZvaWQgKmZpbGUpDQo+IHsNCj4gICAgICAgICBkZWxheSgyKTsNCj4gICAgICAgICBvcGVu
KGZpbGUsIE9fUkRPTkxZKTsNCj4gDQo+ICAgICAgICAgZGVsYXkoNSk7DQo+ICAgICAgICAgb3Bl
bihmaWxlLCBPX1JET05MWSk7DQo+IA0KPiAgICAgICAgIHJldHVybiBOVUxMOw0KPiB9DQo+IA0K
PiBpbnQgbWFpbihpbnQgYXJnYywgY2hhciAqKmFyZ3YpDQo+IHsNCj4gICAgICAgICBwdGhyZWFk
X3QgaWQ7DQo+IA0KPiAgICAgICAgIHB0aHJlYWRfY3JlYXRlKCZpZCwgTlVMTCwgdGhyZWFkX2Zu
LCBhcmd2WzFdKTsNCj4gDQo+ICAgICAgICAgZGVsYXkoMSk7DQo+ICAgICAgICAgb3Blbihhcmd2
WzFdLCBPX1JET05MWSk7DQo+IA0KPiAgICAgICAgIGRlbGF5KDIpOw0KPiAgICAgICAgIHNldG5z
KG9wZW4oIi9wcm9jLzEvbnMvbmV0IiwgT19SRE9OTFkpLCAwKTsNCj4gDQo+ICAgICAgICAgZGVs
YXkoMSk7DQo+ICAgICAgICAgb3Blbihhcmd2WzFdLCBPX1JET05MWSk7DQo+IA0KPiAgICAgICAg
IGRlbGF5KDQpOw0KPiANCj4gICAgICAgICByZXR1cm4gMDsNCj4gfQ0KPiANCj4gLQ0KPiBSZWdp
c3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9u
IEtleW5lcywgTUsxIDFQVCwgVUsNCj4gUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykN
Cg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZh
cm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYg
KFdhbGVzKQ0K

