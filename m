Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3E137A644
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 14:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbhEKMFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 08:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbhEKMFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 08:05:47 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD7BC061574;
        Tue, 11 May 2021 05:04:40 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id s6so22514200edu.10;
        Tue, 11 May 2021 05:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hJsw+lxKd2cb0b24j+83WH1uLaEto1TRoqJQ5s2GyQw=;
        b=pFbmxPia6cPDL8Awb5a8lY1GeCvq/Eu7I5OzOoAHLtTDi8T1o+s1QGH+lj1+2gNyyG
         5DlTjRd7pV8so+YSUx3Vy8B+WAP+CpMbHowMpq9jmXE7qkd7uLOVPlcyuwVgpyknjBMY
         pv50pn21wdpei/HpSx4eRW4mJyy59+6dLfeBZhCOlO9gbc45Us2ixzhQgmHlkgb97JZ1
         tSN+ivUdegqNdUja2P6DMPXy0nE8QS58zHY2nE7pnYTIiH0vS4CeI/A0YyAgiBtB4K7E
         j6VgQY5LzhY1OWTyBqUMbrlpwR/AGrkYY1VePyKvl05dl2vMkEYkcX8Aa84/iThfqVVk
         zJ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hJsw+lxKd2cb0b24j+83WH1uLaEto1TRoqJQ5s2GyQw=;
        b=uK6KdCTK7cO4PLs2n4Bb+KrZSaVyrKTIa0MkuXBWjZRShzfZjL/tSs7mWsvJjbRkuH
         02NTdgI2+Yuww9xeSj5OrwvMsyMqE2gHOyrGcdUhjZ4JTg+lIjDbBE/Kk4gF901ar2h6
         rJIWtMiJBWVeIN6mkTVxA3b4xxOpsfzBw7H0TqAgAod9fA/JdlvLhNk9iUR+Ve98fT8O
         qoC8F8fZiwrnL+BALK/VLVDYPVcmjj4VNNCkFKU+Yz0ZY9nqF4DLgSXVEKCGdX8n3IaG
         Fdf6FA+SczgGyrN7iKpB7VYQPRBZTq1K5xsiUeMFuK5DPOrz2ljMwEr5sBQtKyIh2LP1
         OGiA==
X-Gm-Message-State: AOAM5324bboxIMwmX1Hl05PIvQVlqpYAFzXVf9Z9kylewcbH1q1dv2aR
        fP4wnq7L4gcjGafXg/iPBv4=
X-Google-Smtp-Source: ABdhPJwUDjbq3fzDucfBHjhDPlfU72GnCoS3a0ZLgfCQOJOaj91kTubBkerTs7LeckDpkSm+b6iSJg==
X-Received: by 2002:a05:6402:1115:: with SMTP id u21mr35586687edv.383.1620734678860;
        Tue, 11 May 2021 05:04:38 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:1d80:58c4:451b:d037:737c])
        by smtp.gmail.com with ESMTPSA id o20sm8212615eds.20.2021.05.11.05.04.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 05:04:38 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Neal Cardwell <ncardwell@google.com>,
        Matt Mathis <mattmathis@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        John Heffner <johnwheffner@gmail.com>,
        Leonard Crestez <lcrestez@drivenets.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC 2/3] tcp: Use mtu probes if RACK is enabled
Date:   Tue, 11 May 2021 15:04:17 +0300
Message-Id: <b3be1a00fa6e242709ce2cfbd10b09d22934e73e.1620733594.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1620733594.git.cdleonard@gmail.com>
References: <cover.1620733594.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RACK allows detecting a loss in min_rtt / 4 based on just one extra
packet. If enabled use this instead of relying of fast retransmit.

Suggested-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 Documentation/networking/ip-sysctl.rst |  5 +++++
 include/net/netns/ipv4.h               |  1 +
 net/ipv4/sysctl_net_ipv4.c             |  7 +++++++
 net/ipv4/tcp_ipv4.c                    |  1 +
 net/ipv4/tcp_output.c                  | 22 +++++++++++++++++++++-
 5 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 108a5ee227d3..4f6ac69f61e7 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -325,10 +325,15 @@ tcp_mtu_probe_floor - INTEGER
 tcp_mtu_probe_autocork - BOOLEAN
 	Take into account mtu probe size when accumulating data via autocorking.
 
 	Default: 1
 
