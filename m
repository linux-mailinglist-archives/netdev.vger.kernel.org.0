Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 230B34FE822
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 20:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358758AbiDLSmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 14:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358752AbiDLSlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 14:41:53 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0CF63205D
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 11:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649788774; x=1681324774;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Nf4dQ8M4/Q+zfYcnDH6ue2bOcCkU3LEDy5ATvfPKRw0=;
  b=PI1oZ52GbO0TLb9UYL245/XUsATrzpdCkROPigh5KKtI7uxlo0p/X9ih
   +K7BnLQ1BqiDK9NWveFwNfc3sH6/mqNfKqh8EATGAZK3yby1nmUy3eAko
   TJ/u7jxcN7DPuq9DQbN6AYDmQj8WlINceRsS10GO3gZoygA6WhchjXIjp
   ysDAMAIzVUVG9aZRJgV65BchTY4egKUR63PznIN4eQgvYjVztemaaBkzi
   Ft16ETEtn0E6m2lAc0QWdySd33WB3n/l8r6YbaLQKXCEG18Q1CeTu5ngG
   JlPxvF6Jw1f1DUFtXnJrWKPOmTGG/LqrvPJZFTQSbZJ0bFGN8Wb0b7zSa
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="322919273"
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="322919273"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 11:39:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="590453089"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 12 Apr 2022 11:39:29 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     "Nabil S. Alramli" <dev@nalramli.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 4/5] i40e: Add vsi.tx_restart to i40e ethtool stats
Date:   Tue, 12 Apr 2022 11:36:35 -0700
Message-Id: <20220412183636.1408915-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220412183636.1408915-1-anthony.l.nguyen@intel.com>
References: <20220412183636.1408915-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Nabil S. Alramli" <dev@nalramli.com>

Add vsi.tx_restart to the i40e driver ethtool statistics

Signed-off-by: Nabil S. Alramli <dev@nalramli.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 162bae158160..610f00cbaff9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -300,6 +300,7 @@ static const struct i40e_stats i40e_gstrings_misc_stats[] = {
 	I40E_VSI_STAT("rx_cache_alloc", rx_page_alloc),
 	I40E_VSI_STAT("rx_cache_waive", rx_page_waive),
 	I40E_VSI_STAT("rx_cache_busy", rx_page_busy),
+	I40E_VSI_STAT("tx_restart", tx_restart),
 };
 
 /* These PF_STATs might look like duplicates of some NETDEV_STATs,
-- 
2.31.1

