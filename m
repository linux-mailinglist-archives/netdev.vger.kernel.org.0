Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C88635BA3B
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 08:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236485AbhDLGmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 02:42:13 -0400
Received: from mail-vi1eur05on2082.outbound.protection.outlook.com ([40.107.21.82]:26502
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229524AbhDLGmN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 02:42:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HwCWqDoG9hfczqGP56k7K+9k1i5lZbUQxQAsClWW7IFiQIfCIXoPuPdFZhQV6Aq6GWrmmys5xQWE3XfXOG1KP11sHYqoTT4OA7/PzrMv+BQmmjGoPdxqsYj8yYLvOJgSlGseK7UP2VS1S4Dh4S4F31/ekjgKUj8TTL7vRCnOPmD2lDVA159ykEoruMvUjH6HDPvlrpqUTTvCIStLP75ODKCJRt2i5lz/8CiuOIjXzsF1KGenxBMdImMg/x3Qwd+LD3m+F5IDeRxOFbCG4q+wk80/VJFsZbmH3usFn87rSjiwLbr0srq5a4OsTz05ZLv5mGM+jc0UQbJz69psvzeWrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3IYT7Gbi/++HaofBy+zmdUdARfTxuXYrq2dRfCxO0F8=;
 b=jHtrWLtN3r9y71nn5sAamwIYaDWjUTzMtjc4QOY5HYCE5HGZ55I0PgzUmvcsqlO1DJZCyi0Kr41dzjnOycVRLoEPJck4cMr5UWwc9vPyd5sUQk0fUxR7pmJ7bDs+X1gcWucX/voUkx9LFs3VhtZ/veLJ1ilDj7Q57vq/wPmY8WzG+7A2SbqHyAzAo6fmG/Ud6jIDkW8j2zCR6n4/OxNlpnFjloPa3PJ/crYJLLAXX0MAvDm71PPB0thCCzC9jD3tw9R9O3zZ9AP2Qou44XGJTS5l8IVvtV8d6qRX/WFKRB9nmAu6cvhdSXRPW1VEZqRXDUwtc6Rrik2+rf4XIZ/jIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3IYT7Gbi/++HaofBy+zmdUdARfTxuXYrq2dRfCxO0F8=;
 b=ZoocpvP2J+2LwDQpbUBafGAv+g2sSnyoUbg9UzNpfr5Eu3o3wvB/mmLACk4WIND3aWypt7tAaU0exs9Q0455CWDlISrA/zMUqYxEiFfQLdMoxSbBslsIGao6chih8L8593iUwY5+dUPp0ynhRN2B9cdJCGaCzq2gDlfFNgmP0eY=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB5852.eurprd04.prod.outlook.com (2603:10a6:10:b0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Mon, 12 Apr
 2021 06:41:53 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%6]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 06:41:53 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "frowand.list@gmail.com" <frowand.list@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH net-next 0/3] net: add new properties for
 of_get_mac_address from nvmem
Thread-Topic: [PATCH net-next 0/3] net: add new properties for
 of_get_mac_address from nvmem
Thread-Index: AQHXLR/LYQp902HohUWyFWlxX3MAy6qshkWAgAPsX1A=
Date:   Mon, 12 Apr 2021 06:41:52 +0000
Message-ID: <DB8PR04MB6795C3C71F4884B5CA5AA78DE6709@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210409090711.27358-1-qiangqing.zhang@nxp.com>
 <20210409114341.1ed508d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210409114341.1ed508d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 826c401b-a5c9-45f9-c7dc-08d8fd7e0ee5
