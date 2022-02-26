Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 867904C54B7
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 09:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbiBZIvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 03:51:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbiBZIvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 03:51:36 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F4A1B8BD7;
        Sat, 26 Feb 2022 00:51:02 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21Q4nHA1030174;
        Sat, 26 Feb 2022 08:49:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=eUO0OS+ETeAg4CuJQcX+O+hhDyPBbXpObmQxWMNMmdw=;
 b=jFus6xyvc+0/vSfTkBnC78rPEDxGIFqMZ4YrbuNM9Ca1vEljZyu+lmHj4SHyn6t3CTzG
 Hx3kSnpN6WETquLKV5NyVRRCHpBLKJe2MAULmczXWpRXhKWTQA2cEcaVtZ21lels9xsJ
 kE+IwbmeCh5IOL9DBL+NCxC3PoMaaY+VnGpCW4nMNIZ35uS02pYIpOMlWJCO1JMcM28Y
 XTXxDoO3BT+G2vvWl2TOamQYGAHLPaaIh9MwbHgFX6qAiGWl6trVFrz1sB30gIXzuzeN
 IBZYIX5neFdyBQ+DeJzaB87DFBn6+uuRGrrOx2XqiCmfezFse7OXDhqOnUNEQiExXn3V 3g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3efamc8ebr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Feb 2022 08:49:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21Q8kO7p005020;
        Sat, 26 Feb 2022 08:49:57 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3030.oracle.com with ESMTP id 3ef9askqdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Feb 2022 08:49:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DD3OD5dUfSJ+H/TlivgJ07eZstlW93B7nOHnFT7B1ezPnTDCNv5A2UFa8vxhY5yozHD73MHR6jYnPYNLJHFVL2JsITQJfm6hdHI5TGPHbHDqPSkqI2qe2wweIs3j3PbqgR4FGit3e6jLaXY7yd0GlaRxpopBkHiTD+e9ZUynzGTsUsSmGWt4+Ix41Hx8AYf2UUDaWu226bq1Pagvm+jCGxxcbK7Wx+vOJUHqJm/9L8dbRRrO9ytTBFwnmzVAvG13ysu4O+S76AH5mfggfCIQLGBsOVIF9nvCHxyYKGQopfsZUHO3ilvewDabPzP3qp0yDev8xfClQE8Z2KKUhZtuhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eUO0OS+ETeAg4CuJQcX+O+hhDyPBbXpObmQxWMNMmdw=;
 b=Ix7YT6cnUla9rk1lEkB3ced5EfhimtPBrvqzThlY3YTWdiP346l8xokdfTS24D6xyUjPfzvuKN/dJk1h+zZZ60wIX0gEmF/6cC+p1ks5XNjbdRPsUkx5jA6SaKonjffQ+odRY7d7+xv7tgAqbiOSuvBj40Z7m3JaUYE2++LB3ZaQcrGNBqbxhbI9DHbTMuyglyKLEmjiYFc2ijbWcKRY+MKKCByuaB6w2oBenID2dW+ksGJqzgZww1YApwdkhUOurdkkm8rUzMu/0nIFbUpDyI0S4GLIq2VM8zyNnSTWLB70k0m/WdHW6g3qUrcV7opRdhFdL+ygczgn75FRxAu+6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eUO0OS+ETeAg4CuJQcX+O+hhDyPBbXpObmQxWMNMmdw=;
 b=RKuIDRFMemerWPpN/apICV17iUPV+MPDJQC/okaYLiIQnC3Vvxd2AN6GkM6nb8Ir0fE2Xv8jpxfwo9PqmKPIGtVWhPUeB2rxQepbxqb1o6grjjpYlp32ZQwyHK9ncWBmAIOAx1X6ksjnqksnnKPrZWRnsHrYaBjB5MFuGQoctUc=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CY4PR10MB1768.namprd10.prod.outlook.com (2603:10b6:910:c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Sat, 26 Feb
 2022 08:49:55 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.5017.025; Sat, 26 Feb 2022
 08:49:55 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
Subject: [PATCH net-next v4 1/4] skbuff: introduce kfree_skb_list_reason()
Date:   Sat, 26 Feb 2022 00:49:26 -0800
Message-Id: <20220226084929.6417-2-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220226084929.6417-1-dongli.zhang@oracle.com>
References: <20220226084929.6417-1-dongli.zhang@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0196.namprd05.prod.outlook.com
 (2603:10b6:a03:330::21) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25a0a032-7ae1-43ac-0827-08d9f904f583
X-MS-TrafficTypeDiagnostic: CY4PR10MB1768:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1768B46CFC5503A74CDA549BF03F9@CY4PR10MB1768.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wLdYbr5DsI2uBZy28r8FiVzCR+4+J+4ZVlznj8JGydh1mnf+eCW2KZFbspT+pgQrxx/MwYvRl+Dj4Um8YvEpGk5y4t2CofaIdqNolZwuBRaZdRkfn9bl8gYEbmBEiVFdSAwEElqBuWDX788+sa8Hn/tM0mUkiZ48s2QswU/eaB4Jp/NRJBQokc3A7C7/RlwFqVQapQ0QAQtmWdUmcPBJbjErT+bP2OfjGsga2DvXUgdeArRydAMldItB8p4aa8J3Sq2tHYQyAAiVUqEMOsqeRT+8xfLqV9biB1moJrEz7rdfoL4uOp5I8hysaahuSo5aQBila2JBVZbixjcE9FcYtT3EsDXKl6ynaYDnoI30Quc5LMN06CajA3ZOHPhT6P7aX6LvX+xGvJjJJKBjpyYaLOV0JxBEzSjcMWj7jmhhBnvrUGCzm7BTIRVzLm+8tJHdIzv3E36l53a9LGhmdrUkLpWzNPANf63E74V4nRz2hwYZh/E7+Nk3Lt+lyfhNd1BQZ7DZstRlbpmTCmoYjdncP6N/2YvI3dkAiPFjitZQUzak4kM3Rd5hHWO+USToevbYWhx1iB8QPa7wcTM+6BUGzhLcXPCZUHvzrlXJPO7WDwKSVi8Fas+GIRSd1Z4/axDV3WcxogM8O2oao1eM+2t0Su8XWdAAtfgtDVn7cFnNTCkxfj5+g+T6X/d1VZvwo1sGd8VZa0rOTvfkaIaU0uy9KA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(52116002)(316002)(6512007)(6666004)(6506007)(186003)(5660300002)(86362001)(8936002)(44832011)(26005)(7416002)(1076003)(2616005)(2906002)(8676002)(66476007)(66556008)(83380400001)(66946007)(38350700002)(38100700002)(4326008)(6486002)(508600001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UP0MpMH6+5BSBD7zaykMNyNS3QwGh1siQu7ms6+HfjldJcqU6kyR7h8IZJz4?=
 =?us-ascii?Q?IHRcHQC0FG3c8YM1XzrO2yivWNwVHebse2xrNvt07QJUxGQDrAwYx2GM5ZIc?=
 =?us-ascii?Q?+kitjff6Saynx0O/toPAY2CEK9gYHGsZg0jdWvgUxh/jI/WRxQ0bw6Tl5657?=
 =?us-ascii?Q?PrDmJ643caI51fpLMiDeWcbp7iw062AXfgzHnua9hhJJqEjcITVll0SEWKkp?=
 =?us-ascii?Q?+2D98w5mYvedN4kP0AmrCfTt/1DXL7J4cSQFi7/ot3kM6DXCy0KSpyZR74zE?=
 =?us-ascii?Q?XnuYu6kuo9x3r+bWYm3EW8BW3VKM2hpGAdouwtIdZaF0Qt0isqx8GkDEUR2j?=
 =?us-ascii?Q?GE2pcOPkElR1p/G8Am3zv3HSws3s1B/OKU7U4JsjAEbJzvJaYRc5CUJemohO?=
 =?us-ascii?Q?1no89O61rmRjajAMYSyp8zSTTYDQMjBUUG/cHLbfoagxpE6oeyf9oaAblG8O?=
 =?us-ascii?Q?NTBu1/I8S+NFON1mEDiawjSR4C4QzV95ZuM5LtoBoFosYd94ak4OgOVTvbpY?=
 =?us-ascii?Q?P2Z9Wp1QWwyL9dA4MHFnAzuoLmO6QABzs2kS/E/Fbl5/q+671uKHqhyJPiEX?=
 =?us-ascii?Q?cvkOrmROCYo99Og4veLRWOSMHueStg7tgaXE9ScIAqadu/SO300F7rR8Mvog?=
 =?us-ascii?Q?/YZFKXEJ0UFwLc+En+PeLvxkPRBFwUVKCr8VXv3UU0ulXnHWui4B6sVY+kZz?=
 =?us-ascii?Q?DUfOVVsgwBPswnxdLC/SShQ0HZXlKq8j5ZDjXaYgtrr1U7Xc9brLIgIEdG8J?=
 =?us-ascii?Q?WhQPnTdD8fHqbkeMBj13idQYWwyiPc0gRl5DaobG7v57lDx7cI2bX3x/gQPE?=
 =?us-ascii?Q?BLjJTd7IaZkH+LKIxVDdzNuq6MsU/RGAjDKMbRt4wM1C/UtsbkA5R0zNaYf0?=
 =?us-ascii?Q?ezhBY3BOERTEzsRMe9OBCEb+1BCTca1zKyZGW+/232z0ZAafQDO6BmGuhWrd?=
 =?us-ascii?Q?g6lFgkKI5b4e71Xbh5/y//gKpxEdWHpUj3/I95pkptgTFwriO5LKzgWaMAUE?=
 =?us-ascii?Q?9528a1Enpthl9Csbtx8PBmDLm3U6CafWoDqqTCaV8PJG4p/CuUUkt/x3DztN?=
 =?us-ascii?Q?2mX6f3yE4xWhCYEHhkIwo9vACpw2QurSNm/lW1v97PjmNnsYqy7iw8yJkxuD?=
 =?us-ascii?Q?CSoXV5uHsoEvcduyv2QUXGL3xCfGmHVidPfsgpSqviTOiNGc2MGjMg5L9Ptm?=
 =?us-ascii?Q?TmmQp/drVmyZWxAHqM1G+BHnlVMWFVAmNc4x9Jtla131AMGbOlcaO0rvC+Fz?=
 =?us-ascii?Q?1qtZwG469v/uI9YPey9NhP21tjUUrp8PixdIKXmVXN4PijxAIu5TCRuN1HCw?=
 =?us-ascii?Q?RH+KR4b1UgKw50w1kTkGRf0dis5lai/YcIL0dI5irtmx63TlTgep0xO7O51C?=
 =?us-ascii?Q?Z7UEEZNZdW0osYKyT6HEAzLHqGFvFgl6Wx57ZQ0VqI5Yj98R7qgNA7ssy4g5?=
 =?us-ascii?Q?EFdEc9ZJWXLpNlQg8e8BSGcRKRGqGE/SUOg8zJ1V+0fMv6OcG3rYuSt/AdfI?=
 =?us-ascii?Q?nviRAyhI1LKLk9TqwfxPpPwIVzKVZ0NeyDWGamQcY1YspMltMDBfCLstYryg?=
 =?us-ascii?Q?m76TkP9ZLIRpi1T2IuXr1dbDV0xl3ia4wTaV5k7yxnEIBeQ46P2ja9KGw7tx?=
 =?us-ascii?Q?7ND0WROypso2rHMi4tqXwIE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25a0a032-7ae1-43ac-0827-08d9f904f583
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2022 08:49:54.5857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CEmAiTJMs3FncURg31E2v2O6sQ+kMBKvpUs7C3UxhNbieEm0G0eSdtkdDHOAI1di/qQSQHOn1mG7HaKkLYf4TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1768
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10269 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202260060
X-Proofpoint-ORIG-GUID: 38jJBqROrvuGxsqWYagK6cRMXdnqA5u9
X-Proofpoint-GUID: 38jJBqROrvuGxsqWYagK6cRMXdnqA5u9
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
Reviewed-by: David Ahern <dsahern@kernel.org>
---
 include/linux/skbuff.h |  2 ++
 net/core/skbuff.c      | 11 +++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 31be38078918..bc3f7822110c 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1176,6 +1176,8 @@ static inline void kfree_skb(struct sk_buff *skb)
 }
 
 void skb_release_head_state(struct sk_buff *skb);
+void kfree_skb_list_reason(struct sk_buff *segs,
+			   enum skb_drop_reason reason);
 void kfree_skb_list(struct sk_buff *segs);
 void skb_dump(const char *level, const struct sk_buff *skb, bool full_pkt);
 void skb_tx_error(struct sk_buff *skb);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index b32c5d782fe1..b4193eab3083 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -777,15 +777,22 @@ void kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
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
+EXPORT_SYMBOL(kfree_skb_list_reason);
+
+void kfree_skb_list(struct sk_buff *segs)
+{
+	kfree_skb_list_reason(segs, SKB_DROP_REASON_NOT_SPECIFIED);
+}
 EXPORT_SYMBOL(kfree_skb_list);
 
 /* Dump skb information and contents.
-- 
2.17.1

