Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7089A295677
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 04:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895162AbgJVCjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 22:39:48 -0400
Received: from mail-eopbgr00047.outbound.protection.outlook.com ([40.107.0.47]:31904
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2895159AbgJVCjs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 22:39:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N+dIRLdWpCy1jyG8nomzpKm8aUDOf/6I9WF+Smu+raiWfth/AhsftEA2RZTfOOfRtOx635HCnAGoxsum8eFs7fmDA0crQrN+nqAZf0av9QIVeCdlyMnbF4D0ZCHBwIRQlDJ7H7EFJ5X3VvhqrfInhzzJG0BuW2qtid6+WM+9iW1d0hMoChd2LhI8svrxhxrW2jYZsR8EK6W0fb8Auvrmt/G4xHKOOv1pmjI4pXwhC5tb55/EU4Ar7Wb8EBeZ3sofKFwVuAuiEAapSwSt88tswCip2tBxge/lkKEHPYlHB/dymZT+R0bvGNLRk246GFQN9DvM1zFShRdiCgPUZ05XvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i78ZiPC6Cs2sZ/eTW+G6g5maUz/qRuli3fxzDeFUlJc=;
 b=Yif5w2cosQz6A9qmeJUNTrgPUR8AZde27LiNQMYt9aYFjXEqeEIISHnQA20WVkIxjdIHjP9HrzACRr1mexR0lh8ZqH9YShbYgAcMvco85xRQrDbt0Fx9WA6xHWb+9ZWywbtniZCQSGE+HsG/3Gkp/0REVVeEJ6TImrRZ5ABPLRyZ0b+pesQcUqkjq5d849d/U/cRH53x0u3FUgUdwhxvhCj+eToJcojFRZJK6RHIty+lzgcQM4hmplR7vfqc/3HmDuzpdn2U0zjlJ1iixNG0aTKGWqfaTdaLDkRE6jHmKqePEh1JoRLsJzduEtiEOf5Urkw6/I4kbRLyiH9M1sPy2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i78ZiPC6Cs2sZ/eTW+G6g5maUz/qRuli3fxzDeFUlJc=;
 b=lSpVOdG0A/LTdMyesqaC8PpjUAo9Q+HfXrq1qFjTT7b/qZ4z9+acEuvZ6QEGhrR6ULDVwiW1IMp3SiF03QSmnGCUqAxpojs3uhInzIB8qppRMf/SPsA5Ufk9lZQnOYAez7DeG/AJhVJ8rCZEnCalJe/Bw8X6PZzYYfmEtytUTZI=
Received: from AM8PR04MB7315.eurprd04.prod.outlook.com (2603:10a6:20b:1d4::7)
 by AM0PR04MB4723.eurprd04.prod.outlook.com (2603:10a6:208:c0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Thu, 22 Oct
 2020 02:39:45 +0000
Received: from AM8PR04MB7315.eurprd04.prod.outlook.com
 ([fe80::11e6:d413:2d3d:d271]) by AM8PR04MB7315.eurprd04.prod.outlook.com
 ([fe80::11e6:d413:2d3d:d271%6]) with mapi id 15.20.3477.028; Thu, 22 Oct 2020
 02:39:45 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Greg Ungerer <gerg@linux-m68k.org>, Andrew Lunn <andrew@lunn.ch>
CC:     Chris Heally <cphealy@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH] net: ethernet: fec: Replace interrupt driven
 MDIO with polled IO
Thread-Topic: [EXT] Re: [PATCH] net: ethernet: fec: Replace interrupt driven
 MDIO with polled IO
Thread-Index: AQHWpoauv6yGoz1SREmyP2rAbcRdI6mfx44AgAGE0gCAAMVZAIAAwnuAgAAXh4A=
Date:   Thu, 22 Oct 2020 02:39:45 +0000
Message-ID: <AM8PR04MB7315ED2E004383264BDC4654FF1D0@AM8PR04MB7315.eurprd04.prod.outlook.com>
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
x-ms-office365-filtering-correlation-id: ef5bde0e-69f4-4b2d-1bb9-08d87633bc93
x-ms-traffictypediagnostic: AM0PR04MB4723:
x-microsoft-antispam-prvs: <AM0PR04MB47232E03F8DB524CC6DBC22FFF1D0@AM0PR04MB4723.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0nj0uttQzJgGauCEBefjAz7yXsHx/XZsiJ1lB4lhSq6rRoAmTskygcKxUFEyVo9gDwwOxHTnwazHMe0p4+Yvl4N6vQoOrHxmcxlprDbzM5TvDE8wQgOoaP/Y4iXz7zjTQdOQKfHv/80VuqQZgq2tLtPSr4nUy4ZUGNmL1kVHZwsmS1SbXGoZfFEGYV8Ispqr4XOJF2D4ZJQL8HAlJLeYz7C4572L+65j/jnaGQu7X/MZHQDqilT84/vaudap3MUH0BQaf5Acn1pSWQ2pMf+ZE5wT/6TzDowMny3yucoJINh3TIJluAGD/+8SWOftdaDzdVRbVk7Jl63xDOjG1j2eLQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7315.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(39860400002)(136003)(376002)(6506007)(2906002)(316002)(55016002)(4326008)(110136005)(26005)(9686003)(478600001)(53546011)(8936002)(186003)(54906003)(66446008)(66556008)(52536014)(8676002)(66946007)(33656002)(66476007)(7696005)(71200400001)(5660300002)(64756008)(86362001)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: LY1sUvlW6g/4GIBYmrdAR5pXNAkGgjzF7itsPIwpTVJOhj84pJV2+QaucaeTSG2rLOhdMh0vlgGHa0Zp7mcL5pTvbkZqc2Yho914aPPqHVaLzXqr57WbTLMF55i17IKdvshit31eJJikhYpATOvbX/dwzipklkWBwHjKV4hMK0cOEQquUVrB6Yel+qySZwWO6xofnnoHf04MQLvFhAAiLVa/oAVy+A0Cmsl/U/+RdnkGmZOcEG///rMbmcdRvmv5s9PPO9a1O5GIIUMCQIZOEJIkrmC+9Ada90Sj8wUnBB+g0cJNcEcLkkVAAEPUXWMvILnWP9M/cjtjABHkcEyOyw7qw8q6OjVu2pMz1w2lW5coOPoKZ28YeBCcQwKYOscD9a+0qmZJgznlsi3SaDoUf0IWka3goxqBUA50ou9s6D4/E5jQuX7rw6iASCuClw0PabkSqRbbOKqqshj13rqMUWOvBdzpnEvMLbgEwNgu5gtd9VgoB/zp3l3Deq1AMfRh3jgo+YxJ2xVrNaF4Z2eSkByf2wTs0lXRPyYcdAXuX2AWaq3wFJlofyqz15kkVl+L5/SKgScegEt8MOojW3AK72TXEHy93naMUQZDY7Np0Iv3HaqqYbxvBa0SGGks5zLrq0BOCh0veA1Ozcd+xziG+w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7315.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef5bde0e-69f4-4b2d-1bb9-08d87633bc93
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2020 02:39:45.1221
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TR0VTIsN4ehbjGZPT1d03dBh78exR9r6y8jKThAfXm5KHSHt3oqWHW3muI8hSZF3+kcvzsxpRT0mRmn+t6mgHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4723
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
aXQgZm9yIGENCj4gRkVDX0lFVkVOVCBhZnRlciB0aGUgRkVDX01JSV9TUEVFRCB3cml0ZS4NCg0K
SXQgaXMgd2hhdCBJIHJhaXNlZCBpbiBwcmV2aW91cyBtYWlsIGFib3V0IDMwbXMgbGF0ZW5jeSBm
b3IgYm9vdC4gDQo+IA0KPiBSZWdhcmRzDQo+IEdyZWcNCg0K
