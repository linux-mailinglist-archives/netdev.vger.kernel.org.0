Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1FF33CA14C
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 17:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238855AbhGOPTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 11:19:11 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:41912 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238643AbhGOPS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 11:18:59 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16FF6akw005314;
        Thu, 15 Jul 2021 15:15:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=EEeISX5A5CSjFQFiUHPfSqnCrqOej145qjAdSh2vU1w=;
 b=x7kE5KZ5R/ptcIUi//kn4tQn0+qC0DhVqygbn+Dg3nE2UvZDR7/hnlh114UM8F8/wzUl
 7QQR6dydjH7RvCt8i+QCn9TYnrgJM8pgZXTSMRB6SwJ+6DBrfiGD9lGtfxTdw3W4GJsO
 oVTpyd9cuEa1TiwqvV6sjIHoTkLG7Moc3Po314dNHK/3o+48xA3tNtn1cgb+qyR3nAan
 7vtA0ukM1gOLAnmRs/CuotGrmN86RuTDhyolq4lhJ42DvWXhpHBBHqsgPmzhcnDWieiu
 QW2t0mIeudgdD3+feYmCHWJJ+o0frCSzQp8YVyG5Y+kjfW0o0nF3kIA/87ybIHEFV+Wc 9A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=EEeISX5A5CSjFQFiUHPfSqnCrqOej145qjAdSh2vU1w=;
 b=KkLmxGy/Pgd1koUb7sJk8SYWM3lfTEH2qIev9CrQp9ZaTqc/zlza+CcPM5Z90ezuqrk7
 IVyShKZqedoOC+puvv7jipnQHqy4TAmUMtOnXLjHhWcwQFhPzhoQqNPQCLtt3CKx65CF
 AkFDgHyOla/rxGdgrZyaEEeaSJD2zRxdSQYLjgKZx+39iqi8TZjf8CocMUfDVVtqCiQq
 rUmd85vSJzahXWu2/K7pizHdbksm44YgiW3Rm392T9dB3qJrNJ6H9TjSl4pLV1G1a3NU
 lvzu/Y+Q7CrnqTTiibbIGmD+POnl6q/zh4T64vyT/kfhoO5nnRXqKymfzTakkSymn+xs zQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39t2tj2b5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jul 2021 15:15:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16FF73ST171923;
        Thu, 15 Jul 2021 15:15:41 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by aserp3030.oracle.com with ESMTP id 39qyd37ahh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jul 2021 15:15:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eyhSU1KQwAwsfYX4Y1OiClSxi4CXOzffA9X7il8IcGGWZtxkSWvxbuoDK3X46da8oqiWdcZAgsJo/k56tgwXiNRQrO6uKSmJTIUMS6UtP6fbH4GXICvuiSZjfFWF+cxzUi8OHRmk+1ebIWfVKuDmZTdqrMA7hZsklPEs+LHDIn8HcDnlk6f1TYotPbG4bW+S2p5oY6a3/Jb8wyIPLFOx+ZRGfOZDaMpnaC/Uuncutk0yIpKRDErYfi4sohkLOAcI51jrHFqqE5OqJ9jfHZgTYuuIxr0Al+Hxfo+lc2Bzh6zlGVPXmUBQY8Otxu25MudgUzTyjd/d4SImW1sqvctFrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EEeISX5A5CSjFQFiUHPfSqnCrqOej145qjAdSh2vU1w=;
 b=DlxSdJIDU/FIpZyUCyhGGQWmosRe3kiNooad6RovrI2UsbuTs17YwUNZMfbINXGIAshBHedpxnjQBVfeSHzk8KKGW0pWEnr4MXrRUrCJ8r6mkvEkxM35NMKre7djk019D2aNsSoGlmn1ZhH942sjSTufeTz+1DHUZmHbGKBKzu+Po2dTexXFw2qrcS+L6MK9a9Wz7K3eplEnUuyDh/F3lRPMlqbkbilgpeRSjJQRvOR0oFELNmAQrZbrNoUtxcxiyVJm8sA6VCEKR6pWg0MUX5hg23GIU06kyT+q3laWzl7XJS4pPY3sNbRke+LqePnUyefG8ghl3avsfm7WXsS2fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EEeISX5A5CSjFQFiUHPfSqnCrqOej145qjAdSh2vU1w=;
 b=S7k7qvPPrQmS301Q35l3gagG2zaDUgbRgFXoemZvAgjInTRZAg+YLxUA0yJOVkveXEiEfHYGR/Fm2JD+kXsfA+padecH163d4my1WPrYjVZaaia8B8R6P4rJUceLBrY3+IWGwuaIHLOEB1sIR+ApOa3cNkGSnAC1aTGGm7dynjg=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by BLAPR10MB5123.namprd10.prod.outlook.com (2603:10b6:208:333::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Thu, 15 Jul
 2021 15:15:38 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56%9]) with mapi id 15.20.4331.024; Thu, 15 Jul 2021
 15:15:38 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v6 bpf-next 3/3] selftests/bpf: add dump type data tests to btf dump tests
