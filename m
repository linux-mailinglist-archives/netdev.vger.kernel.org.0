Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D91839151C
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 12:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234083AbhEZKkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 06:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234037AbhEZKkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 06:40:20 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB67C061756;
        Wed, 26 May 2021 03:38:47 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id u4-20020a05600c00c4b02901774b80945cso186394wmm.3;
        Wed, 26 May 2021 03:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YZpXkJ34CAHAUHDFaJtbjNc7wnXsmsycKj1vjs1tXaA=;
        b=ZJvAd//IGF0ZmqI6h1gV53q0j8hcDvw5C6XiwXM6tez/g5DjDV9h8zl1pd5y6pNMR5
         CeIlziAGprCe0TqVZfDSsKdA77PC8Gj0Hp/25evMlah8XdQJSmzIDH0P1pB9GPAgI5fA
         Pi0AirJLi9RUdSBvn2RJL6XL7duZLJZ7j4tGEH6UET3v7Bn08/T0PhF6OJ1cz+/lz4yv
         yZa1bVefYVdvP9Mzx1F76es/bNshrB/H0WtUlskfYJu3WjU7A9czGsvsqIpSlDTcK0wP
         st6MtEXZD7zyhXjTtU28zIt4xzPZrwJx3hqsHniGhyLmtnYDWX062ZJdariKyxEAEYih
         DNCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YZpXkJ34CAHAUHDFaJtbjNc7wnXsmsycKj1vjs1tXaA=;
        b=CISapkqylFEDNwvIocUfDcAMX5SCtmynRwkpIisRFKUVdee54txsePkK3JuXeRyO7k
         h0bNh6W8ougui3b4j5DN/VYFtVYPUQA3PDLVLtOrF4lenDoNnZliDr6APHBY1i+VeinW
         n0QZKJh98bvwCx8olSa2pymO5ZXkZlj9ihEpecD2H832WCiLK9WsX5p+iuWnKUEnPosr
         71evIjctUqlSaZQFUWr7sFoRJHsmtH/4G7dZOFMhRyjK/QEnfCCCBK2z8T97SBCjMXUu
         OwQEWLG3eB1oNqzNIi39/PcUUm26VMecb1ytbj7dbuEo9yzLWuL/bL8VH8Qu2FxB1Abi
         J1Hg==
X-Gm-Message-State: AOAM532LLuHkePMc2wugcpiB1HQq3uUJi5VrMoYZDmt3vEl7URwiWpdJ
        hkIseAAHDXlUThnT9Ehl7SqHMbsRzHVq2ySY
X-Google-Smtp-Source: ABdhPJzu1fgpKvmseTngQUlnpqfOD9CWRtbTz49hvvVXQVOTI2Wd0Jb0M4b7pGEmLQJRt21FjuvRvQ==
X-Received: by 2002:a05:600c:350a:: with SMTP id h10mr2750709wmq.154.1622025526266;
        Wed, 26 May 2021 03:38:46 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:1d80:a50a:8c74:4a8f:62b3])
        by smtp.gmail.com with ESMTPSA id j101sm15364927wrj.66.2021.05.26.03.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 03:38:45 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Neal Cardwell <ncardwell@google.com>,
        Matt Mathis <mattmathis@google.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        John Heffner <johnwheffner@gmail.com>,
        Leonard Crestez <lcrestez@drivenets.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFCv2 3/3] tcp: Wait for sufficient data in tcp_mtu_probe
Date:   Wed, 26 May 2021 13:38:27 +0300
Message-Id: <e6dac4f513fa2ca96ccb4dcc5b11f96b3f9ddc40.1622025457.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1622025457.git.cdleonard@gmail.com>
References: <cover.1622025457.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to RFC4821 Section 7.4 "Protocols MAY delay sending non-probes
in order to accumulate enough data" but linux almost never does that.

Implement this by returning 0 from tcp_mtu_probe if not enough data is
queued locally but some packets are still in flight. This makes mtu
probing more likely to happen for applications that do small writes.

Only doing this if packets are in flight should ensure that writing will
be attempted again later. This is similar to how tcp_mtu_probe already
returns zero if the probe doesn't fit inside the receiver window or the
congestion window.

Control this with a sysctl because this implies a latency tradeoff but
only up to one RTT.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 Documentation/networking/ip-sysctl.rst |  5 +++++
 include/net/netns/ipv4.h               |  1 +
 net/ipv4/sysctl_net_ipv4.c             |  7 +++++++
 net/ipv4/tcp_ipv4.c                    |  1 +
 net/ipv4/tcp_output.c                  | 18 ++++++++++++++----
 5 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 7ab52a105a5d..967b7fac35b1 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -349,10 +349,15 @@ tcp_mtu_probe_floor - INTEGER
 	If MTU probing is enabled this caps the minimum MSS used for search_low
 	for the connection.
 
 	Default : 48
 
