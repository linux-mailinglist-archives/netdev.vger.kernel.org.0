Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE7D64FB73
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 18:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiLQR5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 12:57:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiLQR5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 12:57:04 -0500
Received: from mail-io1-xd63.google.com (mail-io1-xd63.google.com [IPv6:2607:f8b0:4864:20::d63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2252C13D17
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 09:57:01 -0800 (PST)
Received: by mail-io1-xd63.google.com with SMTP id 3so2770510iou.12
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 09:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+e0Tri+9yozxSemCJdzeRWlbTERfju7XWnmwBSfIH40=;
        b=M1rLKOw9qOG+Ocfsn6+WYbQejQIoCgu7NTEWOFOeww3tz71Hm2fpG8O+TiW6iGCB1T
         vHAofbiVeiQZzkFgg+LGh2DgrDUpfWV6XJnhhOhq+rdigIumkvTtu6Xsq5lItjwg2eld
         dG1ZaT814rjHclLUeAAIiVagK5JiUNdtGq+9xztTL8xIH68nZcYAhimdoR9ISx0iVG0h
         viaJo5JpxiDl5HMnswL5VLDMluSQ07AroPa6Huh3W3kwp9V4vBzmH+5V0ddz7I6DH8JA
         4hdPQ9c11O6AdGwQZo9G46MvGTVObyBEIMr3Uyjo53kL4PeKEMQJfLszvFKq3lmnMwAw
         owag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+e0Tri+9yozxSemCJdzeRWlbTERfju7XWnmwBSfIH40=;
        b=GlULd3ArhxueOkRDTVGR9cB8VYHwiKQMmNCoIywZHJJxyMJupBOSys6Sdb8MHa6jjp
         it2O1bzk+tbikJ9iGcl7UUKYwHtafjTsjSGvWP1/k/5AcDyoEhDvvmeHLB94c+DmWCPM
         PXIHIYkK4LAB7AiaF8xiL8S8NqWz4fBCQ/5VvtLqOPz77IXktcpE72TdOyoxJz75c5DK
         PrfI8V2fd3CG0jKVYNLjPY9XWvRFz9xg6lgLiu80Jcmw3A9L1X++FccTyo13ypOQLgw+
         BS1YiQNTKZOqjqeSPq6srJcLlvJV5kyi3Ofy40ST7gK6hYQBoTLxekBC9euXlqZR6GpL
         18iQ==
X-Gm-Message-State: ANoB5pnzsIc0aYhe4X9yVYQCxe+yVmyhNNidLHokwWjit34qqale+DXr
        3XxLT3WMmd3ONeFefZw24edEICi1lDADXkLC+27HFB/JOWCzAw==
X-Google-Smtp-Source: AA0mqf5SjcxecLzgmIzBrzkuU1DNNfg7EAQ9qG+iYM7w2fYdwqX7WXwJ+7GivZ65ZL4fb7blML4TWhkVRtz6
X-Received: by 2002:a6b:fb16:0:b0:6dc:5e15:c6e4 with SMTP id h22-20020a6bfb16000000b006dc5e15c6e4mr19205970iog.11.1671299820502;
        Sat, 17 Dec 2022 09:57:00 -0800 (PST)
Received: from c7-smtp.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id bq6-20020a056638468600b0038c90589d94sm360905jab.43.2022.12.17.09.57.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 17 Dec 2022 09:57:00 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
        by c7-smtp.dev.purestorage.com (Postfix) with ESMTP id 1770622137;
        Sat, 17 Dec 2022 10:57:00 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
        id 0A873E40603; Sat, 17 Dec 2022 10:56:30 -0700 (MST)
From:   Caleb Sander <csander@purestorage.com>
To:     Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>, netdev@vger.kernel.org
Cc:     Joern Engel <joern@purestorage.com>,
        Caleb Sander <csander@purestorage.com>
Subject: [PATCH] qed: allow sleep in qed_mcp_trace_dump()
Date:   Sat, 17 Dec 2022 10:56:12 -0700
Message-Id: <20221217175612.1515174-1-csander@purestorage.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By default, qed_mcp_cmd_and_union() waits for 10us at a time
in a loop that can run 500K times, so calls to qed_mcp_nvm_rd_cmd()
may block the current thread for over 5s.
We observed thread scheduling delays of over 700ms in production,
with stacktraces pointing to this code as the culprit.

qed_mcp_trace_dump() is called from ethtool, so sleeping is permitted.
It already can sleep in qed_mcp_halt(), which calls qed_mcp_cmd().
Add a "can sleep" parameter to qed_find_nvram_image() and
qed_nvram_read() so they can sleep during qed_mcp_trace_dump().
qed_mcp_trace_get_meta_info() and qed_mcp_trace_read_meta(),
called only by qed_mcp_trace_dump(), allow these functions to sleep.
It's not clear to me that the other caller (qed_grc_dump_mcp_hw_dump())
can sleep, so it keeps b_can_sleep set to false.

Signed-off-by: Caleb Sander <csander@purestorage.com>
---
 drivers/net/ethernet/qlogic/qed/qed_debug.c | 28 +++++++++++++++------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
index 86ecb080b153..cdcead614e9f 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -1830,11 +1830,12 @@ static void qed_grc_clear_all_prty(struct qed_hwfn *p_hwfn,
 /* Finds the meta data image in NVRAM */
 static enum dbg_status qed_find_nvram_image(struct qed_hwfn *p_hwfn,
 					    struct qed_ptt *p_ptt,
 					    u32 image_type,
 					    u32 *nvram_offset_bytes,
-					    u32 *nvram_size_bytes)
+					    u32 *nvram_size_bytes,
+					    bool b_can_sleep)
 {
 	u32 ret_mcp_resp, ret_mcp_param, ret_txn_size;
 	struct mcp_file_att file_att;
 	int nvm_result;
 
@@ -1844,11 +1845,12 @@ static enum dbg_status qed_find_nvram_image(struct qed_hwfn *p_hwfn,
 					DRV_MSG_CODE_NVM_GET_FILE_ATT,
 					image_type,
 					&ret_mcp_resp,
 					&ret_mcp_param,
 					&ret_txn_size,
-					(u32 *)&file_att, false);
+					(u32 *)&file_att,
+					b_can_sleep);
 
 	/* Check response */
 	if (nvm_result || (ret_mcp_resp & FW_MSG_CODE_MASK) !=
 	    FW_MSG_CODE_NVM_OK)
 		return DBG_STATUS_NVRAM_GET_IMAGE_FAILED;
@@ -1871,11 +1873,13 @@ static enum dbg_status qed_find_nvram_image(struct qed_hwfn *p_hwfn,
 
 /* Reads data from NVRAM */
 static enum dbg_status qed_nvram_read(struct qed_hwfn *p_hwfn,
 				      struct qed_ptt *p_ptt,
 				      u32 nvram_offset_bytes,
-				      u32 nvram_size_bytes, u32 *ret_buf)
+				      u32 nvram_size_bytes,
+				      u32 *ret_buf,
+				      bool b_can_sleep)
 {
 	u32 ret_mcp_resp, ret_mcp_param, ret_read_size, bytes_to_copy;
 	s32 bytes_left = nvram_size_bytes;
 	u32 read_offset = 0, param = 0;
 
@@ -1897,11 +1901,11 @@ static enum dbg_status qed_nvram_read(struct qed_hwfn *p_hwfn,
 		if (qed_mcp_nvm_rd_cmd(p_hwfn, p_ptt,
 				       DRV_MSG_CODE_NVM_READ_NVRAM, param,
 				       &ret_mcp_resp,
 				       &ret_mcp_param, &ret_read_size,
 				       (u32 *)((u8 *)ret_buf + read_offset),
-				       false))
+				       b_can_sleep))
 			return DBG_STATUS_NVRAM_READ_FAILED;
 
 		/* Check response */
 		if ((ret_mcp_resp & FW_MSG_CODE_MASK) != FW_MSG_CODE_NVM_OK)
 			return DBG_STATUS_NVRAM_READ_FAILED;
@@ -3378,11 +3382,12 @@ static u32 qed_grc_dump_mcp_hw_dump(struct qed_hwfn *p_hwfn,
 	/* Read HW dump image from NVRAM */
 	status = qed_find_nvram_image(p_hwfn,
 				      p_ptt,
 				      NVM_TYPE_HW_DUMP_OUT,
 				      &hw_dump_offset_bytes,
-				      &hw_dump_size_bytes);
+				      &hw_dump_size_bytes,
+				      false);
 	if (status != DBG_STATUS_OK)
 		return 0;
 
 	hw_dump_size_dwords = BYTES_TO_DWORDS(hw_dump_size_bytes);
 
@@ -3395,11 +3400,13 @@ static u32 qed_grc_dump_mcp_hw_dump(struct qed_hwfn *p_hwfn,
 	/* Read MCP HW dump image into dump buffer */
 	if (dump && hw_dump_size_dwords) {
 		status = qed_nvram_read(p_hwfn,
 					p_ptt,
 					hw_dump_offset_bytes,
-					hw_dump_size_bytes, dump_buf + offset);
+					hw_dump_size_bytes,
+					dump_buf + offset,
+					false);
 		if (status != DBG_STATUS_OK) {
 			DP_NOTICE(p_hwfn,
 				  "Failed to read MCP HW Dump image from NVRAM\n");
 			return 0;
 		}
@@ -4121,11 +4128,13 @@ static enum dbg_status qed_mcp_trace_get_meta_info(struct qed_hwfn *p_hwfn,
 	    (*running_bundle_id ==
 	     DIR_ID_1) ? NVM_TYPE_MFW_TRACE1 : NVM_TYPE_MFW_TRACE2;
 	return qed_find_nvram_image(p_hwfn,
 				    p_ptt,
 				    nvram_image_type,
-				    trace_meta_offset, trace_meta_size);
+				    trace_meta_offset,
+				    trace_meta_size,
+				    true);
 }
 
 /* Reads the MCP Trace meta data from NVRAM into the specified buffer */
 static enum dbg_status qed_mcp_trace_read_meta(struct qed_hwfn *p_hwfn,
 					       struct qed_ptt *p_ptt,
@@ -4137,11 +4146,14 @@ static enum dbg_status qed_mcp_trace_read_meta(struct qed_hwfn *p_hwfn,
 	u32 signature;
 
 	/* Read meta data from NVRAM */
 	status = qed_nvram_read(p_hwfn,
 				p_ptt,
-				nvram_offset_in_bytes, size_in_bytes, buf);
+				nvram_offset_in_bytes,
+				size_in_bytes,
+				buf,
+				true);
 	if (status != DBG_STATUS_OK)
 		return status;
 
 	/* Extract and check first signature */
 	signature = qed_read_unaligned_dword(byte_buf);
-- 
2.25.1

