Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5411F310228
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 02:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbhBEBTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 20:19:40 -0500
Received: from mail-eopbgr140052.outbound.protection.outlook.com ([40.107.14.52]:21408
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232391AbhBEBTh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 20:19:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hptql+vgxZTgsuj/8IXhd4jWn0w6vqwil3UkxawkDO9eXg3MTnBVs5gc2gIyJljsZfdKdWNc4ZuMFKEwQVTjin6JvL0UNl3fjmsZrfO/op38G4hxt+3WrXHqKe+/aj/d5Wyl93GBXQUoZBIbGk7xZD4+yN4BJHO2K38CRiW4gW458bmbAdGsjLW+zyKW25NtltqugkrJon6AY4RZJ2yKY4xQRSq1BxQqessKsrHfOKBF1LWGBH+9oV+6sON7DydlrEwFQyZGgkoH5Ur4YT7Kg9PJbH3pSBj66nl7Z/JpTFeREX+p8ojdpeNRx6gd/ScseB0quIC2bEyAnrvvS6t2DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hRgomb1itYd8aEY/l4tNbf0V+IkDCrbR215cPCuhlo4=;
 b=ScR4ycqz2o5tjw+903zk+bV57k9RTCW8UJ61wJplVqCL5Kif3R5PzzhheWLN0c64Mh2PdJK7/e3aCztOV41Y38Feig5OH279AuKrbiVzu0FkkSBw8KxQBhFmV3bRKCns07jyCt3j6jbxdo8IXN2sewYKFIFIB5wRXTMiYT8MoU8M4juAJY1/2bIi02daLW96jFt8rEQg/5c7t0LJONTS606qSAXdhpAov6FwBNdmtlxybDpmSiQSPADTGbIyokrPvXaAg9KTHdONkm8R9UUXAO3hMCxA8rHAoWpgsuwCeviF6Kw+lhs2DiStC6CbF1Tk0U/PMyc8UXEMGOlVSdVFFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hRgomb1itYd8aEY/l4tNbf0V+IkDCrbR215cPCuhlo4=;
 b=CMR4th2Dys+Dq0ZJozrQ+EzmAYZLMlkMjJ3lwLAo4PV1JKAzgombfyFFXDxgoZJNiyB4erGRe8qD1nihBu/hbyPf8l+MqChmc//+S87oOBfnW3q24T5WDlem9yzugmYsMU10JsEE+IeHywbosbhQQIno00T2smjJWeFo6ukzG2E=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0402MB2902.eurprd04.prod.outlook.com (2603:10a6:4:9a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Fri, 5 Feb
 2021 01:18:49 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3825.023; Fri, 5 Feb 2021
 01:18:49 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: RE: [PATCH net-next 2/2] net: stmmac: slightly adjust the order of
 the codes in stmmac_resume()
Thread-Topic: [PATCH net-next 2/2] net: stmmac: slightly adjust the order of
 the codes in stmmac_resume()
Thread-Index: AQHW+t6r2YtHulXEfkOxiP1zVHZpz6pH+y6AgADH20A=
Date:   Fri, 5 Feb 2021 01:18:48 +0000
Message-ID: <DB8PR04MB6795B6E99BCD31A36483E696E6B29@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210204101550.21595-1-qiangqing.zhang@nxp.com>
 <20210204101550.21595-3-qiangqing.zhang@nxp.com>
 <CA+FuTSdxk3V5oqPTOfsBpB18KiO4MGGm2FrU4RCdD-T6ssCL5g@mail.gmail.com>
In-Reply-To: <CA+FuTSdxk3V5oqPTOfsBpB18KiO4MGGm2FrU4RCdD-T6ssCL5g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fefa4e3b-48a1-432f-62d2-08d8c973fdf2
x-ms-traffictypediagnostic: DB6PR0402MB2902:
x-microsoft-antispam-prvs: <DB6PR0402MB29027A6708C51E6473B0CB1AE6B29@DB6PR0402MB2902.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:605;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n1IxpBQ0FsMmzH+iB4EhlIje2kCYXjMc9zjaIq4o+7G657OcyFuZPpOMd4/1X/wIWZoCHLMF7F59HjuVG009+fFfCQvZo+xKU4WhZAIsAdURBztlpwA1m6HCulcPxz9Hmn6hxqboNJDQ44+DJqQhESYIV3qXqeOpYsNQBdE6zWnjZtLBiTMbOQ/eM+RUf8SyWZdfGiq7OR45yVKYh9gg0HqmqI3lu3KlVnorsCgwgKf4FXRdK4DXkmHaawAQD4VPuRaO211QM52obnICs3oX+reDRGRHZYqp/mqv3kWHMtSq6cSb7kjQgsdjepAQUO1rl68PJ3n1zG67Hry/V1k0/SyFTd+LxWGk26eojI1u7ajuAFoN/Mr+eqx7eFjj21Wd1r4sRX68CfH/jKIGAFNsDTltuZ/tSbekpB+E+vcOl2Z2IeiAOCcOPZhhxudBd9JRkmH5RMBUkj5EFkdJCr1PYGsfCzuigKaQ59Z9dMB/Iuz+NDKYh5I1dQC8YvII7rkCPtAe4K6VjeVOEhTuVEfw7A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(2906002)(33656002)(53546011)(55016002)(76116006)(8676002)(5660300002)(26005)(54906003)(478600001)(186003)(86362001)(83380400001)(4744005)(66446008)(6916009)(9686003)(7696005)(64756008)(8936002)(6506007)(71200400001)(52536014)(4326008)(66946007)(316002)(66556008)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Y2NvTStadjlkRkFGc2hucFJSR2I4UlJHbTM1MTkyc0p6NjE1MmNmL2Fvem1I?=
 =?utf-8?B?YXRJb3U2UHNWdVhnYVNsOU9IZDE2TE5Jb0lsM01WNjR2R3NTTGNieHdRSi96?=
 =?utf-8?B?Q1NYVUZmZ2N4YTZMWWJoNnd5aUY3b0t3eFJQWTRaTmVHSFJOWE52ek5DMVNZ?=
 =?utf-8?B?Y2RJVWRsVTFwcmpEVURwYXV4Mlh1anBLdEZBNE5ndGdMV2JINTNFTTRoaS9E?=
 =?utf-8?B?eTF1bXQwbGZ6eHM2S0lFMUl6ODdxbUNiaU1SaEpEbmdBTnpaOVZ0NDBqeCsy?=
 =?utf-8?B?Y3B1dnhKeGFHbEtRMUdBcWd5ZE5kREhFYW9QaEdzUEYzbkpCelI4bVR6cDhK?=
 =?utf-8?B?K05Ock0vSHlOTU1wWlVhZ2drTzRjWHVEM3R0Wk5URWNrV2RLRVJCM20zR09L?=
 =?utf-8?B?NDNwR3hNK1VjdUtTS1ZQNXQrTmdRbUJkSGY0TVErRlY2R1k3bkw5bGQzQkc4?=
 =?utf-8?B?UzErQyswT1B6RFgxYllJTlRsN0xoa3hINkZ3L0dJa1poVmlCZ21Ea2RsMm83?=
 =?utf-8?B?enVpT0ozUnR3Y0xBZ2VqQVg4bFdaeVIwbGxGSlVaRjRhbjhKNk5oR1NNbVRl?=
 =?utf-8?B?Z0FPNmVZdUtYNTU3a0xMTXFhK0VqWldSUmdxTU9WTWtMQjRNS1ZBUU5HM2ZV?=
 =?utf-8?B?UjhZYzlaUk5NdlFRcTBDb2QwVTY5TlI4TVFRYkJ4R1dEbC9MVm9Iak41L05n?=
 =?utf-8?B?dnkrRk82VVdqMmNwN0dRYlhkeWplZUFIZXNRakI4MVZUQndtMEFQSkx0TkNW?=
 =?utf-8?B?VGZmY1VOS0FESXZ2QytkSEV6V3M5VW94VnFVczFKTGszYnptUTBGeU9DeDNh?=
 =?utf-8?B?aDBsM2JoMyszaEdwNUhjYlZMME4yRXpBaFNSSnJvekFFLzNQV3BOdE50cXNT?=
 =?utf-8?B?cnNzWlBaNEd3dG1KRytjaTh0em1IVTBaelJ3bjBYWkQvSThLNk5BWXduaDAv?=
 =?utf-8?B?bUxJR0JwdVoySVU2UlhGZjI5a2ppQm9iZGViSU8rOFp1Tm5zTUJiRWZ1UGYx?=
 =?utf-8?B?NUd1MkthNVJVVUxhTzU4UzRUd1ExZTJqQmdoZm8rQlAwTTdoY2pmc1FJMDZ5?=
 =?utf-8?B?VCsvWnZXcElEZXpTazg0d0xJbXpibXdYaUs4elhibjVSZWQ2ZTNRR3BCOUtw?=
 =?utf-8?B?bm5VUlROaXhMYUt2akducDNUL21SNUI3VHVVVWwvUEdXcFp4M2YwQ0tWZHZz?=
 =?utf-8?B?Tk10TTEyVW5oZ1dJaFh2QmNKUCsyUk83TDdxTm1UeHp1eGNUVElWY2E1ek1y?=
 =?utf-8?B?Q241TEhqQXo5MUp3emNKZGN2czFadFBaV3Y3U2hvNFNWRHJQVlZYVy8zY3pS?=
 =?utf-8?B?TFpFT3RrU1paQ2NzVkF5OWV1Q00zT1VnZDNoNE9HVU9Jc2UwVVpaclh6dUxW?=
 =?utf-8?B?cVprWmR4dzU4Y2NBa1k4cTJ0VVFuUFNpV1pLd0xYU0VCRlhsVFhHYy9QdDZG?=
 =?utf-8?B?RHJ6bGNiVUR5YVNFZDBYaUNMRGZ6WUpEQm9OMUc1ZHFuQWVNOUZBa1dROTZD?=
 =?utf-8?B?KzNwVjhXK2ZId0NDUjV0R3hqVkhTOHcxZXlWVnBSMkhSb1BOWEVoQnVWU2RK?=
 =?utf-8?B?K0IycTRGbWVhWUkzZlc3Y0ZIczJ5cUpYNkZoenJERjZ5KzYxL0g1UkQ4N3VQ?=
 =?utf-8?B?Rkk3OU9paXpqejl3L2dsT245Q2I1UGoyMVprTHIwU3lIVS9IbGcxYXFMNmRG?=
 =?utf-8?B?N3lWaTViQlBPZGNLMWVYYkdncXJKTnRRQ1lLeStqRnkzb0trUEo4QVAwRGlJ?=
 =?utf-8?Q?fu6w/wLcLYBk9Qd6jh5MYpnrfd/Kaod+bFaUZpo?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fefa4e3b-48a1-432f-62d2-08d8c973fdf2
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2021 01:18:49.0872
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BckDCVMXTetQDQyyHgiQZLNFAhiTj/sCnH/EaiRUYk/vxpBs3/6/Ru/UPICnqOy+9V2Dx9zUpgZWFxEhKk861Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2902
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFdpbGxlbSBkZSBCcnVpam4g
PHdpbGxlbWRlYnJ1aWpuLmtlcm5lbEBnbWFpbC5jb20+DQo+IFNlbnQ6IDIwMjHlubQy5pyINOaX
pSAyMToyMA0KPiBUbzogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4g
Q2M6IEdpdXNlcHBlIENhdmFsbGFybyA8cGVwcGUuY2F2YWxsYXJvQHN0LmNvbT47IEFsZXhhbmRy
ZSBUb3JndWUNCj4gPGFsZXhhbmRyZS50b3JndWVAc3QuY29tPjsgSm9zZSBBYnJldSA8am9hYnJl
dUBzeW5vcHN5cy5jb20+OyBEYXZpZA0KPiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBK
YWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgTmV0d29yaw0KPiBEZXZlbG9wbWVudCA8
bmV0ZGV2QHZnZXIua2VybmVsLm9yZz47IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD47DQo+
IEZsb3JpYW4gRmFpbmVsbGkgPGYuZmFpbmVsbGlAZ21haWwuY29tPjsgV2lsbGVtIGRlIEJydWlq
bg0KPiA8d2lsbGVtZGVicnVpam4ua2VybmVsQGdtYWlsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQ
QVRDSCBuZXQtbmV4dCAyLzJdIG5ldDogc3RtbWFjOiBzbGlnaHRseSBhZGp1c3QgdGhlIG9yZGVy
IG9mIHRoZQ0KPiBjb2RlcyBpbiBzdG1tYWNfcmVzdW1lKCkNCj4gDQo+IE9uIFRodSwgRmViIDQs
IDIwMjEgYXQgNToxOCBBTSBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0K
PiB3cm90ZToNCj4gPg0KPiA+IFNsaWdodGx5IGFkanVzdCB0aGUgb3JkZXIgb2YgdGhlIGNvZGVz
IGluIHN0bW1hY19yZXN1bWUoKSwgcmVtb3ZlIHRoZQ0KPiA+IGNoZWNrICJpZiAoIWRldmljZV9t
YXlfd2FrZXVwKHByaXYtPmRldmljZSkgfHwgIXByaXYtPnBsYXQtPnBtdCkiLg0KPiA+DQo+ID4g
U2lnbmVkLW9mZi1ieTogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4g
DQo+IFRoaXMgY29tbWl0IG1lc3NhZ2Ugc2F5cyB3aGF0IHRoZSBjb2RlIGRvZXMsIGJ1dCBub3Qg
d2h5IG9yIHdoeSBpdCdzIGNvcnJlY3QuDQoNClRoaXMganVzdCBzbGlnaHQgY2hhbmdlcyB0aGUg
Y29kZSBvcmRlciwgdGhlcmUgaXMgbm8gZnVuY3Rpb24gY2hhbmdlLCBJIHdpbGwgaW1wcm92ZSB0
aGUgY29tbWl0IG1lc3NhZ2UgaWYgbmVlZGVkLg0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhh
bmcNCg==
