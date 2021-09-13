Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7471408B93
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239327AbhIMNEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:04:01 -0400
Received: from mail-bn8nam08on2055.outbound.protection.outlook.com ([40.107.100.55]:54369
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237666AbhIMNDs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 09:03:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lHY8x5gInPO6wOq9L2+npDr45go6qxEarwvM/8iVc4eDxTsAwP4PqXZzIQn4/mj0knbeDlSpcBLsPE2olRARIxERdo+tet17JnjNi/GaZbfi/HiIW34HEcOqrB4Bl8qyYgQ2NY+432W6qDKkDKSg6CdIgg2udIYYJ1oKFzmcEKmJPBYIrxpfn0xR5is181M79r85ncVMk+YfKPwsU1nfqt315bagNbhKYC8I7FbAjcAwY93quHuMewdw9O6XeN7ZdDbsnPHxhEBb0r1vhpiIXjtz0mMyRwq99KNgY9GK0nTMTCWYV49ZDUEZ8Z9Y4zqkjwWqvVnZ5cnljfyw4vRQtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Ltkb34xn1l2676USN4kZ+ng0WW2jWxAd1JTkXQJO7zI=;
 b=ZSl2m5V7T963qYmWJoMpvNwClyLKjE4I2v+2TgvaSLJtoeuLSJ/R8Iyr19PxhssWBj9t/BAwkFb8LuKDiiJxXFLhhONA+bIYd/75oeJMVdk+NK68V7Qj/aPZV8fD2r82jXY2CiEg/Uj8kz9sb0t2L9i7WrsD9mUqSEHTFs4sbCE4LZ6CPeXZePhDtVDaTSP/3X3zCXCzxJPj4qyPQU6xMW8f6OaIz9TkTmryvXluW+XlXgcC+KAVsVD4Se2SKLRISKkMM41jpkGp69RykVvI3AZuHwuCAn8r6MKhBabe0/9sxV5o2a/9X/Sy9gmVZjiorsORQjSk3IFsRya6SrKrBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ltkb34xn1l2676USN4kZ+ng0WW2jWxAd1JTkXQJO7zI=;
 b=QmPVM5qFNe7QH6b9H9xv7UplD93acVPKJMBuMxWiUb0lHQYkN9xRL3DQhmi3OsYjT987256dsCzSe3VI74AxBA8B0itnEwxcDzBiNPVS29DTLIhNuUZL8mtL++8olOK6NwHMSOY8YRpPv3iDBSEhmgCpr0SqS9+JofRHjFvaos4=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB4860.namprd11.prod.outlook.com (2603:10b6:806:11b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 13:02:28 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 13:02:28 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v3 06/32] staging: wfx: drop unused argument from hif_scan()
Date:   Mon, 13 Sep 2021 15:01:37 +0200
Message-Id: <20210913130203.1903622-7-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
References: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 13:02:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb985e32-68be-4daa-2c95-08d976b6bd20
X-MS-TrafficTypeDiagnostic: SA2PR11MB4860:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB48604EF58C7B9B711C3FD68793D99@SA2PR11MB4860.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:854;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QED/HfA2lLp6vPsXdjR4V68I5v4W+cbqdnrfDbc38CE68Ol28+vIGkr5fAfbeTd0cFyp7xDAAIBfPR8EIgV28oW47MZvb8S9RuZIQ43iFvBkqBIjMNqcQeQjjMpB+OoehFdIP77itj5bhe65jBpxWJEqQFuRCvUiz+hBRTYuVbQjZlMgtC+ZBQ4Hm79ZfSt5UYCaC2B0+Awir0sKXN72lYNrb7HE/2OXXFd2olSIA08V6ZNJ/K3ZHUOxIGy1BAiQhs1YAnZ4fpff4nPtUcddfAWDha0H5n2P9EQH5oMceMo4G/3cUs80HZtwj0GH8aCtdi1XP4sCNbLHvGRuHg5kuv0J3goCdO5rPvYH/yTlE3YpaOhFtKEMY3kHAiUFbY34VcabVp5kvrLO8q0GP0QEe1MZjphG6MZFCJLThvZqPdg6rx0nCuwVGjoHcMgZSqbcDtr+itQ1YZyBFH22LJog5Iwh8nzKyV+fb9v3o+vmMauRuMwq+biWdaLD9IyZCaxoDWGVnbM0ndrIY1+jJFFGs91KO8Zbp5D6wUuxZUJPapINEkosZfpNSMCIPFWMGQmDM0UwDEdiBelvgestmmMys2+wTlNEi6hm+liPCU69Zelb9DWXWVJCztROAaIrSjH7eN2s8zgpBfgyNzQqqOU0QMoAqNa8AJg222dWH/7S7O4dRKX17BMeSTP/JtkPV4omfzXyHCp91h9cYrXObd3bhw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(66574015)(6666004)(66946007)(2616005)(26005)(36756003)(38100700002)(38350700002)(316002)(4326008)(107886003)(7696005)(54906003)(5660300002)(52116002)(66556008)(1076003)(66476007)(6486002)(508600001)(8936002)(83380400001)(86362001)(2906002)(8676002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dk8yTlhTMjFhLy8vaDNFbXZHdFdGdjIzazNLbGo4ZUZTVVRnRGtad1NEWW96?=
 =?utf-8?B?UURyeTE2OENFN3NaMGtneEFBN0J6a0lvbTZNZVlWWHZabjNvWElDcXIyb1dV?=
 =?utf-8?B?SVlvQWpZcWc5MDEzdFNuMUc1eFhqeGczOW4zZy9Va1ZuaDdPT2x1U1NNMXZI?=
 =?utf-8?B?NG02ZnJrNVZWVWRaU2RUWnZUdUgxZkR0dHAzSnJzbmhvcEhqcWJiTEpneTdG?=
 =?utf-8?B?Zm5CTlg0Q1pFTm5LblZUZG5vM3dsOE1RblV6SUdqdjJHOEdmUkV0bm1aeDg5?=
 =?utf-8?B?L2dwSm5ucE5sSnlaaUtCcGZNVUp5VXYrU0NFS2VZeWwyd2ZlVEtSWVgzYXh6?=
 =?utf-8?B?bEFyeXI5L09JSk1hSnN1UlMzQTFmWUVSaVR4SitYUjN4Tk40NXhBUjFJMWFa?=
 =?utf-8?B?OFZvUUNJaTgrbGFFdThHQmRYN2U4YkFGQVkvZE4yT2JGRm5scUlIN0s3WTYr?=
 =?utf-8?B?Q2dFL2J1KzBoY3UvalNNRzVVZTcyT2t4a3dlNi9OMDlpQ0poVVEwUlVNTjZJ?=
 =?utf-8?B?MW1jcUhlY0hUMnUxTWMyQWxTSEZ6YjMwMkxFVThFdGdOUndBWVpoOXBnMkUz?=
 =?utf-8?B?TlZDTEROMXR2ZGpkT1M4dlZ2ZGpYL1FkdUlyOVJwbi8vemN0QUcydEYyd0NU?=
 =?utf-8?B?VSttUXhkSnNPZXhha0pLMFN6enB2cFoxNEdxNm1sbERUa0sreU1pcy9UUXFZ?=
 =?utf-8?B?UEZRUGZmSW8wN2NlcXpzZTRDRzhqTlhiSmkxV0JjYWJQMUEya1dwTWM0U2NI?=
 =?utf-8?B?aExSTmFjOU9nUTZrbzdVOHcxZjF4UG1EVStBb1VSNitzMml5QVNIWUVmOFV2?=
 =?utf-8?B?KzNXZzhJTWduZkg3aUZSWGZNRURnU0hTb204SlFyUGN6b3FCL2VEdGJ6QlEr?=
 =?utf-8?B?bXNrTjg4MC9GY21SaXdCKzJ4elhxcjNBS0pWcGtQTld4UlBQT0FFekhSUXBU?=
 =?utf-8?B?dzhPTW0rZGhyZit6eFpVL2VwdW1uRUtVaUEyWUFMOUp6dEw1LzZKeEpvcU5n?=
 =?utf-8?B?MU9PYW12dWxPaW03Q1hKTXU4TFVQMGE5WFgweGZ3WnRLRkpLTnJjT1lpSTRL?=
 =?utf-8?B?YW15RUdvdDJqRVBTS2hsVHFPZ2UxclIzbERPMjUvTzJSTVE4OTJjd3k1b1pK?=
 =?utf-8?B?SVprYWM4TzZEditiR3pYVE1Odm5kbGlUUm9yTGYrZkJSU05wOWdiOEpSQUEx?=
 =?utf-8?B?bTRhSlJYc0wxU014L243ZnhxZWtZVEcwMlZNMXhvanBPdXRKZ1pKNU0yS3BD?=
 =?utf-8?B?ZEg4Z2cyWVR5ZzBBSnJQV0RmQ1RDQStXU0RGaFE4cFl5L3dhWDZiSmdyZU5Z?=
 =?utf-8?B?MTVtN3RJdVUzWnZuWFZzNVFjaGFhSlgvK2RXSkVqM0RTcW0vOEtMV3RpOGRz?=
 =?utf-8?B?QzI1V1IxWjJqT0lYSmFEbURTSUlXOTE5MytzemswMHRkQUJlUlVMazB3U0RV?=
 =?utf-8?B?blBMRUtNSVcxYW5SdkkwLzdjYTBneUFXbEZJbzkybVRHZk1YSUlCd0tTdHZa?=
 =?utf-8?B?M2k4SlF3MXozVVk0VnM3TDVIWkcrR0ZWdEpqOHRWWlg3SDNuK1lERlQvdHZM?=
 =?utf-8?B?YWJxSHlMYmtaWVBCWnFPZ1R2OEhaRm1WREkrVUozem5PYkE0M3BKdkpuUnVE?=
 =?utf-8?B?T1FCbWFmR2x2WUIxczB3OFBCNjdYWlVMOURvazhoeVpUSnJDazNSdThaaHk5?=
 =?utf-8?B?TXpUSWI0UkVjVXpiRnYwNlk0by9YUExzTDRnK0owRWJraGJiUHk3YnBkdGpC?=
 =?utf-8?Q?puCYRW0aOa/JnjUXArIl/3ncVoz33086dQ0dFEG?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb985e32-68be-4daa-2c95-08d976b6bd20
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 13:02:28.0282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6jTaiSfbmBBqPpPiR2jcAckSJ8aGnizkcjK3E7xLVLgO9slpvvnJwq4Xft4vzHfanltpjL4oBMG23zyFytctig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4860
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSXQg
aXMgbm8gbW9yZSBuZWNlc3NhcnkgdG8gY29tcHV0ZSB0aGUgZXhwZWN0ZWQgZHVyYXRpb24gb2Yg
dGhlIHNjYW4KcmVxdWVzdC4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJv
bWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5j
IHwgOSArLS0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmggfCAyICstCiBkcml2
ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYyAgIHwgMiArLQogMyBmaWxlcyBjaGFuZ2VkLCAzIGluc2Vy
dGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93
ZngvaGlmX3R4LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jCmluZGV4IDYzYjQzNzI2
MWViNy4uMTRiN2UwNDc5MTZlIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90
eC5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMKQEAgLTIyNywxNCArMjI3LDEz
IEBAIGludCBoaWZfd3JpdGVfbWliKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LCBpbnQgdmlmX2lkLCB1
MTYgbWliX2lkLAogfQogCiBpbnQgaGlmX3NjYW4oc3RydWN0IHdmeF92aWYgKnd2aWYsIHN0cnVj
dCBjZmc4MDIxMV9zY2FuX3JlcXVlc3QgKnJlcSwKLQkgICAgIGludCBjaGFuX3N0YXJ0X2lkeCwg
aW50IGNoYW5fbnVtLCBpbnQgKnRpbWVvdXQpCisJICAgICBpbnQgY2hhbl9zdGFydF9pZHgsIGlu
dCBjaGFuX251bSkKIHsKIAlpbnQgcmV0LCBpOwogCXN0cnVjdCBoaWZfbXNnICpoaWY7CiAJc2l6
ZV90IGJ1Zl9sZW4gPQogCQlzaXplb2Yoc3RydWN0IGhpZl9yZXFfc3RhcnRfc2Nhbl9hbHQpICsg
Y2hhbl9udW0gKiBzaXplb2YodTgpOwogCXN0cnVjdCBoaWZfcmVxX3N0YXJ0X3NjYW5fYWx0ICpi
b2R5ID0gd2Z4X2FsbG9jX2hpZihidWZfbGVuLCAmaGlmKTsKLQlpbnQgdG1vX2NoYW5fZmcsIHRt
b19jaGFuX2JnLCB0bW87CiAKIAlXQVJOKGNoYW5fbnVtID4gSElGX0FQSV9NQVhfTkJfQ0hBTk5F
TFMsICJpbnZhbGlkIHBhcmFtcyIpOwogCVdBUk4ocmVxLT5uX3NzaWRzID4gSElGX0FQSV9NQVhf
TkJfU1NJRFMsICJpbnZhbGlkIHBhcmFtcyIpOwpAQCAtMjY5LDEyICsyNjgsNiBAQCBpbnQgaGlm
X3NjYW4oc3RydWN0IHdmeF92aWYgKnd2aWYsIHN0cnVjdCBjZmc4MDIxMV9zY2FuX3JlcXVlc3Qg
KnJlcSwKIAkJYm9keS0+bnVtX29mX3Byb2JlX3JlcXVlc3RzID0gMjsKIAkJYm9keS0+cHJvYmVf
ZGVsYXkgPSAxMDA7CiAJfQotCXRtb19jaGFuX2JnID0gbGUzMl90b19jcHUoYm9keS0+bWF4X2No
YW5uZWxfdGltZSkgKiBVU0VDX1BFUl9UVTsKLQl0bW9fY2hhbl9mZyA9IDUxMiAqIFVTRUNfUEVS
X1RVICsgYm9keS0+cHJvYmVfZGVsYXk7Ci0JdG1vX2NoYW5fZmcgKj0gYm9keS0+bnVtX29mX3By
b2JlX3JlcXVlc3RzOwotCXRtbyA9IGNoYW5fbnVtICogbWF4KHRtb19jaGFuX2JnLCB0bW9fY2hh
bl9mZykgKyA1MTIgKiBVU0VDX1BFUl9UVTsKLQlpZiAodGltZW91dCkKLQkJKnRpbWVvdXQgPSB1
c2Vjc190b19qaWZmaWVzKHRtbyk7CiAKIAl3ZnhfZmlsbF9oZWFkZXIoaGlmLCB3dmlmLT5pZCwg
SElGX1JFUV9JRF9TVEFSVF9TQ0FOLCBidWZfbGVuKTsKIAlyZXQgPSB3ZnhfY21kX3NlbmQod3Zp
Zi0+d2RldiwgaGlmLCBOVUxMLCAwLCBmYWxzZSk7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2hpZl90eC5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguaAppbmRleCAzNTIx
YzU0NWFlNmIuLjQ2ZWVkNmNmYTI0NyAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9o
aWZfdHguaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5oCkBAIC00MCw3ICs0MCw3
IEBAIGludCBoaWZfcmVhZF9taWIoc3RydWN0IHdmeF9kZXYgKndkZXYsIGludCB2aWZfaWQsIHUx
NiBtaWJfaWQsCiBpbnQgaGlmX3dyaXRlX21pYihzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwgaW50IHZp
Zl9pZCwgdTE2IG1pYl9pZCwKIAkJICB2b2lkICpidWYsIHNpemVfdCBidWZfc2l6ZSk7CiBpbnQg
aGlmX3NjYW4oc3RydWN0IHdmeF92aWYgKnd2aWYsIHN0cnVjdCBjZmc4MDIxMV9zY2FuX3JlcXVl
c3QgKnJlcTgwMjExLAotCSAgICAgaW50IGNoYW5fc3RhcnQsIGludCBjaGFuX251bSwgaW50ICp0
aW1lb3V0KTsKKwkgICAgIGludCBjaGFuX3N0YXJ0LCBpbnQgY2hhbl9udW0pOwogaW50IGhpZl9z
dG9wX3NjYW4oc3RydWN0IHdmeF92aWYgKnd2aWYpOwogaW50IGhpZl9qb2luKHN0cnVjdCB3Znhf
dmlmICp3dmlmLCBjb25zdCBzdHJ1Y3QgaWVlZTgwMjExX2Jzc19jb25mICpjb25mLAogCSAgICAg
c3RydWN0IGllZWU4MDIxMV9jaGFubmVsICpjaGFubmVsLCBjb25zdCB1OCAqc3NpZCwgaW50IHNz
aWRsZW4pOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L3NjYW4uYwppbmRleCA2OTViMDY5NzQxOTQuLjllMmQwODMxN2M5ZSAxMDA2
NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMKKysrIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC9zY2FuLmMKQEAgLTU2LDcgKzU2LDcgQEAgc3RhdGljIGludCBzZW5kX3NjYW5fcmVxKHN0
cnVjdCB3ZnhfdmlmICp3dmlmLAogCXdmeF90eF9sb2NrX2ZsdXNoKHd2aWYtPndkZXYpOwogCXd2
aWYtPnNjYW5fYWJvcnQgPSBmYWxzZTsKIAlyZWluaXRfY29tcGxldGlvbigmd3ZpZi0+c2Nhbl9j
b21wbGV0ZSk7Ci0JcmV0ID0gaGlmX3NjYW4od3ZpZiwgcmVxLCBzdGFydF9pZHgsIGkgLSBzdGFy
dF9pZHgsIE5VTEwpOworCXJldCA9IGhpZl9zY2FuKHd2aWYsIHJlcSwgc3RhcnRfaWR4LCBpIC0g
c3RhcnRfaWR4KTsKIAlpZiAocmV0KSB7CiAJCXdmeF90eF91bmxvY2sod3ZpZi0+d2Rldik7CiAJ
CXJldHVybiAtRUlPOwotLSAKMi4zMy4wCgo=
