Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F53A30B921
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 09:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbhBBIDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 03:03:09 -0500
Received: from mail-am6eur05on2046.outbound.protection.outlook.com ([40.107.22.46]:20353
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231225AbhBBIDD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 03:03:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CgSCCLaPXmqoGcv0oa3unpHR/hxTUES1zJiOh73Kk+YD2W0b8hyW4VtOuaeCEEy/SJAtcUcDC72/tuz8NmFYRgYPbB5MattNZK5ZdNXhgcc13wGZCAUPJzHeOSpq+Tco2aP85Ovtg68H5rCu7gJXSbT0ceL/qdoUQFnrrc5NtoehOc7Mp7aYCKsMrq4hwABjforFb+yYQxFS4WL7UMNXNjzL3CGusHVRwMXlxClVON7HUV7RYs9bm/ZB9ZAg3YCoQ5yFnIGpfaCS5wadjiRbEoVPXcsAirPN5qscnvDZVFgFBrtNK/zojukuqlT+Byikd0IEt7347JTs8uZtpZquag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q56apVJqAomX4Z9U72N0o/uTZMRXGPw8J56bVpZ1QDM=;
 b=ZkhFUfEA7Y0OIPPZm16s4CZcdPLrgVvN+2W0bwMdDtfjWEtPLOK/DrBNBmamq8GOsDSwqE7vRsn1npU6I3kNEhuspWdCMMJ6YNVWalcaevmii9BBVbo4RX8N/LwaXRubCYKZzyuqHk9gGzmA/zmnmo3aLbtAz7c/GlMnIZTX2kQ6etcVgWTAV2C0SZeZcr2NbEvoyqtYvr0IQVHi+m97Gh/Y8uW8j0GeJn/W843Vz3juQ1fTJCCz88lwXOJvcATwhxb9+k/vjEo+5OpXaHV3cO6yfxjJt/fJd1QWjvRmsdB+Zn5RSXgQuwjgS2jAaGuy3W9n6f5QmzzzrskEYlz/FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q56apVJqAomX4Z9U72N0o/uTZMRXGPw8J56bVpZ1QDM=;
 b=L5ZZ2kVt2NhnuT6ktEYQKTdkKiP7E9ocplrZwPODz2JeJ+HOT87Wg95ObPIzZ3pqDgLxkkdOW2tF6kkXAdm7p7hgkQRHTYP00XQJzJ/tnyqOEEr+skjcSFaNOJVzP89ET1b4sNr1WIrS3B3TjEQ5HHEZ1lrgM7CzK1Ge4DxNmp4=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0401MB2325.eurprd04.prod.outlook.com (2603:10a6:4:49::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.28; Tue, 2 Feb
 2021 08:02:11 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9d2b:182e:ba3b:5920]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9d2b:182e:ba3b:5920%3]) with mapi id 15.20.3805.027; Tue, 2 Feb 2021
 08:02:11 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH linux-can] can: flexcan: enable RX FIFO after FRZ/HALT
 valid
Thread-Topic: [PATCH linux-can] can: flexcan: enable RX FIFO after FRZ/HALT
 valid
Thread-Index: AQHW+SwY0VdFQlRMB0yIQBn1zWjHfapEeieAgAAGc3A=
Date:   Tue, 2 Feb 2021 08:02:10 +0000
Message-ID: <DB8PR04MB67953020297534342367BD76E6B59@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210202062350.7258-1-qiangqing.zhang@nxp.com>
 <c6bc1c1b-b86e-63c2-2dba-eb9fe108516e@pengutronix.de>
