Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3C23D2F79
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 00:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhGVVZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 17:25:37 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:63596 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230481AbhGVVZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 17:25:35 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16MLv3kf010607;
        Thu, 22 Jul 2021 22:05:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=rDgMY72Iqxvarh8/0LI2rdXb43ko/2/TAnq6pjAca7g=;
 b=ldTeAYRLLrbJ3Ywqer+Ncd/YkW11Piq+0x8CrU/+oQ9pZVvwaZnWO9qFyZCYN3ZkYevT
 HialpFCvyN1PGOkwPEoRNkb+Hh36i19Mu7Hr7xOvJIRUaYk3kMOKoVY1edl0htJ0RtHP
 ovEeKtAVTQXNQhhPsOOr5QwSUReCy82FAnkIAyQH6suwf91SWbFLSdjd1L4N+1Ly9LGa
 A3fztfqHmC6hfdAuPjpZHRxijiXyn6u2OXJtHIClhHhzGFiLRngAEBKPqAc9Ge4ERn/Y
 KUnJnlMwGqjEok4QJ5vtG9dSKMuSqhimyAav0aPVtbcIDevWiWLW8wG+FmaaUlFbIRA5 bg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2020-01-29; bh=rDgMY72Iqxvarh8/0LI2rdXb43ko/2/TAnq6pjAca7g=;
 b=FNjkMI/VeiMnODdD9c+oZmSraMrvEDsvRaU0hB9goFIiXUxbU0ZW4ngaqoVSKFBrkSVS
 G3DW8Tz/DFWwB7+8SGxTb3adHtzSGq1JIwjytyW2QWgReU/Qqj089n/0+TyqRHNeEgEc
 3bm8asNegXCI5bh0O3dJUEZ5SXF1n/V4gh1wA9O7qAcwq0hSLbjqzM0w0/Zzhwck0gVp
 qxdSmZ4cAgOQOsA1L+LH8pLVAtBr6APVNnMpRtB4A4KNFwsQZDEMX9TTbizWZIbMLAIH
 tAdSN51WGsDVuKeM+bnNAVr5w5SMvcDgH5yQTnYLb4QGFOcaQ33oH5jjqvpDtx2m7HdE Mg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39y37ta1ww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jul 2021 22:05:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16MM5Rq8095688;
        Thu, 22 Jul 2021 22:05:49 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2048.outbound.protection.outlook.com [104.47.57.48])
        by aserp3030.oracle.com with ESMTP id 39wunpqf63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jul 2021 22:05:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lsHkgk3lckoeNM9FPY/fWv5KS24Kq7XXke2NLJnkQBB1pg3sud0DYlQiUZvUsC4qFY8l/NX9lsrnvWfibDyfvKnBfkL9htpLos5RLeOU+WibyTZsavEvO4l2QC+CIEXjDbF8AG447fWa6RMHV/LbIOBIi6NFKwvSfI1bwDYGV8wKjMDnk4KqJcSyRKwDZ4+dSytPGeEKezP8VeeZsgkLPVvZUJE0wHvayXobUby7v8g7pzimqh3nnoP5bWq91NJQRfxA1MnB6TxxsAwiRcZ+StW4+Cr3CRAVCAffw2QoSBBHqLTnurGuMwYJkvXuJdPBwhSz77tIlIhXP0AznfcfXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rDgMY72Iqxvarh8/0LI2rdXb43ko/2/TAnq6pjAca7g=;
 b=GYuK259tlp8y5/QNA/Ka5iNZHgsCTZSxPFlHIbE73wZa+SrSRvdoM2g0T34uH+8UOBXPP+HFi4dZ7I9c0Y54ntEG8eyTQiqL/ZRhLKs6zjkTCS4ZKz/iuzF7bARxUiCl+HQUQsEx7wSbLtoLPoQru4y3i7Xx0WgYrOP49R8+wD8144lloWsHXT9X3zHrCPRrO9GC6Hrj+YjDtAxsuVK4SbcOWBofjWRQCnQwo85iM9OoqB2AAxGaXlghpJCT9TiSaAbKYaXH32F+9f20fKDU6Em+tsWbwNPd8807Wi0JgorhKgcbFK+gNXfKsRoSrXiTdwD0T4KM3PeO9q4fx2sFsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rDgMY72Iqxvarh8/0LI2rdXb43ko/2/TAnq6pjAca7g=;
 b=QrHOkHmQOF6OVwF0QaHJ25Jqxp22y/gJZSVG36o1AzCvUlC3F1t381QcFp8MtQHgNYW9tER2CX+HeqZ91sM3B7DNfHS5QoSN5Ey11YItRF+FeW5RMn5ASLd1rQcthyGKSX9nF/IFEnFky/Jyz15nIXvFeQBhSiz7HEoiDyuzJuo=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by MN2PR10MB3165.namprd10.prod.outlook.com (2603:10b6:208:12b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Thu, 22 Jul
 2021 22:05:47 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56%9]) with mapi id 15.20.4352.026; Thu, 22 Jul 2021
 22:05:47 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf-next] selftests/bpf: add multidimensional array BTF-based data dump test
