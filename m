Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B992B6376A0
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 11:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiKXKjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 05:39:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiKXKjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 05:39:09 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226AF205E8
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 02:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669286349; x=1700822349;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gK9lJEPQhoeKGmn0SLkYFb/fwQG86BGbl4bBaAYLIFs=;
  b=Z8FRdpPqhu8Ymu3l9Aarq44o/ozQItYfL8vwZheeD1DlrbsoYTDg1Zp0
   WPvG+1zqbvcR8P+ME2gfLrJ5x035uVebrkESpu9fEk5j+wPPIxSVrO813
   SuJF3ACkbVIDpL7WSP95cWpZ0RkX/NVTUWf0BTm1/3/kMIDT00aX4znyp
   JBkDyaKsS9e+cNLpawrLC2qo/3EnJDysbALCu1w04idzv3XPtjH4axtBX
   AXPlw1liU+TesvLn7K1CoAFANLnV3yTWsffDIrjTJIkJ/qnKBnIv7/VPR
   KyBnlPsIhlaSum1UyNx9JeuM0eidIoL0FJlAhiF6/JdRqYKqCFnxY2DrW
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="400566435"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="400566435"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 02:37:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="887327832"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="887327832"
Received: from bswcg005.iind.intel.com ([10.224.174.166])
  by fmsmga006.fm.intel.com with ESMTP; 24 Nov 2022 02:37:54 -0800
From:   m.chetan.kumar@linux.intel.com
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, linuxwwan@intel.com, edumazet@google.com,
        pabeni@redhat.com, M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v2 net 1/4] net: wwan: iosm: fix kernel test robot reported error
Date:   Thu, 24 Nov 2022 16:07:46 +0530
Message-Id: <20221124103746.1445987-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

sparse warnings - iosm_ipc_mux_codec.c:1474 using plain
integer as NULL pointer.

Use skb_trim() to reset skb tail & len.

Fixes: 9413491e20e1 ("net: iosm: encode or decode datagram")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
--
v2: No Change.
---
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c b/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
index d41e373f9c0a..c16365123660 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
@@ -1471,8 +1471,7 @@ void ipc_mux_ul_encoded_process(struct iosm_mux *ipc_mux, struct sk_buff *skb)
 			ipc_mux->ul_data_pend_bytes);
 
 	/* Reset the skb settings. */
-	skb->tail = 0;
-	skb->len = 0;
+	skb_trim(skb, 0);
 
 	/* Add the consumed ADB to the free list. */
 	skb_queue_tail((&ipc_mux->ul_adb.free_list), skb);
-- 
2.34.1

