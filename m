Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E6C48B341
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344092AbiAKRQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:16:04 -0500
Received: from mail-dm6nam08on2088.outbound.protection.outlook.com ([40.107.102.88]:54880
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344083AbiAKRPa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 12:15:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H66fWT+z7L7rQiGvsf5uD+12aaFh5xPLCJ003QTwqgLCHHDU1gfca4S4bJymq1OwjJ4wKhHN1Qd6n/ceHcyjw4KgXBHvwQ/vDh4p2S+PpGlIhCGxDZ0/fZ8bONV53TSxf4mXg+FiujR5f4/kQfUvQ/tbXMNlGTZLbVw72zMCqb7gEH26xxQI4XoSl04jkg+kTrOWUzFiDpcd6PSjEtBcI/7gjXa+0LQTib5Cm1vHnnqoEVjehfRlo4itz9KwkMNydqXUzmtcZikn4svzUoXfl+EqMi0aA+PhDc1faVuVKV9qBsZMzj1rbRjEqxWLp/ok5jTyNbCMefCotpxhRNbIVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Laa+FpIvHKHjdSdPVWts6lBXNK06rPxwoCWe69GbX7w=;
 b=cZ5kXiOkIGT9Mf480jAE0NyBhOj9vSxBURMwzXl0WZLNTEumPUYI9pxiD5SYOj+Ygrx2M0Cl5sEpCnGnA+KvZ/nbXu5ry/PaSULVkuy7RoYPR1MNI5IiLuX0ucxK3pU8PQTiP5nY1dyEfgFe5BoBOjfgtsPDdraXiSLtbI2PVLgjsOpEgCsGZj7+DcEx7HMljvFAf9xh0cHNVXV9B/JWFS1pQXPzQzccNyB3eBx3gxVQH1j8lKfoZ1IiUOq0498JUmh55w3fBzPPnR2ZlH76N60jBNLzj76mAN69eFta6AakIH5x2Vy4G9Ks2d9l8yLJMctPNxNwHXfVrlv2++0taA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Laa+FpIvHKHjdSdPVWts6lBXNK06rPxwoCWe69GbX7w=;
 b=j9p8ep2rascBdDE45waMuUCFjEm3opUhAxhtk4Oqx/0riCZntnpLopLJGHP3Fh2NLOkRkfpIf0N7h/qJ8K2mQXtjrwAaFqB+266jvav1U7nLkV3pjkysbvcn4K7S1edqQ3cE7wgWk+JY+iozeH0CtzVssf3mR4uICWdHEBhzNE4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5626.namprd11.prod.outlook.com (2603:10b6:510:ee::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Tue, 11 Jan
 2022 17:15:28 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%6]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 17:15:28 +0000
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
Subject: [PATCH v9 16/24] wfx: add data_rx.c/data_rx.h
Date:   Tue, 11 Jan 2022 18:14:16 +0100
Message-Id: <20220111171424.862764-17-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220111171424.862764-1-Jerome.Pouiller@silabs.com>
References: <20220111171424.862764-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN1PR12CA0099.namprd12.prod.outlook.com
 (2603:10b6:802:21::34) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 469599b6-2308-4bb0-6234-08d9d525f6ad
X-MS-TrafficTypeDiagnostic: PH0PR11MB5626:EE_
X-Microsoft-Antispam-PRVS: <PH0PR11MB562688604647339608046EB493519@PH0PR11MB5626.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I9D0n3tdHc+ykpzBdGXADWpQImsdyeUG2EyAzghxVS+7KFmZ4waOJS0KGRQ9CBL5kIIsi+lr9jTscUqyi4bAdYa8duJvlptscB3dU53UhlpIO1cqsXpw8ho+7dnxJjRnpiRf+y7Nr7aK0mRQA6ePxlrOJLBRg/fjBxUa9OvTa4OxbRcboFwjScqEYcEbd9N1maKa7naIsmCqq4b5cWDZuJAJOnDLRTWUUyvnBivQMz9iv+TwEbmRt3ZH3qfNI1xHV5y/01WK1+2cRINsqu52BvTeE+5jGn/Ia9YV+9FOF5UvSXbPEq43kmoIWNS2++0Fnb1EGwD2VzWLYVEqXWauMFfy/KTuEHyMsiIx5wVeHmFM+bqF8g3Ip+sAAjtJSqEG9asA791f1refqkOm3491PlaN6PGws8H48oVVI4mtHdF4bYSZQ9yDx1UKthA0YeOYKkvCHuE+YrZfaCDOFyZeeSkqNa0QbXq3ATCb3+StEgYSoUQJWJM9p1GI3qTjeRYGeyQEX40YLvzdKq0WJl8xgaesRaPXNAqHZVaAJamJJX3QJsr+vB+uFNNepx/0ysxIL1m5FXiU3kV6JkZocq14zmbYyvyNnsTsci7BDb4TSktzpzQLrJ+3MGOC9/cbcSHhd4fhPYLJNGfa48IC0bui0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(1076003)(83380400001)(38100700002)(54906003)(86362001)(8676002)(186003)(508600001)(6512007)(6666004)(8936002)(6916009)(6506007)(36756003)(2616005)(6486002)(52116002)(2906002)(107886003)(4326008)(316002)(5660300002)(7416002)(66556008)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MnlSSTRZMnpEcFVLTkVoTmMzcko2ZFR4S0xVcUJBbk5IQTJua0pyMXpjL3dr?=
 =?utf-8?B?eVM3VHZ5a29lSkxOV015TzZoRzkyMTU3bGMwVGE0aGduL3FUM1YyWForRG5Y?=
 =?utf-8?B?Um1BQjhLRWE4V1d0a0ZBMWQzRjV0WGJDWWxEWDRsME5OL2FQc2hiRUoxSHU1?=
 =?utf-8?B?M2p4NlByVlUzK1BlSzdjNjJkZlRpYXcwU04wdXFzdmJOMDU4SmJCdCtRam1R?=
 =?utf-8?B?TVY1Z1N1VGd0VFlnSEVqeElKTXYwQ1JjVGpZaVhLYUtQUGQzeGJKZ1FUOWV5?=
 =?utf-8?B?TnphR09nbm90LzZBK3Q5S3BJSmRXenBMeUFONnJyd0xLakdEUzM3NXc3RG5h?=
 =?utf-8?B?a0NZMFJYaEhHUVJxRU1wWUNLZXVBM0tGT1RYWWtEOGxINmJCK3dOT0x6b0h6?=
 =?utf-8?B?dDM2dW5meUlSTENYK05VOVhzekN3SVZ3UzVHWXRxenNmT3A3OXBja0N2TkZu?=
 =?utf-8?B?QWdZUUlqbFVCMTlTSE0zYVNzbDFHOXRvbGx4ZWZmTFY3QjAwL0d1eGhGUVVR?=
 =?utf-8?B?NXJzRUdZUU9pcWwwd2Zrc0pSdnhIdTlObnFORXJ1OXY4WUF5amJCNzRtalZz?=
 =?utf-8?B?RFUzTW9tMk42dUNEN01vOHpsMU1vYUUrcEFsalJVOHhhVlBNRDdicEVZUUdJ?=
 =?utf-8?B?blpwYTBGKytZNHdVTENIK25nUjhiaHNyS3lUV3NqMk5IZFNhcWxwT0JLdWVL?=
 =?utf-8?B?dFlBOVV2NDFwbEVTbThydllPSGNlUzZSSmJXVWZydHJZNUZ4dmRpOEdaU3hs?=
 =?utf-8?B?UjdvdEh0NFVjL1V2aHh0ZzR5T2x6Y3hTUVBRMXRsWWlleDBWMlRqbnFJdTYy?=
 =?utf-8?B?VVhINGtrRTRwZUZtKzU1YkYrdE9DRW9JZVZkQStqUDVpejN0SDF1eGMvR1lq?=
 =?utf-8?B?MlpEb2QwVENkdjRKTzQrQ09ON1FDVjNpTzZzTWdDYktJVUlBTGxJNW5WalJz?=
 =?utf-8?B?NXNTekR2Sm5FODZVWmJmeE56bU51NndyaDVwYnZib1kxbXJBN1VreU4vekFm?=
 =?utf-8?B?QmxSVVFJdEs0Y3JIa05nYlFiM0RwU0E2cE5LekYrVWtqVXIxaDdmZU0waVNB?=
 =?utf-8?B?c01NR1ByMlpKUEx2RWJHYlJhbWM1VXhmcU5UYWVUYzEwOXZjblRTQ21Ld2lZ?=
 =?utf-8?B?N1lWckZhbVRCNlZGR3Jtc09oc3pxOFEzQzNaOCtjSDB2ZkwrNklRUUR1R3ZE?=
 =?utf-8?B?M3JZa1ovRzltVGtYMTlsZXMwR1lrZ2RMQUJwSEl4cU50MzhhcUFTNEM0RThm?=
 =?utf-8?B?VjBYblVjbmptVnpCT1JidEtOUGh4WGF0UnRwQ2pwbndhb3l4ZmZuQVBIcjIz?=
 =?utf-8?B?WlprL0tRUEhuLzhOWkp0Zno2Um40VWRVWmpaYlNlMVNKMXVueFE1azVROUJn?=
 =?utf-8?B?bDFsVDJGK1o5RjZscFFOcXphM2FtSlUzOWJCY09pbGU0djRnVWcra2xMR0JG?=
 =?utf-8?B?MU9FbThVdHRHbyt5TE1XalBGM25rL3V2ajlQakRBSjQycjRUV2hTbnFlWDlx?=
 =?utf-8?B?YWhtcm4yUHVLaWg5cXloYVFCS0lNU1R6REhadldDUXpLb2ZzbkJ2TUM2MVMz?=
 =?utf-8?B?Y0UrNlE4SExwL3B0OEVCckUxQWFCR29HTSttWlV6Q0FLVjdTbk5sZVlmWFl4?=
 =?utf-8?B?eDh4YmIyZDZza0tQMXNXMkpMbU5HK29CVlN4ZkFNNWJjWDVRWlBMRSsrWEVS?=
 =?utf-8?B?NEF2V1M1WEpVaUs0aXJSaGNSa1d4TWg1RkJNY050ZEJiT3IzazlWT1prSndH?=
 =?utf-8?B?L0xLWW9ZeEloOEFvTkZaRjRaL2dWdGRwdFNDQ2VsbDdtdUMvRXFPY2hKeEZi?=
 =?utf-8?B?T3VjZ3FPaFlVaDVwN0U1bXUzVGxoSlk2RzVqYTRiM0tvOWJxSzMxV1ppeWhT?=
 =?utf-8?B?Y1JITVphUmRQK1JKdDlSWE1uelpXTTVidElxdHptbmtSQ1BaYldidkQ0THZO?=
 =?utf-8?B?SHZzTEJScHBrZ3VkdndVcEtCR0ZUYmlwU0hLYm1PdStLRFVRRG92Y1JNSXFP?=
 =?utf-8?B?dUYzSFJ3UndjMkRTVzczaWhvNkNBTHRSYVZaeWs1UjNQQm5rN2l1MTBHTmxZ?=
 =?utf-8?B?bk1nb2dGRHhYU0ZQVVZhc2JIcCt3c2tQbVhFSjdnR0hFOHZkWXVhNEp1Rmtw?=
 =?utf-8?B?dlpPbHNVWHgzT1FNNWJITkN2ZXFkb3hNd0xFeXVuT2hzSENqNURpR2F4QUVZ?=
 =?utf-8?B?eTZZQkg0dDd0ajM4TE9PK2JBZGtWR0dwZCtZdXUvNEtEVHArZGdOUTNHczFE?=
 =?utf-8?Q?PgbYXg9VHuVDmxgvKg2Vzx6lNwiUQbDSyfYJOe58kU=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 469599b6-2308-4bb0-6234-08d9d525f6ad
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 17:15:28.1824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e48AqxcoyFEOGQtGD8EVq0jCPWuN7KkaY2U8KW3EXTp1U0M4OWdqVutkANg/dJy+QbPWGjLMUVh0oenPVsM/UQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5626
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
PgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0YV9yeC5jIHwgOTIgKysr
KysrKysrKysrKysrKysrKysrKysKIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0
YV9yeC5oIHwgMTcgKysrKysKIDIgZmlsZXMgY2hhbmdlZCwgMTA5IGluc2VydGlvbnMoKykKIGNy
ZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L2RhdGFfcngu
YwogY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0
YV9yeC5oCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9kYXRh
X3J4LmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L2RhdGFfcnguYwpuZXcgZmls
ZSBtb2RlIDEwMDY0NAppbmRleCAwMDAwMDAwMDAwMDAuLmE0YjVmZmUxNThlNAotLS0gL2Rldi9u
dWxsCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0YV9yeC5jCkBAIC0w
LDAgKzEsOTIgQEAKKy8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkKKy8q
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
ZiwgY29uc3Qgc3RydWN0IHdmeF9oaWZfaW5kX3J4ICphcmcsIHN0cnVjdCBza19idWZmICpza2Ip
Cit7CisJc3RydWN0IGllZWU4MDIxMV9yeF9zdGF0dXMgKmhkciA9IElFRUU4MDIxMV9TS0JfUlhD
Qihza2IpOworCXN0cnVjdCBpZWVlODAyMTFfaGRyICpmcmFtZSA9IChzdHJ1Y3QgaWVlZTgwMjEx
X2hkciAqKXNrYi0+ZGF0YTsKKwlzdHJ1Y3QgaWVlZTgwMjExX21nbXQgKm1nbXQgPSAoc3RydWN0
IGllZWU4MDIxMV9tZ210ICopc2tiLT5kYXRhOworCisJbWVtc2V0KGhkciwgMCwgc2l6ZW9mKCpo
ZHIpKTsKKworCWlmIChhcmctPnN0YXR1cyA9PSBISUZfU1RBVFVTX1JYX0ZBSUxfTUlDKQorCQlo
ZHItPmZsYWcgfD0gUlhfRkxBR19NTUlDX0VSUk9SIHwgUlhfRkxBR19JVl9TVFJJUFBFRDsKKwll
bHNlIGlmIChhcmctPnN0YXR1cykKKwkJZ290byBkcm9wOworCisJaWYgKHNrYi0+bGVuIDwgc2l6
ZW9mKHN0cnVjdCBpZWVlODAyMTFfcHNwb2xsKSkgeworCQlkZXZfd2Fybih3dmlmLT53ZGV2LT5k
ZXYsICJtYWxmb3JtZWQgU0RVIHJlY2VpdmVkXG4iKTsKKwkJZ290byBkcm9wOworCX0KKworCWhk
ci0+YmFuZCA9IE5MODAyMTFfQkFORF8yR0haOworCWhkci0+ZnJlcSA9IGllZWU4MDIxMV9jaGFu
bmVsX3RvX2ZyZXF1ZW5jeShhcmctPmNoYW5uZWxfbnVtYmVyLCBoZHItPmJhbmQpOworCisJaWYg
KGFyZy0+cnhlZF9yYXRlID49IDE0KSB7CisJCWhkci0+ZW5jb2RpbmcgPSBSWF9FTkNfSFQ7CisJ
CWhkci0+cmF0ZV9pZHggPSBhcmctPnJ4ZWRfcmF0ZSAtIDE0OworCX0gZWxzZSBpZiAoYXJnLT5y
eGVkX3JhdGUgPj0gNCkgeworCQloZHItPnJhdGVfaWR4ID0gYXJnLT5yeGVkX3JhdGUgLSAyOwor
CX0gZWxzZSB7CisJCWhkci0+cmF0ZV9pZHggPSBhcmctPnJ4ZWRfcmF0ZTsKKwl9CisKKwlpZiAo
IWFyZy0+cmNwaV9yc3NpKSB7CisJCWhkci0+ZmxhZyB8PSBSWF9GTEFHX05PX1NJR05BTF9WQUw7
CisJCWRldl9pbmZvKHd2aWYtPndkZXYtPmRldiwgInJlY2VpdmVkIGZyYW1lIHdpdGhvdXQgUlNT
SSBkYXRhXG4iKTsKKwl9CisJaGRyLT5zaWduYWwgPSBhcmctPnJjcGlfcnNzaSAvIDIgLSAxMTA7
CisJaGRyLT5hbnRlbm5hID0gMDsKKworCWlmIChhcmctPmVuY3J5cCkKKwkJaGRyLT5mbGFnIHw9
IFJYX0ZMQUdfREVDUllQVEVEOworCisJLyogQmxvY2sgYWNrIG5lZ290aWF0aW9uIGlzIG9mZmxv
YWRlZCBieSB0aGUgZmlybXdhcmUuIEhvd2V2ZXIsIHJlLW9yZGVyaW5nIG11c3QgYmUgZG9uZSBi
eQorCSAqIHRoZSBtYWM4MDIxMS4KKwkgKi8KKwlpZiAoaWVlZTgwMjExX2lzX2FjdGlvbihmcmFt
ZS0+ZnJhbWVfY29udHJvbCkgJiYKKwkgICAgbWdtdC0+dS5hY3Rpb24uY2F0ZWdvcnkgPT0gV0xB
Tl9DQVRFR09SWV9CQUNLICYmCisJICAgIHNrYi0+bGVuID4gSUVFRTgwMjExX01JTl9BQ1RJT05f
U0laRSkgeworCQl3ZnhfcnhfaGFuZGxlX2JhKHd2aWYsIG1nbXQpOworCQlnb3RvIGRyb3A7CisJ
fQorCisJaWVlZTgwMjExX3J4X2lycXNhZmUod3ZpZi0+d2Rldi0+aHcsIHNrYik7CisJcmV0dXJu
OworCitkcm9wOgorCWRldl9rZnJlZV9za2Ioc2tiKTsKK30KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0YV9yeC5oIGIvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
c2lsYWJzL3dmeC9kYXRhX3J4LmgKbmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMDAw
MDAwLi5jZjcwOGYxNmQ2MDIKLS0tIC9kZXYvbnVsbAorKysgYi9kcml2ZXJzL25ldC93aXJlbGVz
cy9zaWxhYnMvd2Z4L2RhdGFfcnguaApAQCAtMCwwICsxLDE3IEBACisvKiBTUERYLUxpY2Vuc2Ut
SWRlbnRpZmllcjogR1BMLTIuMC1vbmx5ICovCisvKgorICogRGF0YSByZWNlaXZpbmcgaW1wbGVt
ZW50YXRpb24uCisgKgorICogQ29weXJpZ2h0IChjKSAyMDE3LTIwMjAsIFNpbGljb24gTGFib3Jh
dG9yaWVzLCBJbmMuCisgKiBDb3B5cmlnaHQgKGMpIDIwMTAsIFNULUVyaWNzc29uCisgKi8KKyNp
Zm5kZWYgV0ZYX0RBVEFfUlhfSAorI2RlZmluZSBXRlhfREFUQV9SWF9ICisKK3N0cnVjdCB3Znhf
dmlmOworc3RydWN0IHNrX2J1ZmY7CitzdHJ1Y3Qgd2Z4X2hpZl9pbmRfcng7CisKK3ZvaWQgd2Z4
X3J4X2NiKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBjb25zdCBzdHJ1Y3Qgd2Z4X2hpZl9pbmRfcngg
KmFyZywgc3RydWN0IHNrX2J1ZmYgKnNrYik7CisKKyNlbmRpZgotLSAKMi4zNC4xCgo=
