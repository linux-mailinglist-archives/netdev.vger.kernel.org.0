Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 680544A87D4
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 16:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351955AbiBCPiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 10:38:55 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:50132 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351913AbiBCPir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 10:38:47 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 213F9VeV032744;
        Thu, 3 Feb 2022 15:37:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ylrSjp7FTH5Qvlu8+RqdsWATCB5o82UlnqCw5g8dTHw=;
 b=s7BuFKayrCKVueyc4G/4H2Sisq917xSeGSU8/MDk8i5/9sducZkhaQ1YADZJVPQDylG+
 nzlBzcUns64GKMO5aC5jTwH0Q5iO81Eis+X2o0ExUxKg5So+2Mzg67GQF/SxpRnLOy7C
 92akTnMkvWbcXzET7PSCSmUrJ80TUC3uOVzWbNuorLjwDx4ymYcs4qmBL68HGwzLJOWv
 uASXKRcCPOD37u/99+WqETqHgWnXuMIQCS4xnora4PC6o4N5QvtpafPw6lBG8/laNwii
 So9dbkxxKeOCHhi88xLZNNelt82IgTVfIuccA5D48GEZzWIBChLgm8BId3xtyXowjiS7 iQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e0het835b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Feb 2022 15:37:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 213FVIM1184560;
        Thu, 3 Feb 2022 15:37:46 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2045.outbound.protection.outlook.com [104.47.57.45])
        by aserp3020.oracle.com with ESMTP id 3dvwdaj9de-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Feb 2022 15:37:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FxSF0gLLZz3V9Ih7I6+NoVK8e1CiNqq9JoXD0/EAi6MajyvVCg1Ze9ZMUPjsyII/QIA9p46C9ggLO4ZlVcF9/+aqfL8n9eP0mswWZAJ9rTuX4n+70j5rkvi3/zcMJAIbQLLwb0vobUkQJglznx1a0lxUdXFTeyW7f6+4QE+ye8NFQ0zEWojcjkrg2bu9yOBt8EMk/FprO49TKl9VkapjQDVlxsRPI+AhhcPLZKZ92E1p99cw9v7twIS2peBgz6Wo3Phfjs/FYE3p37tPyW22oZCuT8NfBR7VfSparvm2ktcN8iqH8KAfaILthPpC9iT2pNidY/64Egqc1SZFU0bJdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ylrSjp7FTH5Qvlu8+RqdsWATCB5o82UlnqCw5g8dTHw=;
 b=d26LpnF/fheB1stU5d3vgqRYTdFh7GhT9EcT75AipE2WH54GyyE1qItXGPxubf7EsldjAYqLZgvvbtoxkmYHxOqfWJ0Tn6f024Tv5yNSa0mV+Q4PkI/zlsTEHia3ccblAGM1sUeuq7OgU0imJYYm7UAizNQgOaeexFjrDP9uAVvorULa/DoMOfyDq0sr0gIUGjDDmT85DrVlCX9mPy6fbJN0HyecAkpIuu9rXpdad2qAYBeR4T5B6bpfaChiZGZVJyJ04KOI32D5KZBDSwe7Wl7roKq/Ud2VaES+1OOyCNgNYUItIOtmw4ZKzxCZQwkmIYD3084FAZJqZn6+L+YQHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ylrSjp7FTH5Qvlu8+RqdsWATCB5o82UlnqCw5g8dTHw=;
 b=aa7nE3YXg7+SAEnaI6ajGg3UOSMJ69ttXb0Be0JXPU/837WFkUw8O2PAznIyAUV5kcaHcZxZ9YXR4xko+xxoEbRfUiuI6m0wt3oZUIoiUY4k11rTuxOK5BnA5Z6VSbRTOsUYnZhe203p7D4Rnn/mHrVq35yEA5Qtm1/BXsjYrYU=
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
Subject: [PATCH RFC 3/4] net: tun: track dropped skb via kfree_skb_reason()
Date:   Thu,  3 Feb 2022 07:37:30 -0800
Message-Id: <20220203153731.8992-4-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220203153731.8992-1-dongli.zhang@oracle.com>
References: <20220203153731.8992-1-dongli.zhang@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::27) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac5b2923-4c89-49d9-2515-08d9e72b1ef6
X-MS-TrafficTypeDiagnostic: BN7PR10MB2436:EE_
X-Microsoft-Antispam-PRVS: <BN7PR10MB24367639C5A0E5C17341591CF0289@BN7PR10MB2436.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WDTm9FjnYlEh/RROa1rzfI/UopFgHLLDDG/63jgIxjFM5tHIIzsB6c3YDO+DS6X4vhWSF4g6udXRpeSr9xkRCwVRWbE4Vl40XyVRmbiWDM832gDQ71g5Ccvoh21vDut5rfHr7ay7OITffIDcyblOAY06Hdljc129wb9cIbOzbjLJ9chS7SrJr7rcZDOLsjx6KwbgXUYROe9Hjl1Ns5k3+zDbLsxQRMdZRuUXf9ECCMfSGMk6MVIkV3IafwyxRdklGqA2vf2/ELNLwwcZsyb7CKawLgNSlaY/rtYqv58GaD3929235UpaVV+xGLwvEo4oEL3JkWYYtv0/Aot623eOVRaYfwbPtBO0AHa8UN29KCBMQu1hqX+h3Zcbwo0i+6WzUoSLItn+PYw1GdADL87tm1s5mR4LyfFtG1v8b4Ae0GyYIIwWZnVagHGzkK5yHyf5bTsnWXGTgdYREbNoU2jYI/Co+5uMon/KLZ1qAjlL4gTPfnTrdoWF82ghNCwHSdD5i/yjp76sOXImug0Bob7EMNsNbc4a/S5LfPvsNcWIiMUWM8J3UZR9tpaY6hVDKWFPfMAfww85RoJuOc206E5nQAe5OrXnMC4b9L2YS71OvxKCdZKH4HGYRkN+V8G2WqbCAIJRnbnGdS1PRLv8GIDRYiC1hPt6ML7J+dWw3CKZjbL5ie137jvLrYRaVVo97PeQFLRmlS0GZ7AO/Wb358nInQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(44832011)(66476007)(52116002)(6512007)(107886003)(7416002)(2906002)(8936002)(66946007)(6506007)(2616005)(66556008)(4326008)(86362001)(6666004)(508600001)(5660300002)(8676002)(186003)(26005)(6486002)(83380400001)(38100700002)(38350700002)(36756003)(316002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9bKoe/t4QEy/Kc212x7AmIkiKuTv4MpHgYmmVIkQ/Ov86xZ+F0jkrGgn5T44?=
 =?us-ascii?Q?i57aP9gcr4stNECZBucEk4oSgSHJmkhAPFBgZ1yx8fYFTOuDr+rhNVO51vWD?=
 =?us-ascii?Q?j8MexZsJAZPtQ1+QNHj9NB/1TYSOfFebi5z9rxOQuuejEPrtXsM40nutobo0?=
 =?us-ascii?Q?dqiIzO9KW4L1oylBz2JqatG4rWKxqh2p1wk96Hoiy1LdLYqASWpnACpqOjJq?=
 =?us-ascii?Q?puX10aPwyKXzPbUbf16FMkGtlQGiXXBZ4VusbtwZMIZg54O3St5CG+bBjBtz?=
 =?us-ascii?Q?cMlhwKfu8F484v0mQvDx+0PwKtKCzBub3T/1KY0T7MxSMIX5owhtMKY1qBGu?=
 =?us-ascii?Q?+ozBdgoyzxoE9N14MAsOfAbeA6gS2GCnMRITSvOjhaB9n4VkIT7oP4OcE6Hy?=
 =?us-ascii?Q?4nkPhQ1G16Ha14TdyFH8xK29FRhz1PVVqTMzVLWYmgwA3TYdwg7ZsxNkHDSU?=
 =?us-ascii?Q?4p19ioNIepCJ2WAQEGqvzDKoTH/vBvAli3+ey/kt25PuIsPRCn7Ge2JzQc7t?=
 =?us-ascii?Q?Nm5vPwceTKM5H7dZNd7d6dDIj4LJvtXG9k49MIopem2hnenc0dSUhtHYfmox?=
 =?us-ascii?Q?1nrfnVr0QI+Bn4wEXGwXusLr1siieKYyVyY6FX/9QrGoG4YPrE8Si/cKOhcH?=
 =?us-ascii?Q?FgDrYB0K6l/ftnDlmZjwJnHcGwrcp7S6ATRM5pdxCLigCFpNfkxJEqE/c+hR?=
 =?us-ascii?Q?1gv1aYrjvZt6o6yulaeAMUMWQrtDfXOzUSyNJi5E86PZFCJC3NZiXR0lTWB8?=
 =?us-ascii?Q?5jCvetHYefMAGqaYmkOyuS2vIGgiNti4SndGhi/pnpV+sxtSpFYLChyf9puh?=
 =?us-ascii?Q?ZGwGz/XnrD/2klCs11UIOwQ4x5oxRPCB80vjJsSVQ8A9EhyrWwEi62enbSmg?=
 =?us-ascii?Q?RATTgG1ivsfSYWaGKWEXkUo6iw7YUaCQpj+lnwl83iiBF718ua2mJL9hqTEc?=
 =?us-ascii?Q?NMxS+Mh3i4LLGiM//8QfB2odRD0yd4B7etuQqW2zmhp/T4JdumHAcNsD0v8B?=
 =?us-ascii?Q?vSDwExTwQQ7NueEnMeTrMdpHgR1pWDKJW89uc0mUJGvUg4ZulxGKsSaIzIwi?=
 =?us-ascii?Q?lh/eTehNsRNHHIJzSqeCDqLmqyAfxzozVPvnCs70dKEcmGTtFxaG4n4nKObD?=
 =?us-ascii?Q?cMoh0wglSaT1ni31c/2eaQiFNvvzNn422VZI/9W9GmCQf5/sQqzlGbg/gvLt?=
 =?us-ascii?Q?3Lp8PEDQmHv9mifPa1nqUeB8VwoGAX0WJZs0aIL8i9fDaLKNM7cJizVDLSNy?=
 =?us-ascii?Q?IQV5K9WJoK3s2ztvMbrVTem7TA/rJ3qePsCkVcUiJd6lJpXzDWyG2m+L6SFa?=
 =?us-ascii?Q?fEAMf52VFy287laeU9XPrawetOe1u8PW2V3ujEe6vmF0iQknc+pYQbDOXMgn?=
 =?us-ascii?Q?AnovJxssOMaGnc4Cu7gQWyEIoh49vNjF6rRCNY5k7OuKIZ7nVAVYscxoKJIQ?=
 =?us-ascii?Q?WvqTrBkNdOfhIenOzupDhQMEDjtnLPj6ZgXPNjEXAtoJjGGgo7yyVFwKqFJ7?=
 =?us-ascii?Q?5kyLE/OaxgoLzFwW9T4C2MqoNV90JDpoeZCvaH3hn7txAto5oGocTTgU/IQ2?=
 =?us-ascii?Q?yGnuzsVq4PIyHFhhRHWNLrjxAGGohr31ymh1WozxZHjWe96Fu2XD2/DaNTLs?=
 =?us-ascii?Q?b0PhwedAH/R9drrTEaq6Nv8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac5b2923-4c89-49d9-2515-08d9e72b1ef6
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2022 15:37:44.2287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TWYPl4UxNewNyjIpADrU48LjAvC14Wp8Ke5Y96ueonlXdZa0QOBznc4nocUNpfgMVUlZWJJb7gX9XD8J3+XW1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2436
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10247 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202030096
X-Proofpoint-ORIG-GUID: BkhkClo6Kf4M6C1dk3IxyFlGEfSOl9HI
X-Proofpoint-GUID: BkhkClo6Kf4M6C1dk3IxyFlGEfSOl9HI
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
 drivers/net/tun.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index fed85447701a..8f6c6d23a787 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1062,13 +1062,16 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct netdev_queue *queue;
 	struct tun_file *tfile;
 	int len = skb->len;
+	unsigned int drop_line = SKB_DROP_LINE_NONE;
 
 	rcu_read_lock();
 	tfile = rcu_dereference(tun->tfiles[txq]);
 
 	/* Drop packet if interface is not attached */
-	if (!tfile)
+	if (!tfile) {
+		drop_line = SKB_DROP_LINE;
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
+		drop_line = SKB_DROP_LINE;
 		goto drop;
+	}
 
 	if (tfile->socket.sk->sk_filter &&
-	    sk_filter(tfile->socket.sk, skb))
+	    sk_filter(tfile->socket.sk, skb)) {
+		drop_line = SKB_DROP_LINE;
 		goto drop;
+	}
 
 	len = run_ebpf_filter(tun, skb, len);
