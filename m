Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4AD17D6DE
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 23:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgCHWqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 18:46:21 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:53735 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgCHWqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 18:46:20 -0400
Received: by mail-pj1-f66.google.com with SMTP id l36so731800pjb.3
        for <netdev@vger.kernel.org>; Sun, 08 Mar 2020 15:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=d5dPhPsqrYDWnVQKJGlid1FVfZf4Fzgl0UPW/4GhP3A=;
        b=RSgL4QDPuFKJcB0Mt3kewRF9Ztpvd7EOkY/of1HpAvpvljRE9/I69FsQvaltm2ZzNR
         sKztXFMSZcaw4X8jgKZU/n+i3HKoRUy4MoV5jePc++9nQPm43Yb5RZXTPa6vP+LTXAoo
         wgf9ZhtCW2ozy+QZ9KFhz6BuOY8WieNxh2akg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=d5dPhPsqrYDWnVQKJGlid1FVfZf4Fzgl0UPW/4GhP3A=;
        b=s/oiPx/+dSMaNgA4buzHNs1NkySi7fFkwj4fmBRqAz6WOdbjW9YdF49iZKtv/XP+WJ
         qJoeVJ3NDuS8KTqSwIRDad4LmvnY68qiqPoJ4woVnVabUdaDBHOpi4yqTTYCeRpQEfmq
         ymnhs4hmqKWKiG/lgAReQ+fTqzi0bX56qLojFh2sIkTq70FjdfjprHcEvKZNn+xtCmKQ
         H/y7X2/oSnc6b3mGRXN2cjo2w3i1QduuJvgslEpMGOurV5MXDe4YvmqcI2JpsX+4zKOB
         XeytoNHnQYBX41dWkbsNbyTYBnBPTpjepPCOckSl5DSjn5PvKbCQxW0o6S0ubSD9r1La
         5lUQ==
X-Gm-Message-State: ANhLgQ2vJQZkaP+GWBk7q3touo6t1v9LTz5+HsSv5JQ32ivWPYc5S8/X
        F7QgzEmhxyQPn+YS2h3QIBRh9A==
X-Google-Smtp-Source: ADFU+vsRVItdzsaDYoS276udlKYc/O0Rn9UZhHjedvQQC6Zb43vkvoHNLZqFrgro6P7ZA1rgeDzZ4Q==
X-Received: by 2002:a17:902:9b8a:: with SMTP id y10mr12716065plp.114.1583707578747;
        Sun, 08 Mar 2020 15:46:18 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x66sm31241397pgb.9.2020.03.08.15.46.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Mar 2020 15:46:18 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next 5/8] bnxt_en: Remove unnecessary assignment of return code
Date:   Sun,  8 Mar 2020 18:45:51 -0400
Message-Id: <1583707554-1163-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1583707554-1163-1-git-send-email-michael.chan@broadcom.com>
References: <1583707554-1163-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

As part of converting error code in firmware message to standard
code, checking for firmware return code is removed in most of the
places. Remove the assignment of return code where the function
can directly return.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 37 ++++++++---------------
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c     | 19 ++++--------
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  5 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c   |  4 +--
 4 files changed, 21 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 500d4c8..b4a551a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -5838,8 +5838,7 @@ bnxt_hwrm_reserve_pf_rings(struct bnxt *bp, int tx_rings, int rx_rings,
 	if (bp->hwrm_spec_code < 0x10601)
 		bp->hw_resc.resv_tx_rings = tx_rings;
 
-	rc = bnxt_hwrm_get_rings(bp);
-	return rc;
+	return bnxt_hwrm_get_rings(bp);
 }
 
 static int
