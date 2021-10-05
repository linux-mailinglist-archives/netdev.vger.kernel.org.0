Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5250B42295B
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 15:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236311AbhJEN6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 09:58:11 -0400
Received: from mail-co1nam11on2066.outbound.protection.outlook.com ([40.107.220.66]:34049
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235601AbhJEN5U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 09:57:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FDlHdij7RDkbnu58uOt05LmpY9XFu8nwZGyBOpa3NJHuEmeakEIJlW5vnSIrwWapjm3clc+hqzSMKBlHBw8Se7+/MOMw1HXdtS3zAtHtio/RcgvuFWXRFHYMrOxjMfkM5J7WIgUPsmTTgQ3Avosvk9zExj8N3Sh9DhkeWaoZEOSHTcHvT8n/FzuFp9vvHwMjDc8YytQGJsEMAv30JqeEZF7qSEVjintP8d4ePRMeC24zr3q/cdNvFfpSF1oYxX/0UbbdahiMcERGVo2+PWwLmwpeCC8dpUgikeH3w+iMJnNs6WNNDWJlRrHBgcJlC8zRsosvOrhxHzRirVxRTM+9Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GBnZqeb4Sp5OnrJs0hzKJp9ild+Ok2gpApXY2Eigxok=;
 b=fOpKEvroDUKwk9fYVFEilMTG5lo0XQabfyAibgtohev4tkj2IIUwVjUkV8N9JFwL1DhGnaIq2mWzFTFdItILyFbck595fDm9nserosqRpsuKWRvU3WodmNkiLZQSdm1w+BZoFhVfWHj9UUqMgJZNgyGDIRXSTReJoPsyTDccpL8c4LJ05Ldq7P+BF6QjMBWdDhLzMDpUnzO1Jj/fd+kpzGPb99p//lx0h5EVH54uXfTdslXBKuxvBrewKin8AcVM9kYoAmlWSKKRfL8LCJ9BiKi97jdBAbQvv84roa+bJ4QlkFYiPY6I262NTmOQ/VNwK/v2AK0GB1G8KvK2DnGnKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GBnZqeb4Sp5OnrJs0hzKJp9ild+Ok2gpApXY2Eigxok=;
 b=KP1LXav4edmWF50hu95lGhaOUCqj4ibdJCEgUyBTC2wSJ69yxbFnrSfsZnrvUuzxqwv6dr/rAPAAJuYEGWM9BiPwehbAtYDGFtaIrBcdL5QjopbYY95qKk1GncamHvG8JWt9BaQFonhHVnZuyNsx1ZSNS4av/K/qep3EVkbHD/0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5627.namprd11.prod.outlook.com (2603:10b6:510:e4::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Tue, 5 Oct
 2021 13:55:07 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4%9]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 13:55:07 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v8 16/24] wfx: add data_rx.c/data_rx.h