Date:   Thu, 15 Jul 2021 16:15:26 +0100
Message-Id: <1626362126-27775-4-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1626362126-27775-1-git-send-email-alan.maguire@oracle.com>
References: <1626362126-27775-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0357.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::20) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.uk.oracle.com (95.45.14.174) by LO4P123CA0357.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:18d::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Thu, 15 Jul 2021 15:15:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1fade103-8093-415d-53bf-08d947a36708
X-MS-TrafficTypeDiagnostic: BLAPR10MB5123:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BLAPR10MB5123E1CA3AAB4ECFF9960272EF129@BLAPR10MB5123.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E9Gf6KA3AVVk5QhNQJEjy3Sg94tcwGTTjVXTD7BUV0zkRbjGgUQyf++E5dvQM5jnNBoNxEw8UgL7espeu2/p/4gUhJ+BJSrea6jATezUBX1jMJMWx33zsQiprQt6IyEl7hKoEpnWPMFkHliLrZlqc9Vm7g/FPq8nGx2CzGVNwDudMImkckHOR726ALcTjxUCEjb4Z2X0glP9KBD8+stE/r//0H5os9gZ3jo2kHSLB+H2OKUrJf6OH65vn+3lvJLNToikGY26sRMfEKFJOnR+LWBcVwhLOxK4mPD6HVYRl7kh0Svbtqo7kE5JWvwxoqpSpFA6Fq7hl7cNmJmzP4zF1QxTyHR1aUphXAfgtmEErmvTH8nKmhyILw4hWckM+o3se9ns1jqeuzS4YKDc1CKSM8Bk2rsdn7db5wXyNhiRA+BifM2aFPSDYFTFo3vJiU5fmagJPXV9cpGpaeY2JnHRu4NnSZ7h9RL9Pt0XfyfGwbaGd27W7LoUWgnRty55BOWYANEikF0ywlXAsvc2LLcRChVaFs9pKhhsqYV3EMDmlGSaEgRQb13lVJ2MSIhdy5LvoDQud/RPklt0iLk+fIHvdEttrGAM5CKV3qmiE1H4qqq31xLqkHH7fS3Ki01XRuf2EebO/Gn5P9c+27/xmJQusSWhT75zcBvIZnZk0ijB4JUG4ENBw4UEroKIsjeUKpEVXdLFkhHFdnzmYNkOAqhBQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(44832011)(83380400001)(316002)(8676002)(478600001)(2906002)(66476007)(4326008)(66556008)(86362001)(66946007)(30864003)(8936002)(6486002)(52116002)(7696005)(186003)(5660300002)(36756003)(956004)(7416002)(6666004)(26005)(38100700002)(107886003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZdCaOjDIyL6hY6RlKCrd7vxjeD05WXp5oIfgs2bzt8dJ+qAs5PD3FbMSHvvz?=
 =?us-ascii?Q?vnUDEhYfcEk4bTWCq1AwNTp/uULGoFnQv85TIgwnCCJTCfve3JlqyK9GyC/o?=
 =?us-ascii?Q?/LvXi+SBTiI2baj/HVCH8qHw/Z6HASWmSvxmv9UfBiG0FuBIa8ohuBQgGcSo?=
 =?us-ascii?Q?NzMAc0a4ivJKPTfDka1HRpFx+H4683+ry0huuyoKM9Kx1ol7QTAm4PzpT5Nj?=
 =?us-ascii?Q?DZyvv87UA1jIiqk2YKeUde9XHa9j73I3uhbw8oZp6ZfVVpVT5jX2PrLw/UVd?=
 =?us-ascii?Q?fJPJVshSsVmEZ7HrxvrkIm8yW9devVqrlveUEwqP+po+VxZB4H5yK+FCdTlJ?=
 =?us-ascii?Q?111WCRDy4T3bg3wIWeBiMKyNSAL6mLJxz5mlxHpNhyTX8p5SCthgB+4Et3at?=
 =?us-ascii?Q?RO9ZoSTLsBqAbuB12BI+rgpavDB+xpLwdTSqCe+dcVFXJuot8Q75uYJxm4RL?=
 =?us-ascii?Q?JHo3EXPlOxiShDx9aShkA22LP3T+PSHb+tKLGsNhgkdoWcNOQuC+yAI1GOFd?=
 =?us-ascii?Q?4mhgYprfNMGqQLAZRVE1H9dYk+Eqo/XSKIt3j6ivUFR+dmw81sg2Mzg3JYAr?=
 =?us-ascii?Q?4hxoL+S1nVtKgJqah+1oPCfvQlmVqq5EzeNDQODC1xrS+2XDO1i6nQc792k9?=
 =?us-ascii?Q?QzYOCqsLKvQ7rdjDcQQ22cS9yMOrWJYgbs/06IRA4f/4PUQ9U6waAJJw9dBy?=
 =?us-ascii?Q?uSDs2DCZmgdNtb5xxQn3I+51luBwpGQ/z4olzZyCqNDVQJO6l56v+kES8ZnE?=
 =?us-ascii?Q?aGuqmDVM4fVykatVoc/KGazcEwFn3LqohgrCat3oaOV/Vf2430+kVNtyMcWl?=
 =?us-ascii?Q?udH7Qvu4VbLbxDEfWn52ToIRuw8///n+pJi7ScnLgwOSZk/d7X5xb/HljVIb?=
 =?us-ascii?Q?wQWKcIg03n6LNDppkOhi7W2b6y0ubVrXdK9CNMfeTmfhJ8fecdrfbOB78arM?=
 =?us-ascii?Q?iTwKAzyExQRfMXoH7yuKKFxqydrDW8wK4ILqSAJHhLf1p6/IdvztuIDzObvG?=
 =?us-ascii?Q?yvyJ6+xN204VCGxXJXB28ev4y56wATIyQB+jpfDUTEQskDILK8APr5tOS8G0?=
 =?us-ascii?Q?/31BHXnTFZNaNwYk4xRmfmVLuGhSh/JQV+TcA4GG2Kk1TsZM6C8Stp8VxHvN?=
 =?us-ascii?Q?7Xp6nK8k1xI8EEhtZKBAEoIVipGys2b/LzDktPnvuLrNsVFECEKNby7jaJvG?=
 =?us-ascii?Q?Or89lMKcWh1o+mAzAuDbR8NN5NAj3EC3lZmzYb6JeDWqX3w/ZYwZFWvHR+mL?=
 =?us-ascii?Q?VmZcDg1AqbmaJh3WUa62VYO/lkk6oyVym22ZS/UTdmcnC0Ep0HsbwigKZRO7?=
 =?us-ascii?Q?FfvRy/2c6zSF1lK3+65cdXvr?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fade103-8093-415d-53bf-08d947a36708
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2021 15:15:38.4780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ebEJ+Kef6wrdO0+xMutEyMLJ3Y8frk/2dEKxGPfXRp5m//amlrJYGv58gPJfHkD5qK1ice6wyY4ZlDZu/XxGEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5123
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10045 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107150107
X-Proofpoint-GUID: z_dC5TeZaS-_dVXNRavRjKAB9utw66if
X-Proofpoint-ORIG-GUID: z_dC5TeZaS-_dVXNRavRjKAB9utw66if
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
 tools/testing/selftests/bpf/prog_tests/btf_dump.c | 600 ++++++++++++++++++++++
 1 file changed, 600 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dump.c b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
