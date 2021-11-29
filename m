Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B00B5460E3E
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 05:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbhK2FB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 00:01:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238488AbhK2E7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 23:59:24 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58776C0613D7
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 20:55:21 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id o4so15527917pfp.13
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 20:55:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EqYRUqqd41aXlKA0/ZYdi5FpiIkmQPnY727rVIh/6mk=;
        b=EQN7scL8XVWVBSaRuNL3dIX9JUw4vUuIAuIDeAxmXtH16BtX2RYCiBjJm5QSxDUzRg
         ofFio8JK6ZErkFyhJspoCMpHEqKlbF6B9ScrwU2/IddixGSTMXl9tl/Mik3/0kR5v1Lo
         llCHmPLV/9jpDqcSI2XeVfZ31S/h6JLyIxiVWcYSaMbDR3T69J+GQiVFZWUUZP2IucPx
         9kiF9Vh+yIU2CRwfTEPHASmrJIxYr8YdLHGFq0+FTq9PyaLtHXMoosLHKGmkHdG+cpOk
         hINYWNp/tEhuEdbR+Fto0jBH55VO4a/bRdENcMGm6gi55hVvzY5N2+GaQQcCkoZ7+Kfm
         GC2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EqYRUqqd41aXlKA0/ZYdi5FpiIkmQPnY727rVIh/6mk=;
        b=5woSzvxdIu1ia7vwXb0PnJ6EluCahjnSFmRSUxq4MtIXLQ7PoQumuFVs0f/T7ijHmr
         hKylnOdDUOdyY4utIp5fmsVuLp5zs0QDY6ZusR8rKOCMsho8W8PVH1bM7hAt9vAZBnxr
         ucRMvZ33H9/FmBY2LClrx4LSWpm05pHEbFitsl5bFfYdme/NUYd5ZQ2PY6Fhem4m1Cub
         8PTKJ65f41Lzo4tlq89V5xtGkMdA2+hSScub3NxOe0B7/lHx5t/8A6BJ+PIkOoHzg2L9
         yksMVyx+tyqIctKNM17klW8pGWKIo8fbQT1tVIcnHPftxW+ngU8Xq/9pdZEKe3gGCl7x
         jexQ==
X-Gm-Message-State: AOAM532v/5cmFNL06aqimBp6N47qQ55ONa3Ld+cKRDJ6uEmjDWBtELw6
        75K827caB1nx5DAnn0Y3fQYfjkU+SqJ/+Q==
X-Google-Smtp-Source: ABdhPJzBn0g76xnzIOKtfIGbytb6XmznkyPdo2jIMe4QpxOe82kBW11TQLwGS3NXFzKAh7pb+ZdPPw==
X-Received: by 2002:a05:6a00:1909:b0:49f:a0d0:abcf with SMTP id y9-20020a056a00190900b0049fa0d0abcfmr36838056pfi.70.1638161720598;
        Sun, 28 Nov 2021 20:55:20 -0800 (PST)
Received: from localhost.localdomain ([111.204.182.106])
        by smtp.gmail.com with ESMTPSA id p33sm10781329pgm.85.2021.11.28.20.55.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Nov 2021 20:55:20 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Wei Wang <weiwan@google.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [net v3 2/3] net: sched: add check tc_skip_classify in sch egress
Date:   Mon, 29 Nov 2021 12:55:02 +0800
Message-Id: <20211129045503.20217-2-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20211129045503.20217-1-xiangxia.m.yue@gmail.com>
References: <20211129045503.20217-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Try to resolve the issues as below:
* We look up and then check tc_skip_classify flag in net
  sched layer, even though skb don't want to be classified.
  That case may consume a lot of cpu cycles.

  Install the rules as below:
  $ for id in $(seq 1 100); do
  $       tc filter add ... egress prio $id ... action mirred egress redirect dev ifb0
  $ done

  netperf:
  $ taskset -c 1 netperf -t TCP_RR -H ip -- -r 32,32
  $ taskset -c 1 netperf -t TCP_STREAM -H ip -- -m 32

  Before: 10662.33 tps, 108.95 Mbit/s
  After:  12434.48 tps, 145.89 Mbit/s
  For TCP_RR, there are 16.6% improvement, TCP_STREAM 33.9%.

* bpf_redirect may be invoked in egress path. if we don't
  check the flags and then return immediately, the packets
  will loopback.

  $ tc filter add dev eth0 egress bpf direct-action obj \
	  test_tc_redirect_ifb.o sec redirect_ifb

Cc: Willem de Bruijn <willemb@google.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Antoine Tenart <atenart@kernel.org>
Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Wei Wang <weiwan@google.com>
Cc: "Björn Töpel" <bjorn@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
v2: https://patchwork.kernel.org/project/netdevbpf/patch/20211103143208.41282-1-xiangxia.m.yue@gmail.com/
Willem de Bruijn and Daniel Borkmann, comment this patch, but I think we should fix this,
bpf_redirect may also loopback the packets. I hope there are more comments?
---
 net/core/dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 823917de0d2b..4ceb927b1577 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3823,6 +3823,9 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 	if (!miniq)
 		return skb;
 
+	if (skb_skip_tc_classify(skb))
+		return skb;
+
 	/* qdisc_skb_cb(skb)->pkt_len was already set by the caller. */
 	qdisc_skb_cb(skb)->mru = 0;
 	qdisc_skb_cb(skb)->post_ct = false;
-- 
2.27.0

