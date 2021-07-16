Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1A73CBF71
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 00:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbhGPWux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 18:50:53 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:8612 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230399AbhGPWuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 18:50:40 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16GMgNT0020076;
        Fri, 16 Jul 2021 22:47:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=fdjorHEFhu2yaIC1cgldbiFo1kZZP2Dd+W4zRfcn2DE=;
 b=VHOQ60aaq9bI8EwRSfmAfDS+FHjsoVmaCckkq9uG+OcTDPGVi92XY/ouWmqnF6TtGj+A
 tQOQvP6GA6UeYLM/akiHTghZwAqYIYK92rarwYiK7+FQdedbRXRVTtr2oi9+QEN1HrkA
 2gvtY9h+THszYHEoBbCRf5EoGHhF/HAt8HmopD4Mwdzu64sNuAdcsMIb+Nk1ERTUegP8
 KfmsS/deMi2rDkkENUgJJ32y54A/lgwYIm8KMpdI7is+DX8zdWhfwqnbOD2/BWA2W0Tg
 +9DJwWLoMF7EYlEGOmu8HvsoG+88Ozp3F8LoRj9oCQ45wCY3Rr//7uSpmNmlrcVUjpLQ SA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=fdjorHEFhu2yaIC1cgldbiFo1kZZP2Dd+W4zRfcn2DE=;
 b=YUULF0iZkyKwhLeYgc9MPbF59/CVaiygPaXg8ei7KuESa6wV4cJDfYUvGRUUWyalEQId
 r0q6s3PEOc3S21KG2ajh5IdVfh8Mhp8rOukBnxhrEYirXGyIPCYCk8lD9txWBrmriIfk
 WMmFCzj+9w7jBbsobwduPeWF/dKsENxhVT/CMEDJIIru1JTgX7NlpQYZMz1L3Q78eyYT
 /kkfKYM/ZH4G/pTjs0/4EP03i55Fu52iwRz2ZS4Sr0n1htR8+SMEQzndOKb2dON65Rjw
 B/rt0jiw8hKJQMES6pU2daXsiuceMVzvm0vQtNnZr3pi2zWIV/kmarvTXBZP0Pdj94Jg VA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39tw2w2c84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Jul 2021 22:47:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16GMdtdE186272;
        Fri, 16 Jul 2021 22:47:13 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by userp3020.oracle.com with ESMTP id 39twqrx98t-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Jul 2021 22:47:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P2bJP7xrUw8AHMeAYIB5aG1o27BX1ziSJ9Q8N44JH0wT4zWjHYkDS7k6xdfND6s1xhkO80OUJw8lOCg425MRgz/zZkPb1i70P2vqO+32NH64h+8gIFdLqdtxiFLmwj/w7eEmdxyZeqIG+9/LWOXCrRnl7vSzpgrXV3eNbxSlbdbWPU0O5gKvRj2rUnhf75cr1bCujgrtGK2viKawFukuIs2uHBXRW3vFnAOYMdGKySblYmxvRB8EHMNSgse8rIoyKakfzX4OjifzEoLZVMuME/WTg9GLp0TJunMiisExlthSrKD9FdS19l5VdtDDbxk0kGGqyqb5n+8moZNTcn2qRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fdjorHEFhu2yaIC1cgldbiFo1kZZP2Dd+W4zRfcn2DE=;
 b=lIl7L3XjXrZ9QuyMTnzNJ5Ug6Kb3KnDxBQQZ/HsjZ4OhwRJGdwpH1MxcPYoXJrSetBppU2sLT8NCQ0miiuNPdV5R26QbXlEXoKUBJxj5fcqnbZhAhAVgA0LvHPTXS9UGB4zphhJu2gavheGrOJOef4CQC6GMlrVoqj9eE/t4tLInN0epKzmxZHiWjYkz7tNBwqHoWxFVaPIm0VZkfPFYDWuW9aYUcUVpZB1aOTsVkmMmCod+sxc8BN+ivY3M+O8cldKS/WhsHMxtfIPYBEFcejTmc0OevCKEZq1ZCeLUy+OtosxM21Yyri6kCA6zyg0UTLHCFngTeYJDmNZWAd1fbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fdjorHEFhu2yaIC1cgldbiFo1kZZP2Dd+W4zRfcn2DE=;
 b=dW5cp0jisHufMgX8TEiId7GVsyyEGZhLN2qjWjDgV/7bU/d8rDo/BuLV6d5pgCxWiiThdlF15QvyV1IDaqeI6rgk0Enq6gFI/EPbhKoiAgY2vntFNVeQ/UQPiLVWvBt4+j4zdzIaaEqXsGM0/GCC1sfCJxHxrcnCMWpDUdTk5UI=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by BLAPR10MB5378.namprd10.prod.outlook.com (2603:10b6:208:328::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Fri, 16 Jul
 2021 22:47:12 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56%9]) with mapi id 15.20.4331.026; Fri, 16 Jul 2021
 22:47:12 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v2 bpf-next 1/3] libbpf: clarify/fix unaligned data issues for btf typed dump
