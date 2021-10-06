Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 050A64243FD
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 19:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239233AbhJFRYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 13:24:45 -0400
Received: from mail-eopbgr1410120.outbound.protection.outlook.com ([40.107.141.120]:62640
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239192AbhJFRYn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 13:24:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NsWg8mNywN4mkhv6VeMYk7zUSKj770Hwc8oUbtyb1o94XaMsCX+J1hYLgFb8Ej1Geaxb+EwakWkfDfnJSYTBkw8PeTNZpaYHp0MCZs+qIDYbxD7H5hvHw3VjKRpaWQizC/nLvtaaJ5M9vXEEP6T5yaRV7Wem7HLtNHF78hn50rStoR8igoUzAU/PnFJVPGbj1WZSWVhAHprDfdKdE02GesF2nsy+EW0S/lRrb+e2MoYG9Wumsn9VipjXKc2Hv0C5/XBGjjtoYQ763aL0/3fCeZJcdXjApDhlyYH7EQxdAIUA9WeQy7JmE7WPAC3NyJetAmCYLAsRizbQqIEEF+Lcdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Obybfl2FGIV05FGSF4onkIRq53pKQEvjN5PIRBYqycM=;
 b=F01E8Fb/hl+m5xw/l0PpVZ2ixRR/A/P7atu79GWyVRaawL7QdJ1kNdg+A+lq++RptgZA0gdSw91CUKXtBDi8nClgZS8sW7jlWNqFSTawAiDbhM72CX5s/mqJuwAOhlO0ZKcJIGZtle+Yvi2zoQpTGi7tqnsAzjtPCIFDP1/IdlYaaRkj0jrrt/ja+cv6AIZ6N1o0WPvcZVv++HpY9Rd9tllSChNx2OPVwQS+5lHVJBIflme4lbzeMd0N3fkjCnLe3YagB3knW6Bj1wCko9hXh8EoSmBUBs2/MAEw8Yru1oxnP08SV6X0BYFtGqR/pzMMugj2pPX5gPvgyp67txnROA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Obybfl2FGIV05FGSF4onkIRq53pKQEvjN5PIRBYqycM=;
 b=BKCi4YYKaNH3h7bFiN1rBAU5v1Z5A+Sa/KKHfEod/JjkgE8aZvY8DrbzMXHHblLMK6jMmXlIVrZee2fk122ZkkmoX0Sv3sYkSg6yEGg5JwOwJr6PsZHTeB3RuAUrV16cTaFV5ER0nIzp+vgibcoYp0QV19BrYpLr+tJUmMnEDCQ=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB2133.jpnprd01.prod.outlook.com (2603:1096:603:1f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Wed, 6 Oct
 2021 17:22:47 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4587.018; Wed, 6 Oct 2021
 17:22:47 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
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
Subject: RE: [RFC 08/12] ravb: Add carrier_counters to struct ravb_hw_info
Thread-Topic: [RFC 08/12] ravb: Add carrier_counters to struct ravb_hw_info
Thread-Index: AQHXudkptJjj8VB/5E2i+VTBh4dGtavGLjAAgAAFWICAAAYTAA==
Date:   Wed, 6 Oct 2021 17:22:47 +0000
Message-ID: <OS0PR01MB592250A67A4E5BFFF02DD49D86B09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
 <20211005110642.3744-9-biju.das.jz@bp.renesas.com>
 <5be0aed7-ba46-3b5f-e49f-8edf7cb9c193@omp.ru>
 <4eac039d-1a4e-fdfa-37e7-8a774a88c69a@omp.ru>
In-Reply-To: <4eac039d-1a4e-fdfa-37e7-8a774a88c69a@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5167d6f3-89ff-4513-3c3d-08d988edead6
x-ms-traffictypediagnostic: OSBPR01MB2133:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB2133CA9AFB46F34054FA6C1586B09@OSBPR01MB2133.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uVeqkMQCAGYHSU3OBQ0fqjJdizTgeqvGX4PnphO/4wRqEv7kdUkvKh59Lxm7KJJrWDiRbUbe+83tW1oepmE8NNq9gj/eNe0hmW/GWHvc1FUCGNuZzwdHLTrZA2rys/2wRjBAofF26u6U68yf8U/Aa5KZb4zsgPCpCJ0tT0m6f5u90+CFDTp+Dp+sws4sOnt4ME5tnZOeZnMMZfSn5cJYZl8lLPZUGZIgeDYNR+cTjZTkVPsfvViQmd5VbK8lvzuQaQiu46pfgj0JTeszfKkje87YEXurOeKEAgGyPtbF/s5LJph6pmZ34IBaFEBnbl/w2611lt/IZTdX9aFJL2rRK3U/RvC16zBHt+jlF+fbjrEAbnaPZfbWAFr0NMvmtE6zPw54WHzgviLd8L/dYch+dOYoRjV4LldduTKiXEpzZkkkkfH2YK5ZQgtWfE5WNLr55OJGNVq8uLcr4nfvAqCOa042e3FSAb9VuRtNtU6Jq/LJj9VjfUhAr34ruqKE8mS0I7u0RcQ0p0QAzIHlVFbtjKDCCjp5jumx/kuAORKCNYz7BzG/MT3iph0ik8WI34qAt5/sIbaqK954VRErzG9PmOZkuEN97D7LvCtMzIWvXCDJ/Gox0FT/JydvehNBJfv6YL7UjWA5yTomZLuPGfInd4xTeRQYkwiV9gbZuMj7ZTbx6Sg20GSciNgtX2rVYLC6q8HEV+rySSxE7RDtt1FrLA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(53546011)(54906003)(66946007)(110136005)(8676002)(316002)(6506007)(66476007)(66556008)(122000001)(55016002)(186003)(64756008)(9686003)(66446008)(26005)(38100700002)(5660300002)(4326008)(71200400001)(52536014)(83380400001)(86362001)(2906002)(8936002)(33656002)(7696005)(38070700005)(107886003)(508600001)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T3Nzd1RFNnAvNit6L2RjSlpOZmI5cHlpM3V2aU1PVzdPSEFlZ3hwSm9TYlpV?=
 =?utf-8?B?K1o0RTRDZkNYVGNGZGo4RWdmL0JzVzNlYkxPanE2WEhnaHQ5bzFyWS96Q3ZT?=
 =?utf-8?B?RVhQN29iSVNjQzd1b1ZyTlVreHlOUHBNT3UrZWtsTHhWRkMzRG1FdmFhQnBi?=
 =?utf-8?B?Z0h1ZGhlWE1aR3dHY0N1NUROWUs0SzhMYnU3SDZ0Tm56WlhvYnQxYTZuTld3?=
 =?utf-8?B?TE1BN3FlTGliRjRlZ0FUZDdDWFNCb0RRbkQzQy9BVjQrWllnMm9hbzg5RDVw?=
 =?utf-8?B?QkJPSXRlcTYzYURsK2ZkaFdmZExZcGQ2bVZyNGJIcFpwc2dQRk5semQ0SCtO?=
 =?utf-8?B?cjYwZHZqNjA1U0RvYTZmK2hvU2N1Tm1Uc2ErYWJBRG1VMUdXd2xZM3ZSNVNP?=
 =?utf-8?B?MG9GZ2FTYTJkcER3NEw5TWdBN0piNE91Skl1ZnpkZ2JscDA5aFNSUW9GcFNK?=
 =?utf-8?B?N2lISXJOb2I2U0Z2bW9iOXlHM1psL2dvdHNidTRrbHRqeGh3RjQzaW9GR3NO?=
 =?utf-8?B?TjJWMEFUSitzRWRKQVEzUHFiS3hUMkpEWld3OUNLcDd3dDc3UGNLQWxPWU5o?=
 =?utf-8?B?WU1ha0c2R3hRYlduUzBocEF2Y0hkQXEvZW55alFhcE01R3FBZGVNSGl0NUcz?=
 =?utf-8?B?UTh3RnU3bmFleWxDOFBzeTYwbzJiMk1EOU9tTXlWbDNtR3JsK25rUXArbkVl?=
 =?utf-8?B?S3QzWkZ6VVVvVkJVdWZ0NjRSQmZjdVVXL2JFbVoyTGFqbFNiWHBGWmxHc0xI?=
 =?utf-8?B?MlNRK09mYk8rZ1hpS213Y1BXelc3dU44bXRpandGZHdIbXgwa3JxcjBDc2l5?=
 =?utf-8?B?MTVvSkFJbU1uSWI5b1F2N21sc2RmWjNXN3hiUk12VUErWE5xNUJ0Y3hVR0Z3?=
 =?utf-8?B?K3dMQWFvdDdsdThCUDBqMWJmTXlVWnAwK1dOOGxJNU4rSkhiR0I4N3YxUTlE?=
 =?utf-8?B?TU9zekdwaU5WMnVodWZOOFMvZW9qNTh4L1hoRXF0RDNIYW0wZXBkZlJqODRk?=
 =?utf-8?B?VkQ3N0k0bGl2Lzl6dThTcTJMcFZmYjI3RklPSFFObXhOUFhCOUxsZU5wV1c2?=
 =?utf-8?B?eHVjVzYvbnh1eHd1alVoc2ZKVyt5VTJzbUdFcEtLazEyRUg5U3pyaVpLaDdW?=
 =?utf-8?B?eVlIOFNMZ3AyN3V5a1R0MmUwTXIvZitEWFRpRG00cmMrOS80b0ltYzUyWkNW?=
 =?utf-8?B?SkN3bEpTNlpNREpIWnBvS2RmSlUxTjRyS0tka3d1dlZNMEpqWUFCTit2VlRF?=
 =?utf-8?B?b2FZT1BKeGs0bllqTG9pTjlOb1lTRmdoZ0lMU0Ntd21Na043Wk1rMGRmcnFo?=
 =?utf-8?B?d2JKRjREVC85ODBYS3ZLTVk5dUZpODN1UE5Ed3d0N2RDcnVUMjlnUklQYUU4?=
 =?utf-8?B?Nm04UHhzNloxYjRTcFNuS2U4c0xyNUVLOHR3d1RxeTQ1OWpnTnBCNW5JWENn?=
 =?utf-8?B?NWJhSis1VDEzYWZvekxybE1YaitLczB3cnVtaThhSyt5djNudUhpSDZaSWVP?=
 =?utf-8?B?Tm1GSmFCa1AvamFTY2lmbnNuMmE5NlVjNXdwdnYvU1BGWUFEZG11V3IraG0y?=
 =?utf-8?B?RDlvQXhmZkwzQ0ZQdGVUNUh2bU1Mc3Q2TkJvRkVRZ0FJSkhtL2syMU8vdys4?=
 =?utf-8?B?UVBhaElEaUlRakJXV0tOVmYvYjlkZjNRU1BWMG9nSTJlSW4zOGdSNms2d1RK?=
 =?utf-8?B?L2lzcnNYUWl6VWR1Z0RWYTI3ZGhRNVY2eHhmUTJDR3ZiaDYxWk05dTI4M2Rk?=
 =?utf-8?Q?VlNmzuyKrPZrzbbSEc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5167d6f3-89ff-4513-3c3d-08d988edead6
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2021 17:22:47.6608
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GV2jWyFBr98HnA8qDan3fxkMMx1Q5EJ4yfdB9M0WqathwP5DUq9juXNv6FMpgF/olimyRQte7A9+y7Ge+ok2ifjqAvoMs23SZRti12JkPd4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB2133
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LA0KDQo+IFN1YmplY3Q6IFJlOiBbUkZDIDA4LzEyXSByYXZiOiBBZGQgY2Fycmll
cl9jb3VudGVycyB0byBzdHJ1Y3QgcmF2Yl9od19pbmZvDQo+IA0KPiBPbiAxMC82LzIxIDc6NDEg
UE0sIFNlcmdleSBTaHR5bHlvdiB3cm90ZToNCj4gDQo+ID4+IFJaL0cyTCBFLU1BQyBzdXBwb3J0
cyBjYXJyaWVyIGNvdW50ZXJzLg0KPiA+PiBBZGQgYSBjYXJyaWVyX2NvdW50ZXIgaHcgZmVhdHVy
ZSBiaXQgdG8gc3RydWN0IHJhdmJfaHdfaW5mbyB0byBhZGQNCj4gPj4gdGhpcyBmZWF0dXJlIG9u
bHkgZm9yIFJaL0cyTC4NCj4gPj4NCj4gPj4gU2lnbmVkLW9mZi1ieTogQmlqdSBEYXMgPGJpanUu
ZGFzLmp6QGJwLnJlbmVzYXMuY29tPg0KPiA+PiBSZXZpZXdlZC1ieTogU2VyZ2V5IFNodHlseW92
IDxzLnNodHlseW92QG9tcC5ydT4NCj4gPg0KPiA+IFsuLi5dDQo+ID4NCj4gPj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4+IGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPj4gaW5kZXggOGM3YjI1NjljN2RkLi44OTll
MTZjNWViMWEgMTAwNjQ0DQo+ID4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMv
cmF2Yi5oDQo+ID4+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+
ID4+IFsuLi5dDQo+ID4+IEBAIC0xMDYxLDYgKzEwNjUsNyBAQCBzdHJ1Y3QgcmF2Yl9od19pbmZv
IHsNCj4gPj4gIAl1bnNpZ25lZCBuY19xdWV1ZToxOwkJLyogQVZCLURNQUMgaGFzIE5DIHF1ZXVl
ICovDQo+ID4+ICAJdW5zaWduZWQgbWFnaWNfcGt0OjE7CQkvKiBFLU1BQyBzdXBwb3J0cyBtYWdp
YyBwYWNrZXQNCj4gZGV0ZWN0aW9uICovDQo+ID4+ICAJdW5zaWduZWQgaGFsZl9kdXBsZXg6MTsJ
CS8qIEUtTUFDIHN1cHBvcnRzIGhhbGYgZHVwbGV4IG1vZGUgKi8NCj4gPj4gKwl1bnNpZ25lZCBj
YXJyaWVyX2NvdW50ZXJzOjE7CS8qIEUtTUFDIGhhcyBjYXJyaWVyIGNvdW50ZXJzICovDQo+IA0K
PiAgICBJIHRob3VnaHQgSSdkIHR5cGVkIGhlcmUgdGhhdCB0aGlzIGZpZWxkIHNob3VsZCBiZSBk
ZWNsYXJlZCBuZXh0IHRvIHRoZQ0KPiAndHhfY291bnRlcnMnIGZpZWxkLiA6LSkNCg0KQWdyZWVk
LiBXaWxsIG1vdmUgdG8gJ3R4X2NvdW50ZXJzJyBmaWVsZC4NCg0KUmVnYXJkcywNCkJpanUNCg0K
