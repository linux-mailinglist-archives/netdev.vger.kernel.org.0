Return-Path: <netdev+bounces-3783-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EDC5708D5E
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 03:33:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16FA41C211C1
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 01:33:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43048387;
	Fri, 19 May 2023 01:33:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2B1386
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 01:33:11 +0000 (UTC)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2065.outbound.protection.outlook.com [40.107.22.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C52E51
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 18:33:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gc/MPqnRvCBBr5SSKHLTkjE4bHz/ovJo5Q6qBYVBdb90GttctPw4WLblNCAzGbo0Ki/clexvlaIebWePkK+Byd6SULieOP4NyCOMjjlW4OV13s/G+muJ8/IR3UJ9nr3PiNtT9W7Mef9oDvZiJChhy59iJ1YXwviZoVFPETpTxBBTBtzp6Z7bVC6VdzzPu+p7MlURIomzPmTnLC0wTmA+7Ox499ogHHRHITDzqGkw/fKx+ahOqf2sqbrFKDqgp+BPyq6L1cgAMIIQlggVfcUBp/XTKs8nyU3R44U+17hNoqYto9WjQukiPxSNU778+aiul8uymEsSKpVYYzu0Jn/NJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4iFaHnDcj+/cs5NpIJHWPTihyOFSOHMjnDxrdowXmic=;
 b=FMGPBneYbQ7XopmSO5OS9tjN2+bmu63FlsrjlzJntHqkTC9q8PhSA4QV32zPSmry26xxfE0cMSeU4tdWwy3GMXiGCQT+mc1VMnpDerEgqic8CsroC92gk9tFvIbmiiR27lp4qaDI8QUTVhTu4CpbxippGe2XwETTw+c50YRbJDHUrEi1K4RawitJlFAvXoTbyk7Zgy7oisnb813gX22TRUClmjqc7XUuldN4th46T7ANt5SBxvPieuR+Xz3g/z8prYlXVUjdpMXpwzlHE2wRlYakMubPx/12Y1DBhKAqM3JFIgtGVvefLYnmI/y0cjcZooyvXau504diFnsgfklM2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4iFaHnDcj+/cs5NpIJHWPTihyOFSOHMjnDxrdowXmic=;
 b=NaQzJJpjcFgVMyjGSqebtQ3b4u976ynGYIsg7NkvM9/AuUMF+GRvKJO8nBmvBX9WKqUG+o3bsfxz6tzanetqezbsViGCmtfj+BRBjOobcvHjbPV9D/EheLXrlBWfkUeoLy23iLk7rDrW89ACmmrmhZlSFik3kh7gD9q8f0X5/Ak=
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com (2603:10a6:206:8::20)
 by AS8PR04MB8754.eurprd04.prod.outlook.com (2603:10a6:20b:42d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Fri, 19 May
 2023 01:33:07 +0000
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::682b:185:581f:7ea2]) by AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::682b:185:581f:7ea2%4]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 01:33:06 +0000
From: Wei Fang <wei.fang@nxp.com>
To: Shenwei Wang <shenwei.wang@nxp.com>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
	<horms@kernel.org>, Horatiu Vultur <horatiu.vultur@microchip.com>, Heiner
 Kallweit <hkallweit1@gmail.com>
CC: Clark Wang <xiaoning.wang@nxp.com>, dl-linux-imx <linux-imx@nxp.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "imx@lists.linux.dev"
	<imx@lists.linux.dev>
Subject: RE: [PATCH v3 net] net: fec: add dma_wmb to ensure correct descriptor
 values
Thread-Topic: [PATCH v3 net] net: fec: add dma_wmb to ensure correct
 descriptor values
Thread-Index: AQHZiZm8pi6/M3IVMkCSzzpJm1vVA69g0FKg
Date: Fri, 19 May 2023 01:33:06 +0000
Message-ID:
 <AM5PR04MB3139DF67CC0CA6866B6FA964887C9@AM5PR04MB3139.eurprd04.prod.outlook.com>
