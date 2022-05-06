Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3E351D2D4
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 10:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389822AbiEFINf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 04:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239540AbiEFINe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 04:13:34 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C22CA674F2
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 01:09:48 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-250-24u7aDa_PwiQf3uhDwIDfw-1; Fri, 06 May 2022 09:09:45 +0100
X-MC-Unique: 24u7aDa_PwiQf3uhDwIDfw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Fri, 6 May 2022 09:09:44 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Fri, 6 May 2022 09:09:44 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Maxim Mikityanskiy' <maximmi@nvidia.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next] tls: Add opt-in zerocopy mode of sendfile()
Thread-Topic: [PATCH net-next] tls: Add opt-in zerocopy mode of sendfile()
Thread-Index: AQHYXx+Xq0V3mdE7TkGKm+YxYaezY60OeVSwgAGyMICAACK8UIAAPk4AgADxqjA=
Date:   Fri, 6 May 2022 08:09:44 +0000
Message-ID: <1f45be856eae43a5bca0af524f5b02b9@AcuMS.aculab.com>
References: <20220427175048.225235-1-maximmi@nvidia.com>
 <20220428151142.3f0ccd83@kernel.org>
 <d99c36fd-2bd3-acc6-6c37-7eb439b04949@nvidia.com>
 <20220429121117.21bf7490@kernel.org>
 <db461463-23ac-de03-806b-6ce2b7ea1d6b@nvidia.com>
 <3f5f17a11d294781a5e500b3903aa902@AcuMS.aculab.com>
 <41abbf9f-8719-f2a7-36b5-fd6835bb133d@nvidia.com>
 <5dba0c54c647491a85366834c8c1c7d1@AcuMS.aculab.com>
 <f1fa7f2c-d5ef-256b-0bc3-87950c2b6ab7@nvidia.com>
