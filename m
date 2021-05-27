Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9AF939330F
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 18:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236962AbhE0QBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 12:01:44 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:6948 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236183AbhE0QBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 12:01:36 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14RFr1nO024092;
        Thu, 27 May 2021 15:59:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=XHddP9FDSJCqiAgCUfos5tfLToi7HKQO9wfr1ojQUVE=;
 b=N6oY1VsUHY37G35KPFAGW4jeMCdWy4rgkBAk9bcJ/MZ9N9Dq/XUTvuByujOo+U4cCMmb
 JIZZ+wF5hSrLxUynoKENNR1xAScbjVojTwn4StNnM7lXOKF0kEy0L3eEITJgSiadIoNu
 9MnxHw3XKof7Xg9KCV69E79Ny6gIgjZgOUxeKXETYoOoS3uHcNyjbtQUQwuN9mfGbVnA
 WwLKOhyBcWga/DYhgbOnTaBxGvMnn/r1x9MhEQNat+1iF1iONy20vAUc+vvyccwT8gLL
 nCU4zXuzzvsM+Ao7gaRXFXRLDbj9Z+Gxo9kdyU3blTgYytVx17zrdzc48+wnQyVNT024 0w== 
Received: from oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 38sn3yrhb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 May 2021 15:59:43 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14RFs4Zd071106;
        Thu, 27 May 2021 15:59:43 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by aserp3030.oracle.com with ESMTP id 38pr0dqaer-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 May 2021 15:59:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hn7c/pw4udpaBGV9qTA1KQIkILCEQbEy+XIbS33jE5DqWP6Z809ggRb/Flu+dMCT4riXqSI7r+km6XMwZYFMtadYdXHn3+WO5H6ko/HMW3/xHKTxCGCbi4u4/wEEwVOLB5XKi72JWjG0J4RpJ/T1ZtD2cEg6o/cS5bYmaHC+nYLdpvUvX4mxGeNj4HqZib5O5izZgaLLVqFrO6VbySA+o8C+hoFOqCuzW1YTGuLeTr+7ZntlJkYt2LPrPW0CunLJ0QpsOA3GUH0pDhMQ7lID6LxBVQz+aRxOOpi4D3t+tBVF1xPLa6FAqtcQSxR7eNHDWsXbuyPQGsyaTcKFgbgb0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XHddP9FDSJCqiAgCUfos5tfLToi7HKQO9wfr1ojQUVE=;
 b=FPpq0TaLyCkxZbu397lCG38iZobc1MXx4DTG1GI/KGGxcl0zHHblorEt4NlQyfceXHOyRxcrF247OTvqY2VpSZOlVUtUtXvUVSJ8NZ+MZobl0Dv047XWDGG9fOylZ5zFkLk/tiGbC1LKahWfRAD9oh2FZS2p+qOZIp1WK4Rs1xa6CFGpY3lPf1ElGGs/QCek/DKv+epODUl7AfJXY3/WLnX6ItC+K/KC309lFW9LZiMHJgLpnxHR+4ks+uW7GikS1rwnaUd1zTf3GfXLuYBsahBOXmwvUK1BteyetFyGKhwrjbV+nZCrQvQo4d6stpY0K31ZAac0ci9gz7j/u2UO5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XHddP9FDSJCqiAgCUfos5tfLToi7HKQO9wfr1ojQUVE=;
 b=yuanmUDPks7/o6nwjH6aZzCEIcI65R4dE17/tMX6Kx8KGywi7kJGd3Flre5ibPpmzqAi5yLcoKLHaY8gQ/Gr8ifoiN9+N5Rh1+NrKlboupUZH27NZl47Z35OmHGOByBnQS3kRw9xp91qz0OJ/GmpRht7Fd+B/kNvoXewvOEv3nI=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by BLAPR10MB5266.namprd10.prod.outlook.com (2603:10b6:208:331::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Thu, 27 May
 2021 15:59:39 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::9da7:f131:1f41:657c]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::9da7:f131:1f41:657c%4]) with mapi id 15.20.4173.020; Thu, 27 May 2021
 15:59:39 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v3 bpf-next 1/2] libbpf: BTF dumper support for typed data
