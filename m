Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F05744BA413
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 16:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242248AbiBQPPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 10:15:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239181AbiBQPPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 10:15:30 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2BF042A228B
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 07:15:15 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-93-EQ4SPIr8P7WTnj341oLK3g-1; Thu, 17 Feb 2022 15:15:13 +0000
X-MC-Unique: EQ4SPIr8P7WTnj341oLK3g-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Thu, 17 Feb 2022 15:15:12 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Thu, 17 Feb 2022 15:15:12 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christophe Leroy' <christophe.leroy@csgroup.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net v3] net: Force inlining of checksum functions in
 net/checksum.h
Thread-Topic: [PATCH net v3] net: Force inlining of checksum functions in
 net/checksum.h
Thread-Index: AQHYI/ioJk+yETn/QkyN152xjKaZ96yXvR4wgAAXuo+AAALtMA==
Date:   Thu, 17 Feb 2022 15:15:11 +0000
Message-ID: <3c2b682a7d804b5e8749428b50342c82@AcuMS.aculab.com>
References: <978951d76d8cb84bab347c7623bc163e9a038452.1645100305.git.christophe.leroy@csgroup.eu>
 <35bcd5df0fb546008ff4043dbea68836@AcuMS.aculab.com>
 <d38e5e1c-29b6-8cc6-7409-d0bdd5772f23@csgroup.eu>
 <9b8ef186-c7fe-822c-35df-342c9e86cc88@csgroup.eu>
