Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8133363BC3C
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 09:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbiK2IzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 03:55:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231785AbiK2Iyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 03:54:54 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CB459FE6
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:54:30 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-72-_IDLqBNPPYKl1T-dLqul3w-1; Tue, 29 Nov 2022 08:54:27 +0000
X-MC-Unique: _IDLqBNPPYKl1T-dLqul3w-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 29 Nov
 2022 08:54:25 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.044; Tue, 29 Nov 2022 08:54:25 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jacob Keller' <jacob.e.keller@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: RE: [PATCH net-next v2 1/9] devlink: use min_t to calculate data_size
Thread-Topic: [PATCH net-next v2 1/9] devlink: use min_t to calculate
 data_size
Thread-Index: AQHY/3u0GPIWenbZ/0+Xu9BNaPVoNq5OnL0QgAYTcACAAO/9oA==
Date:   Tue, 29 Nov 2022 08:54:25 +0000
Message-ID: <4fead34adb0a4461a7800a121b4642e0@AcuMS.aculab.com>
References: <20221123203834.738606-1-jacob.e.keller@intel.com>
 <20221123203834.738606-2-jacob.e.keller@intel.com>
 <d561b49935234451ac062f9f12c50e83@AcuMS.aculab.com>
 <395aa6d3-c423-266e-28e1-43f8d66dce2a@intel.com>
In-Reply-To: <395aa6d3-c423-266e-28e1-43f8d66dce2a@intel.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSmFjb2IgS2VsbGVyDQo+IFNlbnQ6IDI4IE5vdmVtYmVyIDIwMjIgMTg6MzENCj4gDQo+
IE9uIDExLzI0LzIwMjIgMTo1MyBQTSwgRGF2aWQgTGFpZ2h0IHdyb3RlOg0KPiA+IEZyb206IEph
Y29iIEtlbGxlcg0KPiA+PiBTZW50OiAyMyBOb3ZlbWJlciAyMDIyIDIwOjM4DQo+ID4+DQo+ID4+
IFRoZSBjYWxjdWxhdGlvbiBmb3IgdGhlIGRhdGFfc2l6ZSBpbiB0aGUgZGV2bGlua19ubF9yZWFk
X3NuYXBzaG90X2ZpbGwNCj4gPj4gZnVuY3Rpb24gdXNlcyBhbiBpZiBzdGF0ZW1lbnQgdGhhdCBp
cyBiZXR0ZXIgZXhwcmVzc2VkIHVzaW5nIHRoZSBtaW5fdA0KPiA+PiBtYWNyby4NCj4gPg0KPiA+
IFRoZXJlIG91Z2h0IHRvIGJlIGEgJ2R1Y2sgc2hvb3QnIGFycmFuZ2VkIGZvciBhbGwgdXNlcyBv
ZiBtaW5fdCgpLg0KPiA+IEkgd2FzIHRlc3RpbmcgYSBwYXRjaCAoSSBtaWdodCBzdWJtaXQgbmV4
dCB3ZWVrKSB0aGF0IHJlbGF4ZXMgdGhlDQo+ID4gY2hlY2tzIGluIG1pbigpIHNvIHRoYXQgaXQg
ZG9lc24ndCBlcnJvciBhIGxvdCBvZiB2YWxpZCBjYXNlcy4NCj4gPiBJbiBwYXJ0aWN1bGFyIGEg
cG9zaXRpdmUgaW50ZWdlciBjb25zdGFudCBjYW4gYWx3YXlzIGJlIGNhc3QgdG8gKGludCkNCj4g
PiBhbmQgdGhlIGNvbXBhcmUgd2lsbCBEVFJULg0KPiA+DQo+ID4gSSBmb3VuZCB0aGluZ3MgbGlr
ZSBtaW5fdCh1MzIsIHUzMl9sZW5ndGgsIHU2NF9saW1pdCkgd2hlcmUNCj4gPiB5b3UgcmVhbGx5
IGRvbid0IHdhbnQgdG8gbWFzayB0aGUgbGltaXQgZG93bi4NCj4gPiBUaGVyZSBhcmUgYWxzbyB0
aGUgbWluX3QodTgsIC4uLikgYW5kIG1pbl90KHUxNiwgLi4uKS4NCj4gPg0KPiANCj4gV291bGRu
J3QgdGhhdCBleGFtcGxlIGp1c3Qgd2FudCB0byBiZSBtaW5fdCh1NjQsIC4uLik/DQoNClRoYXQg
aXMgd2hhdCBpcyB3b3VsZCBuZWVkIHRvIGJlLg0KQnV0IHRoZSBjb21waWxlciBjYW4gd29yayBp
dCBvdXQgYW5kIGdldCBpdCByaWdodC4NCg0KPiA+IC4uLg0KPiA+PiArCQlkYXRhX3NpemUgPSBt
aW5fdCh1MzIsIGVuZF9vZmZzZXQgLSBjdXJyX29mZnNldCwNCj4gPj4gKwkJCQkgIERFVkxJTktf
UkVHSU9OX1JFQURfQ0hVTktfU0laRSk7DQo+ID4NCj4gPiBIZXJlIEkgdGhpbmsgYm90aCB4eHhf
b2Zmc2V0IGFyZSB1MzIgLSBzbyB0aGUgQ0hVTktfU0laRQ0KPiA+IGNvbnN0YW50IHByb2JhYmx5
IG5lZWRzIGEgVSBzdWZmaXguDQo+IA0KPiBSaWdodC4gTXkgdW5kZXJzdGFuZGluZyB3YXMgdGhh
dCBtaW5fdCB3b3VsZCBjYXN0IGV2ZXJ5dGhpbmcgdG8gYSB1MzINCj4gd2hlbiBkb2luZyBzdWNo
IGNvbXBhcmlzb24sIGFuZCB3ZSBrbm93IHRoYXQNCj4gREVWTElOS19SRUdJT05fUkVBRF9DSFVO
S19TSVpFIGlzIDwgVTMyX01BWCBzbyB0aGlzIGlzIG9rPw0KPiANCj4gT3IgYW0gSSBtaXN1bmRl
cnN0YW5kaW5nPw0KDQpUaGUgY29kZSBpc24ndCB3cm9uZywgZXhjZXB0IHRoYXQgZXJyb3JzIGZy
b20gbWluKCkgYXJlIHJlYWxseQ0KYW4gaW5kaWNhdGlvbiB0aGF0IHRoZSB0eXBlcyBtaXNtYXRj
aCwgbm90IHRoYXQgeW91IHNob3VsZCBhZGQNCmxvYWRzIG9mIGNhc3RzLg0KWW91IHdvdWxkbid0
IHRoaW5rOg0KCXggPSAoaW50KWEgKyAoaW50KWI7DQp3YXMgYW55dGhpbmcgbm9ybWFsLCBidXQg
dGhhdCBpcyB3aGF0IG1pbl90KCkgZG9lcy4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRk
cmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBN
SzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

