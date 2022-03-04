Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8360D4CCDDE
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 07:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238213AbiCDGfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 01:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236024AbiCDGfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 01:35:13 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF558BF0F;
        Thu,  3 Mar 2022 22:34:25 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2240ZbHQ028323;
        Fri, 4 Mar 2022 06:33:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Oq9mum8fMreT2svMzyXF+djffbtkANnYZ05MWHcPROw=;
 b=hlzRaWUv94UaoPJPXjbByz2w7akw9FSf04y2ysRtxzmfXKdCtXPD1/p8sSEUx2nHq/NU
 FEpKkhTF3CIIU8p0VmHidZj/eB7Ymt9RMbQGDKlYB/sOm5HJFO4joTFs/s74hOr40zk9
 j/HSAkuAcClnulJXMqATWGLfGzzh7ns/neVMk9zsdaojb6r3VWsnTuaMUHLzWaxLamE9
 VhYu9loDWRu2dVNphZTZPi30tlvl5SaMQcSBXrbVmd0XWYvCcQBpTuVI/pzdRv2YlmG9
 RAhgzgQxZuG8T85IJXLAG8D6OpzuIElx8awQB7PlceYlFTwv8jSwPuSdM0d89kndB1op lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ek4hw0xg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 06:33:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2246VBvL010489;
        Fri, 4 Mar 2022 06:33:22 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3020.oracle.com with ESMTP id 3ek4j8drrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 06:33:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OHXiIR82fY92pBn1hGpm9OYYUPkIbTzJW1wKuuzXkjO5cEO6BcWKwBIrjKEB/4OG8VsWq5eMuuPZhVRg5rEL3AGgWji45frOHlU89IAqApt1dNPrMNKCttuAxQzv5ZHsbNDFVInzEgE9TqXpnMm5KSquqA6c+16o3gXvd+PuIZ7gjv12lhg5dBoj8j6j8MT/eB4zwQDfe1kfM+E2OfOVfsgvS1RL9g2MzzfU1gksNoKuWkYnubVFMgaYQ0ga0+zongPZARbb/FWRNdBVPclhWnMBJRmwmf75jfemnCtig//KPGQYrXfFruDaysmgYtg54dUOz1AGCVc2zN7hqv6KAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oq9mum8fMreT2svMzyXF+djffbtkANnYZ05MWHcPROw=;
 b=oHDg9SVgup7/Vaaq/k6x7gkOHSWxeWzzQ0SJbz0y7dPS5PEt06FAuUiH0lQpADLucqQUWu5XBzd3tc2wYe5IB7HFO4YKL2dvSkMAKwAjw5Jf+u5a49BlHwesGH+2C910PWdorZiZBxTIUqtVZYXBVnURVY8RdBShWxeg6MGg+TJH+5my/27upqG2Ub+Xzq6K1J4lML8nvwcdjpp+lfjigJSZJd4q4EbygV/QugQa7QTEM5YmAbNASDln6x+SAvse5cFiQmKxS/2gOp/gVfKYHUz1wEJ/xZOdIAbTK+kvsIVGn6tvFdWFih4DYGbbXxpVwENRrFvwwImwJsWh6hBxtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oq9mum8fMreT2svMzyXF+djffbtkANnYZ05MWHcPROw=;
 b=v0ediqGDsrI214WIKR5/DzH35f1E1jhkqb1NRCqZYQbObaLxG70HBsUw+YZ7TyGCgK/TrtUktpfoF01cjRTlZ6oALwY7+XTiTYcNnirfbjqczODD66CzBMDUf3Gw3Q93UNsf6jroq7LFpl9Z/3xljZl1FVjH9ski2UZcm8ACTdI=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by SA2PR10MB4603.namprd10.prod.outlook.com (2603:10b6:806:119::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Fri, 4 Mar
 2022 06:33:20 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.5038.017; Fri, 4 Mar 2022
 06:33:20 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
Subject: [PATCH net-next v5 1/4] skbuff: introduce kfree_skb_list_reason()
Date:   Thu,  3 Mar 2022 22:33:04 -0800
Message-Id: <20220304063307.1388-2-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220304063307.1388-1-dongli.zhang@oracle.com>
References: <20220304063307.1388-1-dongli.zhang@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: DM6PR01CA0018.prod.exchangelabs.com (2603:10b6:5:296::23)
 To BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ea7f0c6-a43d-450f-d175-08d9fda8dff5
X-MS-TrafficTypeDiagnostic: SA2PR10MB4603:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB4603A16BFDABDC53D13ADF14F0059@SA2PR10MB4603.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9t2fGFv7VgCMybkQsRQBLiqTEgKeOvGDfxw7zwzhpu/8M4jqb/encnL3r5hwLEPrs7QEifP4vON+fPfXNoYASp51iwJ7WKqEe2TDYKq8k73X73nldmgjVGrJyw78QiYiVxpT62hICoJ+IQA27AHtKRHxxMtrzSLjEsLLPyqqH080030qmJVmD/pzF29sGuozZBFy8m3uqBhRCtg/2nUM42yUS0u4E0YLqGruuId2LPRTpjzNXCJjR7cskV2xBtuYMYF6xq869VNx4PFeMaAhUgaUHGxkR8Eiz6CECsrSu23cPWYDCCqEBH9MQGRme3Ktsp60BXjTlwAme0M6EDT4LSEKSnAwFX96ZeI1Jzjem0xJYByMj0apttmsUp4O2uSFjUGl0FhfKwOuFIq2HogDSdOZdl/JBZlx9tbGPLJBBWCrPsHxSahc5iLjWOBvb1VVgnnMo9JDL8vpRIyrnplA/ds/bdsCgLj90wW7+zChj7GC5wCCZZT56cQzi4k56+0EfDutS3/VzbQQkVYenTp2DZDM6nThz5nHgfT2zyFfBbjllT6EHq2tAGzOTsGO24rXnDrzy9lcoq0YNue+xXC9Hk1Td6yKUpdA46Azk9/QNVy5AQaSUbhNG90SCLh+5iAzGN8NS5rUYqE98q/t5X6+PKSztGvO0MnIcZWbsmflVwhU0pR5Tq9uLAOAKmnCumES64oEMKHZ9C9Wlr0/Nk8t/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(8676002)(66946007)(66476007)(66556008)(1076003)(5660300002)(8936002)(7416002)(52116002)(6506007)(6512007)(508600001)(83380400001)(6486002)(86362001)(6666004)(2906002)(38350700002)(38100700002)(26005)(186003)(36756003)(2616005)(44832011)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6wQr9ddA3sEA8GGmz5qVwxuXqbQu2gyHekyAYGTias6wNEW/xB3vYOvAMIsO?=
 =?us-ascii?Q?qQFqKaTyIN+gM7gZTxz0L5nGVfSjMoC1nrtWZGqS4Vk+QILsSoVVU7dpAPEx?=
 =?us-ascii?Q?j5PsxEUsWs5lO80+n4buQYfK4+evBe7fAj0JCMLt8mcy8kRG9j2QrmEryIi0?=
 =?us-ascii?Q?N3uLZD193isAS3zWyZ58sE8aIph+/j90IZBHav1OHpUYAQCM99lH8aJFaHw6?=
 =?us-ascii?Q?yaAfm1MPHfVXwaKKjWiU7Z5Pe2MM0a3kCizFxa4T3FP2EA1E/jdfufLrU7Ws?=
 =?us-ascii?Q?fXV1tuZF6bcuAFpf1f6Wo9Wa0w842uO0mGBjuEccPKYWsi7C9fYajTMdMba6?=
 =?us-ascii?Q?T44vhH/KNO6oZuo2IONmeFh3vqItxnSd9VbX2bFU0jC05qyzrpgpC+2ND+za?=
 =?us-ascii?Q?HgIappasgTBpNfi9SBbPkkM4Tx3YgP27ITI/ge2+gzY16IRWKemQ9l9SRgj3?=
 =?us-ascii?Q?GjEAjLTdwT02eFBldivGbVwmYHIs3defnJ/IxrgHYwigDHNW3wL6M1TzVTlY?=
 =?us-ascii?Q?Am2BFvRv+iTlxP8EG0iiWo6uYXztkSOOtFeTo2nUpfKHcwz+D10Dmf0X7pxw?=
 =?us-ascii?Q?4no1iSPrCBSI2VW6QsEaaeqLr8nXshCaBruDwBB2RJA3vidrxH12V+/sSBC4?=
 =?us-ascii?Q?W0fkHBPjYlCaqoO5VvqTnj6XNr+9zV3AmeJyMSRnsNjox49S5sy1QI3zc1FU?=
 =?us-ascii?Q?oXe8nK99d18YHd8xX9t4C6gCYj+zJxl+AmGdvfh65JndC6UUvR0RxqRYVY6z?=
 =?us-ascii?Q?S51bxbhe5LGyOvPLnaQvId6XDRwtpVhyoxoaVwNliyilDAZ9dc+M2xdjOB18?=
 =?us-ascii?Q?ctl7PBsErrwXD1lVPRDvNV5EFg4dNXSQDTi4kWBePWyJxFi3JeNHK2krpxBD?=
 =?us-ascii?Q?wsdxVDf63rzSa9L4xFEHWmwAjEuLZf7uyV+6XL6qSUjZiKpB562hPiAHt5QC?=
 =?us-ascii?Q?MrKQSAuAbCcOplhxSgZPf0a9il9QV5Uv8E5dS1+lh3T4/7De0CRuwWVSTDQP?=
 =?us-ascii?Q?B6aB+WlQJ9AA2LUY72sgXcG8X4Cw4VtXDfFs+aDoHmnu/T7uOS39Ljmf2zuo?=
 =?us-ascii?Q?lgeaJMeXe9BBe6ca9FYXLFU2ykyg7q9YcmIIEuNVSCjMFuppsMVzHeu9zRA0?=
 =?us-ascii?Q?0LUScTu56LrUKaF+TAeXM8ulWQRloXHYI/o+JPYYus9tx2r4Srvu8cBPkoD7?=
 =?us-ascii?Q?j5r86WCukEoChZjxqxLmKTEMIKRoImsMKEZpD1q66ukxQJY/596UHq+wr8Mc?=
 =?us-ascii?Q?FxDs9aCuy6HZPT5s6G5Tw9ymrIOINWVrqXi20HxvQUourIF6Hva00S9Ic23U?=
 =?us-ascii?Q?yqmQ4M/7fH1dWo/ofJoZ2wZ1ROQmCDg4rgoilDFv/+nPLbXaK4wYKmS9rE9m?=
 =?us-ascii?Q?auOCTHpcy5f3fHQ8Ly2eccXpZvxo6lOq+QVFJIy/acIarOqgknKMJDm6t4RX?=
 =?us-ascii?Q?laKYvZvOXZx1in8ovtDkoWa+gfapbB7d3hTczMVwQdhq83VRxOMihIke0YkQ?=
 =?us-ascii?Q?xlHQ6nCYsVQfkmy9dwcT4CJHEBQN/eDyZpf8dARYFw9xLF2aLqhJjzSVYYM8?=
 =?us-ascii?Q?EDNe/wpnSPfr4w3Jk7B2KdAE0sCfSTCF3nX2y62Dxg1tRwTpZLUG6yl6waGR?=
 =?us-ascii?Q?EnJhW2kHXEZeFkL5sxjzy2Y=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ea7f0c6-a43d-450f-d175-08d9fda8dff5
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 06:33:20.4647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6xL1jOzqCw5oFQ9Jhm7WhdwSFU9QgEk1xwOR2fDxTRDRGWKn3+04ikBIHRVVf/DPCHdrXpXO0Cpb/yd9sobTfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4603
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10275 signatures=686983
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203040031
X-Proofpoint-ORIG-GUID: gQo5RDZ0Px2zwT6aED24JPdP6EFtxfbY
X-Proofpoint-GUID: gQo5RDZ0Px2zwT6aED24JPdP6EFtxfbY
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is to introduce kfree_skb_list_reason() to drop a list of sk_buff with
a specific reason.

Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
Changed since v4:
  - make kfree_skb_list() static inline

 include/linux/skbuff.h | 8 +++++++-
 net/core/skbuff.c      | 7 ++++---
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 5445860e1ba6..bb00f86791e0 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1201,10 +1201,16 @@ static inline void kfree_skb(struct sk_buff *skb)
 }
 
 void skb_release_head_state(struct sk_buff *skb);
