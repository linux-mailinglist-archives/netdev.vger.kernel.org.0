Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B626940CF61
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 00:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbhIOWg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 18:36:59 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:34438 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232739AbhIOWg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 18:36:58 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Sep 2021 18:36:57 EDT
Received: from Internal Mail-Server by MTLPINE1 (envelope-from asmaa@mellanox.com)
        with SMTP; 16 Sep 2021 01:28:53 +0300
Received: from farm-0002.mtbu.labs.mlnx (farm-0002.mtbu.labs.mlnx [10.15.2.32])
        by mtbu-labmailer.labs.mlnx (8.14.4/8.14.4) with ESMTP id 18FMSrP0018006;
        Wed, 15 Sep 2021 18:28:53 -0400
Received: (from asmaa@localhost)
        by farm-0002.mtbu.labs.mlnx (8.14.7/8.13.8/Submit) id 18FMSomd010292;
        Wed, 15 Sep 2021 18:28:50 -0400
From:   Asmaa Mnebhi <asmaa@nvidia.com>
To:     andy.shevchenko@gmail.com, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Cc:     Asmaa Mnebhi <asmaa@nvidia.com>, andrew@lunn.ch, kuba@kernel.org,
        linus.walleij@linaro.org, bgolaszewski@baylibre.com,
        davem@davemloft.net, rjw@rjwysocki.net, davthompson@nvidia.com
Subject: [PATCH v1 0/2] gpio: mlxbf2: Introduce proper interrupt handling
Date:   Wed, 15 Sep 2021 18:28:45 -0400
Message-Id: <20210915222847.10239-1-asmaa@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a follow up on a discussion regarding
proper handling of GPIO interrupts within the
gpio-mlxbf2.c driver.

Link to discussion:
https://lore.kernel.org/netdev/20210816115953.72533-7-andriy.shevchenko@linux.intel.com/T/

Patch 1 adds support to a GPIO IRQ handler in gpio-mlxbf2.c.
Patch 2 is a follow up removal of custom GPIO IRQ handling
from the mlxbf_gige driver and replacing it with a simple
IRQ request. The ACPI table for the mlxbf_gige driver is
responsible for instantiating the PHY GPIO interrupt via
GpioInt.

Andy Shevchenko, could you please review this patch series.
David Miller, could you please ack the changes in the
mlxbf_gige driver.

Asmaa Mnebhi (2):
  gpio: mlxbf2: Introduce IRQ support
  net: mellanox: mlxbf_gige: Replace non-standard interrupt handling

 drivers/gpio/gpio-mlxbf2.c                    | 181 ++++++++++++++-
 .../net/ethernet/mellanox/mlxbf_gige/Makefile |   1 -
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige.h |  12 -
 .../mellanox/mlxbf_gige/mlxbf_gige_gpio.c     | 212 ------------------
 .../mellanox/mlxbf_gige/mlxbf_gige_main.c     |  22 +-
 5 files changed, 188 insertions(+), 240 deletions(-)
 delete mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_gpio.c

-- 
2.30.1

