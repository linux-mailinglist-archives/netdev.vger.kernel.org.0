Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A929221CCF
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 08:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgGPGtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 02:49:14 -0400
Received: from mail-eopbgr00043.outbound.protection.outlook.com ([40.107.0.43]:5506
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728036AbgGPGtN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 02:49:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oNVpeC7qO5IWHmLYZbDFn4CsG+F0HoyNKUiPtsGdhK7ahhi9Vc12kif8lnqwTegzk7MHTbZvXGbWG+F8MQU+nPEHFPSKa4M1r3rkw7MkniQtuF7ON2PYk6p3JD2oZUcaA9QvP3d0nqZbXtNb3PI0cbyYGbwaDCZnIXA/UF5mgbaiDtbc7H9xGKq8fpXo0kJf3PLJ99cYwIdgkr6QCgxiY8wQeC8L8lUoAyKuMajL6k4d2o98yha+zLGTA4Ri5vWA4tfTNPVELo0yt8PXhSfMenVQfFrr11YBQ5Xl0KsqZkKANDDuRCZhVkh0dSxEHGVX6YzykVHJSxe1S6xXBgAnrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YGX4OjM2wLwxGZ8vctQebaIuaCA0LiKNYdCHhaev3bU=;
 b=JKg5retGyCEnrbskGHAoD44sQHQK+qMqwzVo6pBsVfMEGr3Lz6nsOtVyEyPNkMCvFIw8vSpmRYNhfD/qg7rhG53IrvZ1oC6vm5Q7cDtKlr3h2GmvVrrPeWJVWYrgFGuRXErCToI6EtsRAZ/rT9OVnQt/XWDFNOtQF0ckZ9Z4KtA7SPAQRLsQFRZgz5USCpP57wOc7mpvdn7cLSeIO3HUlxmAqpTzbB7hoNiDWDxX+EoAUKw+mW1fR01DM34Vqg1XoV/pZNBoxsKVA0qA35zRGM+V0Xr1IPdPnpkHyJtHJ/T5Y6WiHvYpGPhERmVHeIJm1ucIqI4+qqsev6SeREopiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YGX4OjM2wLwxGZ8vctQebaIuaCA0LiKNYdCHhaev3bU=;
 b=Uj/0xDaO5CnaSI4sWhOo75QpdwssWQEe78aIN5nmSIBcJ6oDR1pmGsU6ISor/haZw4+ujALGpb1rXxswFHVkoohgOB2c+e0yMO3CxYD3vJ6ygwfz0m3q0M/plTrXWV8zPQm3GiwDZ9QIp9RjXXTxg1na4MoQbpHn82Ci6jd7ZMI=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DB7PR04MB5498.eurprd04.prod.outlook.com (2603:10a6:10:80::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Thu, 16 Jul
 2020 06:49:09 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::b502:cec6:9389:665]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::b502:cec6:9389:665%3]) with mapi id 15.20.3174.026; Thu, 16 Jul 2020
 06:49:09 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     Po Liu <po.liu@nxp.com>, Claudiu Manoil <claudiu.manoil@nxp.com>,
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
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "linux-devel@linux.nxdi.nxp.com" <linux-devel@linux.nxdi.nxp.com>
Subject: RE: [EXT] Re: [PATCH v2 net-next 03/10] net: mscc: ocelot: allocated
 rules to different hardware VCAP TCAMs by chain index
Thread-Topic: [EXT] Re: [PATCH v2 net-next 03/10] net: mscc: ocelot: allocated
 rules to different hardware VCAP TCAMs by chain index
