Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D78124C6B
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 12:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727251AbfEUKMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 06:12:39 -0400
Received: from mail01.preh.com ([80.149.130.22]:50804 "EHLO mail01.preh.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbfEUKMj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 May 2019 06:12:39 -0400
From:   Kloetzke Jan <Jan.Kloetzke@preh.de>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "oneukum@suse.com" <oneukum@suse.com>
CC:     "jan@kloetzke.net" <jan@kloetzke.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v2] usbnet: fix kernel crash after disconnect
Thread-Topic: [PATCH v2] usbnet: fix kernel crash after disconnect
Thread-Index: AQHU/18dyV1WEybtp0WgCkArhegqtKZcDN8AgAGbOgCAD6SEgIAIB9wAgAAGnQA=
Date:   Tue, 21 May 2019 10:12:23 +0000
Message-ID: <1558433542.19453.33.camel@preh.de>
References: <1556563688.20085.31.camel@suse.com>
         <20190430141440.9469-1-Jan.Kloetzke@preh.de>
         <20190505.004556.492323065607253635.davem@davemloft.net>
         <1557130666.12778.3.camel@suse.com> <1557990629.19453.7.camel@preh.de>
         <1558432122.12672.12.camel@suse.com>
In-Reply-To: <1558432122.12672.12.camel@suse.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-tm-snts-smtp: E766891CAA47C511B3ACF51FFF83D97C99B6D1BBDEE79F336CAB83929E6DDA6D2000:8
x-exclaimer-md-config: 142fe46c-4d13-4ac1-9970-1f36f118897a
Content-Type: text/plain; charset="utf-8"
Content-ID: <C544988B646F2E438DB82C8B97E734CA@preh.de>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; d=preh.de; s=key1; c=relaxed/relaxed;
 h=from:to:cc:subject:date:message-id:references:content-type:mime-version;
 bh=9wyZw08aJ2US/GZIzCzxf42QZpwuiDAuMmCgt4oeGqc=;
 b=Xf5Bzq63XAX30L5Uwvs6QsIBYZ+znN2z+lCLKYY70YGo6/VqBRjijo9dmaLGVbb2d3jouIJpG185
        4Eozy8AV5sAohsQTH96Wl5iUAVy0mVqSNoo3tRrTYCgBZ3+hSeyeWNs6mM8Nk7BmTMdqG86UwlBr
        QEIXBA3LnCg4SvLMYb2xyM5q1XlORT2edfdNtptrmrJKXh6ub9RcLSOC5Uskb4H5SLh1DahisOgv
        hdwX1JIDqDcxVrRmEM9qUGk+O2pc20Mv6oJQ3BF4oYllOrwdqbLfzoWjnKJjY47QsYXZYhhh0U8Z
        /5vTGGZ/3AXp6RoLYSX7HDnM5w54ftlzKG+Ebw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCkFtIERpZW5zdGFnLCBkZW4gMjEuMDUuMjAxOSwgMTE6NDggKzAyMDAgc2NocmllYiBP
