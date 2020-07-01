Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08867210170
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 03:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbgGAB1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 21:27:05 -0400
Received: from mail-db8eur05on2081.outbound.protection.outlook.com ([40.107.20.81]:6176
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725862AbgGAB1E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 21:27:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R0Z9kL+2o7D43M9gZ460fPPNdGLOY3NWlKpDjAzLmdbm0Dof9NLnkdxCbumhYZGnp70f6OluZBTce6taH+5IVede/oeeFN+IxiCquj/k7pQ4hKi0Kqkv/Dbl0FDdtuzbvcHbiGYwM3RAJ8+nOVgRJTmOHN1PE9yQ4q+uKoo+F3+QoFgiUb2x8LyPLh3AGkdzwl8fl5Yd57hp1UGRBA4+xJc3Hzgn4PAVfIsfRr8SiUWC0bLf1J+gP3zt4xn+yY3pnsWqjllCXYvrIZg9N/3FJFgZXjq3nods7edmUkP2sDOWZUe79Dw9mHg8ZEho/rcZ//EJW3bjxpZ67OWVGVvEVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=voaIvO+/kDNqAiB0M4M5dxdsSWQS86D+Y6dq2rY+asI=;
 b=anSPTMFaOMja+e1N5RikdEqYIC9Q+JkT5TvnQHCea3eAPsAR08lGXf60q4J02M4G6bAEGkWF2cH2x0bnz70R+YFhOun2A3bxoQ5FaE/QbvnKPZGxl+0tmgnjL1nq/b058+8GzgNdQ66EX8CZW0YWNCsEfFRJZchB5ZiwrBg8LOr049cKJT5cvCoqlnRzYl4ZbzCxHRfuanxVGezfFMZIkfoQYZeXSeapJGv6yBFXq7t9YxdexGuNumgJZLiJIArPjtmdO7TY8Hvrga8PvztGSkEavjn8o1BRxJFuu66iEiSQc6/O4C+W15EVtAGKnHvdEPksLG27cfMBQYAssUuzpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=voaIvO+/kDNqAiB0M4M5dxdsSWQS86D+Y6dq2rY+asI=;
 b=B+xBh5i28hCxs9CGQeB3GTVX3DLF6RZO5L2dH+bo32efwT0Les9VhLtAMDEZwP0BNXhVLaYFoC9MyGPdUH6LnN7yod21bXw/1iHuTTnzYEIShQlmvbNWxf2RWhPe1nIxXRiU2B4NJKJfdPCmKEy3mJ6KHpg0U7wALDyFaw3pNrU=
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3830.eurprd04.prod.outlook.com
 (2603:10a6:209:1d::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.24; Wed, 1 Jul
 2020 01:27:01 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3131.027; Wed, 1 Jul 2020
 01:27:01 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>,
        David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net-next] net: ethernet: fec: prevent tx
 starvation under high rx load
Thread-Topic: [EXT] Re: [PATCH net-next] net: ethernet: fec: prevent tx
 starvation under high rx load
Thread-Index: AQHWSyWV3hyWvPwI+E6K+muw3DPNvajtkJeQgAI97gCAAOkCsIAAEuSAgAAPKTCAAAipAIAAAXzggAADJQCAAAkogIAAFWkAgADxYRA=
Date:   Wed, 1 Jul 2020 01:27:01 +0000
Message-ID: <AM6PR0402MB3607636E42D7ADF5907EA1F7FF6C0@AM6PR0402MB3607.eurprd04.prod.outlook.com>
References: <AM6PR0402MB36074675DB9DBCD9788DCE9BFF6F0@AM6PR0402MB3607.eurprd04.prod.outlook.com>
 <C3UDW5NW0479.2LD6LMUDKPVGN@wkz-x280>
In-Reply-To: <C3UDW5NW0479.2LD6LMUDKPVGN@wkz-x280>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 69ff4a88-ab76-4242-6782-08d81d5ddadf
x-ms-traffictypediagnostic: AM6PR0402MB3830:
x-microsoft-antispam-prvs: <AM6PR0402MB383053E41B987DC2DDE79C0AFF6C0@AM6PR0402MB3830.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1388;
x-forefront-prvs: 04519BA941
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GL3du4j0VyZWcYh5nGBMxZGqPXsCSAFk4kYJ6l9yCqd3spWJOTB2WXY7hE3/JkM00r5VvBCQSEOdCQ1x30EA2UG6G5VTkgJ416tIl13+D63u7BRRuXfDX9bSbWA1WtpepILZa9IXyEneH26bkoA1dZz/vm5o2KlDiYMJz1zDMNOioO5rlSmZDUEgmaExKv18di81+vwFI7SDbCBUI9Kc20116gHs5YyI0Eb0gwvNOhiuY1TJiRPZOfO/nL4cha/Ec/mdmIrXSoM902P1nNYdWu7AmUBBelMD7lHhSPyMY9RU8lY/jPWt9ILEEzJFAEd+fkwwzHZ7Bjxy0DUf2BjCPiDgjzxSmIQppReLVndisFcstAOANFnMX7ECdTC+kusZqk8UBBowF/4uQ4cMB4Zmhg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(136003)(39860400002)(396003)(346002)(45080400002)(4326008)(2906002)(83080400001)(110136005)(71200400001)(26005)(8676002)(316002)(966005)(186003)(66556008)(66446008)(64756008)(66476007)(9686003)(5660300002)(86362001)(478600001)(76116006)(7696005)(55016002)(6506007)(33656002)(4744005)(8936002)(66946007)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: HbNjDynVX940kEg2J7d7WppTB28HfbAS58edtefTbbF7N6U1wpYqQnIMpba4S46oZhEZPayA6FJFn0+BqD83R6D6AmnYIo6v/3VnxBJeFSfmDGnFEi7uZz4EDpmTiqOCuSpNkQvjK6zLDaGUw8csNkFOhv+gl2YZpqx8S1djkg50JpvbMGZh685VTNnW+gIEYfDZK63WYsbGv/dL5I0+IHeKZuGjc6pbXbS5E1ucSiyyvfcUPCTYOCC0B3Q97tXQbhJeF3csdFs9HmSnzJi3OCEI+D6cHO2pI5I1ssCk3sS3w6fxC6CeG7UrYJRrwtIeQuIml3Ad0a5/+/pk5qwVCTQK2jYBMDrU2QmNo994crAhIls+X1dWdZTOClxLCLbBo9u8EkjPMpIIWkM46A6GZsD6XF7MNsVoSrdWM+qgeMfhYw4Gk5n/nTlRSYTmhQz9U2n634ic1HzzBlBWqfX7LXz40pc7RbIXFa0T7IBmUn+6AeqbrkthSDzOqaqGtde/
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR0402MB3607.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69ff4a88-ab76-4242-6782-08d81d5ddadf
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2020 01:27:01.3329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YXvm5V0CO7K9u9kE8/hUpmcLY1pWevMOpAGCt9gD0kUXMi1BJqOQKHCaLxtwDeNWcE30/9kLCogAA+X4TFT/2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3830
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogVG9iaWFzIFdhbGRla3JhbnogPHRvYmlhc0B3YWxkZWtyYW56LmNvbT4gU2VudDogVHVl
c2RheSwgSnVuZSAzMCwgMjAyMCA3OjAyIFBNDQo+IE9uIFR1ZSBKdW4gMzAsIDIwMjAgYXQgMTE6
NDcgQU0gQ0VTVCwgQW5keSBEdWFuIHdyb3RlOg0KPiA+IFRvYmlhcywgc29ycnksIEkgYW0gbm90
IHJ1bm5pbmcgdGhlIG5ldCB0cmVlLCBJIHJ1biB0aGUgbGludXgtaW14IHRyZWU6DQo+ID4gaHR0
cHM6Ly9ldXIwMS5zYWZlbGlua3MucHJvdGVjdGlvbi5vdXRsb29rLmNvbS8/dXJsPWh0dHBzJTNB
JTJGJTJGc291cg0KPiA+DQo+IGNlLmNvZGVhdXJvcmEub3JnJTJGZXh0ZXJuYWwlMkZpbXglMkZs
aW51eC1pbXglMkZyZWZzJTJGaGVhZHMmYW1wOw0KPiBkYXRhDQo+ID4NCj4gPTAyJTdDMDElN0Nm
dWdhbmcuZHVhbiU0MG54cC5jb20lN0MzNTFhZTUwZGU2MWE0NTkzNTFhZjA4ZDgxY2UNCj4gNTRk
MDAlN0MNCj4gPg0KPiA2ODZlYTFkM2JjMmI0YzZmYTkyY2Q5OWM1YzMwMTYzNSU3QzAlN0MwJTdD
NjM3MjkxMTE4NDQ3MTIyNzk1DQo+ICZhbXA7c2RhdA0KPiA+DQo+IGE9QzJnVlVPcnl0R29sM0Fs
OXlQVTJDZ0RBNnVQc2sxTEp2dmI1NTB6RGlRayUzRCZhbXA7cmVzZXJ2ZWQ9MA0KPiA+IGJyYW5j
aO+8mmlteF81LjQuMjRfMi4xLjANCj4gPiBCdXQgdGhlIGRhdGEgZm9sbG93IGlzIHRoZSBzYW1l
IGFzIG5ldCB0cmVlLg0KPiANCj4gT2ssIEknbGwgYnVpbGQgdGhhdCBrZXJuZWwgYW5kIHNlZSBp
ZiBJIGdldCBkaWZmZXJlbnQgcmVzdWx0cy4gV291bGQgeW91IG1pbmQNCj4gc2hhcmluZyB5b3Vy
IGtlcm5lbCBjb25maWc/DQoNClRoZSBjb25maWc6IGlteF92OF9kZWZjb25maWcNCg==
