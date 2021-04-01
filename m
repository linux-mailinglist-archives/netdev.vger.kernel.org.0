Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC02B351AB6
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236705AbhDASCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 14:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235549AbhDAR5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 13:57:16 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68996C031148
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 09:43:19 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id ap14so3890978ejc.0
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 09:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vYlbfdlzeautMqT/19BMG+KdW7W8IY0mDtzZJCnvWck=;
        b=TOXNZv8rMKbqXI29vr9+uyubunhgM2xh1INCAwVc50su/dHsCgeDrDjCXIczoZGKVz
         weXCd3DluKCb3mhrdVfW3dWpG91usiIZUAvbAVVgkTcpKBVIlH4+WdyeJA7WSJt8llJx
         Cxs8Zn79XVdeoGh43jh2XB7YW/yQ1ziFxXHebaS/Ufzm5dCTnQ7TbwrCQQPFfU7keT4v
         snD8QxIqnE2GgqmrEK5BAqTm4w0/WD8aWVj3uzeo02WldtH+Tay6MWQN/gntFOFnxfNo
         mSv/ZBbvZQFrpnPJ3Bw5iA6GZbt8uCzI7SZBKj6cJvzOquFWtiR7OFgVmMU1/AMdvNRh
         KMKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vYlbfdlzeautMqT/19BMG+KdW7W8IY0mDtzZJCnvWck=;
        b=ptAiNkaIHiPqA0+T9etZm4FsRjecuCD6/93+NFT8ebFbETMmCtzagcXmup+AmOUqGw
         E9KCpRg1Xn/4K5gMfSPu5l7+XOUME/hBxan612JCY7gupOWL99IMk1uD18c32m/Jymde
         5H8ydNoiXThJaEzFfs6a5/HgQyY0C9CRHKHdOQ6rCGoe4Bq4Oy+5Pank6apN/3b7nRKY
         ThhAwdDZPScP9AuDD3VCNqxBjd8e5tGRwn5jmJguIr9+kwdjXNZa6buJmVnGCLuEEk7i
         r34gd9vDduFkESTy5VDDWAMQh3+JWC2lF6jtYDJV/57PJrphLof+80XcngyOw7AkygPb
         zpVw==
X-Gm-Message-State: AOAM532YWx0caBJPcsH2Ppms7SP7mc6nXjj9tixeE3sSHZ1zPRGSsDX1
        cft5cNdl0xoYJmHXhkyefr4=
X-Google-Smtp-Source: ABdhPJw5Eg5dvIcOMGbstX2kZlrQovQlXyMeHOxSXr6UePDLnOvFPXKM/8f+LRsqaKaXrVpZ6PO9gQ==
X-Received: by 2002:a17:906:3496:: with SMTP id g22mr10370879ejb.143.1617295398131;
        Thu, 01 Apr 2021 09:43:18 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id w24sm3821270edt.44.2021.04.01.09.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 09:43:17 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ruxandra.radulescu@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 1/3] dpaa2-eth: rename dpaa2_eth_xdp_release_buf into dpaa2_eth_recycle_buf
Date:   Thu,  1 Apr 2021 19:39:54 +0300
Message-Id: <20210401163956.766628-2-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210401163956.766628-1-ciorneiioana@gmail.com>
References: <20210401163956.766628-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Rename the dpaa2_eth_xdp_release_buf function into dpaa2_eth_recycle_buf
since in the next patches we'll be using the same recycle mechanism for
the normal stack path beside for XDP_DROP.

Also, rename the array which holds the buffers to be recycled so that it
does not have any reference to XDP.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 26 +++++++++----------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  6 +++--
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index fc0eb82cdd6a..f545cb99388a 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -223,31 +223,31 @@ static void dpaa2_eth_free_bufs(struct dpaa2_eth_priv *priv, u64 *buf_array,
 	}
 }
 
