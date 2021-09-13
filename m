Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E308408BA3
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240090AbhIMNEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:04:48 -0400
Received: from mail-mw2nam12on2088.outbound.protection.outlook.com ([40.107.244.88]:10209
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240063AbhIMNEU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 09:04:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WKoPPU2D7lNsKjZ6sFcDqZ2ljt6n3wkz7ka0t78zFEA78d8TQMothGUnIES2ePNuvFvHsvskCf2L3e0hFNu+skLF9VjpAz0NxEJHRiucl7jI0M87xjAborsmJ3KxdeyZYDxCHzK1TXThdoV5SvjCX6AVUOyzNDi/wu3TqvudQgNfDYhhxhKGVgdYiYUzCv9IVU21V/F/m/6HeMU+gFgzw6ss4a8IHf8eC4axoEtItT4DlQn5DXi9Q/zAVi44FjRcSY+hRUh24R/NqeYvHZgIPoWkzthjz0+qCFyfUd/BlHoWqmZR1Qq1Bq5p0f9JjUvgMtBpqNP3tS0bj7d4/3wHPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=sKQTsgOm6zR+8zh/irGIoz0XeG7P1LWn4tiUm/Vkbw4=;
 b=OEMGBSMeuKh2CTGBqat30mOy28NVzLkPlkMPu0Z2z5RBkmApD3d6SJLXuuaYk7vZn1JU+tQGMZ0Ql4KETmN2LclV9SfRcHfdeHff5kEoh2klX8QSP+TzgYDnngu9lIgS1ZL/NLI/zYUtq0Jzppixta53fxrb4JjbBaH9m8I7fz2/GoiD/izyHhpzaId1oZ4vjXdbJNGZp1blQRi6jmgWTP+7q4lPSEUOtp1el+gDaRV+wyVLsGRLqPcd1Fln8jJSL97rI6OJG/uAYtErGLPvBlpRsjPrd/bXLnGCMKeWuoHObDDlwQeLQWmGpe4GGXTjYw5wn7qH9n6Kt5mgNial1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sKQTsgOm6zR+8zh/irGIoz0XeG7P1LWn4tiUm/Vkbw4=;
 b=EByOyinXQ2HDhjA2dsEOWNo2toKFl0oLWNp7qNw9FlPmwN37RfZhIsxqF0rTn8EkiwRKSZykizlnCoIYT3TWUVaCJqAXD60eEzVcGnhKR2fZqz0W9z+6BaXugxQNZFZbRjt2Mhlh8/8W3mzHjKiRArac42xoi68XSoCIQaHdG3Y=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB4860.namprd11.prod.outlook.com (2603:10b6:806:11b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 13:02:38 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 13:02:38 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v3 11/32] staging: wfx: relax the PDS existence constraint
Date:   Mon, 13 Sep 2021 15:01:42 +0200
Message-Id: <20210913130203.1903622-12-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
References: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 13:02:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a083e9e2-e4c4-430f-3b1c-08d976b6c2fd
X-MS-TrafficTypeDiagnostic: SA2PR11MB4860:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB4860864B1B1C5F0AE25BA4AD93D99@SA2PR11MB4860.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B2vXlpBWiEi7LrNboItKNu87ptkqV/7bW2lF083XlhPHmzypiDDzaMyGBQLzc1f6S6+47WyWSkGvztS5DxTspwd51nY6dm0QRTvFpIfKSbmj/1kXhrncvO0pVbnrhTw3oh7nit1aeqobC1H8zAmwXmVw5OPhLVmIfE41+I+4ZXk3WJD3ooDF33icF0Z8Tu/5fhyAz2a8ADRrQjHe3XDZXXNo9IXjNUAzZnQuNwMlpkwEqk3HMkvnto7Ov/bAPUZd1S9VaTNJsDCsPShA/Yk+W3kwVs3GGXm50Abl/6iPc8tKP915HRfbGgCzgwucbjn11Bo9DZi8IZVeVy28M1HKL+Ki/x2qJ8Pii6YFUDHI1m5gXxM0K9lq9H811M74AL5IpZ6r/506WPUqfNrmSi7yXdrEaHXQDXaRjK2Dv6rnBoy1Hmo/YhpGfQR2+0Cb2lI+OI6IGsDJiaJvm1He8q1g2qKeej6CmAF1JuKlM0FAwGFanGXuRF6JdLXhZ7hYlXGUFDYU9kUQbxCs26qZLYkR9do0FMn7/36g4Of5PNrBb3lzSJ8Q6sb8yBa93Yl9u4lmniMBmwd8vKYez9J3KLOCuAxhrlij/81ydn4bzxQSA0GhSo055XBuy28H+0UO1ios0vzW8ZVlQuMSWlQavgKMb8VzPHFmFVkhyy8hLXS8yDN89Hcam0n17eraG/ip0/43s6oQhoKubGVp3bfKLvTqxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(66574015)(6666004)(66946007)(2616005)(26005)(36756003)(38100700002)(38350700002)(316002)(4326008)(107886003)(7696005)(54906003)(5660300002)(52116002)(66556008)(1076003)(66476007)(6486002)(508600001)(8936002)(83380400001)(86362001)(2906002)(8676002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MVp6WlgyYUJZcUlDRng4dWg0YnJwNnVJYmttTm5KQUtpdEgxOGJweWJDc1k3?=
 =?utf-8?B?ZlgrUG5ENFEvaGptV082b2V5U3RzbmlObU8yRTdWVjdHV0pveW1tMUgrTlV6?=
 =?utf-8?B?Y1o0cEhidkRodStRa3JVZVlXMC9HZng2U2JJYmhzTzBLMlBRTVlCWGJsc3Bv?=
 =?utf-8?B?MUxKTUF6aDJHWFZnNTBMbytGYllmTkpCVW5EWHJZOCszWGFzMWp4a3BOZWsw?=
 =?utf-8?B?cE9vZmdGalRDcHpVemNDZ0JTWXFNc0hnUHF0Q1NsSW9obzZMUVZHRm9pa0Jj?=
 =?utf-8?B?VStLQVhqSkxCdWx6NnR4WTRWUlFhUTZYRktDY0NmemdhTEpFb0c4WjkrUGFs?=
 =?utf-8?B?Rmx1Nm9VQmNZM3BUcGRpTVNtaEdOMWFLWjV1NXZLR2pjY3RWU2RqK21nWEVJ?=
 =?utf-8?B?YlE1U21xZ3R1M1VBTE5pVGlVYk8rUjY4ZE9jbU5kSk0yTzFCVFdTMXJWbVVG?=
 =?utf-8?B?SUUyU1ZrZTY2Q1ZsaTVJcHBPa3pxd3FVYitadXdERzJSZ2NtZmkrVlFPUUM4?=
 =?utf-8?B?U0dEYkdQZit2QklEMnFPL0V2SGxZY3RJZDBIcEFYcS9RQzRlOTUwV3ZUQUQz?=
 =?utf-8?B?V0g5dk1LUXNJL3dMbElLTWh0c0ptMjRyTkF1aWpIN014OFVoQnNyUDZXcFl0?=
 =?utf-8?B?MnE1emRYR0M2anh2YjR2ZXVxQWVGbVBnVGhHVGxqelRNdUw1QS9aVTZtVzBp?=
 =?utf-8?B?NXhVOGpPRUNUZHFHUDBoT25MbzlycVF5dFd4NmI4M3h0VWlZTzJOWVIwMzNH?=
 =?utf-8?B?cC9VMW1ueFE5NzcxaDVLanJqcEMvelhkOERkeWplZzZmbjhIODJZS3d6QTNw?=
 =?utf-8?B?bDNUK2JWYUVlbjFHODJYRDY2TURXWThVcXZrVk1QcGxGUUlTeGdUSDZHVEFQ?=
 =?utf-8?B?ZTNLVW5Gb0VYY3pxU0VMTytzZDV5MmlhTE11U2xDd1U4WWxHY3ljWXV4Vjdj?=
 =?utf-8?B?VnpEY2lIVUFwSWFnYmVhVUt6R1hOK1VpUHQxdG1mOFNtQ2x0TStvd1hDQUov?=
 =?utf-8?B?V3dHK1RSaFllbC9SNzNkNHNMajJaME9DOG5VRkc1Z1QvSDIrb1d6N1RzUkxa?=
 =?utf-8?B?bDdISG9NazdIWUNYVVNuRjArU0FvNnAyV2hlUE1DQlpuejVXcVk2bURzODhK?=
 =?utf-8?B?L3AwZ0hxYUkxa0RFTUVVVzAvWnhjMVkyQkpYZWlpNFp3NzdUYWNueGE5bklP?=
 =?utf-8?B?TW5YS3VrYVp2RmhXSHlINC9EOUpMc04zckM5MDFCUzFZa0kyVW9GYS83Zlha?=
 =?utf-8?B?T2lqeDVHcmdmbUk3STV4SzJsUDNCTkMxTVZDckx0OCthNndWTGdIV0FtVEF1?=
 =?utf-8?B?dnNzVzd2dzArelhIOGY1dkl6NHFTOU9sNnRxNTl0YmRqOCtwV2dlM2JnVHFE?=
 =?utf-8?B?NVVFMjAxREdRNWJ5ZzgyU3E1eHA2QzJqdXlCdG5GQzJvUDRrdVlKeDN4UG5l?=
 =?utf-8?B?T2EzRVVVQ1Ruc092ZXBXQlFmOVowK1NtT2hSOG9uaG1BajQ1VFpqTFQwekxQ?=
 =?utf-8?B?TkJnb0R4eUhUVWhsMWhacmJYdmdsUk5QY1JsVldaNkYraExCMXFKa1JtSnlR?=
 =?utf-8?B?Uk9yWkxCMEhpRGpEM0VTOUUwK2dOMUo1SkZ2SUIwcDlMb1BqRzVtUXZ5ZXh5?=
 =?utf-8?B?WGJ6dkpLa0t0WHJLYXZ1YWFqZmFvbEVmRVJEOW1KdVBkblZVQmF5YUJvZGRH?=
 =?utf-8?B?MkhCZE12bGdOL04vcWxTNXdBS3NOT0ZPa1gweFR2clVTdGxSMUtkRk9UL25B?=
 =?utf-8?Q?slTWPYJun4LCY81h2KCCiaqVDpBUB+GjKgvUmUk?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a083e9e2-e4c4-430f-3b1c-08d976b6c2fd
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 13:02:37.8256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4p4TpeOf3DWVkt/v7wkTtTSxl6fA09XB5RoGSyQ+8jj48bYL0Feo2pByAx+YOFwbAl/fi1nWqrOO7hnV3ZN3Fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4860
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IFBEUyBmaWxlIGNvbnRhaW5zIGFudGVubmEgcGFyYW1ldGVycy4gVGhlIGZpbGUgaXMgc3BlY2lm
aWMgdG8gZWFjaApoYXJkd2FyZSBkZXNpZ24uIE5vcm1hbGx5LCB0aGUgYm9hcmQgZGVzaWduZXIg
c2hvdWxkIGFkZCBhIGxpbmUgaW4gdGhlCm9mX2RldmljZV9pZCB0YWJsZSB3aXRoIGhpcyBvd24g
YW50ZW5uYSBwYXJhbWV0ZXJzLgoKVW50aWwsIG5vdyB0aGUgYWJzZW5jZSBvZiBQRFMgZmlsZSBp
cyBhIGhhcmQgZmF0YWwgZXJyb3IuIEhvd2V2ZXIsCmR1cmluZyB0aGUgZGV2ZWxvcG1lbnQsIGlu
IG1vc3Qgb2YgdGhlIGNhc2VzLCBhbiBlbXB0eSBQRFMgZmlsZSBpcwpzdWZmaWNpZW50IHRvIHN0
YXJ0IFdpRmkgY29tbXVuaWNhdGlvbi4KClRoaXMgcGF0Y2gga2VlcCBhbiBlcnJvciwgYnV0IGFs
bG93IHRoZSB1c2VyIHRvIHBsYXkgd2l0aCB0aGUgZGV2aWNlLgoKU2lnbmVkLW9mZi1ieTogSsOp
csO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMv
c3RhZ2luZy93ZngvbWFpbi5jIHwgNCArKy0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25z
KCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvbWFp
bi5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMKaW5kZXggMGE5ZDAyZDFhZjJmLi4yYTc1
OWYzNTU0YzkgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvbWFpbi5jCisrKyBiL2Ry
aXZlcnMvc3RhZ2luZy93ZngvbWFpbi5jCkBAIC0yMjAsNyArMjIwLDcgQEAgc3RhdGljIGludCB3
Znhfc2VuZF9wZGF0YV9wZHMoc3RydWN0IHdmeF9kZXYgKndkZXYpCiAKIAlyZXQgPSByZXF1ZXN0
X2Zpcm13YXJlKCZwZHMsIHdkZXYtPnBkYXRhLmZpbGVfcGRzLCB3ZGV2LT5kZXYpOwogCWlmIChy
ZXQpIHsKLQkJZGV2X2Vycih3ZGV2LT5kZXYsICJjYW4ndCBsb2FkIFBEUyBmaWxlICVzXG4iLAor
CQlkZXZfZXJyKHdkZXYtPmRldiwgImNhbid0IGxvYWQgYW50ZW5uYSBwYXJhbWV0ZXJzIChQRFMg
ZmlsZSAlcykuIFRoZSBkZXZpY2UgbWF5IGJlIHVuc3RhYmxlLlxuIiwKIAkJCXdkZXYtPnBkYXRh
LmZpbGVfcGRzKTsKIAkJZ290byBlcnIxOwogCX0KQEAgLTM5Niw3ICszOTYsNyBAQCBpbnQgd2Z4
X3Byb2JlKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KQogCWRldl9kYmcod2Rldi0+ZGV2LCAic2VuZGlu
ZyBjb25maWd1cmF0aW9uIGZpbGUgJXNcbiIsCiAJCXdkZXYtPnBkYXRhLmZpbGVfcGRzKTsKIAll
cnIgPSB3Znhfc2VuZF9wZGF0YV9wZHMod2Rldik7Ci0JaWYgKGVyciA8IDApCisJaWYgKGVyciA8
IDAgJiYgZXJyICE9IC1FTk9FTlQpCiAJCWdvdG8gZXJyMDsKIAogCXdkZXYtPnBvbGxfaXJxID0g
ZmFsc2U7Ci0tIAoyLjMzLjAKCg==
