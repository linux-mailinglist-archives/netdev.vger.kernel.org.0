Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1A54BCA6F
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 20:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243085AbiBSTOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 14:14:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238798AbiBSTOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 14:14:33 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB92329;
        Sat, 19 Feb 2022 11:14:13 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21J9kYQk007284;
        Sat, 19 Feb 2022 19:13:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=hgd7ySqpiIUsg9ORtZaItuO25s2zIWChlLZE2YgNFxI=;
 b=ORMLGsugDvStortdjKlCyUwyiAUVPmwZI8PNUpsCPbx1RZcncd9tJhIcv2un2Ckk1RpT
 5R+nUwWNXrB4/4jXOCYLzfsDVuN+/6UreJyA6OThNXlCLnXJVIOVckmq1RnF1djOruhM
 +t/K8XxP3JATQlMmZc4U/TOJuHC3flwrQmGklZGw86ANP0SvodpjQ+RdL7UrxBd8AxMy
 UPSbvYQJ9F76hR6R2E61ehHOXX87uHbzRWlYJt+nAS7gQJIgIHh7P5OO3hQv1s8arWK0
 vXgQQhD0BjI4UUecS0pvyFpqeBdoeHWuJWCueIc2Lm1xgcPojK2WVeLAB+wx+FQGKqPJ nQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eaq52909y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Feb 2022 19:13:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21JJAgpQ019680;
        Sat, 19 Feb 2022 19:13:12 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2043.outbound.protection.outlook.com [104.47.73.43])
        by aserp3030.oracle.com with ESMTP id 3eapkd0ud9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Feb 2022 19:13:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aJ6kukyS7Q/dm4Oqls0GwJXiTFyqTrhSikJWTe0j4Wr3W7ux7j/3oRAvqoqCyhr3A6QL6nR3B8G1o3gjCLwwHUcI9Gcrj8Z13ZzAOKwZnbaJhIotX9MhS4JKtfhOkJCx29QuRhzxTTyJmJLh0fgZ0CrwglIuhcNwJBgC/SYUKKlNM28ksM3HQj5I5Y0WvxLOdn6JGUxTIynUlPbOJSHDUei6tQoVNyyJy6TFhiegDLpUuSLovY/Lz3rGSrb1XLhfwFE5jadVYtr7hLn4ZPnuhzwU5IBR0yLfsyJyrqtUHIiDIbGSFZoBILX5OiCCUpV+/CgJckvK6rSn/hSjuvW1nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hgd7ySqpiIUsg9ORtZaItuO25s2zIWChlLZE2YgNFxI=;
 b=D6/ujPI8OcPNjrP4S7a02nPZ4bWQ2qYGsw3iPpnmr5d/5Psw6pK8CIaBQu+uuXInMuvGh+BAVlffZFOXgRFOor78xk+ZI3BxCzhPpUAIxM9KLxP8nTJ19MSCzThSwdGGUxpbci1iNXaK2b+sbZ1eMQxtgVliVtun314C2Jp3GdbJzeB/QVgAXhbay75JYCS50w/A6uc8VsLuiONhg5kIqKTNr6/hEybjhb1TE9zIsQjLXjRnPzR28/U90UoWdF+NMYARwl0sYQp7uc1+L4nj2UrY7zkqyXTro0TUe4ZB3oQDxr/bsnLspNlho3wJJLsN4i1yWjaW2n9Y60uwYq5Otg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hgd7ySqpiIUsg9ORtZaItuO25s2zIWChlLZE2YgNFxI=;
 b=TgQg01iNwsgx2GU6ksHfv/6fCLCHekm9vG5HaBorHiZT4XqUZbiMSHVDvVXeVzSTv3y0jwfwyP6/pOhXKKyaYIW2xMLheoQEC1UUmk8IZaxYM6Yt36WjYRtrUgOAGYdRZ9eNVpb8gS5VSUJ/pJEwGZTptCBcDw1uMLp2AxFoSaw=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by SN6PR10MB2928.namprd10.prod.outlook.com (2603:10b6:805:d2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.22; Sat, 19 Feb
 2022 19:13:10 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.4995.024; Sat, 19 Feb 2022
 19:13:10 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
Subject: [PATCH v2 3/3] net: tun: track dropped skb via kfree_skb_reason()
Date:   Sat, 19 Feb 2022 11:12:46 -0800
Message-Id: <20220219191246.4749-4-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220219191246.4749-1-dongli.zhang@oracle.com>
References: <20220219191246.4749-1-dongli.zhang@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0017.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::15) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 917587a1-db2f-47e0-b91c-08d9f3dbde10
X-MS-TrafficTypeDiagnostic: SN6PR10MB2928:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB29281060F98E93DF7623E01FF0389@SN6PR10MB2928.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lF+Ntz3DQosA6SJWCe2jTbOuzY/5GqxC3iD0ag18whKmI+mS/EMZnBwWUYLSs/vTXwQbx+FahSnO/PyGkwn8Wsvi3PgdeGbn1LEr4HVuXR7O1D5DNkL3V4me5E55lL9SUoqm/exzYplBaAG2jFhH8gWkdFxuGZRwutX5P+ky4zS8vZnJBP7LAlKUV9IZMHsCkN32tHJyW4v6qyWouLT2BVLule0vh1SpW8Jm9Hh3JjGKYcQGWRCQ1RDAn3F7hcHTKorZ8bsqXEDx9mWig3lEITRuWYUxMC8LuexKx0TL6NuQ6Ul9eGYqB/2vmkSrcxOnLxQ0CitNDASH0ZbeE3v3iEFOipEOEcREPe9yEnIzsGtnqgkcCdxkYR63srXkB17+OJmYwys7rSdUcSg3VLUYr6EzUdqYWQXB0tKjAvMMkffgiQLYsHoerRSXw3YtEM4L4WYDbPdY0OoAhYHzvv/mVynWdv2iNj6xjmwp25GgDOKUVBKZIRvk28dN/V8N7Se1c9Vz2XsEGiHD9TZolqoorLHanRyNZBOs8TjivdJc8oO/yC1UUee31BYYE7QK0B/iq80+W+Zk3KSvxt6YUlEbufJ9HHJ78lTCr6iz+/aVccEMI+E4qnRWAQ0znBl99Yz/t+/tLFZyM2VWNM0aBzVCOs0M84mEyVeMVc316jCapXiTlzatp5J0imrNc7f1wHbRr781IujHaCjTZ3qZ6YB1kA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7416002)(5660300002)(8936002)(86362001)(316002)(508600001)(8676002)(4326008)(66946007)(6506007)(66476007)(66556008)(52116002)(6666004)(44832011)(38350700002)(186003)(26005)(38100700002)(2616005)(1076003)(36756003)(83380400001)(6486002)(6512007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SXtamCZ7cMXc9CCa7DmPrVBRoiEXw9dudaU/RnUz7zzhGLx0Oz9vcWT1LwxD?=
 =?us-ascii?Q?23sVsnmSyTX7YaG5Q6mTC1B0nn1gncKQ2VWX/pal8QCTrOy8oR0tqJDLxjtx?=
 =?us-ascii?Q?cxyeX4FujufUuPpaBIOoD8a+5aB9iGKatqfz1TzuAA5dtdpLtWzvjkPD5gtF?=
 =?us-ascii?Q?KfacCAtTq+KNFwNaX7uMUaeGtKLXN/b2pwd0ge8oQ+qLLjGwyBEXkO1oHuGa?=
 =?us-ascii?Q?OCdkOmEwfUenDT08cZDuCfcNnP0XnIfKLfLtJ7bAnjhNR9wVXMECm67cn2lV?=
 =?us-ascii?Q?FPtK3hodifjWpFu3R3Km/THv11vEmagF2BkOKqV+e4kO4FnZhgYh/M4Hunfk?=
 =?us-ascii?Q?lEeiUo4f2BcnEVsAq4YwbozjDyfGDLNubjONK01Gje5uOtHBXWSKUM4xt6Gm?=
 =?us-ascii?Q?/OnQH5etb9Cym0NXJZoMAM4De51CWyCu+WGJJh2miCl2AmbKBCgs97APhPGj?=
 =?us-ascii?Q?sdb9OXYmiHcxYUMhj4BqMRAXl7o7yLQ5LWXWqeHfqL7W9RqvIcP9YtDDzSzi?=
 =?us-ascii?Q?OehyGO9BtUWNuNn3TO+C9arr8tR4TJ2x6R4Kt7IhWaj0rOgkQP3Qth3sIcli?=
 =?us-ascii?Q?NhBaWL2345GdU57jiyFJxGIWNgZsjxPH9e4DsXK8hbJZEgjnGYdceVY8JSRs?=
 =?us-ascii?Q?7D7cMGqp3YZchSiJ4hH2maZps18ThO+xTqwjqERrS35KDbT3oN1GpkP9huc+?=
 =?us-ascii?Q?ak+OO+Dr3EkqH/UpNZZQo+Ck/fMsV5f5MyYHdQwwGBs1IN1rjn/9YGLe+mm/?=
 =?us-ascii?Q?SrBaXtox5lsD5v6daza8XCrpO3S+4RXNPUCJA+bnCl2dq2rgA3NXG9YpEb3B?=
 =?us-ascii?Q?w6eGX6kLV7fL4H2yoNxLJKKycuSWdGfaMksWxNzjc4d83d3P1sjzqa0gmFbq?=
 =?us-ascii?Q?5RwLvDCDaymv/KhTQ5Hs8jgqg/oDAd8xuaYcaB7tSd5NeM6y9ROpR6VX6nKA?=
 =?us-ascii?Q?1ue3W9ocgKmwKdPTUqz8ePNC10Y83cVGWPABREZlnF3O28ihqW988y3iUbsp?=
 =?us-ascii?Q?yEDWwYzqAfZOQJDPOw5nRLzgnUL90iHrArRFkrFMpD3wNguk2PZpR29Bgfr6?=
 =?us-ascii?Q?sXlLT4i4m92wLF/5c9m9++069GqzDu+3uJWHGBaIQ8MlS2sSokKVc+BAdg+Q?=
 =?us-ascii?Q?gEedW9v0AtRFvLNC9iPOLJDdHSAE9EcVTVmqB5KXxamzUTw/kXVpAp0/+Hlj?=
 =?us-ascii?Q?UR5yW+DtehRLyFx+NnitvFKRZrPgDWTO009EBriDvueG3XGEyTML4ftLhSJO?=
 =?us-ascii?Q?MFxRvnfnmStLEzYf5tGUuF+F+2Jok4AxuF/NGiZwsOynoMRlaEyMmxaWOipE?=
 =?us-ascii?Q?v0SwbJSFtp0VlEE4bOO4V9HoIYWBqvzObq02Uk7kfykNO4UR2nxpRQNksf3d?=
 =?us-ascii?Q?FwOA+hOsfnEQQSQq7frTxlOK+oY8O1sl0rbsRM1f+/rK7MaJA+uOFRjDRmBV?=
 =?us-ascii?Q?XR3qu9tIwM5RMARfdzxv4o3bCjgtX+TsGcttdqN34uZFBs+PJxfjUK35PeYq?=
 =?us-ascii?Q?bLbInEDfghrVPfqU3mXzmznubrgZiisMCuOY/PKaK6kM5cx/dZThQD//K7jc?=
 =?us-ascii?Q?CcrgtvegPzS7fo2AqvzxMKtIFisSKyyU2Yju4sT501LdZF+T9o7CGRrxCuG/?=
 =?us-ascii?Q?SwB7NjJHLY89E5PmiQCAAPU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 917587a1-db2f-47e0-b91c-08d9f3dbde10
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2022 19:13:10.0379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ki/mxw+OqNodEg+/QEv9CMH5WLVCv/+eYTS4zNmhf8NKf6GSxpQ7smJQFq1dZJYafUw3Xcqv3OVC9NCoMyVihA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2928
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10263 signatures=677614
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202190125
X-Proofpoint-GUID: 4VFg1S2jElUokme47la3ociHAD1EsRjN
X-Proofpoint-ORIG-GUID: 4VFg1S2jElUokme47la3ociHAD1EsRjN
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TUN can be used as vhost-net backend. E.g, the tun_net_xmit() is the
interface to forward the skb from TUN to vhost-net/virtio-net.

However, there are many "goto drop" in the TUN driver. Therefore, the
kfree_skb_reason() is involved at each "goto drop" to help userspace
ftrace/ebpf to track the reason for the loss of packets.

The below reasons are introduced:

- SKB_DROP_REASON_SKB_PULL
- SKB_DROP_REASON_SKB_TRIM
- SKB_DROP_REASON_DEV_READY
- SKB_DROP_REASON_DEV_FILTER
- SKB_DROP_REASON_BPF_FILTER

Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 drivers/net/tun.c          | 37 ++++++++++++++++++++++++++++---------
 include/linux/skbuff.h     |  7 +++++++
 include/trace/events/skb.h |  5 +++++
 3 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index aa27268edc5f..ab47a66deb7f 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1062,13 +1062,16 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct netdev_queue *queue;
 	struct tun_file *tfile;
 	int len = skb->len;
+	int drop_reason;
 
 	rcu_read_lock();
 	tfile = rcu_dereference(tun->tfiles[txq]);
 
 	/* Drop packet if interface is not attached */
-	if (!tfile)
+	if (!tfile) {
+		drop_reason = SKB_DROP_REASON_DEV_READY;
 		goto drop;
+	}
 
 	if (!rcu_dereference(tun->steering_prog))
 		tun_automq_xmit(tun, skb);
@@ -1078,22 +1081,32 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* Drop if the filter does not like it.
 	 * This is a noop if the filter is disabled.
 	 * Filter can be enabled only for the TAP devices. */
-	if (!check_filter(&tun->txflt, skb))
+	if (!check_filter(&tun->txflt, skb)) {
+		drop_reason = SKB_DROP_REASON_DEV_FILTER;
 		goto drop;
+	}
 
 	if (tfile->socket.sk->sk_filter &&
-	    sk_filter(tfile->socket.sk, skb))
+	    sk_filter(tfile->socket.sk, skb)) {
+		drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
 		goto drop;
+	}
 
 	len = run_ebpf_filter(tun, skb, len);
