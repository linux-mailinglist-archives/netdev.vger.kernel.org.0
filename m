Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309A5365452
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 10:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbhDTIk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 04:40:28 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:34844 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231136AbhDTIk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 04:40:26 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-41-LdMxTme-MY-UX7jiXf2mLw-1; Tue, 20 Apr 2021 09:39:52 +0100
X-MC-Unique: LdMxTme-MY-UX7jiXf2mLw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Tue, 20 Apr 2021 09:39:51 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.015; Tue, 20 Apr 2021 09:39:51 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Geert Uytterhoeven' <geert@linux-m68k.org>,
        Matthew Wilcox <willy@infradead.org>
CC:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, netdev <netdev@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "mcroce@linux.microsoft.com" <mcroce@linux.microsoft.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Arnd Bergmann <arnd@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        arcml <linux-snps-arc@lists.infradead.org>,
        Michal Hocko <mhocko@kernel.org>,
        "Mel Gorman" <mgorman@suse.de>
Subject: RE: [PATCH 1/2] mm: Fix struct page layout on 32-bit systems
Thread-Topic: [PATCH 1/2] mm: Fix struct page layout on 32-bit systems
Thread-Index: AQHXNbhaf1yRrc3ugkWz9MvyD1ZvgKq9FGTg
Date:   Tue, 20 Apr 2021 08:39:51 +0000
Message-ID: <bb8805a33371468892a7271dbe321e1f@AcuMS.aculab.com>
References: <20210416230724.2519198-1-willy@infradead.org>
 <20210416230724.2519198-2-willy@infradead.org>
 <20210417024522.GP2531743@casper.infradead.org>
 <CAMuHMdXm1Zg=Wm-=tn5jUJwqVGUvCi5yDaW0PXWC2DEDYGcy5A@mail.gmail.com>
