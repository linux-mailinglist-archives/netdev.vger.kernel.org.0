Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABEE3CBF6E
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 00:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237561AbhGPWuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 18:50:44 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:38264 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232601AbhGPWuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 18:50:39 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16GMfjnT007626;
        Fri, 16 Jul 2021 22:47:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=auwPqAGnnwXkDIkBx2v2BO9iZ931eRgjh4vhAKmKjKk=;
 b=P67BuTly26b0idvCxlQHXWgqSF1hjNnOfLYg2E3dniorvDKsgHp9xw4WJlAahhfHXrzB
 FYPqlD8pMf2dr5jgG+rW09lcezC2b5AehQVTQIIBdc1KuDSRs0aeLz8ykFX4ovNfGby8
 RLBxAaMyq6bpzQ2U+LSbMhiKfvP4+NpKACxboIhZ8Z7YdFcB1mvX25uCZbsHZuGBItBi
 Do+R596HZu25cQu7JWMYepgM532X4H5UjCR4Czp76zhZPSOJ6PS090NX+GfmqjYCvZ8X
 NU7e7G6FVMcgnmGbWCmlJIOo3JgFdJgGN1h1Xp3hgITWf8nke7EWyPfShZS/oHMNn+gU nA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=auwPqAGnnwXkDIkBx2v2BO9iZ931eRgjh4vhAKmKjKk=;
 b=HWm5GGUMclU9vLGtMu4BO3SXIo4w4mV6kNPBfAtQlePDOcfm4PnfX7GjWzQ4Xja1twx/
 JYSsBQwlLIfF8gfXviUPhZNnG98mTvLYNNJEA5aZR5VQjLxb28PX7ASzpyqhpoa8U0a7
 SlIXi7xMjmObr/LCGYcl2kf/SNFXnEvyZVoRw5TawfxLiPxoT01ivafs8T5L1uNyIKpj
 QbHdZ1lHJFaU+alw5TEp4YWHMzB0EcmFsoMV5+omZWPDkWoPemMU/wZyJFA1Kqyv4751
 1BV50LLP3kHoR7sKXJw6yDB4wqM6922mGzIuVeshYo1zFpFzXzTX3FSaAudT7T/2mqeV +g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39twnmac94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Jul 2021 22:47:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16GMequE181803;
        Fri, 16 Jul 2021 22:47:18 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by aserp3020.oracle.com with ESMTP id 39twnhjm8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Jul 2021 22:47:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=igr7WZXbjasUYeUoYIoRCFl7LPXPSl/ytT9RsLjL66lU/LqJpQ1TYkYgCGNCTJiJvDO13ZE14NMUVGBUnyRU9kHv1vYhhRKkUTH+INydEpYONR5Ng1T/oaEABOCI9cZD5mdCvh0i281qTmGOhD9eYhCEWkXItbdMYLowc2308PW0r5uoA0+oVRLggnyEsqAfTCnWwhaL9v+eh2hMdcWMuE94YyR0EZuaQ9ia85l3ZUPug355AZ8/6+8OcSguFnB3FjOu0OvurCkCZC83ZKMi0uwrEiqIs0DXQQsN+o4l7WLp7LAuhkwXfLuZtkV3R/W91SwEc64CvwGYCqLLQnpwiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=auwPqAGnnwXkDIkBx2v2BO9iZ931eRgjh4vhAKmKjKk=;
 b=oZlk4vKyLHSD504yDsIzW8/7pNWU0Ef5uELofuzgtVdXRqCrPe6ItmoZkAI69X3zVMy28hHaH5sRL5b+mxZdKOE/yF9gMsjKIpsYtzHi4yjX0oYoPOsTe91M4Iw5A/jxTZx45Vbp5lWbM197gJSMabhZmqbjDvc3VFvrhf8O60sWP4j+eALUK3pJigbHouKcFriPrfj9mEQ+Im9YM7JxOaHSkohA3/KSayX85q0P9pWy+iWBMBWNgx+hGw0dImlEXYapVak5V0Eiv1n527C6gN5T3nGG1q1354pl00pCevB1+2434HLz4ez8Mp7w2g8we3j+DeWbvS1JhR+51AGIIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=auwPqAGnnwXkDIkBx2v2BO9iZ931eRgjh4vhAKmKjKk=;
 b=L601U/1W7ZMGe2ZD1ybsk8p07FwQrLuzLvtpHjJ0hab4lt6Kqo5hdBp4aVmLQToHE9Yk3/l+GgUv939VbaVc2987qn8zx/W6Q69CcTgWnudY+8ijrZy/OgsZ/ikfvG7o1bsyFLkfz0FLEzShvC+Zzw/KNkLwYKaSbmbo5QgLyJo=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by BLAPR10MB5378.namprd10.prod.outlook.com (2603:10b6:208:328::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Fri, 16 Jul
 2021 22:47:16 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56%9]) with mapi id 15.20.4331.026; Fri, 16 Jul 2021
 22:47:16 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v2 bpf-next 3/3] libbpf: btf typed dump does not need to allocate dump data
