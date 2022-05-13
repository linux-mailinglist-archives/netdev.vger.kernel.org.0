Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F463526889
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 19:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383090AbiEMRfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 13:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241962AbiEMRfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 13:35:02 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C4FE091;
        Fri, 13 May 2022 10:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652463301; x=1683999301;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B/QqEFQ2mEUkuczZyZDlIEde5EgILxhh1qTOe1s6O0c=;
  b=Xoo0gpqQXyUcXJitQaqV4gBBtnh0h4hhEqq4BRIzr+qheunHtPXCwtU8
   /R0iiBnCGNabsckDaPhQajbEIbd84bb/7EG8pji++3Ne7sJLvGk4f4T/x
   qNIf/pkIDty8AfsAdU8OgjBtEYrLMin14QjFP+F/Xm8eSXw6RrkA62oyL
   9bZcQgACsqvpkCB1SswASQzlmTrxLyHsP7bR2p8mXV8wDbfiHLedTXi+L
   PVRYM4pS+4QZDe0DWeZeroshdYHOKPruX6MQc6SRKccwiRxwF6AKuS+ED
   Qv9P2Nx6NvKeaKJz8h8j0pBUoV3+chlOHw9fkLmgCWLgCebxjpOfj3OLT
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10346"; a="250895684"
X-IronPort-AV: E=Sophos;i="5.91,223,1647327600"; 
   d="scan'208";a="250895684"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 10:34:15 -0700
X-IronPort-AV: E=Sophos;i="5.91,223,1647327600"; 
   d="scan'208";a="624950940"
Received: from abarkat-mobl.amr.corp.intel.com (HELO rmarti10-nuc3.hsd1.or.comcast.net) ([10.212.160.143])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 10:34:15 -0700
From:   Ricardo Martinez <ricardo.martinez@linux.intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, andriy.shevchenko@linux.intel.com,
        dinesh.sharma@intel.com, ilpo.jarvinen@linux.intel.com,
        moises.veleta@intel.com, sreehari.kancharla@intel.com,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
Subject: [PATCH net-next 2/2] net: skb: Remove skb_data_area_size()
Date:   Fri, 13 May 2022 10:34:00 -0700
Message-Id: <20220513173400.3848271-3-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220513173400.3848271-1-ricardo.martinez@linux.intel.com>
References: <20220513173400.3848271-1-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb_data_area_size() is not needed. As Jakub pointed out [1]:
For Rx, drivers can use the size passed during skb allocation or
use skb_tailroom().
For Tx, drivers should use skb_headlen().

[1] https://lore.kernel.org/netdev/CAHNKnsTmH-rGgWi3jtyC=ktM1DW2W1VJkYoTMJV2Z_Bt498bsg@mail.gmail.com/

Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 include/linux/skbuff.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 9d82a8b6c8f1..2810a3abe81a 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1764,11 +1764,6 @@ static inline void skb_set_end_offset(struct sk_buff *skb, unsigned int offset)
 }
 #endif
 
-static inline unsigned int skb_data_area_size(struct sk_buff *skb)
-{
-	return skb_end_pointer(skb) - skb->data;
-}
-
 struct ubuf_info *msg_zerocopy_realloc(struct sock *sk, size_t size,
 				       struct ubuf_info *uarg);
 
-- 
2.25.1

