Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7609B656273
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 13:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbiLZMOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 07:14:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231750AbiLZMOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 07:14:00 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 559116346
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 04:13:55 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2BQCCvAO2029897, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2BQCCvAO2029897
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Mon, 26 Dec 2022 20:12:57 +0800
Received: from RTEXMBS02.realtek.com.tw (172.21.6.95) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Mon, 26 Dec 2022 20:13:51 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS02.realtek.com.tw (172.21.6.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Mon, 26 Dec 2022 20:13:50 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Mon, 26 Dec 2022 20:13:50 +0800
From:   Hau <hau@realtek.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Subject: RE: [PATCH net v2] r8169: fix rtl8125b dmar pte write access not set error
Thread-Topic: [PATCH net v2] r8169: fix rtl8125b dmar pte write access not set
 error
Thread-Index: AQHZFqI+QAzyLpduP0msiI3VXpiKqa56wjQAgAVWqYA=
Date:   Mon, 26 Dec 2022 12:13:50 +0000
Message-ID: <337435cc983e4c8ca1fc1b1c354c842d@realtek.com>
References: <20221223074321.4862-1-hau@realtek.com>
 <ea257540-edae-2803-4726-778a44f96a34@gmail.com>
In-Reply-To: <ea257540-edae-2803-4726-778a44f96a34@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.74]
x-kse-serverinfo: RTEXMBS02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEyLzI2IOS4iuWNiCAwOTozMTowMA==?=
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

