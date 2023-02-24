Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEFC6A16EB
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 08:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjBXHHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 02:07:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBXHG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 02:06:58 -0500
Received: from IND01-MAX-obe.outbound.protection.outlook.com (mail-maxind01olkn2084.outbound.protection.outlook.com [40.92.102.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D90461F25;
        Thu, 23 Feb 2023 23:06:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d6j3EHN8Z8SAEPM8m+paE54uW7a2pAhyqdKEkvE/yrIUmVQ/J6LRjfVuljPonH5JkE/2zaxHIBRM4K0BKWh/JZsRIxT9FaAut96r+Lm23TwWp0STT63T8xLsypmNWe1jpRRNvdwPRsAi8EOJvJc6GvvEZmb+2AwQjC9UtfZXYTNh+k+/0cLUFCQWIvBLeiKiHATAS5mp3Nm6aoySHJ1udmN6+JWaBhyYUMl70pGjLdL7rRyYBt3SEcTEoearBUG11Z1phKQeDkyu681J6+KWHTwNJ+wXClIkzJ3KH8YhcxDoyFHgXlGnWNxQ3gBdkjv0FkwMVAWBRCOdLF1KfK0ppw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dnu+H0cre6zG7oPcyELJY7/9MeySARuVTTl5pcTaqNQ=;
 b=jnTgNeoGWELfWvsPZX/uwmzHEGFSYR+TyCLkn738+8Gt2i7rMSUZxJNhP6mp90O+K3lF4xF7b345Ggq9S3n6MbumJ666WaeFoVawHMW0l8uu/NHEpS6XG86kecJeNY8gVWsiWb0//sGWpGpOshb4q7TwpMYyE6fnR4FKSkr2JbSzSukCyuyDrPMaONnNRqi7d+2Uw9Mxa0PphDl9c7HSeRtRLa1blBwwF9Lebvbl5wNGDftHFYBWEav8L/8Et4n6ReDTQYxTpBXZ0KvvaF0ZZsN41jc4jAkL0wvJJ5VEmS3tTw7jkGdvNRGp134UV5q1e9ZRN0sLsCISOdpBIPgA4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dnu+H0cre6zG7oPcyELJY7/9MeySARuVTTl5pcTaqNQ=;
 b=IpUNG3wSjsPbbT1SFTwEK9yNrXbDMbO+IwBRFG9WzNrHSgtOJnGZQZmC8t75MvGHwZTHhr1RkM8vAMTbGPnVP6Qd8SXPx3yro+cka79ZIXerzSvggrwLO1vTRLo2zpmwNmjdGTnd+XBwDvYPBR0b3eLpr2UXQuttlyyHbs7BmajKKpxU3s6hnMsJ7941m01fMhYYWII5k1DYSIeMAxlIdRFSWH2/IhR/dx+mJCB6/u21D1J0x9cRKYQ/D2K/fOWsuRbXrWjL+aNTQvWK613VGEf7nRbY6g8SnJy/E3sgM+yP3+Pgk+7+4e849VX9pkHHLEWcxoCe9ou88JSpKbYLOw==
Received: from BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:2::9) by
 PN3PR01MB7896.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:8f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.6; Fri, 24 Feb 2023 07:06:44 +0000
Received: from BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::f156:868f:a45b:aeee]) by BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::f156:868f:a45b:aeee%11]) with mapi id 15.20.6156.007; Fri, 24 Feb
 2023 07:06:44 +0000
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
        Asahi Linux <asahi@lists.linux.dev>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Orlando Chamberlain <orlandoch.dev@gmail.com>
Subject: Re: [PATCH 0/2] Apple T2 platform support
Thread-Topic: [PATCH 0/2] Apple T2 platform support
Thread-Index: AQHZR5e26B2arN4fj02dzTxrW7w7KA==
Date:   Fri, 24 Feb 2023 07:06:44 +0000
Message-ID: <08D37F17-E4A1-4BA5-B440-FDAD10937A23@live.com>
References: <379F9C6D-F98D-4940-A336-F5356F9C1898@live.com>
 <6588DEA1-673C-415E-A7AC-45CFBAA2B0F5@live.com>
