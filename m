Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8A548C825
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 17:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355095AbiALQUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 11:20:20 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:31368 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355114AbiALQT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 11:19:29 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20CGJBbj009449;
        Wed, 12 Jan 2022 16:19:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=1g4DumJDGdbQ1l13iMGBSErBU8FnprHqZ80LsebhFWQ=;
 b=vAly4v5M0DSeRrtAYg5H3CyjWn3MQt9Hg1fCm1x7Zm3zQrKApTcFCqlG1+N01x5crtA6
 6jrYAJ5Km0w/RANyIQnhKzYTZne4hF+mi2Au2ZGDWf4TZYXJxrNdgSaEZQ64kEaPXfca
 o4zxbCmQjX+Fkc7wty/43Xlk8gq45W2j3cX81mVBNXFjMixpkunqUij2lidXGFaeS6K1
 KQe40e87Y97w8P181JTrJu/VLsjIH38c1YnomgkA3S4jMmObGZonnXn96KeWV2P6/1kl
 4yrcs1VdePhQdd1xyZRMY/Qu5d3nd3mJjOMTwKt+P2I0FGM4F5Zs6MiDDsC3InbY8uTq IQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgn74ekud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jan 2022 16:19:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20CG8DbC073456;
        Wed, 12 Jan 2022 16:19:06 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by userp3030.oracle.com with ESMTP id 3deyr051gm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jan 2022 16:19:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JrCxLtl8QTNfFX/NYPr51z44YFCRbbN0GgIR+hAsCCgew5j4KRo4CSTZRfa3vSb/+W8fcTuXFjEib3Z7vFbMQyCgl+F1m1f937SCEIz9cpVPs0qVpBRlUyIC6/vn0EF0UmC3F+RTTzzRMZ7gNCya0zrIysb7rG0Bd6RCihHG/PQF7vBKmh9PLaln6473NcjbRmnz3T0hZZh7rgvWulylev3HE8GONMIYApfM6opJi9RayeBDmE7g4pHuNtgscv/XgDHtNFcGc/fjnI4ELjoBRqVVHdj6srJNy7ylwhyvFXznP7NlBzrfAYqpqc7Fx0wOe5CiCApbx8HjO6wSiZd0Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1g4DumJDGdbQ1l13iMGBSErBU8FnprHqZ80LsebhFWQ=;
 b=jXquegx/F5PcnDIE3vm9HxzzaWCZYi6jJtt32imKz8ZHDiYD58HGX3iaUP8CiAdNTyDO03f+6zOMNru6N3foZ3i3Lz9z+1XAaDJlscYauA4WwqTpV+J6f7sz+UmzmYHWF3qOdmBM8hO5L85scWJ1HELEUoe2TWd1CuwG8N+6sFlyhgSzBh35oaEJGVntLOTpmJxa1BjtFWObzt2yFj+QwKCT2UJD0t0JQcsRkyrB3xWxPuzfn8697Q+wCBuFL58NvTHE0uoJ5TITwqBD16Htou8gMvabuO1+wLVZSRO7OTO/VeIxBsKvRuDM6DVbRWCC1XailxHFejT0ful3ZBXL1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1g4DumJDGdbQ1l13iMGBSErBU8FnprHqZ80LsebhFWQ=;
 b=fCZePrfIFF3jKnkcH5Zdm0UG6uEQ7OF0IA9G267/4J2tSbv66OlT6m8k/4t8t6arnrWEZ+et0Iif1bHJ1Wevd+udwXjh3/NVxtIgSl23tnzl8qNXDEMBGVRZ5rwcu0w7+ZTeodtawqhlm7otqGQA/CLdng0IYsFJ2UPxV16erL8=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by MN2PR10MB3600.namprd10.prod.outlook.com (2603:10b6:208:114::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Wed, 12 Jan
 2022 16:19:03 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::31c1:e20b:33a1:ba8c]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::31c1:e20b:33a1:ba8c%5]) with mapi id 15.20.4888.009; Wed, 12 Jan 2022
 16:19:03 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, jolsa@kernel.org,
        sunyucong@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [RFC bpf-next 4/4] selftests/bpf: add test for USDT uprobe attach by name
