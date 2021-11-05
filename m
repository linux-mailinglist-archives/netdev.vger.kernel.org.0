Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1517446753
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 17:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbhKEQyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 12:54:37 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:41194 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231288AbhKEQyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 12:54:35 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A5G19Wo020804;
        Fri, 5 Nov 2021 16:51:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=o8ZwEHlszaw0Bcn5CtFuvzHW7aMx7eQAv0AJbFFP3VQ=;
 b=Wlo/fVtb4cUjoNBOsFDsgbnOcfRKfIaU31IMZ0z/ioJSX9qrTBXr0bhucPUA07aqWNmm
 9amqAlqR8MPCSIt15NDct3b5wlaUCBDVgdqQKx5Z1Z6+NodDbOAz/BQSsj67jC/Kpmnv
 Pu1p5m5/+p0sIu4qOGtaIvwrA9A8GOCIgV0YvYx/eLRhc7fM03aYsB5VA4Q14GTq/SI1
 4A4TbrB6grVgC14mB68XrGirvFI5hE8Z6wWpDDOGc3NBmJcdQCm9pOnMV4PN7LCO5ms+
 EuP+5UzUpG/q/7uZsmTZZP2UT/hCl3hpQjfX2cnCsGwC5I7fSJxXUapk0CsTHqcN7c+Z 2A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c4t7f3ejw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Nov 2021 16:51:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A5GfBNV124651;
        Fri, 5 Nov 2021 16:50:59 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2041.outbound.protection.outlook.com [104.47.51.41])
        by userp3030.oracle.com with ESMTP id 3c4t5d7hn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Nov 2021 16:50:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=elI1Ks+rfroU8g5hscXe9/X+x213RYNVp0J9WosGTJWJgHUZmVcguzmkzpof2Z25lJgnBSTb5iPtLI6W6/KNrbeOqHA3mmJdlJ7OAcBIV1MtuSxmaxrJqVu0yhmWkhXche6J+bKYapl7Tix11usOiMoJthMJKuZn/d7s3rygwJYzGIne3Tq3HVKWOTPLhGuV1OBc1hvqqXibkYVuADLRyPYNVQWqhwycivol6gjOf+ueCjSXTVQN1hjQJnSO+Vitv/pu6lG0S8+VnjMgsUpa0pUv8pktiSJTsHDS7TQV2DJZQAlyzlOazjiRGSaTCD+aAtTRn3xCqmrKLkP1yv9JaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o8ZwEHlszaw0Bcn5CtFuvzHW7aMx7eQAv0AJbFFP3VQ=;
 b=jl4NuLi9VWq4DU33BxSqd53nC6jqTyNIIkKsKNi62jHzX3t0u3QGn4scfBpCFVIKA6MNQCN5L3ysUJgHt6KtCCifEeHr9lb/umZvEx3RZAXfUgYpaCazdzcFFZ9AuB074YAdx/y7939HWoWQNNXWwOkwrLi3fiMBkA6UE1fBLefwA+CScDEQZhF4h86mtVAB6ZO57UuoywOykBkCKj8C123U8kRpRFWANTSeu2a1MH6FMeUMuLan7rXWySJ2oB2BjxI0ZZJ+G7UwFdqUNed6zWbqY2mYqZLu6D28Bc2cWrxueVBpq8dLKzoAhqY0lIenioTjQ2n/eR+dyOaXp1/Znw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o8ZwEHlszaw0Bcn5CtFuvzHW7aMx7eQAv0AJbFFP3VQ=;
 b=oH6VuKPEyiPW5jiS9NAenvzFUUzdzd61yKhW8H/kRWtD3SAz7g0L6BuDLtM8RVPHUQUzbLCM01q9RQAgO9aa0IJud7nf1umzO0pbBDuz60uOW7JG1udaabTRco03tisNF/vMKVqFlFjQOKiAqROghMqI8oP6rKUsyG7aL+i3fRM=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by BLAPR10MB5300.namprd10.prod.outlook.com (2603:10b6:208:334::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Fri, 5 Nov
 2021 16:50:55 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::998f:e9eb:ec26:1334]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::998f:e9eb:ec26:1334%7]) with mapi id 15.20.4669.013; Fri, 5 Nov 2021
 16:50:55 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ardb@kernel.org, catalin.marinas@arm.com, will@kernel.org,
        daniel@iogearbox.net, ast@kernel.org
Cc:     zlim.lnx@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, andreyknvl@gmail.com,
        vincenzo.frascino@arm.com, mark.rutland@arm.com,
        samitolvanen@google.com, joey.gouly@arm.com, maz@kernel.org,
        daizhiyuan@phytium.com.cn, jthierry@redhat.com,
        tiantao6@hisilicon.com, pcc@google.com, akpm@linux-foundation.org,
        rppt@kernel.org, Jisheng.Zhang@synaptics.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v2 bpf-next 0/2] arm64/bpf: remove 128MB limit for BPF JIT programs
