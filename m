Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00EBE4D6147
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 13:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242868AbiCKMMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 07:12:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239673AbiCKMM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 07:12:29 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DB8122227;
        Fri, 11 Mar 2022 04:11:26 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22BBqp45024124;
        Fri, 11 Mar 2022 12:11:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=1zVQH+FuCIgl+lwGZ9pO04mlfe4Ad+U3ZJafV9THhLo=;
 b=Z/9lweFccaj4ye5Wg/ha6bVOZxTiEd6eITGOUyFr2LZYDNnMQnBxv7wnIrOu83AN6soq
 7kv7gfXgUcIcHfsfIcmNkyaPLgipNv/WwHfjCmva1Yl+Ilbv8qhu3Pd8W8QCMz9UL2oD
 WXCNCHaRcsZWWGgjBtDXbGhqLFgx6AzAZVmO6hRsiTKPnklnSwSxZQp6QZpg4aXb5FiR
 /k3GaowfZmWOuJ5HVwAFfz3ihthMGXzbp6bueTvCt3/Mwo9irOVq0lXFEdlm25xdkWhq
 ajXzlJFRtno5d1UyUp/M1MQ19AasRMN7yURqWJVLB7nHQ430/1vibpHpjejkSBV5K9EZ pA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekx9creun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 12:11:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22BC1NZh078598;
        Fri, 11 Mar 2022 12:11:07 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by aserp3020.oracle.com with ESMTP id 3ekyp47eh1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 12:11:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZtjOYZANfIOq8vZF833CO40vY3y1HIB6TCjfpMEaEmLMZLYL8J8H1CiYkn+I0m27oCDsbYB+HigxXZbyEmONVRgqe9vADGFpJUvRj4lAeJ+kEb1s9QtKuf3DcxB1erbJV6V1HgxJKCWtDSBER5mqF7hE9PAOhPzyfznbzHWGRySCzAp5nELKgp1r5wCkwPyoPgGxfI4hz1WgEcwKqYG61g02dP5kyIgVXHRMjtodFwYusoQRq4GTCOToSCpFSYWg5UM+4Pp6ZrWyHOUP9160DT+U9SJ/qtDJqBt22mCfwXbsJ6+WQ7XLnvIDnB1J/93cIFPZJWPEpq4r1C67uZNFWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1zVQH+FuCIgl+lwGZ9pO04mlfe4Ad+U3ZJafV9THhLo=;
 b=SklV4TrVtBHrVpNh8a0ENfKmGZgcOzm3BSt1eDo/JdhzSmu8wctSwtEz/sI+ATGTZsGcxDScQO/ZGfh2TPkr2uyJ71lccg+BRee3I9v8Sa2PzU5I5pnkB/jpwoqBNLgYU7hE9Q7+aRXftN0J5atCZ6oC8ADLFvaLqlk2DPWsp1GunIYhUTCCAfcutrKDQ9fFQVngHSslkKKPw3+vivgMtKGhiQDRw0eL7zDlvVBZ0Y88BjzmAlsPAtDJrRz8gy9kPBzA30mda0nd0In3nZ+TM0u/Tg9B3/T39dpoEvjEfpZW79mowPWFRkzWBPpsm3i5mSrMu1iRvdpZ4lhyKBNDmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1zVQH+FuCIgl+lwGZ9pO04mlfe4Ad+U3ZJafV9THhLo=;
 b=k7AZoOvSbafFuVdxgUNmcE46hnrO+oGRhWd0/crDcsSJFYDKpFFheqXf1KYFhBd3FOs/R0HXSMPlayD7S/8FIQ01llqm+D4UjWNalBUdHihzAc8t6smZrpMfl62zbDnblZupfZYARsJMqVjOSL89W2eqFGVzgDLwfrhi60CTt4E=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by SJ0PR10MB4784.namprd10.prod.outlook.com (2603:10b6:a03:2d4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 11 Mar
 2022 12:11:06 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::517b:68:908d:b931]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::517b:68:908d:b931%3]) with mapi id 15.20.5061.024; Fri, 11 Mar 2022
 12:11:06 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, toke@redhat.com,
        sunyucong@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v4 bpf-next 1/5] libbpf: bpf_program__attach_uprobe_opts() should determine paths for programs/libraries where possible
