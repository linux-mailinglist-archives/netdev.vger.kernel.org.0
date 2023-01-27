Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC3D67E50B
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 13:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233520AbjA0MXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 07:23:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234240AbjA0MWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 07:22:50 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6F87F693;
        Fri, 27 Jan 2023 04:20:26 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id m7-20020a17090a71c700b0022c0c070f2eso7773240pjs.4;
        Fri, 27 Jan 2023 04:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LLT1Nv3FsKGMyXLmpa+ThlcdDGK8ls8MWUnHvX54ufk=;
        b=H/A/5YZowQIRbQhn7LrdJgM3fSXHE4dLbYV2js9dGcDWk3J5c6Zmz4NIWQskDigE17
         bw9Q1PyqorE4xx5Hm5CvkH3r77hNYlZJnjKM4Ikv1TeqZuPFO2AL2lUe5HDKu+EaYs9R
         zCuz5dx81flK7bivAKOoWzkIvGmqKOKyzY6RfDJBJbe7aSm5ThV+ltB4lBVbEYr1R5yS
         6jI+PLuoqnxrNk6oCd9yexwPIwZd16pMS8Xc4WOhZUgHhV5ipd41qAJCdLteUdHyaVPQ
         G6Kf3o2QamOfmnhp/ch5ZeQhIcqcQl7SfOLEvfkniZrIaBP+Kik48xH1jgplegwrE3LR
         fIpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LLT1Nv3FsKGMyXLmpa+ThlcdDGK8ls8MWUnHvX54ufk=;
        b=X+r7cirXA93CWqiLQ5IJbNnLnvRd70l74ViNlwN9+tIXenv2DaA6DBIVUSHc7Bzb2I
         6Fwg60zG+TBHEztBWiu3eyI577Jy+fV1FU9ZxCZcpl8RYxwIjCTOB+x3kUZPdJ0n1ytJ
         C2ulMq5EJmsxlE0863qdCstMYfUHUa8u1sK3Pn0DO96vr/dv1COJ6w9awxMXiJsVrrv/
         VhR0/qJZMb6+XzwGppI1wlxYJrPpvZ21ZcAWGrvlJR3jMdhtjLrL1WNNhc9QKt7+7Cpt
         45N36zDHgadseBtKJa/MG+rIqUsi9sbcoV8d20sCYt3c14DyvaS0FW82D3h4Etn/uiat
         hwCg==
X-Gm-Message-State: AO0yUKWw89Co7FLh7+9mxKh8/hjM9W/G2DCXWZEXCieYWwl6yEjFATk7
        pbnDBTYQ3FzN79Ud1bQHZ0k=
X-Google-Smtp-Source: AK7set82V7nuhM/DZp31PjOW8pLz2TzfBZeTfHCbBHNMeYlsVOHaZWR2stNZ1kLzsMWNujdXcPJ+6g==
X-Received: by 2002:a17:903:2444:b0:196:15f6:bafc with SMTP id l4-20020a170903244400b0019615f6bafcmr13847684pls.47.1674822025876;
        Fri, 27 Jan 2023 04:20:25 -0800 (PST)
Received: from KERNELXING-MB0.tencent.com ([114.253.32.172])
        by smtp.gmail.com with ESMTPSA id d18-20020a170903231200b0019339f3368asm2762942plh.3.2023.01.27.04.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 04:20:25 -0800 (PST)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        alexandr.lobakin@intel.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        kerneljasonxing@gmail.com, Jason Xing <kernelxing@tencent.com>
Subject: [PATCH v2 net] ixgbe: allow to increase MTU to some extent with XDP enabled
Date:   Fri, 27 Jan 2023 20:20:18 +0800
Message-Id: <20230127122018.2839-1-kerneljasonxing@gmail.com>
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

I encountered one case where I cannot increase the MTU size directly
from 1500 to 2000 with XDP enabled if the server is equipped with
IXGBE card, which happened on thousands of servers in production
environment.

This patch follows the behavior of changing MTU as i40e/ice does.

Referrences:
commit 23b44513c3e6f ("ice: allow 3k MTU for XDP")
commit 0c8493d90b6bb ("i40e: add XDP support for pass and drop actions")

Link: https://lore.kernel.org/lkml/20230121085521.9566-1-kerneljasonxing@gmail.com/
Signed-off-by: Jason Xing <kernelxing@tencent.com>
---
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

