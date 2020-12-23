Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859A72E1E81
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 16:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729218AbgLWPlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 10:41:55 -0500
Received: from mail-mw2nam12on2078.outbound.protection.outlook.com ([40.107.244.78]:27104
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728422AbgLWPlv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 10:41:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XGmTCfJKBGw3BdnfomMe7IsytuezSMzxxyIwLA4BNnf5/Bz+9TmszMyonHiBiBQelHh2hCF8xRD1wAvEb4TJ/i0pOaJDjpk3xI9fJ+/ouZ2JVMHxa9azClXFD9UoEx38lkquqHX//0ApLswD7b4QeHLFnvq9KaqDWNBxZ7MuXBtQ4zyfFrJVJL1YZ7I16lMQjY3LDdPHbAypSxrvmugnLiHOx/GgutjpmVEPqm9EXFj3dGf71rbX344mq3IVtGZ2pCWnZhoz0mkTrQ2CumjcEqCnMDGDtdVwpIP6ckijDkx37TQ/zZfHb1F7ZczZPOd2OHO99QpbVhZawIr4WJ4hng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oyZovbrWuWNAssWmQIv6YcBO/dyLQ9nf1NwrMuLwb2A=;
 b=Hko7PcF53yRgYxsc1MRiXtXIYOhBKQlEG93A58rUo2uYwIbckp9iGQMc0jBxuXUC3WOXM4Y/63ahUN9OKCbq67B+YZNFUdacmBth7VR430MPGOHhvOudnuyFVioQP8INQJICk4gvHaRRholXZeU1eF3spdIBgQgoxiK3ZLuwKErTxRRXzSUaAHG729Dut6KIhuMg5tk9kBTrMtEn1iUbfYrnJTel3uBOQciTeJGL09IQa84Z3wrESGXL93mew/GKrDuSAD0Yine4UorjPOoOzqwFIcPxZSEbHvEFkGSw8wPH/e7WfkA+av01Hop7mtPugiFCF22RZusVGdQWcVn0bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oyZovbrWuWNAssWmQIv6YcBO/dyLQ9nf1NwrMuLwb2A=;
 b=UMBcUCM8zSEAvN8RutgZoae+tSNXwvxnxSVlBdxS5f6g+96vYQzP36HI6djRYUldM3Ug3OvQAbgMkH/AiA7NYbYamNhfK4LBOyIgJC89t7iTpi48Voh6hL+pkGimxjBYoLxWpirCX0K6WfDYxajaTzpu6hFtOUTQ45B7t0G5UZ0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2815.namprd11.prod.outlook.com (2603:10b6:805:62::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Wed, 23 Dec
 2020 15:40:19 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::a989:f850:6736:97ca]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::a989:f850:6736:97ca%5]) with mapi id 15.20.3700.026; Wed, 23 Dec 2020
 15:40:19 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v4 16/24] wfx: add data_rx.c/data_rx.h
