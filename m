Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C60011FFFD
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 09:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfEPHKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 03:10:46 -0400
Received: from mail01.preh.com ([80.149.130.22]:31508 "EHLO mail01.preh.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbfEPHKq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 03:10:46 -0400
From:   Kloetzke Jan <Jan.Kloetzke@preh.de>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "oneukum@suse.com" <oneukum@suse.com>
CC:     "jan@kloetzke.net" <jan@kloetzke.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v2] usbnet: fix kernel crash after disconnect
Thread-Topic: [PATCH v2] usbnet: fix kernel crash after disconnect
Thread-Index: AQHU/18dyV1WEybtp0WgCkArhegqtKZcDN8AgAGbOgCAD6SEgA==
Date:   Thu, 16 May 2019 07:10:30 +0000
Message-ID: <1557990629.19453.7.camel@preh.de>
References: <1556563688.20085.31.camel@suse.com>
         <20190430141440.9469-1-Jan.Kloetzke@preh.de>
         <20190505.004556.492323065607253635.davem@davemloft.net>
         <1557130666.12778.3.camel@suse.com>
In-Reply-To: <1557130666.12778.3.camel@suse.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-tm-snts-smtp: CD001CF085DFE775677F9BE5A836228302ED75D7614BA2027CD81CD33F5F1FEF2000:8
x-exclaimer-md-config: 142fe46c-4d13-4ac1-9970-1f36f118897a
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E1D6F6A821CE24589B802D64EFA922E@preh.de>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; d=preh.de; s=key1; c=relaxed/relaxed;
 h=from:to:cc:subject:date:message-id:references:content-type:mime-version;
 bh=HDjNlSGE1pTbaN6s5Om8695edfLLIhm71aZmgJAjO2E=;
 b=kZYWIs4EZuot34elPr1rGsqg4H3PS2mTzoi1qB2cJ7SNCHKSSxopR4JYxLc2pp3AVYQIIUvF+FGp
        OwQCryEkx65/3ZvoFuPMRf67/B4ONhl8s8uSNKoJyX2NGsEm9Oyw0jO5g6+uMVt5EU+EKNT3zDCy
        MAMhTT6YOoReLBNbOyRLQUHfTnAViQYofql2kEChxUYPxVmES3zEysViKeIu0TNTiLpak7n6RwNX
        kgnaghX1T3rbSGDomkcTkPbNCddQSkST9GylZhdH7vVlHC7E+BTENCkW5DzLxne++zRWJPrq48oj
        QgRObLnHSmB6/O4NmdyTQTqOdstUp0uRaZlD+Q==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QW0gTW9udGFnLCBkZW4gMDYuMDUuMjAxOSwgMTA6MTcgKzAyMDAgc2NocmllYiBPbGl2ZXIgTmV1
a3VtOg0KPiBPbiBTbywgMjAxOS0wNS0wNSBhdCAwMDo0NSAtMDcwMCwgRGF2aWQgTWlsbGVyIHdy
b3RlOg0KPiA+IEZyb206IEtsb2V0emtlIEphbiA8SmFuLktsb2V0emtlQHByZWguZGU+DQo+ID4g
RGF0ZTogVHVlLCAzMCBBcHIgMjAxOSAxNDoxNTowNyArMDAwMA0KPiA+IA0KPiA+ID4gQEAgLTE0
MzEsNiArMTQzMiwxMSBAQCBuZXRkZXZfdHhfdCB1c2JuZXRfc3RhcnRfeG1pdCAoc3RydWN0IHNr
X2J1ZmYgKnNrYiwNCj4gPiA+ICAgICAgICAgICAgICAgc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgm
ZGV2LT50eHEubG9jaywgZmxhZ3MpOw0KPiA+ID4gICAgICAgICAgICAgICBnb3RvIGRyb3A7DQo+
ID4gPiAgICAgICB9DQo+ID4gPiArICAgICBpZiAoV0FSTl9PTihuZXRpZl9xdWV1ZV9zdG9wcGVk
KG5ldCkpKSB7DQo+ID4gPiArICAgICAgICAgICAgIHVzYl9hdXRvcG1fcHV0X2ludGVyZmFjZV9h
c3luYyhkZXYtPmludGYpOw0KPiA+ID4gKyAgICAgICAgICAgICBzcGluX3VubG9ja19pcnFyZXN0
b3JlKCZkZXYtPnR4cS5sb2NrLCBmbGFncyk7DQo+ID4gPiArICAgICAgICAgICAgIGdvdG8gZHJv
cDsNCj4gPiA+ICsgICAgIH0NCj4gPiANCj4gPiBJZiB0aGlzIGlzIGtub3duIHRvIGhhcHBlbiBh
bmQgaXMgZXhwZWN0ZWQsIHRoZW4gd2Ugc2hvdWxkIG5vdCB3YXJuLg0KPiA+IA0KPiANCj4gSGks
DQo+IA0KPiB5ZXMgdGhpcyBpcyB0aGUgcG9pbnQuIENhbiBuZG9fc3RhcnRfeG1pdCgpIGFuZCBu
ZG9fc3RvcCgpIHJhY2U/DQo+IElmIG5vdCwgd2h5IGRvZXMgdGhlIHBhdGNoIGZpeCB0aGUgb2Jz
ZXJ2ZWQgaXNzdWUgYW5kIHdoYXQNCj4gcHJldmVudHMgdGhlIHJhY2U/IFNvbWV0aGluZyBpcyBu
b3QgY2xlYXIgaGVyZS4NCg0KRGF2ZSwgY291bGQgeW91IHNoZWQgc29tZSBsaWdodCBvbiBPbGl2
ZXJzIHF1ZXN0aW9uPyBJZiB0aGUgcmFjZSBjYW4NCmhhcHBlbiB0aGVuIHdlIGNhbiBzdGljayB0
byB2MSBiZWNhdXNlIHRoZSBXQVJOX09OIGlzIGluZGVlZCBwb2ludGxlc3MuDQpPdGhlcndpc2Ug
aXQncyBub3QgY2xlYXIgd2h5IGl0IG1hZGUgdGhlIHByb2JsZW0gZ28gYXdheSBmb3IgdXMgYW5k
IHYyDQptYXkgYmUgdGhlIGJldHRlciBvcHRpb24uLi4NCg0KUmVnYXJkcywNCkphbg==
