Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7F752CE99
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 10:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235590AbiESIpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 04:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235584AbiESIo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 04:44:58 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AA09380204
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 01:44:56 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-258-Ycl6JFhPPeWrSeOc2GTTrg-1; Thu, 19 May 2022 09:44:54 +0100
X-MC-Unique: Ycl6JFhPPeWrSeOc2GTTrg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Thu, 19 May 2022 09:44:53 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Thu, 19 May 2022 09:44:53 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Michael Chan' <michael.chan@broadcom.com>
CC:     Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mchan@broadcom.com" <mchan@broadcom.com>,
        "David Miller" <davem@davemloft.net>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>
Subject: RE: tg3 dropping packets at high packet rates
Thread-Topic: tg3 dropping packets at high packet rates
Thread-Index: AdhqyKyabzDEQq15SKKGm31SHwTbKwAC24IAAAoYsMAABXOQgAASBiKA
Date:   Thu, 19 May 2022 08:44:53 +0000
Message-ID: <13d6579e9bc44dc2bfb73de8d9715b10@AcuMS.aculab.com>
References: <70a20d8f91664412ae91e401391e17cb@AcuMS.aculab.com>
 <6576c307ed554adb443e62a60f099266c95b55a7.camel@redhat.com>
 <153739175cf241a5895e6a5685a89598@AcuMS.aculab.com>
 <CACKFLinwh=YgPGPZ0M0dTJK1ar+SoPUZtYb5nBmLj6CNPdCQ2g@mail.gmail.com>
In-Reply-To: <CACKFLinwh=YgPGPZ0M0dTJK1ar+SoPUZtYb5nBmLj6CNPdCQ2g@mail.gmail.com>
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

