Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B29D3098EB
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 00:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbhA3XuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 18:50:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232002AbhA3Xsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 18:48:37 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A23FC061756;
        Sat, 30 Jan 2021 15:47:55 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id l9so18613194ejx.3;
        Sat, 30 Jan 2021 15:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cxSfak/V43jKqWcO6/6SQQ+5yWV+HRDzMcHjvD41g54=;
        b=uxz6anzkuqOHZ/axAQOWNhrzh3/gFCvhu56kTjpD210Q7s4PpFZ1pSLRyNECjCXTWq
         r/pgJeBEgw2QLehfInddLOuB0QMBglGV5l/63EIp1uNeTcKuBcBmAQIv4o+XCKfhnbkK
         0mvMnpaBGPs0lueb8QLC/SakCdoNOldhbY8ok/dnP9iERYVG6gkBxCS526aOUpPhacaP
         C57EBXxoZWdiLDnm0vbTduo8YO+sAIHVI2f4DH4jWlgJr2OhswCy2L3/g+CkJ9hhbZvs
         w0JhWpAmQuM3bUM11ztARQh7SkbTzPbEVzb3W6vJaq3pg10sAFOgY3mjFj8ucVx1jI22
         1kOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=cxSfak/V43jKqWcO6/6SQQ+5yWV+HRDzMcHjvD41g54=;
        b=BoeEeMcKq2+KCgMJgUvxOVVoluTjVkTIpWTLKL7WIE/HsQzGIpPbzUy5gQ5xfn4I6b
         b9FNZgxTalsHN4CEbt2mgpCcxAIBDDccEHUXKCXvmr5wNR8yQGuicHQsXbReTIKLMfsG
         jQVDlzc4BTjr6ARBuKQRze4NqIlVnvhBbEyxV2Umsmp0IrcQT9v+Q3KmgUe9Bw669in6
         jBkvAqrJ05POR6enKL/77l10mAdmDc3mUJNpVm/YttjIJ0+iPaVQ3kCQZqwGC5VcKZUn
         IN4DmG/lLpyoUKHas9zCCM17wU5RKv0/frEYewiLO/YBvxnszv2jWVNsT2Mlm4Zh0FyW
         I/oQ==
X-Gm-Message-State: AOAM531eoo0oSx4ozDdtdT1t8bKaBjE1s2f6PtxT+mdNd8H6oOPlL/0E
        01cHKst4Mo7paOAhvTcwW/7zlCI6l4xHWJFE
X-Google-Smtp-Source: ABdhPJzpIZ7klZL3V2lxnJc2o27HrHtk93XeCrArdoVu/g6/UkjAF1Bh0O3bnuTPL2BF7rasRGrkWQ==
X-Received: by 2002:a17:907:7785:: with SMTP id ky5mr11296923ejc.176.1612050474133;
        Sat, 30 Jan 2021 15:47:54 -0800 (PST)
Received: from stitch.. ([80.71.140.73])
        by smtp.gmail.com with ESMTPSA id u17sm6628009edr.0.2021.01.30.15.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jan 2021 15:47:53 -0800 (PST)
Sender: Emil Renner Berthing <emil.renner.berthing@gmail.com>
From:   Emil Renner Berthing <kernel@esmil.dk>
To:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-ppp@vger.kernel.org
Cc:     Emil Renner Berthing <kernel@esmil.dk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Petko Manolov <petkan@nucleusys.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Oliver Neukum <oneukum@suse.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] ifb: use new tasklet API
Date:   Sun, 31 Jan 2021 00:47:24 +0100
Message-Id: <20210130234730.26565-4-kernel@esmil.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210130234730.26565-1-kernel@esmil.dk>
References: <20210130234730.26565-1-kernel@esmil.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This converts the driver to use the new tasklet API introduced in
commit 12cc923f1ccc ("tasklet: Introduce new initialization API")

Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
---
 drivers/net/ifb.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index fa63d4dee0ba..ab7022582154 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -59,9 +59,9 @@ static netdev_tx_t ifb_xmit(struct sk_buff *skb, struct net_device *dev);
 static int ifb_open(struct net_device *dev);
 static int ifb_close(struct net_device *dev);
 
-static void ifb_ri_tasklet(unsigned long _txp)
+static void ifb_ri_tasklet(struct tasklet_struct *t)
 {
-	struct ifb_q_private *txp = (struct ifb_q_private *)_txp;
+	struct ifb_q_private *txp = from_tasklet(txp, t, ifb_tasklet);
 	struct netdev_queue *txq;
 	struct sk_buff *skb;
 
@@ -170,8 +170,7 @@ static int ifb_dev_init(struct net_device *dev)
 		__skb_queue_head_init(&txp->tq);
 		u64_stats_init(&txp->rsync);
 		u64_stats_init(&txp->tsync);
-		tasklet_init(&txp->ifb_tasklet, ifb_ri_tasklet,
-			     (unsigned long)txp);
+		tasklet_setup(&txp->ifb_tasklet, ifb_ri_tasklet);
 		netif_tx_start_queue(netdev_get_tx_queue(dev, i));
 	}
 	return 0;
-- 
2.30.0

