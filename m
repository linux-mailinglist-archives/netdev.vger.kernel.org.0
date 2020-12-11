Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F862D7572
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 13:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395523AbgLKMTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 07:19:48 -0500
Received: from mail-eopbgr00052.outbound.protection.outlook.com ([40.107.0.52]:4483
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388412AbgLKMTe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 07:19:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OH4FjG4H+EC4xOQvYj0LF6zqzLoIaLYHN5l0DhwVgHdCi9ZY3RNMIFiAKhxdyKPhI05SF7fyLwbA/9IBa9g8Uu4mMgJ8QnsTwm6Ud5YSDnUSPypEgCG8xCIRlBj3Fa4eK3MPU1NGzz3H1UxYRSsuRn6DMu4uoqHYo5PiOJAlrv5cj2yMLF3D0m0eA9l7cNS3QEh65J3eN0oSJa8IfI98cn1PJoqxRcHPDkyqaBBsFHLZR53duwcMvxwcDLFokGqPwz3S7MUq1Ps/ijEEXTHrgO4Gm8U1NqWqnpNLQGKGLe64MpTYz7vcmMy0h/dfhYi/I2s89u9dSeYOXZB6QsHKYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kpzJomJ/eEM1ZYG8okksbJ664d3uBPC3Lf5sdT1aR1k=;
 b=ITWhRNM9Uoh+bY5w7e91kPngP/zTnkF+4aLi7yTbO4pY6l9675IBWhiVfGXcUEmptlvDkI7I+gqNEd0S2fkQVmJGFRzYEs6EDYXHUknSVDrGvaqiSub4NPeXZkRuJLAVBDz9bIz1PQM/8pDLeGV8kqYr65DwBUpfPjhKdpWwOd3S3TCRvi4orhGbAGD9r+re3oqdmdx3rpaqb8Il/b9oVr3JyuxDxCBfOS4NiK9JHh89yREaXit6nUaZg0CLIGfr/c21QZ5PJZT0rWD9I03DbTzHvmlU6mG7Q/x6SenLCN2d/++Vg83/xCKLc+iApGF6bU6Xl/jjnsHQGMgwMMw7gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kpzJomJ/eEM1ZYG8okksbJ664d3uBPC3Lf5sdT1aR1k=;
 b=Hu4r0bu8qktz2yyqQTNdKltw2o0XP+d/qZqH/1F3AsBJ/Vi1JLTBFI6iKzLkUoOH1RQXbV4sdcazuz1QMFYvgoGlBZeRSfcc3bIJBZlqEBZtIkq6TpgNqXJNV1BRrThDwIh+6mDcpE8R3JoVWV8wavMpIflSh2nOix9srpOlbe4=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6972.eurprd04.prod.outlook.com (2603:10a6:10:11c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.14; Fri, 11 Dec
 2020 12:18:45 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%5]) with mapi id 15.20.3654.014; Fri, 11 Dec 2020
 12:18:45 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH RFC] ethernet: stmmac: clean up the code for
 release/suspend/resume function
Thread-Topic: [PATCH RFC] ethernet: stmmac: clean up the code for
 release/suspend/resume function
Thread-Index: AQHWzI2S18NWndIqyUWx3RsQGG1aHqns/3sAgAABlGCAAwxxgIABwoyg
Date:   Fri, 11 Dec 2020 12:18:44 +0000
Message-ID: <DB8PR04MB6795536B700E3E5904F149B5E6CA0@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20201207113849.27930-1-qiangqing.zhang@nxp.com>
        <20201208182422.156f7ef1@xhacker.debian>
        <DB8PR04MB67952071DBA50ECF03BF9B98E6CD0@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20201210170319.534c0377@xhacker.debian>
In-Reply-To: <20201210170319.534c0377@xhacker.debian>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: synaptics.com; dkim=none (message not signed)
 header.d=none;synaptics.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6b0758f5-fed8-4a2f-5a8e-08d89dcee7de
