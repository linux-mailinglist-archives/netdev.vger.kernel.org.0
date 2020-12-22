Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D17072E09CF
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 12:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgLVLiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 06:38:23 -0500
Received: from mail-eopbgr70054.outbound.protection.outlook.com ([40.107.7.54]:46725
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726661AbgLVLiV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 06:38:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b0t05iFBpMIM2uWqFc55YKNtCH7RkbWiJj13MF/YvTm5AcQ9fSJYU0+kHYhAbf+Ni8YHoXXJaUmUIIdofU2LZSQ3qLXCWWaGfaWvIEztnrU6AuLePTZlqrmSofyr4f3JGBSbnAoIqkZkoIqoJyMVZqvVn1bG6pyz4nG64NskiTs/UWM+k9ACq4T814HtAqMOxo5NjCh+j5D5dwp8GXM+WDaeCJtvROu+L9P8Ncn72SchVO7Zp6X05JO9rFDtyny1cxz0kai2Zrqsl/GzmDgiunLtqTMB6GwspfU/pb/ogzsqEn3OGtXNGO5V+ZNMbx4o1kBdlg4jpaV9KhsKGL8REA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MAvqJPQ2tashsLCNjAIm2peNlp463xNDPuTHF67gIu0=;
 b=CzDuvsJ4pjQ+UvAdreVK0sEf5ArfMXDgnbHMTkQrLNjzu+haSTSjm8gmYwEZ2monDw8BLygdRcYbU97MO9H+yZz8aNDgDX3bfOhmhmsqf3hnS3V2wiHqYMm/CwjgpeYUGJamSfKcRkpdXMfgxATVd39MPgPrRtbQswZnkuMoNvRT8kQ1FgbWoirWg3JauZf+3b8Shf2ozY3raYwdIYpoZE5pIwjMKFRGYG6hWBbfA0paA0X5+QOUq89genM8L3NVcTGgrzZ3FqpNnI0h6O1OmGDmhPYCuCklmqwG2uHGq1M+Cc+L00VgmS1OolIxLsZc2EmJ9/4r0jp7ydOZckIQGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MAvqJPQ2tashsLCNjAIm2peNlp463xNDPuTHF67gIu0=;
 b=fm1ZQfY6S9xb/Wu8THFyM0DGUzoLsv6ENAX+YGxz0X1LoZIPuzGL+XTIBB733qAaAY9JP/XpYA8IbaoScuxwkDcSdk/5PT+cQNk9zSmkK/7KowJ8fKXf6EAFc0M7l/JT5R2NsC9O2mV8imwjt8+8Vc9G0PII3e0Po5BzxUr+j2E=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7240.eurprd04.prod.outlook.com (2603:10a6:10:1af::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.33; Tue, 22 Dec
 2020 11:37:30 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%5]) with mapi id 15.20.3676.033; Tue, 22 Dec 2020
 11:37:30 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V5 0/5] can: flexcan: add stop mode support for i.MX8QM
Thread-Topic: [PATCH V5 0/5] can: flexcan: add stop mode support for i.MX8QM
Thread-Index: AQHWtCtrHb1jMsZi9EW4fUbOcFsCeKm6+LoAgEhI8zA=
Date:   Tue, 22 Dec 2020 11:37:30 +0000
Message-ID: <DB8PR04MB6795544FA09F6F0D17EBBE36E6DF0@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20201106105627.31061-1-qiangqing.zhang@nxp.com>
 <688b3f70-07d2-fb6d-3722-f2fa3a6f3a85@pengutronix.de>
