Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5124F6BF0
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 22:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235250AbiDFVBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 17:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234879AbiDFVBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 17:01:21 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2086.outbound.protection.outlook.com [40.107.20.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A64B1F6209;
        Wed,  6 Apr 2022 12:30:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dIdbr2Kk/9y287AAmxUzGbwQ6d6OZHW9ldbJwby3UF3/wXNysbSMM70m5Gli1K0TIxKenihnip4O1Z21cm67i/aA52C9O/2oKT2TifQMcqh24h4W1Gnu0dzKpQsuWDTPZRJvurZAZ5qlsnJ2IpDll8t0ggKoYDls4QsO1S5+2GsN6e1+2rYRzmCvpkZevoCl78IG90HGU/cLrAhvWv/C/FTx4mikw4wKz69ZVt8YWmweHuLSOkY9ZW3+AEnhMQMFtL5jdriRMs6IWTcPNgAx7CpdlQMjL54zdrObE0xUbpacAhV2u6JkGLDmkVVd+Nc/s7A5sZyiIfA/DIPpKqRUWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Dfvk8kjhA4RZ/ShX8AgrNIDmXj8uhuNjOnAGvO27Lw=;
 b=Pse6JdCK2AAzwenJxOYXKrU5uR0THTZx2emVt54PCe0xyOSI1vCcHj68kmt8000UokM8qi/zz8TmnyPvop8WZ6mxZMEJOG/GqR54sKDK2X0aAE6rPx0KCi/ZVCRs7g4afO0b7oYT/+84S1mdcerDug7e0mrTKwgDLAaiPJoHbSD/JxPPdYX3YhvcLgshcDyErbc7XgDMH2gt13SUwfduN42vaTAxuZ3ZZYmHm4j1q7Doiqld7cx9QfEe56I4J6Mu81LEQqwthXtKZXtTT4n/Mbn6LX7b8AK9tpW9KbDc97lb0h2vzAWeswhTcUonwhrFBDWiySzdCWlLJUwhPpEcGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Dfvk8kjhA4RZ/ShX8AgrNIDmXj8uhuNjOnAGvO27Lw=;
 b=lnjw+qB0iS6AJCK0/khwi9MEpz+5/lwq4P50NAEUr1tW0KDhPgw7DmN2HefBHyBscexzn4/NanTliUGgr0L5VusI6pf47g6wixfbb70K7FkLdCChCrAxaThL7nAV9DHrIyMFr3XYn38Uzf0MPQl3b0Z2tOPzIj96bSj7saaw0Wo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5487.eurprd04.prod.outlook.com (2603:10a6:803:d1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.19; Wed, 6 Apr
 2022 19:30:19 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 19:30:19 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH 4.14 1/2] ipv6: add missing tx timestamping on IPPROTO_RAW
Date:   Wed,  6 Apr 2022 22:29:54 +0300
Message-Id: <20220406192956.3291614-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220406192956.3291614-1-vladimir.oltean@nxp.com>
References: <20220406192956.3291614-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR1001CA0069.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::46) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87547ad0-383c-4c8b-1eba-08da1803e2b5
X-MS-TrafficTypeDiagnostic: VI1PR04MB5487:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB5487568539846D1351F5EBFAE0E79@VI1PR04MB5487.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g1jsobDgCW/G/WS0RM5o9dxgmCzPXM/8fueDExKYuy5SNB3YYHPwLawt/V5O4c9HlhjnxNEvF3xxEpcFxyQ+gRpLfyiuUIrvGwBOkKh+WY+dR7sJkJ95S6plF7V97IQTTqOoHZ/8ms/95u0jQlfgUQzr2b5zED0E3LO0r5qCOkHNSy2MJT7/LNFqESp6t3XhoRCLncXuYnM1zfTb4UuVztEP6lbjQH3ohWFnoXgh9gf1HDkgy9pCL+qbw27JNnugQad8yKUoNt8X+PWugNQquwWNX4MHk84aDZ179nZ6R2pvOvaao3LUH9HPvgm4z94dHjmajXMI6SJhOHfHur2JqtZgg4DpGCSVVrO4MmhyEF68zP/RBN1qx7RoBlCXwzGqSvYEy2vQVjgMFLhePCevUHukNBUzZtIjARHIS6CAr2Fd47h1yF7nJ1cHmvEHzk0EF74P6HQeq/NlqD1XJyhegrHVkwz+pXwnPaodlHHJrcHy3hTr167jHvDBuXnheorcHO5hOxQqW39TRHC5HOH1VZUJ/a1PI5Ny9DP9lv98jl5XgMAs4E19Fa+TxRZkzJCvc2yHdMxkycH0CkjwEs0QPCWrrZuJCFTFTKgbA7DxVx1hMkn3pQpoXiJdJnIugT6DR5AQIa5pb8DpI1aKg4zpHbGriYUsUwS648m6NkjRUgxcZJHohCvgD4GCuGqVK7swXWM1ubTn0Fy2/bOx2GcSoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(86362001)(2616005)(316002)(8676002)(66556008)(66476007)(38350700002)(1076003)(6506007)(38100700002)(66946007)(4326008)(6666004)(186003)(110136005)(54906003)(2906002)(508600001)(26005)(6486002)(8936002)(52116002)(83380400001)(36756003)(5660300002)(7416002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3WpQucLYsddugS89GKHZVy5fJqt8xIcKAVG8QZRtOCnQLND4Qdxr4RpY0Sem?=
 =?us-ascii?Q?DBRlqWALjtHe+PPS5SBxrVRPIbV3VsVezpG378YM8hbwksKcRAlnezMIdJHq?=
 =?us-ascii?Q?LFnZDm+YI58E2JNwssFOiRFOSc4ptUyRD1VZJDoHz0XtdRNcwO4FkqU1Xa8H?=
 =?us-ascii?Q?KXRvVZiR2OFdizwTP1Txm/CORLscHRjUfYuPmS/vCiYazatRTYS7KSsbk/OA?=
 =?us-ascii?Q?KfCRcT5uu10MCwGBTzhjpsYQERmDI8R8G8QYr4svsv2uSdkNd/e0+Fvg2SJo?=
 =?us-ascii?Q?k6WjliCnv9AeJvbSAAtjZONdBDJ8zTWYDbq6HsE0P3+zteCKt+aYw/6OfZkj?=
 =?us-ascii?Q?PLEwyqqoQXSTm7C6AWUUvETyev3ENFerPl1nSn8XIRrLlrhuJ87ZAXTFLVRJ?=
 =?us-ascii?Q?tIkyJo/NJ1f7SLWkb2aziizwXTuF0PFAHNwRGow/5StBTxivPH2nBc6ZRl14?=
 =?us-ascii?Q?OWKR6t+DX3y+61ZxLK8mURcpeGcl2Oi1nR3JM8d13gA4Aa+u3iJXjrqF8JOQ?=
 =?us-ascii?Q?tYmoe/M+wj5tAuzfFw8VERBaGJVnbviErx8Zp/1G9QhkPlauyQqlYBuK2GC4?=
 =?us-ascii?Q?7IBcEv49eQ3/nW0sCay5oxoBbSQOQoB4lKr1eHMvMrWe89dEITt7wkbIbvkk?=
 =?us-ascii?Q?Li+ORSskhQ69pHDT10e4/kggcbvP8Jrja9IGTY74jM88iNkM1ViBUWyCmqh3?=
 =?us-ascii?Q?abUoAHiy9K7NzFP6hsqccGhNdMUctJChjWbNo9w+upc84YYjalgkhR6MuBqa?=
 =?us-ascii?Q?cfVPuMBql+cwpaXpptnMVCUlC5jNbIacG9BqepKiisflFdY3p5Uj3o/hO1bY?=
 =?us-ascii?Q?pNs9PeKbcl0rTNF4PmnrK23AFBHK3ePSpUr33PLrFi+nTR1RPUbT8JoQ0c0m?=
 =?us-ascii?Q?CMv5dWXDClpwx4LQB7xvDD7I1jsAj5g34NccTABaMYZK6GiuIGMu41XAoE0l?=
 =?us-ascii?Q?N1DAq2ykCoXUf1sGkPCr8ay38LzBRn6ZIIVK4u+zYs4KL7rxE5AXQWVVU8jW?=
 =?us-ascii?Q?Z+Qq3cEGcbveQ8liPGL/KrBNmY10E15NDLF2y68yQVR6KVpfV5+7VL1nmdR+?=
 =?us-ascii?Q?sxlQSzfuLw6Bfk9wXZ8OKN0Suda4DTf3ywp0fo8j62yhVdS2NSROA/i5hdc3?=
 =?us-ascii?Q?6ty/vg/TPEu1KwY9z9p0Mq76gp7Bb4f2NSJaD8qJVJNYpw3UOLzEPwJJhkcT?=
 =?us-ascii?Q?4UYN1vujYJTiGb/EMBraUwwrAFuxD0s7m6Jwd0MC0mzl0WDSDVvh36YBjORU?=
 =?us-ascii?Q?JNrbNUgkpzKG3PHN2Xnc0tyK0bxjUT9Pn9NbZ8kX4ppnlFm0PTy4Z0CV3aV9?=
 =?us-ascii?Q?FkWuPZMKZiqH+1JSRo/xMZLsV6NL9LuxHP5Baahx89k7DW9ofzdu/NNTuTl3?=
 =?us-ascii?Q?75/8/Mm8j4XzXusJ1oqOj6UOsmJ0oHwqzvPy0fNzQ1XGhUFqDRcq8QqRIsTt?=
 =?us-ascii?Q?uerIjhQc9f+5xKhyD8IzewdcRkfUVs3CYhvwnOVCrNKemAV1VU4SelFr6eEj?=
 =?us-ascii?Q?45eoxz00F4rugqdrJ/6Y54uMHLqkMMMm9o4VXuijhYDby8STPvDZokr8yfvu?=
 =?us-ascii?Q?39RJt8l2xf8tZPf7h4YgQJORz0/4koxEtdoFq7KdkbUDJMhqPqnZt24eXXHw?=
 =?us-ascii?Q?hHK2nvbY7ri0Gsmu6p/Lu9DVQ2YowuwUJ5D7/6vaoCm91M2cDFTRh7eza6Y3?=
 =?us-ascii?Q?A1Hf7FrW+Ra/j7CIPZiRk1yNqRjAS6zxWXBbiwHgVYvSBhIhS5DHOEmIBDRX?=
 =?us-ascii?Q?HaTuJAdQ000xXr6Qyy3PdSOCl4omNcg=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87547ad0-383c-4c8b-1eba-08da1803e2b5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 19:30:19.5554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RizKYAnDkz8hjnqAM3rXcqmzbGqMNEY6CeEbDnP10KbWy7dIM+8ZalyjYLS2/lWTYzY0F5h6T5RYu1Tm4H3ASA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5487
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit fbfb2321e950918b430e7225546296b2dcadf725 ]

