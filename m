Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C084B3F4781
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 11:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236102AbhHWJ1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 05:27:51 -0400
Received: from mail-eopbgr1410131.outbound.protection.outlook.com ([40.107.141.131]:6426
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235991AbhHWJ1m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 05:27:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d3Flv6fSGjVxBPxC4qdQB90T1eZoG78dYU+gsH9Gp3yTgWnSWk0whvz8zTlDwfyVRyNnefxhGXwWUeiAlrVrpazBkAqRyEXikHjOusymX3/8cCDbVEdn/r084GFxutCjnO38SdgbXbLFHwbdaZdagfwGsKMr9vCwrC+C1U9zkgJFUPDnJBSGh9NHL3cUGP5WBgJV3+RtFfmldLUQoEavUCTkMl8YJQwoKfPXA1vhZikP+7r4JdsfUXdT+auLO8z+9OziMmPqpAJYlrR/tseoBbOxR12z2imxoArGZVBF9/3U8ppQdGyj/w17q6jBe/lgTGbv3L0RWDQw8M+A+M39bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kt60gxT29iFz9aeec0XxW3NSSELWrge0bCTtWsePgQM=;
 b=H0LBq1h9JKVqeUJxgys44fw6S8csGRz5GHkj08bqjtC5OAyh/tgNSbmi/wrcnkdWKNEOKP9tiUYwdOeeFRzjxXJnBkrf1xVJcMz3txMqzjc7V0NW56uSn1ph82maF4iMC0OnIw6ck3lfeO2W3TZQk9rMpD2rO6DT9Uwx69j3IIOTJq8oyg3DthQfqb7uIaV23zS4HYFiE/fsUiKvGNH8usLsS37lb2qyLmes4uX0VJmw3uV4QJzcu2Am1+HcmbpeX2K6kAD8RoUnasEG/yxVBm6mSayhgaBnHFWfQ3CcIb5giXqiOUG0j1aHECDl+tiRjN9k0p3CPxQHzvLPg/tJXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kt60gxT29iFz9aeec0XxW3NSSELWrge0bCTtWsePgQM=;
 b=silYypzfZA0SZuhmQpeExh8qvhfNRvpzB1Z4TxgC+Av/JAsEIUwgFY9Ay5HZmOC8vXAfVSxXueUZk87FqXnIu0uuZdDldT8yz5NrewhHNs32lVhLmH1AGghnmdMYsGlm4liz9OpBjXBOm93FipGo/vcSPUJU7UZ1Y7eP0HvYQBg=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB3298.jpnprd01.prod.outlook.com (2603:1096:604:5d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Mon, 23 Aug
 2021 09:26:57 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e111:61:43af:3b98]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e111:61:43af:3b98%3]) with mapi id 15.20.4436.024; Mon, 23 Aug 2021
 09:26:57 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [PATCH net-next v3 3/9] ravb: Add aligned_tx to struct
 ravb_hw_info
Thread-Topic: [PATCH net-next v3 3/9] ravb: Add aligned_tx to struct
 ravb_hw_info
Thread-Index: AQHXlGRpmKKQYVGTn0+nR/u7LvubpKuA1biAgAABQ7A=
Date:   Mon, 23 Aug 2021 09:26:56 +0000
Message-ID: <OS0PR01MB5922C2D351667A787AA95F0586C49@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210818190800.20191-1-biju.das.jz@bp.renesas.com>
 <20210818190800.20191-4-biju.das.jz@bp.renesas.com>
 <CAMuHMdUEeZjfJgpXpO6qcAyuGp64wxyxiuLjUosVcRfG8=2s6w@mail.gmail.com>
In-Reply-To: <CAMuHMdUEeZjfJgpXpO6qcAyuGp64wxyxiuLjUosVcRfG8=2s6w@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux-m68k.org; dkim=none (message not signed)
 header.d=none;linux-m68k.org; dmarc=none action=none
 header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 35d2faf0-fed6-41f2-b3d8-08d96618270e
