Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206AD4587EA
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 03:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbhKVCLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 21:11:09 -0500
Received: from mail-eopbgr70072.outbound.protection.outlook.com ([40.107.7.72]:37454
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229906AbhKVCLI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Nov 2021 21:11:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Or5wqi04gYE7B71iMPVvDTMQIiH71CjNBxqIWWb20mDLw1AwNOupOr/knpSSxi2aeCWOQsD54Y72igJE3ZyAlq76va5e/THewDLQVbvIw2nJHuKezwSDl/KKsnmEeJC5Me5J+Q6W7Ets6djwNTwviPY/9O7OCG/u5rCN8DqPN19qxa4dEYh2LU6rlC6Z7ierK7At7J+x1ndt3x/uMyPUuHqMO3uhIAxxG7tcyA4I6sd8QtIEysStq4swbPpevSuFbaeClrZfry0IqgM+z/Xe58uLKguvRrYCUjcZAt+f71iU19i2RXH1SAqaY1rutOE4oZ0FbAkl1X/OpPYikmoSYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NTkgcpcpu6JCMn2e67GsVp8QiT+eYywjmWHeD7ObQhY=;
 b=YDYgQIOz1wxXYXBhjbURFyfBVSn7Y9DI7f7xDP7myzkeQ1lQ19fU42X97q/qRw+FA573B2vYvtc+XnKbKJ9YBJjNTGCywxLdtnI2iHcdPQExWz76tXcgqvpzJ3HuwedQhEY2IcTpZb59zmHm1hYXzTY7tSlYAGMhHD6yDoc9on9++jbA/ebpK+rIBug6ymo8mUIhvbM3D+1gkNfj7kSXkTgNqSl5I4Mqzy5w4z7aKzVzLIzHX74rdYz/SsIvRg1mHV5Sg5/2FozsI6Fpxktp7EQ4o4W+HTh/krUegqxHjzIRwEHNgj1MmKOX0A8ye/qwbZVNiCfGrOhapxOyNW+hog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NTkgcpcpu6JCMn2e67GsVp8QiT+eYywjmWHeD7ObQhY=;
 b=pz4NlLe70QBW3/zJcRrGPSWgZA+ALBelo4X1bUksdwELChrQjgdFHjPYH/GCR6y3fQFiYx5vk0tKdBPbVjcRemCq2zSmtXwaF16hkbQdtJsMW7utzfnGq5hcR9S7brjq1iwGskRzOEF9mmdfengGh4kmbAmv16LY72iR9GPjOW8=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB9PR04MB8429.eurprd04.prod.outlook.com (2603:10a6:10:24e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Mon, 22 Nov
 2021 02:07:59 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::c005:8cdc:9d35:4079]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::c005:8cdc:9d35:4079%5]) with mapi id 15.20.4713.024; Mon, 22 Nov 2021
 02:07:59 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "Peng Fan (OSS)" <peng.fan@oss.nxp.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Aisheng Dong <aisheng.dong@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>, Peng Fan <peng.fan@nxp.com>
Subject: RE: [PATCH 3/4] arm64: dts: imx8ulp: add fec node
Thread-Topic: [PATCH 3/4] arm64: dts: imx8ulp: add fec node
Thread-Index: AQHX3gYULIwD3yvp3UGDoZ2PMByKjqwOx47Q
Date:   Mon, 22 Nov 2021 02:07:59 +0000
Message-ID: <DB8PR04MB679539B6A74FF1369210BCE3E69F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20211120115825.851798-1-peng.fan@oss.nxp.com>
 <20211120115825.851798-4-peng.fan@oss.nxp.com>
