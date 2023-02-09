Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78A91690326
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 10:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjBIJRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 04:17:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBIJRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 04:17:31 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2079.outbound.protection.outlook.com [40.107.6.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557AB5B92;
        Thu,  9 Feb 2023 01:17:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mnkGAm3wha2nm3O9w4wh/p7YvvA1awasWJJ9qQpxnl2Eg+1PrScSJQsJj64e1werVrli7Plgbw7NmVeknlE0n26Bp2CCe80WxQN0RPgK74V0Fjts3KKfzvufNGDvZkIxw5RtD8FJUj/+bYm6UIANO06wUZKEVcrwFo7JK7t8lx8s5yS+aQdln6Ro1NcD75mD7k6abWUFuYdkV3LQGXMe0+sxvUogwmg7YNYI/E8QA8IHppB5r7QaUihfnoL3CEcXYKj+EdPRryxjNjGBHb8QIJFcUiLgtngNH/mWfc6DObXAs04gcSKQ5YOH2etXNpgOVMwWWx+z9alngZayAkX8Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6DwXHAM3VpYJOyemn9SSG6QBSivRHgltLNW+86XL7cA=;
 b=G/ajb8onUYsHmfKxQN2S5Rq8CPwpGGmjYqBCuA/NoWcqLkx1Tdn9Lm5sgNnbboeRgpa7De0yNqWSUSVsSIF/a0j9q2mQH4MnQFYiEtqWxtwHGWm2Vg5m8X8Dthq0m4kgKuptOGoT02HykLlRBXbScDsbLcGnd1TKf/fJunLPnkb6dkJkwCnetDh+5E5NZsBh03KgDvwTjR67oRQbZPp7LyfEUtuZDwS/Edg+UpWf6aLgwwq5oaTTZhR1o1dE+FDbFudHGaZj0IH1bbpiF44/DcXWSmvA18UN+Iojc01gVTPXYz1iEX/VGMvCXhovxNd4WOpDqQKLZ62F0GxiRSraHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6DwXHAM3VpYJOyemn9SSG6QBSivRHgltLNW+86XL7cA=;
 b=atDsfxitNSs8C+cKp0BV+F2/JE4k/JDLJxU3xcviVfNafFrM8fqQscHdeDzcWjj1YwQvvNM0QQi8UOqTsMP4D1Fs2LviEPoxRNFiiBkJV3C4WL/5ZVYtWOPv9q4Vudh5AxbI+9DrUdAANsYnbTb0FAQ+sdp7ZW74mOPwswoBqC4=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by PA4PR04MB7743.eurprd04.prod.outlook.com (2603:10a6:102:b8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Thu, 9 Feb
 2023 09:17:25 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f%6]) with mapi id 15.20.6086.018; Thu, 9 Feb 2023
 09:17:25 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     "Sverdlin, Alexander" <alexander.sverdlin@siemens.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
CC:     Clark Wang <xiaoning.wang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: fec: Defer probe if other FEC has deferred MDIO
Thread-Topic: [PATCH] net: fec: Defer probe if other FEC has deferred MDIO
Thread-Index: AQHZO6ayZHeilxi1lEmqNJcLCg64E67FyycAgABtnYCAABleIA==
Date:   Thu, 9 Feb 2023 09:17:25 +0000
Message-ID: <DB9PR04MB81063375BAC5F0B9CBBB6A0D88D99@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <20230208101821.871269-1-alexander.sverdlin@siemens.com>
         <Y+REjDdjHkv4g45o@lunn.ch>
 <9a520aac82f90b222c72c3a7e08fdbdb68d2d2f6.camel@siemens.com>
