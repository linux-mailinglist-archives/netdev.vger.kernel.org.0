Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB653FA4AF
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 11:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233647AbhH1JV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 05:21:56 -0400
Received: from mail-eopbgr1400138.outbound.protection.outlook.com ([40.107.140.138]:40671
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233563AbhH1JVz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Aug 2021 05:21:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JvxJG5Adzfm6DxzJJnRAfgk+qD5IIFVami9uNuFLjIRDEhRQ0zCZ6ft1Z7SczR6wvs1Ib95ZqJ/lynggIzwDeirPzvFr4R5+st6rX+p3609d/jOyM8eahNOe4SWv2mx08TMPX8VItlzIs9Df3TwxwKUZbCf3bmch2leA9RUtSJk4gDeWk/bqvc9hj/JxicCfAkTR8SEn1FVX4dP8KDp9dyMiI2XwhRpXTcR7MBlSn0GckAiYwykDVGdebguX33NzpmJNLXz0g73u/d3GwlE6TIYZAM+O6+vuKcl4QkvzahszCyuxABfqHGt8TtGO5Sve8OLlWIvL9YrxZ0vIU0M/ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WB3jCjYVbkZjbZtKxIfl/SKlA6CYIIp+zPjmbJUxOok=;
 b=P+/2yTso0R3yKNcaaZr1u0LERREENbsoEz6u5qxvmKYvaSAcExD5mJTSUNGhmHoVSYMGnqS1lregK9yVOGXT7JySBQWEAQ9ah7tX4Bjcj9eLX7h0ynivPJuRDvljNSLdAsiL0HTSEdYht0i9gAdw7+2+6pBHEnLxkTjRDJTxT5BLi8Fj+SZHTOzvTvstp8K2wiZbE4zm8MzOHsLhgZAVFFz+Mzg+ndpsgFIe6n9aAZ6fpkCYPwFJmBQI8zDLQzRdZ85AImiVQGAbrgnI3k/nd1Z/vTUef8Z/mUwOorvyS1sbrr4/JvvkT23YKeaKuptwm7X69bpXiCpi5SaQycyzNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WB3jCjYVbkZjbZtKxIfl/SKlA6CYIIp+zPjmbJUxOok=;
 b=FP+GU9M02c52ivSZZ0MU0+Aos6q+zlqT2KJaMY78bF84MnrlV9Gn//ttx/qF1ptrWMfo2hCkSQDcdTjxqEZL6piB+qxGf9fOjoFs/VgU0Q5a6IjxoSuxCHXUHB4t2q2ZEN1iBsWoP5z1y2xD5n57WvkkOxXObzQUI4LnyFH/y84=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB2914.jpnprd01.prod.outlook.com (2603:1096:603:3e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.19; Sat, 28 Aug
 2021 09:21:00 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e111:61:43af:3b98]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e111:61:43af:3b98%4]) with mapi id 15.20.4457.023; Sat, 28 Aug 2021
 09:20:59 +0000
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
Subject: RE: [PATCH net-next 10/13] ravb: Factorise ravb_set_features
Thread-Topic: [PATCH net-next 10/13] ravb: Factorise ravb_set_features
Thread-Index: AQHXmX8wiUfxijLx1ESK/WmjrUoG+quHvSsAgADqaNA=
Date:   Sat, 28 Aug 2021 09:20:59 +0000
Message-ID: <OS0PR01MB5922B9A2B3A9ADDFFDF47E1486C99@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
 <20210825070154.14336-11-biju.das.jz@bp.renesas.com>
 <e08a1cf0-aac6-3ae2-fead-9b1f916fc27b@omp.ru>
