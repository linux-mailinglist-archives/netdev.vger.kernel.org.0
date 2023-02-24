Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 012D66A1CED
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 14:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjBXNWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 08:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjBXNWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 08:22:44 -0500
Received: from IND01-MAX-obe.outbound.protection.outlook.com (mail-maxind01olkn2044.outbound.protection.outlook.com [40.92.102.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6E86696F;
        Fri, 24 Feb 2023 05:22:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DjEWdqeyYVv3cw2SPDfB/EzGf+Ow+KwldnodpGBmrBRzzmRe6wOs+sLIVfMbSXEtuPOSvPUh9yoEx6PhthQsnVdWv4mFLKr5r7qxKUoIpwxTPQQx/fP1ujbs4gA+lg+lvo+U+QLioDvYKpoy6/yqhAR633ZsAEOH0dHMcvjZWLw4OLR40qkocRayFBHkuBRQc2RxY6OX+zWYFVR3ByB2PI72O25yvZFkLfU8KZ95wmqSFCk+uhMNibcXOM+nnwzOSEQjuVcuRzFAXtRpMQU3NKW86+R1x2OCB1psysToZIWVz3620615dBHqCILqBwIwM6jyXkoar/t04H9M03zGXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jVpMMAGOuE8VK7thiK8Tm4H3/MWF8qu8KqVcVu1IKbg=;
 b=es2p2SuDHeYw0RV8GCZpUTHOVdA5sdYa0RVMpb1lcMuFs6BGlJHyrA2xbY0pJOcqIug9SFUAMZHwf/W1ZXbUTqMsnZSYXYAkrqQZHMv7PqrhyQ1NxwdSLZfrp19zKlr4SVy3D+aMraPDb4AP9HZ7ccKx1m0t0s22kisosGLgkbykvYnA8KsDflw+g7iRrgwKEwBCm0/XuvFomXBF4WQPV/lHt69ZhceQuP8vsY6b2Y5D9vglVGyP0iZq/3E7xl2Abf9BsCVrPkeZkn0PgqERzoM+E8ecgKsLNfUUqYqVyDYRxbXtlFYRIdhRFeNfu1m6A7K0Eygdsj771SaI0P2YJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jVpMMAGOuE8VK7thiK8Tm4H3/MWF8qu8KqVcVu1IKbg=;
 b=NBUmvt4mVTwI866BpBEB/kOswsXX5R17jE7YMw1HUOv99/eDqi0YpocQZ1NfMZrmBoG/uqKDM3tOU2lP6Lbpn3xbMWcNG0sNDmmtVVYmbvVYMEEtRb3Fb5Di+oOlVeh3SuwXTHVqDvxyF9DJodaJ7Rza4NuOB2ZPlJiysEdMpS1afAuMxVyj8kuC7dU9nUburliunaRV3clTDu1r61oLG+HcaFI1RaqmQ/eRpW3HFg1KTkDgHMe3XugJ3nAXYWlXt0a59AHti2a9oLk+J5B6YBXShQ5G0g+ZInLHaQ07VvKoCt7x2M4t3HAdTyoNJjMnOjFcUrC0I8eelwyv9UXURA==
Received: from BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:2::9) by
 MA0PR01MB7596.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a01:29::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6134.18; Fri, 24 Feb 2023 13:22:33 +0000
Received: from BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::f156:868f:a45b:aeee]) by BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::f156:868f:a45b:aeee%11]) with mapi id 15.20.6156.007; Fri, 24 Feb
 2023 13:22:33 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Kalle Valo <kvalo@kernel.org>
CC:     Hector Martin <marcan@marcan.st>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
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
Thread-Index: AQHZR5e26B2arN4fj02dzTxrW7w7KK7eEkWHgAABuMaAAALubw==
Date:   Fri, 24 Feb 2023 13:22:33 +0000
Message-ID: <BM1PR01MB09314C99F20D73ED6455B7F7B8A89@BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM>
References: <20230214080034.3828-1-marcan@marcan.st>
        <379F9C6D-F98D-4940-A336-F5356F9C1898@live.com>
        <BM1PR01MB09315D50C9380E9CB6471E9EB8A89@BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM>
 <87leknrywd.fsf@kernel.org>
