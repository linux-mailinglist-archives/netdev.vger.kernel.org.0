Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE31180AC0
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 13:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfHDL73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 07:59:29 -0400
Received: from mga05.intel.com ([192.55.52.43]:50581 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726225AbfHDL73 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Aug 2019 07:59:29 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Aug 2019 04:59:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,345,1559545200"; 
   d="scan'208";a="178602029"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 04 Aug 2019 04:59:28 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 4/8] fm10k: explicitly return 0 on success path in function
Date:   Sun,  4 Aug 2019 04:59:22 -0700
Message-Id: <20190804115926.31944-5-jeffrey.t.kirsher@intel.com>
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

In the fm10k_handle_resume function, return 0 explicitly at the end of
the function instead of returning the err value.

This was detected by cppcheck and resolves the following style warning
produced by that tool:

[fm10k_pci.c:2768] -> [fm10k_pci.c:2787]: (warning) Identical condition
'err', second condition is always false

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
index 9522e9f8f8b8..73928dbe714f 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
@@ -2340,7 +2340,7 @@ static int fm10k_handle_resume(struct fm10k_intfc *interface)
 	/* Restart the MAC/VLAN request queue in-case of outstanding events */
 	fm10k_macvlan_schedule(interface);
 
-	return err;
+	return 0;
 }
 
 /**
-- 
2.21.0

