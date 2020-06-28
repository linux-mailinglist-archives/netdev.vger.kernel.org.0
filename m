Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D1420CA35
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 21:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgF1Txq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 15:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbgF1Txp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 15:53:45 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06804C03E979;
        Sun, 28 Jun 2020 12:53:45 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id n26so571929ejx.0;
        Sun, 28 Jun 2020 12:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y+i0IcQsjWmXQ0Pd6Qvx5hq3ZReJQOfTWgZO3faohco=;
        b=kleefZaAJFV8BacB1VKjG3AIfuhS4INVMz6/+kI0fPD4iIM0g/IjeC3POUHOv6FTwN
         hNYo4XHTMBmsMVnuzlA07ubgWzBEss7GAvN6sgwk5ZJrwaa7YQvc1Ow0dfC9fJZXhoTI
         JXChNFwplDJFSK4qkvrhN2Mz1jd/uJNkGIrQ0rsWaX/SVrzI1VFOToURkM1NT01kzBPf
         ycX5Zjyxdm7nR56wNBqylO7ZDPkw4leKsLSayY3oeuQpcl5fWm8iZmsizD/E70nb1iNs
         AQZwNaKBoZdcPBTeXuequSmGotiabYM8ivVD0Y8JU8Sb0fbihOU8jkQY2rNvQJDLpEeX
         /SiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y+i0IcQsjWmXQ0Pd6Qvx5hq3ZReJQOfTWgZO3faohco=;
        b=sLA+j6+aP+r8NZ80vzy2tT9oxat2FiZn1SdVPTFba9XSNu13JVoFT1UtOeuarE4cUE
         WmlD8gLRyzwI1btu3FSz0MAsfTDKKUbdd8wxKvefE3QWyEHrSlrsDmYZQt4khiMWV0Bp
         CFU+dTttiCVLsd4YtkvVF7vfgJVvkoXIkYlYFtdZ+EWQfRCK70KRlgWd5sQY8T0OIuVO
         BzY9RgS+r6nC9o339CRlTkn374cqmj6vOJ0ge3kQe8AjUNVP8T8d+ILvt5NAT6tP4rU3
         MsMbwxbHzZRCFJ11j8FAdxREbo3jYBV9WDAliFx25+azypRw7bbxb0vIzfhGXvSmMIZU
         b+yg==
X-Gm-Message-State: AOAM532QIO3Sn6tX+PhSHuf6NID9pSxbBJTYD/J4N8jnBL037O3ucJCb
        YF994iml+LvjebWdq+4iJno=
X-Google-Smtp-Source: ABdhPJz1OupfKH5ObS1ezsMLqwdLjr4hCUvdfovj9vXUgcUJCtWnju4d2Luxvr/MiHaQiFsA/Ev1Fg==
X-Received: by 2002:a17:907:20b4:: with SMTP id pw20mr11656101ejb.225.1593374023577;
        Sun, 28 Jun 2020 12:53:43 -0700 (PDT)
Received: from localhost.localdomain ([2a02:a03f:b7f9:7600:f145:9a83:6418:5a5c])
        by smtp.gmail.com with ESMTPSA id z8sm15669531eju.106.2020.06.28.12.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 12:53:43 -0700 (PDT)
From:   Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@netronome.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: [PATCH 01/15] cail,hsi: fix cfhsi_xmit()'s return type
Date:   Sun, 28 Jun 2020 21:53:23 +0200
Message-Id: <20200628195337.75889-2-luc.vanoostenryck@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200628195337.75889-1-luc.vanoostenryck@gmail.com>
References: <20200628195337.75889-1-luc.vanoostenryck@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, but the implementation in this
driver returns an 'int'.

Fix this by returning 'netdev_tx_t' in this driver too and
returning NETDEV_TX_OK instead of 0 accordingly.

Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
---
 drivers/net/caif/caif_hsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/caif/caif_hsi.c b/drivers/net/caif/caif_hsi.c
index bbb2575d4728..4a33ec4fc089 100644
--- a/drivers/net/caif/caif_hsi.c
+++ b/drivers/net/caif/caif_hsi.c
@@ -1006,7 +1006,7 @@ static void cfhsi_aggregation_tout(struct timer_list *t)
 	cfhsi_start_tx(cfhsi);
 }
 
-static int cfhsi_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t cfhsi_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct cfhsi *cfhsi = NULL;
 	int start_xfer = 0;
@@ -1072,7 +1072,7 @@ static int cfhsi_xmit(struct sk_buff *skb, struct net_device *dev)
 		spin_unlock_bh(&cfhsi->lock);
 		if (aggregate_ready)
 			cfhsi_start_tx(cfhsi);
-		return 0;
+		return NETDEV_TX_OK;
 	}
 
 	/* Delete inactivity timer if started. */
@@ -1102,7 +1102,7 @@ static int cfhsi_xmit(struct sk_buff *skb, struct net_device *dev)
 			queue_work(cfhsi->wq, &cfhsi->wake_up_work);
 	}
 
-	return 0;
+	return NETDEV_TX_OK;
 }
 
 static const struct net_device_ops cfhsi_netdevops;
-- 
2.27.0

