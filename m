Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A48D43AD8C6
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 10:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234404AbhFSI7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 04:59:11 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:9452 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233964AbhFSI66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 04:58:58 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15J8p0A0002222;
        Sat, 19 Jun 2021 08:56:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=JWIHY72KehJdlupumkhUBejSexsVoWXQr10cm5KPXWo=;
 b=mBoQ9JNLm/zm/WHy7eWM3hhTrA1SoS7U3+UXWP2yEPrBKpccuvAPxgxP/AhAKghPoa8g
 JuOKdnUAPjmjvoloGZ0fRD/bvm0b7ivMTu4AaRHAZDMOwTUXwpMvXzRwq5hXaPorr8MB
 CY0WbQrkEw47jVxdQmQ29QdtrlAe5tzmmuQW8cEXPCyQkVr7ceW+Q2HDEtqI0icdPaLc
 hK3gDmgswL+w3+W9iJYzuhn82fyJnlC89JjejYWW++VSEcLnQGGnRZZJI23iHYticzmv
 aW3HZCysoLgg8s3qU5PgWC6PorEbwa5UqwDAt1Y6JJUdifXbxGNUyv157OHnOi2wzuAl aA== 
Received: from oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39994r06v3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 08:56:31 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15J8uTV9139034;
        Sat, 19 Jun 2021 08:56:30 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by aserp3020.oracle.com with ESMTP id 3998d2jqrs-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 08:56:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d1nDFT8VhO5vkpkhSGdDzLipTouI8nKx2ahuqsliNXfiY41k60wCuUApAvB4x2M7Qk4/xuIa5UoSxPN7dgrv835cMn4yEMh6EANB8lrDcfhkKq0cBV2MyV8AkilMJz+1yvomU4aef/GfMH9GhZJcbe6XvpR2RH2yIf2sHbQcz+1D8cf9jbJ8C0HY8Wo+hxjPLeVFBdqIR3Y17oRos989p1OxIo0kSrJu+t1NS2DoX0VvLo/EO5Y6g4SdZR20/qcC3wr4O86vbZgJLPm/40szCsJHP3m7ENatI4wfKfP5I3A2XBnwtzTyN0ryeVT4bavibIpnVVZVFYDikYmNl+lfVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JWIHY72KehJdlupumkhUBejSexsVoWXQr10cm5KPXWo=;
 b=LqEJLLEDqd5hS4tlxE63OCeNIKPe6dgI6csygwuf21c5dOM4JuyXZ+2hW0titeP2OYQlIbH12YiKm1ywVvbVH3pEGjoCt/4qOiyzj7JE082S6RutsCICFGQU8bYuWJOtIX8OM25tUggvoE32HBDy9DmdwD2MRt3e6K9Vof3VQzGw6datFqNVY6BMVFlc+cINGo2QtTcPbT2daxqIAjFIKwW9Zj9NlObA5R9pdQNIFVDIoZbSrG6Bba3pzVNiPFS0WHt/cvKkxFe+qbYBcD7lAAMyQ2QgYfzUSZvurc0G44x/iaWp60U9OLJ1ehQcszAlpG6kC4Mtj8UVDsNiFkclVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JWIHY72KehJdlupumkhUBejSexsVoWXQr10cm5KPXWo=;
 b=OGMh/u66/t2wSSIVmhkkZ60R+ZyY7HDUi0hxHWg5l63xeNYhg35tNDVzN/ZkAwIGfzG/J2ra0Vel5DDd3VhykdWJMr+oYlWRxZ/5NSONkPQysFjJ8VNljBZY4FkCO37hXgS0vX7x7O+8N/lSMPPqQ18+hW/mVrMEOsCjwoU599k=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by MN2PR10MB3357.namprd10.prod.outlook.com (2603:10b6:208:12e::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Sat, 19 Jun
 2021 08:56:27 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::9da7:f131:1f41:657c]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::9da7:f131:1f41:657c%4]) with mapi id 15.20.4242.023; Sat, 19 Jun 2021
 08:56:27 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v5 bpf-next 3/3] selftests/bpf: add dump type data tests to btf dump tests
