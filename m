Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9555D466B54
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 22:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbhLBVEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 16:04:12 -0500
Received: from mga12.intel.com ([192.55.52.136]:23858 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229683AbhLBVEL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 16:04:11 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10186"; a="216854520"
X-IronPort-AV: E=Sophos;i="5.87,282,1631602800"; 
   d="scan'208";a="216854520"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2021 13:00:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,282,1631602800"; 
   d="scan'208";a="597312254"
Received: from black.fi.intel.com ([10.237.72.28])
  by FMSMGA003.fm.intel.com with ESMTP; 02 Dec 2021 13:00:25 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 22E4D109; Thu,  2 Dec 2021 23:00:31 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/1] net: dsa: vsc73xxx: Get rid of duplicate of_node assignment
Date:   Thu,  2 Dec 2021 23:00:29 +0200
Message-Id: <20211202210029.77466-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GPIO library does copy the of_node from the parent device of
the GPIO chip, there is no need to repeat this in the individual
drivers. Remove assignment here.

For the details one may look into the of_gpio_dev_init() implementation.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/dsa/vitesse-vsc73xx-core.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/dsa/vitesse-vsc73xx-core.c b/drivers/net/dsa/vitesse-vsc73xx-core.c
index 4c18f619ec02..ae55167ce0a6 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-core.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-core.c
@@ -1122,9 +1122,6 @@ static int vsc73xx_gpio_probe(struct vsc73xx *vsc)
 	vsc->gc.ngpio = 4;
 	vsc->gc.owner = THIS_MODULE;
 	vsc->gc.parent = vsc->dev;
-#if IS_ENABLED(CONFIG_OF_GPIO)
-	vsc->gc.of_node = vsc->dev->of_node;
-#endif
 	vsc->gc.base = -1;
 	vsc->gc.get = vsc73xx_gpio_get;
 	vsc->gc.set = vsc73xx_gpio_set;
-- 
2.33.0