-static void dpaa2_eth_xdp_release_buf(struct dpaa2_eth_priv *priv,
-				      struct dpaa2_eth_channel *ch,
-				      dma_addr_t addr)
+static void dpaa2_eth_recycle_buf(struct dpaa2_eth_priv *priv,
+				  struct dpaa2_eth_channel *ch,
+				  dma_addr_t addr)
 {
 	int retries = 0;
 	int err;
 
-	ch->xdp.drop_bufs[ch->xdp.drop_cnt++] = addr;
-	if (ch->xdp.drop_cnt < DPAA2_ETH_BUFS_PER_CMD)
+	ch->recycled_bufs[ch->recycled_bufs_cnt++] = addr;
+	if (ch->recycled_bufs_cnt < DPAA2_ETH_BUFS_PER_CMD)
 		return;
 
 	while ((err = dpaa2_io_service_release(ch->dpio, priv->bpid,
-					       ch->xdp.drop_bufs,
-					       ch->xdp.drop_cnt)) == -EBUSY) {
+					       ch->recycled_bufs,
+					       ch->recycled_bufs_cnt)) == -EBUSY) {
 		if (retries++ >= DPAA2_ETH_SWP_BUSY_RETRIES)
 			break;
 		cpu_relax();
 	}
 
 	if (err) {
-		dpaa2_eth_free_bufs(priv, ch->xdp.drop_bufs, ch->xdp.drop_cnt);
-		ch->buf_count -= ch->xdp.drop_cnt;
+		dpaa2_eth_free_bufs(priv, ch->recycled_bufs, ch->recycled_bufs_cnt);
+		ch->buf_count -= ch->recycled_bufs_cnt;
 	}
 
-	ch->xdp.drop_cnt = 0;
+	ch->recycled_bufs_cnt = 0;
 }
 
 static int dpaa2_eth_xdp_flush(struct dpaa2_eth_priv *priv,
@@ -300,7 +300,7 @@ static void dpaa2_eth_xdp_tx_flush(struct dpaa2_eth_priv *priv,
 		ch->stats.xdp_tx++;
 	}
 	for (i = enqueued; i < fq->xdp_tx_fds.num; i++) {
-		dpaa2_eth_xdp_release_buf(priv, ch, dpaa2_fd_get_addr(&fds[i]));
+		dpaa2_eth_recycle_buf(priv, ch, dpaa2_fd_get_addr(&fds[i]));
 		percpu_stats->tx_errors++;
 		ch->stats.xdp_tx_err++;
 	}
@@ -382,7 +382,7 @@ static u32 dpaa2_eth_run_xdp(struct dpaa2_eth_priv *priv,
 		trace_xdp_exception(priv->net_dev, xdp_prog, xdp_act);
 		fallthrough;
 	case XDP_DROP:
-		dpaa2_eth_xdp_release_buf(priv, ch, addr);
+		dpaa2_eth_recycle_buf(priv, ch, addr);
 		ch->stats.xdp_drop++;
 		break;
 	case XDP_REDIRECT:
@@ -403,7 +403,7 @@ static u32 dpaa2_eth_run_xdp(struct dpaa2_eth_priv *priv,
 				free_pages((unsigned long)vaddr, 0);
 			} else {
 				ch->buf_count++;
-				dpaa2_eth_xdp_release_buf(priv, ch, addr);
+				dpaa2_eth_recycle_buf(priv, ch, addr);
 			}
 			ch->stats.xdp_drop++;
 		} else {
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 9b6a89709ce1..9ba31c2706bb 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -438,8 +438,6 @@ struct dpaa2_eth_fq {
 
 struct dpaa2_eth_ch_xdp {
 	struct bpf_prog *prog;
-	u64 drop_bufs[DPAA2_ETH_BUFS_PER_CMD];
-	int drop_cnt;
 	unsigned int res;
 };
 
@@ -457,6 +455,10 @@ struct dpaa2_eth_channel {
 	struct dpaa2_eth_ch_xdp xdp;
 	struct xdp_rxq_info xdp_rxq;
 	struct list_head *rx_list;
+
+	/* Buffers to be recycled back in the buffer pool */
+	u64 recycled_bufs[DPAA2_ETH_BUFS_PER_CMD];
+	int recycled_bufs_cnt;
 };
 
 struct dpaa2_eth_dist_fields {
-- 
2.30.0

