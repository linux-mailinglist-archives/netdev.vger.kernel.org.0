Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2473536565
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 22:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbfFEUYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 16:24:04 -0400
Received: from mga18.intel.com ([134.134.136.126]:4313 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726717AbfFEUXr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 16:23:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jun 2019 13:23:46 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga005.jf.intel.com with ESMTP; 05 Jun 2019 13:23:45 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 07/15] ixgbe: use 'cc' instead of 'hw_cc' for local variable
Date:   Wed,  5 Jun 2019 13:23:50 -0700
Message-Id: <20190605202358.2767-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190605202358.2767-1-jeffrey.t.kirsher@intel.com>
References: <20190605202358.2767-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The ixgbe_ptp.c file sometimes uses hw_cc as the local variable for the
cycle counter in ixgbe_ptp_read_X550. However, we use just 'cc' as
a local variable for this by convention else where in the file.

Convert this lone usage of 'hw_cc' into just the shorter 'cc' name to
match the other read functions in the file.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
index 047767408df0..20f11ea641e2 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
@@ -226,7 +226,7 @@ static void ixgbe_ptp_setup_sdp_X540(struct ixgbe_adapter *adapter)
 
 /**
  * ixgbe_ptp_read_X550 - read cycle counter value
- * @hw_cc: cyclecounter structure
+ * @cc: cyclecounter structure
  *
  * This function reads SYSTIME registers. It is called by the cyclecounter
  * structure to convert from internal representation into nanoseconds. We need
@@ -234,10 +234,10 @@ static void ixgbe_ptp_setup_sdp_X540(struct ixgbe_adapter *adapter)
  * result of SYSTIME is 32bits of "billions of cycles" and 32 bits of
  * "cycles", rather than seconds and nanoseconds.
  */
-static u64 ixgbe_ptp_read_X550(const struct cyclecounter *hw_cc)
+static u64 ixgbe_ptp_read_X550(const struct cyclecounter *cc)
 {
 	struct ixgbe_adapter *adapter =
-			container_of(hw_cc, struct ixgbe_adapter, hw_cc);
+		container_of(cc, struct ixgbe_adapter, hw_cc);
 	struct ixgbe_hw *hw = &adapter->hw;
 	struct timespec64 ts;
 
-- 
2.21.0

