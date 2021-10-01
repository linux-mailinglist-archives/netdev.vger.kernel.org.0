Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D7341E90B
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 10:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352529AbhJAIYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 04:24:39 -0400
Received: from mail-eopbgr1400094.outbound.protection.outlook.com ([40.107.140.94]:3880
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231324AbhJAIYh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 04:24:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NmFsZMhUHzSkzKxchIse/tTgI05CtL3Zb7AgWGPRZ/YRZ+BUzxFlx1/z1WNwAs2kyhdj0+y9dfH7LeovFG1M/zPxEdoArwZyAWUHupSOfxXrkI0RgeMkQomniqZUa+xM0Q75DloJ+7gn+mWDA+7jtx02PJBsBFxtt/O9dA/Mwf59Lf7aAZSBdVKbU8LOY12ZPgPntK68nYXelBe8p1W0OC1kiQJhZemniThOcXrRv5QqeNI752ISsG/UceteniT7u6oAgwyYxqr2k09E9gUJOWor/Fv3AkugEyOwXjGQuGnndWwG+tf65XtAoUfaxO0+JAMAdfTtk/Q7+90pBESoRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cX2MWo8o3MqmK4FTjXYfRnwC17rp85+5FhPsmxlQCT8=;
 b=lxlg3j5Pzn4qvH9i8H+0hF/9v7bkgRNPIkp1sRLZIAywNtLH4QKCBZH0O+/G5YdY620gBltA8avrqHfKypo6U9hxf9mp+S1OOCb7IZGq2BBSF7QTCguzvqboB9Kgzwcqb6Rqr0u9WglSe7ZSZKo8Ni+000BVrmmEd47Fk9z44/RiuEVhQUebYRAwt8chr+umUXl7DVZawi7NZwvQ4FffDWK2Ev/gWksZY6pPwD6wxvtGe2HbtwRK5OIW7Cm3XbxepBCSozPgybEh8nr6/9bBq/PLZ3i5omHjm0I14rsEfJD6rwJ4PZ/prrPFAuOIO4aKqmHynqLwuESjQs4Ue8BkSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cX2MWo8o3MqmK4FTjXYfRnwC17rp85+5FhPsmxlQCT8=;
 b=TpKJKZYn+DgahCU3DfWCKtT1/TC7+t9xbkpyOo81AyhEIU4urcIzajbW/5Cj8LKlmHNc0xJXFqOzelkwK/7lmqTPQA0Xh7m7ujZkkiFU38jM8i9g0nVyNkT8IXkgas37PUcGzRxHRYGgJHK5O9V1ptBSHsLEUPxKXcrh/G2O9Lk=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSZPR01MB7081.jpnprd01.prod.outlook.com (2603:1096:604:13e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Fri, 1 Oct
 2021 08:22:49 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4566.015; Fri, 1 Oct 2021
 08:22:49 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
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
Subject: RE: [RFC/PATCH 18/18] ravb: Add set_feature support for RZ/G2L
Thread-Topic: [RFC/PATCH 18/18] ravb: Add set_feature support for RZ/G2L
Thread-Index: AQHXsISbPS3JiQSpSkuqkXJbL6JsEau9FXsAgADEOsA=
Date:   Fri, 1 Oct 2021 08:22:49 +0000
Message-ID: <OS0PR01MB5922F3C4BEB26E1CCFAA4C9C86AB9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-19-biju.das.jz@bp.renesas.com>
 <b19b7b83-7b0b-2c48-afc2-6fbf36a5ad98@omp.ru>
In-Reply-To: <b19b7b83-7b0b-2c48-afc2-6fbf36a5ad98@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c064f016-a353-42a2-62c6-08d984b4a81c
x-ms-traffictypediagnostic: OSZPR01MB7081:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSZPR01MB70810BA328924BF4162ABD8786AB9@OSZPR01MB7081.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7iL9i3ofp3Frxdx3LGDSYUlwS7ZYMouDBAuuHBQnoHiky+5/vLt+tmZ+lgNmj2qpuivwiLaHBejf3NW+bfuolc0Jiv0itz9hZ7bSDwwAai58XVbGHuxz+kW5VnRV9TnRrd9kusf3ma135oRxsQVRXE4z9Sb0ekAXZPMLWPOIStXAqUX3TigC8BL2bzb8IGdNFPA3n/YmoPzUvH3I2eZJJCsvIkGvOAXTfy+GEOPkIiJ0aDam4pnLCmcdlVXu40utyeOeT/UGXKT0hux0tDC7uvVvp++T3DyRrkkFUoW+DphmJLZ6haMc6xTqkmvo4VKwwtMrwkiMMulX64+Dah8EOhrytpdoAaCXolnd/Z4sHm/Ljbux0m8SGW2BEUdMu5gVoyru+pSQs2gI3G+2YkqjiHu6LqMEHK0K8VjUuknZDKSaVy2RC0zSW+q5j/FkA0yt57PThcZUsNESzNlQ+8fN5Ikrbu0MjKkuzPI9Bhext8wGeZFL+TIPm2jPiSRZId6L1LD/W/YViuFEj3dHYtjl20+lRsYjHh7bneaxYi2mbsl8FEPcZo1eARn/QtaeMQhAikXBAXfVmqWTW58T0qOYul7OjPGyOeWbYJlj/itE5suTbKsFw+WXVoayDz5QC72eXCe34twnokU40l0MfR7EhntAIO5eZOzAJC2qzuTR3qUNSOcHf+1kKESyyb9YhOPHpm6YLlDe04ncKHou1kIFLYcgnbps8iFSxoscrB9zyed+SytlRy1WmqeJ8dAd+7QOpQIGvMulGuEtYWr+c3GC/2BBWJIEzh3iqlhPpQNdUwk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(186003)(8936002)(52536014)(71200400001)(38100700002)(83380400001)(110136005)(54906003)(5660300002)(107886003)(2906002)(26005)(316002)(66946007)(4326008)(66446008)(64756008)(66476007)(66556008)(122000001)(8676002)(7696005)(508600001)(53546011)(6506007)(55016002)(33656002)(86362001)(966005)(9686003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q3dXTVA4dk9Rb3hid0VNbEVlYXQzUitMZy9mSTdVTklvRG1VVzRIK2UyeTV6?=
 =?utf-8?B?VW1NOWNndlBkZEkxc2dLOEtBNjR3VzlYQ1gxOW5Xc2g3RWdLTVpvWCtxUDdm?=
 =?utf-8?B?YUdkMVNZT3FmZ1Z3VkNDazZydkJDSEpYRmdxRVBZVms5TkNXamdtNTVZQTlJ?=
 =?utf-8?B?dUNhWlAwSVRDRjMvLytDMG1OZEdNUW9jT3N6N24xSHZxSzVNai8ra3RVbGs0?=
 =?utf-8?B?RXcrR2RlOFlGZXdrbm1EbGl0NWlxVm9VRjk2aURyMGRNYldwdGpxNmRrcEFk?=
 =?utf-8?B?RERraDlENDE2bTViM0lsb2w2c0laREJ6ckVTR0JqS3dnanlrWGFBeWtpaWNr?=
 =?utf-8?B?ZE1HSXVSaG9oY2llcDA5YkxxWEhoeThpaFdyc3V3UUE2MXUxRDI1SFRHZjJF?=
 =?utf-8?B?c2llYTIxWTdHRDg0Y3NRR0JGQUZQRjlsOExqV1dEZU1kQXRmT3lCamFLcHVj?=
 =?utf-8?B?OU85NXNCSkxyTDZtZ2QxZ1Vrbm40UVZ0dG5JSHJCUjJqbFBZd2xFTU9NYWJ6?=
 =?utf-8?B?dnhWamhDRUJRTnNCaDQ0aXVLVEFMSVV2bXZpOWpucVpLTzNnU2RhdG1NNnhQ?=
 =?utf-8?B?VXd0Z2hDKzVnVmh0dGNrNmVCQ2orbjNtMjExaFpZRDBYOUtoV3RLaW5xWk45?=
 =?utf-8?B?N2dxVGNSYllMdUFYMTExZ1paUm5oOStuVTlvWnQ0UE9WUVBWaDZZNWNCelpw?=
 =?utf-8?B?TXdkWTR2M3M4N1cvdEx3WDZmRlB2OWVEeTlkQm5obisyeENIc24xcTVhUWJk?=
 =?utf-8?B?L0N1dmFKRk43REJZQlE5MlduMWVXM3ZOSjZVWGxsZ0ozWXRMaWhUL2ZaenRE?=
 =?utf-8?B?Z3F4bDA1ZVV2QUdWUTJoU2dzQkkyZU9ZLzhNd25sQmJ4aXd2UjIxUGs1ZGVo?=
 =?utf-8?B?WEhNc2lxU0xzZExGQ0lzUHZSdXd1NnF5SUpQaEtHeWYzb1BodmxJM2hNZUpR?=
 =?utf-8?B?ZURBR0haNE9VZUl3anBUSEFWQkZTeVpqRFBuS1FKUHlFdHJQNmkvdVNtSWlT?=
 =?utf-8?B?T2NoUWRpcjNpYVNKcjQrRjhmS1V3VjhlYkNvRlc3ajAyeDJ3K3pUQk5qM01T?=
 =?utf-8?B?RTI4WjJSRWczYklYSmVieEJ3MXNlWU1tVEFpNFRhUlpQdlpDNll5QlAvYzlE?=
 =?utf-8?B?WFJwY2R0eDdZUHQ1NTZpYTRuNm9sNmc4SnVXcWJTcHpmU2xpcDUrckRVaFJN?=
 =?utf-8?B?a0QvcVoxUzkxcXZWMEZrMGRhOHY4VFNCaWRxd2xRdEMrQUV4My96M2VBNGJi?=
 =?utf-8?B?L2kyMWJRWlNRd0hBc2ZGSmpCVVNBdDVJT3pFUTBSS0ROak5oT3lmUGJteDMv?=
 =?utf-8?B?NWxRSmJCVm9JZWRsTlBrelBHN1A3MW5VYXBDMy82UkRjK3FLdHR5ajIxYTZr?=
 =?utf-8?B?TzJ6VmhFYUQwenFLbDV2dm5OSzZsZFJNakkwOG5paHNzc1E4eVdReHVLemt6?=
 =?utf-8?B?RHAyV1VSUU1yMHZ6WUhSeU1LWFl5QzFVU0RBK0lTaVNwWS9qN3ZmTGN4eHRC?=
 =?utf-8?B?aHdJc3Uzd1kwUHUyOUFxYlNqUnFBU3ErTHpvOEhSZkR4cUMxNjQyMjJDR3E5?=
 =?utf-8?B?TUdzMjloMHV6dmxEWk5KUVNHVUJWbWtmMk0xWmRVUlpGUm9Va2tHUXMyb3R1?=
 =?utf-8?B?WkZhd0U4azhGcTRuRXZCOS9DeU44aHozd25TSXVLM2YxRW56Mk9hYVArZEtC?=
 =?utf-8?B?U2dHSGZmcXpjVUxObi9GaEcrNUY0Vi9TQ1Z0RjltUVpzbm9Dam9sQTByV3JB?=
 =?utf-8?Q?x4QSy26lsyizDek/k4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c064f016-a353-42a2-62c6-08d984b4a81c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2021 08:22:49.7723
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bmCjiJsKOI3ZYzQ5snGl0HHC27kgeWJmeTvheITMtEbY3Ea4JhWDJcBk8UPFLFvzernvAnhSCmTU4e4/8u6FNz7Bu9lb/su8x35UN6k7SL4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB7081
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2VyZ2V5IFNodHlseW92
IDxzLnNodHlseW92QG9tcC5ydT4NCj4gU2VudDogMzAgU2VwdGVtYmVyIDIwMjEgMjE6MzkNCj4g
VG86IEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT47IERhdmlkIFMuIE1pbGxl
cg0KPiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5v
cmc+DQo+IENjOiBQcmFiaGFrYXIgTWFoYWRldiBMYWQgPHByYWJoYWthci5tYWhhZGV2LWxhZC5y
akBicC5yZW5lc2FzLmNvbT47DQo+IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD47IFNlcmdl
aSBTaHR5bHlvdiA8c2VyZ2VpLnNodHlseW92QGdtYWlsLmNvbT47DQo+IEdlZXJ0IFV5dHRlcmhv
ZXZlbiA8Z2VlcnQrcmVuZXNhc0BnbGlkZXIuYmU+OyBBZGFtIEZvcmQNCj4gPGFmb3JkMTczQGdt
YWlsLmNvbT47IFlvc2hpaGlybyBTaGltb2RhDQo+IDx5b3NoaWhpcm8uc2hpbW9kYS51aEByZW5l
c2FzLmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LXJlbmVzYXMtDQo+IHNvY0B2
Z2VyLmtlcm5lbC5vcmc7IENocmlzIFBhdGVyc29uIDxDaHJpcy5QYXRlcnNvbjJAcmVuZXNhcy5j
b20+OyBCaWp1DQo+IERhcyA8YmlqdS5kYXNAYnAucmVuZXNhcy5jb20+DQo+IFN1YmplY3Q6IFJl
OiBbUkZDL1BBVENIIDE4LzE4XSByYXZiOiBBZGQgc2V0X2ZlYXR1cmUgc3VwcG9ydCBmb3IgUlov
RzJMDQo+IA0KPiBPbiA5LzIzLzIxIDU6MDggUE0sIEJpanUgRGFzIHdyb3RlOg0KPiANCj4gPiBU
aGlzIHBhdGNoIGFkZHMgc2V0X2ZlYXR1cmUgc3VwcG9ydCBmb3IgUlovRzJMLg0KPiA+DQo+ID4g
U2lnbmVkLW9mZi1ieTogQmlqdSBEYXMgPGJpanUuZGFzLmp6QGJwLnJlbmVzYXMuY29tPg0KPiA+
IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaCAgICAgIHwgMzIg
KysrKysrKysrKysrKysNCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21h
aW4uYyB8IDU2DQo+ID4gKysrKysrKysrKysrKysrKysrKysrKystDQo+ID4gIDIgZmlsZXMgY2hh
bmdlZCwgODcgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiA+DQo+ID4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+IGluZGV4IGQ0MmU4ZWE5ODFkZi4uMjI3NWYy
N2MwNjcyIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2
Yi5oDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiBA
QCAtMjA5LDYgKzIwOSw4IEBAIGVudW0gcmF2Yl9yZWcgew0KPiA+ICAJQ1hSNTYJPSAweDA3NzAs
CS8qIERvY3VtZW50ZWQgZm9yIFJaL0cyTCBvbmx5ICovDQo+ID4gIAlNQUZDUgk9IDB4MDc3OCwN
Cj4gPiAgCUNTUjAgICAgID0gMHgwODAwLAkvKiBEb2N1bWVudGVkIGZvciBSWi9HMkwgb25seSAq
Lw0KPiA+ICsJQ1NSMSAgICAgPSAweDA4MDQsCS8qIERvY3VtZW50ZWQgZm9yIFJaL0cyTCBvbmx5
ICovDQo+ID4gKwlDU1IyICAgICA9IDB4MDgwOCwJLyogRG9jdW1lbnRlZCBmb3IgUlovRzJMIG9u
bHkgKi8NCj4gDQo+ICAgIFRoZXNlIGFyZSB0aGUgVE9FIHJlZ3MgKENTUjAgaW5jbHVkZWQpLCB0
aGV5IG9ubHkgZXhpc3Qgb24gUlovRzJMLCBubz8NCj4gDQo+IFsuLi5dDQo+ID4gQEAgLTk3OCw2
ICs5ODAsMzYgQEAgZW51bSBDU1IwX0JJVCB7DQo+ID4gIAlDU1IwX1JQRQk9IDB4MDAwMDAwMjAs
DQo+ID4gIH07DQo+ID4NCj4gDQo+ICAgICplbnVtKiBDU1IwX0JJVCBzaG91bGQgYmUgaGVyZSAo
YXMgd2UgY29uY2x1ZGVkKS4NCj4gDQo+ID4gK2VudW0gQ1NSMV9CSVQgew0KPiBbLi4uXQ0KPiA+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+
ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gaW5kZXgg
NzJhZWE1ODc1YmM1Li42NDFhZTU1NTNiNjQgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gWy4uLl0NCj4gPiBAQCAtMjI5MCw3ICsyMzA4LDM4
IEBAIHN0YXRpYyB2b2lkIHJhdmJfc2V0X3J4X2NzdW0oc3RydWN0IG5ldF9kZXZpY2UNCj4gPiAq
bmRldiwgYm9vbCBlbmFibGUpICBzdGF0aWMgaW50IHJhdmJfc2V0X2ZlYXR1cmVzX3JnZXRoKHN0
cnVjdA0KPiBuZXRfZGV2aWNlICpuZGV2LA0KPiA+ICAJCQkJICAgbmV0ZGV2X2ZlYXR1cmVzX3Qg
ZmVhdHVyZXMpDQo+ID4gIHsNCj4gPiAtCS8qIFBsYWNlIGhvbGRlciAqLw0KPiA+ICsJbmV0ZGV2
X2ZlYXR1cmVzX3QgY2hhbmdlZCA9IGZlYXR1cmVzIF4gbmRldi0+ZmVhdHVyZXM7DQo+ID4gKwl1
bnNpZ25lZCBpbnQgcmVnOw0KPiANCj4gICAgdTMyIHJlZzsNCj4gDQo+ID4gKwlpbnQgZXJyb3I7
DQo+ID4gKw0KPiA+ICsJcmVnID0gcmF2Yl9yZWFkKG5kZXYsIENTUjApOw0KPiANCj4gICAgLi4u
IGFzIHRoaXMgZnVuY3Rpb24gcmV0dXJucyB1MzIuDQo+IA0KPiA+ICsNCj4gPiArCXJhdmJfd3Jp
dGUobmRldiwgcmVnICYgfihDU1IwX1JQRSB8IENTUjBfVFBFKSwgQ1NSMCk7DQo+ID4gKwllcnJv
ciA9IHJhdmJfd2FpdChuZGV2LCBDU1IwLCBDU1IwX1JQRSB8IENTUjBfVFBFLCAwKTsNCj4gPiAr
CWlmIChlcnJvcikgew0KPiA+ICsJCXJhdmJfd3JpdGUobmRldiwgcmVnLCBDU1IwKTsNCj4gPiAr
CQlyZXR1cm4gZXJyb3I7DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICsJaWYgKGNoYW5nZWQgJiBORVRJ
Rl9GX1JYQ1NVTSkgew0KPiA+ICsJCWlmIChmZWF0dXJlcyAmIE5FVElGX0ZfUlhDU1VNKQ0KPiA+
ICsJCQlyYXZiX3dyaXRlKG5kZXYsIENTUjJfQUxMLCBDU1IyKTsNCj4gPiArCQllbHNlDQo+ID4g
KwkJCXJhdmJfd3JpdGUobmRldiwgMCwgQ1NSMik7DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICsJaWYg
KGNoYW5nZWQgJiBORVRJRl9GX0hXX0NTVU0pIHsNCj4gPiArCQlpZiAoZmVhdHVyZXMgJiBORVRJ
Rl9GX0hXX0NTVU0pIHsNCj4gPiArCQkJcmF2Yl93cml0ZShuZGV2LCBDU1IxX0FMTCwgQ1NSMSk7
DQo+ID4gKwkJCW5kZXYtPmZlYXR1cmVzIHw9IE5FVElGX0ZfQ1NVTV9NQVNLOw0KPiANCj4gICAg
SG0sIEkgZG9uJ3QgdW5kZXJzdGFuZCB0aGlzLi4uIGl0IHdvdWxkIGJlIG5pY2UgaWYgc29tZW9u
ZQ0KPiBrbm93bGVkZ2VhYmxlIGFib3V0IHRoZSBvZmZsb2FkcyB3b3VsZCBsb29rIGF0IHRoaXMu
Li4gQWx0aG91Z2gsIHdpdGhvdXQNCj4gdGhlIHJlZ2lzdGVyIGRvY3VtZW50YXRpb24gaXQncyBw
b3NzaWJseSB2YWluLi4uDQoNCllvdSBjYW4gZG93bmxvYWQgdGhlIGRvY3VtZW50IGZyb20gaGVy
ZSBbMV0NCg0KWzFdIGh0dHBzOi8vd3d3LnJlbmVzYXMuY29tL2RvY3VtZW50L21haC9yemcybC1n
cm91cC1yemcybGMtZ3JvdXAtdXNlcnMtbWFudWFsLWhhcmR3YXJlLTA/bGFuZ3VhZ2U9ZW4mcj0x
NDY3OTgxDQoNClJlZ2FyZHMsDQpCaWp1DQoNCg0KPiANCj4gPiArCQl9IGVsc2Ugew0KPiA+ICsJ
CQlyYXZiX3dyaXRlKG5kZXYsIDAsIENTUjEpOw0KPiA+ICsJCX0NCj4gPiArCX0NCj4gPiArCXJh
dmJfd3JpdGUobmRldiwgcmVnLCBDU1IwKTsNCj4gPiArDQo+ID4gKwluZGV2LT5mZWF0dXJlcyA9
IGZlYXR1cmVzOw0KPiA+ICsNCj4gPiAgCXJldHVybiAwOw0KPiA+ICB9DQo+ID4NCj4gPiBAQCAt
MjQzMiw2ICsyNDgxLDExIEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgcmF2Yl9od19pbmZvIHJnZXRo
X2h3X2luZm8gPQ0KPiB7DQo+ID4gIAkuc2V0X2ZlYXR1cmUgPSByYXZiX3NldF9mZWF0dXJlc19y
Z2V0aCwNCj4gPiAgCS5kbWFjX2luaXQgPSByYXZiX2RtYWNfaW5pdF9yZ2V0aCwNCj4gPiAgCS5l
bWFjX2luaXQgPSByYXZiX2VtYWNfaW5pdF9yZ2V0aCwNCj4gPiArCS5uZXRfaHdfZmVhdHVyZXMg
PSAoTkVUSUZfRl9IV19DU1VNIHwgTkVUSUZfRl9SWENTVU0pLA0KPiA+ICsJLmdzdHJpbmdzX3N0
YXRzID0gcmF2Yl9nc3RyaW5nc19zdGF0c19yZ2V0aCwNCj4gPiArCS5nc3RyaW5nc19zaXplID0g
c2l6ZW9mKHJhdmJfZ3N0cmluZ3Nfc3RhdHNfcmdldGgpLA0KPiA+ICsJLnN0YXRzX2xlbiA9IEFS
UkFZX1NJWkUocmF2Yl9nc3RyaW5nc19zdGF0c19yZ2V0aCksDQo+IA0KPiAgICAgVGhlc2Ugc2Vl
bSB1bnJlbGF0ZWQsIGNvdWxkbid0IGl0IGJlIG1vdmVkIHRvIGEgc3BlYXJhdGUgcGF0Y2g/DQo+
IA0KPiA+ICsJLm1heF9yeF9sZW4gPSBSR0VUSF9SWF9CVUZGX01BWCArIFJBVkJfQUxJR04gLSAx
LA0KPiANCj4gICAgVGhpcyBzZWVtcyB1bnJlbHNhdGVkIGFuZCBtaXNwbGFjZWQgdG9vLg0KPiAN
Cj4gWy4uLl0NCj4gDQo+IE1CUiwgU2VyZ2V5DQo=
