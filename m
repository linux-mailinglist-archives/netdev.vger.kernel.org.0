Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5228530D768
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 11:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbhBCKZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 05:25:03 -0500
Received: from mail-eopbgr70103.outbound.protection.outlook.com ([40.107.7.103]:27485
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233781AbhBCKYz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 05:24:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CWUaa3IGkxrbYM37+qepv+SgC4hWJN8WMUbyFngtZI1+IVk1YeocyxPyZLMJ3+0L6KCP7HA2l39oShPfeTmEtQQREqFpDhMp3NV32obDVXYf2ZnNElAO4SHkLt8McAvWzhEX5YFrfZU/pB0D5sObiKKIs8qVvLHlB8at2hyOYsyjLGSnrfQLvmKwEqKQYQ4Ohs69EvwW4tFR59ZPRpk7HnGO+1rrdhPjRfbkWiy6qx9wao8a5gr+zfgjaRcxPFlOCCLwScnYlbBLgnEkfSu1oc8UrTeiBkUIVCqvS7A5kEqd2OJJcWSy4CZGexYUBW8DXbI0qQ0Ip7EAQ/iClv41SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wS5M3sxTbfRXmkjS6BihLCD6pg4Pa0FnmZpRg+jobcw=;
 b=IMEqYanN+JQJUmsaASeipEtkD4OSat52u8MlC7WmHU7U88g8H9D23X6IjYO2xhagKIphz6TLzen2ymi0jD9DI7jrbXqVhU3GorqjSACSYRw009UCoZ88ER0zBFnTPyqpZlv6R224eT0f7R0EKV9baCEP1QnQiPrUMyPdLQJuRJTb3tUQIdTiBsejBSnCZQUSDp9xhHMxjdj7+OTYhxCnUn4Sg2LKnGCgt4NIK9dA//bBQHmTjULpsxJnJ1sHvhtYg4NOhVuWYC9XqzjabMgxpHZX7lgCpF+ZjN/V8WpDIJsSYIkpNhpdZHOVbZaivkSX2Lu4VwRIuYHpzHPWKguHpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wS5M3sxTbfRXmkjS6BihLCD6pg4Pa0FnmZpRg+jobcw=;
 b=mM2nDy+b6qo5WALqplW8XN/yJqHP59yg17bcDS/L6iJOaNy8uuydfa4fSRwEaWvFzjWsBTfPDWUlH48qZHSa9asj19HPp6MK3Pny0DURnoSagbXhKnHxP3eXfk12S3xrGUVABCvKXGWWr2K0aXpMQsrhI7HGSQwKtE2gzbum8CE=
Received: from VE1PR05MB7278.eurprd05.prod.outlook.com (2603:10a6:800:1a5::23)
 by VI1PR0502MB3805.eurprd05.prod.outlook.com (2603:10a6:803:a::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.24; Wed, 3 Feb
 2021 10:24:04 +0000
Received: from VE1PR05MB7278.eurprd05.prod.outlook.com
 ([fe80::3d79:bea1:a0f8:dacd]) by VE1PR05MB7278.eurprd05.prod.outlook.com
 ([fe80::3d79:bea1:a0f8:dacd%7]) with mapi id 15.20.3805.026; Wed, 3 Feb 2021
 10:24:04 +0000
From:   Philippe Schenker <philippe.schenker@toradex.com>
To:     "o.rempel@pengutronix.de" <o.rempel@pengutronix.de>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "festevam@gmail.com" <festevam@gmail.com>,
        "linux-imx@nxp.com" <linux-imx@nxp.com>,
        "david@protonic.nl" <david@protonic.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 1/7] ARM i.MX6q: remove PHY fixup for KSZ9031
Thread-Topic: [PATCH v1 1/7] ARM i.MX6q: remove PHY fixup for KSZ9031
Thread-Index: AQHW+g4fK+2cLe5nKk6oG5/C7reDeqpGOUgA
Date:   Wed, 3 Feb 2021 10:24:04 +0000
Message-ID: <6688cc451a9307d9210976a9c422c70f6089f526.camel@toradex.com>
References: <20210203091857.16936-1-o.rempel@pengutronix.de>
         <20210203091857.16936-2-o.rempel@pengutronix.de>
In-Reply-To: <20210203091857.16936-2-o.rempel@pengutronix.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.3 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=toradex.com;
x-originating-ip: [51.154.7.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f59dfa76-0822-440c-9e6a-08d8c82dd500
x-ms-traffictypediagnostic: VI1PR0502MB3805:
x-microsoft-antispam-prvs: <VI1PR0502MB38050761713FC4C784B948FBF4B49@VI1PR0502MB3805.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l1yEvnQFnM0to+4PB7aDxyvrUbjR2X0YRehhJHKhVehUk3e2JCXUzc3ZlAGiNRWB2RfSVcfjM4uuK8EeShM0tAqTPAUV/dYlCVpxDAWS3kDrNreNlHhSv/vrIBjtYb1uIXhb/EDoHT0H7Fj6OU9LxxPfVCtMIHkxVEsCNyIZDxzpNWFd3mG/ohPHH0PKgeHp1VzBk73JkO/2HWDyGnNGdyj9D05yda21dLBrnpeZ1t/QZttbdmnW4QO1N6EDkPgFZ1cXFwP6DM/mJjaIHclT+TNecAI1j3LTqF8bSzCul01x0MN2F4Xs+hG3SL0yZakjbdeYaGs33ns5XLG5QpL2O9kD3AjrZxNVyiYVrSqlh7loNwOcRz58+MiqAtBG1HzTQlDMzAZo6DG34X7g61zeKPFpattFHrYcPAAyoq72fOEtirhD6vHTaWWy1kwQIUDvapshTnZaaIggBsh4V8honiHMkTnI/uDR4vEeqJdvikBTaGuY8A3kzg57wLj87HfYU7RNwZbVZpO6qSzbR5/Ylw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR05MB7278.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(6506007)(76116006)(66556008)(6512007)(4326008)(91956017)(66946007)(66446008)(7416002)(26005)(186003)(64756008)(2906002)(2616005)(5660300002)(44832011)(83380400001)(110136005)(71200400001)(6486002)(86362001)(8676002)(498600001)(54906003)(8936002)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?L3IzN2k4cTU2YWNzRG9uYzF2UWtUbGh1RXkybE1UcjVybzBpZmVxZU92d2U2?=
 =?utf-8?B?Vmx1b0FSc2U0OWNtOXFPSWRIZkRlQzhOSVJpYlpBMGw0Qm83aXdXL2hCTVZ2?=
 =?utf-8?B?NjhJV2w2dE0xZC9ZdjNIUDJyOWthbFRHdmxReWhFbktnOWFuRDM3THdBMG9m?=
 =?utf-8?B?YksvUHlJOVpCcTJHZ2xVZ3E1YS95T3Q2VzRYWGQ5c1RuZFFlN1dHWnZXQ3VV?=
 =?utf-8?B?bkIxYVdWTDJ1dXdSSlI4am40MFhCblAvTHl0VC8zaTR0blpuZXc0eDVIbEx6?=
 =?utf-8?B?UDI1Njl2bklOVXdMTjA0dTROZFV3N1c3ZVF1emt6cU5DM3BKRDVoYmgrQm9X?=
 =?utf-8?B?ZWZMb2RoekNPbnRqdU9UblhaQVlTU1FuUHFlZzRTR3h0MHp0TXBFbG1OOXdt?=
 =?utf-8?B?Qnl0a1FNTmVtNEFpQm8zK1EvRGg5TVlXNWs1Z1NxTHpQTW95NzNtNS9TeXVz?=
 =?utf-8?B?MXpGQlc0SHBZdXJmS0N1N05TSmNxZCtLU1prdEJSSW5aR1p5Mnl3TG00M29i?=
 =?utf-8?B?ZlNMUDh1bjgxZUE1aCtCNmc5VnBJbURGRHZrOVFHNzdGZzhoU3hVMTBZQ3pk?=
 =?utf-8?B?UVJNSHRyZkU3aUFJRVU4eWFYci9FcmkranpqbUVXOTBTckZmK2p4Y3lEUDJ1?=
 =?utf-8?B?L2krb0tYa1Y2bzhtT21NTUtMd1dEWW5kSHN4UjltbUxnaHphY0hESXAxbWRJ?=
 =?utf-8?B?YmNhVkUxdDVqTThQbDRtbmpJa1lUaVpyNGM4QjM2Q1RlVkVuSS9KT1J0T09v?=
 =?utf-8?B?Sno4OFdZSnVNeklXTTFDeHRYRE43V212ZnhEUmYwZm9vNEhiWXRWaG1aUFRR?=
 =?utf-8?B?MS9laVhvWlptc1pvM0NTd0luT3B4enVHWVNDYUFHWjVURGpOd1BRRXJwYjRP?=
 =?utf-8?B?VkgyeFk2ci9uQ0NaaXlUcXB3WkFOQ09pdkV0dHBzU3ZsM3VlNHJaRXcwdDQ0?=
 =?utf-8?B?OTBiUThGY0JUUmt1VWloaERnZklYdVFWNWRYMFA4ZWNsZXo5dnVPL0pGaW92?=
 =?utf-8?B?STVpd0grRGZpanJxWkp4Y0k1cG9hZkpNTmxvQUNVQkxtU2MyMEs5ckMwckIy?=
 =?utf-8?B?bGNITjA4Z0p3dG9YdEpndzlJQUZiYlFpakhadUY3VEdIbkdpMFJHMVF1YXNj?=
 =?utf-8?B?RUJiOUN0MlVhUFVDNGNsNUxMbEttaHlaY1B5TUtMcmczU1FwZ3p1eTkwZlJS?=
 =?utf-8?B?bUlXWldnekVsaG40Kzk3QWFDekN0bTRpcklFanlrdmZGWlhSN0FoOXFYTTlB?=
 =?utf-8?B?WXFvYXBHRnZ1cmFMTVNyUDZXSm56YVdSN0NZd2pNMmtoMjJ5bVhsanhIWWky?=
 =?utf-8?B?aEdTZ2Z0MU84RHNkZVhGTklsejlNdmtqK3VCWlV4V0REU0EvcFF1bERhcmts?=
 =?utf-8?B?VVNNdU9tbnY5dlI1THI5UXF2RHIxdHRGbUxmMCtnWW4yVi9PU1QxUkVQeFA2?=
 =?utf-8?B?MzVOT2puL1RuQXpMUzN2WHBJNHNyODl1cmhRUEdDdTVJK1VPTWZDcDZlQWpJ?=
 =?utf-8?B?WFYyU25wMzhNZzlxWXpCbHA5RFNZRjVMMWtjcUJUQUpSNWRPVEJkeEV4SFVB?=
 =?utf-8?B?dGpFMVJMTzhPTkhUenhQckpFWjZVeEFGcDZSa05sRGpZZjEzNUJ2MkgycW96?=
 =?utf-8?B?bW1CUHJsczFLUTFBemtCQmRKMXQ5VFlIN3R4OHBYTnlaeHgrbGhldkx5TktX?=
 =?utf-8?B?bzc1TGpSenhidENMMG5EaGFZem9WUldlMmtyb2RqNEU5LzJzNW9zQk52UVgy?=
 =?utf-8?Q?BAjrzZ+iLq0w7CIwP8jXM9APCT+JEozBYNme7KU?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A04155CA3D86E6489ADFD32FED4DF7B9@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VE1PR05MB7278.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f59dfa76-0822-440c-9e6a-08d8c82dd500
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2021 10:24:04.4869
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NH6hvqERgPamMwOARZVp22tbHoYu9htgOCrEcuM8DHK0VQ6dtdbndc24DJbgFhUlFcOFD+EGY/1Y4Q04raSMXzgSpxC8eRWjZtZruyDV8YA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB3805
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTAyLTAzIGF0IDEwOjE4ICswMTAwLCBPbGVrc2lqIFJlbXBlbCB3cm90ZToN
Cj4gU3RhcnRpbmcgd2l0aDoNCj4gDQo+IMKgwqDCoCBiY2YzNDQwYzZkZDcgKCJuZXQ6IHBoeTog
bWljcmVsOiBhZGQgcGh5LW1vZGUgc3VwcG9ydCBmb3IgdGhlDQo+IEtTWjkwMzEgUEhZIikNCj4g
DQo+IHRoZSBtaWNyZWwgcGh5IGRyaXZlciBzdGFydGVkIHJlc3BlY3RpbmcgcGh5LW1vZGUgZm9y
IHRoZSBLU1o5MDMxIFBIWS4NCj4gQXQgbGVhc3Qgd2l0aCBrZXJuZWwgdjUuOCBjb25maWd1cmF0
aW9uIHByb3ZpZGVkIGJ5IHRoaXMgZml4dXAgd2FzDQo+IG92ZXJ3cml0dGVuIGJ5IHRoZSBtaWNy
ZWwgZHJpdmVyLg0KPiANCj4gVGhpcyBmaXh1cCB3YXMgcHJvdmlkaW5nIGZvbGxvd2luZyBjb25m
aWd1cmF0aW9uOg0KPiANCj4gUlggcGF0aDogMi41OG5zIGRlbGF5DQo+IMKgwqDCoCByeCAtMC40
MiAobGVmdCBzaGlmdCkgKyByeF9jbGvCoCArMC45Nm5zIChyaWdodCBzaGlmdCkgPQ0KPiDCoMKg
wqDCoMKgwqDCoCAxLDM4ICsgMSwyIGludGVybmFsIFJYIGRlbGF5ID0gMi41OG5zDQo+IFRYIHBh
dGg6IDAuOTZucyBkZWxheQ0KPiDCoMKgwqAgdHggKG5vIGRlbGF5KSArIHR4X2NsayAwLjk2bnMg
KHJpZ2h0IHNoaWZ0KSA9IDAuOTZucw0KPiANCj4gVGhpcyBjb25maWd1cmF0aW9uIGlzIG91dHNp
ZGUgb2YgdGhlIHJlY29tbWVuZGVkIFJHTUlJIGNsb2NrIHNrZXcNCj4gZGVsYXlzDQo+IGFuZCBh
Ym91dCBpbiB0aGUgbWlkZGxlIG9mOiByZ21paS1pZHJ4IGFuZCByZ21paS1pZA0KPiANCj4gU2lu
Y2UgbW9zdCBlbWJlZGRlZCBzeXN0ZW1zIGRvIG5vdCBoYXZlIGVub3VnaCBwbGFjZSB0byBpbnRy
b2R1Y2UNCj4gc2lnbmlmaWNhbnQgY2xvY2sgc2tldywgcmdtaWktaWQgaXMgdGhlIHdheSB0byBn
by4NCj4gDQo+IEluIGNhc2UgdGhpcyBwYXRjaCBicmVha3MgbmV0d29yayBmdW5jdGlvbmFsaXR5
IG9uIHlvdXIgc3lzdGVtLCBidWlsZA0KPiBrZXJuZWwgd2l0aCBlbmFibGVkIE1JQ1JFTF9QSFku
IElmIGl0IGlzIHN0aWxsIG5vdCB3b3JraW5nIHRoZW4gdHJ5DQo+IGZvbGxvd2luZyBkZXZpY2Ug
dHJlZSBvcHRpb25zOg0KPiAxLiBTZXQgKG9yIGNoYW5nZSkgcGh5LW1vZGUgaW4gRFQgdG86DQo+
IMKgwqAgcGh5LW1vZGUgPSAicmdtaWktaWQiOw0KPiDCoMKgIFRoaXMgYWN0aXZlcyBpbnRlcm5h
bCBkZWxheSBmb3IgYm90aCBSWCBhbmQgVFguDQo+IDEuIFNldCAob3IgY2hhbmdlKSBwaHktbW9k
ZSBpbiBEVCB0bzoNCj4gwqDCoCBwaHktbW9kZSA9ICJyZ21paS1pZHJ4IjsNCj4gwqDCoCBUaGlz
IGFjdGl2ZXMgaW50ZXJuYWwgZGVsYXkgZm9yIFJYIG9ubHkuDQo+IDMuIFVzZSBmb2xsb3dpbmcg
RFQgcHJvcGVydGllczoNCj4gwqDCoCBwaHktbW9kZSA9ICJyZ21paSI7DQo+IMKgwqAgdHhlbi1z
a2V3LXBzZWMgPSA8MD47DQo+IMKgwqAgcnhkdi1za2V3LXBzZWMgPSA8MD47DQo+IMKgwqAgcnhk
MC1za2V3LXBzZWMgPSA8MD47DQo+IMKgwqAgcnhkMS1za2V3LXBzZWMgPSA8MD47DQo+IMKgwqAg
cnhkMi1za2V3LXBzZWMgPSA8MD47DQo+IMKgwqAgcnhkMy1za2V3LXBzZWMgPSA8MD47DQo+IMKg
wqAgcnhjLXNrZXctcHNlYyA9IDwxODYwPjsNCj4gwqDCoCB0eGMtc2tldy1wc2VjID0gPDE4NjA+
Ow0KPiDCoMKgIFRoaXMgYWN0aXZhdGVzIHRoZSBpbnRlcm5hbCBkZWxheXMgZm9yIFJYIGFuZCBU
WCwgd2l0aCB0aGUgdmFsdWUgYXMNCj4gwqDCoCB0aGUgZml4dXAgdGhhdCBpcyByZW1vdmVkIGlu
IHRoaXMgcGF0Y2guDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBPbGVrc2lqIFJlbXBlbCA8by5yZW1w
ZWxAcGVuZ3V0cm9uaXguZGU+DQoNCkZvciBUb3JhZGV4IEJvYXJkczoNCg0KQWNrZWQtYnk6IFBo
aWxpcHBlIFNjaGVua2VyIDxwaGlsaXBwZS5zY2hlbmtlckB0b3JhZGV4LmNvbT4NCg0KPiAtLS0N
Cj4gwqBhcmNoL2FybS9ib290L2R0cy9pbXg2cS1kbW8tZWRtcW14Ni5kdHMgfMKgIDIgKy0NCj4g
wqBhcmNoL2FybS9tYWNoLWlteC9tYWNoLWlteDZxLmPCoMKgwqDCoMKgwqDCoMKgwqAgfCAyMyAt
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiDCoDIgZmlsZXMgY2hhbmdlZCwgMSBpbnNlcnRpb24o
KyksIDI0IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtL2Jvb3QvZHRz
L2lteDZxLWRtby1lZG1xbXg2LmR0cw0KPiBiL2FyY2gvYXJtL2Jvb3QvZHRzL2lteDZxLWRtby1l
ZG1xbXg2LmR0cw0KPiBpbmRleCBmYTIzMDdkOGNlODYuLmM3MTNhYzAzYjNiOSAxMDA2NDQNCj4g
LS0tIGEvYXJjaC9hcm0vYm9vdC9kdHMvaW14NnEtZG1vLWVkbXFteDYuZHRzDQo+ICsrKyBiL2Fy
Y2gvYXJtL2Jvb3QvZHRzL2lteDZxLWRtby1lZG1xbXg2LmR0cw0KPiBAQCAtMTEyLDcgKzExMiw3
IEBAIGZsYXNoOiBtMjVwODBAMCB7DQo+IMKgJmZlYyB7DQo+IMKgwqDCoMKgwqDCoMKgwqBwaW5j
dHJsLW5hbWVzID0gImRlZmF1bHQiOw0KPiDCoMKgwqDCoMKgwqDCoMKgcGluY3RybC0wID0gPCZw
aW5jdHJsX2VuZXQ+Ow0KPiAtwqDCoMKgwqDCoMKgwqBwaHktbW9kZSA9ICJyZ21paSI7DQo+ICvC
oMKgwqDCoMKgwqDCoHBoeS1tb2RlID0gInJnbWlpLWlkIjsNCj4gwqDCoMKgwqDCoMKgwqDCoHBo
eS1yZXNldC1ncGlvcyA9IDwmZ3BpbzEgMjUgR1BJT19BQ1RJVkVfTE9XPjsNCj4gwqDCoMKgwqDC
oMKgwqDCoHBoeS1zdXBwbHkgPSA8JnZnZW4yXzF2Ml9ldGg+Ow0KPiDCoMKgwqDCoMKgwqDCoMKg
c3RhdHVzID0gIm9rYXkiOw0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm0vbWFjaC1pbXgvbWFjaC1p
bXg2cS5jIGIvYXJjaC9hcm0vbWFjaC1pbXgvbWFjaC0NCj4gaW14NnEuYw0KPiBpbmRleCA3MDM5
OThlYmI1MmUuLjc4MjA1ZjkwZGEyNyAxMDA2NDQNCj4gLS0tIGEvYXJjaC9hcm0vbWFjaC1pbXgv
bWFjaC1pbXg2cS5jDQo+ICsrKyBiL2FyY2gvYXJtL21hY2gtaW14L21hY2gtaW14NnEuYw0KPiBA
QCAtNDAsMjcgKzQwLDYgQEAgc3RhdGljIGludCBrc3o5MDIxcm5fcGh5X2ZpeHVwKHN0cnVjdCBw
aHlfZGV2aWNlDQo+ICpwaHlkZXYpDQo+IMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gMDsNCj4gwqB9
DQo+IMKgDQo+IC1zdGF0aWMgdm9pZCBtbWRfd3JpdGVfcmVnKHN0cnVjdCBwaHlfZGV2aWNlICpk
ZXYsIGludCBkZXZpY2UsIGludA0KPiByZWcsIGludCB2YWwpDQo+IC17DQo+IC3CoMKgwqDCoMKg
wqDCoHBoeV93cml0ZShkZXYsIDB4MGQsIGRldmljZSk7DQo+IC3CoMKgwqDCoMKgwqDCoHBoeV93
cml0ZShkZXYsIDB4MGUsIHJlZyk7DQo+IC3CoMKgwqDCoMKgwqDCoHBoeV93cml0ZShkZXYsIDB4
MGQsICgxIDw8IDE0KSB8IGRldmljZSk7DQo+IC3CoMKgwqDCoMKgwqDCoHBoeV93cml0ZShkZXYs
IDB4MGUsIHZhbCk7DQo+IC19DQo+IC0NCj4gLXN0YXRpYyBpbnQga3N6OTAzMXJuX3BoeV9maXh1
cChzdHJ1Y3QgcGh5X2RldmljZSAqZGV2KQ0KPiAtew0KPiAtwqDCoMKgwqDCoMKgwqAvKg0KPiAt
wqDCoMKgwqDCoMKgwqAgKiBtaW4gcnggZGF0YSBkZWxheSwgbWF4IHJ4L3R4IGNsb2NrIGRlbGF5
LA0KPiAtwqDCoMKgwqDCoMKgwqAgKiBtaW4gcngvdHggY29udHJvbCBkZWxheQ0KPiAtwqDCoMKg
wqDCoMKgwqAgKi8NCj4gLcKgwqDCoMKgwqDCoMKgbW1kX3dyaXRlX3JlZyhkZXYsIDIsIDQsIDAp
Ow0KPiAtwqDCoMKgwqDCoMKgwqBtbWRfd3JpdGVfcmVnKGRldiwgMiwgNSwgMCk7DQo+IC3CoMKg
wqDCoMKgwqDCoG1tZF93cml0ZV9yZWcoZGV2LCAyLCA4LCAweDAwM2ZmKTsNCj4gLQ0KPiAtwqDC
oMKgwqDCoMKgwqByZXR1cm4gMDsNCj4gLX0NCj4gLQ0KPiDCoC8qDQo+IMKgICogZml4dXAgZm9y
IFBMWCBQRVg4OTA5IGJyaWRnZSB0byBjb25maWd1cmUgR1BJTzEtNyBhcyBvdXRwdXQgSGlnaA0K
PiDCoCAqIGFzIHRoZXkgYXJlIHVzZWQgZm9yIHNsb3RzMS03IFBFUlNUIw0KPiBAQCAtMTUyLDgg
KzEzMSw2IEBAIHN0YXRpYyB2b2lkIF9faW5pdCBpbXg2cV9lbmV0X3BoeV9pbml0KHZvaWQpDQo+
IMKgwqDCoMKgwqDCoMKgwqBpZiAoSVNfQlVJTFRJTihDT05GSUdfUEhZTElCKSkgew0KPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHBoeV9yZWdpc3Rlcl9maXh1cF9mb3JfdWlkKFBI
WV9JRF9LU1o5MDIxLA0KPiBNSUNSRUxfUEhZX0lEX01BU0ssDQo+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBrc3o5MDIxcm5f
cGh5X2ZpeHVwKTsNCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHBoeV9yZWdpc3Rl
cl9maXh1cF9mb3JfdWlkKFBIWV9JRF9LU1o5MDMxLA0KPiBNSUNSRUxfUEhZX0lEX01BU0ssDQo+
IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoGtzejkwMzFybl9waHlfZml4dXApOw0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoHBoeV9yZWdpc3Rlcl9maXh1cF9mb3JfdWlkKFBIWV9JRF9BUjgwMzEsIDB4ZmZmZmZm
ZWYsDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBhcjgwMzFfcGh5X2ZpeHVwKTsNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqBwaHlfcmVnaXN0ZXJfZml4dXBfZm9yX3VpZChQSFlfSURfQVI4MDM1LCAweGZm
ZmZmZmVmLA0KDQo=
