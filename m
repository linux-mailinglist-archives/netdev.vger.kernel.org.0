Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F0D41C01D
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 09:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244694AbhI2Hvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 03:51:32 -0400
Received: from mail-eopbgr1400130.outbound.protection.outlook.com ([40.107.140.130]:47864
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243252AbhI2Hvb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 03:51:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dPaC3/YM3tGJvnuaEDf5lot9R1H4QjF04ZkIECVuTxwkrZSBgSGVjRDVU0B40G4RhZCRwvyYRuJeQu8rDVJv9o/hK47DpuMOE7Ofrtwi9McezsHUYHVT6IQM6yy4rpTP09GuwAtT2bUqo4N3DvDswbnH5EvBWJlrNaOmiBLF1sMhVmJJfVi144Gs9ook5hVu1GswKyT9b+D345kXDLB3THgnQJQsqZnST0C4MXq+rfP7xVh08BsmoMEL2e5X950BheYj3gA8WNu2mcQsSH/6iXceUoPTzrxJJR+bjhcTujqoyp94lyahE3D8AUlBwX6aqTIvpmh0wKkCCOHgxoEE5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=r5Bg5fUyxTS9EpDphPTnhPO8LgK1I6fbJcOfqf0Zs38=;
 b=Ru3eOjriZXWBUurotUfoRVQ2z2pUJ8QzZYSeM+KCU2azSGjpL//BVTakpfcAN4rfWM5T6/PXb02tAlFchLiljkGpNXgq1vUMFYWg882yiWohQVXezEESWjD313d905PnYhnAq8o2enBSFoWF0EoxF3UKOhrrcuE0kv9HoBEmIq3hvrzEnt25CaVYGZWakVn3GhO/UoDvPkJjv1arqGLnNq3vgMUdrOJVdYPTalCJrI/3MRewpeJIZE9GlDLHpasaZQHF0uH4WFdGOzrCG8L4bdz9JY6CuHspLj/ozprSwWyA5hnE3tIMbGVcAmY6P0WHCg6uiO+hAe11jNYknR0Fmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r5Bg5fUyxTS9EpDphPTnhPO8LgK1I6fbJcOfqf0Zs38=;
 b=sSSr9H9z0IM723wWrmhsOdzrkV6Y7CuvaYg50T1YZCa7VKcSdqRTs68UpEJrbusTTdCeBeHtLrw2AndvmDgBRF7+aX5GybT7r4w4pin1Rbkips+4Te9WkIOffwQeB1V9HOjoEBUV87XrH8QE0DFVz31UUh2o7IFc0nRCSkrBwdw=
Received: from TYCPR01MB5933.jpnprd01.prod.outlook.com (2603:1096:400:47::11)
 by TYAPR01MB6329.jpnprd01.prod.outlook.com (2603:1096:402:3b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Wed, 29 Sep
 2021 07:49:47 +0000
Received: from TYCPR01MB5933.jpnprd01.prod.outlook.com
 ([fe80::3d5f:8ca:b2a0:80a1]) by TYCPR01MB5933.jpnprd01.prod.outlook.com
 ([fe80::3d5f:8ca:b2a0:80a1%6]) with mapi id 15.20.4544.022; Wed, 29 Sep 2021
 07:49:47 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [RFC/PATCH 14/18] ravb: Add rx_ring_format function for
 GbEthernet
Thread-Topic: [RFC/PATCH 14/18] ravb: Add rx_ring_format function for
 GbEthernet
Thread-Index: AQHXsISclm/+pLhigEGn+jk9tXaexau4XKIAgAJNNbA=
Date:   Wed, 29 Sep 2021 07:49:47 +0000
Message-ID: <TYCPR01MB59331AE19456E7FB53457C2C86A99@TYCPR01MB5933.jpnprd01.prod.outlook.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-15-biju.das.jz@bp.renesas.com>
 <c50f22d3-4741-f0a0-2664-34910d6c5ea4@omp.ru>
In-Reply-To: <c50f22d3-4741-f0a0-2664-34910d6c5ea4@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 71d3c347-e7fb-4237-cd1f-08d9831db59a
x-ms-traffictypediagnostic: TYAPR01MB6329:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <TYAPR01MB6329CB48BDE67BC602EA41B286A99@TYAPR01MB6329.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7Hk5Ne8xQ2j3WuC1MkqpN/t/xBrmvecs8W6z2n44PdcNYQpLKtKjwnjE2SwcF6b9o8plbX6dR+5vWG8BPDAikQN3H5L98PqLCFbsEVEiXnp0shvcwpUhp04Usfjv6pd1VZ5PGDOGiXkdqoHD/ePR/4/sxIodjgrY3m21hSMqcq+tETVyvWl71zsxJLFKYLu4YgY8ZeI+JrOKa0JTMT6dNVkU1h0jYyxCS33F1UA2Qj5udTmrNtsgIDF+jmnLiYpcRIuywlWw5EBDr4Orxr8cO20IiET0RXRgCoHh8KQkOcuwgBMZyBdCJwnUlZTMQx+XdsGWjWYlhrrbwQzuTCpCG2hKTu7rnuqIv2OEPTSxKNCmGFRqLcbX7V+OcjsJdMz65/m9QYh0vUphatyzVutQx92A3SyTjG8M6YRRGXlaV8jh5dV35LUOgnCQJIeTstWoMzU+lPcjLwjhlqlChqjs5aGNfmsp2PtRsXfroJdg/qMMvcehnLoDA+2oVZ6f95+13/NTY8WrbAWEwE8vqCrvfaPGxKmV7AjiGk4/vgyrBHMAxL2b+xvz+3vbMYKq0LkSHIzdAR/LvCdevUsKyP10+lfv5rm/UOEKFpfcs8xjTdC5ok4bID+eDsQYaiAkwTyJuResQupIwbU1owYF+2SEZQ4Xy0FYcQ0jghuyStsTDYD8hmjK9VRXExdsyf4E4j5h3Nvmpzgg4gaKNM15s/QMgd/WwrsCMtQFnNCmEXCZfZIXiBSVas+KtXzUkl+rbrvdrE0NyJFAhMyeELVk3sQHCziJkEB118roOukWGj4thmk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB5933.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(6029001)(4636009)(366004)(7696005)(5660300002)(66446008)(26005)(83380400001)(55016002)(52536014)(186003)(76116006)(64756008)(66556008)(66476007)(66946007)(508600001)(107886003)(53546011)(122000001)(4326008)(2906002)(38070700005)(86362001)(966005)(8676002)(33656002)(316002)(38100700002)(71200400001)(9686003)(6506007)(110136005)(8936002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TDY2SXZ1TXZoZDZEQ0YrV0hSSWxKWGVrNGxVT2xZa1YreDIxMHo3Qkd6Tm9K?=
 =?utf-8?B?K1UxSHY5ekpabEd2MkxJcWF3K3Q1S3AyN0NpKzB0TFp4Zm9naHhUT2p2ZWc2?=
 =?utf-8?B?Q0pod09IOXBjRGFyOGNJQ3JRYWg2bnVMSi9qOU5lRlM3KzZWTTgrcDYxTXJz?=
 =?utf-8?B?UWZkdWo4b0FwQ055SXVqZmt3VXFzbEk1L1RPMndJanRGVmVNbFBkaUtIWmlU?=
 =?utf-8?B?MTZyVXRMSUk0cVVCcVAxMjN5T0RRUFp1bWd6UXJmYkcvd213YUhGUnZxcUhw?=
 =?utf-8?B?T1doWGQxVWJRMU0xc2tWRWJvNk9JVDdLRFZ6UzRmY3F0TjZ0UVl6UU9JcjJX?=
 =?utf-8?B?KzkwTmRJSG95UHJvQ2o0YXk1RG9icmNTKzNCc2pFUWFtN213UkZWUG5NWE02?=
 =?utf-8?B?V1lHVFZ2RFdkMVFuZC9FNjd0ZThkeHNYakJwVnorUGVaQm0wWVFyWEpjWUEz?=
 =?utf-8?B?cGhvcFZnMEMxOXc1K0lBZm1mbmZqbUxCQm1zbEd4Q01sMm55S012VkNZMUg3?=
 =?utf-8?B?WlRzRXVIOXl5V0pSUk9uVEh5alpYNDZTQUxSUkFrM1kyWDB1R0RpS3RGTTFG?=
 =?utf-8?B?VG5mVStManRNUW1IZGJnN28wdDNvc0RRYmlNK2dBeVBEbnVQbHZOZGVsaUpo?=
 =?utf-8?B?YitCZU9LeHlPNUE5K0did2tRVCtmZVlYZlMvRWVHWGpXeGM1cWJ4aEFQZ3Mr?=
 =?utf-8?B?QmtEaHprcXBGUENLc01VL2N4ZFdOdmVRUitWRmZ1aWUyOXRUNEcrMnVVeEE2?=
 =?utf-8?B?TU9iOE8wVmxSVWJ0aHdxQnlnUzhnaXpDTkJ4UVh1L3kxVkpBeXNVdXFQdTEx?=
 =?utf-8?B?czRkNURMaGFCcFAwV0tIcEloc2VGYW1MT1RvL3VWcmhkU2lvSmlyN2pEbUlK?=
 =?utf-8?B?U3dzVllwcFJFNURxV2ZHdlduSjlVSGoyVVRvcHY3bmd3SVNDNzB2a1ZiT3Jo?=
 =?utf-8?B?ZXlVUmpNaVFZdTFUcUY3cURmS00rQXpFZUc3d0R4WjVreTRnSzFSNEdrdmha?=
 =?utf-8?B?bkdvT05pcVhXWXI5eXpZbkJqTEI1TXpMaEp1NERIdmw3Q0djK3k3aDUvM0tT?=
 =?utf-8?B?dWZheGYvZ3ptWWVJUkU4ZHZXaFphODJaU3M5dlB6aGppcTVURWI0RXB0TWJI?=
 =?utf-8?B?NmI2b3A5U2VvVnVkb2Q4NzhVQlNabTVEOHR6TUgzdlJwMjBpSExtOG1WOVYw?=
 =?utf-8?B?YnlrVm8yOVRqQUI5ZW83SlZZWW02QWxtaXZVYXN0WGIwZGNwaWcvTUxTcnM2?=
 =?utf-8?B?S3dFbG94RFhpQ2h3V3JQdlBrM1NCbTg1djN3cTA3a0w1RzBKTUxwZXQvb3pY?=
 =?utf-8?B?NnYxbldsWnNFS2RNZGVCL3lVaTZBQXd6SVRzUnlMMUdIczJ5MmlOZDF0RkdH?=
 =?utf-8?B?OWRHVnAvZFVwMkExM1lqY2lzQmtMYkJ5bFZsU1VDWmFjaUI4Y2pYS0VuQjBC?=
 =?utf-8?B?RmNZeFNXUWZmcmRFRGZ1b0VqNDU1TG0zeVB5R3J4N2l3aEdkeFladC95TE1y?=
 =?utf-8?B?ZUdGbFk4VEtRRlB0VytzNlhIWkppOGNwWHdwNWxCUml6WWo4cTZGWFliSHdK?=
 =?utf-8?B?RWtlWGJJejlzUitEU1VVangzdnYvd2NFSkRmWGZIZ2pqODhSSDluUEZZQ1dR?=
 =?utf-8?B?QzIzYk5qQXRjTzYwQmhrOG5BczZaazdjcXUwT3dsVTFQR0lEdEoxeG50V2xq?=
 =?utf-8?B?bXJ4SHFyYXhzZUU0Q3ozdHJjdmlWdnJEUmpIcnVrcis2TkJVQk82cnNLbWpP?=
 =?utf-8?Q?eGzUUkB3BBssUdF1gE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB5933.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71d3c347-e7fb-4237-cd1f-08d9831db59a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2021 07:49:47.1766
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DUan3BrWohLUvWslfwG206znl1/p8/aFox7RRFZCfaK2XFJElGjijL5BkVF0vIyPd8d1QTK3jqDnZCQDSMK0QG2kybcA3yrhgqMw6i+fJ5s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB6329
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQo+IFN1YmplY3Q6IFJlOiBbUkZDL1BBVENIIDE0LzE4XSByYXZiOiBBZGQg
cnhfcmluZ19mb3JtYXQgZnVuY3Rpb24gZm9yDQo+IEdiRXRoZXJuZXQNCj4gDQo+IE9uIDkvMjMv
MjEgNTowOCBQTSwgQmlqdSBEYXMgd3JvdGU6DQo+IA0KPiA+IFRoaXMgcGF0Y2ggYWRkcyByeF9y
aW5nX2Zvcm1hdCBmdW5jdGlvbiBmb3IgR2JFdGhlcm5ldCBmb3VuZCBvbiBSWi9HMkwNCj4gPiBT
b0MuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVu
ZXNhcy5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2
Yi5oICAgICAgfCAgMSArDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9t
YWluLmMgfCAyNw0KPiA+ICsrKysrKysrKysrKysrKysrKysrKysrLQ0KPiA+ICAyIGZpbGVzIGNo
YW5nZWQsIDI3IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPg0KPiA+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+IGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiBpbmRleCAyNTA1ZGU1ZDRhMjguLmIwZTA2
N2E2YThlZSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3Jh
dmIuaA0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4g
QEAgLTk4Miw2ICs5ODIsNyBAQCBlbnVtIENTUjBfQklUIHsNCj4gPiAgI2RlZmluZSBSWF9CVUZf
U1oJKDIwNDggLSBFVEhfRkNTX0xFTiArIHNpemVvZihfX3N1bTE2KSkNCj4gPg0KPiA+ICAjZGVm
aW5lIFJHRVRIX1JYX0JVRkZfTUFYIDgxOTINCj4gPiArI2RlZmluZSBSR0VUSF9SWF9ERVNDX0RB
VEFfU0laRSA0MDgwDQo+ID4NCj4gPiAgc3RydWN0IHJhdmJfdHN0YW1wX3NrYiB7DQo+ID4gIAlz
dHJ1Y3QgbGlzdF9oZWFkIGxpc3Q7DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVz
YXMvcmF2Yl9tYWluLmMNCj4gPiBpbmRleCAwMzhhZjM2MTQxYmIuLmVlMTA2NmZlZGM0YSAxMDA2
NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+
ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+IEBA
IC0zMjcsNyArMzI3LDMyIEBAIHN0YXRpYyB2b2lkIHJhdmJfcmluZ19mcmVlKHN0cnVjdCBuZXRf
ZGV2aWNlDQo+ID4gKm5kZXYsIGludCBxKQ0KPiA+DQo+ID4gIHN0YXRpYyB2b2lkIHJhdmJfcnhf
cmluZ19mb3JtYXRfcmdldGgoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYsIGludCBxKQ0KPiA+IHsN
Cj4gPiAtCS8qIFBsYWNlIGhvbGRlciAqLw0KPiA+ICsJc3RydWN0IHJhdmJfcHJpdmF0ZSAqcHJp
diA9IG5ldGRldl9wcml2KG5kZXYpOw0KPiA+ICsJc3RydWN0IHJhdmJfcnhfZGVzYyAqcnhfZGVz
YzsNCj4gPiArCXVuc2lnbmVkIGludCByeF9yaW5nX3NpemUgPSBzaXplb2YoKnJ4X2Rlc2MpICog
cHJpdi0+bnVtX3J4X3JpbmdbcV07DQo+ID4gKwlkbWFfYWRkcl90IGRtYV9hZGRyOw0KPiA+ICsJ
dW5zaWduZWQgaW50IGk7DQo+ID4gKw0KPiA+ICsJbWVtc2V0KHByaXYtPnJnZXRoX3J4X3Jpbmdb
cV0sIDAsIHJ4X3Jpbmdfc2l6ZSk7DQo+ID4gKwkvKiBCdWlsZCBSWCByaW5nIGJ1ZmZlciAqLw0K
PiA+ICsJZm9yIChpID0gMDsgaSA8IHByaXYtPm51bV9yeF9yaW5nW3FdOyBpKyspIHsNCj4gPiAr
CQkvKiBSWCBkZXNjcmlwdG9yICovDQo+ID4gKwkJcnhfZGVzYyA9ICZwcml2LT5yZ2V0aF9yeF9y
aW5nW3FdW2ldOw0KPiANCj4gICAgTG9va3MgbGlrZSB0aGlzIHBhdGNoIHNob2xkIGNvbWUgYmFm
b3JlIHRoZSBwYXRjaCAjMTIgYXMgd2VsbC4uLg0KDQpQYXRjaCMxMiBpcyB0aW1lc3RhbXAgcmVs
YXRlZCBhbmQgd2UgYWdyZWVkIHRvIG1lcmdlIHRpbWVzdGFtcCByZWxhdGVkIGNvZGUgdG8gZ1BU
UCBzdXBwb3J0Lg0KDQo+IA0KPiA+ICsJCXJ4X2Rlc2MtPmRzX2NjID0gY3B1X3RvX2xlMTYoUkdF
VEhfUlhfREVTQ19EQVRBX1NJWkUpOw0KPiA+ICsJCWRtYV9hZGRyID0gZG1hX21hcF9zaW5nbGUo
bmRldi0+ZGV2LnBhcmVudCwgcHJpdi0NCj4gPnJ4X3NrYltxXVtpXS0+ZGF0YSwNCj4gPiArCQkJ
CQkgIFJHRVRIX1JYX0JVRkZfTUFYLA0KPiANCj4gICAgIEFsbG9jYXRpb24gYnVmZmVyIHNpemUg
bW9yZSB0aGVuIHRoZSByZWFsIGRhdGEgc2l6ZT8gRG9lcyB0aGF0IG1ha2UNCj4gc2Vuc2U/DQoN
CkFsbG9jYXRlZCBidWZmZXIgaXMgOEsgYW5kIG1hcHBpbmcgYnVmZmVyIHNpemUgaXMgOEsuIFNv
IHRoZXJlIHdvbid0IGJlIGFueSBpc3N1ZXMNCmZvciBkbWEvY3B1IG9wZXJhdGlvbnMuDQoNCllv
dSBjYW4gcmVmZXIgdG8gY2lwIGtlcm5lbFsxXSBmb3IgZGV0YWlscw0KWzFdIGh0dHBzOi8vZ2l0
aHViLmNvbS9yZW5lc2FzLXJ6L3J6X2xpbnV4LWNpcC9ibG9iL3J6ZzJsLWNpcDQxL2RyaXZlcnMv
bmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMjTDMyNg0KDQo+IA0KPiA+ICsJCQkJCSAg
RE1BX0ZST01fREVWSUNFKTsNCj4gPiArCQkvKiBXZSBqdXN0IHNldCB0aGUgZGF0YSBzaXplIHRv
IDAgZm9yIGEgZmFpbGVkIG1hcHBpbmcgd2hpY2gNCj4gPiArCQkgKiBzaG91bGQgcHJldmVudCBE
TUEgZnJvbSBoYXBwZW5pbmcuLi4NCj4gPiArCQkgKi8NCj4gPiArCQlpZiAoZG1hX21hcHBpbmdf
ZXJyb3IobmRldi0+ZGV2LnBhcmVudCwgZG1hX2FkZHIpKQ0KPiA+ICsJCQlyeF9kZXNjLT5kc19j
YyA9IGNwdV90b19sZTE2KDApOw0KPiA+ICsJCXJ4X2Rlc2MtPmRwdHIgPSBjcHVfdG9fbGUzMihk
bWFfYWRkcik7DQo+ID4gKwkJcnhfZGVzYy0+ZGllX2R0ID0gRFRfRkVNUFRZOw0KPiA+ICsJfQ0K
PiA+ICsJcnhfZGVzYyA9ICZwcml2LT5yZ2V0aF9yeF9yaW5nW3FdW2ldOw0KPiA+ICsJcnhfZGVz
Yy0+ZHB0ciA9IGNwdV90b19sZTMyKCh1MzIpcHJpdi0+cnhfZGVzY19kbWFbcV0pOw0KPiA+ICsJ
cnhfZGVzYy0+ZGllX2R0ID0gRFRfTElOS0ZJWDsgLyogdHlwZSAqLw0KPiA+ICB9DQo+ID4NCj4g
PiAgc3RhdGljIHZvaWQgcmF2Yl9yeF9yaW5nX2Zvcm1hdChzdHJ1Y3QgbmV0X2RldmljZSAqbmRl
diwgaW50IHEpDQo+IA0KPiBNQlIsIFNlcmdleQ0K
