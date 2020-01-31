Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B518714EC70
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 13:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbgAaMYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 07:24:53 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:20169 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728479AbgAaMYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 07:24:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1580473493; x=1612009493;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=QgUb6BnvvX81FwAsK2U7sEWbKCuwBEBk54cVqTZu9s8=;
  b=Dy97uh+xKV5tM6qihuTnMjVISIQOKc49fyxOqpcP4ftao4kwDSH97tEz
   ldaSLupYpDejxDXd4UBDGu/kxKyP3zc+rxRl99brfmeKwpqSegQeslNk5
   U2/1k4JWoHUUMf3ioXAoQFVUKtjKNGFNFBSWHvbz76dSbAzFEWYVkxegj
   M=;
IronPort-SDR: +Jvlb3BG7cY5yLhCjFAC9GmZ+3DpN3kRoqd94Pdp20FL4bzJGD6us5ywlA2jB91Ffwwka32Ckd
 IeSct9F5mNuQ==
X-IronPort-AV: E=Sophos;i="5.70,385,1574121600"; 
   d="scan'208";a="15007143"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 31 Jan 2020 12:24:51 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com (Postfix) with ESMTPS id D6210A2195;
        Fri, 31 Jan 2020 12:24:49 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Fri, 31 Jan 2020 12:24:49 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.162.50) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 31 Jan 2020 12:24:44 +0000
From:   <sjpark@amazon.com>
To:     <edumazet@google.com>, <davem@davemloft.net>
CC:     <shuah@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sj38.park@gmail.com>, <aams@amazon.com>,
        SeongJae Park <sjpark@amazon.de>
Subject: [PATCH 1/3] net/ipv4/inet_timewait_sock: Fix inconsistent comments
Date:   Fri, 31 Jan 2020 13:24:19 +0100
Message-ID: <20200131122421.23286-2-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200131122421.23286-1-sjpark@amazon.com>
References: <20200131122421.23286-1-sjpark@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.50]
X-ClientProxiedBy: EX13D24UWA003.ant.amazon.com (10.43.160.195) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

Commit ec94c2696f0b ("tcp/dccp: avoid one atomic operation for timewait
hashdance") mistakenly erased a comment for the second step of
`inet_twsk_hashdance()`.  This commit restores it for better
readability.

Signed-off-by: SeongJae Park <sjpark@amazon.de>
---
 net/ipv4/inet_timewait_sock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
index c411c87ae865..fbfcd63cc170 100644
--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -120,6 +120,7 @@ void inet_twsk_hashdance(struct inet_timewait_sock *tw, struct sock *sk,
 
 	spin_lock(lock);
 
+	/* Step 2: Hash TW into tcp ehash chain. */
 	inet_twsk_add_node_rcu(tw, &ehead->chain);
 
 	/* Step 3: Remove SK from hash chain */
-- 
2.17.1

