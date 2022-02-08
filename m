Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 330544ACFF3
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 04:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346598AbiBHD4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 22:56:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346495AbiBHD41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 22:56:27 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD822C0401DC;
        Mon,  7 Feb 2022 19:56:25 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2182Yv8m011786;
        Tue, 8 Feb 2022 03:55:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=rcdfWI3MVOr2TR/JdreyHzhUkcT3OOW6y5xI4BEen2Q=;
 b=Oahy8y1id7nqrGjXu9LspYpGYza+Ls38LtvAhptosPTO6wHw38OySyS1RRkEX/WNTICi
 KCSYQulnjrQp1y62rlSLJ3dg3DCKrYnQG5lRXJkF6OsTGpyEhndQL7L/ngDEzAIS5vVs
 1Tl+DtehLcgw5HqNcjCpzHXd+BXSep+beif+RthUBO6gLuMgAuvRWfg5mDbKW5eQOMJU
 5L6g0K4ZGQEi6mIPgNZ7HQKiEwS5ClwLO3a08ARhI3V2pP9WZHVNNr0N1qUp+iYUzmE0
 jdt1g3ktfDXSo1KVkjFI4GKKH2tUqTTuV7wq3ujPGjqFPMKUOzAfQQ7Kw0OviuPJvWEx Ug== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e345shyyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 03:55:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2183jjRW044635;
        Tue, 8 Feb 2022 03:55:38 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2174.outbound.protection.outlook.com [104.47.73.174])
        by userp3030.oracle.com with ESMTP id 3e1ebyab49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 03:55:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fnjtO0BiwgZUyNRcOdTKnfeYq8YrJ0GHAWkekU3TB9CQ2nRYIMjmmMDUclN5CeWFGdtzJV3wOZjhlaG9FS0pLXSDZJLbF1xtGEcl1RfFlugZ9wWDFC+9rHYMslZGVpxi/mxbqBmZhtPmZ2L/V6hpsPJbJo69Q8jq1d7R2Hzlv0DVV41d8/4A1eYcItdltbhNMKok9Jwf1XzonTcP6Y+dgu6tmMxcw6s7Gbad7lOf4cEljHJWdRV5xTzsNaZ2uTBre85vm2kRTmcr7RN1C7f8JiLKTHo48aJtZqsQCXoFqReS2PK74D/57JOMzabiPkKWVEZsiCAlUnCxs9nK+diatw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rcdfWI3MVOr2TR/JdreyHzhUkcT3OOW6y5xI4BEen2Q=;
 b=OyA6Iax8etMxKNsHw00Ff5Kvtl3Jxeesq93+nLNkBKerh0zX0EFQFiXunguwiAO+kYNmGdr7VUwz2MLm/FYDZimhM1QEzalpfUZ/eClE3yk2FSzNv7f8LJ2knefaCly3XmuGMFw0ZwEh+HbCJrMY8VJqkl9hT1WVTqyPslf8+LckbOecn7pT+TO07fiavcwguXmVBHpXVKehHdYjAMicdVBUmqnlhwXVtxwTabqEuBdZ6/ceqRjY1uKcbz8HV7JCOx33g+hNxGzFSSmq1YGRVRqTL/ytb89AkXdEghwOmiw9F1i7o1wsBfyfY2rHZUc/f+3tVzeb0XkY0Gd3G9YQug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rcdfWI3MVOr2TR/JdreyHzhUkcT3OOW6y5xI4BEen2Q=;
 b=Kt1a3Uag4mnLfTFfirJLuZ/UyirdrbYHAvqZ1o+8q8Ip3b+tMt0n3LWuCe6DDZjP0VWgQFVMTTe6RUiUUw223EXdIM7Sqri5++khHVI2uxH2L/Si4XwP/wNHBNsoY1VUkN0FewamSkorGRJTpoUxKa+5Q4V4GfVYEoN3p/unfvA=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CY4PR10MB1352.namprd10.prod.outlook.com (2603:10b6:903:28::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.16; Tue, 8 Feb
 2022 03:55:35 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 03:55:35 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
Subject: [PATCH 2/2] net: tun: track dropped skb via kfree_skb_reason()
Date:   Mon,  7 Feb 2022 19:55:10 -0800
Message-Id: <20220208035510.1200-3-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220208035510.1200-1-dongli.zhang@oracle.com>
References: <20220208035510.1200-1-dongli.zhang@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SA0PR13CA0010.namprd13.prod.outlook.com
 (2603:10b6:806:130::15) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe843066-e5d3-4140-e1f6-08d9eab6dc6f
X-MS-TrafficTypeDiagnostic: CY4PR10MB1352:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB13521F3BA76C7665E597D224F02D9@CY4PR10MB1352.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r0nvLdBBCuyNbdA1hYcyiPVMID8qtHfaTjPfJ0HjSoPSMFKF/tsLGNIEgTJIrVVNkwhuWoT9Nh4y5ipRrhusC9sMN6fRErH1fRi1O5rALWwVBzRz1BW4NWmsamTE+42dITeINPt6N9EFh2DgrNJuI4WhJg7BdINeQgs7y+k3lKzm266CAdsjqdkaAIf6IRgVVliOg2n/8cCF2dOB4k36xjIJbFmhsfl41lTKIfXqIex4+cT/VVFvay/M7pEO4fuVhPZL8zefeXF3P7FiHks6vNM9DQKKz33yJlHxN3eab8DHGtMKzmHzaatxmd7sJ3piaUVdFGjgqbAnqlXia8NCdYekW+tEh6UQVNXV2QF2gGfRs8FboSFAcFAwgr/gVqdgsXJbbHF/7VXWDA28Rm1/5cc/Ibnm0rs8Cyqg/Mc86a9HB7TtsYjIH5xePFiKSuhN1akFklMrr5o1pbg3YHO3xuUqlEx6ITMHBqYKRfn8f0K9kNvOXUky4JTk4dmAksf2BvQZnbHBQGK4Vp22JHVl6lLOkOgreCP3zCGAWmhedvdSXcS1MecZV6Wnc0rZmsT24msYWUR12w3sqIAZhhVpySvRsV67Nl75NyT+0mBCY67SnUTRFu3Tp7/q+bpbirzw1/Pc4LG+HJSVVtL0O3eKU0jic7fpHCwPuHOfpEeSY9dTwzR8brBWyxXNz5a4q3RloCKKaIxm7YyiUliuzw5jZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(4326008)(1076003)(38350700002)(38100700002)(83380400001)(6512007)(26005)(186003)(8936002)(2616005)(52116002)(6666004)(6506007)(8676002)(7416002)(66476007)(2906002)(86362001)(36756003)(44832011)(508600001)(66556008)(66946007)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WKOnEkIMv3GQpxFwotS3bc1BW1goAgHMt8ZL4CYo5I5xAhxD21uTPT8175r6?=
 =?us-ascii?Q?t4klNOVMj0MpRCKVFK9/TSFLzUW6p151QZ1rLlvQ1HY+BleznBu3zlRMaT11?=
 =?us-ascii?Q?1N9oX9bpL4hsRA1zUSWSfbjwv5OOsOPms08SrQBilGJJJ4KO0v9f8qXJ/b/C?=
 =?us-ascii?Q?qsrhNGf1GwF/7eMJkQqPtx4NGFaHM0mUAqViL3mMnbr64EcLMGtdgKXuPxPl?=
 =?us-ascii?Q?N12OPyWSqvwBzKmKSQ0jPt2BP2Qtl+vRkxWvvJ0F41huhuNGLiBcZXUD7uQ8?=
 =?us-ascii?Q?qU4s5uhRAxDQ5/BYQpqaxLL6p/ZIN3/cv2XGe2hvQ4mqqGrL/UEstbY7/rq+?=
 =?us-ascii?Q?C3jprVrWfRhCl1AhE/DhGqwL7ev2UbmgbtuCx2lv7BI61mqgg3diW9GqpNpv?=
 =?us-ascii?Q?eAuUu/fEDOkkKI25BL4PrkoOFgLYIqnxeumhY7LTY8hHcKWhTG+mztsHnFX+?=
 =?us-ascii?Q?UtWVKYAP9O8lRiD7sWJnB9TZiOnc/yWmyNylbAmmxhiuDBUwy/OpxTqpBPIp?=
 =?us-ascii?Q?3mrQGpir6QEwyVOF8CFbGthPUYb8GrxDmiFEO1tTlVVGTnCWeR+dUcEHVXxE?=
 =?us-ascii?Q?phIQociR2qKRoRzQZmMEGiMgSyo4t0wiWMqPtSUH0yS+KybIOUHKkQTsFbNj?=
 =?us-ascii?Q?Ig1VASDFjIJR0dfCXsmX+mKE1RLYtCl8/0oDH90tgh6r/msyWo/dAPd/F+ae?=
 =?us-ascii?Q?IKGgmyFUtBNbslFUZRYEElLFL+6pEY2hDP5zYkEwnrQv0tZ/XCO/qhRSN31x?=
 =?us-ascii?Q?/88d3dMuupF5k1FBFxDuXljwGS5GEdKlGQbcmFPSniQF6iFi8sOsgXG5TUsQ?=
 =?us-ascii?Q?jxxzupUTJo8ssMcIdJkSt+K1AVHpBubyThdBxflcD0JbO8JynbnUm01fuAuL?=
 =?us-ascii?Q?6lMly63nZJ+CAxuKBVEt9UFhT5rXqIkAUvAf/ls1bV0Se6PO+DKZfPhQW6jX?=
 =?us-ascii?Q?d9Gq5s0jGA/7c6dEgQHcGeEo//ATrZt6KfWwqqWLlQB/yhD/96KfW7sKp2ay?=
 =?us-ascii?Q?bNmZ1vJtaNec6eRHJZbQm/XkLm6KsKMY52AQ92PDsd9hSc+W/63V+hIvtkT2?=
 =?us-ascii?Q?LNEmdZJz2AevxLv2hYyZnNbndbNd93k0UDmojq0Yzw9HSxLhpdLnXxNBZ7yN?=
 =?us-ascii?Q?CxKJjCi2bNhEAhicOa5/pUv0oR9n6YdVlUyXF4/sNKw78aWGynHUK095jAE0?=
 =?us-ascii?Q?OuLq6yaprcWSFe8QIr/A5X05HyE+T8jusv3zTRBySQm/YroQv3OZfWeUMAOq?=
 =?us-ascii?Q?eXz3A9NgnkPHGxFS8Nc29JxgEFWH+foZFWC36r9jUD9INNALgmPMkV40aDoM?=
 =?us-ascii?Q?YiJjIqifV8wfAPOFNetUDE8v1btBbq6L7Zq5HX11paV+z39T5orC4TrIqT43?=
 =?us-ascii?Q?mYRmJS31xwY6XrSdx7Ns3FqQcyecJf2JNoRmnpl6az9C7UP5pfelBYsSGQ8q?=
 =?us-ascii?Q?s8mBsgHBHDv70auec/i8Exu6ZWCgY79JaIZTFKqQpdS/HEmuEUcljSKCJjOZ?=
 =?us-ascii?Q?55FBzEwqrYHxNTKZ3/kl6xzPi+XG73aMKsKXhx8x9kl5zn2RG2yP6zvuUywW?=
 =?us-ascii?Q?EoYgOKU4KadD1D0q6HT1asA9mOfzHIfeHlyWvZEHnuI4mdv8geAKzRaFL28K?=
 =?us-ascii?Q?zhgd+LUn/k1LdYtr8SfbX5c=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe843066-e5d3-4140-e1f6-08d9eab6dc6f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 03:55:35.4621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bF7yfzNIWzgfXEDMQxu4McnNDc6FTmWQjDTEa++uRY1/BbucxZP/Nj5vbk+D2jv8GJb3zrLihYapXZQj+UgCTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1352
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10251 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202080018
X-Proofpoint-GUID: U0-E-5VSbatKltcfQXLGLqhMeU43l-ND
X-Proofpoint-ORIG-GUID: U0-E-5VSbatKltcfQXLGLqhMeU43l-ND
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

Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 drivers/net/tun.c          | 33 +++++++++++++++++++++++++--------
 include/linux/skbuff.h     |  6 ++++++
 include/trace/events/skb.h |  6 ++++++
 3 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index fed85447701a..d67f2419dbb4 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1062,13 +1062,16 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct netdev_queue *queue;
 	struct tun_file *tfile;
 	int len = skb->len;
+	int drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 
 	rcu_read_lock();
 	tfile = rcu_dereference(tun->tfiles[txq]);
 
 	/* Drop packet if interface is not attached */
-	if (!tfile)
+	if (!tfile) {
+		drop_reason = SKB_DROP_REASON_DEV_NOT_ATTACHED;
 		goto drop;
+	}
 
 	if (!rcu_dereference(tun->steering_prog))
 		tun_automq_xmit(tun, skb);
@@ -1078,19 +1081,27 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* Drop if the filter does not like it.
 	 * This is a noop if the filter is disabled.
 	 * Filter can be enabled only for the TAP devices. */
-	if (!check_filter(&tun->txflt, skb))
+	if (!check_filter(&tun->txflt, skb)) {
+		drop_reason = SKB_DROP_REASON_TAP_RUN_FILTER;
 		goto drop;
+	}
 
 	if (tfile->socket.sk->sk_filter &&
-	    sk_filter(tfile->socket.sk, skb))
+	    sk_filter(tfile->socket.sk, skb)) {
+		drop_reason = SKB_DROP_REASON_SKB_TRIM;
 		goto drop;
+	}
 
 	len = run_ebpf_filter(tun, skb, len);
