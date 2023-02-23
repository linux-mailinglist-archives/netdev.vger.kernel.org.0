Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93D796A0C6A
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 16:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234224AbjBWPCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 10:02:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjBWPB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 10:01:59 -0500
Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2035.outbound.protection.outlook.com [40.92.103.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B29D311E5;
        Thu, 23 Feb 2023 07:01:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PC2B5ems2m55Jsl11su6niZ1QF2fe5z187d3KUjkcHjG0CM6sIRHOG5ICRGwAFGCX4ToE8r6VysfEng9MxwxucjQrzfwqAqtvv27z00nikZpYFw0sM6wYUuMKDMgMhUKr8/gnmoNMaGBdi4p+2tjlY2it42GYwRIJK5DLb+gZ54CWDJiwEQXqc6rkBTmABzSHFgLfURNnWyHBWnc9brUS3ecgnPmnj5YvRSG52Y978KRz+feXR+hZo+v3GPGwYuac7EGsb7Gg3Rnfa7Yf9cKnh9SUw+z1C+mJCjRZsbEpHW7U8acyxpSMbE6KpXgJHRYGJSeQHsQxOhbGTZysyeLlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sTbYqBC8FAUIBzj7tk/iPo72DsiVvLEfgZa1iSrltB0=;
 b=ASMrfnN+obnfKj2vpGcVAkQowcJxNK4coM3tR/6iD8vEr9O65bUYSrSPwQhKIkmh6s6txfHTAj0IBDhT0Lo8icdQav4VrNVwUEdY7dlF47R9C3iCbrDGj8LXSK8wws17f238x4nh6lulDEDnIu0UDA59kNbQTDlTNXc7EXAHFKhSgvLLwYqDuer8vsTgudVwXPK1iVmQ/Ae1C3574Nhjyndw+4U9yD6mvno+NUxwCytONMElbj/YlVomIlIWL5Is83rySDfOI47r5zt7va7abvdZhNl/zBSeMsw4YjzTQNUugXdnuAxwhzsgJCefqWyf5C1x+6xhKpAEER00vxAwzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sTbYqBC8FAUIBzj7tk/iPo72DsiVvLEfgZa1iSrltB0=;
 b=C5FXD3yma10dhxhMNpbVpC7x5CAq3/BpY1aouutFiRxCC00EHEJzx6DWVwd+a0S1e1aCNVfMMHZdNlolCe1UrJs7QX37S7Sg/g00NeuBm1/BwNWCaKLEvq6xhjX2NYBNorS5fhqNgaNteqWZ5yrQwSTAnqraCw/veVzjl3nvoAuKgWA4WjD98K9e8z9USotgYMlwe6/gOe2TPL1TE3aaMxrMUpmr2R1vcf5pepKha5QIUy//kRPwoi6oGqwZXLYLlBuQjraJnCEHg6WDEV4Qt9Q84elWdKksEl69gAC5fVgA1wzy1lqVO343ETdB5LpsFGYNleyowyU06/RHk21ysA==
Received: from BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:2::9) by
 MAZPR01MB8968.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a01:d0::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6134.19; Thu, 23 Feb 2023 15:01:49 +0000
Received: from BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::f156:868f:a45b:aeee]) by BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::f156:868f:a45b:aeee%11]) with mapi id 15.20.6156.007; Thu, 23 Feb
 2023 15:01:49 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Hector Martin <marcan@marcan.st>
CC:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Linus Walleij <linus.walleij@linaro.org>,
        "asahi@lists.linux.dev" <asahi@lists.linux.dev>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Apple T2 platform support
