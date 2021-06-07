Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D352639E484
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbhFGQxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:53:03 -0400
Received: from mga14.intel.com ([192.55.52.115]:57119 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230503AbhFGQwr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:52:47 -0400
IronPort-SDR: DOhhuUwvSFLNnqq5LoHuKb+n16sC5MKCl/yGuWpsoxHV4Q5aauTwwnOaqSSJPYQheg1RXK7Pv5
 dEsM8/rzTYMQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10008"; a="204474566"
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="204474566"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2021 09:50:55 -0700
IronPort-SDR: UjQBY4W+3Co39gW7Nd5IYe3ozyQwZbB7jI62eGN/PC2A0FyP9/b9PF66NFzJ2kL7vQ6EqTYIND
 3GigJU9WHKbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="484841273"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 07 Jun 2021 09:50:55 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 14/15] ice: downgrade error print to debug print
Date:   Mon,  7 Jun 2021 09:53:24 -0700
Message-Id: <20210607165325.182087-15-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210607165325.182087-1-anthony.l.nguyen@intel.com>
References: <20210607165325.182087-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

Failing to add or remove LLDP filter doesn't seem to be a fatal
error, so downgrade the dev_err message to a dev_dbg message.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 1c636f4bb4fc..9322c09ac36c 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2239,7 +2239,7 @@ void ice_cfg_sw_lldp(struct ice_vsi *vsi, bool tx, bool create)
 	}
 
 	if (status)
-		dev_err(dev, "Fail %s %s LLDP rule on VSI %i error: %s\n",
+		dev_dbg(dev, "Fail %s %s LLDP rule on VSI %i error: %s\n",
 			create ? "adding" : "removing", tx ? "TX" : "RX",
 			vsi->vsi_num, ice_stat_str(status));
 }
-- 
2.26.2

