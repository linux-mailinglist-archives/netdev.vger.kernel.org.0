Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D41F839330A
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 18:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236281AbhE0QBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 12:01:41 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:7018 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236175AbhE0QBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 12:01:36 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14RFrC7B029677;
        Thu, 27 May 2021 15:59:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=bzyGroclyWM6w8NgXnKGFDYHcB6URqz/lsWdMD4H/sU=;
 b=jAPCo5mN37lZF5AIBaVyquwWAYSeZSfg8/4IBaWUb/Nxf7/Zm78wlHjHatrAyixvWLtk
 +1YSVhAwzEnR0vPKW81l6Y4CluFL4ncCT2/a4+72CKWj720uRv9QEdnYT+DvLsAba7Eo
 XBX0lf9dqOD1WlDxzHfCdr33rcc8+U6jcsBnZgriQy1+0ZrzHvMw4b+UXpfdYOFpiMRm
 iWdIP7zPi50jFIgQ6nhTaY78qK2xuas9sQbDHq57h4OFGl3gtBkfSaE6l7fn+fXMs68U
 np63lKKAZptgh+UrbqjKPuUy/r0bzF314gOYyG4JkXCvCUUZtYmkewQ4NhPgqUETd1YM PQ== 
Received: from oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 38sppd0g7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 May 2021 15:59:46 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14RFsdbr088492;
        Thu, 27 May 2021 15:59:45 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by userp3020.oracle.com with ESMTP id 38qbqufct5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 May 2021 15:59:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TDPu9P0Sz7Nydy2n4U49VVBoGjAVbIqV4ZZ8gOhN21qiKI8jPtApEzQjmZSP+kNOPU1UHm6WhJgqCwfr+Rsb1H0noqnZR950FcTn+JmJi+BO1w2kQhjJE/18l3KMR3oIM6lv3FyB81g37WD20wLmHyywpFEAjbgOjTqY7OOBMHk4YF1wRAXodIvYAe8lUmVc1dzo/tHOL+RpDIzo34HvSrMISEp4rclJMCvj4UcFgr9/nAinFQZOd+iryW3OL7x7kqU4nlCnNbRJEgbql8nFTf2yJ/Kc3xgkerNkzJ6CKm6ZMY15h2YP5f1RG99vAbY+wud/8NThvq3mihZZ9DBqrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bzyGroclyWM6w8NgXnKGFDYHcB6URqz/lsWdMD4H/sU=;
 b=jzZObD/FtR89qfeeuNFqn6X7VHj/mvsQaFXUOy9D0To7ryg2IRS2n5O8c4ykfQztk7xTepy8q2BE0XEgzULQfmWGOgzt8aIU8V1ng6Ybve/dgta6G8aSxXXaXGW4kPNK8wq50YfJVdXq+hPhkiJrDjhmowE3hu9P3rLfcEGWuktsVn4CVnocrJxo5+sysnn6EurxWwhCAkz5LDWOBfcyi7UCgwOhbrpBHcC/SGHFZRUWyaS/tkgzYo6yETDsJhjhUIkcxFjepMwy1qR4TzC+1xM66RW3pD6dbEtQqHKlbJpUI+kIyxvxFPyavmc4SpXXkBKQ5CaYSTh+uEU5Pfm8Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bzyGroclyWM6w8NgXnKGFDYHcB6URqz/lsWdMD4H/sU=;
 b=WiRhELtC/8UdbU+8kQ2VJ7k80INZk6l3Rbav11Dr+5C2Uh5vO+57ygjecXA1SWOdg+1E0Zw8bL8aBEd6i5gAtdq+CBt5RPsounQqWLVkSFpPeuCBAufq7PtQgsQwF0pIGREq3jyS5jY6Qn+Rqw/NKhhFluPOVTON/7cycv9mVno=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by MN2PR10MB3405.namprd10.prod.outlook.com (2603:10b6:208:131::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Thu, 27 May
 2021 15:59:41 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::9da7:f131:1f41:657c]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::9da7:f131:1f41:657c%4]) with mapi id 15.20.4173.020; Thu, 27 May 2021
 15:59:41 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v3 bpf-next 2/2] selftests/bpf: add dump type data tests to btf dump tests
