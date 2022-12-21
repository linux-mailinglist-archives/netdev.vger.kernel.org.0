Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA420652B17
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 02:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234326AbiLUBm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 20:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiLUBmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 20:42:55 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 638B71928E;
        Tue, 20 Dec 2022 17:42:54 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2BL1fcrJ7003645, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2BL1fcrJ7003645
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Wed, 21 Dec 2022 09:41:38 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Wed, 21 Dec 2022 09:42:29 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 21 Dec 2022 09:42:29 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Wed, 21 Dec 2022 09:42:29 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     "Jes.Sorensen@gmail.com" <Jes.Sorensen@gmail.com>,
        "rtl8821cerfe2@gmail.com" <rtl8821cerfe2@gmail.com>,
        "JunASAKA@zzy040330.moe" <JunASAKA@zzy040330.moe>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: [PATCH] wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu
Thread-Topic: [PATCH] wifi: rtl8xxxu: fixing transmisison failure for
 rtl8192eu
Thread-Index: AQHZEcSxpWNKKfbUGEumZ8h5P7r+XK52Rmng///23oCAANQEgA==
Date:   Wed, 21 Dec 2022 01:42:29 +0000
Message-ID: <fb0a7d6c0897464550ed7ee75c6318c525a0f001.camel@realtek.com>
References: <20221217030659.12577-1-JunASAKA@zzy040330.moe>
         <3b4124ebabcb4ceaae89cd9ccf84c7de@realtek.com>
         <33b2b585-c5b1-5888-bcee-ca74ce809a44@gmail.com>
In-Reply-To: <33b2b585-c5b1-5888-bcee-ca74ce809a44@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [125.224.71.208]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEyLzIwIOS4i+WNiCAxMDowMDowMA==?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <5E08DD7BCA56F7478F2C5D3AA4F61ED8@realtek.com>
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

