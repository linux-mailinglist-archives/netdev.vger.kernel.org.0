Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1603420E429
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731354AbgF2VVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729761AbgF2Swn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:52:43 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on0605.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0c::605])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99AF8C00F81B;
        Mon, 29 Jun 2020 05:32:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fu4rBARA8HLJOUDjNg9TdihldLCjmsl5aNvWnkeEUrRGUJfdI4GF0NVnn+R5Mzt+E+HuvuRSCBxW4m8HYJv91z19rluRti1g8o1zR7uVqbuFMzjtNN1f67O5zfgVD2c+Iju4KoPD2j/JZJNd4AQG3A2GObRQZ6lWBDoCQGS0wEzXyF1h/PyYltVcXLY50MsKxnZSrXcJSNE0IMjnoa3F6NNMiGVgPowizpTwkFFuDzEd/r6k3X9asQyY7hQUqMHTlup/qGqhh/GdDYQqFW1/Gzun/bFyvdpJ+FO9plOxjC/Y3T8ajKQ7k15ZfuLqXb6bzfV+Ql+Du88f/TPbDllHXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pi0+wksIBH6vO/kEi0aNA4dudTsDzaumiu9XXOUTLyA=;
 b=RYgE9wIJeCyWZqQ8Vdjx24aDuog7TGh2k3K5+8WLZ9vaTGnCCxCnCg++KIGuPlRjM9iwLW4xrdih89ToADPfSBxm3uKVtXxGdOxJ9VHeEq3RObJzuXcqtCAjUQueTG309sEpbAaCNGkdL2ssdbMwnfPB37EovRudstX3SKGbozk1uVNjxK+r2AwAr+wl/j3wKL/OHA+tCnwOyoqi52g0uAY+/1aXM1sXAMsmEYxEbwaEd7ykUDtTOx1MjAaS4b98t5G69KlKdCDs6bwKCs5Hv7B4xwOUIgxOZPU2ir9zaTDv7+TCpa49a5AArhxymWfOMWdrcAXg5tH87CjF1tLGTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pi0+wksIBH6vO/kEi0aNA4dudTsDzaumiu9XXOUTLyA=;
 b=gHqBbctKGxHXD7XDSaTpFntMUhbT3gpncZWr00sYMRXii1Q2jP3U5ub0ZHI7nYxoucgsQ+m4OyR9zjC7hkhTvGLROjydWL9HZpW4mX90ZG1jmG4584yH5dWJKsjoPXVc9LfCw9Ow1xqGAPwe+41+RsJaOC+HIS1axl/A5NUq6DQ=
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (2603:10a6:208:119::33)
 by AM0PR04MB4625.eurprd04.prod.outlook.com (2603:10a6:208:71::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.26; Mon, 29 Jun
 2020 12:32:45 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd%7]) with mapi id 15.20.3131.026; Mon, 29 Jun 2020
 12:32:45 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: RE: [EXT] Re: [PATCH net-next v3 7/7] arm64: dts: add serdes and mdio
 description
Thread-Topic: [EXT] Re: [PATCH net-next v3 7/7] arm64: dts: add serdes and
 mdio description
Thread-Index: AQHWSJoQi+Vi6V9y00S3MlK6FZtCgqjrSQuAgARDaqA=
Date:   Mon, 29 Jun 2020 12:32:45 +0000
Message-ID: <AM0PR04MB5443841EE53D93C686AB1E4AFB6E0@AM0PR04MB5443.eurprd04.prod.outlook.com>
References: <1592832924-31733-1-git-send-email-florinel.iordache@nxp.com>
 <1592832924-31733-8-git-send-email-florinel.iordache@nxp.com>
 <10dc033c-1a1c-9eb3-f27b-c0ea279e5169@gmail.com>
