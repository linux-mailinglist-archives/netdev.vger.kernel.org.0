Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAB76E0FD8
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 16:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbjDMOU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 10:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbjDMOU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 10:20:57 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27CA0359D
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 07:20:55 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-168-L1A8pdJON22gPzDGKhDKwg-1; Thu, 13 Apr 2023 15:20:53 +0100
X-MC-Unique: L1A8pdJON22gPzDGKhDKwg-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 13 Apr
 2023 15:20:51 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Thu, 13 Apr 2023 15:20:51 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Paolo Abeni' <pabeni@redhat.com>,
        'Jakub Kicinski' <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: RE: [PATCH net-next v2 2/3] bnxt: use READ_ONCE/WRITE_ONCE for ring
 indexes
Thread-Topic: [PATCH net-next v2 2/3] bnxt: use READ_ONCE/WRITE_ONCE for ring
 indexes
Thread-Index: AQHZbOE4lpy9n4P2zECDFY6wjA/SEa8nUYsggAG8xQCAADw1wA==
Date:   Thu, 13 Apr 2023 14:20:51 +0000
Message-ID: <3d2a7abe17554ed69f599b733062a003@AcuMS.aculab.com>
References: <20230412015038.674023-1-kuba@kernel.org>
         <20230412015038.674023-3-kuba@kernel.org>
         <f6c134852244441a88eef8c1774bb67f@AcuMS.aculab.com>
 <78cea5774de414fa3bcbd6ef02e436ae6b5706c1.camel@redhat.com>
In-Reply-To: <78cea5774de414fa3bcbd6ef02e436ae6b5706c1.camel@redhat.com>
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

RnJvbTogUGFvbG8gQWJlbmkNCj4gU2VudDogMTMgQXByaWwgMjAyMyAxMjozOA0KPiANCj4gT24g
V2VkLCAyMDIzLTA0LTEyIGF0IDA4OjE1ICswMDAwLCBEYXZpZCBMYWlnaHQgd3JvdGU6DQo+ID4g
RnJvbTogSmFrdWIgS2ljaW5za2kNCj4gPiA+IFNlbnQ6IDEyIEFwcmlsIDIwMjMgMDI6NTENCj4g
PiA+DQo+ID4gPiBFcmljIHBvaW50cyBvdXQgdGhhdCB3ZSBzaG91bGQgbWFrZSBzdXJlIHRoYXQg
cmluZyBpbmRleCB1cGRhdGVzDQo+ID4gPiBhcmUgd3JhcHBlZCBpbiB0aGUgYXBwcm9wcmlhdGUg
UkVBRF9PTkNFL1dSSVRFX09OQ0UgbWFjcm9zLg0KPiA+ID4NCj4gPiAuLi4NCj4gPiA+IC1zdGF0
aWMgaW5saW5lIHUzMiBibnh0X3R4X2F2YWlsKHN0cnVjdCBibnh0ICpicCwgc3RydWN0IGJueHRf
dHhfcmluZ19pbmZvICp0eHIpDQo+ID4gPiArc3RhdGljIGlubGluZSB1MzIgYm54dF90eF9hdmFp
bChzdHJ1Y3QgYm54dCAqYnAsDQo+ID4gPiArCQkJCWNvbnN0IHN0cnVjdCBibnh0X3R4X3Jpbmdf
aW5mbyAqdHhyKQ0KPiA+ID4gIHsNCj4gPiA+IC0JLyogVGVsbCBjb21waWxlciB0byBmZXRjaCB0
eCBpbmRpY2VzIGZyb20gbWVtb3J5LiAqLw0KPiA+ID4gLQliYXJyaWVyKCk7DQo+ID4gPiArCXUz
MiB1c2VkID0gUkVBRF9PTkNFKHR4ci0+dHhfcHJvZCkgLSBSRUFEX09OQ0UodHhyLT50eF9jb25z
KTsNCj4gPiA+DQo+ID4gPiAtCXJldHVybiBicC0+dHhfcmluZ19zaXplIC0NCj4gPiA+IC0JCSgo
dHhyLT50eF9wcm9kIC0gdHhyLT50eF9jb25zKSAmIGJwLT50eF9yaW5nX21hc2spOw0KPiA+ID4g
KwlyZXR1cm4gYnAtPnR4X3Jpbmdfc2l6ZSAtICh1c2VkICYgYnAtPnR4X3JpbmdfbWFzayk7DQo+
ID4gPiAgfQ0KPiA+DQo+ID4gRG9lc24ndCB0aGF0IGZ1bmN0aW9uIG9ubHkgbWFrZSBzZW5zZSBp
ZiBvbmx5IG9uZSBvZg0KPiA+IHRoZSByaW5nIGluZGV4IGNhbiBiZSBjaGFuZ2luZz8NCj4gPiBJ
biB0aGlzIGNhc2UgSSB0aGluayB0aGlzIGlzIGJlaW5nIHVzZWQgaW4gdGhlIHRyYW5zbWl0IHBh
dGgNCj4gPiBzbyB0aGF0ICd0eF9wcm9kJyBpcyBjb25zdGFudCBhbmQgaXMgZWl0aGVyIGFscmVh
ZHkgcmVhZA0KPiA+IG9yIG5lZWQgbm90IGJlIHJlYWQgYWdhaW4uDQo+ID4NCi4uLg0KPiANCj4g
QUZBSUNTIGJueHRfdHhfYXZhaWwoKSBpcyBhbHNvIHVzZWQgaW4gVFggaW50ZXJydXB0LCBvdXRz
aWRlIHR4IHBhdGgvdHgNCj4gbG9jay4NCg0KSW4gd2hpY2ggY2FzZSBib3RoIHR4X3Byb2QgYW5k
IHR4X2NvbnMgYXJlIHN1YmplY3QgdG8gcG9zc2libGUgdXBkYXRlcy4NCkl0IGlzIGV2ZW4gcG9z
c2libGUgdGhhdCB0aGUgdHdvIHZhbHVlcyBoYXZlIGFic29sdXRlbHkgbm8gcmVsYXRpb24NCnRv
IGVhY2ggb3RoZXIsIGl0IHJlcXVpcmVzIHNvbWUgdW51c3VhbCBjaXJjdW1zdGFuY2VzLCBidXQg
aXNuJ3QgaW1wb3NzaWJsZS4NCi0gQSBoaWdoIHByaW9yaXR5IGludGVycnVwdCAoZWcgeDg2IFNN
TSBtb2RlKSBjb3VsZCBzZXBhcmF0ZSB0aGUgUkVBRF9PTkNFKCkuDQotIFRyYW5zbWl0IHNldHVw
IHdpbGwgaW5jcmVhc2UgdHhfcHJvZC4NCi0gRW5kIG9mIHRyYW5zbWl0ICdyZWFwJyBvZnRlbiBk
b25lIGJ5IG90aGVyIGNvZGUgcGF0aHMgKGxpa2UgcnggcHJvY2Vzc2luZw0KICBvciB0eCBzZXR1
cCkgY2FuIGNoYW5nZSB0eF9jb25zLg0KU28gbm90IG9ubHkgaXMgdGhlIHZhbHVlIGltbWVkaWF0
ZWx5IHN0YWxlLCBpdCBjYW4gYmUganVzdCBwbGFpbiB3cm9uZy4NCg0KCURhdmlkDQoNCi0NClJl
Z2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0
b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykN
Cg==

