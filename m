Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7124B4FC05F
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 17:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244043AbiDKPYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 11:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347810AbiDKPYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 11:24:19 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7C13B2BF;
        Mon, 11 Apr 2022 08:22:05 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23BFE9EI018415;
        Mon, 11 Apr 2022 15:21:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=uWYx+rK45qRCXj2RWb1UhuWbONYg7Aw/aLCelMOodKo=;
 b=gLmo/3Zl1CefUdsCUMUoaKjBVIecqsodGDlsYmxWq+biJyg17C1tCjjWqtubJSB4lELp
 nJOheTNqcd5pzK6uaeRblGnWkUNfG0Q4iXL5+BxhaOVs6xZi/8Yg6YxbQBGUJGfralnf
 JvSWbDpJ+4TsUPTm9nkLxT8XfgDN9Db1FNL7mkOMrYhAMCpaK8Omim1eV/ZrXlIf/Z+c
 mm744uLGFjG1yRjZVobT0HqhtwAWcnM/JiEf8a2Ar64Mk9cudy91hzOlElncFSwC9P8z
 eSLBGoYlVJiFnOcb9NEJb/V762ipvgnCummdAnIRKfZpt84cADdozgR1oir8WnFrPql/ wg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0r1c24b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 15:21:48 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23BFG7N6036948;
        Mon, 11 Apr 2022 15:21:47 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fcg9gcfvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 15:21:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JYhtUgEgsmgf4UnXGiKKn/Sf62QJKlis8yK2P5s5Q03z2iwcBQGD/MTr1RuOAgSLIUg+EMsZ8d296KjNqkbzgc3wC5Pfi1zOxLoKYMv95vBebP9fk6WJXKU4KlMt6pPek0Dl/Zz7kY4cYikN5KVRLHSHmu8XfZr4C1hsxaG+R3lJxCZNvRH+MS5IWnu8Jde6uBvardeI47XCCoyAUmIABMxPWpfmvEaqu6GcbCW7raUUZQVc1QXSyL1D2E0eTWsbKS28fsVAj3mzxi1xq4YQBznJ9QdyuyelDghuL203wfm7QE63uJ6Bn9skNBghvDymH8FRY9yhYQdrqd4RamxjQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uWYx+rK45qRCXj2RWb1UhuWbONYg7Aw/aLCelMOodKo=;
 b=iozd1bkSA1NsC5hKxrV85AhzZEHrNK9JJesBV2ItvwcQAesEBG7Xg5w71RN9qbcUFydobvOV9wiSEefZA8TMYdkSEH3UonXJ2kzYy85I9L6RoOkELzhB7DPrzkeA3ibh6qPoqeBumjV91sEniMlrTvRDU7mWzoUdEqFKhVcLEmEaCzqJ3HhqwdPYQqNOC+3Jb1/QWR9bCDHjKTafTl0I85P3CoSEf/O3b2CylqDWeCvgmBlTsXsgPSl5WOqe5G5Zf2ZPrA0A6qO563+eM5bq0MGoK3jpJ3svfDtWnNTzfuNjE4yXkF8171HKAwl3iSqqJ0D+2AP6U0dBLL4VzEnEsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uWYx+rK45qRCXj2RWb1UhuWbONYg7Aw/aLCelMOodKo=;
 b=au4zA+UibqG88NMe28tS5FA+pIG8XsEZDbEm+6aLB5nm+8Ren9Zf7ZYzO6UPfeiU/AZ7jYtEZJgZEaF9Oekle0ezM00h+/RGt4/DRuoHVws23f7m8Lvy77kJVCYslpqZ8PNjjNI3LWKuDOpPTJxsfoGw+nQceC2rmxdKVr2PUvc=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by CH2PR10MB3942.namprd10.prod.outlook.com (2603:10b6:610:e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 15:21:45 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::bc05:7970:d543:fd52]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::bc05:7970:d543:fd52%4]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 15:21:45 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     iii@linux.ibm.com, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v2 bpf-next] libbpf: usdt aarch64 arg parsing support
