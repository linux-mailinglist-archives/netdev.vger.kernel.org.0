Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5340239759B
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 16:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234370AbhFAOjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 10:39:25 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:22278 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234196AbhFAOjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 10:39:13 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 151EaMon004342;
        Tue, 1 Jun 2021 14:37:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=NYvatjM0P88ZSOnu2ejnKwGSA0ClCErrLV2Eod9ddjQ=;
 b=nlPLkfDktlLfTOaWCv5dClD5UuoPGWO9jnQGS3Z0pzYczjle5f6nkNUCSaIOuna9D51S
 Jx/ZJ8FCz0CtKkNOdvBGqExJqrVA5X5XFnbM4H6oAXo9/CNLUO/l6S92D3aE24Wq/JkB
 WBT72j3beLbFw8nIRvP7oyE2xFnC1qYiYltsZb9ivpr+AoqgYVldiDUoqGknKzIwZE9a
 uhudJY9/VXRInlaTVAgPJrKaT9+2+qLmn3Mkd+uqRQ8kos4UMmALPjovLVWLPM7R0U5R
 0/BNgFpuM8hdDDPY9V+5BnGxmoiA2kJfmvtv+zR7Z3qWmRcFBGjS42u1olr7K71lSHo+ dA== 
Received: from oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 38vj1krnf7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Jun 2021 14:37:15 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 151EbEk2139147;
        Tue, 1 Jun 2021 14:37:14 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by aserp3030.oracle.com with ESMTP id 38ubnd7wa3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Jun 2021 14:37:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Udn5lLj0vL/p4D8myxpYN7z3RyD5IEao0DcXt+boM5HdWm+mnQy0X/yQ77mO39TZ0GRWpXWxQQYX1/sURMCOqx+R8eo7OwB61o2A+iLtQtifaxNOxzOk/RUfRfR14uWXtEzL2o1z9Mrg9/e2nst2pqFDVJXUGSA4A/NF2vVE2APlQ6zLaJH/ezxPendt1aKoEhd+CpSWGjhLywfVBJLQqtfaP3ujdZKl7rnUx/T9FWr9Bjid1UMfLyhJTq1Q4SigmxiXxDkcfFhVo6qJg/p5Px33w2lkxFkDSmADY/3CsQ/uQxLOaCSKbSoKHBje0CvNOtStOA/NrFMe3w+xc0ukbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NYvatjM0P88ZSOnu2ejnKwGSA0ClCErrLV2Eod9ddjQ=;
 b=UdfXsbNSE0UaUb+9Fc/b8QmpUCOatoYBd4OI7j//IBgJhPgCuh8q2otBWHeW8JdrNFFnDklgDRbs+dYgHC5YcvL9Jc19GEg164GfShBO3QGIIYasku5zeu5pHaKbhZN1FFgjFfKyzMey+vYVIAe0W4Ogy/znRi8Tfsd4KGqIf7I2aSNn+ALV+rNFSnBrr35NEG/7s2TCSg+QyYDfeVKAn5Kv90A1r23P0nkZe1uSXB4rhQdavMGL/oJv+oFjwzIV3jMbd4NCmpT4OxQBX3Tr91pBqzfV+Y7s5fv3aV81QXyEKD7oudnlOb4SbCK+z1cMaF650ef6bidBc9hgrX0p8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NYvatjM0P88ZSOnu2ejnKwGSA0ClCErrLV2Eod9ddjQ=;
 b=JuD+z39snqQWE7tZJEUuOcQhv4qr3BimwpihZfOE1xsfZVB0nSoOVyFyU3h5pCIRw63FZQZ2EJTfnB4OyTDgRq0FnUkr2fmWZHDJpvKUq99Dur/thDihrC08WK6p+H7yzxSrWpMGd7a4YgsbM3gm48kTBXif17z7Zl81Mo7anyM=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by MN2PR10MB3743.namprd10.prod.outlook.com (2603:10b6:208:11e::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Tue, 1 Jun
 2021 14:37:11 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::9da7:f131:1f41:657c]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::9da7:f131:1f41:657c%4]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 14:37:11 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v4 bpf-next 2/2] selftests/bpf: add dump type data tests to btf dump tests
