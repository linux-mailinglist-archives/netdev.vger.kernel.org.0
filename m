Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 548AD2F887B
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 23:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbhAOWbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 17:31:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726172AbhAOWbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 17:31:42 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43EBC061757;
        Fri, 15 Jan 2021 14:31:01 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id s2so11196445oij.2;
        Fri, 15 Jan 2021 14:31:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=uzyWBS9+DxY8uhv4N5qWwxPq4n3dlQKk79o209HF7qM=;
        b=qN/FQhS0w1u3aZA9oC/wA0Ps+ZJLw0oY9K4x03U4hqEpZFSgwxRLX6POaELg8A9orM
         s35OWpvnzjpM0TKdupzixGBSQ5Iy7L2+SAqPuPLzIAJkL0z/VTtgC93sBoTldU5cfkaT
         hwZ7/bEjC80k8ZMon5/dB8dsbPEFlLCJCnKoMmIhBiuTf3mP8PxtdlKZ2eNNCZ4y8Yls
         /F5dVgmzQYT0UG4bNysOPuVCM/jcFxI/s4e0fAMtcll1kOeL5giWssyOkonfTCZfUNHI
         jl64hzIq9Hct70PU+kgeClSiFBTa2DtTMKYqKFff8v+lG1e1WxpaxHOvfox8/hEVzqrx
         SYbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=uzyWBS9+DxY8uhv4N5qWwxPq4n3dlQKk79o209HF7qM=;
        b=pJ5lrAUtn3gjbVtQDd2X7/Ce3iifCl7TwAVysJS+4z5yKEd4Xe4o0A1W+V3IRAgtAt
         Tc7cBlTlGNmllkZpVRj6LrWfL6aL0fr6G9l5tsZgnIyfWs60vp3MFr0XaJV1mwr4Q7/D
         cRyfUBCrULEAByZVjKHSq17lJZi7wcN15apn4BBDkzsjgi81hZTo4g0WFm73jFr/Rh5o
         MADlzKtpPzP5lbGDV34DBoLVX0yoTkM9UATrB1mCXLQ7ldAsMHqHMglpDR3Az5LcDplA
         Y4WXrFq9jywTpttqChV4F/QIGJLYQ8uiec86bAzVhaUxDHYFjdmH3WTQD3h9UxIGldYf
         tSrg==
X-Gm-Message-State: AOAM530ThJfLgV09CnN6OcGhCCdDk/j6h0K21j5jtWVfoMGVvfbA1G6z
        zk7hM7Pf75SxzeuS+UueLek=
X-Google-Smtp-Source: ABdhPJxOSxyknU5H1+hGzk42MaCsfeuBp3VxoQl5sglarkpy5nwc1kAggFMGrk2ICqJ4ZRylE3etOg==
X-Received: by 2002:aca:4ec9:: with SMTP id c192mr7423302oib.115.1610749861241;
        Fri, 15 Jan 2021 14:31:01 -0800 (PST)
Received: from localhost.localdomain (99-6-134-177.lightspeed.snmtca.sbcglobal.net. [99.6.134.177])
        by smtp.gmail.com with ESMTPSA id c12sm1921643oig.35.2021.01.15.14.30.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 14:31:00 -0800 (PST)
Date:   Fri, 15 Jan 2021 14:30:58 -0800
From:   Enke Chen <enkechen2020@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Maxwell <jmaxwell37@gmail.com>,
        William McCall <william.mccall@gmail.com>,
        enkechen2020@gmail.com
Subject: [PATCH net v2] tcp: fix TCP_USER_TIMEOUT with zero window
Message-ID: <20210115223058.GA39267@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Enke Chen <enchen@paloaltonetworks.com>

The TCP session does not terminate with TCP_USER_TIMEOUT when data
remain untransmitted due to zero window.

The number of unanswered zero-window probes (tcp_probes_out) is
reset to zero with incoming acks irrespective of the window size,
as described in tcp_probe_timer():

    RFC 1122 4.2.2.17 requires the sender to stay open indefinitely
    as long as the receiver continues to respond probes. We support
    this by default and reset icsk_probes_out with incoming ACKs.

This counter, however, is the wrong one to be used in calculating the
duration that the window remains closed and data remain untransmitted.
Thanks to Jonathan Maxwell <jmaxwell37@gmail.com> for diagnosing the
actual issue.

In this patch a new timestamp is introduced for the socket in order to
track the elapsed time for the zero-window probes that have not been
answered with any non-zero window ack.

