Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9D84AA9A3
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 16:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359518AbiBEPXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 10:23:21 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:40752 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358041AbiBEPXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 10:23:20 -0500
Received: from mail.baikalelectronics.ru (unknown [192.168.51.25])
        by mail.baikalelectronics.ru (Postfix) with ESMTP id 60E268030865;
        Sat,  5 Feb 2022 18:23:17 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.baikalelectronics.ru 60E268030865
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baikalelectronics.ru; s=mail; t=1644074598;
        bh=QHLFQH2a3MKFeN5W7H8+opv1v3yX8dFAXQi720szGHo=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=hyKU+oar5fSLOwsZK1jX1Ncr6BoEDe2/l38hdKreX5Qn3VY74hicNBMc5lKIDguRd
         MqrRr8q3IGWgjVFo2RgJl1+KmKkED1n4JAMaChWu1ZBGuEGLC2marHaH8derkG+bh0
         ZmBYL9Tv/MaN+sG3+IaPowGOwLYwBFUpUuJYbabE=
Received: from MAIL.baikal.int (192.168.51.25) by mail (192.168.51.25) with
 Microsoft SMTP Server (TLS) id 15.0.1395.4; Sat, 5 Feb 2022 18:22:45 +0300
Received: from MAIL.baikal.int ([::1]) by MAIL.baikal.int ([::1]) with mapi id
 15.00.1395.000; Sat, 5 Feb 2022 18:22:44 +0300
From:   <Pavel.Parkhomenko@baikalelectronics.ru>
To:     <andrew@lunn.ch>
CC:     <Alexey.Malahov@baikalelectronics.ru>,
        <Sergey.Semin@baikalelectronics.ru>,
        <linux-kernel@vger.kernel.org>, <michael@stapelberg.de>,
        <afleming@gmail.com>, <f.fainelli@gmail.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: phy: marvell: Fix RGMII Tx/Rx delays setting in
 88e1121-compatible PHYs
Thread-Topic: [PATCH] net: phy: marvell: Fix RGMII Tx/Rx delays setting in
 88e1121-compatible PHYs
Thread-Index: AQHYGYgjpwnysZLJNUG22PH4uN5jnqyDK9IAgAG3OQA=
Date:   Sat, 5 Feb 2022 15:22:44 +0000
Message-ID: <5dd77fec0f9a2d38fd4473cd0e357e80aeafe0cb.camel@baikalelectronics.ru>
References: <96759fee7240fd095cb9cc1f6eaf2d9113b57cf0.camel@baikalelectronics.ru>
         <Yf0lyGi+2mEwmrEH@lunn.ch>
In-Reply-To: <Yf0lyGi+2mEwmrEH@lunn.ch>
Accept-Language: ru-RU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="utf-8"
Content-ID: <369B71F9D41807438C1279FA0EB1A53A@baikalelectronics.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAwNC8wMi8yMDIyIGF0IDE0OjEwICswMTAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
SGkgUGF2ZWwNCj4gDQo+IFRoZXJlIGFwcGVhcnMgdG8gYmUgYW5vdGhlciBwYXRoIHdoaWNoIGhh
cyB0aGUgc2FtZSBpc3N1ZS4NCj4gDQo+IG04OGUxMTE4X2NvbmZpZ19hbmVnKCkgY2FsbHMgbWFy
dmVsbF9zZXRfcG9sYXJpdHkoKSwgd2hpY2ggYWxzbyBuZWVkcw0KPiBhIHJlc2V0IGFmdGVyd2Fy
ZHMuDQo+IA0KPiBDb3VsZCB5b3UgZml4IHRoaXMgY2FzZSBhcyB3ZWxsPw0KPiANCj4gVGhhbmtz
DQo+IMKgwqDCoMKgwqDCoMKgwqBBbmRyZXcNCg0KbTg4ZTExMThfY29uZmlnX2FuZWcoKSB3YXMg
YWRkZWQgYmFjayBpbiAyMDA4IGFuZCBoYXMgdW5jb25kaXRpb25hbA0KZ2VucGh5X3NvZnRfcmVz
ZXQoKSBhdCB0aGUgdmVyeSBiZWdpbm5pbmcuIEkgaGF2ZW4ndCBnb3QgODhFMTExOFIgb3INCjg4
RTExMTQ5UiBieSB0aGUgaGFuZCBhbmQgdGhlIGZ1bGwgZG9jdW1lbnRhdGlvbiBpcyBhbHNvIG5v
dCBhdmFpbGFibGUuDQpJIGJlbGlldmUgdGhhdCBpbiB0aGlzIGNhc2UgaXQgd291bGQgYmUgc2Fm
ZSB0byBzdGlsbCBpc3N1ZSByZXNldA0KdW5jb25kaXRpb25hbGx5LCBidXQgZG8gaXQgYXQgdGhl
IHZlcnkgZW5kIG9mIG04OGUxMTE4X2NvbmZpZ19hbmVnKCkuDQpBbnl3YXlzLCBJJ2QgbGlrZSB0
byBwb3N0IGl0IGFzIGEgc2VwYXJhdGUgcGF0Y2ggYXMgSSBjYW5ub3QgdGVzdCB0aGUgZml4DQpw
cm9wZXJseSwgdW5saWtlIHByZXZpb3VzIHBhdGNoIHJlZ2FyZGluZyA4OEUxNTEwLg0KDQotLSAN
CkJlc3QgcmVnYXJkcywNClBhdmVsIFBhcmtob21lbmtvDQo=
