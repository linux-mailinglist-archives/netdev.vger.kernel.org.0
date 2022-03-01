Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE874C899C
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 11:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234039AbiCAKrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 05:47:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234407AbiCAKrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 05:47:49 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 592B590FD6
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 02:47:08 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-9-k5QvRFb1PI-8v6nfzAE3Tg-1; Tue, 01 Mar 2022 10:47:05 +0000
X-MC-Unique: k5QvRFb1PI-8v6nfzAE3Tg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Tue, 1 Mar 2022 10:47:04 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Tue, 1 Mar 2022 10:47:04 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christophe Leroy' <christophe.leroy@csgroup.eu>,
        'Segher Boessenkool' <segher@kernel.crashing.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: Remove branch in csum_shift()
Thread-Topic: [PATCH] net: Remove branch in csum_shift()
Thread-Index: AQHYHyQqmTo4K/pb5UWdDmTfE7rfRayQxWFwgABxD4CAAIxicIAYqtUAgAAE/lA=
Date:   Tue, 1 Mar 2022 10:47:04 +0000
Message-ID: <9cdb4a5243d342efb562bc61d0c1bfcb@AcuMS.aculab.com>
References: <efeeb0b9979b0377cd313311ad29cf0ac060ae4b.1644569106.git.christophe.leroy@csgroup.eu>
 <7f16910a8f63475dae012ef5135f41d1@AcuMS.aculab.com>
 <20220213091619.GY614@gate.crashing.org>
 <476aa649389345db92f86e9103a848be@AcuMS.aculab.com>
 <de560db6-d29a-8565-857b-b42ae35f80f8@csgroup.eu>
