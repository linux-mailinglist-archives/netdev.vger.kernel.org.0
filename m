Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6868B4CBA42
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 10:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231989AbiCCJbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 04:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbiCCJbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 04:31:11 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 41D9416C4F8
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 01:30:24 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-318-HvTdrMxlM1W3jsGT6It_3A-1; Thu, 03 Mar 2022 09:30:16 +0000
X-MC-Unique: HvTdrMxlM1W3jsGT6It_3A-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Thu, 3 Mar 2022 09:30:14 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Thu, 3 Mar 2022 09:30:14 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Xiaomeng Tong' <xiam0nd.tong@gmail.com>
CC:     "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "bjohannesmeyer@gmail.com" <bjohannesmeyer@gmail.com>,
        "c.giuffrida@vu.nl" <c.giuffrida@vu.nl>,
        "christian.koenig@amd.com" <christian.koenig@amd.com>,
        "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "gustavo@embeddedor.com" <gustavo@embeddedor.com>,
        "h.j.bos@vu.nl" <h.j.bos@vu.nl>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "jakobkoschel@gmail.com" <jakobkoschel@gmail.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "kgdb-bugreport@lists.sourceforge.net" 
        <kgdb-bugreport@lists.sourceforge.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-f2fs-devel@lists.sourceforge.net" 
        <linux-f2fs-devel@lists.sourceforge.net>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux1394-devel@lists.sourceforge.net" 
        <linux1394-devel@lists.sourceforge.net>,
        "linux@rasmusvillemoes.dk" <linux@rasmusvillemoes.dk>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "v9fs-developer@lists.sourceforge.net" 
        <v9fs-developer@lists.sourceforge.net>
Subject: RE: [PATCH 2/6] treewide: remove using list iterator after loop body
 as a ptr
Thread-Topic: [PATCH 2/6] treewide: remove using list iterator after loop body
 as a ptr
Thread-Index: AQHYLhg9+DU/OogLf0+tiSFmjztyUKysHu+QgADRVYCAACVtoIAALj+AgAAE1XA=
Date:   Thu, 3 Mar 2022 09:30:14 +0000
Message-ID: <2d208771c50b4c6db4f43039e9d62851@AcuMS.aculab.com>
References: <39404befad5b44b385698ff65465abe5@AcuMS.aculab.com>
 <20220303072657.11124-1-xiam0nd.tong@gmail.com>
In-Reply-To: <20220303072657.11124-1-xiam0nd.tong@gmail.com>
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

