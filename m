Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E23F693116
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 13:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbjBKMuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 07:50:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBKMuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 07:50:02 -0500
Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2094.outbound.protection.outlook.com [40.92.103.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81BAD2105;
        Sat, 11 Feb 2023 04:50:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FlMhlMjofERQ9p9oEaC62yZ9GWfPbT/Uus2M/kH5OljatxqY5lTw9zeM00pKB3UbLWVwe1sXwEoGFB/1iPRH3coscvi2fS2okeAqXV3WIHiTJ432+6vICC2haqHF3O7YhUkPNDTxZnRu5cuUPgWOq+befR3G8y+MbEu2Ub8Uc6cCfKopaQsNeDqBXe2VHAlQ1u94nb4f0zEh3GU6puJfjNVRBJqmh5vnUSHcKGgmS5NFtE00QumcvtvGgt7tX2UpnnvPkOeEBb+IZnjVodXS7azFaW3/YGjpBKU6t8EED9ur/GDU6Tn3Wc/TAlorPTvZFfmJWNbtK9Yua94Gqg33bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qu829ga8ez1SY95FoXSyx9ce2xwmA49k++ecf46twqU=;
 b=R8x/AGj/PnARQt0Z3cVVeHs6x1fhyU6bOhUIXnulXxac74RcPSKdKfZLY34sfT9/t6a7HjD32mUYG1/NDlNiCVj4XKRC1FDqhovkoyW1F4HsWB5TLR8Bk67xVWfFN2E8nd87N9SHTWNDjBdnqyuWC73A/kWJxicm11PxvvWNt6bct8P7dhc9cXHppGB8h1llmct6F9HVjSXNZDSIfavrNJzyyjmjN1qROjGv8zIOwXe1VwlggS9f7yALmtEnRdupJhGhPjVglhJKRRzDMkfM6mOaIhMlLVZOYT9P1E8yzmjIsEOh67wJwtKX53MgQGp1EC0LGxnJhOb/ORjCEX5LxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qu829ga8ez1SY95FoXSyx9ce2xwmA49k++ecf46twqU=;
 b=u/YfpzoIoAPfy7zFJPINqRbg5dPLdSXqxs29cmv3NdP6i72oVchV2d91vk2XOL7hDSecCK2WA/Hg697dnwglpOTGA+sFhH5zzyYZFmR0LCo5Il5MFjHDK0f8jRXHtphQnVsi6gJf9p3wJenNBpRLdbcd82EmQSN1GH0FEMqundnNtzfD+ucg0/UJ9szC5qa/pxzD53W+JkkeQMFzoRYiNMkn/TjBW6hRQ+SAFd1O7xZgQxRVdakD5P4PfNILDcpImIsGhOzBBtNu2PyLTwtA+SkhYV2sWKEfovDP1gY4+rs66EGttPTFn+9AafEdCOIx9FZTWEcKZk0sZCFIoNq5eQ==
Received: from BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:2::9) by
 PNZPR01MB8377.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:3b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.8; Sat, 11 Feb 2023 12:49:50 +0000
Received: from BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::9dc7:9298:c988:474d]) by BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::9dc7:9298:c988:474d%11]) with mapi id 15.20.6111.005; Sat, 11 Feb
 2023 12:49:50 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Hector Martin <marcan@marcan.st>
CC:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Arend van Spriel <aspriel@gmail.com>,
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
        Jonas Gorski <jonas.gorski@gmail.com>,
        "asahi@lists.linux.dev" <asahi@lists.linux.dev>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/4] wifi: brcmfmac: Rename Cypress 89459 to BCM4355
Thread-Topic: [PATCH v3 1/4] wifi: brcmfmac: Rename Cypress 89459 to BCM4355
Thread-Index: AQHZPPp8Rkxr3ZdfVkWP0oVivQ3Nb67HiYGAgAH+NgCAABTegIAAFxaAgAABCCg=
Date:   Sat, 11 Feb 2023 12:49:50 +0000
Message-ID: <BM1PR01MB0931D1A15E7945A0D48B828EB8DF9@BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM>
References: <20230210025009.21873-1-marcan@marcan.st>
 <20230210025009.21873-2-marcan@marcan.st>
 <0cd45af5812345878faf0dc8fa6b0963@realtek.com>
 <624c0a20-f4e6-14a5-02a2-eaf7b36e9331@marcan.st>
 <18640374b38.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
 <e9dbfa3d-6599-94b9-0176-e25bb074b2c7@marcan.st>
