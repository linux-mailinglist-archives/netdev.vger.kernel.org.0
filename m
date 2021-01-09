Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCFB22EFDC6
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 05:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbhAIEiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 23:38:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbhAIEiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 23:38:51 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D32C061573;
        Fri,  8 Jan 2021 20:38:11 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id i6so11860802otr.2;
        Fri, 08 Jan 2021 20:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=ZsFTTrJbetn2CnyONlnngrlzz9wtSmXI0rG1K4D4rPo=;
        b=DT4seXADhunI5NZU2Tg6VYDsdyEOLa/LHxr4wBSTKEGcfFth1S710Lyf8BJk9/t09p
         rh1O3DkP22MrNM96zWXaSATEQyCFgK8D5/WWc0OdwugBYYMjBje19MDQMUTsl8tVn09H
         F2vWSOWJoz3E1xAJ2B+aBaEeIDdCoJf/pxxKorl+dKp7EyhV6kBAnq3WD5frGecu4x4+
         mwyPoUKxkZuU+poMkEOZ7MDCyxBtZydlc01Rqe2xHt9F6KR754ZPnUMthRnMZkcfka4O
         p3G0usfJ3YAdbwAWSav+0X6hg0Nid2aBCBqBJkmBsFxEt+9EiQrPsPVc+6MKI10Ws5MU
         OffQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=ZsFTTrJbetn2CnyONlnngrlzz9wtSmXI0rG1K4D4rPo=;
        b=PeOac68z6S5wPxtvgUWIGtBlar5dPbIJA1o2DCX18pdSipvzIKQofrrkvW6gZF2ZZn
         MuzyQ75EeW+Zg3DsX5fJxDC8xTIFlFpAMvxTLx/XmQsVlR/KEUYKKeJifJZXrzfmk3sb
         Q6H5C+bEEseTkyWRBYk3DlwN3+3PdSyF5UtWSRxyQtcItrb3wq20GFf0bl4uukIhmWN0
         e/29nfvC5jIvRHmVLVeiMjEiztHgsMX3YFd/GJTAyROhBoSSDkrtk6iYAcDkFousBXFK
         dmEtcdFzOLnOrEbrveh3EavdZG8i5eQlIoGJNJGD8mmubPBbvG82uF+TjydFfugkNik+
         3H9w==
X-Gm-Message-State: AOAM531W9InKpB2UaPEGo2HWpr89sfcWeasjtldiKqPNo+qdCkKffud9
        Q3TuKnGIobABQsTVy6q9LjE=
X-Google-Smtp-Source: ABdhPJx+XQxRy0Hr5Q5bTreVVN47gPlzSpf+RG+v87C4V0nUh56BGU7o6DS53FBWtMv9Y4IpxDkaiw==
X-Received: by 2002:a9d:aca:: with SMTP id 68mr4832590otq.272.1610167090979;
        Fri, 08 Jan 2021 20:38:10 -0800 (PST)
Received: from localhost.localdomain (99-6-134-177.lightspeed.snmtca.sbcglobal.net. [99.6.134.177])
        by smtp.gmail.com with ESMTPSA id y84sm2470454oig.36.2021.01.08.20.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 20:38:10 -0800 (PST)
Date:   Fri, 8 Jan 2021 20:38:08 -0800
From:   Enke Chen <enkechen2020@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Maxwell <jmaxwell37@gmail.com>,
        William McCall <william.mccall@gmail.com>, enchen2020@gmail.com
Subject: [PATCH] Revert "tcp: simplify window probe aborting on USER_TIMEOUT"
Message-ID: <20210109043808.GA3694@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Enke Chen <enchen@paloaltonetworks.com>

This reverts commit 9721e709fa68ef9b860c322b474cfbd1f8285b0f.

With the commit 9721e709fa68 ("tcp: simplify window probe aborting
on USER_TIMEOUT"), the TCP session does not terminate with
TCP_USER_TIMEOUT when data remain untransmitted due to zero window.

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

Cc: stable@vger.kernel.org
Fixes: 9721e709fa68 ("tcp: simplify window probe aborting on USER_TIMEOUT")
Reported-by: William McCall <william.mccall@gmail.com>
Signed-off-by: Enke Chen <enchen@paloaltonetworks.com>
---
 net/ipv4/tcp_timer.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 6c62b9ea1320..ad98f2ea89f1 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -346,6 +346,7 @@ static void tcp_probe_timer(struct sock *sk)
 	struct sk_buff *skb = tcp_send_head(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 	int max_probes;
+	u32 start_ts;
 
 	if (tp->packets_out || !skb) {
 		icsk->icsk_probes_out = 0;
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
+	start_ts = tcp_skb_timestamp(skb);
+	if (!start_ts)
+		skb->skb_mstamp_ns = tp->tcp_clock_cache;
+	else if (icsk->icsk_user_timeout &&
+		 (s32)(tcp_time_stamp(tp) - start_ts) > icsk->icsk_user_timeout)
+		goto abort;
 
 	max_probes = sock_net(sk)->ipv4.sysctl_tcp_retries2;
 	if (sock_flag(sk, SOCK_DEAD)) {
-- 
2.29.2