Date:   Mon, 11 Apr 2022 16:21:36 +0100
Message-Id: <1649690496-1902-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1649690496-1902-1-git-send-email-alan.maguire@oracle.com>
References: <1649690496-1902-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0189.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::14) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 856e932f-2fcc-4bc6-0e97-08da1bcefd56
X-MS-TrafficTypeDiagnostic: CH2PR10MB3942:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB39427207A2D5F2C36220015CEFEA9@CH2PR10MB3942.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sr73DzqD7AFTHdwK7tM00mmoKxRUpDKWel0HBDESeY84t4z81+OCwmhVFCpjQFwyEL6nt18iJ8zc+Z29Z4+VKsnV7owf2FiZbu2N8ijhKmMs3dH6kPISFozRyI8MkwMzgrlgL8qMHycIQ4J6R0Ot3QTojMuRoATlngVuqCWlgRc1ozFbzSQqDaMxdpiETW2BlgyA7PySemTqOi6kAJJW8lQe6wFiC9FGh/OwwdxtHtelIXnT527y7ZUDqR02n2Koq9daYhO9rxi3yCiG52ndogRJWzC/YTn4sFLoTQzOyV8+ClHKcQRkOCfnV2KfgGah+Ggn21xmePdL3URl7TL8f9ESgvxIteCMxwcTXLihpFMxgYI8MzaqZlDAg0N4F1ORBH0bLGCnLgyY/I62q8Si1I2moJFgTy2x4E5J2Rp6MLh7MR4B+Gdhrt9g+T6TJK8uhyHzss6NB++qlrlGSVn/5liEVZQYY5jwLXx1iepKXJ3UYgCDgecCYscJCI2DJp1bRS1NZVpPSP0t9me8DUhdNHu5jt/qTwNccAHAic/jnDJha0/FkQuybXmHhveAma3hCh3koSaj54tQLqU6K2eVrMrpSwVmSZy261/9Y3f0rzcOgLByP921cAjn8cjemOY5vqBjXC4QJzFcG2whTJs0a8jDPB/dFzcQhwKVtJpn8m0ma6ptDeu2VK0uIE0w2zNCDPSybdEzdRPbLhtWJ5+eow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(86362001)(316002)(6666004)(6486002)(36756003)(38350700002)(38100700002)(6506007)(107886003)(2616005)(52116002)(6512007)(44832011)(2906002)(5660300002)(7416002)(8676002)(66556008)(186003)(66476007)(66946007)(8936002)(26005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?frQArA1amyRHvOOWCn1+BWVUZoKZUWbry98cr6TjiS/Ou/7YslrOJBO5qvk5?=
 =?us-ascii?Q?EBgzUaEMwybzqSehXl8ZWenrvdLcma24/z+mAO1VzJVXOvxwp1mIEsOURpvG?=
 =?us-ascii?Q?tAdttl5BeVLftdJCwtrN8Qok2a53KzFYNlckzvZ+rhAAobhwSpp4sHGql+va?=
 =?us-ascii?Q?Bru3V2jRmMv2YK68lKKxkUK9Pj3j8s+qB3LmSqL6QvL935GrnQLT4J4w6po4?=
 =?us-ascii?Q?VqBXTkIkioGgFJVsXsuHVF39AC5cqO/6NJdvEQxljq4+ia40w9ByzlNkF/rH?=
 =?us-ascii?Q?oCBhnRB3EhbVv54h4zwaemi8v8Q+/wsYJRqxjeQ51GbE/b/z8ujjEVjWUCJf?=
 =?us-ascii?Q?Lg5cmHhE6HO0fL4nxH7w9fTwSYPimm/pJpyCPvcb1k/MBfYaC0INyeCILGC+?=
 =?us-ascii?Q?JMqRQX2km0ycbiCx+cQs23Ad+PtTXq0a4ecz1KgCqT/qXFnTOxp8Xy48EpZK?=
 =?us-ascii?Q?bckM2NdnxV/Kh9A97YM7LBj2Vsu5wpJyHbkmnk1xzbCcFtaHg547IeKfCnsh?=
 =?us-ascii?Q?Cdps1jRcmVkdHxdTqDSFrZcg8L1AwMrGO15BXEbiq/Qid+NjcGZdr7qqvo0U?=
 =?us-ascii?Q?csIeP29pkIcAHcz8WmE8kkIK4z4JWpiun0hszMasr/XW3fQqLzEpAtpF0h18?=
 =?us-ascii?Q?c55/Tlcud+q6d+U62RC9dXNf8JVLQjf/nnY2DsLtvtsoeQk64fUr1RqAbTt8?=
 =?us-ascii?Q?zhXPS5EWZLs5siKkHwpzUGd9g57/9oAhqwokbFHD2DEmn0bkAumLcNYSD9zr?=
 =?us-ascii?Q?ESQ3RFTkBma3wEoqcOVrcsMJ7Z3HLL3FDNEz9rnM4PSrux3s5yJY3Kz7rAR3?=
 =?us-ascii?Q?+FS8+NeMjRvc3I0s9JJCyh0uR605uJNdcu0AHfseggODj9J8oTFpRoQlNgjw?=
 =?us-ascii?Q?tgEu4S4GnFdeHqstG5YKK0DYiCnhR5a10mWH/1uoNr9Qxa+iQMXlmpbHrbgK?=
 =?us-ascii?Q?FIO1X7DmHhL28Hs2hCJBD1dxKbzSB9hXa4bh7dnjeq9jxDS+ntVi0CBdFwYd?=
 =?us-ascii?Q?aYdv0Kz5qYfh6ho1w5GED0dzGZq4DLaGUA9s8uJ8j1kb4pbx9w6+ZOt0Aue7?=
 =?us-ascii?Q?Q3MN+miKZokJCgUZx9olb5+IsnZPoArt06AXmdL5IxzjhDVHv3pu+0Sw+R6w?=
 =?us-ascii?Q?4V0TGG6aNlyV6/2X0AoQA6/DUlXEkUZADJwId8gPAN3G2BtDGTFLPSva+bHA?=
 =?us-ascii?Q?2F8cFJ032Indg3UkM9E0gxkN8Q/EpACKYw23bsCneOyTC+85oPKNJYbeAUGX?=
 =?us-ascii?Q?3DUiGY7HNXormmslZTEiY7UfIKOdVdaoIPf0+CjxDolYtxQh7bDGbE73fUDf?=
 =?us-ascii?Q?2pnLc5bKosVKq+Q2ldrFja+V5X/FuarvjG60Rjpj5L2BWySt+BEMDkh2VtVE?=
 =?us-ascii?Q?UCSkcvn4qtodh+FW7PuzSUHPfTMF8dWrOmwMAhEWj0kmGMz5S+jkxoOhhDQ4?=
 =?us-ascii?Q?MPLzal+HRox5I/gzhRpQe1JKOL3EEYvc4/FTrx3r2Xqo7syqC8GFzXyILWdW?=
 =?us-ascii?Q?FTWXaF/0IoG0ME6QfdUvJ7J9eIS1onFrgje2DjLkTb0IPZxReSD2N0mOme4k?=
 =?us-ascii?Q?atZdxXg3CX9S1rhvfarNNy+WB8t8XvZKl3FAh7Yg6/D/MR+7Wh51ORTcBcB5?=
 =?us-ascii?Q?q+YLy8+/QsVViXleQdaoey5boP7ie4lYoGY909YmrMCIcwpRxYQQWtMMcN9+?=
 =?us-ascii?Q?GU1vDvNyY+I3DT2UasS9lVLw2lYJdlhekgIwUd6LX1g732nWrcsVLpyFenTw?=
 =?us-ascii?Q?fX5jonkBhSDDQx06a7fLlLxhR+W/uHE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 856e932f-2fcc-4bc6-0e97-08da1bcefd56
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 15:21:45.6021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 06t5d4HDcZ6QoZDdyEYuT8QYtna8MVRsdQBwgXLjJxS9LbaE2MDsjB4wkBQSwAzEFLZHUbKM1GSkE0rcBptblg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3942
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-11_06:2022-04-11,2022-04-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204110085
X-Proofpoint-GUID: ugLCVTVog8YFblgUu-ZnFWMfE01HI5Zn
X-Proofpoint-ORIG-GUID: ugLCVTVog8YFblgUu-ZnFWMfE01HI5Zn
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
 tools/lib/bpf/usdt.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/tools/lib/bpf/usdt.c b/tools/lib/bpf/usdt.c
index acf2d99..934c253 100644
--- a/tools/lib/bpf/usdt.c
+++ b/tools/lib/bpf/usdt.c
@@ -1324,6 +1324,82 @@ static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec
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
+	int arg_sz, len, reg_off;
+	long off;
+
+	if (sscanf(arg_str, " %d @ \[ %m[a-z0-9], %ld ] %n", &arg_sz, &reg_name, &off, &len) == 3) {
+		/* Memory dereference case, e.g., -4@[sp, 96] */
+		arg->arg_type = USDT_ARG_REG_DEREF;
+		arg->val_off = off;
+		reg_off = calc_pt_regs_off(reg_name);
+		free(reg_name);
+		if (reg_off < 0)
+			return reg_off;
+		arg->reg_off = reg_off;
+	} else if (sscanf(arg_str, " %d @ \[ %m[a-z0-9] ] %n", &arg_sz, &reg_name, &len) == 2) {
+		/* Memory dereference case, e.g., -4@[sp] */
+		arg->arg_type = USDT_ARG_REG_DEREF;
+		arg->val_off = 0;
+		reg_off = calc_pt_regs_off(reg_name);
+		free(reg_name);
+		if (reg_off < 0)
+			return reg_off;
+		arg->reg_off = reg_off;
+	} else if (sscanf(arg_str, " %d @ %ld %n", &arg_sz, &off, &len) == 2) {
+		/* Constant value case, e.g., 4@5 */
+		arg->arg_type = USDT_ARG_CONST;
+		arg->val_off = off;
+		arg->reg_off = 0;
+	} else if (sscanf(arg_str, " %d @ %m[a-z0-9] %n", &arg_sz, &reg_name, &len) == 2) {
+		/* Register read case, e.g., -8@x4 */
+		arg->arg_type = USDT_ARG_REG;
+		arg->val_off = 0;
+		reg_off = calc_pt_regs_off(reg_name);
+		free(reg_name);
+		if (reg_off < 0)
+			return reg_off;
+		arg->reg_off = reg_off;
+	} else {
+		pr_warn("usdt: unrecognized arg #%d spec '%s'\n", arg_num, arg_str);
+		return -EINVAL;
+	}
+
+	arg->arg_signed = arg_sz < 0;
+	if (arg_sz < 0)
+		arg_sz = -arg_sz;
+
+	switch (arg_sz) {
+	case 1: case 2: case 4: case 8:
+		arg->arg_bitshift = 64 - arg_sz * 8;
+		break;
+	default:
+		pr_warn("usdt: unsupported arg #%d (spec '%s') size: %d\n",
+			arg_num, arg_str, arg_sz);
+		return -EINVAL;
+	}
+
+	return len;
+}
+
 #else
 
 static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec *arg)
-- 
1.8.3.1

