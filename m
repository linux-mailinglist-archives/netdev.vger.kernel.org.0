Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55A7B148D38
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 18:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390923AbgAXRqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 12:46:45 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:37213 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390840AbgAXRqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 12:46:44 -0500
Received: by mail-pj1-f67.google.com with SMTP id m13so151645pjb.2
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 09:46:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FbgVN4/5MyPLoaJrZsZSpus64rGfXVYVvuI4dUu/fO4=;
        b=nAd7csHjbul/3bWwkrvG0xuAi/2NtQBpNa+8xjrJjLJu/0TJvrQG2BCUQJTBvQxMNx
         cpOWjnSpQkGxakb1MzJhOz/R8UBI+zcoOFrmCDqVtjKFZ3PLjOH7PQVDfbFPYhiqot9h
         dzL9WnZE/Fgrxoqrc3+Mtd/Z6gNwjO9TmIXVn8qqwLeFpttk2VIJF1Nz2zZYKDymWsmH
         Oaj6dNsxPYxejcYLAD/e59VaJ2sovfrFlCKJ3l58M71RLto6SQwhU77JJu+CBK/8HqHm
         MYeLYp3wD/OHbJAb4Veo2wm48GOF/UoRHxvCjW4I6dB9JBSH+s8oDet6sXA/UakfbmwA
         PAOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FbgVN4/5MyPLoaJrZsZSpus64rGfXVYVvuI4dUu/fO4=;
        b=iUCvk60+v/3Vidy0NnQOJh9EXRTzkhxVw41ImqkOoa4K1VxEao3B4lA+8DYTRhyipd
         /kMYvXEd2/u456+5tNt3+XdMnR7v1DsQRWuu9KU4LuzopHcuYD1Gl+8LRB3tlqdWDaUE
         HfVOPsR8WDp1R7hIMZqQzuvtsIPDxDmenIAN7YlPNrzLxhP6Pjtoo2X09+VG+lFcd2hp
         vqDksAxefu7EP58/QrJTB+yWOdHuxpTk+4Dcds9QomJGOBrVJuYvRDqO1xfK9jaqNGq+
         MkJCF4kY8xMHQjUmVyukrwwzhFqlE/ss4QdOXqgUcp9E/aH4qZ/NJz4CmezTciedI0dB
         zbOA==
X-Gm-Message-State: APjAAAUI8s6o1DOqbeQdukmnJYxgnWZmXdrp8PDOhdn1GsPLxd5aE2sn
        yNZTplRyFyyPXHm6dhkyJpTNbukXa+8=
X-Google-Smtp-Source: APXvYqwZ5NhjhmCkB1HBVfZZ3C0bkpX+YTh6iirzT4YFy7CpHjbH9DiSotVvNIJEpTKHp+iVpjl4hA==
X-Received: by 2002:a17:90a:234f:: with SMTP id f73mr361686pje.109.1579888003636;
        Fri, 24 Jan 2020 09:46:43 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id w11sm7310849pgs.60.2020.01.24.09.46.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 24 Jan 2020 09:46:43 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kubakici@wp.pl, mkubecek@suse.cz,
        maciej.fijalkowski@intel.com, Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v5 13/17] octeontx2-pf: Add ndo_get_stats64
Date:   Fri, 24 Jan 2020 23:15:51 +0530
Message-Id: <1579887955-22172-14-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1579887955-22172-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1579887955-22172-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

Added ndo_get_stats64 which returns stats maintained by HW.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 47 +++++++++++++++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   | 49 ++++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  1 +
 3 files changed, 97 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index c674171..c4be787 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -16,6 +16,53 @@
 #include "otx2_common.h"
 #include "otx2_struct.h"
 
