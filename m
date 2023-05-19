Return-Path: <netdev+bounces-3778-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E2D83708D4B
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 03:26:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18D9E281A58
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 01:26:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAF77385;
	Fri, 19 May 2023 01:26:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83D7362
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 01:26:09 +0000 (UTC)
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2077.outbound.protection.outlook.com [40.107.15.77])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7E399;
	Thu, 18 May 2023 18:26:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IFtcnliWGEttobkWOhPILgXOCOBn2FI/jyHjhPjZO7XbGElYqTBEtummb2KPcuFEM2eUQVrBz/pGlHM3INt+wyFyGFlE9giHnKqC08FNUtHbOk/i7KmxZrPg+/S4KqAM4N3UQF7EoJ/05BJ20tL0s6mzglb6nUKTJ3kc8GXKv11UHBBJKsCV63gm87Dr/EU+8XkGprKKJ+SyWh0zXsigUOrY0Zzs6Le2YYJLQjzM+suzFmFJN1/YUYmSytkCMg6Z4qjOA+MeQhblBS+1gW3928rTl9cuwciYytlHkIZSkGk9x4Uk5+2vw3++9HLKIc3wzqCA6R5PEoQHY/dT0E1psQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Dbf3cOQSnSGypwr95REpK5aIhee2Oe6niM0Oc3NZXY=;
 b=lppqcMkj1JZPgze3fL6D3quroROgV6H16wPkEV92nNxrIi7aR5gQS+aCMYX6qCy62X4JFuiEydwLane9wldPCf88WHxDp3/15safp44u21+FmZni3KFAgRBmPPnyBZdpOMwm2pRIgY4blLoPjE/sQ9sb+0o6IpQ+6RIJJRoO1arFIeiJxGbV0jpv3wlAU8eZhuOsI9jLEr632nUpr6Ql9XzgC2T5IyLItj4piMOF+Mef/LAJOSKgiIhL8JUb909DuQUEV0Njm8dguPL56dZD9cZ7xoPxk9o6CFXCQ0ELcWYUxN/GbDfLSELR+QrzRNTY5i8ZcbgdRzJUI2KDoV/hGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Dbf3cOQSnSGypwr95REpK5aIhee2Oe6niM0Oc3NZXY=;
 b=OY+w22HA5YFfc8NJtfsGhit4vMlA4viMtA2ERBgp5Cmv1yNvD5te7jn/Pcl5ltCoEBbHPeGfxVf+n0th0VM72k+sWHXSJerWMV4tD5UfMhJYB6arzoI/QMuBoPxFpyw1LVZwiBahFbbiXElHhh63GwVRAmaYr2S6FdvteafG3Og=
Received: from DB6PR04MB3141.eurprd04.prod.outlook.com (2603:10a6:6:c::21) by
 DUZPR04MB10016.eurprd04.prod.outlook.com (2603:10a6:10:4dd::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.21; Fri, 19 May 2023 01:26:04 +0000
Received: from DB6PR04MB3141.eurprd04.prod.outlook.com
 ([fe80::4fc7:994a:43c9:7058]) by DB6PR04MB3141.eurprd04.prod.outlook.com
 ([fe80::4fc7:994a:43c9:7058%7]) with mapi id 15.20.6411.017; Fri, 19 May 2023
 01:26:03 +0000
From: Wei Fang <wei.fang@nxp.com>
To: Simon Horman <simon.horman@corigine.com>
CC: "davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "Frank.Li@freescale.com"
	<Frank.Li@freescale.com>, Shenwei Wang <shenwei.wang@nxp.com>, Clark Wang
	<xiaoning.wang@nxp.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	dl-linux-imx <linux-imx@nxp.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net] net: fec: remove useless fec_enet_reset_skb()
Thread-Topic: [PATCH net] net: fec: remove useless fec_enet_reset_skb()
Thread-Index: AQHZiYla0M3/wuMQfEe0TPDQsIZBYa9gRj+AgACHfgA=
Date: Fri, 19 May 2023 01:26:03 +0000
Message-ID:
 <DB6PR04MB3141A8E6711EF51ABD272FE9887C9@DB6PR04MB3141.eurprd04.prod.outlook.com>
References: <20230518130016.1615671-1-wei.fang@nxp.com>
 <ZGZduVeDx9TvlToT@corigine.com>
