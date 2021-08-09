Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 271423E3F37
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 07:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbhHIFJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 01:09:17 -0400
Received: from mail-vi1eur05on2076.outbound.protection.outlook.com ([40.107.21.76]:24776
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229516AbhHIFJO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 01:09:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DgTmRdFB+owpUN2HW3qQpd0CvnT6gVrovNiJ309F7JrCU/3wC+d/IjsE/51sjcyXAszcwV7z6Sl6m7QV20vZV1Rv8hHyeFy/L4tjc4xaa/Psk1a9Y+KukUeqtyRZUqwigPLHfWiDiWFVidVr7F4Q4mkiTbC3hZi2TgzoIvqUkMAdMhQiz5PZtMmX/LqK6YCxClISMRKnHGbRsqoe0C57YY91AuKBnKQU/vIAfLX18a1VG2iyKQ+dY1bsuLz2H+DB2/WTSXPn3MbOINc/Zwv4bPPyag/v6BiQYJiG0m/yUZ7hRFJWUAfK2OjSqlYrhEBazejuB9y/tHpRHzHeHywcDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N+GyT0V4uKiv2PDfHGdfILdW7tAtsFXoNc4Wue8BgtQ=;
 b=kyMmy6kECC9U78vwPe2WE7NoaGosvbRsQacPoQV4SOsILTL4hGx07XXLjfoRSwOQihHXEgZuO8E1LJB964a4k3m8i4pl10hPUiWSz34dk/d9XroO6UwdoKocwcsW3z1VKjqo8Q42wzMcxqStCGAGp1EH3CCJNmdO88nJF4ROZCycRTiupaNcMGRI7uqY06vlNzLEpSluKtrC4yQREFY26DPFLXh5vMb/KovSnsG/AyI/xqScoYB70rJdTr2mFQo7Pp1liA5M/Ha1bQybfxBblyI14Q3XvKEeTwakt9NvLg7kdDBynnKaKId23NGuKBGgg854nEMyaSFs/SIIgg9sig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N+GyT0V4uKiv2PDfHGdfILdW7tAtsFXoNc4Wue8BgtQ=;
 b=TuUmmlySBd+OunAQESWyyqXE8mxS1WRhLT9e2kia7/mIO974Xs7euL3NA1aO34KCIbrj0wD4ab6VR2HM3HB2/Gr+8fN0AeDiQtLgJPbb9wdCmUo/4GV3QaXEIy2J0ZoB7c7diyTim0fJTWbxq9SG9XWzziLfD9op6yff0WXSU4c=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB9PR04MB8430.eurprd04.prod.outlook.com (2603:10a6:10:24f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Mon, 9 Aug
 2021 05:08:50 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::6969:eadc:6001:c0d]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::6969:eadc:6001:c0d%6]) with mapi id 15.20.4394.022; Mon, 9 Aug 2021
 05:08:50 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH net-next 1/3] dt-bindings: net: fsl, fec: add "fsl,
 wakeup-irq" property
Thread-Topic: [PATCH net-next 1/3] dt-bindings: net: fsl, fec: add "fsl,
 wakeup-irq" property
Thread-Index: AQHXidrZaeAm3FGM8UWFBIfAWGHBc6tqnwvw
Date:   Mon, 9 Aug 2021 05:08:50 +0000
Message-ID: <DB8PR04MB67950F6863A8FEE6745CBC68E6F69@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210805074615.29096-1-qiangqing.zhang@nxp.com>
 <20210805074615.29096-2-qiangqing.zhang@nxp.com>
 <2e1a14bf-2fa8-ed39-d133-807c4e14859c@gmail.com>
