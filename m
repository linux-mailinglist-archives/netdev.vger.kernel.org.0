Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127D73AD8C4
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 10:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234325AbhFSI7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 04:59:09 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:8308 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233913AbhFSI64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 04:58:56 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15J8uSeV019976;
        Sat, 19 Jun 2021 08:56:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Nq8dOzeS2qyHNGrqzPmtLMtCR01Zm90VfFBV9xBgqIg=;
 b=lOSM8ClP2UEwk6685ltWqyMjmfuXXw8wKCb2LxAnrkkoKhffi0UBehUgYjuK92rFlurO
 GDVzqRYOYcwIs89laJXtRVkV4YrLCyjTmQAzg/EUCWAWQZKEPhfyx7wzSJRtgRj/JPs6
 qu2MhpcIZi186J3edPlj3gfqWlPIJs6qxUi8cDaxTXKlDJmdUUtFuaizsPHVJkeHvkHT
 NJVhFPX9Fz/1O9Obr7bHKaX+mJVAfWwL8LJzpp2xNPUWEpU2D7J5yxzmGrsScPcT6wMy
 xP7EA20EM8z5FCz16HPjJHY9kyowtXNumD3y7oKwhHVo403FAbfykj7nsh6dXRM0WXIr Lg== 
Received: from oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3998f887gh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 08:56:28 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15J8uRwC022639;
        Sat, 19 Jun 2021 08:56:27 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by aserp3030.oracle.com with ESMTP id 3996ma7fts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 08:56:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CxAIU8WvrJXyScL1nhDKUapr6OICIzaOUhkBlTCcteon2F9n0gGwX85SXFBR0i9wmlbwAaQ6v2xE+kkJxsYM7Sn7rE0RR+27Kx/3c8Tb6pz7r5MueW4GvDAmh6ac/eLHYA/GlXp5JJx1VYzBEZGFXj/EjqSfNOxma7jBn3bybAHh6pySak/o03nKRODaucBdtNWdpsqZ0vU6HPhF10Xyk+RjR+CQmY7UOtxLgYtJ7vI2Q0SDvkIPXzO8NbOrU1Zz3wY9D/35qViwAZJ/TZmXH97S7bhbTGczvY5lm6WEG9lgHf6CSytg2yZor07OGGIecQqGT3ECHIJkRG7uJ42c0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nq8dOzeS2qyHNGrqzPmtLMtCR01Zm90VfFBV9xBgqIg=;
 b=WfVBNJsnPtklBnE9veoAx7dw8HoKP0xki6a3gztnDqCOLBBdEP/d03Fk6uaQDJfGtUKVD0mgF/Y5hXawh5L/c+0mAyu6dq81XS15tvxJ2EZayeTJ6wmS7QVJQ0FgrXUMaBR3Zev+9fm+WfBDQWc+cPeomUkubh9E9SbJM78FFar5AtC/xsrumSkKsowB5zWD0L1mqBSDhWCwtr0vSa0Pc33P5QOVgX9663NEF0uarQC+Drm2EIhi8A8FEGYJnLGrX1vImgM9h3l9af/ovyDpREjTEjlAaooa8r7gq02teET0y//imvY3xBi+TnBP8S7nke7Ra/HJG68+pYj5HXejgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nq8dOzeS2qyHNGrqzPmtLMtCR01Zm90VfFBV9xBgqIg=;
 b=MP2IPUKimJZBJRr9Z/ze+hrzqutV9ZunDfnHQ5RO3jZkKp+lblE2YrKS8DF4t3hJSDHDJqu6ixFCP0QlmannelV/hqblUpkXSanbUorW6fq2jQdDGCKGpvrDzNiSolZi/17/lLZnauNvnQyAspnwSj82Dj/RND++SpZO6BzvtMc=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by MN2PR10MB3357.namprd10.prod.outlook.com (2603:10b6:208:12e::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Sat, 19 Jun
 2021 08:56:24 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::9da7:f131:1f41:657c]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::9da7:f131:1f41:657c%4]) with mapi id 15.20.4242.023; Sat, 19 Jun 2021
 08:56:24 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v5 bpf-next 1/3] libbpf: BTF dumper support for typed data
