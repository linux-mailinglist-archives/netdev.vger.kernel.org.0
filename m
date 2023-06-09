Return-Path: <netdev+bounces-9604-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 753B772A022
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:26:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 70FEE1C210AE
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:26:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A0B5200CB;
	Fri,  9 Jun 2023 16:26:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C92E19509
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 16:26:22 +0000 (UTC)
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021015.outbound.protection.outlook.com [52.101.57.15])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524752D5F;
	Fri,  9 Jun 2023 09:26:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G0LgF3mSiJNAmfhUIPmpxLnB1Q12XrfbMGPa4COf2Wx9P5x0hDMGrse13gkQrAauoN6HtQrTAHLsNJWxxmCh0ZoQx/bmZtKdL3huxyW0aONRc8t6WGNSKEEKq/rT9vsOlu7M9v/nu+rTFk+e0jYyS3uXziDl6piOJj17gyuA9QgTCKB6GtBy8z6P5sNcfSGFDLC5zsj+r1ywdqPHIOIbPDN29TBRVb7r6omJopzEq614me/Fw80s1pn6uE+wDDR+DygMcrkRsilA3e4m4g8zXoeJjwdoybCghnqXFeZK4piAvvxN5UZB/zftOdTAr6fTLY9aKNyXgL/9v+scNP1P2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w5bfv1H+CGDfbkwZ2cBIh4gyavf+5rvdrsvjYmkXPcQ=;
 b=UbSHC2S4qEpv2orM7/fqdeTuV/rFurX6AfUmJPBnhEnbt/0LvLVIVp5VxgESJ8BK7UenevwWBYav8rLfGdSp3FaJN+hOOqw8B7Njtr4m7CsyRiHacqXrQP06I41SkIJ7pnFFyM72NEeo6SOS08necWVDb7SxPAY7wjvdNu0UyCdfmb12JNOVbXwebq5IVVEcAHaf9dVc9xUCrnY741lTU4b8YMm/iq70UfBB/O8ZWxMWy7YFYckj+BBmGRNTYBY65BugM2bMOZ0/3yFnZ6x3u/wHIMCUhB3GAMcrcTe8s4AyoYUqnRMeJHciQxgoSdIQogbB2KzAO40Td4ievAZxUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w5bfv1H+CGDfbkwZ2cBIh4gyavf+5rvdrsvjYmkXPcQ=;
 b=ESD3q6mug2xhtm8HdsTQDxE092V7RGn3UbAWxDyaDsrKHerKX2NiYuPh8x61pfYD+THdCy4ckUlKpXSUHnpT4Teux0HsZrnGhv2Lzcp4uK44kS7HywYXoJrBCoDgb0TxoE8Wih5KlIQto6LghytN2kbi5aaWoS94kih8vqisGns=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BY5PR21MB1443.namprd21.prod.outlook.com (2603:10b6:a03:21f::18)
 by BY5PR21MB1474.namprd21.prod.outlook.com (2603:10b6:a03:21f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.15; Fri, 9 Jun
 2023 16:26:18 +0000
Received: from BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::4eff:a209:efda:81d4]) by BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::4eff:a209:efda:81d4%6]) with mapi id 15.20.6500.016; Fri, 9 Jun 2023
 16:26:17 +0000
From: Haiyang Zhang <haiyangz@microsoft.com>
To: linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org
Cc: haiyangz@microsoft.com,
	kys@microsoft.com,
	olaf@aepfle.de,
	vkuznets@redhat.com,
	davem@davemloft.net,
	weiwan@google.com,
	tim.gardner@canonical.com,
	corbet@lwn.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	dsahern@kernel.org,
	atenart@kernel.org,
	bagasdotme@gmail.com,
	ykaliuta@redhat.com,
	kuniyu@amazon.com,
	stephen@networkplumber.org,
	simon.horman@corigine.com,
	maheshb@google.com,
	liushixin2@huawei.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next] tcp: Make pingpong threshold tunable
