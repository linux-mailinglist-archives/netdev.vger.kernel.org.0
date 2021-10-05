Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34AC2422958
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 15:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235297AbhJEN6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 09:58:07 -0400
Received: from mail-dm3nam07on2073.outbound.protection.outlook.com ([40.107.95.73]:28128
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235482AbhJEN5R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 09:57:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aY4aAuEbOUnPW9g7ZStgncAM08S1x1IeCTTJpf7pftRA9/CFSolJ+Z8XhdIYfp6TG3CWhml70eBx/SsG+Wg6LKBZ2x77uAIV1lqKriMLxEY8ETDxfts37zGCanQ3dVJSb9oV9SlU8aeDmc2zHjxVPYIOyWUe4vRGLM8deLy5MOu+9e0kZ+QD4hDq3emyrietWPowQKJhZE29LvD+WkKIhHvILulg4VT0ah2NPgiuA/J2Se3PxItMPqiu8nZBUVjTxWAf7vo+y1LVdQjEURoRCUiirebaYtb1yWeHsfvrB2RCt2VfI1El7d6vsB3HZpEXiA86uyXKj/TuhABVb0qsnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/KGviaj5T1/EBEmLeuCf3Aukxd3aMsZE1V3/7dfMSrI=;
 b=TCvOPMuo17geQ1PlQoQWnKGoCuMUvK9lN7jL6RApSYqbtfAh7YQTQ77eGpmdp5afPVM8mJUGwJCZ3l/aG6mRy8lQ5P+7LH/9i2Zkj+oB6biISw0KSYPrSkSuLzFovlsm9IxgtNZC1zrxqmGPxnmxXUV2M4fW5p14HsjC/IP8xqyZSqD3xDjMQgQF0KphaOvPTJv86OEJwprz06E5UsNO8GGC8RcomznS3M2x3NPp2eRwS2UYdtKwQcSvlhPoqu4hzjPA/Ot9vNlcULD0Lh9kkTVJxvNf6aV4aPzCOY5VUfATmDSxhex71UyLOsp8YNO2sX4dN/Xlgq98Xzi6SvzLhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/KGviaj5T1/EBEmLeuCf3Aukxd3aMsZE1V3/7dfMSrI=;
 b=E436rg7ORNLLlmXNqFxZc/FM4K+DBzOw1oWWfX9+SUz5kgENvPvTLBDGf8V8mYu5lyHl1T5TY7ig+UAIW4Eksha1zxVpZ53dA7b1dvkQD+Eh8GDrdi6GLVCGA1jlp0AhrQS0teUzbf2q8mH7Vn2wVgAx0xLYFLCE5inLt2LLs8c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5643.namprd11.prod.outlook.com (2603:10b6:510:d5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Tue, 5 Oct
 2021 13:54:31 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4%9]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 13:54:31 +0000
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
Subject: [PATCH v8 04/24] wfx: add wfx.h
Date:   Tue,  5 Oct 2021 15:53:40 +0200
Message-Id: <20211005135400.788058-5-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135400.788058-1-Jerome.Pouiller@silabs.com>
References: <20211005135400.788058-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR3P189CA0084.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:b4::29) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR3P189CA0084.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:b4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 5 Oct 2021 13:54:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce365ae1-1d6e-4971-341e-08d98807a7d7
X-MS-TrafficTypeDiagnostic: PH0PR11MB5643:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR11MB5643FE9F6389A5DE989403EC93AF9@PH0PR11MB5643.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:773;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LtCFKTCv11pqj7HDlUEZg5LGfK3iqsCqeP+/HlMQ9oNR6nGaICo+Fwzl9aSvebXRmOMiCiUl3h+PokLQoRWdGEqwkQJ7nyBz7GlU2TTLb2n2tuFxXJedKiyjTOy7HaAyCJcURRdtuZlu35nAKe5VNpO6KVTWAhZSI+5cJhQe9c2GCrJ7pqrjDSyLOW8ugJoOKBmFvdhGtQedifWgv9//NE/MtZ/I3U1KlLsWarIIMOdUiUdK+zL1ZlbHn3/GcZ0Dw6J7SNyvzdGTnhzmudZ967seCvK/p2+Zsf1i8SyP19Xq85AmPkoK9Z+qJFHV5v7rXGtLRCCxu1xqnPmzV6ocpCWqrXpw+sxs57sP3Rr6s0uLqy2qYMkUxplQt+a960/r4RWimXv9ct4xqvGvYGeSTii5/AmSeEDwZqW0N+xMEhkwjkB+t19lHkMY41JL0HxZNQKOOhU2xsCgm4i4lyNrR8AY4HYXwHMBS9PaLx8XJ38zl7nNpgv4UsTE/QGvluTtmScd02pIF6mp75PuqBxnSTPAvqHhMcvHuAVoIXL2dlQq1DG//Qb93Q9iH+PhNtBs2AKcO5f/QqzaIDBVLbMYeZPbKL03zbaTROOfQl3WJqY3mmrkJGbrREmE3xibjdugjS6kLe56XQynE7GfHdQNQVJdKJCD5DZUvoHyw35KjkpDq/Ol9T2hJRbDJut8VI9M1kGJhq8Eam/7FEy2nVN4xA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7416002)(2616005)(956004)(54906003)(8936002)(66574015)(36756003)(1076003)(186003)(38100700002)(86362001)(6486002)(83380400001)(6916009)(5660300002)(38350700002)(66946007)(66476007)(66556008)(52116002)(7696005)(508600001)(6666004)(2906002)(316002)(4326008)(26005)(107886003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K3Nkb1ROaTdhL2tsL24wemdqeFpuSGc3VjN4YUlPejB0Y3lxL3JtUmhCY0xZ?=
 =?utf-8?B?dVZXUGJtbFptNklUdXQweFRmYmtObkF6WkE5ZlZPdjNkQjBkeWI2WHh5S3Y5?=
 =?utf-8?B?c0FaaVlIdHdRcWlha21NSnVUSGVuTTEvbWZaL3hQdGorMFBEZmQ0Z1JZMFdW?=
 =?utf-8?B?cVJRcWRxMGZFVitRSFMrVTBKbDcwM25tYVFHN3A2dmR2QXdEcnk5SzdBdkps?=
 =?utf-8?B?eVhyL1ZQVkpJWlp4d0c3MnZSV1NXOTNXMFVBTDJtalovMld2UGM1bm5VMlkw?=
 =?utf-8?B?NzNER0FxcUxDb294cDd1WC9XSGU5RlM2bDRqdy9rYmNITkMvNTE5YU1kdi9z?=
 =?utf-8?B?TS9sV0cvbnliejgyS1A3SDhiaDFSZlRxNHhaTktDS2plcUhWeXZQOTQwUXNh?=
 =?utf-8?B?b3hNanBBNS94YXpZMldYSHdUR1VPRnQzYnNERjFPVndzZWxiNDI3bEVuZGs4?=
 =?utf-8?B?SEZYeC9qVENlMHV5M0ZGWjlCNGg1cDRnbFVsYnhEclM1NEJ5a2wwTkU3SjBD?=
 =?utf-8?B?SW5mZjlpMVVMbHpZZ1VXYXJHdVlaZjJnc1pJYndYSVRtNTlNbkFZVlFCMmlP?=
 =?utf-8?B?SlNXUEU1L1p0ejBpQTFVRGFjdE5zWWpxU3lpUEhlbjNpMUdsNTMxdlhCdHFT?=
 =?utf-8?B?aVp6R2QzTDJac0xvSnpJOHRnb04rSWpnV0daU05rMG9yWHgzZlF2STYzaGVW?=
 =?utf-8?B?Qjh5ZC9lNW9raUlzc3YyNFY2Ukdyc3RZSXdWcHhJODdJUnpuTU5PdnM4TU1X?=
 =?utf-8?B?eEExaVF3YnFrd1FuTHQvZlQ5azZLcmdqRGkxRXpEWjFvQXV0Njk1ZHExUitS?=
 =?utf-8?B?R3ZkTDAyclpoSzl1UitlTTJHeXpQcEdhaTdSRWRzRlpSeGNzREVWQk5HVkxM?=
 =?utf-8?B?ZDNHcmdXUGlUOFArbk9rMFNUSFE3Q3pIWmRzakl4T2RLRUhFcGVUMjlqMzdx?=
 =?utf-8?B?QjNzOGpjSGhNSjlGQnN5WnR0T05EV0JHODMyUkM3bndGeTdxMzJ0UmZIQTQr?=
 =?utf-8?B?NXdkL29lQzA4QUxTWEdabFJFMlVqN1Vnb25JWWlUVUF5aUxWMElTTlFzOUk5?=
 =?utf-8?B?UUpsLzRMMkRVQlQzOG15NUlFd0tvVWVGcFdPQTE5QXdvYjZYRmRzeXpqVVNH?=
 =?utf-8?B?UFdMMzl6QmtxaHVvYVZmZ3ZETk1yb1hRYXhIZTRyK2VNYzFaRXNpME1Jc1hW?=
 =?utf-8?B?RHlqYjlxaFhNcFJLWXNKWEh6N3Uwa0g1N1llemNWRnFXcWVqZGx1VTdYZzBJ?=
 =?utf-8?B?NWRJSVFiU1JyOThEbjlGUHNkZWxsbDdlNlFZTm9QcE4yT0JKUUo5Yk0vUDJa?=
 =?utf-8?B?cFc3azVkTTR4WjZLT2tPNzVNb1g0aXdOdTUxZmpXQ1d4SU5Ha2pPZnZlcVVm?=
 =?utf-8?B?dXJnUmNqejNPUFMyT0w5TDl1TUZyQnBteUZWazJhblYxSmFyTGpoaTJTY1RK?=
 =?utf-8?B?RWs2MzE4ZVJVQ1hNRGtZQXJEb2ZLYVo2WDloWlQ4emRRZU5uaXRob1RCWGI2?=
 =?utf-8?B?ejJCbnczSEJyQVhEMXpnVXlBYzZEVWFITW1hTlRwVnBQQXg4S3FjbDRXQ3dW?=
 =?utf-8?B?TzREbVZpMlVnTXhzTHVJdERBSkkxNVJLZitXOVIwTFVUdW9kdm1rRE5NSGxo?=
 =?utf-8?B?eTVWRTA5NFlRNjJYb09RZzNkSU5FSU9PYnR6SHR2YVdpcmtUNER5WlNSbEoy?=
 =?utf-8?B?OGJTRDRsMkVGZEUwRmxhNTREN2FQTjlObEt3MUdzNzRReFd5ejJoZWRYWXhP?=
 =?utf-8?Q?KyHMu7dCYxoZTjxzcdW7dft6Z5sKIaGjS44s2hG?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce365ae1-1d6e-4971-341e-08d98807a7d7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 13:54:31.3037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rl9bsCKlfooKmRzG+mPYVc5QOkQs0WFs7GcrtbY61xbSu5sOE0SkCiRSSHshQhLvkGRzmfjx0wMn+t6B5iKmGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5643
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
PgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvd2Z4LmggfCAxNjMgKysrKysr
KysrKysrKysrKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAxNjMgaW5zZXJ0aW9ucygrKQog
Y3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvd2Z4LmgK
CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L3dmeC5oIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC93ZnguaApuZXcgZmlsZSBtb2RlIDEwMDY0NApp
bmRleCAwMDAwMDAwMDAwMDAuLjg0ZjVlZjhlZDA2OAotLS0gL2Rldi9udWxsCisrKyBiL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvd2Z4LmgKQEAgLTAsMCArMSwxNjMgQEAKKy8qIFNQ
RFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkgKi8KKy8qCisgKiBDb21tb24gcHJp
dmF0ZSBkYXRhLgorICoKKyAqIENvcHlyaWdodCAoYykgMjAxNy0yMDIwLCBTaWxpY29uIExhYm9y
YXRvcmllcywgSW5jLgorICogQ29weXJpZ2h0IChjKSAyMDEwLCBTVC1Fcmljc3NvbgorICogQ29w
eXJpZ2h0IChjKSAyMDA2LCBNaWNoYWVsIFd1IDxmbGFtaW5naWNlQHNvdXJtaWxrLm5ldD4KKyAq
IENvcHlyaWdodCAyMDA0LTIwMDYgSmVhbi1CYXB0aXN0ZSBOb3RlIDxqYm5vdGVAZ21haWwuY29t
PiwgZXQgYWwuCisgKi8KKyNpZm5kZWYgV0ZYX0gKKyNkZWZpbmUgV0ZYX0gKKworI2luY2x1ZGUg
PGxpbnV4L2NvbXBsZXRpb24uaD4KKyNpbmNsdWRlIDxsaW51eC93b3JrcXVldWUuaD4KKyNpbmNs
dWRlIDxsaW51eC9tdXRleC5oPgorI2luY2x1ZGUgPGxpbnV4L25vc3BlYy5oPgorI2luY2x1ZGUg
PG5ldC9tYWM4MDIxMS5oPgorCisjaW5jbHVkZSAiYmguaCIKKyNpbmNsdWRlICJkYXRhX3R4Lmgi
CisjaW5jbHVkZSAibWFpbi5oIgorI2luY2x1ZGUgInF1ZXVlLmgiCisjaW5jbHVkZSAiaGlmX3R4
LmgiCisKKyNkZWZpbmUgVVNFQ19QRVJfVFhPUCAzMiAvKiBzZWUgc3RydWN0IGllZWU4MDIxMV90
eF9xdWV1ZV9wYXJhbXMgKi8KKyNkZWZpbmUgVVNFQ19QRVJfVFUgMTAyNAorCitzdHJ1Y3Qgd2Z4
X2h3YnVzX29wczsKKworc3RydWN0IHdmeF9kZXYgeworCXN0cnVjdCB3ZnhfcGxhdGZvcm1fZGF0
YSBwZGF0YTsKKwlzdHJ1Y3QgZGV2aWNlCQkqZGV2OworCXN0cnVjdCBpZWVlODAyMTFfaHcJKmh3
OworCXN0cnVjdCBpZWVlODAyMTFfdmlmCSp2aWZbMl07CisJc3RydWN0IG1hY19hZGRyZXNzCWFk
ZHJlc3Nlc1syXTsKKwljb25zdCBzdHJ1Y3Qgd2Z4X2h3YnVzX29wcyAqaHdidXNfb3BzOworCXZv
aWQJCQkqaHdidXNfcHJpdjsKKworCXU4CQkJa2V5c2V0OworCXN0cnVjdCBjb21wbGV0aW9uCWZp
cm13YXJlX3JlYWR5OworCXN0cnVjdCB3ZnhfaGlmX2luZF9zdGFydHVwIGh3X2NhcHM7CisJc3Ry
dWN0IHdmeF9oaWYJCWhpZjsKKwlzdHJ1Y3QgZGVsYXllZF93b3JrCWNvb2xpbmdfdGltZW91dF93
b3JrOworCWJvb2wJCQlwb2xsX2lycTsKKwlib29sCQkJY2hpcF9mcm96ZW47CisJc3RydWN0IG11
dGV4CQljb25mX211dGV4OworCisJc3RydWN0IHdmeF9oaWZfY21kCWhpZl9jbWQ7CisJc3RydWN0
IHNrX2J1ZmZfaGVhZAl0eF9wZW5kaW5nOworCXdhaXRfcXVldWVfaGVhZF90CXR4X2RlcXVldWU7
CisJYXRvbWljX3QJCXR4X2xvY2s7CisKKwlhdG9taWNfdAkJcGFja2V0X2lkOworCXUzMgkJCWtl
eV9tYXA7CisKKwlzdHJ1Y3Qgd2Z4X2hpZl9yeF9zdGF0cwlyeF9zdGF0czsKKwlzdHJ1Y3QgbXV0
ZXgJCXJ4X3N0YXRzX2xvY2s7CisJc3RydWN0IHdmeF9oaWZfdHhfcG93ZXJfbG9vcF9pbmZvIHR4
X3Bvd2VyX2xvb3BfaW5mbzsKKwlzdHJ1Y3QgbXV0ZXgJCXR4X3Bvd2VyX2xvb3BfaW5mb19sb2Nr
OworfTsKKworc3RydWN0IHdmeF92aWYgeworCXN0cnVjdCB3ZnhfZGV2CQkqd2RldjsKKwlzdHJ1
Y3QgaWVlZTgwMjExX3ZpZgkqdmlmOworCXN0cnVjdCBpZWVlODAyMTFfY2hhbm5lbCAqY2hhbm5l
bDsKKwlpbnQJCQlpZDsKKworCXUzMgkJCWxpbmtfaWRfbWFwOworCisJYm9vbAkJCWFmdGVyX2R0
aW1fdHhfYWxsb3dlZDsKKwlib29sCQkJam9pbl9pbl9wcm9ncmVzczsKKworCXN0cnVjdCBkZWxh
eWVkX3dvcmsJYmVhY29uX2xvc3Nfd29yazsKKworCXN0cnVjdCB3ZnhfcXVldWUJdHhfcXVldWVb
NF07CisJc3RydWN0IHdmeF90eF9wb2xpY3lfY2FjaGUgdHhfcG9saWN5X2NhY2hlOworCXN0cnVj
dCB3b3JrX3N0cnVjdAl0eF9wb2xpY3lfdXBsb2FkX3dvcms7CisKKwlzdHJ1Y3Qgd29ya19zdHJ1
Y3QJdXBkYXRlX3RpbV93b3JrOworCisJdW5zaWduZWQgbG9uZwkJdWFwc2RfbWFzazsKKworCS8q
IGF2b2lkIHNvbWUgb3BlcmF0aW9ucyBpbiBwYXJhbGxlbCB3aXRoIHNjYW4gKi8KKwlzdHJ1Y3Qg
bXV0ZXgJCXNjYW5fbG9jazsKKwlzdHJ1Y3Qgd29ya19zdHJ1Y3QJc2Nhbl93b3JrOworCXN0cnVj
dCBjb21wbGV0aW9uCXNjYW5fY29tcGxldGU7CisJaW50CQkJc2Nhbl9uYl9jaGFuX2RvbmU7CisJ
Ym9vbAkJCXNjYW5fYWJvcnQ7CisJc3RydWN0IGllZWU4MDIxMV9zY2FuX3JlcXVlc3QgKnNjYW5f
cmVxOworCisJc3RydWN0IGNvbXBsZXRpb24Jc2V0X3BtX21vZGVfY29tcGxldGU7Cit9OworCitz
dGF0aWMgaW5saW5lIHN0cnVjdCB3ZnhfdmlmICp3ZGV2X3RvX3d2aWYoc3RydWN0IHdmeF9kZXYg
KndkZXYsIGludCB2aWZfaWQpCit7CisJaWYgKHZpZl9pZCA+PSBBUlJBWV9TSVpFKHdkZXYtPnZp
ZikpIHsKKwkJZGV2X2RiZyh3ZGV2LT5kZXYsICJyZXF1ZXN0aW5nIG5vbi1leGlzdGVudCB2aWY6
ICVkXG4iLCB2aWZfaWQpOworCQlyZXR1cm4gTlVMTDsKKwl9CisJdmlmX2lkID0gYXJyYXlfaW5k
ZXhfbm9zcGVjKHZpZl9pZCwgQVJSQVlfU0laRSh3ZGV2LT52aWYpKTsKKwlpZiAoIXdkZXYtPnZp
Zlt2aWZfaWRdKQorCQlyZXR1cm4gTlVMTDsKKwlyZXR1cm4gKHN0cnVjdCB3ZnhfdmlmICopd2Rl
di0+dmlmW3ZpZl9pZF0tPmRydl9wcml2OworfQorCitzdGF0aWMgaW5saW5lIHN0cnVjdCB3Znhf
dmlmICp3dmlmX2l0ZXJhdGUoc3RydWN0IHdmeF9kZXYgKndkZXYsCisJCQkJCSAgIHN0cnVjdCB3
ZnhfdmlmICpjdXIpCit7CisJaW50IGk7CisJaW50IG1hcmsgPSAwOworCXN0cnVjdCB3Znhfdmlm
ICp0bXA7CisKKwlpZiAoIWN1cikKKwkJbWFyayA9IDE7CisJZm9yIChpID0gMDsgaSA8IEFSUkFZ
X1NJWkUod2Rldi0+dmlmKTsgaSsrKSB7CisJCXRtcCA9IHdkZXZfdG9fd3ZpZih3ZGV2LCBpKTsK
KwkJaWYgKG1hcmsgJiYgdG1wKQorCQkJcmV0dXJuIHRtcDsKKwkJaWYgKHRtcCA9PSBjdXIpCisJ
CQltYXJrID0gMTsKKwl9CisJcmV0dXJuIE5VTEw7Cit9CisKK3N0YXRpYyBpbmxpbmUgaW50IHd2
aWZfY291bnQoc3RydWN0IHdmeF9kZXYgKndkZXYpCit7CisJaW50IGk7CisJaW50IHJldCA9IDA7
CisJc3RydWN0IHdmeF92aWYgKnd2aWY7CisKKwlmb3IgKGkgPSAwOyBpIDwgQVJSQVlfU0laRSh3
ZGV2LT52aWYpOyBpKyspIHsKKwkJd3ZpZiA9IHdkZXZfdG9fd3ZpZih3ZGV2LCBpKTsKKwkJaWYg
KHd2aWYpCisJCQlyZXQrKzsKKwl9CisJcmV0dXJuIHJldDsKK30KKworc3RhdGljIGlubGluZSB2
b2lkIG1lbXJldmVyc2UodTggKnNyYywgdTggbGVuZ3RoKQoreworCXU4ICpsbyA9IHNyYzsKKwl1
OCAqaGkgPSBzcmMgKyBsZW5ndGggLSAxOworCXU4IHN3YXA7CisKKwl3aGlsZSAobG8gPCBoaSkg
eworCQlzd2FwID0gKmxvOworCQkqbG8rKyA9ICpoaTsKKwkJKmhpLS0gPSBzd2FwOworCX0KK30K
Kworc3RhdGljIGlubGluZSBpbnQgbWVtemNtcCh2b2lkICpzcmMsIHVuc2lnbmVkIGludCBzaXpl
KQoreworCXU4ICpidWYgPSBzcmM7CisKKwlpZiAoIXNpemUpCisJCXJldHVybiAwOworCWlmICgq
YnVmKQorCQlyZXR1cm4gMTsKKwlyZXR1cm4gbWVtY21wKGJ1ZiwgYnVmICsgMSwgc2l6ZSAtIDEp
OworfQorCisjZW5kaWYKLS0gCjIuMzMuMAoK
