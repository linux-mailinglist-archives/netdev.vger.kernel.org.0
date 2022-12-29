Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6B2658832
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 01:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232576AbiL2Au4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 19:50:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiL2Auz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 19:50:55 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9F72F12D01;
        Wed, 28 Dec 2022 16:50:54 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2BT0nkuH7024151, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2BT0nkuH7024151
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Thu, 29 Dec 2022 08:49:46 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Thu, 29 Dec 2022 08:50:40 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 29 Dec 2022 08:50:39 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Thu, 29 Dec 2022 08:50:39 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Morgan <macroalpha82@gmail.com>,
        "Nitin Gupta" <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: RE: [RFC PATCH v1 12/19] rtw88: sdio: Add HCI implementation for SDIO based chipsets
Thread-Topic: [RFC PATCH v1 12/19] rtw88: sdio: Add HCI implementation for
 SDIO based chipsets
Thread-Index: AQHZGktCsajZQIMfG02cvFqSiCFada6C3HLQ///QmACAAVnS4A==
Date:   Thu, 29 Dec 2022 00:50:39 +0000
Message-ID: <a2449a2d1e664bcc8962af4667aa1290@realtek.com>
References: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
 <20221227233020.284266-13-martin.blumenstingl@googlemail.com>
 <2a9e671ef17444238fee3e7e6f14484b@realtek.com>
 <CAFBinCDVq6o0c6OLSD0PhQKFPrXohjhdJeXk=5wuDEWMKwufrA@mail.gmail.com>
