Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0B767C844
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 11:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236679AbjAZKRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 05:17:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236566AbjAZKRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 05:17:18 -0500
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77AD6AD16;
        Thu, 26 Jan 2023 02:16:47 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id CDA985C00DA;
        Thu, 26 Jan 2023 05:16:29 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 26 Jan 2023 05:16:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=umbraculum.org;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1674728189; x=1674814589; bh=s9W/9MyKgS
        isyN6zGHmrgn0Oipj/EtVibkHLYyeuDVc=; b=dsge6GPzRlw9MWF79ytfvya17Y
        BNMGKRZx18MwVo1hntKB9c7cYDONDTJroJUgYjoSSEEq9Upt0dSFkq9Ae7o1mQhq
        DSywSSlxjhLYa+J7mpNSgZ6J8lLqKKLNLI4i3rcW5hOXcCKm+mHv5WYgZ/Zj3lKO
        3MuHCpjmt4IlmhIWz+jrFwhwQ2uTvoIPdIG7zZFfLeAVpGle9UQHN5VhtYAOi9b0
        K3BfahIuiYxcltkguJ+r2AJ6YRrlqj5u/eV4gye4Qpg5wZXjjoUapnr/tZkUo0FI
        gFsUuk7U2pxz3ppnqAOWnpItq5weeVjpyDCeNHEI07HyD5JuI+3zdgbjDgXw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
        1674728189; x=1674814589; bh=s9W/9MyKgSisyN6zGHmrgn0Oipj/EtVibkH
        LYyeuDVc=; b=mh6+nV3SaPKHsK0aW9l5M77NSTJfGt5Uy4g5XjB0bDU0G+iU3WN
        V0ebS2sjZG3zlg3ANlcpUeZnPobLqIBz+oXdcKVUWFyuq6QpRPPoG8LYnw1esfNj
        42JKSjb28aGdyRd8C7FMUWApsXbsge6rXHyEMWd31+7gRU8GAFxVsWJpxZW5uDMn
        jgw/K3GAJlPGEzu8VS6tjE80xxKMYWy7285nmBCqcBEtkb6qEIYG8iuRcpMBvBUj
        EJ43BiVxqXbvIyFosoDT2GxMeQb2z+uNux4Qj8idp5IENx+pVHagirRwqgUYpo3U
        L81197OrSLeAanrlWqVYwh/WlINw4hfRl/Q==
X-ME-Sender: <xms:_FLSY2t1UfBzqMPy07pqW3KPYUFLC8F1xFKrZkqD0qK4GO5KpvCKcw>
    <xme:_FLSY7c8x9IRTk0Iu8R7aQOiQYfz7TpZ6_8OjJ8g3U75I7mOPFKSWjtGaM-u0Hy7W
    zIkdbw0wNlK70BUjQU>
X-ME-Received: <xmr:_FLSYxycdWGekEISM8g95bc4aqtPwXtwiTalAg-J0F04y-ovjpDKkXzRkBa2pxsSGofP8SpuejQH39lRNrdzaMABC9W6WyqWmHJcXA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedruddvgedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpeflohhnrghsucfuuhhhrhcuvehhrhhishhtvghnshgvnhcuoehj
    shgtsehumhgsrhgrtghulhhumhdrohhrgheqnecuggftrfgrthhtvghrnhepfeevgeeihf
    dttdefvdegleehffevveejgefhtefhhedvjeefudfgfeeigfelgfelnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepjhhstgesuhhmsghrrggtuh
    hluhhmrdhorhhg
X-ME-Proxy: <xmx:_FLSYxMMCKAvlGESrxNDxlfI-bdnwQP6kIg-Z8lpCwkOpgl3py9oEQ>
    <xmx:_FLSY2_6DTbOdQ2qQvdk2xxZAdAyMSwDHpGRLkOPrHUSP56T5BKKZg>
    <xmx:_FLSY5X3LTTts269_8OSf48XE47ij8px1HXHOech2cUCYtW4SixGdQ>
    <xmx:_VLSY6TDcx4sRirhqjxL03bR6AG1JZPmYBD16IABWhlYTO5i-B91_w>
Feedback-ID: i06314781:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 26 Jan 2023 05:16:25 -0500 (EST)
From:   Jonas Suhr Christensen <jsc@umbraculum.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, michal.simek@xilinx.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        esben@geanix.com, Jonas Suhr Christensen <jsc@umbraculum.org>
Subject: [PATCH 1/2] net: ll_temac: fix DMA resources leak
Date:   Thu, 26 Jan 2023 11:16:06 +0100
Message-Id: <20230126101607.88407-1-jsc@umbraculum.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing conversion of address when unmapping dma region causing
unmapping to silently fail. At some point resulting in buffer
overrun eg. when releasing device.

Signed-off-by: Jonas Suhr Christensen <jsc@umbraculum.org>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 1066420d6a83..66c04027f230 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -300,6 +300,7 @@ static void temac_dma_bd_release(struct net_device *ndev)
 {
 	struct temac_local *lp = netdev_priv(ndev);
 	int i;
+	struct cdmac_bd *bd;
 
 	/* Reset Local Link (DMA) */
 	lp->dma_out(lp, DMA_CONTROL_REG, DMA_CONTROL_RST);
@@ -307,9 +308,14 @@ static void temac_dma_bd_release(struct net_device *ndev)
 	for (i = 0; i < lp->rx_bd_num; i++) {
 		if (!lp->rx_skb[i])
 			break;
-		dma_unmap_single(ndev->dev.parent, lp->rx_bd_v[i].phys,
+
+		bd = &lp->rx_bd_v[1];
+		dma_unmap_single(ndev->dev.parent, be32_to_cpu(bd->phys),
 				 XTE_MAX_JUMBO_FRAME_SIZE, DMA_FROM_DEVICE);
+		bd->phys = 0;
+		bd->len = 0;
 		dev_kfree_skb(lp->rx_skb[i]);
+		lp->rx_skb[i] = NULL;
 	}
 	if (lp->rx_bd_v)
 		dma_free_coherent(ndev->dev.parent,
-- 
2.39.1

