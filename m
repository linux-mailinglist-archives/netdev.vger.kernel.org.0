Return-Path: <netdev+bounces-10853-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C7847308BE
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 21:48:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57BDC281552
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 19:48:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91DAC11CB0;
	Wed, 14 Jun 2023 19:48:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CDC2EC11
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 19:48:15 +0000 (UTC)
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A10ADC
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 12:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1686772094; x=1718308094;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iidJqSAvNnrJdpqpSeOqORjtJbqaWg1odczibQj/eXg=;
  b=Z+kQClwT9O+pp8QJm0SKB0KjfTMNjSV/65fAhUBnh22zePrbdYJLcgGm
   JdoiSvqLHv8ZAgX5ZRQeHbCAylfFp1pPlvWelImc5E61tUHhermWYfIlU
   APfhbLHlTVypZbaWoHoKuVREjPoZSX2Ei9aPdGdi6qBmJ7Lmxl9Kz5J9f
   g=;
X-IronPort-AV: E=Sophos;i="6.00,243,1681171200"; 
   d="scan'208";a="1137574294"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-9fe6ad2f.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 19:48:08 +0000
Received: from EX19MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
	by email-inbound-relay-iad-1a-m6i4x-9fe6ad2f.us-east-1.amazon.com (Postfix) with ESMTPS id 4BFF5808FA;
	Wed, 14 Jun 2023 19:48:06 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 14 Jun 2023 19:48:05 +0000
Received: from 88665a182662.ant.amazon.com (10.187.170.18) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 14 Jun 2023 19:48:03 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC: Kuniyuki Iwashima <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <netdev@vger.kernel.org>
Subject: [PATCH v1 net 2/2] dccp: Print deprecation notice.
Date: Wed, 14 Jun 2023 12:47:05 -0700
Message-ID: <20230614194705.90673-3-kuniyu@amazon.com>
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
X-ClientProxiedBy: EX19D046UWB001.ant.amazon.com (10.13.139.187) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DCCP was marked as Orphan in the MAINTAINERS entry 2 years ago in commit
054c4610bd05 ("MAINTAINERS: dccp: move Gerrit Renker to CREDITS").  It says
we haven't heard from the maintainer for five years, so DCCP is not well
maintained for 7 years now.

Recently DCCP only receives updates for bugs, and major distros disable it
by default.

Removing DCCP would allow for better organisation of TCP fields to reduce
the number of cache lines hit in the fast path.

Let's add a deprecation notice when DCCP socket is created and schedule its
removal to 2025.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/dccp/proto.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index a06b5641287a..b0ebf853cb07 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -191,6 +191,9 @@ int dccp_init_sock(struct sock *sk, const __u8 ctl_sock_initialized)
 	struct dccp_sock *dp = dccp_sk(sk);
 	struct inet_connection_sock *icsk = inet_csk(sk);
 
+	pr_warn_once("DCCP is deprecated and scheduled to be removed in 2025, "
+		     "please contact the netdev mailing list\n");
+
 	icsk->icsk_rto		= DCCP_TIMEOUT_INIT;
 	icsk->icsk_syn_retries	= sysctl_dccp_request_retries;
 	sk->sk_state		= DCCP_CLOSED;
-- 
2.30.2


