Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF5144D6C2
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 13:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbhKKMsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 07:48:22 -0500
Received: from mail-db8eur05on2043.outbound.protection.outlook.com ([40.107.20.43]:50528
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232033AbhKKMsU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 07:48:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CqqWC/fqByXoV4Ety57GXryfpjh/Bcg9MOmwivBhRa6Y7Qm6v/AVSlLymjdNLBoudSK5OuJonmHjlo2jaM59L/KKJ86qs3eoOAwfUPX2ay11Cbpcjjeyf1X8koXI0xRCrRfANfGHX9CD0rCyKrGMeF9dPhGBEwjgrFztRLJUWQOLJIwcoKTj9Ugn6ULkYLbbKmYARa89sVxo2ifPTdr8YQJhbDgApKJv2yYuXDO2QFOr9ycUw9kfrRlONX2QRUl0enGLdg3HcZT8qdkhnvpbssZSb2ESX0eDlG6D3xDZCrnc/lqJr7lLcoicXI3pu0VIjEtvj8bD4RmjAvSZWrYRKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cYfM8SWKChENtPqC3tNrQiEHgE0Oibel7c2daCMnFgc=;
 b=PBXQeqK+Oocv3/nA3j1hDM6zRRp0H3oEOJ9pACTxhb7foZ3UHnM0EknSJ8viJTah2lrt/fI49pZmAkQC69Ew123HDwSuvEVnOCwWljD3SDGLmYY9u8+lFRHgvX1kyStKrBdHlaT+6LXVKEfVgwJZtXkJn7tulIcJguoZVsU/nkCNLcXm0MMv8+Iui+j2PYkBlkgckz+DFtRmXQeetJ0i+np3SpsU9J7FmhgZzfNZhxmXM7/jeDJBsgqxA0dbh95pe0PfCCFe9ppRHNFcX3ul8/Y4AHAQ55tQ83z/G/7EmKI7aGBCwufOcxFeewTu0nBgXRhqoezea2LPzvpOLoflKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cYfM8SWKChENtPqC3tNrQiEHgE0Oibel7c2daCMnFgc=;
 b=YxIrd3VjGxMLVgkrROGjy/oK0NelvKG0V3rlI/uo+S0ktFOUkgR8f6kHvMP2oFkpjYkWyv3u3SuRih6K1/trhDrJXeCnclpkmq5Na/HOXSpVPqM9r44ZFlHSVtnvC3aB9zG9ymxDx20gfHc5PZj+ameBv1XUoVw5Y8i0IrTW3ok=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5694.eurprd04.prod.outlook.com (2603:10a6:803:e0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Thu, 11 Nov
 2021 12:45:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4669.016; Thu, 11 Nov 2021
 12:45:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [RFC PATCH net-next 1/6] net: dsa: make dp->bridge_num one-based
Thread-Topic: [RFC PATCH net-next 1/6] net: dsa: make dp->bridge_num one-based
Thread-Index: AQHXyoZHNP2OAoYzNE6Mu95HQgPLg6v+WS6AgAAFxwA=
Date:   Thu, 11 Nov 2021 12:45:28 +0000
Message-ID: <20211111124528.2tecc3hoslheswl3@skbuf>
References: <20211026162625.1385035-1-vladimir.oltean@nxp.com>
 <20211026162625.1385035-2-vladimir.oltean@nxp.com>
 <a84ee210-b695-c352-8802-5b982d4037d5@bang-olufsen.dk>
In-Reply-To: <a84ee210-b695-c352-8802-5b982d4037d5@bang-olufsen.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fbb56833-331f-410c-5276-08d9a5112434
x-ms-traffictypediagnostic: VI1PR04MB5694:
x-microsoft-antispam-prvs: <VI1PR04MB5694FD306408E3F6E1D7D584E0949@VI1PR04MB5694.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4EygdYO7fge/KqsGaRgLY5G6/KFxJZ/k7kcTNAzDa7gT62bufRpp4jFUzwkC3THM5lGcy+WPjiuJUKbuRjnLiHDEnCTu1BJxxzLm6panokMUFLdqoTgDaglQz6/TC75Sf1sLJe6/Sic/IBC4AGM+Try2IrPXfEF+iJrR4QWu8Gon2DENUrGAh4PK4qoW0wFAIzId3NjegmSlTLDiKg1dh+5Q0Kn10zPZj+qUGZ5/1OgHfaTAMzWADSlYbdVqahlcJg7XSS+XntTBTY8eAbsZCeRAudy2E/2tpXixIFH6lan3QAeuKgXuSMLRNeH3JAULxxeoxlVkivbKHI9dwuaPD4FXThmMHBq7cFXJBKsI0l6qWgf+45BsqKWVOx4iG1R2tSvpI9Rf172HTodt5Td6TmqtEBCo0yJYxpQLCp8RkspARE/Dyy2sc//MJSDtChYb+5O+9ueUOz3kOgyTod6u+Ivlhmrmbxp2N4n2CWm4UQI586Pk2aQbYkZoz6NJdh9zQ3qCHVyDDMLuByV0vI7oWOscWI/llVWQiJt9nI37ozWlhdjagSojiM2MOHQFQ95Dnn+9Q7O6NJOq88qof2DNhy/3T1JGmNxaZPR7xtKvbgI7qCDKhzPFIRlGKYpxA3oRzTYF4yEbwV0foAstdHrjcHRXpSmQ0cwDbD1dxS0+mXhQ8bvUUmLwq9pDhSuO3ToIk/x9x4U+EuZ9xQ+0dCZrVg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(33716001)(6506007)(8676002)(26005)(1076003)(508600001)(66476007)(8936002)(71200400001)(6486002)(54906003)(2906002)(6916009)(38070700005)(316002)(5660300002)(6512007)(4326008)(53546011)(9686003)(44832011)(66574015)(83380400001)(76116006)(186003)(66946007)(66446008)(122000001)(86362001)(66556008)(38100700002)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cXlLTGFyVGpMMFRoWEV3ZDNYNW5wbmRJVXUzbERQbElXcjhMYStVVGp3NUdZ?=
 =?utf-8?B?WFBQS0ZjTUJEVENCd2lXQnpORSt4QTN5cGZpU0o2Q1RWSVV6ajdWVjBheTZT?=
 =?utf-8?B?VzlQZzZOQmx0bWZqZXV1djhkMFlZM2cvdTQzY0tpNlRqWkx2aDZWaFVROWc0?=
 =?utf-8?B?a1J4VmNaVXVwbHFZdnZvL1dMR24rQ3U1RUpnTkVYU0lEWTNWSStyQ3VvVUFk?=
 =?utf-8?B?TUJZZEdZVnBCQ2h4TTRRdTZ1ZWltZm8vd2taaE9sMDVUSGdON3ZxMzVtUlNn?=
 =?utf-8?B?clNDaG5DMGlneGdEUG8zZURRMkdGR3NFZnFOdUprNG9CZ0NCOWhJdi9lN1V4?=
 =?utf-8?B?RG1pM3gwU2ZJcmc0U2hwOUxmT3JHQkp2RS9JeWpkajVEaklZTWIvZGZ2U0hu?=
 =?utf-8?B?UnJ4ZmpnYlBwUlAzUll3RVcrRzRUaXJzUXIvb25KODRrNXJiL2x3SkNqc1pr?=
 =?utf-8?B?K1VYYnBYQ0s0UVBKTXUyckpJOHJDZEQvaVBXTEV6eDFhNFpuaHlWZUtPYmRh?=
 =?utf-8?B?Y1RZa0lLYzFRcHlTT3RYQ2RBU204Zy9rQlIrdzNxazVIWmtNUTQ2L1hNSXox?=
 =?utf-8?B?b1FSTFB4SDEzcEQyWERnQXRFVVM3U1ZNdjg0enQrbGVLYkkvZlNQNkhKRkxr?=
 =?utf-8?B?OWNGRWpHRm9iclJKUC8vVUJPbEhnQjRpZXZIeXFndDBReFZPcHJFMXVYejVU?=
 =?utf-8?B?ZmVCclA5RVF0MFpuMkU2OGphb2pxN0FlaTJPN0FudTNwSU96VTdWanZQNkNi?=
 =?utf-8?B?K3NsZkt1N1JJUzlDZDdQbFh2SnNVdmRmWGxIWXY0SUI1Q2s2NjI2aVZsR3Ix?=
 =?utf-8?B?Q1lseXBuZjFtSlFXaGtuRENvWURicFRsblpmUWNvYWxmZkdHNlJQRjd0TWhr?=
 =?utf-8?B?RmdVQ2gvT3RwTlQyWURKYUhMaDBVc0Q3dzJ2U211Vk9oRXlOOWlOZHBMN1Fu?=
 =?utf-8?B?Y3J2M1EvOXBlSFdLWGhDWkhJQWYvTXJ6SVN2b0tjS3ZXMHVzZzNId2NmM0tl?=
 =?utf-8?B?VmJYcE1lSEZVUjJoNXAyNS9ueVc2QVBiSHArR21rWXpySnR5RGw4UVlGdjNu?=
 =?utf-8?B?eXRiT1c2VE9jVXk3MEVaWnl5SFNPdWxhcUQ0T2E5eW5PUk4rOHF1R2RnbU4r?=
 =?utf-8?B?aDBZSjhRNjg2VnhmYzNKQkJCUHl3RVFxUVZEVVU5TmpYRC9PbUlSeklnaXpC?=
 =?utf-8?B?eG4xTkJYa2J3MzhvRmt2R0lUUDNpRWtSZ3Jsay9IZm5lTWZDY0tsejNCZUJz?=
 =?utf-8?B?RVh5SGdjNUpxZG1ibElhYm1lNS9LTVZSOWptZlc2amJIM2o3eGhyTTMwZi83?=
 =?utf-8?B?cmhZNHQ1d0V4R3RFcS9vT3hDTTRsckhtdWs0V1gvQ2lQOTN4M3haSk91T003?=
 =?utf-8?B?NWgrK1pzcUkvWmVhRUhFdkJsbHY5RGhNUDJwY3NiSjJxZDhFYWxSVU1QSTU2?=
 =?utf-8?B?M2RBN2JxS3F2TDVUWjU1UUd0YUd2R3VNYU9pbVJsRVhVT3B5cEFLa09tZC9q?=
 =?utf-8?B?U0s4cUlLWDU5T0N3Qjk2UDFMa2lBeG92cE44RWNlTGdRNHhGaGMxalVIdkE1?=
 =?utf-8?B?Qmw2M2NJc3h4a1RCS3dyWmJmZmV1UHdpcG0rREU5V3hKNno4VGRGOWdWQzIz?=
 =?utf-8?B?cmZFbzIzdmNTY0YvUTBZQzlJVWZ3OGlUeGRiY2VNUHVDM1dqeVNqODhTNjhP?=
 =?utf-8?B?aTVlVUpNdGlLY0RYYVNPOTBNd0VwM1ZsS0RHVms3blZlU2NkNGNHdktwNkk4?=
 =?utf-8?B?aUlFMDJtQnhsT3ZoQXZab1E4YzIyanNUYjBENWQ4T2RhRDc1Mlg3VEVWR1do?=
 =?utf-8?B?dHdMb1pyOFZIeFh1TVBHSzBiWnNyUlhNa2l5OUJSM2hqNGlTY0NQRnJJQ1lK?=
 =?utf-8?B?S0Y3dUVNWkhka0o3T1VYTHlvVnUwMGhCdngrRkNkN3Q0cHkvcThpSkNtclVV?=
 =?utf-8?B?ZzZVK0xpUE9OV2dxUWh5OW1Id2t1MzZTTlFHNnNMaW9nVUlic0Q4NnhKRnky?=
 =?utf-8?B?Z3BINnV3Y1dXTFN5Q3JiSm9CTHF4eFJXQkduNWhCdUJ5Qy9MOWFFWXB1V3cy?=
 =?utf-8?B?b0krUDQyaGRYQjZzbW81NzhrQ0dZdjZxcjU1VnpIRUx6L3V3Sy9MT2dXb05n?=
 =?utf-8?B?cElMUzV3NzRPQk1tZXgwWmRhdS9xS2xzUVAraUM4aFBIVU9jYVpqN2xTT01O?=
 =?utf-8?Q?xsvks+u+Jjf0b4cZbTQwJ14=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <12E76041081F2B4AA796615DF252FDB1@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbb56833-331f-410c-5276-08d9a5112434
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2021 12:45:28.9142
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FwdzvdO39LcNYIspHrOG9C+sIJOtBIZYOxmmSygEJWvChbP14/skj600yN7hUpaQJf2dD8FaL8JLZEdJZl9GvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5694
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCBOb3YgMTEsIDIwMjEgYXQgMTI6MjQ6NDdQTSArMDAwMCwgQWx2aW4gxaBpcHJhZ2Eg
d3JvdGU6DQo+IE9uIDEwLzI2LzIxIDE4OjI2LCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6DQo+ID4g
SSBoYXZlIHNlZW4gdG9vIG1hbnkgYnVncyBhbHJlYWR5IGR1ZSB0byB0aGUgZmFjdCB0aGF0IHdl
IG11c3QgZW5jb2RlIGFuDQo+ID4gaW52YWxpZCBkcC0+YnJpZGdlX251bSBhcyBhIG5lZ2F0aXZl
IHZhbHVlLCBiZWNhdXNlIHRoZSBuYXR1cmFsIHRlbmRlbmN5DQo+ID4gaXMgdG8gY2hlY2sgdGhh
dCBpbnZhbGlkIHZhbHVlIHVzaW5nICghZHAtPmJyaWRnZV9udW0pLiBMYXRlc3QgZXhhbXBsZQ0K
PiA+IGNhbiBiZSBzZWVuIGluIGNvbW1pdCAxYmVjMGYwNTA2MmMgKCJuZXQ6IGRzYTogZml4IGJy
aWRnZV9udW0gbm90DQo+ID4gZ2V0dGluZyBjbGVhcmVkIGFmdGVyIHBvcnRzIGxlYXZpbmcgdGhl
IGJyaWRnZSIpLg0KPiA+IA0KPiA+IENvbnZlcnQgdGhlIGV4aXN0aW5nIHVzZXJzIHRvIGFzc3Vt
ZSB0aGF0IGRwLT5icmlkZ2VfbnVtID09IDAgaXMgdGhlDQo+ID4gZW5jb2RpbmcgZm9yIGludmFs
aWQsIGFuZCB2YWxpZCBicmlkZ2UgbnVtYmVycyBzdGFydCBmcm9tIDEuDQo+ID4gDQo+ID4gU2ln
bmVkLW9mZi1ieTogVmxhZGltaXIgT2x0ZWFuIDx2bGFkaW1pci5vbHRlYW5AbnhwLmNvbT4NCj4g
PiAtLS0NCj4gDQo+IFJldmlld2VkLWJ5OiBBbHZpbiDFoGlwcmFnYSA8YWxzaUBiYW5nLW9sdWZz
ZW4uZGs+DQoNClRoYW5rcyBmb3IgdGhlIHJldmlldy4NCg0KPiBTbWFsbCByZW1hcmsgaW5saW5l
Lg0KPiANCj4gPiAtaW50IGRzYV9icmlkZ2VfbnVtX2dldChjb25zdCBzdHJ1Y3QgbmV0X2Rldmlj
ZSAqYnJpZGdlX2RldiwgaW50IG1heCkNCj4gPiArdW5zaWduZWQgaW50IGRzYV9icmlkZ2VfbnVt
X2dldChjb25zdCBzdHJ1Y3QgbmV0X2RldmljZSAqYnJpZGdlX2RldiwgaW50IG1heCkNCj4gPiAg
IHsNCj4gPiAtCWludCBicmlkZ2VfbnVtID0gZHNhX2JyaWRnZV9udW1fZmluZChicmlkZ2VfZGV2
KTsNCj4gPiArCXVuc2lnbmVkIGludCBicmlkZ2VfbnVtID0gZHNhX2JyaWRnZV9udW1fZmluZChi
cmlkZ2VfZGV2KTsNCj4gPiAgIA0KPiA+IC0JaWYgKGJyaWRnZV9udW0gPCAwKSB7DQo+ID4gKwlp
ZiAoIWJyaWRnZV9udW0pIHsNCj4gPiAgIAkJLyogRmlyc3QgcG9ydCB0aGF0IG9mZmxvYWRzIFRY
IGZvcndhcmRpbmcgZm9yIHRoaXMgYnJpZGdlICovDQo+IA0KPiBQZXJoYXBzIHlvdSB3YW50IHRv
IHVwZGF0ZSB0aGlzIGNvbW1lbnQgaW4gcGF0Y2ggMi82LCBzaW5jZSBicmlkZ2VfbnVtIA0KPiBp
cyBubyBsb25nZXIganVzdCBhYm91dCBUWCBmb3J3YXJkaW5nIG9mZmxvYWQuDQo+IA0KPiA+IC0J
CWJyaWRnZV9udW0gPSBmaW5kX2ZpcnN0X3plcm9fYml0KCZkc2FfZndkX29mZmxvYWRpbmdfYnJp
ZGdlcywNCj4gPiAtCQkJCQkJIERTQV9NQVhfTlVNX09GRkxPQURJTkdfQlJJREdFUyk7DQo+ID4g
KwkJYnJpZGdlX251bSA9IGZpbmRfbmV4dF96ZXJvX2JpdCgmZHNhX2Z3ZF9vZmZsb2FkaW5nX2Jy
aWRnZXMsDQo+ID4gKwkJCQkJCURTQV9NQVhfTlVNX09GRkxPQURJTkdfQlJJREdFUywNCj4gPiAr
CQkJCQkJMSk7DQoNCkkgd2lsbCB1cGRhdGUgdGhpcyBjb21tZW50IGluIHBhdGNoIDIgdG8gc2F5
ICJGaXJzdCBwb3J0IHRoYXQgcmVxdWVzdHMNCkZEQiBpc29sYXRpb24gb3IgVFggZm9yd2FyZGlu
ZyBvZmZsb2FkIGZvciB0aGlzIGJyaWRnZSIuIFNvdW5kcyBvaz8=
