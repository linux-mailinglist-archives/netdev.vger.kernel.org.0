Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADB3676683
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 14:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjAUNdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 08:33:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjAUNdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 08:33:21 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BDCF1E1C1
        for <netdev@vger.kernel.org>; Sat, 21 Jan 2023 05:33:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674308000; x=1705844000;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=izEfW719uYISOiSB5OXuUvWvk5+OjbHKx4iqgH+UEeI=;
  b=TuC1/BK3ZabjnFNXIMlPKvfvYCDUUECZgo2nDeY5Th8uJMyLYPq/Tfrx
   iE0bZyDRXyQP1Ha4Ph7IWNi2SKfwyryDVyT6sqKnNN/7S3ydxKu3l5YB8
   jtFk/J+BZP+7kMG/1PHmaTqq9ixLbb3fTGnTT64ugX15s+cP1UeC7H7L1
   Sa7aiVzRen5+CEfWTunulrmHchU0VQWnPTbKkB6dr31+mHE3McHXR358H
   Kj1KU7JtKPbVHnDJbuOiVbqS7QKwTAryGYHrmHwmisnjZEmrMuWELKi53
   Ayu5Jnu1DhG6V/7stI4xqoVr068huEHzqiVY4qIAdZRfH1sCSXnoCSdGN
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10596"; a="327872875"
X-IronPort-AV: E=Sophos;i="5.97,235,1669104000"; 
   d="scan'208";a="327872875"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2023 05:33:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10596"; a="989700249"
X-IronPort-AV: E=Sophos;i="5.97,235,1669104000"; 
   d="scan'208";a="989700249"
Received: from bswcg005.iind.intel.com ([10.224.174.136])
  by fmsmga005.fm.intel.com with ESMTP; 21 Jan 2023 05:33:15 -0800
From:   m.chetan.kumar@linux.intel.com
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        ilpo.jarvinen@linux.intel.com, ricardo.martinez@linux.intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        edumazet@google.com, pabeni@redhat.com,
        chandrashekar.devegowda@intel.com, m.chetan.kumar@linux.intel.com,
        linuxwwan@intel.com, linuxwwan_5g@intel.com
Subject: [PATCH v5 net-next 0/5] net: wwan: t7xx: fw flashing & coredump support
Date:   Sat, 21 Jan 2023 19:02:40 +0530
Message-Id: <cover.1674307425.git.m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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

Version History:
================
v5: Address reivew comments given by Jarvinen, Ilpo Johannes.
v4: Address review comments given by Jesse Brandeburg & Bagas Sanjaya.
v3: Repost the series by setting format.thread git-config option to
    shallow as suggested by Brandeburg, Jesse.
v2: Address review comments given by Jarvinen, Ilpo Johannes and
    Sergey Ryazanov. Refer to Individual patches on v2 changes.
v1: Initial Version.

Haijun Liu (1):
  net: wwan: t7xx: Add AP CLDMA

M Chetan Kumar (4):
  net: wwan: t7xx: Infrastructure for early port configuration
  net: wwan: t7xx: PCIe reset rescan
  net: wwan: t7xx: Enable devlink based fw flashing and coredump
    collection
  net: wwan: t7xx: Devlink documentation

 Documentation/networking/devlink/index.rst |   1 +
 Documentation/networking/devlink/t7xx.rst  | 224 +++++++
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
 drivers/net/wwan/t7xx/t7xx_port_ap_msg.c   |  79 +++
 drivers/net/wwan/t7xx/t7xx_port_ap_msg.h   |  11 +
 drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c |   8 +-
 drivers/net/wwan/t7xx/t7xx_port_devlink.c  | 701 +++++++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_port_devlink.h  |  86 +++
 drivers/net/wwan/t7xx/t7xx_port_proxy.c    | 132 +++-
 drivers/net/wwan/t7xx/t7xx_port_proxy.h    |  14 +
 drivers/net/wwan/t7xx/t7xx_port_wwan.c     |  25 +-
 drivers/net/wwan/t7xx/t7xx_reg.h           |  30 +-
 drivers/net/wwan/t7xx/t7xx_state_monitor.c | 132 +++-
 drivers/net/wwan/t7xx/t7xx_state_monitor.h |   3 +
 25 files changed, 1729 insertions(+), 101 deletions(-)
 create mode 100644 Documentation/networking/devlink/t7xx.rst
 create mode 100644 drivers/net/wwan/t7xx/t7xx_pci_rescan.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_pci_rescan.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_ap_msg.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_ap_msg.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_devlink.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_devlink.h

--
2.34.1

