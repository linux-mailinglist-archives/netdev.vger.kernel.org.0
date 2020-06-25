Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B152A20981D
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 03:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389143AbgFYBPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 21:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388789AbgFYBP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 21:15:29 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94996C061573;
        Wed, 24 Jun 2020 18:15:29 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id i14so4280364ejr.9;
        Wed, 24 Jun 2020 18:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LdePh6pYJbdEkhepk0j/2K/h7SmjiAvccJ3LBQIdXo0=;
        b=EfdBcaGsjgvmP2FUMHMt58WxokxZbIHRYmKPRbf+YYdH+96y0P4VN2H1T2MTRa+WkY
         P908qwI0KmMZjIKExvSEPXXgW6F0V5dzGehxsrgWQ4qjg3w0TjcmTOE3Vj4hKEnuQetD
         QBUkURYW6QSzCHT7xSxNKH6VvzzbLOSwVZeWKkrdyQj34BoTTLXIVdNCtJEDXvToKFV+
         OUbLLrgwa4UPn6e6nfV4EAcUJrK40eq61xpzdkaW/wpV7bJfIO6lpoEXoy58eOE7dS+d
         NuvxGyQmw1chFUnkkUQmtGciI2ZxY7+XQVPSFxBk+pD21NRDdiFErbm0vvZVA9oyOYnA
         sr8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LdePh6pYJbdEkhepk0j/2K/h7SmjiAvccJ3LBQIdXo0=;
        b=TRa0TF25A+jVCdIzZmm5mDNlMwQ2sNqDUq9FTnbwTiV1ZdxZ7F6pCGrHnf4D1XDR6r
         KGzhiznPftCJVUaVtL1Vjm9UJ9PmERRhRv4OXdTNx17vwCuBqOM36w4F9/nxO1HvVYkq
         wNeF9Vz4vcg9gQq3swYYsRR4P6T+gjaCJH+paCvrTA+VLHFOhHm6UH6r+VUTsRlY6vdN
         kX9usUBeEpM1D87QgoNEjr5uQmJOpfTiSUiSZjlgb3ptYxv3syblSI4kg1TLM8U/LiYb
         vro67Fg7QuQxO20oOXmLIXT1cLsMLsB5dNfjdiezxfBP1uSbNtwW6zr0TgPZbyo+eB5W
         3zUg==
X-Gm-Message-State: AOAM531UGzHgQmvWnYQvJylomDQcHm0jRcsvt4M9LnUtWxJG9Qs/gDF9
        WAnQ1XHS1B4aTtetEXLcWk8Bgc39
X-Google-Smtp-Source: ABdhPJzzsfAvp8rIuFz0HAOTSqWg4w+krqeIpFM5OiXIC5EIgtppBEbTVm+18O2xQPEj29wVq502Zg==
X-Received: by 2002:a17:907:2118:: with SMTP id qn24mr28704440ejb.252.1593047728303;
        Wed, 24 Jun 2020 18:15:28 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l24sm16080423ejb.5.2020.06.24.18.15.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jun 2020 18:15:27 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net 1/3] net: bcmgenet: re-remove bcmgenet_hfb_add_filter
Date:   Wed, 24 Jun 2020 18:14:53 -0700
Message-Id: <1593047695-45803-2-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593047695-45803-1-git-send-email-opendmb@gmail.com>
References: <1593047695-45803-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function was originally removed by Baoyou Xie in
commit e2072600a241 ("net: bcmgenet: remove unused function in
bcmgenet.c") to prevent a build warning.

Some of the functions removed by Baoyou Xie are now used for
WAKE_FILTER support so his commit was reverted, but this function
is still unused and the kbuild test robot dutifully reported the
warning.

This commit once again removes the remaining unused hfb functions.

Fixes: 14da1510fedc ("Revert "net: bcmgenet: remove unused function in bcmgenet.c"")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 77 --------------------------
 1 file changed, 77 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index ff31da0ed846..f1fa11665319 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -459,17 +459,6 @@ static inline void bcmgenet_rdma_ring_writel(struct bcmgenet_priv *priv,
 			genet_dma_ring_regs[r]);
 }
 
