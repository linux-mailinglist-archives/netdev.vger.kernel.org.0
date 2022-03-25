Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8361C4E7CCA
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbiCYVmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 17:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233534AbiCYVmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 17:42:04 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC2CF6E8EE
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 14:40:25 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-198-v6S2T8p_MaetwOyqgJM0fQ-1; Fri, 25 Mar 2022 21:40:22 +0000
X-MC-Unique: v6S2T8p_MaetwOyqgJM0fQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Fri, 25 Mar 2022 21:40:20 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Fri, 25 Mar 2022 21:40:20 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Johannes Berg' <johannes@sipsolutions.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
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
Thread-Index: AQHYQI1aK/9JYQDqEEKfLChLw6SC36zQnHkQ
Date:   Fri, 25 Mar 2022 21:40:20 +0000
Message-ID: <19b4ad5f9909446ea0eca93f9b5b4c40@AcuMS.aculab.com>
References: <1812355.tdWV9SEqCh@natalenko.name>
         <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
         <20220324055732.GB12078@lst.de> <4386660.LvFx2qVVIh@natalenko.name>
         <81ffc753-72aa-6327-b87b-3f11915f2549@arm.com>
 <878rsza0ih.fsf@toke.dk>
         <4be26f5d8725cdb016c6fdd9d05cfeb69cdd9e09.camel@freebox.fr>
         <20220324163132.GB26098@lst.de>
         <d8a1cbf4-a521-78ec-1560-28d855e0913e@arm.com>
 <871qyr9t4e.fsf@toke.dk>
         <CAHk-=whUQCCaQXJt3KUeQ8mtnLeVXEScNXCp+_DYh2SNY7EcEA@mail.gmail.com>
         <31434708dcad126a8334c99ee056dcce93e507f1.camel@freebox.fr>
         <CAHk-=wippum+MksdY7ixMfa3i1sZ+nxYPWLLpVMNyXCgmiHbBQ@mail.gmail.com>
         <298f4f9ccad7c3308d3a1fd8b4b4740571305204.camel@sipsolutions.net>
         <CAHk-=whXAan2ExANMryPSFaBWeyzikPi+fPUseMoVhQAxR7cEA@mail.gmail.com>
 <e42e4c8bf35b62c671ec20ec6c21a43216e7daa6.camel@sipsolutions.net>
In-Reply-To: <e42e4c8bf35b62c671ec20ec6c21a43216e7daa6.camel@sipsolutions.net>
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

