Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7CC0420D8C
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 15:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235639AbhJDNQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 09:16:19 -0400
Received: from mail-eopbgr1410134.outbound.protection.outlook.com ([40.107.141.134]:45888
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235280AbhJDNOS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 09:14:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b1a17X13HCHjMiJEyZPyz6oV/PcG/I8cQLQZAFjMP0QRF3Y016y3ehV5Bima73ZEFyJKbFdzPKvIX5XdAgouyf2hAz2XUZ3EqcVQajNoaj/mAyLb2POw5gFNTMLcY80OwpzCVrYzUCVtGeABSpNCpV+q1PcrqNabEI33DUZDPznSPpKvaVn+wXb+i7GYmMkhMGahCPbEkvMRruWY5/uLosOa+Xsoh/d6dQkjhwKnplEF4SaFcBJ3QLIm+W8vmPyRwa+yBc3jXJNpsP03nwaAONm+rmsSjtr9bxPLyP0J65vdsG3FwuxX8HXh6oHzSYIhTjlv5ST0YiaKJBv0pEVGng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iBEJic9JCq8dvkbH62QbqiH9JD2RBGDS67skNGGuIzc=;
 b=NJGZFKPVqdeqAksbsBsU2hGEnfBNDf3O2vWQzCQBuFF+P9V3k3T0sHjjd/UDTpCAcW+yevslopKkpwp94frrTPtNjvMw8sTbZT/1jtdtzMaL4R0XeCuPOvG6wXxXl/zXCrzjpFveBrMPjFcbbYyiqpbfO5G4XsYmDIEyKnh6hzANweDwBF1l+2ir5UajzSvnRUwoUvWcDfvxAiu4vMh33q/8mZ2lfK0hum+8IZiORUgnkUS3zChVXUV/09BJCNVz3gOhKewX6KRtXXcTTFEjX3cbx+invXwk+i3V8VhCGU35lNQVO/pvvy8Xq+7StjyddAjeDLrMHap5afORxz4HfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iBEJic9JCq8dvkbH62QbqiH9JD2RBGDS67skNGGuIzc=;
 b=UuVSnfr2GF6VWNDW592LMhmenw3v0w0Nurq7Sd5GT2w1VW8fsJm59yruXG3GWFNsR1PJpLdeXhXK6tg88ckkmV37nHRgSLHnyl053CN9IZ+9HCjS0tpD9tiU6pF4BqWRReeMOw3nFAVUSakQIp4z3KXxJKebHo/lT40TaJ9HeyY=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS0PR01MB5844.jpnprd01.prod.outlook.com (2603:1096:604:bc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Mon, 4 Oct
 2021 13:12:23 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 13:12:21 +0000
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
Subject: RE: [PATCH 05/10] ravb: Initialize GbEthernet DMAC
Thread-Topic: [PATCH 05/10] ravb: Initialize GbEthernet DMAC
Thread-Index: AQHXttX98IVMPc8eo06bCvpsOJ39GavCzDuAgAADyuA=
Date:   Mon, 4 Oct 2021 13:12:21 +0000
Message-ID: <OS0PR01MB5922A72D9E04C359C64ACE4486AE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
 <20211001150636.7500-6-biju.das.jz@bp.renesas.com>
 <58ca2e47-9c25-c394-51e5-067ebaa66538@omp.ru>
In-Reply-To: <58ca2e47-9c25-c394-51e5-067ebaa66538@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 189b1ee4-b40f-4bd0-d7fb-08d9873899cb
x-ms-traffictypediagnostic: OS0PR01MB5844:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS0PR01MB5844ACEC1E966030D6316D7186AE9@OS0PR01MB5844.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ydW2tJ8rc4sGHN2h4QI7vxXUpPtanr5KqFxfIIUl/lda9TSBS3DnQnWsBb0xtk+UyB8qUCg1RcqCv41cgWYYiQCdjS/YeAu7+ZauTErAFUpGxUgCxNDJQVXmxluF0xh5hE55SELcxucJjFnaLyycStLMmgmO/6ziyhkpPHPEu+UM4vIGRlFvSVKYR2VwlBlvtTswEN+j1O0B3egCyNTWRo3s5bUy1GvK6VjTYXRF3iR4hMyn0HBs8fk3WcDBBNJSlxaYdtONGtnYtNsjfLhk8/m/3yfRTYGC4qnwRZmVP6SVi/ug60RrKneZFZ6F0/TWAB4PTbR2z0MwK8+rnY4nipRtM8pSHY7JGKeVtKkppIw0y59hx9nPRnVreD76Co0ZyuvXOsjbTgNDapUlZgABApDPEUBFpT4QIvXELvvGdEKzdQtx+w4TiIKXDwUi41TiOA+Ot711fRyk0Mr5bAfk5ZohwrMFepA6u/vlhN9CZuVaHYMI+KL4Q8VLMxX8ra8yXx5wcTILKL9UFZHL5FTJmeHL0arqF+bcmPhWDfdGaLl9ctsatI6rYEULiK4xADKHaZlMsJUEeJ9x961ByodIW2IzVw8tsZZXLf9NIME4UZJGuVheMq/lKSa8RODltqPNcuixjmR8T3zMcA7wRhT/Pz+BriOvNNlSOJPQ1crSp8jPHYz2Co/OuiZGPoJtzunrne9Vzeo4lpNayubzbGo3PA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(6029001)(4636009)(366004)(8676002)(4326008)(7416002)(54906003)(2906002)(5660300002)(110136005)(52536014)(6506007)(53546011)(508600001)(107886003)(186003)(55016002)(7696005)(9686003)(26005)(316002)(71200400001)(8936002)(38070700005)(38100700002)(76116006)(86362001)(122000001)(33656002)(83380400001)(66946007)(64756008)(66476007)(66446008)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OFYzV1c3bHkxRXR0Z2Z6N0pIY2lYc21qeDF4QktCbVRmTzAxT25zVTZWdTRT?=
 =?utf-8?B?b21FeFVadEFlYmxvK3paVWxPRnJ3WFBMb1Rpbmk0bVBJWXBkbXh4UC9FK3Vm?=
 =?utf-8?B?NVRuMnJ0aHpSTVVUUmw0eUUrZ3lzT3hFOHJTTUhlYnNkUU1JczZBek9LYTZT?=
 =?utf-8?B?U2pVNHRLcjBzbHJZbkF1MWpsQ3I1L0c4eHZrOUcvYTVsT1llL2srK3U4NmRP?=
 =?utf-8?B?c1R0dEo5NkRCWHE2T3FLQURYVlYvM3FLQU1XY0E5ZWw0TVE1cWZxc1FBb2dy?=
 =?utf-8?B?V3BxaXowdWI0NE94UGZkRkQxQURlbm5vQzZxRUxjNjRqTnlxSytTTll2aUIx?=
 =?utf-8?B?Wndsb3U4dHZ2cTlVbmIyZ2hLYy9GbTlGZFpMSU1FemJ5ZlRGU05wamkvS2Nt?=
 =?utf-8?B?cHgzQjBNY1hkakVqRDY4R0ZLT0FNRURKSHQxWWRwTVV6bWY0cjJNdElNRkta?=
 =?utf-8?B?dmFrdzQzZHpWcXkwa0d3blNkL1lQVTlpS2NGMW10Rk5wTEtGOU9hdFdKRVNs?=
 =?utf-8?B?a2Z3a1Z5MGlwbUVuWmZWdFNFancyMVdGQldLT3hxSVo3NlZJMHQ3MGptZUZj?=
 =?utf-8?B?L05lQnU2RDRheDFETitrMG1vd240b1ZxUXBZbEZxYWhDOVQyb05qOW0rZC9P?=
 =?utf-8?B?SDdxUFR4akl2MEVyMC96V2k2enlvUmRoVTVyUEpYQ2Q3U252NjdtOWRuWEcr?=
 =?utf-8?B?SzE0YlNIWHVHbXQ5OTVSV2k0MFRtellnTXovYWtjbW1WRnh5K2ZPL004bFpW?=
 =?utf-8?B?ZkEwU09hYlZNNWVKMFkzT3JraHkzZnpYa25yYzBKalU0TXkxalFSMkNjS1Nq?=
 =?utf-8?B?ZmRXeHpxODhaK3ZSUVA5MnpaMEFxWTE1aWljQk55R1NiR1pFMjNuaUxTTlpz?=
 =?utf-8?B?dW10cC92VytHZWVJcUN3UW1Wb1o0cmtiMnlST0dvamZQdjhyaDBqZU9GZmZ4?=
 =?utf-8?B?Q3FvdWZFYVBzZ0xGaGxvcy9NNE1qbTh3UXlMdXF3ZjBYSnVqOUpIRFBpYUwx?=
 =?utf-8?B?Ly9Wd2YyWGIxZzdUQ0tXYTB5UmQzc2U0azVvRUdjRTlmaVd4WFMrb0NuOThh?=
 =?utf-8?B?K3RSaVRzNDJMTEZWNmtIRS9jQlJaTlRCdjdFU2J3UzdISWVQQnFsZllydHVV?=
 =?utf-8?B?b0FlNVd0MC9iVkdYSkNKcGRVRVhZR2s5bzU2aHFyMlIrSXQ0d1hFaVkxVUxH?=
 =?utf-8?B?N1hTVmFkRlVvelcrTDU4MFdCdDI2bm5uYmw1dU9UMW9YdXFud0hqa3JDd3JZ?=
 =?utf-8?B?Q2Fhb0VQRnJUNlR5ZkJ2ZG93aVJETysrVStYc2VLTklSdUVtUTZZNVFVbHZu?=
 =?utf-8?B?andraklmNTBnWGlNNG0vOERuUElNTkNYSkFkQWJXSUxNMDBrM1haWmo2OHdL?=
 =?utf-8?B?citFemR2c1ZabFIwMTdocmV0ZnZxTldjaTdPWUg0RGRGWGxXeVRpeTM4azNI?=
 =?utf-8?B?UExlelZRYzY4UFdhUWZUeG9kdEg1a0d2SWN1ZGRwbDJSKzgwM3BUM3ZDZ1dr?=
 =?utf-8?B?ZHQrNGVVelR2T0R4ZzFZSUV4MURJd3lXYnMrOTN4MS9RaVRDMXI3TWxHcjBh?=
 =?utf-8?B?K2hCd1pxeHlnbUw2TE1Hb1RRZVZwUDBJYXV4OE5LTDN4Tk00UmdtM1gxNURG?=
 =?utf-8?B?eE02WG9MYm8yQUxJajNPL2JxVEpoRGVaUHZlelRzanNKWFRUb0l3R29ZUExl?=
 =?utf-8?B?T2JOZWpwWGN5TjYzNUhBaS9ic2tpTDVNenRhZ3BPN2VjbkRacUc3dTRTajNm?=
 =?utf-8?Q?kfLEaoYnlD0Am0zSYo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 189b1ee4-b40f-4bd0-d7fb-08d9873899cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2021 13:12:21.5945
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: paXRSYoQBco2JWIiC9TQI2He0/5qqLrI8hJZ+8JuT2Lra5jJfZ/Dah2nWvX3uDBez6JP5iaPrKRA61A/qrVbc5iXVGSZhAo/bdA32UeDsCk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB5844
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBTZXJnZXksDQpUaGFua3MgZm9yIHRoZSBjb21tZW50cw0KDQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggMDUvMTBdIHJhdmI6IEluaXRpYWxpemUgR2JFdGhlcm5ldCBETUFDDQo+IA0KPiBIZWxs
byENCj4gDQo+IE9uIDEwLzEvMjEgNjowNiBQTSwgQmlqdSBEYXMgd3JvdGU6DQo+IA0KPiA+IElu
aXRpYWxpemUgR2JFdGhlcm5ldCBETUFDIGZvdW5kIG9uIFJaL0cyTCBTb0MuDQo+ID4NCj4gPiBT
aWduZWQtb2ZmLWJ5OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+ID4g
UmV2aWV3ZWQtYnk6IExhZCBQcmFiaGFrYXIgPHByYWJoYWthci5tYWhhZGV2LWxhZC5yakBicC5y
ZW5lc2FzLmNvbT4NCj4gPiAtLS0NCj4gPiBSRkMtPnYxOg0KPiA+ICAqIFJlbW92ZWQgUklDMyBp
bml0aWFsaXphdGlvbiBmcm9tIERNQUMgaW5pdCwgYXMgaXQgaXMNCj4gPiAgICBzYW1lIGFzIHJl
c2V0IHZhbHVlLg0KPiANCj4gICAgSSdtIG5vdCBzdXJlIHdlIGRvIGEgcmVzZXQgZXZlcnl0aW1l
Li4uDQo+IA0KPiA+ICAqIG1vdmVkIHN0dWJzIGZ1bmN0aW9uIHRvIGVhcmxpZXIgcGF0Y2hlcy4N
Cj4gPiAgKiByZW5hbWVkICJyZ2V0aCIgd2l0aCAiZ2JldGgiDQo+ID4gLS0tDQo+ID4gIGRyaXZl
cnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oICAgICAgfCAgMyArKy0NCj4gPiAgZHJpdmVy
cy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYyB8IDMwDQo+ID4gKysrKysrKysrKysr
KysrKysrKysrKystDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwgMzEgaW5zZXJ0aW9ucygrKSwgMiBk
ZWxldGlvbnMoLSkNCj4gPg0KPiBbLi4uXQ0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9y
ZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gaW5kZXggZGM4MTdiNGQ5NWExLi41NzkwYTkzMzJlN2Ig
MTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4u
Yw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4g
PiBAQCAtNDg5LDcgKzQ4OSwzNSBAQCBzdGF0aWMgdm9pZCByYXZiX2VtYWNfaW5pdChzdHJ1Y3Qg
bmV0X2RldmljZQ0KPiA+ICpuZGV2KQ0KPiA+DQo+ID4gIHN0YXRpYyBpbnQgcmF2Yl9kbWFjX2lu
aXRfZ2JldGgoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYpICB7DQo+ID4gLQkvKiBQbGFjZSBob2xk
ZXIgKi8NCj4gPiArCWludCBlcnJvcjsNCj4gPiArDQo+ID4gKwllcnJvciA9IHJhdmJfcmluZ19p
bml0KG5kZXYsIFJBVkJfQkUpOw0KPiA+ICsJaWYgKGVycm9yKQ0KPiA+ICsJCXJldHVybiBlcnJv
cjsNCj4gPiArDQo+ID4gKwkvKiBEZXNjcmlwdG9yIGZvcm1hdCAqLw0KPiA+ICsJcmF2Yl9yaW5n
X2Zvcm1hdChuZGV2LCBSQVZCX0JFKTsNCj4gPiArDQo+ID4gKwkvKiBTZXQgQVZCIFJYICovDQo+
IA0KPiAgICBBVkI/IFdlIGRvbid0IGhhdmUgaXQsIGRvIHdlPw0KDQpHb29kIGNhdGNoLiBJIFdp
bGwgdXBkYXRlIHRoZSBjb21tZW50IGluIG5leHQgUkZDIHBhdGNoLg0KDQo+IA0KPiA+ICsJcmF2
Yl93cml0ZShuZGV2LCAweDYwMDAwMDAwLCBSQ1IpOw0KPiANCj4gICAgTm90IGV2ZW4gUkNSLkVG
RlM/IEFuZCB3aGF0IGRvIGJpdHMgMjkuLjMwIG1lYW4/DQoNClJaL0cyTCBCaXQgMzEgaXMgcmVz
ZXJ2ZWQuDQpCaXQgMTY6MzAgUmVjZXB0aW9uIGZpZm8gY3JpdGljYWwgbGV2ZWwuDQpCaXQgMTU6
MSByZXNlcnZlZA0KQml0IDAgOiBFRkZTDQoNCkkgYW0gbm90IHN1cmUsIHdoZXJlIGRvIHlvdSBn
ZXQgMjkuLjMwPyBjYW4geW91IHBsZWFzZSBjbGFyaWZ5Lg0KDQoNCj4gDQo+IFsuLi5dDQo+ID4g
KwkvKiBTZXQgRklGTyBzaXplICovDQo+ID4gKwlyYXZiX3dyaXRlKG5kZXYsIDB4MDAyMjIyMDAs
IFRHQyk7DQo+IA0KPiAgICBEbyBUQkQ8bj4gKG90aGVyIHRoYW4gVEJEMCkgZmllbGRzIGV2ZW4g
ZXhpc3Q/DQoNCk9ubHkgVEJEIChCaXQgOC4uOSkgaXMgYXZhaWxhYmxlIHRvIHdyaXRlLCByZXN0
IGFsbCBhcmUgcmVzZXJ2ZWQgd2l0aCByZW1haW5pbmcgdmFsdWVzDQphcyBpbiAiMHgwMDIyMjIw
MCINCg0KUmVnZHMsDQpCaWp1DQoNCg0KPiANCj4gWy4uLl0NCj4gDQo+IE1CUiwgU2VyZ2V5DQo=