In-Reply-To: <CAMuHMdXm1Zg=Wm-=tn5jUJwqVGUvCi5yDaW0PXWC2DEDYGcy5A@mail.gmail.com>
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogR2VlcnQgVXl0dGVyaG9ldmVuDQo+IFNlbnQ6IDIwIEFwcmlsIDIwMjEgMDg6NDANCj4g
DQo+IEhpIFdpbGx5LA0KPiANCj4gT24gU2F0LCBBcHIgMTcsIDIwMjEgYXQgNDo0OSBBTSBNYXR0
aGV3IFdpbGNveCA8d2lsbHlAaW5mcmFkZWFkLm9yZz4gd3JvdGU6DQo+ID4gUmVwbGFjZW1lbnQg
cGF0Y2ggdG8gZml4IGNvbXBpbGVyIHdhcm5pbmcuDQo+ID4NCj4gPiAzMi1iaXQgYXJjaGl0ZWN0
dXJlcyB3aGljaCBleHBlY3QgOC1ieXRlIGFsaWdubWVudCBmb3IgOC1ieXRlIGludGVnZXJzDQo+
ID4gYW5kIG5lZWQgNjQtYml0IERNQSBhZGRyZXNzZXMgKGFyYywgYXJtLCBtaXBzLCBwcGMpIGhh
ZCB0aGVpciBzdHJ1Y3QNCj4gPiBwYWdlIGluYWR2ZXJ0ZW50bHkgZXhwYW5kZWQgaW4gMjAxOS4g
IFdoZW4gdGhlIGRtYV9hZGRyX3Qgd2FzIGFkZGVkLA0KPiA+IGl0IGZvcmNlZCB0aGUgYWxpZ25t
ZW50IG9mIHRoZSB1bmlvbiB0byA4IGJ5dGVzLCB3aGljaCBpbnNlcnRlZCBhIDQgYnl0ZQ0KPiA+
IGdhcCBiZXR3ZWVuICdmbGFncycgYW5kIHRoZSB1bmlvbi4NCj4gPg0KPiA+IEZpeCB0aGlzIGJ5
IHN0b3JpbmcgdGhlIGRtYV9hZGRyX3QgaW4gb25lIG9yIHR3byBhZGphY2VudCB1bnNpZ25lZCBs
b25ncy4NCj4gPiBUaGlzIHJlc3RvcmVzIHRoZSBhbGlnbm1lbnQgdG8gdGhhdCBvZiBhbiB1bnNp
Z25lZCBsb25nLCBhbmQgYWxzbyBmaXhlcyBhDQo+ID4gcG90ZW50aWFsIHByb2JsZW0gd2hlcmUg
KG9uIGEgYmlnIGVuZGlhbiBwbGF0Zm9ybSksIHRoZSBiaXQgdXNlZCB0byBkZW5vdGUNCj4gPiBQ
YWdlVGFpbCBjb3VsZCBpbmFkdmVydGVudGx5IGdldCBzZXQsIGFuZCBhIHJhY2luZyBnZXRfdXNl
cl9wYWdlc19mYXN0KCkNCj4gPiBjb3VsZCBkZXJlZmVyZW5jZSBhIGJvZ3VzIGNvbXBvdW5kX2hl
YWQoKS4NCj4gPg0KPiA+IEZpeGVzOiBjMjVmZmY3MTcxYmUgKCJtbTogYWRkIGRtYV9hZGRyX3Qg
dG8gc3RydWN0IHBhZ2UiKQ0KPiA+IFNpZ25lZC1vZmYtYnk6IE1hdHRoZXcgV2lsY294IChPcmFj
bGUpIDx3aWxseUBpbmZyYWRlYWQub3JnPg0KPiANCj4gVGhhbmtzIGZvciB5b3VyIHBhdGNoIQ0K
PiANCj4gPiAtLS0gYS9pbmNsdWRlL2xpbnV4L21tX3R5cGVzLmgNCj4gPiArKysgYi9pbmNsdWRl
L2xpbnV4L21tX3R5cGVzLmgNCj4gPiBAQCAtOTcsMTAgKzk3LDEwIEBAIHN0cnVjdCBwYWdlIHsN
Cj4gPiAgICAgICAgICAgICAgICAgfTsNCj4gPiAgICAgICAgICAgICAgICAgc3RydWN0IHsgICAg
ICAgIC8qIHBhZ2VfcG9vbCB1c2VkIGJ5IG5ldHN0YWNrICovDQo+ID4gICAgICAgICAgICAgICAg
ICAgICAgICAgLyoqDQo+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgICogQGRtYV9hZGRyOiBt
aWdodCByZXF1aXJlIGEgNjQtYml0IHZhbHVlIGV2ZW4gb24NCj4gPiArICAgICAgICAgICAgICAg
ICAgICAgICAgKiBAZG1hX2FkZHI6IG1pZ2h0IHJlcXVpcmUgYSA2NC1iaXQgdmFsdWUgb24NCj4g
PiAgICAgICAgICAgICAgICAgICAgICAgICAgKiAzMi1iaXQgYXJjaGl0ZWN0dXJlcy4NCj4gPiAg
ICAgICAgICAgICAgICAgICAgICAgICAgKi8NCj4gPiAtICAgICAgICAgICAgICAgICAgICAgICBk
bWFfYWRkcl90IGRtYV9hZGRyOw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIHVuc2lnbmVk
IGxvbmcgZG1hX2FkZHJbMl07DQo+IA0KPiBTbyB3ZSBnZXQgdHdvIDY0LWJpdCB3b3JkcyBvbiA2
NC1iaXQgcGxhdGZvcm1zLCB3aGlsZSBvbmx5IG9uZSBpcw0KPiBuZWVkZWQ/DQo+IA0KPiBXb3Vs
ZA0KPiANCj4gICAgIHVuc2lnbmVkIGxvbmcgX2RtYV9hZGRyW3NpemVvZihkbWFfYWRkcl90KSAv
IHNpemVvZih1bnNpZ25lZCBsb25nKV07DQo+IA0KPiB3b3JrPw0KPiANCj4gT3Igd2lsbCB0aGUg
Y29tcGlsZXIgYmVjb21lIHRvbyBvdmVyemVhbG91cywgYW5kIHdhcm4gYWJvdXQgdGhlIHVzZQ0K
PiBvZiAuLi5bMV0gYmVsb3csIGV2ZW4gd2hlbiB1bnJlYWNoYWJsZT8NCj4gSSB3b3VsZG4ndCBt
aW5kIGFuICNpZmRlZiBpbnN0ZWFkIG9mIGFuIGlmICgpIGluIHRoZSBjb2RlIGJlbG93LCB0aG91
Z2guDQoNCllvdSBjb3VsZCB1c2UgW0FSUkFZX1NJWkUoKS0xXSBpbnN0ZWFkIG9mIFsxXS4NCk9y
LCBzaW5jZSBJSVJDIGl0IGlzIHRoZSBsYXN0IG1lbWJlciBvZiB0aGF0IHNwZWNpZmljIHN0cnVj
dCwgZGVmaW5lIGFzOg0KCQl1bnNpZ25lZCBsb25nIGRtYV9hZGRyW107DQoNCi4uLg0KPiA+IC0g
ICAgICAgcmV0dXJuIHBhZ2UtPmRtYV9hZGRyOw0KPiA+ICsgICAgICAgZG1hX2FkZHJfdCByZXQg
PSBwYWdlLT5kbWFfYWRkclswXTsNCj4gPiArICAgICAgIGlmIChzaXplb2YoZG1hX2FkZHJfdCkg
PiBzaXplb2YodW5zaWduZWQgbG9uZykpDQo+ID4gKyAgICAgICAgICAgICAgIHJldCB8PSAoZG1h
X2FkZHJfdClwYWdlLT5kbWFfYWRkclsxXSA8PCAxNiA8PCAxNjsNCj4gDQo+IFdlIGRvbid0IHNl
ZW0gdG8gaGF2ZSBhIGhhbmR5IG1hY3JvIGZvciBhIDMyLWJpdCBsZWZ0IHNoaWZ0IHlldC4uLg0K
PiANCj4gQnV0IHlvdSBjYW4gYWxzbyBhdm9pZCB0aGUgd2FybmluZyB1c2luZw0KPiANCj4gICAg
IHJldCB8PSAodTY0KXBhZ2UtPmRtYV9hZGRyWzFdIDw8IDMyOw0KDQpPcjoNCglyZXQgfD0gcGFn
ZS0+ZG1hX2FkZHJbMV0gKyAwdWxsIDw8IDMyOw0KDQpXaGljaCByZWxpZXMgaW4gaW50ZWdlciBw
cm9tb3Rpb24gcmF0aGVyIHRoYW4gYSBjYXN0Lg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBB
ZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMs
IE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