@@ -5860,8 +5859,7 @@ bnxt_hwrm_reserve_vf_rings(struct bnxt *bp, int tx_rings, int rx_rings,
 	if (rc)
 		return rc;
 
-	rc = bnxt_hwrm_get_rings(bp);
-	return rc;
+	return bnxt_hwrm_get_rings(bp);
 }
 
 static int bnxt_hwrm_reserve_rings(struct bnxt *bp, int tx, int rx, int grp,
@@ -6021,7 +6019,6 @@ static int bnxt_hwrm_check_vf_rings(struct bnxt *bp, int tx_rings, int rx_rings,
 {
 	struct hwrm_func_vf_cfg_input req = {0};
 	u32 flags;
-	int rc;
 
 	if (!BNXT_NEW_RM(bp))
 		return 0;
@@ -6038,8 +6035,8 @@ static int bnxt_hwrm_check_vf_rings(struct bnxt *bp, int tx_rings, int rx_rings,
 		flags |= FUNC_VF_CFG_REQ_FLAGS_RING_GRP_ASSETS_TEST;
 
 	req.flags = cpu_to_le32(flags);
-	rc = hwrm_send_message_silent(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-	return rc;
+	return hwrm_send_message_silent(bp, &req, sizeof(req),
+					HWRM_CMD_TIMEOUT);
 }
 
 static int bnxt_hwrm_check_pf_rings(struct bnxt *bp, int tx_rings, int rx_rings,
@@ -6048,7 +6045,6 @@ static int bnxt_hwrm_check_pf_rings(struct bnxt *bp, int tx_rings, int rx_rings,
 {
 	struct hwrm_func_cfg_input req = {0};
 	u32 flags;
-	int rc;
 
 	__bnxt_hwrm_reserve_pf_rings(bp, &req, tx_rings, rx_rings, ring_grps,
 				     cp_rings, stats, vnics);
@@ -6066,8 +6062,8 @@ static int bnxt_hwrm_check_pf_rings(struct bnxt *bp, int tx_rings, int rx_rings,
 	}
 
 	req.flags = cpu_to_le32(flags);
-	rc = hwrm_send_message_silent(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-	return rc;
+	return hwrm_send_message_silent(bp, &req, sizeof(req),
+					HWRM_CMD_TIMEOUT);
 }
 
 static int bnxt_hwrm_check_rings(struct bnxt *bp, int tx_rings, int rx_rings,
@@ -6539,8 +6535,8 @@ static int bnxt_hwrm_func_backing_store_cfg(struct bnxt *bp, u32 enables)
 	__le64 *pg_dir;
 	u32 flags = 0;
 	u8 *pg_attr;
-	int i, rc;
 	u32 ena;
+	int i;
 
 	if (!ctx)
 		return 0;
@@ -6627,8 +6623,7 @@ static int bnxt_hwrm_func_backing_store_cfg(struct bnxt *bp, u32 enables)
 		bnxt_hwrm_set_pg_attr(&ctx_pg->ring_mem, pg_attr, pg_dir);
 	}
 	req.flags = cpu_to_le32(flags);
-	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-	return rc;
+	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 }
 
 static int bnxt_alloc_ctx_mem_blk(struct bnxt *bp,
@@ -7332,7 +7327,6 @@ int bnxt_hwrm_fw_set_time(struct bnxt *bp)
 
 static int bnxt_hwrm_port_qstats(struct bnxt *bp)
 {
-	int rc;
 	struct bnxt_pf_info *pf = &bp->pf;
 	struct hwrm_port_qstats_input req = {0};
 
@@ -7343,8 +7337,7 @@ static int bnxt_hwrm_port_qstats(struct bnxt *bp)
 	req.port_id = cpu_to_le16(pf->port_id);
 	req.tx_stat_host_addr = cpu_to_le64(bp->hw_tx_port_stats_map);
 	req.rx_stat_host_addr = cpu_to_le64(bp->hw_rx_port_stats_map);
-	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-	return rc;
+	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 }
 
 static int bnxt_hwrm_port_qstats_ext(struct bnxt *bp)
@@ -7498,7 +7491,6 @@ static void bnxt_hwrm_resource_free(struct bnxt *bp, bool close_path,
 static int bnxt_hwrm_set_br_mode(struct bnxt *bp, u16 br_mode)
 {
 	struct hwrm_func_cfg_input req = {0};
-	int rc;
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_CFG, -1, -1);
 	req.fid = cpu_to_le16(0xffff);
@@ -7509,14 +7501,12 @@ static int bnxt_hwrm_set_br_mode(struct bnxt *bp, u16 br_mode)
 		req.evb_mode = FUNC_CFG_REQ_EVB_MODE_VEPA;
 	else
 		return -EINVAL;
-	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-	return rc;
+	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 }
 
 static int bnxt_hwrm_set_cache_line_size(struct bnxt *bp, int size)
 {
 	struct hwrm_func_cfg_input req = {0};
-	int rc;
 
 	if (BNXT_VF(bp) || bp->hwrm_spec_code < 0x10803)
 		return 0;
@@ -7528,8 +7518,7 @@ static int bnxt_hwrm_set_cache_line_size(struct bnxt *bp, int size)
 	if (size == 128)
 		req.options = FUNC_CFG_REQ_OPTIONS_CACHE_LINESIZE_SIZE_128;
 
-	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-	return rc;
+	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 }
 
 static int __bnxt_setup_vnic(struct bnxt *bp, u16 vnic_id)
@@ -8883,14 +8872,12 @@ int bnxt_hwrm_alloc_wol_fltr(struct bnxt *bp)
 int bnxt_hwrm_free_wol_fltr(struct bnxt *bp)
 {
 	struct hwrm_wol_filter_free_input req = {0};
-	int rc;
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_WOL_FILTER_FREE, -1, -1);
 	req.port_id = cpu_to_le16(bp->pf.port_id);
 	req.enables = cpu_to_le32(WOL_FILTER_FREE_REQ_ENABLES_WOL_FILTER_ID);
 	req.wol_filter_id = bp->wol_filter_id;
-	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-	return rc;
+	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 }
 
 static u16 bnxt_hwrm_get_wol_fltrs(struct bnxt *bp, u16 handle)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
index fb6f30d..e50c679 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
@@ -39,8 +39,8 @@ static int bnxt_queue_to_tc(struct bnxt *bp, u8 queue_id)
 static int bnxt_hwrm_queue_pri2cos_cfg(struct bnxt *bp, struct ieee_ets *ets)
 {
 	struct hwrm_queue_pri2cos_cfg_input req = {0};
-	int rc = 0, i;
 	u8 *pri2cos;
+	int i;
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_QUEUE_PRI2COS_CFG, -1, -1);
 	req.flags = cpu_to_le32(QUEUE_PRI2COS_CFG_REQ_FLAGS_PATH_BIDIR |
@@ -56,8 +56,7 @@ static int bnxt_hwrm_queue_pri2cos_cfg(struct bnxt *bp, struct ieee_ets *ets)
 		qidx = bp->tc_to_qidx[ets->prio_tc[i]];
 		pri2cos[i] = bp->q_info[qidx].queue_id;
 	}
-	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-	return rc;
+	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 }
 
 static int bnxt_hwrm_queue_pri2cos_qcfg(struct bnxt *bp, struct ieee_ets *ets)
@@ -93,8 +92,8 @@ static int bnxt_hwrm_queue_cos2bw_cfg(struct bnxt *bp, struct ieee_ets *ets,
 {
 	struct hwrm_queue_cos2bw_cfg_input req = {0};
 	struct bnxt_cos2bw_cfg cos2bw;
-	int rc = 0, i;
 	void *data;
+	int i;
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_QUEUE_COS2BW_CFG, -1, -1);
 	for (i = 0; i < max_tc; i++) {
@@ -128,8 +127,7 @@ static int bnxt_hwrm_queue_cos2bw_cfg(struct bnxt *bp, struct ieee_ets *ets,
 			req.unused_0 = 0;
 		}
 	}
-	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-	return rc;
+	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 }
 
 static int bnxt_hwrm_queue_cos2bw_qcfg(struct bnxt *bp, struct ieee_ets *ets)
@@ -236,7 +234,6 @@ static int bnxt_hwrm_queue_pfc_cfg(struct bnxt *bp, struct ieee_pfc *pfc)
 	unsigned int tc_mask = 0, pri_mask = 0;
 	u8 i, pri, lltc_count = 0;
 	bool need_q_remap = false;
-	int rc;
 
 	if (!my_ets)
 		return -EINVAL;
@@ -267,15 +264,11 @@ static int bnxt_hwrm_queue_pfc_cfg(struct bnxt *bp, struct ieee_pfc *pfc)
 	}
 
 	if (need_q_remap)
-		rc = bnxt_queue_remap(bp, tc_mask);
+		bnxt_queue_remap(bp, tc_mask);
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_QUEUE_PFCENABLE_CFG, -1, -1);
 	req.flags = cpu_to_le32(pri_mask);
-	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-	if (rc)
-		return rc;
-
-	return rc;
+	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 }
 
 static int bnxt_hwrm_queue_pfc_qcfg(struct bnxt *bp, struct ieee_pfc *pfc)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 1fa3a12..cc807ba 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2606,7 +2606,7 @@ static int bnxt_set_phys_id(struct net_device *dev,
 	struct bnxt_led_cfg *led_cfg;
 	u8 led_state;
 	__le16 duration;
-	int i, rc;
+	int i;
 
 	if (!bp->num_leds || BNXT_VF(bp))
 		return -EOPNOTSUPP;
@@ -2632,8 +2632,7 @@ static int bnxt_set_phys_id(struct net_device *dev,
 		led_cfg->led_blink_off = duration;
 		led_cfg->led_group_id = bp->leds[i].led_group_id;
 	}
-	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-	return rc;
+	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 }
 
 static int bnxt_hwrm_selftest_irq(struct bnxt *bp, u16 cmpl_ring)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
index 2aba1e0..6ea3df6d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
@@ -138,7 +138,6 @@ static bool bnxt_is_trusted_vf(struct bnxt *bp, struct bnxt_vf_info *vf)
 static int bnxt_hwrm_set_trusted_vf(struct bnxt *bp, struct bnxt_vf_info *vf)
 {
 	struct hwrm_func_cfg_input req = {0};
-	int rc;
 
 	if (!(bp->fw_cap & BNXT_FW_CAP_TRUSTED_VF))
 		return 0;
@@ -149,8 +148,7 @@ static int bnxt_hwrm_set_trusted_vf(struct bnxt *bp, struct bnxt_vf_info *vf)
 		req.flags = cpu_to_le32(FUNC_CFG_REQ_FLAGS_TRUSTED_VF_ENABLE);
 	else
 		req.flags = cpu_to_le32(FUNC_CFG_REQ_FLAGS_TRUSTED_VF_DISABLE);
-	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-	return rc;
+	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 }
 
 int bnxt_set_vf_trust(struct net_device *dev, int vf_id, bool trusted)
-- 
2.5.1

