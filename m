Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E8C60BE6B
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 01:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbiJXXSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 19:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbiJXXSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 19:18:11 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7EFBE2E1BBD
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 14:38:57 -0700 (PDT)
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 29OI2CoN4004722, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 29OI2CoN4004722
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Tue, 25 Oct 2022 02:02:12 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Tue, 25 Oct 2022 02:02:45 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Tue, 25 Oct 2022 02:02:44 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::add3:284:fd3d:8adb]) by
 RTEXMBS04.realtek.com.tw ([fe80::add3:284:fd3d:8adb%5]) with mapi id
 15.01.2375.007; Tue, 25 Oct 2022 02:02:44 +0800
From:   Hau <hau@realtek.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "grundler@chromium.org" <grundler@chromium.org>
Subject: RE: [PATCH net] r8169: fix rtl8125b dmar pte write access not set error
Thread-Topic: [PATCH net] r8169: fix rtl8125b dmar pte write access not set
 error
Thread-Index: AQHY18jMGMKenjvi2k2tTzR0owCm5K4FMJuAgAU+f1CAAD4tAIABNXCAgALE74CABEBDgP//onuAgAtpUjA=
Date:   Mon, 24 Oct 2022 18:02:44 +0000
Message-ID: <93142463abc6464484f1ff3f46e07975@realtek.com>
References: <20221004081037.34064-1-hau@realtek.com>
 <6d607965-53ab-37c7-3920-ae2ad4be09e5@gmail.com>
 <6781f98dd232471791be8b0168f0153a@realtek.com>
 <3ffdaa0d-4a3d-dd2c-506c-d10b5297f430@gmail.com>
 <5eda67bb8f16473fb575b6a470d3592c@realtek.com>
 <48ff36cd-370b-f067-b643-a3d59df036dd@gmail.com>
 <c214fed3af19464c823a5294f531eaea@realtek.com>
 <465b96bf-0eff-8e5c-433d-3571114058e6@gmail.com>
In-Reply-To: <465b96bf-0eff-8e5c-433d-3571114058e6@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.129]
x-kse-serverinfo: RTEXDAG01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEwLzI0IOS4i+WNiCAwMzoxNjowMA==?=
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