Date:   Wed, 23 Dec 2020 16:39:17 +0100
Message-Id: <20201223153925.73742-17-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223153925.73742-1-Jerome.Pouiller@silabs.com>
References: <20201223153925.73742-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: SA0PR12CA0024.namprd12.prod.outlook.com
 (2603:10b6:806:6f::29) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (82.67.86.106) by SA0PR12CA0024.namprd12.prod.outlook.com (2603:10b6:806:6f::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.27 via Frontend Transport; Wed, 23 Dec 2020 15:40:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37482021-529f-4cfb-77d7-08d8a7590d53
X-MS-TrafficTypeDiagnostic: SN6PR11MB2815:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB281501A812FDF44288C2102293DE0@SN6PR11MB2815.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AOVE6SFhH8YkozjmHiwQLiIrexIVJRz6z+ptDT1EzWvYxwke2CcB35yWRJ3xsQ/zZecujEZadqfoGj1KlGOplvQCgZ4LXH63V71aq3V+n16dTKklQbFt50NbwDbUfn2++fBfJqThULHYalTLdSJYWoDReLuWNMUdiimeim5O5UT+rBOkn78PlI/b/P5VZ5oVB5ecF05bWxTqEjFXkp31jJ93LJM8hbrlLm9oz/5LCef7yEeXZWXz6xAmvz4cXgFr9yLjKwlf3+vs2nvbafrp2Po31EKsoG+GLVjtYzrF1frMjNhlojj57u8z1+l5QgRScEqDyEaTgz+8/pE+JQlKk+fyP7fUxMtBf1uGnAjmFjX/HXnFEUPLOSTJ6nXSyEpzVHYsG84pzCnAXFwPAPgJig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(376002)(39850400004)(346002)(478600001)(83380400001)(8676002)(186003)(2906002)(8936002)(26005)(52116002)(107886003)(16526019)(7696005)(66946007)(7416002)(6486002)(956004)(2616005)(54906003)(66476007)(316002)(4326008)(36756003)(5660300002)(1076003)(86362001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dFZIOWg3RDFudThhdDVhS1B4WnpSVXZaZzBqUUhtUlQxajJwb21odWVhbEVI?=
 =?utf-8?B?WjNiS0pvZFV0MndRanFNdC9mVWZEMDQ4ZVJkWFF4TXR1dmNpZUhDazRVZVd2?=
 =?utf-8?B?enVFaDVOMUJ1cXJLTFMrVXA5ZjhsYXNnZ0llZ2dreldieGZsZEMxNmR1SkFn?=
 =?utf-8?B?NXBUN2lnVVRpd1JHZjJ5OVYxZGw1ZXBkcW45ZUVFczM3YUVNcmkyVXBGMFBj?=
 =?utf-8?B?eG12OTNIM0ZwUk53Z2U0cERqZ0RIb25tdGV4MDdwa0FWV3pkUlBhMis0VEFB?=
 =?utf-8?B?aGhXMGFXVXMvN1FJL3daQm1MSG0xSHhTLy9lUnhSY0xXRDJRZDZpZWlaVUpi?=
 =?utf-8?B?VVlBeW9jY3JmVkE1QTNaYUdWanArdUNaRDVhcmk5dmdLYzZXWGN1aVVqTDNP?=
 =?utf-8?B?b0xNeTJuZm9lYThyTkc0aWUycnVUTlM1WS9pWm80WjZTczFBNEY4YnVUWEZ6?=
 =?utf-8?B?bXRZUWxzdGEvbWZVb3ZrbEluVTZBUjJ4VVNzKzZFNzFQNXlEdHg5Nit4WG04?=
 =?utf-8?B?a2EyUUppakdtNC9HYi8rRzFxUUJ1bzBqdFcwSmVHOXQxclB5b1NyUENkWGZi?=
 =?utf-8?B?REwrN2FwOGZ0U3RzNkZuNnZPZEE4U1lLOSs4b01tVWR5NktVM3BVRFdneVBJ?=
 =?utf-8?B?VUFaakJFQmx3KytzcVQrTWk1OE4vUlFmRUNZSUs2ZUdzSGhndnNQRVNmSDU3?=
 =?utf-8?B?L0FpakZwR29tZzVETnBIZWRBa3M5U0JQSDBMaXVRYlZ2TEUzV014TzZUMmRK?=
 =?utf-8?B?YUxadXdGbnJXdERDMzdYOXJLcHEySUVYSnB1Q2FQa2FiNXdDMjVjOFlEZzNG?=
 =?utf-8?B?WkNwQ1JJQ3dQeFJSU0t3aDBDdkl2ZGJvaS9QMG1MTnFLc2V2R3gzd0lKamUx?=
 =?utf-8?B?VXFGbElzeU8vaHN6QWdHcWd4RjhZWEtIb2RoUlp4MGRQR3I4bzFlWjhLQ0pv?=
 =?utf-8?B?NkVYT2tYMDQ5dWVndXVVcktEa09uaEY5YzBoakxFQW41VkVkSSt4Y1pVTWRr?=
 =?utf-8?B?cllMOC8wRjFVTHY4K00yYjdrd0k1MjBSRE11QUJ6ZklMVzVXdXpFZmVOTDBj?=
 =?utf-8?B?b1NVSDFKcjk5cXJkdHRrcWUyTDVoTjRHMkJqcUdiSldUdWVoQmNVb1ZwZnJR?=
 =?utf-8?B?cUNUVENmUTZkaVNWQlhoQWdRVGR4Rkc2am9uWnpISitXVUNoRnZCVkpWejdS?=
 =?utf-8?B?WkRJZzlXU3ZERkNVeGZZa3UvRXRZZnZaUzJLeTJzZzN6WElqNmlCM1prTEdr?=
 =?utf-8?B?OGJQZzZoMFkrMGZKSDRBUUNGTTcxS2NoQ2d0UnVOSGxGZkIxanRQbGtRSXhx?=
 =?utf-8?Q?U9wLOhVkX8YvYSTZhzNUD2pBUPjyeg8V/7?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2020 15:40:18.8977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-Network-Message-Id: 37482021-529f-4cfb-77d7-08d8a7590d53
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a2In/j9P61C7bzw96Eqx9WWg+33FRL7gwRDkZAoz7XuNLoIeedYUYPWWQlXrTYibrIIaUsmWSYKZ49ddXPBDJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2815
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
ZSBtb2RlIDEwMDY0NAppbmRleCAwMDAwMDAwMDAwMDAuLmU2ZDlkODc0NmQ0ZAotLS0gL2Rldi9u
dWxsCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0YV9yeC5jCkBAIC0w
LDAgKzEsOTQgQEAKKy8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkKKy8q
CisgKiBEYXRhcGF0aCBpbXBsZW1lbnRhdGlvbi4KKyAqCisgKiBDb3B5cmlnaHQgKGMpIDIwMTct
MjAyMCwgU2lsaWNvbiBMYWJvcmF0b3JpZXMsIEluYy4KKyAqIENvcHlyaWdodCAoYykgMjAxMCwg
U1QtRXJpY3Nzb24KKyAqLworI2luY2x1ZGUgPGxpbnV4L2V0aGVyZGV2aWNlLmg+CisjaW5jbHVk
ZSA8bmV0L21hYzgwMjExLmg+CisKKyNpbmNsdWRlICJkYXRhX3J4LmgiCisjaW5jbHVkZSAid2Z4
LmgiCisjaW5jbHVkZSAiYmguaCIKKyNpbmNsdWRlICJzdGEuaCIKKworc3RhdGljIHZvaWQgd2Z4
X3J4X2hhbmRsZV9iYShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgc3RydWN0IGllZWU4MDIxMV9tZ210
ICptZ210KQoreworCWludCBwYXJhbXMsIHRpZDsKKworCWlmICh3ZnhfYXBpX29sZGVyX3RoYW4o
d3ZpZi0+d2RldiwgMywgNikpCisJCXJldHVybjsKKworCXN3aXRjaCAobWdtdC0+dS5hY3Rpb24u
dS5hZGRiYV9yZXEuYWN0aW9uX2NvZGUpIHsKKwljYXNlIFdMQU5fQUNUSU9OX0FEREJBX1JFUToK
KwkJcGFyYW1zID0gbGUxNl90b19jcHUobWdtdC0+dS5hY3Rpb24udS5hZGRiYV9yZXEuY2FwYWIp
OworCQl0aWQgPSAocGFyYW1zICYgSUVFRTgwMjExX0FEREJBX1BBUkFNX1RJRF9NQVNLKSA+PiAy
OworCQlpZWVlODAyMTFfc3RhcnRfcnhfYmFfc2Vzc2lvbl9vZmZsKHd2aWYtPnZpZiwgbWdtdC0+
c2EsIHRpZCk7CisJCWJyZWFrOworCWNhc2UgV0xBTl9BQ1RJT05fREVMQkE6CisJCXBhcmFtcyA9
IGxlMTZfdG9fY3B1KG1nbXQtPnUuYWN0aW9uLnUuZGVsYmEucGFyYW1zKTsKKwkJdGlkID0gKHBh
cmFtcyAmICBJRUVFODAyMTFfREVMQkFfUEFSQU1fVElEX01BU0spID4+IDEyOworCQlpZWVlODAy
MTFfc3RvcF9yeF9iYV9zZXNzaW9uX29mZmwod3ZpZi0+dmlmLCBtZ210LT5zYSwgdGlkKTsKKwkJ
YnJlYWs7CisJfQorfQorCit2b2lkIHdmeF9yeF9jYihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKKwkg
ICAgICAgY29uc3Qgc3RydWN0IGhpZl9pbmRfcnggKmFyZywgc3RydWN0IHNrX2J1ZmYgKnNrYikK
K3sKKwlzdHJ1Y3QgaWVlZTgwMjExX3J4X3N0YXR1cyAqaGRyID0gSUVFRTgwMjExX1NLQl9SWENC
KHNrYik7CisJc3RydWN0IGllZWU4MDIxMV9oZHIgKmZyYW1lID0gKHN0cnVjdCBpZWVlODAyMTFf
aGRyICopc2tiLT5kYXRhOworCXN0cnVjdCBpZWVlODAyMTFfbWdtdCAqbWdtdCA9IChzdHJ1Y3Qg
aWVlZTgwMjExX21nbXQgKilza2ItPmRhdGE7CisKKwltZW1zZXQoaGRyLCAwLCBzaXplb2YoKmhk
cikpOworCisJaWYgKGFyZy0+c3RhdHVzID09IEhJRl9TVEFUVVNfUlhfRkFJTF9NSUMpCisJCWhk
ci0+ZmxhZyB8PSBSWF9GTEFHX01NSUNfRVJST1IgfCBSWF9GTEFHX0lWX1NUUklQUEVEOworCWVs
c2UgaWYgKGFyZy0+c3RhdHVzKQorCQlnb3RvIGRyb3A7CisKKwlpZiAoc2tiLT5sZW4gPCBzaXpl
b2Yoc3RydWN0IGllZWU4MDIxMV9wc3BvbGwpKSB7CisJCWRldl93YXJuKHd2aWYtPndkZXYtPmRl
diwgIm1hbGZvcm1lZCBTRFUgcmVjZWl2ZWRcbiIpOworCQlnb3RvIGRyb3A7CisJfQorCisJaGRy
LT5iYW5kID0gTkw4MDIxMV9CQU5EXzJHSFo7CisJaGRyLT5mcmVxID0gaWVlZTgwMjExX2NoYW5u
ZWxfdG9fZnJlcXVlbmN5KGFyZy0+Y2hhbm5lbF9udW1iZXIsCisJCQkJCQkgICBoZHItPmJhbmQp
OworCisJaWYgKGFyZy0+cnhlZF9yYXRlID49IDE0KSB7CisJCWhkci0+ZW5jb2RpbmcgPSBSWF9F
TkNfSFQ7CisJCWhkci0+cmF0ZV9pZHggPSBhcmctPnJ4ZWRfcmF0ZSAtIDE0OworCX0gZWxzZSBp
ZiAoYXJnLT5yeGVkX3JhdGUgPj0gNCkgeworCQloZHItPnJhdGVfaWR4ID0gYXJnLT5yeGVkX3Jh
dGUgLSAyOworCX0gZWxzZSB7CisJCWhkci0+cmF0ZV9pZHggPSBhcmctPnJ4ZWRfcmF0ZTsKKwl9
CisKKwlpZiAoIWFyZy0+cmNwaV9yc3NpKSB7CisJCWhkci0+ZmxhZyB8PSBSWF9GTEFHX05PX1NJ
R05BTF9WQUw7CisJCWRldl9pbmZvKHd2aWYtPndkZXYtPmRldiwgInJlY2VpdmVkIGZyYW1lIHdp
dGhvdXQgUlNTSSBkYXRhXG4iKTsKKwl9CisJaGRyLT5zaWduYWwgPSBhcmctPnJjcGlfcnNzaSAv
IDIgLSAxMTA7CisJaGRyLT5hbnRlbm5hID0gMDsKKworCWlmIChhcmctPmVuY3J5cCkKKwkJaGRy
LT5mbGFnIHw9IFJYX0ZMQUdfREVDUllQVEVEOworCisJLyogQmxvY2sgYWNrIG5lZ290aWF0aW9u
IGlzIG9mZmxvYWRlZCBieSB0aGUgZmlybXdhcmUuIEhvd2V2ZXIsCisJICogcmUtb3JkZXJpbmcg
bXVzdCBiZSBkb25lIGJ5IHRoZSBtYWM4MDIxMS4KKwkgKi8KKwlpZiAoaWVlZTgwMjExX2lzX2Fj
dGlvbihmcmFtZS0+ZnJhbWVfY29udHJvbCkgJiYKKwkgICAgbWdtdC0+dS5hY3Rpb24uY2F0ZWdv
cnkgPT0gV0xBTl9DQVRFR09SWV9CQUNLICYmCisJICAgIHNrYi0+bGVuID4gSUVFRTgwMjExX01J
Tl9BQ1RJT05fU0laRSkgeworCQl3ZnhfcnhfaGFuZGxlX2JhKHd2aWYsIG1nbXQpOworCQlnb3Rv
IGRyb3A7CisJfQorCisJaWVlZTgwMjExX3J4X2lycXNhZmUod3ZpZi0+d2Rldi0+aHcsIHNrYik7
CisJcmV0dXJuOworCitkcm9wOgorCWRldl9rZnJlZV9za2Ioc2tiKTsKK30KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0YV9yeC5oIGIvZHJpdmVycy9uZXQv
d2lyZWxlc3Mvc2lsYWJzL3dmeC9kYXRhX3J4LmgKbmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXgg
MDAwMDAwMDAwMDAwLi5hMzIwY2Q4NTgyNzMKLS0tIC9kZXYvbnVsbAorKysgYi9kcml2ZXJzL25l
dC93aXJlbGVzcy9zaWxhYnMvd2Z4L2RhdGFfcnguaApAQCAtMCwwICsxLDE4IEBACisvKiBTUERY
LUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5ICovCisvKgorICogRGF0YXBhdGggaW1w
bGVtZW50YXRpb24uCisgKgorICogQ29weXJpZ2h0IChjKSAyMDE3LTIwMjAsIFNpbGljb24gTGFi
b3JhdG9yaWVzLCBJbmMuCisgKiBDb3B5cmlnaHQgKGMpIDIwMTAsIFNULUVyaWNzc29uCisgKi8K
KyNpZm5kZWYgV0ZYX0RBVEFfUlhfSAorI2RlZmluZSBXRlhfREFUQV9SWF9ICisKK3N0cnVjdCB3
ZnhfdmlmOworc3RydWN0IHNrX2J1ZmY7CitzdHJ1Y3QgaGlmX2luZF9yeDsKKwordm9pZCB3Znhf
cnhfY2Ioc3RydWN0IHdmeF92aWYgKnd2aWYsCisJICAgICAgIGNvbnN0IHN0cnVjdCBoaWZfaW5k
X3J4ICphcmcsIHN0cnVjdCBza19idWZmICpza2IpOworCisjZW5kaWYKLS0gCjIuMjkuMgoK
