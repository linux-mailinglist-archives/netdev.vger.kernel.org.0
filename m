Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11ED86C4A08
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 13:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjCVMN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 08:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjCVMN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 08:13:28 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52C22449D
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 05:13:27 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 32MCCxt06003070, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 32MCCxt06003070
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Wed, 22 Mar 2023 20:12:59 +0800
Received: from RTEXMBS03.realtek.com.tw (172.21.6.96) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Wed, 22 Mar 2023 20:13:13 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Wed, 22 Mar 2023 20:13:12 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Wed, 22 Mar 2023 20:13:12 +0800
From:   Hau <hau@realtek.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Subject: RE: [PATCH net] r8169: fix rtl8168h rx crc error
Thread-Topic: [PATCH net] r8169: fix rtl8168h rx crc error
Thread-Index: AQHZXIn13gnxa8cqaECWm4Ww3lcREq8F70wAgADCfmA=
Date:   Wed, 22 Mar 2023 12:13:12 +0000
Message-ID: <3892d440f0194b30aa32ccd93f661dd2@realtek.com>
References: <20230322064550.2378-1-hau@realtek.com>
 <20230322082104.y6pz7ewu3ojd3esh@soft-dev3-1>
In-Reply-To: <20230322082104.y6pz7ewu3ojd3esh@soft-dev3-1>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.228.56]
x-kse-serverinfo: RTEXMBS03.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIzLzMvMjIg5LiK5Y2IIDExOjIwOjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBUaGUgMDMvMjIvMjAyMyAxNDo0NSwgQ2h1bkhhbyBMaW4gd3JvdGU6DQo+ID4NCj4gPiBXaGVu
IGxpbmsgc3BlZWQgaXMgMTAgTWJwcyBhbmQgdGVtcGVyYXR1cmUgaXMgdW5kZXIgLTIwwrBDLCBy
dGw4MTY4aA0KPiA+IG1heSBoYXZlIHJ4IGNyYyBlcnJvci4gRGlzYWJsZSBwaHkgMTAgTWJwcyBw
bGwgb2ZmIHRvIGZpeCB0aGlzIGlzc3VlLg0KPiANCj4gRG9uJ3QgZm9yZ2V0IHRvIGFkZCB0aGUg
Zml4ZXMgdGFnLg0KPiBBbm90aGVyIGNvbW1lbnQgdGhhdCBJIHVzdWFsbHkgZ2V0IGlzIHRvIHJl
cGxhY2UgaGFyZGNvZGVkIHZhbHVlcyB3aXRoDQo+IGRlZmluZXMsIGJ1dCBvbiB0aGUgb3RoZXIg
c2lkZSBJIGNhbiBzZWUgdGhhdCB0aGlzIGZpbGUgYWxyZWFkeSBoYXMgcGxlbnRseSBvZg0KPiBo
YXJkY29kZWQgdmFsdWVzLg0KPiANCkl0IGlzIG5vdCBhIGZpeCBmb3IgYSBzcGVjaWZpYyBjb21t
aXQuIFBIWSAxMG0gcGxsIG9mZiBpcyBhbiBwb3dlciBzYXZpbmcgZmVhdHVyZSB3aGljaCBpcyBl
bmFibGVkIGJ5IEgvVyBkZWZhdWx0Lg0KVGhpcyBpc3N1ZSBjYW4gYmUgZml4ZWQgYnkgZGlzYWJs
ZSBQSFkgMTBtIHBsbCBvZmYuDQoNCj4gUmV2aWV3ZWQtYnk6IEhvcmF0aXUgVnVsdHVyIDxob3Jh
dGl1LnZ1bHR1ckBtaWNyb2NoaXAuY29tPg0KPiANCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IENo
dW5IYW8gTGluIDxoYXVAcmVhbHRlay5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2V0
aGVybmV0L3JlYWx0ZWsvcjgxNjlfcGh5X2NvbmZpZy5jIHwgMyArKysNCj4gPiAgMSBmaWxlIGNo
YW5nZWQsIDMgaW5zZXJ0aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L3JlYWx0ZWsvcjgxNjlfcGh5X2NvbmZpZy5jDQo+ID4gYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9yZWFsdGVrL3I4MTY5X3BoeV9jb25maWcuYw0KPiA+IGluZGV4IDkzMDQ5NmNkMzRl
ZC4uYjUwZjE2Nzg2YzI0IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3Jl
YWx0ZWsvcjgxNjlfcGh5X2NvbmZpZy5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
cmVhbHRlay9yODE2OV9waHlfY29uZmlnLmMNCj4gPiBAQCAtODI2LDYgKzgyNiw5IEBAIHN0YXRp
YyB2b2lkIHJ0bDgxNjhoXzJfaHdfcGh5X2NvbmZpZyhzdHJ1Y3QNCj4gcnRsODE2OV9wcml2YXRl
ICp0cCwNCj4gPiAgICAgICAgIC8qIGRpc2FibGUgcGh5IHBmbSBtb2RlICovDQo+ID4gICAgICAg
ICBwaHlfbW9kaWZ5X3BhZ2VkKHBoeWRldiwgMHgwYTQ0LCAweDExLCBCSVQoNyksIDApOw0KPiA+
DQo+ID4gKyAgICAgICAvKiBkaXNhYmxlIDEwbSBwbGwgb2ZmICovDQo+ID4gKyAgICAgICBwaHlf
bW9kaWZ5X3BhZ2VkKHBoeWRldiwgMHgwYTQzLCAweDEwLCBCSVQoMCksIDApOw0KPiA+ICsNCj4g
PiAgICAgICAgIHJ0bDgxNjhnX2Rpc2FibGVfYWxkcHMocGh5ZGV2KTsNCj4gPiAgICAgICAgIHJ0
bDgxNjhnX2NvbmZpZ19lZWVfcGh5KHBoeWRldik7ICB9DQo+ID4gLS0NCj4gPiAyLjM3LjINCj4g
Pg0KPiANCj4gLS0NCj4gL0hvcmF0aXUNCj4gDQo+IC0tLS0tLVBsZWFzZSBjb25zaWRlciB0aGUg
ZW52aXJvbm1lbnQgYmVmb3JlIHByaW50aW5nIHRoaXMgZS1tYWlsLg0K
