Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78F6A65872B
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 23:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbiL1WCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 17:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiL1WCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 17:02:12 -0500
Received: from mail-pl1-x661.google.com (mail-pl1-x661.google.com [IPv6:2607:f8b0:4864:20::661])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744C9D12F
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 14:02:10 -0800 (PST)
Received: by mail-pl1-x661.google.com with SMTP id jl4so10937969plb.8
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 14:02:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xuBTnBw3e6+eEZpzYRGIQUmG2+HiTTXWn6T+oELsVl4=;
        b=bkO1U8qEb3FdDAdoPzpdLztmzTLtXT8GgdJv5zyn8FbNNDJ3LyARiAlmzYZ5LBG0lR
         fjm6mZmi5qekr3TcPpNTBySGIjrfxWGWzhVGyeJwUk9ox8+hlUia2/7tdmWeNPgXszOz
         FcQrRQ5JMxsi4aEgpFv3nmCYQecn8m1k07DSb/7HTRWUdPJBfITqbzw928JkaE/N27cu
         VGj4t00Wyl6dG2QAXL8E6o/MdXAtvWvkXxocjUmGXriAxnVXqgRH+VB73s9y533gjpGi
         Px8yN8xERw5fzdaOn/IBmXWQiqzuLHQ1+A7Q1QZf6if3AoBs0By36hfDmAfR8NYG1G1g
         0e1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xuBTnBw3e6+eEZpzYRGIQUmG2+HiTTXWn6T+oELsVl4=;
        b=eobbvfcd5CNYUF8QOcRSvXqmcyjUDJ8FiDLvoYCANakCPmouGwoy/SSPLFX3zZB4oT
         xInp0wEBn2FSowImI6CfDrPkWb7dqcPmclbXMhxxGzYf16qAYsgh/33wx8JSFc2/NdOT
         H7D14dn3tpJYOxNMUP5+RJ0iowKu1b/zEwdeFW2ayIQGbC2Dtb+2Fi+A8IM17kwOc7pd
         HKoKPmJWj6BCrTmGpocZrdKTB3xivsuqI1/l9z+9rG96Ce388axASgA175pg7OcXEk4l
         kdD9Yv2CXWBGdhsWjD39iCPTmrgEewkQrazQ6r7QrFQiv3mMJWGQEcSCaymW71p8lxLQ
         Oaug==
X-Gm-Message-State: AFqh2krfHeLAlyjys1jLGJwafKhcb7IIhD6X3uIEsZ/Sb+T/dILkKMp9
        mOvSjzRUMrmRTX4lCA5dVNf5hAkqSq/b+efNQ0m4wjyipcBi4Tmrf+BEkJt5uHSmYw==
X-Google-Smtp-Source: AMrXdXuQ1cSgN4B9J5+Pp9J4bxrY+j81Ge0feFr75tR6RnlMdNmuu3Imye9j7RIZN6YwPBMYFIlwOw0lGLPS
X-Received: by 2002:a17:902:7284:b0:190:d273:38a9 with SMTP id d4-20020a170902728400b00190d27338a9mr28388900pll.14.1672264929965;
        Wed, 28 Dec 2022 14:02:09 -0800 (PST)
Received: from c7-smtp.dev.purestorage.com ([2620:125:9007:320:7:32:106:0])
        by smtp-relay.gmail.com with ESMTPS id y18-20020a170902d65200b00172a52d5e42sm884798plh.42.2022.12.28.14.02.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Dec 2022 14:02:09 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
        by c7-smtp.dev.purestorage.com (Postfix) with ESMTP id 21BD42216C;
        Wed, 28 Dec 2022 15:02:09 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
        id 1CFF5E40CD0; Wed, 28 Dec 2022 15:02:09 -0700 (MST)
From:   Caleb Sander <csander@purestorage.com>
To:     Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Joern Engel <joern@purestorage.com>,
        Caleb Sander <csander@purestorage.com>,
        Alok Prasad <palok@marvell.com>
Subject: [PATCH net v2] qed: allow sleep in qed_mcp_trace_dump()
Date:   Wed, 28 Dec 2022 15:00:46 -0700
Message-Id: <20221228220045.101647-1-csander@purestorage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <71c526c6bf99171fef334ab9d51f78777e7b9df5.camel@redhat.com>
References: <71c526c6bf99171fef334ab9d51f78777e7b9df5.camel@redhat.com>
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

By default, qed_mcp_cmd_and_union() delays 10us at a time in a loop
that can run 500K times, so calls to qed_mcp_nvm_rd_cmd()
may block the current thread for over 5s.
We observed thread scheduling delays over 700ms in production,
with stacktraces pointing to this code as the culprit.

qed_mcp_trace_dump() is called from ethtool, so sleeping is permitted.
It already can sleep in qed_mcp_halt(), which calls qed_mcp_cmd().
Add a "can sleep" parameter to qed_find_nvram_image() and
qed_nvram_read() so they can sleep during qed_mcp_trace_dump().
qed_mcp_trace_get_meta_info() and qed_mcp_trace_read_meta(),
called only by qed_mcp_trace_dump(), allow these functions to sleep.
I can't tell if the other caller (qed_grc_dump_mcp_hw_dump()) can sleep,
so keep b_can_sleep set to false when it calls these functions.

Signed-off-by: Caleb Sander <csander@purestorage.com>
Acked-by: Alok Prasad <palok@marvell.com>
Fixes: c965db4446291 ("qed: Add support for debug data collection")
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