x-ms-traffictypediagnostic: DB8PR04MB6972:
x-microsoft-antispam-prvs: <DB8PR04MB6972928CF53966B7A2EA643FE6CA0@DB8PR04MB6972.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BRE2uXyjD6JwED/ANDTQDNTY7ubTPN1FnFmQwQ/yYjWHEGuueCBON1IykyG8oA1m3vypfGXiukGNHTC02wsWuL5RfVeNTvX6Pwjh+dPSHWAKvMnX6HiJuDJubCr2NRQ07Tf8DrxWarJklYBVXp2hIneCauGM3vDEGvuSzgIjFaVSaoCOBycbPAp07DzzCUAWgU0mUz/fjylFmEVih2ghoPT7nUKsOvpi6SHmoSl+U4h0Y9ENv3w9dUSWaht8Zdoi5lGhff8LwRk3gScPlU8U8L4clFCDD7g3V/2rz5QcTMu4GT8m/3aP2Q0ls7z5QBcvSW5faw9EQ9wJTLNSRTOeZw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(136003)(39860400002)(346002)(6916009)(5660300002)(64756008)(66556008)(66476007)(8936002)(33656002)(8676002)(316002)(52536014)(66446008)(186003)(4326008)(9686003)(71200400001)(53546011)(76116006)(54906003)(66946007)(55016002)(83380400001)(26005)(15650500001)(6506007)(86362001)(2906002)(45080400002)(7696005)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bzZBVlppWHdUblEzc3ZENEEwNWZDZ08rOG1Wc3ZveUQ1eUo5TERmaG5OSWxQ?=
 =?utf-8?B?YXFIOVdzV0swRC9HcURwU2RuTXZhNmRveHY0Szg5cmQwL0cyT1djdmN3Q2Nj?=
 =?utf-8?B?WmZVR2xiNDIreWJNYkZkTUcyUy9SVmpvanp1UEJUNEd3UFZQWXpHTnFEVTRC?=
 =?utf-8?B?R1J6VTdGTldPVXhTSnVXU2ZNelYrVWVmcmtNRGdVWUJQUHNHTnZ0c0FSMHp6?=
 =?utf-8?B?N3FzYnZueG16Z3pneFFTWVNPVU5NeFRmM0RQT241UXRBdGxOWFQ0MUtES3Fm?=
 =?utf-8?B?bnhySTgvbTFxc3VITkJQZUUvZFpUbWkzNzFQU3JhcmVaZ2RrUGV1c0hHRmFI?=
 =?utf-8?B?Z2RKKzl0c3AxNkJSdGt6VXdSQzBDT0h0SDNtK0Z0VnN4OW53RXd2SFN4UkU0?=
 =?utf-8?B?cm5JYkJDZWZjYXgyblJzcVdTQnR1OXk5eXY4T1pPcU9FbWFzWUgvdGNvdGh6?=
 =?utf-8?B?Nmc5WENyWEZHcVcxNjNCMWtTOVU5VXN2bmhxbU9EdVR3b1FhM3VKU1pQblc3?=
 =?utf-8?B?bnNGOE5qYVJkMUpKQmVOb3BUUzZPS3VDcFBFU0J1TDhmVmFmYWdFQ21WQVBa?=
 =?utf-8?B?cnA2bUFLVVh3RkhNTlowTXRwcldqTmxWMHVZbXd6akVmTW5sNllpY0Q0SXpa?=
 =?utf-8?B?c3RENFkxZXZzdi96UTVLVXBtckZMQVAxOGJYMXNiVldQaHN2ZVpRd0ZPQ0dF?=
 =?utf-8?B?eUFkOWxlZk1YdUFzTElkQWJKaWFRdWFnaFUzeDVXdW1ZT1N2cDRTWlk5Um52?=
 =?utf-8?B?aEtZWG5EbjNCQWQyVkc2eFJvazdYSm4yMVVuZUdLTUYvbytvZ1JoRTR6K1d0?=
 =?utf-8?B?N1BpRVQ0ZkhzZE01K1JQM00zdHJYc3IySEhEZzdTQ0Q3eVJBcDlNblloU0My?=
 =?utf-8?B?Z1dUVlNwaUhmczNEcGc3MTdwUmVLVStIZnUwWEtlV1pXb0hPVG1jT003bUM3?=
 =?utf-8?B?R1BpWXZZNTNzTVIyNlpmcjU2YXNLb1pDUVcrV1I3b2pHbFd0OEp4VTN3c0tM?=
 =?utf-8?B?UHF2Q255RDBFcGRtMTFsMFBKV1VyakV4NFkzbkNMMzdEUkJpTkVBMWIwSU9q?=
 =?utf-8?B?SWhqdzRudTBiUmcya2xmWTJPQldSbXFXa1BDVUllT1VXVG1va0JDMHFGekRF?=
 =?utf-8?B?VVU5S1owVkhGRTQ0Vm1IeUdSZDhsemJuRTg4aGh2N3FuWnpuazVpUDlabXhT?=
 =?utf-8?B?OFpGNjhneElwS2MwKys1Y1pTOWxlNlRXcUVtQjZkei9kbk9OYWFYQnp1bWUw?=
 =?utf-8?B?eXFoZkhuNHNESkFCUTJxbFZlaTlQYU1JSVJZMDRlZk5HMVN0TXhUV0ZDaXJU?=
 =?utf-8?Q?ppba+szy5b/so=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b0758f5-fed8-4a2f-5a8e-08d89dcee7de
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2020 12:18:45.1091
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 90Qs6aiD4kRMsujoxIb17bydMgy6G+3mX1qqodtZhesfQuxEfT/PNpkukqhAjUGLMvy0yCPl+n0H55SgVcg03w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6972
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEppc2hlbmcgWmhhbmcgPEpp
c2hlbmcuWmhhbmdAc3luYXB0aWNzLmNvbT4NCj4gU2VudDogMjAyMOW5tDEy5pyIMTDml6UgMTc6
MDMNCj4gVG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+DQo+IENjOiBw
ZXBwZS5jYXZhbGxhcm9Ac3QuY29tOyBhbGV4YW5kcmUudG9yZ3VlQHN0LmNvbTsNCj4gam9hYnJl
dUBzeW5vcHN5cy5jb207IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsNCj4g
bmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhwLmNvbT4N
Cj4gU3ViamVjdDogUmU6IFtQQVRDSCBSRkNdIGV0aGVybmV0OiBzdG1tYWM6IGNsZWFuIHVwIHRo
ZSBjb2RlIGZvcg0KPiByZWxlYXNlL3N1c3BlbmQvcmVzdW1lIGZ1bmN0aW9uDQo+ID4gPiA+IC0t
LSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19tYWluLmMNCj4g
PiA+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjX21h
aW4uYw0KPiA+ID4gPiBAQCAtMjkwOCw4ICsyOTA4LDcgQEAgc3RhdGljIGludCBzdG1tYWNfcmVs
ZWFzZShzdHJ1Y3QgbmV0X2RldmljZQ0KPiAqZGV2KQ0KPiA+ID4gPiAgICAgICAgIHN0cnVjdCBz
dG1tYWNfcHJpdiAqcHJpdiA9IG5ldGRldl9wcml2KGRldik7DQo+ID4gPiA+ICAgICAgICAgdTMy
IGNoYW47DQo+ID4gPiA+DQo+ID4gPiA+IC0gICAgICAgaWYgKGRldmljZV9tYXlfd2FrZXVwKHBy
aXYtPmRldmljZSkpDQo+ID4gPg0KPiA+ID4gVGhpcyBjaGVjayBpcyB0byBwcmV2ZW50IGxpbmsg
c3BlZWQgZG93biBpZiB0aGUgc3RtbWFjIGlzbid0IGEgd2FrZXVwDQo+IGRldmljZS4NCj4gPg0K
PiA+IFdoZW4gd2UgaW52b2tlIC5uZG9fc3RvcCwgd2UgZG93biB0aGUgbmV0IGRldmljZS4gUGVy
IG15IHVuZGVyc3RhbmRpbmcsDQo+IHdlIGNhbiBzcGVlZCBkb3duIHRoZSBwaHksIG5vIG1hdHRl
ciBpdCBpcyBhIHdha2V1cCBkZXZpY2Ugb3Igbm90Lg0KPiANCj4gVGhlIHByb2JsZW0gaXMgaWYg
dGhlIGRldmljZSBjYW4ndCB3YWtlIHVwLCB0aGVuIHBoeSBsaW5rIHdpbGwgYmUgdHVybmVkIG9m
ZiBObw0KPiBuZWVkIHRvIHNwZWVkIGRvd24gdGhlIHBoeSBiZWZvcmUgdHVybmluZyBvZmYgaXQu
DQoNClllcywgaXQgbWFrZXMgc2Vuc2UuIFRoYW5rcyBmb3IgeW91ciBleHBsYW5hdGlvbi4NCg0K
RG8geW91IGVuY291bnRlciBkZXZfd2F0Y2hkb2cgdGltZW91dCBhZnRlciBhIGZldyBodW5kcmVk
IHRpbWVzIHN1c3BlbmQvcmVzdW1lIHN0cmVzcyB0aW1lIHdpdGggc3RtbWFjIGRyaXZlcj8NCkkg
YW0gbm90IGZhbWlsaWFyIHdpdGggZXRoZXJuZXQgZHJpdmVyIG5vdywgY291bGQgeW91IGdpdmUg
bWUgc29tZSBzdWdnZXN0aW9ucz8gVGhpcyBpc3N1ZSBzZWVtcyBtb3JlIHJlbGF0ZWQgdG8gc3Rt
bWFjIGNvcmUgZHJpdmVyLg0KDQpbICAzMDUuMjczOTM1XSBJUHY2OiBBRERSQ09ORihORVRERVZf
Q0hBTkdFKTogZXRoMDogbGluayBiZWNvbWVzIHJlYWR5DQpbICAzMTUuOTgzNDc0XSAtLS0tLS0t
LS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0NClsgIDMxNS45ODgxNThdIE5FVERFViBXQVRD
SERPRzogZXRoMCAoaW14LWR3bWFjKTogdHJhbnNtaXQgcXVldWUgMCB0aW1lZCBvdXQNClsgIDMx
NS45OTUwNDRdIFdBUk5JTkc6IENQVTogMCBQSUQ6IDAgYXQgbmV0L3NjaGVkL3NjaF9nZW5lcmlj
LmM6NDUwIGRldl93YXRjaGRvZysweDJmYy8weDMwYw0KWyAgMzE2LjAwMzMxNV0gTW9kdWxlcyBs
aW5rZWQgaW46DQpbICAzMTYuMDA2Mzg5XSBDUFU6IDAgUElEOiAwIENvbW06IHN3YXBwZXIvMCBO
b3QgdGFpbnRlZCA1LjEwLjAtcmM2LTA0NDUxLWc4ZmYyNmY1YWY4M2ItZGlydHkgIzU1DQpbICAz
MTYuMDE1MDEyXSBIYXJkd2FyZSBuYW1lOiBGcmVlc2NhbGUgaS5NWDhEWEwgRVZLIChEVCkNClsg
IDMxNi4wMjAxNThdIHBzdGF0ZTogMjAwMDAwMDUgKG56Q3YgZGFpZiAtUEFOIC1VQU8gLVRDTyBC
VFlQRT0tLSkNClsgIDMxNi4wMjYxNzhdIHBjIDogZGV2X3dhdGNoZG9nKzB4MmZjLzB4MzBjDQpb
ICAzMTYuMDMwMTk4XSBsciA6IGRldl93YXRjaGRvZysweDJmYy8weDMwYw0KWyAgMzE2LjAzNDIw
OF0gc3AgOiBmZmZmODAwMDExYzdiZDkwDQpbICAzMTYuMDM3NTI4XSB4Mjk6IGZmZmY4MDAwMTFj
N2JkOTAgeDI4OiBmZmZmMDAwMDE2OTViOTQwDQpbICAzMTYuMDQyODUyXSB4Mjc6IDAwMDAwMDAw
MDAwMDAwMDQgeDI2OiBmZmZmMDAwMDE2ZGQ4NDgwDQpbICAzMTYuMDQ4MTc4XSB4MjU6IDAwMDAw
MDAwMDAwMDAxNDAgeDI0OiAwMDAwMDAwMGZmZmZmZmZmDQpbICAzMTYuMDUzNTA0XSB4MjM6IGZm
ZmYwMDAwMTZkZDgzZGMgeDIyOiAwMDAwMDAwMDAwMDAwMDAwDQpbICAzMTYuMDU4ODI3XSB4MjE6
IGZmZmY4MDAwMTFhNzYwMDAgeDIwOiBmZmZmMDAwMDE2ZGQ4MDAwDQpbICAzMTYuMDY0MTU0XSB4
MTk6IDAwMDAwMDAwMDAwMDAwMDAgeDE4OiAwMDAwMDAwMDAwMDAwMDMwDQpbICAzMTYuMDY5NDgw
XSB4MTc6IDAwMDAwMDAwMDAwMDAwMDAgeDE2OiAwMDAwMDAwMDAwMDAwMDAwDQpbICAzMTYuMDc0
ODA1XSB4MTU6IGZmZmY4MDAwMTFhODI3MzggeDE0OiBmZmZmZmZmZmZmZmZmZmZmDQpbICAzMTYu
MDgwMTMzXSB4MTM6IGZmZmY4MDAwMTFhOTE2NzggeDEyOiAwMDAwMDAwMDAwMDAyMDYxDQpbICAz
MTYuMDg1NDU2XSB4MTE6IDAwMDAwMDAwMDAwMDBhY2IgeDEwOiBmZmZmODAwMDExYWU5Njc4DQpb
ICAzMTYuMDkwNzgxXSB4OSA6IDAwMDAwMDAwZmZmZmYwMDAgeDggOiBmZmZmODAwMDExYTkxNjc4
DQpbICAzMTYuMDk2MTA3XSB4NyA6IGZmZmY4MDAwMTFhZTk2NzggeDYgOiAwMDAwMDAwMDAwMDAw
MDAzDQpbICAzMTYuMTAxNDMyXSB4NSA6IDAwMDAwMDAwMDAwMDAwMDAgeDQgOiAwMDAwMDAwMDAw
MDAwMDAwDQpbICAzMTYuMTA2NzU4XSB4MyA6IDAwMDAwMDAwMDAwMDAwMDAgeDIgOiAwMDAwMDAw
MDAwMDAwMTAwDQpbICAzMTYuMTEyMDgxXSB4MSA6IDcyOTBlOTE1YWEwZDViMDAgeDAgOiAwMDAw
MDAwMDAwMDAwMDAwDQpbICAzMTYuMTE3NDA5XSBDYWxsIHRyYWNlOg0KWyAgMzE2LjExOTg2Nl0g
IGRldl93YXRjaGRvZysweDJmYy8weDMwYw0KWyAgMzE2LjEyMzU0Ml0gIGNhbGxfdGltZXJfZm4u
Y29uc3Rwcm9wLjArMHgyNC8weDgwDQpbICAzMTYuMTI4MTcxXSAgX19ydW5fdGltZXJzLnBhcnQu
MCsweDFmMC8weDIyNA0KWyAgMzE2LjEzMjQ1MV0gIHJ1bl90aW1lcl9zb2Z0aXJxKzB4M2MvMHg3
Yw0KWyAgMzE2LjEzNjM4MF0gIGVmaV9oZWFkZXJfZW5kKzB4MTI0LzB4MjkwDQpbICAzMTYuMTQw
MjI3XSAgaXJxX2V4aXQrMHhkYy8weGZjDQpbICAzMTYuMTQzMzcxXSAgX19oYW5kbGVfZG9tYWlu
X2lycSsweDgwLzB4ZTANClsgIDMxNi4xNDc0NzNdICBnaWNfaGFuZGxlX2lycSsweGMwLzB4MTQw
DQpbICAzMTYuMTUxMjMyXSAgZWwxX2lycSsweGJjLzB4MTgwDQpbICAzMTYuMTU0Mzc5XSAgYXJj
aF9jcHVfaWRsZSsweDE0LzB4MWMNClsgIDMxNi4xNTc5NTldICBkb19pZGxlKzB4MjMwLzB4MmEw
DQpbICAzMTYuMTYxMTkwXSAgY3B1X3N0YXJ0dXBfZW50cnkrMHgyOC8weDcwDQpbICAzMTYuMTY1
MTE2XSAgcmVzdF9pbml0KzB4ZDgvMHhlOA0KWyAgMzE2LjE2ODM1MF0gIGFyY2hfY2FsbF9yZXN0
X2luaXQrMHgxMC8weDFjDQpbICAzMTYuMTcyNDU4XSAgc3RhcnRfa2VybmVsKzB4NGJjLzB4NGY0
DQpbICAzMTYuMTc2MTIxXSAtLS1bIGVuZCB0cmFjZSBhMDMxMTIyN2U0MThhNjcyIF0tLS0NCg0K
DQo+IFBTOiBJdCBzZWVtcyB5b3VyIGVtYWlsIGNsaWVudCBpc24ndCBwcm9wZXJseSBzZXR1cC4u
DQpEbyB5b3UgbWVhbiBtYWlsIHRpbWVzdGFtcD8NCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpo
YW5nDQo=
