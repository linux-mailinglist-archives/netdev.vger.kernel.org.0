Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA70B6A0C78
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 16:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234918AbjBWPFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 10:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233805AbjBWPFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 10:05:07 -0500
Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2082b.outbound.protection.outlook.com [IPv6:2a01:111:f403:7011::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97B84AFC4;
        Thu, 23 Feb 2023 07:05:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BXTCoVndTN+v/hxo5+HXUf/OetaigYh5SCD22LysihdBpM884xQSQpWIcPntviOMklYBNWImVykObGN28MXraVo6pJnuKHiKuWXtFUdtvKNjbVzo7hyWEZOE00vwX/ptyT1GSd/RFczMNXJvhBTEyl8pAlyeKvdPDV2ckR6JfeqfjQWJv8mb2fCv+tCOBEjM9rlBWX+op34jpPzkS1dVP8lhWkFkwWlvIQgHZjFR4KuG0QSKfEAQtr55p+AZhwKJ5aZTeZj+XROezo5Vfqlrl5lPSEU90XpMJRZnhb5rrhfETpdU6WR2i+X2/J9zsxS5XZO+UeFvKqST4dtj3sImHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ws50nCm2pU1wi5pFdrhuBxlrsgveanmOggOfW6IVX68=;
 b=fs2r7elHZAEMcxo4dMgIsq+OTiFugjz7PnutgNjYTk4lGeBIbh9VN2xP7kMdKrdWE/vEwgwiPHksjQ2fQKQe5fjv+ZoXHR9xYYhQoWFZmWek+VC3ic2dmY1KZHfTWpX82MPXIfeT4+ODg6Yiwcj9r8B360ZAzE+Tp39T2ze6KWu7CrwYEtuX1veK+dTGHlswa7DwmupI5IQCy3P4TxXs9VriWcv9rJW/aMGZrxNmdj8Zo82Rd7cTfdADovNhAxiqErtv68Oc53qVnPGNowZ/nfa5Ss2BVtu+Ok1iRSQDDxTv7b+SoEYXgtivuHYTVDvoRh9Aaj5gyjRILLqU0g/Pow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ws50nCm2pU1wi5pFdrhuBxlrsgveanmOggOfW6IVX68=;
 b=sNZEFc3SMf+dZyBih1JhKf+65GVID3skOZdECsdP4bpfpP7Xs1Wz++2xJBJ15G6QKXOMNbrpG/xqIreHxVjvpe1tCt7+SfJMNJU2C7iC2rsXgwhdJVLt1KZK2aZrYeWL1i8I7E33sQJKNLK1Px6diwNBx6xTPyPC5hVu/2QVoC46SfTxMiS2pbTg50v/5z0pdKXZFAFCxKrdsyKUhmkrZZq0MPPiHdWQ88LWoNUld+4snN+vDWcNazUQTCZ/rfwLrF922N1zJE/zbVYLGd7npv6IBI7OzAxjLmnzhULeaMfVR1viPDP09OLM7qMgFTQ7fH04OhoY0HQ4N5rcYVkkHQ==
Received: from BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:2::9) by
 PN2PR01MB8218.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:5d::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.7; Thu, 23 Feb 2023 15:04:54 +0000
