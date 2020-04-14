Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4221A87F5
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 19:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502870AbgDNRuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 13:50:03 -0400
Received: from mail-eopbgr130074.outbound.protection.outlook.com ([40.107.13.74]:61156
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2502768AbgDNRuA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 13:50:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iyOGX9WxAd+GnyCLUeCYSog1HseE8s6vpjfqj3bdUJzKw4NH20gmeU/Rx75Jj1a0TruwZq75kG20VICDO+tvHKCX/J7cgO42cD1X2N2RhW4EFXewDdzphyJ2Um9Ln8oHG/77InMDZcI67od91tDLnp7ikrZOpm1VbF7p6YT/FveggUhgJBPW+mXmZCvEE1RV9vFbVRIL1sTKfClZbQTnUkItKa5phCS/5x0OGvHJBJW8NgZzLNzEcoDY3LWmk/mx++kUl0JF7Obrc7xumvKh0DZWH49cluXCxh9prSK5RDeWZftgSRWDf6+lSr3iUrOcZDKD3Pjfu2eHXoxv8Lxo5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wpxs3kU8/3fQJR7Txh0E1aVd1Pzhw8m1oYOxfQFrT/Y=;
 b=Rb0Jf0A8Xt2vn3Rr0mXqMvq3Mm5tZRlOWS0NOqqgHDP2MIIT2CloEvcqsOGLRTLTpG4ppM0imuhudETfEL1bB2vlNlsLFfUX+LZSlPO1exk299YWF6DOWRsky5vmH9DTTZBYm7McrclfxqCHrGFFoqrg2d2pVI0pWHEKtIAmoJ4q44cDH6/UWWW9ekkAQvJh1qno4m6njcQiBYeFCV2+HEOUNYU9Gje5Ev8kW0PdZWW4cgrI9qkZom9+BbvMqIqTMu4au4w1MsiwcWUVrRVLi24Ne6TdpmMeJU6XrpsD/151qd1dVAoIZcWOGNXdgyOZZMqZA2V0JY29nTIYwlOamw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wpxs3kU8/3fQJR7Txh0E1aVd1Pzhw8m1oYOxfQFrT/Y=;
 b=tJCGtH3faicDp6+ueuJPlsxNwmWG4oF26ioRso1QmvA7Pr7d84FU8pGbiV0M2iND5qWb/dgVKppTfvOBPFN/TIjugbE94NtF7D1WLiIAS4w5Dr4GvmPrsk/KT7Wmz+29oOMjMkxacGJ3zEdHP5ApqTnH8ZFwWG0tyulK+NoZnhM=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5215.eurprd05.prod.outlook.com (2603:10a6:803:a7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.26; Tue, 14 Apr
 2020 17:49:42 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2900.028; Tue, 14 Apr 2020
 17:49:42 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jgg@ziepe.ca" <jgg@ziepe.ca>, "arnd@arndb.de" <arnd@arndb.de>
CC:     "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "Laurent.pinchart@ideasonboard.com" 
        <Laurent.pinchart@ideasonboard.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "nico@fluxnic.net" <nico@fluxnic.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "kieran.bingham+renesas@ideasonboard.com" 
        <kieran.bingham+renesas@ideasonboard.com>,
        "jani.nikula@linux.intel.com" <jani.nikula@linux.intel.com>,
        "a.hajda@samsung.com" <a.hajda@samsung.com>,
        "jonas@kwiboo.se" <jonas@kwiboo.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "jernej.skrabec@siol.net" <jernej.skrabec@siol.net>
Subject: Re: [RFC 0/6] Regressions for "imply" behavior change
Thread-Topic: [RFC 0/6] Regressions for "imply" behavior change
Thread-Index: AQHWDeQiJzc7TgrcN0yUMWAEU5j98qhvr4mAgAADKgCAAB92AIAAp0gAgAEtnwCAAPPSAIAAHv4AgAXrpwCAABBmgIAAD4MAgAAAr4CAACg8gA==
Date:   Tue, 14 Apr 2020 17:49:41 +0000
Message-ID: <f6d83b08fc0bc171b5ba5b2a0bc138727d92e2c0.camel@mellanox.com>
References: <20200408202711.1198966-1-arnd@arndb.de>
         <nycvar.YSQ.7.76.2004081633260.2671@knanqh.ubzr>
         <CAK8P3a2frDf4BzEpEF0uwPTV2dv6Jve+6N97z1sSuSBUAPJquA@mail.gmail.com>
         <20200408224224.GD11886@ziepe.ca> <87k12pgifv.fsf@intel.com>
         <7d9410a4b7d0ef975f7cbd8f0b6762df114df539.camel@mellanox.com>
         <20200410171320.GN11886@ziepe.ca>
         <16441479b793077cdef9658f35773739038c39dc.camel@mellanox.com>
         <20200414132900.GD5100@ziepe.ca>
         <CAK8P3a0aFQ7h4zRDW=QLogXWc88JkJJXEOK0_CpWwsRjq6+T+w@mail.gmail.com>
         <20200414152312.GF5100@ziepe.ca>
         <CAK8P3a1PjP9_b5NdmqTLeGN4y+3JXx_yyTE8YAf1u5rYHWPA9g@mail.gmail.com>
In-Reply-To: <CAK8P3a1PjP9_b5NdmqTLeGN4y+3JXx_yyTE8YAf1u5rYHWPA9g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ac769aa8-eb06-45b6-7ff4-08d7e09c35f3
x-ms-traffictypediagnostic: VI1PR05MB5215:
x-microsoft-antispam-prvs: <VI1PR05MB5215F4B00C4CB883593FF645BEDA0@VI1PR05MB5215.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0373D94D15
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(39860400002)(376002)(396003)(136003)(366004)(186003)(71200400001)(110136005)(5660300002)(7416002)(36756003)(8676002)(6506007)(8936002)(4326008)(6486002)(6512007)(81156014)(86362001)(54906003)(316002)(91956017)(66556008)(2616005)(64756008)(478600001)(76116006)(26005)(66446008)(2906002)(66476007)(53546011)(66946007);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rm0zeaUTSgMejJQtSAwBz9bMu/mx2ECZFRTaXwd7jczXadIbDlze6tFI/xdXfrLMGOU+E2OjNRODqv4AE4oLdJPEAzKDSDpVe+pwaj4UzAS/oGlE+YRuTkMczt/RgHqM//KDwmKrfvTENztwxgnB1ogO0DXrRNmIhR8T9G8e108OG9jspYBsmqx26lHMbf162L9iJ57wDKHEM2k+P5kxCjal/FdhVffAHGgx5ZuB871ShY54VoApR7Z863JOp105F8ffkgmEFoaqmux2mlegYjYOnQ6yukU3fgOwpBcgHelfaq25p6xbfZa99wDVAAgvflv+/sRgjL73Gx3evC+yHGtKjiN8FkjtdQB9M+B8McYJvLw+/F430WyF2KEkAQTI78siDZ3aAbwcQZ8V9LgELYBCotB3a1CJOIybpPDq+U9pThnhFH34R/iuiELAkzWU
x-ms-exchange-antispam-messagedata: 1NkgKHyHsKz1raQ+CJFWat9KZLvaunRuFz0VzeVRjmy9P5lMDvq5bg32Cbuk3ZV3Lg0LQMOJYBzhTwD2Kq3vH0FdeDp506pXFlhpN2ZP8/7mp7Ml0neEOquN3vtuGtQ4aBhztmVYYS8eVBqmpp7htg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <732BDB5CD5614D4C86B0C0233E6BE302@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac769aa8-eb06-45b6-7ff4-08d7e09c35f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2020 17:49:42.0115
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NkCNURkiqLIWiek5JheVgT9BsK/z5kmnYSQK4VIif/CghHtXxXIkY9lxJgBSB5D3azWVOjo2ZNNscu+eC6maOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5215
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTA0LTE0IGF0IDE3OjI1ICswMjAwLCBBcm5kIEJlcmdtYW5uIHdyb3RlOg0K
PiBPbiBUdWUsIEFwciAxNCwgMjAyMCBhdCA1OjIzIFBNIEphc29uIEd1bnRob3JwZSA8amdnQHpp
ZXBlLmNhPiB3cm90ZToNCj4gPiBPbiBUdWUsIEFwciAxNCwgMjAyMCBhdCAwNDoyNzo0MVBNICsw
MjAwLCBBcm5kIEJlcmdtYW5uIHdyb3RlOg0KPiA+ID4gT24gVHVlLCBBcHIgMTQsIDIwMjAgYXQg
MzoyOSBQTSBKYXNvbiBHdW50aG9ycGUgPGpnZ0B6aWVwZS5jYT4NCj4gPiA+IHdyb3RlOg0KPiA+
ID4gPiBPbiBGcmksIEFwciAxMCwgMjAyMCBhdCAwNzowNDoyN1BNICswMDAwLCBTYWVlZCBNYWhh
bWVlZCB3cm90ZToNCj4gPiA+IHdoaWNoIGluIHR1cm4gbGVhZHMgdG8gbWx4NV9jb3JlLmtvICpu
b3QqIGNvbnRhaW5pbmcNCj4gPiA+IG1seDVfdnhsYW4ubywNCj4gPiA+IGFuZCBpbiB0dXJuIGNh
dXNpbmcgdGhhdCBsaW5rIGVycm9yIGFnYWluc3QNCj4gPiA+IG1seDVfdnhsYW5fY3JlYXRlL21s
eDVfdnhsYW5fZGVzdHJveSwgdW5sZXNzIHRoZSBJU19FTkFCTEVEKCkNCj4gPiA+IGlzIGNoYW5n
ZWQgdG8gSVNfUkVBQ0hBQkxFKCkuDQo+ID4gDQo+ID4gV2hhdCBhYm91dCB0aGUgcmV2ZXJzZSBp
ZiBtbHg1X2NvcmUgaXMgJ20nIGFuZCBWTFhBTiBpcyAneSc/DQo+ID4gDQo+ID4gIG1seDVfY29y
ZS1tIDo9IG1seDVfY29yZS5vDQo+ID4gIG1seDVfY29yZS15ICs9IG1seDVfdnhsYW4ubw0KPiA+
IA0KPiA+IE1hZ2ljYWxseSB3b3JrcyBvdXQ/DQo+IA0KPiBZZXMsIEtidWlsZCB0YWtlcyBjYXJl
IG9mIHRoYXQgY2FzZS4NCj4gDQo+ID4gPiA+IElJUkMgdGhhdCBpc24ndCB3aGF0IHRoZSBleHBy
ZXNzaW9uIGRvZXMsIGlmIHZ4bGFuIGlzICduJyB0aGVuDQo+ID4gPiA+ICAgbiB8fCAhbiA9PSB0
cnVlDQo+ID4gPiANCj4gPiA+IEl0IGZvcmNlcyBNTFg1X0NPUkUgdG8gJ20nIG9yICduJyBidXQg
bm90ICd5JyBpZiBWWExBTj1tLA0KPiA+ID4gYnV0IGFsbG93cyBhbnkgb3B0aW9uIGlmIFZYTEFO
PXkNCj4gPiANCj4gPiBBbmQgYW55IG9wdGlvbiBpZiBWWExBTj1uID8NCj4gDQo+IENvcnJlY3Qu
DQo+IA0KDQpHcmVhdCAhDQoNClRoZW4gYm90dG9tIGxpbmUgd2Ugd2lsbCBjaGFuZ2UgbWx4NS9L
Y29uZmlnOiB0bw0KDQpkZXBlbmRzIG9uIFZYTEFOIHx8ICFWWExBTg0KDQpUaGlzIHdpbGwgZm9y
Y2UgTUxYNV9DT1JFIHRvIG0gd2hlbiBuZWNlc3NhcnkgdG8gbWFrZSB2eGxhbiByZWFjaGFibGUN
CnRvIG1seDVfY29yZS4gIFNvIG5vIG5lZWQgZm9yIGV4cGxpY2l0IHVzZSBvZiBJU19SRUFDSEFC
TEUoKS4NCmluIG1seDUgdGhlcmUgYXJlIDQgb2YgdGhlc2U6DQoNCiAgICAgICAgaW1wbHkgUFRQ
XzE1ODhfQ0xPQ0sNCiAgICAgICAgaW1wbHkgVlhMQU4NCiAgICAgICAgaW1wbHkgTUxYRlcNCiAg
ICAgICAgaW1wbHkgUENJX0hZUEVSVl9JTlRFUkZBQ0UNCg0KDQpJIHdpbGwgbWFrZSBhIHBhdGNo
Lg0KDQpUaGFua3MsDQpTYWVlZC4NCg==
