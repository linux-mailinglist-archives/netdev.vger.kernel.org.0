Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3905FE5ED
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 01:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiJMXoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 19:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiJMXn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 19:43:56 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD0318C43F;
        Thu, 13 Oct 2022 16:43:54 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id de14so2300623qvb.5;
        Thu, 13 Oct 2022 16:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/YPjj/+mYMhRlZ2E9EjM0QB8fHYgSe8UWol/kOphzlw=;
        b=O4quyDE29K+3M6oNzJuBdcA5bA7uqLpZc9RUDQsHZBKDIkSrlZw4vANQ3w1jDzorpz
         7WKe9j3ny5ZwMaJDh4yukguMAjUkF947Hmv26iCLnCcO4j8nXuHr8DrHOH1oOKQhMS71
         Ky9CBYJKPchchJjRSZjjcp5pe1nFU7f7jiR9vx9wyqeKbi1hMIIOAHPjDk5/NaOiTPzK
         Y3rinmaKwkWzuIwwMrNxDmEUjobbXyF3Rf4wdCh8olJeTX5iF1nN1I7zLhcGmgug3DjN
         DEr7PlRaik7R1GntS6ZtakVVuEUp3GoBLTYjKjZqDHGRnVWPyoWhBZ7N78d/ZR5perIy
         TfAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/YPjj/+mYMhRlZ2E9EjM0QB8fHYgSe8UWol/kOphzlw=;
        b=HWJbXT1B9Jz6FNxJ16rW22/r2R8vQ9NOtpfgIu4cVO4MzFSaEIJ0jf5yXgnPDt2f6G
         Y3vT+pI0e53kZ5T6b0v8tawW+Jg+rq9NWKxftFmDFjrJwQJVTIZwWuC1rfPH43WvQZMW
         DOrqdaVFKY91xFc5MYyicZXnyqFPrPbR7zRQUmCJSFYujcd049VEVDVUtosx2IxUHFjD
         kSwWvTOfommq6FNe5PYHAwq3q8q45G48jwAGVoHSAjym4byxYDrw5ZAcpcH/KvDVCuMC
         9nJhId+4it7k7FBlI8LJmmoBWYmXNBYAxleYVJqtyP1QuqtKLeIVZnL4wli5rx3gsXon
         1Knw==
X-Gm-Message-State: ACrzQf2wUuNP4zNiXN6A+fUW81jG9/GDMrgNPzHhAElAUFoSi1mDX0De
        BC3E5ALpHa5Nuwzh5Ui86N4VDrl0SJg=
X-Google-Smtp-Source: AMsMyM61vCajgGmDZzBGu9YK0FXDaRoCwCzw8bi7Hhflshg6GE2WlnNRvLFg0ozNcsWC+TkUtEMkiw==
X-Received: by 2002:a0c:ab12:0:b0:4b1:9467:1948 with SMTP id h18-20020a0cab12000000b004b194671948mr2213318qvb.80.1665704633897;
        Thu, 13 Oct 2022 16:43:53 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:ec49:7545:4026:a70a])
        by smtp.gmail.com with ESMTPSA id l4-20020a37f904000000b006ced5d3f921sm925793qkj.52.2022.10.13.16.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 16:43:53 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
Cc:     Yury Norov <yury.norov@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] net: fix opencoded for_each_and_bit() in __netif_set_xps_queue()
Date:   Thu, 13 Oct 2022 16:43:48 -0700
Message-Id: <20221013234349.1165689-5-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221013234349.1165689-1-yury.norov@gmail.com>
References: <20221013234349.1165689-1-yury.norov@gmail.com>
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
index 53d738f66159..5db2b6de7308 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3648,52 +3648,6 @@ static inline bool netif_attr_test_online(unsigned long j,
 
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
index 8049e2ff11a5..b0fb592d51da 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2592,8 +2592,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
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

