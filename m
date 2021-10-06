Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5BFC424594
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 20:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239213AbhJFSG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 14:06:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232019AbhJFSGz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 14:06:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60CA661037;
        Wed,  6 Oct 2021 18:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633543503;
        bh=mphWiOSjWVve4063iT9iLB+Ae/xfjYf+gdyYkUHB2/Y=;
        h=Date:From:To:Cc:Subject:From;
        b=e9HZWeueYaTquf0esaeqBWa+qbUPx9RRyl1y3/SlMhT0F4LiGEEpruzhqsIcVOExJ
         Il5t2TN7bFbTG3YnDOEQA9+MCerGxYNZ0uZvYHehxgKy5syHlbYsfqhdaL67Nn0F9k
         8SLgZoM2/uewdLe3CLgkzhuN8aL16jj2x9Y/SjeugZQxhxTDGER6SSRg3q8nM41Bfn
         7BnIz/5DAGCpJo/QvWxZ5cmQ/mfAGvlBSNZOAfxHBvqPZOJz0lbxl6VkWlqC99gz6e
         UillWofcVuceyoH5OSO4cqbX4S+8sG6w3uX1L207aLtgyvwVF4fLR6uQaBUL+v6KHq
         082UUeqLM0iXA==
Date:   Wed, 6 Oct 2021 13:09:08 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] ice: use devm_kcalloc() instead of devm_kzalloc()
Message-ID: <20211006180908.GA913430@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use 2-factor multiplication argument form devm_kcalloc() instead
of devm_kzalloc().

Link: https://github.com/KSPP/linux/issues/162
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c | 4 ++--
 drivers/net/ethernet/intel/ice/ice_txrx.c         | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
index 16de603b280c..38960bcc384c 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
@@ -706,7 +706,7 @@ ice_create_init_fdir_rule(struct ice_pf *pf, enum ice_fltr_ptype flow)
 	if (!seg)
 		return -ENOMEM;
 
-	tun_seg = devm_kzalloc(dev, sizeof(*seg) * ICE_FD_HW_SEG_MAX,
+	tun_seg = devm_kcalloc(dev, sizeof(*seg), ICE_FD_HW_SEG_MAX,
 			       GFP_KERNEL);
 	if (!tun_seg) {
 		devm_kfree(dev, seg);
@@ -1068,7 +1068,7 @@ ice_cfg_fdir_xtrct_seq(struct ice_pf *pf, struct ethtool_rx_flow_spec *fsp,
 	if (!seg)
 		return -ENOMEM;
 
-	tun_seg = devm_kzalloc(dev, sizeof(*seg) * ICE_FD_HW_SEG_MAX,
+	tun_seg = devm_kcalloc(dev, sizeof(*seg), ICE_FD_HW_SEG_MAX,
 			       GFP_KERNEL);
 	if (!tun_seg) {
 		devm_kfree(dev, seg);
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 13b2bdc25b0d..fd10f8548feb 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -340,7 +340,7 @@ int ice_setup_tx_ring(struct ice_ring *tx_ring)
 	/* warn if we are about to overwrite the pointer */
 	WARN_ON(tx_ring->tx_buf);
 	tx_ring->tx_buf =
-		devm_kzalloc(dev, sizeof(*tx_ring->tx_buf) * tx_ring->count,
+		devm_kcalloc(dev, sizeof(*tx_ring->tx_buf), tx_ring->count,
 			     GFP_KERNEL);
 	if (!tx_ring->tx_buf)
 		return -ENOMEM;
@@ -464,7 +464,7 @@ int ice_setup_rx_ring(struct ice_ring *rx_ring)
 	/* warn if we are about to overwrite the pointer */
 	WARN_ON(rx_ring->rx_buf);
 	rx_ring->rx_buf =
-		devm_kzalloc(dev, sizeof(*rx_ring->rx_buf) * rx_ring->count,
+		devm_kcalloc(dev, sizeof(*rx_ring->rx_buf), rx_ring->count,
 			     GFP_KERNEL);
 	if (!rx_ring->rx_buf)
 		return -ENOMEM;
-- 
2.27.0

