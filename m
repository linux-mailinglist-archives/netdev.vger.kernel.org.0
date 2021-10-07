Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9A34258F1
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 19:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243142AbhJGRKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 13:10:34 -0400
Received: from mail-am6eur05on2104.outbound.protection.outlook.com ([40.107.22.104]:38336
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242959AbhJGRKd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 13:10:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bX1tBE9W6RRqPiFdzfjxgeDSr9LyMsdynz05o+nvzpE2igpEie0oWhU1KfJjkOB0swsOM27fbzOZe1P7OGdvfiI8QxKIHHStrScP6C8zyDvHNXXvshyXVM8hmK9jqm25tcCisD6GHAY99rzU70lcyqvE8NVZiRspvz4sUcKdk5TDuM07xgVxdLWX/tKNWyo0BShllNTh6lrsZpZaecHzc77Pok2VL3DfzaYgQys5w+aeo6/6E3S/LsWVsK9PST7Z+re/w3D7FxhhIL90eOZg2L8Q5sSExUx56JxBocx769cIxTQ0itawYZlZhfH0iXf3j1vlD5aWEYBEjoqFcMKsJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DZwLQckagtNQevfRZwzN/CDD5M0XRVZhFLFe3qJ6qIU=;
 b=b9Bh/WClvtqI9UaswB6Ejz6BC594wqruIVlQgUg1imUnDm96MvDufRtC+kViZ6zSsnm66frPlXuHcIvXsfzfLtZb51Kqc22szcb7LIrcrhYXMYzyk4UJCZk1f6fscRC8nf19RFsim8Z/pkY4WgjFmtg52is1u3HZqlX1iUnCf2Cq1wDC/Qt37t4cO7aUi44nlMUmaR8ESvatJk+nrRi6gSTUpS6tzvU6gCu/sWNa725BpZ2Z55oEg9H8S4+aKG4FEwwGQAflixgSLKM3x3FlA0iwN5ZymIs8fEL3iQqjlT399vVcI9VP6MzZDnP+iaFn3Jb26yRK1tFVImas7PmPqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZwLQckagtNQevfRZwzN/CDD5M0XRVZhFLFe3qJ6qIU=;
 b=BZs1rlJociQ7saLuAMqtgi3K0SKCavbKQpctwoTI2OcOJfwl+33ss0pDkYQ4BTsVg15T5FVSkV5As8eAQB9YVGvGa9eP3hC3Zyif3cEk6OZ2a5k9KxJn/k/57lO6UTnky4MuGaZ5tQNV2RvGHzwrWrDlVmyQsA04EREVjmCF08w=
Received: from VE1PR05MB7278.eurprd05.prod.outlook.com (2603:10a6:800:1a5::23)
 by VI1PR05MB5808.eurprd05.prod.outlook.com (2603:10a6:803:cd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Thu, 7 Oct
 2021 17:08:37 +0000
Received: from VE1PR05MB7278.eurprd05.prod.outlook.com
 ([fe80::2853:2c91:4f51:5bdf]) by VE1PR05MB7278.eurprd05.prod.outlook.com
 ([fe80::2853:2c91:4f51:5bdf%4]) with mapi id 15.20.4566.022; Thu, 7 Oct 2021
 17:08:37 +0000
From:   Philippe Schenker <philippe.schenker@toradex.com>
To:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net: phy: micrel: ksz9131 led errata
 workaround
Thread-Topic: [PATCH net-next v2] net: phy: micrel: ksz9131 led errata
 workaround
Thread-Index: AQHXu5rHkxPwiU4Nr0itDfYefxF0MavHxLgA
Date:   Thu, 7 Oct 2021 17:08:37 +0000
Message-ID: <71c35967a1a40557cc034ff7d716fec367d5b4a1.camel@toradex.com>
References: <20211007164535.657245-1-francesco.dolcini@toradex.com>
In-Reply-To: <20211007164535.657245-1-francesco.dolcini@toradex.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=toradex.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bf33daa2-1fd7-45d3-91bd-08d989b51a52
x-ms-traffictypediagnostic: VI1PR05MB5808:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5808CC302C78EF212F59803CF4B19@VI1PR05MB5808.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r7PUQ2kJJJcFU978rjHEGB4H9Jnd3KQPbCzVFYJ3LjttcqXGiN45SF2xs6nmTYxIN05B3tmNn6AW/8zlrCZihOZ46udR69LYdpAj72oJ/wsoCBnvqXH4f1UawIU9P9Z+oxYVzWTzTpjgyOfFSKzIYrgFHsczdUixmWKMdwkOyGsdqfTdVEMMgn+iPkXbZawrweZDDNXTMQYlu4SaSuSPq4sKHnhKZk9rKfQKOOPBxnSQvvWJB7nCI0O1mNKJ+w1zVmjDHTTaixbLmfL+2QATYp4mcSI08KC3x46rWS/nQiREuZ/5ve4Mud0XL6WiSlggrSDw/jDwjX/M0LH1DclSm0zBqGePOKq6fqfM3YFiZ49AVQ7yZDVe53cYlUAaRBDsK6boC6fRf4BV+EdeO5w+Vuto2hJ/6Zkqxhdqj2u5opVS+f+nAcTpSeFQZXtCCuHUsdINzMKclGD5234uf2i+hvSnygzJwHyDuAm/ZnLcye/wCwtoGkzotdC45xzkzc3LeyXzXClwOKrpdttAuLHAN7BXKMm9RxWsKGeuTEFbG6jDp5PWWR1PQ/UOJNHzTqmCAcSbP+KalTfKF6qHR0VoLjKLZKSBGUJAlwOdiThHIFeWAfSK4S73GSu5zZFv0rv4AK1rI4EjNTw6S4vTJpYkPEQi1vtakjEZJ9wMwq077P5N96QJmwfGBpOSq44bO96qJZLRpukVVxEwvSS/e/PtvwDABxxTjB8SEDWuHPUQWrry0/FylA7DaAZfGIOboBPkSIh4zcV/BzSSo57JkGfEjfZ1XK3du2OYE0Fp+ZLtuew=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR05MB7278.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(376002)(396003)(39850400004)(122000001)(66476007)(38100700002)(38070700005)(64756008)(8676002)(66946007)(5660300002)(91956017)(2616005)(76116006)(66556008)(26005)(6506007)(86362001)(66446008)(966005)(508600001)(44832011)(8936002)(54906003)(186003)(316002)(4326008)(6512007)(83380400001)(6486002)(71200400001)(36756003)(2906002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c3JHVWNNbTluVUJsOWczNTRTRDZmRTZTekdjWWRuek04US9Iams0R0s1WUtq?=
 =?utf-8?B?LzdEcnBKZjdkZzQwRGJmSmxiUlQ2MXN6V3hoRHRYVDVuM0JVR1Ryd1hpdEhm?=
 =?utf-8?B?V0ZGQk5DSGo3aVF5ajhKVVRGcXFlb1JVZ0FLTWNsTmhrSnE5SE5MZ0dBRjQ2?=
 =?utf-8?B?NEdJZDZweTlwRk1rVDB5RVpkMlRlNzE4ckFuMml0cnF1d2Y3UjdrQ0ZncTg2?=
 =?utf-8?B?NmM4NWh0dVJMWm4zYjdQYWtEa2JHRE4vQ0ZoSjQ1L01EeEFyWnRscjBUQzNE?=
 =?utf-8?B?WnR6TTdsNnhUUjBGenpkRFFHQ2Q1WC95Z2trcDRldnFuMkNkUEhJQjlQNnov?=
 =?utf-8?B?MVQxZlNxYzlIc3UwTnRKelJOdEt5Sm0xMTVBbjN4Mmxub2xVRkFrcTdqSjhW?=
 =?utf-8?B?Y25BNW52cXBKUEc0dVdlUHhyU3ZoQ0NIRm9TaGpGZ0IrNmFFSU02SlJYY0pZ?=
 =?utf-8?B?RWErelNHWEo3eUlXNWtIWWk5eWJYaUs2TENPU3ptR2hUMkhWTUpqQ1lLbU9m?=
 =?utf-8?B?TDY3Z0drTkppVGt1VnFpZDdneTZaSTgxajM1eE9ia1JYaXhnVGd3cjcvRXVJ?=
 =?utf-8?B?QU1Xd3FTM1R5VUhPaEJRc2g2ZGlCOEJqSVhMTVFlSEVkeTdrYnJZR2hQVW11?=
 =?utf-8?B?OG9LMXI2S09DY0NVd002ZkFUTjdFTHpDQ2I1cEtqNUR5L3hXcUxETGtJVmFR?=
 =?utf-8?B?ZWtsZzZtZEppemdNZzhGMzkxQVFpUzlkYWpGMGhhUkF5NjIxdXJXZDRxM2dl?=
 =?utf-8?B?UzNGRzhIOThOazVHZnc1ZXpRTlQ1eUNKU05CQkN5eTZBamZnL1JhTVFMc2Ir?=
 =?utf-8?B?SDhPT1IvbVBORHhKbDdmRFdwS3dNQ28ramR4Zno3U0hLTzhZM3pTOFF3ajZJ?=
 =?utf-8?B?cGZpeFBZdVF5NU0wY29iS25IdktvbHM2c0twMUdqV0ZjRDB2b1dueC9IUnhW?=
 =?utf-8?B?NnZGL1RnNGE4M2NnRUgvU2dsb1hrMDJCV2Z5ZklzVTk0aFJJeHJIWStWdFJD?=
 =?utf-8?B?ZERNR00vL0d2YnRUUVFVeEdvSG81NGkwS1VpUmlUcUJDR2Q5UXNCbE90bjZE?=
 =?utf-8?B?QXlJN1V0TmZyNUc5bFRqRU5DY3RXZFE4NjZWRXFaaEZLMUZ2bG5zTG45NW5R?=
 =?utf-8?B?UVlXVE1yYitjUld4NFFmY0VDVzJCbTRENnlySjI0VlkzOERLSmdRZUU4Mnpm?=
 =?utf-8?B?QWd6Tldrai9JQVYrR1AvRVBZWkxXSWd4TVJiZzNaQ210SlBUaVFMTjNOZ21h?=
 =?utf-8?B?MGZuMWZGMUROc3N6RDN0bHZNWTlmV0JPVjVSd0xQVWVWMGxEOVJuMFEzN3pn?=
 =?utf-8?B?dVlCTE0xb3NFZEtrR2dEVndqNlNoZlNGZG4rbFl4Njh4aDFkZDRhbDBhZHh5?=
 =?utf-8?B?NHVZUjVLdUp3eVJtUEVteFg1djI5SGJ5d3RaK2J4VkRIQVhYb3NOMGl2Ynhs?=
 =?utf-8?B?TU9qRjBGbnQ3NGdHb3U2THlzMnE4SmgvN1BCMXErZ2VUZmFyMXBTYVVpamlW?=
 =?utf-8?B?ZUpES0gzNXptZUhwTm9Mbm9FM3FIZG9QL1dvMVZNMXRhd0pGWGIxMXZxdWp1?=
 =?utf-8?B?TVEwRHJ2YXJnc1RBd3lZRU9ZK2tuUStISTVuK2VVYkZaaEJhT1F2Q24wUWZQ?=
 =?utf-8?B?TE5ra1VYUU9ZZDIvczc0OUY1ZjI5b2hDbmtzbzQrcmFKcjhIWlFraHhnTnVN?=
 =?utf-8?B?RGJzZnZkUHlkSFBGeHlLenpodDJRQVQxY1Nod0t2NW53S08zYTc2S0JKK1Jh?=
 =?utf-8?Q?BtjJU9A8uHkuw71cvnEs8Ltq3ii7uDODykLYF8V?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0C20E9C6511441448A1AA9E20099E91A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VE1PR05MB7278.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf33daa2-1fd7-45d3-91bd-08d989b51a52
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2021 17:08:37.2912
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bU7EopliVaQOFvWGgD2gBx1HxxGpff9cjYzwUBK7OUMoQsIGlTg/7AUX4asA8DH9I++5SI9w1geB/cjLTFqu1s7x5J4uxAbdg8pOHK81dg4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5808
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIxLTEwLTA3IGF0IDE4OjQ1ICswMjAwLCBGcmFuY2VzY28gRG9sY2luaSB3cm90
ZToNCj4gTWljcmVsIEtTWjkxMzEgUEhZIExFRCBiZWhhdmlvciBpcyBub3QgY29ycmVjdCB3aGVu
IGNvbmZpZ3VyZWQgaW4NCj4gSW5kaXZpZHVhbCBNb2RlLCBMRUQxIChBY3Rpdml0eSBMRUQpIGlz
IGluIHRoZSBPTiBzdGF0ZSB3aGVuIHRoZXJlIGlzDQo+IG5vLWxpbmsuDQo+IA0KPiBXb3JrYXJv
dW5kIHRoaXMgYnkgc2V0dGluZyBiaXQgOSBvZiByZWdpc3RlciAweDFlIGFmdGVyIHZlcmlmeWlu
ZyB0aGF0DQo+IHRoZSBMRUQgY29uZmlndXJhdGlvbiBpcyBJbmRpdmlkdWFsIE1vZGUuDQo+IA0K
PiBUaGlzIGlzc3VlIGlzIGRlc2NyaWJlZCBpbiBLU1o5MTMxUk5YIFNpbGljb24gRXJyYXRhIERT
ODAwMDA2OTNCIFsqXQ0KPiBhbmQgYWNjb3JkaW5nIHRvIHRoYXQgaXQgd2lsbCBub3QgYmUgY29y
cmVjdGVkIGluIGEgZnV0dXJlIHNpbGljb24NCj4gcmV2aXNpb24uDQo+IA0KPiBbKl0NCj4gaHR0
cHM6Ly93dzEubWljcm9jaGlwLmNvbS9kb3dubG9hZHMvZW4vRGV2aWNlRG9jL0tTWjkxMzFSTlgt
U2lsaWNvbi1FcnJhdGEtYW5kLURhdGEtU2hlZXQtQ2xhcmlmaWNhdGlvbi04MDAwMDg2M0IucGRm
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBGcmFuY2VzY28gRG9sY2luaSA8ZnJhbmNlc2NvLmRvbGNp
bmlAdG9yYWRleC5jb20+DQoNClRoaXMgcGF0Y2ggbG9va3MgZ29vZCB0byBtZSwgZnVuY3Rpb25h
bGl0eSB3aXNlIGl0IHdpbGwgd29yay4gSSB3b3VsZA0Kc3RpbGwgZG8gc29tZSBkZWZpbmVzIGZv
ciB0aGUgcmF3IHZhbHVlcyB5b3UgdXNlZCB0aGF0IGFyZSBkZXNjcmliZWQgaW4NCnRoZSBkYXRh
c2hlZXQgYW5kIG1heWJlIGNoYW5nZSB0aGUgc3RyYW5nZSBkZWZpbmVzIEkgaW50cm9kdWNlZCBz
b21lDQp3aGlsZSBhZ28sIGJ1dCBJIGRvbid0IHNlZSB0aGlzIGFzIGEgYmxvY2tlci4NCg0KUmV2
aWV3ZWQtYnk6IFBoaWxpcHBlIFNjaGVua2VyIDxwaGlsaXBwZS5zY2hlbmtlckB0b3JhZGV4LmNv
bT4NCg0KPiAtLS0NCj4gQ2hhbmdlcyB2MSA9PiB2MjoNCj4gwqAxLiBjb3JyZWN0ZWQgZXJyYXRh
IFVSTCBpbiBjb21taXQgbWVzc2FnZQ0KPiDCoDIuIGNoZWNrIHBoeV9yZWFkX21tZCByZXR1cm4g
dmFsdWUNCj4gLS0tDQo+IMKgZHJpdmVycy9uZXQvcGh5L21pY3JlbC5jIHwgMjQgKysrKysrKysr
KysrKysrKysrKysrKysrDQo+IMKgMSBmaWxlIGNoYW5nZWQsIDI0IGluc2VydGlvbnMoKykNCj4g
DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9waHkvbWljcmVsLmMgYi9kcml2ZXJzL25ldC9w
aHkvbWljcmVsLmMNCj4gaW5kZXggYzMzMGE1YTlmNjY1Li5iNzBmNjJlZmRiYzMgMTAwNjQ0DQo+
IC0tLSBhL2RyaXZlcnMvbmV0L3BoeS9taWNyZWwuYw0KPiArKysgYi9kcml2ZXJzL25ldC9waHkv
bWljcmVsLmMNCj4gQEAgLTEwMDMsNiArMTAwMywyNiBAQCBzdGF0aWMgaW50IGtzejkxMzFfY29u
ZmlnX3JnbWlpX2RlbGF5KHN0cnVjdA0KPiBwaHlfZGV2aWNlICpwaHlkZXYpDQo+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdHhjZGxs
X3ZhbCk7DQo+IMKgfQ0KPiDCoA0KPiArLyogU2lsaWNvbiBFcnJhdGEgRFM4MDAwMDY5M0INCj4g
KyAqDQo+ICsgKiBXaGVuIExFRHMgYXJlIGNvbmZpZ3VyZWQgaW4gSW5kaXZpZHVhbCBNb2RlLCBM
RUQxIGlzIE9OIGluIGEgbm8tDQo+IGxpbmsNCj4gKyAqIGNvbmRpdGlvbi4gV29ya2Fyb3VuZCBp
cyB0byBzZXQgcmVnaXN0ZXIgMHgxZSwgYml0IDksIHRoaXMgd2F5DQo+IExFRDEgYmVoYXZlcw0K
PiArICogYWNjb3JkaW5nIHRvIHRoZSBkYXRhc2hlZXQgKG9mZiBpZiB0aGVyZSBpcyBubyBsaW5r
KS4NCj4gKyAqLw0KPiArc3RhdGljIGludCBrc3o5MTMxX2xlZF9lcnJhdGEoc3RydWN0IHBoeV9k
ZXZpY2UgKnBoeWRldikNCj4gK3sNCj4gK8KgwqDCoMKgwqDCoMKgaW50IHJlZzsNCj4gKw0KPiAr
wqDCoMKgwqDCoMKgwqByZWcgPSBwaHlfcmVhZF9tbWQocGh5ZGV2LCAyLCAwKTsNCj4gK8KgwqDC
oMKgwqDCoMKgaWYgKHJlZyA8IDApDQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBy
ZXR1cm4gcmVnOw0KPiArDQo+ICvCoMKgwqDCoMKgwqDCoGlmICghKHJlZyAmIEJJVCg0KSkpDQo+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gMDsNCj4gKw0KPiArwqDCoMKg
wqDCoMKgwqByZXR1cm4gcGh5X3NldF9iaXRzKHBoeWRldiwgMHgxZSwgQklUKDkpKTsNCj4gK30N
Cj4gKw0KPiDCoHN0YXRpYyBpbnQga3N6OTEzMV9jb25maWdfaW5pdChzdHJ1Y3QgcGh5X2Rldmlj
ZSAqcGh5ZGV2KQ0KPiDCoHsNCj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCBkZXZpY2Vfbm9kZSAq
b2Zfbm9kZTsNCj4gQEAgLTEwNTgsNiArMTA3OCwxMCBAQCBzdGF0aWMgaW50IGtzejkxMzFfY29u
ZmlnX2luaXQoc3RydWN0DQo+IHBoeV9kZXZpY2UgKnBoeWRldikNCj4gwqDCoMKgwqDCoMKgwqDC
oGlmIChyZXQgPCAwKQ0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiBy
ZXQ7DQo+IMKgDQo+ICvCoMKgwqDCoMKgwqDCoHJldCA9IGtzejkxMzFfbGVkX2VycmF0YShwaHlk
ZXYpOw0KPiArwqDCoMKgwqDCoMKgwqBpZiAocmV0IDwgMCkNCj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoHJldHVybiByZXQ7DQo+ICsNCj4gwqDCoMKgwqDCoMKgwqDCoHJldHVybiAw
Ow0KPiDCoH0NCj4gwqANCg0K
