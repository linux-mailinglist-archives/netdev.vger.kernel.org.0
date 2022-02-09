Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7094AFA7D
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 19:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239695AbiBIShf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 13:37:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239786AbiBIShP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 13:37:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC2FC05CBB5;
        Wed,  9 Feb 2022 10:37:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AA9D61BAA;
        Wed,  9 Feb 2022 18:37:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61415C340E7;
        Wed,  9 Feb 2022 18:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644431830;
        bh=06AEE+dTILRtwDY8oQbRofaIwu30iB9WUEgyuAH6rvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lJLdHtCKCdfG4J9yy3VphtyUaZslzGK+1G6hP2P288TGsFtY3nTJJlAaAk9RsgKXM
         bdWumdDfkDEFKUm+Va4rmlEZxt2TUVniJF/mt0xgn0iN4VPjIwieBOX50CrK8o2Ft4
         ZD/m/MfhXr0xzbory/wl8e1RyUqy71suGD3BeRAkCQCL4ixYZ08UjspZDKw8VkiHIG
         iX+yFjzEIEJOIkKih4W9ikp/SjumtvNtGV7tyFMvHPY116j+S+zEQ9+/IeXut8HUjN
         GsDTNLvvE096O+XzXjqDYWtpa7gXjt51s64op6p+m8e7NGYk/vSJXmd5+WMKDi52A3
         71Bf3kmE24Emg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steen Hegelund <steen.hegelund@microchip.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        UNGLinuxDriver@microchip.com, bjarni.jonasson@microchip.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 35/42] net: sparx5: do not refer to skb after passing it on
Date:   Wed,  9 Feb 2022 13:33:07 -0500
Message-Id: <20220209183335.46545-35-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209183335.46545-1-sashal@kernel.org>
References: <20220209183335.46545-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steen Hegelund <steen.hegelund@microchip.com>

[ Upstream commit 81eb8b0b18789e647e65579303529fd52d861cc2 ]

Do not try to use any SKB fields after the packet has been passed up in the
receive stack.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
Link: https://lore.kernel.org/r/20220202083039.3774851-1-steen.hegelund@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_packet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
index dc7e5ea6ec158..148d431fcde42 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
@@ -145,9 +145,9 @@ static void sparx5_xtr_grp(struct sparx5 *sparx5, u8 grp, bool byte_swap)
 	skb_put(skb, byte_cnt - ETH_FCS_LEN);
 	eth_skb_pad(skb);
 	skb->protocol = eth_type_trans(skb, netdev);
-	netif_rx(skb);
 	netdev->stats.rx_bytes += skb->len;
 	netdev->stats.rx_packets++;
+	netif_rx(skb);
 }
 
 static int sparx5_inject(struct sparx5 *sparx5,
-- 
2.34.1

