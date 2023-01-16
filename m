Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8497366B716
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 07:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbjAPGEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 01:04:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231621AbjAPGEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 01:04:47 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2BF93CF
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 22:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673849087; x=1705385087;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0S4DApMIyfNsJ4HNT+x+lsq07CG1g0v+S9lVDRMoRik=;
  b=KFOra1APM2P/FcyVKs5yma9mID9fcnphY9WeAKYZ4lPVqGw0mNwDes0N
   kNleP9j8XgRkDdCqkFkWXWDnQiYFDC/ZRYRjaMEFi63oq/gyJtPrIOq+4
   l62dkCjOHWu+mKZARgtNZjKTUUbdmpKn7pPEzgsc5/2OtWt+4+VisEw7P
   b0j1qHXTjqZgrUx4vxJ2fhIHJ5xv5qieDUsTwCOoTQWB/XBHwOctTMTfM
   /8T/54BEADm5dLdGnxnpbSQkBKVcRoTKYrdfzeitARxFKz0/gEbqIQQ3a
   E2qJGLyH6t+/AB1B/xdsStt4GuR5BC7oPWt+xLNzu58RQQhO6KeBUEf+K
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10591"; a="324451074"
X-IronPort-AV: E=Sophos;i="5.97,220,1669104000"; 
   d="scan'208";a="324451074"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2023 22:04:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10591"; a="722185646"
X-IronPort-AV: E=Sophos;i="5.97,220,1669104000"; 
   d="scan'208";a="722185646"
Received: from bswcg005.iind.intel.com ([10.224.174.136])
  by fmsmga008.fm.intel.com with ESMTP; 15 Jan 2023 22:04:41 -0800
From:   m.chetan.kumar@linux.intel.com
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        ilpo.jarvinen@linux.intel.com, ricardo.martinez@linux.intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        edumazet@google.com, pabeni@redhat.com,
        chandrashekar.devegowda@intel.com, m.chetan.kumar@linux.intel.com,
        linuxwwan@intel.com, linuxwwan_5g@intel.com
Subject: [PATCH v4 net-next 0/5] net: wwan: t7xx: fw flashing & coredump support
Date:   Mon, 16 Jan 2023 11:34:11 +0530
Message-Id: <cover.1673842618.git.m.chetan.kumar@linux.intel.com>
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

Version History:
================
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
 drivers/net/wwan/t7xx/t7xx_port_devlink.c  | 669 +++++++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_port_devlink.h  |  86 +++
 drivers/net/wwan/t7xx/t7xx_port_proxy.c    | 135 ++++-
 drivers/net/wwan/t7xx/t7xx_port_proxy.h    |  16 +-
 drivers/net/wwan/t7xx/t7xx_port_wwan.c     |  25 +-
 drivers/net/wwan/t7xx/t7xx_reg.h           |  30 +-
 drivers/net/wwan/t7xx/t7xx_state_monitor.c | 133 +++-
 drivers/net/wwan/t7xx/t7xx_state_monitor.h |   3 +
 25 files changed, 1700 insertions(+), 104 deletions(-)
 create mode 100644 Documentation/networking/devlink/t7xx.rst
 create mode 100644 drivers/net/wwan/t7xx/t7xx_pci_rescan.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_pci_rescan.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_ap_msg.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_ap_msg.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_devlink.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_devlink.h

--
2.34.1

