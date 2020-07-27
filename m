Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740E222E951
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 11:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbgG0Jlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 05:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728133AbgG0Jlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 05:41:35 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3956C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 02:41:35 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id j19so9173175pgm.11
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 02:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XgOjzv1EdV6wnW0ljXZYGfHHCKyd+/XjPnyFswctSok=;
        b=QpiNSOZP7+J3URbuH0LjgC/ba2rEuSLbih+ZW27qnNwV4/trzSMOqeu4Dhe6zOw8UI
         /jTbBDTl+9/+OLvkWYbIFyUVCVbjHcRmqz7GVZA8lB1TD3w2beC9ABwndcNh19b9y/sA
         qd69Lsz9ICVq8UTCChejGJ6yQ3sfCcAJPbCCI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XgOjzv1EdV6wnW0ljXZYGfHHCKyd+/XjPnyFswctSok=;
        b=dxJyUjyu5VwwIfUBgMvFHTpYtr2L9Cov3GtT7ArBa/Ma9dVqqMtH3AboS6GNj4xksJ
         Yb6gzyoUoR+l1XHnNwMIi0xpN0NShO8142Fd0z0uiBvWFiXl50Fv3gX/SuEmyXMPI3q5
         Rq55rJMwrGBndu1gqh8jYTALkIgYBdJS50adFhGCQoaPep76ycLOK3bSElGhaJjdgP9I
         Qj8xjWWhgcYVyzo2jChHMn9EGfyNYqjDVWbjm/s808K1wSC2KyOthpOilvY4Pk3LGWHV
         cFcbZDerT+fOopgpFqigc/6cC4F7swAL3k+jHlpEvHMXEVS2RtKaEa4/24OMgcNSTknc
         /zGw==
X-Gm-Message-State: AOAM533lQc1GjX4bMHEzDbTpVCAAc5eHGZxQubpkwabGe2LLCb8EAA+w
        942xbewH/XTQRQuJmdGYNS+XUg==
X-Google-Smtp-Source: ABdhPJzNgrfWYmNixj9LU4oHSRzFFwBJT7m+A46u5Scuyekikw6s4jj/WgzZY4/F0w//mQMCTVQqkg==
X-Received: by 2002:aa7:9186:: with SMTP id x6mr19925440pfa.103.1595842895153;
        Mon, 27 Jul 2020 02:41:35 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f131sm14560945pgc.14.2020.07.27.02.41.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jul 2020 02:41:34 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next v2 10/10] bnxt_en: Add support for 'ethtool -d'
Date:   Mon, 27 Jul 2020 05:40:45 -0400
Message-Id: <1595842845-19403-11-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1595842845-19403-1-git-send-email-michael.chan@broadcom.com>
References: <1595842845-19403-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Add support to dump PXP registers and PCIe statistics.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 32 +++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  5 +++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 55 +++++++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h |  2 +
 4 files changed, 94 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 014edd8..943345b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10220,6 +10220,38 @@ static int bnxt_set_features(struct net_device *dev, netdev_features_t features)
 	return rc;
 }
 