-	if (len == 0 || pskb_trim(skb, len))
+	if (len == 0 || pskb_trim(skb, len)) {
+		drop_reason = SKB_DROP_REASON_SKB_TRIM;
 		goto drop;
+	}
 
-	if (unlikely(skb_orphan_frags_rx(skb, GFP_ATOMIC)))
+	if (unlikely(skb_orphan_frags_rx(skb, GFP_ATOMIC))) {
+		drop_reason = SKB_DROP_REASON_SKB_ORPHAN_FRAGS;
 		goto drop;
+	}
 
 	skb_tx_timestamp(skb);
 
@@ -1101,8 +1112,10 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	nf_reset_ct(skb);
 
-	if (ptr_ring_produce(&tfile->tx_ring, skb))
+	if (ptr_ring_produce(&tfile->tx_ring, skb)) {
+		drop_reason = SKB_DROP_REASON_PTR_FULL;
 		goto drop;
+	}
 
 	/* NETIF_F_LLTX requires to do our own update of trans_start */
 	queue = netdev_get_tx_queue(dev, txq);
@@ -1119,7 +1132,7 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 drop:
 	atomic_long_inc(&dev->tx_dropped);
 	skb_tx_error(skb);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 	rcu_read_unlock();
 	return NET_XMIT_DROP;
 }
