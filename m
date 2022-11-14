Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A70E628DA8
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 00:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237880AbiKNXnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 18:43:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237515AbiKNXnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 18:43:00 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C032019C3F
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 15:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668469379; x=1700005379;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bI1uEiAjRQOJ7ZaCESNNL4ZR59Sisco88juTR70KLSM=;
  b=axdaW+cgCKI1QTkW9RmmqwQfn2G+P8NE69xyH+H7gaVpeL1ARJno6mpI
   Sid+F4zWamy9j6ihxcVKfkiyvxWUUj5wj5rUNzlJX3sKpC/3MZhqZoeAO
   yI2DQ/A2I13GrxrrMPiY/sSkps8ZoMgst7QgslmbIBqThVWldfhm5YOA3
   yDs+Hzn7vI7LCk8Jky3REaFAyg76uqYLloelVVyptnDRThVdIHOy37W8W
   w33eYLh2Pe8wsa1WBb64bA+O0jScp+m/+/8iEIPELDstOnKP1pHA9KkbM
   Ylhp94fjzL4iVTN/UFKTXzX8AJgMnF6HuA23LxL1k+2gFXdzXNeESejn/
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="310821198"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="310821198"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 15:42:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="702208687"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="702208687"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 14 Nov 2022 15:42:58 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 7/7] ice: Use ICE_RLAN_BASE_S instead of magic number
Date:   Mon, 14 Nov 2022 15:42:50 -0800
Message-Id: <20221114234250.3039889-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221114234250.3039889-1-anthony.l.nguyen@intel.com>
References: <20221114234250.3039889-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>

Commit 72adf2421d9b ("ice: Move common functions out of ice_main.c part
2/7") moved an older version of ice_setup_rx_ctx() function with
usage of magic number 7.
Reimplement the commit 5ab522443bd1 ("ice: Cleanup magic number") to use
ICE_RLAN_BASE_S instead of magic number.

Signed-off-by: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index e864634d66bc..554095b25f44 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -389,7 +389,7 @@ static int ice_setup_rx_ctx(struct ice_rx_ring *ring)
 	 * Indicates the starting address of the descriptor queue defined in
 	 * 128 Byte units.
 	 */
-	rlan_ctx.base = ring->dma >> 7;
+	rlan_ctx.base = ring->dma >> ICE_RLAN_BASE_S;
 
 	rlan_ctx.qlen = ring->count;
 
-- 
2.35.1

