Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F37C36BE99
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 06:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbhD0Et3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 00:49:29 -0400
Received: from mail-db8eur05on2057.outbound.protection.outlook.com ([40.107.20.57]:43457
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229587AbhD0Et1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 00:49:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IxEE0EwAea7Obm6CU3Z2T5uoMHmXDrBWT9d6KLusrdmcx0iWwNM1cjW484J1XSeHVAEqop7g16QwYDe5UJ91EnWhhGx/L8o6siIH/PJRwtoKL8TMnNh/bSkENkGuTslGnfU/uWlGbmq0koyOb9DEFFwavseMP5K51Rcr3DtCxYVdHVOqV8N6rWEagFbRJcW9nvXdohTbNtm+g/ShSmXKKjbqcxpDNRqo3QAq8a0LdZJYCsvTmtaF3orperkY65hDNtefqa4bwOwZ+xxxXb7Mp1SdQ4OdtNxdcFOMAy8NBv+tA1OPrjeJ/GpwTm6rdGqWtjwojMcbLASoZeLvn9ugdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fPDTphZiR2UhhjR/DLtxKU44TBfuTxoA7Lrga7sVmbM=;
 b=UEF53GRbfS7b1bwHfVcTQlQQ/ACgBaFs/Nbf0OhqZCNUPl7rvJlP8Z7al+H4jxh7Dc4eH1F8M7xOA+u0e4OYkPMt/wy3hsNYdYQyphGDYKJIQ4zKMFZkZQezOrSWSJJzPDxadwUuXRzOMTRceLRrBleAp6Sd+C/dlFZl2Dk/C/7kNR2+29ksNs4DJ477SdQnxQdfe+z9BM9CH7sD4qqwDWnG2/+nYQVs5wXKzcw38I642O3RnMcZXkVI77Bivuwg9w5VuIie88wVGa76WhQ2hn9iVxnoJhMkmmAkQd+FuyUkj6uKcKjg7Njpd6NMopW+9+Ykbo75QWezgWK+BaQ+FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fPDTphZiR2UhhjR/DLtxKU44TBfuTxoA7Lrga7sVmbM=;
 b=nIkOhNWGSME3E53/r3hP1s9DohSjLGZjMzX+/2itYwHz8DHt1rHfbRWzTEkYOTuDDzbQItcSYK6SeBMDzUfJQrRPPwVtir41nBm83FAJYlLboH1IAVN75ETKkcGM/WiPjZHHUZuXp6Cuyvh3mFtvaqLPsI8pQCaPaxYpW/E60F8=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7240.eurprd04.prod.outlook.com (2603:10a6:10:1af::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Tue, 27 Apr
 2021 04:48:43 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%7]) with mapi id 15.20.4065.027; Tue, 27 Apr 2021
 04:48:42 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
CC:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: RE: [PATCH net-next v3 0/6] provide generic net selftest support
Thread-Topic: [PATCH net-next v3 0/6] provide generic net selftest support
Thread-Index: AQHXNRwagqYg3yRB0ku+UvQ/Kt5swqrBcaDggAAY44CABi40MA==
Date:   Tue, 27 Apr 2021 04:48:42 +0000
Message-ID: <DB8PR04MB6795479FBF086751D16080E2E6419@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210419130106.6707-1-o.rempel@pengutronix.de>
 <DB8PR04MB67951B9C6AB1620E807205F2E6459@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210423043729.tup7nntmmyv6vurm@pengutronix.de>
