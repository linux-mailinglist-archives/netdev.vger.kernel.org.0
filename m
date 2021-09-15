Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C9840C012
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 09:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236541AbhIOHGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 03:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbhIOHGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 03:06:12 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C0CC061574
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 00:04:53 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id q22so1915441pfu.0
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 00:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2BWdhdicOR1qL0nUDLFCT++AnjlBgHiscLfuhjIbVtc=;
        b=teTMxolm7LhP6awEeeU3sKPcpdQ8IwvuUlEY5G3V2dVsLf3l0kXtAHDDZfnhB/xBLs
         0tQ5wfNt/7bqAjz3QK6dHICopSLvOQTTgxAP4fWp48NLNhTts8Ec9dgM1wOVDnQ3SwCL
         62nlkf+DqGQ86/PEijrh9mFZNyhiPzxJyIrzxJ5rHZKR2TBIyKl+Alwo5hiGPJPEiB5J
         g7TrC93KdA1xPeYBWF36wwLhc/CY7DE7w9qCJlkVuT7r+dN8jEGTWuC+r58pKlS6yLNO
         v518QxpJ8MoYVYOFTmlsyIvJYeuqS3iw0zk1h1ZtmLEsOEv6mA+yWCl41Bc7QY8rT/qK
         +2lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2BWdhdicOR1qL0nUDLFCT++AnjlBgHiscLfuhjIbVtc=;
        b=xUh3QX5w6tXY8CfsNhtz1e3x1RplzVCmRPpYAoK+AqSWkpAfueoNtHbiHsCw4NBlli
         Cp/rURteDCDs9ZgFSAi8HWEG1ZbVqsByEndazWE/4QsJqpskg0r6pWQ+WXKoxrfLv4Of
         cXMoQx+x2TcXSEkW6yFGtE2BIJlpUlf/wAbmmilKEsxkVXd9TkxpgMk9poOwuyGMEdo5
         foL4Dr2j5rlt6R0BxmLioJOS4cu/OXRvimUWzkWOQjcH4mok3zEP9G2m2axrb7KsI1ab
         +g+76vEYH670AKPl3cgNlDvTuAk5l5Fkr+b3FEa6EjMm5yZaMN8XRc+MBrBWcTM29BEM
         BMtA==
X-Gm-Message-State: AOAM532yeWYa9K7mWARokNQeMBBcfWOfJg7Qmf9WNOTNzUHgjA3II0KF
        A+eGCVet4OR7LWGfVzSZ6rL39w==
X-Google-Smtp-Source: ABdhPJxP5vXMShjKBRCkNc71Ozvp3iP6RY6OfumaxCx0NalgMg5dpxxYkJchi6kulDztfPbyucxGfw==
X-Received: by 2002:a63:4610:: with SMTP id t16mr19179215pga.176.1631689493251;
        Wed, 15 Sep 2021 00:04:53 -0700 (PDT)
Received: from C02F52LSML85.bytedance.net ([139.177.225.251])
        by smtp.gmail.com with ESMTPSA id s192sm14079655pgc.23.2021.09.15.00.04.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Sep 2021 00:04:52 -0700 (PDT)
From:   Feng zhou <zhoufeng.zf@bytedance.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        jeffrey.t.kirsher@intel.com, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        duanxiongchun@bytedance.com, songmuchun@bytedance.com,
        zhouchengming@bytedance.com, chenying.kernel@bytedance.com,
        zhengqi.arch@bytedance.com, wangdongdong.6@bytedance.com,
        zhoufeng.zf@bytedance.com
Subject: [PATCH v3] ixgbe: Fix NULL pointer dereference in ixgbe_xdp_setup
Date:   Wed, 15 Sep 2021 15:04:40 +0800
Message-Id: <20210915070440.6540-1-zhoufeng.zf@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Feng Zhou <zhoufeng.zf@bytedance.com>

The ixgbe driver currently generates a NULL pointer dereference with
some machine (online cpus < 63). This is due to the fact that the
maximum value of num_xdp_queues is nr_cpu_ids. Code is in
"ixgbe_set_rss_queues"".

Here's how the problem repeats itself:
Some machine (online cpus < 63), And user set num_queues to 63 through
ethtool. Code is in the "ixgbe_set_channels",
	adapter->ring_feature[RING_F_FDIR].limit = count;

It becomes 63.

When user use xdp, "ixgbe_set_rss_queues" will set queues num.
	adapter->num_rx_queues = rss_i;
	adapter->num_tx_queues = rss_i;
	adapter->num_xdp_queues = ixgbe_xdp_queues(adapter);

