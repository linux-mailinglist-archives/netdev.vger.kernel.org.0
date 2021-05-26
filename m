Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4562D391519
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 12:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbhEZKkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 06:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233991AbhEZKkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 06:40:18 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC78C061574;
        Wed, 26 May 2021 03:38:46 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id n17-20020a7bc5d10000b0290169edfadac9so200912wmk.1;
        Wed, 26 May 2021 03:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MmEilk3WIXxDtJNZv7A7PlxIlYLkb/rN6qjZv1UZnpw=;
        b=nMsMJ6iLPPi3vpLnTReqnIWdcFuM2FxpXksKTgpoOuGvjqyZJgxkLDlu5xCz6Pv8RC
         H+Bmdv48ZatSu6pGmpBb6gBL6bV2a/MRSHyND7gK/IgD7cZJoq4hWnQuFKLYfT412pAB
         zeX5DTTrMUpLFStxH4zu0+HWRpM31uLQA8mp+VJ9vavhCWnuAwzHPHScDOpVSw2mFTG7
         ZTtSIVOVIanaKk6VBVUTeU4teS+c8dNJ9WkJ6P5xq5/XP57w0cN+i1eTZsW5DhYXHauu
         gN5n5QlSWe6VL6QWbBDioZ4LXhvsXK2xPlw5ApbxwSGK1G1618RLfSo0ommgp5UdtiB9
         wnIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MmEilk3WIXxDtJNZv7A7PlxIlYLkb/rN6qjZv1UZnpw=;
        b=YU80Jap/cYChW3mYnSOVqPuv98g4T0NDYzsxenUTQO9YPE1zVbQ6rj9nayK3OjQ7GI
         MeiYi6o/k8bGyzADFVZh0S+SRE93swEySKR7mPFL4OmMt3BqAhLaIyEHFda0hZQRs0YV
         9VlWWqB4zsBuKL3Ybbx0nlgdK/EK10DukzwS8yJFdB/Q+oNWL+91UypeHMpn6X86fC9m
         E49AH9W9IJwf8GYOXeNQDws39DVZFAFeBTFjWxvwTPtuJj8fxh5Zo+oqT2CGONsTqB1H
         MD3NNVYm5UGxTNRBfbnU/+Xhz/ymipOlv713g6ldzPY0W/R2Tj0DGZqPbVdC4uzDDH1s
         SHZw==
X-Gm-Message-State: AOAM532u8XN2gIm8E19NilbSDCBsJtebQfLw90WGK08Q+qxVBYE3VXnc
        lJR+gO5Cusd6UTjUUa5DdJw=
X-Google-Smtp-Source: ABdhPJwHm3JNSqqbGdMbwWDdLvYvvggbeaP4q1MvIBoSdXHvbac6ExQTJSTo1GMFM21+WAF4lNVtrw==
X-Received: by 2002:a1c:a5c3:: with SMTP id o186mr28203150wme.6.1622025524778;
        Wed, 26 May 2021 03:38:44 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:1d80:a50a:8c74:4a8f:62b3])
        by smtp.gmail.com with ESMTPSA id j101sm15364927wrj.66.2021.05.26.03.38.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 03:38:44 -0700 (PDT)
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
Subject: [RFCv2 2/3] tcp: Adjust congestion window handling for mtu probe
Date:   Wed, 26 May 2021 13:38:26 +0300
Message-Id: <ceaab407cbd802545151df0e517fb527e674a012.1622025457.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1622025457.git.cdleonard@gmail.com>
References: <cover.1622025457.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On very fast links after successive succesful MTU probes the cwnd (measured in
packets) shrinks and does not grow again because tcp_is_cwnd_limited returns
false unless at least half the window is being used. If snd_cwnd falls below 11
then no more probes are sent despite the link being otherwise idle.

When preparing an mtu probe linux checks for snd_cwnd >= 11 and for 2 more
packets to fit alongside what is currently in flight. The reasoning behind
these constants is unclear. Replace this with checks based on the required
probe size:

* Skip probing if congestion window is too small to ever fit a probe.
* Wait for the congestion window to drain if too many packets are
already in flight.

This is very similar to snd_wnd logic except packets are counted instead of
bytes. This patch also adds more documentation regarding how "return 0"
works in tcp_mtu_probe because I found it difficult to understand.

This patch allows mtu probing at smaller cwnd values and does not contradict
any standard. Since "0" is only returned if packets are in flight no stalls
should happen expect when many acks are lost.

Removing the snd_cwnd >= 11 check also allows probing to happen for
bursty traffic where the cwnd is reset to 10 after a few hundred ms of
idling.

It does not completely solve the problem of very small cwnds on fast links.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 net/ipv4/tcp_output.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 9691f435477b..362f97cfb09e 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2328,32 +2328,35 @@ static int tcp_mtu_probe_is_rack(const struct sock *sk)
  * changes resulting in larger path MTUs.
  *
  * Returns 0 if we should wait to probe (no cwnd available),
  *         1 if a probe was sent,
  *         -1 otherwise
+ *
+ * Caller won't queue future write attempts if this returns 0. Zero is only
+ * returned if acks are pending from packets in flight which will trigger
+ * tcp_write_xmit again later.
  */
 static int tcp_mtu_probe(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
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
 	 * not in recovery,
-	 * have enough cwnd, and
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
@@ -2375,10 +2378,11 @@ static int tcp_mtu_probe(struct sock *sk)
 		/* Without RACK send enough extra packets to trigger fast retransmit
 		 * This is dynamic DupThresh + 1
 		 */
 		size_needed = probe_size + (tp->reordering + 1) * tp->mss_cache;
 	}
+	packets_needed = DIV_ROUND_UP(size_needed, tp->mss_cache);
 
 	interval = icsk->icsk_mtup.search_high - icsk->icsk_mtup.search_low;
 	/* When misfortune happens, we are reprobing actively,
 	 * and then reprobe timer has expired. We stick with current
 	 * probing process by not resetting search range to its orignal.
@@ -2394,22 +2398,30 @@ static int tcp_mtu_probe(struct sock *sk)
 
 	/* Have enough data in the send queue to probe? */
 	if (tp->write_seq - tp->snd_nxt < size_needed)
 		return -1;
 
+	/* Can probe fit inside congestion window? */
+	if (packets_needed > tp->snd_cwnd)
+		return -1;
+
+	/* Can probe fit inside receiver window? If not then skip probing.
+	 * The receiver might increase the window as data is processed but
+	 * don't assume that.
+	 * If some data is inflight (between snd_una and snd_nxt) we wait for it to
+	 * clear below.
+	 */
 	if (tp->snd_wnd < size_needed)
 		return -1;
+
+	/* Do we need for more acks to clear the receive window? */
 	if (after(tp->snd_nxt + size_needed, tcp_wnd_end(tp)))
 		return 0;
 
-	/* Do we need to wait to drain cwnd? With none in flight, don't stall */
-	if (tcp_packets_in_flight(tp) + 2 > tp->snd_cwnd) {
-		if (!tcp_packets_in_flight(tp))
-			return -1;
-		else
-			return 0;
-	}
+	/* Do we need the congestion window to clear? */
+	if (tcp_packets_in_flight(tp) + packets_needed > tp->snd_cwnd)
+		return 0;
 
 	if (!tcp_can_coalesce_send_queue_head(sk, probe_size))
 		return -1;
 
 	/* We're allowed to probe.  Build it now. */
-- 
2.25.1