In-Reply-To: <6588DEA1-673C-415E-A7AC-45CFBAA2B0F5@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [TnxCYNDvuZAb7RP6e8/zf53ZEpe24AZh]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BM1PR01MB0931:EE_|PN3PR01MB7896:EE_
x-ms-office365-filtering-correlation-id: b2043197-3d31-40e7-88b0-08db1635b01e
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gJ6PSoY9qPNvagPDIDOCf2Yd6SMiiOw+drLQbMS0Fr+R3TeI++F2TH6/jUgp4n/kEWWWu+s+PkXYa3/bwgGyu14LAMlGxe+FJCu7kdiGfOknFDc5f/qC/sToW7tt9ePQRgvzCT2ysPeroyVonrlzsHxm1AQR1G6WAVXBDthcg8+m7H1scyORWKrIl9YZObz2CadXXBuEz7XfBChHlTm4gj1cEGF4EsU/QZnyVIkoY2cJk0dR3PQCwiJGRLkP+ryatw9rZHo/4q0br7nbtdlfJ7z97JHyiDUD0NHIh2ZgMj5NjNEHiFA2hk6v6us2SxLwATXgsw9L4y+0SGw7eHVhRcWJ3gvDfgCshZ4HFiNh0zrieF2aqE5oARfg5WFZtGve7TPZv2DzrNDvFFmZKqVIwS3GyBlgFEq7fEbTt6MO8+325456dkZB2FFAH4TFfhtilHRF9kBE/2cOE+JVRRm1VeN70UEXngCZ/QZlurj8omb0/uHbaJ6XK/Z41r92Ugvu26BDYA0UdHpxlwQJZx0NQTqFrY09lYoewAZnzrq2Gd0TnhKYxpXNxNE4n/tzdvO1J8y6GTCleFcxeJJlPy5eUL8BeoszZCWioY1LWEykBCg01CC0BxSW2HZ25GVsYJA9RWIAEjZwuj0m9fDUUmfLJA==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eE5kWTE3T1RPKzEvb1E1d2FjaUNMZkIwZjc3cC9CZUJOMERkSm5IK2E4MCs4?=
 =?utf-8?B?RkE1Z0lmM3hkZEZIZGsrdllRTXFraUFyVVl6UFhJL091OGpUSTF2cHZVUUpt?=
 =?utf-8?B?N1NiQ1Nrd3hhTis3dHpiNzk5c3pIVzlVays1K05pVE9hU1Q3b2VGOWFkYUdk?=
 =?utf-8?B?Um4yMVROT0VETVVUL2xlL0NOdFpYNytyaFRnMllnUkpzYkh1clg2K3VOMU5E?=
 =?utf-8?B?dmYwRFlrczcvYUMyMW9NWGE4UW5PcEZQOVNzN1JFU3VBR0c3clhMVEx6VnhF?=
 =?utf-8?B?cWc0YTFwQUhKek95Z3BEM1RueDBPbE4wRkRZYVdpKzJVZjFyS2pXTnpsc3g5?=
 =?utf-8?B?aFpnbmtsWnRtYTdmVWhPSy9QMXNuWURFQm1hUmN4aE1EbDAwNlpDMXNua2hC?=
 =?utf-8?B?RXN6UG9zM1NlY1EwTzNBNm1WTlpwWE4ydFFLbWhFSENDMDNsQ2k1VDFUSHdM?=
 =?utf-8?B?czF4UWRnN2R4QlZaZWZ2ZGdFNXJaYzZaSnFsRFVSSnNvaW9OL3NmWWsxR2Nn?=
 =?utf-8?B?QlpPWW96RUU5b0RZZ0Z2Ukxvb21tU1UzSERiTVBqTFJiZGd6SVg3ZnRvanNp?=
 =?utf-8?B?U05COUtYemtWMHF5Q1loTVBCNFErZjFITkFxVE1wTVJQK3ZieXdwdVZmbytx?=
 =?utf-8?B?TEcxYnNPUEpDRTFxc0ZWQ1ZIaTBodjJpRmFqUTNIWmw3NzU5aVg1cmtsVHI3?=
 =?utf-8?B?dHZZUnVtcGltV2dmb3NjLzRnazhBS1YzTHhHZnpobFBKR3k4NmUxT0padEZF?=
 =?utf-8?B?Z0RHUk90TE1Va2ovMHIrSG5xMHhDejFTTlo2UUJVMld6ekRzUUFNaEdaRUFN?=
 =?utf-8?B?VHl0SWtxWFZSWmxZcldubkFtY3BESWJvYi8zVVptQ0NaTmtLR0dHSGRjOHRN?=
 =?utf-8?B?RTViRTM1K3ZHbVdvbjhTQ3lsazJObThSbFFvVTZ0SE8xcTRMQlMvOTJaT1pz?=
 =?utf-8?B?TjdGanE2RzdDY3BBcjJwMU5lV3NrWHcvKzh6NUFWd01zcGQ0OXliTk5uUlBx?=
 =?utf-8?B?Ulo4cW4xN1VYRVJsK1ZWbm5ZRnMveXdsQjJaRzNIeUV0TmFWa2Uwa0sxbE1J?=
 =?utf-8?B?SmNoWmpwT0t5TXJIVStPZ2Mzc1kzSnkvd3A2UU9iYzcrZk9ZWDlEaDN1M1lM?=
 =?utf-8?B?Z1VhNkhxa3dKOGdnMmFnVm1Ec2FJR2o0TlNHVmJDUU15a3hpdzVIaXNOUXB5?=
 =?utf-8?B?ODdPc011THY2VFo4ZXdJRUpCWitQMUF1Mzhyc0xoOEY2a3hQQk85ekZBTy84?=
 =?utf-8?B?WjUxMkoyOS9LSXk4UlU3QThERUEydnZUTEtZdTBWVGFmOG9nZldkc0NmL0s2?=
 =?utf-8?B?c2NCYUlFREdvUk9Na053dGZlWmhIT2tyeTFlQnBZOGVZUFhLZ3pmaEhhbm82?=
 =?utf-8?B?YjhDaHVVVi9nWE1yd0RidUdJYklkVCtIaGhyMmdNemh3Q2YwOVdocXRtVE05?=
 =?utf-8?B?Nmtoak5qdk9vY2JIYW5PdndrcW5PS0h1TnNFSjhwVFI0S3dnM2MzVmQ0Z1dF?=
 =?utf-8?B?UGhkZ2NXK0lhUktRdnI4Rmh0QzdsYjF6REVzeWR3YzNOMlBSSFRicGR0b09G?=
 =?utf-8?B?UzIrcTJBYlZiWVRTWjRCZEh6ZEhJc0hDQzAvanZGenJ5Umh1eklQRjZUOS96?=
 =?utf-8?B?WUNCTXB5dFRBMWNuSmx6RnY1d2xsOWx6ZUxnRFlXR1grVmhyaTk2VlpZOGU5?=
 =?utf-8?B?NUdxcU5iUmZpb056TEY2NytrN20yNTBhdGF5V3RmWUFHc0x3aDdrNFZBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E986A73D6936B447BCF13D0E6D092923@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: b2043197-3d31-40e7-88b0-08db1635b01e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2023 07:06:44.6301
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN3PR01MB7896
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiANCj4gSSBhbHNvIHRlc3RlZCB0aGUgKnBhdGNoc2V0KiBpbiB0aGUgZm9sbG93aW5nIGxpbmss
IGFuZCB3aWZpIG1vc3RseSB3b3JrZWQgdGhlcmUgKG9jY2FzaW9uYWxseSBpdCBjb21wbGFpbmVk
IGFib3V0IHNvbWUgKnBjaSogZXJyb3IsIEnigJlsbCBzYXZlIHRoZSBsb2dzIG5leHQgdGltZSBJ
IGVuY291bnRlciB0aGF0KSA6DQoNCkkgZ290IHRoZSBsb2dzIGFzIGZvbGxvd3M6DQoNCkZlYiAy
NCAxMjowNDo1MCBNYWNCb29rIGtlcm5lbDogdXNiY29yZTogcmVnaXN0ZXJlZCBuZXcgaW50ZXJm
YWNlIGRyaXZlciBicmNtZm1hYw0KRmViIDI0IDEyOjA0OjUwIE1hY0Jvb2sga2VybmVsOiBicmNt
Zm1hYyAwMDAwOjA1OjAwLjA6IGVuYWJsaW5nIGRldmljZSAoMDAwMCAtPiAwMDAyKQ0KRmViIDI0
IDEyOjA0OjUwIE1hY0Jvb2sga2VybmVsOiBicmNtZm1hYzogYnJjbWZfZndfYWxsb2NfcmVxdWVz
dDogdXNpbmcgYnJjbS9icmNtZm1hYzQzNjRiMy1wY2llIGZvciBjaGlwIEJDTTQzNjQvNA0KRmVi
IDI0IDEyOjA0OjUwIE1hY0Jvb2sga2VybmVsOiBicmNtZm1hYyAwMDAwOjA1OjAwLjA6IERpcmVj
dCBmaXJtd2FyZSBsb2FkIGZvciBicmNtL2JyY21mbWFjNDM2NGIzLXBjaWUuYXBwbGUsYmFsaS1I
UlBOLXUtNy43LVgzLmJpbiBmYWlsZWQgd2l0aCBlcnJvciAtMg0KRmViIDI0IDEyOjA0OjUwIE1h
Y0Jvb2sga2VybmVsOiBicmNtZm1hYyAwMDAwOjA1OjAwLjA6IERpcmVjdCBmaXJtd2FyZSBsb2Fk
IGZvciBicmNtL2JyY21mbWFjNDM2NGIzLXBjaWUuYXBwbGUsYmFsaS1IUlBOLXUtNy43LmJpbiBm
YWlsZWQgd2l0aCBlcnJvciAtMg0KRmViIDI0IDEyOjA0OjUwIE1hY0Jvb2sga2VybmVsOiBicmNt
Zm1hYyAwMDAwOjA1OjAwLjA6IERpcmVjdCBmaXJtd2FyZSBsb2FkIGZvciBicmNtL2JyY21mbWFj
NDM2NGIzLXBjaWUuYXBwbGUsYmFsaS1IUlBOLXUuYmluIGZhaWxlZCB3aXRoIGVycm9yIC0yDQpG
ZWIgMjQgMTI6MDQ6NTAgTWFjQm9vayBrZXJuZWw6IGJyY21mbWFjIDAwMDA6MDU6MDAuMDogRGly
ZWN0IGZpcm13YXJlIGxvYWQgZm9yIGJyY20vYnJjbWZtYWM0MzY0YjMtcGNpZS5hcHBsZSxiYWxp
LUhSUE4uYmluIGZhaWxlZCB3aXRoIGVycm9yIC0yDQpGZWIgMjQgMTI6MDQ6NTAgTWFjQm9vayBr
ZXJuZWw6IGJyY21mbWFjIDAwMDA6MDU6MDAuMDogRGlyZWN0IGZpcm13YXJlIGxvYWQgZm9yIGJy
Y20vYnJjbWZtYWM0MzY0YjMtcGNpZS5hcHBsZSxiYWxpLVgzLmJpbiBmYWlsZWQgd2l0aCBlcnJv
ciAtMg0KRmViIDI0IDEyOjA0OjUwIE1hY0Jvb2sga2VybmVsOiBicmNtZm1hY19iY2E6IGJyY21m
X2JjYV9hdHRhY2g6IGV4ZWN1dGluZw0KRmViIDI0IDEyOjA0OjUwIE1hY0Jvb2sga2VybmVsOiBi
cmNtZm1hY19iY2E6IGJyY21mX2JjYV9kZXRhY2g6IGV4ZWN1dGluZw0KRmViIDI0IDEyOjA0OjUw
IE1hY0Jvb2sga2VybmVsOiBicmNtZm1hYyAwMDAwOjA1OjAwLjA6IGJyY21mX3BjaWVfc2V0dXA6
IERvbmdsZSBzZXR1cCBmYWlsZWQNCkZlYiAyNCAxMjowNDo1MCBNYWNCb29rIGtlcm5lbDogYnJj
bWZtYWMgMDAwMDowNTowMC4wOiBicmNtZl9wY2llX2J1c19jb25zb2xlX3JlYWQ6IENPTlNPTEU6
IDAwMDAuODUzIEVMOiAzMCAzZTg0DQpGZWIgMjQgMTI6MDQ6NTAgTWFjQm9vayBrZXJuZWw6IGJy
Y21mbWFjIDAwMDA6MDU6MDAuMDogYnJjbWZfcGNpZV9idXNfY29uc29sZV9yZWFkOiBDT05TT0xF
OiAwMDAwMDAuODUzIFRocmVhZDogd2xhbl90aHJlYWQoSUQ6MHg1NDQ4NTI0NCkgcnVuIGNudDoy
DQpGZWIgMjQgMTI6MDQ6NTAgTWFjQm9vayBrZXJuZWw6IGJyY21mbWFjIDAwMDA6MDU6MDAuMDog
YnJjbWZfcGNpZV9idXNfY29uc29sZV9yZWFkOiBDT05TT0xFOiAwMDAwMDAuODU0IFRocmVhZDog
U3RhY2s6MDAyOWZmMzQgU3RhcnQgQWRkcjowMDI5ZTAwMCBFbmQgQWRkcjowMDI5ZmZkZiBTaXpl
OjgxNjANCkZlYiAyNCAxMjowNDo1MCBNYWNCb29rIGtlcm5lbDogYnJjbWZtYWMgMDAwMDowNTow
MC4wOiBicmNtZl9wY2llX2J1c19jb25zb2xlX3JlYWQ6IENPTlNPTEU6IDAwMDAwMC44NTQgVGhy
ZWFkOiBFbnRyeSBmdW5jOjAwMTZmODE5DQpGZWIgMjQgMTI6MDQ6NTAgTWFjQm9vayBrZXJuZWw6
IGJyY21mbWFjIDAwMDA6MDU6MDAuMDogYnJjbWZfcGNpZV9idXNfY29uc29sZV9yZWFkOiBDT05T
T0xFOiAwMDAwMDAuODU0IFRocmVhZDogVGltZXI6MDAxY2E3MGMNCkZlYiAyNCAxMjowNDo1MCBN
YWNCb29rIGtlcm5lbDogYnJjbWZtYWMgMDAwMDowNTowMC4wOiBicmNtZl9wY2llX2J1c19jb25z
b2xlX3JlYWQ6IENPTlNPTEU6IDAwMDAwMC44NTQgDQpGZWIgMjQgMTI6MDQ6NTAgTWFjQm9vayBr
ZXJuZWw6IGJyY21mbWFjIDAwMDA6MDU6MDAuMDogYnJjbWZfcGNpZV9idXNfY29uc29sZV9yZWFk
OiBDT05TT0xFOiBGV0lEIDAxLTIzNDE5ZWQyDQpGZWIgMjQgMTI6MDQ6NTAgTWFjQm9vayBrZXJu
ZWw6IGJyY21mbWFjIDAwMDA6MDU6MDAuMDogYnJjbWZfcGNpZV9idXNfY29uc29sZV9yZWFkOiBD
T05TT0xFOiBmbGFncyA3ODAxMDAwNw0KRmViIDI0IDEyOjA0OjUwIE1hY0Jvb2sga2VybmVsOiBi
cmNtZm1hYyAwMDAwOjA1OjAwLjA6IGJyY21mX3BjaWVfYnVzX2NvbnNvbGVfcmVhZDogQ09OU09M
RTogMDAwMDAwLjg1NCANCkZlYiAyNCAxMjowNDo1MCBNYWNCb29rIGtlcm5lbDogYnJjbWZtYWMg
MDAwMDowNTowMC4wOiBicmNtZl9wY2llX2J1c19jb25zb2xlX3JlYWQ6IENPTlNPTEU6IFRSQVAg
NCgyOWZlZjgpOiBwYyAxNmUyMTgsIGxyIDE2ZTIwNSwgc3AgMjlmZjUwLCBjcHNyIDYwMDAwMTkz
LCBzcHNyIDYwMDAwMDMzDQpGZWIgMjQgMTI6MDQ6NTAgTWFjQm9vayBrZXJuZWw6IGJyY21mbWFj
IDAwMDA6MDU6MDAuMDogYnJjbWZfcGNpZV9idXNfY29uc29sZV9yZWFkOiBDT05TT0xFOiAwMDAw
MDAuODU1ICAgZGZzciA4MGQsIGRmYXIgMA0KRmViIDI0IDEyOjA0OjUwIE1hY0Jvb2sga2VybmVs
OiBicmNtZm1hYyAwMDAwOjA1OjAwLjA6IGJyY21mX3BjaWVfYnVzX2NvbnNvbGVfcmVhZDogQ09O
U09MRTogMDAwMDAwLjg1NSAgIHIwIDEsIHIxIDAsIHIyIDE2MDk4OCwgcjMgMCwgcjQgMTY3ZjM1
LCByNSAxLCByNiAxNjdmMzUNCkZlYiAyNCAxMjowNDo1MCBNYWNCb29rIGtlcm5lbDogYnJjbWZt
YWMgMDAwMDowNTowMC4wOiBicmNtZl9wY2llX2J1c19jb25zb2xlX3JlYWQ6IENPTlNPTEU6IDAw
MDAwMC44NTUgICByNyAwLCByOCAwLCByOSAwLCByMTAgMjllMDAwLCByMTEgODBkLCByMTIgMA0K
RmViIDI0IDEyOjA0OjUwIE1hY0Jvb2sga2VybmVsOiBicmNtZm1hYyAwMDAwOjA1OjAwLjA6IGJy
Y21mX3BjaWVfYnVzX2NvbnNvbGVfcmVhZDogQ09OU09MRTogMDAwMDAwLjg1NSANCkZlYiAyNCAx
MjowNDo1MCBNYWNCb29rIGtlcm5lbDogYnJjbWZtYWMgMDAwMDowNTowMC4wOiBicmNtZl9wY2ll
X2J1c19jb25zb2xlX3JlYWQ6IENPTlNPTEU6ICAgIHNwKzAgMDAyODA2NDggMDAwMTk3ODMgMDAw
MDAwMDAgMDAxNjdmMzUNCkZlYiAyNCAxMjowNDo1MCBNYWNCb29rIGtlcm5lbDogYnJjbWZtYWMg
MDAwMDowNTowMC4wOiBicmNtZl9wY2llX2J1c19jb25zb2xlX3JlYWQ6IENPTlNPTEU6IDAwMDAw
MC44NTYgICBzcCsxMCAwMDI4MDY0OCAwMDE2ODMwMSAwMDIzNmVjNCAwMDAwMDAwMg0KRmViIDI0
IDEyOjA0OjUwIE1hY0Jvb2sga2VybmVsOiBicmNtZm1hYyAwMDAwOjA1OjAwLjA6IGJyY21mX3Bj
aWVfYnVzX2NvbnNvbGVfcmVhZDogQ09OU09MRTogDQpGZWIgMjQgMTI6MDQ6NTAgTWFjQm9vayBr
ZXJuZWw6IGJyY21mbWFjIDAwMDA6MDU6MDAuMDogYnJjbWZfcGNpZV9idXNfY29uc29sZV9yZWFk
OiBDT05TT0xFOiAwMDAwMDAuODU2IHNwKzQgMDAwMTk3ODMNCkZlYiAyNCAxMjowNDo1MCBNYWNC
b29rIGtlcm5lbDogYnJjbWZtYWMgMDAwMDowNTowMC4wOiBicmNtZl9wY2llX2J1c19jb25zb2xl
X3JlYWQ6IENPTlNPTEU6IDAwMDAwMC44NTYgc3ArYyAwMDE2N2YzNQ0KRmViIDI0IDEyOjA0OjUw
IE1hY0Jvb2sga2VybmVsOiBicmNtZm1hYyAwMDAwOjA1OjAwLjA6IGJyY21mX3BjaWVfYnVzX2Nv
bnNvbGVfcmVhZDogQ09OU09MRTogMDAwMDAwLjg1NiBzcCsxNCAwMDE2ODMwMQ0KRmViIDI0IDEy
OjA0OjUwIE1hY0Jvb2sga2VybmVsOiBicmNtZm1hYyAwMDAwOjA1OjAwLjA6IGJyY21mX3BjaWVf
YnVzX2NvbnNvbGVfcmVhZDogQ09OU09MRTogMDAwMDAwLjg1NiBzcCsyYyAwMDAxOTc4Mw0KRmVi
IDI0IDEyOjA0OjUwIE1hY0Jvb2sga2VybmVsOiBicmNtZm1hYyAwMDAwOjA1OjAwLjA6IGJyY21m
X3BjaWVfYnVzX2NvbnNvbGVfcmVhZDogQ09OU09MRTogMDAwMDAwLjg1NiBzcCszNCAwMDAzOTEw
Zg0KRmViIDI0IDEyOjA0OjUwIE1hY0Jvb2sga2VybmVsOiBicmNtZm1hYyAwMDAwOjA1OjAwLjA6
IGJyY21mX3BjaWVfYnVzX2NvbnNvbGVfcmVhZDogQ09OU09MRTogMDAwMDAwLjg1NyBzcCs0NCAw
MDE2ZjhlNw0KRmViIDI0IDEyOjA0OjUwIE1hY0Jvb2sga2VybmVsOiBicmNtZm1hYyAwMDAwOjA1
OjAwLjA6IGJyY21mX3BjaWVfYnVzX2NvbnNvbGVfcmVhZDogQ09OU09MRTogMDAwMDAwLjg1NyBz
cCs0YyAwMDAzZDFjNQ0KRmViIDI0IDEyOjA0OjUwIE1hY0Jvb2sga2VybmVsOiBicmNtZm1hYyAw
MDAwOjA1OjAwLjA6IGJyY21mX3BjaWVfYnVzX2NvbnNvbGVfcmVhZDogQ09OU09MRTogMDAwMDAw
Ljg1NyBzcCs2MCAwMDAwYzAyYg0KRmViIDI0IDEyOjA0OjUwIE1hY0Jvb2sga2VybmVsOiBicmNt
Zm1hYyAwMDAwOjA1OjAwLjA6IGJyY21mX3BjaWVfYnVzX2NvbnNvbGVfcmVhZDogQ09OU09MRTog
MDAwMDAwLjg1NyBzcCs2YyAwMDAzZGZjZA0KDQoNCg0K
