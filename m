Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFEE37A648
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 14:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbhEKMF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 08:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231544AbhEKMFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 08:05:48 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9422EC06175F;
        Tue, 11 May 2021 05:04:41 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id j10so2311237ejb.3;
        Tue, 11 May 2021 05:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Knt9wT/TnxSJqdQUEwJzgxbl2tHLC9vQ7ygQk/z3nDU=;
        b=PGpkUvAz7khi0D+tBeYCLn8QramMYFE7ZaC3IEiqLoNSS5AYCDPZ+6Z4L8qCqF9rQM
         keG1pQW9P0ATI+GDgD2vxPQrrsK9PxpAzOMBYcuinQgqtGR5aw5y/bqI2WVDDhtzCTiO
         Cfv5JWO8k8xIIplo/d2mRBjSfpiyLX6o8bmbBzj3EGHBFGgLm7mtpJMSSwKbnOXh3BhL
         TzGlmRzCBg5gq4gzD6E/k0Z4B+MYpuGnJJgcPzqvNr9KWYJKyZEI1lq5Dy0BERIYfPbH
         /fbWxbkC/IYIFQ5K4tZYycnDXRk/NZgQCfKmvPo/fL1BTFlMb/DAFqPeCxpQrNJtvpiE
         RvoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Knt9wT/TnxSJqdQUEwJzgxbl2tHLC9vQ7ygQk/z3nDU=;
        b=GtwitcS6PdZm8VeNwdh051R9WiB942d4hriq/uLyjGKZEL8W3I6xaX2qYpCboU9Hsx
         HKzsvPXP2xtfIGTpgAks9jCwgwitlYgmZp/sGNVxQnvepXVAD2fKkwZcMv3WU8oF257B
         FXE+SVJxR44IpToziHaq+yaD6JQrVjYRTH+w3+743HAN0vBQTH66I2v1ZGKuaVg0bxLf
         oqglIiscmF/02y8ZiUe7rI3nL3pmNYMJJcxa8SaTfXdmO+gfFswuqbnho1u9o7eM5baV
         jrc4sWRRRbXTtBOSay3QO0QvLtDAOh0LuMjP1rKSgW2HzXcy4MjIXCf725p8kBnLMJKK
         eSFw==
X-Gm-Message-State: AOAM533BcYWX26cXlBOfiRLmhe+rdIqUYphuqN7t+Cpyet0GXqecTPWR
        08s1PM8wkDfodxF6X6tpA1A=
X-Google-Smtp-Source: ABdhPJylTaR0NiP5BrjYnLaUYJlc0wK+5kK1MkfSHIaFHaMnlcGnee8r11i4PaXZT4LNffxHCooJHQ==
X-Received: by 2002:a17:906:2ec6:: with SMTP id s6mr7755049eji.65.1620734680276;
        Tue, 11 May 2021 05:04:40 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:1d80:58c4:451b:d037:737c])
        by smtp.gmail.com with ESMTPSA id o20sm8212615eds.20.2021.05.11.05.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 05:04:39 -0700 (PDT)
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
Subject: [RFC 3/3] tcp: Adjust congestion window handling for mtu probe
Date:   Tue, 11 May 2021 15:04:18 +0300
Message-Id: <1d5beaabad348d16a95fc5e699f87f3248758996.1620733594.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1620733594.git.cdleonard@gmail.com>
References: <cover.1620733594.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When preparing an mtu probe linux checks for snd_cwnd >= 11 and for 2
more packets to fit alongside what is currently in flight. The reasoning
behind these constants is unclear. Replace this with checks based on the
required probe size:

* Skip probing if congestion window is too small to ever fit a probe.
* Wait for the congestion window to drain if too many packets are
already in flight.

This is very similar to snd_wnd logic except packets are counted instead
of bytes.

This patch will allow mtu probing at smaller cwnd values.

On very fast links after successive succesful MTU probes the cwnd
(measured in packets) shrinks and does not grow again because
tcp_is_cwnd_limited returns false. If snd_cwnd falls below then no more
probes are sent despite the link being otherwise idle.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 net/ipv4/tcp_output.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 7cd1e8fd9749..ccf3eb29e7a5 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2369,10 +2369,11 @@ static int tcp_mtu_probe(struct sock *sk)
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct sk_buff *skb, *nskb, *next;
 	struct net *net = sock_net(sk);
 	int probe_size;
 	int size_needed;
+	int packets_needed;
 	int copy, len;
 	int mss_now;
 	int interval;
 
 	/* Not currently probing/verifying,
@@ -2381,20 +2382,20 @@ static int tcp_mtu_probe(struct sock *sk)
 	 * not SACKing (the variable headers throw things off)
 	 */
 	if (likely(!icsk->icsk_mtup.enabled ||
 		   icsk->icsk_mtup.probe_size ||
 		   inet_csk(sk)->icsk_ca_state != TCP_CA_Open ||
-		   tp->snd_cwnd < 11 ||
 		   tp->rx_opt.num_sacks || tp->rx_opt.dsack))
 		return -1;
 
 	/* Use binary search for probe_size between tcp_mss_base,
 	 * and current mss_clamp. if (search_high - search_low)
 	 * smaller than a threshold, backoff from probing.
 	 */
 	mss_now = tcp_current_mss(sk);
 	size_needed = tcp_mtu_probe_size_needed(sk, &probe_size);
+	packets_needed = DIV_ROUND_UP(size_needed, tp->mss_cache);
 
 	interval = icsk->icsk_mtup.search_high - icsk->icsk_mtup.search_low;
 	/* When misfortune happens, we are reprobing actively,
 	 * and then reprobe timer has expired. We stick with current
 	 * probing process by not resetting search range to its orignal.
@@ -2406,26 +2407,26 @@ static int tcp_mtu_probe(struct sock *sk)
 		 */
 		tcp_mtu_check_reprobe(sk);
 		return -1;
 	}
 
+	/* Can probe fit inside snd_cwnd */
+	if (packets_needed > tp->snd_cwnd)
+		return -1;
+
 	/* Have enough data in the send queue to probe? */
 	if (tp->write_seq - tp->snd_nxt < size_needed)
 		return net->ipv4.sysctl_tcp_mtu_probe_autocork ? 0 : -1;
 
 	if (tp->snd_wnd < size_needed)
 		return -1;
 	if (after(tp->snd_nxt + size_needed, tcp_wnd_end(tp)))
 		return 0;
 
-	/* Do we need to wait to drain cwnd? With none in flight, don't stall */
-	if (tcp_packets_in_flight(tp) + 2 > tp->snd_cwnd) {
-		if (!tcp_packets_in_flight(tp))
-			return -1;
-		else
-			return 0;
-	}
+	/* Wait for snd_cwnd to drain */
+	if (tcp_packets_in_flight(tp) + packets_needed > tp->snd_cwnd)
+		return 0;
 
 	if (!tcp_can_coalesce_send_queue_head(sk, probe_size))
 		return -1;
 
 	/* We're allowed to probe.  Build it now. */
-- 
2.25.1

