Return-Path: <netdev+bounces-8709-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 650A47254A1
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 08:48:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C53DF1C20C7A
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 06:48:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D7224690;
	Wed,  7 Jun 2023 06:48:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B58B647
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 06:48:26 +0000 (UTC)
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2081.outbound.protection.outlook.com [40.107.241.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E7D1723
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 23:48:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ju58d5iEqW7NTB1VM6vn/HzW+ZEXHbMt+TgaYXC0tzL9Bzqr25jcPhZhw105kxrErOBlAqimHnJ5i2l8EOx850O/lFGJrxFfsLIvrV/xy3rBo4KwGtAgVehVYen6Pvtrc2U+2FvVSF+lyH3W13aiMUNSy4B8IYFCkxz8MG30pMp6nfRuVgPBRinaSBHpBwnzY1fLwgl2pW/MydMdDRfMNvajehyWsNv9F7FfZkeaoez9mlLJbR/8PwKjlfn2thJ4wphkH4F4WtuSaJ+GICRyF+vGA+ZDjn2R5UA6ggG+xNmWN+JPmW4kkK8vv1GVyLaDoKuahxrZx8XN5NiEXwymlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b+Hbsdw9Ge6n3Fd65PReMO5ZD5ab1nVKnvRCemjtW3M=;
 b=XJfed/uLEF1EfV4Vf0hKAg6rsWvT00VWMImT1lk3TXJyczCSTFJzqwGTdTiFgvHmK8w7gbBvwJxpxjHRVTUqSsUaj8SloxKUG2KN0QCEKojxD8Hz2mrv6dDv8PL27mHWiWitcWVh5V+0sGbNHHRucWk9T9A6KpaH2O6eYCTyxGyJDVO+JTI/SHdnfu1LWHBJgdgHKhCP78EiOFkNES230qcANXkK30EsdI/G1Lr/hjBVh2GBGNNBp4RjPngiY/BmBv+fdzrg6xczAYys7F3e362uEI8gCiQIgwx7oS9Hc4CqVrWqW5ce6v7JMIsSgz8CdDFTKu9x9PWcCruqFCsxkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b+Hbsdw9Ge6n3Fd65PReMO5ZD5ab1nVKnvRCemjtW3M=;
 b=UUcJn58/9+Dw4RsMrL/iMOhW230JUwsmv3IumxaaZqOYQe9oraUE9IC1e0ZS2AKiLo0CgnFaylzL4TvzaomNcXxrsFYPhYOKBMmDgx4sVDOk4AgKNt4Fu8BEKIMWqFG79eNGIIFma/3FBsK7HvAsNcFUfihFvpZfuW9/9j90NO4=
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com (2603:10a6:206:8::20)
 by AM9PR04MB8681.eurprd04.prod.outlook.com (2603:10a6:20b:43c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 06:48:20 +0000
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::1edd:68cb:85d0:29e0]) by AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::1edd:68cb:85d0:29e0%6]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 06:48:20 +0000
From: Wei Fang <wei.fang@nxp.com>
To: =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= <u.kleine-koenig@pengutronix.de>,
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Marc
 Kleine-Budde <mkl@pengutronix.de>, Damien Le Moal
	<damien.lemoal@opensource.wdc.com>, Michael Ellerman <mpe@ellerman.id.au>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Rob Herring
	<robh@kernel.org>
CC: Shenwei Wang <shenwei.wang@nxp.com>, Clark Wang <xiaoning.wang@nxp.com>,
	dl-linux-imx <linux-imx@nxp.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "kernel@pengutronix.de" <kernel@pengutronix.de>,
	Michal Kubiak <michal.kubiak@intel.com>
Subject: RE: [PATCH net-next v2 3/8] net: fec: Convert to platform remove
 callback returning void
Thread-Topic: [PATCH net-next v2 3/8] net: fec: Convert to platform remove
 callback returning void
Thread-Index: AQHZmJQA2uSZjPvV7ES4/amSaqnjI69+5n1g
Date: Wed, 7 Jun 2023 06:48:20 +0000
Message-ID:
 <AM5PR04MB3139844BED84F444D279790F8853A@AM5PR04MB3139.eurprd04.prod.outlook.com>
