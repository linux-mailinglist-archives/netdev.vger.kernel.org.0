Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3FEB4A4B84
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 17:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349656AbiAaQNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 11:13:08 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:41196 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1380229AbiAaQNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 11:13:07 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20VFx21m031412;
        Mon, 31 Jan 2022 16:12:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=mvEtoXSlK+vBwzuJvftLxHyKs3OcSq27RIKe97b2jqQ=;
 b=unKY/XikkXn84XaU1Fa2EdMnxwBpzYaGyz06uZWV7jMrj0+K61o/T2vKIcXG0NAZ2Wqg
 whMhyQAVv+81GSAnvR0UezTEz2lI8cemHlsVvpKPy+B5sgXJy36FcUyKI5GQZmepeLF0
 mlo4+C7zbjOQV/uA62CMZYUfPTxVJsXlnwOY6seb8gD8sgYyrSbG3GTf/qXq9WHqbnKS
 cPh8LBpODuHD+alkrcH1QU5zUyRDs1s3fURNaBrx9ljdcYXwx5v7QsIWxntrt4ys8Y4G
 XaLd+OAoXAvcM0wa3tyqxNFOl7cZPOXTeFILCQs7tTs/3RpcP+zfV/MNzNrUTLWrJY27 mg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dxj9v86de-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 16:12:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20VGB6DD195237;
        Mon, 31 Jan 2022 16:12:44 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by aserp3020.oracle.com with ESMTP id 3dvwd4j528-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 16:12:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L2nXLtZWA9k+wS9LX6o/6vCIyiPTJQnu+ow3qCaQ7Yp/OXRNbNXGcE52sScYk7Yr2rEo0OGjVz67l8YL9QhmyUweW9287dPa9CaVm1eNO2lwvnMHcKDMb9rw0avxHAvv33A//JfvipFScaoIjK1BAnOsojfcTX52a2OvSsuqUjwSA+R/JpHkBmsJAyhv3wS+Za3YsVdVRYzMwqc0vn1qYPLMJ9rYRbebyka0ByPaoz8CpBKE+GQc/N0T4thxuOiLC06r+1ZaULR0IjB6SWH+GWlqnz5NQuoH24oS+HtWam5fwQOtBc1O36Jip2ELj3xRWXUEvh4Cu9N1rfNlqAi4Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mvEtoXSlK+vBwzuJvftLxHyKs3OcSq27RIKe97b2jqQ=;
 b=MNjEo1KQhEU+wkZDVRkb2Zqu1r7/pp+OJeP8I9QBqdiRIq5I2FQ7PJK2rjO7eu7ewZwVaH+HR9xyzklBhXdd+3ytqZNwaWJTt5CJOL2pGvn/zWrIgodblsfX9WJ7VBrIrf1djPm8qkAOUEC3mKTViLMtEDFFaJCH8mplycktOImIRyrazT7d3z4jfsQQb3OVQk4nOaeIgegu0kAVG/08GOczQQh5Ycx8RNPVxyCqszF3Go9xDSpJlmyPN1IJg6HARvD3QzTeUD+LPeMlWicXufHRaeUCs5LpDCp7Fm6pZ0nE+ajv3aCLfEPySAgcK4eY61EenM+ZmE2z8gaeG8T3IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mvEtoXSlK+vBwzuJvftLxHyKs3OcSq27RIKe97b2jqQ=;
 b=BDl30LucZ/HRtwyOWlgdXhsY5cRLESyTHvAO4mn2x01vydUY/uzxPPAqfpokbodvw7pMxCT3ZjWRbMpa1EQ0E7qHf6WYIjprkftqZfIFI9qZ3itZfm9lxg1uGPfnPfUB9ixLDyR14HrBxckN4rtnx83lp/ivbdRl64BimeVLCxo=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by BN7PR10MB2516.namprd10.prod.outlook.com (2603:10b6:406:c1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Mon, 31 Jan
 2022 16:12:40 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::49df:513e:bdbb:33a6]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::49df:513e:bdbb:33a6%6]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 16:12:39 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, jolsa@kernel.org,
        sunyucong@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v3 bpf-next 0/4] libbpf: name-based u[ret]probe attach
