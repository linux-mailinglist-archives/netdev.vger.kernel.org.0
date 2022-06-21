Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A085553EDA
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 01:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354991AbiFUXCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 19:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355019AbiFUXCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 19:02:35 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 877182AE31
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 16:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655852554; x=1687388554;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FkULkhTFrMqyygB+FD+5LHlb5S2KfPcUHB6vKtKZK48=;
  b=SnOg6jmqoVcND/xufQSa8cPjolKS1grHPAGYv6Jg/nMJly/ZZwtCMD4B
   zXY1J9A41Hs9jCcEDNtPRlipfuz1Lpce40Od7FYcUzvig+jNm/q80jQML
   mpYNbp/HEJ7qad/HdwnEJ6dIAKvxK9F5CXVElezsEWe8EjWzG0+iiN0nF
   mRiWdBhVhhNfHN9tJqA0VHvg5GVk1TwG0admrvbNSprcv7qWw1O/hXdLE
   6bi3tKd6tyPv/r5i83bzC7jk/faALQJjiYPId7DIJox0CRTrZXvZMZ4p8
   GHZQl1JuYUWv5mM666Gf7lNsBCHD9ZjDypUEjd6IxYXgJa61iKLuKkaBH
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="341943801"
X-IronPort-AV: E=Sophos;i="5.92,210,1650956400"; 
   d="scan'208";a="341943801"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 16:02:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,210,1650956400"; 
   d="scan'208";a="677235001"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Jun 2022 16:02:32 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Bernard Zhao <zhaojunkui2008@126.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 3/3] intel/i40e: delete if NULL check before dev_kfree_skb
Date:   Tue, 21 Jun 2022 15:59:30 -0700
Message-Id: <20220621225930.632741-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220621225930.632741-1-anthony.l.nguyen@intel.com>
References: <20220621225930.632741-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bernard Zhao <zhaojunkui2008@126.com>

dev_kfree_skb check if the input parameter NULL and do the right
thing, there is no need to check again.
This change is to cleanup the code a bit.

Signed-off-by: Bernard Zhao <zhaojunkui2008@126.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index b7967105a549..dadef56e5f9b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1483,10 +1483,8 @@ void i40e_clean_rx_ring(struct i40e_ring *rx_ring)
 	if (!rx_ring->rx_bi)
 		return;
 
-	if (rx_ring->skb) {
-		dev_kfree_skb(rx_ring->skb);
-		rx_ring->skb = NULL;
-	}
+	dev_kfree_skb(rx_ring->skb);
+	rx_ring->skb = NULL;
 
 	if (rx_ring->xsk_pool) {
 		i40e_xsk_clean_rx_ring(rx_ring);
-- 
2.35.1

