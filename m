Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7AE7397F59
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 05:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbhFBDQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 23:16:29 -0400
Received: from mail-eopbgr30060.outbound.protection.outlook.com ([40.107.3.60]:14099
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229643AbhFBDQ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 23:16:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rd4gv3E7lJrBtPd0HWQQmdBWvGA2Gnf1NBc+AX2inVm4qOPAzNkD0s1gS9C05vGo8UEEULWKyWNKJ704dO1xy1Q7r3nPxdNHxWh8+eEm1Krg47tvqtwFF6MrWcsgrQiyTAUFFXuv0s3v2LnShduW6yEGvYHhJAT2kH4zCti2xpb4qkLsVrS3DrgEAYppGmwTn3BbfMUl2iGTwAlFY1RoBFt6DcI8l3XJ1RahY+n/kaqEIfx4mNqIOA6Tg2wJTVc6g0NwN+KmfexJCiCiudyRgRzF7CZ9zqcFPLxov+H8pbEo3MNatuuCsUY9ClRPNY+x/hX6XGC/4T/qP4kmg5Y7lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dH1+ksW/8AtLJYxK2yQRe8BQq7Wf8eOs3IocwbX0go4=;
 b=IJQbaY04j1eyZ4M68o50VDWW7w9jjotie5XYiiZb+HKT5fTpautW/WeWLhNKZGZ0xb4pN0bxEYmlTN20Vdtal9qJ3Dg/0+MlUXa+TTWk2S4C7cRYGMuueeZZ94GEFc2caNPYcdedICg5goya+n6k1iNdfnfW7WCFV3WylJXF027Gpda8O5zeEIlrNtq8aXJu/znvKITq0lkl11s5MUIuHcFhRCp3n6oOdF1XfV95cW4I7H3e0z1QM/FaVdSKeecZjAf/G0BJbtkTmhMHLO7JNWHlLBzYNClE03W0IYXkWw4B4BZf0mHLOn+K/pzi+W8gWCwUsOxPU71jyYRQQjXk4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dH1+ksW/8AtLJYxK2yQRe8BQq7Wf8eOs3IocwbX0go4=;
 b=mlPAR2sUp6p+3FUJXaGblyF6At7aK/cjQWwg1oDDwO6h7YMwwpmOeNcPLqvFv/Qo7Kzb7zW0XoeVSlvafhgzjphVPTwsoe4y1eDHkuwT3N/RMzt9Ec/vQ8Gqw45mVdZSMA1VXhL03KMA47AKSPRnI415IsI/b6cqqBW9OQGR+CY=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB9PR04MB8430.eurprd04.prod.outlook.com (2603:10a6:10:24f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 2 Jun
 2021 03:14:43 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 03:14:43 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 1/4] dt-bindings: net: add dt binding for realtek
 rtl82xx phy
Thread-Topic: [PATCH net-next 1/4] dt-bindings: net: add dt binding for
 realtek rtl82xx phy
Thread-Index: AQHXVsUpo3i1yaHMi0ysBGPrSCuJC6sAA3AAgAACraA=
Date:   Wed, 2 Jun 2021 03:14:43 +0000
Message-ID: <DB8PR04MB6795F2A1A48C4587A7F479ABE63D9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210601090408.22025-1-qiangqing.zhang@nxp.com>
 <20210601090408.22025-2-qiangqing.zhang@nxp.com> <YLbvWKIE3FOhdzsl@lunn.ch>
In-Reply-To: <YLbvWKIE3FOhdzsl@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 758bc707-2cb3-494e-93bf-08d925749198
x-ms-traffictypediagnostic: DB9PR04MB8430:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB9PR04MB8430F6A3614FEE5C05B7C9C7E63D9@DB9PR04MB8430.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GR83o0vTJLnJLbZE0uhje5Mpn4xQs2vFjC97LqmsXZjpOybpEjUgCzk5eqIUSKswOeRxPV1CLRmgcKZTmsC+uYg9RcdA9weDQ9yIEzDt+G5af5EunDf/ckFRQVKTBPGctDIeNahl9zvtVVtbvbEEiyKPlKW6GFWwiR/CA3fix09V9/8JonBtTpYLy15G4bG6M2xNSi9Lk8Cvpo1r5Q1syJy97U1UGafUJpaebjs3w5XeotdrMMQ2zDFC0iPFVn8SViVFRA0axiok2rVMiKkBbf3HPneUJrXo5wZ46116NNRLV2LnYX4wx4gufrGb+v6YqYw3Ox9GlpArezV0SwNTJ1xbX0F3lZ5X0sX5R61Cq9O82WWcKM0h0vyS/PUFMzqpbHv6tzkKgAbsK762AHw9jxHYT8fGgi2as7u5fy/QqbjlVnoSEfC2NM8xuAnFHPwAkS7+Ya1Eajw4R0o+dtdC3gDgvQTpEtbBcFQjgz1PfPlv4gWsvu4mjachVmkj2ZHTSKKZjY4D1VF36kialXG1YTI4cRfyrGOLLpfgveb6NdpJ/vLLhFjQKdYWi/G6UnmwIZNRB3vxdFfztg3RILm47qxpB1TkqQtI/hMra7wJJb8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(366004)(396003)(346002)(86362001)(55016002)(76116006)(8936002)(6506007)(52536014)(66476007)(66556008)(66446008)(4326008)(54906003)(64756008)(2906002)(316002)(186003)(33656002)(53546011)(478600001)(26005)(83380400001)(6916009)(71200400001)(38100700002)(122000001)(7696005)(7416002)(5660300002)(9686003)(8676002)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?Um8xcTRTcW9HZEhKL3pXNndJZ2tFVjUrZTZPSDBFV2MrdEJkblN4WnlraUg1?=
 =?gb2312?B?dktxWnZLUGdMZ2dYa3dScXpqN0pxTTBmZDVWY1p4akcxSWdyZ0c1cjE1Nlhu?=
 =?gb2312?B?VXdDSTYyd1lvRm9VT3huM1RuSnRQNE9HSDA2Tml4RVpJaUZXeTZUdk55TVRh?=
 =?gb2312?B?TGlLSkg3RFZZOXBDMDJQTjAySHJsQkVQVnhtNWUwQVp0czZhaWJKQzVkVitz?=
 =?gb2312?B?OGMyNVVUSkE3elliOWdvdng4MVQwTVNJUjRkY050bXZiVStFMFJBeFZ6akNN?=
 =?gb2312?B?YVd3Zm45VFQvVm8zVFFHQ043Z0Z2a3dSeVc2cStVblp0bnM1WG5YclpDNUFP?=
 =?gb2312?B?elZYOXNaeXQvcUZXOXRhb200WDM2RGFtSFViM3NnWVV5R2NTbXNRN3dFbTVa?=
 =?gb2312?B?bkVxS1p0bHB5RmdMM3ZXdk9sWFduK0hqSFg0bDI2Kzhnbi91YlltV3BMQ05T?=
 =?gb2312?B?Wmd5alY4WHVoSmdORHZRTm0xODkyeWM0SjI0Tm1DQXJydnFIOFZrd1dOVkI2?=
 =?gb2312?B?V0FsaC94dTZjVzZiQUkvSjZRQnJHRzNOS3N3NTZXam9sOTQrNkEyK2JzdnlV?=
 =?gb2312?B?RUw0aS92Q2dXbmNWcjh0Z2I1bmg3Tnpzdzg0ZWZ4VGMyZGNnbndlNDc4TG5Z?=
 =?gb2312?B?R0hmcUNYV3NwTDhNczRHbFhoYkhkMzM4ZFc1dnFQUW9lcW1wWlRCVElzdHFw?=
 =?gb2312?B?WmxsTDRDYnFrMnJEYWlvOWZTSXdJOUR2TUM3MFZFNHpxUUFMTEthbkdjYytn?=
 =?gb2312?B?UFBPTEYyYVlCTmtNRG1lMGFOU0VEblUxVnJRUXc2WFF6TDE4YzREVTRLS1ZZ?=
 =?gb2312?B?bUpETHAvMk1iVXpyOW0rS3krQUNCQUFuak5UNFIwZjlhbzduVzVBbWx5Mzlr?=
 =?gb2312?B?UXhMVEJ6NzBaM0FWOU5DazRDTGFsbzVTcDZxMWNMZDhVYkorUXZON2tUMnNH?=
 =?gb2312?B?MmUxaEYvdksvelNrUTh1cUNyK1ZHcG5GM2hyNW5DMGtVRjVhOTdUUEVyWFJG?=
 =?gb2312?B?T3pXdnFnVDI5aWN3S2tuS1ROcEhDbDVaRlpOMmpCUDBoQ2ppaGowa1pSRlRC?=
 =?gb2312?B?WUhKTkQyYlpiQndTcTM0S3g3WUtacnlBWlRJdzg1Y2x2OEpVNlhiV3BDYXZS?=
 =?gb2312?B?NG9SVkhWcmREYTc2Q1d2QkE2MHpEaTZiV01wU1FLWEw0K2tWYUhLTXpzYWZ3?=
 =?gb2312?B?b0dXYXlYOW5iMisxOE94RDM3WUtZQzVoeDVOVTE3cnVsMVVFMi9VbENseUhu?=
 =?gb2312?B?aGxLSlVyOGt6T0NndXRXNW4wWGFVWFVmOEFWcHB0RzFZN0xKZkFwSmlNUE1w?=
 =?gb2312?B?SXptYS9pdi83NEFObDhtV1BGblRoY0ZueU5HYWtxMDdFS3FGdjJZdnJldWxF?=
 =?gb2312?B?VitrMk9pOHhvRDZuOCtIbngvS3V6WDU4SzFJaWJxN25nY1l3dnYwUTNHbmtK?=
 =?gb2312?B?eUllZEVRbWtsRzcxcGRJZGJNS0ZXNEZiNVp1dGxsNEkwUklMamVBTENoVCtG?=
 =?gb2312?B?c0p4SXlIQytucjRMQmc4anE5R2RBS09sNWFwT29WQnpKbmRBUHhTSUtLN2RF?=
 =?gb2312?B?OEVNK21QaXIvTE9hY0RMQ1hSVnh2WWU5UFhJNzJHamxlQTlYeTY2akw4NEFX?=
 =?gb2312?B?dmhWTUdRNFlJeHF1K1lZRlNVQVRQbDdpaXpIOGNiQ1RoZmgwdEN1emdPZXYw?=
 =?gb2312?B?eWpkUUh1NkF6RldXTkFocXBNbGdXTWtML1NuN0tCLzQzR1ZwQXQ0RGc2bndq?=
 =?gb2312?Q?yLuGn4q/rKyn7Hi3LZu4peWqRXE4q1n03QUxjyX?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 758bc707-2cb3-494e-93bf-08d925749198
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2021 03:14:43.8138
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CPVsrtPNRgiCI0erXfbExS9g35Ez2C5QK8/09sUH4JcniR82LP75jiYb06cLgPp5/uCnOzy+bsF9Mlo5yz/aag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8430
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBBbmRyZXcsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQW5k
cmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPg0KPiBTZW50OiAyMDIxxOo21MIyyNUgMTA6MzkNCj4g
VG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+DQo+IENjOiBkYXZlbUBk
YXZlbWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmc7IHJvYmgrZHRAa2VybmVsLm9yZzsNCj4gaGth
bGx3ZWl0MUBnbWFpbC5jb207IGxpbnV4QGFybWxpbnV4Lm9yZy51azsgZi5mYWluZWxsaUBnbWFp
bC5jb207DQo+IGRsLWxpbnV4LWlteCA8bGludXgtaW14QG54cC5jb20+OyBuZXRkZXZAdmdlci5r
ZXJuZWwub3JnOw0KPiBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZn
ZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IDEvNF0gZHQtYmlu
ZGluZ3M6IG5ldDogYWRkIGR0IGJpbmRpbmcgZm9yIHJlYWx0ZWsNCj4gcnRsODJ4eCBwaHkNCj4g
DQo+ID4gK3Byb3BlcnRpZXM6DQo+ID4gKyAgcnRsODIxeCxjbGtvdXQtZGlzYWJsZToNCj4gPiAr
ICAgIGRlc2NyaXB0aW9uOiBEaXNhYmxlIENMS09VVCBjbG9jay4NCj4gPiArICAgIHR5cGU6IGJv
b2xlYW4NCj4gPiArDQo+ID4gKyAgcnRsODIxeCxhbGRwcy1kaXNhYmxlOg0KPiA+ICsgICAgZGVz
Y3JpcHRpb246IERpc2FibGUgQUxEUFMgbW9kZS4NCj4gPiArICAgIHR5cGU6IGJvb2xlYW4NCj4g
DQo+IEkgdGhpbmsgbW9zdCBvZiB0aGUgcHJvYmxlbXMgYXJlIHRoZSBhbWJpZ3VpdHkgaW4gdGhl
IGJpbmRpbmcuDQo+IA0KPiBJZiBydGw4MjF4LGNsa291dC1kaXNhYmxlIGlzIG5vdCBwcmVzZW50
LCBzaG91bGQgaXQgZW5hYmxlIHRoZSBDTEtPVVQ/DQo+IFRoYXQgbmVlZHMgY2xlYXIgZGVmaW5l
IGhlcmUuDQpObywgZG9uJ3QgbmVlZCB0bywgQ0xLT1VUIGNsb2NrIGRlZmF1bHQgaXMgZW5hYmxl
ZCBhZnRlciBQSFkgaGFyZHdhcmUgcmVzZXQuIEFkZCB0aGlzIHByb3BlcnR5IGZvciB1c2Vycw0K
cmVxdWVzdCB0byBkaXNhYmxlIHRoaXMgY2xvY2sgb3V0cHV0LiBJIHdpbGwgaW1wcm92ZSB0aGUg
ZGVzY3JpcHRpb24uDQoNCj4gRG8gd2UgYWN0dWFsbHkgd2FudCBhIHRyaXN0YXRlIGhlcmU/DQo+
IA0KPiAgICAgICAgICAgICAgICAgcnRsODIxeCxjbGtvdXQgPSA8dHJ1ZT47DQo+IA0KPiBtZWFu
cyBlbnN1cmUgdGhlIGNsb2NrIGlzIG91dHB1dHRpbmcuDQo+IA0KPiAgICAgICAgICAgICAgICAg
cnRsODIxeCxjbGtvdXQgPSA8ZmFsc2U+Ow0KPiANCj4gbWVhbnMgZW5zdXJlIHRoZSBjbG9jayBp
cyBub3Qgb3V0cHV0dGluZy4NCkkgdGhpbmsgaXQncyB1bm5lY2Vzc2FyeS4gQSBib29sZWFuIHR5
cGUgaGVyZSBpcyBlbm91Z2guDQoNCj4gQW5kIGlmIHRoZSBwcm9wZXJ0eSBpcyBub3QgaW4gRFQg
YXQgYWxsLCBsZWF2ZSB0aGUgaGFyZHdhcmUgYWxvbmUsIGF0IGVpdGhlciBpdHMNCj4gZGVmYXVs
dCB2YWx1ZSwgb3Igd2hhdGV2ZXIgY2FtZSBiZWZvcmUgaGFzIHNldCBpdCB0bz8NClNlZW1zIG5v
dC4NCjEuIElmIGVuYWJsZSBDTEtPVVQgaW4gYm9vdCBsb2FkZXIgb3Iga2VlcCB0aGUgaGFyZHdh
cmUgZGVmYXVsdCB2YWx1ZSAoQ0xLT1VUIGVuYWJsZWQpLCBEVCB3b3VsZCB3b3JrIHdpdGggdGhp
cyBwYXRjaC4NCjIuIElmIGRpc2FibGUgQ0xLT1VUIGluIGJvb3QgbG9hZGVyLCB3aXRoIHRoaXMg
cGF0Y2gsIGRyaXZlciB3b3VsZCBlbmFibGUgdGhpcyBjbG9jayBpZiB0aGlzIHByb3BlcnR5IGlz
IG5vdCBpbiBEVC4NCg0KU28sIEkgbmVlZCBmaXJzdCByZWFkIFBIWUNSMiByZWdpc3RlciwgaWYg
RFQgaGFzIHByb3BlcnR5IHRoZW4gZGlzYWJsZSB0aGUgY2xvY2ssIGlmIG5vdCwga2VlcCB0aGUg
b3JpZ2luYWwgdmFsdWU/DQoNCkhvd2V2ZXIsIGZvciBBTERQUyBtb2RlLCB0aGUgaGFyZHdhcmUg
ZGVmYXVsdCB2YWx1ZSBpcyBkaXNhYmxlZC4gVGhlIGRyaXZlciBlbmFibGUgQUxEUFMgYnkgZGVm
YXVsdCB3aGljaCBjYXVzZWQgaXNzdWUgYXQgbXkgc2lkZS4gU28gbmVlZCBhIHByb3BlcnR5IHRv
IGRpc2FibGUgaXQuIA0KDQpXZSBoYWQgYmV0dGVyIGFkZCBhIHByb3BlcnR5IGxpa2UgIiBydGw4
MjF4LGFsZHBzLWVuYWJsZSIsIGJ1dCBJdCBzZWVtcyBicmVhayB0aGUgZXhpc3RpbmcgYmVoYXZp
b3IuDQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0KPiAgICAgQW5kcmV3DQo=
