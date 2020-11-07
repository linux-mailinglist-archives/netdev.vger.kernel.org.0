Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3EA2AA2E7
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 07:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgKGGyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 01:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727782AbgKGGyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 01:54:05 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653A7C0613CF;
        Fri,  6 Nov 2020 22:54:05 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id u4so2898571pgr.9;
        Fri, 06 Nov 2020 22:54:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+Z83KD4tlH2fFEQRMhMQtKb03AHYu/UAnjkkUKzI9xQ=;
        b=to6uwmpt+2RfMmgfmq41N6qLqwxPO4len0HT4ZqZbrk4Y5+2wC/TnKTiZhiQzcjGAd
         VSJFH2No/Jx99fzs9FQ9qI75EZVhEugafWgSLQi68WmGcbHaO0D6Yy66nuEnNzTP81/p
         3ofFHwKGuVkQ9bp16borptwEc7ivi4avTfoKH5UzBVcoygeqve6XtWfLxU6ntPIGlTy5
         YI2BPoiSYHI5GgLUQcL0WDHjrl2VqHBlJeD8LnFoHzVQQ+nImmfL2Mjdl+6d1HUJMDJ9
         LYdqswo52coqPEUGHiflwDgNiq2wGQX7Vv78yvzZi9SQT3mtjvfc5fwt6at5x9h8mcud
         mDjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+Z83KD4tlH2fFEQRMhMQtKb03AHYu/UAnjkkUKzI9xQ=;
        b=rrX87qkWMvyE7iGfFmRpfoIX8E0HGa/HPsv/LxYXB9h3SrSpyMYcJ3p4qkXJF0ryI9
         mGQlQ5c1y+2ORGFm+OpbK67Pbo0NLs6uJrVxgest2Nmbu2z6Dn+4PFFbgsZuMUQSZg/X
         4n5RV2gkstK614Cq+DrMj5OHZqbvPCUlaT8bdsVNMpwkW3P8QvF0emPwxUV8cFSzCGUK
         B7Fig6XxjqrwlIKCOZohMIEQ2TvY9gCGWL+tsBWXlgdSS/MIha5dAh2GU8ZDIxohYepy
         bQg4JBba7Pl0dTCOK6YfsAmrtFRVcl8mhMIKSv58b7BTksghGvQNFbJ0lkLXLs9vWX0f
         c+Zg==
X-Gm-Message-State: AOAM532XaeV1DBuVOmTjrB17WdL7M/zehr4OeEHqegHX0v6Ypph169N1
        5d9VydNElB+lvJEFrgrnxA==
X-Google-Smtp-Source: ABdhPJwy2zvosEa7WnewbXyKOT4GqcR44MXF929jCV5KI0YI2vbLMpbagjHNF+1ly7QWIRTrmK56yg==
X-Received: by 2002:a62:790f:0:b029:18a:ae57:353f with SMTP id u15-20020a62790f0000b029018aae57353fmr5087076pfc.78.1604732045012;
        Fri, 06 Nov 2020 22:54:05 -0800 (PST)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id j20sm3849419pgh.15.2020.11.06.22.54.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Nov 2020 22:54:04 -0800 (PST)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     tariqt@nvidia.com, tariqt@mellanox.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] net/mlx4: Assign boolean values to a bool variable
Date:   Sat,  7 Nov 2020 14:53:58 +0800
Message-Id: <1604732038-6057-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Fix the following coccinelle warnings:

./drivers/net/ethernet/mellanox/mlx4/en_rx.c:687:1-17: WARNING: Assignment of 0/1 to bool variable

Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 502d1b97855c..b0f79a5151cf 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -684,7 +684,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 	xdp_prog = rcu_dereference(ring->xdp_prog);
 	xdp.rxq = &ring->xdp_rxq;
 	xdp.frame_sz = priv->frag_info[0].frag_stride;
-	doorbell_pending = 0;
+	doorbell_pending = false;
 
 	/* We assume a 1:1 mapping between CQEs and Rx descriptors, so Rx
 	 * descriptor offset can be deduced from the CQE index instead of
-- 
2.20.0

