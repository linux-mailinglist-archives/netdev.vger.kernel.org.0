Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE093FA9F6
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 09:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234851AbhH2HgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 03:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234850AbhH2HgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 03:36:20 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BAB3C061756
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 00:35:28 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id n27so23773915eja.5
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 00:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FQPXpm4Ykdz8mlAF6un/yliIg4RdcdVQAUsj+X9x7ec=;
        b=QCVpIjRHAOOZk6Kr+u0qQR9xW7hVzRQQCpYgWjUZ7PWqDq732bbgk/GkA6ATXiMZsR
         TlpOJbvAPoedfL1CYzLe1aGUsxxA42plVY51tJEni35oo6JcbP4TeQrK4I8DdbMlbxeL
         ac8wTz/KG4hYfX0BrxvdJKHswl7NZZqFy0UaA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FQPXpm4Ykdz8mlAF6un/yliIg4RdcdVQAUsj+X9x7ec=;
        b=VRIyhoEA4q569AHPqW85yZQQejrrX2lVGWkbSDBr7U6vFPQpk3O1hOFkzu50Az5cPp
         tTThiUYhezHpxZHodcOAo0zRMmtU/uxinQ/LzCRS3C8PXgnI0Jyu6BQLKvlVx5uoPR1t
         7tTaSGSShoH1WrLcZT+1TbUxBXuLvo78MOfA/dFhOTJruWdEgGMDDFvkzqs4ThkV31YI
         0CyEswOLrmE3IY1XkiYlot0IqrjxKMSXGOzbQMJfHdC/ZFI4KQjEsmHNerY+j5x1AMkD
         PjpFB+xCXCqf94lgLQZ7F0jmtFig/R8v6iuV2U/fNGaxEvtFz9zEBQGLBP7nOYYhPtbk
         F9Ng==
X-Gm-Message-State: AOAM533znsxKN8fzk8rJByfGK3ZdCb5oXwrqiEDg5Opn98rWcz1ykHxV
        Ikt3hswxw6riJ8+0FzBWGK1Z5Q==
X-Google-Smtp-Source: ABdhPJxeMlG2beu5i3qQjE/pyQpO5tpwGfIEIzrb2fTLgzunuufxuuDliLvIQdW1TudssvdDtagyLw==
X-Received: by 2002:a17:906:160a:: with SMTP id m10mr19046533ejd.67.1630222525443;
        Sun, 29 Aug 2021 00:35:25 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id dy7sm984007edb.38.2021.08.29.00.35.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 29 Aug 2021 00:35:24 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com
Subject: [PATCH net-next v2 03/11] bnxt_en: move HWRM API implementation into separate file
Date:   Sun, 29 Aug 2021 03:34:58 -0400
Message-Id: <1630222506-19532-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1630222506-19532-1-git-send-email-michael.chan@broadcom.com>
References: <1630222506-19532-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000092a1bb05caadc2a3"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000092a1bb05caadc2a3

From: Edwin Peer <edwin.peer@broadcom.com>

Move all firmware messaging functions and definitions to new
bnxt_hwrm.[ch].  The follow-on patches will make major modifications
to these APIs.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/Makefile   |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 273 +---------------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  84 -----
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c |   1 +
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |   1 +
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |   1 +
 .../net/ethernet/broadcom/bnxt/bnxt_hwrm.c    | 297 ++++++++++++++++++
 .../net/ethernet/broadcom/bnxt/bnxt_hwrm.h    | 100 ++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c |   1 +
 .../net/ethernet/broadcom/bnxt/bnxt_sriov.c   |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c |   1 +
 13 files changed, 407 insertions(+), 357 deletions(-)
 create mode 100644 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
 create mode 100644 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h

diff --git a/drivers/net/ethernet/broadcom/bnxt/Makefile b/drivers/net/ethernet/broadcom/bnxt/Makefile
index 2b8ae687b3c1..c6ef7ec2c115 100644
--- a/drivers/net/ethernet/broadcom/bnxt/Makefile
+++ b/drivers/net/ethernet/broadcom/bnxt/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_BNXT) += bnxt_en.o
 
-bnxt_en-y := bnxt.o bnxt_sriov.o bnxt_ethtool.o bnxt_dcb.o bnxt_ulp.o bnxt_xdp.o bnxt_ptp.o bnxt_vfr.o bnxt_devlink.o bnxt_dim.o
+bnxt_en-y := bnxt.o bnxt_hwrm.o bnxt_sriov.o bnxt_ethtool.o bnxt_dcb.o bnxt_ulp.o bnxt_xdp.o bnxt_ptp.o bnxt_vfr.o bnxt_devlink.o bnxt_dim.o
 bnxt_en-$(CONFIG_BNXT_FLOWER_OFFLOAD) += bnxt_tc.o
 bnxt_en-$(CONFIG_DEBUG_FS) += bnxt_debugfs.o
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index dd2f80c394f5..10c39801ad5f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -60,6 +60,7 @@
 
 #include "bnxt_hsi.h"
 #include "bnxt.h"
+#include "bnxt_hwrm.h"
 #include "bnxt_ulp.h"
 #include "bnxt_sriov.h"
 #include "bnxt_ethtool.h"
@@ -4549,278 +4550,6 @@ static void bnxt_enable_int(struct bnxt *bp)
 	}
 }
 
