Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D91D36AA95
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 04:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbhDZCcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 22:32:05 -0400
Received: from dispatch1-eu1.ppe-hosted.com ([185.132.181.6]:1820 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231502AbhDZCcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 22:32:04 -0400
X-Greylist: delayed 506 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Apr 2021 22:32:03 EDT
Received: from dispatch1-eu1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 4B748165BA4;
        Mon, 26 Apr 2021 02:22:55 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR03-DB5-obe.outbound.protection.outlook.com (mail-db5eur03lp2057.outbound.protection.outlook.com [104.47.10.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id EEB164006C;
        Mon, 26 Apr 2021 02:22:51 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YWVcn7ILhcQKxE4SabS9nJdpTTrJ/xkehvaVOHzQslwZavqwD3h0fUuJeYzct+YSGiKjgKmI/hOrL0Bv8TbutrV1InVq/yuGCBEs54kA7AJho0jfose1eBEJBp7RRTQTf52+yEtZoNtecMx+KKxSQLyxGPr3fAEC5UlCaWXh4AFOn0C4YkLWLW5+9gEpmyiu9RHz1CtZI8iHpCO37qthh4drzYnIeHvtp+UZiX51VkFtqGg0qwSHy0frDj5Nj9J/i6NBBdwn9vzZLkS1J0/dC4ntr1x6j4DOlsy6BNDAIXTFUV4RapFoE62Kv2++B4SRXdh+TlIAerFNABhzX+yGwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RAZApA+fFm+JuNDMB2h8/gtcKrAPXrqgd6SZ8sd6URc=;
 b=HdYS8NedWVr5FzYMLCGjSeWD5RslWXOVI39E0s7r8JcyPSfV9z92dXUF1wT3LTW+O+qlQP98+gHkEFeX84y4CjuXYg1QRsHEuOk1/4nGxBSNKMQxgv9eDhjHteI/D5zkrytmVHZL32pLs84YOuCTb1SmUAUe/7MPYzMHP5kRyDY+0WPR06+SlOw5gpRp/ctm9+hLE+1YGVT/UTBJgGcgiJFvLTayb8aSf+lsNuhkPMJlHJR8J8k0SpCkvwu2dvxhx/EIObEDNa7DRDT8qff+ECafZGsUhU/fT/sSEmXcihYpHiF01xjcg3oO7UPitYu2seRqLLlbY/IlBKetOkfQzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RAZApA+fFm+JuNDMB2h8/gtcKrAPXrqgd6SZ8sd6URc=;
 b=WDhD0OGjfA8z3I7m4f4LFaHqMe6BKwOy57SRjCjLGFC1KCTCpgPJPoWEY8ou4agluW43y/2uVeAOi9dy9GZODM70tDeRi2lhscN5FRqA4UEtDSKWVGVsCHas8zNM/PePWp/7BXtiEN35KL3BexjFNHBGuiWXq1FLbRz1gPmXmIs=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=drivenets.com;
Received: from AM7PR08MB5511.eurprd08.prod.outlook.com (2603:10a6:20b:10d::12)
 by AS8PR08MB5958.eurprd08.prod.outlook.com (2603:10a6:20b:299::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Mon, 26 Apr
 2021 02:22:50 +0000
Received: from AM7PR08MB5511.eurprd08.prod.outlook.com
 ([fe80::1b7:6f71:2dd8:a2b3]) by AM7PR08MB5511.eurprd08.prod.outlook.com
 ([fe80::1b7:6f71:2dd8:a2b3%6]) with mapi id 15.20.4065.026; Mon, 26 Apr 2021
 02:22:50 +0000
From:   Leonard Crestez <lcrestez@drivenets.com>
To:     Matt Mathis <mattmathis@google.com>,
        Neal Cardwell <ncardwell@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        John Heffner <johnwheffner@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Leonard Crestez <cdleonard@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC] tcp: Consider mtu probing for tcp_xmit_size_goal
Date:   Mon, 26 Apr 2021 05:22:29 +0300
Message-Id: <c575e693788233edeb399d8f9b6d9217b3daed9b.1619403511.git.lcrestez@drivenets.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [78.96.81.202]
X-ClientProxiedBy: AM0PR06CA0132.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::37) To AM7PR08MB5511.eurprd08.prod.outlook.com
 (2603:10a6:20b:10d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dnmacvm.dev.drivenets.net (78.96.81.202) by AM0PR06CA0132.eurprd06.prod.outlook.com (2603:10a6:208:ab::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Mon, 26 Apr 2021 02:22:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd43b248-6685-4281-b38d-08d9085a3057
X-MS-TrafficTypeDiagnostic: AS8PR08MB5958:
X-Microsoft-Antispam-PRVS: <AS8PR08MB59584F23D89494154711B749D5429@AS8PR08MB5958.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7tUg642QyVAcNHkhbcZ1jTHZWxIpQhs/lXanXsJMPBgAuImKCo4NM6UU+V56qB/4IqjuPSBoZc6TzQQbawm5zdcuXRIJB/Y/ahE8qp6tHTWmIMvXqaccvW+0j5azCwNo70qmRCOjQcZ9BfL4t2/evSJEQYpxcUGESq4x+Q9S97oJU192/DzWosHcUAAMxGhsb+ikKPrByG6QoIVIfu0b72iMRp399c6kqxWFj+5nRVBt0XHmJ473+hZhImoPsEN9LD6fMWVG+2clu5QyrjYH8V6GoEgxW2dQXqR5W15wZCMjXCyt1WCWHaI7UrrR6r/RZOE3q2SlXizDk9A2auDiXXk0mZfxTuSr+OG+X+tn2RVzRW2ZfBA9WL2fkCpX06n+EMpgx9IKmPIjIH/sEr5LwEESsufcG9hTAW2Mh8cKcQyx5EUvsnQYEMZaVM4orHr1dIXuM2UbvxLyWnA+62y4/NDWvEhL7u/upnUF3qE/vjf9FZL+2yV8+X4BBmarTCTtBFaWKYxHbYVQl3vYYm/PR39UIVlYGOx63bXLwURQamWTGapWFNxPGvMakXj8+ZejvTmkg31xOlHsEWbPSamhIro4bek6yNeSjVaOxbcvvKm40BRkFjt8KiaSTGIeprzyzgazMOrdV00ybsUAU/rhMdsKgVn7BHEIeMCKY3751XVN8IMmFEj1F1AKjdTNsv50unkNQc6YIU9c1Rf7Np2v75wsj3lmqVefD2XdIPeWk5o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR08MB5511.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(39830400003)(396003)(366004)(26005)(52116002)(956004)(66556008)(5660300002)(316002)(6512007)(16526019)(38350700002)(86362001)(6506007)(38100700002)(7416002)(186003)(2906002)(110136005)(6666004)(8676002)(83380400001)(8936002)(6486002)(66946007)(66476007)(36756003)(4326008)(2616005)(54906003)(478600001)(966005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?HQWURVRNsE0H3K0AK7HYKAH4pOyqklx01/QXkjyuogeRnVrKA1bNU+tkl914?=
 =?us-ascii?Q?OSSRsnsxS2HZm//5g8Pkxe/8R0slLy/0kTlyAlPZaCiIRCPCp7NDiC3xT3Bu?=
 =?us-ascii?Q?LHSP3U/V5tnoMNu2oRhaV82B8XnK1rDAROGUaTI36of7bLorMI6byULg+uXq?=
 =?us-ascii?Q?B/ZQskLVBAMTQt3NfPMqluTfTKCyO9lTAsn0SkKt0jo9vpqFlcMnsiWwDFl0?=
 =?us-ascii?Q?v3ggfBdEkwt+UqRafRhHr6L34mm0sEDy5imt6kLf7umQGZE0i/SaO6+KDmx+?=
 =?us-ascii?Q?dfn+awbmNpCaia1XWXVp7WrNFfICNl5rljy8pyYhDUMsCJfEO7XqdiTXjQp0?=
 =?us-ascii?Q?vw/5qk94cDJ8VaZEiXkepVFu7HSOAxqrFgxcEGx/jXVMFUF5GaN2K/b+h6R+?=
 =?us-ascii?Q?Z/pT5Oe9rWxsFznW8BEhHOT5EbZVQQyo4tCUVEW+YOVuSIWPb/dzRCXwifw9?=
 =?us-ascii?Q?sYDo0XHDS4EhYrsSt8UcOsfbrcX5KWD9r/IK2JQW670XAzDk4YeqTQElQiAW?=
 =?us-ascii?Q?y7O1swpdb4jr0vOcgpj27Cyh9lc1hoJUOas5ZaS74mz5ZB0YeXLPcU7E6qwm?=
 =?us-ascii?Q?Qxy3RdEYXh+mJeycC9zNnwM2rMQ6Xx4dp3kOgIb7n3aicMILVoZyv+WGFGNM?=
 =?us-ascii?Q?NtvtL0kNNsTr9ikZhhS613W5QDLUgjvzTIxgQSBO0Cy6ErsK70X5iZaa3BCQ?=
 =?us-ascii?Q?S9x70bdIElrcm2yAA5+rbbgE9zJKzAJtSupZzuzhKatyLRWSI0UeQK25eMhe?=
 =?us-ascii?Q?wCPo99JTwegwor88Fse+3uqLiQehEBVCxboK8wchJSg1H4g8aQCTqDIFSR89?=
 =?us-ascii?Q?lhu1Oram8mdHLRAu6FLduRDCRIaZeAnjCXJuBDR+3yqkorNqGD92Yj2iQdSj?=
 =?us-ascii?Q?tgE6F6pMyh/uZDODRgrW409ULcuENRfZXZ8MX5D6LbiT2DTpLYkz9v+r5evp?=
 =?us-ascii?Q?b5TomgNy2Xmp0Jfqrg+LY2oh7fbjexKIZD0afvhcUQXC7AAWhcay07yfLKBc?=
 =?us-ascii?Q?OUuaR3yC8sOrmuPv5v14Vmz0NIpDTvCabGlfCWdMP2FTBpRCYNMuAvtpUDsw?=
 =?us-ascii?Q?z75NjMmfhnh8oNjr8T78zJFpqJXE66zPMoTdJCivZ4EcARwDPtxer74h+wzw?=
 =?us-ascii?Q?ZDytpatQe3PqwP2KwzO6GDSL0DW2nfIW23JIjI4oe14Cny8nqPWkg3BTtW5M?=
 =?us-ascii?Q?F3UDyX5FCKgXHQPl2rSTZzfcm9+7Up0OTfuvJJY+raI6nInSjhBrj8Ij0RQx?=
 =?us-ascii?Q?5ioOuGSxSO3YD66rivBjN5QEAug1vF872H5vhClVUPUCzK10mLVi6oXOMoxN?=
 =?us-ascii?Q?XKuziWYrQnmECq9aLdpOBncF?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd43b248-6685-4281-b38d-08d9085a3057
X-MS-Exchange-CrossTenant-AuthSource: AM7PR08MB5511.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2021 02:22:50.4034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6shM2dEKsnKfocLMSVIyIAHpiiENtSmtgW3r53WS/mw73IEFYy4VsGI0Mow9DgJjuyUqWudBTGVeQ4Bh/mxp3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB5958
X-MDID: 1619403773-8bMHryy5dVWq
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to RFC4821 Section 7.4 "Protocols MAY delay sending non-probes
in order to accumulate enough data" but linux almost never does that.

Linux checks for probe_size + (1 + retries) * mss_cache to be available
in the send buffer and if that condition is not met it will send anyway
using the current MSS. The feature can be made to work by sending very
large chunks of data from userspace (for example 128k) but for small
writes on fast links tcp mtu probes almost never happen.

This patch tries to take mtu probe into account in tcp_xmit_size_goal, a
function which otherwise attempts to accumulate a packet suitable for
TSO. No delays are introduced beyond existing autocork heuristics.

Suggested-by: Matt Mathis <mattmathis@google.com>
Signed-off-by: Leonard Crestez <lcrestez@drivenets.com>
---
 Documentation/networking/ip-sysctl.rst |  3 +++
 include/net/inet_connection_sock.h     |  7 +++++-
 include/net/netns/ipv4.h               |  1 +
 include/net/tcp.h                      |  3 +++
 net/ipv4/sysctl_net_ipv4.c             |  7 ++++++
 net/ipv4/tcp.c                         | 11 ++++++++-
 net/ipv4/tcp_output.c                  | 33 +++++++++++++++++++++++---
 7 files changed, 60 insertions(+), 5 deletions(-)

Previously:
https://lore.kernel.org/netdev/d7fbf3d3a2490d0a9e99945593ada243da58e0f8.1619000255.git.cdleonard@gmail.com/T/#u

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index c2ecc9894fd0..36b8964abbb3 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -320,10 +320,13 @@ tcp_mtu_probe_floor - INTEGER
 	If MTU probing is enabled this caps the minimum MSS used for search_low
 	for the connection.
 
 	Default : 48
 
+tcp_mtu_probe_autocork - INTEGER
+	Take into account mtu probe size when accumulating data via autocorking.
+
 tcp_min_snd_mss - INTEGER
 	TCP SYN and SYNACK messages usually advertise an ADVMSS option,
 	as described in RFC 1122 and RFC 6691.
 
 	If this ADVMSS option is smaller than tcp_min_snd_mss,
diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 3c8c59471bc1..19afcc7a4f4a 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -123,15 +123,20 @@ struct inet_connection_sock {
 		/* Range of MTUs to search */
 		int		  search_high;
 		int		  search_low;
 
 		/* Information on the current probe. */
-		u32		  probe_size:31,
+		u32		  probe_size:30,
+		/* Are we actively accumulating data for an mtu probe? */
+				  wait_data:1,
 		/* Is the MTUP feature enabled for this connection? */
 				  enabled:1;
 
 		u32		  probe_timestamp;
+
+		/* Timer for wait_data */
+		struct	  timer_list	wait_data_timer;
 	} icsk_mtup;
 	u32			  icsk_probes_tstamp;
 	u32			  icsk_user_timeout;
 
 	u64			  icsk_ca_priv[104 / sizeof(u64)];
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 87e1612497ea..2afe98422441 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -122,10 +122,11 @@ struct netns_ipv4 {
 #ifdef CONFIG_NET_L3_MASTER_DEV
 	u8 sysctl_tcp_l3mdev_accept;
 #endif
 	u8 sysctl_tcp_mtu_probing;
 	int sysctl_tcp_mtu_probe_floor;
+	int sysctl_tcp_mtu_probe_autocork;
 	int sysctl_tcp_base_mss;
 	int sysctl_tcp_min_snd_mss;
 	int sysctl_tcp_probe_threshold;
 	u32 sysctl_tcp_probe_interval;
 
diff --git a/include/net/tcp.h b/include/net/tcp.h
index eaea43afcc97..c3eaae3bf7d6 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -666,10 +666,11 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 void tcp_initialize_rcv_mss(struct sock *sk);
 
 int tcp_mtu_to_mss(struct sock *sk, int pmtu);
 int tcp_mss_to_mtu(struct sock *sk, int mss);
 void tcp_mtup_init(struct sock *sk);
+int tcp_mtu_probe_size_needed(struct sock *sk);
 
 static inline void tcp_bound_rto(const struct sock *sk)
 {
 	if (inet_csk(sk)->icsk_rto > TCP_RTO_MAX)
 		inet_csk(sk)->icsk_rto = TCP_RTO_MAX;
@@ -1375,10 +1376,12 @@ static inline void tcp_slow_start_after_idle_check(struct sock *sk)
 	s32 delta;
 
 	if (!sock_net(sk)->ipv4.sysctl_tcp_slow_start_after_idle || tp->packets_out ||
 	    ca_ops->cong_control)
 		return;
+	if (inet_csk(sk)->icsk_mtup.wait_data)
+		return;
 	delta = tcp_jiffies32 - tp->lsndtime;
 	if (delta > inet_csk(sk)->icsk_rto)
 		tcp_cwnd_restart(sk, delta);
 }
 
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index a62934b9f15a..e19176c17973 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -827,10 +827,17 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &tcp_min_snd_mss_min,
 		.extra2		= &tcp_min_snd_mss_max,
 	},
+	{
+		.procname	= "tcp_mtu_probe_autocork",
+		.data		= &init_net.ipv4.sysctl_tcp_mtu_probe_autocork,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 	{
 		.procname	= "tcp_probe_threshold",
 		.data		= &init_net.ipv4.sysctl_tcp_probe_threshold,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e14fd0c50c10..6341a87e9388 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -913,10 +913,11 @@ struct sk_buff *sk_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp,
 }
 
 static unsigned int tcp_xmit_size_goal(struct sock *sk, u32 mss_now,
 				       int large_allowed)
 {
+	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 	u32 new_size_goal, size_goal;
 
 	if (!large_allowed)
 		return mss_now;
@@ -932,11 +933,19 @@ static unsigned int tcp_xmit_size_goal(struct sock *sk, u32 mss_now,
 		tp->gso_segs = min_t(u16, new_size_goal / mss_now,
 				     sk->sk_gso_max_segs);
 		size_goal = tp->gso_segs * mss_now;
 	}
 
-	return max(size_goal, mss_now);
+	size_goal = max(size_goal, mss_now);
+
+	if (unlikely(icsk->icsk_mtup.wait_data)) {
+		int mtu_probe_size_needed = tcp_mtu_probe_size_needed(sk);
+		if (mtu_probe_size_needed > 0)
+			size_goal = max(size_goal, (u32)mtu_probe_size_needed);
+	}
+
+	return size_goal;
 }
 
 int tcp_send_mss(struct sock *sk, int *size_goal, int flags)
 {
 	int mss_now;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index bde781f46b41..c15ed548a48a 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2311,10 +2311,23 @@ static bool tcp_can_coalesce_send_queue_head(struct sock *sk, int len)
 	}
 
 	return true;
 }
 
+int tcp_mtu_probe_size_needed(struct sock *sk)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+	struct tcp_sock *tp = tcp_sk(sk);
+	int probe_size;
+	int size_needed;
+
+	probe_size = tcp_mtu_to_mss(sk, (icsk->icsk_mtup.search_high + icsk->icsk_mtup.search_low) >> 1);
+	size_needed = probe_size + (tp->reordering + 1) * tp->mss_cache;
+
+	return size_needed;
+}
+
 /* Create a new MTU probe if we are ready.
  * MTU probe is regularly attempting to increase the path MTU by
  * deliberately sending larger packets.  This discovers routing
  * changes resulting in larger path MTUs.
  *
@@ -2366,16 +2379,18 @@ static int tcp_mtu_probe(struct sock *sk)
 		 */
 		tcp_mtu_check_reprobe(sk);
 		return -1;
 	}
 
+	/* Can probe ever fit inside window? */
+	if (tp->snd_wnd < size_needed)
+		return -1;
+
 	/* Have enough data in the send queue to probe? */
 	if (tp->write_seq - tp->snd_nxt < size_needed)
-		return -1;
+		return net->ipv4.sysctl_tcp_mtu_probe_autocork ? 0 : -1;
 
-	if (tp->snd_wnd < size_needed)
-		return -1;
 	if (after(tp->snd_nxt + size_needed, tcp_wnd_end(tp)))
 		return 0;
 
 	/* Do we need to wait to drain cwnd? With none in flight, don't stall */
 	if (tcp_packets_in_flight(tp) + 2 > tp->snd_cwnd) {
@@ -2596,28 +2611,40 @@ void tcp_chrono_stop(struct sock *sk, const enum tcp_chrono type)
  * but cannot send anything now because of SWS or another problem.
  */
 static bool tcp_write_xmit(struct sock *sk, unsigned int mss_now, int nonagle,
 			   int push_one, gfp_t gfp)
 {
+	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
+	struct net *net = sock_net(sk);
 	struct sk_buff *skb;
 	unsigned int tso_segs, sent_pkts;
 	int cwnd_quota;
 	int result;
 	bool is_cwnd_limited = false, is_rwnd_limited = false;
 	u32 max_segs;
 
 	sent_pkts = 0;
 
 	tcp_mstamp_refresh(tp);
+	/*
+	 * Waiting for tcp probe data also applies when push_one=1
+	 * If user does many small writes we hold them until we have have enough
+	 * for a probe.
+	 */
 	if (!push_one) {
 		/* Do MTU probing. */
 		result = tcp_mtu_probe(sk);
 		if (!result) {
+			if (net->ipv4.sysctl_tcp_mtu_probe_autocork)
+				icsk->icsk_mtup.wait_data = true;
 			return false;
 		} else if (result > 0) {
+			icsk->icsk_mtup.wait_data = false;
 			sent_pkts = 1;
+		} else {
+			icsk->icsk_mtup.wait_data = false;
 		}
 	}
 
 	max_segs = tcp_tso_segs(sk, mss_now);
 	while ((skb = tcp_send_head(sk))) {

base-commit: 8203c7ce4ef2840929d38b447b4ccd384727f92b
-- 
2.25.1

