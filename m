Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 679FA4EBD87
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 11:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244744AbiC3JWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 05:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239931AbiC3JWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 05:22:22 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 63DCE2AE1A
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 02:20:36 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-238-PvzMciuTPwSAX9RYfRl6uw-1; Wed, 30 Mar 2022 10:20:33 +0100
X-MC-Unique: PvzMciuTPwSAX9RYfRl6uw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Wed, 30 Mar 2022 10:20:31 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Wed, 30 Mar 2022 10:20:31 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Guenter Roeck' <linux@roeck-us.net>,
        'Michael Walle' <michael@walle.cc>,
        Xu Yilun <yilun.xu@intel.com>, Tom Rix <trix@redhat.com>,
        Jean Delvare <jdelvare@suse.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     "linux-hwmon@vger.kernel.org" <linux-hwmon@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 1/5] hwmon: introduce hwmon_sanitize_name()
Thread-Topic: [PATCH v2 1/5] hwmon: introduce hwmon_sanitize_name()
Thread-Index: AQHYQ4dUrIB0cQMH/kajVzJ0H3I8wazXOSsggAAAkwCAAGuLAA==
Date:   Wed, 30 Mar 2022 09:20:31 +0000
Message-ID: <cf6f672fbaf645f780ae5eab1a955871@AcuMS.aculab.com>
References: <20220329160730.3265481-1-michael@walle.cc>
 <20220329160730.3265481-2-michael@walle.cc>
 <16d8b45eba7b44e78fa8205e6666f2bd@AcuMS.aculab.com>
 <fa1f64d2-32a1-b8f9-0929-093fbd45d219@roeck-us.net>
In-Reply-To: <fa1f64d2-32a1-b8f9-0929-093fbd45d219@roeck-us.net>
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

