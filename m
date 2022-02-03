Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A982E4A87CA
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 16:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351305AbiBCPit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 10:38:49 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:44082 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349835AbiBCPio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 10:38:44 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 213FBd4o010676;
        Thu, 3 Feb 2022 15:37:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=mz8Spix1ShjoE1Nfrfza/PYM4UjGTg6N/DcL7p+oX/o=;
 b=V35keS3o5ffrQVbzuuuEDn6a5/Vr1v48w97X6U3ow8oFUmyu4FDQEZBPulPMT/XzzEgA
 ZFDFiDihP0ET6YqZ2xhsIFhB8QFWBzaaliEQJglsQGCvHQRvoP7O2B/ts2BF7uJsZcpZ
 AgkcsYbxDjmMLjcpWSH8bXN6YRlP/kqQcQRmYq/aAYdQt70zWTWxfzBAFYKZDOMTWtUs
 Uiz1knCpZL+HPp4sOTU9zXJEibklgtxNnsWIBiEU3T1mevkAv4WylprWS2oM29vMWwk9
 6QtdlEvYxATcyewPFpTxbm7+KbI/m2R+y5px49YJGfkzznMt6wnP0MQIFGzUsYbvGK7G /Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e0hfs82ce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Feb 2022 15:37:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 213FVILx184560;
        Thu, 3 Feb 2022 15:37:45 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2045.outbound.protection.outlook.com [104.47.57.45])
        by aserp3020.oracle.com with ESMTP id 3dvwdaj9de-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Feb 2022 15:37:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cp5oXnj4ZB34dVBZQH19/1L5984cfY/RAdmtHoaGNNEQ4XU61AHnMaC6vxLmJdVEdqY53uRNkB+IpZsTIRLjv8d3lJbvpoV2eQMKi5xC76PPgJwSbXJ5qehCEDcWIMZJc0BxFDUUnO3nBcMLvucqhYeyhVg8h4st3T5PcebQ5NMhV8OkKj87iGUu1u31PE7axR4KdSdzOsrSJmn83kM5tbxKjZ4PxUl8a2awOLuL6PpKB2a6JZt0H8JZwCwTsiBqVBlNAVf/wpKe3vVnTN9+pwJJGQXrmXEnbM7wfxiwzNehpLL/ZOydfo0OvPrILYwiOX+u8MZw4YRl7/QU62noaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mz8Spix1ShjoE1Nfrfza/PYM4UjGTg6N/DcL7p+oX/o=;
 b=cq773vcdwDRb0YCNcAMvovIvVR4kfTSct53AoDmQAn4wiQmgx2KSI2sG2YUljMT7t66olzHMXRaLOm7MNJee+YSqbQXpq4haBYEe5heJSiaLdjlfntTdnkuuq1gZXDIba0gMXa9jwmyjF2nUk99aNIDp0LwryhFWX/Y9GSNtkeOEyU8kRSETAe8MkNHZegXlMJhPDPjqR4l8nzdXfSY/+Iv2PGM6LyrSotqSNmt9QBTYa37nUGt8ZVcMV5m9fte/QTCduK00WzOoOlibYIFAn0qwpy7wd1iYV31b9wZI0IDtRGD0YtG2JRDH9h38bbbVGJxT++kIY62qHCYzWbwXdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mz8Spix1ShjoE1Nfrfza/PYM4UjGTg6N/DcL7p+oX/o=;
 b=uKvgEgFmod5ORxnya1xQzcECPdLzrq9q5XpuxnLeUQWRgd/a0UY+UBY1tOEART9tA7r/XvTyeIUbe/c8FJGMB1NV0VmKFARXWhkdBO2i5tyfi8cGyVDfGvp4BSHo6RghY1ZJyt3FG8JU3AqDR66k8838rjX/Bguucfmxco/3IOo=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by BN7PR10MB2436.namprd10.prod.outlook.com (2603:10b6:406:c3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Thu, 3 Feb
 2022 15:37:43 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::60be:11d2:239:dcef]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::60be:11d2:239:dcef%7]) with mapi id 15.20.4930.021; Thu, 3 Feb 2022
 15:37:43 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        imagedong@tencent.com, joao.m.martins@oracle.com,
        joe.jin@oracle.com
