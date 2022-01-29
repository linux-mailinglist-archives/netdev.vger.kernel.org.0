Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCC2B4A2D40
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 09:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243634AbiA2Ixm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 03:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232415AbiA2Ixm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 03:53:42 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD20C061714;
        Sat, 29 Jan 2022 00:53:41 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id v3so7409265pgc.1;
        Sat, 29 Jan 2022 00:53:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=a05V4ozyXx2YyDX8DIWgRjjIxEZoALk0gSpI8hkYt60=;
        b=Kj0r4g1ZMDIk4p86Ak/uNjXu8XRB31hUfA5AIWSl/JY2D/YIW73E0ABXKWNkakq06K
         bD3HxcnN5YBgQ8kpKoF4nG4uY3FmlVySxYiR/3alBcF5zTWkcqC3YMXSq6ZLRZNVs5cN
         I7kdhupFLui17WWvAilOLJyQkiBboFQncqKR9aKui8lEQdoDevPRHz+gynR23eu/mVty
         VkKFF0ky7YeUwpApt94TvCUa+Y7EvPIN2NnJ20N/ecaeWRJ4B5Vk4w5nK5uoegYs1gAO
         rafAteQmE8PD4W4Bkt5di+eQDMTm4S8m9r/AUvapAnB1/BBe6VBfLe42WzV05U4oTnZ+
         su1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=a05V4ozyXx2YyDX8DIWgRjjIxEZoALk0gSpI8hkYt60=;
        b=qlMno8WhmxFSCYcXptgkuqafcl6dYezQ3nVVA733A7g01dJGU+AjHqfPhuRchoBg4b
         vjh/O8qVgj6Tlrb9V3WDvoy0sxZXO2wIeXTdO5gHO0wsy3cMgt3mTJq7mXrgZ2cLin18
         igQquvl2cm9HCX7vTLmidL1Cilxs8EVxHSkza20kFqxvQ25CUskHpcQ0McpW7zLKtW6b
         ncWZZwk1SB7z5FExyvYWctV6DCAeXsjAUM+TIJwtef60no/vZ4krNOxE4EDUp6IxtZXV
         XdNa7SMvcv80k8o+PqnepddQF7jkD/V22ORhNSDjc5sAqrqhIv5InXSH4ys0O2Mf+w+O
         SX3w==
X-Gm-Message-State: AOAM532sA6PBkN919lvxfkisRDhfgcQcf1UaxAa40Cqv0jg//M/sN8QA
        3Wlz9YVZKvMn1XnTMCvKYRihjacqVQvjuw==
X-Google-Smtp-Source: ABdhPJwRqs7csuGE/JE8h2SQ5QQd9S5Ru37Nko/elf0xCLUdsYZWj73lOjH2Dd+GWfHYlVACp+FWow==
X-Received: by 2002:a05:6a00:884:: with SMTP id q4mr11570615pfj.81.1643446421000;
        Sat, 29 Jan 2022 00:53:41 -0800 (PST)
Received: from ip-172-31-19-208.ap-northeast-1.compute.internal (ec2-18-181-137-102.ap-northeast-1.compute.amazonaws.com. [18.181.137.102])
        by smtp.gmail.com with ESMTPSA id k21sm11932108pff.33.2022.01.29.00.53.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Jan 2022 00:53:40 -0800 (PST)
Date:   Sat, 29 Jan 2022 08:53:36 +0000
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
To:     netdev@vger.kernel.org
Cc:     jwiedmann.dev@gmail.com, Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sameeh Jubran <sameehj@amazon.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: [PATCH v2] net: ena: Do not waste napi skb cache
Message-ID: <YfUAkA9BhyOJRT4B@ip-172-31-19-208.ap-northeast-1.compute.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By profiling, discovered that ena device driver allocates skb by
build_skb() and frees by napi_skb_cache_put(). Because the driver
does not use napi skb cache in allocation path, napi skb cache is
periodically filled and flushed. This is waste of napi skb cache.

As ena_alloc_skb() is called only in napi, Use napi_build_skb()
and napi_alloc_skb() when allocating skb.

This patch was tested on aws a1.metal instance.

[ jwiedmann.dev@gmail.com: Use napi_alloc_skb() instead of
  netdev_alloc_skb_ip_align() to keep things consistent. ]

Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Acked-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 53080fd143dc..07444aead3fd 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1400,10 +1400,9 @@ static struct sk_buff *ena_alloc_skb(struct ena_ring *rx_ring, void *first_frag)
 	struct sk_buff *skb;
 
 	if (!first_frag)
-		skb = netdev_alloc_skb_ip_align(rx_ring->netdev,
-						rx_ring->rx_copybreak);
+		skb = napi_alloc_skb(rx_ring->napi, rx_ring->rx_copybreak);
 	else
-		skb = build_skb(first_frag, ENA_PAGE_SIZE);
+		skb = napi_build_skb(first_frag, ENA_PAGE_SIZE);
 
 	if (unlikely(!skb)) {
 		ena_increase_stat(&rx_ring->rx_stats.skb_alloc_fail, 1,
-- 
2.33.1

