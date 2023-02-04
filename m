Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15D7768AA43
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 14:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233828AbjBDNgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 08:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233751AbjBDNgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 08:36:38 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC18619F1E;
        Sat,  4 Feb 2023 05:36:35 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id nm12-20020a17090b19cc00b0022c2155cc0bso7356217pjb.4;
        Sat, 04 Feb 2023 05:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I7aOuN0Z7cOy5dqAaUiuywFRmsjtA1MOUQCg+0SjNXU=;
        b=hQQzKyaWdvmDukB36qd0U5WCkp30kIycSrZRPaiYB6pruSWlSVqjbWe4IfTgeuB0yR
         utHtWsyC5FHYj7jhdKBwoJt7BJcbWiTGic0/xWP98GLBGRBUmJrzQzo/KYU9ov/g9x7z
         SLTd07Li+6rqmJAx/49QJH7roZibn/7/Wt+ZfNuTPScFP9Rv1IilK/PIPG030I+Uj/xt
         ZuOYv6p2oYQbemS0aDa1ua+ujhyIoUgMXaRhkM2aqtctNEEX87Su3XdzhhV/plrSKja+
         k2QuO1K1OJfY+Rmy2lYd2MmOK9UB0vJ4LItB1FW0VW+t32TlgiRp63x4ucZQplmHA/Er
         eXIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I7aOuN0Z7cOy5dqAaUiuywFRmsjtA1MOUQCg+0SjNXU=;
        b=vwrzF7GdOdBFJJRrDFamJW77FAf4XpyKjfdMusdMcdsLNwbisjCTnZS14uyCC+LUr9
         /gY+H+SijioAk1Fv71SpVHfNky/vFkB62JGAFT0sUNyoIdbm5sdo2I20LShn+QwgsbdR
         XquHGFmULtoxYq+y45lNHET8VrZbIzWUUDVHyMUJqYCI9no0jHnZ003K7GX5dEQFovK1
         4wTI0B6A9LNYVn9esoAzYQgp4cXMQH0UjaUex5Yfk2y3J6M4KZl8hWu9mGsCNKvDFr5t
         NJ5fKDPUW5jO4t1DCARnJ9phjXk3/3BRv35saog348xHyZmkmYvwZBE5P71ceYp+LtcV
         KEKw==
X-Gm-Message-State: AO0yUKWZP7hWqkuy1z4ZBRteNPSOpe19BLKba8Yz6lV7au8Lm4tnXYJa
        acNx1STOL1Jb3DfKg6H6qQE=
X-Google-Smtp-Source: AK7set82L+r+w/YrVVuZAZANVizJHQi1In+ibQ/DGgzNViqqEPE3/I68sA2MSzKX5CKJXUzpeZXg7A==
X-Received: by 2002:a17:902:c792:b0:198:f13d:14d4 with SMTP id w18-20020a170902c79200b00198f13d14d4mr2096692pla.55.1675517795162;
        Sat, 04 Feb 2023 05:36:35 -0800 (PST)
Received: from KERNELXING-MB0.tencent.com ([114.253.32.172])
        by smtp.gmail.com with ESMTPSA id 21-20020a170902c25500b0019605a51d50sm3463575plg.61.2023.02.04.05.36.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 05:36:34 -0800 (PST)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        alexandr.lobakin@intel.com, maciej.fijalkowski@intel.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        kerneljasonxing@gmail.com, Jason Xing <kernelxing@tencent.com>
Subject: [PATCH net v3 1/3] ixgbe: allow to increase MTU to 3K with XDP enabled
Date:   Sat,  4 Feb 2023 21:35:33 +0800
Message-Id: <20230204133535.99921-2-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230204133535.99921-1-kerneljasonxing@gmail.com>
References: <20230204133535.99921-1-kerneljasonxing@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Xing <kernelxing@tencent.com>

Recently I encountered one case where I cannot increase the MTU size
directly from 1500 to a much bigger value with XDP enabled if the
server is equipped with IXGBE card, which happened on thousands of
servers in production environment. After appling the current patch,
we can set the maximum MTU size to 3K.

This patch follows the behavior of changing MTU as i40e/ice does.

Referrences:
[1] commit 23b44513c3e6 ("ice: allow 3k MTU for XDP")
[2] commit 0c8493d90b6b ("i40e: add XDP support for pass and drop actions")

Fixes: fabf1bce103a ("ixgbe: Prevent unsupported configurations with XDP")
Signed-off-by: Jason Xing <kernelxing@tencent.com>
---
v3:
1) modify the titile and body message.

v2:
1) change the commit message.
2) modify the logic when changing MTU size suggested by Maciej and Alexander.
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 25 ++++++++++++-------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index ab8370c413f3..2c1b6eb60436 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -6777,6 +6777,18 @@ static void ixgbe_free_all_rx_resources(struct ixgbe_adapter *adapter)
 			ixgbe_free_rx_resources(adapter->rx_ring[i]);
 }
 
+/**
+ * ixgbe_max_xdp_frame_size - returns the maximum allowed frame size for XDP
+ * @adapter - device handle, pointer to adapter
+ */
+static int ixgbe_max_xdp_frame_size(struct ixgbe_adapter *adapter)
+{
+	if (PAGE_SIZE >= 8192 || adapter->flags2 & IXGBE_FLAG2_RX_LEGACY)
+		return IXGBE_RXBUFFER_2K;
+	else
+		return IXGBE_RXBUFFER_3K;
+}
+
 /**
  * ixgbe_change_mtu - Change the Maximum Transfer Unit
  * @netdev: network interface device structure
@@ -6788,18 +6800,13 @@ static int ixgbe_change_mtu(struct net_device *netdev, int new_mtu)
 {
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 
-	if (adapter->xdp_prog) {
+	if (ixgbe_enabled_xdp_adapter(adapter)) {
 		int new_frame_size = new_mtu + ETH_HLEN + ETH_FCS_LEN +
 				     VLAN_HLEN;
-		int i;
-
-		for (i = 0; i < adapter->num_rx_queues; i++) {
-			struct ixgbe_ring *ring = adapter->rx_ring[i];
 
-			if (new_frame_size > ixgbe_rx_bufsz(ring)) {
-				e_warn(probe, "Requested MTU size is not supported with XDP\n");
-				return -EINVAL;
-			}
+		if (new_frame_size > ixgbe_max_xdp_frame_size(adapter)) {
+			e_warn(probe, "Requested MTU size is not supported with XDP\n");
+			return -EINVAL;
 		}
 	}
 
-- 
2.37.3