References: <20230518150202.1920375-1-shenwei.wang@nxp.com>
In-Reply-To: <20230518150202.1920375-1-shenwei.wang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM5PR04MB3139:EE_|AS8PR04MB8754:EE_
x-ms-office365-filtering-correlation-id: 9dfe9b9e-8c2c-4969-1403-08db5808ff4a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 NkmCkBEWlaucascaTYS7lxfcu/MNw80tvuH5MJj3RISJk3aT5IMYWGDvVefliNiszFr9hVKWBBuSPGbowO+AE+rtUONiaEVjM88eSXcoPMpKs3nSC1R09JZEIMBybSeApE64Y6RfSXfjTfBW3A+pN15k84WgysDEu37ws/ZIUqFsVNvdvLQU0yX9U6gWSeViUMmh/Va0jvnRqB51atKzZ0YZeGwc129rQ7Mkcc0YxltiaTscUb60zh3AtBIsEk6gHK8XqyLasH4t24LwEyX5br1V1JN2MOqMkfKS3G9CKrWOOVvw/UlOpMM2HoTSP8CVd5gApH7shr3QO3w8LSIdwQvlzsbZ5Aa4fpfEfWwTCsAIUeVV0CvaK3PdI6axyzqSRDcyEDZYvWYwlhhbX55H6PSjIYr+Sr5SH7Y8tMo/GIsf826ZcrK5BCkrxu+cb8wClC+l1OxR4dYhn3IrOhyz26eIsRU48Q63dEpqg+SeQf+1qtdvEt/xuwQQ4jYVUNFqFEEIqIEDFa3G6TD4qQXwuRI4lLsrAbRUoTdxq9O38fNnRBfrtOkMOYPnzgJL/585eBykIjU+cJ53LYYW38ezYnQZRxOkyD4G/g6CPSYO9JdrS8nP9i0ZFIVtIdW74E5k
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3139.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(451199021)(55016003)(53546011)(9686003)(6506007)(44832011)(8936002)(8676002)(33656002)(86362001)(83380400001)(2906002)(478600001)(7696005)(64756008)(66476007)(41300700001)(66556008)(52536014)(5660300002)(186003)(316002)(76116006)(66946007)(110136005)(66446008)(54906003)(4326008)(38070700005)(122000001)(38100700002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?UHdKSmtEWW1OeUdaeGhwVGhWdGU0aHlPMXZ0VVU0M1Y3ekpXNDBBd3J0VE5v?=
 =?gb2312?B?UGlZL1p2NnVIRGFFRjU0Ykw0SDVzbnlXN3NZM0ZHaDF6citiQkR6Qml2TDFn?=
 =?gb2312?B?OHEyMmpEaVoyL3BXQjUrQUNkRXAzQWZYMXloUGZKUTVlaHluVTI0czdrVEZv?=
 =?gb2312?B?a25BYzl4U3lxZDRZMVAxSmtuV3hKelFjNCt1NkVZS2VvL1pCWlBDTGlvVmpW?=
 =?gb2312?B?eWFtUVFObXdFOVVvcDA3eEl0S2ZJZmkxRW9JUjZoZ25GZmNJbzZONXpqWlRz?=
 =?gb2312?B?dTc1bXRQR25XWFVQaEV5KzhzVTBuRUtqcDBHV3ptT2dLZmp4VS9NTjkzZFVV?=
 =?gb2312?B?c2dGZC9GV2syVTMwb0lSUFp6WUFjL0NjMll5a0p0bTkzdHJpb1RKNUpwN1Nk?=
 =?gb2312?B?QUN0aGJTK1R2MXRPdjdaMjBUOHJWdGRuRjhJSmV3MFAwdnVCOTF5QjdHem5R?=
 =?gb2312?B?WlI2NE0wcFliRWJQSnhsZmduVjFQLzRDRHFBTC8zTzJZY0w0UmlvcFhPQXJs?=
 =?gb2312?B?elU4OWFINERYakhaMklwY1RVM2tBWHBkSHJVODE5RlNGandHRGgvdDJOL3hn?=
 =?gb2312?B?K1ZqV0g2NnE1Y0NiNm94aUR3MWYrQVVIZWJodTgvS2J3VXBGaFVtYVBzZGl6?=
 =?gb2312?B?MlhrcjlPUFc2cHlrak5UTXJabFV2WDF0aWYzeVhqdWpmQ0NTbUplRkNRSTls?=
 =?gb2312?B?RnU2cGgzN3M4S1o3OURXYVNyenl6QldsSHlneHRJS1JXR2Z2TFRDSERSU1Vy?=
 =?gb2312?B?RE9CVG1SV0ErWS9qVFJvalFHTkNJb1pYVjdZMlg4amNiSkdxcnBnL0tHMkh6?=
 =?gb2312?B?UHpJYUNRVmg2K2VOV2wvZ2pTV3JXVHpHTGgwWkN5dUk3NWh6OVdJRGgzY2Z1?=
 =?gb2312?B?SHBkRHVPTHFaZzA1dm5HSmtkRC9YUEQ3QllBNnZHU2FScCtsdHlKeW56VFJz?=
 =?gb2312?B?a1QraE4xOTdVREtqYSttN0lNVGhKZzZjYTF6dWp1RmVTajFpV2dsKzBkSmtZ?=
 =?gb2312?B?K3pocGhwODh2Qk5RR2RrOTgwV0E0Z1BhYzhRUUpEcWxLTWp1UEcxdkhJS3JI?=
 =?gb2312?B?K1F6cnNCSmtrOFpEYi9PVmErSTBlZndBeUFpSy92ZzF6VzVDZjd4YWJKYVZ3?=
 =?gb2312?B?aUlNdjV2NzZNV29pWFhEaG5RSFkyWGxyVjlMeStHRTcvWkNiNVgyWDFuSENJ?=
 =?gb2312?B?Y294bXhFMU0ydUNsWkpVclhWWGFvQXRYcjZoNHJGNUN1WVN4TXhJN0tZY1hD?=
 =?gb2312?B?RmUweEFFYlJrbGVSRTdrbzVUSDRnWm04ang1N1Q0RXRueWFEQnpiR2NxcGNm?=
 =?gb2312?B?bCt5NGxFM2RCZVZ4b3JyaW56OTZVNyt3cmhXWUtYSjlzN29XNXlJMDhsYUhH?=
 =?gb2312?B?Qk8xcVgwOXhuNlE5cERCa0tqUFRYb1RvRzhEZUxJbW1RMHNPUFV1Y1A3YXgz?=
 =?gb2312?B?RlhWOGdaSkxHM0wrZmNJRDNKNW5pR2lJWkNjSVNybUVSQnJqd1BBWEM3ZFRv?=
 =?gb2312?B?OUwybC9sME9zaWN5ZXUyQTVUWXYrbFc1UUZpbXhJalpvSGprSFJJblFBbXNC?=
 =?gb2312?B?aXAyWFJaUVY1SUVKWEZSV2VWMXlFQ29UcmdzT3VQYXBpOG8rSDRPbzlocDE1?=
 =?gb2312?B?aWJaWlI0NGxUVmdpUzhlUFNqMzJqdmVhUVB6TGZ3Wlcwc3pTc2VwcXhsOHVT?=
 =?gb2312?B?WjdPVmloV1BORjFJWEVqV3F3Ris2QThNNGVDZ3RWVU81VFEwOTEycVZCdUg1?=
 =?gb2312?B?anR6ZERYR1k4OHZ3T3dYa1hFKzNqc3J1ZVVxUFhLUE5nWEp6K25JdzN3UmNP?=
 =?gb2312?B?VWtlUlVURGJKa3hWTXpCZnFsYnM0T3FJMmxJK0dqQnVaL1pBMnF3em9oN3ZX?=
 =?gb2312?B?WXVFQW1kR1JUbFJtMjZleEgwZ3RwWlo2YzN4YnQzdzExZmo5UGd2dGdYdTBK?=
 =?gb2312?B?N1QzOGpKVWxDbHA5NnovcFJPL256MUZ3S1VKRm9UUXFKMGpDeDRYWVJSTzZ4?=
 =?gb2312?B?c0NLZjB2NzY5OWlLcVNUN0ZUaWVjL2NvcVRndFh0d0lUTkF4NzRCcnJabEN3?=
 =?gb2312?B?K2tIVDk4bFhqT24ybThieGxheE1ydjIvbVJDUT09?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3139.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dfe9b9e-8c2c-4969-1403-08db5808ff4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2023 01:33:06.8957
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hl3N9WM9JDPrKOb3lky/ItBvLwm2Su1oY2c7YnVTwwD22fjbgIGSB3Kyz14ZHh8j/971pqJA1PqAfQLNVDr7NQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8754
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTaGVud2VpIFdhbmcgPHNoZW53
ZWkud2FuZ0BueHAuY29tPg0KPiBTZW50OiAyMDIzxOo11MIxOMjVIDIzOjAyDQo+IFRvOiBXZWkg
RmFuZyA8d2VpLmZhbmdAbnhwLmNvbT47IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0
Lm5ldD47DQo+IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT47IEpha3ViIEtpY2lu
c2tpIDxrdWJhQGtlcm5lbC5vcmc+Ow0KPiBQYW9sbyBBYmVuaSA8cGFiZW5pQHJlZGhhdC5jb20+
OyBTaW1vbiBIb3JtYW4gPGhvcm1zQGtlcm5lbC5vcmc+Ow0KPiBIb3JhdGl1IFZ1bHR1ciA8aG9y
YXRpdS52dWx0dXJAbWljcm9jaGlwLmNvbT47IEhlaW5lciBLYWxsd2VpdA0KPiA8aGthbGx3ZWl0
MUBnbWFpbC5jb20+DQo+IENjOiBTaGVud2VpIFdhbmcgPHNoZW53ZWkud2FuZ0BueHAuY29tPjsg
Q2xhcmsgV2FuZw0KPiA8eGlhb25pbmcud2FuZ0BueHAuY29tPjsgZGwtbGludXgtaW14IDxsaW51
eC1pbXhAbnhwLmNvbT47DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGlteEBsaXN0cy5saW51
eC5kZXYNCj4gU3ViamVjdDogW1BBVENIIHYzIG5ldF0gbmV0OiBmZWM6IGFkZCBkbWFfd21iIHRv
IGVuc3VyZSBjb3JyZWN0IGRlc2NyaXB0b3INCj4gdmFsdWVzDQo+IA0KPiBUd28gZG1hX3dtYigp
IGFyZSBhZGRlZCBpbiB0aGUgWERQIFRYIHBhdGggdG8gZW5zdXJlIHByb3BlciBvcmRlcmluZyBv
Zg0KPiBkZXNjcmlwdG9yIGFuZCBidWZmZXIgdXBkYXRlczoNCj4gMS4gQSBkbWFfd21iKCkgaXMg
YWRkZWQgYWZ0ZXIgdXBkYXRpbmcgdGhlIGxhc3QgQkQgdG8gbWFrZSBzdXJlDQo+ICAgIHRoZSB1
cGRhdGVzIHRvIHJlc3Qgb2YgdGhlIGRlc2NyaXB0b3IgYXJlIHZpc2libGUgYmVmb3JlDQo+ICAg
IHRyYW5zZmVycmluZyBvd25lcnNoaXAgdG8gRkVDLg0KPiAyLiBBIGRtYV93bWIoKSBpcyBhbHNv
IGFkZGVkIGFmdGVyIHVwZGF0aW5nIHRoZSBiZHAgdG8gZW5zdXJlIHRoZXNlDQo+ICAgIHVwZGF0
ZXMgYXJlIHZpc2libGUgYmVmb3JlIHVwZGF0aW5nIHR4cS0+YmQuY3VyLg0KPiAzLiBTdGFydCB0
aGUgeG1pdCBvZiB0aGUgZnJhbWUgaW1tZWRpYXRlbHkgcmlnaHQgYWZ0ZXIgY29uZmlndXJpbmcg
dGhlDQo+ICAgIHR4IGRlc2NyaXB0b3IuDQo+IA0KPiBGaXhlczogNmQ2YjM5ZjE4MGI4ICgibmV0
OiBmZWM6IGFkZCBpbml0aWFsIFhEUCBzdXBwb3J0IikNCj4gU2lnbmVkLW9mZi1ieTogU2hlbndl
aSBXYW5nIDxzaGVud2VpLndhbmdAbnhwLmNvbT4NCj4gLS0tDQo+ICB2MzoNCj4gICAtIHVzZSB0
aGUgbGlnaHR3ZWlnaHQgbWVtb3J5IGJhcnJpZXIgZG1hX3dtYi4NCj4gDQo+ICB2MjoNCj4gICAt
IHVwZGF0ZSB0aGUgaW5saW5lIGNvbW1lbnRzIGZvciAybmQgd21iIHBlciBXZWkgRmFuZydzIHJl
dmlldy4NCj4gDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYyB8
IDE3ICsrKysrKysrKysrLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygr
KSwgNiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9mcmVlc2NhbGUvZmVjX21haW4uYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2Fs
ZS9mZWNfbWFpbi5jDQo+IGluZGV4IDZkMGI0NmM3NjkyNC4uYTUwOTZjM2NhYzAxIDEwMDY0NA0K
PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYw0KPiArKysg
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYw0KPiBAQCAtMzgzNCw2
ICszODM0LDExIEBAIHN0YXRpYyBpbnQgZmVjX2VuZXRfdHhxX3htaXRfZnJhbWUoc3RydWN0DQo+
IGZlY19lbmV0X3ByaXZhdGUgKmZlcCwNCj4gIAlpbmRleCA9IGZlY19lbmV0X2dldF9iZF9pbmRl
eChsYXN0X2JkcCwgJnR4cS0+YmQpOw0KPiAgCXR4cS0+dHhfc2tidWZmW2luZGV4XSA9IE5VTEw7
DQo+IA0KPiArCS8qIE1ha2Ugc3VyZSB0aGUgdXBkYXRlcyB0byByZXN0IG9mIHRoZSBkZXNjcmlw
dG9yIGFyZSBwZXJmb3JtZWQgYmVmb3JlDQo+ICsJICogdHJhbnNmZXJyaW5nIG93bmVyc2hpcC4N
Cj4gKwkgKi8NCj4gKwlkbWFfd21iKCk7DQo+ICsNCj4gIAkvKiBTZW5kIGl0IG9uIGl0cyB3YXku
ICBUZWxsIEZFQyBpdCdzIHJlYWR5LCBpbnRlcnJ1cHQgd2hlbiBkb25lLA0KPiAgCSAqIGl0J3Mg
dGhlIGxhc3QgQkQgb2YgdGhlIGZyYW1lLCBhbmQgdG8gcHV0IHRoZSBDUkMgb24gdGhlIGVuZC4N
Cj4gIAkgKi8NCj4gQEAgLTM4NDMsOCArMzg0OCwxNCBAQCBzdGF0aWMgaW50IGZlY19lbmV0X3R4
cV94bWl0X2ZyYW1lKHN0cnVjdA0KPiBmZWNfZW5ldF9wcml2YXRlICpmZXAsDQo+ICAJLyogSWYg
dGhpcyB3YXMgdGhlIGxhc3QgQkQgaW4gdGhlIHJpbmcsIHN0YXJ0IGF0IHRoZSBiZWdpbm5pbmcg
YWdhaW4uICovDQo+ICAJYmRwID0gZmVjX2VuZXRfZ2V0X25leHRkZXNjKGxhc3RfYmRwLCAmdHhx
LT5iZCk7DQo+IA0KPiArCS8qIE1ha2Ugc3VyZSB0aGUgdXBkYXRlIHRvIGJkcCBhcmUgcGVyZm9y
bWVkIGJlZm9yZSB0eHEtPmJkLmN1ci4gKi8NCj4gKwlkbWFfd21iKCk7DQo+ICsNCj4gIAl0eHEt
PmJkLmN1ciA9IGJkcDsNCj4gDQo+ICsJLyogVHJpZ2dlciB0cmFuc21pc3Npb24gc3RhcnQgKi8N
Cj4gKwl3cml0ZWwoMCwgdHhxLT5iZC5yZWdfZGVzY19hY3RpdmUpOw0KPiArDQo+ICAJcmV0dXJu
IDA7DQo+ICB9DQo+IA0KPiBAQCAtMzg3MywxMiArMzg4NCw2IEBAIHN0YXRpYyBpbnQgZmVjX2Vu
ZXRfeGRwX3htaXQoc3RydWN0IG5ldF9kZXZpY2UNCj4gKmRldiwNCj4gIAkJc2VudF9mcmFtZXMr
KzsNCj4gIAl9DQo+IA0KPiAtCS8qIE1ha2Ugc3VyZSB0aGUgdXBkYXRlIHRvIGJkcCBhbmQgdHhf
c2tidWZmIGFyZSBwZXJmb3JtZWQuICovDQo+IC0Jd21iKCk7DQo+IC0NCj4gLQkvKiBUcmlnZ2Vy
IHRyYW5zbWlzc2lvbiBzdGFydCAqLw0KPiAtCXdyaXRlbCgwLCB0eHEtPmJkLnJlZ19kZXNjX2Fj
dGl2ZSk7DQo+IC0NCj4gIAlfX25ldGlmX3R4X3VubG9jayhucSk7DQo+IA0KPiAgCXJldHVybiBz
ZW50X2ZyYW1lczsNCj4gLS0NCj4gMi4zNC4xDQoNClJldmlld2VkLWJ5OiBXZWkgRmFuZyA8d2Vp
LmZhbmdAbnhwLmNvbT4NCg0K