SSd2ZSBiZWVuIHRoaW5raW5nIG9mIHRoZSBjYXNlIHdoZXJlIGEgZGVzY3JpcHRvciByaW5nIGhh
cw0KdG8gYmUgaW4gbm9uLWNvaGVyZW50IG1lbW9yeSAoZWcgYmVjYXVzZSB0aGF0IGlzIGFsbCB0
aGVyZSBpcykuDQoNClRoZSByZWNlaXZlIHJpbmcgcHJvY2Vzc2luZyBpc24ndCBhY3R1YWxseSB0
aGF0IGRpZmZpY3VsdC4NCg0KVGhlIGRyaXZlciBoYXMgdG8gZmlsbCBhIGNhY2hlIGxpbmUgZnVs
bCBvZiBuZXcgYnVmZmVyDQpkZXNjcmlwdG9ycyBpbiBtZW1vcnkgYnV0IHdpdGhvdXQgYXNzaWdu
aW5nIHRoZSBmaXJzdA0KYnVmZmVyIHRvIHRoZSBoYXJkd2FyZS4NClRoZW4gaXQgaGFzIHRvIGRv
IGEgY2FjaGUgbGluZSB3cml0ZSBvZiBqdXN0IHRoYXQgbGluZS4NClRoZW4gaXQgY2FuIGFzc2ln
biBvd25lcnNoaXAgb2YgdGhlIGZpcnN0IGJ1ZmZlciBhbmQNCmZpbmFsbHkgZG8gYSBzZWNvbmQg
Y2FjaGUgbGluZSB3cml0ZS4NCihUaGUgZmlyc3QgZXhwbGljaXQgd3JpdGUgY2FuIGJlIHNraXBw
ZWQgaWYgdGhlIGNhY2hlDQp3cml0ZXMgYXJlIGtub3duIHRvIGJlIGF0b21pYy4pDQpJdCB0aGVu
IG11c3Qgbm90IGRpcnR5IHRoYXQgY2FjaGUgbGluZS4NCg0KVG8gY2hlY2sgZm9yIG5ldyBmcmFt
ZXMgaXQgbXVzdCBpbnZhbGlkYXRlIHRoZSBjYWNoZQ0KbGluZSB0aGF0IGNvbnRhaW5zIHRoZSAn
bmV4dCB0byBiZSBmaWxsZWQnIGRlc2NyaXB0b3INCmFuZCB0aGVuIHJlYWQgdGhhdCBjYWNoZSBs
aW5lLg0KVGhpcyB3aWxsIGNvbnRhaW4gaW5mbyBhYm91dCBvbmUgb3IgbW9yZSByZWNlaXZlIGZy
YW1lcy4NCkJ1dCB0aGUgaGFyZHdhcmUgaXMgc3RpbGwgZG9pbmcgdXBkYXRlcy4NCg0KQnV0IGJv
dGggdGhlc2Ugb3BlcmF0aW9ucyBjYW4gYmUgaGFwcGVuaW5nIGF0IHRoZSBzYW1lDQp0aW1lIG9u
IGRpZmZlcmVudCBwYXJ0cyBvZiB0aGUgYnVmZmVyLg0KDQpTbyB5b3UgbmVlZCB0byBrbm93IGEg
J2NhY2hlIGxpbmUgc2l6ZScgZm9yIHRoZSBtYXBwaW5nDQphbmQgYmUgYWJsZSB0byBkbyB3cml0
ZWJhY2tzIGFuZCBpbnZhbGlkYXRlcyBmb3IgcGFydHMNCm9mIHRoZSBidWZmZXIsIG5vdCBqdXN0
IGFsbCBvZiBpdC4NCg0KVGhlIHRyYW5zbWl0IHNpZGUgaXMgaGFyZGVyLg0KSXQgZWl0aGVyIHJl
cXVpcmVzIHdhaXRpbmcgZm9yIGFsbCBwZW5kaW5nIHRyYW5zbWl0cyB0bw0KZmluaXNoIG9yIHNw
bGl0dGluZyBhIHNpbmdsZSB0cmFuc21pdCBpbnRvIGVub3VnaCBmcmFnbWVudHMNCnRoYXQgaXRz
IGRlc2NyaXB0b3JzIGVuZCBvbiBhIGNhY2hlIGxpbmUgYm91bmRhcnkuDQpCdXQgYWdhaW4sIGFu
ZCBpZiB0aGUgaW50ZXJmYWNlIGlzIGJ1c3ksIHlvdSB3YW50IHRoZSBjcHUNCnRvIGJlIGFibGUg
dG8gdXBkYXRlIG9uZSBjYWNoZSBsaW5lIG9mIHRyYW5zbWl0IGRlc2NyaXB0b3JzDQp3aGlsZSB0
aGUgZGV2aWNlIGlzIHdyaXRpbmcgdHJhbnNtaXQgY29tcGxldGlvbiBzdGF0dXMNCnRvIHRoZSBw
cmV2aW91cyBjYWNoZSBsaW5lLg0KDQpJIGRvbid0IHRoaW5rIHRoYXQgaXMgbWF0ZXJpYWxseSBk
aWZmZXJlbnQgZm9yIG5vbi1jb2hlcmVudA0KbWVtb3J5IG9yIGJvdW5jZSBidWZmZXJzLg0KQnV0
IHBhcnRpYWwgZmx1c2gvaW52YWxpZGF0ZSBpcyBuZWVkZWQuDQoNCglEYXZpZA0KDQotDQpSZWdp
c3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9u
IEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

