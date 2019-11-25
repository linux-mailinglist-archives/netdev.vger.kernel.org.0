Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 020D5108A8B
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 10:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727172AbfKYJKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 04:10:03 -0500
Received: from mail-oln040092254060.outbound.protection.outlook.com ([40.92.254.60]:48736
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726980AbfKYJKD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Nov 2019 04:10:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vxli5IMZLc1Z5t1KIdqFuREC1UOyUJkCjFeArUzWa338uBCzbyhcs6HGxUJl0l7F1dfALLCDaBTPWyCirMFxFclMA2ZE2/exfYKvpglSw8o6HdYil3+VpLQxHvjr+lkTQv0RHaBlv5zK1CWJ/HtU/zH64ACosW135urwj+91FepNtpYGYnZI5J0eaOumO3GqBm8Z71tkIn7Aafguecab9C8LAKWUwUmvgjpqaMaYnni7xvIUaN8HLDyZ8GmaxVbcJSILseGEtHDQlktwdOu1Hqk2OoiSe8Nc3EOClD8FXeUXhD6CZeI3Ish8SXTqpovYgZvIisXqb1Er6OfmBjyR3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g0HDOi0ZgHcuxAky2+3i1jtEDScTE39u/krrPhYye18=;
 b=RO9ztC4EFDTradzZ+Hd7eDeLHmdlLoqL134rDMHlJmcKPNQBNG2lDnszuKaeIRYZoSXl0R2Ku2XYlP8I2kPeCuNL/aFaDr7AirSSORQjqddVL11HkhtsPhKtW6Fcz3cQXujg8Q+U6u+2Hg6+QQgXN/HNUPCWAr+VViEknVQ0xDts5baUeIGmrrR+ELEinYwiQn6DRkP2b4e7/HNQz2els3BvSxSAwWKtRAV5dWO879Rn+kCy6Y4vcSAOXrnse+8abCT0VdpsrhZMHg9Vb/m05xNAYrNptbPl/yzkXaeMFHBt9kzbiJy18FCSreIkopRUEt6l2O1OywddEv86iNXBFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from HK2APC01FT054.eop-APC01.prod.protection.outlook.com
 (10.152.248.56) by HK2APC01HT038.eop-APC01.prod.protection.outlook.com
 (10.152.249.161) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2474.17; Mon, 25 Nov
 2019 09:09:52 +0000
Received: from PSXP216MB0438.KORP216.PROD.OUTLOOK.COM (10.152.248.59) by
 HK2APC01FT054.mail.protection.outlook.com (10.152.249.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17 via Frontend Transport; Mon, 25 Nov 2019 09:09:52 +0000
Received: from PSXP216MB0438.KORP216.PROD.OUTLOOK.COM
 ([fe80::b880:961e:dd88:8b5d]) by PSXP216MB0438.KORP216.PROD.OUTLOOK.COM
 ([fe80::b880:961e:dd88:8b5d%12]) with mapi id 15.20.2474.023; Mon, 25 Nov
 2019 09:09:52 +0000
From:   Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>
To:     Alexander Lobakin <alobakin@dlink.ru>
CC:     David Miller <davem@davemloft.net>,
        "ecree@solarflare.com" <ecree@solarflare.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "petrm@mellanox.com" <petrm@mellanox.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jaswinder.singh@linaro.org" <jaswinder.singh@linaro.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "johannes.berg@intel.com" <johannes.berg@intel.com>,
        "emmanuel.grumbach@intel.com" <emmanuel.grumbach@intel.com>,
        "luciano.coelho@intel.com" <luciano.coelho@intel.com>,
        "linuxwifi@intel.com" <linuxwifi@intel.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 net-next] net: core: use listified Rx for GRO_NORMAL in
 napi_gro_receive()
Thread-Topic: [PATCH v2 net-next] net: core: use listified Rx for GRO_NORMAL
 in napi_gro_receive()
Thread-Index: AQHVo2IFW7miydWzwUGig6GEl/Vj46ebhG8AgAAIsACAAAw6AA==
Date:   Mon, 25 Nov 2019 09:09:52 +0000
Message-ID: <PSXP216MB0438267E8191486435445DA6804A0@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
References: <20191014080033.12407-1-alobakin@dlink.ru>
 <20191015.181649.949805234862708186.davem@davemloft.net>
 <7e68da00d7c129a8ce290229743beb3d@dlink.ru>
 <PSXP216MB04388962C411CD0B17A86F47804A0@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
 <c762f5eee08a8f2d0d6cb927d7fa3848@dlink.ru>
 <746f768684f266e5a5db1faf8314cd77@dlink.ru>
In-Reply-To: <746f768684f266e5a5db1faf8314cd77@dlink.ru>
Accept-Language: en-AU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MEAPR01CA0110.ausprd01.prod.outlook.com
 (2603:10c6:220:60::26) To PSXP216MB0438.KORP216.PROD.OUTLOOK.COM
 (2603:1096:300:d::20)
x-incomingtopheadermarker: OriginalChecksum:203FB3F987C23C28E936EA3BA501821D039EB4600917140B8B26B6C48B06CBD5;UpperCasedChecksum:E9AADA5753C0DAF02AC972CF249D74F649E19C18D8C3C9412653165F8D849D4A;SizeAsReceived:8588;Count:49
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [jACqFul3O98whUecvfJiFSj7AskTef6V]
x-microsoft-original-message-id: <20191125090930.GA2978@nicholas-usb>
x-ms-publictraffictype: Email
x-incomingheadercount: 49
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 31338f4f-da06-4b78-7453-08d771873acb
x-ms-traffictypediagnostic: HK2APC01HT038:
x-ms-exchange-purlcount: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BTZTIilJ2Kc9MI2NsIOfuAk9H3aYmwGJb9XUd9gd9SWZDjq/vieyP3+Zxczge21Nf1oj26JUNUJpyaEwrimvgHZaJlr5hpSs816CDAUKIqkwXVeAO15ytkumOllmRwvPJ2vwHTFYKABpTm/X4sAy1F0jm8EyhYqKCqZrdRaiN6YKW0MohFZs9J9gf22PYox3i4y+OZprmDJ55pd3aQWOrSRC9fl+KFC2Psx2Tqi2awI=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <2B25CC9523977E4B855D3E1BF2F02712@KORP216.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 31338f4f-da06-4b78-7453-08d771873acb
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2019 09:09:52.4347
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK2APC01HT038
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCBOb3YgMjUsIDIwMTkgYXQgMTE6MjU6NTBBTSArMDMwMCwgQWxleGFuZGVyIExvYmFr
aW4gd3JvdGU6DQo+IEFsZXhhbmRlciBMb2Jha2luIHdyb3RlIDI1LjExLjIwMTkgMTA6NTQ6DQo+
ID4gTmljaG9sYXMgSm9obnNvbiB3cm90ZSAyNS4xMS4yMDE5IDEwOjI5Og0KPiA+ID4gSGksDQo+
ID4gPiANCj4gPiA+IE9uIFdlZCwgT2N0IDE2LCAyMDE5IGF0IDEwOjMxOjMxQU0gKzAzMDAsIEFs
ZXhhbmRlciBMb2Jha2luIHdyb3RlOg0KPiA+ID4gPiBEYXZpZCBNaWxsZXIgd3JvdGUgMTYuMTAu
MjAxOSAwNDoxNjoNCj4gPiA+ID4gPiBGcm9tOiBBbGV4YW5kZXIgTG9iYWtpbiA8YWxvYmFraW5A
ZGxpbmsucnU+DQo+ID4gPiA+ID4gRGF0ZTogTW9uLCAxNCBPY3QgMjAxOSAxMTowMDozMyArMDMw
MA0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBDb21taXQgMzIzZWJiNjFlMzJiNCAoIm5ldDogdXNl
IGxpc3RpZmllZCBSWCBmb3IgaGFuZGxpbmcgR1JPX05PUk1BTA0KPiA+ID4gPiA+ID4gc2ticyIp
IG1hZGUgdXNlIG9mIGxpc3RpZmllZCBza2IgcHJvY2Vzc2luZyBmb3IgdGhlIHVzZXJzIG9mDQo+
ID4gPiA+ID4gPiBuYXBpX2dyb19mcmFncygpLg0KPiA+ID4gPiA+ID4gVGhlIHNhbWUgdGVjaG5p
cXVlIGNhbiBiZSB1c2VkIGluIGEgd2F5IG1vcmUgY29tbW9uIG5hcGlfZ3JvX3JlY2VpdmUoKQ0K
PiA+ID4gPiA+ID4gdG8gc3BlZWQgdXAgbm9uLW1lcmdlZCAoR1JPX05PUk1BTCkgc2ticyBmb3Ig
YSB3aWRlIHJhbmdlIG9mIGRyaXZlcnMNCj4gPiA+ID4gPiA+IGluY2x1ZGluZyBncm9fY2VsbHMg
YW5kIG1hYzgwMjExIHVzZXJzLg0KPiA+ID4gPiA+ID4gVGhpcyBzbGlnaHRseSBjaGFuZ2VzIHRo
ZSByZXR1cm4gdmFsdWUgaW4gY2FzZXMgd2hlcmUgc2tiIGlzIGJlaW5nDQo+ID4gPiA+ID4gPiBk
cm9wcGVkIGJ5IHRoZSBjb3JlIHN0YWNrLCBidXQgaXQgc2VlbXMgdG8gaGF2ZSBubyBpbXBhY3Qg
b24gcmVsYXRlZA0KPiA+ID4gPiA+ID4gZHJpdmVycycgZnVuY3Rpb25hbGl0eS4NCj4gPiA+ID4g
PiA+IGdyb19ub3JtYWxfYmF0Y2ggaXMgbGVmdCB1bnRvdWNoZWQgYXMgaXQncyB2ZXJ5IGluZGl2
aWR1YWwgZm9yIGV2ZXJ5DQo+ID4gPiA+ID4gPiBzaW5nbGUgc3lzdGVtIGNvbmZpZ3VyYXRpb24g
YW5kIG1pZ2h0IGJlIHR1bmVkIGluIG1hbnVhbCBvcmRlciB0bw0KPiA+ID4gPiA+ID4gYWNoaWV2
ZSBhbiBvcHRpbWFsIHBlcmZvcm1hbmNlLg0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IFNpZ25l
ZC1vZmYtYnk6IEFsZXhhbmRlciBMb2Jha2luIDxhbG9iYWtpbkBkbGluay5ydT4NCj4gPiA+ID4g
PiA+IEFja2VkLWJ5OiBFZHdhcmQgQ3JlZSA8ZWNyZWVAc29sYXJmbGFyZS5jb20+DQo+ID4gPiA+
ID4NCj4gPiA+ID4gPiBBcHBsaWVkLCB0aGFuayB5b3UuDQo+ID4gPiA+IA0KPiA+ID4gPiBEYXZp
ZCwgRWR3YXJkLCBFcmljLCBJbGlhcywNCj4gPiA+ID4gdGhhbmsgeW91IGZvciB5b3VyIHRpbWUu
DQo+ID4gPiA+IA0KPiA+ID4gPiBSZWdhcmRzLA0KPiA+ID4gPiDhmrcg4ZuWIOGaoiDhmqYg4Zqg
IOGasQ0KPiA+ID4gDQo+ID4gPiBJIGFtIHZlcnkgc29ycnkgdG8gYmUgdGhlIGJlYXJlciBvZiBi
YWQgbmV3cy4gSXQgYXBwZWFycyB0aGF0IHRoaXMNCj4gPiA+IGNvbW1pdCBpcyBjYXVzaW5nIGEg
cmVncmVzc2lvbiBpbiBMaW51eCA1LjQuMC1yYzgtbmV4dC0yMDE5MTEyMiwNCj4gPiA+IHByZXZl
bnRpbmcgbWUgZnJvbSBjb25uZWN0aW5nIHRvIFdpLUZpIG5ldHdvcmtzLiBJIGhhdmUgYSBEZWxs
IFhQUw0KPiA+ID4gOTM3MA0KPiA+ID4gKEludGVsIENvcmUgaTctODY1MFUpIHdpdGggSW50ZWwg
V2lyZWxlc3MgODI2NSBbODA4NjoyNGZkXS4NCj4gPiANCj4gPiBIaSENCj4gPiANCj4gPiBJdCdz
IGEgYml0IHN0cmFuZ2UgYXMgdGhpcyBjb21taXQgZG9lc24ndCBkaXJlY3RseSBhZmZlY3QgdGhl
IHBhY2tldA0KPiA+IGZsb3cuIEkgZG9uJ3QgaGF2ZSBhbnkgaXdsd2lmaSBoYXJkd2FyZSBhdCB0
aGUgbW9tZW50LCBzbyBsZXQncyBzZWUgaWYNCj4gPiBhbnlvbmUgZWxzZSB3aWxsIGJlIGFibGUg
dG8gcmVwcm9kdWNlIHRoaXMgKGZvciBub3csIGl0IGlzIHRoZSBmaXJzdA0KPiA+IHJlcG9ydCBp
biBhIH42IHdlZWtzIGFmdGVyIGFwcGx5aW5nIHRvIG5ldC1uZXh0KS4NCj4gPiBBbnl3YXksIEkn
bGwgaW52ZXN0aWdhdGUgaXdsd2lmaSdzIFJ4IHByb2Nlc3NpbmcgLS0gbWF5YmUgSSBjb3VsZCBm
aW5kDQo+ID4gc29tZXRoaW5nIGRyaXZlci1zcGVjaWZpYyB0aGF0IG1pZ2h0IHByb2R1Y2UgdGhp
cy4NCkp1c3QgaW4gY2FzZSwgSSBkb3VibGUgY2hlY2tlZCBieSByZWFwcGx5aW5nIHRoZSBwYXRj
aCB0byBjaGVjayBpdCBpcyANCnRoZSBwcm9ibGVtLiBUaGUgcHJvYmxlbSByZWFwcGVhcmVkLiBT
byBJIGFtIHN1cmUuDQoNCkhlcmUncyB3aGF0IEkgd2lsbCBkby4gSSBrbm93IHNvbWVib2R5IHdp
dGggdGhlIHNhbWUgRGVsbCBYUFMgOTM3MCwgDQpleGNlcHQgdGhlaXJzIGhhcyB0aGUgSW50ZWwg
Q29yZSBpNyA4NTUwVSBhbmQgS2lsbGVyIFdpLUZpLiBNaW5lIGlzIHRoZSANCiJidXNpbmVzcyIg
bW9kZWwsIHdoaWNoIHdhcyBoYXJkZXIgdG8gb2J0YWluLiBJIGhhdmUgYmVlbiBkb2luZyBiaXNl
Y3RzIA0Kb24gYSBVU0ItQyBTU0QgYmVjYXVzZSBJIGRvIG5vdCBoYXZlIGVub3VnaCBzcGFjZSBv
biB0aGUgaW50ZXJuYWwgTlZNZSANCmRyaXZlLiBJIHdpbGwgYXNrIHRvIGJvcnJvdyB0aGVpciBs
YXB0b3AsIGFuZCBib290IG9mZiB0aGUgZHJpdmUgYXMgSSANCmhhdmUgYmVlbiBkb2luZyB3aXRo
IG15IGxhcHRvcC4gSWYgdGhlIHByb2JsZW0gZG9lcyBub3QgYXBwZWFyIG9uIHRoZWlyIA0KbGFw
dG9wLCB0aGVuIHRoZXJlIGlzIGEgZ29vZCBjaGFuY2UgdGhhdCB0aGUgcHJvYmxlbSBpcyBzcGVj
aWZpYyB0byANCml3bHdpZmkuDQoNCj4gPiANCj4gPiBUaGFuayB5b3UgZm9yIHRoZSByZXBvcnQu
DQo+ID4gDQo+ID4gPiBJIGRpZCBhIGJpc2VjdCwgYW5kIHRoaXMgY29tbWl0IHdhcyBuYW1lZCB0
aGUgY3VscHJpdC4gSSB0aGVuIGFwcGxpZWQNCj4gPiA+IHRoZSByZXZlcnNlIHBhdGNoIG9uIGFu
b3RoZXIgY2xvbmUgb2YgTGludXggbmV4dC0yMDE5MTEyMiwgYW5kIGl0DQo+ID4gPiBzdGFydGVk
IHdvcmtpbmcuDQo+ID4gPiANCj4gPiA+IDY1NzBiYzc5YzBkZmZmMGYyMjhiN2FmZDJkZTcyMGZi
NGU4NGQ2MWQNCj4gPiA+IG5ldDogY29yZTogdXNlIGxpc3RpZmllZCBSeCBmb3IgR1JPX05PUk1B
TCBpbiBuYXBpX2dyb19yZWNlaXZlKCkNCj4gPiA+IA0KPiA+ID4gWW91IGNhbiBzZWUgbW9yZSBh
dCB0aGUgYnVnIHJlcG9ydCBJIGZpbGVkIGF0IFswXS4NCj4gPiA+IA0KPiA+ID4gWzBdDQo+ID4g
PiBodHRwczovL2J1Z3ppbGxhLmtlcm5lbC5vcmcvc2hvd19idWcuY2dpP2lkPTIwNTY0Nw0KPiA+
ID4gDQo+ID4gPiBJIGNhbGxlZCBvbiBvdGhlcnMgYXQgWzBdIHRvIHRyeSB0byByZXByb2R1Y2Ug
dGhpcyAtIHlvdSBzaG91bGQgbm90DQo+ID4gPiBwdWxsDQo+ID4gPiBhIHBhdGNoIGJlY2F1c2Ug
b2YgYSBzaW5nbGUgcmVwb3J0ZXIgLSBhcyBJIGNvdWxkIGJlIHdyb25nLg0KPiA+ID4gDQo+ID4g
PiBQbGVhc2UgbGV0IG1lIGtub3cgaWYgeW91IHdhbnQgbWUgdG8gZ2l2ZSBtb3JlIGRlYnVnZ2lu
ZyBpbmZvcm1hdGlvbg0KPiA+ID4gb3INCj4gPiA+IHRlc3QgYW55IHBvdGVudGlhbCBmaXhlcy4g
SSBhbSBoYXBweSB0byBoZWxwIHRvIGZpeCB0aGlzLiA6KQ0KPiANCj4gQW5kIHlvdSBjYW4gYWxz
byBzZXQgL3Byb2Mvc3lzL25ldC9jb3JlL2dyb19ub3JtYWxfYmF0Y2ggdG8gdGhlIHZhbHVlDQo+
IG9mIDEgYW5kIHNlZSBpZiB0aGVyZSBhcmUgYW55IGNoYW5nZXMuIFRoaXMgdmFsdWUgbWFrZXMg
R1JPIHN0YWNrIHRvDQo+IGJlaGF2ZSBqdXN0IGxpa2Ugd2l0aG91dCB0aGUgcGF0Y2guDQpUaGUg
ZGVmYXVsdCB2YWx1ZSBvZiAvcHJvYy9zeXMvbmV0L2NvcmUvZ3JvX25vcm1hbF9iYXRjaCB3YXMg
OC4NCg0KU2V0dGluZyBpdCB0byAxIGFsbG93ZWQgaXQgdG8gY29ubmVjdCB0byBXaS1GaSBuZXR3
b3JrLg0KDQpTZXR0aW5nIGl0IGJhY2sgdG8gOCBkaWQgbm90IGtpbGwgdGhlIGNvbm5lY3Rpb24u
DQoNCkJ1dCB3aGVuIEkgZGlzY29ubmVjdGVkIGFuZCB0cmllZCB0byByZWNvbm5lY3QsIGl0IGRp
ZCBub3QgcmUtY29ubmVjdC4NCg0KSGVuY2UsIGl0IGFwcGVhcnMgdGhhdCB0aGUgcHJvYmxlbSBv
bmx5IGFmZmVjdHMgdGhlIGluaXRpYWwgaGFuZHNoYWtlIA0Kd2hlbiBhc3NvY2lhdGluZyB3aXRo
IGEgbmV0d29yaywgYW5kIG5vdCBub3JtYWwgcGFja2V0IGZsb3cuDQoNCj4gDQo+ID4gPiBLaW5k
IHJlZ2FyZHMsDQo+ID4gPiBOaWNob2xhcyBKb2huc29uDQo+ID4gDQo+ID4gUmVnYXJkcywNCj4g
PiDhmrcg4ZuWIOGaoiDhmqYg4ZqgIOGasQ0KPiANCj4gUmVnYXJkcywNCj4g4Zq3IOGbliDhmqIg
4ZqmIOGaoCDhmrENCg0KUmVnYXJkcywNCk5pY2hvbGFzDQo=
