Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 430004A87CD
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 16:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351917AbiBCPiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 10:38:50 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:43678 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351906AbiBCPio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 10:38:44 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 213F9n36024860;
        Thu, 3 Feb 2022 15:37:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=y5cmkg6mXDlXoJ0Ep4GjPJo3MxoloxdWBKwIVYMUa7k=;
 b=RNIgFfVIuSFw9tPr9BL0ZJY8ELY0N816/CNUBWD2swi+smDk57cwuScmdiS+LKtN0QGz
 2HaPZ41sPJ+hUcTcB4Nh4uQbVhmqK1e/RcIWKpgJNK2i+i97G08UOtdUJMczw+MX02TU
 SJ43hVdx0bhn3MieN6y4MrKhp3jA2b6qfIOZnI6YHCEWzLsdE6dv/psknTM2gkOvJowg
 y1+IVy6VJw2ymkr45VBO/hm7lAs8mFuhSV8Gqere7DwGQr3u0t8mbLVNR16T7JMpD2wQ
 KLgKhmYM0HyWrtJcqxNZgFYBrqFPfSzd3Pdo3ItV0lEZd1H7cdvnmciUeCKU+huVDQoE uw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e0hevr302-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Feb 2022 15:37:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 213FVIM0184560;
        Thu, 3 Feb 2022 15:37:46 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2045.outbound.protection.outlook.com [104.47.57.45])
        by aserp3020.oracle.com with ESMTP id 3dvwdaj9de-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Feb 2022 15:37:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cw5JMRMVdPi8OiBOPIx5PMUT/DdcM762JSVcWm4xaPOiA91NJIxephOSYq1mV8GfX02E9N9o2YORu3odvGgy7I8PZc2lfKgKePfTp+qyuRxBEk083fmYkoO7QGLSboFNL8YqPGtbjLu9EjWRo9MFTEs+7esc75qGW18iHNCZwbBCHw+FCr4no+RXP8laDgRT7AvRgTKvLRuNISiUeUuToDJU8tvcV5Pub/S8eYzPabgTnUNDk3oQpqhiNh7WDAPHcwT7o3UOPb0sKx7RbeU86uqIdRXlxKe9DIfrX3G45C3kw0f07LZcDZQEVdi9zVd+gbD5HyOR0UVUsMd+6oNKSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y5cmkg6mXDlXoJ0Ep4GjPJo3MxoloxdWBKwIVYMUa7k=;
 b=bBOoYT1PaUw5ZXrC4F8xMU2pnq6QHqxyFzKSD8NlGZlkgX3wr/wCb/fd/ZuJ1bfrFitIYU2gfeeS4NWVlrd+7Aiw4jvpi3bhlayP9PK+ifAQkUrYlzcQI8YOTyooPhWl+MsUeeoPYJSpISNu25x5yNrWxgGtRN4Suc8kqbWpT0+yeGh+ptJlgk65Gj/N3tjmcLcD6NSO7ZBLF4E2uTvFB80mzB/thE56um0sP/ycsFrwgSwXmpGWOzo2DbEqbitynAoFj+/oPVTH+TrkxREEX9bnvZRhK58sT/slgNJJry0GCoSZ1FRGk0ThBZL8Lj4MH6PINqoA63rW7VFDhsKHLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y5cmkg6mXDlXoJ0Ep4GjPJo3MxoloxdWBKwIVYMUa7k=;
 b=l7V5ZQqDpa8fP/aq9WNK/ocdMdjz5HeJj/o2I16vwWiNZsToFJdPoBZ+ruD8jq2yDpudcTVhmpMwjTGrAf8nEwiDv/gEV/X8Pvx5sDT+v2TEmAb6wZRtC7GyoxdRPjMn96mD19u2vcuF/yOOEKQpqc48pDExM3ofJU/9reNF3hw=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by BN7PR10MB2436.namprd10.prod.outlook.com (2603:10b6:406:c3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Thu, 3 Feb
 2022 15:37:44 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::60be:11d2:239:dcef]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::60be:11d2:239:dcef%7]) with mapi id 15.20.4930.021; Thu, 3 Feb 2022
 15:37:44 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        imagedong@tencent.com, joao.m.martins@oracle.com,
        joe.jin@oracle.com
