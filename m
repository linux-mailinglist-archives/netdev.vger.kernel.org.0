Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A56636BD78
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 04:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbhD0Cp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 22:45:29 -0400
Received: from mail-db8eur05on2045.outbound.protection.outlook.com ([40.107.20.45]:2017
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231363AbhD0Cp2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 22:45:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O2NeDZfol+plJUm7nTPx52uXwc3Q2YCHZk6o8fdg3vZDrQfMn1F0+TpxbDFqF+Qfy1T8/F94i/lQvLUvS6jq0Z9VGPL/D6yKL2ZJSSC7MPtvvHAmDEaT+9aHfkJzxXl9X4BZDA5kQjlVc0ZB+VdAH5pe8XmRNxU2tXrCEKYbPeRd/vL5laT4UPU9v9iipa3/sR4/YpwhitdK3SNqWPTFY9FUzTIIrGVZaHSRuxSEpv5GO6RE2XImoaMwDykBe9ra68984e/cwJUipKj/De0k/ON3hibYiF3UVVJbwxC7RA/fgihJ1n/to0rzADluLoramfvmNNjFFgx4LO9U3azrjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UpqKkCBCCkeae1o3gBohuD2XTvqPLTYxansD3A+p/F0=;
 b=U7CEdyNesBeFyjAi99K3j5ZMJDJVPWykFaBqQ5S6vda2FNdtqq3VYhcRj6aSUamHs1uHCAtMOJdzy6dv29jRph5DBdkTqt8SvTHeFdafdRTfY4G1parq6XF+3bG9cCox0xZPaVoPCix9lGn5uzjPzujkhNzPaU+/2aJH5Yv/okIJ/KnNtiVCnZHcAFKH6zKNulCPSH+0L/5BwJXyJ5xkEC7ZJkzVZuz/eQ/bbvPFK/ySBpnSNK7sMBtpcK99nTV3s0nZDY9y/DVwcCooKsC6yqWZEFTZ/Bo0QaVYf93vLU6qtT62SDDBLPYzwphTELz8l/F2cHcfud+Obv8v4/Ee/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UpqKkCBCCkeae1o3gBohuD2XTvqPLTYxansD3A+p/F0=;
 b=caRa8J4dXiMuOVHNePER0zZqFA7mNG7JK3PXgPUP8GcNOI9NidSrh/to5aDzuoeOcly2fQZXPmc47zTeIwxkeXv4ygFvC3NMqiOoMh9Zo4kgTVJdjzE5Z8Io8MWZF2UA1vb7ARs7M4WSaHcXYJNwUa8dAtxGdjpcSsS+TNAxeS0=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB5129.eurprd04.prod.outlook.com (2603:10a6:10:1f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.25; Tue, 27 Apr
 2021 02:44:43 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%7]) with mapi id 15.20.4065.027; Tue, 27 Apr 2021
 02:44:43 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        "Jisheng.Zhang@synaptics.com" <Jisheng.Zhang@synaptics.com>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH V2 net] net: stmmac: fix MAC WoL unwork if PHY doesn't
 support WoL
Thread-Topic: [PATCH V2 net] net: stmmac: fix MAC WoL unwork if PHY doesn't
 support WoL
Thread-Index: AQHXOnsdgzR/5IOU8kKc3lqbLXj1qarGxJwAgADhE7A=
Date:   Tue, 27 Apr 2021 02:44:43 +0000
Message-ID: <DB8PR04MB6795A418BE733407FB4B7AF6E6419@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210426090447.14323-1-qiangqing.zhang@nxp.com>
 <YIa6hnmYhOAOyZLY@lunn.ch>