Date:   Thu, 27 May 2021 16:59:29 +0100
Message-Id: <1622131170-8260-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622131170-8260-1-git-send-email-alan.maguire@oracle.com>
References: <1622131170-8260-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-Originating-IP: [95.45.14.174]
X-ClientProxiedBy: LO4P123CA0051.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:152::20) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.uk.oracle.com (95.45.14.174) by LO4P123CA0051.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:152::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Thu, 27 May 2021 15:59:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1eca992e-deba-4294-fc00-08d921286ef9
X-MS-TrafficTypeDiagnostic: BLAPR10MB5266:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BLAPR10MB526649E97A015C2285B97AC8EF239@BLAPR10MB5266.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gyaGFPijPGNFE0KJgnHo2d5/ytRs7XwCs+bG1Kzn1p8X8K2AQwnM3a52njzomKM7Mp393SpTXGlwdsjp3z3TvdNsNIK5flsFmMA7RwJYVD1oq3r579UrjgKLW+Rmf95kI5NWsz1aNK2IAlb2blCoHfJ4uhSuGkbfH4ayPL5ePR9uEQQSyJwX14OECoj7NrLzyaH3Yy5nwCx8q8VV4sKZeOnIhoalT+1egzdgI3+d3YIT6AJpSrG1VuJUTSnwgbKzcPj7lkkdTwVOg6XtHbTu/HXtE5jqFcF50gMsYIgAbEcikD9YF2BKPXIHzwbTsUN9L1WLgquFHtbhS2SgSqRpdkv/HO0hARH2NhwXIIibR4cFkOSmgB5YxFyuyn9oC3LQKyCOAuFJD9+bTg48v0hKNAWxLhEK4pWqIKkvTHwZhncgk/4mScvCnZCppeHpRVGFGDVINw7TtVJ3p0t2tZngmFgRySXXDWkzpo9Dh9M5yG1BBBI58xUUYRKW0t6+VFGurxbgQ5n2rk3qPibFBodE0N/RfWxG/d0qpjO47Ny2IJYQ7Y0RNdYgB896xFh55fJ/3uu8CBXA6viIma0o9gOh5+RfDwBBz6WvOs9WgbdzXNv+l6IHu/GnXcDRFpvQA+loiXFdUmI+az7gK+vwXTSRgAf4lnMt17FB12Zo3eZbW58=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(136003)(39860400002)(396003)(478600001)(66476007)(66946007)(30864003)(86362001)(5660300002)(6666004)(66556008)(83380400001)(38350700002)(7416002)(2906002)(8936002)(8676002)(38100700002)(36756003)(16526019)(107886003)(4326008)(186003)(6486002)(956004)(2616005)(52116002)(7696005)(44832011)(26005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?R+/Cc6KmX8vZguO2QFUp9PRFE+jWio0bkLLNLFBNvjVFcovx/ZIH25MN+vYQ?=
 =?us-ascii?Q?sBrvKW7BwSROOaGxFJWDLiTfi1VCfGbjWiD0+s1se8b7plUlY8jR607OYB1D?=
 =?us-ascii?Q?dQQckbMqPgao9z+WtbdyeiX8C2MMRxlwMFXFbNoVIx1DAmX98haXFTUxdRJ3?=
 =?us-ascii?Q?zvKa1cICqL6Bv8jqI2R4RRT97W7U3j2YnileGwoaoApM854POXIbYcDUp54y?=
 =?us-ascii?Q?EnXx2p9s7Re9isC3Ot2/6JwH+cscjX38Qyz5nWPxoiHhBHFkEsm+xtRbFmHm?=
 =?us-ascii?Q?9Bj0kf69uHMKxlhpZEeoVACOOHLvZkWQiDBZpHWKNsBZwwqmu1xUOQNXBS4s?=
 =?us-ascii?Q?vn/96+XF64jBCdaI6W05NnmK8qQIezD4jeKo0iwKMCDyDTYLmTAmfAba+s5d?=
 =?us-ascii?Q?K7hWdpdTAIvYP0DRigtM9sbK6KG5rn3xIJNkM8hd56bGAN2z/WoWYhT1Jt7X?=
 =?us-ascii?Q?UM7WSmgnpHIxaWna1qDb2NBBdmt8mCOjyzMaex2uTve+ZwfUJsL3sOQ3tpYo?=
 =?us-ascii?Q?2tXpz/jVphWkcCemIqLbWAFQkrAoljWxomA4H3i/fXu8Zb0LqNa9Yd0PGeDG?=
 =?us-ascii?Q?cl8Ft60PJvHW1LsEYg077D7l4jwVK+9UTAbe3HmbKqFo/NZPhN/SMvu6Mimx?=
 =?us-ascii?Q?OkoPOrmaiETh7WL4PDuMQYVZg0xAFyTLMW5t0GClOkcaY3zDRNkittO1SQxq?=
 =?us-ascii?Q?3M6FhOM3iQ92rNxgWG3i8Te2FMEcNCLLJThiHlQAbkw0kZzqN4yy2m2AtPrz?=
 =?us-ascii?Q?Gk6hX154Ej8sC6W4VkvZZtb6NDXzHCPFPU182GFdZ+r7SrPrH8gYpxiEYSnm?=
 =?us-ascii?Q?affD9c7RcQ+iDb4PnVtp9j43zo8qEbtyCiGdJYmF23xltUeDOJ74/IVD4gNZ?=
 =?us-ascii?Q?dZ5c48KLogr02/WJ8BDxow0nBcyrRYtxrLJRBCd2geTBv2h62nBDNWnBXrNg?=
 =?us-ascii?Q?qe8uvTgFg5RzyShFevRVTv8EjRNYdOPHXA+cT0cm3A9l3rzMhka3f3X/cZa+?=
 =?us-ascii?Q?NuheFYaQc2/0G2HV+fmkRQemqq3RfEdiCSY971R1fE/5jB9fAVT+2gSzc0IS?=
 =?us-ascii?Q?uxiKKv2UIC6k5yYTA78lOjrkNIzd084ofynBmA8TX2vzG+Jt1Li+oDqW80qS?=
 =?us-ascii?Q?WAbvjenE26ZnX/i9vz433urOhYEozfwCH9K8vgUsPYNqEIVQIoG8VqGLrjgO?=
 =?us-ascii?Q?5EkWo3/prBFZCJMUu9kh6gfpcyMUd+u7kIPkZjbURv7L/78HmFafaSe4RbnA?=
 =?us-ascii?Q?yUxFPIWf9qa3eStrDMjMAai82VP4CmfGsAN82GF4CzsXum22TKCiBR6AVHmO?=
 =?us-ascii?Q?V++8iYCWykUEXQFjCG6VYX4t?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eca992e-deba-4294-fc00-08d921286ef9
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 15:59:39.6449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J4J4QfyrbiNfPS1aAVZhb9I4RVlE7iAYBHw0cSJGYRdEgDLK4eCm/YpvFwIsh51xh1h2HaGFWIk99kGDWEw5bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5266
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9997 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105270102
X-Proofpoint-GUID: 66IE_SAlaSqNuGShKRUICTpPg6BlDUHW
X-Proofpoint-ORIG-GUID: 66IE_SAlaSqNuGShKRUICTpPg6BlDUHW
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a BTF dumper for typed data, so that the user can dump a typed
version of the data provided.

The API is

int btf_dump__dump_type_data(struct btf_dump *d, __u32 id,
                             void *data, size_t byte_sz,
                             const struct btf_dump_type_data_opts *opts);

...where the id is the BTF id of the data pointed to by the "void *"
argument; for example the BTF id of "struct sk_buff" for a
"struct skb *" data pointer.  Options supported are

 - a starting indent level (indent_lvl)
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

If the data structure is larger than the *byte_sz*
number of bytes that are available in *data*, as much
of the data as possible will be dumped and -E2BIG will
be returned.  This is useful as tracers will sometimes
not be able to capture all of the data associated with
a type; for example a "struct task_struct" is ~16k.
Being able to specify that only a subset is available is
important for such cases.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/btf.h      |  17 +
 tools/lib/bpf/btf_dump.c | 901 +++++++++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.map |   5 +
 3 files changed, 923 insertions(+)

diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index b54f1c3..234aa97 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -184,6 +184,23 @@ struct btf_dump_emit_type_decl_opts {
 btf_dump__emit_type_decl(struct btf_dump *d, __u32 id,
 			 const struct btf_dump_emit_type_decl_opts *opts);
 
+
+struct btf_dump_type_data_opts {
+	/* size of this struct, for forward/backward compatibility */
+	size_t sz;
+	int indent_level;
+	/* below match "show" flags for bpf_show_snprintf() */
+	bool compact;		/* no newlines/tabs */
+	bool skip_names;	/* skip member/type names */
+	bool emit_zeroes;	/* show 0-valued fields */
+};
+#define btf_dump_type_data_opts__last_field emit_zeroes
+
+LIBBPF_API int
+btf_dump__dump_type_data(struct btf_dump *d, __u32 id,
+			 void *data, size_t byte_sz,
+			 const struct btf_dump_type_data_opts *opts);
+
 /*
  * A set of helpers for easier BTF types handling
  */
diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 5e2809d..27baa6a 100644
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
@@ -19,6 +21,13 @@
 #include "libbpf.h"
 #include "libbpf_internal.h"
 
+#define BITS_PER_BYTE			8
+#define BITS_PER_U128			128
+#define BITS_PER_BYTE_MASK		(BITS_PER_BYTE - 1)
+#define BITS_PER_BYTE_MASKED(bits)	((bits) & BITS_PER_BYTE_MASK)
+#define BITS_ROUNDDOWN_BYTES(bits)	((bits) / 8)
+#define BITS_ROUNDUP_BYTES(bits)	(roundup(bits, 8))
+
 static const char PREFIXES[] = "\t\t\t\t\t\t\t\t\t\t\t\t\t";
 static const size_t PREFIX_CNT = sizeof(PREFIXES) - 1;
 
@@ -53,6 +62,25 @@ struct btf_dump_type_aux_state {
 	__u8 referenced: 1;
 };
 
+/*
+ * Common internal data for BTF type data dump operations.
+ */
+struct btf_dump_data {
+	void *data_end;		/* end of valid data to show */
+	bool compact;
+	bool skip_names;
+	bool emit_zeroes;
+	__u8 indent_lvl;	/* base indent level */
+	/* below are used during iteration */
+	struct {
+		__u8 depth;
+		__u8 array_member:1,
+		     array_terminated:1,
+		     array_ischar:1;
+		__u32 bitfield_size;
+	} state;
+};
+
 struct btf_dump {
 	const struct btf *btf;
 	const struct btf_ext *btf_ext;
@@ -89,6 +117,10 @@ struct btf_dump {
 	 * name occurrences
 	 */
 	struct hashmap *ident_names;
+	/*
+	 * data for typed display.
+	 */
+	struct btf_dump_data data;
 };
 
 static size_t str_hash_fn(const void *key, void *ctx)
@@ -1392,6 +1424,91 @@ static void btf_dump_emit_type_chain(struct btf_dump *d,
 	btf_dump_emit_name(d, fname, last_was_ptr);
 }
 
+/* show type name as [.fname =] (type_name) */
+static void btf_dump_emit_type_name(struct btf_dump *d, __u32 id,
+				    const char *fname, int lvl, bool toplevel)
+{
+
+	const struct btf_type *t, *child;
+	const char *name;
+	__u16 kind;
+
+	/* for array members, we don't bother emitting type name for each
+	 * member to avoid the redundancy of
+	 * .name = (char[])[(char)'f',(char)'o',(char)'o',]
+	 */
+	if (d->data.state.array_member)
+		return;
+
+	t = btf__type_by_id(d->btf, id);
+	kind = btf_kind(t);
+
+	/* avoid type name specification for variable/section; it will be done
+	 * for the associated variable value(s).  Also skip for function
+	 * prototypes.
+	 */
+	switch (kind) {
+	case BTF_KIND_VAR:
+	case BTF_KIND_DATASEC:
+	case BTF_KIND_FUNC_PROTO:
+		return;
+	default:
+		break;
+	}
+
+	if (toplevel) {
+		if (fname && strlen(fname) > 0)
+			btf_dump_printf(d, ".%s = ", fname);
+		btf_dump_printf(d, "(");
+	}
+
+	switch (kind) {
+	case BTF_KIND_INT:
+		name = btf_name_of(d, t->name_off);
+		btf_dump_printf(d, "%s", name);
+		break;
+	case BTF_KIND_STRUCT:
+	case BTF_KIND_UNION:
+		name = btf_dump_type_name(d, id);
+		btf_dump_printf(d, "%s%s%s",
+				btf_is_struct(t) ? "struct" : "union",
+				strlen(name) > 0 ? " " : "",
+				name);
+		break;
+	case BTF_KIND_ENUM:
+		btf_dump_emit_enum_fwd(d, id, t);
+		break;
+	case BTF_KIND_TYPEDEF:
+		btf_dump_printf(d, "%s", btf_dump_ident_name(d, id));
+		break;
+	case BTF_KIND_VOLATILE:
+	case BTF_KIND_CONST:
+	case BTF_KIND_RESTRICT:
+		/* modifiers are omitted from the cast to save space */
+		btf_dump_emit_type_name(d, t->type, NULL, lvl, false);
+		break;
+	case BTF_KIND_PTR:
+		btf_dump_emit_type_name(d, t->type, NULL, lvl, false);
+		child = btf__type_by_id(d->btf, t->type);
+		btf_dump_printf(d,
+				btf_kind(child) == BTF_KIND_PTR ? "*" : " *");
+		break;
+	case BTF_KIND_ARRAY: {
+		const struct btf_array *a = btf_array(t);
+
+		btf_dump_emit_type_name(d, a->type, NULL, lvl, false);
+		btf_dump_printf(d, "[]");
+		break;
+	}
+	default:
+		pr_warn("unexpected type when emitting type name, kind %u, id:[%u]\n",
+			kind, id);
+		break;
+	}
+	if (toplevel)
+		btf_dump_printf(d, ")");
+}
+
 /* return number of duplicates (occurrences) of a given name */
 static size_t btf_dump_name_dups(struct btf_dump *d, struct hashmap *name_map,
 				 const char *orig_name)
@@ -1442,3 +1559,787 @@ static const char *btf_dump_ident_name(struct btf_dump *d, __u32 id)
 {
 	return btf_dump_resolve_name(d, id, d->ident_names);
 }
+
+static int btf_dump_dump_type_data(struct btf_dump *d,
+				   const char *fname,
+				   const struct btf_type *t,
+				   __u32 id,
+				   void *data,
+				   __u8 bits_offset);
+
+static const char *btf_dump_data_newline(struct btf_dump *d)
+{
+	return d->data.compact ? "" : "\n";
+}
+
+static const char *btf_dump_data_delim(struct btf_dump *d)
+{
+	if (d->data.state.depth == 0)
+		return "";
+
+	return ",";
+}
+
+static const char *btf_dump_data_pfx(struct btf_dump *d)
+{
+	int lvl = d->data.indent_lvl + d->data.state.depth;
+
+	if (d->data.compact)
+		lvl = 0;
+	return pfx(lvl);
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
+static int btf_dump_df_data(struct btf_dump *d,
+			    const struct btf_type *t,
+			    __u32 id,
+			    void *data)
+{
+	btf_dump_printf(d, "<unsupported kind:%u>",
+			BTF_INFO_KIND(t->info));
+	return -ENOTSUP;
+}
+
+static void btf_dump_int128(struct btf_dump *d,
+			    const struct btf_type *t,
+			    void *data)
+{
+	/* data points to a __int128 number.
+	 * Suppose
+	 *	int128_num = *(__int128 *)data;
+	 * The below formulas shows what upper_num and lower_num represents:
+	 *     upper_num = int128_num >> 64;
+	 *     lower_num = int128_num & 0xffffffffFFFFFFFFULL;
+	 */
+	__u64 upper_num, lower_num;
+
+#ifdef __BIG_ENDIAN_BITFIELD
+	upper_num = *(__u64 *)data;
+	lower_num = *(__u64 *)(data + 8);
+#else
+	upper_num = *(__u64 *)(data + 8);
+	lower_num = *(__u64 *)data;
+#endif
+	if (upper_num == 0)
+		btf_dump_type_values(d, "0x%llx", (long long)lower_num);
+	else
+		btf_dump_type_values(d, "0x%llx%016llx", (long long)upper_num,
+				     (long long)lower_num);
+}
+
+static void btf_int128_shift(__u64 *print_num, __u16 left_shift_bits,
+			     __u16 right_shift_bits)
+{
+	__u64 upper_num, lower_num;
+
+#ifdef __BIG_ENDIAN_BITFIELD
+	upper_num = print_num[0];
+	lower_num = print_num[1];
+#else
+	upper_num = print_num[1];
+	lower_num = print_num[0];
+#endif
+
+	/* shake out un-needed bits by shift/or operations */
+	if (left_shift_bits >= 64) {
+		upper_num = lower_num << (left_shift_bits - 64);
+		lower_num = 0;
+	} else {
+		upper_num = (upper_num << left_shift_bits) |
+			    (lower_num >> (64 - left_shift_bits));
+		lower_num = lower_num << left_shift_bits;
+	}
+
+	if (right_shift_bits >= 64) {
+		lower_num = upper_num >> (right_shift_bits - 64);
+		upper_num = 0;
+	} else {
+		lower_num = (lower_num >> right_shift_bits) |
+			    (upper_num << (64 - right_shift_bits));
+		upper_num = upper_num >> right_shift_bits;
+	}
+
+#ifdef __BIG_ENDIAN_BITFIELD
+	print_num[0] = upper_num;
+	print_num[1] = lower_num;
+#else
+	print_num[0] = lower_num;
+	print_num[1] = upper_num;
+#endif
+}
+
+static int btf_dump_bitfield_get_data(struct btf_dump *d,
+				      void *data,
+				      __u8 bits_offset,
+				      __u8 nr_bits,
+				      __u64 *print_num)
+{
+	__u16 left_shift_bits, right_shift_bits;
+	__u8 nr_copy_bytes;
+	__u8 nr_copy_bits;
+
+	nr_copy_bits = nr_bits + bits_offset;
+	nr_copy_bytes = BITS_ROUNDUP_BYTES(nr_copy_bits);
+
+	memcpy(print_num, data, nr_copy_bytes);
+
+#ifdef __BIG_ENDIAN_BITFIELD
+	left_shift_bits = bits_offset;
+#else
+	left_shift_bits = BITS_PER_U128 - nr_copy_bits;
+#endif
+	right_shift_bits = BITS_PER_U128 - nr_bits;
+
+	btf_int128_shift(print_num, left_shift_bits, right_shift_bits);
+
+	return 0;
+}
+
+static int btf_dump_bitfield_data(struct btf_dump *d,
+				  const struct btf_type *t,
+				  void *data,
+				  __u8 bits_offset,
+				  __u8 nr_bits)
+{
+	__u64 print_num[2] = {};
+
+	btf_dump_bitfield_get_data(d, data, bits_offset, nr_bits, print_num);
+	btf_dump_int128(d, t, print_num);
+
+	return 0;
+}
+
+static int btf_dump_int_bits(struct btf_dump *d,
+			     const struct btf_type *t,
+			     void *data,
+			     __u8 bits_offset)
+{
+	__u8 nr_bits = d->data.state.bitfield_size ?: btf_int_bits(t);
+	__u8 total_bits_offset;
+
+	/*
+	 * bits_offset is at most 7.
+	 * BTF_INT_OFFSET() cannot exceed 128 bits.
+	 */
+	total_bits_offset = bits_offset + btf_int_offset(t);
+	data += BITS_ROUNDDOWN_BYTES(total_bits_offset);
+	bits_offset = BITS_PER_BYTE_MASKED(total_bits_offset);
+	return btf_dump_bitfield_data(d, t, data, bits_offset, nr_bits);
+}
+
+static int btf_dump_int_bits_check_zero(struct btf_dump *d,
+					const struct btf_type *t,
+					void *data,
+					__u8 bits_offset)
+{
+	__u64 print_num[2], zero[2] = { };
+	__u8 nr_bits = d->data.state.bitfield_size ?: btf_int_bits(t);
+	__u8 total_bits_offset;
+
+	total_bits_offset = bits_offset + btf_int_offset(t);
+	data += BITS_ROUNDDOWN_BYTES(total_bits_offset);
+	bits_offset = BITS_PER_BYTE_MASKED(total_bits_offset);
+	btf_dump_bitfield_get_data(d, data, bits_offset, nr_bits,
+				   (__u64 *)&print_num);
+	if (memcmp(print_num, zero, sizeof(zero)) == 0)
+		return -ENODATA;
+	return 0;
+}
+
+static int btf_dump_int_check_zero(struct btf_dump *d,
+				const struct btf_type *t,
+				void *data,
+				__u8 bits_offset)
+{
+	__u8 encoding = btf_int_encoding(t);
+	bool sign = encoding & BTF_INT_SIGNED;
+	__u8 nr_bits = btf_int_bits(t);
+	bool zero = false;
+
+	if (bits_offset || btf_int_offset(t) ||
+	    BITS_PER_BYTE_MASKED(nr_bits))
+		return btf_dump_int_bits_check_zero(d, t, data, bits_offset);
+
+	switch (nr_bits) {
+	case 128:
+		zero = sign ? (*(__int128 *)data) == 0 :
+			      (*(unsigned __int128 *)data) == 0;
+		break;
+	case 64:
+		zero = sign ? (*(__s64 *)data) == 0 :
+			      (*(__u64 *)data) == 0;
+		break;
+	case 32:
+		zero = sign ? (*(__s32 *)data) == 0 :
+			      (*(__u32 *)data) == 0;
+		break;
+	case 16:
+		zero = sign ? (*(__s16 *)data) == 0 :
+			      (*(__u16 *)data) == 0;
+		break;
+	case 8:
+		zero = sign ? (*(__s8 *)data) == 0 :
+			      (*(__u8 *)data) == 0;
+		break;
+	default:
+		break;
+	}
+	if (zero)
+		return -ENODATA;
+	return 0;
+}
+
+static int btf_dump_int_data(struct btf_dump *d,
+			     const struct btf_type *t,
+			     __u32 type_id,
+			     void *data,
+			     __u8 bits_offset)
+{
+	__u8 encoding = btf_int_encoding(t);
+	bool sign = encoding & BTF_INT_SIGNED;
+	__u8 nr_bits = btf_int_bits(t);
+
+	if (bits_offset || btf_int_offset(t) ||
+	    BITS_PER_BYTE_MASKED(nr_bits))
+		return btf_dump_int_bits(d, t, data, bits_offset);
+
+	switch (nr_bits) {
+	case 128:
+		btf_dump_int128(d, t, data);
+		break;
+	case 64:
+		if (sign)
+			btf_dump_type_values(d, "%lld", *(long long *)data);
+		else
+			btf_dump_type_values(d, "%llu",
+					     *(unsigned long long *)data);
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
+		if (d->data.state.array_ischar) {
+			/* check for null terminator */
+			if (d->data.state.array_terminated)
+				break;
+			if (*(char *)data == '\0') {
+				d->data.state.array_terminated = 1;
+				break;
+			}
+			if (isprint(*(char *)data)) {
+				btf_dump_type_values(d, "'%c'",
+						     *(char *)data);
+				break;
+			}
+		}
+		if (sign)
+			btf_dump_type_values(d, "%d", *(__s8 *)data);
+		else
+			btf_dump_type_values(d, "%u", *(__u8 *)data);
+		break;
+	default:
+		return btf_dump_int_bits(d, t, data, bits_offset);
+	}
+	return 0;
+}
+
+static int btf_dump_var_data(struct btf_dump *d,
+			     const struct btf_type *v,
+			     __u32 id,
+			     void *data)
+{
+	enum btf_func_linkage linkage = btf_var(v)->linkage;
+	const struct btf_type *t;
+	const char *l = "";
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
+		break;
+	}
+
+	/* format of output here is [linkage] [type] [varname] = (type)value,
+	 * for example "static int cpu_profile_flip = (int)1"
+	 */
+	btf_dump_printf(d, "%s", l);
+	type_id = v->type;
+	t = btf__type_by_id(d->btf, type_id);
+	btf_dump_emit_type_name(d, type_id, NULL, 0, false);
+	btf_dump_printf(d, " %s = ", btf_name_of(d, v->name_off));
+	return btf_dump_dump_type_data(d, NULL,
+				       t, type_id, data, 0);
+}
+
+static int btf_dump_array_data(struct btf_dump *d,
+			       const struct btf_type *t,
+			       __u32 id,
+			       void *data)
+{
+	const struct btf_array *array = btf_array(t);
+	const struct btf_type *elem_type;
+	__u32 i, elem_size = 0, elem_type_id;
+	int array_member;
+
+	elem_type_id = array->type;
+	elem_type = skip_mods_and_typedefs(d->btf, elem_type_id, NULL);
+	if (!elem_type) {
+		pr_warn("unexpected error skipping mods/typedefs for id [%u]\n",
+			elem_type_id);
+		return -EINVAL;
+	}
+	elem_size = btf__resolve_size(d->btf, elem_type_id);
+
+	if (elem_type && btf_is_int(elem_type)) {
+		/*
+		 * BTF_INT_CHAR encoding never seems to be set for
+		 * char arrays, so if size is 1 and element is
+		 * printable as a char, we'll do that.
+		 */
+		if (elem_size == 1)
+			d->data.state.array_ischar = true;
+	}
+
+	if (!elem_type)
+		return 0;
+
+	btf_dump_printf(d, "[%s",
+			btf_dump_data_newline(d));
+	d->data.state.depth++;
+
+	/* may be a multidimemsional array, so store current "is array member"
+	 * status so we can restore it correctly later.
+	 */
+	array_member = d->data.state.array_member;
+	d->data.state.array_member = 1;
+	for (i = 0; i < array->nelems && !d->data.state.array_terminated; i++) {
+
+		btf_dump_dump_type_data(d, NULL, elem_type, elem_type_id,
+					  data, 0);
+		data += elem_size;
+	}
+	d->data.state.array_member = array_member;
+	d->data.state.depth--;
+	btf_dump_printf(d, "%s]%s%s",
+			btf_dump_data_pfx(d),
+			btf_dump_data_delim(d),
+			btf_dump_data_newline(d));
+
+	return 0;
+}
+
+static int btf_dump_struct_data(struct btf_dump *d,
+				const struct btf_type *t,
+				__u32 id,
+				void *data)
+{
+	const struct btf_member *member;
+	__u32 i;
+	int err;
+
+	btf_dump_printf(d, "{%s",
+			btf_dump_data_newline(d));
+	d->data.state.depth++;
+	for (i = 0, member = btf_members(t);
+	     i < btf_vlen(t);
+	     i++, member++) {
+		const struct btf_type *member_type;
+		__u32 bytes_offset, member_offset;
+		const char *member_name;
+		__u8 bits8_offset;
+
+		member_type = btf__type_by_id(d->btf, member->type);
+		member_name = btf_name_of(d, member->name_off);
+		member_offset = btf_member_bit_offset(t, i);
+		bytes_offset = BITS_ROUNDDOWN_BYTES(member_offset);
+		bits8_offset = BITS_PER_BYTE_MASKED(member_offset);
+
+		/* btf_int_bits() does not store member bitfield size;
+		 * bitfield size needs to be stored here so int display
+		 * of member can retrieve it.
+		 */
+		d->data.state.bitfield_size =
+			btf_member_bitfield_size(t, i);
+		err = btf_dump_dump_type_data(d,
+					      member_name,
+					      member_type,
+					      member->type,
+					      data + bytes_offset,
+					      bits8_offset);
+		d->data.state.bitfield_size = 0;
+		if (err)
+			return err;
+	}
+	d->data.state.depth--;
+	btf_dump_printf(d, "%s}%s%s",
+			btf_dump_data_pfx(d),
+			btf_dump_data_delim(d),
+			btf_dump_data_newline(d));
+	return err;
+}
+
+static int btf_dump_ptr_data(struct btf_dump *d,
+			      const struct btf_type *t,
+			      __u32 id,
+			      void *data)
+{
+	btf_dump_type_values(d, "%p", *(void **)data);
+	return 0;
+}
+
+static int btf_dump_get_enum_value(const struct btf_type *t,
+				   void *data,
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
+		pr_warn("unexpected size %d for enum, id:[%u]\n",
+			t->size, id);
+		return -EINVAL;
+	}
+}
+
+static int btf_dump_enum_data(struct btf_dump *d,
+			      const struct btf_type *t,
+			      __u32 id,
+			      void *data)
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
+		btf_dump_type_values(d, "%s",
+				     btf_name_of(d, e->name_off));
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
+				 void *data)
+{
+	const struct btf_var_secinfo *vsi;
+	const struct btf_type *var;
+	__u32 i;
+	int err;
+
+	btf_dump_type_values(d, "SEC(\"%s\") ",
+			     btf_name_of(d, t->name_off));
+	for (i = 0, vsi = btf_var_secinfos(t);
+	     i < btf_vlen(t);
+	     i++, vsi++) {
+		var = btf__type_by_id(d->btf, vsi->type);
+		err = btf_dump_dump_type_data(d, NULL, var,
+					      vsi->type,
+					      data + vsi->offset,
+					      0);
+		if (err)
+			return err;
+		btf_dump_printf(d, ";");
+	}
+	return 0;
+}
+
+static int btf_dump_type_data_check_overflow(struct btf_dump *d,
+					     const struct btf_type *t,
+					     __u32 id,
+					     void *data,
+					     __u8 bits_offset)
+{
+	__s64 size;
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
+		size = btf__resolve_size(d->btf, id);
+		if (size < 0) {
+			pr_warn("unexpected size [%llu] for id [%u]\n",
+				size, id);
+			return -EINVAL;
+		}
+		if (data + (bits_offset >> 3) + size > d->data.data_end)
+			return -E2BIG;
+		return 0;
+	default:
+		return 0;
+	}
+}
+
+static int btf_dump_type_data_check_zero(struct btf_dump *d,
+					 const struct btf_type *t,
+					 __u32 id,
+					 void *data,
+					 __u8 bits_offset)
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
+	if (d->data.emit_zeroes || d->data.state.depth == 0 ||
+	    (d->data.state.array_member && !d->data.state.array_ischar))
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
+		if (d->data.state.bitfield_size)
+			return btf_dump_int_bits_check_zero(d, t, data,
+							    bits_offset);
+		return btf_dump_int_check_zero(d, t, data, bits_offset);
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
+							    bits_offset);
+			if (err != -ENODATA)
+				return err;
+		}
+		return -ENODATA;
+	}
+	case BTF_KIND_STRUCT:
+	case BTF_KIND_UNION: {
+		const struct btf_member *member;
+
+		/* if any struct/union member is non-zero, the struct/union
+		 * is considered non-zero and dumped.
+		 */
+		for (i = 0, member = btf_members(t);
+		     i < btf_vlen(t);
+		     i++, member++) {
+			const struct btf_type *member_type;
+			__u32 bytes_offset, member_offset;
+			__u8 bits8_offset;
+
+			member_type = btf__type_by_id(d->btf, member->type);
+			member_offset = btf_member_bit_offset(t, i);
+			bytes_offset = BITS_ROUNDDOWN_BYTES(member_offset);
+			bits8_offset = BITS_PER_BYTE_MASKED(member_offset);
+
+			/* btf_int_bits() does not store member bitfield size;
+			 * bitfield size needs to be stored here so int display
+			 * of member can retrieve it.
+			 */
+			d->data.state.bitfield_size =
+				btf_member_bitfield_size(t, i);
+
+			err = btf_dump_type_data_check_zero(d, member_type,
+							    member->type,
+							    data + bytes_offset,
+							    bits8_offset);
+			d->data.state.bitfield_size = 0;
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
+static int btf_dump_dump_type_data(struct btf_dump *d,
+				   const char *fname,
+				   const struct btf_type *t,
+				   __u32 id,
+				   void *data,
+				   __u8 bits_offset)
+{
+	int err;
+
+	err = btf_dump_type_data_check_overflow(d, t, id, data, bits_offset);
+	if (err)
+		return err;
+	err = btf_dump_type_data_check_zero(d, t, id, data, bits_offset);
+	if (err) {
+		/* zeroed data is expected and not an error, so simply skip
+		 * dumping such data.  Record other errors however.
+		 */
+		if (err == -ENODATA)
+			return 0;
+		return err;
+	}
+	btf_dump_printf(d, "%s", btf_dump_data_pfx(d));
+	if (!d->data.skip_names)
+		btf_dump_emit_type_name(d, id, fname, 0, true);
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
+		return btf_dump_df_data(d, t, id, data);
+	case BTF_KIND_INT:
+		if (d->data.state.bitfield_size)
+			return btf_dump_bitfield_data(d, t, data,
+						      bits_offset,
+						      d->data.state.bitfield_size);
+		return btf_dump_int_data(d, t, id, data, bits_offset);
+	case BTF_KIND_PTR:
+		return btf_dump_ptr_data(d, t, id, data);
+	case BTF_KIND_ARRAY:
+		return btf_dump_array_data(d, t, id, data);
+	case BTF_KIND_STRUCT:
+	case BTF_KIND_UNION:
+		return btf_dump_struct_data(d, t, id, data);
+	case BTF_KIND_ENUM:
+		return btf_dump_enum_data(d, t, id, data);
+	case BTF_KIND_VAR:
+		return btf_dump_var_data(d, t, id, data);
+	case BTF_KIND_DATASEC:
+		return btf_dump_datasec_data(d, t, id, data);
+	default:
+		pr_warn("unexpected kind [%u] for id [%u]\n",
+			BTF_INFO_KIND(t->info), id);
+		return -EINVAL;
+	}
+}
+
+int btf_dump__dump_type_data(struct btf_dump *d, __u32 id,
+			     void *data, size_t byte_sz,
+			     const struct btf_dump_type_data_opts *opts)
+{
+	const struct btf_type *t;
+	int err;
+
+	if (!OPTS_VALID(opts, btf_dump_type_data_opts))
+		return -EINVAL;
+
+	t = btf__type_by_id(d->btf, id);
+	if (!t)
+		return -ENOENT;
+
+	d->data.data_end = data + byte_sz;
+	d->data.indent_lvl = OPTS_GET(opts, indent_level, 0);
+	d->data.compact = OPTS_GET(opts, compact, false);
+	d->data.skip_names = OPTS_GET(opts, skip_names, false);
+	d->data.emit_zeroes = OPTS_GET(opts, emit_zeroes, false);
+	memset(&d->data.state, 0, sizeof(d->data.state));
+
+	err = btf_dump_dump_type_data(d, NULL, t, id, data, 0);
+
+	/* We reported all the data; return size of data we reported. */
+	if (err == 0)
+		err = btf__resolve_size(d->btf, id);
+
+	memset(&d->data, 0, sizeof(d->data));
+
+	return err;
+}
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 0229e01..76cfac6 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -370,3 +370,8 @@ LIBBPF_0.4.0 {
 		bpf_tc_hook_destroy;
 		bpf_tc_query;
 } LIBBPF_0.3.0;
+
+LIBBPF_0.5.0 {
+	global:
+		btf_dump__dump_type_data;
+} LIBBPF_0.4.0;
-- 
1.8.3.1