-void bnxt_hwrm_cmd_hdr_init(struct bnxt *bp, void *request, u16 req_type,
-			    u16 cmpl_ring, u16 target_id)
-{
-	struct input *req = request;
-
-	req->req_type = cpu_to_le16(req_type);
-	req->cmpl_ring = cpu_to_le16(cmpl_ring);
-	req->target_id = cpu_to_le16(target_id);
-	req->resp_addr = cpu_to_le64(bp->hwrm_cmd_resp_dma_addr);
-}
-
-static int bnxt_hwrm_to_stderr(u32 hwrm_err)
-{
-	switch (hwrm_err) {
-	case HWRM_ERR_CODE_SUCCESS:
-		return 0;
-	case HWRM_ERR_CODE_RESOURCE_LOCKED:
-		return -EROFS;
-	case HWRM_ERR_CODE_RESOURCE_ACCESS_DENIED:
-		return -EACCES;
-	case HWRM_ERR_CODE_RESOURCE_ALLOC_ERROR:
-		return -ENOSPC;
-	case HWRM_ERR_CODE_INVALID_PARAMS:
-	case HWRM_ERR_CODE_INVALID_FLAGS:
-	case HWRM_ERR_CODE_INVALID_ENABLES:
-	case HWRM_ERR_CODE_UNSUPPORTED_TLV:
-	case HWRM_ERR_CODE_UNSUPPORTED_OPTION_ERR:
-		return -EINVAL;
-	case HWRM_ERR_CODE_NO_BUFFER:
-		return -ENOMEM;
-	case HWRM_ERR_CODE_HOT_RESET_PROGRESS:
-	case HWRM_ERR_CODE_BUSY:
-		return -EAGAIN;
-	case HWRM_ERR_CODE_CMD_NOT_SUPPORTED:
-		return -EOPNOTSUPP;
-	default:
-		return -EIO;
-	}
-}
-
-static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
-				 int timeout, bool silent)
-{
-	int i, intr_process, rc, tmo_count;
-	struct input *req = msg;
-	u32 *data = msg;
-	u8 *valid;
-	u16 cp_ring_id, len = 0;
-	struct hwrm_err_output *resp = bp->hwrm_cmd_resp_addr;
-	u16 max_req_len = BNXT_HWRM_MAX_REQ_LEN;
-	struct hwrm_short_input short_input = {0};
-	u32 doorbell_offset = BNXT_GRCPF_REG_CHIMP_COMM_TRIGGER;
-	u32 bar_offset = BNXT_GRCPF_REG_CHIMP_COMM;
-	u16 dst = BNXT_HWRM_CHNL_CHIMP;
-
-	if (BNXT_NO_FW_ACCESS(bp) &&
-	    le16_to_cpu(req->req_type) != HWRM_FUNC_RESET)
-		return -EBUSY;
-
-	if (msg_len > BNXT_HWRM_MAX_REQ_LEN) {
-		if (msg_len > bp->hwrm_max_ext_req_len ||
-		    !bp->hwrm_short_cmd_req_addr)
-			return -EINVAL;
-	}
-
-	if (bnxt_kong_hwrm_message(bp, req)) {
-		dst = BNXT_HWRM_CHNL_KONG;
-		bar_offset = BNXT_GRCPF_REG_KONG_COMM;
-		doorbell_offset = BNXT_GRCPF_REG_KONG_COMM_TRIGGER;
-	}
-
-	memset(resp, 0, PAGE_SIZE);
-	cp_ring_id = le16_to_cpu(req->cmpl_ring);
-	intr_process = (cp_ring_id == INVALID_HW_RING_ID) ? 0 : 1;
-
-	req->seq_id = cpu_to_le16(bnxt_get_hwrm_seq_id(bp, dst));
-	/* currently supports only one outstanding message */
-	if (intr_process)
-		bp->hwrm_intr_seq_id = le16_to_cpu(req->seq_id);
-
-	if ((bp->fw_cap & BNXT_FW_CAP_SHORT_CMD) ||
-	    msg_len > BNXT_HWRM_MAX_REQ_LEN) {
-		void *short_cmd_req = bp->hwrm_short_cmd_req_addr;
-		u16 max_msg_len;
-
-		/* Set boundary for maximum extended request length for short
-		 * cmd format. If passed up from device use the max supported
-		 * internal req length.
-		 */
-		max_msg_len = bp->hwrm_max_ext_req_len;
-
-		memcpy(short_cmd_req, req, msg_len);
-		if (msg_len < max_msg_len)
-			memset(short_cmd_req + msg_len, 0,
-			       max_msg_len - msg_len);
-
-		short_input.req_type = req->req_type;
-		short_input.signature =
-				cpu_to_le16(SHORT_REQ_SIGNATURE_SHORT_CMD);
-		short_input.size = cpu_to_le16(msg_len);
-		short_input.req_addr =
-			cpu_to_le64(bp->hwrm_short_cmd_req_dma_addr);
-
-		data = (u32 *)&short_input;
-		msg_len = sizeof(short_input);
-
-		/* Sync memory write before updating doorbell */
-		wmb();
-
-		max_req_len = BNXT_HWRM_SHORT_REQ_LEN;
-	}
-
-	/* Write request msg to hwrm channel */
-	__iowrite32_copy(bp->bar0 + bar_offset, data, msg_len / 4);
-
-	for (i = msg_len; i < max_req_len; i += 4)
-		writel(0, bp->bar0 + bar_offset + i);
-
-	/* Ring channel doorbell */
-	writel(1, bp->bar0 + doorbell_offset);
-
-	if (!pci_is_enabled(bp->pdev))
-		return -ENODEV;
-
-	if (!timeout)
-		timeout = DFLT_HWRM_CMD_TIMEOUT;
-	/* Limit timeout to an upper limit */
-	timeout = min(timeout, HWRM_CMD_MAX_TIMEOUT);
-	/* convert timeout to usec */
-	timeout *= 1000;
-
-	i = 0;
-	/* Short timeout for the first few iterations:
-	 * number of loops = number of loops for short timeout +
-	 * number of loops for standard timeout.
-	 */
-	tmo_count = HWRM_SHORT_TIMEOUT_COUNTER;
-	timeout = timeout - HWRM_SHORT_MIN_TIMEOUT * HWRM_SHORT_TIMEOUT_COUNTER;
-	tmo_count += DIV_ROUND_UP(timeout, HWRM_MIN_TIMEOUT);
-
-	if (intr_process) {
-		u16 seq_id = bp->hwrm_intr_seq_id;
-
-		/* Wait until hwrm response cmpl interrupt is processed */
-		while (bp->hwrm_intr_seq_id != (u16)~seq_id &&
-		       i++ < tmo_count) {
-			/* Abort the wait for completion if the FW health
-			 * check has failed.
-			 */
-			if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
-				return -EBUSY;
-			/* on first few passes, just barely sleep */
-			if (i < HWRM_SHORT_TIMEOUT_COUNTER) {
-				usleep_range(HWRM_SHORT_MIN_TIMEOUT,
-					     HWRM_SHORT_MAX_TIMEOUT);
-			} else {
-				if (HWRM_WAIT_MUST_ABORT(bp, req))
-					break;
-				usleep_range(HWRM_MIN_TIMEOUT,
-					     HWRM_MAX_TIMEOUT);
-			}
-		}
-
-		if (bp->hwrm_intr_seq_id != (u16)~seq_id) {
-			if (!silent)
-				netdev_err(bp->dev, "Resp cmpl intr err msg: 0x%x\n",
-					   le16_to_cpu(req->req_type));
-			return -EBUSY;
-		}
-		len = le16_to_cpu(resp->resp_len);
-		valid = ((u8 *)resp) + len - 1;
-	} else {
-		int j;
-
-		/* Check if response len is updated */
-		for (i = 0; i < tmo_count; i++) {
-			/* Abort the wait for completion if the FW health
-			 * check has failed.
-			 */
-			if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
-				return -EBUSY;
-			len = le16_to_cpu(resp->resp_len);
-			if (len)
-				break;
-			/* on first few passes, just barely sleep */
-			if (i < HWRM_SHORT_TIMEOUT_COUNTER) {
-				usleep_range(HWRM_SHORT_MIN_TIMEOUT,
-					     HWRM_SHORT_MAX_TIMEOUT);
-			} else {
-				if (HWRM_WAIT_MUST_ABORT(bp, req))
-					goto timeout_abort;
-				usleep_range(HWRM_MIN_TIMEOUT,
-					     HWRM_MAX_TIMEOUT);
-			}
-		}
-
-		if (i >= tmo_count) {
-timeout_abort:
-			if (!silent)
-				netdev_err(bp->dev, "Error (timeout: %d) msg {0x%x 0x%x} len:%d\n",
-					   HWRM_TOTAL_TIMEOUT(i),
-					   le16_to_cpu(req->req_type),
-					   le16_to_cpu(req->seq_id), len);
-			return -EBUSY;
-		}
-
-		/* Last byte of resp contains valid bit */
-		valid = ((u8 *)resp) + len - 1;
-		for (j = 0; j < HWRM_VALID_BIT_DELAY_USEC; j++) {
-			/* make sure we read from updated DMA memory */
-			dma_rmb();
-			if (*valid)
-				break;
-			usleep_range(1, 5);
-		}
-
-		if (j >= HWRM_VALID_BIT_DELAY_USEC) {
-			if (!silent)
-				netdev_err(bp->dev, "Error (timeout: %d) msg {0x%x 0x%x} len:%d v:%d\n",
-					   HWRM_TOTAL_TIMEOUT(i),
-					   le16_to_cpu(req->req_type),
-					   le16_to_cpu(req->seq_id), len,
-					   *valid);
-			return -EBUSY;
-		}
-	}
-
-	/* Zero valid bit for compatibility.  Valid bit in an older spec
-	 * may become a new field in a newer spec.  We must make sure that
-	 * a new field not implemented by old spec will read zero.
-	 */
-	*valid = 0;
-	rc = le16_to_cpu(resp->error_code);
-	if (rc && !silent)
-		netdev_err(bp->dev, "hwrm req_type 0x%x seq id 0x%x error 0x%x\n",
-			   le16_to_cpu(resp->req_type),
-			   le16_to_cpu(resp->seq_id), rc);
-	return bnxt_hwrm_to_stderr(rc);
-}
-
-int _hwrm_send_message(struct bnxt *bp, void *msg, u32 msg_len, int timeout)
-{
-	return bnxt_hwrm_do_send_msg(bp, msg, msg_len, timeout, false);
-}
-
-int _hwrm_send_message_silent(struct bnxt *bp, void *msg, u32 msg_len,
-			      int timeout)
-{
-	return bnxt_hwrm_do_send_msg(bp, msg, msg_len, timeout, true);
-}
-
-int hwrm_send_message(struct bnxt *bp, void *msg, u32 msg_len, int timeout)
-{
-	int rc;
-
-	mutex_lock(&bp->hwrm_cmd_lock);
-	rc = _hwrm_send_message(bp, msg, msg_len, timeout);
-	mutex_unlock(&bp->hwrm_cmd_lock);
-	return rc;
-}
-
-int hwrm_send_message_silent(struct bnxt *bp, void *msg, u32 msg_len,
-			     int timeout)
-{
-	int rc;
-
-	mutex_lock(&bp->hwrm_cmd_lock);
-	rc = bnxt_hwrm_do_send_msg(bp, msg, msg_len, timeout, true);
-	mutex_unlock(&bp->hwrm_cmd_lock);
-	return rc;
-}
-
 int bnxt_hwrm_func_drv_rgtr(struct bnxt *bp, unsigned long *bmap, int bmap_size,
 			    bool async_only)
 {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index a4fb1aa12b24..5ff71eeffdd8 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -669,37 +669,7 @@ struct nqe_cn {
 #define RING_CMP(idx)		((idx) & bp->cp_ring_mask)
 #define NEXT_CMP(idx)		RING_CMP(ADV_RAW_CMP(idx, 1))
 
-#define BNXT_HWRM_MAX_REQ_LEN		(bp->hwrm_max_req_len)
-#define BNXT_HWRM_SHORT_REQ_LEN		sizeof(struct hwrm_short_input)
 #define DFLT_HWRM_CMD_TIMEOUT		500
-#define HWRM_CMD_MAX_TIMEOUT		40000
-#define SHORT_HWRM_CMD_TIMEOUT		20
-#define HWRM_CMD_TIMEOUT		(bp->hwrm_cmd_timeout)
-#define HWRM_RESET_TIMEOUT		((HWRM_CMD_TIMEOUT) * 4)
-#define HWRM_COREDUMP_TIMEOUT		((HWRM_CMD_TIMEOUT) * 12)
-#define BNXT_HWRM_REQ_MAX_SIZE		128
-#define BNXT_HWRM_REQS_PER_PAGE		(BNXT_PAGE_SIZE /	\
-					 BNXT_HWRM_REQ_MAX_SIZE)
-#define HWRM_SHORT_MIN_TIMEOUT		3
-#define HWRM_SHORT_MAX_TIMEOUT		10
-#define HWRM_SHORT_TIMEOUT_COUNTER	5
-
-#define HWRM_MIN_TIMEOUT		25
-#define HWRM_MAX_TIMEOUT		40
-
-#define HWRM_WAIT_MUST_ABORT(bp, req)					\
-	(le16_to_cpu((req)->req_type) != HWRM_VER_GET &&		\
-	 !bnxt_is_fw_healthy(bp))
-
-#define HWRM_TOTAL_TIMEOUT(n)	(((n) <= HWRM_SHORT_TIMEOUT_COUNTER) ?	\
-	((n) * HWRM_SHORT_MIN_TIMEOUT) :				\
-	(HWRM_SHORT_TIMEOUT_COUNTER * HWRM_SHORT_MIN_TIMEOUT +		\
-	 ((n) - HWRM_SHORT_TIMEOUT_COUNTER) * HWRM_MIN_TIMEOUT))
-
-#define HWRM_VALID_BIT_DELAY_USEC	150
-
-#define BNXT_HWRM_CHNL_CHIMP	0
-#define BNXT_HWRM_CHNL_KONG	1
 
 #define BNXT_RX_EVENT		1
 #define BNXT_AGG_EVENT		2