Date: Fri,  9 Jun 2023 09:25:59 -0700
Message-Id: <1686327959-13478-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0294.namprd04.prod.outlook.com
 (2603:10b6:303:89::29) To BY5PR21MB1443.namprd21.prod.outlook.com
 (2603:10b6:a03:21f::18)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR21MB1443:EE_|BY5PR21MB1474:EE_
X-MS-Office365-Filtering-Correlation-Id: 27637225-4df6-4cde-43f0-08db69064010
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 lCMfJfrt4VmHW74gLSp7kFMWk/ytLG43jidsRrgnfrEX+NUsHPZPqzYtyKYoq5OE+z8PCWJq9tDtS6+GekskppA+SUOz+9/nZq4NqNa4GgCvyxinby1qp9qCZUJELyDaYOTsK1Ud7PBUAylDPrOg1ldA4opTFiIIT1geSZrQHLSMqFwU8SGsCLgPf2DhoS7iAhuy5mHb5GYCvkrk6IVJLS3pIAD4ae/q31aXJwiIodtKah+U3knSDhmacJWhgglJbk/wDd++2LCZXmcw4BKBMhrz0O2LjUGDleSVHHvsPzn3AsXPlK8k28C8kl1zWFqmuFicCLNvZfAJoxHkWxXUe/vqzq7tW38gofchGsKWo37QkgkFdTCtvT61IrxA8cn7VGKvpA6d98n1tRgCCNhbrovZ34Q1Ar+20dIQZjrN6jgeO4dq+bdqwPjocKhFs59NyKaAHa0J6qWEYaPdQE4os85/qhXUBYHU7aTE0mByay7K4ISET33MQ9tD7nvjTWQUZ1WHHKLawOJQ+cTYMfY2vYdkOIXnmSPHs7lNbQbPVoVEZjqi9cd22ggv6hROfp1AxfcOdzE/5/ZcRuc7egDSl5M2LEHwo9OAh1QRnWo5SWWEC1lrSIkaKd7fEYPha7CaX5L1ch4vm8+enNQn3Tcs/2clPVOzsQfzsqkdRMkvlFw=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1443.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(39860400002)(396003)(346002)(366004)(451199021)(8676002)(8936002)(478600001)(10290500003)(7846003)(6666004)(41300700001)(5660300002)(4326008)(316002)(6486002)(52116002)(6506007)(6512007)(26005)(186003)(7416002)(66556008)(66476007)(66946007)(2616005)(2906002)(83380400001)(38100700002)(38350700002)(82960400001)(82950400001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?6/3+KJxF+NpZx41J5hrmfAV6+CRz77iRmpN1ApA1zxoLVUQirrsKMzX0eSyq?=
 =?us-ascii?Q?Jd2mgAmoMNMrhrRrfC7tMQdewVLzy+5R2JTjO1U6quJWkkQ26GlrOR3FIK0G?=
 =?us-ascii?Q?q6FKril6XCHr8qL0qwYwQhQr0MCLN19KrhDvEuKk60Oj188kafYuBWL0D9Uj?=
 =?us-ascii?Q?uh7Y5bL397rXOUK4jOaJnNrpC8UMiLFi5SBz2xKdnggyb6ZQk9dqo/+HVPjQ?=
 =?us-ascii?Q?L1Rw4leEtK2gCgO3/RJoufYd1tw0xqaad0SP2Bzqqlaj+8uxNu8ixY30mA3P?=
 =?us-ascii?Q?9hpNhh/lcyE4VRGeDAXdAz+bPipOlNAhkLex/He6Zn//l862rFzAMN9+o6uF?=
 =?us-ascii?Q?/K6W5aY4B8Bsxee0J3snbtx2RHM/fJGsXV2JZgJrmG1S+bSWROgMDbR8uXJE?=
 =?us-ascii?Q?7wmNKSJAVd5V5cYEsc5GtZJ3XyxoBxxLQUHnOftEfsx7S3SQ7Bf8OULqLLx0?=
 =?us-ascii?Q?dMsgpuMf31JoaHfNNty5U3YxceQZxqVuCT9GQAGz45PTfRNdINzO6GvyF8Cd?=
 =?us-ascii?Q?SUUEiU/8nwhImDKADme5dd+XDlj6AxXgMIkAsOfKQwE1mlcxCR/R5sv6c5uZ?=
 =?us-ascii?Q?JcV/qgooDEbac0AnB7XA99ND1mHmnbTLGRKaMpeujchLMG7XXujJP601UHBh?=
 =?us-ascii?Q?TP4OT9TxDtv27N9UDf2jxs2tXvs8wJbUyhqzHDYuTf8NsyIzWxoKqWb8lGDa?=
 =?us-ascii?Q?mTJGozcBfeDqIQ8yMjqE9PyjOR7HlbnA5BixkR2AcvgemkXsPJ59El87zRRr?=
 =?us-ascii?Q?23vgNlikbPEbozTIPgKoupYTwLmkc3mU9ed6cU9vHW+7WoPot5q+yT0zL5y0?=
 =?us-ascii?Q?s4BTyMzeWNyoSFIfXg5WgBZYOMt0C/lnWpqVoKwyXKR510t5Fpcz4f2HPINk?=
 =?us-ascii?Q?N8cVwv6/liIF6Bc+zqM2nI6FxFBEk2D5Yt3Ca8xCrdoKEKaC+Nug8hb32qB5?=
 =?us-ascii?Q?HG8Bf2YK1V50BV/gK4jlA4Gpvbi/FDITmO8QBVYaJpzIf3cBPYgG52pjkgvr?=
 =?us-ascii?Q?40httRdTJypdTFw03tYBedLr8iLOMyZbz+4VZDgHQyATlzX6fVOKt5lpxQg6?=
 =?us-ascii?Q?g3oEx273NYZY8QGbYNOwoFuvVVZDwWR+wUnfXCCU3+rW9cK1vI0IHsknkQ95?=
 =?us-ascii?Q?Snf4jhec9ly+p/i62SN+SR2rdSqknoY/4ZLX8TSpAPjOr75+8m/E40ysqqGP?=
 =?us-ascii?Q?G7MZspxKBHub7FYZksUahhxjsZQpWcLqLehCz2+QVuPihOT1AA+VV+VVxLGM?=
 =?us-ascii?Q?KNUFc2XfjNjA6RZ+yf5LiUrXBzVEGSEgXeTNldnfG/7XCHu20JzT2WrNzwNK?=
 =?us-ascii?Q?lPB4NRbzoZF5f/mZXkFM3DAMIyUmMAFt9hs+KgjoUPNj30UHzjhPDN8Uh6nU?=
 =?us-ascii?Q?lLxa02yHIXRiTO0OEDVQoD126LPp4b2iQrT3TWf52ko6qdSluvWyAjlKAZYs?=
 =?us-ascii?Q?y3/GPgDk6EJcXfwM3yj5pzyepqT5+aQpQZKtPrC5LxX7kuWTOGdwiujWAJjQ?=
 =?us-ascii?Q?LVMtRkGjSY2fgn/+I6+ZLQhXoPvO5GY7QDkrDMB+mClTmCb8M72ZRHFXp1Zk?=
 =?us-ascii?Q?8zoOxZdoLMSEdDPtqvX54NadtUJyrjSiQW1TxI/1?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27637225-4df6-4cde-43f0-08db69064010
X-MS-Exchange-CrossTenant-AuthSource: BY5PR21MB1443.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 16:26:17.8406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9RHwuWVAAVbpUVo4zgg/QneIlPre0cXcCBGkvEvy1yDKUoE5aRKQmeBRiNF/oiogOGI8ucIUdqeyvX1IjYTXWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR21MB1474
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

TCP pingpong threshold is 1 by default. But some applications, like SQL DB
may prefer a higher pingpong threshold to activate delayed acks in quick
ack mode for better performance.

The pingpong threshold and related code were changed to 3 in the year
2019, and reverted to 1 in the year 2022. There is no single value that
fits all applications.

Add net.core.tcp_pingpong_thresh sysctl tunable, so it can be tuned for
optimal performance based on the application needs.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 Documentation/admin-guide/sysctl/net.rst |  8 ++++++++
 include/net/inet_connection_sock.h       | 14 +++++++++++---
 net/core/sysctl_net_core.c               |  9 +++++++++
 net/ipv4/tcp.c                           |  2 ++
 net/ipv4/tcp_output.c                    | 17 +++++++++++++++--
 5 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index 4877563241f3..16f54be9461f 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -413,6 +413,14 @@ historical importance.
 
 Default: 0
 
+tcp_pingpong_thresh
+-------------------
+
+TCP pingpong threshold is 1 by default, but some application may need a higher
+threshold for optimal performance.
+
+Default: 1, min: 1, max: 3
+
 2. /proc/sys/net/unix - Parameters for Unix domain sockets
 ----------------------------------------------------------
 
diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index c2b15f7e5516..e84e33ddae49 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -324,11 +324,11 @@ void inet_csk_update_fastreuse(struct inet_bind_bucket *tb,
 
 struct dst_entry *inet_csk_update_pmtu(struct sock *sk, u32 mtu);
 
-#define TCP_PINGPONG_THRESH	1
+extern int tcp_pingpong_thresh;
 
 static inline void inet_csk_enter_pingpong_mode(struct sock *sk)
 {
-	inet_csk(sk)->icsk_ack.pingpong = TCP_PINGPONG_THRESH;
+	inet_csk(sk)->icsk_ack.pingpong = tcp_pingpong_thresh;
 }
 
 static inline void inet_csk_exit_pingpong_mode(struct sock *sk)
@@ -338,7 +338,15 @@ static inline void inet_csk_exit_pingpong_mode(struct sock *sk)
 
 static inline bool inet_csk_in_pingpong_mode(struct sock *sk)
 {
-	return inet_csk(sk)->icsk_ack.pingpong >= TCP_PINGPONG_THRESH;
+	return inet_csk(sk)->icsk_ack.pingpong >= tcp_pingpong_thresh;
+}
+
+static inline void inet_csk_inc_pingpong_cnt(struct sock *sk)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+
+	if (icsk->icsk_ack.pingpong < U8_MAX)
+		icsk->icsk_ack.pingpong++;
 }
 
 static inline bool inet_csk_has_ulp(struct sock *sk)
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 782273bb93c2..b5253567f2bd 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -653,6 +653,15 @@ static struct ctl_table net_core_table[] = {
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 	},
+	{
+		.procname	= "tcp_pingpong_thresh",
+		.data		= &tcp_pingpong_thresh,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ONE,
+		.extra2		= SYSCTL_THREE,
+	},
 	{ }
 };
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 53b7751b68e1..dcd143193d41 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -308,6 +308,8 @@ EXPORT_SYMBOL(tcp_have_smc);
 struct percpu_counter tcp_sockets_allocated ____cacheline_aligned_in_smp;
 EXPORT_SYMBOL(tcp_sockets_allocated);
 
