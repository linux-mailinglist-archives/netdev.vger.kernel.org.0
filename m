Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E6044BEED
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 11:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbhKJKqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 05:46:10 -0500
Received: from mail-am6eur05on2042.outbound.protection.outlook.com ([40.107.22.42]:13825
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229653AbhKJKqJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 05:46:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wgn3xIjGbKdvvlgZs0L5U1Yi0+sgMnM93wZsSDfCvfBBGCW+UznL9iASjxR2KK/5csqX72MEss76DwNIIkkRiHgwjPV6JCP8Z6lPjpDfX9w/w89DoS6wjQUwKD+kL+TMJR2FG9FIRhistv3RtZCDZ3tHUTXAODgcm9JA5xHI/vh7xd9szL67OC1pT3q3BkiypRJArc72sz4faPmrT+wjiuuPuhggNtS/KxEt8ljkE0zmvneJZHZsP4Q9m5zOhEaOKkV7aacxasLRKoUJBoLGt2GqDyYjE+UHw3vp5jMmDhtsRFkFBJreMT3dSzB+byJ9AUpDkwikl2aOpPNub9jdhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A7KN6Ko3gZTz/V6d2kyvcG8qXqRZuFZZsYLDqqk2k78=;
 b=HVQj5/+rnNJ2198+ltNmP41EGNLRCy8m9DddakIYTk3MpgjOEi1vXqB1bij6kTNNA9uFxFs5xtQgn83ZD7QbiC5Wz1K65JdI7/oqiR2mVdg1bgjb5PDVE5mTVsdJ4Ab5Z19w2o4J1d5bEbJTxB3AxvB6NB9Afg52CjDN4OA92Sj9aiNayYL0K7U2csUgJdQ5zAS6aIppe8GNnX9NqlHsTqC7gDV/hg+RoIByOG2DWMid9Zh10ZR01ShpYBo4KjjjNSv37cAiaFOwM0W9i00YAlqHjmSKOKbRfbo9faj179612QTxZlskanOd5rZGCTcvioKCBXR/MwWzXvM5JHhZ3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A7KN6Ko3gZTz/V6d2kyvcG8qXqRZuFZZsYLDqqk2k78=;
 b=nJF2276Xx70MBO85I7RSY5NjKwwSe5KIXLwMpiU5K/vUjnPzjrWOqEuX49xSYlL9qZAd23xxuFPl4Clinzc8QycMOw/tWGE/h7BHJg33FVMhCAyv2GL6iLf3rju37CsmzllXP65E4QPAVCypSHoiimnTXTJ8orGkfLxKtd7Xp0g=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DB6PR0402MB2901.eurprd04.prod.outlook.com (2603:10a6:4:99::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.15; Wed, 10 Nov
 2021 10:43:20 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::4490:a7e9:37cb:99f8]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::4490:a7e9:37cb:99f8%3]) with mapi id 15.20.4690.016; Wed, 10 Nov 2021
 10:43:20 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>, Po Liu <po.liu@nxp.com>,
        Leo Li <leoyang.li@nxp.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>