And rss_i's value is from
	f = &adapter->ring_feature[RING_F_FDIR];
	rss_i = f->indices = f->limit;

So "num_rx_queues" > "num_xdp_queues", when run to "ixgbe_xdp_setup",
	for (i = 0; i < adapter->num_rx_queues; i++)
		if (adapter->xdp_ring[i]->xsk_umem)

It leads to panic.

Call trace:
[exception RIP: ixgbe_xdp+368]
RIP: ffffffffc02a76a0  RSP: ffff9fe16202f8d0  RFLAGS: 00010297
RAX: 0000000000000000  RBX: 0000000000000020  RCX: 0000000000000000
RDX: 0000000000000000  RSI: 000000000000001c  RDI: ffffffffa94ead90
RBP: ffff92f8f24c0c18   R8: 0000000000000000   R9: 0000000000000000
R10: ffff9fe16202f830  R11: 0000000000000000  R12: ffff92f8f24c0000
R13: ffff9fe16202fc01  R14: 000000000000000a  R15: ffffffffc02a7530
ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 7 [ffff9fe16202f8f0] dev_xdp_install at ffffffffa89fbbcc
 8 [ffff9fe16202f920] dev_change_xdp_fd at ffffffffa8a08808
 9 [ffff9fe16202f960] do_setlink at ffffffffa8a20235
10 [ffff9fe16202fa88] rtnl_setlink at ffffffffa8a20384
11 [ffff9fe16202fc78] rtnetlink_rcv_msg at ffffffffa8a1a8dd
12 [ffff9fe16202fcf0] netlink_rcv_skb at ffffffffa8a717eb
13 [ffff9fe16202fd40] netlink_unicast at ffffffffa8a70f88
14 [ffff9fe16202fd80] netlink_sendmsg at ffffffffa8a71319
15 [ffff9fe16202fdf0] sock_sendmsg at ffffffffa89df290
16 [ffff9fe16202fe08] __sys_sendto at ffffffffa89e19c8
17 [ffff9fe16202ff30] __x64_sys_sendto at ffffffffa89e1a64
18 [ffff9fe16202ff38] do_syscall_64 at ffffffffa84042b9
19 [ffff9fe16202ff50] entry_SYSCALL_64_after_hwframe at ffffffffa8c0008c

So I fix ixgbe_max_channels so that it will not allow a setting of queues 
to be higher than the num_online_cpus(). And when run to ixgbe_xdp_setup, 
take the smaller value of num_rx_queues and num_xdp_queues.

Fixes: 4a9b32f30f80 ("ixgbe: fix potential RX buffer starvation for
AF_XDP")
Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
---
v1:
- Fix "ixgbe_max_channels" callback so that it will not allow a setting of 
queues to be higher than the num_online_cpus().
v2:
- Modify commit message
more details can be seen from here:
https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20210817075407.11961-1-zhoufeng.zf@bytedance.com/
https://lore.kernel.org/netdev/20210903064013.9842-1-zhoufeng.zf@bytedance.com/
Thanks to Maciej Fijalkowski and Paul Menzel for yours advice.

 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c | 2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c    | 8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index 4ceaca0f6ce3..21321d164708 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -3204,7 +3204,7 @@ static unsigned int ixgbe_max_channels(struct ixgbe_adapter *adapter)
 		max_combined = ixgbe_max_rss_indices(adapter);
 	}
 
-	return max_combined;
+	return min_t(int, max_combined, num_online_cpus());
 }
 
 static void ixgbe_get_channels(struct net_device *dev,
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 14aea40da50f..5db496cc5070 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -10112,6 +10112,7 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
 	struct ixgbe_adapter *adapter = netdev_priv(dev);
 	struct bpf_prog *old_prog;
 	bool need_reset;
+	int num_queues;
 
 	if (adapter->flags & IXGBE_FLAG_SRIOV_ENABLED)
 		return -EINVAL;
@@ -10161,11 +10162,14 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
 	/* Kick start the NAPI context if there is an AF_XDP socket open
 	 * on that queue id. This so that receiving will start.
 	 */
-	if (need_reset && prog)
-		for (i = 0; i < adapter->num_rx_queues; i++)
+	if (need_reset && prog) {
+		num_queues = min_t(int, adapter->num_rx_queues,
+			adapter->num_xdp_queues);
+		for (i = 0; i < num_queues; i++)
 			if (adapter->xdp_ring[i]->xsk_pool)
 				(void)ixgbe_xsk_wakeup(adapter->netdev, i,
 						       XDP_WAKEUP_RX);
+	}
 
 	return 0;
 }
-- 
2.11.0

