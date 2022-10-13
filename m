Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 341675FD472
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 08:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiJMGEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 02:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiJMGEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 02:04:53 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5C0A515819
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 23:04:51 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 29D641NO0027095, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 29D641NO0027095
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Thu, 13 Oct 2022 14:04:01 +0800
Received: from RTEXMBS02.realtek.com.tw (172.21.6.95) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Thu, 13 Oct 2022 14:04:31 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS02.realtek.com.tw (172.21.6.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 13 Oct 2022 14:04:30 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::402d:f52e:eaf0:28a2]) by
 RTEXMBS04.realtek.com.tw ([fe80::402d:f52e:eaf0:28a2%5]) with mapi id
 15.01.2375.007; Thu, 13 Oct 2022 14:04:30 +0800
From:   Hau <hau@realtek.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "grundler@chromium.org" <grundler@chromium.org>
Subject: RE: [PATCH net] r8169: fix rtl8125b dmar pte write access not set error
Thread-Topic: [PATCH net] r8169: fix rtl8125b dmar pte write access not set
 error
Thread-Index: AQHY18jMGMKenjvi2k2tTzR0owCm5K4FMJuAgAU+f1CAAD4tAIABNXCA
Date:   Thu, 13 Oct 2022 06:04:30 +0000
Message-ID: <5eda67bb8f16473fb575b6a470d3592c@realtek.com>
References: <20221004081037.34064-1-hau@realtek.com>
 <6d607965-53ab-37c7-3920-ae2ad4be09e5@gmail.com>
 <6781f98dd232471791be8b0168f0153a@realtek.com>
 <3ffdaa0d-4a3d-dd2c-506c-d10b5297f430@gmail.com>