Date:   Thu, 22 Jul 2021 23:05:40 +0100
Message-Id: <1626991540-21097-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0092.eurprd03.prod.outlook.com
 (2603:10a6:208:69::33) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.uk.oracle.com (95.45.14.174) by AM0PR03CA0092.eurprd03.prod.outlook.com (2603:10a6:208:69::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.25 via Frontend Transport; Thu, 22 Jul 2021 22:05:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b25bc48-e081-4334-fd39-08d94d5cdb30
X-MS-TrafficTypeDiagnostic: MN2PR10MB3165:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB31652566B71B82733B6FB698EFE49@MN2PR10MB3165.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nXd6Gq2fk9kWAEenoq6g8cn8G/2W2dtCj6ER0cl+8E5vulG0VvIOe8PD/UPI/PlZ7B6QCeXZnKSKpl1Bqr26c5eu2D8+DbgYk5MXKjrfSKyTsCkUkqt18hcb2C4lln+LMGFGZnJaYIIukzOnVQn8qbkSj4YRYkGjf2Vg2hPdIZFT5cz6ViYBMf0JQyTay8AiRxWpMcBuZ8CTrTc0u6cqvipk+sz0RHbB4g/uumMkokBJLimL/hi7wut8XOfHa6I5h06P/6vqRC4q+nturlWGQggz0FPbo5ZQMb/BQ//TiHmc4QE6CXwFXsX+UPK02nCbyy4yxn4PURyCcQ2ABX9jR9dOlvVB0TrHF1IO8EywsuCfgpuxaIFbzKz6CEZQ3nYaPsAqHKdiO0I30/WIdzOg6iRv8zTcIDwF7K1/Tcbvv7U1Z/23atuFKn1HRb7xj277DkwEbuqIyatwe2D0VAQ+vj3C/J1TJg0AjnLfP7khZfou3Hs8mh0Bbnw3ohR5nrUiHNYn8fAEm7M7hpSt0XsdTNNnjLDGKY7gguo00AZhqUqlxTpPzXl9/A9wWmJcwR94KtbcVDjfxs2zo6JJjpkQdQzVyJCRTxpEeJrWNyB/WRXglWwpBUOFP1oDuht3JDWenPuvxWHjHeuZcczdu1WBjjT6tbdbXEUWziFNMnljEEZ0qGLnVF4TNpbW/gDeQUA5X5mTQA20RY141FRy7IqJ/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(396003)(366004)(346002)(39860400002)(66946007)(2616005)(38100700002)(36756003)(7416002)(7696005)(52116002)(107886003)(86362001)(956004)(38350700002)(66556008)(66476007)(44832011)(4326008)(26005)(478600001)(6486002)(8676002)(8936002)(316002)(6666004)(2906002)(186003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MmxUlSGppqQKOfoACkTa2EeWhY7WkvKD0de4CIqhmAqTkDPm0a5kNFzsJqQ9?=
 =?us-ascii?Q?cOxmg6Of/2Q8Z9vISuCl4qN/lWdFVSfO9ywrnuWtIFz//Q3hsotxHfiCs5B/?=
 =?us-ascii?Q?ONxqERGHMnAwmZxDLey0jJ3CeIG/F5FZlZVKffnge3gBPOuYaZJpkEHn+KFJ?=
 =?us-ascii?Q?bRHsJ/xRLCx0ZsW5lb3nuRkcAkSoYQD59AnfA4/YRwMaZPuqGK9ngc4eEoFm?=
 =?us-ascii?Q?3fL7bgkbM5eY5XcsS74cQEuNNaRtDAFzgqpT5qlC7wK9eAP2KJR+gSBhY/c7?=
 =?us-ascii?Q?o2f6IeEf6NQpoFBI1K0D12pbRqrC/nSQ7V2UJ7I364RTZmNn5XE5Ow09FCxD?=
 =?us-ascii?Q?lf+Nhd8q2kUMX0zCvVRBiLc8OMWN8xTh6PSS+/XPqMz7JvBr9xwBZeRwyFku?=
 =?us-ascii?Q?0QzX9d8aG9+pEzt057snFLSwtPn/nTsIf/Mat7DUqPzSEau8LafuXO63spHj?=
 =?us-ascii?Q?EJj7fnV/XOCdU5L2Qq3TGuujm/55B/57P/uMirOs7HRBPDctj9ZfEX/tVhUQ?=
 =?us-ascii?Q?gBbTgi9s3L6piQLjkPyKtMJixxdbcHndlpXIpRXMLgv/P7u34HGo5KRaVwAf?=
 =?us-ascii?Q?2UZDoe++ktbLW1y/Dpb3o8dvEk8s+JKKyEZtk+kxDorW/dg1ALq/lRcRNnYw?=
 =?us-ascii?Q?08a5WDAVn2oZJDS8+yjnSOTWbNsXk40RV9liKbachfeZzp57r7u9m2k+aLH3?=
 =?us-ascii?Q?LQu4pW9LSPjenLzh7dXGizgE6W0pP2Jf0XEAho+bnpvI0OwVJHMcuYK4MYVY?=
 =?us-ascii?Q?07mRRzPJt5BOa6AtLGXuyV9lyZ5WyMZ8XOEvyLW78xqdufEJcF4I0xU4lncR?=
 =?us-ascii?Q?9DzafHL3Dszk/8kEG5+bUWTPuOzdx3nmH0lINDrvtSNEqX86M18+LyiU0F/n?=
 =?us-ascii?Q?4X5tP+m+/ydtcTdg9XC+gJ+uLBPl952GXvMKWBXdZ349Ov4EXwxsfbYMnxZP?=
 =?us-ascii?Q?fxPSpDrZJH4ybT6iWeFd2CgAt2GGZpC4Nd+UlZYWxFkS4KYnx/LEJRDH3RKq?=
 =?us-ascii?Q?H9ko9SWJGK2Jhh17yMFA6xcK+vZlPxSN1Bvumyp8n7yNLFldF22OrGqLzypK?=
 =?us-ascii?Q?okeZA5zye/AQI/pLoucgCm0NWegiWLP3rEqP2FdfWmRt7LwWI1Nl0uRIgZxW?=
 =?us-ascii?Q?btDuPXSnom5LKb12sjcG1O8FmoXEQscGM15uVXJru5FT9cbvo0ccbfa9MYcN?=
 =?us-ascii?Q?GxwjeoXSqc2/vM3DE9aScwbe30dJYKb1nXrqf5Bbf5D0BrKD74cB3ZBZYe8D?=
 =?us-ascii?Q?RVpsuev+pYgC3qXZueAATxDSbWioZzD7uZPJE1IQBUx2MrAiRUbatZq4SI+/?=
 =?us-ascii?Q?iRJxY3oR9ZTTlmaTb9f01E7e?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b25bc48-e081-4334-fd39-08d94d5cdb30
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 22:05:47.4390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ce4mBuWJ5j82tAShw8s0X3ygsM8bV8UygBIGgMSOivvdCY71iPIMd/2kk2Qw0gF+9saGDFs5UDJFsGAFehUgtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3165
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10053 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107220142
X-Proofpoint-ORIG-GUID: mdsZeycYhC8f8DS2GY8B_SIdB79kk0Tz
X-Proofpoint-GUID: mdsZeycYhC8f8DS2GY8B_SIdB79kk0Tz
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are currently no multidimensional array tests for
BTF-based data dumping.  In BTF, a multidimensional array is
represented as an array with an element type of array.  However,
pahole and llvm collapse multidimensional arrays into a
one-dimensional array [1].  Accordingly, the test uses the BTF
add interfaces to create a multidimensional char [2][4] array,
and tests type-based display matches expectations.

[1] See Documentation/bpf/btf.rst Section 2.2.3

Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/testing/selftests/bpf/prog_tests/btf_dump.c | 39 +++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dump.c b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
index 52ccf0c..70d26cf 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_dump.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
@@ -681,6 +681,45 @@ static void test_btf_dump_struct_data(struct btf *btf, struct btf_dump *d,
 "}",
 			   { .cb = { 0, 0, 1, 0, 0},});
 
+	/* multidimensional array; because pahole and llvm collapse arrays
+	 * with multiple dimensions into a single dimension, we add a
+	 * multidimensional array explicitly.
+	 */
+	type_id = btf__find_by_name(btf, "char");
+	if (ASSERT_GT(type_id, 0, "find char")) {
+		__s32 index_id, array1_id, array2_id;
+		char strs[2][4] = { "one", "two" };
+
+		index_id = btf__find_by_name(btf, "int");
+		ASSERT_GT(index_id, 0, "find int");
+
+		array2_id = btf__add_array(btf, index_id, type_id, 4);
+		ASSERT_GT(array2_id, 0, "add multidim 2");
+
+		array1_id = btf__add_array(btf, index_id, array2_id, 2);
+		ASSERT_GT(array1_id, 0, "add multidim 1");
+
+		str[0] = '\0';
+		ret = btf_dump__dump_type_data(d, array1_id, &strs, sizeof(strs), &opts);
+		ASSERT_GT(ret, 0, "dump multidimensional array");
+
+		ASSERT_STREQ(str,
+"(char[2][4])[\n"
+"	[\n"
+"		'o',\n"
+"		'n',\n"
+"		'e',\n"
+"	],\n"
+"	[\n"
+"		't',\n"
+"		'w',\n"
+"		'o',\n"
+"	],\n"
+"]",
+			     "multidimensional char array matches");
+	}
+
+
 	/* struct with bitfields */
 	TEST_BTF_DUMP_DATA_C(btf, d, "struct", str, struct bpf_insn, BTF_F_COMPACT,
 		{.code = (__u8)1,.dst_reg = (__u8)0x2,.src_reg = (__u8)0x3,.off = (__s16)4,.imm = (__s32)5,});
-- 
1.8.3.1

