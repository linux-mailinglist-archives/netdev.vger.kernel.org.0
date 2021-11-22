Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6A704587ED
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 03:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233997AbhKVCLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 21:11:37 -0500
Received: from mail-eopbgr70042.outbound.protection.outlook.com ([40.107.7.42]:11236
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229906AbhKVCLh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Nov 2021 21:11:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RURtTBmYDH9/YaW91mYDPd1bdKgWf52E57RWad5QKQHji9z1QicS0oTvTIjKHzJNshaGkbq8apRuGsbZWK3IUzowNG0dcvanJFRUVYCLTqS3RbQFZKv8XkGMixYMbgGIi0cxulRcAdqFb3SyvLRKIryx+1L77XSaKL8qCs3r1/i6yrJtkU/aenWZfZSYKTlRr/gJEXpNHt/1h7KHcIRClwLckF1vd/8SNNlN2oz5aN2+TKPby8E71yG4Js5zlfLQBfG46t4JArpjbSr1v4gnTnwe8xFUl3nxeMh+arFoIzfgss40xQpizB5U+Lsl0E5rWQA6CCYtFuFeRzOJ7uBieg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wmefjtc6a/6L9R+0VJbO11pUoVuBfWmC+ucfvjPR0Jc=;
 b=NStCanDLhJPxiMdfZL8uJTbd8WKDwEIlj4XyKoWceh2vowfliVCrC0KH5KQNdr43Sz4/esrAk9d3IKEf37jiugtxNEUU/3Tw77Eerul/J8FbISKwdbFOS1+1wHVT/kmj1xI0psmn7GPRLDbLCuNM1fhhlM8k0x2J5+OgOR854VVgdUoeClZPoaJjfTD3d24eTfBfznhBp7E5J0VyvmgGoxQ8emliaf4BW9syH46E/SihTF6fvNikrUnldW6+qFUGmHZdY1JHIYydHljc5lCqyHzdSpV7MWND/do+Za5Q7m5ONWg1WQGIkoSp5FBswzFxgThybNF4vW1TBIbL860WJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wmefjtc6a/6L9R+0VJbO11pUoVuBfWmC+ucfvjPR0Jc=;
 b=XroG/O3UkvfBAHpT/aAqpmWoNdBhWwkf0GP3R8LMmPEpuvxEcG9lFJyiofdl3dqrwt1pBF+o59aWfc2FC6vHznf4hpws3TNqM2H6bIS7ZsLxQ1SyyX/KKhD1pmuPqntcpWLErotOcrhJnu0ggvQPM7a8WomgdusaAzqZeWEkMj8=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB9PR04MB8429.eurprd04.prod.outlook.com (2603:10a6:10:24e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Mon, 22 Nov
 2021 02:08:29 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::c005:8cdc:9d35:4079]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::c005:8cdc:9d35:4079%5]) with mapi id 15.20.4713.024; Mon, 22 Nov 2021
 02:08:29 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Peng Fan <peng.fan@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
CC:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Aisheng Dong <aisheng.dong@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 4/4] arm64: dts: imx8ulp-evk: enable fec
Thread-Topic: [PATCH 4/4] arm64: dts: imx8ulp-evk: enable fec
Thread-Index: AQHX3gYXWhk163Jeb029MpXmsNmzhawMidaAgAIz44CAABCdwA==
Date:   Mon, 22 Nov 2021 02:08:28 +0000
Message-ID: <DB8PR04MB6795270E9F852F33300C0D24E69F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20211120115825.851798-1-peng.fan@oss.nxp.com>
 <20211120115825.851798-5-peng.fan@oss.nxp.com> <YZkTkagrQ/zafYEQ@lunn.ch>
 <DU0PR04MB941710123952E0D448A1B38E889F9@DU0PR04MB9417.eurprd04.prod.outlook.com>
