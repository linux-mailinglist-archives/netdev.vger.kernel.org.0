Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B765F23D1
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 17:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiJBPRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 11:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiJBPRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 11:17:14 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C823133A32;
        Sun,  2 Oct 2022 08:17:13 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id i9so2194927qvu.1;
        Sun, 02 Oct 2022 08:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=yU9cN/+uqBVB1dXNbr75Y5YkzMpkVLSP66bVAusnii4=;
        b=PopAKlMxrvfPEOuH+8QT8WPKSRyja9JPsjHnQA0hhfoXJUTyAApAcWsDMQvMqwWYPJ
         t0e9kf6zJFRH+bd7E6w89ouvhY7buL14A/Wxvrzk1S6MOw41Tpe9tW7NgHfGCVy5OlW0
         rNg5tMHZpkeIhdLf8zKf2HIVKewbtp/Upfv/rKpLLCGlL/Y879jHJtMTXgQNVvzyGEeN
         +HKfYOuw/uUX3nJ1HtYKqv6IbV5kwlZY+IjB5vf3Tc0CSI4xv8kT9FvEu/OeOcs1h+q2
         4WH+PZNAxoNEUkPggqkDzyenUvY+JP7rzJMz2L2wuwcbPykMLY1uIfEfBqZPMDpfP2+M
         B/ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=yU9cN/+uqBVB1dXNbr75Y5YkzMpkVLSP66bVAusnii4=;
        b=RFll5UPjFmPRWiJoFBy9NEpVGpL5c6qQTcA9aGAS3/GRFhWPYqxOor+/RoS+JekZDZ
         AI38LQFePw9VAL8Lvk31FmrOiBnqbpGY9DScW2UIF1VR0x1dAmapkRAEIIOVCtUCDRo5
         ZFL3q/2pBNz/LPpTawVmOKFfi0etGLLKBV76czlYgs6BVhvKK/vkrAAuJCNfc/kdcDW/
         fedHtBFkWp19vC5w3ITUPB68BfZxQZ9eblSALDvZqHS8bn/N3AZqMUnrh2n693nDuIvy
         Y/R/S0u2wUXzoJlFyxqRyo0GY9yprso6vsIvqQz1JqkQINVpXqOtOIGrdCNTUfwLPB0y
         /JzA==
X-Gm-Message-State: ACrzQf2erhUCepHF2AuUZ3yDm0ZUNd+zhB1I1c2Pn2eQwzm+sftbItfA
        PTS1ppZUEZPE6Jh7Myl98Csz3h+/ayQ=
X-Google-Smtp-Source: AMsMyM7m7sf2PXIIcSxRceXMge9XN/NAM+cmhOPzNh8308Qu8DgZu9Kk6l1gtUcoupcWli+H/1Pleg==
X-Received: by 2002:a05:6214:212c:b0:4af:8572:4255 with SMTP id r12-20020a056214212c00b004af85724255mr14137289qvc.16.1664723832733;
        Sun, 02 Oct 2022 08:17:12 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:ec09:fca7:de7a:72aa])
        by smtp.gmail.com with ESMTPSA id y15-20020a05620a25cf00b006ce515196a7sm8968655qko.8.2022.10.02.08.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Oct 2022 08:17:12 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>, linux-kernel@vger.kernel.org
Cc:     Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 4/4] net: fix opencoded for_each_and_bit() in __netif_set_xps_queue()
Date:   Sun,  2 Oct 2022 08:17:02 -0700
Message-Id: <20221002151702.3932770-5-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221002151702.3932770-1-yury.norov@gmail.com>
References: <20221002151702.3932770-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace opencoded bitmap traversing and drop unused
netif_attrmask_next*() functions

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/netdevice.h | 46 ---------------------------------------
 net/core/dev.c            |  3 +--
 2 files changed, 1 insertion(+), 48 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 6f8cdd5c7908..41c94e5854e8 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3628,52 +3628,6 @@ static inline bool netif_attr_test_online(unsigned long j,
 
 	return (j < nr_bits);
 }
-
-/**
- *	netif_attrmask_next - get the next CPU/Rx queue in a cpu/Rx queues mask
- *	@n: CPU/Rx queue index
- *	@srcp: the cpumask/Rx queue mask pointer
- *	@nr_bits: number of bits in the bitmask
- *
- * Returns >= nr_bits if no further CPUs/Rx queues set.
- */
-static inline unsigned int netif_attrmask_next(int n, const unsigned long *srcp,
-					       unsigned int nr_bits)
-{
-	/* n is a prior cpu */
-	cpu_max_bits_warn(n + 1, nr_bits);
-
-	if (srcp)
-		return find_next_bit(srcp, nr_bits, n + 1);
-
-	return n + 1;
-}
-
-/**
- *	netif_attrmask_next_and - get the next CPU/Rx queue in \*src1p & \*src2p
- *	@n: CPU/Rx queue index
- *	@src1p: the first CPUs/Rx queues mask pointer
- *	@src2p: the second CPUs/Rx queues mask pointer
- *	@nr_bits: number of bits in the bitmask
- *
- * Returns >= nr_bits if no further CPUs/Rx queues set in both.
- */
-static inline int netif_attrmask_next_and(int n, const unsigned long *src1p,
-					  const unsigned long *src2p,
-					  unsigned int nr_bits)
-{
-	/* n is a prior cpu */
-	cpu_max_bits_warn(n + 1, nr_bits);
-
-	if (src1p && src2p)
-		return find_next_and_bit(src1p, src2p, nr_bits, n + 1);
-	else if (src1p)
-		return find_next_bit(src1p, nr_bits, n + 1);
-	else if (src2p)
-		return find_next_bit(src2p, nr_bits, n + 1);
-
-	return n + 1;
-}
 #else
 static inline int netif_set_xps_queue(struct net_device *dev,
 				      const struct cpumask *mask,
diff --git a/net/core/dev.c b/net/core/dev.c
index 266378ad1cf1..e3da6cb1e7ee 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2591,8 +2591,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 		copy = true;
 
 	/* allocate memory for queue storage */
-	for (j = -1; j = netif_attrmask_next_and(j, online_mask, mask, nr_ids),
-	     j < nr_ids;) {
+	for_each_and_bit(j, online_mask, mask ? : online_mask, nr_ids) {
 		if (!new_dev_maps) {
 			new_dev_maps = kzalloc(maps_sz, GFP_KERNEL);
 			if (!new_dev_maps)
-- 
2.34.1

