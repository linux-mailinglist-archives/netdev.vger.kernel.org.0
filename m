Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1B56014B3
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 19:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbiJQRXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 13:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbiJQRXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 13:23:35 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A2A66726AB
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 10:23:30 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 29HHMfbG6005826, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 29HHMfbG6005826
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Tue, 18 Oct 2022 01:22:41 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Tue, 18 Oct 2022 01:23:12 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Tue, 18 Oct 2022 01:23:12 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::add3:284:fd3d:8adb]) by
 RTEXMBS04.realtek.com.tw ([fe80::add3:284:fd3d:8adb%5]) with mapi id
 15.01.2375.007; Tue, 18 Oct 2022 01:23:12 +0800
From:   Hau <hau@realtek.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "grundler@chromium.org" <grundler@chromium.org>
Subject: RE: [PATCH net] r8169: fix rtl8125b dmar pte write access not set error
Thread-Topic: [PATCH net] r8169: fix rtl8125b dmar pte write access not set
 error
Thread-Index: AQHY18jMGMKenjvi2k2tTzR0owCm5K4FMJuAgAU+f1CAAD4tAIABNXCAgALE74CABEBDgA==
Date:   Mon, 17 Oct 2022 17:23:11 +0000
Message-ID: <c214fed3af19464c823a5294f531eaea@realtek.com>
References: <20221004081037.34064-1-hau@realtek.com>
 <6d607965-53ab-37c7-3920-ae2ad4be09e5@gmail.com>
 <6781f98dd232471791be8b0168f0153a@realtek.com>
 <3ffdaa0d-4a3d-dd2c-506c-d10b5297f430@gmail.com>
 <5eda67bb8f16473fb575b6a470d3592c@realtek.com>
 <48ff36cd-370b-f067-b643-a3d59df036dd@gmail.com>
In-Reply-To: <48ff36cd-370b-f067-b643-a3d59df036dd@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.129]
x-kse-serverinfo: RTEXDAG01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEwLzE3IOS4i+WNiCAwNDoxMjowMA==?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
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

