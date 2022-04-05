Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A23414F53EE
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2361291AbiDFE0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1577947AbiDEXRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 19:17:46 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43062654C;
        Tue,  5 Apr 2022 14:46:23 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 235IiJmT024505;
        Tue, 5 Apr 2022 21:46:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Ju5JwQzu+kyrxxnHcPiGoqfobNAGbsuStRP1G7f67R0=;
 b=PgHaG0tmOLQbBysNVeTiHP7ecZriP9bT3i27rLA+aODXR01wLDH/dcgRueqvOrZ0PTZd
 Q1kSJeS5zn4f3Qy4lvLhgo51RZBo2Ahbx84PRUy/u/LYf8fuTD9IdLaq7+W1vRSgLD8+
 dHzfPeajPojz0RvzDm9tv+o1jD444KnNtENKLtHbD+stFPwExec/v/yzNt6j0Vs9/aaG
 IWq2UPKNvdhHbSnAKp9s9z/5fsjgO8Rwf56eMhgEUqs6CIe4tOJgNaKxtJLE7RhJ64xC
 E45Rt4tYBYeZODzxvW9O2i6LSgVq1Clk8Og68ReFh0tV/V3uFXfLXQZr4+tl01IB8kJ4 tw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6f1t7b17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Apr 2022 21:46:07 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 235Lfpg8008143;
        Tue, 5 Apr 2022 21:46:07 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f6cx440gd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Apr 2022 21:46:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U1s7FI2gIuoG/vbP/Q2IDXlpc1AIGYizgEOd7Iqo0sUvMt0PCUUhIoMHMGxyo30f7visU+PCO4zRzIpdAQdXE6o9ZjOzJkWBNARlSECWViiB8KGtXmD5FESmPov6/UD70ouwDca76MvYFLFoF+tAJr9rzKonqpxwJqD0qqKqzKB5C9ysmicZ5gKIxrRmQhoy5rqnHq8N/Y1apbe3mqBxs36SwCCLyCirb/MycRw+pYGSx6qZKQFGn3JaVizLez+AIPrcVy7yXaPjXbU9M5R+0X8qa20I+oh0L+2Zpq9Q7la9mL1B95q5q4t+GWT/Hj0HbpHn1+Me2ekh9AuzSwD8pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ju5JwQzu+kyrxxnHcPiGoqfobNAGbsuStRP1G7f67R0=;
 b=WYIsNrx7IC/w9CkIVeX1dRcyemsWFfUIT61+sWfQX+5pHAHuIBJZUX5+xnCqjxeGVx4XuKgNvLGVO4JjPD1Tny8aj2PD5bMHPSrGAf5j+29deQb9qo3x3rfQD6RqFeZJQxf/D5pfZGF0x8kdsNgBQduZojPQkrTofDe96aiLOUHazSP92dTrd5byeruckEqtE3RPg/mvLxNJ9HDLLPL6nALjqyiV2pduQWiOJW7R+IAZ1vyc5s2gqSeLvh+OsDo2BbvPwijlCM5Pt7jmUX25qPUGkPQzUvqMndn4ACuGhf1IQDEFjqdYnZRyuwmATbFMHJKXpyIjMzwTQmZUt5KThw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ju5JwQzu+kyrxxnHcPiGoqfobNAGbsuStRP1G7f67R0=;
 b=RGFxH8MV7v4823Eg1jAxYGFP8SZwX5at/e3SiyeuweR56yYbF/zDAY4iw28ClYf6cQw4aAe7GW1EeDDKDHT9sU4HxbSWzBa35A9WwVWqXe5YjxmuKtefmioNdDdoRMZs8RSw2Qv8QXN+TFSkfbRZfl5OTmmTMBjdIIBPljZX9C4=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by BN6PR10MB1362.namprd10.prod.outlook.com (2603:10b6:404:42::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 21:46:05 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::bc05:7970:d543:fd52]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::bc05:7970:d543:fd52%3]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 21:46:05 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     andrii@kernel.org, daniel@iogearbox.net, ast@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf-next 2/2] selftests/bpf: uprobe tests should verify param/return values
Date:   Tue,  5 Apr 2022 22:45:56 +0100
Message-Id: <1649195156-9465-3-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1649195156-9465-1-git-send-email-alan.maguire@oracle.com>
References: <1649195156-9465-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0302CA0016.eurprd03.prod.outlook.com
 (2603:10a6:205:2::29) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef5b1ca2-7496-4e34-d9cb-08da174daf4f
