Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E2D6661DF
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 18:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234973AbjAKRaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 12:30:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238467AbjAKR2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 12:28:02 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CF2753DBD2
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 09:23:53 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 30BHMQRv8026518, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 30BHMQRv8026518
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Thu, 12 Jan 2023 01:22:26 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Thu, 12 Jan 2023 01:23:24 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 12 Jan 2023 01:23:23 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Thu, 12 Jan 2023 01:23:23 +0800
From:   Hau <hau@realtek.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>, Andrew Lunn <andrew@lunn.ch>
Subject: RE: [PATCH net] r8169: fix rtl8168h wol fail
Thread-Topic: [PATCH net] r8169: fix rtl8168h wol fail
Thread-Index: AQHZITAeQEw7+pbiWEKyObvpj0H4U66PsbSAgAAedICAARt84IAASKWAgAayTHD//86LgIABruOg
Date:   Wed, 11 Jan 2023 17:23:23 +0000
Message-ID: <add32dc486bb4fc9abc283b2bb39efc3@realtek.com>
References: <20230105180408.2998-1-hau@realtek.com>
 <714782c5-b955-4511-23c0-9688224bba84@gmail.com> <Y7dAbxSPeaMnW/ly@lunn.ch>
 <9ee2f626bab3481697b71c58091e7def@realtek.com>
 <4014d243-8f8a-f273-fba8-2ae5a3844ea5@gmail.com>
 <6ff876a66e154bb4b357b31465c86741@realtek.com>
 <d28834dc-0426-5813-a24d-181839f23c38@gmail.com>
