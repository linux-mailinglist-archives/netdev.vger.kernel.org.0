Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A05294671
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 04:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411174AbgJUCTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 22:19:24 -0400
Received: from mail-eopbgr140047.outbound.protection.outlook.com ([40.107.14.47]:36446
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2411166AbgJUCTY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 22:19:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sr8epu17HU6RZvtNp/TUlSW/hrP/Ik4qmeiEZHMevRmQS2iC2K8RMK90h6JjfOhK3ZzYgl9MM3jKbZp+9KD+OCZzRF1Qv7wBdnOihIUdqSb1x49+YS7q32zxOFLbVN/4neO4bK2Y4H8x9bOuGJ7D5awMmoBXPCYZEQoLcJbYoycGyGn9F5ImkH6Wr3+Y1C5reUYJw5FtvKMw9ENcZVR0KtJaQ6KLUOILkUB5DAPapgDeRatKJ5UpgrBBWgDs7YsIMwT08FOjwse7kZ8s7U9g0CIXv2pVeXbPjZsliNYEm8PSaKxIdfPnEImXa7nHQK9T4C3M0c4TdcsnMunlP5oHnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bUyvZxA7WFXM58xHa1Kk0O+DwgA3PFHfzOlv5qNpK+c=;
 b=Bkp5cOK45OdbTdSmM3ZqfpkbWEbFu3ONvcno4mqQmrAi2pctW4axZkiZy3yaoQIFy4L/tVP1Wq2QKboZXUmHqLi8kPr6y6P18lsTFfOSLk6tAkxv8m0rn09RHmr0YwT2yleEyd8NzhPySI1IfzEyN9S/Wk1uKpdXAotE/b7G1V/+tYP3uotouNHQdcRqPD1J2zlTSEXZWb486smTkeltVxLbZyEb84mvBJP856fkGRlPnrzDkV6+26RfxdxGqp257KrulEcN3C0HsdBlU2moIJKh+1J+AwJNwsoGrSAiREVPOW6RkndEcU6Bqy7zzEJhYx50O6HY5nD/xOgKxdI09g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bUyvZxA7WFXM58xHa1Kk0O+DwgA3PFHfzOlv5qNpK+c=;
 b=rWJC4yi9pXu/jZ7s9rMY0Z+ndybiIZBG5j9eNivjWhyh1zubKcuMReNWAGG4V454gqa4wO2fE72PtJHMkL+krK0RzrhPyvhHQk9LMZbhJQnMb+2EuVZrmS66svx2QdaAdIP94UrJU/SI/JhtsPe6/ZCIPNDRHmAzG5Ig0cL1vSQ=
Received: from AM8PR04MB7315.eurprd04.prod.outlook.com (2603:10a6:20b:1d4::7)
 by AM0PR04MB6802.eurprd04.prod.outlook.com (2603:10a6:208:184::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Wed, 21 Oct
 2020 02:19:19 +0000
Received: from AM8PR04MB7315.eurprd04.prod.outlook.com
 ([fe80::11e6:d413:2d3d:d271]) by AM8PR04MB7315.eurprd04.prod.outlook.com
 ([fe80::11e6:d413:2d3d:d271%6]) with mapi id 15.20.3477.028; Wed, 21 Oct 2020
 02:19:19 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Greg Ungerer <gerg@linux-m68k.org>, Andrew Lunn <andrew@lunn.ch>
CC:     Chris Heally <cphealy@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH] net: ethernet: fec: Replace interrupt driven
 MDIO with polled IO
Thread-Topic: [EXT] Re: [PATCH] net: ethernet: fec: Replace interrupt driven
 MDIO with polled IO
Thread-Index: AQHWpoauv6yGoz1SREmyP2rAbcRdI6mfx44AgAGE0gCAAAdisA==
Date:   Wed, 21 Oct 2020 02:19:19 +0000
Message-ID: <AM8PR04MB73153FA5CF4C0B88CE65EF87FF1C0@AM8PR04MB7315.eurprd04.prod.outlook.com>
References: <c8143134-1df9-d3bc-8ce7-79cb71148d49@linux-m68k.org>
 <20201020024000.GV456889@lunn.ch>
 <9fa61ea8-11b4-ef3c-c04e-cb124490c9ae@linux-m68k.org>
In-Reply-To: <9fa61ea8-11b4-ef3c-c04e-cb124490c9ae@linux-m68k.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux-m68k.org; dkim=none (message not signed)
 header.d=none;linux-m68k.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f508d76a-7a46-48a8-2650-08d87567b781
x-ms-traffictypediagnostic: AM0PR04MB6802:
x-microsoft-antispam-prvs: <AM0PR04MB680227FF12F42A25E2619F17FF1C0@AM0PR04MB6802.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WXRa1Vgpr/waOLlBg2yXhJWJ/Y9nYhwol+PyJwtm5NLuOmtY3A18sYK2btFpcuKL1gdQQmBeeA+Jzskbm4Dy0ZIJZ9UxDetbqhHINMMPKeGhFJa1v/Zj+3HsYmvZMo8bjho2c2tvcmN4ZGq/ebR0RVDo3U2hRRy1AsOycJiNMTJruGwMb5/2wNojxiMIuqMYEalx/KVzzSHSuu3MOxZ5cBbKgs0fT7BAY04ppN/5yfoWXRzjzNjN3h1KXtqOcu1wnQIRA2dNZL8UScG0hnfB+15A3t7uo2it/BUMK2fbM4fumg+zyAvf76yp6ZOpL2u8L4T0CBmvulBZYWophm0LLw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7315.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(86362001)(316002)(66946007)(110136005)(64756008)(33656002)(66476007)(66446008)(66556008)(76116006)(71200400001)(52536014)(478600001)(26005)(54906003)(5660300002)(186003)(55016002)(6506007)(53546011)(7696005)(4326008)(9686003)(8936002)(2906002)(8676002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: rRPxPRFS3KHn/ji2M/y3CLkWg0g75Ptdylm1FSZV1ZjTexZCtIpkUO9bXbo3tdEDdz8PcmJOpOxVQFPOh4Foy/WlmOFKsQkN+L//9oy0EcRajWVrSfgToXEpzhnUP7JGuhMtdrn/USNl0GuZdYcUYjDLWyRDGJcF+hHRJl02aGJVuCrInJ9TF/lNCwQ1aquxam7k9mS/U8aSuk8I3EkiPb2fQbu0iXHyYNObpN+U0iu3rx0zmDT144pKBCGRrQ7ufm2rUPaNp2umSXMdRGwG1/j1Ktk79R2FUv6bFEQz4oEO1KDL7em+wVrc7lElGrkvhOslsyub16jt1cVYwTCEYR+giaQotQLoHz08P3eYp7Pm7JP1JcsyfPVbvEQtpSbTMcMKBu8V7ly1cXWKwNKVrovscRABhnhIDpowaCj+8AdjuwPaKTjz9Gr61b+/c5BwFR9t+Wopu2GUi2qSeSwPteRMLQJgX5Z1FDSaKuaX3NURzm9OW0+1dmBJeJwca4Auuh/2OP+JqbdeM9coNCF0ICr5PdzQISXtPboPbzH3eI4q16CEa2p4GC4icjLO1CYUcxZ844X7yLb60uTrvKOi9GhzMIN8NrwXoJ7CzQ1Ylr7kYQ8umxFnn/TIOiJEjw8h7MUK3SGKPG5PSMRmTdhrBA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7315.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f508d76a-7a46-48a8-2650-08d87567b781
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2020 02:19:19.2645
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 83dCK9AFs6co8UYgLMJsFmwWRnhYlpRx1gDghKh/ZSExBd5YpqAKTJTGpHUW8z5NxxMQby9btRJmrPyOLvs1PQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6802
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogR3JlZyBVbmdlcmVyIDxnZXJnQGxpbnV4LW02OGsub3JnPiBTZW50OiBXZWRuZXNkYXks
IE9jdG9iZXIgMjEsIDIwMjAgOTo1MiBBTQ0KPiBIaSBBbmRyZXcsDQo+IA0KPiBUaGFua3MgZm9y
IHRoZSBxdWljayByZXNwb25zZS4NCj4gDQo+IA0KPiBPbiAyMC8xMC8yMCAxMjo0MCBwbSwgQW5k
cmV3IEx1bm4gd3JvdGU6DQo+ID4gT24gVHVlLCBPY3QgMjAsIDIwMjAgYXQgMTI6MTQ6MDRQTSAr
MTAwMCwgR3JlZyBVbmdlcmVyIHdyb3RlOg0KPiA+PiBIaSBBbmRyZXcsDQo+ID4+DQo+ID4+IENv
bW1pdCBmMTY2Zjg5MGM4ZjAgKCJbUEFUQ0hdIG5ldDogZXRoZXJuZXQ6IGZlYzogUmVwbGFjZSBp
bnRlcnJ1cHQNCj4gPj4gZHJpdmVuIE1ESU8gd2l0aCBwb2xsZWQgSU8iKSBicmVha3MgdGhlIEZF
QyBkcml2ZXIgb24gYXQgbGVhc3Qgb25lIG9mDQo+ID4+IHRoZSBDb2xkRmlyZSBwbGF0Zm9ybXMg
KHRoZSA1MjA4KS4gTWF5YmUgb3RoZXJzLCB0aGF0IGlzIGFsbCBJIGhhdmUNCj4gPj4gdGVzdGVk
IG9uIHNvIGZhci4NCj4gPj4NCj4gPj4gU3BlY2lmaWNhbGx5IHRoZSBkcml2ZXIgbm8gbG9uZ2Vy
IGZpbmRzIGFueSBQSFkgZGV2aWNlcyB3aGVuIGl0DQo+ID4+IHByb2JlcyB0aGUgTURJTyBidXMg
YXQga2VybmVsIHN0YXJ0IHRpbWUuDQo+ID4+DQo+ID4+IEkgaGF2ZSBwaW5uZWQgdGhlIHByb2Js
ZW0gZG93biB0byB0aGlzIG9uZSBzcGVjaWZpYyBjaGFuZ2UgaW4gdGhpcyBjb21taXQ6DQo+ID4+
DQo+ID4+PiBAQCAtMjE0Myw4ICsyMTQyLDIxIEBAIHN0YXRpYyBpbnQgZmVjX2VuZXRfbWlpX2lu
aXQoc3RydWN0DQo+IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gPj4+ICAgICBpZiAoc3VwcHJl
c3NfcHJlYW1ibGUpDQo+ID4+PiAgICAgICAgICAgICBmZXAtPnBoeV9zcGVlZCB8PSBCSVQoNyk7
DQo+ID4+PiArICAgLyogQ2xlYXIgTU1GUiB0byBhdm9pZCB0byBnZW5lcmF0ZSBNSUkgZXZlbnQg
Ynkgd3JpdGluZyBNU0NSLg0KPiA+Pj4gKyAgICAqIE1JSSBldmVudCBnZW5lcmF0aW9uIGNvbmRp
dGlvbjoNCj4gPj4+ICsgICAgKiAtIHdyaXRpbmcgTVNDUjoNCj4gPj4+ICsgICAgKiAgICAgIC0g
bW1mclszMTowXV9ub3RfemVybyAmIG1zY3JbNzowXV9pc196ZXJvICYNCj4gPj4+ICsgICAgKiAg
ICAgICAgbXNjcl9yZWdfZGF0YV9pbls3OjBdICE9IDANCj4gPj4+ICsgICAgKiAtIHdyaXRpbmcg
TU1GUjoNCj4gPj4+ICsgICAgKiAgICAgIC0gbXNjcls3OjBdX25vdF96ZXJvDQo+ID4+PiArICAg
ICovDQo+ID4+PiArICAgd3JpdGVsKDAsIGZlcC0+aHdwICsgRkVDX01JSV9EQVRBKTsNCj4gPj4N
Cj4gPj4gQXQgbGVhc3QgYnkgcmVtb3ZpbmcgdGhpcyBJIGdldCB0aGUgb2xkIGJlaGF2aW9yIGJh
Y2sgYW5kIGV2ZXJ5dGhpbmcNCj4gPj4gd29ya3MgYXMgaXQgZGlkIGJlZm9yZS4NCj4gPj4NCj4g
Pj4gV2l0aCB0aGF0IHdyaXRlIG9mIHRoZSBGRUNfTUlJX0RBVEEgcmVnaXN0ZXIgaW4gcGxhY2Ug
aXQgc2VlbXMgdGhhdA0KPiA+PiBzdWJzZXF1ZW50IE1ESU8gb3BlcmF0aW9ucyByZXR1cm4gaW1t
ZWRpYXRlbHkgKHRoYXQgaXMgRkVDX0lFVkVOVCBpcw0KPiA+PiBzZXQpIC0gZXZlbiB0aG91Z2gg
aXQgaXMgb2J2aW91cyB0aGUgTURJTyB0cmFuc2FjdGlvbiBoYXMgbm90IGNvbXBsZXRlZCB5ZXQu
DQo+ID4+DQo+ID4+IEFueSBpZGVhcz8NCj4gPg0KPiA+IEhpIEdyZWcNCj4gPg0KPiA+IFRoaXMg
aGFzIGNvbWUgdXAgYmVmb3JlLCBidXQgdGhlIGRpc2N1c3Npb24gZml6emxlZCBvdXQgd2l0aG91
dCBhDQo+ID4gZmluYWwgcGF0Y2ggZml4aW5nIHRoZSBpc3N1ZS4gTlhQIHN1Z2dlc3RlZCB0aGlz
DQo+ID4NCj4gPiB3cml0ZWwoMCwgZmVwLT5od3AgKyBGRUNfTUlJX0RBVEEpOw0KPiA+DQo+ID4g
V2l0aG91dCBpdCwgc29tZSBvdGhlciBGRUMgdmFyaWFudHMgYnJlYWsgYmVjYXVzZSB0aGV5IGRv
IGdlbmVyYXRlIGFuDQo+ID4gaW50ZXJydXB0IGF0IHRoZSB3cm9uZyB0aW1lIGNhdXNpbmcgYWxs
IGZvbGxvd2luZyBNRElPIHRyYW5zYWN0aW9ucyB0bw0KPiA+IGZhaWwuDQo+ID4NCj4gPiBBdCB0
aGUgbW9tZW50LCB3ZSBkb24ndCBzZWVtIHRvIGhhdmUgYSBjbGVhciB1bmRlcnN0YW5kaW5nIG9m
IHRoZQ0KPiA+IGRpZmZlcmVudCBGRUMgdmVyc2lvbnMsIGFuZCBob3cgdGhlaXIgTURJTyBpbXBs
ZW1lbnRhdGlvbnMgdmFyeS4NCj4gDQo+IEJhc2VkIG9uIEFuZHkgYW5kIENocmlzJyBjb21tZW50
cyBpcyBzb21ldGhpbmcgbGlrZSB0aGUgYXR0YWNoZWQgcGF0Y2ggd2hhdA0KPiB3ZSBuZWVkPw0K
DQpHcmVnLCBpbXgyOCBwbGF0Zm9ybSBhbHNvIHJlcXVpcmVzIHRoZSBmbGFnLg0KPiANCj4gUmVn
YXJkcw0KPiBHcmVnDQo+IA0KDQo=
