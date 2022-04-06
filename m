Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 423D94F6349
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 17:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236034AbiDFPZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 11:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236044AbiDFPYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 11:24:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10D2267C1D;
        Wed,  6 Apr 2022 05:24:09 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2369Ynwx006381;
        Wed, 6 Apr 2022 11:44:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=LmR0RxbqaoJec/IDQ7baHoZLHWVDDdGvKQ2XWoY0PTA=;
 b=WlsNMhZWeEzWRWVbuQnhOae9/PNnopGKHSRsLhhccSVEoXfF6koRdwTSGSf9DWXBqt5J
 PZwDHRKF4cyYi1V9XUDMrY8GukqhGtGNSJlk5IPRwvZYwAs+KNaq4nMt+Dn5QTPrUvTH
 dJfwB+WHYSsEwTuuIr+1elIuoznnxRuGMiNYKTdwCGTE+5xQiz4/0nfM9qGzfZdyTRS3
 bGBG7/gEz6iGqzZ1r2v1DVBggTfwFrwyVKPk2QQcXnsx/vklkpdtxYlcZcKBionlf1TL
 hvVbp0DTCaVKli24MNlk7JpCI1OzFhuk9Qpe8/UF07FpuxxJOv8oSZL4K/Ym5mWHaOqE /Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6d31gqcb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 11:44:10 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 236BfW00009411;
        Wed, 6 Apr 2022 11:44:02 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97trw9ck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 11:44:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bTwLxJeyDHNZJAeTzWDqv3DeK8TS2c/YTxfVAFeUv8DFTs/xbrimTYTek9LjaE6j4Ok0pcFq48yaLFxfF/bL5+AHNcEmv6N1igrFeaOxPX5//wmBP+whflkj6B3qiDuCcouZP7rrwGp9Z5cwuzzlpqKbnCS4Q08n0t50WzrxXHoO677e2bFYa24esPJGGxa5Kk0AISvxfwsLHIL9wZ+9oMmJvoCuLPqLt9XMgT4fzDzDCit/K0DyS/KLejmYuxIpOR+dUBuc7FSB1Zip09T7KJk4sG937niKX9HO+pmwCH038N7t4CUONcXxIBTZwVFypKOG2XXM7A25x3OpoM1LsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LmR0RxbqaoJec/IDQ7baHoZLHWVDDdGvKQ2XWoY0PTA=;
 b=Ev1+uOVCwQz5ipJGkzTC+1m7N5ypGWGRgSq+7sKeLFMRpU3Fbwb0GLh1vyiJPX9S3JXMyo+ZUymf8tU2TJre89ZrZDrBuz41sVgWV/yXx6o8/dOTj/m2gSbvfbgvefva5bd9WkHfRsBVjBsuPoJjrn9TzGGNWGYP079VEZ1usovv6YyhuLdnVpWwvWP3RYzGePdwuUy1VdHjcSCul+dJSdhH/IMimPVgzPQ6jx65iqFv1N9pLNP6kzs4iSYPLkxxtz+tmjbZjfgCu86Pi4Zx+ww8FbLMA7TmhtgonLSHvgIOIuxhJeH4wBM7buvFrV9dEkYJwnj6zG4zNQTGyhb5+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LmR0RxbqaoJec/IDQ7baHoZLHWVDDdGvKQ2XWoY0PTA=;
 b=KhfisuvoCAwE5azOfahf7X5LaDJaNFuEJuUjokUJNHsvUVGRq7s1swm0Z4ZL+FgZvCh8/TmcEMkQrNyXTVcC5Qkz0zwEtSCu5cuNpkzMTAGqLVeBj8XsNh+SaW3bjcF922WMROwDzBqPabZ1aPgnFZkzgFkx/7WU8r8BGljpqOI=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by DM5PR1001MB2409.namprd10.prod.outlook.com (2603:10b6:4:33::35) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 11:44:00 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::bc05:7970:d543:fd52]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::bc05:7970:d543:fd52%3]) with mapi id 15.20.5144.019; Wed, 6 Apr 2022
 11:44:00 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v2 bpf-next 2/3] libbpf: improve string parsing for uprobe auto-attach
