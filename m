Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D57E3ED38A
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 14:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234824AbhHPMBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 08:01:12 -0400
Received: from mga07.intel.com ([134.134.136.100]:49131 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234791AbhHPMAz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 08:00:55 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10077"; a="279586998"
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="279586998"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 05:00:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="572448305"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga004.jf.intel.com with ESMTP; 16 Aug 2021 05:00:03 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id DD688FF; Mon, 16 Aug 2021 15:00:02 +0300 (EEST)
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
Subject: [PATCH v1 0/6] gpio: mlxbf2: Introduce proper interrupt handling
Date:   Mon, 16 Aug 2021 14:59:47 +0300
Message-Id: <20210816115953.72533-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is just a WIP / TODO series based on the discussion [1].
I hope nVidia will finish it and fix the initial problem sooner than later.

Bart, Linus, First 4 patches may be directly applied to the tree (they are
at least compile-tested, but I believe they won't change any functionality.

Patch 5 is some stubs that should have been done in the driver.
Patch 6 is follow up removal of custom GPIO IRQ handling from
Mellanox GBE driver. Both of them are quite far from finishing,
but it's a start for nVidia to develop and test proper solution.

In any case, I will probably sent end this week the ACPI IRQ abuse
part from the GBE driver (I won't touch OF path).

ARs for nVidia:
0) review this series;
1) properly develop GPIO driver;
2) replace custom code with correct one;
3) send the work for review to GPIO and ACPI maintainers (basically list
   of this series).

On my side I will help you if you have any questions regarding to GPIO
and ACPI.

Andy Shevchenko (6):
  gpio: mlxbf2: Convert to device PM ops
  gpio: mlxbf2: Drop wrong use of ACPI_PTR()
  gpio: mlxbf2: Use devm_platform_ioremap_resource()
  gpio: mlxbf2: Use DEFINE_RES_MEM_NAMED() helper macro
  TODO: gpio: mlxbf2: Introduce IRQ support
  TODO: net: mellanox: mlxbf_gige: Replace non-standard interrupt
    handling

 drivers/gpio/gpio-mlxbf2.c                    | 151 ++++++++++---
 .../mellanox/mlxbf_gige/mlxbf_gige_gpio.c     | 212 ------------------
 2 files changed, 120 insertions(+), 243 deletions(-)
 delete mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_gpio.c

-- 
2.30.2