In-Reply-To: <d28834dc-0426-5813-a24d-181839f23c38@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.228.56]
x-kse-serverinfo: RTEXMBS04.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIzLzEvMTEg5LiL5Y2IIDAyOjU4OjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiANCj4gT24gMTAuMDEuMjAyMyAxODowMywgSGF1IHdyb3RlOg0KPiA+PiBPbiAwNi4wMS4yMDIz
IDA3OjUzLCBIYXUgd3JvdGU6DQo+ID4+Pj4+PiBydGw4MTY4aCBoYXMgYW4gYXBwbGljYXRpb24g
dGhhdCBpdCB3aWxsIGNvbm5lY3QgdG8gcnRsODIxMWZzDQo+ID4+Pj4+PiB0aHJvdWdoIG1kaSBp
bnRlcmZhY2UuIEFuZCBydGw4MjExZnMgd2lsbCBjb25uZWN0IHRvIGZpYmVyDQo+ID4+Pj4+PiB0
aHJvdWdoIHNlcmRlcw0KPiA+Pj4+IGludGVyZmFjZS4NCj4gPj4+Pj4+IEluIHRoaXMgYXBwbGlj
YXRpb24sIHJ0bDgxNjhoIHJldmlzaW9uIGlkIHdpbGwgYmUgc2V0IHRvIDB4MmEuDQo+ID4+Pj4+
Pg0KPiA+Pj4+Pj4gQmVjYXVzZSBydGw4MjExZnMncyBmaXJtd2FyZSB3aWxsIHNldCBsaW5rIGNh
cGFiaWxpdHkgdG8gMTAwTSBhbmQNCj4gPj4+Pj4+IEdJR0Egd2hlbiBsaW5rIGlzIGZyb20gb2Zm
IHRvIG9uLiBTbyB3aGVuIHN5c3RlbSBzdXNwZW5kIGFuZCB3b2wNCj4gPj4+Pj4+IGlzIGVuYWJs
ZWQsIHJ0bDgxNjhoIHdpbGwgc3BlZWQgZG93biB0byAxMDBNIChiZWNhdXNlIHJ0bDgyMTFmcw0K
PiA+Pj4+Pj4gYWR2ZXJ0aXNlIDEwME0gYW5kIEdJR0EgdG8gcnRsODE2OGgpLiBJZiB0aGUgbGlu
ayBzcGVlZCBiZXR3ZWVuDQo+ID4+Pj4gcnRsODEyMTFmcyBhbmQgZmliZXIgaXMgR0lHQS4NCj4g
Pj4+Pj4+IFRoZSBsaW5rIHNwZWVkIGJldHdlZW4gcnRsODE2OGggYW5kIGZpYmVyIHdpbGwgbWlz
bWF0Y2guIFRoYXQNCj4gPj4+Pj4+IHdpbGwgY2F1c2Ugd29sIGZhaWwuDQo+ID4+Pj4+Pg0KPiA+
Pj4+Pj4gSW4gdGhpcyBwYXRjaCwgaWYgcnRsODE2OGggaXMgaW4gdGhpcyBraW5kIG9mIGFwcGxp
Y2F0aW9uLCBkcml2ZXINCj4gPj4+Pj4+IHdpbGwgbm90IHNwZWVkIGRvd24gcGh5IHdoZW4gd29s
IGlzIGVuYWJsZWQuDQo+ID4+Pj4+Pg0KPiA+Pj4+PiBJIHRoaW5rIHRoZSBwYXRjaCB0aXRsZSBp
cyBpbmFwcHJvcHJpYXRlIGJlY2F1c2UgV29MIHdvcmtzDQo+ID4+Pj4+IG5vcm1hbGx5IG9uIFJU
TDgxNjhoIGluIHRoZSBzdGFuZGFyZCBzZXR1cC4NCj4gPj4+Pj4gV2hhdCB5b3UgYWRkIGlzbid0
IGEgZml4IGJ1dCBhIHdvcmthcm91bmQgZm9yIGEgZmlybXdhcmUgYnVnIGluDQo+ID4+IFJUTDgy
MTFGUy4NCj4gPj4+Pj4gQXMgbWVudGlvbmVkIGluIGEgcHJldmlvdXMgcmV2aWV3IGNvbW1lbnQ6
IGlmIHNwZWVkIG9uIGZpYnJlIHNpZGUNCj4gPj4+Pj4gaXMgMUdicHMgdGhlbiBSVEw4MjExRlMg
c2hvdWxkbid0IGFkdmVydGlzZSAxMDBNYnBzIG9uIE1ESS9VVFANCj4gc2lkZS4NCj4gPj4+Pj4g
TGFzdCBidXQgbm90IGxlYXN0IHRoZSB1c2VyIGNhbiBzdGlsbCB1c2UgZS5nLiBldGh0b29sIHRv
IGNoYW5nZQ0KPiA+Pj4+PiB0aGUgc3BlZWQgdG8gMTAwTWJwcyB0aHVzIGJyZWFraW5nIHRoZSBs
aW5rLg0KPiA+Pj4+DQo+ID4+Pj4gSSBhZ3JlZSB3aXRoIEhlaW5lciBoZXJlLiBJIGFzc3VtZSB5
b3UgY2Fubm90IGZpeCB0aGUgZmlybXdhcmU/DQo+ID4+Pj4NCj4gPj4+PiBTbyBjYW4gd2UgZGV0
ZWN0IHRoZSBicm9rZW4gZmlybXdhcmUgYW5kIGNvcnJlY3RseSBzZXQNCj4gPj4+PiBwaHlkZXYt
PmFkdmVydGlzaW5nPyBUaGF0IHdpbGwgZml4IFdvTCBhbmQgc2hvdWxkIHByZXZlbnQgdGhlIHVz
ZXINCj4gPj4+PiBmcm9tIHVzaW5nIGV0aHRvb2wgdG8gc2VsZWN0IGEgc2xvd2VyIHNwZWVkLg0K
PiA+Pj4+DQo+ID4+PiBJdCBpcyBhIHJ0bDgyMTFmcydzIGZpcm13YXJlIGJ1Zy4gQmVjYXVzZSBp
biB0aGlzIGFwcGxpY2F0aW9uIGl0DQo+ID4+PiB3aWxsIHN1cHBvcnQgYm90aCAxMDBNIGFuZCBH
SUdBIGZpYmVyIG1vZHVsZSwgc28gaXQgY2Fubm90IGp1c3Qgc2V0DQo+ID4+PiBwaHlkZXYtPmFk
dmVydGlzaW5nIHRvIDEwME0gb3IgR0lHQS4gV2UgIG1heSBuZWVkIHRvIHVzZSBiaXQtYmFuZw0K
PiA+PiBNRElPDQo+ID4+PiB0byBkZXRlY3QgZmliZXIgbGluayBzcGVlZCBhbmQgc2V0IHBoeWRl
di0+YWR2ZXJ0aXNpbmcgcHJvcGVybHkuIEJ1dA0KPiA+Pj4gaXQgd2lsbA0KPiA+PiBsZXQgdGhp
cyBwYXRjaCBiZWNvbWUgbW9yZSBjb21wbGljYXRlZC4NCj4gPj4+DQo+ID4+IEkgdGhpbmsgdGhl
cmUncyBhbHNvIGEgdXNlcnNwYWNlIHdvcmthcm91bmQgZm9yIHlvdXIgcHJvYmxlbS4NCj4gPj4g
WW91IGNhbiB1c2UgImV0aHRvb2wgLXMgPGlmPiBhZHZlcnRpc2UgLi4iIHRvIGFkanVzdCB3aGF0
IHRoZQ0KPiA+PiBpbnRlcm5hbCBQSFkgYWR2ZXJ0aXNlcy4NCj4gPj4gcGh5X3NwZWVkX2Rvd24o
KSBjb25zaWRlcnMgb25seSBtb2RlcyB0aGF0IGFyZSBjdXJyZW50bHkgYWR2ZXJ0aXNlZC4NCj4g
Pj4NCj4gPj4gSW4geW91ciBjYXNlIHdpdGggYSAxR2JwcyBmaWJyZSBtb2R1bGUgeW91IGNvdWxk
IHNldCB0aGUNCj4gPj4gYWR2ZXJ0aXNlbWVudCB0byAxR2Jwcy9mdWxsIG9ubHkuDQo+ID4+IFRo
ZW4gcGh5X3NwZWVkX2Rvd24oKSB3b3VsZG4ndCBjaGFuZ2UgdGhlIHNwZWVkLg0KPiA+Pg0KPiA+
IEluIHRoaXMgYXBwbGljYXRpb24ocnRsODE2OGggKyBydGw4MjExZnMpIGl0IGFsc28gc3VwcG9y
dHMgMTAwTWJwcyBmaWJlcg0KPiBtb2R1bGUuDQo+IA0KPiBEb2VzIFJUTDgyMTFGUyBhZHZlcnRp
c2UgMTAwTWJwcyBhbmQgMUdicHMgb24gdGhlIFVUUC9NREkgc2lkZSBpbiBjYXNlDQo+IG9mIGEg
MTAwTWJwcyBmaWJlciBtb2R1bGU/DQpZZXMuDQoNCj4gPiBTbyB1c2Vyc3BhY2Ugd29ya2Fyb3Vu
ZCBpcyBnb29kIGJ1dCBpdCBtYXkgbm90IGFsd2F5cyB3b3JrIGZvciB0aGlzIGlzc3VlLg0KPiAN
Cj4gV2hlbiB3b3VsZCBpdCBub3Qgd29yaz8gSWYgeW91IGtub3cgdGhlIGZpYmVyIG1vZHVsZSBz
cGVlZCB5b3UgY2FuIHNldA0KPiB0aGUgYWR2ZXJ0aXNlbWVudCBhY2NvcmRpbmdseS4NClN1cmUs
IHVzZXIgY2FuIHNldCBpbnRlcm5hbCBQSFkgYWR2ZXJ0aXNlbWVudCBhY2NvcmRpbmcgdG8gZmli
ZXIgbW9kdWxlIHNwZWVkLg0KQnV0IHdlIHdvdWxkIGxpa2UgdG8gaGF2ZSBhIHNvbHV0aW9uIHRo
YXQgZG9lcyBub3QgbmVlZCB1c2VyIHRvIGRvIGFueXRoaW5nLg0KU28gdGhpcyB1c2Vyc3BhY2Ug
d29ya2Fyb3VuZCBtYXkgbm90IG1lZXQgb3VyIG5lZWQuDQoNCj4gPiBOb3Qgc3BlZWQgZG93biBk
dXJpbmcgc3lzdGVtIHN1c3BlbmQgbWF5IGJlIHRoZSBzaW1wbGVzdCB3b3JrYXJvdW5kDQo+IGZv
ciB0aGlzIGlzc3VlLg0KPiA+DQotLS0tLS1QbGVhc2UgY29uc2lkZXIgdGhlIGVudmlyb25tZW50
IGJlZm9yZSBwcmludGluZyB0aGlzIGUtbWFpbC4NCg==