Date:   Mon, 31 Jan 2022 16:12:30 +0000
Message-Id: <1643645554-28723-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0124.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::29) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 371b5202-2603-4a37-9477-08d9e4d480f1
X-MS-TrafficTypeDiagnostic: BN7PR10MB2516:EE_
X-Microsoft-Antispam-PRVS: <BN7PR10MB2516B1E01BB43BD3EB4F2D8EEF259@BN7PR10MB2516.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VH4Y1R4xqGWR8teFVCR0QdAWpg2dK9sVPpTN+mvquVXk04Xlx8Ld+6uIAixvbvPdmJkqt1Jst92iDx7b69k2LgPA3m43J2802j2zIURz0TGJOcVOuZMjftVAJfbf55FyWzjWXegvxbQ8ujaHcrpagGSBaicUXcoae7CUpMYkOmHiLZ4qvgfHLUsxT/Fb1kJp0OEYzgGSfK1S0w35EGDg/O5y4djDk+z2Eq5iRcbz4ESODd31qx/AdWxKDMVc5Q585J4OUtxytta6bJY0E4WKGNbWVDxk+tppuowDnl5fZe0aGQ4+zaZTV3nLzsaUfnsRbFs4N0lsCtgc3L7YXU7NJtHLCloy8mstMIk2L9nFdIgluJ5b6+sGzYcZePombr1dxnkIQz/VK0s0HB+3N70Q0q7dnmCriUusPsqQasme2sgjzFFgG0UCSiXZVqQlp3nOAWIf+OUgzlHHZYmz74hv/fprtJ4D24DRIte6PxnoM8sWu0AukEao34DcMhPmj1H6NbHdox/pmekCVe194DOaVCiWMNvbWivF1eYTTxRth8Meox8L+R1cp0JYuwnmueNRfDFZ8kq/BVtIPhq9c98i4pSg8IsrUCDQ8UjoFQVd0/NHC3ZD/3eeVxl3iP3p1eNdpW6/JbMaDxtXD9hNRSkE9yigebXXY+R7zymFt2C/fVql/a6NbjZdh9h/wNMXsj8XGkO0YIwuPTz9Pmr1+NzN3iXRvAQ1567X9OPYIvZtUoCezYrNgaTrp8Vjwd8EZUssC0+t/zdilIZJmFG5b0x73GBxA/PQbbnwuLzLs91/4kA0Wya2n/wFKIpbdEJl3wJk9Btl3ub76EpEx2P/ObKj/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(186003)(38350700002)(6486002)(38100700002)(966005)(5660300002)(6666004)(107886003)(2616005)(52116002)(86362001)(508600001)(6512007)(6506007)(316002)(83380400001)(44832011)(8936002)(4326008)(8676002)(66946007)(2906002)(66556008)(66476007)(7416002)(36756003)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9de6mraL0Q5JhExVPHkNTcrqz+OC7VvKPVxeBCIGoGAdF5lDS6T3+fQPTSl6?=
 =?us-ascii?Q?W6vhGs4kfs8mayFxlFRWpdjhXgx3ab5eU8mmUhIlOMjtonlaraBVaowjaYsr?=
 =?us-ascii?Q?VZbYZq2kREdGfEAGfqS2cRiXxKft9bEDch7K+PUa0+7aAMlvJfheoOz4n3NT?=
 =?us-ascii?Q?9VYXfeanfviZAMeCsHBYaVtj/CQ7GiR+DXL+WMgeeSX/72PR+45zYPhkgvfe?=
 =?us-ascii?Q?C+HwbC89Pzb0q6PraYtmKUTUNstEfjYtG/FlKkYj9+qLiO5R5Qu0l9s18GdV?=
 =?us-ascii?Q?EU9xnMjf0t40SYxezkrfdymz9z6tY6JawoQa5SaxdMHfMDjwnsJxITCxkUj0?=
 =?us-ascii?Q?Q5Ra4Sy8tQUydl1aP+e7g3fQAu9omUxb4z4O8JDumV2fUix20PNJ5e6Cb/C+?=
 =?us-ascii?Q?sHs5juBocghBtXsSwbFSzWuJD5xz/vjISFzZhDeaw/v+dn4n1UJN0ak+9hby?=
 =?us-ascii?Q?yrf7VWpNqv56RIgpm+qGQ7BlaNLMF96Nyg11dd1CcswaoubY3iAhASGBqdWP?=
 =?us-ascii?Q?wcPaHMyJen+Zm+rwdOinQfOfOs2dbsHznt9mFepKCjiGeMNlyMgdZmWBViLu?=
 =?us-ascii?Q?XIvjus1vK8qkp6Lv1wD+UaNtZkerPZlXnXVeWgEG3KXOvrb7vy9f0gjtDa26?=
 =?us-ascii?Q?EfH/rWGeV9/sBe4c948vjWixu7jz8Du5aIeAdhVfxTs2jmONpZH15qXCSqeB?=
 =?us-ascii?Q?VFpZWjxuIbHx2juCCLtUJcCLZ/jaqNjhJsFpW+6nOXVub5pOqn43GhfXH0JE?=
 =?us-ascii?Q?s6Rhid5rv+ceg6Y5MSUUzOFyalH/N2lhHhrK+tGytv1HcHxGlgfiJwaPcic3?=
 =?us-ascii?Q?TvsjWgxhNTLiMFqu3KateMW214PE/RdgW8cFvOJYbxPJMpkcC5joQBEkN5GR?=
 =?us-ascii?Q?EggmeLNEDW6jgOoj5uYuZUgkVWhRc9egJSRQ+RCyVBcblSIdYqLVmqORR62d?=
 =?us-ascii?Q?A4OGS1bAAKWQljOuOBeHyjj8mlL6E+eIk5k4r+3BlDAUGQ0KIBES/BNsP+ZN?=
 =?us-ascii?Q?E7evOaGoHjJaxKsOx1XNgFNdalcAL4STGTNB14mNiIKh5CmnkCEICKxSJzRn?=
 =?us-ascii?Q?wtQ/oWrnD7NBOx1O5MRyMevDQeemypywq8keKSJlDDoBTmgHBNXTkWY7Cn97?=
 =?us-ascii?Q?X1sTDTc/DJziUuhVYKg2eR6b0cpKB/fQXo3t6U+78cRrGTSPdPAz1fnxDrww?=
 =?us-ascii?Q?Oah43NC4JnqLmVlD710765coO6F6uAYBuFdUESH6nNJ6Vd7jQy9CcTvln3MM?=
 =?us-ascii?Q?D9hfvH8fsUmsl5YvvTiwY9dkiUbnUMux7Jkj4Tktm30NiCdJTHQh57FVYElH?=
 =?us-ascii?Q?OSocULl1PRbOWj4t/4E+nV58LFWKjTytzxeUqY1gj1+3ATMA29mg8VmhGtEQ?=
 =?us-ascii?Q?qQoakZyxejEZ+RiCDexGbi0gSBk9rxcnz4J6dhpDRULjIpwkeXGiYZ0tDIxp?=
 =?us-ascii?Q?SpjsaANmNgO8J+uiz72gEbfxOeXGob6UYcDzt6w0DPmO22Ue4jh28wiy5dIX?=
 =?us-ascii?Q?twMSTrRqhjWjbceSgTXo2yMpfForTsAgDQTGCqCJ1JklzDsZxrQkmw8T1o8y?=
 =?us-ascii?Q?nDk/VyBudNsNGxFtzJfbAlJdYKLwKwIES1Ol64KMRNWCcGqSv6pd5BV6pPZJ?=
 =?us-ascii?Q?evQwWreD0DvhKZFEBDX8W5Q=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 371b5202-2603-4a37-9477-08d9e4d480f1
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 16:12:39.8869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ciZCP0wkwdpKVQA9itl10+hc7bz4REK2L5IxxFhf0V4b/fj3i5vJg2uYIX8stZi/uKaZGCbFBASNPScQ3+cPSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2516
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10244 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201310106
X-Proofpoint-ORIG-GUID: ZJc37SiwD4v7CNgoWn0s0A9isVGLZMdq
X-Proofpoint-GUID: ZJc37SiwD4v7CNgoWn0s0A9isVGLZMdq
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series is a refinement of the RFC patchset [1], focusing
on support for attach by name for uprobes and uretprobes. v3 
because there was an earlier RFC [2].

