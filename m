Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D260E327CB6
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 11:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232791AbhCAK6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 05:58:36 -0500
Received: from mail-eopbgr50074.outbound.protection.outlook.com ([40.107.5.74]:24962
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232596AbhCAK5t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 05:57:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DUuRODIfqBzW0J1Dqd3WM8gvpMcy9TFOnaeHK7I5D0oeJS+cgSjfhIXtd6DKnZugkgcmHXj+SzHTByYoNmtGNIWsI43/itd2X2uvxYY8V6q8aW7cEl2RGkZ3ld9irSr4rSsViHG74TAQwt9KJX+Ux4Bi2mwAQn/Vh2fWsNc+upRcwSnbf0XI3wqA60fnBFZxDFAvGOHRAKPeJE1gOVdamvxmfvrPGxWau+sl6l11aOKtS2hNcSLuyCLdzhR0YsGg6K4sDfbQuhezARS2XLtXG24EskV9lFD2haeK2OErI8StNvwayY13bd3Kex/93X2vAhmFu6/AJxeVxsXAKf0uZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wUKc5d0TFZ2wa4EnRvMYQubEw7WgJ/36eYKg6dnqFnw=;
 b=nE/EQBPqzVwZ0zDkBpUkpd3aHOKxv1HcBKADyJ2NgJ2ahmVf7SCEk8B69wNTaksQ1JSC5BdRKkrWVgI4fobvOf2ORqGEXpieDtoWt5ZdVeRKVroeS1DNaTk1NShLHqE2g4Bv8had47r0G9vmHjgxEzW2SEjRA4SxEawJRyn3PUn3j4LYBMbB3CYqlKFA6D8Y+2fgKl0tgNINDUCK+sd+oWrUxS836xed3NtenocTC23IsqZwNtzp8zLupIMnJl92Ane8weLr9/bTvpN4cU+iT+G8Qg6rWUtSLCar+L+SC+XIDTYTNG49qbArUtXva0jVLJuC9cuq3ZE4zS4aWL6EMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wUKc5d0TFZ2wa4EnRvMYQubEw7WgJ/36eYKg6dnqFnw=;
 b=gehSEdTWLZ2H4Q0DlBSV5rfs/o9bQ/Fp60iZXAsyiTevYOCSG9lmip8vT4gMHm0b3vmGJHAqEc2fvsm3Z6rMU3GkeH5NrvN9oP8UCZ2HBWNSGQmRlZAjBTEDMWjNvfLudcbMHIe7fqQcU1x/FsWQqMZe2d9YtHn1jkPetETtidc=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB5306.eurprd04.prod.outlook.com (2603:10a6:10:1f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.33; Mon, 1 Mar
 2021 10:56:58 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 10:56:58 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Robin van der Gracht <robin@protonic.nl>
CC:     Andre Naujoks <nautsch2@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net v4 1/1] can: can_skb_set_owner(): fix ref counting if
 socket was closed before setting skb ownership
Thread-Topic: [PATCH net v4 1/1] can: can_skb_set_owner(): fix ref counting if
 socket was closed before setting skb ownership
Thread-Index: AQHXDCHTtD8a1IStAEOrE/v6wJPl7Kpu+jmA
Date:   Mon, 1 Mar 2021 10:56:58 +0000
Message-ID: <DB8PR04MB6795A03ADFAE983568087CB3E69A9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210226092456.27126-1-o.rempel@pengutronix.de>
In-Reply-To: <20210226092456.27126-1-o.rempel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8b437b53-12fe-4485-e5ae-08d8dca0bc4b
x-ms-traffictypediagnostic: DB7PR04MB5306:
x-microsoft-antispam-prvs: <DB7PR04MB53064E2D3EDAC2872C792BFAE69A9@DB7PR04MB5306.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Yx9dcJUDbf5iwFi5OjkeIHlELfZYr37diMTMoeXx+0cNZ5VMSl02gBlUTSjSMd9GEM28pwBkOjKRENfHbBQEP+xdsCdkfxPDX6Y3V7hqEH5T290odslAfDKaO2hxYNULf4CSqATdnnpOZ4jAvGDKCHauNlpXsHLntf4jXzRuw86icxaMis1H1JXAW3Yv59xTiyeIykxQOm2SExUNQiuVTwQrDBBErhYL2PIs3kc5wFZXeuZrHwVyK6G1LF/LkBOdhvQgJ6wg0A9r+HebM/7+JbsS26SaS5pAXWAwZdGMEYJMCl7SBQ/skFNwK0duJdjfxw6cgPON+vOb6sQKSn5LMoeRp5MxCTCnDoGjAcKOmOAYHI6Xckp6cIsjgGYZhQtpgP/FutpnoI3HENI+rPXw/m2ybaZfQabbQaC7E0BbQp5CjDdQe4wRHxMtjItN4rJj7W6MUFitT//jgmWR03lnLmdpE2CE9+lvhHFN3645718Kh+4l/kpn4MDX9GOCAj+9xQMu6DsFhR925Ie9yxBrOQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(39860400002)(376002)(366004)(76116006)(316002)(186003)(8936002)(26005)(9686003)(4326008)(66446008)(71200400001)(66946007)(66476007)(6506007)(55016002)(7416002)(478600001)(33656002)(86362001)(52536014)(7696005)(5660300002)(2906002)(66556008)(110136005)(8676002)(54906003)(83380400001)(64756008)(45080400002)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?RzJ0TERkOTRpbmFJRHZYcFY4WFFvYXVnQkNaMWxlZnc3MWRUQVNSeHd4TGQ0?=
 =?utf-8?B?UGtGSXB0Y1NTVnBkckJmSU1TWkpXbWRQMlNCemtOUUY5aXlNcUZjS3k3VjRk?=
 =?utf-8?B?ZElOYTlxdDZrVmMyalFOQmRPNWtWV2x5Z1hHYjhUeXdIMTR1UEZJakJOUGZ0?=
 =?utf-8?B?WkI4MW91c20rU3A0REdKQnc3T1laNEZlOTVKaXJQekxKQXFoOTN3UmtlWGEz?=
 =?utf-8?B?UFpwYTRWKzlVY21XTVpQamthRjFLbS9xY3BKS2NleDJlbmpEOFo4QXNVck5r?=
 =?utf-8?B?akc3VUZRQk93MVBmdmZQOWYvZG5sRUtBT1ptUEhqSVdRbUU0Sm83Zm1RdEZL?=
 =?utf-8?B?bE1LQXRIRHJaTGhmYyt6TUdZQ2pXZ09lbjB1VExvN0VvcUxMNGYrVmpNS01W?=
 =?utf-8?B?TkdJZlpGREsxSmY5OWFBaTdlci8zaENpYUhsQ3lhM0wxK21tOHVsMkp5Yncr?=
 =?utf-8?B?dktVb2hGd1FhcTB1c2JHT0VUYmZFL3YrV3Q2a0lXVUIvTnBMMmRkWVlLUjNL?=
 =?utf-8?B?dUs5Zk9kalYrUENteWsrSk1uL25VUTNUejNmUW53d25SWDJZZU5qMDhYbmVX?=
 =?utf-8?B?SktpNHNzWm9Wd3QxcVhHdjhjbGhsZGxUOXBEdndDQWwxM21TbGkxa09VYnJp?=
 =?utf-8?B?cENQb1dFZ2twQXB6N0JST1pyUVpVZVRmM0k2Mzd5dlk0MEIrdHQ4VWNKaWkx?=
 =?utf-8?B?NkhESUdiZGF6L00xbktvY3ozamFMNjVMTEZldzlQcXhOT2k3K2VRS3Q4akpT?=
 =?utf-8?B?Qm9NMTA5RXZmVk42a0k1bmdxSHhaVGhNZjBiMi9jb3pWdEc3Znp6NFV2S2hF?=
 =?utf-8?B?aHBJYU5DTG1hTWNvbmluTFlhemFPWjEya3dPNm44NnZIckU1TnREVEtTU0ZX?=
 =?utf-8?B?SmJPS0o1Uzl5aHg1dDBtVVlJL3VZY1FBRFF4UUcvRWtkRzhVTURBWXQyV0RX?=
 =?utf-8?B?elJ1K00ycXRJaCtpSjFuRjNDcFFTZlJqd0RyV0dyY1pPOUl2NEkxS0s0dVFp?=
 =?utf-8?B?OXdZQXVpZWJJSzBGRTM1WHdUUmdacUZKSTRySjk2ek5DMVcycTFjanhnc01j?=
 =?utf-8?B?bUFKYUd5UjhIYkxpTG9xNWkvRFZ6cTZvL3Zya3VQUnFkYzVIZ3dZbjgxNWhn?=
 =?utf-8?B?TWhBN3RSZk1DM0FuaVZvUzJOWWpnS0ZYYUJIZnpucnZCdFFrUHJLNi9vSmJZ?=
 =?utf-8?B?TGtiZXNhRFE5TTJDekVPMlV0clptR3o0ZEJyMFJRZkJiL29NVGFXNzZtbU9r?=
 =?utf-8?B?TVlITTNsaHlpSVZ4OEdNVmdhUG5LMmhXZnBSTkdvU2k5cjdxRVpHOUU5M1Zk?=
 =?utf-8?B?aE1pRDl1dWN2T2R1M2N0ZnY1MEEwNHJpN2hCdzAzVlpaZmZIRGRCTW5XbFN5?=
 =?utf-8?B?d21Jc1VqdTRDem1ja1RKUkd5b21xOU1QZG1pNkZqcit6WjQ2L3VDcFVhdlAy?=
 =?utf-8?B?eGRpajBOOGRQWmg5SG9iL3BsSllGY2taWWVLbncraFVzemVQV3ZEWkdHQzdi?=
 =?utf-8?B?R0wwREJtZXZzakZHd3ltaFNTU0I1Q3JqT0RzNy9vdGQ1R2V5dzNRWjNmelE5?=
 =?utf-8?B?R0VMR1B6T1NacXZ0b3p2bjBkOVZjaDBEWkxtNWYvU09RQmFCRHQ1d0dUSVll?=
 =?utf-8?B?bnVoRWJEL3l6dmRYSG5QeUVHNGpTa1c2VldralpsQ1VkQ1RwUi9ObDFGVEdR?=
 =?utf-8?B?QU53N1hLUXR4bEFTbEhHc25kWk1lOGJUZ0xqVm9abnF3ZzJvZnpSdjVZZGxV?=
 =?utf-8?Q?/D2hmWccj1CgUBC3r4=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b437b53-12fe-4485-e5ae-08d8dca0bc4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 10:56:58.4306
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3UXXZdHCS0uZHoP+HQRVokuY+11n3ZJKnx8lwyo1QK+m26+Yk1dbG3WCSo9UNVUUqF8EThKDqDV7SHb7DFF9fQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5306
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE9sZWtzaWogUmVtcGVsIDxv
LnJlbXBlbEBwZW5ndXRyb25peC5kZT4NCj4gU2VudDogMjAyMeW5tDLmnIgyNuaXpSAxNzoyNQ0K
PiBUbzogbWtsQHBlbmd1dHJvbml4LmRlOyBEYXZpZCBTLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9m
dC5uZXQ+OyBKYWt1Yg0KPiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgT2xpdmVyIEhhcnRr
b3BwIDxzb2NrZXRjYW5AaGFydGtvcHAubmV0PjsNCj4gUm9iaW4gdmFuIGRlciBHcmFjaHQgPHJv
YmluQHByb3RvbmljLm5sPg0KPiBDYzogT2xla3NpaiBSZW1wZWwgPG8ucmVtcGVsQHBlbmd1dHJv
bml4LmRlPjsgQW5kcmUgTmF1am9rcw0KPiA8bmF1dHNjaDJAZ21haWwuY29tPjsgRXJpYyBEdW1h
emV0IDxlZHVtYXpldEBnb29nbGUuY29tPjsNCj4ga2VybmVsQHBlbmd1dHJvbml4LmRlOyBsaW51
eC1jYW5Admdlci5rZXJuZWwub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1r
ZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFtQQVRDSCBuZXQgdjQgMS8xXSBjYW46
IGNhbl9za2Jfc2V0X293bmVyKCk6IGZpeCByZWYgY291bnRpbmcgaWYgc29ja2V0DQo+IHdhcyBj
bG9zZWQgYmVmb3JlIHNldHRpbmcgc2tiIG93bmVyc2hpcA0KPiANCj4gVGhlcmUgYXJlIHR3byBy
ZWYgY291bnQgdmFyaWFibGVzIGNvbnRyb2xsaW5nIHRoZSBmcmVlKClpbmcgb2YgYSBzb2NrZXQ6
DQo+IC0gc3RydWN0IHNvY2s6OnNrX3JlZmNudCAtIHdoaWNoIGlzIGNoYW5nZWQgYnkgc29ja19o
b2xkKCkvc29ja19wdXQoKQ0KPiAtIHN0cnVjdCBzb2NrOjpza193bWVtX2FsbG9jIC0gd2hpY2gg
YWNjb3VudHMgdGhlIG1lbW9yeSBhbGxvY2F0ZWQgYnkNCj4gICB0aGUgc2ticyBpbiB0aGUgc2Vu
ZCBwYXRoLg0KPiANCj4gSW4gY2FzZSB0aGVyZSBhcmUgc3RpbGwgVFggc2ticyBvbiB0aGUgZmx5
IGFuZCB0aGUgc29ja2V0KCkgaXMgY2xvc2VkLCB0aGUgc3RydWN0DQo+IHNvY2s6OnNrX3JlZmNu
dCByZWFjaGVzIDAuIEluIHRoZSBUWC1wYXRoIHRoZSBDQU4gc3RhY2sgY2xvbmVzIGFuICJlY2hv
IiBza2IsDQo+IGNhbGxzIHNvY2tfaG9sZCgpIG9uIHRoZSBvcmlnaW5hbCBzb2NrZXQgYW5kIHJl
ZmVyZW5jZXMgaXQuIFRoaXMgcHJvZHVjZXMgdGhlDQo+IGZvbGxvd2luZyBiYWNrIHRyYWNlOg0K
PiANCj4gfCBXQVJOSU5HOiBDUFU6IDAgUElEOiAyODAgYXQgbGliL3JlZmNvdW50LmM6MjUNCj4g
fCByZWZjb3VudF93YXJuX3NhdHVyYXRlKzB4MTE0LzB4MTM0DQo+IHwgcmVmY291bnRfdDogYWRk
aXRpb24gb24gMDsgdXNlLWFmdGVyLWZyZWUuDQo+IHwgTW9kdWxlcyBsaW5rZWQgaW46IGNvZGFf
dnB1KEUpIHY0bDJfanBlZyhFKSB2aWRlb2J1ZjJfdm1hbGxvYyhFKQ0KPiBpbXhfdmRvYShFKQ0K
PiB8IENQVTogMCBQSUQ6IDI4MCBDb21tOiB0ZXN0X2Nhbi5zaCBUYWludGVkOiBHICAgICAgICAg
ICAgRQ0KPiA1LjExLjAtMDQ1NzctZ2Y4ZmY2NjAzYzYxNyAjMjAzDQo+IHwgSGFyZHdhcmUgbmFt
ZTogRnJlZXNjYWxlIGkuTVg2IFF1YWQvRHVhbExpdGUgKERldmljZSBUcmVlKQ0KPiB8IEJhY2t0
cmFjZToNCj4gfCBbPDgwYmFmZWE0Pl0gKGR1bXBfYmFja3RyYWNlKSBmcm9tIFs8ODBiYjAyODA+
XSAoc2hvd19zdGFjaysweDIwLzB4MjQpDQo+IHwgcjc6MDAwMDAwMDAgcjY6NjAwZjAxMTMgcjU6
MDAwMDAwMDAgcjQ6ODE0NDEyMjAgWzw4MGJiMDI2MD5dDQo+IHwgKHNob3dfc3RhY2spIGZyb20g
Wzw4MGJiNTkzYz5dIChkdW1wX3N0YWNrKzB4YTAvMHhjOCkgWzw4MGJiNTg5Yz5dDQo+IHwgKGR1
bXBfc3RhY2spIGZyb20gWzw4MDEyYjI2OD5dIChfX3dhcm4rMHhkNC8weDExNCkgcjk6MDAwMDAw
MTkNCj4gfCByODo4MGY0YThjMiByNzo4M2U0MTUwYyByNjowMDAwMDAwMCByNTowMDAwMDAwOSBy
NDo4MDUyOGY5MA0KPiB8IFs8ODAxMmIxOTQ+XSAoX193YXJuKSBmcm9tIFs8ODBiYjA5YzQ+XSAo
d2Fybl9zbG93cGF0aF9mbXQrMHg4OC8weGM4KQ0KPiB8IHI5OjgzZjI2NDAwIHI4OjgwZjRhOGQx
IHI3OjAwMDAwMDA5IHI2OjgwNTI4ZjkwIHI1OjAwMDAwMDE5DQo+IHwgcjQ6ODBmNGE4YzIgWzw4
MGJiMDk0MD5dICh3YXJuX3Nsb3dwYXRoX2ZtdCkgZnJvbSBbPDgwNTI4ZjkwPl0NCj4gfCAocmVm
Y291bnRfd2Fybl9zYXR1cmF0ZSsweDExNC8weDEzNCkgcjg6MDAwMDAwMDAgcjc6MDAwMDAwMDAN
Cj4gfCByNjo4MmI0NDAwMCByNTo4MzRlNTYwMCByNDo4M2Y0ZDU0MCBbPDgwNTI4ZTdjPl0NCj4g
fCAocmVmY291bnRfd2Fybl9zYXR1cmF0ZSkgZnJvbSBbPDgwNzlhNGM4Pl0NCj4gfCAoX19yZWZj
b3VudF9hZGQuY29uc3Rwcm9wLjArMHg0Yy8weDUwKQ0KPiB8IFs8ODA3OWE0N2M+XSAoX19yZWZj
b3VudF9hZGQuY29uc3Rwcm9wLjApIGZyb20gWzw4MDc5YTU3Yz5dDQo+IHwgKGNhbl9wdXRfZWNo
b19za2IrMHhiMC8weDEzYykgWzw4MDc5YTRjYz5dIChjYW5fcHV0X2VjaG9fc2tiKSBmcm9tDQo+
IHwgWzw4MDc5YmE5OD5dIChmbGV4Y2FuX3N0YXJ0X3htaXQrMHgxYzQvMHgyMzApIHI5OjAwMDAw
MDEwIHI4OjgzZjQ4NjEwDQo+IHwgcjc6MGZkYzAwMDAgcjY6MGMwODAwMDAgcjU6ODJiNDQwMDAg
cjQ6ODM0ZTU2MDAgWzw4MDc5YjhkND5dDQo+IHwgKGZsZXhjYW5fc3RhcnRfeG1pdCkgZnJvbSBb
PDgwOTY5MDc4Pl0gKG5ldGRldl9zdGFydF94bWl0KzB4NDQvMHg3MCkNCj4gfCByOTo4MTRjMGJh
MCByODo4MGM4NzkwYyByNzowMDAwMDAwMCByNjo4MzRlNTYwMCByNTo4MmI0NDAwMA0KPiB8IHI0
OjgyYWIxZjAwIFs8ODA5NjkwMzQ+XSAobmV0ZGV2X3N0YXJ0X3htaXQpIGZyb20gWzw4MDk3MjVh
ND5dDQo+IHwgKGRldl9oYXJkX3N0YXJ0X3htaXQrMHgxOWMvMHgzMTgpIHI5OjgxNGMwYmEwIHI4
OjAwMDAwMDAwIHI3OjgyYWIxZjAwDQo+IHwgcjY6ODJiNDQwMDAgcjU6MDAwMDAwMDAgcjQ6ODM0
ZTU2MDAgWzw4MDk3MjQwOD5dIChkZXZfaGFyZF9zdGFydF94bWl0KQ0KPiB8IGZyb20gWzw4MDlj
NjU4ND5dIChzY2hfZGlyZWN0X3htaXQrMHhjYy8weDI2NCkgcjEwOjgzNGU1NjAwDQo+IHwgcjk6
MDAwMDAwMDAgcjg6MDAwMDAwMDAgcjc6ODJiNDQwMDAgcjY6ODJhYjFmMDAgcjU6ODM0ZTU2MDAN
Cj4gfCByNDo4M2YyNzQwMCBbPDgwOWM2NGI4Pl0gKHNjaF9kaXJlY3RfeG1pdCkgZnJvbSBbPDgw
OWM2YzBjPl0NCj4gfCAoX19xZGlzY19ydW4rMHg0ZjAvMHg1MzQpDQo+IA0KPiBUbyBmaXggdGhp
cyBwcm9ibGVtLCBvbmx5IHNldCBza2Igb3duZXJzaGlwIHRvIHNvY2tldHMgd2hpY2ggaGF2ZSBz
dGlsbCBhIHJlZg0KPiBjb3VudCA+IDAuDQo+IA0KPiBDYzogT2xpdmVyIEhhcnRrb3BwIDxzb2Nr
ZXRjYW5AaGFydGtvcHAubmV0Pg0KPiBDYzogQW5kcmUgTmF1am9rcyA8bmF1dHNjaDJAZ21haWwu
Y29tPg0KPiBTdWdnZXN0ZWQtYnk6IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT4N
Cj4gRml4ZXM6IDBhZTg5YmViMjgzYSAoImNhbjogYWRkIGRlc3RydWN0b3IgZm9yIHNlbGYgZ2Vu
ZXJhdGVkIHNrYnMiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBPbGVrc2lqIFJlbXBlbCA8by5yZW1wZWxA
cGVuZ3V0cm9uaXguZGU+DQoNCkkgd2lsbCBnaXZlIG91dCBhIHRlc3QgcmVzdWx0IHRvbW9ycm93
IHdoZW4gdGhlIGJvYXJkIGlzIGF2YWlsYWJsZS4g8J+Yig0KDQpCZXN0IFJlZ2FyZHMsDQpKb2Fr
aW0gWmhhbmcNCj4gLS0tDQo+ICBpbmNsdWRlL2xpbnV4L2Nhbi9za2IuaCB8IDggKysrKysrLS0N
Cj4gIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9jYW4vc2tiLmggYi9pbmNsdWRlL2xpbnV4L2Nh
bi9za2IuaCBpbmRleA0KPiA2ODVmMzRjZmJhMjAuLmQ4MjAxOGNjMGQwYiAxMDA2NDQNCj4gLS0t
IGEvaW5jbHVkZS9saW51eC9jYW4vc2tiLmgNCj4gKysrIGIvaW5jbHVkZS9saW51eC9jYW4vc2ti
LmgNCj4gQEAgLTY1LDggKzY1LDEyIEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBjYW5fc2tiX3Jlc2Vy
dmUoc3RydWN0IHNrX2J1ZmYgKnNrYikNCj4gDQo+ICBzdGF0aWMgaW5saW5lIHZvaWQgY2FuX3Nr
Yl9zZXRfb3duZXIoc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IHNvY2sgKnNrKSAgew0KPiAt
CWlmIChzaykgew0KPiAtCQlzb2NrX2hvbGQoc2spOw0KPiArCS8qDQo+ICsJICogSWYgdGhlIHNv
Y2tldCBoYXMgYWxyZWFkeSBiZWVuIGNsb3NlZCBieSB1c2VyIHNwYWNlLCB0aGUgcmVmY291bnQg
bWF5DQo+ICsJICogYWxyZWFkeSBiZSAwIChhbmQgdGhlIHNvY2tldCB3aWxsIGJlIGZyZWVkIGFm
dGVyIHRoZSBsYXN0IFRYIHNrYiBoYXMNCj4gKwkgKiBiZWVuIGZyZWVkKS4gU28gb25seSBpbmNy
ZWFzZSBzb2NrZXQgcmVmY291bnQgaWYgdGhlIHJlZmNvdW50IGlzID4gMC4NCj4gKwkgKi8NCj4g
KwlpZiAoc2sgJiYgcmVmY291bnRfaW5jX25vdF96ZXJvKCZzay0+c2tfcmVmY250KSkgew0KPiAg
CQlza2ItPmRlc3RydWN0b3IgPSBzb2NrX2VmcmVlOw0KPiAgCQlza2ItPnNrID0gc2s7DQo+ICAJ
fQ0KPiAtLQ0KPiAyLjI5LjINCg0K
