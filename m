Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9B065D7A7
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 16:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239639AbjADP40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 10:56:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239277AbjADP4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 10:56:24 -0500
Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2061.outbound.protection.outlook.com [40.92.103.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA722AE9;
        Wed,  4 Jan 2023 07:56:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JmSKv0BsP+ekqBs3bcCKHd0is60UbcpErYNkAZQE7L/3sU3t433er+bU9okjmRX49tTH7PRZ+AxKQ+hipW27g86Naen9f8a66xPX9KcNeCjBOfackhI2jAVvsDpLLcLJPfoOOe/q40sczx0fWNFVVRMnOs0ttgww4oKf0wlY7ue1yeVwHiJWZy6/dLsagU6JckrwZtCv69Bqc308irFRf1jr2s1Yyic+bQyc9bsKqKG8hm7GEzprMLosskiodiFVLxmefkL0udcPALTkTLJ0nPGTSPsd5RI+VbAg/7ycAXUEXJjv1VVF1oPylX7sEpFzxmlKgkrhzsXC1FJKrsC7Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TBVQyhFdC0YHBfbxjaL/VnhW3r6c0ZcCJ1EGGYYzsrc=;
 b=d0tli+bxNdy1zUm10oQcG9qZUnrDeYB0XOpppHTIUMJnSZXqJ1KsuqFJCK04Htd1Ls6jKhtZlDaYEyzeI2zTeKVAy1/jgoHuNqi37A04VYKOz3uoAkjtzh3StsZUJnLwmto8OSzqLfOEAP9Ec15tLUml7GhLmDzvkQm3leZ69Md0uKXCqN8ziVI/lD0eEfW/BrfparI7djpFchB2XoTJmdbfN0xhMbEgyEuaOtGbNk/T+WLJ4jfmvyORPoEEtcGZhVzYjUKkpQg5rYJUYLrOjRzUgmXiNljhLdf5ZL0PuFq8i4BaRFtVFU0MRyJ6h18wNPzknp+iqPA5EaR82zJ8TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TBVQyhFdC0YHBfbxjaL/VnhW3r6c0ZcCJ1EGGYYzsrc=;
 b=gjpzU3TJrDakPM0UfUxZ9Dq2jPvhrlw0FtTfrBe1OPydzeY/JOCWtWpmk16sCmnzPlB8jRxGY/JYqCIN8he2X0+pG2pWZtQIXsynQSxIR0Su6wh8ZdgMaDxcmpYfGNtPp/NW+79PUx03Ttf4sXg15khWjvoEbNHqUAamz9xN1zIapiORO4flmhkztuRaowM3DIquJruIksbtiEmnBRGAYHMiOpK2C4RKIINdvBh/TdYFo9BJcP/ytG7PP29rCB2HlAvPomnuSYYDr9mh3tuh2KW8kBVFubQt2CH/3oNXqhCS9XQ9RgoUUaIr70dlXgyLP69L1G/sxWxO3Lg5ZyjGTw==
Received: from BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:2::9) by
 MAZPR01MB5695.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a01:63::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.19; Wed, 4 Jan 2023 15:56:14 +0000
Received: from BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::f90e:46bc:7a0f:23bc]) by BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::f90e:46bc:7a0f:23bc%7]) with mapi id 15.20.5944.019; Wed, 4 Jan 2023
 15:56:14 +0000
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
        Alexander Prutskov <alep@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Ian Lin <ian.lin@infineon.com>,
        Soontak Lee <soontak.lee@cypress.com>,
        Joseph chuang <jiac@cypress.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        "asahi@lists.linux.dev" <asahi@lists.linux.dev>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v1 4/4] brcmfmac: pcie: Perform correct BCM4364 firmware
 selection
Thread-Topic: [PATCH v1 4/4] brcmfmac: pcie: Perform correct BCM4364 firmware
 selection
Thread-Index: AQHZIFUSEFBryofprUeqp4fURzKUtg==
Date:   Wed, 4 Jan 2023 15:56:14 +0000
Message-ID: <4AC571A3-D90C-4BE6-A413-74C9142FF604@live.com>
References: <20230104100116.729-1-marcan@marcan.st>
 <20230104100116.729-5-marcan@marcan.st>
