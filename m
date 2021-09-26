Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E54F34186BA
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 08:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbhIZGgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 02:36:38 -0400
Received: from mail-eopbgr1400113.outbound.protection.outlook.com ([40.107.140.113]:21862
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229592AbhIZGgh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Sep 2021 02:36:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hhRYvA2WYEYK452EINyzg1S54aDl8vUGEH7njG/VXGnlrdeX3xl5IZle9FhbFbQlRVAqN8ZiQwPMB+M7wZcYTtZC+ptwO6Zd6dzIDE1tzFMRy0Ms8yYZ9M0lcLae72lJRNiy9bXVjG+Q568A96o2fIA3ohGJbg7wcgZ53chR4T9jTjsV5hHK93gH8GNmrBuSqbZ028mVQPWKqg9UZdEPwhdVMOIF24bS/u0h5yTWFApezFe5816v1V2qgK047zcpxhIUEdUttKw1Ldy9W6UM7STNyFscpSaxCHnqf2w6WWWPCfulE/h18kD75tbjPM45B2OZxrBP1k8UyAxrVHSIVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=PYwwHZamuFPJq2Ihzq8QpffVbEdunZxUCbNe3MBk4Q0=;
 b=JtVjZFRZdOBbN2LkdrZQTZW3pQA5SFarcstV6dTtieC4wUSEWGtxQ7J5GYj407TqMhQ9bSZ/Uwdx1szlYL9nOMrcNqawBlkfJrQRMycDCaerkNJA9Sg6vsh+VaemRSRCjnNDPZfMu7gyCo34hErtjTqHN4bSx4mJZ1J7FXy3KxQRVmBgv/agPqCpqUmCPeRDMrByf3a21xWd9qF02enC9NAoUu5mKAR10Hdc2+UIAudMXsMXHoGE+yEK5qihpTUoYZJTV8QVlqeCSvNYLaRkUpSI5qhn2kaUIKE+DxEcdrDhzArsJJxGFvH6FooG1Ea5Et6DlBtmmPgut//fh9pq0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PYwwHZamuFPJq2Ihzq8QpffVbEdunZxUCbNe3MBk4Q0=;
 b=CaTNpKMo5Kbul4Yui9G6EzMrC8PWYRAo2DT+was8IUgMMCtusEAX3jsW9Ccv0y3JLIADUsnokYw4Zh8/Qc2CLuLbcqe0TppvSDIovZYdFG83H1DxQXaisYHA9isV9+0tCHz6i72ELz+Klu4Yb31AXSXkdLg1cICG3vdTArwLgLM=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB3304.jpnprd01.prod.outlook.com (2603:1096:604:45::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Sun, 26 Sep
 2021 06:34:56 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::8f9:8388:6090:4262]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::8f9:8388:6090:4262%7]) with mapi id 15.20.4544.021; Sun, 26 Sep 2021
 06:34:54 +0000
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
Subject: RE: [RFC/PATCH 12/18] ravb: Add timestamp to struct ravb_hw_info
Thread-Topic: [RFC/PATCH 12/18] ravb: Add timestamp to struct ravb_hw_info
Thread-Index: AQHXsISOUUpjeBVcoEe6exCe5Ob9S6u1PXqAgACeaaA=
Date:   Sun, 26 Sep 2021 06:34:54 +0000
Message-ID: <OS0PR01MB5922426AACFBDF176125A9AF86A69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-13-biju.das.jz@bp.renesas.com>
 <ef7c0a4c-cd4d-817a-d5af-3af1c058964f@omp.ru>