@@ -1717,6 +1730,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	u32 rxhash = 0;
 	int skb_xdp = 1;
 	bool frags = tun_napi_frags_enabled(tfile);
+	int drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 
 	if (!(tun->flags & IFF_NO_PI)) {
 		if (len < sizeof(pi))
@@ -1820,9 +1834,10 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 
 		if (err) {
 			err = -EFAULT;
+			drop_reason = SKB_DROP_REASON_SKB_COPY_DATA;
 drop:
 			atomic_long_inc(&tun->dev->rx_dropped);
-			kfree_skb(skb);
+			kfree_skb_reason(skb, drop_reason);
 			if (frags) {
 				tfile->napi.skb = NULL;
 				mutex_unlock(&tfile->napi_mutex);
@@ -1869,6 +1884,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	case IFF_TAP:
 		if (frags && !pskb_may_pull(skb, ETH_HLEN)) {
 			err = -ENOMEM;
+			drop_reason = SKB_DROP_REASON_SKB_PULL;
 			goto drop;
 		}
 		skb->protocol = eth_type_trans(skb, tun->dev);
@@ -1922,6 +1938,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	if (unlikely(!(tun->dev->flags & IFF_UP))) {
 		err = -EIO;
 		rcu_read_unlock();
+		drop_reason = SKB_DROP_REASON_DEV_DOWN;
 		goto drop;
 	}
 
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 16c30d2e20dc..db2ef8e8d878 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -323,8 +323,14 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_SKB_GSO_SEGMENT,
 	SKB_DROP_REASON_SKB_CHECKSUM,
 	SKB_DROP_REASON_SKB_COPY_DATA,
+	SKB_DROP_REASON_SKB_TRIM,
+	SKB_DROP_REASON_SKB_ORPHAN_FRAGS,
+	SKB_DROP_REASON_SKB_PULL,
+	SKB_DROP_REASON_DEV_NOT_ATTACHED,
+	SKB_DROP_REASON_DEV_DOWN,
 	SKB_DROP_REASON_PTR_FULL,
 	SKB_DROP_REASON_VIRTNET_HDR,
+	SKB_DROP_REASON_TAP_RUN_FILTER,
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index bf1509c31cea..03121373d2f0 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -19,8 +19,14 @@
 	EM(SKB_DROP_REASON_SKB_GSO_SEGMENT, SKB_GSO_SEGMENT)	\
 	EM(SKB_DROP_REASON_SKB_CHECKSUM, SKB_CHECKSUM)		\
 	EM(SKB_DROP_REASON_SKB_COPY_DATA, SKB_COPY_DATA)	\
+	EM(SKB_DROP_REASON_SKB_TRIM, SKB_TRIM)			\
+	EM(SKB_DROP_REASON_SKB_ORPHAN_FRAGS, SKB_ORPHAN_FRAGS)	\
+	EM(SKB_DROP_REASON_SKB_PULL, SKB_PULL)			\
+	EM(SKB_DROP_REASON_DEV_NOT_ATTACHED, DEV_NOT_ATTACHED)	\
+	EM(SKB_DROP_REASON_DEV_DOWN, DEV_DOWN)			\
 	EM(SKB_DROP_REASON_PTR_FULL, PTR_FULL)			\
 	EM(SKB_DROP_REASON_VIRTNET_HDR, VIRTNET_HDR)		\
+	EM(SKB_DROP_REASON_TAP_RUN_FILTER, TAP_RUN_FILTER)	\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
-- 
2.17.1

