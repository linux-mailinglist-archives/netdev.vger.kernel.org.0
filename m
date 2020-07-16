Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB6C2220B5
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 12:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgGPKhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 06:37:46 -0400
Received: from mail-vi1eur05on2062.outbound.protection.outlook.com ([40.107.21.62]:63468
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726239AbgGPKhp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 06:37:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kqk4dyo43U/6AYzYEL5qfp/tLAgWmEIXnJJgDvFuXREOmSBtVVL1Rc+Ky8mwVsJ57G6DCVRIoxz9j1z6TOtgxT5JvfHWCegBiR2QXIUOfHhK6OoHRomUs+SLv/N4TPA7MgZLgqLAjlrUm8jOArwXx3VGYDJKbqm4AUiIo49hB6exnqDaH/3Cfd0Z3WRpv+InNaBAzlDRRSN8Xp0lO9jsKuLQhUiRfOFUqKqmyGpSnQQwKJM731wt8HrUTKLRMw+o3g71Ss5aANuf8CO9xVgMe+P055sahWt8jOsuqLW6JrqS0u1yCjgTpNNqTXhe0emnWzdDje6zxg1yZTZ/1A6EuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=22JJDXbdeThZZazdARggzHWOttg6LrGuZcY1k4Gmcdw=;
 b=lAyvuA4ocAPO9yEKYOW2xCrxlBdtF1Rw8+dYDxhZhrWVbMEekfyTUqwMiLjff9gk6aku/WP5oC6n+JE6bhSVzcZ0/abjPzWz1Jl1EeQnbXUmxzcFsdx2AkNLup7O2mft/XSPYJbxOmwC+MZQlCHBwouxMj/6QHUpvIjPZ1CCEybKbAVgKerAZ3+wDmcCX69jhqLxcfy0rVak/+ZMqwwO/ekXO0dQ2xPh22X4hbwSGor6WhgTW+HYmN/xf6agWfgD6igMj/xOvImyQo15/ZOPBkhFPAWBL0qtS+MfNdhQ4YbA9/BAAynt5Cdc70Tdd1GpLDFry4v6XrvXdvmYDuglVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=22JJDXbdeThZZazdARggzHWOttg6LrGuZcY1k4Gmcdw=;
 b=f1Mr3I6JM1YPgI2ZUKZTIDhFH9nu4WCxmP/JT7L7lDrX9sGFrj9K+U/e+sC02h6NbzWl7HOOJ5Fj6RJTagS7goRDyHwOXDgWoXjdiKJkxpznZ9me+P5M9GQrEQsPgBfzGUj+5SuoNr4CVG/WTAAtyQJAft9YNXtIDpDWpq7G97Y=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DB8PR04MB5884.eurprd04.prod.outlook.com (2603:10a6:10:b0::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Thu, 16 Jul
 2020 10:37:40 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::b502:cec6:9389:665]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::b502:cec6:9389:665%3]) with mapi id 15.20.3174.026; Thu, 16 Jul 2020
 10:37:40 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     Joergen Andreasen <joergen.andreasen@microchip.com>
CC:     "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Vladimir Oltean <olteanv@gmail.com>, Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "linux-devel@linux.nxdi.nxp.com" <linux-devel@linux.nxdi.nxp.com>
Subject: RE: [EXT] Re: [PATCH v2 net-next 03/10] net: mscc: ocelot: allocated
 rules to different hardware VCAP TCAMs by chain index
Thread-Topic: [EXT] Re: [PATCH v2 net-next 03/10] net: mscc: ocelot: allocated
 rules to different hardware VCAP TCAMs by chain index