Raw sockets support tx timestamping, but one case is missing.

IPPROTO_RAW takes a separate packet construction path. raw_send_hdrinc
has an explicit call to sock_tx_timestamp, but rawv6_send_hdrinc does
not. Add it.

Fixes: 11878b40ed5c ("net-timestamp: SOCK_RAW and PING timestamping")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/ipv6/raw.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 3d9d20074203..f0d8b7e9a685 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -622,7 +622,7 @@ static int rawv6_push_pending_frames(struct sock *sk, struct flowi6 *fl6,
 
 static int rawv6_send_hdrinc(struct sock *sk, struct msghdr *msg, int length,
 			struct flowi6 *fl6, struct dst_entry **dstp,
-			unsigned int flags)
+			unsigned int flags, const struct sockcm_cookie *sockc)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct net *net = sock_net(sk);
@@ -659,6 +659,8 @@ static int rawv6_send_hdrinc(struct sock *sk, struct msghdr *msg, int length,
 
 	skb->ip_summed = CHECKSUM_NONE;
 
+	sock_tx_timestamp(sk, sockc->tsflags, &skb_shinfo(skb)->tx_flags);
+
 	if (flags & MSG_CONFIRM)
 		skb_set_dst_pending_confirm(skb, 1);
 
@@ -945,7 +947,8 @@ static int rawv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 back_from_confirm:
 	if (hdrincl)
-		err = rawv6_send_hdrinc(sk, msg, len, &fl6, &dst, msg->msg_flags);
+		err = rawv6_send_hdrinc(sk, msg, len, &fl6, &dst,
+					msg->msg_flags, &sockc);
 	else {
 		ipc6.opt = opt;
 		lock_sock(sk);
-- 
2.25.1

