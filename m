Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFCCF4A4B8C
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 17:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380124AbiAaQNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 11:13:32 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:63844 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349709AbiAaQNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 11:13:10 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20VFx5mI010613;
        Mon, 31 Jan 2022 16:12:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=IcvUWVkBXSJVXiG/GXrnRKhgiKEEGhz0Q5TSiYjSw2M=;
 b=qEdxRBRBMj+1+VwqC1YxtTZV8GyKoV0rs/XDtgiQRzX4cdO6vPFg630n29XjNCt5VMbr
 VdexQVM+Mhi3ffgLpC0fINmAXzI2IgnVgAcLlVHkur/lGrbM236WOXYCZBOlhRaiQIEF
 21So2Y8dWjM8QNNGQSp8AoWAiq5Tt06DW3HBAaiO5BPbx/0YQGz2shP1tsjkqByN4XNz
 LyEiwgS1LoQ8u9/uw/I8kvUk3OiO6wDhez/hvyRWHW5npyfl3/nIpLdEtHQiKaiR3F9/
 DhE9aQb6reR6bC+CvujJeoSAGbP1Qx7PptaJcnYDqjW9gFN+iy8BZe/naMX+dEV4OCIi dw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dxjatr65q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 16:12:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20VGBbKq115119;
        Mon, 31 Jan 2022 16:12:48 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by aserp3030.oracle.com with ESMTP id 3dvumdt0p1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 16:12:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xhz/BA/CEE3wTGb0f14qyTI6U9BhnVciQoChjuA75mTK4TjYRFNF8q6avxIVwL+5ofjaeed5Ie+1lhUh9fDFqgvVnI01ANhruAkdG+nZdHn8ZYO6+gNG9hHY6ghMmYFiDd6RAup0/UYgijfR+rsjxkLoNF6+MURYEbjeQDROsrSpOMwxVcKwsD1u6rkrs+DuazJ1XmO05JD55tJlVwYY17tbLaCN+PaWROIAYP/ufQn95FEjjmrjoAfE77YlDCq+iLMGCB3fVngSDWWghmOXJw2sH2JxZUJM6OvJOJ3VW0VDh2+bXJRuwuqxzIXuIgkSMbdN6iNCvr8VgdK6jK4rUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IcvUWVkBXSJVXiG/GXrnRKhgiKEEGhz0Q5TSiYjSw2M=;
 b=IztMRcAltlrLJObDCVo/L0DjmvBf1QkfMUW7VHwjzWyD/kF9+BxR5E9NAsmFf7rInXtIudkFQTQvglAhQmGvegq3SyDtyWWjkGTmVGcRlNoxNqdVO5M0YE/XmtNo45nLt98f6lpGmLdWyJgf8zk0h2sM6ui2XvWduxblSVX51YMmO6KTZQ2zl3dMI2laKkT4mCKYDjMrHJrU5K8WCoH4JXksKWI5SfnmFkwhM7YktjVm4JnPn4aOiv47dlTj58xl2OTmzFzKSMw0tBWli3Ce5DDKSQSRwykCYCRP4QDXNWfbU7tY0iMYT9PU6i6xur8TuuV89SHkUIvjvWMbBfsKmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IcvUWVkBXSJVXiG/GXrnRKhgiKEEGhz0Q5TSiYjSw2M=;
 b=gl3RUSwaWu2aZtAI+FV5vEF8h0q33lpa+DRpwYfkJrt+Qw5DHunMD3+kC4ItouS4ZX01etXfvq1vVw1PTBIQg9teBx71nKWqRp0/XLpvD+DZ9nzqwQsyClmATX7p36KheUcHhOsyhgmnZ8OZld7fUfcbin+BLYJlERWWjLv+tlg=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by BN7PR10MB2516.namprd10.prod.outlook.com (2603:10b6:406:c1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Mon, 31 Jan
 2022 16:12:46 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::49df:513e:bdbb:33a6]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::49df:513e:bdbb:33a6%6]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 16:12:46 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, jolsa@kernel.org,
        sunyucong@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v3 bpf-next 3/4] selftests/bpf: add get_lib_path() helper