RnJvbTogR3VlbnRlciBSb2Vjaw0KPiBTZW50OiAzMCBNYXJjaCAyMDIyIDA0OjQ3DQo+IA0KPiBP
biAzLzI5LzIyIDE5OjU3LCBEYXZpZCBMYWlnaHQgd3JvdGU6DQo+ID4gRnJvbTogTWljaGFlbCBX
YWxsZQ0KPiA+PiBTZW50OiAyOSBNYXJjaCAyMDIyIDE3OjA3DQo+ID4+DQo+ID4+IE1vcmUgYW5k
IG1vcmUgZHJpdmVycyB3aWxsIGNoZWNrIGZvciBiYWQgY2hhcmFjdGVycyBpbiB0aGUgaHdtb24g
bmFtZQ0KPiA+PiBhbmQgYWxsIGFyZSB1c2luZyB0aGUgc2FtZSBjb2RlIHNuaXBwZXQuIENvbnNv
bGlkYXRlIHRoYXQgY29kZSBieSBhZGRpbmcNCj4gPj4gYSBuZXcgaHdtb25fc2FuaXRpemVfbmFt
ZSgpIGZ1bmN0aW9uLg0KPiA+DQo+ID4gSSdtIGFzc3VtaW5nIHRoZXNlICdiYWQnIGh3bW9uIG5h
bWVzIGNvbWUgZnJvbSB1c2Vyc3BhY2U/DQo+ID4gTGlrZSBldGhlcm5ldCBpbnRlcmZhY2UgbmFt
ZXM/Pw0KPiA+DQo+ID4gSXMgc2lsZW50bHkgY2hhbmdpbmcgdGhlIG5hbWUgb2YgdGhlIGh3bW9u
IGVudHJpZXMgdGhlIHJpZ2h0DQo+ID4gdGhpbmcgdG8gZG8gYXQgYWxsPw0KPiA+DQo+ID4gV2hh
dCBoYXBwZW5zIGlmIHRoZSB1c2VyIHRyaWVzIHRvIGNyZWF0ZSBib3RoICJmb29fYmFyIiBhbmQg
ImZvby1iYXIiPw0KPiA+IEknbSBzdXJlIHRoYXQgaXMgZ29pbmcgdG8gZ28gaG9ycmlibHkgd3Jv
bmcgc29tZXdoZXJlLg0KPiA+DQo+ID4gSXQgd291bGQgY2VydGFpbmx5IG1ha2Ugc2Vuc2UgdG8g
aGF2ZSBhIGZ1bmN0aW9uIHRvIHZlcmlmeSB0aGUgbmFtZQ0KPiA+IGlzIGFjdHVhbGx5IHZhbGlk
Lg0KPiA+IFRoZW4gYmFkIG5hbWVzIGNhbiBiZSByZWplY3RlZCBlYXJsaWVyIG9uLg0KPiA+DQo+
ID4gSSdtIGFsc28gaW50cmlndWVkIGFib3V0IHRoZSBsaXN0IG9mIGludmFsaWQgY2hhcmFjdGVy
czoNCj4gPg0KPiA+ICtzdGF0aWMgYm9vbCBod21vbl9pc19iYWRfY2hhcihjb25zdCBjaGFyIGNo
KQ0KPiA+ICt7DQo+ID4gKwlzd2l0Y2ggKGNoKSB7DQo+ID4gKwljYXNlICctJzoNCj4gPiArCWNh
c2UgJyonOg0KPiA+ICsJY2FzZSAnICc6DQo+ID4gKwljYXNlICdcdCc6DQo+ID4gKwljYXNlICdc
bic6DQo+ID4gKwkJcmV0dXJuIHRydWU7DQo+ID4gKwlkZWZhdWx0Og0KPiA+ICsJCXJldHVybiBm
YWxzZTsNCj4gPiArCX0NCj4gPiArfQ0KPiA+DQo+ID4gSWYgJ1x0JyBhbmQgJ1xuJyBhcmUgaW52
YWxpZCB3aHkgYXJlIGFsbCB0aGUgb3RoZXIgY29udHJvbCBjaGFyYWN0ZXJzDQo+ID4gYWxsb3dl
ZD8NCj4gPiBJJ20gZ3Vlc3NpbmcgJyonIGlzIGRpc2FsbG93ZWQgYmVjYXVzZSBpdCBpcyB0aGUg
c2hlbGwgd2lsZGNhcmQ/DQo+ID4gU28gd2hhdCBhYm91dCAnPycuDQo+ID4gVGhlbiBJJ2QgZXhw
ZWN0ICcvJyB0byBiZSBpbnZhbGlkIC0gYnV0IHRoYXQgaXNuJ3QgY2hlY2tlZC4NCj4gPiBOZXZl
ciBtaW5kIGFsbCB0aGUgdmFsdWVzIDB4ODAgdG8gMHhmZiAtIHRoZXkgYXJlIHByb2JhYmx5IHdv
cnNlDQo+ID4gdGhhbiB3aGl0ZXNwYWNlLg0KPiA+DQo+ID4gT1RPSCB3aHkgYXJlIGFueSBjaGFy
YWN0ZXJzIGludmFsaWQgYXQgYWxsIC0gZXhjZXB0ICcvJz8NCj4gPg0KPiANCj4gVGhlIG5hbWUg
aXMgc3VwcG9zZWQgdG8gcmVmbGVjdCBhIGRyaXZlciBuYW1lLiBVc3VhbGx5IGRyaXZlciBuYW1l
cw0KPiBhcmUgbm90IGRlZmluZWQgYnkgdXNlcnNwYWNlIGJ1dCBieSBkcml2ZXIgYXV0aG9ycy4g
VGhlIG5hbWUgaXMgdXNlZA0KPiBieSBsaWJzZW5zb3JzIHRvIGRpc3Rpbmd1aXNoIGEgZHJpdmVy
IGZyb20gaXRzIGluc3RhbnRpYXRpb24uDQo+IGxpYnNlbnNvcnMgdXNlcyB3aWxkY2FyZHMgaW4g
L2V0Yy9zZW5zb3JzMy5jb25mLiBEdXBsaWNhdGUgbmFtZXMNCj4gYXJlIGV4cGVjdGVkOyB0aGVy
ZSBjYW4gYmUgbWFueSBpbnN0YW5jZXMgb2YgdGhlIHNhbWUgZHJpdmVyIGluDQo+IHRoZSBzeXN0
ZW0uIEZvciBleGFtcGxlLCBvbiB0aGUgc3lzdGVtIEkgYW0gdHlwaW5nIHRoaXMgb24sIEkgaGF2
ZToNCj4gDQo+IC9zeXMvY2xhc3MvaHdtb24vaHdtb24wL25hbWU6bnZtZQ0KPiAvc3lzL2NsYXNz
L2h3bW9uL2h3bW9uMS9uYW1lOm52bWUNCj4gL3N5cy9jbGFzcy9od21vbi9od21vbjIvbmFtZTpu
b3V2ZWF1DQo+IC9zeXMvY2xhc3MvaHdtb24vaHdtb24zL25hbWU6bmN0Njc5Nw0KPiAvc3lzL2Ns
YXNzL2h3bW9uL2h3bW9uNC9uYW1lOmpjNDINCj4gL3N5cy9jbGFzcy9od21vbi9od21vbjUvbmFt
ZTpqYzQyDQo+IC9zeXMvY2xhc3MvaHdtb24vaHdtb242L25hbWU6amM0Mg0KPiAvc3lzL2NsYXNz
L2h3bW9uL2h3bW9uNy9uYW1lOmpjNDINCj4gL3N5cy9jbGFzcy9od21vbi9od21vbjgvbmFtZTpr
MTB0ZW1wDQo+IA0KPiBod21vbl9pc19iYWRfY2hhcigpIGZpbHRlcnMgb3V0IGNoYXJhY3RlcnMg
d2hpY2ggaW50ZXJmZXJlIHdpdGgNCj4gbGlic2Vuc29yJ3MgdmlldyBvZiBkcml2ZXIgaW5zdGFu
Y2VzIGFuZCB0aGUgY29uZmlndXJhdGlvbiBkYXRhDQo+IGluIC9ldGMvc2Vuc29yczMuY29uZi4g
Rm9yIGV4YW1wbGUsIGFnYWluIG9uIG15IHN5c3RlbSwgdGhlDQo+ICJzZW5zb3JzIiBjb21tYW5k
IHJlcG9ydHMgdGhlIGZvbGxvd2luZyBqYzQyIGFuZCBudm1lIHNlbnNvcnMuDQo+IA0KPiBqYzQy
LWkyYy0wLTFhDQo+IGpjNDItaTJjLTAtMTgNCj4gamM0Mi1pMmMtMC0xYg0KPiBqYzQyLWkyYy0w
LTE5DQo+IG52bWUtcGNpLTAxMDANCj4gbnZtZS1wY2ktMjUwMA0KPiANCj4gSW4gL2V0Yy9zZW5z
b3JzMy5jb25mLCB0aGVyZSBtaWdodCBiZSBlbnRyaWVzIGZvciAiamM0Mi0qIiBvciAibnZtZS0q
Ii4NCj4gSSBkb24ndCB0aGluayBsaWJzZW5zb3JzIGNhcmVzIGlmIGEgZHJpdmVyIGlzIG5hbWVk
ICJ0aGlzL2lzL215L2RyaXZlciIuDQo+IFRoYXQgZHJpdmVyIHdvdWxkIHRoZW4sIGFzc3VtaW5n
IGl0IGlzIGFuIGkyYyBkcml2ZXIsIHNob3cgdXANCj4gd2l0aCB0aGUgc2Vuc29ycyBjb21tYW5k
IGFzICJ0aGlzL2lzL215L2RyaXZlci1pMmMtMC0yNSIgb3Igc2ltaWxhci4NCj4gSWYgaXQgaXMg
bmFtZWQgInRoaXMlaXMlbXklZHJpdmVyIiwgaXQgd291bGQgYmUgc29tZXRoaW5nIGxpa2UNCj4g
InRoaXMlaXMlbXklZHJpdmVyLWkyYy0wLTI1Ii4gQW5kIHNvIG9uLiBXZSBjYW4gbm90IHBlcm1p
dCAiamMtNDIiDQo+IGJlY2F1c2UgbGlic2Vuc29ycyB3b3VsZCBub3QgYmUgYWJsZSB0byBwYXJz
ZSBzb21ldGhpbmcgbGlrZQ0KPiAiamMtNDItKiIgb3IgImpjLTQyLWkyYy0qIi4NCj4gDQo+IFRh
a2luZyB5b3VyIGV4YW1wbGUsIGlmIGRyaXZlciBhdXRob3JzIGltcGxlbWVudCB0d28gZHJpdmVy
cywgb25lDQo+IG5hbWVkIGZvby1iYXIgYW5kIHRoZSBvdGhlciBmb29fYmFyLCBpdCB3b3VsZCBi
ZSB0aGUgZHJpdmVyIGF1dGhvcnMnDQo+IHJlc3BvbnNpYmlsaXR5IHRvIHByb3ZpZGUgdmFsaWQg
ZHJpdmVyIG5hbWVzIHRvIHRoZSBod21vbiBzdWJzeXN0ZW0sDQo+IHdoYXRldmVyIHRob3NlIG5h
bWVzIG1pZ2h0IGJlLiBJZiBib3RoIGVuZCB1cCBuYW1lZCAiZm9vX2JhciIgYW5kIGNhbg0KPiBh
cyByZXN1bHQgbm90IGJlIGRpc3Rpbmd1aXNoZWQgZnJvbSBlYWNoIG90aGVyIGJ5IGxpYnNlbnNv
cnMsDQo+IG9yIGEgdXNlciBvZiB0aGUgInNlbnNvcnMiIGNvbW1hbmQsIHRoYXQgd291bGQgYmUg
ZW50aXJlbHkgdGhlDQo+IHJlc3BvbnNpYmlsaXR5IG9mIHRoZSBkcml2ZXIgYXV0aG9ycy4gVGhl
IG9ubHkgaW52b2x2ZW1lbnQgb2YgdGhlDQo+IGh3bW9uIHN1YnN5c3RlbSAtIGFuZCB0aGF0IGlz
IG9wdGlvbmFsIC0gd291bGQgYmUgdG8gcHJvdmlkZSBtZWFucw0KPiB0byB0aGUgZHJpdmVycyB0
byBoZWxwIHRoZW0gZW5zdXJlIHRoYXQgdGhlIG5hbWVzIGFyZSB2YWxpZCwgYnV0DQo+IG5vdCB0
aGF0IHRoZXkgYXJlIHVuaXF1ZS4NCj4gDQo+IElmIHRoZXJlIGlzIGV2ZXIgYSBkcml2ZXIgd2l0
aCBhIGRyaXZlciBuYW1lIHRoYXQgaW50ZXJmZXJlcyB3aXRoDQo+IGxpYnNlbnNvcnMnIGFiaWxp
dHkgdG8gZGlzdGluZ3Vpc2ggdGhlIGRyaXZlciBuYW1lIGZyb20gaW50ZXJmYWNlL3BvcnQNCj4g
aW5mb3JtYXRpb24sIHdlJ2xsIGJlIGhhcHB5IHRvIGFkZCB0aGUgb2ZmZW5kaW5nIGNoYXJhY3Rl
cihzKQ0KPiB0byBod21vbl9pc19iYWRfY2hhcigpLiBVbnRpbCB0aGVuLCBiZWluZyBwaWNreSBk
b2Vzbid0IHJlYWxseQ0KPiBhZGQgYW55IHZhbHVlIGFuZCBhcHBlYXJzIHBvaW50bGVzcy4NCg0K
U28gYWN0dWFsbHksIHRoZSBvbmx5IG9uZSBvZiB0aGUgY2hhcmFjdGVycyB0aGF0IGlzIGFjdHVh
bGx5DQpsaWtlbHkgYXQgYWxsIGlzICctJy4NCkFuZCBldmVuIHRoYXQgY2FuIGJlIGRlZW1lZCB0
byBiZSBhbiBlcnJvciBpbiB0aGUgY2FsbGVyPw0KT3IgYSAnYnVnJyBpbiB0aGUgbGlic2Vuc29y
cyBjb2RlIC0gd2hpY2ggY291bGQgaXRzZWxmIHRyZWF0ICctJyBhcyAnXycuDQoNClNvIHdoeSBu
b3QgZXJyb3IgdGhlIHJlcXVlc3QgdG8gY3JlYXRlZCB0aGUgaHdtb24gZGV2aWNlIHdpdGgNCmFu
IGludmFsaWQgbmFtZS4NClRoZSBuYW1lIHN1cHBsaWVkIHdpbGwgc29vbiBnZXQgZml4ZWQgLSBz
aW5jZSBpdCBpcyBhIGxpdGVyYWwNCnN0cmluZyBpbiB0aGUgY2FsbGluZyBkcml2ZXIuDQoNCglE
YXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91
bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5
NzM4NiAoV2FsZXMpDQo=