In-Reply-To: <CAFBinCDVq6o0c6OLSD0PhQKFPrXohjhdJeXk=5wuDEWMKwufrA@mail.gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEyLzI4IOS4i+WNiCAxMDoxODowMA==?=
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWFydGluIEJsdW1lbnN0
aW5nbCA8bWFydGluLmJsdW1lbnN0aW5nbEBnb29nbGVtYWlsLmNvbT4NCj4gU2VudDogV2VkbmVz
ZGF5LCBEZWNlbWJlciAyOCwgMjAyMiA4OjAwIFBNDQo+IFRvOiBQaW5nLUtlIFNoaWggPHBrc2hp
aEByZWFsdGVrLmNvbT4NCj4gQ2M6IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZzsgWWFu
LUhzdWFuIENodWFuZyA8dG9ueTA2MjBlbW1hQGdtYWlsLmNvbT47IEthbGxlIFZhbG8NCj4gPGt2
YWxvQGtlcm5lbC5vcmc+OyBVbGYgSGFuc3NvbiA8dWxmLmhhbnNzb25AbGluYXJvLm9yZz47IGxp
bnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxp
bnV4LW1tY0B2Z2VyLmtlcm5lbC5vcmc7IENocmlzIE1vcmdhbiA8bWFjcm9hbHBoYTgyQGdtYWls
LmNvbT47IE5pdGluIEd1cHRhDQo+IDxuaXRpbi5ndXB0YTk4MUBnbWFpbC5jb20+OyBOZW8gSm91
IDxuZW9qb3VAZ21haWwuY29tPjsgSmVybmVqIFNrcmFiZWMgPGplcm5lai5za3JhYmVjQGdtYWls
LmNvbT4NCj4gU3ViamVjdDogUmU6IFtSRkMgUEFUQ0ggdjEgMTIvMTldIHJ0dzg4OiBzZGlvOiBB
ZGQgSENJIGltcGxlbWVudGF0aW9uIGZvciBTRElPIGJhc2VkIGNoaXBzZXRzDQo+IA0KPiBIaSBQ
aW5nLUtlLA0KPiANCj4gYXMgYWx3YXlzOiB0aGFuayB5b3Ugc28gbXVjaCBmb3IgdGFraW5nIHRp
bWUgdG8gZ28gdGhyb3VnaCB0aGlzIQ0KPiANCj4gT24gV2VkLCBEZWMgMjgsIDIwMjIgYXQgMTA6
MzkgQU0gUGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+IHdyb3RlOg0KDQpbLi4uXQ0K
DQo+ID4gPiArc3RhdGljIHZvaWQgcnR3X3NkaW9fcnhfaXNyKHN0cnVjdCBydHdfZGV2ICpydHdk
ZXYpDQo+ID4gPiArew0KPiA+ID4gKyAgICAgdTMyIHJ4X2xlbjsNCj4gPiA+ICsNCj4gPiA+ICsg
ICAgIHdoaWxlICh0cnVlKSB7DQo+ID4NCj4gPiBhZGQgYSBsaW1pdCB0byBwcmV2ZW50IGluZmlu
aXRlIGxvb3AuDQo+IERvIHlvdSBoYXZlIGFueSByZWNvbW1lbmRhdGlvbnMgb24gaG93IG1hbnkg
cGFja2V0cyB0byBwdWxsIGluIG9uZSBnbz8NCj4gTXkgdGhpbmtpbmcgaXM6IHB1bGxpbmcgdG8g
bGl0dGxlIGRhdGEgYXQgb25jZSBjYW4gaHVydCBwZXJmb3JtYW5jZQ0KDQpUaGlzIGlzIHRvIHBy
ZXZlbnQgdW5leHBlY3RlZCB0aGluZ3MgaGFwcGVuLCBhbmQgbm9ybWFsbHkgd2UgcmVjZWl2ZS9z
ZW5kDQphbGwgcGFja2V0cyBhdCBvbmNlIGxpa2Ugd2hpbGUodHJ1ZSkgY29kZS4gU28sIG1heWJl
IHdlIGNhbiBoYXZlIHJvdWdoIGxpbWl0LA0KbGlrZSA1MTIgdGhhdCB3b3VsZCBiZSBlbm91Z2gg
Zm9yIG1vc3QgY2FzZXMuIFRvIGhhdmUgYWNjdXJhdGUgbnVtYmVyLCB5b3UNCmNhbiBkbyBleHBl
cmltZW50cyB3aXRoIHRoZSBoaWdoZXN0IHBlcmZvcm1hbmNlIHRvIHNlZSB0aGUgbG9vcCBjb3Vu
dCBpbg0KcmVhbCB1c2FnZSwgYW5kIDUgb3IgMTAgdGltZXMgY291bnQgYXMgbGltaXQuDQoNCkhv
d2V2ZXIsIHdoZW4gSSByZXZpZXdlZCBydHc4OCBVU0IgcGF0Y2hlcywgSSBmb3VuZCB3ZSBjYW4n
dCBhbHdheXMgYnJlYWsNCnRoZSBsb29wLCBiZWNhdXNlIGl0IGNvdWxkIG9ubHkgb25lIGNoYW5j
ZSB0byBmcmVlIHNrYihzKS4gU28sIHlvdSBzaG91bGQNCm1ha2Ugc3VyZSB3ZSByZWFsbHkgY2Fu
IGJyZWFrIHRoZSBsb29wIGxvZ2ljYWxseSwgYW5kIHRoZW4gZGVjaWRlIHdoaWNoDQpsaW1pdCBp
cyBzdWl0YWJsZSBmb3IgdXMuDQoNCj4gDQo+IFsuLi5dDQo+ID4NCj4gPiA+ICsNCj4gPiA+ICtz
dGF0aWMgdm9pZCBydHdfc2Rpb19wcm9jZXNzX3R4X3F1ZXVlKHN0cnVjdCBydHdfZGV2ICpydHdk
ZXYsDQo+ID4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBlbnVtIHJ0d190
eF9xdWV1ZV90eXBlIHF1ZXVlKQ0KPiA+ID4gK3sNCj4gPiA+ICsgICAgIHN0cnVjdCBydHdfc2Rp
byAqcnR3c2RpbyA9IChzdHJ1Y3QgcnR3X3NkaW8gKilydHdkZXYtPnByaXY7DQo+ID4gPiArICAg
ICBzdHJ1Y3Qgc2tfYnVmZiAqc2tiOw0KPiA+ID4gKyAgICAgaW50IHJldDsNCj4gPiA+ICsNCj4g
PiA+ICsgICAgIHdoaWxlICh0cnVlKSB7DQo+ID4NCj4gPiBDYW4gd2UgaGF2ZSBhIGxpbWl0Pw0K
PiBTaW1pbGFyIHRvIHRoZSBxdWVzdGlvbiBhYm92ZTogZG8geW91IGhhdmUgYW55IHJlY29tbWVu
ZGF0aW9ucyBvbiBob3cNCj4gbWFueSBwYWNrZXRzIChwZXIgcXVldWUpIHRvIHNlbmQgaW4gb25l
IGdvPw0KPiANCg0KUGluZy1LZQ0KDQo=
