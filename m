Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08E746D8AA1
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 00:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbjDEWcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 18:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232869AbjDEWcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 18:32:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D81B2719
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 15:32:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0483563CA9
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 22:32:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679E5C433EF;
        Wed,  5 Apr 2023 22:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680733923;
        bh=XylMkO0ZM7opGBGpW1+eWOkMczIFVC7JdTXkfP7gpyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gd1k/V00PIGiLjFxYyx/ni6xFGdETgOysgzMMufXHzwPRW3wLJv9wO2GWU24MaMR7
         atLDEOc5Qb47qXp2G/Padd03k6clvqARn3zC+r9Ekw/nCz/Mwlt6LInQA2uvCROdxb
         3ZmxoKRMTaq+oOFT2jILJ+nWlyB8AkKruaYPitU9GDw8rJSjXt0iu+so9VUJ/VLs6s
         9dmyQTvx/XE/L6ugQkw5zexDgIv1TybXnZIUPbrmWPSDz1swfcx0nQ26NBR93F958B
         u2NEJgHQb46UV2LR19jbsjJz9UltmzFam3xTmYo67OUuPmwH5ifBSuwNJasFKB2Jo3
         0NZMzp8iN66+A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        herbert@gondor.apana.org.au, alexander.duyck@gmail.com,
        hkallweit1@gmail.com, andrew@lunn.ch, willemb@google.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 3/7] docs: net: use C syntax highlight in driver.rst
Date:   Wed,  5 Apr 2023 15:31:30 -0700
Message-Id: <20230405223134.94665-4-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230405223134.94665-1-kuba@kernel.org>
References: <20230405223134.94665-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use syntax highlight, comment out the "..." since they are
not valid C.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/driver.rst | 30 +++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/Documentation/networking/driver.rst b/Documentation/networking/driver.rst
index bfbd66871bb3..19c363291d04 100644
--- a/Documentation/networking/driver.rst
+++ b/Documentation/networking/driver.rst
@@ -43,7 +43,9 @@ there is no way your device can tell ahead of time when its
 transmit function will become busy.
 
 Instead it must maintain the queue properly.  For example,
-for a driver implementing scatter-gather this means::
+for a driver implementing scatter-gather this means:
+
+.. code-block:: c
 
 	static netdev_tx_t drv_hard_start_xmit(struct sk_buff *skb,
 					       struct net_device *dev)
@@ -51,7 +53,7 @@ Instead it must maintain the queue properly.  For example,
 		struct drv *dp = netdev_priv(dev);
 
 		lock_tx(dp);
-		...
+		//...
 		/* This is a hard error log it. */
 		if (TX_BUFFS_AVAIL(dp) <= (skb_shinfo(skb)->nr_frags + 1)) {
 			netif_stop_queue(dev);
@@ -61,34 +63,42 @@ Instead it must maintain the queue properly.  For example,
 			return NETDEV_TX_BUSY;
 		}
 
-		... queue packet to card ...
-		... update tx consumer index ...
+		//... queue packet to card ...
+		//... update tx consumer index ...
 
 		if (TX_BUFFS_AVAIL(dp) <= (MAX_SKB_FRAGS + 1))
 			netif_stop_queue(dev);
 
-		...
+		//...
 		unlock_tx(dp);
-		...
+		//...
 		return NETDEV_TX_OK;
 	}
 
-And then at the end of your TX reclamation event handling::
+And then at the end of your TX reclamation event handling:
+
+.. code-block:: c
 
 	if (netif_queue_stopped(dp->dev) &&
 	    TX_BUFFS_AVAIL(dp) > (MAX_SKB_FRAGS + 1))
 		netif_wake_queue(dp->dev);
 
-For a non-scatter-gather supporting card, the three tests simply become::
+For a non-scatter-gather supporting card, the three tests simply become:
+
+.. code-block:: c
 
 		/* This is a hard error log it. */
 		if (TX_BUFFS_AVAIL(dp) <= 0)
 
-and::
+and:
+
+.. code-block:: c
 
 		if (TX_BUFFS_AVAIL(dp) == 0)
 
-and::
+and:
+
+.. code-block:: c
 
 	if (netif_queue_stopped(dp->dev) &&
 	    TX_BUFFS_AVAIL(dp) > 0)
-- 
2.39.2

