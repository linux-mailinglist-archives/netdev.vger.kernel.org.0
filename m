Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA1C348AC1
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 08:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhCYHxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 03:53:35 -0400
Received: from mail-eopbgr70079.outbound.protection.outlook.com ([40.107.7.79]:62279
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229693AbhCYHxa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 03:53:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jTGs0liMf9zRYxtzVkg9u1f06dAb6plhik8zfUkAqY+Y0cKgyqXBzekAtG4NkZUs6ioK09vwlu2wdaZuTOqlipt4Ef25cIN2AWOFFoCSJUUtKYiu2F8ULrOrnGpNfpdohrQbCGc2PkBRSYSNSH2eyJHt8XYL+eMAbDYps77gvu6BK4tGaoaxoMfCECWEcXyvxCbc099+MLn5sbGa5ZjjOnul8BSLU8mJPZQfO6NQqcYdnBCxspZTmeAHYXS1kF8Vnu0DHA/m+bBkJ7iRPJPm9pqsonOX8KLmikxmL5jwiXUAZNVM3uIi0q/6Mp4vc4se3wDd8rn3qYgSGf+sXLAlrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XnK/0XXwjbkRf66/YJAm52LD4JDIy8kzfVGw4bwcImg=;
 b=LgEzKadWvFRTGXOkTHiiIELt7tnUfF9NvZFjPr1lCUwTyFxAli1AcZrr+niXX8I3ByKTkOowKDt22jLTNdJE9iE/lP0T34MKLPg9YCodP1HWOJObFWY1gKPBm0eFU2xjlbswJ/lgPFk3GU9tSzSq7awzLTh/5Uy6RWjBh4ZrfVq/RPcijLyptZ6vmfBfgXI4BN1qz+T1IauNppW3tclDuHXPe/ts1ZkKjHds+O1bM2mfyT+Ld2B2VTbqMw7ISg8J47dkHzDLPM/oZLag2b3aZE2HvxcFRuJwiwSHDy2rz6Ngp7APpaipvppCTEXqI4DxPPcLR9P6tvmv6DQTll4r6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XnK/0XXwjbkRf66/YJAm52LD4JDIy8kzfVGw4bwcImg=;
 b=XIvMGzqaj9VlZvpgTZx3zHQ1Kcg0pjAOxDR3wNgSwn8c6gMRWe0AFrsV+4CyHieqDlJC5yEEc8VSbx6YiqaTmlW3nYQ75Tpnc7lSyxF5MZR1CklpmyJ7l0y4zyr7JJbWSzqoDfsC16C9S2pB3HgR36HY4u0s5l+mG22iQZz2C7U=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB5193.eurprd04.prod.outlook.com (2603:10a6:10:15::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Thu, 25 Mar
 2021 07:53:26 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%6]) with mapi id 15.20.3977.025; Thu, 25 Mar 2021
 07:53:26 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Jon Hunter <jonathanh@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: Regression v5.12-rc3: net: stmmac: re-init rx buffers when mac
 resume back
Thread-Topic: Regression v5.12-rc3: net: stmmac: re-init rx buffers when mac
 resume back
Thread-Index: AQHXIJuN/Okb/PN4nkWB+yH0VnH6i6qTC9OwgAAITACAAT8a8A==
Date:   Thu, 25 Mar 2021 07:53:26 +0000
Message-ID: <DB8PR04MB6795863753DAD71F1F64F81DE6629@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <708edb92-a5df-ecc4-3126-5ab36707e275@nvidia.com>
 <DB8PR04MB679546EC2493ABC35414CCF9E6639@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <0d0ddc16-dc74-e589-1e59-91121c1ad4e0@nvidia.com>