Date:   Fri, 11 Mar 2022 12:10:54 +0000
Message-Id: <1647000658-16149-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1647000658-16149-1-git-send-email-alan.maguire@oracle.com>
References: <1647000658-16149-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0335.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::16) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98e7a5ec-1773-4d25-9082-08da03583805
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4784:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB47849F8EE35297D7B9B93788EF0C9@SJ0PR10MB4784.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: et965yZQuftg5Tr1E4eAeF9rrBsYRnxO9w5rC4+Tk6Wqdt4UzZKIriroWtzz8LflbEpOivVzY6Tpl/51Y8UzsnNnO31cOadIegN9TLndxYl3CYGsZKmpicjm8Czr2JceEn+hqC6U3FOwECQjXckOUJKWKCJm+rLRD0s9qkmAJE1QSuxmFnt6ULZuP4jBZS0N3JKrmnIzagnuCwRivOzLTywjWKR3Z/KA87i/8Xv2FhEaOmCWr3FI0jL7jNdBrLJaQEwZ7D+gGJwSs/cp2rMLzMe5tQYKM+/3m85RFZFKjsvRRE4KF6MNUMhh/xH1OiWi/dOOipKBS77PbNy9u+EXtOn1h9XnhxWzUW7gkLbGKZ8odQ/ym+9ghdkXtKQHqtmhmavBXJ3GDoHUQB4Dcn0u6R++K/eNE+5D77H4WuEXTVbte6f16fw/0paycAtwBJcArpM+E1zfmiaMRKW/CuzZ2GeXZBQ8cB+IA7OSQL9YKN8g5Q2gmdbfHrh9HWQI9ApckJAe/v/wcZKq4l9KspHxsz7vnGKLR6czuxY1BKS7PEZBJd9KFmI/Dm4AVU3j0Ty2qzhH44WABH9MVRxOsP5A0/bQEpFBMKieSpokO7QQ5MxfobvzLp+CZEWiNCEXVuzQNHgMV1+UXenw4bPvCdMWs4YTGxTppsch06Z/ssC30RitBBhigoOeaJz9J9KToxWVZLbFxSlgO9E7H7tKt4pThhdBlUeCH72WESHB9ECbADtgLuBfNoVB0NldDDowPyBK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38350700002)(2616005)(66946007)(36756003)(7416002)(83380400001)(316002)(38100700002)(6666004)(86362001)(508600001)(5660300002)(44832011)(6506007)(8936002)(52116002)(26005)(6512007)(186003)(2906002)(107886003)(66476007)(8676002)(4326008)(6486002)(66556008)(101420200003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zoj7SXAiF4oU3LE0F0/tG4jZKdo0Um2t14bM1vN7149rhJPfCd/SoiNGPYIP?=
 =?us-ascii?Q?TOqgoH0zqOZBnmz/Blg4WlNzCbx/d3SR3KGbOgvf4WXggJ/7IkBgUHUqW8ro?=
 =?us-ascii?Q?9I9SUwt719cAggTA6RAhUGkHawYZ9Vy+WL9Jz2hJ/c8JW9kqYc41aFW17kbC?=
 =?us-ascii?Q?5HELo5evt6k1M+/nQFsY5X/rs9rggxobgmdbz6PahDIZkYTitmbrkPIEhSh5?=
 =?us-ascii?Q?f6sbVowB+5rJNeDLuuUqcvHjJEj/7MpNN5ZO1GFhnpugTTWdPIanlghOl35g?=
 =?us-ascii?Q?6RAvvA4fN4aAs+CWGBYDHGRhp4yqax9elQb3t1tHpsEnrLMlZ8bntrQP1t0x?=
 =?us-ascii?Q?IF9jBr9qSYUw8NM/OxMBuVQwnJsSxLYgTEdEDHLksllfVSPwbkNZjnOOOVpx?=
 =?us-ascii?Q?yqm/F5BaTUfCXQNyuSSAumMwlw0z/WsgqXCS2y8SHDuCxGzvwdQiX9/ZTJzY?=
 =?us-ascii?Q?4q17Lfgd7anFyf78ioPpWTlppKNcX2EYU1zaNwa7F+rxZwYbMlV81bF3iu8/?=
 =?us-ascii?Q?THGzd/araB9ulPG3+4HfVdIMqZZ1hWxEI1m6b95trNNri4BHsZqj8bAGjAiw?=
 =?us-ascii?Q?UutDdRQLZwn5xs3hthDFMSp5zpfwKIW3foMidM75UEhJpjZTuvM6P/JSjY1Z?=
 =?us-ascii?Q?j5qUotTU5f/ItnuBfXmtXwEWYZMrIb9aXZxzrsohu41nLDs1bG+pBObCF5Wp?=
 =?us-ascii?Q?GxlB6FG4guj7hlL09Hb20iWZG8Q98VtXyQKrl+BvtXKTIsIMRXxzdhHhGrmW?=
 =?us-ascii?Q?u65Yi0yCd9203y/npvGrOb1nHjX8QdyxIcZvn03zH6VfYVOkUiuJNux486l6?=
 =?us-ascii?Q?YSnODpuzyPiX6UTvh3Qe/3XdjZ5Uafx45uFAhUHt8FuIjLqDUSOFJC4Ehjmx?=
 =?us-ascii?Q?L9UZm8mUSS6zjjgAwSTzzGtJ+xZe3Nv3ykaIVPERMhmey7ns2+HJNmD8bp9Y?=
 =?us-ascii?Q?xifMDNa9LB4Z55Oqj0KIArxeAclaXHDTeMhOzFpoj2asgMu0k/bQQTUQmKTG?=
 =?us-ascii?Q?YLPU/Bmw/3bb78/PYR9W6XOXUXgMxNqd2QJUvXKK77iK+xgW2RPEgI+H0fe/?=
 =?us-ascii?Q?6iscyAa5eN/oqsHRB/ky1PT9lkTshvkj8epe7JLYmqqMNNUiQHSg1PMNMKd5?=
 =?us-ascii?Q?9NpQsMFhtEuO/vUeDrGj+de4pvFZ+1R4VEWOGhy6qvHJc5xxfKuhmEH6tut7?=
 =?us-ascii?Q?F/Z82wUGH+arzN+8gjSt6l1nfeH4TblHP+2NtQZNUKTh4DCLUYRMBZnQOZ4V?=
 =?us-ascii?Q?1EA9uhd/hKjRlZQIo7Q3vm8x5MiZZ8dPTLDqsM7H8tLAdIF8Xe+qcpKrLnB1?=
 =?us-ascii?Q?hEUTjV0NA85NGgpJULE+cJfi/Gls7zFugYNVQCwxQBkTsgzkBUn7C8fVL8GG?=
 =?us-ascii?Q?MVCO1ogxb8RYmvCx2YCSyHvBm6CzjO73h7upthqZwrq5bVfIM/2ibq9quMV+?=
 =?us-ascii?Q?l+W/W/o4dVRQvDWAN4f4EJ9hTeDHLQDxAnQ46Q46XFjeWPZNN6CDIB6FDzor?=
 =?us-ascii?Q?WjHxePcyxgjEN65AftemkUt3la1PrO5uc0+JvneAGgvy4JBFqApn2oJksb+W?=
 =?us-ascii?Q?rcYdVZOBIkYzZAGxvRymQbBhg8rz+aXo9pf2LuPu3bcCR+hUxGKWyRg90yFi?=
 =?us-ascii?Q?5Xnu6IeG+TIKDqgkebLM5RY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98e7a5ec-1773-4d25-9082-08da03583805
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 12:11:06.0751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oDg/qX1EHvicQUCzqgeROHKog50pLeA37dG9krWzTZy0jxzLYI91BR6x6Q3zEgPMceyhyvTosjO2qGL0FhmUeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4784
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10282 signatures=692556
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203110059
X-Proofpoint-ORIG-GUID: girn4a8Bz0H-Tk2B3n_oIizshzXf5r1y
X-Proofpoint-GUID: girn4a8Bz0H-Tk2B3n_oIizshzXf5r1y
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_program__attach_uprobe_opts() requires a binary_path argument
specifying binary to instrument.  Supporting simply specifying
"libc.so.6" or "foo" should be possible too.

Library search checks LD_LIBRARY_PATH, then /usr/lib64, /usr/lib.
This allows users to run BPF programs prefixed with
LD_LIBRARY_PATH=/path2/lib while still searching standard locations.
Similarly for non .so files, we check PATH and /usr/bin, /usr/sbin.

Path determination will be useful for auto-attach of BPF uprobe programs
using SEC() definition.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/libbpf.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 43161fd..b577577 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10320,6 +10320,45 @@ static int perf_event_uprobe_open_legacy(const char *probe_name, bool retprobe,
 	return pfd;
 }
 
+/* Get full path to program/shared library. */
+static int resolve_full_path(const char *file, char *result, size_t result_sz)
+{
+	char *search_paths[2];
+	int i;
+
+	if (strstr(file, ".so")) {
+		search_paths[0] = getenv("LD_LIBRARY_PATH");
+		search_paths[1] = (char *)"/usr/lib64:/usr/lib";
+	} else {
+		search_paths[0] = getenv("PATH");
+		search_paths[1] = (char *)"/usr/bin:/usr/sbin";
+	}
+
+	for (i = 0; i < ARRAY_SIZE(search_paths); i++) {
+		char *s, *search_path, *currpath, *saveptr = NULL;
+
+		if (!search_paths[i])
+			continue;
+		search_path = strdup(search_paths[i]);
+		s = search_path;
+		while ((currpath = strtok_r(s, ":", &saveptr)) != NULL) {
+			struct stat sb;
+
+			s = NULL;
+			snprintf(result, result_sz, "%s/%s", currpath, file);
+			/* ensure it is an executable file/link */
+			if (stat(result, &sb) == 0 && (sb.st_mode & (S_IFREG | S_IFLNK)) &&
+			    (sb.st_mode & (S_IXUSR | S_IXGRP | S_IXOTH))) {
+				pr_debug("resolved '%s' to '%s'\n", file, result);
+				free(search_path);
+				return 0;
+			}
+		}
+		free(search_path);
+	}
+	return -ENOENT;
+}
+
 LIBBPF_API struct bpf_link *
 bpf_program__attach_uprobe_opts(const struct bpf_program *prog, pid_t pid,
 				const char *binary_path, size_t func_offset,
@@ -10327,6 +10366,7 @@ static int perf_event_uprobe_open_legacy(const char *probe_name, bool retprobe,
 {
 	DECLARE_LIBBPF_OPTS(bpf_perf_event_opts, pe_opts);
 	char errmsg[STRERR_BUFSIZE], *legacy_probe = NULL;
+	char full_binary_path[PATH_MAX];
 	struct bpf_link *link;
 	size_t ref_ctr_off;
 	int pfd, err;
@@ -10338,13 +10378,22 @@ static int perf_event_uprobe_open_legacy(const char *probe_name, bool retprobe,
 	retprobe = OPTS_GET(opts, retprobe, false);
 	ref_ctr_off = OPTS_GET(opts, ref_ctr_offset, 0);
 	pe_opts.bpf_cookie = OPTS_GET(opts, bpf_cookie, 0);
+	if (binary_path && !strchr(binary_path, '/')) {
+		err = resolve_full_path(binary_path, full_binary_path,
+					sizeof(full_binary_path));
+		if (err) {
+			pr_warn("could not find full path for %s\n", binary_path);
+			return libbpf_err_ptr(err);
+		}
+		binary_path = full_binary_path;
+	}
 
 	legacy = determine_uprobe_perf_type() < 0;
 	if (!legacy) {
 		pfd = perf_event_open_probe(true /* uprobe */, retprobe, binary_path,
 					    func_offset, pid, ref_ctr_off);
 	} else {
-		char probe_name[512];
+		char probe_name[PATH_MAX + 64];
 
 		if (ref_ctr_off)
 			return libbpf_err_ptr(-EINVAL);
-- 
1.8.3.1