Thread-Index: AQHWOJ4IR5sw1Ew6RUWo30td44MCGqjFAIOAgAGq+gCACByDgIABgUeAgAHscQCAN6b3AA==
Date:   Thu, 16 Jul 2020 06:49:09 +0000
Message-ID: <DB8PR04MB57851605ACFE209B4E54208EF07F0@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20200602051828.5734-1-xiaoliang.yang_1@nxp.com>
 <20200602051828.5734-4-xiaoliang.yang_1@nxp.com>
 <20200602083613.ddzjh54zxtbklytw@ws.localdomain>
 <CA+h21hocBOyuDFvnLq-sBEG5phaJPxbhvZ_P5H8HnTkBDv1x+w@mail.gmail.com>
 <20200608135633.jznoxwny6qtzxjng@ws.localdomain>
 <CA+h21hqoZdQeSxTtrEsVEHi6ZP1LrWKQGwZ9zPvjyWZ62TNfbg@mail.gmail.com>
 <20200610181802.2sqdhsoyrkd4awcg@ws.localdomain>
In-Reply-To: <20200610181802.2sqdhsoyrkd4awcg@ws.localdomain>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 328eabbf-f913-4d43-e283-08d829545777
x-ms-traffictypediagnostic: DB7PR04MB5498:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB5498FD61CD2A35EB8BD87A3EF07F0@DB7PR04MB5498.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0U7oulUowWWbgylU3A0Bl1Vy8uooLNtIdK64RjBr32ybmH2iyL1iy3+OCKDON+JL4A9r+rZXKGmIZsqxjD0VSzzhygatYCVfav4nYYnRP7vNrW5fqL1dwsf04cJvMKmnKA5TG4RAzINi5e+D9wH8xnYB5vzYxFvSW26BqDgCgTCj8BIg5/gbi3RSLGsvo8rdwGKqRWsxy0SMVpXs/jZ0d7j+7xCf1KAqnpy8Pqsx9X09DCNmX0LiJfDaaXYNuFZlCB1gHDKRi6sJfzoojwG9e3Tc7hrDnzz+7haojoqlMcCFMWKiM9rYHy5SqXFDQwr/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(66476007)(2906002)(33656002)(478600001)(55016002)(86362001)(26005)(8936002)(52536014)(7416002)(316002)(66556008)(54906003)(7696005)(66946007)(71200400001)(186003)(64756008)(76116006)(6506007)(5660300002)(8676002)(66446008)(83380400001)(53546011)(9686003)(110136005)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Z30DLjBMMwD6UPpTB2UUt5X3kU1Mp73H/RWKkcY0w/SECQzllnQ2PHKY6G9uDqBdSo2lYfosjjDoTObB7WvqKXMeBnSVmT7gUQW/1mS/35ZIdCnZq4LszFGPPRQfRNOQEAmc4lwV2gqB3E0L3dPsIsvTTlb2hgEJsa23t7PmPlU5B1nyT+2g6TOC6I2iE/XQzJxR3J5zFM1YmcwzixNQgxwUBsSAqFD60lAeT50IGvX1X1H/cwTHA5NTOFrGUPatsdyhB8ISzLAdH8FN/e8WgXGmXcaRc3/+l0UVCnrDWBUDe0a1h+6nANblXqdD6XxJFXV52YUbbM+qk5Uu2cE+7r7QF53Dc/8rrsb3S0L840juu23vF0Ks3R+47E+jSOcHzHs0hmIixCjHxvgsJI5ew5ICbN5oWlgZhLK3jau4slphNAObRJC3SathmNmD4mfRcYXSAaS2EJ74eqKZwRetan5AsuqyYuMY00BGcRO+CHw=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB5785.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 328eabbf-f913-4d43-e283-08d829545777
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2020 06:49:09.2552
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4hNNKpxn//r7DQJ/v4OxCWMTYcsyKn9HM4Ua1LVI2CQVtDRLDGRLBeIPqwQbXULHYpz46XNZFB3TZgV08VpZpBDaIIhVTedppXCQSbHfw5o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5498
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQWxsYW4sDQoNCk9uIDExLjA2LjIwMDIgMjoxOCwgQWxsYW4gVy4gTmllbHNlbiA8YWxsYW4u
bmllbHNlbkBtaWNyb2NoaXAuY29tPiB3cm90ZToNCj4+ID4+IEhlcmUgaXMgbXkgaW5pdGlhbCBz
dWdnZXN0aW9uIGZvciBhbiBhbHRlcm5hdGl2ZSBjaGFpbi1zY2hlbWE6DQo+PiA+Pg0KPj4gPj4g
Q2hhaW4gMDogICAgICAgICAgIFRoZSBkZWZhdWx0IGNoYWluIC0gdG9kYXkgdGhpcyBpcyBpbiBJ
UzIuIElmIHdlIHByb2NlZWQNCj4+ID4+ICAgICAgICAgICAgICAgICAgICAgd2l0aCB0aGlzIGFz
IGlzIC0gdGhlbiB0aGlzIHdpbGwgY2hhbmdlLg0KPj4gPj4gQ2hhaW4gMS05OTk5OiAgICAgIFRo
ZXNlIGFyZSBvZmZsb2FkZWQgYnkgImJhc2ljIiBjbGFzc2lmaWNhdGlvbi4NCj4+ID4+IENoYWlu
IDEwMDAwLTE5OTk5OiBUaGVzZSBhcmUgb2ZmbG9hZGVkIGluIElTMQ0KPj4gPj4gICAgICAgICAg
ICAgICAgICAgICBDaGFpbiAxMDAwMDogTG9va3VwLTAgaW4gSVMxLCBhbmQgaGVyZSB3ZSBjb3Vs
ZCBsaW1pdCB0aGUNCj4+ID4+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGFjdGlv
biB0byBkbyBRb1MgcmVsYXRlZCBzdHVmZiAocHJpb3JpdHkNCj4+ID4+ICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHVwZGF0ZSkNCj4+ID4+ICAgICAgICAgICAgICAgICAgICAgQ2hh
aW4gMTEwMDA6IExvb2t1cC0xIGluIElTMSwgaGVyZSB3ZSBjb3VsZCBkbyBWTEFODQo+PiA+PiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzdHVmZg0KPj4gPj4gICAgICAgICAgICAg
ICAgICAgICBDaGFpbiAxMjAwMDogTG9va3VwLTIgaW4gSVMxLCBoZXJlIHdlIGNvdWxkIGFwcGx5
IHRoZQ0KPj4gPj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIlBBRyIgd2hpY2gg
aXMgZXNzZW50aWFsbHkgYSBHT1RPLg0KPj4gPj4NCj4+ID4+IENoYWluIDIwMDAwLTI5OTk5OiBU
aGVzZSBhcmUgb2ZmbG9hZGVkIGluIElTMg0KPj4gPj4gICAgICAgICAgICAgICAgICAgICBDaGFp
biAyMDAwMC0yMDI1NTogTG9va3VwLTAgaW4gSVMyLCB3aGVyZSBDSEFJTi1JRCAtDQo+PiA+PiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAyMDAwMCBpcyB0aGUgUEFHIHZh
bHVlLg0KPj4gPj4gICAgICAgICAgICAgICAgICAgICBDaGFpbiAyMTAwMC0yMTAwMDogTG9va3Vw
LTEgaW4gSVMyLg0KPj4gPj4NCj4+ID4+IEFsbCB0aGVzZSBjaGFpbnMgc2hvdWxkIGJlIG9wdGlv
bmFsIC0gdXNlcnMgc2hvdWxkIG9ubHkgbmVlZCB0byANCj4+ID4+IGNvbmZpZ3VyZSB0aGUgY2hh
aW5zIHRoZXkgbmVlZC4gVG8gbWFrZSB0aGlzIHdvcmssIHdlIG5lZWQgdG8gDQo+PiA+PiBjb25m
aWd1cmUgYm90aCB0aGUgZGVzaXJlZCBhY3Rpb25zIChjb3VsZCBiZSBwcmlvcml0eSB1cGRhdGUp
IGFuZCB0aGUgZ290byBhY3Rpb24uDQo+PiA+PiBSZW1lbWJlciBpbiBIVywgYWxsIHBhY2tldHMg
Z29lcyB0aHJvdWdoIHRoaXMgcHJvY2Vzcywgd2hpbGUgaW4gU1cgDQo+PiA+PiB0aGV5IG9ubHkg
Zm9sbG93IHRoZSAiZ290byIgcGF0aC4NCj4+ID4+DQoNCkkgYWdyZWUgd2l0aCB0aGlzIGNoYWlu
IGFzc2lnbm1lbnQsIGZvbGxvd2luZyBpcyBhbiBleGFtcGxlIHRvIHNldCBydWxlczoNCg0KMS4g
U2V0IGEgbWF0Y2hhbGwgcnVsZSBmb3IgZWFjaCBjaGFpbiwgdGhlIGxhc3QgY2hhaW4gZG8gbm90
IG5lZWQgZ290byBjaGFpbiBhY3Rpb24uDQojIHRjIGZpbHRlciBhZGQgZGV2IHN3cDAgY2hhaW4g
MCBmbG93ZXIgc2tpcF9zdyBhY3Rpb24gZ290byBjaGFpbiAxMDAwMA0KIyB0YyBmaWx0ZXIgYWRk
IGRldiBzd3AwIGNoYWluIDEwMDAwIGZsb3dlciBza2lwX3N3IGFjdGlvbiBnb3RvIGNoYWluIDIx
MDAwDQpJbiBkcml2ZXIsIHVzZSB0aGVzZSBydWxlcyB0byByZWdpc3RlciB0aGUgY2hhaW4uDQoN
CjIuIFNldCBub3JtYWwgcnVsZXMuDQojIHRjIGZpbHRlciBhZGQgZGV2IHN3cDAgY2hhaW4gMTAw
MDAgcHJvdG9jb2wgODAyLjFRIHBhcmVudCBmZmZmOiBmbG93ZXIgc2tpcF9zdyB2bGFuX2lkIDEg
dmxhbl9wcmlvIDEgYWN0aW9uIHNrYmVkaXQgcHJpb3JpdHkgMSBhY3Rpb24gZ290byBjaGFpbiAy
MTAwMA0KIyB0YyBmaWx0ZXIgYWRkIGRldiBzd3AwIGNoYWluIDIxMDAwIHByb3RvY29sIDgwMi4x
USBwYXJlbnQgZmZmZjogZmxvd2VyIHNraXBfc3cgdmxhbl9pZCAxIHZsYW5fcHJpbyAxIGFjdGlv
biBkcm9wDQoNCkluIGRyaXZlciwgd2UgY2hlY2sgaWYgdGhlIGNoYWluIElEIGhhcyBiZWVuIHJl
Z2lzdGVyZWQsIGFuZCBnb3RvIGNoYWluIGlzIHRoZSBzYW1lIGFzIGZpcnN0IG1hdGNoYWxsIHJ1
bGUsIGlmIGlzIG5vdCwgdGhlbiByZXR1cm4gZXJyb3IuIEVhY2ggcnVsZSBuZWVkIGhhcyBnb3Rv
IGFjdGlvbiBleGNlcHQgbGFzdCBjaGFpbi4NCg0KSSBhbHNvIGhhdmUgY2hlY2sgYWJvdXQgY2hh
aW4gdGVtcGxhdGUsIGl0IGNhbiBub3Qgc2V0IGFuIGFjdGlvbiB0ZW1wbGF0ZSBmb3IgZWFjaCBj
aGFpbiwgc28gSSB0aGluayBpdCdzIG5vIHVzZSBmb3Igb3VyIGNhc2UuIElmIHRoaXMgd2F5IHRv
IHNldCBydWxlcyBpcyBPSywgSSB3aWxsIHVwZGF0ZSB0aGUgcGF0Y2ggdG8gZG8gYXMgdGhpcy4N
Cg0KVGhhbmtzLA0KWGlhb2xpYW5nIFlhbmcNCg0K