In-Reply-To: <20211120115825.851798-4-peng.fan@oss.nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 58ec4d8a-c75e-4825-6d08-08d9ad5ce844
x-ms-traffictypediagnostic: DB9PR04MB8429:
x-microsoft-antispam-prvs: <DB9PR04MB8429817F4E3875925F4A2B0CE69F9@DB9PR04MB8429.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qR8PeBf8B4vE6loDl7l7VOZsjqYFOXPvU5NJ7oskX4pEiLi9Ube+/S6tlxPhrQk/8Zu/OV9IrfxNonbg3sfT6Hot8JXggs4XvHzM7bgJrNrPBEEycOT+jPAeJ3m+1NEbDJdb3XC4KRxcvbqErbdg8O2r16Fs+0FDxud1p74Q88Cx1AviEeA/R0D2BCte20f8wZXnEFSFX0zQXn+RtAZs/nqHJ8KGZlSu7HlI4xpm4kw+Wob2+d7fzbJN6GG3JvfgNtC58uQd5S86CPFEjp/FlrFh/Ck3nJvkX3FmOiV0Iutwz58BWu5crRn2CuvBpNTLOhwAJ6zM8GZ/BGIiNzR/f5h6BM9yE9cmAWiIcozg6YU/euAmMKYHZ2vUspbcBPN38ElYre0C5ZNzQ7rwOKhzyadUWVDfKlhASvRxuzJqKrTHZcbyB4253cYfsDH0psxI85zfR2mUoTdfA2XfuGfZ5QlmNecXwWl07E8Qs0JsADBmrN75gqFepmLo78ywBOyMKlb3DT01cNSO1Ff3YU7PfMWUVUPispzb3cWIl95qPj4RS8nXvvcZdAmkX8WcGGfx0XyEAD8eOI+cxYhlNx1XTODVOvZsEnRpnOmFuJgBQ2DUSfEPIf0frCXFh1m1DcQBfwlL8upSp0pvxrk0GUbB2eN9dyFtLKRFncg24Wfs7B3A7GjzqKIcC6XmcPLxYNwYLFmWsQ/Qo5V2KpoveVWGk7ga6PF9w8UUP6YeLS2vzts=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(6506007)(53546011)(66946007)(110136005)(316002)(55016002)(7416002)(7696005)(9686003)(5660300002)(76116006)(54906003)(2906002)(66556008)(71200400001)(66446008)(66476007)(64756008)(122000001)(4326008)(83380400001)(38100700002)(186003)(52536014)(8936002)(38070700005)(508600001)(26005)(33656002)(8676002)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?aFQ0dHRERDVDSDhKM29DQkNId29ONVJocisrbHdkRWI4cGx2cTdnMlp0aUhh?=
 =?gb2312?B?WFVRRVBCMHo5Nnd6OHYvZWtMV0hET3JuMDJSV1ptalFkTFNyTzZKc011ZGhk?=
 =?gb2312?B?T0hnV2tzbDZwWGJXNUppdDdlMDZKbE52T0NEOW4wbnluUWJ1Z0RtNWY4bFM0?=
 =?gb2312?B?MllhTXRoRitIcllCM1JBUVFTTnZ5RkowQ0YyWFlGY2tRelJranhseldveGEr?=
 =?gb2312?B?a0h1cmh2Ukp5WlVBdjBuQmVJcy9wR0FpbU5YakxKQllVQzJNMFlOc2grNkhE?=
 =?gb2312?B?ekZXNEVmbnhBTFQ2TG1MNEFZNC9CaVJYM2krR291TGNydXNyVkMvV1BTRzVE?=
 =?gb2312?B?SklpVC96QitCSTVmMEUyNWZCSWIwOEtxTkxTQ3FJcFozWEY3VklldUZSSllx?=
 =?gb2312?B?bk5LdEJmZ1pUd0pwOVhZNmJmMHhTNU54VVFmSWxVSS9ueUgwWC9ISFVqNmVp?=
 =?gb2312?B?TVRweGJuRm9pWXI0RC9xTjQyek5VZ3dKWTdubkdRZVd3MWV2cS9oZmMwekp0?=
 =?gb2312?B?UDIzU0UyYlRmU0ZjNnQ2SDZZK2EyMC90K0F3cEU3UUZXOGJaSmVpOWlzZ3I4?=
 =?gb2312?B?Sk52UldtcUR0NEVxaUI3YUdJTk9jNXBUVTVxU0lvaTNTQTRnVmc5S0wvOTZH?=
 =?gb2312?B?eWFNeTBvb08wMHdtWGx1bFdPYjBRRWxwMU1WcXJsZFYrZmhFT0xiV0ZyeGJT?=
 =?gb2312?B?K05uWEo2R3VWdUE4dDVDZlJYR3lGWGI3RHh4NnBRc1diNjh6ME5UMnBYamxR?=
 =?gb2312?B?eW5SUXMvcjJ3cG14RDFqcVJKZXh4dmZGYWVHbjZXUFhvVTFXMnh6VVovYkNv?=
 =?gb2312?B?RnVOSkRmbWIzUEc1Z1JCOWpsUURETzZDYW1JL0hEMFpydXdqRVFVai83THMz?=
 =?gb2312?B?ZmUyWGYvNkVTTmIrTWpuRnVHK3pMRHAxYWNOcS9wdzhUK3VMTzFjRWxXTlNp?=
 =?gb2312?B?YjhJVnd5MnF4cXBIeXR0R2NGWksvQ0REVnEwRUNLeWlhMU1SQTlGVnhmbTVP?=
 =?gb2312?B?MElacU8zRlhvZTl1UHl2RVdnZHlCbVBaMllpVVh6TnZrakU3aXdFUnp3cFFt?=
 =?gb2312?B?YlN5dlRhTFRxRHZ1N0wvbUw2TzBUNFJQRzVIZUVEWWcrdHJQSnF0dW03Yi9C?=
 =?gb2312?B?M1cvZGp0elhZTFN0MFpUTjUvNEhad2lsdG0vZHdYcWdhNkFJRGZMVUlNZ3c3?=
 =?gb2312?B?eEJPTmg4L2dRN1plemhVS0pzRG42bDZHUjgvaEQxVEJQY2w5ZEk0OVVIRHdY?=
 =?gb2312?B?RHhzMGlTdjVuNm1BQ2VGZVA4SjhJK0hSdlhRcjV4dVQvMXVUZEhTcFoxYlBV?=
 =?gb2312?B?eGE0ZEkrUzEwRCtVdGsrSWNRL2o4MUNKa1kvN2RHVENySDhJN21RRi9neUta?=
 =?gb2312?B?Q2o2Nkc2R1dQcERTa2FreEkvUlVHVitDQm5ua0FobFVmdDBLVE9rYTd0ejFZ?=
 =?gb2312?B?NEl2K0QreEN3V0s3ZTlTMER6WHZGYkVVNDhUTW53RmZTRVpJUFBRMFF5YXhF?=
 =?gb2312?B?eUYrVmJ5bU9mYW9xeVplb2N0OFcrUHJRQmw3Q29iQ2o4RUxNWVpwV0l0Y1Zq?=
 =?gb2312?B?WkNLSTIvSGVyM3lOVklKZEJuME8yVGhFY2RWeWVORGhZRDA4aTh4Ym1QQmow?=
 =?gb2312?B?OTVPL3hqS2ZmakZhdUZWcDBPOUd6clF0cVpKTzlDL2J6R1MxdDBNKzFKVkU3?=
 =?gb2312?B?QmlvUXh0dGxRSVZHOFVET0U4MURicnNET3ZDQVd1aGJlK2w3QjVvSUNYU2da?=
 =?gb2312?B?UExSYU9hVTRSNmk4Z0RYYXlWdTBaaXlwbSt6L2NRa3cyTlo4cTB5akYwemVR?=
 =?gb2312?B?VzQ2MTk3bWNIK3JFSVpubFlBT2p6Z05zbllrRnJqdkxMYUJKeEpHQTc3QS8x?=
 =?gb2312?B?dFlIQ2dDNisrSGJ6L0FmbkJMY1ZIY01TVm5EcEt3NVBXUWpNWWtxWGN0aUtF?=
 =?gb2312?B?Y0VpU3hKL1BlVmRtSTRiSWg2SHFNa2RhZDFmbGxWcnlKUjNJVW5lZVlaR2Nl?=
 =?gb2312?B?S0tDY2ZQaExKRW5vdk9XcmhkZGhtMXlZbWY4b1ZXZFlIbTNWMHZZV2pUZjMv?=
 =?gb2312?B?VzVYZm1qUnBScDZJbVJIdHhmbVJOUGhEYXlJV09nZHpxRTlldXFHcDNQWEU1?=
 =?gb2312?B?NmdyVThUemhpRWQvaDY3YlJBYnVOVHBDYVFhQTVkMkxBeEh0aWE5SVI3bjFj?=
 =?gb2312?B?Smc9PQ==?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58ec4d8a-c75e-4825-6d08-08d9ad5ce844
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2021 02:07:59.4274
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w5IfpTYJ+52OWdGVpBhdTHdVI5uYpxeKd/mpnZ7BKn+uLE2xecE9a+Ti/JWjRtj4k4NjIhE75XeoqtLgvIrIaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8429
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBQZW5nLA0KDQpJIHNhdyBpdCdzIG5vdCB0aGUgbGF0ZXN0IHZlcnNpb24oY2xvY2sgc2V0
dGluZykgY29tcGFyZWQgdG8gb3VyIGxvY2FsIGltcGxlbWVudGF0aW9uLCBjb3VsZCB5b3UgaGVs
cCB1cGRhdGUgaXQgb3IgbmVlZCBhIGZvbGxvdyB1cCBsYXRlcj8NCg0KQmVzdCBSZWdhcmRzLA0K
Sm9ha2ltIFpoYW5nDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGVu
ZyBGYW4gKE9TUykgPHBlbmcuZmFuQG9zcy5ueHAuY29tPg0KPiBTZW50OiAyMDIxxOoxMdTCMjDI
1SAxOTo1OA0KPiBUbzogcm9iaCtkdEBrZXJuZWwub3JnOyBBaXNoZW5nIERvbmcgPGFpc2hlbmcu
ZG9uZ0BueHAuY29tPjsgSm9ha2ltDQo+IFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT47
IGRhdmVtQGRhdmVtbG9mdC5uZXQ7DQo+IGt1YmFAa2VybmVsLm9yZzsgc2hhd25ndW9Aa2VybmVs
Lm9yZzsgcy5oYXVlckBwZW5ndXRyb25peC5kZQ0KPiBDYzoga2VybmVsQHBlbmd1dHJvbml4LmRl
OyBmZXN0ZXZhbUBnbWFpbC5jb207IGRsLWxpbnV4LWlteA0KPiA8bGludXgtaW14QG54cC5jb20+
OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOw0KPiBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsg
bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsNCj4gbGludXgtYXJtLWtlcm5lbEBsaXN0cy5p
bmZyYWRlYWQub3JnOyBQZW5nIEZhbiA8cGVuZy5mYW5AbnhwLmNvbT4NCj4gU3ViamVjdDogW1BB
VENIIDMvNF0gYXJtNjQ6IGR0czogaW14OHVscDogYWRkIGZlYyBub2RlDQo+IA0KPiBGcm9tOiBQ
ZW5nIEZhbiA8cGVuZy5mYW5AbnhwLmNvbT4NCj4gDQo+IEFkZCBldGhlcm5ldCBub2RlIGFuZCBp
dHMgYWxpYXMNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFBlbmcgRmFuIDxwZW5nLmZhbkBueHAuY29t
Pg0KPiAtLS0NCj4gIGFyY2gvYXJtNjQvYm9vdC9kdHMvZnJlZXNjYWxlL2lteDh1bHAuZHRzaSB8
IDE4ICsrKysrKysrKysrKysrKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDE4IGluc2VydGlvbnMo
KykNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2Jvb3QvZHRzL2ZyZWVzY2FsZS9pbXg4
dWxwLmR0c2kNCj4gYi9hcmNoL2FybTY0L2Jvb3QvZHRzL2ZyZWVzY2FsZS9pbXg4dWxwLmR0c2kN
Cj4gaW5kZXggZWRhYzYzY2YzNjY4Li5lM2M2NThiNDVhZTYgMTAwNjQ0DQo+IC0tLSBhL2FyY2gv
YXJtNjQvYm9vdC9kdHMvZnJlZXNjYWxlL2lteDh1bHAuZHRzaQ0KPiArKysgYi9hcmNoL2FybTY0
L2Jvb3QvZHRzL2ZyZWVzY2FsZS9pbXg4dWxwLmR0c2kNCj4gQEAgLTE2LDYgKzE2LDcgQEAgLyB7
DQo+ICAJI3NpemUtY2VsbHMgPSA8Mj47DQo+IA0KPiAgCWFsaWFzZXMgew0KPiArCQlldGhlcm5l
dDAgPSAmZmVjOw0KPiAgCQlncGlvMCA9ICZncGlvZDsNCj4gIAkJZ3BpbzEgPSAmZ3Bpb2U7DQo+
ICAJCWdwaW8yID0gJmdwaW9mOw0KPiBAQCAtMzY1LDYgKzM2NiwyMyBAQCB1c2RoYzI6IG1tY0Ay
OThmMDAwMCB7DQo+ICAJCQkJYnVzLXdpZHRoID0gPDQ+Ow0KPiAgCQkJCXN0YXR1cyA9ICJkaXNh
YmxlZCI7DQo+ICAJCQl9Ow0KPiArDQo+ICsJCQlmZWM6IGV0aGVybmV0QDI5OTUwMDAwIHsNCj4g
KwkJCQljb21wYXRpYmxlID0gImZzbCxpbXg4dWxwLWZlYyIsICJmc2wsaW14NnVsLWZlYyI7DQo+
ICsJCQkJcmVnID0gPDB4Mjk5NTAwMDAgMHgxMDAwMD47DQo+ICsJCQkJaW50ZXJydXB0cyA9IDxH
SUNfU1BJIDEwNyBJUlFfVFlQRV9MRVZFTF9ISUdIPjsNCj4gKwkJCQlpbnRlcnJ1cHQtbmFtZXMg
PSAiaW50MCI7DQo+ICsJCQkJY2xvY2tzID0gPCZwY2M0IElNWDhVTFBfQ0xLX0VORVQ+LA0KPiAr
CQkJCQkgPCZwY2M0IElNWDhVTFBfQ0xLX0VORVQ+LA0KPiArCQkJCQkgPCZjZ2MxIElNWDhVTFBf
Q0xLX0VORVRfVFNfU0VMPjsNCj4gKwkJCQljbG9jay1uYW1lcyA9ICJpcGciLCAiYWhiIiwgInB0
cCI7DQo+ICsJCQkJYXNzaWduZWQtY2xvY2tzID0gPCZjZ2MxIElNWDhVTFBfQ0xLX0VORVRfVFNf
U0VMPjsNCj4gKwkJCQlhc3NpZ25lZC1jbG9jay1wYXJlbnRzID0gPCZzb3NjPjsNCj4gKwkJCQlh
c3NpZ25lZC1jbG9jay1yYXRlcyA9IDwyNDAwMDAwMD47DQo+ICsJCQkJZnNsLG51bS10eC1xdWV1
ZXMgPSA8MT47DQo+ICsJCQkJZnNsLG51bS1yeC1xdWV1ZXMgPSA8MT47DQo+ICsJCQkJc3RhdHVz
ID0gImRpc2FibGVkIjsNCj4gKwkJCX07DQo+ICAJCX07DQo+IA0KPiAgCQlncGlvZTogZ3Bpb0Ay
ZDAwMDAwMCB7DQo+IC0tDQo+IDIuMjUuMQ0KDQo=
