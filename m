Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD0B6822CC
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 04:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbjAaDYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 22:24:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbjAaDYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 22:24:50 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 715552DE51;
        Mon, 30 Jan 2023 19:24:49 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id f3so9146025pgc.2;
        Mon, 30 Jan 2023 19:24:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=I7aOuN0Z7cOy5dqAaUiuywFRmsjtA1MOUQCg+0SjNXU=;
        b=QLP6qnxqtTVUGl8ftH1gx2SHFDp02aveZTLQWaEOtDVIhjkRGUGKMk4EpnBNTjEMlk
         1rBuU1LF13nS12x7YzruzYDNrITQ50V3D9ZwxIu4okbxWH6j68pqU6HzH4d0mgMYblMi
         HOMRc4MZmxa1zygmqSMOatsw5R+MuyeIzSQpi0Ace2iJBsdIqOjuWrePd48IjOjX935U
         1Fplq+GekDXsYlncVjlLu2ia7+kYovFP9bJz/HTX+W4iKtHLgdnnmRaOdpF8rghpjDoV
         b6+BdmJPqzpfznLLxThiKt0XOAxz0eHB3wZan1KdmVHd9wSahApJzACHQucJ+R4LhFaP
         0zOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I7aOuN0Z7cOy5dqAaUiuywFRmsjtA1MOUQCg+0SjNXU=;
        b=w1p8ycQ3ZqPIc3d+9bMslPRTG194nErOUDWt5+g4ipG7vEpiWjxT5Drpw42dozRWOJ
         /QhRfsCjR5PdhRXpfw+gpwS3XJnVZ9/oJGnDiA+WHku/LOG6qVpL+txuaRG3V+WVp52a
         pGZiNnnA8PrfY605YbcY0/1i7HCA5PGYzkkRKN3c+E7lXdIfcyVGUZj1+qDmvJtXGFu7
         hkWqKyc/mJTkFi8Em7zv5RcaVQd2sFsCsH1jo4dZKctDeOY4Ov5anJmvrKjivFFjcjJU
         depERLLEXxkfv3TxYWPpel+PulTjhLPthr4/A8HCbhMAtoOc1WPa0+XjNly8EK2eXHn0
         T19Q==
X-Gm-Message-State: AO0yUKWVXn4kcmmZR//cTRUpWoYP8aWWNwuiHPdbEkAFw8hHEq3dByuU
        KiRHXPPEAYKQyCs5QhC8ei0=
X-Google-Smtp-Source: AK7set/B7wVZT+I5etpqA/nHbyamv863RRwrdx2lkYxVfeAJYa94pjlygbTNxMJtL7wq1rfDVeJNqQ==
X-Received: by 2002:a62:585:0:b0:590:32a9:b276 with SMTP id 127-20020a620585000000b0059032a9b276mr19003810pff.22.1675135488934;
        Mon, 30 Jan 2023 19:24:48 -0800 (PST)
Received: from KERNELXING-MB0.tencent.com ([103.7.29.31])
        by smtp.gmail.com with ESMTPSA id 189-20020a6215c6000000b005906dbf5f80sm8207545pfv.163.2023.01.30.19.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 19:24:48 -0800 (PST)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        alexandr.lobakin@intel.com, maciej.fijalkowski@intel.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        kerneljasonxing@gmail.com, Jason Xing <kernelxing@tencent.com>
Subject: [PATCH v3 net] ixgbe: allow to increase MTU to 3K with XDP enabled
Date:   Tue, 31 Jan 2023 11:23:57 +0800
Message-Id: <20230131032357.34029-1-kerneljasonxing@gmail.com>
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

