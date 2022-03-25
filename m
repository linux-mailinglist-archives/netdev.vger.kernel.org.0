Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFBF54E7B83
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233870AbiCYWmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 18:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233818AbiCYWmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 18:42:46 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3B755203A4A
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 15:41:06 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-132-bzPiuRSPOXqPuBduQ2feJg-1; Fri, 25 Mar 2022 22:41:04 +0000
X-MC-Unique: bzPiuRSPOXqPuBduQ2feJg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Fri, 25 Mar 2022 22:41:02 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Fri, 25 Mar 2022 22:41:01 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Linus Torvalds' <torvalds@linux-foundation.org>,
        Johannes Berg <johannes@sipsolutions.net>
CC:     Maxime Bizon <mbizon@freebox.fr>,
        =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Halil Pasic <pasic@linux.ibm.com>,
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
Thread-Index: AQHYQJM6K/9JYQDqEEKfLChLw6SC36zQrLFA
Date:   Fri, 25 Mar 2022 22:41:01 +0000
Message-ID: <273dec6267b249ca941558c268390fbc@AcuMS.aculab.com>
References: <1812355.tdWV9SEqCh@natalenko.name>
 <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
 <20220324055732.GB12078@lst.de> <4386660.LvFx2qVVIh@natalenko.name>
 <81ffc753-72aa-6327-b87b-3f11915f2549@arm.com> <878rsza0ih.fsf@toke.dk>
 <4be26f5d8725cdb016c6fdd9d05cfeb69cdd9e09.camel@freebox.fr>
 <20220324163132.GB26098@lst.de>
 <d8a1cbf4-a521-78ec-1560-28d855e0913e@arm.com> <871qyr9t4e.fsf@toke.dk>
 <CAHk-=whUQCCaQXJt3KUeQ8mtnLeVXEScNXCp+_DYh2SNY7EcEA@mail.gmail.com>
 <31434708dcad126a8334c99ee056dcce93e507f1.camel@freebox.fr>
 <CAHk-=wippum+MksdY7ixMfa3i1sZ+nxYPWLLpVMNyXCgmiHbBQ@mail.gmail.com>
 <298f4f9ccad7c3308d3a1fd8b4b4740571305204.camel@sipsolutions.net>
 <CAHk-=whXAan2ExANMryPSFaBWeyzikPi+fPUseMoVhQAxR7cEA@mail.gmail.com>
 <e42e4c8bf35b62c671ec20ec6c21a43216e7daa6.camel@sipsolutions.net>
 <CAHk-=wjJp5xCx0CCrLCzFGZyyABYSNNNa0i=4fN3fBydP7r97w@mail.gmail.com>
In-Reply-To: <CAHk-=wjJp5xCx0CCrLCzFGZyyABYSNNNa0i=4fN3fBydP7r97w@mail.gmail.com>
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