In-Reply-To: <c6bc1c1b-b86e-63c2-2dba-eb9fe108516e@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 33a54d48-738e-497a-427e-08d8c750d837
x-ms-traffictypediagnostic: DB6PR0401MB2325:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0401MB2325E18F44CFABBAAD6F77D2E6B59@DB6PR0401MB2325.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RPKaoaa7eHNUZ3zxNsmy1MUzgPvm0x/xtwn0KR+XVGMLRRQ4stRwTu5qalDdJa9qXMlVDhj7OiKn6j2XKC5XRJG6KviRLfhJhlU2CmVKND05EX/mPcc8dlw1mqmp0KSSkiXTr5rVlaD6Mr/mvPC52T5JuNPZMJFNxe6TFC0m2PN9a26PrPhe4iuG0jpg85GlvQt8vhmzfqJAsc9029lpdXpFuaCHB3zr07TBllXLqctN+eneIiNC4jlhl7DvQYFVYGFxuCAMGrrK+nw0HXQQMZ+EzNj7XBQB+u9sXoZgyuQ2UK62Q3rvmxE9E90CcS5wk7IshNXog4E7jewgZ5IeMU4f+QdpD2t8+ZuzxISyUNVqX2ZJCFdYPtBHNFwnqYb32yupj9Ov32zqwXaQh0MYNb/fJi7KJf+5P2Ywlc76oVn2MjCzFVI+KiMwBXbPunBqbkiG+HUcBfDBrVxXbtAFZFxbNwcTx2n0iseof3E/Og7guu9UUn9EUn6bah6OvgA4uSKhriG07i2lpmW83p85oEUWwC10Mzqdy3zKn3JGNlEzsktleOG27DUCFItpmUrdM1kf/MLwta0bWVgsLcbSlm6gF3UJ3rg6l7t9b/P0hDG3P+I7QcaIYMmmCSLdE9kKGXZ2b3s4oizC2Ws79LZZhZcdB3TYckj+2V+p5YUoNMc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(136003)(366004)(396003)(26005)(186003)(71200400001)(4326008)(9686003)(86362001)(76116006)(33656002)(55016002)(53546011)(6506007)(8676002)(66446008)(64756008)(66556008)(66476007)(2906002)(66946007)(83380400001)(52536014)(54906003)(7696005)(83080400002)(110136005)(966005)(8936002)(5660300002)(478600001)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?eUNmQzdkU3NKVk9QamZPZGJTR0RPS29ncmN5dzQwZENlUy9iV3p5eHhRL2xo?=
 =?utf-8?B?YWFENVZ3S0dnVEVXZmJNR0VJT0tzMjZpM2d2SzEvcUZsWHMzRCtaSkJyYU9u?=
 =?utf-8?B?aW5VMEQ5b2NXcU52cUptRHg3Q0FicFlpcEJNSVdvbUFSWVVPR3JGK1lmOUhU?=
 =?utf-8?B?K1ZkcTJPcUtLRy9WSnY4VXd2bmppUE5lZy8xOGFJYWNOMHZRa1BZdGFNZ09K?=
 =?utf-8?B?cFhrY090Ym4rMEpRYVJUems3VHpCNVhVc09qL0NENUsvc25iL093cXZSWGgy?=
 =?utf-8?B?VlEzZWNvc3pIV2t5aVpEbWp0WTVLMkFCNmxaenc2WGJkN0dQNWF6cnpLa1p1?=
 =?utf-8?B?Mk43d3RXZ2FiM1o3cmk1SVNVMlIyV3FyVEJMOUtyQ1hNWEFvM3NTQ1F3YVZ1?=
 =?utf-8?B?ZTJQMmxVamJBTTlpa3ZRMlI5NXdwVTBFaEZuVVV4NCtscURYTHAvb0ZhV1lS?=
 =?utf-8?B?TG5hVWthZGNmSEU5cEtTSnQ0VGhBNTI3NDJpMFRGdXQ2cWZHL1EwdktjOHJ4?=
 =?utf-8?B?b1JCRjZVK20wd3pibXdUbDBQVWFXeFVvUWFTZEZGdTVneFR0eGgveTRFdWdN?=
 =?utf-8?B?VGtZdUMvdVRzaDlWeHRQTi84VDFyTlF6cEVhckIvZVMrcHRsUG5MR2pTVVJU?=
 =?utf-8?B?d3NpUEMyMDRZY1J0YWJjVTJCckpFaGV6VUNjU1BLbVdPSkN0UG1rR1Zna2lp?=
 =?utf-8?B?c2FDeXBpTlJkaC94OTVMM0NEc0Q2bzBvNnZKc0c1OWVlcHVxUTF4MlQvUmtj?=
 =?utf-8?B?WkJ1aGpwSTdQUm9zcTNKN2dhendKbkdHNmJkKzJGM1RnbllyUUkrb3pmaWpn?=
 =?utf-8?B?REM2L2hFaEZuN0c4eFBZZDRNcGR1OERtRHdwbkhNaGd0UzRZMGZ0NWdCSUZZ?=
 =?utf-8?B?T3luaUc1QnpwNGJKNDgzSWNpZHZwdjgya2FTRHFIWU8yQm9iNjlFMzlXZWZS?=
 =?utf-8?B?OFZqVElXRW1na3I1YXF5eXVuSkZwQzltUklDRHlnQUpJTHY3YTUvZVJRRXQx?=
 =?utf-8?B?YktKUzJ2M0FPNThLMElsQk1hc05venVJV3NCQ2hsNUMvcjkwdXdqdU5hMG9X?=
 =?utf-8?B?ZDdhZ082cjh6cnFTZmhkemNHU2VubDh4N2hIdkY0S3RkaWVsVEQrTk1ka0Fv?=
 =?utf-8?B?aGUwMjhWVEZyL0U2WDNEQ2puTXpUemdEUE5MeHJiVlVxSk94YjZTV01vOUo4?=
 =?utf-8?B?b2MrQjJnMlhtQlVHZEViZEJvaWNDSmsxdSsyUWMxMWVvTUFOTDYraFJuK0tW?=
 =?utf-8?B?SHhZc1I4bElXSmJScHFLQm9ZeldrS3QxV2RVMWhOTFE1YTk3SGltQjdnR0VB?=
 =?utf-8?B?U3VkV0w3SHErQ0gyYVc0SHU1b0ptNXZsTFpmLzVpcVl4a29JcEQrMGtwR3VJ?=
 =?utf-8?B?RnR2TEZ5UndGRVFIbzlwMVk0NUFiMVp2YW5DWlFDNHRGOGZNckcrL3NXZWlp?=
 =?utf-8?Q?y2IfMl2I?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33a54d48-738e-497a-427e-08d8c750d837
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2021 08:02:11.1168
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yDlDmKJg3rpdrLWnJqFlqfu9YHqkifDgm17pl/T+GSe2NirL2xSsDhj6N37nK3OsffnnE9DZu9bXArLkDvCaWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2325
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMgS2xlaW5lLUJ1ZGRl
IDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMjHlubQy5pyIMuaXpSAxNTozNw0KPiBU
bzogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT47IGxpbnV4LWNhbkB2Z2Vy
Lmtlcm5lbC5vcmcNCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGRsLWxpbnV4LWlteCA8
bGludXgtaW14QG54cC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbGludXgtY2FuXSBjYW46
IGZsZXhjYW46IGVuYWJsZSBSWCBGSUZPIGFmdGVyIEZSWi9IQUxUDQo+IHZhbGlkDQo+IA0KPiBP
biAyLzIvMjEgNzoyMyBBTSwgSm9ha2ltIFpoYW5nIHdyb3RlOg0KPiA+IFJYIEZJRk8gZW5hYmxl
IGZhaWxlZCBjb3VsZCBoYXBwZW4gd2hlbiBkbyBzeXN0ZW0gcmVib290IHN0cmVzcyB0ZXN0LA0K
PiA+IG9uZSBjdXN0b21lciByZXBvcnRzIGZhaWx1cmUgcmF0ZSBpcyBhYm91dCA1MCUuDQo+ID4N
Cj4gPiBbICAgIDAuMzAzOTU4XSBmbGV4Y2FuIDVhOGQwMDAwLmNhbjogNWE4ZDAwMDAuY2FuIHN1
cHBseSB4Y2VpdmVyIG5vdA0KPiBmb3VuZCwgdXNpbmcgZHVtbXkgcmVndWxhdG9yDQo+ID4gWyAg
ICAwLjMwNDI4MV0gZmxleGNhbiA1YThkMDAwMC5jYW4gKHVubmFtZWQgbmV0X2RldmljZSkgKHVu
aW5pdGlhbGl6ZWQpOg0KPiBDb3VsZCBub3QgZW5hYmxlIFJYIEZJRk8sIHVuc3VwcG9ydGVkIGNv
cmUNCj4gPiBbICAgIDAuMzE0NjQwXSBmbGV4Y2FuIDVhOGQwMDAwLmNhbjogcmVnaXN0ZXJpbmcg
bmV0ZGV2IGZhaWxlZA0KPiA+IFsgICAgMC4zMjA3MjhdIGZsZXhjYW4gNWE4ZTAwMDAuY2FuOiA1
YThlMDAwMC5jYW4gc3VwcGx5IHhjZWl2ZXIgbm90DQo+IGZvdW5kLCB1c2luZyBkdW1teSByZWd1
bGF0b3INCj4gPiBbICAgIDAuMzIwOTkxXSBmbGV4Y2FuIDVhOGUwMDAwLmNhbiAodW5uYW1lZCBu
ZXRfZGV2aWNlKSAodW5pbml0aWFsaXplZCk6DQo+IENvdWxkIG5vdCBlbmFibGUgUlggRklGTywg
dW5zdXBwb3J0ZWQgY29yZQ0KPiA+IFsgICAgMC4zMzEzNjBdIGZsZXhjYW4gNWE4ZTAwMDAuY2Fu
OiByZWdpc3RlcmluZyBuZXRkZXYgZmFpbGVkDQo+ID4gWyAgICAwLjMzNzQ0NF0gZmxleGNhbiA1
YThmMDAwMC5jYW46IDVhOGYwMDAwLmNhbiBzdXBwbHkgeGNlaXZlciBub3QgZm91bmQsDQo+IHVz
aW5nIGR1bW15IHJlZ3VsYXRvcg0KPiA+IFsgICAgMC4zMzc3MTZdIGZsZXhjYW4gNWE4ZjAwMDAu
Y2FuICh1bm5hbWVkIG5ldF9kZXZpY2UpICh1bmluaXRpYWxpemVkKToNCj4gQ291bGQgbm90IGVu
YWJsZSBSWCBGSUZPLCB1bnN1cHBvcnRlZCBjb3JlDQo+ID4gWyAgICAwLjM0ODExN10gZmxleGNh
biA1YThmMDAwMC5jYW46IHJlZ2lzdGVyaW5nIG5ldGRldiBmYWlsZWQNCj4gPg0KPiA+IFJYIEZJ
Rk8gc2hvdWxkIGJlIGVuYWJsZWQgYWZ0ZXIgdGhlIEZSWi9IQUxUIGFyZSB2YWxpZC4gQnV0IHRo
ZQ0KPiA+IGN1cnJlbnQgY29kZSBzZXQgUlggRklGTyBlbmFibGUgYW5kIEZSWi9IQUxUIGF0IHRo
ZSBzYW1lIHRpbWUuDQo+ID4NCj4gPiBGaXhlczogZTk1NWNlYWQwMzExNyAoIkNBTjogQWRkIEZs
ZXhjYW4gQ0FOIGNvbnRyb2xsZXIgZHJpdmVyIikNCj4gPiBTaWduZWQtb2ZmLWJ5OiBKb2FraW0g
WmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25l
dC9jYW4vZmxleGNhbi5jIHwgMTYgKysrKysrKysrKysrKy0tLQ0KPiA+ICAxIGZpbGUgY2hhbmdl
ZCwgMTMgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jIGIvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYw0K
PiA+IGluZGV4IDAzOGZlMTAzNmRmMi4uOGVlOWZhMmY0MTYxIDEwMDY0NA0KPiA+IC0tLSBhL2Ry
aXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9jYW4vZmxleGNh
bi5jDQo+ID4gQEAgLTE4MDMsNiArMTgwMyw3IEBAIHN0YXRpYyBpbnQgcmVnaXN0ZXJfZmxleGNh
bmRldihzdHJ1Y3QgbmV0X2RldmljZQ0KPiA+ICpkZXYpICB7DQo+ID4gIAlzdHJ1Y3QgZmxleGNh
bl9wcml2ICpwcml2ID0gbmV0ZGV2X3ByaXYoZGV2KTsNCj4gPiAgCXN0cnVjdCBmbGV4Y2FuX3Jl
Z3MgX19pb21lbSAqcmVncyA9IHByaXYtPnJlZ3M7DQo+ID4gKwl1bnNpZ25lZCBpbnQgdGltZW91
dCA9IEZMRVhDQU5fVElNRU9VVF9VUyAvIDEwOw0KPiA+ICAJdTMyIHJlZywgZXJyOw0KPiA+DQo+
ID4gIAllcnIgPSBmbGV4Y2FuX2Nsa3NfZW5hYmxlKHByaXYpOw0KPiA+IEBAIC0xODI1LDEwICsx
ODI2LDE5IEBAIHN0YXRpYyBpbnQgcmVnaXN0ZXJfZmxleGNhbmRldihzdHJ1Y3QgbmV0X2Rldmlj
ZQ0KPiAqZGV2KQ0KPiA+ICAJaWYgKGVycikNCj4gPiAgCQlnb3RvIG91dF9jaGlwX2Rpc2FibGU7
DQo+ID4NCj4gPiAtCS8qIHNldCBmcmVlemUsIGhhbHQgYW5kIGFjdGl2YXRlIEZJRk8sIHJlc3Ry
aWN0IHJlZ2lzdGVyIGFjY2VzcyAqLw0KPiA+ICsJLyogc2V0IGZyZWV6ZSwgaGFsdCBhbmQgcG9s
bGluZyB0aGUgZnJlZXplIGFjayAqLw0KPiA+ICAJcmVnID0gcHJpdi0+cmVhZCgmcmVncy0+bWNy
KTsNCj4gPiAtCXJlZyB8PSBGTEVYQ0FOX01DUl9GUlogfCBGTEVYQ0FOX01DUl9IQUxUIHwNCj4g
PiAtCQlGTEVYQ0FOX01DUl9GRU4gfCBGTEVYQ0FOX01DUl9TVVBWOw0KPiA+ICsJcmVnIHw9IEZM
RVhDQU5fTUNSX0ZSWiB8IEZMRVhDQU5fTUNSX0hBTFQ7DQo+ID4gKwlwcml2LT53cml0ZShyZWcs
ICZyZWdzLT5tY3IpOw0KPiA+ICsNCj4gPiArCXdoaWxlICh0aW1lb3V0LS0gJiYgIShwcml2LT5y
ZWFkKCZyZWdzLT5tY3IpICYNCj4gRkxFWENBTl9NQ1JfRlJaX0FDSykpDQo+ID4gKwkJdWRlbGF5
KDEwMCk7DQo+IA0KPiBQbGVhc2UgbWFrZSB1c2Ugb2YgZXhpc3RpbmcgZnVuY3Rpb25zIGxpa2Ug
ZmxleGNhbl9jaGlwX2ZyZWV6ZSgpLg0KDQpPSywgd2lsbCBpbXByb3ZlIGl0LiBNYXJjLCBJIG5v
dGljZSB0aGlzIGlzc3VlIGFsc28gZXhpc3QgaW4gZmxleGNhbl9jaGlwX3N0YXJ0KCksIHNob3Vs
ZCBJIGZpeCBpdCB0b2dldGhlcj8gDQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0KPiBy
ZWdhcmRzLA0KPiBNYXJjDQo+IA0KPiAtLQ0KPiBQZW5ndXRyb25peCBlLksuICAgICAgICAgICAg
ICAgICB8IE1hcmMgS2xlaW5lLUJ1ZGRlICAgICAgICAgICB8DQo+IEVtYmVkZGVkIExpbnV4ICAg
ICAgICAgICAgICAgICAgIHwgaHR0cHM6Ly93d3cucGVuZ3V0cm9uaXguZGUgIHwNCj4gVmVydHJl
dHVuZyBXZXN0L0RvcnRtdW5kICAgICAgICAgfCBQaG9uZTogKzQ5LTIzMS0yODI2LTkyNCAgICAg
fA0KPiBBbXRzZ2VyaWNodCBIaWxkZXNoZWltLCBIUkEgMjY4NiB8IEZheDogICArNDktNTEyMS0y
MDY5MTctNTU1NSB8DQoNCg==