In-Reply-To: <de560db6-d29a-8565-857b-b42ae35f80f8@csgroup.eu>
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
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQ2hyaXN0b3BoZSBMZXJveQ0KPiBTZW50OiAwMSBNYXJjaCAyMDIyIDEwOjIwDQo+IA0K
PiBMZSAxMy8wMi8yMDIyIMOgIDE4OjQ3LCBEYXZpZCBMYWlnaHQgYSDDqWNyaXTCoDoNCj4gPiBG
cm9tOiBTZWdoZXIgQm9lc3Nlbmtvb2wNCj4gPj4gU2VudDogMTMgRmVicnVhcnkgMjAyMiAwOTox
Ng0KPiA+IC4uLi4NCj4gPj4NCj4gPj4+IFdoYXQgaGFwcGVucyBvbiB4ODYtNjQ/DQo+ID4+Pg0K
PiA+Pj4gVHJ5aW5nIHRvIGRvIHRoZSBzYW1lIGluIHRoZSB4ODYgaXBjc3VtIGNvZGUgdGVuZGVk
IHRvIG1ha2UgdGhlIGNvZGUgd29yc2UuDQo+ID4+PiAoQWx0aG91Z2ggdGhhdCB0ZXN0IGlzIGZv
ciBhbiBvZGQgbGVuZ3RoIGZyYWdtZW50IGFuZCBjYW4ganVzdCBiZSByZW1vdmVkLikNCj4gPj4N
Cj4gPj4gSW4gYW4gaWRlYWwgd29ybGQgdGhlIGNvbXBpbGVyIGNvdWxkIGNob29zZSB0aGUgb3B0
aW1hbCBjb2RlIHNlcXVlbmNlcw0KPiA+PiBldmVyeXdoZXJlLiAgQnV0IHRoYXQgd29uJ3QgZXZl
ciBoYXBwZW4sIHRoZSBzZWFyY2ggc3BhY2UgaXMgd2F5IHRvbw0KPiA+PiBiaWcuICBTbyBjb21w
aWxlcnMganVzdCB1c2UgaGV1cmlzdGljcywgbm90IGV4aGF1c3RpdmUgc2VhcmNoIGxpa2UNCj4g
Pj4gc3VwZXJvcHQgZG9lcy4gIFRoZXJlIGlzIGEgbWlkZGxlIHdheSBvZiBjb3Vyc2UsIHNvbWV0
aGluZyB3aXRoIGRpcmVjdGVkDQo+ID4+IHNlYXJjaGVzLCBhbmQgbWF5YmUgaW4gYSBmZXcgZGVj
YWRlcyBzeXN0ZW1zIHdpbGwgYmUgZmFzdCBlbm91Z2guICBVbnRpbA0KPiA+PiB0aGVuIHdlIHdp
bGwgdmVyeSBvZnRlbiBzZWUgY29kZSB0aGF0IGlzIDEwJSBzbG93ZXIgYW5kIDMwJSBiaWdnZXIg
dGhhbg0KPiA+PiBuZWNlc3NhcnkuICBBIHNpbmdsZSBpbnNuIG1vcmUgdGhhbiBuZWVkZWQgaXNu
J3Qgc28gYmFkIDotKQ0KPiA+DQo+ID4gQnV0IGl0IGNhbiBiZSBhIGxvdCBtb3JlIHRoYW4gdGhh
dC4NCj4gPg0KPiA+PiBNYWtpbmcgdGhpbmdzIGJyYW5jaC1mcmVlIGlzIHZlcnkgbXVjaCB3b3J0
aCBpdCBoZXJlIHRob3VnaCENCj4gPg0KPiA+IEkgdHJpZWQgdG8gZmluZCBvdXQgd2hlcmUgJ2hl
cmUnIGlzLg0KPiA+DQo+ID4gSSBjYW4ndCBnZXQgZ29kYm9sdCB0byBnZW5lcmF0ZSBhbnl0aGlu
ZyBsaWtlIHRoYXQgb2JqZWN0IGNvZGUNCj4gPiBmb3IgYSBjYWxsIHRvIGNzdW1fc2hpZnQoKS4N
Cj4gPg0KPiA+IEkgY2FuJ3QgYWN0dWFsbHkgZ2V0IGl0IHRvIGlzc3VlIGEgcm90YXRlICh4ODYg
b2YgcHBjKS4NCj4gPg0KPiA+IEkgdGhpbmsgaXQgaXMgb25seSBhIHNpbmdsZSBpbnN0cnVjdGlv
biBiZWNhdXNlIHRoZSBjb21waWxlcg0KPiA+IGhhcyBzYXZlZCAnb2Zmc2V0ICYgMScgbXVjaCBl
YXJsaWVyIGluc3RlYWQgb2YgZG9pbmcgdGVzdGluZw0KPiA+ICdvZmZzZXQgJiAxJyBqdXN0IHBy
aW9yIHRvIHRoZSBjb25kaXRpb25hbC4NCj4gPiBJdCBjZXJ0YWlubHkgaGFzIGEgbmFzdHkgaGFi
aXQgb2YgZG9pbmcgdGhhdCBwZXNzaW1pc2F0aW9uLg0KPiA+DQo+ID4gU28gd2hpbGUgaXQgaGVs
cHMgYSBzcGVjaWZpYyBjYWxsIHNpdGUgaXQgbWF5IGJlIG11Y2gNCj4gPiB3b3JzZSBpbiBnZW5l
cmFsLg0KPiA+DQo+IA0KPiBUaGUgbWFpbiB1c2VyIG9mIGNzdW1fc2hpZnQoKSBpcyBjc3VtX2Fu
ZF9jb3B5X3RvX2l0ZXIoKS4NCj4gDQo+IFlvdSBjbGVhcmx5IHNlZSB0aGUgZGlmZmVyZW5jZSBp
biBvbmUgb2YgdGhlIGluc3RhbmNlcyBiZWxvdyBleHRyYWN0ZWQNCj4gZnJvbSBvdXRwdXQgb2Yg
b2JqZHVtcCAtUyBsaWIvaW92X2l0ZXIubzoNCj4gDQo+IA0KPiBXaXRob3V0IHRoZSBwYXRjaDoN
Cj4gDQo+IAlzdW0gPSBjc3VtX3NoaWZ0KGNzc3RhdGUtPmNzdW0sIGNzc3RhdGUtPm9mZik7DQo+
ICAgICAgMjFhODoJOTIgZTEgMDAgNGMgCXN0dyAgICAgcjIzLDc2KHIxKQ0KPiAgICAgIDIxYWM6
CTdjIDc3IDFiIDc4IAltciAgICAgIHIyMyxyMw0KPiAgICAgIDIxYjA6CTkzIDAxIDAwIDUwIAlz
dHcgICAgIHIyNCw4MChyMSkNCj4gICAgICAyMWI0Ogk3YyBiOCAyYiA3OCAJbXIgICAgICByMjQs
cjUNCj4gICAgICAyMWI4Ogk5MyA2MSAwMCA1YyAJc3R3ICAgICByMjcsOTIocjEpDQo+ICAgICAg
MjFiYzoJN2MgZGIgMzMgNzggCW1yICAgICAgcjI3LHI2DQo+ICAgICAgMjFjMDoJOTMgODEgMDAg
NjAgCXN0dyAgICAgcjI4LDk2KHIxKQ0KPiAgICAgIDIxYzQ6CTgxIDA1IDAwIDA0IAlsd3ogICAg
IHI4LDQocjUpDQo+ICAgICAgMjFjODoJODMgODUgMDAgMDAgCWx3eiAgICAgcjI4LDAocjUpDQo+
IH0NCj4gDQo+IHN0YXRpYyBfX2Fsd2F5c19pbmxpbmUgX193c3VtIGNzdW1fc2hpZnQoX193c3Vt
IHN1bSwgaW50IG9mZnNldCkNCj4gew0KPiAJLyogcm90YXRlIHN1bSB0byBhbGlnbiBpdCB3aXRo
IGEgMTZiIGJvdW5kYXJ5ICovDQo+IAlpZiAob2Zmc2V0ICYgMSkNCj4gICAgICAyMWNjOgk3MSAw
OSAwMCAwMSAJYW5kaS4gICByOSxyOCwxCQk8PT0gdGVzdCBvZGRpdHkNCj4gICAgICAyMWQwOgk0
MSBhMiAwMCAwOCAJYmVxICAgICAyMWQ4CQk8PT0gYnJhbmNoDQo+ICAgKiBAd29yZDogdmFsdWUg
dG8gcm90YXRlDQo+ICAgKiBAc2hpZnQ6IGJpdHMgdG8gcm9sbA0KPiAgICovDQo+IHN0YXRpYyBp
bmxpbmUgX191MzIgcm9yMzIoX191MzIgd29yZCwgdW5zaWduZWQgaW50IHNoaWZ0KQ0KPiB7DQo+
IAlyZXR1cm4gKHdvcmQgPj4gKHNoaWZ0ICYgMzEpKSB8ICh3b3JkIDw8ICgoLXNoaWZ0KSAmIDMx
KSk7DQo+ICAgICAgMjFkNDoJNTcgOWMgYzAgM2UgCXJvdGx3aSAgcjI4LHIyOCwyNAk8PT0gcm90
YXRlDQo+ICAgICAgMjFkODoJMmIgOGEgMDAgMDMgCWNtcGx3aSAgY3I3LHIxMCwzDQo+ICAgICAg
MjFkYzoJNDEgOWUgMDEgZWMgCWJlcSAgICAgY3I3LDIzYzggPGNzdW1fYW5kX2NvcHlfdG9faXRl
cisweDIzND4NCj4gDQo+IA0KPiANCj4gDQo+IFdpdGggdGhlIHBhdGNoOg0KPiANCj4gCXN1bSA9
IGNzdW1fc2hpZnQoY3NzdGF0ZS0+Y3N1bSwgY3NzdGF0ZS0+b2ZmKTsNCj4gICAgICAyMWE4Ogk5
MiBjMSAwMCA0OCAJc3R3ICAgICByMjIsNzIocjEpDQo+IAlpZiAodW5saWtlbHkoaW92X2l0ZXJf
aXNfcGlwZShpKSkpDQo+ICAgICAgMjFhYzoJMjggMDggMDAgMDMgCWNtcGx3aSAgcjgsMw0KPiAg
ICAgIDIxYjA6CTkyIGUxIDAwIDRjIAlzdHcgICAgIHIyMyw3NihyMSkNCj4gICAgICAyMWI0Ogk3
YyA3NiAxYiA3OCAJbXIgICAgICByMjIscjMNCj4gICAgICAyMWI4Ogk5MyA0MSAwMCA1OCAJc3R3
ICAgICByMjYsODgocjEpDQo+ICAgICAgMjFiYzoJN2MgYjcgMmIgNzggCW1yICAgICAgcjIzLHI1
DQo+ICAgICAgMjFjMDoJOTMgODEgMDAgNjAgCXN0dyAgICAgcjI4LDk2KHIxKQ0KPiAgICAgIDIx
YzQ6CTdjIGRhIDMzIDc4IAltciAgICAgIHIyNixyNg0KPiAJc3VtID0gY3N1bV9zaGlmdChjc3N0
YXRlLT5jc3VtLCBjc3N0YXRlLT5vZmYpOw0KPiAgICAgIDIxYzg6CTgwIGU1IDAwIDA0IAlsd3og
ICAgIHI3LDQocjUpDQo+ICAgKiBAd29yZDogdmFsdWUgdG8gcm90YXRlDQo+ICAgKiBAc2hpZnQ6
IGJpdHMgdG8gcm9sbA0KPiAgICovDQo+IHN0YXRpYyBpbmxpbmUgX191MzIgcm9sMzIoX191MzIg
d29yZCwgdW5zaWduZWQgaW50IHNoaWZ0KQ0KPiB7DQo+IAlyZXR1cm4gKHdvcmQgPDwgKHNoaWZ0
ICYgMzEpKSB8ICh3b3JkID4+ICgoLXNoaWZ0KSAmIDMxKSk7DQo+ICAgICAgMjFjYzoJODEgMjUg
MDAgMDAgCWx3eiAgICAgcjksMChyNSkNCj4gfQ0KPiANCj4gc3RhdGljIF9fYWx3YXlzX2lubGlu
ZSBfX3dzdW0gY3N1bV9zaGlmdChfX3dzdW0gc3VtLCBpbnQgb2Zmc2V0KQ0KPiB7DQo+IAkvKiBy
b3RhdGUgc3VtIHRvIGFsaWduIGl0IHdpdGggYSAxNmIgYm91bmRhcnkgKi8NCj4gCXJldHVybiAo
X19mb3JjZSBfX3dzdW0pcm9sMzIoKF9fZm9yY2UgdTMyKXN1bSwgKG9mZnNldCAmIDEpIDw8IDMp
Ow0KPiAgICAgIDIxZDA6CTU0IGVhIDFmIDM4IAlybHdpbm0gIHIxMCxyNywzLDI4LDI4DQoNClJp
Z2h0LCB0aGlzIGFsbCBkZXBlbmRzIG9uIHRoZSBybHdpbm0gaW5zdHJ1Y3Rpb24uDQpJIGhhZCB0
byBsb29rIGl0IHVwLCB0aGF0IG9uZSBzaGlmdHMgcjcgKGNvdW50KSBsZWZ0IDMgYml0cw0KYW5k
IHRoZW4gbWFza3MgaXQgd2l0aCBhbGwgdGhlIGJpdHMgZnJvbSAyOCB0byAyOCAoaW4gc29tZSBj
b3VudGluZyBzY2hlbWUpLg0KDQpUcnkgdGhlIHNhbWUgY29kZSBvbiB4ODYuDQpUaGUgbWFzayBh
bmQgc2hpZnQgaGF2ZSB0byBiZSBzZXBhcmF0ZSBpbnN0cnVjdGlvbnMgYW5kIGl0IHByb2JhYmx5
DQpuZWVkcyBhIHJlZ2lzdGVyIG1vdmUgKHdoaWNoIG1pZ2h0IGJlIGEgcmVuYW1lIGFuZCBmcmVl
KS4NCldoZXJlYXMgdGhlIGN1cnJlbnQgY29kZSBnZW5lcmF0ZXMgYSBjb25kaXRpb25hbCBtb3Zl
Lg0KKEF0IGxlYXN0LCB0aGUgb25seSByb3RhdGVzIGluIHRoYXQgZnVuY3Rpb24gYXJlIGZvbGxv
d2VkIGJ5IGEgY21vdm5lLikNCg0KU28geDg2IGlzIGFsbW9zdCBjZXJ0YWlubHkgYmV0dGVyIHdp
dGggdGhlIGN1cnJlbnQgY29kZS4NCk5vIGlkZWEgYWJvdXQgYXJtIG9yIGFueXRoaW5nIGVsc2Ug
cGVvcGxlIG1pZ2h0IGNhcmUgYWJvdXQuDQoNCkFsbCB0aGUgd29ybGQgaXNuJ3QgcHBjLg0KDQoJ
RGF2aWQNCg0KPiAgICAgIDIxZDQ6CTVkIDNjIDUwIDNlIAlyb3RsdyAgIHIyOCxyOSxyMTAJPD09
IHJvdGF0ZQ0KPiAJaWYgKHVubGlrZWx5KGlvdl9pdGVyX2lzX3BpcGUoaSkpKQ0KPiAgICAgIDIx
ZDg6CTQxIDgyIDAxIGUwIAliZXEgICAgIDIzYjggPGNzdW1fYW5kX2NvcHlfdG9faXRlcisweDIy
ND4NCj4gDQo+IA0KPiBDaHJpc3RvcGhlDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lk
ZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0K
UmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