In-Reply-To: <f1fa7f2c-d5ef-256b-0bc3-87950c2b6ab7@nvidia.com>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogTWF4aW0gTWlraXR5YW5za2l5DQo+IFNlbnQ6IDA1IE1heSAyMDIyIDE5OjI4DQo+IA0K
PiBPbiAyMDIyLTA1LTA1IDE2OjQ4LCBEYXZpZCBMYWlnaHQgd3JvdGU6DQo+ID4gRnJvbTogTWF4
aW0gTWlraXR5YW5za2l5DQo+ID4+IFNlbnQ6IDA1IE1heSAyMDIyIDEzOjQwDQo+ID4+DQo+ID4+
IE9uIDIwMjItMDUtMDQgMTI6NDksIERhdmlkIExhaWdodCB3cm90ZToNCj4gPj4+Pj4gSWYgeW91
IGRlY2xhcmUgdGhlIHVuaW9uIG9uIHRoZSBzdGFjayBpbiB0aGUgY2FsbGVycywgYW5kIHBhc3Mg
YnkgdmFsdWUNCj4gPj4+Pj4gLSBpcyB0aGUgY29tcGlsZXIgbm90IGdvaW5nIHRvIGJlIGNsZXZl
ciBlbm91Z2ggdG8gc3RpbGwgRERSVD8NCj4gPj4+Pg0KPiA+Pj4+IEFoLCBPSywgaXQgc2hvdWxk
IGRvIHRoZSB0aGluZy4gSSB0aG91Z2h0IHlvdSB3YW50ZWQgbWUgdG8gZGl0Y2ggdGhlDQo+ID4+
Pj4gdW5pb24gYWx0b2dldGhlci4NCj4gPj4+DQo+ID4+PiBTb21lIGFyY2hpdGVjdHVyZXMgYWx3
YXlzIHBhc3Mgc3RydWN0L3VuaW9uIGJ5IGFkZHJlc3MuDQo+ID4+PiBXaGljaCBpcyBwcm9iYWJs
eSBub3Qgd2hhdCB5b3UgaGFkIGluIG1pbmQuDQo+ID4+DQo+ID4+IERvIHlvdSBoYXZlIGFueSBz
cGVjaWZpYyBhcmNoaXRlY3R1cmUgaW4gbWluZD8gSSBjb3VsZG4ndCBmaW5kIGFueQ0KPiA+PiBp
bmZvcm1hdGlvbiB0aGF0IGl0IGhhcHBlbnMgYW55d2hlcmUsIHg4Nl82NCBBQkkgWzFdIChwYWdl
cyAyMC0yMSkNCj4gPj4gYWxpZ25zIHdpdGggbXkgZXhwZWN0YXRpb25zLCBhbmQgbXkgY29tbW9u
IHNlbnNlIGNhbid0IGV4cGxhaW4gd2h5IHdvdWxkDQo+ID4+IHNvbWUgYXJjaGl0ZWN0dXJlcyBk
byB3aGF0IHlvdSBzYXkuDQo+ID4+DQo+ID4+IEluIEMsIHdoZW4gdGhlIGNhbGxlciBwYXNzZXMg
YSBzdHJ1Y3QgYXMgYSBwYXJhbWV0ZXIsIHRoZSBjYWxsZWUgY2FuDQo+ID4+IGZyZWVseSBtb2Rp
ZnkgaXQuIElmIHRoZSBjb21waWxlciBzaWxlbnRseSByZXBsYWNlZCBpdCB3aXRoIGEgcG9pbnRl
ciwNCj4gPj4gdGhlIGNhbGxlZSB3b3VsZCBjb3JydXB0IHRoZSBjYWxsZXIncyBsb2NhbCB2YXJp
YWJsZSwgc28gc3VjaCBhcHByb2FjaA0KPiA+PiByZXF1aXJlcyB0aGUgY2FsbGVyIHRvIG1ha2Ug
YW4gZXh0cmEgY29weS4NCj4gPg0KPiA+IFllcywgdGhhdCBpcyB3aGF0IGhhcHBlbnMuDQo+IA0K
PiBJIGRpZCBhIHF1aWNrIGV4cGVyaW1lbnQgd2l0aCBnY2MgOSBvbiBtNjhrIGFuZCBpMzg2LCBh
bmQgaXQgZG9lc24ndA0KPiBjb25maXJtIHdoYXQgeW91IGNsYWltLg0KPiANCj4gI2luY2x1ZGUg
PHN0ZGludC5oPg0KPiAjaW5jbHVkZSA8c3RkaW8uaD4NCj4gDQo+IHVuaW9uIHRlc3Qgew0KPiAg
ICAgICAgICB1aW50MzJfdCB4Ow0KPiAgICAgICAgICB1aW50MzJfdCAqeTsNCj4gfTsNCj4gDQo+
IHZvaWQgZnVuYzEodm9pZCAqcHRyLCB1bmlvbiB0ZXN0IHQpDQo+IHsNCj4gICAgICAgICAgaWYg
KHB0cikgew0KPiAgICAgICAgICAgICAgICAgIHByaW50ZigiJXAgJXVcbiIsIHB0ciwgdC54KTsN
Cj4gICAgICAgICAgfSBlbHNlIHsNCj4gICAgICAgICAgICAgICAgICBwcmludGYoIiV1XG4iLCAq
dC55KTsNCj4gICAgICAgICAgfQ0KPiB9DQo+IA0KPiB2b2lkIGZ1bmMyKHZvaWQgKnB0ciwgdWlu
dDMyX3QgKnkpDQo+IHsNCj4gICAgICAgICAgaWYgKHB0cikgew0KPiAgICAgICAgICAgICAgICAg
IHByaW50ZigiJXAgJXVcbiIsIHB0ciwgKHVpbnQzMl90KXkpOw0KPiAgICAgICAgICB9IGVsc2Ug
ew0KPiAgICAgICAgICAgICAgICAgIHByaW50ZigiJXVcbiIsICp5KTsNCj4gICAgICAgICAgfQ0K
PiB9DQo+IA0KPiBnY2MgLVMgdGVzdC5jIC1mbm8tc3RyaWN0LWFsaWFzaW5nIC1vIC0NCj4gDQo+
IEkgYmVsaWV2ZSB0aGlzIG1pbmltYWwgZXhhbXBsZSByZWZsZWN0cyB3ZWxsIGVub3VnaCB3aGF0
IGhhcHBlbnMgaW4gbXkNCj4gY29kZS4gVGhlIGFzc2VtYmx5IGdlbmVyYXRlZCBmb3IgZnVuYzEg
YW5kIGZ1bmMyIGFyZSBpZGVudGljYWwuIEluIGJvdGgNCj4gY2FzZXMgdGhlIHNlY29uZCBwYXJh
bWV0ZXIgaXMgcGFzc2VkIG9uIHRoZSBzdGFjayBieSB2YWx1ZSwgbm90IGJ5IHBvaW50ZXIuDQoN
CkhtbW0sIHBlcmhhcHMgaXQgaXMvd2FzIG9ubHkgc3BhcmMzMiB0aGF0IHBhc3NlZCBhbGwgc3Ry
dWN0dXJlcyBieSByZWZlcmVuY2UuDQpnb2Rib2x0IGRvZXNuJ3Qgc2VlbSB0byBoYXZlIGEgc3Bh
cmMgY29tcGlsZXIgYW5kIEkgZG9uJ3QgaGF2ZSBhDQp3b3JraW5nIHNwYXJjIHN5c3RlbSBhbnkg
bW9yZS4NCg0KSXQgaXMgYWxzbyBwb3NzaWJsZSB0aGF0IHRoZSBjYWxsaW5nIGNvbnZlbnRpb25z
IGFyZSBzbGlnaHRseQ0KZGlmZmVyZW50IHRoYW4gdGhlIG9uZXMgSSByZW1lbWJlciB1c2luZyB5
ZWFycyBhZ28uDQoNCkNlcnRhaW5seSBvbiBpMzg2IGV2ZW4gNCBieXRlIHN0cnVjdHVyZXMgYXJl
IHJldHVybmVkIGJ5IHJlZmVyZW5jZS4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVz
cyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEg
MVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

