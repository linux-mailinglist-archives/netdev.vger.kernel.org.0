Return-Path: <netdev+bounces-1052-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01B216FC040
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:13:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8749281263
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 07:13:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E237F5673;
	Tue,  9 May 2023 07:13:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4F6566B
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 07:13:33 +0000 (UTC)
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2044.outbound.protection.outlook.com [40.107.215.44])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B22919B9;
	Tue,  9 May 2023 00:13:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lILUlwi5Ax+OSNWLgp0ITtXnxtJ23YOKOUlt6QG7xUgcQIWmBA8sBbH7QXMEGCXfllJcJqBCdau2I1OQ93/teLlY10njHyExJdA7POSdZkVdLQ+n6EuP56bpdCORBR0BEJVdb6SRxtgvjy/bBfYGuiS2goPHtm1m3aNOfpCseJho8tPQJ9+QaDgGVxfLKtQVD5pDvbA+kNl1CmBZ3LZ9zohIzl6tc7om0jN0wrnFkgY3wkkdTx2MtRlEWhpSIMvXAzs16ypOQSv7R5zaDtmGdQYKc5+jg0buPu14/ogAqDj17G9NBxP3rtFwci+rHl5AMsbfYd6CapLMHjmHdKTDrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n/yfJx8Yu2SEH1YJZxuicb715aSoUhFTN5RPUFUwopU=;
 b=Vty/hH9feOkeqB4nHOFQRIB2B+s5uj+xTk/v/vT7YiJk1zAbhp7sOpJm9MGug1WmzgyTeVl0wO3F92WXCHiR0brBg/8SvIVSUQLC+yJc4k85wjPtxbzjqcKgRtnxNmy1px3ogRGPeY3vWSyJRn4t1/q4CcUaS1g2TDV9mIVH+qITtuhCVh7eWbbByB8KnkxiICx499bZoS45J40EFfrdUwBGTc8zM1GLI1BrED66715pAmzU0aROzQkAhxvHy6/xGxELiUr24GiysmLPBigEYLarBdfEhBx5dS4NCaYv8uO8sUEYX8WxNsgcxV6+ITNbYAkPqdO18FIsV3YlDboCig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jaguarmicro.com; dmarc=pass action=none
 header.from=jaguarmicro.com; dkim=pass header.d=jaguarmicro.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaguarmicro.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n/yfJx8Yu2SEH1YJZxuicb715aSoUhFTN5RPUFUwopU=;
 b=pyyPnE5MYaYLhkW0UenvoQsxM2eQC+Gz8fFXu7hyyznmR9KCISys8mzEPitasLqcCvoa3OiD/pOjqTSHn57SYwDtBYz2roNpFvWfrfUiZGksyjVScqgDc9pFLrDLHoJGB9F1xLvg6wZ0y/N/tfNNy0UyujPagxHG4WZRxSfZMqUpzU3lb4t3ve2/d781KmVYIE3XFyosFGId5zdSejGyTDiuaGvyJRHLeHFyUw7c5j3xHYH+eISJwQQCPps9Go3Kzhyi7bHK7JQSa18pmyxWtCcfspVnNJwH9mRiGjyOoKoZP3+B/mKEAqFFbuxCMBQC/ERy+3KFyMp0NqrHU5Hk/A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=jaguarmicro.com;