In-Reply-To: <20230104100116.729-5-marcan@marcan.st>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [vgmokLZvB0LodnavtZtyJai6lGdk3tQ7jGk27G0mW7YXfLHV2fyBEsjvNO8LTKez]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BM1PR01MB0931:EE_|MAZPR01MB5695:EE_
x-ms-office365-filtering-correlation-id: 64c7e031-7011-49a7-f67f-08daee6c3511
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L+S/I8uhzqvfxI587aQDAx8l5gEbTMUFIWeG2J4Z7N/mKKN5wPeOuRmJRmUjX7SS180+D4W2O2If4m8+zv9WzCqYNvDSu6waINZ/MobpfolKKPrsJ8LLoqtuSY4Rlwpi3iWZ9yKCeDXXp+PlNuNgHMbvJ4acgTJBZIv6em1Krf2CV6PRUcPvDbzCGR8nsg2UmNjyXD2Y+OSrP8twJqvPcfzCxqX+Nh4EBpxDXoy1sYuea+H9A3YTueaSFZvs+gQ5xXQys4qpn5y81yfp7Vk23tAb90ik9ZT3x69thTtFYP52XF6jBviUgmQ2KYDCkcMHjf1hVY9mOz5QU7RoOWt0trnjrjW0l87shj21PTun+ZNjMOzsarYI4st8U8H6RCEBraEIIXVsHBrS/SbpNFgl8v6dHSU661Y4lxIU3LeCbqwkOHtR6Nkevlk2LzuGkB5RsjJ//1MRmN3RdoYT9IZeKUdsyTyx+G2tNRGWmUsROhbus/eRkZQ/90JcS7kSSNUIuKtlsS/C82pUtF1zS2G4ftWGADRx43DXAlECon3SEMmVQAmCMDsyo5WhnyW8Ia/i3zN4DC59Fw0/wRSeMM6kTH2WMI3MxVd0l+77/f2OY//ZD2FTgVNKbwCDfXYU3Ay9wnm/IO1ew3n+6jv1DBle6w==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SHE0Uk9yenMzYndObU12UEhQY00wcUNYb0tJdGhlVlZiWjNZcVZJUUZXVExo?=
 =?utf-8?B?WHpZRzBRQ1h6SHNXMVM0TXo5UzBBbVR2SWVmdCt6dkJ4cWlyMEJhanBLWHJh?=
 =?utf-8?B?bEN0ZUNIczl3QWN2VHBxeDRRUUN2akMxSWxaRTEzL1U1Y25tem1veU5RSWZM?=
 =?utf-8?B?WU1WcVFXVDJLdGNoSWsrd3l4M3JBQ3VEbi8rTWxYWjU2ZHMwZkNmdWQzbkF4?=
 =?utf-8?B?R2Rwcm1rYzErMTFSQ0N6SEFKUmVBOG1PTXNJUmlJWURnVjgydGxSbmI5M2Nm?=
 =?utf-8?B?V2FacnVidGd3NHRnWXhxR3J0UndhcVhvTm5IU3U3TXBWT05iNU91Sy9DWHhm?=
 =?utf-8?B?NjZtTGVQYTV2eHJ3S1BJRHBxQWJTZlRSbjFzVGhPTzZiZDZ4UmRqdXZ0eEEw?=
 =?utf-8?B?STVyN0hrdDhuS1FlMCtLWXVBTExjTHFRNlRqVi9mYUZWSktwWVA0dk9Ob3Uv?=
 =?utf-8?B?bm1vYUo3QytVNENTbUpxQzdhSUxSbldlbEpZMCtkMm1IdVN2NU9VTENTdXFC?=
 =?utf-8?B?dXJwK0ZybktCSmEyV3A2ZE1kV3p2ODZWaFdUQjc0OElQQVdSU0xpaTVMV2tM?=
 =?utf-8?B?L3hNT0VQY2VHWUJib2JScjRNSnNQdWdiK01pcW5XTy94bkgzU2t5d083WDhO?=
 =?utf-8?B?aEpnY2RSTy92cUlQL2dTRnp1RXBvcFdmR3BCbEt3Zm1PSTYydWRiZk9JRTJT?=
 =?utf-8?B?Uk1ZRnFqRjc4R3NhZE5CNVhzN3J4RkVremQ4emhBbXR5T3lmMXFFbWM4S0N3?=
 =?utf-8?B?NU5FdTJVZnU2NDFkb3FFc1RTQUJIbWlVOWxxMG0rSndDa1dHZW9saWw5Mmpr?=
 =?utf-8?B?NEQ3OGpjWVF0a0NYUkJ2bDdicjk3U0piblNtaGp6SU90eEJ0Zk9WLzkyVmVk?=
 =?utf-8?B?T3NIWjlxWDZIVC9Ic1Y2ak9oYjUxbllMbjJWY3Fvb1JTTEdiRU91bHJiVHJZ?=
 =?utf-8?B?RnZ6aE5GWDlVMXAySE1qSWh5ZlUzY1JsYklTVy9ubVJlc0VSTUVZNDVkSGdv?=
 =?utf-8?B?V2E4SVdibmRrQVdoRHhkdnJJdFdwd3E1TDdUL2hhWDI2ZTFDY283RmRDeDZn?=
 =?utf-8?B?T0ZLSWh0dzNpZzBtWG92SDRVV2dBKzF4QU5LbDdWQlB4ZElwL3RCS21yVkhC?=
 =?utf-8?B?RnptS29yM0pqbnhiYmh5MExMeW13eE95V0VaUVVYTk14WkJYeHRvVU5VQXZy?=
 =?utf-8?B?U25YYlZIdWkyNlhEYVV2Qnlnb3JBUENyczI2SC9jZ3AybTkvM091SVZPeEE1?=
 =?utf-8?B?Z3IzSFJnZWdadERJdmFzNk0reDdBcXhVd1lGaHpsQzlMNnEvV29VaEpxWjcw?=
 =?utf-8?B?V0dQT2N6MnBUaGxjRkpaZndmVlZsOVhyK0FwWEJOblF0eEd5REc1RHVlVlB4?=
 =?utf-8?B?b3hORUpkZDM0ei9WTDU1WUhucGRQRFhiMHNTK1IzMUM5L3FHbDllbVFzdFJM?=
 =?utf-8?B?TUZ5TDJyT3FiU0VQc095TFJvai9kMXlQWU9hazZlY0ZaQTF0MTlEaG9LMVc5?=
 =?utf-8?B?TTErb0RPdkczRVZJRXlGaDRCSmxsMmI2TjZUUGxVNUtkN0xnQWdKVG52SDdL?=
 =?utf-8?B?c3hhcHcrWldVQ3ExYmtUK3RYSDFXWVhvT3gvTXFWYkQzSWJEdFh1cHdjMXRo?=
 =?utf-8?B?K0QzL2JhWVRHUWlKaUl6Wk1pVHNyaUFuR0J3WGphbmlndy9zK21QNVU3YS93?=
 =?utf-8?B?NitIV1g1Z0pvQTB0M1VZSlNZNTR6L3BQSHdqMzNaOXNwMHpYUjJRUHNzQ2hJ?=
 =?utf-8?B?S2VJbmVXMXBhZFNlWTZvVVVzSUU2eUZXamtTMENSZGlhRHdTT0VqdW0zZnlo?=
 =?utf-8?B?NVdZZ1BxbmJtQkxMSUFtdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AFE96DB990481144A500A93CCE00873A@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 64c7e031-7011-49a7-f67f-08daee6c3511
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2023 15:56:14.0282
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MAZPR01MB5695
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IE9uIDA0LUphbi0yMDIzLCBhdCAzOjMxIFBNLCBIZWN0b3IgTWFydGluIDxtYXJjYW5AbWFy
Y2FuLnN0PiB3cm90ZToNCj4gDQo+IFRoaXMgY2hpcCBleGlzdHMgaW4gdHdvIHJldmlzaW9ucyAo
QjI9cjMgYW5kIEIzPXI0KSBvbiBkaWZmZXJlbnQNCj4gcGxhdGZvcm1zLCBhbmQgd2FzIGFkZGVk
IHdpdGhvdXQgcmVnYXJkIHRvIGRvaW5nIHByb3BlciBmaXJtd2FyZQ0KPiBzZWxlY3Rpb24gb3Ig
ZGlmZmVyZW50aWF0aW5nIGJldHdlZW4gdGhlbS4gRml4IHRoaXMgdG8gaGF2ZSBwcm9wZXINCj4g
cGVyLXJldmlzaW9uIGZpcm13YXJlcyBhbmQgc3VwcG9ydCBBcHBsZSBOVlJBTSBzZWxlY3Rpb24u
DQo+IA0KPiBSZXZpc2lvbiBCMiBpcyBwcmVzZW50IG9uIGF0IGxlYXN0IHRoZXNlIEFwcGxlIFQy
IE1hY3M6DQo+IA0KPiBrYXVhaTogICAgTWFjQm9vayBQcm8gMTUiIChUb3VjaC8yMDE4LTIwMTkp
DQo+IG1hdWk6ICAgICBNYWNCb29rIFBybyAxMyIgKFRvdWNoLzIwMTgtMjAxOSkNCj4gbGFuYWk6
ICAgIE1hYyBtaW5pIChMYXRlIDIwMTgpDQo+IGVrYW5zOiAgICBpTWFjIFBybyAyNyIgKDVLLCBM
YXRlIDIwMTcpDQo+IA0KPiBBbmQgdGhlc2Ugbm9uLVQyIE1hY3M6DQo+IA0KPiBuaWhhdTogICAg
aU1hYyAyNyIgKDVLLCAyMDE5KQ0KPiANCj4gUmV2aXNpb24gQjMgaXMgcHJlc2VudCBvbiBhdCBs
ZWFzdCB0aGVzZSBBcHBsZSBUMiBNYWNzOg0KPiANCj4gYmFsaTogICAgIE1hY0Jvb2sgUHJvIDE2
IiAoMjAxOSkNCj4gdHJpbmlkYWQ6IE1hY0Jvb2sgUHJvIDEzIiAoMjAyMCwgNCBUQjMpDQo+IGJv
cm5lbzogICBNYWNCb29rIFBybyAxNiIgKDIwMTksIDU2MDBNKQ0KPiBrYWhhbmE6ICAgTWFjIFBy
byAoMjAxOSkNCj4ga2FoYW5hOiAgIE1hYyBQcm8gKDIwMTksIFJhY2spDQo+IGhhbmF1bWE6ICBp
TWFjIDI3IiAoNUssIDIwMjApDQo+IGt1cmU6ICAgICBpTWFjIDI3IiAoNUssIDIwMjAsIDU3MDAv
WFQpDQo+IA0KPiBGaXhlczogMjRmMGJkMTM2MjY0ICgiYnJjbWZtYWM6IGFkZCB0aGUgQlJDTSA0
MzY0IGZvdW5kIGluIE1hY0Jvb2sgUHJvIDE1LDIiKQ0KPiBSZXZpZXdlZC1ieTogTGludXMgV2Fs
bGVpaiA8bGludXMud2FsbGVpakBsaW5hcm8ub3JnPg0KPiBTaWduZWQtb2ZmLWJ5OiBIZWN0b3Ig
TWFydGluIDxtYXJjYW5AbWFyY2FuLnN0Pg0KPiAtLS0NCj4gLi4uL25ldC93aXJlbGVzcy9icm9h
ZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvcGNpZS5jICAgfCAxMSArKysrKysrKystLQ0KPiAxIGZp
bGUgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCg0KSGkgSGVj
dG9yDQoNClNob3VsZG7igJl0IHRoZXJlIGJlIGEgV0NDIGluc3RlYWQgb2YgQkNBIGhlcmUgOg0K
DQpodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90b3J2YWxk
cy9saW51eC5naXQvdHJlZS9kcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEv
YnJjbWZtYWMvcGNpZS5jP2g9djYuMi1yYzIjbjI2MDM=
