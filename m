Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 516E0470215
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 14:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236707AbhLJNyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 08:54:49 -0500
Received: from mail-gv0che01on2111.outbound.protection.outlook.com ([40.107.23.111]:13920
        "EHLO CHE01-GV0-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230296AbhLJNyt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Dec 2021 08:54:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TIlTimwfWlUHn56ijmXsVM7B1wCIJSkqmMDzhaESxz98RV4ZL970XsTArDVEPf8SLwlfxRt18361OmfQ6s/PgiAqkJpOdTi+7dZeWCGMdwhVB7rmEnV4LE07D9xY4CBOgbsfb7GPYAi3P5wclVNpiiYIzmfhN6tXDMXCxsHTK/a98Xjqt+15sf3myWmH5EMCsMidCw4akUFj9uGvm/JajELLUO0ArMk3cPqIwB0ZBF0sui4owJ/r0978g7qdkY5GEJi1q4lysMlRMekNcfYhFnzEVeQjVng+ycBAAE/ekScV1de6ea9HmI7i//as/LnBd1k+AlKjVvSZlWITXxcRBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S2EH5YF7+o8yoYU0cr7UkyU/h5pjB27grl6BqLl++74=;
 b=l4L7p1+V8NKHDVx0tBvMDGqUAE/eaGeG0EsfdfMACcyLT2Q2bnFujq4tb8IxA7rIXM3wXgc1fKCLQclf5sDJ1fhjc5OHFaLPE1F9mBfGIT69SRN3QDTIVLBw2yICYN89nCC2W7tl/8zA7A/waNK+6tXkKrAR69n4EJA7orxMGW3HleX+1KtQ+X8N7dLm5kaSSxZDXE6Eyk7s8VexTtoNsFs4vO9tLMbMKkwTJ7uk8q1ohlSaq0AdRmrkcp+QbrIUlpZbiQc65p1VBFKq2cAwlFyvJ7EIWIC4ZbW6io5mT84Ctm6Doekdu8KuLoubW14yscU8jzJw0yJZV/FagMis2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S2EH5YF7+o8yoYU0cr7UkyU/h5pjB27grl6BqLl++74=;
 b=ZPCvW6GrXNWu1BWcI5XATdTMf9YuLJ280XtLzuayetUPais6ti6xvoPBwTEIZ+PefQExfbVvAJJel8YDrO7DMBNUJbA0FfeELs7MZie0pVSh557hocnSKjEvSIRviy8dmWG8As4XdJuVeVVnTY1LKzFK0OTszlqWCrpPMqozGqA=
Received: from ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:34::14)
 by ZR0P278MB0364.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:31::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.24; Fri, 10 Dec
 2021 13:51:00 +0000
Received: from ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 ([fe80::e5c4:5c29:1958:fbea]) by ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 ([fe80::e5c4:5c29:1958:fbea%8]) with mapi id 15.20.4778.015; Fri, 10 Dec 2021
 13:51:00 +0000
From:   Philippe Schenker <philippe.schenker@toradex.com>
To:     "festevam@gmail.com" <festevam@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "qiangqing.zhang@nxp.com" <qiangqing.zhang@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/2] Reset PHY in fec_resume if it got powered down
Thread-Topic: [RFC PATCH 0/2] Reset PHY in fec_resume if it got powered down
Thread-Index: AQHX6on4HliFY0NG/EG5keTVNxrWuawmRrgAgAV+IQA=
Date:   Fri, 10 Dec 2021 13:51:00 +0000
Message-ID: <7a4830b495e5e819a2b2b39dd01785aa3eba4ce7.camel@toradex.com>
References: <20211206101326.1022527-1-philippe.schenker@toradex.com>
         <DB8PR04MB679536F1DD900564B9A957C4E66E9@DB8PR04MB6795.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB679536F1DD900564B9A957C4E66E9@DB8PR04MB6795.eurprd04.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toradex.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1b3fcb9-5ed9-4235-725e-08d9bbe419ad
