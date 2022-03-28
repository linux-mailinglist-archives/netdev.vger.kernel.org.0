Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5EA94E966F
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 14:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242392AbiC1MXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 08:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242394AbiC1MWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 08:22:54 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1BCD446B13
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 05:21:12 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-8-vkuU1pGbNXCyrAVN_KskHQ-1; Mon, 28 Mar 2022 13:21:10 +0100
X-MC-Unique: vkuU1pGbNXCyrAVN_KskHQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Mon, 28 Mar 2022 13:21:04 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Mon, 28 Mar 2022 13:21:04 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Kalle Valo' <kvalo@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
CC:     =?utf-8?B?QmVuamFtaW4gU3TDvHJ6?= <benni@stuerz.xyz>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "linux@simtec.co.uk" <linux@simtec.co.uk>,
        "krzk@kernel.org" <krzk@kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "robert.moore@intel.com" <robert.moore@intel.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "3chas3@gmail.com" <3chas3@gmail.com>,
        "laforge@gnumonks.org" <laforge@gnumonks.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "rric@kernel.org" <rric@kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "brgl@bgdev.pl" <brgl@bgdev.pl>,
        "mike.marciniszyn@cornelisnetworks.com" 
        <mike.marciniszyn@cornelisnetworks.com>,
        "dennis.dalessandro@cornelisnetworks.com" 
        <dennis.dalessandro@cornelisnetworks.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, "pali@kernel.org" <pali@kernel.org>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "isdn@linux-pingi.de" <isdn@linux-pingi.de>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "fbarrat@linux.ibm.com" <fbarrat@linux.ibm.com>,
        "ajd@linux.ibm.com" <ajd@linux.ibm.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "nico@fluxnic.net" <nico@fluxnic.net>,
        "loic.poulain@linaro.org" <loic.poulain@linaro.org>,
        "pkshih@realtek.com" <pkshih@realtek.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>,
        "linux-atm-general@lists.sourceforge.net" 
        <linux-atm-general@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "wcn36xx@lists.infradead.org" <wcn36xx@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: RE: [PATCH 21/22] rtw89: Replace comments with C99 initializers
Thread-Topic: [PATCH 21/22] rtw89: Replace comments with C99 initializers
Thread-Index: AQHYQoY88SRtyCmm7EOK7E4AJyEA9qzUtsLg
Date:   Mon, 28 Mar 2022 12:21:04 +0000
Message-ID: <6082d343f18a40229df83e3102e7dc38@AcuMS.aculab.com>
References: <20220326165909.506926-1-benni@stuerz.xyz>
        <20220326165909.506926-21-benni@stuerz.xyz>
        <f7bb9164-2f66-8985-5771-5f31ee5740b7@lwfinger.net>
 <87k0cezarl.fsf@kernel.org>
In-Reply-To: <87k0cezarl.fsf@kernel.org>
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