+tcp_mtu_probe_waitdata - BOOLEAN
+	Wait for enough data for an mtu probe to accumulate on the sender.
+
+	Default: 1
+
 tcp_mtu_probe_rack - BOOLEAN
 	Try to use shorter probes if RACK is also enabled
 
 	Default: 1
 
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index b4ff12f25a7f..366e7b325778 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -112,10 +112,11 @@ struct netns_ipv4 {
 #ifdef CONFIG_NET_L3_MASTER_DEV
 	u8 sysctl_tcp_l3mdev_accept;
 #endif
 	u8 sysctl_tcp_mtu_probing;
 	int sysctl_tcp_mtu_probe_floor;
+	int sysctl_tcp_mtu_probe_waitdata;
 	int sysctl_tcp_mtu_probe_rack;
 	int sysctl_tcp_base_mss;
 	int sysctl_tcp_min_snd_mss;
 	int sysctl_tcp_probe_threshold;
 	u32 sysctl_tcp_probe_interval;
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 275c91fb9cf8..53868b812958 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -847,10 +847,17 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &tcp_min_snd_mss_min,
 		.extra2		= &tcp_min_snd_mss_max,
 	},
+	{
+		.procname	= "tcp_mtu_probe_waitdata",
+		.data		= &init_net.ipv4.sysctl_tcp_mtu_probe_waitdata,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 	{
 		.procname	= "tcp_mtu_probe_rack",
 		.data		= &init_net.ipv4.sysctl_tcp_mtu_probe_rack,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index ed8af4a7325b..940df2ae4636 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2892,10 +2892,11 @@ static int __net_init tcp_sk_init(struct net *net)
 	net->ipv4.sysctl_tcp_base_mss = TCP_BASE_MSS;
 	net->ipv4.sysctl_tcp_min_snd_mss = TCP_MIN_SND_MSS;
 	net->ipv4.sysctl_tcp_probe_threshold = TCP_PROBE_THRESHOLD;
 	net->ipv4.sysctl_tcp_probe_interval = TCP_PROBE_INTERVAL;
 	net->ipv4.sysctl_tcp_mtu_probe_floor = TCP_MIN_SND_MSS;
+	net->ipv4.sysctl_tcp_mtu_probe_waitdata = 1;
 	net->ipv4.sysctl_tcp_mtu_probe_rack = 1;
 
 	net->ipv4.sysctl_tcp_keepalive_time = TCP_KEEPALIVE_TIME;
 	net->ipv4.sysctl_tcp_keepalive_probes = TCP_KEEPALIVE_PROBES;
 	net->ipv4.sysctl_tcp_keepalive_intvl = TCP_KEEPALIVE_INTVL;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 362f97cfb09e..268e1bac001f 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2394,14 +2394,10 @@ static int tcp_mtu_probe(struct sock *sk)
 		 */
 		tcp_mtu_check_reprobe(sk);
 		return -1;
 	}
 
-	/* Have enough data in the send queue to probe? */
-	if (tp->write_seq - tp->snd_nxt < size_needed)
-		return -1;
-
 	/* Can probe fit inside congestion window? */
 	if (packets_needed > tp->snd_cwnd)
 		return -1;
 
 	/* Can probe fit inside receiver window? If not then skip probing.
@@ -2411,10 +2407,24 @@ static int tcp_mtu_probe(struct sock *sk)
 	 * clear below.
 	 */
 	if (tp->snd_wnd < size_needed)
 		return -1;
 
+	/* Have enough data in the send queue to probe? */
+	if (tp->write_seq - tp->snd_nxt < size_needed) {
+		/* If packets are already in flight it's safe to wait for more data to
+		 * accumulate on the sender because writing will be triggered as ACKs
+		 * arrive.
+		 * If no packets are in flight returning zero can stall.
+		 */
+		if (net->ipv4.sysctl_tcp_mtu_probe_waitdata &&
+		    tcp_packets_in_flight(tp))
+			return 0;
+		else
+			return -1;
+	}
+
 	/* Do we need for more acks to clear the receive window? */
 	if (after(tp->snd_nxt + size_needed, tcp_wnd_end(tp)))
 		return 0;
 
 	/* Do we need the congestion window to clear? */
-- 
2.25.1

