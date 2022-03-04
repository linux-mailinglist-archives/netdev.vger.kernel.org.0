Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBC04CCDE0
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 07:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238450AbiCDGf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 01:35:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237244AbiCDGfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 01:35:16 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A388BF0F;
        Thu,  3 Mar 2022 22:34:29 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2240gE8R013345;
        Fri, 4 Mar 2022 06:33:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=DG6UUJ7EYxEboQwhbz38ZsHU6Z8ES+htolFLAMlQBvA=;
 b=RTWfKY4/bjxf01ZSX2K3HgtN56slLLhjiGIA7qbiJUlXhAkYyEFKkjuiOHa96OwlJ+Ue
 qus+29qgxk3lQg6xCcS1F18abcqY3tQPpNpi/2OYVXAiKpY7s4rH4vgmLgLdsl9uLe4L
 3oChHh7uDM7Db3cdkBw2Xdi4hS/B6Gd1vLd3Hw0aF37U6TNAHh4CI0UlMAf6YWmUQPP/
 BmkwEPoljKOXyFtqc+roncxBx8t45V8fanGeTQCAq39LCZHJ+xv72MDyqKvsu0Is7Uay
 DElfIMRdwkcYB0DBPYjrsbZJokgpyIrCp8lD5j2yf1ExXNMpXARhAyl8I9MtA3XwPhUI CQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ek4hv0ws5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 06:33:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2246V0CV010220;
        Fri, 4 Mar 2022 06:33:27 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by aserp3020.oracle.com with ESMTP id 3ek4j8drxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 06:33:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Luhu78rOFzeNDW+0jStGUO4G/s6TPJfEAarkAf4MmcAD1F8XFm2xZn5VYffSqvzWPNeP4sx/ZLW7FNfZLHGg5w2SIA4cK58lp4HNHgIgIEA4oTdkmBhS1GYpx7XULEdXOLoVOUmg2hUzme9aqF9QBO5tVWacoUHIRP+pctSh6NRkqIp9cPSqEZ6og0MTr9dM6zGXJa//0fg0RjJsS+x4mN33sUnTmBKG4ajn2YDtDbA4i+0ytD7bSGjUONJZGaLThIXgqcfiwd4YksiwoWdvurchieMTOZTQMRTBTZ6a+htIIlj4Xfl+6cFykb5l8/Sq2ouTjWh3oCU4m39DpQC7Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DG6UUJ7EYxEboQwhbz38ZsHU6Z8ES+htolFLAMlQBvA=;
 b=mZrG0UGYrxujUnoi0qQdnl2x1bxQslJrnxY2cczsTXtGN8pMY8brLYRuobRo3kYDQ99xc2rCquyifjiypyDsVhlC5ONVAafeLzJ1nrDKDJWJ5ShTRaEhVkT1xGRWUkYl/ujqc0/Ul0n4Fv+CeU93fu40QIxvxyL4vuHDIpZl7oQalyE9Q+OoNzxMGhFn/U2z2PxC0w2z4VyD81btOsgD94BJqJYeejcYBfh0Ktq3XNl3i7TsbhPHGTp61UGYwIHZ9cZyaYxyqYbJtbKsCzFtohLPr8W8UOQHLq58dZezqeVPU4ddWaE3pmNOPMf24XH9Aldbp4i1xg1CpWTXVqqPTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DG6UUJ7EYxEboQwhbz38ZsHU6Z8ES+htolFLAMlQBvA=;
 b=xcH55u04II5nObxyyG2qah8Yxinx3VlHt4VtvJ8yMfPyazMTX2KK8wSei9Ew6sfZrIJvhMI8xbgAJykisNYmmrjiCzWDiwgBPMF/3Qcz+20Y8g+CN6B2+CWfethao18+bg/dPfHJC58tmqkkfBNR/4gA/AmKxP2Y42BhwTwTBxA=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by SA2PR10MB4603.namprd10.prod.outlook.com (2603:10b6:806:119::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Fri, 4 Mar
 2022 06:33:26 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.5038.017; Fri, 4 Mar 2022
 06:33:26 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
Subject: [PATCH net-next v5 4/4] net: tun: track dropped skb via kfree_skb_reason()
Date:   Thu,  3 Mar 2022 22:33:07 -0800
Message-Id: <20220304063307.1388-5-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220304063307.1388-1-dongli.zhang@oracle.com>
References: <20220304063307.1388-1-dongli.zhang@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: DM6PR01CA0018.prod.exchangelabs.com (2603:10b6:5:296::23)
 To BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96bcaa28-a64f-4a2d-fe23-08d9fda8e33c
X-MS-TrafficTypeDiagnostic: SA2PR10MB4603:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB46032C273FED18B77A0C8A6CF0059@SA2PR10MB4603.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JCy96By8DygNRgmD4Ilch7a1NZ7IPXoqob2GqWLye8MYBwDjq2SZIVEXqDO8s2vHRkvo8KT2g9Wh3j2+6EoIHDrMmaRsSR+6gFIHbFEMDjATm3soSMim5bSpVrGH5Vno7TNCqypnxuR1WX4qGoe8eIRNxevjMOTJMtAVwlZzKId3fg+BZ/L3q4i9I07A7eikbt5N9VAwAhDAQ5uQxbLRAFE05tstAJxS29Mj2aO6afwAskgvqXMeZwHGX/+DOIXKRQKBCcc7Vjn79yDzZ9ykb7Gd07yZnko8I9u8829fHm6CTIa6RlWEZAPVbTfFGcw5nvzTfLA3Eqj7ZhO872mBwwhQwSTi4NcHN0Dz+wFn9xuZLsNUL1DeVr9lO9SAygpvn7WHZ6kLgOJJJ7La7Z18KVfVtqb8A2nFHm0BTxdtnry6j7+fFwOyHZ6PsK2gH6acgpNRuzbnhhQ77xhYnifA0pPf5v0PMxyiEHDsEHssiwjhW6LDQvugnDUKBtNRuKGCwO2L+C9Xwy6snXxF6+ZMGFsEqAx+1TAwjug9JCV/z5vz/gL8jPuSY4jRFDOPwOJVYvfuJ83Ze839RGFaFXX39QXxNLu/5r7OAx/DiPpcAR9M0Bv4sGlydW76iLM4hdPRCdw6E2RPiJyDn+GN2SDlBT9efLOhlF6hEHu/koZ8M/tkwIGVrwCTQNLo9MrxDX4OfXFP6a75UBY6LJIxrEDvrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(8676002)(66946007)(66476007)(66556008)(1076003)(5660300002)(8936002)(7416002)(52116002)(6506007)(6512007)(508600001)(83380400001)(6486002)(86362001)(6666004)(2906002)(38350700002)(38100700002)(26005)(186003)(36756003)(2616005)(44832011)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2/9IdlanHcCm1e4L1hmsMHcgUWPWkRyJEzfvJNKfn2tRNWx6mkMgqoOB+VTG?=
 =?us-ascii?Q?nro73qocQ6t9vZrul8CHltONu9f4LlzYhwZxYNv+RTdeS/7ARAypK7ESj7yP?=
 =?us-ascii?Q?KKdn7LZSyLHT8aQGBc+hOA2I3jVdharlsHqrFL0ZLGJYte/dQu1qcX8h6Aus?=
 =?us-ascii?Q?7YrkH1zLdNTUSbBxKBaprK1P/wA2fPwcyP6Hi1ckYCIcGnhI2GeFSE2aLgNx?=
 =?us-ascii?Q?ihwvvWiq3ratJvyC8Njjf95SkqQMfCC/5CkG717qFZtaRecprBvBmwnuV7lP?=
 =?us-ascii?Q?LA4ngt346TQw0NF+/hywJxtXY8OQeIWIwDoxTrSbZEAy2ABj+e562H+w6j+N?=
 =?us-ascii?Q?1udAoeR7MQ/VtBBuPZN0zXfz5di2Unw81cHUWQU+Y7hcYapNsNoaP3to8e+o?=
 =?us-ascii?Q?WnwN/JTvi+VBR8G58MivYv0w+dQ5ZfnfI67mx3MMj5PhWjG70DZy2vjl8kxb?=
 =?us-ascii?Q?DGxf8XGNG9SEMglX4qcAyjm0pdR4KQGsrBw2MdVa6s34QSxQs0t5O8P7gVJl?=
 =?us-ascii?Q?vdc4FtoIHEgNCzqDVlqjkGiQJjq4TFVLbQ7C2QiD8eUScHKuI1cIUJGtx1EW?=
 =?us-ascii?Q?R7BhriCz9VlM5bDM5XaN2RCZQI7at1N/8dv9fKnjSpZj7RPi5vHOffFv0EGP?=
 =?us-ascii?Q?9ptYHbVUS/u6x4R/psSBJpLACZwz9DxBiT6GWbkosS9ducCWBW+MscY58dZK?=
 =?us-ascii?Q?c4p0CE/s8XneIjSy+pzaYP+scoFPnltL9fpQ/eqTWz6ZI5lIGLn8M13DcOMP?=
 =?us-ascii?Q?bKoCKrpYNmB0mmgNpTL21T+q2+ujh4HJLTUc37c+yFmpqoom8bEgu7iL2anu?=
 =?us-ascii?Q?/K1iP1saB0Xr+tgzUdx09TLXckQAyXqCToVCyMqPrjJlS3eWqC7IdPnA8Ctc?=
 =?us-ascii?Q?yLMoNtfsIQy8BlO/4WiUuJhN3ObCsUFW58vgjOmrOfG4/Jx+5aybPr2B+qGh?=
 =?us-ascii?Q?TRSQxo9yfHts4vyqwFLhW3lh7b5HtXD2gjBTgsLR4j1DYf156jayYK9OY+YO?=
 =?us-ascii?Q?wFcg6dqCkQBD50QFoscTMeGALfyIeeTnco3JTTqtS1GTaOEAsIxGV6AWUZlh?=
 =?us-ascii?Q?k75+kyPQ2KK7EiAcys3R8CPUbtn0jkCmDNoUg5bU45dILUbh52E+NPFbo/UK?=
 =?us-ascii?Q?vweCezjshRpvinGTZPAkaMQF7Hu7YsnK/m89TAH2xqPl3ngXI24HW23SI9kU?=
 =?us-ascii?Q?c8W3FTTh8NTuK3vnaJ1LOkrcXZC3eVF1TedLwuRlG3DPO0AZajcl4Wz7i8jm?=
 =?us-ascii?Q?ey7ua5lm/KIRWqPuDLyRLDxiofyxtwtTVe9nQUzRn+l10JCg7Mb6BJkLn2aD?=
 =?us-ascii?Q?77EaA7acktq06dDUNe0vsizupKXx1sN4X96i2NCqaSrfyZw2W+Ap3Ctb9l0u?=
 =?us-ascii?Q?EU6E4qp1LQZuxJ+35rdXewOR7Hxn5qUzFmVzYNMj1hSz4tcPftVyokcJ7zpG?=
 =?us-ascii?Q?Cr//5rhSswZEnmnfVbovLtRI5FCYfR52zohQ31xtlZmNOU24lruK5bC9xuzR?=
 =?us-ascii?Q?OQnogb9XDouWsWWhP02YfBE+VojKSgBCI5SLW799pexCMTPrqdfdKSvx1KSS?=
 =?us-ascii?Q?3KouYfGnLSM7qTOjcUosdlScNxwby3iZ5NVuBd+be49qcrDzx5DpMWaIJlyn?=
 =?us-ascii?Q?mInE5UncYxySPD5CBKlF79A=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96bcaa28-a64f-4a2d-fe23-08d9fda8e33c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 06:33:26.0112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mRfB7xDpJse0cYJxC/aOzwwmH2dxDpY1WAzIteCp7ybDZ46ofj57N+5ryz8nuzkf8TObBwfhDQPyPWTnFa6uqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4603
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10275 signatures=686983
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203040031
X-Proofpoint-GUID: quM5ieBm3W7nlr0Jt3hbg_D0-29Co6ZI
X-Proofpoint-ORIG-GUID: quM5ieBm3W7nlr0Jt3hbg_D0-29Co6ZI
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

- SKB_DROP_REASON_DEV_READY
- SKB_DROP_REASON_NOMEM
- SKB_DROP_REASON_HDR_TRUNC
- SKB_DROP_REASON_TAP_FILTER
- SKB_DROP_REASON_TAP_TXFILTER

Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
Changed since v1:
  - revise the reason name
Changed since v2:
  - declare drop_reason as type "enum skb_drop_reason"
Changed since v3:
  - rename to TAP_FILTER and TAP_TXFILTER
  - honor reverse xmas tree style declaration for 'drop_reason' in
    tun_net_xmit()
Changed since v4:
  - expand comment on DEV_READY
  - change SKB_TRIM to NOMEM
  - chnage SKB_PULL to HDR_TRUNC

 drivers/net/tun.c          | 37 ++++++++++++++++++++++++++++---------
 include/linux/skbuff.h     | 18 ++++++++++++++++++
 include/trace/events/skb.h |  5 +++++
 3 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 6e06c846fe82..bab92e489fba 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1058,6 +1058,7 @@ static unsigned int run_ebpf_filter(struct tun_struct *tun,
 static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct tun_struct *tun = netdev_priv(dev);
+	enum skb_drop_reason drop_reason;
 	int txq = skb->queue_mapping;
 	struct netdev_queue *queue;
 	struct tun_file *tfile;
@@ -1067,8 +1068,10 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
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
+		drop_reason = SKB_DROP_REASON_TAP_TXFILTER;
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
+		drop_reason = SKB_DROP_REASON_TAP_FILTER;
 		goto drop;
+	}
 
-	if (pskb_trim(skb, len))
+	if (pskb_trim(skb, len)) {
+		drop_reason = SKB_DROP_REASON_NOMEM;
 		goto drop;
+	}
 
-	if (unlikely(skb_orphan_frags_rx(skb, GFP_ATOMIC)))
+	if (unlikely(skb_orphan_frags_rx(skb, GFP_ATOMIC))) {
+		drop_reason = SKB_DROP_REASON_SKB_UCOPY_FAULT;
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
+	enum skb_drop_reason drop_reason;
 
 	if (!(tun->flags & IFF_NO_PI)) {
 		if (len < sizeof(pi))
@@ -1823,9 +1839,10 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 
 		if (err) {
 			err = -EFAULT;
+			drop_reason = SKB_DROP_REASON_SKB_UCOPY_FAULT;
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
+			drop_reason = SKB_DROP_REASON_HDR_TRUNC;
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
index e5d5371a543b..4e5b725302ca 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -406,7 +406,25 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_DEV_HDR,	/* device driver specific
 					 * header/metadata is invalid
 					 */
+	/* the device is not ready to xmit/recv due to any of its data
+	 * structure that is not up/ready/initialized, e.g., the IFF_UP is
+	 * not set, or driver specific tun->tfiles[txq] is not initialized
+	 */
+	SKB_DROP_REASON_DEV_READY,
 	SKB_DROP_REASON_FULL_RING,	/* ring buffer is full */
+	SKB_DROP_REASON_NOMEM,		/* error due to OOM */
+	SKB_DROP_REASON_HDR_TRUNC,      /* failed to trunc/extract the header
+					 * from networking data, e.g., failed
+					 * to pull the protocol header from
+					 * frags via pskb_may_pull()
+					 */
+	SKB_DROP_REASON_TAP_FILTER,     /* dropped by (ebpf) filter directly
+					 * attached to tun/tap, e.g., via
+					 * TUNSETFILTEREBPF
+					 */
+	SKB_DROP_REASON_TAP_TXFILTER,	/* dropped by tx filter implemented
+					 * at tun/tap, e.g., check_filter()
+					 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 9d91ec9755b8..e167a6657748 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -49,7 +49,12 @@
 	EM(SKB_DROP_REASON_SKB_GSO_SEG, SKB_GSO_SEG)		\
 	EM(SKB_DROP_REASON_SKB_UCOPY_FAULT, SKB_UCOPY_FAULT)	\
 	EM(SKB_DROP_REASON_DEV_HDR, DEV_HDR)			\
+	EM(SKB_DROP_REASON_DEV_READY, DEV_READY)		\
 	EM(SKB_DROP_REASON_FULL_RING, FULL_RING)		\
+	EM(SKB_DROP_REASON_NOMEM, NOMEM)			\
+	EM(SKB_DROP_REASON_HDR_TRUNC, HDR_TRUNC)		\
+	EM(SKB_DROP_REASON_TAP_FILTER, TAP_FILTER)		\
+	EM(SKB_DROP_REASON_TAP_TXFILTER, TAP_TXFILTER)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
-- 
2.17.1