Date:   Tue,  1 Jun 2021 15:37:00 +0100
Message-Id: <1622558220-2849-3-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622558220-2849-1-git-send-email-alan.maguire@oracle.com>
References: <1622558220-2849-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-Originating-IP: [95.45.14.174]
X-ClientProxiedBy: LO2P265CA0461.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::17) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.uk.oracle.com (95.45.14.174) by LO2P265CA0461.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a2::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Tue, 1 Jun 2021 14:37:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30b11200-03b6-47ef-2e41-08d9250abd78
X-MS-TrafficTypeDiagnostic: MN2PR10MB3743:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB3743B0F423745E89678887BAEF3E9@MN2PR10MB3743.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bp9POybW74OqQxVykT9EeKWzSVqTl2QNsSSIFT5cQERMVT0n9nBp8v8ilfZgSG/M3polaLk/dRMJkJBLvjVmQOlbgiNosuJ6DHQoS3Jc8EOoU2q0pFJe4ivxvVEK7hcYEDO/KhhXindzfsUgoem+3MWdGX7LTiLnjgT44jyD7Ur90ZH+COTsnECHF01fbZ0h5+sJnBkZ+eIeYoeiMdvdFBQjXsguiyl0+ZHQIUCXe7St8uu9G14E//gDNQOAov6+PLBtQvg7Su7wiS5sQELvwFqskuK8JuH+xn5AFVSfKSwSLOw8r+J3p7RSf1WhehazaCFo9q5jRRYIjLUtYDggNkEfHgjf24Ga9fjOsLsq5z7GDEFI0LpuP3OPXBLqfp2S+51H0318vLA1FzT6Ef2NET5QkyH+d6A14eQnG3TOEFihtEcc7cdsT4mz8Ap3UxMG/agiIbs3srwVr5Den+/R1+KfrWvenj0sz9HWEJY+OPr1GUi4ocBhsYBvQJ7/g4NSY9WetGOtmR3VCcGEMsuTw/XtrktuwrPV8X3Gre/Bei+IzdGqV0/FLsJn2Qq1N6eC0zh/7H1cxNjwxzKZvadhg3PXrBe0mZw8hJWW08MOG12VgyucOMwJKjR4rdUHpCLIouD3UUymlXzPlHJ2s16aGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(346002)(376002)(39850400004)(5660300002)(52116002)(7696005)(36756003)(26005)(38350700002)(44832011)(30864003)(7416002)(956004)(8936002)(83380400001)(8676002)(38100700002)(2616005)(66556008)(86362001)(186003)(6486002)(4326008)(6666004)(107886003)(2906002)(316002)(66946007)(478600001)(16526019)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?T9Qd+OStzHcB+IpCyJIw1xyvXlj04+t7JOLCtbd4k1SKjy54ku9sAQ1SlUaQ?=
 =?us-ascii?Q?LyJi0/seXBu7K6EkybdNqvaqMOpiBazEBqbwMLFcwaFdo+O4D1Ul/8AnkWoj?=
 =?us-ascii?Q?WNvWmU0qG/GmteMenH9ugH6MTtWB5TmTpBSQhxp2+3f99duZVI7ykjEeTbkB?=
 =?us-ascii?Q?tzBZQ7LDqsQNDHkXK11yLWHyI5ECFlISod5Eca9vjhSnIWYgWOPWBeOjE83b?=
 =?us-ascii?Q?XND8Ho7av1JTF4s9G34IV44chbzWv+kvgdJk7utjwSeeJbdEuJPYre1y2oqy?=
 =?us-ascii?Q?M9COSHKFpa++dA4W7m2kJ5Ci00V1GFGX6A/TieyT1h/7bhtbx+dr/M6N4OV4?=
 =?us-ascii?Q?HQLGpuwY+NVL3LUXoAwS/SpxHfetgBY7+dAKZH66f5fLywQCyjjHOmWWpcfj?=
 =?us-ascii?Q?dzURnlv+2KjxbYHGfyOYZ4h2XSB5YJ9AfxT/tTBZ3rf+qQ+VyGn7HmIvaAJp?=
 =?us-ascii?Q?7x4nwU+6UzKuVjkN1m72QB6RQYWOdDrY9wtpyqaxLMWG9Q+kVpsA1/Pn9q8D?=
 =?us-ascii?Q?9kHeD2wxDx/pqUDygI1fyyILzqbb6ji+mKeb/8xoHN988FtP6L1RQT0345lI?=
 =?us-ascii?Q?5Zyb3CLH1T3oyLtsbanUFFEyWEeQmx5o36dUuYcuKzSC3F2tN9dZoCySIlEv?=
 =?us-ascii?Q?TcNX0vxB3RAUaC0QEH22X/KFC+PduyV8dbBxKHxvd2tib2Aft6Q6BGN59Nmd?=
 =?us-ascii?Q?Z+HpmzZODUzKc/Fa/LIbGOP3WQQshZJNgONz0RLsxppgY6iFcC7w5YlzugjO?=
 =?us-ascii?Q?1AFEJ6laR9tRHXmuWgDJQWmnH6P9uW7Zln2SSxAh8K7+fJE1dVtavYlIiOjI?=
 =?us-ascii?Q?uR/yXhsJED99aYrgWVYaKsaSGvxKlGkMvEd15JxmCaAVe5Nevudoab+QNOT/?=
 =?us-ascii?Q?azMQgsO3d+/UUq/NiTPO7qaAhWlB0+LP74xcihx4D757vfzWkRAtC3sVh12i?=
 =?us-ascii?Q?4zuN++7fALTQfhNTD5phkyYVGXGG4feRc5kQYN6GLQ/Xm/QgHvIy9S7wYn7f?=
 =?us-ascii?Q?ZV0JigqYDsXbAwcqmVCSeEE/ob6SJXpYzymFKGsnbFWTxB25FC7BOJ5gYfoA?=
 =?us-ascii?Q?wuL8xecr7owdtLW6NJv5FwM0lWZIsW/u70hK8e5za5aL5cxe95jO6rNtliTo?=
 =?us-ascii?Q?5oejBrHOktNQgwikmD7ZyiodXOk1FFG03APT/2vhADQKWoS64/oXo0OxNGRa?=
 =?us-ascii?Q?yONRPDOC+bCnd8WlFZvqXq5pcXO58bT7ZBti7km9MHgNWWxR/xaNGfQiavIm?=
 =?us-ascii?Q?Q6KG/FP3rcWexH4//ppojoPNC1b3ftErXUQxduhryoEswSnH/pu3YQB5+kDJ?=
 =?us-ascii?Q?c9zlgrnmcg94EaAq4LM2rxs9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30b11200-03b6-47ef-2e41-08d9250abd78
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2021 14:37:10.9740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lcFjjAxqDTO9EKoHly7hbrL7Wq4ywGDwZrRYzVOMaHIxxZOcWONBkywlLei+I8d8ZO/4arvXuraq3UBGH4T9Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3743
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 spamscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106010099
X-Proofpoint-ORIG-GUID: LBT09FMLALeQs12KAHprPyikRT0yEW9W
X-Proofpoint-GUID: LBT09FMLALeQs12KAHprPyikRT0yEW9W
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
 tools/testing/selftests/bpf/prog_tests/btf_dump.c | 638 ++++++++++++++++++++++
 1 file changed, 638 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dump.c b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