Received: from SG2PR06MB3420.apcprd06.prod.outlook.com (2603:1096:4:9c::20) by
 TYZPR06MB5841.apcprd06.prod.outlook.com (2603:1096:400:28e::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.32; Tue, 9 May 2023 07:13:26 +0000
Received: from SG2PR06MB3420.apcprd06.prod.outlook.com
 ([fe80::79ee:e13e:ac9b:16b3]) by SG2PR06MB3420.apcprd06.prod.outlook.com
 ([fe80::79ee:e13e:ac9b:16b3%6]) with mapi id 15.20.6363.033; Tue, 9 May 2023
 07:13:26 +0000
From: Angus Chen <angus.chen@jaguarmicro.com>
To: davem@davemloft.net,
	dsahern@kernel.org,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Angus Chen <angus.chen@jaguarmicro.com>
Subject: [PATCH] net: Remove low_thresh in ip defrag
Date: Tue,  9 May 2023 15:12:43 +0800
Message-Id: <20230509071243.1572-1-angus.chen@jaguarmicro.com>
X-Mailer: git-send-email 2.33.0.windows.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR06CA0009.apcprd06.prod.outlook.com
 (2603:1096:404:42::21) To SG2PR06MB3420.apcprd06.prod.outlook.com
 (2603:1096:4:9c::20)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SG2PR06MB3420:EE_|TYZPR06MB5841:EE_
X-MS-Office365-Filtering-Correlation-Id: 6850c471-f832-4ab4-a0ab-08db505ce1d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	pPU+gOPsvAcry+GF4s4v1ePrcJT1d/xXHMycerZNDuEoYflnfAkTViQGYNBi0AjbXNRK/KEl5epZc7klmGKIxEJZHQ5+sm4iA3EpMJwdGH4Y2QvQn7RX2WmUSYMGxlkyiBzfEL3AOzqGCyagnl4/BDZaM4jKW+rpqC55EdhSQXOfwagtVLdrzrqR4w7uLZd07+MmwbVqbRZcVuiPZR5LdQIfMqzuh1Bubyrkh5wzFy5xr5rle7VTcOiMtgvHjm4wuzkmJxI7k2S8PjWfOFT150KPGaMhLmoUBEijMF/fBZkubgot/98QYR42z/QjPgJh/gcaksRQrcApcZpTckoZc9+G4VG7JLTniNcnHtcL+2ZO/crNw5AUqTlqL2pkZt4dh0drTd5h3YvYS5Zcwvue084wp8iL2h8yFCBxsNbKS9xP6yWYUQXomHFVGbDKQTqzeZ/79DCdtTi8S9bZg6woZrW3IcQhl28r6BkgjikEKgf85dJfbkbgxvGuZlsYD/g2GG8+Y92CtvjZaV/shFFkFoFfk4M0SwuSz7AQFjQ/JYsqPFErTp52hMTXwQo0q+MIyDO7KPuTasti4R/vQmTLVwLVQdrBz5DmzTKB8GEeK2gObdOblRDwNaZnRBOT2ZHA
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3420.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(376002)(396003)(346002)(39830400003)(451199021)(4326008)(2906002)(8936002)(478600001)(316002)(66476007)(5660300002)(66556008)(8676002)(41300700001)(6666004)(44832011)(66946007)(52116002)(6486002)(6506007)(1076003)(6512007)(26005)(107886003)(186003)(2616005)(36756003)(83380400001)(38100700002)(86362001)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gtyygNjguqo+ZFrvJCOH6DkPBOE9caT0Oska/w8EbkSKzFiaIC/vTH1j8HcF?=
 =?us-ascii?Q?c2jQy/OY/uRdHrRdPQcny3p1XrpxPPhS/plixuI3fvwzuFYmlTwxBDRQVeKG?=
 =?us-ascii?Q?NN/tgrHv1JiYoy1IIPlaPpgun/slpCggKnWeeKG8SPZlw5xpPSmGJq6EAEhC?=
 =?us-ascii?Q?fnRoi73IPoFjTwx3ib5LkA9w3NXz3ruVZvJ9FGQ7SYFyP31qtxXjDIck85+p?=
 =?us-ascii?Q?xCpE6BNdjsM2dxzHAjgPtcZLLZjtpqMQqttEDPmZgqPBgyf/oenrujzIT+PV?=
 =?us-ascii?Q?jF0L+K7EKmhwMgDmAfTtwmPjhNbwi9wnQIxdi2DssI+jph6q76RIRQvEDeJT?=
 =?us-ascii?Q?YeG+EN9V5wgivLnGbHbX6C3T0N+9TBvtphDUlyOEcRLxS4ix1pk88qmP11yM?=
 =?us-ascii?Q?+fJOnyEN2qsxdYpE8sz7MYRtM09r1eh+lxewmYznZ5xl1/NppldHMn9TXIMj?=
 =?us-ascii?Q?Gdb67FCe44X0KduJOs9dp5VRkuCRo/Jt2lh9mVCeR90USKwlu80SghYNz+sQ?=
 =?us-ascii?Q?TnPy7j4yRcNfflq13KP6y2mgSK/2+qOgtzOJr4+gskUX1QRehD7xvje2CUKY?=
 =?us-ascii?Q?3ZyvzZAqsUbptmsMrJj0TPvh4sSM8wYccQxA/5fDuRDEXxH1XRstb5D0jb4I?=
 =?us-ascii?Q?Y3tvTdTzxSFLMpz598hHt16IabFYJbwdVFDK9urdBg/YRf5JlhBLvCguRZLl?=
 =?us-ascii?Q?rwyrYlktTb4Fee195Uifibhc+YvOVa5qUvoKsMSlq7R+lVEk5QVoAwAGwY1w?=
 =?us-ascii?Q?rtb5DuY2YH+j60oiS7lMSkrAHw5CxlmI8pL+KR5AKPsF3kuk/mifgpLk1XQ3?=
 =?us-ascii?Q?o9Hqa7i+CnPi2r51HC02JvXk7VAagTwW4hLC6zx7sNkIYpQ/jt7RY4IhxwfY?=
 =?us-ascii?Q?leC6GY3b6g9LfCqX7a1O5tNjLYkvXNzEcWzOsiBmJv3+oPdbdZnXmXIFZo9N?=
 =?us-ascii?Q?cfRwQpFsIIJyaq6PjR/kA6JJT1aYhMQ+9aQHNs4nVSCViasYoqAkTP2oySCs?=
 =?us-ascii?Q?bGhU0Mw+OdxLi+aY6JU7qzbhLt4cREFFVZXe35C+S0ZZ4pVz5C96+njq1m30?=
 =?us-ascii?Q?wuPqp5hUR/vNKfN0YF283VMsdFlfY73IFcv2oTGg0T80XS9J/Y+LMzEdmitE?=
 =?us-ascii?Q?KtGuGrQfT81vUoVT41t+ilOF6Ps71FCU7Fprl13ZPV3phMpO0PlwC7lQwtsS?=
 =?us-ascii?Q?zDd6A5UQL1DZQpmgMTr2LY/JqGOa9KSaV4PABXCO0Z87b3wWmrSQPfc7z/lI?=
 =?us-ascii?Q?W5Y+OMbuqVsY54LngzGk5/BnjLFmTfJU6nzIgF0Ju7cOhKWTsv3wl/5TLqAK?=
 =?us-ascii?Q?e/E5RbgipekVGBTy7TM/vN3rEpjexYMabRVYYSCNRQnIU34ejdOoPlqdSrEp?=
 =?us-ascii?Q?bQDwF+hI0DHwWXFkCkYBInZUdV/z7aDzcs2ya5C6HHLY0P0dF2B829nZ4rX2?=
 =?us-ascii?Q?+AHsxy7IJ4rf5tGKAfuRYGmbwhdhX9W4gvW/zun34KDY07KlvXo9hoD36LpH?=
 =?us-ascii?Q?iCmyZDYnkTg7U4Y91/yqwiAR6ZUPowJhYt4GAZwkYmbuODuqKjJuAA4VuPQU?=
 =?us-ascii?Q?BrxmabGu3DODUWQfDNcRM+MiKzjLuXngx30zkuqiCcNBLhFx6UerBxS/uwCv?=
 =?us-ascii?Q?Cw=3D=3D?=
X-OriginatorOrg: jaguarmicro.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6850c471-f832-4ab4-a0ab-08db505ce1d1
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3420.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 07:13:26.3990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1e45a5c2-d3e1-46b3-a0e6-c5ebf6d8ba7b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S8prbgRyVPgRakAvc9G1iZCAIvGfDdwsXO43O6TkN8799sYKOJvx1eXOFcttlrXBxqRCUJzJFLLG75RPmu+gYHlXppi8/zW4OlqJzdUoSGE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB5841
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

As low_thresh has no work in fragment reassembles,del it.
And Mark it deprecated in sysctl Document.

Signed-off-by: Angus Chen <angus.chen@jaguarmicro.com>
---
 Documentation/networking/nf_conntrack-sysctl.rst |  1 +
 include/net/inet_frag.h                          |  1 +
 net/ieee802154/6lowpan/reassembly.c              |  9 ++++-----
 net/ipv4/ip_fragment.c                           | 13 +++++--------
 net/ipv6/netfilter/nf_conntrack_reasm.c          |  9 ++++-----
 net/ipv6/reassembly.c                            |  9 ++++-----
 6 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index 8b1045c3b59e..9ca356bc7217 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -55,6 +55,7 @@ nf_conntrack_frag6_high_thresh - INTEGER
 	nf_conntrack_frag6_low_thresh is reached.
 
 nf_conntrack_frag6_low_thresh - INTEGER
+	(Obsolete since linux-4.17)
 	default 196608
 
 	See nf_conntrack_frag6_low_thresh
diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index b23ddec3cd5c..6c056547e690 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -13,6 +13,7 @@
 struct fqdir {
 	/* sysctls */
 	long			high_thresh;
+	/* low_thresh is deprecated */
 	long			low_thresh;
 	int			timeout;
 	int			max_dist;
diff --git a/net/ieee802154/6lowpan/reassembly.c b/net/ieee802154/6lowpan/reassembly.c
index a91283d1e5bf..3ba4c0f27af9 100644
--- a/net/ieee802154/6lowpan/reassembly.c
+++ b/net/ieee802154/6lowpan/reassembly.c
@@ -318,7 +318,7 @@ int lowpan_frag_rcv(struct sk_buff *skb, u8 frag_type)
 }
 
 #ifdef CONFIG_SYSCTL
-
+static unsigned long lowpanfrag_low_thresh_unuesd = IPV6_FRAG_LOW_THRESH;
 static struct ctl_table lowpan_frags_ns_ctl_table[] = {
 	{
 		.procname	= "6lowpanfrag_high_thresh",
@@ -374,9 +374,9 @@ static int __net_init lowpan_frags_ns_sysctl_register(struct net *net)
 	}
 
 	table[0].data	= &ieee802154_lowpan->fqdir->high_thresh;
-	table[0].extra1	= &ieee802154_lowpan->fqdir->low_thresh;
-	table[1].data	= &ieee802154_lowpan->fqdir->low_thresh;
-	table[1].extra2	= &ieee802154_lowpan->fqdir->high_thresh;
+	table[0].extra1 = &lowpanfrag_low_thresh_unuesd;
+	table[1].data   = &lowpanfrag_low_thresh_unuesd;
+	table[1].extra2 = &ieee802154_lowpan->fqdir->high_thresh;
 	table[2].data	= &ieee802154_lowpan->fqdir->timeout;
 
 	hdr = register_net_sysctl(net, "net/ieee802154/6lowpan", table);
@@ -451,7 +451,6 @@ static int __net_init lowpan_frags_init_net(struct net *net)
 		return res;
 
 	ieee802154_lowpan->fqdir->high_thresh = IPV6_FRAG_HIGH_THRESH;
-	ieee802154_lowpan->fqdir->low_thresh = IPV6_FRAG_LOW_THRESH;
 	ieee802154_lowpan->fqdir->timeout = IPV6_FRAG_TIMEOUT;
 
 	res = lowpan_frags_ns_sysctl_register(net);
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 69c00ffdcf3e..0db5eb3dec83 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -553,7 +553,7 @@ EXPORT_SYMBOL(ip_check_defrag);
 
 #ifdef CONFIG_SYSCTL
 static int dist_min;
-
+static unsigned long ipfrag_low_thresh_unused;
 static struct ctl_table ip4_frags_ns_ctl_table[] = {
 	{
 		.procname	= "ipfrag_high_thresh",
@@ -609,9 +609,9 @@ static int __net_init ip4_frags_ns_ctl_register(struct net *net)
 
 	}
 	table[0].data	= &net->ipv4.fqdir->high_thresh;
-	table[0].extra1	= &net->ipv4.fqdir->low_thresh;
-	table[1].data	= &net->ipv4.fqdir->low_thresh;
-	table[1].extra2	= &net->ipv4.fqdir->high_thresh;
+	table[0].extra1 = &ipfrag_low_thresh_unused;
+	table[1].data	= &ipfrag_low_thresh_unused;
+	table[1].extra2 = &net->ipv4.fqdir->high_thresh;
 	table[2].data	= &net->ipv4.fqdir->timeout;
 	table[3].data	= &net->ipv4.fqdir->max_dist;
 
@@ -674,12 +674,9 @@ static int __net_init ipv4_frags_init_net(struct net *net)
 	 * A 64K fragment consumes 129736 bytes (44*2944)+200
 	 * (1500 truesize == 2944, sizeof(struct ipq) == 200)
 	 *
-	 * We will commit 4MB at one time. Should we cross that limit
-	 * we will prune down to 3MB, making room for approx 8 big 64K
-	 * fragments 8x128k.
+	 * We will commit 4MB at one time. Should we cross that limit.
 	 */
 	net->ipv4.fqdir->high_thresh = 4 * 1024 * 1024;
-	net->ipv4.fqdir->low_thresh  = 3 * 1024 * 1024;
 	/*
 	 * Important NOTE! Fragment queue must be destroyed before MSL expires.
 	 * RFC791 is wrong proposing to prolongate timer each fragment arrival
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index d13240f13607..1b1324713af6 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -42,7 +42,7 @@ static struct nft_ct_frag6_pernet *nf_frag_pernet(struct net *net)
 }
 
 #ifdef CONFIG_SYSCTL
-
+static unsigned long nf_conntrack_frag6_low_thresh_noused = IPV6_FRAG_LOW_THRESH;
 static struct ctl_table nf_ct_frag6_sysctl_table[] = {
 	{
 		.procname	= "nf_conntrack_frag6_timeout",
@@ -82,10 +82,10 @@ static int nf_ct_frag6_sysctl_register(struct net *net)
 	nf_frag = nf_frag_pernet(net);
 
 	table[0].data	= &nf_frag->fqdir->timeout;
-	table[1].data	= &nf_frag->fqdir->low_thresh;
-	table[1].extra2	= &nf_frag->fqdir->high_thresh;
+	table[1].data	= &nf_conntrack_frag6_low_thresh_noused;
+	table[1].extra2 = &nf_frag->fqdir->high_thresh;
 	table[2].data	= &nf_frag->fqdir->high_thresh;
-	table[2].extra1	= &nf_frag->fqdir->low_thresh;
+	table[2].extra1 = &nf_conntrack_frag6_low_thresh_noused;
 
 	hdr = register_net_sysctl(net, "net/netfilter", table);
 	if (hdr == NULL)
@@ -500,7 +500,6 @@ static int nf_ct_net_init(struct net *net)
 		return res;
 
 	nf_frag->fqdir->high_thresh = IPV6_FRAG_HIGH_THRESH;
-	nf_frag->fqdir->low_thresh = IPV6_FRAG_LOW_THRESH;
 	nf_frag->fqdir->timeout = IPV6_FRAG_TIMEOUT;
 
 	res = nf_ct_frag6_sysctl_register(net);
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 5bc8a28e67f9..eb8373c25675 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -416,7 +416,7 @@ static const struct inet6_protocol frag_protocol = {
 };
 
 #ifdef CONFIG_SYSCTL
-
+static unsigned long ip6_frags_low_thresh_unused = IPV6_FRAG_LOW_THRESH;
 static struct ctl_table ip6_frags_ns_ctl_table[] = {
 	{
 		.procname	= "ip6frag_high_thresh",
@@ -465,9 +465,9 @@ static int __net_init ip6_frags_ns_sysctl_register(struct net *net)
 
 	}
 	table[0].data	= &net->ipv6.fqdir->high_thresh;
-	table[0].extra1	= &net->ipv6.fqdir->low_thresh;
-	table[1].data	= &net->ipv6.fqdir->low_thresh;
-	table[1].extra2	= &net->ipv6.fqdir->high_thresh;
+	table[0].extra1 = &ip6_frags_low_thresh_unused;
+	table[1].data   = &ip6_frags_low_thresh_unused;
+	table[1].extra2 = &net->ipv6.fqdir->high_thresh;
 	table[2].data	= &net->ipv6.fqdir->timeout;
 
 	hdr = register_net_sysctl(net, "net/ipv6", table);
@@ -536,7 +536,6 @@ static int __net_init ipv6_frags_init_net(struct net *net)
 		return res;
 
 	net->ipv6.fqdir->high_thresh = IPV6_FRAG_HIGH_THRESH;
-	net->ipv6.fqdir->low_thresh = IPV6_FRAG_LOW_THRESH;
 	net->ipv6.fqdir->timeout = IPV6_FRAG_TIMEOUT;
 
 	res = ip6_frags_ns_sysctl_register(net);
-- 
2.25.1


