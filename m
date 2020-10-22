Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1042967C1
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 01:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373639AbgJVXzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 19:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S373630AbgJVXzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 19:55:53 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DA0C0613CE
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 16:55:53 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id s22so2026849pga.9
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 16:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0PJBN/sBFpmtoIm/dAiFxgraYfKdEYPqonxyP9QB+D8=;
        b=IZqGeDvqFZAcK8Qhk4zoA7X6JWvyzaeQihsuFC9QfVJ5+WvhSYFU4uKSr4yRjiEegC
         +T5qvGBda2sS8NotMs7JeFqYi+/EHppxjsirnZakYR0/xbWFjthhLKLPrPYzYQjW13JG
         oq551FUPda3HEY2F0CBRAIUc9QT0NMw347090+eLvyKqpegmd8PxgVqZwB5RRKZ8kgpa
         3cqLMPfl7b1Vht+UCXx35jACsPgFXjhUM7AOoeGpmJQNHt+pDgEKfsa0ogFT58jNFoN5
         p8aC9IkCbEWVmRDJ9bGY0iMoxBgoEMAikwQ6ITrpr6XCzOZe89v0lFhIAGXbHaeEnYVH
         x3Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0PJBN/sBFpmtoIm/dAiFxgraYfKdEYPqonxyP9QB+D8=;
        b=UfGqXw/4JLKn7lJ3hVfKmSvHYfP72JVyB6+wf1C3mRSWFZiaeED0Z16LEy5jJBMsIH
         ZGoO4HDr8TBfxKjNeR/N48+7gM9et7ExOIhCxmdp5qRWXa8KEYRl9UQZegLPMDGp0PgY
         WAE1432USXMqnGzlTNNW+Hxbqiyl7WXjylUkkRvhGfNOHMRta+utRhNv0D7UFYbgItnX
         n+4V8fRxZ8JHhMARFhf4m2kR7ZJJMHlERhODU6p0Q+wWaYdhxmQIIutft2nqJTnZ+oZC
         p23mwBgI89m/wxKE9ETBjq9u05+4R2LrwmNOJXZzOLa38KIgRIdiaCYmNZXbRvCPv+pI
         0j/g==
X-Gm-Message-State: AOAM5322koG4Z3dyButV4WeMVv2BUgQRVTQ1c6fh7h88zAuolDQZymDU
        Gx+Nm+MVDWdb7d70AbNOh2ibBHH+FZ9ZTw==
X-Google-Smtp-Source: ABdhPJx7MIbTStYVCtbq04/2n2wpUGXKF4mrQXAV8SaVrqPaCTc1B5qoBu2+DkOksnim5FrTjg2szA==
X-Received: by 2002:a17:90b:47d5:: with SMTP id kc21mr4354855pjb.169.1603410952728;
        Thu, 22 Oct 2020 16:55:52 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id v3sm3167244pfu.165.2020.10.22.16.55.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Oct 2020 16:55:52 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 1/3] ionic: clean up sparse complaints
Date:   Thu, 22 Oct 2020 16:55:29 -0700
Message-Id: <20201022235531.65956-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201022235531.65956-1-snelson@pensando.io>
References: <20201022235531.65956-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sparse complaints around the static_asserts were obscuring
more useful complaints.  So, don't check the static_asserts,
and fix the remaining sparse complaints.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  4 +--
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  2 ++
 .../net/ethernet/pensando/ionic/ionic_fw.c    |  6 ++--
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 28 +++++++++----------
 .../net/ethernet/pensando/ionic/ionic_main.c  |  4 +--
 .../net/ethernet/pensando/ionic/ionic_stats.h |  2 +-
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 10 +++----
 7 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 545c99b15df8..dc5fbc2704f3 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -333,7 +333,7 @@ int ionic_set_vf_config(struct ionic *ionic, int vf, u8 attr, u8 *data)
 	union ionic_dev_cmd cmd = {
 		.vf_setattr.opcode = IONIC_CMD_VF_SETATTR,
 		.vf_setattr.attr = attr,
-		.vf_setattr.vf_index = vf,
+		.vf_setattr.vf_index = cpu_to_le16(vf),
 	};
 	int err;
 