+int bnxt_dbg_hwrm_rd_reg(struct bnxt *bp, u32 reg_off, u16 num_words,
+			 u32 *reg_buf)
+{
+	struct hwrm_dbg_read_direct_output *resp = bp->hwrm_cmd_resp_addr;
+	struct hwrm_dbg_read_direct_input req = {0};
+	__le32 *dbg_reg_buf;
+	dma_addr_t mapping;
+	int rc, i;
+
+	dbg_reg_buf = dma_alloc_coherent(&bp->pdev->dev, num_words * 4,
+					 &mapping, GFP_KERNEL);
+	if (!dbg_reg_buf)
+		return -ENOMEM;
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_DBG_READ_DIRECT, -1, -1);
+	req.host_dest_addr = cpu_to_le64(mapping);
+	req.read_addr = cpu_to_le32(reg_off + CHIMP_REG_VIEW_ADDR);
+	req.read_len32 = cpu_to_le32(num_words);
+	mutex_lock(&bp->hwrm_cmd_lock);
+	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	if (rc || resp->error_code) {
+		rc = -EIO;
+		goto dbg_rd_reg_exit;
+	}
+	for (i = 0; i < num_words; i++)
+		reg_buf[i] = le32_to_cpu(dbg_reg_buf[i]);
+
+dbg_rd_reg_exit:
+	mutex_unlock(&bp->hwrm_cmd_lock);
+	dma_free_coherent(&bp->pdev->dev, num_words * 4, dbg_reg_buf, mapping);
+	return rc;
+}
+
 static int bnxt_dbg_hwrm_ring_info_get(struct bnxt *bp, u8 ring_type,
 				       u32 ring_id, u32 *prod, u32 *cons)
 {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 0c9b79b..5a13eb6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1304,6 +1304,9 @@ struct bnxt_test_info {
 	char string[BNXT_MAX_TEST][ETH_GSTRING_LEN];
 };
 
+#define CHIMP_REG_VIEW_ADDR				\
+	((bp->flags & BNXT_FLAG_CHIP_P5) ? 0x80000000 : 0xb1000000)
+
 #define BNXT_GRCPF_REG_CHIMP_COMM		0x0
 #define BNXT_GRCPF_REG_CHIMP_COMM_TRIGGER	0x100
 #define BNXT_GRCPF_REG_WINDOW_BASE_OUT		0x400
@@ -2117,6 +2120,8 @@ int bnxt_hwrm_func_drv_rgtr(struct bnxt *bp, unsigned long *bmap,
 int bnxt_half_open_nic(struct bnxt *bp);
 void bnxt_half_close_nic(struct bnxt *bp);
 int bnxt_close_nic(struct bnxt *, bool, bool);
+int bnxt_dbg_hwrm_rd_reg(struct bnxt *bp, u32 reg_off, u16 num_words,
+			 u32 *reg_buf);
 void bnxt_fw_exception(struct bnxt *bp);
 void bnxt_fw_reset(struct bnxt *bp);
 int bnxt_check_rings(struct bnxt *bp, int tx, int rx, bool sh, int tcs,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index ff380d7..7fd7997 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1324,6 +1324,59 @@ static void bnxt_get_drvinfo(struct net_device *dev,
 	info->regdump_len = 0;
 }
 
+static int bnxt_get_regs_len(struct net_device *dev)
+{
+	struct bnxt *bp = netdev_priv(dev);
+	int reg_len;
+
+	reg_len = BNXT_PXP_REG_LEN;
+
+	if (bp->fw_cap & BNXT_FW_CAP_PCIE_STATS_SUPPORTED)
+		reg_len += sizeof(struct pcie_ctx_hw_stats);
+
+	return reg_len;
+}
+
+static void bnxt_get_regs(struct net_device *dev, struct ethtool_regs *regs,
+			  void *_p)
+{
+	struct pcie_ctx_hw_stats *hw_pcie_stats;
+	struct hwrm_pcie_qstats_input req = {0};
+	struct bnxt *bp = netdev_priv(dev);
+	dma_addr_t hw_pcie_stats_addr;
+	int rc;
+
+	regs->version = 0;
+	bnxt_dbg_hwrm_rd_reg(bp, 0, BNXT_PXP_REG_LEN / 4, _p);
+
+	if (!(bp->fw_cap & BNXT_FW_CAP_PCIE_STATS_SUPPORTED))
+		return;
+
+	hw_pcie_stats = dma_alloc_coherent(&bp->pdev->dev,
+					   sizeof(*hw_pcie_stats),
+					   &hw_pcie_stats_addr, GFP_KERNEL);
+	if (!hw_pcie_stats)
+		return;
+
+	regs->version = 1;
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_PCIE_QSTATS, -1, -1);
+	req.pcie_stat_size = cpu_to_le16(sizeof(*hw_pcie_stats));
+	req.pcie_stat_host_addr = cpu_to_le64(hw_pcie_stats_addr);
+	mutex_lock(&bp->hwrm_cmd_lock);
+	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	if (!rc) {
+		__le64 *src = (__le64 *)hw_pcie_stats;
+		u64 *dst = (u64 *)(_p + BNXT_PXP_REG_LEN);
+		int i;
+
+		for (i = 0; i < sizeof(*hw_pcie_stats) / sizeof(__le64); i++)
+			dst[i] = le64_to_cpu(src[i]);
+	}
+	mutex_unlock(&bp->hwrm_cmd_lock);
+	dma_free_coherent(&bp->pdev->dev, sizeof(*hw_pcie_stats), hw_pcie_stats,
+			  hw_pcie_stats_addr);
+}
+
 static void bnxt_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 {
 	struct bnxt *bp = netdev_priv(dev);
@@ -3596,6 +3649,8 @@ void bnxt_ethtool_free(struct bnxt *bp)
 	.get_pauseparam		= bnxt_get_pauseparam,
 	.set_pauseparam		= bnxt_set_pauseparam,
 	.get_drvinfo		= bnxt_get_drvinfo,
+	.get_regs_len		= bnxt_get_regs_len,
+	.get_regs		= bnxt_get_regs,
 	.get_wol		= bnxt_get_wol,
 	.set_wol		= bnxt_set_wol,
 	.get_coalesce		= bnxt_get_coalesce,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
index dddbca1..34f44dd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
@@ -84,6 +84,8 @@ struct hwrm_dbg_cmn_output {
 				  ETH_RESET_PHY | ETH_RESET_RAM)	\
 				 << ETH_RESET_SHARED_SHIFT)
 
+#define BNXT_PXP_REG_LEN	0x3110
+
 extern const struct ethtool_ops bnxt_ethtool_ops;
 
 u32 bnxt_get_rxfh_indir_size(struct net_device *dev);
-- 
1.8.3.1

