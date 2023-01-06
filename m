Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC59660437
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 17:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235325AbjAFQ0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 11:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231374AbjAFQ0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 11:26:35 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5016E1A838
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 08:26:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673022394; x=1704558394;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ctzDQnYxxyCDps2wP23DPf/rRuEaD1btA2BvbQjol7M=;
  b=bGWjUL+/uGPcbobLiTu05rWYxbQYjYxgEdWqMBSZFXfCDz3fS7j3ZRir
   VwPiD4xvOHLY0tvLai+M+bHP/VuWfk2OopzmRZRgJNfY8y13/Z3BD6jHc
   qHQuaQtq1WIggFY4p7foN51bmHLJZ/qaECr3WWa60/I2bIplBZ7t0R1Ni
   0W2UkTUcfezGWB06QUYMn9AY+nBPhsrUTNutXW4wQ61SVWp9qcv3VYT2m
   89z8QVYZRfqJXkl6hIVoFaZmr7qeWk2r2xAPbYzuL3R7JHI5jrOzanWXJ
   sdbiBMiI+pU8RSU9sHGua3ZHk9Izo5qIyVPPJRZosCZRbHtp0dy5V1gqP
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="321210293"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="321210293"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 08:26:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="798319063"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="798319063"
Received: from bswcg005.iind.intel.com ([10.224.174.136])
  by fmsmga001.fm.intel.com with ESMTP; 06 Jan 2023 08:26:28 -0800
From:   m.chetan.kumar@linux.intel.com
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        ilpo.jarvinen@linux.intel.com, ricardo.martinez@linux.intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        edumazet@google.com, pabeni@redhat.com, linuxwwan@intel.com,
        linuxwwan_5g@intel.com, chandrashekar.devegowda@intel.com,
        m.chetan.kumar@linux.intel.com, matthias.bgg@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v3 net-next 0/5] net: wwan: t7xx: fw flashing & coredump support
Date:   Fri,  6 Jan 2023 21:56:16 +0530
Message-Id: <cover.1673016069.git.m.chetan.kumar@linux.intel.com>
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

