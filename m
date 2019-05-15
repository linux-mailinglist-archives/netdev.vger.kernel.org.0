Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBF01F249
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 14:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730206AbfEOMBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 08:01:43 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:23067 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729176AbfEOLNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 07:13:53 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-17-7-hwOp_fMoOm1VVMCmE2cQ-1; Wed, 15 May 2019 12:13:51 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Wed,
 15 May 2019 12:13:50 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 15 May 2019 12:13:50 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Robin Murphy' <robin.murphy@arm.com>,
        'Will Deacon' <will.deacon@arm.com>
CC:     Zhangshaokun <zhangshaokun@hisilicon.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "huanglingyan (A)" <huanglingyan2@huawei.com>,
        "steve.capper@arm.com" <steve.capper@arm.com>
Subject: RE: [PATCH] arm64: do_csum: implement accelerated scalar version
Thread-Topic: [PATCH] arm64: do_csum: implement accelerated scalar version
Thread-Index: AQHVCwMrtYHa1Y0LVUWOb1uB691U/KZr90eg///8CQCAABRdMA==
Date:   Wed, 15 May 2019 11:13:50 +0000
Message-ID: <9f72aecd99e74c1a939df6562ed9c18c@AcuMS.aculab.com>
References: <20190218230842.11448-1-ard.biesheuvel@linaro.org>
 <d7a16ebd-073f-f50e-9651-68606d10b01c@hisilicon.com>
 <20190412095243.GA27193@fuggles.cambridge.arm.com>
 <41b30c72-c1c5-14b2-b2e1-3507d552830d@arm.com>
 <20190515094704.GC24357@fuggles.cambridge.arm.com>
 <6e755b2daaf341128cb3b54f36172442@AcuMS.aculab.com>
 <3d4fdbb5-7c7f-9331-187e-14c09dd1c18d@arm.com>
