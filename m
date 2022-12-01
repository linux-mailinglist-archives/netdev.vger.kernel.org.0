Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72D6B63E7A7
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 03:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiLACTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 21:19:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiLACTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 21:19:19 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C69C099511;
        Wed, 30 Nov 2022 18:19:17 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2B12I7lpC004454, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2B12I7lpC004454
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Thu, 1 Dec 2022 10:18:07 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Thu, 1 Dec 2022 10:18:52 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 1 Dec 2022 10:18:52 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Thu, 1 Dec 2022 10:18:52 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Jun ASAKA <JunASAKA@zzy040330.moe>,
        "Jes.Sorensen@gmail.com" <Jes.Sorensen@gmail.com>
CC:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtl8xxxu: fixing IQK failures for rtl8192eu
Thread-Topic: [PATCH] wifi: rtl8xxxu: fixing IQK failures for rtl8192eu
Thread-Index: AQHZBMW0Ra7MKeD5kEmSajNwR0qaiK5YM5hw//+IBwCAAIuIkA==
Date:   Thu, 1 Dec 2022 02:18:52 +0000
Message-ID: <870b8a6e591f4de8b83df26f2a65330b@realtek.com>
References: <20221130140849.153705-1-JunASAKA@zzy040330.moe>
 <663e6d79c34f44998a937fe9fbd228e9@realtek.com>
 <6ce2e648-9c12-56a1-9118-e1e18c7ecd7d@zzy040330.moe>
