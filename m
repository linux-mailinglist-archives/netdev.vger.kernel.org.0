Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8303A4E886C
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 17:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235849AbiC0P0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 11:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235056AbiC0P0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 11:26:34 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 182D2140C9
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 08:24:54 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-160-sYhtiCskO1qRFgnKRoKrFA-1; Sun, 27 Mar 2022 16:24:51 +0100
X-MC-Unique: sYhtiCskO1qRFgnKRoKrFA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Sun, 27 Mar 2022 16:24:48 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Sun, 27 Mar 2022 16:24:48 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Linus Torvalds' <torvalds@linux-foundation.org>,
        Halil Pasic <pasic@linux.ibm.com>
CC:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Maxime Bizon <mbizon@freebox.fr>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        "Marek Szyprowski" <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Olha Cherevyk <olha.cherevyk@gmail.com>,
        iommu <iommu@lists.linux-foundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Subject: RE: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
Thread-Topic: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
Thread-Index: AQHYQZpzK/9JYQDqEEKfLChLw6SC36zTVWUA
Date:   Sun, 27 Mar 2022 15:24:48 +0000
Message-ID: <0745b44456d44d1e9fc364e5a3780d9a@AcuMS.aculab.com>
References: <1812355.tdWV9SEqCh@natalenko.name>
 <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
 <20220324055732.GB12078@lst.de> <4386660.LvFx2qVVIh@natalenko.name>
 <81ffc753-72aa-6327-b87b-3f11915f2549@arm.com> <878rsza0ih.fsf@toke.dk>
 <4be26f5d8725cdb016c6fdd9d05cfeb69cdd9e09.camel@freebox.fr>
 <20220324163132.GB26098@lst.de>
 <d8a1cbf4-a521-78ec-1560-28d855e0913e@arm.com> <871qyr9t4e.fsf@toke.dk>
 <CAHk-=whUQCCaQXJt3KUeQ8mtnLeVXEScNXCp+_DYh2SNY7EcEA@mail.gmail.com>
 <20220327054848.1a545b12.pasic@linux.ibm.com>
 <CAHk-=whUJ=tMEgP3KiWwk0pzmHn+1QORUu50syE+zOGk4UnFog@mail.gmail.com>
 <CAHk-=wgUx5CVF_1aEkhhEiRGXHgKzUdKiyctBKcHAxkxPpbiaw@mail.gmail.com>
In-Reply-To: <CAHk-=wgUx5CVF_1aEkhhEiRGXHgKzUdKiyctBKcHAxkxPpbiaw@mail.gmail.com>
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
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogTGludXMgVG9ydmFsZHMNCj4gU2VudDogMjcgTWFyY2ggMjAyMiAwNjoyMQ0KPiANCj4g
T24gU2F0LCBNYXIgMjYsIDIwMjIgYXQgMTA6MDYgUE0gTGludXMgVG9ydmFsZHMNCj4gPHRvcnZh
bGRzQGxpbnV4LWZvdW5kYXRpb24ub3JnPiB3cm90ZToNCj4gPg0KPiA+IE9uIFNhdCwgTWFyIDI2
LCAyMDIyIGF0IDg6NDkgUE0gSGFsaWwgUGFzaWMgPHBhc2ljQGxpbnV4LmlibS5jb20+IHdyb3Rl
Og0KPiA+ID4NCj4gPiA+IEkgYWdyZWUgaXQgQ1BVIG1vZGlmaWVkIGJ1ZmZlcnMgKmNvbmN1cnJl
bnRseSogd2l0aCBETUEgY2FuIG5ldmVyIHdvcmssDQo+ID4gPiBhbmQgSSBiZWxpZXZlIHRoZSBv
d25lcnNoaXAgbW9kZWwgd2FzIGNvbmNlaXZlZCB0byBwcmV2ZW50IHRoaXMNCj4gPiA+IHNpdHVh
dGlvbi4NCj4gPg0KPiA+IEJ1dCB0aGF0IGp1c3QgbWVhbnMgdGhhdCB0aGUgIm93bmVyc2hpcCIg
bW9kZWwgaXMgZ2FyYmFnZSwgYW5kIGNhbm5vdA0KPiA+IGhhbmRsZSB0aGlzIFJFQUwgTElGRSBz
aXR1YXRpb24uDQo+IA0KPiBKdXN0IHRvIGNsYXJpZnk6IEkgb2J2aW91c2x5IGFncmVlIHRoYXQg
dGhlICJib3RoIHNpZGVzIG1vZGlmeQ0KPiBjb25jdXJyZW50bHkiIG9idmlvdXNseSBjYW5ub3Qg
d29yayB3aXRoIGJvdW5jZSBidWZmZXJzLg0KDQpBcmVuJ3QgYm91bmNlIGJ1ZmZlcnMganVzdCBh
IG1vcmUgZXh0cmVtZSBjYXNlIG9uIG5vbi1jb2hlcmVudA0KbWVtb3J5IGFjY2Vzc2VzPw0KVGhl
eSBqdXN0IG5lZWQgZXhwbGljaXQgbWVtb3J5IGNvcGllcyByYXRoZXIgdGhhbiBqdXN0IGNhY2hl
DQp3cml0ZWJhY2sgYW5kIGludmFsaWRhdGUgb3BlcmF0aW9ucy4NCg0KU28gJ2JvdGggc2lkZXMg
bW9kaWZ5IGNvbmN1cnJlbnRseScganVzdCBoYXMgdGhlIHNhbWUgaXNzdWUNCmFzIGl0IGRvZXMg
d2l0aCBub24tY29oZXJlbnQgbWVtb3J5IGluIHRoYXQgdGhlIGxvY2F0aW9ucw0KbmVlZCB0byBi
ZSBpbiBzZXBhcmF0ZSAoZG1hKSBjYWNoZSBsaW5lcy4NCkluZGVlZCwgaWYgdGhlIGJvdW5jZSBi
dWZmZXJzIGFyZSBhY3R1YWxseSBjb2hlcmVudCB0aGVuDQphcmJpdHJhcnkgY29uY3VycmVudCB1
cGRhdGVzIGFyZSBwb3NzaWJsZS4NCg0KT25lIGlzc3VlIGlzIHRoYXQgdGhlIGRyaXZlciBuZWVk
cyB0byBpbmRpY2F0ZSB3aGljaCBwYXJ0cw0Kb2YgYW55IGJ1ZmZlciBhcmUgZGlydHkuDQpXaGVy
ZWFzIHRoZSBhbnkgJ2NhY2hlIHdyaXRlYmFjaycgcmVxdWVzdCB3aWxsIG9ubHkgd3JpdGUNCmRp
cnR5IGRhdGEuDQoNCkdldCBldmVyeXRoaW5nIHJpZ2h0IGFuZCB5b3UgY2FuIGV2ZW4gc3VwcG9y
dCBoYXJkd2FyZSB3aGVyZQ0KdGhlICdib3VuY2UgYnVmZmVycycgYXJlIGFjdHVhbGx5IG9uIHRo
ZSBjYXJkIGFuZCB0aGUgY29waWVzDQphcmUgTU1JTyAob3IgYmV0dGVyLCBlc3BlY2lhbGx5IG9u
IFBDSWUsIHN5bmNocm9ub3VzIGhvc3QNCmluaXRpYXRlZCBkbWEgdHJhbnNmZXJzKS4NCg0KCURh
dmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3Vu
dCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3
Mzg2IChXYWxlcykNCg==

