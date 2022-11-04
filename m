Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9EAB61A2BC
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 21:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbiKDUya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 16:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiKDUy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 16:54:27 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C324A1838E
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 13:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667595266; x=1699131266;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+g3krU+7Cr5eTFYUhMKJ4JVUaV6xSzuTMHf/r2/ChGo=;
  b=oJeAQwfAwaNptlR4WGXMXGdX9DX5EANlLfiSPgZdTAT++O20CoGJW8zP
   P3i4ruVYxSz3hAhglvoTBGZE7yJPxL4lALidH8Su6XhrJOEx7Z6cxihM4
   Jev8t8QrOBR5h/ihVF7aAeI1y9P/YAAUcwzeiGq6XOzWZg+/ZHJ/NaD+c
   aL93pakMR0KPWMmFvVfPZrnSz39SX2PneyoZSVHUDmZUBUsBm7XZ4yl52
   AZnFwAL5tVpg/uU+GbadTjIwXuSuw+kQ49j01kksSTdCJdvZZ+6lgPbtf
   wv1YO6TLe6wCvyhwaDeHJff92xANmU5gBklbLo9QXs1KTjzJ1pqSAU0la
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="372177363"
X-IronPort-AV: E=Sophos;i="5.96,138,1665471600"; 
   d="scan'208";a="372177363"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 13:54:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="637716207"
X-IronPort-AV: E=Sophos;i="5.96,138,1665471600"; 
   d="scan'208";a="637716207"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 04 Nov 2022 13:54:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 2/6] ixgbe: Remove local variable
Date:   Fri,  4 Nov 2022 13:54:10 -0700
Message-Id: <20221104205414.2354973-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221104205414.2354973-1-anthony.l.nguyen@intel.com>
References: <20221104205414.2354973-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

Remove local variable "match" and directly return evaluated conditional
instead.

Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index d737e851a9e0..6cfc9dc16537 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -1996,18 +1996,13 @@ static bool ixgbe_check_lbtest_frame(struct ixgbe_rx_buffer *rx_buffer,
 				     unsigned int frame_size)
 {
 	unsigned char *data;
-	bool match = true;
 
 	frame_size >>= 1;
 
 	data = page_address(rx_buffer->page) + rx_buffer->page_offset;
 
-	if (data[3] != 0xFF ||
-	    data[frame_size + 10] != 0xBE ||
-	    data[frame_size + 12] != 0xAF)
-		match = false;
-
-	return match;
+	return data[3] == 0xFF && data[frame_size + 10] == 0xBE &&
+		data[frame_size + 12] == 0xAF;
 }
 
 static u16 ixgbe_clean_test_rings(struct ixgbe_ring *rx_ring,
-- 
2.35.1

