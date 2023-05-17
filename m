Return-Path: <netdev+bounces-3140-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AC268705BE1
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 02:18:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6258C280FA5
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 00:18:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 828D0193;
	Wed, 17 May 2023 00:18:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8A27E
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 00:18:49 +0000 (UTC)
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2087.outbound.protection.outlook.com [40.107.117.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885792118;
	Tue, 16 May 2023 17:18:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X8q/9nW8khbQWwuxPvpfPvl9xbbJ0Q+0JoFplhX8yfORKi1IOIsiMyKb7ACtEOnP3uWWHSUG8zV96zj1EEG47OcXmBJeuEj3+Wxfzsawl81fIrkHRwQOkEkloCQYC0Dp/UvcPaMi6Ka6Yqrlq5koYHDC2xDf0ek4MCiC1yGA/vwPPVOlWKnqm+7yUS+8wV0UUncmOUvS/KU01XOMSDnfCfRb4D/111ea4AP9hzdjAFHtsNUAGObVNpbij8jhGp3WAntcFIZC1M2yn8kTn+s8K+zjzfkcAESaBS50WjBcUh6CQ8A5Vvp2beCllvLGWwxDmGJPiZrRKWamqC9u0Rqi1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ypEQAVGZ18DmGwgbd1Li+/UGo8c7JflQT1cTvTDsYOM=;
 b=eifHlOH3MC5P7kXadYtcVEeAqEx0cSZYy5dcJiRvzG8uuo8NAqz+P6oxGdVBSOgejzkhedDsSN6+Omqsio1LZeX+ICNnmtagRneKkF2l6vV6zLPHr3PrrYN/utQk6FwZ1L/BCaMg99DFFD/U5jKrN6qQsIoAZPI2KmL1VfWoTzbjJp0wGULZ202id+EGH7rsztw3q69ZKHOHG2uI+TT/I1NcIkIJoiM9pbpQSNpZVfugF7T5RmTmYgqtVantQY0H9XyGZxFQh6sXr7yOE7ZHKVw3HSso9tmeGNEZNiJP9QwzKXYLL+fMG2rG+g3DWergcCGCfY66QTOKH6XMcO1Ouw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jaguarmicro.com; dmarc=pass action=none
 header.from=jaguarmicro.com; dkim=pass header.d=jaguarmicro.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaguarmicro.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ypEQAVGZ18DmGwgbd1Li+/UGo8c7JflQT1cTvTDsYOM=;
 b=TMzW8FF3TKlLcLxyz/VIe2+y1G5A2twfFIQBH7zdMRjor66I3sFp3w/uaFZIkumOeBbjBhuH4LZVlbR4oBhitcw1jwLxqgK1SUMEKpF4jAvvAoa10mOIgB0NTbzU6j6u9yDbUtVNULvHH5185ZcmtreJPCNy6cUa9O6dEk2jbZyDCvtic97iGtY6s4GZmtDjiv/+zheENDYeYkQ6EDSXzEEpTfB6/F7cgsBK2CPX1s2prNba4pHMd0fyw+mPk2mcgXKT8dSJUvWRuCMxv0sLj9YMrsuv+Useoi2Uc406BDtNdAXWryBPA6fQcju2ZtimwtEJIPACwSFij+Tj3vgVVg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=jaguarmicro.com;
Received: from TY2PR06MB3424.apcprd06.prod.outlook.com (2603:1096:404:104::19)
 by SEYPR06MB6522.apcprd06.prod.outlook.com (2603:1096:101:169::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.32; Wed, 17 May
 2023 00:18:40 +0000
Received: from TY2PR06MB3424.apcprd06.prod.outlook.com
 ([fe80::60d6:4281:7511:78f7]) by TY2PR06MB3424.apcprd06.prod.outlook.com
 ([fe80::60d6:4281:7511:78f7%6]) with mapi id 15.20.6387.034; Wed, 17 May 2023
 00:18:40 +0000
From: Angus Chen <angus.chen@jaguarmicro.com>
To: davem@davemloft.net,
	dsahern@kernel.org,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	idosch@idosch.org,
	petrm@nvidia.com,
	Angus Chen <angus.chen@jaguarmicro.com>
Subject: [PATCH v3] net: Remove low_thresh in ip defrag
Date: Wed, 17 May 2023 08:18:20 +0800
Message-Id: <20230517001820.1625-1-angus.chen@jaguarmicro.com>
X-Mailer: git-send-email 2.33.0.windows.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0134.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b6::16) To TY2PR06MB3424.apcprd06.prod.outlook.com
 (2603:1096:404:104::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TY2PR06MB3424:EE_|SEYPR06MB6522:EE_
X-MS-Office365-Filtering-Correlation-Id: 021c9da9-efc2-42c0-07dd-08db566c43fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	IgalW3TM4zpqih/ByMsxGdX+k6hXVZT0EVKH5Fc/EkCDgrk8JNv5ME/3ev6DfdJI4rqBoLT/ruXn3cPpw4tQkIZf4wocCk8eidKsU016cVQD2oQhJyJvtzNkXgUV9AP0oUGSaUxbkjNlE/uJ2rpjkzpsJkdbsWq6i2fjDcEAwKaEINDTzePWOkL8ZSo0Z876PZ155AhISF0mxAAj+dCeoMDSLlRfEzA6BcKcV9ifeTnGqMxGjBObisVRy9i2/EUSkKhnMXw39LpAepNTjsDb74OKhFK1qjs4M1CaxeXPFsgxunDCuxu04cn4aLZCzioyo5Qs+ahCwKeFuxJqR8BWVfVq+hqjWJ63uvjuLENiXuop3rw9OLPWuSVKuzgb8BlFPe/yilpn5gQONdrHvOTDgAMSTgT4+PZiBwW+ckesSoEuXqhOA6+ZpXxvL4A3YNaY6phQS8rSeD0fMnZzBpFWE65aJ4tqO8zdDgQS9qdWNlPCml35iOMXEMpLQoeR/saVbbXFbNrGyCfg8BC4tm3gIheXIkYHMxJ/0/O+1I44XiPxTHKWoRLMkXPXVvEWdKMrCxmYsZqicDM5GyGEKasMEfWLPVaVlZBdrK2rTVCi70eGZJX98EO2M/dYlEzTJY1o
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR06MB3424.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(366004)(346002)(396003)(39840400004)(451199021)(44832011)(5660300002)(2616005)(8676002)(8936002)(2906002)(83380400001)(186003)(36756003)(38350700002)(38100700002)(86362001)(6506007)(6512007)(107886003)(26005)(1076003)(316002)(6666004)(478600001)(66476007)(66556008)(66946007)(4326008)(41300700001)(52116002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+BlSt/lQ5/X+Mx54pSIUIZpsS2RIMIRWQZUQVG/i4mvj4T3qRfoIqOFM5z3B?=
 =?us-ascii?Q?ND4dtERBM6cPiS2biFqQH01JbYkLBdeBPMnxDjOjXE27FV+HdGiPhArKwvRx?=
 =?us-ascii?Q?uTqkSESN3Wc0tNZgl00lOrvNiyn9Xy+186PQMTB2TKM5c/E1WcrQ8bSFfkdZ?=
 =?us-ascii?Q?rd7OOXWFc7NnwA5HNA8qRk/ZUXZQ8ex7Ho1LooveYgUwphRBQVm/TGc8kdq8?=
 =?us-ascii?Q?3mEWBAIVVfn5VKuuwMD3dzobJDfse3Q/6xrfz0CP5jjNvmqoiBvBCr9+6w3X?=
 =?us-ascii?Q?PRBW1l6NUN0EW0aOC3lUdTgDvDhby11gDILQAb4MnArSRuIEXIQ5N0lIF8wu?=
 =?us-ascii?Q?VAYfc7o11po3pvk71qgWm3a1vhEhfRbzVd9N1DBYlsnhIK3iQyJ2UpNx/Ot6?=
 =?us-ascii?Q?TFCIE2sXwUYTxV1VQxMvbIAQLzBkWvBo212hbHZAYHN+4ZyxmALHNQWDj7he?=
 =?us-ascii?Q?5YnYXboOTmobL8lRA36CLrrB7ZEZG6eFflU4bdeZnqtjMehq/t7NtigPcvZ3?=
 =?us-ascii?Q?fBnfrQ9n9rmdAQcBWli9ot7ki5kuxkozza5pt2M8B2S1hm25U7XZ8YMlTu5m?=
 =?us-ascii?Q?N76mD00qQu3UukLMksT2cgwztaTBjAPz6odXEbUdYYv40bKqLdSY7NFoq3sO?=
 =?us-ascii?Q?eRokugzTbjsliM5nRSL442o+w7hn/4pOAad7HHx9woZ8ZTyuZnEgi8s35raG?=
 =?us-ascii?Q?56BoC5371ti2Kv2vdzJNrH8z5Y7NHJROoGUMeb/TFmZlHlD1N5q39dUWOLl8?=
 =?us-ascii?Q?YreTgNvLqQiNHyvqyUnR64qIFxswTqN4akDXDS5Tk6RNNsW1B20FHhCIA2xE?=
 =?us-ascii?Q?2r8o11zG+Nq04JCrbEzUEzWX1vr7IEA94NEpnKuczwqczVXJRH06AYFPLPSy?=
 =?us-ascii?Q?H18pe+Q7uXDqmOF1GbtE6s+VN+W2ycCiTrbc6aZmtNAfCb9QWysuW1RjUWJq?=
 =?us-ascii?Q?sYBPPv40uD0cLYqaqBiqfoWGE7Bz5UPtLFCUEbSIA/xy4XxyrUNLtowod8xQ?=
 =?us-ascii?Q?SkKVVjGHE4SjLoxjHy8jkpztqKPTHl5gezf+tfhoN2oESz1evo0NIRJpnte3?=
 =?us-ascii?Q?+kkoxKaVbRlof2rMKNs4vIyEuZNVUK83mNMgwLwRl1RZ7xOVbSimekRo8nYb?=
 =?us-ascii?Q?vo/qlODSXaZCWSqrXaS0o1em3YHb8Ky7U7/+Qzmcf/bAEl0QsiKno1BI1Ykf?=
 =?us-ascii?Q?KqHZHBHt4P3DVtedlt/foXP3M4Xq9XPT/wtNDHf5lqzgtGWMNeaRlYHputfn?=
 =?us-ascii?Q?0uEsUmvkUISo12JCLJvpHAc6mxzfB8iVe3r0tVEYnEpy4pkxAq/OQS8Bfy38?=
 =?us-ascii?Q?17N1GakOd1f2HSMq12IGsWbJQOSkaqmwmlUmBesLy8/9I9h6XM2Vij7Dmr7A?=
 =?us-ascii?Q?7hfrx3XyV+VEfTp5Dky/my7dO7weWRSXj7ecZvDuUIWO16nDwyoW5jso6tZm?=
 =?us-ascii?Q?SdEuBEgNUTEPTNgWG/621J2hAb2zjQawKW5rTL6rG8vaf3+PhPtT5+8ddt6s?=
 =?us-ascii?Q?GIT8q4YOqK9U1HxMgFQTle/pVcgReE0JNO3MBEt0H9lhboGRUTxSe6Sd8t+Y?=
 =?us-ascii?Q?J8HEMUC+ie9GfDklmBsw+DPWPIGEUnbD+IaVEN5wrKDHaeeFzDAsJtjICzdW?=
 =?us-ascii?Q?iA=3D=3D?=
X-OriginatorOrg: jaguarmicro.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 021c9da9-efc2-42c0-07dd-08db566c43fe
X-MS-Exchange-CrossTenant-AuthSource: TY2PR06MB3424.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 00:18:40.2398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1e45a5c2-d3e1-46b3-a0e6-c5ebf6d8ba7b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FDUuWpk8NOr43MXz9Bd/k/I4wGZg7bhsGrAx0g7mIFvKPJl8yWZ9gJLuhiwOxeQtYYkmDt2ViCPDUhGuriN8hfkIoPUhd0ubDHrq6JpPaVE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB6522
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

As low_thresh has no work in fragment reassembles,mark it to be unused.
And Mark it deprecated in sysctl Document.

Signed-off-by: Angus Chen <angus.chen@jaguarmicro.com>
---

v2:
 Fix some spelling errors,and remove low_thresh from struct fqdir.
 suggested by Jakub Kicinski <kuba@kernel.org>.

v3:
  Change low_thresh to low_thresh_unused in struct fqdir.

 Documentation/networking/nf_conntrack-sysctl.rst |  1 +
 include/net/inet_frag.h                          |  5 ++++-
 net/ieee802154/6lowpan/reassembly.c              |  6 +++---
 net/ipv4/ip_fragment.c                           | 10 ++++------
 net/ipv6/netfilter/nf_conntrack_reasm.c          |  6 +++---
 net/ipv6/reassembly.c                            |  6 +++---
 6 files changed, 18 insertions(+), 16 deletions(-)

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
index b23ddec3cd5c..6ef360e4b729 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -13,7 +13,10 @@
 struct fqdir {
 	/* sysctls */
 	long			high_thresh;
-	long			low_thresh;
+	/* low_thresh is unused since linux-4.17,
+	 * keep it just to avoid getting warning from ensure_safe_net_sysctl.
+	 */
+	long			low_thresh_unused;
 	int			timeout;
 	int			max_dist;
 	struct inet_frags	*f;
diff --git a/net/ieee802154/6lowpan/reassembly.c b/net/ieee802154/6lowpan/reassembly.c
index a91283d1e5bf..c46cbe001646 100644
--- a/net/ieee802154/6lowpan/reassembly.c
+++ b/net/ieee802154/6lowpan/reassembly.c
@@ -374,8 +374,8 @@ static int __net_init lowpan_frags_ns_sysctl_register(struct net *net)
 	}
 
 	table[0].data	= &ieee802154_lowpan->fqdir->high_thresh;
-	table[0].extra1	= &ieee802154_lowpan->fqdir->low_thresh;
-	table[1].data	= &ieee802154_lowpan->fqdir->low_thresh;
+	table[0].extra1	= &ieee802154_lowpan->fqdir->low_thresh_unused;
+	table[1].data	= &ieee802154_lowpan->fqdir->low_thresh_unused;
 	table[1].extra2	= &ieee802154_lowpan->fqdir->high_thresh;
 	table[2].data	= &ieee802154_lowpan->fqdir->timeout;
 
@@ -451,7 +451,7 @@ static int __net_init lowpan_frags_init_net(struct net *net)
 		return res;
 
 	ieee802154_lowpan->fqdir->high_thresh = IPV6_FRAG_HIGH_THRESH;
-	ieee802154_lowpan->fqdir->low_thresh = IPV6_FRAG_LOW_THRESH;
+	ieee802154_lowpan->fqdir->low_thresh_unused = IPV6_FRAG_LOW_THRESH;
 	ieee802154_lowpan->fqdir->timeout = IPV6_FRAG_TIMEOUT;
 
 	res = lowpan_frags_ns_sysctl_register(net);
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 69c00ffdcf3e..9d72673b048b 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -609,8 +609,8 @@ static int __net_init ip4_frags_ns_ctl_register(struct net *net)
 
 	}
 	table[0].data	= &net->ipv4.fqdir->high_thresh;
-	table[0].extra1	= &net->ipv4.fqdir->low_thresh;
-	table[1].data	= &net->ipv4.fqdir->low_thresh;
+	table[0].extra1	= &net->ipv4.fqdir->low_thresh_unused;
+	table[1].data	= &net->ipv4.fqdir->low_thresh_unused;
 	table[1].extra2	= &net->ipv4.fqdir->high_thresh;
 	table[2].data	= &net->ipv4.fqdir->timeout;
 	table[3].data	= &net->ipv4.fqdir->max_dist;
@@ -674,12 +674,10 @@ static int __net_init ipv4_frags_init_net(struct net *net)
 	 * A 64K fragment consumes 129736 bytes (44*2944)+200
 	 * (1500 truesize == 2944, sizeof(struct ipq) == 200)
 	 *
-	 * We will commit 4MB at one time. Should we cross that limit
-	 * we will prune down to 3MB, making room for approx 8 big 64K
-	 * fragments 8x128k.
+	 * We will commit 4MB at one time. And mark low_thresh be unused.
 	 */
 	net->ipv4.fqdir->high_thresh = 4 * 1024 * 1024;
-	net->ipv4.fqdir->low_thresh  = 3 * 1024 * 1024;
+	net->ipv4.fqdir->low_thresh_unused  = 3 * 1024 * 1024;
 	/*
 	 * Important NOTE! Fragment queue must be destroyed before MSL expires.
 	 * RFC791 is wrong proposing to prolongate timer each fragment arrival
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index d13240f13607..013f16ecdcd1 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -82,10 +82,10 @@ static int nf_ct_frag6_sysctl_register(struct net *net)
 	nf_frag = nf_frag_pernet(net);
 
 	table[0].data	= &nf_frag->fqdir->timeout;
-	table[1].data	= &nf_frag->fqdir->low_thresh;
+	table[1].data	= &nf_frag->fqdir->low_thresh_unused;
 	table[1].extra2	= &nf_frag->fqdir->high_thresh;
 	table[2].data	= &nf_frag->fqdir->high_thresh;
-	table[2].extra1	= &nf_frag->fqdir->low_thresh;
+	table[2].extra1	= &nf_frag->fqdir->low_thresh_unused;
 
 	hdr = register_net_sysctl(net, "net/netfilter", table);
 	if (hdr == NULL)
@@ -500,7 +500,7 @@ static int nf_ct_net_init(struct net *net)
 		return res;
 
 	nf_frag->fqdir->high_thresh = IPV6_FRAG_HIGH_THRESH;
-	nf_frag->fqdir->low_thresh = IPV6_FRAG_LOW_THRESH;
+	nf_frag->fqdir->low_thresh_unused = IPV6_FRAG_LOW_THRESH;
 	nf_frag->fqdir->timeout = IPV6_FRAG_TIMEOUT;
 
 	res = nf_ct_frag6_sysctl_register(net);
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 5bc8a28e67f9..59b3fc8d9e6b 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -465,8 +465,8 @@ static int __net_init ip6_frags_ns_sysctl_register(struct net *net)
 
 	}
 	table[0].data	= &net->ipv6.fqdir->high_thresh;
-	table[0].extra1	= &net->ipv6.fqdir->low_thresh;
-	table[1].data	= &net->ipv6.fqdir->low_thresh;
+	table[0].extra1	= &net->ipv6.fqdir->low_thresh_unused;
+	table[1].data	= &net->ipv6.fqdir->low_thresh_unused;
 	table[1].extra2	= &net->ipv6.fqdir->high_thresh;
 	table[2].data	= &net->ipv6.fqdir->timeout;
 
@@ -536,7 +536,7 @@ static int __net_init ipv6_frags_init_net(struct net *net)
 		return res;
 
 	net->ipv6.fqdir->high_thresh = IPV6_FRAG_HIGH_THRESH;
-	net->ipv6.fqdir->low_thresh = IPV6_FRAG_LOW_THRESH;
+	net->ipv6.fqdir->low_thresh_unused = IPV6_FRAG_LOW_THRESH;
 	net->ipv6.fqdir->timeout = IPV6_FRAG_TIMEOUT;
 
 	res = ip6_frags_ns_sysctl_register(net);
-- 
2.25.1


