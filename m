Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1116DA6E8
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 03:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239001AbjDGBZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 21:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbjDGBZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 21:25:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DF4583C0
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 18:25:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F1F164C4A
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 01:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 085A0C433EF;
        Fri,  7 Apr 2023 01:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680830740;
        bh=36mKSDo7caAzw9MeOJgOqj/hZuogqtg0PSbH1x+7xik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FCbfNsdSpQcJRxC1G8qVTgKIeyYZV4EKYITVoYP8u2kyYn2ouYZZ9KCT1kM8fG/gE
         AvpAUWJh900UjPLp0ojtIPtyaSPEb3mqNBrhTErlzHDvfph3Tvup+WnXSRA40YwRr+
         B4vFCDlcyDq24VXhi9RuOmD7o+POQ5JBd8BTQ9C7EyVEHHJ6ECSuaVxfnPx7z9XiZd
         kQ8xVNvmmYQJZpFHPIwKvK0WVL1/ekkwKrOaUWiZeckp0dLUgOiAbA8jgx0uDGLE9u
         aY5UaIoRQHJjyuJFFBsy6P+vncDIEIddkTFGkx2zX5tghZ/1jdViR40P5400bMZZrE
         RFkp4Kxh9YdqQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        herbert@gondor.apana.org.au, alexander.duyck@gmail.com,
        hkallweit1@gmail.com, andrew@lunn.ch, willemb@google.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v4 1/7] docs: net: reformat driver.rst from a list to sections
Date:   Thu,  6 Apr 2023 18:25:30 -0700
Message-Id: <20230407012536.273382-2-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230407012536.273382-1-kuba@kernel.org>
References: <20230407012536.273382-1-kuba@kernel.org>
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

driver.rst had a historical form of list of common problems.
In the age os Sphinx and rendered documentation it's better
to use the more usual title + text format.

This will allow us to render kdoc into the output more naturally.

No changes to the actual text.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/driver.rst | 91 ++++++++++++++++++-----------
 1 file changed, 56 insertions(+), 35 deletions(-)

diff --git a/Documentation/networking/driver.rst b/Documentation/networking/driver.rst
index 64f7236ff10b..3040a74d421c 100644
--- a/Documentation/networking/driver.rst
+++ b/Documentation/networking/driver.rst
@@ -4,15 +4,19 @@
 Softnet Driver Issues
 =====================
 
-Transmit path guidelines:
+Transmit path guidelines
+========================
 
-1) The ndo_start_xmit method must not return NETDEV_TX_BUSY under
-   any normal circumstances.  It is considered a hard error unless
-   there is no way your device can tell ahead of time when its
-   transmit function will become busy.
+Stop queues in advance
+----------------------
 
-   Instead it must maintain the queue properly.  For example,
-   for a driver implementing scatter-gather this means::
+The ndo_start_xmit method must not return NETDEV_TX_BUSY under
+any normal circumstances.  It is considered a hard error unless
+there is no way your device can tell ahead of time when its
+transmit function will become busy.
+
+Instead it must maintain the queue properly.  For example,
+for a driver implementing scatter-gather this means::
 
 	static netdev_tx_t drv_hard_start_xmit(struct sk_buff *skb,
 					       struct net_device *dev)
@@ -42,56 +46,73 @@ Softnet Driver Issues
 		return NETDEV_TX_OK;
 	}
 
-   And then at the end of your TX reclamation event handling::
+And then at the end of your TX reclamation event handling::
 
 	if (netif_queue_stopped(dp->dev) &&
 	    TX_BUFFS_AVAIL(dp) > (MAX_SKB_FRAGS + 1))
 		netif_wake_queue(dp->dev);
 
-   For a non-scatter-gather supporting card, the three tests simply become::
+For a non-scatter-gather supporting card, the three tests simply become::
 
 		/* This is a hard error log it. */
 		if (TX_BUFFS_AVAIL(dp) <= 0)
 
-   and::
+and::
 
 		if (TX_BUFFS_AVAIL(dp) == 0)
 
-   and::
+and::
 
 	if (netif_queue_stopped(dp->dev) &&
 	    TX_BUFFS_AVAIL(dp) > 0)
 		netif_wake_queue(dp->dev);
 
-2) An ndo_start_xmit method must not modify the shared parts of a
-   cloned SKB.
+No exclusive ownership
+----------------------
+
+An ndo_start_xmit method must not modify the shared parts of a
+cloned SKB.
+
+Timely completions
+------------------
+
+Do not forget that once you return NETDEV_TX_OK from your
+ndo_start_xmit method, it is your driver's responsibility to free
+up the SKB and in some finite amount of time.
 
-3) Do not forget that once you return NETDEV_TX_OK from your
-   ndo_start_xmit method, it is your driver's responsibility to free
-   up the SKB and in some finite amount of time.
+For example, this means that it is not allowed for your TX
+mitigation scheme to let TX packets "hang out" in the TX
+ring unreclaimed forever if no new TX packets are sent.
+This error can deadlock sockets waiting for send buffer room
+to be freed up.
 
-   For example, this means that it is not allowed for your TX
-   mitigation scheme to let TX packets "hang out" in the TX
-   ring unreclaimed forever if no new TX packets are sent.
-   This error can deadlock sockets waiting for send buffer room
-   to be freed up.
+If you return NETDEV_TX_BUSY from the ndo_start_xmit method, you
+must not keep any reference to that SKB and you must not attempt
+to free it up.
 
-   If you return NETDEV_TX_BUSY from the ndo_start_xmit method, you
-   must not keep any reference to that SKB and you must not attempt
-   to free it up.
+Probing guidelines
+==================
 
-Probing guidelines:
+Address validation
+------------------
+
+Any hardware layer address you obtain for your device should
+be verified.  For example, for ethernet check it with
+linux/etherdevice.h:is_valid_ether_addr()
+
+Close/stop guidelines
+=====================
 
-1) Any hardware layer address you obtain for your device should
-   be verified.  For example, for ethernet check it with
-   linux/etherdevice.h:is_valid_ether_addr()
+Quiescence
+----------
 
-Close/stop guidelines:
+After the ndo_stop routine has been called, the hardware must
+not receive or transmit any data.  All in flight packets must
+be aborted. If necessary, poll or wait for completion of
+any reset commands.
 
-1) After the ndo_stop routine has been called, the hardware must
-   not receive or transmit any data.  All in flight packets must
-   be aborted. If necessary, poll or wait for completion of
-   any reset commands.
+Auto-close
+----------
 
-2) The ndo_stop routine will be called by unregister_netdevice
-   if device is still UP.
+The ndo_stop routine will be called by unregister_netdevice
+if device is still UP.
-- 
2.39.2

