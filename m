Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A239C374F6A
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 08:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbhEFGfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 02:35:20 -0400
Received: from mail-eopbgr80058.outbound.protection.outlook.com ([40.107.8.58]:4373
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230078AbhEFGek (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 May 2021 02:34:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JYTlGlhyX6eo1B4S1XmnpWk5B6PTuoMrfZw5DXnYjNGrQeMwVh/4Z89D9YyCjifRVRDmS/miNz0H1ZSDVZ4tRjNSjqeXCP155Vi7ZgBC9MrS7sxzE3GopNgIKXLHlb6a1830rZtAev4kgGyhCH92xMOw350kMbsW30hvNIKkgru37FiWsYjhS5Hn1GchuL82D1lfidHi7OF7n8F8dnXPHAjbYWUcnSSEY63YfwqAaVZA+M88O1KmSBje0KYXsD4vAUqh8Ga6tgC1Qb9c50y+8wkuJ5+i4ud76PI+DiofBNES0+yI+ox9/5hhFyIf3AxBCOLG7+roLqR4DlIKtfCOHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J2HmpI2J/dt2pb8YQkc7DYvqNFiTsZgfcNqYpCQisuo=;
 b=AHGZ4q/sJolpx8wi7qiXdfMNHBYnr2WnXU6R64AS3g9SmeTbdkW8RNPkO812tDZyIAT1DrbRnp/2IZOhDYbBHjB37g85uvy51oLL22C+hDO0bjAbYGUpPzO0zmON61uQHj0tiObrJNRkHlRZNSdvXo2L9snPWwmM12fTOu0yf7syvSWI72npr1TVMiH/DB7O07E71XB8v3CmHZ21FYoZEXiijsJ35qe1JX4MB2ZnnZQ6heiHyGCvvOLGpAoa73Kw3SRcPoIvRs3zEW50pPWdhxAt5AAmKuAUZmTbs5et7TO9q9rqbMsQIEfiYI5jkHkBtjw7dKV8rmsGvIofCbnXDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J2HmpI2J/dt2pb8YQkc7DYvqNFiTsZgfcNqYpCQisuo=;
 b=Vqpcw42+LujYTswxcxII0X/xA5pURQUH6SohsJIOnNGAiR13Dmq874riPfcAZDIUjeeL5gmx7+Gqa9WpQWmQDTNanOEXnBqE4x5Wf64pIrs3sn7yHiyhUPPURVDrcaj/I24kRnoNqdP6IhIaJX9KQQTI4s6IvlzyYAsGDIuZVoM=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6972.eurprd04.prod.outlook.com (2603:10a6:10:11c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Thu, 6 May
 2021 06:33:39 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4108.025; Thu, 6 May 2021
 06:33:39 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Jon Hunter <jonathanh@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "treding@nvidia.com" <treding@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [RFC net-next] net: stmmac: should not modify RX descriptor when
 STMMAC resume
Thread-Topic: [RFC net-next] net: stmmac: should not modify RX descriptor when
 STMMAC resume
Thread-Index: AQHXNRN2zsKOwhYLU0OtzigMEkddiqq78qqAgACuHyCAAMibgIACfU4wgADPWgCAAW5iAIAT9FVg
Date:   Thu, 6 May 2021 06:33:39 +0000
Message-ID: <DB8PR04MB67952FC590FEE5A327DA4C95E6589@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210419115921.19219-1-qiangqing.zhang@nxp.com>
 <f00e1790-5ba6-c9f0-f34f-d8a39c355cd7@nvidia.com>
 <DB8PR04MB67954D37A59B2D91C69BF6A9E6489@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <cec17489-2ef9-7862-94c8-202d31507a0c@nvidia.com>
 <DB8PR04MB67953A499438FF3FF6BE531BE6469@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210422085648.33738d1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <1732e825-dd8b-6f24-6ead-104467e70a6c@nvidia.com>
In-Reply-To: <1732e825-dd8b-6f24-6ead-104467e70a6c@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98a5d056-6cf9-4f28-93b8-08d91058e2c6
x-ms-traffictypediagnostic: DB8PR04MB6972:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB697227ED42A3EDCEDC1E9EA5E6589@DB8PR04MB6972.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 98TK73I/yOGfdcQfqRacwnsfnfpjNewUO8qIQStv7AAUIp5gZK09i4CevAggDM8KBUr4mSqdcYSpyOLZUN08ckBnKGs4XlViKG94qSnVQ3RXXegU1yUHrbOy0enPpVCYoXNbRBB3NKqBJ2jaU4Xdpo09TNtyNJeoDDBO0bCAZJ93XQ4acV1tQyugKxtBiW9iUZgZCBq3VGLlATjkii7dg994WyRB0v6RG1QgO1evlfVT24Ess51xfgZ+HVYP8BonU+HeQSFMs0EjYDdKjTA026UJpVQtwGHKB5R2kmfwQJ3Nao8UNLOlbcOIAkPenoRtHUPNQj6WVl3iCYvWfn27Z4+AvSCE+fq1v3UGJEfMHT14Io3G9skv1uz8If1ykYAIAsF4yZ1EMxMRDyErSrzlKNYDbLBvkwKG5nNisw5zwbU/c6bD9FX4IshBVZ0XCpvsN1ybWj7TgWgtdHsUZEZiXUlIMOJ9xlkgyEjCl8X54a8Scst1Nn6HbLSBdJWCIInuGSprJttnjOqOa2JwqbcHBsNyTfZAvqELEvYHzkoeoeq32lXk1pjD0a/iMJSWIFjpGZ5JsPsoihIMsYzBIjH/wqNqLl/ClEtHFlSh02zAilA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(396003)(346002)(376002)(8936002)(26005)(53546011)(478600001)(122000001)(38100700002)(4744005)(7696005)(71200400001)(83380400001)(6506007)(110136005)(54906003)(2906002)(7416002)(86362001)(8676002)(66446008)(66476007)(9686003)(76116006)(64756008)(66556008)(66946007)(5660300002)(52536014)(33656002)(186003)(4326008)(316002)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?MWhYbUgyNHhnUEJpZnIySXMvcEg2Z3lJa09mcGViVy82c2UrK1NldHFrM05L?=
 =?utf-8?B?RmZFcnczdVBxUlVtUmFXVk50MElQR0E1bUVvbWZPN24rWmUwa2ZDMW5zM1d2?=
 =?utf-8?B?OEt3NktycEx1bGNTZ25Id0wvc05ZMnhZZjJsMXpsUDgyc1ZVYlBLWjg3SkNP?=
 =?utf-8?B?V0dNS3JKSUpNbzd2NHUyVkZZeHVnWGg3Q29JNTlBV0lFMVJ1bnhDVi9TNWpM?=
 =?utf-8?B?L1dERTVpZFByRXh4UCs4eVVHc3cwQWlRdUliZEdQc04xd0lhQ0ZhKzZJNzZ3?=
 =?utf-8?B?aVd3L0pvYWpDUFEwOW84bTByWWZ4MEE0SVZXUWxwMUF5Z1dkWk5WUHB3a2wr?=
 =?utf-8?B?aUhMSFVpUzZoVkdUVU9UTTlpS3ppNElYQk9QTlNVeGx4MmNsNUxCOXBiZ3hF?=
 =?utf-8?B?WHl5dkRWcTh6SXIwOElwTVpiZ0wrZkhvZXVRMWorc0dQSjF0Tjd1bW9MeFBM?=
 =?utf-8?B?WmxJcENlSk1yb05HTTZ6WmQwaDhtUkZjNU45NEY4dENNSENQWVdITkFQVzVl?=
 =?utf-8?B?WVhtUXhLZzQyU3NVM25lMG5aaHdXcnlmY3R6MlpSMDMrQzg0Q2oxdXhKc3I5?=
 =?utf-8?B?Q1IyU0tGRTdJR0hNMUhGQVR2ZHBPS09qZkpZdVNEdWs0MFJRUHZrUG9uTG5y?=
 =?utf-8?B?UUNQbFBaRkMyWUF1NHZpZzRranJUNlhsZkNiQWhpZnQ4RXpOalRTZER1N0Nr?=
 =?utf-8?B?SnJRbEF4a2JxODdhenhJcjZtc1ZOZloyTFRTazdQNjJvaWVJYlNseFVKY3A0?=
 =?utf-8?B?dVhldW9JbVpvN1ZCdkdNeEhRRGxrcG9PcTlINHJKbHZZWE5uSjRsNmppNmtp?=
 =?utf-8?B?U2REdGZIa3ZvR29POTVsYTkwc0lyV0ZFTEhNU3RQVGJOZGNHbjlEVHVBVDU2?=
 =?utf-8?B?bTQ3Ynd3NDlNZEtFVWdpSUpiNDBDK3J5K2g5czJlQUhvcDlReUo1WmJ6VGU5?=
 =?utf-8?B?ZjNyMGZMMW9SSDNFdExaTjVXZitpUm94UW1HeTlNVTRXWHlzK0dkb3hvVUw1?=
 =?utf-8?B?L0tValJxWlM0Vk8yU3QwdWd1b1E3Y053dGdZeE1ZdG9lZlNubUdZUmVOZ2Rv?=
 =?utf-8?B?b203TDN3SlBJVEsrYm5NSi9uOGtyYkZvUzJhY01sREF1S0tBRVdoeGVqT1VI?=
 =?utf-8?B?NnI0OHo2TE9kSVpMeUxWRmZRanMrcXV0cnVhbUlmVUh4TlptcXZsd0tpQWpE?=
 =?utf-8?B?b1N5dHVNYm8vTDlXMnkyOUQ4VGVxZmFxRUJPZUNISUF1WEM1QjVkbXdHWldq?=
 =?utf-8?B?WWI3ZDB2NGltOGZ5blhpZ056QnBEOGY4NVJsV0FEWU5hV2E3UmhUV1V2aytZ?=
 =?utf-8?B?L3R1ODhHNzNRVERuRzJoeG9UNHFLd3VmQzZNVFhOdDdpODM3Mkg5M0lsNkEr?=
 =?utf-8?B?L2tRSzhXUWM1VzZVZ280blNHYlJGT1lyMG8xUTB2QWJJbDVtZGE5KzU0S3FK?=
 =?utf-8?B?bjFNb0l3VUFWWEpiNnFtWEpzZUhHa0swVTEyVW1qWkN1RzE3Snl3a01YZ1hp?=
 =?utf-8?B?NHk2UjhLcGNnc2Q3NTBFS3lBQW13b0hCd2VLU2h5dzlXa3hiTmw2OWZnV3di?=
 =?utf-8?B?cWk0STgwVTNHVXhFV21tRC9yeWFLN2xmSksvbWVhQkd3S0UrRHQxY0JQcFBm?=
 =?utf-8?B?aVQ3K1g5V2hTMFBEVE1lUE5WanJQM0ZuZjI5NG5jYXl2MklFVG4waXhBZCtm?=
 =?utf-8?B?TTFBdWpkRmQydGhBMkY3MThZYjgvSEdGMXlhUWliWEQzenUvSGxaQTV3dmR6?=
 =?utf-8?Q?zXILpSZ5pLlhLfkpKS0KQe3E6DXUsP1R6giMsfo?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98a5d056-6cf9-4f28-93b8-08d91058e2c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2021 06:33:39.5694
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b+f0hGBL7+KsF6w/x0YM3GdY3y9wncq6VQ/zbrf4ZrW9/JYZnTyUFEu41Z9ztr/yfTs8/DyNVoZXNGIwtzMC0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6972
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpvbiBIdW50ZXIgPGpvbmF0
aGFuaEBudmlkaWEuY29tPg0KPiBTZW50OiAyMDIx5bm0NOaciDIz5pelIDIxOjQ4DQo+IFRvOiBK
YWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgSm9ha2ltIFpoYW5nDQo+IDxxaWFuZ3Fp
bmcuemhhbmdAbnhwLmNvbT4NCj4gQ2M6IHBlcHBlLmNhdmFsbGFyb0BzdC5jb207IGFsZXhhbmRy
ZS50b3JndWVAZm9zcy5zdC5jb207DQo+IGpvYWJyZXVAc3lub3BzeXMuY29tOyBkYXZlbUBkYXZl
bWxvZnQubmV0Ow0KPiBtY29xdWVsaW4uc3RtMzJAZ21haWwuY29tOyBhbmRyZXdAbHVubi5jaDsg
Zi5mYWluZWxsaUBnbWFpbC5jb207DQo+IGRsLWxpbnV4LWlteCA8bGludXgtaW14QG54cC5jb20+
OyB0cmVkaW5nQG52aWRpYS5jb207DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVj
dDogUmU6IFtSRkMgbmV0LW5leHRdIG5ldDogc3RtbWFjOiBzaG91bGQgbm90IG1vZGlmeSBSWCBk
ZXNjcmlwdG9yIHdoZW4NCj4gU1RNTUFDIHJlc3VtZQ0KPiANCj4gDQo+IE9uIDIyLzA0LzIwMjEg
MTY6NTYsIEpha3ViIEtpY2luc2tpIHdyb3RlOg0KPiA+IE9uIFRodSwgMjIgQXByIDIwMjEgMDQ6
NTM6MDggKzAwMDAgSm9ha2ltIFpoYW5nIHdyb3RlOg0KPiA+PiBDb3VsZCB5b3UgcGxlYXNlIGhl
bHAgcmV2aWV3IHRoaXMgcGF0Y2g/IEl0J3MgcmVhbGx5IGJleW9uZCBteQ0KPiA+PiBjb21wcmVo
ZW5zaW9uLCB3aHkgdGhpcyBwYXRjaCB3b3VsZCBhZmZlY3QgVGVncmExODYgSmV0c29uIFRYMiBi
b2FyZD8NCj4gPg0KPiA+IExvb2tzIG9rYXksIHBsZWFzZSByZXBvc3QgYXMgbm9uLVJGQy4NCj4g
DQo+IA0KPiBJIHN0aWxsIGhhdmUgYW4gaXNzdWUgd2l0aCBhIGJvYXJkIG5vdCBiZWluZyBhYmxl
IHRvIHJlc3VtZSBmcm9tIHN1c3BlbmQgd2l0aA0KPiB0aGlzIHBhdGNoLiBTaG91bGRuJ3Qgd2Ug
dHJ5IHRvIHJlc29sdmUgdGhhdCBmaXJzdD8NCg0KSGkgSm9uLA0KDQpBbnkgdXBkYXRlcyBhYm91
dCB0aGlzPyBDb3VsZCBJIHJlcG9zdCBhcyBub24tUkZDPw0KDQpCZXN0IFJlZ2FyZHMsDQpKb2Fr
aW0gWmhhbmcNCj4gSm9uDQo=
