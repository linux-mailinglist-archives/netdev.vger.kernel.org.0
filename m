Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 011034EC75C
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 16:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347334AbiC3OwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 10:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347266AbiC3Ovy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 10:51:54 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 186DF275E2
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 07:50:07 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-136-sIRC0DlJN0S4pc-bPv8wSQ-1; Wed, 30 Mar 2022 15:50:04 +0100
X-MC-Unique: sIRC0DlJN0S4pc-bPv8wSQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Wed, 30 Mar 2022 15:50:02 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Wed, 30 Mar 2022 15:50:02 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Guenter Roeck' <linux@roeck-us.net>,
        Michael Walle <michael@walle.cc>,
        "Xu Yilun" <yilun.xu@intel.com>, Tom Rix <trix@redhat.com>,
        Jean Delvare <jdelvare@suse.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     "linux-hwmon@vger.kernel.org" <linux-hwmon@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 1/5] hwmon: introduce hwmon_sanitize_name()
Thread-Topic: [PATCH v2 1/5] hwmon: introduce hwmon_sanitize_name()
Thread-Index: AQHYREG1rIB0cQMH/kajVzJ0H3I8wazYAMOg
Date:   Wed, 30 Mar 2022 14:50:02 +0000
Message-ID: <02545bf1c21b45f78eba5e8b37951748@AcuMS.aculab.com>
References: <20220329160730.3265481-1-michael@walle.cc>
 <20220329160730.3265481-2-michael@walle.cc>
 <75093b82-4625-d806-a4ea-372b74e60c3b@roeck-us.net>
In-Reply-To: <75093b82-4625-d806-a4ea-372b74e60c3b@roeck-us.net>
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