Thread-Topic: [PATCH 0/2] Apple T2 platform support
Thread-Index: AQHZR5fA6B2arN4fj02dzTxrW7w7KA==
Date:   Thu, 23 Feb 2023 15:01:48 +0000
Message-ID: <379F9C6D-F98D-4940-A336-F5356F9C1898@live.com>
References: <20230214080034.3828-1-marcan@marcan.st>
In-Reply-To: <20230214080034.3828-1-marcan@marcan.st>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [rMVh0onSZI3JfMFM/stkEBlpCw6tqmNW]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BM1PR01MB0931:EE_|MAZPR01MB8968:EE_
x-ms-office365-filtering-correlation-id: 53e35224-b17c-4a25-1cb3-08db15aee35b
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B7Wr0sfZK/1EWwUl2aNmVN9zHY68J2fgkIFoFESGz9RO4Ks1VSN125K1YEvYpOPGx4/21h8Q1AKpfMvpnJp0iOvTfHFpWNAViDMJ2KcnB7kTdP64/7e1aeBU87IvYQLtTg/sb5M2ST4xZxthojS1kqqTHksdYjc2IRRS2m05v4TaP3Coo+FqRRBGi8HD6KBLQdOTHjjH+dT7COTG+CqxEmSo3kd1tltdLF5FPl+skBkCNb4Vm2SHbPw/0WTVJhegnB62TIs0HYpfnBlZEKrcfuuDNx4cdhtMT+3JyxGyq1sE8RBuFB9dNFx5z7Pg9VD+JSQTI5pdgGA7fjBakR2X54kP7B9nVd6ZQmOSUkwWU7QwWt1qsLRxcLK834EVk23WAykuctR/eGH4Wk6SIuOlecQMvnLw3zYR0K06sqnhyUCsu1FP5jqJ45X6nJQLnSEcjCnilwtVnWzIr4aNFdzVGeIyJFz004bZETvTNtcI2ZDPAcVuqywn5fVBxkyUXpXexE5E9JEmnAVjrZOXafI/6XUEYsvq5WgGDH3H1+DFzhSifFdu0SNZ1CsRwEE7rnmSVaVQYan2n98R11C+1WQYaABX0YXmV6+CSS6jpR+HLAu2wmAQn339HxTQV62wBgzWxvOfO+sxL7ouyPkxVvM/8w==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L1JHVlBZWGg5TlF1U2MrV29SenpJWkZKdkdBYWVHVnd1bXRGTEYvY2NTcHBx?=
 =?utf-8?B?MnFsMWxlRGd2UXdBbnNFcjVPWnVlUEZiUFk1VlBubUdsZzV1T2tPUE1yUU9W?=
 =?utf-8?B?Ym1oUnQ4NXVRSW45ME5GamRDaXJGT1dMclFxc2tFK3JFNng1ajJIYnlUVDJl?=
 =?utf-8?B?RmprRk1QVUpXeXVSRldjMVZHd1ZEb1g1N1p0RG8rS09sM1VWekZ1NXQ5bkxF?=
 =?utf-8?B?cmE2OTJXZW00YUsza09PMVkwb3hvQ2ZmcG5CWmxoNTc3Tk5SMTNiTGtod2xT?=
 =?utf-8?B?WmNzeUt6QnhEQ1hKN25qL2h0T05ia2xUNTN1bk4rR1ZJaDZTK2NWcUU1MkZN?=
 =?utf-8?B?bzZEMWQyNjNWYm5aa0ZHR2t3WGFtV1Y3ZEwvYXF5YjJjR1A5MmNNYnczUzVl?=
 =?utf-8?B?UkJUWmxSRWNpVFpJcGZrVDJiQk44RU5BTHFpdDRoajlIVjByYzM0MlZtUUtR?=
 =?utf-8?B?UTBRck5JcDV5eGVvUkpDUXBwZER4eHJyZ2d6SnZiN0pUTFFiVURyUHZEQ3U5?=
 =?utf-8?B?OVFWQlBwNm14aGdnbnBrSW94NC9VOHdhUUJHOFR4ckNnN2d3WS9FL0JrVmVT?=
 =?utf-8?B?TmMzN0tIZDB2a09LUjBoYWt6UktCTWJkQ2Fza0poR0NlQ3F0RFcxVnhSZS9V?=
 =?utf-8?B?czNmRDlBK0RseHJoRkNhS2tsc0FZaDdsRGo5eUZIY2dVSTVHM0ZDSjV4QzJL?=
 =?utf-8?B?NURiU2hBYVBvZUsxdnFSRDJVemlOWFJ4SUhQWUN0VkgzMkJHN2NwWFJmdGdJ?=
 =?utf-8?B?L1pLQnNWWXozYlgvNGxJa2NmMHdPWFJQbHBSdElyTTVkVmVRYjhacTM4c3Bx?=
 =?utf-8?B?RGZLOUcxSEZsNW9DQ0dxcXNiMThuSHZkK2RNQjdkM1ZpcDZCSEkzQ2dUWFVY?=
 =?utf-8?B?TXNrS3QzZmsxM3p1THBjZmhzUnYvemorNlZzaXRKcHdIRGhYdTN2aGhhNDV4?=
 =?utf-8?B?NEpCazBNMjhubUQvYzVpL2k5emYyS1lOb3dTM0tLWWVDOE0rT1FJd3JWbEg1?=
 =?utf-8?B?Vmd5d0hzNzB4UmJNWXU0RFo4RXFyUHdWZ2tRWTVKTndtblVmM3piRmNOaTBa?=
 =?utf-8?B?bGJkelhxdkhidEt2bW9xbC90dXZwK0Y1Q3JvYmhCSzZsUzlCQTE3RlZ3ejI5?=
 =?utf-8?B?TGI5ODIxOGdham9JRzJFT2J3K3dFcy9hU0t6enFZR3ZwZ0NTNEdZcG10RjNE?=
 =?utf-8?B?U3BLNDQ4WE1lMk5nUGhJVWI3V0huWVVLbzVOcVRCaXY5RUxiKzl4cFBhbUho?=
 =?utf-8?B?aUdSRUsyTE5LcSt2SWplaGltUWlyS1BvbVZ1SkI5bDBjeEtDWVhUU0U2Vytk?=
 =?utf-8?B?YnJXWTM3THlXcEFiYlM4QmNHclZiSVVsSHo1N3hKVHVkKzUxalJ2UWMzSzIv?=
 =?utf-8?B?VldQTkpsZ2pRSWdkdjBDU2s3V2w4Wnd4WWtYZVI5d2VnZkdUUGlVOFJ3UEZ3?=
 =?utf-8?B?WFB4SkxJbWY5aEhIcTBkZVdLS2t3ZDJ2K3BvRWJlRk14RGRuS2ZiR0JDaDRG?=
 =?utf-8?B?M1ZMcVNZZDVVNHVUTENiSGJENmRpQXAvWFNVVWZVb3lvdHJYQUh2WmtsOFJz?=
 =?utf-8?B?NDhLeGNrUzZiT2FEd2d5Vi9YYzVEZ3ZVOUNJSWF5S2ZzUTFtWHpkQk9tVHdm?=
 =?utf-8?B?WTBHdW1tWmhVV3Nld1NPZWdRZFZVNzVPd2tIY0pPeDQrTjJYT1Njdmp5aEgy?=
 =?utf-8?B?RTd0STNNSnM1b05jODhPemJSck9IamdIYnFyM1pKU1l3RU9waHgxQ2p3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <40675B01EA5D794E887D6BA8C5E75222@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 53e35224-b17c-4a25-1cb3-08db15aee35b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2023 15:01:48.5792
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MAZPR01MB8968
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSGVjdG9yDQoNCknigJl2ZSBhcHBsaWVkIHRoZSBmb2xsb3dpbmcgcGF0Y2hzZXQgKGFycmFu
Z2VkIGluIGNocm9ub2xvZ2ljYWwgb3JkZXIpIHRvIGxpbnV4IDYuMiwNCmFuZCB3aWZpIHNlZW1z
IHRvIGhhdmUgYnJva2VuIG9uIE1hY0Jvb2tQcm8xNiwxIChicmNtZm1hYzQzNjRiMykNCg0KaHR0
cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYXNhaGkvMjAyMzAyMTIwNjM4MTMuMjc2MjItMS1tYXJjYW5A
bWFyY2FuLnN0L1QvI3QgKEJDTTQzNTUvNDM2NC80Mzc3IHN1cHBvcnQgJiBpZGVudGlmaWNhdGlv
biBmaXhlcykNCg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYXNhaGkvMjAyMzAyMTQwODAwMzQu
MzgyOC0xLW1hcmNhbkBtYXJjYW4uc3QvVC8jdCAoQXBwbGUgVDIgcGxhdGZvcm0gc3VwcG9ydCkN
Cg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYXNhaGkvMjAyMzAyMTQwOTE2NTEuMTAxNzgtMS1t
YXJjYW5AbWFyY2FuLnN0L1QvI3QgKEJDTTQzODcgLyBBcHBsZSBNMSBwbGF0Zm9ybSBzdXBwb3J0
KQ0KDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9hc2FoaS9iNDQ4OWUyNC1lMjI2LTRmOTktMTMy
Mi1jYWI2YzEyNjlmMDlAYnJvYWRjb20uY29tL1QvI3QgKGJyY21mbWFjOiBjZmc4MDIxMTogVXNl
IFdTRUMgdG8gc2V0IFNBRSBwYXNzd29yZCkNCg0KDQpUaGUgbG9ncyBzaG93Og0KDQpGZWIgMjMg
MjA6MDg6NTcgTWFjQm9vayBrZXJuZWw6IHVzYmNvcmU6IHJlZ2lzdGVyZWQgbmV3IGludGVyZmFj
ZSBkcml2ZXIgYnJjbWZtYWMNCkZlYiAyMyAyMDowODo1NyBNYWNCb29rIGtlcm5lbDogYnJjbWZt
YWMgMDAwMDowNTowMC4wOiBlbmFibGluZyBkZXZpY2UgKDAwMDAgLT4gMDAwMikNCkZlYiAyMyAy
MDowODo1NyBNYWNCb29rIGtlcm5lbDogYnJjbWZtYWM6IGJyY21mX2Z3X2FsbG9jX3JlcXVlc3Q6
IHVzaW5nIGJyY20vYnJjbWZtYWM0MzY0YjMtcGNpZSBmb3IgY2hpcCBCQ000MzY0LzQNCkZlYiAy
MyAyMDowODo1NyBNYWNCb29rIGtlcm5lbDogYnJjbWZtYWMgMDAwMDowNTowMC4wOiBEaXJlY3Qg
ZmlybXdhcmUgbG9hZCBmb3IgYnJjbS9icmNtZm1hYzQzNjRiMy1wY2llLkFwcGxlIEluYy4tTWFj
Qm9va1BybzE2LDEuYmluIGZhaWxlZCB3aXRoIGVycm9yIC0yDQpGZWIgMjMgMjA6MDg6NTcgTWFj
Qm9vayBrZXJuZWw6IGJyY21mbWFjIDAwMDA6MDU6MDAuMDogRGlyZWN0IGZpcm13YXJlIGxvYWQg
Zm9yIGJyY20vYnJjbWZtYWM0MzY0YjMtcGNpZS5iaW4gZmFpbGVkIHdpdGggZXJyb3IgLTINCkZl
YiAyMyAyMDowODo1NyBNYWNCb29rIGtlcm5lbDogYnJjbWZtYWMgMDAwMDowNTowMC4wOiBicmNt
Zl9wY2llX3NldHVwOiBEb25nbGUgc2V0dXAgZmFpbGVkDQoNCkkgYWxzbyB0ZXN0ZWQgdGhlIHBh
dGNoaWVzdCBpbiB0aGUgZm9sbG93aW5nIGxpbmssIGFuZCB3aWZpIG1vc3RseSB3b3JrZWQgdGhl
cmUgKG9jY2FzaW9uYWxseSBpdCBjb21wbGFpbmVkIGFib3V0IHNvbWUgcGljIGVycm9yLCBJ4oCZ
bGwgc2F2ZSB0aGUgbG9ncyBuZXh0IHRpbWUgSSBlbmNvdW50ZXIgdGhhdCkgOg0KDQpodHRwczov
L2dpdGh1Yi5jb20vdDJsaW51eC9saW51eC10Mi1wYXRjaGVzL2Jsb2IvbWFpbi84MDAxLWFzYWhp
bGludXgtd2lmaS1wYXRjaHNldC5wYXRjaA0KDQpUaGFua3MNCkFkaXR5YQ0KDQo+IE9uIDE0LUZl
Yi0yMDIzLCBhdCAxOjMwIFBNLCBIZWN0b3IgTWFydGluIDxtYXJjYW5AbWFyY2FuLnN0PiB3cm90
ZToNCj4gDQo+IEhpIGFsbCwNCj4gDQo+IFRoaXMgc2hvcnQgc2VyaWVzIGFkZHMgdGhlIG1pc3Np
bmcgYml0cyB0byBzdXBwb3J0IEFwcGxlIFQyIHBsYXRmb3Jtcy4NCj4gDQo+IFRoZXJlIGFyZSB0
d28gcXVpcmtzOiB0aGVzZSBkZXZpY2VzIGhhdmUgZmlybXdhcmUgdGhhdCByZXF1aXJlcyB0aGUN
Cj4gaG9zdCB0byBwcm92aWRlIGEgYmxvYiBvZiByYW5kb21uZXNzIGFzIGEgc2VlZCAocHJlc3Vt
YWJseSBiZWNhdXNlIHRoZQ0KPiBjaGlwc2V0cyBsYWNrIGEgcHJvcGVyIFJORyksIGFuZCB0aGUg
bW9kdWxlL2FudGVubmEgaW5mb3JtYXRpb24gdGhhdA0KPiBpcyB1c2VkIGZvciBBcHBsZSBmaXJt
d2FyZSBzZWxlY3Rpb24gYW5kIGNvbWVzIGZyb20gdGhlIERldmljZSBUcmVlDQo+IG9uIEFSTTY0
IHN5c3RlbXMgKGFscmVhZHkgdXBzdHJlYW0pIG5lZWRzIHRvIGNvbWUgZnJvbSBBQ1BJIG9uIHRo
ZXNlDQo+IGluc3RlYWQuDQo+IA0KPiBDaGFuZ2VzIHNpbmNlIHRoZSBtZWdhc2VyaWVzIGZyb20g
YSB+eWVhciBhZ286IG1hZGUgdGhlIEFDUEkgY29kZSBiYWlsDQo+IGlmIHRoZXJlIGlzIG5vIG1v
ZHVsZS1pbnN0YW5jZSwgc28gd2UgZG9uJ3QgdHJ5IHRvIGdldCB0aGUgYW50ZW5uYQ0KPiBpbmZv
IGF0IGFsbCBpbiB0aGF0IGNhc2UgKGFzIHN1Z2dlc3RlZCBieSBBcmVuZCkuIE1hZGUgdGhlIHJh
bmRvbW5lc3MNCj4gY29uZGl0aW9uYWwgb24gYW4gQXBwbGUgT1RQIGJlaW5nIHByZXNlbnQsIHNp
bmNlIGl0J3Mgbm90IGtub3duIHRvIGJlDQo+IG5lZWRlZCBvbiBub24tQXBwbGUgZmlybXdhcmUu
DQo+IA0KPiBIZWN0b3IgTWFydGluICgyKToNCj4gIGJyY21mbWFjOiBhY3BpOiBBZGQgc3VwcG9y
dCBmb3IgZmV0Y2hpbmcgQXBwbGUgQUNQSSBwcm9wZXJ0aWVzDQo+ICBicmNtZm1hYzogcGNpZTog
UHJvdmlkZSBhIGJ1ZmZlciBvZiByYW5kb20gYnl0ZXMgdG8gdGhlIGRldmljZQ0KPiANCj4gLi4u
L2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9NYWtlZmlsZSAgICAgIHwgIDIgKw0KPiAuLi4v
YnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2FjcGkuYyAgICAgICAgfCA1MSArKysrKysrKysr
KysrKysrKysrDQo+IC4uLi9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvY29tbW9uLmMgICAg
ICB8ICAxICsNCj4gLi4uL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9jb21tb24uaCAgICAg
IHwgIDkgKysrKw0KPiAuLi4vYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL3BjaWUuYyAgICAg
ICAgfCAzMiArKysrKysrKysrKysNCj4gNSBmaWxlcyBjaGFuZ2VkLCA5NSBpbnNlcnRpb25zKCsp
DQo+IGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNt
ODAyMTEvYnJjbWZtYWMvYWNwaS5jDQo+IA0KPiAtLSANCj4gMi4zNS4xDQo+IA0KPiANCg0K