Currently attach for such probes is done by determining the offset
manually, so the aim is to try and mimic the simplicity of kprobe
attach, making use of uprobe opts to specify a name string.
Patch 1 adds the "func_name" option to allow uprobe attach by
name; the mechanics are described there.

Having name-based support allows us to support auto-attach for
uprobes; patch 2 adds auto-attach support while attempting
to handle backwards-compatibility issues that arise.  The format
supported is

u[ret]probe//path/2/binary:[raw_offset|function[+offset]]

For example, to attach to libc malloc:

SEC("uprobe//usr/lib64/libc.so.6:malloc")

Patch 3 introduces a helper function to trace_helpers, allowing
us to retrieve the path to a library by reading /proc/self/maps.

Finally patch 4 add tests to the attach_probe selftests covering
attach by name, auto-attach and auto-attach failure.

Changes since RFC [1]:
- used "long" for addresses instead of ssize_t (Andrii, patch 1).
- used gelf_ interfaces to avoid assumptions about 64-bit
  binaries (Andrii, patch 1)
- clarified string matching in symbol table lookups
  (Andrii, patch 1)
- added support for specification of shared object functions
  in a non-shared object binary.  This approach instruments
  the Procedure Linking Table (PLT) - malloc@PLT.
- changed logic in symbol search to check dynamic symbol table
  first, then fall back to symbol table (Andrii, patch 1).
