Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75652354A3C
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 03:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238598AbhDFBjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 21:39:24 -0400
Received: from mail-vi1eur05on2072.outbound.protection.outlook.com ([40.107.21.72]:37345
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232367AbhDFBjK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 21:39:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fQaTaagLIYcZKcrWNF8cDf2A3lqonaiuhZPRTmgT1nd3cNchinojMzJ+NgqGlY6sHy7DpCgG+d6w5rMkMgLpfAJM/p/W13vRET4CD+mfLLXMlcr1CWWtCt+iYiOk3NLsW5a1+FRR8dwcdek2F+IY742XhQgQF8i9YxVckTKSvc3pCv4p7Mv2GW4cb15ghQ5RLHnTnyYND/5xxOPq8BL9Nh2kMMDmkerExWI/WWlUyV010G5tXknvP4k99AICLR4U9BC3klTcPZ1RKm7sVZgnmuQo5pg/Se7KT1VAzlMy0fSwMU+yReei6N7c9hoRGRBeqUUl14Xk8ygRXUyYa6xkfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/v3NkhcxQ+PWY8tHNjik5UA3ILLVIfJmLFSGdbeA97Q=;
 b=LPxmc9VF3yUFWI3OES4hVnawNGs51AO0XhnrUUaP6ybOm2/LJK4EG1n8/2G31vaGzkJM7NKEcOGnG9Lq+9LAEb2c6yquAlrD2ZhX2G2lM9ag3AFs0ag9NTgJsCWfzGnzhz0RpZpwpXmSvkVSL7AfMGHn4uXlXAIzhRKrlJ0ZNoXZFvcUjp+MpCZg2hk5rI+6Iu84rYH7zDvw8qL2tptH+UR75zWSKZXsiVnUY1Pd/Ht9JFIiaGx018Grai9/y7tf52rEmtpTaAz5ThwPe7SxslbiElHPbv5JUvPnyAc/JHAZbV9KkZ1Z5xgFgng+M9JNNZZoiugTlZzHpEvBvygtxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/v3NkhcxQ+PWY8tHNjik5UA3ILLVIfJmLFSGdbeA97Q=;
 b=WvPnhc72HpayTQ5NyLfrPTA3+99Y/K8BEBbq62eHXa8yLlMEX6n3usCywWwZb0ZSLHkyJdar8TyQs9fn4BME7UVQhWjqCp/cuREnXrYgUxJwl1NrF0ANMcRKfhFjouDOpzlO83qVhuk2ChF3MN2cHgyKAI2mdPaB9fjBj324zhs=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB5308.eurprd04.prod.outlook.com (2603:10a6:10:1d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Tue, 6 Apr
 2021 01:39:01 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%5]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 01:39:01 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "christian.melki@t2data.com" <christian.melki@t2data.com>
Subject: RE: [PATCH] net: phy: fix PHY possibly unwork after MDIO bus resume
 back
Thread-Topic: [PATCH] net: phy: fix PHY possibly unwork after MDIO bus resume
 back
Thread-Index: AQHXKTprONOHGtpeU0eiVA3RKY2nOaqkZbwAgACRNACAAb0k0A==
Date:   Tue, 6 Apr 2021 01:39:00 +0000
Message-ID: <DB8PR04MB6795EA96DD50305AAF84C9E6E6769@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210404100701.6366-1-qiangqing.zhang@nxp.com>
 <97e486f8-372a-896f-6549-67b8fb34e623@gmail.com>
 <ed600136-2222-a261-bf08-522cc20fc141@gmail.com>
In-Reply-To: <ed600136-2222-a261-bf08-522cc20fc141@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b56f879c-ad71-48fe-dd5e-08d8f89cc11c
x-ms-traffictypediagnostic: DB7PR04MB5308:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB5308301912497C7CFE612BFFE6769@DB7PR04MB5308.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wo97QXfl605KWuyhLRvOcwQhl1bt01NsQpJHcwt+eyeMooaFE4eKcoiZ7xYLQ/831NZDtVheQzoiprHQFrQ8PzMQyr+YTRpNoOMPmGfV8guCSXgTDWf6HBGNyR5dX0MWMmnftmLKvdVVk7h/tzBvJC7a7mQzjtEhPLYG6oodn4HnCw9Oeui3o+7Kz2DhYi6bkQR4TOI0uOe9h40eaRr39LrMtt2Aq2/ly/vmPdJng5KUAWtL460Rr2H5tyh2uIhD072fiMMCJgP7+TpfUUH35WQ+YagI+wy+H3cT2dGpA/PKSVFDS7q4ywUkn++/q34g0nZk+6mruGkLEOp0lZetkPGf5Nwe2z1Ovps/enlPsBRUU2uH3tKDmB1CPJztJHb/5BEQOy/DkZUCqorML5Cpp2S4JI5zKBByiy6u7SDOI93RMRpbPioxQD4SH7h+qcuv7a2OsobxSWC5GIeJZMT2f5qABdir0Y/L3uEiHghKOQ7PoXSeh0zmTCqhtJCs3MZIiNeB6UyepE4cZq3jKmlXPyeFWQSxrwws6o/11SuXCROOPjBo2fi+6WeV/G+9+0SdO5+3Sm4itPf0fcSpF51h8aefCjHoSc5rwKSfWVvYxQr12RaOCXJrowFlSUWvcNMlMjnCbgMzP2s3KEpkKns7Iic94qTJIWq46HPGDkcgiG8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(5660300002)(26005)(2906002)(66446008)(52536014)(76116006)(54906003)(478600001)(64756008)(66556008)(66476007)(53546011)(83380400001)(7696005)(38100700001)(186003)(71200400001)(33656002)(86362001)(55016002)(316002)(110136005)(4326008)(66946007)(6506007)(9686003)(8936002)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?SUVodDZ3Q2lGV3dPWVEzNkpHTzdhNnNQS1lNcGtOdHBhNW5vdUJ4WHhUdE4v?=
 =?utf-8?B?S0VOR3RobTkva1Y1QmtweTV4SS8vcjdSaGZQaTMxT2QvSUYzUFFFVm9WUlpz?=
 =?utf-8?B?OXZZOXVYQ3NnOUEwU29SOHdqWmVDbnJVTTk1V1NZSXBvOWJqWUQzUnNrU2tW?=
 =?utf-8?B?Y2xlaStPSm9HYWVuK2pOSXovTmYvdm9vVml5YU9kaU1CRXk4UXlmZXlKYWRV?=
 =?utf-8?B?b0k4cHRxNTM1citEVzRqL3BEYjFQT2JSZFdHRUlORDBaTmZVT243b2RDdWd0?=
 =?utf-8?B?OWhRL2JoR2psV0s5SGFlNys0S0Nnbm9FZ2l1emZyWjJyUmsyWDBzeVo0NXFp?=
 =?utf-8?B?TGpLUEtqQUdxMWhwRFdCRTRtTEZsZW9KQWpTTmJqSmhHNVRDSTBBTGZOUGpi?=
 =?utf-8?B?R1QzT1Y4dFJJdno4c3RoaU8zQWxESi81eEZqOEpqVWRCZW5VRHBVd1R3aWpr?=
 =?utf-8?B?VUMzTEJpKzFRR2czOFROZTFHcTlNbG1OU2RUTzFvNzNHR2VqdjhkTTRBR1hr?=
 =?utf-8?B?TkF2T29uMFEzK1RUcUNGOVFQeVE5cXdndjRqMVgrSzhEdnQ2bzUrMmV6LzV0?=
 =?utf-8?B?bmIrYjFHYytWcDVjRDFZMzZIRThBRlYycDF0R01uUTRpYVVqVTg2SVNIRzJX?=
 =?utf-8?B?b09SZUduN1Z4VFBJempoWlc5cU9KOFRDRTE3bDA5WFJkdXVTOWtVdlAvdDNn?=
 =?utf-8?B?WWIrNTNjcTZzdTNTeUt0WXJaYWNEdmNxWjRBMUFBaXA3Vkt6OTdYbXZDZGpl?=
 =?utf-8?B?Z0VMcVUwV3pyVlY4WmJvLzJjcTVUZmlXbEdwVWlqVzI2MDdjR2k2elFjMUFi?=
 =?utf-8?B?QnYwOW5ld25KdFlUZ2YzcmFvUWo5TVE1amo3UU5hN0R0bGUrVUVnNE9McTZB?=
 =?utf-8?B?RVZnQ2lEMGRxVUoxeDUwdjdDb0Y4R1BWTlVlTnRxZjkzaVgwclRaOG5KTlZT?=
 =?utf-8?B?UzJxenFFRmpCODlFcXFqTUtPV1ROVUd0VmFnRkpXbXZ5MkdTclRZK25yZklP?=
 =?utf-8?B?WFUwOWZtUFRWajhSK1NhVDZXd0U0SVRTZlMxZFU3YUNjbXAzajc5R0I2OEEz?=
 =?utf-8?B?dERrK2FpTmdEUGU4akJodCs3ZGwwZlVpeXRWa1M0a2NnTXhBYnRnV01aS2o4?=
 =?utf-8?B?R1QxTlVNZGpQUFR2b1RNSXRFeEErYVlLMzRpbm9aVFpVN1o1RVIxSHJML1pJ?=
 =?utf-8?B?NHBzVkFlOFBBd1gvUUsvMURJWU9DanVmMURGLzk2dDAwczBMZlNXenRvS1BJ?=
 =?utf-8?B?eDh5dThhMVNMUXVJanpoczV2THJ5Yno2aHM4K0F2N3NOdDBiUGY4V0h0emh6?=
 =?utf-8?B?SXJGajR2ZDA5RTJROE5sNUdkemMvV0RKallUK2wycTFKZWxFUDVIUFV3Wnc5?=
 =?utf-8?B?eGtZT2dJS0VoMGpkOGdhQWIvN2xMcXV4VFVPTHlQNmc0cEEwSWxQTmxyTUxp?=
 =?utf-8?B?UU1HNzZHSzJ2eGN2VjAxUGRCN1FTSHFuMWROZTN6RVlRSVQycWo3Z0JXckxS?=
 =?utf-8?B?UE52WWlXWG5HbmVJNEJ6TXdQNmJ0YUVRVXpJNVhNSTcweVlER1RlME8zVkJL?=
 =?utf-8?B?c3NpOFNDR1lSdzQ3WENuQkdxYm81NlRPNnRob2ZQWVM2WXlDMyt5c1pDYXRx?=
 =?utf-8?B?Z2VVQ2ptR2l5dlVLOXdwemFveVQrQ3RCUGxDTWg1SmJZaGgrREVVSEwwMEY0?=
 =?utf-8?B?emgxV21Uc3ozc0NWa2hGNDVkU2FVd3JYaTdPUGQ1dk5qWWxkWDJiZEgzQXNR?=
 =?utf-8?Q?BgWZyCBsSQcTt1+nYQfYB+pKYwn8X+aLuaSXkpA?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b56f879c-ad71-48fe-dd5e-08d8f89cc11c
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2021 01:39:01.0131
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j0o15E6VUNwrl+S2Rm1zduhWDWtBZeGy+8rWqPjeMZS9q3wVcSIh+KIHB34QRpGSB6SCJFP8QzsGTp0qWF/IOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5308
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBIZWluZXIsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSGVp
bmVyIEthbGx3ZWl0IDxoa2FsbHdlaXQxQGdtYWlsLmNvbT4NCj4gU2VudDogMjAyMeW5tDTmnIg1
5pelIDY6NDkNCj4gVG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBh
bmRyZXdAbHVubi5jaDsNCj4gbGludXhAYXJtbGludXgub3JnLnVrOyBkYXZlbUBkYXZlbWxvZnQu
bmV0OyBrdWJhQGtlcm5lbC5vcmcNCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4
LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGRsLWxpbnV4LWlteA0KPiA8bGludXgtaW14QG54cC5j
b20+OyBjaHJpc3RpYW4ubWVsa2lAdDJkYXRhLmNvbQ0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBu
ZXQ6IHBoeTogZml4IFBIWSBwb3NzaWJseSB1bndvcmsgYWZ0ZXIgTURJTyBidXMgcmVzdW1lDQo+
IGJhY2sNCj4gDQo+IE9uIDA0LjA0LjIwMjEgMTY6MDksIEhlaW5lciBLYWxsd2VpdCB3cm90ZToN
Cj4gPiBPbiAwNC4wNC4yMDIxIDEyOjA3LCBKb2FraW0gWmhhbmcgd3JvdGU6DQo+ID4+IGNvbW1p
dCA0YzBkMmU5NmJhMDU1ICgibmV0OiBwaHk6IGNvbnNpZGVyIHRoYXQgc3VzcGVuZDJyYW0gbWF5
IGN1dA0KPiA+PiBvZmYgUEhZIHBvd2VyIikgaW52b2tlcyBwaHlfaW5pdF9odygpIHdoZW4gTURJ
TyBidXMgcmVzdW1lLCBpdCB3aWxsDQo+ID4+IHNvZnQgcmVzZXQgUEhZIGlmIFBIWSBkcml2ZXIg
aW1wbGVtZW50cyBzb2Z0X3Jlc2V0IGNhbGxiYWNrLg0KPiA+PiBjb21taXQgNzY0ZDMxY2FjZmU0
ICgibmV0OiBwaHk6IG1pY3JlbDogc2V0IHNvZnRfcmVzZXQgY2FsbGJhY2sgdG8NCj4gPj4gZ2Vu
cGh5X3NvZnRfcmVzZXQgZm9yIEtTWjgwODEiKSBhZGRzIHNvZnRfcmVzZXQgZm9yIEtTWjgwODEu
IEFmdGVyDQo+ID4+IHRoZXNlIHR3byBwYXRjaGVzLCBJIGZvdW5kIGkuTVg2VUwgMTR4MTQgRVZL
IHdoaWNoIGNvbm5lY3RlZCB0bw0KPiA+PiBLU1o4MDgxUk5CIGRvZXNuJ3Qgd29yayBhbnkgbW9y
ZSB3aGVuIHN5c3RlbSByZXN1bWUgYmFjaywgTUFDIGRyaXZlcg0KPiBpcyBmZWNfbWFpbi5jLg0K
PiA+Pg0KPiA+PiBJdCdzIG9idmlvdXMgdGhhdCBpbml0aWFsaXppbmcgUEhZIGhhcmR3YXJlIHdo
ZW4gTURJTyBidXMgcmVzdW1lIGJhY2sNCj4gPj4gd291bGQgaW50cm9kdWNlIHNvbWUgcmVncmVz
c2lvbiB3aGVuIFBIWSBpbXBsZW1lbnRzIHNvZnRfcmVzZXQuIFdoZW4NCj4gPj4gSQ0KPiA+DQo+
ID4gV2h5IGlzIHRoaXMgb2J2aW91cz8gUGxlYXNlIGVsYWJvcmF0ZSBvbiB3aHkgYSBzb2Z0IHJl
c2V0IHNob3VsZCBicmVhaw0KPiA+IHNvbWV0aGluZy4NCj4gPg0KPiA+PiBhbSBkZWJ1Z2dpbmcs
IEkgZm91bmQgUEhZIHdvcmtzIGZpbmUgaWYgTUFDIGRvZXNuJ3Qgc3VwcG9ydA0KPiA+PiBzdXNw
ZW5kL3Jlc3VtZSBvciBwaHlfc3RvcCgpL3BoeV9zdGFydCgpIGRvZXNuJ3QgYmVlbiBjYWxsZWQg
ZHVyaW5nDQo+ID4+IHN1c3BlbmQvcmVzdW1lLiBUaGlzIGxldCBtZSByZWFsaXplLCBQSFkgc3Rh
dGUgbWFjaGluZQ0KPiA+PiBwaHlfc3RhdGVfbWFjaGluZSgpIGNvdWxkIGRvIHNvbWV0aGluZyBi
cmVha3MgdGhlIFBIWS4NCj4gPj4NCj4gPj4gQXMgd2Uga25vd24sIE1BQyByZXN1bWUgZmlyc3Qg
YW5kIHRoZW4gTURJTyBidXMgcmVzdW1lIHdoZW4gc3lzdGVtDQo+ID4+IHJlc3VtZSBiYWNrIGZy
b20gc3VzcGVuZC4gV2hlbiBNQUMgcmVzdW1lLCB1c3VhbGx5IGl0IHdpbGwgaW52b2tlDQo+ID4+
IHBoeV9zdGFydCgpIHdoZXJlIHRvIGNoYW5nZSBQSFkgc3RhdGUgdG8gUEhZX1VQLCB0aGVuIHRy
aWdnZXIgdGhlDQo+ID4+IHN0YXQ+IG1hY2hpbmUgdG8gcnVuIG5vdy4gSW4gcGh5X3N0YXRlX21h
Y2hpbmUoKSwgaXQgd2lsbA0KPiA+PiBzdGFydC9jb25maWcgYXV0by1uZWdvLCB0aGVuIGNoYW5n
ZSBQSFkgc3RhdGUgdG8gUEhZX05PTElOSywgd2hhdCB0bw0KPiA+PiBuZXh0IGlzIHBlcmlvZGlj
YWxseSBjaGVjayBQSFkgbGluayBzdGF0dXMuIFdoZW4gTURJTyBidXMgcmVzdW1lLCBpdA0KPiA+
PiB3aWxsIGluaXRpYWxpemUgUEhZIGhhcmR3YXJlLCBpbmNsdWRpbmcgc29mdF9yZXNldCwgd2hh
dCB3b3VsZA0KPiA+PiBzb2Z0X3Jlc2V0IGFmZmVjdCBzZWVtcyB2YXJpb3VzIGZyb20gZGlmZmVy
ZW50IFBIWXMuIEZvciBLU1o4MDgxUk5CLA0KPiA+PiB3aGVuIGl0IGluIFBIWV9OT0xJTksgc3Rh
dGUgYW5kIHRoZW4gcGVyZm9ybSBhIHNvZnQgcmVzZXQsIGl0IHdpbGwgbmV2ZXINCj4gY29tcGxl
dGUgYXV0by1uZWdvLg0KPiA+DQo+ID4gV2h5PyBUaGF0IHdvdWxkIG5lZWQgdG8gYmUgY2hlY2tl
ZCBpbiBkZXRhaWwuIE1heWJlIGNoaXAgZXJyYXRhDQo+ID4gZG9jdW1lbnRhdGlvbiBwcm92aWRl
cyBhIGhpbnQuDQo+ID4NCj4gDQo+IFRoZSBLU1o4MDgxIHNwZWMgc2F5cyB0aGUgZm9sbG93aW5n
IGFib3V0IGJpdCBCTUNSX1BET1dOOg0KPiANCj4gSWYgc29mdHdhcmUgcmVzZXQgKFJlZ2lzdGVy
IDAuMTUpIGlzDQo+IHVzZWQgdG8gZXhpdCBwb3dlci1kb3duIG1vZGUNCj4gKFJlZ2lzdGVyIDAu
MTEgPSAxKSwgdHdvIHNvZnR3YXJlDQo+IHJlc2V0IHdyaXRlcyAoUmVnaXN0ZXIgMC4xNSA9IDEp
IGFyZQ0KPiByZXF1aXJlZC4gVGhlIGZpcnN0IHdyaXRlIGNsZWFycw0KPiBwb3dlci1kb3duIG1v
ZGU7IHRoZSBzZWNvbmQNCj4gd3JpdGUgcmVzZXRzIHRoZSBjaGlwIGFuZCByZS1sYXRjaGVzDQo+
IHRoZSBwaW4gc3RyYXBwaW5nIHBpbiB2YWx1ZXMuDQo+IA0KPiBNYXliZSB0aGlzIGNhdXNlcyB0
aGUgaXNzdWUgeW91IHNlZSBhbmQgZ2VucGh5X3NvZnRfcmVzZXQoKSBpc24ndCBhcHByb3ByaWF0
ZQ0KPiBmb3IgdGhpcyBQSFkuIFBsZWFzZSByZS10ZXN0IHdpdGggdGhlIEtTWjgwODEgc29mdCBy
ZXNldCBmb2xsb3dpbmcgdGhlIHNwZWMNCj4gY29tbWVudC4NCg0KWWVzLCBJIGFsc28gbm90aWNl
ZCB0aGlzIG5vdGUgaW4gc3BlYywgYW5kIHRyaWVkIHRvIHNvZnQgcmVzZXQgdHdpY2UgZnJvbSBQ
SFkgZHJpdmVyLCBidXQgc3RpbGwgY2FuJ3Qgd29yay4NCg0KV2hhdCBpcyBzdHJhbmdlIGlzIHRo
YXQsIGlmdXAvaWZkb3duIGNhbiB3b3JrIGZpbmUsIHdoaWNoIGlzIGFsbW9zdCB0aGUgc2FtZSBy
b3V0ZSB3aXRoIHN1c3BlbmQvcmVzdW1lLA0KZXhjZXB0IHN1c3BlbmQvcmVzdW1lIGhhcyBzdGF0
ZSBtYWNoaW5lIHJ1bm5pbmcuIA0KDQo+IA0KPiA+Pg0KPiA+PiBUaGlzIHBhdGNoIGNoYW5nZXMg
UEhZIHN0YXRlIHRvIFBIWV9VUCB3aGVuIE1ESU8gYnVzIHJlc3VtZSBiYWNrLCBpdA0KPiA+PiBz
aG91bGQgYmUgcmVhc29uYWJsZSBhZnRlciBQSFkgaGFyZHdhcmUgcmUtaW5pdGlhbGl6ZWQuIEFs
c28gZ2l2ZQ0KPiA+PiBzdGF0ZSBtYWNoaW5lIGEgY2hhbmNlIHRvIHN0YXJ0L2NvbmZpZyBhdXRv
LW5lZ28gYWdhaW4uDQo+ID4+DQo+ID4NCj4gPiBJZiB0aGUgTUFDIGRyaXZlciBjYWxscyBwaHlf
c3RvcCgpIG9uIHN1c3BlbmQsIHRoZW4gcGh5ZGV2LT5zdXNwZW5kZWQNCj4gPiBpcyB0cnVlIGFu
ZCBtZGlvX2J1c19waHlfbWF5X3N1c3BlbmQoKSByZXR1cm5zIGZhbHNlLiBBcyBhIGNvbnNlcXVl
bmNlDQo+ID4gcGh5ZGV2LT5zdXNwZW5kZWRfYnlfbWRpb19idXMgaXMgZmFsc2UgYW5kIG1kaW9f
YnVzX3BoeV9yZXN1bWUoKQ0KPiA+IHNraXBzIHRoZSBQSFkgaHcgaW5pdGlhbGl6YXRpb24uDQo+
ID4gUGxlYXNlIGFsc28gbm90ZSB0aGF0IG1kaW9fYnVzX3BoeV9zdXNwZW5kKCkgY2FsbHMgcGh5
X3N0b3BfbWFjaGluZSgpDQo+ID4gdGhhdCBzZXRzIHRoZSBzdGF0ZSB0byBQSFlfVVAuDQo+ID4N
Cj4gDQo+IEZvcmdvdCB0aGF0IE1ESU8gYnVzIHN1c3BlbmQgaXMgZG9uZSBiZWZvcmUgTUFDIGRy
aXZlciBzdXNwZW5kLg0KPiBUaGVyZWZvcmUgZGlzcmVnYXJkIHRoaXMgcGFydCBmb3Igbm93Lg0K
DQpPSy4NCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQo+ID4gSGF2aW5nIHNhaWQgdGhh
dCB0aGUgY3VycmVudCBhcmd1bWVudGF0aW9uIGlzbid0IGNvbnZpbmNpbmcuIEknbSBub3QNCj4g
PiBhd2FyZSBvZiBzdWNoIGlzc3VlcyBvbiBvdGhlciBzeXN0ZW1zLCB0aGVyZWZvcmUgaXQncyBs
aWtlbHkgdGhhdA0KPiA+IHNvbWV0aGluZyBpcyBzeXN0ZW0tZGVwZW5kZW50Lg0KPiA+DQo+ID4g
UGxlYXNlIGNoZWNrIHRoZSBleGFjdCBjYWxsIHNlcXVlbmNlIG9uIHlvdXIgc3lzdGVtLCBtYXli
ZSBpdCBwcm92aWRlcw0KPiA+IGEgaGludC4NCj4gPg0KPiA+PiBTaWduZWQtb2ZmLWJ5OiBKb2Fr
aW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiA+PiAtLS0NCj4gPj4gIGRyaXZl
cnMvbmV0L3BoeS9waHlfZGV2aWNlLmMgfCA3ICsrKysrKysNCj4gPj4gIDEgZmlsZSBjaGFuZ2Vk
LCA3IGluc2VydGlvbnMoKykNCj4gPj4NCj4gPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3Bo
eS9waHlfZGV2aWNlLmMNCj4gPj4gYi9kcml2ZXJzL25ldC9waHkvcGh5X2RldmljZS5jIGluZGV4
IGNjMzhlMzI2NDA1YS4uMzEyYTZmNjYyNDgxDQo+ID4+IDEwMDY0NA0KPiA+PiAtLS0gYS9kcml2
ZXJzL25ldC9waHkvcGh5X2RldmljZS5jDQo+ID4+ICsrKyBiL2RyaXZlcnMvbmV0L3BoeS9waHlf
ZGV2aWNlLmMNCj4gPj4gQEAgLTMwNiw2ICszMDYsMTMgQEAgc3RhdGljIF9fbWF5YmVfdW51c2Vk
IGludA0KPiBtZGlvX2J1c19waHlfcmVzdW1lKHN0cnVjdCBkZXZpY2UgKmRldikNCj4gPj4gIAly
ZXQgPSBwaHlfcmVzdW1lKHBoeWRldik7DQo+ID4+ICAJaWYgKHJldCA8IDApDQo+ID4+ICAJCXJl
dHVybiByZXQ7DQo+ID4+ICsNCj4gPj4gKwkvKiBQSFkgc3RhdGUgY291bGQgYmUgY2hhbmdlZCB0
byBQSFlfTk9MSU5LIGZyb20gTUFDIGNvbnRyb2xsZXINCj4gcmVzdW1lDQo+ID4+ICsJICogcm91
bnRlIHdpdGggcGh5X3N0YXJ0KCksIGhlcmUgY2hhbmdlIHRvIFBIWV9VUCBhZnRlciByZS1pbml0
aWFsaXppbmcNCj4gPj4gKwkgKiBQSFkgaGFyZHdhcmUsIGxldCBQSFkgc3RhdGUgbWFjaGluZSB0
byBzdGFydC9jb25maWcgYXV0by1uZWdvIGFnYWluLg0KPiA+PiArCSAqLw0KPiA+PiArCXBoeWRl
di0+c3RhdGUgPSBQSFlfVVA7DQo+ID4+ICsNCj4gPj4gIG5vX3Jlc3VtZToNCj4gPj4gIAlpZiAo
cGh5ZGV2LT5hdHRhY2hlZF9kZXYgJiYgcGh5ZGV2LT5hZGp1c3RfbGluaykNCj4gPj4gIAkJcGh5
X3N0YXJ0X21hY2hpbmUocGh5ZGV2KTsNCj4gPj4NCj4gPg0KDQo=
