Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB756646EC
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 18:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233674AbjAJRDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 12:03:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238716AbjAJRDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 12:03:48 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 25F613E0F7
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 09:03:46 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 30AH2cxL6013056, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 30AH2cxL6013056
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Wed, 11 Jan 2023 01:02:38 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Wed, 11 Jan 2023 01:03:36 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Wed, 11 Jan 2023 01:03:35 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Wed, 11 Jan 2023 01:03:35 +0800
From:   Hau <hau@realtek.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>, Andrew Lunn <andrew@lunn.ch>
Subject: RE: [PATCH net] r8169: fix rtl8168h wol fail
Thread-Topic: [PATCH net] r8169: fix rtl8168h wol fail
Thread-Index: AQHZITAeQEw7+pbiWEKyObvpj0H4U66PsbSAgAAedICAARt84IAASKWAgAayTHA=
Date:   Tue, 10 Jan 2023 17:03:35 +0000
Message-ID: <6ff876a66e154bb4b357b31465c86741@realtek.com>
References: <20230105180408.2998-1-hau@realtek.com>
 <714782c5-b955-4511-23c0-9688224bba84@gmail.com> <Y7dAbxSPeaMnW/ly@lunn.ch>
 <9ee2f626bab3481697b71c58091e7def@realtek.com>
 <4014d243-8f8a-f273-fba8-2ae5a3844ea5@gmail.com>