In-Reply-To: <ef7c0a4c-cd4d-817a-d5af-3af1c058964f@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 350ee78c-69d0-4f7c-925f-08d980b7c070
x-ms-traffictypediagnostic: OSBPR01MB3304:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB3304EB04DFE3FF4BF60900B786A69@OSBPR01MB3304.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8gMeZ1XmPkdcJQqHgoixzdfkRNhgZXYTi8hqJCh33Iwd2qegl/CCBDADFmF5bddqYXumxSNCBzwHavsXPqKj2bmqyhSgrnVfSb0ICSuag+Wn6UG+JELuUI0ObYyoATaxbXz1hi1bHcmLjq9hN10l71N4Y9ju3GXNgKaE/gMsBfwLC+us+MSvGbnLbvYVkOjrH58NjLgJbeiLjjJeTm/76SHrdAYN2dELh5pkZqNwD2R2c/bKQDRiVzjsgBMwt/qzkH5NqceawaBONwpcifcCZEqMAy2UYv28LArjL7kWVVWhCli3+JeyXhRcsDDJ/VTI2Z1fkkbfaxrBo782zMQs2OYOEK6M5P3QOiN6puVEnU51ARv4jSYNVum7dya8wHfLBo+DCXLto1CNRjWDe3uT6xJ6sE7s7yLkQKMFfh31s5LlqT2Nk3QMlLbulZJXfDqwQL0l7yvKChb87DnCaynquFEgWLetDW0zJ5mBahCgYMb3EU/qxsJyywvhR1Cw/kTDgMxByPBYWftUk1N2kEpPQWwLKKhsCr8tFtN6xe2H0osu4LA02uQDGTeQX5HJRTHOlMIo9xdrvnuUoUDGAXYAX2mMYBp/Ne7ufsI/ijl5yNwMaVzsX2iE6UxaJEEnvQcnGyJO32RKSCs2MAIfNhvkhxtY+l3lenLla8HRA+ILQAMmV4jra1BKapxKRHKIJHsxFVbBud2FSZHRlDKcycrI8g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(107886003)(86362001)(6506007)(52536014)(2906002)(8676002)(38100700002)(71200400001)(122000001)(8936002)(5660300002)(33656002)(76116006)(53546011)(83380400001)(110136005)(9686003)(7696005)(55016002)(186003)(26005)(54906003)(66946007)(66476007)(64756008)(66446008)(316002)(38070700005)(66556008)(4326008)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a2lRbGFTeW1DZjA3YWV0Q1RvYVNOSlIrZnhhZzZXaGxaSWxrczN0R2xVSFow?=
 =?utf-8?B?dHRWdUtQN0xEaDZvZEpUN0dYb3hEMmZsVnp0RHhRTXVBSUJkT2lodnpJQ3dq?=
 =?utf-8?B?OG1acU1NUU9nWldDSUdQZ1F6ZmRYbllPeExHQzkzNnRWUkRHM0JvRUF2b0FZ?=
 =?utf-8?B?clE3WmF6QWc1YVlGbWFTY2FWUmtzUlVVd2RFbFBNRFA5ZnA4VXZEa0RyREtr?=
 =?utf-8?B?SlhUSi9VK2lXWXBKbUExa2l0WVBGZHprUC8rTnBLRVZ5Z0UvSzlVOGlKMitm?=
 =?utf-8?B?NEZ3RnZyd3FYWDdLN2VkSTkrbGxSYmJJd0s0ejczOWxTbDV2VDF5TGFJakht?=
 =?utf-8?B?YVNLODFjVFgwblAyVXVYcStMOCtuY1BVNkhlQ1hITFlscnpyVDlLVzBkMFF4?=
 =?utf-8?B?VGpGcjFMT01DSVJLTzFObi9jNWxWWFVCYUdjd1IvdjdHMkhia0tzVGRqcGhH?=
 =?utf-8?B?aE5KWVkyVlFlRkIwY0N1NmhWK3BCaGxlSEVUV2x4U09qdzhrbFNjU0J5Y1p6?=
 =?utf-8?B?dGczY2IyOW1Gb1NXSklzS2FUL1BVYWR5SXdZOURQd0NGWDNUT1F3WXV2ajY2?=
 =?utf-8?B?TnNlcVMrVmRBYXloMUliQnZpUVk0Q21NdW1mWGpRL2RUTlpZZ0JoWStIRWsv?=
 =?utf-8?B?TVczQnNjcXlJY0EwaWM4amp0cU1pcVA4ZGkrY2dsWDVDMHY2UjVwZ3RJd2Z2?=
 =?utf-8?B?cnlPcG9XRXdWQU1RcjQvWXNjWW1wUUlJVGJVRHBzam91Nkd0dmVoTWtKV0JF?=
 =?utf-8?B?WFpEV3B5RmloM25kd0F3T1NaaEtLRGkxSlF6Z0JRWkJLRDN4WHdlcnpUMFBp?=
 =?utf-8?B?bitsYmdmRGh5anVMYUl0RC9LTFNFMklabTM2TzBUeDd4NGNqOS9KLzV1eVBy?=
 =?utf-8?B?YnpXSjNXWmJ6Z1U4U3FPQXlScnNUNmsvU0hVNmhOa2dyUGNuUTJ6ZEpjbHpF?=
 =?utf-8?B?SlB0SmRNenRTb2J1OFBwTmpBSzhMYWwvTXEvNm1ObFphQ0ROSGFxWjJsYnFV?=
 =?utf-8?B?c1lIUDhIN2JWbnhZYXZsOVhpaFBuWk02Sm1CUG1YM1pxbHlCb2xCM3NYSTZ0?=
 =?utf-8?B?U0xadWt5cWgzbkZDTDZqVzV4aFdCbnN2WFB2RyszeUZzcWpPbUtaUDZBbGFk?=
 =?utf-8?B?anYvNHhSTmdBbHNpTFBOR3g5ZjdDNHpnS0VubHRuN1R6c3R2R2d1dEtMUnox?=
 =?utf-8?B?QjdrY1dua3puQkVBMUUxd3I1alNjRWxwVFhLUnFHTEd1TmMycVlQUXpYZlJG?=
 =?utf-8?B?T2h5ajFvSVUxN2tWVkhJd3FhbFk0SkcxSngrOHNZcXpQTWxxNmdZNU0rRTdO?=
 =?utf-8?B?M0ZnRU4yb20zUUNxQkMwTXdPalNWQTJTaXRFTHRYaU0rcEFwTUFCS0k0M2g2?=
 =?utf-8?B?NmxGMWNnUkVxUlIvRWdYZFVaMXRmbHkrMkk5N1V2TFZBMmcycktpN3FoZkp5?=
 =?utf-8?B?SFFqWkM1bDEyK2RpSkwxY2c1UWZZSEJVVU8ramhPRS9IU3diUWcxOHhFc2Rh?=
 =?utf-8?B?QW5zdFQwRHRmTEpiWUJVbkY2Zk9SSTFyVU44UVdXM3YzblY2ZEFUMWhjOHNL?=
 =?utf-8?B?WWhCTkpOUmxMd0JGSTdYZ3k3V3BPZ0ZFY0M3bTNvNklhR3laYW5YRk1CZ0d0?=
 =?utf-8?B?bzZnRFc1VTZBWEY2QXljR0hzbjM1WENubzZFTmVjREl6VlJTUWozSndGSURJ?=
 =?utf-8?B?cDFjM1lFYXI0aW1QM0dVcTFWTHpmdHZRNGphK3d4TkROc2xDWlNqaHhhVzA3?=
 =?utf-8?Q?YOP0xv7lMCC7vOXDl/r4OcUWUY4aawT2+Wy2/v/?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 350ee78c-69d0-4f7c-925f-08d980b7c070
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2021 06:34:54.3588
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5xomoaQH64bWu7kcw9ce+btV0rawGXuTk4fi13Us1urWiAhFccuoJH8OCKkGh8W7q6nDfTVJxH+0Q1jhl2RbtMa4Fl0hAzqGfK0t3zKn4Ao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB3304
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SEkgU2VyZ2VpLA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiAtLS0tLU9yaWdpbmFs
IE1lc3NhZ2UtLS0tLQ0KPiBTdWJqZWN0OiBSZTogW1JGQy9QQVRDSCAxMi8xOF0gcmF2YjogQWRk
IHRpbWVzdGFtcCB0byBzdHJ1Y3QgcmF2Yl9od19pbmZvDQo+IA0KPiBPbiA5LzIzLzIxIDU6MDgg
UE0sIEJpanUgRGFzIHdyb3RlOg0KPiANCj4gPiBSLUNhciBBVkItRE1BQyBzdXBwb3J0cyB0aW1l
c3RhbXAgZmVhdHVyZS4NCj4gPiBBZGQgYSB0aW1lc3RhbXAgaHcgZmVhdHVyZSBiaXQgdG8gc3Ry
dWN0IHJhdmJfaHdfaW5mbyB0byBhZGQgdGhpcw0KPiA+IGZlYXR1cmUgb25seSBmb3IgUi1DYXIu
DQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNh
cy5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5o
ICAgICAgfCAgMiArDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWlu
LmMgfCA2OA0KPiA+ICsrKysrKysrKysrKysrKy0tLS0tLS0tLQ0KPiA+ICAyIGZpbGVzIGNoYW5n
ZWQsIDQ1IGluc2VydGlvbnMoKyksIDI1IGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+IGluZGV4IGFiNDkwOTI0NDI3Ni4uMjUwNWRl
NWQ0YTI4IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2
Yi5oDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiBA
QCAtMTAzNCw2ICsxMDM0LDcgQEAgc3RydWN0IHJhdmJfaHdfaW5mbyB7DQo+ID4gIAl1bnNpZ25l
ZCBtaWlfcmdtaWlfc2VsZWN0aW9uOjE7CS8qIEUtTUFDIHN1cHBvcnRzIG1paS9yZ21paQ0KPiBz
ZWxlY3Rpb24gKi8NCj4gPiAgCXVuc2lnbmVkIGhhbGZfZHVwbGV4OjE7CQkvKiBFLU1BQyBzdXBw
b3J0cyBoYWxmIGR1cGxleCBtb2RlICovDQo+ID4gIAl1bnNpZ25lZCByeF8ya19idWZmZXJzOjE7
CS8qIEFWQi1ETUFDIGhhcyBNYXggMksgYnVmIHNpemUgb24gUlgNCj4gKi8NCj4gPiArCXVuc2ln
bmVkIHRpbWVzdGFtcDoxOwkJLyogQVZCLURNQUMgaGFzIHRpbWVzdGFtcCAqLw0KPiANCj4gICAg
SXNuJ3QgdGhpcyBhIG1hdHRlciBvZiB0aGUgZ1BUUCBzdXBwb3J0IGFzIHdlbGwsIGkuZS4gbm8g
c2VwYXJhdGUgZmxhZw0KPiBuZWVkZWQ/DQoNCkFncmVlZC4gUHJldmlvdXNseSBpdCBpcyBzdWdn
ZXN0ZWQgdG8gdXNlIHRpbWVzdGFtcC4gSSB3aWxsIGNoYW5nZSBpdCB0byBhcyBwYXJ0IG9mIGdQ
VFAgc3VwcG9ydCBjYXNlcy4NCg0KPiANCj4gWy4uLl0NCj4gPiBAQCAtMTA4OSw2ICsxMDkwLDcg
QEAgc3RydWN0IHJhdmJfcHJpdmF0ZSB7DQo+ID4gIAl1bnNpZ25lZCBpbnQgbnVtX3R4X2Rlc2M7
CS8qIFRYIGRlc2NyaXB0b3JzIHBlciBwYWNrZXQgKi8NCj4gPg0KPiA+ICAJaW50IGR1cGxleDsN
Cj4gPiArCXN0cnVjdCByYXZiX3J4X2Rlc2MgKnJnZXRoX3J4X3JpbmdbTlVNX1JYX1FVRVVFXTsN
Cj4gDQo+ICAgIFN0cmFuZ2UgcGxhY2UgdG8gZGVjbGFyZSB0aGlzLi4uDQoNCkFncmVlZC4gVGhp
cyBoYXMgdG8gYmUgb24gbGF0ZXIgcGF0Y2guIFdpbGwgbW92ZSBpdC4NCg0KPiANCj4gPg0KPiA+
ICAJY29uc3Qgc3RydWN0IHJhdmJfaHdfaW5mbyAqaW5mbzsNCj4gPiAgCXN0cnVjdCByZXNldF9j
b250cm9sICpyc3RjOw0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5l
c2FzL3JhdmJfbWFpbi5jDQo+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJf
bWFpbi5jDQo+ID4gaW5kZXggOWMwZDM1ZjRiMjIxLi4yYzM3NTAwMmViY2IgMTAwNjQ0DQo+ID4g
LS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+ICsrKyBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiBAQCAtOTQ5LDEx
ICs5NDksMTQgQEAgc3RhdGljIGJvb2wgcmF2Yl9xdWV1ZV9pbnRlcnJ1cHQoc3RydWN0DQo+ID4g
bmV0X2RldmljZSAqbmRldiwgaW50IHEpDQo+ID4NCj4gPiAgc3RhdGljIGJvb2wgcmF2Yl90aW1l
c3RhbXBfaW50ZXJydXB0KHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2KSAgew0KPiA+ICsJc3RydWN0
IHJhdmJfcHJpdmF0ZSAqcHJpdiA9IG5ldGRldl9wcml2KG5kZXYpOw0KPiA+ICsJY29uc3Qgc3Ry
dWN0IHJhdmJfaHdfaW5mbyAqaW5mbyA9IHByaXYtPmluZm87DQo+ID4gIAl1MzIgdGlzID0gcmF2
Yl9yZWFkKG5kZXYsIFRJUyk7DQo+ID4NCj4gPiAgCWlmICh0aXMgJiBUSVNfVEZVRikgew0KPiA+
ICAJCXJhdmJfd3JpdGUobmRldiwgfihUSVNfVEZVRiB8IFRJU19SRVNFUlZFRCksIFRJUyk7DQo+
ID4gLQkJcmF2Yl9nZXRfdHhfdHN0YW1wKG5kZXYpOw0KPiA+ICsJCWlmIChpbmZvLT50aW1lc3Rh
bXApDQo+ID4gKwkJCXJhdmJfZ2V0X3R4X3RzdGFtcChuZGV2KTsNCj4gDQo+ICAgIFNob3VsZG4n
dCB3ZSBqdXN0IGRpc2FibGUgVElTLlRGVUYgcGVybWFuZW50bHkgaW5zdGVhZCBmb3IgdGhlIG5v
bi1nUFRQDQo+IGNhc2U/DQoNCkdvb2QgY2F0Y2guIEFzIHJhdmJfZG1hY19pbml0X3JnZXRoKHdp
bGwgYmUgcmVuYW1lZCB0byAicmF2Yl9kbWFjX2luaXRfZ2JldGgiKSBpcyBub3QgZW5hYmxpbmcg
dGhpcyBpbnRlcnJ1cHQgYXMgaXQgaXMgbm90IGRvY3VtZW50ZWQgaW4gUlovRzJMIGhhcmR3YXJl
IG1hbnVhbC4NClNvIHRoaXMgZnVuY3Rpb24gbmV2ZXIgZ2V0cyBjYWxsZWQgZm9yIG5vbi1nUFRQ
IGNhc2UuDQoNCkkgd2lsbCByZW1vdmUgdGhpcyBjaGVjay4NCg0KUmVnYXJkcywNCkJpanUNCg0K
DQo+IA0KPiBbLi4uXQ0KPiANCj4gTUJSLCBTZXJnZXkNCg==
