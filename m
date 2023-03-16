Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D52DA6BCF02
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 13:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjCPMHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 08:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjCPMHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 08:07:50 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A462DCA1C8;
        Thu, 16 Mar 2023 05:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678968469; x=1710504469;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MgWcw0ZELpPGPcSfV8O0eRAKpYyedQmRFInBTmwy934=;
  b=gxwRpZDqvxVfiCCxwIj996gLjYVo2AbZ4vxWB/zEmwYcoHULF6EYbxP+
   Zxv6Lv3YqgDs2wGjOL4FbAG5BQb65skMgssipJQnxUV25Li6s6ZOV+AKJ
   MAB0eZefBE94Bd5dLwqxdjw6rPkVFc5oILrGkMz6kFLEKpctgwWAahmjD
   BVoeWnJflHzJzefyCgkEmvhPrAKpJUfppBGFBDaoSa2JT1+uMj1WPaU0j
   Seh5v0VqynlyhgQUK0zcBuGNxo054FHhBlWFCnBv0SXJkDSzceFqQ2zIb
   kO6fhYBFBqanCenhatV9pQt/S0R/FjgtXuA65bOdy0lh6oNDXvip75BzL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="400536901"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="400536901"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 05:07:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="710079631"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="710079631"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga008.jf.intel.com with ESMTP; 16 Mar 2023 05:07:46 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id D2C443DD; Thu, 16 Mar 2023 14:08:30 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH net-next v1 1/1] net: phy: at803x: Replace of_gpio.h with what indeed is used
Date:   Thu, 16 Mar 2023 14:08:26 +0200
Message-Id: <20230316120826.14242-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

of_gpio.h in this driver is solely used as a proxy to other headers.
This is incorrect usage of the of_gpio.h. Replace it .h with what
indeed is used in the code.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/phy/at803x.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 22f4458274aa..656136628ffd 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -13,12 +13,11 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool_netlink.h>
-#include <linux/of_gpio.h>
 #include <linux/bitfield.h>
-#include <linux/gpio/consumer.h>
 #include <linux/regulator/of_regulator.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/consumer.h>
+#include <linux/of.h>
 #include <linux/phylink.h>
 #include <linux/sfp.h>
 #include <dt-bindings/net/qca-ar803x.h>
-- 
2.39.2

