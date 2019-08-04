Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB3EE80AC4
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 13:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbfHDL7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 07:59:36 -0400
Received: from mga05.intel.com ([192.55.52.43]:50580 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726180AbfHDL73 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Aug 2019 07:59:29 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Aug 2019 04:59:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,345,1559545200"; 
   d="scan'208";a="178602026"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 04 Aug 2019 04:59:28 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 3/8] fm10k: remove needless initialization of size local variable
Date:   Sun,  4 Aug 2019 04:59:21 -0700
Message-Id: <20190804115926.31944-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190804115926.31944-1-jeffrey.t.kirsher@intel.com>
References: <20190804115926.31944-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The local variable 'size' in fm10k_dfwd_add_station is initialized, but
is always re-assigned immediately before use. Remove this unnecessary
initialization.

This was detected by cppcheck and resolves the following warning
produced by that tool:

[fm10k_netdev.c:1466]: (style) Variable 'size' is assigned a value that is never used.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/fm10k/fm10k_netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
index 4704395c0f66..d3e85480f46d 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -1463,7 +1463,7 @@ static void *fm10k_dfwd_add_station(struct net_device *dev,
 	struct fm10k_l2_accel *old_l2_accel = NULL;
 	struct fm10k_dglort_cfg dglort = { 0 };
 	struct fm10k_hw *hw = &interface->hw;
-	int size = 0, i;
+	int size, i;
 	u16 vid, glort;
 
 	/* The hardware supported by fm10k only filters on the destination MAC
-- 
2.21.0

