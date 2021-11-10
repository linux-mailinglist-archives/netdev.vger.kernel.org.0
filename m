Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E818B44C4E0
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 17:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbhKJQQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 11:16:15 -0500
Received: from mga04.intel.com ([192.55.52.120]:2888 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229512AbhKJQQP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 11:16:15 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10164"; a="231425223"
X-IronPort-AV: E=Sophos;i="5.87,224,1631602800"; 
   d="scan'208";a="231425223"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 08:13:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,224,1631602800"; 
   d="scan'208";a="452349506"
Received: from ccgwwan-desktop15.iind.intel.com ([10.224.174.19])
  by orsmga003.jf.intel.com with ESMTP; 10 Nov 2021 08:13:17 -0800
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        linuxwwan@intel.com, kernel test robot <lkp@intel.com>
Subject: [PATCH] net: wwan: iosm: fix compilation warning
Date:   Wed, 10 Nov 2021 21:50:36 +0530
Message-Id: <20211110162036.256158-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

curr_phase is unused. Removed the dead code.

Fixes: 8d9be0634181 ("net: wwan: iosm: transport layer support for fw flashing/cd")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
index b885a6570235..825e8e5ffb2a 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
@@ -394,12 +394,10 @@ void ipc_imem_sys_devlink_close(struct iosm_devlink *ipc_devlink)
 	int boot_check_timeout = BOOT_CHECK_DEFAULT_TIMEOUT;
 	enum ipc_mem_exec_stage exec_stage;
 	struct ipc_mem_channel *channel;
-	enum ipc_phase curr_phase;
 	int status = 0;
 	u32 tail = 0;
 
 	channel = ipc_imem->ipc_devlink->devlink_sio.channel;
-	curr_phase = ipc_imem->phase;
 	/* Increase the total wait time to boot_check_timeout */
 	do {
 		exec_stage = ipc_mmio_get_exec_stage(ipc_imem->mmio);
-- 
2.25.1