Date:   Wed, 12 Jan 2022 16:18:49 +0000
Message-Id: <1642004329-23514-5-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1642004329-23514-1-git-send-email-alan.maguire@oracle.com>
References: <1642004329-23514-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P123CA0080.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::13) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 719886aa-b66d-4f5e-7639-08d9d5e73f85
X-MS-TrafficTypeDiagnostic: MN2PR10MB3600:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB3600B781FACE6CBC5D85EDC9EF529@MN2PR10MB3600.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OyegCkHxduNODGXVp9Ttf2fjToEfRPfPzSr39MIAVVUUYKi30IhxufJ5DSP2j0TIRUL7QZ6erJERKbpZmpBkgZ/pq6gaFcYiYTE6zmn+d/prdi/0Dpw76PwRSGn3cSHPSp3/NB09ScFCfUQu4k3K+0EdDox5tIHXyik9BikvnhQLHf0BHgPQaVOlApCIy3pNO4d/DAUnJTsMrG0aJ4bg11KaJfy8MQD3PwsPWGi3cw3TKMpRZ/5GiMd0Nup5eAuK2NHRS8KFxqU5BkvVGVNMugpX+R597qisgNyY87eE3KchpwyF/vvhjn3RjrscYpPUh8fa8SsmQiWj/bMGiw8Z3UjlNyKRGx17lGzj5NBwgSE2rC2BWFpVp9fLLl/cW74wXhAqPD6tUBEv4FcBERto/gCxKIslru29BX5KSSGhxWluiALTvMpU0zoUO782wURv9p/CCq4wBqr//juyxQYkbsNki+5RrJP6HtHRX7nyhN6QIOgMNCXmlRLRygbQCERAVK7t+0fgubmZYEezJmBHzmd4wbX1ou+0dZnGetD2evp1fxFLaNjDY1vt4AvGyhhOzdBdmivZNBz465yaqCtyyCIn1cXUYhJ6KMdAPhbLEO7RG25DblNos1vGmzPtTajeEC53KIHBP8uDIKPpuatzs2VEoLXlu4Fn0mFIFIFyu+V3sS30fZUNg+zIfuE7LI4r43Yxff/QmI9x1E6R8LQIow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38350700002)(8676002)(66476007)(8936002)(6486002)(36756003)(66946007)(2616005)(5660300002)(44832011)(107886003)(6512007)(66556008)(316002)(86362001)(7416002)(83380400001)(2906002)(4326008)(52116002)(26005)(38100700002)(6506007)(6666004)(186003)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?85+N3TvmLHj2ZDEK8U2N1+Clv2M2Qa1ggoTUgMBL8PFcznrdkZFMBcb/7P/S?=
 =?us-ascii?Q?jBAmosuzZTRGRMq0lr0/X87M5+DRLKymi9RElryp1hNcyGZRt1W+M5S6fZ7h?=
 =?us-ascii?Q?HwoktElkCuXqzt93vUFfHpYHchhGTpz6ev4KS/0VCH5WRMcYb5pdKzh2suA2?=
 =?us-ascii?Q?N1YyZgCGnb7O7N7ywL/4lCG4lPWzYGicrGMNNNUVNrRd9+X6VUz6R7E3wO7y?=
 =?us-ascii?Q?lQ1Sw3tFZnU1UmgKlMHQHABSofl/dAm4hRlTX5oEz1VMeHSUnwbdQEywk77y?=
 =?us-ascii?Q?xBNjbuVfv5rTmyafCAj/WSg+Y19mdA/oT66RQAooPV81H4xM5xPIHkBvv0rh?=
 =?us-ascii?Q?Ic/jXdAJstRmOvj1Qd9MITLjNscd4QeAS24ZnwWkq4x3ROYYYpoJ/piSHcVq?=
 =?us-ascii?Q?cezdMnM0Aaw+NBKOWKtC26Lz5qbtfygko/Z9jNodYhRwR0UptNi3P9Addrsg?=
 =?us-ascii?Q?ZJKQktsiAVI/lQjvsXf8NR4NBq5y2Opi4PS2v+I719IaNxqmvbPK80evnx/n?=
 =?us-ascii?Q?VpuhjSeAQ92MqkwaMxXctYpzszdRfvcS75HmZsnXCD7wpHcPIKx5OEE/oySc?=
 =?us-ascii?Q?/hwORbIstAp6Wnv2wIoCTo6aN1khvUGI3W99mavN2fKqHWEOOJm/JohJt1JH?=
 =?us-ascii?Q?jCNpk2xENty5nzHgjhDXEgjFYuuIzVmFDedzrPzBfW7koqiWnkMl9Ts8JThB?=
 =?us-ascii?Q?SZm6TgvS1kuio9ybZ5rzIhm8lCfqk/0m0DZOcUaVqv98zVnnj8ZPshx2131/?=
 =?us-ascii?Q?ZEVMEIRsGc66PkCXEaKLK7NhnwobMlPQssKkWoBfQgsTOOebr1IVsnj08hYc?=
 =?us-ascii?Q?LtcjAQvHiokHyb/LrmI1NwxeEu1VUK3VbyXY4kWe4rWW5fj/CiPmeb/ABtk+?=
 =?us-ascii?Q?dTs+0eRt+yEkUrIQ4GN9VJPQBI7004/obKwU4mn2oPEpiNDi9lpfmdaJ/PFz?=
 =?us-ascii?Q?7UlNmFcGAD0ucvBmRRTuWUtgdmvwz0fM5PYgYlBF+FVfzCJKiVeJ8T+0dmlO?=
 =?us-ascii?Q?AhcQVSRISWK2Ho4L0nmplwkKyOcnHMOHh/r0YlPHofYwpad9XrO9kP5T7yKV?=
 =?us-ascii?Q?KPf0f6aS3gWzAPFOcYGiRVr3Ldw4qAtmLeQKGTHy4pNGj0ZEumsyfUva0/5O?=
 =?us-ascii?Q?zH2Pzy2+ex9TMff4Q/vdvsDFzGVVXw3gfrsT9J9+Y2UdqC0xlBrByjxuiyvh?=
 =?us-ascii?Q?LxC7sW6GQVvlSqCwCfwyokCmiIyCJoZZnRpaOEhJnH3XdyOvPXq97rqbhTYv?=
 =?us-ascii?Q?afAu1d08H3IpC+66pzfohWAOebMtl6C0kGsSYRC/6/yFpgCd0NWR4f7URA4x?=
 =?us-ascii?Q?wmuHm6j0JTYsH5iHDvCioZQbeniEBSbfqMzCjfi3HxAbmPXBImwwQhoN0LDY?=
 =?us-ascii?Q?Qn2C9ZwL5eyXwgHw0z4fQ8pedR3Rf3Ol3VW6ZpbsNMCahCsQkDTjEkMCj16d?=
 =?us-ascii?Q?IrYwcd4+uH7QCp7cg4yCDPS4N002JpfA3VflenUs2cn59Az9L1KfcoUFhwJi?=
 =?us-ascii?Q?Po4VQ+IusJUpGsonvBz3j9kPctNg7y3ERQApMH15bwYkkeoVgyzmvgkezdAq?=
 =?us-ascii?Q?YSxnPDs5fTe7xXPL+Jyv1z8nBHtAHYpCejTAb/keqI1UbCdKVMu5z+pVzY94?=
 =?us-ascii?Q?pYEbx9dIU7fVCIwSm01cVKY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 719886aa-b66d-4f5e-7639-08d9d5e73f85
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 16:19:03.2164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G6XJ6D8CZa3LbQDTT/3L/tsTA+Pory8BQzcskKycoVLLPv7ZN5Vfg95u3MShHZapoLpuXXJm6T75MX40hTCU3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3600
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10225 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201120103
X-Proofpoint-ORIG-GUID: tSlmSaKyZA5fGQE5h9-E78I69wh12SPv
X-Proofpoint-GUID: tSlmSaKyZA5fGQE5h9-E78I69wh12SPv
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add test to verify attaching to USDT probe via specification of
provider/name succeeds and probe fires.