In-Reply-To: <2e1a14bf-2fa8-ed39-d133-807c4e14859c@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ef75c0f6-1ed1-4904-7248-08d95af3c683
x-ms-traffictypediagnostic: DB9PR04MB8430:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB9PR04MB8430D3A0FB100EFB808D7EF1E6F69@DB9PR04MB8430.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oWbXgWGkZCN1ZQXxdsmGHnZAI/6TA9C9Y7VxGf9PKEnuV4hMTKzOQFlOmsiOQQfsZCRQQHt/aOl7TrM8ZNuaqMhJY/KL41JDhONJY44YVCt0z7p2Yu0fFUjcWcrtW7aofTvprJcAzeJ5GYMxXoY793g7Fh9cnSVJTOtCZCKrUMHy1xwwK1QURIshsLOp/RoqE7tSuoIf7JB+ejYzIy6Mf8UhyRW3wqy7Af6aP7fD19Qq4KCQmXhz86UfRQ5GAiHyafiGnwY2isHDG+I4bPSGM2/tcjOT4QWZz2NpsPyepuxYIeAz6G6k6QLITVfsnGTLYSoPUUSYaYg+dC2y+TL6U8u9j1dYp2bfdSb6HiekjhTwgK8LGUubnavRvcabkhPROaebM0Wy7mZjbaGfFXLzxDtElAK5xEgds3j3J71WDEacZJvHF87xhzC0ywm26swDWafEnhOI7MUqoK274cV/3ODrUZbz0fRJPog+xOSGlzR51x28lycXsIRB9kH9YyiCG+8lqFzJbqQr4vUdD2RAQITIGa0a4g7CWzF9HUTFfReH0wbfXE0F9SJrMUWj8zGaEgXY0z2/zZ3zRp/euMMKR0T9FwS/t9IuGw/Ls0tRUxQZeOPXSKkVlpMZQUVSqRP4UYU3M9xntpncoLqvIX3TbaPq3BJITrplXwCxfp88mpOlYK+eeMZ11dqLLiyfvjiEEhUDQ6PX6xS7znhjdewu6w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(186003)(26005)(52536014)(83380400001)(86362001)(66946007)(66556008)(76116006)(64756008)(66446008)(66476007)(55016002)(71200400001)(2906002)(9686003)(110136005)(54906003)(8936002)(122000001)(4326008)(38100700002)(7416002)(38070700005)(33656002)(316002)(6506007)(8676002)(53546011)(7696005)(508600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L0dHMXlTc2svN2V0QlRHYUg0TGRWeFRqYTYrLzBDVk95Zy9BUTdRcHd1d051?=
 =?utf-8?B?OWs1NGRpTmJEcGEvNUpoSTNWZkgyZ0JicFdCVTgxMmVvcEhEZGdVbWdGNUFE?=
 =?utf-8?B?N2RORitmcnc2YmwxWFA4VXc3OGpVOEdwbVRsZXNNYW1mRWJpejhoYnZYN0xB?=
 =?utf-8?B?N0hsVkJwcm00N3MwS3Ftb2k4RkN1TCt4di84WmljN3kvcklFVWhoRE0vY0tl?=
 =?utf-8?B?L0hlcGVoWWszM2w3cm9PMkVoQmx4bUh6aHNobnVudGs5c0Z0TjQ3TzNOREpS?=
 =?utf-8?B?clNjbnNYWVVIRHM1M28va2tIdkdxdllSY2krOTdZZ3FFVGc0ek04Nk5WMTdD?=
 =?utf-8?B?VjFKUE5MQkFIWWU0Sk0rUkdIWVZ5MTc1bkEzQ1ZtZEFYL2hib20zZjRvMHJo?=
 =?utf-8?B?cnBoMGhiaFo0QTRmY3Z6WjBHeU9GN2pYVVNYdFdFSm1weFBWaG1Ha0k1endW?=
 =?utf-8?B?S1NnUlc5c0dEZy83cVY0MFYvN0pJL05DeU1iZlc5TGtkRVNQR0M4cnB2Mk1R?=
 =?utf-8?B?UTdmVkRyQVR5aS9QSGZyK0c2VXpTTkdlN240RTdKb0xMN3dzZ3ozMnpBU3Uw?=
 =?utf-8?B?NEtxZHN2aFBYQ2VHZHRqQUhaU0trRm9BWUZ6dXJVNkZqQXRselFvbndkV3FM?=
 =?utf-8?B?VmZJMzVSMnA0ZTZSZDVoUmxqclZka2FaQXVqaFRQT2J3SjJ2MEhrSnNjRHJG?=
 =?utf-8?B?VTZDY0tERURVcFB2Yko5eVROOEIxZlQwOTdDc2I1N3lKUUplYVpzK2tVR2Jj?=
 =?utf-8?B?a0RXYUtyaDJlQXBCNWVsbkZMNmhDWXR6UWlYRGVXRjhTRGVkQTRqOUxCMmVQ?=
 =?utf-8?B?UDBZckJSdTlIMmpwd09XQ3Ztc0lSYzVSS2MweFJyVDdCWENZNXMrdzRzT2dG?=
 =?utf-8?B?RjNNTkExcnZTcU5MQ2ZIYUpQTHpZNzl3eTJqWkdBTnRNaG9FNnZkQ2hSeVhm?=
 =?utf-8?B?d0srRHlrYURWTk9nakFVR0lBZlc3MHFQVjc2N2RVNkt6U3k5ZDhuNnlhY1F5?=
 =?utf-8?B?WEV0VWo0T3VERjZ6a001RkRMYVFlbzhIeDRIUmFuVEpuSkd6aWhtMWdXeCtL?=
 =?utf-8?B?OHNOcnY4V3VVa2JlVEZpRGRUL09oMXpNVk5JS2k4cXhoUVNsYnRGcEpFY1Mv?=
 =?utf-8?B?cDFBL0ZFOG9uVGRWSXZzVHBIWEUzZzluVDErVVlYNUVPWHZCakQvUWdGQSt3?=
 =?utf-8?B?WEUwL1NScXdzUFV5M1owZ0lHQ1NtaEhOUVBxQ1QxU0JqU2I4US9RTFBwcFk4?=
 =?utf-8?B?cllyYVhoNW1aN2hLM0pmdzRrdUdYcjlDZHFuVEYyUi9uKzB6WlhXOWtlYUZp?=
 =?utf-8?B?MGg2WGlKSENncjdWY3d1WFJJcE1POUVBSzF0eW1NN29mS081ZUxtSExuYmNH?=
 =?utf-8?B?clNNdlJwYmI5aHMwQ3pzQU5MamN3dmFUOVAvNjlqVnp0T3JHV1Nlanh4bmsr?=
 =?utf-8?B?am9rQ3NoTXlFUmZaeHBMWkllL3MyVGVuWlViLzd6S1FKLzR3Y2xSdXN3NTNo?=
 =?utf-8?B?bTJGWWJXQTFMOWQrN3hqZGxKVHBnSVJRdFhOcStXQXZBVzNnZjY4UnNWeEc1?=
 =?utf-8?B?bmw1MFBSak83U2ZrLyt2SVRRaXFtT0k2SmdJT2ZlRG4yb1FzeE8ycVdjdkND?=
 =?utf-8?B?V0NDUlNNMkJET1F1YjNNR2FFM2w1N3JjcyszRUdKSmlMSHZLeGdLUFE0VFdt?=
 =?utf-8?B?M0RMQWZrdmlneFFQU2QzNXJ0OFM3WHY0cWhPd2tLQXlUVnV1L3Zzci9PRzUx?=
 =?utf-8?Q?Nfspb+beXx+pZJ7qO0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef75c0f6-1ed1-4904-7248-08d95af3c683
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2021 05:08:50.2865
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: doqc7XJNNrxxAerQCXRMGdr4E3MP95dBHlIH5JlXsrdVIB26RS8GC3V++gNjgmA6T+FXTExuFlljQ/WGTAe4iA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8430
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBGbG9yaWFuLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEZs
b3JpYW4gRmFpbmVsbGkgPGYuZmFpbmVsbGlAZ21haWwuY29tPg0KPiBTZW50OiAyMDIx5bm0OOac
iDXml6UgMTc6MTgNCj4gVG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+
OyBkYXZlbUBkYXZlbWxvZnQubmV0Ow0KPiBrdWJhQGtlcm5lbC5vcmc7IHJvYmgrZHRAa2VybmVs
Lm9yZzsgc2hhd25ndW9Aa2VybmVsLm9yZzsNCj4gcy5oYXVlckBwZW5ndXRyb25peC5kZTsgZmVz
dGV2YW1AZ21haWwuY29tOyBhbmRyZXdAbHVubi5jaA0KPiBDYzoga2VybmVsQHBlbmd1dHJvbml4
LmRlOyBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPjsNCj4gbmV0ZGV2QHZnZXIua2Vy
bmVsLm9yZzsgZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWtlcm5lbEB2Z2Vy
Lmtlcm5lbC5vcmc7IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZw0KPiBTdWJq
ZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IDEvM10gZHQtYmluZGluZ3M6IG5ldDogZnNsLCBmZWM6
IGFkZCAiZnNsLA0KPiB3YWtldXAtaXJxIiBwcm9wZXJ0eQ0KPiANCj4gDQo+IA0KPiBPbiA4LzUv
MjAyMSAxMjo0NiBBTSwgSm9ha2ltIFpoYW5nIHdyb3RlOg0KPiA+IEFkZCAiZnNsLHdha2V1cC1p
cnEiIHByb3BlcnR5IGZvciBGRUMgY29udHJvbGxlciB0byBzZWxlY3Qgd2FrZXVwIGlycQ0KPiA+
IHNvdXJjZS4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEZ1Z2FuZyBEdWFuIDxmdWdhbmcuZHVh
bkBueHAuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpo
YW5nQG54cC5jb20+DQo+IA0KPiBXaHkgYXJlIG5vdCB5b3UgbWFraW5nIHVzZSBvZiB0aGUgc3Rh
bmRhcmQgaW50ZXJydXB0cy1leHRlbmRlZCBwcm9wZXJ0eQ0KPiB3aGljaCBhbGxvd3MgZGlmZmVy
ZW50IGludGVycnVwdCBsaW5lcyB0byBiZSBvcmlnaW5hdGluZyBmcm9tIGRpZmZlcmVudCBpbnRl
cnJ1cHQNCj4gY29udHJvbGxlcnMsIGUuZy46DQo+IA0KPiBpbnRlcnJ1cHRzLWV4dGVuZGVkID0g
PCZnaWMgR0lDX1NQSSAxMTIgND4sIDwmd2FrZXVwX2ludGMgMD47DQoNClRoYW5rcy4NCg0KQUZB
SUssIGludGVycnVwdHMtZXh0ZW5kZWQgc2hvdWxkIGJlIHVzZWQgaW5zdGVhZCBvZiBpbnRlcnJ1
cHRzIHdoZW4gYSBkZXZpY2UgaXMgY29ubmVjdGVkIHRvIG11bHRpcGxlIGludGVycnVwdCBjb250
cm9sbGVycw0KYXMgaXQgZW5jb2RlcyBhIHBhcmVudCBwaGFuZGxlIHdpdGggZWFjaCBpbnRlcnJ1
cHQgc3BlY2lmaWVyLiBIb3dldmVyLCBmb3IgRkVDIGNvbnRyb2xsZXIsIGFsbCBpbnRlcnJ1cHQg
bGluZXMgYXJlIG9yaWdpbmF0aW5nIGZyb20NCnRoZSBzYW1lIGludGVycnVwdCBjb250cm9sbGVy
cy4NCg0KMSkgRkVDIGNvbnRyb2xsZXIgaGFzIHVwIHRvIDQgaW50ZXJydXB0IGxpbmVzIGFuZCBh
bGwgb2YgdGhlc2UgYXJlIHJvdXRlZCB0byBHSUMgaW50ZXJydXB0IGNvbnRyb2xsZXIuDQoyKSBG
RUMgaGFzIGEgd2FrZXVwIGludGVycnVwdCBzaWduYWwgYW5kIGFsd2F5cyBhcmUgbWl4ZWQgd2l0
aCBvdGhlciBpbnRlcnJ1cHQgc2lnbmFscywgYW5kIHRoZW4gb3V0cHV0IHRvIG9uZSBpbnRlcnJ1
cHQgbGluZS4NCjMpIEZvciBsZWdhY3kgU29Dcywgd2FrZXVwIGludGVycnVwdCBhcmUgbWl4ZWQg
dG8gaW50MCBsaW5lLCBidXQgZm9yIGkuTVg4TSBzZXJpYWxzLCBhcmUgbWl4ZWQgdG8gaW50MiBs
aW5lLg0KNCkgTm93IGRyaXZlciB0cmVhdCBpbnQwIGFzIHRoZSB3YWtldXAgc291cmNlIGJ5IGRl
ZmF1bHQsIGl0IGlzIGJyb2tlbiBmb3IgaS5NWDhNLg0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0g
WmhhbmcNCj4gLS0NCj4gRmxvcmlhbg0K
