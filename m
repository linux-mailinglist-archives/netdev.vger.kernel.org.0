Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04BC5460E3F
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 05:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbhK2FB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 00:01:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238207AbhK2E7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 23:59:24 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD56C061763
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 20:55:15 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so14535001pjb.5
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 20:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LNM8sfQpMLWvuNtmqh46qWd8UWJ7MTXUa8CLFYTumGA=;
        b=jT4jvsFQSDqsw7A6NLlvDsGVroRQgCJaHU2DlzWOl6AlqF8kZAkWzmMbyX4NmUGxdd
         vR+AKHeG0UXTU/HaBc59E+liX1AtXMz7ApstY2NoF1wR5yyOHHxxMGV4P6n87CZVhKsz
         wq8a8l4YN49Cw+yEAPfaZXWx51TJRwLc3y8zLP+e6T8o6ABfPP+Uz9ZbINyX3hnxs0Rq
         na9Q++jLTcnsqKUmijDzk1xbCxA9qoc38hCbvgIPtyBQ0/oVuS9TP9lDRZVzUYVpBFLY
         QPdEmxsoll/HYcJh0v7w47dwQX/eWO9JtjQXBwQH0BqxAZfP7IB3wvb+51ZgcXQH/Esh
         HvQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LNM8sfQpMLWvuNtmqh46qWd8UWJ7MTXUa8CLFYTumGA=;
        b=Ce68e6q7LFO5gOUL5WobqRgJBKR+FemK6uPPX1yH3XXEvLKpzq940k+wSwoK4jXLmW
         mk591A/11Xupnn0zNt0wcYRRbK6k/VulG8UrmYqoBLFCncIgi0FRKgDxvvv4TsQjvB5b
         AZQPD9aXgHJwxDpxcoYpIio9clwzi6Kfewt4EqKgj1ri9Ev+7xvXad3cilNKX6ruFU2b
         e0ZS0TFzks6/XrsO3K4auE1IrDGFbfQu9qrjh3ep1SIjX4TDy1HSQUZCEV13HxIKL7rc
         bDpLL69UbiNcHyKpMjERxdZmke0I2WQp0FIgM5HOqff+2qv3Loxb7+UXeVHHUgTz1wm+
         9lXA==
X-Gm-Message-State: AOAM533luLvDVJEcG2MXo59T2ohphFbDrZuIZr4dTvWE2lUCOsB06fWS
        bJRYhPgBqL0QdN0zLY6MVl1FLXvsw2w=
X-Google-Smtp-Source: ABdhPJwzVzjq+VxD3YdGR8tzb2kpxE+QhFlNATFcXHyCwLyb9cYnP8kKMG3u90ZvuT+7GJBPRxKbyQ==
X-Received: by 2002:a17:90a:e7cc:: with SMTP id kb12mr35596580pjb.172.1638161715170;
        Sun, 28 Nov 2021 20:55:15 -0800 (PST)
Received: from localhost.localdomain ([111.204.182.106])
        by smtp.gmail.com with ESMTPSA id p33sm10781329pgm.85.2021.11.28.20.55.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Nov 2021 20:55:14 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net v3 1/3] net: core: set skb useful vars in __bpf_tx_skb
Date:   Mon, 29 Nov 2021 12:55:01 +0800
Message-Id: <20211129045503.20217-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

We may use bpf_redirect to redirect the packets to other
netdevice (e.g. ifb) in ingress and egress path.

The target netdevice may check the *skb_iif, *redirected
and *from_ingress, for example, if skb_iif or redirected
is 0, ifb will drop the packets.

bpf_redirect may be invoked in ingress or egress path, so
we set the *skb_iif unconditionally.

Fixes: a70b506efe89 ("bpf: enforce recursion limit on redirects")
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/core/filter.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 8271624a19aa..225dc8743863 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2107,9 +2107,19 @@ static inline int __bpf_tx_skb(struct net_device *dev, struct sk_buff *skb)
 		return -ENETDOWN;
 	}
 
-	skb->dev = dev;
+	/* The target netdevice (e.g. ifb) may use the:
+	 * - skb_iif, bpf_redirect may be invoked in ingress or egress path.
+	 * - redirected
+	 * - from_ingress
+	 */
+	skb->skb_iif = skb->dev->ifindex;
+#ifdef CONFIG_NET_CLS_ACT
+	skb_set_redirected(skb, skb->tc_at_ingress);
+#else
 	skb->tstamp = 0;
+#endif
 
+	skb->dev = dev;
 	dev_xmit_recursion_inc();
 	ret = dev_queue_xmit(skb);
 	dev_xmit_recursion_dec();
-- 
2.27.0

