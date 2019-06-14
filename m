Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 068CC46267
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 17:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfFNPQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 11:16:47 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:32325 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726567AbfFNPQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 11:16:46 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-68-X-FdWeQ3PqmiCOAg4_EgNg-1; Fri, 14 Jun 2019 16:16:44 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 14 Jun 2019 16:16:43 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 14 Jun 2019 16:16:43 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Robin Murphy' <robin.murphy@arm.com>,
        'Christoph Hellwig' <hch@lst.de>
CC:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sean Paul <sean@poorly.run>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: RE: [PATCH 16/16] dma-mapping: use exact allocation in
 dma_alloc_contiguous
Thread-Topic: [PATCH 16/16] dma-mapping: use exact allocation in
 dma_alloc_contiguous
Thread-Index: AQHVIrfpTFjppS25RkWUhwqPPyqZ4qabLzdwgAAQm/2AAAIJEA==
Date:   Fri, 14 Jun 2019 15:16:43 +0000
Message-ID: <d8009432a10549bbbda802021562a28b@AcuMS.aculab.com>
References: <20190614134726.3827-1-hch@lst.de>
 <20190614134726.3827-17-hch@lst.de>
 <a90cf7ec5f1c4166b53c40e06d4d832a@AcuMS.aculab.com>
 <20190614145001.GB9088@lst.de> <4113cd5f-5c13-e9c7-bc5e-dcf0b60e7054@arm.com>
In-Reply-To: <4113cd5f-5c13-e9c7-bc5e-dcf0b60e7054@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: X-FdWeQ3PqmiCOAg4_EgNg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUm9iaW4gTXVycGh5DQo+IFNlbnQ6IDE0IEp1bmUgMjAxOSAxNjowNg0KLi4uDQo+IFdl
bGwsIGFwYXJ0IGZyb20gdGhlIGJpdCBpbiBETUEtQVBJLUhPV1RPIHdoaWNoIGhhcyBzYWlkIHRo
aXMgc2luY2UNCj4gZm9yZXZlciAod2VsbCwgYmVmb3JlIEdpdCBoaXN0b3J5LCBhdCBsZWFzdCk6
DQo+IA0KPiAiVGhlIENQVSB2aXJ0dWFsIGFkZHJlc3MgYW5kIHRoZSBETUEgYWRkcmVzcyBhcmUg
Ym90aA0KPiBndWFyYW50ZWVkIHRvIGJlIGFsaWduZWQgdG8gdGhlIHNtYWxsZXN0IFBBR0VfU0la
RSBvcmRlciB3aGljaA0KPiBpcyBncmVhdGVyIHRoYW4gb3IgZXF1YWwgdG8gdGhlIHJlcXVlc3Rl
ZCBzaXplLiAgVGhpcyBpbnZhcmlhbnQNCj4gZXhpc3RzIChmb3IgZXhhbXBsZSkgdG8gZ3VhcmFu
dGVlIHRoYXQgaWYgeW91IGFsbG9jYXRlIGEgY2h1bmsNCj4gd2hpY2ggaXMgc21hbGxlciB0aGFu
IG9yIGVxdWFsIHRvIDY0IGtpbG9ieXRlcywgdGhlIGV4dGVudCBvZiB0aGUNCj4gYnVmZmVyIHlv
dSByZWNlaXZlIHdpbGwgbm90IGNyb3NzIGEgNjRLIGJvdW5kYXJ5LiINCg0KSSBrbmV3IGl0IHdh
cyBzb21ld2hlcmUgOi0pDQpJbnRlcmVzdGluZ2x5IHRoYXQgYWxzbyBpbXBsaWVzIHRoYXQgdGhl
IGFkZHJlc3MgcmV0dXJuZWQgZm9yIGEgc2l6ZQ0Kb2YgKHNheSkgMTI4IHdpbGwgYWxzbyBiZSBw
YWdlIGFsaWduZWQuDQpJbiB0aGF0IGNhc2UgMTI4IGJ5dGUgYWxpZ25tZW50IHNob3VsZCBwcm9i
YWJseSBiZSBvayAtIGJ1dCBpdCBpcyBzdGlsbA0KYW4gQVBJIGNoYW5nZSB0aGF0IGNvdWxkIGhh
dmUgaG9ycmlkIGNvbnNlcXVlbmNlcy4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVz
cyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEg
MVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