RnJvbTogWGlhb21lbmcgVG9uZw0KPiBTZW50OiAwMyBNYXJjaCAyMDIyIDA3OjI3DQo+IA0KPiBP
biBUaHUsIDMgTWFyIDIwMjIgMDQ6NTg6MjMgKzAwMDAsIERhdmlkIExhaWdodCB3cm90ZToNCj4g
PiBvbiAzIE1hciAyMDIyIDEwOjI3OjI5ICswODAwLCBYaWFvbWVuZyBUb25nIHdyb3RlOg0KPiA+
ID4gVGhlIHByb2JsZW0gaXMgdGhlIG1pcy11c2Ugb2YgaXRlcmF0b3Igb3V0c2lkZSB0aGUgbG9v
cCBvbiBleGl0LCBhbmQNCj4gPiA+IHRoZSBpdGVyYXRvciB3aWxsIGJlIHRoZSBIRUFEJ3MgY29u
dGFpbmVyX29mIHBvaW50ZXIgd2hpY2ggcG9pbnRlcnMNCj4gPiA+IHRvIGEgdHlwZS1jb25mdXNl
ZCBzdHJ1Y3QuIFNpZGVub3RlOiBUaGUgKm1pcy11c2UqIGhlcmUgcmVmZXJzIHRvDQo+ID4gPiBt
aXN0YWtlbHkgYWNjZXNzIHRvIG90aGVyIG1lbWJlcnMgb2YgdGhlIHN0cnVjdCwgaW5zdGVhZCBv
ZiB0aGUNCj4gPiA+IGxpc3RfaGVhZCBtZW1iZXIgd2hpY2ggYWN1dGFsbHkgaXMgdGhlIHZhbGlk
IEhFQUQuDQo+ID4NCj4gPiBUaGUgcHJvYmxlbSBpcyB0aGF0IHRoZSBIRUFEJ3MgY29udGFpbmVy
X29mIHBvaW50ZXIgc2hvdWxkIG5ldmVyDQo+ID4gYmUgY2FsY3VsYXRlZCBhdCBhbGwuDQo+ID4g
VGhpcyBpcyB3aGF0IGlzIGZ1bmRhbWVudGFsbHkgYnJva2VuIGFib3V0IHRoZSBjdXJyZW50IGRl
ZmluaXRpb24uDQo+IA0KPiBZZXMsIHRoZSBydWxlIGlzICJ0aGUgSEVBRCdzIGNvbnRhaW5lcl9v
ZiBwb2ludGVyIHNob3VsZCBuZXZlciBiZQ0KPiBjYWxjdWxhdGVkIGF0IGFsbCBvdXRzaWRlIHRo
ZSBsb29wIiwgYnV0IGhvdyBkbyB5b3UgbWFrZSBzdXJlIGV2ZXJ5b25lDQo+IGZvbGxvd3MgdGhp
cyBydWxlPw0KPiBFdmVyeW9uZSBtYWtlcyBtaXN0YWtlcywgYnV0IHdlIGNhbiBlbGltaW5hdGUg
dGhlbSBhbGwgZnJvbSB0aGUgYmVnaW5uaW5nDQo+IHdpdGggdGhlIGhlbHAgb2YgY29tcGlsZXIg
d2hpY2ggY2FuIGNhdGNoIHN1Y2ggdXNlLWFmdGVyLWxvb3AgdGhpbmdzLg0KPiANCj4gPiA+IElP
VywgeW91IHdvdWxkIGRlcmVmZXJlbmNlIGEgKE5VTEwgKyBvZmZzZXRfb2ZfbWVtYmVyKSBhZGRy
ZXNzIGhlcmUuDQo+ID4NCj4gPldoZXJlPw0KPiANCj4gSW4gdGhlIGNhc2Ugd2hlcmUgYSBkZXZl
bG9wZXIgZG8gbm90IGZvbGxvd3MgdGhlIGFib3ZlIHJ1bGUsIGFuZCBtaXN0YWtlbHkNCj4gYWNj
ZXNzIGEgbm9uLWxpc3QtaGVhZCBtZW1iZXIgb2YgdGhlIEhFQUQncyBjb250YWluZXJfb2YgcG9p
bnRlciBvdXRzaWRlDQo+IHRoZSBsb29wLiBGb3IgZXhhbXBsZToNCj4gICAgIHN0cnVjdCByZXF7
DQo+ICAgICAgIGludCBhOw0KPiAgICAgICBzdHJ1Y3QgbGlzdF9oZWFkIGg7DQo+ICAgICB9DQo+
ICAgICBzdHJ1Y3QgcmVxICpyOw0KPiAgICAgbGlzdF9mb3JfZWFjaF9lbnRyeShyLCBIRUFELCBo
KSB7DQo+ICAgICAgIGlmIChyLT5hID09IDB4MTApDQo+ICAgICAgICAgYnJlYWs7DQo+ICAgICB9
DQo+ICAgICAvLyB0aGUgZGV2ZWxvcGVyIG1hZGUgYSBtaXN0YWtlOiBoZSBkaWRuJ3QgdGFrZSB0
aGlzIHNpdHVhdGlvbiBpbnRvDQo+ICAgICAvLyBhY2NvdW50IHdoZXJlIGFsbCBlbnRyaWVzIGlu
IHRoZSBsaXN0IGFyZSAqci0+YSAhPSAweDEwKiwgYW5kIG5vdw0KPiAgICAgLy8gdGhlIHIgaXMg
dGhlIEhFQUQncyBjb250YWluZXJfb2YgcG9pbnRlci4NCj4gICAgIHItPmEgPSAweDIwOw0KPiBU
aHVzIHRoZSAici0+YSA9IDB4MjAiIHdvdWxkIGRlcmVmZXJlbmNlIGEgKE5VTEwgKyBvZmZzZXRf
b2ZfbWVtYmVyKQ0KPiBhZGRyZXNzIGhlcmUuDQoNClRoYXQgaXMganVzdCBhIGJ1Zy4NCk5vIGRp
ZmZlcmVudCB0byBmYWlsaW5nIHRvIGNoZWNrIGFueXRoaW5nIGVsc2UgbWlnaHQgJ3JldHVybicN
CmEgTlVMTCBwb2ludGVyLg0KQmVjYXVzZSBpdCBpcyBhIE5VTEwgZGVyZWZlcmVuY2UgeW91IGZp
bmQgb3V0IHByZXR0eSBxdWlja2x5Lg0KVGhlIGV4aXN0aW5nIGxvb3AgbGVhdmVzIHlvdSB3aXRo
IGEgdmFsaWQgcG9pbnRlciB0byBzb21ldGhpbmcNCnRoYXQgaXNuJ3QgYSBsaXN0IGl0ZW0uDQoN
Cj4gPiA+IFBsZWFzZSByZW1pbmQgbWUgaWYgaSBtaXNzZWQgc29tZXRoaW5nLCB0aGFua3MuDQo+
ID4gPg0KPiA+ID4gQ2FuIHlvdSBzaGFyZSB5b3VyICJhbHRlcm5hdGl2ZSBkZWZpbml0aW9ucyIg
ZGV0YWlscz8gdGhhbmtzIQ0KPiA+DQo+ID4gVGhlIGxvb3Agc2hvdWxkIHByb2JhYmx5IHVzZSBh
cyBleHRyYSB2YXJpYWJsZSB0aGF0IHBvaW50cw0KPiA+IHRvIHRoZSAnbGlzdCBub2RlJyBpbiB0
aGUgbmV4dCBzdHJ1Y3R1cmUuDQo+ID4gU29tZXRoaW5nIGxpa2U6DQo+ID4gCWZvciAoeHh4ICpp
dGVyID0gaGVhZC0+bmV4dDsNCj4gPiAJCWl0ZXIgPT0gJmhlYWQgPyAoKGl0ZW0gPSBOVUxMKSww
KSA6ICgoaXRlbSA9IGxpc3RfaXRlbShpdGVyKSwxKSk7DQo+ID4gCQlpdGVyID0gaXRlbS0+bWVt
YmVyLT5uZXh0KSB7DQo+ID4gCSAgIC4uLg0KPiA+IFdpdGggYSBiaXQgb2YgY2FzdGluZyB5b3Ug
Y2FuIHVzZSAnaXRlbScgdG8gaG9sZCAnaXRlcicuDQo+IA0KPiB5b3Ugc3RpbGwgY2FuIG5vdCBt
YWtlIHN1cmUgZXZlcnlvbmUgZm9sbG93cyB0aGlzIHJ1bGU6DQo+ICJkbyBub3QgdXNlIGl0ZXJh
dG9yIG91dHNpZGUgdGhlIGxvb3AiIHdpdGhvdXQgdGhlIGhlbHAgb2YgY29tcGlsZXIsDQo+IGJl
Y2F1c2UgaXRlbSBpcyBkZWNsYXJlZCBvdXRzaWRlIHRoZSBsb29wLg0KDQpUaGF0IG9uZSBoYXMg
J2l0ZXInIGRlZmluZWQgaW4gdGhlIGxvb3AuDQoNCj4gQlRXLCB0byBhdm9pZCBhbWJpZ3VpdHnv
vIx0aGUgImFsdGVybmF0aXZlIGRlZmluaXRpb25zIiBoZXJlIGkgYXNrZWQgaXMNCj4gc29tZXRo
aW5nIGZyb20geW91IGluIHRoaXMgY29udGV4dDoNCj4gIk9UT0ggdGhlcmUgbWF5IGJlIGFsdGVy
bmF0aXZlIGRlZmluaXRpb25zIHRoYXQgY2FuIGJlIHVzZWQgdG8gZ2V0DQo+IHRoZSBjb21waWxl
ciAob3Igb3RoZXIgY29tcGlsZXItbGlrZSB0b29scykgdG8gZGV0ZWN0IGJyb2tlbiBjb2RlLg0K
PiBFdmVuIGlmIHRoZSBkZWZpbml0aW9uIGNhbid0IHBvc3NpYmx5IGdlbmVyYXRlIGEgd29ya2lu
ZyBrZXJybmVsLiINCg0KSSB3YXMgdGhpbmtpbmcgb2Ygc29tZXRoaW5nIGxpa2U6DQoJaWYgKChw
b3MgPSBsaXN0X2ZpcnN0KSksIDEpIHBvcyA9IE5VTEwgZWxzZQ0Kc28gdGhhdCB1bmNoZWNrZWQg
ZGVyZWZlcmVuY2VzIGFmdGVyIHRoZSBsb29wIHdpbGwgYmUgZGV0ZWN0YWJsZQ0KYXMgTlVMTCBw
b2ludGVyIG9mZnNldHMgLSBidXQgdGhhdCBpbiBpdHNlbGYgaXNuJ3QgZW5vdWdoIHRvIGF2b2lk
DQpvdGhlciB3YXJuaW5ncy4NCg0KPiA+ID4gVGhlICJsaXN0X2Zvcl9lYWNoX2VudHJ5X2luc2lk
ZShwb3MsIHR5cGUsIGhlYWQsIG1lbWJlcikiIHdheSBtYWtlcw0KPiA+ID4gdGhlIGl0ZXJhdG9y
IGludmlzaWFibGUgb3V0c2lkZSB0aGUgbG9vcCwgYW5kIHdvdWxkIGJlIGNhdGNoZWQgYnkNCj4g
PiA+IGNvbXBpbGVyIGlmIHVzZS1hZnRlci1sb29wIHRoaW5ncyBoYXBwZW5lZC4NCj4gDQo+ID4g
SXQgaXMgYWxzbyBhIGNvbXBldGUgUElUQSBmb3IgYW55dGhpbmcgZG9pbmcgYSBzZWFyY2guDQo+
IA0KPiBZb3UgbWVhbiBpdCB3b3VsZCBiZSBhIGJ1cmRlbiBvbiBzZWFyY2g/IGNhbiB5b3Ugc2hv
dyBtZSBzb21lIGV4YW1wbGVzPw0KDQpUaGUgd2hvbGUgYnVzaW5lc3Mgb2YgaGF2aW5nIHRvIHNh
dmUgdGhlIHBvaW50ZXIgdG8gdGhlIGxvY2F0ZWQgaXRlbQ0KYmVmb3JlIGJyZWFraW5nIHRoZSBs
b29wLCByZW1lbWJlcmluZyB0byBoYXZlIHNldCBpdCB0byBOVUxMIGVhcmxpZXIgZXRjLg0KDQpJ
dCBpcyBzbyBtdWNoIGJldHRlciBpZiB5b3UgY2FuIGp1c3QgZG86DQoJCWlmIChmb3VuZCkNCgkJ
CWJyZWFrOw0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFt
bGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3Ry
YXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

