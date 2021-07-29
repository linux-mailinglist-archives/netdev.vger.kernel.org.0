Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9CA63D9BD1
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 04:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233507AbhG2CcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 22:32:08 -0400
Received: from mail-eopbgr130085.outbound.protection.outlook.com ([40.107.13.85]:42209
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233256AbhG2CcH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 22:32:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DUMPyjTa+YhuPCDNfvz2bFzEree/JMH3S0bkbvBGelkD/s9HrU0aCzKVtL1djz7k1+k62Gq0RR2aRd1eG58J1kjkwhcekxZXOx+GoqvGgzMLkAYUxapCKA+E1L3ep/7vY7sVcbvXzwwlhWvswzrZFPZMl1QZMqGxayJWnfISKejdCOgoy8KOFyEAkjU5S8KInk4smG4vQ6sN73azkINneS7LwyuGox0PiZifySTtDe2fHEvB0bVqpPemQeHohNieJU2yDxkOX3dTdvVbBdHACYCDNDHUZkfdbkGUhYeDkPwHAvp9lMeRBuL4L5X54KgbfdoI6ezTyp2Vj9vsMmf1IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PdetnhdUKgXtf6Y7paH+HdVHwLbVcsmJRdzfeoRydeM=;
 b=BxW/CXUINQwQnXaBhgBrOAMPBLNKrjNIkF/KVer8FkS/VFqFfrrxc1A5rThh6r6ruzv5tk5B+tHSYDjlNlsA8xEAVKL/bCJx5h+W9iTde0HdoLwuaSpbhi/8DnGIjaTEVQS+Oh/dqZEiu7cC5hem5yCaxPvrjLGbVkNikQZc3pDBVEzGH1LoeLK1OZJobU1/jC1pGkF47gE8YI6f7xaCu3w3JzViMZZk0j4f9lENCLu9u5GifNGdtCsiN+aqNMZn1w6oVX6KyxZimSfzap8DFGlYHYxqco+tDZ3+io9Yr8mptByFtRs5M33aFCioYzrdg1Ebsk2pMrDq67Tw1A2bgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PdetnhdUKgXtf6Y7paH+HdVHwLbVcsmJRdzfeoRydeM=;
 b=MK21c6vTI7hMTd0NF1NXZA4M11HYqvEmIbZ/ORmagn81ZZLl6eTLHKomDnGgzRqLXmP9fGjGCdJYfyJIF+d8LNYxf+qJ3PndjqfLhcSXtxezkeEmGlI/DZjuj9QGkKXrrQUGIQmGfMJX6hcsdUT4yEgGiRGawkxIkoA2FYIYcpU=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB5787.eurprd04.prod.outlook.com (2603:10a6:10:ac::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Thu, 29 Jul
 2021 02:32:02 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4373.021; Thu, 29 Jul 2021
 02:32:02 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2 net-next 5/7] net: fec: add MAC internal delayed clock
 feature support
Thread-Topic: [PATCH V2 net-next 5/7] net: fec: add MAC internal delayed clock
 feature support
Thread-Index: AQHXg6cAboDpCGozNkG/XLYPAsqKlKtYbWuAgADKAeA=
Date:   Thu, 29 Jul 2021 02:32:02 +0000
Message-ID: <DB8PR04MB6795AE88083D595D275C3B2CE6EB9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210728115203.16263-1-qiangqing.zhang@nxp.com>
 <20210728115203.16263-6-qiangqing.zhang@nxp.com> <YQFlZ+eZRTikjItm@lunn.ch>
In-Reply-To: <YQFlZ+eZRTikjItm@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8551be45-efb9-4d17-e755-08d952390c9f
x-ms-traffictypediagnostic: DB8PR04MB5787:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB5787BB4ACD122343369639E6E6EB9@DB8PR04MB5787.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UUHW9MppsXSJriFs0z3OwbDP6KfEWxud37AQzqLn/kCWTVypu/EsoCEitOQlUrT1QRCWY7Z1iRUCt7AhOS2UJQlxDfqssX7VnWJj2ySw6Jw+9Bl9q3oCDxr29gvD0hDWMQJBaqBLs0ubAgL1r3LtB8jU7DdvL5P8Yptt1tyOpDO1EyRMOCqyz2TxB+MHOD35reSa8W1N6cR+ileJYP7kh+U8SqYt8Mae2A/G+/00CIiJRWO3TLRsk/eDpn8QOHV0SwTXOZF8/VTWHO1DcSCpuxYvTVXctYq4aS5/IPJ8IiYyY9N4ISQTzDvKiPC6bBoBFBxV3KAoCqmtMoXKZQhhWRe4KgPNZn9W7vaqDYvAUobKhJMtC7048H0gDrG33ATTqCAGmvloPyaL7AydGQkrrF904AomK/G1U31lmRcQimDuwyKp4VX7LzK8TXBIUgWCqM5dGN+PXCoQkC9jCmAlOCurUkUa1B8K5ydrFBuG5eTuAeSbbnUlD7oxg3u4pwNC7mUoSeoMYXBNB9hFCWqYAFm6fDLi8zdYYXFIbr577ovnRwqXnAT65awXB/0+veIlgNmnD7DX0Lau0OW2u7fihw00ug/e5lncZqwUpQNjknIcTi8gidMr0IppA9yxgvNBzuud7szpA1htv1iifJ0gMJyCMMiFy6SDANLYW42yn5gKOjwJb8inPNXI+acNlghg635cqP55XfHg+Q/iymPvSg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(366004)(136003)(39860400002)(478600001)(9686003)(2906002)(33656002)(71200400001)(26005)(7696005)(55016002)(86362001)(6506007)(38070700005)(5660300002)(186003)(53546011)(52536014)(76116006)(8936002)(83380400001)(66556008)(66946007)(64756008)(54906003)(66476007)(316002)(66446008)(7416002)(4326008)(122000001)(8676002)(38100700002)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?Q1crMFNoNEpBMVdWTFp1VzdpdlJCWWRqalJPR2dZM2pJQm1tODVWdGo5OFVN?=
 =?gb2312?B?QkdqQ0hjYlVMRkcwN3BxVk5JMTFwU2hCVTN5TmthbkZOUk9oTTcwQ0pBSGpU?=
 =?gb2312?B?OTE1bkEwVWhhRVZ4cWhIL3cybW9CSG9Pdm0wSSt3TTBkMzduOXFERmZPZmxm?=
 =?gb2312?B?TnAwQW83aWkxeXJtSjFyeTF2V2xGS29BL3FrVWlZK3BnWWhkTHljTUhvemJz?=
 =?gb2312?B?cWtoeUpoQVV5T00xNVN5empIcEVLdVplZWRZM1hmRXhVdlVPWDlyeWRYNnJl?=
 =?gb2312?B?Mi90alhsTnlXOXdrbDVRLzk0YyswUEVwQVRQbWdWN0NIMmpmc3JrMEpiWWdT?=
 =?gb2312?B?cXFhOWJ1M2I3K0pKejVaRmxaYUQ3NFM4WUlpbFdQakRLV09xRnZSaS9vSlRn?=
 =?gb2312?B?RDRpTU1rWHVUV2x3d0FicjZ1VmVtWU9XRVNBZUFHckRUOERSbXlVQ1paWjN5?=
 =?gb2312?B?UTdKSHdBbCtJNnVvMC9mbXV3WnczTWZ0ZVhHakVCWjFReFA2ZHg2K3h6Rmc0?=
 =?gb2312?B?VURaWUwvSzhpcUl0NXd2S200M0VGZlVYU0RaTkhDZDNYRlBBM0p3K2NFR21p?=
 =?gb2312?B?U00xNEppMmcwT2w4eHRnZ05naVcxb0RnMThEcnlEdHNVVmk4dEZ1MXJDcWNH?=
 =?gb2312?B?WmVGd1o5UVl4emdLUVdFVUkyYmd5QTVQNXZLQ1NrNHFncGtjeVJ3ZDFVbm12?=
 =?gb2312?B?Y3FmSHJQODBjR0Z6dU05ZmNQZlRENU4vWG5lcXJSdW5wRjRBaE0ydjN5VHoy?=
 =?gb2312?B?M0dTRmRud0cvamZvSjlFR2gvbmcxb2psOWNFZXBTT3RGYkUvckdVUlZWRDYz?=
 =?gb2312?B?ZU9odlVHK2ZTQndVQTZxM2FjNzVPaTRZMU5FUGM4RzRBZjN5V0xwWTZRcjc4?=
 =?gb2312?B?TWNibVRjLzI0bVBKTU9SbHJLWXZFVk9vTDg4aWEzM0poc2VaVmt0eXNZWkZy?=
 =?gb2312?B?UWJZK0Z0MXpXSC9hVkhEZ1BFeXJwSHE2YjJOdzZhV0JrcXlURTVPNzBobEdp?=
 =?gb2312?B?b2hYMy9WVyt5Nkk5Z3ZpM2FmWFk4UC9IaktCZFo0NS9lRHhGOTNPa1d3Q2V6?=
 =?gb2312?B?NDZLejZia05JUlY5eEJhTlFRZkd4MnNiM3BCQ3pzcG1uL0w5ZU12T1lla1pw?=
 =?gb2312?B?SlV2T3VlUkRPRU85bmRhcU1KS2VsbUJoeS9vandZUEkwdU80MkJkYjFXcjZv?=
 =?gb2312?B?YmVHaElhK0h2T2ZjZ1RsMWdjRlk0VE5oNmVzQlBVYXNPbW5BMGZlcmJvY3Zs?=
 =?gb2312?B?VmhQWFRISkxzYjR6bGlvNnBhVXVRKzRFSEFQdWlRNTd3cTNERVBDcU9TdDc2?=
 =?gb2312?B?NzltL1M5U3RGVjZUWVJ4ZXNHNXM5M0NkT2tOQ0NyZ0dxUVR3SDFxQk1JYjdQ?=
 =?gb2312?B?ME9aZVRqVHRxNGNXVGIyeTVnT1VMZERaaWtzeGFoZmRjOXVPM0Jod2pvbmNU?=
 =?gb2312?B?U0czZXk2WEJoMUliWWQ0OGN2aHBBTnphMGxqcDFZVENqTzRaYmxCM2V2Rk80?=
 =?gb2312?B?Tm0wSlpKaW9pZ3RBMi9mVE9rZ2l3aVVqa2NFRWZyWG1reGp4RXRodkE3bXhN?=
 =?gb2312?B?cGNuK0VYcHF6YytrR2xxTDFDZ1E3R2NDNEo1YmVra0ZhbUhEZkpIeEJvSTFx?=
 =?gb2312?B?RlNFclo3Z0RkSHVxaGNNUVBGbDJ5bEpvRVNHamI0NkwrWW9sWnhSbmhjazgy?=
 =?gb2312?B?ekJmMmZaTFhjTkVTalpyOG1mcTJ2ZUZMVjJWMVBtNVMvNXc2aC9rTlY1ZXJw?=
 =?gb2312?Q?VcnudkaMFjIPmvI2L9VoPzPu/cpvYxAMkkuUHoh?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8551be45-efb9-4d17-e755-08d952390c9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2021 02:32:02.6571
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6YdTbQ31vC/PpyJ5lIHyy3OAjgi8dqvWKq+jshPoQyz6iHsJ1SkxAORdaL1fNHpjPoFblWr1GOCJJJxvcuT4hA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5787
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEFuZHJldyBMdW5uIDxhbmRy
ZXdAbHVubi5jaD4NCj4gU2VudDogMjAyMcTqN9TCMjjI1SAyMjoxMQ0KPiBUbzogSm9ha2ltIFpo
YW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gQ2M6IGRhdmVtQGRhdmVtbG9mdC5uZXQ7
IGt1YmFAa2VybmVsLm9yZzsgcm9iaCtkdEBrZXJuZWwub3JnOw0KPiBzaGF3bmd1b0BrZXJuZWwu
b3JnOyBzLmhhdWVyQHBlbmd1dHJvbml4LmRlOyBrZXJuZWxAcGVuZ3V0cm9uaXguZGU7DQo+IGZl
c3RldmFtQGdtYWlsLmNvbTsgZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhwLmNvbT47DQo+IG5l
dGRldkB2Z2VyLmtlcm5lbC5vcmc7IGRldmljZXRyZWVAdmdlci5rZXJuZWwub3JnOw0KPiBsaW51
eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggVjIgbmV0LW5l
eHQgNS83XSBuZXQ6IGZlYzogYWRkIE1BQyBpbnRlcm5hbCBkZWxheWVkIGNsb2NrDQo+IGZlYXR1
cmUgc3VwcG9ydA0KPiANCj4gPiArCS8qIEZvciByZ21paSBpbnRlcm5hbCBkZWxheSwgdmFsaWQg
dmFsdWVzIGFyZSAwcHMgYW5kIDIwMDBwcyAqLw0KPiA+ICsJaWYgKG9mX3Byb3BlcnR5X3JlYWRf
dTMyKG5wLCAidHgtaW50ZXJuYWwtZGVsYXktcHMiLCAmcmdtaWlfZGVsYXkpKQ0KPiA+ICsJCWZl
cC0+cmdtaWlfdHhjX2RseSA9IHRydWU7DQo+ID4gKwlpZiAob2ZfcHJvcGVydHlfcmVhZF91MzIo
bnAsICJyeC1pbnRlcm5hbC1kZWxheS1wcyIsICZyZ21paV9kZWxheSkpDQo+ID4gKwkJZmVwLT5y
Z21paV9yeGNfZGx5ID0gdHJ1ZTsNCj4gDQo+IEkgZG9uJ3Qgc2VlIGFueSB2YWxpZGF0aW9uIG9m
IHRoZSBvbmx5IHN1cHBvcnRlZCB2YWx1ZXMgYXJlIDBwcyBhbmQgMjAwMHBzLg0KDQpIaSBBbmRy
ZXcsDQoNCkkgYWxzbyB0YWtlIHRoaXMgaW50byBhY2NvdW50LCBzaW5jZSBJIGhhdmUgbGltaXRl
ZCB0aGUgdmFsdWUgdG8gMCBhbmQgMjAwMCBpbiBmZWMgZHQtYmluZGluZ3MuDQpJdCB3aWxsIHJl
cG9ydCBlcnJvciB3aGVuIHJ1biBkdGJzX2NoZWNrIGlmIHZhbHVlIGlzIG5vdCBpbnZhbGlkLiBB
bm90aGVyIHJlYXNvbiBpcyB0aGF0IGFjdHVhbGx5DQp0aGUgdmFsdWUgaXMgbm90IHByb2dyYW0g
dG8gaGFyZHdhcmUsIHdlIG9ubHkgZW5hYmxlIFJHTUlJIGRlbGF5IG9yIG5vdC4gSWYgbmVlZCwg
SSB0aGluayB3ZQ0KY2FuIG9ubHkgYWRkIGEgZGV2X3dhcm4oKSBoZXJlLCBpbnN0ZWFkIG9mIHN0
b3AgdGhlIHByb2JlIHByb2Nlc3M/DQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0KPiAJ
QW5kcmV3DQo=
