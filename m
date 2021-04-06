Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8714354A37
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 03:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243201AbhDFBhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 21:37:31 -0400
Received: from mail-eopbgr00078.outbound.protection.outlook.com ([40.107.0.78]:54897
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242023AbhDFBhZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 21:37:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SUthblCLIZHBHTgGjbYwJlv87tZGX9G9oFOErRrxAuiv6zY40IbEBm8NxUge0bo593OLTbtw9pdBFSERQmSqYKgTBNzpvv+BNyyz9ycF382VNmwED0X7VcXSahD9APbnDf+UtcJUFyXJWnJpzUVJf71JyEOGgVLth7UQEfM/577eEwppjQ38A0GFhgkrwGnlPc7JNE/aWJHfYNowIppaYb71/MB/JS7so8S8jksT5+tVMIzxTQshofh1YfkIsuhExFS9rWl5l1El0ADR8M6o6awqtWoYU2Q2ZE+8dI9HsU0RzQiNZO5utpj5vMKHKojpFWeDGCKM2iOVuykCLoaD9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XpfRM8vPKG4Ba4MwdLrguJO6O7whx7HOazz1hCtVkFo=;
 b=ViEcFirGV29EEcbnDAJpqnj6yrqEnTpy0uK9aQdYIaOgEiNJqLEknpyGy+OVeqLGI891GyHtMfQJ5GYc89diTW2huHSqgkraJrfhd/vS7BgHNXikMdfh1dVf2rLPhamWokKYfpX2ujNr0tsdaYdfPSTRbmuBlJz/p4WlL59QYQz/UY9GsimQWxLpzmD3MW9oZuBDuAmQbUWULd6Z9p2EUkY/3sfWqgHTgaC1giUpWYCHCa/Kr6xFuxiDPg4GDx75kWVR4jfV/le7yUjgpQE9R7qP0/KqfRVZx88XgnTvkZTlG/tWwQt8qdHR7TvY3tSvP3jZ5zqgqiy/W2zwy66pkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XpfRM8vPKG4Ba4MwdLrguJO6O7whx7HOazz1hCtVkFo=;
 b=NfpG9abKE78/BjTLc9XYCKoP+6vS2Wy3wRInNkxuHk+e6esA2uPq49Elpte0fTNdRsjfvQcHfdXvVmtcAMrRAXfoN46vjQgEoSxlzanelvsyVvMX3Ik265JMDfzj2HpeTatpJCDEZPms2Fq3rYepKOrndiKsFk56GSVNZvvzFWw=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB5308.eurprd04.prod.outlook.com (2603:10a6:10:1d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Tue, 6 Apr
 2021 01:37:15 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%5]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 01:37:15 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "christian.melki@t2data.com" <christian.melki@t2data.com>
Subject: RE: [PATCH] net: phy: fix PHY possibly unwork after MDIO bus resume
 back
Thread-Topic: [PATCH] net: phy: fix PHY possibly unwork after MDIO bus resume
 back
Thread-Index: AQHXKTprONOHGtpeU0eiVA3RKY2nOaqkZbwAgAJKm5A=
Date:   Tue, 6 Apr 2021 01:37:14 +0000
Message-ID: <DB8PR04MB67950878469CACA2A7731A2BE6769@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210404100701.6366-1-qiangqing.zhang@nxp.com>
 <97e486f8-372a-896f-6549-67b8fb34e623@gmail.com>
In-Reply-To: <97e486f8-372a-896f-6549-67b8fb34e623@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cc1245d8-946e-476c-18c1-08d8f89c81dd
x-ms-traffictypediagnostic: DB7PR04MB5308:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB530827C27E1BD48355E34514E6769@DB7PR04MB5308.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K+HMWyG+fDW+1iwIoCLo+UR6YZtsbQNnAigiHr9flrnjPWS/3UbsGTMj9dT9qVkRlGYz4TpbJ62ClGCRJPoYE/WZ67ID77u0RL9F3QZrIWl4G/GNu+XkpimM6IOlkr9rwm+HLWcLIN69MW98ziKfkG93VRaqXUB5FbX8Cn84LM0FT6cvuwJJTe8lMnZopDFKgx5auaOtWoOx9FggvFOKSK6GsOWrgldhWmlDOvAUiejXZgddYDVHg3aJv/wLf/ACAFGCA187V6yYoqqaD6mQ6DclyrM5v9B8IVL5tA5Yi9ijnv/MjIHHwMWUPNAY9xsQgNh3PLTIpIGEOyFIiJ0BM2w2UONrV265J2fJrsV94dvL5mVeVveXSyL3+xvieRxwO8sqA2nsSTqp99ISXxBQLiHVs2N6b0nwsgEKz8pnx/xPskSpwzmS2mU02K13MPqQvhumLC3k45SHiuZvwl9lluTmUu47KIr7OMhSTynokrWlfiZaqZx7yUcJErdbZrcxK/KIp47C5b6NRChOAyIHEi8GY+8Q4JDXBRQukOaAgeX6Zosmvc6Q7BzSeH6Sf+0stQO6j1sK0IcCcnrjW4E0Q7qTjJ6bicMJxFdrIuCa2RrlbbC7y77HuDUqinU6TkgCU8zQIzXSpAPh4oNADyECC2QIxVVrqwlIEXMNcJZ6ovY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(346002)(376002)(366004)(86362001)(55016002)(71200400001)(33656002)(110136005)(4326008)(316002)(186003)(9686003)(8936002)(8676002)(6506007)(66946007)(2906002)(66446008)(52536014)(76116006)(26005)(5660300002)(83380400001)(38100700001)(7696005)(64756008)(66556008)(66476007)(54906003)(478600001)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?OUVuZ2s5OGl6WnlBL2haNllPRXdpbWFsSml4NG1ET1ZxMHJVR1J3ckN3ODNa?=
 =?utf-8?B?V2NnSzVOT1pHM3B0dWIzTllsa1UxYVdDb2Q3VUJySi84VzhsaTZqS1lnUGxp?=
 =?utf-8?B?MEM4U1M2UlJEKzNlZ29BV2VjT0w5Yml6OFpFMXlLQ3hKN2RYMHFiSEkwV1dm?=
 =?utf-8?B?RVZXSmx1TzdMTTMvUTAxTVpzQjdBbkkycjRiNUwvbGxlT0VoOGZDK2g3c3p1?=
 =?utf-8?B?SDNZR2gwZ2x0b2M2UjlQSEtrd0VnNVNGdWhBUWdIVDUxRm9qb2s2T0RlZHEx?=
 =?utf-8?B?RTNseVNuRkV3dEp6M24vOWdPbDJMeGVDdDJYOVk4WDhaZWxDT09SOE5zRTB0?=
 =?utf-8?B?KzB3SDdiWGpLUEplN083MjFEL0FpYklRRUxZcDQ3N0ZHMVkvVDJQQS9PU252?=
 =?utf-8?B?V25hL2VqeERIVEFTNk1PZk1SNm51bktTRXk5QmRXaG0wOXNTTHlidDc3K3M3?=
 =?utf-8?B?Y0RLS0I5YWx1QTRib0hyb2NMd1crZ2dMcTIveGo2VDVRamhqbzZQU2Irc2hX?=
 =?utf-8?B?SFN1ODN2S3J0aTBZNnBZakVWOHFONy9wU21pcGlRa20vMlRTRThyeU1UREVF?=
 =?utf-8?B?VUhTNVY0Vm5lOGVtWFFBUXJEYTBHQkx4ZkYrQ0hETitRNVF5dFUyRDNBTDRo?=
 =?utf-8?B?ZjFzbkw0NWxLZ1haM3lqejljOTRuSUNWMlJjWTlBU3VlR25XaWlIdTJhcTlz?=
 =?utf-8?B?VFlhR3RKZjc2T3RsZTE2Y3MwL1ZMUTltODdydzZyVTNyZmlQWjExYm9uQ2JK?=
 =?utf-8?B?R2U5VTAxTVZLeHRwV1EzOEZzS1ZrZ2Fvc1ZJTk9la2hOV0NjaFRPbnl0TDBR?=
 =?utf-8?B?Zm45Wkp6OFNpL2VWU05yNEZZTlF2MnR1b0tZSTNlMWYxR2xnL0JQS3IrWER6?=
 =?utf-8?B?TlZVaTl0OGZrbHBZSWRPZGJGNENnNUJCdnIvbEpjLzZkK0Z2YWVZTmlkcCtF?=
 =?utf-8?B?OGlnaVkxMkV5NEZocWtQbEMzWTkyUFgxb0tnUjVINnR5c0xqUDNTOWpQUFZY?=
 =?utf-8?B?UEF1bzcwRlE0dDlIOHlhMUgxRk02VTZWSkRTM04xUldXVytyZ0JWUWFnNXR3?=
 =?utf-8?B?dzhveW9kRnloaGhRNEc3Rms0UjExOU5PVGpZNFkrM2RzcWdLSVVNMnhYUEkx?=
 =?utf-8?B?aVJQZmoxRUtybEVPcVE5VjVwNjdVTXlzM0x2UXZPVjFmZWxvTC9BM2U0b1pG?=
 =?utf-8?B?RXN5TUc0bUNFMXFFendRR0ZKUmhxSnJWcDN2RWxiMTVCaWhIcGQyZ2FjaWd6?=
 =?utf-8?B?WlAvZ3hLS2pqaTNhNCtDNjBlZ2ZtVTVIZVZSSmVkWUVTSWlOUnZLTGRhT2hG?=
 =?utf-8?B?QkM3b1lTcC9RSEM4SjR5SEtvWFRFdVIyRXJYR0xkUzJmYldDdUlTRlRlRlZU?=
 =?utf-8?B?cytoUVdzY0dpd1VDZFhwYlY2aUp5bkNqRzRwYVM2bXhtUkV2YmhkMXpoc3pR?=
 =?utf-8?B?Vjd6TXVlQ245M2IyYXh0Y1RZbmlOMGM1QU92T1lmdkNMUXpJaGNTdVpPMnVw?=
 =?utf-8?B?ZVJRSXc4K2M2ODZ2Vythdng1MldqcFdXUXNrUDN2QWxQV0orQ1FOUzcvemNO?=
 =?utf-8?B?a1AzZEI5TExBcGlLNTVxM0pnUER4SXd1SVpmL2lqa1NoQ3kzRHJtQzZOa1BB?=
 =?utf-8?B?NWhkMjF2bEswZlBISTBFNW1JK0U0TVlxOGVqcTlLK1EzOUtxTVFQUGhaZmNm?=
 =?utf-8?B?alc3V3kvTExiS2RKMEhJS2dUeHBsR2tpaGZIa1JIajhjaGxNSlR0eHo0T0NO?=
 =?utf-8?Q?fEfQHyMsw3hfvvG5VkeMKMQB4Bpo8QmLMIzlan3?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc1245d8-946e-476c-18c1-08d8f89c81dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2021 01:37:14.9376
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H1HkMgSqwN1TVbNhq93rbcAw/kmNvUhf+l+H+LvAE4lqyYVqy9tz3Fy7NGAE7kyaSHasB0MNk4BK6LYmheYKDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5308
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBIZWluZXIsDQoNClRoYW5rcyBmb3IgeW91ciBjb21tZW50cy4NCg0KPiAtLS0tLU9yaWdp
bmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBIZWluZXIgS2FsbHdlaXQgPGhrYWxsd2VpdDFAZ21h
aWwuY29tPg0KPiBTZW50OiAyMDIx5bm0NOaciDTml6UgMjI6MDkNCj4gVG86IEpvYWtpbSBaaGFu
ZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBhbmRyZXdAbHVubi5jaDsNCj4gbGludXhAYXJt
bGludXgub3JnLnVrOyBkYXZlbUBkYXZlbWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmcNCj4gQ2M6
IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGRs
LWxpbnV4LWlteA0KPiA8bGludXgtaW14QG54cC5jb20+OyBjaHJpc3RpYW4ubWVsa2lAdDJkYXRh
LmNvbQ0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBuZXQ6IHBoeTogZml4IFBIWSBwb3NzaWJseSB1
bndvcmsgYWZ0ZXIgTURJTyBidXMgcmVzdW1lDQo+IGJhY2sNCj4gDQo+IE9uIDA0LjA0LjIwMjEg
MTI6MDcsIEpvYWtpbSBaaGFuZyB3cm90ZToNCj4gPiBjb21taXQgNGMwZDJlOTZiYTA1NSAoIm5l
dDogcGh5OiBjb25zaWRlciB0aGF0IHN1c3BlbmQycmFtIG1heSBjdXQgb2ZmDQo+ID4gUEhZIHBv
d2VyIikgaW52b2tlcyBwaHlfaW5pdF9odygpIHdoZW4gTURJTyBidXMgcmVzdW1lLCBpdCB3aWxs
IHNvZnQNCj4gPiByZXNldCBQSFkgaWYgUEhZIGRyaXZlciBpbXBsZW1lbnRzIHNvZnRfcmVzZXQg
Y2FsbGJhY2suDQo+ID4gY29tbWl0IDc2NGQzMWNhY2ZlNCAoIm5ldDogcGh5OiBtaWNyZWw6IHNl
dCBzb2Z0X3Jlc2V0IGNhbGxiYWNrIHRvDQo+ID4gZ2VucGh5X3NvZnRfcmVzZXQgZm9yIEtTWjgw
ODEiKSBhZGRzIHNvZnRfcmVzZXQgZm9yIEtTWjgwODEuIEFmdGVyDQo+ID4gdGhlc2UgdHdvIHBh
dGNoZXMsIEkgZm91bmQgaS5NWDZVTCAxNHgxNCBFVksgd2hpY2ggY29ubmVjdGVkIHRvDQo+ID4g
S1NaODA4MVJOQiBkb2Vzbid0IHdvcmsgYW55IG1vcmUgd2hlbiBzeXN0ZW0gcmVzdW1lIGJhY2ss
IE1BQyBkcml2ZXINCj4gaXMgZmVjX21haW4uYy4NCj4gPg0KPiA+IEl0J3Mgb2J2aW91cyB0aGF0
IGluaXRpYWxpemluZyBQSFkgaGFyZHdhcmUgd2hlbiBNRElPIGJ1cyByZXN1bWUgYmFjaw0KPiA+
IHdvdWxkIGludHJvZHVjZSBzb21lIHJlZ3Jlc3Npb24gd2hlbiBQSFkgaW1wbGVtZW50cyBzb2Z0
X3Jlc2V0LiBXaGVuIEkNCj4gDQo+IFdoeSBpcyB0aGlzIG9idmlvdXM/IFBsZWFzZSBlbGFib3Jh
dGUgb24gd2h5IGEgc29mdCByZXNldCBzaG91bGQgYnJlYWsNCj4gc29tZXRoaW5nLg0KDQpUaGlz
IG9idmlvdXMgc2luY2Ugb25seSBhYm92ZSB0d28gZml4ZXMgd29yayB0b2dldGhlciBjYW4gdHJp
Z2dlciB0aGlzIGlzc3VlIGF0IG15IHNpZGUuDQoNCj4gPiBhbSBkZWJ1Z2dpbmcsIEkgZm91bmQg
UEhZIHdvcmtzIGZpbmUgaWYgTUFDIGRvZXNuJ3Qgc3VwcG9ydA0KPiA+IHN1c3BlbmQvcmVzdW1l
IG9yIHBoeV9zdG9wKCkvcGh5X3N0YXJ0KCkgZG9lc24ndCBiZWVuIGNhbGxlZCBkdXJpbmcNCj4g
PiBzdXNwZW5kL3Jlc3VtZS4gVGhpcyBsZXQgbWUgcmVhbGl6ZSwgUEhZIHN0YXRlIG1hY2hpbmUN
Cj4gPiBwaHlfc3RhdGVfbWFjaGluZSgpIGNvdWxkIGRvIHNvbWV0aGluZyBicmVha3MgdGhlIFBI
WS4NCj4gPg0KPiA+IEFzIHdlIGtub3duLCBNQUMgcmVzdW1lIGZpcnN0IGFuZCB0aGVuIE1ESU8g
YnVzIHJlc3VtZSB3aGVuIHN5c3RlbQ0KPiA+IHJlc3VtZSBiYWNrIGZyb20gc3VzcGVuZC4gV2hl
biBNQUMgcmVzdW1lLCB1c3VhbGx5IGl0IHdpbGwgaW52b2tlDQo+ID4gcGh5X3N0YXJ0KCkgd2hl
cmUgdG8gY2hhbmdlIFBIWSBzdGF0ZSB0byBQSFlfVVAsIHRoZW4gdHJpZ2dlciB0aGUNCj4gPiBz
dGF0PiBtYWNoaW5lIHRvIHJ1biBub3cuIEluIHBoeV9zdGF0ZV9tYWNoaW5lKCksIGl0IHdpbGwg
c3RhcnQvY29uZmlnDQo+ID4gYXV0by1uZWdvLCB0aGVuIGNoYW5nZSBQSFkgc3RhdGUgdG8gUEhZ
X05PTElOSywgd2hhdCB0byBuZXh0IGlzDQo+ID4gcGVyaW9kaWNhbGx5IGNoZWNrIFBIWSBsaW5r
IHN0YXR1cy4gV2hlbiBNRElPIGJ1cyByZXN1bWUsIGl0IHdpbGwNCj4gPiBpbml0aWFsaXplIFBI
WSBoYXJkd2FyZSwgaW5jbHVkaW5nIHNvZnRfcmVzZXQsIHdoYXQgd291bGQgc29mdF9yZXNldA0K
PiA+IGFmZmVjdCBzZWVtcyB2YXJpb3VzIGZyb20gZGlmZmVyZW50IFBIWXMuIEZvciBLU1o4MDgx
Uk5CLCB3aGVuIGl0IGluDQo+ID4gUEhZX05PTElOSyBzdGF0ZSBhbmQgdGhlbiBwZXJmb3JtIGEg
c29mdCByZXNldCwgaXQgd2lsbCBuZXZlciBjb21wbGV0ZQ0KPiBhdXRvLW5lZ28uDQo+IA0KPiBX
aHk/IFRoYXQgd291bGQgbmVlZCB0byBiZSBjaGVja2VkIGluIGRldGFpbC4gTWF5YmUgY2hpcCBl
cnJhdGENCj4gZG9jdW1lbnRhdGlvbiBwcm92aWRlcyBhIGhpbnQuDQo+IA0KPiA+DQo+ID4gVGhp
cyBwYXRjaCBjaGFuZ2VzIFBIWSBzdGF0ZSB0byBQSFlfVVAgd2hlbiBNRElPIGJ1cyByZXN1bWUg
YmFjaywgaXQNCj4gPiBzaG91bGQgYmUgcmVhc29uYWJsZSBhZnRlciBQSFkgaGFyZHdhcmUgcmUt
aW5pdGlhbGl6ZWQuIEFsc28gZ2l2ZQ0KPiA+IHN0YXRlIG1hY2hpbmUgYSBjaGFuY2UgdG8gc3Rh
cnQvY29uZmlnIGF1dG8tbmVnbyBhZ2Fpbi4NCj4gPg0KPiANCj4gSWYgdGhlIE1BQyBkcml2ZXIg
Y2FsbHMgcGh5X3N0b3AoKSBvbiBzdXNwZW5kLCB0aGVuIHBoeWRldi0+c3VzcGVuZGVkIGlzIHRy
dWUNCj4gYW5kIG1kaW9fYnVzX3BoeV9tYXlfc3VzcGVuZCgpIHJldHVybnMgZmFsc2UuIEFzIGEg
Y29uc2VxdWVuY2UNCj4gcGh5ZGV2LT5zdXNwZW5kZWRfYnlfbWRpb19idXMgaXMgZmFsc2UgYW5k
IG1kaW9fYnVzX3BoeV9yZXN1bWUoKQ0KPiBza2lwcyB0aGUgUEhZIGh3IGluaXRpYWxpemF0aW9u
Lg0KDQpQZXIgbXkgZGVidWdnaW5nLCBNRElPIGJ1cyBzdXNwZW5kZWQgYmVmb3JlIE1BQywgSSB0
aGluayBpdCBpcyBhIGNvbW1vbiBiZWhhdmlvciwNCnNvIFBIWSBodyBpbml0aWFsaXphdGlvbiBp
cyBhbHdheXMgY2FsbGVkLiBEb2VzIHRoaXMgYmVoYXZpb3IgYmUgc3lzdGVtLWRlcGVuZGVudD8N
Cg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQo+IFBsZWFzZSBhbHNvIG5vdGUgdGhhdCBt
ZGlvX2J1c19waHlfc3VzcGVuZCgpIGNhbGxzIHBoeV9zdG9wX21hY2hpbmUoKSB0aGF0DQo+IHNl
dHMgdGhlIHN0YXRlIHRvIFBIWV9VUC4NCj4gDQo+IEhhdmluZyBzYWlkIHRoYXQgdGhlIGN1cnJl
bnQgYXJndW1lbnRhdGlvbiBpc24ndCBjb252aW5jaW5nLiBJJ20gbm90IGF3YXJlIG9mDQo+IHN1
Y2ggaXNzdWVzIG9uIG90aGVyIHN5c3RlbXMsIHRoZXJlZm9yZSBpdCdzIGxpa2VseSB0aGF0IHNv
bWV0aGluZyBpcw0KPiBzeXN0ZW0tZGVwZW5kZW50Lg0KPiANCj4gUGxlYXNlIGNoZWNrIHRoZSBl
eGFjdCBjYWxsIHNlcXVlbmNlIG9uIHlvdXIgc3lzdGVtLCBtYXliZSBpdCBwcm92aWRlcyBhIGhp
bnQuDQo+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5n
QG54cC5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L3BoeS9waHlfZGV2aWNlLmMgfCA3
ICsrKysrKysNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKQ0KPiA+DQo+ID4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3BoeS9waHlfZGV2aWNlLmMNCj4gPiBiL2RyaXZlcnMv
bmV0L3BoeS9waHlfZGV2aWNlLmMgaW5kZXggY2MzOGUzMjY0MDVhLi4zMTJhNmY2NjI0ODEgMTAw
NjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvcGh5L3BoeV9kZXZpY2UuYw0KPiA+ICsrKyBiL2Ry
aXZlcnMvbmV0L3BoeS9waHlfZGV2aWNlLmMNCj4gPiBAQCAtMzA2LDYgKzMwNiwxMyBAQCBzdGF0
aWMgX19tYXliZV91bnVzZWQgaW50DQo+IG1kaW9fYnVzX3BoeV9yZXN1bWUoc3RydWN0IGRldmlj
ZSAqZGV2KQ0KPiA+ICAJcmV0ID0gcGh5X3Jlc3VtZShwaHlkZXYpOw0KPiA+ICAJaWYgKHJldCA8
IDApDQo+ID4gIAkJcmV0dXJuIHJldDsNCj4gPiArDQo+ID4gKwkvKiBQSFkgc3RhdGUgY291bGQg
YmUgY2hhbmdlZCB0byBQSFlfTk9MSU5LIGZyb20gTUFDIGNvbnRyb2xsZXINCj4gcmVzdW1lDQo+
ID4gKwkgKiByb3VudGUgd2l0aCBwaHlfc3RhcnQoKSwgaGVyZSBjaGFuZ2UgdG8gUEhZX1VQIGFm
dGVyIHJlLWluaXRpYWxpemluZw0KPiA+ICsJICogUEhZIGhhcmR3YXJlLCBsZXQgUEhZIHN0YXRl
IG1hY2hpbmUgdG8gc3RhcnQvY29uZmlnIGF1dG8tbmVnbyBhZ2Fpbi4NCj4gPiArCSAqLw0KPiA+
ICsJcGh5ZGV2LT5zdGF0ZSA9IFBIWV9VUDsNCj4gPiArDQo+ID4gIG5vX3Jlc3VtZToNCj4gPiAg
CWlmIChwaHlkZXYtPmF0dGFjaGVkX2RldiAmJiBwaHlkZXYtPmFkanVzdF9saW5rKQ0KPiA+ICAJ
CXBoeV9zdGFydF9tYWNoaW5lKHBoeWRldik7DQo+ID4NCg0K
