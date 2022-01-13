Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1432548D480
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 10:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233156AbiAMI6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 03:58:14 -0500
Received: from mail-dm6nam11on2067.outbound.protection.outlook.com ([40.107.223.67]:58624
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233422AbiAMI5a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 03:57:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OOpxyhhfsHfF8iV+FF5mgYaTOiJqdJnicOX9JSiPUMKx7WNtc8J8Gs4pb2ivgEhTwknKtWoefh09M/xeGE3aAxnD3Ds62G/t6cs+MtveFgWEFRC8Wa41ZDSmNPE7JauNpw4UG10+SB+oA/pATpBHBTzgLe7VwSF0lUbz+1V/Zh/TT0cw1UAKYqKS+ulPNqWtLG4t+ihM88geovCT2lQCkDrM/4CeK3uA/vYrO2VZbr8hcmIMSoi7PXFFzNx4CN3/Pjt6MmkZ28GaXYm8X4MiPd6pp8CLgZ9MEeB1CScayqsQ7IS1gsZLDuesAViyJMzcx9TVOBISMGFTMxPx/SGFyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pG21vyC3xFQoCuo6lUwFIbPoAQR3xI8/mNdq+O8nT/c=;
 b=MPLfVhhO7FECaLzWTWKqqBD+mU6UKDjAUClofWqDxx/ATXU7BNVSuKSR9cR5uNmoPHbu0aHnQkFxV8lLg6OTPS6dle9yS12sG5px9L3ad+D3RK6QDjoFGIA50m1OuqPG0Pwfj7wmge3IW/hNc9OLxscPUS1w2TUfbpHAfLe5pa9nqXdp8sskIVXmcfsbh4HFCkVk4ziLk/cP5kHq1hOuY0q1Lp25KN4D5/gO1aTJlGhdnfcPDqjEqNlx1KoWpmAkawfrEhBuwNxGVPuEWomiFn6bl7Aa3VdDMDIqVk/hMEj0EL0fFtxIXjd6pfCtkRXCatRYdF1dIv4tMZ1R7jJiDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pG21vyC3xFQoCuo6lUwFIbPoAQR3xI8/mNdq+O8nT/c=;
 b=LVM1o/0nq7TVnVbfMAtWxC/1Lwgo9ka3KnEFCYMyhwqaAvtcXD38PZQD1nHxtm6PnV5lCacw0njRdrqJil73RDnp8OBtjXiGb5dGqgfDV8pP14UoY71gC8AhTuJfxm8JI1Qr8FP1ks84QQnPR7q225lLMQWtg0wzD4iPt2RwDas=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by CY4PR1101MB2071.namprd11.prod.outlook.com (2603:10b6:910:1a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 13 Jan
 2022 08:56:26 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%5]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 08:56:26 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 24/31] staging: wfx: replace compiletime_assert() by BUILD_BUG_ON_MSG()
