Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2CF4086CA
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 10:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238659AbhIMIeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 04:34:44 -0400
Received: from mail-dm6nam12on2048.outbound.protection.outlook.com ([40.107.243.48]:60019
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238389AbhIMIeK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 04:34:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jjsdfTXGrpRpFG5a2jqvUDdZaBmd5OsFkwVDuVjFuOYOix0IeJlqB5A3JtwahV1kROE2EsBNnxPDP2ers+o8zAOWAZoO/rGQBGekENxJpP1j7Nsq7CFJmiQFqYn52bnMuW7PudCXE01xlKtpJEyFq551BFtO8U++d6t4ULfqZ5DeVIxMRSfqcEkn+JfbGQa17Q46AJmSXXsn4q3o7cC08OqPQRB+ub0k3foZPUMcZJ/DK/cg5zFwkXce6rgZ47lqWddtl+LETw1Nk1bzgmezQH7K8CDz3Segp/n+pCA8/WBJmqpU0RGyIZS7mZJXV4EMyniXnNCDZ1IKaFGWuAZ1UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=qM0FMGZRJjSUIUB43bIkjZdDBC6mBZNDVgLC0UqdvoM=;
 b=R7LujJ1bXZuuv+S3QhyLZFX1A2mcIMarq4RyVh7fyKNsBHgEq0HMSBmCD3TA67huyuJN8Yicqv6OmxGmnlYhQDKRDoN0MhSQ3RKl5SvExFEDZKvnHZ9c7iStze4roXkq4s2Dgwynm05ZKgPbUs4H8RXnuYXxKNZibRUdquCIwYzd/FqcSWMTm7td2eN10VYG7OkJ76iX6L4KAKdaHRjFoHs1n+EUKX4CqrhWAbSfVtFMsoZhpN8D81UPrrQUOrcOymamr6/pOMZHXCXi605Ek+QsASfWpOkmTkUEPINMbJ6ugULyJ7t/iqkGgOUS538NSZ34i4eHbrtDjhLQJnJhOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qM0FMGZRJjSUIUB43bIkjZdDBC6mBZNDVgLC0UqdvoM=;
 b=ZUxo4vE2s1yhdSZYI+4PYWkd8LSSr5r79INIS39HllhPRRTL6iYSYHLeOqLrX8H6XfYmh6n63qt6PeGfIjsUVudrEKvb2iQMHuh6h9FruL9df+8kMmgtfosWTaqx5GbkIytlibME9MLstcjMyk46z7//0YnKJ9ynyNNdzyVasFM=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (52.135.97.18) by
 SN6PR11MB3263.namprd11.prod.outlook.com (52.135.109.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.18; Mon, 13 Sep 2021 08:31:52 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 08:31:52 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 13/33] staging: wfx: update with the firmware API 3.8
Date:   Mon, 13 Sep 2021 10:30:25 +0200
Message-Id: <20210913083045.1881321-14-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
References: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fd::10) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1fd::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 08:31:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b53992ea-05c5-478e-9bd6-08d97690e116
X-MS-TrafficTypeDiagnostic: SN6PR11MB3263:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3263932698124FE1680924D093D99@SN6PR11MB3263.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:288;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3fAl55nHIPwQHnzJtpbLjeS+vciFmWwnpaTQfEtwHN/d0ClvYs7XSZZtcy6lLd7UpbCJ3C9uCMd3OmdxnScilvgWKyiCzT9BYFnB+6s5Wcg2YBhHVSsdLyfOGc+t4vEnee/Y6DGQhHzEzrTHNI0g/jDdM7+jhAN7aM5ct16Z926wjdSMgPP6IwlkEn5vB/J7QlmPjUQS//ZZev/xDPPSjGFR12u2yKdAJjEWYxWucuFxJzsoR1HVoCH8qVEmt8QaKEPOMi08cOy2zDGZgHuhSyB9E3bjG+YkfykXc5MbGf7w03+a6qx1YAxfd1Mbly9CZUeH4laLtpcPZUgiPaAh/hQir4EX2gredgQMoEEv1fU5V0/RqYEhsTO76iCW3OwHR/++TBzVKAcipHfK7X2fm4Eeq+DBZnchMl+9/b9LVSRzaURcVkVDJR8DkQhetqyy2Zhzm8sxM6KEeDfYCkuSa7rY47iotufoOV0DwfgT1P4EOGtvVEKQs+FC42XvzfkPAEYacIArtpjynqcoyirooxYO/yfO/jUtF5xfiZ58XfaeHKLDqlZXmEBrJG4TxRR7x5KNZbohtK4FzqFck0t1dRJod5nGCSH1kbehs4PZr8ry6JYLJtn6L89+sOwUEm4S9BdQ7lilppui6rsX6TQ4wQOuOVQsODGHgvEXkQWk+wdYva1OxgdEl7oQT7RiAcmcjsA2UTehc6+2RzCTB9YY4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(66574015)(107886003)(956004)(2616005)(5660300002)(54906003)(38350700002)(4326008)(316002)(38100700002)(66946007)(26005)(66476007)(66556008)(186003)(8676002)(36756003)(8936002)(86362001)(508600001)(52116002)(7696005)(6486002)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZGpnMzEzdWdPQ1ZRa0N5ak8wdEtMdE5GSUwxQ2liNzZPb0hBbVEzelRRNUxz?=
 =?utf-8?B?cEZkNVQ4cTFadElKOHRPQVFEWWlKdGxGaFVBYThtRHIzU3hTdHBZMUVGcGZC?=
 =?utf-8?B?MC9YdjAvc0d1ZDVzOFVVS2FXM1ZiRDJrTlBIWHlKanlaK3NMVTBqWVBWQVoy?=
 =?utf-8?B?UjFHQ1lJWHJuTVFxa0dsMFJBdG1hdkZ5SlRLamxXWE8vMTNER0RQenpwdnRH?=
 =?utf-8?B?d2NPck50bHRGZVdNcWNxNUUvSmtnbkNESEVsUmNrdmZvTEgxd2Zac1dUeGVK?=
 =?utf-8?B?emZlN01LQjVBQVpvaWtyRFhTUmJrUElWRTFvMFdpc25PWno4Z2htUHY0OUpi?=
 =?utf-8?B?SzlEazlRcjlnQmhPVW0yblZLMnpHSUU5bVJnVG9ydGh1TDN4Q0RBUXpJUGNO?=
 =?utf-8?B?R2Zzd0trNHpxN1BHWWl3SUxVN1h3d3BFWmdYZkRkV2dRaVZ4NTRUb1dXdzdz?=
 =?utf-8?B?eVpkZ0Z4Q1NFc2lrUm1hTDd2U3BScDhyQkxjbzJieW13V2JrbmRBT0RkVWc5?=
 =?utf-8?B?cXNpbWNjcWZiZzFGK2lub3FwbUQ1SllOUFA3aTA5RWJMMXV2SUQ2b1A1NlZo?=
 =?utf-8?B?SStBMkJ6b1F3UGVyYS9PYjVCWW40NkRIbGFZMURESU8rRXk1UXFwNkp2Z0sx?=
 =?utf-8?B?cml1RW9hcnBoWTdIRG80V0h6U1Q3alVDUVE4c0IzcmRnZjJ4SisrbVJmaWh5?=
 =?utf-8?B?Tm90V3BpR0QzVHVYQ0EraDNDaXI5QTJlQ2N4bnhsay8wOUdpVnRmTWdiUkox?=
 =?utf-8?B?SmFJeHpuM2FIOUdoemxwZFAzclVxUDl6WGxLZFEwZThZN1RKNVl4RlZLYmxL?=
 =?utf-8?B?Rmh5YXRhQ0tMVVgwUFRLQnhXU0VoaWQ1ek5qa2V5NjZZVXlZUmcrbzlXbGlu?=
 =?utf-8?B?ME9aUTdZRU9KV1ozQWZwb081ZnR3WHhhL1UwZ3ZzTHpBRTBFRzdTZVRuT0lk?=
 =?utf-8?B?a1Nrb1dsR1RWMVMyNklzTStoQU91KzdQMzNPR1NBc294ZXRSeFJSYm5zSUxx?=
 =?utf-8?B?QXF1ZnAzYVJHamRJU1JQdURNTFpaS2lnbDJaWTUydXA1ZXVPb09xNTgxUkJB?=
 =?utf-8?B?K1I2WXBnRlhTb1dDRzl5NWxrWDl6ZHR5L0xMUEppSE51ODNYazh2WStpeXNn?=
 =?utf-8?B?RGtqMUg5SVNqSnp3cjlPNWNOb2lRY0NLV3dVemJqeEFZSEV5NG01c2lIVlN2?=
 =?utf-8?B?U29FWTlhVFVDNzV4dFNRekRWcTZYRTl6RmZZZ3d6Mk95eWxLM0FZM3RTRzY4?=
 =?utf-8?B?alV3aTkrTmdmcnpkbXA0OU5JM0dqc3FzSExTMW5QcW5VMWh3aDNpUVh4QUNO?=
 =?utf-8?B?V05jcllkWXBQcGpadXF5a0VPTy9Ja1g1bGtRenhOVXZHb3dVZ080cW9CcWNp?=
 =?utf-8?B?TkIvQkE3LzZEOWU0WUVBNzA3UjRvek85N0hpNFBIRTRNRzkwR3BBNWZDR0px?=
 =?utf-8?B?bW9YTkx3UjFjdzRJSHJYMGxDam1WUTZMb2ZRWFlvWlo4R1BTUk9yVU8xOTBH?=
 =?utf-8?B?UVZvUEJwNmVyVHVxK3ZjakFmdzJpTmpDVnNqMHhFWTZpeDl5V21ubkkyMXNt?=
 =?utf-8?B?U2ZVZUZ3VjJVME5NcWNHN0UrdURVZ1FMekQrYm1JNzZjQmlCOFl3azhTdU14?=
 =?utf-8?B?Nkd2WWgyM2UxWW81ZDNtNWNTYzg5blhhbHVzTTBBREFORzBDU1VqZy9KYU9v?=
 =?utf-8?B?VmtZbVZnbmdVMDBjSE1XZVB4Zi9iS1BlYUxaZFFUTXIzeFIwUFZvblF3b3ZQ?=
 =?utf-8?Q?aueby5A5uZlZo4NAxpAh3VDU5w9Eufr0hHBUCQn?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b53992ea-05c5-478e-9bd6-08d97690e116
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 08:31:27.5028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lflThaV7wLd6ccG0NA+sL0BPb+b1BS5asLeEyitLITz0sJldrINxSzyJ3Vc9MpxXYGqg7EYysTlZDWgSkJ7xhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3263
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGZpcm13YXJlIEFQSSAzLjggaW50cm9kdWNlcyBuZXcgc3RhdGlzdGljIGNvdW50ZXJzLiBUaGVz
ZSBjaGFuZ2VzCmFyZSBiYWNrd2FyZCBjb21wYXRpYmxlLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0
bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3Rh
Z2luZy93ZngvZGVidWcuYyAgICAgICB8IDMgKysrCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9h
cGlfbWliLmggfCA1ICsrKystCiAyIGZpbGVzIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgMSBk
ZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGVidWcuYyBiL2Ry
aXZlcnMvc3RhZ2luZy93ZngvZGVidWcuYwppbmRleCBlZWRhZGE3OGMyNWYuLmU2N2NhMGQ4MThi
YSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kZWJ1Zy5jCisrKyBiL2RyaXZlcnMv
c3RhZ2luZy93ZngvZGVidWcuYwpAQCAtMTA5LDYgKzEwOSw5IEBAIHN0YXRpYyBpbnQgd2Z4X2Nv
dW50ZXJzX3Nob3coc3RydWN0IHNlcV9maWxlICpzZXEsIHZvaWQgKnYpCiAKIAlQVVRfQ09VTlRF
UihyeF9iZWFjb24pOwogCVBVVF9DT1VOVEVSKG1pc3NfYmVhY29uKTsKKwlQVVRfQ09VTlRFUihy
eF9kdGltKTsKKwlQVVRfQ09VTlRFUihyeF9kdGltX2FpZDBfY2xyKTsKKwlQVVRfQ09VTlRFUihy
eF9kdGltX2FpZDBfc2V0KTsKIAogI3VuZGVmIFBVVF9DT1VOVEVSCiAKZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9taWIuaCBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlm
X2FwaV9taWIuaAppbmRleCBhY2U5MjQ3MjBjZTYuLmIyZGM0N2MzMTRjYyAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX21pYi5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93
ZngvaGlmX2FwaV9taWIuaApAQCAtMTU4LDcgKzE1OCwxMCBAQCBzdHJ1Y3QgaGlmX21pYl9leHRl
bmRlZF9jb3VudF90YWJsZSB7CiAJX19sZTMyIGNvdW50X3J4X2JpcG1pY19lcnJvcnM7CiAJX19s
ZTMyIGNvdW50X3J4X2JlYWNvbjsKIAlfX2xlMzIgY291bnRfbWlzc19iZWFjb247Ci0JX19sZTMy
IHJlc2VydmVkWzE1XTsKKwlfX2xlMzIgY291bnRfcnhfZHRpbTsKKwlfX2xlMzIgY291bnRfcnhf
ZHRpbV9haWQwX2NscjsKKwlfX2xlMzIgY291bnRfcnhfZHRpbV9haWQwX3NldDsKKwlfX2xlMzIg
cmVzZXJ2ZWRbMTJdOwogfSBfX3BhY2tlZDsKIAogc3RydWN0IGhpZl9taWJfY291bnRfdGFibGUg
ewotLSAKMi4zMy4wCgo=
