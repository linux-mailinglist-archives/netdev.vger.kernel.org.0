Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83C2F48D40A
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 09:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbiAMI4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 03:56:19 -0500
Received: from mail-co1nam11on2086.outbound.protection.outlook.com ([40.107.220.86]:28322
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231932AbiAMI4N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 03:56:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kxj9mthRkgJi2evWfwuAd9+uKO4PmTKI6tGHtanohLqB2TR6RSAKmhZb5GmGJ/ts2/yjbYTIl2Ifv63N8MPIEf5Wc/btl6ShdLAAkd/gDW+jhPidirYBqqZEVHF+8ZOQYagW4of+gQbSImcgVMRAor8hIwM7/6t0Qngh0r3udYlINwtqjagAC6DifLu9M83+DOPCErTzD/7oaybkvR71QpDolBB7Xkxk/HPV8nCWCGV4v+Br+ajf3b7YmWLqZ3xGg1IymgUogbf+veglahdF0Igp4Ofq57nuQ+/I6+LO2/+9WgfWu8A/jUf/UWDEvySSfuJwXGqvxcG0szgutiQ5eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ROux8YOXP+rBzV4eXP78mZycZroqTVJCivRcn4Gly7g=;
 b=aFwYfe+6WrsF2KwZOkmjzdsEJLuM5YKAU1gSvZ4uYHYWblW9Z7x+BrT6U79zOEYefeXRzRO3mi8a03bQ95L18rLPs6ft9BJtx2XY8xzCKrnXI0DSYUx8e9ltDqSM4ZX+jpEsNPh0Lyzr/pNceBWNlw0aRgqIodpTxKgqr5K43vMKxnoI0jqw0y6mBC7KASxv5ydd7f0gyKxpRqrBEHh0ouDCNhzNbXMwar1sh2UQLVzBOHQWK1IFymtb/TryLWp2gMVxwSAjUYhC62FFPq9frwJ+5G9skex4v4RlQtegbGKldDKN4C+Plc3grf09H5WESbgW5ED9ro6rblX6Jc9fwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ROux8YOXP+rBzV4eXP78mZycZroqTVJCivRcn4Gly7g=;
 b=bvNx8Mdiyt1C4SvcO4S1B+k3OQlVMJT//rgnNKRY7ocFgdEvq+RA84DXcgw9FQWHrOUHVJrRn9FdgWUneeGCgZha//IfpQ0jfkyN7LwLiA7QvCR4M2LysyRRtfoIWT8AOKiTqkNgz/6ShsVe399qicxmH3hZnHBrj0FWvwST25A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by BY5PR11MB4040.namprd11.prod.outlook.com (2603:10b6:a03:186::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Thu, 13 Jan
 2022 08:55:57 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%5]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 08:55:57 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 10/31] stagigg: wfx: replace magic number by HIF_ID_IS_INDICATION
Date:   Thu, 13 Jan 2022 09:55:03 +0100
Message-Id: <20220113085524.1110708-11-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220113085524.1110708-1-Jerome.Pouiller@silabs.com>
References: <20220113085524.1110708-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SA0PR11CA0117.namprd11.prod.outlook.com
 (2603:10b6:806:d1::32) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62ff95cf-b803-42d7-ee31-08d9d67283b5