-	if (len == 0)
+	if (len == 0) {
+		drop_reason = SKB_DROP_REASON_BPF_FILTER;
 		goto drop;
+	}
 
-	if (pskb_trim(skb, len))
+	if (pskb_trim(skb, len)) {
+		drop_reason = SKB_DROP_REASON_SKB_TRIM;
 		goto drop;
+	}
 
-	if (unlikely(skb_orphan_frags_rx(skb, GFP_ATOMIC)))
+	if (unlikely(skb_orphan_frags_rx(skb, GFP_ATOMIC))) {
+		drop_reason = SKB_DROP_REASON_SKB_COPY_DATA;
 		goto drop;
+	}
 
 	skb_tx_timestamp(skb);
 
@@ -1104,8 +1117,10 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	nf_reset_ct(skb);
 
-	if (ptr_ring_produce(&tfile->tx_ring, skb))
+	if (ptr_ring_produce(&tfile->tx_ring, skb)) {
+		drop_reason = SKB_DROP_REASON_FULL_RING;
 		goto drop;
+	}
 
 	/* NETIF_F_LLTX requires to do our own update of trans_start */
 	queue = netdev_get_tx_queue(dev, txq);
@@ -1122,7 +1137,7 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 drop:
 	atomic_long_inc(&dev->tx_dropped);
 	skb_tx_error(skb);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 	rcu_read_unlock();
 	return NET_XMIT_DROP;
 }
