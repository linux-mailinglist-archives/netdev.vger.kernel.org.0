Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9415B4F6436
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 18:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236660AbiDFP4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 11:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236661AbiDFPzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 11:55:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E2A3E9414;
        Wed,  6 Apr 2022 06:19:31 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2369l3Gs004892;
        Wed, 6 Apr 2022 11:44:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=/DnWFwGYN/B4rwV2r1g3sFhTJw2RVllkQ4xzzzla0Y8=;
 b=e4ThAWNpWUcPA1gXwQVt7StK4zIPlGgKCJoKk4awqN/7BzA1JwyvIVLQlQeHdCQUgrzZ
 o6yw+CzFbjXLiLBXcifCSzBDOIuW/rDDh3N1RnsNntEY6eg9eHDYqbiBkzyOu80plOty
 wx+s5hYti9iHLIGkhE5X+8JU30YHae7vJsVUcjnEdNay6yUhiraFPgnH3U4FJrACZTF3
 adkJcOduCeeh7ThtNrc+LNlNtF7QCW5h13809dEnUb7BXivUP49P40wRnyU5tZwWf5rr
 8Como6DmOm57Z2RvMAsKTxo5I2rBlUcHTKBUqp/xQ73n/cwJ24mf5Ehusq/IckVU0nNJ BQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6d930pc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 11:44:01 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 236BfXCC009437;
        Wed, 6 Apr 2022 11:44:00 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97trw9bj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 11:44:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aJVNYsLGrfOToOZh2rvTzWf5Pc+LbsCUT9L1WUqPSnMcVasMM0SWSpfCUfV8mlNFd5HfUjHMF9iBPvleZQGzH6zgc4fS/UoK+KsbkEKbv5GBNojdUI1xSqrELQpUVFy5IxCqEIJgva3M//3qoHxmM4l4VaVb40VRezD4ZGf903hEc6NpIF2nfh8k3E2CrqvyUBdZlKOfaPtTahB5V8Y/ndQV+NyIyy0ORuInFhVTMPAiPcmRO8ZiqGk5igJs8zadXP1E0rhXesVWekmRFL7oack5YH1IAS6pgy0CdBLnepwXA2WK1PmZigwYh7SzTIL5ZZEbVlnqoQb9yooyMtgc6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/DnWFwGYN/B4rwV2r1g3sFhTJw2RVllkQ4xzzzla0Y8=;
 b=c42kTF/Xkd2kDiAoDhjyG+wDSIFiVvPRbl1KFwIx/nh3PPrD8/ozsfwNwZ3a8QNm6sNbp8vnvU/L6X/4XfiLCx1iV58SbNiu2CL/oFvtnE9qTnjUDx2phff3fqNKBrYSmw8xG00Syb/erxRLvG5DfR7OwJ3/ykKwF9wgbWabbpWiNYUV1hyd28aQ+eYViMsIAlGsGMpG8LKYbozOGfbxNrRsrO9XVLmkz9uFWEJ+/wGbg+etqzesOHMWnNQrkZRNp5AIJmD0sAZHYZft+TqfqR0CKVuO9NHEk62LEhFnBCQf22GAEJsC8G0FGx1dx0D6ZbF7ZV3Mv7c6bmdViZ3L3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/DnWFwGYN/B4rwV2r1g3sFhTJw2RVllkQ4xzzzla0Y8=;
 b=kQXmMLBS9CqZ2xMKvR+8g1pJHY87ghDwpHMIoLxOLqKokWClGnEPsvxD7sejNacx8d3ucw0hx+dASEnXsL8m3YvMjVk3B6QsjYvGsxZ8AdJVMGwpMyuRqXXq8n1jt7zvLwZZah6viSD63nkx6J2/z8/jdhEF7BEPRhkfeCOmZWk=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by DM5PR1001MB2409.namprd10.prod.outlook.com (2603:10b6:4:33::35) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 11:43:58 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::bc05:7970:d543:fd52]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::bc05:7970:d543:fd52%3]) with mapi id 15.20.5144.019; Wed, 6 Apr 2022
 11:43:58 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v2 bpf-next 1/3] libbpf: improve library identification for uprobe binary path resolution
