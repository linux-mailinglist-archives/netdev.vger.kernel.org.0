Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B772B60682B
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 20:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiJTSZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 14:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiJTSZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 14:25:16 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9DC38109D77
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 11:25:11 -0700 (PDT)
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 29KI1HGR0031530, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 29KI1HGR0031530
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Fri, 21 Oct 2022 02:01:17 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Fri, 21 Oct 2022 02:01:49 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Fri, 21 Oct 2022 02:01:48 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::add3:284:fd3d:8adb]) by
 RTEXMBS04.realtek.com.tw ([fe80::add3:284:fd3d:8adb%5]) with mapi id
 15.01.2375.007; Fri, 21 Oct 2022 02:01:48 +0800
From:   Hau <hau@realtek.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "grundler@chromium.org" <grundler@chromium.org>
Subject: RE: [PATCH net] r8169: fix rtl8125b dmar pte write access not set error
Thread-Topic: [PATCH net] r8169: fix rtl8125b dmar pte write access not set
 error
Thread-Index: AQHY18jMGMKenjvi2k2tTzR0owCm5K4FMJuAgAU+f1CAAD4tAIABNXCAgALE74CABEBDgP//onuAgAUghpA=
Date:   Thu, 20 Oct 2022 18:01:48 +0000
Message-ID: <e7b7241fdb7c4cde80811ca5b588e17e@realtek.com>
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
x-kse-serverinfo: RTEXMBS01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEwLzIwIOS4i+WNiCAwNToxNTowMA==?=
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

