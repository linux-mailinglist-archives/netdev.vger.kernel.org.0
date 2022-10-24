Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDAC260B4DE
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 20:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbiJXSGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 14:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbiJXSFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 14:05:23 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2072c.outbound.protection.outlook.com [IPv6:2a01:111:f403:7010::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17921C69EC;
        Mon, 24 Oct 2022 09:46:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TxpZB/AJgtc925OP5UDmilJ0khBpc0ulwaOrmBqxlGGzjKO/ZyDhM8RtHlKDLIg15LfITgnxgSNxXFILuL7jSe6koGiouCCZMJQBre2Q8ttNKG75H1sywHFvR9F0R3G1nnLnbWzYupgcnPHuvYceFRZGpyjhkbLcf44lWJhwjys4mOC4VR8fKRlshbvIZdcPCKR3+XUBzVFxOzk22yGVNh6JtATn/8Fo1I1vZdV3djP6Mik6MHzEPhQaXwJwN6uEf2NC4qzd4a4HzsOQHLmJqZzxzoAJdt+dAluXrrBYB/2MbfZUR+Z9E2z6z/+54T51zAYjN/dXNnR8xcC7zYqLig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0K9Yh8d2A8CnPa13lQ+wWqdLICIo8p0yAsUILE9hOYs=;
 b=GGHwzSn0pxiB98iX+XGFX6r23pOPVJs0DIRhwKFe4HEG+Imd2Kwfrix7cUpwrLVXvIUbyfU25mwu4Jkj6QMK9ydqa4Mkht3d5Ar+vt4UXV+wZF5zbZ2rzDj3kmdEOia8//PIjoeGA26BG/2fwB5LXPZ+MckSvkJ8IVKUIdAWTi6Y5FcCGhEGZR3dJ5Fpuzcaz0r5bf5BOHbLt3oGDwgFCbGY+LL/KVK2XFB1noWqIRAI0AoMxZTXAfFng/8y4+f8OJ7S0t9PmLfo+Rc2Vq0OpwDBEKkU2wulfZ+VFrvoagB75Z/zR/Dfh6e6FAaSPbYMXxQGr5Q8J9T4NnEJUkr3GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0K9Yh8d2A8CnPa13lQ+wWqdLICIo8p0yAsUILE9hOYs=;
 b=eh1WTsyXroR0oIE+thmJO78oqi8MkaP7N+di/cxVBl5uoTRCT3zq//Srdrl0kGECHTVPEDLkGcaoMlI2cDIJE77nfww/qTp/WCzmGO0QnvqNJxWlvFqnUQCPC57N3r55tpabbadCBga5NIAsj4hbsjYZFLcFedrhHm8MJ0cZdQM=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYCPR01MB8598.jpnprd01.prod.outlook.com (2603:1096:400:138::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.26; Mon, 24 Oct
 2022 16:42:26 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::fea0:9039:b0b3:968f]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::fea0:9039:b0b3:968f%7]) with mapi id 15.20.5746.028; Mon, 24 Oct 2022
 16:42:26 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        =?utf-8?B?U3RlZmFuIE3DpHRqZQ==?= <stefan.maetje@esd.eu>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Rob Herring <robh@kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH 1/3] can: rcar_canfd: Fix IRQ storm on global fifo receive
Thread-Topic: [PATCH 1/3] can: rcar_canfd: Fix IRQ storm on global fifo
 receive
Thread-Index: AQHY5fEK6d4STYQGnkuaJSprEex4Pq4dsSYAgAAKShA=
Date:   Mon, 24 Oct 2022 16:42:26 +0000
Message-ID: <OS0PR01MB5922847D826B17D19CB5DEA8862E9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20221022081503.1051257-1-biju.das.jz@bp.renesas.com>
 <20221022081503.1051257-2-biju.das.jz@bp.renesas.com>
 <20221024153726.72avg6xbgzwyboms@pengutronix.de>