Date:   Fri, 16 Jul 2021 23:46:55 +0100
Message-Id: <1626475617-25984-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1626475617-25984-1-git-send-email-alan.maguire@oracle.com>
References: <1626475617-25984-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0058.eurprd05.prod.outlook.com
 (2603:10a6:200:68::26) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.uk.oracle.com (95.45.14.174) by AM4PR0501CA0058.eurprd05.prod.outlook.com (2603:10a6:200:68::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Fri, 16 Jul 2021 22:47:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78f1e505-0fe4-4aa2-c2eb-08d948aba689
X-MS-TrafficTypeDiagnostic: BLAPR10MB5378:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BLAPR10MB5378CCFF2B0627C3AEC7C11EEF119@BLAPR10MB5378.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nqb4br0ww606Dh6KZ9FeZG06xpX7ErQ/HmwHpxIKTl/9sUEZN3GOiNtrUwopnaNExXOasNd3PO/2Vx4QAFMQn1ySCAL8tUr9LzqVOoBUVisdkR52t6pjdDwx+hg4RvAW+kvkCDSWZ4ur3p0DvWX2K3NNVCgAOp3MYaxwmmrqrI/43t6sd+2mILCSnA48C6TdYYcC2w2c9aV+t1EX2qpDtz0pZaBwKDk09ybJ15b6OTnPSabH3EhDQg/zpej9UyJvBBnI+QmvdcnG4jG5JmLnwJJzltr2reduy1JfA7J+4aiApIQsmH4Mi4aoceb9QgVVGDcEkegyY7HzAlfObQp2OEdw/Hm0ZmvBDWvD4zD1uOQZNfvpGkQBVzvtE/Be6stwkEx8oK+02yLmHwrBapIDDVEN2pYQUg8+GMOTu0AWwzgbg4MI3VCH0IvGidUCJSGUjKcwhZrgpVEOSdG/6wEWKtzrL1CCodlSNQ+Ikz/2CYZyXr0VzOb039Nq5+nxYnKaPsAaTXjnY6wauWzRvdw4T3p2EvKlr9TYn87NPvvWwyR8CS+Ciyg6213hYJ7mJj+Qsfd+gHuGpFhN4EnDm0xmhEdA5BxvWNPdDwTWBxz0HanzDEgPEArtUgpB6f21vAvymO0UrurDd31KMIyk/1Qht8wIR4ZABQV5nVdjoJT2Gfwxq/FZwt4kq3Hl1EWFsAAFZLMsqrHxusDW3HhPKaN4rg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(396003)(136003)(39860400002)(83380400001)(2906002)(6486002)(8936002)(36756003)(107886003)(6666004)(4326008)(5660300002)(316002)(44832011)(86362001)(38100700002)(478600001)(38350700002)(2616005)(7696005)(956004)(52116002)(8676002)(186003)(26005)(7416002)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sq55S86bTx3n7UmqI23rF9SAiRobAvZMPuqRqaAwRkJvg+NwcAIYxKUn457W?=
 =?us-ascii?Q?0uITULIV2tXd6N9+54ZUkHZSj+a5r5IfuycIdVRHKZhGPVxQ8SiykXqza4jK?=
 =?us-ascii?Q?OGsuumo86jmBFLsOu7qRFaFwcBjA2+ij4IyH3xlM+AzZDmoZEzo+QN8B0L+p?=
 =?us-ascii?Q?jbzRdRBcLIYgGOGwmpZO8xU9fAbvJuqFVa0sC/V69kCjIDbqU74kwSV3D6Om?=
 =?us-ascii?Q?1rfomSp74eSCL5L+kqugesb+TD6eyGhhKoOrVgMIbn6ccd9YGBIiOAWtG5pu?=
 =?us-ascii?Q?U6I6lYBe9uQEfvIja+UQIv9BfQWSc2RuQHzcMbz25I3h5gBvwchtnVe3T98+?=
 =?us-ascii?Q?iManQpYEG6/posxIGfpRvBB8hFDYz4ne4Bv330D5hV5igs1Sv2V1NOHz9buy?=
 =?us-ascii?Q?pXCRhZXpp8RwnMuJPNwRwV6um+3xtJ+Ed1JpA3u6e9cINtsnpSZDa61M1EWc?=
 =?us-ascii?Q?Ph0aKAqusmsJq+nm2JPbkbfLwH0lb2IwdVRVy7FzXiFD8cw6YDpXnc0ymnAq?=
 =?us-ascii?Q?weF8wCGSSjLUHzEtkNaLEbBQaxUj63v9nBWSq0pluWq1FCeM5VmbmLZC5Ktw?=
 =?us-ascii?Q?0mP7/p4kKhyr4/cTMdlSI+SnDZMRG3duALqz9r92McXUTUM0wZWX2G643f9M?=
 =?us-ascii?Q?+QwUdB5+QWSKgJy7xmVB9arlGoEURifllPzstkQblK1Ay/YRyzjkUGCI+drR?=
 =?us-ascii?Q?obxOK7BUTJ7k/FLixbrZdCSVjO5aWQUC86P3cc+YLbNnPUw4I6bkDKd9QIBw?=
 =?us-ascii?Q?5HM5xTrdQUqAhTHW4v2vGvTRQbSijRIQH+VxnUO1rsmI5XWyx8YaHponbN5U?=
 =?us-ascii?Q?37uzaHOOuF+nsFvtgGv/lBZwWAL7SoHsxDda8f6fRkY4svZR1h1+O9NoLxwn?=
 =?us-ascii?Q?JwVCwZwDwFxceKFXeqaPWUyHbb3hdndqsBU8OZ99bhnMFQv/QvKf6tccm/fy?=
 =?us-ascii?Q?hrG8lYUrvydqtYL8B9fXzhsBUb+j8tM9tR4V4V2YiD4JZi6SJ5wg3uKy2K91?=
 =?us-ascii?Q?S5uRCEsBxuEyWvcGSvq8M6LWhRIK2AYYeLi3kn+X1AruwptsnSaPu1NHwZC3?=
 =?us-ascii?Q?CdwEbgU3sm+QERMwyC7KoAN2m/uF/fz63+uoCNigIAH1Ska8eoRQB0/+NhxD?=
 =?us-ascii?Q?GOTmbksCmhrwJWfeOn7dEMmmj/wWd5MPjtgKk44C4K5wWxRL34kHZY5ieEBC?=
 =?us-ascii?Q?2yZYYpsOZRkgq8HXUUXL/6twhGo5SZ6mtE/THO+G4HJZxeAthPTFoyOR8WoR?=
 =?us-ascii?Q?Cmj5R7rxNwh8zaGhK1zeVlaGF5R0q+VImtBYQbaxVTMf6oSuNY8XBKiT9UOR?=
 =?us-ascii?Q?Eww49ztbmzZLkWQhjRPMoqsq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78f1e505-0fe4-4aa2-c2eb-08d948aba689
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2021 22:47:12.1265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aP+OxD/6p84qx8XJctBlVimSWFIf20mI1leYVg/uMSEMYGADdzPFoHczjnERrH6ER5oc7kWY9JROZsja6RZrlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5378
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10047 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107160145
X-Proofpoint-ORIG-GUID: BsslnyrQse0SUwKO3168l1jrbPhKaK5c
X-Proofpoint-GUID: BsslnyrQse0SUwKO3168l1jrbPhKaK5c
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
However pointer display was missed, and a simple function to test if
"ptr_is_aligned(data, data_sz)" would help clarify this code.

Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/btf_dump.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 929cf93..814a538 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -1654,6 +1654,11 @@ static int btf_dump_base_type_check_zero(struct btf_dump *d,
 	return 0;
 }
 
+static bool ptr_is_aligned(const void *data, int data_sz)
+{
+	return ((uintptr_t)data) % data_sz == 0;
+}
+
 static int btf_dump_int_data(struct btf_dump *d,
 			     const struct btf_type *t,
 			     __u32 type_id,
@@ -1672,7 +1677,7 @@ static int btf_dump_int_data(struct btf_dump *d,
 	/* handle packed int data - accesses of integers not aligned on
 	 * int boundaries can cause problems on some platforms.
 	 */
-	if (((uintptr_t)data) % sz)
+	if (!ptr_is_aligned(data, sz))
 		return btf_dump_bitfield_data(d, t, data, 0, 0);
 
 	switch (sz) {
@@ -1739,7 +1744,7 @@ static int btf_dump_float_data(struct btf_dump *d,
 	int sz = t->size;
 
 	/* handle unaligned data; copy to local union */
-	if (((uintptr_t)data) % sz) {
+	if (!ptr_is_aligned(data, sz)) {
 		memcpy(&fl, data, sz);
 		flp = &fl;
 	}
@@ -1892,12 +1897,29 @@ static int btf_dump_struct_data(struct btf_dump *d,
 	return err;
 }
 
+union ptr_data {
+	unsigned int p;
+	unsigned long lp;
+};
+
 static int btf_dump_ptr_data(struct btf_dump *d,
 			      const struct btf_type *t,
 			      __u32 id,
 			      const void *data)
 {
-	btf_dump_type_values(d, "%p", *(void **)data);
+	bool ptr_sz_matches = d->ptr_sz == sizeof(void *);
+
+	if (ptr_sz_matches && ptr_is_aligned(data, d->ptr_sz)) {
+		btf_dump_type_values(d, "%p", *(void **)data);
+	} else {
+		union ptr_data pt;
+
+		memcpy(&pt, data, d->ptr_sz);
+		if (d->ptr_sz == 4)
+			btf_dump_type_values(d, "0x%x", pt.p);
+		else
+			btf_dump_type_values(d, "0x%llx", pt.lp);
+	}
 	return 0;
 }
 
@@ -1910,7 +1932,7 @@ static int btf_dump_get_enum_value(struct btf_dump *d,
 	int sz = t->size;
 
 	/* handle unaligned enum value */
-	if (((uintptr_t)data) % sz) {
+	if (!ptr_is_aligned(data, sz)) {
 		*value = (__s64)btf_dump_bitfield_get_data(d, t, data, 0, 0);
 		return 0;
 	}
-- 
1.8.3.1