In-Reply-To: <4014d243-8f8a-f273-fba8-2ae5a3844ea5@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.228.56]
x-kse-serverinfo: RTEXMBS01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIzLzEvMTAg5LiL5Y2IIDAyOjAwOjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiAwNi4wMS4yMDIzIDA3OjUzLCBIYXUgd3JvdGU6DQo+ID4+Pj4gcnRsODE2OGggaGFzIGFu
IGFwcGxpY2F0aW9uIHRoYXQgaXQgd2lsbCBjb25uZWN0IHRvIHJ0bDgyMTFmcw0KPiA+Pj4+IHRo
cm91Z2ggbWRpIGludGVyZmFjZS4gQW5kIHJ0bDgyMTFmcyB3aWxsIGNvbm5lY3QgdG8gZmliZXIg
dGhyb3VnaA0KPiA+Pj4+IHNlcmRlcw0KPiA+PiBpbnRlcmZhY2UuDQo+ID4+Pj4gSW4gdGhpcyBh
cHBsaWNhdGlvbiwgcnRsODE2OGggcmV2aXNpb24gaWQgd2lsbCBiZSBzZXQgdG8gMHgyYS4NCj4g
Pj4+Pg0KPiA+Pj4+IEJlY2F1c2UgcnRsODIxMWZzJ3MgZmlybXdhcmUgd2lsbCBzZXQgbGluayBj
YXBhYmlsaXR5IHRvIDEwME0gYW5kDQo+ID4+Pj4gR0lHQSB3aGVuIGxpbmsgaXMgZnJvbSBvZmYg
dG8gb24uIFNvIHdoZW4gc3lzdGVtIHN1c3BlbmQgYW5kIHdvbCBpcw0KPiA+Pj4+IGVuYWJsZWQs
IHJ0bDgxNjhoIHdpbGwgc3BlZWQgZG93biB0byAxMDBNIChiZWNhdXNlIHJ0bDgyMTFmcw0KPiA+
Pj4+IGFkdmVydGlzZSAxMDBNIGFuZCBHSUdBIHRvIHJ0bDgxNjhoKS4gSWYgdGhlIGxpbmsgc3Bl
ZWQgYmV0d2Vlbg0KPiA+PiBydGw4MTIxMWZzIGFuZCBmaWJlciBpcyBHSUdBLg0KPiA+Pj4+IFRo
ZSBsaW5rIHNwZWVkIGJldHdlZW4gcnRsODE2OGggYW5kIGZpYmVyIHdpbGwgbWlzbWF0Y2guIFRo
YXQgd2lsbA0KPiA+Pj4+IGNhdXNlIHdvbCBmYWlsLg0KPiA+Pj4+DQo+ID4+Pj4gSW4gdGhpcyBw
YXRjaCwgaWYgcnRsODE2OGggaXMgaW4gdGhpcyBraW5kIG9mIGFwcGxpY2F0aW9uLCBkcml2ZXIN
Cj4gPj4+PiB3aWxsIG5vdCBzcGVlZCBkb3duIHBoeSB3aGVuIHdvbCBpcyBlbmFibGVkLg0KPiA+
Pj4+DQo+ID4+PiBJIHRoaW5rIHRoZSBwYXRjaCB0aXRsZSBpcyBpbmFwcHJvcHJpYXRlIGJlY2F1
c2UgV29MIHdvcmtzIG5vcm1hbGx5DQo+ID4+PiBvbiBSVEw4MTY4aCBpbiB0aGUgc3RhbmRhcmQg
c2V0dXAuDQo+ID4+PiBXaGF0IHlvdSBhZGQgaXNuJ3QgYSBmaXggYnV0IGEgd29ya2Fyb3VuZCBm
b3IgYSBmaXJtd2FyZSBidWcgaW4NCj4gUlRMODIxMUZTLg0KPiA+Pj4gQXMgbWVudGlvbmVkIGlu
IGEgcHJldmlvdXMgcmV2aWV3IGNvbW1lbnQ6IGlmIHNwZWVkIG9uIGZpYnJlIHNpZGUgaXMNCj4g
Pj4+IDFHYnBzIHRoZW4gUlRMODIxMUZTIHNob3VsZG4ndCBhZHZlcnRpc2UgMTAwTWJwcyBvbiBN
REkvVVRQIHNpZGUuDQo+ID4+PiBMYXN0IGJ1dCBub3QgbGVhc3QgdGhlIHVzZXIgY2FuIHN0aWxs
IHVzZSBlLmcuIGV0aHRvb2wgdG8gY2hhbmdlIHRoZQ0KPiA+Pj4gc3BlZWQgdG8gMTAwTWJwcyB0
aHVzIGJyZWFraW5nIHRoZSBsaW5rLg0KPiA+Pg0KPiA+PiBJIGFncmVlIHdpdGggSGVpbmVyIGhl
cmUuIEkgYXNzdW1lIHlvdSBjYW5ub3QgZml4IHRoZSBmaXJtd2FyZT8NCj4gPj4NCj4gPj4gU28g
Y2FuIHdlIGRldGVjdCB0aGUgYnJva2VuIGZpcm13YXJlIGFuZCBjb3JyZWN0bHkgc2V0DQo+ID4+
IHBoeWRldi0+YWR2ZXJ0aXNpbmc/IFRoYXQgd2lsbCBmaXggV29MIGFuZCBzaG91bGQgcHJldmVu
dCB0aGUgdXNlcg0KPiA+PiBmcm9tIHVzaW5nIGV0aHRvb2wgdG8gc2VsZWN0IGEgc2xvd2VyIHNw
ZWVkLg0KPiA+Pg0KPiA+IEl0IGlzIGEgcnRsODIxMWZzJ3MgZmlybXdhcmUgYnVnLiBCZWNhdXNl
IGluIHRoaXMgYXBwbGljYXRpb24gaXQgd2lsbA0KPiA+IHN1cHBvcnQgYm90aCAxMDBNIGFuZCBH
SUdBIGZpYmVyIG1vZHVsZSwgc28gaXQgY2Fubm90IGp1c3Qgc2V0DQo+ID4gcGh5ZGV2LT5hZHZl
cnRpc2luZyB0byAxMDBNIG9yIEdJR0EuIFdlICBtYXkgbmVlZCB0byB1c2UgYml0LWJhbmcNCj4g
TURJTw0KPiA+IHRvIGRldGVjdCBmaWJlciBsaW5rIHNwZWVkIGFuZCBzZXQgcGh5ZGV2LT5hZHZl
cnRpc2luZyBwcm9wZXJseS4gQnV0IGl0IHdpbGwNCj4gbGV0IHRoaXMgcGF0Y2ggYmVjb21lIG1v
cmUgY29tcGxpY2F0ZWQuDQo+ID4NCj4gSSB0aGluayB0aGVyZSdzIGFsc28gYSB1c2Vyc3BhY2Ug
d29ya2Fyb3VuZCBmb3IgeW91ciBwcm9ibGVtLg0KPiBZb3UgY2FuIHVzZSAiZXRodG9vbCAtcyA8
aWY+IGFkdmVydGlzZSAuLiIgdG8gYWRqdXN0IHdoYXQgdGhlIGludGVybmFsIFBIWQ0KPiBhZHZl
cnRpc2VzLg0KPiBwaHlfc3BlZWRfZG93bigpIGNvbnNpZGVycyBvbmx5IG1vZGVzIHRoYXQgYXJl
IGN1cnJlbnRseSBhZHZlcnRpc2VkLg0KPiANCj4gSW4geW91ciBjYXNlIHdpdGggYSAxR2JwcyBm
aWJyZSBtb2R1bGUgeW91IGNvdWxkIHNldCB0aGUgYWR2ZXJ0aXNlbWVudCB0bw0KPiAxR2Jwcy9m
dWxsIG9ubHkuDQo+IFRoZW4gcGh5X3NwZWVkX2Rvd24oKSB3b3VsZG4ndCBjaGFuZ2UgdGhlIHNw
ZWVkLg0KPiANCkluIHRoaXMgYXBwbGljYXRpb24ocnRsODE2OGggKyBydGw4MjExZnMpIGl0IGFs
c28gc3VwcG9ydHMgMTAwTWJwcyBmaWJlciBtb2R1bGUuDQpTbyB1c2Vyc3BhY2Ugd29ya2Fyb3Vu
ZCBpcyBnb29kIGJ1dCBpdCBtYXkgbm90IGFsd2F5cyB3b3JrIGZvciB0aGlzIGlzc3VlLg0KTm90
IHNwZWVkIGRvd24gZHVyaW5nIHN5c3RlbSBzdXNwZW5kIG1heSBiZSB0aGUgc2ltcGxlc3Qgd29y
a2Fyb3VuZCBmb3IgdGhpcyBpc3N1ZS4NCg0KLS0tLS0tUGxlYXNlIGNvbnNpZGVyIHRoZSBlbnZp
cm9ubWVudCBiZWZvcmUgcHJpbnRpbmcgdGhpcyBlLW1haWwuDQo=