X-MS-TrafficTypeDiagnostic: BN6PR10MB1362:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB1362394A86A554DD5394D40DEFE49@BN6PR10MB1362.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v8BDu/kNVfolFruT4CtwgkuCJ228qAWKclm0EfDcx5LtW7RwTNKKScYJIOYm7CzDIjTkDHiD6EHC8emEyDsD+5P2GggN+PGc00IBEN/ibebQhXQYok9CpnV9XI1HKkQtQ0lTGXoFiruxHHpL+RcFcJNhG2mozFbLT76rkA7qc0qf0ICrQLtnvCmcvIAb2S+5XfN2tIwtuuyHmLdj3VRYM5/SbslswuM3GSihcoVhA30Z771mvFUeyuewYyyBfLXqSXwQIDiYLPW0bpV+MjBxyYhINFce/+7EI3KrTWRnAkJkjgRwI4dswIo/FJRyfVpQ7JoXLZRAuM1RcuUsHQ0PJJzG5Etxx23pEPFJhFmiWWu+71Aci2HEct7L78MjqNtSXN7Ohwmv/ZX20bQ+fHGhuLYAiOcPAldQisn1ofgze+6I2zWYaqi+xW59f2kItMzxr4RXf8y/23W45DCBqMYaVVcgTuL84w7Lx68NP7jG5VZGsgABhBTynPN3vJqb01pIl/ewqBy2w9M/HM913QPCT8kzMCOsXXBT215EPYSneuP8tjV4ismf28nHIoTO4R0ysDXLeJnimC0lXC0Bt5jl1QrxWwB+u2auGzC0r+zvyrnRhOVZGpI1nlPvTuA3SgGmhkD0IpZU+BSmW8rajYNfiLz6bLKM0vTiTy183vi1/nWvM2QLJEO1rWKqo0BzO+3ChBPLqP/989rWZzihA5isZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66946007)(4326008)(66556008)(66476007)(44832011)(8676002)(2906002)(38350700002)(38100700002)(52116002)(6512007)(6506007)(6666004)(5660300002)(15650500001)(8936002)(7416002)(107886003)(186003)(83380400001)(2616005)(316002)(6486002)(86362001)(36756003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cWF47l754h2S8QN34HqB04lXNO1XH4ZON7FYW7slxOgdr7vflA0bi44uaiNW?=
 =?us-ascii?Q?jKPz+0gHXoVOi53EUvMSG5vZv5iJKgmvLlPOT63hMol4kr4/8/Mlla4Ur7L3?=
 =?us-ascii?Q?QbAM+4HLQ46iaF/GbUUZ58x+UVv2OJxC6J11UXAVslxwM/WNFb2GzhOARgDK?=
 =?us-ascii?Q?gPc2EyN5CXO/ps4Zjb+HkSnGWMEIqb94zjZ+RRGtmDC9XzOFZZLMnrWJBYeR?=
 =?us-ascii?Q?DhqAiTX5qoW2beBtATLveg16apRtV1YFD2i00wpQrcPFOPMP8nQhPufvrzi6?=
 =?us-ascii?Q?J2KNFWteK0/dDNz4jfs0EgGpmZl5lyWFoIfh7p+8NWEkjsiyg+D5LUgPo7Up?=
 =?us-ascii?Q?IxCmMgb/o3Qm+T2bGvxXB+GxRqAy8Os3RM/yVhYFzdnRPzg8CWQg2foAlmrU?=
 =?us-ascii?Q?r5Ffzn7MZb5P+UTGR/wUb2EbW96q4jAXf2ERBdFustuOS0vP5qDMBhZlQZzE?=
 =?us-ascii?Q?a4AgXENxv2Tu3HwIhPcplJDQxG238F89cMYlpMUQg5qaLNBFnxR3Q0aw7L4F?=
 =?us-ascii?Q?xtAfpB7I4RewqlGN1oeuepJsed/Z+Yc12qIncT6XeFJ0vQO3czop12O55Hht?=
 =?us-ascii?Q?+7YJ750HtY0kdkDFRGCXDXEamKgOH39MsF4A/g3MOtHmtCcfrB3Oi+oUQ4wR?=
 =?us-ascii?Q?+wsTmx//zAxZc2A9wrfGJKsO+iy9+Z0wMSFBcfzKdXEB+x3MVd3GJWNJPN8b?=
 =?us-ascii?Q?EihsvUM7KhQtIs1X8Dbu1+Pz9KbYb/f7oGin1woFwzWHnBMupK3/oybqwJus?=
 =?us-ascii?Q?dOlH6jqGYt6zILAjfVGTlfsSrdLVWt9v8t1cX8iy7tAyNoCst3rxGv292O7l?=
 =?us-ascii?Q?8GoY6VX5z5/pBtLuJ4kkNLd6sjIkSEW7xZrMdFgOjdCkhLCXh0jhBLAIBnTR?=
 =?us-ascii?Q?Wx2z+Yuu5q0YK7ia0BhPyV2ZtBSNpbPzgvqzDgrNdTmMUCORmV/4htpECNLC?=
 =?us-ascii?Q?iVQ4Q5D3YMWiRAGV31uvK65d5PMy8l5sRLgf1jfnVKfbVNhcdnmqpK/TTGC8?=
 =?us-ascii?Q?fgleTc3l8uSyp7TlpCWItiubj1/iFhgSzLP3C5D7L3gHRgGRgdDZI58gnPk+?=
 =?us-ascii?Q?LUuMM3axAjdYPQlnWW3Gq1E053DZz6clIx9adLqA6j2HYakWsTcYDs0c7qOk?=
 =?us-ascii?Q?BtvxTjg8ck2//nXTV2Rctg2M+SIvWWU+3732Q7fJ6Qjxd6aQ1akxTmzsoo5l?=
 =?us-ascii?Q?1GJZOSg1moNGfguYW6wzLwVwi4YDahEMkF/dCIduIrsmFSXGC+vflRWFzHow?=
 =?us-ascii?Q?S9vB7rd8UXkiqs/cFae3SvXxj5EwVNyT5GjdkR83LC0kpWvXCw18YO08oOuR?=
 =?us-ascii?Q?KYvWHVmlHIeAhbBXsk7y/5UWjbmrDh9ACigtUDwdtD2tzksRb1qIPLGxlNDT?=
 =?us-ascii?Q?7DdYCewazmK21cbY/L0k0NKdXry6HY5L4Ed2M2YRKhtW953lfAiGHarr27e7?=
 =?us-ascii?Q?w6XZvjV8kx858IhhLCMSNlFFOicntF5aRAi0rfIgQ5DxUA5ACCUtxnvNZuyO?=
 =?us-ascii?Q?c+pCk6u8h3F/z+WKLMxN8GqCq2h0XMw//XaV8vmYrJGnlImOJXiQB0zPFhnO?=
 =?us-ascii?Q?W18yVq2bz8y2P/LhKIvDi03T5Uwg8+tCcx3flnuphb48loFYRrIKMQYxnMHo?=
 =?us-ascii?Q?IUJt+CACmfO79/tRprFN1RqWlqcTV0Lk5ZeW1DkVhWBtJLnYhcM4CGO93/EF?=
 =?us-ascii?Q?os5gOnhVzbqbYtBzZ2OdmIpZccYJW4FoUxI3WRlQMb08xNqrdmi7hob3R3Pt?=
 =?us-ascii?Q?BiVJg5ym90HYaAPjAtxQSahz2F13Xug=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef5b1ca2-7496-4e34-d9cb-08da174daf4f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 21:46:04.9243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UbqejXaUxmMUpf/VtqfxQmn8XbFm5ytGohKsX55OWYP8daA+9rhCIKD9jEuvLh128I0YpWrGr5+Bi7dXCEInVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1362
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-05_07:2022-04-04,2022-04-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204050119
X-Proofpoint-ORIG-GUID: LZgaoT2E5h578JvDnW7naDoB-R12xPH0
X-Proofpoint-GUID: LZgaoT2E5h578JvDnW7naDoB-R12xPH0
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

uprobe/uretprobe tests don't do any validation of arguments/return values,
and without this we can't be sure we are attached to the right function,
or that we are indeed attached to a uprobe or uretprobe.  To fix this
validate argument and return value for auto-attached functions.

Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 .../selftests/bpf/prog_tests/uprobe_autoattach.c   | 16 ++++++++++----
 .../selftests/bpf/progs/test_uprobe_autoattach.c   | 25 +++++++++++++++-------
 2 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c b/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
index 03b15d6..ff85f1f 100644
--- a/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
+++ b/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
@@ -5,14 +5,16 @@
 #include "test_uprobe_autoattach.skel.h"
 
 /* uprobe attach point */
-static void autoattach_trigger_func(void)
+static noinline int autoattach_trigger_func(int arg)
 {
-	asm volatile ("");
+	return arg + 1;
 }
 
 void test_uprobe_autoattach(void)
 {
 	struct test_uprobe_autoattach *skel;
+	int trigger_val = 100;
+	size_t malloc_sz = 1;
 	char *mem;
 
 	skel = test_uprobe_autoattach__open_and_load();
@@ -22,12 +24,18 @@ void test_uprobe_autoattach(void)
 	if (!ASSERT_OK(test_uprobe_autoattach__attach(skel), "skel_attach"))
 		goto cleanup;
 
+	skel->bss->uprobe_byname_parm1 = trigger_val;
+	skel->bss->uretprobe_byname_rc  = trigger_val + 1;
+	skel->bss->uprobe_byname2_parm1 = malloc_sz;
+	skel->bss->uretprobe_byname2_rc = getpid();
+
 	/* trigger & validate uprobe & uretprobe */
-	autoattach_trigger_func();
+	(void) autoattach_trigger_func(trigger_val);
 
 	/* trigger & validate shared library u[ret]probes attached by name */
-	mem = malloc(1);
+	mem = malloc(malloc_sz);
 	free(mem);
+	(void) getpid();
 
 	ASSERT_EQ(skel->bss->uprobe_byname_res, 1, "check_uprobe_byname_res");
 	ASSERT_EQ(skel->bss->uretprobe_byname_res, 2, "check_uretprobe_byname_res");
diff --git a/tools/testing/selftests/bpf/progs/test_uprobe_autoattach.c b/tools/testing/selftests/bpf/progs/test_uprobe_autoattach.c
index b442fb5..db104bd 100644
--- a/tools/testing/selftests/bpf/progs/test_uprobe_autoattach.c
+++ b/tools/testing/selftests/bpf/progs/test_uprobe_autoattach.c
@@ -1,15 +1,20 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2022, Oracle and/or its affiliates. */
 
-#include <linux/ptrace.h>
-#include <linux/bpf.h>
+#include "vmlinux.h"
+
+#include <bpf/bpf_core_read.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 
+int uprobe_byname_parm1 = 0;
 int uprobe_byname_res = 0;
+int uretprobe_byname_rc = 0;
 int uretprobe_byname_res = 0;
+size_t uprobe_byname2_parm1 = 0;
 int uprobe_byname2_res = 0;
-int uretprobe_byname2_res = 0;
+int uretprobe_byname2_rc = 0;
+pid_t uretprobe_byname2_res = 0;
 
 /* This program cannot auto-attach, but that should not stop other
  * programs from attaching.
@@ -23,14 +28,16 @@ int handle_uprobe_noautoattach(struct pt_regs *ctx)
 SEC("uprobe//proc/self/exe:autoattach_trigger_func")
 int handle_uprobe_byname(struct pt_regs *ctx)
 {
-	uprobe_byname_res = 1;
+	if (PT_REGS_PARM1_CORE(ctx) == uprobe_byname_parm1)
+		uprobe_byname_res = 1;
 	return 0;
 }
 
 SEC("uretprobe//proc/self/exe:autoattach_trigger_func")
 int handle_uretprobe_byname(struct pt_regs *ctx)
 {
-	uretprobe_byname_res = 2;
+	if (PT_REGS_RC_CORE(ctx) == uretprobe_byname_rc)
+		uretprobe_byname_res = 2;
 	return 0;
 }
 
@@ -38,14 +45,16 @@ int handle_uretprobe_byname(struct pt_regs *ctx)
 SEC("uprobe/libc.so.6:malloc")
 int handle_uprobe_byname2(struct pt_regs *ctx)
 {
-	uprobe_byname2_res = 3;
+	if (PT_REGS_PARM1_CORE(ctx) == uprobe_byname2_parm1)
+		uprobe_byname2_res = 3;
 	return 0;
 }
 
-SEC("uretprobe/libc.so.6:free")
+SEC("uretprobe/libc.so.6:getpid")
 int handle_uretprobe_byname2(struct pt_regs *ctx)
 {
-	uretprobe_byname2_res = 4;
+	if (PT_REGS_RC_CORE(ctx) == uretprobe_byname2_rc)
+		uretprobe_byname2_res = 4;
 	return 0;
 }
 
-- 
1.8.3.1