-void kfree_skb_list(struct sk_buff *segs);
+void kfree_skb_list_reason(struct sk_buff *segs,
+			   enum skb_drop_reason reason);
 void skb_dump(const char *level, const struct sk_buff *skb, bool full_pkt);
 void skb_tx_error(struct sk_buff *skb);
 
+static inline void kfree_skb_list(struct sk_buff *segs)
+{
+	kfree_skb_list_reason(segs, SKB_DROP_REASON_NOT_SPECIFIED);
+}
+
 #ifdef CONFIG_TRACEPOINTS
 void consume_skb(struct sk_buff *skb);
 #else
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 23f3ba343661..10bde7c6db44 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -777,16 +777,17 @@ void kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
 }
 EXPORT_SYMBOL(kfree_skb_reason);
 
-void kfree_skb_list(struct sk_buff *segs)
+void kfree_skb_list_reason(struct sk_buff *segs,
+			   enum skb_drop_reason reason)
 {
 	while (segs) {
 		struct sk_buff *next = segs->next;
 
-		kfree_skb(segs);
+		kfree_skb_reason(segs, reason);
 		segs = next;
 	}
 }
-EXPORT_SYMBOL(kfree_skb_list);
+EXPORT_SYMBOL(kfree_skb_list_reason);
 
 /* Dump skb information and contents.
  *
-- 
2.17.1

