Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCFB3ED390
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 14:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235813AbhHPMBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 08:01:32 -0400
Received: from mga14.intel.com ([192.55.52.115]:38495 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234555AbhHPMAz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 08:00:55 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10077"; a="215572752"
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="215572752"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 05:00:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="423522467"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 16 Aug 2021 05:00:03 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 1C7DF314; Mon, 16 Aug 2021 15:00:03 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        David Thompson <davthompson@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-acpi@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Asmaa Mnebhi <asmaa@nvidia.com>,
        Liming Sun <limings@nvidia.com>
Subject: [PATCH v1 4/6] gpio: mlxbf2: Use DEFINE_RES_MEM_NAMED() helper macro
Date:   Mon, 16 Aug 2021 14:59:51 +0300
Message-Id: <20210816115953.72533-5-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210816115953.72533-1-andriy.shevchenko@linux.intel.com>
References: <20210816115953.72533-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use DEFINE_RES_MEM_NAMED() to save a couple of lines of code, which makes
the code a bit shorter and easier to read.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/gpio/gpio-mlxbf2.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/gpio-mlxbf2.c b/drivers/gpio/gpio-mlxbf2.c
index c193d1a9a5dd..3ed95e958c17 100644
--- a/drivers/gpio/gpio-mlxbf2.c
+++ b/drivers/gpio/gpio-mlxbf2.c
@@ -69,11 +69,8 @@ struct mlxbf2_gpio_param {
 	struct mutex *lock;
 };
 
-static struct resource yu_arm_gpio_lock_res = {
-	.start = YU_ARM_GPIO_LOCK_ADDR,
-	.end   = YU_ARM_GPIO_LOCK_ADDR + YU_ARM_GPIO_LOCK_SIZE - 1,
-	.name  = "YU_ARM_GPIO_LOCK",
-};
+static struct resource yu_arm_gpio_lock_res =
+	DEFINE_RES_MEM_NAMED(YU_ARM_GPIO_LOCK_ADDR, YU_ARM_GPIO_LOCK_SIZE, "YU_ARM_GPIO_LOCK");
 
 static DEFINE_MUTEX(yu_arm_gpio_lock_mutex);
 
-- 
2.30.2

