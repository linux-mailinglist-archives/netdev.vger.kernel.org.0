Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9FE3CBEB4
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 23:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236299AbhGPVrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 17:47:00 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:13304 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235198AbhGPVq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 17:46:57 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16GLfx3E021698;
        Fri, 16 Jul 2021 21:43:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=AlxYj/phCgxYTGdR7RVzbVGMm+oFXw81c1rqU8IQnJU=;
 b=Z4gF3xGP/V+PMJ37TrD8Bfj7JfGfU4cM3f5HAhVVwnjHeybVR7QvICXXtwU0BmWxe5Cw
 tiAhypvchXL4O5qxNUGV0ZyQXZE/m1552EW1aKmcYOKI/2kwTmWibCNEHYVVJeogGixS
 N0V6YgngMYXd143zi4XCOeBxAEn60rhleD9qe7k2J158XVgpS5gvPX+Dx0fqFq6W0UUq
 5i59gBLDJ3UAA0d0IeCIJOxcMpjddRnG8KM6nD7OSWHq1MGzSc+W2WoEkCAUd+Cy6wUM
 VB50QUrFReDCwRfrQGiAWabul/ptWb6lnO+u/zeggEW0UxUwOnZGn/T9j6h0SiiJvs+y bA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2020-01-29; bh=AlxYj/phCgxYTGdR7RVzbVGMm+oFXw81c1rqU8IQnJU=;
 b=hOiS2LsXgnh7mhcwjs/tSMNCZI7hXvH+u05WLwTF753mHqK8mi356EZpcASfZfuvlfAc
 EACleOTWVYWZhk3CRQe3IZ3K4YAjqFZ9fVC4jVFSmp9Y5kj3Ef3VJn2SL+biy9mkSrmw
 GrjZjPf38y/EMETDf7knq4KvL268qddC9uyV5RGRgCH//fAyjYyt2++ljegAkH6m/nIz
 nFOb/D6/RchjQGUCuA+xWzhopS/WanSgHEwEV0PAjCyaHu7RGLMygQZM58xWtWAhBPQg
 O98+b8yNmYStZ4yl+SFIPCMGxJLrajGr+YsWbvio9AHmD8pTJ7Kc0zhEVk6DFa70HZBU Mg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39tw31a8a3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Jul 2021 21:43:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16GLeDk2128489;
        Fri, 16 Jul 2021 21:43:45 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by userp3030.oracle.com with ESMTP id 39twp44090-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Jul 2021 21:43:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cOm5YA/7uEkMLysJi8Ws9k8WL9cQw9YGKBZnTgkOEqAFiziO9PszLdbJaphWkyWQipRIPvs1xd1UucWH30KEtQ/PNdqlRTfZBoWDh9fj1o3myMyvYQ+NlK+D8rgbOcTXVdb2EoyBQNj6ZEJFTOgWJ6WCArlJzd4zawWHiAwfotkE9d2oaBRJfICtcLG8pfUdCkjzGP2Pp6rp+xBVnmzjH1FXIJK5iKKQiqm3So7NcYumm0WVJf4DoDq0LGyTdAcZuMcJQcoZ7FIx3XSsDS9sINYxXWhe6LKBaFcQdf8HUdnrUaCh4//DDiqLBVUWZLvJb8kwScLI+1cMw1Ey4YFOag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AlxYj/phCgxYTGdR7RVzbVGMm+oFXw81c1rqU8IQnJU=;
 b=ZSHjAW8Wr/Wb5J/8asH1POpriQOEUFZXYgs94aa7ZCq81OTRoPzCsFSM3urUU/uIiHVFbEbQXDB78vRcfE5L2MeAvjonRZ7YK95yVeTtnGBXmRvxyDU2ShE9YgHFnr2HpOKtsh06kjYou8+v3Q7nIlaqai8iTWr32UN1XLEPdD97yo5VdsfGABDaDG3R2rd9z4bne/nip0Jqgd0ROLf4exUFcP+NK2YvJ6gre/VOFZ529BHtTEt3AgrPIxpoPjaBaoT/WAOChU3VSMcWjwsMXjg9ntQovl9VmL7KKfuBv38R0Ooz/2EsqvcOdpGj4pC9Cn2lG0lt8NaWhVKp0ZkRyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AlxYj/phCgxYTGdR7RVzbVGMm+oFXw81c1rqU8IQnJU=;
 b=b940KoxpjPHgXZIfyqfjQrOHO7U84zL47fqNEoEQ5psRGr7tLfFId5cFQSaEDpuYLnTiJaPxuRuOBmRilmcm0BJWSD3xG1VFWg4exjWXot/Jfdj857iOpObzq8WzhczCL0IhbDmdnjti/HGEn0QCYsRNOtdaZF0/u6AfBCBaSbs=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by MN2PR10MB3728.namprd10.prod.outlook.com (2603:10b6:208:115::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Fri, 16 Jul
 2021 21:43:42 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56%9]) with mapi id 15.20.4331.026; Fri, 16 Jul 2021
 21:43:42 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf-next] libbpf: clarify/fix unaligned data issues for btf typed dump
