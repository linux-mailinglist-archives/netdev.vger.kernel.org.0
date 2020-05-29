Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80A31E7113
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 02:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437983AbgE2AIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 20:08:36 -0400
Received: from mga03.intel.com ([134.134.136.65]:2081 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437933AbgE2AIe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 20:08:34 -0400
IronPort-SDR: 1KscPOzSd4DkoKYF9fXP3i7+YA/87A1t83B7e9bcbTF0pTC4gsokAD8PrH7z6Dgk2I4jnheITG
 cNWDxERS/jog==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 17:08:33 -0700
IronPort-SDR: zFvWOQJeC/J8cTSJSN58qDY0/t5St1TSbcsvi/VfaKOwd0Z3BXYPRBdTniLbD9LPMxV5v4jfBp
 i8q9ZeoaGS/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,446,1583222400"; 
   d="scan'208";a="302651617"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 28 May 2020 17:08:32 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 02/15] ice: cleanup VSI context initialization
Date:   Thu, 28 May 2020 17:08:18 -0700
Message-Id: <20200529000831.2803870-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529000831.2803870-1-jeffrey.t.kirsher@intel.com>
References: <20200529000831.2803870-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Remove an unnecessary copy of vsi->info into ctxt->info in ice_vsi_init.
This line is essentially a no-op because ice_set_dflt_vsi_ctx performs
a memset to clear the info from the context structure.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 6f3ee8ac11ce..89e8e4f7f56f 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -938,7 +938,6 @@ static int ice_vsi_init(struct ice_vsi *vsi, bool init_vsi)
 	if (!ctxt)
 		return -ENOMEM;
 
-	ctxt->info = vsi->info;
 	switch (vsi->type) {
 	case ICE_VSI_CTRL:
 	case ICE_VSI_LB:
-- 
2.26.2

