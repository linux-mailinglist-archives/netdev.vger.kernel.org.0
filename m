Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3EF34F5343
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448837AbiDFEXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1577945AbiDEXRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 19:17:46 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A7825582;
        Tue,  5 Apr 2022 14:46:21 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 235J49jc006378;
        Tue, 5 Apr 2022 21:46:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=INFStmJuLBDz+zTtGjWYnKY1C7uahJ8lJUW26FkZRfg=;
 b=ZXkVIyjgaFn77p5aKW4Vl2p7s1uORJ+XuzA5BiOgs0eQNwJiT0d195XnZZj3JVPeXJra
 3/+2jaDXhMa8py2PwzvdDlwqWljLnm2kYOPZPeRSN/h14ywUSbPcUzL6e02Zzmt/UgbZ
 MABc9picQjxIjb0Uepok4uKq4n7yBLB8kBoEcEiKLNy+nGwE1hUO/0vUq8uerxV9eYCW
 tR63oKrls7V5qpF9Mz4X3ck31/IWBHq7hoide4KgOFz7nBIJKVj7feKA7xT51J6j2ZBK
 BJ/81ZG0dQqMkf5n70nphWtDq3QqlU9lkYznpjXMl5VVXaVXV/ozvkY5ALZPoOj0+OJE bA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6d31fb12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Apr 2022 21:46:04 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 235Letwx029195;
        Tue, 5 Apr 2022 21:46:03 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f6cx3yhwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Apr 2022 21:46:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SkwXgv8h8p+R3sbvMd4KmnuaLsWi12VBay9ZY6wXYF1uBRSgK1ER0XWqff3fNa+xsIoo0jukbobpfKntaUF3aFwSzcprIncFUedBj4S0HxmZxMW/9RwmZtNXzwfFBv9hJkfB8fuNbWEAC08Fm5SADSNkT45thihKJKT5bOaSmlIEJYNlvbGYk3ylL7mVkf0m6MhXjwpYGC5hntCbvc3we2ywpx5jayrIHyVbob+H4jUbDsMQa2NTa/uSI8+vo8JM/duoDQxeY8yDpDttvQ8V+al5c8qG64s9omL53eDxrU9AwvmedG5dzTUdMk+IAaAfnKe6a3NUVzIxKPoGYOCtIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=INFStmJuLBDz+zTtGjWYnKY1C7uahJ8lJUW26FkZRfg=;
 b=UcxkAU/wGSDo2K49cdLxmlFTDlVVocwJHIVlnTxtTqOv2twomGJNNSe8A1fJa+CzfxHCDdM0GAr2iwF+1i4LzMkfjiEScOP3VEj5B/AgvQTD/0us3KdFvAfAw+CkOLR7KVvQXcGgq9ImZ0sXb/St6/+UqAVKaY4x7frRexh1tSEn6YMeRd0qbxMz8YIQoY0Dq0FBMN0G8kvXrkf/fh1yGTrz5QactecEojFE/SGZtbn1x+70r93wiirNEXggw/bUpB0OUM833iXw0CAbYM6QdawQXywSLB7r4yJmsmiKb7z3LMRzqL6bEjbb3cDde9uUxHWUJ+Y9MqqEkbPhEVQG3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=INFStmJuLBDz+zTtGjWYnKY1C7uahJ8lJUW26FkZRfg=;
 b=uZJZYd6Y6rI4arDbeytatIj8UH5ClzE393pFDNVyXtHIyeUMLzbY1E5HyuxkJmJparaNB3eYzWaD6K38q5lhQzy/BDC66tBerl76ToT1c45sSq7PPM/ULWoFvNy/P+fbFxClIsfQfuzORLWCiUvzudJMX+SUhgg7nQzPIC1O2cU=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by BN6PR10MB1362.namprd10.prod.outlook.com (2603:10b6:404:42::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 21:46:01 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::bc05:7970:d543:fd52]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::bc05:7970:d543:fd52%3]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 21:46:01 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     andrii@kernel.org, daniel@iogearbox.net, ast@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf-next 0/2]  libbpf: uprobe name-based attach followups
Date:   Tue,  5 Apr 2022 22:45:54 +0100
Message-Id: <1649195156-9465-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0302CA0016.eurprd03.prod.outlook.com
 (2603:10a6:205:2::29) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b2c17f4-4e2d-4b3d-d8c5-08da174dad29
