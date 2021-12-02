Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8792466B4C
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 21:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349056AbhLBVDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 16:03:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:39397 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234616AbhLBVDL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 16:03:11 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10186"; a="236645008"
X-IronPort-AV: E=Sophos;i="5.87,282,1631602800"; 
   d="scan'208";a="236645008"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2021 12:58:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,282,1631602800"; 
   d="scan'208";a="677822787"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga005.jf.intel.com with ESMTP; 02 Dec 2021 12:58:52 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 91AB1109; Thu,  2 Dec 2021 22:58:57 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/1] can: mcp251x: Get rid of duplicate of_node assignment
Date:   Thu,  2 Dec 2021 22:58:55 +0200
Message-Id: <20211202205855.76946-1-andriy.shevchenko@linux.intel.com>
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
 drivers/net/can/spi/mcp251x.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index 0579ab74f728..0cec808e8727 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -600,9 +600,6 @@ static int mcp251x_gpio_setup(struct mcp251x_priv *priv)
 	gpio->ngpio = ARRAY_SIZE(mcp251x_gpio_names);
 	gpio->names = mcp251x_gpio_names;
 	gpio->can_sleep = true;
-#ifdef CONFIG_OF_GPIO
-	gpio->of_node = priv->spi->dev.of_node;
-#endif
 
 	return devm_gpiochip_add_data(&priv->spi->dev, gpio, priv);
 }
-- 
2.33.0

