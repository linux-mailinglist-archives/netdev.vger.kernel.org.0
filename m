Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3AD395C0D
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 15:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbhEaN3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 09:29:01 -0400
Received: from mga03.intel.com ([134.134.136.65]:1438 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231834AbhEaN1A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 09:27:00 -0400
IronPort-SDR: mUwqcWKGLtkTAe579X+1Jsa3qxjfMDyDQ3Y5q20p8pfv0s1tleg74X3omjSLi+3M3TgJeNG+82
 mbdWuHzgv3qw==
X-IronPort-AV: E=McAfee;i="6200,9189,10000"; a="203394960"
X-IronPort-AV: E=Sophos;i="5.83,237,1616482800"; 
   d="scan'208";a="203394960"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2021 06:22:08 -0700
IronPort-SDR: liI2DfwDLQ9hNU9BmbLM3P4YuqlgD6tMOBlYwldjLUTnT3EezvNneTJi7vElVnV0XXvqb4DoRj
 g4a2gSlYfFyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,237,1616482800"; 
   d="scan'208";a="478911609"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga001.jf.intel.com with ESMTP; 31 May 2021 06:22:06 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 3994012A; Mon, 31 May 2021 16:22:29 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Alan Ott <alan@signal11.us>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v1 1/1] mrf29j40: Drop unneeded of_match_ptr()
Date:   Mon, 31 May 2021 16:22:26 +0300
Message-Id: <20210531132226.47081-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Driver can be used in different environments and moreover, when compiled
with !OF, the compiler may issue a warning due to unused mrf24j40_of_match
variable. Hence drop unneeded of_match_ptr() call.

While at it, update headers block to reflect above changes.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/ieee802154/mrf24j40.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ieee802154/mrf24j40.c b/drivers/net/ieee802154/mrf24j40.c
index b9be530b285f..ff83e00b77af 100644
--- a/drivers/net/ieee802154/mrf24j40.c
+++ b/drivers/net/ieee802154/mrf24j40.c
@@ -8,8 +8,8 @@
 
 #include <linux/spi/spi.h>
 #include <linux/interrupt.h>
+#include <linux/mod_devicetable.h>
 #include <linux/module.h>
-#include <linux/of.h>
 #include <linux/regmap.h>
 #include <linux/ieee802154.h>
 #include <linux/irq.h>
@@ -1388,7 +1388,7 @@ MODULE_DEVICE_TABLE(spi, mrf24j40_ids);
 
 static struct spi_driver mrf24j40_driver = {
 	.driver = {
-		.of_match_table = of_match_ptr(mrf24j40_of_match),
+		.of_match_table = mrf24j40_of_match,
 		.name = "mrf24j40",
 	},
 	.id_table = mrf24j40_ids,
-- 
2.30.2