@@ -1720,6 +1735,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	u32 rxhash = 0;
 	int skb_xdp = 1;
 	bool frags = tun_napi_frags_enabled(tfile);
+	int drop_reason;
 
 	if (!(tun->flags & IFF_NO_PI)) {
 		if (len < sizeof(pi))
@@ -1822,10 +1838,11 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 			err = skb_copy_datagram_from_iter(skb, 0, from, len);
 
 		if (err) {
+			drop_reason = SKB_DROP_REASON_SKB_COPY_DATA;
 			err = -EFAULT;
 drop:
 			atomic_long_inc(&tun->dev->rx_dropped);
-			kfree_skb(skb);
+			kfree_skb_reason(skb, drop_reason);
 			if (frags) {
 				tfile->napi.skb = NULL;
 				mutex_unlock(&tfile->napi_mutex);
@@ -1872,6 +1889,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	case IFF_TAP:
 		if (frags && !pskb_may_pull(skb, ETH_HLEN)) {
 			err = -ENOMEM;
+			drop_reason = SKB_DROP_REASON_SKB_PULL;
 			goto drop;
 		}
 		skb->protocol = eth_type_trans(skb, tun->dev);
@@ -1925,6 +1943,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	if (unlikely(!(tun->dev->flags & IFF_UP))) {
 		err = -EIO;
 		rcu_read_unlock();
+		drop_reason = SKB_DROP_REASON_DEV_READY;
 		goto drop;
 	}
 
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 218f7ba753e7..9370778b428d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -351,10 +351,17 @@ enum skb_drop_reason {
 					 * sk_buff
 					 */
 	SKB_DROP_REASON_SKB_GSO_SEG,	/* gso segmentation error */
+	SKB_DROP_REASON_SKB_PULL,	/* failed to pull sk_buff data */
+	SKB_DROP_REASON_SKB_TRIM,	/* failed to trim sk_buff data */
 	SKB_DROP_REASON_DEV_HDR,	/* there is something wrong with
 					 * device driver specific header
 					 */
+	SKB_DROP_REASON_DEV_READY,	/* device is not ready */
+	SKB_DROP_REASON_DEV_FILTER,	/* dropped by device driver
+					 * specific filter
+					 */
 	SKB_DROP_REASON_FULL_RING,	/* ring buffer is full */
+	SKB_DROP_REASON_BPF_FILTER,	/* dropped by ebpf filter */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 842020d532f2..62704851062c 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -30,8 +30,13 @@
 	EM(SKB_DROP_REASON_SKB_CSUM, SKB_CSUM)			\
 	EM(SKB_DROP_REASON_SKB_COPY_DATA, SKB_COPY_DATA)	\
 	EM(SKB_DROP_REASON_SKB_GSO_SEG, SKB_GSO_SEG)		\
+	EM(SKB_DROP_REASON_SKB_PULL, SKB_PULL)			\
+	EM(SKB_DROP_REASON_SKB_TRIM, SKB_TRIM)			\
 	EM(SKB_DROP_REASON_DEV_HDR, DEV_HDR)			\
+	EM(SKB_DROP_REASON_DEV_READY, DEV_READY)		\
+	EM(SKB_DROP_REASON_DEV_FILTER, DEV_FILTER)		\
 	EM(SKB_DROP_REASON_FULL_RING, FULL_RING)		\
+	EM(SKB_DROP_REASON_BPF_FILTER, BPF_FILTER)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
-- 
2.17.1

