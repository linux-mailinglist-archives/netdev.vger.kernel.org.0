Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94D457E481
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 22:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387848AbfHAUvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 16:51:53 -0400
Received: from mga07.intel.com ([134.134.136.100]:8390 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727580AbfHAUvx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 16:51:53 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Aug 2019 13:51:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,335,1559545200"; 
   d="scan'208";a="163734547"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga007.jf.intel.com with ESMTP; 01 Aug 2019 13:51:51 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Slawomir Laba <slawomirx.laba@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 3/9] i40e: Log disable-fw-lldp flag change by ethtool
Date:   Thu,  1 Aug 2019 13:51:43 -0700
Message-Id: <20190801205149.4114-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190801205149.4114-1-jeffrey.t.kirsher@intel.com>
References: <20190801205149.4114-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Slawomir Laba <slawomirx.laba@intel.com>

Add logging for disable-fw-lldp flag by ethtool. Added check
for I40E_FLAG_DISABLE_FW_LLDP and logging state in dmesg.
Without this commit there was no clear statement in dmesg
about FW LLDP state in dmesg.

Signed-off-by: Slawomir Laba <slawomirx.laba@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index d39940b9c8b7..423a4820af4c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -8486,6 +8486,11 @@ void i40e_do_reset(struct i40e_pf *pf, u32 reset_flags, bool lock_acquired)
 		dev_dbg(&pf->pdev->dev, "PFR requested\n");
 		i40e_handle_reset_warning(pf, lock_acquired);
 
+		dev_info(&pf->pdev->dev,
+			 pf->flags & I40E_FLAG_DISABLE_FW_LLDP ?
+			 "FW LLDP is disabled\n" :
+			 "FW LLDP is enabled\n");
+
 	} else if (reset_flags & BIT_ULL(__I40E_REINIT_REQUESTED)) {
 		int v;
 
-- 
2.21.0

