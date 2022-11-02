Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAB1A616F63
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 22:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbiKBVKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 17:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbiKBVKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 17:10:25 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC62CDFE1
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 14:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667423422; x=1698959422;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Hbx2rBwlzRL/QJDQfzpWKwRdH5xTlYuOaavZdv3suAc=;
  b=PYX1uIfIPlyOHP5IFwxeU8o34FRAH8kIvPRVYQ9LdG+bK8wv0TQ7rbXZ
   CyYzz0/PDON5ngN4x0XKIBv27/GeEuxEPI5cy8xBkjQisqveudHO9SVQK
   OUYhpkvb8acRuCkOfgq1N3yNzKlPYnSas15bJkccmuX/z22Pt2c/YPNVX
   CrkNeTc14EmEK8saEVFGAYk8EDThF/TsuVnciIBp24uEkLqkuwnJrvOyA
   vLEWPN6ty83i3ahcQ0vbmTkwt8I9SLO4Bv3VvCnydPT86PDI11gfTk8ZE
   9Va9LNfaqKoQ5+O6tqOza7xdtltWu63mHwOa6sg7T/GAEafDEwtVBSy0p
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="311245991"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="311245991"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 14:10:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="629103003"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="629103003"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 02 Nov 2022 14:10:18 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Alicja Kowalska <alicjax.kowalska@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Kamil Maziarz <kamil.maziarz@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 5/7] i40e: Add appropriate error message logged for incorrect duplex setting
Date:   Wed,  2 Nov 2022 14:10:09 -0700
Message-Id: <20221102211011.2944983-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221102211011.2944983-1-anthony.l.nguyen@intel.com>
References: <20221102211011.2944983-1-anthony.l.nguyen@intel.com>
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

From: Alicja Kowalska <alicjax.kowalska@intel.com>

Nothing logged in dmesg for attempting to set incorrect duplex.
Add appropriate error message logged for incorrect duplex setting.

Signed-off-by: Alicja Kowalska <alicjax.kowalska@intel.com>
Signed-off-by: Kamil Maziarz <kamil.maziarz@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index cc269f9db99f..616d27ec3226 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -1287,8 +1287,10 @@ static int i40e_set_link_ksettings(struct net_device *netdev,
 	 * trying to set something that we do not support.
 	 */
 	if (memcmp(&copy_ks.base, &safe_ks.base,
-		   sizeof(struct ethtool_link_settings)))
+		   sizeof(struct ethtool_link_settings))) {
+		netdev_err(netdev, "Only speed and autoneg are supported.\n");
 		return -EOPNOTSUPP;
+	}
 
 	while (test_and_set_bit(__I40E_CONFIG_BUSY, pf->state)) {
 		timeout--;
-- 
2.35.1

