Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BECA75F6985
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 16:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiJFOXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 10:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbiJFOX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 10:23:29 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AEF0B5F5A
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 07:23:27 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 296EMfuX6022224, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 296EMfuX6022224
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Thu, 6 Oct 2022 22:22:41 +0800
Received: from RTEXMBS02.realtek.com.tw (172.21.6.95) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 6 Oct 2022 22:23:09 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS02.realtek.com.tw (172.21.6.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 6 Oct 2022 22:23:08 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::402d:f52e:eaf0:28a2]) by
 RTEXMBS04.realtek.com.tw ([fe80::402d:f52e:eaf0:28a2%5]) with mapi id
 15.01.2375.007; Thu, 6 Oct 2022 22:23:08 +0800
From:   Hau <hau@realtek.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "grundler@chromium.org" <grundler@chromium.org>
Subject: RE: [PATCH net] r8169: fix rtl8125b dmar pte write access not set error
Thread-Topic: [PATCH net] r8169: fix rtl8125b dmar pte write access not set
 error
Thread-Index: AQHY18jMGMKenjvi2k2tTzR0owCm5K3/eaaAgAHxavA=
Date:   Thu, 6 Oct 2022 14:23:08 +0000
Message-ID: <06d5b5ab8833445691a26e238235f9a0@realtek.com>
References: <20221004081037.34064-1-hau@realtek.com>
 <4d5fe96b-26ef-a9c8-f385-a3428d5562f5@gmail.com>
In-Reply-To: <4d5fe96b-26ef-a9c8-f385-a3428d5562f5@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.129]
x-kse-serverinfo: RTEXMBS02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEwLzYg5LiL5Y2IIDEyOjU3OjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
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

PiANCj4gSSB0aGluayB0aGUgZm9sbG93aW5nIHNpbXBsZSBjaGFuZ2Ugc2hvdWxkIGFsc28gZml4
IHRoZSBpc3N1ZS4NCj4gRE1BIGlzIGVuYWJsZWQgb25seSBhZnRlciB0aGUgY2hpcCBoYXMgYmVl
biByZXNldCBpbiBydGxfcmVzZXRfd29yaygpLg0KPiBUaGlzIHNob3VsZCBlbnN1cmUgdGhhdCB0
aGVyZSBhcmUgbm8gc3RhbGUgUlggRE1BIGRlc2NyaXB0b3JzIGFueSBsb25nZXIuDQo+IENvdWxk
IHlvdSBwbGVhc2UgdGVzdCBpdD8NCj4gDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvcmVhbHRlay9yODE2OV9tYWluLmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9y
ZWFsdGVrL3I4MTY5X21haW4uYw0KPiBpbmRleCAxMTRmODg0OTcuLjFkNzI2OTFhNCAxMDA2NDQN
Cj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVhbHRlay9yODE2OV9tYWluLmMNCj4gKysr
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVhbHRlay9yODE2OV9tYWluLmMNCj4gQEAgLTQ2MTAs
MTMgKzQ2MTAsMTMgQEAgc3RhdGljIHZvaWQgcnRsODE2OV9kb3duKHN0cnVjdCBydGw4MTY5X3By
aXZhdGUNCj4gKnRwKQ0KPiANCj4gIHN0YXRpYyB2b2lkIHJ0bDgxNjlfdXAoc3RydWN0IHJ0bDgx
NjlfcHJpdmF0ZSAqdHApICB7DQo+IC0JcGNpX3NldF9tYXN0ZXIodHAtPnBjaV9kZXYpOw0KPiAg
CXBoeV9pbml0X2h3KHRwLT5waHlkZXYpOw0KPiAgCXBoeV9yZXN1bWUodHAtPnBoeWRldik7DQo+
ICAJcnRsODE2OV9pbml0X3BoeSh0cCk7DQo+ICAJbmFwaV9lbmFibGUoJnRwLT5uYXBpKTsNCj4g
IAlzZXRfYml0KFJUTF9GTEFHX1RBU0tfRU5BQkxFRCwgdHAtPndrLmZsYWdzKTsNCj4gIAlydGxf
cmVzZXRfd29yayh0cCk7DQo+ICsJcGNpX3NldF9tYXN0ZXIodHAtPnBjaV9kZXYpOw0KPiANCj4g
IAlwaHlfc3RhcnQodHAtPnBoeWRldik7DQo+ICB9DQo+IC0tDQo+IDIuMzguMA0KPiANClRoaXMg
Y2FuIGZpeCB0aGUgaXNzdWUuIEJ1dCBpdCB3aWxsIGNhdXNlIGFub3RoZXIgZXJyb3IgbWVzc2Fn
ZSAiIHJ0bF9yeHR4X2VtcHR5X2NvbmQgPT0gMCAobG9vcDogNDIsIGRlbGF5OiAxMDApIi4NCkJl
Y2F1c2UgaWYgcnggaXMgZW5hYmxlZCwgcGFja2V0IHdpbGwgYmUgbW92ZSB0byBmaWZvLiBXaGVu
IGRyaXZlciBjaGVjayBpZiBmaWZvIGlzIGVtcHR5IG9uIGRldmljZSBvcGVuLA0KaGFyZHdhcmUg
d2lsbCBub3QgZG1hIHRoaXMgcGFja2V0IGJlY2F1c2UgYnVzIG1hc3RlciBpcyBkaXNhYmxlZCwg
ZmlmbyB3aWxsIGFsd2F5cyBub3QgZW1wdHkuDQogU28gaXQgbWlnaHQgYmUgYmV0dGVyIHRvIGRp
c2FibGUgdHhyeCB3aGVuIGNsb3NlIGRldmljZS4NCg0KLS0tLS0tUGxlYXNlIGNvbnNpZGVyIHRo
ZSBlbnZpcm9ubWVudCBiZWZvcmUgcHJpbnRpbmcgdGhpcyBlLW1haWwuDQo=