RnJvbTogTWljaGFlbCBDaGFuDQo+IFNlbnQ6IDE5IE1heSAyMDIyIDAxOjUyDQo+IA0KPiBPbiBX
ZWQsIE1heSAxOCwgMjAyMiBhdCAyOjMxIFBNIERhdmlkIExhaWdodCA8RGF2aWQuTGFpZ2h0QGFj
dWxhYi5jb20+IHdyb3RlOg0KPiA+DQo+ID4gRnJvbTogUGFvbG8gQWJlbmkNCj4gPiA+IFNlbnQ6
IDE4IE1heSAyMDIyIDE4OjI3DQo+ID4gLi4uLg0KPiA+ID4gPiBJZiBJIHJlYWQgL3N5cy9jbGFz
cy9uZXQvZW0yL3N0YXRpc3RpY3MvcnhfcGFja2V0cyBldmVyeSBzZWNvbmQNCj4gPiA+ID4gZGVs
YXlpbmcgd2l0aDoNCj4gPiA+ID4gICBzeXNjYWxsKFNZU19jbG9ja19uYW5vc2xlZXAsIENMT0NL
X01PTk9UT05JQywgVElNRVJfQUJTVElNRSwgJnRzLCBOVUxMKTsNCj4gPiA+ID4gYWJvdXQgZXZl
cnkgNDMgc2Vjb25kcyBJIGdldCBhIHplcm8gaW5jcmVtZW50Lg0KPiA+ID4gPiBUaGlzIHJlYWxs
eSBkb2Vzbid0IGhlbHAhDQo+ID4gPg0KPiA+ID4gSXQgbG9va3MgbGlrZSB0aGUgdGczIGRyaXZl
ciBmZXRjaGVzIHRoZSBIL1cgc3RhdHMgb25jZSBwZXIgc2Vjb25kLiBJDQo+ID4gPiBndWVzcyB0
aGF0IGlmIHlvdSBmZXRjaCB0aGVtIHdpdGggdGhlIHNhbWUgcGVyaW9kIGFuZCB5b3UgYXJlIHVu
bHVja3kNCj4gPiA+IHlvdSBjYW4gcmVhZCB0aGUgc2FtZSBzYW1wbGUgMiBjb25zZWN1dGl2ZSB0
aW1lLg0KPiA+DQo+ID4gQWN0dWFsbHkgSSB0aGluayB0aGUgaGFyZHdhcmUgaXMgd3JpdGluZyB0
aGVtIHRvIGtlcm5lbCBtZW1vcnkNCj4gPiBldmVyeSBzZWNvbmQuDQo+IA0KPiBPbiB5b3VyIEJD
TTk1NzIwIGNoaXAsIHN0YXRpc3RpY3MgYXJlIGdhdGhlcmVkIGJ5IHRnM190aW1lcigpIG9uY2Ug
YQ0KPiBzZWNvbmQuICBPbGRlciBjaGlwcyB3aWxsIHVzZSBETUEuDQoNCkFoLCBJIHdhc24ndCBz
dXJlIHdoaWNoIGNvZGUgd2FzIHJlbGV2YW50Lg0KRldJVyB0aGUgY29kZSBjb3VsZCByb3RhdGUg
NjRiaXQgdmFsdWVzIGJ5IDMyIGJpdHMNCnRvIGNvbnZlcnQgdG8vZnJvbSB0aGUgc3RyYW5nZSBv
cmRlcmluZyB0aGUgaGFyZHdhcmUgdXNlcy4NCg0KPiBQbGVhc2Ugc2hvdyBhIHNuYXBzaG90IG9m
IGFsbCB0aGUgY291bnRlcnMuICBJbiBwYXJ0aWN1bGFyLA0KPiByeGJkc19lbXB0eSwgcnhfZGlz
Y2FyZHMsIGV0YyB3aWxsIHNob3cgd2hldGhlciB0aGUgZHJpdmVyIGlzIGtlZXBpbmcNCj4gdXAg
d2l0aCBpbmNvbWluZyBSWCBwYWNrZXRzIG9yIG5vdC4NCg0KQWZ0ZXIgcnVubmluZyB0aGUgdGVz
dCBmb3IgYSBzaG9ydCB0aW1lLg0KVGhlIGFwcGxpY2F0aW9uIHN0YXRzIGluZGljYXRlIHRoYXQg
YXJvdW5kIDQwMDAwIHBhY2tldHMgYXJlIG1pc3NpbmcuDQoNCiMgZXRodG9vbCAtUyBlbTIgfCBn
cmVwIC12ICcgMCQnOyBmb3IgZiBpbiAvc3lzL2NsYXNzL25ldC9lbTIvc3RhdGlzdGljcy8qOyBk
byBlY2hvICRmICQoY2F0ICRmKTsgZG9uZXxncmVwIC12ICcgMCQnDQpOSUMgc3RhdGlzdGljczoN
CiAgICAgcnhfb2N0ZXRzOiA0NTg5MDI4NTU4DQogICAgIHJ4X3VjYXN0X3BhY2tldHM6IDIxMDQ5
ODY2DQogICAgIHJ4X21jYXN0X3BhY2tldHM6IDc2Mw0KICAgICByeF9iY2FzdF9wYWNrZXRzOiA3
NDYNCiAgICAgdHhfb2N0ZXRzOiA0MzQ0DQogICAgIHR4X3VjYXN0X3BhY2tldHM6IDYNCiAgICAg
dHhfbWNhc3RfcGFja2V0czogNDANCiAgICAgdHhfYmNhc3RfcGFja2V0czogMw0KICAgICByeGJk
c19lbXB0eTogNzYNCiAgICAgcnhfZGlzY2FyZHM6IDE0DQogICAgIG1idWZfbHdtX3RocmVzaF9o
aXQ6IDE0DQovc3lzL2NsYXNzL25ldC9lbTIvc3RhdGlzdGljcy9tdWx0aWNhc3QgNzYzDQovc3lz
L2NsYXNzL25ldC9lbTIvc3RhdGlzdGljcy9yeF9ieXRlcyA0NTg5MDI4NTU4DQovc3lzL2NsYXNz
L25ldC9lbTIvc3RhdGlzdGljcy9yeF9taXNzZWRfZXJyb3JzIDE0DQovc3lzL2NsYXNzL25ldC9l
bTIvc3RhdGlzdGljcy9yeF9wYWNrZXRzIDIxNDMzMTY5DQovc3lzL2NsYXNzL25ldC9lbTIvc3Rh
dGlzdGljcy90eF9ieXRlcyA0MzQ0DQovc3lzL2NsYXNzL25ldC9lbTIvc3RhdGlzdGljcy90eF9w
YWNrZXRzIDQ5DQoNCkkndmUgcmVwbGFjZWQgdGhlIHJ4X3BhY2tldHMgY291bnQgd2l0aCBhbiBh
dG9taWM2NCBjb3VudGVyIGluIHRnM19yeCgpLg0KUmVhZGluZyBldmVyeSBzZWNvbmQgZ2l2ZXMg
dmFsdWVzIGxpa2U6DQoNCiMgZWNob19ldmVyeSAxIHwoYz0wOyBuMD0wOyB3aGlsZSByZWFkIHI7
IGRvIG49JChjYXQgL3N5cy9jbGFzcy9uZXQvZW0yL3N0YXRpc3RpY3MvcnhfcGFja2V0cyk7IGVj
aG8gJGMgJCgobiAtIG4wKSk7IGM9JCgoYysxKSk7IG4wPSRuOyBkb25lKQ0KMCAzOTcxNjk5NDkN
CjEgMzk5ODMxDQoyIDM5OTg4Mw0KMyAzOTk5MTMNCjQgMzk5ODcxDQo1IDM5ODc0Nw0KNiA0MDAw
MzUNCjcgMzk5OTU4DQo4IDM5OTk0Nw0KOSAzOTk5MjMNCjEwIDM5OTk3OA0KMTEgMzk5NDU3DQox
MiAzOTkxMzANCjEzIDQwMDEyOA0KMTQgMzk5ODA4DQoxNSAzOTkwMjkNCg0KVGhleSBzaG91bGQg
YWxsIGJlIDQwMDAwMCB3aXRoIHNsaWdodCB2YXJpYW5jZXMuDQpCdXQgdGhlcmUgYXJlIGNsZWFy
bHkgMTAwcyBvZiBwYWNrZXRzIGJlaW5nIGRpc2NhcmRlZCBpbiBzb21lDQoxIHNlY29uZCBwZXJp
b2RzLg0KDQpJIGRvbid0IHRoaW5rIEkgY2FuIGJsYW1lIHRoZSBuZXR3b3JrLg0KQWxsIHRoZSBz
eXN0ZW1zIGFyZSBwbHVnZ2VkIGludG8gdGhlIHNhbWUgZXRoZXJuZXQgc3dpdGNoIG9uIGEgdGVz
dCBMQU4uDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1s
ZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJh
dGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