Date:   Sat, 19 Jun 2021 09:56:08 +0100
Message-Id: <1624092968-5598-4-git-send-email-alan.maguire@oracle.com>
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
Received: from localhost.localdomain (95.45.14.174) by DU2PR04CA0245.eurprd04.prod.outlook.com (2603:10a6:10:28e::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19 via Frontend Transport; Sat, 19 Jun 2021 08:56:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efd30cb7-d467-4d49-108a-08d933001f9e
X-MS-TrafficTypeDiagnostic: MN2PR10MB3357:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB33573AD7EFEBCC946A6771ADEF0C9@MN2PR10MB3357.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yuGIUSWjtez+PtgcY78THetnHZH2OklVz49/onZs6Obd7ucWRiNMz672+SwQ/dsKiXfDjkK1yG6h6hlahe/lFp9nECdYJZzrf7a4FAzD1eKMjITj4BZBtC4IJE7u0ANXyRp5Fk01pbTCFdgaV9QtmM4LX1edYL7sS1Y18Kwa2LmS+cflNLx+6kKuzAk3DbQVTunpSFtJHKvX0EAgQjQepX4e3ZH1yXbJJcZI+Gcu7aPS87imGRd5yptdsNqtsKLWQCErLRKGhteJa1UvZKxcoIZtAMFcs+b6be3HYTP0P34D1Y+/Q2kAYWhtXNJf6aIyWQYTL1vN7c9vMBrc784vHsLTuF46o7GDTiJQAUGXGfw15/bikfNn4MQAXdvEiz99YFsV7gVqc4BKew2Yjj+6kGK7KvvmWh1oKIQ7yFYNKfhT2FOUHIgifyuX77k8vv7iuSTka6pDKDYrCzcjz8nTbC5dyaPUfGM3QZlC0gUZ+HyXt6xrKHV2bvUWHMR4E15pECd9Uhbtf2u2+gH39XLRd85WF2T68bEZps/xsZxVYm7Z1bd1XzwgOy/8X3BGfp1Dz1RzM2NHeZSoIxGE0cRxEduddoCVorOgJakX4xUH1AKZubcPio/2QdsbbaJDlwZ29vr5IG4IePttfIz4IVjzF06OpW5YVcTl3KSILF8ixJ2+LTYOTU/zUpbzr/WifK7d
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(346002)(136003)(366004)(478600001)(5660300002)(4326008)(26005)(52116002)(44832011)(86362001)(66946007)(83380400001)(6486002)(16526019)(186003)(66476007)(66556008)(6506007)(2616005)(956004)(107886003)(316002)(30864003)(36756003)(7416002)(6512007)(8676002)(2906002)(38350700002)(6666004)(8936002)(38100700002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c66IiaDxoauh2hWFs6HzKc3RnH7jotpwL0ecgmY/jncbTY9ocBl8jX4/YY53?=
 =?us-ascii?Q?RmQ4GJef21epbCbnXIks/CcOO25oohQKp5OmuDF8cTJyAGsXurGlnkFLs1Cm?=
 =?us-ascii?Q?jVeWqjiuzQaH3Yxc+NIhoVeG4ZU12oAdPfJ/nIFWJbAWgHjkynDSdXuE+Mcp?=
 =?us-ascii?Q?v0jmBaF35Xb3k8FmU2IIYq9t+6xAnRYDR1QSIt/k8NSzxfeu1c5VSSRJhzBD?=
 =?us-ascii?Q?rOY7fKoveaCqTifoHPMNZ0hj+H63pKyKNB4DuIEXCYQG7KOEB22mlu3vkGSp?=
 =?us-ascii?Q?ODq/oPtRZxdfrht73IcxawvVp09OkU7Z/xJFeSJ4+LEjbjzBtYDCg8ILSyLb?=
 =?us-ascii?Q?LARuRcuaamQT0jBzTzMyoBgqI/udJV7y14sqJpL7QKprbyJygw/ljk70pZkC?=
 =?us-ascii?Q?9aaHpzTJso1EVKJDT/vmkHi/DslVUOtJ90hd9eDp3Qo/CGRRkgeE7rFW0cwK?=
 =?us-ascii?Q?LgnR44iJwlJ3mt237oWdmACHM+oprJqaW50fK5YXiFm/nI5gmbMIP1Xgf7pU?=
 =?us-ascii?Q?677OfMaKDZzNPfLl0Qo8tQrLKcozwTKA92Zkx5m2vc9a+p5ch685KSdhDJ4S?=
 =?us-ascii?Q?5Q59+979X8NWfrwRU7EWNqhZHWpphmUSu36TWwXWYL42Vqk2tWPr4jkai27s?=
 =?us-ascii?Q?gFRiyJNb9KDKJb7kJ+GmvJBVXemdSOtzUTYqC0ncC2DrrLnoOKDO5ZKn+rVe?=
 =?us-ascii?Q?rfS5MfytvEX+vYTTjQl9gV2OMJLJ/+5XG82a5GsNfP4y1ITzp2ykGpzBvezT?=
 =?us-ascii?Q?PSI0amu19C+GmcJUV+JtsQAykioaf0Ss45NjUe/JoisFs/aHglcT4QCsppvJ?=
 =?us-ascii?Q?2I4KvFfs5VJ0qqQS6MEtred++Zvj1KzgUKn2mM6vW4zM+KVt+PerqtJ6APpt?=
 =?us-ascii?Q?5iqyJ9Tgd6uFfaDFB3u1gbhe6cvqWbsLSuqFnBi7Rh4UdeQGHos9+ki5a8xN?=
 =?us-ascii?Q?dOPcAlz5YRC2YXaGipueSmEQcw+iSTtPQUqAy2Tcu/trN63dGacOy/eaSqse?=
 =?us-ascii?Q?n/r+toeawgvfDiO5thCe4GAeZsV2lVwuMBiTxnxwzutglNoPScb/MBWAsk3t?=
 =?us-ascii?Q?8LLN5ywHFYG+vnNBRd4pQkkUjSXRer4CtzgWf2x4getgyX0wfmheZKdhGQay?=
 =?us-ascii?Q?qkP9BN/QKX3G2yU9JJ3W3wCpPZJ7beVBzgQrWEdsC7mqPJCirB9cpQ2RvEmf?=
 =?us-ascii?Q?jSo1Eawp4aqMdF/hIG5OyxZKettV/hP4ERuJ3svrebGty/oHO0KHTPUKWkWN?=
 =?us-ascii?Q?ycj3pxN4piHyqTvk4XzguHkX4y9NL1sjazzdDriDIfl3VsOD9Xk6rlpSKesJ?=
 =?us-ascii?Q?B2lb4jYtODll3wD6iVNvuTVT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efd30cb7-d467-4d49-108a-08d933001f9e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2021 08:56:27.4329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r5X5YW6JbqbJJx7gTl2UPoLRQdE4V1gLH6cmNajafnDz4sw3YxLgSNYDStSvwDzR7DYl0lUOnW08LiBqAoWgFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3357
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10019 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106190058
X-Proofpoint-ORIG-GUID: DDLVZaNQ20OoFgewXhiS8lm-PNCZrKBU
X-Proofpoint-GUID: DDLVZaNQ20OoFgewXhiS8lm-PNCZrKBU
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test various type data dumping operations by comparing expected
format with the dumped string; an snprintf-style printf function
is used to record the string dumped.  Also verify overflow handling
where the data passed does not cover the full size of a type,
such as would occur if a tracer has a portion of the 8k
"struct task_struct".

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/testing/selftests/bpf/prog_tests/btf_dump.c | 644 ++++++++++++++++++++++
 1 file changed, 644 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dump.c b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
index 1b90e68..c894201 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_dump.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
@@ -232,7 +232,621 @@ void test_btf_dump_incremental(void)
 	btf__free(btf);
 }
 
+#define STRSIZE				4096
+
+static void btf_dump_snprintf(void *ctx, const char *fmt, va_list args)
+{
+	char *s = ctx, new[STRSIZE];
+
+	vsnprintf(new, STRSIZE, fmt, args);
+	strncat(s, new, STRSIZE);
+}
+
+/* skip "enum "/"struct " prefixes */
+#define SKIP_PREFIX(_typestr, _prefix)					\
+	do {								\
+		if (strncmp(_typestr, _prefix, strlen(_prefix)) == 0)	\
+			_typestr += strlen(_prefix) + 1;		\
+	} while (0)
+
+static int btf_dump_data(struct btf *btf, struct btf_dump *d,
+			 char *name, __u64 flags, void *ptr,
+			 size_t ptr_sz, char *str, const char *expected_val)
+{
+	DECLARE_LIBBPF_OPTS(btf_dump_type_data_opts, opts);
+	size_t type_sz;
+	__s32 type_id;
+	int ret = 0;
+
+	if (flags & BTF_F_COMPACT)
+		opts.compact = true;
+	if (flags & BTF_F_NONAME)
+		opts.skip_names = true;
+	if (flags & BTF_F_ZERO)
+		opts.emit_zeroes = true;
+	SKIP_PREFIX(name, "enum");
+	SKIP_PREFIX(name, "struct");
+	SKIP_PREFIX(name, "union");
+	type_id = btf__find_by_name(btf, name);
+	if (!ASSERT_GE(type_id, 0, "find type id"))
+		return -ENOENT;
+	type_sz = btf__resolve_size(btf, type_id);
+	str[0] = '\0';
+	ret = btf_dump__dump_type_data(d, type_id, ptr, ptr_sz, &opts);
+	if (type_sz <= ptr_sz) {
+		if (!ASSERT_EQ(ret, type_sz, "failed/unexpected type_sz"))
+			return -EINVAL;
+	} else {
+		if (!ASSERT_EQ(ret, -E2BIG, "failed to return -E2BIG"))
+			return -EINVAL;
+	}
+	if (!ASSERT_STREQ(str, expected_val, "ensure expected/actual match"))
+		return -EFAULT;
+	return 0;
+}
+
+#define TEST_BTF_DUMP_DATA(_b, _d, _str, _type, _flags, _expected, ...)	\
+	do {								\
+		char __ptrtype[64] = #_type;				\
+		char *_ptrtype = (char *)__ptrtype;			\
+		_type _ptrdata = __VA_ARGS__;				\
+		void *_ptr = &_ptrdata;					\
+		int _err;						\
+									\
+		_err = btf_dump_data(_b, _d, _ptrtype, _flags, _ptr,	\
+				     sizeof(_type), _str, _expected);	\
+		if (_err < 0)						\
+			return;						\
+	} while (0)
+
+/* Use where expected data string matches its stringified declaration */
+#define TEST_BTF_DUMP_DATA_C(_b, _d, _str, _type, _flags, ...)		\
+	TEST_BTF_DUMP_DATA(_b, _d, _str, _type, _flags,			\
+			   "(" #_type ")" #__VA_ARGS__,	__VA_ARGS__)
+
+/* overflow test; pass typesize < expected type size, ensure E2BIG returned */
+#define TEST_BTF_DUMP_DATA_OVER(_b, _d, _str, _type, _type_sz, _expected, ...)\
+	do {								\
+		char __ptrtype[64] = #_type;				\
+		char *_ptrtype = (char *)__ptrtype;			\
+		_type _ptrdata = __VA_ARGS__;				\
+		void *_ptr = &_ptrdata;					\
+		int _err;						\
+									\
+		_err = btf_dump_data(_b, _d, _ptrtype, 0, _ptr,		\
+				     _type_sz, _str, _expected);	\
+		if (_err < 0)						\
+			return;						\
+	} while (0)
+
+#define TEST_BTF_DUMP_VAR(_b, _d, _str, _var, _type, _flags, _expected, ...) \
+	do {								\
+		_type _ptrdata = __VA_ARGS__;				\
+		void *_ptr = &_ptrdata;					\
+		int _err;						\
+									\
+		_err = btf_dump_data(_b, _d, _var, _flags, _ptr,	\
+				     sizeof(_type), _str, _expected);	\
+		if (_err < 0)						\
+			return;						\
+	} while (0)
+
+static void test_btf_dump_int_data(struct btf *btf, struct btf_dump *d,
+				   char *str)
+{
+	/* simple int */
+	TEST_BTF_DUMP_DATA_C(btf, d, str, int, BTF_F_COMPACT, 1234);
+	TEST_BTF_DUMP_DATA(btf, d, str, int, BTF_F_COMPACT | BTF_F_NONAME,
+			   "1234", 1234);
+	TEST_BTF_DUMP_DATA(btf, d, str, int, 0, "(int)1234", 1234);
+
+	/* zero value should be printed at toplevel */
+	TEST_BTF_DUMP_DATA(btf, d, str, int, BTF_F_COMPACT, "(int)0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, str, int, BTF_F_COMPACT | BTF_F_NONAME,
+			   "0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, str, int, BTF_F_COMPACT | BTF_F_ZERO,
+			   "(int)0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, str, int,
+			   BTF_F_COMPACT | BTF_F_NONAME | BTF_F_ZERO,
+			   "0", 0);
+	TEST_BTF_DUMP_DATA_C(btf, d, str, int, BTF_F_COMPACT, -4567);
+	TEST_BTF_DUMP_DATA(btf, d, str, int, BTF_F_COMPACT | BTF_F_NONAME,
+			   "-4567", -4567);
+	TEST_BTF_DUMP_DATA(btf, d, str, int, 0, "(int)-4567", -4567);
+
+	TEST_BTF_DUMP_DATA_OVER(btf, d, str, int, sizeof(int)-1, "", 1);
+}
+
+static void test_btf_dump_float_data(struct btf *btf, struct btf_dump *d,
+				     char *str)
+{
+	float t1 = 1.234567;
+	float t2 = -1.234567;
+	float t3 = 0.0;
+	double t4 = 5.678912;
+	double t5 = -5.678912;
+	double t6 = 0.0;
+	long double t7 = 9.876543;
+	long double t8 = -9.876543;
+	long double t9 = 0.0;
+
+	/* since the kernel does not likely have any float types in its BTF, we
+	 * will need to add some of various sizes.
+	 */
+
+	if (!ASSERT_GT(btf__add_float(btf, "test_float", 4), 0, "add float"))
+		return;
+	if (!ASSERT_OK(btf_dump_data(btf, d, "test_float", 0, &t1, 4, str,
+				     "(test_float)1.234567"), "dump float"))
+		return;
+
+	if (!ASSERT_OK(btf_dump_data(btf, d, "test_float", 0, &t2, 4, str,
+				     "(test_float)-1.234567"), "dump float"))
+		return;
+	if (!ASSERT_OK(btf_dump_data(btf, d, "test_float", 0, &t3, 4, str,
+				     "(test_float)0.000000"), "dump float"))
+		return;
+
+	if (!ASSERT_GT(btf__add_float(btf, "test_double", 8), 0, "add_double"))
+		return;
+	if (!ASSERT_OK(btf_dump_data(btf, d, "test_double", 0, &t4, 8, str,
+				     "(test_double)5.678912"), "dump double"))
+		return;
+	if (!ASSERT_OK(btf_dump_data(btf, d, "test_double", 0, &t5, 8, str,
+				     "(test_double)-5.678912"), "dump double"))
+		return;
+	if (!ASSERT_OK(btf_dump_data(btf, d, "test_double", 0, &t6, 8, str,
+				     "(test_double)0.000000"), "dump double"))
+		return;
+
+	if (!ASSERT_GT(btf__add_float(btf, "test_long_double", 16), 0,
+		       "add_long_double"))
+		return;
+	if (!ASSERT_OK(btf_dump_data(btf, d, "test_long_double", 0, &t7, 16,
+				     str, "(test_long_double)9.876543"),
+				     "dump long_double"))
+		return;
+	if (!ASSERT_OK(btf_dump_data(btf, d, "test_long_double", 0, &t8, 16,
+				     str, "(test_long_double)-9.876543"),
+				     "dump long_double"))
+		return;
+	ASSERT_OK(btf_dump_data(btf, d, "test_long_double", 0, &t9, 16,
+				str, "(test_long_double)0.000000"),
+				"dump long_double");
+}
+
+static void test_btf_dump_char_data(struct btf *btf, struct btf_dump *d,
+				    char *str)
+{
+	/* simple char */
+	TEST_BTF_DUMP_DATA_C(btf, d, str, char, BTF_F_COMPACT, 100);
+	TEST_BTF_DUMP_DATA(btf, d, str, char, BTF_F_COMPACT | BTF_F_NONAME,
+			   "100", 100);
+	TEST_BTF_DUMP_DATA(btf, d, str, char, 0, "(char)100", 100);
+	/* zero value should be printed at toplevel */
+	TEST_BTF_DUMP_DATA(btf, d, str, char, BTF_F_COMPACT, "(char)0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, str, char, BTF_F_COMPACT | BTF_F_NONAME,
+			   "0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, str, char, BTF_F_COMPACT | BTF_F_ZERO,
+			   "(char)0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, str, char,
+			   BTF_F_COMPACT | BTF_F_NONAME | BTF_F_ZERO,
+			   "0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, str, char, 0, "(char)0", 0);
+
+	TEST_BTF_DUMP_DATA_OVER(btf, d, str, char, sizeof(char)-1, "", 100);
+}
+
+static void test_btf_dump_typedef_data(struct btf *btf, struct btf_dump *d,
+				       char *str)
+{
+	/* simple typedef */
+	TEST_BTF_DUMP_DATA_C(btf, d, str, uint64_t, BTF_F_COMPACT, 100);
+	TEST_BTF_DUMP_DATA(btf, d, str, u64, BTF_F_COMPACT | BTF_F_NONAME,
+			   "1", 1);
+	TEST_BTF_DUMP_DATA(btf, d, str, u64, 0, "(u64)1", 1);
+	/* zero value should be printed at toplevel */
+	TEST_BTF_DUMP_DATA(btf, d, str, u64, BTF_F_COMPACT, "(u64)0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, str, u64, BTF_F_COMPACT | BTF_F_NONAME,
+			   "0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, str, u64, BTF_F_COMPACT | BTF_F_ZERO,
+			   "(u64)0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, str, u64,
+			   BTF_F_COMPACT | BTF_F_NONAME | BTF_F_ZERO,
+			   "0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, str, u64, 0, "(u64)0", 0);
+
+	/* typedef struct */
+	TEST_BTF_DUMP_DATA_C(btf, d, str, atomic_t, BTF_F_COMPACT,
+			     {.counter = (int)1,});
+	TEST_BTF_DUMP_DATA(btf, d, str, atomic_t, BTF_F_COMPACT | BTF_F_NONAME,
+			   "{1,}", { .counter = 1 });
+	TEST_BTF_DUMP_DATA(btf, d, str, atomic_t, 0,
+"(atomic_t){\n"
+"	.counter = (int)1,\n"
+"}",
+			   {.counter = 1,});
+	/* typedef with 0 value should be printed at toplevel */
+	TEST_BTF_DUMP_DATA(btf, d, str, atomic_t, BTF_F_COMPACT, "(atomic_t){}",
+			   {.counter = 0,});
+	TEST_BTF_DUMP_DATA(btf, d, str, atomic_t, BTF_F_COMPACT | BTF_F_NONAME,
+			   "{}", {.counter = 0,});
+	TEST_BTF_DUMP_DATA(btf, d, str, atomic_t, 0,
+"(atomic_t){\n"
+"}",
+			   {.counter = 0,});
+	TEST_BTF_DUMP_DATA(btf, d, str, atomic_t, BTF_F_COMPACT | BTF_F_ZERO,
+			   "(atomic_t){.counter = (int)0,}",
+			   {.counter = 0,});
+	TEST_BTF_DUMP_DATA(btf, d, str, atomic_t,
+			   BTF_F_COMPACT | BTF_F_NONAME | BTF_F_ZERO,
+			   "{0,}", {.counter = 0,});
+	TEST_BTF_DUMP_DATA(btf, d, str, atomic_t, BTF_F_ZERO,
+"(atomic_t){\n"
+"	.counter = (int)0,\n"
+"}",
+			   { .counter = 0,});
+
+	/* overflow should show type but not value since it overflows */
+	TEST_BTF_DUMP_DATA_OVER(btf, d, str, atomic_t, sizeof(atomic_t)-1,
+				"(atomic_t){\n", { .counter = 1});
+}
+
+static void test_btf_dump_enum_data(struct btf *btf, struct btf_dump *d,
+				    char *str)
+{
+	/* enum where enum value does (and does not) exist */
+	TEST_BTF_DUMP_DATA_C(btf, d, str, enum bpf_cmd, BTF_F_COMPACT,
+			     BPF_MAP_CREATE);
+	TEST_BTF_DUMP_DATA(btf, d, str, enum bpf_cmd, BTF_F_COMPACT,
+			   "(enum bpf_cmd)BPF_MAP_CREATE", 0);
+	TEST_BTF_DUMP_DATA(btf, d, str, enum bpf_cmd,
+			   BTF_F_COMPACT | BTF_F_NONAME,
+			   "BPF_MAP_CREATE",
+			   BPF_MAP_CREATE);
+	TEST_BTF_DUMP_DATA(btf, d, str, enum bpf_cmd, 0,
+			   "(enum bpf_cmd)BPF_MAP_CREATE",
+			   BPF_MAP_CREATE);
+	TEST_BTF_DUMP_DATA(btf, d, str, enum bpf_cmd,
+			   BTF_F_COMPACT | BTF_F_NONAME | BTF_F_ZERO,
+			   "BPF_MAP_CREATE", 0);
+	TEST_BTF_DUMP_DATA(btf, d, str, enum bpf_cmd,
+			   BTF_F_COMPACT | BTF_F_ZERO,
+			   "(enum bpf_cmd)BPF_MAP_CREATE",
+			   BPF_MAP_CREATE);
+	TEST_BTF_DUMP_DATA(btf, d, str, enum bpf_cmd,
+			   BTF_F_COMPACT | BTF_F_NONAME | BTF_F_ZERO,
+			   "BPF_MAP_CREATE", BPF_MAP_CREATE);
+	TEST_BTF_DUMP_DATA_C(btf, d, str, enum bpf_cmd, BTF_F_COMPACT, 2000);
+	TEST_BTF_DUMP_DATA(btf, d, str, enum bpf_cmd,
+			   BTF_F_COMPACT | BTF_F_NONAME,
+			   "2000", 2000);
+	TEST_BTF_DUMP_DATA(btf, d, str, enum bpf_cmd, 0,
+			   "(enum bpf_cmd)2000", 2000);
+
+	TEST_BTF_DUMP_DATA_OVER(btf, d, str, enum bpf_cmd,
+				sizeof(enum bpf_cmd) - 1, "", BPF_MAP_CREATE);
+}
+
+static void test_btf_dump_struct_data(struct btf *btf, struct btf_dump *d,
+				      char *str)
+{
+	DECLARE_LIBBPF_OPTS(btf_dump_type_data_opts, opts);
+	char zero_data[512] = { };
+	char type_data[512];
+	void *fops = type_data;
+	void *skb = type_data;
+	size_t type_sz;
+	__s32 type_id;
+	char *cmpstr;
+	int ret;
+
+	memset(type_data, 255, sizeof(type_data));
+
+	/* simple struct */
+	TEST_BTF_DUMP_DATA_C(btf, d, str, struct btf_enum, BTF_F_COMPACT,
+			     {.name_off = (__u32)3,.val = (__s32)-1,});
+	TEST_BTF_DUMP_DATA(btf, d, str, struct btf_enum,
+			   BTF_F_COMPACT | BTF_F_NONAME,
+			   "{3,-1,}",
+			   { .name_off = 3, .val = -1,});
+	TEST_BTF_DUMP_DATA(btf, d, str, struct btf_enum, 0,
+"(struct btf_enum){\n"
+"	.name_off = (__u32)3,\n"
+"	.val = (__s32)-1,\n"
+"}",
+			   { .name_off = 3, .val = -1,});
+	TEST_BTF_DUMP_DATA(btf, d, str, struct btf_enum,
+			   BTF_F_COMPACT | BTF_F_NONAME,
+			   "{-1,}",
+			   { .name_off = 0, .val = -1,});
+	TEST_BTF_DUMP_DATA(btf, d, str, struct btf_enum,
+			   BTF_F_COMPACT | BTF_F_NONAME | BTF_F_ZERO,
+			   "{0,-1,}",
+			   { .name_off = 0, .val = -1,});
+	/* empty struct should be printed */
+	TEST_BTF_DUMP_DATA(btf, d, str, struct btf_enum, BTF_F_COMPACT,
+			   "(struct btf_enum){}",
+			   { .name_off = 0, .val = 0,});
+	TEST_BTF_DUMP_DATA(btf, d, str, struct btf_enum,
+			   BTF_F_COMPACT | BTF_F_NONAME,
+			   "{}",
+			   { .name_off = 0, .val = 0,});
+	TEST_BTF_DUMP_DATA(btf, d, str, struct btf_enum, 0,
+"(struct btf_enum){\n"
+"}",
+			   { .name_off = 0, .val = 0,});
+	TEST_BTF_DUMP_DATA(btf, d, str, struct btf_enum,
+			   BTF_F_COMPACT | BTF_F_ZERO,
+			   "(struct btf_enum){.name_off = (__u32)0,.val = (__s32)0,}",
+			   { .name_off = 0, .val = 0,});
+	TEST_BTF_DUMP_DATA(btf, d, str, struct btf_enum,
+			   BTF_F_ZERO,
+"(struct btf_enum){\n"
+"	.name_off = (__u32)0,\n"
+"	.val = (__s32)0,\n"
+"}",
+			   { .name_off = 0, .val = 0,});
+
+	/* struct with pointers */
+	TEST_BTF_DUMP_DATA(btf, d, str, struct list_head, BTF_F_COMPACT,
+			   "(struct list_head){.next = (struct list_head *)0x1,}",
+			   { .next = (struct list_head *)1 });
+	TEST_BTF_DUMP_DATA(btf, d, str, struct list_head, 0,
+"(struct list_head){\n"
+"	.next = (struct list_head *)0x1,\n"
+"}",
+			   { .next = (struct list_head *)1 });
+	/* NULL pointer should not be displayed */
+	TEST_BTF_DUMP_DATA(btf, d, str, struct list_head, BTF_F_COMPACT,
+			   "(struct list_head){}",
+			   { .next = (struct list_head *)0 });
+	TEST_BTF_DUMP_DATA(btf, d, str, struct list_head, 0,
+"(struct list_head){\n"
+"}",
+			   { .next = (struct list_head *)0 });
+
+	/* struct with function pointers */
+	type_id = btf__find_by_name(btf, "file_operations");
+	if (CHECK(type_id <= 0, "find type id",
+		  "no 'struct file_operations' in BTF: %d\n", type_id))
+		return;
+	type_sz = btf__resolve_size(btf, type_id);
+	str[0] = '\0';
+
+	ret = btf_dump__dump_type_data(d, type_id, fops, type_sz, &opts);
+	if (CHECK(ret != type_sz,
+		  "dump file_operations is successful",
+		  "unexpected return value dumping file_operations '%s': %d\n",
+		  str, ret))
+		return;
+
+	cmpstr =
+"(struct file_operations){\n"
+"	.owner = (struct module *)0xffffffffffffffff,\n"
+"	.llseek = (loff_t (*)(struct file *, loff_t, int))0xffffffffffffffff,";
+
+	if (!ASSERT_STRNEQ(str, cmpstr, strlen(cmpstr), "file_operations"))
+		return;
+
+	/* struct with char array */
+	TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_prog_info, BTF_F_COMPACT,
+			   "(struct bpf_prog_info){.name = (char[16])['f','o','o',],}",
+			   { .name = "foo",});
+	TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_prog_info,
+			   BTF_F_COMPACT | BTF_F_NONAME,
+			   "{['f','o','o',],}",
+			   {.name = "foo",});
+	TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_prog_info, 0,
+"(struct bpf_prog_info){\n"
+"	.name = (char[16])[\n"
+"		'f',\n"
+"		'o',\n"
+"		'o',\n"
+"	],\n"
+"}",
+			   {.name = "foo",});
+	/* leading null char means do not display string */
+	TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_prog_info, BTF_F_COMPACT,
+			   "(struct bpf_prog_info){}",
+			   {.name = {'\0', 'f', 'o', 'o'}});
+	/* handle non-printable characters */
+	TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_prog_info, BTF_F_COMPACT,
+			   "(struct bpf_prog_info){.name = (char[16])[1,2,3,],}",
+			   { .name = {1, 2, 3, 0}});
+
+	/* struct with non-char array */
+	TEST_BTF_DUMP_DATA(btf, d, str, struct __sk_buff, BTF_F_COMPACT,
+			   "(struct __sk_buff){.cb = (__u32[5])[1,2,3,4,5,],}",
+			   { .cb = {1, 2, 3, 4, 5,},});
+	TEST_BTF_DUMP_DATA(btf, d, str, struct __sk_buff,
+			   BTF_F_COMPACT | BTF_F_NONAME,
+			   "{[1,2,3,4,5,],}",
+			   { .cb = { 1, 2, 3, 4, 5},});
+	TEST_BTF_DUMP_DATA(btf, d, str, struct __sk_buff, 0,
+"(struct __sk_buff){\n"
+"	.cb = (__u32[5])[\n"
+"		1,\n"
+"		2,\n"
+"		3,\n"
+"		4,\n"
+"		5,\n"
+"	],\n"
+"}",
+			   { .cb = { 1, 2, 3, 4, 5},});
+	/* For non-char, arrays, show non-zero values only */
+	TEST_BTF_DUMP_DATA(btf, d, str, struct __sk_buff, BTF_F_COMPACT,
+			   "(struct __sk_buff){.cb = (__u32[5])[0,0,1,0,0,],}",
+			   { .cb = { 0, 0, 1, 0, 0},});
+	TEST_BTF_DUMP_DATA(btf, d, str, struct __sk_buff, 0,
+"(struct __sk_buff){\n"
+"	.cb = (__u32[5])[\n"
+"		0,\n"
+"		0,\n"
+"		1,\n"
+"		0,\n"
+"		0,\n"
+"	],\n"
+"}",
+			   { .cb = { 0, 0, 1, 0, 0},});
+
+	/* struct with bitfields */
+	TEST_BTF_DUMP_DATA_C(btf, d, str, struct bpf_insn, BTF_F_COMPACT,
+		{.code = (__u8)1,.dst_reg = (__u8)0x2,.src_reg = (__u8)0x3,.off = (__s16)4,.imm = (__s32)5,});
+	TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_insn,
+			   BTF_F_COMPACT | BTF_F_NONAME,
+			   "{1,0x2,0x3,4,5,}",
+			   { .code = 1, .dst_reg = 0x2, .src_reg = 0x3, .off = 4,
+			     .imm = 5,});
+	TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_insn, 0,
+"(struct bpf_insn){\n"
+"	.code = (__u8)1,\n"
+"	.dst_reg = (__u8)0x2,\n"
+"	.src_reg = (__u8)0x3,\n"
+"	.off = (__s16)4,\n"
+"	.imm = (__s32)5,\n"
+"}",
+			   {.code = 1, .dst_reg = 2, .src_reg = 3, .off = 4, .imm = 5});
+
+	/* zeroed bitfields should not be displayed */
+	TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_insn, BTF_F_COMPACT,
+			   "(struct bpf_insn){.dst_reg = (__u8)0x1,}",
+			   { .code = 0, .dst_reg = 1});
+
+	/* struct with enum bitfield */
+	type_id = btf__find_by_name(btf, "fs_context");
+	if (CHECK(type_id <= 0, "find fs_context",
+		  "no 'struct fs_context' in BTF: %d\n", type_id))
+		return;
+	type_sz = btf__resolve_size(btf, type_id);
+	str[0] = '\0';
+
+	opts.emit_zeroes = true;
+	ret = btf_dump__dump_type_data(d, type_id, zero_data, type_sz, &opts);
+	if (CHECK(ret != type_sz,
+		  "dump fs_context is successful",
+		  "unexpected return value dumping fs_context '%s': %d\n",
+		  str, ret))
+		return;
+
+	if (CHECK(strstr(str, "FS_CONTEXT_FOR_MOUNT") == NULL,
+		  "verify enum value shown for bitfield",
+		  "bitfield value not present in '%s'\n", str))
+		return;
+
+	/* struct with nested anon union */
+	TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_sock_ops, BTF_F_COMPACT,
+			   "(struct bpf_sock_ops){.op = (__u32)1,(union){.args = (__u32[4])[1,2,3,4,],.reply = (__u32)1,.replylong = (__u32[4])[1,2,3,4,],},}",
+			   { .op = 1, .args = { 1, 2, 3, 4}});
+
+	/* union with nested struct */
+	TEST_BTF_DUMP_DATA(btf, d, str, union bpf_iter_link_info, BTF_F_COMPACT,
+			   "(union bpf_iter_link_info){.map = (struct){.map_fd = (__u32)1,},}",
+			   { .map = { .map_fd = 1 }});
+
+	/* struct skb with nested structs/unions; because type output is so
+	 * complex, we don't do a string comparison, just verify we return
+	 * the type size as the amount of data displayed.
+	 */
+	type_id = btf__find_by_name(btf, "sk_buff");
+	if (CHECK(type_id <= 0, "find type id",
+		  "no 'struct sk_buff' in BTF: %d\n", type_id))
+		return;
+	type_sz = btf__resolve_size(btf, type_id);
+	str[0] = '\0';
+
+	ret = btf_dump__dump_type_data(d, type_id, skb, type_sz, &opts);
+	if (CHECK(ret != type_sz,
+		  "dump sk_buff is successful",
+		  "unexpected return value dumping sk_buff '%s': %d\n",
+		  str, ret))
+		return;
+
+	/* overflow bpf_sock_ops struct with final element nonzero/zero.
+	 * Regardless of the value of the final field, we don't have all the
+	 * data we need to display it, so we should trigger an overflow.
+	 * In other words oveflow checking should trump "is field zero?"
+	 * checks because if we've overflowed, it shouldn't matter what the
+	 * field is - we can't trust its value so shouldn't display it.
+	 */
+	TEST_BTF_DUMP_DATA_OVER(btf, d, str, struct bpf_sock_ops,
+				sizeof(struct bpf_sock_ops) - 1,
+				"(struct bpf_sock_ops){\n\t.op = (__u32)1,\n",
+				{ .op = 1, .skb_tcp_flags = 2});
+	TEST_BTF_DUMP_DATA_OVER(btf, d, str, struct bpf_sock_ops,
+				sizeof(struct bpf_sock_ops) - 1,
+				"(struct bpf_sock_ops){\n\t.op = (__u32)1,\n",
+				{ .op = 1, .skb_tcp_flags = 0});
+}
+
+static void test_btf_dump_var_data(struct btf *btf, struct btf_dump *d,
+				   char *str)
+{
+	TEST_BTF_DUMP_VAR(btf, d, str, "cpu_number", int, BTF_F_COMPACT,
+			  "int cpu_number = (int)100", 100);
+	TEST_BTF_DUMP_VAR(btf, d, str, "cpu_profile_flip", int, BTF_F_COMPACT,
+			  "static int cpu_profile_flip = (int)2", 2);
+}
+
+static void test_btf_datasec(struct btf *btf, struct btf_dump *d, char *str,
+			     const char *name, const char *expected_val,
+			     void *data, size_t data_sz)
+{
+	DECLARE_LIBBPF_OPTS(btf_dump_type_data_opts, opts);
+	int ret = 0, cmp;
+	size_t secsize;
+	__s32 type_id;
+
+	opts.compact = true;
+
+	type_id = btf__find_by_name(btf, name);
+	if (CHECK(type_id <= 0, "find type id",
+		  "no '%s' in BTF: %d\n", name, type_id))
+		return;
+
+	secsize = btf__resolve_size(btf, type_id);
+	if (CHECK(secsize != 0, "verify section size",
+		  "unexpected section size %ld for %s\n", secsize, name))
+		return;
+
+	str[0] = '\0';
+	ret = btf_dump__dump_type_data(d, type_id, data, data_sz, &opts);
+	if (CHECK(ret != 0, "btf_dump__dump_type_data",
+		  "failed/unexpected return value: %d\n", ret))
+		return;
+
+	cmp = strcmp(str, expected_val);
+	if (CHECK(cmp, "ensure expected/actual match",
+		  "'%s' does not match expected '%s': %d\n",
+		  str, expected_val, cmp))
+		return;
+}
+
+static void test_btf_dump_datasec_data(char *str)
+{
+	struct btf *btf = btf__parse("xdping_kern.o", NULL);
+	struct btf_dump_opts opts = { .ctx = str };
+	char license[4] = "GPL";
+	struct btf_dump *d;
+
+	if (CHECK(!btf, "get prog BTF", "xdping_kern.o BTF not found"))
+		return;
+
+	d = btf_dump__new(btf, NULL, &opts, btf_dump_snprintf);
+
+	if (CHECK(!d, "new dump", "could not create BTF dump"))
+		return;
+
+	test_btf_datasec(btf, d, str, "license",
+			 "SEC(\"license\") char[4] _license = (char[4])['G','P','L',];",
+			 license, sizeof(license));
+}
+
 void test_btf_dump() {
+	char str[STRSIZE];
+	struct btf_dump_opts opts = { .ctx = str };
+	struct btf_dump *d;
+	struct btf *btf;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(btf_dump_test_cases); i++) {
@@ -245,4 +859,34 @@ void test_btf_dump() {
 	}
 	if (test__start_subtest("btf_dump: incremental"))
 		test_btf_dump_incremental();
+
+	btf = libbpf_find_kernel_btf();
+	if (CHECK(!btf, "get kernel BTF", "no kernel BTF found"))
+		return;
+
+	d = btf_dump__new(btf, NULL, &opts, btf_dump_snprintf);
+
+	if (CHECK(!d, "new dump", "could not create BTF dump"))
+		return;
+
+	/* Verify type display for various types. */
+	if (test__start_subtest("btf_dump: int_data"))
+		test_btf_dump_int_data(btf, d, str);
+	if (test__start_subtest("btf_dump: float_data"))
+		test_btf_dump_float_data(btf, d, str);
+	if (test__start_subtest("btf_dump: char_data"))
+		test_btf_dump_char_data(btf, d, str);
+	if (test__start_subtest("btf_dump: typedef_data"))
+		test_btf_dump_typedef_data(btf, d, str);
+	if (test__start_subtest("btf_dump: enum_data"))
+		test_btf_dump_enum_data(btf, d, str);
+	if (test__start_subtest("btf_dump: struct_data"))
+		test_btf_dump_struct_data(btf, d, str);
+	if (test__start_subtest("btf_dump: var_data"))
+		test_btf_dump_var_data(btf, d, str);
+	btf_dump__free(d);
+	btf__free(btf);
+
+	if (test__start_subtest("btf_dump: datasec_data"))
+		test_btf_dump_datasec_data(str);
 }
-- 
1.8.3.1