In-Reply-To: <87leknrywd.fsf@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [4GFZbDxPC7Ru2ecaJKEgfPMIhGiLCyjZK7YQ0SkWJfWXw0IIXx0OCTvki4EpBLhQ]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BM1PR01MB0931:EE_|MA0PR01MB7596:EE_
x-ms-office365-filtering-correlation-id: 8253a01f-ec18-4bfd-4f07-08db166a3009
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LG/ht0fhCZSQ2CuyBNPZ6Kup7NYM4dEPOkpRxyaYgxOoOQfA5Xs2c1qi1YgG9WXePoliYjTLDZWgI64YwxLll1u+88QlpF7RyJDVdOcSFAd2tUHPI8n8HPZoG7SSGh19LG2OyMN9GTFN0CU+CJebUjoaOhHro5f0KIfVecithMARvnLU8zpJfdZaSvPXGLtVX8zR6w7MXEBJ+WSJLo2dDv0Q+9//RoQGSqWVCzfUU3iNRClbuysV/L5sjlpZngtFSv+IvSyqcBDWw6SMYeaW71POIfHTYP4YzGDhmburyJMZkUX6OGi6vsOiTHmbJeOFjjOAoIBEEuqhvNYUtgjZxZtnemtbLSe/OL4bhGFUI93SetVFu+aYZKTqUMCz0cWH1J8H5XAcqnPm9HXkKJXjjLilpO/Mve2OkgheMWwybSemWmez0R51VA2PjFX1QBL2IzK3UZmdFkFXuKAGJhWoaEHdfetIYEkzOcaP5DQhCWFJf0+LVc4dRIA1yfA7X3MXNhA8Isew5Vp9vP2FfiiMrEH5c5Zi+6mQ9ZZEFkfGjNinW3dMcgBgdmxnMCNA7PnEzlBTwcaJLEmn3buPObbH2WGoVjuagxKO4scmP9LiiAsUGoFVA5EMmY/TAVu8daxtUTtPgFpsblVVFqqX1rowD88P18VhsIIzZGiNkyCElB1sYYVYi60sR39k5Ms2qB1Z
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c3hrZ1p4UDNMWDVXUmFKbkw2dzl1VDRhRWZWMlI1cDM1UkszcXJFdm5ySzZL?=
 =?utf-8?B?OUl0K0dlN1B5NzJYeWFQQmczV2swcG1MYTF6SktMaW9qRllqMzVkeENOVXU5?=
 =?utf-8?B?dmtvaGNCVjBpSFlxZGdUWmxEUVNXdTBhVjU0ZUh0d3JpZmlBV2Z4Uk16Wk01?=
 =?utf-8?B?azZyVjExc21GSk52aW1MTi9ldFBTU1lWQzNubXNJMlpldmc3aGV2dm5Oakxk?=
 =?utf-8?B?NlBDYXFqaDlmUlZyRzZ3SklpLzZIRWdHMko5Uk1ZQk5GclZTU3pBNXBUb2c4?=
 =?utf-8?B?QWh6Um9MQTgxcDdERGpseVlSUzhnd2YzN0JKWFFwcHhma0E3WGx4TFdWKzJ3?=
 =?utf-8?B?M0tZUlNYV0xIVUt5Nm5PVHJrY29KYkRrN1dIWHh1cFFDeFdQNzM4Q1JBUW5O?=
 =?utf-8?B?WEIxblFhVTdLc3FiME5USHFVVVRXVmZBdGRoaXFoa2xpcVZmRmJrRlNIMzRq?=
 =?utf-8?B?ZFpOL3NzSzc0Q2g4TXhnbktyOEIrSjNOVkJFR0NYZ3NiUHZCWmhDZ2I3YTJT?=
 =?utf-8?B?dU9yRjdjQTczT1E2MlRJNlFTaGJoQ25hZkpVSkZqQU8rUysyQjZ2Nkx0akdJ?=
 =?utf-8?B?M3lmcmlicDc2ZTVBYmtpVkZJZVdrZExOQldnL2FFRVoySUZRbEJDWmFpTUdK?=
 =?utf-8?B?N3k4amFtbTM4OG5kbzZ5ak9DREhoZ1NnV2dnLzVzV3I2LzRyUVNHQkxuN0h3?=
 =?utf-8?B?eEpDdG9mai83UGJsMkRpY2VOMWdXZmExS041cGtZN0N2eDN0aHp2RjQ3b2Zw?=
 =?utf-8?B?cjNIR2VES0NwWXpUT2JVYUUzbjR1elhZbHI1RHk4d2Q0ZlZ5Q1dpVkwzV1NS?=
 =?utf-8?B?cVlkZzUvdzhaSS9MQTBQbGZhZTN4V0ZRN1Y2Qm5DQVdVbnk4OUlYTVVxcXRt?=
 =?utf-8?B?TSs3dHRsbURKMm1NcGxyRTNwd3lNYU93NGZkZngxWlcya1NCb1Fjems4R3Jh?=
 =?utf-8?B?WTRhbitRa0tTWitrQy9ENVNsc3JmRDFSQWJ2dmhwTXRkUmFVdnF0dk8vZ0Zw?=
 =?utf-8?B?OUJHemExckUvSi9PNE81MUgrRFI4NnBZRnl1ZmhNU1dJM3g0UEtnai91ZVFD?=
 =?utf-8?B?S1VQUlB2T3diUjIrOGZ4bnRTMk41bGEzaHR3c2sydFNwM3ZNZG51K0w2cTMy?=
 =?utf-8?B?YitDSTlnanhHK3pPSzBabDk3RWM3OFViQXVBU2R4cGs3dzJlNkZ6UUxRSWw1?=
 =?utf-8?B?UVdZQ2JTQVRId0orbWpuTEVrWGNJdkt3aE5ESUpvdWZYUjJ1RTVDblNndWM0?=
 =?utf-8?B?Zk92MnZ6Vkp1eFFJektjL21NU1FJWXVIeWRiYlJka2ZmTlh3RFMveWR4V1ZD?=
 =?utf-8?B?L2RNcU0yZ25DNW9Zcy9peVhkblJ1KzZ5S2pzRVRsUEhydHloQ3JlYXI3TVFL?=
 =?utf-8?B?SC9rMitxV0xVMjdoOTVlbUpYajdxMktVOXBzVUNheENJQmJKQlFXdmNtSkRY?=
 =?utf-8?B?b3VEUnV1dEdMSFYyNXZNMjVRWGhkUnZzOFFheDNnU0l3Y3A4a0lPaUx5U29n?=
 =?utf-8?B?ZmplZ1hQcXlmU1ZNVFloTFI2MHVYVW9yRTVLTkhlTmYrOTlXK00wc3NwV3Nl?=
 =?utf-8?B?Z0dMdjhDYWdXczU1d3NkeExjSktIczMxWEpHUlAwbzFOTFo4RG51QzVIQXFv?=
 =?utf-8?B?WndUajcxLy9rNXR5ZzlxVVJsUFlTVnJDeVMyZURiSTd6MUJMMmtLeEFmNWpr?=
 =?utf-8?B?VGVyN3B0aWJmZFZQVWdtUnloQ3I0T3RiRG5wbHIrS2l5YjRMMmY5c1pUMFI4?=
 =?utf-8?B?elZKOEFPMnQ4UnpqNUpPL0pWUXlEUElYZ3k2aEpINGpkVmYwVzJraTZ6RkxP?=
 =?utf-8?B?RFJKcjVPWHREbmdSSUlVUT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 8253a01f-ec18-4bfd-4f07-08db166a3009
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2023 13:22:33.0849
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MA0PR01MB7596
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gMjQtRmViLTIwMjMsIGF0IDY6NDIgUE0sIEthbGxlIFZhbG8gPGt2YWxvQGtlcm5l
bC5vcmc+IHdyb3RlOg0KPiANCj4g77u/QWRpdHlhIEdhcmcgPGdhcmdhZGl0eWEwOEBsaXZlLmNv
bT4gd3JpdGVzOg0KPiANCj4+IE9uIDIzLUZlYi0yMDIzLCBhdCA4OjMxIFBNLCBBZGl0eWEgR2Fy
ZyA8Z2FyZ2FkaXR5YTA4QGxpdmUuY29tPiB3cm90ZToNCj4+IA0KPj4g77u/SGkgSGVjdG9yDQo+
PiANCj4+IEnigJl2ZSBhcHBsaWVkIHRoZSBmb2xsb3dpbmcgcGF0Y2hzZXQgKGFycmFuZ2VkIGlu
IGNocm9ub2xvZ2ljYWwgb3JkZXIpIHRvIGxpbnV4IDYuMiwNCj4+IGFuZCB3aWZpIHNlZW1zIHRv
IGhhdmUgYnJva2VuIG9uIE1hY0Jvb2tQcm8xNiwxIChicmNtZm1hYzQzNjRiMykNCj4+IA0KPj4g
aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYXNhaGkvMjAyMzAyMTIwNjM4MTMuMjc2MjItMS1tYXJj
YW5AbWFyY2FuLnN0L1QvI3QNCj4+IChCQ000MzU1LzQzNjQvNDM3NyBzdXBwb3J0ICYgaWRlbnRp
ZmljYXRpb24gZml4ZXMpDQo+PiANCj4+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FzYWhpLzIw
MjMwMjE0MDgwMDM0LjM4MjgtMS1tYXJjYW5AbWFyY2FuLnN0L1QvI3QgKEFwcGxlIFQyDQo+PiBw
bGF0Zm9ybSBzdXBwb3J0KQ0KPj4gDQo+PiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hc2FoaS8y
MDIzMDIxNDA5MTY1MS4xMDE3OC0xLW1hcmNhbkBtYXJjYW4uc3QvVC8jdCAoQkNNNDM4Nw0KPj4g
LyBBcHBsZSBNMSBwbGF0Zm9ybSBzdXBwb3J0KQ0KPj4gDQo+PiBodHRwczovL2xvcmUua2VybmVs
Lm9yZy9hc2FoaS9iNDQ4OWUyNC1lMjI2LTRmOTktMTMyMi1jYWI2YzEyNjlmMDlAYnJvYWRjb20u
Y29tL1QvI3QNCj4+IChicmNtZm1hYzogY2ZnODAyMTE6IFVzZSBXU0VDIHRvIHNldCBTQUUgcGFz
c3dvcmQpDQo+PiANCj4+IFRoZSBsb2dzIHNob3c6DQo+PiANCj4+IEZlYiAyMyAyMDowODo1NyBN
YWNCb29rIGtlcm5lbDogdXNiY29yZTogcmVnaXN0ZXJlZCBuZXcgaW50ZXJmYWNlIGRyaXZlciBi
cmNtZm1hYw0KPj4gRmViIDIzIDIwOjA4OjU3IE1hY0Jvb2sga2VybmVsOiBicmNtZm1hYyAwMDAw
OjA1OjAwLjA6IGVuYWJsaW5nIGRldmljZSAoMDAwMCAtPiAwMDAyKQ0KPj4gRmViIDIzIDIwOjA4
OjU3IE1hY0Jvb2sga2VybmVsOiBicmNtZm1hYzogYnJjbWZfZndfYWxsb2NfcmVxdWVzdDogdXNp
bmcNCj4+IGJyY20vYnJjbWZtYWM0MzY0YjMtcGNpZSBmb3IgY2hpcCBCQ000MzY0LzQNCj4+IEZl
YiAyMyAyMDowODo1NyBNYWNCb29rIGtlcm5lbDogYnJjbWZtYWMgMDAwMDowNTowMC4wOiBEaXJl
Y3QgZmlybXdhcmUgbG9hZCBmb3INCj4+IGJyY20vYnJjbWZtYWM0MzY0YjMtcGNpZS5BcHBsZSBJ
bmMuLU1hY0Jvb2tQcm8xNiwxLmJpbiBmYWlsZWQgd2l0aCBlcnJvciAtMg0KPj4gRmViIDIzIDIw
OjA4OjU3IE1hY0Jvb2sga2VybmVsOiBicmNtZm1hYyAwMDAwOjA1OjAwLjA6IERpcmVjdCBmaXJt
d2FyZSBsb2FkIGZvcg0KPj4gYnJjbS9icmNtZm1hYzQzNjRiMy1wY2llLmJpbiBmYWlsZWQgd2l0
aCBlcnJvciAtMg0KPj4gRmViIDIzIDIwOjA4OjU3IE1hY0Jvb2sga2VybmVsOiBicmNtZm1hYyAw
MDAwOjA1OjAwLjA6IGJyY21mX3BjaWVfc2V0dXA6IERvbmdsZSBzZXR1cA0KPj4gZmFpbGVkDQo+
PiANCj4+IEkgYWxzbyB0ZXN0ZWQgdGhlIHBhdGNoaWVzdCBpbiB0aGUgZm9sbG93aW5nIGxpbmss
IGFuZCB3aWZpIG1vc3RseSB3b3JrZWQgdGhlcmUgKG9jY2FzaW9uYWxseSBpdA0KPj4gY29tcGxh
aW5lZCBhYm91dCBzb21lIHBpYyBlcnJvciwgSeKAmWxsIHNhdmUgdGhlIGxvZ3MgbmV4dCB0aW1l
IEkgZW5jb3VudGVyIHRoYXQpIDoNCj4+IA0KPj4gaHR0cHM6Ly9naXRodWIuY29tL3QybGludXgv
bGludXgtdDItcGF0Y2hlcy9ibG9iL21haW4vODAwMS1hc2FoaWxpbnV4LXdpZmktcGF0Y2hzZXQu
cGF0Y2gNCj4+IA0KPj4gVGhhbmtzDQo+PiBBZGl0eWENCj4+IA0KPj4gSSBqdXN0IG5vdGljZWQg
dGhhdCB0aGUgcGF0Y2ggdG8gQUNQSSB3YXMgbWlzc2luZy4gQWRkaW5nIHRoYXQgZml4ZWQgdGhl
IGlzc3VlLg0KPj4gDQo+PiBodHRwczovL2dpdGh1Yi5jb20vdDJsaW51eC9saW51eC10Mi1wYXRj
aGVzL2Jsb2IvbWFpbi84MDA1LUFDUEktcHJvcGVydHktU3VwcG9ydC1zdHJpbmdzLWluLUFwcGxl
LV9EU00tcHJvcHMucGF0Y2gNCj4gDQo+IFBsZWFzZSBkb24ndCB1c2UgSFRNTCwgb3VyIGxpc3Rz
IGRyb3AgdGhvc2UuIEknbGwgcmVwbHkgaW4gdGV4dC9wbGFpbiBzbw0KPiB0aGF0IGlzIGluZm8g
aXMgYXJjaGl2ZWQuDQo+IA0KSGkNCg0KU29ycnkgZm9yIHRoYXQuIEkgYWN0dWFsbHkgZm9yZ290
IHRvIGZvcm1hdCB0aGF0IGVtYWlsIGFzIHBsYWluIHRleHQuDQo+IC0tIA0KPiBodHRwczovL3Bh
dGNod29yay5rZXJuZWwub3JnL3Byb2plY3QvbGludXgtd2lyZWxlc3MvbGlzdC8NCj4gDQo+IGh0
dHBzOi8vd2lyZWxlc3Mud2lraS5rZXJuZWwub3JnL2VuL2RldmVsb3BlcnMvZG9jdW1lbnRhdGlv
bi9zdWJtaXR0aW5ncGF0Y2hlcw0K
