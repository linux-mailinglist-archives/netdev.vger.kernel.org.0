Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26C84A4E33
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 19:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237899AbiAaS0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 13:26:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348806AbiAaS0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 13:26:08 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FAFC061714
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 10:26:08 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so8171pjp.0
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 10:26:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rCLlUtnQH35gT8+FRgjKzZzhP4/g6CX5X/m+IUNUKh4=;
        b=eMhUOpC2JI6Wq5eT7y2RU1LLZy0XBVJ43BQpIq37Wt9V8CMQQrM2ceDqN9LCLgmgVX
         eJSJM4tIvDyMqcJ7/yZBnajR67ksso0LPX4WTFk+9JIpkhbHFsJmZbPSYqkME8CWISjb
         xDh1CogE1X6+xbXm/cXI+125Qh06Sy1bHrWg59ahJtnake+74qeX4PQy0rj6ozts5qdn
         IwSdsQdRxMpjWehWhRMrsBCCZTiPLBXkDKo80w9YXNjKbd+L8lJbEtDUFo0HhMIl6bpm
         A9EqUmuSuEyckLfUkUhjMa4fGwStl3usgroq9zmB+PherTc4819KfkZkhwKMT27D9lV9
         uV0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rCLlUtnQH35gT8+FRgjKzZzhP4/g6CX5X/m+IUNUKh4=;
        b=6T5loE4+tMDKOu4B05PJAHeedoLO1+yrYmllpgsS1WtA4Xmg9xwGeClzSL/4kk/GA8
         puM7ujO2dPnenwPW9UvlwIaVVXvJrD1Symkmt4Z+lH7A7Jfb0cKnEq1mNtp9f/7yHp2q
         xAXJf1GaPB7nCW2GdovUsVeh2Ylc7FXjxwi2SSRWXVyAeHqalt7E01JgzOrQlMvsG9O8
         kugHE3OnAIrnfwqxeD5gMRa3tZIUcWh1SdtNSRKJFIo6v17dvuwsClvchEuYx4+eU+21
         38AMxxySdxbd3iqnT5sFKqvJ92UIsN3sDLbRf3w1SfojRxv5kuVNoZPXgcLH7obfN7du
         j67g==
X-Gm-Message-State: AOAM532uPUxiv5LBOuXhsT6NS4uihGrJrPX7OyqRDg8p0EWX20tYfqTy
        NlHnjuwI91SmUfxw0E1yW5o=
X-Google-Smtp-Source: ABdhPJyjyFtlsbY81/KbpceCiLVOgbkG2/bQNf6h55NGHFsxdm7hMpTE0rIT5CU1k9SvE0aTH7lg/w==
X-Received: by 2002:a17:902:8496:: with SMTP id c22mr21855149plo.147.1643653568055;
        Mon, 31 Jan 2022 10:26:08 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4c2d:864b:dd30:3c5e])
        by smtp.gmail.com with ESMTPSA id m21sm19619673pfk.26.2022.01.31.10.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 10:26:07 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jason Xing <kerneljasonxing@gmail.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        liweishi <liweishi@kuaishou.com>,
        Shujin Li <lishujin@kuaishou.com>,
        Neal Cardwell <ncardwell@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v4.19] tcp: fix possible socket leaks in internal pacing mode
Date:   Mon, 31 Jan 2022 10:26:03 -0800
Message-Id: <20220131182603.3804056-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This patch is addressing an issue in stable linux-4.19 only.

In linux-4.20, TCP stack adopted EDT (Earliest Departure
Time) model and this issue was incidentally fixed.

Issue at hand was an extra sock_hold() from tcp_internal_pacing()
in paths not using tcp_xmit_retransmit_queue()

Jason Xing reported this leak and provided a patch stopping
the extra sock_hold() to happen.

This patch is more complete and makes sure to avoid
unnecessary extra delays, by reprogramming the high
resolution timer.

Fixes: 73a6bab5aa2a ("tcp: switch pacing timer to softirq based hrtimer")
Reference: https://lore.kernel.org/all/CANn89i+7-wE4xr5D9DpH+N-xkL1SB8oVghCKgz+CT5eG1ODQhA@mail.gmail.com/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Jason Xing <kerneljasonxing@gmail.com>
Reported-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Cc: liweishi <liweishi@kuaishou.com>
Cc: Shujin Li <lishujin@kuaishou.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_output.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 941c655cad91713f2e6ede178a8f1e5f4b5e7f51..c97c027a8d7734ac857e6b3680a809cd007f37de 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -968,6 +968,8 @@ enum hrtimer_restart tcp_pace_kick(struct hrtimer *timer)
 
 static void tcp_internal_pacing(struct sock *sk, const struct sk_buff *skb)
 {
+	struct tcp_sock *tp = tcp_sk(sk);
+	ktime_t expire, now;
 	u64 len_ns;
 	u32 rate;
 
@@ -979,12 +981,28 @@ static void tcp_internal_pacing(struct sock *sk, const struct sk_buff *skb)
 
 	len_ns = (u64)skb->len * NSEC_PER_SEC;
 	do_div(len_ns, rate);
-	hrtimer_start(&tcp_sk(sk)->pacing_timer,
-		      ktime_add_ns(ktime_get(), len_ns),
+	now = ktime_get();
+	/* If hrtimer is already armed, then our caller has not
+	 * used tcp_pacing_check().
+	 */
+	if (unlikely(hrtimer_is_queued(&tp->pacing_timer))) {
+		expire = hrtimer_get_softexpires(&tp->pacing_timer);
+		if (ktime_after(expire, now))
+			now = expire;
+		if (hrtimer_try_to_cancel(&tp->pacing_timer) == 1)
+			__sock_put(sk);
+	}
+	hrtimer_start(&tp->pacing_timer, ktime_add_ns(now, len_ns),
 		      HRTIMER_MODE_ABS_PINNED_SOFT);
 	sock_hold(sk);
 }
 
+static bool tcp_pacing_check(const struct sock *sk)
+{
+	return tcp_needs_internal_pacing(sk) &&
+	       hrtimer_is_queued(&tcp_sk(sk)->pacing_timer);
+}
+
 static void tcp_update_skb_after_send(struct tcp_sock *tp, struct sk_buff *skb)
 {
 	skb->skb_mstamp = tp->tcp_mstamp;
@@ -2121,6 +2139,9 @@ static int tcp_mtu_probe(struct sock *sk)
 	if (!tcp_can_coalesce_send_queue_head(sk, probe_size))
 		return -1;
 
+	if (tcp_pacing_check(sk))
+		return -1;
+
 	/* We're allowed to probe.  Build it now. */
 	nskb = sk_stream_alloc_skb(sk, probe_size, GFP_ATOMIC, false);
 	if (!nskb)
@@ -2194,12 +2215,6 @@ static int tcp_mtu_probe(struct sock *sk)
 	return -1;
 }
 
-static bool tcp_pacing_check(const struct sock *sk)
-{
-	return tcp_needs_internal_pacing(sk) &&
-	       hrtimer_is_queued(&tcp_sk(sk)->pacing_timer);
-}
-
 /* TCP Small Queues :
  * Control number of packets in qdisc/devices to two packets / or ~1 ms.
  * (These limits are doubled for retransmits)
-- 
2.35.0.rc2.247.g8bbb082509-goog