bGl2ZXIgTmV1a3VtOg0KPiBPbiBEbywgMjAxOS0wNS0xNiBhdCAwNzoxMCArMDAwMCwgS2xvZXR6
a2UgSmFuIHdyb3RlOg0KPiA+IEFtIE1vbnRhZywgZGVuIDA2LjA1LjIwMTksIDEwOjE3ICswMjAw
IHNjaHJpZWIgT2xpdmVyIE5ldWt1bToNCj4gPiA+IE9uIFNvLCAyMDE5LTA1LTA1IGF0IDAwOjQ1
IC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+ID4gPiA+IEZyb206IEtsb2V0emtlIEphbiA8
SmFuLktsb2V0emtlQHByZWguZGU+DQo+ID4gPiA+IERhdGU6IFR1ZSwgMzAgQXByIDIwMTkgMTQ6
MTU6MDcgKzAwMDANCj4gPiA+ID4gDQo+ID4gPiA+ID4gQEAgLTE0MzEsNiArMTQzMiwxMSBAQCBu
ZXRkZXZfdHhfdCB1c2JuZXRfc3RhcnRfeG1pdCAoc3RydWN0IHNrX2J1ZmYgKnNrYiwNCj4gPiA+
ID4gPiAgICAgICAgICAgICAgIHNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmRldi0+dHhxLmxvY2ss
IGZsYWdzKTsNCj4gPiA+ID4gPiAgICAgICAgICAgICAgIGdvdG8gZHJvcDsNCj4gPiA+ID4gPiAg
ICAgICB9DQo+ID4gPiA+ID4gKyAgICAgaWYgKFdBUk5fT04obmV0aWZfcXVldWVfc3RvcHBlZChu
ZXQpKSkgew0KPiA+ID4gPiA+ICsgICAgICAgICAgICAgdXNiX2F1dG9wbV9wdXRfaW50ZXJmYWNl
X2FzeW5jKGRldi0+aW50Zik7DQo+ID4gPiA+ID4gKyAgICAgICAgICAgICBzcGluX3VubG9ja19p
cnFyZXN0b3JlKCZkZXYtPnR4cS5sb2NrLCBmbGFncyk7DQo+ID4gPiA+ID4gKyAgICAgICAgICAg
ICBnb3RvIGRyb3A7DQo+ID4gPiA+ID4gKyAgICAgfQ0KPiA+ID4gPiANCj4gPiA+ID4gSWYgdGhp
cyBpcyBrbm93biB0byBoYXBwZW4gYW5kIGlzIGV4cGVjdGVkLCB0aGVuIHdlIHNob3VsZCBub3Qg
d2Fybi4NCj4gPiA+ID4gDQo+ID4gPiANCj4gPiA+IEhpLA0KPiA+ID4gDQo+ID4gPiB5ZXMgdGhp
cyBpcyB0aGUgcG9pbnQuIENhbiBuZG9fc3RhcnRfeG1pdCgpIGFuZCBuZG9fc3RvcCgpIHJhY2U/
DQo+ID4gPiBJZiBub3QsIHdoeSBkb2VzIHRoZSBwYXRjaCBmaXggdGhlIG9ic2VydmVkIGlzc3Vl
IGFuZCB3aGF0DQo+ID4gPiBwcmV2ZW50cyB0aGUgcmFjZT8gU29tZXRoaW5nIGlzIG5vdCBjbGVh
ciBoZXJlLg0KPiA+IA0KPiA+IERhdmUsIGNvdWxkIHlvdSBzaGVkIHNvbWUgbGlnaHQgb24gT2xp
dmVycyBxdWVzdGlvbj8gSWYgdGhlIHJhY2UgY2FuDQo+ID4gaGFwcGVuIHRoZW4gd2UgY2FuIHN0
aWNrIHRvIHYxIGJlY2F1c2UgdGhlIFdBUk5fT04gaXMgaW5kZWVkIHBvaW50bGVzcy4NCj4gPiBP
dGhlcndpc2UgaXQncyBub3QgY2xlYXIgd2h5IGl0IG1hZGUgdGhlIHByb2JsZW0gZ28gYXdheSBm
b3IgdXMgYW5kIHYyDQo+ID4gbWF5IGJlIHRoZSBiZXR0ZXIgb3B0aW9uLi4uDQo+IA0KPiBIaSwN
Cj4gDQo+IGFzIERhdmUgY29uZmlybWVkIHRoYXQgdGhlIHJhY2UgZXhpc3RzLCBjb3VsZCB5b3Ug
cmVzdWJtaXQgd2l0aG91dA0KPiB0aGUgV0FSTiA/DQoNCldoeSBub3QganVzdCB0YWtlIHYxIG9m
IHRoZSBwYXRjaD8NCg0KICBodHRwczovL2xvcmUua2VybmVsLm9yZy9uZXRkZXYvMjAxOTA0MTcw
OTE4NDkuNzQ3NS0xLUphbi5LbG9ldHprZUBwcmVoLmRlLw0KDQpUaGUgb3JpZ2luYWwgdmVyc2lv
biB3YXMgZXhhY3RseSB0aGUgc2FtZSwganVzdCB3aXRob3V0IHRoZSBXQVJOX09OKCkuDQpPciBp
cyBpdCByZXF1aXJlZCB0byBzZW5kIGEgdjMgaW4gdGhpcyBjYXNlPw0KDQpSZWdhcmRzLA0KSmFu