-static bool bcmgenet_hfb_is_filter_enabled(struct bcmgenet_priv *priv,
-					   u32 f_index)
-{
-	u32 offset;
-	u32 reg;
-
-	offset = HFB_FLT_ENABLE_V3PLUS + (f_index < 32) * sizeof(u32);
-	reg = bcmgenet_hfb_reg_readl(priv, offset);
-	return !!(reg & (1 << (f_index % 32)));
-}
-
 static void bcmgenet_hfb_enable_filter(struct bcmgenet_priv *priv, u32 f_index)
 {
 	u32 offset;
@@ -533,19 +522,6 @@ static void bcmgenet_hfb_set_filter_length(struct bcmgenet_priv *priv,
 	bcmgenet_hfb_reg_writel(priv, reg, offset);
 }
 
-static int bcmgenet_hfb_find_unused_filter(struct bcmgenet_priv *priv)
-{
-	u32 f_index;
-
-	/* First MAX_NUM_OF_FS_RULES are reserved for Rx NFC filters */
-	for (f_index = MAX_NUM_OF_FS_RULES;
-	     f_index < priv->hw_params->hfb_filter_cnt; f_index++)
-		if (!bcmgenet_hfb_is_filter_enabled(priv, f_index))
-			return f_index;
-
-	return -ENOMEM;
-}
-
 static int bcmgenet_hfb_validate_mask(void *mask, size_t size)
 {
 	while (size) {
@@ -744,59 +720,6 @@ static int bcmgenet_hfb_create_rxnfc_filter(struct bcmgenet_priv *priv,
 	return err;
 }
 
-/* bcmgenet_hfb_add_filter
- *
- * Add new filter to Hardware Filter Block to match and direct Rx traffic to
- * desired Rx queue.
- *
- * f_data is an array of unsigned 32-bit integers where each 32-bit integer
- * provides filter data for 2 bytes (4 nibbles) of Rx frame:
- *
- * bits 31:20 - unused
- * bit  19    - nibble 0 match enable
- * bit  18    - nibble 1 match enable
- * bit  17    - nibble 2 match enable
- * bit  16    - nibble 3 match enable
- * bits 15:12 - nibble 0 data
- * bits 11:8  - nibble 1 data
- * bits 7:4   - nibble 2 data
- * bits 3:0   - nibble 3 data
- *
- * Example:
- * In order to match:
- * - Ethernet frame type = 0x0800 (IP)
- * - IP version field = 4
- * - IP protocol field = 0x11 (UDP)
- *
- * The following filter is needed:
- * u32 hfb_filter_ipv4_udp[] = {
- *   Rx frame offset 0x00: 0x00000000, 0x00000000, 0x00000000, 0x00000000,
- *   Rx frame offset 0x08: 0x00000000, 0x00000000, 0x000F0800, 0x00084000,
- *   Rx frame offset 0x10: 0x00000000, 0x00000000, 0x00000000, 0x00030011,
- * };
- *
- * To add the filter to HFB and direct the traffic to Rx queue 0, call:
- * bcmgenet_hfb_add_filter(priv, hfb_filter_ipv4_udp,
- *                         ARRAY_SIZE(hfb_filter_ipv4_udp), 0);
- */
-int bcmgenet_hfb_add_filter(struct bcmgenet_priv *priv, u32 *f_data,
-			    u32 f_length, u32 rx_queue)
-{
-	int f_index;
-
-	f_index = bcmgenet_hfb_find_unused_filter(priv);
-	if (f_index < 0)
-		return -ENOMEM;
-
-	if (f_length > priv->hw_params->hfb_filter_size)
-		return -EINVAL;
-
-	bcmgenet_hfb_set_filter(priv, f_data, f_length, rx_queue, f_index);
-	bcmgenet_hfb_enable_filter(priv, f_index);
-
-	return 0;
-}
-
 /* bcmgenet_hfb_clear
  *
  * Clear Hardware Filter Block and disable all filtering.
-- 
2.7.4

