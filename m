Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDAFA68BE
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 14:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729138AbfICMnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 08:43:03 -0400
Received: from mga18.intel.com ([134.134.136.126]:25216 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729079AbfICMnD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 08:43:03 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 05:43:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,463,1559545200"; 
   d="scan'208";a="383063355"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga006.fm.intel.com with ESMTP; 03 Sep 2019 05:43:00 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id A91D4EC; Tue,  3 Sep 2019 15:42:59 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 0/4] can: mcp251x: Make use of device properties
Date:   Tue,  3 Sep 2019 15:42:55 +0300
Message-Id: <20190903124259.60920-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.23.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of this series is to simplify driver by switching to use device
properties. In particular it allows to drop legacy platform data.

Patch 1 switches driver to use devm_clk_get_optional() API.

Patch 2 unifies getting the driver data independently of the table which
provides it.

Patch 3 drops extra check for regulator presence by switch to use an already
present wrapper.

And patch 4 gets rid of legacy platform data.

Changelog v2:
- add patch 4 to get rid of legacy platform data

Andy Shevchenko (4):
  can: mcp251x: Use devm_clk_get_optional() to get the input clock
  can: mcp251x: Make use of device property API
  can: mcp251x: Call wrapper instead of regulator_disable()
  can: mcp251x: Get rid of legacy platform data

 arch/arm/mach-pxa/icontrol.c         |  9 ++--
 arch/arm/mach-pxa/zeus.c             |  9 ++--
 drivers/net/can/spi/mcp251x.c        | 65 +++++++++++-----------------
 include/linux/can/platform/mcp251x.h | 22 ----------
 4 files changed, 36 insertions(+), 69 deletions(-)
 delete mode 100644 include/linux/can/platform/mcp251x.h

-- 
2.23.0.rc1