Subject: [PATCH RFC 1/4] net: skb: use line number to trace dropped skb
Date:   Thu,  3 Feb 2022 07:37:28 -0800
Message-Id: <20220203153731.8992-2-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220203153731.8992-1-dongli.zhang@oracle.com>
References: <20220203153731.8992-1-dongli.zhang@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::27) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 631ef7fe-cdf6-42de-5606-08d9e72b1e62
X-MS-TrafficTypeDiagnostic: BN7PR10MB2436:EE_
X-Microsoft-Antispam-PRVS: <BN7PR10MB2436224D20B74FEE26228E9EF0289@BN7PR10MB2436.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:103;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oA4QIzcpH0OFuXr7WANHQ4aGaFyD2jJyOfz16jf/7njuv405w1sRbZdmsANLqT12bS6tPdDTxlTvbC+malH5TsQd2kLVI9T+vnz9f6rVYLoxhX49yyJ/OAFpiPakK5gOdKo0diVsXEeFaLtAYDawPwTHD1+OrH4l9qee/GAd0BA9B0pLUdJBcDjB956AwSumeP22fP0ODo8KIjiWpaGiRpB2wvr/Jt7u2cx+LFlLZ4f50PWpIfcVOC459WgisWUYt6WcIHPFGytLcdNaYAz1P+3oZpmE1RIr+WrmAqEmaXNRAsmyr9GCWHxHE6Qgkg4pNFcgDUBvgtL5X4SdofsXrs5KhYAlBJKjXw7gW2uE5fcWKlQ9LAgaX5Yo76d7CXBoG0mPwrL5bpKWFlXJyJIRTBlVj1evKVX2kZWQgVApi/LQa2ifv89s/DK7jHFr++GTVoYGUz9JR0TdHnCmM2u56z2CQw8cXdIOB9GAzQTAOUHYLBACloGtXQ9uW2Td3AcrLXbnYu/em8pKWzoFQLRmWGwGXTQiBf3inBBbrYbQGCstb5Q8+jRkQeUsJovscsmMJ8XcUYi6SWGHG57UeWhsFVQEVajk/ko6r9Q0yyl0Ym4i/MhBBQ6OvLIdVmXpMKyHGVecSb5NxmQBrT5ToBNTODACQyhY5AnK6r3/UOsZ0a1mh9/anHF667Wi+FJiynLePye3f3OJbPR2rmgkP+UYpA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(44832011)(66476007)(52116002)(6512007)(107886003)(7416002)(2906002)(8936002)(66946007)(6506007)(2616005)(66556008)(4326008)(86362001)(6666004)(508600001)(5660300002)(8676002)(186003)(26005)(6486002)(83380400001)(38100700002)(38350700002)(36756003)(316002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lXJEIXsVDjL8uZpQC1qH8I/8jU6J+mAonCn8jv9e86+MZaEaNvD+2udCOxZy?=
 =?us-ascii?Q?JO/IzY7DVK+VLIco1torFwX5dm8/RpgvkhWqah5JZ2GyzdgZ2ayA/z3syOip?=
 =?us-ascii?Q?mQ/a3StBoEaq8JUgdI2Q7Z/2EbewwXpt4wdVVEnwShN/CP9HVMrhMTn6PVqe?=
 =?us-ascii?Q?r6n2A6XnjzCzTfXl06SQq7me71sVOgRSr34AaMQlb2nNwPRsr+ZPfcPDEuAf?=
 =?us-ascii?Q?XDtWSK1I6jfKEPWgHzh0tLPICE1kmpWAOt3UMJsDwf03LnHPlHkUd7E24jOe?=
 =?us-ascii?Q?i2mUo24gprhLo+EOACl/gHvtHcSWSGSfSp4ETwWRLgM0gv6HkIZ12JONWVk3?=
 =?us-ascii?Q?pDuBVCyT954IDeJ9PYkKaZW9bqh1GYyzmhtkWUu0WF0HyqEx7aU8R5SN431b?=
 =?us-ascii?Q?YjO/VmXc+wWVApadZX6TtJKoy8ea5UdThkf3gtUODDIg06odY5YfVekGnAds?=
 =?us-ascii?Q?T1yi9/mRN+gh9t+8rfrn6bIhguE2fu3auM8Xe6QL3oJr6hwEkQv9Cy8MwShE?=
 =?us-ascii?Q?4iQ8A0X4HQ6QjhQL7V95GGtVZ2w96WU6RztxKm0rkGF91MZSwsrv02BGAg8w?=
 =?us-ascii?Q?Ri7bwglhQYgSxvNov51VGIlzr5IE3jxg247ofJuyq8wSUgaZtNPVyUOWaeNw?=
 =?us-ascii?Q?QpbnVN2eRV6U7FClBKmcPJauKvM6gLJCrlumMt8lAEC+izD9P14nZJcB1XHn?=
 =?us-ascii?Q?+yJzyXp75z4bZRi13EPV+uVLYVevd7utp2W7CWeXyvWFHGy4X6r055gq6cMP?=
 =?us-ascii?Q?cEkfpnX8MKgtoKrStUjt0qeAoA5bUx+KW1yUNQD53u41/gTUJgRS0FSy9DP5?=
 =?us-ascii?Q?QDFZIhjfsbskGeCYWsK84+jrGJ0IG0NMraJyzRo4YCg9yLUMzTVMgH3ANroa?=
 =?us-ascii?Q?UrHltCDOePz32LnaHMjRjlNe88YROh2dAgFR5mIVZ5Uqk+L5iL9PkVolt4V8?=
 =?us-ascii?Q?2XWRwlyL+u48CIRWJCQFkpcDiwsfEP5uR2uiIVliYk4ZKQVE9eYkyUR9JL3t?=
 =?us-ascii?Q?2wfc3hB7QYZiJh+yAgPTBm4xsCEhd0yYYmfboAk8n65UjdVPUYnlsp1wEYO0?=
 =?us-ascii?Q?jfXDmUieKKph3/ztD9F2rJIkO9bz1btQFkGZ0YShAmDHMAtO09bPTX80Cyyn?=
 =?us-ascii?Q?AJmrdP1E2cQbADjBZlv0aiMxS5GL9Y3V1pk0bz6nGSdHvoBSLG7MpcNSlrup?=
 =?us-ascii?Q?ThzCpEGrHakJ88YlZBfnBoFLrTJfQ1t27yRNptDY3v3Km7YZKAvRt5Oec8Am?=
 =?us-ascii?Q?HUhISrGcWCUu1iJ22g2oH7VxhDR+j+wfngq+aWLluGvCCeO3daIPUkl6GWm9?=
 =?us-ascii?Q?+SuOa/Q6qNq76IAZezhtZ/p+gguQeVwIR63GuE801XUEjEurcMQ9jYAubatl?=
 =?us-ascii?Q?6qrma4yAGC7gesc8WhGEyRCxMB0pEbDu/E2/umjZU9L51bd2CimGZePTyoGo?=
 =?us-ascii?Q?/yvs50AszPcQdHazhm/ug4pZyqKfQItwtOXcJChI1lMqBM3XT2BjvV2hit/F?=
 =?us-ascii?Q?oE/h2UrxR6q92q8axxrGudE1K57jSpzFasHQSVRSyzj8CDdjC8BXdx6PR0wI?=
 =?us-ascii?Q?jBxCtEqpSCko6SsYGwt71PDD0hgLLrOo0ZIcrVsK3HRzUIifWvsOH8v3Vs77?=
 =?us-ascii?Q?PZZoO4heRPD03Aeug0FC7TA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 631ef7fe-cdf6-42de-5606-08d9e72b1e62
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2022 15:37:43.0725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fq6SYid2oDZiQMbJt9MCziyHDAWvCf0LqEUcRj0u9He57Jru+bqMNcvxRjINFxUBhKS1OCQZQQD7gMo5/sbNZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2436
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10247 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202030096
X-Proofpoint-ORIG-GUID: 3sM4gJ6_7VNWpQ5_R960BF45RQM_A6v8
X-Proofpoint-GUID: 3sM4gJ6_7VNWpQ5_R960BF45RQM_A6v8
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sometimes the kernel may not directly call kfree_skb() to drop the sk_buff.
Instead, it "goto drop" and call kfree_skb() at 'drop'. This make it
difficult to track the reason that the sk_buff is dropped.

The commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()") has
introduced the kfree_skb_reason() to help track the reason. However, we may
need to define many reasons for each driver/subsystem.

To avoid introducing so many new reasons, this is to use line number
("__LINE__") to trace where the sk_buff is dropped. As a result, the reason
will be generated automatically.

Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 include/linux/skbuff.h     | 21 ++++-----------------
 include/trace/events/skb.h | 35 ++++++-----------------------------
 net/core/dev.c             |  2 +-
 net/core/skbuff.c          |  9 ++++-----
 net/ipv4/tcp_ipv4.c        | 14 +++++++-------
 net/ipv4/udp.c             | 14 +++++++-------
 6 files changed, 29 insertions(+), 66 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 8a636e678902..471268a4a497 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -307,21 +307,8 @@ struct sk_buff_head {
 
 struct sk_buff;
 
-/* The reason of skb drop, which is used in kfree_skb_reason().
- * en...maybe they should be splited by group?
- *
- * Each item here should also be in 'TRACE_SKB_DROP_REASON', which is
- * used to translate the reason to string.
- */
-enum skb_drop_reason {
-	SKB_DROP_REASON_NOT_SPECIFIED,
-	SKB_DROP_REASON_NO_SOCKET,
-	SKB_DROP_REASON_PKT_TOO_SMALL,
-	SKB_DROP_REASON_TCP_CSUM,
-	SKB_DROP_REASON_SOCKET_FILTER,
-	SKB_DROP_REASON_UDP_CSUM,
-	SKB_DROP_REASON_MAX,
-};
+#define SKB_DROP_LINE_NONE	0
+#define SKB_DROP_LINE		__LINE__
 
 /* To allow 64K frame to be packed as single skb without frag_list we
  * require 64K/PAGE_SIZE pages plus 1 additional page to allow for
@@ -1103,7 +1090,7 @@ static inline bool skb_unref(struct sk_buff *skb)
 	return true;
 }
 
-void kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason);
+void kfree_skb_reason(struct sk_buff *skb, unsigned int line);
 
 /**
  *	kfree_skb - free an sk_buff with 'NOT_SPECIFIED' reason
@@ -1111,7 +1098,7 @@ void kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason);
  */
 static inline void kfree_skb(struct sk_buff *skb)
 {
-	kfree_skb_reason(skb, SKB_DROP_REASON_NOT_SPECIFIED);
+	kfree_skb_reason(skb, SKB_DROP_LINE_NONE);
 }
 
 void skb_release_head_state(struct sk_buff *skb);
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index a8a64b97504d..45d1a1757ff1 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -9,56 +9,33 @@
 #include <linux/netdevice.h>
 #include <linux/tracepoint.h>
 
-#define TRACE_SKB_DROP_REASON					\
-	EM(SKB_DROP_REASON_NOT_SPECIFIED, NOT_SPECIFIED)	\
-	EM(SKB_DROP_REASON_NO_SOCKET, NO_SOCKET)		\
-	EM(SKB_DROP_REASON_PKT_TOO_SMALL, PKT_TOO_SMALL)	\
-	EM(SKB_DROP_REASON_TCP_CSUM, TCP_CSUM)			\
-	EM(SKB_DROP_REASON_SOCKET_FILTER, SOCKET_FILTER)	\
-	EM(SKB_DROP_REASON_UDP_CSUM, UDP_CSUM)			\
-	EMe(SKB_DROP_REASON_MAX, MAX)
-
-#undef EM
-#undef EMe
-
-#define EM(a, b)	TRACE_DEFINE_ENUM(a);
-#define EMe(a, b)	TRACE_DEFINE_ENUM(a);
-
-TRACE_SKB_DROP_REASON
-
-#undef EM
-#undef EMe
-#define EM(a, b)	{ a, #b },
-#define EMe(a, b)	{ a, #b }
-
 /*
  * Tracepoint for free an sk_buff:
  */
 TRACE_EVENT(kfree_skb,
 
 	TP_PROTO(struct sk_buff *skb, void *location,
-		 enum skb_drop_reason reason),
+		 unsigned int line),
 
-	TP_ARGS(skb, location, reason),
+	TP_ARGS(skb, location, line),
 
 	TP_STRUCT__entry(
 		__field(void *,		skbaddr)
 		__field(void *,		location)
 		__field(unsigned short,	protocol)
-		__field(enum skb_drop_reason,	reason)
+		__field(unsigned int,	line)
 	),
 
 	TP_fast_assign(
 		__entry->skbaddr = skb;
 		__entry->location = location;
 		__entry->protocol = ntohs(skb->protocol);
-		__entry->reason = reason;
+		__entry->line = line;
 	),
 
-	TP_printk("skbaddr=%p protocol=%u location=%p reason: %s",
+	TP_printk("skbaddr=%p protocol=%u location=%p line: %u",
 		  __entry->skbaddr, __entry->protocol, __entry->location,
-		  __print_symbolic(__entry->reason,
-				   TRACE_SKB_DROP_REASON))
+		  __entry->line)
 );
 
 TRACE_EVENT(consume_skb,
diff --git a/net/core/dev.c b/net/core/dev.c
index 1baab07820f6..448f390d35d3 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4900,7 +4900,7 @@ static __latent_entropy void net_tx_action(struct softirq_action *h)
 				trace_consume_skb(skb);
 			else
 				trace_kfree_skb(skb, net_tx_action,
-						SKB_DROP_REASON_NOT_SPECIFIED);
+						SKB_DROP_LINE);
 
 			if (skb->fclone != SKB_FCLONE_UNAVAILABLE)
 				__kfree_skb(skb);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 0118f0afaa4f..8572c3bce264 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -761,18 +761,17 @@ EXPORT_SYMBOL(__kfree_skb);
 /**
  *	kfree_skb_reason - free an sk_buff with special reason
  *	@skb: buffer to free
- *	@reason: reason why this skb is dropped
+ *	@line: the line where this skb is dropped
  *
  *	Drop a reference to the buffer and free it if the usage count has
- *	hit zero. Meanwhile, pass the drop reason to 'kfree_skb'
- *	tracepoint.
+ *	hit zero. Meanwhile, pass the drop line to 'kfree_skb' tracepoint.
  */
-void kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
+void kfree_skb_reason(struct sk_buff *skb, unsigned int line)
 {
 	if (!skb_unref(skb))
 		return;
 
-	trace_kfree_skb(skb, __builtin_return_address(0), reason);
+	trace_kfree_skb(skb, __builtin_return_address(0), line);
 	__kfree_skb(skb);
 }
 EXPORT_SYMBOL(kfree_skb_reason);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index fec656f5a39e..f23af94d1186 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1971,10 +1971,10 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	const struct tcphdr *th;
 	bool refcounted;
 	struct sock *sk;
-	int drop_reason;
+	unsigned int drop_line;
 	int ret;
 
-	drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
+	drop_line = SKB_DROP_LINE_NONE;
 	if (skb->pkt_type != PACKET_HOST)
 		goto discard_it;
 
@@ -1987,7 +1987,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	th = (const struct tcphdr *)skb->data;
 
 	if (unlikely(th->doff < sizeof(struct tcphdr) / 4)) {
-		drop_reason = SKB_DROP_REASON_PKT_TOO_SMALL;
+		drop_line = SKB_DROP_LINE;
 		goto bad_packet;
 	}
 	if (!pskb_may_pull(skb, th->doff * 4))
@@ -2095,7 +2095,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	nf_reset_ct(skb);
 
 	if (tcp_filter(sk, skb)) {
-		drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
+		drop_line = SKB_DROP_LINE;
 		goto discard_and_relse;
 	}
 	th = (const struct tcphdr *)skb->data;
@@ -2130,7 +2130,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	return ret;
 
 no_tcp_socket:
-	drop_reason = SKB_DROP_REASON_NO_SOCKET;
+	drop_line = SKB_DROP_LINE;
 	if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb))
 		goto discard_it;
 