PiBPbiAxMy4xMC4yMDIyIDA4OjA0LCBIYXUgd3JvdGU6DQo+ID4+IE9uIDEyLjEwLjIwMjIgMDk6
NTksIEhhdSB3cm90ZToNCj4gPj4+Pg0KPiA+Pj4+IE9uIDA0LjEwLjIwMjIgMTA6MTAsIENodW5o
YW8gTGluIHdyb3RlOg0KPiA+Pj4+PiBXaGVuIGNsb3NlIGRldmljZSwgcnggd2lsbCBiZSBlbmFi
bGVkIGlmIHdvbCBpcyBlbmFiZWxkLiBXaGVuIG9wZW4NCj4gPj4+Pj4gZGV2aWNlIGl0IHdpbGwg
Y2F1c2UgcnggdG8gZG1hIHRvIHdyb25nIGFkZHJlc3MgYWZ0ZXIgcGNpX3NldF9tYXN0ZXIoKS4N
Cj4gPj4+Pj4NCj4gPj4+Pj4gSW4gdGhpcyBwYXRjaCwgZHJpdmVyIHdpbGwgZGlzYWJsZSB0eC9y
eCB3aGVuIGNsb3NlIGRldmljZS4gSWYgd29sDQo+ID4+Pj4+IGlzIGVhbmJsZWQgb25seSBlbmFi
bGUgcnggZmlsdGVyIGFuZCBkaXNhYmxlIHJ4ZHZfZ2F0ZSB0byBsZXQNCj4gPj4+Pj4gaGFyZHdh
cmUgY2FuIHJlY2VpdmUgcGFja2V0IHRvIGZpZm8gYnV0IG5vdCB0byBkbWEgaXQuDQo+ID4+Pj4+
DQo+ID4+Pj4+IEZpeGVzOiAxMjAwNjg0ODE0MDUgKCJyODE2OTogZml4IGZhaWxpbmcgV29MIikN
Cj4gPj4+Pj4gU2lnbmVkLW9mZi1ieTogQ2h1bmhhbyBMaW4gPGhhdUByZWFsdGVrLmNvbT4NCj4g
Pj4+Pj4gLS0tDQo+ID4+Pj4+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9yZWFsdGVrL3I4MTY5X21h
aW4uYyB8IDE0ICsrKysrKystLS0tLS0tDQo+ID4+Pj4+ICAxIGZpbGUgY2hhbmdlZCwgNyBpbnNl
cnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQ0KPiA+Pj4+Pg0KPiA+Pj4+PiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVhbHRlay9yODE2OV9tYWluLmMNCj4gPj4+Pj4gYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9yZWFsdGVrL3I4MTY5X21haW4uYw0KPiA+Pj4+PiBpbmRleCAxYjdm
ZGI0ZjA1NmIuLmMwOWNmYmUxZDNmMCAxMDA2NDQNCj4gPj4+Pj4gLS0tIGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvcmVhbHRlay9yODE2OV9tYWluLmMNCj4gPj4+Pj4gKysrIGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvcmVhbHRlay9yODE2OV9tYWluLmMNCj4gPj4+Pj4gQEAgLTIyMzksNiArMjIzOSw5
IEBAIHN0YXRpYyB2b2lkIHJ0bF93b2xfZW5hYmxlX3J4KHN0cnVjdA0KPiA+Pj4+IHJ0bDgxNjlf
cHJpdmF0ZSAqdHApDQo+ID4+Pj4+ICAJaWYgKHRwLT5tYWNfdmVyc2lvbiA+PSBSVExfR0lHQV9N
QUNfVkVSXzI1KQ0KPiA+Pj4+PiAgCQlSVExfVzMyKHRwLCBSeENvbmZpZywgUlRMX1IzMih0cCwg
UnhDb25maWcpIHwNCj4gPj4+Pj4gIAkJCUFjY2VwdEJyb2FkY2FzdCB8IEFjY2VwdE11bHRpY2Fz
dCB8IEFjY2VwdE15UGh5cyk7DQo+ID4+Pj4+ICsNCj4gPj4+Pj4gKwlpZiAodHAtPm1hY192ZXJz
aW9uID49IFJUTF9HSUdBX01BQ19WRVJfNDApDQo+ID4+Pj4+ICsJCVJUTF9XMzIodHAsIE1JU0Ms
IFJUTF9SMzIodHAsIE1JU0MpICYNCj4gflJYRFZfR0FURURfRU4pOw0KPiA+Pj4+DQo+ID4+Pj4g
SXMgdGhpcyBjb3JyZWN0IGFueXdheT8gU3VwcG9zZWRseSB5b3Ugd2FudCB0byBzZXQgdGhpcyBi
aXQgdG8gZGlzYWJsZQ0KPiBETUEuDQo+ID4+Pj4NCj4gPj4+IElmIHdvbCBpcyBlbmFibGVkLCBk
cml2ZXIgbmVlZCB0byBkaXNhYmxlIGhhcmR3YXJlIHJ4ZHZfZ2F0ZSBmb3INCj4gPj4+IHJlY2Vp
dmluZw0KPiA+PiBwYWNrZXRzLg0KPiA+Pj4NCj4gPj4gT0ssIEkgc2VlLiBCdXQgd2h5IGRpc2Fi
bGUgaXQgaGVyZT8gSSBzZWUgbm8gc2NlbmFyaW8gd2hlcmUgcnhkdl9nYXRlDQo+ID4+IHdvdWxk
IGJlIGVuYWJsZWQgd2hlbiB3ZSBnZXQgaGVyZS4NCj4gPj4NCj4gPiByeGR2X2dhdGUgd2lsbCBi
ZSBlbmFibGVkIGluIHJ0bDgxNjlfY2xlYW51cCgpLiBXaGVuIHN1c3BlbmQgb3IgY2xvc2UNCj4g
PiBhbmQgd29sIGlzIGVuYWJsZWQgZHJpdmVyIHdpbGwgY2FsbCBydGw4MTY5X2Rvd24oKSAtPiBy
dGw4MTY5X2NsZWFudXAoKS0+DQo+IHJ0bF9wcmVwYXJlX3Bvd2VyX2Rvd24oKS0+IHJ0bF93b2xf
ZW5hYmxlX3J4KCkuDQo+ID4gU28gZGlzYWJsZWQgcnhkdl9nYXRlIGluIHJ0bF93b2xfZW5hYmxl
X3J4KCkgZm9yIHJlY2VpdmluZyBwYWNrZXRzLg0KPiA+DQo+IHJ0bDgxNjlfY2xlYW51cCgpIHNr
aXBzIHRoZSBjYWxsIHRvIHJ0bF9lbmFibGVfcnhkdmdhdGUoKSB3aGVuIGJlaW5nIGNhbGxlZA0K
PiBmcm9tDQo+IHJ0bDgxNjlfZG93bigpIGFuZCB3b2wgaXMgZW5hYmxlZC4gVGhpcyBtZWFucyBy
eGR2IGdhdGUgaXMgc3RpbGwgZGlzYWJsZWQuDQo+IA0KWWVzLCBpdCB3aWxsIGtlZXAgcnhkdl9n
YXRlIGRpc2FibGUuIEJ1dCBpdCB3aWxsIGFsc28ga2VlcCB0eC9yeCBvbi4gIElmIE9TIGhhdmUg
YW4gIHVuZXhwZWN0ZWQNCnJlYm9vdCBoYXJkd2FyZSAgbWF5IGRtYSB0byBpbnZhbGlkIG1lbW9y
eSBhZGRyZXNzLiBJZiBwb3NzaWJsZSBJIHByZWZlciB0byBrZWVwDQp0eC9yeCBvZmYgd2hlbiBl
eGl0IGRyaXZlciBjb250cm9sLiAgDQoNCi0tLS0tLVBsZWFzZSBjb25zaWRlciB0aGUgZW52aXJv
bm1lbnQgYmVmb3JlIHByaW50aW5nIHRoaXMgZS1tYWlsLg0K