Date:   Wed,  6 Apr 2022 12:43:49 +0100
Message-Id: <1649245431-29956-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1649245431-29956-1-git-send-email-alan.maguire@oracle.com>
References: <1649245431-29956-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0073.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::14) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3fe0d0b7-5f23-4127-6771-08da17c2bcc5
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2409:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2409C6A74267E16F3564369BEFE79@DM5PR1001MB2409.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nyi5508tf6IEpLTEWL2rkxeva1js8/zhrQMYpv6g6pJZxiX+IXmuuhh0HN0QBF17C6FVX3mjdbIzOsFnESN0J2OTwIryPi2lMbnG0NFY22YjmDkRHtXc9D+Nc69hP4sGsvWNIxc35zaSVQaHqIeRzv4o5ZIVzGXZbCgGO12hG+UIWhRD8qj2u4cmWkjoQnrwvOf0zEsb5CdRgn2gurDCXuFiu3pzEAeQz6PatwM4KP8riYO2RNxMcDt3uRpqFKftWkuxKTh1W7XgpoGIGZw4uEuVn1WOOi1xc0q9F9zcKNyEVOD1HmPpjX4Lq/45xDS6fW8l094BD9xicIPQBup1fRI0N7gSenbOmGahYwSqXTi1urKEHqUdQ6ZNtgqCq6BZGmfmbiI3r/lL+ycgsX5CIV+UNGxgx3q3qtfkk+r49BMUnG2wG1FrNX+S7NcBrzB6YH4Fw4IMaQeFRhDggOmN1X9RNKk4mOkPCP2ieFf8IhAI4SnzJW/6VB8plK+kbIgQ+xprIOpi0T+7SnEvGbazvm7an0KuwotCoeSJnxD27ipR6emccrjxT+inrUwps0OI2zW6VwANe97PpoCVLKuwj3aewy/greo4pn+G+KOjpwy44PJ3nl4MS1cdwWAFkdRUrGrUxvNhHlOtGvriCvZesqrI84ht+4CNN+4N59vOzdpO7YJuBfpJdYOg7DqWKyYXdP1MF/ZbG/gzYK7r9b85wg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(38350700002)(86362001)(8676002)(4326008)(66476007)(66556008)(316002)(2906002)(66946007)(186003)(5660300002)(8936002)(7416002)(44832011)(2616005)(107886003)(26005)(83380400001)(508600001)(6486002)(6666004)(6506007)(6512007)(52116002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NNWM2GVlQEcL2E6IhyaG8qjNEI2sw9PIssXa00BdVAlrFcN/GO4ZxE7d2PNw?=
 =?us-ascii?Q?A5XnB5FhhfZKOam7+lyV3iDcBy7wawt9oteadZ7PrBclO7/+cnsLZYYhNFhz?=
 =?us-ascii?Q?LqerBtxeQtNRudpLz7cqpCuYmigYTNucJ/+Nf+YXdfC8iayFOrVUydre3KBv?=
 =?us-ascii?Q?MjcyUjOOnZdSxQh+meGJJwuaZbPkUmnqnQFT3TlYbBfAHgSvU9PVT2Y6AJg7?=
 =?us-ascii?Q?b4Tm+eGRXmCcLixXFveednXdwXdmvwYq35FGauEbK72DWv6b+0TuLXJOauzU?=
 =?us-ascii?Q?0hbG7FjzhhcT7jn4BVp2VdEaxUwLn3RWSShPa6kAPeRzZ5oseqpRds8tBBXM?=
 =?us-ascii?Q?qJm2rTrPYIz1qfdnX6EPe3ck4+bwQo1DuasBWVcdvTs0D5tvUfLKRGbHyG2J?=
 =?us-ascii?Q?Ny6BjIVkvC/vZE0LolvsTzl7izmtE3puuHlanRQqPKvjcHNsVtatlZvCY2QS?=
 =?us-ascii?Q?YsRsQv55aFhR55EiSLOcYQ6/sDX+vJItXrpL1t8P9MzJIyqy/QSwMTRc+CY8?=
 =?us-ascii?Q?B6JTEzMi1HIp9P+NjA+f/SnKSH33qXlYr++8Sd/cE2BA0bmzkenU1Z24JwoM?=
 =?us-ascii?Q?9KrdSsMIIT+frfQ1BdktLS76vdZR7y33DwwX24d3nh/Vg/lUYifNmGJnKqvA?=
 =?us-ascii?Q?VS7ZJIIy3LNwPujgvx/2n8pMARGGNqEvji7QLwOaVtIEuRr/luM6JmY1p864?=
 =?us-ascii?Q?Fiu0Bzg+DkcOO1QyqyzChUQbZ2V7jgR+uJNDWcisHxTHl8tlYmP6r+Ql0E2u?=
 =?us-ascii?Q?uaFK0JbuEq3dwJgN5RRDOqw0uzScdN5yKZ4F++3DYE1fO9kIjsbAtcq1lr8b?=
 =?us-ascii?Q?3kowpu0zwxdDRYJkzcfh9kUZSAI0VvRayzuqk9Xh40xyLpFC0VywvURCjuQ6?=
 =?us-ascii?Q?ZKs1aRdO7TMhKSmcDvNG7q/w5QtDdhypZ51DmG0J9JHXk053nLWwgX8j/di7?=
 =?us-ascii?Q?cGVneacz5Avq2XbJ03hSgCSQZZfRcRLrB6IkRcIo/mc6fSGTeYRLcHio8MSi?=
 =?us-ascii?Q?OcQ2ukIkoaM6gSKBnN/4MI2LCZLXDW5trkGMjAzsmVb8UV6TscFkhiLPIa2T?=
 =?us-ascii?Q?PNPw9cg9VRywpgmM/tRsDba+lMlnyIqskXsLM5XtQ2PHcCpcQEI9k+lFTqLB?=
 =?us-ascii?Q?aoANSBmmt6diStk8KU//QEmf9IrJDhWUA3FyGJuGnX7iIDKZwJUcIWUg09mc?=
 =?us-ascii?Q?Lx/+iGlTE8iVmyYqcLawadlV/vBP6G9ZdshVqqkT/XeCkTNn8ez0caMV75gG?=
 =?us-ascii?Q?/n03zG7tyTCFqFyYBfksx8WFDLz510j0Vq7MDsKXaZmsrWvbP6ecfgj0xRNo?=
 =?us-ascii?Q?fvViF3aV6VxK1ILddzbUZoqkN3YemNLK8Yn9SeMTFozrRNlJ99kkAd0OkS5X?=
 =?us-ascii?Q?VpN2/OhQYAlGgsEtcAkESg8dH/iw23QY4+OEbQXMRHiqVLExnmN1l/wDznvY?=
 =?us-ascii?Q?N8M9vgt9gAytlpC20j68iuPGCW9Q7uQZVlNd5OdVq+1SKxgKH8wjer5vX+dB?=
 =?us-ascii?Q?EejgyspxN15A527o5XOhnPNKI3bHC8sWVowV5yODnMOxt1D8eVjJIkD2mW8A?=
 =?us-ascii?Q?iIZc5Omzju8kg/S3V0eW44qQleSa6Ik/UxaIC7bCZ/qV9ak03MG8gSvfZBrM?=
 =?us-ascii?Q?amBtnsGNVEK5OpFe3HGfYrhHSQryMuf4I7Ly6ZVUhAq008p9sbvNSdECm+xw?=
 =?us-ascii?Q?Fi9PaqBwbjfpyBJ5RGRq9hZHzL4GfxwPK0B4Oe8xtiCyDVbFsGcTrihTMToR?=
 =?us-ascii?Q?VhuUNVM8dyZ+9n1MdOUdUu5DJz2kOLg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fe0d0b7-5f23-4127-6771-08da17c2bcc5
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 11:43:58.6524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2mrZ1ngg8z093ruYQiBLdfnYnI6YMsarorGO9ETiQuFDeWJh2248asJBBS2GkiPs5jXLWIBx9M0+KBvjEZJo0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2409
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_04:2022-04-06,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204060054
X-Proofpoint-ORIG-GUID: 9ZiXEZnxns8ePTOyVzxwuQFkRj0hN6HK
X-Proofpoint-GUID: 9ZiXEZnxns8ePTOyVzxwuQFkRj0hN6HK
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the process of doing path resolution for uprobe attach, libraries are
identified by matching a ".so" substring in the binary_path.
This matches a lot of patterns that do not conform to library.so[.version]
format, so instead match a ".so" _suffix_, and if that fails match a
".so." substring for the versioned library case.

Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/libbpf.c          |  2 +-
 tools/lib/bpf/libbpf_internal.h | 11 +++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 1111e9d..c92226a 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10766,7 +10766,7 @@ static int resolve_full_path(const char *file, char *result, size_t result_sz)
 	const char *search_paths[3] = {};
 	int i;
 
-	if (strstr(file, ".so")) {
+	if (str_has_sfx(file, ".so") || strstr(file, ".so.")) {
 		search_paths[0] = getenv("LD_LIBRARY_PATH");
 		search_paths[1] = "/usr/lib64:/usr/lib";
 		search_paths[2] = arch_specific_lib_paths();
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index dd0d4cc..0802724 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -103,6 +103,17 @@
 #define str_has_pfx(str, pfx) \
 	(strncmp(str, pfx, __builtin_constant_p(pfx) ? sizeof(pfx) - 1 : strlen(pfx)) == 0)
 
+/* suffix check */
+static inline bool str_has_sfx(const char *str, const char *sfx)
+{
+	size_t str_len = strlen(str);
+	size_t sfx_len = strlen(sfx);
+
+	if (sfx_len <= str_len)
+		return strcmp(str + str_len - sfx_len, sfx);
+	return false;
+}
+
 /* Symbol versioning is different between static and shared library.
  * Properly versioned symbols are needed for shared library, but
  * only the symbol of the new version is needed for static library.
-- 
1.8.3.1

