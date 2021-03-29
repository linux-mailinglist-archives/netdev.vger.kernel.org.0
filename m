Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D77A34D3F3
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 17:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbhC2PbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 11:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbhC2Paz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 11:30:55 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 896E6C061574
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 08:30:54 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id g25so6862754wmh.0
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 08:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MSgFlM9sjDK43XxiaOvHTG7XVjCdNq2hxwfF6EGuwyc=;
        b=bDUTA8Zk4fT3Adk/5U6WLojLR2dBd6HlGFzEXvjLzyerEa+YL03zTnuj6t4aL4Ylp7
         tDEHEMDJq//KjgQos/NjVPGblMbRLsa9cmIKDOE8kpbKUk+LT/u8VRbUjfHdn0kcbwQK
         yjOd2gDs627lJjXQx2oyW70O5x0jXfrOdvg6gZC+WOI+s6I12xtE0FJeKf269ssponcP
         wLBGfo4TqZy7sayUM0/7C4H7xHB0XBGwhdWGB4aDF8FpOCjd4+2AhZhmTIKtc6+RzWAO
         FxK4afHy/pUXvKUOCMk6oQpvWxBNfk1W5lEot9M7nxSxuSh3gA+I1r02L7SpqLCw9wIz
         EHYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MSgFlM9sjDK43XxiaOvHTG7XVjCdNq2hxwfF6EGuwyc=;
        b=q+nwH3I6xEkx4TNSrF/RbSUJoc9iPEHwHznogDTka9zG92v/up4xhuDeJwdshDSzca
         wACsVDZiqFoN+9aelh2tc9v7q8bPl4Uh6CbY9ElN8A/IKvDF2VwFca3rk/GK4OEb7ODs
         0MYkigpPhPw2V8uTQLdWoEjdKrKma7TJxiHnl1Q026tPdADSGn8NACT66O7d/paF9QBE
         cLf/1mhT2KCb3ER67x89CuDGUgCX39AOqi7kXJX7yPWPlbbZUhFZYHIv3vEtCdTxnTBo
         RQZtSSBR3lmbOFtbPPIslKAlJYsL8r4/xjPc1zc+KiLBbD/D6/KgPESYekF4wQw0/T4r
         9zLA==
X-Gm-Message-State: AOAM5302NnzebI14KOtnne6yhkvGDj9jGHZeEaO/RdadJS2o/pWk7AXV
        SdXkxvlCVi9j9Qa8Ak/rzvXduQ==
X-Google-Smtp-Source: ABdhPJz48OXG2JmjM6I5d/rC7muwxowXCHXbMRsYmavTSezWgJPOKK8NTbuwINdpuCVgBz+AeFWt1w==
X-Received: by 2002:a1c:3d46:: with SMTP id k67mr25164888wma.188.1617031853058;
        Mon, 29 Mar 2021 08:30:53 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:e89:f257:8111:afb6])
        by smtp.gmail.com with ESMTPSA id p12sm29200976wrx.28.2021.03.29.08.30.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Mar 2021 08:30:52 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v3 2/2] net: mhi: Allow decoupled MTU/MRU
Date:   Mon, 29 Mar 2021 17:39:32 +0200
Message-Id: <1617032372-2387-2-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1617032372-2387-1-git-send-email-loic.poulain@linaro.org>
References: <1617032372-2387-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MBIM protocol makes the mhi network interface asymmetric, ingress data
received from MHI is MBIM protocol, possibly containing multiple
aggregated IP packets, while egress data received from network stack is
IP protocol.

This changes allows a 'protocol' to specify its own MRU, that when
specified is used to allocate MHI RX buffers (skb).

For MBIM, Set the default MTU to 1500, which is the usual network MTU
for WWAN IP packets, and MRU to 3.5K (for allocation efficiency),
allowing skb to fit in an usual 4K page (including padding,
skb_shared_info, ...).

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
  v2: squashed 1/2 and 1/2 (decoupled mtu/mru + mbim mru)
     Reduced MRU from 32k to 3.5K
  v3: no change

 drivers/net/mhi/mhi.h        |  1 +
 drivers/net/mhi/net.c        |  4 +++-
 drivers/net/mhi/proto_mbim.c | 11 +++++++++++
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/mhi/mhi.h b/drivers/net/mhi/mhi.h
index 12e7407..1d0c499 100644
--- a/drivers/net/mhi/mhi.h
+++ b/drivers/net/mhi/mhi.h
@@ -29,6 +29,7 @@ struct mhi_net_dev {
 	struct mhi_net_stats stats;
 	u32 rx_queue_sz;
 	int msg_enable;
+	unsigned int mru;
 };
 
 struct mhi_net_proto {
diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
index b1769fb..4bef7fe 100644
--- a/drivers/net/mhi/net.c
+++ b/drivers/net/mhi/net.c
@@ -270,10 +270,12 @@ static void mhi_net_rx_refill_work(struct work_struct *work)
 						      rx_refill.work);
 	struct net_device *ndev = mhi_netdev->ndev;
 	struct mhi_device *mdev = mhi_netdev->mdev;
-	int size = READ_ONCE(ndev->mtu);
 	struct sk_buff *skb;
+	unsigned int size;
 	int err;
 
+	size = mhi_netdev->mru ? mhi_netdev->mru : READ_ONCE(ndev->mtu);
+
 	while (!mhi_queue_is_full(mdev, DMA_FROM_DEVICE)) {
 		skb = netdev_alloc_skb(ndev, size);
 		if (unlikely(!skb))
diff --git a/drivers/net/mhi/proto_mbim.c b/drivers/net/mhi/proto_mbim.c
index 5a176c3..fc72b3f 100644
--- a/drivers/net/mhi/proto_mbim.c
+++ b/drivers/net/mhi/proto_mbim.c
@@ -26,6 +26,15 @@
 
 #define MBIM_NDP16_SIGN_MASK 0x00ffffff
 
+/* Usual WWAN MTU */
+#define MHI_MBIM_DEFAULT_MTU 1500
+
+/* 3500 allows to optimize skb allocation, the skbs will basically fit in
+ * one 4K page. Large MBIM packets will simply be split over several MHI
+ * transfers and chained by the MHI net layer (zerocopy).
+ */
+#define MHI_MBIM_DEFAULT_MRU 3500
+
 struct mbim_context {
 	u16 rx_seq;
 	u16 tx_seq;
@@ -281,6 +290,8 @@ static int mbim_init(struct mhi_net_dev *mhi_netdev)
 		return -ENOMEM;
 
 	ndev->needed_headroom = sizeof(struct mbim_tx_hdr);
+	ndev->mtu = MHI_MBIM_DEFAULT_MTU;
+	mhi_netdev->mru = MHI_MBIM_DEFAULT_MRU;
 
 	return 0;
 }
-- 
2.7.4