In-Reply-To: <e08a1cf0-aac6-3ae2-fead-9b1f916fc27b@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: edd67953-9ad9-4333-05ea-08d96a052647
x-ms-traffictypediagnostic: OSAPR01MB2914:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB2914558A1B84F13BA042522186C99@OSAPR01MB2914.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:348;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t8Nf6vSTZaCt1mbHy+3/DtBhGY7B1v/svdTVUHXIKaFiHLFzdl5lm1043tyiclWad6QKCSfOlmXymabDjsgCudlqisCw902u8pmpjunSTpNQ6GSPs+cldJGW5k0chbWRTo/N3Fu3W8iJ3TVC+ZrGKjFViQWDp9ldxawepfPAYjpIt/he2esCFQrL6/5/ONBK+B2B0ixOBK+XVsUHWL8V1qxgdPx4Qt4KtSGTjSHu5FMCCPUHWH5JeXgfSayQpDOfa1LKQn98oikwo9meIgyataFj2rdO+hJSysg3rtoIGZAuu4Kse4spn3q80TZXesi3OLZwbt6MRFAW/vzY1RTJQv9pNmYbeCvxfDPFPvEeapJ37cRpsDbqMBRz8qrdi4GPrpKQeSe0KD3zo5JWGMq5rhePoujVR34WoryQ2+bd8QvEyIBnUgZZpq3GN12tk6QFeVE+k1hmDc2a/zusS1tdmXic7ZFadC5pNKWv52ixfGD/A7e2950xic/WaQbSSJ3W2LoOw42d4iNIP5+2QdITE9aH1WZ6YW27niSpcAON7FHegIYSDdBS6J7KovdYZefdPawRktru0flCc5xO9JxBJgsQy1ltbVbl9mfnbz3Bmc9K0lN4A/g9dj/1mls0TNR6N1V/w0TsceGZp/bAb0UJE/rVyqs8j5U0pXYUYER9RDuYbXK4TqcHqfidA7MuNhebdkHWpnbCHa3xp8FeDKT+hg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(366004)(39860400002)(396003)(316002)(54906003)(2906002)(33656002)(86362001)(110136005)(8936002)(71200400001)(5660300002)(52536014)(4326008)(478600001)(107886003)(122000001)(38100700002)(186003)(83380400001)(38070700005)(76116006)(26005)(64756008)(66446008)(6506007)(53546011)(66556008)(66476007)(8676002)(7696005)(66946007)(55016002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZzNmQkdXcUtYVWZnZk1jcGhEYkhCL25rdVlpcndXVG5NU0xXdXU3UzlUdGZZ?=
 =?utf-8?B?SnFrSG56c3poV0cyTmprNlN3eUpLa3BLK0NYOTRneWE3bTZTWFI3VUtZWGFp?=
 =?utf-8?B?dGQzTC93bGZySDFERDg2eHZwTEc1UGZweUQxVzUxS1duMndJck9rdnlOc25C?=
 =?utf-8?B?UmZveEM5Mk4wOFpjZmVrRTl0L1ZjUzJxelZ2Znk2Zjd3T0FCTkdVQXFsQm1u?=
 =?utf-8?B?dndLRm81UlpFb1FyMmlsNVAwM1VPZTBGYzdjb0IwY0piYVpHUlUwdWNjamUw?=
 =?utf-8?B?L0EyMVV0cEdSZmdpMm9VTWtpWmxrd2hJTHVKUzRMSTA4WjczMnlZci9jdHpY?=
 =?utf-8?B?aFNLSDlacWpxNkZJbTRoUFFoQ1VYNEo3SGc0ZmJBUHIwNC9PU3NWWjV0QzZw?=
 =?utf-8?B?RVEwMG9kT1FiT2c1N3NPS1oyb1p5cE54bVpXdGQxb2VseWJEaFZrUlJGRGpL?=
 =?utf-8?B?QUZDeEl5L3RsRkFMY0ttUWRRcURBSTdDUGpiN2lYYm5oaW83L1cxWVJISkli?=
 =?utf-8?B?VC9Kb2ZoVEMzY2EyWXBVSlNFL3BmeGV3RUtKWHRLRFdUMWxjRFlkYjIrYWF2?=
 =?utf-8?B?Y1VGWFhULzZvVGU5aUl4aHp4YlhlVVNXMEtTd1dJY0R5TVpReW9rZmFOUmxU?=
 =?utf-8?B?L2F3aFM5WkdaWlRoRm1UUUJMRVBoMCtxbjFDaVU0SzF5Y20rQlBXa1cxM1hV?=
 =?utf-8?B?aEh6cURVeHlDNDZIZjhYM2NvSll2b2FNTXM1TVRiOUZ1Y3RzUk5GTjhnb1Yy?=
 =?utf-8?B?TTI1cVlDMUdXUkRSU3dmUm5iSGFoY2x5azVFeGhhSlNWd1grVWZnT0xkSW13?=
 =?utf-8?B?WHFaNHRFeVUxNTVjZnpqTEVDaE14YjMwazc2WU1hdDE0akgzU2pYckhnMW12?=
 =?utf-8?B?d2E5dlNRTE9DV2xxQTVrTGIxMEh6L3NPYksreWdoczE0ZkU4WW1tTUIrWmRR?=
 =?utf-8?B?S3NHdFNzUGk4V0RNTEpFNUJZSW41a0xmb2Fjd3N4a1FCQnJNZytaTVhVejBw?=
 =?utf-8?B?a1dVWldkbzJobmFaUk0vbUtEVHo3bFBtdUhsVWdOVmJHdTEzUDBSSkFlRmlq?=
 =?utf-8?B?QVpvSGozOXVxYm9jWkVPdnJpOWpuN3MxdFZmaHpZWitBMEVsREVFZXRvU0Ru?=
 =?utf-8?B?cG1Ra2FpbGZIOE9GK3V5WmJRYUhrQWJTYTNIeFJ1WmtQTWZIQnN1a3NPTjVt?=
 =?utf-8?B?MVFQNXpKc2taMGcxdFk0N1VkNHZCbG9uWjBiMll0aHhyVkZaYU54Qml6cHhr?=
 =?utf-8?B?bFJyU0ZlQWtxNHJZQmtMN2Q3b3d3b3QxZk1ma3VuZGNkUXYxcElQOEdkUk45?=
 =?utf-8?B?dXJadjN0R0pXeDJmc1FMRW1jUlFhYVUvZER5Nml5UUJvTVBEQm9nTmpZY0Ja?=
 =?utf-8?B?WjNQckplTVAxVVQvelkzZjFMRlhxd2c1S0Q2cVJWLzh3L3dTZUFqOHpicitQ?=
 =?utf-8?B?Qk1YY1QvR3p5RVcyNEVrek9STGFoWXhXRWF1aGxDbUlJZEpSUVViVGV2OHAy?=
 =?utf-8?B?ekc1UFBpOElxTTIrRHVyNGkwUjhmTGhGaEtRanZlUTNvOFZ2ZmRaVWYwdlE3?=
 =?utf-8?B?ckxnZnMyaG5oMi8vc3FGbXVOcms1aGtwVGRNem42YkhiNXkyK3Jvditaakkr?=
 =?utf-8?B?aXF3dTJNckdMTXNXMUcvWU9IbVh3MGs0MGMvMi9ad01CMHF1a1ZHZnZtbklR?=
 =?utf-8?B?VmtwMXdnMUNCQUROWVl2Y0lYQVY3bVdaQXorUEVGc25mRFc3UE1nRXVVN0dX?=
 =?utf-8?Q?FO6otMUXdcIBszLVyg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edd67953-9ad9-4333-05ea-08d96a052647
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2021 09:20:59.4077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ObX4CbwlJnOkqOyMmQ1BsSD2sM5z4O1+mt8B5sb+Pb2KEcNc3KgEtoXkDZz+5Qhz3ZkQb1thizGaXAONRapnW8tcGKwiI2c9N3XRfMvLcxg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB2914
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2VyZ2V5IFNodHlseW92
IDxzLnNodHlseW92QG9tcC5ydT4NCj4gU2VudDogMjcgQXVndXN0IDIwMjEgMjA6MTcNCj4gVG86
IEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT47IERhdmlkIFMuIE1pbGxlcg0K
PiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+
DQo+IENjOiBQcmFiaGFrYXIgTWFoYWRldiBMYWQgPHByYWJoYWthci5tYWhhZGV2LWxhZC5yakBi
cC5yZW5lc2FzLmNvbT47DQo+IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD47IFNlcmdlaSBT
aHR5bHlvdiA8c2VyZ2VpLnNodHlseW92QGdtYWlsLmNvbT47DQo+IEdlZXJ0IFV5dHRlcmhvZXZl
biA8Z2VlcnQrcmVuZXNhc0BnbGlkZXIuYmU+OyBBZGFtIEZvcmQNCj4gPGFmb3JkMTczQGdtYWls
LmNvbT47IFlvc2hpaGlybyBTaGltb2RhDQo+IDx5b3NoaWhpcm8uc2hpbW9kYS51aEByZW5lc2Fz
LmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LXJlbmVzYXMtDQo+IHNvY0B2Z2Vy
Lmtlcm5lbC5vcmc7IENocmlzIFBhdGVyc29uIDxDaHJpcy5QYXRlcnNvbjJAcmVuZXNhcy5jb20+
OyBCaWp1DQo+IERhcyA8YmlqdS5kYXNAYnAucmVuZXNhcy5jb20+DQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggbmV0LW5leHQgMTAvMTNdIHJhdmI6IEZhY3RvcmlzZSByYXZiX3NldF9mZWF0dXJlcw0K
PiANCj4gT24gOC8yNS8yMSAxMDowMSBBTSwgQmlqdSBEYXMgd3JvdGU6DQo+IA0KPiA+IFJaL0cy
TCBzdXBwb3J0cyBIVyBjaGVja3N1bSBvbiBSWCBhbmQgVFggd2hlcmVhcyBSLUNhciBzdXBwb3J0
cyBvbiBSWC4NCj4gPiBGYWN0b3Jpc2UgcmF2Yl9zZXRfZmVhdHVyZXMgdG8gc3VwcG9ydCB0aGlz
IGZlYXR1cmUuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBCaWp1IERhcyA8YmlqdS5kYXMuanpA
YnAucmVuZXNhcy5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IExhZCBQcmFiaGFrYXIgPHByYWJoYWth
ci5tYWhhZGV2LWxhZC5yakBicC5yZW5lc2FzLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9u
ZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmggICAgICB8ICAxICsNCj4gPiAgZHJpdmVycy9uZXQv
ZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYyB8IDE1ICsrKysrKysrKysrKystLQ0KPiA+ICAy
IGZpbGVzIGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+ID4NCj4g
Wy4uLl0NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZi
X21haW4uYw0KPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0K
PiA+IGluZGV4IDFmOWQ5ZjU0YmYxYi4uMTc4OTMwOWM0YzAzIDEwMDY0NA0KPiA+IC0tLSBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiArKysgYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gQEAgLTE5MDEsOCArMTkwMSw4
IEBAIHN0YXRpYyB2b2lkIHJhdmJfc2V0X3J4X2NzdW0oc3RydWN0IG5ldF9kZXZpY2UNCj4gKm5k
ZXYsIGJvb2wgZW5hYmxlKQ0KPiA+ICAJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmcHJpdi0+bG9j
aywgZmxhZ3MpOyAgfQ0KPiA+DQo+ID4gLXN0YXRpYyBpbnQgcmF2Yl9zZXRfZmVhdHVyZXMoc3Ry
dWN0IG5ldF9kZXZpY2UgKm5kZXYsDQo+ID4gLQkJCSAgICAgbmV0ZGV2X2ZlYXR1cmVzX3QgZmVh
dHVyZXMpDQo+ID4gK3N0YXRpYyBpbnQgcmF2Yl9zZXRfZmVhdHVyZXNfcnhfY3N1bShzdHJ1Y3Qg
bmV0X2RldmljZSAqbmRldiwNCj4gPiArCQkJCSAgICAgbmV0ZGV2X2ZlYXR1cmVzX3QgZmVhdHVy
ZXMpDQo+IA0KPiAgICBIb3cgYWJvdXQgcmF2Yl9zZXRfZmVhdHVyZXNfcmNhcigpIG9yIHMvdGgg
YWxpa2U/DQoNCldoYXQgYWJvdXQNCg0KcmF2Yl9yY2FyX3NldF9mZWF0dXJlc19jc3VtKCk/DQoN
CmFuZA0KDQpyYXZiX3JnZXRoX3NldF9mZWF0dXJlc19jc3VtKCk/DQoNCg0KSWYgeW91IGFyZSBv
ayB3aXRoIHRoaXMgbmFtZSBjaGFuZ2UgSSB3aWxsIGluY29ycG9yYXRlIHRoaXMgY2hhbmdlcyBp
biBuZXh0IC0gUkZDIHBhdGNoc2V0Pw0KDQpJZiB5b3Ugc3RpbGwgd2FudCByYXZiX3NldF9mZWF0
dXJlc19yY2FyKCkgYW5kIHJhdmJfc2V0X2ZlYXR1cmVzX3JnZXRoKCksIEkgYW0gb2sgd2l0aCB0
aGF0IGFzIHdlbGwuDQoNClBsZWFzZSBsZXQgbWUga25vdywgd2hpY2ggbmFtZSB5b3UgbGlrZS4N
Cg0KUmVnYXJkcywNCkJpanUNCg0KDQoNCj4gWy4uLl0NCj4gDQo+ICAgIE90aGVyIHRoYW4gdGhh
dDoNCj4gDQo+IFJldmlld2VkLWJ5OiBTZXJnZXkgU2h0eWx5b3YgPHMuc2h0eWx5b3ZAb21wLnJ1
Pg0KPiAgICBMZXQncyBzZWUgdGhlIFRPQyBjb2RlIG5vdy4uLg0KPiANCj4gTUJSLCBTZXJnZXkN
Cg==