@@ -391,7 +391,7 @@ void ionic_dev_cmd_queue_identify(struct ionic_dev *idev,
 {
 	union ionic_dev_cmd cmd = {
 		.q_identify.opcode = IONIC_CMD_Q_IDENTIFY,
-		.q_identify.lif_type = lif_type,
+		.q_identify.lif_type = cpu_to_le16(lif_type),
 		.q_identify.type = qtype,
 		.q_identify.ver = qver,
 	};
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index c109cd5a0471..6c243b17312c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -29,6 +29,7 @@ struct ionic_dev_bar {
 	int res_index;
 };
 
+#ifndef __CHECKER__
 /* Registers */
 static_assert(sizeof(struct ionic_intr) == 32);
 
@@ -119,6 +120,7 @@ static_assert(sizeof(struct ionic_vf_setattr_cmd) == 64);
 static_assert(sizeof(struct ionic_vf_setattr_comp) == 16);
 static_assert(sizeof(struct ionic_vf_getattr_cmd) == 64);
 static_assert(sizeof(struct ionic_vf_getattr_comp) == 16);
+#endif /* __CHECKER__ */
 
 struct ionic_devinfo {
 	u8 asic_type;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_fw.c b/drivers/net/ethernet/pensando/ionic/ionic_fw.c
index f492ae406a60..d7bbf336c6f6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_fw.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_fw.c
@@ -27,9 +27,9 @@ static void ionic_dev_cmd_firmware_download(struct ionic_dev *idev, u64 addr,
 {
 	union ionic_dev_cmd cmd = {
 		.fw_download.opcode = IONIC_CMD_FW_DOWNLOAD,
-		.fw_download.offset = offset,
-		.fw_download.addr = addr,
-		.fw_download.length = length
+		.fw_download.offset = cpu_to_le32(offset),
+		.fw_download.addr = cpu_to_le64(addr),
+		.fw_download.length = cpu_to_le32(length),
 	};
 
 	ionic_dev_cmd_go(idev, &cmd);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index d655a7ae3058..591c644b8e69 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1915,11 +1915,11 @@ static int ionic_get_vf_config(struct net_device *netdev,
 		ret = -EINVAL;
 	} else {
 		ivf->vf           = vf;
-		ivf->vlan         = ionic->vfs[vf].vlanid;
+		ivf->vlan         = le16_to_cpu(ionic->vfs[vf].vlanid);
 		ivf->qos	  = 0;
 		ivf->spoofchk     = ionic->vfs[vf].spoofchk;
 		ivf->linkstate    = ionic->vfs[vf].linkstate;
-		ivf->max_tx_rate  = ionic->vfs[vf].maxrate;
+		ivf->max_tx_rate  = le32_to_cpu(ionic->vfs[vf].maxrate);
 		ivf->trusted      = ionic->vfs[vf].trusted;
 		ether_addr_copy(ivf->mac, ionic->vfs[vf].macaddr);
 	}
@@ -2019,7 +2019,7 @@ static int ionic_set_vf_vlan(struct net_device *netdev, int vf, u16 vlan,
 		ret = ionic_set_vf_config(ionic, vf,
 					  IONIC_VF_ATTR_VLAN, (u8 *)&vlan);
 		if (!ret)
-			ionic->vfs[vf].vlanid = vlan;
+			ionic->vfs[vf].vlanid = cpu_to_le16(vlan);
 	}
 
 	up_write(&ionic->vf_op_lock);
@@ -2048,7 +2048,7 @@ static int ionic_set_vf_rate(struct net_device *netdev, int vf,
 		ret = ionic_set_vf_config(ionic, vf,
 					  IONIC_VF_ATTR_RATE, (u8 *)&tx_max);
 		if (!ret)
-			lif->ionic->vfs[vf].maxrate = tx_max;
+			lif->ionic->vfs[vf].maxrate = cpu_to_le32(tx_max);
 	}
 
 	up_write(&ionic->vf_op_lock);
@@ -2981,14 +2981,14 @@ void ionic_lif_unregister(struct ionic_lif *lif)
 
 static void ionic_lif_queue_identify(struct ionic_lif *lif)
 {
+	union ionic_q_identity __iomem *q_ident;
 	struct ionic *ionic = lif->ionic;
-	union ionic_q_identity *q_ident;
 	struct ionic_dev *idev;
 	int qtype;
 	int err;
 
 	idev = &lif->ionic->idev;
-	q_ident = (union ionic_q_identity *)&idev->dev_cmd_regs->data;
+	q_ident = (union ionic_q_identity __iomem *)&idev->dev_cmd_regs->data;
 
 	for (qtype = 0; qtype < ARRAY_SIZE(ionic_qtype_versions); qtype++) {
 		struct ionic_qtype_info *qti = &lif->qtype_info[qtype];
@@ -3011,14 +3011,14 @@ static void ionic_lif_queue_identify(struct ionic_lif *lif)
 					     ionic_qtype_versions[qtype]);
 		err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
 		if (!err) {
-			qti->version   = q_ident->version;
-			qti->supported = q_ident->supported;
-			qti->features  = le64_to_cpu(q_ident->features);
-			qti->desc_sz   = le16_to_cpu(q_ident->desc_sz);
-			qti->comp_sz   = le16_to_cpu(q_ident->comp_sz);
-			qti->sg_desc_sz   = le16_to_cpu(q_ident->sg_desc_sz);
-			qti->max_sg_elems = le16_to_cpu(q_ident->max_sg_elems);
-			qti->sg_desc_stride = le16_to_cpu(q_ident->sg_desc_stride);
+			qti->version   = readb(&q_ident->version);
+			qti->supported = readb(&q_ident->supported);
+			qti->features  = readq(&q_ident->features);
+			qti->desc_sz   = readw(&q_ident->desc_sz);
+			qti->comp_sz   = readw(&q_ident->comp_sz);
+			qti->sg_desc_sz   = readw(&q_ident->sg_desc_sz);
+			qti->max_sg_elems = readw(&q_ident->max_sg_elems);
+			qti->sg_desc_stride = readw(&q_ident->sg_desc_stride);
 		}
 		mutex_unlock(&ionic->dev_cmd_lock);
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index ee0740881af3..d355676f6c16 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -311,7 +311,7 @@ int ionic_adminq_post_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
 
 static void ionic_dev_cmd_clean(struct ionic *ionic)
 {
-	union ionic_dev_cmd_regs *regs = ionic->idev.dev_cmd_regs;
+	union __iomem ionic_dev_cmd_regs *regs = ionic->idev.dev_cmd_regs;
 
 	iowrite32(0, &regs->doorbell);
 	memset_io(&regs->cmd, 0, sizeof(regs->cmd));
@@ -333,7 +333,7 @@ int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds)
 	 */
 	max_wait = jiffies + (max_seconds * HZ);
 try_again:
-	opcode = idev->dev_cmd_regs->cmd.cmd.opcode;
+	opcode = readb(&idev->dev_cmd_regs->cmd.cmd.opcode);
 	start_time = jiffies;
 	do {
 		done = ionic_dev_cmd_done(idev);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_stats.h b/drivers/net/ethernet/pensando/ionic/ionic_stats.h
index 3f543512616e..2a725834f792 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_stats.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_stats.h
@@ -49,7 +49,7 @@ extern const int ionic_num_stats_grps;
 	(*((u64 *)(((u8 *)(base_ptr)) + (desc_ptr)->offset)))
 
 #define IONIC_READ_STAT_LE64(base_ptr, desc_ptr) \
-	__le64_to_cpu(*((u64 *)(((u8 *)(base_ptr)) + (desc_ptr)->offset)))
+	__le64_to_cpu(*((__le64 *)(((u8 *)(base_ptr)) + (desc_ptr)->offset)))
 
 struct ionic_stat_desc {
 	char name[ETH_GSTRING_LEN];
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 169ac4f54640..8f6fc7142bc5 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -200,7 +200,7 @@ static void ionic_rx_clean(struct ionic_queue *q,
 	if (likely(netdev->features & NETIF_F_RXCSUM)) {
 		if (comp->csum_flags & IONIC_RXQ_COMP_CSUM_F_CALC) {
 			skb->ip_summed = CHECKSUM_COMPLETE;
-			skb->csum = (__wsum)le16_to_cpu(comp->csum);
+			skb->csum = (__force __wsum)le16_to_cpu(comp->csum);
 			stats->csum_complete++;
 		}
 	} else {
@@ -812,6 +812,7 @@ static int ionic_tx_tso(struct ionic_queue *q, struct sk_buff *skb)
 	skb_frag_t *frag;
 	bool start, done;
 	bool outer_csum;
+	dma_addr_t addr;
 	bool has_vlan;
 	u16 desc_len;
 	u8 desc_nsge;
@@ -893,11 +894,10 @@ static int ionic_tx_tso(struct ionic_queue *q, struct sk_buff *skb)
 			if (frag_left > 0) {
 				len = min(frag_left, left);
 				frag_left -= len;
-				elem->addr =
-				    cpu_to_le64(ionic_tx_map_frag(q, frag,
-								  offset, len));
-				if (dma_mapping_error(dev, elem->addr))
+				addr = ionic_tx_map_frag(q, frag, offset, len);
+				if (dma_mapping_error(dev, addr))
 					goto err_out_abort;
+				elem->addr = cpu_to_le64(addr);
 				elem->len = cpu_to_le16(len);
 				elem++;
 				desc_nsge++;
-- 
2.17.1

