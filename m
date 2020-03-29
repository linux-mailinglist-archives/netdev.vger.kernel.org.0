Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B55EC196A89
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 03:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgC2BlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 21:41:12 -0400
Received: from mail-eopbgr50062.outbound.protection.outlook.com ([40.107.5.62]:36838
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727733AbgC2BlM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Mar 2020 21:41:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KEMrEbdNe2qwv8QD5ENxGWgT6FLKjlfOmfKCK1G21RsNmTxmGV6aj98OUztyQEoZXrydRSvfPakX7ySieVVErqy+gnZP9kMj8HIspqhaqsmdrOT1oKzF562Q/auytE7H071huTBlXHqnmtFZfK+dCsc+QwxoeDnzZqqJegE5cd/Vyq+IIFAEmW2Is7TbMdriHuY/5gkfAXbmeUxNrbdtmHihpxmcXiBM/28qrLrsGQ8uraMEwDa7369bjEuSXBWjIbW71ymU/fve2w+VK5uSWovfpwSWxp6RCSjbL4h1tKmCjy0/F6ohLTdYxKiGH798wvrtH2VVbwyD6Umi20n7Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jK4ETLV7LtTkUbStcjpSETxD8G6FMhxYqO+kLEQFC8g=;
 b=eIT/QQ2BIEFcv+KWbB66AeZLJ3/kHhkXYrbippHfX9yQhEbfTOzPhcNdK0vfa66B2Jxjry+DLbTZCHNvOXoQ15tRztvDZrPqQMMhbmbc9yOx+hfZQtfJLWB46s5M8P9YXfo96NS4HQhtsy8wVh3mzH/Pr1LqQaJjyr5qaHXzYZlrqWYTrhBbvzCsaQYa6u9fpZ2VsIKK4Gd5dWpgTUHD4yi7V6LzE1bnX/uWej/o1HoRIo0FsYS3TVHGkbj+GfZdqIJj2qG5M6Qduc1K2AidRuu/Yf97lRR60yZz0zLUQvhF6CzJUcCp6MjyKCJO1kAlEm7IX917P0f4Pqqbwh5y6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jK4ETLV7LtTkUbStcjpSETxD8G6FMhxYqO+kLEQFC8g=;
 b=ITfzU0iOc8ZZ0qA7CrWwFL3JWV3XWB8SPBxKT21umpINgF9pB85bF7ksAM8LwwsB2FGIOPRYh1E0vtrubePGI4boL4Rr0MPFFg2+wqFMCg4AkmAth/4aY9sTiA2/hhlwMT1xFI+ojQB9mG4W7r4JN8XjuUL2AZBWpOnp2hpqOKQ=
Received: from DB8PR04MB6426.eurprd04.prod.outlook.com (20.179.249.138) by
 DB8PR04MB6730.eurprd04.prod.outlook.com (20.179.249.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Sun, 29 Mar 2020 01:41:07 +0000
Received: from DB8PR04MB6426.eurprd04.prod.outlook.com
 ([fe80::5130:da14:4c4f:3e2f]) by DB8PR04MB6426.eurprd04.prod.outlook.com
 ([fe80::5130:da14:4c4f:3e2f%5]) with mapi id 15.20.2856.019; Sun, 29 Mar 2020
 01:41:07 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: RE: [EXT] Re: [net-next,v1] net: mscc: ocelot: add action of police
 on vcap_is2
Thread-Topic: [EXT] Re: [net-next,v1] net: mscc: ocelot: add action of police
 on vcap_is2
Thread-Index: AQHWBP4zQ7VVONeLtUqudLfMovlkOaheBakAgAC5o4CAAAo6QA==
Date:   Sun, 29 Mar 2020 01:41:07 +0000
Message-ID: <DB8PR04MB64264BF8BDFA26590409F40EF0CA0@DB8PR04MB6426.eurprd04.prod.outlook.com>
References: <20200328123739.45247-1-xiaoliang.yang_1@nxp.com>
 <CA+h21hpQO=KACy9yKCmOVQenyyoTjLyFD4mX3Cj7PCQnxCB8sA@mail.gmail.com>
 <CA+h21hpBfey-uWrusfDsh7oWocV-sQLBqoYGrhzYuQM8qZdegg@mail.gmail.com>
In-Reply-To: <CA+h21hpBfey-uWrusfDsh7oWocV-sQLBqoYGrhzYuQM8qZdegg@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=xiaoliang.yang_1@nxp.com; 
x-originating-ip: [115.171.229.245]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1b330d6f-b4e6-493a-0d0a-08d7d3824067
x-ms-traffictypediagnostic: DB8PR04MB6730:|DB8PR04MB6730:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB6730478A79B9271B2AA8BE14F0CA0@DB8PR04MB6730.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 035748864E
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6426.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(39850400004)(136003)(396003)(366004)(376002)(7416002)(2906002)(71200400001)(33656002)(8676002)(4326008)(6506007)(53546011)(7696005)(9686003)(81166006)(81156014)(8936002)(55016002)(966005)(52536014)(86362001)(6916009)(316002)(54906003)(5660300002)(478600001)(45080400002)(26005)(66476007)(64756008)(76116006)(66556008)(66446008)(186003)(66946007)(142933001);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q+k7IUUVzpDBtshQ40gZkFoy7lfvriAXgBC1ytoAh6o9YX7hzDkjuCtq+SW3slWOYJ7VjsmbARHoVFxcfKyOUV29yLX7kjoH8LkKytlEONZ2xvEzHU3tXJb2kBV4gO7qjo0pZy19xXeKOLEQ23NceODYwqXAMsQKWpZhfqhk2zOHobSwx4zsgik4kvsfGQ5SdYipDc6iPNriIpVDEHyA9EvIQ0Q7Ruvhcwtket+EZpJP9vPB9fDocsoQ3wWpXkGvOvOguF3mj2koP0A7L6uQb5ZhOFbgwQGjOqP4TUSM7OfuXHHL4SBepeic8K6DcpDXmN7DyZq9y4oYhm9QjCKbWpQ2U48qOF1El9nu2qqtu7DRq4JnZvT7nqZDvSjQv2AQX6lnFzAIlkKmcM3+zUBeP44vpEgocOaixg6TIwfqmXDbrvnK5EdmAv+ne1i8u0c1goB/xSZPtR4IaJ24p97SMK1BgkRm+87cF3ApKhP0jCriv2G8pTHOl9fluEqA7aeFwvtP+78iA6UkBx9qYC734GHARZG/txL9i3Po+NQPMbbqeIWd43Kttj8uMK/JG20XGSKZP7+l9hFc67FqcUB+qg==
x-ms-exchange-antispam-messagedata: /jlz8+35uxpGBRxGOuq1obwHPMaGdYsWGyMgSnxkYUn0ewPlRcJ4J9oSQBo7mEvDXYmcnHi7V3go5DBf7MHDgIOfO/0VNAPrlDs76Qc2BZ6K9Mps7VhzROdjAQoNXtAbaf9ZozxKw+i50EeukK6OVw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b330d6f-b4e6-493a-0d0a-08d7d3824067
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2020 01:41:07.4819
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z1XQkrAmB+QhtDEk1D620sHa1rJXP5KEkkBrSV666lT5jxqcEo4G0reNu1mEG56FeEZu8dgpAxyVHyHDXiz9hPo6aguTNn5f64JUm4AfOb4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6730
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQoNClRoYW5rcywgeW91IGFyZSByaWdodCwgdGhlIHBhdGNoIG5lZWQgdG8g
Y2hhbmdlIHJ1bGUtPnBvbCB0byB0bXAtPnBvbC4gSSBoYXZlIHNlZW4geW91ciBwYXRjaCBzZXJp
ZXMsIGl0J3MgYmV0dGVyIHRvIGFkZCB0aGlzIHBhdGNoIHRvIHlvdXIgcGF0Y2ggc2VyaWVzLg0K
DQpSZWdhcmRzLA0KWGlhb2xpYW5nIFlhbmcNCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0N
CkZyb206IFZsYWRpbWlyIE9sdGVhbiA8b2x0ZWFudkBnbWFpbC5jb20+IA0KU2VudDogMjAyMOW5
tDPmnIgyOeaXpSA4OjU1DQpUbzogWGlhb2xpYW5nIFlhbmcgPHhpYW9saWFuZy55YW5nXzFAbnhw
LmNvbT4NCkNjOiBEYXZpZCBTLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBuZXRkZXYg
PG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+OyBsa21sIDxsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwu
b3JnPjsgSXZhbiBLaG9yb256aHVrIDxpdmFuLmtob3JvbnpodWtAbGluYXJvLm9yZz47IEhvcmF0
aXUgVnVsdHVyIDxob3JhdGl1LnZ1bHR1ckBtaWNyb2NoaXAuY29tPjsgQWxleGFuZHJlIEJlbGxv
bmkgPGFsZXhhbmRyZS5iZWxsb25pQGJvb3RsaW4uY29tPjsgQW5kcmV3IEx1bm4gPGFuZHJld0Bs
dW5uLmNoPjsgQWxsYW4gVy4gTmllbHNlbiA8YWxsYW4ubmllbHNlbkBtaWNyb2NoaXAuY29tPjsg
Vml2aWVuIERpZGVsb3QgPHZpdmllbi5kaWRlbG90QGdtYWlsLmNvbT47IEpvZXJnZW4gQW5kcmVh
c2VuIDxqb2VyZ2VuLmFuZHJlYXNlbkBtaWNyb2NoaXAuY29tPjsgTWljcm9jaGlwIExpbnV4IERy
aXZlciBTdXBwb3J0IDxVTkdMaW51eERyaXZlckBtaWNyb2NoaXAuY29tPjsgWS5iLiBMdSA8eWFu
Z2JvLmx1QG54cC5jb20+OyBBbGV4YW5kcnUgTWFyZ2luZWFuIDxhbGV4YW5kcnUubWFyZ2luZWFu
QG54cC5jb20+OyBQbyBMaXUgPHBvLmxpdUBueHAuY29tPjsgQ2xhdWRpdSBNYW5vaWwgPGNsYXVk
aXUubWFub2lsQG54cC5jb20+OyBWbGFkaW1pciBPbHRlYW4gPHZsYWRpbWlyLm9sdGVhbkBueHAu
Y29tPjsgTGVvIExpIDxsZW95YW5nLmxpQG54cC5jb20+OyBGbG9yaWFuIEZhaW5lbGxpIDxmLmZh
aW5lbGxpQGdtYWlsLmNvbT4NClN1YmplY3Q6IFtFWFRdIFJlOiBbbmV0LW5leHQsdjFdIG5ldDog
bXNjYzogb2NlbG90OiBhZGQgYWN0aW9uIG9mIHBvbGljZSBvbiB2Y2FwX2lzMg0KDQpDYXV0aW9u
OiBFWFQgRW1haWwNCg0KT24gU2F0LCAyOCBNYXIgMjAyMCBhdCAxNTo1MCwgVmxhZGltaXIgT2x0
ZWFuIDxvbHRlYW52QGdtYWlsLmNvbT4gd3JvdGU6DQo+DQo+IEhpIFhpYW9saWFuZywNCj4NCj4g
VGhhbmtzIGZvciB0aGUgcGF0Y2guIEkndmUgdGVzdGVkIGl0LCBidXQgc2FkbHksIGFzLWlzIGl0
IGRvZXNuJ3QgY29tcGlsZS4NCj4gQnV0IHRoZW4gYWdhaW4sIG5ldC1uZXh0IGRvZXNuJ3QgY29t
cGlsZSBlaXRoZXIsIHNvIHRoZXJlLi4uDQo+DQo+IE9uIFNhdCwgMjggTWFyIDIwMjAgYXQgMTQ6
NDEsIFhpYW9saWFuZyBZYW5nIDx4aWFvbGlhbmcueWFuZ18xQG54cC5jb20+IHdyb3RlOg0KPiA+
DQo+ID4gT2NlbG90IGhhcyAzODQgcG9saWNlcnMgdGhhdCBjYW4gYmUgYWxsb2NhdGVkIHRvIGlu
Z3Jlc3MgcG9ydHMsIFFvUyANCj4gPiBjbGFzc2VzIHBlciBwb3J0LCBhbmQgVkNBUCBJUzIgZW50
cmllcy4gb2NlbG90X3BvbGljZS5jIHN1cHBvcnRzIHRvIA0KPiA+IHNldCBwb2xpY2VycyB3aGlj
aCBjYW4gYmUgYWxsb2NhdGVkIHRvIHBvbGljZSBhY3Rpb24gb2YgVkNBUCBJUzIuIFdlIA0KPiA+
IGFsbG9jYXRlIHBvbGljZXJzIGZyb20gbWF4aW11bSBwb2xfaWQsIGFuZCBkZWNyZWFzZSB0aGUg
cG9sX2lkIHdoZW4gDQo+ID4gYWRkIGEgbmV3IHZjYXBfaXMyIGVudHJ5IHdoaWNoIGlzIHBvbGlj
ZSBhY3Rpb24uDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBYaWFvbGlhbmcgWWFuZyA8eGlhb2xp
YW5nLnlhbmdfMUBueHAuY29tPg0KPiA+IC0tLQ0KW3NuaXBdDQo+DQo+IEZvciB3aGF0IGl0J3Mg
d29ydGgsIEkgYW0gcHJlcGFyaW5nIGFub3RoZXIgcGF0Y2ggc2VyaWVzIGZvciBwb3J0IA0KPiBw
b2xpY2VycyBpbiBEU0EsIGFuZCBJJ20ga2VlcGluZyB5b3VyIHBhdGNoIGluIG15IHRyZWUgYW5k
IHJlYmFzaW5nIG9uIA0KPiB0b3Agb2YgaXQuIERlcGVuZGluZyBvbiBob3cgdGhpbmdzIGdvIHdp
dGggcmV2aWV3LCBkbyB5b3UgbWluZCBpZiBJIA0KPiBqdXN0IHRha2UgeW91ciBwYXRjaCB0byBh
ZGRyZXNzIG90aGVyIHJlY2VpdmVkIGZlZWRiYWNrLCBhbmQgcmVwb3N0IA0KPiB5b3VyIGZsb3ct
YmFzZWQgcG9saWNlcnMgdG9nZXRoZXIgd2l0aCBteSBwb3J0LWJhc2VkIHBvbGljZXJzPw0KPg0K
PiBSZWdhcmRzLA0KPiAtVmxhZGltaXINCg0KSSB0b29rIHRoZSBsaWJlcnR5IHRvIHJlcG9zdCB5
b3VyIHBhdGNoIHdpdGggdGhlIGNvbXBpbGF0aW9uIGVycm9yIGZpeGVkLCBhcyBwYXJ0IG9mIHRo
aXMgc2VyaWVzOg0KaHR0cHM6Ly9ldXIwMS5zYWZlbGlua3MucHJvdGVjdGlvbi5vdXRsb29rLmNv
bS8/dXJsPWh0dHBzJTNBJTJGJTJGcGF0Y2h3b3JrLm96bGFicy5vcmclMkZwYXRjaCUyRjEyNjMz
NTglMkYmYW1wO2RhdGE9MDIlN0MwMSU3Q3hpYW9saWFuZy55YW5nXzElNDBueHAuY29tJTdDYjlk
NTZlZTU4ODVkNGViNDFlZjcwOGQ3ZDM3YmNlNmIlN0M2ODZlYTFkM2JjMmI0YzZmYTkyY2Q5OWM1
YzMwMTYzNSU3QzAlN0MwJTdDNjM3MjEwNDAxMDMyMzIxMTcxJmFtcDtzZGF0YT1hWGZ6dGp4QUhn
MEpKd2llWlFTbVNOZTV0WWZ0SnlWWVM1TU15NjZhd1VVJTNEJmFtcDtyZXNlcnZlZD0wDQoNClNv
IHRoaXMgcGF0Y2ggaXMgbm93IHN1cGVyc2VkZWQuDQoNClRoYW5rcywNCi1WbGFkaW1pcg0K