In-Reply-To: <20210423043729.tup7nntmmyv6vurm@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c2045f40-c89b-40d2-9d62-08d90937bbcb
x-ms-traffictypediagnostic: DBAPR04MB7240:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBAPR04MB7240D1D2C550B7AD14FFC740E6419@DBAPR04MB7240.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AjTlhLoVKsPQPFzOVe045byE+hTjthelph+rv+oTE7Xja7OdYV3BRK8xltxC9sKSyzw0RD7s9lVQTFN2AUqkugB/jwTgHij2uwcXknsLUULfsTeGY5XNnAE/LY9Clq8m0F3HwyFIs71JZEOwszIRdSD5eZDyYnVDGfCdiJl+7yJA//tZD8sCpTIy6nhikd5MSo2fz3PahvhhEH/ioutzd8zbs4mrabawcBuAJYXlA2H8l0IuZ0gmUuZTQogFWLTslgIdprHNizDpDQV6+b/3iY+A5d64Osc9Eky6nyASvFNb2EOXVn85CnaYDj500kdQALo23vm+sa2n7QO7CyaCsUh1eD8/9u0qUzZaJPZ/6/3htg3fN3tfmLDSIieNkKhE2jOHF4xt1zOQOJ+CC05TEKhY8NefZ4WECvny85DAhG5fPQipcnwHfrLK41t/mszDP3bJL3kvDW44jeM6peSj3TcnkwIgF6jRc2Q83HLlpVpYVfzqJHI7E04/O7ybBeHuMCAvRaWhad1XsX4HJzn6lnRpha2QM5PfC1TBHgDlk75iUsCxaBZmIhTT6XmYXe1tqgZDrk/35HiFqG/Xxi1CGDQierykzc4ABObyp/HC8vh0+I2fb/XtmHwfzcC0r3qIcqUMHUyeCHWPBbkPxjN25+jiQavMHT3j3DlGz4XmRbKx7IR/TfgRjlxgBenMOboc1ri3ivekslecx9b4ZCF2GlnPiDGLcyKEx0NjMNXkjho=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(54906003)(8936002)(66476007)(66556008)(66446008)(64756008)(83380400001)(122000001)(66946007)(52536014)(5660300002)(186003)(7416002)(53546011)(6916009)(4326008)(71200400001)(966005)(8676002)(498600001)(9686003)(45080400002)(6506007)(38100700002)(55016002)(86362001)(7696005)(33656002)(2906002)(26005)(41533002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?VUxVTlJNZ2V6d1ZsRHp3cUZVbXl0aEx5ek5oQVhMNHduZTFsbHE0aWpCM1FN?=
 =?gb2312?B?eDhpVHNRTEMrNkxOZE5TYU1wRnd1OE0zMUVoVi8rMjA0SFQxNUFvVWtPcU1y?=
 =?gb2312?B?RWpoWk9iaEM4elZLZTdxQmlNYXNNdkhWcGgxb1FoWWhkTEVqTE9hMFhpRWFt?=
 =?gb2312?B?cHdMWEFXc2NwUHlub2NwaHRFQUk4TS9YdzFpTEw1VldlWTk2RlZRMzlhUllP?=
 =?gb2312?B?UVdBTTltM3FSRit4OWJBMkdiaXo4aUdnT24vRG5aVTZCM1VCM1NqamRQbG1V?=
 =?gb2312?B?OC9TVzZIdlBIdmdQWENZU3JWQ0lLU1BNYTdpSGpkejBMci9WSnBCZXN5M0Zh?=
 =?gb2312?B?L2w2Mks3b1VmSXZLbDFtT24yam5mdStzMEtmWUQ1Y3hUSDBkblVHSHp0Z3hS?=
 =?gb2312?B?QXpSRytSZ0FjdGpvZmZIQnFCd2k2UEJ4MUk5RndUckVGOEt6emRLMm5nSkhz?=
 =?gb2312?B?SEx1NUtDdExZV1dTUEJNVDJ5NFE5cVIzZFpvbCswODE2M3F0OStLY3ZlUnJv?=
 =?gb2312?B?a1VPMmVvaDVCc3ZPQ2FHSWxtK1RYOUdtVmRiUDZRU280VUQwQko2MTFtUEg0?=
 =?gb2312?B?dUgxeUhBd0F2Rk9oMlUwTkJ1cWdKRmRuTUlTckFOQTVCVk5XV0pFMEQyVlJk?=
 =?gb2312?B?dmxqZjFQS2Z6RzU5MjhIalJxK2tYREJJMGg3VnBXMlBvdWtMRHNGQlRoVERN?=
 =?gb2312?B?SERVNm9iWWo3cnZORlE4Q1ZQYkloaUUvUnByMUQ3Y3FqaWVnOVdIaXBUUmJW?=
 =?gb2312?B?R2NSVTY4VXZubmhaanBHU2VqWEpCYVRORWo4V3BTYXNKc1c4blhrV1ZScGZ4?=
 =?gb2312?B?cmhDSmRwYTdSeGM2b0VyYUtGNmwxY3lzTUd5dVQ2YkN4TjB1SVVLYTdNSElW?=
 =?gb2312?B?SEZ3UVI1M2xiRFhCcU1aVFRSS0ZJUnoxY0xmQXV1SVcvcFF3dGRmc1JuTHFB?=
 =?gb2312?B?WTlVdE1idjlNbFJlSTkxUEltVEpHUTZWUkxzM0NhclJXV1NpYSt1a1IwQWZN?=
 =?gb2312?B?STZhRHEydlRjNmNDSUFyOG9DY0hBSEZEMVRvNU8rL3VHSmhLSDZNczZaQkV6?=
 =?gb2312?B?MlZXQzdoc2ZhbmhRbmljSU1QcUdnRDMzcXQ0Z3A3dldHbFpsTW80N3MzV2l6?=
 =?gb2312?B?ejh5TytveHFDSVROZ1ZyVGUvZityQkZHMW4xRTBZTW9mbkFqbnVsa1pycFRj?=
 =?gb2312?B?emczaTgrT1FNYlR1Y013RFd5SStWczc0YmFMeDlEMnRKWU52ZVZYT1JKaytL?=
 =?gb2312?B?d2tFOWJ2am00QzlOUG5QRmR1SHJtWmxnMGtBQkNSU01Gd3JpZHpLVG52SnFs?=
 =?gb2312?B?KzFoaDYzSmVtMHpIZEVocDN3c2Z1M1k1cWRsL292QVRjL2V2OW5kdjFHYlhv?=
 =?gb2312?B?VVhsYTcwQkJ5Tk9LaE04MWpiMkcydmNOeUVWRXNlTFFsTEpHTlRkVFpaWkVn?=
 =?gb2312?B?MHl4R3VxZUxTa2UxTGxQeWYybTJtRkFibVdvM1E5WjlBRGRwMTZJbDBUb2RH?=
 =?gb2312?B?NFJDb3l0cjkyc0o5T21vMHVBTndqUVV6NXRuRWVXdi9jZEgwUHlVTWFVNTFa?=
 =?gb2312?B?VzN1OUV0Z3NacW5rb0hJZUk5MCs0TElaeFk0QjBOeU9iTzhtOUFMZHF1ck90?=
 =?gb2312?B?UW1Vby9nd0ltemtJTUhrREpMd3Q0TDJUSUFuVTB5SFlGbldnekJIeWtOYjdM?=
 =?gb2312?B?TDVPQ3R1dXhEWE9qOGxpck9tMTk5OXphdjk4OUNwN0lSNXE5SEZ6WXpMZzBw?=
 =?gb2312?Q?q8NyDc/l66wCePQjvbh/bExQqzHHYGVMmijc4S7?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2045f40-c89b-40d2-9d62-08d90937bbcb
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2021 04:48:42.4944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yCxsnnucJplIA5yVq6aRrPT27PMJzXfH3x0fiI8nM5HlAa6ZlvODZlKYAVWbzo/nYgBI6ztRZiltskb5Nd+MrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7240
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE9sZWtzaWogUmVtcGVsIDxv
LnJlbXBlbEBwZW5ndXRyb25peC5kZT4NCj4gU2VudDogMjAyMcTqNNTCMjPI1SAxMjozNw0KPiBU
bzogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gQ2M6IFNoYXduIEd1
byA8c2hhd25ndW9Aa2VybmVsLm9yZz47IFNhc2NoYSBIYXVlcg0KPiA8cy5oYXVlckBwZW5ndXRy
b25peC5kZT47IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD47IEZsb3JpYW4gRmFpbmVsbGkN
Cj4gPGYuZmFpbmVsbGlAZ21haWwuY29tPjsgSGVpbmVyIEthbGx3ZWl0IDxoa2FsbHdlaXQxQGdt
YWlsLmNvbT47IEZ1Z2FuZw0KPiBEdWFuIDxmdWdhbmcuZHVhbkBueHAuY29tPjsga2VybmVsQHBl
bmd1dHJvbml4LmRlOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1hcm0ta2VybmVs
QGxpc3RzLmluZnJhZGVhZC5vcmc7DQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGRs
LWxpbnV4LWlteCA8bGludXgtaW14QG54cC5jb20+OyBGYWJpbw0KPiBFc3RldmFtIDxmZXN0ZXZh
bUBnbWFpbC5jb20+OyBEYXZpZCBKYW5kZXIgPGRhdmlkQHByb3RvbmljLm5sPjsgUnVzc2VsbA0K
PiBLaW5nIDxsaW51eEBhcm1saW51eC5vcmcudWs+OyBQaGlsaXBwZSBTY2hlbmtlcg0KPiA8cGhp
bGlwcGUuc2NoZW5rZXJAdG9yYWRleC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5l
eHQgdjMgMC82XSBwcm92aWRlIGdlbmVyaWMgbmV0IHNlbGZ0ZXN0IHN1cHBvcnQNCj4gDQo+IEhp
IEpvYWtpbSwNCj4gDQo+IE9uIEZyaSwgQXByIDIzLCAyMDIxIGF0IDAzOjE4OjMyQU0gKzAwMDAs
IEpvYWtpbSBaaGFuZyB3cm90ZToNCj4gPg0KPiA+IEhpIE9sZWtzaWosDQo+ID4NCj4gPiBJIGxv
b2sgYm90aCBzdG1tYWMgc2VsZnRlc3QgY29kZSBhbmQgdGhpcyBwYXRjaCBzZXQuIEZvciBzdG1t
YWMsIGlmIFBIWQ0KPiBkb2Vzbid0IHN1cHBvcnQgbG9vcGJhY2ssIGl0IHdpbGwgZmFsbHRocm91
Z2ggdG8gTUFDIGxvb3BiYWNrLg0KPiA+IFlvdSBwcm92aWRlIHRoaXMgZ2VuZXJpYyBuZXQgc2Vs
ZnRlc3Qgc3VwcG9ydCBiYXNlZCBvbiBQSFkgbG9vcGJhY2ssIEkgaGF2ZSBhDQo+IHF1ZXN0aW9u
LCBpcyBpdCBwb3NzaWJsZSB0byBleHRlbmQgaXQgYWxzbyBzdXBwb3J0IE1BQyBsb29wYmFjayBs
YXRlcj8NCj4gDQo+IFllcy4gSWYgeW91IGhhdmUgaW50ZXJlc3QgYW5kIHRpbWUgdG8gaW1wbGVt
ZW50IGl0LCBwbGVhc2UgZG8uDQo+IEl0IHNob3VsZCBiZSBzb21lIGtpbmQgb2YgZ2VuZXJpYyBj
YWxsYmFjayBhcyBwaHlfbG9vcGJhY2soKSBhbmQgaWYgUEhZIGFuZA0KPiBNQUMgbG9vcGJhY2tz
IGFyZSBzdXBwb3J0ZWQgd2UgbmVlZCB0byB0ZXN0cyBib3RoIHZhcmlhbnRzLg0KSGkgT2xla3Np
aiwNCg0KWWVzLCBJIGNhbiB0cnkgdG8gaW1wbGVtZW50IGl0IHdoZW4gSSBhbSBmcmVlLCBidXQg
SSBzdGlsbCBoYXZlIHNvbWUgcXVlc3Rpb25zOg0KMS4gV2hlcmUgd2UgcGxhY2UgdGhlIGdlbmVy
aWMgZnVuY3Rpb24/IFN1Y2ggYXMgbWFjX2xvb3BiYWNrKCkuDQoyLiBNQUMgaXMgZGlmZmVyZW50
IGZyb20gUEhZLCBuZWVkIHByb2dyYW0gZGlmZmVyZW50IHJlZ2lzdGVycyB0byBlbmFibGUgbG9v
cGJhY2sgb24gZGlmZmVyZW50IFNvQ3MsIHRoYXQgbWVhbnMgd2UgbmVlZCBnZXQgTUFDIHByaXZh
dGUgZGF0YSBmcm9tICJzdHJ1Y3QgbmV0X2RldmljZSIuDQpTbyB3ZSBuZWVkIGEgY2FsbGJhY2sg
Zm9yIE1BQyBkcml2ZXJzLCB3aGVyZSB3ZSBleHRlbmQgdGhpcyBjYWxsYmFjaz8gQ291bGQgYmUg
InN0cnVjdCBuZXRfZGV2aWNlX29wcyI/IFN1Y2ggYXMgbmRvX3NldF9sb29wYmFjaz8NCg0KQmVz
dCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQo+IEJlc3QgcmVnYXJkcywNCj4gT2xla3Npag0KPiAN
Cj4gPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gPiBGcm9tOiBPbGVrc2lqIFJl
bXBlbCA8by5yZW1wZWxAcGVuZ3V0cm9uaXguZGU+DQo+ID4gPiBTZW50OiAyMDIxxOo01MIxOcjV
IDIxOjAxDQo+ID4gPiBUbzogU2hhd24gR3VvIDxzaGF3bmd1b0BrZXJuZWwub3JnPjsgU2FzY2hh
IEhhdWVyDQo+ID4gPiA8cy5oYXVlckBwZW5ndXRyb25peC5kZT47IEFuZHJldyBMdW5uIDxhbmRy
ZXdAbHVubi5jaD47IEZsb3JpYW4NCj4gPiA+IEZhaW5lbGxpIDxmLmZhaW5lbGxpQGdtYWlsLmNv
bT47IEhlaW5lciBLYWxsd2VpdA0KPiA+ID4gPGhrYWxsd2VpdDFAZ21haWwuY29tPjsgRnVnYW5n
IER1YW4gPGZ1Z2FuZy5kdWFuQG54cC5jb20+DQo+ID4gPiBDYzogT2xla3NpaiBSZW1wZWwgPG8u
cmVtcGVsQHBlbmd1dHJvbml4LmRlPjsga2VybmVsQHBlbmd1dHJvbml4LmRlOw0KPiA+ID4gbmV0
ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3Jn
Ow0KPiA+ID4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgZGwtbGludXgtaW14IDxsaW51
eC1pbXhAbnhwLmNvbT47DQo+ID4gPiBGYWJpbyBFc3RldmFtIDxmZXN0ZXZhbUBnbWFpbC5jb20+
OyBEYXZpZCBKYW5kZXINCj4gPiA+IDxkYXZpZEBwcm90b25pYy5ubD47IFJ1c3NlbGwgS2luZyA8
bGludXhAYXJtbGludXgub3JnLnVrPjsgUGhpbGlwcGUNCj4gPiA+IFNjaGVua2VyIDxwaGlsaXBw
ZS5zY2hlbmtlckB0b3JhZGV4LmNvbT4NCj4gPiA+IFN1YmplY3Q6IFtQQVRDSCBuZXQtbmV4dCB2
MyAwLzZdIHByb3ZpZGUgZ2VuZXJpYyBuZXQgc2VsZnRlc3QNCj4gPiA+IHN1cHBvcnQNCj4gPiA+
DQo+ID4gPiBjaGFuZ2VzIHYzOg0KPiA+ID4gLSBtYWtlIG1vcmUgZ3JhbnVsYXIgdGVzdHMNCj4g
PiA+IC0gZW5hYmxlIGxvb3BiYWNrIGZvciBhbGwgUEhZcyBieSBkZWZhdWx0DQo+ID4gPiAtIGZp
eCBhbGxtb2Rjb25maWcgYnVpbGQgZXJyb3JzDQo+ID4gPiAtIHBvbGwgZm9yIGxpbmsgc3RhdHVz
IHVwZGF0ZSBhZnRlciBzd2l0Y2hpbmcgdG8gdGhlIGxvb3BiYWNrIG1vZGUNCj4gPiA+DQo+ID4g
PiBjaGFuZ2VzIHYyOg0KPiA+ID4gLSBtYWtlIGdlbmVyaWMgc2VsZnRlc3RzIGF2YWlsYWJsZSBm
b3IgYWxsIG5ldHdvcmtpbmcgZGV2aWNlcy4NCj4gPiA+IC0gbWFrZSB1c2Ugb2YgbmV0X3NlbGZ0
ZXN0KiBvbiBGRUMsIGFnNzF4eCBhbmQgYWxsIERTQSBzd2l0Y2hlcy4NCj4gPiA+IC0gYWRkIGxv
b3BiYWNrIHN1cHBvcnQgb24gbW9yZSBQSFlzLg0KPiA+ID4NCj4gPiA+IFRoaXMgcGF0Y2ggc2V0
IHByb3ZpZGVzIGRpYWdub3N0aWMgY2FwYWJpbGl0aWVzIGZvciBzb21lIGlNWCwgYWc3MXh4DQo+
ID4gPiBvciBhbnkgRFNBIGJhc2VkIGRldmljZXMuIEZvciBwcm9wZXIgZnVuY3Rpb25hbGl0eSwg
UEhZIGxvb3BiYWNrIHN1cHBvcnQgaXMNCj4gbmVlZGVkLg0KPiA+ID4gU28gZmFyIHRoZXJlIGlz
IG9ubHkgaW5pdGlhbCBpbmZyYXN0cnVjdHVyZSB3aXRoIGJhc2ljIHRlc3RzLg0KPiA+ID4NCj4g
PiA+IE9sZWtzaWogUmVtcGVsICg2KToNCj4gPiA+ICAgbmV0OiBwaHk6IGV4ZWN1dGUgZ2VucGh5
X2xvb3BiYWNrKCkgcGVyIGRlZmF1bHQgb24gYWxsIFBIWXMNCj4gPiA+ICAgbmV0OiBwaHk6IGdl
bnBoeV9sb29wYmFjazogYWRkIGxpbmsgc3BlZWQgY29uZmlndXJhdGlvbg0KPiA+ID4gICBuZXQ6
IGFkZCBnZW5lcmljIHNlbGZ0ZXN0IHN1cHBvcnQNCj4gPiA+ICAgbmV0OiBmZWM6IG1ha2UgdXNl
IG9mIGdlbmVyaWMgTkVUX1NFTEZURVNUUyBsaWJyYXJ5DQo+ID4gPiAgIG5ldDogYWc3MXh4OiBt
YWtlIHVzZSBvZiBnZW5lcmljIE5FVF9TRUxGVEVTVFMgbGlicmFyeQ0KPiA+ID4gICBuZXQ6IGRz
YTogZW5hYmxlIHNlbGZ0ZXN0IHN1cHBvcnQgZm9yIGFsbCBzd2l0Y2hlcyBieSBkZWZhdWx0DQo+
ID4gPg0KPiA+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2F0aGVyb3MvS2NvbmZpZyAgICAgIHwg
ICAxICsNCj4gPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9hdGhlcm9zL2FnNzF4eC5jICAgICB8
ICAyMCArLQ0KPiA+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9LY29uZmlnICAg
IHwgICAxICsNCj4gPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4u
YyB8ICAgNyArDQo+ID4gPiAgZHJpdmVycy9uZXQvcGh5L3BoeS5jICAgICAgICAgICAgICAgICAg
ICAgfCAgIDMgKy0NCj4gPiA+ICBkcml2ZXJzL25ldC9waHkvcGh5X2RldmljZS5jICAgICAgICAg
ICAgICB8ICAzNSArLQ0KPiA+ID4gIGluY2x1ZGUvbGludXgvcGh5LmggICAgICAgICAgICAgICAg
ICAgICAgIHwgICAxICsNCj4gPiA+ICBpbmNsdWRlL25ldC9kc2EuaCAgICAgICAgICAgICAgICAg
ICAgICAgICB8ICAgMiArDQo+ID4gPiAgaW5jbHVkZS9uZXQvc2VsZnRlc3RzLmggICAgICAgICAg
ICAgICAgICAgfCAgMTIgKw0KPiA+ID4gIG5ldC9LY29uZmlnICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHwgICA0ICsNCj4gPiA+ICBuZXQvY29yZS9NYWtlZmlsZSAgICAgICAgICAgICAg
ICAgICAgICAgICB8ICAgMSArDQo+ID4gPiAgbmV0L2NvcmUvc2VsZnRlc3RzLmMgICAgICAgICAg
ICAgICAgICAgICAgfCA0MDANCj4gPiA+ICsrKysrKysrKysrKysrKysrKysrKysNCj4gPiA+ICBu
ZXQvZHNhL0tjb25maWcgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgMSArDQo+ID4gPiAg
bmV0L2RzYS9zbGF2ZS5jICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgMjEgKysNCj4gPiA+
ICAxNCBmaWxlcyBjaGFuZ2VkLCA1MDAgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkgIGNy
ZWF0ZSBtb2RlDQo+ID4gPiAxMDA2NDQgaW5jbHVkZS9uZXQvc2VsZnRlc3RzLmggIGNyZWF0ZSBt
b2RlIDEwMDY0NA0KPiA+ID4gbmV0L2NvcmUvc2VsZnRlc3RzLmMNCj4gPiA+DQo+ID4gPiAtLQ0K
PiA+ID4gMi4yOS4yDQo+ID4NCj4gPiBfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXw0KPiA+IGxpbnV4LWFybS1rZXJuZWwgbWFpbGluZyBsaXN0DQo+ID4gbGlu
dXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnDQo+ID4gaHR0cHM6Ly9ldXIwMS5zYWZl
bGlua3MucHJvdGVjdGlvbi5vdXRsb29rLmNvbS8/dXJsPWh0dHAlM0ElMkYlMkZsaXN0cw0KPiA+
IC5pbmZyYWRlYWQub3JnJTJGbWFpbG1hbiUyRmxpc3RpbmZvJTJGbGludXgtYXJtLWtlcm5lbCZh
bXA7ZGF0YT0wNCU3DQo+IEMwDQo+ID4NCj4gMSU3Q3FpYW5ncWluZy56aGFuZyU0MG54cC5jb20l
N0M4Nzk2YmY1M2U0NmI0YjFiZTkyYjA4ZDkwNjExODZmOQ0KPiAlN0M2ODYNCj4gPg0KPiBlYTFk
M2JjMmI0YzZmYTkyY2Q5OWM1YzMwMTYzNSU3QzAlN0MwJTdDNjM3NTQ3NDk0NjE0NzUzMzU4JTdD
VQ0KPiBua25vd24lNw0KPiA+DQo+IENUV0ZwYkdac2IzZDhleUpXSWpvaU1DNHdMakF3TURBaUxD
SlFJam9pVjJsdU16SWlMQ0pCVGlJNklrMWhhV3dpTA0KPiBDSlhWDQo+ID4NCj4gQ0k2TW4wJTNE
JTdDMTAwMCZhbXA7c2RhdGE9eCUyQlVGQiUyQjFYcDB6YlIxbUc1SERHdnFCVXZLaFgNCj4gVkpu
MzM3VCUyQkINCj4gPiBEN2NPNmclM0QmYW1wO3Jlc2VydmVkPTANCj4gDQo+IC0tDQo+IFBlbmd1
dHJvbml4IGUuSy4gICAgICAgICAgICAgICAgICAgICAgICAgICB8DQo+IHwNCj4gU3RldWVyd2Fs
ZGVyIFN0ci4gMjEgICAgICAgICAgICAgICAgICAgICAgIHwNCj4gaHR0cHM6Ly9ldXIwMS5zYWZl
bGlua3MucHJvdGVjdGlvbi5vdXRsb29rLmNvbS8/dXJsPWh0dHAlM0ElMkYlMkZ3d3cucGUNCj4g
bmd1dHJvbml4LmRlJTJGJmFtcDtkYXRhPTA0JTdDMDElN0NxaWFuZ3FpbmcuemhhbmclNDBueHAu
Y29tJTdDODcNCj4gOTZiZjUzZTQ2YjRiMWJlOTJiMDhkOTA2MTE4NmY5JTdDNjg2ZWExZDNiYzJi
NGM2ZmE5MmNkOTljNWMzMDE2MzUNCj4gJTdDMCU3QzAlN0M2Mzc1NDc0OTQ2MTQ3NTMzNTglN0NV
bmtub3duJTdDVFdGcGJHWnNiM2Q4ZXlKV0lqDQo+IG9pTUM0d0xqQXdNREFpTENKUUlqb2lWMmx1
TXpJaUxDSkJUaUk2SWsxaGFXd2lMQ0pYVkNJNk1uMCUzRCU3QzEwDQo+IDAwJmFtcDtzZGF0YT1L
MmRzR1Z4RVh2JTJGdEM3cDBsNFRGbExsYXF6elRhNmt0cmJTZGNDSjEwSjAlM0QmYW1wOw0KPiBy
ZXNlcnZlZD0wICB8DQo+IDMxMTM3IEhpbGRlc2hlaW0sIEdlcm1hbnkgICAgICAgICAgICAgICAg
ICB8IFBob25lOiArNDktNTEyMS0yMDY5MTctMA0KPiB8DQo+IEFtdHNnZXJpY2h0IEhpbGRlc2hl
aW0sIEhSQSAyNjg2ICAgICAgICAgICB8IEZheDoNCj4gKzQ5LTUxMjEtMjA2OTE3LTU1NTUgfA0K