Date:   Fri, 16 Jul 2021 22:43:33 +0100
Message-Id: <1626471813-17736-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: LNXP265CA0033.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::21) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.uk.oracle.com (95.45.14.174) by LNXP265CA0033.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:5c::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Fri, 16 Jul 2021 21:43:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57571b4b-9252-4270-85e0-08d948a2c7f5
X-MS-TrafficTypeDiagnostic: MN2PR10MB3728:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB3728FC9104E9A1E5FF610F92EF119@MN2PR10MB3728.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 67g6pZJ6AzkE/AH4DYc3Yn6Q6fJ/EhTB4O4ZvZu2JsEJFjVGq48jO2u3S9KIRj+wW65p2lMeFRtMnXYg4jVL7UFNnqFZs2TGD4wwda7Otoy5mStjEsdv75luQaCEpDIyUQdE79t3ygLq0SqSAqwxBL3kvqhlrYZtxsYtp1+QzK+xk2xD1mQx9y92GLnItlCArFc4jEvblvLKbzb6zPLHbE2hTZKT9BwF1PRpna3KXqVzlP3f3w/C60mMod12e/W+NqGcrZ2jKh3gXGGCwwL8/T4PxyPmsgH9TxD4IlcaiFWLiSh3eC7CUjJoOSGh6dUpLvguF6udeR6Ww88qZJgHDjp6X0tSkmv/M9Sat9T++WC9uo6v5pJFQpysMd2Ye1JO53tSBYr9cKVZQ21LDi5NCsHy9XO5hAVri5V1o3fKXFKLDsPduNWVa0gIKxOARr9CzYmkOfP0yj4RPis0V5x7K9MYhWVwWDosq2bc+YUfHSBX3wDkOQQri/bC9a0w+FSbDoj4CUdtlbfBL8A3RNQ4nVwHgFhfk0U6HyjyIZRPxpCdk9cmkl0vrLWbNuSx6P2jQQ1nfV9HUFzSyU6pA8kdDU3kSxS64VlzgxyJtfCM/5vgZSN3jLusuDBz29f/UyjWJ2zl/dvdOSWW3WhFGPMIh+es6+pPzywDVwNFSNPc7N9g+kRwJJQz4jQLj+NNxpSV5LUXGcfokde38mWRzjQXCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39860400002)(376002)(366004)(136003)(86362001)(107886003)(36756003)(6486002)(2906002)(316002)(26005)(44832011)(66476007)(4326008)(52116002)(478600001)(7696005)(66556008)(6666004)(8936002)(7416002)(83380400001)(38350700002)(5660300002)(2616005)(38100700002)(66946007)(8676002)(186003)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KocBA6r97hC9CNBAKNdCmgN2LMn7Zy9mpV0NQOgdXwM0qWDiYoV/K7iLd+5u?=
 =?us-ascii?Q?tm1ss9AkcuBexodZCsOdPsiuy3a+D7ZEpqbBxt3B3pOJfcn1h1BPjQYipeMj?=
 =?us-ascii?Q?DDYB/N9je099O/uKFKfFQ8p8a70SSfJP0U3CWvYUyWZCyD65jIX8FLS1w5G1?=
 =?us-ascii?Q?Karr4GJ0d+i8/vsAdhVylhkf1sptWuacSNWHJrZbxatFlwrPXhOOGV6ahwJJ?=
 =?us-ascii?Q?rfy+qtekGPqPuOubpxxaEbNwW9f56ZYxZqHkL2m/BFWsv1sRzCFCknir96Uo?=
 =?us-ascii?Q?ctdcI1O+5AgULaZMYnMEtpIoOWksvnHiyYdm8t48DzMUHZG2wFWvRR8u3ahN?=
 =?us-ascii?Q?PyGlbi/j2d/ZZuMkU7eOU2MDHOnPfMfQtovUrnFTMV3OI3dCdM3Fzn7xQUNu?=
 =?us-ascii?Q?WsnYNj8xXWhGRaOZdF1nHVHVEUkzw4sh/KJCNilPjyZcdSAjTDL8sVwI35ur?=
 =?us-ascii?Q?axM097gN7fHX0Azdkmh5H4d8O3YiCFAPc5eyw4Lp4SxgRxMjWMZNDbZdR6IQ?=
 =?us-ascii?Q?eqjrvtDUu1g5jRqWr+blO+egXQmR9MyLUDXHy8Lx4P8cyuq6CHgr8tJGHKab?=
 =?us-ascii?Q?ksFztrg/7IDQscNp9m7UbRpFtiPsjM+uNJM0Iu/9fD6IV50VENxTM417/VAG?=
 =?us-ascii?Q?QGCYH/a4HEWCqA5rBIJU6GUutr9RfRCKoQXb1rcPjdRnKU+8YXz0Br4Pt6di?=
 =?us-ascii?Q?Xx04JwkZcDiNSTdIf0QkvSSayK8JN18vPPD2A5gr3CiqNSGHK6jzZ1MEbyky?=
 =?us-ascii?Q?sYMNoQv6slnp6z+umKIHHaIDeHWwPSYQ3PWJK7N/4i92aiwONWA/3bDQJvdW?=
 =?us-ascii?Q?9jkrL8dH+EkOTNwF/cCBSAlAepY/2V2gqFdoa6Z+TVvVhBEChn0p5SDE9Z04?=
 =?us-ascii?Q?TuaPZNv6fBr8WzEBOA/7hQOBk5OEN6I1BSPH7bn8/gWX1ZYZaw9GvszNvWn7?=
 =?us-ascii?Q?6yculVsBB6YN6EmWSEU3suDjQOifMOFlr61m9xg/OxlMMnJu7Roy16XpjPTf?=
 =?us-ascii?Q?ihA4PmhZXHQcNpLx/zS4/rp+Ni/iO51BgDHbk0K2eIkDwXyWgFeRXJuOtxIV?=
 =?us-ascii?Q?qaizES0uit2NxJ8R17E0SL6OiqatIMuwy1K9SDXyRIx0e+lwzqWM/3x70sy1?=
 =?us-ascii?Q?uzfnO7c9sQTotoLnBH7N50E6sRuFXKNi16zGqtNrkdr1nf90+fmTxUMT8AK4?=
 =?us-ascii?Q?r9pTjmotqWidUrCA0EIgdF2imFtnWT2mQX/Mo5V9uqDichgKOfix5Q48sPiR?=
 =?us-ascii?Q?cAwgcJlrKY+8nqZCyjcs6Wy59srqTlo3oUweuIDmih6xK9kwdTGeLRfNUKzW?=
 =?us-ascii?Q?CXXCwUTt95OI4iWDZIZpZW0z?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57571b4b-9252-4270-85e0-08d948a2c7f5
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2021 21:43:42.8564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3HbuoJl8U/QkTa9rfqiJMnXRiiiVwifEis4J+NU81n8hbKrhSGdlKb7oz/mMeZOIK7551DSLYTLqZymGfiN51A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3728
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10047 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107160137
X-Proofpoint-GUID: 0Lnnayhc4bBK6eGj8G0hgT0cn3G3q9m4
X-Proofpoint-ORIG-GUID: 0Lnnayhc4bBK6eGj8G0hgT0cn3G3q9m4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If data is packed, data structures can store it outside of usual
boundaries.  For example a 4-byte int can be stored on a unaligned
boundary in a case like this:

struct s {
	char f1;
	int f2;
} __attribute((packed));

...the int is stored at an offset of one byte.  Some platforms have
problems dereferencing data that is not aligned with its size, and
code exists to handle most cases of this for BTF typed data display.
However pointer display was missed, and a simple macro to test if
"data_is_unaligned(data, data_sz)" would help clarify this code.

Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/btf_dump.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 929cf93..9dfe9c1 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -1654,6 +1654,8 @@ static int btf_dump_base_type_check_zero(struct btf_dump *d,
 	return 0;
 }
 
+#define data_is_unaligned(data, data_sz)	(((uintptr_t)data) % data_sz)
+
 static int btf_dump_int_data(struct btf_dump *d,
 			     const struct btf_type *t,
 			     __u32 type_id,
@@ -1672,7 +1674,7 @@ static int btf_dump_int_data(struct btf_dump *d,
 	/* handle packed int data - accesses of integers not aligned on
 	 * int boundaries can cause problems on some platforms.
 	 */
-	if (((uintptr_t)data) % sz)
+	if (data_is_unaligned(data, sz))
 		return btf_dump_bitfield_data(d, t, data, 0, 0);
 
 	switch (sz) {
@@ -1739,7 +1741,7 @@ static int btf_dump_float_data(struct btf_dump *d,
 	int sz = t->size;
 
 	/* handle unaligned data; copy to local union */
-	if (((uintptr_t)data) % sz) {
+	if (data_is_unaligned(data, sz)) {
 		memcpy(&fl, data, sz);
 		flp = &fl;
 	}
@@ -1897,7 +1899,10 @@ static int btf_dump_ptr_data(struct btf_dump *d,
 			      __u32 id,
 			      const void *data)
 {
-	btf_dump_type_values(d, "%p", *(void **)data);
+	void *ptrval;
+
+	memcpy(&ptrval, data, d->ptr_sz);
+	btf_dump_type_values(d, "%p", ptrval);
 	return 0;
 }
 
@@ -1910,7 +1915,7 @@ static int btf_dump_get_enum_value(struct btf_dump *d,
 	int sz = t->size;
 
 	/* handle unaligned enum value */
-	if (((uintptr_t)data) % sz) {
+	if (data_is_unaligned(data, sz)) {
 		*value = (__s64)btf_dump_bitfield_get_data(d, t, data, 0, 0);
 		return 0;
 	}
-- 
1.8.3.1