In-Reply-To: <9a520aac82f90b222c72c3a7e08fdbdb68d2d2f6.camel@siemens.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8106:EE_|PA4PR04MB7743:EE_
x-ms-office365-filtering-correlation-id: 4500852f-9f7a-4793-8574-08db0a7e757d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nLSjTjQvxd0Ou6qAgzedLTRNq/qT/tPJTp2Cbn345dae7aC/bTKDRL+ldY6dMNVtCm0ZbZhmq8Kw36dgZija2MS/EzE1EQq2Vm5EPD7W1CP966eUDslJeSInMea9T0gbzkJdVvzcBVTQo5oDL2tcSe6bNIOvztJ3WLAOybZmMQUcLGAl4PDqXCK1enL6LzFXH8kCVnyDwIb0OwcdV54S0RH5GVvj97KyANZLIM3V0yVEVDxbctXrnUtJ6hh/lDDBrGLcj4CZt6UqNEOCyKT2ElS3hmOZFcoAqxcMN5ly+/GkExpz3gkwyJkH7Tr0iinvThyoOub/fbONfzQRyoJmQIBe8AHkc7F5JeCfQntNeduZ8hf7jLiKzipxEAE9k/G6vPASxqjLEBCifN8RfFsJqQM+Z6L3AFywi5Pth8GzEDECykGqzysagNukovT8v+cfGQYOree3i1fjkDzzTrnT+Vxm+HUgQctJRyDLXr9j/EYAAj0urz/gWW6vxOUpWiEqj+LXT8Pnnl5ckl64IXmTNud2v64Peoc3DIuV+hblev3KYTQuRD6nu+XSyPyyN/HRAVazTqxBVi3Ti/RkFS9bNBelv5E54baLG4mndtn0iUVPhXZWxHGkx8dj2lt+YFwjKQc3Ga5nUu3fHtDTRVZANOMjbHCG5pSfUcfa4pcutGzBOKenQhpriTYhYUEpCpM8WFAQ1c9Jsu50jx6hr9MKOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(346002)(376002)(396003)(366004)(451199018)(66946007)(76116006)(41300700001)(66556008)(4326008)(66476007)(66446008)(8676002)(64756008)(83380400001)(38070700005)(478600001)(55016003)(33656002)(86362001)(122000001)(38100700002)(54906003)(110136005)(316002)(71200400001)(7696005)(186003)(26005)(9686003)(53546011)(6506007)(2906002)(52536014)(8936002)(44832011)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NnRHcHJWRDZhMTl6TEE5TGV2NWtRekUyVnVESmM2cE0ra1A1a2k5QWZhVXZs?=
 =?utf-8?B?aC9CTnB4Mk1vOGhjLzB4K0xNSFk2ZG01UCtrK2ROakNhUFVWR2Rra1Bmb1Z2?=
 =?utf-8?B?anpodU5sb3VYR3htOG8wSWlxUjJyamFXMWNXS3UwL2lvV3ZVSlZNQkw1U0RI?=
 =?utf-8?B?bE1ZaWpuK2NvUGNBN2Z3amRlSlFvMzU0V09hdnVxdkxNdHJzUk5Kd1EwSDVS?=
 =?utf-8?B?K3NkSW5YdGw0TktEaHVFQnJUR0c1UWdHMkNxM016TEYxRk1QaW9WQ1J3aWxx?=
 =?utf-8?B?QXYyVUlBbm9QdzV5MkJFV3I2WjU5RU5JazYyWkdvR2hhcWlIYkV4WHF3aVFB?=
 =?utf-8?B?bXFrcGQ3bjVNMDJYYVI0ZWdzZmtSVXlnWW5nYzl4dFc2SWJmWm9nRjgxdHBp?=
 =?utf-8?B?NkNBTTZkclg5TUFhZVV2UGdhZUJtMXdPZmF1aVhPNlFBTDc2Y3ZXaUxNN1Nw?=
 =?utf-8?B?ckZ3ekQ0RVdNaHRsRlpGSE9aMWoxaStCQUZtNzdIT0RNTTVZRmhqNlVlMytL?=
 =?utf-8?B?dUFCUmc0OUZIN0NtOVJ3NlB4Ly9JRG1KajdiMUE2R3U2aEJWTUFzQWpqejFI?=
 =?utf-8?B?OXN0clV5MmRMVWlEVkcwbVVDSVpBRW5kTU1MU0dBZTJIeHNrRmhUdk03clpv?=
 =?utf-8?B?Z0thVEp3WmhSTnI2Ujd0L094OUN3cEJJZWg2K0hxZ3F1Yys4eTRzeVRlbmdG?=
 =?utf-8?B?U2J4SDNtdHdlYWkvK2dLT0IwYURhRjUwZ2NWd2JnSTVXcTVmRGdpSWprci82?=
 =?utf-8?B?M0VlK2x1OUZtclFuNElGOGlnQXFIdFpaTlE0KytFWUVPVWVQVUpBVVR4UThv?=
 =?utf-8?B?RGkxekw3NS9KblRKbjRCQzVMeFpCTkFTMkpFQWZjRkdsVEZzS0pPalgybVd4?=
 =?utf-8?B?VVNRdGw0TXR3NjRVc01uME9SNlREc0c2YWlOM2hJZ3hPRmdDSDlpRi8wcXp2?=
 =?utf-8?B?bE5hYkJUb3lvbzFRNzRZZm40ZndkUHRPczJ2aUdDYVFMNGdGdGNvSElONUVj?=
 =?utf-8?B?OExTdG1aK2pCOGVoaFhKdzRKZHhTL3MzT0dOUXZJMDJOM0Y4bDBTa2NFQU10?=
 =?utf-8?B?OUV3cWpBTUtkdUlpcUdPK2I3ZXAxTGlzY1JmRDVHZkJXQkpBek5nNUNoMUx4?=
 =?utf-8?B?eEZYZ3FSVzdjdThpa3RLblkxOEVOZ25OY1R3U1lOeEFtK2FhVEZUcW9wZW1o?=
 =?utf-8?B?NGMwbm81alpUNFJTRk45ZHRHVHdkY2doSVc4d29saWFNcHIyVVZCcjJoZFIy?=
 =?utf-8?B?TEw1dG00Z3UvTXVCekhBTVpkclZ5Rzc3VnRPdm5OcWdmVVluSzhWc1lLaFg5?=
 =?utf-8?B?TzFDSndTczQ5RzBEVUoxdmZnVGFKTHU5RStZZzV0UFQ4N3BCSlpaQU1VRjVW?=
 =?utf-8?B?NlVKR2JIdmhwa3FsWUh2Z2pnUXI1WkczejZydjlCVDZibElmemp2cjRKZHQ4?=
 =?utf-8?B?YmJ4UHUxcllXK1ZBZTk5M1hxNVBRM1kzaDZGNXptY1MwYzQwcDliNmliSWt4?=
 =?utf-8?B?ZzVocVVrTlFZZXpQMmxna3dzNGZKbDlzdjZUUkhRT01lVS9zYS9wbUEwUTNv?=
 =?utf-8?B?aWVrdkhGTVIyWVFMRWJEdVNqQTdoZFMvandDQ1VhejFWTnU3aGUrQ1VFVzlY?=
 =?utf-8?B?a1VoS2t2RVRwSGZPTGtSNkRoQmg3MW1WSnhBUDVNNk1mYWR0VlNmY0pvMUFC?=
 =?utf-8?B?MDhlc0pwQjdhbjExdSt6T255WkpTNVdwcndVd1hucFgvMTVicEpvSG91MmF3?=
 =?utf-8?B?TStQNVpkVGRLU2I5MUVPRzhIRExxUFh5YmJQckZGRTVqZmFIb1JLTlhQV0Fm?=
 =?utf-8?B?dG5XYkkzVldKdklWNGphVThncFBvZUFzZk5GbE1XTHZnWStCbVRVcU5uTnpU?=
 =?utf-8?B?V0RnaTJabWpRK1JCTW1CNUUrUWVPUTcvZ2orZGhtMGZRbVJvMzNnM2VQeHdj?=
 =?utf-8?B?ZFJWK1hQUWJ3YjBMeUxEZ1JOY1dBUmpYcUJZeko2S3YrT3VDM08zSjIzSFpo?=
 =?utf-8?B?TzFLYmN6SUphZUZ3OEtEQnJBZldacElrd1lRQ0wwNjR6RDNieHZBaHhrNGFY?=
 =?utf-8?B?aXF2UU1TREJkS0JWVXFmT0F5M0dnSXozaWtIK3U5TnFHNlM2RG5nb0ovR1Yr?=
 =?utf-8?Q?7xMc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4500852f-9f7a-4793-8574-08db0a7e757d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 09:17:25.6062
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yFJUyjP+hnJP7xS+IqtyUwXnJTNYHUH0Ify05U3lJM4kaNTBaaLHeYCnBpSUw3zpXqROqf1XNo88nt2pV/9LAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7743
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTdmVyZGxpbiwgQWxleGFuZGVy
IDxhbGV4YW5kZXIuc3ZlcmRsaW5Ac2llbWVucy5jb20+DQo+IFNlbnQ6IDIwMjPlubQy5pyIOeaX
pSAxNToyOA0KPiBUbzogYW5kcmV3QGx1bm4uY2gNCj4gQ2M6IFdlaSBGYW5nIDx3ZWkuZmFuZ0Bu
eHAuY29tPjsgQ2xhcmsgV2FuZyA8eGlhb25pbmcud2FuZ0BueHAuY29tPjsNCj4gU2hlbndlaSBX
YW5nIDxzaGVud2VpLndhbmdAbnhwLmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+IGRs
LWxpbnV4LWlteCA8bGludXgtaW14QG54cC5jb20+OyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwu
b3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIG5ldDogZmVjOiBEZWZlciBwcm9iZSBpZiBvdGhl
ciBGRUMgaGFzIGRlZmVycmVkIE1ESU8NCj4gDQo+IEhlbGxvIEFuZHJldywNCj4gDQo+IE9uIFRo
dSwgMjAyMy0wMi0wOSBhdCAwMTo1NSArMDEwMCwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+ID4gPiAt
wqDCoMKgwqDCoMKgwqBpZiAoKGZlcC0+cXVpcmtzICYgRkVDX1FVSVJLX1NJTkdMRV9NRElPKSAm
JiBmZXAtPmRldl9pZCA+DQo+ID4gPiAwKSB7DQo+ID4gPiArwqDCoMKgwqDCoMKgwqBpZiAoZmVw
LT5xdWlya3MgJiBGRUNfUVVJUktfU0lOR0xFX01ESU8pIHsNCj4gPiA+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgLyogZmVjMSB1c2VzIGZlYzAgbWlpX2J1cyAqLw0KPiA+ID4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAobWlpX2NudCAmJiBmZWMwX21paV9idXMp
IHsNCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oGZlcC0+bWlpX2J1cyA9IGZlYzBfbWlpX2J1czsNCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoG1paV9jbnQrKzsNCj4gPiA+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAwOw0KPiA+ID4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB9DQo+ID4gPiAtwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgcmV0dXJuIC1FTk9FTlQ7DQo+ID4NCj4gPiBDb3VsZCB5b3Ugbm90IGFkZCBh
biBlbHNlIGNsYXVzZSBoZXJlPyByZXR1cm4gLUVQUk9CRV9ERUZGRVI/DQo+ID4NCj4gPiBCYXNp
Y2FsbHksIGlmIGZlYzAgaGFzIG5vdCBwcm9iZWQsIGRlZmZlciB0aGUgcHJvYmluZyBvZiBmZWMx
Pw0KPiANCj4gd2UgZG8gaGF2ZSBhIGNvbmZpZ3VyYXRpb24gd2l0aCBpLk1YOCB3aGVyZSB3ZSBo
YXZlIG9ubHkgZmVjMiBlbmFibGVkIChhbmQNCj4gaGFzIG1kaW8gbm9kZSkuDQo+IEknbSBub3Qg
c3VyZSBpZiBpdCB3YXMgdGhvdWdodCBvZiBieSBmZWMgZHJpdmVyIGRldmVsb3BlcnMgKGl0IG1h
a2VzIGEgbG90IG9mDQo+IG5vbi1vYnZpb3VzIGFzc3VtdGlvbnMpLCBidXQgdGhhdCdzIGhvdyBp
dCB3b3JrcyBub3cuDQo+IA0KDQpIaSBBbGV4YW5kZXIsDQoNClRoaXMgaXNzdWUgc2VlbXMgdGhh
dCB0aGUgZmVjMiAod2l0aG91dCBtZGlvIHN1Ym5vZGUpIHJlZ2lzdGVycyBtaWlfYnVzIGZpcnN0
LCB0aGVuDQp0aGUgZmVjMSAoaGFzIG1kaW8gc3Vibm9kZSkgdXNlIHRoZSBmZWMyJ3MgbWlpX2J1
cyB3aGVuIGZlYzEgcHJvYmVzIGFnYWluLCBmaW5hbGx5DQpib3RoIGZlYzEgYW5kIGZlYzIgY2Fu
IG5vdCBjb25uZWN0IHRvIFBIWS4gQW0gSSByaWdodD8NCg0KSWYgc28sIEkgdGhpbmsgdGhpcyBp
c3N1ZSBjYW4ndCBiZSByZXByb2R1Y2VkIG9uIHRoZSB1cHN0cmVhbSB0cmVlLCBiZWNhdXNlIHRo
ZSBxdWlya3Mgb2YNCmkuTVg4IG9uIHRoZSB1cHN0cmVhbSB0cmVlIGRvIG5vdCBzZXQgdGhlIEZF
Q19RVUlSS19TSU5HTEVfTURJTyBiaXQuIFNvLCB0aGUgZmVjMQ0Kd2lsbCByZWdpc3RlcnMgYSBt
aWlfYnVzIGluIHlvdXIgY2FzZSByYXRoZXIgdGhhbiB1c2luZyB0aGUgZmVjMidzIG1paV9idXMu
IEknbSBhIGJpdCBjdXJpb3VzDQp0aGF0IGhhdmUgeW91IHRyaWVkIHRvIHJlcHJvZHVjZSB0aGlz
IGlzc3VlIGJhc2Ugb24gdGhlIHVwc3RyZWFtIHRyZWU/DQoNCg==
