Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726ED38FA51
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 07:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbhEYFzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 01:55:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:41319 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231129AbhEYFzE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 01:55:04 -0400
IronPort-SDR: 3OF4ZyI511mDX3CY/vFGoJtBf4+Whie1eQTO2i+BJui1wuCt5oObtcmxQ1zgr62x6gvkaiP5/Z
 n0d1BX8/eHBw==
X-IronPort-AV: E=McAfee;i="6200,9189,9994"; a="199054945"
X-IronPort-AV: E=Sophos;i="5.82,327,1613462400"; 
   d="scan'208";a="199054945"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2021 22:53:35 -0700
IronPort-SDR: FQFDVxQH/mNCmeuQsNTjlXQgMuMhyhQOHUKStNhrOZ3WSAWkgYVk3/7uSALCGTk4q6ECA90YAt
 TJO24//DTcnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,327,1613462400"; 
   d="scan'208";a="471110393"
Received: from linux.intel.com ([10.54.29.200])
  by FMSMGA003.fm.intel.com with ESMTP; 24 May 2021 22:53:35 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.59])
        by linux.intel.com (Postfix) with ESMTP id 239C3580911;
        Mon, 24 May 2021 22:53:33 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC net-next 1/2] net: phy: allow mdio bus to probe for c45 devices before c22
Date:   Tue, 25 May 2021 13:58:39 +0800
Message-Id: <20210525055839.22496-1-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some MAC controllers that is able to pair with  external PHY devices
such as the Synopsys MAC Controller (STMMAC) support both Clause-22 and
Clause-45 access.

When paired with PHY devices that only accessible via Clause-45, such as
the Marvell 88E2110, any attempts to access the PHY devices via
Clause-22 will get a PHY ID of all zeroes.

To fix this, we introduce MDIOBUS_C45_C22 which the MAC controller will
try with Clause-45 access before going to Clause-22.

Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
 include/linux/phy.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 60d2b26026a2..9b0e2c76e19b 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -368,6 +368,7 @@ struct mii_bus {
 		MDIOBUS_C22,
 		MDIOBUS_C45,
 		MDIOBUS_C22_C45,
+		MDIOBUS_C45_C22,
 	} probe_capabilities;
 
 	/** @shared_lock: protect access to the shared element */
-- 
2.25.1

