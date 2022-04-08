Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E25B34F9FC5
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 00:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235811AbiDHWz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 18:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237230AbiDHWz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 18:55:27 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186D7A146D;
        Fri,  8 Apr 2022 15:53:22 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 238LH6Af014737;
        Fri, 8 Apr 2022 22:53:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=/Gifo4HUYQyLLitYneboX59wA8qb9JybsgkPe1cyx60=;
 b=xdz1DCO2DSl7oKIqg/ZjQOHm9Ht8eGZ1g1x1QxaEVUUDhunWVtEMUyH4mkfuMe5F5ZAe
 zkoTtRJrhskCQHZTYUcN3hZyDBjQ/uu/XRqjPpohoiGiKm8YbYhSwVc2YI7jPJ+i7ohe
 6G5YxGoB/2G++CwAkUGqiZaQF4+iHZz3584DV+kSstIlJyJv5btBrY4iMhnEKjVpE9DY
 oLbjNHKvdwDg7PefOEApWEIfadpPJbnNcG8QdBZPDXYUP58E5b7zRK396C/rllL33Dhf
 VTTAxPMuSlPgespeYFXFG+SDYeWmKYPERaLEN7iIBjQxK7J2iPKrsmc5jq2JD+3X0BAn UA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6ec9yxcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 22:53:05 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 238MkvLv029275;
        Fri, 8 Apr 2022 22:53:04 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97y9e12s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 22:53:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dcS5d7GkDRy4Rb1IcEKd+mQ+srbEiNhY8MSuycF0yuQbsfN4Hin70xnNcHe9RM2gqcXjOId01NSak6G9NeM2iMNpnPvxCe2Es+EZ5SCNHm3YsaxY6a3ZEelw+npXTWg08WzYwe927kM5vyWqtB3HBZk35tocvWPkpXxpCvGaGISyPWQH3CN3e9eIZ4iuGtkpdHqsa7UKA77ynx4K6j/HSfCZQrEb55is3M3saZYT37IovPW5gTN/gzv+xT9egyQyHaqqapDCWKILmlhzCpx8J4QOgmlxsj67T8U7NOBVgb3d151u5pikyTJi6Qtr5ck+FHoUengFbD5m92GTPfuVzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Gifo4HUYQyLLitYneboX59wA8qb9JybsgkPe1cyx60=;
 b=VXCOw06+CTmbXBJPBGHsQzONqpN0u/cnqsfdNNTKCi/vL27RhJI/6bwc2Cnu5VJ4vYP+dQM4ip7EXD6Ux3NQEGuFPQoRhkkY5uTcaY7sCqtbnOqm5f7okHXR1bIxqeymGLVV/GFZcY5N5cItPRgYPNx2036OL+pC1hiR1Y1+5XurLC2sR7GO89+bmFS3HvtV3JUeVy8fPrFklI5PZ7HTYFBk64uryYWrb7u8qpVGeO6ll0sJGwceel727hz5OOTLkE2XZRVrkV737iXoMgDxXSmgjBP+sax0lB0HVvONG0KaxNgKI0zb/nS7mkzA+mMvPdc5H+eoj/GO6zg6eNN9Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Gifo4HUYQyLLitYneboX59wA8qb9JybsgkPe1cyx60=;
 b=Ycdxlb+MsnJ4URqRgVrxOOgDRAfcxAdIPf1fjyXwvwu5Gwm3Z2tJLi8dhKIMcZvSr+K8Ou+Y72qzduvVrupEIAVthnGgM/rTyE1tgLrqQVhxuS2ZSrzwtkO7+qEuTWoPYyc35e/Yg4U3j91boPgooyUu/sfU02oGQjf/Qkr8c6s=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by DM6PR10MB3705.namprd10.prod.outlook.com (2603:10b6:5:155::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Fri, 8 Apr
 2022 22:52:58 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::bc05:7970:d543:fd52]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::bc05:7970:d543:fd52%4]) with mapi id 15.20.5144.027; Fri, 8 Apr 2022
 22:52:57 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     andrii@kernel.org, iii@linux.ibm.com, ast@kernel.org,
        daniel@iogearbox.net
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf-next 2/2] libbpf: usdt aarch64 arg parsing support
Date:   Fri,  8 Apr 2022 23:52:46 +0100
Message-Id: <1649458366-25288-3-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1649458366-25288-1-git-send-email-alan.maguire@oracle.com>
References: <1649458366-25288-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0047.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:152::16) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b17a5588-9580-4b04-1eee-08da19b28679
X-MS-TrafficTypeDiagnostic: DM6PR10MB3705:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB37055EB28E387DF80442269BEFE99@DM6PR10MB3705.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E+yFKNFBK0wchcKAKxcqwP2LtO6Iifv37vDWxHUFnrdf9E5TxEBQbt7E5s2OaoMCXuE7RaH4NEgbDbuen28RNgs2bIAo8KrcuZ1+WKuSVfxN1r5tK14fvUFBTTg7HNCGW1XqJ41RjOIuspjDaShGWvbjhFf+0JU7kCnewp0qS6aHxKDaHF2i4EKWss8VFAwVRIkkn52zokMYbmexBKZfesHPToDnGCvAn5OpN9ULwA5I62k1ULc+1D3H4K4CQqtQCg9dMWLP/l7oMdTWUvZTOQDT+JRh7Ia8ldBoHzPuP1k9QaSK37FAWeloJx1utzNsgQpj0Oxvw0YHhqPjbBJCWCJ/kCzeAOOLvRtR1amZza92wY75O6HFozCMWRhwHaxrhgJpgrPGKXl7PyfsaF4fAH9WkSQKqZ+IK3554p3IM0XyaT4yvovz6chFWnfxnPo5X01Wqmw0s5Duw+s7P9BZ5gnSpogI9enaYKgq0lUCdFEEhkryo3qG2YvzNYSX6gh16G7J/S27RWMgXnm7nfI7Jzvm9I5s8P/PGlpnDri4EqsBsOQrdULkL0b8w7k7YoL2zuKfNPxhogQWQO+NJydOq4CxZK4MKA8Lc93HbU7X7Uofr8duRK87oPXUB81w1lNRFYS5m6L5edw+QnWp+VBWWUVj+29+odar5p2lPubL19ZFdDnJN+D73aB9kWAWH4HYFo5fIFDhtF9UooQjkZnP8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(86362001)(6512007)(36756003)(4326008)(186003)(66476007)(66556008)(83380400001)(5660300002)(7416002)(44832011)(6666004)(52116002)(45080400002)(6506007)(6486002)(8676002)(66946007)(8936002)(26005)(2906002)(107886003)(2616005)(38100700002)(38350700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+ppRVRH3RFLY6p3tymRQSMbzz+qxuSCC/DptzUKivPPvr8crBNRy30GaAvGG?=
 =?us-ascii?Q?myZ72mA8zfF1kiDwkxPLJ3YgJu45PFnfq5ctOyYh9eXtbq86fCL1Plg63QTh?=
 =?us-ascii?Q?4xyiA81NiZZUZWRQGX0KnA39gjYaIG1qQLwCAR6stj45d96hW2KIxVuYla9i?=
 =?us-ascii?Q?5b+p1k0HJ1I/Dh6M4O2exugPIQEnlZQhX8QU/o8eSx0oINEd1E8vX/FCFU7v?=
 =?us-ascii?Q?HQSEISC1S/TaXPzbs1mNs5wZm6u/s+DU2hdFcuwwtI2TOfoQ/9ob8lzTAGGy?=
 =?us-ascii?Q?gFgZJYUUMPHihWD/PPdIHKuNlFiDqr304Bqh8N3Pumfjv/lP86GFJSQ+NNJ1?=
 =?us-ascii?Q?RK6dmikiNKF5vNJqDtDWEW2p/9X9b5fosVvYk5TH3uC7k9c5K9uYSYNWM99a?=
 =?us-ascii?Q?r7+tb9ZCN1YG9dQh83sy2IxD+oCdqltW4A7XOPcC1t3HPcUUKEa8XPykwwmJ?=
 =?us-ascii?Q?1fuCsRRGEJtjDDXMO2UVrJG3J+h5JcyRkd0K0TQ22qGPrmN02tzDkuHeSaOY?=
 =?us-ascii?Q?vNnJa2jquDD2L/S0FiIsc2r+x4k9mMvmztVMU95C0T7AvQKdsVxAZvNq+AQ7?=
 =?us-ascii?Q?FVqIsQThkILPSPtsCqsxZT8pEVuQ/ySrLIrOl+HWPtuWo7iCW6IZpvhPGg3L?=
 =?us-ascii?Q?gTkbp6ujHxNpAgHu8DO8973IO8nUmfr7U6zt5OWf3u1VZde3mZ+YnzjtbV0+?=
 =?us-ascii?Q?muQPnarzNq3zJ9+bkVW3YrHhiAOlrvKRq9yfkzDEcNcQXidVU8WnxPS8UPv9?=
 =?us-ascii?Q?y/ymGOi4LOj4y4Lc8vC2QJZxESRWKSBY8go79CfA5WkRfdL0xqM0vpgrkmM0?=
 =?us-ascii?Q?jcdJwOa0aW5waqDezmZY7ED5XpxmYS5X0+MGADdkCCGGajH0YLd1U4NdlvZA?=
 =?us-ascii?Q?MeaO1pOcaGgDetJcbDumrAAiy22oo44kBQRcI6VT9u09qfNUm5ITCDIeu3LU?=
 =?us-ascii?Q?U//ptATyQT4YxtJGigalSeskf1sRnDD+QDE4ZqwgzfjLPGQw1mS/jak+cdEc?=
 =?us-ascii?Q?4fCXfSPvO/X1FhP4ElL0dTdKP16zVhAjmUaGNXqOty4f0vR9hMBhg5wz1OAU?=
 =?us-ascii?Q?aMX8kHdIKKKZmG0LuOAoU3idLo/sTsdB08CwLYOZ64o18PkhEWUn+X+nR15N?=
 =?us-ascii?Q?ncm8qI+Iub74xFjmntuGYxWrZtPpscxSxjIoVKb7B09RUwnbgZFKRiAHIbqO?=
 =?us-ascii?Q?fd/23jo9ty416QvEdgFw3YPYkNaI9Aoqh38kz+ukJk/S4fnu5wPkfxvqt+5+?=
 =?us-ascii?Q?SVuywH6tYJ5fL8q9OihOZ55Usn+qTE34h+VNmBasFROYMlfAsoNubFd0JS7R?=
 =?us-ascii?Q?jPQwl+HJHp0unmTkCfAYnsX42NwisnjdHQ9RBSKJxEL1jNpZmeaXXunOObES?=
 =?us-ascii?Q?RA0Wl8h/EJJGZ6TRK8tB04VOZ6t0d7yzMhDa/9sCQ8kfPea7BaF9XqHN68w0?=
 =?us-ascii?Q?bVBZfUNgSI4bh8W62OUGNzU1uByVtYAzQYx64fjrGIKDLZuGv2vaan1LQOyn?=
 =?us-ascii?Q?ydKhp7ahQM7P7xGZZsUpdCbkzsaDM4d8fhMwA7vRfDPzNpPZjemJayoo8Ai1?=
 =?us-ascii?Q?iRZZE+iVSCACBAYsGp3z2vlLGy51lLEtyGpUCaj6/LlQVW8Xrrwr0iy1/dzN?=
 =?us-ascii?Q?q4sK2+prm91UeHFTHMQONymdBeSlo9lS9Ld+HpjW+HVT6njHjqrndjKj2WzO?=
 =?us-ascii?Q?WavNo3xDQpqB6w4R83ZVfaSHoykiVrpmxM67v3Ae2hRb2uKZeqVyy+DS/GFi?=
 =?us-ascii?Q?iyCbW7dOryXRske47V9nrLiSihlewko=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b17a5588-9580-4b04-1eee-08da19b28679
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 22:52:57.9178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iBwgQNdolp5LUlMTh+N1liH/h4V7OUxzaCzlaFYtmn6ZoZHcs+lbY36/5z/AkunMW/UJOREAjET+5y8NCt3aDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3705
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-08_08:2022-04-08,2022-04-08 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204080117
X-Proofpoint-GUID: JfRCckjuKKVthWUSawCk_EoIjENMhQaw
X-Proofpoint-ORIG-GUID: JfRCckjuKKVthWUSawCk_EoIjENMhQaw
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Parsing of USDT arguments is architecture-specific; on aarch64 it is
relatively easy since registers used are x[0-31], sp.  Format is
slightly different compared to x86_64; forms are

- "size @ [ reg[,offset] ]" for dereferences, for example
  "-8 @ [ sp, 76 ]" ; " -4 @ [ sp ]"
- "size @ reg" for register values; for example
  "-4@x0"
- "size @ value" for raw values; for example
  "-8@1"

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/usdt.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/usdt.c b/tools/lib/bpf/usdt.c
index 0677bbd..6165d40 100644
--- a/tools/lib/bpf/usdt.c
+++ b/tools/lib/bpf/usdt.c
@@ -1170,7 +1170,7 @@ static int parse_usdt_spec(struct usdt_spec *spec, const struct usdt_note *note,
 
 /* Architecture-specific logic for parsing USDT argument location specs */
 
-#if defined(__x86_64__) || defined(__i386__) || defined(__s390x__)
+#if defined(__x86_64__) || defined(__i386__) || defined(__s390x__) || defined(__aarch64__)
 
 static int init_usdt_arg_spec(struct usdt_arg_spec *arg, enum usdt_arg_type arg_type, int arg_sz,
 			      __u64 val_off, int reg_off)
@@ -1316,6 +1316,54 @@ static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec
 	return len;
 }
 
+#elif defined(__aarch64__)
+
+static int calc_pt_regs_off(const char *reg_name)
+{
+	int reg_num;
+
+	if (sscanf(reg_name, "x%d", &reg_num) == 1) {
+		if (reg_num >= 0 && reg_num < 31)
+			return offsetof(struct user_pt_regs, regs[reg_num]);
+	} else if (strcmp(reg_name, "sp") == 0) {
+		return offsetof(struct user_pt_regs, sp);
+	}
+	pr_warn("usdt: unrecognized register '%s'\n", reg_name);
+	return -ENOENT;
+}
+
+static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec *arg)
+{
+	char *reg_name = NULL;
+	int arg_sz, len, ret;
+	long off = 0;
+
+	if (sscanf(arg_str, " %d @ \[ %m[^,], %ld ] %n", &arg_sz, &reg_name, &off, &len) == 3 ||
+	    sscanf(arg_str, " %d @ \[ %m[a-z0-9] ] %n", &arg_sz, &reg_name, &len) == 2) {
+		/* Memory dereference case, e.g., -4@[sp, 96], -4@[sp] */
+		ret = init_usdt_arg_spec(arg, USDT_ARG_REG_DEREF, arg_sz, off,
+					 calc_pt_regs_off(reg_name));
+		free(reg_name);
+	} else if (sscanf(arg_str, " %d @ %ld %n", &arg_sz, &off, &len) == 2) {
+		/* Constant value case, e.g., 4@5 */
+		ret = init_usdt_arg_spec(arg, USDT_ARG_CONST, arg_sz, off, 0);
+	} else if (sscanf(arg_str, " %d @ %ms %n", &arg_sz, &reg_name, &len) == 2) {
+		/* Register read case, e.g., -8@x4 */
+		ret = init_usdt_arg_spec(arg, USDT_ARG_REG, arg_sz, 0, calc_pt_regs_off(reg_name));
+		free(reg_name);
+	} else {
+		pr_warn("usdt: unrecognized arg #%d spec '%s'\n", arg_num, arg_str);
+		return -EINVAL;
+	}
+
+	if (ret < 0) {
+		pr_warn("usdt: unsupported arg #%d (spec '%s') size: %d\n",
+			arg_num, arg_str, arg_sz);
+		return ret;
+	}
+	return len;
+}
+
 #else
 
 static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec *arg)
-- 
1.8.3.1