Date:   Thu, 27 May 2021 16:59:30 +0100
Message-Id: <1622131170-8260-3-git-send-email-alan.maguire@oracle.com>
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
Received: from localhost.uk.oracle.com (95.45.14.174) by LO4P123CA0051.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:152::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Thu, 27 May 2021 15:59:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d2fa0c8-bf96-4cff-1575-08d921287046
X-MS-TrafficTypeDiagnostic: MN2PR10MB3405:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB34059654A8077230DA746DD6EF239@MN2PR10MB3405.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ND9r1LNNTOABLxTHxq2YXlxGM5iK4IfU2IM2810foqjKzdsi3/gmRCjZ3VncZIKtdqey0pEJtjWxPgyRDkGKzpgn/j8d7gg/Jv9svWNl9ABLRVTjbGDZVNnX+IEbR2O1iXfJzUE4J+XdgghizSeSToeps6InrXSdaHngimknqHjWIGbKo4xS9WQlGZH0CtNIfyVLkhnzmUo8a3WrtyoyzR8PEkaYLvxPQnQ8YEArJqIXTCnGTb3Jka/HDeRU+C/JuAlo49uKqfM4Vhgft1NcZImD2ztADh5hGUIhRmGmBfpK+aoBHRUp+3HgxfG4QVkqGhITNDS7Tx1zcD5KarNxbjCPBhsEUVIc9pqAcM8Whh82kREl/V+Ca/Ujb07nNtotukktEZ08XDIbw/9HmcZ3kG80+xcxLKxyQ7syzDEb4JbplMfKv7SE5WTfJrP41VcZuOEADLv/5D4tkPwdgvtAlRFcCKwhjDMNK+G9vMemshM25+UWY/gTe2HCzsNSYnf3kr4ZM0hSmt4+ft61ONvCiWw751JYqgE9+1+smItSjRYr2sYXtqqeUZ246BzGE1b8qRju1uxNV06chrZSF3wQivaspALDMn792Hbattw4I3Jf3vQ7ph2IebfhuXs+vCesT6VaPRpI0GyyAZyM066RMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(396003)(346002)(376002)(8936002)(8676002)(2616005)(956004)(2906002)(38100700002)(38350700002)(83380400001)(6486002)(7696005)(86362001)(52116002)(5660300002)(6666004)(66476007)(66946007)(66556008)(16526019)(30864003)(478600001)(186003)(44832011)(107886003)(36756003)(4326008)(7416002)(316002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?EpO7EQBfGRtOLY3cNc/PjVbssjwHA/yegPVns1y8mE0jFzfoUnUu32COP/dQ?=
 =?us-ascii?Q?G9KTAwz+SHp6iY6MSbBL4wrlajjTdo17zvn78qVycSvSPM1qV+7ooieWrmEJ?=
 =?us-ascii?Q?FLrhkbYauitALzK2izZW6fgdqZMci39p5uxA1DfLTr2GyCJgxkuGrghSEZPg?=
 =?us-ascii?Q?efcGcYaItqsGtOX+Lmk+YZUXWUQ2X7p8B+A1uCyJTf+xtm5MNvBU5+RcAUSf?=
 =?us-ascii?Q?Uk/13DP9Ok/MaEcCfR5gFfmZtke2QFEqk1NdekxYtSsTlcDHHsDbxVOBDTF7?=
 =?us-ascii?Q?TbxAyQAE+2OiRdQflhPl9ARbiGw+jXxmuDO+tb1wgCfU76DBmgwejWLatjD3?=
 =?us-ascii?Q?X4waI0hVbCjDnmAvigDksEaciaDbO448Ust0cq/R39vomDY/UPG5LZSYf4re?=
 =?us-ascii?Q?kg+FsAEltkFHQdWEwNY8thNeL+O5q+BClgoyj0wuKf0UXn59Kkc7fAsKaNNn?=
 =?us-ascii?Q?hPwToGF3jFn7QhxTnbt/Z3heDHw/AJ1IxHs4Hu37q74tt+TPQg23zLi30ydZ?=
 =?us-ascii?Q?xFG+RZeeay8HojTg92DZZBBRAMsdFUVd5YI1eWh8w834muzp67wVlOQHSwAN?=
 =?us-ascii?Q?1BGxY660cgOK5WrKp2gwu+bbKnALDj0vB9XjG+3VsiRQIg1cO6+ibn5kkpKD?=
 =?us-ascii?Q?tzr8edl7NxAozN8mjeVR2pV5QVRZ+G7ibi0vRTr9qtL2KNSlL/GYcaXV+liQ?=
 =?us-ascii?Q?hEPPTMu+tDDU64ODUYUm8lrv4JYmJcvJX7LQhtwvBKW70ee7ZyV+ZAt6TF1r?=
 =?us-ascii?Q?gLhALq7207HmI+mRnrKdgH2SyYelkfjQHIZJHAX76OGKlGQFP1zTAnj7nuPI?=
 =?us-ascii?Q?YZppY+lSrX7mqI4PyTnY5N1kW0lIQGlmgHzYvvhPYE1V4RNvISYWJ8LWVzfh?=
 =?us-ascii?Q?5865GpY9j2HAVnAkvPgQHyqtwOGgb0z/orHDEEiYeMGD3D4AWTyK+41UCQOo?=
 =?us-ascii?Q?gAl6VmDNeDaBUtlVs77sq2bUgzFsF1wWKhsNlWd857gcpJicjlPreCq9bDCi?=
 =?us-ascii?Q?S7wMeC21j0OaVQ9y5ipSy8BXs3kF36z526YWE4gjUW5L0ir9cdktdn8vavhh?=
 =?us-ascii?Q?Z+kxMqAatyzpbB6zcsMwWI9LZDjqtMIliIBPwh8ixAPxXoe1zv3UlhBBEOa+?=
 =?us-ascii?Q?mFAyK78sRRwWA8jpMGy40j49b/WW2qe/zmzahbRlKu+qXskn1T0wAmp85ygY?=
 =?us-ascii?Q?LuQUyxRLbMmChVBQexP/+zjYufIkYsM5WDPOc/3nNWPzA/d0ZqRfd/KfxkmR?=
 =?us-ascii?Q?9p1VcfcQwlLfOZuGA0sYNnRSfoJ5JQ8HANU+eZaNme7JU5ERX4H81UNeUwD0?=
 =?us-ascii?Q?33jL8e53hcLNbAVDJz36i2ax?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d2fa0c8-bf96-4cff-1575-08d921287046
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 15:59:41.7378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1y62NZVjGBgXc1PYsgiyF2+bndlFO5JRQPrQtRhsomhy1EwJfKG6XvCFW8ZXGe9YRBR8uw4IsAN127QaAI2Euw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3405
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9997 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105270102
X-Proofpoint-GUID: orMkckPzWbXICpc9L6IReWPEmp6RlVSp
X-Proofpoint-ORIG-GUID: orMkckPzWbXICpc9L6IReWPEmp6RlVSp
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
 tools/testing/selftests/bpf/prog_tests/btf_dump.c | 524 ++++++++++++++++++++++
 1 file changed, 524 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dump.c b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
index 5e129dc..50a1c1d 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_dump.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
@@ -232,6 +232,528 @@ void test_btf_dump_incremental(void)
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
+	char skbdata[512] = { };
+	void *skb = skbdata;
+	size_t typesize;
+	__s32 type_id;
+	int ret;
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
+	memset(skb, 255, 512);
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
 
@@ -245,4 +767,6 @@ void test_btf_dump() {
 	}
 	if (test__start_subtest("btf_dump: incremental"))
 		test_btf_dump_incremental();
+	if (test__start_subtest("btf_dump: data"))
+		test_btf_dump_data();
 }
-- 
1.8.3.1

