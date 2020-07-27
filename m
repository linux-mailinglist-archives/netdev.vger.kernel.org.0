Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E259122F64D
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 19:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730313AbgG0RNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 13:13:48 -0400
Received: from mga12.intel.com ([192.55.52.136]:43935 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729988AbgG0RNq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 13:13:46 -0400
IronPort-SDR: n0aHjxZ6sPPpwJj9t5+HB9epBq/EyHdcui6XHlSAJTSmR41gS/MzbUg2Ykc9euB1WHl95VjU4n
 flXYW5qwz7vQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="130631835"
X-IronPort-AV: E=Sophos;i="5.75,402,1589266800"; 
   d="scan'208";a="130631835"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 10:13:44 -0700
IronPort-SDR: dKuYrSWetSW52lkK3+lNLPLLTRwianHbGLF9QJxmZPsa4IRrwhAaKXcxnH9cUFS9lN1GgHKd/s
 tJGmWq9JTYAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,402,1589266800"; 
   d="scan'208";a="394048644"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga001.fm.intel.com with ESMTP; 27 Jul 2020 10:13:44 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next v2 2/8] igc: Add Receive Descriptor Minimum Threshold Count to clear HW counters
Date:   Mon, 27 Jul 2020 10:13:32 -0700
Message-Id: <20200727171338.3698640-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200727171338.3698640-1-anthony.l.nguyen@intel.com>
References: <20200727171338.3698640-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

The statistics of this register are being tracked, however, the register
was inadvertently missed when implementing igc_clear_hw_cntrs_base().
The register is clear on read, so add it to the function so that the
register is cleared when requested so the tracked count is accurate.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_mac.c b/drivers/net/ethernet/intel/igc/igc_mac.c
index 2d9ca3e1bdde..3a618e69514e 100644
--- a/drivers/net/ethernet/intel/igc/igc_mac.c
+++ b/drivers/net/ethernet/intel/igc/igc_mac.c
@@ -308,6 +308,7 @@ void igc_clear_hw_cntrs_base(struct igc_hw *hw)
 	rd32(IGC_TLPIC);
 	rd32(IGC_RLPIC);
 	rd32(IGC_HGPTC);
+	rd32(IGC_RXDMTC);
 	rd32(IGC_HGORCL);
 	rd32(IGC_HGORCH);
 	rd32(IGC_HGOTCL);
-- 
2.26.2