In-Reply-To: <3d4fdbb5-7c7f-9331-187e-14c09dd1c18d@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: 7-hwOp_fMoOm1VVMCmE2cQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUm9iaW4gTXVycGh5DQo+IFNlbnQ6IDE1IE1heSAyMDE5IDExOjU4DQo+IFRvOiBEYXZp
ZCBMYWlnaHQ7ICdXaWxsIERlYWNvbicNCj4gQ2M6IFpoYW5nc2hhb2t1bjsgQXJkIEJpZXNoZXV2
ZWw7IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsgbmV0ZGV2QHZnZXIua2Vy
bmVsLm9yZzsNCj4gaWxpYXMuYXBhbG9kaW1hc0BsaW5hcm8ub3JnOyBodWFuZ2xpbmd5YW4gKEEp
OyBzdGV2ZS5jYXBwZXJAYXJtLmNvbQ0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBhcm02NDogZG9f
Y3N1bTogaW1wbGVtZW50IGFjY2VsZXJhdGVkIHNjYWxhciB2ZXJzaW9uDQo+IA0KPiBPbiAxNS8w
NS8yMDE5IDExOjE1LCBEYXZpZCBMYWlnaHQgd3JvdGU6DQo+ID4gLi4uDQo+ID4+PiAJcHRyID0g
KHU2NCAqKShidWZmIC0gb2Zmc2V0KTsNCj4gPj4+IAlzaGlmdCA9IG9mZnNldCAqIDg7DQo+ID4+
Pg0KPiA+Pj4gCS8qDQo+ID4+PiAJICogSGVhZDogemVybyBvdXQgYW55IGV4Y2VzcyBsZWFkaW5n
IGJ5dGVzLiBTaGlmdGluZyBiYWNrIGJ5IHRoZSBzYW1lDQo+ID4+PiAJICogYW1vdW50IHNob3Vs
ZCBiZSBhdCBsZWFzdCBhcyBmYXN0IGFzIGFueSBvdGhlciB3YXkgb2YgaGFuZGxpbmcgdGhlDQo+
ID4+PiAJICogb2RkL2V2ZW4gYWxpZ25tZW50LCBhbmQgbWVhbnMgd2UgY2FuIGlnbm9yZSBpdCB1
bnRpbCB0aGUgdmVyeSBlbmQuDQo+ID4+PiAJICovDQo+ID4+PiAJZGF0YSA9ICpwdHIrKzsNCj4g
Pj4+ICNpZmRlZiBfX0xJVFRMRV9FTkRJQU4NCj4gPj4+IAlkYXRhID0gKGRhdGEgPj4gc2hpZnQp
IDw8IHNoaWZ0Ow0KPiA+Pj4gI2Vsc2UNCj4gPj4+IAlkYXRhID0gKGRhdGEgPDwgc2hpZnQpID4+
IHNoaWZ0Ow0KPiA+Pj4gI2VuZGlmDQo+ID4NCj4gPiBJIHN1c3BlY3QgdGhhdA0KPiA+ICNpZmRl
ZiBfX0xJVFRMRV9FTkRJQU4NCj4gPiAJZGF0YSAmPSB+MHVsbCA8PCBzaGlmdDsNCj4gPiAjZWxz
ZQ0KPiA+IAlkYXRhICY9IH4wdWxsID4+IHNoaWZ0Ow0KPiA+ICNlbmRpZg0KPiA+IGlzIGxpa2Vs
eSB0byBiZSBiZXR0ZXIuDQo+IA0KPiBPdXQgb2YgaW50ZXJlc3QsIGJldHRlciBpbiB3aGljaCBy
ZXNwZWN0cz8gRm9yIHRoZSBBNjQgSVNBIGF0IGxlYXN0LA0KPiB0aGF0IHdvdWxkIHRha2UgMyBp
bnN0cnVjdGlvbnMgcGx1cyBhbiBhZGRpdGlvbmFsIHNjcmF0Y2ggcmVnaXN0ZXIsIGUuZy46DQo+
IA0KPiAJTU9WCXgyLCAjfjANCj4gCUxTTAl4MiwgeDIsIHgxDQo+IAlBTkQJeDAsIHgwLCB4MQ0K
PiANCj4gKGFsdGVybmF0aXZlbHkgIkFORCB4MCwgeDAsIHgxIExTTCB4MiIgdG8gc2F2ZSA0IGJ5
dGVzIG9mIGNvZGUsIGJ1dCB0aGF0DQo+IHdpbGwgdHlwaWNhbGx5IHRha2UgYXMgbWFueSBjeWNs
ZXMgaWYgbm90IG1vcmUgdGhhbiBqdXN0IHBpcGVsaW5pbmcgdGhlDQo+IHR3byAnc2ltcGxlJyBB
TFUgaW5zdHJ1Y3Rpb25zKQ0KPiANCj4gV2hlcmVhcyB0aGUgb3JpZ2luYWwgaXMganVzdCB0d28g
c2hpZnQgaW5zdHJ1Y3Rpb24gaW4tcGxhY2UuDQo+IA0KPiAJTFNSCXgwLCB4MCwgeDENCj4gCUxT
TAl4MCwgeDAsIHgxDQo+IA0KPiBJZiB0aGUgb3BlcmF0aW9uIHdlcmUgcmVwZWF0ZWQsIHRoZSBj
b25zdGFudCBnZW5lcmF0aW9uIGNvdWxkIGNlcnRhaW5seQ0KPiBiZSBhbW9ydGlzZWQgb3ZlciBt
dWx0aXBsZSBzdWJzZXF1ZW50IEFORHMgZm9yIGEgbmV0IHdpbiwgYnV0IHRoYXQgaXNuJ3QNCj4g
dGhlIGNhc2UgaGVyZS4NCg0KT24gYSBzdXBlcnNjYWxlciBwcm9jZXNzb3IgeW91IHJlZHVjZSB0
aGUgcmVnaXN0ZXIgZGVwZW5kZW5jeQ0KY2hhaW4gYnkgb25lIGluc3RydWN0aW9uLg0KVGhlIG9y
aWdpbmFsIGNvZGUgaXMgcHJldHR5IG11Y2ggYSBzaW5nbGUgZGVwZW5kZW5jeSBjaGFpbiBzbw0K
eW91IGFyZSBsaWtlbHkgdG8gYmUgYWJsZSB0byBnZW5lcmF0ZSB0aGUgbWFzayAnZm9yIGZyZWUn
Lg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJv
YWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24g
Tm86IDEzOTczODYgKFdhbGVzKQ0K

