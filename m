Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194CC46A24D
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 18:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236374AbhLFRLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 12:11:06 -0500
Received: from mail-eopbgr80074.outbound.protection.outlook.com ([40.107.8.74]:56942
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238294AbhLFRKr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 12:10:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TCmUiDx+EeuAZa/xtkJx2qEkNqjgY3POTnZv6lKpQALV8tOcLDK+ixh+2Qg/Z9rYm1P1af8vUYmx7MY/LdYX/Ij8BYXDc3IT07DDF8NdJf33TgKy+b/1Nhp5Kk299IzkTCyvaLvYon8Xph7gQc2it05Mwq+SY1wVbI1BQkyIGwKj3K6eXdXIduwJqINXFW4nE+Jw/8YsD8IRAa3rdw4nHVni0HOMTjiPM/xKlO0tacfs3PR4x6ZB3OHt0BHVryVrHxdz5fJdhCmsTyKQAd697EI/Ua2Korm6aNLRRtQMWiEhJdTxWrIIxJQiAKoD6lWO7rYjwQ6khIv0+Je3JFSSNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uhBUrbY2Q7ZVpawXPn1KKkIJl9GHeu/dyKCqPSwo9Bs=;
 b=nKVPqnsj9/JPP5aftZE1SuKfS0m00LyMiJO0xdmoJ8H6/2w5tn96lJ0len5V20QlELTkMvXvjz6c9KjD9WjhYvlTbnKRC2pesxFbG7V9TyAIrTynu3CRCeX8NEXOvTBfLKifAZCbflx/kIxVcr/L6G3ejK2c5YuD3PuF1M/JgSYVbkkT9r9j9gHrZEZyvemKlm512DTgK9N6P3XT1F+zMy9Bpefr1oCMOuzyEE4xFh5ySFcssDrXL718EKqNm6NL5LXzihZ1o1K/q89UMtUwOQ/+KuREUZB5TXj7QlRfPOSjUaNFYr48V5qFAQPIkFkAbo53KjcQWHMchd8ZVGQaDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uhBUrbY2Q7ZVpawXPn1KKkIJl9GHeu/dyKCqPSwo9Bs=;
 b=HxedyziSmMwyo4Ni97Oxw9aa5EqhUXN5AnitlMJqksYsZIGtSaSskEOd99BaJd69LPKMm8T3+DwZo+U89nBlRZupPY5b5jp7K6LJWXPElUeAZCMRPKq4yNDAPa4GP9jxceqb1FMla65g/Jj+Vzh57qdPnMvDjN9ZBX5hFm5ubH8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3071.eurprd04.prod.outlook.com (2603:10a6:802:3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Mon, 6 Dec
 2021 17:07:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.022; Mon, 6 Dec 2021
 17:07:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
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
Subject: Re: [PATCH net-next v4 4/4] net: ocelot: add FDMA support
Thread-Topic: [PATCH net-next v4 4/4] net: ocelot: add FDMA support
Thread-Index: AQHX6GoBQOKMK7t4rE2bRf8FEkqhQ6wiWRIAgALdbwCAAIAagA==
Date:   Mon, 6 Dec 2021 17:07:16 +0000
Message-ID: <20211206170715.awfojcbzxirrueih@skbuf>
References: <20211203171916.378735-1-clement.leger@bootlin.com>
 <20211203171916.378735-5-clement.leger@bootlin.com>
 <20211204134342.7mhznmfh3x36nlxj@skbuf> <20211206102846.40e4cbb9@fixe.home>
In-Reply-To: <20211206102846.40e4cbb9@fixe.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 05d6ba2e-c0e7-430a-8366-08d9b8dadabb
x-ms-traffictypediagnostic: VI1PR04MB3071:EE_
x-microsoft-antispam-prvs: <VI1PR04MB3071BFEE0A469983F495E1C2E06D9@VI1PR04MB3071.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j//onBUeXuyLxsEXQq8SEvXLhacY/O8FtVmYepelwwNDIZsvtRXclwaXizYJWiq0j8uZklJJpVHY58V2X38ki3kCsT5Af4TdIf5uxPtmYdNPpj3mdk0ccLyhWEwQHXsflhh9pYeaZ7ruxX8r6FYP5EhXrkja0waYwIXaIFtaGNce2q+lWfFvJRKpHA8s2V1y6wOOYy+eUppaZAdl8Lme+JWHsBBzSuoPtCoO+sLwYNNK8exxl7NSVYD6RqxYMHzh5Ec7ovnoUNz/q2dIhQfDIZ/w2Som+IaWljD5CK1dCZS2LYCAoWbj8/172zNdf8ZKkoZ48nigdkkNlYNYW2cuhJ+baN11yWbP9IzWCPvb/DCWx3OYVCJUAYHNHnkwXYZsK8gd2+XnN4XNtkS1Hv2/ybRYp/QokxHBYIo+g1SXv9pHCVn/gP2eP+AJzmyTigKvaWROEtJ+9yYXOl7VUOGRdqaGwOGlJY5lVsZppfOeYBaPoLNh2zbLmj6LHk9pua7Hx5TKGBe2hjcU0cEanTu5I5OgUlGDe9bJ23DT6oGifvK8mUanQM7hTEuFaHWxWczp4xbtBE/BsKAMFBJJShu/Lme8KOuQcw79gkPRUqAy7j33Bpah2aTooBwgFyozl985Nrv1keByAi/BbfGx5LY9c4IQf6PbXNpSDD0CM8XG1bOEDbOQfSKSWDdmRSvgecP1PwnOxgp3HkESc1V7HeWbBA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(83380400001)(6506007)(2906002)(186003)(26005)(71200400001)(6512007)(7416002)(3716004)(9686003)(8676002)(4326008)(122000001)(66574015)(38100700002)(33716001)(54906003)(44832011)(508600001)(86362001)(38070700005)(316002)(5660300002)(6486002)(66446008)(64756008)(66556008)(91956017)(6916009)(66946007)(8936002)(76116006)(1076003)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OFRkektzNWJLTzJtalBScXBOY25uQ0w2bjM4cnZWNlB6d0hETWJJZVJUbUpR?=
 =?utf-8?B?Wk10VUNYdzREQzM4OWM1WHVubFFUNXpNeXI0QVBobVBTekJDUjhJMkh3NnF3?=
 =?utf-8?B?UEdBYzFBSU03bmF0b2RHY29SRmF6dXF0cVlWODJ6dDVLcEQ2MXlXeDVEQkto?=
 =?utf-8?B?WTdma2FoR1hrdndEVkE0QllqM0hOSmREdlJ2dXNPLzdUbDZ3dUMwYW1iUTNH?=
 =?utf-8?B?M2NwNlQramhBSkFJSEJpRitVd1pXNkwwbUdYdG5QckVKQThXR014Ym02WTI3?=
 =?utf-8?B?S3ZLNndlcjAwT3orTlFtbEpNbkhVckJ5TzR3QmpQODZUdGxOQnJab0pydkQ0?=
 =?utf-8?B?Y2ltdkhvZ1pBa2JLSUdzbTVRM3oxM1RIMzBleTYzbzRZbll1WnJUblpGUUwx?=
 =?utf-8?B?QVNOcEc1d0tteVAxaHBqVTVDOGozOEhpYzVnRU5ZdXZ2YjdhMW9ZK3l6VWpL?=
 =?utf-8?B?MGtGTHhhOFM3SXNZcUhmeWFCNmZDU1FyOEx6WFJzREo3K04yVSszUjRhWHZn?=
 =?utf-8?B?TGJKU3hHMEhJRzBYaGhzNkxyclorSjdnaGtUa1h4dE0zZDVXN09raThLWHRT?=
 =?utf-8?B?K0theGJEL01vRGEyZG9nTS9YTThQS0NKMlRXVmNFZTEwWWVLK2Exb0h2VHZC?=
 =?utf-8?B?UnJSWjNIcTJ3MVVhcVJJSWRjalU4aWtwU2YrcjIwRkRTQmY5TUxhT2Z4VVNO?=
 =?utf-8?B?akptREJuSGRhNU1lc0xscXNuM09wN09CNTdwV0RtK0lZU0I4VktwRzBzWjJv?=
 =?utf-8?B?SnRmSDJiK1FyaElqMVduM1RiUDRaWE03bFc1Tnc3cVBrdjB1WSttM2UvVmhX?=
 =?utf-8?B?OTRmSlh1cG1oV3l4SEREblR2ditIbkYrbXNTV3VFdjQwejdVQnJNdWhsNWt3?=
 =?utf-8?B?N043amVmMHBiQjdML0JmZ081dXg2OWZVamdxRVIybTlFa2t2cCtHdWlSZ0lR?=
 =?utf-8?B?encxcHBYWmI1Q2M0YjVIUGtiMGVFZE5QZTYwSGxCckFwNjQwZTlnWmZJTVd5?=
 =?utf-8?B?L0wrR0lRTWRjVUwrT0l2UGRzSW5IMndVTFgyNE01NkRTVWpla0xucGdaeUZY?=
 =?utf-8?B?RnNLTmR5YTVGalltaHZlVHE5WitneGY4ZjErU3JoU3piSnNrWlNRdEUyc1c1?=
 =?utf-8?B?Y1hpS0xSdXNmNGt4UjlScnRBUVphVXZrc0xxbUNyY3kzVElmczhzZEtpWFF3?=
 =?utf-8?B?N21pWDlmeGxXUzZJaE9ta3pHem1ranpOdVFYZlcySEtGN0duR1E5NjM3bXJF?=
 =?utf-8?B?L0ZLSmdwUU03cktKSG1OZHJlSkIxdkxyQlpvQTEraDBwZVZLaFoxT0NtNmFE?=
 =?utf-8?B?VmxtM203dlVRb3BpTkZ1ekpXMXdjaUx4NVF6ZVBUL0dMTXVrM25iYnpYUXVa?=
 =?utf-8?B?MjdKSDBZQWJSYjJiL0hFaDJwbll5MHg0eVYyUm5laU9KOUZOSmcwU24xdFVm?=
 =?utf-8?B?TGk2RXgreFJPNFd4ZE5sL01hRGhOTDBacXJGK1IrRjFtNHA0OEg0ZWxIb2U5?=
 =?utf-8?B?Mm1TampvZ1hiN0JUcGk5bnhDc3orbG1mbnV4QXNyM0JvTVFzd1NRT2d2UWNX?=
 =?utf-8?B?TGIzZTIrWHZ0TnlrRUJXQ1VkLzdpNXl5RldUbFZ0RWRqWDloZ1Q5US9yR21z?=
 =?utf-8?B?RFc2WVVkUTZYb25qOThNSUJSc3BwM2NkMjN3aS9CeGdkQzgvVnp1YnZRUkVv?=
 =?utf-8?B?VEo3UzMyb2d2aWpmTDJUU2FKNDBtMHM1cjJiTjRnZG1waFFGdnVtR3FERnhS?=
 =?utf-8?B?bnhmSE55aGV0L1JyeGZiWFlNdkl5eHZmdENRZFdHS1pIQXMrTUtZdWk3aXNW?=
 =?utf-8?B?a2xmOW9zbXNBcFF6S0JxQTdTQnlXMFp3elVvcFdETWZBSTdUUHdMZzAxTHBh?=
 =?utf-8?B?Mzc3SzNvZ1lGQXhhZTBza1p2MlJ0UWxZZHFzQUN0dXhFOXhCdFJoa1d2Zzhw?=
 =?utf-8?B?RTRvMUc3akR1RXBaaWh3RHhuVGNDVkI3ZnJobXpZN2M3cXlFMEFHajhnVm0x?=
 =?utf-8?B?c3lRUmhmQ1lKbVJNSVBIUkZxRmNqU2ZBazl5dTBxdUNDQzB5WDJpc3dmOUdZ?=
 =?utf-8?B?TGd3R3FXbTlvazFTR0NTTGMxZ2dHS2RzNmkrQVJGazlKTlBnbVYwbDVSbEs0?=
 =?utf-8?B?WDNpUk52Zlp6V1g0OUhZRjlhRTZnOWh5NE1MZCs1YlR0aEFiSnI5MjQxQVYz?=
 =?utf-8?Q?z/tDbxafv4bvyp9f4dCxCF4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <20273A3A112FE947AC3B329EAA1ECD7C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05d6ba2e-c0e7-430a-8366-08d9b8dadabb
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2021 17:07:16.0332
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qzYFW7uE2+X2EyF4VDIXEewO5H2aN4qmg6SHjC0Or8Qjm82ZEWtXOEcSIsvm69a2uvq6fLOWdujCwBVv+XGyyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3071
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCBEZWMgMDYsIDIwMjEgYXQgMTA6Mjg6NDZBTSArMDEwMCwgQ2zDqW1lbnQgTMOpZ2Vy
IHdyb3RlOg0KPiBMZSBTYXQsIDQgRGVjIDIwMjEgMTM6NDM6NDMgKzAwMDAsDQo+IFZsYWRpbWly
IE9sdGVhbiA8dmxhZGltaXIub2x0ZWFuQG54cC5jb20+IGEgw6ljcml0IDoNCj4gDQo+ID4gT24g
RnJpLCBEZWMgMDMsIDIwMjEgYXQgMDY6MTk6MTZQTSArMDEwMCwgQ2zDqW1lbnQgTMOpZ2VyIHdy
b3RlOg0KPiA+ID4gRXRoZXJuZXQgZnJhbWVzIGNhbiBiZSBleHRyYWN0ZWQgb3IgaW5qZWN0ZWQg
YXV0b25vbW91c2x5IHRvIG9yIGZyb20NCj4gPiA+IHRoZSBkZXZpY2XigJlzIEREUjMvRERSM0wg
bWVtb3J5IGFuZC9vciBQQ0llIG1lbW9yeSBzcGFjZS4gTGlua2VkIGxpc3QNCj4gPiA+IGRhdGEg
c3RydWN0dXJlcyBpbiBtZW1vcnkgYXJlIHVzZWQgZm9yIGluamVjdGluZyBvciBleHRyYWN0aW5n
IEV0aGVybmV0DQo+ID4gPiBmcmFtZXMuIFRoZSBGRE1BIGdlbmVyYXRlcyBpbnRlcnJ1cHRzIHdo
ZW4gZnJhbWUgZXh0cmFjdGlvbiBvcg0KPiA+ID4gaW5qZWN0aW9uIGlzIGRvbmUgYW5kIHdoZW4g
dGhlIGxpbmtlZCBsaXN0cyBuZWVkIHVwZGF0aW5nLg0KPiA+ID4gDQo+ID4gPiBUaGUgRkRNQSBp
cyBzaGFyZWQgYmV0d2VlbiBhbGwgdGhlIGV0aGVybmV0IHBvcnRzIG9mIHRoZSBzd2l0Y2ggYW5k
DQo+ID4gPiB1c2VzIGEgbGlua2VkIGxpc3Qgb2YgZGVzY3JpcHRvcnMgKERDQikgdG8gaW5qZWN0
IGFuZCBleHRyYWN0IHBhY2tldHMuDQo+ID4gPiBCZWZvcmUgYWRkaW5nIGRlc2NyaXB0b3JzLCB0
aGUgRkRNQSBjaGFubmVscyBtdXN0IGJlIHN0b3BwZWQuIEl0IHdvdWxkDQo+ID4gPiBiZSBpbmVm
ZmljaWVudCB0byBkbyB0aGF0IGVhY2ggdGltZSBhIGRlc2NyaXB0b3Igd291bGQgYmUgYWRkZWQg
c28gdGhlDQo+ID4gPiBjaGFubmVscyBhcmUgcmVzdGFydGVkIG9ubHkgb25jZSB0aGV5IHN0b3Bw
ZWQuDQo+ID4gPiANCj4gPiA+IEJvdGggY2hhbm5lbHMgdXNlcyByaW5nLWxpa2Ugc3RydWN0dXJl
IHRvIGZlZWQgdGhlIERDQnMgdG8gdGhlIEZETUEuDQo+ID4gPiBoZWFkIGFuZCB0YWlsIGFyZSBu
ZXZlciB0b3VjaGVkIGJ5IGhhcmR3YXJlIGFuZCBhcmUgY29tcGxldGVseSBoYW5kbGVkDQo+ID4g
PiBieSB0aGUgZHJpdmVyLiBPbiB0b3Agb2YgdGhhdCwgcGFnZSByZWN5Y2xpbmcgaGFzIGJlZW4g
YWRkZWQgYW5kIGlzDQo+ID4gPiBtb3N0bHkgdGFrZW4gZnJvbSBnaWFuZmFyIGRyaXZlci4NCj4g
PiA+IA0KPiA+ID4gQ28tZGV2ZWxvcGVkLWJ5OiBBbGV4YW5kcmUgQmVsbG9uaSA8YWxleGFuZHJl
LmJlbGxvbmlAYm9vdGxpbi5jb20+DQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBBbGV4YW5kcmUgQmVs
bG9uaSA8YWxleGFuZHJlLmJlbGxvbmlAYm9vdGxpbi5jb20+DQo+ID4gPiBTaWduZWQtb2ZmLWJ5
OiBDbMOpbWVudCBMw6lnZXIgPGNsZW1lbnQubGVnZXJAYm9vdGxpbi5jb20+DQo+ID4gPiAtLS0g
IA0KPiA+IA0KPiA+IERvZXNuJ3QgbG9vayB0b28gYmFkLiBEaWQgdGhlIHBhZ2UgcmV1c2UgbWFr
ZSBhbnkgZGlmZmVyZW5jZSB0byB0aGUNCj4gPiB0aHJvdWdocHV0LCBvciBpcyB0aGUgaW50ZXJh
Y3Rpb24gd2l0aCB0aGUgRkRNQSBleHRyYWN0aW9uIGNoYW5uZWwgd2hlcmUNCj4gPiB0aGUgYm90
dGxlbmVjayBpcz8NCj4gDQo+IFdpdGggYSBzdGFuZGFyZCBNVFUsIHRoZSByZXN1bHRzIGRpZCBu
b3QgaW1wcm92ZWQgYSBsb3QuLi4gVENQIFJYIGFkZCBhDQo+IHNtYWxsIGltcHJvdmVtZW50ICh+
NE1CaXQvcykgYnV0IHRoYXQgaXMgdGhlIG9ubHkgb25lLg0KPiBIZXJlIGFyZSB0aGUgbmV3IHJl
c3VsdHMgd2l0aCB0aGUgRkRNQToNCj4gDQo+IFRDUCBUWDogNDguMiBNYml0cy9zZWMNCj4gVENQ
IFJYOiA2MC45IE1iaXRzL3NlYw0KPiBVRFAgVFg6IDI4LjggTWJpdHMvc2VjDQo+IFVEUCBSWDog
MTguOCBNYml0cy9zZWMNCj4gDQo+IEluIGp1bWJvIG1vZGUgKDkwMDAgYnl0ZXMgZnJhbWVzKSwg
dGhlcmUgaXMgaW1wcm92ZW1lbnRzOg0KPiANCj4gVENQIFRYOiA3NC40IE1iaXRzL3NlYw0KPiBU
Q1AgUlg6IDEwOSBNYml0cy9zZWMNCj4gVURQIFRYOiAxMDUgTWJpdHMvc2VjDQo+IFVEUCBSWDog
NTEuNiBNYml0cy9zZWMNCg0KWWVhaCwgSSBkb24ndCBrbm93IHdoYXQgZWxzZSB0byB0ZWxsIHlv
dS4gU29ycnkuDQoNCj4gPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3NvYy9tc2NjL29jZWxvdC5o
IGIvaW5jbHVkZS9zb2MvbXNjYy9vY2Vsb3QuaA0KPiA+ID4gaW5kZXggMTFjOTlmY2ZkMzQxLi4y
NjY3YTIwM2UxMGYgMTAwNjQ0DQo+ID4gPiAtLS0gYS9pbmNsdWRlL3NvYy9tc2NjL29jZWxvdC5o
DQo+ID4gPiArKysgYi9pbmNsdWRlL3NvYy9tc2NjL29jZWxvdC5oDQo+ID4gPiBAQCAtNjkyLDYg
KzY5MiwxMiBAQCBzdHJ1Y3Qgb2NlbG90IHsNCj4gPiA+ICAJLyogUHJvdGVjdHMgdGhlIFBUUCBj
bG9jayAqLw0KPiA+ID4gIAlzcGlubG9ja190CQkJcHRwX2Nsb2NrX2xvY2s7DQo+ID4gPiAgCXN0
cnVjdCBwdHBfcGluX2Rlc2MJCXB0cF9waW5zW09DRUxPVF9QVFBfUElOU19OVU1dOw0KPiA+ID4g
Kw0KPiA+ID4gKwlzdHJ1Y3Qgb2NlbG90X2ZkbWEJCSpmZG1hOw0KPiA+ID4gKwkvKiBOYXBpIGNv
bnRleHQgdXNlZCBieSBGRE1BLiBOZWVkcyB0byBiZSBpbiBvY2Vsb3QgdG8gYXZvaWQgdXNpbmcg
YQ0KPiA+ID4gKwkgKiBiYWNrcG9pbnRlciBpbiBvY2Vsb3RfZmRtYQ0KPiA+ID4gKwkgKi8NCj4g
PiA+ICsJc3RydWN0IG5hcGlfc3RydWN0CQluYXBpOyAgDQo+ID4gDQo+ID4gQ2FuIGl0IGF0IGxl
YXN0IGJlIGR5bmFtaWNhbGx5IGFsbG9jYXRlZCwgYW5kIGtlcHQgYXMgYSBwb2ludGVyIGhlcmU/
DQo+IA0KPiBJZiBpdCBpcyBkeW5hbWljYWxseSBhbGxvY2F0ZWQsIHRoZW4gY29udGFpbmVyX29m
IGNhbid0IGJlIHVzZWQgYW55bW9yZQ0KPiBpbiB0aGUgbmFwaSBwb2xsIGZ1bmN0aW9uLiBJIGNv
dWxkIG1vdmUgaXQgYmFjayBpbiBzdHJ1Y3QgZmRtYSBidXQNCj4gdGhlbiwgSSB3b3VsZCBuZWVk
IGEgYmFja3BvaW50ZXIgdG8gb2NlbG90IGluIHRoZSBmZG1hIHN0cnVjdC4NCj4gT3IgSSBjb3Vs
ZCB1c2UgbmFwaS0+ZGV2IGFuZCBhY2Nlc3MgdGhlIG9jZWxvdF9wb3J0X3ByaXZhdGUgdG8gdGhl
biBnZXQNCj4gdGhlIG9jZWxvdCBwb2ludGVyIGJ1dCBJIGhhdmUgbm90IHNlZW4gbXVjaCBkcml2
ZXIgdXNpbmcgdGhlIG5hcGktPmRldg0KPiBmaWVsZC4gVGVsbCBtZSB3aGF0IHlvdSB3b3VsZCBs
aWtlLg0KDQpJZiB5b3Ugd2FudCB0byBtb3ZlIGl0IGJhY2sgdG8gc3RydWN0IG9jZWxvdF9mZG1h
LCB5b3UgY2FuIGRvIHRoYXQsIEknbQ0KZmluZSB3aXRoIHRoYXQgbm93IDopIFNvcnJ5IGZvciB0
aGUgdHJvdWJsZS4=
