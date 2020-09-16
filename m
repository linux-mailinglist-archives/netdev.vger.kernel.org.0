Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1D3826BA14
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 04:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgIPC05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 22:26:57 -0400
Received: from mail-eopbgr150070.outbound.protection.outlook.com ([40.107.15.70]:15900
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726168AbgIPC04 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 22:26:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lQuniM69w2rTsT89b/fVuYjbWj9BZHh3eTNNtLrMu+U8ySkL1R6E2yuZ9k/s0zSlPBAVN+vr2A+bX4rKynWJrGOtt1/JqVJDJqnxW+gBs8Wd7EF3AmpA8lEtNVcUAtqzQw8ZOasGMvj6eJCzfcm/2qPtYsXs8qVrS+A0jX0PERkEwWBYl4nu/AF+7SDzMbUfwXeePfQr0e9GMHQlxXS34YFkJJTk+huNuTdv0lFH2X0heAxw5z5ZupWLCER4ZGH/xHpRV1+nxYP+cbWX59JIzBCTMnYuAYb05S2m+yc0aljf8ZeyHsak+WiYddz5Hp5MOdkC1CGA4VN9LFfY0WLi+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=26/KY4jUsLDakOpKr8rqZVhr8p1ZDSN7y75CqH/YFVE=;
 b=Q1vd/X4aJ05miLnn6/mvEJyXheu3zubbnR49dEyQO5ZADXCq9NxbqhOYfafzci8cLXSunlD/AdWw7yAcoRC5OAALlsBi2g2l27LjCYng8pXsdss2mW33B79AeUh90/Ggd7Ah3WNcneKDV6Ms6EM59pP/AkZ4H1S4Gtp51lZKkL4eUx6ik5CxBivzzBVS4uSgmJI1s5RwgW3cSkpb9BIXvI3+ssoNghCaRary2sENT538fElZKAJcm8TqZRuH0PyDIj2lfQsUCuXrBVjnmHJa1WVE4BTEhmcEQg8uPjCAIcoH7l/wgPlLHnh20tBnp0mHye7EmmrgzS/NGd111eqoIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=26/KY4jUsLDakOpKr8rqZVhr8p1ZDSN7y75CqH/YFVE=;
 b=awRN/c7hsaafuFourQJ0zhNUvN7lhKqoqUDOHV8eu6tiD7dIiN6LmQfA2/JfA+oev9B4/9G/dttEuViK5YLLcAuVdjbdUYgjbRC+R6TppjYN/itA5ELEbiMtNKviCSUqaTDucDkizKJIVCn4Zabpx955YhaIHMPiI88hE9l2LL4=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR04MB3094.eurprd04.prod.outlook.com (2603:10a6:6:10::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Wed, 16 Sep
 2020 02:26:52 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3391.011; Wed, 16 Sep 2020
 02:26:52 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Michael Walle <michael@walle.cc>
CC:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH linux-can-next/flexcan] can: flexcan: fix TDC feature
Thread-Topic: [PATCH linux-can-next/flexcan] can: flexcan: fix TDC feature
Thread-Index: AQHWE9It45mk5G6f2ES/KFIAprd1aah7fVCAgEnofYCAJE1mgIAABUIAgAaDC4CAAJkbAIB6X1gAgABDQ9A=
Date:   Wed, 16 Sep 2020 02:26:52 +0000
Message-ID: <DB8PR04MB6795D75BE5A285980E75892EE6210@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20200416093126.15242-1-qiangqing.zhang@nxp.com>
 <20200416093126.15242-2-qiangqing.zhang@nxp.com>
 <DB8PR04MB6795F7E28A9964A121A06140E6D80@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <d5579883c7e9ab3489ec08a73c407982@walle.cc>
 <39b5d77bda519c4d836f44a554890bae@walle.cc>
 <e38cf40b-ead3-81de-0be7-18cca5ca1a0c@pengutronix.de>
 <9dc13a697c246a5c7c53bdd89df7d3c7@walle.cc>
 <DB8PR04MB6795751DBB178E1EDF74136FE66F0@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <61489f52-84d5-e800-02f9-e40596e269ef@pengutronix.de>
In-Reply-To: <61489f52-84d5-e800-02f9-e40596e269ef@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b11bbe82-afdd-4157-8a14-08d859e7f90a
x-ms-traffictypediagnostic: DB6PR04MB3094:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR04MB3094E8E745B06397A8C7AC9DE6210@DB6PR04MB3094.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h9Ag28UEPzO5v4iT+8+/rrlp0QUsI2WiPrQhXw470ece60O+NGLaWg8TcbH6eqejFY7CX2l3PPPLhSTccgXGSqy1VzAOv9/0yciX1LqH9BHJmZ4jlpFF4RfvHz9NZ9At2VWxvfDl7qu1IwpXtwqEfHizNnX5igUlVor2mDF8ToWxoSRVZqru+pBuqSi2wfpYgJaSz43HyZVFE1SSonJbPzu4+mgmM5nIVzN+BiJcvm4BwQQqrlT7WTCy//AJ4iT3VOtDJBawwRV+MdyRq1jSmUhJnN1DB8cwis6QLkxahr5Q8LMnduLPv3ZPQL44mhQI+4vY40ezeLBIqUo4Xr0p6ozy3Nk7NbQhR8y2CNYA9f2735P685v31uhD7CDK+zM+ZKUoGvMyVeharx3Nr9CWNw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(39860400002)(396003)(136003)(6506007)(26005)(186003)(55016002)(9686003)(316002)(4326008)(86362001)(478600001)(8936002)(966005)(33656002)(64756008)(8676002)(7696005)(2906002)(110136005)(54906003)(5660300002)(83380400001)(66476007)(66556008)(66446008)(76116006)(52536014)(66946007)(53546011)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: cDcAnZW2eRf6P1DrVg2Xo7JpkatuaC8J7RlURNe56V0ZfD3DNNdR8DHd6t4kM/OwhGLlG/HBTu9GzVWTJKknNVCpETKvUN224OlRbuEF478c4gpSBl46U2Li9mT/5MgtWbzBfk52NjM26w1PHOALueU/3qiQkNUuMgl0YhUEvkLKOfWZT575AuGmdov0bcQHCoKL6KAOre+lOKQa+V5/eRTdMatJVCCF0BqmUnoiR4CBZtJO6SYoXLFvMPvPzmnXvaRyZB+sctKkQh0IlBiUzRBR/N8yI9FoaoStXxEbNP3wPUPC6md5tqvW+CNSYjlLZI/1Ooz2ocsrUcC2E+aKCDJBlfLCzWiX88JAAV46IMxe6SIUNjeVxliQB/Byczkc5uFhGNjXbm4dz0kkQIj/9h3AXPvTh0lFJKM+aTV9urjRX3hhpbiEQ/169G49LWgiQc2AQ4mdGKNRcWSvzdD1kLfUlSefZ0O4sP7U5P6zPspjmB0vdFXGlfGV+dFKg5dpY7unQqoqfpkTAmmcf6Rh5mv5R3AeY+SVgOb16QDHyEbA2MWdDl1EjUmZFInYpNRtmVzIeno8OmG8JH6AvowNWqhM4S7K2n8dg9nr9krjG4aRvZZn7NVhGHf8Lo1FtaF7PtrIV+j3kbzcOx+pfxZ07Q==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b11bbe82-afdd-4157-8a14-08d859e7f90a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2020 02:26:52.2892
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: noes2XyTxGJOYx945XsmBPMSI4sJcBuFkRhcZtAOcV+KjHxRkAxT7sC0Z2Krf+i3NcGeEvU5SOD30brYBSbikA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3094
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMgS2xlaW5lLUJ1ZGRl
IDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMjDlubQ55pyIMTbml6UgNjoxNg0KPiBU
bzogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT47IE1pY2hhZWwgV2FsbGUN
Cj4gPG1pY2hhZWxAd2FsbGUuY2M+DQo+IENjOiBsaW51eC1jYW5Admdlci5rZXJuZWwub3JnOyBk
bC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPjsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9y
Zw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIGxpbnV4LWNhbi1uZXh0L2ZsZXhjYW5dIGNhbjogZmxl
eGNhbjogZml4IFREQyBmZWF0dXJlDQo+IA0KPiBPbiA2LzMwLzIwIDQ6MjUgQU0sIEpvYWtpbSBa
aGFuZyB3cm90ZToNCj4gPiBJIGhhdmUgYWxzbyBub3RpY2VkIHRoaXMgZGlmZmVyZW5jZSwgYWx0
aG91Z2ggdGhpcyBjb3VsZCBub3QgYnJlYWsNCj4gPiBmdW5jdGlvbiwgYnV0IElNTywgdXNpbmcg
cHJpdi0+Y2FuLmN0cmxtb2RlIHNob3VsZCBiZSBiZXR0ZXIuDQo+ID4NClsuLi5dDQoNCj4gPiAy
KSBDbGVhbiB0aW1pbmcgcmVnaXN0ZXIuDQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvY2FuL2ZsZXhj
YW4uYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMNCj4gPiBAQCAtMTE2Nyw2
ICsxMTY3LDE0IEBAIHN0YXRpYyB2b2lkIGZsZXhjYW5fc2V0X2JpdHRpbWluZ19jYnQoY29uc3QN
Cj4gc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCj4gPiAgICAgICAgIHN0cnVjdCBmbGV4Y2FuX3Jl
Z3MgX19pb21lbSAqcmVncyA9IHByaXYtPnJlZ3M7DQo+ID4gICAgICAgICB1MzIgcmVnX2NidCwg
cmVnX2ZkY3RybDsNCj4gPg0KPiA+ICsgICAgICAgcmVnX2NidCA9IHByaXYtPnJlYWQoJnJlZ3Mt
PmNidCk7DQo+ID4gKyAgICAgICByZWdfY2J0ICY9IH4oRkxFWENBTl9DQlRfQlRGIHwNCj4gPiAr
ICAgICAgICAgICAgICAgRklFTERfUFJFUChGTEVYQ0FOX0NCVF9FUFJFU0RJVl9NQVNLLCAweDNm
ZikgfA0KPiA+ICsgICAgICAgICAgICAgICBGSUVMRF9QUkVQKEZMRVhDQU5fQ0JUX0VSSldfTUFT
SywgMHgxZikgfA0KPiA+ICsgICAgICAgICAgICAgICBGSUVMRF9QUkVQKEZMRVhDQU5fQ0JUX0VQ
Uk9QU0VHX01BU0ssIDB4M2YpIHwNCj4gPiArICAgICAgICAgICAgICAgRklFTERfUFJFUChGTEVY
Q0FOX0NCVF9FUFNFRzFfTUFTSywgMHgxZikgfA0KPiA+ICsgICAgICAgICAgICAgICBGSUVMRF9Q
UkVQKEZMRVhDQU5fQ0JUX0VQU0VHMl9NQVNLLCAweDFmKSk7DQo+ID4gKw0KPiANCj4gV2h5IGlz
IHRoaXMgbmVlZGVkPyBUaGUgInJlZ19jYnQgJj0iIHNldHMgcmVnX2NidCBiYXNpY2FsbHkgdG8g
MCwgYXMgdGhlIGZpZWxkcw0KPiBhbmQgdGhlIEJURiBvY2N1cHkgYWxsIDMyYml0Lg0KPiANCj4g
VGhlIG9ubHkgdGhpbmcgdGhhdCdzIGxlZnQgb3ZlciBpcyB0aGUgcmVhZCgpLi4uLg0KDQpZZXMs
IG5lZWQgbm90LCBJIGhhdmUgbm90IG5vdGljZWQgaXQgaGFzIG9jY3VweSB0aGUgd2hvbGUgMzJi
aXQuDQoNClRoZXJlIGlzIGEgc21hbGwgaW1wcm92ZSBwYXRjaCB0byBiYWxhbmNlIHRoZSB1c2Fn
ZV9jb3VudCBpZiByZWdpc3RlciBmbGV4Y2FuZGV2IGZhaWxlZC4gQ291bGQgeW91IHBpY2sgdXAg
aXQgYnkgdGhlIHdheSB0aGlzIHRpbWU/DQpodHRwczovL3d3dy5zcGluaWNzLm5ldC9saXN0cy9s
aW51eC1jYW4vbXNnMDMwNTIuaHRtbA0KDQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0K