Depends on presence of <sys/sdt.h> as verified via feature-sdt

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/testing/selftests/bpf/Makefile               | 34 ++++++++++++++++++++++
 .../selftests/bpf/prog_tests/attach_probe.c        | 33 +++++++++++++++++++++
 .../selftests/bpf/progs/test_attach_probe.c        |  8 +++++
 3 files changed, 75 insertions(+)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 42ffc24..3a7e3f2 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -3,6 +3,14 @@ include ../../../build/Build.include
 include ../../../scripts/Makefile.arch
 include ../../../scripts/Makefile.include
 
+# needed for Makile.feature
+ifeq ($(srctree),)
+srctree := $(patsubst %/,%,$(dir $(CURDIR)))
+srctree := $(patsubst %/,%,$(dir $(srctree)))
+srctree := $(patsubst %/,%,$(dir $(srctree)))
+srctree := $(patsubst %/,%,$(dir $(srctree)))
+endif
+
 CXX ?= $(CROSS_COMPILE)g++
 
 CURDIR := $(abspath .)
@@ -32,6 +40,26 @@ ifneq ($(LLVM),)
 CFLAGS += -Wno-unused-command-line-argument
 endif
 
+FEATURE_USER = .bpftest
+FEATURE_TESTS = sdt
+FEATURE_DISPLAY = sdt
+
+check_feat := 1
+NON_CHECK_FEAT_TARGETS := clean docs docs-clean
+ifdef MAKECMDGOALS
+ifeq ($(filter-out $(NON_CHECK_FEAT_TARGETS),$(MAKECMDGOALS)),)
+  check_feat := 0
+endif
+endif
+
+ifeq ($(check_feat),1)
+ifeq ($(FEATURES_DUMP),)
+include $(srctree)/tools/build/Makefile.feature
+else
+include $(FEATURES_DUMP)
+endif
+endif
+
 # Order correspond to 'make run_tests' order
 TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test_progs \
 	test_verifier_log test_dev_cgroup \