Fixes: 9721e709fa68 ("tcp: simplify window probe aborting on USER_TIMEOUT")
Reported-by: William McCall <william.mccall@gmail.com>
Co-developed-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Enke Chen <enchen@paloaltonetworks.com>
Reviewed-by: Yuchung Cheng <ycheng@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 include/net/inet_connection_sock.h |  3 +++
 net/ipv4/inet_connection_sock.c    |  1 +
 net/ipv4/tcp.c                     |  1 +
 net/ipv4/tcp_input.c               |  1 +
 net/ipv4/tcp_output.c              |  1 +
 net/ipv4/tcp_timer.c               | 14 +++++++-------
 6 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 7338b3865a2a..111d7771b208 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -76,6 +76,8 @@ struct inet_connection_sock_af_ops {
  * @icsk_ext_hdr_len:	   Network protocol overhead (IP/IPv6 options)
  * @icsk_ack:		   Delayed ACK control data
  * @icsk_mtup;		   MTU probing control data
+ * @icsk_probes_tstamp:    Probe timestamp (cleared by non-zero window ack)
+ * @icsk_user_timeout:	   TCP_USER_TIMEOUT value
  */
 struct inet_connection_sock {
 	/* inet_sock has to be the first member! */
@@ -129,6 +131,7 @@ struct inet_connection_sock {
 
 		u32		  probe_timestamp;
 	} icsk_mtup;
+	u32			  icsk_probes_tstamp;
 	u32			  icsk_user_timeout;
 
 	u64			  icsk_ca_priv[104 / sizeof(u64)];
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index fd8b8800a2c3..6bd7ca09af03 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -851,6 +851,7 @@ struct sock *inet_csk_clone_lock(const struct sock *sk,
 		newicsk->icsk_retransmits = 0;
 		newicsk->icsk_backoff	  = 0;
 		newicsk->icsk_probes_out  = 0;
+		newicsk->icsk_probes_tstamp = 0;
 
 		/* Deinitialize accept_queue to trap illegal accesses. */
 		memset(&newicsk->icsk_accept_queue, 0, sizeof(newicsk->icsk_accept_queue));
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index ed42d2193c5c..32545ecf2ab1 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2937,6 +2937,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 
 	icsk->icsk_backoff = 0;
 	icsk->icsk_probes_out = 0;
+	icsk->icsk_probes_tstamp = 0;
 	icsk->icsk_rto = TCP_TIMEOUT_INIT;
 	icsk->icsk_rto_min = TCP_RTO_MIN;
 	icsk->icsk_delack_max = TCP_DELACK_MAX;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index c7e16b0ed791..bafcab75f425 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3384,6 +3384,7 @@ static void tcp_ack_probe(struct sock *sk)
 		return;
 	if (!after(TCP_SKB_CB(head)->end_seq, tcp_wnd_end(tp))) {
 		icsk->icsk_backoff = 0;
+		icsk->icsk_probes_tstamp = 0;
 		inet_csk_clear_xmit_timer(sk, ICSK_TIME_PROBE0);
 		/* Socket must be waked up by subsequent tcp_data_snd_check().
 		 * This function is not for random using!
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index f322e798a351..ab458697881e 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -4084,6 +4084,7 @@ void tcp_send_probe0(struct sock *sk)
 		/* Cancel probe timer, if it is not required. */
 		icsk->icsk_probes_out = 0;
 		icsk->icsk_backoff = 0;
+		icsk->icsk_probes_tstamp = 0;
 		return;
 	}
 
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 6c62b9ea1320..454732ecc8f3 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -349,6 +349,7 @@ static void tcp_probe_timer(struct sock *sk)
 
 	if (tp->packets_out || !skb) {
 		icsk->icsk_probes_out = 0;
+		icsk->icsk_probes_tstamp = 0;
 		return;
 	}
 
@@ -360,13 +361,12 @@ static void tcp_probe_timer(struct sock *sk)
 	 * corresponding system limit. We also implement similar policy when
 	 * we use RTO to probe window in tcp_retransmit_timer().
 	 */
-	if (icsk->icsk_user_timeout) {
-		u32 elapsed = tcp_model_timeout(sk, icsk->icsk_probes_out,
-						tcp_probe0_base(sk));
-
-		if (elapsed >= icsk->icsk_user_timeout)
-			goto abort;
-	}
+	if (!icsk->icsk_probes_tstamp)
+		icsk->icsk_probes_tstamp = tcp_jiffies32;
+	else if (icsk->icsk_user_timeout &&
+		 (s32)(tcp_jiffies32 - icsk->icsk_probes_tstamp) >=
+		 msecs_to_jiffies(icsk->icsk_user_timeout))
+		goto abort;
 
 	max_probes = sock_net(sk)->ipv4.sysctl_tcp_retries2;
 	if (sock_flag(sk, SOCK_DEAD)) {
-- 
2.29.2