Date:   Fri, 16 Jul 2021 23:46:57 +0100
Message-Id: <1626475617-25984-4-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1626475617-25984-1-git-send-email-alan.maguire@oracle.com>
References: <1626475617-25984-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0058.eurprd05.prod.outlook.com
 (2603:10a6:200:68::26) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.uk.oracle.com (95.45.14.174) by AM4PR0501CA0058.eurprd05.prod.outlook.com (2603:10a6:200:68::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Fri, 16 Jul 2021 22:47:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f8e13ad-aca6-4f32-19d4-08d948aba929
X-MS-TrafficTypeDiagnostic: BLAPR10MB5378:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BLAPR10MB53786424779EEB18D092BF33EF119@BLAPR10MB5378.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yL8KaByptLfebMFvrjKRQofiBm5rGUsATaNYWvsmrUTHzOye11ssdyqkJxYOxlsPPdyFbrSEZGsQ+6Hxw81FBXjpmiGq5VU65czRJXZFGZ7+Lsc++HzcLOs6vV0GRYp17JALOKTx6SVxXbYOCG3E2bGtYFAPO201Ymie+ilJ9Exuiy2MoKBUCcTZnzEBYUwwg92RGdbCErr1XhE0vSwvv771RqKUmE0HbWRCKZuLYSBbqXsAf+y0Stz1QdjKFn8blLmPKLwUfZDM1mUMq2EShOKgFpPgLugIYasx5q06rPnbSphYW8so+heJz1Lv0OcMhJZ7OiJtjNnIUDbAEo5jpgOZgEMzQNvetglgb5idmra1Nk/LuQLHCKH6OSxxDHEdFu7TquTbOfzYNy5Xq2oST7cfk0xl+BYv3E35fWgty1oYsqgKNXjbGcbb3jC2sShNrDnchkpR87szgcMeLBauxTLliMmtds4DVZ6p4a+t88OOxscxWS5z0zeGsDURsy451FONBOpvgtmQVUbxLt07nOAQLxODq7m+cyDFlt5FK77Y78ymYrMJG6hR0M7xav/3M6ARAp3n4u1pFD6cYyKZy8W2PFkhLgvOk+rudNrM1HWwBYKJQTUxQAwI0yMfmXOPPRo1jeSvTkXHAZ8UjS91Yf9R5hcBy0hEoyaZgr0TaBq+OGB6TApXiRLRvV4/iuhA4VugsDW5hKp7xZ5FIuuWpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(396003)(136003)(39860400002)(83380400001)(2906002)(6486002)(8936002)(36756003)(107886003)(6666004)(4326008)(5660300002)(316002)(44832011)(86362001)(38100700002)(478600001)(38350700002)(2616005)(7696005)(956004)(52116002)(8676002)(186003)(26005)(7416002)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?29O2wQQBNzwHqgwAG4zvuyPWvUIcGlQ173tojvxmqya71LrncyAMjXVNiAEA?=
 =?us-ascii?Q?2nvNgSgiPq8MEVHXBnEQh+38QTgyRC/8HpsE5Qvcv2oQ3LaFCt2bcpVG9PfN?=
 =?us-ascii?Q?BOsktjYbRfoHtUFxzcV23FOGc47JtgIIJ4qZu62Du3oLxRuJTvzRRB98AVIR?=
 =?us-ascii?Q?nTyjcSpgupBcIvReWbB8dsiX3X/2E+22bmv7q5WMsGyVsGGJcAVEtJGDbTGh?=
 =?us-ascii?Q?ubWG9Zc25FY9CgsyJFu/4SOqRcwBPhKc0VIOh6WixtSl8+lFIowtyPTUFJOM?=
 =?us-ascii?Q?0atmQon5zHoufhkVJtNaESohja5ZMvKV4ViV9drji2DYIX+zi4qXvsai8MPn?=
 =?us-ascii?Q?lG5BDJlXOdi3De6es9i3FG56VpHzyaMhtli0nvLd8RDceroo9YKN9HfQl4AC?=
 =?us-ascii?Q?v8/U9VAh1Vz369grV8LVEfYpeuEtD49HAWiLuAya6BMShy/NpPZbsu6L97Ke?=
 =?us-ascii?Q?pTKHDMUkM+cQx6/ExET3agAw4QCceiv1k54i4Rxe6W5uFv8xV8U8bPNxuDiv?=
 =?us-ascii?Q?T8ZIa0KErsfX2+f703vR06AFVe+tlVaarraP+vzQ9K2J0jmXnniQCoIutQtE?=
 =?us-ascii?Q?pvnawKu01LkqYT0/dG2YEE5PuEZmT2PuDaVhfZSAqVQvY9q4KinOTevKpPd/?=
 =?us-ascii?Q?MWBJ7CS6M0LaThdFRaXXl+LPArCgLfEYyryQ4DcDfiPwicNyxF8YAmkd/FUU?=
 =?us-ascii?Q?KX9bcx+UyzEZpp/92skwCOGycgz5Kr30miI03G9mAQVCyMnPEaPaHP/RJ9no?=
 =?us-ascii?Q?G+fLiuITHE1lcQLIY/wnEa1a6X0PHqSYV8HMAvTZAtvGSzPlV6oPc2kAJMkn?=
 =?us-ascii?Q?zDJV0hl4HedtAo3SaG+rhwsd1O2DNl+iMD40lVnATe5AXSpyeIwKcIeWScsI?=
 =?us-ascii?Q?kXznxpAWkvPdXaLNfdDaLQGttbwucEDRWLlJgRMD6WIDq/rPlMhl6EQUBX55?=
 =?us-ascii?Q?AkVc7MoTiQ6BDfIZ+/0cMJg400beRwsz1poefD1kokspTk8K+RFpt+m5hQMa?=
 =?us-ascii?Q?wSSczmQBWgQ7oKx/elEoU8co4k4niaccPNEBo95XJrO38EfTEp/hElKlJc67?=
 =?us-ascii?Q?x53ia/ojzfshgn+RK+YlLkE0nkmQvO4QhK791GESx5M45drKJ9cMzf2Owgoi?=
 =?us-ascii?Q?/XsEG/aUNkd5cJkzMXrK9Qoshx2xOSDGQbiSgITrqo1t4KmJ3dWLFevz7RvX?=
 =?us-ascii?Q?7vlPWrhhVMfVqYiMFwHuVBdq83aatmhEAjmPI6aiom2ZJsz809qLlMaXpivk?=
 =?us-ascii?Q?usYQU7CaqY0I1y8i9TnwZjdpwX3EMT7fxO1d3upzfqdzaKxl4atUcrYaVCtv?=
 =?us-ascii?Q?EwzzPuSTmqOsdXxmFrcE6zTO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f8e13ad-aca6-4f32-19d4-08d948aba929
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2021 22:47:16.6297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p5+h9RrbPgkWfABSHSBXKrx021rhmwOxcQxhjv1y3popLunyhuqmJMF6BSlAHugZEkyFOTJpLH3ZF9B1KPz+rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5378
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10047 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107160145
X-Proofpoint-ORIG-GUID: ZYarI40cWSXmbqcfVX1cTsom9V2ZFDOO
X-Proofpoint-GUID: ZYarI40cWSXmbqcfVX1cTsom9V2ZFDOO
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By using the stack for this small structure, we avoid the need
for freeing memory in error paths.

Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/btf_dump.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index e5fbfb8..bd8e005 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -2240,6 +2240,7 @@ int btf_dump__dump_type_data(struct btf_dump *d, __u32 id,
 			     const void *data, size_t data_sz,
 			     const struct btf_dump_type_data_opts *opts)
 {
+	struct btf_dump_data typed_dump = {};
 	const struct btf_type *t;
 	int ret;
 
@@ -2250,7 +2251,7 @@ int btf_dump__dump_type_data(struct btf_dump *d, __u32 id,
 	if (!t)
 		return libbpf_err(-ENOENT);
 
-	d->typed_dump = calloc(1, sizeof(struct btf_dump_data));
+	d->typed_dump = &typed_dump;
 	if (!d->typed_dump)
 		return libbpf_err(-ENOMEM);
 
@@ -2269,7 +2270,5 @@ int btf_dump__dump_type_data(struct btf_dump *d, __u32 id,
 
 	ret = btf_dump_dump_type_data(d, NULL, t, id, data, 0, 0);
 
-	free(d->typed_dump);
-
 	return libbpf_err(ret);
 }
-- 
1.8.3.1

