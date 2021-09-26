Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6544418A0B
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 17:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbhIZPvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 11:51:37 -0400
Received: from mail-eopbgr1410122.outbound.protection.outlook.com ([40.107.141.122]:6123
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232060AbhIZPvg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Sep 2021 11:51:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EoWXocA+r0X07xRkbHr4++IANLPhjgx9ou7b+/9/lkDzV8pG6HKCaCnPr70L4lF3rbyZzukQ4Trch1a1HuEdv32VHOkTnfqnt9HntGQwqeCKY7FCRlPUaT0TVLT4xIxEjRzT3agf23ZXvYTiPlxQnLZV2b7zucmyzBZkl4XEABDqWbO6zuuIkz4RbJs68nfMKXn1AQrYKh4OcyWsVNhFI8D3ubn+18h2RePiqSkiu/j3/B5i/hJDhO7mvPb9Ft36IKPVVVX2uvWNwr4cMm3oxKGIw3tIZkz34G8Ca0qc2WWM1nwYX5836hbIOUqyelHTugPsBXYok/KjY38oP/Gwmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=kW0Fe9REWdAi8EFk9EpV2vQG5rs4ulr+uY97R8Nm+f0=;
 b=FtWMiUx+G3x8bBWgTdUmhe4F/C4VKp2v4YnIajMZNWc8NBVHAVWeWOKy80NRWJhH8C4XAvyjDdC299RdwyyktBkHwG7kTyfexRQN9ObbFYidZqDYmjwYnhf9+CG0OD0wNisqPEjyf1t69/w20q47q8Q8J4nnTNKKV/HS4pdPH/CRKGUhsncwZn7aj2Idck9nBUrzVc96gUuMHcge3ZUDMzrKjJwcy7Q0YtxJh9TIRYH50Jxo63thNdDGk1X0WQLNnopDhdA88kwjacbUJiggUudoPHszSCNQf4XeWy7wkPuDn9v0npPMxhxGI/DS2xMOWbm2Dxg9PxwDY8IfkGA3kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kW0Fe9REWdAi8EFk9EpV2vQG5rs4ulr+uY97R8Nm+f0=;
 b=AQkEQMJlUSmvhS1je8mbJaP3KtK5w5UALvYpvfm9Q6VEaPyMDOm2ia72rRHlnMOTWBNe4pvVz1ZixSgU0rNGy+dCRWBlt8ZL1rNIN3wNaCXmu8xihvqDZT/bKMlO3uh1dkEvXz2IND9eAcLABK30AngAaVJkX08pjCnIV2mxI1s=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB2097.jpnprd01.prod.outlook.com (2603:1096:603:1a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Sun, 26 Sep
 2021 15:49:58 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::8f9:8388:6090:4262]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::8f9:8388:6090:4262%7]) with mapi id 15.20.4544.021; Sun, 26 Sep 2021
 15:49:58 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [RFC/PATCH 08/18] ravb: Add mii_rgmii_selection to struct
 ravb_hw_info
Thread-Topic: [RFC/PATCH 08/18] ravb: Add mii_rgmii_selection to struct
 ravb_hw_info
Thread-Index: AQHXsISIl1AnQ6pYVE2T9rLaXIqMK6uzmXAAgACvnGCAAjHa8A==
Date:   Sun, 26 Sep 2021 15:49:57 +0000
Message-ID: <OS0PR01MB5922F0CD1758CD3E9EF080E586A69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-9-biju.das.jz@bp.renesas.com>
 <8b92e5f8-2f78-b64c-8356-1e43034ba622@omp.ru>
 <OS0PR01MB5922C9EDAE62B0750D84354A86A59@OS0PR01MB5922.jpnprd01.prod.outlook.com>
In-Reply-To: <OS0PR01MB5922C9EDAE62B0750D84354A86A59@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: bp.renesas.com; dkim=none (message not signed)
 header.d=none;bp.renesas.com; dmarc=none action=none
 header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b120272-5efc-49fe-518f-08d981054ad8
