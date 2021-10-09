Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792EB427C71
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 19:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhJIRzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 13:55:33 -0400
Received: from mail-eopbgr1400131.outbound.protection.outlook.com ([40.107.140.131]:34019
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229448AbhJIRzc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Oct 2021 13:55:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i1eLZXNlnuB5pnKwTgoR0HoVpQk6igGWZhAFessJiLBfuON6nQwjZyDYiGgpzQ5ctadu70zVyGwCC6xF0cJaTVYQZl6KoU69jOaFJkbzvt4LT1wjWQRcPjfDPinO1hK6cq0PoRfrBgTUiYvoHf/jbLcL/tg0S08bQwvfOSpqOuA471ibMCTwxGfC6b9jIe3j0u41bSURpn/b1p9pMg7O084EM7qF3iwAp16nRAWxo7nkOwfLsOhvS8w3PofaE6PA7S6m+nPQze+DxbZbnSvXghJMjf26KXl9gyRKUgEbRsYfK9hiNRqeNahE2ngbTvCUBK+aLeaGy4I8m3by/c+rIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T8Bq/H6cGvoA/BpdrXY/gy7tkupIgHscHaKisu2/TMc=;
 b=bSDrk6hNXnfP6dJWKYPcnYKHgDoiTmCEIxlSF77qeMzHwYSYo5AbP6fK2Bszd1PHNwbjBHOc7PbgCKfWFdk5ovOrrF38ds+YGpvGatnceagCm/BY0heTI8tzZQQXxS0Rgt946W925dCUCEX02sU0EVnIeGid5J9CGHv8UI2lTV1acAoPCUyWI6IsJu2BDqQnHqMbg91PBt8tmUcAgm2NyWzpXhJqEH2cRMa5KnhpvqcEvEEqNWrnrUEJRKtZlubN6206NNQMHxP2ZiXmmdtUpSTy47+4zUl9JRXapSXOI/ny7rpmXi1Cp+xNcwAfjs9Bgx3YK35DvWxRwA4HHfVGUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T8Bq/H6cGvoA/BpdrXY/gy7tkupIgHscHaKisu2/TMc=;
 b=r0PLaM93mHRY63QZKGaYyZ9/L12I/9uF0SMSaq3AS15IHUhW7YTHDZcSM31aRCCRcMSdkc1tdsVPRJscSmmxb8Q32WxUBkyQXdhVCBw4kYLqigOpifW2Fmk/5Dm0XsCwz1EIiDwoJyK7vkuhAU9XhWsd6VOYbjp8zsZwlrWcoPE=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB3889.jpnprd01.prod.outlook.com (2603:1096:604:52::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Sat, 9 Oct
 2021 17:53:31 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4587.024; Sat, 9 Oct 2021
 17:53:29 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [RFC 03/12] ravb: Fillup ravb_set_features_gbeth() stub
Thread-Topic: [RFC 03/12] ravb: Fillup ravb_set_features_gbeth() stub
Thread-Index: AQHXudkfXI2W6zxlnkCipKWTBPO9NavEwo2AgADUVkCABWFjAA==
Date:   Sat, 9 Oct 2021 17:53:29 +0000
Message-ID: <OS0PR01MB5922DBC6EF8E23340B47162686B39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
 <20211005110642.3744-4-biju.das.jz@bp.renesas.com>
 <17eb621c-05f8-155b-24ed-5445f445c6ce@omp.ru>
 <OS0PR01MB59223E020F4AEE30CD13F9E786B09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
In-Reply-To: <OS0PR01MB59223E020F4AEE30CD13F9E786B09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: bp.renesas.com; dkim=none (message not signed)
 header.d=none;bp.renesas.com; dmarc=none action=none
 header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e2121f79-f494-495e-a5cb-08d98b4db3ff
x-ms-traffictypediagnostic: OSAPR01MB3889:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB3889896F6BEB0169D28D429886B39@OSAPR01MB3889.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rlikk6FSpRhypHDYAQ5Ttfn4YDi/JlC5mbE86/rot00+J3213LB89Eilt6ZPE7IuwWdX5IY/oYYVoc8z3M1jP3R0Wrki9dXynknAeMVYUdu32OVW96C39x0pgxQIgowcOxeaa1opn5ApFu7cEE7eWEr3r0VWjTohCTFJ4gfwu7si1tOUgeUQ3G6YhISByQbX7OhmgtZZF8xKIQh4k5buEces24c0GiK1JLMYCgk+kKwuPaqXe7hjEy8WJIzUmSXIedtHYncOvrhasmbNMsbY0V9sxQH5nVM07XPHOp0glE6IHHhDBmIuB1sDRG39g70I5hH8GYvkEJpsakO2uDv+HBxVUz9+QkjhBtRTth6Bnz/PVxRHgfu/Qv4RVeg2o/XWPQfNkFvB9nXqyWjAejQb/AU4kGfhYyDECmYsWKyVeaZMq/EgE8wXK15bbQbz6I8sqpU9JhmPNA9ktvwwf7GCebcDf8HgbEWkH5ZtYcOCsECxnE5ppdCISBFGw9y1H0W4lNyBDz9GTYUmMDw7jPjPdA8ep86Hb+aL3fpgcmPCibSSavSBxRq2hZ3CsAPwd+zT81cRqj3dyLR7ArNFwHtpZMlVYFdbUPQVq3WOpMl0v5CkxY9JCC0cg9FUXrZ2SCBaY8xLOOBYDSROR+u1QEPLqQJaYtEACzrOSKr1/G/byHFnfZpXWSTFjZz9frqylac1wYSw7CeqhlRzuCyUd+HODw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(55016002)(64756008)(66946007)(66476007)(66446008)(508600001)(122000001)(38070700005)(52536014)(66556008)(4326008)(5660300002)(76116006)(38100700002)(33656002)(53546011)(83380400001)(107886003)(7416002)(6506007)(26005)(2906002)(186003)(7696005)(86362001)(71200400001)(110136005)(54906003)(316002)(8936002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MFZQZm1WdEZ5eERxdFJJcWtCelpTWERoSmhGTGZWTmgwWVJKWWhiNjlHN0Y5?=
 =?utf-8?B?RTRoL2tZR1M3YlM2Z3c2Y1cxMGlIU1IxR0xhbmJxN1FWUWR4NU9LU1dKbnpT?=
 =?utf-8?B?dHdOM3FSU2l4bWt5WXo4dHNDUmFZS0xWYmo4WmFwL003cTlkOGVVMkF2SFBW?=
 =?utf-8?B?T0hGOXlNL2dZZWNQSm45bDN2QUlScnZWU25EcWlRZVp2bzJGOXNEMTJKdFVC?=
 =?utf-8?B?YzJpa3hQR3NuUXAzRHZGbm43ZkVzQlh4dFpCalE5VUxCZDkxNUVYeGg0MmIz?=
 =?utf-8?B?VWJTUlFmdUF0VDBmVXE1UFRnS2RsNE5XN1VQQXhrWmxIdnBNQXoyajlVemtv?=
 =?utf-8?B?MHJHQXNvSmZSZTljeG85elV5bzJVQ1duMHdrVjBHdWVqUlRQak1wQlRkRVdu?=
 =?utf-8?B?OTZodGVOczVXdVBDYkY1RlZFN0g0NFh1YXdNVDgzUXdMRmFJWXRjcER0ZlVK?=
 =?utf-8?B?bzBpV1hLUEI4aERCQXllU24rR0c4TWVJU3JBWDRIdjZFeVFkMGx4aGpLbHN1?=
 =?utf-8?B?RFREc1MzQXdKMVpRT2RMM1JLVmFiTXJKVXYxY0JwWEpvaS9CVTdHNWJiSlVW?=
 =?utf-8?B?c0Y5K28wSG1xbkh1SThkLy9oRGY0OVkwZEZiR0RTSWtvWENjTGRMMXVnc1hB?=
 =?utf-8?B?WDBoR0lDejhJWXZXOHQ1cVh2eTVYUTNtOGw5eTZUeGZ4VlA3LzUyNUZueEov?=
 =?utf-8?B?QWR4SFVZcjl6OXdTczRhTHRXYWd6c0o4aStwbmVLcWp3NFFTdmNEZ2srQnhX?=
 =?utf-8?B?ajNoVmY1Y1lrbUZiM1J2ODJOdVV4bUNOMVdqbTZPRzBUUzFZV1RKNkc3amEz?=
 =?utf-8?B?Y2pPSmxJeUgwOUNiNzJqSTVxekVDVjVzQ21BQkhETUxXTGJGcWx1ZGJvVWx6?=
 =?utf-8?B?c1h3ZVhwSzVjOVByYWIrK3MwOG16RFE5L0dITEo5amRPMkNuR0dzLzhPSUZy?=
 =?utf-8?B?V2xRWWpsSXBtZGlKOVN5OW81R2VwaE43RzRkMU1Gd1NhSTRmbGFmcmRaclFH?=
 =?utf-8?B?dThhQUR1dk9GcE9aUEt5bmNWU3EzM2hpY3JMTlFyN25YVVJaZ1RQU3lVL0g1?=
 =?utf-8?B?VjJnWVdsbVdvVUFleS9sbC8xa3BUVVIyR0FBa3ZCaUxpbEFyWDd5dUZFMDZ0?=
 =?utf-8?B?dlhGZlFybG5BcWRkb0l1N3lXVEw5ZEEvWm5XQnBBdHJSM2Z1SnpFdkZMbUVu?=
 =?utf-8?B?RmpYVEFacmMyNFBmQlJ3c3ViNlBlaFoxblNnNVg4ZThRdzQyV2JHZVQ5Unht?=
 =?utf-8?B?NDkwUFprVS9oRGhpZ0h0UnZoNmtJWHpQU0wrR1hsVHRjdkdhTUI0U3I2V2cz?=
 =?utf-8?B?VE50RG5uQzNkYUI4NHVZdy9tcFk4TWZUSTB2dVJIUHJlL1VYWWVLc3FEUzQv?=
 =?utf-8?B?RlFoV0c1YlZqd1luL1NZSnlHVFhPNWl6Skl3bUNwZjRwSDdBR1hVay90ekNy?=
 =?utf-8?B?ZVZLQ3pyM2toNXczeng5KzhPTy9rcS94WWFJdkFhTkR5QnJZWFhZbUN4bG5X?=
 =?utf-8?B?RzhoTFBsUWVjMjNmTkdxOWM2REpMMGRCWkVjMTlvdTcvNXJKUUpSdWFKbVZC?=
 =?utf-8?B?UTNJY1l0bi9iVlpXbGZCS2hUZ2tZUGRUaFYwWWsxUzZCdC9IcWF1MFBnSzU1?=
 =?utf-8?B?QTNOS1V1MnNPQUllUTRYd2pQZHJQZUFxQ09BclpNTEpaL2E5Zy9GZy9Ga1ky?=
 =?utf-8?B?eHJiaHlaWXFIR2xlRDRFVmRhampyeUpuUlY1WWQ2R1Z3VEtoK1VSOU5GaDBX?=
 =?utf-8?Q?r2PrI7eeoAOmSQqakI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2121f79-f494-495e-a5cb-08d98b4db3ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2021 17:53:29.2678
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GeXRXD55FyF2xO/0xGrDaCfG1T338bRqK8mxRkATIa2OE/gCFf/HppAtSDi9aQKcjjQk8xza0wbxwAHJUlKo3bEApNb13XVTS9ibH0ivo90=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB3889
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQmlqdSBEYXMgPGJpanUu
ZGFzLmp6QGJwLnJlbmVzYXMuY29tPg0KPiBTZW50OiAwNiBPY3RvYmVyIDIwMjEgMDg6NDQNCj4g
VG86IFNlcmdleSBTaHR5bHlvdiA8cy5zaHR5bHlvdkBvbXAucnU+OyBEYXZpZCBTLiBNaWxsZXIN
Cj4gPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3Jn
Pg0KPiBDYzogR2VlcnQgVXl0dGVyaG9ldmVuIDxnZWVydCtyZW5lc2FzQGdsaWRlci5iZT47IFNl
cmdleSBTaHR5bHlvdg0KPiA8cy5zaHR5bHlvdkBvbXBydXNzaWEucnU+OyBBZGFtIEZvcmQgPGFm
b3JkMTczQGdtYWlsLmNvbT47IEFuZHJldyBMdW5uDQo+IDxhbmRyZXdAbHVubi5jaD47IFl1dXN1
a2UgQXNoaXp1a2EgPGFzaGlkdWthQGZ1aml0c3UuY29tPjsgWW9zaGloaXJvDQo+IFNoaW1vZGEg
PHlvc2hpaGlyby5zaGltb2RhLnVoQHJlbmVzYXMuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9y
ZzsgbGludXgtDQo+IHJlbmVzYXMtc29jQHZnZXIua2VybmVsLm9yZzsgQ2hyaXMgUGF0ZXJzb24g
PENocmlzLlBhdGVyc29uMkByZW5lc2FzLmNvbT47DQo+IEJpanUgRGFzIDxiaWp1LmRhc0BicC5y
ZW5lc2FzLmNvbT47IFByYWJoYWthciBNYWhhZGV2IExhZA0KPiA8cHJhYmhha2FyLm1haGFkZXYt
bGFkLnJqQGJwLnJlbmVzYXMuY29tPg0KPiBTdWJqZWN0OiBSRTogW1JGQyAwMy8xMl0gcmF2Yjog
RmlsbHVwIHJhdmJfc2V0X2ZlYXR1cmVzX2diZXRoKCkgc3R1Yg0KPiANCj4gSGkgU2VyZ2VpLA0K
PiANCj4gVGhhbmtzIGZvciB0aGUgZmVlZGJhY2suDQo+IA0KPiA+IFN1YmplY3Q6IFJlOiBbUkZD
IDAzLzEyXSByYXZiOiBGaWxsdXAgcmF2Yl9zZXRfZmVhdHVyZXNfZ2JldGgoKSBzdHViDQo+ID4N
Cj4gPiBPbiAxMC81LzIxIDI6MDYgUE0sIEJpanUgRGFzIHdyb3RlOg0KPiA+DQo+ID4gPiBGaWxs
dXAgcmF2Yl9zZXRfZmVhdHVyZXNfZ2JldGgoKSBmdW5jdGlvbiB0byBzdXBwb3J0IFJaL0cyTC4N
Cj4gPiA+IEFsc28gc2V0IHRoZSBuZXRfaHdfZmVhdHVyZXMgYml0cyBzdXBwb3J0ZWQgYnkgR2JF
dGhlcm5ldA0KPiA+ID4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6IEJpanUgRGFzIDxiaWp1LmRhcy5q
ekBicC5yZW5lc2FzLmNvbT4NCj4gPiA+IFJldmlld2VkLWJ5OiBMYWQgUHJhYmhha2FyIDxwcmFi
aGFrYXIubWFoYWRldi1sYWQucmpAYnAucmVuZXNhcy5jb20+DQo+ID4gWy4uLl0NCj4gPg0KPiA+
ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMN
Cj4gPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+ID4g
aW5kZXggZWQwMzI4YTkwMjAwLi4zN2Y1MGMwNDExMTQgMTAwNjQ0DQo+ID4gPiAtLS0gYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gPiArKysgYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gWy4uLl0NCj4gPiA+IEBAIC0y
MDg2LDcgKzIwODcsMzcgQEAgc3RhdGljIHZvaWQgcmF2Yl9zZXRfcnhfY3N1bShzdHJ1Y3QNCj4g
PiA+IG5ldF9kZXZpY2UgKm5kZXYsIGJvb2wgZW5hYmxlKSAgc3RhdGljIGludA0KPiA+ID4gcmF2
Yl9zZXRfZmVhdHVyZXNfZ2JldGgoc3RydWN0DQo+ID4gbmV0X2RldmljZSAqbmRldiwNCj4gPiA+
ICAJCQkJICAgbmV0ZGV2X2ZlYXR1cmVzX3QgZmVhdHVyZXMpDQo+ID4gPiAgew0KPiA+ID4gLQkv
KiBQbGFjZSBob2xkZXIgKi8NCj4gPiA+ICsJbmV0ZGV2X2ZlYXR1cmVzX3QgY2hhbmdlZCA9IGZl
YXR1cmVzIF4gbmRldi0+ZmVhdHVyZXM7DQo+ID4gPiArCWludCBlcnJvcjsNCj4gPiA+ICsJdTMy
IGNzcjA7DQo+ID4gPiArDQo+ID4gPiArCWNzcjAgPSByYXZiX3JlYWQobmRldiwgQ1NSMCk7DQo+
ID4gPiArCXJhdmJfd3JpdGUobmRldiwgY3NyMCAmIH4oQ1NSMF9SUEUgfCBDU1IwX1RQRSksIENT
UjApOw0KPiA+ID4gKwllcnJvciA9IHJhdmJfd2FpdChuZGV2LCBDU1IwLCBDU1IwX1JQRSB8IENT
UjBfVFBFLCAwKTsNCj4gPiA+ICsJaWYgKGVycm9yKSB7DQo+ID4gPiArCQlyYXZiX3dyaXRlKG5k
ZXYsIGNzcjAsIENTUjApOw0KPiA+ID4gKwkJcmV0dXJuIGVycm9yOw0KPiA+ID4gKwl9DQo+ID4g
PiArDQo+ID4gPiArCWlmIChjaGFuZ2VkICYgTkVUSUZfRl9SWENTVU0pIHsNCj4gPiA+ICsJCWlm
IChmZWF0dXJlcyAmIE5FVElGX0ZfUlhDU1VNKQ0KPiA+ID4gKwkJCXJhdmJfd3JpdGUobmRldiwg
Q1NSMl9BTEwsIENTUjIpOw0KPiA+ID4gKwkJZWxzZQ0KPiA+ID4gKwkJCXJhdmJfd3JpdGUobmRl
diwgMCwgQ1NSMik7DQo+ID4gPiArCX0NCj4gPiA+ICsNCj4gPiA+ICsJaWYgKGNoYW5nZWQgJiBO
RVRJRl9GX0hXX0NTVU0pIHsNCj4gPiA+ICsJCWlmIChmZWF0dXJlcyAmIE5FVElGX0ZfSFdfQ1NV
TSkgew0KPiA+ID4gKwkJCXJhdmJfd3JpdGUobmRldiwgQ1NSMV9BTEwsIENTUjEpOw0KPiA+ID4g
KwkJCW5kZXYtPmZlYXR1cmVzIHw9IE5FVElGX0ZfQ1NVTV9NQVNLOw0KPiA+DQo+ID4gICAgSG0s
IHRoZSA+bGludXgvbmV0ZGV2X2ZlYXR1cmVzLmg+IHNheXMgdGhvc2UgYXJlIGNvbnRyYWRpY3Rv
cnkgdG8NCj4gPiBoYXZlIGJvdGggTkVUSUZfRl9IV19DU1VNIGFuZCBORVRJRl9GX0NTVU1fTUFT
SyBzZXQuLi4NCj4gDQo+IEl0IGlzIGEgbWlzdGFrZSBmcm9tIG15IHNpZGUsIEkgYW0gdGFraW5n
IG91dCB0aGlzIHNldHRpbmcuIEFueSB3YXkgYmVsb3cNCj4gY29kZSBvdmVycmlkZXMgaXQuDQo+
IFRoaXMgd2lsbCBhbnN3ZXIgYWxsIHlvdXIgY29tbWVudHMgYmVsb3cuDQoNCkkgYW0gZGVmZXJy
aW5nIHRoaXMgcGF0Y2ggYW5kIHdpbGwgdGFrZSBvdXQgIFJYIGNoZWNrc3VtIG9mZmxvYWQgZnVu
Y3Rpb25hbGl0eSBmcm9tIHBhdGNoIzcNCg0KV2lsbCBwb3N0IHRoaXMgMiBwYXRjaGVzIGFzIFJG
QywgYXMgbG9va3MgbGlrZSBpdCBuZWVkcyBtb3JlIGRpc2N1c3Npb25zIHJlbGF0ZWQgdG8gSFcg
Y2hlY2tzdW0uDQoNClJlZ2FyZHMsDQpCaWp1DQoNCj4gDQo+IFJlZ2FyZHMsDQo+IEJpanUNCj4g
DQo+ID4NCj4gPiA+ICsJCX0gZWxzZSB7DQo+ID4gPiArCQkJcmF2Yl93cml0ZShuZGV2LCAwLCBD
U1IxKTsNCj4gPg0KPiA+ICAgIE5vIG5lZWQgdG8gbWFzayBvZmYgdGhlICdmZWF0dXJlcycgZmll
bGQ/DQo+ID4NCj4gPiA+ICsJCX0NCj4gPiA+ICsJfQ0KPiA+ID4gKwlyYXZiX3dyaXRlKG5kZXYs
IGNzcjAsIENTUjApOw0KPiA+ID4gKw0KPiA+ID4gKwluZGV2LT5mZWF0dXJlcyA9IGZlYXR1cmVz
Ow0KPiA+DQo+ID4gICAgTWhtLCBkb2Vzbid0IHRoYXQgY2xlYXIgTkVUSUZfRl9DU1VNX01BU0s/
DQo+ID4NCj4gPiBbLi4uXQ0KPiA+DQo+ID4gTUJSLCBTZXJnZXkNCg==
