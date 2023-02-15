Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5946C69852D
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 21:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjBOUGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 15:06:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjBOUGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 15:06:07 -0500
Received: from IND01-MAX-obe.outbound.protection.outlook.com (mail-maxind01olkn2073.outbound.protection.outlook.com [40.92.102.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D7E43A84F;
        Wed, 15 Feb 2023 12:06:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ciOPc4pJUWSKdDcAF8ShrXTtsMyzYJozTXRRo0l+jPf/ud9DUKu9XaeV2UXiIu2ows+tKdauggzEIkLvtPIwlLsYRl1oXQ/J/du+SuA5Cpr9RCJGe79VNLtVU9cZQPG71djAjWJcNN+EGkx9nXVPTYUOC6FtnZXf9As1PmNurgMG0lcjkWtNcHliu/dvzxZ+azheRFoO2ERmFUR5N0QNw9M3IDOqBsQtie4/sUJAhET2nepBF9ljnV5Q8rVOvjIrCX5dHCPT8fKYHSs7uTRKw058z2UgcGbVgtljgFackmv4Yp8I1lBHmogiuH5L953a8TmTHKgo4wnVqbrtFFddVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rPUTIlAUwbjF92IOtkagBNuMhAmlSfKczBIjRMagmCQ=;
 b=Oj0iAGkwP1rXDP/NOL4V/OB88jlIkPDtJUKVk3JpXHG9i+B3fPo25Uo0QEWyklnvJPVpqSEh5vAfrnNrh/y+p84gKHzJ7XCI+ajo3ddEPZ66ukDVnDj2JLMK9ZngRd+FSOjq4TN5wWOgjzCwTytCGecfP9W6bzWoeq6T7rj9wXStVjqA2s4ZeX7qu7/hJirUlDmDd5puz127Fjgf5P1wT8COJznyRdWeAe0h/BPjbYbffZkPLtn6CDIB66pjVium4AL/Xreu3805Gs2eYKl+DutzJ6CtlK/HjGCY+WLYYW30OOhwLjLfsFHoJf21hBIT52cAF+dJu0vYC+DaZB2r4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rPUTIlAUwbjF92IOtkagBNuMhAmlSfKczBIjRMagmCQ=;
 b=gjNYiYqOj0QzARhTqHUbc6OMxdmUkWk+u3MPizZ+VxFNf6WUlEX7ns7jJPnk/A3cHk7YR903wBOmRAUFhTqX9RlrVHXo61IzlYVwdq0QgTlEMx2mZHinJ4xt9yYDgiJUGPUJbLl8BQN2trK7G0E5+7u6LETHZNTqLJTYQiTKsDtQxnmyRbo/KvER6eIfUcRj+g4Im1yAWpbLoEpjXzTPXQl2bQToj9lswyDCEvtQXsx+UVXHNDbXlsuOysjU7IkFf+enPODY8yLn3HgSPbpFQnt6gmLymTcA0d1V/XDEm0F+4Lf1DmNMbz1igBeoZXgADNxNBC9zG1VUpB0+htUIpw==
Received: from BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:2::9) by
 PNXPR01MB7292.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:a3::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.12; Wed, 15 Feb 2023 20:05:57 +0000
Received: from BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::f156:868f:a45b:aeee]) by BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::f156:868f:a45b:aeee%11]) with mapi id 15.20.6111.012; Wed, 15 Feb
 2023 20:05:57 +0000
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
        Alexander Prutskov <alep@cypress.com>,
        Ian Lin <ian.lin@infineon.com>,
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH v4 1/4] wifi: brcmfmac: Rename Cypress 89459 to BCM4355
Thread-Topic: [PATCH v4 1/4] wifi: brcmfmac: Rename Cypress 89459 to BCM4355
Thread-Index: AQHZPqywRfbBFz/y5ke3vwPVMwb+rK7NGWeAgANbEis=
Date:   Wed, 15 Feb 2023 20:05:56 +0000
Message-ID: <BM1PR01MB09318B4189950B6B549C93E6B8A39@BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM>
References: <20230212063813.27622-2-marcan@marcan.st>
 <167630706967.12830.157103392387761972.kvalo@kernel.org>