Received: from BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::f156:868f:a45b:aeee]) by BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::f156:868f:a45b:aeee%11]) with mapi id 15.20.6156.007; Thu, 23 Feb
 2023 15:04:54 +0000
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
Thread-Index: AQHZR5e26B2arN4fj02dzTxrW7w7KK7coRuA
Date:   Thu, 23 Feb 2023 15:04:54 +0000
Message-ID: <BM1PR01MB09319F7AD88509E50A33D7DDB8AB9@BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM>
References: <379F9C6D-F98D-4940-A336-F5356F9C1898@live.com>
In-Reply-To: <379F9C6D-F98D-4940-A336-F5356F9C1898@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [lzHNG0Im+oaAtwK0i/viG/B/z8aV34tDep3/btXVOmzE63trTdEp03uU7bWndmJ2]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BM1PR01MB0931:EE_|PN2PR01MB8218:EE_
x-ms-office365-filtering-correlation-id: 4999e7e3-f980-4163-23a0-08db15af5255
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /9Yu9jEUtm72hX8mrIvIWHndnrPtSCKkFGXa6p6nWvEbe/IU9JZB8RDsB25Wu7cALjszujinU/G2N3FuXJAKfqPjFJ1B54cNNGcvRfoiIwH/Jwmb2lvlLIZWnTbbk0EwS9vbkGyWL+FYEnzb6tTrInLUC5giNXGgHGGP+IlwePJfpfjJMC+88J8NG3cyIdF/ncT1l5ckAeQ5PlQsMYGk/hsZXfv0J/CMBP0Q/DMBZ89L57kxbtuybfYpJk4JJTRkJogTzxXP0peZeFjN7zBenSeFKGAh9s7VXvIXv06ZQBrXu2ZhAVHz8L1RC6bj6jYVUtjWLqQDSVo8liefBiCeyoMQIj1fQw2SsatEQVrYqSocfVWSjdTM0mMVHEssksdKUd87Da8yzgQHy4fvbIIvnCtijnz6CCLOTNdGM6yIZQu4QZUIZu+vjjg0IaRmakw+fVG9d2UlZbvStNNlBPGyGGHvambev4xEYPPglSk3vY5Too6HFgKmhvbBR2iajJYkaPWx7Ai/YXNJYCEPuOFk2ne9ur2OpQBtkHvRH75pNy787sUXeZzvNhRIYmjvZ+TVzvOqzxqtarCleWCIWoAtd46vWeIBbSyq51Pd61yMudS7D202OMSl+kEj6yOFJzPw33pp1E4ZTbjBG/8KMpiriw==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TjBobldLVXZQMG9qdDVNNUFEaWNoKzF5OVQ5a29TT2JWeFNIamsvdWw5VW1y?=
 =?utf-8?B?bklMaXhqYlVXbEZXUElaRk5Ia2RhaUVLa2Q1SU4wSGVFOURTY2gzVXV3SVd5?=
 =?utf-8?B?UFR4aC91QVFtbVVGM0JyN2E5NklMVUUxMW9ERm9rc2xPNVJheHVjZForaVJa?=
 =?utf-8?B?OFFKbHFSSkpmYXNMc2ZDdVJNQkJRZWI1TmY1MFFGSHNCbVpmN1FMWUgwSHVh?=
 =?utf-8?B?cCtsQUpRSlpQczk0QU8zY1hYeHJTTXJSQys5OXBhaHlqRG12MjVHUjhzeW1h?=
 =?utf-8?B?R0g3aUlJc3V6RGF0MHFGTXhvRFRlVU1OTWVYbm15L0NWVXVVRGNHa2tFRHVM?=
 =?utf-8?B?bDhsTyt1bFF5REswK0pnVTZTSElPVWNPb0VEY3d1NnFlbWFwOE9nUUkrS01o?=
 =?utf-8?B?UjQ5Y0pRcHFobTJQNG9UUDI3SVRWVzBCNkMySXRidTdkRjU4bVRSS0RTRWdM?=
 =?utf-8?B?MThQb0ZSZjZGYW5pWkVycG5UZ2pIVUlLMnRRdzBwcHpnblE1OEgvU1FZY3I4?=
 =?utf-8?B?ek52UmZRRkFmWjgrRzRZU09HTTI2R0xTK0dQMEZmdDMzaEUyZG11TDdYaGNj?=
 =?utf-8?B?eFZENDZCWnZvUlNNNTQrbDlBZVVCUStWOGhVdjQwdHpZYTFEMlRQOGxia1lV?=
 =?utf-8?B?TEZGdnFncDNMM3Z3Nzd6T0FqQ2ZKMFQzY0NtY2xJOFdjaG5sS3pPNE1nU2J2?=
 =?utf-8?B?QkhTL2lkRVZ3QTN1Zm55eHVCU04xbmJZSTIvQ0R4aDIwOHpMekMyaTdtU3Zx?=
 =?utf-8?B?NnJMd0ZsTjg4aFZDaFZVSHp1THVnc1ZCMS8wdG9wUGtoRGJTMXZQOEdIU21W?=
 =?utf-8?B?OXcyVWNzUzlmZFBlcURuZ3RlRkloMXplcUNmekY5MFhRRHU4bGE3WkhhY3ZC?=
 =?utf-8?B?cngzcnlwZCtrSVVaNnRzeWtGVTV4RitxY3N3ckdLSHB5MlJLVUEyZFUvRjFm?=
 =?utf-8?B?emZiNm1ZWGcwUW9GeS81OUxsZnN4a1dBYmdpNDdBY3hHbTg5cVF2RzVMTkdt?=
 =?utf-8?B?eFZOOWVzSm50WExqQ2JyMmV0K2lVUnpJNGVPOThGS3J5UzNRWlB3TXJYOWF1?=
 =?utf-8?B?c1UzM1JQcHpYZFNVbjhsWk50RGh6ekpHV2xCMUtXN0tMMTBrVjhLQkNwU3oz?=
 =?utf-8?B?MDhzbDNsZkNUMWR3RVdDSVdhaVo1bUs3cmFuRS8xdlY0UjljUFZlWGkyTjha?=
 =?utf-8?B?blV2azErVnE3TEI5UmJKdVEvRE14dGF1NE90RWU0VGRLTHp0Y3BmeU45Y3My?=
 =?utf-8?B?M2JyYmlkT2tYRXJhNENCOTJXaG8rWmJacjFMR1Nxd2FZQWp4WHVuL253bGRq?=
 =?utf-8?B?ZnNCVVJjRUlRS1VDRVQrUkZPUitKV0VibFB3RGo0endHV0YxZ09NU0RsYXpF?=
 =?utf-8?B?NjZ1dWJBV2VFLzdaVmlFakROZm9XWGlxcFVNdGM5ZkpJekRXMGMzNUNrbUsv?=
 =?utf-8?B?TE5nbzAzRFpCQkxTQklPSFczTjRVUFB1OWpmOFh6MXFJV2FlUUxjNTBobHR1?=
 =?utf-8?B?NmhFSGdXRjBmb2hyWCtsckV6WnFwMnBucXowOGw5akxITDIzY0JmSDFJTWZ3?=
 =?utf-8?B?OGNDZWV6S3JXb1BGcjE5SFAyenRQcXpMVFFhUjhCdk44T2hzS0x2dUcrM0Fi?=
 =?utf-8?B?azh5OW4rVXpIcEZ3Wk5oUGxYNmpYeEpUTmlqM25JbWQyV0F5Q1VSN3FON1Qx?=
 =?utf-8?B?azd5RXRRNU02aDRWYXd4di9SaW52Sm9RUUVzVjh2VkJlQ3FvQ2tZQUszQXZq?=
 =?utf-8?B?RzNmck1SQ3h5UjVwcEorMGEzS2tRTDFPZkRQYlNTT044OWVmcHpoQjNwVlpY?=
 =?utf-8?B?SWdzRjhQU2tWSFBOYkFtdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8438CEBA6C97BB4DA517C7C049E98063@sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 4999e7e3-f980-4163-23a0-08db15af5255
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2023 15:04:54.7359
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN2PR01MB8218
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gMjMtRmViLTIwMjMsIGF0IDg6MzEgUE0sIEFkaXR5YSBHYXJnIDxnYXJnYWRpdHlh
MDhAbGl2ZS5jb20+IHdyb3RlOg0KPiANCj4g77u/SGkgSGVjdG9yDQo+IA0KPiBJ4oCZdmUgYXBw
bGllZCB0aGUgZm9sbG93aW5nIHBhdGNoc2V0IChhcnJhbmdlZCBpbiBjaHJvbm9sb2dpY2FsIG9y
ZGVyKSB0byBsaW51eCA2LjIsDQo+IGFuZCB3aWZpIHNlZW1zIHRvIGhhdmUgYnJva2VuIG9uIE1h
Y0Jvb2tQcm8xNiwxIChicmNtZm1hYzQzNjRiMykNCj4gDQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL2FzYWhpLzIwMjMwMjEyMDYzODEzLjI3NjIyLTEtbWFyY2FuQG1hcmNhbi5zdC9ULyN0IChC
Q000MzU1LzQzNjQvNDM3NyBzdXBwb3J0ICYgaWRlbnRpZmljYXRpb24gZml4ZXMpDQo+IA0KPiBo
dHRwczovL2xvcmUua2VybmVsLm9yZy9hc2FoaS8yMDIzMDIxNDA4MDAzNC4zODI4LTEtbWFyY2Fu
QG1hcmNhbi5zdC9ULyN0IChBcHBsZSBUMiBwbGF0Zm9ybSBzdXBwb3J0KQ0KPiANCj4gaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvYXNhaGkvMjAyMzAyMTQwOTE2NTEuMTAxNzgtMS1tYXJjYW5AbWFy
Y2FuLnN0L1QvI3QgKEJDTTQzODcgLyBBcHBsZSBNMSBwbGF0Zm9ybSBzdXBwb3J0KQ0KPiANCj4g
aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYXNhaGkvYjQ0ODllMjQtZTIyNi00Zjk5LTEzMjItY2Fi
NmMxMjY5ZjA5QGJyb2FkY29tLmNvbS9ULyN0IChicmNtZm1hYzogY2ZnODAyMTE6IFVzZSBXU0VD
IHRvIHNldCBTQUUgcGFzc3dvcmQpDQo+IA0KPiANCj4gVGhlIGxvZ3Mgc2hvdzoNCj4gDQo+IEZl
YiAyMyAyMDowODo1NyBNYWNCb29rIGtlcm5lbDogdXNiY29yZTogcmVnaXN0ZXJlZCBuZXcgaW50
ZXJmYWNlIGRyaXZlciBicmNtZm1hYw0KPiBGZWIgMjMgMjA6MDg6NTcgTWFjQm9vayBrZXJuZWw6
IGJyY21mbWFjIDAwMDA6MDU6MDAuMDogZW5hYmxpbmcgZGV2aWNlICgwMDAwIC0+IDAwMDIpDQo+
IEZlYiAyMyAyMDowODo1NyBNYWNCb29rIGtlcm5lbDogYnJjbWZtYWM6IGJyY21mX2Z3X2FsbG9j
X3JlcXVlc3Q6IHVzaW5nIGJyY20vYnJjbWZtYWM0MzY0YjMtcGNpZSBmb3IgY2hpcCBCQ000MzY0
LzQNCj4gRmViIDIzIDIwOjA4OjU3IE1hY0Jvb2sga2VybmVsOiBicmNtZm1hYyAwMDAwOjA1OjAw
LjA6IERpcmVjdCBmaXJtd2FyZSBsb2FkIGZvciBicmNtL2JyY21mbWFjNDM2NGIzLXBjaWUuQXBw
bGUgSW5jLi1NYWNCb29rUHJvMTYsMS5iaW4gZmFpbGVkIHdpdGggZXJyb3IgLTINCj4gRmViIDIz
IDIwOjA4OjU3IE1hY0Jvb2sga2VybmVsOiBicmNtZm1hYyAwMDAwOjA1OjAwLjA6IERpcmVjdCBm
aXJtd2FyZSBsb2FkIGZvciBicmNtL2JyY21mbWFjNDM2NGIzLXBjaWUuYmluIGZhaWxlZCB3aXRo
IGVycm9yIC0yDQo+IEZlYiAyMyAyMDowODo1NyBNYWNCb29rIGtlcm5lbDogYnJjbWZtYWMgMDAw
MDowNTowMC4wOiBicmNtZl9wY2llX3NldHVwOiBEb25nbGUgc2V0dXAgZmFpbGVkDQo+IA0KPiBJ
IGFsc28gdGVzdGVkIHRoZSBwYXRjaGllc3QgaW4gdGhlIGZvbGxvd2luZyBsaW5rLCBhbmQgd2lm
aSBtb3N0bHkgd29ya2VkIHRoZXJlIChvY2Nhc2lvbmFsbHkgaXQgY29tcGxhaW5lZCBhYm91dCBz
b21lIHBpYyBlcnJvciwgSeKAmWxsIHNhdmUgdGhlIGxvZ3MgbmV4dCB0aW1lIEkgZW5jb3VudGVy
IHRoYXQpIDoNCj4gDQoNClNvcnJ5IGZvciB0aGUgdHlwb3MgaGVyZSAodGhhbmtzIHRvIGF1dG9j
b3JyZWN0KQ0KDQpJdCBzYXlzDQoNCkkgYWxzbyB0ZXN0ZWQgdGhlICpwYXRjaHNldCogaW4gdGhl
IGZvbGxvd2luZyBsaW5rLCBhbmQgd2lmaSBtb3N0bHkgd29ya2VkIHRoZXJlIChvY2Nhc2lvbmFs
bHkgaXQgY29tcGxhaW5lZCBhYm91dCBzb21lICpwY2kqIGVycm9yLCBJ4oCZbGwgc2F2ZSB0aGUg
bG9ncyBuZXh0IHRpbWUgSSBlbmNvdW50ZXIgdGhhdCkgOg0KPiANCj4gaHR0cHM6Ly9naXRodWIu
Y29tL3QybGludXgvbGludXgtdDItcGF0Y2hlcy9ibG9iL21haW4vODAwMS1hc2FoaWxpbnV4LXdp
ZmktcGF0Y2hzZXQucGF0Y2gNCj4gDQo+IFRoYW5rcw0KPiBBZGl0eWENCj4gDQo+PiBPbiAxNC1G
ZWItMjAyMywgYXQgMTozMCBQTSwgSGVjdG9yIE1hcnRpbiA8bWFyY2FuQG1hcmNhbi5zdD4gd3Jv
dGU6DQo+PiANCj4+IEhpIGFsbCwNCj4+IA0KPj4gVGhpcyBzaG9ydCBzZXJpZXMgYWRkcyB0aGUg
bWlzc2luZyBiaXRzIHRvIHN1cHBvcnQgQXBwbGUgVDIgcGxhdGZvcm1zLg0KPj4gDQo+PiBUaGVy
ZSBhcmUgdHdvIHF1aXJrczogdGhlc2UgZGV2aWNlcyBoYXZlIGZpcm13YXJlIHRoYXQgcmVxdWly
ZXMgdGhlDQo+PiBob3N0IHRvIHByb3ZpZGUgYSBibG9iIG9mIHJhbmRvbW5lc3MgYXMgYSBzZWVk
IChwcmVzdW1hYmx5IGJlY2F1c2UgdGhlDQo+PiBjaGlwc2V0cyBsYWNrIGEgcHJvcGVyIFJORyks
IGFuZCB0aGUgbW9kdWxlL2FudGVubmEgaW5mb3JtYXRpb24gdGhhdA0KPj4gaXMgdXNlZCBmb3Ig
QXBwbGUgZmlybXdhcmUgc2VsZWN0aW9uIGFuZCBjb21lcyBmcm9tIHRoZSBEZXZpY2UgVHJlZQ0K
Pj4gb24gQVJNNjQgc3lzdGVtcyAoYWxyZWFkeSB1cHN0cmVhbSkgbmVlZHMgdG8gY29tZSBmcm9t
IEFDUEkgb24gdGhlc2UNCj4+IGluc3RlYWQuDQo+PiANCj4+IENoYW5nZXMgc2luY2UgdGhlIG1l
Z2FzZXJpZXMgZnJvbSBhIH55ZWFyIGFnbzogbWFkZSB0aGUgQUNQSSBjb2RlIGJhaWwNCj4+IGlm
IHRoZXJlIGlzIG5vIG1vZHVsZS1pbnN0YW5jZSwgc28gd2UgZG9uJ3QgdHJ5IHRvIGdldCB0aGUg
YW50ZW5uYQ0KPj4gaW5mbyBhdCBhbGwgaW4gdGhhdCBjYXNlIChhcyBzdWdnZXN0ZWQgYnkgQXJl
bmQpLiBNYWRlIHRoZSByYW5kb21uZXNzDQo+PiBjb25kaXRpb25hbCBvbiBhbiBBcHBsZSBPVFAg
YmVpbmcgcHJlc2VudCwgc2luY2UgaXQncyBub3Qga25vd24gdG8gYmUNCj4+IG5lZWRlZCBvbiBu
b24tQXBwbGUgZmlybXdhcmUuDQo+PiANCj4+IEhlY3RvciBNYXJ0aW4gKDIpOg0KPj4gYnJjbWZt
YWM6IGFjcGk6IEFkZCBzdXBwb3J0IGZvciBmZXRjaGluZyBBcHBsZSBBQ1BJIHByb3BlcnRpZXMN
Cj4+IGJyY21mbWFjOiBwY2llOiBQcm92aWRlIGEgYnVmZmVyIG9mIHJhbmRvbSBieXRlcyB0byB0
aGUgZGV2aWNlDQo+PiANCj4+IC4uLi9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvTWFrZWZp
bGUgICAgICB8ICAyICsNCj4+IC4uLi9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvYWNwaS5j
ICAgICAgICB8IDUxICsrKysrKysrKysrKysrKysrKysNCj4+IC4uLi9icm9hZGNvbS9icmNtODAy
MTEvYnJjbWZtYWMvY29tbW9uLmMgICAgICB8ICAxICsNCj4+IC4uLi9icm9hZGNvbS9icmNtODAy
MTEvYnJjbWZtYWMvY29tbW9uLmggICAgICB8ICA5ICsrKysNCj4+IC4uLi9icm9hZGNvbS9icmNt
ODAyMTEvYnJjbWZtYWMvcGNpZS5jICAgICAgICB8IDMyICsrKysrKysrKysrKw0KPj4gNSBmaWxl
cyBjaGFuZ2VkLCA5NSBpbnNlcnRpb25zKCspDQo+PiBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVy
cy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2FjcGkuYw0KPj4gDQo+
PiAtLSANCj4+IDIuMzUuMQ0KPj4gDQo+PiANCj4gDQo=
