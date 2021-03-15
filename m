Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 786E133AA6C
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 05:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhCOE3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 00:29:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:21290 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229840AbhCOE3q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 00:29:46 -0400
IronPort-SDR: OJx/OLoAg4dcg7PvdCzESSb0Yl0+wa9WrWyF9+3hZsxIKQa5fAhReRoIZgQhrRdejlhRfIjx4V
 aP4jckXBmNTQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9923"; a="185675502"
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="185675502"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2021 21:29:46 -0700
IronPort-SDR: ogTylwdyRj4znRIbzItclBNSgcMFkJhL37rbGrm0BDZ2aMTXp8+L2drxZvxcATuXr83xeLDZUv
 Ol9wxBosyrkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="604713764"
Received: from glass.png.intel.com ([10.158.65.59])
  by fmsmga005.fm.intel.com with ESMTP; 14 Mar 2021 21:29:43 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net 1/1] net: phylink: Fix phylink_err() function name error in phylink_major_config
Date:   Mon, 15 Mar 2021 12:33:42 +0800
Message-Id: <20210315043342.26269-1-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

if pl->mac_ops->mac_finish() failed, phylink_err should use
"mac_finish" instead of "mac_prepare".

Fixes: b7ad14c2fe2d4 ("net: phylink: re-implement interface configuration with PCS")
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/phy/phylink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 053c92e02cd8..dc2800beacc3 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -476,7 +476,7 @@ static void phylink_major_config(struct phylink *pl, bool restart,
 		err = pl->mac_ops->mac_finish(pl->config, pl->cur_link_an_mode,
 					      state->interface);
 		if (err < 0)
-			phylink_err(pl, "mac_prepare failed: %pe\n",
+			phylink_err(pl, "mac_finish failed: %pe\n",
 				    ERR_PTR(err));
 	}
 }
-- 
2.25.1