PiANCj4gT24gMjMuMTIuMjAyMiAwODo0MywgQ2h1bmhhbyBMaW4gd3JvdGU6DQo+ID4gV2hlbiBj
bG9zZSBkZXZpY2UsIGlmIHdvbCBpcyBlbmFibGVkLCByeCB3aWxsIGJlIGVuYWJsZWQuIFdoZW4g
b3Blbg0KPiA+IGRldmljZSBpdCB3aWxsIGNhdXNlIHJ4IHRvIGRtYSB0byB0aGUgd3JvbmcgbWVt
b3J5IGFkZHJlc3MgYWZ0ZXINCj4gcGNpX3NldF9tYXN0ZXIoKS4NCj4gPiBTeXN0ZW0gbG9nIHdp
bGwgc2hvdyBibG93IG1lc3NhZ2VzLg0KPiA+DQo+ID4gRE1BUjogRFJIRDogaGFuZGxpbmcgZmF1
bHQgc3RhdHVzIHJlZyAzDQo+ID4gRE1BUjogW0RNQSBXcml0ZV0gUmVxdWVzdCBkZXZpY2UgWzAy
OjAwLjBdIFBBU0lEIGZmZmZmZmZmIGZhdWx0IGFkZHINCj4gPiBmZmRkNDAwMCBbZmF1bHQgcmVh
c29uIDA1XSBQVEUgV3JpdGUgYWNjZXNzIGlzIG5vdCBzZXQNCj4gPg0KPiA+IEluIHRoaXMgcGF0
Y2gsIGRyaXZlciBkaXNhYmxlIHR4L3J4IHdoZW4gY2xvc2UgZGV2aWNlLiBJZiB3b2wgaXMNCj4g
PiBlbmFibGVkLCBvbmx5IGVuYWJsZSByeCBmaWx0ZXIgYW5kIGRpc2FibGUgcnhkdl9nYXRlIHRv
IGxldCBoYXJkd2FyZQ0KPiA+IG9ubHkgcmVjZWl2ZSBwYWNrZXQgdG8gZmlmbyBidXQgbm90IHRv
IGRtYSBpdC4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IENodW5oYW8gTGluIDxoYXVAcmVhbHRl
ay5jb20+DQo+ID4gLS0tDQo+ID4gdjEgLT4gdjI6IHVwZGF0ZSBjb21taXQgbWVzc2FnZSBhbmQg
YWRqdXN0IHRoZSBjb2RlIGFjY29yZGluZyB0byBjdXJyZW50DQo+IGtlcm5lbCBjb2RlLg0KPiA+
DQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlYWx0ZWsvcjgxNjlfbWFpbi5jIHwgNTgNCj4g
PiArKysrKysrKysrKy0tLS0tLS0tLS0tLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMjkgaW5zZXJ0
aW9ucygrKSwgMjkgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvcmVhbHRlay9yODE2OV9tYWluLmMNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L3JlYWx0ZWsvcjgxNjlfbWFpbi5jDQo+ID4gaW5kZXggYTlkY2M5OGI2YWYxLi4yNDU5MmQ5
NzI1MjMgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVhbHRlay9yODE2
OV9tYWluLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZWFsdGVrL3I4MTY5X21h
aW4uYw0KPiA+IEBAIC0yMjEwLDI4ICsyMjEwLDYgQEAgc3RhdGljIGludCBydGxfc2V0X21hY19h
ZGRyZXNzKHN0cnVjdCBuZXRfZGV2aWNlDQo+ICpkZXYsIHZvaWQgKnApDQo+ID4gIAlyZXR1cm4g
MDsNCj4gPiAgfQ0KPiA+DQo+ID4gLXN0YXRpYyB2b2lkIHJ0bF93b2xfZW5hYmxlX3J4KHN0cnVj
dCBydGw4MTY5X3ByaXZhdGUgKnRwKSAtew0KPiA+IC0JaWYgKHRwLT5tYWNfdmVyc2lvbiA+PSBS
VExfR0lHQV9NQUNfVkVSXzI1KQ0KPiA+IC0JCVJUTF9XMzIodHAsIFJ4Q29uZmlnLCBSVExfUjMy
KHRwLCBSeENvbmZpZykgfA0KPiA+IC0JCQlBY2NlcHRCcm9hZGNhc3QgfCBBY2NlcHRNdWx0aWNh
c3QgfCBBY2NlcHRNeVBoeXMpOw0KPiA+IC19DQo+ID4gLQ0KPiA+IC1zdGF0aWMgdm9pZCBydGxf
cHJlcGFyZV9wb3dlcl9kb3duKHN0cnVjdCBydGw4MTY5X3ByaXZhdGUgKnRwKSAtew0KPiA+IC0J
aWYgKHRwLT5kYXNoX3R5cGUgIT0gUlRMX0RBU0hfTk9ORSkNCj4gPiAtCQlyZXR1cm47DQo+ID4g
LQ0KPiA+IC0JaWYgKHRwLT5tYWNfdmVyc2lvbiA9PSBSVExfR0lHQV9NQUNfVkVSXzMyIHx8DQo+
ID4gLQkgICAgdHAtPm1hY192ZXJzaW9uID09IFJUTF9HSUdBX01BQ19WRVJfMzMpDQo+ID4gLQkJ
cnRsX2VwaHlfd3JpdGUodHAsIDB4MTksIDB4ZmY2NCk7DQo+ID4gLQ0KPiA+IC0JaWYgKGRldmlj
ZV9tYXlfd2FrZXVwKHRwX3RvX2Rldih0cCkpKSB7DQo+ID4gLQkJcGh5X3NwZWVkX2Rvd24odHAt
PnBoeWRldiwgZmFsc2UpOw0KPiA+IC0JCXJ0bF93b2xfZW5hYmxlX3J4KHRwKTsNCj4gPiAtCX0N
Cj4gPiAtfQ0KPiA+IC0NCj4gPiAgc3RhdGljIHZvaWQgcnRsX2luaXRfcnhjZmcoc3RydWN0IHJ0
bDgxNjlfcHJpdmF0ZSAqdHApICB7DQo+ID4gIAlzd2l0Y2ggKHRwLT5tYWNfdmVyc2lvbikgew0K
PiA+IEBAIC0yNDU1LDYgKzI0MzMsMzEgQEAgc3RhdGljIHZvaWQgcnRsX2VuYWJsZV9yeGR2Z2F0
ZShzdHJ1Y3QNCj4gcnRsODE2OV9wcml2YXRlICp0cCkNCj4gPiAgCXJ0bF93YWl0X3R4cnhfZmlm
b19lbXB0eSh0cCk7DQo+ID4gIH0NCj4gPg0KPiA+ICtzdGF0aWMgdm9pZCBydGxfd29sX2VuYWJs
ZV9yeChzdHJ1Y3QgcnRsODE2OV9wcml2YXRlICp0cCkgew0KPiA+ICsJaWYgKHRwLT5tYWNfdmVy
c2lvbiA+PSBSVExfR0lHQV9NQUNfVkVSXzI1KQ0KPiA+ICsJCVJUTF9XMzIodHAsIFJ4Q29uZmln
LCBSVExfUjMyKHRwLCBSeENvbmZpZykgfA0KPiA+ICsJCQlBY2NlcHRCcm9hZGNhc3QgfCBBY2Nl
cHRNdWx0aWNhc3QgfCBBY2NlcHRNeVBoeXMpOw0KPiA+ICsNCj4gPiArCWlmICh0cC0+bWFjX3Zl
cnNpb24gPj0gUlRMX0dJR0FfTUFDX1ZFUl80MCkNCj4gPiArCQlydGxfZGlzYWJsZV9yeGR2Z2F0
ZSh0cCk7DQo+ID4gK30NCj4gPiArDQo+ID4gK3N0YXRpYyB2b2lkIHJ0bF9wcmVwYXJlX3Bvd2Vy
X2Rvd24oc3RydWN0IHJ0bDgxNjlfcHJpdmF0ZSAqdHApIHsNCj4gPiArCWlmICh0cC0+ZGFzaF90
eXBlICE9IFJUTF9EQVNIX05PTkUpDQo+ID4gKwkJcmV0dXJuOw0KPiA+ICsNCj4gPiArCWlmICh0
cC0+bWFjX3ZlcnNpb24gPT0gUlRMX0dJR0FfTUFDX1ZFUl8zMiB8fA0KPiA+ICsJICAgIHRwLT5t
YWNfdmVyc2lvbiA9PSBSVExfR0lHQV9NQUNfVkVSXzMzKQ0KPiA+ICsJCXJ0bF9lcGh5X3dyaXRl
KHRwLCAweDE5LCAweGZmNjQpOw0KPiA+ICsNCj4gPiArCWlmIChkZXZpY2VfbWF5X3dha2V1cCh0
cF90b19kZXYodHApKSkgew0KPiA+ICsJCXBoeV9zcGVlZF9kb3duKHRwLT5waHlkZXYsIGZhbHNl
KTsNCj4gPiArCQlydGxfd29sX2VuYWJsZV9yeCh0cCk7DQo+ID4gKwl9DQo+ID4gK30NCj4gPiAr
DQo+ID4gIHN0YXRpYyB2b2lkIHJ0bF9zZXRfdHhfY29uZmlnX3JlZ2lzdGVycyhzdHJ1Y3QgcnRs
ODE2OV9wcml2YXRlICp0cCkNCj4gPiB7DQo+ID4gIAl1MzIgdmFsID0gVFhfRE1BX0JVUlNUIDw8
IFR4RE1BU2hpZnQgfCBAQCAtMzg3Miw3ICszODc1LDcgQEANCj4gc3RhdGljDQo+ID4gdm9pZCBy
dGw4MTY5X3R4X2NsZWFyKHN0cnVjdCBydGw4MTY5X3ByaXZhdGUgKnRwKQ0KPiA+ICAJbmV0ZGV2
X3Jlc2V0X3F1ZXVlKHRwLT5kZXYpOw0KPiA+ICB9DQo+ID4NCj4gPiAtc3RhdGljIHZvaWQgcnRs
ODE2OV9jbGVhbnVwKHN0cnVjdCBydGw4MTY5X3ByaXZhdGUgKnRwLCBib29sDQo+ID4gZ29pbmdf
ZG93bikNCj4gPiArc3RhdGljIHZvaWQgcnRsODE2OV9jbGVhbnVwKHN0cnVjdCBydGw4MTY5X3By
aXZhdGUgKnRwKQ0KPiA+ICB7DQo+ID4gIAluYXBpX2Rpc2FibGUoJnRwLT5uYXBpKTsNCj4gPg0K
PiA+IEBAIC0zODg0LDkgKzM4ODcsNiBAQCBzdGF0aWMgdm9pZCBydGw4MTY5X2NsZWFudXAoc3Ry
dWN0DQo+ID4gcnRsODE2OV9wcml2YXRlICp0cCwgYm9vbCBnb2luZ19kb3duKQ0KPiA+DQo+ID4g
IAlydGxfcnhfY2xvc2UodHApOw0KPiA+DQo+ID4gLQlpZiAoZ29pbmdfZG93biAmJiB0cC0+ZGV2
LT53b2xfZW5hYmxlZCkNCj4gPiAtCQlnb3RvIG5vX3Jlc2V0Ow0KPiA+IC0NCj4gPiAgCXN3aXRj
aCAodHAtPm1hY192ZXJzaW9uKSB7DQo+ID4gIAljYXNlIFJUTF9HSUdBX01BQ19WRVJfMjg6DQo+
ID4gIAljYXNlIFJUTF9HSUdBX01BQ19WRVJfMzE6DQo+ID4gQEAgLTM5MDcsNyArMzkwNyw3IEBA
IHN0YXRpYyB2b2lkIHJ0bDgxNjlfY2xlYW51cChzdHJ1Y3QgcnRsODE2OV9wcml2YXRlDQo+ICp0
cCwgYm9vbCBnb2luZ19kb3duKQ0KPiA+ICAJfQ0KPiA+DQo+ID4gIAlydGxfaHdfcmVzZXQodHAp
Ow0KPiA+IC1ub19yZXNldDoNCj4gPiArDQo+ID4gIAlydGw4MTY5X3R4X2NsZWFyKHRwKTsNCj4g
PiAgCXJ0bDgxNjlfaW5pdF9yaW5nX2luZGV4ZXModHApOw0KPiA+ICB9DQo+ID4gQEAgLTM5MTgs
NyArMzkxOCw3IEBAIHN0YXRpYyB2b2lkIHJ0bF9yZXNldF93b3JrKHN0cnVjdA0KPiA+IHJ0bDgx
NjlfcHJpdmF0ZSAqdHApDQo+ID4NCj4gPiAgCW5ldGlmX3N0b3BfcXVldWUodHAtPmRldik7DQo+
ID4NCj4gPiAtCXJ0bDgxNjlfY2xlYW51cCh0cCwgZmFsc2UpOw0KPiA+ICsJcnRsODE2OV9jbGVh
bnVwKHRwKTsNCj4gPg0KPiA+ICAJZm9yIChpID0gMDsgaSA8IE5VTV9SWF9ERVNDOyBpKyspDQo+
ID4gIAkJcnRsODE2OV9tYXJrX3RvX2FzaWModHAtPlJ4RGVzY0FycmF5ICsgaSk7IEBAIC00NjA1
LDcNCj4gKzQ2MDUsNyBAQA0KPiA+IHN0YXRpYyB2b2lkIHJ0bDgxNjlfZG93bihzdHJ1Y3QgcnRs
ODE2OV9wcml2YXRlICp0cCkNCj4gPiAgCXBjaV9jbGVhcl9tYXN0ZXIodHAtPnBjaV9kZXYpOw0K
PiA+ICAJcnRsX3BjaV9jb21taXQodHApOw0KPiA+DQo+ID4gLQlydGw4MTY5X2NsZWFudXAodHAs
IHRydWUpOw0KPiA+ICsJcnRsODE2OV9jbGVhbnVwKHRwKTsNCj4gPiAgCXJ0bF9kaXNhYmxlX2V4
aXRfbDEodHApOw0KPiA+ICAJcnRsX3ByZXBhcmVfcG93ZXJfZG93bih0cCk7DQo+ID4gIH0NCj4g
DQo+IFRoZSBjaGFuZ2UgYWZmZWN0cyBhbHNvIGNoaXAgdmVyc2lvbnMgb3RoZXIgdGhhbiBSVEw4
MTI1Qi4NCj4gSXMgdGhlIHByb2JsZW0geW91J3JlIGZpeGluZyByZWFsbHkgc3BlY2lmaWMgdG8g
UlRMODEyNUI/DQo+IE9yIGNvdWxkIGl0IGhhcHBlbiBhbHNvIHdpdGggb3RoZXIgY2hpcCB2ZXJz
aW9ucz8NCj4NCkFsbCBjaGlwcyB0aGF0IHN1cHBvcnRlZCBieSByODE2OSB3aWxsIGJlIGFmZmVj
dCBieSB0aGlzIHBhdGNoLg0KDQo+IEVpdGhlciBwYXRjaCBvciBjb21taXQgbWVzc2FnZSBuZWVk
IHRvIGJlIGNoYW5nZWQuDQo+IEFuZCBpdCB3b3VsZCBiZSBiZXR0ZXIgdG8gc3BsaXQgdGhlIHBh
dGNoOg0KPiAxLiBNb3ZpbmcgcnRsX3dvbF9lbmFibGVfcngoKSBhbmQgcnRsX3ByZXBhcmVfcG93
ZXJfZG93bigpIGluIHRoZSBjb2RlIDIuDQo+IEFjdHVhbCBjaGFuZ2UgVGhpcyBtYWtlcyBpdCBl
YXNpZXIgdG8gdHJhY2sgdGhlIGFjdHVhbCBjaGFuZ2UuDQo+DQpJIHdpbGwgZm9sbG93IHlvdXIg
c3VnZ2VzdGlvbiBhbmQgc3VibWl0IHRoaXMgcGF0Y2ggYWdhaW4uDQogDQo+IC0tLS0tLVBsZWFz
ZSBjb25zaWRlciB0aGUgZW52aXJvbm1lbnQgYmVmb3JlIHByaW50aW5nIHRoaXMgZS1tYWlsLg0K
