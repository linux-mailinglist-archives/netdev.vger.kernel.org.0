Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6873ED7F3
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 15:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236682AbhHPNu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 09:50:26 -0400
Received: from mail-eopbgr80099.outbound.protection.outlook.com ([40.107.8.99]:57854
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236595AbhHPNtl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 09:49:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J8RvMx8kKqb/MV171rES7fBOwSOUoKvZuPbW9fmsOVP8ggs/hBJYevGZL5llt6l7DrUcFBtNUMXX9T1ogGB54JeeofMCwkhcLN4P7YqJG15EA2ekufo6Zr2s1YyNjDeuoqT7RBnevhLjHTiOuUcxcZGHtHrbcN1/07qHaKewZ/DkBhzlHplcxn6AD0r59hxPbsugWjPLQ1Rf00Bg+hntJBOXSUKTXsHgbQ6l5VW3sG3Mc+KIvHMIdNAVTT5oWoEUBUbUx07qjCfxc8LbGbyTDbRoC9Xer8JYxZ6LeaFpZGgICyulLzn0JbWN5mWhBqb0aU+zokgOpfOw9+F9uCQPkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KK1MA4ZCl6Q//ETnEN4yQ+RVfqL7hGwGtgndtGHBKVE=;
 b=ehZtWeQ7naBI/+IVhIfoii9LZCunlUE8rzYmFH80B7yr5fEi2i2D6H6xKAASQ4OggN34v1PqtS36E+DEQifVCBaKq//8GYYG5ohqbry+2XWzY7073vG0cyVYJbyXOx1BvDH8zbeAFk0nT6+vwXkN6OSPKFgZmkdPHlBYYThEGx0GNI2RDbA+Vs8++anTDZow2r76dwNMeUO+GC5N1jL/HWC+13ld4BV1NN5/miDcZ7SUgrkD89ZIuxL9IfK4SfVaAflZjGYs6eguNwciY3fJdwqNsvAMAeFkR+DfBn0amsCpbPtisdgXHNdhmiWhn9QF+q9slY+ucSGujSnpKZIefQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=esd.eu; dmarc=pass action=none header.from=esd.eu; dkim=pass
 header.d=esd.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KK1MA4ZCl6Q//ETnEN4yQ+RVfqL7hGwGtgndtGHBKVE=;
 b=IIul7rSTqaRdq7tUU/Pzn1yLQDvOZ/uvR+xylUnfbGn1AcHU5iQIHw+6M/9jZnJGyZKvk33780TlsyCYoJCUmJUy+aJ80buoRaQpuia2Xbgmb4/IDjDrKKVHr/FAGJQr6YUe45kQNrirBq3YEa94S1SPa9uxJqATKDNN3MFAChw=
Received: from AM9PR03MB6929.eurprd03.prod.outlook.com (2603:10a6:20b:287::7)
 by AM0PR03MB5987.eurprd03.prod.outlook.com (2603:10a6:208:155::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Mon, 16 Aug
 2021 13:49:07 +0000
Received: from AM9PR03MB6929.eurprd03.prod.outlook.com
 ([fe80::1846:f0d4:5710:e65d]) by AM9PR03MB6929.eurprd03.prod.outlook.com
 ([fe80::1846:f0d4:5710:e65d%5]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 13:49:07 +0000
From:   =?utf-8?B?U3RlZmFuIE3DpHRqZQ==?= <Stefan.Maetje@esd.eu>
To:     "mailhol.vincent@wanadoo.fr" <mailhol.vincent@wanadoo.fr>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
Subject: Re: [PATCH v5 2/7] can: bittiming: allow TDC{V,O} to be zero and add
 can_tdc_const::tdc{v,o,f}_min
Thread-Topic: [PATCH v5 2/7] can: bittiming: allow TDC{V,O} to be zero and add
 can_tdc_const::tdc{v,o,f}_min
Thread-Index: AQHXkYZg3Z5wznDA1k6aOerIr/sDHat10kWAgAAciYCAACGygIAAF2kA
Date:   Mon, 16 Aug 2021 13:49:06 +0000
Message-ID: <79691916e4280970f583a54cd5010ece025a1c53.camel@esd.eu>
References: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
         <20210815033248.98111-3-mailhol.vincent@wanadoo.fr>
         <20210816084235.fr7fzau2ce7zl4d4@pengutronix.de>
         <CAMZ6RqK5t62UppiMe9k5jG8EYvnSbFW3doydhCvp72W_X2rXAw@mail.gmail.com>
         <20210816122519.mme272z6tqrkyc6x@pengutronix.de>
In-Reply-To: <20210816122519.mme272z6tqrkyc6x@pengutronix.de>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: wanadoo.fr; dkim=none (message not signed)
 header.d=none;wanadoo.fr; dmarc=none action=none header.from=esd.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2f55f67-9795-40ac-052f-08d960bc9e01
x-ms-traffictypediagnostic: AM0PR03MB5987:
x-microsoft-antispam-prvs: <AM0PR03MB5987C39D2E05D6C628F6759781FD9@AM0PR03MB5987.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ImC6R62sAo+6oLSm3q1i+Gwk+eSbZlSODGxmrZ73l6NLLF/Sa+LBVqATCUrVKZh3FZAZe1kBaEAKHaFNMGbcp2m4iyJZuNiTm+Dm+hZM9IkUbQudHWGrnTjiEu5aoTYmhnT1Zsen7DmE4uUTs2lyHRi9JeKmvAUswC9cRv8JdlnMJlLLAHoM/wYd+6K9F8YOkQ9JevYn9L3zvEFHyLeI/5t2wYouda0yPXfjXoKIC2PcHU8u170jovBcahMiGF+d3wpoGPeMSE/Rw/LCqd6W3mSJq/CT1JgpjloMUhPLEk7w+ZhuIGUkncpm9IG66oogqwzZbZcd8/z0zHUdiliiLKm/hdjT20SI2yvS7IJvD8o9GVznIsbM1CphPz2Q+KOSibId6/Yn/3q25+edLR36AMnoqI9Jwd1N0HxQMbn7LDi5BJxivG3UbTtgXbLZZHMi/UZ2n79pwJuQHPo9lrhLX/QCoZePEJlSv1EAEm2SS+olRaivpg6Xq9X/wG9SQactIr0LJMh3FGLOelkoW4jW/1FIWEgKQFgA+f6VbjiFeoQtmtssa6A/ATXYvz371gUKK3BecX861hiTbcyZ0sHHEosqLDjUBWYF+pbEwnc8k4v2EGjtpprudDz49mFY1EFj5l3rVhmgs/BgL7xQVstH7BAumn0wV02JydCX+zNKGHzoJKpN6kpMCG60BFaNIJ4Cij4pmn42Vd9QKpPLpo+qZosHJqKCSItGJSXdupx2FARSI3tMPvNRV1Qsj4S0ZU5CV8N8SY8gCBGR41EDhJs9yYgCHjWrb4Y5ZvuBbCcvGkUBvkl60M2xJuLTie4/uTow
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR03MB6929.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(39830400003)(366004)(136003)(6506007)(86362001)(6512007)(966005)(53546011)(54906003)(26005)(110136005)(2906002)(6486002)(5660300002)(66446008)(64756008)(66556008)(66476007)(2616005)(66946007)(316002)(478600001)(71200400001)(186003)(36756003)(38100700002)(4326008)(76116006)(122000001)(83380400001)(85182001)(8936002)(85202003)(38070700005)(8676002)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aVo1R3oxVW5oUHljUUphbVYreFMya0VZUnR5SjNvd3NWa0ttc1I1OXFtTGV2?=
 =?utf-8?B?OW5PS3lWb0VKWVRGa21LY2FYV3BTRzNrSzNMR0g4WG9wRGc2cnRCMjE2bWFX?=
 =?utf-8?B?Ymt6SmdhbUVhZnRHdi81UVZVdkV4SlM2UWhGOWN2Q0pxV3djNC9zMmNjNVky?=
 =?utf-8?B?VlhqSFpKN2pJSU1MTkNyNGNVVktYZXZqaCtiWElWWnExNktiTnBKNGlQQWoz?=
 =?utf-8?B?T2hKdjI5bmxIZ1ZuRmlhdWVsYngyUGV3L0hIcGNQalhEenJvU1BqNUtaLytm?=
 =?utf-8?B?eEFlVFNzWTZ2T2lySjJ6cVRib09oaEZIM004L1BOYklzVmRLTE5xbVVscFhu?=
 =?utf-8?B?KzU3QnQwTnJXRjVFVzltM1hRdmNrcU1qSUlyRWwwa2JMcG1WMFJQRUxkU1B5?=
 =?utf-8?B?UkNWZ2orQ3Viczl1UjBkbm1keXoxWFFibktOd1pGTStZcFo0OHVCMDJuT2hm?=
 =?utf-8?B?SEtMNGtmOG9jeGw3bVg2akRiam9MLzBQcStrUmhTSGc5NEpVcUZFZllZRVB1?=
 =?utf-8?B?clhOT3JKWkM5U2dpWEtBd1I2V2ZDaTZpRy9oNGE4QWVSY2xmTFFSWndpa2lY?=
 =?utf-8?B?K3lSVGtVTUtpMFl4ZDFRZE1QNFhmVngzV2svamFQKzlsVHFETUI1RG5EVDht?=
 =?utf-8?B?NU00am1ZTndqSTlrODRaeWRaQldVMGtJekRNQ1dZVDJJWkdDeFM3c1kweHFV?=
 =?utf-8?B?YlBtcSs5dEdZV3dpZG9SV3JKZTRNYzE5aFF5YkFoQzhoQ1YxU28wWXN4WCtp?=
 =?utf-8?B?S1VkdnFBdTJHUWt1UlJxMUk1MXRBR0FwOVIvR1dLVDdQV3F2WkJEM1doZnNs?=
 =?utf-8?B?cW0zeDJITU8xd2pUQ1plKzRYMXJ1cUlwcEFUeEgrZ1JEekZqeUhFUGdHRlZu?=
 =?utf-8?B?WWh6U3F5VXA2Y0h1VkE2SmlHZmdyS3UyMDJ4MW16THZ5VUpZNkkxdno1QlZw?=
 =?utf-8?B?WWxTZisxN3dFUGlYdmliSVl1cUltRE43NkV5M21selk3Z0dTV1pxL2haWmJF?=
 =?utf-8?B?ekl5TmNJOFpMTXpGTEJ1MUNZTWIvMlV6RTMzS2twK0h0M0NpdFp4N3RLUGdH?=
 =?utf-8?B?UnJNK0x6OGNhMVYvMmIzQmZxRnJKNmhnWHM5UU5hc1crRHVjeDA2emVYQVBP?=
 =?utf-8?B?cGVQWTZ4NUg5REhtOElvdTdFTFZlSkIyYmpUYTdHelVyU1JqbkFuL0gzVkI3?=
 =?utf-8?B?UEhnWGtidUZRdkp2L3l3WHRpNFFDTjhlYVFpSGJOczZhUTY0RDEwNEQxS0xN?=
 =?utf-8?B?bWZzU1duWXA2bHkzWjFCMjMzWUh6U0YvVndFZi9pZlFqNFRCTnpCRFZ2N3dO?=
 =?utf-8?B?Z282ZEdBd0UrYmxmVVBTTzhnV0dUd1FGaXc1NXFmcmlGSHl0dmFrcEZsaXd0?=
 =?utf-8?B?NDQ5VGNSSGlaZFdFQ084ZHRWRitJaHk1TDVaTEdzaXg1N1F4bFVPOEdtcDZ3?=
 =?utf-8?B?d1V3TEQ1WHl4VC9NcDNUZ1dlTTVNMTl6ZDQwUm9vUjliRjFpNXlHRkcwclBj?=
 =?utf-8?B?K0RYcU5mbXJTNlpsclVRa0FYbGRPbFJjUHFkZnVwdEZFczBUNkx4c0w1d08r?=
 =?utf-8?B?R2xnM2puY1ZCQmtjd1B5ckNYSFJIQ2NRZDNmQVQ4dXErcHJYOVdFYUZoN0E0?=
 =?utf-8?B?OUdoa1R0UG02U2tHWDNYVjdzR0htdVZkMEsyVGxOK1A4UytKOHpvN0Y2VlJM?=
 =?utf-8?B?MURSWDByT1ViZlAxZC9MdWUxTGpBcHhQOUs5d1pWR05WUUFKN0V4N0FSTXgw?=
 =?utf-8?Q?c9l7k/A8gQvVfZG8sPeVBoN3vQ7+2ddgIpQIIXO?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <03F2346D685D9D4BAFD6C101039EED73@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR03MB6929.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2f55f67-9795-40ac-052f-08d960bc9e01
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2021 13:49:06.9814
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: suK4SGSWKv8D3SmP3jHHGOvzhWUJewFT7ya07YbKwblQ28SKnfYT1gDpDepLGP70xkJ0SXpbxktY3oEodlqh2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR03MB5987
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmluY2VudCwNCg0KSSB3b3VsZCBsaWtlIHRvIGFkZCBzb21lIGNvbW1lbnRzIGJlbG93Og0K
DQpBbSBNb250YWcsIGRlbiAxNi4wOC4yMDIxLCAxNDoyNSArMDIwMCBzY2hyaWViIE1hcmMgS2xl
aW5lLUJ1ZGRlOg0KPiBPbiAxNi4wOC4yMDIxIDE5OjI0OjQzLCBWaW5jZW50IE1BSUxIT0wgd3Jv
dGU6DQo+ID4gT24gTW9uLiAxNiBBdWcgMjAyMSBhdCAxNzo0MiwgTWFyYyBLbGVpbmUtQnVkZGUg
PG1rbEBwZW5ndXRyb25peC5kZT4gd3JvdGU6DQo+ID4gPiBPbiAxNS4wOC4yMDIxIDEyOjMyOjQz
LCBWaW5jZW50IE1haWxob2wgd3JvdGU6DQo+ID4gPiA+IElTTyAxMTg5OC0xIHNwZWNpZmllcyBp
biBzZWN0aW9uIDExLjMuMyAiVHJhbnNtaXR0ZXIgZGVsYXkNCj4gPiA+ID4gY29tcGVuc2F0aW9u
IiB0aGF0ICJ0aGUgY29uZmlndXJhdGlvbiByYW5nZSBmb3IgW3RoZV0gU1NQIHBvc2l0aW9uDQo+
ID4gPiA+IHNoYWxsIGJlIGF0IGxlYXN0IDAgdG8gNjMgbWluaW11bSB0aW1lIHF1YW50YS4iDQo+
ID4gPiA+IA0KPiA+ID4gPiBCZWNhdXNlIFNTUCA9IFREQ1YgKyBURENPLCBpdCBtZWFucyB0aGF0
IHdlIHNob3VsZCBhbGxvdyBib3RoIFREQ1YgYW5kDQo+ID4gPiA+IFREQ08gdG8gaG9sZCB6ZXJv
IHZhbHVlIGluIG9yZGVyIHRvIGhvbm9yIFNTUCdzIG1pbmltdW0gcG9zc2libGUNCj4gPiA+ID4g
dmFsdWUuDQo+ID4gPiA+IA0KPiA+ID4gPiBIb3dldmVyLCBjdXJyZW50IGltcGxlbWVudGF0aW9u
IGFzc2lnbmVkIHNwZWNpYWwgbWVhbmluZyB0byBURENWIGFuZA0KPiA+ID4gPiBURENPJ3MgemVy
byB2YWx1ZXM6DQo+ID4gPiA+ICAgKiBURENWID0gMCAtPiBURENWIGlzIGF1dG9tYXRpY2FsbHkg
bWVhc3VyZWQgYnkgdGhlIHRyYW5zY2VpdmVyLg0KPiA+ID4gPiAgICogVERDTyA9IDAgLT4gVERD
IGlzIG9mZi4NCj4gPiA+ID4gDQo+ID4gPiA+IEluIG9yZGVyIHRvIGFsbG93IGZvciB0aG9zZSB2
YWx1ZXMgdG8gcmVhbGx5IGJlIHplcm8gYW5kIHRvIG1haW50YWluDQo+ID4gPiA+IGN1cnJlbnQg
ZmVhdHVyZXMsIHdlIGludHJvZHVjZSB0d28gbmV3IGZsYWdzOg0KPiA+ID4gPiAgICogQ0FOX0NU
UkxNT0RFX1REQ19BVVRPIGluZGljYXRlcyB0aGF0IHRoZSBjb250cm9sbGVyIHN1cHBvcnQNCj4g
PiA+ID4gICAgIGF1dG9tYXRpYyBtZWFzdXJlbWVudCBvZiBURENWLg0KPiA+ID4gPiAgICogQ0FO
X0NUUkxNT0RFX1REQ19NQU5VQUwgaW5kaWNhdGVzIHRoYXQgdGhlIGNvbnRyb2xsZXIgc3VwcG9y
dA0KPiA+ID4gPiAgICAgbWFudWFsIGNvbmZpZ3VyYXRpb24gb2YgVERDVi4gTi5CLjogY3VycmVu
dCBpbXBsZW1lbnRhdGlvbiBmYWlsZWQNCj4gPiA+ID4gICAgIHRvIHByb3ZpZGUgYW4gb3B0aW9u
IGZvciB0aGUgZHJpdmVyIHRvIGluZGljYXRlIHRoYXQgb25seSBtYW51YWwNCj4gPiA+ID4gICAg
IG1vZGUgd2FzIHN1cHBvcnRlZC4NCj4gPiA+ID4gDQo+ID4gPiA+IFREQyBpcyBkaXNhYmxlZCBp
ZiBib3RoIENBTl9DVFJMTU9ERV9URENfQVVUTyBhbmQNCj4gPiA+ID4gQ0FOX0NUUkxNT0RFX1RE
Q19NQU5VQUwgZmxhZ3MgYXJlIG9mZiwgYy5mLiB0aGUgaGVscGVyIGZ1bmN0aW9uDQo+ID4gPiA+
IGNhbl90ZGNfaXNfZW5hYmxlZCgpIHdoaWNoIGlzIGFsc28gaW50cm9kdWNlZCBpbiB0aGlzIHBh
dGNoLg0KPiA+ID4gDQo+ID4gPiBOaXRwaWNrOiBXZSBjYW4gb25seSBzYXkgdGhhdCBUREMgaXMg
ZGlzYWJsZWQsIGlmIHRoZSBkcml2ZXIgc3VwcG9ydHMNCj4gPiA+IHRoZSBUREMgaW50ZXJmYWNl
IGF0IGFsbCwgd2hpY2ggaXMgdGhlIGNhc2UgaWYgdGRjX2NvbnN0IGlzIHNldC4NCj4gPiANCj4g
PiBJIHdvdWxkIGFyZ3VlIHRoYXQgc2F5aW5nIHRoYXQgYSBkZXZpY2UgZG9lcyBub3Qgc3VwcG9y
dCBUREMgaXMNCj4gPiBlcXVpdmFsZW50IHRvIHNheWluZyB0aGF0IFREQyBpcyBhbHdheXMgZGlz
YWJsZWQgZm9yIHRoYXQgZGV2aWNlLg0KPiA+IEVzcGVjaWFsbHksIHRoZSBmdW5jdGlvbiBjYW5f
dGRjX2lzX2VuYWJsZWQoKSBjYW4gYmUgdXNlZCBldmVuIGlmDQo+ID4gdGhlIGRldmljZSBkb2Vz
IG5vdCBzdXBwb3J0IFREQyAoZXZlbiBpZiB0aGVyZSBpcyBubyBiZW5lZml0DQo+ID4gZG9pbmcg
c28pLg0KPiA+IA0KPiA+IERvIHlvdSBzdGlsbCB3YW50IG1lIHRvIHJlcGhyYXNlIHRoaXMgcGFy
dD8NCj4gPiANCj4gPiA+ID4gQWxzbywgdGhpcyBwYXRjaCBhZGRzIHRocmVlIGZpZWxkczogdGRj
dl9taW4sIHRkY29fbWluIGFuZCB0ZGNmX21pbiB0bw0KPiA+ID4gPiBzdHJ1Y3QgY2FuX3RkY19j
b25zdC4gV2hpbGUgd2UgYXJlIG5vdCBjb252aW5jZWQgdGhhdCB0aG9zZSB0aHJlZQ0KPiA+ID4g
PiBmaWVsZHMgY291bGQgYmUgYW55dGhpbmcgZWxzZSB0aGFuIHplcm8sIHdlIGNhbiBpbWFnaW5l
IHRoYXQgc29tZQ0KPiA+ID4gPiBjb250cm9sbGVycyBtaWdodCBzcGVjaWZ5IGEgbG93ZXIgYm91
bmQgb24gdGhlc2UuIFRodXMsIHRob3NlIG1pbmltdW1zDQo+ID4gPiA+IGFyZSByZWFsbHkgYWRk
ZWQgImp1c3QgaW4gY2FzZSIuDQo+ID4gPiANCj4gPiA+IEknbSBub3Qgc3VyZSwgaWYgd2UgdGFs
a2VkIGFib3V0IHRoZSBtY3AyNTF4ZmQncyB0Y2RvLCB2YWxpZCB2YWx1ZXMgYXJlDQo+ID4gPiAt
NjQuLi42My4NCj4gPiANCj4gPiBZZXMhIFN0ZWZhbiBzaGVkIHNvbWUgbGlnaHQgb24gdGhpcy4g
VGhlIG1jcDI1MXhmZCB1c2VzIGEgdGRjbw0KPiA+IHZhbHVlIHdoaWNoIGlzIHJlbGF0aXZlIHRv
IHRoZSBzYW1wbGUgcG9pbnQuDQo+IA0KPiBJIGRvbid0IHJlYWQgdGhlIGRvY3VtZW50YXRpb24g
dGhpcyB3YXkuLi4uDQoNCkBWaW5jZW50OiBJIGhhdmUgdG8gYWdyZWUgd2l0aCBNYXJjIGhlcmUu
IFBlcmhhcHMgbXkgZW1haWwNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LWNhbi8wOTRk
OGEyZWFiMjE3N2U1YTUxNDNmOTZjZjc0NWIyNjg5N2UxNzkzLmNhbWVsQGVzZC5ldS8NCndhcyBh
bHNvIG1pc2xlYWRpbmcuIEkgYWxzbyByZWZlcnJlZCB0aGVyZSB0byBhIE1pY3JvQ2hpcCBFeGNl
bCBzaGVldA0KKGh0dHBzOi8vd3cxLm1pY3JvY2hpcC5jb20vZG93bmxvYWRzL2VuL0RldmljZURv
Yy9NQ1AyNTE3RkQlMjBCaXQlMjBUaW1lJTIwQ2FsY3VsYXRpb25zJTIwLSUyMFVHLnhsc3gpDQp0
aGF0IGRlc2NyaWJlcyB0aGUgY2FsY3VsYXRpb24gb2YgdGhlIGJpdCB0aW1pbmcgYW5kIHRoZSBU
RENPLiBUaGUgdmFsdWVzIGNhbGN1bGF0ZWQgDQp0aGVyZSBjb3JyZXNwb25kIHRvIHRoZSBTUE8g
ZnJvbSB0aGUgYWJvdmUgZW1haWwuIE1pY3JvY2hpcCBjYWxjdWxhdGVzIHRoZSBURENPIGFzDQpU
RENPID0gKERQUlNFRyArIERQSDFTRUcpICogREJSUC4NClRodXMsIGFzIGFscmVhZHkgZGlzY3Vz
c2VkLCBuZWdhdGl2ZSB2YWx1ZXMgYXJlIG5vdCBwdXJwb3NlZnVsLg0KDQpTb3JyeSwgdGhhdCB0
aGF0IGVtYWlsIHdhcyBtaXNsZWFkaW5nLiBTbyBmYXIgSSd2ZSBzZWVuIG5vdyBvbmx5IHRoZSBF
U0RBQ0MgDQpjb250cm9sbGVyIGhhcyBhICJyZWxhdGl2ZSIgVERDTyByZWdpc3RlciB2YWx1ZSB3
aGVyZSBhIG5lZ2F0aXZlIHZhbHVlIG1heQ0KYmUgc2Vuc2libGUuDQoNCj4gPiA+IFNTUCA9IFRE
Q1YgKyBhYnNvbHV0ZSBURENPDQo+ID4gPiAgICAgPSBURENWICsgU1AgKyByZWxhdGl2ZSBURENP
DQo+ID4gDQo+ID4gQ29uc2VxdWVudGx5Og0KPiA+ID4gcmVsYXRpdmUgVERDTyA9IGFic29sdXRl
IFREQ08gLSBTUA0KPiANCj4gSW4gdGhlIG1jcDE1eHhmZCBmYW1pbHkgbWFudWFsDQo+IChodHRw
Oi8vd3cxLm1pY3JvY2hpcC5jb20vZG93bmxvYWRzL2VuL0RldmljZURvYy9NQ1AyNTFYWEZELUNB
Ti1GRC1Db250cm9sbGVyLU1vZHVsZS1GYW1pbHktUmVmZXJlbmNlLU1hbnVhbC0yMDAwNTY3OEIu
cGRmKQ0KPiBpbiB0aGUgMm1iaXQvcyBkYXRhIGJpdCByYXRlIGV4YW1wbGUgaW4gdGFibGUgMy01
IChwYWdlIDIxKSBpdCBzYXlzOg0KPiANCj4gPiBEVFNFRzEgIDE1IERUUQ0KPiA+IERUU0VHMiAg
IDQgRFRRDQo+ID4gVERDTyAgICAxNSBEVFENCj4gDQo+IFRoZSBtY3AyNTF4ZmQgZHJpdmVyIHVz
ZXMgMTUsIHRoZSBmcmFtZXdvcmsgY2FsY3VsYXRlcyAxNiAoPT0gU3luYyBTZWcrDQo+IHRzZWcx
LCB3aGljaCBpcyBjb3JyZWN0KSwgYW5kIHJlbGF0aXZlIHRkY28gd291bGQgYmUgMDoNCj4gDQo+
ID4gbWNwMjUxeGZkX3NldF9iaXR0aW1pbmc6IHRkY289MTUsIHByaXYtPnRkYy50ZGM9MTYsIHJl
bGF0aXZlX3RkY289MA0KPiANCj4gSGVyZSB0aGUgb3V0cHV0IHdpdGggdGhlIHBhdGNoZWQgaXAg
dG9vbDoNCj4gDQo+ID4gNDogbWNwMjUxeGZkMDogPE5PQVJQLFVQLExPV0VSX1VQLEVDSE8+IG10
dSA3MiBxZGlzYyBwZmlmb19mYXN0IHN0YXRlIFVQIG1vZGUgREVGQVVMVCBncm91cCBkZWZhdWx0
IHFsZW4gMTANCj4gPiAgICAgbGluay9jYW4gIHByb21pc2N1aXR5IDAgbWlubXR1IDAgbWF4bXR1
IDAgDQo+ID4gICAgIGNhbiA8RkQsVERDX0FVVE8+IHN0YXRlIEVSUk9SLUFDVElWRSAoYmVyci1j
b3VudGVyIHR4IDAgcnggMCkgcmVzdGFydC1tcyAxMDAgDQo+ID4gICAgICAgICAgIGJpdHJhdGUg
NTAwMDAwIHNhbXBsZS1wb2ludCAwLjg3NQ0KPiA+ICAgICAgICAgICB0cSAyNSBwcm9wLXNlZyAz
NCBwaGFzZS1zZWcxIDM1IHBoYXNlLXNlZzIgMTAgc2p3IDEgYnJwIDENCj4gPiAgICAgICAgICAg
bWNwMjUxeGZkOiB0c2VnMSAyLi4yNTYgdHNlZzIgMS4uMTI4IHNqdyAxLi4xMjggYnJwIDEuLjI1
NiBicnBfaW5jIDENCj4gPiAgICAgICAgICAgZGJpdHJhdGUgMjAwMDAwMCBkc2FtcGxlLXBvaW50
IDAuNzUwDQo+ID4gICAgICAgICAgIGR0cSAyNSBkcHJvcC1zZWcgNyBkcGhhc2Utc2VnMSA3IGRw
aGFzZS1zZWcyIDUgZHNqdyAxIGRicnAgMQ0KPiA+ICAgICAgICAgICB0ZGNvIDE1DQo+ID4gICAg
ICAgICAgIG1jcDI1MXhmZDogZHRzZWcxIDEuLjMyIGR0c2VnMiAxLi4xNiBkc2p3IDEuLjE2IGRi
cnAgMS4uMjU2IGRicnBfaW5jIDENCj4gPiAgICAgICAgICAgdGRjbyAwLi4xMjcNCj4gPiAgICAg
ICAgICAgY2xvY2sgNDAwMDAwMDAgbnVtdHhxdWV1ZXMgMSBudW1yeHF1ZXVlcyAxIGdzb19tYXhf
c2l6ZSA2NTUzNiBnc29fbWF4X3NlZ3MgNjU1MzUgcGFyZW50YnVzIHNwaSBwYXJlbnRkZXYgc3Bp
MC4wDQo+IA0KPiANCj4gPiBXaGljaCBpcyBhbHNvIHdoeSBURENPIGNhbiBiZSBuZWdhdGl2ZS4N
Cj4gPiANCj4gPiBJIGFkZGVkIGFuIGhlbHBlciBmdW5jdGlvbiBjYW5fdGRjX2dldF9yZWxhdGl2
ZV90ZGNvKCkgaW4gdGhlDQo+ID4gZm91cnRoIHBhdGggb2YgdGhpcyBzZXJpZXM6DQo+ID4gaHR0
cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtY2FuLzIwMjEwODE0MDkxNzUwLjczOTMxLTUtbWFp
bGhvbC52aW5jZW50QHdhbmFkb28uZnIvVC8jdQ0KPiA+IA0KPiA+IERldmljZXMgd2hpY2ggdXNl
IHRoZSBhYnNvbHV0ZSBURENPIGNhbiBkaXJlY3RseSB1c2UNCj4gPiBjYW5fcHJpdi0+dGRjLnRk
Y28uIERldmljZXMgd2hpY2ggdXNlIHRoZSByZWxhdGl2ZSBURENPIHN1Y2ggYXMNCj4gPiB0aGUg
bWNwMjUxeGZkIHNob3VsZCB1c2UgdGhpcyBoZWxwZXIgZnVuY3Rpb24gaW5zdGVhZC4NCj4gDQo+
IERvbid0IHRoaW5rIHNvLi4uLg0KDQpAVmluY2VudDogUGVyaGFwcyB5b3Ugc2hvdWxkIG5vdCBp
bXBsZW1lbnQgdGhpcyBoZWxwZXIgZnVuY3Rpb24gYXMgaXQgaXMgb25seSBuZWVkZWQNCmZvciB0
aGUgRVNEQUNDIHNvIGZhci4NCg0KPiA+IEhvd2V2ZXIsIHlvdSB3aWxsIHN0aWxsIG5lZWQgdG8g
Y29udmVydCB0aGUgVERDTyB2YWxpZCByYW5nZSBmcm9tDQo+ID4gcmVsYXRpdmUgdmFsdWVzIHRv
IGFic29sdXRlIG9uZXMuIEluIHlvdXIgY2FzZSAwLi4xMjcuDQo+IA0KPiBNYXJjDQo+IA0KDQpT
dGVmYW4NCg0K