In-Reply-To: <YIa6hnmYhOAOyZLY@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-Mentions: Jisheng.Zhang@synaptics.com
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f113a6b6-ba4e-44d4-ca49-08d90926699e
x-ms-traffictypediagnostic: DB7PR04MB5129:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB5129230A0BDD3F8A25EA6A3BE6419@DB7PR04MB5129.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ToaEZwWgJjYykVNjdqGC/IlZHQU4mtiM7er25wpQaQTRv1WPmIR+IhWuhdXkgvjDdfomAnvAwOMvMYBzu+n3Evwse1xv0yKWr/YEB441iiAvYqN8nF4rPeQfyuYpa4bgO6HjL4CVC5j/UcvjXQ0u2dq7bzMGIuwsfbrh/ofdZ9gausJp76jMDTvFT8saujFm8H+auvf+hEYlDUAwtgwnCSJ1VLrX8o/QSJ+wftpxc26ZWuTZOyhn50xy+fnRCQuNknV1snsBAzSAZIy1+AK+wQzZYrui3OE8ZyqIfjrMtweLj6fClAHtw4XPs9aay+ooaH2cuKeSV7cu/aWrCW/jm51cdje8+NAkI12eV4OvMb5oP/XTIW31cUSiR2sQOWgxPfV6MzD3kqd6euL110CR8vx3M5BDHY88Z1bzudJqS9GLVrZK74tP7SfJ/XA8v9VuYghYGwIgfwR4ypoCXne/FeLBtdhZ5sxgu5/XRjM174qBRAtvnvlEspjOBF5V229j5iBLCZzy3Go1ocjMG17r3srKYt7i2l3D3zwfInZ/BRrAUG77/xVExZ0gY6fWqDEsaidBAK2sXq5b2wfxQKLphu6rB3GSolhSE9ndUb8qoMjT43+VI2GOBFuTFEqQ83+9I9O7aDj+Nci2xgN34O+iB5QRktUl1xeDjFFUnc5jZ70=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9686003)(55016002)(83380400001)(186003)(53546011)(2906002)(7696005)(122000001)(6506007)(8936002)(38100700002)(52536014)(26005)(110136005)(5660300002)(54906003)(71200400001)(66476007)(8676002)(66556008)(33656002)(66946007)(66446008)(64756008)(498600001)(86362001)(4326008)(76116006)(309714004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?Y0RnNk1wU3A1UHc4VkFLb1piTXVkYjUxZEdMdFQ4TDNsbXNOZDdIQ0RvRzBK?=
 =?gb2312?B?TmZTcERMQlY3M0JNK3pSNHdLVDhKeTAzaVBQQzZOWGRNa2dUYlpHTmhMdWxj?=
 =?gb2312?B?VnRWOHdOaG9BRWt4a1ovM0VnYzVYY3REbFkxNEtDclF2MTh1clpCbUtuUXVL?=
 =?gb2312?B?aE9KMHlVbkNSVVRXVnpnMFBrbzl3ZFJ2MjVZOWREbEo5elV5ZERsMk9IZ1BT?=
 =?gb2312?B?b0xOMGNoRGpHOVoyS1hpdUpHaFhWUFFLQVVCNlkvb3hNb2wrVGNqYWJRc0hw?=
 =?gb2312?B?SFZwOFRpRzRnNW41S21ZNlE2RTc1ZWZaTWRtdWdNcUp5b2l5VnkzQ2ZVaW1C?=
 =?gb2312?B?aXdFcUZ6WDM0VThLRkx2VlBHQUljY3FBaG1KMHJBMUZ2NXlGL2E5UDNBMFA5?=
 =?gb2312?B?NjlIaVpvSkFoZGh6S3AvaTl6c2JlbDM3TnBTV1lzbGhZMTJUS1I2MTFXRTEw?=
 =?gb2312?B?Vk9BYmw0a08zRDc3bis4aGxRQ3gxWjY2RHRCVVVWaU0yYlVtN2pia29jcWc4?=
 =?gb2312?B?NXhDMVhWYjdwZG52MVBBdlJxUU1PeXg4b3BpRWlvYmpMY3krdEtkWjUyYmJa?=
 =?gb2312?B?elpkQXhZLzJoR0NiNnNVWng3UkI3eERRc0Zicmw4OEZZbkNEKzV2OENiTnMy?=
 =?gb2312?B?L3VHL3BMbVlLejg1aW5BUXFvdlIvR0FVZXJQT25KWkJIa2RTOFdpT1lVMWVI?=
 =?gb2312?B?VlBUUGF5MEEwZDNSaEw1K25iUDcrY2U1MWt3ek1oZmRqQitNTWhSSTdxSllz?=
 =?gb2312?B?aUZTa3h3WThWaEUzYmZwcnUzRUIwQVhzNkM5Zk5FRjQ0UUNXbEhucWJOMW10?=
 =?gb2312?B?ZURlcU9RZmRFaUM1R1doaGk3TWRMdXY5MldqOUFnaTFPU2E4NldUaGNOaHhl?=
 =?gb2312?B?am41S3dFODRQWWppNitsS3FEV3dwT1E3RW5TNHQ1a08rR2thdTJzanhrVnpw?=
 =?gb2312?B?d09SZ3JZY1lSYU5iNTMwdWkwR09kMnc5c2w2Nm5tdndxZDBkRVkvWnhxMHNy?=
 =?gb2312?B?OHp0cWFEMlRxdWFiNXRJcldSZzBrYS9iNFBTNUdtbjcxUDlKdW9kSnlDdWE5?=
 =?gb2312?B?dzdNWWdFRURCSmxmQS9YN01TS0VWYjBjT1VHcGxmcWZvVE1iSE82aUhQdUNK?=
 =?gb2312?B?S3h5czRNcGpxZnBRR0hsQnR6bHpvTGpOdTUzRENPcVpYNk43bjVvSGZPblFC?=
 =?gb2312?B?MENMdFJqZWRBalZiV3Q5NzFwV3U2c1ZTZnRmcElKVEs2Z0FUMlV3UFBqdHV0?=
 =?gb2312?B?VEF1Y3BqWXd4MmlKS21qTFBXeEhUOUxjREZPOGVaVHh1dDJBNkU3b3c3c3ds?=
 =?gb2312?B?RlhHM3NUdjFOM01lTGhJSFNyQUJweXVuM292TmV1RWE3S2Y1cnJPV2ZkbnUr?=
 =?gb2312?B?UE9PQitvTDBPQitpcWNHL1d6cnI4eWJOaysvbGNpWGNPdkk3SDlIZlViamx2?=
 =?gb2312?B?d0FpQUxIRUFSRTRHeDJiSzl3T0FsZDhBTVB0TDVkSFhCWUE0MGU1ZGJiT0Zq?=
 =?gb2312?B?YjhxSEg2d1BwbEE4WE9SVUxlYm84aHNHQVQ4RVBWZk9CcHpncmhoMGFsTllI?=
 =?gb2312?B?RVMyUVRLR0E5S3FqSG1JdXFzOTJJbW9OVkdFMUJlTVdtZW43bndJOXM2U0th?=
 =?gb2312?B?R2xUdHJUd242L0h4WFByNjNaWmIraTYwUS81SzQ4L3Z4dm0xTWJsTVVtRzNV?=
 =?gb2312?B?Q244YVNXRGtGTUtuQVJhSjRxOVkvd3ZLRVV2K0JKZmljbExyUHIwOUdBVXQr?=
 =?gb2312?Q?553Mnc9kRGV0bFZC1v0IAWKhSktNtz+3GWzDUof?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f113a6b6-ba4e-44d4-ca49-08d90926699e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2021 02:44:43.4031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yMNpENBps/k/f2PWlgxIucoyt/Oz4fLrMdY1L0GC9/apr8DeE5aw2lBZtdzFQghVPlzeHnb+pZwHloHdZQVykg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5129
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEFuZHJldyBMdW5uIDxhbmRy
ZXdAbHVubi5jaD4NCj4gU2VudDogMjAyMcTqNNTCMjbI1SAyMTowNQ0KPiBUbzogSm9ha2ltIFpo
YW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gQ2M6IHBlcHBlLmNhdmFsbGFyb0BzdC5j
b207IGFsZXhhbmRyZS50b3JndWVAc3QuY29tOw0KPiBqb2FicmV1QHN5bm9wc3lzLmNvbTsgZGF2
ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOw0KPiBmLmZhaW5lbGxpQGdtYWlsLmNv
bTsgSmlzaGVuZy5aaGFuZ0BzeW5hcHRpY3MuY29tOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOw0K
PiBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENI
IFYyIG5ldF0gbmV0OiBzdG1tYWM6IGZpeCBNQUMgV29MIHVud29yayBpZiBQSFkgZG9lc24ndA0K
PiBzdXBwb3J0IFdvTA0KPiANCj4gPiArCWlmICh3b2wtPndvbG9wdHMgJiBXQUtFX1BIWSkgew0K
PiA+ICsJCWludCByZXQgPSBwaHlsaW5rX2V0aHRvb2xfc2V0X3dvbChwcml2LT5waHlsaW5rLCB3
b2wpOw0KPiANCj4gVGhpcyBpcyB3cm9uZy4gTm8gUEhZIGFjdHVhbGx5IGltcGxlbWVudHMgV0FL
RV9QSFkuDQo+IA0KPiBXaGF0IFBIWXMgZG8gaW1wbGVtZW50IGlzIFdBS0VfTUFHSUMsIFdBS0Vf
TUFHSUNTRUMsIFdBS0VfVUNBU1QsDQo+IGFuZCBXQUtFX0JDQVNULiBTbyB0aGVyZSBpcyBhIGNs
ZWFyIG92ZXJsYXAgd2l0aCB3aGF0IHRoZSBNQUMgY2FuIGRvLg0KPiANCj4gU28geW91IG5lZWQg
dG8gZGVjaWRlIHdoaWNoIGlzIGdvaW5nIHRvIHByb3ZpZGUgZWFjaCBvZiB0aGVzZSB3YWtldXBz
LCB0aGUNCj4gTUFDIG9yIHRoZSBQSFksIGFuZCBtYWtlIHN1cmUgb25seSBvbmUgZG9lcyB0aGUg
YWN0dWFsIGltcGxlbWVudGF0aW9uLg0KDQpIaSBBbmRyZXcsDQoNClRoYW5rcyBmb3IgeW91ciBy
ZXZpZXc6LSksIFBIWSB3YWtldXAgaGF2ZSBub3QgdGVzdCBhdCBteSBzaWRlLCBuZWVkIEBKaXNo
ZW5nLlpoYW5nQHN5bmFwdGljcy5jb20gaGF2ZSBhIHRlc3QgaWYgcG9zc2libGUuDQoNCkFjY29y
ZGluZyB0byB5b3VyIGNvbW1lbnRzLCBJIGRpZCBhIHF1aWNrIGRyYWZ0LCBhbmQgaGF2ZSBub3Qg
dGVzdCB5ZXQsIGNvdWxkIHlvdSBwbGVhc2UgcmV2aWV3IHRoZSBsb2dpYyB0byBzZWUgaWYgSSB1
bmRlcnN0YW5kIHlvdSBjb3JyZWN0bHk/IFRoYW5rcy4NCg0KLS0tIGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjX2V0aHRvb2wuYw0KKysrIGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjX2V0aHRvb2wuYw0KQEAgLTY0NywxOCArNjQ3
LDcgQEAgc3RhdGljIHZvaWQgc3RtbWFjX2dldF93b2woc3RydWN0IG5ldF9kZXZpY2UgKmRldiwg
c3RydWN0IGV0aHRvb2xfd29saW5mbyAqd29sKQ0KIHN0YXRpYyBpbnQgc3RtbWFjX3NldF93b2wo
c3RydWN0IG5ldF9kZXZpY2UgKmRldiwgc3RydWN0IGV0aHRvb2xfd29saW5mbyAqd29sKQ0KIHsN
CiAgICAgICAgc3RydWN0IHN0bW1hY19wcml2ICpwcml2ID0gbmV0ZGV2X3ByaXYoZGV2KTsNCi0g
ICAgICAgdTMyIHN1cHBvcnQgPSBXQUtFX01BR0lDIHwgV0FLRV9VQ0FTVDsNCi0NCi0gICAgICAg
aWYgKCFkZXZpY2VfY2FuX3dha2V1cChwcml2LT5kZXZpY2UpKQ0KLSAgICAgICAgICAgICAgIHJl
dHVybiAtRU9QTk9UU1VQUDsNCi0NCi0gICAgICAgaWYgKCFwcml2LT5wbGF0LT5wbXQpIHsNCi0g
ICAgICAgICAgICAgICBpbnQgcmV0ID0gcGh5bGlua19ldGh0b29sX3NldF93b2wocHJpdi0+cGh5
bGluaywgd29sKTsNCi0NCi0gICAgICAgICAgICAgICBpZiAoIXJldCkNCi0gICAgICAgICAgICAg
ICAgICAgICAgIGRldmljZV9zZXRfd2FrZXVwX2VuYWJsZShwcml2LT5kZXZpY2UsICEhd29sLT53
b2xvcHRzKTsNCi0gICAgICAgICAgICAgICByZXR1cm4gcmV0Ow0KLSAgICAgICB9DQorICAgICAg
IHUzMiBzdXBwb3J0ID0gV0FLRV9NQUdJQyB8IFdBS0VfVUNBU1QgfCBXQUtFX01BR0lDU0VDVVJF
IHwgIFdBS0VfQkNBU1Q7DQoNCiAgICAgICAgLyogQnkgZGVmYXVsdCBhbG1vc3QgYWxsIEdNQUMg
ZGV2aWNlcyBzdXBwb3J0IHRoZSBXb0wgdmlhDQogICAgICAgICAqIG1hZ2ljIGZyYW1lIGJ1dCB3
ZSBjYW4gZGlzYWJsZSBpdCBpZiB0aGUgSFcgY2FwYWJpbGl0eQ0KQEAgLTY2OSwxMyArNjU4LDI0
IEBAIHN0YXRpYyBpbnQgc3RtbWFjX3NldF93b2woc3RydWN0IG5ldF9kZXZpY2UgKmRldiwgc3Ry
dWN0IGV0aHRvb2xfd29saW5mbyAqd29sKQ0KICAgICAgICBpZiAod29sLT53b2xvcHRzICYgfnN1
cHBvcnQpDQogICAgICAgICAgICAgICAgcmV0dXJuIC1FSU5WQUw7DQoNCi0gICAgICAgaWYgKHdv
bC0+d29sb3B0cykgew0KLSAgICAgICAgICAgICAgIHByX2luZm8oInN0bW1hYzogd2FrZXVwIGVu
YWJsZVxuIik7DQotICAgICAgICAgICAgICAgZGV2aWNlX3NldF93YWtldXBfZW5hYmxlKHByaXYt
PmRldmljZSwgMSk7DQotICAgICAgICAgICAgICAgZW5hYmxlX2lycV93YWtlKHByaXYtPndvbF9p
cnEpOw0KLSAgICAgICB9IGVsc2Ugew0KKyAgICAgICBpZiAoIXdvbC0+d29sb3B0cykgew0KKyAg
ICAgICAgICAgICAgIGRldmljZV9zZXRfd2FrZXVwX2NhcGFibGUocHJpdi0+ZGV2aWNlLCAwKTsN
CiAgICAgICAgICAgICAgICBkZXZpY2Vfc2V0X3dha2V1cF9lbmFibGUocHJpdi0+ZGV2aWNlLCAw
KTsNCiAgICAgICAgICAgICAgICBkaXNhYmxlX2lycV93YWtlKHByaXYtPndvbF9pcnEpOw0KKyAg
ICAgICB9IGVsc2Ugew0KKyAgICAgICAgICAgICAgIGlmIChwcml2LT5wbGF0LT5wbXQgJiYgKCh3
b2wtPndvbG9wdHMgJiBXQUtFX01BR0lDKSB8fCAod29sLT53b2xvcHRzICYgV0FLRV9VQ0FTVCkp
KSB7DQorICAgICAgICAgICAgICAgICAgICAgICBwcl9pbmZvKCJzdG1tYWM6IG1hYyB3YWtldXAg
ZW5hYmxlXG4iKTsNCisgICAgICAgICAgICAgICAgICAgICAgIGVuYWJsZV9pcnFfd2FrZShwcml2
LT53b2xfaXJxKTsNCisgICAgICAgICAgICAgICB9IGVsc2Ugew0KKyAgICAgICAgICAgICAgICAg
ICAgICAgaW50IHJldCA9IHBoeWxpbmtfZXRodG9vbF9zZXRfd29sKHByaXYtPnBoeWxpbmssIHdv
bCk7DQorDQorICAgICAgICAgICAgICAgICAgICAgICBpZiAoIXJldCkNCisgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgcHJfaW5mbygic3RtbWFjOiBwaHkgd2FrZXVwIGVuYWJsZVxuIik7
DQorICAgICAgICAgICAgICAgICAgICAgICBlbHNlDQorICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHJldHVybiByZXQ7DQorICAgICAgICAgICAgICAgfQ0KKyAgICAgICAgICAgICAgIGRl
dmljZV9zZXRfd2FrZXVwX2NhcGFibGUocHJpdi0+ZGV2aWNlLCAxKTsNCisgICAgICAgICAgICAg
ICBkZXZpY2Vfc2V0X3dha2V1cF9lbmFibGUocHJpdi0+ZGV2aWNlLCAxKTsNCiAgICAgICAgfQ0K
DQogICAgICAgIG11dGV4X2xvY2soJnByaXYtPmxvY2spOw0KDQoNCkJlc3QgUmVnYXJkcywNCkpv
YWtpbSBaaGFuZw0KPiAJQW5kcmV3DQo=
