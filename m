Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F199041D804
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 12:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350107AbhI3KrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 06:47:00 -0400
Received: from mail-eopbgr80117.outbound.protection.outlook.com ([40.107.8.117]:53123
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1350082AbhI3Kq7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 06:46:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SPzUSZGUTx84pN1Db2LG4s9JOAlLB6Myd/vVRHomQkBH9seD9qNnbvT3CxvPjXtRbHuu2hnArQdKCcI3wj+hSp+xE9pxiGI2SiH3RV/zJEFqA7QU4FosJfcb2S20xjmkQvT02TdajxVmzM6yI/h552tA6T/PNcQOOXRjcpUf9Qsql4r1ODmA2eLtFeKl8NNQDpwrJQTrgXOUuGc6bki7/8uJh+5mWz3Hjyva6zGuN+w0UfUW5NLnPsF9R/YO9eONiJ7hjXpn0l3S9RfIkxkr+LszOdvrlkZQ8Qh7GpZoxilTvRjFEBuwoUVWVBZi9NAgLmFbWga/MOUqwLvLMRG17Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=AMXXOpolNiiWCh9We3FfQb9HMKTtTJGTOUaHHgv+lf8=;
 b=KyWep/4tHozdLgvn17/JkJcoh8AMs7mIUhvz7Lzuygoi4Fn8kCGWpSuMsrOQZ/XPvTYGqT6jmv12DFudL6rTskJRMLf3VmxDhk3Kt72q4Q8kR2pIzD0Pe7qgTmXFczWkCRrcgPhG3TX72d8lCIgra+tFSUlH9D3aAGKonmrfdqSFAa+KqOUR4ZG0zhGWLOhaj6uxHR5asOqzFXo3pZvytgSH6CPAufJxxLjr2UWUH/v+s/UahA5X3E2++Crvgc1VSpAYGfJpwGnRI7Un7IBBEiQ3G0opBNmLn75/Jr/6xANoY7ihOb6h7LDoPV1vzeEqpMIhaBR6Ic9Ue/epyhX/6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AMXXOpolNiiWCh9We3FfQb9HMKTtTJGTOUaHHgv+lf8=;
 b=DfdL/UEZ9Jsuny8z8LKUFdNumHD6CuS7Vyqj7r2dRi5K970taZz/lP1TU5OBzrFMoXXIbdA4YOfEui9ZZhXC8rkvc2pN7VQSW7ql5fH9AD70BcncKbxh10Zs9gz+8V4xitHEACSazYTeFvTaE5hP1WDx/FlR+151yz88OuCVmTU=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR0301MB2314.eurprd03.prod.outlook.com (2603:10a6:3:25::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4544.18; Thu, 30 Sep 2021 10:45:12 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d550:ffc2:ab2e:8167]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d550:ffc2:ab2e:8167%6]) with mapi id 15.20.4544.021; Thu, 30 Sep 2021
 10:45:12 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH net-next 1/4 v4] net: dsa: rtl8366rb: Support disabling
 learning
Thread-Topic: [PATCH net-next 1/4 v4] net: dsa: rtl8366rb: Support disabling
 learning
Thread-Index: AQHXtXXws06pLZ3f6EGMY4OLSctn3qu8ZZCA
Date:   Thu, 30 Sep 2021 10:45:12 +0000
Message-ID: <9c620f87-884f-dd85-3d29-df8861131516@bang-olufsen.dk>
References: <20210929210349.130099-1-linus.walleij@linaro.org>
 <20210929210349.130099-2-linus.walleij@linaro.org>
