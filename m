Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58F8B4AE81C
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 05:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344527AbiBIEHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 23:07:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347164AbiBIDjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 22:39:12 -0500
X-Greylist: delayed 353 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Feb 2022 19:29:47 PST
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7079FC0613C9;
        Tue,  8 Feb 2022 19:29:47 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1644377032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Kdr8dNn4iICRISRtuisg+/4TjCNRd8kV1b7gGhU6794=;
        b=jNWyA+20XpR9BiQpgr2sdbar754HhKFYaY3yP93kBGgYVNQJ6BgA4lLdv3IrzL9PkngtV5
        OxrNpq6Fro54w0asFlDnSOTHmEcQ91XE9qV5O3i8qbn9ckZxmlIM8VJyS9L1cnSEPO+8Y9
        vj0DqXFYuumPPHcw1McTSeMjpJKu8Pc=
From:   Cai Huoqing <cai.huoqing@linux.dev>
To:     cai.huoqing@linux.dev
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Mukesh Sisodiya <mukesh.sisodiya@intel.com>,
        Matti Gottlieb <matti.gottlieb@intel.com>,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Abhishek Naik <abhishek.naik@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: Make use of the helper macro LIST_HEAD()
Date:   Wed,  9 Feb 2022 11:23:20 +0800
Message-Id: <20220209032322.37472-1-cai.huoqing@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,TO_EQ_FM_DIRECT_MX,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace "struct list_head head = LIST_HEAD_INIT(head)" with
"LIST_HEAD(head)" to simplify the code.

Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 7ad9cee925da..4e1fb02bd51e 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -2444,7 +2444,7 @@ static void iwl_fw_error_dump_data_free(struct iwl_fwrt_dump_data *dump_data)
 static void iwl_fw_error_ini_dump(struct iwl_fw_runtime *fwrt,
 				  struct iwl_fwrt_dump_data *dump_data)
 {
-	struct list_head dump_list = LIST_HEAD_INIT(dump_list);
+	LIST_HEAD(dump_list);
 	struct scatterlist *sg_dump_data;
 	u32 file_len = iwl_dump_ini_file_gen(fwrt, dump_data, &dump_list);
 
-- 
2.25.1

