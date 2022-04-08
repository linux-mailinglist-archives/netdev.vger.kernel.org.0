Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D48D4F9FCA
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 00:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239969AbiDHWzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 18:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239046AbiDHWzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 18:55:41 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE5770922;
        Fri,  8 Apr 2022 15:53:37 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 238LKdCC024505;
        Fri, 8 Apr 2022 22:52:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=mnnG7Q6ua2ynXRHTA4M/gltsNW5+K8aG6Vc51hNZ6i4=;
 b=uOXAOlMtUI3/YGTA9laLg4pp6j090utan/3pKrQ0+v7jDyHgaKHLdVVdZEtXMG9TDp9i
 SvroX2Gxwr+RJyQfJaA8iy9WjLhaULYhSJIjaQDtX0RjjqK9AYHboLg8AG7/upCIq9VZ
 EFekMxTI5YZs6EEWNr6GF2F2aHRb6IPTYlywohd1ZrtAkttYVNFTJmaPj5WdNcsVKRrK
 G1rMDCqQbOrqKA3qA7z/xwMRTJTuqm+aC7+x8U+59RGN1qLY5phXz3IZgns8UWv4r7la
 UYy6Vaq2w8zkBI+4ny+3/zCocd2fCbUnzTkw7fzaymKnRt1GH8bDPjY1S91NbB2Cujv+ ug== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6f1tgrs7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 22:52:58 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 238MjYK6001071;
        Fri, 8 Apr 2022 22:52:58 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uynks4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 22:52:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aXePUanHw+z7M10lpYLnGRNIoTKGEu60qs3gyruYPtkG8Z2rxuf88IDpxfGr96A7vvIbJxb2eflDc0AsrojFvBl6kGG/EotY3gBv1k+EsMn2hXvRNIZJm3SCBsWKdf9bgtP1gYtbo/qbtSA0/OtGjt58MVIjWx8TqLidl97SfNuJrmiR+xb8yhvieZ5r/fPG3mXCHTzX3EiDNfIrfREWYQOkskLJzfWjb2TB7eCCzltDrSgvnTjvTzvu/PaXKLE8UlfvQOm6ef7ofvANvSaS8isf/CusMH4b7IhTqOr8tQI1MFTW49qOt1uChTyJVFdaS11LQAecX3xQIimYh6fsfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mnnG7Q6ua2ynXRHTA4M/gltsNW5+K8aG6Vc51hNZ6i4=;
 b=jOX3D7QtXzjSAoXgDCx9JmIf06rVIngLWivATeCnosk1eL/o0Q343ldr/B/nG8NmdFR9uJl8jjUpI1HEVHN8scutHmpZ+cd9JDBDBHkW9KKpfC18d/zPN/EoVJ/oK/9pSKwAVMxeRdt9l1OYv336i5lUdInfBJuW/n5Sge1xUu9EHOdaARcePAjhFUCjhPq0OOOLXa52sm2ipTDu5lX87Y3/jQXh5Sz8DFDsDskon0Pc4gf4kOkOQIH2Bzw3WS27YSv1MG/Ooa0yl1LGkLKDc/EcIZfKXbjg+qKtg1TyzsUSSTIBfA3MnhxPAK3H9bthdCDn76KGPCO//BfcmPqjqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mnnG7Q6ua2ynXRHTA4M/gltsNW5+K8aG6Vc51hNZ6i4=;
 b=J5QXPk7T2M47DeoRNdgfwidswW2+FMvEa9j/JagtPs6t52Y6TAQQ028MXOTLRmS++0YhDuLACTJi9uDQARg82UWyifbeeirGRa2fU/5hUpoIHY3v9mrS/phRjGcfP5IOUEt63xID63rrxZpUtewgXGGhgpmVAT3l/vZuBBC80qg=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by DM6PR10MB3705.namprd10.prod.outlook.com (2603:10b6:5:155::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Fri, 8 Apr
 2022 22:52:56 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::bc05:7970:d543:fd52]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::bc05:7970:d543:fd52%4]) with mapi id 15.20.5144.027; Fri, 8 Apr 2022
 22:52:56 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     andrii@kernel.org, iii@linux.ibm.com, ast@kernel.org,
        daniel@iogearbox.net
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf-next 1/2] libbpf: usdt: factor out common USDT arg handling
Date:   Fri,  8 Apr 2022 23:52:45 +0100
Message-Id: <1649458366-25288-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1649458366-25288-1-git-send-email-alan.maguire@oracle.com>
References: <1649458366-25288-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0047.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:152::16) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9427b05a-56c7-41a8-c1a1-08da19b28572
X-MS-TrafficTypeDiagnostic: DM6PR10MB3705:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB37052191BE2B434780FC5188EFE99@DM6PR10MB3705.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HMMfSOMTOyhAblETPaHJ2GYSSOY9cqfuYQ/qFkCh3K+aQd9XyQ2WtRBcIpftOZcF7vJNCIFPKXVTb1UMgcdlQu4xXKxAicPciZnI/f6TBZ0ITvM/445DW3VUeZSG0mR566PIWjC2XiLbkQi3C0VdtQyUSzpEsYCSXBiBjpzueOjmRtgWG7ugebyRVIOkVbnE5HwHGMvw5ofWeDSI+9H2NOyHUSfOYTuMw65B42s5Z5SJGZiGJ5oXCKf5Fc7gwYa9QyKAK0pYhbNY9Hh12f8Oa0loQKu0LRlX6nkeSBZsn7/6d4SuP17fEyHBsnWIrJMCR5SUE6fTHbcLXKIDGtPLFxvZUM9eJHmhvqKphmbdBc5tbgB8a3KbP3HTnDGtJ9pzx1SwneEtxS8R117aW96XfJXq/qNjLuNBsT3l2aY8ukWxnnlD/q9NCmrWvH2JT/CW9MJgHp5mxpwbAct1iyESwQ9smqy5Gfv3hWHcQu/fE7TSCUS7C1k1pBDytxzaenUH5hdzTM8jXk5wdEFJnuYrCnuFEeEeRaP36L27xwShZOsYDj/TT4GbdyAaRzOdEw5Hlfrxqm24mjTpWd4fTjaQ+ClALB0+BSTOElIYtMwZFYC3KWCrZCIIZre7+51aZW1GCisBiuxUeLA1vaxP46zNOyVEYL2DDWAQaGMTzF3EggnKa3uHsW7cPmtjBTPPGW7E4uJ07jNz6tuygmCROI94+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(86362001)(6512007)(36756003)(4326008)(186003)(66476007)(66556008)(83380400001)(5660300002)(7416002)(44832011)(6666004)(52116002)(45080400002)(6506007)(6486002)(8676002)(66946007)(8936002)(26005)(2906002)(107886003)(2616005)(38100700002)(38350700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ldx6yw7jSklxFlsoS5mTQLJYdXzguTFN4jyjgYfMRd2Ds5GW01V27tUi9xse?=
 =?us-ascii?Q?4OmNQr5cYUtVrHtOhM5Db0aH6xITPmqk7qYNVglUXMDw9F2sNJMp9By8XcS3?=
 =?us-ascii?Q?FXlECun+8+iawyrjx8N0J0NK7Ln37kI6ilcVr53jD+j42xiZOjTuYYzeBsla?=
 =?us-ascii?Q?hSiHkCUyITE/p+gGK2chhH6KqUq5JKe09TkjvHss/imjK4Ib6EW95lO2r5+C?=
 =?us-ascii?Q?9EhKsvQVCsfFQM3NWFKcEbzicx7x1hxng/rd6/dhRzwgxe+O2ycimh2/FZC6?=
 =?us-ascii?Q?xi12EcsqpzOcJ/sjN/YwRZtMsYSWUdaUEBBsZowsNyMZmmh4D6GTVig+SyTC?=
 =?us-ascii?Q?mGfSebSthO5nP7xPjZ0isHuW5uFaL/ylUIQdKyLOOts86NVUpbYLFXaKmxLP?=
 =?us-ascii?Q?rx9qO0c2zOqg+7g2NvOU3FIa+S5C94pxotH38vAO/5Tb9wHsbAExjmLrIQIB?=
 =?us-ascii?Q?r9fNovhWwIN8tcQGeXu5WejwIGWeB9NLGvLG1QWaw7XaLylT7mPf0gvT2JGr?=
 =?us-ascii?Q?SlKbqLmaLlCut5f0Ky7dAHhlr0qwbdYE1RvQFbovtyWLWlEO22na98zr7BVL?=
 =?us-ascii?Q?psGpYg6/a2Y4rqyxm+VcaFOCB+zLQTHD3FJQhg+dAezSR775PW5e+rbraxw/?=
 =?us-ascii?Q?NuLG0AvzrCTC4R7Zz2SJsrxgSLvK2UVCs1MQkHOJDurwPK5f+ue1ym2SXl2Z?=
 =?us-ascii?Q?VZCsI4yXvwXWwjBB5KUrdSD6uxHYev3F3K/HGLl1Sw7JYpNo70d0jAmbSdCi?=
 =?us-ascii?Q?zSJclyRdzjygvEs9wSTx4gqsiyOGvJHAbCR1Y7k0ELy1voteD0n2dGpGUXrp?=
 =?us-ascii?Q?03mk5eCF4x3sQS5ZWgrYBvWqZ3KSWhof/6uGxIuw7jRZzDzuAZvkxTzdioT4?=
 =?us-ascii?Q?wFaKnnTpwcYHzzOYJJsVFyeYFBlK3IBrMlxzqHCg4vllQCwDdYldys+vfxOR?=
 =?us-ascii?Q?+dymKQf1HQEXnw8bg2FnkR+AaRf+RG+FkE98vpq9OAe5gsOAmzRtJSRNlhO3?=
 =?us-ascii?Q?gJiuVuAVCktK1h8KbYn0rAX4G3rSDqGMA+Jc6H0zTc+NsiApsJRXhoc4+Ikq?=
 =?us-ascii?Q?X0AamkpOffszXSCrGqnF9UvCPbMYHhGtcSAyc8wvNA7JvSQ7mRS2MgoR1lUu?=
 =?us-ascii?Q?k7AfRZmkZX2Z5oMpgLmStV1UnHqVZXlLCKb1smdAYOevPqJju4SVDl4YB0XN?=
 =?us-ascii?Q?a7vhxhwY7tqK091ebIlb7j19aJgMteiEkCzzi2d3LSGC8o7ydW1k3nTsIpcq?=
 =?us-ascii?Q?Cc2YXFfYvmmvV0Yl5nzBrtg3aUjrhBt76Txeaw5odKx2Bvj98D3bWdlw17wG?=
 =?us-ascii?Q?yPe+wePd8iaJOThW7zKHtoN3fO9A7i0B8ylqTAkqS7rcFzugQaHSIBaoLZrn?=
 =?us-ascii?Q?DvFjKVfMzgj26NZbDhBMMk3ycHn6KHuJKLsl0oKg1bFcUHmCv7Tz9yikyzlL?=
 =?us-ascii?Q?v1hJY7XqPS7ghwvWD2AJddSjOHfaMZZ4cIgPscLdNTIbqsDN+vsXiaAdaeb0?=
 =?us-ascii?Q?mjRJ2Jkh5j+GGJ/nJw8YHTQuTZwHstGozdXGZvYWWjBwmE2ieSBQu1J7d5DF?=
 =?us-ascii?Q?IUhltXrzEAJ4sMKUJe1ekYqxuk4TuSoXwqxn47hj5hHaEtFzILryXoeYVodJ?=
 =?us-ascii?Q?qBhg1e8QiH8qAmboCFZzCXPD2IVXOm68sd2f90HtiMy/B86v7FnYEhULLLGl?=
 =?us-ascii?Q?FLINmHmBIzSDQ624IssctWiSPKtLCvT/blyl0fA/I7W4MjhViGLiKPD3obrG?=
 =?us-ascii?Q?srBeZVoWUxIFoqiaPwDzrkCa/DXIiac=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9427b05a-56c7-41a8-c1a1-08da19b28572
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 22:52:56.1984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lcNLqpeVot+/nMqQAt+vcsuhF0krxD2m6hgv7aVmHimAFpSJPLCU0ZRj5xzGwEPuGuo/ZrOtQNVSVYQkYAEZKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3705
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-08_08:2022-04-08,2022-04-08 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 mlxscore=0 adultscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204080117
X-Proofpoint-ORIG-GUID: kSGldJClv2XQ1vd3zBpf8UKgQBFPJOUa
X-Proofpoint-GUID: kSGldJClv2XQ1vd3zBpf8UKgQBFPJOUa
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Common code to initialize a struct usdt_arg_spec can be factored out
from arch-specific flavours of parse_usdt_arg(); signed size,
bitshift handling etc.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/usdt.c | 90 ++++++++++++++++++++++++----------------------------
 1 file changed, 41 insertions(+), 49 deletions(-)

diff --git a/tools/lib/bpf/usdt.c b/tools/lib/bpf/usdt.c
index 30c495a..0677bbd 100644
--- a/tools/lib/bpf/usdt.c
+++ b/tools/lib/bpf/usdt.c
@@ -1170,6 +1170,31 @@ static int parse_usdt_spec(struct usdt_spec *spec, const struct usdt_note *note,
 
 /* Architecture-specific logic for parsing USDT argument location specs */
 
+#if defined(__x86_64__) || defined(__i386__) || defined(__s390x__)
+
+static int init_usdt_arg_spec(struct usdt_arg_spec *arg, enum usdt_arg_type arg_type, int arg_sz,
+			      __u64 val_off, int reg_off)
+{
+	if (reg_off < 0)
+		return reg_off;
+	arg->arg_type = arg_type;
+	arg->val_off = val_off;
+	arg->reg_off = reg_off;
+	arg->arg_signed = arg_sz < 0;
+	if (arg_sz < 0)
+		arg_sz = -arg_sz;
+
+	switch (arg_sz) {
+	case 1: case 2: case 4: case 8:
+		arg->arg_bitshift = 64 - arg_sz * 8;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+#endif
+
 #if defined(__x86_64__) || defined(__i386__)
 
 static int calc_pt_regs_off(const char *reg_name)
@@ -1220,52 +1245,32 @@ static int calc_pt_regs_off(const char *reg_name)
 static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec *arg)
 {
 	char *reg_name = NULL;
-	int arg_sz, len, reg_off;
+	int arg_sz, len, ret;
 	long off;
 
 	if (sscanf(arg_str, " %d @ %ld ( %%%m[^)] ) %n", &arg_sz, &off, &reg_name, &len) == 3) {
 		/* Memory dereference case, e.g., -4@-20(%rbp) */
-		arg->arg_type = USDT_ARG_REG_DEREF;
-		arg->val_off = off;
-		reg_off = calc_pt_regs_off(reg_name);
+		ret = init_usdt_arg_spec(arg, USDT_ARG_REG_DEREF, arg_sz, off,
+					 calc_pt_regs_off(reg_name));
 		free(reg_name);
-		if (reg_off < 0)
-			return reg_off;
-		arg->reg_off = reg_off;
 	} else if (sscanf(arg_str, " %d @ %%%ms %n", &arg_sz, &reg_name, &len) == 2) {
 		/* Register read case, e.g., -4@%eax */
-		arg->arg_type = USDT_ARG_REG;
-		arg->val_off = 0;
-
-		reg_off = calc_pt_regs_off(reg_name);
+		ret = init_usdt_arg_spec(arg, USDT_ARG_REG, arg_sz, 0,
+					 calc_pt_regs_off(reg_name));
 		free(reg_name);
-		if (reg_off < 0)
-			return reg_off;
-		arg->reg_off = reg_off;
 	} else if (sscanf(arg_str, " %d @ $%ld %n", &arg_sz, &off, &len) == 2) {
 		/* Constant value case, e.g., 4@$71 */
-		arg->arg_type = USDT_ARG_CONST;
-		arg->val_off = off;
-		arg->reg_off = 0;
+		ret = init_usdt_arg_spec(arg, USDT_ARG_CONST, arg_sz, off, 0);
 	} else {
 		pr_warn("usdt: unrecognized arg #%d spec '%s'\n", arg_num, arg_str);
 		return -EINVAL;
 	}
 
-	arg->arg_signed = arg_sz < 0;
-	if (arg_sz < 0)
-		arg_sz = -arg_sz;
-
-	switch (arg_sz) {
-	case 1: case 2: case 4: case 8:
-		arg->arg_bitshift = 64 - arg_sz * 8;
-		break;
-	default:
+	if (ret < 0) {
 		pr_warn("usdt: unsupported arg #%d (spec '%s') size: %d\n",
 			arg_num, arg_str, arg_sz);
-		return -EINVAL;
+		return ret;
 	}
-
 	return len;
 }
 
@@ -1276,51 +1281,38 @@ static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec
 static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec *arg)
 {
 	unsigned int reg;
-	int arg_sz, len;
+	int arg_sz, len, ret;
 	long off;
 
 	if (sscanf(arg_str, " %d @ %ld ( %%r%u ) %n", &arg_sz, &off, &reg, &len) == 3) {
 		/* Memory dereference case, e.g., -2@-28(%r15) */
-		arg->arg_type = USDT_ARG_REG_DEREF;
-		arg->val_off = off;
 		if (reg > 15) {
 			pr_warn("usdt: unrecognized register '%%r%u'\n", reg);
 			return -EINVAL;
 		}
-		arg->reg_off = offsetof(user_pt_regs, gprs[reg]);
+		ret = init_usdt_arg_spec(arg, USDT_ARG_REG_DEREF, arg_sz, off,
+					 offsetof(user_pt_regs, gprs[reg]));
 	} else if (sscanf(arg_str, " %d @ %%r%u %n", &arg_sz, &reg, &len) == 2) {
 		/* Register read case, e.g., -8@%r0 */
-		arg->arg_type = USDT_ARG_REG;
-		arg->val_off = 0;
 		if (reg > 15) {
 			pr_warn("usdt: unrecognized register '%%r%u'\n", reg);
 			return -EINVAL;
 		}
-		arg->reg_off = offsetof(user_pt_regs, gprs[reg]);
+		ret = init_usdt_arg_spec(arg, USDT_ARG_REG, arg_sz, 0,
+					 offsetof(user_pt_regs, gprs[reg]));
 	} else if (sscanf(arg_str, " %d @ %ld %n", &arg_sz, &off, &len) == 2) {
 		/* Constant value case, e.g., 4@71 */
-		arg->arg_type = USDT_ARG_CONST;
-		arg->val_off = off;
-		arg->reg_off = 0;
+		ret = init_usdt_arg_spec(arg, USDT_ARG_CONST, arg_sz, off, 0);
 	} else {
 		pr_warn("usdt: unrecognized arg #%d spec '%s'\n", arg_num, arg_str);
 		return -EINVAL;
 	}
 
-	arg->arg_signed = arg_sz < 0;
-	if (arg_sz < 0)
-		arg_sz = -arg_sz;
-
-	switch (arg_sz) {
-	case 1: case 2: case 4: case 8:
-		arg->arg_bitshift = 64 - arg_sz * 8;
-		break;
-	default:
+	if (ret < 0) {
 		pr_warn("usdt: unsupported arg #%d (spec '%s') size: %d\n",
 			arg_num, arg_str, arg_sz);
-		return -EINVAL;
+		return ret;
 	}
-
 	return len;
 }
 
-- 
1.8.3.1

