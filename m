Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58EB55953D3
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 09:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbiHPHdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 03:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232018AbiHPHc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 03:32:58 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E517FFB7
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 21:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660623101; x=1692159101;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5Z2rm7waZmcaZDuQ+HpRsmC8j8DtFG5fGMS8z7+0kxw=;
  b=YAl4lqrw+68tOpya9UWCH+pyP4iUPmU+Mr+E3JdKNzcwg5lWnO9umEcO
   ChIWMIVp09mUF0IIkr8SYmItXCCspI8iLyJfbCOrb1vk0SMhOdCH8gcG3
   AkTE/EceCbp1UTbdui6bybfB14X1f+N0cI2t7SRHCZEeAlWODK9E5E9O0
   SUJM+Jyl+BvUI54yFK88d9JiB9jawUZld7jifS0ffg4ygQGyrbUlV/AYv
   SqdgcucFX39hJnb/wuzqTMrjfBBvuBNmImg809lLQM1sUtxkdgpGHjGbY
   o31Sfq3Y3XMCr3nprndO2gS004c7GvxYHHU2+Fl9eBr390biMigkOFjVC
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="353863262"
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="353863262"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 21:11:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="749163323"
Received: from bswcg005.iind.intel.com ([10.224.174.23])
  by fmsmga001.fm.intel.com with ESMTP; 15 Aug 2022 21:11:33 -0700
From:   m.chetan.kumar@intel.com
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@linux.intel.com,
        linuxwwan@intel.com
Subject: [PATCH net-next 0/5] net: wwan: t7xx: fw flashing & coredump support
Date:   Tue, 16 Aug 2022 09:53:01 +0530
Message-Id: <20220816042301.2416911-1-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

Haijun Liu (3):
  net: wwan: t7xx: Add AP CLDMA
  net: wwan: t7xx: Infrastructure for early port configuration
  net: wwan: t7xx: PCIe reset rescan

M Chetan Kumar (2):
  net: wwan: t7xx: Enable devlink based fw flashing and coredump
    collection
  net: wwan: t7xx: Devlink documentation

 Documentation/networking/devlink/index.rst |   1 +
 Documentation/networking/devlink/t7xx.rst  | 145 +++++
 drivers/net/wwan/Kconfig                   |   1 +
 drivers/net/wwan/t7xx/Makefile             |   5 +-
 drivers/net/wwan/t7xx/t7xx_hif_cldma.c     |  55 +-
 drivers/net/wwan/t7xx/t7xx_hif_cldma.h     |  26 +-
 drivers/net/wwan/t7xx/t7xx_mhccif.h        |   1 +
 drivers/net/wwan/t7xx/t7xx_modem_ops.c     |  92 ++-
 drivers/net/wwan/t7xx/t7xx_modem_ops.h     |   3 +
 drivers/net/wwan/t7xx/t7xx_pci.c           |  65 +-
 drivers/net/wwan/t7xx/t7xx_pci.h           |   3 +
 drivers/net/wwan/t7xx/t7xx_pci_rescan.c    | 117 ++++
 drivers/net/wwan/t7xx/t7xx_pci_rescan.h    |  29 +
 drivers/net/wwan/t7xx/t7xx_port.h          |  12 +-
 drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c |   8 +-
 drivers/net/wwan/t7xx/t7xx_port_devlink.c  | 705 +++++++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_port_devlink.h  |  85 +++
 drivers/net/wwan/t7xx/t7xx_port_proxy.c    | 132 +++-
 drivers/net/wwan/t7xx/t7xx_port_proxy.h    |  12 +-
 drivers/net/wwan/t7xx/t7xx_port_wwan.c     |   9 +-
 drivers/net/wwan/t7xx/t7xx_reg.h           |  31 +-
 drivers/net/wwan/t7xx/t7xx_state_monitor.c | 158 ++++-
 drivers/net/wwan/t7xx/t7xx_state_monitor.h |   4 +
 drivers/net/wwan/t7xx/t7xx_uevent.c        |  41 ++
 drivers/net/wwan/t7xx/t7xx_uevent.h        |  39 ++
 25 files changed, 1706 insertions(+), 73 deletions(-)
 create mode 100644 Documentation/networking/devlink/t7xx.rst
 create mode 100644 drivers/net/wwan/t7xx/t7xx_pci_rescan.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_pci_rescan.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_devlink.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_devlink.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_uevent.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_uevent.h

--
2.34.1

