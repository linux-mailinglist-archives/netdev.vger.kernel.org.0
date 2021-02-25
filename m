Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737263248D0
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 03:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236826AbhBYCQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 21:16:30 -0500
Received: from mail-eopbgr40087.outbound.protection.outlook.com ([40.107.4.87]:11251
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236783AbhBYCQO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 21:16:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TAmbzypnIkj8cQa/7gywKVxGwMYcUws7JJohsbfQUjv6ffDFfPRIOC2dnjvkVf+GmrGGv56FvvT6f2pCx7xaCfbwkWQ1FqE35yC6zgQSWOAB17srn3kLq63WRSM2E3tsAo6wN6VUHdhFpq0/FXZZZHnWIGtYpLvyK+WUikxyD+lNJP5I7B+XRw5IgLK70XiEtJ7CvDjpwKhyu2wQ1cRRLnNYQqs7PEXnXriPnGv01BYPQmsbsDNWaYqBKfhnaHbBPmvdsWjk1Mu+kzuVOAOmLKS0+rIfXLgNxoDhu5bXqvSnsQ0n7MvZ/zcouwVgHZLaMIKFEhwqDcvaYD5nMDEeyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tojH11VopLd8Ijqh/iCiTXYtH6WyCy+Vztz+Rya3JQ4=;
 b=nfspVz5BXmcaVVFgbVYR2iIsyFYUwtJQu5WdMXwQWdef5Qmy13JlWEJ4RisQbhlU3BIO4U8mEXhTGk5jBd0yMisGeIX4F8frcxYjkT6kCS+Vzco9neYq1azwfQLpTMHra6JTxExA+2iibTJ4ir+XfGuCSpdTSW+wsdbA4KBmdpaJjbPGMoJzutxM6HPbxYN/CavBOVP2JhO+Yzn//ih7M3cAxAyT4tqsw1EBUpr/QAQaUl86POK11g4bJijCs0uKduA8M4W7OUX/Tz6vmol1L9FDWyNSjTc+O7Gd785qy9qRoXLEoZNw1HAPgnfntTX+nhsj0RmC4NeF8CQ23fJWXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tojH11VopLd8Ijqh/iCiTXYtH6WyCy+Vztz+Rya3JQ4=;
 b=AELcTMJAjS0Hiafmb5S6xdYIy/3pJJ1gd0+gYyprj30SENOv6+I2s5h2i8vWWh6a258gqanaD8oU3cHSnwxvNfnes80sW0DOvlGCtyVy8joZ7fxK5JJr5VLQLDO8u03FRLBP91V8jhtfH1dUfpJUZbRN79ngl1x4mdpXGSlFNy4=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB7017.eurprd04.prod.outlook.com (2603:10a6:10:123::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.33; Thu, 25 Feb
 2021 02:15:24 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3846.045; Thu, 25 Feb 2021
 02:15:24 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH V1 net-next 0/3] net: stmmac: implement clocks
Thread-Topic: [PATCH V1 net-next 0/3] net: stmmac: implement clocks
Thread-Index: AQHXCdFekWFqiRqYw0qX+7Ua7CCmtKpl8tSAgACRjMCAAAgFgIAAulgAgADdkMA=
Date:   Thu, 25 Feb 2021 02:15:24 +0000
Message-ID: <DB8PR04MB67954D68397236C56A0DB2DBE69E9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210223104818.1933-1-qiangqing.zhang@nxp.com>
 <20210223084503.34ae93f7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DB8PR04MB6795925488C63791C2BD588EE69F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210223175441.2a1b86f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YDZOMpUYZrijdFli@lunn.ch>
In-Reply-To: <YDZOMpUYZrijdFli@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 87aee6dc-ffff-4cbf-0773-08d8d9333633
x-ms-traffictypediagnostic: DB8PR04MB7017:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB70179423B0777A5AC4F55CF2E69E9@DB8PR04MB7017.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YBnDn/jkQ9s4F9LTIt2/oyApZpkBs7F/1ZBDCQmHiGnwGrAOHAWnEmIrCSZMc3lh2brLPswdyKogz2Q8pffHl5HEu6zexydO/obDB9Dqu/RWg47WxooWFaLgELpL1GenntUbLL0p2TbiDuodF61XQhDVBhKq8LLOjUl0etSS4/y0HfR44wMM4KAgTO/BfNtjgVw7jB5qZTVrgk8LtDYdLE6k1wH9svHkxtDe0/aeCn9BChsFXiU477yPRm8f6w1GMnJ0f0mesJr2Y4SiPrsxN6M7KtzA1GSIljhpn5RthjxE82AT8QiJUrzZjDpBq0ag+dBLW1DGSJ3LgncByEsiQm1f39p6bfchCEDEEyDzF5oZnUAz7TeRY1orGZmwV6zZavjOUuCyeFwTkUnyfxHsi3xdkdkuJ5thjoJgu4UXZjw64cy4GT+ESlBTzVPuooEiMiKFitepHvx4xQEGGu4Oj1o/UmJben8L7CWj7hYIr+KU4acoy1tKin1zecBpAY1myqgse86kIQX1/T8BWbEYog==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(366004)(136003)(39860400002)(66556008)(2906002)(76116006)(71200400001)(66476007)(186003)(5660300002)(52536014)(8936002)(26005)(8676002)(66446008)(64756008)(66946007)(53546011)(55016002)(110136005)(7696005)(83380400001)(4326008)(54906003)(86362001)(9686003)(33656002)(478600001)(316002)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?SUpMNjRjelNDWkluYmZUdFVZTWV5MXcyWDhXV0haZjN5Uk5VWXNvcWx1ekZx?=
 =?gb2312?B?RzJ0cEhod3lUczE3bk5wQTA5UlpreFAwMituVnBPNUorMVh4Q0tKK0RpMlI1?=
 =?gb2312?B?Q2Y0NWZBTnNQd29tWFdJUkNsdmt6bWljZXN6NFBjMXZ4a1FZeUszcHZsU1po?=
 =?gb2312?B?MDAwakR5dkdhcFN2OE9maXRPWkh5TU1SV0gzTjZHMUNVUjl6MlloaVdLOWFR?=
 =?gb2312?B?WkhVQlEweWtLelVOQ0lzVnVrVXV1NlFwV1czZSt6TGg2NDlPNzdpQ3BUR25C?=
 =?gb2312?B?YWxycDBZdlhxMzMrZ2VVb0krN0dSc2x4YkFQdFM3NTA2ZzhhK3VBZWFLVml4?=
 =?gb2312?B?bnkzMUpPR0IrOXdFcXo0V3BFTSt0d1I4SzZzWm9wcnNjTjhCd3huNEtaUnQ1?=
 =?gb2312?B?eWN2dTRpd25JMmEvKy9mMFRDcWNFUXFpUjRZVzY4UFRRYzBvTlVKekFyZEt6?=
 =?gb2312?B?eXNOTVFBRkdCeW9qdHZzMDV6dEE5SzlIc3NMVzNRZXloS0ZBYW0rUHNETi9T?=
 =?gb2312?B?L2MzVHZFam90VWJmVTdNeEVFVkVMdnlrYzZYZStwUGkvQ2ViUFl5cnpVMVZZ?=
 =?gb2312?B?cnVwM2xFZ1I2aXE2bmFZeDNMQmlDeGRVc0t5Q2owNUExc2VuZnA2V0w1K2V5?=
 =?gb2312?B?aExqKy9LUGtHVldKSEFuRUIxcm96ZUtjemE5QXVuY3hPL3Q3ZGR3a0tHNUVn?=
 =?gb2312?B?VHlHWDl1SVpiK3VJQkxUWHBrTTlFWG1vY0VMeGpPeUxCSUxEd21WUjE2d01S?=
 =?gb2312?B?SmtFTnAxa204YkRMSlBDTTZ2N3NVZWtVYzN2U0ZDYXA4Z3lva3BuUjNiejEx?=
 =?gb2312?B?REZmbnQrR2FhZlR4cVNleE5RWmIvaldkL1hLWnl6cSsvbWw2MGNvaXdhaHU2?=
 =?gb2312?B?WENqTDZNK0QweVZzY0l1RG1sRm9FV1VsQWRqWkJYUGdPRTBHUDFoTW9HZUpz?=
 =?gb2312?B?ZlRkSGVNVlVaaUNWSHJOTVRjY3FxTEVHQSt3a29VNzN1MjJqTTVSZkpSdk9B?=
 =?gb2312?B?MTcrclhxQzgzMkMyOE5XaS9meHptTDF5bFE5RHdtVk5pd0NyOERQYUJyWWtw?=
 =?gb2312?B?ejZxNkl2MVlHYkYrUzlHWjdXNTJuYXNJRS8rQ3NiYmRDQWNvNEUwaCt0UVFw?=
 =?gb2312?B?b3lwc0l1dDdRb3FydUpLTVd4UW5wWTlENGtFZUhaM3FxSldWSHdYQUVpTjdr?=
 =?gb2312?B?eEx1SFR4RnI2ZlZlZkFud3Y3akZrRVk1WUhyTXNkSWpHVDN5YUFlMUNpYlNv?=
 =?gb2312?B?N3RhaXlCWlA3TVJ1bFhUOEJpcTI5cU1NdU1EekVFUXNFRDV1WEkxVjFZVXZW?=
 =?gb2312?B?YjZJbWdueGs3S0ptMDFLOVY0Tk1vU2V4VGZaSjZDSFRjU1N2cytJNDU1T05o?=
 =?gb2312?B?M2dtei9zZ2UwdmdaYVdJMHQrZTNnQkZUMWlUOVdiY3g3Q04rUDJkaUdPRUNp?=
 =?gb2312?B?a2JwZmpDM1k0TFBKVWU2RHdPSm45NVRlTUNPMTVnZnVXWmFVUDJYWFhub2d1?=
 =?gb2312?B?U0lJOXlDNnl2eVl4c3gxc2hobWhGU0JVUFBOMGRzV2paU2piTitWVWwwa2RP?=
 =?gb2312?B?SGs1ZnV5WUp4NEN4SGpLbWNGRGFTcTBQdnIyck10ankyNTU3QitDL1RWY0Zk?=
 =?gb2312?B?bGZmbkxFYXM0VE9EbjlPbnhlWDAyTlRLVDltdEdzbUhrWmtHa0phK0pxQXpk?=
 =?gb2312?B?Vk9xdlk3NXdrRXpmZkE5Sm1TUXdUSVhIUnhOYTZBdk9FOWx0NldEZ1g3OWJ1?=
 =?gb2312?Q?/7IdIw9jgWkqN5vg86zeclLJAsJeDGG011eAm0c?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87aee6dc-ffff-4cbf-0773-08d8d9333633
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2021 02:15:24.7822
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vdd+lUr0y17OkXNaC+DHX7HFNV60szNeGiO7O/rWedpsULKLALMu04URaprR1gh2S0e/2UCHDIducCfBv2bSIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7017
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEFuZHJldyBMdW5uIDxhbmRy
ZXdAbHVubi5jaD4NCj4gU2VudDogMjAyMcTqMtTCMjTI1SAyMTowMg0KPiBUbzogSmFrdWIgS2lj
aW5za2kgPGt1YmFAa2VybmVsLm9yZz4NCj4gQ2M6IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpo
YW5nQG54cC5jb20+OyBwZXBwZS5jYXZhbGxhcm9Ac3QuY29tOw0KPiBhbGV4YW5kcmUudG9yZ3Vl
QHN0LmNvbTsgam9hYnJldUBzeW5vcHN5cy5jb207IGRhdmVtQGRhdmVtbG9mdC5uZXQ7DQo+IG5l
dGRldkB2Z2VyLmtlcm5lbC5vcmc7IGRsLWxpbnV4LWlteCA8bGludXgtaW14QG54cC5jb20+DQo+
IFN1YmplY3Q6IFJlOiBbUEFUQ0ggVjEgbmV0LW5leHQgMC8zXSBuZXQ6IHN0bW1hYzogaW1wbGVt
ZW50IGNsb2Nrcw0KPiANCj4gPiBVbmRlcnN0b29kLiBQbGVhc2UgZG91YmxlIGNoZWNrIGV0aHRv
b2wgY2FsbGJhY2tzIHdvcmsgZmluZS4gUGVvcGxlDQo+ID4gb2Z0ZW4gZm9yZ2V0IGFib3V0IHRo
b3NlIHdoZW4gZGlzYWJsaW5nIGNsb2NrcyBpbiAuY2xvc2UuDQo+IA0KPiBUaGUgTURJTyBidXMg
Y2FuIGFsc28gYmUgdXNlZCBhdCBhbnkgdGltZSwgbm90IGp1c3Qgd2hlbiB0aGUgaW50ZXJmYWNl
IGlzIG9wZW4uDQo+IEZvciBleGFtcGxlIHRoZSBNQUMgY291bGQgYmUgY29ubmVjdGVkIHRvIGFu
IEV0aGVybmV0IHN3aXRjaCwgd2hpY2ggaXMNCj4gbWFuYWdlZCBieSB0aGUgTURJTyBidXMuIE9y
IHNvbWUgUEhZcyBoYXZlIGEgdGVtcGVyYXR1cmUgc2Vuc29yIHdoaWNoIGlzDQo+IHJlZ2lzdGVy
ZWQgd2l0aCBIV01PTiB3aGVuIHRoZSBQSFkgaXMgcHJvYmVkLg0KDQpIaSBBbmRyZXcsDQoNCkkg
ZG9uJ3QgaGF2ZSBleHBlcmllbmNlIHdpdGggRXRoZXJuZXQgc3dpdGNoLCBhY2NvcmRpbmcgdG8g
eW91ciBwb2ludHMsIHlvdSBtZWFuIHdlIGNhbiBjb25uZWN0IFNUTU1BQyB0byBhbiBFdGhlcm5l
dCBzd2l0Y2gsIGFuZCB0aGVuIEV0aGVybmV0IHN3aXRjaCBtYW5hZ2VkIFNUTU1BQyBieSB0aGUg
TURJTyBidXMgYnV0IHdpdGhvdXQgY2hlY2tpbmcgd2hldGhlciBTVE1NQUMgaW50ZXJmYWNlIGlz
IG9wZW5lZCBvciBub3QsIHNvIFNUTU1BQyBuZWVkcyBjbG9ja3MgZm9yIE1ESU8gZXZlbiBpbnRl
cmZhY2UgaXMgY2xvc2VkLCByaWdodD8NCg0KPiBZb3Ugc2FpZCB5b3UgY29waWVkIHRoZSBGRUMg
ZHJpdmVyLiBUYWtlIGEgbG9vayBhdCB0aGF0LCBpdCB3YXMgaW5pdGlhbGx5IGJyb2tlbiBpbg0K
PiB0aGlzIHdheSwgYW5kIGkgbmVlZGVkIHRvIGV4dGVuZCBpdCB3aGVuIGkgZ290IGEgYm9hcmQg
d2l0aCBhbiBFdGhlcm5ldCBzd2l0Y2gNCj4gYXR0YWNoZWQgdG8gdGhlIEZFQy4NCg0KQ291bGQg
eW91IHBvaW50IG1lIGhvdyB0byBpbXBsZW1lbnQgY2xvY2tzIG1hbmFnZW1lbnQgdG8gY292ZXIg
YWJvdmUgRXRoZXJuZXQgc3dpdGNoIGNhc2U/IE9yIGNhbiB3ZSB1cHN0cmVhbSB0aGlzIGZpcnN0
IGFuZCB0aGVuIGZpeCBpdCBsYXRlciBmb3Igc3VjaCBjYXNlPw0KDQpCZXN0IFJlZ2FyZHMsDQpK
b2FraW0gWmhhbmcNCj4gDQo+ICAgICAgIEFuZHJldw0K