+int tcp_pingpong_thresh __read_mostly = 1;
+
 /*
  * TCP splice context
  */
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index cfe128b81a01..576d21621778 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -167,12 +167,25 @@ static void tcp_event_data_sent(struct tcp_sock *tp,
 	if (tcp_packets_in_flight(tp) == 0)
 		tcp_ca_event(sk, CA_EVENT_TX_START);
 
+	/* If tcp_pingpong_thresh > 1, and
+	 * this is the first data packet sent in response to the
+	 * previous received data,
+	 * and it is a reply for ato after last received packet,
+	 * increase pingpong count.
+	 */
+	if (tcp_pingpong_thresh > 1 &&
+	    before(tp->lsndtime, icsk->icsk_ack.lrcvtime) &&
+	    (u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato)
+		inet_csk_inc_pingpong_cnt(sk);
+
 	tp->lsndtime = now;
 
-	/* If it is a reply for ato after last received
+	/* If tcp_pingpong_thresh == 1, and
+	 * it is a reply for ato after last received
 	 * packet, enter pingpong mode.
 	 */
-	if ((u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato)
+	if (tcp_pingpong_thresh == 1 &&
+	    (u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato)
 		inet_csk_enter_pingpong_mode(sk);
 }
 
-- 
2.25.1