x-ms-traffictypediagnostic: OSAPR01MB3298:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB32987ADEC9664C8CBE86859F86C49@OSAPR01MB3298.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1227;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y2NmMbpfYc20wsvz8lfzljQplwY7LLy06+FkgKuZUFXQZflSZEpmaCyMj64tVWuV764T+ybydw12qJueYyrSDPHt++LCrggMvYbtyaiWH9dUmlkequKHFQ9/8B96Pil6y515c3J+HnTo1edjcJRxcry7JvxFqquKXCC04Fr14G1OFI3dxJ6sxLWhepElEYF4SDupNPKPiHEu4Qnm/gIBXeqUviPQS5KpDxta3hYNTBIvhIkS8ooDf5mmrHSElNQFU1QDEO4ptkfolZZ3IGTEIU9ccbMVEnHFTfjMojXKQOKgV8v4bEyD6Tyon9WK/az+N9xzrCbuYgeLhD00juQ8P5021jfbL3D9NGBauWroq75pQN/Pp+M19BOrFOGU/FjMIf8Uukx43jpXzgNaOabzEimU1GOBQGAZ1wUAGUe/HYHBhWeVJ4lGD8tpiOXrWvKCaCmKbNHyh2GfDHn+gHW04ufS9GI6hNDw0e8oF3dUJM/v1Y5vB6/U9fEzPyPibaeT297yhFkkAgLadTgMIOB8F5p7wOeUJT1xXW2TZsq8fV7MoBLilSswKhKqD8CVaUCO5aYYixltR8CYzChChXAJi/E5O1/N0fLvlMambbMf+f/ai9k+qe2AO8w270Lh3R8HbeW+F8NB2Hp41E8fZtIxWIzGxcICtrqSJqwcgklfoe3VnkPrEPEwRQ1778UZ8qXF1xCAHE+RcAhHJOckfwoius7IJnjW1cnIpOgKox+qbSdmytsgajEZ+7bYvcZkIQgaiOZRv96N1RDRNewyNCojPWAfjrBhq6vthCeG5w8uaxE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(39860400002)(366004)(376002)(2906002)(316002)(66556008)(55016002)(186003)(66476007)(64756008)(8936002)(53546011)(54906003)(6506007)(38100700002)(122000001)(966005)(26005)(7696005)(6916009)(38070700005)(8676002)(107886003)(9686003)(52536014)(4326008)(33656002)(7416002)(5660300002)(76116006)(66446008)(86362001)(66946007)(478600001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MCtjRW9TY0lDOW55WCtja0pJNUZkOXpxZExxY2lMdUlJdG1hd051c09zWit4?=
 =?utf-8?B?K2xoTHlSUGJrUng1dFJMUkRwWG53enowTWNZVUJDdmdGOUpxbUx6WlphWFNW?=
 =?utf-8?B?RmR1cm1hQ1I2WThQRGtYMjRuQTRpVzBsekdZNFNBTHNiR2pOd1NUWmIzWjJB?=
 =?utf-8?B?d3BZSzNTeURWS2c1aWt1cXJwc0NkcWhrVFlLbTRoVFBjazU5VVNJVmdmVHVX?=
 =?utf-8?B?YmNSQjcydVZXcUJKZkRtQ0FXVFpKVVh2cklLR3VSSDlRTGltRXpEVkloTTRm?=
 =?utf-8?B?QStLREozS2tvSUFlbDAzcnZibVpCQ0tjZmcxMjVZdEVuRWIwbGJybkJPdmta?=
 =?utf-8?B?L3h4MlhMSStjODVTcGVsWExwVEdISkpKUTYxYWJHN3QyM2FpcllxMXo0aDBz?=
 =?utf-8?B?TGY2ME50RlVnb2JkN0JLYjZjcFEzckQ1SHpkV3JVOVZaZ3huTHdDRWpKNEFu?=
 =?utf-8?B?MXVDbE94bDlESGFlM1hlVFpwT2FUcWJ6NjRuNXp3WDBIKzFDcDhaQXo2d0pX?=
 =?utf-8?B?YldsWTUxTjdUeUw3RCtiZjRBR0pod2hUaUNoQitwOTVNL2RIS2M5RXFLeTJP?=
 =?utf-8?B?THg0bnpuRjA2S2ZCS0hxZUk4aTByUkRLUlJPcUZheDRLUzVkWHBZSSsrQkdQ?=
 =?utf-8?B?aGxpbUplTnlYODdOOGdSYjhaWHdReWJnNjlSOTNsaUNjUXVkTnJMcUhwQ3d3?=
 =?utf-8?B?RkhxUUpJUkFpb1RyaktMazJERStMcEdMRnFjOWM2MFgrUzJUUllLYjRDV0Jn?=
 =?utf-8?B?bFB3WG45UU1ZcUw0RlNJaDFPSFNia0grN2pFeTVwbEdQNzlEUXIyaFkra0dD?=
 =?utf-8?B?c3hKMVE4dzROVmliMTNVN2hnSnhSYTNBQnFZTUE1b21VSFFFWFUvUjVmQ3pX?=
 =?utf-8?B?SE9LcDg5TE9RN0hjME1qdFVzaDJUV0ZEa0U0S2F5NFkrYkRYR1JsTGJyRVZy?=
 =?utf-8?B?QW9rdWkwa3lRd2ZKdU12NDd1Wk5XOUpwcWRncG1ENURRaEJic3J0MDl2UGk4?=
 =?utf-8?B?MzdIR045djd0YXJOd1kvM3FwdDJyN3h4cm96eWEwY2lyYmFXMUdTT3ZVL05I?=
 =?utf-8?B?MlYyS0g0UDNBVjAyQmVINk1CM2E0c010cFFGZ3lxRUo4VWpLZUZuQmNLZmlr?=
 =?utf-8?B?clhWbjBhejA1WHYwNlRrb2FyeUgwV1AvclpMdlYxUVh1eGRTdm5TMEc1U3Ft?=
 =?utf-8?B?TlpGZmZSY3pHWXEzVGx0VEtpb0lxaHlpTm9LT2JiQmNDOGp6Y3VFSFo3NHlp?=
 =?utf-8?B?R25Ic2RKK25FOVpLTTk0ZnBaVFZUaVZMNE5mV2VxU2c0NGFsY0w1VDBTaEZZ?=
 =?utf-8?B?MFE1QktHcm43Nmx2cUVIWjVuS2pEU0E3M1JYL2l2c2FVNno5dW1jSlhjSVlq?=
 =?utf-8?B?anRmWXd4eG1zVjN6cERzaDJwZUtPZjd1U0FiWXQzS1VxcHhRNnlweUhkUi9p?=
 =?utf-8?B?NmExYWwzSlg3SWROM2Vpcjlld3ZsUHZQZkZ0bG0wRmxWaDVxWUlSR1RxVnRW?=
 =?utf-8?B?UHZvTlEzOHJDZXVocGhJZGFtZEp0bWJrb010K3ZhU2doa21XeFhiVmN6dDNJ?=
 =?utf-8?B?K3c5ZzNPYlVDYU5WNHArLy9OSTZOZ2lWSWlWYnlJR1Z6MHNiNHhrY2VhSEQy?=
 =?utf-8?B?Lzlvc1FxRlhMMTRZdVU4TEVaSko2a1lqTmkydlpVUHNINWoyNkNORldIWEtR?=
 =?utf-8?B?OUJ6V1VkYXo1UTJCWXdNWGVPbW9wTTRZVlphM0FDRldtTUZTd0hDd3ZJUzRp?=
 =?utf-8?Q?Pp4ZjzSciobESDcFJ0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35d2faf0-fed6-41f2-b3d8-08d96618270e
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2021 09:26:56.8287
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pwtL9WaTQpBL4EiTTjYgXNmN7N2QePf35oIXgCupCU6pPcCU6Z40hdDOIf7azA/gqCBLzZWUmS2I9zo6MHNynK72w7JrOp5I3HhehWoMglM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB3298
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgR2VlcnQsDQoNClRoYW5rcyBmb3IgdGhlIGZlZWRiYWNrDQoNCj4gU3ViamVjdDogUmU6IFtQ
QVRDSCBuZXQtbmV4dCB2MyAzLzldIHJhdmI6IEFkZCBhbGlnbmVkX3R4IHRvIHN0cnVjdA0KPiBy
YXZiX2h3X2luZm8NCj4gDQo+IEhpIEJpanUsDQo+IA0KPiBPbiBXZWQsIEF1ZyAxOCwgMjAyMSBh
dCA5OjA4IFBNIEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4gd3JvdGU6
DQo+ID4gUi1DYXIgR2VuMiBuZWVkcyBhIDRieXRlIGFsaWduZWQgYWRkcmVzcyBmb3IgdGhlIHRy
YW5zbWlzc2lvbiBidWZmZXIsDQo+ID4gd2hlcmVhcyBSLUNhciBHZW4zIGRvZXNuJ3QgaGF2ZSBh
bnkgc3VjaCByZXN0cmljdGlvbi4NCj4gPg0KPiA+IEFkZCBhbGlnbmVkX3R4IHRvIHN0cnVjdCBy
YXZiX2h3X2luZm8gdG8gc2VsZWN0IHRoZSBkcml2ZXIgdG8gY2hvb3NlDQo+ID4gYmV0d2VlbiBh
bGlnbmVkIGFuZCB1bmFsaWduZWQgdHggYnVmZmVycy4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6
IEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4gPiBSZXZpZXdlZC1ieTog
TGFkIFByYWJoYWthciA8cHJhYmhha2FyLm1haGFkZXYtbGFkLnJqQGJwLnJlbmVzYXMuY29tPg0K
PiANCj4gVGhhbmtzIGZvciB5b3VyIHBhdGNoLCB3aGljaCBpcyBub3cgY29tbWl0IDY4Y2EzYzky
MzIxM2I5MDggKCJyYXZiOg0KPiBBZGQgYWxpZ25lZF90eCB0byBzdHJ1Y3QgcmF2Yl9od19pbmZv
IikgaW4gbmV0LW5leHQuDQo+IA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVz
YXMvcmF2Yi5oDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgN
Cj4gPiBAQCAtOTkwLDYgKzk5MCw3IEBAIGVudW0gcmF2Yl9jaGlwX2lkIHsNCj4gPg0KPiA+ICBz
dHJ1Y3QgcmF2Yl9od19pbmZvIHsNCj4gPiAgICAgICAgIGVudW0gcmF2Yl9jaGlwX2lkIGNoaXBf
aWQ7DQo+ID4gKyAgICAgICB1bnNpZ25lZCBhbGlnbmVkX3R4OiAxOw0KPiA+ICB9Ow0KPiA+DQo+
ID4gIHN0cnVjdCByYXZiX3ByaXZhdGUgew0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9y
ZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gaW5kZXggYjY1NTRlNWUxM2FmLi5kYmNjZjJjZDg5YjIg
MTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4u
Yw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4g
PiBAQCAtMTkzMCw2ICsxOTMwLDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCByYXZiX2h3X2luZm8N
Cj4gPiByYXZiX2dlbjNfaHdfaW5mbyA9IHsNCj4gPg0KPiA+ICBzdGF0aWMgY29uc3Qgc3RydWN0
IHJhdmJfaHdfaW5mbyByYXZiX2dlbjJfaHdfaW5mbyA9IHsNCj4gPiAgICAgICAgIC5jaGlwX2lk
ID0gUkNBUl9HRU4yLA0KPiA+ICsgICAgICAgLmFsaWduZWRfdHggPSAxLA0KPiA+ICB9Ow0KPiA+
DQo+ID4gIHN0YXRpYyBjb25zdCBzdHJ1Y3Qgb2ZfZGV2aWNlX2lkIHJhdmJfbWF0Y2hfdGFibGVb
XSA9IHsgQEAgLTIxNDAsNw0KPiA+ICsyMTQxLDcgQEAgc3RhdGljIGludCByYXZiX3Byb2JlKHN0
cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ID4gICAgICAgICBuZGV2LT5tYXhfbXR1ID0g
MjA0OCAtIChFVEhfSExFTiArIFZMQU5fSExFTiArIEVUSF9GQ1NfTEVOKTsNCj4gPiAgICAgICAg
IG5kZXYtPm1pbl9tdHUgPSBFVEhfTUlOX01UVTsNCj4gPg0KPiA+IC0gICAgICAgcHJpdi0+bnVt
X3R4X2Rlc2MgPSBpbmZvLT5jaGlwX2lkID09IFJDQVJfR0VOMiA/DQo+ID4gKyAgICAgICBwcml2
LT5udW1fdHhfZGVzYyA9IGluZm8tPmFsaWduZWRfdHggPw0KPiA+ICAgICAgICAgICAgICAgICBO
VU1fVFhfREVTQ19HRU4yIDogTlVNX1RYX0RFU0NfR0VOMzsNCj4gDQo+IEF0IGZpcnN0IGxvb2ss
IHRoaXMgY2hhbmdlIGRvZXMgbm90IHNlZW0gdG8gbWF0Y2ggdGhlIHBhdGNoIGRlc2NyaXB0aW9u
Lg0KPiBVcG9uIGEgZGVlcGVyIGxvb2ssIGl0IGlzIGNvcnJlY3QsIGFzIG51bV90eF9kZXNjIGlz
IGFsc28gdXNlZCB0byBjb250cm9sDQo+IGFsaWdubWVudC4NCg0KVGhpcyBjaGFuZ2VzIGludHJv
ZHVjZWQgYnkgdGhlIGNvbW1pdCBbMV0sIHdoZXJlIGl0IHVzZWQgbnVtX3R4X2Rlc2MgcmVsYXRl
ZCB0byA0Ynl0ZSBhbGlnbm1lbnQgcmVzdHJpY3Rpb24uDQoNClsxXSBodHRwczovL2dpdC5rZXJu
ZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90b3J2YWxkcy9saW51eC5naXQvY29tbWl0
L2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmM/aD12NS4xNC1yYzcmaWQ9
ZjU0MzMwNWRhOWI1YTVlZmFmNmZhNjE2MDZlOGJiYzg5NzdmNDA2ZA0KDQoNCj4gDQo+IEJ1dCBu
b3cgTlVNX1RYX0RFU0NfR0VOWzIzXSBubyBsb25nZXIgbWF0Y2ggdGhlaXIgdXNlLg0KPiBQZXJo
YXBzIHRoZXkgc2hvdWxkIGJlIHJlbmFtZWQsIG9yIHJlcGxhY2VkIGJ5IGhhcmRjb2RlZCB2YWx1
ZXMsIHdpdGggYQ0KPiBjb21tZW50Pw0KDQpPSywgd2lsbCByZXBsYWNlIHRoaXMgbWFjcm9zIHdp
dGggaGFyZGNvZGVkIHZhbHVlcyB3aXRoIGEgY29tbWVudC4NCg0KUmVnYXJkcywNCkJpanUNCg0K
DQo+IA0KPiAgICAgLyoNCj4gICAgICAqIEZJWE1FOiBFeHBsYWluIHRoZSByZWxhdGlvbnNoaXAg
YmV0d2VlbiBhbGlnbm1lbnQgYW5kIG51bWJlciBvZg0KPiBidWZmZXJzDQo+ICAgICAgKi8NCj4g
ICAgIHByaXYtPm51bV90eF9kZXNjID0gaW5mby0+YWxpZ25lZF90eCA/IDIgOiAxOw0KPiANCj4g
Pg0KPiA+ICAgICAgICAgLyogU2V0IGZ1bmN0aW9uICovDQo+IA0KPiBHcntvZXRqZSxlZXRpbmd9
cywNCj4gDQo+ICAgICAgICAgICAgICAgICAgICAgICAgIEdlZXJ0DQo+IA0KPiAtLQ0KPiBHZWVy
dCBVeXR0ZXJob2V2ZW4gLS0gVGhlcmUncyBsb3RzIG9mIExpbnV4IGJleW9uZCBpYTMyIC0tIGdl
ZXJ0QGxpbnV4LQ0KPiBtNjhrLm9yZw0KPiANCj4gSW4gcGVyc29uYWwgY29udmVyc2F0aW9ucyB3
aXRoIHRlY2huaWNhbCBwZW9wbGUsIEkgY2FsbCBteXNlbGYgYSBoYWNrZXIuDQo+IEJ1dCB3aGVu
IEknbSB0YWxraW5nIHRvIGpvdXJuYWxpc3RzIEkganVzdCBzYXkgInByb2dyYW1tZXIiIG9yIHNv
bWV0aGluZw0KPiBsaWtlIHRoYXQuDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
LS0gTGludXMgVG9ydmFsZHMNCg==