Date:   Sat, 19 Jun 2021 09:56:06 +0100
Message-Id: <1624092968-5598-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1624092968-5598-1-git-send-email-alan.maguire@oracle.com>
References: <1624092968-5598-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-Originating-IP: [95.45.14.174]
X-ClientProxiedBy: DU2PR04CA0245.eurprd04.prod.outlook.com
 (2603:10a6:10:28e::10) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (95.45.14.174) by DU2PR04CA0245.eurprd04.prod.outlook.com (2603:10a6:10:28e::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19 via Frontend Transport; Sat, 19 Jun 2021 08:56:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f52154e-3f8d-4f41-cbd6-08d933001d8a
X-MS-TrafficTypeDiagnostic: MN2PR10MB3357:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB3357788265EE749EE805CEFDEF0C9@MN2PR10MB3357.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KWtT81IbcWtcuRHHadWr6y9XBVxiOkPRP2x0cQmqQAJVkh3roNBnpqldUWroWXb7blUmn20m5zM7enyIFOfW9ZX5FpNnGOC4mZCLbzicjAV5jbBlXaAntpq3jbPUqlTXDUZZZQQxLmlwXD136hlFwhNsExJoEOgpZBVW7hDnjMiEcVUBCIyjNw3OQ772wegxccVWMOE2xVZbvO8tlK5JibrsdKmZBV/arCVxtoiHRYNML52EhBTYDrQnhtA5WHn4r6og3+ZlfGzUeFtPEytksXKc+GaleZOFgPnZctJyv+5Fd4l76ENfz7YTQJ5RIH8T+BxWo9GerPz4Mu+2IozOSgMC/TaqNN13gyDwP6PlxGLu95cN7xp1lzVa3ubhKohq0yvz5UnWQXLelgRuwJ5Xj7/BRoFaxZ1RcCAvKkdHz7zT/iPep4VJOg48zA8pGn6BwdLUvfjDkpRa2VkVY4VWrDSXboOkGdT3ZdtN75NUZz7TJeiKzmdZUbvrt+4JSfmUdLG1SRjm+sdCH+M5jVZxuNtkPzbQFatIvKXhbEheed2viCAemLo4IKOC76T+W0X77AO6jrJJcoB/SQQOUnuVHYLnKHkOhxsj5un9JNM0NJyDFjus8GpYigsVgxjkKss74lFLtrEa2l/+F+FGvB+vGzUym7lhJrTBPpL2sHuPxcC4iCWfXKMHLa/07LqvuUel
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(346002)(136003)(366004)(478600001)(5660300002)(4326008)(26005)(52116002)(44832011)(86362001)(66946007)(83380400001)(6486002)(16526019)(186003)(66476007)(66556008)(6506007)(2616005)(956004)(107886003)(316002)(30864003)(36756003)(7416002)(6512007)(8676002)(2906002)(38350700002)(6666004)(8936002)(38100700002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lkqb5dNvnEAgZJKWNTSC48j+9usBjefKJlCCorQS3H7NjuYpYGROQ9ZE+IMC?=
 =?us-ascii?Q?31WPP7TX/6BlIvkE1AkJi00oA6ZkutSbcx2vT2AYcgv1sZgC5Mbfx61gaogh?=
 =?us-ascii?Q?768sGdTomOFzB07mpcgTeDFwUmT9gXsJRTosn3+RcweGUVTaIjuzXFKe0s0D?=
 =?us-ascii?Q?XtUrbG4WvrQ1g0QOrAmRaTXodVTlSnO01kUTrV/xvyUct7RciHcuJtCHdn/b?=
 =?us-ascii?Q?Hcd1gOscujsaG61vKNgdx3YHQ7VkMTePZGDgQEpysJqSgf5/SG49KjhRt5KZ?=
 =?us-ascii?Q?wyBmGWxnG0gRy7xcq3izqKkwF4K86xVKAdIKHMrOPg2MiEMXmBbM7z/Kt6tV?=
 =?us-ascii?Q?woynZwouCWPoCPxG00flWhyMbQvV4eLCCPew+SmsKnP1Wo7KvPHpRAabhI0i?=
 =?us-ascii?Q?zL3GCmKGOYa7x50IMvRblTYxbPzBsfCG6tpqQuvAQTzjtzfZTyHP+9KIRu4A?=
 =?us-ascii?Q?5VKMOND8dIQcmpTCogRorB0gakS9dwplaLaHjTk85ok5ID+XGO0I7Xk5IbFi?=
 =?us-ascii?Q?D0C4DXV+mVIPL7Vq2NZd3GA4COJLILeaWRXLfl4PI1eW51Uyav7AM3eA36CH?=
 =?us-ascii?Q?6D/1vDhyoMQ4Uy1f4nMg2T+pJcrhXcC0HiEIWJ1MCHX+ukkQrX4REKZlWDvX?=
 =?us-ascii?Q?yxbKRKTJf+nP8yPLjlqdYr0aYYjpzN7o3fwSkCIX++29oA3XuvyFtrXcmcRR?=
 =?us-ascii?Q?4myyp3wLr6Mgvn25m12bSPsqtyihBMRWKR+UPGrWE2ZDwGfC7v9bY4/t4rEq?=
 =?us-ascii?Q?x9I8YzUZxWUAGAMJacYHdgsbPO3DHwhM4i5onYYnRd6Bl30Hzu/SynHAp+Yq?=
 =?us-ascii?Q?VVLPLNnDyO9KA4uUp9RPI8bcjSKmhd+kK3tOlVoITcu6keVLTbuwCmCvI91B?=
 =?us-ascii?Q?rndTSrAs5hzo4ymZ2Pvx1IGhvaNLLbzLpi4dHxA/HZvRYZcXnQzEp8StmpNf?=
 =?us-ascii?Q?KqKNfRBMi4ozmOQM8QUhqtCTORXTSIrEacV2uiFanvmmxorGwNS4OmGvIcK/?=
 =?us-ascii?Q?45lbcf6UJUdg+lqzElwno0BwD4XsLYdRytNVDqFnNc8A3c+QZ+wyK9a04lKK?=
 =?us-ascii?Q?e93YP1XYun1ENaDWNf+bGczNzEuoDGFgXopAfINKt1i+M5/GwrvbCDkfx1Oo?=
 =?us-ascii?Q?idssqj9Tnf6nY/wlwks0w5SkV1IOCAdBYPmVPdO34WItzlXG+nUlpGxGfUGG?=
 =?us-ascii?Q?dhBrNl5OKYXveU/6xdFkbdkSq/pSfwRmM04vPSmBilJCu3c8WNg8PXowtIHg?=
 =?us-ascii?Q?puUH713ZRAyvzFg1VHALlWQqy7JWaHypr1JyN+1nNFkl8JUJufkE7dRjQO7n?=
 =?us-ascii?Q?aErRchLbVCtwfR3cNeKYHN7y?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f52154e-3f8d-4f41-cbd6-08d933001d8a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2021 08:56:24.0060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YiiRwt4/ShJKnKi7OQg2xIaiIPSRAfuVTqaPopq0GZjZBBfLuszc+ai4qTAxbjCRSXvNr+zDm3jI+1BNP8wnOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3357
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10019 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106190058
X-Proofpoint-GUID: jJnMFTtxS3-RnRKTsOk8w3qL8zfMxU5s
X-Proofpoint-ORIG-GUID: jJnMFTtxS3-RnRKTsOk8w3qL8zfMxU5s
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a BTF dumper for typed data, so that the user can dump a typed
version of the data provided.

The API is

int btf_dump__dump_type_data(struct btf_dump *d, __u32 id,
                             void *data, size_t data_sz,
                             const struct btf_dump_type_data_opts *opts);

...where the id is the BTF id of the data pointed to by the "void *"
argument; for example the BTF id of "struct sk_buff" for a
"struct skb *" data pointer.  Options supported are

 - a starting indent level (indent_lvl)
 - a user-specified indent string which will be printed once per
   indent level; if NULL, tab is chosen but any string <= 32 chars
   can be provided.
 - a set of boolean options to control dump display, similar to those
   used for BPF helper bpf_snprintf_btf().  Options are
        - compact : omit newlines and other indentation
        - skip_names: omit member names
        - emit_zeroes: show zero-value members

Default output format is identical to that dumped by bpf_snprintf_btf(),
for example a "struct sk_buff" representation would look like this:

struct sk_buff){
	(union){
		(struct){
			.next = (struct sk_buff *)0xffffffffffffffff,
			.prev = (struct sk_buff *)0xffffffffffffffff,
		(union){
			.dev = (struct net_device *)0xffffffffffffffff,
			.dev_scratch = (long unsigned int)18446744073709551615,
		},
	},
...

If the data structure is larger than the *data_sz*
number of bytes that are available in *data*, as much
of the data as possible will be dumped and -E2BIG will
be returned.  This is useful as tracers will sometimes
not be able to capture all of the data associated with
a type; for example a "struct task_struct" is ~16k.
Being able to specify that only a subset is available is
important for such cases.  On success, the amount of data
dumped is returned.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/btf.h      |  19 ++
 tools/lib/bpf/btf_dump.c | 833 ++++++++++++++++++++++++++++++++++++++++++++++-
 tools/lib/bpf/libbpf.map |   1 +
 3 files changed, 848 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index b54f1c3..5240973 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -184,6 +184,25 @@ struct btf_dump_emit_type_decl_opts {
 btf_dump__emit_type_decl(struct btf_dump *d, __u32 id,
 			 const struct btf_dump_emit_type_decl_opts *opts);
 
+
+struct btf_dump_type_data_opts {
+	/* size of this struct, for forward/backward compatibility */
+	size_t sz;
+	int indent_level;
+	const char *indent_str;
+	/* below match "show" flags for bpf_show_snprintf() */
+	bool compact;		/* no newlines/tabs */
+	bool skip_names;	/* skip member/type names */
+	bool emit_zeroes;	/* show 0-valued fields */
+	size_t :0;
+};
+#define btf_dump_type_data_opts__last_field emit_zeroes
+
+LIBBPF_API int
+btf_dump__dump_type_data(struct btf_dump *d, __u32 id,
+			 const void *data, size_t data_sz,
+			 const struct btf_dump_type_data_opts *opts);
+
 /*
  * A set of helpers for easier BTF types handling
  */
diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 5dc6b517..c59fa07 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -10,6 +10,8 @@
 #include <stddef.h>
 #include <stdlib.h>
 #include <string.h>
+#include <ctype.h>
+#include <endian.h>
 #include <errno.h>
 #include <linux/err.h>
 #include <linux/btf.h>
@@ -53,6 +55,28 @@ struct btf_dump_type_aux_state {
 	__u8 referenced: 1;
 };
 
+/* indent string length; one indent string is added for each indent level */
+#define BTF_DATA_INDENT_STR_LEN			32
+
+/*
+ * Common internal data for BTF type data dump operations.
+ */
+struct btf_dump_data {
+	const void *data_end;		/* end of valid data to show */
+	bool compact;
+	bool skip_names;
+	bool emit_zeroes;
+	__u8 indent_lvl;	/* base indent level */
+	char indent_str[BTF_DATA_INDENT_STR_LEN + 1];
+	/* below are used during iteration */
+	struct {
+		__u8 depth;
+		__u8 array_member:1,
+		     array_terminated:1,
+		     array_ischar:1;
+	} state;
+};
+
 struct btf_dump {
 	const struct btf *btf;
 	const struct btf_ext *btf_ext;
@@ -60,6 +84,7 @@ struct btf_dump {
 	struct btf_dump_opts opts;
 	int ptr_sz;
 	bool strip_mods;
+	bool skip_anon_defs;
 	int last_id;
 
 	/* per-type auxiliary state */
@@ -89,6 +114,10 @@ struct btf_dump {
 	 * name occurrences
 	 */
 	struct hashmap *ident_names;
+	/*
+	 * data for typed display; allocated if needed.
+	 */
+	struct btf_dump_data *typed_dump;
 };
 
 static size_t str_hash_fn(const void *key, void *ctx)
@@ -765,11 +794,11 @@ static void btf_dump_emit_type(struct btf_dump *d, __u32 id, __u32 cont_id)
 		break;
 	case BTF_KIND_FUNC_PROTO: {
 		const struct btf_param *p = btf_params(t);
-		__u16 vlen = btf_vlen(t);
+		__u16 n = btf_vlen(t);
 		int i;
 
 		btf_dump_emit_type(d, t->type, cont_id);
-		for (i = 0; i < vlen; i++, p++)
+		for (i = 0; i < n; i++, p++)
 			btf_dump_emit_type(d, p->type, cont_id);
 
 		break;
@@ -852,8 +881,9 @@ static void btf_dump_emit_bit_padding(const struct btf_dump *d,
 static void btf_dump_emit_struct_fwd(struct btf_dump *d, __u32 id,
 				     const struct btf_type *t)
 {
-	btf_dump_printf(d, "%s %s",
+	btf_dump_printf(d, "%s%s%s",
 			btf_is_struct(t) ? "struct" : "union",
+			t->name_off ? " " : "",
 			btf_dump_type_name(d, id));
 }
 
@@ -1259,7 +1289,7 @@ static void btf_dump_emit_type_chain(struct btf_dump *d,
 		case BTF_KIND_UNION:
 			btf_dump_emit_mods(d, decls);
 			/* inline anonymous struct/union */
-			if (t->name_off == 0)
+			if (t->name_off == 0 && !d->skip_anon_defs)
 				btf_dump_emit_struct_def(d, id, t, lvl);
 			else
 				btf_dump_emit_struct_fwd(d, id, t);
@@ -1267,7 +1297,7 @@ static void btf_dump_emit_type_chain(struct btf_dump *d,
 		case BTF_KIND_ENUM:
 			btf_dump_emit_mods(d, decls);
 			/* inline anonymous enum */
-			if (t->name_off == 0)
+			if (t->name_off == 0 && !d->skip_anon_defs)
 				btf_dump_emit_enum_def(d, id, t, lvl);
 			else
 				btf_dump_emit_enum_fwd(d, id, t);
@@ -1392,6 +1422,39 @@ static void btf_dump_emit_type_chain(struct btf_dump *d,
 	btf_dump_emit_name(d, fname, last_was_ptr);
 }
 
+/* show type name as (type_name) */
+static void btf_dump_emit_type_cast(struct btf_dump *d, __u32 id,
+				    bool top_level)
+{
+	const struct btf_type *t;
+
+	/* for array members, we don't bother emitting type name for each
+	 * member to avoid the redundancy of
+	 * .name = (char[4])[(char)'f',(char)'o',(char)'o',]
+	 */
+	if (d->typed_dump->state.array_member)
+		return;
+
+	/* avoid type name specification for variable/section; it will be done
+	 * for the associated variable value(s).
+	 */
+	t = btf__type_by_id(d->btf, id);
+	if (btf_is_var(t) || btf_is_datasec(t))
+		return;
+
+	if (top_level)
+		btf_dump_printf(d, "(");
+
+	d->skip_anon_defs = true;
+	d->strip_mods = true;
+	btf_dump_emit_type_decl(d, id, "", 0);
+	d->strip_mods = false;
+	d->skip_anon_defs = false;
+
+	if (top_level)
+		btf_dump_printf(d, ")");
+}
+
 /* return number of duplicates (occurrences) of a given name */
 static size_t btf_dump_name_dups(struct btf_dump *d, struct hashmap *name_map,
 				 const char *orig_name)
@@ -1442,3 +1505,763 @@ static const char *btf_dump_ident_name(struct btf_dump *d, __u32 id)
 {
 	return btf_dump_resolve_name(d, id, d->ident_names);
 }
+
+static int btf_dump_dump_type_data(struct btf_dump *d,
+				   const char *fname,
+				   const struct btf_type *t,
+				   __u32 id,
+				   const void *data,
+				   __u8 bits_offset,
+				   __u8 bit_sz);
+
+static const char *btf_dump_data_newline(struct btf_dump *d)
+{
+	return (d->typed_dump->compact || d->typed_dump->state.depth == 0) ?
+	       "" : "\n";
+}
+
+static const char *btf_dump_data_delim(struct btf_dump *d)
+{
+	return d->typed_dump->state.depth == 0 ? "" : ",";
+}
+
+static void btf_dump_data_pfx(struct btf_dump *d)
+{
+	int i, lvl = d->typed_dump->indent_lvl + d->typed_dump->state.depth;
+
+	if (d->typed_dump->compact)
+		return;
+
+	for (i = 0; i < lvl; i++)
+		btf_dump_printf(d, "%s", d->typed_dump->indent_str);
+}
+
+/* A macro is used here as btf_type_value[s]() appends format specifiers
+ * to the format specifier passed in; these do the work of appending
+ * delimiters etc while the caller simply has to specify the type values
+ * in the format specifier + value(s).
+ */
+#define btf_dump_type_values(d, fmt, ...)				\
+	btf_dump_printf(d, fmt "%s%s",					\
+			__VA_ARGS__,					\
+			btf_dump_data_delim(d),				\
+			btf_dump_data_newline(d))
+
+static int btf_dump_unsupported_data(struct btf_dump *d,
+				     const struct btf_type *t,
+				     __u32 id)
+{
+	btf_dump_printf(d, "<unsupported kind:%u>", btf_kind(t));
+	return -ENOTSUP;
+}
+
+static void btf_dump_int128(struct btf_dump *d,
+			    const struct btf_type *t,
+			    const void *data)
+{
+	__int128 num = *(__int128 *)data;
+
+	if ((num >> 64) == 0)
+		btf_dump_type_values(d, "0x%llx", (long long)num);
+	else
+		btf_dump_type_values(d, "0x%llx%016llx", (long long)num >> 32,
+				     (long long)num);
+}
+
+static unsigned __int128 btf_dump_bitfield_get_data(struct btf_dump *d,
+						    const void *data,
+						    __u8 bits_offset,
+						    __u8 bit_sz)
+{
+	__u16 left_shift_bits, right_shift_bits;
+	__u8 nr_copy_bits, nr_copy_bytes, i;
+	unsigned __int128 num = 0, ret;
+	const __u8 *bytes = data;
+
+	/* Bitfield value retrieval is done in two steps; first relevant bytes are
+	 * stored in num, then we left/right shift num to eliminate irrelevant bits.
+	 */
+	nr_copy_bits = bit_sz + bits_offset;
+	nr_copy_bytes = roundup(nr_copy_bits, 8) / 8;
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+	for (i = 0; i < nr_copy_bytes; i++)
+		num += bytes[i] << (8 * i);
+#elif __BYTE_ORDER == __BIG_ENDIAN
+	for (i = nr_copy_bytes - 1; i >= 0; i--)
+		num += bytes[i] << (8 * i);
+#else
+# error "Unrecognized __BYTE_ORDER__"
+#endif
+	left_shift_bits = 128 - nr_copy_bits;
+	right_shift_bits = 128 - bit_sz;
+
+	ret = (num << left_shift_bits) >> right_shift_bits;
+
+	return ret;
+}
+
+static int btf_dump_bitfield_data(struct btf_dump *d,
+				  const struct btf_type *t,
+				  const void *data,
+				  __u8 bits_offset,
+				  __u8 bit_sz)
+{
+	unsigned __int128 print_num;
+
+	print_num = btf_dump_bitfield_get_data(d, data, bits_offset, bit_sz);
+	btf_dump_int128(d, t, &print_num);
+
+	return 0;
+}
+
+static int btf_dump_int_bits(struct btf_dump *d,
+			     const struct btf_type *t,
+			     const void *data,
+			     __u8 bits_offset,
+			     __u8 bit_sz)
+{
+	data += bits_offset / 8;
+	return btf_dump_bitfield_data(d, t, data, bits_offset, bit_sz);
+}
+
+static int btf_dump_int_bits_check_zero(struct btf_dump *d,
+					const struct btf_type *t,
+					const void *data,
+					__u8 bits_offset,
+					__u8 bit_sz)
+{
+	__int128 print_num;
+
+	data += bits_offset / 8;
+	print_num = btf_dump_bitfield_get_data(d, data, bits_offset, bit_sz);
+	if (print_num == 0)
+		return -ENODATA;
+	return 0;
+}
+
+static int btf_dump_int_check_zero(struct btf_dump *d,
+				const struct btf_type *t,
+				const void *data,
+				__u8 bits_offset)
+{
+	__u8 nr_bits = btf_int_bits(t);
+	bool zero = false;
+
+	if (bits_offset)
+		return btf_dump_int_bits_check_zero(d, t, data, bits_offset, 0);
+
+	switch (nr_bits) {
+	case 128:
+		zero = *(__int128 *)data == 0;
+		break;
+	case 64:
+		zero = *(__s64 *)data == 0;
+		break;
+	case 32:
+		zero = *(__s32 *)data == 0;
+		break;
+	case 16:
+		zero = *(__s16 *)data == 0;
+		break;
+	case 8:
+		zero = *(__s8 *)data == 0;
+		break;
+	default:
+		pr_warn("unexpected nr_bits %d for int\n", nr_bits);
+		return -EINVAL;
+	}
+	if (zero)
+		return -ENODATA;
+	return 0;
+}
+
+static int btf_dump_int_data(struct btf_dump *d,
+			     const struct btf_type *t,
+			     __u32 type_id,
+			     const void *data,
+			     __u8 bits_offset)
+{
+	__u8 encoding = btf_int_encoding(t);
+	bool sign = encoding & BTF_INT_SIGNED;
+	__u8 nr_bits = btf_int_bits(t);
+
+	if (bits_offset)
+		return btf_dump_int_bits(d, t, data, bits_offset, 0);
+
+	switch (nr_bits) {
+	case 128:
+		btf_dump_int128(d, t, data);
+		break;
+	case 64:
+		if (sign)
+			btf_dump_type_values(d, "%lld", *(long long *)data);
+		else
+			btf_dump_type_values(d, "%llu", *(unsigned long long *)data);
+		break;
+	case 32:
+		if (sign)
+			btf_dump_type_values(d, "%d", *(__s32 *)data);
+		else
+			btf_dump_type_values(d, "%u", *(__u32 *)data);
+		break;
+	case 16:
+		if (sign)
+			btf_dump_type_values(d, "%d", *(__s16 *)data);
+		else
+			btf_dump_type_values(d, "%u", *(__u16 *)data);
+		break;
+	case 8:
+		if (d->typed_dump->state.array_ischar) {
+			/* check for null terminator */
+			if (d->typed_dump->state.array_terminated)
+				break;
+			if (*(char *)data == '\0') {
+				d->typed_dump->state.array_terminated = 1;
+				break;
+			}
+			if (isprint(*(char *)data)) {
+				btf_dump_type_values(d, "'%c'", *(char *)data);
+				break;
+			}
+		}
+		if (sign)
+			btf_dump_type_values(d, "%d", *(__s8 *)data);
+		else
+			btf_dump_type_values(d, "%u", *(__u8 *)data);
+		break;
+	default:
+		pr_warn("unexpected nr_bits %d for id [%u]\n", nr_bits, type_id);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int btf_dump_float_check_zero(struct btf_dump *d,
+				     const struct btf_type *t,
+				     const void *data)
+{
+	static __u8 bytecmp[16] = {};
+	int nr_bytes = t->size;
+
+	if (nr_bytes > 16 || nr_bytes < 2) {
+		pr_warn("unexpected size %d for float\n", nr_bytes);
+		return -EINVAL;
+	}
+	if (memcmp(data,  bytecmp, nr_bytes) == 0)
+		return -ENOMSG;
+
+	return 0;
+}
+
+static int btf_dump_float_data(struct btf_dump *d,
+			       const struct btf_type *t,
+			       __u32 type_id,
+			       const void *data,
+			       __u8 bits_offset)
+{
+	int nr_bytes = t->size;
+
+	switch (nr_bytes) {
+	case 16:
+		btf_dump_type_values(d, "%Lf", *(long double *)data);
+		break;
+	case 8:
+		btf_dump_type_values(d, "%f", *(double *)data);
+		break;
+	case 4:
+		btf_dump_type_values(d, "%f", *(float *)data);
+		break;
+	default:
+		pr_warn("unexpected size %d for id [%u]\n", nr_bytes, type_id);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int btf_dump_var_data(struct btf_dump *d,
+			     const struct btf_type *v,
+			     __u32 id,
+			     const void *data)
+{
+	enum btf_func_linkage linkage = btf_var(v)->linkage;
+	const struct btf_type *t;
+	const char *l;
+	__u32 type_id;
+
+	switch (linkage) {
+	case BTF_FUNC_STATIC:
+		l = "static ";
+		break;
+	case BTF_FUNC_EXTERN:
+		l = "extern ";
+		break;
+	case BTF_FUNC_GLOBAL:
+	default:
+		l = "";
+		break;
+	}
+
+	/* format of output here is [linkage] [type] [varname] = (type)value,
+	 * for example "static int cpu_profile_flip = (int)1"
+	 */
+	btf_dump_printf(d, "%s", l);
+	type_id = v->type;
+	t = btf__type_by_id(d->btf, type_id);
+	btf_dump_emit_type_cast(d, type_id, false);
+	btf_dump_printf(d, " %s = ", btf_name_of(d, v->name_off));
+	return btf_dump_dump_type_data(d, NULL, t, type_id, data, 0, 0);
+}
+
+static int btf_dump_array_data(struct btf_dump *d,
+			       const struct btf_type *t,
+			       __u32 id,
+			       const void *data)
+{
+	const struct btf_array *array = btf_array(t);
+	const struct btf_type *elem_type;
+	__u32 i, elem_size = 0, elem_type_id;
+	int array_member;
+
+	elem_type_id = array->type;
+	elem_type = skip_mods_and_typedefs(d->btf, elem_type_id, NULL);
+	elem_size = btf__resolve_size(d->btf, elem_type_id);
+	if (elem_size <= 0) {
+		pr_warn("unexpected elem size %d for array type [%u]\n", elem_size, id);
+		return -EINVAL;
+	}
+
+	if (btf_is_int(elem_type)) {
+		/*
+		 * BTF_INT_CHAR encoding never seems to be set for
+		 * char arrays, so if size is 1 and element is
+		 * printable as a char, we'll do that.
+		 */
+		if (elem_size == 1)
+			d->typed_dump->state.array_ischar = true;
+	}
+
+	d->typed_dump->state.depth++;
+	btf_dump_printf(d, "[%s", btf_dump_data_newline(d));
+
+	/* may be a multidimensional array, so store current "is array member"
+	 * status so we can restore it correctly later.
+	 */
+	array_member = d->typed_dump->state.array_member;
+	d->typed_dump->state.array_member = 1;
+	for (i = 0;
+	     i < array->nelems && !d->typed_dump->state.array_terminated;
+	     i++) {
+		btf_dump_dump_type_data(d, NULL, elem_type, elem_type_id, data, 0, 0);
+		data += elem_size;
+	}
+	d->typed_dump->state.array_member = array_member;
+	d->typed_dump->state.depth--;
+	btf_dump_data_pfx(d);
+	btf_dump_printf(d, "]%s%s", btf_dump_data_delim(d), btf_dump_data_newline(d));
+
+	return 0;
+}
+
+static int btf_dump_struct_data(struct btf_dump *d,
+				const struct btf_type *t,
+				__u32 id,
+				const void *data)
+{
+	const struct btf_member *m = btf_members(t);
+	__u16 n = btf_vlen(t);
+	int i, err;
+
+	d->typed_dump->state.depth++;
+	btf_dump_printf(d, "{%s", btf_dump_data_newline(d));
+
+	for (i = 0; i < n; i++, m++) {
+		const struct btf_type *mtype;
+		const char *mname;
+		__u32 moffset;
+		__u8 bit_sz;
+
+		mtype = btf__type_by_id(d->btf, m->type);
+		mname = btf_name_of(d, m->name_off);
+		moffset = btf_member_bit_offset(t, i);
+
+		bit_sz = btf_member_bitfield_size(t, i);
+		err = btf_dump_dump_type_data(d, mname, mtype, m->type, data + moffset / 8,
+					      moffset % 8, bit_sz);
+		if (err < 0)
+			return err;
+	}
+	d->typed_dump->state.depth--;
+	btf_dump_data_pfx(d);
+	btf_dump_printf(d, "}%s%s", btf_dump_data_delim(d), btf_dump_data_newline(d));
+	return err;
+}
+
+static int btf_dump_ptr_data(struct btf_dump *d,
+			      const struct btf_type *t,
+			      __u32 id,
+			      const void *data)
+{
+	btf_dump_type_values(d, "%p", *(void **)data);
+	return 0;
+}
+
+static int btf_dump_get_enum_value(const struct btf_type *t,
+				   const void *data,
+				   __u32 id,
+				   __s64 *value)
+{
+	switch (t->size) {
+	case 8:
+		*value = *(__s64 *)data;
+		return 0;
+	case 4:
+		*value = *(__s32 *)data;
+		return 0;
+	case 2:
+		*value = *(__s16 *)data;
+		return 0;
+	case 1:
+		*value = *(__s8 *)data;
+	default:
+		pr_warn("unexpected size %d for enum, id:[%u]\n", t->size, id);
+		return -EINVAL;
+	}
+}
+
+static int btf_dump_enum_data(struct btf_dump *d,
+			      const struct btf_type *t,
+			      __u32 id,
+			      const void *data)
+{
+	const struct btf_enum *e;
+	__s64 value;
+	int i, err;
+
+	err = btf_dump_get_enum_value(t, data, id, &value);
+	if (err)
+		return err;
+
+	for (i = 0, e = btf_enum(t); i < btf_vlen(t); i++, e++) {
+		if (value != e->val)
+			continue;
+		btf_dump_type_values(d, "%s", btf_name_of(d, e->name_off));
+		return 0;
+	}
+
+	btf_dump_type_values(d, "%d", value);
+	return 0;
+}
+
+static int btf_dump_datasec_data(struct btf_dump *d,
+				 const struct btf_type *t,
+				 __u32 id,
+				 const void *data)
+{
+	const struct btf_var_secinfo *vsi;
+	const struct btf_type *var;
+	__u32 i;
+	int err;
+
+	btf_dump_type_values(d, "SEC(\"%s\") ",
+			     btf_name_of(d, t->name_off));
+	for (i = 0, vsi = btf_var_secinfos(t); i < btf_vlen(t); i++, vsi++) {
+		var = btf__type_by_id(d->btf, vsi->type);
+		err = btf_dump_dump_type_data(d, NULL, var, vsi->type, data + vsi->offset, 0, 0);
+		if (err < 0)
+			return err;
+		btf_dump_printf(d, ";");
+	}
+	return 0;
+}
+
+/* return size of type, or if base type overflows, return -E2BIG. */
+static int btf_dump_type_data_check_overflow(struct btf_dump *d,
+					     const struct btf_type *t,
+					     __u32 id,
+					     const void *data,
+					     __u8 bits_offset)
+{
+	__s64 size = btf__resolve_size(d->btf, id);
+
+	if (size < 0 || size >= INT_MAX) {
+		pr_warn("unexpected size [%lld] for id [%u]\n",
+			size, id);
+		return -EINVAL;
+	}
+
+	/* Only do overflow checking for base types; we do not want to
+	 * avoid showing part of a struct, union or array, even if we
+	 * do not have enough data to show the full object.  By
+	 * restricting overflow checking to base types we can ensure
+	 * that partial display succeeds, while avoiding overflowing
+	 * and using bogus data for display.
+	 */
+	t = skip_mods_and_typedefs(d->btf, id, NULL);
+	if (!t) {
+		pr_warn("unexpected error skipping mods/typedefs for id [%u]\n",
+			id);
+		return -EINVAL;
+	}
+
+	switch (BTF_INFO_KIND(t->info)) {
+	case BTF_KIND_INT:
+	case BTF_KIND_PTR:
+	case BTF_KIND_ENUM:
+		if (data + bits_offset / 8 + size > d->typed_dump->data_end)
+			return -E2BIG;
+		break;
+	default:
+		break;
+	}
+	return (int)size;
+}
+
+static int btf_dump_type_data_check_zero(struct btf_dump *d,
+					 const struct btf_type *t,
+					 __u32 id,
+					 const void *data,
+					 __u8 bits_offset,
+					 __u8 bit_sz)
+{
+	__s64 value;
+	int i, err;
+
+	/* toplevel exceptions; we show zero values if
+	 * - we ask for them (emit_zeros)
+	 * - if we are at top-level so we see "struct empty { }"
+	 * - or if we are an array member and the array is non-empty and
+	 *   not a char array; we don't want to be in a situation where we
+	 *   have an integer array 0, 1, 0, 1 and only show non-zero values.
+	 *   If the array contains zeroes only, or is a char array starting
+	 *   with a '\0', the array-level check_zero() will prevent showing it;
+	 *   we are concerned with determining zero value at the array member
+	 *   level here.
+	 */
+	if (d->typed_dump->emit_zeroes || d->typed_dump->state.depth == 0 ||
+	    (d->typed_dump->state.array_member &&
+	     !d->typed_dump->state.array_ischar))
+		return 0;
+
+	t = skip_mods_and_typedefs(d->btf, id, NULL);
+	if (!t) {
+		pr_warn("unexpected error skipping mods/typedefs for id [%u]\n",
+			id);
+		return -EINVAL;
+	}
+
+
+	switch (BTF_INFO_KIND(t->info)) {
+	case BTF_KIND_INT:
+		if (bit_sz)
+			return btf_dump_int_bits_check_zero(d, t, data,
+							    bits_offset, bit_sz);
+		return btf_dump_int_check_zero(d, t, data, bits_offset);
+	case BTF_KIND_FLOAT:
+		return btf_dump_float_check_zero(d, t, data);
+	case BTF_KIND_PTR:
+		if (*((void **)data) == NULL)
+			return -ENODATA;
+		return 0;
+	case BTF_KIND_ARRAY: {
+		const struct btf_array *array = btf_array(t);
+		const struct btf_type *elem_type;
+		__u32 elem_type_id, elem_size;
+		bool ischar;
+
+		elem_type_id = array->type;
+		elem_size = btf__resolve_size(d->btf, elem_type_id);
+		elem_type =  btf__type_by_id(d->btf, elem_type_id);
+
+		ischar = btf_is_int(elem_type) && elem_size == 1;
+
+		/* check all elements; if _any_ element is nonzero, all
+		 * of array is displayed.  We make an exception however
+		 * for char arrays where the first element is 0; these
+		 * are considered zeroed also, even if later elements are
+		 * non-zero because the string is terminated.
+		 */
+		for (i = 0; i < array->nelems; i++) {
+			if (i == 0 && ischar && *(char *)data == 0)
+				return -ENODATA;
+			err = btf_dump_type_data_check_zero(d, elem_type,
+							    elem_type_id,
+							    data +
+							    (i * elem_size),
+							    bits_offset, 0);
+			if (err != -ENODATA)
+				return err;
+		}
+		return -ENODATA;
+	}
+	case BTF_KIND_STRUCT:
+	case BTF_KIND_UNION: {
+		const struct btf_member *m = btf_members(t);
+		__u16 n = btf_vlen(t);
+
+		/* if any struct/union member is non-zero, the struct/union
+		 * is considered non-zero and dumped.
+		 */
+		for (i = 0; i < n; i++, m++) {
+			const struct btf_type *mtype;
+			__u32 moffset;
+			__u8 bit_sz;
+
+			mtype = btf__type_by_id(d->btf, m->type);
+			moffset = btf_member_bit_offset(t, i);
+
+			/* btf_int_bits() does not store member bitfield size;
+			 * bitfield size needs to be stored here so int display
+			 * of member can retrieve it.
+			 */
+			bit_sz = btf_member_bitfield_size(t, i);
+			err = btf_dump_type_data_check_zero(d, mtype, m->type, data + moffset / 8,
+							    moffset % 8, bit_sz);
+			if (err != ENODATA)
+				return err;
+		}
+		return -ENODATA;
+	}
+	case BTF_KIND_ENUM:
+		if (btf_dump_get_enum_value(t, data, id, &value))
+			return 0;
+		if (value == 0)
+			return -ENODATA;
+		return 0;
+	default:
+		return 0;
+	}
+}
+
+/* returns size of data dumped, or error. */
+static int btf_dump_dump_type_data(struct btf_dump *d,
+				   const char *fname,
+				   const struct btf_type *t,
+				   __u32 id,
+				   const void *data,
+				   __u8 bits_offset,
+				   __u8 bit_sz)
+{
+	int size, err;
+
+	size = btf_dump_type_data_check_overflow(d, t, id, data, bits_offset);
+	if (size < 0)
+		return size;
+	err = btf_dump_type_data_check_zero(d, t, id, data, bits_offset, bit_sz);
+	if (err) {
+		/* zeroed data is expected and not an error, so simply skip
+		 * dumping such data.  Record other errors however.
+		 */
+		if (err == -ENODATA)
+			return size;
+		return err;
+	}
+	btf_dump_data_pfx(d);
+
+	if (!d->typed_dump->skip_names) {
+		if (fname && strlen(fname) > 0)
+			btf_dump_printf(d, ".%s = ", fname);
+		btf_dump_emit_type_cast(d, id, true);
+	}
+
+	t = skip_mods_and_typedefs(d->btf, id, NULL);
+	if (!t) {
+		pr_warn("unexpected error skipping mods/typedefs for id [%u]\n",
+			id);
+		return -EINVAL;
+	}
+
+	switch (BTF_INFO_KIND(t->info)) {
+	case BTF_KIND_UNKN:
+	case BTF_KIND_FWD:
+	case BTF_KIND_FUNC:
+	case BTF_KIND_FUNC_PROTO:
+		err = btf_dump_unsupported_data(d, t, id);
+		break;
+	case BTF_KIND_INT:
+		if (bit_sz)
+			err = btf_dump_bitfield_data(d, t, data, bits_offset, bit_sz);
+		else
+			err = btf_dump_int_data(d, t, id, data, bits_offset);
+		break;
+	case BTF_KIND_FLOAT:
+		err = btf_dump_float_data(d, t, id, data, bits_offset);
+		break;
+	case BTF_KIND_PTR:
+		err = btf_dump_ptr_data(d, t, id, data);
+		break;
+	case BTF_KIND_ARRAY:
+		err = btf_dump_array_data(d, t, id, data);
+		break;
+	case BTF_KIND_STRUCT:
+	case BTF_KIND_UNION:
+		err = btf_dump_struct_data(d, t, id, data);
+		break;
+	case BTF_KIND_ENUM:
+		/* handle bitfield and int enum values */
+		if (bit_sz) {
+			unsigned __int128 print_num;
+			__s64 enum_val;
+
+			print_num = btf_dump_bitfield_get_data(d, data, bits_offset, bit_sz);
+			enum_val = (__s64)print_num;
+			err = btf_dump_enum_data(d, t, id, &enum_val);
+		} else
+			err = btf_dump_enum_data(d, t, id, data);
+		break;
+	case BTF_KIND_VAR:
+		err = btf_dump_var_data(d, t, id, data);
+		break;
+	case BTF_KIND_DATASEC:
+		err = btf_dump_datasec_data(d, t, id, data);
+		break;
+	default:
+		pr_warn("unexpected kind [%u] for id [%u]\n",
+			BTF_INFO_KIND(t->info), id);
+		return -EINVAL;
+	}
+	if (err < 0)
+		return err;
+	return size;
+}
+
+int btf_dump__dump_type_data(struct btf_dump *d, __u32 id,
+			     const void *data, size_t data_sz,
+			     const struct btf_dump_type_data_opts *opts)
+{
+	const struct btf_type *t;
+	int ret;
+
+	if (!OPTS_VALID(opts, btf_dump_type_data_opts))
+		return libbpf_err(-EINVAL);
+
+	t = btf__type_by_id(d->btf, id);
+	if (!t)
+		return libbpf_err(-ENOENT);
+
+	d->typed_dump = calloc(1, sizeof(struct btf_dump_data));
+	if (!d->typed_dump)
+		return libbpf_err(-ENOMEM);
+
+	d->typed_dump->data_end = data + data_sz;
+	d->typed_dump->indent_lvl = OPTS_GET(opts, indent_level, 0);
+	/* default indent string is a tab */
+	if (!opts->indent_str)
+		d->typed_dump->indent_str[0] = '\t';
+	else {
+		if (strlen(opts->indent_str) >
+		    sizeof(d->typed_dump->indent_str) - 1)
+			return libbpf_err(-EINVAL);
+		strncpy(d->typed_dump->indent_str, opts->indent_str,
+			sizeof(d->typed_dump->indent_str) - 1);
+	}
+
+	d->typed_dump->compact = OPTS_GET(opts, compact, false);
+	d->typed_dump->skip_names = OPTS_GET(opts, skip_names, false);
+	d->typed_dump->emit_zeroes = OPTS_GET(opts, emit_zeroes, false);
+
+	ret = btf_dump_dump_type_data(d, NULL, t, id, data, 0, 0);
+
+	free(d->typed_dump);
+
+	return libbpf_err(ret);
+}
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 944c99d..5bfc107 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -373,5 +373,6 @@ LIBBPF_0.5.0 {
 		bpf_map__initial_value;
 		bpf_map_lookup_and_delete_elem_flags;
 		bpf_object__gen_loader;
+		btf_dump__dump_type_data;
 		libbpf_set_strict_mode;
 } LIBBPF_0.4.0;
-- 
1.8.3.1