Date:   Fri,  5 Nov 2021 16:50:44 +0000
Message-Id: <1636131046-5982-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: AM9P192CA0024.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::29) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
Received: from localhost.uk.oracle.com (138.3.204.60) by AM9P192CA0024.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.17 via Frontend Transport; Fri, 5 Nov 2021 16:50:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4062733d-81fa-4143-6de3-08d9a07c6f07
X-MS-TrafficTypeDiagnostic: BLAPR10MB5300:
X-Microsoft-Antispam-PRVS: <BLAPR10MB53007F99125AEE57AC7FE2CEEF8E9@BLAPR10MB5300.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:669;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CRq4iwLKDLecpBbvWTP+/IlQiQnzxetjOh+I9j7iE/bt8LbhLCTDehDYzasZSnc+fzM5TH7hYNkrYtQZJXnFJv0La3IkRfCYxW1Z4u4Py9gDrH1597GEsLenIm3x60qXXn0h6H/w/W3559B+dMPs26keWWZjB1DIZIGjzKofIItpUFG1/YHaELSSIIr/lWPbzQl3CC5OF84Ha8z6Elvd+snoFP32SpxcfSXLq9ns72NG5KtsLblFZaWap+nlnNjpSZW520Clxmn1nP15Oa/e9DlUEnqhWGvC4bQ6M3lVKV9sxx6tk2y7rmmwQibbrC7wvU5+di2WUbldGPxKHmfft/R1KO6uTW9/cNmhNp2gMjg+k33Io4SvW7NKVVh75e5BJbkGjRq7HTgOd3NE/UmapwTtQUqJoqk83IIjX1Rv8TS8xZhRO3OJPItqjSY8pKED0IUvGvbwejc8aNp3YMkzLJhXZ8hS9cynSbryNVMafuU68wrTrQrsyyeDlzAAUP0vnBdyVZIK4Ee1zyaMeueHlK6hEiQdVGlbmsofvTpbjnYR4I/ro5U5mX6B9LktNkim5rrM5qsAwtx8gbTExQZ5MfXelE5ZP7mbiyOTsc8zeAI5jbQTVoKDMUC3/hWIwmzIt1ifF+hO8/r34r2uw4x51CTVwSWO5KUu7arK7ANcAr8X6o0Tdf1kqZHQNVd1WXq+Z8/18cXuRFGANFDWqZcYJCFeLNs7HgKG1GVUI+Ny9qqv5aTKhhRKAvvqYpLVNhtdYylpwwwvxgm55rzTcGb6XOQrnWT8ycoeePImTGad6Oc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(8936002)(66946007)(26005)(2616005)(38350700002)(8676002)(86362001)(66556008)(4326008)(6666004)(7416002)(508600001)(966005)(5660300002)(316002)(44832011)(52116002)(7696005)(66476007)(2906002)(956004)(107886003)(36756003)(38100700002)(83380400001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wvj283najdbU5DvM/oFGZ/P0XzAaQW91ptyvZBglg30hE7pGT6x/U4HIVFSS?=
 =?us-ascii?Q?bmmulyWtaYPQgrn1SXAuf1r5jmM3ziKVf+8rvLzOHp0M/POm3IRPuPZW8Bvy?=
 =?us-ascii?Q?TwrO6Tj6Dw/JOX7b78W5Icq25D0B1Y5W+ZWZsKgEThwEQR6K2gKNTNeuBoDg?=
 =?us-ascii?Q?SwCqFymmA7yvJ6/S/GE7Gmn5W6rUMs2dTEH6xT8OkW5zsGXOgowkTX1bkzct?=
 =?us-ascii?Q?ht6d8BkdUP5ccv8K6zLsGORZnwRyEH9Kn9lA7ozf+ws27ayaFyTW6Ia5LpkF?=
 =?us-ascii?Q?XTwfoQSCK7DEi5dXu5sydDik0fZ1tZHBxEtFwOTTxjpAP5nOoMifmtj5yJvI?=
 =?us-ascii?Q?8n6h2A8LtW7QcTt6aaK+UvHY1Ir4hTGak8ENeA0Dg+qgb/dcLOodoRjRUD7B?=
 =?us-ascii?Q?yDdWxORsH02kiyWioxbcYfe9lng43+9ocThBd+4gNHKItbAbpctG3PClIDVJ?=
 =?us-ascii?Q?BCetUAdC3q1IsFj+gBRy9u+RC54kdoa2i7cG8qMWzOl8b49d2dSpS4Z6UCaT?=
 =?us-ascii?Q?KfkOK4HNNBQLCSvWVZC/6akm+gXsJWVTe44dWcVBG/ryNPNBn5PcbXPZFsds?=
 =?us-ascii?Q?ZsmGBMbJomb0WcydF9rniwapnSSPdXj7oxArnRkkDwH5MZ1qG7aeuD1Yj0uI?=
 =?us-ascii?Q?amqaZpO25GLaR8jj3yGd4O097/IadKp205Zly7/8MOrESlBEHa++8oGLWngm?=
 =?us-ascii?Q?IQ0Kk/VC/2NcklLgPOgWyhpNhD4Eoa10/CmgJT0iyBiZrUSyrYotGWY7PoSD?=
 =?us-ascii?Q?pWZ+OmU9x/7sJt01uslbpiIIFIDLUJ+z8+CbSLWX8/n4gd69JZ4RmGXTIdpz?=
 =?us-ascii?Q?UjH04ViTqAA5wNWNJiolIaE3s8yapCf0N+SJpB7lt80XYIrL+VIOrbdwMtEd?=
 =?us-ascii?Q?+i5PER9D1GUY/X4yJYdzoChEFv/OW1Fhbx5qMo06ByNpPLcppOr9XXX91Fa0?=
 =?us-ascii?Q?K53N6vfE8yL/oSghLCjxRFBcRW6QiZLQy03PqxRx8o8j1jMCBeV8XWMNuFoP?=
 =?us-ascii?Q?oE57J38NXNq4ilD9msKAXxd9G7S8uaDipOwGiYHd+QoWn4Ne0jShz67oxK4B?=
 =?us-ascii?Q?KNz7OqsdaLBtgmgsQc2PGCOwm6ozrVB4pzreO0y4jdYcgQD/Zjm56pXHxJca?=
 =?us-ascii?Q?7Xigqc1DDCa4mnyQ8C0M8+YbdTRsF4Jgkt7N9I5eS9jsZK3TysPyJTt3QCIb?=
 =?us-ascii?Q?qFp5vpqhyvqwLMn/q1aXvRXhEdJs/S/1rfsIXMW1H2pZ4Tde2gff2myIjEG6?=
 =?us-ascii?Q?1GE2ycIJsWprdeV9mPHpf2zWGtMzf0jdem17U7BCPOCCTSVms1QGzvFduVRK?=
 =?us-ascii?Q?9qnRmIbaoMtawNcTe2cZQQdPKgatKOTZCalHUTjSPuu6uLZalqjRSZcYzJa6?=
 =?us-ascii?Q?jr3OBNraxxsKI4er+6QtCG0Q6RBs0d9GUihjRJnbeMZ39benRq+d1AxdJ1fj?=
 =?us-ascii?Q?E60uWheTMjlbABtqzP1EgjAswsJwqwHnmyAnTH7pcAKiZPtY9k47DKhkynaj?=
 =?us-ascii?Q?ZpA1hrvk0WnmnePS0jXwQwGCDayF+FEfjTNYFmdYvG1LyJtK9i3W93Ip1F+H?=
 =?us-ascii?Q?d8NHoys1BUEiBYHyBrer4lDfzkn4FZAGDEwy9nKBGBek8pSkY+2Z9T2Udrzp?=
 =?us-ascii?Q?wNh2DZVlQLLUGbHTYRQ32OM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4062733d-81fa-4143-6de3-08d9a07c6f07
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2021 16:50:55.1938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iAM1MT6aC7YcG+wD1KKVdv433ivo+WiwYGH+8w5PHq1G2VMhirnSodn2HcqpA5IM0Dpdy1zXIp+ApacLz8yLAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5300
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10159 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=769 adultscore=0
 suspectscore=0 mlxscore=0 spamscore=0 bulkscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111050094
X-Proofpoint-ORIG-GUID: tLHhgT1YmoCQS6J-YUaCE2CrlGlHC0FQ
X-Proofpoint-GUID: tLHhgT1YmoCQS6J-YUaCE2CrlGlHC0FQ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a 128MB limit on BPF JIT program allocations; this is
to ensure BPF programs are in branching range of each other.
Patch 1 in this series removes this restriction.  To verify
exception handling still works, a test case to validate
exception handling in BPF programs is added in patch 2.

There was previous discussion around this topic [1], in particular
would be good to get feedback from Daniel if this approach makes
sense.

[1] https://lore.kernel.org/all/20181121131733.14910-1-ard.biesheuvel@linaro.org/

Changes since v1:

 - respin picked up changes in arm64 exception handling changes
   which removed need for special BPF exception handling in patch 1
 - made selftest use task creation/task_struct field instead to
   minimize BPF selftests parallel runs, moved from CHECK()s
   to ASSERT_*()s (Andrii, patch 2)

Alan Maguire (1):
  selftests/bpf: add exception handling selftests for tp_bpf program

Russell King (1):
  arm64/bpf: remove 128MB limit for BPF JIT programs

 arch/arm64/include/asm/extable.h                   |  9 -----
 arch/arm64/include/asm/memory.h                    |  5 +--
 arch/arm64/kernel/traps.c                          |  2 +-
 arch/arm64/mm/ptdump.c                             |  2 -
 arch/arm64/net/bpf_jit_comp.c                      |  7 +---
 tools/testing/selftests/bpf/prog_tests/exhandler.c | 43 ++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/exhandler_kern.c | 43 ++++++++++++++++++++++
 7 files changed, 90 insertions(+), 21 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/exhandler.c
 create mode 100644 tools/testing/selftests/bpf/progs/exhandler_kern.c

-- 
1.8.3.1

