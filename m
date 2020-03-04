Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21254178844
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 03:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387469AbgCDC0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 21:26:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:56688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387397AbgCDC0f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 21:26:35 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6704820842;
        Wed,  4 Mar 2020 02:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583288794;
        bh=BsWeZ17pmIx7nJvpD5RcxoLF7ggfhrZMuVvO9BuLjlQ=;
        h=From:To:Cc:Subject:Date:From;
        b=S7pQ6MOPzOtXjxw3x0cMerIKCwm29JZnIy0s0/0Na55hUj9z/FVMobZvh87w/LGpi
         CieA+ItngB+5txg1I/K1ATcXpefrd8BEd9heeKTDJqeTV6OwJ1y97EkkCKDhBHTRQf
         7lmuK12rSJ8PaT/iB1SGaIR9it38Bhcey/bG3x/c=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] gianfar: remove unnecessary zeroing coalesce settings
Date:   Tue,  3 Mar 2020 18:26:12 -0800
Message-Id: <20200304022612.602957-1-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Core already zeroes out the struct ethtool_coalesce structure,
drivers don't have to set every field to 0 individually.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../net/ethernet/freescale/gianfar_ethtool.c  | 29 -------------------
 1 file changed, 29 deletions(-)

diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
index 3c8e4e2efc07..5fc8bc5e25c5 100644
--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -276,35 +276,6 @@ static int gfar_gcoalesce(struct net_device *dev,
 	cvals->tx_coalesce_usecs = gfar_ticks2usecs(priv, txtime);
 	cvals->tx_max_coalesced_frames = txcount;
 
-	cvals->use_adaptive_rx_coalesce = 0;
-	cvals->use_adaptive_tx_coalesce = 0;
-
-	cvals->pkt_rate_low = 0;
-	cvals->rx_coalesce_usecs_low = 0;
-	cvals->rx_max_coalesced_frames_low = 0;
-	cvals->tx_coalesce_usecs_low = 0;
-	cvals->tx_max_coalesced_frames_low = 0;
-
-	/* When the packet rate is below pkt_rate_high but above
-	 * pkt_rate_low (both measured in packets per second) the
-	 * normal {rx,tx}_* coalescing parameters are used.
-	 */
-
-	/* When the packet rate is (measured in packets per second)
-	 * is above pkt_rate_high, the {rx,tx}_*_high parameters are
-	 * used.
-	 */
-	cvals->pkt_rate_high = 0;
-	cvals->rx_coalesce_usecs_high = 0;
-	cvals->rx_max_coalesced_frames_high = 0;
-	cvals->tx_coalesce_usecs_high = 0;
-	cvals->tx_max_coalesced_frames_high = 0;
-
-	/* How often to do adaptive coalescing packet rate sampling,
-	 * measured in seconds.  Must not be zero.
-	 */
-	cvals->rate_sample_interval = 0;
-
 	return 0;
 }
 
-- 
2.24.1

