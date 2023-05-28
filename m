Return-Path: <netdev+bounces-5951-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E08F713A0F
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 16:25:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E60AD1C20984
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 14:25:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 773C93C3D;
	Sun, 28 May 2023 14:25:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B0D211A
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 14:25:33 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E22F99;
	Sun, 28 May 2023 07:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685283932; x=1716819932;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6Zxijp7bVo155CL7hIfCOYPS8fsrRnxpH07BilcE8G0=;
  b=FdxBbtGuJ3HrNAEqUCQKQEQaQCpFWInFgS7LqnAhtJl+z2xInTupEtMj
   qzi3LcqjxGiAim33c/Ij+QEYSbLROY34W5h87BvDA50Jsc4chhR1FG5RK
   /LEHb7D/bGtP+LX9ngS7rJZTZvLW7hsI7CA6ItavkISP6Fqv90lnr0U5I
   AW1iwusYzz0J8t/od4nUoqhZJiCCwuy6y9E+G3vuhJzUI708gEQeMuPtA
   ZkATBXfAe+0aJlCxYAek/NHXKiA80OuteDcAkUVZRDS/+WrxzUAgPEp9Y
   bYy6WSihFxGwzzuhyv+ffXaed77Sqz9zsIhgVzIVq4yjyva6nGJqcbJ/H
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="382773704"
X-IronPort-AV: E=Sophos;i="6.00,198,1681196400"; 
   d="scan'208";a="382773704"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 07:25:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="708952251"
X-IronPort-AV: E=Sophos;i="6.00,198,1681196400"; 
   d="scan'208";a="708952251"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga007.fm.intel.com with ESMTP; 28 May 2023 07:25:29 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
	id E3A8724F; Sun, 28 May 2023 17:25:33 +0300 (EEST)
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Jerry Ray <jerry.ray@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH net-next v1 1/1] dsa: lan9303: Remove stray gpiod_unexport() call
Date: Sun, 28 May 2023 17:25:31 +0300
Message-Id: <20230528142531.38602-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.40.0.1.gaa8946217a0b
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

There is no gpiod_export() and gpiod_unexport() looks pretty much stray.
The gpiod_export() and gpiod_unexport() shouldn't be used in the code,
GPIO sysfs is deprecated. That said, simply drop the stray call.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/dsa/lan9303-core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index cbe831875347..b560e73c14ca 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1462,7 +1462,6 @@ int lan9303_remove(struct lan9303 *chip)
 
 	/* assert reset to the whole device to prevent it from doing anything */
 	gpiod_set_value_cansleep(chip->reset_gpio, 1);
-	gpiod_unexport(chip->reset_gpio);
 
 	return 0;
 }
-- 
2.40.0.1.gaa8946217a0b


