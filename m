Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0622346BF3C
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 16:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238595AbhLGP1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 10:27:23 -0500
Received: from mail-eopbgr140055.outbound.protection.outlook.com ([40.107.14.55]:14477
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233446AbhLGP1W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 10:27:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aBbbu7EPDDWVU0xoaVNvvJYT/B7ynQYZOODCjSXDc3HElwhA8dNgzwr9GaGbYw6UIrtid1BmkCIMvQwvK2i90Ep/4AZS6jesg4iaIbOZM7JzXikpIhfjyt4Y/MHG+ivddaZqz72mo1TR3ci4SWyZ6zBZlMhiIsAleCzHHgq/ihSpLhDpXlsQIlMjiJs0VNqYuGKQy8frCfc3FF9palJRtfWWmO0M5iL0rzTJJo2ehe5s+Rv9FoHau/q+w0FyE2LWMIknaxM5hZwsJc76fQOH4B4TGJNX8Qxk0DMJGwQppET9FI6g43c9ifjLniHDGgVPTLSDhxdJT76JPcL3i0M5FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BcPN7Ffy6YvZ63OCpedqsOAtFtCUyV1Pn5uOFxsZBpM=;
 b=L7Koq1oS+cuFurMr5Lg3qPKdA/6qDH2p+WQiEofr1HquQ3J0LaJlwHQHgflXmzS5AFruth6kaATP77AzoG8FTs6ArbNTmbuFmjIdt9t8vbmUw+Hcn0y9fEqC0t//beaMovy+d59JnzRGpWeJmHtP5eYGLlh2QbSRqkHfol94bYymFCCNVwMt2L/CagDXWHcYes7F8ptOJjjXRE0Nm+hkl+1NrZ9AeWQbDOZRrHGAFhOS1hEztK+i/EBptVvHB/6ruIOaqDC8GTHIAaR0osNa1fWPHctlp0xC/P2Pu+vUpQxmPY6AGd5JaYMuOWJLoaLkqnVDjeZLC+GykKoFu0CPfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BcPN7Ffy6YvZ63OCpedqsOAtFtCUyV1Pn5uOFxsZBpM=;
 b=YQAqNvYi7te4d5l1bXpcjMG9qNdpqRlq9lJW0HxmLHiBCMrj+f6SRd4/m3NbWUTJof6QWlfDNwBZiE9s3x0vmEvN1trzs5zZFkq4J9ES+LfTW9uujiCfXPZEYm+DgATbRVj6Jp0Q4RBdiibKFfBtV6a2SrmGM38nPXsjfc6VAAw=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5694.eurprd04.prod.outlook.com (2603:10a6:803:e0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Tue, 7 Dec
 2021 15:23:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 15:23:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Denis Kirjanov <dkirjanov@suse.de>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: Re: [PATCH net-next v5 4/4] net: ocelot: add FDMA support
Thread-Topic: [PATCH net-next v5 4/4] net: ocelot: add FDMA support
Thread-Index: AQHX60pT2N9heOAMh0yw/W+Yi1Q3QKwnDKEAgAAXlQCAAAIQgA==
Date:   Tue, 7 Dec 2021 15:23:48 +0000
Message-ID: <20211207152347.hnlhja52qeolq7pt@skbuf>
References: <20211207090853.308328-1-clement.leger@bootlin.com>
 <20211207090853.308328-5-clement.leger@bootlin.com>
 <20211207135200.qvjaw6vkazfcmuvk@skbuf> <20211207161624.39565296@fixe.home>
In-Reply-To: <20211207161624.39565296@fixe.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d2691f44-3b98-490c-f06e-08d9b995914a
x-ms-traffictypediagnostic: VI1PR04MB5694:EE_
x-microsoft-antispam-prvs: <VI1PR04MB5694A65B691C058A756E05C5E06E9@VI1PR04MB5694.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NQjyII2+Pf4MUPQzV/Db1pqZo8dmZMiFr/DJws2UwFVTNDNzfCHIi/DbleccsS08aGcPQyePy0O3gOeq8hQwr9oZ+tLXgSOm+BQFn9GWKWjk7V92f/XUtNc2SLTC9mgNAXDLF1jnT/FlE8OuWv0WinaFrwFv83mRzfxpm4ed/3H88A1wpwV8AxTiI8wDaoqyB2TPaxFtJNDxQTiHPRQdr+vgSEfwxuVcckPJ46s50SZXmVzjoAuHsxqEAnZayq7AtEpp5h4PqUTG6UpdfRpBIJL7qT8fzMaXEe8oXhR7rDLz2OJGtbdqUIfsi41eKZYK4UmKWPMCz8+oIHpvjRrMCzOQWXPRJsruMj7e8KCMypmfEqNFBaRi6HG//LTMb+xMfbHTVTIJyzWaa/vMva6gaCFEnldkTRaA0+Uv7/B1BoEUEczY5rVeo5Pf1sDZR44wcBX/khmSp0jBXFdloTU/rCEnB3Cogxds97mxwRIeAmHrGoJgnuDJp93I6Sv0mRFeQIl+kfqcFd7xkudkpmmEaPNJfxw+8PXfDkt2QgNd083inPfPDvjQguQxl5AR/apSpHmwuxT1pH+w1KW76WHcEKRFPjjLvCeyTda0vo+rN4I21tSod4b99pq1Jo2hfX7OtLjF85zlMJRZ3Fv+mF0RdU+kSPToMk6xw5UIqChuomQ7iARjsKxtD0r1BENidcJf4W3yCwJ61EdWPyBPMKd+KA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(54906003)(316002)(6486002)(508600001)(110136005)(4326008)(7416002)(186003)(66556008)(2906002)(76116006)(66476007)(8676002)(66446008)(83380400001)(5660300002)(91956017)(122000001)(66946007)(6506007)(8936002)(44832011)(64756008)(38100700002)(66574015)(86362001)(33716001)(1076003)(26005)(38070700005)(6512007)(71200400001)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RUxIbkk5OGNneG9zdEw5UHlIck5lNXJoeTZBQWxBSGtQVFhjRklUdGl1d3VO?=
 =?utf-8?B?bDMrTVNKNXFLWGYrRURoZUxiQms2N2VsL0w0V0hyWW5pTUVwYVcvOHpvRkt2?=
 =?utf-8?B?ZEk4ZnZRdmJJRzNBSjlVUGdnZE04alJyOFB2S01KWXlzQkx1SFpnKzRPc0dU?=
 =?utf-8?B?UW1Ia0I4aUp5OFZCbzNyc2huQ05ZRkRHdFhiN1I1cEE5dkpXWlYzcVY5OGg5?=
 =?utf-8?B?MFI5aEoyNWJHUFJlOGcwN043T1pUeWZPR1JuY0ZWN0czbDAvVFBDNHNnbzhO?=
 =?utf-8?B?RjhrNGpKMFB4UVNrUjBPMGhFalFoeDdGYUxFV3Jza0hsRFgydnc2aDhwaXdN?=
 =?utf-8?B?cmUzY2dKRDRQYzBoc3FQS2QxWFRkc0c0bHJyZGVNWjRhSGZpa0NhV2VtcUE3?=
 =?utf-8?B?bW91czhQZVV4SmJZMWNoQWlrNjR4SzdrSmU0VW1KNXV2dnp1VW5lL1FIRWxF?=
 =?utf-8?B?UDVEUUo0T2pNOGsrSXZWak9WNCtKQXJHc1MzdGUrYXdjY1FFNSs5bnMwYkg0?=
 =?utf-8?B?Z2Y1QVllT0dJSGFySkN6RjJyUHN2R3BmRFJhOHQveUJzNFRFWkRtQ3hUWDdQ?=
 =?utf-8?B?UUxuOHpXaVpXcnoxTlk2Y3pnNGxCYnhBeWFzQUF4a3A1L1IrQytyN29BOUQr?=
 =?utf-8?B?N1FndlNXeldLTDJPeUFMU2g2cWdXa2s0Zml1R0dPYXRWQjMxZnJQSmtlaytt?=
 =?utf-8?B?eC9wa1pHMyt1c3VvZUVxS2dTT25ZdWZrWE5Vc21vV0hWT0JHeUpKdzRuS1lH?=
 =?utf-8?B?czVXUkxHS0FNY1BSVUJucjNxeHVxK0FpakZqbGQwRUpSVTNMUzhpektCTFhn?=
 =?utf-8?B?ZEc5bG1UV093N0VoL0o4dHlJdzVxMzlzTCtCTEIvUDdCelBZWG5DMlZpdy9p?=
 =?utf-8?B?RXh0WnJQWVhYZ2xoN2lGaHFzeGN3V3g0UjlCTmdBNktyVXBTWm5SclJ2UTY4?=
 =?utf-8?B?N1B6SWNqaTRvRUJOZ0FnSnphTklwTzVWYUN2dURhUjNIZVd1NEN1V2c5SVpn?=
 =?utf-8?B?NU41L0lhZ2tJcTdWUXZqajA3QnJxZmNyNVdBYnhaSjFXUnZqM0RLME84cjFL?=
 =?utf-8?B?RVJ2QXllWkxoMVJTNTh1QzV4cUo1dEpvdG9WM3FRSHBlTlU3aWFmcHB5Vlp0?=
 =?utf-8?B?Vk9BT29Vc3NVZFpQTWMydWhXOEZyaWx1SFVqZ1pDaGVmcVhpTTNDcUh1TlFZ?=
 =?utf-8?B?Z2pmMmZhVDNzYnFETzF4VTZhTkZpL3ZFYzBxUmFJY1VqL1VwWFlWU0ZmWWVi?=
 =?utf-8?B?eTJabDVvSTZlRXRISHROeWRZVlM4QU16T2M4SmdOcFNOWUhrVDBXVS9NWk5E?=
 =?utf-8?B?QzQvajVOZFJLMmpUMldSdy9ZRFFQT1RxRWNIVysrQlQwTURkVG5CbHN0Y3Fn?=
 =?utf-8?B?VVRZcE81L2FHTVJ2NlZaODFjYmVDUGROYVNnaVo4c0lpMXpXRXB0NnB6SDJ1?=
 =?utf-8?B?SC9KT0VPTStNVWxpRWpQL2dwUlBTaCtJZ0hTMEsrMlZxWUdZaGlOaFRrL3c2?=
 =?utf-8?B?bzc4RUtQTFhaR0tHTjlGeTk3UklmRVlnR1BjUmhOWjFaaU1qMm45Q1NvNi94?=
 =?utf-8?B?NFZiVkhxdzJFSVVYWE9GUEhkTkNzdFNnYk9STHVic2RlL3E5dFJjZFdyM0VY?=
 =?utf-8?B?QytzMGN1ZVk3b3ZlMS84YUpOZUcyeEREYzV5R0M5MFRDTDFOSFQ3cGx5Y3VI?=
 =?utf-8?B?K0V4M2F0RFlnRWxVR2svOGJJNVNNSVY1VHhNc3daNkc5eW1YWXN6WFE2OHdl?=
 =?utf-8?B?WmoxVFBWNjRCMWpYQ3dQM2hrRGhCNnRlT05MTUFXR0RmbGJEa3FvQTUyZllG?=
 =?utf-8?B?M3hxWXA0Z09abnRTdTBZZUhSMEw5dXUwV0o1dEtUUVVBYm5DdlUyZ1kwZ0dN?=
 =?utf-8?B?ZktvemhYYjhUV0xweTdTSFRyRnE4M3hadE83Qkl6cThDYStMOGx6REpNTHd5?=
 =?utf-8?B?VUttOEZBN1RuemdTUmpTZkRqekx3cG5ITlEvT2o1dUdid28weWwvdERZNWFP?=
 =?utf-8?B?Y1hsRk1VK3FxUzQyb2t1b3ZMOTUzS3RpeVZLMzdpaDExSWVleUpBTW94LzBt?=
 =?utf-8?B?WW1nZGgyNnhtRXZqRDZmZmZ3ZVQvYUZra2xuL0pBTjNEWXdYTUNLSlBoWnRx?=
 =?utf-8?B?MnJaYVIwM2E0WXQxK2N4M1Z1cnFrTEdFS3BlSTdzcHd5MmRrWmU4a3pFanFs?=
 =?utf-8?Q?vyU+VBwrrhWTgmUE+TTRY4Q=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B9239B7EBF1E1844A621E39FEC7C9A38@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2691f44-3b98-490c-f06e-08d9b995914a
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2021 15:23:48.7884
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kv3FcSfMWH0O6vYfb1+NMdSuYYGIpd52lNYpgosK+gszzvwhHK4dARgRKpCAZFrbHa9ImjyddHAd5TJRAA9PWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5694
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCBEZWMgMDcsIDIwMjEgYXQgMDQ6MTY6MjRQTSArMDEwMCwgQ2zDqW1lbnQgTMOpZ2Vy
IHdyb3RlOg0KPiBMZSBUdWUsIDcgRGVjIDIwMjEgMTM6NTI6MDEgKzAwMDAsDQo+IFZsYWRpbWly
IE9sdGVhbiA8dmxhZGltaXIub2x0ZWFuQG54cC5jb20+IGEgw6ljcml0IDoNCj4gDQo+ID4gT24g
VHVlLCBEZWMgMDcsIDIwMjEgYXQgMTA6MDg6NTNBTSArMDEwMCwgQ2zDqW1lbnQgTMOpZ2VyIHdy
b3RlOg0KPiA+ID4gRXRoZXJuZXQgZnJhbWVzIGNhbiBiZSBleHRyYWN0ZWQgb3IgaW5qZWN0ZWQg
YXV0b25vbW91c2x5IHRvIG9yIGZyb20NCj4gPiA+IHRoZSBkZXZpY2XigJlzIEREUjMvRERSM0wg
bWVtb3J5IGFuZC9vciBQQ0llIG1lbW9yeSBzcGFjZS4gTGlua2VkIGxpc3QNCj4gPiA+IGRhdGEg
c3RydWN0dXJlcyBpbiBtZW1vcnkgYXJlIHVzZWQgZm9yIGluamVjdGluZyBvciBleHRyYWN0aW5n
IEV0aGVybmV0DQo+ID4gPiBmcmFtZXMuIFRoZSBGRE1BIGdlbmVyYXRlcyBpbnRlcnJ1cHRzIHdo
ZW4gZnJhbWUgZXh0cmFjdGlvbiBvcg0KPiA+ID4gaW5qZWN0aW9uIGlzIGRvbmUgYW5kIHdoZW4g
dGhlIGxpbmtlZCBsaXN0cyBuZWVkIHVwZGF0aW5nLg0KPiA+ID4NCj4gPiA+IFRoZSBGRE1BIGlz
IHNoYXJlZCBiZXR3ZWVuIGFsbCB0aGUgZXRoZXJuZXQgcG9ydHMgb2YgdGhlIHN3aXRjaCBhbmQN
Cj4gPiA+IHVzZXMgYSBsaW5rZWQgbGlzdCBvZiBkZXNjcmlwdG9ycyAoRENCKSB0byBpbmplY3Qg
YW5kIGV4dHJhY3QgcGFja2V0cy4NCj4gPiA+IEJlZm9yZSBhZGRpbmcgZGVzY3JpcHRvcnMsIHRo
ZSBGRE1BIGNoYW5uZWxzIG11c3QgYmUgc3RvcHBlZC4gSXQgd291bGQNCj4gPiA+IGJlIGluZWZm
aWNpZW50IHRvIGRvIHRoYXQgZWFjaCB0aW1lIGEgZGVzY3JpcHRvciB3b3VsZCBiZSBhZGRlZCBz
byB0aGUNCj4gPiA+IGNoYW5uZWxzIGFyZSByZXN0YXJ0ZWQgb25seSBvbmNlIHRoZXkgc3RvcHBl
ZC4NCj4gPiA+DQo+ID4gPiBCb3RoIGNoYW5uZWxzIHVzZXMgcmluZy1saWtlIHN0cnVjdHVyZSB0
byBmZWVkIHRoZSBEQ0JzIHRvIHRoZSBGRE1BLg0KPiA+ID4gaGVhZCBhbmQgdGFpbCBhcmUgbmV2
ZXIgdG91Y2hlZCBieSBoYXJkd2FyZSBhbmQgYXJlIGNvbXBsZXRlbHkgaGFuZGxlZA0KPiA+ID4g
YnkgdGhlIGRyaXZlci4gT24gdG9wIG9mIHRoYXQsIHBhZ2UgcmVjeWNsaW5nIGhhcyBiZWVuIGFk
ZGVkIGFuZCBpcw0KPiA+ID4gbW9zdGx5IHRha2VuIGZyb20gZ2lhbmZhciBkcml2ZXIuDQo+ID4g
Pg0KPiA+ID4gQ28tZGV2ZWxvcGVkLWJ5OiBBbGV4YW5kcmUgQmVsbG9uaSA8YWxleGFuZHJlLmJl
bGxvbmlAYm9vdGxpbi5jb20+DQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBBbGV4YW5kcmUgQmVsbG9u
aSA8YWxleGFuZHJlLmJlbGxvbmlAYm9vdGxpbi5jb20+DQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBD
bMOpbWVudCBMw6lnZXIgPGNsZW1lbnQubGVnZXJAYm9vdGxpbi5jb20+DQo+ID4gPiAtLS0gIA0K
PiA+IA0KPiA+ID4gK3N0YXRpYyB2b2lkIG9jZWxvdF9mZG1hX3NlbmRfc2tiKHN0cnVjdCBvY2Vs
b3QgKm9jZWxvdCwNCj4gPiA+ICsJCQkJIHN0cnVjdCBvY2Vsb3RfZmRtYSAqZmRtYSwgc3RydWN0
IHNrX2J1ZmYgKnNrYikNCj4gPiA+ICt7DQo+ID4gPiArCXN0cnVjdCBvY2Vsb3RfZmRtYV90eF9y
aW5nICp0eF9yaW5nID0gJmZkbWEtPnR4X3Jpbmc7DQo+ID4gPiArCXN0cnVjdCBvY2Vsb3RfZmRt
YV90eF9idWYgKnR4X2J1ZjsNCj4gPiA+ICsJc3RydWN0IG9jZWxvdF9mZG1hX2RjYiAqZGNiOw0K
PiA+ID4gKwlkbWFfYWRkcl90IGRtYTsNCj4gPiA+ICsJdTE2IG5leHRfaWR4Ow0KPiA+ID4gKw0K
PiA+ID4gKwlkY2IgPSAmdHhfcmluZy0+ZGNic1t0eF9yaW5nLT5uZXh0X3RvX3VzZV07DQo+ID4g
PiArCXR4X2J1ZiA9ICZ0eF9yaW5nLT5idWZzW3R4X3JpbmctPm5leHRfdG9fdXNlXTsNCj4gPiA+
ICsJaWYgKCFvY2Vsb3RfZmRtYV90eF9kY2Jfc2V0X3NrYihvY2Vsb3QsIHR4X2J1ZiwgZGNiLCBz
a2IpKSB7DQo+ID4gPiArCQlkZXZfa2ZyZWVfc2tiX2FueShza2IpOw0KPiA+ID4gKwkJcmV0dXJu
Ow0KPiA+ID4gKwl9DQo+ID4gPiArDQo+ID4gPiArCW5leHRfaWR4ID0gb2NlbG90X2ZkbWFfaWR4
X25leHQodHhfcmluZy0+bmV4dF90b191c2UsDQo+ID4gPiArCQkJCQlPQ0VMT1RfRkRNQV9UWF9S
SU5HX1NJWkUpOw0KPiA+ID4gKwkvKiBJZiB0aGUgRkRNQSBUWCBjaGFuIGlzIGVtcHR5LCB0aGVu
IGVucXVldWUgdGhlIERDQiBkaXJlY3RseSAqLw0KPiA+ID4gKwlpZiAob2NlbG90X2ZkbWFfdHhf
cmluZ19lbXB0eShmZG1hKSkgew0KPiA+ID4gKwkJZG1hID0gb2NlbG90X2ZkbWFfaWR4X2RtYSh0
eF9yaW5nLT5kY2JzX2RtYSwgdHhfcmluZy0+bmV4dF90b191c2UpOw0KPiA+ID4gKwkJb2NlbG90
X2ZkbWFfYWN0aXZhdGVfY2hhbihvY2Vsb3QsIGRtYSwgTVNDQ19GRE1BX0lOSl9DSEFOKTsNCj4g
PiA+ICsJfSBlbHNlIHsNCj4gPiA+ICsJCS8qIENoYWluIHRoZSBEQ0JzICovDQo+ID4gPiArCQlk
Y2ItPmxscCA9IG9jZWxvdF9mZG1hX2lkeF9kbWEodHhfcmluZy0+ZGNic19kbWEsIG5leHRfaWR4
KTsNCj4gPiA+ICsJfQ0KPiA+ID4gKwlza2JfdHhfdGltZXN0YW1wKHNrYik7DQo+ID4gPiArDQo+
ID4gPiArCXR4X3JpbmctPm5leHRfdG9fdXNlID0gbmV4dF9pZHg7ICANCj4gPiANCj4gPiBZb3Un
dmUgZGVjaWRlZCBhZ2FpbnN0IG1vdmluZyB0aGVzZSBiZWZvcmUgb2NlbG90X2ZkbWFfYWN0aXZh
dGVfY2hhbj8NCj4gPiBUaGUgc2tiIG1heSBiZSBmcmVlZCBieSBvY2Vsb3RfZmRtYV90eF9jbGVh
bnVwKCkgYmVmb3JlDQo+ID4gc2tiX3R4X3RpbWVzdGFtcCgpIGhhcyBhIGNoYW5jZSB0byBydW4s
IGlzIHRoaXMgbm90IHRydWU/DQo+IA0KPiBTaW5jZSB0eF9yaW5nLT5uZXh0X3RvX3VzZSBpcyB1
cGRhdGVkIGFmdGVyIGNhbGxpbmcgc2tiX3R4X3RpbWVzdGFtcCwNCj4gZmRtYV90eF9jbGVhbnVw
IHdpbGwgbm90IGZyZWUgaXQuIEhvd2V2ZXIsIEknbSBub3Qgc3VyZSBpZiB0aGUNCj4gdGltZXN0
YW1waW5nIHNob3VsZCBiZSBkb25lIGJlZm9yZSBiZWluZyBzZW50IGJ5IHRoZSBoYXJkd2FyZSAo
aWUsIGRvZXMNCj4gdGhlIHRpbWVzdGFtcGluZyBmdW5jdGlvbiBtb2RpZmllcyB0aGUgU0tCIGlu
cGxhY2UpLiBJZiBub3QsIHRoZW4gdGhlDQo+IGN1cnJlbnQgY29kZSBpcyBvay4gQnkgbG9va2lu
ZyBhdCBvY2Vsb3RfcG9ydF9pbmplY3RfZnJhbWUsIHRoZQ0KPiB0aW1lc3RhbXBpbmcgaXMgZG9u
ZSBhZnRlciBzZW5kaW5nIHRoZSBmcmFtZS4NCg0KSXQgbG9va3MgbGlrZSB3ZSBtYXkgbmVlZCBS
aWNoYXJkIGZvciBhbiBleHBlcnQgb3Bpbm9uLg0KRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5nL3Rp
bWVzdGFtcGluZy5yc3Qgb25seSBzYXlzOg0KDQp8IERyaXZlciBzaG91bGQgY2FsbCBza2JfdHhf
dGltZXN0YW1wKCkgYXMgY2xvc2UgdG8gcGFzc2luZyBza19idWZmIHRvIGhhcmR3YXJlDQp8IGFz
IHBvc3NpYmxlLg0KDQpub3Qgd2hldGhlciBpdCBtdXN0IGJlIGRvbmUgYmVmb3JlIG9yIGl0IGNh
biBiZSBkb25lIGFmdGVyIHRvbzsNCmJ1dCBteSBpbnR1aXRpb24gc2F5cyB0aGF0IGlzIGFsc28g
bmVlZHMgdG8gYmUgc3RyaWN0bHkgX2JlZm9yZV8gdGhlDQpoYXJkd2FyZSB4bWl0LCBvdGhlcndp
c2UgaXQgYWxzbyByYWNlcyB3aXRoIHRoZSBoYXJkd2FyZSBUWCB0aW1lc3RhbXBpbmcNCnBhdGgg
YW5kIHRoYXQgbWF5IGxlYWQgdG8gaXNzdWVzIG9mIGl0cyBvd24gKHRoZSBsb2dpYyB3aGV0aGVy
IHRvDQpkZWxpdmVyIGEgc29mdHdhcmUgYW5kL29yIGEgaGFyZHdhcmUgdGltZXN0YW1wIHRvIHRo
ZSBzb2NrZXQgaXMgbm90DQp0cml2aWFsIGF0IGFsbCku