Thread-Index: AQHWOJ4IR5sw1Ew6RUWo30td44MCGqjFAIOAgAGq+gCACByDgIABgUeAgAHscQCAN6b3AIAATnYAgAAVANA=
Date:   Thu, 16 Jul 2020 10:37:40 +0000
Message-ID: <DB8PR04MB578594DD3C106D8BDE291B95F07F0@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20200602051828.5734-1-xiaoliang.yang_1@nxp.com>
 <20200602051828.5734-4-xiaoliang.yang_1@nxp.com>
 <20200602083613.ddzjh54zxtbklytw@ws.localdomain>
 <CA+h21hocBOyuDFvnLq-sBEG5phaJPxbhvZ_P5H8HnTkBDv1x+w@mail.gmail.com>
 <20200608135633.jznoxwny6qtzxjng@ws.localdomain>
 <CA+h21hqoZdQeSxTtrEsVEHi6ZP1LrWKQGwZ9zPvjyWZ62TNfbg@mail.gmail.com>
 <20200610181802.2sqdhsoyrkd4awcg@ws.localdomain>
 <DB8PR04MB57851605ACFE209B4E54208EF07F0@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20200716085044.wzwdca535aa5oiv4@soft-dev16>
In-Reply-To: <20200716085044.wzwdca535aa5oiv4@soft-dev16>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 28416226-bfac-49b1-4d4a-08d82974441f
x-ms-traffictypediagnostic: DB8PR04MB5884:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB58847B770D9C2A653CECFB32F07F0@DB8PR04MB5884.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6kOTz63eC48le1uNzGGhFb4QisRGrGoENwCBEKhWn6A766JXMy4vQGVbsr7WknjqFk+MEZy9ZdE2M1Jbs/YRiuCj+pNSldhwGyuKFn7IlhYV5FY2CQf081mV4Hsymd5njbM30rssjWb5SG0fljiW/92U7veZ59VtZ2i/uohS01hWFvGN8muu5q9f/zJJmy32ggsLoxAXUkNqS94jPwaLM3fsmTVL337DdoYFuz/upsvh08eEXEXail72lc1oIrD7p9LRYhtZt5poZtSkDJ19u8slmmcBQKxeDIixQLE3x+xFaBXKv9uuhgVex48sOply
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(346002)(396003)(366004)(136003)(54906003)(76116006)(66446008)(66946007)(7416002)(9686003)(66556008)(66476007)(64756008)(83380400001)(71200400001)(26005)(186003)(8936002)(52536014)(86362001)(7696005)(55016002)(8676002)(33656002)(316002)(2906002)(6506007)(6916009)(5660300002)(478600001)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 8zDsBuUWxth5xvfRKpc/UsFwNFucyDiTQvZ9EExVcJ5Og/WfXlJnjqU6wnx/5VYfPOlKJHdQnO/TR9aoohxwtwuRq7HiKCzNFV3hyB4wZEUlwsU8i0qI6hErPxeN1HezYaoqwkhbHMoHCUxHTQY+h1I2Q8FJnEpaRvbKNSSpPLVBadGWiSA3/aj0INWLpl1yWNdXm+iXucE5Ft+ywm5D/wAYpl0EG9SivmxrgK8ZZklAul+I0UKXXmFSirYXrhY9+bM2cHcwTEV3L26Aehf7WKH6tbYmCz4iPUEp0L8vT2+pzUIsW3rHNE902b5NbQdWGa01bYiG1RTEPA+P8paIl79fmBD74PANpJsIBZu0O44qnQbb1uxUFpV43zEfpHFigffRK1MUsgQtlcEAVdOxO1ZEjUA/LRQgLiN6jXgpIquxBKU39AKi4cepwCkYT3hcYO8MUWpAT9CiuX9ssdUWFpCemt3IPS/65WdNPkrUs7g=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB5785.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28416226-bfac-49b1-4d4a-08d82974441f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2020 10:37:40.6843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WdSIOZtRbKr5CHctzDThWchYOnBStgJoZxo2jNBo1pvKiEWsP6VzobqX7xtyac5PCgp2XLFMqKaGbpuNJyhBgqQxeTYdwZNymMNsZHdK97w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5884
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSm9lcmdlbiwNCg0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogSm9lcmdl
biBBbmRyZWFzZW4gPGpvZXJnZW4uYW5kcmVhc2VuQG1pY3JvY2hpcC5jb20+IA0KU2VudDogMjAy
MOW5tDfmnIgxNuaXpSAxNjo1MQ0KDQo+ID4+ID4+IENoYWluIDA6ICAgICAgICAgICBUaGUgZGVm
YXVsdCBjaGFpbiAtIHRvZGF5IHRoaXMgaXMgaW4gSVMyLiBJZiB3ZSBwcm9jZWVkDQo+ID4+ID4+
ICAgICAgICAgICAgICAgICAgICAgd2l0aCB0aGlzIGFzIGlzIC0gdGhlbiB0aGlzIHdpbGwgY2hh
bmdlLg0KPiA+PiA+PiBDaGFpbiAxLTk5OTk6ICAgICAgVGhlc2UgYXJlIG9mZmxvYWRlZCBieSAi
YmFzaWMiIGNsYXNzaWZpY2F0aW9uLg0KPiA+PiA+PiBDaGFpbiAxMDAwMC0xOTk5OTogVGhlc2Ug
YXJlIG9mZmxvYWRlZCBpbiBJUzENCj4gPj4gPj4gICAgICAgICAgICAgICAgICAgICBDaGFpbiAx
MDAwMDogTG9va3VwLTAgaW4gSVMxLCBhbmQgaGVyZSB3ZSBjb3VsZCBsaW1pdCB0aGUNCj4gPj4g
Pj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgYWN0aW9uIHRvIGRvIFFvUyByZWxh
dGVkIHN0dWZmIChwcmlvcml0eQ0KPiA+PiA+PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICB1cGRhdGUpDQo+ID4+ID4+ICAgICAgICAgICAgICAgICAgICAgQ2hhaW4gMTEwMDA6IExv
b2t1cC0xIGluIElTMSwgaGVyZSB3ZSBjb3VsZCBkbyBWTEFODQo+ID4+ID4+ICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHN0dWZmDQo+ID4+ID4+ICAgICAgICAgICAgICAgICAgICAg
Q2hhaW4gMTIwMDA6IExvb2t1cC0yIGluIElTMSwgaGVyZSB3ZSBjb3VsZCBhcHBseSB0aGUNCj4g
Pj4gPj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIlBBRyIgd2hpY2ggaXMgZXNz
ZW50aWFsbHkgYSBHT1RPLg0KPiA+PiA+Pg0KPiA+PiA+PiBDaGFpbiAyMDAwMC0yOTk5OTogVGhl
c2UgYXJlIG9mZmxvYWRlZCBpbiBJUzINCj4gPj4gPj4gICAgICAgICAgICAgICAgICAgICBDaGFp
biAyMDAwMC0yMDI1NTogTG9va3VwLTAgaW4gSVMyLCB3aGVyZSBDSEFJTi1JRCAtDQo+ID4+ID4+
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDIwMDAwIGlzIHRoZSBQQUcg
dmFsdWUuDQo+ID4+ID4+ICAgICAgICAgICAgICAgICAgICAgQ2hhaW4gMjEwMDAtMjEwMDA6IExv
b2t1cC0xIGluIElTMi4NCj4gPj4gPj4NCj4gPj4gPj4gQWxsIHRoZXNlIGNoYWlucyBzaG91bGQg
YmUgb3B0aW9uYWwgLSB1c2VycyBzaG91bGQgb25seSBuZWVkIHRvIA0KPiA+PiA+PiBjb25maWd1
cmUgdGhlIGNoYWlucyB0aGV5IG5lZWQuIFRvIG1ha2UgdGhpcyB3b3JrLCB3ZSBuZWVkIHRvIA0K
PiA+PiA+PiBjb25maWd1cmUgYm90aCB0aGUgZGVzaXJlZCBhY3Rpb25zIChjb3VsZCBiZSBwcmlv
cml0eSB1cGRhdGUpIGFuZCB0aGUgZ290byBhY3Rpb24uDQo+ID4+ID4+IFJlbWVtYmVyIGluIEhX
LCBhbGwgcGFja2V0cyBnb2VzIHRocm91Z2ggdGhpcyBwcm9jZXNzLCB3aGlsZSBpbiANCj4gPj4g
Pj4gU1cgdGhleSBvbmx5IGZvbGxvdyB0aGUgImdvdG8iIHBhdGguDQo+ID4+ID4+DQo+Pg0KPj4g
SSBhZ3JlZSB3aXRoIHRoaXMgY2hhaW4gYXNzaWdubWVudCwgZm9sbG93aW5nIGlzIGFuIGV4YW1w
bGUgdG8gc2V0IHJ1bGVzOg0KPj4NCj4+IDEuIFNldCBhIG1hdGNoYWxsIHJ1bGUgZm9yIGVhY2gg
Y2hhaW4sIHRoZSBsYXN0IGNoYWluIGRvIG5vdCBuZWVkIGdvdG8gY2hhaW4gYWN0aW9uLg0KPj4g
IyB0YyBmaWx0ZXIgYWRkIGRldiBzd3AwIGNoYWluIDAgZmxvd2VyIHNraXBfc3cgYWN0aW9uIGdv
dG8gY2hhaW4gDQo+PiAxMDAwMCAjIHRjIGZpbHRlciBhZGQgZGV2IHN3cDAgY2hhaW4gMTAwMDAg
Zmxvd2VyIHNraXBfc3cgYWN0aW9uIGdvdG8gDQo+PiBjaGFpbiAyMTAwMCBJbiBkcml2ZXIsIHVz
ZSB0aGVzZSBydWxlcyB0byByZWdpc3RlciB0aGUgY2hhaW4uDQo+Pg0KPj4gMi4gU2V0IG5vcm1h
bCBydWxlcy4NCj4+ICMgdGMgZmlsdGVyIGFkZCBkZXYgc3dwMCBjaGFpbiAxMDAwMCBwcm90b2Nv
bCA4MDIuMVEgcGFyZW50IGZmZmY6IA0KPj4gZmxvd2VyIHNraXBfc3cgdmxhbl9pZCAxIHZsYW5f
cHJpbyAxIGFjdGlvbiBza2JlZGl0IHByaW9yaXR5IDEgYWN0aW9uIA0KPj4gZ290byBjaGFpbiAy
MTAwMCAjIHRjIGZpbHRlciBhZGQgZGV2IHN3cDAgY2hhaW4gMjEwMDAgcHJvdG9jb2wgODAyLjFR
IA0KPj4gcGFyZW50IGZmZmY6IGZsb3dlciBza2lwX3N3IHZsYW5faWQgMSB2bGFuX3ByaW8gMSBh
Y3Rpb24gZHJvcA0KPj4NCj4+IEluIGRyaXZlciwgd2UgY2hlY2sgaWYgdGhlIGNoYWluIElEIGhh
cyBiZWVuIHJlZ2lzdGVyZWQsIGFuZCBnb3RvIGNoYWluIGlzIHRoZSBzYW1lIGFzIGZpcnN0IG1h
dGNoYWxsIHJ1bGUsIGlmIGlzIG5vdCwgdGhlbiByZXR1cm4gZXJyb3IuIEVhY2ggcnVsZSBuZWVk
IGhhcyBnb3RvIGFjdGlvbiBleGNlcHQgbGFzdCBjaGFpbi4NCj4+DQo+PiBJIGFsc28gaGF2ZSBj
aGVjayBhYm91dCBjaGFpbiB0ZW1wbGF0ZSwgaXQgY2FuIG5vdCBzZXQgYW4gYWN0aW9uIHRlbXBs
YXRlIGZvciBlYWNoIGNoYWluLCBzbyBJIHRoaW5rIGl0J3Mgbm8gdXNlIGZvciBvdXIgY2FzZS4g
SWYgdGhpcyB3YXkgdG8gc2V0IHJ1bGVzIGlzIE9LLCBJIHdpbGwgdXBkYXRlIHRoZSBwYXRjaCB0
byBkbyBhcyB0aGlzLg0KPj4NCj4+IFRoYW5rcywNCj4+IFhpYW9saWFuZyBZYW5nDQo+DQoNCj4g
SSBhZ3JlZSB0aGF0IHlvdSBjYW5ub3Qgc2V0IGFuIGFjdGlvbiB0ZW1wbGF0ZSBmb3IgZWFjaCBj
aGFpbiBidXQgeW91IGNhbiBzZXQgYSBtYXRjaCB0ZW1wbGF0ZSB3aGljaCBmb3IgZXhhbXBsZSBj
YW4gYmUgdXNlZCBmb3Igc2V0dGluZyB1cCB3aGljaCBJUzEga2V5IHRvIGdlbmVyYXRlIGZvciB0
aGUgZGV2aWNlL3BvcnQuDQo+IFRoZSB0ZW1wbGF0ZSBlbnN1cmVzIHRoYXQgeW91IGNhbm5vdCBh
ZGQgYW4gaWxsZWdhbCBtYXRjaC4NCj4gSSBoYXZlIGF0dGFjaGVkIGEgc25pcHBldCBmcm9tIGEg
dGVzdGNhc2UgSSB3cm90ZSBpbiBvcmRlciB0byB0ZXN0IHRoZXNlIGlkZWFzLg0KPiBOb3RlIHRo
YXQgbm90IGFsbCBhY3Rpb25zIGFyZSB2YWxpZCBmb3IgdGhlIGhhcmR3YXJlLg0KPg0KPiBTTUFD
ICAgICAgID0gIjAwOjAwOjAwOjExOjExOjExIg0KPiBETUFDICAgICAgID0gIjAwOjAwOjAwOmRk
OmRkOmRkIg0KPiBWSUQxICAgICAgID0gMHgxMA0KPiBWSUQyICAgICAgID0gMHgyMA0KPiBQQ1Ax
ICAgICAgID0gMw0KPiBQQ1AyICAgICAgID0gNQ0KPiBERUkgICAgICAgID0gMQ0KPiBTSVAgICAg
ICAgID0gIjEwLjEwLjAuMSINCj4gRElQICAgICAgICA9ICIxMC4xMC4wLjIiDQo+DQo+IElTMV9M
MCAgICAgPSAxMDAwMCAjIElTMSBsb29rdXAgMA0KPiBJUzFfTDEgICAgID0gMTEwMDAgIyBJUzEg
bG9va3VwIDENCj4gSVMxX0wyICAgICA9IDEyMDAwICMgSVMxIGxvb2t1cCAyDQo+DQo+IElTMl9M
MCAgICAgPSAyMDAwMCAjIElTMiBsb29rdXAgMCAjIElTMiAyMDAwMCAtIDIwMjU1IC0+IHBhZyAw
LTI1NQ0KPiBJUzJfTDBfUDEgID0gMjAwMDEgIyBJUzIgbG9va3VwIDAgcGFnIDENCj4gSVMyX0ww
X1AyICA9IDIwMDAyICMgSVMyIGxvb2t1cCAwIHBhZyAyDQo+DQo+IElTMl9MMSAgICAgPSAyMTAw
MCAjIElTMiBsb29rdXAgMQ0KPg0KPiAkc2tpcCA9ICJza2lwX2h3IiAjIG9yICJza2lwX3N3Ig0K
Pg0KPiB0ZXN0ICJDaGFpbiB0ZW1wbGF0ZXMgYW5kIGdvdG8iIGRvDQo+ICAgICB0X2kgIidwcmlv
ICMnIHNldHMgdGhlIHNlcXVlbmNlIG9mIGZpbHRlcnMuIExvd2VzdCBudW1iZXIgPSBoaWdoZXN0
IHByaW9yaXR5ID0gY2hlY2tlZCBmaXJzdC4gMC4uMHhmZmZmIg0KPiAgICAgdF9pICInaGFuZGxl
ICMnIGlzIGEgcmVmZXJlbmNlIHRvIHRoZSBmaWx0ZXIuIFVzZSB0aGlzIGlzIGlmIHlvdSBuZWVk
IHRvIHJlZmVyZW5jZSB0aGUgZmlsdGVyIGxhdGVyLiAwLi4weGZmZmZmZmZmIg0KPiAgICAgdF9p
ICInY2hhaW4gIycgaXMgdGhlIGNoYWluIHRvIHVzZS4gQ2hhaW4gMCBpcyB0aGUgZGVmYXVsdC4g
RGlmZmVyZW50IGNoYWlucyBjYW4gaGF2ZSBkaWZmZXJlbnQgdGVtcGxhdGVzLiAwLi4weGZmZmZm
ZmZmIg0KPiAgICAgJHRzLmR1dC5ydW4gInRjIHFkaXNjIGFkZCBkZXYgI3skZHBbMF19IGNsc2Fj
dCINCj4NCj4gICAgIHRfaSAiQWRkIHRlbXBsYXRlcyINCj4gICAgIHRfaSAiQ29uZmlndXJlIHRo
ZSBWQ0FQIHBvcnQgY29uZmlndXJhdGlvbiB0byBtYXRjaCB0aGUgc2hvcnRlc3Qga2V5IHRoYXQg
ZnVsZmlsbCB0aGUgcHVycG9zZSINCg0KPiAgICAgdF9pICJDcmVhdGUgYSB0ZW1wbGF0ZSB0aGF0
IHNldHMgSVMxIGxvb2t1cCAwIHRvIGdlbmVyYXRlIFMxX05PUk1BTCB3aXRoIFMxX0RNQUNfRElQ
X0VOQSINCj4gICAgIHRfaSAiSWYgeW91IG1hdGNoIG9uIGJvdGggc3JjIGFuZCBkc3QgeW91IHdp
bGwgZ2VuZXJhdGUgUzFfN1RVUExFIg0KPiAgICAgJHRzLmR1dC5ydW4gInRjIGNoYWluIGFkZCBk
ZXYgI3skZHBbMF19IGluZ3Jlc3MgcHJvdG9jb2wgaXAgY2hhaW4gI3tJUzFfTDB9IGZsb3dlciAj
eyRza2lwfSAiXA0KPiAgICAgICAgICAgICAgICAgImRzdF9tYWMgMDA6MDA6MDA6MDA6MDA6MDAg
IlwNCj4gICAgICAgICAgICAgICAgICJkc3RfaXAgMC4wLjAuMCAiDQo+DQo+ICAgICB0X2kgIkNy
ZWF0ZSBhIHRlbXBsYXRlIHRoYXQgc2V0cyBJUzEgbG9va3VwIDEgdG8gZ2VuZXJhdGUgUzFfNVRV
UExFX0lQNCINCj4gICAgICR0cy5kdXQucnVuICJ0YyBjaGFpbiBhZGQgZGV2ICN7JGRwWzBdfSBp
bmdyZXNzIHByb3RvY29sIGlwIGNoYWluICN7SVMxX0wxfSBmbG93ZXIgI3skc2tpcH0gIlwNCj4g
ICAgICAgICAgICAgICAgICJzcmNfaXAgMC4wLjAuMCAiXA0KPiAgICAgICAgICAgICAgICAgImRz
dF9pcCAwLjAuMC4wICINCj4NCj4gICAgIHRfaSAiQ3JlYXRlIGEgdGVtcGxhdGUgdGhhdCBzZXRz
IElTMSBsb29rdXAgMiB0byBnZW5lcmF0ZSBTMV9EQkxfVklEIg0KPiAgICAgJHRzLmR1dC5ydW4g
InRjIGNoYWluIGFkZCBkZXYgI3skZHBbMF19IGluZ3Jlc3MgcHJvdG9jb2wgODAyLjFhZCBjaGFp
biAje0lTMV9MMn0gZmxvd2VyICN7JHNraXB9ICJcDQo+ICAgICAgICAgICAgICAgICAidmxhbl9p
ZCAwICJcDQo+ICAgICAgICAgICAgICAgICAidmxhbl9wcmlvIDAgIlwNCj4gICAgICAgICAgICAg
ICAgICJ2bGFuX2V0aHR5cGUgODAyLjFxICJcDQo+ICAgICAgICAgICAgICAgICAiY3ZsYW5faWQg
MCAiXA0KPiAgICAgICAgICAgICAgICAgImN2bGFuX3ByaW8gMCAiDQo+DQo+ICAgICAkdHMuZHV0
LnJ1biAidGMgY2hhaW4gc2hvdyBkZXYgI3skZHBbMF19IGluZ3Jlc3MiDQoNCldoeSB5b3Ugc2V0
IGRpZmZlcmVudCBmaWx0ZXIga2V5cyBvbiBkaWZmZXJlbnQgbG9va3VwPyBFYWNoIGxvb2t1cCBv
bmx5IGZpbHRlciBvbmUgdHlwZSBvZiBrZXlzPw0KSWYgSSB3YW50IHRvIGZpbHRlciBhIHNhbWUg
a2V5IGxpa2UgZHN0X21hYyBhbmQgZG8gYm90aCBRb1MgY2xhc3NpZmllZCBhY3Rpb24gYW5kIHZs
YW4gbW9kaWZ5IGFjdGlvbiwgaG93IHRvIGltcGxlbWVudCB0aGlzIGluIHRoZSBzYW1lIGNoYWlu
ICN7SVMxX0wwfSA/DQoNCkkgdGhpbmsgaXQncyBtb3JlIHJlYXNvbmFibGUgdG8gZGlzdGluZ3Vp
c2ggZGlmZmVyZW50IGxvb2t1cCBieSBkaWZmZXJlbnQgYWN0aW9uIGxpa2UgdGhpczoNCklTMV9M
MCAgICAgPSAxMDAwMCAjIElTMSBsb29rdXAgMAkjIGRvIFFvUyBjbGFzc2lmaWVkIGFjdGlvbg0K
SVMxX0wxICAgICA9IDExMDAwICMgSVMxIGxvb2t1cCAxCSMgZG8gdmxhbiBtb2RpZnkgYWN0aW9u
DQpJUzFfTDIgICAgID0gMTIwMDAgIyBJUzEgbG9va3VwIDIJIyBkbyBnb3RvIFBBRyBhY3Rpb24N
Cg0KSVMyX0wwICAgICA9IDIwMDAwICMgSVMyIGxvb2t1cCAwICMgSVMyIDIwMDAwIC0gMjAyNTUg
LT4gcGFnIDAtMjU1DQpJUzJfTDEgCSAgPSAyMTAwMCAjIElTMiBsb29rdXAgMQ0KDQpTbyBpdOKA
mXMgbm8gbmVlZCB0byBhZGQgdGVtcGxhdGVzLCBlYWNoIGxvb2t1cCBjYW4gc3VwcG9ydCBmaWx0
ZXJpbmcgbWFjLCBJUCBvciB2bGFuIHRhZywgYnV0IG9ubHkgc3VwcG9ydCBvbmUgYWN0aW9uLg0K
DQpUaGFua3MsDQpYaWFvbGlhbmcNCg==