Subject: RE: [PATCH v6 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Topic: [PATCH v6 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Index: AQHXtc/Tz1JX9fjSAUSptjPa61SVr6vF/CgAgDbU4pA=
Date:   Wed, 10 Nov 2021 10:43:20 +0000
Message-ID: <DB8PR04MB5785610A137B7DA78B3F8B1CF0939@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20210930075948.36981-1-xiaoliang.yang_1@nxp.com>
 <20210930075948.36981-6-xiaoliang.yang_1@nxp.com>
 <20211006131301.tx42h4kcoacat2jm@skbuf>
In-Reply-To: <20211006131301.tx42h4kcoacat2jm@skbuf>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1e52bbd7-0f09-43b4-c4bc-08d9a436e997
x-ms-traffictypediagnostic: DB6PR0402MB2901:
x-microsoft-antispam-prvs: <DB6PR0402MB2901BE42C4E77419DB0CCFE9F0939@DB6PR0402MB2901.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RDCHzcCRbF7XWa7zTMzl4+Q/nvUKSKE+5DdJEEjLqroI78FAlEhXJFDQTISoBWT16MXblF1GiQcGCSTj4/OUK8X+nHyGMgqpbK73m2Y+FtIq7V/0CtbEC0+9APNJd4o1NqUolRcdYGqs0eqzwMYQPUHgWEHNUp55tCvZIZNKzXvHmxYlvIhP1TVgUnLlnEOkZK6OvUtRPiFYwoV7K31699UhbWZWphGdqSqtt0sFWJB0U0bdSLvMtuUec7K7wqH5qtIRsRrcj95RQju+crBeglNyYz40vV7wYhbIpip7/4tO5Ew4lJnYhwv51CY6Nim8Wv0oHNkz2xbnfwLyJaZLK/9T2LmS4LiYZUUzHVj7r4KYqcmYdWIwb5A5yu0safbOrOdizWS9FM4wZW7vKXDsv3FN83S/EHdBCfoUQ069Jb192wAK+h1SgRvTfGx7kFjvhIjuxJ4H1PfOOO5m5vyKQSzxtsKyMcrDNH5+asRHDNuxQrwBpiXWlyr2iuSI4+pkRCKFUSF92lRQmghaiJc86sxUkTbEtzqiyVWKFnFzJWK7P7odFLfLbFSpEiwf40VWo+G/tIQVWV7VcenD3jrQZ71jNE1aXFcfAVtDtBFXeIKM1cEYoDrEiOb8EI9Ah1C+BKBZf4EB8kvpwsJ4iAJubxDl5Mrl0+5/dQhzaojCDz2jk48mvIhb8kcEYfUuAzIUHbKSzhOMpxA5ede+p8WvOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(71200400001)(7696005)(186003)(316002)(8936002)(38070700005)(66556008)(66946007)(53546011)(508600001)(2906002)(7416002)(6636002)(52536014)(9686003)(54906003)(6862004)(83380400001)(8676002)(86362001)(33656002)(55016002)(38100700002)(5660300002)(6506007)(64756008)(4326008)(66446008)(76116006)(66476007)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?c3Q3SUlBQWs5czZsOHE3UFFwSktab05vVlVTanpURXJkeG85M3RCNDdhdzU3?=
 =?gb2312?B?bG10T256UVNtTjh4aEdOYU9NQ3QyK3Nxb3pBb1A5Zlk5TUZ1L2hjUVZWZDln?=
 =?gb2312?B?RE8xWXNRL0drNFRKaTBZbUR1L1IrampydVo2NUxIRWJGTElzSVoxV05ud2FQ?=
 =?gb2312?B?UkwvK293Wjg4KzN4YU41dTFTRllQelkrYTg3MGFFNW8wVi9PRGxGd29WalBX?=
 =?gb2312?B?N3BxVGRYS1Jjd0ZtY2dyVVArejAxdWszd3BVRlRpamFOTzArQS9kdmsxR1Ru?=
 =?gb2312?B?c3ducXBXdkp4SDZVWVE2ck9lc3NFRnRrTURvSnpFK2gwSkUwOE9QNzNrR3Nv?=
 =?gb2312?B?aDc3dUZJdCtDZUdMWmR4RW54YlNlMkUxSDNiWUxWb0k2L210MmtxM2ZvWDAr?=
 =?gb2312?B?NGR2cEpRWTdmS0lxTHQrTlBlckwwUy8rNmExbUg4RUtDM0ZoeWFwQTJQcjNl?=
 =?gb2312?B?YmF2SHVTQUJZNkRKdlpFSVd3MG5iTlI3b3BheWJwMWNKaVdabjZUMkNiQ29E?=
 =?gb2312?B?OWZxWCtLY1lpTlB1V2JaaW1Sa2Jvc1hlVkRFbmkrWkZzdFpZSGZtUUtYdEk2?=
 =?gb2312?B?c2RaYXMzMHh3SC9NLzVZQktrUWNXK25DeEdJSVQ0WHNQdWxqKyt4ZVdxWGty?=
 =?gb2312?B?WjM3S0p4MmlBZllxdHJleStKandHUFhPdzlmWm1WTEdFeENDRC9vODk4QmZM?=
 =?gb2312?B?dEhJazhaeFdGS1dFTkZzc0tQQjZzSDEvb2w4czRFdHVZQVhoekpEWXFOWXVN?=
 =?gb2312?B?ZE1tOXM0RmV1b09RQkZ4aEF2QUVUQVMwNVNHT04vN25EUjRXcm1lazB6QkhI?=
 =?gb2312?B?SithVUdsTDVCUWlqckxpK3pCdHI3TXFHNHdPYXZhREsvdERBdkhzSHNBd3lx?=
 =?gb2312?B?czA3bHRXakxFUHNiY0VDYUdaK1NJb3M1SUQxZGhiVUZRVFZFb0lLNWxudnBE?=
 =?gb2312?B?Sm5YK2IyMlVEVGxOTVVFV3dHb291VDhyK3pYQyt1U01IeE5XM2J3aURGRWxS?=
 =?gb2312?B?TDY2SlNvVXdaMEVDV3psWkNqNlpHeEEvTkhGZklIU0RnVXNTNitOTTdoS3Zo?=
 =?gb2312?B?aUhNeDV2ZWoxOVJCZ0VKVjBBOXJJM0xLOWpmR2RxSDdDbUVUcFR2bUZVK0ZJ?=
 =?gb2312?B?WjhySzRWc2tWNmtXRTF3SnY5WUpkSjI1NjUrUmRQSlpwOTlCbEMyWklha0Jh?=
 =?gb2312?B?a2tKdnA0eENwR3FadVRaNWZhS3QzbS9RNTkxNXAvTTNNdXVRRFM2TnpIeVph?=
 =?gb2312?B?WmNMQ1FlOCtMTDFiamhiaExaK3c2S1lOVURHa285RXRLUHVnNEtWQlNscjNv?=
 =?gb2312?B?cUIyS2oxeUxJTlFTNklJL0JKMUpSSzNMMzJwYVI2aEdZWGh5UkdheUJzQUU1?=
 =?gb2312?B?QVhDZnRmR0V6QzlIb1JWTkJrK0hxbHFaMi9oak5yNTdMVTRlazNHb3JDZGtQ?=
 =?gb2312?B?WWl5dWg0bnEvRXhsTm5TU1Vkc0QwN1ljTjMwL2xSZEI5VUhIaTlOU1FZQ0VK?=
 =?gb2312?B?VnJoSjROYXdjWER4eTYzMXpHVVFHUVhZN3RscG90alN1b0tNVnJSaWNqbjRE?=
 =?gb2312?B?UUZnMHVuWi9paEdwclJaY0RFOTN0UG1DSzJFTzN3VS9XaDJ5RHdXWUZkcWJj?=
 =?gb2312?B?RFIyTzdnMU4xd1ZuQlVvQ2xHR29QTzk3a0R6V3A3a2Rnb0dQcU5wQzQ4M3BE?=
 =?gb2312?B?dEt6QmxsajVJUDdaYVE2c3AyUVFBQnJ4WHUzcW5lVFZwR2N6SzEzUW9KRys5?=
 =?gb2312?B?aDU3RDhoZFpudkh5RTZsa0VIMThhQXhHWlBoNlJTcjhqUFM3cXhhbnZOWEdY?=
 =?gb2312?B?cWVEeHFHNGhpeXpNYm4yc1czL29kU2Mra1pia2dyV29IWTJsdXdwc0ZsdEZD?=
 =?gb2312?B?U1ZkeVdsOVpQODYvWlBNVXJYTEI3aFhuUEd5cUJJT0dwQzBoYlFkSElzalVC?=
 =?gb2312?B?MlFndm9wYlFsQ3RyeGFKQ1dXTlNILytHVGxOVzhUNFduSlFpRHJZeGMyRVA5?=
 =?gb2312?B?a0E0MWR3dDFSRlA1bUE4NUxtRTA5eTJsZmtZb0VtK09xNHRCQXo5WTNteStz?=
 =?gb2312?B?dWF5VFBrMWpMRG9JdkVsN2FjbGt3MDlPNlFIaVo1S3pQMmZJRElveHJsYjJH?=
 =?gb2312?B?N2xpM1pPYVdieEhhZW5hNldMWW5KTWRpQkpzYW13cHVvREFySk5qbk1WTlht?=
 =?gb2312?B?aExkYU9JcGdjZGtPbmo2TWQ5VWh2bEIwSXdmRzNORXFKUlE4ZS9Jb0ZMSEpX?=
 =?gb2312?B?NDhwbGxVUFBucDVKNHMwRm4zeGtRPT0=?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB5785.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e52bbd7-0f09-43b4-c4bc-08d9a436e997
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2021 10:43:20.1843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6N0OPJMxyZUZYl6/Coi+sy8qjGHublRdRHmokc4bCgjxjOPLA11CaKoRfZHyUKFRUtF2miNdjOdV5S/8/2eKcSIyfKSJWYdvnMNv+6iDnQQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2901
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogVmxh
ZGltaXIgT2x0ZWFuIDx2bGFkaW1pci5vbHRlYW5AbnhwLmNvbT4NCj4gU2VudDogMjAyMcTqMTDU
wjbI1SAyMToxMw0KPiBUbzogWGlhb2xpYW5nIFlhbmcgPHhpYW9saWFuZy55YW5nXzFAbnhwLmNv
bT4NCj4gQ2M6IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmc7DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGFsbGFuLm5pZWxzZW5AbWljcm9jaGlwLmNv
bTsNCj4gam9lcmdlbi5hbmRyZWFzZW5AbWljcm9jaGlwLmNvbTsgVU5HTGludXhEcml2ZXJAbWlj
cm9jaGlwLmNvbTsNCj4gdmluaWNpdXMuZ29tZXNAaW50ZWwuY29tOyBtaWNoYWVsLmNoYW5AYnJv
YWRjb20uY29tOw0KPiB2aXNoYWxAY2hlbHNpby5jb207IHNhZWVkbUBtZWxsYW5veC5jb207IGpp
cmlAbWVsbGFub3guY29tOw0KPiBpZG9zY2hAbWVsbGFub3guY29tOyBhbGV4YW5kcmUuYmVsbG9u
aUBib290bGluLmNvbTsga3ViYUBrZXJuZWwub3JnOyBQbw0KPiBMaXUgPHBvLmxpdUBueHAuY29t
PjsgTGVvIExpIDxsZW95YW5nLmxpQG54cC5jb20+OyBmLmZhaW5lbGxpQGdtYWlsLmNvbTsNCj4g
YW5kcmV3QGx1bm4uY2g7IHZpdmllbi5kaWRlbG90QGdtYWlsLmNvbTsgQ2xhdWRpdSBNYW5vaWwN
Cj4gPGNsYXVkaXUubWFub2lsQG54cC5jb20+OyBsaW51eC1tZWRpYXRla0BsaXN0cy5pbmZyYWRl
YWQub3JnOw0KPiBsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc7IG1hdHRoaWFz
LmJnZ0BnbWFpbC5jb207DQo+IGhvcmF0aXUudnVsdHVyQG1pY3JvY2hpcC5jb20NCj4gU3ViamVj
dDogUmU6IFtQQVRDSCB2NiBuZXQtbmV4dCA1LzhdIG5ldDogZHNhOiBmZWxpeDogc3VwcG9ydCBw
c2ZwIGZpbHRlciBvbg0KPiB2c2M5OTU5DQo+IA0KPiBPbiBUaHUsIE9jdCA2LCAyMDIxIGF0IDIx
OjEzOjQ1ICswMzAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6DQo+ID4gK3N0YXRpYyBpbnQgdnNj
OTk1OV9wc2ZwX2ZpbHRlcl9hZGQoc3RydWN0IG9jZWxvdCAqb2NlbG90LA0KPiA+ICsJCQkJICAg
c3RydWN0IGZsb3dfY2xzX29mZmxvYWQgKmYpDQo+ID4gK3sNCj4gDQo+IE5laXRoZXIgdGhlIHZz
Yzk5NTlfcHNmcF9maWx0ZXJfYWRkIG5vciB2c2M5OTU5X3BzZnBfZmlsdGVyX2RlbA0KPiBpbXBs
ZW1lbnRhdGlvbnMgdGFrZSBhbiAiaW50IHBvcnQiIGFzIGFyZ3VtZW50LiBUaGVyZWZvcmUsIHdo
ZW4gdGhlIFNGSUQgaXMNCj4gcHJvZ3JhbW1lZCBpbiB0aGUgTUFDIHRhYmxlLCBpdCBtYXRjaGVz
IG9uIGFueSBpbmdyZXNzIHBvcnQgdGhhdCBpcyBpbiB0aGUNCj4gc2FtZSBicmlkZ2luZyBkb21h
aW4gYXMgdGhlIHBvcnQgcG9pbnRlZCB0b3dhcmRzIGJ5IHRoZSBNQUMgdGFibGUgKGFuZCB0aGUN
Cj4gTUFDIHRhYmxlIHNlbGVjdHMgdGhlIF9kZXN0aW5hdGlvbl8gcG9ydCkuDQo+IA0KPiBPdGhl
cndpc2Ugc2FpZCwgaW4gdGhpcyBzZXR1cDoNCj4gDQo+ICAgICAgICAgICAgICAgICAgICAgIGJy
MA0KPiAgICAgICAgICAgICAgICAgICAgLyAgfCAgXA0KPiAgICAgICAgICAgICAgICAgICAvICAg
fCAgIFwNCj4gICAgICAgICAgICAgICAgICAvICAgIHwgICAgXA0KPiAgICAgICAgICAgICAgIHN3
cDAgICBzd3AxICAgc3dwMg0KPiANCj4gYnJpZGdlIHZsYW4gYWRkIGRldiBzd3AwIHZpZCAxMDAN
Cj4gYnJpZGdlIHZsYW4gYWRkIGRldiBzd3AxIHZpZCAxMDANCj4gYnJpZGdlIHZsYW4gYWRkIGRl
diBzd3AyIHZpZCAxMDANCj4gYnJpZGdlIGZkYiBhZGQgZGV2IHN3cDIgMDA6MDE6MDI6MDM6MDQ6
MDUgdmxhbiAxMDAgc3RhdGljIG1hc3RlciB0YyBmaWx0ZXIgYWRkDQo+IGRldiBzd3AwIGluZ3Jl
c3MgY2hhaW4gMCBwcmVmIDQ5MTUyIGZsb3dlciBcDQo+IAlza2lwX3N3IGFjdGlvbiBnb3RvIGNo
YWluIDMwMDAwDQo+IHRjIGZpbHRlciBhZGQgZGV2IHN3cDAgaW5ncmVzcyBjaGFpbiAzMDAwMCBw
cmVmIDEgXA0KPiAJcHJvdG9jb2wgODAyLjFRIGZsb3dlciBza2lwX3N3IFwNCj4gCWRzdF9tYWMg
MDA6MDE6MDI6MDM6MDQ6MDUgdmxhbl9pZCAxMDAgXA0KPiAJYWN0aW9uIGdhdGUgYmFzZS10aW1l
IDAuMDAwMDAwMDAwIFwNCj4gCXNjaGVkLWVudHJ5IE9QRU4gIDUwMDAwMDAgLTEgLTEgXA0KPiAJ
c2NoZWQtZW50cnkgQ0xPU0UgNTAwMDAwMCAtMSAtMQ0KPiANCj4gVGhlICJmaWx0ZXIiIGFib3Zl
IHdpbGwgbWF0Y2ggbm90IG9ubHkgb24gc3dwMCwgYnV0IGFsc28gb24gcGFja2V0cyBpbmdyZXNz
ZWQNCj4gZnJvbSBzd3AxLg0KPiANCj4gVGhlIGhhcmR3YXJlIHByb3ZpZGVzIElHUl9TUkNQT1JU
X01BVENIX0VOQSBhbmQgSUdSX1BPUlRfTUFTSyBiaXRzDQo+IGluIHRoZSBTdHJlYW0gRmlsdGVy
IFJBTSAoQU5BOkFOQV9UQUJMRVM6U0ZJRF9NQVNLKS4gTWF5YmUgeW91IGNvdWxkDQo+IHByb2dy
YW0gYSBTRklEIHRvIG1hdGNoIG9ubHkgb24gdGhlIHBvcnRzIG9uIHdoaWNoIHRoZSB1c2VyIGlu
dGVuZGVkPw0KPiANClllcywgeW91IGFyZSByaWdodC4gSSBoYXZlIHRlc3RlZCB0aGF0IHVzZSBJ
R1JfU1JDUE9SVF9NQVRDSF9FTkEgYW5kIElHUl9QT1JUX01BU0sgYml0cyBjYW4gbGV0IGEgU0ZJ
RCB0bw0KbWF0Y2ggb25seSBvbiB0aGUgZGVzaWduYXRlZCBwb3J0cy4gQnV0IHRoaXMgb25seSBj
YW4gbWF0Y2ggdG8gdHdvIHBvcnRzIGZvciBlYWNoIFNGSUQsIHR3byBwb3J0cyB1c2UgdGhlIHNm
aWQsDQpzZmlkKzEgYXMgU0ZJRCBpbmRleC4gSSBjYW4gdHJ5IHRvIGFkZCBpdCBpbiBkcml2ZXIs
IGJ1dCBpdCB3aWxsIGxpbWl0IHVzZXIgb25seSB0byBtYXRjaCBvbmUgb3IgdHdvIHBvcnRzIGZv
ciBhIHNhbWUNCnN0cmVhbS4NCg0KVGhhbmtzLA0KWGlhb2xpYW5nDQo=