x-ms-traffictypediagnostic: OSAPR01MB2097:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB2097ECE0C283F2B9259969E886A69@OSAPR01MB2097.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PiK9LHC9mRws5EBdBLNfGHsVnhtuW8kNgzAub5m28MXzuRpjuoR0UkkB8V0gfrWjdAI0jlHa0SZryuucHI0hTjMz3fhvi9jrjEdrnVsh38Eoavdp0Ta03DmTz2joByptuE8VUqGYSKnBmmmMMOpoyDt1uZuGafniIXnR2RWxpOmoBXCAjWK1Gv98XWDzF5cELqhQnIOlepVKTy1MIbFyjxHAfbnkJefP9KvSyl9AU0mX5Ix2rund/n5BkxarQutYo+daqhFR/+URDBREvMfz3yJchHhpRpMrOFgh6T5P+nyZqe7R65YOsxwkuXWZdeavSoJaCoDxqZw1zoN1nj/h+eFuBtOpnWxtHsYQwgavTZ3I/FBORax+FakcaZXKe/mdOnL6e5q8Nx4XpxIuBYLFAxQsuqP4BeDUsj27gEL4KpqrSy2E0S/gU/kMJ+VaslLUqAZofzjdquHNNkvu9QRbyMT2qBT3lpRZlF8lrzS6fCKL+1b2vd82edtGE7qrQWyZvJGau4zPt01XrskNwPlHIHhC1zIXmM4e4pI4e4P3WhjuJt0vyQspzMyphXbDl4VmbovC2Qm4qO4SMjXw7KuDntSOi7znm+Yh0NvfamPOQcuyzC03TUIdkefO+U1ol8QkLAXGv2Fgbs6L2Gscrf2BLYCoAeSXtQQd7AAbhb6j6RPGik/ICDaucYuSgP0YqZ3TAmpfYXTZSpc4NqHh6xIm8w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52536014)(4326008)(508600001)(33656002)(2906002)(71200400001)(5660300002)(38070700005)(6506007)(8676002)(107886003)(316002)(38100700002)(186003)(76116006)(26005)(8936002)(66946007)(9686003)(53546011)(86362001)(66476007)(64756008)(66446008)(7696005)(122000001)(66556008)(55016002)(54906003)(110136005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b3dLbzNGSWpwYnRKakl3SWpmWkVucUxrZzgyUmprS3lEU3hodnh6NGlDVEpn?=
 =?utf-8?B?YVJub0NGQnBjOWFQb2J5aHkvT0VkbkpOQzN1STFDMzJ3eG93UG9MV1Z0OG13?=
 =?utf-8?B?ekJhQzdXcmowOHFqa1RWMTNMVTJiWUVxVGtHdTdoN3JWejl3NXZtalJzb3lQ?=
 =?utf-8?B?WkZuMG1INm9uWXNtUEdPb2dnYlBjaWV2QzJqMUhsUCtjek4vQmN6QmRCVHZ2?=
 =?utf-8?B?cjJ3RFkwRTlnMDJrRkdiOUNJRXlSZ1Btb2FhbkhDbDc5b29qZFV4WmZrTWl4?=
 =?utf-8?B?MEJVUnUxSGduV3dXeitsckF3VmFsMmQwZFhWckNFalg5KytPV1c4d0VQZWp5?=
 =?utf-8?B?ZHhoRTFHZ2o4VmZmOTh5S2w0a0dybkcwdUh5QkhWc2wybkFucXc1NS8wbzd6?=
 =?utf-8?B?ck1nNjRFcnBzMTloUHdqVzJUc1lZaW4vRkhObnBvRm5Pck5JMzVMVXVncnk4?=
 =?utf-8?B?U3lMa2ZQRUZhbTVwR0NKakhORWhmZlQwZGExbUtJWkh6SEFqQUp4TDNVdlp6?=
 =?utf-8?B?cVpzdUYyV1UyS09xd0EySVl4UGVGVXZoUXQwc1FsQWk4VVV6SzJibHNVN2E2?=
 =?utf-8?B?VEdVUzBDa1ova2VMbGttaXkrVHRBditWOVlmYThlekUxb2RHOEZFOXMxcVdI?=
 =?utf-8?B?TUR6ZStHSTBONEpvY2FGT0RERUEraVU4Lysyd3FLSmo5OVZjakY0UEpFTTlz?=
 =?utf-8?B?TExoNjlDaS82WXhSUFFZZ3pRcHRVM1lUMTZyUUVSSC93ejZBRVFSL2NsbWRI?=
 =?utf-8?B?SkJxNDc1V1UyakkyTUVzcCt3ZzMzZmZyT09KMU9NZ01oVktDS29jcGR2T2Fy?=
 =?utf-8?B?aUw3UjIrV3RYZUZqd1h4Vk9TWWRTV3hwSzlDY2p2elJyU2lIbHEwWWpDZjNn?=
 =?utf-8?B?bER5ZDl2NEcxQWdKMlVsMVBsd2lCYVNKd081bWRvVlZwRTNOalVDSGU4WVJ2?=
 =?utf-8?B?T1lsaVcxRFFycm5ta0E4ME5nUkZmb2xOS0tzRU1STmFkdS8rS0d0YzBwT04w?=
 =?utf-8?B?Uzc2WTZPODZ3eDRzOERFUDREbHlNeHBpU01Sd2xuSGZjUVJyajRqTlc1VEM4?=
 =?utf-8?B?bXZTQVdqZDRWbTNlUUV4Rjd6ZkFqZlUxdW1wcUQ3V2t1NGdJOGNwUXJFT1Nh?=
 =?utf-8?B?eW5YSDE2THUraFZiM1I3RVgxbjE1bUEzTmw5dlRNQU1ldUVJQlJKbEdpSGMw?=
 =?utf-8?B?S0NaUXhLVWZPcU5BNUd0cENlL3BSQ1lxZ3hFRHZsKzFlbzYwZ3ZGRzQ4eGdq?=
 =?utf-8?B?WURXVG5vSUltMUdVR3AwZGRyTUh1c29sbXZrQno3cFpSM08zWDB2S2ROdzcx?=
 =?utf-8?B?YjFjNGp5bGl2U0dITkh2ZDBxeHh0Y2p4WGJBb01VcklHYW9IdUp6UXBtRzV4?=
 =?utf-8?B?STJZVkxzVDhnSHh1cXc0cDZkZlZDZW9JN2VCVDE0Z3JOQUVkUHMvOE52WE1z?=
 =?utf-8?B?ZWRaMlR1UnNhSHRab2s5UnRhUlpHWDlNck1Qcklnc283NE9zWjlRWElJRTFq?=
 =?utf-8?B?eUh0b0ZHV3lQN0hKd1UyckNYcmR5YjhIOWQyOGkvdnlVTVBCT3R4MzhoZUFj?=
 =?utf-8?B?WTV2RTZhUHB0ZVh5RGNNR2I3cWM3V1UxVkpibHVGUUMybXphSlVqOXlnWjVx?=
 =?utf-8?B?TUYxOWFIL1c3azFtNVZ5ZjlGY0hlR2ZOUWVKeVRDN1o1K0RQUVhGU25YWkNW?=
 =?utf-8?B?Y0oydTNHRjJHV3dNRFRQVU5iN3h1NGRsdCsyU3RRclM3c3Jnd3RDU0hDZkhD?=
 =?utf-8?Q?yNH9Vvw0szS4va/xj/smHV4zOYyrVultu/7rG5n?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b120272-5efc-49fe-518f-08d981054ad8
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2021 15:49:57.8284
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: En+/cLX/V54IubGKXzE9wiZFv4LiCKAjblZa1qlgetHSZmZmJRvHQXl9iBK183yWP3GzhgBqkAd8XSMJ84sgEWsPtIVUkQwOfbniOFrZMTQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB2097
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQo+IFN1YmplY3Q6IFJFOiBbUkZDL1BBVENIIDA4LzE4XSByYXZiOiBBZGQg
bWlpX3JnbWlpX3NlbGVjdGlvbiB0byBzdHJ1Y3QNCj4gcmF2Yl9od19pbmZvDQo+IA0KPiBIaSBT
ZXJnZWksDQo+IA0KPiBUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCj4gDQo+ID4gU3ViamVjdDog
UmU6IFtSRkMvUEFUQ0ggMDgvMThdIHJhdmI6IEFkZCBtaWlfcmdtaWlfc2VsZWN0aW9uIHRvIHN0
cnVjdA0KPiA+IHJhdmJfaHdfaW5mbw0KPiA+DQo+ID4gT24gOS8yMy8yMSA1OjA4IFBNLCBCaWp1
IERhcyB3cm90ZToNCj4gPg0KPiA+ID4gRS1NQUMgb24gUlovRzJMIHN1cHBvcnRzIE1JSS9SR01J
SSBzZWxlY3Rpb24uIEFkZCBhDQo+ID4gPiBtaWlfcmdtaWlfc2VsZWN0aW9uIGZlYXR1cmUgYml0
IHRvIHN0cnVjdCByYXZiX2h3X2luZm8gdG8gc3VwcG9ydA0KPiA+ID4gdGhpcyBmb3IgUlovRzJM
Lg0KPiA+ID4gQ3VycmVudGx5IG9ubHkgc2VsZWN0aW5nIFJHTUlJIGlzIHN1cHBvcnRlZC4NCj4g
PiA+DQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNh
cy5jb20+DQo+ID4gPiAtLS0NCj4gPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3Jh
dmIuaCAgICAgIHwgMTcgKysrKysrKysrKysrKysrKysNCj4gPiA+ICBkcml2ZXJzL25ldC9ldGhl
cm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jIHwgIDYgKysrKysrDQo+ID4gPiAgMiBmaWxlcyBjaGFu
Z2VkLCAyMyBpbnNlcnRpb25zKCspDQo+ID4gPg0KPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L3JlbmVzYXMvcmF2Yi5oDQo+ID4gPiBpbmRleCBiY2U0ODBmYWRiOTEuLmRmYWYzMTIxZGE0NCAx
MDA2NDQNCj4gPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+
ID4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+IFsuLi5d
DQo+ID4gPiBAQCAtOTUxLDYgKzk1MywyMCBAQCBlbnVtIFJBVkJfUVVFVUUgew0KPiA+ID4gIAlS
QVZCX05DLAkvKiBOZXR3b3JrIENvbnRyb2wgUXVldWUgKi8NCj4gPiA+ICB9Ow0KPiA+ID4NCj4g
PiA+ICtlbnVtIENYUjMxX0JJVCB7DQo+ID4gPiArCUNYUjMxX1NFTF9MSU5LMAk9IDB4MDAwMDAw
MDEsDQo+ID4gPiArCUNYUjMxX1NFTF9MSU5LMQk9IDB4MDAwMDAwMDgsDQo+ID4gPiArfTsNCj4g
PiA+ICsNCj4gPiA+ICtlbnVtIENYUjM1X0JJVCB7DQo+ID4gPiArCUNYUjM1X1NFTF9NT0RJTgk9
IDB4MDAwMDAxMDAsDQo+ID4gPiArfTsNCj4gPiA+ICsNCj4gPiA+ICtlbnVtIENTUjBfQklUIHsN
Cj4gPiA+ICsJQ1NSMF9UUEUJPSAweDAwMDAwMDEwLA0KPiA+ID4gKwlDU1IwX1JQRQk9IDB4MDAw
MDAwMjAsDQo+ID4gPiArfTsNCj4gPg0KPiA+ICAgIEkgZG9uJ3Qgc2VlIHRob3NlIHVzZWQ/IFdo
YXQgaXMgQ1NSMD8NCj4gDQo+IE9LLCBUaGlzIGhhcyB0byBiZSBwYXJ0IG9mIGxhdGVyIHBhdGNo
IGZvciBlbWFjX2luaXQuIENTUiBpcyBjaGVja3N1bQ0KPiBvcGVyYXRpbmcgbW9kZSByZWdpc3Rl
ciBpbiBUT0UuDQo+IA0KPiA+DQo+ID4gWy4uLl0NCj4gPiA+IEBAIC0xMDA4LDYgKzEwMjQsNyBA
QCBzdHJ1Y3QgcmF2Yl9od19pbmZvIHsNCj4gPiA+ICAJdW5zaWduZWQgY2NjX2dhYzoxOwkJLyog
QVZCLURNQUMgaGFzIGdQVFAgc3VwcG9ydCBhY3RpdmUgaW4NCj4gPiBjb25maWcgbW9kZSAqLw0K
PiA+ID4gIAl1bnNpZ25lZCBtdWx0aV90c3JxOjE7CQkvKiBBVkItRE1BQyBoYXMgTVVMVEkgVFNS
USAqLw0KPiA+ID4gIAl1bnNpZ25lZCBtYWdpY19wa3Q6MTsJCS8qIEUtTUFDIHN1cHBvcnRzIG1h
Z2ljIHBhY2tldA0KPiA+IGRldGVjdGlvbiAqLw0KPiA+ID4gKwl1bnNpZ25lZCBtaWlfcmdtaWlf
c2VsZWN0aW9uOjE7CS8qIEUtTUFDIHN1cHBvcnRzIG1paS9yZ21paQ0KPiA+IHNlbGVjdGlvbiAq
Lw0KPiA+DQo+ID4gICAgUGVyaGFwcyBqdXN0ICdtaWlfcmdtaWlfc2VsJz8NCj4gT0suDQo+IA0K
PiA+DQo+ID4gWy4uLl0NCj4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9y
ZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMv
cmF2Yl9tYWluLmMNCj4gPiA+IGluZGV4IDUyOTM2NGQ4ZjdmYi4uNWQxODY4MTU4MmI5IDEwMDY0
NA0KPiA+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0K
PiA+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+
IFsuLi5dDQo+ID4gPiBAQCAtMTE3Myw2ICsxMTc0LDEwIEBAIHN0YXRpYyBpbnQgcmF2Yl9waHlf
aW5pdChzdHJ1Y3QgbmV0X2RldmljZQ0KPiAqbmRldikNCj4gPiA+ICAJCW5ldGRldl9pbmZvKG5k
ZXYsICJsaW1pdGVkIFBIWSB0byAxMDBNYml0L3NcbiIpOw0KPiA+ID4gIAl9DQo+ID4gPg0KPiA+
ID4gKwlpZiAoaW5mby0+bWlpX3JnbWlpX3NlbGVjdGlvbiAmJg0KPiA+ID4gKwkgICAgcHJpdi0+
cGh5X2ludGVyZmFjZSA9PSBQSFlfSU5URVJGQUNFX01PREVfUkdNSUlfSUQpDQo+ID4NCj4gPiAg
ICBOb3QgTUlJPw0KPiANCj4gQ3VycmVudGx5IG9ubHkgUkdNSUkgc3VwcG9ydGVkLCBzZWUgdGhl
IGNvbW1pdCBtZXNzYWdlLg0KPiA+DQo+ID4gPiArCQlyYXZiX3dyaXRlKG5kZXYsIHJhdmJfcmVh
ZChuZGV2LCBDWFIzNSkgfCBDWFIzNV9TRUxfTU9ESU4sDQo+ID4gQ1hSMzUpOw0KPiA+DQo+ID4g
ICAgV2UgaGF2ZSByYXZiX21ub2RpZnkoKSBmb3IgdGhhdC4uLg0KPiA+DQo+ID4gPiArDQo+ID4g
PiAgCS8qIDEwQkFTRSwgUGF1c2UgYW5kIEFzeW0gUGF1c2UgaXMgbm90IHN1cHBvcnRlZCAqLw0K
PiA+ID4gIAlwaHlfcmVtb3ZlX2xpbmtfbW9kZShwaHlkZXYsIEVUSFRPT0xfTElOS19NT0RFXzEw
YmFzZVRfSGFsZl9CSVQpOw0KPiA+ID4gIAlwaHlfcmVtb3ZlX2xpbmtfbW9kZShwaHlkZXYsIEVU
SFRPT0xfTElOS19NT0RFXzEwYmFzZVRfRnVsbF9CSVQpOw0KPiA+ID4gQEAgLTIxMzIsNiArMjEz
Nyw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgcmF2Yl9od19pbmZvIHJnZXRoX2h3X2luZm8gPQ0K
PiB7DQo+ID4gPiAgCS5hbGlnbmVkX3R4ID0gMSwNCj4gPiA+ICAJLnR4X2NvdW50ZXJzID0gMSwN
Cj4gPiA+ICAJLm5vX2dwdHAgPSAxLA0KPiA+ID4gKwkubWlpX3JnbWlpX3NlbGVjdGlvbiA9IDEs
DQo+ID4NCj4gPiAgICBJIGRvbid0IHNlZSB3aGVyZSB3ZSBoYW5kbGUgTUlJPw0KPiANCj4gU2Vl
IHRoZSBjb21taXQgbWVzc2FnZS4gIkN1cnJlbnRseSBvbmx5IHNlbGVjdGluZyBSR01JSSBpcyBz
dXBwb3J0ZWQuIg0KPiBXZSBoYXZlIGEgcGxhbiB0byBzdXBwb3J0IHRoaXMgYXQgbGF0ZXIuDQo+
IA0KDQpJIGhhdmUgcHJlcGFyZWQgYSBwYXRjaCB3aXRoICJtaWlfcmdtaWlfc2VsIiwgd2lsbCBz
ZW5kIG5leHQgcmV2aXNpb24gc29vbi4NCg0KUmVnYXJkcywNCkJpanUNCg0KDQo=