@@ -108,6 +136,7 @@ override define CLEAN
 	$(Q)$(RM) -r $(TEST_GEN_PROGS)
 	$(Q)$(RM) -r $(TEST_GEN_PROGS_EXTENDED)
 	$(Q)$(RM) -r $(TEST_GEN_FILES)
+	$(Q)$(RM) -r $(OUTPUT)FEATURE-DUMP.bpf
 	$(Q)$(RM) -r $(EXTRA_CLEAN)
 	$(Q)$(MAKE) -C bpf_testmod clean
 	$(Q)$(MAKE) docs-clean
@@ -434,6 +463,11 @@ $(TRUNNER_TESTS_HDR): $(TRUNNER_TESTS_DIR)/*.c
 		 ) > $$@)
 endif
 
+# support for adding USDT probes?
+ifeq ($(feature-sdt), 1)
+CFLAGS += -DHAVE_SDT_EVENT
+endif
+
 # compile individual test files
 # Note: we cd into output directory to ensure embedded BPF object is found
 $(TRUNNER_TEST_OBJS): $(TRUNNER_OUTPUT)/%.test.o:			\
diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
index 521d7bd..5bb24927 100644
--- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
+++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
@@ -2,6 +2,17 @@
 #include <test_progs.h>
 #include "test_attach_probe.skel.h"
 
+#if defined(HAVE_SDT_EVENT)
+#include <sys/sdt.h>
+
+static void usdt_method(void)
+{
+	DTRACE_PROBE(bpftest, probe1);
+	return;
+}
+
+#endif /* HAVE_SDT_EVENT */
+
 /* this is how USDT semaphore is actually defined, except volatile modifier */
 volatile unsigned short uprobe_ref_ctr __attribute__((unused)) __attribute((section(".probes")));
 
@@ -22,6 +33,7 @@ void test_attach_probe(void)
 	struct bpf_link *kprobe_link, *kretprobe_link;
 	struct bpf_link *uprobe_link, *uretprobe_link;
 	struct bpf_link *uprobe_byname_link, *uretprobe_byname_link;
+	struct bpf_link *usdtprobe_byname_link;
 	struct test_attach_probe* skel;
 	size_t uprobe_offset;
 	ssize_t base_addr, ref_ctr_offset;
@@ -121,6 +133,27 @@ void test_attach_probe(void)
 		goto cleanup;
 	skel->links.handle_uretprobe_byname = uretprobe_byname_link;
 
+#if defined(HAVE_SDT_EVENT)
+	uprobe_opts.usdt_provider = "bpftest";
+	uprobe_opts.usdt_name = "probe1";
+	uprobe_opts.func_name = NULL;
+	uprobe_opts.retprobe = false;
+	usdtprobe_byname_link = bpf_program__attach_uprobe_opts(skel->progs.handle_usdtprobe_byname,
+								0 /* this pid */,
+								"/proc/self/exe",
+								0, &uprobe_opts);
+	if (!ASSERT_OK_PTR(usdtprobe_byname_link, "attach_usdtprobe_byname"))
+		goto cleanup;
+	skel->links.handle_usdtprobe_byname = usdtprobe_byname_link;
+
+	/* trigger and validate usdt probe */
+	usdt_method();
+
+	if (CHECK(skel->bss->usdtprobe_byname_res != 7, "check_usdtprobe_byname_res",
+		  "wrong usdtprobe_byname res: %d\n", skel->bss->usdtprobe_byname_res))
+		goto cleanup;
+#endif /* HAVE_SDT_EVENT */
+
 	/* trigger & validate kprobe && kretprobe && uretprobe by name */
 	usleep(1);
 
diff --git a/tools/testing/selftests/bpf/progs/test_attach_probe.c b/tools/testing/selftests/bpf/progs/test_attach_probe.c
index efa56bd..0c93191 100644
--- a/tools/testing/selftests/bpf/progs/test_attach_probe.c
+++ b/tools/testing/selftests/bpf/progs/test_attach_probe.c
@@ -12,6 +12,7 @@
 int uretprobe_res = 0;
 int uprobe_byname_res = 0;
 int uretprobe_byname_res = 0;
+int usdtprobe_byname_res = 0;
 
 SEC("kprobe/sys_nanosleep")
 int handle_kprobe(struct pt_regs *ctx)
@@ -55,4 +56,11 @@ int handle_uretprobe_byname(struct pt_regs *ctx)
 	return 0;
 }
 
+SEC("uprobe/trigger_usdt_byname")
+int handle_usdtprobe_byname(struct pt_regs *ctx)
+{
+	usdtprobe_byname_res = 7;
+	return 0;
+}
+
 char _license[] SEC("license") = "GPL";
-- 
1.8.3.1