In-Reply-To: <167630706967.12830.157103392387761972.kvalo@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [bcTFr7cLEMh9TB+50phF9k0HQQo2ch82DIEswnZa0wGKK8niS/BBERjVGfVX0cwr]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BM1PR01MB0931:EE_|PNXPR01MB7292:EE_
x-ms-office365-filtering-correlation-id: a4e0ba56-db06-4356-f734-08db0f900cf1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D8p+2rHcSV+2+tVWkLVA/d2/0XtPlQ1UqO2zZBrdYNkhGuon6yLlf+sGPfBwD6Wvi4qd2718dOOwfZwOgSVWSPdM3n4EbXoL0sHKEAlMg0hT8YRonaj2Mn2quVEDsMv+L1nDFpPpe2ixnWFqTz7zTKQKc3MY6UQX1XcOyXDQMuJ+4NJemmPG/QdlYb/GgrUQEUEqG4qVAVu5x/dDzpW2T0s1hnYjuZgotvi5dcNH9k6vTpvQL4BVpyQsSU7ALcgwENrfCs1RsR7v2mW7wCKfebLju/vFzEiUWYrSJiP1f06HbG7LL98pmhQcO0okODKEZP6Q7Iqpva5bMUzi3Y6vIasnTYPn7YnlaABK7z+Z+Dy0B30Rmn0kpOyQHx7PPGwhTbzqD9170QzbU1Phfr+MUL3GUt/rxtqIgV14x5s8PbmBV2UhRe7MCiZqS4dL+tZ1TbA3rZXB3GNXKud5YfCTVIG5SpqZwIPPmEhznZm2Zp28V8zmNt75SmqLBQvzNtafLvB5p9iP7PK8RiMxj4gZVLikH2gEwDsxcQlXQOtIN2idZduK/qaIiV+6ZKZD1cmwigc/nFxbOVj3WymCwdl/nLR5yCoTP852k5+Lx7cnK5/w6HVko8UeXlAEXmghM0VdJstFFfXe3M6SScqSCpoDvA==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MzFxRTBHNVpVbkNrWE02MGF1MzJjVWVYK0FVSDM3WFRmci9NVUZYVlBuZUcy?=
 =?utf-8?B?NVQwN1NaWDkzdXAwZmlxSWhTMjZ2U0tuSm1jOHNDdzhaUFhmaHVhbkExSFhR?=
 =?utf-8?B?ODhLWjMrNjFwMFFEUGV2a1htakc5SkI4Snhzc1g2MFhyTVB3TVlUOTYyM3VB?=
 =?utf-8?B?OG5MUkI4WFMxWXRVa2JSVG55WlpLdzV5YnB2dzVMRnRRY0REM1IzMERrbW5P?=
 =?utf-8?B?TmMwOFJrMUxUVmIzaHh0UWxGSEVXYThFWVdVM2wzcnVpVGFBQzFRKys3UWll?=
 =?utf-8?B?YWJEMkZzVWtvWmV0M3VXR1RKVEdEc091eStoMzMwdjFqMVhpeEhsRWFxTHJ6?=
 =?utf-8?B?UlZsemNES2lUY2pzSSt2OXNpOXVPanVrSm9nTlAzNnVQaVh1S3J1VTJRSlNQ?=
 =?utf-8?B?dG1PMllNZXZpdFlIZThUcEtDako0L3Q3UVU2QVRXUkcwTWpRdlVMYy8wN0FQ?=
 =?utf-8?B?TUVBTEJvMmJkK1lBRWpnT3ljdi9QcHIzTzMxd1A2dDJpVmRvMVdkbjlzcENs?=
 =?utf-8?B?SWxuaXF6dTlaRFRyTjE2cjk1NU03OXdKZVMzaHNPemhjaHlQaUtYUy9kWWMz?=
 =?utf-8?B?azNZNzdrMmF6YXRWTDRSVDdYVUJkQzdTdVRqTTdCWnhLZXgvZmtGcC9uc3I5?=
 =?utf-8?B?cXZlcTI1am9Jd2U0SzJ3amtZUzBmKzFhMXlsV1BWd3FBM2t0UTRMM3FvOHAz?=
 =?utf-8?B?MmVYK0ZZckpNakNBVGN1Vmg1eTlzdUdkS3VMN290cWtEUlV1NTFBSXBOUGJO?=
 =?utf-8?B?eFFhY2FOQ1l4aXF4QlhJcjFlUHlKRHl0bCtuY2tqeTZLSm9BNjVtU1RSbytJ?=
 =?utf-8?B?b0R5MG12NFJQNUxtUHhEenNsVmp0MUlDdHJ4akxITXR1Q2N5T0RJUmE4Nkgy?=
 =?utf-8?B?eUdtWGc3OERVL29JeEpCWWlRVGM2VGFqVnhMbjBHVHRmcU4xTHdUL3Y2bHMx?=
 =?utf-8?B?WHdiczkySlNVYzVTejcwNWxqY29iNzJCY243WjZJRGR6b2djVFNubGt1NHVW?=
 =?utf-8?B?OGFjVEVSMk1QM0p2NmU1MGtxOExDMXdyOGF4OWZqOVdkS1YyTU52cnBlaC91?=
 =?utf-8?B?NWhjT0VXeWk5dDh3ZExWR3FtRHFBUVFZa0Z4amx1U1E4bFdPVndUL1B2Umg0?=
 =?utf-8?B?eEtXYzFXQ1hWVFZWZlVLb25MdCt3c29vVnUzenh6MEJ2SUZCYnlDRHpMKysy?=
 =?utf-8?B?U1pKS2QyT3lJS2QzZUJVbTBLd2ErYW9oU3pobUVnYzIzcjB5ejRDVVBWSVBo?=
 =?utf-8?B?Yk5jeWhEODZ5NVF3S2dqMkEwdlhHK2ZUUzJTV0h3RlFNWW5pU3ZhaU5heXhZ?=
 =?utf-8?B?UkEyWjVSdWE1ZGVxaUhTTVF4Y3dvaEo5bm9PMFRHRmVTQm1QcSs3RTk3U3lW?=
 =?utf-8?B?ZkxoTytaM2RYcm1pYWE1UCtzRzN1amV5dDI0WDFyNzhuNk5LWC9zUXJHRWk0?=
 =?utf-8?B?bVhQMk53dWdyeGl2U1J6REprN3A0YkxhcGZGY00rZnFpVVNETnlNcy8zb0s4?=
 =?utf-8?B?TGFyTXpLMG1kTUZQa1hidTJuL20vQ2JWOHVFZmlVaUZZWVVNV2RuZ3hWd25Z?=
 =?utf-8?B?TUZNOUVpV05pdytIZFdXeWZWaW1RN2VjdGpmM1dMdHpHNGU2QXBNSWxYNUQ1?=
 =?utf-8?B?eGdGQXd4RmJRaHAxak01NWNJRzU4dHlKdzRtV0VOWnJuVmQxaXhsckJJSUhS?=
 =?utf-8?B?dWI2R05YT1dHdG5Gd1ZEQmNsN01pNUlONzBLNS9CaUZIYjl6Z0wrOTZjRlJF?=
 =?utf-8?B?Y3NrS1hRS1JzWmgyZ3dqK3plYTIwVDgrMnVRR0hEMjZaTG1EVG4vUlZlUVFq?=
 =?utf-8?B?K0NHcGpUQ3FsNEU1Q20zUT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: a4e0ba56-db06-4356-f734-08db0f900cf1
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2023 20:05:56.9635
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PNXPR01MB7292
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgYWxsDQo+IA0KPiA0IHBhdGNoZXMgYXBwbGllZCB0byB3aXJlbGVzcy1uZXh0LmdpdCwgdGhh
bmtzLg0KPiANCj4gNTRmMDFmNTZjZjYzIHdpZmk6IGJyY21mbWFjOiBSZW5hbWUgQ3lwcmVzcyA4
OTQ1OSB0byBCQ000MzU1DQoNClNob3VsZG7igJl0IHRoaXMgcGF0aCBiZSBiYWNrcG9ydGVkIHRv
IHN0YWJsZSBzbyBhcyB0byBwcmV2ZW50IGRpZmZlcmVudCBmaXJtd2FyZSBuYW1lcyBpbiBkaWZm
ZXJlbnQga2VybmVscz8=