RnJvbTogTGludXMgVG9ydmFsZHMNCj4gU2VudDogMjUgTWFyY2ggMjAyMiAyMTo1Nw0KPiANCj4g
T24gRnJpLCBNYXIgMjUsIDIwMjIgYXQgMjoxMyBQTSBKb2hhbm5lcyBCZXJnIDxqb2hhbm5lc0Bz
aXBzb2x1dGlvbnMubmV0PiB3cm90ZToNCj4gPg0KPiA+IFdlbGwgSSBzZWUgbm93IHRoYXQgeW91
IHNhaWQgJ2NhY2hlICJ3cml0ZWJhY2siJyBpbiAoMSksIGFuZCAnZmx1c2gnIGluDQo+ID4gKDIp
LCBzbyBwZXJoYXBzIHlvdSB3ZXJlIHRoaW5raW5nIG9mIHRoZSBzYW1lLCBhbmQgSSdtIGp1c3Qg
Y2FsbGluZyBpdA0KPiA+ICJmbHVzaCIgYW5kICJpbnZhbGlkYXRlIiByZXNwZWN0aXZlbHk/DQo+
IA0KPiBZZWFoLCBzbyBJIG1lbnRhbGx5IHRlbmQgdG8gdGhpbmsgb2YgdGhlIG9wZXJhdGlvbnMg
YXMganVzdA0KPiAid3JpdGViYWNrIiAod2hpY2ggZG9lc24ndCBpbnZhbGlkYXRlKSBhbmQgImZs
dXNoIiAod2hpY2ggaXMgYQ0KPiB3cml0ZWJhY2staW52YWxpZGF0ZSkuDQoNCkl0IGFsbW9zdCBj
ZXJ0YWlubHkgZG9lc24ndCBtYXR0ZXIgd2hldGhlciB0aGUgIndyaXRlYmFjayINCmludmFsaWRh
dGVzIG9yIG5vdC4NCllvdSBoYXZlIHRvIGFzc3VtZSB0aGF0IGFsbCBzb3J0cyBvZiBvcGVyYXRp
b25zIG1pZ2h0IGNhdXNlDQp0aGUgY3B1IHRvIHJlYWQgaW4gYSBjYWNoZWxpbmUuDQpUaGlzIGlu
Y2x1ZGVzLCBidXQgaXMgbm90IGxpbWl0ZWQgdG8sIHNwZWN1bGF0aXZlIGV4ZWN1dGlvbg0KYW5k
IGNhY2hlIGxpbmUgcHJlZmV0Y2guDQoNCkJ1dCB5b3UgZGVmaW5pdGVseSBuZWVkIGFuICJpbnZh
bGlkYXRlIiB0byBmb3JjZSBhIGNhY2hlIGxpbmUNCmJlIHJlYWQgYWZ0ZXIgdGhlIGhhcmR3YXJl
IGhhcyBhY2Nlc3NlZCBpdC4NCk5vdyBzdWNoIGxpbmVzIG11c3Qgbm90IGJlIGRpcnR5OyBiZWNh
dXNlIHRoZSBjcHUgY2FuIHdyaXRlDQpiYWNrIGEgZGlydHkgY2FjaGUgbGluZSBhdCBhbnkgdGlt
ZSAtIHdoaWNoIHdvdWxkIGJyZWFrIHRoaW5ncy4NClNvIHRoaXMgY2FuIGFsc28gYmUgIndyaXRl
IGJhY2sgaWYgZGlydHkiIGFuZCAiaW52YWxpZGF0ZSIuDQoNCkJvdW5jZSBidWZmZXJzIGFuZCBj
YWNoZSBwcm9iYWJseSB3b3JrIG11Y2ggdGhlIHNhbWUgd2F5Lg0KQnV0IGZvciBib3VuY2UgYnVm
ZmVycyBJIGd1ZXNzIHlvdSB3YW50IHRvIGVuc3VyZSB0aGUgaW5pdGlhbGx5DQphbGxvY2F0ZWQg
YnVmZmVyIGRvZXNuJ3QgY29udGFpbiBvbGQgZGF0YSAoYmVsb25naW5nIHRvDQpzb21lb25lIGVs
c2UpLg0KU28geW91IG1pZ2h0IGRlY2lkZSB0byB6ZXJvIHRoZW0gb24gYWxsb2NhdGlvbiBvciBh
bHdheXMgY29weQ0KZnJvbSB0aGUgZHJpdmVyIGJ1ZmZlciBvbiB0aGUgZmlyc3QgcmVxdWVzdC4N
Cg0KVGhlbiB5b3UgZ2V0IHRoZSByZWFsbHkgYW5ub3lpbmcgY3B1IHRoYXQgZG9uJ3QgaGF2ZSBh
IA0KIndyaXRlIGJhY2sgZGlydHkgbGluZSBhbmQgaW52YWxpZGF0ZSIgb3Bjb2RlLg0KQW5kIHRo
ZSBvbmx5IHdheSBpcyB0byByZWFkIGVub3VnaCBvdGhlciBtZW1vcnkgYXJlYXMNCnRvIGRpc3Bs
YWNlIGFsbCB0aGUgZXhpc3RpbmcgY2FjaGUgbGluZSBkYXRhLg0KWW91IHByb2JhYmx5IG1pZ2h0
IGFzIHdlbGwgZ2l2ZSB1cCBhbmQgdXNlIFBJTyA6LSkNCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVy
ZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5
bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