Subject: [PATCH RFC 2/4] net: skb: add function name as part of reason
Date:   Thu,  3 Feb 2022 07:37:29 -0800
Message-Id: <20220203153731.8992-3-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220203153731.8992-1-dongli.zhang@oracle.com>
References: <20220203153731.8992-1-dongli.zhang@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::27) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d122fc48-f27a-41c9-db50-08d9e72b1ea9
X-MS-TrafficTypeDiagnostic: BN7PR10MB2436:EE_
X-Microsoft-Antispam-PRVS: <BN7PR10MB2436FA8D73E1F4D2578810BBF0289@BN7PR10MB2436.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 00QtDgWPKAS9PUmCYIv+5aHN/0wVY2scqoIhJ5fiMFs8zzbU0einsNg8BxLfiqznW983R1NuAtVPprZfbcXYByiIVecGOHO4Fv9nVdmGj65TKrtwgUpoqMlyE+wMBxlJds+v1OfpMnU4qcDkY5SigBRoJDRXnXZ5mCYjNBJfzkv6MZN1+qf5h/kBthMoRN3ghG7easK3jOsf6ShEitTOg7rqVgu1nUA3hz2nZzBlB9DLrbh971qe2No57yArEAW3IysLtnmPBHlAn3MBOP+AclJdgYFGFstBNOKaj2hy5cj7BSiElpYRd8vhSKuK2XxqBsOEE1lkZJXaSPoOtceLDJRs3PLjimZLMfhNMKM3KfXFQsWcrXF7Nyd3ReBEolxm6yjbzOrlXrjrLCJHgpHmVyApsotJPiwTLYAe7JMxpZihX7uLmj3fl+q1zUD4xr2QRah10u9i9fQTkq3ZZVLGrNcxlT3hDPrLseZy+RwZM6LCJI3Ef5jT7fzIUz3L/SuYvUX8xWiNdgPI3JXyoSVXeJ7qcyJ6Ryd+AMVIJIXjAMVKeMXawLjVAuUjg/ih+NI9jkDZuoF6v1sOrzc9C1d/b17KP7MgXuFfZhBb3D+kegbl9Z5cu8NoJVdI8c9FWXfYDnhA6HocaDcESOhZRTCqo2X6jLpnv18615sfu/JDJ+OMjWLmzUWgGYESIkvPVD6wxan5LIm+fx5PfX26mBfJ1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(44832011)(66476007)(52116002)(6512007)(107886003)(7416002)(2906002)(8936002)(66946007)(6506007)(2616005)(66556008)(4326008)(86362001)(6666004)(508600001)(5660300002)(8676002)(186003)(26005)(6486002)(83380400001)(38100700002)(38350700002)(36756003)(316002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZsbSjYba4ws7b43EH2+3ctJE7dgN/edWqQPAxXuKUqthz3S7yAUd+pzESTNP?=
 =?us-ascii?Q?rA5udRhAbQnzJfVg2AWF7gJ/FqGeufkkyCDLV15RME1cho9mP+YBFUduF/ej?=
 =?us-ascii?Q?QHnRvwBq7NqpDGISLvQvySr5KEtDIX+SUIFM4rUaPrqloZUEHc0fEsYAdZA5?=
 =?us-ascii?Q?z3ppauBl9Jp5Le78CRkjSot9U+UBhdtF2QKwpxRmpBRHtAY/tV8oqK38FQRO?=
 =?us-ascii?Q?ZfQm8+rw/jJBnuBk9rYu638clyJtwv9+riXWRLzpbYejCYNDdKvnfnJ5knc/?=
 =?us-ascii?Q?dJ4s5r4hpf1X28GUMiZRu/isPeYroqPJNsRdsHNsDhNnXURLoJApbJG+eoVQ?=
 =?us-ascii?Q?veTVdZ7fxu9cwFkC3jj0NcFrkWmZnoMMUoXg6W3tuypGkvwNneNmQdILISTX?=
 =?us-ascii?Q?T74nQNbMpB79pyes2Cwp1zpvfWnssiru4yBRj602xGOUVj15mc60LCaW8eL5?=
 =?us-ascii?Q?B4kvcB+7mDktisd/mr2ArLWLhZ2fcs8LtuZ5l8h5uRCX7/rjOmQa1vROZMnu?=
 =?us-ascii?Q?nnn7Lj8+2LjMb52W6aTjt9Fx5MlMGMYbgjLMQO27AWuRIGYcuZmdGb58cnI7?=
 =?us-ascii?Q?9eMjQsa9MgM3HlRe2HEpEl6RgCEBXdiK8almpPAO8lxlQiBFwKmUT1c5wjtc?=
 =?us-ascii?Q?ekiJbeLw2+5O51y5wl22D1B/T39V02SAAa2yBPfi/eoLd2fIYHkXcSfjUuPr?=
 =?us-ascii?Q?s6eLRLdNOA0fHPbP5Mdt1rlL3vLncSiwBrbfymwr4eFzmDe8FMw+G6sbStcw?=
 =?us-ascii?Q?0HSfFjK5Z1d1v9fn4fg2znBAq+k+ercWD8BJIpISsCn1pcAW1aIoh35bbWrt?=
 =?us-ascii?Q?5Gts4Xkup3F7WIvoPraXbcg00IacP5kp5m+wO+V0ZM0VikvtNCQ16cbS5ocw?=
 =?us-ascii?Q?qgKDV91o1+Sk4hYuiuLCk34OvkZNqfD4T9rLin3zrp9H1l2JC304/oZ2A19q?=
 =?us-ascii?Q?f1qe4N5R9mRSCSKLOnRhTnrNaY4I2rZx2XmkqVlZSeZfjCl/mI1mNwKTN0bY?=
 =?us-ascii?Q?L5o6KjK03JVCj2bTV20E7JigAGVxVPLcRhk6+q8II2gfGAZZ/kv27OxruKhV?=
 =?us-ascii?Q?xKumgs2reEV67a4nQq/smRU65iVQygUCGGvNrd3ws7WQXjNNEjNRsWAQPSlH?=
 =?us-ascii?Q?bQRupYS/itjbW5Na1fvUpe42PCJW3gwBdRxGOantTmAxzQWztMt4sWtL/102?=
 =?us-ascii?Q?9olR7xk6gzwa4cLpLxgyKYkRnzAfUlqa7pvLOt8xvhvSW27L/487z8cH1tcO?=
 =?us-ascii?Q?041aqPtC8vgQ55EoK4f+Ed0a3QwhCfNzgnL6nZeln8kyUQM8RXFmle+WQp9Y?=
 =?us-ascii?Q?6F7cEkMtKzN77WL7nv3UvRY9/mq4TWGw1w9umIJqeatC/1K7qsseEGNYqJ8b?=
 =?us-ascii?Q?9636jQJPOBeR7FdK26f4hqzmnA2hTZ+VehFcWHgm1jA0URd5wrZ8TqCsneWp?=
 =?us-ascii?Q?PIWWgKG4mJJo9OGpfyJ/Usfis7GFVuptMJeWHkCPKABZYviTspP6Ax/mugCp?=
 =?us-ascii?Q?LgEamgNr3jOjoKbHGRKP5yhE7v5n1bRul7WdGTECkIqDz4WSvuIQdReM6yC+?=
 =?us-ascii?Q?sWT6zfg/i7kDK6dsZ1BNFRp/9tN8yuvBRPUtxl13yv1xmzVmg6jjrKryvz5x?=
 =?us-ascii?Q?486UHn61AmPp49+ZcW/hYQc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d122fc48-f27a-41c9-db50-08d9e72b1ea9
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2022 15:37:43.5412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mAG6/dnVqcBRXIVVNsysBJFDro6xX3KzWwHZjYgAiJ8PK3c3UWYYtxv30a4fHN5OLZYBlOgpV8ijIDlT2IKLdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2436
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10247 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202030096
X-Proofpoint-GUID: Jlmht3RoNF0DzJOmZDNLaXn849Ker-z1
X-Proofpoint-ORIG-GUID: Jlmht3RoNF0DzJOmZDNLaXn849Ker-z1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In addition to the line number ("__LINE__"), this is to make the
function name ("__func__", which is the caller of kfree_skb_reason())
as part of reason.

The (function, line) combination is able to uniquely represent where the
sk_buff is dropped.

The existing trace_kfree_skb() is able to trace the 'location'. While it
is fine to either echo 'stacktrace' to the trigger, or trace at
userspace via ebpf, the TP_printk will only print %p.

With the function name, the TP_printk will tell the function and the
line number that the sk_buff is dropped.

Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 include/linux/skbuff.h     |  7 +++++--
 include/trace/events/skb.h | 10 ++++++----
 net/core/dev.c             |  1 +
 net/core/skbuff.c          |  9 ++++++---
 net/ipv4/tcp_ipv4.c        |  2 +-
 net/ipv4/udp.c             |  4 ++--
 6 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 471268a4a497..10bcbe4f690f 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -309,6 +309,8 @@ struct sk_buff;
 
 #define SKB_DROP_LINE_NONE	0
 #define SKB_DROP_LINE		__LINE__
+#define SKB_DROP_FUNC_NONE	"none"
+#define SKB_DROP_FUNC		__func__
 
 /* To allow 64K frame to be packed as single skb without frag_list we
  * require 64K/PAGE_SIZE pages plus 1 additional page to allow for
@@ -1090,7 +1092,8 @@ static inline bool skb_unref(struct sk_buff *skb)
 	return true;
 }
 
-void kfree_skb_reason(struct sk_buff *skb, unsigned int line);
+void kfree_skb_reason(struct sk_buff *skb, const char *func,
+		      unsigned int line);
 
 /**
  *	kfree_skb - free an sk_buff with 'NOT_SPECIFIED' reason
@@ -1098,7 +1101,7 @@ void kfree_skb_reason(struct sk_buff *skb, unsigned int line);
  */
 static inline void kfree_skb(struct sk_buff *skb)
 {
-	kfree_skb_reason(skb, SKB_DROP_LINE_NONE);
+	kfree_skb_reason(skb, SKB_DROP_FUNC_NONE, SKB_DROP_LINE_NONE);
 }
 
 void skb_release_head_state(struct sk_buff *skb);
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 45d1a1757ff1..b63bf724809e 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -15,14 +15,15 @@
 TRACE_EVENT(kfree_skb,
 
 	TP_PROTO(struct sk_buff *skb, void *location,
-		 unsigned int line),
+		 const char *function, unsigned int line),
 
-	TP_ARGS(skb, location, line),
+	TP_ARGS(skb, location, function, line),
 
 	TP_STRUCT__entry(
 		__field(void *,		skbaddr)
 		__field(void *,		location)
 		__field(unsigned short,	protocol)
+		__string(function, function)
 		__field(unsigned int,	line)
 	),
 
@@ -30,12 +31,13 @@ TRACE_EVENT(kfree_skb,
 		__entry->skbaddr = skb;
 		__entry->location = location;
 		__entry->protocol = ntohs(skb->protocol);
+		__assign_str(function, function);
 		__entry->line = line;
 	),
 
-	TP_printk("skbaddr=%p protocol=%u location=%p line: %u",
+	TP_printk("skbaddr=%p protocol=%u location=%p function=%s line=%u",
 		  __entry->skbaddr, __entry->protocol, __entry->location,
-		  __entry->line)
+		  __get_str(function), __entry->line)
 );
 
 TRACE_EVENT(consume_skb,
diff --git a/net/core/dev.c b/net/core/dev.c
index 448f390d35d3..3dccd3248de9 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4900,6 +4900,7 @@ static __latent_entropy void net_tx_action(struct softirq_action *h)
 				trace_consume_skb(skb);
 			else
 				trace_kfree_skb(skb, net_tx_action,
+						SKB_DROP_FUNC,
 						SKB_DROP_LINE);
 
 			if (skb->fclone != SKB_FCLONE_UNAVAILABLE)
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 8572c3bce264..f7bceb310912 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -761,17 +761,20 @@ EXPORT_SYMBOL(__kfree_skb);
 /**
  *	kfree_skb_reason - free an sk_buff with special reason
  *	@skb: buffer to free
+ *	@func: the function where this skb is dropped
  *	@line: the line where this skb is dropped
  *
  *	Drop a reference to the buffer and free it if the usage count has
- *	hit zero. Meanwhile, pass the drop line to 'kfree_skb' tracepoint.
+ *	hit zero. Meanwhile, pass the drop function and line to 'kfree_skb'
+ *	tracepoint.
  */
-void kfree_skb_reason(struct sk_buff *skb, unsigned int line)
+void kfree_skb_reason(struct sk_buff *skb, const char *func,
+		      unsigned int line)
 {
 	if (!skb_unref(skb))
 		return;
 
-	trace_kfree_skb(skb, __builtin_return_address(0), line);
+	trace_kfree_skb(skb, __builtin_return_address(0), func, line);
 	__kfree_skb(skb);
 }
 EXPORT_SYMBOL(kfree_skb_reason);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index f23af94d1186..a1cb1252370b 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2149,7 +2149,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 
 discard_it:
 	/* Discard frame. */
-	kfree_skb_reason(skb, drop_line);
+	kfree_skb_reason(skb, SKB_DROP_FUNC, drop_line);
 	return 0;
 
 discard_and_relse:
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index f0715d1072d7..ae86ab56a7dd 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2477,7 +2477,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	 * Hmm.  We got an UDP packet to a port to which we
 	 * don't wanna listen.  Ignore it.
 	 */
-	kfree_skb_reason(skb, drop_line);
+	kfree_skb_reason(skb, SKB_DROP_FUNC, drop_line);
 	return 0;
 
 short_packet:
@@ -2502,7 +2502,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	__UDP_INC_STATS(net, UDP_MIB_CSUMERRORS, proto == IPPROTO_UDPLITE);
 drop:
 	__UDP_INC_STATS(net, UDP_MIB_INERRORS, proto == IPPROTO_UDPLITE);
-	kfree_skb_reason(skb, drop_line);
+	kfree_skb_reason(skb, SKB_DROP_FUNC, drop_line);
 	return 0;
 }
 
-- 
2.17.1

