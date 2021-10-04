Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AADA84206D1
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 09:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhJDHvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 03:51:21 -0400
Received: from mail-eopbgr1400137.outbound.protection.outlook.com ([40.107.140.137]:29664
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229505AbhJDHvT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 03:51:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n6V+DmfLmgKm36MKYOnZCPbwNjywDDfqrGDfOKqJbIL+fd33RimZnpmErqj3labZmX7Fxg4bELWykEPZEwetND0nW6VImVZCGoBqeh77j4HWPy6lGYiNMg9ZR4Rw/TlbPqsEPM2tZ4Sm/EyFQyGIZS0JyztRPP/B4OWUBckPGA3ZJmSmq0JuRafxhoLaZOR2/J9aH9gFLwMp+O8pUX9VxZU2Jj0XkY0un1DLi8NvFh7rWq7wuzvrOTFQDRkkXwMRyNnzkwyWh3sw1FSg8XFtxBut1BPWdpICH4DHlGg862BT+0K2DSiiONdGErjt55mmoylp+CJFqMk0mjWHqIQEVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ytL1CfBB8ZZVAbgW53dPien67BW+3s+RNtRR5rqkgVY=;
 b=i6k3t74K0qvvg31NkKn3ajbSg+J6GqGb8h3cfIJ+ohR5Tv3fP1clY1EdwV8l/4rg6mGiEjFQJHPfYo0lf/zU6PEhm9x8FP9DZ3BNFL2JQ6p4SRwroFU7zGAY3gPWvetOcEYGIwhAlHaUNn7fhNU05pYqstvxrGmJ9aOTKpcNxylfWSjm1h6TyC1qiwhJQxqXA9X1tPc1gEYGc8PK+LCDvKZAfwTY1+H8oxT1JNPcTtAQrlfqclIxyTk0K/EXYlgk/S3Ds8a9JRQaRy7H58LneOICG64BY8TQ6BALpEmDef9VNpkz5ORdJrfSrkwUrkbD+QeaWbeVPgl+ApTMIbUmRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ytL1CfBB8ZZVAbgW53dPien67BW+3s+RNtRR5rqkgVY=;
 b=sEvmax/re6BqT2hCGpooQqL8Y0pqsXWwb/GukWAL7HjIvNQFSF0IZ1ppf7v/XZ/CBK3AYmn0pTaIGeGPvqDHVfn4hd+AstaMbTlfHARaoLzz5yVa911DfRWrckCs2OKp0GvScNSh5lba8ksVqxSxfYJyM8zsO5KgOowJRwDOJKA=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB2740.jpnprd01.prod.outlook.com (2603:1096:603:3a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Mon, 4 Oct
 2021 07:49:27 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 07:49:27 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
CC:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
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
Subject: RE: [PATCH 04/10] ravb: Add support for RZ/G2L SoC
Thread-Topic: [PATCH 04/10] ravb: Add support for RZ/G2L SoC
Thread-Index: AQHXttX7hUtu3PiXEk+gzpGHHZtaNqvAHb6AgAC5mMCAAZjcgIAAASuQ
Date:   Mon, 4 Oct 2021 07:49:27 +0000
Message-ID: <OS0PR01MB5922532F81F63129BD8F1BB386AE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
 <20211001150636.7500-5-biju.das.jz@bp.renesas.com>
 <b4c87a6d-014f-0170-feb5-20079c7d5761@omp.ru>
 <OS0PR01MB59224497C081231E9CC334B986AD9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <CAMuHMdXSeCA+27xiXAgwRUi4wFukXkrttTvnEGhZAtq7p_trCw@mail.gmail.com>
In-Reply-To: <CAMuHMdXSeCA+27xiXAgwRUi4wFukXkrttTvnEGhZAtq7p_trCw@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux-m68k.org; dkim=none (message not signed)
 header.d=none;linux-m68k.org; dmarc=none action=none
 header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f1c3455c-c83f-4d9a-e38e-08d9870b7ded
x-ms-traffictypediagnostic: OSAPR01MB2740:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB2740F569989FA0DC05F6BEAB86AE9@OSAPR01MB2740.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ydT6lgAxCOYfIckEen8aeX+zqbjrRP4Fy5jmqZ1V/DSzQKyP4Whh2oGuwP4qQG0eJT+Vl5UKoudrlyLgiKSBZOSW4sl/LqxUkncH27Lolgj70uaaYGpyXEQI2k3xeLK8FXW00UCG4GyKx/D+9Y+3HT9vt8oit/DQWlJFPZQYrcWxvKPbtwcX2/KLvYE+9yMg5m0QVZEF+MucCHVs6RJaq+m6YO5ZfksGNKJGB8kx8My56ShEKn/Ul6mzfy8qGLGvh5XbTblBKstQFvOW5XklyEuR5LY0l9w4b/geUE5PRRsnAT+bsvqhQciMbxMAwiVXliUENbXU5rkgwcyZ8r8kMtaTcz/WEF869VQWW2lkrKOaHsxj2nvFb59W3ONnVEN/6tLcf8+SlXqTeB1DXzfDDgnaMsyoOcWT0Ir6TW9K2KXt2qcoUEI3PIzpQ+qCJlsHerUpnu/qD1o+BVhWCyC8x+cqk8tZiNeqDFkw1m0X752vnhPjcgZ5D2W1TOVoUijTz0f8yawoSPy+oz/06lozxlNUkzkSNtluRuWIYCG+MeMWNKsFz9B1bJDXYeRkHo+Sk03uRW5zyybZCUVwyrGHMEZCJRyVYYQSsBpFegj5Q053D6qEH1ev1GWpABDyFVJAw6/7Uikbv3DDWRLsCOMKTlEyNWpnObyx/qmRAaPnKfJRCEPE8KJhtRjXgTRQ/jDSjNA2Kfj2s6rE0B35aVFvaw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(26005)(5660300002)(316002)(107886003)(7696005)(6916009)(508600001)(186003)(38070700005)(122000001)(76116006)(33656002)(83380400001)(71200400001)(38100700002)(66946007)(9686003)(52536014)(55016002)(53546011)(6506007)(66476007)(4326008)(64756008)(66556008)(66446008)(8676002)(8936002)(2906002)(7416002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Rkw5MlE4ZnYzMGZ4L3FiNkp3bDBGY2sza1A5RDl0MEk3SG9iWVdkNU02RFd5?=
 =?utf-8?B?ZmdTVHBNcElNY2QwWDV1QUZVeWpjaXFGTG5VaWpHTmIydHN2SUpyYVhHSHpF?=
 =?utf-8?B?QkxEN1o3WlJ4eXRtYTZBUm9wMEZiZFFURDY1Ym9qNDhadWlZTXR5cmdURjYy?=
 =?utf-8?B?eGNjMkpMeHZSelNyalJMTUtrdzVIZnV3UEZBZHlaTGl3dzh6TnZNMkZrWEpy?=
 =?utf-8?B?MnZVNDZVOXpvNE0yQjNjdnNwMVZKVUcvSDJvQjNMeVl6REV6Nk0vYkgrWXlW?=
 =?utf-8?B?dXhSVlNTMlVHYzlKZGVEd2ZKQXJtcWYrc0V2MXBtZ0dHSGUxTzNlVjMrMjBS?=
 =?utf-8?B?ekJ6R0N6TEY3dFBLTm1DTjIzL0s3aEFwbFpYZGh1c0pGcE5scE9iOEl4NnIx?=
 =?utf-8?B?VVRKSTBkQnR4aGxnRWZMd2VuR2dNMHhvSUVOeDVXRllQZzU3eW4yLytzb3BV?=
 =?utf-8?B?YXBvR0Raejk3RE84SjVZakxhZlArcnVqTERHNVJUTlBVS01ZUXd5MTNia3lK?=
 =?utf-8?B?UjFSWnhxS3NmSmJDN2Y5N096bXpwR3c1T2ZVajNIU0hFZnQxTFBodEVvZGFY?=
 =?utf-8?B?VnFwUkpqWHJVcVBoSGJmdkdKcDhQdmY2aEF0cjNCVUdvenh1SHorNGVOamYv?=
 =?utf-8?B?Z2xjN3pOZXpkbU11WVpxM1ZGcmNJc29Obk1wdVc4OCs5VmlOMFVoRFNqRTVu?=
 =?utf-8?B?OEJ6MDJQdVpZRHRQTXgxNnpCTDlIKytlQVJUSWNVd0p3TFQ5eXpCTVMxQ3FB?=
 =?utf-8?B?cE01dUhDTUFxU1lRMTBiYi8yY253Ync1cGc2OS8rNlBDamVjbmg1aGtmMDNN?=
 =?utf-8?B?MVhSOThsZUlzQlRwTXZKZGxtdTl5R1IvVHEzVjIwUEo1dkg1b3IxOUN3L0Iz?=
 =?utf-8?B?RXFJeTVBTkw4Mi9hTXY3dmdhTHhrK3JDKzIrYVFoTWJKR3RhbXpxWGFIM25G?=
 =?utf-8?B?V1NRdDhTalhWWS8wMWhNc3BWZzJoN3B3djU5ZEgzcHZXWDh4UUllcmRyWlFG?=
 =?utf-8?B?YXNzQkRwRVo0cjY2cUZMZUlpM29Zc1lZamlIUmZ0RWF0VVlwNDNyWGEyVVNo?=
 =?utf-8?B?cFNRUXEzZ1NVaGtFdHFiNnIxOEFCM0ZqNWp0TUd5QUxqRzZJMW4yc2VYTEZ1?=
 =?utf-8?B?MGpmZXo1Rjd1VGtSZ1VrNDRJODNWYTJGUHN1MjEvN3Z6UlhRdy9uVjI4YS9R?=
 =?utf-8?B?MUlTV240NnNOd3dvL01Db1kzaWVoVmFqb0s2U1pZQWtVdWlBbVF5QmF1dnlH?=
 =?utf-8?B?bVlCRHVQSUYvNXE3dHErSm5KSE0xWVkvN0dEMW0rYzI1a0NCZDdjZ21rRW9a?=
 =?utf-8?B?RlJpOXltM2ladnVtRVVlY3dSZUFNUUxwSmRKVmYxckNhTm9BenBMcXRMM3Zt?=
 =?utf-8?B?UDA0aHpkSEhoV1RnMTUzU3BITmN6b0xMdFdCNFRoMmNlcVY4TGlmc1MwZ3Yx?=
 =?utf-8?B?c0hyclJTdVJ0K1Fqdk9KTUhEZGhzdGI3MXBJTlpxelpQcCs3NXNqeTFFeCs2?=
 =?utf-8?B?WFk2MVZ6eElOYmhZRkRkdnVneHFxU1VwWFFBV0pNUUFmb3IwUDJGdzB4RkZp?=
 =?utf-8?B?MURGWUZhdEp1bnczNWVZcFNWYklkNXhzZk1VZlQrbjRJcEdGY0ZMM3lvYXZ0?=
 =?utf-8?B?TmNNRmtVRnBsOFpnZkpIc0VpSGZ0WTBzNWZYNlo0U2U1SXRhclhKZnZ0TlZl?=
 =?utf-8?B?RWVCLy96eFR6M1J0R2d5UXBDbGQxWGo4UDhoVTRxZWZ1TjROZlBVaklDMHht?=
 =?utf-8?Q?sUIWZbSLw284+FVMKQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1c3455c-c83f-4d9a-e38e-08d9870b7ded
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2021 07:49:27.5314
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YCI9uYwiYHTgKefdbwm4nwA4puhuefrq6QC9lU9vkjMU07fuRw7zbTRQDNmsq/3XPeyH8vA6XI3RJFhm/yKPP8SGnZmonhOWltCcHzsUrv0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB2740
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgR2VlcnQsDQoNClRoYW5rcyBmb3IgdGhlIGZlZWRiYWNrDQoNCj4gU3ViamVjdDogUmU6IFtQ
QVRDSCAwNC8xMF0gcmF2YjogQWRkIHN1cHBvcnQgZm9yIFJaL0cyTCBTb0MNCj4gDQo+IEhpIEJp
anUsDQo+IA0KPiBPbiBTdW4sIE9jdCAzLCAyMDIxIGF0IDg6NTEgQU0gQmlqdSBEYXMgPGJpanUu
ZGFzLmp6QGJwLnJlbmVzYXMuY29tPg0KPiB3cm90ZToNCj4gPiA+IFN1YmplY3Q6IFJlOiBbUEFU
Q0ggMDQvMTBdIHJhdmI6IEFkZCBzdXBwb3J0IGZvciBSWi9HMkwgU29DIE9uDQo+ID4gPiAxMC8x
LzIxIDY6MDYgUE0sIEJpanUgRGFzIHdyb3RlOg0KPiA+ID4gPiBSWi9HMkwgU29DIGhhcyBHaWdh
Yml0IEV0aGVybmV0IElQIGNvbnNpc3Rpbmcgb2YgRXRoZXJuZXQNCj4gPiA+ID4gY29udHJvbGxl
ciAoRS1NQUMpLCBJbnRlcm5hbCBUQ1AvSVAgT2ZmbG9hZCBFbmdpbmUgKFRPRSkgYW5kDQo+ID4g
PiA+IERlZGljYXRlZCBEaXJlY3QgbWVtb3J5IGFjY2VzcyBjb250cm9sbGVyIChETUFDKS4NCj4g
PiA+ID4NCj4gPiA+ID4gVGhpcyBwYXRjaCBhZGRzIGNvbXBhdGlibGUgc3RyaW5nIGZvciBSWi9H
MkwgYW5kIGZpbGxzIHVwIHRoZQ0KPiA+ID4gPiByYXZiX2h3X2luZm8gc3RydWN0LiBGdW5jdGlv
biBzdHVicyBhcmUgYWRkZWQgd2hpY2ggd2lsbCBiZSB1c2VkDQo+ID4gPiA+IGJ5IGdiZXRoX2h3
X2luZm8gYW5kIHdpbGwgYmUgZmlsbGVkIGluY3JlbWVudGFsbHkuDQo+ID4gPg0KPiA+ID4gICAg
SSd2ZSBhbHdheXMgYmVlbiBhZ2FpbnN0IHRoaXMgcGF0Y2ggLS0gd2UgZ2V0IGEgc3VwcG9ydCBm
b3IgdGhlDQo+ID4gPiBHYkV0aGVyIHdoaWhjIGRvZXNuJ3Qgd29yayBhZnRlciB0aGlzIHBhdGNo
LiBJIGJlbGlldmUgd2Ugc2hvdWxkDQo+ID4gPiBoYXZlIHRoZSBHYkV0aGVyIHN1cHBvcnQgaW4g
dGhlIGxhc3QgcGF0Y2guIG9mIHRoZSBvdmVyYWxsIHNlcmllcy4NCj4gPg0KPiA+IFRoaXMgaXMg
dGhlIGNvbW1vbiBwcmFjdGljZS4gV2UgdXNlIGJyaWNrcyB0byBidWlsZCBhIHdhbGwuIFRoZQ0K
PiA+IGZ1bmN0aW9uIHN0dWJzIGFyZSBqdXN0IEJyaWNrcy4NCj4gPg0KPiA+IEFmdGVyIGZpbGxp
bmcgc3R1YnMsIHdlIHdpbGwgYWRkIFNvQyBkdCBhbmQgYm9hcmQgRFQsIGFmdGVyIHRoYXQgb25l
DQo+ID4gd2lsbCBnZXQgR0JzdXBwb3J0IG9uIFJaL0cyTCBwbGF0Zm9ybS4NCj4gDQo+IE5vdCAi
YWZ0ZXIiLCBidXQgImluIHBhcmFsbGVsIi4gIFRoZSBzdHVicyB3aWxsIGJlIGZpbGxlZCBpbiB0
aHJvdWdoIHRoZQ0KPiBuZXRkZXYgdHJlZSAoMSksIHdoaWxlIFNvQyBEVCBhbmQgYm9hcmQgRFQg
d2lsbCBnbyB0aHJvdWdoIHRoZSByZW5lc2FzLQ0KPiBkZXZlbCBhbmQgc29jIHRyZWVzICgyKS4N
Cj4gDQo+IFNvIG91ciBtYWluIHdvcnJ5IGlzOiB3aGF0IGhhcHBlbnMgaWYgeW91IGhhdmUgKDIp
IGJ1dCBub3QgKDEpPw0KDQpQbGVhc2UgZmluZCB0aGUgdGVzdCBjYXNlcw0KDQpDYXNlIGEpICgx
KSBhbmQgdGhlbiAoMikgUm9vdEZTIG1vdW50ZWQgb24gTkZTDQotLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQoNCnJvb3RAc21hcmMtcnpnMmw6fiMg
Y2F0IC9wcm9jL2NtZGxpbmUNCmlnbm9yZV9sb2dsZXZlbCBuZnNyb290ZGVidWcgcm9vdD0vZGV2
L25mcyBydyBuZnNyb290PTE5Mi4xNjguMTAuMTovdGZ0cGJvb3QvUlotRzJMLG5mc3ZlcnM9MyBp
cD0xOTIuMTY4LjEwLjINCnJvb3RAc21hcmMtcnpnMmw6fiMNCg0KQ2FzZSBiKSBIYXZlICgyKSBi
dXQgbm90ICgxKT8gUm9vdEZTIG1vdW50ZWQgb24gVVNCDQotLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQoNCnJvb3RAc21hcmMtcnpnMmw6fiMgY2F0
IC9wcm9jL2NtZGxpbmUNCnJ3IHJvb3R3YWl0IGVhcmx5Y29uIHJvb3Q9L2Rldi9zZGExDQpyb290
QHNtYXJjLXJ6ZzJsOn4jDQoNCkNhc2UgYykgSGF2ZSAoMikgYnV0IG5vdCAoMSk/IFJvb3RGUyBt
b3VudGVkIG9uIE5GUw0KLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tDQoNCkl0IHN0b3BzIGJvb3RpbmcgYXMgd2UgaGF2ZW4ndCBmaWxsZWQgUlggc3R1
YnMuDQoNClsgICAgNC40NTc0MzJdICBzZGE6IHNkYTENClsgICAgNC40NjU5MDldIHNkIDA6MDow
OjA6IFtzZGFdIEF0dGFjaGVkIFNDU0kgcmVtb3ZhYmxlIGRpc2sNCg0KDQpJZiB5b3UgbG9vayBh
dCBDYXNlIEIsIHRoYXQgaXMgdGhlIGN1cnJlbnQgY2FzZSwgd2hpY2ggYm9vdHMgd2l0aG91dCBh
bnkgaXNzdWVzLiBUaGVyZSBpcyBubyByZWdyZXNzaW9uDQphdCBhbGwgd2l0aCB0aGUgY3VycmVu
dCBjaGFuZ2VzIHN1Ym1pdHRlZC4NCg0KVGhlIG9ubHkgaXNzdWUgaXMgbW91bnRpbmcgd2l0aCBO
RlMgd2hpY2ggd29uJ3Qgd29yayBhcyB3ZSBoYXZlbid0IGZpbGxlZCBzdHVicyB0byBnZXQgZnVs
bCBmdW5jdGlvbmFsaXR5Lg0KDQoNClJlZ2FyZHMsDQpCaWp1DQoNCg==
