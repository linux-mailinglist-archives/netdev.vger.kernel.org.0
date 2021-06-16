Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5723A9506
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 10:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbhFPIav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 04:30:51 -0400
Received: from mail-eopbgr30077.outbound.protection.outlook.com ([40.107.3.77]:24190
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232098AbhFPIat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 04:30:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MM9pU8UThvr6HSYnj3BkGKKc3InOQm6Il4r1LWdTVtFIfySPTvKHy5Wn9rXQHM+aldYziOAsbzw7T5XTSAU1JRIEeUIv7TdOZvOAW04ZjCeJaBKSfvctQt4Uulji3+ePEfiFYbMGrHVknVzbRrnY5MRu8N+mZCQ6P1oemtJhP+LFBMF2H2X2cjZuN8L0jWlDm/LeGyF8CwH0Fpa1Rv3eJ/i7nHCvPz5AstrrV1sHEqJ2oTOwu2TAqpgQga4qM6I1pMolg6+rE3E1RWc8hGFlwsI8zgADIjW26FYSrkc2gJz71uN8f2apIGCxcxnk2qX9aymyQkQ1HoMzLtwQyjWL0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8r872WdPrnmTveDdPsMAqr8ks2rL73AdJXwuYkcbUao=;
 b=N/gliBIz6H84W7eHTQmBw9YhG4TUbQiaaZ+o3jsBOsKqEahJu+9gm4wZJ0+lC8sI1ybtdzx+6se1GheTBKqC3Tmty7dMxiA+q0j+mzEyCTGMslap26rsoJ/pmUztB56w/0/jH6Pouz/2FFKrZ6ulbrqn8cNCaVaNGz3VlTykgHJvpNk70POoHU0Ur8o7O5+hyXFBm+J76hx7SCmLgtbZB58zq0RZU8dqspzKwlgaiEizLPJaCocbdQa69mg+Un93cjOXPygksNR0hqtneCHTKgZm3OqTqN/gUOrX0eMON2Ua3yX4GlBhwhw9PkN6MsTl8DSv5jWHz8CMfiuPQYJePQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8r872WdPrnmTveDdPsMAqr8ks2rL73AdJXwuYkcbUao=;
 b=fBvKSQO4JDRhH473CsovOlGKoorkaG3BhMNj0yEBSQmlZwGvG2JXnYMHt6WxRouEFx8Y2G4Lns5xlWIuqbOmCrQW7WkW1Iasguz8vGHteezVseLI7EkjOSXldBxvkocQyisis6z6xS9NujcRqThBLesZRhZ8bVs8FSjzA4sNB6o=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB6137.eurprd04.prod.outlook.com (2603:10a6:10:c1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Wed, 16 Jun
 2021 08:28:40 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4219.025; Wed, 16 Jun 2021
 08:28:40 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "frieder.schrempf@kontron.de" <frieder.schrempf@kontron.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2 net-next 0/2] net: fec: fix TX bandwidth fluctuations
Thread-Topic: [PATCH V2 net-next 0/2] net: fec: fix TX bandwidth fluctuations
Thread-Index: AQHXXqdJJp2Y2RcztU6Ho2b70gc0WqsPQnYAgAVNuXCAAHYrgIABTjKQ
Date:   Wed, 16 Jun 2021 08:28:40 +0000
Message-ID: <DB8PR04MB6795A2A1D51D95E996B7B75FE60F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210611095005.3909-1-qiangqing.zhang@nxp.com>
 <20210611.132514.1451796354248475314.davem@davemloft.net>
 <DB8PR04MB679518CF771FEBE118E395A3E6309@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YMicuzWwAKz5ffWB@lunn.ch>
In-Reply-To: <YMicuzWwAKz5ffWB@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8c9378c3-4595-450c-45f4-08d930a0bf07
x-ms-traffictypediagnostic: DBBPR04MB6137:
x-microsoft-antispam-prvs: <DBBPR04MB6137538DFD14A1343C6A47EDE60F9@DBBPR04MB6137.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QmAm7n8ivkg/C8V/o+jnMQ+NQyTRXtP+SvFcjELsvtfaxSkmVIbNtVAcqL8c4PjpHt2n9bTyA6GUG4Ujf1l44xiv2e3KcKwc7eH2TMKCa52d+lNEHxyJ7WiYeo5SYpYlJ8ibegIt0hQ4iLFVc1s7NWgRqCqJ9Q1+LDJk7c0jDZmK0hNKWqS1IGajPyB+CneEShs2UXXYXCB2DokBLGeE91s6q2P5FqzXj3dmiXcx47/Kw0tgxWFEejcm6svZjed4ANZ4ji5P5xyGSOKWynnLkY30SZg73bRO06+juxGGprSx3hFjQMRVJOty+QEj12iZeTGLynLDy+Y3c+oDgXda+KmlFuOlS7wGV/EaQQW82WN3F2IqCeeZTdoQNm99yZ7VBy7j6dDmGZ/3veNW7IeLMrdw/hxBj5kxK/7pYGPNU4w8f41GDjEdA+gxEBgM1V+pagXC1rffkifR4NwJwN0SXCfpuUldN93Wj5afJoYig574seuQRGLKzxjXfR+jd3+AGovNlcnFzbG0Wg0rChItuB90SWE6ULdV2kulAj5w0YCWUrEYFO0i6F0cvVwsB+1578yPrktE4NRvez7d4kDeLYwODDBnLSeBdNOUUeM2cmo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(39850400004)(346002)(396003)(366004)(76116006)(9686003)(66446008)(110136005)(33656002)(66556008)(64756008)(2906002)(66946007)(52536014)(122000001)(478600001)(71200400001)(4326008)(5660300002)(38100700002)(66476007)(53546011)(7696005)(54906003)(55016002)(4744005)(26005)(8936002)(186003)(316002)(8676002)(83380400001)(86362001)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?VG83Z0prVnJjdEtUdktpRHQ1M1crUXBOcC9wT0VCWlFjMFlLeDgrRWpMTnp5?=
 =?gb2312?B?UGxDL0pVQ0FqckRFQzNMRmtjVDlidnd0a2JJSTN2Tzg5OTFjbFN4R3VnaXFV?=
 =?gb2312?B?U0Q2ZklqQUhjQThRaW8wTGo3VFVmcklQNk80bW00YklPSVh5NTNWd2ZzNmN0?=
 =?gb2312?B?ME1HeDdOdzVFb2M2QzdoeUFHNGp3ZUJVT3czcHpOWnRkakcxb2I3cXZ0czBa?=
 =?gb2312?B?a3drN3dTY1p1T1Y0Y2taMkpuSXFLMm43VVliL0dTVk02dzJ2ZlJRZ0N2K3FZ?=
 =?gb2312?B?bUNZT3FJaXM5czRaYzFRTDZ6TkRxR3dxbmttc0x3c3hONk50SENSL1RMT2hr?=
 =?gb2312?B?OEVnWFdmYm1OVkgwd0diNkc4NnltaEx0TXhzSFBKQzJlQWNMc0xzUkxZU0gv?=
 =?gb2312?B?WUZFMkdpTFFMT3lkR3pXZ3JnV0hkQzJncU1Sa0ZicWs3TlBNdU1tTkZzU3U1?=
 =?gb2312?B?WUpDZ0lSTjhmMFprbkFVQUtzTm5oQU5WbDZ6VGlwRDNOUnJDcEtUUlJzM2JB?=
 =?gb2312?B?cit1VVdmUHFJN3NRYzV6Q1hDWUdpNDA0U0lDWW9jSHYvMHRUa1lvdlhJUjRn?=
 =?gb2312?B?T2NDUkdiWDZVZ0plTlRMeFRieWdXYkpTbWU4T3Nrci9sOVJuclpoOURyWEh5?=
 =?gb2312?B?NjNERUFXUkw3bzBuUzBpZ051VTQrbEw0VnVEenY5VXdRNU04aE1KU2FsSXQv?=
 =?gb2312?B?emJTTUhvUXlkdnViYkRDZUdGRDFEdDFMV0dJV2pXa1ZnZURhdWdyMDU1WENH?=
 =?gb2312?B?V1RTemV6QlVnOGxsWjRkQkdjNEpNblFmUEY1alZHSVAwRFB6S21RMXZ5aG9u?=
 =?gb2312?B?aTMyK0JzTExDK3VQa3hyU01GbUNyaXZ6bytJVU5CSFpUU2NFQWFWZWc5ckM2?=
 =?gb2312?B?Q0hVZ3B5TDAyblh6ZjAwZGdRSHVZZjh3Z2l3UVNNbHFrNGJHTG1IT2hxU3N5?=
 =?gb2312?B?dmhBblBEYTZnNHlkT3BMMCtjRnRXdzNLdzNack5DUTdLYkNydGsrU01uNjk2?=
 =?gb2312?B?VnVjTFZwTlRPMmNsdmk4dTVjbFBBL3BNbWdZNFV0L0h3TjJ5QmpUTXMzNCt3?=
 =?gb2312?B?bTlHTE1GdWZlVURmVWF4dlVNcThpdmwyMmZTbi9HTHBERjl1WFlxT05QLzJZ?=
 =?gb2312?B?OE1WNm82M01ZY1lJKzJDbURMUGFjY3ZyZzBadVZFdThSK2NNTWlDWkM2ZEw0?=
 =?gb2312?B?NklNOWxRTTRQcGpFdzJNNE5OZjFvM3NuN2NjUFpCUVdhVzFwTjM3OUhUMVlX?=
 =?gb2312?B?YTFGNGxkZ2xwMWVsYzk3Nm5KQ0plaTVMelBDRDQ0a2xmRVJaVFRwN1luMkNK?=
 =?gb2312?B?N1JGdi9hdnRZbVVLcXBBY1BJUUttZkJsb25jVmRxOWJJWGhIcDY5QlBtZXJz?=
 =?gb2312?B?RGhweUtNSXNqUE5iQ21aeU1LSVFBMzNUQ1RRbEJwT0ZaRDNFQjJYb3NQNkdo?=
 =?gb2312?B?NGkwbEZ0a1hIemRxS0VXR0lKYjdLWWVLUTQ2VDY0SDlVUTFKakliUHBtZm96?=
 =?gb2312?B?eElKajNGSExSNGVjK3l0aEZPTkhDMFRQczR3OWUwekpQMk5WWTN0dEE5eFA5?=
 =?gb2312?B?WDNlMWhtUDdacUE2dWczdjN3TGIwMW1tRzVJc3VrQXdaU1l6Z0U1c2daQnhV?=
 =?gb2312?B?Q05HWlZCcDJxY3lRdmJwUVJoOHBoY1p0ejcwZVF5cU1nQXY2aWtmaS9kaFlY?=
 =?gb2312?B?dXNTeXB3MFBBNU1tOFo2UXlUODZwM2VZeHFJU3JzY1lMVXljUG1keFh0bDUw?=
 =?gb2312?Q?pFqP8oivQlAdfa8sZ8=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c9378c3-4595-450c-45f4-08d930a0bf07
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2021 08:28:40.1865
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1nPeLBQjtU09Lo0g/+yFEf1xdjrQ1aMJcrxg8B09quDe0dheZ0oGRy1DY5M0m38+4hx2R+gPFgLL+vOoVFnoXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6137
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBBbmRyZXcsIERhdmlkLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZy
b206IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD4NCj4gU2VudDogMjAyMcTqNtTCMTXI1SAy
MDoyOA0KPiBUbzogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gQ2M6
IERhdmlkIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IGt1YmFAa2VybmVsLm9yZzsNCj4g
ZnJpZWRlci5zY2hyZW1wZkBrb250cm9uLmRlOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOw0KPiBs
aW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggVjIgbmV0
LW5leHQgMC8yXSBuZXQ6IGZlYzogZml4IFRYIGJhbmR3aWR0aCBmbHVjdHVhdGlvbnMNCj4gDQo+
ID4gSSBjYW4ndCByZXByb2R1Y2UgdGhlc2Ugd2FybmluZ3Mgd2l0aCAiIG1ha2UgQVJDSD1hcm02
NCBhbGxtb2Rjb25maWciLA0KPiBjb3VsZCB5b3UgcGxlYXNlIHNob3cgbWUgdGhlIGNvbW1hbmQg
eW91IHVzZWQ/IFRoYW5rcy4NCj4gDQo+IFRyeSBhZGRpbmcgVz0xDQoNClRoYW5rcy4NCg0KSSB0
cnkgYmVsb3cgYnVpbGQgb3B0aW9ucywgYWxzbyBjYW4ndCByZXByb2R1Y2UgdGhpcyBpc3N1ZSwg
c28gcmVhbGx5IGRvbid0IGtub3cgaG93IHRvIGZpeCBpdC4NCg0KbWFrZSBBUkNIPWFybTY0IGRp
c3RjbGVhbg0KbWFrZSBBUkNIPWFybTY0IGFsbG1vZGNvbmZpZw0KbWFrZSAtajggQVJDSD1hcm02
NCBDUk9TU19DT01QSUxFPWFhcmNoNjQtbGludXgtZ251LSBXPTEgLyBtYWtlIC1qOCBBUkNIPWFy
bTY0IENST1NTX0NPTVBJTEU9YWFyY2g2NC1saW51eC1nbnUtIFc9MiAvIG1ha2UgLWo4IEFSQ0g9
YXJtNjQgQ1JPU1NfQ09NUElMRT1hYXJjaDY0LWxpbnV4LWdudS0gVz0zDQoNCkkgc2F3IG1hbnkg
dW5yZWxhdGVkIHdhcm5pbmdzLi4uDQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0KPiAg
ICAgQW5kcmV3DQo=
