Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4D94EC83A
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 17:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348198AbiC3P3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 11:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348191AbiC3P3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 11:29:02 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE3F1B5388;
        Wed, 30 Mar 2022 08:27:16 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22UFNYlK027881;
        Wed, 30 Mar 2022 15:26:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Nmc47HQizRRt1JgKSUFPwD1OrG0yITvOHjbKi7FS08A=;
 b=m3wXmpDNPD/hGU5TtSZP62xx3CHguN6EZtFMKbUyM0dksrBFzniWCfllFgykoACNp6RV
 5n8TXK5mML97DNqCm4esFT0Ncubx2GEyEt0C/P4bUPpet/sVLcU3caGdZCS58NI1N6lb
 88Hdj6LDZRHkWpD/zgs7IGbL+R997zbQBUiB/HAfe9i4VliUC2AHfkvBbOvtPOQxcqth
 QtlAZrbvBZz/zG5WgMf/RH7gmACa9N/qoC5WU+ZCL0xP3fUdQL5qx7u4KgtuXI28DMq7
 oCVQLm40tSZh2bIzwv04F0bHjJSlTND3VIpnTKA2B94mqBpJ9/PrnkF1C3bsN+QySHLW XA== 
Received: from aserp3030.oracle.com ([141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1sm2hv7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 15:26:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22UFBAss055900;
        Wed, 30 Mar 2022 15:26:58 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by aserp3030.oracle.com with ESMTP id 3f1rv8f9k9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 15:26:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TJVZerfrMTgSJO1pUD0bXAfJcNt1PHtmqrYiM5+jv484Wc2tmsk85ob1e3EfyYDyc6NvNc7JaLco5U2Jtk6uxb06pofWaj54g8i0wy0W+L5Pmro5tcTZs11U9syUMuxRDxyfoOQLqdMbcSsgX1t4lGeDP/bBHeJd2jtmFGGMtDJ0PRVyTL2MP0x564u6ZxUNr+ZIHr3JtFazFvD37mDcMlQosGnlS5fRXQ8FjAoXxSwrqVYoCqMKmqfY5KXsCvwOZS4KLHlHJ2y1QWWPeFcAOoaNyz2RaBUzm8MWWtW2a/wu3hAe7JaYLmFX3Ax0REgSHPGR8cTPzjt75M99BGZWiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nmc47HQizRRt1JgKSUFPwD1OrG0yITvOHjbKi7FS08A=;
 b=Fjx1OlS0WGEqtEcFhWy9Qj792mYobAOji14nzg1PJUccum8TVh8Nz8DyCIc6VI+xQKbyT/7vCVWBPY5LbXQqperr4T3UV2zMFyoP1EC6AaS1WVBrxeWghj1KRiyXHG39mPdUfTfHggz6qi+9eTx0dP0rgebC6O6ySeXM+2qVQ8sD6QvtuGuJDFqM2JH+DHRUGMjIL5jzlBf9V3g+vEiFH3dH+3T5zrJ8peNVSXehn3Ym4CG+tpQzoeMs0W685bW3wAakSU4Na3iLQSEYx9ixbNvWAZiiV37eben4S/NrbuLfbCEzbJIbGUlDmkm+BRfN+Qd/ErHrs/ix/TCZCLMXcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nmc47HQizRRt1JgKSUFPwD1OrG0yITvOHjbKi7FS08A=;
 b=xADyuWMVAooZ+Y388WhFBFKSqNwayGwZGjUzVS8rFKG/cOIsb5pPkrg1nhK9QaZiCjxlI93RcB5Fonn0Vdy8eciTjsBbW/gzdr+BczjTvhOzmOxBwz8SBE1STxrDdIZPGoptG2AkJUEe4LOBdbYxSr3lUfO94j6dIGK1vgK0W6I=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by DM5PR10MB1322.namprd10.prod.outlook.com (2603:10b6:3:e::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5102.19; Wed, 30 Mar 2022 15:26:56 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::1483:5b00:1247:2386]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::1483:5b00:1247:2386%4]) with mapi id 15.20.5123.020; Wed, 30 Mar 2022
 15:26:56 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     andrii@kernel.org, daniel@iogearbox.net, ast@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, toke@redhat.com,
        sunyucong@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v5 bpf-next 5/5] selftests/bpf: add tests for uprobe auto-attach via skeleton
