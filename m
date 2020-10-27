Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1418829A23C
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 02:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411633AbgJ0BdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 21:33:19 -0400
Received: from mail-am6eur05on2055.outbound.protection.outlook.com ([40.107.22.55]:29569
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390906AbgJ0BdS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 21:33:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TVXYfq7rrCc3JgiVkIwLTgV3bzVHvDLrAu0Blume+rF7TuQgc3faDpmBZFbgI/q9iVdiu7ESgfgOA0Tk9BbVsGr61y8oR71HghXxvmviZ6ikrTuvWDvL10kMihhobFCqWqD7sTZqEHov/eLmrmJZQLnuZXPfRbfxDTE4I+NCQspkqx16pqLP7mSv6iIOBWuT4kptxH0Voq/XNCVJUDai6RPIZ7GRdyP8kZd2cnpdeAenmm/oLhZnwXg1fPtsuCJxp5H8z+nFYKPzzqUGvA8iUXmxWBuz6C0ugL6fIQpEuThvLrbe65FgVtOc7HTBwg5yKHo6Zj+lvs++oUzhz37F6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DkW0/MmSy4mhlnrsnL+Hlc1aSbtN+u1wwpQTMXGPnTQ=;
 b=jbDz4yyA3/qzSDUTJGWOy5V4mx4Ro170I7F2ktW5+rtPswu4vnc1gwT1pHGL+6LT5uIVRiq5vL3T26I4NTNCCLbkKbiZ7li5Tz22LOwOOHWKyY8hqZKwLtwIdlPqu0WVWPIDFhg3CgPb+6tzfHOVU/NcX9nNM7VyEmXSli2If9grsGa7nPSoh7Xa9a6Kt1Jc8lRAbTNUkqbre4NTcV5iyeuxYKL+aKJ+bFtpkGb+qfZGYa4IOGq2lx71GuG57wUhc4PiUG0IZZqMY+AiGO5nP5+bjAX3y6y3W/CF4k8JhXtLJdkvq38oQxEioyAkrQUa+twHjcRan7+A7jyCMzoi4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DkW0/MmSy4mhlnrsnL+Hlc1aSbtN+u1wwpQTMXGPnTQ=;
 b=dNqTm3vJSQtm0OnVsUcegT+fDCGHKADnde7Ilal0s2QkHPSkja5B441udEeAveDwcQe6j4/5w84FitYU1A53gaigg6SRjh2dePNr1ipXedunGXwzWUemsLsD90yH6QOY4+mx5eKw87CGPqTqlP+ZI94l642nB6qBSlveLCvj1LI=
Received: from AM8PR04MB7315.eurprd04.prod.outlook.com (2603:10a6:20b:1d4::7)
 by AM0PR04MB6129.eurprd04.prod.outlook.com (2603:10a6:208:13d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Tue, 27 Oct
 2020 01:33:14 +0000
Received: from AM8PR04MB7315.eurprd04.prod.outlook.com
 ([fe80::11e6:d413:2d3d:d271]) by AM8PR04MB7315.eurprd04.prod.outlook.com
 ([fe80::11e6:d413:2d3d:d271%6]) with mapi id 15.20.3477.028; Tue, 27 Oct 2020
 01:33:14 +0000
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
Thread-Index: AQHWpoauv6yGoz1SREmyP2rAbcRdI6mfx44AgAGE0gCAAMVZAIAAwnuAgAB/zGCAB0wQAIAAFNVg
Date:   Tue, 27 Oct 2020 01:33:14 +0000
Message-ID: <AM8PR04MB73156F7ADC1446023E0D9C8EFF160@AM8PR04MB7315.eurprd04.prod.outlook.com>
References: <c8143134-1df9-d3bc-8ce7-79cb71148d49@linux-m68k.org>
 <20201020024000.GV456889@lunn.ch>
 <9fa61ea8-11b4-ef3c-c04e-cb124490c9ae@linux-m68k.org>
 <20201021133758.GL139700@lunn.ch>
 <16e85e61-ed25-c6be-ed4a-4c4708e724ea@linux-m68k.org>
 <AM8PR04MB731512CC1B16C307C4543B90FF1D0@AM8PR04MB7315.eurprd04.prod.outlook.com>
 <a1f62ee2-3013-50fe-4069-e63f87a984ce@linux-m68k.org>
In-Reply-To: <a1f62ee2-3013-50fe-4069-e63f87a984ce@linux-m68k.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux-m68k.org; dkim=none (message not signed)
 header.d=none;linux-m68k.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bbe7a6d2-0743-4318-70d7-08d87a1845ea
x-ms-traffictypediagnostic: AM0PR04MB6129:
x-microsoft-antispam-prvs: <AM0PR04MB612924432D052602994F09FBFF160@AM0PR04MB6129.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oVIV8Rk4EAOHZfP28b898ptBpWo4hCh1Q3MBiqYkKLx9D7oCHVRJrhYA22POMLzvzKn9wG+HvooOynoMQo7F0WVBz+nHHhlFTFRXQ2tb1uyY51cdGuTXhjO+yz/ivjYyeyoz3TDbc5TOm5LMtfB5cIQVaufqK1bRs7TQtUgSQNJWA2R75Y0dWL4BLELeAldQLuBlzInxirn7HFF6o+6xzkPnAOr4U2FnLBwAs4Ohh/Kp3ZUlet7lLwZajNut7cUkKznhYBpfK/oYO36W3XYHmBiuhtNJdd+30iIZ/JpVqhcLDEteYsWxFY5ajhHHfWoKbng94Pnzr8/E8hUHxVZ4HA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7315.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(346002)(376002)(136003)(26005)(33656002)(316002)(71200400001)(186003)(5660300002)(6506007)(53546011)(7696005)(86362001)(66556008)(478600001)(4326008)(66946007)(66446008)(2906002)(8936002)(66476007)(55016002)(76116006)(9686003)(52536014)(64756008)(8676002)(54906003)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: MEA4Xi/k7b2sw/HYEVp56kK1ezH3QxXNBi5hqvLEcjRhxS6/OOBBJB1+kqZlq6p57zbMlDGdQSIOzHDr72xfIh5eplX0JgoVRLp2LNsxXntdg4cT0DqkGuo4nzTFa0SD7+WWmwDI1pGtbkQh1xlS3+YJWHvu6i+wDUFM/0gU7EZDCn+211QbZpqXXu3FC/x4Z+Ya11VjYzIJESXm7AzPXfYfets1ZuBpdBN+SCS+MXf30Ri7A7+Y+1DnABcog5wYL8RKn1o/BiFptjEFlRvPBqQd4VO5eS/Mro0/5as80NIPvimoeGF43kfyXQQwMWR6KidYMWzrf3DdUltsbSL7aVIF0A/271tuTRQDOBJ7e6+9cYfG5MOIMbeVoT2ApSfk7yQGNp8TShH9+7aa0IgRSSwixPAn19gSTR5R2AKbc/eRXuoB6jCRGA91k7HmwcL74uOCC99AMD0bXOXEV5uVjr0xVa8qufPGo/5Egz4zclIfudRyHPiJHeWEmoWRr+V4NAorc7nZnCCIxMlPvQgFxIPwrZtG8bxwT8pjDKkKvnB0qc4iXuWYOsyuzRKcOSpbEdshJK30PmALTyNmNuDNzaD4tu7HxECYXnRmGy6TKZkQKzYt2WN60kX7Tac5P3dJBMS4gcdNuEBrTk098KDLWg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7315.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbe7a6d2-0743-4318-70d7-08d87a1845ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2020 01:33:14.3118
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9360ZZO68a4P9w36SSpL6UiI4muRFN6czGpj4+7NcXwwRcF7VXl9IWmZ0hv7GTGkP1z5BXD9rVWUw7Nk9xv+Jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6129
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogR3JlZyBVbmdlcmVyIDxnZXJnQGxpbnV4LW02OGsub3JnPiBTZW50OiBUdWVzZGF5LCBP
Y3RvYmVyIDI3LCAyMDIwIDg6MTggQU0NCj4gSGkgQW5keSwNCj4gDQo+IE9uIDIyLzEwLzIwIDc6
MDQgcG0sIEFuZHkgRHVhbiB3cm90ZToNCj4gPiBGcm9tOiBHcmVnIFVuZ2VyZXIgPGdlcmdAbGlu
dXgtbTY4ay5vcmc+IFNlbnQ6IFRodXJzZGF5LCBPY3RvYmVyIDIyLA0KPiA+IDIwMjAgOToxNCBB
TQ0KPiA+PiBIaSBBbmRyZXcsDQo+ID4+DQo+ID4+IE9uIDIxLzEwLzIwIDExOjM3IHBtLCBBbmRy
ZXcgTHVubiB3cm90ZToNCj4gPj4+PiArICAgIGlmIChmZXAtPnF1aXJrcyAmIEZFQ19RVUlSS19D
TEVBUl9TRVRVUF9NSUkpIHsNCj4gPj4+PiArICAgICAgICAgICAgLyogQ2xlYXIgTU1GUiB0byBh
dm9pZCB0byBnZW5lcmF0ZSBNSUkgZXZlbnQgYnkNCj4gPj4+PiArIHdyaXRpbmcNCj4gPj4gTVND
Ui4NCj4gPj4+PiArICAgICAgICAgICAgICogTUlJIGV2ZW50IGdlbmVyYXRpb24gY29uZGl0aW9u
Og0KPiA+Pj4+ICsgICAgICAgICAgICAgKiAtIHdyaXRpbmcgTVNDUjoNCj4gPj4+PiArICAgICAg
ICAgICAgICogICAgICAtIG1tZnJbMzE6MF1fbm90X3plcm8gJiBtc2NyWzc6MF1faXNfemVybyAm
DQo+ID4+Pj4gKyAgICAgICAgICAgICAqICAgICAgICBtc2NyX3JlZ19kYXRhX2luWzc6MF0gIT0g
MA0KPiA+Pj4+ICsgICAgICAgICAgICAgKiAtIHdyaXRpbmcgTU1GUjoNCj4gPj4+PiArICAgICAg
ICAgICAgICogICAgICAtIG1zY3JbNzowXV9ub3RfemVybw0KPiA+Pj4+ICsgICAgICAgICAgICAg
Ki8NCj4gPj4+PiArICAgICAgICAgICAgd3JpdGVsKDAsIGZlcC0+aHdwICsgRkVDX01JSV9EQVRB
KTsNCj4gPj4+PiArICAgIH0NCj4gPj4+DQo+ID4+PiBIaSBHcmVnDQo+ID4+Pg0KPiA+Pj4gVGhl
IGxhc3QgdGltZSB3ZSBkaXNjdXNzZWQgdGhpcywgd2UgZGVjaWRlZCB0aGF0IGlmIHlvdSBjYW5u
b3QgZG8NCj4gPj4+IHRoZSBxdWlyaywgeW91IG5lZWQgdG8gd2FpdCBhcm91bmQgZm9yIGFuIE1E
SU8gaW50ZXJydXB0LCBlLmcuIGNhbGwNCj4gPj4+IGZlY19lbmV0X21kaW9fd2FpdCgpIGFmdGVy
IHNldHRpbmcgRkVDX01JSV9TUEVFRCByZWdpc3Rlci4NCj4gPj4+DQo+ID4+Pj4NCj4gPj4+PiAg
ICAgICB3cml0ZWwoZmVwLT5waHlfc3BlZWQsIGZlcC0+aHdwICsgRkVDX01JSV9TUEVFRCk7DQo+
ID4+DQo+ID4+IFRoZSBjb2RlIGZvbGxvd2luZyB0aGlzIGlzOg0KPiA+Pg0KPiA+PiAgICAgICAg
ICAgd3JpdGVsKGZlcC0+cGh5X3NwZWVkLCBmZXAtPmh3cCArIEZFQ19NSUlfU1BFRUQpOw0KPiA+
Pg0KPiA+PiAgICAgICAgICAgLyogQ2xlYXIgYW55IHBlbmRpbmcgdHJhbnNhY3Rpb24gY29tcGxl
dGUgaW5kaWNhdGlvbiAqLw0KPiA+PiAgICAgICAgICAgd3JpdGVsKEZFQ19FTkVUX01JSSwgZmVw
LT5od3AgKyBGRUNfSUVWRU5UKTsNCj4gPj4NCj4gPj4NCj4gPj4gU28gdGhpcyBpcyBmb3JjaW5n
IGEgY2xlYXIgb2YgdGhlIGV2ZW50IGhlcmUuIElzIHRoYXQgbm90IGdvb2QgZW5vdWdoPw0KPiA+
Pg0KPiA+PiBGb3IgbWUgb24gbXkgQ29sZEZpcmUgdGVzdCB0YXJnZXQgSSBhbHdheXMgZ2V0IGEg
dGltZW91dCBpZiBJIHdhaXQNCj4gPj4gZm9yIGEgRkVDX0lFVkVOVCBhZnRlciB0aGUgRkVDX01J
SV9TUEVFRCB3cml0ZS4NCj4gPj4NCj4gPj4gUmVnYXJkcw0KPiA+PiBHcmVnDQo+ID4NCj4gPiBE
YXZlIEthcnIncyBsYXN0IHBhdGNoIGNhbiBmaXggdGhlIGlzc3VlLCBidXQgaXQgbWF5IGludHJv
ZHVjZSAzMG1zIGRlbGF5IGR1cmluZw0KPiBib290Lg0KPiA+IEdyZWcncyBwYXRjaCBpcyB0byBh
ZGQgcXVpcmsgZmxhZyB0byBkaXN0aW5ndWlzaCBwbGF0Zm9ybSBiZWZvcmUNCj4gPiBjbGVhcmlu
ZyBtbWZyIG9wZXJhdGlvbiwgd2hpY2ggYWxzbyBjYW4gZml4IHRoZSBpc3N1ZS4NCj4gDQo+IERv
IHlvdSBtZWFuIHRoYXQgd2UgY2FuIHVzZSBlaXRoZXIgZml4IC0gYW5kIHRoYXQgaXMgb2sgZm9y
IGFsbCBoYXJkd2FyZSB0eXBlcz8NCj4gDQo+IFJlZ2FyZHMNCj4gR3JlZw0KDQpZZXMsIEkgdGhp
bmsgc28uDQoNClRoYW5rcywNCkFuZHkNCg==