X-MS-TrafficTypeDiagnostic: BN6PR10MB1362:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB13626790D2C8BB61A60CAF19EFE49@BN6PR10MB1362.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: euUiYOz6OMAPQpQlEwGKNm2NaGquWSVamjL2jkMApmQK2GVmtNrYH6RpuMEIVYzKCZ+4z7lffjjE9CTouLjftOmAtjzW+ZHTpyJrzqB9eWyu3vMQuPPuXH6L/VlivQCmfOT5RyNBDKn3qth2aZlJ0wXS+qhgoKXEsgAkdCiofTMSgHZehhq94/+aUJDNJzMiioRfT7u7Al8951nvMzGkxa5Tt5J+734ZeUOz9Mp8XHKn3AMMJKHw5ScfNWl89zlFUW/GZsvuHt+/E7cmC+WAQeau5WBzzWdh8XQmGm1gnVfp0UgWSS2QaybCWAoHZnTnAbnL248IYNN4MTwrG05QxriVGli0HoMHfhXuiypqsHoyikJYNLLzifWylMGP8346O8j7JIclGMxdHPTdYHaXjKRXqA8f0jT9b5GHHSRSMafE4AZIQ1btj9NjTcx7dM6OnBLd1qNgve+l2H5m9figqw65aRnjEtxZf1hV10QQuCldPoVqskTmhOFt8B3BX5JWUHV2kDwkMzwmNJz63JGgVrMe4Tx1SqVlw7+SGBKFo08C1kH0R3CkRGvwSbjlqysbTywhJi1tsfbVQF/nLFQ5E1gbESu4/QcPAj3wKdGCtT+t5uWKVTDgf2Q8tBLUr6HWHz4tQD2XcbvBjQ1P6PSGGsv+z+hRkq97x1rRU0HVYrKt9r8FAnH8B8tq3lQD0k9/3UYhElsTjnUSix+Hf1pDi2chz32XoYmH164flJfBCmhZpL8JSQzL4D1bXYQK6WBB9BzqUi0jArYbDGXDYgDc+608kWRgNfvmhibjqAZxWgA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66946007)(4326008)(66556008)(66476007)(44832011)(8676002)(2906002)(38350700002)(38100700002)(52116002)(6512007)(6506007)(6666004)(5660300002)(8936002)(7416002)(107886003)(186003)(4744005)(83380400001)(2616005)(316002)(6486002)(86362001)(966005)(36756003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yVUKtkAK8ZgRR5qD3QPEqe36RS/C1aHnWz0EXzb7qPAc/Q44HnMfsk4yig9U?=
 =?us-ascii?Q?UYGf39GcIeUSTyNl8Jx7NY1Zj3qsTLT9mzpBVuEga2T+fnKaZKbcLbomBXrB?=
 =?us-ascii?Q?m8Ki4NVSLhEyhhJj3v/BPplgFbaFJtBh5jJFwHsd2MXWFnKGPLRuZnHrydi5?=
 =?us-ascii?Q?igsm+zX1auCd7Gg+/k4K9YQjUzm+yH02pe6k4QRG3gwJfPM9cyph91UQts1L?=
 =?us-ascii?Q?KtBUUaok0USqlevPRI6+z7zZqJnngqxAiZLBAR6NqYbUa0YTpjzK5FTpbaLp?=
 =?us-ascii?Q?NBMQ5TjGzSa0jJpk4cluVQ3gyc6YXCmwQECzMUXNlmKNKac9kuR5C2L/Q5qJ?=
 =?us-ascii?Q?EEqiK2HC3RjAKTpOIiVXDgXyY7JJh7RMMjcYO/woKWbHHdX6k/s17bZJ1HxI?=
 =?us-ascii?Q?Dizwsx6djU+undfhJo7lg20tMLog3ouw3zSY0idN1OR1iybTHZ2utqAjwqiM?=
 =?us-ascii?Q?2lIp/f6rWpKGqEEEc3ce3b47gxodaUWDhh2ML8IpXnR2C71oDDJZB7jO5lpo?=
 =?us-ascii?Q?09mzg0jQKkRP8O8k8P4Pdl2K1KT5meU9+qRfRc8c14+VuGWtnVukYre3Y3uc?=
 =?us-ascii?Q?2WcJVAdP1+a9jI9m6AVBbncpJC82AGHNeepdN4eH28ylzWI4EyKsXXAp/BYF?=
 =?us-ascii?Q?/8hxJLqvRLMmCSQfXZqPR84XtNObIB/CR6XJCcYp8MnWTFTX/EgLsnhWuvfG?=
 =?us-ascii?Q?tuxYoKpq3jAv9icBmGEBqztudZ1vr4OcA8AXB/gfLxrYO+S3/AFl+Id9TW+S?=
 =?us-ascii?Q?pXe9vv2JchwAhVIXGUbq3t4qtDJ1jNa+2ZZaiyFK1ZHOSI8E3ZL/ea6U/FPJ?=
 =?us-ascii?Q?O8jWbhKpuwhaRxYQocMRF78FJdsrLFUsHguud5uM4cDDHJESRzu7gPCoCGog?=
 =?us-ascii?Q?4uV6xuboOd5weQapin8ycNe9YkueldUFamYiKwI9F6EUiuGPiiYpWbZz0z+y?=
 =?us-ascii?Q?iB3/NWnLOIdkAkdlZymFPo/NBLppp7P5ADM7PwzL7OL37B+QG0ckT88tj7hN?=
 =?us-ascii?Q?eGvcT01gJesKNADTmxL7YLAT3yjSh4UXfpizRIxFMljPkPjx3q/FjKgvgga3?=
 =?us-ascii?Q?WdDiIepwpZ7vsCRHw1Y8oTjSYUPlOHJYQBmkyOwQzYzOjjZPqI2eZEttbdl1?=
 =?us-ascii?Q?rHoxjmeRD31fDy2I7ERUIUvHdKUyT8seerIeuCjLmyEVVKTNL6M/WLDLCV/r?=
 =?us-ascii?Q?43QBXSV5lmg0HBzjdBszofQN1l/Qu0zSXU0MeZ9e+WBbxXo+f4frNjCbrNXS?=
 =?us-ascii?Q?ZMY/vn/m2+D2dweXzmrovnh0uSEp6ywRn3vyEmsUxzqTHq5X3dq3T8BeC6mk?=
 =?us-ascii?Q?YSgQkaZAQAEKkxXFy7ycwO180GQUw8EXfpUYWroN2D59qjfhz4QVjE61RF+f?=
 =?us-ascii?Q?U6+MUZq7r5VEMdjlcEQ905HJz8zT/XDEZFZxG9HqmGJBfdIof0kf0DH2zYfk?=
 =?us-ascii?Q?UCvrHDk3RQhZJfRTldRjdAQCqFt1ccKKyM2hCxpEVw6dn6nIBMUrhe8Ax63R?=
 =?us-ascii?Q?lnG+KystFRieXRQnOCD9XqghGLd4bOqfYOCESSkiVZsH06Gu6nzIc8TjnIM9?=
 =?us-ascii?Q?JoaQXrgJJ8XoTUF2RaAQaitY6YRStKMAmJf6p+h/2+vwnHS9pFMNnI/kv/cN?=
 =?us-ascii?Q?EDvq53Qejx4CrIRFK4BSXFoM3qZwRvG+2e4rkeciUwcRkHFhLDrfaJYGuOAY?=
 =?us-ascii?Q?zAzqxXXr9Gyw8v6yAkRGZRqXe4eZ2djsX2jQ5eYTM0mGcW0oe3WZZHNNZyCl?=
 =?us-ascii?Q?y2IdcIyza5PX6fOwaRoCENihPzM3IS4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b2c17f4-4e2d-4b3d-d8c5-08da174dad29
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 21:46:01.3714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r5mKcIwNzJDb13z6cuV/d5tRr6zhB5byAoWC/xGPQ0Z2JI5wAafhYRRCfz2Diwcg9Sv+/5946e8MY8QCFrEZ5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1362
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-05_07:2022-04-04,2022-04-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 bulkscore=0 mlxlogscore=748 phishscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204050119
X-Proofpoint-GUID: ynqb0Ji5PPW4nA9VYJbj7mQ1pze5CQvX
X-Proofpoint-ORIG-GUID: ynqb0Ji5PPW4nA9VYJbj7mQ1pze5CQvX
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follow-up series to [1] to address some suggestions from Andrii to
improve parsing and make it more robust (patch 1) and to improve
validation of u[ret]probe firing by validating expected argument
and return values.

[1] https://lore.kernel.org/bpf/164903521182.13106.12656654142629368774.git-patchwork-notify@kernel.org/

Alan Maguire (2):
  libbpf: improve string handling for uprobe name-based attach
  selftests/bpf: uprobe tests should verify param/return values

 tools/lib/bpf/libbpf.c                             | 77 +++++++++-------------
 tools/lib/bpf/libbpf_internal.h                    |  5 ++
 .../selftests/bpf/prog_tests/uprobe_autoattach.c   | 16 +++--
 .../selftests/bpf/progs/test_uprobe_autoattach.c   | 25 ++++---
 4 files changed, 64 insertions(+), 59 deletions(-)

-- 
1.8.3.1