PiBPbiAxNy4xMC4yMDIyIDE5OjIzLCBIYXUgd3JvdGU6DQo+ID4+IE9uIDEzLjEwLjIwMjIgMDg6
MDQsIEhhdSB3cm90ZToNCj4gPj4+PiBPbiAxMi4xMC4yMDIyIDA5OjU5LCBIYXUgd3JvdGU6DQo+
ID4+Pj4+Pg0KPiA+Pj4+Pj4gT24gMDQuMTAuMjAyMiAxMDoxMCwgQ2h1bmhhbyBMaW4gd3JvdGU6
DQo+ID4+Pj4+Pj4gV2hlbiBjbG9zZSBkZXZpY2UsIHJ4IHdpbGwgYmUgZW5hYmxlZCBpZiB3b2wg
aXMgZW5hYmVsZC4gV2hlbg0KPiA+Pj4+Pj4+IG9wZW4gZGV2aWNlIGl0IHdpbGwgY2F1c2Ugcngg
dG8gZG1hIHRvIHdyb25nIGFkZHJlc3MgYWZ0ZXINCj4gcGNpX3NldF9tYXN0ZXIoKS4NCj4gPj4+
Pj4+Pg0KPiA+Pj4+Pj4+IEluIHRoaXMgcGF0Y2gsIGRyaXZlciB3aWxsIGRpc2FibGUgdHgvcngg
d2hlbiBjbG9zZSBkZXZpY2UuIElmDQo+ID4+Pj4+Pj4gd29sIGlzIGVhbmJsZWQgb25seSBlbmFi
bGUgcnggZmlsdGVyIGFuZCBkaXNhYmxlIHJ4ZHZfZ2F0ZSB0bw0KPiA+Pj4+Pj4+IGxldCBoYXJk
d2FyZSBjYW4gcmVjZWl2ZSBwYWNrZXQgdG8gZmlmbyBidXQgbm90IHRvIGRtYSBpdC4NCj4gPj4+
Pj4+Pg0KPiA+Pj4+Pj4+IEZpeGVzOiAxMjAwNjg0ODE0MDUgKCJyODE2OTogZml4IGZhaWxpbmcg
V29MIikNCj4gPj4+Pj4+PiBTaWduZWQtb2ZmLWJ5OiBDaHVuaGFvIExpbiA8aGF1QHJlYWx0ZWsu
Y29tPg0KPiA+Pj4+Pj4+IC0tLQ0KPiA+Pj4+Pj4+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9yZWFs
dGVrL3I4MTY5X21haW4uYyB8IDE0ICsrKysrKystLS0tLS0tDQo+ID4+Pj4+Pj4gIDEgZmlsZSBj
aGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pDQo+ID4+Pj4+Pj4NCj4gPj4+
Pj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVhbHRlay9yODE2OV9tYWlu
LmMNCj4gPj4+Pj4+PiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlYWx0ZWsvcjgxNjlfbWFpbi5j
DQo+ID4+Pj4+Pj4gaW5kZXggMWI3ZmRiNGYwNTZiLi5jMDljZmJlMWQzZjAgMTAwNjQ0DQo+ID4+
Pj4+Pj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVhbHRlay9yODE2OV9tYWluLmMNCj4g
Pj4+Pj4+PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZWFsdGVrL3I4MTY5X21haW4uYw0K
PiA+Pj4+Pj4+IEBAIC0yMjM5LDYgKzIyMzksOSBAQCBzdGF0aWMgdm9pZCBydGxfd29sX2VuYWJs
ZV9yeChzdHJ1Y3QNCj4gPj4+Pj4+IHJ0bDgxNjlfcHJpdmF0ZSAqdHApDQo+ID4+Pj4+Pj4gIAlp
ZiAodHAtPm1hY192ZXJzaW9uID49IFJUTF9HSUdBX01BQ19WRVJfMjUpDQo+ID4+Pj4+Pj4gIAkJ
UlRMX1czMih0cCwgUnhDb25maWcsIFJUTF9SMzIodHAsIFJ4Q29uZmlnKSB8DQo+ID4+Pj4+Pj4g
IAkJCUFjY2VwdEJyb2FkY2FzdCB8IEFjY2VwdE11bHRpY2FzdCB8DQo+IEFjY2VwdE15UGh5cyk7
DQo+ID4+Pj4+Pj4gKw0KPiA+Pj4+Pj4+ICsJaWYgKHRwLT5tYWNfdmVyc2lvbiA+PSBSVExfR0lH
QV9NQUNfVkVSXzQwKQ0KPiA+Pj4+Pj4+ICsJCVJUTF9XMzIodHAsIE1JU0MsIFJUTF9SMzIodHAs
IE1JU0MpICYNCj4gPj4gflJYRFZfR0FURURfRU4pOw0KPiA+Pj4+Pj4NCj4gPj4+Pj4+IElzIHRo
aXMgY29ycmVjdCBhbnl3YXk/IFN1cHBvc2VkbHkgeW91IHdhbnQgdG8gc2V0IHRoaXMgYml0IHRv
DQo+ID4+Pj4+PiBkaXNhYmxlDQo+ID4+IERNQS4NCj4gPj4+Pj4+DQo+ID4+Pj4+IElmIHdvbCBp
cyBlbmFibGVkLCBkcml2ZXIgbmVlZCB0byBkaXNhYmxlIGhhcmR3YXJlIHJ4ZHZfZ2F0ZSBmb3IN
Cj4gPj4+Pj4gcmVjZWl2aW5nDQo+ID4+Pj4gcGFja2V0cy4NCj4gPj4+Pj4NCj4gPj4+PiBPSywg
SSBzZWUuIEJ1dCB3aHkgZGlzYWJsZSBpdCBoZXJlPyBJIHNlZSBubyBzY2VuYXJpbyB3aGVyZQ0K
PiA+Pj4+IHJ4ZHZfZ2F0ZSB3b3VsZCBiZSBlbmFibGVkIHdoZW4gd2UgZ2V0IGhlcmUuDQo+ID4+
Pj4NCj4gPj4+IHJ4ZHZfZ2F0ZSB3aWxsIGJlIGVuYWJsZWQgaW4gcnRsODE2OV9jbGVhbnVwKCku
IFdoZW4gc3VzcGVuZCBvcg0KPiA+Pj4gY2xvc2UgYW5kIHdvbCBpcyBlbmFibGVkIGRyaXZlciB3
aWxsIGNhbGwgcnRsODE2OV9kb3duKCkgLT4NCj4gPj4+IHJ0bDgxNjlfY2xlYW51cCgpLT4NCj4g
Pj4gcnRsX3ByZXBhcmVfcG93ZXJfZG93bigpLT4gcnRsX3dvbF9lbmFibGVfcngoKS4NCj4gPj4+
IFNvIGRpc2FibGVkIHJ4ZHZfZ2F0ZSBpbiBydGxfd29sX2VuYWJsZV9yeCgpIGZvciByZWNlaXZp
bmcgcGFja2V0cy4NCj4gPj4+DQo+ID4+IHJ0bDgxNjlfY2xlYW51cCgpIHNraXBzIHRoZSBjYWxs
IHRvIHJ0bF9lbmFibGVfcnhkdmdhdGUoKSB3aGVuIGJlaW5nDQo+ID4+IGNhbGxlZCBmcm9tDQo+
ID4+IHJ0bDgxNjlfZG93bigpIGFuZCB3b2wgaXMgZW5hYmxlZC4gVGhpcyBtZWFucyByeGR2IGdh
dGUgaXMgc3RpbGwgZGlzYWJsZWQuDQo+ID4+DQo+ID4gWWVzLCBpdCB3aWxsIGtlZXAgcnhkdl9n
YXRlIGRpc2FibGUuIEJ1dCBpdCB3aWxsIGFsc28ga2VlcCB0eC9yeCBvbi4NCj4gPiBJZiBPUyBo
YXZlIGFuICB1bmV4cGVjdGVkIHJlYm9vdCBoYXJkd2FyZSAgbWF5IGRtYSB0byBpbnZhbGlkIG1l
bW9yeQ0KPiA+IGFkZHJlc3MuIElmIHBvc3NpYmxlIEkgcHJlZmVyIHRvIGtlZXAgdHgvcnggb2Zm
IHdoZW4gZXhpdCBkcml2ZXIgY29udHJvbC4NCj4gPg0KPiANCj4gV2hlbiB5b3Ugc2F5ICJrZWVw
IHR4L3J4IG9mZiIsIGRvIHlvdSByZWZlciB0byB0aGUgcnhjb25maWcgYml0cyBpbiByZWdpc3Rl
cg0KPiBSeENvbmZpZywgb3IgdG8gQ21kVHhFbmIgYW5kIENtZFJ4RW5iIGluIENoaXBDbWQ/DQo+
IA0KPiBJZiB3ZSB0YWxrIGFib3V0IHRoZSBmaXJzdCBvcHRpb24sIHRoZW4gbXkgZ3Vlc3Mgd291
bGQgYmU6DQo+IEFjY29yZGluZyB0byBydGxfd29sX2VuYWJsZV9yeCgpIHRoZSByeCBjb25maWcg
Yml0cyBhcmUgcmVxdWlyZWQgZm9yIFdvTCB0bw0KPiB3b3JrIG9uIGNlcnRhaW4gY2hpcCB2ZXJz
aW9ucy4gV2l0aCB0aGUgaW50cm9kdWN0aW9uIG9mIHJ4ZHZnYXRlIHRoaXMgY2hhbmdlZA0KPiBh
bmQgc2V0dGluZyB0aGVzZSBiaXRzIGlzbid0IG5lZWRlZCBhbnkgbG9uZ2VyLg0KPiBJIHRlc3Rl
ZCBvbiBSVEw4MTY4aCBhbmQgV29MIHdvcmtlZCB3L28gdGhlIEFjY2VwdCBiaXRzIHNldCBpbiBS
eENvbmZpZy4NCj4gUGxlYXNlIGNvbmZpcm0gb3IgY29ycmVjdCBteSB1bmRlcnN0YW5kaW5nLg0K
PiANCj4gc3RhdGljIHZvaWQgcnRsX3dvbF9lbmFibGVfcngoc3RydWN0IHJ0bDgxNjlfcHJpdmF0
ZSAqdHApIHsNCj4gCWlmICh0cC0+bWFjX3ZlcnNpb24gPj0gUlRMX0dJR0FfTUFDX1ZFUl8yNSkN
Cj4gCQlSVExfVzMyKHRwLCBSeENvbmZpZywgUlRMX1IzMih0cCwgUnhDb25maWcpIHwNCj4gCQkJ
QWNjZXB0QnJvYWRjYXN0IHwgQWNjZXB0TXVsdGljYXN0IHwNCj4gQWNjZXB0TXlQaHlzKTsgfQ0K
PiANCj4gDQpXZSBleHBlY3Qgd29sICBwYWNrZXQgc2hvdWxkIGJlIGZpbHRlcmVkIGJ5IEFjY2Vw
dCBiaXRzIHNldCBpbiBSeENvbmZpZy4gDQpCdXQgZm9yIG1hZ2ljIHBhY2tldCB3YWtldXAgaXQg
c2VlbXMgaXQgZG9lcyBub3QgcGVyZm9ybSBhcyBleHBlY3RlZC4gDQpXZSBuZWVkIHNvbWUgdGlt
ZSB0byBmaWd1cmUgdGhpcyBvdXQuIE9uY2Ugd2UgaGF2ZSBhbnkgdXBkYXRlIHdlIHdpbGwgbGV0
IHlvdSBrbm93Lg0KDQogLS0tLS0tUGxlYXNlIGNvbnNpZGVyIHRoZSBlbnZpcm9ubWVudCBiZWZv
cmUgcHJpbnRpbmcgdGhpcyBlLW1haWwuDQo=
