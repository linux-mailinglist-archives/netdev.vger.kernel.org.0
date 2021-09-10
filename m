Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7F9406ECD
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhIJQIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:08:31 -0400
Received: from mail-mw2nam10on2088.outbound.protection.outlook.com ([40.107.94.88]:56865
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231580AbhIJQHc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:07:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XaYD0hZGUnMFLbF3VbM+xr0wc9nDuf4gW/Ln0SQJrtkiejH7e+JlhK4foKE+ljqwIqj6UD6n0vMcNsf2CJz7/+ulsiLkyJIzbsY3hVmNiGOvD+XveRjgcbhsKsiAZFV23ZOFZDmhWGqJsLf+nFL+ZNZwPeYfOoZi4hP8AcFXfkDiG3vTL489g+9xGx/4eyEBuc6XgrKCmtVZF/N5WfQAuSIfGpowsPm+UW7kFO5/nWzlIiMeDiiIvcp6vmCKPbeAPzh7qfzr6iY0TpH7ucGUFsTfJdAqkgyBF/HtUPw1r9As431JUKH2WiCdjka90vL3B7m3X8ULl0X9Kcz2JIe5+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=zepjhr/9IN2TlKMACudigtOtb0JfVXPJtJXaDzy1Q/o=;
 b=hyv5+bJvyFc0fBvTfCNn18r7d/W7yaFklW5yTZg6GyK1kQ4YdCK2stqce8b53WqA/6flFA+MTOn4XozkE+pc3WkrCGvHW/EWiCEYghuM/eegrmyWYVGL/5N1ePCm9Wip1EWm6MyFB+Hgu45z2yszfPjP+2baF2NLv1WIslDAjlQ8Y9A9A3pVNt65hryPZsug+r8//7Ac/D0psuwRyyI2lXhUEnbrDCEjbJQ6j1+WDKKaSriDCc6YWUql+0g+FNjnw4Znogi2wjVeZMiY92jzsnElsX7SPvSkVbuM9uUbi6PP2sqawE3YZfp4FU9b2G4LFyEBOiS5vPOVj5+MsdzbxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zepjhr/9IN2TlKMACudigtOtb0JfVXPJtJXaDzy1Q/o=;
 b=nrBsZn+XOqfFx6w1AMXwVXHnFOjaZbdlb+w25iccdUQCurnH1Pvb9BznX/1Swctw4jM67wAhJj0w3WuEd0rpv1s2eouR/ty6sT6KRzvkfvfbD522YY9xct2fYmI8tCSmuYfgHjSo2VMWEhx4OR0X0oyvr/9xdMKlDolngQtZDCQ=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB5002.namprd11.prod.outlook.com (2603:10b6:806:fb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.25; Fri, 10 Sep
 2021 16:06:10 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 16:06:10 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 20/31] staging: wfx: apply naming rules in hif_tx_mib.c
Date:   Fri, 10 Sep 2021 18:04:53 +0200
Message-Id: <20210910160504.1794332-21-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0601CA0006.namprd06.prod.outlook.com
 (2603:10b6:803:2f::16) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SN4PR0601CA0006.namprd06.prod.outlook.com (2603:10b6:803:2f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend Transport; Fri, 10 Sep 2021 16:06:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7f43ec7-29a1-404b-c562-08d97474e7cc
X-MS-TrafficTypeDiagnostic: SA2PR11MB5002:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB500250AEF20D4346C66001D893D69@SA2PR11MB5002.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q+4EO0+UqcX3/JECXAZYDOVHHWJsXqy2wSZmZshWmMQJlSqBE5sydhtKfxZ5YEPpvgm5jZ0l2X3Etrnxw02MBeluSwU3MTvp4Xw/Oy3sE4lSSx6nYNdtgKJlxRlIWsAzSKuzobUKmLprzhsgSu8xsa7fKznM+MOAu+y4LfJYKxKhuQV9hlTzGPjfoAUd4H+Jkv04s45EXns0T5MtiPDnnyNMCgWlwYgyB6VDF2xtih0u9cVX2UbmzcqJAv7ynU7JVZZeloyVdn61iHV+GxR9CsMPSbrWhSz1WqK7nuKbtBBlg4rKwSgfLzqkT0xPcBPbudgwXU13Mk1mEkeRjvq1HrdJaEKVypyu/ivnOxR4vuCoqL8vYHoB84XZmu2ItAfxvE5B7vT98r/W8zdudIOw6qVqN5fPUg7knBTpMAzrlgbezCy1WNMq2R1g1xakyeHmFeA5HFr3C8TxKLtXYDEfXWikSD3/dR7zphH+oqemheidOCgDzEmk1s2ouybVt4rCHDD777h5YmgDrsyzZOZHVf6sXukAhC0Daw6n+vSDxP0pPMPkvrVXMp8BF79oZv1B70u/chyAKhopu/VF219LYY6aJRhaHh05jc1CkNQz5LXxPoGh4u83UI8O4IEFm3UYJHuYPsF296BH2QLicc0qqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(52116002)(86362001)(38100700002)(8936002)(186003)(7696005)(4326008)(508600001)(8676002)(36756003)(2616005)(6666004)(66556008)(316002)(66476007)(83380400001)(54906003)(66946007)(2906002)(1076003)(107886003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bWV1b0toZHJ3ZnExanFncnZRakE5SFdjRXl3V3RVN1htanhORG5JdkJvRDhE?=
 =?utf-8?B?VUhnZTk2QmVQQVpzTDBMWE5WazJvZG1ERm9XM0lqVlVYN0cvWWZXS3ozRzRk?=
 =?utf-8?B?L1U1Z2ZBRmpJbzhLN1pxY2ppSnpIMkJzWjRnc05Kd3JhT2kyMnF0WnRwZ1Fs?=
 =?utf-8?B?QWxVdW51TzVCNDZGZFZWN1ppWUdRQzdBZG1Cc0V6MTB0cHluNXpKSzBsVWY3?=
 =?utf-8?B?UHp5cHJyRVhONWhqbmxVN2l1ZlI2eUpCNUR3eUZseStoUUtML1hZQ1pYNGlR?=
 =?utf-8?B?RWJkb0E3RkxTQksyQ0tMdk1PNlJVSWg4RVRSRE9qM1ErTlp5SDJMZzV5TWVZ?=
 =?utf-8?B?UFZ6ZmlKaDN4S1R4TnNjUmlNOXgvSTJyS3U3U2FRWEtlWldGSEk1K0J2VmpO?=
 =?utf-8?B?NmgxbndXczhWMDZoQThsbFZrV3BuSDNDcmkzOTdhSjFvYXVweklEd2ErU3kv?=
 =?utf-8?B?ZEoyVmZjRC91QTRENm1EQ3orc0JVR0s1dTZmbEdwUHpHcmN3VEN0ME5ZMWVn?=
 =?utf-8?B?WktvUVY4NzJWbDMzQWE2OWtkZGpGc2F4VzVWOE0xSWx4V2ZwUzJPZ3VRbGI2?=
 =?utf-8?B?QW5uTW5JVEdNU1JRalFYVG9sWngxTndoWndSRXlaeEEyK1p0bjBmMDJsc21F?=
 =?utf-8?B?Tnc1aUdpWVV1WHVtTndkZHlQM1hwRThGOEZVcUpaWkcrWDRXbjZEYTFJaHhS?=
 =?utf-8?B?Zy9WQnNKZXlCYjFhaDZ1bmtjdFhBK29kWmFUdTRvWlVNM1psTWI5eVorQXZN?=
 =?utf-8?B?QlpIVlMvMERnNFdBaTNSeUdBaU80WENEM1RjN2l0bWo5dzA2L0EwRUthN3NF?=
 =?utf-8?B?R0pMMTBlRFdaQUN0RVBkRnM2aUwwb2tNbEV1bkR5anNjMk1hYXNvNFFrclM3?=
 =?utf-8?B?WXd1M2FxU05OQjhXOXhTWFJaKy83Q2x5WXU2Nk5PRUhtay80QmUwc2YvaGR1?=
 =?utf-8?B?c0c2THY5RlkyL1JxaTc1NG9RWWlhVHlLUUdyWDJuOTNXeHlEdTlzbnJ6ZEtS?=
 =?utf-8?B?Q3JySVAzQTZpVGR2dllKZ0FDdmlONGhWb2tQZEVPK2Q4ZGNtKzZxaUdleGNF?=
 =?utf-8?B?c0tEMlE4amhpdTFHazhJb2dBWjlVSW5LT24vWDlkVTZkVWdlaEtrdkR1QjBM?=
 =?utf-8?B?RENzTTg0b25paTdBVjliQzd6Z1B3QWdhMjJTWlpHQk1OVy9USlNsTkVJOUsy?=
 =?utf-8?B?UnovVkprNFVnYkc2VUxxeE9pNU1pRXVOVGFkdHRKbnQxOEwwNGZHT29JaEVU?=
 =?utf-8?B?a0VxMGlTY3lCY0FrcEZVUHNVYXpTVnR4NHl5amNFWVg1T3orODBVc2ZEeFRu?=
 =?utf-8?B?Wm04ZW5QU0NTeWJWZGRFMDFPYjB4S2VuTmxmODNkYUFpMk43aUFaejQreG1l?=
 =?utf-8?B?RkhZbVlzUVlXUHcrZDZBSjNmYXZmanB3MitGZUNkb1dMTW9qZU9abXA4NkNW?=
 =?utf-8?B?RUxmS01QYkJGT0k3amYzanprSE9PRlArcXRITTVjRjBsSUtDaXlCdFFjdnVC?=
 =?utf-8?B?U3NSV3RIRVVOQTcwUUdHaVVFSEpoTUY1ZHZvWTd3ak51QlZYMHBoNE1FVGox?=
 =?utf-8?B?T3ZYM3MxSG1ELzcyT3ZRT3doODlMU2o2VmUvRElneDNxZTI4WjNPd3loVUpX?=
 =?utf-8?B?ZVRNOHZJUmlEZDJEVC9INmFqSUM5WWZLbFExdFIzVXBZMEY4NS92WExNUXVL?=
 =?utf-8?B?bkZVMFZRclFIV3JXaklUMXNPYzh5Tzk4SFpWa1JJdUVuMThIaG9lbldaQWF6?=
 =?utf-8?B?dHdYcnpGY0w3VDVIQ2ZQRWNtTFc1aTMrcjIzTnc5dzg5QTFKS3dqWjlSL0gv?=
 =?utf-8?B?anlJMDdhV0kyNDZpbjhDZG5YTDZrRTlmTktTenVENHBPc2UyT2d4dkc1VnJp?=
 =?utf-8?Q?36KLdcQVnPaEc?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7f43ec7-29a1-404b-c562-08d97474e7cc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 16:06:10.7398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 69VeO6tneFC7hRdbeInNxrE0uPTZYVsKQQGpZcmJRRD9bfcXBGNc9oH7lKZQ/dvYx0sXWTP1ZVR9PVoNreLQeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5002
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQWxs
IHRoZSBmdW5jdGlvbnMgb2YgaGlmX3R4X21pYi5jIGZvcm1hdCBkYXRhIHRvIGJlIHNlbnQgdG8g
dGhlCmhhcmR3YXJlLiBJbiB0aGlzIGZpbGUsIHRoZSBzdHJ1Y3QgdG8gYmUgc2VudCBpcyBhbHdh
eXMgbmFtZWQgJ2FyZycuCgpBbHNvIGFwcGxpZXMgdGhpcyBydWxlIHRvIGhpZl9zZXRfbWFjYWRk
cigpLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBz
aWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5jIHwgNiArKyst
LS0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmMgYi9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2hpZl90eF9taWIuYwppbmRleCAxOTI2Y2YxYjYyYmUuLjE5MDBiN2ZhZmQ5ZSAxMDA2
NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmMKKysrIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9oaWZfdHhfbWliLmMKQEAgLTgxLDEyICs4MSwxMiBAQCBpbnQgaGlmX2dldF9j
b3VudGVyc190YWJsZShzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwgaW50IHZpZl9pZCwKIAogaW50IGhp
Zl9zZXRfbWFjYWRkcihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgdTggKm1hYykKIHsKLQlzdHJ1Y3Qg
aGlmX21pYl9tYWNfYWRkcmVzcyBtc2cgPSB7IH07CisJc3RydWN0IGhpZl9taWJfbWFjX2FkZHJl
c3MgYXJnID0geyB9OwogCiAJaWYgKG1hYykKLQkJZXRoZXJfYWRkcl9jb3B5KG1zZy5tYWNfYWRk
ciwgbWFjKTsKKwkJZXRoZXJfYWRkcl9jb3B5KGFyZy5tYWNfYWRkciwgbWFjKTsKIAlyZXR1cm4g
aGlmX3dyaXRlX21pYih3dmlmLT53ZGV2LCB3dmlmLT5pZCwgSElGX01JQl9JRF9ET1QxMV9NQUNf
QUREUkVTUywKLQkJCSAgICAgJm1zZywgc2l6ZW9mKG1zZykpOworCQkJICAgICAmYXJnLCBzaXpl
b2YoYXJnKSk7CiB9CiAKIGludCBoaWZfc2V0X3J4X2ZpbHRlcihzdHJ1Y3Qgd2Z4X3ZpZiAqd3Zp
ZiwKLS0gCjIuMzMuMAoK
