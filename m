Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C8D42ACA8
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 20:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbhJLS5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 14:57:25 -0400
Received: from mail-eopbgr1410092.outbound.protection.outlook.com ([40.107.141.92]:6069
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230427AbhJLS5Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 14:57:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kAEc3FOXZvEshmTgfDb+JotEF3x7p1uqZZVDp7dYG2M54X9YBv4a5L82TtzyToO017S8LGNNUdvRhz+DSmvBAIqKSkVM/RbFvtgaWOmeA3y1QFiwGoc7QiIlzkTHVFVJ/ir4oy8dsL9IW7c2QrP0ONZJeeheKMYNU9LXAoVB0aEm8/qKHe08Y2RQpd7uQWdL2QUJBBstdMgFEr8ArfZyE1tBtN5Kpcj15NXIpbOOqy7k3dSdSMlcxviBNZ9LBBIzPldBOWHyIYUu+VQDiZjy4H+ZWnXiViUIZGBLMXyV0dwK3tA+plZNrhOtjUi5KR1sI9vExNZgV7w27PDSeieNEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GqIjRSOKqPC8W2lp20OlZ7OabwOvijXTQGLGIf+Brnw=;
 b=YjBNWdJCB/q33g7ZHPtyzPo7jjAc6QmDMR+bt3XKSE2JHkIbSjU2djrXyiKpAVdkwF0/Vf+OpbvSpw/qEET0CwA5jUQ+NXndaFoDpqJzdDj8jrVNIQXj2YtOHI5tN4euUBzxJXIUN7YlavZt+z8RjYYpcM3P1IFrGZIljSes2M8SedlwD1JOYCO5ZHdHhRa4hw3RwglJ1y9k4bca12rW67zgWR1hi49mfknk5CiZ7j0+i5lBlJH8IYLWxDxSjRf1p9VxkS1XRulqraUHwCppSSsY+jHuashp5Z/E/eLoxU6lSyczC934tv7GOzhFxHQWyqd8OlZ85sIoGxc69/biUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GqIjRSOKqPC8W2lp20OlZ7OabwOvijXTQGLGIf+Brnw=;
 b=lf0ZXMwIBMH1rZ+y/Y3+yvjHGIceIBqmbaQl8Dl7bJpiO5P4g0DCG7aUKerCdRrOrAnFDEqjWUpww5bgwKQKl26MLf9Z1rqzrV134oWQXYGdz12DQ2lRoO9/8vmkH7vNicZ+kDlWBddwG/DyKVLnv8dw61cnhcXg+jDdaX/5KVY=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB4344.jpnprd01.prod.outlook.com (2603:1096:604:7f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Tue, 12 Oct
 2021 18:55:18 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 18:55:18 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
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
Subject: RE: [PATCH net-next v3 13/14] ravb: Update ravb_emac_init_gbeth()
Thread-Topic: [PATCH net-next v3 13/14] ravb: Update ravb_emac_init_gbeth()
Thread-Index: AQHXv4dnnKNAfP5bNkuTvIq9GdANz6vPn6iAgAAEiTCAAAONgIAABUnQgAABDQCAAAIh4A==
Date:   Tue, 12 Oct 2021 18:55:18 +0000
Message-ID: <OS0PR01MB592259FBB622ECABF6ED250486B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211012163613.30030-1-biju.das.jz@bp.renesas.com>
 <20211012163613.30030-14-biju.das.jz@bp.renesas.com>
 <b06ad74a-5ecd-8dbf-4b54-fc18ce679053@omp.ru>
 <OS0PR01MB59220334F9C1891BE848638D86B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <dd98fb58-5cd7-94d6-14d6-cc013164d047@gmail.com>
 <OS0PR01MB59223759B5B15858E394461086B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <8b261e85-4aa3-3d58-906d-4da931057e96@gmail.com>
In-Reply-To: <8b261e85-4aa3-3d58-906d-4da931057e96@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: de169239-5e79-483d-d9b4-08d98db1d5d8
x-ms-traffictypediagnostic: OSBPR01MB4344:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB4344A826293447320E4D3ECC86B69@OSBPR01MB4344.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xg3FJaLSR0zb1ah0HAFhWGWtCFoyffUhRZOogVbFbX3lM/7ipaQQqq78ki7MMFxFuUBniWsdFhR0gCob/AgB4dQrHUlPMTHxawjz3nJu//X7po3MMQbNAnqo+1oxcUBy/6yEZkRLpxeO+ycwszPoLngJGLmI8bzFJtPE7czq/dDYfAHXlVaVz1s18xjYmZJlv0+LLvpV5vmN3CXz1F74h49zWIFdmwWxGpX3JCTX6jW3fMgwwQAMw9CB7U687k/gGyiokpiXGvEeorG0Qtf0vp+aJ0gHPBc8P/JK4qgdZUU31UKlW7sKYhiJLkrFROJ1ZbT2KeovtCV+pFte3Ymr37sUgZUvXmu/dQzzYPpBGEEdKYGisvlguYRmmmrIrYiboxvQAzgxNLMyoM56zur2m9NK2aTC9gRaPt84s0MUECCD9Vks+Wjo5kwgxENiIPovRkAEaQ5A+w1l2/nAFJTT8Qj1cwRCf/8+LW6d4Wa+PsjCZbU3vtm5lbLLu8IBbKT/5SX0bcqOFH1WtKeQ5qkXaqxuX1AKXDIqBF8I7RS7pujmHkmUexast0IhnFphy+2T2PwMwJc+/Alrh3V31w1Gvp/D7Bpny5RPs30nxOChw/APZXX2kBFNNbfs9z4XrF0/NeGRdI5RYyDh3dUW1IsKyyF7rkavg4WoUwiKHHKKWkwXjMAqJnDH9B5qwjYguwzm42/Bpc90R3C7uyU5MQRfXg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(86362001)(7416002)(15650500001)(7696005)(110136005)(64756008)(66556008)(38100700002)(83380400001)(66446008)(38070700005)(508600001)(66946007)(122000001)(54906003)(186003)(5660300002)(71200400001)(107886003)(8936002)(316002)(2906002)(33656002)(9686003)(6506007)(26005)(53546011)(52536014)(76116006)(8676002)(55016002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a3Q3NTlQUHdVUHFhNU1wSFp0YnJCTzBNRUIzbnM5ZC80R2EwdkduVGRPdWpa?=
 =?utf-8?B?SE90ak80bk1kazh3NXcxaXV2SnRoWlRwVW1udVYvM0MzKzNnVWVnRmkyOWIw?=
 =?utf-8?B?NXpOL0hJWlRyZ2JtcjRzdlZsUmxWemZHV0pGTkFJclJpVlR1RkRpVGZMaEta?=
 =?utf-8?B?S1dGVTNsSGM2SW1NcjZTUUhDeXcrNWYvZHBnWUV4dUM1VXRHWlFIMnpVRll1?=
 =?utf-8?B?TUpLVlg4MEgxdEJZMUZSb25kZ1JIdHdVaEhCRVhzSkp5c05MdWFMa09FMThy?=
 =?utf-8?B?WGhKVzdCeVpKT1pRdGN2dHh5bXVRZ0VyMFpBcTZvb1NKYTN6SXdZMUJydEp4?=
 =?utf-8?B?OEdQaGUxRGt3WVhRK1ByVWZKa3ZBQkZaMXJWdmhrcjJ3aUJIVldBZmM2dWtM?=
 =?utf-8?B?akVNemduN0ZGaFpDQ1dPS29HSThlR3g1RlBVanhLcEM4T1hIaHArUlNsemdz?=
 =?utf-8?B?a1VzM21nY1ZNMkJJcjArbi90Zjd0R1ZoYjdNSmRlZ2xJWGJiZUlHd0ZkK294?=
 =?utf-8?B?UXVtTjFDbWZDdnFBTVVPei9LaFBXWXFRUlZ3bHhSRkYxMVNFQzloSTBDQlJm?=
 =?utf-8?B?a25KclI3UEZtaHp0eldqRHVRUk9seWJpNWV5Yy9CRDYxV3psMm8wUHFCRE9y?=
 =?utf-8?B?aTVIVi9MTW55Z1FMZmxMeTR0UGZRUmRWTjJkd0ZGS0R6OC9rUmNmbVNZOG9J?=
 =?utf-8?B?UUlmbC94eGY1bTJzN1BnV2I4cDRKTXRXYzJYTktZaW96TnZkdlF4V0VrdTJ6?=
 =?utf-8?B?eWtrbW1IdHJaR3J3UzFNQVJOODZ3NUEvYU96aHc3TTZSYzB5THR2Q1ZYa29M?=
 =?utf-8?B?bnpVRVFsbmgzUCtoc3JXeE5PaGwxRnlINGpVdnlLQjE4cHlZc0JyUWFzelRx?=
 =?utf-8?B?VlRscCs5TW5hWGRkSElXVVVFL2lKQkx2NVFqYVJxK3ZCRlAwSnc1SDZRYTZt?=
 =?utf-8?B?Nml3TGljTzdXZVViTG9RYzhGaFJvOUFzR3ZWclhjRVhBSVpSZWMxNkxxWkRY?=
 =?utf-8?B?Q1ZKWFNJRitrelAyclpDbEIwY2hxNG55NmVIc3BnSUw4NzJERk1QR2ZCV1Zw?=
 =?utf-8?B?by9kNmtxMlR1RXM2SzZHWXVEKzhpZ0JSaG1ycHUxRStOVkRVUGx6L1FkUEEz?=
 =?utf-8?B?dW9vR2xOV2dualpyWFpNUG5UWTVHOEFQY3ZWQkhjSDJoMVI2NHVlbzUvU3lL?=
 =?utf-8?B?OHVFcVgzSDA3OHZKelZNeE96TVVybDZQZk5wUjE2eEh1OTdCOG5ZWnpoUG91?=
 =?utf-8?B?Z3dENzlnd250TGl0U20vL1B5RkhES25OS0RIUXVoWjhrbFl5R3lQREN0V3po?=
 =?utf-8?B?ZW15RzI0TDNPTUp1QlBJekQwemxuNTBSWkdVVEpvSU5ob21LN2VLaXp3S2tu?=
 =?utf-8?B?Y3ZwSnN3Rk42RGYxNXZoMFRZN0VTMU1rallaTitodVJrU3pUVkhEM3dQSmdm?=
 =?utf-8?B?VWt4WnNrUzM4L0VkeUVwVURnNGhvWm5GVDV5WWtHemJBVklwQ2w2cVhoTVp2?=
 =?utf-8?B?UGNEQ0c3enJlYlRXTE1hbytZTDdEcGRyUE9qcUkwTEp4dXp2dXR2T3p6OW9k?=
 =?utf-8?B?eTlrbndMUkw0OGR3dEhJTFA1SHpDSGQvZ0hWMVRSRHJkTWlEbEhIR3N2VDZS?=
 =?utf-8?B?YmZmcFQ2MzduS25UU3FuMHpBQWVlVXlydUZjdlNheU5GNHY2VzBkem1qV1pa?=
 =?utf-8?B?L0s2L1JBUEF6MUVHSnV5YkRBOFcycGFJOG12UDJnd09qUlZ6OHpJcExMSGNL?=
 =?utf-8?Q?5DgbK5xDkaeedCLRKs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de169239-5e79-483d-d9b4-08d98db1d5d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2021 18:55:18.3852
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /eHib8e02rpBv6qUmlDR/pv/iq9x6PRINqSQO9dCb+SXpREwkgbyAMrWuSocJF+09/Ll/nAV7Kx8g09WtDwvDaHlqdTLt82tvCNdKNxqvGY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB4344
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIG5ldC1uZXh0IHYzIDEzLzE0XSByYXZiOiBVcGRhdGUgcmF2Yl9lbWFjX2luaXRfZ2Jl
dGgoKQ0KPiANCj4gT24gMTAvMTIvMjEgOToyMyBQTSwgQmlqdSBEYXMgd3JvdGU6DQo+IA0KPiA+
Pj4+PiBUaGlzIHBhdGNoIGVuYWJsZXMgUmVjZWl2ZS9UcmFuc21pdCBwb3J0IG9mIFRPRSBhbmQg
cmVtb3ZlcyB0aGUNCj4gPj4+Pj4gc2V0dGluZyBvZiBwcm9taXNjdW91cyBiaXQgZnJvbSBFTUFD
IGNvbmZpZ3VyYXRpb24gbW9kZSByZWdpc3Rlci4NCj4gPj4+Pj4NCj4gPj4+Pj4gVGhpcyBwYXRj
aCBhbHNvIHVwZGF0ZSBFTUFDIGNvbmZpZ3VyYXRpb24gbW9kZSBjb21tZW50IGZyb20gIlBBVVNF
DQo+ID4+Pj4+IHByb2hpYml0aW9uIiB0byAiRU1BQyBNb2RlOiBQQVVTRSBwcm9oaWJpdGlvbjsg
RHVwbGV4OyBUWDsgUlg7IENSQw0KPiA+Pj4+PiBQYXNzIFRocm91Z2giLg0KPiA+Pj4+DQo+ID4+
Pj4gICAgSSdtIG5vdCBzdXJlIHdoeSB5b3Ugc2V0IEVDTVIuUkNQVCB3aGlsZSB5b3UgZG9uJ3Qg
aGF2ZSB0aGUNCj4gPj4+PiBjaGVja3N1bSBvZmZsb2FkZWQuLi4NCj4gPj4+Pg0KPiA+Pj4+PiBT
aWduZWQtb2ZmLWJ5OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+ID4+
Pj4+IC0tLQ0KPiA+Pj4+PiB2Mi0+djM6DQo+ID4+Pj4+ICAqIEVuYWJsZWQgVFBFL1JQRSBvZiBU
T0UsIGFzIGRpc2FibGluZyBjYXVzZXMgbG9vcGJhY2sgdGVzdCB0bw0KPiA+Pj4+PiBmYWlsDQo+
ID4+Pj4+ICAqIERvY3VtZW50ZWQgQ1NSMCByZWdpc3RlciBiaXRzDQo+ID4+Pj4+ICAqIFJlbW92
ZWQgUFJNIHNldHRpbmcgZnJvbSBFTUFDIGNvbmZpZ3VyYXRpb24gbW9kZQ0KPiA+Pj4+PiAgKiBV
cGRhdGVkIEVNQUMgY29uZmlndXJhdGlvbiBtb2RlLg0KPiA+Pj4+PiB2MS0+djI6DQo+ID4+Pj4+
ICAqIE5vIGNoYW5nZQ0KPiA+Pj4+PiBWMToNCj4gPj4+Pj4gICogTmV3IHBhdGNoLg0KPiA+Pj4+
PiAtLS0NCj4gPj4+Pj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oICAgICAg
fCA2ICsrKysrKw0KPiA+Pj4+PiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21h
aW4uYyB8IDUgKysrLS0NCj4gPj4+Pj4gIDIgZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCsp
LCAyIGRlbGV0aW9ucygtKQ0KPiA+Pj4+Pg0KPiA+Pj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPj4+Pj4gYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9yZW5lc2FzL3JhdmIuaA0KPiA+Pj4+PiBpbmRleCA2OWE3NzE1MjY3NzYuLjA4MDYyZDczZGYx
MCAxMDA2NDQNCj4gPj4+Pj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZi
LmgNCj4gPj4+Pj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4g
Pj4+Pj4gQEAgLTIwNCw2ICsyMDQsNyBAQCBlbnVtIHJhdmJfcmVnIHsNCj4gPj4+Pj4gIAlUTEZS
Q1IJPSAweDA3NTgsDQo+ID4+Pj4+ICAJUkZDUgk9IDB4MDc2MCwNCj4gPj4+Pj4gIAlNQUZDUgk9
IDB4MDc3OCwNCj4gPj4+Pj4gKwlDU1IwICAgID0gMHgwODAwLAkvKiBSWi9HMkwgb25seSAqLw0K
PiA+Pj4+PiAgfTsNCj4gPj4+Pj4NCj4gPj4+Pj4NCj4gPj4+Pj4gQEAgLTk2NCw2ICs5NjUsMTEg
QEAgZW51bSBDWFIzMV9CSVQgew0KPiA+Pj4+PiAgCUNYUjMxX1NFTF9MSU5LMQk9IDB4MDAwMDAw
MDgsDQo+ID4+Pj4+ICB9Ow0KPiA+Pj4+Pg0KPiA+Pj4+PiArZW51bSBDU1IwX0JJVCB7DQo+ID4+
Pj4+ICsJQ1NSMF9UUEUJPSAweDAwMDAwMDEwLA0KPiA+Pj4+PiArCUNTUjBfUlBFCT0gMHgwMDAw
MDAyMCwNCj4gPj4+Pj4gK307DQo+ID4+Pj4+ICsNCj4gPj4+Pg0KPiA+Pj4+ICAgSXMgdGhpcyBy
ZWFsbHkgbmVlZGVkIGlmIHlvdSBoYXZlIEVDTVIuUkNQVCBjbGVhcmVkPw0KPiA+Pj4NCj4gPj4+
IFllcyBpdCBpcyByZXF1aXJlZC4gUGxlYXNlIHNlZSB0aGUgY3VycmVudCBsb2cgYW5kIGxvZyB3
aXRoIHRoZQ0KPiA+Pj4gY2hhbmdlcyB5b3Ugc3VnZ2VzdGVkDQo+ID4+Pg0KPiA+Pj4gcm9vdEBz
bWFyYy1yemcybDovcnpnMmwtdGVzdC1zY3JpcHRzIyAuL2V0aF90XzAwMS5zaA0KPiA+Pj4gWyAg
IDM5LjY0Njg5MV0gcmF2YiAxMWMyMDAwMC5ldGhlcm5ldCBldGgwOiBMaW5rIGlzIERvd24NCj4g
Pj4+IFsgICAzOS43MTUxMjddIHJhdmIgMTFjMzAwMDAuZXRoZXJuZXQgZXRoMTogTGluayBpcyBE
b3duDQo+ID4+PiBbICAgMzkuODk1NjgwXSBNaWNyb2NoaXAgS1NaOTEzMSBHaWdhYml0IFBIWSAx
MWMyMDAwMC5ldGhlcm5ldC0NCj4gPj4gZmZmZmZmZmY6MDc6IGF0dGFjaGVkIFBIWSBkcml2ZXIg
KG1paV9idXM6cGh5X2FkZHI9MTFjMjAwMDAuZXRoZXJuZXQtDQo+ID4+IGZmZmZmZmZmOjA3LCBp
cnE9UE9MTCkNCj4gPj4+IFsgICAzOS45NjYzNzBdIE1pY3JvY2hpcCBLU1o5MTMxIEdpZ2FiaXQg
UEhZIDExYzMwMDAwLmV0aGVybmV0LQ0KPiA+PiBmZmZmZmZmZjowNzogYXR0YWNoZWQgUEhZIGRy
aXZlciAobWlpX2J1czpwaHlfYWRkcj0xMWMzMDAwMC5ldGhlcm5ldC0NCj4gPj4gZmZmZmZmZmY6
MDcsIGlycT1QT0xMKQ0KPiA+Pj4gWyAgIDQyLjk4ODU3M10gSVB2NjogQUREUkNPTkYoTkVUREVW
X0NIQU5HRSk6IGV0aDA6IGxpbmsgYmVjb21lcyByZWFkeQ0KPiA+Pj4gWyAgIDQyLjk5NTExOV0g
cmF2YiAxMWMyMDAwMC5ldGhlcm5ldCBldGgwOiBMaW5rIGlzIFVwIC0gMUdicHMvRnVsbCAtDQo+
ID4+IGZsb3cgY29udHJvbCBvZmYNCj4gPj4+IFsgICA0My4wNTI1NDFdIElQdjY6IEFERFJDT05G
KE5FVERFVl9DSEFOR0UpOiBldGgxOiBsaW5rIGJlY29tZXMgcmVhZHkNCj4gPj4+IFsgICA0My4w
NTU3MTBdIHJhdmIgMTFjMzAwMDAuZXRoZXJuZXQgZXRoMTogTGluayBpcyBVcCAtIDFHYnBzL0Z1
bGwgLQ0KPiA+PiBmbG93IGNvbnRyb2wgb2ZmDQo+ID4+Pg0KPiA+Pj4gRVhJVHxQQVNTfHxbNDIy
MzkxOjQzOjAwXSB8fA0KPiA+Pj4NCj4gPj4+IHJvb3RAc21hcmMtcnpnMmw6L3J6ZzJsLXRlc3Qt
c2NyaXB0cyMNCj4gPj4+DQo+ID4+Pg0KPiA+Pj4gd2l0aCB0aGUgY2hhbmdlcyB5b3Ugc3VnZ2Vz
dGVkDQo+ID4+PiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4+Pg0KPiA+Pj4gcm9v
dEBzbWFyYy1yemcybDovcnpnMmwtdGVzdC1zY3JpcHRzIyAuL2V0aF90XzAwMS5zaA0KPiA+Pj4g
WyAgIDIzLjMwMDUyMF0gcmF2YiAxMWMyMDAwMC5ldGhlcm5ldCBldGgwOiBMaW5rIGlzIERvd24N
Cj4gPj4+IFsgICAyMy41MzU2MDRdIHJhdmIgMTFjMzAwMDAuZXRoZXJuZXQgZXRoMTogZGV2aWNl
IHdpbGwgYmUgc3RvcHBlZA0KPiBhZnRlcg0KPiA+PiBoL3cgcHJvY2Vzc2VzIGFyZSBkb25lLg0K
PiA+Pj4gWyAgIDIzLjU0NzI2N10gcmF2YiAxMWMzMDAwMC5ldGhlcm5ldCBldGgxOiBMaW5rIGlz
IERvd24NCj4gPj4+IFsgICAyMy44MDI2NjddIE1pY3JvY2hpcCBLU1o5MTMxIEdpZ2FiaXQgUEhZ
IDExYzIwMDAwLmV0aGVybmV0LQ0KPiA+PiBmZmZmZmZmZjowNzogYXR0YWNoZWQgUEhZIGRyaXZl
ciAobWlpX2J1czpwaHlfYWRkcj0xMWMyMDAwMC5ldGhlcm5ldC0NCj4gPj4gZmZmZmZmZmY6MDcs
IGlycT1QT0xMKQ0KPiA+Pj4gWyAgIDI0LjAzMTcxMV0gcmF2YiAxMWMzMDAwMC5ldGhlcm5ldCBl
dGgxOiBmYWlsZWQgdG8gc3dpdGNoIGRldmljZSB0bw0KPiA+PiBjb25maWcgbW9kZQ0KPiA+Pj4g
UlRORVRMSU5LIGFuc3dlcnM6IENvbm5lY3Rpb24gdGltZWQgb3V0DQo+ID4+Pg0KPiA+Pj4gRVhJ
VHxGQUlMfHxbNDIyMzkxOjQyOjMyXSBGYWlsZWQgdG8gYnJpbmcgdXAgRVRIMXx8DQo+ID4+Pg0K
PiA+Pj4gcm9vdEBzbWFyYy1yemcybDovcnpnMmwtdGVzdC1zY3JpcHRzIw0KPiA+Pg0KPiA+PiAg
ICBIbS4uLiA6LS8NCj4gPj4gICAgV2hhdCBpZiB5b3Ugb25seSBjbGVhciBFQ01SLlJDUFQgYnV0
IGNvbnRpbnVlIHRvIHNldCBDU1IwPw0KPiA+DQo+ID4gV2UgYWxyZWFkeSBzZWVuLCBSQ1BUPTAs
IFJDU0M9MSB3aXRoIHNpbWlsYXIgSGFyZHdhcmUgY2hlY2tzdW0NCj4gPiBmdW5jdGlvbiBsaWtl
IFItQ2FyLCBTeXN0ZW0gY3Jhc2hlcy4NCj4gDQo+ICAgIEkgZGlkbid0IHRlbGwgeW91IHRvIHNl
dCBFQ01SLlJDU0MgdGhpcyB0aW1lLiA6LSkNCg0KVGhlb3JldGljYWxseSwgSXQgc2hvdWxkIHdv
cmsgYXMgaXQgaXMuIEFzIHdlIGFyZSBub3QgZG9pbmcgYW55IGhhcmR3YXJlIGNoZWNrc3VtLA0K
DQpIL1cgaXMganVzdCBwYXNzaW5nIFJYIENTVU0gdG8gVE9FIHdpdGhvdXQgYW55IHNvZnR3YXJl
IGludGVydmVudGlvbi4NCg0KSXQgaXMgY2xlYXJseSBtZW50aW9uZWQgaW4gZGF0YSBzaGVldCwg
aXQgaXMgSFcgY29udHJvbGxlZC4NCg0KMjUgUkNQVCBC4oCZMCBSL1cgUmVjZXB0aW9uIENSQyBQ
YXNzIFRocm91Z2gNCjE6IENSQyBvZiByZWNlaXZlZCBmcmFtZSBpcyB0cmFuc2ZlcnJlZCB0byBU
T0UuDQpSQ1NDIChhdXRvIGNhbGN1bGF0aW9uIG9mIGNoZWNrc3VtIG9mIHJlY2VpdmVkIGZyYW1l
IGRhdGEgcGFydCkgZnVuY3Rpb24gaXMgZGlzYWJsZWQNCmF0IHRoaXMgdGltZS4NCjA6IENSQyBv
ZiByZWNlaXZlZCBmcmFtZSBpcyBub3QgdHJhbnNmZXJyZWQgdG8gVE9FLg0KDQpSZWdhcmRzLA0K
QmlqdQ0KDQoNCj4gDQo+ID4gUmVnYXJkcywNCj4gPiBCaWp1DQo+IA0KPiBNQlIsIFNlcmdleQ0K