@@ -2185,55 +2155,6 @@ static inline void bnxt_db_write(struct bnxt *bp, struct bnxt_db_info *db,
 	}
 }
 
-static inline bool bnxt_cfa_hwrm_message(u16 req_type)
-{
-	switch (req_type) {
-	case HWRM_CFA_ENCAP_RECORD_ALLOC:
-	case HWRM_CFA_ENCAP_RECORD_FREE:
-	case HWRM_CFA_DECAP_FILTER_ALLOC:
-	case HWRM_CFA_DECAP_FILTER_FREE:
-	case HWRM_CFA_EM_FLOW_ALLOC:
-	case HWRM_CFA_EM_FLOW_FREE:
-	case HWRM_CFA_EM_FLOW_CFG:
-	case HWRM_CFA_FLOW_ALLOC:
-	case HWRM_CFA_FLOW_FREE:
-	case HWRM_CFA_FLOW_INFO:
-	case HWRM_CFA_FLOW_FLUSH:
-	case HWRM_CFA_FLOW_STATS:
-	case HWRM_CFA_METER_PROFILE_ALLOC:
-	case HWRM_CFA_METER_PROFILE_FREE:
-	case HWRM_CFA_METER_PROFILE_CFG:
-	case HWRM_CFA_METER_INSTANCE_ALLOC:
-	case HWRM_CFA_METER_INSTANCE_FREE:
-		return true;
-	default:
-		return false;
-	}
-}
-
-static inline bool bnxt_kong_hwrm_message(struct bnxt *bp, struct input *req)
-{
-	return (bp->fw_cap & BNXT_FW_CAP_KONG_MB_CHNL &&
-		(bnxt_cfa_hwrm_message(le16_to_cpu(req->req_type)) ||
-		 le16_to_cpu(req->target_id) == HWRM_TARGET_ID_KONG));
-}
-
-static inline void *bnxt_get_hwrm_resp_addr(struct bnxt *bp, void *req)
-{
-	return bp->hwrm_cmd_resp_addr;
-}
-
-static inline u16 bnxt_get_hwrm_seq_id(struct bnxt *bp, u16 dst)
-{
-	u16 seq_id;
-
-	if (dst == BNXT_HWRM_CHNL_CHIMP)
-		seq_id = bp->hwrm_cmd_seq++;
-	else
-		seq_id = bp->hwrm_cmd_kong_seq++;
-	return seq_id;
-}
-
 extern const u16 bnxt_lhint_arr[];
 
 int bnxt_alloc_rx_data(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
@@ -2243,11 +2164,6 @@ u32 bnxt_fw_health_readl(struct bnxt *bp, int reg_idx);
 void bnxt_set_tpa_flags(struct bnxt *bp);
 void bnxt_set_ring_params(struct bnxt *);
 int bnxt_set_rx_skb_mode(struct bnxt *bp, bool page_mode);
-void bnxt_hwrm_cmd_hdr_init(struct bnxt *, void *, u16, u16, u16);
-int _hwrm_send_message(struct bnxt *, void *, u32, int);
-int _hwrm_send_message_silent(struct bnxt *bp, void *msg, u32 len, int timeout);
-int hwrm_send_message(struct bnxt *, void *, u32, int);
-int hwrm_send_message_silent(struct bnxt *, void *, u32, int);
 int bnxt_hwrm_func_drv_rgtr(struct bnxt *bp, unsigned long *bmap,
 			    int bmap_size, bool async_only);
 int bnxt_get_nr_rss_ctxs(struct bnxt *bp, int rx_rings);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
index 8a68df4d9e59..df898665763a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
@@ -18,6 +18,7 @@
 #include <rdma/ib_verbs.h>
 #include "bnxt_hsi.h"
 #include "bnxt.h"
+#include "bnxt_hwrm.h"
 #include "bnxt_dcb.h"
 
 #ifdef CONFIG_BNXT_DCB
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 2cd8bb37e641..00b284a028c5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -12,6 +12,7 @@
 #include <net/devlink.h>
 #include "bnxt_hsi.h"
 #include "bnxt.h"
+#include "bnxt_hwrm.h"
 #include "bnxt_vfr.h"
 #include "bnxt_devlink.h"
 #include "bnxt_ethtool.h"
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 5852ae3b26a2..b6aaf14bd7fd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -24,6 +24,7 @@
 #include <linux/timecounter.h>
 #include "bnxt_hsi.h"
 #include "bnxt.h"
+#include "bnxt_hwrm.h"
 #include "bnxt_xdp.h"
 #include "bnxt_ptp.h"
 #include "bnxt_ethtool.h"
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
new file mode 100644
index 000000000000..b2a211b6cdd0
--- /dev/null
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
@@ -0,0 +1,297 @@
+/* Broadcom NetXtreme-C/E network driver.
+ *
+ * Copyright (c) 2020 Broadcom Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+
+#include <asm/byteorder.h>
+#include <linux/dma-mapping.h>
+#include <linux/dmapool.h>
+#include <linux/errno.h>
+#include <linux/ethtool.h>
+#include <linux/if_ether.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+#include <linux/pci.h>
+#include <linux/skbuff.h>
+
+#include "bnxt_hsi.h"
+#include "bnxt.h"
+#include "bnxt_hwrm.h"
+
+void bnxt_hwrm_cmd_hdr_init(struct bnxt *bp, void *request, u16 req_type,
+			    u16 cmpl_ring, u16 target_id)
+{
+	struct input *req = request;
+
+	req->req_type = cpu_to_le16(req_type);
+	req->cmpl_ring = cpu_to_le16(cmpl_ring);
+	req->target_id = cpu_to_le16(target_id);
+	req->resp_addr = cpu_to_le64(bp->hwrm_cmd_resp_dma_addr);
+}
+
+static int bnxt_hwrm_to_stderr(u32 hwrm_err)
+{
+	switch (hwrm_err) {
+	case HWRM_ERR_CODE_SUCCESS:
+		return 0;
+	case HWRM_ERR_CODE_RESOURCE_LOCKED:
+		return -EROFS;
+	case HWRM_ERR_CODE_RESOURCE_ACCESS_DENIED:
+		return -EACCES;
+	case HWRM_ERR_CODE_RESOURCE_ALLOC_ERROR:
+		return -ENOSPC;
+	case HWRM_ERR_CODE_INVALID_PARAMS:
+	case HWRM_ERR_CODE_INVALID_FLAGS:
+	case HWRM_ERR_CODE_INVALID_ENABLES:
+	case HWRM_ERR_CODE_UNSUPPORTED_TLV:
+	case HWRM_ERR_CODE_UNSUPPORTED_OPTION_ERR:
+		return -EINVAL;
+	case HWRM_ERR_CODE_NO_BUFFER:
+		return -ENOMEM;
+	case HWRM_ERR_CODE_HOT_RESET_PROGRESS:
+	case HWRM_ERR_CODE_BUSY:
+		return -EAGAIN;
+	case HWRM_ERR_CODE_CMD_NOT_SUPPORTED:
+		return -EOPNOTSUPP;
+	default:
+		return -EIO;
+	}
+}
+
+static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
+				 int timeout, bool silent)
+{
+	int i, intr_process, rc, tmo_count;
+	struct input *req = msg;
+	u32 *data = msg;
+	u8 *valid;
+	u16 cp_ring_id, len = 0;
+	struct hwrm_err_output *resp = bp->hwrm_cmd_resp_addr;
+	u16 max_req_len = BNXT_HWRM_MAX_REQ_LEN;
+	struct hwrm_short_input short_input = {0};
+	u32 doorbell_offset = BNXT_GRCPF_REG_CHIMP_COMM_TRIGGER;
+	u32 bar_offset = BNXT_GRCPF_REG_CHIMP_COMM;
+	u16 dst = BNXT_HWRM_CHNL_CHIMP;
+
+	if (BNXT_NO_FW_ACCESS(bp) &&
+	    le16_to_cpu(req->req_type) != HWRM_FUNC_RESET)
+		return -EBUSY;
+
+	if (msg_len > BNXT_HWRM_MAX_REQ_LEN) {
+		if (msg_len > bp->hwrm_max_ext_req_len ||
+		    !bp->hwrm_short_cmd_req_addr)
+			return -EINVAL;
+	}
+
+	if (bnxt_kong_hwrm_message(bp, req)) {
+		dst = BNXT_HWRM_CHNL_KONG;
+		bar_offset = BNXT_GRCPF_REG_KONG_COMM;
+		doorbell_offset = BNXT_GRCPF_REG_KONG_COMM_TRIGGER;
+	}
+
+	memset(resp, 0, PAGE_SIZE);
+	cp_ring_id = le16_to_cpu(req->cmpl_ring);
+	intr_process = (cp_ring_id == INVALID_HW_RING_ID) ? 0 : 1;
+
+	req->seq_id = cpu_to_le16(bnxt_get_hwrm_seq_id(bp, dst));
+	/* currently supports only one outstanding message */
+	if (intr_process)
+		bp->hwrm_intr_seq_id = le16_to_cpu(req->seq_id);
+
+	if ((bp->fw_cap & BNXT_FW_CAP_SHORT_CMD) ||
+	    msg_len > BNXT_HWRM_MAX_REQ_LEN) {
+		void *short_cmd_req = bp->hwrm_short_cmd_req_addr;
+		u16 max_msg_len;
+
+		/* Set boundary for maximum extended request length for short
+		 * cmd format. If passed up from device use the max supported
+		 * internal req length.
+		 */
+		max_msg_len = bp->hwrm_max_ext_req_len;
+
+		memcpy(short_cmd_req, req, msg_len);
+		if (msg_len < max_msg_len)
+			memset(short_cmd_req + msg_len, 0,
+			       max_msg_len - msg_len);
+
+		short_input.req_type = req->req_type;
+		short_input.signature =
+				cpu_to_le16(SHORT_REQ_SIGNATURE_SHORT_CMD);
+		short_input.size = cpu_to_le16(msg_len);
+		short_input.req_addr =
+			cpu_to_le64(bp->hwrm_short_cmd_req_dma_addr);
+
+		data = (u32 *)&short_input;
+		msg_len = sizeof(short_input);
+
+		/* Sync memory write before updating doorbell */
+		wmb();
+
+		max_req_len = BNXT_HWRM_SHORT_REQ_LEN;
+	}
+
+	/* Write request msg to hwrm channel */
+	__iowrite32_copy(bp->bar0 + bar_offset, data, msg_len / 4);
+
+	for (i = msg_len; i < max_req_len; i += 4)
+		writel(0, bp->bar0 + bar_offset + i);
+
+	/* Ring channel doorbell */
+	writel(1, bp->bar0 + doorbell_offset);
+
+	if (!pci_is_enabled(bp->pdev))
+		return -ENODEV;
+
+	if (!timeout)
+		timeout = DFLT_HWRM_CMD_TIMEOUT;
+	/* Limit timeout to an upper limit */
+	timeout = min(timeout, HWRM_CMD_MAX_TIMEOUT);
+	/* convert timeout to usec */
+	timeout *= 1000;
+
+	i = 0;
+	/* Short timeout for the first few iterations:
+	 * number of loops = number of loops for short timeout +
+	 * number of loops for standard timeout.
+	 */
+	tmo_count = HWRM_SHORT_TIMEOUT_COUNTER;
+	timeout = timeout - HWRM_SHORT_MIN_TIMEOUT * HWRM_SHORT_TIMEOUT_COUNTER;
+	tmo_count += DIV_ROUND_UP(timeout, HWRM_MIN_TIMEOUT);
+
+	if (intr_process) {
+		u16 seq_id = bp->hwrm_intr_seq_id;
+
+		/* Wait until hwrm response cmpl interrupt is processed */
+		while (bp->hwrm_intr_seq_id != (u16)~seq_id &&
+		       i++ < tmo_count) {
+			/* Abort the wait for completion if the FW health
+			 * check has failed.
+			 */
+			if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
+				return -EBUSY;
+			/* on first few passes, just barely sleep */
+			if (i < HWRM_SHORT_TIMEOUT_COUNTER) {
+				usleep_range(HWRM_SHORT_MIN_TIMEOUT,
+					     HWRM_SHORT_MAX_TIMEOUT);
+			} else {
+				if (HWRM_WAIT_MUST_ABORT(bp, req))
+					break;
+				usleep_range(HWRM_MIN_TIMEOUT,
+					     HWRM_MAX_TIMEOUT);
+			}
+		}
+
+		if (bp->hwrm_intr_seq_id != (u16)~seq_id) {
+			if (!silent)
+				netdev_err(bp->dev, "Resp cmpl intr err msg: 0x%x\n",
+					   le16_to_cpu(req->req_type));
+			return -EBUSY;
+		}
+		len = le16_to_cpu(resp->resp_len);
+		valid = ((u8 *)resp) + len - 1;
+	} else {
+		int j;
+
+		/* Check if response len is updated */
+		for (i = 0; i < tmo_count; i++) {
+			/* Abort the wait for completion if the FW health
+			 * check has failed.
+			 */
+			if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
+				return -EBUSY;
+			len = le16_to_cpu(resp->resp_len);
+			if (len)
+				break;
+			/* on first few passes, just barely sleep */
+			if (i < HWRM_SHORT_TIMEOUT_COUNTER) {
+				usleep_range(HWRM_SHORT_MIN_TIMEOUT,
+					     HWRM_SHORT_MAX_TIMEOUT);
+			} else {
+				if (HWRM_WAIT_MUST_ABORT(bp, req))
+					goto timeout_abort;
+				usleep_range(HWRM_MIN_TIMEOUT,
+					     HWRM_MAX_TIMEOUT);
+			}
+		}
+
+		if (i >= tmo_count) {
+timeout_abort:
+			if (!silent)
+				netdev_err(bp->dev, "Error (timeout: %d) msg {0x%x 0x%x} len:%d\n",
+					   HWRM_TOTAL_TIMEOUT(i),
+					   le16_to_cpu(req->req_type),
+					   le16_to_cpu(req->seq_id), len);
+			return -EBUSY;
+		}
+
+		/* Last byte of resp contains valid bit */
+		valid = ((u8 *)resp) + len - 1;
+		for (j = 0; j < HWRM_VALID_BIT_DELAY_USEC; j++) {
+			/* make sure we read from updated DMA memory */
+			dma_rmb();
+			if (*valid)
+				break;
+			usleep_range(1, 5);
+		}
+
+		if (j >= HWRM_VALID_BIT_DELAY_USEC) {
+			if (!silent)
+				netdev_err(bp->dev, "Error (timeout: %d) msg {0x%x 0x%x} len:%d v:%d\n",
+					   HWRM_TOTAL_TIMEOUT(i),
+					   le16_to_cpu(req->req_type),
+					   le16_to_cpu(req->seq_id), len,
+					   *valid);
+			return -EBUSY;
+		}
+	}
+
+	/* Zero valid bit for compatibility.  Valid bit in an older spec
+	 * may become a new field in a newer spec.  We must make sure that
+	 * a new field not implemented by old spec will read zero.
+	 */
+	*valid = 0;
+	rc = le16_to_cpu(resp->error_code);
+	if (rc && !silent)
+		netdev_err(bp->dev, "hwrm req_type 0x%x seq id 0x%x error 0x%x\n",
+			   le16_to_cpu(resp->req_type),
+			   le16_to_cpu(resp->seq_id), rc);
+	return bnxt_hwrm_to_stderr(rc);
+}
+
+int _hwrm_send_message(struct bnxt *bp, void *msg, u32 msg_len, int timeout)
+{
+	return bnxt_hwrm_do_send_msg(bp, msg, msg_len, timeout, false);
+}
+
+int _hwrm_send_message_silent(struct bnxt *bp, void *msg, u32 msg_len,
+			      int timeout)
+{
+	return bnxt_hwrm_do_send_msg(bp, msg, msg_len, timeout, true);
+}
+
+int hwrm_send_message(struct bnxt *bp, void *msg, u32 msg_len, int timeout)
+{
+	int rc;
+
+	mutex_lock(&bp->hwrm_cmd_lock);
+	rc = _hwrm_send_message(bp, msg, msg_len, timeout);
+	mutex_unlock(&bp->hwrm_cmd_lock);
+	return rc;
+}
+
+int hwrm_send_message_silent(struct bnxt *bp, void *msg, u32 msg_len,
+			     int timeout)
+{
+	int rc;
+
+	mutex_lock(&bp->hwrm_cmd_lock);
+	rc = bnxt_hwrm_do_send_msg(bp, msg, msg_len, timeout, true);
+	mutex_unlock(&bp->hwrm_cmd_lock);
+	return rc;
+}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
new file mode 100644
index 000000000000..940c792b54c7
--- /dev/null
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
@@ -0,0 +1,100 @@
+/* Broadcom NetXtreme-C/E network driver.
+ *
+ * Copyright (c) 2020 Broadcom Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+
+#ifndef BNXT_HWRM_H
+#define BNXT_HWRM_H
+
+#include "bnxt_hsi.h"
+
+#define BNXT_HWRM_MAX_REQ_LEN		(bp->hwrm_max_req_len)
+#define BNXT_HWRM_SHORT_REQ_LEN		sizeof(struct hwrm_short_input)
+#define HWRM_CMD_MAX_TIMEOUT		40000
+#define SHORT_HWRM_CMD_TIMEOUT		20
+#define HWRM_CMD_TIMEOUT		(bp->hwrm_cmd_timeout)
+#define HWRM_RESET_TIMEOUT		((HWRM_CMD_TIMEOUT) * 4)
+#define HWRM_COREDUMP_TIMEOUT		((HWRM_CMD_TIMEOUT) * 12)
+#define BNXT_HWRM_REQ_MAX_SIZE		128
+#define BNXT_HWRM_REQS_PER_PAGE		(BNXT_PAGE_SIZE /	\
+					 BNXT_HWRM_REQ_MAX_SIZE)
+#define HWRM_SHORT_MIN_TIMEOUT		3
+#define HWRM_SHORT_MAX_TIMEOUT		10
+#define HWRM_SHORT_TIMEOUT_COUNTER	5
+
+#define HWRM_MIN_TIMEOUT		25
+#define HWRM_MAX_TIMEOUT		40
+
+#define HWRM_WAIT_MUST_ABORT(bp, req)					\
+	(le16_to_cpu((req)->req_type) != HWRM_VER_GET &&		\
+	 !bnxt_is_fw_healthy(bp))
+
+#define HWRM_TOTAL_TIMEOUT(n)	(((n) <= HWRM_SHORT_TIMEOUT_COUNTER) ?	\
+	((n) * HWRM_SHORT_MIN_TIMEOUT) :				\
+	(HWRM_SHORT_TIMEOUT_COUNTER * HWRM_SHORT_MIN_TIMEOUT +		\
+	 ((n) - HWRM_SHORT_TIMEOUT_COUNTER) * HWRM_MIN_TIMEOUT))
+
+#define HWRM_VALID_BIT_DELAY_USEC	150
+
+#define BNXT_HWRM_CHNL_CHIMP	0
+#define BNXT_HWRM_CHNL_KONG	1
+
+static inline bool bnxt_cfa_hwrm_message(u16 req_type)
+{
+	switch (req_type) {
+	case HWRM_CFA_ENCAP_RECORD_ALLOC:
+	case HWRM_CFA_ENCAP_RECORD_FREE:
+	case HWRM_CFA_DECAP_FILTER_ALLOC:
+	case HWRM_CFA_DECAP_FILTER_FREE:
+	case HWRM_CFA_EM_FLOW_ALLOC:
+	case HWRM_CFA_EM_FLOW_FREE:
+	case HWRM_CFA_EM_FLOW_CFG:
+	case HWRM_CFA_FLOW_ALLOC:
+	case HWRM_CFA_FLOW_FREE:
+	case HWRM_CFA_FLOW_INFO:
+	case HWRM_CFA_FLOW_FLUSH:
+	case HWRM_CFA_FLOW_STATS:
+	case HWRM_CFA_METER_PROFILE_ALLOC:
+	case HWRM_CFA_METER_PROFILE_FREE:
+	case HWRM_CFA_METER_PROFILE_CFG:
+	case HWRM_CFA_METER_INSTANCE_ALLOC:
+	case HWRM_CFA_METER_INSTANCE_FREE:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static inline bool bnxt_kong_hwrm_message(struct bnxt *bp, struct input *req)
+{
+	return (bp->fw_cap & BNXT_FW_CAP_KONG_MB_CHNL &&
+		(bnxt_cfa_hwrm_message(le16_to_cpu(req->req_type)) ||
+		 le16_to_cpu(req->target_id) == HWRM_TARGET_ID_KONG));
+}
+
+static inline void *bnxt_get_hwrm_resp_addr(struct bnxt *bp, void *req)
+{
+	return bp->hwrm_cmd_resp_addr;
+}
+
+static inline u16 bnxt_get_hwrm_seq_id(struct bnxt *bp, u16 dst)
+{
+	u16 seq_id;
+
+	if (dst == BNXT_HWRM_CHNL_CHIMP)
+		seq_id = bp->hwrm_cmd_seq++;
+	else
+		seq_id = bp->hwrm_cmd_kong_seq++;
+	return seq_id;
+}
+
+void bnxt_hwrm_cmd_hdr_init(struct bnxt *, void *, u16, u16, u16);
+int _hwrm_send_message(struct bnxt *bp, void *msg, u32 len, int timeout);
+int _hwrm_send_message_silent(struct bnxt *bp, void *msg, u32 len, int timeout);
+int hwrm_send_message(struct bnxt *bp, void *msg, u32 len, int timeout);
+int hwrm_send_message_silent(struct bnxt *bp, void *msg, u32 len, int timeout);
+#endif
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index 2fe3c9081f8d..4cc2379027cf 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -18,6 +18,7 @@
 #include <linux/ptp_classify.h>
 #include "bnxt_hsi.h"
 #include "bnxt.h"
+#include "bnxt_hwrm.h"
 #include "bnxt_ptp.h"
 
 int bnxt_ptp_parse(struct sk_buff *skb, u16 *seq_id, u16 *hdr_off)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
index 7fa881e1cd80..7b0e308e44c2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
@@ -17,6 +17,7 @@
 #include <linux/etherdevice.h>
 #include "bnxt_hsi.h"
 #include "bnxt.h"
+#include "bnxt_hwrm.h"
 #include "bnxt_ulp.h"
 #include "bnxt_sriov.h"
 #include "bnxt_vfr.h"
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 5e4429b14b8c..c0c3cc426f7b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -22,6 +22,7 @@
 
 #include "bnxt_hsi.h"
 #include "bnxt.h"
+#include "bnxt_hwrm.h"
 #include "bnxt_sriov.h"
 #include "bnxt_tc.h"
 #include "bnxt_vfr.h"
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index 187ff643ad2a..f621cffccd3a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -22,6 +22,7 @@
 
 #include "bnxt_hsi.h"
 #include "bnxt.h"
+#include "bnxt_hwrm.h"
 #include "bnxt_ulp.h"
 
 static int bnxt_register_dev(struct bnxt_en_dev *edev, int ulp_id,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
index dd66302343a2..3ed712a08207 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
@@ -15,6 +15,7 @@
 
 #include "bnxt_hsi.h"
 #include "bnxt.h"
+#include "bnxt_hwrm.h"
 #include "bnxt_vfr.h"
 #include "bnxt_devlink.h"
 #include "bnxt_tc.h"
-- 
2.18.1


--00000000000092a1bb05caadc2a3
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
xV4Em+0wQoEIR2kPG6yiZNtUK0tNCaZejYU/Mf/bzdKSwud3pLgHV8ls83y2OU/ha9xgJMLpRswv
xucFCxMsPmk0yoVmpbr92kIpLm+TomNZsL++LcDRa2ECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUz2bMvqtXpXM0u3vAvRkalz60
CjswDQYJKoZIhvcNAQELBQADggEBAGUgeqqI/q2pkETeLr6oS7nnm1bkeNmtnJ2bnybNO/RdrbPj
DHVSiDCCrWr6xrc+q6OiZDKm0Ieq6BN+Wfr8h5mCkZMUdJikI85WcQTRk6EEF2lzIiaULmFD7U15
FSWQptLx+kiu63idTII4r3k/7+dJ5AhLRr4WCoXEme2GZkfSbYC3fEL46tb1w7w+25OEFCv1MtDZ
1CHkODrS2JGwDQxXKmyF64MhJiOutWHmqoGmLJVz1jnDvClsYtgT4zcNtoqKtjpWDYAefncWDPIQ
DauX1eWVM+KepL7zoSNzVbTipc65WuZFLR8ngOwkpknqvS9n/nKd885m23oIocC+GA4xggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwQeU+Y6hbenPzRMJsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIAWKb/Bs3Yg0S139fx77nTWuM+MfGEnC
6qBBB/SbjMO0MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDgy
OTA3MzUyNlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCcrgagazc3uKni3DZQ0qQvUtjO84LPqzwbuub0jICP20O3lCP6
D/XpBqEi840+KRBD2vt5kDoV32q2o96uhpKn4h2+lB+r4aM0vCmZVDRyiJPnzxQMQHmCCU0GP/gp
+6+SLXmZiaOIYxz0950JCTVDgbmTujNWCKzDesmwEPBhYoujTklOOZS0wTpzZlvdFn1Cj7h3+U1C
C6Eb9lEGpfmnAY2ttuGj2CZLGrajrYPBHf4tuBY7K3gTIe77eJIgA/xM7tMXY+IvHSdFoDku1gxa
NiLpHSeftvRiYuzCLM6iWRYMZoCu/JGw2W44enFqoB/t9+4hkMJm3QgdGL0I4pMD
--00000000000092a1bb05caadc2a3--