In-Reply-To: <e9dbfa3d-6599-94b9-0176-e25bb074b2c7@marcan.st>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [fJ+e+K4uKj/YFWElcKBJK+3S2EhQqAS8LeDEc2e0imLH5HxBZoXqm0K2VgGiR9rS]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BM1PR01MB0931:EE_|PNZPR01MB8377:EE_
x-ms-office365-filtering-correlation-id: 3b54f22f-19dc-4cc5-534a-08db0c2e76f0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E7P2R+AKwZ3eEyi2puWyBhBzLCeZVG6uDshJCpMakxTsN3fXWu5dJilICCuUsZzOd4cyesfY1jK+bdmm0km6lACfvCn+b2p7VD7xgzdBxh7X4qZwvt2lHnCDaOd3tlyOADGK052fy8lZFVCIrjXXGdR8PA7BSvNduWNoj9n7CBasnDC6w29tfA69Pn+SJ23ATZ5SGYaFsJeyf9jXvZ8CNnp9UbUXKYYb4ehBNGDNY5x52qxUEAwFHMNZlwizPig+ZGEXp+CwKJ1vHgWj1gn3Y0I7nOaXuSDr3vdVzYJ8MrtPTNhckz4Rrj0kgNIu7hU4rMh1KitxFyPK/tUxl//bH9OsyR3hqVvp2BDI0cdhYPKR9ESRHvCX4RHSNSGkd0G56tAqAk8QRoKvIe1dMjqd67xp9njVWZkSBkia2lj/PM0Cer5T4E06SxjDG1SdMvdHLPn/tarBV1UzHw6VSY/HoKu/W1kA9cldfNPpUEJUdyZjWswOe+O0xxh9Ppfjq/YmpMnuRO3KbQRU3pr4umeEO/llPiZjBmW1ZIS+UUhTPpV++4nK+lDWHZJ9wjA7oR+3lFpE9+9rWhdGy1eT0bFAXifZKp/cBPne6FTwdiJJfXppiC5mcGAqrPbaI/lK65ePcDMimREwYTJjfMCur4U4yA==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UmRnUitwTk9tb0dXUERRcGEyV1BnblowTFI4UUJrMCtOY1Q3Y0YyYkxsOUZl?=
 =?utf-8?B?TjdDUEluK1V4MGNYQUNXb2NlTk9UL2ZMdnFjZXNCUU12WUlGcmVVZ21hc0M3?=
 =?utf-8?B?YW5hVHBjYXR5c0JyTXNNQTdjOEVUR0JNMWVQRkJZdFUxUjRnOGp0RGRURkRZ?=
 =?utf-8?B?WjhXKzk3Ulk0MzNvMUlhZmdTY1FQekR0ZzlRKzdkdDBUMHl6Q3lQU0ZBdGU0?=
 =?utf-8?B?RU9wYWZzSGZLQWJzc2cvMS9YYnptTmRFSGwyby85d2RoYnRpOVZiNXJ3UTJa?=
 =?utf-8?B?dTBLM2c4QmhXNEEvS3NUb0dXN3J5V0ppME5JalBoUHFiVFJKU0RDdzRPVjBv?=
 =?utf-8?B?OHdqb1k4SkdpemFTdzdMWThIZlpkOFU2VmZDWGc1QUdtbHNzTG03SHh4K2tm?=
 =?utf-8?B?cVZ2YzdabzloMWpsVG5lNWNNdlczbjNKYkh1Nk8yYUpWeUxYOXc3Q0J2aTZ4?=
 =?utf-8?B?bjVab3pMUmpEUVhhRW0xeHNEOG9ISWpUbmxDWmE4MHAwaWViQnFqbE1zdWtK?=
 =?utf-8?B?MUVyaGZ0c2xYT1phblFvUmp2ZXRSa0Z4N1crZzB2clpnSHZXV0pQb1BCcXJT?=
 =?utf-8?B?U2U2M29sRmNFQnhSdXluSjM1di9MM2l6dmROVVc4a2lPblVCbTVsbnhRTTJm?=
 =?utf-8?B?ZllvWjJpTGNCdElnV3cxcmhNWU54UUo1RHo1ZkhqTkYvY09pL3hMVDU3U2FU?=
 =?utf-8?B?QWpVVmpNbnNIY3o2c0JVV2g5bVBVM3JKdjdOeFRaL2NwTUE5dFM3bjR5bCtN?=
 =?utf-8?B?VVBGWHFzanA0TWZ0dFJaeWJUZE9RQmlSN1R1TnRkc3JFM0svaUFhc1cxR2Z0?=
 =?utf-8?B?NHpzUVpSZXQ3c1BNSHNWbjJGaWp3OWVhZ3JrdkVZVjlkNHk3aEg4cTNMRUFW?=
 =?utf-8?B?LzdrL3E2VVFUYyt6b2NKSk9JTFBvY2JKRytMQjVRYTJFdytxQXJwdzk5U0NL?=
 =?utf-8?B?aFd4alZIdkxpSmFOSmVUWkZMek1wTVR3NHRwdDJSaEdvSkVEZnZ5YnpJZmlI?=
 =?utf-8?B?aW4wMmM2VTQ3d1BkSVhjMnI4VVNsekJiUW0zZ25NNnd0WWlINXVhalpudnlq?=
 =?utf-8?B?UmFNaDQ2RnU4Y2xjWHFZY1Bac3JtUStEU25tWitCNThiaFU5eFA2cmt5VUhO?=
 =?utf-8?B?dVc5R0puYWpuME4zb3B1bzcwZEhOWDBkQ2xiZDhVVzhSNW9wRVZPMkJySzl6?=
 =?utf-8?B?RkM0QWdKWWRyU3JHT2NZdS9FL2d5ZjJ4VHZFV29saTM1QW1tRDRPdnNmTytq?=
 =?utf-8?B?VThUZ0JDd2VENS82RFRhNDNIV0J0NDFFRi9TNG9KV05SM2p3NVlZQVBuWitH?=
 =?utf-8?B?UzE2Mk82WFJRTkJWYTFOZGpZSnY2UVJHTnhGUUpIQ1hiOE8rWUlqaWg3UzMr?=
 =?utf-8?B?TDdCWDdvQkZ3Tk5hL0FaTldXUWpoZmVYano3aytpeXEyS1dqVUxyWFUzM1dO?=
 =?utf-8?B?bi80S2RsOUl1NHVpUldTNlZvck1MakVXMHZ6RTNtYWJiZDBuL3pOZ0N2NXMy?=
 =?utf-8?B?bVVaL09oWGRiRFhFRHhtOTkrVkg0TUZQeXlMaGwwK0pQblNHV1ZaUndhVGR1?=
 =?utf-8?B?Ynd5RFBmYlZsVTVzSEE4bmNIZnY3bmNtSXl4YXB4V0Y1NlJUbmJXREJ1eWF3?=
 =?utf-8?B?dTlkaHNFYklCU2EwempVVFgxcFM1VDMyeGJhYm1TbnFlMHpiczMzWnpTQkVq?=
 =?utf-8?B?N3dJOUZWWHR5QnRaajVOTnI5VDNDTW4wSkdIcjdHNXhGTWExNHpDc1dXaUhC?=
 =?utf-8?B?N3lGTnd3d2g1blk3ak15Q0xaRTJIVy9hUEowUndabFNnNHozM3pYYldCb1hU?=
 =?utf-8?B?ZHg2NExhQVBUZCtYV1Fjdz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b54f22f-19dc-4cc5-534a-08db0c2e76f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2023 12:49:50.6235
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PNZPR01MB8377
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gMTEtRmViLTIwMjMsIGF0IDY6MTYgUE0sIEhlY3RvciBNYXJ0aW4gPG1hcmNhbkBt
YXJjYW4uc3Q+IHdyb3RlOg0KPiANCj4g77u/T24gMTEvMDIvMjAyMyAyMC4yMywgQXJlbmQgVmFu
IFNwcmllbCB3cm90ZToNCj4+PiBPbiBGZWJydWFyeSAxMSwgMjAyMyAxMTowOTowMiBBTSBIZWN0
b3IgTWFydGluIDxtYXJjYW5AbWFyY2FuLnN0PiB3cm90ZToNCj4+PiANCj4+PiBPbiAxMC8wMi8y
MDIzIDEyLjQyLCBQaW5nLUtlIFNoaWggd3JvdGU6DQo+Pj4+IA0KPj4+PiANCj4+Pj4+IC0tLS0t
T3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+Pj4+PiBGcm9tOiBIZWN0b3IgTWFydGluIDxtYXJjYW5A
bWFyY2FuLnN0Pg0KPj4+Pj4gU2VudDogRnJpZGF5LCBGZWJydWFyeSAxMCwgMjAyMyAxMDo1MCBB
TQ0KPj4+Pj4gVG86IEFyZW5kIHZhbiBTcHJpZWwgPGFzcHJpZWxAZ21haWwuY29tPjsgRnJhbmt5
IExpbiANCj4+Pj4+IDxmcmFua3kubGluQGJyb2FkY29tLmNvbT47IEhhbnRlIE1ldWxlbWFuDQo+
Pj4+PiA8aGFudGUubWV1bGVtYW5AYnJvYWRjb20uY29tPjsgS2FsbGUgVmFsbyA8a3ZhbG9Aa2Vy
bmVsLm9yZz47IERhdmlkIFMuIA0KPj4+Pj4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pjsg
RXJpYw0KPj4+Pj4gRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT47IEpha3ViIEtpY2luc2tp
IDxrdWJhQGtlcm5lbC5vcmc+OyBQYW9sbyANCj4+Pj4+IEFiZW5pIDxwYWJlbmlAcmVkaGF0LmNv
bT4NCj4+Pj4+IENjOiBBbGV4YW5kZXIgUHJ1dHNrb3YgPGFsZXBAY3lwcmVzcy5jb20+OyBDaGkt
SHNpZW4gTGluIA0KPj4+Pj4gPGNoaS1oc2llbi5saW5AY3lwcmVzcy5jb20+OyBXcmlnaHQgRmVu
Zw0KPj4+Pj4gPHdyaWdodC5mZW5nQGN5cHJlc3MuY29tPjsgSWFuIExpbiA8aWFuLmxpbkBpbmZp
bmVvbi5jb20+OyBTb29udGFrIExlZSANCj4+Pj4+IDxzb29udGFrLmxlZUBjeXByZXNzLmNvbT47
IEpvc2VwaA0KPj4+Pj4gY2h1YW5nIDxqaWFjQGN5cHJlc3MuY29tPjsgU3ZlbiBQZXRlciA8c3Zl
bkBzdmVucGV0ZXIuZGV2PjsgQWx5c3NhIA0KPj4+Pj4gUm9zZW56d2VpZyA8YWx5c3NhQHJvc2Vu
endlaWcuaW8+Ow0KPj4+Pj4gQWRpdHlhIEdhcmcgPGdhcmdhZGl0eWEwOEBsaXZlLmNvbT47IEpv
bmFzIEdvcnNraSA8am9uYXMuZ29yc2tpQGdtYWlsLmNvbT47IA0KPj4+Pj4gYXNhaGlAbGlzdHMu
bGludXguZGV2Ow0KPj4+Pj4gbGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnOyBicmNtODAy
MTEtZGV2LWxpc3QucGRsQGJyb2FkY29tLmNvbTsgDQo+Pj4+PiBTSEEtY3lmbWFjLWRldi1saXN0
QGluZmluZW9uLmNvbTsNCj4+Pj4+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5l
bEB2Z2VyLmtlcm5lbC5vcmc7IEhlY3RvciBNYXJ0aW4gDQo+Pj4+PiA8bWFyY2FuQG1hcmNhbi5z
dD47IEFyZW5kIHZhbiBTcHJpZWwNCj4+Pj4+IDxhcmVuZC52YW5zcHJpZWxAYnJvYWRjb20uY29t
Pg0KPj4+Pj4gU3ViamVjdDogW1BBVENIIHYzIDEvNF0gd2lmaTogYnJjbWZtYWM6IFJlbmFtZSBD
eXByZXNzIDg5NDU5IHRvIEJDTTQzNTUNCj4+Pj4+IA0KPj4+Pj4gVGhlIGNvbW1pdCB0aGF0IGlu
dHJvZHVjZWQgc3VwcG9ydCBmb3IgdGhpcyBjaGlwIGluY29ycmVjdGx5IGNsYWltZWQgaXQNCj4+
Pj4+IGlzIGEgQ3lwcmVzcy1zcGVjaWZpYyBwYXJ0LCB3aGlsZSBpbiBhY3R1YWxpdHkgaXQgaXMg
anVzdCBhIHZhcmlhbnQgb2YNCj4+Pj4+IEJDTTQzNTUgc2lsaWNvbiAoYXMgZXZpZGVuY2VkIGJ5
IHRoZSBjaGlwIElEKS4NCj4+Pj4+IA0KPj4+Pj4gVGhlIHJlbGF0aW9uc2hpcCBiZXR3ZWVuIEN5
cHJlc3MgcHJvZHVjdHMgYW5kIEJyb2FkY29tIHByb2R1Y3RzIGlzbid0DQo+Pj4+PiBlbnRpcmVs
eSBjbGVhciBidXQgZ2l2ZW4gd2hhdCBsaXR0bGUgaW5mb3JtYXRpb24gaXMgYXZhaWxhYmxlIGFu
ZCBwcmlvcg0KPj4+Pj4gYXJ0IGluIHRoZSBkcml2ZXIsIGl0IHNlZW1zIHRoZSBjb252ZW50aW9u
IHNob3VsZCBiZSB0aGF0IG9yaWdpbmFsbHkNCj4+Pj4+IEJyb2FkY29tIHBhcnRzIHNob3VsZCBy
ZXRhaW4gdGhlIEJyb2FkY29tIG5hbWUuDQo+Pj4+PiANCj4+Pj4+IFRodXMsIHJlbmFtZSB0aGUg
cmVsZXZhbnQgY29uc3RhbnRzIGFuZCBmaXJtd2FyZSBmaWxlLiBBbHNvIHJlbmFtZSB0aGUNCj4+
Pj4+IHNwZWNpZmljIDg5NDU5IFBDSWUgSUQgdG8gQkNNNDM1OTYsIHdoaWNoIHNlZW1zIHRvIGJl
IHRoZSBvcmlnaW5hbA0KPj4+Pj4gc3VidmFyaWFudCBuYW1lIGZvciB0aGlzIFBDSSBJRCAoYXMg
ZGVmaW5lZCBpbiB0aGUgb3V0LW9mLXRyZWUgYmNtZGhkDQo+Pj4+PiBkcml2ZXIpLg0KPj4+Pj4g
DQo+Pj4+PiB2MjogU2luY2UgQ3lwcmVzcyBhZGRlZCB0aGlzIHBhcnQgYW5kIHdpbGwgcHJlc3Vt
YWJseSBiZSBwcm92aWRpbmcNCj4+Pj4+IGl0cyBzdXBwb3J0ZWQgZmlybXdhcmUsIHdlIGtlZXAg
dGhlIENZVyBkZXNpZ25hdGlvbiBmb3IgdGhpcyBkZXZpY2UuDQo+Pj4+PiANCj4+Pj4+IHYzOiBE
cm9wIHRoZSBSQVcgZGV2aWNlIElEIGluIHRoaXMgY29tbWl0LiBXZSBkb24ndCBkbyB0aGlzIGZv
ciB0aGUNCj4+Pj4+IG90aGVyIGNoaXBzIHNpbmNlIGFwcGFyZW50bHkgc29tZSBkZXZpY2VzIHdp
dGggdGhlbSBleGlzdCBpbiB0aGUgd2lsZCwNCj4+Pj4+IGJ1dCB0aGVyZSBpcyBhbHJlYWR5IGEg
NDM1NSBlbnRyeSB3aXRoIHRoZSBCcm9hZGNvbSBzdWJ2ZW5kb3IgYW5kIFdDQw0KPj4+Pj4gZmly
bXdhcmUgdmVuZG9yLCBzbyBhZGRpbmcgYSBnZW5lcmljIGZhbGxiYWNrIHRvIEN5cHJlc3Mgc2Vl
bXMNCj4+Pj4+IHJlZHVuZGFudCAobm8gcmVhc29uIHdoeSBhIGRldmljZSB3b3VsZCBoYXZlIHRo
ZSByYXcgZGV2aWNlIElEICphbmQqIGFuDQo+Pj4+PiBleHBsaWNpdGx5IHByb2dyYW1tZWQgc3Vi
dmVuZG9yKS4NCj4+Pj4gDQo+Pj4+IERvIHlvdSByZWFsbHkgd2FudCB0byBhZGQgY2hhbmdlcyBv
ZiB2MiBhbmQgdjMgdG8gY29tbWl0IG1lc3NhZ2U/IE9yLA0KPj4+PiBqdXN0IHdhbnQgdG8gbGV0
IHJldmlld2VycyBrbm93IHRoYXQ/IElmIGxhdHRlciBvbmUgaXMgd2hhdCB5b3Ugd2FudCwNCj4+
Pj4gbW92ZSB0aGVtIGFmdGVyIHMtby1iIHdpdGggZGVsaW1pdGVyIC0tLQ0KPj4+IA0KPj4+IEJv
dGg7IEkgdGhvdWdodCB0aG9zZSB0aGluZ3Mgd2VyZSB3b3J0aCBtZW50aW9uaW5nIGluIHRoZSBj
b21taXQgbWVzc2FnZQ0KPj4+IGFzIGl0IHN0YW5kcyBvbiBpdHMgb3duLCBhbmQgbGVmdCB0aGUg
dmVyc2lvbiB0YWdzIGluIHNvIHJldmlld2VycyBrbm93DQo+Pj4gd2hlbiB0aGV5IHdlcmUgaW50
cm9kdWNlZC4NCj4+IA0KPj4gVGhlIGNvbW1pdCBtZXNzYWdlIGlzIGRvY3VtZW50aW5nIHdoYXQg
d2UgZW5kIHVwIHdpdGggcG9zdCByZXZpZXdpbmcgc28gDQo+PiBwYXRjaCB2ZXJzaW9ucyBhcmUg
bWVhbmluZ2xlc3MgdGhlcmUuIE9mIGNvdXJzZSB1c2VmdWwgaW5mb3JtYXRpb24gdGhhdCANCj4+
IGNhbWUgdXAgaW4gcmV2aWV3IGN5Y2xlcyBzaG91bGQgZW5kIHVwIGluIHRoZSBjb21taXQgbWVz
c2FnZS4NCj4+IA0KPiANCj4gRG8geW91IHJlYWxseSB3YW50IG1lIHRvIHJlc3BpbiB0aGlzIGFn
YWluIGp1c3QgdG8gcmVtb3ZlIDggY2hhcmFjdGVycw0KPiBmcm9tIHRoZSBjb21taXQgbWVzc2Fn
ZT8gSSBrbm93IGl0IGRvZXNuJ3QgaGF2ZSBtdWNoIG1lYW5pbmcgcG9zdCByZXZpZXcNCj4gYnV0
IGl0J3Mgbm90IHVuaGVhcmQgb2YgZWl0aGVyLCBncmVwIGdpdCBsb2dzIGFuZCB5b3UnbGwgZmlu
ZCBwbGVudHkgb2YNCj4gZXhhbXBsZXMuDQo+IA0KPiAtIEhlY3Rvcg0KDQpBZGRpbmcgdG8gdGhh
dCwgSSBndWVzcyB0aGUgbWFpbnRhaW5lcnMgY2FuIGRvIGEgYml0IG9uIHRoZWlyIHBhcnQuIElt
YW8gaXTigJlzDQpyZWFsbHkgZnJ1c3RyYXRpbmcgcHJlcGFyaW5nIHRoZSBzYW1lIHBhdGNoIGFn
YWluIGFuZCBhZ2FpbiwgZXNwZWNpYWxseSBmb3INCmJpdHMgbGlrZSB0aGVzZS4=