In-Reply-To: <0d0ddc16-dc74-e589-1e59-91121c1ad4e0@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 61520ed1-b210-4c3c-4485-08d8ef631295
x-ms-traffictypediagnostic: DB7PR04MB5193:
x-microsoft-antispam-prvs: <DB7PR04MB5193B81CC88360D371881E50E6629@DB7PR04MB5193.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fQVR8VXSkuuXxkK2C8GnRqZ+s/UinPsEvr0Atx231FuqqPL4o/Tw+G5VxU4BAc7uoWkS+eNwI56oODJDmbuvfOoLOuwzuOGplr4Qg5Dp/xkEtt99EeGivy9Q5JRWRV98xaCPpx69jm4b69IXqz/7LoA9gseskhxZSBdm5hv9jykd3C5yXnq7M2N0QCr3/R1Rl45JK0cViDCz6llG2yafhisxxlWIj6OFKz+YAJXFKAbVv5iGsJV2kgX7/7FzG2zNc6PfjTO6ge3nCX67n8t7DP6H4JGKof1jAF0J3Gykwwcg2eaxp7p+8xP2o0dcULtvRPoq5UBD0ZVi7f7tWwQko7UJwykDjoljKvp5w6c4xP4LbOnfKYF5AF+bNISPjMP6g/GnpTJ9psa3BbEEUbrlLxMq1W929Ix+0Hp52NFbIZNapTdgfCFDexkBPy7kLareV3RFEm8KafumpVn7gYxA8W4YUjRLFcFrIY0XGNAvcuV1oGiirPnR39e6YS/Xcy5M9XQ0TejqPaJg7OE9y6Do92wIShhhEW3RnKsCpR5qpP3cPsNCS5muQT9ds4FYuf5Gwzu+rwmTttm1BDf1KPUibUgAK1EFC6wPvy9j8/YuEfSOWQONZJ+LLoTySnyBvUvIMPuvwUq0RWuIAThDiXDiOtUKvuBWT7jBvTL+uYyhYCY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(6916009)(52536014)(9686003)(83380400001)(4326008)(26005)(316002)(55016002)(186003)(76116006)(8676002)(86362001)(8936002)(478600001)(66446008)(66476007)(66556008)(64756008)(66946007)(6506007)(7696005)(71200400001)(33656002)(54906003)(5660300002)(2906002)(38100700001)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?akU2cnQ4STNXeGJ1ZHFEK25tVno1OXM4N0JCaU1lVktFaWhPeExNNVMrdCt0?=
 =?utf-8?B?cjEyb2syZDVaMXRMekJaWnhIYWd1T3JTVjJzMU42ZVFhbXJBZ3RERFhjTno3?=
 =?utf-8?B?UGNHTEdHWmMxaVBYeER1ditORG5waWdrZFdhT1NGSWNWM1FReUpqYlFkbE9h?=
 =?utf-8?B?enFPZ1UrS0t5SkJIQUhTZDA3VnVOM09JQXVnYmpjc3FpUytNZ3g5dWQwY2pu?=
 =?utf-8?B?d1pFcUFXMTZZeHRxTjdqanJkREVxQ1RpOHJ5RXN1eTlteUpETklCUDNwaTFo?=
 =?utf-8?B?c29GMENNMmsvazBsMkxhbk5GaHU0eHFmZkk4UDRiREtYKzlmU3BIRkF6YUVp?=
 =?utf-8?B?UlVwckxvRHVFUmcvelowMG9oVUtxcXFsQy8zSjNGTHlJeVhZTHBuOXFhdnFR?=
 =?utf-8?B?YWJlc0kySElXWGMxRWJHaDNsd0dIRFYwYmRDVlMrYVJQNElOUDB1Um1BUS8r?=
 =?utf-8?B?ZTEwZzdQVUdIbm1KV3lrU2ViVThxYnR5c0VhQ3B6WWxmSGFiZWZ2VWdyMnk5?=
 =?utf-8?B?MElobnBVdzJneWV5SHkyUkdvZHh3KzdlRk44N1o3djdIU00yclRaMm9IQXov?=
 =?utf-8?B?MTJwdjdHNzlBUGh3RnF3eTM1YzJ4MGpmRWhrdnVJL3FLbEJpdHQrOVBvTTlB?=
 =?utf-8?B?U1E3bG5KV0dtN1pQNkR2VFM4UitMblEwcmVBdS9ySHgzMTZNQTJXMzdaUG5y?=
 =?utf-8?B?Vms3bTNYOGxzREIyZFgyZHVGdG5UL0NCVnJKNXlXUzNtS3NvZmx1ODQwVS9o?=
 =?utf-8?B?a2x3cmhmaHltaXpaZWpYdGJRUFdublhJSVJ3NTlydlRKUEdWVnVwSUt5cFdV?=
 =?utf-8?B?bTAzc1p6Y2puK0RlejFoTkVpeTF3RFlIUFVuczljdG5Cd0pxa2g4UTQ1Q3Uw?=
 =?utf-8?B?SmxrbE4rb0xwaDJnaXo1V055b1p2WjFNTmZ1RDgwb0NLdDRWTGptN1NvNENC?=
 =?utf-8?B?WUhUdVRmRFZ6Smt2SjFuZjFJVlR6dGorK20xVm9SdlFGeFpLVVAyRTYwWE9N?=
 =?utf-8?B?ZjFIL1JwK1RlZzd3QytxTWQwcXBwT0VHSGdYZ0VKcW1uRjI5YWUrY25hQXhM?=
 =?utf-8?B?eHFxdHVUWExjdkZ4KzFWaUdRRkhsQlZtRXhwUk5SeU1ZZkRGTUhPTHB2REVy?=
 =?utf-8?B?TTNvSmRXZmozcSt4d2NHeHVlNTJ1SW5EVnhWTjViWUFTcStheGQyajdTZjhT?=
 =?utf-8?B?Z1RmSmZPc0NvUTVVd0gvWHhPUVJ6UTZnSHZsQ0FaQkFRUS92SFA3UHE3M3Zt?=
 =?utf-8?B?N1MrK1l4Q1k2R3QyRE9uY2twR2NsSWE4UU1PZDREQ2xiTkpnUGxNd3d1Q2hv?=
 =?utf-8?B?MGJvcjRwb3Z3UVBuaEVnQ3p1c1E1eURRN2t1V0o1YnFpY1QwdXlGQ0RCTjBm?=
 =?utf-8?B?a0pKTVZtRjVvTFFnbFBpMXBBNmNRbEJPZlhEZzVFWDBOTEc5czNOcEtORlNu?=
 =?utf-8?B?Wjg0cy9mRkhobE56OG9aY3lOQ3JOM2NFRGgwMEVwRE9NNEJ3QnFVN0F5ZVQ4?=
 =?utf-8?B?SkwwOEllY29TMGpUQmcrUEdkbFhxZmhrc2x3S1BaVVhpbHNaUEJUUzI1cGxP?=
 =?utf-8?B?aUFjN3psLzE0KzZBUlVUbFc0K21GRVU4eGZXTmwxeC90SlNaUzZqdlh1R1Nk?=
 =?utf-8?B?MjdlZ21DK3VjaXQ3YzdBWEl4STNhWWlSOVJpNUppUXA0cHZiTjBoTXZWa0dj?=
 =?utf-8?B?MS9wVjBtNFA2QWNvL0QzYmllZVVQc2xwSEpKbkFuRUc4U2J0Si9zTlNnNy9O?=
 =?utf-8?Q?xAXLFeR0OPHDeAsfWL8aoq3tncohKywhAAQi1Qr?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61520ed1-b210-4c3c-4485-08d8ef631295
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2021 07:53:26.4283
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: usNYedo5Zv1C5nCh0NEBi+wk0k8C8z0HQRrPiaf1f0fWI6P08Cxu3MRKbtnKzOjac1oCH+KtseiEfZQzDvNpNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5193
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpvbiBIdW50ZXIgPGpvbmF0
aGFuaEBudmlkaWEuY29tPg0KPiBTZW50OiAyMDIx5bm0M+aciDI05pelIDIwOjM5DQo+IFRvOiBK
b2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiBDYzogbmV0ZGV2QHZnZXIu
a2VybmVsLm9yZzsgTGludXggS2VybmVsIE1haWxpbmcgTGlzdA0KPiA8bGludXgta2VybmVsQHZn
ZXIua2VybmVsLm9yZz47IGxpbnV4LXRlZ3JhIDxsaW51eC10ZWdyYUB2Z2VyLmtlcm5lbC5vcmc+
Ow0KPiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPg0KPiBTdWJqZWN0OiBSZTogUmVn
cmVzc2lvbiB2NS4xMi1yYzM6IG5ldDogc3RtbWFjOiByZS1pbml0IHJ4IGJ1ZmZlcnMgd2hlbiBt
YWMNCj4gcmVzdW1lIGJhY2sNCj4gDQo+IA0KPiANCj4gT24gMjQvMDMvMjAyMSAxMjoyMCwgSm9h
a2ltIFpoYW5nIHdyb3RlOg0KPiANCj4gLi4uDQo+IA0KPiA+IFNvcnJ5IGZvciB0aGlzIGJyZWFr
YWdlIGF0IHlvdXIgc2lkZS4NCj4gPg0KPiA+IFlvdSBtZWFuIG9uZSBvZiB5b3VyIGJvYXJkcz8g
RG9lcyBvdGhlciBib2FyZHMgd2l0aCBTVE1NQUMgY2FuIHdvcmsNCj4gZmluZT8NCj4gDQo+IFdl
IGhhdmUgdHdvIGRldmljZXMgd2l0aCB0aGUgU1RNTUFDIGFuZCBvbmUgd29ya3MgT0sgYW5kIHRo
ZSBvdGhlciBmYWlscy4NCj4gVGhleSBhcmUgZGlmZmVyZW50IGdlbmVyYXRpb24gb2YgZGV2aWNl
IGFuZCBzbyB0aGVyZSBjb3VsZCBiZSBzb21lDQo+IGFyY2hpdGVjdHVyYWwgZGlmZmVyZW5jZXMg
d2hpY2ggaXMgY2F1c2luZyB0aGlzIHRvIG9ubHkgYmUgc2VlbiBvbiBvbmUgZGV2aWNlLg0KSXQn
cyByZWFsbHkgc3RyYW5nZSwgYnV0IEkgYWxzbyBkb24ndCBrbm93IHdoYXQgYXJjaGl0ZWN0dXJh
bCBkaWZmZXJlbmNlcyBjb3VsZCBhZmZlY3QgdGhpcy4gU29ycnkuDQoNCj4gPiBXZSBkbyBkYWls
eSB0ZXN0IHdpdGggTkZTIHRvIG1vdW50IHJvb3Rmcywgb24gaXNzdWUgZm91bmQuIEFuZCBJIGFk
ZCB0aGlzDQo+IHBhdGNoIGF0IHRoZSByZXN1bWUgcGF0Y2gsIGFuZCBvbiBlcnJvciBjaGVjaywg
dGhpcyBzaG91bGQgbm90IGJyZWFrIHN1c3BlbmQuDQo+ID4gSSBldmVuIGRpZCB0aGUgb3Zlcm5p
Z2h0IHN0cmVzcyB0ZXN0LCB0aGVyZSBpcyBubyBpc3N1ZSBmb3VuZC4NCj4gPg0KPiA+IENvdWxk
IHlvdSBwbGVhc2UgZG8gbW9yZSB0ZXN0IHRvIHNlZSB3aGVyZSB0aGUgaXNzdWUgaGFwcGVuPw0K
PiANCj4gVGhlIGlzc3VlIG9jY3VycyAxMDAlIG9mIHRoZSB0aW1lIG9uIHRoZSBmYWlsaW5nIGJv
YXJkIGFuZCBhbHdheXMgb24gdGhlIGZpcnN0DQo+IHJlc3VtZSBmcm9tIHN1c3BlbmQuIElzIHRo
ZXJlIGFueSBtb3JlIGRlYnVnIEkgY2FuIGVuYWJsZSB0byB0cmFjayBkb3duDQo+IHdoYXQgdGhl
IHByb2JsZW0gaXM/DQo+IA0KDQpBcyBjb21taXQgbWVzc2FnZXMgZGVzY3JpYmVkLCB0aGUgcGF0
Y2ggYWltcyB0byByZS1pbml0IHJ4IGJ1ZmZlcnMgYWRkcmVzcywgc2luY2UgdGhlIGFkZHJlc3Mg
aXMgbm90IGZpeGVkLCBzbyBJIG9ubHkgY2FuIA0KcmVjeWNsZSBhbmQgdGhlbiByZS1hbGxvY2F0
ZSBhbGwgb2YgdGhlbS4gVGhlIHBhZ2UgcG9vbCBpcyBhbGxvY2F0ZWQgb25jZSB3aGVuIG9wZW4g
dGhlIG5ldCBkZXZpY2UuDQoNCkNvdWxkIHlvdSBwbGVhc2UgZGVidWcgaWYgaXQgZmFpbHMgYXQg
c29tZSBmdW5jdGlvbnMsIHN1Y2ggYXMgcGFnZV9wb29sX2Rldl9hbGxvY19wYWdlcygpID8NCg0K
QmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQo+IEpvbg0KPiANCj4gLS0NCj4gbnZwdWJsaWMN
Cg==
