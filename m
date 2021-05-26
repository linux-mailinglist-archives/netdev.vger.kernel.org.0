Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F8D390E2B
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 04:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbhEZCIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 22:08:21 -0400
Received: from mail-vi1eur05on2075.outbound.protection.outlook.com ([40.107.21.75]:31521
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232916AbhEZCIT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 22:08:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZXWxLQ2iKk7vuh+DeZqFXtzdWah/lg8EHqiYKf+aqZE8eBnpxMnNdTgFOVix2ynOFFi8CRip4Ey7mhqDkWMvraONripbFq3Y87v9wErnOKO6ok2wgAbjJHK8tpaz/uDvncpY69NuXm1As1iKmVcIy17L11R026cHuibyGurj6kmvKnOnP5P67pDR9g+ErRI7lvvebXZECvu5LukPILp2vmF4GJYN2pjCOCzbxTTNhxkBBo1e7cNYGhj3PhU8/QbFd0MQE8Ys1UE21p4tNbgO3nIrqM7fr/DTaVdeURP6MxNRQkdzin4y3mI8zCwYL9Lbb0JC73du3Ng8UO8G6WsPcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lAqDNFWP9Dt2U8uVMAjMdUl/QM9kiG40KId3YbA7vcw=;
 b=YeiAt2xKUhif5p1WEZipFecmMLgHYQuZYdar7/rImxNmV8PX9C+sAVvwrZ0eGHNjtOYFf8MoUjJEEKsq3m4Bij45OCQ7uCvDbGMO84KGgVf1YodieQB2B2SVu66seJncGN6+IOWKd69LX9gSrcRC8wysl3/w/kREMmqqAc3RlAI/6oW55qj0/rRfCYb0g9TpaEWSPvgNO6GernUkxFmis6T2URk7quzkfF7GEE6MKCIrL+aChr1oLXLT/nr0+foF63xGxhz5ttHLoUhavCjC+RnBOM2R4jvq7yE9Pm/3rOMeHB2kxCPLsyiB+wCoouql6+O+u7wl78WC0waoUMuN/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lAqDNFWP9Dt2U8uVMAjMdUl/QM9kiG40KId3YbA7vcw=;
 b=QASpwI6eIz3af8ps2ikptcb3zgFHTezG+OOPkLPW9r1XXZhb9SwRkurFPV6+DQnURms5hAWUhJKH3BG2e/k+zTZrZlrLqXnreJOkDy8igWx+3jJW+xj2j+k74acPdDhd3XyW0c00/fUenalzJGCuHFrWQ/d/OoN9qIuE1qCxUuw=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4780.eurprd04.prod.outlook.com (2603:10a6:10:1c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Wed, 26 May
 2021 02:06:46 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4150.027; Wed, 26 May 2021
 02:06:45 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "frieder.schrempf@kontron.de" <frieder.schrempf@kontron.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [RFC net-next 2/2] net: fec: add ndo_select_queue to fix TX
 bandwidth fluctuations
Thread-Topic: [RFC net-next 2/2] net: fec: add ndo_select_queue to fix TX
 bandwidth fluctuations
Thread-Index: AQHXT708BKGTZN/11k693vD2JZ2LfqrxJUUAgAJjs/CAALOVgIAAv4rQ
Date:   Wed, 26 May 2021 02:06:45 +0000
Message-ID: <DB8PR04MB6795791CE3D45D49B7FEB84BE6249@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210523102019.29440-1-qiangqing.zhang@nxp.com>
 <20210523102019.29440-3-qiangqing.zhang@nxp.com> <YKpqtK7YBVFnqRSw@lunn.ch>
 <DB8PR04MB67957EA8964DB8CE625F6CFFE6259@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YK0Ce5YxR2WYbrAo@lunn.ch>
In-Reply-To: <YK0Ce5YxR2WYbrAo@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ad485463-f0cc-4889-0022-08d91feaea1b
x-ms-traffictypediagnostic: DB7PR04MB4780:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB47802125E8CB2AAFC03CA22DE6249@DB7PR04MB4780.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o0iKt4MHWJgEHB8KxyPrKtvRLBxXAlZkfn38eQ7zjkjWezMFRyWp8KxvCq/4US7aVquf/Meok1ziG1m9wtdIEvE6Ftuf8tWfCv5micsMg6G19IZxa1WoBFRoSKfB5jjy5m7/7RGWY48qwORQ22feL5DHg19FtIPMofaq33MWU/036dDa/Jj2VZoDLHCKJbV4neMN7EELpovqZPiI5SawkrPVRjRMrc9UEyUqmwANzLr9O9PlS2gc9tCQhXuaZvDV8w/8Hem7HWbb3JaNJUvSSuIqL2YcRZzeGFENky6YbMU+mnBVcgc2oaSj+W3oO1nj7U+LjHZwDkxvtl4gM/ZkJeC3ZF6h+1FqOb6+lcxa8KzUiZVyazth9lB03DS+0J2zxYZvpwV8z7HOAAY9Z80cOYKwi1fZcSHj9uuUTM4qF0PG1En1ay3XsoJEGBbta50rAUXpW4qu4Yridj5Awib/h+jaRY7EC8qiGqLeu8se5Gn252LL5hmlw9gyz+lVPwLFVj05+UOSTE97CAxt23zdrj/mveDLaU5WzNpWYgg2wqeuDumefcg1xfVUbrUr5ywsYS69PSN9NTVzzDrnle0YNn2DTYiPv/2y+GQ3NZ18Ikcd2rUbaenUsSw0JcZYvyCTjxb5plN2pQCjWI6xIhvhu3k4s/lGZOvkE0qym+fvs9tP2xacd6Nsf85Jhj29aPGo4Ag6dW1gGP/lNfm98QAovA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(966005)(4326008)(5660300002)(71200400001)(45080400002)(55016002)(66946007)(54906003)(83380400001)(186003)(8676002)(2906002)(52536014)(66556008)(498600001)(64756008)(76116006)(26005)(33656002)(9686003)(6916009)(86362001)(53546011)(38100700002)(7696005)(122000001)(66446008)(8936002)(66476007)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?NC82NUozOHZNZ1hsdnlubDJXaFB6SUVYcU5MWUxMZTQ2d1V6ak5qaXNvcTNG?=
 =?gb2312?B?R0lIRzh4QnVsS1JXVkZhOVE5SHI5MDBmSzdxKytuNng1bUFLN1FBL2djZ2li?=
 =?gb2312?B?S1IyR0V6YnhKRjdYL3BtYUlCUXNEYS80dDMyalFVTStnWE5jdngrWXluMGR2?=
 =?gb2312?B?UEVFeitoeTlMNlV5d1hueXdBN2R0a1kzS093UW42dXoyZ1ZNNm96a0ZjYlFn?=
 =?gb2312?B?TXkxVmNrU2xocFZlMHdrbjFuNGhsR0tpZVhBL1VNMGNPeU1hLzRxM0lpVk1W?=
 =?gb2312?B?elUzS0tKb3pYZXVPSEFGL3NPNFVGenFBOHQ5UHlqczhXRlJpV2xIaVg4MUM4?=
 =?gb2312?B?eVhHcFhQUGVuZlNLQUlQQ1RDc08xUy9jeE14My9GMWlPR01lZjVxdm5OZll5?=
 =?gb2312?B?MEwzdkRNdjV5Tk1sNitDdEkrUUZxQU1jSFJrSTNLWUFpVTdwZHJ0eGxpU0xx?=
 =?gb2312?B?VkJqTDVpaHRDRWY5US9tRzZNOGdkZ2FidUxvalA0bE1pT084RU9rK2hxRTZD?=
 =?gb2312?B?dXM3L2FNVVJkb2Z1TjVlSk1kbkw0T01rTXNzUmlORmdTNmdIemtZaGlQQW1T?=
 =?gb2312?B?QU1ZTlJkbUw5cHIxL3RXN0oyYnRaSTlKWlVseU4zME5iZ3pheDQyOS9sMUFP?=
 =?gb2312?B?VTNDckQ5NlRhNW1lL0IxVHJjSzFMb2Rvai9qWWxiMTc5bjExRENiTnZNdW9h?=
 =?gb2312?B?SnNnTzVxVHR2VlQvVDVEUDVRVmxtWm5rcW45eTdMYVAwaW5EMGJ0NUdhZnp4?=
 =?gb2312?B?STJYcGEvdUlFOUoxWnorblVHY2ZDaGo2ZU5sTkk5SWQ4eFRiR2dOcmtXdU1h?=
 =?gb2312?B?Ni9id294czdqNVRneGJObjcyL3UxSlNYRE1ldW84YjVCRmdyS1dkNFFobUpX?=
 =?gb2312?B?MU96SjFmdDVXaGRzMzFNYmhnWGExSmZzY2VuR293VGM0eHpKVG4wRENGZFNR?=
 =?gb2312?B?RXQrdUJiREMvczlrL011Y2J2aThDekp3Vjk0R1VvOFZUTGt6amo5Z1dzYmhU?=
 =?gb2312?B?SnlNem8xVWk2YkV1eHVGZEYyZFNEU2xZOThoRStVU2pwNFM2dDNmUkhrQXJD?=
 =?gb2312?B?Tk9NSzhJT0xzTklLUS9NN2M0QlcrVHNteHJ6UVNwSVYxZTFCcFJPZU9jVmdQ?=
 =?gb2312?B?cWwwbnNXS013MlFYSWtjeGE2VUtYUFFmTitTT3AwenlSaVExOWNEM0RydC9j?=
 =?gb2312?B?bnl2RG9aNkF1QXpIUGNuVGtHNUYrbE9QalI0a3lLQXVwZnVlSmZOenMyVnpu?=
 =?gb2312?B?aXhBdE9lMXh2aG5nNzM2UElWSFNEeG9WOVg1L2s2RDFOcHhiaTkrbEVYNGZZ?=
 =?gb2312?B?cUwwSzczMGtjNGNSU1kxZUQrbE85dTM1UHpzTkxsbWprd0ZoS1E0NXR2cWZK?=
 =?gb2312?B?ZlVtREw4eUpnSXh6cG5LRG5iRk05VTg0SzFWdSt1TTdmMGlzUXhsMUx6QUNB?=
 =?gb2312?B?clBiQ2EvOE1ZRTN0dkwwclN6MnNxalEzeVJtMDZ6Wld6V1ZXdzBSRCtCYTBV?=
 =?gb2312?B?UlZhVlVmaVk4RHErdG5kckcvTXZtNyszYTYyVlREOWIwV2ovcXpJL0VIUkxw?=
 =?gb2312?B?cUhHUmtCMzhWY0VmVTdIQWdxSzNSOEh5ZWhlbjl6cFlSNDBtODUrKzQ0blBQ?=
 =?gb2312?B?MzRaWjM4NElJUlZDSGQ4M2RldFFBUmw3bXNyby96WnBTaFhLQ2F5MmhGZWpD?=
 =?gb2312?B?VlBUWVIrdVFRMk1oMFFzLy8vMkZhSXFFdnBGeGVJUlV2Z2JxZklBNlpER0xV?=
 =?gb2312?Q?Wgw6simv4PCVsyFskqui9CTTnBo4ao5a99VG3oY?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad485463-f0cc-4889-0022-08d91feaea1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2021 02:06:45.8608
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HWkmpHK4XbFNJcb7ImZjkOUYQ1d1dHdTmOtBq1Rtkb0+ik83JOuHHawVN7NDHj2TFSkWgxg+ADDL3YDja7GmTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4780
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBBbmRyZXcsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQW5k
cmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPg0KPiBTZW50OiAyMDIxxOo11MIyNcjVIDIxOjU4DQo+
IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiBDYzogZGF2ZW1A
ZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOyBmcmllZGVyLnNjaHJlbXBmQGtvbnRyb24u
ZGU7DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmc7IGRsLWxpbnV4LWlteA0KPiA8bGludXgtaW14QG54cC5jb20+DQo+IFN1YmplY3Q6IFJlOiBb
UkZDIG5ldC1uZXh0IDIvMl0gbmV0OiBmZWM6IGFkZCBuZG9fc2VsZWN0X3F1ZXVlIHRvIGZpeCBU
WA0KPiBiYW5kd2lkdGggZmx1Y3R1YXRpb25zDQo+IA0KPiA+ID4gT24gU3VuLCBNYXkgMjMsIDIw
MjEgYXQgMDY6MjA6MTlQTSArMDgwMCwgSm9ha2ltIFpoYW5nIHdyb3RlOg0KPiA+ID4gPiBGcm9t
OiBGdWdhbmcgRHVhbiA8ZnVnYW5nLmR1YW5AbnhwLmNvbT4NCj4gPiA+ID4NCj4gPiA+ID4gQXMg
d2Uga25vdyB0aGF0IEFWQiBpcyBlbmFibGVkIGJ5IGRlZmF1bHQsIGFuZCB0aGUgRU5FVCBJUCBk
ZXNpZ24NCj4gPiA+ID4gaXMgcXVldWUgMCBmb3IgYmVzdCBlZmZvcnQsIHF1ZXVlIDEmMiBmb3Ig
QVZCIENsYXNzIEEmQi4gQmFuZHdpZHRoDQo+ID4gPiA+IG9mIHF1ZXVlIDEmMiBzZXQgaW4gZHJp
dmVyIGlzIDUwJSwgVFggYmFuZHdpZHRoIGZsdWN0dWF0ZWQgd2hlbg0KPiA+ID4gPiBzZWxlY3Rp
bmcgdHggcXVldWVzIHJhbmRvbWx5IHdpdGggRkVDX1FVSVJLX0hBU19BVkIgcXVpcmsgYXZhaWxh
YmxlLg0KPiA+ID4NCj4gPiA+IEhvdyBpcyB0aGUgZHJpdmVyIGN1cnJlbnRseSBzY2hlZHVsaW5n
IGJldHdlZW4gdGhlc2UgcXVldWVzPyBHaXZlbg0KPiA+ID4gdGhlIDgwMi4xcSBwcmlvcml0aWVz
LCBpIHRoaW5rIHdlIHdhbnQgcXVldWUgMiB3aXRoIHRoZSBoaWdoZXN0DQo+ID4gPiBwcmlvcml0
eSBmb3Igc2NoZWR1bGluZy4gVGhlbiBxdWV1ZSAwIGFuZCBsYXN0bHkgcXVldWUgMS4NCj4gPg0K
PiA+IEkgdGhpbmsgY3VycmVudGx5IHRoZXJlIGlzIG5vIHNjaGVkdWxlIGJldHdlZW4gdGhlc2Ug
cXVldWVzIGluIHRoZSBkcml2ZXIuDQo+IA0KPiBTbyBxdWV1ZXMgMSBhbmQgMiBhcmUgbGltaXRl
ZCB0byA1MCUgdGhlIHRvdGFsIGJhbmR3aWR0aCwgYnV0IGFyZSBvdGhlcndpc2UNCj4gbm90IHBy
aW9yaXRpc2VkIG92ZXIgcXVldWUgMD8gVGhhdCBzb3VuZHMgb2RkLg0KTm8sIHdoZW4gZW5hYmxl
IEFWQiAoY29uZmlndXJlZCBhcyBDcmVkaXQtYmFzZWQgc2NoZW1lKSwgcXVldWUgMCBpcyBiZXN0
IGVmZm9ydCwgcXVldWUgMSBpcyBsaW1pdGVkIHRvIDUwJSBiYW5kd2lkdGgsIHF1ZXVlIDIgaXMg
YWxzbyBsaW1pdGVkIHRvIDUwJSBiYW5kd2lkdGguDQpJIG1heSBtaXN1bmRlcnN0YW5kIHRvIHlv
dSwgd2hhdCBJIG1lYW4gaXMgdGhhdCB0aGVyZSBpcyBubyBzY2hlZHVsZXIgZnJvbSBzb2Z0d2Fy
ZSBsZXZlbCwgTmV0IGNvcmUgY2FsbHMgbmV0ZGV2X3BpY2tfdHgoKSB0byBzZWxlY3QgYSBxdWV1
ZS4gRnJvbSB0aGUgaGFyZHdhcmUgbGV2ZWwsIHNjaGVkdWxlIHdpdGggQ3JlZGl0LWJhc2VkLg0K
DQo+ID4gQ291bGQgeW91IHBsZWFzZSBwb2ludCBtZSB3aGVyZSBJIGNhbiBmaW5kIG1hcHBpbmcg
YmV0d2VlbiBwcmlvcml0aWVzIGFuZA0KPiBxdWV1ZXM/IFlvdSBwcmVmZXIgdG8gYmVsb3cgbWFw
cGluZz8NCj4gPiBzdGF0aWMgY29uc3QgdTE2IGZlY19lbmV0X3ZsYW5fcHJpX3RvX3F1ZXVlWzhd
ID0gezEsIDEsIDAsIDAsIDAsIDIsIDIsDQo+ID4gMn07DQo+IA0KPiBodHRwczovL2V1cjAxLnNh
ZmVsaW5rcy5wcm90ZWN0aW9uLm91dGxvb2suY29tLz91cmw9aHR0cHMlM0ElMkYlMkZlbi53aWtp
cA0KPiBlZGlhLm9yZyUyRndpa2klMkZJRUVFX1A4MDIuMXAmYW1wO2RhdGE9MDQlN0MwMSU3Q3Fp
YW5ncWluZy56aGFuZyUNCj4gNDBueHAuY29tJTdDMzBkOTc1ZjA5YTc5NDQ2MDMwZDYwOGQ5MWY4
NTJjMzklN0M2ODZlYTFkM2JjMmI0YzZmYQ0KPiA5MmNkOTljNWMzMDE2MzUlN0MwJTdDMCU3QzYz
NzU3NTQ3OTA5NzA1MzkyMCU3Q1Vua25vd24lN0NUV0YNCj4gcGJHWnNiM2Q4ZXlKV0lqb2lNQzR3
TGpBd01EQWlMQ0pRSWpvaVYybHVNeklpTENKQlRpSTZJazFoYVd3aUxDSlhWQw0KPiBJNk1uMCUz
RCU3QzEwMDAmYW1wO3NkYXRhPWc2V3hKSlZYTGJhWDNRV0JxM3lCNGZrMVpoNHROJTJGZjhZDQo+
IHclMkZBQVRhYkwlMkJnJTNEJmFtcDtyZXNlcnZlZD0wDQpFcnIsIHRoaXMgbGluayBpc24ndCBh
dmFpbGFibGUgYXQgbXkgc2lkZS4gSXQncyBzZWVtcyA4MDIuMXEgc3BlYy4NCg0KPiBJJ20gbm90
IHN1cmUgaSBhY3R1YWxseSBiZWxpZXZlIHRoZSBoYXJkd2FyZSBkb2VzIG5vdCBwcmlvcml0aXNl
IHRoZSBxdWV1ZXMuIEl0DQo+IHNlZW1zIHRvIG1lLCBpdCBpcyBtb3JlIGxpa2VseSB0byB0YWtl
IGZyYW1lcyBmcm9tIHF1ZXVlcyAxIGFuZCAyIGlmIHRoZXkgaGF2ZQ0KPiBub3QgY29uc3VtZWQg
dGhlaXIgNTAlIHNoYXJlLg0KSGFyZHdhcmUgeG1pdHMgd2l0aCBDcmVkaXQtYmFzZWQgc2NoZW1l
Lg0KDQo+IFBDUCB2YWx1ZSAwIGlzIGJlc3QgZWZmb3J0LiBUaGF0IHNob3VsZCByZWFsbHkgYmUg
Z2l2ZW4gdGhlIHNhbWUgcHJpb3JpdHkgYXMgYQ0KPiBwYWNrZXQgd2l0aG91dCBhIFZMQU4gaGVh
ZGVyLiBXaGljaCBpcyB3aHkgaSBzdWdnZXN0ZWQgcHV0dGluZyB0aG9zZSBwYWNrZXRzDQo+IGlu
dG8gcXVldWUgMC4NCk1ha2Ugc2Vuc2UuDQoNCj4gQWxzbywgaWYgdGhlIGhhcmR3YXJlIGlzIHBl
cmZvcm1pbmcgcHJpb3JpdGlzYXRpb24sIFBDUCB2YWx1ZSAxLCBiYWNrZ3JvdW5kLA0KPiB3aGVu
IHB1dCBpbnRvIHF1ZXVlIDEgd2lsbCBlbmQgdXAgYXMgaGlnaGVyIHByaW9yaXR5IHRoZW4gYmVz
dCBlZmZvcnQ/DQpJIGRvbid0IHRoaW5rIHNvLCBDcmVkaXQtYmFzZWQgc2NoZWR1bGVyIHdvdWxk
IHNjaGVkdWxlIGJhc2VkIG9uIGNyZWRpdCwgbm90IHRoZSBQQ1AgZmlsZWQuDQoNCkJlc3QgUmVn
YXJkcywNCkpvYWtpbSBaaGFuZw0KPiANCj4gICAgICBBbmRyZXcNCg0K
