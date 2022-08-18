Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D65597B49
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 04:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242648AbiHRCBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 22:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242643AbiHRCBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 22:01:09 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2044.outbound.protection.outlook.com [40.107.105.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F3AA5721;
        Wed, 17 Aug 2022 19:01:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EYpj9Hm86ooeHLCsvKXabG5X1efr5kqb4rBtXA+e+4NH+fSO9NRIy1JNUJZaUBkNJlLPWMvyo1+Qs9WFxx+rsf7IfS586yCTGswrafg6IgTVyHy+/uqdll1K7gSnxNGOKJV6UdI0L/mTlM4Gl1qZZ3Dctc4EfgaGOHrVYtso2LSMjUjDNYI3XdZCzVngBBUkW3SJmpbo8I0k6wpV/+BiP6dTMkpiLZetRpTESgma7bu4uvwDDSaDi3n2crS55to8Pr3LiNYp0t13zWb9bPGdPdfojmy9xhBHnMqXOi+IZKUW9NXnL/vVmeIGyI7AC2SBNZKfJ+ZFW7mxRmwVibxp2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WtV1Ov3M2Ufgb8gv5yhgRxpA5f72gCaXQwg/p9e2HD4=;
 b=E8wiUvGD15hhoIt/NvikPDLJGjl0HkmHdrrq0qTjBwAviEaUIjPxOFDDWOHC2vKxxbMTFNWrGOgAuD1YqlDPMRT+V0UHj27KRuiRLaVH19B61HNLW5RNb+pd5D74G4bDoaGTjq0ibLhJROuLZQ7kLEIp/CnfwEYM4TDPvK+mhMrh9kPDP9FdrpllfaffUkx5UQ5OwXN/V4JZWzLLESicdiuMZoUYaFJBSc4nUJx9p5vgr5DAvS0aQIIwNAWFIh66+XrN0da7zfg2GcBgUJ3WQsyNW+CTbGSk4nweMMLpl8yvpalNqOemJvroUoZP0/TYZYl++gjiilZttpkhKoxA+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WtV1Ov3M2Ufgb8gv5yhgRxpA5f72gCaXQwg/p9e2HD4=;
 b=gFf1GGuZ3bqTohBL8zTaazN8BdHkyygQTxEkSBBjX6nZuUqqhOrtQIPueoHxBop6SgN2r7ZN4tWAwB1BSyMDS2ZjfdegYXg+8F4yK/XX9vj8RTZGW3ABHwIVhpvtO9b0giZ8JnV90zHN3apwx09xveBN2h7XU39O6SATNZF0tU4=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by AM0PR04MB5025.eurprd04.prod.outlook.com (2603:10a6:208:cd::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Thu, 18 Aug
 2022 02:01:05 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279%9]) with mapi id 15.20.5525.010; Thu, 18 Aug 2022
 02:01:05 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net 1/2] dt: ar803x: Document disable-hibernation property
Thread-Topic: [PATCH net 1/2] dt: ar803x: Document disable-hibernation
 property
Thread-Index: AQHYrhiZCawC+L8jOkCFO9wn08ratK2rT8AAgAQh61CABHNrAIAAAETwgAAGjICAAAQloA==
Date:   Thu, 18 Aug 2022 02:01:04 +0000
Message-ID: <DB9PR04MB8106F4487E63C61AC310D34B886D9@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <20220812145009.1229094-1-wei.fang@nxp.com>
 <20220812145009.1229094-2-wei.fang@nxp.com> <YvZggGkdlAUuQ1NG@lunn.ch>
 <DB9PR04MB8106F2BFD8150A1C76669F9C88689@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <Yv2TwkThceuU+m5l@lunn.ch>
 <DB9PR04MB8106FF32F683295860D4939F886D9@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <Yv2ZeWPTZkIlh4t2@lunn.ch>
