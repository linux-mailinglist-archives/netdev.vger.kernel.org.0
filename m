Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA0363D4CC
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 12:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235076AbiK3LlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 06:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235114AbiK3Lk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 06:40:57 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2045.outbound.protection.outlook.com [40.107.14.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C29AC2EF23;
        Wed, 30 Nov 2022 03:40:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WR2Pz55dQTGheZumMuE2YaOVFbdYhPrYI5l5ysBje0FPgQwuF8x/myFLR+paB3in/sXLLBvXhMlrXK3n0a3pNFzc1mGRt0nlJd7VOnYn1bvef/1uhwPti+ryw0MJ6DWk0tfHwZbB7uBWXGbrB7Q1fZYyPalmg7qdtXE2/tT73q0GiaJ9payRDvDZT5Ch1Ojb3CA13rRPzCg6hsx64HfgqFUlKqUSnlel8jCNbnzOnwMme6CYWtgpom51xC3afdrfMipt5Aa3U4u0AnMquclRpDrulhGNJN6V5PMhDLLQslBSJWpDoJuxjgMFX+OWtlze2VnGv2m22PXJos9ofazapw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=STa/2m5+sK/qiI8VYbN/NlS+rlNRXIjZ81FrQ0uNiGo=;
 b=XZYZPj3Jcdg0AN870PRAc4PfPOBOATvr3shJz0QWKN7K4iYJvzSISlumcPaQSUz4yXIVwdksYti+yEFrp700XdxKoNRTzLcZswaAspZ5d7JGjCUQIA9ezenuSrFLzsrebmGJpla7VWXYmBfY73/KlHASRfRTsZIpdZWItcUgDTi7ozIXsmz7fu++Pbx1A/B5EMUtl416dA//JrZeCF+jL7YU3y54jggb4RdX7wqQK8PfWjtPGo1bKDyJnqhR2XVLRt8hLHwuMTOuqJNxZEsIHgg/+cNPjp1wMFJtKtd6EyeyEgXBIFEiSjDzbO673iQmzPwrOCn3T/ux5F5AsJhVIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=STa/2m5+sK/qiI8VYbN/NlS+rlNRXIjZ81FrQ0uNiGo=;
 b=Z0OOidr3SeqnrMRbw2OZPMGsAp3K66SSZZgi1s4v+79nokREtk6EYW12nBupR4ngj7nJUdJ57Cb7AOOazGbUkM6SD4ojB9ddUl/TK140ASBiLV6xVR6yNHWch90MafAjYJgO4Ev+wFuj1WCVhOnr1xz1iRRbZdwneueaCyZJKRY=
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com (2603:10a6:3:db::18)
 by PAXPR04MB8375.eurprd04.prod.outlook.com (2603:10a6:102:1be::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Wed, 30 Nov
 2022 11:40:54 +0000
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::7682:a2e6:b891:2f4d]) by HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::7682:a2e6:b891:2f4d%10]) with mapi id 15.20.5857.023; Wed, 30 Nov
 2022 11:40:54 +0000
From:   Clark Wang <xiaoning.wang@nxp.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] net: phylink: add sync flag mac_ready to fix resume
 issue with WoL enabled
Thread-Topic: [PATCH 1/2] net: phylink: add sync flag mac_ready to fix resume
 issue with WoL enabled
Thread-Index: AQHZBKyo4U8XamUbok2HUhpB4yX+kq5XUw0AgAACeACAAAHg4A==
Date:   Wed, 30 Nov 2022 11:40:54 +0000
Message-ID: <HE1PR0402MB29392253DB80AEB2C984D0A5F3159@HE1PR0402MB2939.eurprd04.prod.outlook.com>
References: <20221130111148.1064475-1-xiaoning.wang@nxp.com>
 <20221130111148.1064475-2-xiaoning.wang@nxp.com>
 <Y4c9PlfEC17pVE08@shell.armlinux.org.uk>
 <Y4c/UCHxIWZQVwi6@shell.armlinux.org.uk>
