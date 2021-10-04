Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11BE0421792
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239157AbhJDTaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:30:12 -0400
Received: from mail-eopbgr1410110.outbound.protection.outlook.com ([40.107.141.110]:16258
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239133AbhJDT37 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 15:29:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=maEs2txBk0n3CsZ3qzQE67g7nPgl1jpKFl0uFAjgRFBfFAxHSygq7oWraLN7Ve3GzOmMjBFkNDdaGktjAGzdJ75Vd0h+sgQvoFS54IJ2QfGp/gM6XGO+52N0XhkMio6vC2PL+5G6C8g6VA586uuW1eVw0+EbR3JJukt/ti7kiLD7W9OJ1/Q4zjE+cMx9NIqTmIQHumZdM46WtAR1tgiiyEdypic+J97bdP4khNRztq+m6YG9gXoOsa+ptuF5HCaJ9ObDnjXXtlpA9y3nrAc/1hWpcKPyXLvRqIALHmqpVa+57GHV8M9vAVmujzvktZxO5dKSzDm6fdrLI89qklX3DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l3GKm2CgJxmnk525X2sJZNwD9VK4d6rr984HRH9Y2W8=;
 b=Y7MQv05zGyoEWi/S2SmNcrveqawpMr4qJx9cI+Cp0QFageASjqEG/oy6lAJ66u8eT9iBrvfynmoecGQiP/I3R6Neu4+IA+MI0cmgpxLaVIju+T91ZGyjW6dMJEOCWNn+ZmMTWG4pYgrsbMWr90K3WUb3lFPHsECw9OavcSJ5eifHN/TDVkO0ehhzDASGzNEnZofV6Ef59S4eshoVKzRp7501uSibGarguvtGRre8vumBEU6Uc3cFvQfO7s2BAda86XkrJ9fEXGD+xdxxkqAFj1G3UTlp3x+mIlhtRUeYnJRYy/ZB+Z03urWCRe9SV4AwC/xBTjlYDZE1wlvj1zyvXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l3GKm2CgJxmnk525X2sJZNwD9VK4d6rr984HRH9Y2W8=;
 b=ACfLqkMW9c+WwoO29Ng6ttGspa+0vKaYtfKgr1Dy119+PEqDHCLEIFa00tkVUFVzZt1m5o57huMV1bMfzCPxG15plEb7XAcdROg4AUSkPoBsNw8idXyUOg9RjLDP0psFmvdufSbIols/s7C0/XwWz8lRqQDMzVT/k4S3mbAAbtg=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB4181.jpnprd01.prod.outlook.com (2603:1096:604:4d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.21; Mon, 4 Oct
 2021 19:28:07 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 19:28:07 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
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
Subject: RE: [PATCH 07/10] ravb: Add tsrq to struct ravb_hw_info
Thread-Topic: [PATCH 07/10] ravb: Add tsrq to struct ravb_hw_info
Thread-Index: AQHXttYBwrLZxD51OEWm4mtgQbic7KvDJcMAgAAKOACAAAKqsIAAAjAAgAAJQDA=
Date:   Mon, 4 Oct 2021 19:28:07 +0000
Message-ID: <OS0PR01MB5922F1607B0D837C06A8E45986AE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
 <20211001150636.7500-8-biju.das.jz@bp.renesas.com>
 <5193e153-2765-943b-4cf8-413d5957ec01@omp.ru>
 <e83b3688-4cfe-8706-bd42-ab1ad8644239@gmail.com>
 <OS0PR01MB59220CAF5B166D4E6887B63486AE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <a4c96650-7836-26db-7e12-44ae56dca15a@omp.ru>
In-Reply-To: <a4c96650-7836-26db-7e12-44ae56dca15a@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fc6eb7ff-12f6-4752-fee4-08d9876d1839
x-ms-traffictypediagnostic: OSBPR01MB4181:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB41813113EEF150824C6CC2AD86AE9@OSBPR01MB4181.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:486;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eznhWE9NmsEjF7Bp70x1KRPdSXLu1/M7z+fiD5ILI+O87VIUlAjD+/fmAArsnfyf4rkIbxvexgDfAUN/l307r2reBxpzl356qHo+N4bMV05kkFz76QN6e8mlfJ13P/b+RJ8qeH3zebSg1pCwXjElaT6LxAiZ/dddkfQiUiYylWynOA+R342Ew/iF5xDsrtUf47oQ1DpOT66e9AW9Oq+kLsbpzBKz+6lZFE0MJiOJpsD39UqNj/l0OHweHKRrZfdBlN+APt0fHvj17mcseRDPNJbZlT1/IGlR711A3WG9ivg1bCFny6UFCHR1k1CL/BknmjNxMbQUEX1fTPg9+kS7RJGAEwTyJpdOFt6myc0oVb80UJ8kvQGNUUVjHuaI/M7DneB8A8C4RpkKYyQTKSxipk/2qOzExJw3vvAoXuFj9JQHd2UC0DbHcloc2IS1iKsxJwLJ4ectjKaNXs3jbNaFITvELRu5TZaBYYv48d3uZ6lE9aFdJoLEyEcCJ2NeaTxzaTBJ1pR+naqiwc76hROZYKnOXoI8fIJfB1PFTFPBJRb4vTpkqO6WdBXDeEUG8UDgb/g+oawZ7ACBpKobVSKhQ2t1OmQyEWTjcVKFKO4On1B0GF43cqqa5deM933WC2GD0yHHP3ycPLqzLa8KoJ7lEBedIHFAkSTFGKZAxr+oUmWvYiurjczPMKg58wDwsZXh/srKSaXibfRBa43tid4Sbg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38070700005)(508600001)(2906002)(66476007)(55016002)(64756008)(66556008)(66946007)(66446008)(38100700002)(122000001)(33656002)(4326008)(52536014)(7696005)(8676002)(8936002)(83380400001)(26005)(186003)(6506007)(5660300002)(7416002)(9686003)(110136005)(54906003)(86362001)(71200400001)(76116006)(53546011)(107886003)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NG5SSFc4WEFHSWtMd0pQVlFGWExySVN4QXhvQTFJNUp1bndxK1AyczFzaHgr?=
 =?utf-8?B?bkw5azluT3VsT1VUWmt4dXdrcHJ4WkNxTGM1RmJrc0F4UDRJL0FDa1lhWTZ3?=
 =?utf-8?B?a3kyQ2hSU1Rod3pQT3JzWVFSV1h5K3g1Zzhuc1NEYVFpdWdLNWtxWDBucWlq?=
 =?utf-8?B?QUwvWTJqWHRHS2RoSDVSWndhZFIzakwyNVc4eHlZS25tZEkzK1doTFpWeVk3?=
 =?utf-8?B?RmUzU2pXelRndWhQa0ZzMllZOVEvNUJKcjRtdEgxRWxpLzZDTlMwMFcrSjRI?=
 =?utf-8?B?ZTE2Z2dTOXVjNCt4QmJoRHFpM05Ock40RGJNd1cwYVVqNlQ2T0lCWjl5TGxT?=
 =?utf-8?B?NUVrdTU1K0g5ZFhxd0gxeVVWOE5XdHNETHFtbUpWTjNKb0puMnVXTW9qTXIy?=
 =?utf-8?B?b2lDaTRPbUtEdlpVYTQ1V2FlSUp0eHVyaCsrNHhlc0ZtUVFZR1NhdlR6Rkxo?=
 =?utf-8?B?Q3hjWklBczZqTnlzbkNBSGVGcjI0dDYzS0JKWVVCVkRXL2dCUFh4SDRRdkdo?=
 =?utf-8?B?QjVHaGpOanZNaE4wSFVEazVJdEttcHRnN1IwU3BldHVSVVZaYUtLTGFmWjlp?=
 =?utf-8?B?NGZOdXA3MFVNQUppaHZ3SXM2Nkovazdwa1FPKy9NMjA1MHJvNGRRakhqOEhV?=
 =?utf-8?B?QnE1ZUVZSU9TNzRFYlF6VzcxTVNlZnNZK3h3NkhMVERFUW84RERSeCtxVUIx?=
 =?utf-8?B?SnEwNm5VcUY1SjdNVmlVaG5tVU1OZDAvQUcyc3dVRytOK2wwd0RhWlMxSXVC?=
 =?utf-8?B?ck9FREFDY283SjZqK0p0V3RkZGhLRjdWSEZoL2dOQmd4NlhUMVQ3Nk0yOXFG?=
 =?utf-8?B?VlNzdE5YM1hXdUE0WnZHUE8rMnMrTWJZMkdWcnBmSmkxa0FwK1lBN1dZZ2t6?=
 =?utf-8?B?TkNuV1Q0aVJIY0xnWnpMczJDRG1hRVE1L0wva3ZQZGpVd2tlMWx5YmlpVVZK?=
 =?utf-8?B?L0h5WlRXYkk2WCt6NC9BU21xYlpldVh4ZE5nNnNBRFRDaXZwQ2NMUWJFenRu?=
 =?utf-8?B?NUhwV29lMk9VcThyanhFQjBFMXdsNHowL284UjVMYmVNeWJ3T2dUQURrYlJY?=
 =?utf-8?B?WWNybnlkMVhjVlgzK2ttdDhncThqMld5RXVZc3diK08xYUI5M3l2MFVsUWhC?=
 =?utf-8?B?UkxSR3hEaTJWUkNacjZNZTFFRXVMT0RNWkdmbkZnU1haMXFJa0ZuQlUwZUhK?=
 =?utf-8?B?U09vZjVoQTZ0VWpraW5Md3diVEJuYnhKczdkZDA5am5vN3Zpd1FONnArN3py?=
 =?utf-8?B?dTJlbVZLV2VTNjZSWEV2bFY1RUxIMTI2cTdZSm8wRzA1dmcwL2Y1UmQvK0dt?=
 =?utf-8?B?N2YxT3g3MUxRYUZ1UkhteEhrWEloa2ZOSERVYktDVEdYQ0FWUnpCd3VEUisv?=
 =?utf-8?B?Q1IvdzJaNlZxVlBYdEVDeU91Q3F0RHQra3dxZThPa2ZtWjNYWDdaZDk2S0M0?=
 =?utf-8?B?clpaNkNad3o2cTdJeFA4WEZzQnVXb1ZMZkZpTmsrUUJrRlpENWtWVkxaZHRZ?=
 =?utf-8?B?ZWU0ZldHRUYwcTRKKzc3VTh6VEdDR1NYdEVjc0RFcUhaSVJiNVBRZmNEK3ll?=
 =?utf-8?B?K2NPRVpveGV4MnFCVjhBTGtYbzVLYlhFTTNMeVN1eEw0aUR4ZWhJYUlody9z?=
 =?utf-8?B?WGZ5d001aTZ1U3FFSFV4RWpxaE9TY2daR1FTQmZqcUJkRzFtdXV6cjBCS1ZC?=
 =?utf-8?B?S25DTThLNC9BTzRvVkRFSkE5RkZiSXgwdkFEYnllZTltNU45QnkxRmlTQ1Mr?=
 =?utf-8?Q?H6WNnC2dLgpHwP615Y=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc6eb7ff-12f6-4752-fee4-08d9876d1839
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2021 19:28:07.5442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kFrCOFACn14RIezrVkm4sZHekz4EH/hH76rFbdx2T9AW9cnSfM7jPDUUMsORjC9tZOAn9evenffzw4qlbwKubj3EbvoSDMDtpZlPGd/X7yE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB4181
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2VyZ2V5IFNodHlseW92
IDxzLnNodHlseW92QG9tcC5ydT4NCj4gU2VudDogMDQgT2N0b2JlciAyMDIxIDE5OjU0DQo+IFRv
OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+OyBTZXJnZWkgU2h0eWx5b3YN
Cj4gPHNlcmdlaS5zaHR5bHlvdkBnbWFpbC5jb20+OyBEYXZpZCBTLiBNaWxsZXIgPGRhdmVtQGRh
dmVtbG9mdC5uZXQ+OyBKYWt1Yg0KPiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPg0KPiBDYzog
R2VlcnQgVXl0dGVyaG9ldmVuIDxnZWVydCtyZW5lc2FzQGdsaWRlci5iZT47IFNlcmdleSBTaHR5
bHlvdg0KPiA8cy5zaHR5bHlvdkBvbXBydXNzaWEucnU+OyBBZGFtIEZvcmQgPGFmb3JkMTczQGdt
YWlsLmNvbT47IEFuZHJldyBMdW5uDQo+IDxhbmRyZXdAbHVubi5jaD47IFl1dXN1a2UgQXNoaXp1
a2EgPGFzaGlkdWthQGZ1aml0c3UuY29tPjsgWW9zaGloaXJvDQo+IFNoaW1vZGEgPHlvc2hpaGly
by5zaGltb2RhLnVoQHJlbmVzYXMuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgt
DQo+IHJlbmVzYXMtc29jQHZnZXIua2VybmVsLm9yZzsgQ2hyaXMgUGF0ZXJzb24gPENocmlzLlBh
dGVyc29uMkByZW5lc2FzLmNvbT47DQo+IEJpanUgRGFzIDxiaWp1LmRhc0BicC5yZW5lc2FzLmNv
bT47IFByYWJoYWthciBNYWhhZGV2IExhZA0KPiA8cHJhYmhha2FyLm1haGFkZXYtbGFkLnJqQGJw
LnJlbmVzYXMuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIDA3LzEwXSByYXZiOiBBZGQgdHNy
cSB0byBzdHJ1Y3QgcmF2Yl9od19pbmZvDQo+IA0KPiBPbiAxMC80LzIxIDk6NDcgUE0sIEJpanUg
RGFzIHdyb3RlOg0KPiANCj4gWy4uLl0NCj4gPj4+ICAgIFRoZSBUQ0NSIGJpdHMgYXJlIGNhbGxl
ZCB0cmFuc21pdCBzdGFydCByZXF1ZXN0IChxdWV1ZSAwLzEpLCBub3QNCj4gPj4gdHJhbnNtaXQg
c3RhcnQgcmVxdWVzdCBxdWV1ZSAwLzEuDQo+ID4+PiBJIHRoaW5rIHlvdSd2ZSByZWFkIHRvbyBt
dWNoIHZhbHVlIGludG8gdGhlbSBmb3Igd2hhdCBpcyBqdXN0IFRYIHF1ZXVlDQo+ID4+IDAvMS4N
Cj4gPj4+DQo+ID4+Pj4gQWRkIGEgdHNycSB2YXJpYWJsZSB0byBzdHJ1Y3QgcmF2Yl9od19pbmZv
IHRvIGhhbmRsZSB0aGlzIGRpZmZlcmVuY2UuDQo+ID4+Pj4NCj4gPj4+PiBTaWduZWQtb2ZmLWJ5
OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+ID4+Pj4gUmV2aWV3ZWQt
Ynk6IExhZCBQcmFiaGFrYXIgPHByYWJoYWthci5tYWhhZGV2LWxhZC5yakBicC5yZW5lc2FzLmNv
bT4NCj4gPj4+PiAtLS0NCj4gPj4+PiBSRkMtPnYxOg0KPiA+Pj4+ICAqIEFkZGVkIHRzcnEgdmFy
aWFibGUgaW5zdGVhZCBvZiBtdWx0aV90c3JxIGZlYXR1cmUgYml0Lg0KPiA+Pj4+IC0tLQ0KPiA+
Pj4+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaCAgICAgIHwgMSArDQo+ID4+
Pj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMgfCA5ICsrKysrKyst
LQ0KPiA+Pj4+ICAyIGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMo
LSkNCj4gPj4+Pg0KPiA+Pj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5l
c2FzL3JhdmIuaA0KPiA+Pj4+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgN
Cj4gPj4+PiBpbmRleCA5Y2QzYTE1NzQzYjQuLmM1ODYwNzAxOTNlZiAxMDA2NDQNCj4gPj4+PiAt
LS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+Pj4+ICsrKyBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4+Pj4gQEAgLTk5Nyw2ICs5OTcs
NyBAQCBzdHJ1Y3QgcmF2Yl9od19pbmZvIHsNCj4gPj4+PiAgCW5ldGRldl9mZWF0dXJlc190IG5l
dF9mZWF0dXJlczsNCj4gPj4+PiAgCWludCBzdGF0c19sZW47DQo+ID4+Pj4gIAlzaXplX3QgbWF4
X3J4X2xlbjsNCj4gPj4+PiArCXUzMiB0c3JxOw0KPiA+Pj4NCj4gPj4+ICAgIEknZCBjYWxsIGl0
ICd0Y2NyX3ZhbHVlJyBpbnN0ZWFkLg0KPiA+Pg0KPiA+PiAgICAgT3IgZXZlbiBiZXR0ZXIsICd0
Y2NyX21hc2snLi4uDQo+ID4NCj4gPiBXZSBhcmUgbm90IG1hc2tpbmcgYW55dGhpbmcgaGVyZSBy
aWdodC4NCj4gDQo+ICAgICBXZSBkbyAtLSB3ZSBwYXNzIHRoZSBUQ0NSIG1hc2sgdG8gcmF2Yl93
YWl0KCkuDQoNCkFncmVlZC4gd2lsbCB1c2UgInRjY3JfbWFzayIgaW4gbmV4dCBSRkMgdmVyc2lv
bi4NCg0KPiANCj4gWy4uLl0NCj4gDQo+ID4gUmVnYXJkcywNCj4gPiBCaWp1DQo+IA0KPiBNQlIs
IFNlcmdleQ0K
