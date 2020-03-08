Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E964B17D6DF
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 23:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgCHWqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 18:46:23 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40789 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgCHWqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 18:46:22 -0400
Received: by mail-pl1-f194.google.com with SMTP id h11so11127plk.7
        for <netdev@vger.kernel.org>; Sun, 08 Mar 2020 15:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DUia9G+5l+9JAHv39OQjncEP05LgQjt5zWj0oBoun4k=;
        b=UTWxPiq+VPzsgUxZwfFTMZI9fin+/5sJWqqAbRN0xoeCZyxxv00SoxC7UEQlEAOXep
         r2shzF5W1dO0Mwzgqhe4eiW22gEn6aJuK8a3fRsMVIoXfqvtvv0KjlrNmisBz4rWG+v0
         /9rr/4F0fqnlUDy8h3mVkumrtoabYqnqR8Ybw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DUia9G+5l+9JAHv39OQjncEP05LgQjt5zWj0oBoun4k=;
        b=ckI9nlKw7iJ9u0MnV4TWAwvi9OU/wB9G+4FdC2a75jjHPetxwPL8c7pz3lKxtw0S0q
         Cn/E1LlhHWXc9P+4uUJklsZ99z0qSnc5Eqg3pl2mdds0iYCiWX/72lJWx3mnwubYMCIF
         XPKiwj8Hyz5bYwusSDnGhjcm1BDg/tWAWpbYDjQQF8lWYxOs5LS6y6ONhyADjW+1o+aM
         W3OB1BiAIF0Ku1GcFFbapDCUeuRekgoNbwp+5dTDFk7itH0ikYM9BGlqWkW1pvFMDdn+
         esYFtq2Ls2BPf8OcqNNzzxsExKjzhL0zaXiqDe6LeLBGCewM4BEGECw5LVTSOjHmY3Ar
         8NDg==
X-Gm-Message-State: ANhLgQ1eQm6FdhTqeYIcq80VA9+wsC52/4JkVKCiKXlsMbEoFQOw0JqX
        bFQSfcJ3D2Z7OV2bgZji/b1y2r8XB2A=
X-Google-Smtp-Source: ADFU+vvS+t37Z/XaUctZ9e1c4/VAtZR0zmbYgdN3DPNR6paKubSxrnZYyZo+q+/MWkc4dDtYIxXWEA==
X-Received: by 2002:a17:90a:ba89:: with SMTP id t9mr14924443pjr.93.1583707581057;
        Sun, 08 Mar 2020 15:46:21 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x66sm31241397pgb.9.2020.03.08.15.46.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Mar 2020 15:46:20 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next 6/8] bnxt_en: Modify some bnxt_hwrm_*_free() functions to void.
Date:   Sun,  8 Mar 2020 18:45:52 -0400
Message-Id: <1583707554-1163-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1583707554-1163-1-git-send-email-michael.chan@broadcom.com>
References: <1583707554-1163-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Return code is not needed in some of these functions, as the return
code from firmware message is ignored. Remove the unused rc variable
and also convert functions to void.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b4a551a..e5da60a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -5060,10 +5060,8 @@ int bnxt_hwrm_vnic_cfg(struct bnxt *bp, u16 vnic_id)
 	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 }
 
-static int bnxt_hwrm_vnic_free_one(struct bnxt *bp, u16 vnic_id)
+static void bnxt_hwrm_vnic_free_one(struct bnxt *bp, u16 vnic_id)
 {
-	u32 rc = 0;
-
 	if (bp->vnic_info[vnic_id].fw_vnic_id != INVALID_HW_RING_ID) {
 		struct hwrm_vnic_free_input req = {0};
 
@@ -5071,10 +5069,9 @@ static int bnxt_hwrm_vnic_free_one(struct bnxt *bp, u16 vnic_id)
 		req.vnic_id =
 			cpu_to_le32(bp->vnic_info[vnic_id].fw_vnic_id);
 
-		rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+		hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 		bp->vnic_info[vnic_id].fw_vnic_id = INVALID_HW_RING_ID;
 	}
-	return rc;
 }
 
 static void bnxt_hwrm_vnic_free(struct bnxt *bp)
@@ -5191,14 +5188,13 @@ static int bnxt_hwrm_ring_grp_alloc(struct bnxt *bp)
 	return rc;
 }
 
-static int bnxt_hwrm_ring_grp_free(struct bnxt *bp)
+static void bnxt_hwrm_ring_grp_free(struct bnxt *bp)
 {
 	u16 i;
-	u32 rc = 0;
 	struct hwrm_ring_grp_free_input req = {0};
 
 	if (!bp->grp_info || (bp->flags & BNXT_FLAG_CHIP_P5))
-		return 0;
+		return;
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_RING_GRP_FREE, -1, -1);
 
@@ -5209,12 +5205,10 @@ static int bnxt_hwrm_ring_grp_free(struct bnxt *bp)
 		req.ring_group_id =
 			cpu_to_le32(bp->grp_info[i].fw_grp_id);
 
-		rc = _hwrm_send_message(bp, &req, sizeof(req),
-					HWRM_CMD_TIMEOUT);
+		_hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 		bp->grp_info[i].fw_grp_id = INVALID_HW_RING_ID;
 	}
 	mutex_unlock(&bp->hwrm_cmd_lock);
-	return rc;
 }
 
 static int hwrm_ring_alloc_send_msg(struct bnxt *bp,
@@ -6302,16 +6296,16 @@ int bnxt_hwrm_set_coal(struct bnxt *bp)
 	return rc;
 }
 
-static int bnxt_hwrm_stat_ctx_free(struct bnxt *bp)
+static void bnxt_hwrm_stat_ctx_free(struct bnxt *bp)
 {
-	int rc = 0, i;
 	struct hwrm_stat_ctx_free_input req = {0};
+	int i;
 
 	if (!bp->bnapi)
-		return 0;
+		return;
 
 	if (BNXT_CHIP_TYPE_NITRO_A0(bp))
-		return 0;
+		return;
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_STAT_CTX_FREE, -1, -1);
 
@@ -6323,14 +6317,13 @@ static int bnxt_hwrm_stat_ctx_free(struct bnxt *bp)
 		if (cpr->hw_stats_ctx_id != INVALID_STATS_CTX_ID) {
 			req.stat_ctx_id = cpu_to_le32(cpr->hw_stats_ctx_id);
 
-			rc = _hwrm_send_message(bp, &req, sizeof(req),
-						HWRM_CMD_TIMEOUT);
+			_hwrm_send_message(bp, &req, sizeof(req),
+					   HWRM_CMD_TIMEOUT);
 
 			cpr->hw_stats_ctx_id = INVALID_STATS_CTX_ID;
 		}
 	}
 	mutex_unlock(&bp->hwrm_cmd_lock);
-	return rc;
 }
 
 static int bnxt_hwrm_stat_ctx_alloc(struct bnxt *bp)
-- 
2.5.1