In-Reply-To: <688b3f70-07d2-fb6d-3722-f2fa3a6f3a85@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5f6ffad8-78fe-469e-c262-08d8a66df79b
x-ms-traffictypediagnostic: DBAPR04MB7240:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBAPR04MB7240E142A7EA006E61B8B5C9E6DF0@DBAPR04MB7240.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:109;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mUQiuGmc3EHnl5qrCs0+sGfklLQ3i7/rNOD5pmF4xBlWNkwVTVE5rIYrJ+ESD8VtK/BhLhQ+M0em5uvpaHmBRpEJn/QdrqK+67PA7O01Fwyw6xh0so4X9lQfA0vIWUswxY5kO6Ojs1IDMoxAMarmvG71rQA4klnInx8tHdvgT3rO4yc/KSBGK3aYu3BVWyYGYqmd6cw9OJdQvIKdlD6SuMvBmGFCYpTjkpaY2cxD+jpQFjh9plMw/6gVsO+wYMgCKX9uH86zQDoQ7f47QylAxklXunFfFERw7kJP3sfCvSPj9KJLnRKecyD4T9Su3zCmgo7gioKHlnR6PxLEYSm46N00F4PFkTXzfwAO24mHQ/fNdjuCWAYclFHH8Zx+CZuA/Fb4tCn+FtfzhCRs+5cqbw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(498600001)(110136005)(76116006)(55016002)(86362001)(71200400001)(33656002)(52536014)(26005)(186003)(8936002)(8676002)(4326008)(53546011)(6506007)(7696005)(5660300002)(64756008)(66476007)(66556008)(54906003)(66446008)(83380400001)(2906002)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?NDU1eER1TGxYclZQZ1IvVllsMllxamUxODhtQTVqdStJQ25oWlIwQUF4UjVr?=
 =?utf-8?B?alhjZWl1aE82SkVRS0RvaDRRdy9qemUxMG1NUlJvV2h5djVnS2p1ZWpLdzdG?=
 =?utf-8?B?VE95eTNGTVRCMm9wVVQrdjhmd2dZdnJzbzdJb3FpT1pQUXVBWWhxUTZHMG96?=
 =?utf-8?B?SVRuNmJtV1p2RFhJV24yUWRudGhndTNxb3J2czRkeWNoQkZES3JQZUY0RkVP?=
 =?utf-8?B?dythdmtoODVWVHowTEtBSWJlblcvWDJUcTdtRXVPbEpHc1BZSkkvKzhNYnpG?=
 =?utf-8?B?Q3lIc3dXVXhsdXBCUGt2eVAzUm5NUWtSSGIwSXN3b2I1ZVRhNTJhR2FXSkFJ?=
 =?utf-8?B?MVFNK2Y1WXJTV1pnNUpaNllXS2pHNzFBUGdZcVYrOGNtQnc4ZUlvLzE0Y0Ry?=
 =?utf-8?B?ejUzTmNXN1NlUS9peGZwWVN1V2lSWFdES3BIS0Rwb1NYYzNmQkRNTmtieXZF?=
 =?utf-8?B?MW9mV25zenI5bGZrL1NaNlIxM25WcXRHT3c1ajJlRFYybGVsS2h5WmM3L3Ey?=
 =?utf-8?B?blkwYlNXbWgzTVBzTXhvOG92OThQQWh0RTd2eWFHN2VVazUvVmJwTGZMTDNW?=
 =?utf-8?B?OGFQYUFCQVd3NWlHZmRmcmZWL2tBOXI4S0xwbVU2dy9JWVRHODRTNUdzUkFU?=
 =?utf-8?B?WFhtT0JNbGYzTDJqUVo2ZDd5L2lQcW1YQlNpdlF5RW0vVTd4Yk9TSEtvcGJk?=
 =?utf-8?B?T2gvdTd0ZTVNUXl4VnJjOUkyR0V3MExTT1RpbHlYcFQwS2h6d1Uvam9UbmEr?=
 =?utf-8?B?alhHUXhTTzByZnh1SzB2NkIzMWlhb0MzN0NqakVjZ0xkYktnQzZGM2lVOUdP?=
 =?utf-8?B?dklpUmRPWVFYUHFwRUZERWlvaW15WkdIQ3JOY2dkLzNxejl6Zkc3TFNjTUxJ?=
 =?utf-8?B?ZkJxNW43K2RiTHV0RForazgrYmlFdXRjcmpmZEg3Wjdpa1g1TGdHSElNQUZN?=
 =?utf-8?B?YlVLWm5DY3Z5RHozdEdjUFFDZVhiN1FwT0luL0I5Vld2YjI2S0dERnBDZ05I?=
 =?utf-8?B?U0tFQUo2Z2ZYUThGZjZVNkZrbUdwNllpRDlLWEJqUXF1a0dQZkRJOEd6ZHRs?=
 =?utf-8?B?dEkzT2lZV25oRkpDdjFVVnQ2N3VBNG5OSUtEd1hxb1VTalZpMWl4N3hyVXhE?=
 =?utf-8?B?cHJHSjc3V09VNU94SFNLUHkrcWs4VjkyZjc5R3hjWUx0aFV0SUVhd0ZHSVRa?=
 =?utf-8?B?QTN6TUpWMnhGMkxXaXVIQnpkNGhiYXBJbUpUaVprdTJYSUdxZjBUN2libU05?=
 =?utf-8?B?Y3Zra3RMTWhram1lZDF1cTVhME5ITDVYcjhPWGpmeHNVamNyeE5Zb2FxNWhV?=
 =?utf-8?Q?XbsmtNCGZJJT0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f6ffad8-78fe-469e-c262-08d8a66df79b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Dec 2020 11:37:30.8164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FgEWCCXk9tghQCOjbe9+rS8SVufKkBPJELU17n1yJPNE8tNoC99W7Fkft4GrePI1h+YJkWcvPiaGuJJVkvOgJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7240
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMgS2xlaW5lLUJ1ZGRl
IDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMjDlubQxMeaciDbml6UgMTk6MzMNCj4g
VG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyByb2JoK2R0QGtlcm5l
bC5vcmc7DQo+IHNoYXduZ3VvQGtlcm5lbC5vcmc7IHMuaGF1ZXJAcGVuZ3V0cm9uaXguZGUNCj4g
Q2M6IGtlcm5lbEBwZW5ndXRyb25peC5kZTsgZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhwLmNv
bT47DQo+IGxpbnV4LWNhbkB2Z2VyLmtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7
DQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBW
NSAwLzVdIGNhbjogZmxleGNhbjogYWRkIHN0b3AgbW9kZSBzdXBwb3J0IGZvciBpLk1YOFFNDQo+
IA0KPiBPbiAxMS82LzIwIDExOjU2IEFNLCBKb2FraW0gWmhhbmcgd3JvdGU6DQo+ID4gQWRkIHN0
b3AgbW9kZSBzdXBwb3J0IGZvciBpLk1YOFFNLg0KPiA+DQo+ID4gQ2hhbmdlTG9nczoNCj4gPiBW
NC0+VjU6DQo+ID4gCSogcmVtb3ZlIHBhdGNoOmZpcm13YXJlOiBpbXg6IGFsd2F5cyBleHBvcnQg
U0NVIHN5bWJvbHMsIHNpbmNlDQo+ID4gCWl0IGRvbmUgYnkgY29tbWl0OiA5NWRlNTA5NGY1YWMg
ZmlybXdhcmU6IGlteDogYWRkIGR1bW15IGZ1bmN0aW9ucw0KPiA+IAkqIHJlYmFzZSB0byBmc2ws
ZmxleGNhbi55YW1sDQo+ID4NCj4gPiBWMy0+VjQ6DQo+ID4gCSogY2FuX2lkeC0+c2N1X2lkeC4N
Cj4gPiAJKiByZXR1cm4gaW14X3NjdV9nZXRfaGFuZGxlKCZwcml2LT5zY19pcGNfaGFuZGxlKTsN
Cj4gPiAJKiBmYWlsZWRfY2FucmVnaXN0ZXItPmZhaWxlZF9zZXR1cF9zdG9wX21vZGUuDQo+ID4N
Cj4gPiBWMi0+VjM6DQo+ID4gCSogZGVmaW5lIElNWF9TQ19SX0NBTih4KSBpbiByc3JjLmgNCj4g
PiAJKiByZW1vdmUgZXJyb3IgbWVzc2FnZSBvbiAtRVBST0JFX0RFRkVSLg0KPiA+IAkqIHNwbGl0
IGRpc2FibGUgd2FrZXVwIHBhdGNoIGludG8gc2VwYXJhdGUgb25lLg0KPiA+DQo+ID4gVjEtPlYy
Og0KPiA+IAkqIHNwbGl0IEVDQyBmaXggcGF0Y2hlcyBpbnRvIHNlcGFyYXRlIHBhdGNoZXMuDQo+
ID4gCSogZnJlZSBjYW4gZGV2IGlmIGZhaWxlZCB0byBzZXR1cCBzdG9wIG1vZGUuDQo+ID4gCSog
ZGlzYWJsZSB3YWtldXAgb24gZmxleGNhbl9yZW1vdmUuDQo+ID4gCSogYWRkIEZMRVhDQU5fSU1Y
X1NDX1JfQ0FOIG1hY3JvIGhlbHBlci4NCj4gPiAJKiBmc2wsY2FuLWluZGV4LT5mc2wsc2N1LWlu
ZGV4Lg0KPiA+IAkqIG1vdmUgZnNsLHNjdS1pbmRleCBhbmQgcHJpdi0+Y2FuX2lkeCBpbnRvDQo+
ID4gCSogZmxleGNhbl9zZXR1cF9zdG9wX21vZGVfc2NmdygpDQo+ID4gCSogcHJvdmUgZmFpbGVk
IGlmIGZhaWxlZCB0byBzZXR1cCBzdG9wIG1vZGUuDQo+ID4NCj4gPiBKb2FraW0gWmhhbmcgKDUp
Og0KPiA+ICAgZHQtYmluZGluZ3M6IGNhbjogZmxleGNhbjogZml4IGZzbCxjbGstc291cmNlIHBy
b3BlcnR5DQo+IA0KPiBhZGRlZCB0byBsaW51eC1jYW4vdGVzdGluZw0KPiANCj4gPiAgIGR0LWJp
bmRpbmdzOiBjYW46IGZsZXhjYW46IGFkZCBmc2wsc2N1LWluZGV4IHByb3BlcnR5IHRvIGluZGlj
YXRlIGENCj4gPiAgICAgcmVzb3VyY2UNCj4gPiAgIGNhbjogZmxleGNhbjogcmVuYW1lIG1hY3Jv
IEZMRVhDQU5fUVVJUktfU0VUVVBfU1RPUF9NT0RFIC0+DQo+ID4gICAgIEZMRVhDQU5fUVVJUktf
U0VUVVBfU1RPUF9NT0RFX0dQUg0KPiA+ICAgZHQtYmluZGluZ3M6IGZpcm13YXJlOiBhZGQgSU1Y
X1NDX1JfQ0FOKHgpIG1hY3JvIGZvciBDQU4NCj4gPiAgIGNhbjogZmxleGNhbjogYWRkIENBTiB3
YWtldXAgZnVuY3Rpb24gZm9yIGkuTVg4UU0NCj4gDQo+IFRoZSBvdGhlcnMgZ28gdmlhIGxpbnV4
LWNhbi1uZXh0L3Rlc3RpbmcsIG9uY2UgbmV0L21hc3RlciBpcyBtZXJnZWQgYmFjayB0bw0KPiBu
ZXQtbmV4dC9tYXN0ZXIgdG8gaGF2ZSB0aGUgeWFtbCBiaW5kaW5ncy4NCg0KSGkgTWFyYywNCg0K
SG93IGFib3V0IGJlbG93IHBhdGNoZXM/IEkgZXZlbiBjYW4ndCBzZWUgaXQgaW4geW91ciBsaW51
eC1jYW4tbmV4dC90ZXN0aW5nIGJyYW5jaC4gQXJlIHRoZXNlIG1pc3NlZD8NCglkdC1iaW5kaW5n
czogY2FuOiBmbGV4Y2FuOiBhZGQgZnNsLHNjdS1pbmRleCBwcm9wZXJ0eSB0byBpbmRpY2F0ZSBh
IHJlc291cmNlDQoJY2FuOiBmbGV4Y2FuOiBhZGQgQ0FOIHdha2V1cCBmdW5jdGlvbiBmb3IgaS5N
WDhRTQ0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCg==