In-Reply-To: <20221024153726.72avg6xbgzwyboms@pengutronix.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|TYCPR01MB8598:EE_
x-ms-office365-filtering-correlation-id: d6838cd4-c521-4322-b15b-08dab5debbff
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P8jKX9QcUVjyw2DZwpN4XjqJD66VtAzh9/HemYOSmcBrHOE3rIs6O8QkKt6Y6a2rZE6glZymScNTM6wr5mAOSYfX6R3l+lF60z4ktVaY2MoSt8pYUAcc8IuU7pXUwDEnraGzm4+6nQAZIA8B4R4xxB7kpNIQe/1cCdEW4anyEzRKZcIGOHJRcEcH1IT4RPFVANSet18eROimzKW6j3LVFk79MPZ9TrM1/QPOuIyhUFC5AxOtLPz+v+P4UvV4rb6/VbNJZTefcKBM8dgal9YCwFZm38PQ1i2feMriwYE3AkHyElrgp9ALs58q5aCtNqI+BWVFdyHZ6cpQ05OPB1JZAYNxSP5bzQOnrAzSrUACQ2AxGkmFcJDJZ1sWrOgTTKp9Gc5kWpXYUuD9RDoTDQ9eieyIoqY7KH4+0xICQgD+b2UTOtLbs8SykDpcGjVWD56d1rT+DYYJQPq2WpiFK0FRE85aqsLeKHgfPmbxKyyuhGn2tXI9uxwpQVs1rc0J1IUUkxWshr/3+KgOETxeSwXpI0STanPWtjRRsR0qYgdbU9S9LMvkLdk8/qT7F/c73Tbg9rD7ofSoLn5Lca8RBjtPVqyRVWSMRGOsohAAZfJa3t00iDjTvmcgdAaKefuqB99WyOOZn+t/yvCiCfYJbRdL98582s7Uocv+B6NKczdE66NIVlqTmVOhj1yxCiCiWTHZnCKdg1/TzOp5lOM3dr+rvBUTkxoDJ7HZhHIeJBy3CF8KY0wn99Sdu2zM4jmDhIwVAW/OxipHm9q6odbirqFJiQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(39860400002)(396003)(366004)(451199015)(9686003)(26005)(7696005)(6506007)(53546011)(186003)(83380400001)(2906002)(55016003)(478600001)(6916009)(54906003)(7416002)(316002)(71200400001)(66556008)(41300700001)(52536014)(8936002)(5660300002)(66946007)(76116006)(64756008)(66446008)(66476007)(4326008)(8676002)(86362001)(33656002)(122000001)(38100700002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SDU0Y1VzbGpLZkRsR2Y1b2tnbUdtV05iVTczTFVRTGZidkJlVjV3SCtEc2FO?=
 =?utf-8?B?czRVTGpvY0gyb2dKSWtIWWFqaStxY0hzL2FBekxyZDVlbExtWVFjcnVGL2tL?=
 =?utf-8?B?MERsVGlvY0tlZGtIWC9ZMmo0UDdwbTQ1VmdGbXViTEpPWkNSNk5VUlowNEJF?=
 =?utf-8?B?THhVNDEzaEtoaS9OT2dlUzI1QnB2YUFuSm80WE1QR1d2WVJUWG9VSTkwSWNT?=
 =?utf-8?B?TnVGYVJtSkZSSG0vNDI0bllnT3IvQVlZT0pLWVBvYXNiNW1GTTZLYUo0UmNL?=
 =?utf-8?B?NkxydE1Wd2xxb2hKTkFQbUtUcHdZNktyRGRiK0RmZnBUQWdvSUlhaG9xVnJY?=
 =?utf-8?B?WG5qRURKcGdiMy9tUWdiL1ErRU9MN0w4R25jNXUxNUpYK3MvSG5aMHBZbUxi?=
 =?utf-8?B?VmtEcmFuUERwWDd0YW1ERk5QOGdMcTlnc2ZVQ3NqUUlEc0doZDNveEpKZzE0?=
 =?utf-8?B?Wi9aT1F5K1V6UWdvaUJQbGlqc2dRVnJBU1VJMGFRQVk1d0ZuREsyVDlDTEpT?=
 =?utf-8?B?ZGhhc0RlT2ZXWUs0aVFYLzRMR3huY1E2SndlSkYxMWpNdFhXZnY4dHZKTGlo?=
 =?utf-8?B?Nzd6MXVyaVErL2lXYnY0ekU5OThQcUNZTmd6ZnZndHNoVWluTEVpTFI4b3lO?=
 =?utf-8?B?OEE4d3pKUnM1N1RFMVplYzVzRGJtK084d1RlMG9lc25aSHhSbitZbGJyaitR?=
 =?utf-8?B?VHliM3p1YnNwWnBaSGliVXNuR201bFpsMmsyZXRFblpFOWdFVDRwcm1FWTZZ?=
 =?utf-8?B?R3NxbXhXd2RsdjJ1eDN3TC9qbzNiRVE3U0Uxa3k1ejdRcVc2ZXovc29PV1hM?=
 =?utf-8?B?RU5lWVVxc3hMV2pINVlPMlZwSlI3N1Z0KzFITjJsdER5Z3A0c3pDZW0zckNZ?=
 =?utf-8?B?TktxOG1veUJrMFlSWjVyWVBjOXhTSC96WW9DbkFReDZ1dFBFQ0pKMW1iQ2tr?=
 =?utf-8?B?MlN0cDFJQVVRNVFzYVliZUc1VEFmK1NLVzVEMWZaZHF4VURZUGUxc0JWejdq?=
 =?utf-8?B?ek41MXdmcjV1TzhzNjFNUzNWTS9SNUtseDZXRVIvWDd2anRyY1M5cEdDcDZQ?=
 =?utf-8?B?anRGR21VSUZyaEgzQjJ5WmRmMS9Pd2pybVUwTm9nYmJqNkhBUzZMbjlEZDZp?=
 =?utf-8?B?NE5qK0F5TlVyaHg4dzRmSmY4cnlCUmV4Rll4TjBYSVJhRXBhVmExaURYZjd3?=
 =?utf-8?B?T0ZRVFBSQUNjdXF1blcyc1Y1M29TVG9scmRtQnVHZVNQOFBuMXB4MUJPQTY2?=
 =?utf-8?B?bEhsWVZ4NEhZT3dJYWlUU1d1R25odUlLZi9IZGZQcTExd2diSUc1SnpXbnVH?=
 =?utf-8?B?emdRV2NSa0xYck93NkNOeVBQTmdPUEUrRXkwbVJqVXlyanV2bHhQb3VvRkNF?=
 =?utf-8?B?VlVVNEhsa1c0azlJTzNTcENLcDRUQ1U2TGJOZjRmM3J1SDhuMm9saHVvSy8x?=
 =?utf-8?B?bEQ4d3JQQUFrMUhNU1dQOWhKMWRJMHhYeXAzVjZBblB0RkVPWE1lOHd2UG05?=
 =?utf-8?B?WFJPNE5PTlRCcjZ2d0o0SjBTTnBLeTIxMEVkWUE5eDRWcFFXV1luSGlzUFJo?=
 =?utf-8?B?a1lTeFNPTzZqRncrUldUaCtCZ2h4dlJYRHFabkt3OGZnOTJQZnlSSm1XMCt0?=
 =?utf-8?B?NUxSK2RSYUhiNjdTQVAvVHNjR2JYK1pjTG91bkVkdDhLODllTS9mcXhXYTNG?=
 =?utf-8?B?T0FsQ0EyRFNyekxSTld3KzlCU3VPYjNtLy92NDEvSFp5SnpGR3dySFc0VEhJ?=
 =?utf-8?B?d2VDNm9YdGM2dGZVU2VCV1lFMkc4bWk4QnhMNmlQR3lRTFBrMTh4eEJDSlVT?=
 =?utf-8?B?Y0l6NlpsSXhJdGNqSEQyc3g2WmUvOWNxMWdaVVFnTktkZ2I1UlJ2OTlrbkF4?=
 =?utf-8?B?bzJSOG9IWmxkell2T1dQS2tmK2lpVFhtckNkZGh3eDRyRGJEUkNqUkk0MTZG?=
 =?utf-8?B?NGFxVTRCRWdDbU50YnpadzI0SS85L3NlMmFMb0hGaXREOTdIOVVRQmVtV3dN?=
 =?utf-8?B?VURMcGJTc09FM05Qc0dCYVlKODNDUjVCeHd4eTBtZ0NVYzRRZnNTUElOaEgv?=
 =?utf-8?B?QWRoMGp5WHZwZXVrdlVDREszVk12VlFvV2xXU2JNVlBSTlJoQ0UvSk84eldT?=
 =?utf-8?B?eTVUYnZ0QksrYVNjdVdKWnMybFhhNC9kNTNlSkJvVFRQRThLazZ3eFUzY0Z4?=
 =?utf-8?B?dUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6838cd4-c521-4322-b15b-08dab5debbff
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2022 16:42:26.7497
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sudQhuaamVlpeHKTIuEAeLspLXxLjtWShs+P/giVXaOu5Wr1UGzgHEGZZOxERt/UAivYpK05G62fILgqcVWHvUdoyNQNbdTqXWGdB7IMIUQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB8598
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyYywNCg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIDEvM10gY2FuOiByY2FyX2NhbmZkOiBG
aXggSVJRIHN0b3JtIG9uIGdsb2JhbCBmaWZvDQo+IHJlY2VpdmUNCj4gDQo+IE9uIDIyLjEwLjIw
MjIgMDk6MTU6MDEsIEJpanUgRGFzIHdyb3RlOg0KPiA+IFdlIGFyZSBzZWVpbmcgSVJRIHN0b3Jt
IG9uIGdsb2JhbCByZWNlaXZlIElSUSBsaW5lIHVuZGVyIGhlYXZ5IENBTg0KPiBidXMNCj4gPiBs
b2FkIGNvbmRpdGlvbnMgd2l0aCBib3RoIENBTiBjaGFubmVscyBhcmUgZW5hYmxlZC4NCj4gPg0K
PiA+IENvbmRpdGlvbnM6DQo+ID4gICBUaGUgZ2xvYmFsIHJlY2VpdmUgSVJRIGxpbmUgaXMgc2hh
cmVkIGJldHdlZW4gY2FuMCBhbmQgY2FuMSwNCj4gZWl0aGVyDQo+ID4gICBvZiB0aGUgY2hhbm5l
bHMgY2FuIHRyaWdnZXIgaW50ZXJydXB0IHdoaWxlIHRoZSBvdGhlciBjaGFubmVsIGlycQ0KPiA+
ICAgbGluZSBpcyBkaXNhYmxlZChyZmllKS4NCj4gPiAgIFdoZW4gZ2xvYmFsIHJlY2VpdmUgSVJR
IGludGVycnVwdCBvY2N1cnMsIHdlIG1hc2sgdGhlIGludGVycnVwdCBpbg0KPiA+ICAgaXJxaGFu
ZGxlci4gQ2xlYXJpbmcgYW5kIHVubWFza2luZyBvZiB0aGUgaW50ZXJydXB0IGlzIGhhcHBlbmlu
Zw0KPiBpbg0KPiA+ICAgcnhfcG9sbCgpLiBUaGVyZSBpcyBhIHJhY2UgY29uZGl0aW9uIHdoZXJl
IHJ4X3BvbGwgdW5tYXNrIHRoZQ0KPiA+ICAgaW50ZXJydXB0LCBidXQgdGhlIG5leHQgaXJxIGhh
bmRsZXIgZG9lcyBub3QgbWFzayB0aGUgaXJxIGR1ZSB0bw0KPiA+ICAgTkFQSUZfU1RBVEVfTUlT
U0VEIGZsYWcuDQo+IA0KPiBXaHkgZG9lcyB0aGlzIGhhcHBlbj8NCg0KSXQgaXMgZHVlIHRvIHJh
Y2UgYmV0d2VlbiByeF9wb2xsKCkgYW5kIGludGVycnVwdCB0cmlnZ2VyZWQgYnkgb3RoZXINCkNo
YW5uZWwuDQoNCj4gSXMgaXQgYSBwcm9ibGVtIHRoYXQgeW91IGNhbGwNCj4gcmNhcl9jYW5mZF9o
YW5kbGVfZ2xvYmFsX3JlY2VpdmUoKSBmb3IgYSBjaGFubmVsIHRoYXQgaGFzIHRoZSBJUlFzDQo+
IGFjdHVhbGx5IGRpc2FibGVkIGluIGhhcmR3YXJlPw0KDQpZZXMsIER1ZSB0byBvdGhlciBjaGFu
bmVsIHRyaWdnZXJpbmcgaW50ZXJydXB0IGFuZCBleGVjdXRpbmcNCnRoZSBzYW1lIGNhbGwgZm9y
IGNoYW5uZWwwIGFnYWluLiANCg0KU2NlbmFyaW86DQogQ2hhbm5lbDAgSVJRIGxpbmUgaXMgZGlz
YWJsZWQgYmVjYXVzZSBvZiBSWEZpRm8gY2gwIHN0YXR1cyBpbiBJUlENCmFuZCBpdCBzY2hlZHVs
ZSBOQVBJIGNhbGwuIEJlZm9yZSBleGVjdXRpbmcgcnhfcG9sbCwgeW91IGdldCBhbm90aGVyDQpp
bnRlcnJ1cHQgZHVlIHRvIGNoYW5uZWwxIElSUS4gU2luY2UgUlhGaWZvIHN0YXR1cyBpcyBzdGls
bCBzZXQsDQppdCB3aWxsIGNhbGwgbmFwaV9zY2hlZF9wcmVwKCkgYW5kIHN0YXRlIGJlY29tZSBt
aXNzZWQuDQoNCkFzc3VtZSByeF9wb2xsKCkgY2FsbGVkIGl0IGNsZWFyIGFuZCB1bm1hc2sgdGhl
IElSUSBsaW5lLiBUaGlzDQp0aW1lIHdlIGdldCBhbiBJUlEgZnJvbSBDaGFubmVsMCwgc2luY2Ug
dGhlIHN0YXRlIGlzIG1pc3NlZCBzdGF0ZSwNCnRoZSBsaW5lIHdpbGwgYmUgdW5tYXNrZWQgYW5k
IHdlIGdldCBJUlEgc3Rvcm0NCg0KRmluYWxseSwgSXQgd2lsbCBiZSBsaWtlIHRoaXMgeW91IGhh
dmUgYW4gaW50ZXJydXB0LCB3aGljaCBpcyBub3QgY2xlYXJlZA0KTGVhZGluZyB0byBJUlEgc3Rv
cm0uDQoNCkNoZWVycywNCkJpanUNCg0K