-	if (len == 0 || pskb_trim(skb, len))
+	if (len == 0 || pskb_trim(skb, len)) {
+		drop_line = SKB_DROP_LINE;
 		goto drop;
+	}
 
-	if (unlikely(skb_orphan_frags_rx(skb, GFP_ATOMIC)))
+	if (unlikely(skb_orphan_frags_rx(skb, GFP_ATOMIC))) {
+		drop_line = SKB_DROP_LINE;
 		goto drop;
+	}
 
 	skb_tx_timestamp(skb);
 
@@ -1101,8 +1112,10 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	nf_reset_ct(skb);
 
-	if (ptr_ring_produce(&tfile->tx_ring, skb))
+	if (ptr_ring_produce(&tfile->tx_ring, skb)) {
+		drop_line = SKB_DROP_LINE;
 		goto drop;
+	}
 
 	/* NETIF_F_LLTX requires to do our own update of trans_start */
 	queue = netdev_get_tx_queue(dev, txq);
@@ -1119,7 +1132,7 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 drop:
 	atomic_long_inc(&dev->tx_dropped);
 	skb_tx_error(skb);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, SKB_DROP_FUNC, drop_line);
 	rcu_read_unlock();
 	return NET_XMIT_DROP;
 }
@@ -1717,6 +1730,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	u32 rxhash = 0;
 	int skb_xdp = 1;
 	bool frags = tun_napi_frags_enabled(tfile);
+	unsigned int drop_line = SKB_DROP_LINE_NONE;
 
 	if (!(tun->flags & IFF_NO_PI)) {
 		if (len < sizeof(pi))
@@ -1820,9 +1834,10 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 
 		if (err) {
 			err = -EFAULT;
+			drop_line = SKB_DROP_LINE;
 drop:
 			atomic_long_inc(&tun->dev->rx_dropped);
-			kfree_skb(skb);
+			kfree_skb_reason(skb, SKB_DROP_FUNC, drop_line);
 			if (frags) {
 				tfile->napi.skb = NULL;
 				mutex_unlock(&tfile->napi_mutex);
@@ -1868,6 +1883,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		break;
 	case IFF_TAP:
 		if (frags && !pskb_may_pull(skb, ETH_HLEN)) {
+			drop_line = SKB_DROP_LINE;
 			err = -ENOMEM;
 			goto drop;
 		}
@@ -1922,6 +1938,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	if (unlikely(!(tun->dev->flags & IFF_UP))) {
 		err = -EIO;
 		rcu_read_unlock();
+		drop_line = SKB_DROP_LINE;
 		goto drop;
 	}
 
-- 
2.17.1

