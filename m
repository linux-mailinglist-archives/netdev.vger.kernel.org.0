Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D53873DCAAB
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 09:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbhHAH5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 03:57:32 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:65386 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229543AbhHAH5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 03:57:31 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1717uwcS032487;
        Sun, 1 Aug 2021 07:57:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=i3SUQGuwhRpbpCsv1L8xIgIqF3QsuoqhA1SroOrsUs0=;
 b=TTtm2LooUvdGMILXxBe3BMUQQsUsfw6mfN6Sjxl8g9g3ZW9rHRCEhHmf3GW6nSYEXrmS
 FJO52L+2ElJWKFEAB1d1iHphsygqkN9cpay4Wbis9S4wfCXQaKUwNLqB2PPinxl2WOvv
 CnxRyu7OzqtaqGNlWEZLDNHRJY9vcKx7KdCDoigU1NG8BH4joh50DDQ8N3k1LNRSfsc6
 Ich1zZKgCNOIL2CC9xZ97ZtBgJspYMy5VLfwKnnwso6kYeD1OOIeVeUumkDiOkCm+zeh
 49K2aVxOn7YHbp9ZQRQH3uLeVHNS5tmbnL195f13U/NcfCvSw+M4iSFDqnDs39dB6AMp 1A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=i3SUQGuwhRpbpCsv1L8xIgIqF3QsuoqhA1SroOrsUs0=;
 b=uMS6CCaIWRoF3T4/UslaNJYa0Dp09AJmZQBzh5a/jA4P/8SyulF6D0uXy9sURCAULrxM
 /i6w5t0PMOF3zNoPIbGIIy3xgOVCmsGGUsXf2VsxG5/3+vaOzjMptWxEecJpqL9trPCU
 Rm6C1liXmszilYK3nM4KFiK2eaGPZmsK9/v3pq9bU3X/BibuVy3mQ6A+F2mrGQcAJOTp
 XpI0f4z5MrK5K1bbxdpd94e5sm9yaCuZUp+cD9G0qGSCGGR8Z5qRNafZZLGQ/TSO/adm
 py/vdLQ7siO/71LXmN0Er4hUDz6csvdAMcbrfUq+ml8fRTg4d3Myh6IxzHwQ/0S13Zrf ig== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a4y2s959m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Aug 2021 07:57:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1717tkOP124563;
        Sun, 1 Aug 2021 07:57:19 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by aserp3020.oracle.com with ESMTP id 3a4xb37b8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Aug 2021 07:57:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ren4xMFOLZealz5yr91H0Ftb4Ch71GTkWDK9drIl0DUyRqd2ZN1mtzlxt+wIH1M+w32JkEhc9O3aASFMGsCFp2y53HXJ1ykWXNV/0paYxl/Zi53vwcoMKJoVh1bfaj0eghuPswMyJlSMwlsD+bNd0fXhkw3iZfRwr1MPRBhN59JEGBeHlp8uh/OH75MzZNxkb3mqtGyfr4z1XxpLvPp9het1/FTQ944Kao9Y5kuMKJvyloP7mtUDUVqpmiyQsjgefCefyfbJA3UGDPf0ij1zlfaF+NAZix0MzWsqN87r6+afmU1TiSkBGOfIZBIPCMqfI+w7BLCadAe4awApzxeVDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i3SUQGuwhRpbpCsv1L8xIgIqF3QsuoqhA1SroOrsUs0=;
 b=n6WiD0iE5mnIkhK5+XGRJKAxk2GiF6LgNn0FvUCFowjhJE8Y6Fq5lGIr7zldbT0GCLPBR2GwHKXy0/zzNKqRosNz1Dco4yYyZEcjDS6Txw611lyjTikZ6b+asSq7ECmasFiyUAfuND67uryWL2KdvUwp6fH+2QKG6tHv9v8sQgRGQAT+OOEMpzIW0wqQjN+5lASes6Anf1Wx3Ah73EO8uOz4KBcIQYRtis0uBKzt7qZrKpW8qoDvylxxEhZAvUMotkBerkERV6upyHq1RpBDSrngaShZXcrLdDMZj8wwlXbpTZ4QRST2Ah4X1HDqv6Gkw1LV5/9KxVUcAnE5hqxzKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i3SUQGuwhRpbpCsv1L8xIgIqF3QsuoqhA1SroOrsUs0=;
 b=aOJMB0gboeEhmn2IRp32Lp0kF06fRwg3dSFQ/7QZmPHvQ0Kh2TQmemZQrbqhVK2NwwEvVUZwYNYAvoaixm1cQMVMHxQyoVT9r0Z45UBMylXSFlcmDBIonq5vvsY5puYBAodip73+R2LbtvyvtQUIsRbOgv63sXiHAHF0Bum2dMg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by BYAPR10MB3382.namprd10.prod.outlook.com (2603:10b6:a03:156::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.26; Sun, 1 Aug
 2021 07:57:15 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::5de5:d174:9459:6d21]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::5de5:d174:9459:6d21%6]) with mapi id 15.20.4373.026; Sun, 1 Aug 2021
 07:57:15 +0000
