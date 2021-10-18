Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A46E1430E4E
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 05:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbhJRDiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 23:38:19 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:59953 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232360AbhJRDiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 23:38:00 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 19I3ZTZp8023659, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36503.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 19I3ZTZp8023659
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 18 Oct 2021 11:35:29 +0800
Received: from RTEXMBS06.realtek.com.tw (172.21.6.99) by
 RTEXH36503.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Mon, 18 Oct 2021 11:35:28 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 18 Oct 2021 11:35:28 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::cdd5:82a3:e854:7098]) by
 RTEXMBS04.realtek.com.tw ([fe80::cdd5:82a3:e854:7098%5]) with mapi id
 15.01.2106.013; Mon, 18 Oct 2021 11:35:28 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Colin King <colin.king@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH][next] rtw89: Fix potential dereference of the null pointer sta
Thread-Topic: [PATCH][next] rtw89: Fix potential dereference of the null
 pointer sta
Thread-Index: AQHXwduziBNegQ3KtE6tzEeaYjpkJqvX/pCw
Date:   Mon, 18 Oct 2021 03:35:28 +0000
Message-ID: <9cc681c217a449519aee524b35e6b6bc@realtek.com>
References: <20211015154530.34356-1-colin.king@canonical.com>
In-Reply-To: <20211015154530.34356-1-colin.king@canonical.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS06.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzEwLzE4IOS4iuWNiCAxMjowNDowMA==?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36503.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 10/18/2021 03:26:20
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 166777 [Oct 17 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: pkshih@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 463 463 5854868460de3f0d8e8c0a4df98aeb05fb764a09
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: realtek.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 10/18/2021 03:28:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IENvbGluIEtpbmcgPGNvbGlu
LmtpbmdAY2Fub25pY2FsLmNvbT4NCj4gU2VudDogRnJpZGF5LCBPY3RvYmVyIDE1LCAyMDIxIDEx
OjQ2IFBNDQo+IFRvOiBLYWxsZSBWYWxvIDxrdmFsb0Bjb2RlYXVyb3JhLm9yZz47IERhdmlkIFMg
LiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBKYWt1YiBLaWNpbnNraQ0KPiA8a3ViYUBr
ZXJuZWwub3JnPjsgUGtzaGloIDxwa3NoaWhAcmVhbHRlay5jb20+OyBsaW51eC13aXJlbGVzc0B2
Z2VyLmtlcm5lbC5vcmc7DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGtlcm5lbC1q
YW5pdG9yc0B2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4g
U3ViamVjdDogW1BBVENIXVtuZXh0XSBydHc4OTogRml4IHBvdGVudGlhbCBkZXJlZmVyZW5jZSBv
ZiB0aGUgbnVsbCBwb2ludGVyIHN0YQ0KPiANCj4gRnJvbTogQ29saW4gSWFuIEtpbmcgPGNvbGlu
LmtpbmdAY2Fub25pY2FsLmNvbT4NCj4gDQo+IFRoZSBwb2ludGVyIHJ0d3N0YSBpcyBkZXJlZmVy
ZW5jaW5nIHBvaW50ZXIgc3RhIGJlZm9yZSBzdGEgaXMNCj4gYmVpbmcgbnVsbCBjaGVja2VkLCBz
byB0aGVyZSBpcyBhIHBvdGVudGlhbCBudWxsIHBvaW50ZXIgZGVmZXJlbmNlDQo+IGlzc3VlIHRo
YXQgbWF5IG9jY3VyLiBGaXggdGhpcyBieSBvbmx5IGFzc2lnbmluZyBydHdzdGEgYWZ0ZXIgc3Rh
DQo+IGhhcyBiZWVuIG51bGwgY2hlY2tlZC4gQWRkIGluIGEgbnVsbCBwb2ludGVyIGNoZWNrIG9u
IHJ0d3N0YSBiZWZvcmUNCj4gZGVyZWZlcmVuY2luZyBpdCB0b28uDQo+IA0KPiBGaXhlczogZTNl
YzcwMTdmNmEyICgicnR3ODk6IGFkZCBSZWFsdGVrIDgwMi4xMWF4IGRyaXZlciIpDQo+IEFkZHJl
c3Nlcy1Db3Zlcml0eTogKCJEZXJlZmVyZW5jZSBiZWZvcmUgbnVsbCBjaGVjayIpDQo+IFNpZ25l
ZC1vZmYtYnk6IENvbGluIElhbiBLaW5nIDxjb2xpbi5raW5nQGNhbm9uaWNhbC5jb20+DQo+IC0t
LQ0KPiAgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OS9jb3JlLmMgfCA5ICsrKysr
KystLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkN
Cj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg5L2Nv
cmUuYw0KPiBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODkvY29yZS5jDQo+IGlu
ZGV4IDA2ZmI2ZTViMWIzNy4uMjZmNTJhMjVmNTQ1IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25l
dC93aXJlbGVzcy9yZWFsdGVrL3J0dzg5L2NvcmUuYw0KPiArKysgYi9kcml2ZXJzL25ldC93aXJl
bGVzcy9yZWFsdGVrL3J0dzg5L2NvcmUuYw0KPiBAQCAtMTUzNCw5ICsxNTM0LDE0IEBAIHN0YXRp
YyBib29sIHJ0dzg5X2NvcmVfdHhxX2FnZ193YWl0KHN0cnVjdCBydHc4OV9kZXYgKnJ0d2RldiwN
Cj4gIHsNCj4gIAlzdHJ1Y3QgcnR3ODlfdHhxICpydHd0eHEgPSAoc3RydWN0IHJ0dzg5X3R4cSAq
KXR4cS0+ZHJ2X3ByaXY7DQo+ICAJc3RydWN0IGllZWU4MDIxMV9zdGEgKnN0YSA9IHR4cS0+c3Rh
Ow0KPiAtCXN0cnVjdCBydHc4OV9zdGEgKnJ0d3N0YSA9IChzdHJ1Y3QgcnR3ODlfc3RhICopc3Rh
LT5kcnZfcHJpdjsNCg0KJ3N0YS0+ZHJ2X3ByaXYnIGlzIG9ubHkgYSBwb2ludGVyLCB3ZSBkb24n
dCByZWFsbHkgZGVyZWZlcmVuY2UgdGhlDQpkYXRhIHJpZ2h0IGhlcmUsIHNvIEkgdGhpbmsgdGhp
cyBpcyBzYWZlLiBNb3JlLCBjb21waWxlciBjYW4gb3B0aW1pemUNCnRoaXMgaW5zdHJ1Y3Rpb24g
dGhhdCByZW9yZGVyIGl0IHRvIHRoZSBwbGFjZSBqdXN0IHJpZ2h0IGJlZm9yZSB1c2luZy4NClNv
LCBpdCBzZWVtcyBsaWtlIGEgZmFsc2UgYWxhcm0uDQoNCj4gKwlzdHJ1Y3QgcnR3ODlfc3RhICpy
dHdzdGE7DQo+IA0KPiAtCWlmICghc3RhIHx8IHJ0d3N0YS0+bWF4X2FnZ193YWl0IDw9IDApDQo+
ICsJaWYgKCFzdGEpDQo+ICsJCXJldHVybiBmYWxzZTsNCj4gKwlydHdzdGEgPSAoc3RydWN0IHJ0
dzg5X3N0YSAqKXN0YS0+ZHJ2X3ByaXY7DQo+ICsJaWYgKCFydHdzdGEpDQo+ICsJCXJldHVybiBm
YWxzZTsNCj4gKwlpZiAocnR3c3RhLT5tYXhfYWdnX3dhaXQgPD0gMCkNCj4gIAkJcmV0dXJuIGZh
bHNlOw0KPiANCj4gIAlpZiAocnR3ZGV2LT5zdGF0cy50eF90ZmNfbHYgPD0gUlRXODlfVEZDX01J
RCkNCg0KSSBjaGVjayB0aGUgc2l6ZSBvZiBvYmplY3QgZmlsZXMgYmVmb3JlL2FmdGVyIHRoaXMg
cGF0Y2gsIGFuZA0KdGhlIG9yaWdpbmFsIG9uZSBpcyBzbWFsbGVyLg0KDQogICB0ZXh0ICAgIGRh
dGEgICAgIGJzcyAgICAgZGVjICAgICBoZXggZmlsZW5hbWUNCiAgMTY3ODEgICAgMzM5MiAgICAg
ICAxICAgMjAxNzQgICAgNGVjZSBjb3JlLTAubyAgLy8gb3JpZ2luYWwNCiAgMTY4MTkgICAgMzM5
MiAgICAgICAxICAgMjAyMTIgICAgNGVmNCBjb3JlLTEubyAgLy8gYWZ0ZXIgdGhpcyBwYXRjaA0K
DQpEbyB5b3UgdGhpbmsgaXQgaXMgd29ydGggdG8gYXBwbHkgdGhpcyBwYXRjaD8NCg0KLS0NClBp
bmctS2UNCg0K