Date:   Wed,  6 Apr 2022 12:43:50 +0100
Message-Id: <1649245431-29956-3-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1649245431-29956-1-git-send-email-alan.maguire@oracle.com>
References: <1649245431-29956-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0073.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::14) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b61148ce-994d-4277-5543-08da17c2bdd5
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2409:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2409773A4908E07D37C0CBEBEFE79@DM5PR1001MB2409.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h60YjEosDnQrPcDuxDVAIyhgts4LtJdSKqc/SHhRLUips4eDuxfocDsoxDorOdW/OWldGJvQovvYWc/0d0tggWmtUBpwb1wa7HvrfU6P48tmncmDQVtuDnxAIgix2ifjx7iJBCaJhe50JOoy80gQCEAjbb9E1JuU/mOcjOYyQPbnf/pKXFMyOfXiONvuzmM5MsMvgZrXUZ1cKh4+TtIjTKzsem4xbY4BFeW+l7dNnCjWtDyknkewoemEwlvWixfOIdF+17GWPv1KNyRs/w5YknHZ3P47Ko+EoiyjeHGlg4k9QiQSau8rLZmZERwiJbmshkCk0qBjNHG6tNg2OenrwXr+0WwoDSGNe3YXe4BY4O1/Keqk2Ea8T9TSZXFw/oDlyCa/vhtYlQFGA9Cuc0JRgAWYeNGeGbXR1gzFXqGbpVpVatnDC+LMYpw5c+4nuSAhLgAn3jNh0FOFYz7yuHUICTAbWa0mFGEMhO/R6BSTA4Yl10BVxCuNZsZZopKyEg1E3m1lGv/GhkZK8ZDiTHIsaxn8NtDqY5LjuwhPBXP7EuiR0sQZpzFd4xxEE2x0cq/6WPMskHhNLz7E5NUQzBrBsrrqigyK6h2MQ7XP2fQ5+ZFjFaONMRBN1pAUym9WHwqECJbiS3+MozyVdbWTNKln2g8Im+necUjnZr8W5jj2LWm+B7WNZD129cZDTvupbiN8/3UlLuYRApEo8xvJXTTZPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(38350700002)(86362001)(8676002)(4326008)(66476007)(66556008)(316002)(2906002)(66946007)(186003)(5660300002)(8936002)(7416002)(44832011)(2616005)(107886003)(26005)(83380400001)(508600001)(6486002)(6666004)(6506007)(6512007)(52116002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9tCWakzvlBwsTlwK6EZFrBLnJXLjZ6YJ7u07vsr+h/QzWK+JALOJ5AK0V49M?=
 =?us-ascii?Q?ahvBICYJKG5a9MxSdmYL5lA1uEMIilKLg729codlUnib4J24hlKU7580J+s1?=
 =?us-ascii?Q?8Cf5Uf7UwiLQ8dV/UIPnE9/V00Xg8HvU5IsYK4Rl36+wYgFWRgfb/5aNijCQ?=
 =?us-ascii?Q?eyusq5BtcTKUoSd1G+gjJ09GS7FF8SSaPC7fRFUusg917rMsvcLGv3+7FnxY?=
 =?us-ascii?Q?PnPBWQH8go1+39L6B1MLrT6PZgGRgvHDpd/SkzgVSBlQiYMifXHTa2VCouo+?=
 =?us-ascii?Q?lVK7nUUDeAXJItUCBkLqMkRpx8p5gVUGaD6WQ249V0Wt8ry1YMT8FGbobT60?=
 =?us-ascii?Q?Pm9KLJN5/G+G+52eGpOfDkjjN6Ggi+Gnk9yxmnkCJHWR1HTJf/L5DnJWTQ1z?=
 =?us-ascii?Q?JoKw8p2MyzZJs2Oxh3tyoHV8N6BN/GFdk/JFX94ASOyzs5lQO+l+7WABwT+s?=
 =?us-ascii?Q?1hQqFh4xmXGUFWnDzZ45+l3SxiY6NNbUd/rnPN0eOx5nfwNM0Ya0xk/UFMGI?=
 =?us-ascii?Q?k+fZr/8Tps8AYMnY62JxayxbswVSfehvG6g8EJOO+qApujPgwH1SKPOfCPZR?=
 =?us-ascii?Q?JH1urM64aj7PHV85GjnjITLrhZ16PtFkfhq3r2PsVWuifVxF4fLoK96OVa3m?=
 =?us-ascii?Q?8Lx9UxUyD32W7N6KHHCZQxON1lbk1hg+DkQTP9NyDDvcPnKR2ZdF9YZpF6YZ?=
 =?us-ascii?Q?CQyQhZoKBbJnTczKqNla3deKd4FZw5NbZ2AwhYRGo1VGiC6GVA3tfcMCqxFb?=
 =?us-ascii?Q?1mraL61KgyrIb4HgXpHPv2z+N3S+F2yJfsv5/qizT/d+Z8Ml/E2Af3GWIEu4?=
 =?us-ascii?Q?ckFHUsqqkxDyzQuH3xOkrDPrPpY0N0J3WluuZli78uZf0bCCvEDTg6fnOuBU?=
 =?us-ascii?Q?PUeTx5oTOr2ERI1Ti4fSvXLfQl4BjgK6CCsVLSn2epNIwZKs9rw3LlJNmpwf?=
 =?us-ascii?Q?unM9kd9x9EzCNqLmQ7tgUecvygWddIGNTIWIP8jPDSLlH9HuHD9/fkvbYW6a?=
 =?us-ascii?Q?rWSSiRyCihynxnfYDsHR7eg5HA6/avysaJcitx/VKaVJacZOLpMc1f6yyDRk?=
 =?us-ascii?Q?mxULDeShGi/ugNfC+LZ629mL1QR3poHqAEIWt44JGZ0BQCjLRHa43XndvDqj?=
 =?us-ascii?Q?CWXuGknnHfBhdq/jDJsIZlbDLuow+EMGcpwtatcpaUq5AJ+hpV1KBZ2+nTQD?=
 =?us-ascii?Q?RGaDjbT3LOOqE57cXhZ9lMZ8/iCt7Bj+J0/+iDunSjwJF7F7NwvCrF8mPUsV?=
 =?us-ascii?Q?cMxQzetKs6Kgt99ELDiWPZjbPMHfwz1bj7Q0NL5uJyhbFXDkNLs/5AIhDVIB?=
 =?us-ascii?Q?vQ8jmzPF9QPzziFbm1ZjpC5ghVqCwW1rdgWgHsiMCwPO0zu1jEMpDuKnpaK8?=
 =?us-ascii?Q?/1Tcps7naIbCKdb8kNk86GeNdTC0a9YwBBItPvCwLWy9dvcKjTVy8m3PQAe6?=
 =?us-ascii?Q?uWlzWrH6uXEa2K/UNX7K5lJusCucHLQQZkdeSbPBUW7TQxff2lkNbUuDoyTf?=
 =?us-ascii?Q?hur0J+NBJfQ1dVmrcvFtbjr5hjO92irP5aAhg7dgyJtPBDhjp2oPPpsrldZV?=
 =?us-ascii?Q?aFCMWTVsNCCNaWlyT13TMHLYDdCj2IvbiHsKet9CXIucAZHGhUZgpt1k4Ih0?=
 =?us-ascii?Q?V21ijucNt29jr3LGfcJurUU7XY33KCQQ/iYryGomvZvfjabdyIHirlVokKmD?=
 =?us-ascii?Q?uWJ/gyT2rCTHbyVbpnHggeWkrbyDX61LC1KS5Nimk2As2ifOQAKMLsQpV0fo?=
 =?us-ascii?Q?5KSUIb/B5kGBFPyDMiL7ob+jk+rJrp0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b61148ce-994d-4277-5543-08da17c2bdd5
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 11:44:00.4502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QbQnTOJsp9yaxLmvQhxaHp7WfFKqA4W/ky5hiWDgAVr+LSYUP4z8gKzAUlpFDyxoU5Fl/k95SYgB/XUzHFp85g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2409
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_04:2022-04-06,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=936 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204060054
X-Proofpoint-GUID: KXm7p2hsefhSVgpwXCCsD_OkqNHKhThv
X-Proofpoint-ORIG-GUID: KXm7p2hsefhSVgpwXCCsD_OkqNHKhThv
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For uprobe auto-attach, the parsing can be simplified for the SEC()
name to a single sscanf(); the return value of the sscanf can then
be used to distinguish between sections that simply specify
"u[ret]probe" (and thus cannot auto-attach), those that specify
"u[ret]probe/binary_path:function+offset" etc.

Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/libbpf.c | 83 +++++++++++++++++++++-----------------------------
 1 file changed, 34 insertions(+), 49 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index c92226a..707dcc3 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10913,60 +10913,45 @@ static int resolve_full_path(const char *file, char *result, size_t result_sz)
 static int attach_uprobe(const struct bpf_program *prog, long cookie, struct bpf_link **link)
 {
 	DECLARE_LIBBPF_OPTS(bpf_uprobe_opts, opts);
-	char *func, *probe_name, *func_end;
-	char *func_name, binary_path[512];
-	unsigned long long raw_offset;
-	size_t offset = 0;
-	int n;
+	char *probe_type = NULL, *binary_path = NULL, *func_name = NULL;
+	int n, ret = -EINVAL;
+	long offset = 0;
 
 	*link = NULL;
 
-	opts.retprobe = str_has_pfx(prog->sec_name, "uretprobe");
-	if (opts.retprobe)
-		probe_name = prog->sec_name + sizeof("uretprobe") - 1;
-	else
-		probe_name = prog->sec_name + sizeof("uprobe") - 1;
-	if (probe_name[0] == '/')
-		probe_name++;
-
-	/* handle SEC("u[ret]probe") - format is valid, but auto-attach is impossible. */
-	if (strlen(probe_name) == 0)
-		return 0;
-
-	snprintf(binary_path, sizeof(binary_path), "%s", probe_name);
-	/* ':' should be prior to function+offset */
-	func_name = strrchr(binary_path, ':');
-	if (!func_name) {
-		pr_warn("section '%s' missing ':function[+offset]' specification\n",
-			prog->sec_name);
-		return -EINVAL;
-	}
-	func_name[0] = '\0';
-	func_name++;
-	n = sscanf(func_name, "%m[a-zA-Z0-9_.]+%li", &func, &offset);
-	if (n < 1) {
-		pr_warn("uprobe name '%s' is invalid\n", func_name);
-		return -EINVAL;
-	}
-	if (opts.retprobe && offset != 0) {
-		free(func);
-		pr_warn("uretprobes do not support offset specification\n");
-		return -EINVAL;
-	}
-
-	/* Is func a raw address? */
-	errno = 0;
-	raw_offset = strtoull(func, &func_end, 0);
-	if (!errno && !*func_end) {
-		free(func);
-		func = NULL;
-		offset = (size_t)raw_offset;
+	n = sscanf(prog->sec_name, "%m[^/]/%m[^:]:%m[a-zA-Z0-9_.]+%li",
+		   &probe_type, &binary_path, &func_name, &offset);
+	switch (n) {
+	case 1:
+		/* handle SEC("u[ret]probe") - format is valid, but auto-attach is impossible. */
+		ret = 0;
+		break;
+	case 2:
+		pr_warn("prog '%s': section '%s' missing ':function[+offset]' specification\n",
+			prog->name, prog->sec_name);
+		break;
+	case 3:
+	case 4:
+		opts.retprobe = strcmp(probe_type, "uretprobe") == 0;
+		if (opts.retprobe && offset != 0) {
+			pr_warn("prog '%s': uretprobes do not support offset specification\n",
+				prog->name);
+			break;
+		}
+		opts.func_name = func_name;
+		*link = bpf_program__attach_uprobe_opts(prog, -1, binary_path, offset, &opts);
+		ret = libbpf_get_error(*link);
+		break;
+	default:
+		pr_warn("prog '%s': invalid format of section definition '%s'\n", prog->name,
+			prog->sec_name);
+		break;
 	}
-	opts.func_name = func;
+	free(probe_type);
+	free(binary_path);
+	free(func_name);
 
-	*link = bpf_program__attach_uprobe_opts(prog, -1, binary_path, offset, &opts);
-	free(func);
-	return libbpf_get_error(*link);
+	return ret;
 }
 
 struct bpf_link *bpf_program__attach_uprobe(const struct bpf_program *prog,
-- 
1.8.3.1