x-ms-traffictypediagnostic: ZR0P278MB0364:EE_
x-microsoft-antispam-prvs: <ZR0P278MB0364AB017B37EBBA3C35A6F8F4719@ZR0P278MB0364.CHEP278.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k4iXKk6pBFbVmt3zGE0p5KxeiKc6Z4BeyDmtZCSTZ3wEUXy3nd0rAfwBgRb054tjtNpilpg/54qb/XQlsWZS8wkPnFkm+zXDkU99D1h0b4pNryKaJT8NLHqyiak7ZEVkkONNFITv91sJucdTk3i/dXVb5hpX8fkz3GUq9f8/JL9icWYyy0VOa31zI1b1GRJ8bWnekDHWCRGGu/dVXHxs1nZ0vehsHpspRGcU78sXLeoqi4lLLGUQK4KDWhj+wD6IY4/LeOfrwD3BrWgni/dDWt741DDZlsxfWRygnlUTZD7jSlchvDyvkDceoH29kwZ8FwaR8YiQ1c8kz3FdQ9lXzdnyflyTCJtDBhmT7/oIRzEQIYXzsVkB1MGQlTZz1vEg6WelVCqaVT50RpLXzoSJFZ5SEwrqKnmXljv4TgPnaS2M6ofMvaZfRKwCvVZVn22QL+2NEd/xJWTnc3eHkPWMpjwVeL64tmbNma8RwCqEzXPezrWkQo1kOCJen5d5JqYpXJP8CR/Bs2LboAqaa3R5vSdKl+rFR4h9B2tfKB5HP+iXlOwHSq3gBopu449GQ0dKL9wUvys6oFG2adELl6MIzWMKmQ8kptHe8VfJDPrONogyOU1rNpG6Z697ayrOWqjhIziAOuMimCUw2PCFR0kt122fw8eze2vmsSfpTk0S+lZhyj0bBZ7JPJOxBgETS8Baf0gzgwuZPHCBH/bdTP3yq3211Pm9cY27gsl8NdpgGIFmUa7LB4nGp4evgPn1Ia2i6XOPQk/KqISXld4nYq5tJW+Jl8QOXVBifB1FHrup74M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(136003)(396003)(39850400004)(6486002)(38100700002)(38070700005)(122000001)(2906002)(5660300002)(6506007)(44832011)(110136005)(8936002)(26005)(53546011)(6512007)(76116006)(186003)(66446008)(91956017)(8676002)(2616005)(83380400001)(316002)(64756008)(66946007)(508600001)(36756003)(66476007)(66556008)(4326008)(71200400001)(86362001)(45080400002)(966005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dEtPa2ZHTmVPcDhPN0s0Vnh5aEh6bWxIQUt0b1hua1gzb0dJY2NkdmRUOG94?=
 =?utf-8?B?Mmx2aVhWSVkxVkszTGhqcXZGSjdhUFBQZ25Ea0JaTmp3c3Y3bkoxYUdsNnov?=
 =?utf-8?B?NnVtUHdrbTF5bWtZOGZqVnNWR2VoSGNSdjR2Wk9NYVovdFVZRVQydURzZXZo?=
 =?utf-8?B?dkE3a0loVkhlU0YwS3IxYTl1STV6blJ1TFRhRldpck56SUJMSW1ab2E3UVR2?=
 =?utf-8?B?aVVFbzVXNUNFYzZGaW9pS3E3dkdOVGhaVHA4dlVYbzRyQ1lISkhKVU9XdHBy?=
 =?utf-8?B?WFhUdFRudlhVK1h3R21HcWJHY0k0ZGx5NDhsTWVKV1Iza3BLQjZFZ0Vpd0ZF?=
 =?utf-8?B?TXNJa1cxejJPdGFMZVl3WnRuNWxCTlZDSm0xYnhaT2YxTDdpOWdadmdaaUdj?=
 =?utf-8?B?clpGcG9CV28xRUpwb0xWNmFWS2FuL00wckxyTzVVc1R0VjRaTGlDL3cxbmRp?=
 =?utf-8?B?RG9nTDVQK1dlVCtXdytRSTlFZDlBQ3dqZVI1YlNpcVJYMWt6YUwvclFYcnQx?=
 =?utf-8?B?eHZ5eEpPUmN1ZFlweXNQWDdPbXVLK2tFUGhiYXRGT2lrVEQ2d1BneDZoT1BN?=
 =?utf-8?B?T2JEaGlEb29UR0UrNGRFcmNTRzQ1THBJYlZqTDc3OExRMlUxNVg3OCsyU0RZ?=
 =?utf-8?B?QTVOSUZkWVhma1h6MHlJVVFoUWplQkpacE1mdXhpUG9PNFVTQkVDZGM1cVFM?=
 =?utf-8?B?Sm1YalJ5Ui9VOHZLVTVoR1laU0pPcUJoWW5vNkRFWDdaY21qSGJUL2ZpQzJv?=
 =?utf-8?B?Y0pQWnVPMVl2bGtwcW1DcFplczZ4MHN0ckYrNVh0cUdxSndPNERNQjAxQ2Vu?=
 =?utf-8?B?R2lSL1NqN01NbmNJNlFrMnJtQlRIcmVFOC9CcXdDMWJUcDZ3NVNkY1Z6S2FP?=
 =?utf-8?B?bWlQOEN2aCt5QmliVDlhb0RIaCtSWTNzN0FSZEZsaG5kSTZkMnh6WWVBdzRX?=
 =?utf-8?B?SVdsSkxHdUp5ZWhVaS9LUjFoRndqeG5vRFp0ckZxN2IyU0JBeUFVRnlVUm1O?=
 =?utf-8?B?dy9tc3FuaVJwTUdtb1BSa2taalhoNWJEOWVGS3BDcHR0SDk0aUloLzlIaXM2?=
 =?utf-8?B?d05FK0UrNUtTck8rN3FZbkNxQ2JnWWo2aWtyeDhzTGh6S2RPZXQ1aVozWGMy?=
 =?utf-8?B?MURhc3dmdFFNZk5oSEw1NlRFK29LM01VMzVWUXlTZHpZL2NjVGVlSWFVRENr?=
 =?utf-8?B?YmhGRGRxb3ZFZ2RnVm8xSzJlK2hXdURGVEcvblhEWGVHbkhKN3V6RlhURVMz?=
 =?utf-8?B?V3hVT3ZlYjhOeVBHNzdjUmd2WXd4MnRZN0hXdGR4SXZPQ0JRcFh5dlY4NTlK?=
 =?utf-8?B?eGFUdkRlbVFwSld3YzQ5ZWFqR1QwQ1JaZXhiOGdna0dPajhXWEE4aFFhS1BF?=
 =?utf-8?B?U0dGZE1OVC9zLzFmWW12RkRCWFpiU05WcWRGc2tuSCtxUU16VUZKVC9Ed1ly?=
 =?utf-8?B?a0w2R2pMOEJwMmdXemd1RVRLd0VXVVNDL0diRmNPK2I0b3NrQ3pCQkdZY3p2?=
 =?utf-8?B?QzNnV29TR2hBM3NobGxyOUs5RE5rUnVYRUNtKytTaVQ0dy9zNE9QTG5vZE9i?=
 =?utf-8?B?NkVSYWRwRHdzdnNVT05yUitrUlVNOS9ZakkvRm85eDdKSjdNWWl6dHp1SzBl?=
 =?utf-8?B?bVVJaEpmZDhTMlRIaThoWmh3OEk5WmJ0TVkxYy85bmVzYVpTUnh6TVRER3J3?=
 =?utf-8?B?TUlleDlWRTNYVDJnQktBbCtmM2NMK0FOOUphOEJGQnNHUnNMd0lEeG9DNUM0?=
 =?utf-8?B?NnY0N1Z0Ymo3UGVtUVltWHJxa1hWaHZ6OEZzdmxtTHhRZ1hjR3lTOUtGMnFs?=
 =?utf-8?B?empFS1g0aTdxRGVKOGxUbHB6TXZIcmp5Y3kzM3VrSmZITmJDQzV3S0JUcjh6?=
 =?utf-8?B?QTROdXlxOHhxTDExaXlHZDdxS0xGTWRMTzBnc3JrRWVyRlY3WFJIUHJLNnZx?=
 =?utf-8?B?U012Z29pQ3NHMnFQWE1iM1pmZ3ZWbHBqT1JTQm1QTFRzZVgxeW1lWXdjSTQ0?=
 =?utf-8?B?aXdKb1YvMWZBTXBOUU43WEMvU0VLMWlzS0NPT3ZQcVBsMnVESHVsZ1diZmJM?=
 =?utf-8?B?cW9ISVZpUGFTdlpwSDYyNWNreGxIMExrRFhuOWxmVlhJRDFubmR2bk9JdU5P?=
 =?utf-8?B?dFFuUk9IWjIxR2VaRmtoR1hoMkU1Nks4VWZibXFLYmVHdlpHTi9iS3pNbUZs?=
 =?utf-8?B?ZlRyQ1RiSnhaWFV0b1Nxait5Zm5EbWZvc1krRUVXa2JScDVuVU9sbmtueS91?=
 =?utf-8?Q?gwC0sdj7tGsJsLRaQlHOPeDl2gmt43SLsWrexMyKLU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8C35B2531F7ED34CB6F271A5F5380DA6@CHEP278.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: a1b3fcb9-5ed9-4235-725e-08d9bbe419ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2021 13:51:00.5250
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: grq5IWrWBVh4BtUq4+B6UJkJx3SoNScXDqxeW9Pl2XybilE5Ws3LYDGEg3AOUl5eqnMWjstDWV/T+Of+IMPRydzA0lOyNDEmQCZEjlnDQYY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR0P278MB0364
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTEyLTA3IGF0IDAxOjU4ICswMDAwLCBKb2FraW0gWmhhbmcgd3JvdGU6DQo+
IA0KPiBIaSBQaGlsaXBwZSwNCj4gDQo+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4g
PiBGcm9tOiBQaGlsaXBwZSBTY2hlbmtlciA8cGhpbGlwcGUuc2NoZW5rZXJAdG9yYWRleC5jb20+
DQo+ID4gU2VudDogMjAyMeW5tDEy5pyINuaXpSAxODoxMw0KPiA+IFRvOiBuZXRkZXZAdmdlci5r
ZXJuZWwub3JnOyBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPjsNCj4gPiBG
YWJpbyBFc3RldmFtIDxmZXN0ZXZhbUBnbWFpbC5jb20+OyBGdWdhbmcgRHVhbg0KPiA+IDxmdWdh
bmcuZHVhbkBueHAuY29tPjsgRGF2aWQgUyAuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47
DQo+ID4gUnVzc2VsbA0KPiA+IEtpbmcgPGxpbnV4QGFybWxpbnV4Lm9yZy51az47IEFuZHJldyBM
dW5uIDxhbmRyZXdAbHVubi5jaD47IEpha3ViDQo+ID4gS2ljaW5za2kgPGt1YmFAa2VybmVsLm9y
Zz4NCj4gPiBDYzogUGhpbGlwcGUgU2NoZW5rZXIgPHBoaWxpcHBlLnNjaGVua2VyQHRvcmFkZXgu
Y29tPjsNCj4gPiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+ID4gU3ViamVjdDogW1JG
QyBQQVRDSCAwLzJdIFJlc2V0IFBIWSBpbiBmZWNfcmVzdW1lIGlmIGl0IGdvdCBwb3dlcmVkDQo+
ID4gZG93bg0KPiA+IA0KPiA+IA0KPiA+IElmIGEgaGFyZHdhcmUtZGVzaWduIGlzIGFibGUgdG8g
Y29udHJvbCBwb3dlciB0byB0aGUgRXRoZXJuZXQgUEhZDQo+ID4gYW5kIHJlbHlpbmcNCj4gPiBv
biBzb2Z0d2FyZSB0byBkbyBhIHJlc2V0LCB0aGUgUEhZIGRvZXMgbm8gbG9uZ2VyIHdvcmsgYWZ0
ZXINCj4gPiByZXN1bWluZyBmcm9tDQo+ID4gc3VzcGVuZCwgZ2l2ZW4gdGhlIFBIWSBkb2VzIG5l
ZWQgYSBoYXJkd2FyZS1yZXNldC4NCj4gPiBUaGUgRnJlZXNjYWxlIGZlYyBkcml2ZXIgZG9lcyBj
dXJyZW50bHkgY29udHJvbCB0aGUgcmVzZXQtc2lnbmFsIG9mDQo+ID4gYSBwaHkgYnV0DQo+ID4g
ZG9lcyBub3QgaXNzdWUgYSByZXNldCBvbiByZXN1bWUuDQo+ID4gDQo+ID4gT24gVG9yYWRleCBB
cGFsaXMgaU1YOCBib2FyZCB3ZSBkbyBoYXZlIHN1Y2ggYSBkZXNpZ24gd2hlcmUgd2UgYWxzbw0K
PiA+IGRvbid0DQo+ID4gcGxhY2UgdGhlIFJDIGNpcmN1aXQgdG8gZGVsYXkgdGhlIHJlc2V0LWxp
bmUgYnkgaGFyZHdhcmUuIEhlbmNlIHdlDQo+ID4gZnVsbHkgcmVseQ0KPiA+IG9uIHNvZnR3YXJl
IHRvIGRvIHNvLg0KPiA+IFNpbmNlIEkgZGlkbid0IG1hbmFnZSB0byBnZXQgdGhlIG5lZWRlZCBw
YXJ0cyBvZiBBcGFsaXMgaU1YOCB3b3JraW5nDQo+ID4gd2l0aA0KPiA+IG1haW5saW5lIHRoaXMg
cGF0Y2hzZXQgd2FzIG9ubHkgdGVzdGVkIG9uIHRoZSBkb3duc3RyZWFtIGtlcm5lbA0KPiA+IHRv
cmFkZXhfNS40LTIuMy54LWlteC4gWzFdIFRoaXMga2VybmVsIGlzIGJhc2VkIG9uIE5YUCdzIHJl
bGVhc2UNCj4gPiBpbXhfNS40LjcwXzIuMy4wLiBbMl0gVGhlIGFmZmVjdGVkIGNvZGUgaXMgc3Rp
bGwgdGhlIHNhbWUgb24NCj4gPiBtYWlubGluZSBrZXJuZWwsDQo+ID4gd2hpY2ggd291bGQgYWN0
dWFsbHkgbWFrZSBtZSBjb21mb3J0YWJsZSBtZXJnaW5nIHRoaXMgcGF0Y2gsIGJ1dCBkdWUNCj4g
PiB0bw0KPiA+IHRoaXMgZmFjdCBJJ20gc2VuZGluZyB0aGlzIGFzIFJGQyBtYXliZSBzb21lb25l
IGVsc2UgaXMgYWJsZSB0byB0ZXN0DQo+ID4gdGhpcyBjb2RlLg0KPiA+IA0KPiA+IFRoaXMgcGF0
Y2hzZXQgYWltcyB0byBjaGFuZ2UgdGhlIGJlaGF2aW9yIGJ5IHJlc2V0dGluZyB0aGUgZXRoZXJu
ZXQNCj4gPiBQSFkgaW4NCj4gPiBmZWNfcmVzdW1lLiBBIHNob3J0IGRlc2NyaXB0aW9uIG9mIHRo
ZSBwYXRjaGVzIGNhbiBiZSBmb3VuZCBiZWxvdywNCj4gPiBwbGVhc2UNCj4gPiBmaW5kIGEgZGV0
YWlsZWQgZGVzY3JpcHRpb24gaW4gdGhlIGNvbW1pdC1tZXNzYWdlcyBvZiB0aGUgcmVzcGVjdGl2
ZQ0KPiA+IHBhdGNoZXMuDQo+ID4gDQo+ID4gW1BBVENIIDIvMl0gbmV0OiBmZWM6IHJlc2V0IHBo
eSBpbiByZXN1bWUgaWYgaXQgd2FzIHBvd2VyZWQgZG93bg0KPiA+IA0KPiA+IFRoaXMgcGF0Y2gg
Y2FsbHMgZmVjX3Jlc2V0X3BoeSBqdXN0IGFmdGVyIHJlZ3VsYXRvciBlbmFibGUgaW4NCj4gPiBm
ZWNfcmVzdW1lLA0KPiA+IHdoZW4gdGhlIHBoeSBpcyByZXN1bWVkDQo+ID4gDQo+ID4gW1BBVENI
IDEvMl0gbmV0OiBmZWM6IG1ha2UgZmVjX3Jlc2V0X3BoeSBub3Qgb25seSB1c2FibGUgb25jZQ0K
PiA+IA0KPiA+IFRoaXMgcGF0Y2ggcHJlcGFyZXMgdGhlIGZ1bmN0aW9uIGZlY19yZXNldF9waHkg
dG8gYmUgY2FsbGVkIG11bHRpcGxlDQo+ID4gdGltZXMuIEl0DQo+ID4gc3RvcmVzIHRoZSBkYXRh
IGFyb3VuZCB0aGUgcmVzZXQtZ3BpbyBpbiBmZWNfZW5ldF9wcml2YXRlLg0KPiA+IFRoaXMgcGF0
Y2ggYWltcyB0byBkbyBubyBmdW5jdGlvbmFsIGNoYW5nZXMuDQo+ID4gDQo+ID4gWzFdDQo+ID4g
aHR0cHM6Ly9ldXIwMS5zYWZlbGlua3MucHJvdGVjdGlvbi5vdXRsb29rLmNvbS8/dXJsPWh0dHAl
M0ElMkYlMkZnaXQudG9yDQo+ID4gYWRleC5jb20lMkZjZ2l0JTJGbGludXgtdG9yYWRleC5naXQl
MkZsb2clMkYlM0ZoJTNEdG9yYWRleF81LjQtMi4zLngNCj4gPiAtaW14JmFtcDtkYXRhPTA0JTdD
MDElN0NxaWFuZ3FpbmcuemhhbmclNDBueHAuY29tJTdDZjNjMTM4ZWQ5MjMyDQo+ID4gNGE4ZDc1
ZTcwOGQ5YjhhMTFiOWElN0M2ODZlYTFkM2JjMmI0YzZmYTkyY2Q5OWM1YzMwMTYzNSU3QzAlN0Mw
JQ0KPiA+IDdDNjM3NzQzODI0MzY0MTkzNDIzJTdDVW5rbm93biU3Q1RXRnBiR1pzYjNkOGV5SldJ
am9pTUM0d0xqQXcNCj4gPiBNREFpTENKUUlqb2lWMmx1TXpJaUxDSkJUaUk2SWsxaGFXd2lMQ0pY
VkNJNk1uMCUzRCU3QzMwMDAmYW1wO3NkYQ0KPiA+IHRhPUJ3JTJCWmRxaEFqUFhxS0pGWkNYcDBt
dElkMXg5bWtYNmY2TVcya3k2VTF3dyUzRCZhbXA7cmVzDQo+ID4gZXJ2ZWQ9MA0KPiA+IFsyXQ0K
PiA+IGh0dHBzOi8vZXVyMDEuc2FmZWxpbmtzLnByb3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1o
dHRwcyUzQSUyRiUyRnNvdXJjDQo+ID4gZS5jb2RlYXVyb3JhLm9yZyUyRmV4dGVybmFsJTJGaW14
JTJGbGludXgtaW14JTJGbG9nJTJGJTNGaCUzRGlteF8NCj4gPiA1LjQuNzBfMi4zLjAmYW1wO2Rh
dGE9MDQlN0MwMSU3Q3FpYW5ncWluZy56aGFuZyU0MG54cC5jb20lN0NmM2MxMw0KPiA+IDhlZDky
MzI0YThkNzVlNzA4ZDliOGExMWI5YSU3QzY4NmVhMWQzYmMyYjRjNmZhOTJjZDk5YzVjMzAxNjM1
JTdDDQo+ID4gMCU3QzAlN0M2Mzc3NDM4MjQzNjQxOTM0MjMlN0NVbmtub3duJTdDVFdGcGJHWnNi
M2Q4ZXlKV0lqb2lNDQo+ID4gQzR3TGpBd01EQWlMQ0pRSWpvaVYybHVNeklpTENKQlRpSTZJazFo
YVd3aUxDSlhWQ0k2TW4wJTNEJTdDMzAwMA0KPiA+ICZhbXA7c2RhdGE9b2Y5ejloZlZoSGFrVlNj
THhDZEVvJTJCWG1kMkI5QWQ5WDhScnk2R2pFWkU0JTNEJmENCj4gPiBtcDtyZXNlcnZlZD0wDQo+
ID4gDQo+IA0KPiBJbiBmZWMgZHJpdmVyLCBpdCBoYXMgc3VwcG9ydGVkIGhhcmR3YXJlIHJlc2V0
IGZvciBQSFkgd2hlbiBNQUMgcmVzdW1lDQo+IGJhY2ssDQo+IA0KPiBmZWNfcmVzdW1lKCkgLT4g
cGh5X2luaXRfaHcoKSAtPiBwaHlfZGV2aWNlX3Jlc2V0KCkgZGUtYXNzZXJ0IHRoZQ0KPiByZXNl
dCBzaWduYWwsIHlvdSBvbmx5IG5lZWQgaW1wbGVtZW50DQo+IHRoZSBwcm9wZXJ0aWVzIHdoaWNo
IFBIWSBjb3JlIHByb3ZpZGVkLg0KPiANCj4gSSB0aGluayB5b3Ugc2hvdWxkIG5vdCB1c2UgZGVw
cmVjYXRlZCByZXNldCBwcm9wZXJ0aWVzIHByb3ZpZGVkIGJ5IGZlYw0KPiBkcml2ZXIsIGluc3Rl
YWQgdGhlIGNvbW1vbg0KPiByZXNldCBwcm9wZXJ0aWVzIHByb3ZpZGVkIGJ5IFBIWSBjb3JlLg0K
PiANCj4gUGxlYXNlIGNoZWNrIHRoZSBkdC1iaW5kaW5ncyBmb3IgbW9yZSBkZXRhaWxzOg0KPiBE
b2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2ZzbCxmZWMueWFtbA0KPiBEb2N1
bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2V0aGVybmV0LXBoeS55YW1sDQo+IA0K
PiBCZXN0IFJlZ2FyZHMsDQo+IEpvYWtpbSBaaGFuZw0KDQpIaSBKb2FraW0gYW5kIG1hbnkgdGhh
bmtzIGZvciB0aGF0IGhpbnQhIEkgdHJpZWQgdGhhdCBvdXQgYnV0DQp1bmZvcnR1bmF0ZWx5IGl0
IHN0aWxsIGRvZXMgbm90IHdvcmsgZHVlIHRvIHBoeV9pbml0X2h3KCkgb25seQ0KZGVhc3NlcnRp
bmcgdGhlIHJlc2V0LiBGb3IgdGhhdCB0byB3b3JrLCBmb3IgZXhhbXBsZSBhIGNhbGwgb2YNCnBo
eV9kZXZpY2VfcmVzZXQobmRldi0+cGh5ZGV2LCAxKTsgaW4gZmVjX3N1c3BlbmQgb3IgaW4gZmVj
X3Jlc3VtZQ0KYmVmb3JlIGVuYWJsaW5nIHRoZSBzdXBwbHkgd291bGQgd29yaywgaW4gb3JkZXIg
dG8gYXNzZXJ0IHRoYXQgcmVzZXQuDQoNCkkgc2VlIG5vdyB0d28gd2F5cyB0byBnbyB0byBmaXgg
b3VyIGlzc3VlOg0KDQoxLiBBc3NlcnQgdGhlIHBoeS1yZXNldCBncGlvIGluIGZlY19zdXNwZW5k
KCkgb3IgZmVjX3Jlc3VtZSgpDQoNCjIuIEFkZCBzdXBwb3J0IGZvciByZWd1bGF0b3JzIGluIGRy
aXZlcnMvbmV0L3BoeS9waHktY29yZS5jIGFuZCBoYW5kbGUNCnRoZSBwaHktcmVzZXQgcHJvcGVy
bHkgaW4gdGhlcmUgd2l0aCBhc3NlcnQtdXMgYW5kIGRlYXNzZXJ0LXVzIGRlbGF5cy4NCg0KQXMg
eW91IHByb2JhYmx5IGhhdmUgYSBtdWNoIGJldHRlciBvdmVydmlldzogRG8geW91IHNlZSBhbm90
aGVyDQpwb3NzaWJpbGl0eSB0byBoYW5kbGUgcGh5LXJlc2V0IGFmdGVyIHJlc3VtaW5nPyBPciB3
aGljaCB3YXkgc2hhbGwgSQ0KY2hvb3NlIHRvIGdvIGZvcndhcmQ/DQoNClRoYW5rcyBpbiBhZHZh
bmNlIGZvciBhbnkgYWR2aWNlDQpQaGlsaXBwZQ0KDQo+ID4gUGhpbGlwcGUgU2NoZW5rZXIgKDIp
Og0KPiA+IMKgIG5ldDogZmVjOiBtYWtlIGZlY19yZXNldF9waHkgbm90IG9ubHkgdXNhYmxlIG9u
Y2UNCj4gPiDCoCBuZXQ6IGZlYzogcmVzZXQgcGh5IGluIHJlc3VtZSBpZiBpdCB3YXMgcG93ZXJl
ZCBkb3duDQo+ID4gDQo+ID4gwqBkcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjLmjC
oMKgwqDCoMKgIHzCoCA2ICsrDQo+ID4gwqBkcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUv
ZmVjX21haW4uYyB8IDk4ICsrKysrKysrKysrKysrKystLS0tDQo+ID4gLS0tDQo+ID4gwqAyIGZp
bGVzIGNoYW5nZWQsIDczIGluc2VydGlvbnMoKyksIDMxIGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+
IC0tDQo+ID4gMi4zNC4wDQo+IA0KDQo=
