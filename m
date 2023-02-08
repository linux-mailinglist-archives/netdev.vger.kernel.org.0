Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D68268E62E
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 03:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjBHCoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 21:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjBHCoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 21:44:01 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29ED2138;
        Tue,  7 Feb 2023 18:44:00 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id h15so10396457plk.12;
        Tue, 07 Feb 2023 18:44:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=La3OH/wxxUC+XGiTFrGm7IEcXqspoaqeInslaM1lK3o=;
        b=HcoAEA6t13WP2R5z5xB0i39ady4K0zU6k1HBKc6Dmim0YBCX2HkUXoIAWMAfq5F9Ug
         u5AhG+Cs6exh7j7jEl/Y3nNbsc9ZUBZTaXwjijYD1HNxbRSkiWYv+qYshRdbS+Fn+RAQ
         It6Gkapc18/oiepO/BZ2sF5RwvwaeHuWHm+q2v9UG3u/nFG6UIGHpmFr9RwHjD6ympPG
         YVyxh6ucWUj5OBbrPXHKt3kAMRAyshdidtpcBF8z7+HK9YcrVjBXkK7upIkvDqcenTv0
         mVqcpBNaKF8wzGdE1+5A9CnjpsOvqy7WiYYPyXWKfXO1X3iOw8JaY8B7U7EHgc6Z7szK
         Pllw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=La3OH/wxxUC+XGiTFrGm7IEcXqspoaqeInslaM1lK3o=;
        b=zRfQNwM5d+Z3imZwgRBbOCDzD40ncMkEunOmZaW0GT64CLVHlwNsPtQrr/DK14lLiw
         dJqGoVW+5JWfl7tS2ln0Hg2bI0PxMpFe2Vpbm1MMtS0NY4anM1Hlixygo/Z+sxhYlCX1
         lhy4EPSmmemEMbG1RMQE0k05VwZWjAbpTiQpCN9sUo6CzojQm2mLiuFnhkvooLyrDpRk
         Iv2rR8YxJo0JAzxnWo4ZMPvywnrNVzlkHoypsaiETY8qiQa+eMkaiuwmrL28/hwr+eSa
         tOE8cdYk9Uo6KcwBKMeo9qnjr6Ib792fud6Vw4UoA6IGRQCD8HWXGMeX+F6iYNzpQnzv
         o3kw==
X-Gm-Message-State: AO0yUKXwrtwEIRxMUfEky/0MixJnvFMWKjihvrvbovltoT9l6bYRz2Pa
        KQrk9P9uuGlxBxPSN9Jyb7g=
X-Google-Smtp-Source: AK7set+g6t0zpDw6cZ6u3Ejsod7XXE0VcvWokhkIB7GAN6au/Bx55Hahcu7ysmaoaUwaCydcafhm1A==
X-Received: by 2002:a05:6a20:7d95:b0:bc:5f20:140d with SMTP id v21-20020a056a207d9500b000bc5f20140dmr6731933pzj.30.1675824240304;
        Tue, 07 Feb 2023 18:44:00 -0800 (PST)
Received: from KERNELXING-MB0.tencent.com ([103.7.29.31])
        by smtp.gmail.com with ESMTPSA id jk3-20020a170903330300b001960735c652sm9660835plb.169.2023.02.07.18.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 18:43:59 -0800 (PST)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        alexandr.lobakin@intel.com, maciej.fijalkowski@intel.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        kerneljasonxing@gmail.com, Jason Xing <kernelxing@tencent.com>
Subject: [PATCH net v4 1/3] ixgbe: allow to increase MTU to 3K with XDP enabled
Date:   Wed,  8 Feb 2023 10:43:32 +0800
Message-Id: <20230208024333.10465-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
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
v4:
1) use ':' instead of '-' for kdoc

v3:
1) modify the titile and body message.

v2:
1) change the commit message.
2) modify the logic when changing MTU size suggested by Maciej and Alexander.
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 25 ++++++++++++-------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index ab8370c413f3..25ca329f7d3c 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -6777,6 +6777,18 @@ static void ixgbe_free_all_rx_resources(struct ixgbe_adapter *adapter)
 			ixgbe_free_rx_resources(adapter->rx_ring[i]);
 }
 
+/**
+ * ixgbe_max_xdp_frame_size - returns the maximum allowed frame size for XDP
+ * @adapter: device handle, pointer to adapter
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

