Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0873B0115
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 12:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhFVKQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 06:16:54 -0400
Received: from mail-am6eur05on2060.outbound.protection.outlook.com ([40.107.22.60]:6465
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229807AbhFVKQw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 06:16:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lFG5qi+LU7u75n+X7df94oBwBPm4BBxy4fg2UwQg71u7KOEtwv47+/kf9FrHmBiJoLx9e/6N2bwRHWiI4t66H3RhozQZV1IMZoLciRpvB5sSzwRAK6G4iIZ8gJD65nem4MqbdGbWzrkUAU6tQKi1ckW9P/6vg1+B6m4o13IlpfDg1RZskBogt/5IXZUlh9+vm2+g39ul4jjhwtv33rz48bat0a7bsf1+UG5aqAdtXLYwT9Qbe8nxyC/LTij4eel1Q6Z4H/1HQUsWjni9fZk7puC/yzx7RGprFdSG+R/w8KHJiolZhiOmEWu+w2RFXBc2Rt1yHJGCwMsbLxW2cVq7kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iYi8sHSRj9wP2ckiX2URAzeuUVjxEjhqAOd7KyNAiRk=;
 b=Pf6MV3MQBq4tsKahQhLlXmwEVxbZisWFuxKgbgGHf4t6GBj9wtjy2acPO6+vHqeGvwx5aHQkhc59Ng2+kX9wj61TKt0dDouneFJB43Zk7xZY4hwKZWnDxIfyRtMNBol9q7obiwIqMxOA22IQf4Wi8d2QjFpqlJPHJh4pn9NLyLnrbum9qlVXn0xEsoCEkdbWuGVg0ve5rfhaRnKA6zpJeIm/Witf7tY3JoHCEZNb6K4eQYbauLAgUZ8yWXFQiX12JsxJk2npmW0nHVDNposafko0HIJqJw2wPIqbYlQHkXrEU+Q9jOaXsHPT0KB0a5zn6PaznJz+Lr0jqd3+mA3tjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iYi8sHSRj9wP2ckiX2URAzeuUVjxEjhqAOd7KyNAiRk=;
 b=Elglbe+TbmLrmN8CUzYVi1Jlo0FkD+Fe21fJV2+3ByWX2M2Tb3cTzMdel6Y/QVg+fNtFX4s1xVcNltMczJjsJ3PPKgiNxDFdwZpya4b5ZlS9QxqQ1WGne8ld0DUdVilp1u4UbtJqTRRecPD3kLffgi7zP4/EZ8XhlOP0B3xy280=
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com (2603:10a6:10:1b::21)
 by DB7PR04MB5209.eurprd04.prod.outlook.com (2603:10a6:10:13::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.23; Tue, 22 Jun
 2021 10:14:34 +0000
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::605f:7d36:5e2d:ebdd]) by DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::605f:7d36:5e2d:ebdd%7]) with mapi id 15.20.4242.023; Tue, 22 Jun 2021
 10:14:34 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "mptcp@lists.linux.dev" <mptcp@lists.linux.dev>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Shuah Khan <shuah@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rui Sousa <rui.sousa@nxp.com>,
        Sebastien Laveze <sebastien.laveze@nxp.com>,
        Florian Westphal <fw@strlen.de>
Subject: RE: [net-next, v3, 07/10] net: sock: extend SO_TIMESTAMPING for PHC
 binding
Thread-Topic: [net-next, v3, 07/10] net: sock: extend SO_TIMESTAMPING for PHC
 binding
Thread-Index: AQHXYcn2QpHE4GsBzESAiAPEKHvcAasV0nCAgAoH1yA=
Date:   Tue, 22 Jun 2021 10:14:33 +0000
Message-ID: <DB7PR04MB5017165F5C590671CCCA137EF8099@DB7PR04MB5017.eurprd04.prod.outlook.com>
References: <20210615094517.48752-1-yangbo.lu@nxp.com>
 <20210615094517.48752-8-yangbo.lu@nxp.com>
 <66873ea1-a54b-8d2-5b68-ce474fb75e46@linux.intel.com>