RnJvbTogS2FsbGUgVmFsbw0KPiBTZW50OiAyOCBNYXJjaCAyMDIyIDEwOjI5DQo+IA0KPiBMYXJy
eSBGaW5nZXIgPExhcnJ5LkZpbmdlckBsd2Zpbmdlci5uZXQ+IHdyaXRlczoNCj4gDQo+ID4gT24g
My8yNi8yMiAxMTo1OSwgQmVuamFtaW4gU3TDvHJ6IHdyb3RlOg0KPiA+PiBUaGlzIHJlcGxhY2Vz
IGNvbW1lbnRzIHdpdGggQzk5J3MgZGVzaWduYXRlZA0KPiA+PiBpbml0aWFsaXplcnMgYmVjYXVz
ZSB0aGUga2VybmVsIHN1cHBvcnRzIHRoZW0gbm93Lg0KPiA+Pg0KPiA+PiBTaWduZWQtb2ZmLWJ5
OiBCZW5qYW1pbiBTdMO8cnogPGJlbm5pQHN0dWVyei54eXo+DQo+ID4+IC0tLQ0KPiA+PiAgIGRy
aXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODkvY29leC5jIHwgNDAgKysrKysrKysrKyst
LS0tLS0tLS0tLS0NCj4gPj4gICAxIGZpbGUgY2hhbmdlZCwgMjAgaW5zZXJ0aW9ucygrKSwgMjAg
ZGVsZXRpb25zKC0pDQo+ID4+DQo+ID4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVz
cy9yZWFsdGVrL3J0dzg5L2NvZXguYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3
ODkvY29leC5jDQo+ID4+IGluZGV4IDY4NDU4Mzk1NTUxMS4uM2M4M2EwYmZiMTIwIDEwMDY0NA0K
PiA+PiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg5L2NvZXguYw0KPiA+
PiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg5L2NvZXguYw0KPiA+PiBA
QCAtOTcsMjYgKzk3LDI2IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgcnR3ODlfYnRjX2ZidGNfc2xv
dCBzX2RlZltdID0gew0KPiA+PiAgIH07DQo+ID4+ICAgICBzdGF0aWMgY29uc3QgdTMyIGN4dGJs
W10gPSB7DQo+ID4+IC0JMHhmZmZmZmZmZiwgLyogMCAqLw0KPiA+PiAtCTB4YWFhYWFhYWEsIC8q
IDEgKi8NCj4gPj4gLQkweDU1NTU1NTU1LCAvKiAyICovDQo+ID4+IC0JMHg2NjU1NTU1NSwgLyog
MyAqLw0KPiA+PiAtCTB4NjY1NTY2NTUsIC8qIDQgKi8NCj4gPj4gLQkweDVhNWE1YTVhLCAvKiA1
ICovDQo+ID4+IC0JMHg1YTVhNWFhYSwgLyogNiAqLw0KPiA+PiAtCTB4YWE1YTVhNWEsIC8qIDcg
Ki8NCj4gPj4gLQkweDZhNWE1YTVhLCAvKiA4ICovDQo+ID4+IC0JMHg2YTVhNWFhYSwgLyogOSAq
Lw0KPiA+PiAtCTB4NmE1YTZhNWEsIC8qIDEwICovDQo+ID4+IC0JMHg2YTVhNmFhYSwgLyogMTEg
Ki8NCj4gPj4gLQkweDZhZmE1YWZhLCAvKiAxMiAqLw0KPiA+PiAtCTB4YWFhYTVhYWEsIC8qIDEz
ICovDQo+ID4+IC0JMHhhYWZmZmZhYSwgLyogMTQgKi8NCj4gPj4gLQkweGFhNTU1NWFhLCAvKiAx
NSAqLw0KPiA+PiAtCTB4ZmFmYWZhZmEsIC8qIDE2ICovDQo+ID4+IC0JMHhmZmZmZGRmZiwgLyog
MTcgKi8NCj4gPj4gLQkweGRhZmZkYWZmLCAvKiAxOCAqLw0KPiA+PiAtCTB4ZmFmYWRhZmEgIC8q
IDE5ICovDQo+ID4+ICsJWzBdICA9IDB4ZmZmZmZmZmYsDQo+ID4+ICsJWzFdICA9IDB4YWFhYWFh
YWEsDQo+ID4+ICsJWzJdICA9IDB4NTU1NTU1NTUsDQo+ID4+ICsJWzNdICA9IDB4NjY1NTU1NTUs
DQo+ID4+ICsJWzRdICA9IDB4NjY1NTY2NTUsDQo+ID4+ICsJWzVdICA9IDB4NWE1YTVhNWEsDQo+
ID4+ICsJWzZdICA9IDB4NWE1YTVhYWEsDQo+ID4+ICsJWzddICA9IDB4YWE1YTVhNWEsDQo+ID4+
ICsJWzhdICA9IDB4NmE1YTVhNWEsDQo+ID4+ICsJWzldICA9IDB4NmE1YTVhYWEsDQo+ID4+ICsJ
WzEwXSA9IDB4NmE1YTZhNWEsDQo+ID4+ICsJWzExXSA9IDB4NmE1YTZhYWEsDQo+ID4+ICsJWzEy
XSA9IDB4NmFmYTVhZmEsDQo+ID4+ICsJWzEzXSA9IDB4YWFhYTVhYWEsDQo+ID4+ICsJWzE0XSA9
IDB4YWFmZmZmYWEsDQo+ID4+ICsJWzE1XSA9IDB4YWE1NTU1YWEsDQo+ID4+ICsJWzE2XSA9IDB4
ZmFmYWZhZmEsDQo+ID4+ICsJWzE3XSA9IDB4ZmZmZmRkZmYsDQo+ID4+ICsJWzE4XSA9IDB4ZGFm
ZmRhZmYsDQo+ID4+ICsJWzE5XSA9IDB4ZmFmYWRhZmENCj4gPj4gICB9Ow0KPiA+PiAgICAgc3Ry
dWN0IHJ0dzg5X2J0Y19idGZfdGx2IHsNCj4gPg0KPiA+DQo+ID4gSXMgdGhpcyBjaGFuZ2UgcmVh
bGx5IG5lY2Vzc2FyeT8gWWVzLCB0aGUgZW50cmllcyBtdXN0IGJlIG9yZGVyZWQ7DQo+ID4gaG93
ZXZlciwgdGhlIGNvbW1lbnQgY2FycmllcyB0aGF0IGluZm9ybWF0aW9uIGF0IHZlcnkgZmV3IGV4
dHJhDQo+ID4gY2hhcmFjdGVycy4gVG8gbWUsIHRoaXMgcGF0Y2ggbG9va3MgbGlrZSB1bm5lZWRl
ZCBzb3VyY2UgY2h1cm4uDQo+IA0KPiBPbmUgc21hbGwgYmVuZWZpdCBJIHNlZSBpcyB0byBhdm9p
ZCB0aGUgY29tbWVudCBpbmRleCBiZWluZyB3cm9uZyBhbmQNCj4gdGhlcmUgd291bGQgYmUgbm8g
d2F5IHRvIGNhdGNoIHRoYXQuIEJ1dCBvdGhlcndpc2UgSSBkb24ndCBoYXZlIGFueQ0KPiBvcGlu
aW9uIGFib3V0IHRoaXMuDQoNCklmIHRoZSBbbm5dIGFyZSB3cm9uZyB0aGUgZWZmZWN0IGlzIHBy
b2JhYmx5IHdvcnNlLg0KWW91IHJlYWxseSBkb24ndCB3YW50IGEgZ2FwIQ0KDQpEb2Vzbid0IHNl
ZW0gd29ydGggdXNpbmcgQzk5IGluaXRpYWxpc2VycyB1bmxlc3MgdGhleSBhcmUNCiNkZWZpbmVz
IG9yIGVudW0gdmFsdWVzLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2Vz
aWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVL
DQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

