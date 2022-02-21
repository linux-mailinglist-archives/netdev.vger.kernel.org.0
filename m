Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305004BD580
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 06:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344607AbiBUFib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 00:38:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344602AbiBUFi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 00:38:29 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A61A40A1E;
        Sun, 20 Feb 2022 21:38:06 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21L0CsM6022621;
        Mon, 21 Feb 2022 05:35:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=2V4pm+/5XfXTQKhgjJa/3xlubbMV8Yz7huhFBZlSrt4=;
 b=J/WO7dN3iWm3bwzvGdO/O1CiEVYGYINBjQkFoso3jGGog5T32jobwwKJmSzbIBbQr5Gx
 8YcO55dL2qEpMend57s8iRBrisB5i5ZDcTpoNFpoJyPMsrcKj7HniORGi+Toihv7aO4G
 NjROJzDoEu8KcPvl98b4P6YlYkgBmDs7QNyLN45gFYscODNvDtUixCq1HijB8Z/y8E0n
 2FkJ5rwK7Yf5tIsDHkAXtpjOKOgYHWW3lTG9Cw5Uiu4QTq9HVi6UhuBlM9bIULEzeyMo
 LEVjMy+lmEdQ0GBJucO+ucPE03li3UTi2Ro8FlVqaQ/WiETLNrIRieKNdOZTXAvKnM66 uw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ear5t316a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 05:35:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21L5UpLM019684;
        Mon, 21 Feb 2022 05:35:20 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
        by aserp3030.oracle.com with ESMTP id 3eapke8nys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 05:35:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OlgdviWKOHdJI2QmcUIaejxV9j8slpY6Q6JBZYGoZbkDODdBYH1Dc95N8iAK5KLgFqL1ZTJ33C85rBdktcfEy57HGGQWJ5XQzuQaISca7QeXoUsPUOsnZrhSZqeBPVt6hIc8kp5NNT6V/ZzewnnFbw+0ctgvHfk29xlBniAqzixRbBSDAtDVL4u6ctDsQXqubhwmH7qXkwiZHmXJUKC6pLfQ1MIdOUKHNOZS063rpNpHv9HnVp/D4c1msCMEpyUwvbZsecpwBN5Tq0aJcTs8Cky6xf2B/Fqblc7pFfkaHWTMML2HrSohhBqEjv8SWSJ0HQrFQjuDBpUG2u+Gk2J4hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2V4pm+/5XfXTQKhgjJa/3xlubbMV8Yz7huhFBZlSrt4=;
 b=F5walVXAOaGaO6fTaSRuLgLmAL0StRaqXvYcKp2RCAmbK2asxbZ4rojweA5UKztIoirN5/y7Sb6j2hE1SY38mMRSh3g/z0E0pXK58zrE6qSjJgseyGaeiBavx78nHFVzGRLNzEETSEwC86KWEUzEgzWNVaAfJwiA56LPH+6n9NNcwL6V/QOg1CPLU+hZ0gIHOyGuGpvE8P8Ova2YT5/6L0CGAakImGIyafZ2uqDoeJaeipBpzpFYDkqltORFqQDt/ehuEDi9FdVnOFzxZDwWNI5jDmLgeOz2nPJ7CJZ3yj7OsZuqVZfS+BJaA/ELrM3h1UoFDA3dHMg3wwW1trdOYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2V4pm+/5XfXTQKhgjJa/3xlubbMV8Yz7huhFBZlSrt4=;
 b=VSHGvYoQf7jeCOcEfd6m55YpgR3VDpI/sXfOkrAVNWDn7OhTSK9pyRKHwMIcf+0E11xHHRa+9en44ks9NnjOJ5wIglLrhhrj7qB5onBxTvPlcYRjH9/smOYdXF25oRNdViilbEySdQXIuKR4rydzwxR54IyIuNF3HA+hzmRYfTU=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by MWHPR10MB1533.namprd10.prod.outlook.com (2603:10b6:300:26::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Mon, 21 Feb
 2022 05:35:18 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.4995.027; Mon, 21 Feb 2022
 05:35:18 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
Subject: [PATCH net-next v3 4/4] net: tun: track dropped skb via kfree_skb_reason()
Date:   Sun, 20 Feb 2022 21:34:40 -0800
Message-Id: <20220221053440.7320-5-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220221053440.7320-1-dongli.zhang@oracle.com>
References: <20220221053440.7320-1-dongli.zhang@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SA1P222CA0020.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:22c::21) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98e9f90d-252c-45f8-f721-08d9f4fbf1aa
X-MS-TrafficTypeDiagnostic: MWHPR10MB1533:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB153344ED20A55DD8322CEC17F03A9@MWHPR10MB1533.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LNkA/tg4DvwQ7D9iQgtaUzKvLuLg6lxEu9Jn6lOGxn+35FCDgwy09k1IO4Km9HZoRsLQgJasKy+LuM9X69U8WIAdTBb6kVt7p8p7vyizeFFL+KfEfSg55m1eyL6lAmHtQRsYMu55vk4xVQX+PDqrtVzEtRZx9WOelorWddqIz9+Vx/WwBAI9AdLhCFTuyiSvDYkYUrFFva5cj3I60BVgXBR7g6YG50z34QPpezR6JC92u269O7pGCboB6QodQhIY34zxq+e+qhJZ/zq9FjyUr+LH8uPe2Jw4mepmfoU6o3mzqDwwpvGX6SxHPEOOd9j0e2eDBr7py6nrWtZGDN/ZqmbdFoiab/s29KmKosD/5afkEyQGRnOGDry4WS9TNX7v6w61DK5FqomW8+2C53qUfb3pfqi+ezUvEcehmMX7Meheq9ikSjstmcRZ/cSMeVWC1p+gOVdn4BFd6flT/y190LAsZlo90gZvxzKZkH/rBAMr9UfZ6kyjP0OpTUPxveSTgJae4MyzsAyvwDF4+ArPSx+8hyarUD1O9s+H8wSQqk5zxxXehEfoDj2+e2GNPApli52l+IyCJj4FlTcrjJb5er0XgJf2E0wxpQSiPpi6Cc8AUP/n42awP/H4H7F8Ekp/SrP3Tcs7F8oWwN+zIHQz7kvlEWWeXV/9mjAsjaqMwrd91EFy+hQHsvIMjqZaGvieUViDhRZjNulY1UO+1YsIBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(38100700002)(38350700002)(83380400001)(36756003)(7416002)(44832011)(5660300002)(2906002)(8936002)(2616005)(8676002)(6486002)(6506007)(26005)(52116002)(186003)(66946007)(66556008)(6512007)(1076003)(66476007)(6666004)(508600001)(316002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z80nM9MrPf/g6OGTfERU4EICgh/esPsYcZWRk6K4BpNlSY94ButS5p1d5iSs?=
 =?us-ascii?Q?L/bCdn/W3chD3y3gpQx/llAgzrY7SPk36BeOQgh4x2f+ty6jxyXixlT2fXNA?=
 =?us-ascii?Q?jwuKa7DCdGvXK4C1q3p+G3u2EP1a5VHT2IEfRdxCfIXFzBQms9io327dyP63?=
 =?us-ascii?Q?6Shi6soaOZbFsRfnI+iyvMzMJQt6ejTdBiCrdpQcfUmejXUpdKoXKkeexKSk?=
 =?us-ascii?Q?qY9RT+XQ75EoVoCifHKk/IhKxC4z6ppnMRygVVPA/UZrctGT5QZvhxchUICe?=
 =?us-ascii?Q?Qon+dlALADpxXh43C9nomgL11s24MSSBMAX3AN5K0BrsySgjGchzX2h9Yigo?=
 =?us-ascii?Q?F6/ux2cHzp0s3AuGBeFtYJ2fV8bZUNI2C8GMjqT72TIq2gwSqCquBTE2iVUy?=
 =?us-ascii?Q?/rEzEmI9Lcu6kZoOzx/xj2+Q2Y1tJN0JSCYqvGE5PItkbLC9zt8E0/ZDF1Rd?=
 =?us-ascii?Q?UJXKD3ZI8UVhxeV6Jsq9mSg4O7HXbsbhykS0VpwUnHCI9CbuWqnwPFROAZjz?=
 =?us-ascii?Q?F5IH3bkO+968jeduL+TXpxErxTB4Efa28L3XtOdaCDlECsuEz9sOd/Ze3ZFK?=
 =?us-ascii?Q?6NerTcQ3ahEa/vY+So5eG5Ls1PFYnUCz2f0VOYO6Sk1piWFvXkjyYINHJKH+?=
 =?us-ascii?Q?Vdr2nraAXkU1pQQ/YiHLf6oUj/rpWp8JaPhlKZHXgdBrnvTaaIavUQBnBYsU?=
 =?us-ascii?Q?puQXIjBzP8T8kDl2OCta3Yq6jCpzUvGvbAr225SXdqL7ff7pkWbw0RPT2I7F?=
 =?us-ascii?Q?YFRtqKe62/iW5i7EsahGNO3bOyN2sNiDiCkRj5GyN/awBDKU7uTZYeFZynRD?=
 =?us-ascii?Q?RB3Mw8tmwtHl1Umtgk0bW3EuqkvZEtw/8PvNgeNAv1DUSGOwGHtjfS0WYn3G?=
 =?us-ascii?Q?Ivc2ULh4z4p8AErdXHeA69UHZbYKoXl2h8jiyLN7W1mbNDMXr9B3p70kd058?=
 =?us-ascii?Q?KC65eomANFQmgrTPoi8zWUeyNeweQMs2bsTkTtn216uoUbH4naY5AaCxWAhN?=
 =?us-ascii?Q?Rjj7xLSVBBb960zay+CVX8q+hC3D2X3pII984jvR+3y75mZalmxna6zTEyp3?=
 =?us-ascii?Q?XJlBOX0FED3XSuiTYrEuf5h8G0aDwd3xs/d7+yKpI1E6UCwtD+VUc1cMbIyX?=
 =?us-ascii?Q?jiaMZpxPA2VVEjrycgdJGoaY7G2ruw3KbiXNTRnCXVqihL6IGKkaFpoC0ki3?=
 =?us-ascii?Q?w5PVSgG6aKbUmn6iYtm+7K1batlRo6nplwoW2KVXe7GSVlUhqDc/SeDuCdTw?=
 =?us-ascii?Q?7wBdaM1LtBLcAPmpVhi5jLAQRmpF0vl2XN9Zgb2hc73UJJfJIJfY9cR3NOZ5?=
 =?us-ascii?Q?SK38eNsLflEK9AuHcZEfhQz3mwDVpkmDRW/dv5cUxKJKig6+8h2TDMJOvVQy?=
 =?us-ascii?Q?E6fFw/efWegUpmB+oYOZXyIdvnmaeHwIHp1eJK2cgfm/km3jbrBJXwNou7Xc?=
 =?us-ascii?Q?HjV49M+MPI0nooMYJTDs6Ds7pkdRMqAF66A+fbcd6CaFAz2VBnIt7NnKB31D?=
 =?us-ascii?Q?+0Ac+aebvBlUPAYR9BUfoD60K/uP83fFnvw9B5tmv1w8afPTeJbTEi2emDai?=
 =?us-ascii?Q?g9db3VoWUCLWThAeJy2ag23p3yQkx9R+3sAeCfURtDdDlEviBbJ/pZQy+IQF?=
 =?us-ascii?Q?CxKQkjnxRLzJxPOc+oYUsmo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98e9f90d-252c-45f8-f721-08d9f4fbf1aa
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 05:35:17.9836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8p3B1Yl168ei5OtBnVjZzT/SnG9hxbwmqqOvUq9YJgKCY2pUpMubYqHEUVZvgw+c6duHDnrVbnSY0EDGvGSnYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1533
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10264 signatures=677614
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202210034
X-Proofpoint-GUID: ZlRw-uzGXpjLDa9nEqTH6g6tr9XU3QV2
X-Proofpoint-ORIG-GUID: ZlRw-uzGXpjLDa9nEqTH6g6tr9XU3QV2
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
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
Changed since v1:
- revise the reason name
Changed since v2:
- declare drop_reason as type "enum skb_drop_reason"

 drivers/net/tun.c          | 37 ++++++++++++++++++++++++++++---------
 include/linux/skbuff.h     |  7 +++++++
 include/trace/events/skb.h |  5 +++++
 3 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index aa27268..bf7d8cd 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1062,13 +1062,16 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct netdev_queue *queue;
 	struct tun_file *tfile;
 	int len = skb->len;
+	enum skb_drop_reason drop_reason;
 
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
+	enum skb_drop_reason drop_reason;
 
 	if (!(tun->flags & IFF_NO_PI)) {
 		if (len < sizeof(pi))
@@ -1823,9 +1839,10 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 
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
index 52550c7..5850590 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -385,10 +385,17 @@ enum skb_drop_reason {
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
index 5b5f135..0db0962 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -40,8 +40,13 @@
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
1.8.3.1