In-Reply-To: <6ce2e648-9c12-56a1-9118-e1e18c7ecd7d@zzy040330.moe>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEyLzEg5LiK5Y2IIDEyOjA5OjAw?=
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

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEp1biBBU0FLQSA8SnVuQVNB
S0FAenp5MDQwMzMwLm1vZT4NCj4gU2VudDogVGh1cnNkYXksIERlY2VtYmVyIDEsIDIwMjIgOToz
OSBBTQ0KPiBUbzogUGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+OyBKZXMuU29yZW5z
ZW5AZ21haWwuY29tDQo+IENjOiBrdmFsb0BrZXJuZWwub3JnOyBkYXZlbUBkYXZlbWxvZnQubmV0
OyBlZHVtYXpldEBnb29nbGUuY29tOyBrdWJhQGtlcm5lbC5vcmc7IHBhYmVuaUByZWRoYXQuY29t
Ow0KPiBsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSF0g
d2lmaTogcnRsOHh4eHU6IGZpeGluZyBJUUsgZmFpbHVyZXMgZm9yIHJ0bDgxOTJldQ0KPiANCj4g
T24gMDEvMTIvMjAyMiA4OjU0IGFtLCBQaW5nLUtlIFNoaWggd3JvdGU6DQo+IA0KPiA+DQo+ID4+
IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4+IEZyb206IEp1bkFTQUtBIDxKdW5BU0FL
QUB6enkwNDAzMzAubW9lPg0KPiA+PiBTZW50OiBXZWRuZXNkYXksIE5vdmVtYmVyIDMwLCAyMDIy
IDEwOjA5IFBNDQo+ID4+IFRvOiBKZXMuU29yZW5zZW5AZ21haWwuY29tDQo+ID4+IENjOiBrdmFs
b0BrZXJuZWwub3JnOyBkYXZlbUBkYXZlbWxvZnQubmV0OyBlZHVtYXpldEBnb29nbGUuY29tOyBr
dWJhQGtlcm5lbC5vcmc7IHBhYmVuaUByZWRoYXQuY29tOw0KPiA+PiBsaW51eC13aXJlbGVzc0B2
Z2VyLmtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2Vy
Lmtlcm5lbC5vcmc7IEp1bkFTQUtBDQo+ID4+IDxKdW5BU0FLQUB6enkwNDAzMzAubW9lPg0KPiA+
PiBTdWJqZWN0OiBbUEFUQ0hdIHdpZmk6IHJ0bDh4eHh1OiBmaXhpbmcgSVFLIGZhaWx1cmVzIGZv
ciBydGw4MTkyZXUNCj4gPj4NCj4gPj4gRml4aW5nICJQYXRoIEEgUlggSVFLIGZhaWxlZCIgYW5k
ICJQYXRoIEIgUlggSVFLIGZhaWxlZCINCj4gPj4gaXNzdWVzIGZvciBydGw4MTkyZXUgY2hpcHMg
YnkgcmVwbGFjaW5nIHRoZSBhcmd1bWVudHMgd2l0aA0KPiA+PiB0aGUgb25lcyBpbiB0aGUgdXBk
YXRlZCBvZmZpY2lhbCBkcml2ZXIuDQo+ID4gSSB0aGluayBpdCB3b3VsZCBiZSBiZXR0ZXIgaWYg
eW91IGNhbiBwb2ludCBvdXQgd2hpY2ggdmVyc2lvbiB5b3UgdXNlLCBhbmQNCj4gPiBwZW9wbGUg
d2lsbCBub3QgbW9kaWZ5IHRoZW0gYmFjayB0byBvbGQgdmVyc2lvbiBzdWRkZW5seS4NCj4gPg0K
PiA+PiBTaWduZWQtb2ZmLWJ5OiBKdW5BU0FLQSA8SnVuQVNBS0FAenp5MDQwMzMwLm1vZT4NCj4g
Pj4gLS0tDQo+ID4+ICAgLi4uL3JlYWx0ZWsvcnRsOHh4eHUvcnRsOHh4eHVfODE5MmUuYyAgICAg
ICAgIHwgNzYgKysrKysrKysrKysrKy0tLS0tLQ0KPiA+PiAgIDEgZmlsZSBjaGFuZ2VkLCA1NCBp
bnNlcnRpb25zKCspLCAyMiBkZWxldGlvbnMoLSkNCj4gPj4NCj4gPj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsOHh4eHUvcnRsOHh4eHVfODE5MmUuYw0KPiA+
PiBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsOHh4eHUvcnRsOHh4eHVfODE5MmUu
Yw0KPiA+PiBpbmRleCBiMDY1MDhkMGNkLi44MjM0NjUwMGYyIDEwMDY0NA0KPiA+PiAtLS0gYS9k
cml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bDh4eHh1L3J0bDh4eHh1XzgxOTJlLmMNCj4g
Pj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGw4eHh4dS9ydGw4eHh4dV84
MTkyZS5jDQo+ID4gWy4uLl0NCj4gPg0KPiA+PiBAQCAtODkxLDIyICs5MDcsMjggQEAgc3RhdGlj
IGludCBydGw4MTkyZXVfaXFrX3BhdGhfYihzdHJ1Y3QgcnRsOHh4eHVfcHJpdiAqcHJpdikNCj4g
Pj4NCj4gPj4gICAJcnRsOHh4eHVfd3JpdGUzMihwcml2LCBSRUdfRlBHQTBfSVFLLCAweDAwMDAw
MDAwKTsNCj4gPj4gICAJcnRsOHh4eHVfd3JpdGVfcmZyZWcocHJpdiwgUkZfQiwgUkY2MDUyX1JF
R19VTktOT1dOX0RGLCAweDAwMTgwKTsNCj4gPj4gLQlydGw4eHh4dV93cml0ZTMyKHByaXYsIFJF
R19GUEdBMF9JUUssIDB4ODA4MDAwMDApOw0KPiA+Pg0KPiA+PiAtCXJ0bDh4eHh1X3dyaXRlMzIo
cHJpdiwgUkVHX0ZQR0EwX0lRSywgMHgwMDAwMDAwMCk7DQo+ID4+ICsJcnRsOHh4eHVfd3JpdGVf
cmZyZWcocHJpdiwgUkZfQiwgUkY2MDUyX1JFR19XRV9MVVQsIDB4ODAwYTApOw0KPiA+PiArCXJ0
bDh4eHh1X3dyaXRlX3JmcmVnKHByaXYsIFJGX0IsIFJGNjA1Ml9SRUdfUkNLX09TLCAweDIwMDAw
KTsNCj4gPj4gKwlydGw4eHh4dV93cml0ZV9yZnJlZyhwcml2LCBSRl9CLCBSRjYwNTJfUkVHX1RY
UEFfRzEsIDB4MDAwMGYpOw0KPiA+PiArCXJ0bDh4eHh1X3dyaXRlX3JmcmVnKHByaXYsIFJGX0Is
IFJGNjA1Ml9SRUdfVFhQQV9HMiwgMHgwN2Y3Nyk7DQo+ID4+ICsNCj4gPj4gICAJcnRsOHh4eHVf
d3JpdGUzMihwcml2LCBSRUdfRlBHQTBfSVFLLCAweDgwODAwMDAwKTsNCj4gPj4NCj4gPj4gKwkv
LyBydGw4eHh4dV93cml0ZTMyKHByaXYsIFJFR19GUEdBMF9JUUssIDB4MDAwMDAwMDApOw0KPiA+
PiArCS8vIHJ0bDh4eHh1X3dyaXRlMzIocHJpdiwgUkVHX0ZQR0EwX0lRSywgMHg4MDgwMDAwMCk7
DQo+ID4+ICsNCj4gPiBJIHRoaW5rIHRoaXMgaXMgYSB0ZXN0IGNvZGUgb2YgdmVuZG9yIGRyaXZl
ci4gTm8gbmVlZCB0aGVtIGhlcmUuDQo+ID4NCj4gPg0KPiA+PiAgIAkvKiBQYXRoIEIgSVFLIHNl
dHRpbmcgKi8NCj4gPj4gICAJcnRsOHh4eHVfd3JpdGUzMihwcml2LCBSRUdfVFhfSVFLX1RPTkVf
QSwgMHgzODAwOGMxYyk7DQo+ID4+ICAgCXJ0bDh4eHh1X3dyaXRlMzIocHJpdiwgUkVHX1JYX0lR
S19UT05FX0EsIDB4MzgwMDhjMWMpOw0KPiA+PiAgIAlydGw4eHh4dV93cml0ZTMyKHByaXYsIFJF
R19UWF9JUUtfVE9ORV9CLCAweDE4MDA4YzFjKTsNCj4gPj4gICAJcnRsOHh4eHVfd3JpdGUzMihw
cml2LCBSRUdfUlhfSVFLX1RPTkVfQiwgMHgzODAwOGMxYyk7DQo+ID4+DQo+ID4+IC0JcnRsOHh4
eHVfd3JpdGUzMihwcml2LCBSRUdfVFhfSVFLX1BJX0IsIDB4ODIxNDAzZTIpOw0KPiA+PiArCXJ0
bDh4eHh1X3dyaXRlMzIocHJpdiwgUkVHX1RYX0lRS19QSV9CLCAweDgyMTQwMzAzKTsNCj4gPj4g
ICAJcnRsOHh4eHVfd3JpdGUzMihwcml2LCBSRUdfUlhfSVFLX1BJX0IsIDB4NjgxNjAwMDApOw0K
PiA+Pg0KPiA+PiAgIAkvKiBMTyBjYWxpYnJhdGlvbiBzZXR0aW5nICovDQo+ID4+IC0JcnRsOHh4
eHVfd3JpdGUzMihwcml2LCBSRUdfSVFLX0FHQ19SU1AsIDB4MDA0OTI5MTEpOw0KPiA+PiArCXJ0
bDh4eHh1X3dyaXRlMzIocHJpdiwgUkVHX0lRS19BR0NfUlNQLCAweDAwNDYyOTExKTsNCj4gPj4N
Cj4gPj4gICAJLyogT25lIHNob3QsIHBhdGggQSBMT0sgJiBJUUsgKi8NCj4gPj4gICAJcnRsOHh4
eHVfd3JpdGUzMihwcml2LCBSRUdfSVFLX0FHQ19QVFMsIDB4ZmEwMDAwMDApOw0KPiA+IFsuLi5d
DQo+ID4NCj4gPiBJIGhhdmUgY29tcGFyZWQgeW91ciBwYXRjaCB3aXRoIGludGVybmFsIGNvZGUs
IGFuZCB0aGV5IGFyZSB0aGUgc2FtZS4NCj4gPiBCdXQsIEkgZG9uJ3QgaGF2ZSBhIHRlc3QuDQo+
ID4NCj4gPiBQaW5nLUtlDQo+IA0KPiBJIGNoYW5nZWQgdGhvc2UgYXJndW1lbnRzIGludG8gdGhl
IG9uZXMgaGVyZToNCj4gaHR0cHM6Ly9naXRodWIuY29tL01hbmdlL3J0bDgxOTJldS1saW51eC1k
cml2ZXIgd2hpY2ggd29ya3MgZmluZSB3aXRoIG15DQo+IHJ0bDgxOTJldSB3aWZpIGRvbmdsZS4g
QnV0IGZvcmdpdmUgbXkgaWdub3JhbnQgdGhhdCBJIGRvbid0IGhhdmUgZW5vdWdoDQo+IGV4cGVy
aWVuY2Ugb24gd2lmaSBkcml2ZXJzLCBJIGp1c3QgY29tcGFyZWQgdGhvc2UgdHdvIGRyaXZlcnMg
YW5kDQo+IGZpZ3VyZWQgdGhhdCB0aG9zZSBjb2RlcyBmaXhpbmcgbXkgSVFLIGZhaWx1cmVzLg0K
DQpJIGRvIHNpbWlsYXIgdGhpbmdzIGFzIHdlbGwuIDotKQ0KDQpUaGUgZ2l0aHViIHJlcG9zaXRv
cnkgbWVudGlvbmVkIA0KIlRoaXMgYnJhbmNoIGlzIGJhc2VkIG9uIFJlYWx0ZWsncyBkcml2ZXIg
dmVyc2lvbmVkIDQuNC4xLiBtYXN0ZXIgaXMgYmFzZWQgb24gNC4zLjEuMSBvcmlnaW5hbGx5LiIN
ClNvLCB3ZSBjYW4gYWRkIHNvbWV0aGluZyB0byBjb21taXQgbWVzc2FnZTogDQoxLiBodHRwczov
L2dpdGh1Yi5jb20vTWFuZ2UvcnRsODE5MmV1LWxpbnV4LWRyaXZlciANCjIuIHZlbmRvciBkcml2
ZXIgdmVyc2lvbjogNC4zLjEuMQ0KDQotLQ0KUGluZy1LZQ0KDQo=