index 1b90e68..2bfa47e 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_dump.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
@@ -232,7 +232,577 @@ void test_btf_dump_incremental(void)
 	btf__free(btf);
 }
 
+#define STRSIZE				4096
+
+static void btf_dump_snprintf(void *ctx, const char *fmt, va_list args)
+{
+	char *s = ctx, new[STRSIZE];
+
+	vsnprintf(new, STRSIZE, fmt, args);
+	if (strlen(s) < STRSIZE)
+		strncat(s, new, STRSIZE - strlen(s) - 1);
+}
+
+static int btf_dump_data(struct btf *btf, struct btf_dump *d,
+			 char *name, char *prefix, __u64 flags, void *ptr,
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
+	if (prefix) {
+		ASSERT_STRNEQ(name, prefix, strlen(prefix),
+			      "verify prefix match");
+		name += strlen(prefix) + 1;
+	}
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
+#define TEST_BTF_DUMP_DATA(_b, _d, _prefix, _str, _type, _flags,	\
+			   _expected, ...)				\
+	do {								\
+		char __ptrtype[64] = #_type;				\
+		char *_ptrtype = (char *)__ptrtype;			\
+		_type _ptrdata = __VA_ARGS__;				\
+		void *_ptr = &_ptrdata;					\
+									\
+		(void) btf_dump_data(_b, _d, _ptrtype, _prefix, _flags,	\
+				     _ptr, sizeof(_type), _str,		\
+				     _expected);			\
+	} while (0)
+
+/* Use where expected data string matches its stringified declaration */
+#define TEST_BTF_DUMP_DATA_C(_b, _d, _prefix,  _str, _type, _flags,	\
+			     ...)					\
+	TEST_BTF_DUMP_DATA(_b, _d, _prefix, _str, _type, _flags,	\
+			   "(" #_type ")" #__VA_ARGS__,	__VA_ARGS__)
+
+/* overflow test; pass typesize < expected type size, ensure E2BIG returned */
+#define TEST_BTF_DUMP_DATA_OVER(_b, _d, _prefix, _str, _type, _type_sz,	\
+				_expected, ...)				\
+	do {								\
+		char __ptrtype[64] = #_type;				\
+		char *_ptrtype = (char *)__ptrtype;			\
+		_type _ptrdata = __VA_ARGS__;				\
+		void *_ptr = &_ptrdata;					\
+									\
+		(void) btf_dump_data(_b, _d, _ptrtype, _prefix, 0,	\
+				     _ptr, _type_sz, _str, _expected);	\
+	} while (0)
+
+#define TEST_BTF_DUMP_VAR(_b, _d, _prefix, _str, _var, _type, _flags,	\
+			  _expected, ...)				\
+	do {								\
+		_type _ptrdata = __VA_ARGS__;				\
+		void *_ptr = &_ptrdata;					\
+									\
+		(void) btf_dump_data(_b, _d, _var, _prefix, _flags,	\
+				     _ptr, sizeof(_type), _str,		\
+				     _expected);			\
+	} while (0)
+
+static void test_btf_dump_int_data(struct btf *btf, struct btf_dump *d,
+				   char *str)
+{
+	/* simple int */
+	TEST_BTF_DUMP_DATA_C(btf, d, NULL, str, int, BTF_F_COMPACT, 1234);
+	TEST_BTF_DUMP_DATA(btf, d, NULL, str, int, BTF_F_COMPACT | BTF_F_NONAME,
+			   "1234", 1234);
+	TEST_BTF_DUMP_DATA(btf, d, NULL, str, int, 0, "(int)1234", 1234);
+
+	/* zero value should be printed at toplevel */
+	TEST_BTF_DUMP_DATA(btf, d, NULL, str, int, BTF_F_COMPACT, "(int)0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, NULL, str, int, BTF_F_COMPACT | BTF_F_NONAME,
+			   "0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, NULL, str, int, BTF_F_COMPACT | BTF_F_ZERO,
+			   "(int)0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, NULL, str, int,
+			   BTF_F_COMPACT | BTF_F_NONAME | BTF_F_ZERO,
+			   "0", 0);
+	TEST_BTF_DUMP_DATA_C(btf, d, NULL, str, int, BTF_F_COMPACT, -4567);
+	TEST_BTF_DUMP_DATA(btf, d, NULL, str, int, BTF_F_COMPACT | BTF_F_NONAME,
+			   "-4567", -4567);
+	TEST_BTF_DUMP_DATA(btf, d, NULL, str, int, 0, "(int)-4567", -4567);
+
+	TEST_BTF_DUMP_DATA_OVER(btf, d, NULL, str, int, sizeof(int)-1, "", 1);
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
+	ASSERT_GT(btf__add_float(btf, "test_float", 4), 0, "add float");
+	ASSERT_OK(btf_dump_data(btf, d, "test_float", NULL, 0, &t1, 4, str,
+				"(test_float)1.234567"), "dump float");
+	ASSERT_OK(btf_dump_data(btf, d, "test_float", NULL, 0, &t2, 4, str,
+				"(test_float)-1.234567"), "dump float");
+	ASSERT_OK(btf_dump_data(btf, d, "test_float", NULL, 0, &t3, 4, str,
+				"(test_float)0.000000"), "dump float");
+
+	ASSERT_GT(btf__add_float(btf, "test_double", 8), 0, "add_double");
+	ASSERT_OK(btf_dump_data(btf, d, "test_double", NULL, 0, &t4, 8, str,
+		  "(test_double)5.678912"), "dump double");
+	ASSERT_OK(btf_dump_data(btf, d, "test_double", NULL, 0, &t5, 8, str,
+		  "(test_double)-5.678912"), "dump double");
+	ASSERT_OK(btf_dump_data(btf, d, "test_double", NULL, 0, &t6, 8, str,
+				"(test_double)0.000000"), "dump double");
+
+	ASSERT_GT(btf__add_float(btf, "test_long_double", 16), 0, "add long double");
+	ASSERT_OK(btf_dump_data(btf, d, "test_long_double", NULL, 0, &t7, 16,
+				str, "(test_long_double)9.876543"),
+				"dump long_double");
+	ASSERT_OK(btf_dump_data(btf, d, "test_long_double", NULL, 0, &t8, 16,
+				str, "(test_long_double)-9.876543"),
+				"dump long_double");
+	ASSERT_OK(btf_dump_data(btf, d, "test_long_double", NULL, 0, &t9, 16,
+				str, "(test_long_double)0.000000"),
+				"dump long_double");
+}
+
+static void test_btf_dump_char_data(struct btf *btf, struct btf_dump *d,
+				    char *str)
+{
+	/* simple char */
+	TEST_BTF_DUMP_DATA_C(btf, d, NULL, str, char, BTF_F_COMPACT, 100);
+	TEST_BTF_DUMP_DATA(btf, d, NULL, str, char, BTF_F_COMPACT | BTF_F_NONAME,
+			   "100", 100);
+	TEST_BTF_DUMP_DATA(btf, d, NULL, str, char, 0, "(char)100", 100);
+	/* zero value should be printed at toplevel */
+	TEST_BTF_DUMP_DATA(btf, d, NULL, str, char, BTF_F_COMPACT,
+			   "(char)0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, NULL, str, char, BTF_F_COMPACT | BTF_F_NONAME,
+			   "0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, NULL, str, char, BTF_F_COMPACT | BTF_F_ZERO,
+			   "(char)0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, NULL, str, char, BTF_F_COMPACT | BTF_F_NONAME | BTF_F_ZERO,
+			   "0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, NULL, str, char, 0, "(char)0", 0);
+
+	TEST_BTF_DUMP_DATA_OVER(btf, d, NULL, str, char, sizeof(char)-1, "", 100);
+}
+
+static void test_btf_dump_typedef_data(struct btf *btf, struct btf_dump *d,
+				       char *str)
+{
+	/* simple typedef */
+	TEST_BTF_DUMP_DATA_C(btf, d, NULL, str, uint64_t, BTF_F_COMPACT, 100);
+	TEST_BTF_DUMP_DATA(btf, d, NULL, str, u64, BTF_F_COMPACT | BTF_F_NONAME,
+			   "1", 1);
+	TEST_BTF_DUMP_DATA(btf, d, NULL, str, u64, 0, "(u64)1", 1);
+	/* zero value should be printed at toplevel */
+	TEST_BTF_DUMP_DATA(btf, d, NULL, str, u64, BTF_F_COMPACT, "(u64)0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, NULL, str, u64, BTF_F_COMPACT | BTF_F_NONAME,
+			   "0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, NULL, str, u64, BTF_F_COMPACT | BTF_F_ZERO,
+			   "(u64)0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, NULL, str, u64,
+			   BTF_F_COMPACT | BTF_F_NONAME | BTF_F_ZERO,
+			   "0", 0);
+	TEST_BTF_DUMP_DATA(btf, d, NULL, str, u64, 0, "(u64)0", 0);
+
+	/* typedef struct */
+	TEST_BTF_DUMP_DATA_C(btf, d, NULL, str, atomic_t, BTF_F_COMPACT,
+			     {.counter = (int)1,});
+	TEST_BTF_DUMP_DATA(btf, d, NULL, str, atomic_t, BTF_F_COMPACT | BTF_F_NONAME,
+			   "{1,}", { .counter = 1 });
+	TEST_BTF_DUMP_DATA(btf, d, NULL, str, atomic_t, 0,
+"(atomic_t){\n"
+"	.counter = (int)1,\n"
+"}",
+			   {.counter = 1,});
+	/* typedef with 0 value should be printed at toplevel */
+	TEST_BTF_DUMP_DATA(btf, d, NULL, str, atomic_t, BTF_F_COMPACT, "(atomic_t){}",
+			   {.counter = 0,});
+	TEST_BTF_DUMP_DATA(btf, d, NULL, str, atomic_t, BTF_F_COMPACT | BTF_F_NONAME,
+			   "{}", {.counter = 0,});
+	TEST_BTF_DUMP_DATA(btf, d, NULL, str, atomic_t, 0,
+"(atomic_t){\n"
+"}",
+			   {.counter = 0,});
+	TEST_BTF_DUMP_DATA(btf, d, NULL, str, atomic_t, BTF_F_COMPACT | BTF_F_ZERO,
+			   "(atomic_t){.counter = (int)0,}",
+			   {.counter = 0,});
+	TEST_BTF_DUMP_DATA(btf, d, NULL, str, atomic_t,
+			   BTF_F_COMPACT | BTF_F_NONAME | BTF_F_ZERO,
+			   "{0,}", {.counter = 0,});
+	TEST_BTF_DUMP_DATA(btf, d, NULL, str, atomic_t, BTF_F_ZERO,
+"(atomic_t){\n"
+"	.counter = (int)0,\n"
+"}",
+			   { .counter = 0,});
+
+	/* overflow should show type but not value since it overflows */
+	TEST_BTF_DUMP_DATA_OVER(btf, d, NULL, str, atomic_t, sizeof(atomic_t)-1,
+				"(atomic_t){\n", { .counter = 1});
+}
+
+static void test_btf_dump_enum_data(struct btf *btf, struct btf_dump *d,
+				    char *str)
+{
+	/* enum where enum value does (and does not) exist */
+	TEST_BTF_DUMP_DATA_C(btf, d, "enum", str, enum bpf_cmd, BTF_F_COMPACT,
+			     BPF_MAP_CREATE);
+	TEST_BTF_DUMP_DATA(btf, d, "enum", str, enum bpf_cmd, BTF_F_COMPACT,
+			   "(enum bpf_cmd)BPF_MAP_CREATE", 0);
+	TEST_BTF_DUMP_DATA(btf, d, "enum", str, enum bpf_cmd,
+			   BTF_F_COMPACT | BTF_F_NONAME,
+			   "BPF_MAP_CREATE",
+			   BPF_MAP_CREATE);
+	TEST_BTF_DUMP_DATA(btf, d, "enum", str, enum bpf_cmd, 0,
+			   "(enum bpf_cmd)BPF_MAP_CREATE",
+			   BPF_MAP_CREATE);
+	TEST_BTF_DUMP_DATA(btf, d, "enum", str, enum bpf_cmd,
+			   BTF_F_COMPACT | BTF_F_NONAME | BTF_F_ZERO,
+			   "BPF_MAP_CREATE", 0);
+	TEST_BTF_DUMP_DATA(btf, d, "enum", str, enum bpf_cmd,
+			   BTF_F_COMPACT | BTF_F_ZERO,
+			   "(enum bpf_cmd)BPF_MAP_CREATE",
+			   BPF_MAP_CREATE);
+	TEST_BTF_DUMP_DATA(btf, d, "enum", str, enum bpf_cmd,
+			   BTF_F_COMPACT | BTF_F_NONAME | BTF_F_ZERO,
+			   "BPF_MAP_CREATE", BPF_MAP_CREATE);
+	TEST_BTF_DUMP_DATA_C(btf, d, "enum", str, enum bpf_cmd, BTF_F_COMPACT, 2000);
+	TEST_BTF_DUMP_DATA(btf, d, "enum", str, enum bpf_cmd,
+			   BTF_F_COMPACT | BTF_F_NONAME,
+			   "2000", 2000);
+	TEST_BTF_DUMP_DATA(btf, d, "enum", str, enum bpf_cmd, 0,
+			   "(enum bpf_cmd)2000", 2000);
+
+	TEST_BTF_DUMP_DATA_OVER(btf, d, "enum", str, enum bpf_cmd,
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
+	TEST_BTF_DUMP_DATA_C(btf, d, "struct", str, struct btf_enum, BTF_F_COMPACT,
+			     {.name_off = (__u32)3,.val = (__s32)-1,});
+	TEST_BTF_DUMP_DATA(btf, d, "struct", str, struct btf_enum,
+			   BTF_F_COMPACT | BTF_F_NONAME,
+			   "{3,-1,}",
+			   { .name_off = 3, .val = -1,});
+	TEST_BTF_DUMP_DATA(btf, d, "struct", str, struct btf_enum, 0,
+"(struct btf_enum){\n"
+"	.name_off = (__u32)3,\n"
+"	.val = (__s32)-1,\n"
+"}",
+			   { .name_off = 3, .val = -1,});
+	TEST_BTF_DUMP_DATA(btf, d, "struct", str, struct btf_enum,
+			   BTF_F_COMPACT | BTF_F_NONAME,
+			   "{-1,}",
+			   { .name_off = 0, .val = -1,});
+	TEST_BTF_DUMP_DATA(btf, d, "struct", str, struct btf_enum,
+			   BTF_F_COMPACT | BTF_F_NONAME | BTF_F_ZERO,
+			   "{0,-1,}",
+			   { .name_off = 0, .val = -1,});
+	/* empty struct should be printed */
+	TEST_BTF_DUMP_DATA(btf, d, "struct", str, struct btf_enum, BTF_F_COMPACT,
+			   "(struct btf_enum){}",
+			   { .name_off = 0, .val = 0,});
+	TEST_BTF_DUMP_DATA(btf, d, "struct", str, struct btf_enum,
+			   BTF_F_COMPACT | BTF_F_NONAME,
+			   "{}",
+			   { .name_off = 0, .val = 0,});
+	TEST_BTF_DUMP_DATA(btf, d, "struct", str, struct btf_enum, 0,
+"(struct btf_enum){\n"
+"}",
+			   { .name_off = 0, .val = 0,});
+	TEST_BTF_DUMP_DATA(btf, d, "struct", str, struct btf_enum,
+			   BTF_F_COMPACT | BTF_F_ZERO,
+			   "(struct btf_enum){.name_off = (__u32)0,.val = (__s32)0,}",
+			   { .name_off = 0, .val = 0,});
+	TEST_BTF_DUMP_DATA(btf, d, "struct", str, struct btf_enum,
+			   BTF_F_ZERO,
+"(struct btf_enum){\n"
+"	.name_off = (__u32)0,\n"
+"	.val = (__s32)0,\n"
+"}",
+			   { .name_off = 0, .val = 0,});
+
+	/* struct with pointers */
+	TEST_BTF_DUMP_DATA(btf, d, "struct", str, struct list_head, BTF_F_COMPACT,
+			   "(struct list_head){.next = (struct list_head *)0x1,}",
+			   { .next = (struct list_head *)1 });
+	TEST_BTF_DUMP_DATA(btf, d, "struct", str, struct list_head, 0,
+"(struct list_head){\n"
+"	.next = (struct list_head *)0x1,\n"
+"}",
+			   { .next = (struct list_head *)1 });
+	/* NULL pointer should not be displayed */
+	TEST_BTF_DUMP_DATA(btf, d, "struct", str, struct list_head, BTF_F_COMPACT,
+			   "(struct list_head){}",
+			   { .next = (struct list_head *)0 });
+	TEST_BTF_DUMP_DATA(btf, d, "struct", str, struct list_head, 0,
+"(struct list_head){\n"
+"}",
+			   { .next = (struct list_head *)0 });
+
+	/* struct with function pointers */
+	type_id = btf__find_by_name(btf, "file_operations");
+	if (ASSERT_GT(type_id, 0, "find type id")) {
+		type_sz = btf__resolve_size(btf, type_id);
+		str[0] = '\0';
+
+		ret = btf_dump__dump_type_data(d, type_id, fops, type_sz, &opts);
+		ASSERT_EQ(ret, type_sz,
+			  "unexpected return value dumping file_operations");
+		cmpstr =
+"(struct file_operations){\n"
+"	.owner = (struct module *)0xffffffffffffffff,\n"
+"	.llseek = (loff_t (*)(struct file *, loff_t, int))0xffffffffffffffff,";
+
+		ASSERT_STRNEQ(str, cmpstr, strlen(cmpstr), "file_operations");
+	}
+
+	/* struct with char array */
+	TEST_BTF_DUMP_DATA(btf, d, "struct", str, struct bpf_prog_info, BTF_F_COMPACT,
+			   "(struct bpf_prog_info){.name = (char[16])['f','o','o',],}",
+			   { .name = "foo",});
+	TEST_BTF_DUMP_DATA(btf, d, "struct", str, struct bpf_prog_info,
+			   BTF_F_COMPACT | BTF_F_NONAME,
+			   "{['f','o','o',],}",
+			   {.name = "foo",});
+	TEST_BTF_DUMP_DATA(btf, d, "struct", str, struct bpf_prog_info, 0,
+"(struct bpf_prog_info){\n"
+"	.name = (char[16])[\n"
+"		'f',\n"
+"		'o',\n"
+"		'o',\n"
+"	],\n"
+"}",
+			   {.name = "foo",});
+	/* leading null char means do not display string */
+	TEST_BTF_DUMP_DATA(btf, d, "struct", str, struct bpf_prog_info, BTF_F_COMPACT,
+			   "(struct bpf_prog_info){}",
+			   {.name = {'\0', 'f', 'o', 'o'}});
+	/* handle non-printable characters */
+	TEST_BTF_DUMP_DATA(btf, d, "struct", str, struct bpf_prog_info, BTF_F_COMPACT,
+			   "(struct bpf_prog_info){.name = (char[16])[1,2,3,],}",
+			   { .name = {1, 2, 3, 0}});
+
+	/* struct with non-char array */
+	TEST_BTF_DUMP_DATA(btf, d, "struct", str, struct __sk_buff, BTF_F_COMPACT,
+			   "(struct __sk_buff){.cb = (__u32[5])[1,2,3,4,5,],}",
+			   { .cb = {1, 2, 3, 4, 5,},});
+	TEST_BTF_DUMP_DATA(btf, d, "struct", str, struct __sk_buff,
+			   BTF_F_COMPACT | BTF_F_NONAME,
+			   "{[1,2,3,4,5,],}",
+			   { .cb = { 1, 2, 3, 4, 5},});
+	TEST_BTF_DUMP_DATA(btf, d, "struct", str, struct __sk_buff, 0,
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
+	TEST_BTF_DUMP_DATA(btf, d, "struct", str, struct __sk_buff, BTF_F_COMPACT,
+			   "(struct __sk_buff){.cb = (__u32[5])[0,0,1,0,0,],}",
+			   { .cb = { 0, 0, 1, 0, 0},});
+	TEST_BTF_DUMP_DATA(btf, d, "struct", str, struct __sk_buff, 0,
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
+	TEST_BTF_DUMP_DATA_C(btf, d, "struct", str, struct bpf_insn, BTF_F_COMPACT,
+		{.code = (__u8)1,.dst_reg = (__u8)0x2,.src_reg = (__u8)0x3,.off = (__s16)4,.imm = (__s32)5,});
+	TEST_BTF_DUMP_DATA(btf, d, "struct", str, struct bpf_insn,
+			   BTF_F_COMPACT | BTF_F_NONAME,
+			   "{1,0x2,0x3,4,5,}",
+			   { .code = 1, .dst_reg = 0x2, .src_reg = 0x3, .off = 4,
+			     .imm = 5,});
+	TEST_BTF_DUMP_DATA(btf, d, "struct", str, struct bpf_insn, 0,
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
+	TEST_BTF_DUMP_DATA(btf, d, "struct", str, struct bpf_insn, BTF_F_COMPACT,
+			   "(struct bpf_insn){.dst_reg = (__u8)0x1,}",
+			   { .code = 0, .dst_reg = 1});
+
+	/* struct with enum bitfield */
+	type_id = btf__find_by_name(btf, "fs_context");
+	if (ASSERT_GT(type_id,  0, "find fs_context")) {
+		type_sz = btf__resolve_size(btf, type_id);
+		str[0] = '\0';
+
+		opts.emit_zeroes = true;
+		ret = btf_dump__dump_type_data(d, type_id, zero_data, type_sz, &opts);
+		ASSERT_EQ(ret, type_sz,
+			  "unexpected return value dumping fs_context");
+
+		ASSERT_NEQ(strstr(str, "FS_CONTEXT_FOR_MOUNT"), NULL,
+				  "bitfield value not present");
+	}
+
+	/* struct with nested anon union */
+	TEST_BTF_DUMP_DATA(btf, d, "struct", str, struct bpf_sock_ops, BTF_F_COMPACT,
+			   "(struct bpf_sock_ops){.op = (__u32)1,(union){.args = (__u32[4])[1,2,3,4,],.reply = (__u32)1,.replylong = (__u32[4])[1,2,3,4,],},}",
+			   { .op = 1, .args = { 1, 2, 3, 4}});
+
+	/* union with nested struct */
+	TEST_BTF_DUMP_DATA(btf, d, "union", str, union bpf_iter_link_info, BTF_F_COMPACT,
+			   "(union bpf_iter_link_info){.map = (struct){.map_fd = (__u32)1,},}",
+			   { .map = { .map_fd = 1 }});
+
+	/* struct skb with nested structs/unions; because type output is so
+	 * complex, we don't do a string comparison, just verify we return
+	 * the type size as the amount of data displayed.
+	 */
+	type_id = btf__find_by_name(btf, "sk_buff");
+	if (ASSERT_GT(type_id, 0, "find struct sk_buff")) {
+		type_sz = btf__resolve_size(btf, type_id);
+		str[0] = '\0';
+
+		ret = btf_dump__dump_type_data(d, type_id, skb, type_sz, &opts);
+		ASSERT_EQ(ret, type_sz,
+			  "unexpected return value dumping sk_buff");
+	}
+
+	/* overflow bpf_sock_ops struct with final element nonzero/zero.
+	 * Regardless of the value of the final field, we don't have all the
+	 * data we need to display it, so we should trigger an overflow.
+	 * In other words oveflow checking should trump "is field zero?"
+	 * checks because if we've overflowed, it shouldn't matter what the
+	 * field is - we can't trust its value so shouldn't display it.
+	 */
+	TEST_BTF_DUMP_DATA_OVER(btf, d, "struct", str, struct bpf_sock_ops,
+				sizeof(struct bpf_sock_ops) - 1,
+				"(struct bpf_sock_ops){\n\t.op = (__u32)1,\n",
+				{ .op = 1, .skb_tcp_flags = 2});
+	TEST_BTF_DUMP_DATA_OVER(btf, d, "struct", str, struct bpf_sock_ops,
+				sizeof(struct bpf_sock_ops) - 1,
+				"(struct bpf_sock_ops){\n\t.op = (__u32)1,\n",
+				{ .op = 1, .skb_tcp_flags = 0});
+}
+
+static void test_btf_dump_var_data(struct btf *btf, struct btf_dump *d,
+				   char *str)
+{
+	TEST_BTF_DUMP_VAR(btf, d, NULL, str, "cpu_number", int, BTF_F_COMPACT,
+			  "int cpu_number = (int)100", 100);
+	TEST_BTF_DUMP_VAR(btf, d, NULL, str, "cpu_profile_flip", int, BTF_F_COMPACT,
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
+	if (!ASSERT_GT(type_id, 0, "find type id"))
+		return;
+
+	secsize = btf__resolve_size(btf, type_id);
+	ASSERT_EQ(secsize,  0, "verify section size");
+
+	str[0] = '\0';
+	ret = btf_dump__dump_type_data(d, type_id, data, data_sz, &opts);
+	ASSERT_EQ(ret, 0, "unexpected return value");
+
+	cmp = strcmp(str, expected_val);
+	ASSERT_EQ(cmp, 0, "ensure expected/actual match");
+}
+
+static void test_btf_dump_datasec_data(char *str)
+{
+	struct btf *btf = btf__parse("xdping_kern.o", NULL);
+	struct btf_dump_opts opts = { .ctx = str };
+	char license[4] = "GPL";
+	struct btf_dump *d;
+
+	if (!ASSERT_NEQ(btf, NULL, "xdping_kern.o BTF not found"))
+		return;
+
+	d = btf_dump__new(btf, NULL, &opts, btf_dump_snprintf);
+
+	if (!ASSERT_NEQ(d, NULL, "could not create BTF dump"))
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
@@ -245,4 +815,34 @@ void test_btf_dump() {
 	}
 	if (test__start_subtest("btf_dump: incremental"))
 		test_btf_dump_incremental();
+
+	btf = libbpf_find_kernel_btf();
+	if (!ASSERT_NEQ(btf, NULL, "no kernel BTF found"))
+		return;
+
+	d = btf_dump__new(btf, NULL, &opts, btf_dump_snprintf);
+
+	if (!ASSERT_NEQ(d, NULL, "could not create BTF dump"))
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