RnJvbTogR3VlbnRlciBSb2Vjaw0KPiBTZW50OiAzMCBNYXJjaCAyMDIyIDE1OjIzDQo+IE9uIDMv
MjkvMjIgMDk6MDcsIE1pY2hhZWwgV2FsbGUgd3JvdGU6DQo+ID4gTW9yZSBhbmQgbW9yZSBkcml2
ZXJzIHdpbGwgY2hlY2sgZm9yIGJhZCBjaGFyYWN0ZXJzIGluIHRoZSBod21vbiBuYW1lDQo+ID4g
YW5kIGFsbCBhcmUgdXNpbmcgdGhlIHNhbWUgY29kZSBzbmlwcGV0LiBDb25zb2xpZGF0ZSB0aGF0
IGNvZGUgYnkgYWRkaW5nDQo+ID4gYSBuZXcgaHdtb25fc2FuaXRpemVfbmFtZSgpIGZ1bmN0aW9u
Lg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogTWljaGFlbCBXYWxsZSA8bWljaGFlbEB3YWxsZS5j
Yz4NCj4gPiAtLS0NCj4gPiAgIERvY3VtZW50YXRpb24vaHdtb24vaHdtb24ta2VybmVsLWFwaS5y
c3QgfCAgOSArKysrLQ0KPiA+ICAgZHJpdmVycy9od21vbi9od21vbi5jICAgICAgICAgICAgICAg
ICAgICB8IDQ5ICsrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ICAgaW5jbHVkZS9saW51eC9o
d21vbi5oICAgICAgICAgICAgICAgICAgICB8ICAzICsrDQo+ID4gICAzIGZpbGVzIGNoYW5nZWQs
IDYwIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9E
b2N1bWVudGF0aW9uL2h3bW9uL2h3bW9uLWtlcm5lbC1hcGkucnN0IGIvRG9jdW1lbnRhdGlvbi9o
d21vbi9od21vbi1rZXJuZWwtYXBpLnJzdA0KPiA+IGluZGV4IGM0MWViNjEwODEwMy4uMTJmNGE5
YmNlZjA0IDEwMDY0NA0KPiA+IC0tLSBhL0RvY3VtZW50YXRpb24vaHdtb24vaHdtb24ta2VybmVs
LWFwaS5yc3QNCj4gPiArKysgYi9Eb2N1bWVudGF0aW9uL2h3bW9uL2h3bW9uLWtlcm5lbC1hcGku
cnN0DQo+ID4gQEAgLTUwLDYgKzUwLDEwIEBAIHJlZ2lzdGVyL3VucmVnaXN0ZXIgZnVuY3Rpb25z
OjoNCj4gPg0KPiA+ICAgICB2b2lkIGRldm1faHdtb25fZGV2aWNlX3VucmVnaXN0ZXIoc3RydWN0
IGRldmljZSAqZGV2KTsNCj4gPg0KPiA+ICsgIGNoYXIgKmh3bW9uX3Nhbml0aXplX25hbWUoY29u
c3QgY2hhciAqbmFtZSk7DQo+ID4gKw0KPiA+ICsgIGNoYXIgKmRldm1faHdtb25fc2FuaXRpemVf
bmFtZShzdHJ1Y3QgZGV2aWNlICpkZXYsIGNvbnN0IGNoYXIgKm5hbWUpOw0KPiA+ICsNCj4gPiAg
IGh3bW9uX2RldmljZV9yZWdpc3Rlcl93aXRoX2dyb3VwcyByZWdpc3RlcnMgYSBoYXJkd2FyZSBt
b25pdG9yaW5nIGRldmljZS4NCj4gPiAgIFRoZSBmaXJzdCBwYXJhbWV0ZXIgb2YgdGhpcyBmdW5j
dGlvbiBpcyBhIHBvaW50ZXIgdG8gdGhlIHBhcmVudCBkZXZpY2UuDQo+ID4gICBUaGUgbmFtZSBw
YXJhbWV0ZXIgaXMgYSBwb2ludGVyIHRvIHRoZSBod21vbiBkZXZpY2UgbmFtZS4gVGhlIHJlZ2lz
dHJhdGlvbg0KPiA+IEBAIC05Myw3ICs5NywxMCBAQCByZW1vdmFsIHdvdWxkIGJlIHRvbyBsYXRl
Lg0KPiA+DQo+ID4gICBBbGwgc3VwcG9ydGVkIGh3bW9uIGRldmljZSByZWdpc3RyYXRpb24gZnVu
Y3Rpb25zIG9ubHkgYWNjZXB0IHZhbGlkIGRldmljZQ0KPiA+ICAgbmFtZXMuIERldmljZSBuYW1l
cyBpbmNsdWRpbmcgaW52YWxpZCBjaGFyYWN0ZXJzICh3aGl0ZXNwYWNlLCAnKicsIG9yICctJykN
Cj4gPiAtd2lsbCBiZSByZWplY3RlZC4gVGhlICduYW1lJyBwYXJhbWV0ZXIgaXMgbWFuZGF0b3J5
Lg0KPiA+ICt3aWxsIGJlIHJlamVjdGVkLiBUaGUgJ25hbWUnIHBhcmFtZXRlciBpcyBtYW5kYXRv
cnkuIEJlZm9yZSBjYWxsaW5nIGENCj4gPiArcmVnaXN0ZXIgZnVuY3Rpb24geW91IHNob3VsZCBl
aXRoZXIgdXNlIGh3bW9uX3Nhbml0aXplX25hbWUgb3INCj4gPiArZGV2bV9od21vbl9zYW5pdGl6
ZV9uYW1lIHRvIHJlcGxhY2UgYW55IGludmFsaWQgY2hhcmFjdGVycyB3aXRoIGFuDQo+ID4gK3Vu
ZGVyc2NvcmUuDQo+IA0KPiBUaGF0IG5lZWRzIG1vcmUgZGV0YWlscyBhbmQgZGVzZXJ2ZXMgaXRz
IG93biBwYXJhZ3JhcGguIENhbGxpbmcgb25lIG9mDQo+IHRoZSBmdW5jdGlvbnMgaXMgb25seSBu
ZWNlc3NhcnkgaWYgdGhlIG9yaWdpbmFsIG5hbWUgZG9lcyBvciBjYW4gaW5jbHVkZQ0KPiB1bnN1
cHBvcnRlZCBjaGFyYWN0ZXJzOyBhbiB1bmNvbmRpdGlvbmFsICJzaG91bGQiIGlzIHRoZXJlZm9y
ZSBhIGJpdA0KPiBzdHJvbmcuIEFsc28sIGl0IGlzIGltcG9ydGFudCB0byBtZW50aW9uIHRoYXQg
dGhlIGZ1bmN0aW9uIGR1cGxpY2F0ZXMNCj4gdGhlIG5hbWUsIGFuZCB0aGF0IGl0IGlzIHRoZSBy
ZXNwb25zaWJpbGl0eSBvZiB0aGUgY2FsbGVyIHRvIHJlbGVhc2UNCj4gdGhlIG5hbWUgaWYgaHdt
b25fc2FuaXRpemVfbmFtZSgpIHdhcyBjYWxsZWQgYW5kIHRoZSBkZXZpY2UgaXMgcmVtb3ZlZC4N
Cg0KTW9yZSB3b3JyeWluZywgYW5kIG5vdCBkb2N1bWVudGVkLCBpcyB0aGF0IHRoZSBidWZmZXIg
J25hbWUnIHBvaW50cw0KdG8gbXVzdCBwZXJzaXN0Lg0KDQpJU1RNIHRoYXQgdGhlIGttYWxsb2Mo
KSBpbiBfX2h3bW9uX2RldmljZV9yZWdpc3RlcigpIHNob3VsZCBpbmNsdWRlDQpzcGFjZSBmb3Ig
YSBjb3B5IG9mIHRoZSBuYW1lLg0KSXQgY2FuIHRoZW4gZG8gd2hhdCBpdCB3aWxsIHdpdGggd2hh
dGV2ZXIgaXMgcGFzc2VkIGluLg0KDQpPaCB5ZXMsIGl0IGhhcyBteSAnZmF2b3VyaXRlIGNvbnN0
cnVjdCc6ICBpZiAoIXN0cmxlbihuYW1lKSkgLi4uDQood2VsbCBzdHJbc3RybGVuKHN0cildID0g
MCBhbHNvIGhhcHBlbnMhKQ0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2Vz
aWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVL
DQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