X-MS-TrafficTypeDiagnostic: BY5PR11MB4040:EE_
X-Microsoft-Antispam-PRVS: <BY5PR11MB4040AECE3317932ED10A753493539@BY5PR11MB4040.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:151;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9hvHaP5ZuyODDlEljtxJvYX4dtbSkKQ8p70TiAiROZx2LPsf2/nNgZOF/gmHbAJYxmQb7AUuttTsWjaO/b56E+tSIRMbukOfCuStpC4Z0sxaGYPK1ftCYPgJzaiPTRKy73+DlNvhadJfI31KpsZuIIe0v3hoZ4xhhCEtD29Aet8+pmnzrPjL7AHx/1pxIvC6z4fyq3zXzN99P5huMxJ8nOxCOz6BJQEvoUk9AnH5w2zQ/Qi5xEJUqp2wDrUfempU7DfLw85qDjtx5kY40P70pFeIdEAqzFkUjd6PKyeokR+87hY4Ahq8VgNJw4V91yC6hxTNqfEdyKDk57LFZDtp4yPc7pdVgc0+x5VGZawcTYZdDosZrCouBUu7/moRX4A7UZU+WcqgF1SqK7tDYzTWsIxYjCX04LCQK6/5EjllTxwPclx86odrFB5+wnPd7HfgJznz0Zm5jtqyr1zCACHJIH5tFxNBMW9Z8UFP/AwqIV4sQ+PExsJaxVM8Pf8kqMf3vSEQq9X3y18CIuFvAsoVhsFUx3YLzQShHx12xvEgq7kmzh1IAPhzQQUcPg4oCFymE1VGmtHIxvaLmZ9+yaq7BKC3KTbA7ngFn1Yi9UNHjXx75ssNAyxNe7uMehHVhBeac0nDeprMG87KKaVfKxZFnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(508600001)(186003)(38100700002)(4744005)(4326008)(8936002)(6512007)(6666004)(66946007)(83380400001)(1076003)(2616005)(54906003)(86362001)(66556008)(2906002)(66476007)(316002)(52116002)(36756003)(5660300002)(66574015)(8676002)(6486002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Nk1tNDcrYmVWU3lVd0hTK3lZcmdSWC8ybDRneWZsa01UZ3FhN1BFU1NWZFpx?=
 =?utf-8?B?ZndmQmpISmI2TXprWlRGTUxteE9VU3R3bi82VEVQTDlkeHFqWmlIbWNYQUtG?=
 =?utf-8?B?V2VNZXJXYW5XWXRvSjdNYWwyallraTM4eG4rT2lVeC9LS3VPVUNiSVU4U2Nx?=
 =?utf-8?B?UEZUNVh6dDJONVBQMGxDQmQ5aGF2RFhzeVFnUUVwSmNXaW5nOUkwbnJmamYr?=
 =?utf-8?B?b0JMUnA3K1pjR2RrRnpaYVl1NlVONjVDemRaUmhoWjkvczBlK2VTNTNkL3RI?=
 =?utf-8?B?Y2g1NkNSaDVnc1BidU9rRUJwRXlGUm9mWmlBYmFYZnM0MHpLVWdGc01kai9w?=
 =?utf-8?B?MjVEMnNoQ0ZsNVpSTkM5TDFpZlJiTWs4MHV2aFpkcmIwbmZPMktHVU1SOTBx?=
 =?utf-8?B?SXUwT283MEN1bkdBNHIvVUlYdlo2UEFOOE54WTd5TWtUMVA4MUd2c1FWTmFt?=
 =?utf-8?B?Z1F6c1RmSWkyMkZlbSttMDQ0STg2aU5RVzM2V0FuZW5QZlZjTzBONEpBQkZE?=
 =?utf-8?B?d1cwMDV0NFh4M00wbnJvZkFKUlhBOHRjQlZpVkt1VU1Xbk1FVEJwbVd4TzA0?=
 =?utf-8?B?MnBjQ3k4OHZvV2Z5bG83VGVuaEJGL0w0Zy9FbVJyeFRjZk95dHA3YktOSDg2?=
 =?utf-8?B?eE4wUXptRFVhOEVhdmthU3FKS0JBcWFjVjhIUk8rRVVTNlhQamMyNzBTL1p4?=
 =?utf-8?B?WU9LaXZ1c0VNTWhFWFNySVBlMW1QdG9maUN5bm1qWWp1ZXFKN0U5UEYrTVVJ?=
 =?utf-8?B?MVBiUGMrTnJsSUpnUkxScHFXQWVoUWw4ZGtocVBoaGh5V2RkN3F4dkZSRlgx?=
 =?utf-8?B?TDN4aWtyb3pKSENFWDdyZFgwQlM5cklxMTJldTNsREVtM0hsSS90YVYrSXBL?=
 =?utf-8?B?cVl4RklDcVoyc0lPZFEvbnJhTlh3WnN6WDRpYW9kZTd1QjBWZTdjd1R4eVdC?=
 =?utf-8?B?SHFjRnEzMnliTkp6aFFpVlExZlhrM0FnYVNwMEVCVVlwQlFReXc5MFAvRXFa?=
 =?utf-8?B?OVl6d0pyS1d0Y1REZktJVGMraFkyRFdFQ0w5eFArOHd2T2NOSk0xek9sYWk4?=
 =?utf-8?B?OUVNdkdadEVCeDl5c1Y1bzB2cGtwc0w2VllQQmp0akdnV0ozRmd5T3FQMk91?=
 =?utf-8?B?aGhrQndjR3NHNFBXakxEaFltaEIzclJjNmY5NWNPczROczVteUpucDZEdWky?=
 =?utf-8?B?Y3R2QmVjcERENXh1SHZTeE81M0dqZ0doOSthOE9SZjUvTHc4cVZmUnJKYXpR?=
 =?utf-8?B?WmtRc3dEUGZ6UXlrS3Z1QVh3V2xHWWVhaHhNd3B0Uk40TzJWSW9qNm42emJo?=
 =?utf-8?B?WG0wUkNIYUg3ekQwU0RPNkdaOHR4K2tGOGQ0NWlSalE4QlJ3MENhQWtBNjBR?=
 =?utf-8?B?THpLQys3SEFUbUJueDBQU25vN3RwTjlxbUZQSmhyeUg3NnU1MXkwbmRlZ1hh?=
 =?utf-8?B?ekhvdGVqVE1GdUsxWXNyU2dSY0lpVm43S09YOVR5WW05YUJHZGxsSzJndEhz?=
 =?utf-8?B?MlQ4Q2hPZWJlQnh1Mi9WeURYOWJzZXZOZFllSkpvSjVISUE4amVQMHRVZFVa?=
 =?utf-8?B?bU1sVGdSQlBzVUVUeEU1emtzZTFvSkM3eVU3NUFqWFRzdElFZXBMYnY0ek5j?=
 =?utf-8?B?WmhYbWIzSlc0U29JZEN4QWMwU056ZHdyOHo0UXJjckd2Z2h5R2hXU0ozZmtr?=
 =?utf-8?B?L1IvTitCVklGaVJxbUJLaVJDb0Y0N0MwcFgwbXhQSzkzZTMvWHZWZ2pqaWJM?=
 =?utf-8?B?NzYwRHpsdDZvYStDRER0RlA4c3U4ajc5Nnoxb2ZvVGZXMEFoMndpZ2d6eWsx?=
 =?utf-8?B?d3lnY0NlSGVVaENnTHJUcFpHNzVWTGxLRXdtMFlOSThzeUh2eFBWdkNRNCsv?=
 =?utf-8?B?bVJBTXZvVjhrc1VSQzhYaERwYjEyRTV1Y0NyWUxuWGtXR3lKcHg5M3dOZWlJ?=
 =?utf-8?B?Y2pNOTBBcFRjVXJXd1RzM3VvZUhKUzhMWlhNc2JSanQxSk5mNDkvRjFxcVlo?=
 =?utf-8?B?eDRBMlc5ajhaUjZ6aDhzbnRrbGpqcXF0S2R4NU81eERoVlMvaWE2c1Q3Wmdq?=
 =?utf-8?B?UFJMQm82L3pEMWhQN2hKcW5yYUtlZExDcFFTdDVjY3MyaW1Uc1FYUFE2eDZ5?=
 =?utf-8?B?MzdzNGx1ZDhwcUZUamQrK3B3UkxVWkViQ3A0RGlKMGVoRlY5L2lyTDRaeHlo?=
 =?utf-8?B?OU8ydElDdFREcHdvRTVsMVdaT0ovSzc2c2hHVXVpWjBrZTVzb0w4c2xja2c2?=
 =?utf-8?Q?2fqA9BcNUprVgzEv29X8AIxFS4dZLIQMYlfVj4mZRs=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62ff95cf-b803-42d7-ee31-08d9d67283b5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 08:55:57.6168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a2JCC1ynTGH8bqqi7CloWD8KkWSnUNiqtEqfgw2VO9+/DuZJCprsbfW45AMiriA5PCtfOQjYAiJ1xbQ/44ZL7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4040
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKTWFn
aWMgdmFsdWVzIGFyZSBub3QgcmVjb21tZW5kZWQuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQ
b3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5n
L3dmeC9oaWZfcnguYyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBk
ZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmMgYi9k
cml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jCmluZGV4IDY5NjNiNTRkNTU5My4uNWU2NzVkMmMz
ZTgyIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jCisrKyBiL2RyaXZl
cnMvc3RhZ2luZy93ZngvaGlmX3J4LmMKQEAgLTQwNSw3ICs0MDUsNyBAQCB2b2lkIHdmeF9oYW5k
bGVfcngoc3RydWN0IHdmeF9kZXYgKndkZXYsIHN0cnVjdCBza19idWZmICpza2IpCiAJCQlnb3Rv
IGZyZWU7CiAJCX0KIAl9Ci0JaWYgKGhpZl9pZCAmIDB4ODApCisJaWYgKGhpZl9pZCAmIEhJRl9J
RF9JU19JTkRJQ0FUSU9OKQogCQlkZXZfZXJyKHdkZXYtPmRldiwgInVuc3VwcG9ydGVkIEhJRiBp
bmRpY2F0aW9uOiBJRCAlMDJ4XG4iLAogCQkJaGlmX2lkKTsKIAllbHNlCi0tIAoyLjM0LjEKCg==
