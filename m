Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373CA2287BA
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729478AbgGURqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbgGURqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:46:31 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB6FC0619DA
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:46:31 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id k1so1914536pjt.5
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=21ztYo1uHKOQVrOI2wxli2xxPGSNsEhFPdmoi4KOKYM=;
        b=A3o0pE3efR+VNwz9PFz4mJB3Ib5lasNkpIxOYNvQ3G9nmMN4gkkHDI9auU7JGoS6kq
         2sJeuokGGg4cNdpXCPpprEWXd4BNhFxrs1zt8LHcEwvm/aTQEtsDae9/mXbbjzNOCqqN
         52NY3wH5k/bx2u0Hqq4FiLcFC/o+KyXHvl3ZV51bbpHGoBrTElpNfINA0XjGkzT1CiK5
         5rZv/90mryI1KjQQz9CG4js6tZpK+AiXn/VgZZAicGnGT6YAwAVCKUHCSZJ8AhIAUq/0
         qfL80J4vKd7y2waWRfmrK+Q0vxu4S2C0hZFVuI48cSSLj+tG7vztRHQki1KhRpj7i8Ev
         DFSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=21ztYo1uHKOQVrOI2wxli2xxPGSNsEhFPdmoi4KOKYM=;
        b=O3NKdYvTUMacAJvCo1JC0BjLG1I0Vwo6DNWBWDI35Vv5YqQqOeI/9qkdNY1LhezwuF
         M+sofmLRkmWezJ/wNjY7usP+C2aFDdABT6kYNKANmWQd1Vcoin34ycM6ZPIdoGgJy5oJ
         CRdC8U3K8i8wtAZf9wJOMAMziTZk1lm6Y77NFdxXUcV2EENlBAMK4M+zCYLdaS4L4p0r
         mLle946pmaaNd77tt+b0A5BTe0hPnYHMQqK4sqCzLD/7D+UJZvd2IC9NDt6Y290tzk9c
         fsOXJCfsCU5Xp5F6xuRZ6cM01hrLxJJhpXVb5Mtrg7UHo6Hsmn8YVAWnnEVsr3D6qfda
         oxbQ==
X-Gm-Message-State: AOAM532pNvL+FcBFyeyKhZokm3ueudrTF0kbr/wB/KqzQg84tZBOWdnR
        R7LYn2xWc74vjyh3SfsDbK/weFW3KI0=
X-Google-Smtp-Source: ABdhPJwSrvuZFuTQR8gnsEzL4qMWxRUG92/LyMVVFiF/Hx4kuwaeDWOt9/bu93e4/Qsb1/jq14QEpw==
X-Received: by 2002:a17:902:a416:: with SMTP id p22mr22796892plq.341.1595353590056;
        Tue, 21 Jul 2020 10:46:30 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id c14sm4598712pgb.1.2020.07.21.10.46.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2020 10:46:28 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net 3/6] ionic: fix up filter debug msgs
Date:   Tue, 21 Jul 2020 10:46:16 -0700
Message-Id: <20200721174619.39860-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721174619.39860-1-snelson@pensando.io>
References: <20200721174619.39860-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix up some of the debug messages around filter management.

Fixes: c1e329ebec8d ("ionic: Add management of rx filters")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 17 +++++++----------
 .../ethernet/pensando/ionic/ionic_rx_filter.c   |  1 +
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index f49486b6d04d..41e86d6b76b6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -863,8 +863,7 @@ static int ionic_lif_addr_add(struct ionic_lif *lif, const u8 *addr)
 	if (f)
 		return 0;
 
-	netdev_dbg(lif->netdev, "rx_filter add ADDR %pM (id %d)\n", addr,
-		   ctx.comp.rx_filter_add.filter_id);
+	netdev_dbg(lif->netdev, "rx_filter add ADDR %pM\n", addr);
 
 	memcpy(ctx.cmd.rx_filter_add.mac.addr, addr, ETH_ALEN);
 	err = ionic_adminq_post_wait(lif, &ctx);
@@ -893,6 +892,9 @@ static int ionic_lif_addr_del(struct ionic_lif *lif, const u8 *addr)
 		return -ENOENT;
 	}
 
+	netdev_dbg(lif->netdev, "rx_filter del ADDR %pM (id %d)\n",
+		   addr, f->filter_id);
+
 	ctx.cmd.rx_filter_del.filter_id = cpu_to_le32(f->filter_id);
 	ionic_rx_filter_free(lif, f);
 	spin_unlock_bh(&lif->rx_filters.lock);
@@ -901,9 +903,6 @@ static int ionic_lif_addr_del(struct ionic_lif *lif, const u8 *addr)
 	if (err && err != -EEXIST)
 		return err;
 
-	netdev_dbg(lif->netdev, "rx_filter del ADDR %pM (id %d)\n", addr,
-		   ctx.cmd.rx_filter_del.filter_id);
-
 	return 0;
 }
 
@@ -1351,13 +1350,11 @@ static int ionic_vlan_rx_add_vid(struct net_device *netdev, __be16 proto,
 	};
 	int err;
 
+	netdev_dbg(netdev, "rx_filter add VLAN %d\n", vid);
 	err = ionic_adminq_post_wait(lif, &ctx);
 	if (err)
 		return err;
 
-	netdev_dbg(netdev, "rx_filter add VLAN %d (id %d)\n", vid,
-		   ctx.comp.rx_filter_add.filter_id);
-
 	return ionic_rx_filter_save(lif, 0, IONIC_RXQ_INDEX_ANY, 0, &ctx);
 }
 
@@ -1382,8 +1379,8 @@ static int ionic_vlan_rx_kill_vid(struct net_device *netdev, __be16 proto,
 		return -ENOENT;
 	}
 
-	netdev_dbg(netdev, "rx_filter del VLAN %d (id %d)\n", vid,
-		   le32_to_cpu(ctx.cmd.rx_filter_del.filter_id));
+	netdev_dbg(netdev, "rx_filter del VLAN %d (id %d)\n",
+		   vid, f->filter_id);
 
 	ctx.cmd.rx_filter_del.filter_id = cpu_to_le32(f->filter_id);
 	ionic_rx_filter_free(lif, f);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
index cc2a6977081a..fb9d828812bd 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
@@ -128,6 +128,7 @@ int ionic_rx_filter_save(struct ionic_lif *lif, u32 flow_id, u16 rxq_index,
 	f->filter_id = le32_to_cpu(ctx->comp.rx_filter_add.filter_id);
 	f->rxq_index = rxq_index;
 	memcpy(&f->cmd, ac, sizeof(f->cmd));
+	netdev_dbg(lif->netdev, "rx_filter add filter_id %d\n", f->filter_id);
 
 	INIT_HLIST_NODE(&f->by_hash);
 	INIT_HLIST_NODE(&f->by_id);
-- 
2.17.1

