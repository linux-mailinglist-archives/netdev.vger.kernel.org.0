Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212532E1EC3
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 16:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728958AbgLWPlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 10:41:08 -0500
Received: from mail-mw2nam12on2063.outbound.protection.outlook.com ([40.107.244.63]:15105
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728805AbgLWPlE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 10:41:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sc453uawImG8j30hLI3l5kFLXQTNQZKQR5YvmNfAILNdMAf+stqukEgYhM+V1c3NnfHjXsYoEfR1EPfZuXs+ABN5Ii6qLIuCEKYRqwS+VfIG7LdSmkuXMbZpHLEvmCCVKSXoTj33q5K2Vb/tmFQQ1tM8Dye1CJZD1F/Oz1o/gj4tK+hdLRmRQIuqVubcvLHHwrbx7Am4gaDb9O2I7/nWmSEdbaCcTb99p//8iL8yKfneYAh0u4ILD++8Vv2CEq49m2lIUxyh7Ah126d3H9DvUHE52EXasY2+c2qe2WLanMwsQipmIfArjrvFZIqMbNoly0+c+GYy1rIORHpzjgMvZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BoaSuLSXWkS6RYyIUCKFmHqvAKLzRi7Zxr/nEwrquXc=;
 b=Ifxquje1cuhNgoAzytR057jp8g/ZhT5Hic3thmibcxQIY6gdxnbfpuBdyQwUZuRbVj/Rv/dK8l7YGq0EhjF61TlMssSX7j3r23rXLCmfopk37OOafKRPfcxfAdho7axzM3A4vP3Gh2BSQfTUcUytQjuFDP9a2Jm0o5wo5hniX2umtdiWeAektPF/xl3MNcsR5RridKGR+/Fd07a2I4ATXFhKjs/CTlJVDLpeqNMgjiQRzss/20X1oT9xLnEAyJ0FnJzUn3WRb48SSYWhT9ISqjSER3Do+GJo7HEcrHjXu8GPqJkTqqcLRXekhFpphjlYtimPI0XdaRwE40Y7W5EQsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BoaSuLSXWkS6RYyIUCKFmHqvAKLzRi7Zxr/nEwrquXc=;
 b=MJ+oxX6+VUrNq332VH96SRHPPqkqs7aQiatBzwPyHQFNBmfEs6LZ6NlEEE3mvDhkXuLPFOkj2WC2Ps4ufMgCVwi4fJWi6HGRPtQGfpgQ1QcgUFhHQz7Ebe3Svh9NbzSBexMvDrLEd2oH/anKkOTm7FXiWE+UmBStqCHulDc1zmU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2815.namprd11.prod.outlook.com (2603:10b6:805:62::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Wed, 23 Dec
 2020 15:39:56 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::a989:f850:6736:97ca]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::a989:f850:6736:97ca%5]) with mapi id 15.20.3700.026; Wed, 23 Dec 2020
 15:39:56 +0000
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
Subject: [PATCH v4 06/24] wfx: add bus.h
Date:   Wed, 23 Dec 2020 16:39:07 +0100
Message-Id: <20201223153925.73742-7-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (82.67.86.106) by SA0PR12CA0024.namprd12.prod.outlook.com (2603:10b6:806:6f::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.27 via Frontend Transport; Wed, 23 Dec 2020 15:39:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 308fbd3e-93f9-4677-15d9-08d8a758fffc
X-MS-TrafficTypeDiagnostic: SN6PR11MB2815:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB281544B62E5A1513A29AEAC293DE0@SN6PR11MB2815.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:421;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kRAftRjJ0efC/DWwlJZDWHYD6MLj8Xvi3Co7ZtV+pNINvRNBLyxqZdhYXKJIB//5ZzxlIT40s+X7vS7MFJ3awLvlBHMdGJ2v5GY9RuhbPeDEIOL6B3uXJZyhouWKWzTa+X7gKI7X1vgVqE6RXf6AVxj6Cu9aaqgBUmqKqWsucGnOgZRabBBdFMs6wMgVLAIk8/bsEbWlFkHHbpQWrm+h027N7k+XHICKclRhnZ5VBJpCw8bw2XBHnpCEyBfA6yjVvw6G4Qwb3VqzdPgWhjM08n8YVe23QooBMGF7lzIZU9vJd3fj6CS4Hw8cjoG2iyz8ajUYDaFT8+Jw4C9ya3SxVrYIAFd1nzDNaTCNoZNONSVi0BQZI+Bwpfj5AIEFY1gAIZNce1af/WF4AJdeytjgEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(376002)(39850400004)(346002)(66574015)(478600001)(83380400001)(8676002)(186003)(2906002)(8936002)(26005)(52116002)(107886003)(16526019)(7696005)(66946007)(7416002)(6486002)(956004)(2616005)(54906003)(66476007)(316002)(4326008)(6666004)(36756003)(5660300002)(1076003)(86362001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OHIyRzJObXk1bE9QUmgrZ2dxNjFyNytBeDJZZDhmL1I5N0ZJRUw2YXlZMHQy?=
 =?utf-8?B?ZEFDbWRoaTN6bUdpV0FyRTF3Rmk1ejUyWHEzaFIzWS9hZHRqb0h1WHlyS0tL?=
 =?utf-8?B?aDVndTcwY09kN2JTWERySGdXQkdhQllXNVdDNEVKRnIwVmY5V3JEVGUyRGwx?=
 =?utf-8?B?bmlZdkdUc0hmZ1Fib2hUbDdaV0FBQkZpb04wS2lUbXJ3dGVFNkZGdjl1ekZY?=
 =?utf-8?B?YmgvVzVZZmgvNm9wOGRRUTdYN2xjSmRsMTdsNjM0MStlckZ3WFl4OCtLTi9z?=
 =?utf-8?B?eHZXNkZrMC8yWjUySGlPaGJIZmszQzNSV3ZOTC9iTklVQWViZ05NTzdZMXEy?=
 =?utf-8?B?TzlMU2xodEIrbDg3cG5rZ2cwc0dWektNdGpEVjltcDdOYy81ZWhCa1VtNzda?=
 =?utf-8?B?YkdDUEE1YkpHVXZ3R25rT0s4Y2NZNm1TeENBSnVSeHdhVzY3ampyYXBsU0Z0?=
 =?utf-8?B?TlNCa1lKYlFvYUpjNWFqMHZRRVZvMlpISnMwVW16dCtDWkxjdllMdTVyM1ow?=
 =?utf-8?B?SjliVUVsOW1RdjFZd0g2OExRZ0UxMkhzRWc2K1VzQWplRkc4cnNqYzBCbDZ5?=
 =?utf-8?B?K05lZmhIMW4yYmt6c0lMUVExdzhtc2FsUjlvVmI0ZDF0ckd1TFFLRFZhUE9v?=
 =?utf-8?B?bWl3dk5qd3ZXTTE2TmF1eVh6dVNOWXdpL3RqUldhelZEVEpxWHQ0Qmxwbjla?=
 =?utf-8?B?SWZKUzBCazVQaDlpMGltVWg0aGJWd2RaTCswK0Jid2RhSEludnk2bkJKVGhG?=
 =?utf-8?B?cklmcTVVRlpzNlhobDBCSVB0T3ZxYW1ESE12Q1JQMjBLYmd2UVZoYWJRUjZi?=
 =?utf-8?B?RzZYeXNQdkdFejdOT04xeHZUWHBQak9xcW9LVXpaYVd3d1c0TnpxSlRXMUl2?=
 =?utf-8?B?Zkd3TlYyQkpzQU1CRk1HS3JVbUpJa1Q4SHR4SUo2Z1kya3pSWkZpUmRqSHZB?=
 =?utf-8?B?YjJKRjBwNVY1T1RsSW1URUUvaGRMN0Vzd01JOW9QUWJnb3NjSzVlbnV4bVcy?=
 =?utf-8?B?aFZNWU5BMmdzV0F0QjFqcGVlblAxa2haV0tIdXpVL01GaUY1TFRXbEo5NUM1?=
 =?utf-8?B?dFhvQWJzak9uemdkaDlVZGduNHlNcGRabnlQcEFQS1RuWHNIRmNhRVZEUThI?=
 =?utf-8?B?eGU4UktXVWUzdkFHclBJUFhMaDlxNjRGM1d3dkd2cWVFeXF6VU5aRDZvZWVF?=
 =?utf-8?B?OVpSYUUzSkNsVm8zK2NpWnh2bDlZNDRySVcyUU5DOXJVTFRMZ1BkdVRrMlpy?=
 =?utf-8?B?cWdQRko1V3VZZTJVc0F5UHZFaXJOVHRGbThaY3ExeldEYmM5ZVhieDdaNHFD?=
 =?utf-8?Q?SSjerVpjsqfXR+rhqRuRCm97xqw/p3AMdE?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2020 15:39:56.5327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-Network-Message-Id: 308fbd3e-93f9-4677-15d9-08d8a758fffc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0KkMTvYRt8OwL5KEB3zssDFDHLMFw7On7pp+jjONTt+IUAUfeTF9TKgSEP+yscad7N0ADXVqiZuXiD5pK8vL4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2815
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
PgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvYnVzLmggfCAzOCArKysrKysr
KysrKysrKysrKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAzOCBpbnNlcnRpb25zKCspCiBj
cmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9idXMuaAoK
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvYnVzLmggYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L2J1cy5oCm5ldyBmaWxlIG1vZGUgMTAwNjQ0Cmlu
ZGV4IDAwMDAwMDAwMDAwMC4uY2EwNGIzZGE2MjA0Ci0tLSAvZGV2L251bGwKKysrIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9idXMuaApAQCAtMCwwICsxLDM4IEBACisvKiBTUERY
LUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5ICovCisvKgorICogQ29tbW9uIGJ1cyBh
YnN0cmFjdGlvbiBsYXllci4KKyAqCisgKiBDb3B5cmlnaHQgKGMpIDIwMTctMjAyMCwgU2lsaWNv
biBMYWJvcmF0b3JpZXMsIEluYy4KKyAqIENvcHlyaWdodCAoYykgMjAxMCwgU1QtRXJpY3Nzb24K
KyAqLworI2lmbmRlZiBXRlhfQlVTX0gKKyNkZWZpbmUgV0ZYX0JVU19ICisKKyNpbmNsdWRlIDxs
aW51eC9tbWMvc2Rpb19mdW5jLmg+CisjaW5jbHVkZSA8bGludXgvc3BpL3NwaS5oPgorCisjZGVm
aW5lIFdGWF9SRUdfQ09ORklHICAgICAgICAweDAKKyNkZWZpbmUgV0ZYX1JFR19DT05UUk9MICAg
ICAgIDB4MQorI2RlZmluZSBXRlhfUkVHX0lOX09VVF9RVUVVRSAgMHgyCisjZGVmaW5lIFdGWF9S
RUdfQUhCX0RQT1JUICAgICAweDMKKyNkZWZpbmUgV0ZYX1JFR19CQVNFX0FERFIgICAgIDB4NAor
I2RlZmluZSBXRlhfUkVHX1NSQU1fRFBPUlQgICAgMHg1CisjZGVmaW5lIFdGWF9SRUdfU0VUX0dF
Tl9SX1cgICAweDYKKyNkZWZpbmUgV0ZYX1JFR19GUkFNRV9PVVQgICAgIDB4NworCitzdHJ1Y3Qg
aHdidXNfb3BzIHsKKwlpbnQgKCpjb3B5X2Zyb21faW8pKHZvaWQgKmJ1c19wcml2LCB1bnNpZ25l
ZCBpbnQgYWRkciwKKwkJCSAgICB2b2lkICpkc3QsIHNpemVfdCBjb3VudCk7CisJaW50ICgqY29w
eV90b19pbykodm9pZCAqYnVzX3ByaXYsIHVuc2lnbmVkIGludCBhZGRyLAorCQkJICBjb25zdCB2
b2lkICpzcmMsIHNpemVfdCBjb3VudCk7CisJaW50ICgqaXJxX3N1YnNjcmliZSkodm9pZCAqYnVz
X3ByaXYpOworCWludCAoKmlycV91bnN1YnNjcmliZSkodm9pZCAqYnVzX3ByaXYpOworCXZvaWQg
KCpsb2NrKSh2b2lkICpidXNfcHJpdik7CisJdm9pZCAoKnVubG9jaykodm9pZCAqYnVzX3ByaXYp
OworCXNpemVfdCAoKmFsaWduX3NpemUpKHZvaWQgKmJ1c19wcml2LCBzaXplX3Qgc2l6ZSk7Cit9
OworCitleHRlcm4gc3RydWN0IHNkaW9fZHJpdmVyIHdmeF9zZGlvX2RyaXZlcjsKK2V4dGVybiBz
dHJ1Y3Qgc3BpX2RyaXZlciB3Znhfc3BpX2RyaXZlcjsKKworI2VuZGlmCi0tIAoyLjI5LjIKCg==
