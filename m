Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA4273DB3FC
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 08:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237702AbhG3Gyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 02:54:52 -0400
Received: from mail-eopbgr1400125.outbound.protection.outlook.com ([40.107.140.125]:63200
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237576AbhG3Gyu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 02:54:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WvJNRwwFK1QaoiucYyrHnIc2tbVf3yPZHhuFjEwfzNKfELQcx8VYLGP68ZZbNXrxpECWE0fnXWPC+LvPK66uRN70g83Hf1/fSzZN4/QSHzwClP3UwUJbrnhi/FmJAesRvf5/q4ZSLVfs1Tf/gJAwnYvkeKg8VIGwJZWy5qEUx9qGppdwBRc7IoqEgItiRx0v1Sn2Tjbad05UA+ietmshQyRAlvf/vZ2xxK0GQIjIx8vTgJCtN2wY2YuFpOGK0PZJiQ5gi3FkTtmaFoxHwMxyiZssV9ki7Vf3wyBEQMHvC7cyXnZ0+hnx60y8sy52U8qxPsbl+VOLPDMGNmR6afDHlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=69jJPyAXhUC2kqfeh8tV0fufHkZhNNAKnAE05oL9gqA=;
 b=PmAbD4A2DX9s0wr/6dkCame5kfC8i+nNgIkckfqScPOhMnuOwbesjOzAF7/dzxNF4F7TZkQ+aZ8uN8EFaCaoYPvd929DvDFjdvzT6hq7SwVE+vTNeTPZsvkP+Jt+zJAocn+d/Ls8TZiHSS+m59waFuK+xC9HOTs81N8bX1qUlZcnfcWhow49OGxfF8+xJ+JlV4I4TBIq1jISA2QMltFmK0u3aSJwi7fO76lLUCRCyaRHVEj0wkZDLNa2at4kNc4cqPsvaChXSZCGPGAWKVQKW7e26pjt166a95cf6yKgnFqtZm69sVQEza9O+eeTZFO2TFemiJklv/vSQx2zR46D0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=69jJPyAXhUC2kqfeh8tV0fufHkZhNNAKnAE05oL9gqA=;
 b=gzIl2rnA65VXr4hyATYYT79dAFFJXBr+AK+et0CNE/VK5CiKYT2bnLNpuaisev4ZXjQH6QRcBztqC/nO9AWPs8KeDs0L6EqY6X9eSVtDfmnZV+fCApszH9FwQaCL5YiVXjSrWsTnoLD8mWWpnJ7bMSGsjJMM+PZVvGODJvoLumE=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB1701.jpnprd01.prod.outlook.com (2603:1096:603:6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20; Fri, 30 Jul
 2021 06:54:43 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%8]) with mapi id 15.20.4373.022; Fri, 30 Jul 2021
 06:54:43 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
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
Subject: RE: [PATCH net-next 11/18] ravb: Factorise ravb_ring_init function
Thread-Topic: [PATCH net-next 11/18] ravb: Factorise ravb_ring_init function
Thread-Index: AQHXfwPoHc3Y1bNQ/EqUAD7o4YrMCataWByAgADBBFA=
Date:   Fri, 30 Jul 2021 06:54:43 +0000
Message-ID: <OS0PR01MB5922CAC5CDA8D5A2E045F72F86EC9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
 <20210722141351.13668-12-biju.das.jz@bp.renesas.com>
 <a6728580-11d9-64f5-4c95-32a5a01379ac@gmail.com>