In-Reply-To: <66873ea1-a54b-8d2-5b68-ce474fb75e46@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 11a79335-d120-4f37-efa5-08d93566886b
x-ms-traffictypediagnostic: DB7PR04MB5209:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB520969E56FFB0D00D53D771FF8099@DB7PR04MB5209.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X87cjIoxrG4NHZei0lQqhife6mxOr/QG5mf3c3sKOGMmwcX8G2RB7r2C6g1i+E4L4A7O/5lM5G0HHOo8vI6jy42mMnxjVJVceyFz6ElZlAU7C+r/04ODfzNLxFwCBIEwVIdsL6omE3ECJxWwOAZRr61kyudEtNGZHWbXVK/i9N15I4UdtxJ53Y+B6unwHTtisBGGfDUsYpTzTlL8Pi6h9BX6HLgv8sx/I/YsunYuAcOhrqlRAdTW487BDY7/TOY0LzKjBBQkFaPUCoOW98sqBJucrkXcHCGudg7Cvjkx3hJ7mXs/vyF3U8G5+OKEhaBoN9IjCVeFv1mlqtfOv0hkwZL/VvxiwNrfLwNBqpbuzk8Ir3LzUNUe5tS1/9XHnkiGNELS9F66ewnEUg2xj2FrFgRyfCtMmBQWSHlvsYNgF9ZX7gLXuDe5hhXVjZFdWLof9Eh/MDF4GY+UzLA8uUuwRdV7idofbsOlLdN+/3SAItWVMCpftdcczID7hC2QtKfiCHbtfSmds0GxfWxHMBx4ii5aLKr5seWBR8OK3c1HG47yo1f/c6sqovkGo1Qb/4zbUqxcBRTNDbZ/+lRnriUmBy/01oyX88KYdDMVx/ikhYA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5017.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(66446008)(76116006)(64756008)(66556008)(55016002)(66476007)(9686003)(5660300002)(86362001)(33656002)(66946007)(7696005)(8936002)(71200400001)(38100700002)(6506007)(53546011)(54906003)(2906002)(26005)(4326008)(122000001)(83380400001)(52536014)(478600001)(186003)(7416002)(6916009)(8676002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?a05WMktJTzIxaTMzdmVrV1c5d2s4U2lWMEZFK0ZnVGQrbktuaTgwb0xqaDRp?=
 =?gb2312?B?NVNnRURRZGpOWU9pbk51OTVITVlJTm5BTlIraTdjWWdTaE1XZmZJTisyYUp2?=
 =?gb2312?B?ampqRnpUalRXNEd1WE1WSGZncWtUMUpFSlRNeUdwOExORkxZOGNyZzFrVVU0?=
 =?gb2312?B?WUNXM2VMVnd4b1U5MDNMcnoxU2hsM2ZGSHZzS0R1RVEyc2JFdjBSMFZQaFlL?=
 =?gb2312?B?Zkw5WkhzVS8vQ1o3bzZvVWUzSWJaUUUwM0RTalh1WmpwZUJKNUpRNHdwclpK?=
 =?gb2312?B?aXlYdFowaFZQbVZ4UG53VHZMOXBia0R5VGZjWDh2WnJzSlJxTVNUVjJaSDl5?=
 =?gb2312?B?czZZTjNSNU9WVGl4NklrbGo0NlA4eG1KQUJhNDNmR1IwWTBFREVOcE0zTlhu?=
 =?gb2312?B?NjY3cnVzOHh4MG1kS29Ra1pJQU1OOUVxZDJzWm54Wkg5VWNGWi9uangvWlc0?=
 =?gb2312?B?RkFheE53M1p3YWZUWXk1amlNUHF1TGRUZFJya3phNk9IYXZkQUZBRnk2RTVF?=
 =?gb2312?B?UXU2WisyZFRGTzZnOGFHdXlFalptMlJ3V0FzcUF2S3kxbmJycE1nRDFtZnEx?=
 =?gb2312?B?RER5RzROU0VzejcycWZ0Q3hCV3k3bmZuRUtyZCs5SGJaV0g4SUE1VC9nd2N2?=
 =?gb2312?B?c0VjSE0yUzRkODM4YXYzalUzeDVkUEhGaytyOWhCUGxWVnZ2b21OMXEyYjBQ?=
 =?gb2312?B?d2NDSTFiVnBCTVc2TmRCUitXbVgzVFZmbWFmTU15Y1B4SU5BTzRMd1BWcTR0?=
 =?gb2312?B?djdOa0YrVGVnRjRrcS8zcU9iSVRwZkdFdzJScjFweEU0MHBMbzZqcUM1ZDZ2?=
 =?gb2312?B?Y3VLdWpZMHBpM3AyOHFLdXRVT2FQc283Lzd3Ykp4UVkxU2kyR2tIR2J1TTQy?=
 =?gb2312?B?cWZjc3hicUpuTzVUcHRuT1A2eWxwWmtNandFQ2UzNS8wODFrMWFZM3VyTmly?=
 =?gb2312?B?SGFZSW92KzBTMHBJMGVFNXlISXFuTUUrQ1lSMSs0Y25GY3VHMUF6a0RoVmlJ?=
 =?gb2312?B?ci9PL2NXZDBYa01DZTFmWU9WaGJaVEpnY2lHRXFPRXRjWEI1SzFYMm1YSXRi?=
 =?gb2312?B?L0xNbGRWMnRVMHk4NGpjakpPNG9aOUI4SFJ1Tmo5Y1dyV2J5S3JoVUNFOW1B?=
 =?gb2312?B?bVNkQVpTQ2gxRWc3ZnQxa1FRZ3RSSW1Rd3ZZN05EN2FkaHdOenV5SXI4U0k0?=
 =?gb2312?B?VkVFNFRMcXF2UTIvMGxpWVBKRmZhL1RGNGlUWDFnQVFscTJyVXZVbWFJUnc1?=
 =?gb2312?B?aTk4Um9PNGJ4eWZJSjR3QzQ2MGFFblhUOEJnQXlWeEdJRThSTHNVWktHcUNr?=
 =?gb2312?B?S1JsYWFOQ3dobnZyZW1kanBYSzIwSE9EVWJUTE9XV1pSeWZFZmJncTg3cjZa?=
 =?gb2312?B?ZEdlY1ZoNmtUblRhMllJWkk3MWxyV0pxZEVDL0hvUE1mcFRWMDFPWWg2Um9Q?=
 =?gb2312?B?M01RYzJFVkxGbmdEMW16MWg4emU2aitCdDFQV1B1eXVEMjhVODNTUXZjU2ov?=
 =?gb2312?B?bUFBUTdLNVhleXd5UEMxYXBHd0doRW12RG00cGk0ZGdzbGxiYTErTDN2blFo?=
 =?gb2312?B?V3lDN25ZeThCbEYyaDc4T0tUcklpamtjN1UwREFDbXdJMDJ3cUVZWm5qSWla?=
 =?gb2312?B?OUNuRzhoTElWaHJsMEgvektiNExWb0NZM1pROHlZTGJYUjNmSzYzWlpOc04v?=
 =?gb2312?B?TE1HY2Z3YTU5WVdmRkJoa3JUNXpkeUlKRzViQW0wbytUblRHTG5xK0J1ZnhW?=
 =?gb2312?Q?qmHjgp8bSGxD0ygMt9i9pKJC1yP9qAB96lU9Gor?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5017.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11a79335-d120-4f37-efa5-08d93566886b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2021 10:14:33.9748
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ASQ4ZDo46QgZuTzVEW3g/0WhPqM8/5Mogkso3fdISQXsGFKgbdLUPItnTkPZAvjANTYL97Vk6r22jv9zhE29jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5209
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWF0LA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hdCBNYXJ0
aW5lYXUgPG1hdGhldy5qLm1hcnRpbmVhdUBsaW51eC5pbnRlbC5jb20+DQo+IFNlbnQ6IDIwMjHE
6jbUwjE2yNUgOTowMQ0KPiBUbzogWS5iLiBMdSA8eWFuZ2JvLmx1QG54cC5jb20+DQo+IENjOiBu
ZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiBs
aW51eC1rc2VsZnRlc3RAdmdlci5rZXJuZWwub3JnOyBtcHRjcEBsaXN0cy5saW51eC5kZXY7IFJp
Y2hhcmQgQ29jaHJhbg0KPiA8cmljaGFyZGNvY2hyYW5AZ21haWwuY29tPjsgRGF2aWQgUyAuIE1p
bGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47DQo+IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5l
bC5vcmc+OyBNYXR0aGlldSBCYWVydHMNCj4gPG1hdHRoaWV1LmJhZXJ0c0B0ZXNzYXJlcy5uZXQ+
OyBTaHVhaCBLaGFuIDxzaHVhaEBrZXJuZWwub3JnPjsgTWljaGFsDQo+IEt1YmVjZWsgPG1rdWJl
Y2VrQHN1c2UuY3o+OyBGbG9yaWFuIEZhaW5lbGxpIDxmLmZhaW5lbGxpQGdtYWlsLmNvbT47DQo+
IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD47IFJ1aSBTb3VzYSA8cnVpLnNvdXNhQG54cC5j
b20+OyBTZWJhc3RpZW4NCj4gTGF2ZXplIDxzZWJhc3RpZW4ubGF2ZXplQG54cC5jb20+OyBGbG9y
aWFuIFdlc3RwaGFsIDxmd0BzdHJsZW4uZGU+DQo+IFN1YmplY3Q6IFJlOiBbbmV0LW5leHQsIHYz
LCAwNy8xMF0gbmV0OiBzb2NrOiBleHRlbmQgU09fVElNRVNUQU1QSU5HIGZvcg0KPiBQSEMgYmlu
ZGluZw0KPiANCj4gT24gVHVlLCAxNSBKdW4gMjAyMSwgWWFuZ2JvIEx1IHdyb3RlOg0KPiANCj4g
PiBTaW5jZSBQVFAgdmlydHVhbCBjbG9jayBzdXBwb3J0IGlzIGFkZGVkLCB0aGVyZSBjYW4gYmUg
c2V2ZXJhbCBQVFANCj4gPiB2aXJ0dWFsIGNsb2NrcyBiYXNlZCBvbiBvbmUgUFRQIHBoeXNpY2Fs
IGNsb2NrIGZvciB0aW1lc3RhbXBpbmcuDQo+ID4NCj4gPiBUaGlzIHBhdGNoIGlzIHRvIGV4dGVu
ZCBTT19USU1FU1RBTVBJTkcgQVBJIHRvIHN1cHBvcnQgUEhDIChQVFANCj4gPiBIYXJkd2FyZSBD
bG9jaykgYmluZGluZyBieSBhZGRpbmcgYSBuZXcgZmxhZw0KPiA+IFNPRl9USU1FU1RBTVBJTkdf
QklORF9QSEMuIFdoZW4gUFRQIHZpcnR1YWwgY2xvY2tzIGFyZSBpbiB1c2UsIHVzZXINCj4gPiBz
cGFjZSBjYW4gY29uZmlndXJlIHRvIGJpbmQgb25lIGZvciB0aW1lc3RhbXBpbmcsIGJ1dCBQVFAg
cGh5c2ljYWwNCj4gPiBjbG9jayBpcyBub3Qgc3VwcG9ydGVkIGFuZCBub3QgbmVlZGVkIHRvIGJp
bmQuDQo+ID4NCj4gPiBUaGlzIHBhdGNoIGlzIHByZXBhcmF0aW9uIGZvciB0aW1lc3RhbXAgY29u
dmVyc2lvbiBmcm9tIHJhdyB0aW1lc3RhbXANCj4gPiB0byBhIHNwZWNpZmljIFBUUCB2aXJ0dWFs
IGNsb2NrIHRpbWUgaW4gY29yZSBuZXQuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBZYW5nYm8g
THUgPHlhbmdiby5sdUBueHAuY29tPg0KPiA+IC0tLQ0KPiA+IENoYW5nZXMgZm9yIHYzOg0KPiA+
IAktIEFkZGVkIHRoaXMgcGF0Y2guDQo+ID4gLS0tDQo+ID4gaW5jbHVkZS9uZXQvc29jay5oICAg
ICAgICAgICAgICB8ICA4ICsrKy0NCj4gPiBpbmNsdWRlL3VhcGkvbGludXgvbmV0X3RzdGFtcC5o
IHwgMTcgKysrKysrKystDQo+ID4gbmV0L2NvcmUvc29jay5jICAgICAgICAgICAgICAgICB8IDY1
DQo+ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLQ0KPiA+IG5ldC9ldGh0b29sL2Nv
bW1vbi5jICAgICAgICAgICAgfCAgMSArDQo+ID4gbmV0L21wdGNwL3NvY2tvcHQuYyAgICAgICAg
ICAgICB8IDEwICsrKy0tDQo+ID4gNSBmaWxlcyBjaGFuZ2VkLCA5MSBpbnNlcnRpb25zKCspLCAx
MCBkZWxldGlvbnMoLSkNCj4gPg0KWy4uLl0NCj4gPiBAQCAtMTY2LDcgKzE2OSw3IEBAIHN0YXRp
YyBpbnQNCj4gbXB0Y3Bfc2V0c29ja29wdF9zb2xfc29ja2V0X3RzdGFtcChzdHJ1Y3QgbXB0Y3Bf
c29jayAqbXNrLCBpbnQgb3B0bmFtDQo+ID4gCQkJYnJlYWs7DQo+ID4gCQljYXNlIFNPX1RJTUVT
VEFNUElOR19ORVc6DQo+ID4gCQljYXNlIFNPX1RJTUVTVEFNUElOR19PTEQ6DQo+ID4gLQkJCXNv
Y2tfc2V0X3RpbWVzdGFtcGluZyhzaywgb3B0bmFtZSwgdmFsKTsNCj4gPiArCQkJc29ja19zZXRf
dGltZXN0YW1waW5nKHNrLCBvcHRuYW1lLCB2YWwsIG9wdHZhbCwgb3B0bGVuKTsNCj4gDQo+IFRo
aXMgaXMgaW5zaWRlIGEgbG9vcCwgc28gaW4gY2FzZXMgd2hlcmUgb3B0bGVuID09IHNpemVvZihz
dHJ1Y3QNCj4gc29fdGltZXN0YW1waW5nKSB0aGlzIHdpbGwgZW5kIHVwIHJlLWNvcHlpbmcgdGhl
IHN0cnVjdHVyZSBmcm9tIHVzZXJzcGFjZQ0KPiBvbmUgZXh0cmEgdGltZSBmb3IgZWFjaCBNUFRD
UCBzdWJmbG93OiBvbmNlIGZvciB0aGUgTVBUQ1Agc29ja2V0LCBwbHVzIG9uZQ0KPiB0aW1lIGZv
ciBlYWNoIG9mIHRoZSBUQ1Agc3ViZmxvd3MgdGhhdCBhcmUgZ3JvdXBlZCB1bmRlciB0aGlzIE1Q
VENQDQo+IGNvbm5lY3Rpb24uDQo+IA0KPiBHaXZlbiB0aGF0IHRoZSBleHRyYSBjb3BpZXMgb25s
eSBoYXBwZW4gd2hlbiB1c2luZyB0aGUgZXh0ZW5kZWQgYmluZF9waGMNCj4gb3B0aW9uLCBpdCdz
IG5vdCBhIGh1Z2UgY29zdC4gQnV0IHNvY2tfc2V0X3RpbWVzdGFtcGluZygpIHdhcyB3cml0dGVu
IHRvDQo+IGF2b2lkIHRoZSBleHRyYSBjb3BpZXMgZm9yICdpbnQnIHNpemVkIG9wdGlvbnMsIGFu
ZCBpZiB0aGF0IHdhcyB3b3J0aCB0aGUNCj4gZWZmb3J0IHRoZW4gdGhlIGxhcmdlciBzb190aW1l
c3RhbXBpbmcgc3RydWN0dXJlIGNvdWxkIGJlIGNvcGllZCAob25jZSkNCj4gYmVmb3JlIHRoZSBz
b2NrX3NldF90aW1lc3RhbXBpbmcoKSBjYWxsIGFuZCBwYXNzZWQgaW4uDQoNCkkgc2VlIG5vdy4u
Lg0KTGV0IG1lIHBhc3Mgc29fdGltZXN0YW1waW5nIHN0cnVjdHVyZSBpbiB0byBhdm9pZCByZS1j
b3B5aW5nIGZyb20gdXNlcnNwYWNlLg0KDQo+IA0KPiA+IAkJCWJyZWFrOw0KPiA+IAkJfQ0KPiA+
DQo+ID4gQEAgLTIwNyw3ICsyMTAsOCBAQCBzdGF0aWMgaW50IG1wdGNwX3NldHNvY2tvcHRfc29s
X3NvY2tldF9pbnQoc3RydWN0DQo+IG1wdGNwX3NvY2sgKm1zaywgaW50IG9wdG5hbWUsDQo+ID4g
CWNhc2UgU09fVElNRVNUQU1QTlNfTkVXOg0KPiA+IAljYXNlIFNPX1RJTUVTVEFNUElOR19PTEQ6
DQo+ID4gCWNhc2UgU09fVElNRVNUQU1QSU5HX05FVzoNCj4gPiAtCQlyZXR1cm4gbXB0Y3Bfc2V0
c29ja29wdF9zb2xfc29ja2V0X3RzdGFtcChtc2ssIG9wdG5hbWUsIHZhbCk7DQo+ID4gKwkJcmV0
dXJuIG1wdGNwX3NldHNvY2tvcHRfc29sX3NvY2tldF90c3RhbXAobXNrLCBvcHRuYW1lLCB2YWws
DQo+ID4gKwkJCQkJCQkgIG9wdHZhbCwgb3B0bGVuKTsNCj4gDQo+IFJhdGhlciB0aGFuIG1vZGlm
eWluZyBtcHRjcF9zZXRzb2Nrb3B0X3NvbF9zb2NrZXRfaW50KCksIEkgc3VnZ2VzdCBhZGRpbmcN
Cj4gYSBtcHRjcF9zZXRzb2Nrb3B0X3NvbF9zb2NrZXRfdGltZXN0YW1waW5nKCkgaGVscGVyIGZ1
bmN0aW9uIHRoYXQgY2FuDQo+IGhhbmRsZSB0aGUgc3BlY2lhbCBjb3B5aW5nIGZvciBzb190aW1l
c3RhbXBpbmcuDQoNClRoYW5rIHlvdS4gTGV0IG1lIGRvIHRoaXMgaW4gbmV4dCB2ZXJzaW9uLg0K
DQo+IA0KPiA+IAl9DQo+ID4NCj4gPiAJcmV0dXJuIC1FTk9QUk9UT09QVDsNCj4gPiAtLQ0KPiA+
IDIuMjUuMQ0KPiA+DQo+ID4NCj4gDQo+IC0tDQo+IE1hdCBNYXJ0aW5lYXUNCj4gSW50ZWwNCg==