From:   Rao Shoaib <Rao.Shoaib@oracle.com>
To:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        rao.shoaib@oracle.com, viro@zeniv.linux.org.uk, pabeni@redhat.com
Subject: [PATCH net-next af_unix v1 0/1] af_unix: Add OOB support
Date:   Sun,  1 Aug 2021 00:57:06 -0700
Message-Id: <20210801075707.176201-1-Rao.Shoaib@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0201CA0021.namprd02.prod.outlook.com
 (2603:10b6:803:2b::31) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from shoaib-laptop.us.oracle.com (2606:b400:8301:1010::16aa) by SN4PR0201CA0021.namprd02.prod.outlook.com (2603:10b6:803:2b::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20 via Frontend Transport; Sun, 1 Aug 2021 07:57:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2fe44a9b-c88d-4647-6318-08d954c1fa4a
X-MS-TrafficTypeDiagnostic: BYAPR10MB3382:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB338281AB5170176267588908EFEE9@BYAPR10MB3382.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9KGH9lo+MIMHNbg/hxfzBs5uYKiCgD6vnbcjeRt1kR6uU4mMsrxAK8wNwnZ5vj4nHM00etGVgEQiRCmcbFD87KBnudqwwmlFF0A2u83VTqNnlHIFTadMPOY4Tp4/82vjM8FnOsHxOOcOkD1lE1nd1L4R+a/l1/L8el7LBDDKIlw+mI5aIAdnwTRHTtgDzv0lkfmBsypq/X23fW5KcVBv4kOBqTBeItOu/h6ta/kyBgPO6UvpvvTBS1c9EYa4pUPBKfTDbQjKZVVBE2k1gdtIriF23F6W4pAgY8RGbzu8gF3VMWIwSzSf+kafKOjl64d1huouFEDr57uLecCBJvLF6DSuEk4GqofF8DxHlqZ/8goIcFaVlSdRe0hHiN3a69h/hFxCVuHzLbZDVi0CCoswVUhdDLELCXPG1E48nbNDXsZajBc/bvKMJSSApi0tgjuyGAmaM4jp4xrwF0O4192Qn6EMmYA2UmFi+ty4H41VcIy0k08l2aQPhad6kuNCduAwrIPwUaUZvjI8QJFWLw2BoHosp01CDrWvQ+fupy86RG5On6aHHsXu9Ixv6Fj8RtDf0wn7b3vDsJowq1F4Y4v/82Xibp69WztVbH31ddSkmf5WGT2PT0yJq4M/+M6rB1UuCNlxbSXaa1dFDASWtGPQA8lQ5GCjWQkC1LdG/TRXmUUMSMKoFTjx51AvFxemfS3v41LMaJzG231BTHqystpQfA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(7696005)(52116002)(2906002)(6666004)(66476007)(86362001)(66946007)(1076003)(966005)(508600001)(66556008)(83380400001)(5660300002)(186003)(8936002)(2616005)(8676002)(6486002)(36756003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cFdyjSuB7wXMFsR1kAi63i4xE92gTuJJ+aWTnA3qXrd8fKmbsu5o5zWZUcwm?=
 =?us-ascii?Q?XdBVsUQ54YaNa5SceyqxRjcYcHqs1A/8WIbQngi72NAXJZd4RU0QzZ039xTL?=
 =?us-ascii?Q?KfnAyAqWQx4gnkbFYM3EacWFtLcfke1V13BMV2UXe2txhCzpuQ0e4vrd3rgC?=
 =?us-ascii?Q?kYgLXXFu6Zx5SYGDxz3UuADhxfdm4peW+L5b3H+6wnyoB1E3kXw7BVVhZTa6?=
 =?us-ascii?Q?U0PQxK0Y4PuMgDZv+mOGUkdoAIuAQkOiJgt09hvQ83/8FVDnUVIX1ZaackbL?=
 =?us-ascii?Q?xAAD6uZDM1ygZgHVyZ/gPtG+8Gfj0KED1a10da22laFli1LIsbg1mppPhKCT?=
 =?us-ascii?Q?8UgLhnpbI/jktCUlJeQLTWBrVgOqe83vqGN+LH4IX+0ZJo6SdxHQvZmTcfeD?=
 =?us-ascii?Q?OGrDU/shig4LwbqPu/zl1yBM1AjtTEyr1kty0hkKzmL6Anj1OpgdRVdl14k1?=
 =?us-ascii?Q?UOibIhPfKeLWnb/cUp8A2E3OBqNt9U+x3WjWjNfjKH6MD/4lZUKvwo32ssUN?=
 =?us-ascii?Q?AMds1wCoHv1KOO0MD0eC34NP0/XE8w2Nj58bUXHHMM8JKuebioq1XPoV/Dx9?=
 =?us-ascii?Q?UHFTkDapPht6PhwY/4D646TKqL1hlLt4+doKLBZ7Wn8Pzx9HGss513PIVEyS?=
 =?us-ascii?Q?bAXQuQfeNjI3F7pWz0/oj4F8gL7DZVqJj3uI9ONcYDrNjG/E0vqJuXiIWeaU?=
 =?us-ascii?Q?wtDagjH3hPb8Fe5KyWSaBGXBFJI+6T4vSl/rxaSXGiVl6RZyZMC51UicB6p+?=
 =?us-ascii?Q?I4Ml4vs7b0xUc8n4yfDovW3jSCtFbCDh1CwtdbBOTpeYorNhv0cDCtgfZAup?=
 =?us-ascii?Q?VI7iPwf/vVvu8jPGCaFQZF0on2DbDYwleLtmcnOO1oCuCKLHKkP4TjuD5Kpk?=
 =?us-ascii?Q?Z64JfJro6LXDq6VdocNn+R+clH68RF4yDgCXkPPKzSYOxVwG6cpNVgUlKFW6?=
 =?us-ascii?Q?b7PHjnNXh3juQlFmyACGb++hEsR3Du6NgvRwrWDn/t4uJ/k/zbmAHsbc5mXy?=
 =?us-ascii?Q?FJMWzkUm4JhBx4QkR3mxqVQVD9U+vhJXJaSbT9vLTCHVOs0I0lpw9eMXDgwN?=
 =?us-ascii?Q?Rlhir0YUilq74V28oqF0vRsC/jc8kEG1823ZJPGf8t4JX8UDbHylr9DOGAXT?=
 =?us-ascii?Q?Kfp9vV6iaUfQ7afkLySCU3beCeTaU6STUnIF3VGMIZB3ypl9WQb43eSnUpAQ?=
 =?us-ascii?Q?NojYXxzGsrb8YgQthMzQ/dEG/HGZ4c0Mbq9FtnFuQrGXja47Ga1ek9oI3fdS?=
 =?us-ascii?Q?e1EoabISKfBlZDxy7Y+LqWllmhVek00GKb/QahcKAC4L1S7el+EBKfZvyvmc?=
 =?us-ascii?Q?NDqG4kOg3GVXBxknUEBSLOpdVcXxuLvM1y6Sk3FqgZIFGQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fe44a9b-c88d-4647-6318-08d954c1fa4a
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2021 07:57:15.5918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OSFGFgt8caK1HJFpe1HHToveHxjlCXrNLsQm8yP4pFaY96dLrhtt1nYQAKkV29lmR8WlCABvtdplk8RbfrW1MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3382
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10062 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108010058
X-Proofpoint-ORIG-GUID: k8DB9iokumjFg7YmwmCsjG1OWnwIx8vQ
X-Proofpoint-GUID: k8DB9iokumjFg7YmwmCsjG1OWnwIx8vQ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rao Shoaib <rao.shoaib@oracle.com>

The original Berkeley paper on sockets by Bill Joy 
http://maibriz.de/unix/ultrix/_root/net.pdf
defined OOB support for all streams sockets.
However, this support was never added to AF_UNIX
streams sockets, probably because it was not needed.

With several containers running on the same host, AF_UNIX sockets
are being used instead of TCP sockets because they are efficient.
Papers have been published that show the performance benefit of using
AF_UNIX sockets and mention lack of OOB support.
https://www.usenix.org/system/files/conference/atc15/atc15-paper-dietz.pdf
Products are also being built that require OOB support for AF_UNIX sockets.

This patch adds OOB support to AF_UNIX stream sockets. The semantics
are same as that of TCP.

Rao Shoaib (1):
  af_unix: Add OOB support

 include/net/af_unix.h                         |   3 +
 net/unix/Kconfig                              |   5 +
 net/unix/af_unix.c                            | 153 +++++-
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/net/af_unix/Makefile  |   5 +
 .../selftests/net/af_unix/test_unix_oob.c     | 437 ++++++++++++++++++
 6 files changed, 602 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/net/af_unix/Makefile
 create mode 100644 tools/testing/selftests/net/af_unix/test_unix_oob.c

-- 
2.31.1

