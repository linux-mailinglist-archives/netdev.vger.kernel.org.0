Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEE9352A992
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 19:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351604AbiEQRs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 13:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234922AbiEQRsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 13:48:52 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0908F5006E
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 10:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652809730; x=1684345730;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=PPxU/RzMZUDNchyeAcKf6P7VkZUT00MSl2HYoFL/3d4=;
  b=cKhdU4Ir2OxUmbRNa5+/u1Wt/i/SFgcV2KIKGYPHBmrhUCoqeBaRvxT/
   WlOWC+BZdIHzuLu4w8oBlrxJ0XuF8XVooufYFJWKH4QbfA/zBF7d/3aOL
   HEpwXgVd42w2Y1THAp6SilwgKlTgqFMWEClB7DoY/ujw5alUNE5Dfu1TV
   /cfWzBBa84wRTZrE2UfRGPvYnOy/XINOqIzBEVeDLELe1KNrvYvffM+Jp
   3yEocC6lYfXnFe2yGIN+7AOp70IXTDIoHs8B4juV7f22B18KrGK3LH/2P
   cljAgakY9oP2q+s/uoCgN1Cy676YgTt/2Gzgmf8m3KhT3hKmJjb/RaUR0
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="253316421"
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="253316421"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 10:48:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="545015272"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 17 May 2022 10:48:50 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        richardcochran@gmail.com
Subject: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates 2022-05-17
Date:   Tue, 17 May 2022 10:45:44 -0700
Message-Id: <20220517174547.1757401-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Arkadiusz prevents writing of timestamps when rings are being
configured to resolve null pointer dereference.

Paul changes a delayed call to baseline statistics to occur immediately
which was causing misreporting of statistics due to the delay.

Michal fixes incorrect restoration of interrupt moderation settings.

The following are changes since commit edf410cb74dc612fd47ef5be319c5a0bcd6e6ccd:
  net: vmxnet3: fix possible NULL pointer dereference in vmxnet3_rq_cleanup()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Arkadiusz Kubalewski (1):
  ice: fix crash when writing timestamp on RX rings

Michal Wilczynski (1):
  ice: Fix interrupt moderation settings getting cleared

Paul Greenwalt (1):
  ice: fix possible under reporting of ethtool Tx and Rx statistics

 drivers/net/ethernet/intel/ice/ice_lib.c  | 16 ++++++++--------
 drivers/net/ethernet/intel/ice/ice_main.c |  7 ++++---
 drivers/net/ethernet/intel/ice/ice_ptp.c  | 19 +++++++++++++++----
 drivers/net/ethernet/intel/ice/ice_txrx.h | 11 ++++++++---
 4 files changed, 35 insertions(+), 18 deletions(-)

-- 
2.35.1

