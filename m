Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F25E252D5A8
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 16:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239020AbiESOLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 10:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239533AbiESOLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 10:11:17 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 022195BE5E
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 07:11:15 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-147-9ujxR9WzPHi5JTxbVikL3w-1; Thu, 19 May 2022 15:11:13 +0100
X-MC-Unique: 9ujxR9WzPHi5JTxbVikL3w-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Thu, 19 May 2022 15:11:12 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Thu, 19 May 2022 15:11:12 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Paolo Abeni' <pabeni@redhat.com>,
        'Pavan Chebbi' <pavan.chebbi@broadcom.com>
CC:     Michael Chan <michael.chan@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mchan@broadcom.com" <mchan@broadcom.com>,
        "David Miller" <davem@davemloft.net>
Subject: RE: tg3 dropping packets at high packet rates
Thread-Topic: tg3 dropping packets at high packet rates
Thread-Index: AdhqyKyabzDEQq15SKKGm31SHwTbKwAC24IAAAoYsMAABXOQgAASBiKAAAHW4wAABHST0AACH9sAAAKZZrA=
Date:   Thu, 19 May 2022 14:11:12 +0000
Message-ID: <f8ff0598961146f28e2d186882928390@AcuMS.aculab.com>
References: <70a20d8f91664412ae91e401391e17cb@AcuMS.aculab.com>
         <6576c307ed554adb443e62a60f099266c95b55a7.camel@redhat.com>
         <153739175cf241a5895e6a5685a89598@AcuMS.aculab.com>
         <CACKFLinwh=YgPGPZ0M0dTJK1ar+SoPUZtYb5nBmLj6CNPdCQ2g@mail.gmail.com>
         <13d6579e9bc44dc2bfb73de8d9715b10@AcuMS.aculab.com>
         <CALs4sv1RxAbVid2f8EQF_kQkk48fd=8kcz2WbkTXRkwLbPLgwA@mail.gmail.com>
         <f3d1d5bf11144b31b1b3959e95b04490@AcuMS.aculab.com>
 <5cc5353c518e27de69fc0d832294634c83f431e5.camel@redhat.com>
In-Reply-To: <5cc5353c518e27de69fc0d832294634c83f431e5.camel@redhat.com>
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