Date:   Thu, 13 Jan 2022 09:55:17 +0100
Message-Id: <20220113085524.1110708-25-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220113085524.1110708-1-Jerome.Pouiller@silabs.com>
References: <20220113085524.1110708-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SA0PR11CA0117.namprd11.prod.outlook.com
 (2603:10b6:806:d1::32) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe5f0037-45f6-4e9e-e0f7-08d9d67294d0
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2071:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1101MB20716E07E76DD23B4A27C68193539@CY4PR1101MB2071.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XXQNQm7RvCQmVuFZynaP+dfeRtc0NudZVkT0DWuYoIwYKc9tY9aZ8eRWkWsvbDbzJtJXXO72iVyySqZoPAavNnXbg1+py4RNiNuc8O9hjTqYIh4SJ82uQbrUGVpzV39HccpAr1Aua2hW3So5sc2KodhFofe3FGjV+XmM8ONzSP8qZi/J1wDctIAw2SNsrQyN9coAA9cTxgiwreNpCd+AydLwdAotSHIWz/SeglTmxx4sQ5PzvxHT+VGx4TsU0t1HMWhyK3arzv9LkK1aqV2oXF5J12gxepqVM9TakSS2WFo2rizKQ/URTc/Q5+i0l9t8rXHUHyK0x93P2cNEKngnyXGvO+LusvkLJpbchDQda4MBaPyTXVci0dF7CJXFgNYtpHLq6dIhZprb2uHB30d2b5ZDq4xJQeMoPi0ZcUPkvR9w7efS6+rDALrOWSKkSPzNAYEXX9H66HtK3PtwSsEN16VI0YYUcN1ZmfCi6b0vxclvTVrGb/T7HVCNQFQR2LMqtqwVfK50VZpm7ipqKtcSFeGJgdOUp9VCMxfqc/I2ECKXp9aWC3xq68FnRua/N9dGiVm20lrALkyU5QzNE/p7hlyMBLIUbiDZhoaZZ4Hc6Oi/Z65pi9T2lXvPCxi4e5xyugnQHPux4zIaHitYOAXMxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(66476007)(52116002)(8676002)(6486002)(4326008)(38100700002)(8936002)(83380400001)(6506007)(107886003)(66556008)(6666004)(36756003)(508600001)(2906002)(5660300002)(6512007)(1076003)(86362001)(186003)(316002)(66946007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QUtjQUxkTGFJaldra0tSQVZ5L042NnFmMzlwaEZ1L2g2cTJtMkNLRGdTQ3pD?=
 =?utf-8?B?T3Q4c29Qb0laVlJJQlIyRGxhZUcwWE44Z3NtcUU2WlFqdEZCZkpZN2RqWjFB?=
 =?utf-8?B?MlltVjZTUHlEZDA3dDdrYTJXbkN2OTFtUFpOZW51a01DRDFYakpseDdJNW1S?=
 =?utf-8?B?TWtXWU5rTi9UMzdFWi9sQWQrV0dtT1JWV1lGSHBDcFdPbkc5UXNrUGdtQUVZ?=
 =?utf-8?B?bEhzc3JRYmlPaFNyUWZYTVN2NTNhK0wyWlVnVVBMSnVqTFUzQVlwSVE5a3h6?=
 =?utf-8?B?Zkd2MGMwLzBYZUdFbGpPakZCYWwydlo5QTZIZ1FaSW1wK2ZmK2hocFpLdjNN?=
 =?utf-8?B?SlZaVHFXRVhaVXpXb1FrSzlXSGtqamx3aFg1RkcrbEtYOVU2NlVWUzU5YXUx?=
 =?utf-8?B?aTFtcW93U3J3bG9FRzZlUkNvSXlUSVZmLy9ZeE5iOHdEc1RjdHU5b2NpRE1Q?=
 =?utf-8?B?RHJUV2hya3VXTVdEQWNBV1BrV1c4M1U0azl6ak9tdkhDZHJzcjQreUN5VFN1?=
 =?utf-8?B?VjlDZEQ5a0lFeWtLcUhsNnJGK2JYcVVGUjI2U2VRaUFGcXZ2K216Z1FrUXg4?=
 =?utf-8?B?bXBDSnp3ZUdnODQ4UTFsN1dVOVYza2pKamdRVlQ5SXpWL2NkNmFWYWo5ZC9L?=
 =?utf-8?B?NzNWWlB2Q3N6Z1lySWZTMUN6SHMweVJ5OG52Uk5aVFlLb1gyRVpLTnFPbjV4?=
 =?utf-8?B?OTJjR0NQTlRWNERTZkpFY0FuZmRaQnBjWkRaZzQ5OUxrNWNUVmowc0ovNXdZ?=
 =?utf-8?B?aSt5dGN6dDVmZ096ZFJid0pQWkZnUnYzNHl3RGpudzFHeEhMWWdMc3ZqM0h3?=
 =?utf-8?B?enVHNENaWWMyYjkvNTVOSllaZklXVGJ5QzIvdVlFZUhFNUdkaXUrZzREQjFB?=
 =?utf-8?B?L0hYWGYveWFobDJrUzE2cXdEL0FrbDl5Wi92TC9BWVpIOUtPMExjV0hhMThj?=
 =?utf-8?B?UVpOSldTRmtiN0pFcXhteU5Wc2hIVm9rRjR4U0srcU9pM1V1cDZQNzVlK2dJ?=
 =?utf-8?B?ZXl5UlJpZjF2SzZZa3hXNzIzY2xkelQvQWE1UHBFRytXNTY0MzFYM0NsWVBh?=
 =?utf-8?B?bStxRmowWXVaeEpuYXpublkzRlZoN3dTWUFKZHVjSjcrSUROeW1XQm9KdUlk?=
 =?utf-8?B?aEZzUjNtL3l3azV3YnRvQ3ZMQmFldHZmc3Jwd1ZMOVdsSWl4TjFFRnNBZ0Vw?=
 =?utf-8?B?VjhHcldwYUczQjZ4Uk4rQm5BTHdIdk5mTUhXVGI1L3JKRStIYXhBaW82RGxE?=
 =?utf-8?B?OFRncG5ZVUdZaEFTcDY1SURSYzBxeXBTam9HdnRGV0xkaFdOK3pPZHpkVVgv?=
 =?utf-8?B?amVpT2l2aVdYdWJLdk1IeUhyT0lpNS82R2hzUVEvSFViVzN2a0R6a00wSjdI?=
 =?utf-8?B?cnVXUXRHdHVEa1poOEhlRkZjLzgySStlNW5UZlJpTlJwV3N4ZS9PZS9tTFgw?=
 =?utf-8?B?TXUrM2xXMngycWNULytaNXNFUnpiNTVVS3Z1RVREZlBlY3JsbHVoSUwxN2VL?=
 =?utf-8?B?K2lieDRQUnVXbXpMTW5EWEQxcXpabDZuSGFUVC9hbUZUOEtOWlRvZC8rNDVt?=
 =?utf-8?B?OFozODRta1FxOEt6SGxsRlIyWm1CZWd4SGZoMmFqaXk0NG83cDlZdzQxMXlp?=
 =?utf-8?B?QWdiNXlaNkI3VmdhSmVxQUN6ZEQ2YTg1eVgxSVkzK3FuQXRwL0MrbGtsRStK?=
 =?utf-8?B?S3JhVUFDVDRjeEFXcEhWZEd4SkVmalNkZFF3L1VzSTZvT3F6K2pvVVdWSU5t?=
 =?utf-8?B?UnAweGtIOXUzSVZ0TEZ3b3BpazU1Tm1LZW5PQUhZbGc5blNEc0p0YjRtVHBw?=
 =?utf-8?B?dCtNQ2F3R2xaVGZueGJPRTI0WSs0MlhYNDltbEIzMVB6VWVBVXVEaHRIK2hr?=
 =?utf-8?B?cURaZWtJUDZTQ1ZKQ3JQem5WbXpLM1QvVEJmbDAybytRaERoeWJFUU13eGtx?=
 =?utf-8?B?ajBoRXE3OEhYTGdLbmRCNzd2UTdiemF0SnFFV1EwU0JhS2pPZlYvUy83bFVp?=
 =?utf-8?B?Q2FnUEpteWVxNko2bTUya3RKY2NmR05nV2x6eE9sSmhEdzR1cTZYM3ZSZFk4?=
 =?utf-8?B?RlBGaG1ObzJtS3VQeGI5OEVaZWNRNU5yMVhrQ0xHRUpqdjJLUGh2cUFoamgr?=
 =?utf-8?B?T0lMMDIyY0psVjFRSGV6VzNKV1JxdEZtbFRKa3BVcHltejc4N005Sld5RFFk?=
 =?utf-8?B?WW5iREFLVWU0UVNZdG13bitFNW43SmllNEZ1Ym9KS3FyUW1qYThOY3hYR04v?=
 =?utf-8?Q?XX6YKXMTLaDtjtAuQKdXrSoU0Y/+6eeDcn3+Pbp6g0=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe5f0037-45f6-4e9e-e0f7-08d9d67294d0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 08:56:26.3156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N1DAGF4U2NOiFKHoEGJ9IEk0HFtPmmhwP10rd86i/I4bW0JptZIYjlt/ennYef4cl90GIfeZa4ka64iVbJP/Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2071
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSXQg
c2VlbXMgdGhhdCBCVUlMRF9CVUdfT05fTVNHKCkgaXMgYSBiaXQgbW9yZSBwb3B1bGFyLgoKU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
PgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIHwgNCArKy0tCiAxIGZpbGUgY2hh
bmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMK
aW5kZXggY2EyZjI0YjkyZDI0Li5iZmMzZDQ0MTJhYzYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3Rh
Z2luZy93ZngvZGF0YV90eC5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCkBA
IC0zOTEsOCArMzkxLDggQEAgdm9pZCB3ZnhfdHgoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHN0
cnVjdCBpZWVlODAyMTFfdHhfY29udHJvbCAqY29udHJvbCwgc3RydWMKIAlzdHJ1Y3QgaWVlZTgw
MjExX2hkciAqaGRyID0gKHN0cnVjdCBpZWVlODAyMTFfaGRyICopc2tiLT5kYXRhOwogCXNpemVf
dCBkcml2ZXJfZGF0YV9yb29tID0gc2l6ZW9mX2ZpZWxkKHN0cnVjdCBpZWVlODAyMTFfdHhfaW5m
bywgcmF0ZV9kcml2ZXJfZGF0YSk7CiAKLQljb21waWxldGltZV9hc3NlcnQoc2l6ZW9mKHN0cnVj
dCB3ZnhfdHhfcHJpdikgPD0gZHJpdmVyX2RhdGFfcm9vbSwKLQkJCSAgICJzdHJ1Y3QgdHhfcHJp
diBpcyB0b28gbGFyZ2UiKTsKKwlCVUlMRF9CVUdfT05fTVNHKHNpemVvZihzdHJ1Y3Qgd2Z4X3R4
X3ByaXYpID4gZHJpdmVyX2RhdGFfcm9vbSwKKwkJCSAic3RydWN0IHR4X3ByaXYgaXMgdG9vIGxh
cmdlIik7CiAJV0FSTihza2ItPm5leHQgfHwgc2tiLT5wcmV2LCAic2tiIGlzIGFscmVhZHkgbWVt
YmVyIG9mIGEgbGlzdCIpOwogCS8qIGNvbnRyb2wudmlmIGNhbiBiZSBOVUxMIGZvciBpbmplY3Rl
ZCBmcmFtZXMgKi8KIAlpZiAodHhfaW5mby0+Y29udHJvbC52aWYpCi0tIAoyLjM0LjEKCg==