In-Reply-To: <DU0PR04MB941710123952E0D448A1B38E889F9@DU0PR04MB9417.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 933b5453-c6e0-4bf8-8f76-08d9ad5cf9e1
x-ms-traffictypediagnostic: DB9PR04MB8429:
x-microsoft-antispam-prvs: <DB9PR04MB8429C25B93301126756AAD0DE69F9@DB9PR04MB8429.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k1nj27C7X39h8nkdYzkoOPmFFOdI0Ddrm+wHjOgAWeDF/T50bIg99dgSUbSg3LonMoqhPD4rpNyCSzK8OsF698K15ormGTWQ1NMURfgq4NjHb/FEBEAQg1EX1dREPu5+B+gthrZWLVzl4G0BiiS2bQ5qkZLHEhXSW6LoEiVjJVIWcul3kmufVfcvuBRIvuv/ukLb67IKFsxtVan+ouKVVoeYjoFNLOOft0IFTeJ7o9pDuViNggyfcTeMdhWcBjJX4+c/Jri9fTZrhp8/YVXezfHTYB3B/PdeHjmKL+8Yvz8MJE91OPRPtHLqQXWPiG20SEIf3YHMZ72eo8SVzCicsZYaGLOtFFDRYslNfp/fwetdmG//8tYqkFFr3hpOWQvDPj9OPZKU3RLM7RsrJpE7ww+CfC7pQQh40XA+KrFBmRZvSS0jsploW9z6eN1aK8CVwfs7w8k6Bauk+GPFZfEvHk8xioi8sljsynRWjQfojiQKt6XGFrjtuBc9OFem9jaEQ8YdKzYxfbD1tBt0o81vhm7lifqY0WZYQfCTSWaAhYdzp4Xy7lCEtlmyqXpQlqhdn4PWS8epeXPPx03q4Hmn5u97DIinteSY6YeoeIVsOHmLz0sJB3mPiAK4kybq7jB3es14suufuMgCHQ7ijsFkQJH0Fm20adVSwD+mAqr2dxHY6tgXfRK5dS2kAnVO71D3XCwRj/OJugMRHAz6E0HXEw3Qp5XVoCiMboM3l/GIOQY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(6506007)(53546011)(66946007)(110136005)(316002)(55016002)(7416002)(7696005)(9686003)(5660300002)(76116006)(54906003)(2906002)(66556008)(71200400001)(66446008)(66476007)(64756008)(122000001)(4326008)(83380400001)(38100700002)(186003)(52536014)(8936002)(38070700005)(508600001)(26005)(33656002)(8676002)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?TEh4MFBnaDVZditaMmFDTmNIVVhYYU1LeVBFKzVwcnprVjJSM3lmREl5R2hH?=
 =?gb2312?B?UHVBYUxlUS9MNHZKT3NWZjhnZ3JOQnkwdlpoWGt5TnZxOTRXM3dXbyt2R0pK?=
 =?gb2312?B?b0pXT0J0MlJ1MkFCVEZVZFMwdlZvMmVxMEJvWDN1c1Jsdm9uQ29HMTRNVGtl?=
 =?gb2312?B?Z2JkWEpuc25oc3lBNi8zWGNtTUhyci8yQVhDOHFXWVVMUmRsWW01K0JvSHBy?=
 =?gb2312?B?cW9hYjZDR29mNVRVT3R4alJETmJ4RWplRUYwQ282Z252UDhhV041aDNMdDQr?=
 =?gb2312?B?ME5jV3k3VmkrL2ZMMWplNjFtWC8wZ0g0YnRtNEZPVVdoYkxxVW9SRkc5OTlM?=
 =?gb2312?B?WFZiU1JuVS9seFNJaHFkRVpMZ2Z1V0VvVnN4eTlDUW1sZzMrYm01QVVKaEd6?=
 =?gb2312?B?bUhpSVhyUHV2a3RNQXB4ZUJIN3ZrNk5EcmZabWd4cjNVL25oUFNWdWFJWlV3?=
 =?gb2312?B?MnVnYjhRWU9ENUNqTCtvWjk4NjY1WHl0WlB5dzk1ZGFNdnlzWFR1QWJvVmdE?=
 =?gb2312?B?d2trT3BnWnBQS0hwbnN2elJFRCt2dThWYUNNd2dhRGtESW8vcnNvZG9TVXJE?=
 =?gb2312?B?NEkrM1BzSEVkZHl0czZNNUt6U1ZxMG13VkdudHRIRExyVFV6VzUweVdmQ2lE?=
 =?gb2312?B?RlBLOHRPdTRoaWd4THZXSXhkYTdSZ215WVZveFlUOWdMcEVVZzc2TFNDNHZM?=
 =?gb2312?B?U3dXRnRITlFjYVZQSXZxeTAvcnB0QW9GcklBK213MEZqbUY3OTFSdmsvR0s3?=
 =?gb2312?B?Y3B3bkJJQnoyRUVSdXJkSkhQSnNCSEg3emlCUmtJL21rNFJ0MytQbTZIbEQz?=
 =?gb2312?B?Q2dtYnVXblErYnVKOUdiQkdibmpHSjZ2T0hJTW5QNGZoZWVpQlcySXlROTd1?=
 =?gb2312?B?WnVJQjNpTHRzRXNtaFFZV2VOdEVlYk1PcHFvZWM3cmNpT3BlSFBMcU1zSnRJ?=
 =?gb2312?B?bTZTdFA4ckhJQURaWGh3SkJ1Q29HQ092ME01QnFyVjMxT0lGWDJORDJEcWRs?=
 =?gb2312?B?TlprdnYwakdaaUIxandsSVY0NGQraUlEcjM2Z1ZYSFNNYTlBM3FKQ2U3ckhp?=
 =?gb2312?B?VVF6RjZRUStiOG1QM0E1dXRqcnBhclJudmp4azgrWGFQSDllTmFMemppYkNK?=
 =?gb2312?B?ZUpBTENSbG00T2pqQTIzWDNYYUxYcGdrMFdac0lFYmdpVGJFRFJ6NFhySURy?=
 =?gb2312?B?ZWovcjRTZG1PN0svdlg4clIwOFFaM3pINlV5dTlieG96cnk1MEJrdGRoVkgx?=
 =?gb2312?B?QW9JdDNYRmErU09odFNhNkxKb0tKWjVpUENkcHd0cEhRajVOREdOOGI3MUhZ?=
 =?gb2312?B?VUZ5MlJLKzBEODNnUVhwVGZkMk1TMllseWNPc1BjQXdGajA1ZWVhUGxYU1Fk?=
 =?gb2312?B?OG8wN2dWN25OdWRlU05pNkRUTkJ4S1Vzc1V3OHZCSUFnYVBMY3ZGaXVZUmZV?=
 =?gb2312?B?bkpSQ2FmaFVlTDBYUlNPYjFNQ3kzV3ZFU1ZMcTFKVHNUZ3lsUTI4MHpMR216?=
 =?gb2312?B?L2t3eTJFVnl2aUludGVxNVQ1TnRPRWgyYUlvNzhPM0UycGVLSjFSYzlKS3ZE?=
 =?gb2312?B?YXBieC9IL3I1dnQxSlhvek9PRHVFRE1YcXFBYXlxdzVDbkVxamROUHZ5YnAx?=
 =?gb2312?B?aldTanMrVmFSNWJGS0NNcGh6d2JzYUdkWTB1UmFOVjZjQmhjWk1NNGtWNG1Q?=
 =?gb2312?B?R0VLODNVNjhJVEhmd1RIQzJjZnQrcEdWRHlIMnJaMmtxcXdYc05GeFVoNnF0?=
 =?gb2312?B?cHVLcGZ4N0hwa1E3TkpmRWxpbE40R1RDeWdPUkg3SmVPVlFjMmg0bTlwQVpn?=
 =?gb2312?B?bjhyQm1FTmdtTllXNlhMVFBraUlJR3AzRksySHA1WS9FRlQ2VkFDVnVIQ1ht?=
 =?gb2312?B?L2hVUVNoeUFFZExRSG5nVTYrbkNUZnZPdUYvdFNaYkNtSXU4dk5VTStoRnNP?=
 =?gb2312?B?WnFMT21tNVNTTDJCTFRZRnM3TFZDOTRHZ2hsdXk0SzFNQXYzY1o3WTh6TWJN?=
 =?gb2312?B?MVFxVVZQL00zdlgwMGpNOWtZUzNkdTB2VWl0R2NMRmNnVG5qc2pZWEZyZjh6?=
 =?gb2312?B?a0Z4VDZBdXlJM0ZaaTRNZE95b1hNd0M3ZzVPb0cwYWFuajNmWlFZV1VncGR0?=
 =?gb2312?B?V2hndVFjTmk5TFJsK0RTeFFHanh3Mm1VTmxHOGpOV3MvZzVMb25TdE4wMFFJ?=
 =?gb2312?B?V0E9PQ==?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 933b5453-c6e0-4bf8-8f76-08d9ad5cf9e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2021 02:08:28.9306
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5b7Na0elaihN7Nt2BlXkL4ZRFIWAi4G3Z5R/w5FDgTu/smZYtPiyCy++S8z2+nHJQDDTAk2mi0BgMcdcv0Rlww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8429
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBQZW5nLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFBlbmcg
RmFuIDxwZW5nLmZhbkBueHAuY29tPg0KPiBTZW50OiAyMDIxxOoxMdTCMjLI1SA5OjA0DQo+IFRv
OiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+OyBQZW5nIEZhbiAoT1NTKQ0KPiA8cGVuZy5m
YW5Ab3NzLm54cC5jb20+DQo+IENjOiByb2JoK2R0QGtlcm5lbC5vcmc7IEFpc2hlbmcgRG9uZyA8
YWlzaGVuZy5kb25nQG54cC5jb20+OyBKb2FraW0NCj4gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0Bu
eHAuY29tPjsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsNCj4ga3ViYUBrZXJuZWwub3JnOyBzaGF3bmd1
b0BrZXJuZWwub3JnOyBzLmhhdWVyQHBlbmd1dHJvbml4LmRlOw0KPiBrZXJuZWxAcGVuZ3V0cm9u
aXguZGU7IGZlc3RldmFtQGdtYWlsLmNvbTsgZGwtbGludXgtaW14DQo+IDxsaW51eC1pbXhAbnhw
LmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+IGRldmljZXRyZWVAdmdlci5rZXJuZWwu
b3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1hcm0ta2VybmVsQGxp
c3RzLmluZnJhZGVhZC5vcmcNCj4gU3ViamVjdDogUkU6IFtQQVRDSCA0LzRdIGFybTY0OiBkdHM6
IGlteDh1bHAtZXZrOiBlbmFibGUgZmVjDQo+IA0KPiA+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggNC80
XSBhcm02NDogZHRzOiBpbXg4dWxwLWV2azogZW5hYmxlIGZlYw0KPiA+DQo+ID4gPiArJmZlYyB7
DQo+ID4gPiArCXBpbmN0cmwtbmFtZXMgPSAiZGVmYXVsdCI7DQo+ID4gPiArCXBpbmN0cmwtMCA9
IDwmcGluY3RybF9lbmV0PjsNCj4gPiA+ICsJcGh5LW1vZGUgPSAicm1paSI7DQo+ID4NCj4gPiBJ
cyB0aGlzIHJlYWxseSBhIEZhc3QgRXRoZXJuZXQ/IE5vdCAxRz8NCj4gDQo+IE5vdCAxRy4gaXQg
b25seSBzdXBwb3J0IDEwTS8xMDBNIGV0aGVybmV0Lg0KPiANCj4gPg0KPiA+ID4gKwlwaHktaGFu
ZGxlID0gPCZldGhwaHk+Ow0KPiA+ID4gKwlzdGF0dXMgPSAib2theSI7DQo+ID4gPiArDQo+ID4g
PiArCW1kaW8gew0KPiA+ID4gKwkJI2FkZHJlc3MtY2VsbHMgPSA8MT47DQo+ID4gPiArCQkjc2l6
ZS1jZWxscyA9IDwwPjsNCj4gPiA+ICsNCj4gPiA+ICsJCWV0aHBoeTogZXRoZXJuZXQtcGh5IHsN
Cj4gPiA+ICsJCQlyZWcgPSA8MT47DQo+ID4NCj4gPiBJJ20gc3VycHJpc2VkIHRoaXMgZG9lcyBu
b3QgZ2l2ZSB3YXJuaW5ncyBmcm9tIHRoZSBEVFMgdG9vbHMuIFRoZXJlIGlzDQo+ID4gYSByZWcg
dmFsdWUsIHNvIGl0IHNob3VsZCBiZSBldGhlcm5ldC1waHlAMQ0KPiANCj4gSSBub3Qgc2VlIHdh
cm5pbmcgcGVyIG15IGJ1aWxkOg0KPiAiDQo+ICoqKiBEZWZhdWx0IGNvbmZpZ3VyYXRpb24gaXMg
YmFzZWQgb24gJ2RlZmNvbmZpZycNCj4gIw0KPiAjIE5vIGNoYW5nZSB0byAuY29uZmlnDQo+ICMN
Cj4gICBDQUxMICAgIHNjcmlwdHMvYXRvbWljL2NoZWNrLWF0b21pY3Muc2gNCj4gICBDQUxMICAg
IHNjcmlwdHMvY2hlY2tzeXNjYWxscy5zaA0KPiAgIENISyAgICAgaW5jbHVkZS9nZW5lcmF0ZWQv
Y29tcGlsZS5oDQo+ICAgRFRDICAgICBhcmNoL2FybTY0L2Jvb3QvZHRzL2ZyZWVzY2FsZS9pbXg4
dWxwLWV2ay5kdGINCj4gIg0KPiBBbnl3YXkgSSB3aWxsIGNoZWNrIGFuZCBmaXggaWYgdGhlIG5v
ZGUgbmVlZHMgYSBmaXguDQoNCkFjY29yZGluZyB0byBQSFkgZ3VpZGUsIERvY3VtZW50YXRpb24v
ZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvZXRoZXJuZXQtcGh5LnlhbWwsIHllcywgd2UgbmVlZCB3
cml0ZSB0byAnIGV0aGVybmV0LXBoeUAxJy4NCg0KRFRTIHRvb2wgbWF5IG5vdCBjb21wbGFpbiBp
dCwgSSBndWVzcyAnbWFrZSBkdGJzX2NoZWNrJyBjb3VsZCBnaXZlIGEgd2FybmluZy4uLg0KDQpC
ZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCj4gVGhhbmtzLA0KPiBQZW5nDQo+IA0KPiA+DQo+
ID4gICBBbmRyZXcNCg==