RnJvbTogUGFvbG8gQWJlbmkNCj4gU2VudDogMTkgTWF5IDIwMjIgMTQ6MjkNCi4uLi4NCj4gSWYg
dGhlIHBhY2tldCBwcm9jZXNzaW5nIGlzICdidXJzdHknLCB5b3UgY2FuIGhhdmUgaWRsZSB0aW1l
IGFuZCBzdGlsbA0KPiBoaXQgbm93IGFuZCB0aGUgJ3J4IHJpbmcgaXMgW2FsbW9zdF0gZnVsbCcg
Y29uZGl0aW9uLiBJZiBwYXVzZSBmcmFtZXMNCj4gYXJlIGVuYWJsZWQsIHRoYXQgd2lsbCBjYXVz
ZSB0aGUgcGVlciB0byBzdG9wIHNlbmRpbmcgZnJhbWVzOiBkcm9wIGNhbg0KPiBoYXBwZW4gaW4g
dGhlIHN3aXRjaCwgYW5kIHRoZSBsb2NhbCBOSUMgd2lsbCBub3Qgbm90aWNlICh1bmxlc3MgdGhl
cmUNCj4gYXJlIGNvdW50ZXJzIGF2YWlhbGJsZSBmb3IgcGF1c2UgZnJhbWVzIHNlbnQpLg0KDQpU
aGUgdGVzdCBwcm9ncmFtIHNlbmRpbmcgdGhlIGRhdGEgZG9lcyBzcHJlYWQgaXQgb3V0Lg0KU28g
aXQgaXNuJ3Qgc2VuZGluZyAyMDAwIHBhY2tldHMgd2l0aCBtaW5pbWFsIElQRyBldmVyeSAxMG1z
Lg0KKEknbSBzZW5kaW5nIGZyb20gMiBzeXN0ZW1zLikNCg0KSSBkb24ndCBrbm93IGlmIHBhdXNl
IGZyYW1lcyBhcmUgZW5hYmxlZCAoZXRodG9vbCBtaWdodCBzdWdnZXN0IHRoZXkgYXJlKS4NCkJ1
dCBkZXRlY3Rpbmcgd2hldGhlciB0aGV5IGFyZSBzZW50IGlzIGFub3RoZXIgbWF0dGVyLg0KDQpJ
biBhbnkgY2FzZSBzZW5kaW5nIHBhdXNlIGZyYW1lcyBkb2Vzbid0IGZpeCBhbnl0aGluZy4NClRo
ZXkgYXJlIGxhcmdlbHkgZW50aXJlbHkgdXNlbGVzcyB1bmxlc3MgeW91IGhhdmUgYSBjYWJsZQ0K
dGhhdCBkaXJlY3RseSBjb25uZWN0cyB0d28gY29tcHV0ZXJzLg0KDQo+IEFGQUlDUyB0aGUgcGFj
a2V0IHByb2Nlc3NpbmcgaXMgYnVyc3R5LCBiZWNhdXNlIGVucXVldWluZyBwYWNrZXRzIHRvIGEN
Cj4gcmVtb3RlIENQVSBpbiBjb25zaWRlcmFibHkgZmFzdGVyIHRoZW4gZnVsbCBuZXR3b3JrIHN0
YWNrIHByb2Nlc3NpbmcuDQoNCkkgaGF2ZSB0YWtlbiByZXN0cmljdGVkIGZ0cmFjZSB0cmFjZXMg
b2YgdGhlIHJlY2VpdmluZyBzeXN0ZW0uDQpOb3Qgb2Z0ZW4gc2VlbiBtb3JlIHRoYW4gNCBmcmFt
ZXMgcHJvY2Vzc2VkIGluIG9uZSBuYXBpIGNhbGxiYWNrDQpDZXJ0YWlubHkgZGlkbid0IHNwb3Qg
YmxvY2tzIG9mIDEwMCsgdGhhdCB5b3UgbWlnaHQgZXhwZWN0DQp0byBzZWUgaWYgdGhlIGRyaXZl
ciBjb2RlIHdhcyB0aGUgYm90dGxlbmVjay4NCg0KPiBTaWRlIG5vdGU6IG9uIGEgbm90LXRvLW9i
c29sZXRlIEgvVyB0aGUga2VybmVsIHNob3VsZCBiZSBhYmxlIHRvDQo+IHByb2Nlc3MgPjFtcHBz
IHBlciBjcHUuDQoNClllcywgYW5kLCBJSVJDLCBhIDMzTWh6IDQ4NiBjYW4gc2F0dXJhdGUgMTBN
SHogZXRoZXJuZXQgd2l0aA0Kc21hbGwgcGFja2V0cy4NCg0KSW4gdGhpcyBjYXNlIHRoZSBjcHUg
YXJlIGFsbW9zdCB0d2lkZGxpbmcgdGhlaXIgdGh1bWJzLg0KICBtb2RlbCBuYW1lICAgICAgOiBJ
bnRlbChSKSBYZW9uKFIpIENQVSBFNS0yNjUwIHYzIEAgMi4zMEdIeg0KICBzdGVwcGluZyAgICAg
ICAgOiAyDQogIG1pY3JvY29kZSAgICAgICA6IDB4NDMNCiAgY3B1IE1IeiAgICAgICAgIDogMTMw
MC4wMDANCmNwdSAxNCAodGhlIG9uZSB0YWtpbmcgdGhlIGludGVycnVwdHMpIGlzIHJ1bm5pbmcg
YXQgZnVsbCBzcGVlZC4NCg0KY3B1IGRvZXNuJ3Qgc2VlbSB0byBiZSB0aGUgYm90dGxlbmVjay4N
ClRoZSBwcm9ibGVtIHNlZW1zIHRvIGJlIHRoZSBoYXJkd2FyZSBub3QgdXNpbmcgYWxsIHRoZSBi
dWZmZXJzDQppdCBoYXMgYmVlbiBnaXZlbi4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRk
cmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBN
SzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