In-Reply-To: <3ffdaa0d-4a3d-dd2c-506c-d10b5297f430@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.129]
x-kse-serverinfo: RTEXMBS02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEwLzEzIOS4iuWNiCAwMjo1MTowMA==?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiAxMi4xMC4yMDIyIDA5OjU5LCBIYXUgd3JvdGU6DQo+ID4+DQo+ID4+IE9uIDA0LjEwLjIw
MjIgMTA6MTAsIENodW5oYW8gTGluIHdyb3RlOg0KPiA+Pj4gV2hlbiBjbG9zZSBkZXZpY2UsIHJ4
IHdpbGwgYmUgZW5hYmxlZCBpZiB3b2wgaXMgZW5hYmVsZC4gV2hlbiBvcGVuDQo+ID4+PiBkZXZp
Y2UgaXQgd2lsbCBjYXVzZSByeCB0byBkbWEgdG8gd3JvbmcgYWRkcmVzcyBhZnRlciBwY2lfc2V0
X21hc3RlcigpLg0KPiA+Pj4NCj4gPj4+IEluIHRoaXMgcGF0Y2gsIGRyaXZlciB3aWxsIGRpc2Fi
bGUgdHgvcnggd2hlbiBjbG9zZSBkZXZpY2UuIElmIHdvbA0KPiA+Pj4gaXMgZWFuYmxlZCBvbmx5
IGVuYWJsZSByeCBmaWx0ZXIgYW5kIGRpc2FibGUgcnhkdl9nYXRlIHRvIGxldA0KPiA+Pj4gaGFy
ZHdhcmUgY2FuIHJlY2VpdmUgcGFja2V0IHRvIGZpZm8gYnV0IG5vdCB0byBkbWEgaXQuDQo+ID4+
Pg0KPiA+Pj4gRml4ZXM6IDEyMDA2ODQ4MTQwNSAoInI4MTY5OiBmaXggZmFpbGluZyBXb0wiKQ0K
PiA+Pj4gU2lnbmVkLW9mZi1ieTogQ2h1bmhhbyBMaW4gPGhhdUByZWFsdGVrLmNvbT4NCj4gPj4+
IC0tLQ0KPiA+Pj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlYWx0ZWsvcjgxNjlfbWFpbi5jIHwg
MTQgKysrKysrKy0tLS0tLS0NCj4gPj4+ICAxIGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCsp
LCA3IGRlbGV0aW9ucygtKQ0KPiA+Pj4NCj4gPj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9yZWFsdGVrL3I4MTY5X21haW4uYw0KPiA+Pj4gYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9yZWFsdGVrL3I4MTY5X21haW4uYw0KPiA+Pj4gaW5kZXggMWI3ZmRiNGYwNTZiLi5jMDljZmJl
MWQzZjAgMTAwNjQ0DQo+ID4+PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZWFsdGVrL3I4
MTY5X21haW4uYw0KPiA+Pj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVhbHRlay9yODE2
OV9tYWluLmMNCj4gPj4+IEBAIC0yMjM5LDYgKzIyMzksOSBAQCBzdGF0aWMgdm9pZCBydGxfd29s
X2VuYWJsZV9yeChzdHJ1Y3QNCj4gPj4gcnRsODE2OV9wcml2YXRlICp0cCkNCj4gPj4+ICAJaWYg
KHRwLT5tYWNfdmVyc2lvbiA+PSBSVExfR0lHQV9NQUNfVkVSXzI1KQ0KPiA+Pj4gIAkJUlRMX1cz
Mih0cCwgUnhDb25maWcsIFJUTF9SMzIodHAsIFJ4Q29uZmlnKSB8DQo+ID4+PiAgCQkJQWNjZXB0
QnJvYWRjYXN0IHwgQWNjZXB0TXVsdGljYXN0IHwgQWNjZXB0TXlQaHlzKTsNCj4gPj4+ICsNCj4g
Pj4+ICsJaWYgKHRwLT5tYWNfdmVyc2lvbiA+PSBSVExfR0lHQV9NQUNfVkVSXzQwKQ0KPiA+Pj4g
KwkJUlRMX1czMih0cCwgTUlTQywgUlRMX1IzMih0cCwgTUlTQykgJiB+UlhEVl9HQVRFRF9FTik7
DQo+ID4+DQo+ID4+IElzIHRoaXMgY29ycmVjdCBhbnl3YXk/IFN1cHBvc2VkbHkgeW91IHdhbnQg
dG8gc2V0IHRoaXMgYml0IHRvIGRpc2FibGUgRE1BLg0KPiA+Pg0KPiA+IElmIHdvbCBpcyBlbmFi
bGVkLCBkcml2ZXIgbmVlZCB0byBkaXNhYmxlIGhhcmR3YXJlIHJ4ZHZfZ2F0ZSBmb3IgcmVjZWl2
aW5nDQo+IHBhY2tldHMuDQo+ID4NCj4gT0ssIEkgc2VlLiBCdXQgd2h5IGRpc2FibGUgaXQgaGVy
ZT8gSSBzZWUgbm8gc2NlbmFyaW8gd2hlcmUgcnhkdl9nYXRlIHdvdWxkDQo+IGJlIGVuYWJsZWQg
d2hlbiB3ZSBnZXQgaGVyZS4NCj4gDQpyeGR2X2dhdGUgd2lsbCBiZSBlbmFibGVkIGluIHJ0bDgx
NjlfY2xlYW51cCgpLiBXaGVuIHN1c3BlbmQgb3IgY2xvc2UgYW5kIHdvbCBpcyBlbmFibGVkDQpk
cml2ZXIgd2lsbCBjYWxsIHJ0bDgxNjlfZG93bigpIC0+IHJ0bDgxNjlfY2xlYW51cCgpLT4gcnRs
X3ByZXBhcmVfcG93ZXJfZG93bigpLT4gcnRsX3dvbF9lbmFibGVfcngoKS4NClNvIGRpc2FibGVk
IHJ4ZHZfZ2F0ZSBpbiBydGxfd29sX2VuYWJsZV9yeCgpIGZvciByZWNlaXZpbmcgcGFja2V0cy4N
Cg0KLS0tLS0tUGxlYXNlIGNvbnNpZGVyIHRoZSBlbnZpcm9ubWVudCBiZWZvcmUgcHJpbnRpbmcg
dGhpcyBlLW1haWwuDQo=