References: <20230606162829.166226-1-u.kleine-koenig@pengutronix.de>
 <20230606162829.166226-4-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20230606162829.166226-4-u.kleine-koenig@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM5PR04MB3139:EE_|AM9PR04MB8681:EE_
x-ms-office365-filtering-correlation-id: c7974e00-3f76-4c2c-f5f1-08db67232eb1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 TY2dSIIZmVGo9shPTdaSjIV0Ryo0F0Z/H2LSJ3H2fW5EYuKaXlP6DgeTGDJgATUlIGDy2WZTxnFfds/A4ZD8zOwgQBZIOtnZa3COyT5IyM1DC+I5sqTo5UMf1Jju6clt+9qkE3KRwnXOVNHyJ4/2QjSsrZObAvON1cFwIvNsjOqdoJNlku2wcSgr79yXenDNQ8LCxkgMzxhaKtUkKwxrcEfhJpa8EDA0D833ObI01GBJmE9nGyo7AnHD3QK50pC6jQaEa92A05ahjdUlK83aZr+2jO/WN4QAA/WaAZnQDSip3kG9JopDJ9sim0qE18Bf8ORyoHOjxvxLoCo7Nw9CZJIbMPCKBWZkjKpgOMRDIqRw6T15dnGwgxQ2NxTfbFQJaJhzt5GgNyFVPPUtJT8tgr/LEjeMXIrWrerqYUxv9reCEQjzX7FCJt4dtTM1UMZFR1HKRAO11FKFX7P34/BCg4hgjHcBVzrZDl27qSm0YzzBJG20YjAnXX4GTuFAzqItnB4RrqXaehPoD0MYjFBfIctT4jz7h7DfSdrqCzvglqwz1XtPF3EFHXWLPkk7z/ZSmgVphNCAob/pphlYpVdL3CxVj6ZhV0SPIV4DRzMhctEJpuw4Fklt9uHs7pwTR4njcTZ9W+/How/P+qIIggyOow==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3139.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(366004)(376002)(39860400002)(396003)(451199021)(83380400001)(122000001)(4326008)(110136005)(921005)(54906003)(66574015)(66446008)(64756008)(66946007)(76116006)(66476007)(38100700002)(71200400001)(7696005)(478600001)(66556008)(186003)(2906002)(8676002)(38070700005)(52536014)(8936002)(41300700001)(33656002)(5660300002)(316002)(55016003)(86362001)(44832011)(7416002)(9686003)(26005)(6506007)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MEgrM3lIYWN6UUxYNFZJWTdJcnd2bThYSWdzWUlTWW0zek8xR2dQTnRLU3FZ?=
 =?utf-8?B?M1NyZDJUM3hKY241RlVxMmlSc2owZ3pqckhpWUVndi9OcnBac2IzY005MEJk?=
 =?utf-8?B?L0ZKQTJ5SUFMSEVNOE5aZHlSUlhscWpUbnJWSFpZaHZoRXVaOVdNRW9MMnQw?=
 =?utf-8?B?ZWxhQ01BWUtWZ2FPQ2RUWHprUVZDdUVBbUE2a3N6aG5RTmpHVnJDc2VsOVQr?=
 =?utf-8?B?eExEUE5aVE91RjZsMUU5bVBCUmlFUmlhSUZ0aGgxaEJMS2huelFEdEZzSkxX?=
 =?utf-8?B?NUk5L2svTG9qTWwycS9yaFpDWDNIYTk2VjhSWkt3OGNETjRWRTRHdTZGckVu?=
 =?utf-8?B?Nm5EaDJYb29uQU0wK2poZERHNndnS284dEJnRlcwZTh4NnI0aEJFTFVBYzhO?=
 =?utf-8?B?WEpWVWFnUFZFZFMxVzhPUUR1TUsrOEFmNi9rSUVyNnF6c0pCTlRnZnM4d3Vm?=
 =?utf-8?B?ckM4aXBwRWZtc0I1R0NIVDZOQ0xSMDYxVmRrRDBuVU1PMGp5OTdlMWUyVUdQ?=
 =?utf-8?B?dXcrR2g5YnZwMkZHZFFLT0hLWW8waUJ3WE9jTzdaSFo2Uy9najZSenZNT1Ns?=
 =?utf-8?B?ZkVoUHY5aDVwUVFEV3Q2QmlNaUx6dk9kbUZWdkxvd05sbENvR0MwV2pMVUp2?=
 =?utf-8?B?TU9rbjB2eHUrcXBBaVd4M1FacnpmVTRQdkxYV3ViRDg0bkhTSklwbURHRzNz?=
 =?utf-8?B?SXhENm52NzdWdHFobzI0MFEwci9PL0QvOUJrMXNlK2FaSk0yMUNhNDcycWZC?=
 =?utf-8?B?bk9KZzZlZVc3eWRwOU10MGMycFFvbnlBWjdNZGJ3dlRTcU9YSmc0b0tSQUJR?=
 =?utf-8?B?MGV6Vk93Z0d1Q0JjejNxdFh6bHhyZWRVbXo4UVk5ZVZmK1ljMkR4L2pZOTB5?=
 =?utf-8?B?WEJrL3JLenROUGpyVWVadG8zaE5CUW01V0FZWVlHbE90T0QzZVdnZUZRWTNv?=
 =?utf-8?B?bU52N2FtQ1dNa3NuZXQ0L1R5RGJaNUVmZFlvekppZXhxVDludkFjcXJYTFdl?=
 =?utf-8?B?a3FHWTdqQnZ1QXNYUnBoaFdmVy9iNkVET0tjWWlXZ2VtTWJ1Z2VoREFNK1gw?=
 =?utf-8?B?T0w1NlluVW9JK1ZFb0dsNXFoVllUajcrWEI3bFRKNzVoZzMrNm13WU5EMTFY?=
 =?utf-8?B?cFBKSW5vRUgyOWd6ZlhHbEJIL3dOTWxWWWVnWTJpdDFkSUlNbmtFd0NlbmlC?=
 =?utf-8?B?VnN6L2xZbDVVK1BnZ3h5TERyNE5QbnB0ckEwVHF1d0pZbEhOMGR6cFFxdVFw?=
 =?utf-8?B?WlowS2k0R0gxV1VTVzRrVS9YdGl0S1dCSGx0MGRiU1U0UXU3cXJUSDdyaEF1?=
 =?utf-8?B?U1I4SW5aOHlpNHpkcUJBSHpobkIwRTJQUUpQMmg3Uy9DNGJKOHJhWFlucGRz?=
 =?utf-8?B?SzVjWk5sRjdEeDhnVnpnT25ZY1lJUjhCeTBDa2FHamJuS1VhWG9IVDRCcUp4?=
 =?utf-8?B?aEE5b3dZaWg0S2c0aSsrUUk1aEJmeWNVT1JDaWhHbzVZem5SWDhyenFTdzlN?=
 =?utf-8?B?YUJ6QXJhVXJZK0ErMUVubG03RTZKdGpzZ3AyeXFpYTJSMzhsc1JoaFMzRlRp?=
 =?utf-8?B?Z1Axb1kwZ3U2VGs1V08wVUlISTlYdnFRYmNvWnlZMmF0WHA2YlJRMHphcDIy?=
 =?utf-8?B?QVBtYmUzUFdlY2FIOG9hcnFvMGRFRXhObmlKZ0NEenEwOEtJS1RrSm11NzhY?=
 =?utf-8?B?UzhzcTZOWFkvdDYvVlBCZDYxS0sxMDViZ2lDOFM2Z2RGUG9nOVgwNWlNN3FD?=
 =?utf-8?B?TS82MGlBNW5IUVJiNGpZN1dmRFNTMmN2cExHaGpWQjJzdGxzZWYwMGVGMGI0?=
 =?utf-8?B?MVRsOU1XOHltbVp4UHlFcXM4OGhIamNNbmtLK2F1QzZ6Yjdoa1Bua0ZkR0sx?=
 =?utf-8?B?ZFgvNWZMdWRibTVENWxONzcvUi85YnJaZmJ3LzhhcXpOdXN2ajZFRHNPdVJY?=
 =?utf-8?B?TVkrMXpyamU4L0xSLzRoQlZBQzRvN25SRERybXd1cTFYSU1ycEN1THAvMmlM?=
 =?utf-8?B?WDJXTjJvVEZSSHlaZ3NRTFpmV1dHZi9LSnVPN2RFbWpHR3hYWkZPQk9sMlVT?=
 =?utf-8?B?RmlEQ3cvV3Z5U202cllhbk1CSTY3ck1EdzJOUTVmRGVzUmFMaW94Q1FRSW1V?=
 =?utf-8?Q?IuME=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3139.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7974e00-3f76-4c2c-f5f1-08db67232eb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 06:48:20.7885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KdvycmtL69ZysdjLSSVasdad6o++dR5Tbt3Zp/pU/0gOzVwTthjKnb7ZqnKZjbUCHePAM/hLvAUGKF8eQAArhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8681
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBVd2UgS2xlaW5lLUvDtm5pZyA8
dS5rbGVpbmUta29lbmlnQHBlbmd1dHJvbml4LmRlPg0KPiBTZW50OiAyMDIz5bm0NuaciDfml6Ug
MDoyOA0KPiBUbzogV2VpIEZhbmcgPHdlaS5mYW5nQG54cC5jb20+OyBEYXZpZCBTLiBNaWxsZXIg
PGRhdmVtQGRhdmVtbG9mdC5uZXQ+Ow0KPiBFcmljIER1bWF6ZXQgPGVkdW1hemV0QGdvb2dsZS5j
b20+OyBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsNCj4gUGFvbG8gQWJlbmkgPHBh
YmVuaUByZWRoYXQuY29tPjsgTWFyYyBLbGVpbmUtQnVkZGUNCj4gPG1rbEBwZW5ndXRyb25peC5k
ZT47IERhbWllbiBMZSBNb2FsDQo+IDxkYW1pZW4ubGVtb2FsQG9wZW5zb3VyY2Uud2RjLmNvbT47
IE1pY2hhZWwgRWxsZXJtYW4NCj4gPG1wZUBlbGxlcm1hbi5pZC5hdT47IEFuZHkgU2hldmNoZW5r
bw0KPiA8YW5kcml5LnNoZXZjaGVua29AbGludXguaW50ZWwuY29tPjsgUm9iIEhlcnJpbmcgPHJv
YmhAa2VybmVsLm9yZz4NCj4gQ2M6IFNoZW53ZWkgV2FuZyA8c2hlbndlaS53YW5nQG54cC5jb20+
OyBDbGFyayBXYW5nDQo+IDx4aWFvbmluZy53YW5nQG54cC5jb20+OyBkbC1saW51eC1pbXggPGxp
bnV4LWlteEBueHAuY29tPjsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsga2VybmVsQHBlbmd1
dHJvbml4LmRlOyBNaWNoYWwgS3ViaWFrDQo+IDxtaWNoYWwua3ViaWFrQGludGVsLmNvbT4NCj4g
U3ViamVjdDogW1BBVENIIG5ldC1uZXh0IHYyIDMvOF0gbmV0OiBmZWM6IENvbnZlcnQgdG8gcGxh
dGZvcm0gcmVtb3ZlIGNhbGxiYWNrDQo+IHJldHVybmluZyB2b2lkDQo+IA0KPiBUaGUgLnJlbW92
ZSgpIGNhbGxiYWNrIGZvciBhIHBsYXRmb3JtIGRyaXZlciByZXR1cm5zIGFuIGludCB3aGljaCBt
YWtlcw0KPiBtYW55IGRyaXZlciBhdXRob3JzIHdyb25nbHkgYXNzdW1lIGl0J3MgcG9zc2libGUg
dG8gZG8gZXJyb3IgaGFuZGxpbmcgYnkNCj4gcmV0dXJuaW5nIGFuIGVycm9yIGNvZGUuIEhvd2V2
ZXIgdGhlIHZhbHVlIHJldHVybmVkIGlzIChtb3N0bHkpIGlnbm9yZWQNCj4gYW5kIHRoaXMgdHlw
aWNhbGx5IHJlc3VsdHMgaW4gcmVzb3VyY2UgbGVha3MuIFRvIGltcHJvdmUgaGVyZSB0aGVyZSBp
cyBhDQo+IHF1ZXN0IHRvIG1ha2UgdGhlIHJlbW92ZSBjYWxsYmFjayByZXR1cm4gdm9pZC4gSW4g
dGhlIGZpcnN0IHN0ZXAgb2YgdGhpcw0KPiBxdWVzdCBhbGwgZHJpdmVycyBhcmUgY29udmVydGVk
IHRvIC5yZW1vdmVfbmV3KCkgd2hpY2ggYWxyZWFkeSByZXR1cm5zDQo+IHZvaWQuDQo+IA0KPiBU
cml2aWFsbHkgY29udmVydCB0aGlzIGRyaXZlciBmcm9tIGFsd2F5cyByZXR1cm5pbmcgemVybyBp
biB0aGUgcmVtb3ZlDQo+IGNhbGxiYWNrIHRvIHRoZSB2b2lkIHJldHVybmluZyB2YXJpYW50Lg0K
PiANCj4gUmV2aWV3ZWQtYnk6IE1pY2hhbCBLdWJpYWsgPG1pY2hhbC5rdWJpYWtAaW50ZWwuY29t
Pg0KPiBTaWduZWQtb2ZmLWJ5OiBVd2UgS2xlaW5lLUvDtm5pZyA8dS5rbGVpbmUta29lbmlnQHBl
bmd1dHJvbml4LmRlPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9m
ZWNfbWFpbi5jICAgICAgICB8IDUgKystLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVz
Y2FsZS9mZWNfbXBjNTJ4eC5jICAgICB8IDYgKystLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5l
dC9mcmVlc2NhbGUvZmVjX21wYzUyeHhfcGh5LmMgfCA2ICsrLS0tLQ0KPiAgMyBmaWxlcyBjaGFu
Z2VkLCA2IGluc2VydGlvbnMoKyksIDExIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNfbWFpbi5jDQo+IGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2ZlY19tYWluLmMNCj4gaW5kZXggNjMyYmI0ZDU4OWQ3Li5m
MmIzMzNiM2Y4YzUgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2Fs
ZS9mZWNfbWFpbi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNf
bWFpbi5jDQo+IEBAIC00NDU4LDcgKzQ0NTgsNyBAQCBmZWNfcHJvYmUoc3RydWN0IHBsYXRmb3Jt
X2RldmljZSAqcGRldikNCj4gIAlyZXR1cm4gcmV0Ow0KPiAgfQ0KPiANCj4gLXN0YXRpYyBpbnQN
Cj4gK3N0YXRpYyB2b2lkDQo+ICBmZWNfZHJ2X3JlbW92ZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNl
ICpwZGV2KQ0KPiAgew0KPiAgCXN0cnVjdCBuZXRfZGV2aWNlICpuZGV2ID0gcGxhdGZvcm1fZ2V0
X2RydmRhdGEocGRldik7DQo+IEBAIC00NDk0LDcgKzQ0OTQsNiBAQCBmZWNfZHJ2X3JlbW92ZShz
dHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KPiAgCXBtX3J1bnRpbWVfZGlzYWJsZSgmcGRl
di0+ZGV2KTsNCj4gDQo+ICAJZnJlZV9uZXRkZXYobmRldik7DQo+IC0JcmV0dXJuIDA7DQo+ICB9
DQo+IA0KPiAgc3RhdGljIGludCBfX21heWJlX3VudXNlZCBmZWNfc3VzcGVuZChzdHJ1Y3QgZGV2
aWNlICpkZXYpDQo+IEBAIC00NjUwLDcgKzQ2NDksNyBAQCBzdGF0aWMgc3RydWN0IHBsYXRmb3Jt
X2RyaXZlciBmZWNfZHJpdmVyID0gew0KPiAgCX0sDQo+ICAJLmlkX3RhYmxlID0gZmVjX2RldnR5
cGUsDQo+ICAJLnByb2JlCT0gZmVjX3Byb2JlLA0KPiAtCS5yZW1vdmUJPSBmZWNfZHJ2X3JlbW92
ZSwNCj4gKwkucmVtb3ZlX25ldyA9IGZlY19kcnZfcmVtb3ZlLA0KPiAgfTsNCj4gDQo+ICBtb2R1
bGVfcGxhdGZvcm1fZHJpdmVyKGZlY19kcml2ZXIpOw0KDQpUaGFuayB5b3UhDQpSZXZpZXdlZC1i
eTogV2VpIEZhbmcgPHdlaS5mYW5nQG54cC5jb20+DQoNCg==

