Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA75E295B51
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 11:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2510019AbgJVJEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 05:04:06 -0400
Received: from mail-vi1eur05on2047.outbound.protection.outlook.com ([40.107.21.47]:34241
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2510013AbgJVJEF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 05:04:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bcrG73nKCOAEesDvTNV2zjQhrtKPxE8jfQz0t/wsPipI8MiQZMXnLWmOk+ZkqV55tPXhi77vBqyBfCTKGQVhE/WOi2SHv9siu87+vSEwuZCDOF2y6dq8k1VEfu6l/Z3J1hNdxgT0Y2DlgTNEh7OIDmvOi5359yFKwRw2f6nD0FzzUIHmb3rlEYyDSCm40v0wX3q5RByQCrLWADfSENQdj5QLwVm8h9PR8Vi0mIIMnzbOJFo5jZXBthxizemGd6WZRk5VUWcf16Jl8OTCoSwZgWKOEGhSaIcR31s5D94jOsTVm4T9dbAiHpwiHQkNtcjFX5GF4IeepZZkZOBay9363Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9oVNYrMfryjFUBhVyU5qXfsUmq4RaLV6VCZtKaDCAdM=;
 b=Fyr/fzn5roZVtsPTTRIj89qKW4jydsuxlTZmsMxMBdX/BiDrpQ0Eb1SgXslVWH8qml47od7r/1shy81/XsVtQAI+Z38C+BgGpqzw/O7/v6FXY4qcJsHRw1MJzT3wl4bu9yqxTFpDm5d0wOiLMG+b20FLOH8tKzNY1sBJgJKKZG0LkZIpaV/jGEKB1knWJsdPWAq/NBYgjp5OQ6VYIWlvZgECMDKbpiD1O0mk9MZGs+YDONblpnyUbFD3k+I6tpoJiAC7vgT2XndfyvsYKWJAiVlxhPmOOmBJPyrqNBlYi6fqy1AmhH0lRPadXx2fQ8bMXIMCnPC32RhbzzENEDvPwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9oVNYrMfryjFUBhVyU5qXfsUmq4RaLV6VCZtKaDCAdM=;
 b=POB6diASOAib6HBXH2dV1YNnN9RjZvOQG5Pc14JRGfMj3D8XkxgokPanRf30oqx5XrgdjEmua9Ee42PyiRwJ+gY8X5KJVsxE2qa03d0Tp93+Yv3qWtUP8LJSDFQlyK8AKF6DRF7euBGyqVPg3JyfMdXOYGz0xLscJAv/bsxBB6M=
Received: from AM8PR04MB7315.eurprd04.prod.outlook.com (2603:10a6:20b:1d4::7)
 by AM0PR04MB4084.eurprd04.prod.outlook.com (2603:10a6:208:62::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Thu, 22 Oct
 2020 09:04:01 +0000
Received: from AM8PR04MB7315.eurprd04.prod.outlook.com
 ([fe80::11e6:d413:2d3d:d271]) by AM8PR04MB7315.eurprd04.prod.outlook.com
 ([fe80::11e6:d413:2d3d:d271%6]) with mapi id 15.20.3477.028; Thu, 22 Oct 2020
 09:04:01 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Greg Ungerer <gerg@linux-m68k.org>, Andrew Lunn <andrew@lunn.ch>,
        Dave Karr <dkarr@vyex.com>,
        Clemens Gruber <clemens.gruber@pqgruber.com>
CC:     Chris Heally <cphealy@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH] net: ethernet: fec: Replace interrupt driven
 MDIO with polled IO
Thread-Topic: [EXT] Re: [PATCH] net: ethernet: fec: Replace interrupt driven
 MDIO with polled IO
Thread-Index: AQHWpoauv6yGoz1SREmyP2rAbcRdI6mfx44AgAGE0gCAAMVZAIAAwnuAgAB/zGA=
Date:   Thu, 22 Oct 2020 09:04:01 +0000
Message-ID: <AM8PR04MB731512CC1B16C307C4543B90FF1D0@AM8PR04MB7315.eurprd04.prod.outlook.com>
References: <c8143134-1df9-d3bc-8ce7-79cb71148d49@linux-m68k.org>
 <20201020024000.GV456889@lunn.ch>
 <9fa61ea8-11b4-ef3c-c04e-cb124490c9ae@linux-m68k.org>
 <20201021133758.GL139700@lunn.ch>
 <16e85e61-ed25-c6be-ed4a-4c4708e724ea@linux-m68k.org>
In-Reply-To: <16e85e61-ed25-c6be-ed4a-4c4708e724ea@linux-m68k.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux-m68k.org; dkim=none (message not signed)
 header.d=none;linux-m68k.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b85f8ac1-04cf-4a02-0b59-08d876696b2a
x-ms-traffictypediagnostic: AM0PR04MB4084:
x-microsoft-antispam-prvs: <AM0PR04MB40843AF0DFD6F6BBA9EE9055FF1D0@AM0PR04MB4084.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iOnm5xEs5m/lgmYg9fl5XXs00sWVdO5k0sNRiJdzKrncdNE4edZ18pOWCfT8fP3XBb6UbGtqFetcX+3a+cJKl1KHosSe5Jh1Z2jfSifW6iojYe/ZzsvVgwvC1qpeDnXSXYhp+FEOr4gf+A5RpVIFhnLNyur2j3nHNiqVhyhZtspdcYPvWJLLh/fwigYhc16EshhMdf5AWAPOkMmDBnrvfdbn3x7Tug1gcaA4TQNUZ5iIOQsM/oiNlTzb6zWaY/kwJVtE/yzbGR1vUi8QBsaBGmRbqSqqD+3mih1L+p6SG9RsafTnwgb3N76lgT9ND/dTPulAYGtLxlCG2+hnDs6K6Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7315.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(54906003)(26005)(316002)(4326008)(66946007)(110136005)(64756008)(7696005)(66476007)(66556008)(66446008)(55016002)(71200400001)(76116006)(5660300002)(6506007)(186003)(9686003)(8936002)(8676002)(52536014)(478600001)(86362001)(53546011)(33656002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: J2HhAOAcWrtbUwq86wWqm4+YWEYPOqaiMPytQ2s/q0Rn+fGNS0bTbooIghBWYaUO5Jry8N2b/WEvtGW4WmK5OckOPx/eNViY/YfWQCRxN5LOz1kb9TnT8PqfyP/EyX0zyzdaARIdyNRa7MXJSO1n2aHwTaqPvJZHHv5Ua9Uprt0ekJxQF2WEI6gllB/A/gqWbJklst9smkg4S6NuUxbiZPuj+kGpVaubAU8xLuKUwsWQTQ+Ix693TMrwXf6a/np7NgBZ0EdB3cTcVfrZfRyLitSJfKTbYv5VjgmAXk/ujR1gcXHjW8EyLHHicQ9q9qSUdaLxaF58SQRTYRA4630tqcLkTwy0Rl2mJJ4al0YRM99o82r5zqbY6KA5gdvgTDIRNVebLYAvn79mUcnHqEIlgchXoHBkAOfhi7ZciWANDn4rl4J13SRnHspoLqk8Uh39S6A8lv8VYDtNRtjnDyFe9KXetlelfDXrABrsORLTa85pnHt4OzgJu19MhZRZiX5VB5xZ+tXPqqmGhspU/Hk4H43lX6BiOoKp33xHqxKQsHXEifDx8L/2cFWU7SAa5e7M26PNOzJTpSNzDQOY2VKp2Go9i6oF3osrWou3jb+AesZzZKs5wA5JbVaYVE68D7Zic7T+zvkD6kjteZORrQWG7Q==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7315.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b85f8ac1-04cf-4a02-0b59-08d876696b2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2020 09:04:01.3077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KxvJa6He1y0bNo6fr7/zICUENJCYx38lbMTZC9X/fLLg+V5SwqcaJo7x+KrX7aujfSLmbNSBGZpG6TnHf/tIGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4084
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogR3JlZyBVbmdlcmVyIDxnZXJnQGxpbnV4LW02OGsub3JnPiBTZW50OiBUaHVyc2RheSwg
T2N0b2JlciAyMiwgMjAyMCA5OjE0IEFNDQo+IEhpIEFuZHJldywNCj4gDQo+IE9uIDIxLzEwLzIw
IDExOjM3IHBtLCBBbmRyZXcgTHVubiB3cm90ZToNCj4gPj4gKyAgICBpZiAoZmVwLT5xdWlya3Mg
JiBGRUNfUVVJUktfQ0xFQVJfU0VUVVBfTUlJKSB7DQo+ID4+ICsgICAgICAgICAgICAvKiBDbGVh
ciBNTUZSIHRvIGF2b2lkIHRvIGdlbmVyYXRlIE1JSSBldmVudCBieSB3cml0aW5nDQo+IE1TQ1Iu
DQo+ID4+ICsgICAgICAgICAgICAgKiBNSUkgZXZlbnQgZ2VuZXJhdGlvbiBjb25kaXRpb246DQo+
ID4+ICsgICAgICAgICAgICAgKiAtIHdyaXRpbmcgTVNDUjoNCj4gPj4gKyAgICAgICAgICAgICAq
ICAgICAgLSBtbWZyWzMxOjBdX25vdF96ZXJvICYgbXNjcls3OjBdX2lzX3plcm8gJg0KPiA+PiAr
ICAgICAgICAgICAgICogICAgICAgIG1zY3JfcmVnX2RhdGFfaW5bNzowXSAhPSAwDQo+ID4+ICsg
ICAgICAgICAgICAgKiAtIHdyaXRpbmcgTU1GUjoNCj4gPj4gKyAgICAgICAgICAgICAqICAgICAg
LSBtc2NyWzc6MF1fbm90X3plcm8NCj4gPj4gKyAgICAgICAgICAgICAqLw0KPiA+PiArICAgICAg
ICAgICAgd3JpdGVsKDAsIGZlcC0+aHdwICsgRkVDX01JSV9EQVRBKTsNCj4gPj4gKyAgICB9DQo+
ID4NCj4gPiBIaSBHcmVnDQo+ID4NCj4gPiBUaGUgbGFzdCB0aW1lIHdlIGRpc2N1c3NlZCB0aGlz
LCB3ZSBkZWNpZGVkIHRoYXQgaWYgeW91IGNhbm5vdCBkbyB0aGUNCj4gPiBxdWlyaywgeW91IG5l
ZWQgdG8gd2FpdCBhcm91bmQgZm9yIGFuIE1ESU8gaW50ZXJydXB0LCBlLmcuIGNhbGwNCj4gPiBm
ZWNfZW5ldF9tZGlvX3dhaXQoKSBhZnRlciBzZXR0aW5nIEZFQ19NSUlfU1BFRUQgcmVnaXN0ZXIu
DQo+ID4NCj4gPj4NCj4gPj4gICAgICB3cml0ZWwoZmVwLT5waHlfc3BlZWQsIGZlcC0+aHdwICsg
RkVDX01JSV9TUEVFRCk7DQo+IA0KPiBUaGUgY29kZSBmb2xsb3dpbmcgdGhpcyBpczoNCj4gDQo+
ICAgICAgICAgIHdyaXRlbChmZXAtPnBoeV9zcGVlZCwgZmVwLT5od3AgKyBGRUNfTUlJX1NQRUVE
KTsNCj4gDQo+ICAgICAgICAgIC8qIENsZWFyIGFueSBwZW5kaW5nIHRyYW5zYWN0aW9uIGNvbXBs
ZXRlIGluZGljYXRpb24gKi8NCj4gICAgICAgICAgd3JpdGVsKEZFQ19FTkVUX01JSSwgZmVwLT5o
d3AgKyBGRUNfSUVWRU5UKTsNCj4gDQo+IA0KPiBTbyB0aGlzIGlzIGZvcmNpbmcgYSBjbGVhciBv
ZiB0aGUgZXZlbnQgaGVyZS4gSXMgdGhhdCBub3QgZ29vZCBlbm91Z2g/DQo+IA0KPiBGb3IgbWUg
b24gbXkgQ29sZEZpcmUgdGVzdCB0YXJnZXQgSSBhbHdheXMgZ2V0IGEgdGltZW91dCBpZiBJIHdh
aXQgZm9yIGENCj4gRkVDX0lFVkVOVCBhZnRlciB0aGUgRkVDX01JSV9TUEVFRCB3cml0ZS4NCj4g
DQo+IFJlZ2FyZHMNCj4gR3JlZw0KDQpEYXZlIEthcnIncyBsYXN0IHBhdGNoIGNhbiBmaXggdGhl
IGlzc3VlLCBidXQgaXQgbWF5IGludHJvZHVjZSAzMG1zIGRlbGF5IGR1cmluZyBib290Lg0KR3Jl
ZydzIHBhdGNoIGlzIHRvIGFkZCBxdWlyayBmbGFnIHRvIGRpc3Rpbmd1aXNoIHBsYXRmb3JtIGJl
Zm9yZSBjbGVhcmluZyBtbWZyIG9wZXJhdGlvbiwNCndoaWNoIGFsc28gY2FuIGZpeCB0aGUgaXNz
dWUuIA0KDQpBbmR5DQo=