+tcp_mtu_probe_rack - BOOLEAN
+	Try to use shorter probes if RACK is also enabled
+
+	Default: 1
+
 tcp_min_snd_mss - INTEGER
 	TCP SYN and SYNACK messages usually advertise an ADVMSS option,
 	as described in RFC 1122 and RFC 6691.
 
 	If this ADVMSS option is smaller than tcp_min_snd_mss,
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 3a2d8bf2b20a..298e65d8605c 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -113,10 +113,11 @@ struct netns_ipv4 {
 	u8 sysctl_tcp_l3mdev_accept;
 #endif
 	u8 sysctl_tcp_mtu_probing;
 	int sysctl_tcp_mtu_probe_floor;
 	int sysctl_tcp_mtu_probe_autocork;
+	int sysctl_tcp_mtu_probe_rack;
 	int sysctl_tcp_base_mss;
 	int sysctl_tcp_min_snd_mss;
 	int sysctl_tcp_probe_threshold;
 	u32 sysctl_tcp_probe_interval;
 
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index e19176c17973..f9366f35ff9c 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -834,10 +834,17 @@ static struct ctl_table ipv4_net_table[] = {
 		.data		= &init_net.ipv4.sysctl_tcp_mtu_probe_autocork,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "tcp_mtu_probe_rack",
+		.data		= &init_net.ipv4.sysctl_tcp_mtu_probe_rack,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 	{
 		.procname	= "tcp_probe_threshold",
 		.data		= &init_net.ipv4.sysctl_tcp_probe_threshold,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 7e75423c08c9..4928fcd6e233 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2890,10 +2890,11 @@ static int __net_init tcp_sk_init(struct net *net)
 	net->ipv4.sysctl_tcp_min_snd_mss = TCP_MIN_SND_MSS;
 	net->ipv4.sysctl_tcp_probe_threshold = TCP_PROBE_THRESHOLD;
 	net->ipv4.sysctl_tcp_probe_interval = TCP_PROBE_INTERVAL;
 	net->ipv4.sysctl_tcp_mtu_probe_floor = TCP_MIN_SND_MSS;
 	net->ipv4.sysctl_tcp_mtu_probe_autocork = 1;
+	net->ipv4.sysctl_tcp_mtu_probe_rack = 1;
 
 	net->ipv4.sysctl_tcp_keepalive_time = TCP_KEEPALIVE_TIME;
 	net->ipv4.sysctl_tcp_keepalive_probes = TCP_KEEPALIVE_PROBES;
 	net->ipv4.sysctl_tcp_keepalive_intvl = TCP_KEEPALIVE_INTVL;
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 5a320d792ec4..7cd1e8fd9749 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2311,27 +2311,47 @@ static bool tcp_can_coalesce_send_queue_head(struct sock *sk, int len)
 	}
 
 	return true;
 }
 
+static int tcp_mtu_probe_is_rack(const struct sock *sk)
+{
+	struct net *net = sock_net(sk);
+
+	return (net->ipv4.sysctl_tcp_recovery & TCP_RACK_LOSS_DETECTION &&
+			net->ipv4.sysctl_tcp_mtu_probe_rack);
+}
+
 /* Calculate the size of an MTU probe
  * Probing the MTU requires one packets which is larger that current MSS as well
  * as enough following mtu-sized packets to ensure that a probe loss can be
  * detected without a full Retransmit Time out.
  */
 int tcp_mtu_probe_size_needed(struct sock *sk, int *probe_size)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
+	struct net *net = sock_net(sk);
 	int probe_size_val;
 	int size_needed;
 
 	/* This might be a little slow: */
 	probe_size_val = tcp_mtu_to_mss(sk, (icsk->icsk_mtup.search_high + icsk->icsk_mtup.search_low) >> 1);
 	if (probe_size)
 		*probe_size = probe_size_val;
-	size_needed = probe_size_val + (tp->reordering + 1) * tp->mss_cache;
+
+	if (tcp_mtu_probe_is_rack(sk)) {
+		/* RACK allows recovering in min_rtt / 4 based on just one extra packet
+		 * Use two to account for unrelated losses
+		 */
+		size_needed = probe_size_val + 2 * tp->mss_cache;
+	} else {
+		/* Without RACK send enough extra packets to trigger fast retransmit
+		 * This is dynamic DupThresh + 1
+		 */
+		size_needed = probe_size_val + (tp->reordering + 1) * tp->mss_cache;
+	}
 
 	return size_needed;
 }
 
 /* Create a new MTU probe if we are ready.
-- 
2.25.1

