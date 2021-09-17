Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2488940FBCA
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 17:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240993AbhIQPSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 11:18:06 -0400
Received: from mail-bn7nam10on2088.outbound.protection.outlook.com ([40.107.92.88]:46465
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343723AbhIQPQv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 11:16:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QfpU3TzlfSJQY/5GHZv9y6Desmm3yVLv8YqJ2u0hLlf//1Wc8XipRhqneNRSgMV7DKQ/Ev2YwGZd2exLXBQ3rnU2wFfZMP04wfgMZ7DDMhoDJPnpwlKvy7vl2tgYo40fwYr59P7X/RRrYLjMSnoUn0o4oK8rJAGjjL1lrt9i3s+gcgTTodfjzY7xjdX7poWLukHKjvxhE85v0cFjhRGEzlzqcH900Nop5u6dAtu9+cMiAfV5POICohcaAOr+oNMgV9peAmgilfOkLimuzboZ1Rg+fBtlymIxRXyo9sSDr1kc8KS6/ZHHKxMepmp4E3eiF/2Pj8ClgpnnXAA9uo6+Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=51XqWHJtByRQLPsnY3wtzpUPOfwDveF+8mA8Bal+JXA=;
 b=jBUeUWQ3h3tSELxfG3BxXxeT/KotJ+kFroiq8wpMW8o02nBdJ5vwJOMMcOzBdOGeJhnccsJTRIKRbdxqkSp3pmawSkccPD0g8Je60b8APpZxMbbV0Shyiyj4dLCFigdSg1AWGk24qxOxkcoysoO4IdoS880a+Fk2dH3lkGf+uIFSZ+zwsz+j4vNd3oXmhq6Ysyb306QSRhJ8xm7IT1uzOey1nvt9ymjgzP59ER+nRfEyMLjCfxcU/FCBPuH8fi1X74JLohAMIrW65PdJ/jVNmbKh+LkH1Iur6TmGSuct/4MaVj9M+6Ue74RrkhJaJwXUXrxZoy1hR+5oxUVNIkfgpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=51XqWHJtByRQLPsnY3wtzpUPOfwDveF+8mA8Bal+JXA=;
 b=WYrna+4j/+yeRhGVVnqRmhf2PE1cQ9tQ/vCgLCA1XaRhfbyS7PqWBLbuaHxk5jZwRUyTp+txogKB4Bklvc/Id879CY/bKz3YuvJhCljk7oSmGxN8ntee826OblgZ1LlP+1JjBo5A39H+hLzS4ed/8F4fUeKrJf/fvMz7N38dAsY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4574.namprd11.prod.outlook.com (2603:10b6:806:71::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 17 Sep
 2021 15:14:33 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 17 Sep 2021
 15:14:33 +0000
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
Subject: [PATCH v6 06/24] wfx: add bus.h
Date:   Fri, 17 Sep 2021 17:13:42 +0200
Message-Id: <20210917151401.2274772-7-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210917151401.2274772-1-Jerome.Pouiller@silabs.com>
References: <20210917151401.2274772-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SA9PR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:806:20::34) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SA9PR03CA0029.namprd03.prod.outlook.com (2603:10b6:806:20::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Fri, 17 Sep 2021 15:14:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dea0b8e9-df1b-4abe-5298-08d979eddad7
X-MS-TrafficTypeDiagnostic: SA0PR11MB4574:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB457430925236BBF547E1B8BE93DD9@SA0PR11MB4574.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:421;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MV62SnGooTwdJRsGV/IqegAwmXiVgXDqx9e663NaNURlz1vnDxuYl49f0Tqk/RxO5RvOUieCo1fcJQhC0gschEAON9lmx2BgESDZo21h+BZ1ecBRfkAioyGXRJsNPGw4KyxJwX9dOslo0LRE0WZbO4zIesVOZ1IaDi4aHzoKPweOV3t2eBJ8cdYO3T8K47NcIeDkDkqyMlKN4s5PmOyKc2JMTTOBtg6ciW9vgAklGp0X6ShLl9MYVYac21GdIXubOzT12A0d13aExwVqi+2+Ub/ro37ugTqlMinhw20IvFdjpAa3bj7i9Z2GQSzwni6yVgpJTT24hOjAo6U/jmkShqxeBdJjEKK2cBFaF5j4ZKWHFyu0/hKMQmaGCFFSzObqnf4lQXGJKFB3J3ZTLeIEXpXEfuZjc+YQQePI38IzdI6JSk33QQrd5vSlzsqImfBnMZ4WTXvvntNxMf1nrTxGp7HZP+w2+3Qzs6u94D63J9gVFmDbKZgHK/U+d7raY3Rfy5C/feuFbhWFzXBavh/YTT8IiIZKaTN5GZqRf96uqqdfJk3WsCtGSol9uik3JPyYyCS7K9+vWSqKvWW6PlYQ6qEKDuBCfswL/wFtTztXNQxog7gPmIarp25AOuZgBEBhuZxZfpt7QiEOHf/nCfUpJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(39850400004)(396003)(366004)(52116002)(6666004)(38100700002)(8936002)(7696005)(478600001)(6486002)(186003)(7416002)(86362001)(5660300002)(54906003)(66556008)(66476007)(4326008)(1076003)(66946007)(2616005)(107886003)(6916009)(316002)(36756003)(8676002)(66574015)(2906002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aVFrbHE4T0VVVlk2ejlQYmdEaGp6K0E1dUNUdG1WTm16dXpWejFSYjlzblh1?=
 =?utf-8?B?Q25zNE1wQk1yeVdyVkU1M1ZiaU9KN3pUTXhwSURJd082WG5TUG1GQS9mWVBo?=
 =?utf-8?B?MHRORU5BU1lhQTg0bW1WTk1jQ1A5THZQWldYNHlLSW8zOEJNVUliV2ZySTdB?=
 =?utf-8?B?QnNtU25iV2U5cjBNZUxEN0I5ek5BaUNzdmQxcGhhM1J0dUNQVTB6OTUrL3ZY?=
 =?utf-8?B?TWJIL3ZRaG9nZ0RhNGdid2FVMndNSjdMeXVOZGFsait2NHkvemxQcG42bG14?=
 =?utf-8?B?RVM4RkNKclA4N2RrQWhITGE5bGZuVE1CcUFpNzdZYjBJdlFscTV1NWQ0UHhh?=
 =?utf-8?B?RTFKOHg4ZW9iODIra0NrVW9TTWRFWjhMOUFYeUZPNFFiWnVMeDIyQUtJZ1ZY?=
 =?utf-8?B?TDJ2YTRUWTYwVW96MEs5YjBtekswWlRoc3Fqc0I3MW9HSEVnaGpVVWVUK0ZU?=
 =?utf-8?B?aFl5dEd0OFBiMmZpcmFzV05jeW03RGpTdnVWWVdObkx2dWlhUjNyaWRQM21M?=
 =?utf-8?B?bFRuU0F5T2pzN1ZtRmEyZC9GWFNSUHRNMVZiSlkvU09LVG9zRTNUNmxwYllp?=
 =?utf-8?B?akd5NzYyMXZiS1N6QzFpbnpSNllDcitOTWplS0gyamltK3hZWGJqV1lEMk1U?=
 =?utf-8?B?Rkc1Z2d0R3o1cDdJQWdKM3ppRHJ3SHBBQW5TUC83SXExL25NNFp2T3pJSncv?=
 =?utf-8?B?OEVOYTM4WDZ3Y1JIRXZ5OWVQYUxIcVlSeC9rbGdKTzdDR3FzY25WcXdsZS9V?=
 =?utf-8?B?Y3h1bXFlNk1rUlJnV25rUnU2bzg0NnZoQk9mMkpjVms4OFhaN2ZHZVNWOXdB?=
 =?utf-8?B?OUtYaUZhTitqVVh2bmo1Q1QyUE0yRnB2YWJabUZBZ2RLa2drVW92eStUcWh5?=
 =?utf-8?B?YWwvVjUxUTF1VWo2ZFJGNk5PL3pqR1I4dG9IQWd5eGlEa3dhWVBkU1JIV014?=
 =?utf-8?B?dEp3S09VdW53cktWTVRCN2g1bW9MNjJ1N0J0c1duMHYxeXBEaUpKbEw2QmVW?=
 =?utf-8?B?UkpvUDI5QTBEYnNQZEhZM2w1T1ROWTMzYWl0Q3NpUUM4alc3dzRGbitWWjcw?=
 =?utf-8?B?UlZZZWV5SGc0elJnWWM2TVNqR2ZUL1VOWUFaYUJCY3pCQzZ4bkdFOG9aVDhy?=
 =?utf-8?B?SlJDdU4yNXdnbjB1N0k0MmhpR3lJNVJsM0Z5OVJoNDNydkJyVGI1MWJkRnhn?=
 =?utf-8?B?UjRFaE1ZZXJ4RWZJdVZ1SWNtSXZSR00xUmVGNURNTnYvTXY1Qi96OXdWWVNo?=
 =?utf-8?B?OWl5Ry95UXlKcERDQWdXaHB6QkFSdmlKWlFHNEN3TFNWamk4NStBNXZLT1lh?=
 =?utf-8?B?ZDlyVGZmRGhwaWFJSHVZU2ZybnpWc01jeGFOVFpDdk9wYXJWVVVEK3pWcWJj?=
 =?utf-8?B?QVIwVS8yc2pRUFVOMDcvOXY5SlBnMjFadlQ0UEFoeGtML3drVGpBVnhTanBT?=
 =?utf-8?B?S1FwN0p3TmZTZmRiTlJjRVNsSm5BbTJ5UnljbXhIb0JyQmZ4VnlmbUFITGJE?=
 =?utf-8?B?aEM4UXZuY2NndjV3cW9DNC9QQzYzZTNmYVFIWTkyM1dvaU9SNFkvUFlsc3VX?=
 =?utf-8?B?ZXJEOHBIc3R4VDJDMkNuSlNpaHFuMDdocjd1amJJMFNBT0k2ekZmTHJkcW5O?=
 =?utf-8?B?cDBzUUhSdi9yQW82LzV6YnQ5ZkxuRTZNWlQwdzVPY0VjSU91SEMzQnRPZVF4?=
 =?utf-8?B?RWNPK2xFOU4rUUVWSUxOcktJZGR0RmwyK0o1S2JuRnd3ZXR2VWVic1kyMC9q?=
 =?utf-8?B?S2hFWkZZUm1MNDBpU1IzbHB1ak1TV2cwaGhTdzVBcTZ6eU1ReTM5WXZHejNq?=
 =?utf-8?B?NlY3QmRDaitGdXJKY05KeHpHd1NoQmk5K3pOTVdXa0xyb3JUa2xMc1dtN1d2?=
 =?utf-8?Q?FSqh2tiK6eHce?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dea0b8e9-df1b-4abe-5298-08d979eddad7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 15:14:33.7249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sHkqzX8EOhvX5b8G6qnv2UvneZloMrZbeVChiW1kBlTi/wjTuQQ+iH7LFuwwiB30zCiYlI0m/syCqngBocU01w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4574
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
dHJ1Y3Qgc3BpX2RyaXZlciB3Znhfc3BpX2RyaXZlcjsKKworI2VuZGlmCi0tIAoyLjMzLjAKCg==