In-Reply-To: <20210929210349.130099-2-linus.walleij@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a9923822-b6b3-4139-8260-08d983ff616e
x-ms-traffictypediagnostic: HE1PR0301MB2314:
x-microsoft-antispam-prvs: <HE1PR0301MB2314A6C0EDA1A793883630A383AA9@HE1PR0301MB2314.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bAYfnbNnG9b++nmRQQvmZtNi5JGcN0sC3AGnrHw/opM5h0WzAMWCsYGDAA6TgYWWq12RkQxZai1vOMucBwSxH0b6FU6sQ/jXcLYu7Xcx2C/4XaZI3u5DdgTTJ0E0UI52seOEPTdIgcmFG21cPZP7r4aPv+mj9pUZ+SJEwALAHF+VR80lKInVZLUS/GgGT4yjjmHxSHUgarIGHglUxk1p0+R/UfYTe7ST9Hhd+dIjZ0jWLr9NneGhmquMp2bs8ORrPLM+AlsOQt+V60YsmDypK+KFRa3pJlSLNIjRMqJkjO8WTT8mAPQVH0yL9pPuYYd3N9L8gwdf0mePZeKoWLQVALU0gUgvP9qBM4tvzIIDErXnSV4qngjKY4+Nm4OUCI+HoZPFO9NN6c89XqkNVvkwRJONtcHJtDnY+h4kAm1sOrs64q1M+N1yM+Y5I/RZvvOxiE6jl+eXmUPj3ev8TV2jiaVbckAUdJcjWY+aO3Qd189KzDFSrz+fpWZGvgeJIdt6lIWRgHcn70FQTgeKRwnaKSEYjyTXiKNKlLjtL4ommxdueY9d0VJfSiNirkQ9tl0eFb846cS/uvOlW1KlJVE+86WUGy8XKCMkR7G+bjdBU2Oav5vg3anTzJULospkfGtxTIShiUWAY8n6c+zYja82hDISd+OZda6hvd6CS/VxyhW2EN1tzOoEVUma3HmcjPt43PzDvoDEEVUPHzM+9gUlaF/M64ITih8Im09q5o/zMom/gO+LvjAfU6VYnwfd7I7BTk+6trMyrnRgdVQcewfxRBiqfMgDxQhSvUUlZ56B3h87Fkkn7iSIMy8mVHiPSswshKf97StEhSyD+zCDIIyUXgMfieF8S/Zx3QaVuUGGVQI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(316002)(54906003)(110136005)(7416002)(6512007)(8676002)(966005)(122000001)(86362001)(36756003)(38070700005)(186003)(2906002)(66946007)(85182001)(38100700002)(5660300002)(31696002)(53546011)(6506007)(66476007)(31686004)(66556008)(66446008)(64756008)(85202003)(76116006)(91956017)(8976002)(2616005)(83380400001)(71200400001)(508600001)(66574015)(6486002)(8936002)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Wmw2cnJiSzdwU0R0MXNMbU1jb0FZS0tNUlhxY0E3K0lZV0pRdjhCeHhMbWlT?=
 =?utf-8?B?K3hMWW1lekc3b01lZ1FjVm9TNnZ4VmlhZG1aQzdmSU1OSHVzM2FrWFhBYXVj?=
 =?utf-8?B?d0loWEhhOGpSQm1mYjZHS1pzYTJ1a3cwcklWY0pJbmlLSUpyeGxmY1RjRDZv?=
 =?utf-8?B?NTJ0VFFKYkhqYzVpZWl3SFJpR0lkY21UVE1GV2FsV21wdzZwczZ0N3NDTTlN?=
 =?utf-8?B?Tldkd0ttOXFIV3dzRVNQZlBaRHI3ajVoUjNJdVAvczNRNnJLR29jSzY1aVkv?=
 =?utf-8?B?VGRwRndObjM5dnRFbHF5VzVsc0lJK3doR2VKTDR5N2YwT0xGTFdpREt6R0Jx?=
 =?utf-8?B?eC9Va3hxa1NYWUNyLzlkQmVCaW0veUFjVXUvL1NqazVrSythOHZrcEFOWHFa?=
 =?utf-8?B?UTYyT1g1c1cvOHNjY0RRaCtYNW9EL1BxcEJFcW1uS2xDbmRja3NNaTJCU2hy?=
 =?utf-8?B?OGo1NUxMbG9oZGp0aWQ5MWdVeWVGOEFyT1ZlcndPTlRZSU11dENmOTVoYUVp?=
 =?utf-8?B?VGthNE0vSXJiNHZVRU9pbnIrVFBtRkxxZkRjQ1dreDZqRURGZ1l0UnBMRWJH?=
 =?utf-8?B?Q2R4V04veXZJaTI1Nk5IK2dWRHZiOUhQc2pkSFNuR28xUU1jUEJvWmNIanNG?=
 =?utf-8?B?RlBCNzhWdlo3OXkwMnhiNkg2VWlqQmJMa2t4OFE5OUdMVU5XQys2aEFmbWZD?=
 =?utf-8?B?YzdzVXlSdmxkQ0NpSmNqTFdLMERPSGRRRUVCYkNGd3hjSkxFbURhbDV3ZmlR?=
 =?utf-8?B?MnZhQVgwTUF6b0JUVXNRc2JKSkgzcGkvY0RzSDZScjlkeVJLL2YrdVpXbjha?=
 =?utf-8?B?cm5uWDBoTlFSK2txOWxtRUNYaFdhYjFJbit6Nk5Wc2NzTDBFZ2FaVVZxTmRE?=
 =?utf-8?B?RkVRc2h6SS84ZkhYSGVEc3V5MnVtVkRxdzd1cE44V1lTQjRMMytsNlZMRmxm?=
 =?utf-8?B?NkU1VXZ4UlhscUhxY2loMG0vNnd5aC93RzdaSjAwQytHMnIrejROdnMzaldJ?=
 =?utf-8?B?Tm90WW1FUDcveGRTQTRtdkNiVzZHWmJPMDcrUkdweVZIK0FWL1BaMk42KzBU?=
 =?utf-8?B?VkZGVGhLc1BjekNMWmFPbzZIYTdmbUIvaXpoR2lJRUJqcXd0cUZEN1pDOGQv?=
 =?utf-8?B?WGV3aDZubTVwbDFzdHlrQ2tIOE1JSGlMVGU2b1RQSEhsNWhtQWhqUklkWCtQ?=
 =?utf-8?B?bndzTHl1WStra1hFOFJ6TTJzTHZpUjNFUWhZY2FMenVwMHJ2WjdpYlVLSlZk?=
 =?utf-8?B?bUUzRWdWemlDM0V4L3ZSaVdCZUgwSWlXWkxVcW1OeUtscFRmNDB5NE1pK3p2?=
 =?utf-8?B?bW1PeENKQ0JGSFdYczBKYzhub0lCVW9DTkhqOGVKa2xlR3JKU3dwb1dPS2Qx?=
 =?utf-8?B?d0w4endXYTFlaFBrMENlNzhHRkF3T2lZcVVNM2J2SXJBZXh1TnVVaEFOcjN4?=
 =?utf-8?B?UmFweDhsNk03THBzN1FsckRUbHE3K3EyaE9wWHdjc2dFU0pNb1ZCTFp0VWsv?=
 =?utf-8?B?Z0ZYN1pXakZSb2FxMzl3amR0K1BuR0RnVm16MVh1ck15R1d1blNZQmlXTjYy?=
 =?utf-8?B?WWVSMW1TZTI2T0hhcC9NN2JyK0J4ZDRxVXVtc05VWGhvaUlLNGtuNS93MWgy?=
 =?utf-8?B?ckUzR3VKVFAyTUNQSnZoNGpobTBQUG05WWdFcElETllUMmJVZHJBS2dJZVNM?=
 =?utf-8?B?aUZ1QTBmMm5oWC9MbzcrbVhPV3JNS3R5RmJvRk1DUHRGZCtiZDFYZ21IcTZF?=
 =?utf-8?Q?dH7LvwAjTOxF5rgsg9FYB0sKPEK647I91Qudx/k?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <536A3ED7ACC9B243A891033A0DDB5278@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9923822-b6b3-4139-8260-08d983ff616e
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2021 10:45:12.2330
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NDdFNuybanwJqyfbt/+nDW8IkPsWjbVE0hGY+eFCy+x5Oe299lMz3w9NR9u/h2O7Kxv+jOxL959UwEAZaAhH8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0301MB2314
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTGludXMsDQoNCk9uIDkvMjkvMjEgMTE6MDMgUE0sIExpbnVzIFdhbGxlaWogd3JvdGU6DQo+
IFRoZSBSVEw4MzY2UkIgaGFyZHdhcmUgc3VwcG9ydHMgZGlzYWJsaW5nIGxlYXJuaW5nIHBlci1w
b3J0DQo+IHNvIGxldCdzIG1ha2UgdXNlIG9mIHRoaXMgZmVhdHVyZS4gUmVuYW1lIHNvbWUgdW5m
b3J0dW5hdGVseQ0KPiBuYW1lZCByZWdpc3RlcnMgaW4gdGhlIHByb2Nlc3MuDQoNClNpbmNlIHlv
dSBoYXZlIGltcGxlbWVudGVkIGJyaWRnZSBvZmZsb2FkaW5nIGFuZCB5b3UgYXJlIG5vdyBkaXNh
YmxpbmcgDQpsZWFybmluZyBvbiB0aGUgQ1BVIHBvcnQgYnkgZGVmYXVsdCwgd2lsbCB0aGlzIG1l
YW4gdGhhdCBhbGwgaW5ncmVzcyANCmZyYW1lcyBvbiBhIHVzZXIgcG9ydCB3aXRoIERBIGJlaGlu
ZCB0aGUgQ1BVIHBvcnQgd2lsbCBiZSBmbG9vZGVkIGJ5IHRoZSANCnN3aXRjaCB0byBhbGwgcG9y
dHMgaW4gdGhlIGJyaWRnZSwgYXMgd2VsbCBhcyB0aGUgQ1BVIHBvcnQ/IEl0IHNlZW1zIA0KdGhh
dCB3aWxsIGJlIHRoZSBjYXNlIGlmIG5vdyB0aGUgc3dpdGNoIGNhbid0IGxlYXJuIHRoZSBTQSBv
ZiBmcmFtZXMgDQpjb21pbmcgZnJvbSB0aGUgQ1BVLg0KDQpGb2xsb3dpbmcgeW91ciBkaXNjdXNz
aW9uIHdpdGggVmxhZGltaXIgWzFdLCBkaWQgeW91IGNvbWUgdG8gYSANCmNvbmNsdXNpb24gb24g
aG93IHlvdSB3aWxsIGhhbmRsZSB0aGlzPw0KDQoJQWx2aW4NCg0KWzFdIGh0dHBzOi8vbG9yZS5r
ZXJuZWwub3JnL25ldGRldi8yMDIxMDkwODIxMDkzOS5jd3dud2dqM3A2N3F2c3JoQHNrYnVmLw0K
DQo+IA0KPiBTdWdnZXN0ZWQtYnk6IFZsYWRpbWlyIE9sdGVhbiA8b2x0ZWFudkBnbWFpbC5jb20+
DQo+IENjOiBBbHZpbiDFoGlwcmFnYSA8YWxzaUBiYW5nLW9sdWZzZW4uZGs+DQo+IENjOiBNYXVy
aSBTYW5kYmVyZyA8c2FuZGJlcmdAbWFpbGZlbmNlLmNvbT4NCj4gQ2M6IEZsb3JpYW4gRmFpbmVs
bGkgPGYuZmFpbmVsbGlAZ21haWwuY29tPg0KPiBDYzogREVORyBRaW5nZmFuZyA8ZHFmZXh0QGdt
YWlsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogTGludXMgV2FsbGVpaiA8bGludXMud2FsbGVpakBs
aW5hcm8ub3JnPg0KPiAtLS0NCj4gQ2hhbmdlTG9nIHYzLT52NDoNCj4gLSBObyBjaGFuZ2VzLCBy
ZWJhc2VkIG9uIG90aGVyIHBhdGNoZXMuDQo+IENoYW5nZUxvZyB2Mi0+djM6DQo+IC0gRGlzYWJs
ZSBsZWFybmluZyBieSBkZWZhdWx0LCBsZWFybmluZyB3aWxsIGJlIHR1cm5lZA0KPiAgICBvbiBz
ZWxlY3RpdmVseSB1c2luZyB0aGUgY2FsbGJhY2suDQo+IENoYW5nZUxvZyB2MS0+djI6DQo+IC0g
TmV3IHBhdGNoIHN1Z2dlc3RlZCBieSBWbGFkaW1pci4NCj4gLS0tDQo+ICAgZHJpdmVycy9uZXQv
ZHNhL3J0bDgzNjZyYi5jIHwgNTAgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0t
LQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCA0NCBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQ0K
PiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9ydGw4MzY2cmIuYyBiL2RyaXZlcnMv
bmV0L2RzYS9ydGw4MzY2cmIuYw0KPiBpbmRleCBiYjlkMDE3YzJmOWYuLmIzMDU2MDY0YjkzNyAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZHNhL3J0bDgzNjZyYi5jDQo+ICsrKyBiL2RyaXZl
cnMvbmV0L2RzYS9ydGw4MzY2cmIuYw0KPiBAQCAtMTQsNiArMTQsNyBAQA0KPiAgIA0KPiAgICNp
bmNsdWRlIDxsaW51eC9iaXRvcHMuaD4NCj4gICAjaW5jbHVkZSA8bGludXgvZXRoZXJkZXZpY2Uu
aD4NCj4gKyNpbmNsdWRlIDxsaW51eC9pZl9icmlkZ2UuaD4NCj4gICAjaW5jbHVkZSA8bGludXgv
aW50ZXJydXB0Lmg+DQo+ICAgI2luY2x1ZGUgPGxpbnV4L2lycWRvbWFpbi5oPg0KPiAgICNpbmNs
dWRlIDxsaW51eC9pcnFjaGlwL2NoYWluZWRfaXJxLmg+DQo+IEBAIC00Miw5ICs0MywxMiBAQA0K
PiAgIC8qIFBvcnQgRW5hYmxlIENvbnRyb2wgcmVnaXN0ZXIgKi8NCj4gICAjZGVmaW5lIFJUTDgz
NjZSQl9QRUNSCQkJCTB4MDAwMQ0KPiAgIA0KPiAtLyogU3dpdGNoIFNlY3VyaXR5IENvbnRyb2wg
cmVnaXN0ZXJzICovDQo+IC0jZGVmaW5lIFJUTDgzNjZSQl9TU0NSMAkJCQkweDAwMDINCj4gLSNk
ZWZpbmUgUlRMODM2NlJCX1NTQ1IxCQkJCTB4MDAwMw0KPiArLyogU3dpdGNoIHBlci1wb3J0IGxl
YXJuaW5nIGRpc2FibGVtZW50IHJlZ2lzdGVyICovDQo+ICsjZGVmaW5lIFJUTDgzNjZSQl9QT1JU
X0xFQVJORElTX0NUUkwJCTB4MDAwMg0KPiArDQo+ICsvKiBTZWN1cml0eSBjb250cm9sLCBhY3R1
YWxseSBhZ2luZyByZWdpc3RlciAqLw0KPiArI2RlZmluZSBSVEw4MzY2UkJfU0VDVVJJVFlfQ1RS
TAkJCTB4MDAwMw0KPiArDQo+ICAgI2RlZmluZSBSVEw4MzY2UkJfU1NDUjIJCQkJMHgwMDA0DQo+
ICAgI2RlZmluZSBSVEw4MzY2UkJfU1NDUjJfRFJPUF9VTktOT1dOX0RBCQlCSVQoMCkNCj4gICAN
Cj4gQEAgLTkyNywxMyArOTMxLDE0IEBAIHN0YXRpYyBpbnQgcnRsODM2NnJiX3NldHVwKHN0cnVj
dCBkc2Ffc3dpdGNoICpkcykNCj4gICAJCS8qIGxheWVyIDIgc2l6ZSwgc2VlIHJ0bDgzNjZyYl9j
aGFuZ2VfbXR1KCkgKi8NCj4gICAJCXJiLT5tYXhfbXR1W2ldID0gMTUzMjsNCj4gICANCj4gLQkv
KiBFbmFibGUgbGVhcm5pbmcgZm9yIGFsbCBwb3J0cyAqLw0KPiAtCXJldCA9IHJlZ21hcF93cml0
ZShzbWktPm1hcCwgUlRMODM2NlJCX1NTQ1IwLCAwKTsNCj4gKwkvKiBEaXNhYmxlIGxlYXJuaW5n
IGZvciBhbGwgcG9ydHMgKi8NCj4gKwlyZXQgPSByZWdtYXBfd3JpdGUoc21pLT5tYXAsIFJUTDgz
NjZSQl9QT1JUX0xFQVJORElTX0NUUkwsDQo+ICsJCQkgICBSVEw4MzY2UkJfUE9SVF9BTEwpOw0K
PiAgIAlpZiAocmV0KQ0KPiAgIAkJcmV0dXJuIHJldDsNCj4gICANCj4gICAJLyogRW5hYmxlIGF1
dG8gYWdlaW5nIGZvciBhbGwgcG9ydHMgKi8NCj4gLQlyZXQgPSByZWdtYXBfd3JpdGUoc21pLT5t
YXAsIFJUTDgzNjZSQl9TU0NSMSwgMCk7DQo+ICsJcmV0ID0gcmVnbWFwX3dyaXRlKHNtaS0+bWFw
LCBSVEw4MzY2UkJfU0VDVVJJVFlfQ1RSTCwgMCk7DQo+ICAgCWlmIChyZXQpDQo+ICAgCQlyZXR1
cm4gcmV0Ow0KPiAgIA0KPiBAQCAtMTI3Miw2ICsxMjc3LDM3IEBAIHN0YXRpYyBpbnQgcnRsODM2
NnJiX3ZsYW5fZmlsdGVyaW5nKHN0cnVjdCBkc2Ffc3dpdGNoICpkcywgaW50IHBvcnQsDQo+ICAg
CXJldHVybiByZXQ7DQo+ICAgfQ0KPiAgIA0KPiArc3RhdGljIGludA0KPiArcnRsODM2NnJiX3Bv
cnRfcHJlX2JyaWRnZV9mbGFncyhzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMsIGludCBwb3J0LA0KPiAr
CQkJCXN0cnVjdCBzd2l0Y2hkZXZfYnJwb3J0X2ZsYWdzIGZsYWdzLA0KPiArCQkJCXN0cnVjdCBu
ZXRsaW5rX2V4dF9hY2sgKmV4dGFjaykNCj4gK3sNCj4gKwkvKiBXZSBzdXBwb3J0IGVuYWJsaW5n
L2Rpc2FibGluZyBsZWFybmluZyAqLw0KPiArCWlmIChmbGFncy5tYXNrICYgfihCUl9MRUFSTklO
RykpDQo+ICsJCXJldHVybiAtRUlOVkFMOw0KPiArDQo+ICsJcmV0dXJuIDA7DQo+ICt9DQo+ICsN
Cj4gK3N0YXRpYyBpbnQNCj4gK3J0bDgzNjZyYl9wb3J0X2JyaWRnZV9mbGFncyhzdHJ1Y3QgZHNh
X3N3aXRjaCAqZHMsIGludCBwb3J0LA0KPiArCQkJICAgIHN0cnVjdCBzd2l0Y2hkZXZfYnJwb3J0
X2ZsYWdzIGZsYWdzLA0KPiArCQkJICAgIHN0cnVjdCBuZXRsaW5rX2V4dF9hY2sgKmV4dGFjaykN
Cj4gK3sNCj4gKwlzdHJ1Y3QgcmVhbHRla19zbWkgKnNtaSA9IGRzLT5wcml2Ow0KPiArCWludCBy
ZXQ7DQo+ICsNCj4gKwlpZiAoZmxhZ3MubWFzayAmIEJSX0xFQVJOSU5HKSB7DQo+ICsJCXJldCA9
IHJlZ21hcF91cGRhdGVfYml0cyhzbWktPm1hcCwgUlRMODM2NlJCX1BPUlRfTEVBUk5ESVNfQ1RS
TCwNCj4gKwkJCQkJIEJJVChwb3J0KSwNCj4gKwkJCQkJIChmbGFncy52YWwgJiBCUl9MRUFSTklO
RykgPyAwIDogQklUKHBvcnQpKTsNCj4gKwkJaWYgKHJldCkNCj4gKwkJCXJldHVybiByZXQ7DQo+
ICsJfQ0KPiArDQo+ICsJcmV0dXJuIDA7DQo+ICt9DQo+ICsNCj4gICBzdGF0aWMgaW50IHJ0bDgz
NjZyYl9jaGFuZ2VfbXR1KHN0cnVjdCBkc2Ffc3dpdGNoICpkcywgaW50IHBvcnQsIGludCBuZXdf
bXR1KQ0KPiAgIHsNCj4gICAJc3RydWN0IHJlYWx0ZWtfc21pICpzbWkgPSBkcy0+cHJpdjsNCj4g
QEAgLTE2ODIsNiArMTcxOCw4IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZHNhX3N3aXRjaF9vcHMg
cnRsODM2NnJiX3N3aXRjaF9vcHMgPSB7DQo+ICAgCS5wb3J0X3ZsYW5fZGVsID0gcnRsODM2Nl92
bGFuX2RlbCwNCj4gICAJLnBvcnRfZW5hYmxlID0gcnRsODM2NnJiX3BvcnRfZW5hYmxlLA0KPiAg
IAkucG9ydF9kaXNhYmxlID0gcnRsODM2NnJiX3BvcnRfZGlzYWJsZSwNCj4gKwkucG9ydF9wcmVf
YnJpZGdlX2ZsYWdzID0gcnRsODM2NnJiX3BvcnRfcHJlX2JyaWRnZV9mbGFncywNCj4gKwkucG9y
dF9icmlkZ2VfZmxhZ3MgPSBydGw4MzY2cmJfcG9ydF9icmlkZ2VfZmxhZ3MsDQo+ICAgCS5wb3J0
X2NoYW5nZV9tdHUgPSBydGw4MzY2cmJfY2hhbmdlX210dSwNCj4gICAJLnBvcnRfbWF4X210dSA9
IHJ0bDgzNjZyYl9tYXhfbXR1LA0KPiAgIH07DQo+IA0KDQo=