Date:   Tue,  5 Oct 2021 15:53:52 +0200
Message-Id: <20211005135400.788058-17-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135400.788058-1-Jerome.Pouiller@silabs.com>
References: <20211005135400.788058-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR3P189CA0084.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:b4::29) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR3P189CA0084.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:b4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 5 Oct 2021 13:55:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66df860f-d086-4def-e7bd-08d98807bd63
X-MS-TrafficTypeDiagnostic: PH0PR11MB5627:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR11MB56271503C60264555122B10893AF9@PH0PR11MB5627.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7VDFVPqTlHQXc2PWKoEmtF7w1OF9xpe9EPolVK1NchMnTIUcJenyhXZMD3YUUftiMM7uTV7e+Oo+X0hLsqJdsMrAVeKvy0Ws4B5feJlpHkYkz+/5PjOO998gzl2hfs+kF9q4iFeZSerVWUEWJ8e+AyNTrnLlIN2YqoUqI01pSP7JtRV0K5H3lwfAXbcLJfketpgMBs35XIB9ue/AijNOL24gM2sOZmWmhmO1qLLCj6UHrCuTJOmW3IO6nKCNQ4R9kzvDb859m55EvnqEt05rzFBXzp8KnMijuinPbzyJ4q2LmFeaw1XLENZmsXtVeEU+NsE0DVqyqug7Y8EuY9Ylst1eydHaER/GTnGT1GisoUvvcBwX6tYv6JkyAQJ/7xh9Uvx2ggbc0afQls1Egkcc3QXUFkbo8RSp+4liLY5HZtN3GpOoa/N0rZFF1z0CmS4EzsSStJ19J0CRx52aYDBi2RDqdBMl+otcgDYphybw3JUfZKjjOEH0UeYYJuSXqF7tjGI9e/jiwstCh5MoyVlJb090FfCW0TdyiUPzBYUj33xUigPrxPoA80AsTq0rFXRgkj5lxQG+dIG5fJYozyXszyJ5iLW6DXhUuy6IJXLp+nztCV5E7F5wNyLgeG6hT0lBpc+vb/DUXFl6cYTrvjkTQN1gAhKDnyTNFgQWtJWdvqqjdBbJG6x3DprIqrEFROctQOMystAdLl7ylvfUyRoYTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(508600001)(8676002)(66946007)(66476007)(66556008)(7696005)(107886003)(316002)(4326008)(26005)(2906002)(6666004)(7416002)(1076003)(956004)(54906003)(5660300002)(2616005)(186003)(38350700002)(6486002)(83380400001)(86362001)(6916009)(8936002)(38100700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?anpSUkl0YzJnNThNTDJLTUJCRFdYV0NCaTV1TnV6N1dUdHUrcmZlNDNReVFY?=
 =?utf-8?B?bm8xUkp6eWVKQURaWERHeGgwbW10MG91WnpJRlBQTllvYWg2WldlYWxkUVY5?=
 =?utf-8?B?UldidVJKa0YwMTg4ZG5wcnFpVU1ESGpJdGk1em9pL0hEV25Yc1RlQ0l6dkxP?=
 =?utf-8?B?Qzl6aUhZTE1JVUJZbEg5dTV0bjUyMWd4M2I5RDRtNDdUeW1taEhXcmJkTHNF?=
 =?utf-8?B?ZkZSRUNCdTd2M0h4UzBhTlNHTjlNNEFWaWkwNWRwN2NDSklURG5uZ05naWox?=
 =?utf-8?B?Z2dabk1tcS9hdlpLS1JSaWhBSWxKdkNYSVhwZzMvallDV2ZZK1FMNWkrTmpv?=
 =?utf-8?B?dVZ3Z3B6WlpQSHJEcHI2NUNZdFJ3em9EMUlWRUFSeWpWVTZzb096Z3Jhek55?=
 =?utf-8?B?MElISWMxTm1lclF1NjlrU09VYXdKMnBndDdaSkNRVHNsM1J1NW1MTllsMzli?=
 =?utf-8?B?NmVGOEhoUjAweUNCUHhtYmRrdHc0UGhudDlYTE5obzdaMWJHbFhZOUtSeENi?=
 =?utf-8?B?Z1F1RDVmOTRpQVlVaWVaSCtKaEU4T1ZwenlYMHFnemlPcjc5LzBQVERVVWRm?=
 =?utf-8?B?NjRqOTU3dkRsR3JXbFhVUXR6Wno3V0p6V1lHRUJudStqUyt3RWU4TEE3U0R0?=
 =?utf-8?B?cU1OWDMvT3dUVStJRzN2eXBVSmZIRUZEWTFyME1YbHpEOGpFbHZra0ZCRk1x?=
 =?utf-8?B?T2NvVXdNVWhzNVVBQVRWRmhjQ1Zpb3Flbm1qZitNWTNaSWVGOTI3VGVzS29Y?=
 =?utf-8?B?NjFlSSsrQXVXWlpwaEkyVExHM2pJUXNFVk0rZEdSQS9sR3VVc3g3dUVFdlJX?=
 =?utf-8?B?cVNlRjlYL045WXV6WEl4b1ovNkJEbHlzQ2s1ekx4WUxid1JoWW1la0pHVXZ3?=
 =?utf-8?B?WDJvQ1lKU2NoMnJtbWw4M0NWKzVSR3dzTFhONnRsTURNaVlBTkhzV0ZaQ0t5?=
 =?utf-8?B?V1VYTjVKdW5CTHI5d3NPWlcvS2RSNUZ1UGNaNFRySlVQaTZMd005ZjE4Nk5U?=
 =?utf-8?B?bTdLRmxpd1JWNjM4VGhyWktMT1JmQXRPa3pSUG8zck9UQWo5NDkwdk9CY2ZC?=
 =?utf-8?B?cURVa3JsdWJhUkthNW5uUTFiNUZYbnNMZVRkSXhQSjNpRWtpQzE3dS9VUHpB?=
 =?utf-8?B?Q0FPSlBlRUNBd3M4SkY4bThEa051SHFVNXhnblhkeEo4dXYvUUdiaWYwbTBy?=
 =?utf-8?B?NTgxSk9LbkxMKzVRQXJTTHcxYkxyV0JwZUZCOG5KblBsc0dlc29nZVpzeGNa?=
 =?utf-8?B?U3EzU0lnS2ZscTJkZ0lSakQ0R3Bmem9yRHRxU1NNcW5QejNFQ3k3Z3o5YmJX?=
 =?utf-8?B?NE1tM2ZRcnBSZ1JMcTJiUndLSi9ua21tQ1h0ZVRxNTRIM1lzdVp0YmI2ZUhv?=
 =?utf-8?B?azR6cEdmOFI1dDRZc3RLa25GMHZTU2hXd3ViNHZoV0J4Z2JGZVFtRGN0TCtW?=
 =?utf-8?B?NjhJSkdRczk3VzFYeU90YnBXM0xFN1ZwOVBCM2Y3L2cwMUdYU204WnlnUkxj?=
 =?utf-8?B?TU81SU9jOEdNT1dOeEJzeTJFajJhZTZ2Q0Q0OGkwY2pUYW9yTmpTeXp4Mi92?=
 =?utf-8?B?K2d0MHdPN2wvc2VEQkJjTjdyWHhoaWN2UVo0Ulg1VTZqQUJ3bnR0T3dHcFcx?=
 =?utf-8?B?d2M2YUFXbUdIRkdWSTNLOVdoSHQwVDIyek1lakhUbVZ2SjRIY3FaalgwM2Rr?=
 =?utf-8?B?UXluWldONHp4Mjk0c2kxdjVGUFc5L0tlVW9qRStFTjUzWEQ4VnNxWjJBRGM5?=
 =?utf-8?Q?PLg4OdGokFlxMt05WYtp0pYPGW5YXK2F4UWgvIO?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66df860f-d086-4def-e7bd-08d98807bd63
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 13:55:07.7257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FdWsucXwxYKZ5RB+crbgiiA06glB7mXTf+BLcl3TgSSOO1tssI/d6AyRWjkoSvkDDFB1GZGu9yrCsyL/JwhSzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5627
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
PgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0YV9yeC5jIHwgOTQgKysr
KysrKysrKysrKysrKysrKysrKysKIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0
YV9yeC5oIHwgMTggKysrKysKIDIgZmlsZXMgY2hhbmdlZCwgMTEyIGluc2VydGlvbnMoKykKIGNy
ZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L2RhdGFfcngu
YwogY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0
YV9yeC5oCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9kYXRh
X3J4LmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L2RhdGFfcnguYwpuZXcgZmls
ZSBtb2RlIDEwMDY0NAppbmRleCAwMDAwMDAwMDAwMDAuLjNmZTY3YzQ4MTVlNwotLS0gL2Rldi9u
dWxsCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0YV9yeC5jCkBAIC0w
LDAgKzEsOTQgQEAKKy8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkKKy8q
CisgKiBEYXRhIHJlY2VpdmluZyBpbXBsZW1lbnRhdGlvbi4KKyAqCisgKiBDb3B5cmlnaHQgKGMp
IDIwMTctMjAyMCwgU2lsaWNvbiBMYWJvcmF0b3JpZXMsIEluYy4KKyAqIENvcHlyaWdodCAoYykg
MjAxMCwgU1QtRXJpY3Nzb24KKyAqLworI2luY2x1ZGUgPGxpbnV4L2V0aGVyZGV2aWNlLmg+Cisj
aW5jbHVkZSA8bmV0L21hYzgwMjExLmg+CisKKyNpbmNsdWRlICJkYXRhX3J4LmgiCisjaW5jbHVk
ZSAid2Z4LmgiCisjaW5jbHVkZSAiYmguaCIKKyNpbmNsdWRlICJzdGEuaCIKKworc3RhdGljIHZv
aWQgd2Z4X3J4X2hhbmRsZV9iYShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgc3RydWN0IGllZWU4MDIx
MV9tZ210ICptZ210KQoreworCWludCBwYXJhbXMsIHRpZDsKKworCWlmICh3ZnhfYXBpX29sZGVy
X3RoYW4od3ZpZi0+d2RldiwgMywgNikpCisJCXJldHVybjsKKworCXN3aXRjaCAobWdtdC0+dS5h
Y3Rpb24udS5hZGRiYV9yZXEuYWN0aW9uX2NvZGUpIHsKKwljYXNlIFdMQU5fQUNUSU9OX0FEREJB
X1JFUToKKwkJcGFyYW1zID0gbGUxNl90b19jcHUobWdtdC0+dS5hY3Rpb24udS5hZGRiYV9yZXEu
Y2FwYWIpOworCQl0aWQgPSAocGFyYW1zICYgSUVFRTgwMjExX0FEREJBX1BBUkFNX1RJRF9NQVNL
KSA+PiAyOworCQlpZWVlODAyMTFfc3RhcnRfcnhfYmFfc2Vzc2lvbl9vZmZsKHd2aWYtPnZpZiwg
bWdtdC0+c2EsIHRpZCk7CisJCWJyZWFrOworCWNhc2UgV0xBTl9BQ1RJT05fREVMQkE6CisJCXBh
cmFtcyA9IGxlMTZfdG9fY3B1KG1nbXQtPnUuYWN0aW9uLnUuZGVsYmEucGFyYW1zKTsKKwkJdGlk
ID0gKHBhcmFtcyAmICBJRUVFODAyMTFfREVMQkFfUEFSQU1fVElEX01BU0spID4+IDEyOworCQlp
ZWVlODAyMTFfc3RvcF9yeF9iYV9zZXNzaW9uX29mZmwod3ZpZi0+dmlmLCBtZ210LT5zYSwgdGlk
KTsKKwkJYnJlYWs7CisJfQorfQorCit2b2lkIHdmeF9yeF9jYihzdHJ1Y3Qgd2Z4X3ZpZiAqd3Zp
ZiwKKwkgICAgICAgY29uc3Qgc3RydWN0IHdmeF9oaWZfaW5kX3J4ICphcmcsIHN0cnVjdCBza19i
dWZmICpza2IpCit7CisJc3RydWN0IGllZWU4MDIxMV9yeF9zdGF0dXMgKmhkciA9IElFRUU4MDIx
MV9TS0JfUlhDQihza2IpOworCXN0cnVjdCBpZWVlODAyMTFfaGRyICpmcmFtZSA9IChzdHJ1Y3Qg
aWVlZTgwMjExX2hkciAqKXNrYi0+ZGF0YTsKKwlzdHJ1Y3QgaWVlZTgwMjExX21nbXQgKm1nbXQg
PSAoc3RydWN0IGllZWU4MDIxMV9tZ210ICopc2tiLT5kYXRhOworCisJbWVtc2V0KGhkciwgMCwg
c2l6ZW9mKCpoZHIpKTsKKworCWlmIChhcmctPnN0YXR1cyA9PSBISUZfU1RBVFVTX1JYX0ZBSUxf
TUlDKQorCQloZHItPmZsYWcgfD0gUlhfRkxBR19NTUlDX0VSUk9SIHwgUlhfRkxBR19JVl9TVFJJ
UFBFRDsKKwllbHNlIGlmIChhcmctPnN0YXR1cykKKwkJZ290byBkcm9wOworCisJaWYgKHNrYi0+
bGVuIDwgc2l6ZW9mKHN0cnVjdCBpZWVlODAyMTFfcHNwb2xsKSkgeworCQlkZXZfd2Fybih3dmlm
LT53ZGV2LT5kZXYsICJtYWxmb3JtZWQgU0RVIHJlY2VpdmVkXG4iKTsKKwkJZ290byBkcm9wOwor
CX0KKworCWhkci0+YmFuZCA9IE5MODAyMTFfQkFORF8yR0haOworCWhkci0+ZnJlcSA9IGllZWU4
MDIxMV9jaGFubmVsX3RvX2ZyZXF1ZW5jeShhcmctPmNoYW5uZWxfbnVtYmVyLAorCQkJCQkJICAg
aGRyLT5iYW5kKTsKKworCWlmIChhcmctPnJ4ZWRfcmF0ZSA+PSAxNCkgeworCQloZHItPmVuY29k
aW5nID0gUlhfRU5DX0hUOworCQloZHItPnJhdGVfaWR4ID0gYXJnLT5yeGVkX3JhdGUgLSAxNDsK
Kwl9IGVsc2UgaWYgKGFyZy0+cnhlZF9yYXRlID49IDQpIHsKKwkJaGRyLT5yYXRlX2lkeCA9IGFy
Zy0+cnhlZF9yYXRlIC0gMjsKKwl9IGVsc2UgeworCQloZHItPnJhdGVfaWR4ID0gYXJnLT5yeGVk
X3JhdGU7CisJfQorCisJaWYgKCFhcmctPnJjcGlfcnNzaSkgeworCQloZHItPmZsYWcgfD0gUlhf
RkxBR19OT19TSUdOQUxfVkFMOworCQlkZXZfaW5mbyh3dmlmLT53ZGV2LT5kZXYsICJyZWNlaXZl
ZCBmcmFtZSB3aXRob3V0IFJTU0kgZGF0YVxuIik7CisJfQorCWhkci0+c2lnbmFsID0gYXJnLT5y
Y3BpX3Jzc2kgLyAyIC0gMTEwOworCWhkci0+YW50ZW5uYSA9IDA7CisKKwlpZiAoYXJnLT5lbmNy
eXApCisJCWhkci0+ZmxhZyB8PSBSWF9GTEFHX0RFQ1JZUFRFRDsKKworCS8qIEJsb2NrIGFjayBu
ZWdvdGlhdGlvbiBpcyBvZmZsb2FkZWQgYnkgdGhlIGZpcm13YXJlLiBIb3dldmVyLAorCSAqIHJl
LW9yZGVyaW5nIG11c3QgYmUgZG9uZSBieSB0aGUgbWFjODAyMTEuCisJICovCisJaWYgKGllZWU4
MDIxMV9pc19hY3Rpb24oZnJhbWUtPmZyYW1lX2NvbnRyb2wpICYmCisJICAgIG1nbXQtPnUuYWN0
aW9uLmNhdGVnb3J5ID09IFdMQU5fQ0FURUdPUllfQkFDSyAmJgorCSAgICBza2ItPmxlbiA+IElF
RUU4MDIxMV9NSU5fQUNUSU9OX1NJWkUpIHsKKwkJd2Z4X3J4X2hhbmRsZV9iYSh3dmlmLCBtZ210
KTsKKwkJZ290byBkcm9wOworCX0KKworCWllZWU4MDIxMV9yeF9pcnFzYWZlKHd2aWYtPndkZXYt
Pmh3LCBza2IpOworCXJldHVybjsKKworZHJvcDoKKwlkZXZfa2ZyZWVfc2tiKHNrYik7Cit9CmRp
ZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L2RhdGFfcnguaCBiL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0YV9yeC5oCm5ldyBmaWxlIG1vZGUgMTAw
NjQ0CmluZGV4IDAwMDAwMDAwMDAwMC4uN2Q3N2NkYmJjMzFiCi0tLSAvZGV2L251bGwKKysrIGIv
ZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9kYXRhX3J4LmgKQEAgLTAsMCArMSwxOCBA
QAorLyogU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAtb25seSAqLworLyoKKyAqIERh
dGEgcmVjZWl2aW5nIGltcGxlbWVudGF0aW9uLgorICoKKyAqIENvcHlyaWdodCAoYykgMjAxNy0y
MDIwLCBTaWxpY29uIExhYm9yYXRvcmllcywgSW5jLgorICogQ29weXJpZ2h0IChjKSAyMDEwLCBT
VC1Fcmljc3NvbgorICovCisjaWZuZGVmIFdGWF9EQVRBX1JYX0gKKyNkZWZpbmUgV0ZYX0RBVEFf
UlhfSAorCitzdHJ1Y3Qgd2Z4X3ZpZjsKK3N0cnVjdCBza19idWZmOworc3RydWN0IHdmeF9oaWZf
aW5kX3J4OworCit2b2lkIHdmeF9yeF9jYihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKKwkgICAgICAg
Y29uc3Qgc3RydWN0IHdmeF9oaWZfaW5kX3J4ICphcmcsIHN0cnVjdCBza19idWZmICpza2IpOwor
CisjZW5kaWYKLS0gCjIuMzMuMAoK