PiANCj4gT24gMTcuMTAuMjAyMiAxOToyMywgSGF1IHdyb3RlOg0KPiA+PiBPbiAxMy4xMC4yMDIy
IDA4OjA0LCBIYXUgd3JvdGU6DQo+ID4+Pj4gT24gMTIuMTAuMjAyMiAwOTo1OSwgSGF1IHdyb3Rl
Og0KPiA+Pj4+Pj4NCj4gPj4+Pj4+IE9uIDA0LjEwLjIwMjIgMTA6MTAsIENodW5oYW8gTGluIHdy
b3RlOg0KPiA+Pj4+Pj4+IFdoZW4gY2xvc2UgZGV2aWNlLCByeCB3aWxsIGJlIGVuYWJsZWQgaWYg
d29sIGlzIGVuYWJlbGQuIFdoZW4NCj4gPj4+Pj4+PiBvcGVuIGRldmljZSBpdCB3aWxsIGNhdXNl
IHJ4IHRvIGRtYSB0byB3cm9uZyBhZGRyZXNzIGFmdGVyDQo+IHBjaV9zZXRfbWFzdGVyKCkuDQo+
ID4+Pj4+Pj4NCj4gPj4+Pj4+PiBJbiB0aGlzIHBhdGNoLCBkcml2ZXIgd2lsbCBkaXNhYmxlIHR4
L3J4IHdoZW4gY2xvc2UgZGV2aWNlLiBJZg0KPiA+Pj4+Pj4+IHdvbCBpcyBlYW5ibGVkIG9ubHkg
ZW5hYmxlIHJ4IGZpbHRlciBhbmQgZGlzYWJsZSByeGR2X2dhdGUgdG8NCj4gPj4+Pj4+PiBsZXQg
aGFyZHdhcmUgY2FuIHJlY2VpdmUgcGFja2V0IHRvIGZpZm8gYnV0IG5vdCB0byBkbWEgaXQuDQo+
ID4+Pj4+Pj4NCj4gPj4+Pj4+PiBGaXhlczogMTIwMDY4NDgxNDA1ICgicjgxNjk6IGZpeCBmYWls
aW5nIFdvTCIpDQo+ID4+Pj4+Pj4gU2lnbmVkLW9mZi1ieTogQ2h1bmhhbyBMaW4gPGhhdUByZWFs
dGVrLmNvbT4NCj4gPj4+Pj4+PiAtLS0NCj4gPj4+Pj4+PiAgZHJpdmVycy9uZXQvZXRoZXJuZXQv
cmVhbHRlay9yODE2OV9tYWluLmMgfCAxNCArKysrKysrLS0tLS0tLQ0KPiA+Pj4+Pj4+ICAxIGZp
bGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQ0KPiA+Pj4+Pj4+DQo+
ID4+Pj4+Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlYWx0ZWsvcjgxNjlf
bWFpbi5jDQo+ID4+Pj4+Pj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZWFsdGVrL3I4MTY5X21h
aW4uYw0KPiA+Pj4+Pj4+IGluZGV4IDFiN2ZkYjRmMDU2Yi4uYzA5Y2ZiZTFkM2YwIDEwMDY0NA0K
PiA+Pj4+Pj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlYWx0ZWsvcjgxNjlfbWFpbi5j
DQo+ID4+Pj4+Pj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVhbHRlay9yODE2OV9tYWlu
LmMNCj4gPj4+Pj4+PiBAQCAtMjIzOSw2ICsyMjM5LDkgQEAgc3RhdGljIHZvaWQgcnRsX3dvbF9l
bmFibGVfcngoc3RydWN0DQo+ID4+Pj4+PiBydGw4MTY5X3ByaXZhdGUgKnRwKQ0KPiA+Pj4+Pj4+
ICAJaWYgKHRwLT5tYWNfdmVyc2lvbiA+PSBSVExfR0lHQV9NQUNfVkVSXzI1KQ0KPiA+Pj4+Pj4+
ICAJCVJUTF9XMzIodHAsIFJ4Q29uZmlnLCBSVExfUjMyKHRwLCBSeENvbmZpZykgfA0KPiA+Pj4+
Pj4+ICAJCQlBY2NlcHRCcm9hZGNhc3QgfCBBY2NlcHRNdWx0aWNhc3QgfA0KPiBBY2NlcHRNeVBo
eXMpOw0KPiA+Pj4+Pj4+ICsNCj4gPj4+Pj4+PiArCWlmICh0cC0+bWFjX3ZlcnNpb24gPj0gUlRM
X0dJR0FfTUFDX1ZFUl80MCkNCj4gPj4+Pj4+PiArCQlSVExfVzMyKHRwLCBNSVNDLCBSVExfUjMy
KHRwLCBNSVNDKSAmDQo+ID4+IH5SWERWX0dBVEVEX0VOKTsNCj4gPj4+Pj4+DQo+ID4+Pj4+PiBJ
cyB0aGlzIGNvcnJlY3QgYW55d2F5PyBTdXBwb3NlZGx5IHlvdSB3YW50IHRvIHNldCB0aGlzIGJp
dCB0bw0KPiA+Pj4+Pj4gZGlzYWJsZQ0KPiA+PiBETUEuDQo+ID4+Pj4+Pg0KPiA+Pj4+PiBJZiB3
b2wgaXMgZW5hYmxlZCwgZHJpdmVyIG5lZWQgdG8gZGlzYWJsZSBoYXJkd2FyZSByeGR2X2dhdGUg
Zm9yDQo+ID4+Pj4+IHJlY2VpdmluZw0KPiA+Pj4+IHBhY2tldHMuDQo+ID4+Pj4+DQo+ID4+Pj4g
T0ssIEkgc2VlLiBCdXQgd2h5IGRpc2FibGUgaXQgaGVyZT8gSSBzZWUgbm8gc2NlbmFyaW8gd2hl
cmUNCj4gPj4+PiByeGR2X2dhdGUgd291bGQgYmUgZW5hYmxlZCB3aGVuIHdlIGdldCBoZXJlLg0K
PiA+Pj4+DQo+ID4+PiByeGR2X2dhdGUgd2lsbCBiZSBlbmFibGVkIGluIHJ0bDgxNjlfY2xlYW51
cCgpLiBXaGVuIHN1c3BlbmQgb3INCj4gPj4+IGNsb3NlIGFuZCB3b2wgaXMgZW5hYmxlZCBkcml2
ZXIgd2lsbCBjYWxsIHJ0bDgxNjlfZG93bigpIC0+DQo+ID4+PiBydGw4MTY5X2NsZWFudXAoKS0+
DQo+ID4+IHJ0bF9wcmVwYXJlX3Bvd2VyX2Rvd24oKS0+IHJ0bF93b2xfZW5hYmxlX3J4KCkuDQo+
ID4+PiBTbyBkaXNhYmxlZCByeGR2X2dhdGUgaW4gcnRsX3dvbF9lbmFibGVfcngoKSBmb3IgcmVj
ZWl2aW5nIHBhY2tldHMuDQo+ID4+Pg0KPiA+PiBydGw4MTY5X2NsZWFudXAoKSBza2lwcyB0aGUg
Y2FsbCB0byBydGxfZW5hYmxlX3J4ZHZnYXRlKCkgd2hlbiBiZWluZw0KPiA+PiBjYWxsZWQgZnJv
bQ0KPiA+PiBydGw4MTY5X2Rvd24oKSBhbmQgd29sIGlzIGVuYWJsZWQuIFRoaXMgbWVhbnMgcnhk
diBnYXRlIGlzIHN0aWxsIGRpc2FibGVkLg0KPiA+Pg0KPiA+IFllcywgaXQgd2lsbCBrZWVwIHJ4
ZHZfZ2F0ZSBkaXNhYmxlLiBCdXQgaXQgd2lsbCBhbHNvIGtlZXAgdHgvcnggb24uDQo+ID4gSWYg
T1MgaGF2ZSBhbiAgdW5leHBlY3RlZCByZWJvb3QgaGFyZHdhcmUgIG1heSBkbWEgdG8gaW52YWxp
ZCBtZW1vcnkNCj4gPiBhZGRyZXNzLiBJZiBwb3NzaWJsZSBJIHByZWZlciB0byBrZWVwIHR4L3J4
IG9mZiB3aGVuIGV4aXQgZHJpdmVyIGNvbnRyb2wuDQo+ID4NCj4gDQo+IFdoZW4geW91IHNheSAi
a2VlcCB0eC9yeCBvZmYiLCBkbyB5b3UgcmVmZXIgdG8gdGhlIHJ4Y29uZmlnIGJpdHMgaW4gcmVn
aXN0ZXINCj4gUnhDb25maWcsIG9yIHRvIENtZFR4RW5iIGFuZCBDbWRSeEVuYiBpbiBDaGlwQ21k
Pw0KPiANCj4gSWYgd2UgdGFsayBhYm91dCB0aGUgZmlyc3Qgb3B0aW9uLCB0aGVuIG15IGd1ZXNz
IHdvdWxkIGJlOg0KPiBBY2NvcmRpbmcgdG8gcnRsX3dvbF9lbmFibGVfcngoKSB0aGUgcnggY29u
ZmlnIGJpdHMgYXJlIHJlcXVpcmVkIGZvciBXb0wgdG8NCj4gd29yayBvbiBjZXJ0YWluIGNoaXAg
dmVyc2lvbnMuIFdpdGggdGhlIGludHJvZHVjdGlvbiBvZiByeGR2Z2F0ZSB0aGlzIGNoYW5nZWQN
Cj4gYW5kIHNldHRpbmcgdGhlc2UgYml0cyBpc24ndCBuZWVkZWQgYW55IGxvbmdlci4NCj4gSSB0
ZXN0ZWQgb24gUlRMODE2OGggYW5kIFdvTCB3b3JrZWQgdy9vIHRoZSBBY2NlcHQgYml0cyBzZXQg
aW4gUnhDb25maWcuDQo+IFBsZWFzZSBjb25maXJtIG9yIGNvcnJlY3QgbXkgdW5kZXJzdGFuZGlu
Zy4NCj4gDQo+IHN0YXRpYyB2b2lkIHJ0bF93b2xfZW5hYmxlX3J4KHN0cnVjdCBydGw4MTY5X3By
aXZhdGUgKnRwKSB7DQo+IAlpZiAodHAtPm1hY192ZXJzaW9uID49IFJUTF9HSUdBX01BQ19WRVJf
MjUpDQo+IAkJUlRMX1czMih0cCwgUnhDb25maWcsIFJUTF9SMzIodHAsIFJ4Q29uZmlnKSB8DQo+
IAkJCUFjY2VwdEJyb2FkY2FzdCB8IEFjY2VwdE11bHRpY2FzdCB8DQo+IEFjY2VwdE15UGh5cyk7
IH0NCj4gDQo+DQpXaGVuIGVudGVyIGQzY29sZCBoYXJkd2FyZSB3aWxsIHB1bGwgcGNpZSByZXNl
dCB0byBsb3cuIElmIHBjaWUgcmVzZXQgaXMgcHVsbGVkIGxvdw0KaGFyZHdhcmUgd2lsbCBzZXQg
cmNyIGFjcHRfcGh5L21hci9icmQgLiBUaGF0IGlzIHdoeSB5b3Ugc3RpbGwgZ2V0IHdvbCB3b3Jr
ZWQgdy9vIHNldCByY3IuDQpBbHRob3VnaCBoYXJkd2FyZSB3aWxsIHNldCByY3IgYml0cyB3aGVu
IHBjaWUgcmVzZXQgaXMgcHVsbCBsb3cuIEJ1dCB0aGVyZSBpcyBubyBwY2llIHJlc2V0DQp3aGVu
IGhhcmR3YXJlIGVudGVyIGQzaG90LiBTbyBkcml2ZXIgc3RpbGwgbmVlZHMgdG8gc2V0IHJjciBi
aXRzIHdoZW4gaGFyZHdhcmUgZ28gdG8gZDMgc3RhdGUuDQoNCiAtLS0tLS1QbGVhc2UgY29uc2lk
ZXIgdGhlIGVudmlyb25tZW50IGJlZm9yZSBwcmludGluZyB0aGlzIGUtbWFpbC4NCg==
