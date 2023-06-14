Return-Path: <netdev+bounces-10852-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C983F7308BD
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 21:47:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F5B7281547
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 19:47:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B364411CAD;
	Wed, 14 Jun 2023 19:47:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A882011C9A
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 19:47:51 +0000 (UTC)
Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F1F1B2
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 12:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1686772071; x=1718308071;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/L7VgazpQ6XYQqfhMXxfQ/IrR1xNxpo81P9tgLwwI9A=;
  b=TF7kW/KoiXNKm4Yta/qKRPPJTyH8X2432HNqhjgCTJ+y7bgBjZsUeqxk
   DuIQ2+JHczOFuW6FuVq86ShDHm66Vgf5Ha/3qMWMK3HjlXzMnBpVBgoKW
   IIyZtUKmI5nLX0Pi7wBNRobKKnrT/TirzXRrOO821IQ0l3n9GfKITjoHP
   s=;
X-IronPort-AV: E=Sophos;i="6.00,243,1681171200"; 
   d="scan'208";a="566628360"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-f05d30a1.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 19:47:49 +0000
Received: from EX19MTAUWA002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
	by email-inbound-relay-iad-1d-m6i4x-f05d30a1.us-east-1.amazon.com (Postfix) with ESMTPS id C84B0804A8;
	Wed, 14 Jun 2023 19:47:46 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 14 Jun 2023 19:47:41 +0000
Received: from 88665a182662.ant.amazon.com (10.187.170.18) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 14 Jun 2023 19:47:39 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC: Kuniyuki Iwashima <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <netdev@vger.kernel.org>
Subject: [PATCH v1 net 1/2] udplite: Print deprecation notice.
Date: Wed, 14 Jun 2023 12:47:04 -0700
Message-ID: <20230614194705.90673-2-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230614194705.90673-1-kuniyu@amazon.com>
References: <20230614194705.90673-1-kuniyu@amazon.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.170.18]
X-ClientProxiedBy: EX19D040UWA002.ant.amazon.com (10.13.139.113) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Recently syzkaller reported a 7-year-old null-ptr-deref [0] that occurs
when a UDP-Lite socket tries to allocate a buffer under memory pressure.

Someone should have stumbled on the bug much earlier if UDP-Lite had been
used in a real app.  Also, we do not always need a large UDP-Lite workload
to hit the bug since UDP and UDP-Lite share the same memory accounting
limit.

Removing UDP-Lite would simplify UDP code removing a bunch of conditionals
in fast path.

Let's add a deprecation notice when UDP-Lite socket is created and schedule
its removal to 2025.

Link: https://lore.kernel.org/netdev/20230523163305.66466-1-kuniyu@amazon.com/ [0]
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/udplite.c | 2 ++
 net/ipv6/udplite.c | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/net/ipv4/udplite.c b/net/ipv4/udplite.c
index 56d94d23b9e0..143f93a12f25 100644
--- a/net/ipv4/udplite.c
+++ b/net/ipv4/udplite.c
@@ -22,6 +22,8 @@ static int udplite_sk_init(struct sock *sk)
 {
 	udp_init_sock(sk);
 	udp_sk(sk)->pcflag = UDPLITE_BIT;
+	pr_warn_once("UDP-Lite is deprecated and scheduled to be removed in 2025, "
+		     "please contact the netdev mailing list\n");
 	return 0;
 }
 
diff --git a/net/ipv6/udplite.c b/net/ipv6/udplite.c
index 3bab0cc13697..8e010d07917a 100644
--- a/net/ipv6/udplite.c
+++ b/net/ipv6/udplite.c
@@ -8,6 +8,8 @@
  *  Changes:
  *  Fixes:
  */
+#define pr_fmt(fmt) "UDPLite6: " fmt
+
 #include <linux/export.h>
 #include <linux/proc_fs.h>
 #include "udp_impl.h"
@@ -16,6 +18,8 @@ static int udplitev6_sk_init(struct sock *sk)
 {
 	udpv6_init_sock(sk);
 	udp_sk(sk)->pcflag = UDPLITE_BIT;
+	pr_warn_once("UDP-Lite is deprecated and scheduled to be removed in 2025, "
+		     "please contact the netdev mailing list\n");
 	return 0;
 }
 
-- 
2.30.2


