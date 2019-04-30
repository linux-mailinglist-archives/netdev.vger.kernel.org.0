Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8A1FB0D
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 16:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbfD3OIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 10:08:18 -0400
Received: from mail01.preh.com ([80.149.130.22]:44700 "EHLO mail01.preh.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbfD3OIS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 10:08:18 -0400
From:   Kloetzke Jan <Jan.Kloetzke@preh.de>
To:     "jan@kloetzke.net" <jan@kloetzke.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "oneukum@suse.com" <oneukum@suse.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usbnet: fix kernel crash after disconnect
Thread-Topic: [PATCH] usbnet: fix kernel crash after disconnect
Thread-Index: AQHU9P6lIDgQA+tBpkOiuoVbyUaoWaZBVvAAgAAX0ACAAQSdAIAAgR8AgBB4LACAAUQQAA==
Date:   Tue, 30 Apr 2019 14:08:01 +0000
Message-ID: <1556633280.4173.239.camel@preh.de>
References: <20190417091849.7475-1-Jan.Kloetzke@preh.de>
         <1555569464.7835.4.camel@suse.com> <1555574578.4173.215.camel@preh.de>
         <20190418.163544.2153438649838575906.davem@davemloft.net>
         <20190419071752.GG1084@tuxedo> <1556563688.20085.31.camel@suse.com>
In-Reply-To: <1556563688.20085.31.camel@suse.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-tm-snts-smtp: 164BCF687DC7C74CDE97D6D1126F459DA3E61CEBE809B60CB0E8E0B30459E36A2000:8
x-exclaimer-md-config: 142fe46c-4d13-4ac1-9970-1f36f118897a
Content-Type: text/plain; charset="utf-8"
Content-ID: <6617290D5005814284ACF48FE97A4AA4@preh.de>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; d=preh.de; s=key1; c=relaxed/relaxed;
 h=from:to:cc:subject:date:message-id:references:content-type:mime-version;
 bh=jBqfuTINkpvhlsBGiWl4F4SJSqFFw0LNYABaVNDebi4=;
 b=Xf6Ro7HE5IG+t9wj8r2N1ne5HUR2+vb3E/b6nt4AtLsoVqYTNctmsJ/Ro43jK1s2F3BYBZPecPWH
        6mz9hIwZU1W7Qw+6eQQ/5ZQMW3H7SdKjkUuYa7XtwSb7u++iB5MMBB3RIKu9mjG3QSYRleQrTyBz
        g5Byt+b7O9MlccCc5vihgTiL3EFTl77PuI9CWUFyuurooALVSElfw8rVSXLBDSYvWkW66GMWqadF
        ak1pv8nLq96oDwMQzBkeppzzqYEIo72vxik5cAqdIopmgShXA+5WgnPguVb6zVsNqNcS4FtBQuTX
        /Cn3dHLGQUKkoW6O+uUlcc5R2dcyB/ZzNs0eLg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QW0gTW9udGFnLCBkZW4gMjkuMDQuMjAxOSwgMjA6NDggKzAyMDAgc2NocmllYiBPbGl2ZXIgTmV1
a3VtOg0KPiBPbiBGciwgMjAxOS0wNC0xOSBhdCAwOToxNyArMDIwMCwgSmFuIEtsw7Z0emtlICB3
cm90ZToNCj4gPiBIaSBEYXZpZCwNCj4gPiANCj4gPiBPbiBUaHUsIEFwciAxOCwgMjAxOSBhdCAw
NDozNTo0NFBNIC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+ID4gPiBGcm9tOiBLbG9ldHpr
ZSBKYW4gPEphbi5LbG9ldHprZUBwcmVoLmRlPg0KPiA+ID4gRGF0ZTogVGh1LCAxOCBBcHIgMjAx
OSAwODowMjo1OSArMDAwMA0KPiA+ID4gDQo+ID4gPiA+IEkgdGhpbmsgdGhpcyBhc3N1bXB0aW9u
IGlzIG5vdCBjb3JyZWN0LiBBcyBmYXIgYXMgSSB1bmRlcnN0YW5kIHRoZQ0KPiA+ID4gPiBuZXR3
b3JraW5nIGNvZGUgaXQgaXMgc3RpbGwgcG9zc2libGUgdGhhdCB0aGUgbmRvX3N0YXJ0X3htaXQg
Y2FsbGJhY2sNCj4gPiA+ID4gaXMgY2FsbGVkIHdoaWxlIG5kb19zdG9wIGlzIHJ1bm5pbmcgYW5k
IGV2ZW4gYWZ0ZXIgbmRvX3N0b3AgaGFzDQo+ID4gPiA+IHJldHVybmVkLiBZb3UgY2FuIG9ubHkg
YmUgc3VyZSBhZnRlciB1bnJlZ2lzdGVyX25ldGRldigpIGhhcyByZXR1cm5lZC4NCj4gPiA+ID4g
TWF5YmUgc29tZSBuZXR3b3JraW5nIGZvbGtzIGNhbiBjb21tZW50IG9uIHRoYXQuDQo+ID4gPiAN
Cj4gPiA+IFRoZSBrZXJuZWwgbG9vcHMgb3ZlciB0aGUgZGV2aWNlcyBiZWluZyB1bnJlZ2lzdGVy
ZWQsIGFuZCBmaXJzdCBpdCBjbGVhcnMNCj4gPiA+IHRoZSBfX0xJTktfU1RBVEVfU1RBUlQgb24g
YWxsIG9mIHRoZW0sIHRoZW4gaXQgaW52b2tlcyAtPm5kb19zdG9wKCkgb24NCj4gPiA+IGFsbCBv
ZiB0aGVtLg0KPiA+ID4gDQo+ID4gPiBfX0xJTktfU1RBVEVfU1RBUlQgY29udHJvbHMgd2hhdCBu
ZXRpZl9ydW5uaW5nKCkgcmV0dXJucy4NCj4gPiA+IA0KPiA+ID4gQWxsIGNhbGxzIHRvIC0+bmRv
X3N0YXJ0X3htaXQoKSBhcmUgZ3VhcmRlZCBieSBuZXRpZl9ydW5uaW5nKCkgY2hlY2tzLg0KPiA+
ID4gDQo+ID4gPiBTbyB3aGVuIG5kb19zdG9wIGlzIGludm9rZWQgeW91IHNob3VsZCBnZXQgbm8g
bW9yZSBuZG9fc3RhcnRfeG1pdA0KPiA+ID4gaW52b2NhdGlvbnMgb24gdGhhdCBkZXZpY2UuICBP
dGhlcndpc2UgaG93IGNvdWxkIHlvdSBzaHV0IGRvd24gRE1BDQo+ID4gPiByZXNvdXJjZXMgYW5k
IHR1cm4gb2ZmIHRoZSBUWCBlbmdpbmUgcHJvcGVybHk/DQo+ID4gDQo+ID4gQnV0IHlvdSBjb3Vs
ZCBzdGlsbCByYWNlIHdpdGggYW5vdGhlciBDUFUgdGhhdCBpcyBwYXN0IHRoZQ0KPiA+IG5ldGlm
X3J1bm5pbmcoKSBjaGVjaywgY2FuIHlvdT8gU28gdGhlIGRyaXZlciBoYXMgdG8gbWFrZSBzdXJl
IHRoYXQgaXQNCj4gPiBncmFjZWZ1bGx5IGhhbmRsZXMgY29uY3VycmVudCAtPm5kb19zdGFydF94
bWl0KCkgYW5kIC0+bmRvX3N0b3AoKSBjYWxscy4NCj4gDQo+IExvb2tpbmcgYXQgZGV2X2RpcmVj
dF94bWl0KHN0cnVjdCBza19idWZmICpza2IsIHUxNiBxdWV1ZV9pZCkNCj4gdGhpcyBpbmRlZWQg
c2VlbXMgcG9zc2libGUuIEJ1dCB0aGUgZG9jdW1lbnRhdGlvbiBzYXlzIHRoYXQgaXQgaXMgbm90
Lg0KPiANCj4gRGF2ZT8NCj4gDQo+ID4gT3IgYXJlIHRoZXJlIGFueSBsb2Nrcy9iYXJyaWVycyBp
bnZvbHZlZCB0aGF0IG1ha2Ugc3VyZSBhbGwNCj4gPiAtPm5kb19zdGFydF94bWl0KCkgY2FsbHMg
aGF2ZSByZXR1cm5lZCBiZWZvcmUgaW52b2tpbmcgLT5uZG9fc3RvcCgpPw0KPiANCj4gSmFuLA0K
PiANCj4gY291bGQgeW91IG1ha2UgdmVyc2lvIG9mIHlvdXIgcGF0Y2ggdGhhdCBnaXZlcyBhIFdB
Uk5pbmcgaWYgdGhpcyByYWNlDQo+IHRyaWdnZXJzPw0KDQpTdXJlLiBJJ2xsIHNlbmQgdjIgc2hv
cnRseS4NCg0KUmVnYXJkcywNCkphbg==