In-Reply-To: <10dc033c-1a1c-9eb3-f27b-c0ea279e5169@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [86.126.18.63]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 546bbac9-d23e-47a7-d4de-08d81c288677
x-ms-traffictypediagnostic: AM0PR04MB4625:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB462500566A85458F692CEF14FB6E0@AM0PR04MB4625.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vsPxN3H3xwYOO1VROQuV7U8A3TdbVvmpE1i7yAzOS2J14/NCetStD+UVC+ee7NIHuwNCYkpcrF+Wg2xzazZ06wOxxBcFEzWQ9yv6U8oZwSaq+6PwjKpIHMT7m4ufbzDLwlDPSnQUg7GWB73e+Hr8R07ovcTUfpYiV9diJ10m7zaaiH5u0jZb1UTfjUjlBFo2n7vG5t9wFV/APdfBTYHsRzshERe1GebWKsUNg02UGXfH5IYx7lwmcw5vFIFEinQkdqKsuvJZYGk+0I95xaEs3HjfPxOd63VZ/9wKpUJ48zI5rHCKKYRGgFJKKVg8N2tf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(346002)(366004)(376002)(396003)(8936002)(53546011)(6506007)(316002)(110136005)(26005)(83380400001)(7696005)(71200400001)(186003)(5660300002)(33656002)(76116006)(44832011)(55016002)(8676002)(478600001)(2906002)(66946007)(52536014)(54906003)(66476007)(9686003)(66556008)(64756008)(66446008)(86362001)(4326008)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: lK9/9a4+ICor9KdP+0D7JmxOp7ghfpoWIQvad/msqqMreSc6YoIhBRjth7Z1lW9HB9RLHdu7Q05vVNbFLdiamlN5qe10e/o2jZNuHDBlJLAvUejX8gR4TrjB3DJ2uP4Q+6Ok8FgEw/DXVock8+erlKKbt1sS6bne/AKja5Tya2RA6pX699nT0K+jtGFjsdc4DSiFPbesQjm8nLX8Bg2LLFnmk2SheXmF5iWru5RDQT0M6nxUQDS+GBpmo45NFCqi9VEB41ZDwo25+KNyaX6XsdS30+qGS+9DmQ48ccZ5eCQp5Utzfae73uJ4iHOD64xhKgBtACOSdo4XGARcsCjWGGXIF04iKHluJYCzp1yd9ak1PxR4BPTjonFcdAozLztYbNFafe35at+y3/oPl36d/QArDsPi98vCFCTZ7iqa+8MdS73PbhuFrGgRghpMyZ0jAPe2y/FKM0Val7z24DHBgRl1oVw9CyUbsnNzSJIAD+M=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5443.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 546bbac9-d23e-47a7-d4de-08d81c288677
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 12:32:45.2495
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L9mLjYrDCuiyAu9jbXEvStOT9wWfc8/LR+pa2Pzn0gMUe7wky3Der9WZvQJRpW/Z3CtZ08V4nqGjtF+weQR1yrPWUY9843Ga2ZqgNxce7hY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4625
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEZsb3JpYW4gRmFpbmVsbGkg
PGYuZmFpbmVsbGlAZ21haWwuY29tPg0KPiBTZW50OiBGcmlkYXksIEp1bmUgMjYsIDIwMjAgMTA6
MDggUE0NCj4gVG86IEZsb3JpbmVsIElvcmRhY2hlIDxmbG9yaW5lbC5pb3JkYWNoZUBueHAuY29t
PjsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgYW5kcmV3
QGx1bm4uY2g7IGhrYWxsd2VpdDFAZ21haWwuY29tOw0KPiBsaW51eEBhcm1saW51eC5vcmcudWsN
Cj4gQ2M6IGRldmljZXRyZWVAdmdlci5rZXJuZWwub3JnOyBsaW51eC1kb2NAdmdlci5rZXJuZWwu
b3JnOw0KPiByb2JoK2R0QGtlcm5lbC5vcmc7IG1hcmsucnV0bGFuZEBhcm0uY29tOyBrdWJhQGtl
cm5lbC5vcmc7DQo+IGNvcmJldEBsd24ubmV0OyBzaGF3bmd1b0BrZXJuZWwub3JnOyBMZW8gTGkg
PGxlb3lhbmcubGlAbnhwLmNvbT47IE1hZGFsaW4NCj4gQnVjdXIgKE9TUykgPG1hZGFsaW4uYnVj
dXJAb3NzLm54cC5jb20+OyBJb2FuYSBDaW9ybmVpDQo+IDxpb2FuYS5jaW9ybmVpQG54cC5jb20+
OyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFtFWFRdIFJlOiBbUEFU
Q0ggbmV0LW5leHQgdjMgNy83XSBhcm02NDogZHRzOiBhZGQgc2VyZGVzIGFuZCBtZGlvDQo+IGRl
c2NyaXB0aW9uDQo+IA0KPiBDYXV0aW9uOiBFWFQgRW1haWwNCj4gDQo+IE9uIDYvMjIvMjAgNjoz
NSBBTSwgRmxvcmluZWwgSW9yZGFjaGUgd3JvdGU6DQo+ID4gQWRkIGR0IG5vZGVzIHdpdGggc2Vy
ZGVzLCBsYW5lcywgbWRpbyBnZW5lcmljIGRlc2NyaXB0aW9uIGZvcg0KPiA+IHN1cHBvcnRlZA0K
PiA+IHBsYXRmb3JtOiBsczEwNDYuIFRoaXMgaXMgYSBwcmVyZXF1aXNpdGUgdG8gZW5hYmxlIGJh
Y2twbGFuZSBvbiBkZXZpY2UNCj4gPiB0cmVlIGZvciB0aGVzZSBwbGF0Zm9ybXMuDQo+ID4NCj4g
PiBTaWduZWQtb2ZmLWJ5OiBGbG9yaW5lbCBJb3JkYWNoZSA8ZmxvcmluZWwuaW9yZGFjaGVAbnhw
LmNvbT4NCj4gPiAtLS0NCj4gDQo+IFtzbmlwXQ0KPiANCj4gPiBAQCAtMjEsNyArMjIsNyBAQCBm
bWFuQDFhMDAwMDAgew0KPiA+ICAgICAgICAgICAgICAgZnNsLGZtYW4tMTBnLXBvcnQ7DQo+ID4g
ICAgICAgfTsNCj4gPg0KPiA+IC0gICAgIGV0aGVybmV0QGYyMDAwIHsNCj4gPiArICAgICBtYWMx
MDogZXRoZXJuZXRAZjIwMDAgew0KPiA+ICAgICAgICAgICAgICAgY2VsbC1pbmRleCA9IDwweDk+
Ow0KPiA+ICAgICAgICAgICAgICAgY29tcGF0aWJsZSA9ICJmc2wsZm1hbi1tZW1hYyI7DQo+ID4g
ICAgICAgICAgICAgICByZWcgPSA8MHhmMjAwMCAweDEwMDA+Ow0KPiA+IEBAIC0yOSw3ICszMCw3
IEBAIGZtYW5AMWEwMDAwMCB7DQo+ID4gICAgICAgICAgICAgICBwY3NwaHktaGFuZGxlID0gPCZw
Y3NwaHk3PjsNCj4gPiAgICAgICB9Ow0KPiA+DQo+ID4gLSAgICAgbWRpb0BmMzAwMCB7DQo+ID4g
KyAgICAgbWRpbzEwOiBtZGlvQGYzMDAwIHsNCj4gPiAgICAgICAgICAgICAgICNhZGRyZXNzLWNl
bGxzID0gPDE+Ow0KPiA+ICAgICAgICAgICAgICAgI3NpemUtY2VsbHMgPSA8MD47DQo+ID4gICAg
ICAgICAgICAgICBjb21wYXRpYmxlID0gImZzbCxmbWFuLW1lbWFjLW1kaW8iLCAiZnNsLGZtYW4t
eG1kaW8iOw0KPiANCj4gVGhhdCBwYXJ0IG9mIHRoZSBwYXRjaCBkb2VzIG5vdCBzZWVtIHRvIGhh
dmUgYW55IHVzZXJzLCB0aGVyZSBpcyBub3RoaW5nIGluIHlvdXINCj4gcGF0Y2ggc2VyaWVzIHRo
YXQgcmVmZXJlbmNlcyBtYWM5LCBtZGlvOSBvciBtYWMxMCwgbWRpbzEwIEFGQUlDVC4gTWF5YmUg
eW91DQo+IGNhbiBzcGxpdCBpdCB1cCBhbmQgc2VuZCBpdCBhc2lkZSBmcm9tIHRoaXMgc2VyaWVz
Pw0KPiAtLQ0KPiBGbG9yaWFuDQoNCkhpIEZsb3JpYW4sDQoNClRoZXNlIGxhYmVscyBhcmUgdXNl
ZCBpbiB0aGUgcGxhdGZvcm0gRFRTIChlLmcuOiBmc2wtbHMxMDQ2YS1yZGIuZHRzIGZvciBEUEFB
MSAvIExTMTA0NikuDQpUaGV5IGFyZSBub3QgdXNlZCBpbiB0aGUgcGF0Y2ggYmVjYXVzZSBiYWNr
cGxhbmUgbW9kZSBpcyBOT1QgdGhlIGRlZmF1bHQgbW9kZS4NCkJhY2twbGFuZSBtb2RlIGlzIGVu
YWJsZWQgYnkgdXNlcnMgZm9yIGN1c3RvbSBib2FyZHMgYnkgZWRpdGluZyB0aGUgRFRTLg0KSW50
ZXJmYWNlcyBtdXN0IGJlIHVzZWQgYnkgZGVmYXVsdCB3aXRoIGEgUEhZIGxpa2U6IHBoeS1oYW5k
bGUgPSA8JmFxcjEwNl9waHk+DQpIb3cgdG8gZW5hYmxlIGJhY2twbGFuZSBtb2RlIGluIERUUyBp
cyBkZXNjcmliZWQgaW4gZGV2aWNldHJlZSBiaW5kaW5ncyBmaWxlOiBldGhlcm5ldC1waHkueWFt
bA0KKHdoaWNoIGluY2x1ZGVzIGFuIGV4YW1wbGUgYXQgdGhlIGVuZCkuDQoNCkhlcmUgaXMgYW4g
ZXhhbXBsZSBvZiBob3cgdGhlIGxhYmVscyBhcmUgdXNlZCB0byBlbmFibGUgYmFja3BsYW5lIG1v
ZGU6DQombWRpbzkgew0KCXBjc3BoeTY6IGV0aGVybmV0LXBoeUAwIHsNCgkJY29tcGF0aWJsZSA9
ICJldGhlcm5ldC1waHktaWVlZTgwMi4zLWM0NSI7DQoJCWVxLWFsZ29yaXRobSA9ICJiZWUiOw0K
CQkvKiAxMEcgU2hvcnQgY2FibGVzIHNldHVwOiB1cCB0byAzMCBjbSBjYWJsZSAqLw0KCQllcS1p
bml0ID0gPDB4MiAweDI5IDB4NT47DQoJCWVxLXBhcmFtcyA9IDwwPjsNCgkJcmVnID0gPDB4MD47
DQoJCWxhbmUtaGFuZGxlID0gPCZsYW5lX2Q+OyAgIC8qIGxhbmUgRCAqLw0KCX07DQp9Ow0KLyog
VXBkYXRlIE1BQyBjb25uZWN0aW9ucyB0byBiYWNrcGxhbmUgUEhZcyAqLw0KJm1hYzkgew0KCXBo
eS1jb25uZWN0aW9uLXR5cGUgPSAiMTBnYmFzZS1rciI7DQoJcGh5LWhhbmRsZSA9IDwmcGNzcGh5
Nj47DQp9Ow0KDQpIb3dldmVyLCB0aGUgdXNlcnMgY291bGQgd3JpdGUgRFRTIGJ5IHVzaW5nIGV0
aGVybmV0QGYwMDAwIGluc3RlYWQgb2YgJm1hYzkuDQpTb21ldGhpbmcgbGlrZSB0aGlzOg0KZXRo
ZXJuZXRAZjAwMDAgeyAvKiAxMEdFQzEgKi8NCglwaHktY29ubmVjdGlvbi10eXBlID0gIjEwZ2Jh
c2Uta3IiOw0KCXBoeS1oYW5kbGUgPSA8JnBjc3BoeTY+Ow0KfTsNCihhbmQgc2ltaWxhciBmb3Ig
bWRpbzkvbWRpbzEwKQ0KU28gdWx0aW1hdGVseSB0aGF0IHBhcnQgb2YgdGhlIHBhdGNoIGNvdWxk
IGJlIHJlbW92ZWQgaW5kZWVkLg0KSSBwdXQgaXQgdGhlcmUganVzdCB0byBiZSBtb3JlIHVzZXIg
ZnJpZW5kbHkgdG8gZW5hYmxlIGJhY2twbGFuZSBpbiBEVFMuDQoNClRoYW5rIHlvdSBmb3IgZmVl
ZGJhY2suDQpGbG9yaW5lbC4NCg==