Date:   Wed, 30 Mar 2022 16:26:40 +0100
Message-Id: <1648654000-21758-6-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1648654000-21758-1-git-send-email-alan.maguire@oracle.com>
References: <1648654000-21758-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0362.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::7) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aad1d0cd-11a6-4ed8-8e6a-08da1261b986
X-MS-TrafficTypeDiagnostic: DM5PR10MB1322:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB1322907F7CD6935EA823ED5DEF1F9@DM5PR10MB1322.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ee+odXd884Uh8WVTF7sdaG+Dvj32gLyx8Gpr2ifH0D/IGaca7jdL7bmY5q6w7qVR3pvF3x6R39qL8Axy2brKoS0YfrpL3HdcAzvgY1Pxz7ARw1FITxu0ncCxYIKQ2jIlTr5DLLq9CZU6dIml8Lm2NuhQiNZxBeXO6EzoaZuwDKP8k/3HEvcnVJxCKjUF/7fJNGLJj+l2kxJY4/6Itzy0pisGuOFguuWLEopBtwfH71qT9YvJA9m5Rpgl6J/SH4sEnLl01aD1hl54/JKMN8Ij05c8u3BFCBwx0G84BtIpJwDNPhOxp8Xt0q2cb3PJRsFbnirj65do0SBAvDYij0tXj/W6etyuFlGEOgnGUOHoOb9aXQiprOJu3ZPt46U/uUc+/k1WvHT/JXwFqVrQX9jKsN+kHYOqGB4lDUY6G2Sz2NepxQuZnENXnPX3+lCOgxILG4bLHU2VEjF1irllVB/f3Fw+FDE578HRxCoQfLZuxUeUfxJKgtjl1aC4iUb2Fgjvp8PK6NRx2y0FOkpqQCVfQ1KIHObtkvSu5H/iv2nhI64A/wg+nMC7qv5g35AdFEin1dY/zWpjQs7h4UMlr59pyLYGIiYWdksoahu/YHx15mrWxgs5+usenbzfnlEDhfggXlfEn1C+m26S0vgd+IDOLVaZcbMW99khKEIeI/GdL34jowGxl/QxZw9rRWC3qLRiAyGNYMr2HfxEwl1Yal4hyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(6666004)(26005)(38350700002)(186003)(6486002)(5660300002)(316002)(2616005)(38100700002)(44832011)(107886003)(7416002)(2906002)(66556008)(36756003)(66946007)(8936002)(8676002)(4326008)(66476007)(6512007)(52116002)(508600001)(6506007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g3wFk6nI8wzzcMCwvH+I7hzLC/HKFeUCux3dKnRWueq8wFA7ziCcJrCVGLmC?=
 =?us-ascii?Q?zCPM6YM1SQGTHcyWxrVkYuGxrijT23Y/zfRHjtx4b6JuyTxQMPtPAorNJ/p6?=
 =?us-ascii?Q?vEs/5a6Y5SNsVeqGMUIV7FytwYIaoJPpV2X1Lj47AVVGqyvcMYHZZZSdd7+E?=
 =?us-ascii?Q?w/CHLOX01JQdXcMbArU/y/H6PSAGe4+mTipGHsQsHXjAWcYvzOpdBSZ6AwN/?=
 =?us-ascii?Q?Wz5QALufATx5qRAvJTgMDlZcVuGZqKyobzxCuSlsBvKHFfM3ipd4EvXgDMqr?=
 =?us-ascii?Q?3X3lV3hF0dXCs0SZuHU3+bjSKksTyz0bp7peHnmgnxqb+wWYS/j+tSLjHspj?=
 =?us-ascii?Q?8eSlUQILPnuuh42e4wucLETKwNsIwwxh5BIGbHS/B0/Od0ybVruK8Zd10VRU?=
 =?us-ascii?Q?BjwbLoEd5urKaqE0G0lZmSV8o84oGmBS9R5tJYOHW35ls5+rUN+8MiN6uB1w?=
 =?us-ascii?Q?W6UxMkJNpZvRdtdYwOBw5FsyRZ0CP9O+NCy6fvGi7vHNofZ6BWpng7OTJe6c?=
 =?us-ascii?Q?9Xi+KIvP9QXbiTMsiGANdFKwU3dUPVKjeD+fD7AH6r5MZUwBrdh9pTGm3KzM?=
 =?us-ascii?Q?NgvyP4KbVcuKnWRUO4hp8aESZ6AMCuXIPPrp9aAo2B9NhwuZ1DkLlEoU+jA3?=
 =?us-ascii?Q?FwkQH939FVYnqwdZxwvXj0aQj9q9T87cuEDd6uivrZe1qrIB7DQumBgJS/b6?=
 =?us-ascii?Q?hYlN/fZtsTLhNss7bLlvxQBRCBAuALcwGUxhNRUsRCRKW0FVdnj52cN5koDe?=
 =?us-ascii?Q?bH1eijInYU2E1Ykjy2F6PxQ0ZtEygAjRF5fFxCIJEzg/Q6QqqWxBF/pNYWaB?=
 =?us-ascii?Q?3ffPHdF+vzopLhgJPFm3xw7IS8qmvH/O8AUrE17dwO8VvXTvDW5Cmgd3osCt?=
 =?us-ascii?Q?WI9RHuyuJMcmxt5jPchZgx0ITFaPWkyakU/zUBRo37Ub9+Oy3uqzo1vKj6Gt?=
 =?us-ascii?Q?9BlfmwlWnXDfS0SM4Z9JdTBsSHujknPNYr53b9H2/50Da3+1SLNeZ2S9KXfD?=
 =?us-ascii?Q?Xd6sJBHQ0Ywy43y//S1tF0txoax0TMiUuWD86gPsJQjQA7IZ9aRt+KcJbyTC?=
 =?us-ascii?Q?i5xeqd60Gl+l0wRTew2jUBwpxV8RsTsQgdt1gcTNCOCybJoM76a1MzCA9TnU?=
 =?us-ascii?Q?+EGsusntpx4z2ov+wgDowWjmoQTnWCR1/YHAJnHQWPPzwiMOe/OkdxVBUL3C?=
 =?us-ascii?Q?ILb7EyIERQStZBckUkmYpyRgVmYlPKPM7zvFn46l9eGjYy5q851pSohqjIJK?=
 =?us-ascii?Q?DdRmlaFISUoosVBGGjJ4LHMt33tMmJ7Kk918L1wNgHuWIt3oeTrHvwf1coX1?=
 =?us-ascii?Q?LOuQ+qAE7Sbi314Gc19A5GyMqXUXLsCGTmzhl1frVajSUm7bqicg+vinAFx8?=
 =?us-ascii?Q?unjv2kZy+pTCFa3s5AvSux1/ONwO2LG+7Wz/a/cGhHJERm2oXMsSqPb2CGjm?=
 =?us-ascii?Q?J4QCmHQXPKbMadz1Srpz8s63BLMDENTojAfuar3vjKiwWZ0ZcURVr6b4NPv7?=
 =?us-ascii?Q?d5LtyoMKLHyFuOV+81H6OVbVtlFTgCcF+3g+tUiEuBvczwZessGgMmkztVIB?=
 =?us-ascii?Q?T6U/57/ss27xq7YnZ+lzJXvIVq5t7rm/Xc6HTBydcC/WHNRIq6+yyB9F6+nd?=
 =?us-ascii?Q?7+tCZ2hqlVYA68BGSg6x5fweLyfqrA5dDYC7XPRoc65wiP+DEjiFi1BmdhL9?=
 =?us-ascii?Q?zY3Z5qxTWYLhZ0FGKB+45Ahbq8AmUwZ/BA7qqIYB433/y9Nz4HgqCnVCn0/P?=
 =?us-ascii?Q?SY8WbjrD7JsuXxT2GjvP1z8MQTtU4nk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aad1d0cd-11a6-4ed8-8e6a-08da1261b986
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 15:26:56.2733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kbDFy4jNxnyFrtzRQafp3qA4GS+yDNb/6GU+EAG3ONCag0LctR1pQFEwDOfPEfU43bxJPkSlC+h/6ZSkVjR9Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1322
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10302 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 adultscore=0 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203300074
X-Proofpoint-ORIG-GUID: xg0POY3sZUlBqBchwB2Bi_UbnIUn_yOh
X-Proofpoint-GUID: xg0POY3sZUlBqBchwB2Bi_UbnIUn_yOh
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tests that verify auto-attach works for function entry/return for
local functions in program and library functions in a library.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 .../selftests/bpf/prog_tests/uprobe_autoattach.c   | 38 ++++++++++++++++
 .../selftests/bpf/progs/test_uprobe_autoattach.c   | 52 ++++++++++++++++++++++
 2 files changed, 90 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_uprobe_autoattach.c

diff --git a/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c b/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
new file mode 100644
index 0000000..03b15d6
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
@@ -0,0 +1,38 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2022, Oracle and/or its affiliates. */
+
+#include <test_progs.h>
+#include "test_uprobe_autoattach.skel.h"
+
+/* uprobe attach point */
+static void autoattach_trigger_func(void)
+{
+	asm volatile ("");
+}
+
+void test_uprobe_autoattach(void)
+{
+	struct test_uprobe_autoattach *skel;
+	char *mem;
+
+	skel = test_uprobe_autoattach__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "skel_open"))
+		return;
+
+	if (!ASSERT_OK(test_uprobe_autoattach__attach(skel), "skel_attach"))
+		goto cleanup;
+
+	/* trigger & validate uprobe & uretprobe */
+	autoattach_trigger_func();
+
+	/* trigger & validate shared library u[ret]probes attached by name */
+	mem = malloc(1);
+	free(mem);
+
+	ASSERT_EQ(skel->bss->uprobe_byname_res, 1, "check_uprobe_byname_res");
+	ASSERT_EQ(skel->bss->uretprobe_byname_res, 2, "check_uretprobe_byname_res");
+	ASSERT_EQ(skel->bss->uprobe_byname2_res, 3, "check_uprobe_byname2_res");
+	ASSERT_EQ(skel->bss->uretprobe_byname2_res, 4, "check_uretprobe_byname2_res");
+cleanup:
+	test_uprobe_autoattach__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_uprobe_autoattach.c b/tools/testing/selftests/bpf/progs/test_uprobe_autoattach.c
new file mode 100644
index 0000000..b442fb5
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_uprobe_autoattach.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2022, Oracle and/or its affiliates. */
+
+#include <linux/ptrace.h>
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+int uprobe_byname_res = 0;
+int uretprobe_byname_res = 0;
+int uprobe_byname2_res = 0;
+int uretprobe_byname2_res = 0;
+
+/* This program cannot auto-attach, but that should not stop other
+ * programs from attaching.
+ */
+SEC("uprobe")
+int handle_uprobe_noautoattach(struct pt_regs *ctx)
+{
+	return 0;
+}
+
+SEC("uprobe//proc/self/exe:autoattach_trigger_func")
+int handle_uprobe_byname(struct pt_regs *ctx)
+{
+	uprobe_byname_res = 1;
+	return 0;
+}
+
+SEC("uretprobe//proc/self/exe:autoattach_trigger_func")
+int handle_uretprobe_byname(struct pt_regs *ctx)
+{
+	uretprobe_byname_res = 2;
+	return 0;
+}
+
+
+SEC("uprobe/libc.so.6:malloc")
+int handle_uprobe_byname2(struct pt_regs *ctx)
+{
+	uprobe_byname2_res = 3;
+	return 0;
+}
+
+SEC("uretprobe/libc.so.6:free")
+int handle_uretprobe_byname2(struct pt_regs *ctx)
+{
+	uretprobe_byname2_res = 4;
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
1.8.3.1

