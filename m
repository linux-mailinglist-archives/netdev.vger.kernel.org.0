Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2CF6179C7
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 10:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbiKCJYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 05:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiKCJYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 05:24:12 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82DDEDE97
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 02:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667467424; x=1699003424;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=81u8MnMJrGWz+OnkZM0nkECK4iP+qgDJK5vpye3gGsk=;
  b=QNay40Vkb0O5InroNKtNPo0kywDXy6eOEVA6K0flOeIRLsL+Px4BlZKS
   JjQ7zNX/06oltRxIuINsTo4e9fmQFnqmUep7nH4ztueGTs1UT7gotC4Du
   tM1MqTCSDyWUvrC00UuINeruXKH+Dysn3UwMalvU29dZYQOZdsmtAk2TY
   wotc2PtC2izX6FJFBgdo663s4YjwbOd6ZEbTkM54s/sxuZA2FJR8NVJhO
   O3OzLMzhqn6Uum0dqzq0dX12vCrTPOCVANumUoY7ideGa6Z5k0UqEuus/
   gBMzugYSmdsvvD+07iwzSibpNnDAXq6LnB6ZM/EefNS7m9u2NAvTMeIa2
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="373862201"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="373862201"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 02:23:44 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="723875300"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="723875300"
Received: from sreehari-nuc.iind.intel.com ([10.223.163.48])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 02:23:39 -0700
From:   Sreehari Kancharla <sreehari.kancharla@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, ricardo.martinez@linux.intel.com,
        andriy.shevchenko@linux.intel.com, dinesh.sharma@intel.com,
        ilpo.jarvinen@linux.intel.com, moises.veleta@intel.com,
        sreehari.kancharla@linux.intel.com, sreehari.kancharla@intel.com
Subject: [PATCH net-next v3 1/2] net: wwan: t7xx: Use needed_headroom instead of hard_header_len
Date:   Thu,  3 Nov 2022 14:48:28 +0530
Message-Id: <20221103091829.28432-1-sreehari.kancharla@linux.intel.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

hard_header_len is used by gro_list_prepare() but on Rx, there
is no header so use needed_headroom instead.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sreehari Kancharla <sreehari.kancharla@linux.intel.com>
Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
--
v2, v3:
 * No change.
---
 drivers/net/wwan/t7xx/t7xx_netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/t7xx/t7xx_netdev.c b/drivers/net/wwan/t7xx/t7xx_netdev.c
index f71d3bc3b237..7639846fa3df 100644
--- a/drivers/net/wwan/t7xx/t7xx_netdev.c
+++ b/drivers/net/wwan/t7xx/t7xx_netdev.c
@@ -161,7 +161,7 @@ static void t7xx_ccmni_post_stop(struct t7xx_ccmni_ctrl *ctlb)
 
 static void t7xx_ccmni_wwan_setup(struct net_device *dev)
 {
-	dev->hard_header_len += sizeof(struct ccci_header);
+	dev->needed_headroom += sizeof(struct ccci_header);
 
 	dev->mtu = ETH_DATA_LEN;
 	dev->max_mtu = CCMNI_MTU_MAX;
-- 
2.17.1