x-ms-traffictypediagnostic: DB8PR04MB5852:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB58525E6AF368FF6AD138CAEEE6709@DB8PR04MB5852.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XzJC/oIaRZG6V3/s6s7wJG41csR5/w3Bg7HFwImUd9/Yji2wukA/82hMkO0j5bY6xvw5eu84GUS8gLiVKkYZp9qGU5wHlUKfHe2XD8KHSfGzrTycH0UvJmf3nuGRyRphGOO7M0K7xbmBF5cl/beE9N6BHOh0gHVD/Nn+We6FEIxAFXNlyqefjlYn/b2Yr8wAB35g69Yd+MKXZQ8Wvq6ak9ZakSMa2Mr93ACDBhqv4zv8QOqWcxz+d8LyYgB7KEiQFhR+efdmGCLJaFyy8hsKv2b5TTs4yxmbEOmopoItwCefU3xvkqF/Hr3IoUduYuGt+jrwp9I3bVewSiNCTr0aio8d3feYOSw456H1hZx2VYmH/TPpvnEm4TuIUpsg3QujbwRiEXpW8YDEftFRFt/ASFWLGiKcu12LkvbL9tQajqwGcsOrRygAtIlikMtbAgMrV6QGL18Sdkk/GcGr61DlXKC7gS34gXSogvps04CNipFDMc8ZWlkSRF8MrrQy4iMMK6K4xY82zltYdZqwi6n4yntSrw1qR9d9kJpawAMSj0JWOJGYGxC72n2x51254niUYWr8ciSRP2+HAOSU/AGlkwRPLGw+tmAKbTVzgZgM1bY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(396003)(39850400004)(136003)(26005)(38100700002)(33656002)(186003)(52536014)(83380400001)(8676002)(6506007)(2906002)(66946007)(53546011)(8936002)(66476007)(66446008)(71200400001)(7696005)(55016002)(5660300002)(86362001)(64756008)(66556008)(7416002)(9686003)(4326008)(54906003)(316002)(6916009)(76116006)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?QWtkWXUvd0t3Z0ZTNlAyb2lubkFOOGM3b2UrbVVMU2JmVTF1cG5MYW54MVVN?=
 =?gb2312?B?QnByeWhrNFNNRmRwaGxURyswUVNuYzQ5YndEZGdNMURpQjRLbGlOSnpqY3Fp?=
 =?gb2312?B?L3dwRHZBT3MrOFZBTHJ0YjdsY1EyQlB4cnJBWWl2SWZpdlFoZTAyMENXSCsv?=
 =?gb2312?B?VXZSZ2hOQ2xhTDA1b2lkVHRnTHNFZmlKeHVQZlVyUTI4TmtDMWNPZ2RJNWll?=
 =?gb2312?B?OHdzcURiVEpIYXpLOWcvb3BReFIvcXR3V3A1L3lhc09sSWZKOFE5blpYNEpZ?=
 =?gb2312?B?VGRRSW5rcW9SWmZUdm9XWlMwSUZ0OG84K0NFNlRtNU8zdXQwWmVJdzNwMjlB?=
 =?gb2312?B?cnBNL3NYb3Nlb3hhVm96ZTZNdDc0N3lPVlprVDZpVnU4T0NGdFZmdElIK1JM?=
 =?gb2312?B?UTIyL1BwTWNQZ0NBcFNLUjFXSGNPWURSVk5zQzdjdWpZTERHSkVBeEc1Sjkz?=
 =?gb2312?B?UlJHOGZZSXJxT2pIcCt2U2NnSVhaQnB6bzdsRjYwRUNKU1JuK3AvMmRzcWxs?=
 =?gb2312?B?czA5MWtrd1A5SGkrc0F6TDJ6VVRvMXpCcDU4QldncmRGUjdYa0tEV0FkODBk?=
 =?gb2312?B?ZUQxam5VK0lMbk1WSzdnWlZQaTZvcndKVW51RmFJRTQ1Z1hDS3lkeGREcTFz?=
 =?gb2312?B?T2ZETFlhcVNURUhWZEVwTkx3ZFNUVGsvOWVvN0I3UndkcFVWODE5VWg4YStL?=
 =?gb2312?B?dlVBT0tjN0VjQXNoRU1aejlEbzZiblNvL1dXYzdPeHZLWmJyUG5nay9KU2tj?=
 =?gb2312?B?T1lidkRCQ2dPSFlBOHdLdytVWXFKQ2hHTnVWbmkzSWV4ajFXakJab2Q2bWs2?=
 =?gb2312?B?K2VIQm1UUkw1ZnF1MmN2QWNUdjViR1JEd0NHVFoyZ0w5RFk2cTlXVkFINGZk?=
 =?gb2312?B?R0o1RzExVTlWdlBsai9XNjdWdXZJYXhFd2lXd0Z5MVZ6UklxWUdoM2xySEI2?=
 =?gb2312?B?MGlOTVcweDY0ZzRlTEpZdW55WS9NZmJSdWJ6MzBJU2pZSFQ4cEt1NURBZm03?=
 =?gb2312?B?TDVjOHJjVU00UWh1RmRZSkFrTEZzd3ZEMmhHZDU5UEZ6Ny90UklObW9PMndM?=
 =?gb2312?B?UkVCZXRLaDB3T3ZiL3BvZDZyT3VuV1FwMWJlbC9GdFYyVDZmUmkzakgzY3g5?=
 =?gb2312?B?OWNja2FVblZyczAxUnh6VC9TYXhsek1jZ3R4Z29UMHR4aEJmL29LQ2RWYWpP?=
 =?gb2312?B?WmJucjNTdUxOTEtJblovR2NlSUhUUTF0N1d1YzRsbWljMEMxL2VIbTFHOElo?=
 =?gb2312?B?WVpxNFpWSjgrZlFaUU5RRUpobWVWcW0zcnJSOUFqYWJXakpiNEJiRS9HSkFO?=
 =?gb2312?B?RHJqeFdqSTB5VFVPTXFRM3B3WUZ4RHRReTZvS0daemlMbGsrWGM0Skc1YkxG?=
 =?gb2312?B?UitRUm0yN3B1Q1UrOEhwT0VGdmZOWWZEYTJDRjZUNCsyUWhYcFd2SHpWL2or?=
 =?gb2312?B?c24vbTI4c2Z2T2daZUl1L2p2aGwrdVM0MW1ZYjh0eEtmN3FFUlJIbnJqWm01?=
 =?gb2312?B?SUViNk9JV2EzeWFrNjF3SUZtc1JEQ2xoUExwaENUaUtoRUpxWkpIcThUaHk3?=
 =?gb2312?B?WitOQW1lOExjZ3o5RXB3bldEV1RvZW5wRlZRdEhIN3MzNFVHOTVsZ3BMQjRL?=
 =?gb2312?B?RGhHZjR2V0s2SW5KdDgzOFNvaXg1TzFiQUs4OHptV0RncC9ySExNYjRDK0k0?=
 =?gb2312?B?WW1aTmNMSGlhLzB4NUNvVHVGSWJIMGVjK1Y1bC9yTWZzU2tJZVR5b3R3RmRu?=
 =?gb2312?Q?xduEmRKmhAdjlCU8GCPPx/yvPw/PwLwnlZNcJ1L?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 826c401b-a5c9-45f9-c7dc-08d8fd7e0ee5
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2021 06:41:52.9138
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V9eLwaKRQrI9SVDna2VExwH29A6LddOK1zqIDH/DGFpF2tHV4cne/dLBRMqDJfoCRYVNZHYsk+kkBrPgBAYL1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5852
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBKYWJ1aywNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKYWt1
YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPg0KPiBTZW50OiAyMDIxxOo01MIxMMjVIDI6NDQN
Cj4gVG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+DQo+IENjOiBkYXZl
bUBkYXZlbWxvZnQubmV0OyByb2JoK2R0QGtlcm5lbC5vcmc7IGFuZHJld0BsdW5uLmNoOw0KPiBo
a2FsbHdlaXQxQGdtYWlsLmNvbTsgbGludXhAYXJtbGludXgub3JnLnVrOyBmcm93YW5kLmxpc3RA
Z21haWwuY29tOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkZXZpY2V0cmVlQHZnZXIua2Vy
bmVsLm9yZzsNCj4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgZGwtbGludXgtaW14IDxs
aW51eC1pbXhAbnhwLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCAwLzNdIG5l
dDogYWRkIG5ldyBwcm9wZXJ0aWVzIGZvcg0KPiBvZl9nZXRfbWFjX2FkZHJlc3MgZnJvbSBudm1l
bQ0KPiANCj4gT24gRnJpLCAgOSBBcHIgMjAyMSAxNzowNzowOCArMDgwMCBKb2FraW0gWmhhbmcg
d3JvdGU6DQo+ID4gVGhpcyBwYXRjaCBzZXQgYWRkcyBuZXcgcHJvcGVydGllcyBmb3Igb2ZfZ2V0
X21hY19hZGRyZXNzIGZyb20gbnZtZW0uDQo+IA0KPiBBcGFydCBmcm9tIGFkZHJlc3NpbmcgUm9i
J3MgKGFuZCBwb3RlbnRpYWxseSBvdGhlciBjb21tZW50cyB0byBjb21lKSBwbGVhc2UNCj4gYWxz
byBtYWtlIHN1cmUgdG8gcmViYXNlIGJlZm9yZSBwb3N0aW5nLiBUaGlzIHNlcmllcyBkb2Vzbid0
IHNlZW0gdG8gYXBwbHkgdG8NCj4gbmV0LW5leHQuDQoNClRoaXMgcGF0Y2ggc2V0IGNhbiBiZSBh
cHBsaWVkIHRvIGxhdGVzdCBuZXQtbmV4dCBicmFuY2gsIHRoZSB0b3AgY29tbWl0cyBhcyBiZWxv
dywgbm90IHN1cmUgd2hlcmUgaXMgdGhlIGlzc3VlIGZyb20sIHNvcnJ5Lg0KNWI0ODlmZWE5Nzdj
IChvcmlnaW4vbWFzdGVyLCBvcmlnaW4vSEVBRCkgTWVyZ2UgYnJhbmNoICdpcGEtbmV4dCcNCjky
N2M1MDQzNDU5ZSBuZXQ6IGlwYTogYWRkIElQQSB2NC4xMSBjb25maWd1cmF0aW9uIGRhdGENCmZi
Yjc2M2U3ZTczNiBuZXQ6IGlwYTogYWRkIElQQSB2NC41IGNvbmZpZ3VyYXRpb24gZGF0YQ0KDQpC
ZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCg==