+void otx2_get_dev_stats(struct otx2_nic *pfvf)
+{
+	struct otx2_dev_stats *dev_stats = &pfvf->hw.dev_stats;
+
+#define OTX2_GET_RX_STATS(reg) \
+	 otx2_read64(pfvf, NIX_LF_RX_STATX(reg))
+#define OTX2_GET_TX_STATS(reg) \
+	 otx2_read64(pfvf, NIX_LF_TX_STATX(reg))
+
+	dev_stats->rx_bytes = OTX2_GET_RX_STATS(RX_OCTS);
+	dev_stats->rx_drops = OTX2_GET_RX_STATS(RX_DROP);
+	dev_stats->rx_bcast_frames = OTX2_GET_RX_STATS(RX_BCAST);
+	dev_stats->rx_mcast_frames = OTX2_GET_RX_STATS(RX_MCAST);
+	dev_stats->rx_ucast_frames = OTX2_GET_RX_STATS(RX_UCAST);
+	dev_stats->rx_frames = dev_stats->rx_bcast_frames +
+			       dev_stats->rx_mcast_frames +
+			       dev_stats->rx_ucast_frames;
+
+	dev_stats->tx_bytes = OTX2_GET_TX_STATS(TX_OCTS);
+	dev_stats->tx_drops = OTX2_GET_TX_STATS(TX_DROP);
+	dev_stats->tx_bcast_frames = OTX2_GET_TX_STATS(TX_BCAST);
+	dev_stats->tx_mcast_frames = OTX2_GET_TX_STATS(TX_MCAST);
+	dev_stats->tx_ucast_frames = OTX2_GET_TX_STATS(TX_UCAST);
+	dev_stats->tx_frames = dev_stats->tx_bcast_frames +
+			       dev_stats->tx_mcast_frames +
+			       dev_stats->tx_ucast_frames;
+}
+
+void otx2_get_stats64(struct net_device *netdev,
+		      struct rtnl_link_stats64 *stats)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+	struct otx2_dev_stats *dev_stats;
+
+	otx2_get_dev_stats(pfvf);
+
+	dev_stats = &pfvf->hw.dev_stats;
+	stats->rx_bytes = dev_stats->rx_bytes;
+	stats->rx_packets = dev_stats->rx_frames;
+	stats->rx_dropped = dev_stats->rx_drops;
+	stats->multicast = dev_stats->rx_mcast_frames;
+
+	stats->tx_bytes = dev_stats->tx_bytes;
+	stats->tx_packets = dev_stats->tx_frames;
+	stats->tx_dropped = dev_stats->tx_drops;
+}
+
 /* Sync MAC address with RVU AF */
 static int otx2_hw_set_mac_addr(struct otx2_nic *pfvf, u8 *mac)
 {
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 760f3db..2187ff1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -81,6 +81,49 @@ enum otx2_errcodes_re {
 	ERRCODE_IL4_CSUM = 0x22,
 };
 
+/* NIX TX stats */
+enum nix_stat_lf_tx {
+	TX_UCAST	= 0x0,
+	TX_BCAST	= 0x1,
+	TX_MCAST	= 0x2,
+	TX_DROP		= 0x3,
+	TX_OCTS		= 0x4,
+	TX_STATS_ENUM_LAST,
+};
+
+/* NIX RX stats */
+enum nix_stat_lf_rx {
+	RX_OCTS		= 0x0,
+	RX_UCAST	= 0x1,
+	RX_BCAST	= 0x2,
+	RX_MCAST	= 0x3,
+	RX_DROP		= 0x4,
+	RX_DROP_OCTS	= 0x5,
+	RX_FCS		= 0x6,
+	RX_ERR		= 0x7,
+	RX_DRP_BCAST	= 0x8,
+	RX_DRP_MCAST	= 0x9,
+	RX_DRP_L3BCAST	= 0xa,
+	RX_DRP_L3MCAST	= 0xb,
+	RX_STATS_ENUM_LAST,
+};
+
+struct otx2_dev_stats {
+	u64 rx_bytes;
+	u64 rx_frames;
+	u64 rx_ucast_frames;
+	u64 rx_bcast_frames;
+	u64 rx_mcast_frames;
+	u64 rx_drops;
+
+	u64 tx_bytes;
+	u64 tx_frames;
+	u64 tx_ucast_frames;
+	u64 tx_bcast_frames;
+	u64 tx_mcast_frames;
+	u64 tx_drops;
+};
+
 /* Driver counted stats */
 struct otx2_drv_stats {
 	atomic_t rx_fcs_errs;
@@ -142,6 +185,7 @@ struct otx2_hw {
 	cpumask_var_t           *affinity_mask;
 
 	/* Stats */
+	struct otx2_dev_stats	dev_stats;
 	struct otx2_drv_stats	drv_stats;
 };
 
@@ -545,6 +589,11 @@ void mbox_handler_nix_lf_alloc(struct otx2_nic *pfvf,
 void mbox_handler_nix_txsch_alloc(struct otx2_nic *pf,
 				  struct nix_txsch_alloc_rsp *rsp);
 
+/* Device stats APIs */
+void otx2_get_dev_stats(struct otx2_nic *pfvf);
+void otx2_get_stats64(struct net_device *netdev,
+		      struct rtnl_link_stats64 *stats);
+
 int otx2_open(struct net_device *netdev);
 int otx2_stop(struct net_device *netdev);
 #endif /* OTX2_COMMON_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index d080936..3092634 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1073,6 +1073,7 @@ static const struct net_device_ops otx2_netdev_ops = {
 	.ndo_set_rx_mode	= otx2_set_rx_mode,
 	.ndo_set_features	= otx2_set_features,
 	.ndo_tx_timeout		= otx2_tx_timeout,
+	.ndo_get_stats64	= otx2_get_stats64,
 };
 
 static int otx2_check_pf_usable(struct otx2_nic *nic)
-- 
2.7.4

