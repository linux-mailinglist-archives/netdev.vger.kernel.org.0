Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0480863D5AE
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 13:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233549AbiK3Mfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 07:35:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiK3Mfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 07:35:52 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67DD286D5;
        Wed, 30 Nov 2022 04:35:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669811751; x=1701347751;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Y6YImtjFUGnItblf4QVHZN5K6aqgx8h21CJrsd1H+SE=;
  b=XEm+d+JBtoD9rSObnK5zcCOs24FkXFzLd87CFkftSQWyyaD+tydv7dNf
   ypd/28Dwwye5A3QMDMc5l4SUZqEFURbdLhZyv04+lWHtkZrJTZNO9BwIt
   gEA84+sXG8fDyv1dF74B+j0gk9C9Nxj6WaTebUz0awYABjBmXIT3j+GNg
   xtmsCSjFC5YqhbQan80VWbRCiHfXmIhnj9xbNETvRPhgA1ezy/WcyBoZX
   h9kVPIrjtFEZ8EM7yOszy5LuGmJtLyKtMON07b3VwP6xpGFLQG5LtSS+l
   6h43fv+X0ZWwz9jLsZ1lfICuVqO8ZHODNabn8SIt1+lXznySoQ4sA2Sna
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="315412993"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="315412993"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 04:35:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="621868377"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="621868377"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga006.jf.intel.com with ESMTP; 30 Nov 2022 04:35:48 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id E31F010E; Wed, 30 Nov 2022 14:36:14 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH net-next v3 1/2] net: thunderbolt: Switch from __maybe_unused to pm_sleep_ptr() etc
Date:   Wed, 30 Nov 2022 14:36:12 +0200
Message-Id: <20221130123613.20829-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Letting the compiler remove these functions when the kernel is built
without CONFIG_PM_SLEEP support is simpler and less heavier for builds
than the use of __maybe_unused attributes.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
v3: sent proper patch
v2: added tag (Mika)
 drivers/net/thunderbolt.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index b20cd370b7f2..c73d419f1456 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -1319,7 +1319,7 @@ static void tbnet_shutdown(struct tb_service *svc)
 	tbnet_tear_down(tb_service_get_drvdata(svc), true);
 }
 
-static int __maybe_unused tbnet_suspend(struct device *dev)
+static int tbnet_suspend(struct device *dev)
 {
 	struct tb_service *svc = tb_to_service(dev);
 	struct tbnet *net = tb_service_get_drvdata(svc);
@@ -1334,7 +1334,7 @@ static int __maybe_unused tbnet_suspend(struct device *dev)
 	return 0;
 }
 
-static int __maybe_unused tbnet_resume(struct device *dev)
+static int tbnet_resume(struct device *dev)
 {
 	struct tb_service *svc = tb_to_service(dev);
 	struct tbnet *net = tb_service_get_drvdata(svc);
@@ -1350,9 +1350,7 @@ static int __maybe_unused tbnet_resume(struct device *dev)
 	return 0;
 }
 
-static const struct dev_pm_ops tbnet_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(tbnet_suspend, tbnet_resume)
-};
+static DEFINE_SIMPLE_DEV_PM_OPS(tbnet_pm_ops, tbnet_suspend, tbnet_resume);
 
 static const struct tb_service_id tbnet_ids[] = {
 	{ TB_SERVICE("network", 1) },
@@ -1364,7 +1362,7 @@ static struct tb_service_driver tbnet_driver = {
 	.driver = {
 		.owner = THIS_MODULE,
 		.name = "thunderbolt-net",
-		.pm = &tbnet_pm_ops,
+		.pm = pm_sleep_ptr(&tbnet_pm_ops),
 	},
 	.probe = tbnet_probe,
 	.remove = tbnet_remove,
-- 
2.35.1

