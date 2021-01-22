Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28B6300255
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 13:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbhAVMCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 07:02:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727847AbhAVKyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 05:54:45 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD55C06178B;
        Fri, 22 Jan 2021 02:54:01 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id x23so5996402lji.7;
        Fri, 22 Jan 2021 02:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DIoaswv7B1iicUnLwGWig+2UbyTxVZWzlqhoeUIxenk=;
        b=Aoo8DM1/97CyxI8eDrSo8GY/MTrS/ySxhpEl7dqNW6hwrMmR3d02gjRS2x31TijGtz
         TrjqIJ36cgKdJYkCfxA5gydspNfdQEtsXlNhLTwl9zQ6wRxpwyljQddMhIXwA02CPOym
         Ofwap2ZLw0pxiHFbYWHKRE2hmG1NwhHM5XdCJwY5AkLujXXyNcQUeQSnF0uJKe97pdPU
         hiW7Yaeh2bfNSy0+u/AImFfWbMJkOMReJ1iL1/0h+xwttmTdVUcmGPd9bsjQE6h7B183
         be6XLninUo6isnbJcJw2ugMhhEcmV80r5gTSj7pE88I3/J8q7xVPqyBgZzC8i/JKcpAH
         S/jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DIoaswv7B1iicUnLwGWig+2UbyTxVZWzlqhoeUIxenk=;
        b=iyOkK7DKEqBxBgest7ZqdTbs8PRKGYbqdZEgfx2juyqyjWQY29t6AbotJ5X/S2LDMk
         xYhfUTV8BUxLHhDqX9mwg2bkKSsQkEEF/2Qzbs+SP4Lxi9GbAlBGpuo8AkOf2p8KNRyl
         2/5ZFtyqFf7ZI0x0h6ZmmGa2VyozBHPRTdHcbsGdWZnxr+AykeNR9Mpzn/6fdImeBu3X
         0znXHe7UHfFNfhygxdgw0QWi4Lfd/ROU5UQXD/rCI9yeT8XflXMlIDB/gDGbU3VpeqWU
         sxo6QU+dZMaEkocNNEVSEbLmWYA+nw9qXKQ75VkFw2hf5uF49fjY7Cbo6DMSfzZvCjn9
         O9vg==
X-Gm-Message-State: AOAM533g677tAhGz9Z8n9UgC5kcd4W+A+1e3zDn7x8hNiiJKhqsCKf5N
        2uSAQu+2DeKHF/LoPVE8NcE=
X-Google-Smtp-Source: ABdhPJy/ppHP7o13BG30n7hpJE+1iACUpMWLv+Mfp3RKgYfpyIDZHwJ8UOaXQOVEJ4QGznvM6BFUjw==
X-Received: by 2002:a2e:97c3:: with SMTP id m3mr267043ljj.286.1611312839883;
        Fri, 22 Jan 2021 02:53:59 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id g14sm409580lja.120.2021.01.22.02.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 02:53:59 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com,
        andrii@kernel.org
Subject: [PATCH bpf-next 2/3] xsk: fold xp_assign_dev and __xp_assign_dev
Date:   Fri, 22 Jan 2021 11:53:50 +0100
Message-Id: <20210122105351.11751-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210122105351.11751-1-bjorn.topel@gmail.com>
References: <20210122105351.11751-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Fold xp_assign_dev and __xp_assign_dev. The former directly calls the
latter.

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xsk_buff_pool.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 20598eea658c..8de01aaac4a0 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -119,8 +119,8 @@ static void xp_disable_drv_zc(struct xsk_buff_pool *pool)
 	}
 }
 
-static int __xp_assign_dev(struct xsk_buff_pool *pool,
-			   struct net_device *netdev, u16 queue_id, u16 flags)
+int xp_assign_dev(struct xsk_buff_pool *pool,
+		  struct net_device *netdev, u16 queue_id, u16 flags)
 {
 	bool force_zc, force_copy;
 	struct netdev_bpf bpf;
@@ -191,12 +191,6 @@ static int __xp_assign_dev(struct xsk_buff_pool *pool,
 	return err;
 }
 
-int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *dev,
-		  u16 queue_id, u16 flags)
-{
-	return __xp_assign_dev(pool, dev, queue_id, flags);
-}
-
 int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_umem *umem,
 			 struct net_device *dev, u16 queue_id)
 {
@@ -210,7 +204,7 @@ int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_umem *umem,
 	if (pool->uses_need_wakeup)
 		flags |= XDP_USE_NEED_WAKEUP;
 
-	return __xp_assign_dev(pool, dev, queue_id, flags);
+	return xp_assign_dev(pool, dev, queue_id, flags);
 }
 
 void xp_clear_dev(struct xsk_buff_pool *pool)
-- 
2.27.0

