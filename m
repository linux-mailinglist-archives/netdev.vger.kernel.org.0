Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5AD24280D2
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 13:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbhJJLbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 07:31:52 -0400
Received: from mail-eopbgr1410128.outbound.protection.outlook.com ([40.107.141.128]:43904
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231556AbhJJLbv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Oct 2021 07:31:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NF1ZT5eebomLWXdhe7oIQD1D+aGmEyniRd0NMivQ8yK14el4RrZYBJnLU0Amft3QYDAof8CR/0ZkQ0EKDS8vTy3/QfLIbWIjPkoB6ZrYQiKAUnw99rplwHYynX2/p4JX9CyfDNgIWhB46IkcGYEeJ2pQuxlbhyOHpHQ5ZYmfpiwbfQvvIbjxnS2U1pjFRkAWdZGD3cQycAleHFFA70Tvj6pQcPPjYDj3DgeXi/1sE0rh2D4Ul491PZuwHOup1Jtq1njp03Lakh54Z6v7STAhNDq3obLKzkb8P+ampdbx3O0nvO91j4o+qylRYq0goeXPkA84AK8OuaFPk4ZecjMImg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QJaACD7TlU0UhDOQ89Ow7qHYjjSeUtJLkaTWbHslFr8=;
 b=LkNuo5Q+h/EM3ihRv9tOYMlFVgVdRUfplvRGDiiMez/W/OrYuioRcH+4iJ15QCcttuVd0GCoCKos7v/aBqSTWgL9hHP7c9F9ScmEwklG00D6O3Rhnjsftjcn0mmYldfV4LPfEkMW0YCZjsShlR8JT82awn2jAobryFrMYKb1/Q8o/xxQ7w+gHyl4mW4ar6IkpbNAvIKGUYaBWM3EU7Qtmb23lSWOioJbJhocIRJiFvVld17Y7/4AqwhXz7Q9Fh3ZJRJ/4dK9TAFYzScIJoTYO2ygH7seXLBEMuvuhxBux/C4dHvc72NWQ/xYYhszXk/F39RxUxx1dKFzkuKp+PZsPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QJaACD7TlU0UhDOQ89Ow7qHYjjSeUtJLkaTWbHslFr8=;
 b=mlMpZMIk8p4SKpBmWRW7aZM5XZWvtIea62+54ImWCDT7WPkUFomPixZ0vqzjnTDWtmsSitSHGZMuvSpiapKM3jsFgeMGlp+35Z1nAvArpcmhBGlPnKeaG9D1W1VYcenAjDP0/xGomTOLysCFiZeUpyxEuSaf9lnRDVm9GCjQ05U=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB4871.jpnprd01.prod.outlook.com (2603:1096:604:7d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.20; Sun, 10 Oct
 2021 11:29:47 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4587.025; Sun, 10 Oct 2021
 11:29:47 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sergey Shtylyov <s.shtylyov@omp.ru>,
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
Subject: RE: [PATCH net-next v2 13/14] ravb: Update EMAC configuration mode
 comment
Thread-Topic: [PATCH net-next v2 13/14] ravb: Update EMAC configuration mode
 comment
Thread-Index: AQHXvaixd8lMzh4St0+QfQ9kX6MhhKvL9taAgAABWOCAAAStAIAABr7QgAARvhA=
Date:   Sun, 10 Oct 2021 11:29:46 +0000
Message-ID: <OS0PR01MB59220F93D5AEC17A0E54BA1686B49@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211010072920.20706-1-biju.das.jz@bp.renesas.com>
 <20211010072920.20706-14-biju.das.jz@bp.renesas.com>
 <8c6496db-8b91-8fb8-eb01-d35807694149@gmail.com>
 <OS0PR01MB5922109B263B7FDBB02E33B986B49@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <57dbab90-6f2c-40f5-2b73-43c1ee2c6e06@gmail.com>
 <OS0PR01MB592229224714550A4BFC10B986B49@OS0PR01MB5922.jpnprd01.prod.outlook.com>
In-Reply-To: <OS0PR01MB592229224714550A4BFC10B986B49@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: bp.renesas.com; dkim=none (message not signed)
 header.d=none;bp.renesas.com; dmarc=none action=none
 header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a760f5f5-cc86-409e-8428-08d98be143eb
x-ms-traffictypediagnostic: OSBPR01MB4871:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB4871DF4D85D7C3E8D99B194386B49@OSBPR01MB4871.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1060;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lzohEkGQpZaNiB5jObOWcM6Pdr7EfVyk6ZN73L4ppR59OcE2/yQQSZXR/taV9iZ8Wf7GG2/K14vxWgR/+5pB8oeUhqyhwaoRdZ3uQgnukCVfcOm0QMDWcPdnsgQPKmDRRa6tzSx4JSEb0VodX8lblcwNGBe84gXapoCnMGGXfLIUbTvZ4EGi4HJiHG1IRw2zBl4c1O1U5YZQm+2G5+rmOpx9SloqwYtlNR9o9zWMJsvt22Ob1euOr+QEtI+OuLZI2FKbVk4ytfggLmw75DmN4n1rDKa9oXvYFUtr20jzc/KP2oLomRoHy1MRcud9ChUvhEO9KQOf4CDjZczZb529IJgcIvUHGwsS788dY7s94RW2uiIG9HA7rhffSOIfDFnl21EN8XDCd0UwZGm3Bj0/zqqhZjtu6fkvNyocr+YzeYFpAjlEcm3pfMZcLprAGjNPSj2TeqFI/VrBSQBCaaBiBRxQZ4TI6dX3FLmDpgbvEVc07vFEVpeseQTIxn7bjqOoV7fSsTUo4rHXtgc7zmWzUX/5ZWlbS5z/219u9k2IzYoHrNA4Ms+xA6Aew9+4wW0HC5H0n29xk5GxL9OvTMXWU+2QnyAVT6SQAyOQLIcSYajlrO4yscfY/Tm0M641cebnZDAVAr5STdjvnGl2v9K/WMSXM+NBtGZRg01ydUAELVcAg8xNx3EWNnmD/SSqNUOmIULJ024tqrppVbekwAA3yA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52536014)(26005)(316002)(9686003)(71200400001)(15650500001)(7696005)(2906002)(2940100002)(186003)(7416002)(53546011)(38100700002)(6506007)(55016002)(66476007)(38070700005)(86362001)(4326008)(33656002)(122000001)(107886003)(8936002)(508600001)(5660300002)(8676002)(54906003)(76116006)(83380400001)(64756008)(66556008)(66946007)(110136005)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cEszRXNsLzNiVmNpSlRNOXE2dXcxa1ZUaDBsSFVFREQrWGNDNXAyalBzenB6?=
 =?utf-8?B?YWt6Sm9DMUZZS0tsajFnWG1Qclhpak9pRUR4K1VLV2kyNlg2YTZ6NGJEUWRm?=
 =?utf-8?B?amQ4UXdTQ3lLT2FIT2d1Vm02eTJFSnBGK2JScExjcTRTZWwzaVM3end5MUho?=
 =?utf-8?B?ZDBkTGRJSFBMTXNmTkIzZjdrRkk4b21aRUU5cHo2WlBncEJUV1lCOUhYc2lt?=
 =?utf-8?B?dWZwb1NsVVlPQ0pzVi95enlDcmhreHEzYzhQanJzUEZ6cWhrYk40MzBqVkNr?=
 =?utf-8?B?RmoxQThNdmljNzllRzREUS9QU2ZacWpqOFNEem1JZXRmYXdBUTRTYkJOSXRL?=
 =?utf-8?B?Y2RidU5nZnZ6NlhncHV1dXlYYVlqWTl1NEZwNFViTUtHK3NtYXJrRzc0SU1s?=
 =?utf-8?B?WFlJSjZaeUNXVGI4ZWRkaHlWZE4wMVJFV0d3MmdGR0MwVTVXdU1rNTcvZHIx?=
 =?utf-8?B?cU5mZlI3dy9yREZKRHNNcVJTc01SN1dxWGsvVHdxUTdCb09ac2QzTDRJN2NW?=
 =?utf-8?B?OXhJMXNFZEYzaWN6THhFV29qVXFnZ1ErUHdWRzJEYmJBcnpRY0VST1h1V0hT?=
 =?utf-8?B?d0tZWCtZTGZKZmtNRGpoa2ljODM0VU9DSWtnSVJkYmFscktRZFJyV1oramEx?=
 =?utf-8?B?N1AwNFlHOXpLWXhUNWNtY3Arc1cyUjZoUFZUYnJsalluSUZwSmw1Qll5Zmxz?=
 =?utf-8?B?eU1Mbnh4K2xmU2ZlaG9XUndQVHZqcG5UbTB0ME5ZNldodStVbjQ4OVBDbWRK?=
 =?utf-8?B?RGYwck5CSy9naUJ4Zm94VXVaNWRMMUhvU0RBRGU4QWlyeHlOM0h2VTBOV2th?=
 =?utf-8?B?NjVXdnRheUMvbHZRQytISTFvZENQR3dxbjNLa3lnc2x0RnF5TS8rYkF5K0Ja?=
 =?utf-8?B?TU5naytKR3JTU01XMURZWkoyY1ZGN29jR1lONFlKOS82aHNWaEd5SlM2SitR?=
 =?utf-8?B?cWNjY003RXZKMlNHT3J6dkgwQ0N2b2VwNWhvWmNmRFJLZDhhd0FqaFAvb1N4?=
 =?utf-8?B?OC9TWkhtekkvT1lsSTZWM25YQzNhZGdVdXk0TE0yNnRyeXdQQStsUTJ1akpy?=
 =?utf-8?B?Wk9sWExoTUFvM0h0a29pUndvMTc3VE9LWGV5KzJFZ2t6QnF4c25ZOGVnZmdX?=
 =?utf-8?B?eUNETGlXMklmbXo1RzBmL1U2TnZ1OWF4SUQ0MzdaL1NXb0IrV29tcTJaZzNQ?=
 =?utf-8?B?MjJSY0ErcnArdTYxOGpxSTJPZFR1Y1FRZVpONkY4VVFGeFMrR1J5OVlCQWNL?=
 =?utf-8?B?RUxmZS83VFZDN0JnbThWbEJMZTQyemNGOG1yclN2QzcyU3F4aVkvcDFQODFV?=
 =?utf-8?B?ZzFQOGFHNHh6SzloV0lHdFN0YlFKNG5obzdaU0lQUEYrempwaEtVdEs3TG13?=
 =?utf-8?B?am9tWEVjQzQ4aGNHSS9TdEJ6Q1lmcUxPVjlwK0hiZlIxSnJxM1FUZTNFSUZK?=
 =?utf-8?B?WjFRczJYeE9KMlFzYXVLSXNpZUdhYks3OE5NbXYyMU1uZXMrR3VNR0NDakZm?=
 =?utf-8?B?a09YOVNOSEJBSlBGU1VETzFuQk5SM1NPUEZUdzlBQzYyRnZnbUxlNnpJaUo5?=
 =?utf-8?B?aE1HUVJRVEpCSHhRbnU0dGtaV3g1V1A4bkMwRDJWNmw3OHowdkVRZ1VjaVJx?=
 =?utf-8?B?ZG1qMWdWREFyWmh4ZzVPOEN4S1dPZEluZUU1RnRPYmlDRzc2aWlOdng3U0VS?=
 =?utf-8?B?b0RiZXA2cVlJdjNpK2F5cmVHQnN3Y1lGNFVmUlg1TW4yT09RYnNTc3NwMWZt?=
 =?utf-8?Q?bsLEO2YpojddDTMxW8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a760f5f5-cc86-409e-8428-08d98be143eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2021 11:29:46.8456
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +PF4aJknYKjxtKQdB3XIDCL5vNwVmvG8Ic1+32RFkkmsN+ibZ9lrx0VSlVIkxzqcfYBUGeDPHJsdl2WxgTg5tRMvsqQvv4rGAQS8tCushVY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB4871
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LA0KDQpUaGFua3MgZm9yIHRoZSBzdWdnZXN0aW9uLg0KDQo+IFN1YmplY3Q6IFJF
OiBbUEFUQ0ggbmV0LW5leHQgdjIgMTMvMTRdIHJhdmI6IFVwZGF0ZSBFTUFDIGNvbmZpZ3VyYXRp
b24NCj4gbW9kZSBjb21tZW50DQo+IA0KPiANCj4gDQo+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdl
LS0tLS0NCj4gPiBGcm9tOiBTZXJnZWkgU2h0eWx5b3YgPHNlcmdlaS5zaHR5bHlvdkBnbWFpbC5j
b20+DQo+ID4gU2VudDogMTAgT2N0b2JlciAyMDIxIDEwOjQ5DQo+ID4gVG86IEJpanUgRGFzIDxi
aWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT47IERhdmlkIFMuIE1pbGxlcg0KPiA+IDxkYXZlbUBk
YXZlbWxvZnQubmV0PjsgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz4NCj4gPiBDYzog
U2VyZ2V5IFNodHlseW92IDxzLnNodHlseW92QG9tcC5ydT47IEdlZXJ0IFV5dHRlcmhvZXZlbg0K
PiA+IDxnZWVydCtyZW5lc2FzQGdsaWRlci5iZT47IFNlcmdleSBTaHR5bHlvdiA8cy5zaHR5bHlv
dkBvbXBydXNzaWEucnU+Ow0KPiA+IEFkYW0gRm9yZCA8YWZvcmQxNzNAZ21haWwuY29tPjsgQW5k
cmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPjsgWXV1c3VrZQ0KPiA+IEFzaGl6dWthIDxhc2hpZHVr
YUBmdWppdHN1LmNvbT47IFlvc2hpaGlybyBTaGltb2RhDQo+ID4gPHlvc2hpaGlyby5zaGltb2Rh
LnVoQHJlbmVzYXMuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gPiBsaW51eC1yZW5l
c2FzLSBzb2NAdmdlci5rZXJuZWwub3JnOyBDaHJpcyBQYXRlcnNvbg0KPiA+IDxDaHJpcy5QYXRl
cnNvbjJAcmVuZXNhcy5jb20+OyBCaWp1IERhcyA8YmlqdS5kYXNAYnAucmVuZXNhcy5jb20+Ow0K
PiA+IFByYWJoYWthciBNYWhhZGV2IExhZCA8cHJhYmhha2FyLm1haGFkZXYtIGxhZC5yakBicC5y
ZW5lc2FzLmNvbT4NCj4gPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IHYyIDEzLzE0XSBy
YXZiOiBVcGRhdGUgRU1BQyBjb25maWd1cmF0aW9uDQo+ID4gbW9kZSBjb21tZW50DQo+ID4NCj4g
PiBPbiAxMC4xMC4yMDIxIDEyOjM3LCBCaWp1IERhcyB3cm90ZToNCj4gPiA+IEhpIFNlcmdleSwN
Cj4gPiA+DQo+ID4gPj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+PiBGcm9tOiBT
ZXJnZWkgU2h0eWx5b3YgPHNlcmdlaS5zaHR5bHlvdkBnbWFpbC5jb20+DQo+ID4gPj4gU2VudDog
MTAgT2N0b2JlciAyMDIxIDEwOjI4DQo+ID4gPj4gVG86IEJpanUgRGFzIDxiaWp1LmRhcy5qekBi
cC5yZW5lc2FzLmNvbT47IERhdmlkIFMuIE1pbGxlcg0KPiA+ID4+IDxkYXZlbUBkYXZlbWxvZnQu
bmV0PjsgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz4NCj4gPiA+PiBDYzogU2VyZ2V5
IFNodHlseW92IDxzLnNodHlseW92QG9tcC5ydT47IEdlZXJ0IFV5dHRlcmhvZXZlbg0KPiA+ID4+
IDxnZWVydCtyZW5lc2FzQGdsaWRlci5iZT47IFNlcmdleSBTaHR5bHlvdg0KPiA+ID4+IDxzLnNo
dHlseW92QG9tcHJ1c3NpYS5ydT47IEFkYW0gRm9yZCA8YWZvcmQxNzNAZ21haWwuY29tPjsgQW5k
cmV3DQo+ID4gPj4gTHVubiA8YW5kcmV3QGx1bm4uY2g+OyBZdXVzdWtlIEFzaGl6dWthIDxhc2hp
ZHVrYUBmdWppdHN1LmNvbT47DQo+ID4gPj4gWW9zaGloaXJvIFNoaW1vZGEgPHlvc2hpaGlyby5z
aGltb2RhLnVoQHJlbmVzYXMuY29tPjsNCj4gPiA+PiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOw0K
PiA+ID4+IGxpbnV4LXJlbmVzYXMtIHNvY0B2Z2VyLmtlcm5lbC5vcmc7IENocmlzIFBhdGVyc29u
DQo+ID4gPj4gPENocmlzLlBhdGVyc29uMkByZW5lc2FzLmNvbT47IEJpanUgRGFzIDxiaWp1LmRh
c0BicC5yZW5lc2FzLmNvbT47DQo+ID4gPj4gUHJhYmhha2FyIE1haGFkZXYgTGFkIDxwcmFiaGFr
YXIubWFoYWRldi0gbGFkLnJqQGJwLnJlbmVzYXMuY29tPg0KPiA+ID4+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggbmV0LW5leHQgdjIgMTMvMTRdIHJhdmI6IFVwZGF0ZSBFTUFDDQo+ID4gPj4gY29uZmln
dXJhdGlvbiBtb2RlIGNvbW1lbnQNCj4gPiA+Pg0KPiA+ID4+IE9uIDEwLjEwLjIwMjEgMTA6Mjks
IEJpanUgRGFzIHdyb3RlOg0KPiA+ID4+DQo+ID4gPj4+IFVwZGF0ZSBFTUFDIGNvbmZpZ3VyYXRp
b24gbW9kZSBjb21tZW50IGZyb20gIlBBVVNFIHByb2hpYml0aW9uIg0KPiA+ID4+PiB0byAiRU1B
QyBNb2RlOiBQQVVTRSBwcm9oaWJpdGlvbjsgRHVwbGV4OyBUWDsgUlg7IENSQyBQYXNzDQo+ID4g
Pj4+IFRocm91Z2g7IFByb21pc2N1b3VzIi4NCj4gPiA+Pj4NCj4gPiA+Pj4gU2lnbmVkLW9mZi1i
eTogQmlqdSBEYXMgPGJpanUuZGFzLmp6QGJwLnJlbmVzYXMuY29tPg0KPiA+ID4+PiBTdWdnZXN0
ZWQtYnk6IFNlcmdleSBTaHR5bHlvdiA8cy5zaHR5bHlvdkBvbXAucnU+DQo+ID4gPj4+IC0tLQ0K
PiA+ID4+PiB2MS0+djI6DQo+ID4gPj4+ICAgICogTm8gY2hhbmdlDQo+ID4gPj4+IFYxOg0KPiA+
ID4+PiAgICAqIE5ldyBwYXRjaC4NCj4gPiA+Pj4gLS0tDQo+ID4gPj4+ICAgIGRyaXZlcnMvbmV0
L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMgfCAyICstDQo+ID4gPj4+ICAgIDEgZmlsZSBj
aGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiA+ID4+Pg0KPiA+ID4+PiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+
ID4+PiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiA+Pj4g
aW5kZXggOWE3NzBhMDVjMDE3Li5iNzhhY2EyMzVjMzcgMTAwNjQ0DQo+ID4gPj4+IC0tLSBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiA+Pj4gKysrIGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+ID4+PiBAQCAtNTE5LDcg
KzUxOSw3IEBAIHN0YXRpYyB2b2lkIHJhdmJfZW1hY19pbml0X2diZXRoKHN0cnVjdA0KPiA+ID4+
PiBuZXRfZGV2aWNlDQo+ID4gPj4gKm5kZXYpDQo+ID4gPj4+ICAgIAkvKiBSZWNlaXZlIGZyYW1l
IGxpbWl0IHNldCByZWdpc3RlciAqLw0KPiA+ID4+PiAgICAJcmF2Yl93cml0ZShuZGV2LCBHQkVU
SF9SWF9CVUZGX01BWCArIEVUSF9GQ1NfTEVOLCBSRkxSKTsNCj4gPiA+Pj4NCj4gPiA+Pj4gLQkv
KiBQQVVTRSBwcm9oaWJpdGlvbiAqLw0KPiA+ID4+PiArCS8qIEVNQUMgTW9kZTogUEFVU0UgcHJv
aGliaXRpb247IER1cGxleDsgVFg7IFJYOyBDUkMgUGFzcw0KPiA+ID4+PiArVGhyb3VnaDsgUHJv
bWlzY3VvdXMgKi8NCj4gPiA+Pg0KPiA+ID4+ICAgICAgUHJvbWlzY3VvdXMgbW9kZSwgcmVhbGx5
PyBXaHk/IQ0KPiA+ID4NCj4gPiA+IFRoaXMgaXMgVE9FIHJlbGF0ZWQsDQo+IA0KPiBJIG1lYW50
IHRoZSBjb250ZXh0IGhlcmUgaXMgVE9FIHJlZ2lzdGVyIHJlbGF0ZWQuIFRoYXQgaXMgd2hhdCBJ
IG1lYW50Lg0KPiANCj4gPg0KPiA+ICAgICBUaGUgcHJvbWlzY3VvdXMgbW9kZSBpcyBzdXBwb3J0
ZWQgYnkgX2FsbF8gRXRoZXJuZXQgY29udHJvbGxlcnMsIEkNCj4gPiB0aGluay4NCj4gPg0KPiA+
ID4gYW5kIGlzIHJlY29tbWVuZGF0aW9uIGZyb20gQlNQIHRlYW0uDQo+ID4NCj4gPiAgICAgT24g
d2hhdCBncm91bmRzPw0KPiANCj4gVGhlIHJlZmVyZW5jZSBpbXBsZW1lbnRhdGlvbiBoYXMgdGhp
cyBvbi4gQW55IHdheSBpdCBpcyBnb29kIGNhdGNoLg0KPiBJIHdpbGwgdHVybiBpdCBvZmYgYW5k
IGNoZWNrLg0KPiANCj4gYnkgbG9va2luZyBhdCB0aGUgUkogTEVEJ3MgdGhlcmUgaXMgbm90IG11
Y2ggYWN0aXZpdHkgYW5kIHBhY2tldA0KPiBzdGF0aXN0aWNzIGFsc28gc2hvdyBub3QgbXVjaCBh
Y3Rpdml0eSBieSBkZWZhdWx0Lg0KPiANCj4gSG93IGNhbiB3ZSBjaGVjaywgaXQgaXMgb3Zlcmxv
YWRpbmcgdGhlIGNvbnRyb2xsZXI/IFNvIHRoYXQgSSBjYW4gY29tcGFyZQ0KPiB3aXRoIGFuZCB3
aXRob3V0IHRoaXMgc2V0dGluZw0KPiANCj4gPg0KPiA+ID4gSWYgeW91IHRoaW5rIGl0IGlzIHdy
b25nLg0KPiA+ID4gSSBjYW4gdGFrZSB0aGlzIG91dC4gUGxlYXNlIGxldCBtZSBrbm93LiBDdXJy
ZW50bHkgdGhlIGJvYXJkIGlzDQo+ID4gPiBib290aW5nDQo+ID4gYW5kIGV2ZXJ5dGhpbmcgd29y
a3Mgd2l0aG91dCBpc3N1ZXMuDQo+ID4NCj4gPiAgICAgUGxlYXNlIGRvIHRha2UgaXQgb3V0LiBJ
dCdsbCBuZWVkbGVzc2x5IG92ZXJsb2FkIHRoZSBjb250cm9sbGVyDQo+ID4gd2hlbiB0aGVyZSdz
IG11Y2ggdHJhZmZpYyBvbiB0aGUgbG9jYWwgbmV0d29yay4NCg0KSSBoYXZlIHRlc3RlZCB3aXRo
b3V0IHRoaXMgYXMgd2VsbCBhbmQgSSBkb24ndCBmaW5kIGFueSBkaWZmZXJlbmNlLg0KU28gSSBw
bGFuIHRvIHRha2UgdGhpcyBvdXQuDQoNCkRvIHlvdSBoYXZlIGFueSBpZGVhIGhvdyB0byBjaGVj
ayB0aGUgIm92ZXJsb2FkaW5nIHRoZSBjb250cm9sbGVyIiB3aXRoIFBSTSBiaXQgT04vT0ZGIA0K
dG8gY2hlY2sgdGhlIGFjdHVhbCBpbXBhY3Q/IFBsZWFzZSBsZXQgbWUga25vdywgc28gdGhhdCBJ
IGNhbiBjb21wYXJlIHRoZSBzYW1lLg0KDQpSZWdhcmRzLA0KQmlqdQ0KDQo+IA0KPiANCj4gSSBj
YW4gc2VlIG11Y2ggYWN0aXZpdHkgb25seSBvbiBSSjQ1IExFRCdzIHdoZW4gSSBjYWxsIHRjcGR1
bXAgb3IgYnkNCj4gc2V0dGluZyBJUCBsaW5rIHNldCBldGgwIHByb21pc2Mgb24uDQo+IE90aGVy
d2lzZSB0aGVyZSBpcyBubyB0cmFmZmljIGF0IGFsbC4NCj4gDQo+IFJlZ2FyZHMsDQo+IEJpanUN
Cj4gDQo+ID4NCj4gPiA+IFRoZSBtZWFuaW5nIG9mIHByb21pc2N1b3VzIGluIEgvVyBtYW51YWwg
YXMgZm9sbG93cy4NCj4gPg0KPiA+ICAgICBJIGtub3cgd2hhdCB0aGUgcHJvbWlzY3VvdXMgbW9k
ZSBpcy4gOi0pDQo+ID4gICAgIEl0J3MgbmVlZGVkIGJ5IHRoaW5ncyBsaWtlICd0Y3BkdW1wJyBh
bmQgbm9ybWFsbHkgc2hvaWxkIGJlIG9mZi4NCj4gPg0KPiA+ID4gUHJvbWlzY3VvdXMgTW9kZQ0K
PiA+ID4gMTogQWxsIHRoZSBmcmFtZXMgZXhjZXB0IGZvciBQQVVTRSBmcmFtZSBhcmUgcmVjZWl2
ZWQuDQo+ID4gPiBTZWxmLWFkZHJlc3NlZCB1bmljYXN0LCBkaWZmZXJlbnQgYWRkcmVzcyB1bmlj
YXN0LCBtdWx0aWNhc3QsIGFuZA0KPiA+ID4gYnJvYWRjYXN0IGZyYW1lcyBhcmUgYWxsIHRyYW5z
ZmVycmVkIHRvIFRPRS4gUEFVU0UgZnJhbWUgcmVjZXB0aW9uDQo+ID4gPiBpcyBjb250cm9sbGVk
IGJ5IFBGUg0KPiA+IGJpdC4NCj4gPiA+IDA6IFNlbGYtYWRkcmVzc2VkIHVuaWNhc3QsIG11bHRp
Y2FzdCwgYW5kIGJyb2FkY2FzdCBmcmFtZXMgYXJlDQo+ID4gPiByZWNlaXZlZCwgdGhlbiB0cmFu
c2ZlcnJlZCB0byBUT0UuDQo+IA0KPiANCj4gDQo+ID4gPg0KPiA+ID4gUmVnYXJkcywNCj4gPiA+
IEJpanUNCj4gPg0KPiA+IE1CUiwgU2VyZ2V5DQo=