T24gVHVlLCAyMDIyLTEyLTIwIGF0IDE1OjAzICswMjAwLCBCaXR0ZXJibHVlIFNtaXRoIHdyb3Rl
Og0KPiBPbiAyMC8xMi8yMDIyIDA3OjQ0LCBQaW5nLUtlIFNoaWggd3JvdGU6DQo+ID4gDQo+ID4g
PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4gRnJvbTogSnVuIEFTQUtBIDxKdW5B
U0FLQUB6enkwNDAzMzAubW9lPg0KPiA+ID4gU2VudDogU2F0dXJkYXksIERlY2VtYmVyIDE3LCAy
MDIyIDExOjA3IEFNDQo+ID4gPiBUbzogSmVzLlNvcmVuc2VuQGdtYWlsLmNvbQ0KPiA+ID4gQ2M6
IGt2YWxvQGtlcm5lbC5vcmc7IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGVkdW1hemV0QGdvb2dsZS5j
b207IGt1YmFAa2VybmVsLm9yZzsgDQo+ID4gPiBwYWJlbmlAcmVkaGF0LmNvbTsNCj4gPiA+IGxp
bnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGlu
dXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgSnVuDQo+ID4gPiBBU0FLQQ0KPiA+ID4gPEp1bkFT
QUtBQHp6eTA0MDMzMC5tb2U+DQo+ID4gPiBTdWJqZWN0OiBbUEFUQ0hdIHdpZmk6IHJ0bDh4eHh1
OiBmaXhpbmcgdHJhbnNtaXNpc29uIGZhaWx1cmUgZm9yIHJ0bDgxOTJldQ0KPiA+ID4gDQo+ID4g
PiBGaXhpbmcgdHJhbnNtaXNzaW9uIGZhaWx1cmUgd2hpY2ggcmVzdWx0cyBpbg0KPiA+ID4gImF1
dGhlbnRpY2F0aW9uIHdpdGggLi4uIHRpbWVkIG91dCIuIFRoaXMgY2FuIGJlDQo+ID4gPiBmaXhl
ZCBieSBkaXNhYmxlIHRoZSBSRUdfVFhQQVVTRS4NCj4gPiA+IA0KPiA+ID4gU2lnbmVkLW9mZi1i
eTogSnVuIEFTQUtBIDxKdW5BU0FLQUB6enkwNDAzMzAubW9lPg0KPiA+ID4gLS0tDQo+ID4gPiAg
ZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGw4eHh4dS9ydGw4eHh4dV84MTkyZS5jIHwg
NSArKysrKw0KPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKykNCj4gPiA+IA0K
PiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsOHh4eHUv
cnRsOHh4eHVfODE5MmUuYw0KPiA+ID4gYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0
bDh4eHh1L3J0bDh4eHh1XzgxOTJlLmMNCj4gPiA+IGluZGV4IGE3ZDc2NjkzYzAyZC4uOWQwZWQ2
NzYwY2I2IDEwMDY0NA0KPiA+ID4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9y
dGw4eHh4dS9ydGw4eHh4dV84MTkyZS5jDQo+ID4gPiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVz
cy9yZWFsdGVrL3J0bDh4eHh1L3J0bDh4eHh1XzgxOTJlLmMNCj4gPiA+IEBAIC0xNzQ0LDYgKzE3
NDQsMTEgQEAgc3RhdGljIHZvaWQgcnRsODE5MmVfZW5hYmxlX3JmKHN0cnVjdCBydGw4eHh4dV9w
cml2ICpwcml2KQ0KPiA+ID4gIAl2YWw4ID0gcnRsOHh4eHVfcmVhZDgocHJpdiwgUkVHX1BBRF9D
VFJMMSk7DQo+ID4gPiAgCXZhbDggJj0gfkJJVCgwKTsNCj4gPiA+ICAJcnRsOHh4eHVfd3JpdGU4
KHByaXYsIFJFR19QQURfQ1RSTDEsIHZhbDgpOw0KPiA+ID4gKw0KPiA+ID4gKwkvKg0KPiA+ID4g
KwkgKiBGaXggdHJhbnNtaXNzaW9uIGZhaWx1cmUgb2YgcnRsODE5MmUuDQo+ID4gPiArCSAqLw0K
PiA+ID4gKwlydGw4eHh4dV93cml0ZTgocHJpdiwgUkVHX1RYUEFVU0UsIDB4MDApOw0KPiA+IA0K
PiA+IEkgdHJhY2Ugd2hlbiBydGw4eHh4dSBzZXQgUkVHX1RYUEFVU0U9MHhmZiB0aGF0IHdpbGwg
c3RvcCBUWC4NCj4gPiBUaGUgb2NjYXNpb25zIGluY2x1ZGUgUkYgY2FsaWJyYXRpb24sIExQUyBt
b2RlIChjYWxsZWQgYnkgcG93ZXIgb2ZmKSwgYW5kDQo+ID4gZ29pbmcgdG8gc3RvcC4gU28sIEkg
dGhpbmsgUkYgY2FsaWJyYXRpb24gZG9lcyBUWCBwYXVzZSBidXQgbm90IHJlc3RvcmUNCj4gPiBz
ZXR0aW5ncyBhZnRlciBjYWxpYnJhdGlvbiwgYW5kIGNhdXNlcyBUWCBzdHVjay4gQXMgdGhlIGZs
b3cgSSB0cmFjZWQsDQo+ID4gdGhpcyBwYXRjaCBsb29rcyByZWFzb25hYmxlLiBCdXQsIEkgd29u
ZGVyIHdoeSBvdGhlciBwZW9wbGUgZG9uJ3QgbWVldA0KPiA+IHRoaXMgcHJvYmxlbS4NCj4gPiAN
Cj4gT3RoZXIgcGVvcGxlIGhhdmUgdGhpcyBwcm9ibGVtIHRvbzoNCj4gaHR0cHM6Ly9idWd6aWxs
YS5rZXJuZWwub3JnL3Nob3dfYnVnLmNnaT9pZD0xOTY3NjkNCj4gaHR0cHM6Ly9idWd6aWxsYS5r
ZXJuZWwub3JnL3Nob3dfYnVnLmNnaT9pZD0yMTY3NDYNCg0KSW4gdGhlIHRocmVhZHMsIHlvdSBo
YXZlIGFuc3dlcmVkIG15IHF1ZXN0aW9uIHdpdGgNCiJrZXJuZWwgNC44LjAgd29ya3MsIGJ1dCA0
LjkuPyBkb2VzIG5vdCB3b3JrLiINCg0KPiANCj4gVGhlIFJGIGNhbGlicmF0aW9uIGRvZXMgcmVz
dG9yZSBSRUdfVFhQQVVTRSBhdCB0aGUgZW5kLiBXaGF0IGhhcHBlbnMgaXMNCj4gd2hlbiB5b3Ug
cGx1ZyBpbiB0aGUgZGV2aWNlLCBzb21ldGhpbmcgKG1hYzgwMjExPyB3cGFfc3VwcGxpY2FudD8p
IGNhbGxzDQo+IHJ0bDh4eHh1X3N0YXJ0KCksIHRoZW4gcnRsOHh4eHVfc3RvcCgpLCB0aGVuIHJ0
bDh4eHh1X3N0YXJ0KCkgYWdhaW4uDQo+IHJ0bDh4eHh1X3N0b3AoKSBzZXRzIFJFR19UWFBBVVNF
IHRvIDB4ZmYgYW5kIG5vdGhpbmcgc2V0cyBpdCBiYWNrIHRvIDAuDQo+IA0KDQpZb3UgYXJlIGNv
cnJlY3QuIFRoYXQgaXMgY2xlYXIgdG8gbWUuIEkgbWlzcyB0aGUgcG9pbnQgdGhhdCBSRiBjYWxp
YnJhdGlvbg0KZG9lcyBiYWNrdXAvcmVzdG9yZSByZWdpc3RlcnMgY29udGFpbmluZyBSRUdfVFhQ
QVVTRS4NCg0KVGhlbiwgSSB0aGluayBteSByZXZpZXdlZC1ieSBjYW4gYmUgc3RpbGwgYXBwbGll
ZCwgcmlnaHQ/DQoNClBpbmctS2UNCg0K