In-Reply-To: <Y4c/UCHxIWZQVwi6@shell.armlinux.org.uk>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: HE1PR0402MB2939:EE_|PAXPR04MB8375:EE_
x-ms-office365-filtering-correlation-id: c8731c4f-170b-44ba-0733-08dad2c7bd55
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3ODtJZRdt5/6ns5sTSQVynRC0VLlMg1eSFblTQnsebfUWcshPQFOdToEeUd95TS3wtgy4hdDQL2jrIz+JEh8OTxftHiAkMBU3c8u2TqYoYkJCRfDIinTBIyWW9YndczRB//272Jazumop2AeogR2+HXQEwc6f2cPGUc4paPrFb9HLEXCtEpglbUugES47RQ5mZ+AY6EaWZftO2rN7ZcUj5Ipq2f5Q8e0ojsQhemu/aDhXP1047Yf6FfCSbhnWM7n3WesVlZM43DzlZ3vxaNJiA7KmlHDVzONbFCt6zfNLzYOp41DLWV2a8AlYmng9xnn6CBzF0ssSht8R9R3hGYMuS6sXj22V+2trp3F691W09NRXdP7QXGHCsrkE0wDl/abO/wb6JoYHPkVgia40Y5WhOagUfPUNVKb0aQA6y1wqENzPO3HBqNk2Xtzlv94tIu6cZhHzpxPyxdaa2taTltfLeWBs52TJ8WLAcY1SvNTBdMUHLERUg6donAdXMnnoh4jBIDLGEUVailPydjZuZ21E3J5ocRDVSq/bzO475QipvWd5YOrHUkMMlLv69d5fFjW5zWtrIi8QxYw1Y7Ef2vO5XGQNJMcmKVAKL8rBVmk4eEeR8YETD5SoAp0C9zf5C8AbOMijZ6/ip39VtYnzAUOnVjWcI6C9koWMwHOO9rMPSeut7lIA3RdGBQoPpGTJKiEK0xsrfEp1QkrSp0jkNiWzAsa7jNe8YBmQJ8yOGYchsk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2939.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(136003)(396003)(376002)(366004)(451199015)(53546011)(71200400001)(26005)(122000001)(45080400002)(9686003)(478600001)(64756008)(38100700002)(966005)(6506007)(66476007)(66446008)(41300700001)(66946007)(76116006)(7696005)(8676002)(33656002)(66556008)(4326008)(86362001)(52536014)(38070700005)(55016003)(316002)(7416002)(54906003)(6916009)(8936002)(5660300002)(186003)(83380400001)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?OGNJM0VzbTg2QnpsMEt1QkJ4bXpoZ0JVN1VZeVJEY2w1UVlNQjFMZW1WTzh0?=
 =?gb2312?B?cjRqVDJMa0UvS2QzN2tWekMwUjM5V1FUblo0NENwVk94dng1bUp5alFiN1dq?=
 =?gb2312?B?WGlvNXhBQnJnbUxaeGo3cEo4ZDBuZVN2N3AxUFJXZ2RtN1BxTFBiaG9ldmtj?=
 =?gb2312?B?ZlEwZnB0U2FGb09OM01IN1daMzBKSFBkR1hUVDBxMjY2VndVUVJKQStGY2tt?=
 =?gb2312?B?MWxod2d5SFVlRkFWUFlaV2pzQjhRMnYvUE9Sb2dIVTMzaGs5NURZMUVwNUxX?=
 =?gb2312?B?WHBNNHlabEk0LzN1Mk10QzZvNUZaYkRSNFdxK0c1UWowWTNIeFI1OFNUcjN6?=
 =?gb2312?B?MFF4cFJOVlJ6ZGJaOHBCbElndjNwNHMwK0pMMkh5bUFsdWxmNkpTRnN3L0J6?=
 =?gb2312?B?cDN0bVQzRmxUeW53MUd5UklTWVZuWXIzUWpnR3BjSGtjVEZFTmdXMmI2ZVkx?=
 =?gb2312?B?WUlRQm15T05xajBZMnZ1bDVNWDBVam9JWFJ1ZjBDS25hMndsdXllZkdTZlkr?=
 =?gb2312?B?SG5WWmM1YnlOZVU4bnpOSmdHNmZrNlUwUFZQUEp6Q3oyK2RlWjJNTkNQKzdn?=
 =?gb2312?B?cVd3d1dnMzM5QjQ1SHNFTWVkNjZiMHdDZEFRY2ZGRk9VWjN3QVV3aVJ1WFh3?=
 =?gb2312?B?cS9LY0h3ZUdxcHNMY0ZVeW1SYjRPdjdzSFh5UlVvT3NCeGNhTDF5eE04V3Z1?=
 =?gb2312?B?bDlEVkYzSXJWQUNEUWl3RUNXMXdUU2xyeitDVXkvcGxOUEVKRVVzQXJYVW12?=
 =?gb2312?B?bzErK0NYWENZZW04ZnRuM2lYK2x4Yk5hdzI2cVhhcWJ5SDlORlFtaHJudCsx?=
 =?gb2312?B?Y09LU2ZZTHlTMDNFaUJlYjBPOVB3Ynhnbzc3aXA3K1ZrM3puNzJiQ2syc1hq?=
 =?gb2312?B?Z3ZLQWphc05hd2xqa3NPeFZIWTZUdTVVemtXOU05Y2VVVzhxTGZ5MTNKWmpt?=
 =?gb2312?B?eEZkR2RXN2c3ejlaekQ1ZGZGRDVPVWdJTEtrQjhjMkhSdDZEbFJTM2VFUzkw?=
 =?gb2312?B?anR5eWU0aWJCWDRVRnhUb1Z1enNvTm5vblpMR3ErWFZnQ3VBa01FUzhCcWhG?=
 =?gb2312?B?anJLcTZsRTEzUUdmektCSklFUDErdm9DbHlZZ3o2dVNtbHRHcWpiaUZxLzFk?=
 =?gb2312?B?alBWSHVPaXphWmhpdzRhM1JOMWpPaFFyOFpUcjhNY213VFkwb0RNSm1kNVVV?=
 =?gb2312?B?dlZTMXVuZWtLWTBCZGJIOUV1dFVvQWQ1aVJBWXV6TVFTTzRwTXhtdDJOVHpU?=
 =?gb2312?B?cGMvRzdBK2tjenBzYXBqMWdXdGJvbzhYdWpNeEZkQitORlpNQ25IVFJiYldq?=
 =?gb2312?B?QUZWNUFMdGc0cTBDT3Zwa3FGa2FyV2hLYW80QjhYUmFPTnRxakVzS3poV1Rl?=
 =?gb2312?B?NjZxTEszN0FLVUpKbVYwN2J6aFZ5MjNOaDJsdHNsRGxGQjJqSmp3cFFrYVZV?=
 =?gb2312?B?M3UxTVR2ZTFMamtwcnJQbUhVYWlaanl5eXV4ek13VHRlYVE1WUd1ZTk3TktY?=
 =?gb2312?B?WS9qZ254SHhkcnpzNG1ZWWVUL2lwRU93cmlUUlhqVTJ5SkRLbU5uZUlZak9q?=
 =?gb2312?B?VVN4ZWZmeVV2Nk4vdEI3NmsycW50VVZWNThnNFNLL2lpaEljOXpudkJ4T3hY?=
 =?gb2312?B?MTlhQTBxaVpHWkZDQVMydGRzY0pxcG1BalR2MVo3KzNxemIxeTN2aklMVlY0?=
 =?gb2312?B?TjRwOGF3dTUrREhsLzBJTkNMQkEyYmVhY0ZtcDRBVnZtT1EvYk9ac0V1SUYr?=
 =?gb2312?B?RDJMRlNINkxkaE44dDJTb1ArcFZzdnZ1RkZGeVhZZ2x5cDZuSWw4c080L1pU?=
 =?gb2312?B?M0h6NEhscjV3cFROTy94M1oyT1ZHeUthM3Z0ODkyY0lPdGJXdG9oQktSclZp?=
 =?gb2312?B?RXRHeDBITmhOc2x6ZzQyT0xqUDZyK0x1Y3NQYWlPdlRZNEJvK3NacHlWbVR0?=
 =?gb2312?B?ZVIvTmFKd3NuRzQ2QzdpQ3h4NFdCaXpYOFlONzltb0dla3k0Q05LVm1scDl3?=
 =?gb2312?B?TjBLV3BkK2g1eXZwS2ZjN3IvTWhhdWt5dFI0WG9xM0lWNHlTSWNueDlsSXJP?=
 =?gb2312?B?YURSMjVHamc3d0RESk9hd0FPOXY2N1RRcXJUMm9RY284S3ZRaFY1TzJHN1Yy?=
 =?gb2312?Q?a96DQbfeKnsRftrgnlQBaNaT4?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB2939.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8731c4f-170b-44ba-0733-08dad2c7bd55
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2022 11:40:54.2668
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YPGLVVPCFBTC1rLsxXuXSalvqQF2WIptyaqeLyL9UeoOMEPXJFK6NilYhsvzoutu0/sD8jyMwWZr2Vjn0lW28w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8375
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFJ1c3NlbGwgS2luZyA8bGlu
dXhAYXJtbGludXgub3JnLnVrPg0KPiBTZW50OiAyMDIyxOoxMdTCMzDI1SAxOTozMw0KPiBUbzog
Q2xhcmsgV2FuZyA8eGlhb25pbmcud2FuZ0BueHAuY29tPg0KPiBDYzogcGVwcGUuY2F2YWxsYXJv
QHN0LmNvbTsgYWxleGFuZHJlLnRvcmd1ZUBmb3NzLnN0LmNvbTsNCj4gam9hYnJldUBzeW5vcHN5
cy5jb207IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGVkdW1hemV0QGdvb2dsZS5jb207DQo+IGt1YmFA
a2VybmVsLm9yZzsgcGFiZW5pQHJlZGhhdC5jb207IG1jb3F1ZWxpbi5zdG0zMkBnbWFpbC5jb207
DQo+IGFuZHJld0BsdW5uLmNoOyBoa2FsbHdlaXQxQGdtYWlsLmNvbTsgbmV0ZGV2QHZnZXIua2Vy
bmVsLm9yZzsNCj4gbGludXgtc3RtMzJAc3QtbWQtbWFpbG1hbi5zdG9ybXJlcGx5LmNvbTsNCj4g
bGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnOyBsaW51eC1rZXJuZWxAdmdlci5r
ZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMS8yXSBuZXQ6IHBoeWxpbms6IGFkZCBz
eW5jIGZsYWcgbWFjX3JlYWR5IHRvIGZpeCByZXN1bWUNCj4gaXNzdWUgd2l0aCBXb0wgZW5hYmxl
ZA0KPiANCj4gT24gV2VkLCBOb3YgMzAsIDIwMjIgYXQgMTE6MjM6NDJBTSArMDAwMCwgUnVzc2Vs
bCBLaW5nIChPcmFjbGUpIHdyb3RlOg0KPiA+IE9uIFdlZCwgTm92IDMwLCAyMDIyIGF0IDA3OjEx
OjQ3UE0gKzA4MDAsIENsYXJrIFdhbmcgd3JvdGU6DQo+ID4gPiBJc3N1ZSB3ZSBtZXQ6DQo+ID4g
PiBPbiBzb21lIHBsYXRmb3JtcywgbWFjIGNhbm5vdCB3b3JrIGFmdGVyIHJlc3VtZWQgZnJvbSB0
aGUgc3VzcGVuZA0KPiA+ID4gd2l0aCBXb0wgZW5hYmxlZC4NCj4gPiA+DQo+ID4gPiBUaGUgY2F1
c2Ugb2YgdGhlIGlzc3VlOg0KPiA+ID4gMS4gcGh5bGlua19yZXNvbHZlKCkgaXMgaW4gYSB3b3Jr
cXVldWUgd2hpY2ggd2lsbCBub3QgYmUgZXhlY3V0ZWQNCj4gaW1tZWRpYXRlbHkuDQo+ID4gPiAg
ICBUaGlzIGlzIHRoZSBjYWxsIHNlcXVlbmNlOg0KPiA+ID4gICAgICAgIHBoeWxpbmtfcmVzb2x2
ZSgpLT5waHlsaW5rX2xpbmtfdXAoKS0+cGwtPm1hY19vcHMtPm1hY19saW5rX3VwKCkNCj4gPiA+
ICAgIEZvciBzdG1tYWMgZHJpdmVyLCBtYWNfbGlua191cCgpIHdpbGwgc2V0IHRoZSBjb3JyZWN0
IHNwZWVkL2R1cGxleC4uLg0KPiA+ID4gICAgdmFsdWVzIHdoaWNoIGFyZSBmcm9tIGxpbmtfc3Rh
dGUuDQo+ID4gPiAyLiBJbiBzdG1tYWNfcmVzdW1lKCksIGl0IHdpbGwgY2FsbCBzdG1tYWNfaHdf
c2V0dXAoKSBhZnRlciBjYWxsZWQgdGhlDQo+ID4gPiAgICBwaHlsaW5rX3Jlc3VtZSgpLiBzdG1t
YWNfY29yZV9pbml0KCkgaXMgY2FsbGVkIGluIGZ1bmN0aW9uDQo+ID4gPiBzdG1tYWNfaHdfc2V0
dXAoKSwNCj4gPg0KPiA+IC4uLiBhbmQgdGhhdCBpcyB3aGVyZSB0aGUgcHJvYmxlbSBpcy4gRG9u
J3QgY2FsbCBwaHlsaW5rX3Jlc3VtZSgpDQo+ID4gYmVmb3JlIHlvdXIgaGFyZHdhcmUgaXMgcmVh
ZHkgdG8gc2VlIGEgbGluay11cCBldmVudC4NCj4gDQo+IC4uLiBhbmQgd2hpbGUgdGhhdCBpcyBi
ZWluZyBmaXhlZCwgbWF5YmUgdGhlIHN0dXBpZCBjb2RlIGluDQo+IHN0bW1hY19yZXN1bWUoKSBj
YW4gYWxzbyBiZSBmaXhlZDoNCj4gDQo+ICAgICAgICAgcnRubF9sb2NrKCk7DQo+ICAgICAgICAg
aWYgKGRldmljZV9tYXlfd2FrZXVwKHByaXYtPmRldmljZSkgJiYgcHJpdi0+cGxhdC0+cG10KSB7
DQo+ICAgICAgICAgICAgICAgICBwaHlsaW5rX3Jlc3VtZShwcml2LT5waHlsaW5rKTsNCj4gICAg
ICAgICB9IGVsc2Ugew0KPiAgICAgICAgICAgICAgICAgcGh5bGlua19yZXN1bWUocHJpdi0+cGh5
bGluayk7DQo+ICAgICAgICAgICAgICAgICBpZiAoZGV2aWNlX21heV93YWtldXAocHJpdi0+ZGV2
aWNlKSkNCj4gICAgICAgICAgICAgICAgICAgICAgICAgcGh5bGlua19zcGVlZF91cChwcml2LT5w
aHlsaW5rKTsNCj4gICAgICAgICB9DQo+ICAgICAgICAgcnRubF91bmxvY2soKTsNCj4gDQo+ICAg
ICAgICAgcnRubF9sb2NrKCk7DQo+IA0KPiAxLiBwaHlsaW5rX3Jlc3VtZSgpIGlzIGFsd2F5cyBj
YWxsZWQgYWZ0ZXIgdGhhdCBmaXJzdCBydG5sX2xvY2soKSwgc28gdGhlcmUncyBubw0KPiBwb2lu
dCBpdCBiZWluZyBzdHVwaWRseSBpbiBlYWNoIHNpZGUgb2YgdGhlIGlmKCkuDQo+IA0KPiAyLiB0
aGUgcnRubF91bmxvY2soKSBmb2xsb3dlZCBieSBydG5sX2xvY2soKSBpcyBjb21wbGV0ZWx5IHVu
bmVjZXNzYXJ5Lg0KPiANCj4gVGhhbmtzLg0KPiANCg0KVGhhbmtzIGZvciB5b3VyIHJlbWluZGVy
LCBJIHdpbGwgc2VuZCBhbm90aGVyIHBhdGNoIHRvIGNsZWFuIHRoaXMuDQpTb3JyeSwgdGhlIGxh
c3QgZW1wdHkgZW1haWwgd2FzIHNlbnQgYnkgbWlzdGFrZS4NCg0KQmVzdCBSZWdhcmRzLA0KQ2xh
cmsgV2FuZw0KDQo+IC0tDQo+IFJNSydzIFBhdGNoIHN5c3RlbToNCj4gaHR0cHM6Ly9ldXIwMS5z
YWZlbGlua3MucHJvdGVjdGlvbi5vdXRsb29rLmNvbS8/dXJsPWh0dHBzJTNBJTJGJTJGd3d3LmFy
DQo+IG1saW51eC5vcmcudWslMkZkZXZlbG9wZXIlMkZwYXRjaGVzJTJGJmFtcDtkYXRhPTA1JTdD
MDElN0N4aWFvbmluZy4NCj4gd2FuZyU0MG54cC5jb20lN0NjMDk2MWZhMTc1ODk0NjRhNzQyMzA4
ZGFkMmM2OTUwMiU3QzY4NmVhMWQzYmMyDQo+IGI0YzZmYTkyY2Q5OWM1YzMwMTYzNSU3QzAlN0Mw
JTdDNjM4MDU0MDQ3NTkzMDY2OTQ5JTdDVW5rbm93biUNCj4gN0NUV0ZwYkdac2IzZDhleUpXSWpv
aU1DNHdMakF3TURBaUxDSlFJam9pVjJsdU16SWlMQ0pCVGlJNklrMWhhV3dpDQo+IExDSlhWQ0k2
TW4wJTNEJTdDMzAwMCU3QyU3QyU3QyZhbXA7c2RhdGE9d1VSa1R4aEsySWxxa3RPS21KengNCj4g
TnI4RTRLQ3pkMWdqRGdISzNpU3k2RUElM0QmYW1wO3Jlc2VydmVkPTANCj4gRlRUUCBpcyBoZXJl
ISA0ME1icHMgZG93biAxME1icHMgdXAuIERlY2VudCBjb25uZWN0aXZpdHkgYXQgbGFzdCENCg==
