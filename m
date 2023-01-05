Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5BE165F04B
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 16:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234385AbjAEPmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 10:42:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232700AbjAEPmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 10:42:12 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269974E415
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 07:42:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672933332; x=1704469332;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tIxYioqwMOstAQNqkA3XAWOBkxP7oLKSkPGqOp3UQBI=;
  b=gpwtq5CSyi/u14TukSECM/PDZ5F4ezZPPuhpN9MrIgJA8PJrDR/Uy5ky
   bM0N+BHapAF4glpImnWfpqrz+u8koCrIbdpP/c4FFYM/DpK9ITZc3TwWl
   TmIAABT2NjW4kTennRuljOp280IbdzwKUQ5H7ub/tgZ0jeGepqEKDzkpr
   1NxsvLH03BIVUzrgzT22f5w+QKUv5tnwJJtw0hC87oLzBekyJvBINqptK
   uOuYcwBxlRe1x+AFTRrSHTnYYERQBLV/E2d78UtDq8PtmhV/QVtc1HJ//
   4gEGMcvmKtKVxOyz36HZd9zAyH8vlmXJQwROEmkuJXn4nD+Kb7sZFg+2d
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="302602265"
X-IronPort-AV: E=Sophos;i="5.96,303,1665471600"; 
   d="scan'208";a="302602265"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2023 07:42:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="779670088"
X-IronPort-AV: E=Sophos;i="5.96,303,1665471600"; 
   d="scan'208";a="779670088"
Received: from bswcg005.iind.intel.com ([10.224.174.136])
  by orsmga004.jf.intel.com with ESMTP; 05 Jan 2023 07:42:03 -0800
From:   m.chetan.kumar@linux.intel.com
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        ilpo.jarvinen@linux.intel.com, ricardo.martinez@linux.intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        edumazet@google.com, pabeni@redhat.com, linuxwwan@intel.com,
        linuxwwan_5g@intel.com, chandrashekar.devegowda@intel.com,
        m.chetan.kumar@linux.intel.com
Subject: [PATCH v2 net-next 0/5] net: wwan: t7xx: fw flashing & coredump support
Date:   Thu,  5 Jan 2023 21:11:49 +0530
Message-Id: <20230105154149.198813-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

This patch series brings-in the support for FM350 wwan device firmware
flashing & coredump collection using devlink interface.

Below is the high level description of individual patches.
Refer to individual patch commit message for details.

PATCH1:  Enables AP CLDMA communication for firmware flashing &
coredump collection.

PATCH2: Enables the infrastructure & queue configuration required
for early ports enumeration.

PATCH3: Implements device reset and rescan logic required to enter
or exit fastboot mode.

PATCH4: Implements devlink interface & uses the fastboot protocol for
fw flashing and coredump collection.

PATCH5: t7xx devlink commands documentation.

Haijun Liu (1):
  net: wwan: t7xx: Add AP CLDMA

M Chetan Kumar (4):
  net: wwan: t7xx: Infrastructure for early port configuration
  net: wwan: t7xx: PCIe reset rescan
  net: wwan: t7xx: Enable devlink based fw flashing and coredump
    collection
  net: wwan: t7xx: Devlink documentation

 Documentation/networking/devlink/index.rst |   1 +
 Documentation/networking/devlink/t7xx.rst  | 161 +++++
 drivers/net/wwan/Kconfig                   |   1 +
 drivers/net/wwan/t7xx/Makefile             |   5 +-
 drivers/net/wwan/t7xx/t7xx_hif_cldma.c     |  64 +-
 drivers/net/wwan/t7xx/t7xx_hif_cldma.h     |  20 +-
 drivers/net/wwan/t7xx/t7xx_mhccif.h        |   1 +
 drivers/net/wwan/t7xx/t7xx_modem_ops.c     |  81 ++-
 drivers/net/wwan/t7xx/t7xx_modem_ops.h     |   2 +
 drivers/net/wwan/t7xx/t7xx_pci.c           |  72 ++-
 drivers/net/wwan/t7xx/t7xx_pci.h           |   2 +
 drivers/net/wwan/t7xx/t7xx_pci_rescan.c    |  96 +++
 drivers/net/wwan/t7xx/t7xx_pci_rescan.h    |  28 +
 drivers/net/wwan/t7xx/t7xx_port.h          |  12 +-
 drivers/net/wwan/t7xx/t7xx_port_ap_msg.c   |  78 +++
 drivers/net/wwan/t7xx/t7xx_port_ap_msg.h   |  11 +
 drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c |   8 +-
 drivers/net/wwan/t7xx/t7xx_port_devlink.c  | 665 +++++++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_port_devlink.h  |  86 +++
 drivers/net/wwan/t7xx/t7xx_port_proxy.c    | 135 ++++-
 drivers/net/wwan/t7xx/t7xx_port_proxy.h    |  16 +-
 drivers/net/wwan/t7xx/t7xx_port_wwan.c     |  25 +-
 drivers/net/wwan/t7xx/t7xx_reg.h           |  32 +-
 drivers/net/wwan/t7xx/t7xx_state_monitor.c | 134 ++++-
 drivers/net/wwan/t7xx/t7xx_state_monitor.h |   3 +
 25 files changed, 1634 insertions(+), 105 deletions(-)
 create mode 100644 Documentation/networking/devlink/t7xx.rst
 create mode 100644 drivers/net/wwan/t7xx/t7xx_pci_rescan.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_pci_rescan.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_ap_msg.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_ap_msg.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_devlink.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_devlink.h

--
2.34.1

