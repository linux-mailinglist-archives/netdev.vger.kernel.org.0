Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E339108E9B
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 14:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbfKYNMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 08:12:08 -0500
Received: from mail-oln040092254075.outbound.protection.outlook.com ([40.92.254.75]:2576
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725823AbfKYNMH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Nov 2019 08:12:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=doM9DUeg9z2O2u3MlnbOyTFSwCAnqwzI3ZP1vFwgC2nXdwCEO2n81yi/CuB0w3UAr1L7vnwMJxh9Aph5COdwv0rrK1bHB+W1Lfo8OsyJsQdNQ0kYaEY/xNR4QZplIyiDHfCuibYlMfJ/l0Gn+YYzqnkG0PRpniMeFWVtu/0jNS+EJo8QpxZeTdmjprQ7wNIWdILNCwrOnAULJsa2557UmHH3kTPo2mbwNFBZ5J2gXWbyzFhPOlR9oDgosW19VmBjZ4gI6OvqCM3r2ydkUDF11fAQdbSFbM48zwPKYjnZIA9107NzPz/8FEKuZc3JnuZtdfMgk/RROF4giFuYWA1Qwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ohNvp22acW0KVDijrLIXrbuNwLLO3a3PejuCv9xRdcs=;
 b=YuAw8Ttr+KFp+bvCnneXumrsbpSVTfAsmTRmhvYTNOdhABsjU+MweL5j8wNN+Lo4S1KYXW6FrUAzZFBBNMppp0YVNUcVwKxjFps2ex4k0ul9FhRaET4BK2wKz8xmXscerkaWtLe8jzKBZ/WlqTzc13dehnTe8iB51Kbn7zCofwCVw0t4ghh8wn/ik0FWZsDQ9smtcX0lrUM3iSm2DuO4+ka+JJ5WWJ7gvejlInoH+qmT1cRMuUGJIOLPBhX/6jlJnzYlS9v4kHm8NvMiu6K+OEV7a7krpKltLFm0xBtyojn8/V9WicMOyMiZGjwdRrj0cbyid+IGUO53c2wt0xH5qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from HK2APC01FT032.eop-APC01.prod.protection.outlook.com
 (10.152.248.59) by HK2APC01HT110.eop-APC01.prod.protection.outlook.com
 (10.152.249.201) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2474.17; Mon, 25 Nov
 2019 13:11:18 +0000
Received: from PSXP216MB0438.KORP216.PROD.OUTLOOK.COM (10.152.248.56) by
 HK2APC01FT032.mail.protection.outlook.com (10.152.248.188) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17 via Frontend Transport; Mon, 25 Nov 2019 13:11:18 +0000
Received: from PSXP216MB0438.KORP216.PROD.OUTLOOK.COM
 ([fe80::b880:961e:dd88:8b5d]) by PSXP216MB0438.KORP216.PROD.OUTLOOK.COM
 ([fe80::b880:961e:dd88:8b5d%12]) with mapi id 15.20.2474.023; Mon, 25 Nov
 2019 13:11:18 +0000
From:   Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>
To:     Edward Cree <ecree@solarflare.com>
CC:     Alexander Lobakin <alobakin@dlink.ru>,
        David Miller <davem@davemloft.net>,
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
Thread-Index: AQHVo2IFW7miydWzwUGig6GEl/Vj46ebhG8AgAAIsACAAAw6AIAAFs0AgAAsrQA=
Date:   Mon, 25 Nov 2019 13:11:18 +0000
Message-ID: <PSXP216MB0438DBC8CF65DCA2DD0E3441804A0@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
References: <20191014080033.12407-1-alobakin@dlink.ru>
 <20191015.181649.949805234862708186.davem@davemloft.net>
 <7e68da00d7c129a8ce290229743beb3d@dlink.ru>
 <PSXP216MB04388962C411CD0B17A86F47804A0@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
 <c762f5eee08a8f2d0d6cb927d7fa3848@dlink.ru>
 <746f768684f266e5a5db1faf8314cd77@dlink.ru>
 <PSXP216MB0438267E8191486435445DA6804A0@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
 <cc08834c-ccb3-263a-2967-f72a9d72535a@solarflare.com>
In-Reply-To: <cc08834c-ccb3-263a-2967-f72a9d72535a@solarflare.com>
Accept-Language: en-AU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SYBPR01CA0179.ausprd01.prod.outlook.com
 (2603:10c6:10:52::23) To PSXP216MB0438.KORP216.PROD.OUTLOOK.COM
 (2603:1096:300:d::20)
x-incomingtopheadermarker: OriginalChecksum:83426C5350D6A4CDD52E310BDF6431B834348114CB2D97A5AABB67D9B19F0221;UpperCasedChecksum:06C2698E1D3825EF93B4086A5ED91AD4183A2D94CE9469DB140326ACB0B51424;SizeAsReceived:8820;Count:49
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [chpfik922Qy7yqYdy2PbI23sKuMVrgcKos8/m8D/PZyjyaarPYOjprXn4sWf+Hz4r8tRx3PxGWM=]
x-microsoft-original-message-id: <20191125131102.GB2616@nicholas-usb>
x-ms-publictraffictype: Email
x-incomingheadercount: 49
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 84dbd356-32ea-4374-3a89-08d771a8f577
x-ms-traffictypediagnostic: HK2APC01HT110:
x-ms-exchange-purlcount: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6Zx8Dv0nzwhNKVjYYcHHIvxKlwxtoxaiH6bmODvUsRL7YwJc4CjPc/YUA9t4OGzDRt0bWQyfZWFTK5+jVH1HC58ADWNErfjAwqTcr+7/yQeyVhVwxKzauL/SfKwqMPHpXZqjXb2W+sdgG+xAI4jR73JVjFMAt2hf4bHSrnt8gquBV2f9o2Sqv2SmgLBBpMAX+iiUJenkGj+5az+oCzyR1IeDrWu/Yexb8kFM/KOEAl8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E7EE88E42A23AB4DAAE5EC533D595284@KORP216.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 84dbd356-32ea-4374-3a89-08d771a8f577
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2019 13:11:18.6159
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK2APC01HT110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCBOb3YgMjUsIDIwMTkgYXQgMTA6MzE6MTJBTSArMDAwMCwgRWR3YXJkIENyZWUgd3Jv
dGU6DQo+IE9uIDI1LzExLzIwMTkgMDk6MDksIE5pY2hvbGFzIEpvaG5zb24gd3JvdGU6DQo+ID4g
VGhlIGRlZmF1bHQgdmFsdWUgb2YgL3Byb2Mvc3lzL25ldC9jb3JlL2dyb19ub3JtYWxfYmF0Y2gg
d2FzIDguDQo+ID4gU2V0dGluZyBpdCB0byAxIGFsbG93ZWQgaXQgdG8gY29ubmVjdCB0byBXaS1G
aSBuZXR3b3JrLg0KPiA+DQo+ID4gU2V0dGluZyBpdCBiYWNrIHRvIDggZGlkIG5vdCBraWxsIHRo
ZSBjb25uZWN0aW9uLg0KPiA+DQo+ID4gQnV0IHdoZW4gSSBkaXNjb25uZWN0ZWQgYW5kIHRyaWVk
IHRvIHJlY29ubmVjdCwgaXQgZGlkIG5vdCByZS1jb25uZWN0Lg0KPiA+DQo+ID4gSGVuY2UsIGl0
IGFwcGVhcnMgdGhhdCB0aGUgcHJvYmxlbSBvbmx5IGFmZmVjdHMgdGhlIGluaXRpYWwgaGFuZHNo
YWtlIA0KPiA+IHdoZW4gYXNzb2NpYXRpbmcgd2l0aCBhIG5ldHdvcmssIGFuZCBub3Qgbm9ybWFs
IHBhY2tldCBmbG93Lg0KPiBUaGF0IHNvdW5kcyBsaWtlIHRoZSBHUk8gYmF0Y2ggaXNuJ3QgZ2V0
dGluZyBmbHVzaGVkIGF0IHRoZSBlbmRvZiB0aGUNCj4gwqBOQVBJIOKAlCBtYXliZSB0aGUgZHJp
dmVyIGlzbid0IGNhbGxpbmcgbmFwaV9jb21wbGV0ZV9kb25lKCkgYXQgdGhlDQo+IMKgYXBwcm9w
cmlhdGUgdGltZT8NCj4gSW5kZWVkLCBmcm9tIGRpZ2dpbmcgdGhyb3VnaCB0aGUgbGF5ZXJzIG9m
IGl3bHdpZmkgSSBldmVudHVhbGx5IGdldCB0bw0KPiDCoGl3bF9wY2llX3J4X2hhbmRsZSgpIHdo
aWNoIGRvZXNuJ3QgcmVhbGx5IGhhdmUgYSBOQVBJIHBvbGwgKHRoZQ0KPiDCoG5hcGktPnBvbGwg
ZnVuY3Rpb24gaXMgaXdsX3BjaWVfZHVtbXlfbmFwaV9wb2xsKCkgeyBXQVJOX09OKDEpOw0KPiDC
oHJldHVybiAwOyB9KSBhbmQgaW5zdGVhZCBjYWxscyBuYXBpX2dyb19mbHVzaCgpIGF0IHRoZSBl
bmQgb2YgaXRzIFJYDQo+IMKgaGFuZGxpbmcuwqAgVW5mb3J0dW5hdGVseSwgbmFwaV9ncm9fZmx1
c2goKSBpcyBubyBsb25nZXIgZW5vdWdoLA0KPiDCoGJlY2F1c2UgaXQgZG9lc24ndCBjYWxsIGdy
b19ub3JtYWxfbGlzdCgpIHNvIHRoZSBwYWNrZXRzIG9uIHRoZQ0KPiDCoEdST19OT1JNQUwgbGlz
dCBqdXN0IHNpdCB0aGVyZSBpbmRlZmluaXRlbHkuDQo+IA0KPiBJdCB3YXMgc2VlaW5nIGRyaXZl
cnMgY2FsbGluZyBuYXBpX2dyb19mbHVzaCgpIGRpcmVjdGx5IHRoYXQgaGFkIG1lDQo+IMKgd29y
cmllZCBpbiB0aGUgZmlyc3QgcGxhY2UgYWJvdXQgd2hldGhlciBsaXN0aWZ5aW5nIG5hcGlfZ3Jv
X3JlY2VpdmUoKQ0KPiDCoHdhcyBzYWZlIGFuZCB3aGVyZSB0aGUgZ3JvX25vcm1hbF9saXN0KCkg
c2hvdWxkIGdvLg0KPiBJIHdvbmRlcmVkIGlmIG90aGVyIGRyaXZlcnMgdGhhdCBzaG93IHVwIGlu
IFsxXSBuZWVkZWQgZml4aW5nIHdpdGggYQ0KPiDCoGdyb19ub3JtYWxfbGlzdCgpIG5leHQgdG8g
dGhlaXIgbmFwaV9ncm9fZmx1c2goKSBjYWxsLsKgIEZyb20gYSBjdXJzb3J5DQo+IMKgY2hlY2s6
DQo+IGJyb2NhZGUvYm5hOiBoYXMgYSByZWFsIHBvbGxlciwgY2FsbHMgbmFwaV9jb21wbGV0ZV9k
b25lKCkgc28gaXMgT0suDQo+IGNvcnRpbmEvZ2VtaW5pOiBjYWxscyBuYXBpX2NvbXBsZXRlX2Rv
bmUoKSBzdHJhaWdodCBhZnRlcg0KPiDCoG5hcGlfZ3JvX2ZsdXNoKCksIHNvIGlzIE9LLg0KPiBo
aXNpbGljb24vaG5zMzogY2FsbHMgbmFwaV9jb21wbGV0ZSgpLCBzbyBpcyBfcHJvYmFibHlfIE9L
Lg0KPiBCdXQgaXQncyBmYXIgZnJvbSBjbGVhciB0byBtZSB3aHkgKmFueSogb2YgdGhvc2UgZHJp
dmVycyBhcmUgY2FsbGluZw0KPiDCoG5hcGlfZ3JvX2ZsdXNoKCkgdGhlbXNlbHZlcy4uLg0KUGFy
ZG9uIG15IGxhY2sgb2YgdW5kZXJzdGFuZGluZywgYnV0IGlzIGl0IHVudXN1YWwgdGhhdCBzb21l
dGhpbmcgdGhhdCANCnRoZSBkcml2ZXJzIHNob3VsZCBub3QgYmUgY2FsbGluZyBiZSBleHBvc2Vk
IHRvIHRoZSBkcml2ZXJzPyBDb3VsZCBpdCBiZSANCmhpZGRlbiBmcm9tIHRoZSBkcml2ZXJzIHNv
IHRoYXQgaXQgaXMgb3V0IG9mIHNjb3BlLCBvbmNlIHRoZSBjdXJyZW50IA0KZHJpdmVycyBhcmUg
bW9kaWZpZWQgdG8gbm90IHVzZSBpdD8NCg0KPiANCj4gLUVkDQo+IA0KPiBbMV06IGh0dHBzOi8v
ZWxpeGlyLmJvb3RsaW4uY29tL2xpbnV4L2xhdGVzdC9pZGVudC9uYXBpX2dyb19mbHVzaA0KS2lu
ZCByZWdhcmRzLA0KTmljaG9sYXMNCg==