Date:   Mon, 31 Jan 2022 16:12:33 +0000
Message-Id: <1643645554-28723-4-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1643645554-28723-1-git-send-email-alan.maguire@oracle.com>
References: <1643645554-28723-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0124.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::29) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 431236d5-086d-4d57-f375-08d9e4d484a4
X-MS-TrafficTypeDiagnostic: BN7PR10MB2516:EE_
X-Microsoft-Antispam-PRVS: <BN7PR10MB25160CEEA9E2A18443D2B052EF259@BN7PR10MB2516.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:556;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3FBVObPIxtt/+te2ZyMDebOL3JzHHQmSicEYyK7cC2svXPGWw6YJFvXErhGiKpS2SH5YTQnUHqbgseyLPEPsLb8pVfi64/ZJzmue+Hh+4UcUWr/4ji0eqt81SULtoa1iSE6XPTUqSR616JSZ/6DZh+e0mDYkzgno4nn69lMHZkFj0CjB/6AvPp3XGric0P4XHOZK3g0MdW/bDEPJWJvRcCnCiS9CGYcKUQuza98KkbH59nO+PKsdi0Pyw7ZNw2J8r7NU24/x4DK3O+LnuBxTyoUon/wF5nAZyR8GqnvhQP5ot1++1YrXxC5dqqqNTOUyMWruaUbCt1qgrW9KxuVld5eQ3jkECmyqPXhMHZzumOguFUe7qNIQNvErMXImofMS1qFNAfjM+NsbsnmDikhdWeATGnUxQEaKuy2yN/LS6Dh8Fa6B3k2JSH2aCQu/yYBCs7Na+B6bcSkY+L0epmtVBdwepm9+Pp6lJVuKAMBg48+qS2BAndjtaWQwVGHHtrKkRYtqVjKLvdCg6qs0F2lFLyVxIshWVnNYEswcv1EmAZ/kMdej8r257naQGNkTstD3QrrqsoDoBMf53Bmjxxd9j8yy2SaGcrLIUbLh1yGixDZHnXXmpLq5lBC49MPuECQpyDbGhGK0iRd5Sfj3PItGSajU0/ISDWurGZW5TQuGXh4ciJgTTPtajuHQvEmTpDZaa0xNEJoz1SkGYnFaHNTV5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(186003)(38350700002)(6486002)(38100700002)(5660300002)(6666004)(107886003)(2616005)(52116002)(86362001)(508600001)(6512007)(6506007)(316002)(83380400001)(44832011)(8936002)(4326008)(8676002)(66946007)(2906002)(66556008)(66476007)(7416002)(36756003)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W34pPSGszZd0DEq/Fw1Tlzn5wmtJnj9Hz9+yAQP+jwLdrcjy0nijMZPSebjP?=
 =?us-ascii?Q?VF9P8Zy2eUcHv1qpP9HI71DEBFSNZDJhcbIkYkLqDJ3zbXaYE3cUu09r0mB4?=
 =?us-ascii?Q?P0Fr+YRCYG2gh0avIqRbeQCOtsZFjyftClHZW86znFFSKUTKYf0e+rL+v1KZ?=
 =?us-ascii?Q?okZ+3NVaKqGeniv2qhnqp8skoLGqFpWdKWZplFgKX43Be2g8GjCtPwPTxvXp?=
 =?us-ascii?Q?NgXX3bnZuYEC9V4cDKC9AA1I1vwgsJHdXSg3fQCREeXnYXprQ1iwheFO4UmL?=
 =?us-ascii?Q?JiWEqTPkkftNhRU26pFvEt/VTZLEg46C8HcfQp7ijubt3uc+QLa5IZRu8DwG?=
 =?us-ascii?Q?bDISKhY8XfQFHnNSRgBwu2LFTFlQLMT6h6U8R5s6jrVy5C2dVDGkL7ZUfCFQ?=
 =?us-ascii?Q?v0csqFQHNCSyD2B1aoQA7hL+RPhE0j3y41PGdWnYwYkZJihjSp46ky6deFqb?=
 =?us-ascii?Q?kdYJUwqaimo91iB/CPVfR4ary6ElO1eIzlYVWPViRd7wbU++vG6pvb2GG1fo?=
 =?us-ascii?Q?xPkWWTQnFl8Cqc/oCMthHHlXuqV4rNaKod8f1/2dj1+5vJdOH9dsFPZ7Mb26?=
 =?us-ascii?Q?UrEm5QA20Kg38n0mvbGH3GCKfbuefA1uk4i97D2bB5rIPrtE8C/hq0nyjEGY?=
 =?us-ascii?Q?GuGKfcN94gZnPstin6Do8smb7KuUBBAIWMNyJd4+b7MTrkC4oaANPxD0Dx/+?=
 =?us-ascii?Q?C/EcaRlNC6eZQpiFAG8NWQ0gVwJ9ppVqbB4ESZfHByOBnQiOs7Ux77yxWIGP?=
 =?us-ascii?Q?Rv9hXC1IIuGjhPHHnlcS1g0zjoJ6jyt2q0GerfU4RGzWePXF0kE4xdyPxkv+?=
 =?us-ascii?Q?d/ucEMgjMVG2RSWRF2JM3MkTrafCDFSdN55fURYGJVMp1LAPR3KCJ4O7TKMv?=
 =?us-ascii?Q?mS3nRoCzI2Nw6uALEj7PCL0rqUraibt46BnvHnOr/oO+KLHVa75oA9Uj7AHn?=
 =?us-ascii?Q?VSptQr6nZ06Uqd/4fVTBGPenXpgQC3Lfu69MRv3jBofPMeULW+JAzkz2EE9o?=
 =?us-ascii?Q?orOz2giDMvqReSgi0Ea5Ms6kmPgUzct8a8zqBSWD5L0HUAF7WQu4edm1gs8/?=
 =?us-ascii?Q?38Oa0nEQMQOIUb+g6IxnV9GhGMD11egeI7N36DQUE4IPHiAm2raNU7DymjQZ?=
 =?us-ascii?Q?G8IMwPzRu0ciCB37Cl/AdnBCirFFgI/YknXwFMZjl3nN0yH4YCQB0jDXbHY6?=
 =?us-ascii?Q?s54ndym4U3aUzKaCWA8kzj97nuN86qkWo2DMoWv04xXwuLjhmh4Zt3Lqqdt6?=
 =?us-ascii?Q?F9g6/j06wWkRSdBgNSwwli4d9eKUSGTpjdHUQRi15oC6az6JK0nCxir/raOr?=
 =?us-ascii?Q?HkgvlyhqECoUwfby3s5m7G+Dh/I2XtS54xk4Sm2D83/JlDYEdTJSBC7/eadn?=
 =?us-ascii?Q?+OYkp7amlSqxZBMBf0khy2A7fP9DARUkpckBbg9weOv7DNmshxTdKjbzDcsf?=
 =?us-ascii?Q?z9171feS94MeakaF6bpt7vgOREvPDOBBZsw3z4fl4QDPYhGnssxstfeDXU3d?=
 =?us-ascii?Q?KxKslt6xb4OFfXX1mKwJyYILgNDXRf11p4rH+Erj/80sjIapVtL0rnltdF2C?=
 =?us-ascii?Q?4m+F/htvLXJgZ+dmdlj5K+aAGd7jqX12XgxQasaijlMvBSgDOn4a7FYZQGNf?=
 =?us-ascii?Q?Psfg2jJpOoSEI60Lec2/ijY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 431236d5-086d-4d57-f375-08d9e4d484a4
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 16:12:46.1112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uoF2Dmm0efgMDDtpHMF55pfB168/G1QSlCqojKoNg/cJ1omp1Zr/Dd2tXG5Y0QDWcZxfq8LOrEmM0xMtyVTrtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2516
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10244 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201310106
X-Proofpoint-GUID: Vyz-08KYLM50eTEweOKDlVteCpwt4xP3
X-Proofpoint-ORIG-GUID: Vyz-08KYLM50eTEweOKDlVteCpwt4xP3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

