Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A16CA634309
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 18:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234661AbiKVRyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 12:54:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234481AbiKVRy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 12:54:27 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4D1EE18
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 09:51:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669139488; x=1700675488;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ahNyKUvpxh9s2KB8NbLai5X1RnpDf1ci90JUNTyCLLk=;
  b=VDoS1y8UjSyo71+lrbBkRietQCpF4zJYEOVXH78RuteaXhXG9f7l+Zmg
   40jFQSE8lg+jZ69ZwU0ehr/q73UR45s+xPYdmnfCqlmP4KxjVIzEVbhtS
   sfLG4r/6z1BjLGqFwFm3gi0gn6wcEA11pAKlIX9+5L0mF/Wr+YDjwmBVf
   v8+YqXrMBs/89cX8H8PBWvBhMNG+E80PrLtQJgVVUxuMq8rM27c0x+enI
   diM5w1YzNG2cUjAWAByrkjRCztsyqUHthHSDQBzLM0A6ybhMidbE0+Vki
   A3pwjraX/xpAND6SlsIE2D4B2Kj5Sb4JcWaaivNs5XpvJ8FUd4l3h4Rb1
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="315695702"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="315695702"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 09:46:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="886621113"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="886621113"
Received: from bswcg005.iind.intel.com ([10.224.174.166])
  by fmsmga006.fm.intel.com with ESMTP; 22 Nov 2022 09:46:19 -0800
From:   m.chetan.kumar@linux.intel.com
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@linux.intel.com, linuxwwan@intel.com,
        edumazet@google.com, pabeni@redhat.com,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net 1/4] net: wwan: iosm: fix kernel test robot reported error
Date:   Tue, 22 Nov 2022 23:16:15 +0530
Message-Id: <20221122174615.3496806-1-m.chetan.kumar@linux.intel.com>
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