In-Reply-To: <a6728580-11d9-64f5-4c95-32a5a01379ac@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0df365db-0350-4265-3751-08d95326e921
x-ms-traffictypediagnostic: OSBPR01MB1701:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB170140F6C0B21E47C0979DBF86EC9@OSBPR01MB1701.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jN6C2PQxvHiX4MxYxgbnJ3tMHPuNQh9Lmdp0QRL/axBofdaABQn1/YbhAx34g71wFZekdjTzOL15446lfvmD4r2evx+6Nxe4XtwKCj13tIdApMzuRviWSfZPSKmf7godqCJ8PzuKgt6MZ1xSnsNbx+6cVC7LHfkVptI4PjvHvb0db82UA7+lg/PSIhxwwKvvjxqpJeXcTKMctBKssXauGmn56MDhJqgXVrcRuB5u43EST3xwWxVN7Q2SWDAwZpqudIcdIPfW0i3RYnY+uFsfdcOVxCvLzyRp/O6nuOQAJ+6Pt3dEj/xv0ORWM6Cfzu06jwF0QQ+RUYc6PKX77ZbR5BfYVxI7pG9+8fA7I8Zm3BaBfnvoEoRi0Le1nXHPL12ICq4PUX3leC9l7+0OAE8V/GpLDljZvzExnbM97VgTFJ5WTwjeBJTpeZeBE0jyjO81fMbfuv0Bc8qZ6yZSAAGTFGc7WZEskAGoS8x/lD5EfDIUDNRqqAtLClIFd3uFWTLllu12hQ7Lfbj2hUfiM7uZG3CCIGTbA7V2tmQD7gPgurvP9ntWLQ1EHAvTrApAsjqdOX6l6BFNMV2TzJE7N9Yh0TGUZ01oE4kkIRSuLm5WZciKO4Jxn9iGFPftIYt7og1nFxkkMZzvoAVboqNiQAC250EyDK7rn3YDyR4M32IZw8zWzcgigaECyk6vJ6JC+7KfuVoFwxOEm3DsQKc3KfsWug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(4326008)(316002)(55016002)(9686003)(8936002)(508600001)(5660300002)(53546011)(86362001)(76116006)(7696005)(107886003)(38070700005)(7416002)(66446008)(122000001)(2906002)(52536014)(33656002)(54906003)(71200400001)(110136005)(83380400001)(8676002)(66946007)(64756008)(66476007)(66556008)(6506007)(26005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RE5yS3V2WkJ5MjR6aVBzWVAvS1ZjN3kweG9Ia1BvaTVjSkhmRnJUdVlVSlhu?=
 =?utf-8?B?YnNoSTVXRE9td2NGcGlSeXh5SXFYbVZWL0VtQ095M2JuWVpZV05PVTVsY1Bh?=
 =?utf-8?B?eUFXRGN6bEhFakc3eDZISWs0SmhudHpMdTB4Yk9xS2F3WHZlUnpIQ2FTaWJZ?=
 =?utf-8?B?SWZKajZpTWh3amdMN0V2RUxGRGF2U0x5NVNGajBzY1M3UG8yb2RodG9RWmRQ?=
 =?utf-8?B?ZWF0UndXem5TbVVBam53M0dlejRPMWtXNWtUQytudUZ0Z0Q5MkxqYlgzNXlW?=
 =?utf-8?B?K2cxMXY2NGtNUVBjRHJSOXdwWGVBbFMxSVpaRis1UDV6N1hyWWE0aFI0b2R3?=
 =?utf-8?B?SHRoUHNSNmkzOVpoZERwY0MxSUljellDc2xFZkpkRmlZSWpiMzBvZkxoM2FP?=
 =?utf-8?B?dE9SaVA1L1QzQWdRcjE4OGtHMmRmSHNMR2dsbnlsZ2tOdElxM2pVSjVaZVBI?=
 =?utf-8?B?TldPTEhRWVovbXREZUIxQnNMdGFmaGxwbVV2eHQ5MTVrUm81QXpPSkIxdDRW?=
 =?utf-8?B?eDUrTlhVRXBJT2hKSHdlM2dZUGpWUnY3UWwzZ2h4dlpQQWgxMzQ2UjdwZE1x?=
 =?utf-8?B?Tkx1YTdKSkN4Z3lyYUNMeHY5enkzOHZpSzFnZ0sySWpGTm5tcEE0VlBCdW9q?=
 =?utf-8?B?MmluQjdDZlkzaFBqd2Z0dVRSSGgvTVBmRks5V2JXaDRhV3Y0cXdJMU5xU24z?=
 =?utf-8?B?aUl3L1FVdnUvSTdwdDZGOW1jdlFJQy9qc2VOdExkaDB0U1pnWlRvbFVzWE5l?=
 =?utf-8?B?Q2JUVnFUWVh2QVRWZC94RVQ2emFaMjZSWE5yRUtFZ2xRQllFY3NMdkRiMDFZ?=
 =?utf-8?B?NThlK1NhcG5NS0NYSC9xNzhMU1I2Z2tOWFM3eVdZSzRYWEJxZ0tEbitQTWJh?=
 =?utf-8?B?QWtRbU5oMmtqTW9jeURYWVhuWjRONitHWWlQVld0L05FOThnd1BQNERXb0hY?=
 =?utf-8?B?cngvNGVoYm9Za1FJMzVTeWNZV3JFOU1zSkdKNy8zR0VSVEhoaHl0TjVTa0dw?=
 =?utf-8?B?emtnc1NDSTh6RU9xTmpRT05NQTFqQVhYY1kvQ2R3OEdwb2REOHQwZVZUR2JZ?=
 =?utf-8?B?aFhpRGpUK2xpUlA0TEhaTHRJMHJaOWtTTCsxMkFCZkNiQTlOc1dZUWhFY1E2?=
 =?utf-8?B?c01EWFhWOVZ3ejNMdHlTOWx0dC9MdUJwbFVraGd2YlhsK2x1YTNzS1hRWTNz?=
 =?utf-8?B?K1lvK2cvSW9pazdpVEpMeXVQN3FpUWswNzRhU2hMZ2xlczBwTElEbnlWYVhW?=
 =?utf-8?B?cW5OeG5XcFd3RW13L3NoeUNzTDNaQ2xUSlpKWmkyYjRKSGJDRUpPUk4wWDgr?=
 =?utf-8?B?Uk1iSEI5NWJ4eHNkb21Dd0prZ3hZUWQydE5QZE5DQ2lyc3FxZmh6WlQySHZi?=
 =?utf-8?B?QzErcTJVQnE0OGhZczl6UW1TdjhmT2l3WEtDTzU3Vnhrd0RibmNYaXl1cmxt?=
 =?utf-8?B?OThrbVpiaUNoRW10bEpzQnNwRzR0R2N0TlpWWXM2TWphRFNrdUpmZWduR1Ju?=
 =?utf-8?B?eURoWldLeVlSUi9wTXYwcjdqZ2gxN3BpT0ZqMW8wWWxBd2U2WnJEM2RJRkRz?=
 =?utf-8?B?UndHN2dnako5Y3V4dVVCa2liTGh2a1NTWGtwNHpob0UzRGlHRElNdW9lMUE5?=
 =?utf-8?B?SVpTUWIycUJKS0gzZEpCVHNBNG5STFphamt5cWk5K1VZZE8zdE4wQmZjaVlW?=
 =?utf-8?B?eDV2cWtUam9ITU81YlNnTXhnZ2ZYRTNFdEdOU1VxYlVaMFhpVWZ4cmJkU3pn?=
 =?utf-8?Q?zdAUOf9z+4Bg4F4HsK4kncf1BqYRLAg1IrhXl9N?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0df365db-0350-4265-3751-08d95326e921
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2021 06:54:43.3571
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qtYEH3gBHgfyBVqElDoRDrD4M2LVruek2WfdfR2guNMqsyYgICZa0ws7YUrpCEL1OgEwA2sJMMHEQA1Q5I7ex8pbBlnrdXJ/wAu50sjlaL8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB1701
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIG5ldC1uZXh0IDExLzE4XSByYXZiOiBGYWN0b3Jpc2UgcmF2Yl9yaW5nX2luaXQNCj4g
ZnVuY3Rpb24NCj4gDQo+IE9uIDcvMjIvMjEgNToxMyBQTSwgQmlqdSBEYXMgd3JvdGU6DQo+IA0K
PiA+IFRoZSByYXZiX3JpbmdfaW5pdCBmdW5jdGlvbiB1c2VzIGV4dGVuZGVkIGRlc2NyaXB0b3Ig
aW4gcnggZm9yIFItQ2FyDQo+ID4gYW5kIG5vcm1hbCBkZXNjcmlwdG9yIGZvciBSWi9HMkwuIEZh
Y3RvcmlzZSByeCByaW5nIGJ1ZmZlciBhbGxvY2F0aW9uDQo+ID4gc28gdGhhdCBpdCBjYW4gc3Vw
cG9ydCBsYXRlciBTb0MuDQo+IA0KPiAgICBJbiB0aGlzIGNhc2UgSSB0aGluayB5b3UgZmFjdG9y
ZWQgb3V0IHRoZSBmdW5jdGlvbiBpbiBxdWVzdGlvbi4uLiBidXQNCj4gbXkgRU5nbGlzaCBpcyBw
b3NzaWJseSB0b28gd2Vhay4gOi0pDQoNCk9LLiBJIG1lYW50IGFkZCBhIGhlbHBlciBmdW5jdGlv
biBmb3IgcnggcmluZyBidWZmZXIgYWxsb2NhdGlvbi4NCg0KPiANCj4gPiBTaWduZWQtb2ZmLWJ5
OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6
IExhZCBQcmFiaGFrYXIgPHByYWJoYWthci5tYWhhZGV2LWxhZC5yakBicC5yZW5lc2FzLmNvbT4N
Cj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmggICAgICB8
ICAxICsNCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYyB8IDIw
ICsrKysrKysrKysrKysrKy0tLS0tDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwgMTYgaW5zZXJ0aW9u
cygrKSwgNSBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNh
cy9yYXZiLmgNCj4gPiBpbmRleCBhMzI1OGM1ZDBjM2QuLmQ4MmJmYTZlNTdjMSAxMDA2NDQNCj4g
PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+ICsrKyBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gQEAgLTk5MSw2ICs5OTEsNyBA
QCBlbnVtIHJhdmJfY2hpcF9pZCB7ICBzdHJ1Y3QgcmF2Yl9vcHMgew0KPiA+ICAJdm9pZCAoKnJp
bmdfZnJlZSkoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYsIGludCBxKTsNCj4gPiAgCXZvaWQgKCpy
aW5nX2Zvcm1hdCkoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYsIGludCBxKTsNCj4gPiArCWJvb2wg
KCphbGxvY19yeF9kZXNjKShzdHJ1Y3QgbmV0X2RldmljZSAqbmRldiwgaW50IHEpOw0KPiANCj4g
ICBBaGEsIHJ4XyBhcHBlYXJzIGF0IGxhc3QhIDotKQ0KPiANCj4gDQo+ID4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiBpbmRleCBjMjNmMGQ0MjBjNzAu
LjNkMGY2NTk4YjkzNiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5l
c2FzL3JhdmJfbWFpbi5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9y
YXZiX21haW4uYw0KPiA+IEBAIC0zODQsNiArMzg0LDE5IEBAIHN0YXRpYyB2b2lkIHJhdmJfcmlu
Z19mb3JtYXQoc3RydWN0IG5ldF9kZXZpY2UNCj4gPiAqbmRldiwgaW50IHEpICB9DQo+ID4NCj4g
PiAgLyogSW5pdCBza2IgYW5kIGRlc2NyaXB0b3IgYnVmZmVyIGZvciBFdGhlcm5ldCBBVkIgKi8N
Cj4gPiArc3RhdGljIGJvb2wgcmF2Yl9hbGxvY19yeF9kZXNjKHN0cnVjdCBuZXRfZGV2aWNlICpu
ZGV2LCBpbnQgcSkNCj4gDQo+ICAgICBXaHkgKmJvb2wqPyBJIHRoaW5rIHdlIHNob2xkIGp1c3Qg
cmV0dXJuIGEgcG9pbnRlciBhbGxvY2F0ZWQuDQoNCkFoIE9LLg0KDQpDaGVlcnMsDQpCaWp1DQoN
Cj4gDQo+ID4gK3sNCj4gPiArCXN0cnVjdCByYXZiX3ByaXZhdGUgKnByaXYgPSBuZXRkZXZfcHJp
dihuZGV2KTsNCj4gPiArCWludCByaW5nX3NpemU7DQo+ID4gKw0KPiA+ICsJcmluZ19zaXplID0g
c2l6ZW9mKHN0cnVjdCByYXZiX2V4X3J4X2Rlc2MpICogKHByaXYtPm51bV9yeF9yaW5nW3FdICsN
Cj4gPiArMSk7DQo+ID4gKw0KPiA+ICsJcHJpdi0+cnhfcmluZ1txXSA9IGRtYV9hbGxvY19jb2hl
cmVudChuZGV2LT5kZXYucGFyZW50LCByaW5nX3NpemUsDQo+ID4gKwkJCQkJICAgICAgJnByaXYt
PnJ4X2Rlc2NfZG1hW3FdLA0KPiA+ICsJCQkJCSAgICAgIEdGUF9LRVJORUwpOw0KPiA+ICsJcmV0
dXJuIHByaXYtPnJ4X3JpbmdbcV07DQo+ID4gK30NCj4gPiArDQo+ID4gIHN0YXRpYyBpbnQgcmF2
Yl9yaW5nX2luaXQoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYsIGludCBxKSAgew0KPiA+ICAJc3Ry
dWN0IHJhdmJfcHJpdmF0ZSAqcHJpdiA9IG5ldGRldl9wcml2KG5kZXYpOyBAQCAtNDE4LDExICs0
MzEsNyBAQA0KPiA+IHN0YXRpYyBpbnQgcmF2Yl9yaW5nX2luaXQoc3RydWN0IG5ldF9kZXZpY2Ug
Km5kZXYsIGludCBxKQ0KPiA+ICAJfQ0KPiA+DQo+ID4gIAkvKiBBbGxvY2F0ZSBhbGwgUlggZGVz
Y3JpcHRvcnMuICovDQo+ID4gLQlyaW5nX3NpemUgPSBzaXplb2Yoc3RydWN0IHJhdmJfZXhfcnhf
ZGVzYykgKiAocHJpdi0+bnVtX3J4X3JpbmdbcV0gKw0KPiAxKTsNCj4gPiAtCXByaXYtPnJ4X3Jp
bmdbcV0gPSBkbWFfYWxsb2NfY29oZXJlbnQobmRldi0+ZGV2LnBhcmVudCwgcmluZ19zaXplLA0K
PiA+IC0JCQkJCSAgICAgICZwcml2LT5yeF9kZXNjX2RtYVtxXSwNCj4gPiAtCQkJCQkgICAgICBH
RlBfS0VSTkVMKTsNCj4gPiAtCWlmICghcHJpdi0+cnhfcmluZ1txXSkNCj4gPiArCWlmICghaW5m
by0+cmF2Yl9vcHMtPmFsbG9jX3J4X2Rlc2MobmRldiwgcSkpDQo+ID4gIAkJZ290byBlcnJvcjsN
Cj4gPg0KPiA+ICAJcHJpdi0+ZGlydHlfcnhbcV0gPSAwOw0KPiA+IEBAIC0yMDA4LDYgKzIwMTcs
NyBAQCBzdGF0aWMgaW50IHJhdmJfbWRpb19yZWxlYXNlKHN0cnVjdCByYXZiX3ByaXZhdGUNCj4g
PiAqcHJpdikgIHN0YXRpYyBjb25zdCBzdHJ1Y3QgcmF2Yl9vcHMgcmF2Yl9nZW4zX29wcyA9IHsN
Cj4gPiAgCS5yaW5nX2ZyZWUgPSByYXZiX3JpbmdfZnJlZV9yeCwNCj4gPiAgCS5yaW5nX2Zvcm1h
dCA9IHJhdmJfcmluZ19mb3JtYXRfcngsDQo+ID4gKwkuYWxsb2NfcnhfZGVzYyA9IHJhdmJfYWxs
b2NfcnhfZGVzYywNCj4gPiAgfTsNCj4gPg0KPiA+ICBzdGF0aWMgY29uc3Qgc3RydWN0IHJhdmJf
ZHJ2X2RhdGEgcmF2Yl9nZW4zX2RhdGEgPSB7DQo+ID4NCg0K
