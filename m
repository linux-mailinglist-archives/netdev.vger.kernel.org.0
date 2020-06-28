Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320F120CA27
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 21:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgF1Tyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 15:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbgF1Txy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 15:53:54 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB4BC03E979;
        Sun, 28 Jun 2020 12:53:53 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id l12so14487870ejn.10;
        Sun, 28 Jun 2020 12:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9BW29cs15R7y24DB/D3twWfQ+LOvEc1Her+NuICftwA=;
        b=jEp23vW6KqKRrqBQt/cX+MQTam12WQdL1AQyBuNgvxSEDoWq2Ph1w4MmYxIe6XS4/7
         +G5amB/Ru/D/ANYRS82Y8AunF0lkNwKgNNItKGiTaDy1Q0GD//TnAlOzwsQHO+F6sVix
         eYAZz6y37wjr4RW5NWZJAKyE5Rakuc7c5/U727n48Uy/jT6kWm3tX8k8hYnPn65W5x9t
         PBDUCras2XJ51sPocXMFT6bKdChBPpTYPU88W76lpYbbJcxRM/H6IqXm2mr3B7cmlKMH
         54FHdyWSIR7iBa6IVUAl1XaJQ/EctrbC8j/ZUDINfjJC7KS+PU8ORT5SQnU2tMROec8a
         owbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9BW29cs15R7y24DB/D3twWfQ+LOvEc1Her+NuICftwA=;
        b=DalvYHApuNNv8Qc4e0V6GBQTXpm0X+L4sj0TBObRAwV9RaBNrzC7cvG6nBzpUgoSZX
         VweMg75fg1Mv2pskeF0lhAvZVXrpwE5tsVWJMYUcKJ8Sg7d+d6FLXeXbQJJo8C/vRETH
         h/5fKaRsNQlP84zUUL2b2XoxCjChir0cnSqVvRJ8PKxAIBPRlHgPblUCrRk+neTu34I+
         g1b3C5nQJ7UXGoirZ+Eif9aXNvetiVaw1WuepW0oTALUe5pyhLjWuBB6dznKYb/Iox9i
         Aro8qiYWfhcAUdcXOoR15ggsUJ1nI37PZ/AAWlwbKPayTtbuktqWDGT7aPrGRtmBNyhH
         HD0Q==
X-Gm-Message-State: AOAM531GMU1IEQGf+JNxC3HzCeHQWa88SR8KOivGxSW7u9tDvxdo2bB2
        WyRT1+mcs94Xsw4yNffgvbU=
X-Google-Smtp-Source: ABdhPJxljGTAylajN15yJTYN/mmctJCm+3Mk4kmPFb6iW2GTymn73lHe735BvC/L9+y0wS0ICXjfiA==
X-Received: by 2002:a17:906:8417:: with SMTP id n23mr11119322ejx.192.1593374032709;
        Sun, 28 Jun 2020 12:53:52 -0700 (PDT)
Received: from localhost.localdomain ([2a02:a03f:b7f9:7600:f145:9a83:6418:5a5c])
        by smtp.gmail.com with ESMTPSA id z8sm15669531eju.106.2020.06.28.12.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 12:53:52 -0700 (PDT)
From:   Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@netronome.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: [PATCH 09/15] net: pch_gbe: fix pch_gbe_xmit_frame()'s return type
Date:   Sun, 28 Jun 2020 21:53:31 +0200
Message-Id: <20200628195337.75889-10-luc.vanoostenryck@gmail.com>
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

Fix this by returning 'netdev_tx_t' in this driver too.

Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
---
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 73ec195fbc30..23f7c76737c9 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -2064,7 +2064,7 @@ static int pch_gbe_stop(struct net_device *netdev)
  *	- NETDEV_TX_OK:   Normal end
  *	- NETDEV_TX_BUSY: Error end
  */
-static int pch_gbe_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
+static netdev_tx_t pch_gbe_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
 {
 	struct pch_gbe_adapter *adapter = netdev_priv(netdev);
 	struct pch_gbe_tx_ring *tx_ring = adapter->tx_ring;
-- 
2.27.0

