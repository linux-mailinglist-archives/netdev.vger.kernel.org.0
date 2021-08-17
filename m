Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC153EE7C9
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 09:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234771AbhHQHuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 03:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234581AbhHQHue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 03:50:34 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1861FC0613CF
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 00:50:02 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id bo18so30943781pjb.0
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 00:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ypyY+Uqc+Z2ZZW93qVfCBhIjoZdHXKViPbFJWksLXyw=;
        b=y0aUVuz/yeYt7BmPU+7xx60nVGBhKtDUZ9a11XD6NZkbjOQtHktgAm3ilJKzATVNSh
         kp7TselkFN1llxjWnNzBVylouNVkXFmW2nuLMu4DQ6SFi0HCZkLy5S/rMFHYeBn/tkkL
         /7A9nep/b/LYXd0C2LiEgCEB+jU0Dq/eR9BK4L9TPW8FI9R0Sj+yQEvHJXEaC5wLELjC
         iQDlPctshevT/yVtmyyuC2++bSRpt++r7vmP8W+eqHNmVOl7+nLNm0zYlau4hKatmtQS
         jP9lbL/SzDyNIbOYu40zQfXca5hY8EiLhZwUteFE3/Z5wSR8Z3FtdTbpG8Axb7oJPUgS
         RdzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ypyY+Uqc+Z2ZZW93qVfCBhIjoZdHXKViPbFJWksLXyw=;
        b=fUHk7NOiw2BCBT+B3xhepv3cEcyFrePrCVbQh8lMhO1ITUeu8GyvvbgQbAtMivTMpH
         Mm2v8X3jhc2L/bGIPxQw2pbxm1oHTr/Y03z7t8arSHGYasR+TLC4QTneOyOPMMqbzGcy
         CxWwQ59K5U7tAVn2hd5mtg+bW/hVfu5nTmNmEVDwW6dIYrFL75aW64mgFvmwLtyuUTX8
         fzNIhOzoKUmeVQuY6vBYqRW0TCLBrQicibitfGrGyDQr5DP3UoMdvXk9m8P+qGX96jJX
         /wqhMHF9yrG+4JHMAa9l0kp8JotxWlvKnr1S+gHk3IUDQ6QVBARhsUNJQZMrrAuvR0+g
         ijzw==
X-Gm-Message-State: AOAM531wyHLGxO0UIz7Di3UhGiRhGkR7oErJyw/sv9SAzZahEEeAVZnr
        3l2MwXd2U/d4mFf63B4VnzSzDA==
X-Google-Smtp-Source: ABdhPJxohB+V28AAX2LBG8ktGbGUI5R9Gw48T01lK5QkYJp9yAH00JBLz/Nio11m9qnfjmBzemzB0g==
X-Received: by 2002:a62:dd83:0:b029:30f:d69:895f with SMTP id w125-20020a62dd830000b029030f0d69895fmr2400138pff.17.1629186601603;
        Tue, 17 Aug 2021 00:50:01 -0700 (PDT)
Received: from FVFX41FWHV2J.bytedance.net ([139.177.225.231])
        by smtp.gmail.com with ESMTPSA id w3sm1626031pfn.96.2021.08.17.00.49.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Aug 2021 00:50:01 -0700 (PDT)
From:   Feng zhou <zhoufeng.zf@bytedance.com>
To:     jesse.brandeburg@intel.co, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        jeffrey.t.kirsher@intel.com, magnus.karlsson@intel.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        duanxiongchun@bytedance.com, songmuchun@bytedance.com,
        zhouchengming@bytedance.com, chenying.kernel@bytedance.com,
        zhengqi.arch@bytedance.com, zhoufeng.zf@bytedance.com
Subject: [PATCH] ixgbe: Fix NULL pointer dereference in ixgbe_xdp_setup
Date:   Tue, 17 Aug 2021 15:49:47 +0800
Message-Id: <20210817074947.11555-1-zhoufeng.zf@bytedance.com>
X-Mailer: git-send-email 2.27.0
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
It becames 63.
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
lead to panic.
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

Fixes: 4a9b32f30f80 ("ixgbe: fix potential RX buffer starvation for
AF_XDP")
Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

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