- modified auto-attach string to require "/" separator prior
  to path prefix i.e. uprobe//path/to/binary (Andrii, patch 2)
- modified auto-attach string to use ':' separator (Andrii,
  patch 2)
- modified auto-attach to support raw offset (Andrii, patch 2)
- modified skeleton attach to interpret -ESRCH errors as
  a non-fatal "unable to auto-attach" (Andrii suggested
  -EOPNOTSUPP but my concern was it might collide with other
  instances where that value is returned and reflects a
  failure to attach a to-be-expected attachment rather than
  skip a program that does not present an auto-attachable
  section name. Admittedly -EOPNOTSUPP seems a more natural
  value here).
- moved library path retrieval code to trace_helpers (Andrii,
  patch 3)

[1] https://lore.kernel.org/bpf/1642678950-19584-1-git-send-email-alan.maguire@oracle.com/
[2] https://lore.kernel.org/bpf/1642004329-23514-1-git-send-email-alan.maguire@oracle.com/

Alan Maguire (4):
  libbpf: support function name-based attach uprobes
  libbpf: add auto-attach for uprobes based on section name
  selftests/bpf: add get_lib_path() helper
  selftests/bpf: add tests for u[ret]probe attach by name

 tools/lib/bpf/libbpf.c                             | 327 ++++++++++++++++++++-
 tools/lib/bpf/libbpf.h                             |  10 +-
 .../selftests/bpf/prog_tests/attach_probe.c        |  89 +++++-
 .../selftests/bpf/progs/test_attach_probe.c        |  37 +++
 tools/testing/selftests/bpf/trace_helpers.c        |  17 ++
 tools/testing/selftests/bpf/trace_helpers.h        |   2 +
 6 files changed, 475 insertions(+), 7 deletions(-)

-- 
1.8.3.1