get_lib_path(path_substr) returns full path to a library
containing path_substr (such as "libc-") found via
/proc/self/maps.  Caller is responsible for freeing
the returned string.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/testing/selftests/bpf/trace_helpers.c | 17 +++++++++++++++++
 tools/testing/selftests/bpf/trace_helpers.h |  2 ++
 2 files changed, 19 insertions(+)

diff --git a/tools/testing/selftests/bpf/trace_helpers.c b/tools/testing/selftests/bpf/trace_helpers.c
index ca6abae..49e5f0d 100644
--- a/tools/testing/selftests/bpf/trace_helpers.c
+++ b/tools/testing/selftests/bpf/trace_helpers.c
@@ -216,3 +216,20 @@ ssize_t get_rel_offset(uintptr_t addr)
 	fclose(f);
 	return -EINVAL;
 }
+
+char *get_lib_path(const char *path_substr)
+{
+	char *found = NULL;
+	char lib_path[512];
+	FILE *f;
+
+	f = fopen("/proc/self/maps", "r");
+	while (fscanf(f, "%*s %*s %*s %*s %*s %[^\n]", lib_path) == 1) {
+		if (strstr(lib_path, path_substr) == NULL)
+			continue;
+		found = strdup(lib_path);
+		break;
+	}
+	fclose(f);
+	return found;
+}
diff --git a/tools/testing/selftests/bpf/trace_helpers.h b/tools/testing/selftests/bpf/trace_helpers.h
index 238a9c9..ff379f6 100644
--- a/tools/testing/selftests/bpf/trace_helpers.h
+++ b/tools/testing/selftests/bpf/trace_helpers.h
@@ -20,5 +20,7 @@ struct ksym {
 
 ssize_t get_uprobe_offset(const void *addr);
 ssize_t get_rel_offset(uintptr_t addr);
+/* Return allocated string path to library that contains path_substr. */
+char *get_lib_path(const char *path_substr);
 
 #endif
-- 
1.8.3.1