In-Reply-To: <Yv2ZeWPTZkIlh4t2@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 18e9f123-3c40-4c92-f61e-08da80bd8255
x-ms-traffictypediagnostic: AM0PR04MB5025:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c2IPJVNJx7zxAeh7vjYtXx/ge55xLrekUhLA5KDRBRkf+PHuU0Uh5NwR6qg1o7pw7AVoBvE4naEQEFcZQ9XaWT7DvPWApYVXAqc57bhL+bOkfSGCDMzUpT3Ol3g/x5jmWbDLNbmTnf0VM2iGd3ArLBQacAx4IkCu7EJaB7oenC4mAlD97ci3QBjWyFoxXfpi9tx/azu2c8Q2fAiXgj6ALRnwpgVPp2E8rd8ie9+MAvH62lqsPr1ny58RTNnqZWD9wCV95H9LJ7/GSq748ghIp+SS4V70v3cC0WX9+h5SHcrGQdqR4XvRBHyjpFi6XHJmPAAjh6SURi8cUXvpTxcHWzU18N/RDSEB1st0n1K0c0wvEAp3YxHCQ314zhcf1Zw5zjhfyMtwPIs0VJRzbBsN1HqB2A5KkXSBEyhHjGXNDPXIUwlNgUyETWCOsyruVfYxDVlxp8bWyVPZ64MpZSN2/ri4muiV6OmgIIPgZ45br4Rr2AkoCcyHFWsbt63uSSToVJnfxUlWXnF7A2sTyg1tgDKq5C1ouUInpU69JLku6gebOvOVOKCbqCt0CzRLn+kKE+Zp0KuwlHHO2ng49ZqCJbjb8vdIehcqQi9Te9hKtO6hcmeLUOU6R5s0pW0yqJTuC7MiwiMMIVlnZ6bAuph7iavdaaJS/sQDOQuNKfOeni59Sz5wN4EgG+l7dc4OghTM/nPTcbDd1KfbewXfJKY/VSLlGk3GXuCkNcNatX5pmBAorYJSIVMDN+aVWtDGips4Mudi5P50Ci0ua9mwZPVyfg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(136003)(396003)(366004)(376002)(66946007)(66446008)(76116006)(4326008)(66476007)(66556008)(8676002)(64756008)(316002)(122000001)(86362001)(38100700002)(38070700005)(33656002)(478600001)(52536014)(83380400001)(9686003)(53546011)(7696005)(6506007)(71200400001)(41300700001)(26005)(55016003)(54906003)(6916009)(5660300002)(186003)(44832011)(2906002)(7416002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?OTk1RjZPWFUvbmhNeEhoUXlQOXlpQkRRdm03emtJamJJQ3RnWSsxSVM5bHpE?=
 =?gb2312?B?VFZNL3NQTDRxaWVNQ3Y1NnhnZkdqVTRqcU9uMVY2ejFYdXBYdVNUcFNqTFVS?=
 =?gb2312?B?bm1mVS9USGtvcmN2eVlLL2JQNFo5bnp2Q1U1TVBEaEtWYmhGazZnNnJkQm5j?=
 =?gb2312?B?UVR0NCt0aE5rNVE5Q1VTb1RQazdsNTRydTFiV0FWUTVjMis3OVJzTnhxUHFY?=
 =?gb2312?B?RHVPaWI1ZGhabEttNFQ5VjRtaUsxbUtESUUvUHJ3MEhYOEUwR1RCV3RZZi9x?=
 =?gb2312?B?Mlh2U3ltYnNtVlBNUGVhWG5ReE5obDdyU1MzdnN2YUJNK2JCanZjRUtZZnF4?=
 =?gb2312?B?U0dsN1BJcldyTnhpVmRkczJ1MHEzYnFXMTNFa0RkS2IyWUEwcUx2NTBsaWVY?=
 =?gb2312?B?cHNsbHlHNmZ2NkM4ei9kZUU5SHc5OTBCbWo5SGJleE1TMllZVmpMSGJxMFgz?=
 =?gb2312?B?TGlPV2dCUExXZC92UG9TK1I2MkQ4OHdrNGJ2cWdxdmRjVTRtS0pPQmxTemE4?=
 =?gb2312?B?ZHdObzdpZU5GZE5aa0d5US91eFBPZGFpWVpwb0R2bW5EM0VvMnFOZDlmNVlM?=
 =?gb2312?B?VFdDNUMrOU1OOTdiL0h3aG1nSk4rMzRISGpzM0ZGemhGQmlNVHUxYVQ5Q1E0?=
 =?gb2312?B?OE52aTVGYlFBd0p2TkdBY0g2emRWaTczLzVITk9WQ1hHK2VDeEVvd3I4eDhL?=
 =?gb2312?B?MW9MTEpIcXRMWS9YcVc1RVZIckhlNjk2OWFXNDRxMGpHdVpKUVdtOEE4d21G?=
 =?gb2312?B?OVpaREQ1alRiQjFzbjEzTGl6bUVSQmhWbE1rWUR1a3FyMGZGSDNZVnFrVTZq?=
 =?gb2312?B?WHpYN0ljd3puVjdmTTNnbFlid2dINEZYc2RGbFZSWlBma2pabGhZOFZON09J?=
 =?gb2312?B?TVdqbktzS0N6YVpnajBGYm9zVm53WGlPNSsySUIzZnFJQjA2QWkza2t2M0xm?=
 =?gb2312?B?QTgzbXNzZlB5RWdhWjNWbytDY29lTGVKeDBYazdkd0FvMkVtNm9SMmpRQWZq?=
 =?gb2312?B?eVhmaCsvT0QwS2txbC9pVENuUDdMcEwySXRHZ0ZGd3VGbDJKdUtHL1o4OUtJ?=
 =?gb2312?B?cHA4eklqSzZwM3puT2g5eWo1WDFhV2l3QUNYMGwzQmtBUTFXdlR4dk9Xc0ZE?=
 =?gb2312?B?TnhMYVY0SnpqMnE1eGdhS1JVR0ZDZk1QdHV1ZnBUVm8wbWdOYWk4cEVBVWFU?=
 =?gb2312?B?MTBLUXc5Z3N0OUZJZm5wSHdYYWVJSnZzak1mTklKcmpvcWJBVjM5WnZzRzZq?=
 =?gb2312?B?R1NhY2NoTHFCVDI5RzFuellUY1RqdTlvVk1nY1lUSHhheUxqMm9EWXM4LzVN?=
 =?gb2312?B?eVBBUzJPNjN6US9Hd0xHd01VREJ3dHRvTFhBNTRlaUVoV3hTUXdLdVhONTJQ?=
 =?gb2312?B?YWtSMkRwUVBaY0NCbXFuc1hzTTVscGtvOW5yU3NNWGlHc2FpdzNxKy9GV2U1?=
 =?gb2312?B?MGVURG1xMG9iZUsvUSs1blgwcXBOVHpudUg0YkNDRnlBZTdYMnY3T2RML25q?=
 =?gb2312?B?WkdTdWtTTUxHMnBIOFJuTCsxdmdNSnFKMlh4NlY5OEdYOE1Db0ZKL3o5S2NL?=
 =?gb2312?B?MG53Ris3NFhvUy84eVVoa0V2RjllTnJGU1BwWGJkRXAvL05FQ01RVU9CeDdB?=
 =?gb2312?B?cnZjdGhYOU5IUDBhcXgvK2pRb2dFWFUwTi9TcmFXR2RUdWtmQVBUR1lkbzEz?=
 =?gb2312?B?QW81WWpkbGtTZXdZcXd1S2VuSDI0dy9pd2dsMHh4Q2JXUlBWSmRucnhZUjl0?=
 =?gb2312?B?cjFOMS80WjliNkZkZjVLSEJwOHVacTFGM25jNldQcVV1TGlvRmw0WG1RcTd3?=
 =?gb2312?B?QWlqOUhXNXgrVytSaUNSSEt1SGtiUDhWSHVZRzgzajgxcW41blREcnA5cERT?=
 =?gb2312?B?bFZPU1h1MVJVdUx3VTJuRWM0Vyt2cS9aSjJLaXBlYnhoMkdDSlp0RzNnL3FX?=
 =?gb2312?B?NGlFdlhieDZqbnRvN3dEbEsyejZROEJpM0JDU0N6ZW1YZG9PNmZZMjVFa0Np?=
 =?gb2312?B?ZWRJNmdwMjU1bk5kN2sycis1RzhLWmhWWG02azhOckN2bmdNTVVvY0cxV0Va?=
 =?gb2312?B?VFVmRDc3WkkvbjR1clhwNHZNS05KS0p5U3FKMVEwSEI4b1NEaE5jc0grdk9S?=
 =?gb2312?Q?794U=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18e9f123-3c40-4c92-f61e-08da80bd8255
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2022 02:01:04.9567
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5v9lFJLzjxXfqBFdNCWQDubDwWJvwcHE1hCLU2cn56oa3Kvb+e4+DEJRjFCpKJdAC1ZN+V0MAqu4X7HA9UtKjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5025
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQW5kcmV3IEx1bm4gPGFu
ZHJld0BsdW5uLmNoPg0KPiBTZW50OiAyMDIyxOo41MIxOMjVIDk6NDQNCj4gVG86IFdlaSBGYW5n
IDx3ZWkuZmFuZ0BueHAuY29tPg0KPiBDYzogaGthbGx3ZWl0MUBnbWFpbC5jb207IGxpbnV4QGFy
bWxpbnV4Lm9yZy51azsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsNCj4gZWR1bWF6ZXRAZ29vZ2xlLmNv
bTsga3ViYUBrZXJuZWwub3JnOyBwYWJlbmlAcmVkaGF0LmNvbTsNCj4gcm9iaCtkdEBrZXJuZWwu
b3JnOyBrcnp5c3p0b2Yua296bG93c2tpK2R0QGxpbmFyby5vcmc7IGYuZmFpbmVsbGlAZ21haWwu
Y29tOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9y
ZzsNCj4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENI
IG5ldCAxLzJdIGR0OiBhcjgwM3g6IERvY3VtZW50IGRpc2FibGUtaGliZXJuYXRpb24NCj4gcHJv
cGVydHkNCj4gDQo+ID4gWWVzLCBhZnRlciB0aGUgUEhZIGVudGVycyBoaWJlcm5hdGlvbiBtb2Rl
IHRoYXQgdGhlIFJYX0NMSyBzdG9wDQo+ID4gdGlja2luZywgYnV0IGZvciBzdG1tYWMsIGl0IGlz
IGVzc2VudGlhbCB0aGF0IFJYX0NMSyBvZiBQSFkgaXMgcHJlc2VudA0KPiA+IGZvciBzb2Z0d2Fy
ZSByZXNldCBjb21wbGV0aW9uLiBPdGhlcndpc2UsIHRoZSBzdG1tYWMgaXMgZmFpbGVkIHRvDQo+
ID4gY29tcGxldGUgdGhlIHNvZnR3YXJlIHJlc2V0IGFuZCBjYW4gbm90IGluaXQgRE1BLg0KPiAN
Cj4gU28gdGhlIFJYX0NMSyBpcyBtb3JlIHRoYW4gdGhlIHJlY292ZXJlZCBjbG9jayBmcm9tIHRo
ZSBiaXQgc3RyZWFtIG9uIHRoZQ0KPiB3aXJlLiBUaGUgUEhZIGhhcyBhIHdheSB0byBnZW5lcmF0
ZSBhIGNsb2NrIHdoZW4gdGhlcmUgaXMgbm8gYml0IHN0cmVhbT8NCj4gDQpZZXMsIHdoZW4gZGlz
YWJsZSBoaWJlcm5hdGlvbiBtb2RlLCB0aGUgUlhfQ0xLIGFsd2F5cyBvdXRwdXQgYSB2YWxpZCBj
bG9jay4NCg0KPiBUbyBtZSwgaXQgc291bmRzIGxpa2UgeW91ciBoYXJkd2FyZSBkZXNpZ24gaXMg
d3JvbmcsIGFuZCBpdCBzaG91bGQgYmUgdXNpbmcgdGhlDQo+IDI1TUh6IHJlZmVyZW5jZSBjbG9j
ay4gQW5kIHdoYXQgeW91IGFyZSBwcm9wb3NpbmcgaXMgYSB3b3JrYXJvdW5kIGZvciB0aGlzDQo+
IGhhcmR3YXJlIHByb2JsZW0uDQo+IA0KPiBBbnl3YXksIGkgYWdyZWUgd2l0aCBSdXNzZWxsLCBh
IERUIHByb3BlcnR5IGlzIGZpbmUuIEJ1dCBwbGVhc2UgbWFrZSBpdCBjbGVhciBpbg0KPiB0aGUg
YmluZGluZyBkb2N1bWVudGF0aW9uIHRoYXQgZGlzYWJsaW5nIGhpYmVybmF0aW9uIGhhcyB0aGUg
c2lkZSBhZmZlY3Qgb2YNCj4ga2VlcGluZyB0aGUgUlhfQ0xLIHRpY2tpbmcgd2hlbiB0aGVyZSBp
cyBubyBsaW5rLiBUaGF0IGlzIHByb2JhYmx5IHdoYXQgcGVvcGxlDQo+IHdhbnQgdGhpcyBmb3Is
IG5vdCB0byBhY3R1YWwgZGlzYWJsZSBoaWJlcm5hdGlvbi4NCj4gDQo+IAlBbmRyZXcNCg==