index 1b90e68..b78c308 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_dump.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
@@ -232,6 +232,642 @@ void test_btf_dump_incremental(void)
 	btf__free(btf);
 }
 
+#define STRSIZE				4096
+
+void btf_dump_snprintf(void *ctx, const char *fmt, va_list args)
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
+int btf_dump_data(struct btf *btf, struct btf_dump *d,
+		  char *name, __u64 flags, void *ptr,
+		  size_t ptrsize, char *str, const char *expectedval)
+{
+	DECLARE_LIBBPF_OPTS(btf_dump_type_data_opts, opts);
+	int ret = 0, cmp;
+	size_t typesize;
+	__s32 type_id;
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
+	if (CHECK(type_id <= 0, "find type id",
+		  "no '%s' in BTF: %d\n", name, type_id)) {
+		ret = -ENOENT;
+		goto err;
+	}
+	typesize = btf__resolve_size(btf, type_id);
+	str[0] = '\0';
+	ret = btf_dump__dump_type_data(d, type_id, ptr, ptrsize, &opts);
+	if (typesize <= ptrsize) {
+		if (CHECK(ret != typesize, "btf_dump__dump_type_data",
+			  "failed/unexpected typesize: %d\n", ret))
+			goto err;
+	} else {
+		if (CHECK(ret != -E2BIG, "btf_dump__dump_type_data -E2BIG",
+			  "failed to return -E2BIG: %d\n", ret))
+			goto err;
+		ret = 0;
+	}
+
+	cmp = strcmp(str, expectedval);
+	if (CHECK(cmp, "ensure expected/actual match",
+		  "'%s' does not match expected '%s': %d\n",
+		  str, expectedval, cmp))
+		ret = -EFAULT;
+err:
+	if (ret < 0)
+		btf_dump__free(d);
+	return ret;
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
+			return _err;					\
+	} while (0)
+
+/* Use where expected data string matches its stringified declaration */
+#define TEST_BTF_DUMP_DATA_C(_b, _d, _str, _type, _flags, ...)		\
+	TEST_BTF_DUMP_DATA(_b, _d, _str, _type, _flags,			\
+			   "(" #_type ")" #__VA_ARGS__,	__VA_ARGS__)
+
+/* overflow test; pass typesize < expected type size, ensure E2BIG returned */
+#define TEST_BTF_DUMP_DATA_OVER(_b, _d, _str, _type, _typesize, _expected, ...)\
+	do {								\
+		char __ptrtype[64] = #_type;				\
+		char *_ptrtype = (char *)__ptrtype;			\
+		_type _ptrdata = __VA_ARGS__;				\
+		void *_ptr = &_ptrdata;					\
+		int _err;						\
+									\
+		_err = btf_dump_data(_b, _d, _ptrtype, 0, _ptr,		\
+				     _typesize, _str, _expected);	\
+		if (_err < 0)						\
+			return _err;					\
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
+			return _err;					\
+	} while (0)
+
+int test_btf_dump_int_data(struct btf *btf, struct btf_dump *d, char *str)
+{
+	/* simple int */
+	TEST_BTF_DUMP_DATA_C(btf, d, str, int, BTF_F_COMPACT, 1234);
+	TEST_BTF_DUMP_DATA(btf, d, str, int, BTF_F_COMPACT | BTF_F_NONAME,
+			   "1234", 1234);
+	TEST_BTF_DUMP_DATA(btf, d, str, int, 0, "(int)1234\n", 1234);
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
+	TEST_BTF_DUMP_DATA(btf, d, str, int, 0, "(int)-4567\n", -4567);
+
+	TEST_BTF_DUMP_DATA_OVER(btf, d, str, int, sizeof(int)-1, "", 1);
+
+	return 0;
+}
+
+/* since the kernel does not likely have any float types in its BTF, we
+ * will need to add some of various sizes.
+ */
+#define TEST_ADD_FLOAT(_btf, _name, _sz)				\
+	do {								\
+		int _err;						\
+									\
+		_err = btf__add_float(_btf, _name, _sz);		\
+		if (CHECK(_err < 0, "btf__add_float",			\
+			  "could not add float of size %d: %d",		\
+			  _sz, _err))					\
+			return _err;					\
+	} while (0)
+
+#define TEST_DUMP_FLOAT(_b, _d, _str, _type, _flags, _data, _sz,	\
+			_expectedval)					\
+	do {								\
+		int _err;						\
+									\
+		_err = btf_dump_data(_b, _d, _type, _flags,		\
+				     _data, _sz, _str, _expectedval);	\
+		if (CHECK(_err < 0, "btf_dump float",			\
+			  "could not dump float data: %d\n", _err))	\
+			return _err;					\
+	} while (0)
+
+int test_btf_dump_float_data(struct btf *btf, struct btf_dump *d, char *str)
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
+	TEST_ADD_FLOAT(btf, "test_float", 4);
+	TEST_DUMP_FLOAT(btf, d, str, "test_float", 0, &t1, 4,
+			"(test_float)1.234567\n");
+	TEST_DUMP_FLOAT(btf, d, str, "test_float", 0, &t2, 4,
+			"(test_float)-1.234567\n");
+	TEST_DUMP_FLOAT(btf, d, str, "test_float", 0, &t3, 4,
+			"(test_float)0.000000\n");
+
+	TEST_ADD_FLOAT(btf, "test_double", 8);
+	TEST_DUMP_FLOAT(btf, d, str, "test_double", 0, &t4, 8,
+			"(test_double)5.678912\n");
+	TEST_DUMP_FLOAT(btf, d, str, "test_double", 0, &t5, 8,
+			"(test_double)-5.678912\n");
+	TEST_DUMP_FLOAT(btf, d, str, "test_double", 0, &t6, 8,
+			"(test_double)0.000000\n");
+
+	TEST_ADD_FLOAT(btf, "test_long_double", 16);
+	TEST_DUMP_FLOAT(btf, d, str, "test_long_double", 0, &t7, 16,
+			"(test_long_double)9.876543\n");
+	TEST_DUMP_FLOAT(btf, d, str, "test_long_double", 0, &t8, 16,
+			"(test_long_double)-9.876543\n");
+	TEST_DUMP_FLOAT(btf, d, str, "test_long_double", 0, &t9, 16,
+			"(test_long_double)0.000000\n");
+
+	return 0;
+}
+
+int test_btf_dump_char_data(struct btf *btf, struct btf_dump *d, char *str)
+{
+	/* simple char */
+	TEST_BTF_DUMP_DATA_C(btf, d, str, char, BTF_F_COMPACT, 100);
+	TEST_BTF_DUMP_DATA(btf, d, str, char, BTF_F_COMPACT | BTF_F_NONAME,
+			   "100", 100);
+	TEST_BTF_DUMP_DATA(btf, d, str, char, 0, "(char)100\n", 100);
+	/* zero value should be printed at toplevel */
+	TEST_BTF_DUMP_DATA(btf, d, str, char, BTF_F_COMPACT, "(char)0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, str, char, BTF_F_COMPACT | BTF_F_NONAME,
+			   "0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, str, char, BTF_F_COMPACT | BTF_F_ZERO,
+			   "(char)0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, str, char,
+			   BTF_F_COMPACT | BTF_F_NONAME | BTF_F_ZERO,
+			   "0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, str, char, 0, "(char)0\n", 0);
+
+	TEST_BTF_DUMP_DATA_OVER(btf, d, str, char, sizeof(char)-1, "", 100);
+
+	return 0;
+}
+
+int test_btf_dump_typedef_data(struct btf *btf, struct btf_dump *d, char *str)
+{
+	/* simple typedef */
+	TEST_BTF_DUMP_DATA_C(btf, d, str, uint64_t, BTF_F_COMPACT, 100);
+	TEST_BTF_DUMP_DATA(btf, d, str, u64, BTF_F_COMPACT | BTF_F_NONAME,
+			   "1", 1);
+	TEST_BTF_DUMP_DATA(btf, d, str, u64, 0, "(u64)1\n", 1);
+	/* zero value should be printed at toplevel */
+	TEST_BTF_DUMP_DATA(btf, d, str, u64, BTF_F_COMPACT, "(u64)0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, str, u64, BTF_F_COMPACT | BTF_F_NONAME,
+			   "0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, str, u64, BTF_F_COMPACT | BTF_F_ZERO,
+			   "(u64)0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, str, u64,
+			   BTF_F_COMPACT | BTF_F_NONAME | BTF_F_ZERO,
+			   "0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, str, u64, 0, "(u64)0\n", 0);
+
+	/* typedef struct */
+	TEST_BTF_DUMP_DATA_C(btf, d, str, atomic_t, BTF_F_COMPACT,
+			     {.counter = (int)1,});
+	TEST_BTF_DUMP_DATA(btf, d, str, atomic_t, BTF_F_COMPACT | BTF_F_NONAME,
+			   "{1,}", { .counter = 1 });
+	TEST_BTF_DUMP_DATA(btf, d, str, atomic_t, 0,
+			   "(atomic_t){\n\t.counter = (int)1,\n}\n",
+			   {.counter = 1,});
+	/* typedef with 0 value should be printed at toplevel */
+	TEST_BTF_DUMP_DATA(btf, d, str, atomic_t, BTF_F_COMPACT, "(atomic_t){}",
+			   {.counter = 0,});
+	TEST_BTF_DUMP_DATA(btf, d, str, atomic_t, BTF_F_COMPACT | BTF_F_NONAME,
+			   "{}", {.counter = 0,});
+	TEST_BTF_DUMP_DATA(btf, d, str, atomic_t, 0,
+			   "(atomic_t){\n}\n", {.counter = 0,});
+	TEST_BTF_DUMP_DATA(btf, d, str, atomic_t, BTF_F_COMPACT | BTF_F_ZERO,
+			   "(atomic_t){.counter = (int)0,}",
+			   {.counter = 0,});
+	TEST_BTF_DUMP_DATA(btf, d, str, atomic_t,
+			   BTF_F_COMPACT | BTF_F_NONAME | BTF_F_ZERO,
+			   "{0,}", {.counter = 0,});
+	TEST_BTF_DUMP_DATA(btf, d, str, atomic_t, BTF_F_ZERO,
+			   "(atomic_t){\n\t.counter = (int)0,\n}\n",
+			   { .counter = 0,});
+
+	/* overflow should show type but not value since it overflows */
+	TEST_BTF_DUMP_DATA_OVER(btf, d, str, atomic_t, sizeof(atomic_t)-1,
+				"(atomic_t){\n", { .counter = 1});
+
+	return 0;
+}
+
+int test_btf_dump_enum_data(struct btf *btf, struct btf_dump *d, char *str)
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
+			   "(enum bpf_cmd)BPF_MAP_CREATE\n",
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
+			   "(enum bpf_cmd)2000\n", 2000);
+
+	TEST_BTF_DUMP_DATA_OVER(btf, d, str, enum bpf_cmd,
+				sizeof(enum bpf_cmd) - 1, "", BPF_MAP_CREATE);
+
+	return 0;
+}
+
+int test_btf_dump_struct_data(struct btf *btf, struct btf_dump *d, char *str)
+{
+	DECLARE_LIBBPF_OPTS(btf_dump_type_data_opts, opts);
+	char zerodata[512] = { 0 };
+	char typedata[512];
+	void *fops = typedata;
+	void *skb = typedata;
+	size_t typesize;
+	__s32 type_id;
+	int ret, cmp;
+	char *cmpstr;
+
+	memset(typedata, 255, sizeof(typedata));
+
+	/* simple struct */
+	TEST_BTF_DUMP_DATA_C(btf, d, str, struct btf_enum, BTF_F_COMPACT,
+			     {.name_off = (__u32)3,.val = (__s32)-1,});
+	TEST_BTF_DUMP_DATA(btf, d, str, struct btf_enum,
+			   BTF_F_COMPACT | BTF_F_NONAME,
+			   "{3,-1,}",
+			   { .name_off = 3, .val = -1,});
+	TEST_BTF_DUMP_DATA(btf, d, str, struct btf_enum, 0,
+			   "(struct btf_enum){\n\t.name_off = (__u32)3,\n\t.val = (__s32)-1,\n}\n",
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
+			   "(struct btf_enum){\n}\n",
+			   { .name_off = 0, .val = 0,});
+	TEST_BTF_DUMP_DATA(btf, d, str, struct btf_enum,
+			   BTF_F_COMPACT | BTF_F_ZERO,
+			   "(struct btf_enum){.name_off = (__u32)0,.val = (__s32)0,}",
+			   { .name_off = 0, .val = 0,});
+	TEST_BTF_DUMP_DATA(btf, d, str, struct btf_enum,
+			   BTF_F_ZERO,
+			   "(struct btf_enum){\n\t.name_off = (__u32)0,\n\t.val = (__s32)0,\n}\n",
+			   { .name_off = 0, .val = 0,});
+
+	/* struct with pointers */
+	TEST_BTF_DUMP_DATA(btf, d, str, struct list_head, BTF_F_COMPACT,
+			   "(struct list_head){.next = (struct list_head *)0x1,}",
+			   { .next = (struct list_head *)1 });
+	TEST_BTF_DUMP_DATA(btf, d, str, struct list_head, 0,
+			   "(struct list_head){\n\t.next = (struct list_head *)0x1,\n}\n",
+			   { .next = (struct list_head *)1 });
+	/* NULL pointer should not be displayed */
+	TEST_BTF_DUMP_DATA(btf, d, str, struct list_head, BTF_F_COMPACT,
+			   "(struct list_head){}",
+			   { .next = (struct list_head *)0 });
+	TEST_BTF_DUMP_DATA(btf, d, str, struct list_head, 0,
+			   "(struct list_head){\n}\n",
+			   { .next = (struct list_head *)0 });
+
+	/* struct with function pointers */
+	type_id = btf__find_by_name(btf, "file_operations");
+	if (CHECK(type_id <= 0, "find type id",
+		  "no 'struct file_operations' in BTF: %d\n", type_id))
+		return -ENOENT;
+	typesize = btf__resolve_size(btf, type_id);
+	str[0] = '\0';
+
+	ret = btf_dump__dump_type_data(d, type_id, fops, typesize, &opts);
+	if (CHECK(ret != typesize,
+		  "dump file_operations is successful",
+		  "unexpected return value dumping file_operations '%s': %d\n",
+		  str, ret))
+		return -EINVAL;
+
+	cmpstr = "(struct file_operations){\n\t.owner = (struct module *)0xffffffffffffffff,\n\t.llseek = (loff_t(*)(struct file *, loff_t, int))0xffffffffffffffff,";
+	cmp = strncmp(str, cmpstr, strlen(cmpstr));
+	if (CHECK(cmp != 0, "check file_operations dump",
+		  "file_operations '%s' did not match expected\n",
+		  str))
+		return -EINVAL;
+
+	/* struct with char array */
+	TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_prog_info, BTF_F_COMPACT,
+			   "(struct bpf_prog_info){.name = (char[])['f','o','o',],}",
+			   { .name = "foo",});
+	TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_prog_info,
+			   BTF_F_COMPACT | BTF_F_NONAME,
+			   "{['f','o','o',],}",
+			   {.name = "foo",});
+	TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_prog_info, 0,
+			   "(struct bpf_prog_info){\n\t.name = (char[])[\n\t\t'f',\n\t\t\'o',\n\t\t'o',\n\t],\n}\n",
+			   {.name = "foo",});
+	/* leading null char means do not display string */
+	TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_prog_info, BTF_F_COMPACT,
+			   "(struct bpf_prog_info){}",
+			   {.name = {'\0', 'f', 'o', 'o'}});
+	/* handle non-printable characters */
+	TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_prog_info, BTF_F_COMPACT,
+			   "(struct bpf_prog_info){.name = (char[])[1,2,3,],}",
+			   { .name = {1, 2, 3, 0}});
+
+	/* struct with non-char array */
+	TEST_BTF_DUMP_DATA(btf, d, str, struct __sk_buff, BTF_F_COMPACT,
+			   "(struct __sk_buff){.cb = (__u32[])[1,2,3,4,5,],}",
+			   { .cb = {1, 2, 3, 4, 5,},});
+	TEST_BTF_DUMP_DATA(btf, d, str, struct __sk_buff,
+			   BTF_F_COMPACT | BTF_F_NONAME,
+			   "{[1,2,3,4,5,],}",
+			   { .cb = { 1, 2, 3, 4, 5},});
+	TEST_BTF_DUMP_DATA(btf, d, str, struct __sk_buff, 0,
+			   "(struct __sk_buff){\n\t.cb = (__u32[])[\n\t\t1,\n\t\t2,\n\t\t3,\n\t\t4,\n\t\t5,\n\t],\n}\n",
+			   { .cb = { 1, 2, 3, 4, 5},});
+	/* For non-char, arrays, show non-zero values only */
+	TEST_BTF_DUMP_DATA(btf, d, str, struct __sk_buff, BTF_F_COMPACT,
+			   "(struct __sk_buff){.cb = (__u32[])[0,0,1,0,0,],}",
+			   { .cb = { 0, 0, 1, 0, 0},});
+	TEST_BTF_DUMP_DATA(btf, d, str, struct __sk_buff, 0,
+			   "(struct __sk_buff){\n\t.cb = (__u32[])[\n\t\t0,\n\t\t0,\n\t\t1,\n\t\t0,\n\t\t0,\n\t],\n}\n",
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
+			   "(struct bpf_insn){\n\t.code = (__u8)1,\n\t.dst_reg = (__u8)0x2,\n\t.src_reg = (__u8)0x3,\n\t.off = (__s16)4,\n\t.imm = (__s32)5,\n}\n",
+			   {.code = 1, .dst_reg = 2, .src_reg = 3, .off = 4, .imm = 5});
+
+	/* zeroed bitfields should not be displayed */
+	TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_insn, BTF_F_COMPACT,
+			   "(struct bpf_insn){.dst_reg = (__u8)0x1,}",
+			   { .code = 0, .dst_reg = 1});
+
+	/* struct with enum bitfield */
+	type_id = btf__find_by_name(btf, "nft_cmp_expr");
+	if (CHECK(type_id <= 0, "find nft_cmp_expr",
+		  "no 'struct nft_cmp_expr' in BTF: %d\n", type_id))
+		return -ENOENT;
+	typesize = btf__resolve_size(btf, type_id);
+	str[0] = '\0';
+
+	opts.emit_zeroes = true;
+	ret = btf_dump__dump_type_data(d, type_id, zerodata, typesize, &opts);
+	if (CHECK(ret != typesize,
+		  "dump nft_cmp_expr is successful",
+		  "unexpected return value dumping nft_cmp_expr '%s': %d\n",
+		  str, ret))
+		return -EINVAL;
+
+	if (CHECK(strstr(str, "NFT_CMP_EQ") == NULL,
+		  "verify enum value shown for bitfield",
+		  "bitfield value not present in '%s'\n", str))
+		return -EINVAL;
+
+	/* struct with nested anon union */
+	TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_sock_ops, BTF_F_COMPACT,
+			   "(struct bpf_sock_ops){.op = (__u32)1,(union){.args = (__u32[])[1,2,3,4,],.reply = (__u32)1,.replylong = (__u32[])[1,2,3,4,],},}",
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
+		return -ENOENT;
+	typesize = btf__resolve_size(btf, type_id);
+	str[0] = '\0';
+
+	ret = btf_dump__dump_type_data(d, type_id, skb, typesize, &opts);
+	if (CHECK(ret != typesize,
+		  "dump sk_buff is successful",
+		  "unexpected return value dumping sk_buff '%s': %d\n",
+		  str, ret))
+		return -EINVAL;
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
+
+	return 0;
+}
+
+int test_btf_dump_var_data(struct btf *btf, struct btf_dump *d, char *str)
+{
+
+	TEST_BTF_DUMP_VAR(btf, d, str, "cpu_number", int, BTF_F_COMPACT,
+			  "int cpu_number = (int)100", 100);
+	TEST_BTF_DUMP_VAR(btf, d, str, "cpu_profile_flip", int, BTF_F_COMPACT,
+			  "static int cpu_profile_flip = (int)2", 2);
+
+	return 0;
+}
+
+int test_btf_datasec(struct btf *btf, struct btf_dump *d, char *str,
+		     const char *name, const char *expectedval,
+		     void *data, size_t data_sz)
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
+		return -ENOENT;
+
+	secsize = btf__resolve_size(btf, type_id);
+	if (CHECK(secsize != 0, "verify section size",
+		  "unexpected section size %ld for %s\n", secsize, name))
+		return -EINVAL;
+
+	str[0] = '\0';
+	ret = btf_dump__dump_type_data(d, type_id, data, data_sz, &opts);
+	if (CHECK(ret != 0, "btf_dump__dump_type_data",
+		  "failed/unexpected return value: %d\n", ret))
+		return ret;
+
+	cmp = strcmp(str, expectedval);
+	if (CHECK(cmp, "ensure expected/actual match",
+		  "'%s' does not match expected '%s': %d\n",
+		  str, expectedval, cmp))
+		ret = -EFAULT;
+
+	return ret;
+}
+
+int test_btf_dump_datasec_data(char *str)
+{
+	struct btf *btf = btf__parse("xdping_kern.o", NULL);
+	struct btf_dump_opts opts = { .ctx = str };
+	char license[4] = "GPL";
+	struct btf_dump *d;
+
+	if (CHECK(!btf, "get prog BTF", "xdping_kern.o BTF not found"))
+		return -ENOENT;
+
+	d = btf_dump__new(btf, NULL, &opts, btf_dump_snprintf);
+
+	if (CHECK(!d, "new dump", "could not create BTF dump"))
+		return -ENOENT;
+
+	if (test_btf_datasec(btf, d, str, "license",
+			     "SEC(\"license\") char[] _license = (char[])['G','P','L',];",
+			     license, sizeof(license)))
+		return -EINVAL;
+
+	return 0;
+}
+
+void test_btf_dump_data(void)
+{
+	struct btf *btf = libbpf_find_kernel_btf();
+	char str[STRSIZE];
+	struct btf_dump_opts opts = { .ctx = str };
+	struct btf_dump *d;
+
+	if (CHECK(!btf, "get kernel BTF", "no kernel BTF found"))
+		return;
+
+	d = btf_dump__new(btf, NULL, &opts, btf_dump_snprintf);
+
+	if (CHECK(!d, "new dump", "could not create BTF dump"))
+		return;
+
+	/* Verify type display for various types. */
+	if (test_btf_dump_int_data(btf, d, str))
+		return;
+	if (test_btf_dump_float_data(btf, d, str))
+		return;
+	if (test_btf_dump_char_data(btf, d, str))
+		return;
+	if (test_btf_dump_typedef_data(btf, d, str))
+		return;
+	if (test_btf_dump_enum_data(btf, d, str))
+		return;
+	if (test_btf_dump_struct_data(btf, d, str))
+		return;
+	if (test_btf_dump_var_data(btf, d, str))
+		return;
+	btf_dump__free(d);
+	btf__free(btf);
+
+	/* verify datasec display */
+	if (test_btf_dump_datasec_data(str))
+		return;
+
+}
+
 void test_btf_dump() {
 	int i;
 
@@ -245,4 +881,6 @@ void test_btf_dump() {
 	}
 	if (test__start_subtest("btf_dump: incremental"))
 		test_btf_dump_incremental();
+	if (test__start_subtest("btf_dump: data"))
+		test_btf_dump_data();
 }
-- 
1.8.3.1