In-Reply-To: <ZGZduVeDx9TvlToT@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB6PR04MB3141:EE_|DUZPR04MB10016:EE_
x-ms-office365-filtering-correlation-id: 27640341-ef3d-4671-9e8b-08db58080314
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 GqchgkvKaTh5R4NOUFMsRwcgMn4K2mULvzjL5vy9uSRxzftvQwvwI29UYd0Ti6MltxtPSMQCEsMw6r80MSVVsAEey7+WnLaWLQ8UQAfg4opeixQzwu0is9BNNcJnf+98//HPS5uy93WUsoouMv8kbBB/vZEwUSwVMIffUzrLEnKt6KyqOWlzrcCMTdeY+E3gupQfP/ymSYMYiLAnnY1xBVlXuW8dbuG5V/4Dn1UUUlJdsxt1H1tu2R1hBuNwE5CPWurxFBCSk7IEfGc9SLAco+XHyIvW73BfbI5RJrKFy8yOg3AxqL6J4/ExbdJJRghzis6fZfzKQO+XFzna2Sa1kt0kRSBWaGIE/Wnny4SfLKZJJQS14REcU8RyZeSoKsgGQYm5P1bAGPhFGcjqzBR6aEAJV2xzxwIqFXe/HZ4hPyO9WdpoVw9Id8lm90+f+meealuWczmK4Q8bWCKvSO4OaU36wTsB9asJVKJER5p9dqzOn6xX2GZ3ui441aDJKBqZlU5Y2eotmQOreNTNSZ/ebTZSv2JO/iSSHHMMM2YUDP/quvzPoH0dh2+xPXLG9ADQ0a5b0FoZdGTTDg+pxpU9nEHillzcu+lavYzNPrGIVqioNbtQPxkASyUUA0AMdTf8
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR04MB3141.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(451199021)(83380400001)(478600001)(7696005)(71200400001)(54906003)(6506007)(26005)(9686003)(53546011)(186003)(2906002)(5660300002)(8936002)(44832011)(8676002)(52536014)(33656002)(122000001)(6916009)(38100700002)(4326008)(66446008)(66476007)(66556008)(66946007)(76116006)(64756008)(316002)(55016003)(86362001)(41300700001)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?enVqcUFCN09BQ3JTZ0xlKzhRT1JiRnZGcTFuZ2xCQy9aUm9rWG96NEJCOGVm?=
 =?gb2312?B?UitSUmFqckNWQWVydFZ3bjNwUHpOQlV0QjdqN2JoOGExKyt6UzBoMFhRN0lG?=
 =?gb2312?B?MW5WSGwwY0FCVGF6STJnc1owYzlsT2VsMGpOR0dVbVdZaFhIRXBoeUh5elYv?=
 =?gb2312?B?eUF1TGFsUEI2SzJJRHgzYXJ0RCs1Z1NBbG5CV3ErSmhBcUNlVUdGR2hRZERN?=
 =?gb2312?B?UzhEUi83Z2owZDZxRCthT2ZYc3pGSHZVY2FPRXR1cE5IdGlSTHJEejFCWGpN?=
 =?gb2312?B?WHJxMkE1VjJPLzFpK3FkUUpyQWU3OHJtTkNKVm1VanE1eSsrb0MwRTJma0tW?=
 =?gb2312?B?bFpjRjdvdkc3M0xiNmZQaGRyL2o4SVJ0aVE3anpjM0gweEUvem9pbmJIanYz?=
 =?gb2312?B?L045NkMyM25vU2VuTlArZG9teXRESS9LeGlMcTBhMTBHUjlyd2NPS3N6S1Jm?=
 =?gb2312?B?RG5PakFXYzhjUWlOMmcreCtwekpVMWsySzJGZWdCU0VOQ2YwZEk1cTZySnpp?=
 =?gb2312?B?Ly9ENDZsb3RBL3FmMnp0SmUrc2pBYnBMOUVtVldxdEh1NVh1dFlRWGFnZ2hS?=
 =?gb2312?B?QkxZRHJKR0ZKclBTWjVKQ2NvdG41V1Z3eDdBMXFiNGxZOU5HeEZiSVlJRTlF?=
 =?gb2312?B?bkU4VkxkTmkwVm5tKzUyMmJxSjdhaEZEbUMwRFhQTjROaGdFWUtDNGVjWUhK?=
 =?gb2312?B?N011Ukl1djEyMlc0Zm5GSGpDZUdaQzh4YytJWjltVE9nbWV3cTg4bkZMaHNz?=
 =?gb2312?B?aUVNeTd6T04rR01WYmpJblJNTmNITDJFZERwbm5pZlJ3ZWo0MUFEZU9CVnVU?=
 =?gb2312?B?ejlMM1lzaDJzeXZBN0F0ZVBxdmsxbnptV3IxNVRSNFdrbmZMaXBzR1R5T3c2?=
 =?gb2312?B?bDY5SWpuRTN4ZU9EcmM3TkdoTlpZaUVrUFlKclJDbG9Cd0dtMEpwVHJOb3N0?=
 =?gb2312?B?SXljdTNNaVQwcGtqY2xRQUc1V0lwUXJoSXd3TEIyL1RDNkVUbnpTQ1VrSUQ4?=
 =?gb2312?B?ZEREd0IzS2JZV0t3dW44QUU5em03NWNCYTR1Zy9NanViZVplN0Q1N21yOVc2?=
 =?gb2312?B?Z2hTMDdPU0pSc21nQVlSREd6dS85R2xMMGllakhmalpEcTdNb3hTWHdraE1N?=
 =?gb2312?B?SlRkMVBkVU03am9CdTBQMnV3VS9ORW80cU9OVjhwbkFleEk4TmloY0prY0pw?=
 =?gb2312?B?a20wYW1oQUdSRmpNNnFkR0FhSjVxeHFzVmVUSGtkMlJMRlAxSFJTU2Zpd2g1?=
 =?gb2312?B?b1hFa0FpRUQ3TnY5d0c5SGRKNUpNTis2M0xyYjVxdkxkNUxxUTNHMExzeXEw?=
 =?gb2312?B?ak9jN1M5VGtpUkgzSjJmTDhKbFUyeHFBZk1Zc1ZzMno2T2hKU1J6QzdVNDA2?=
 =?gb2312?B?Y2JYbytqSEZQRjcwb3E1RWVaVG4xRi9uTHlQNHJFSFlSVFFlZUVFMlVmY3VG?=
 =?gb2312?B?SmhidlRxVFN1TUNRc0tIMGVTL1RjTE5walk3RFM1NUc5azU4TXJyMm9xUHhP?=
 =?gb2312?B?RG1ldDFERWFwK2Q1SjE3bzlQUk1PVUtXYkE2UFFTL1RWVFQvRW5OOFEwaUtY?=
 =?gb2312?B?WVMydFVSMHc3TUhrQ2xkaHppcnhncVJ6ZCtyZHpid2xiQ1FNWjl4c1dINFI4?=
 =?gb2312?B?cElyZDlZdW5NRWxmeEk0bTAyU2RuSXNkOFhMOVpXbysyNDNwQjZzS2VqQ3R5?=
 =?gb2312?B?T1A2N2c4QXg5YXdxSGllODNzV1FFR1BPK1hIZjBKYnIrWDdZUlQ3RDZlWU5N?=
 =?gb2312?B?a1BWQi9vdlkwOFA4MFlPOUYxMVhzWVlKTFVvL3FHMnI0OTFpY0lhZEpSWnpp?=
 =?gb2312?B?VEtTbFpZMmxiU0x5ZU1QMVd0N0RmZlJkK0MrYTllN2tkUkpZZ2srWXVyakpl?=
 =?gb2312?B?NkU3akJ2YkJBV3dpdCtLT3hoTTA2bEZNWXhjbE03cWlZMGJEL1FEVVc2MTYx?=
 =?gb2312?B?eVoyOWljRkFBSGIzdis4T3EyUHdoQnlkdTg5U3g2aGRtdHlTWHlQdGxGQjVt?=
 =?gb2312?B?cTI0cXJLM05CVklSNDZobWJ4dnIwOWIzRzNMbG0vcnBzbjJ1dGhXQXNVV0Q2?=
 =?gb2312?B?L0t0UGZEcTZFYUNJU0xWblZsTUtsb2g3WCswRm02dWVtMEpkSGJKYmxEdUQ4?=
 =?gb2312?Q?zfRM=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: DB6PR04MB3141.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27640341-ef3d-4671-9e8b-08db58080314
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2023 01:26:03.7620
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Snff/hmttOw2vklq+NcJ1TUUEOTCb5Ap0m1vv6abXwBHbeRal1JL3boegkpAfVCws+2jObqQ+UmRXSCdLUVHzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DUZPR04MB10016
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTaW1vbiBIb3JtYW4gPHNpbW9u
Lmhvcm1hbkBjb3JpZ2luZS5jb20+DQo+IFNlbnQ6IDIwMjPE6jXUwjE5yNUgMToxOA0KPiBUbzog
V2VpIEZhbmcgPHdlaS5mYW5nQG54cC5jb20+DQo+IENjOiBkYXZlbUBkYXZlbWxvZnQubmV0OyBl
ZHVtYXpldEBnb29nbGUuY29tOyBrdWJhQGtlcm5lbC5vcmc7DQo+IHBhYmVuaUByZWRoYXQuY29t
OyBGcmFuay5MaUBmcmVlc2NhbGUuY29tOyBTaGVud2VpIFdhbmcNCj4gPHNoZW53ZWkud2FuZ0Bu
eHAuY29tPjsgQ2xhcmsgV2FuZyA8eGlhb25pbmcud2FuZ0BueHAuY29tPjsNCj4gbmV0ZGV2QHZn
ZXIua2VybmVsLm9yZzsgZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhwLmNvbT47DQo+IGxpbnV4
LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXRdIG5ldDog
ZmVjOiByZW1vdmUgdXNlbGVzcyBmZWNfZW5ldF9yZXNldF9za2IoKQ0KPiANCj4gT24gVGh1LCBN
YXkgMTgsIDIwMjMgYXQgMDk6MDA6MTZQTSArMDgwMCwgd2VpLmZhbmdAbnhwLmNvbSB3cm90ZToN
Cj4gPiBGcm9tOiBXZWkgRmFuZyA8d2VpLmZhbmdAbnhwLmNvbT4NCj4gPg0KPiA+IFRoaXMgcGF0
Y2ggaXMgYSBjbGVhbnVwIGZvciBmZWMgZHJpdmVyLiBUaGUgZmVjX2VuZXRfcmVzZXRfc2tiKCkg
aXMNCj4gPiB1c2VkIHRvIGZyZWUgc2tiIGJ1ZmZlcnMgZm9yIHR4IHF1ZXVlcyBhbmQgaXMgb25s
eSBpbnZva2VkIGluDQo+ID4gZmVjX3Jlc3RhcnQoKS4gSG93ZXZlciwgZmVjX2VuZXRfYmRfaW5p
dCgpIGFsc28gcmVzZXRzIHNrYiBidWZmZXJzIGFuZA0KPiA+IGlzIGludm9rZWQgaW4gZmVjX3Jl
c3RhcnQoKSB0b28uIFNvIGZlY19lbmV0X3Jlc2V0X3NrYigpIGlzIHJlZHVuZGFudA0KPiA+IGFu
ZCB1c2VsZXNzLg0KPiA+DQo+ID4gRml4ZXM6IDU5ZDBmNzQ2NTY0NCAoIm5ldDogZmVjOiBpbml0
IG11bHRpIHF1ZXVlIGRhdGUgc3RydWN0dXJlIikNCj4gPiBTaWduZWQtb2ZmLWJ5OiBXZWkgRmFu
ZyA8d2VpLmZhbmdAbnhwLmNvbT4NCj4gDQo+IEhpIFdlaSBGYW5nLA0KPiANCj4gdGhpcyBjaGFu
Z2UgbG9va3MgZmluZSB0byBtZS4NCj4gQnV0IGl0IGZlZWxzIG11Y2ggbW9yZSBsaWtlIGEgY2xl
YW51cCB0aGFuIGEgZml4IHRvIG1lOg0KPiB3aGF0IHVzZXItdmlzaWJsZSBwcm9ibGVtIGlzIGl0
IGZpeGluZz8NCj4gDQpUaGVyZSBpcyBubyB1c2VyLXZpc2libGUgcHJvYmxlbSwganVzdCBhIGNs
ZWFudXAuDQoNCj4gSWYgc28sIEkgc3VnZ2VzdCB0YXJnZXRpbmcgYWdhaW5zdCBuZXQtbmV4dCB3
aXRob3V0IHRoZSBmaXhlcyB0YWcuDQpPa2F5LCBJJ2xsIGNoYW5nZSB0aGUgdHJlZSB0YWcuIFRo
YW5rIHlvdSENCg==