In-Reply-To: <9b8ef186-c7fe-822c-35df-342c9e86cc88@csgroup.eu>
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQ2hyaXN0b3BoZSBMZXJveQ0KPiBTZW50OiAxNyBGZWJydWFyeSAyMDIyIDE0OjU1DQo+
IA0KPiBMZSAxNy8wMi8yMDIyIMOgIDE1OjUwLCBDaHJpc3RvcGhlIExlcm95IGEgw6ljcml0wqA6
DQo+ID4gQWRkaW5nIEluZ28sIEFuZHJldyBhbmQgTmljayBhcyB0aGV5IHdlcmUgaW52b2x2ZWQg
aW4gdGhlIHN1YmpldCwNCj4gPg0KPiA+IExlIDE3LzAyLzIwMjIgw6AgMTQ6MzYsIERhdmlkIExh
aWdodCBhIMOpY3JpdMKgOg0KPiA+PiBGcm9tOiBDaHJpc3RvcGhlIExlcm95DQo+ID4+PiBTZW50
OiAxNyBGZWJydWFyeSAyMDIyIDEyOjE5DQo+ID4+Pg0KPiA+Pj4gQWxsIGZ1bmN0aW9ucyBkZWZp
bmVkIGFzIHN0YXRpYyBpbmxpbmUgaW4gbmV0L2NoZWNrc3VtLmggYXJlDQo+ID4+PiBtZWFudCB0
byBiZSBpbmxpbmVkIGZvciBwZXJmb3JtYW5jZSByZWFzb24uDQo+ID4+Pg0KPiA+Pj4gQnV0IHNp
bmNlIGNvbW1pdCBhYzdjM2U0ZmY0MDEgKCJjb21waWxlcjogZW5hYmxlDQo+ID4+PiBDT05GSUdf
T1BUSU1JWkVfSU5MSU5JTkcgZm9yY2libHkiKSB0aGUgY29tcGlsZXIgaXMgYWxsb3dlZCB0bw0K
PiA+Pj4gdW5pbmxpbmUgZnVuY3Rpb25zIHdoZW4gaXQgd2FudHMuDQo+ID4+Pg0KPiA+Pj4gRmFp
ciBlbm91Z2ggaW4gdGhlIGdlbmVyYWwgY2FzZSwgYnV0IGZvciB0aW55IHBlcmZvcm1hbmNlIGNy
aXRpY2FsDQo+ID4+PiBjaGVja3N1bSBoZWxwZXJzIHRoYXQncyBjb3VudGVyLXByb2R1Y3RpdmUu
DQo+ID4+DQo+ID4+IFRoZXJlIGlzbid0IGEgcmVhbCBqdXN0aWZpY2F0aW9uIGZvciBhbGxvd2lu
ZyB0aGUgY29tcGlsZXINCj4gPj4gdG8gJ25vdCBpbmxpbmUnIGZ1bmN0aW9ucyBpbiB0aGF0IGNv
bW1pdC4NCj4gPg0KPiA+IERvIHlvdSBtZWFuIHRoYXQgdGhlIHR3byBmb2xsb3dpbmcgY29tbWl0
cyBzaG91bGQgYmUgcmV2ZXJ0ZWQ6DQo+ID4NCj4gPiAtIDg4OWIzYzEyNDVkZSAoImNvbXBpbGVy
OiByZW1vdmUgQ09ORklHX09QVElNSVpFX0lOTElOSU5HIGVudGlyZWx5IikNCj4gPiAtIDRjNGUy
NzZmNjQ5MSAoIm5ldDogRm9yY2UgaW5saW5pbmcgb2YgY2hlY2tzdW0gZnVuY3Rpb25zIGluDQo+
ID4gbmV0L2NoZWNrc3VtLmgiKQ0KPiANCj4gT2YgY291cnNlIG5vdCB0aGUgYWJvdmUgb25lIChj
b3B5L3Bhc3RlIGVycm9yKSwgYnV0Og0KPiAtIGFjN2MzZTRmZjQwMSAoImNvbXBpbGVyOiBlbmFi
bGUgQ09ORklHX09QVElNSVpFX0lOTElOSU5HIGZvcmNpYmx5IikNCg0KVGhhdCdzIHRoZSBvbmUg
SSBsb29rZWQgYXQuDQoNCj4gPj4gSXQgcmF0aGVyIHNlZW1zIGJhY2t3YXJkcy4NCj4gPj4gVGhl
IGtlcm5lbCBzb3VyY2VzIGRvbid0IHJlYWxseSBoYXZlIGFueXRoaW5nIG1hcmtlZCAnaW5saW5l
Jw0KPiA+PiB0aGF0IHNob3VsZG4ndCBhbHdheXMgYmUgaW5saW5lZC4NCj4gPj4gSWYgdGhlcmUg
YXJlIGFueSBzdWNoIGZ1bmN0aW9ucyB0aGV5IGFyZSBmZXcgYW5kIGZhciBiZXR3ZWVuLg0KPiA+
Pg0KPiA+PiBJJ3ZlIGhhZCBlbm91Z2ggdHJvdWJsZSAoZWxzZXdoZXJlKSBnZXR0aW5nIGdjYyB0
byBpbmxpbmUNCj4gPj4gc3RhdGljIGZ1bmN0aW9ucyB0aGF0IGFyZSBvbmx5IGNhbGxlZCBvbmNl
Lg0KPiA+PiBJIGVuZGVkIHVwIHVzaW5nICdhbHdheXNfaW5saW5lJy4NCj4gPj4gKFRoYXQgaXMg
NGsgb2YgZW1iZWRkZWQgb2JqZWN0IGNvZGUgdGhhdCB3aWxsIGJlIHRvbyBzbG93DQo+ID4+IGlm
IGl0IGV2ZXIgc3BpbGxzIGEgcmVnaXN0ZXIgdG8gc3RhY2suKQ0KPiA+Pg0KPiA+DQo+ID4gSSBh
Z3JlZSB3aXRoIHlvdSB0aGF0IHRoYXQgY2hhbmdlIGlzIGEgbmlnaHRtYXJlIHdpdGggbWFueSBz
bWFsbA0KPiA+IGZ1bmN0aW9ucyB0aGF0IHdlIHJlYWxseSB3YW50IGlubGluZWQsIGFuZCB3aGVu
IHdlIGZvcmNlIGlubGluaW5nIHdlDQo+ID4gbW9zdCBvZiB0aGUgdGltZSBnZXQgYSBzbWFsbGVy
IGJpbmFyeS4NCj4gPg0KPiA+IEFuZCBpdCBiZWNvbWVzIGV2ZW4gbW9yZSBwcm9ibGVtYXRpYyB3
aGVuIHdlIHN0YXJ0IGFkZGluZw0KPiA+IGluc3RydW1lbnRhdGlvbiBsaWtlIHN0YWNrIHByb3Rl
Y3Rvci4NCj4gPg0KPiA+IEFjY29yZGluZyB0byB0aGUgb3JpZ2luYWwgY29tbWl0cyBob3dldmVy
IHRoaXMgd2FzIHN1cHBvc2VkIHRvIHByb3ZpZGUNCj4gPiByZWFsIGJlbmVmaXQ6DQo+ID4NCj4g
PiAtIDYwYTNjZGQwNjM5NCAoIng4NjogYWRkIG9wdGltaXplZCBpbmxpbmluZyIpDQo+ID4gLSA5
MDEyZDAxMTY2MGUgKCJjb21waWxlcjogYWxsb3cgYWxsIGFyY2hlcyB0byBlbmFibGUNCj4gPiBD
T05GSUdfT1BUSU1JWkVfSU5MSU5JTkciKQ0KPiA+DQo+ID4gQnV0IHdoZW4gSSBidWlsZCBwcGM2
NGxlX2RlZmNvbmZpZyArIENPTkZJR19DQ19PUFRJTUlTRV9GT1JfU0laRSBJIGdldDoNCj4gPiAg
wqDCoMKgIDExMiB0aW1lc8KgIHF1ZXVlZF9zcGluX3VubG9jaygpDQo+ID4gIMKgwqDCoCAxMjIg
dGltZXPCoCBtbWlvd2Jfc3Bpbl91bmxvY2soKQ0KPiA+ICDCoMKgwqAgMTUxIHRpbWVzwqAgY3B1
X29ubGluZSgpDQo+ID4gIMKgwqDCoCAyMjUgdGltZXPCoCBfX3Jhd19zcGluX3VubG9jaygpDQoN
ClllcywgeW91IGVpdGhlciB3YW50IHRoZW0gaW5saW5lZCwgb3IgYSBzaW5nbGUgY29weSBvZiB0
aGUgcmVhbCBmdW5jdGlvbi4NCkkgaGF2ZSBzZWVuIGEgbGlua2VyIGRlLWR1cGxpY2F0ZSBmdW5j
dGlvbnMgd2l0aCBpZGVudGljYWwgYm9kaWVzLg0KQnV0IEkgZG9uJ3QgdGhhdCBnbGQgZG9lcyB0
aGF0IGZvciB0aGUga2VybmVsLg0KKFdhcyBjb25mdXNpbmcgYmVjYXVzZSBib3RoIGRpZCBzdHJ1
Y3R1cmUtPm1lbWJlciA9IDAgYnV0IGZvciBlbnRpcmVseQ0KZGlmZmVyZW50IHR5cGVzLikNCg0K
PiA+IFNvIEkgd2FzIHdvbmRlcmluZywgd291bGQgd2UgaGF2ZSBhIHdheSB0byBmb3JjZSBpbmxp
bmluZyBvZiBmdW5jdGlvbnMNCj4gPiBtYXJrZWQgaW5saW5lIGluIGhlYWRlciBmaWxlcyB3aGls
ZSBsZWF2aW5nIEdDQyBoYW5kbGluZyB0aGUgb25lcyBpbiBDDQo+ID4gZmlsZXMgdGhlIHdheSBp
dCB3YW50cyA/DQoNClRoZSB2aWV3IGZvciB0aG9zZSAoaW4gbmV0ZGV2IGF0IGxlYXN0KSBpcyBq
dXN0IG5vdCB0byBtYXJrIHRoZSBpbmxpbmUNCmFuZCBsZXQgdGhlIGNvbXBpbGVyIGRlY2lkZS4N
CkFsdGhvdWdoLCBJTUhPLCBpdCB0ZW5kcyB0byBnZXQgaXQgd3JvbmcgcXVpdGUgb2Z0ZW4uDQpP
ZnRlbiBiZWNhdXNlIGl0IGRlY2lkZXMgbm90IHRvIGlubGluZSBiZWZvcmUgdGhlIG9wdGltaXNl
cg0KcmVtb3ZlcyBhbGwgdGhlIGNvbnN0YW50IGNvbmRpdGlvbmFscy4NCg0KS2VybmVsIGRldmVs
b3BlcnMgb3VnaHQgdG8gYmUgY2xldmVyIGVub3VnaCB0byBub3QgaW5saW5lDQpmdW5jdGlvbnMg
dGhhdCBhcmUgYmlnLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRl
LCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpS
ZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