@@ -2138,7 +2138,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 
 	if (tcp_checksum_complete(skb)) {
 csum_error:
-		drop_reason = SKB_DROP_REASON_TCP_CSUM;
+		drop_line = SKB_DROP_LINE;
 		trace_tcp_bad_csum(skb);
 		__TCP_INC_STATS(net, TCP_MIB_CSUMERRORS);
 bad_packet:
@@ -2149,7 +2149,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 
 discard_it:
 	/* Discard frame. */
-	kfree_skb_reason(skb, drop_reason);
+	kfree_skb_reason(skb, drop_line);
 	return 0;
 
 discard_and_relse:
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 090360939401..f0715d1072d7 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2411,9 +2411,9 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	__be32 saddr, daddr;
 	struct net *net = dev_net(skb->dev);
 	bool refcounted;
-	int drop_reason;
+	unsigned int drop_line;
 
-	drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
+	drop_line = SKB_DROP_LINE_NONE;
 
 	/*
 	 *  Validate the packet.
@@ -2469,7 +2469,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	if (udp_lib_checksum_complete(skb))
 		goto csum_error;
 
-	drop_reason = SKB_DROP_REASON_NO_SOCKET;
+	drop_line = SKB_DROP_LINE;
 	__UDP_INC_STATS(net, UDP_MIB_NOPORTS, proto == IPPROTO_UDPLITE);
 	icmp_send(skb, ICMP_DEST_UNREACH, ICMP_PORT_UNREACH, 0);
 
@@ -2477,11 +2477,11 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	 * Hmm.  We got an UDP packet to a port to which we
 	 * don't wanna listen.  Ignore it.
 	 */
-	kfree_skb_reason(skb, drop_reason);
+	kfree_skb_reason(skb, drop_line);
 	return 0;
 
 short_packet:
-	drop_reason = SKB_DROP_REASON_PKT_TOO_SMALL;
+	drop_line = SKB_DROP_LINE;
 	net_dbg_ratelimited("UDP%s: short packet: From %pI4:%u %d/%d to %pI4:%u\n",
 			    proto == IPPROTO_UDPLITE ? "Lite" : "",
 			    &saddr, ntohs(uh->source),
@@ -2494,7 +2494,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	 * RFC1122: OK.  Discards the bad packet silently (as far as
 	 * the network is concerned, anyway) as per 4.1.3.4 (MUST).
 	 */
-	drop_reason = SKB_DROP_REASON_UDP_CSUM;
+	drop_line = SKB_DROP_LINE;
 	net_dbg_ratelimited("UDP%s: bad checksum. From %pI4:%u to %pI4:%u ulen %d\n",
 			    proto == IPPROTO_UDPLITE ? "Lite" : "",
 			    &saddr, ntohs(uh->source), &daddr, ntohs(uh->dest),
@@ -2502,7 +2502,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	__UDP_INC_STATS(net, UDP_MIB_CSUMERRORS, proto == IPPROTO_UDPLITE);
 drop:
 	__UDP_INC_STATS(net, UDP_MIB_INERRORS, proto == IPPROTO_UDPLITE);
-	kfree_skb_reason(skb, drop_reason);
+	kfree_skb_reason(skb, drop_line);
 	return 0;
 }
 
-- 
2.17.1

