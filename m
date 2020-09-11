Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F2926569B
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 03:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725815AbgIKBYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 21:24:31 -0400
Received: from mga05.intel.com ([192.55.52.43]:51535 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725764AbgIKBXz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 21:23:55 -0400
IronPort-SDR: PebF/z5YMO7zYh+7R1wAKh3Wr7AmmM/4h4XnG2OrihIvz+QFSHeWigpgb6/0JIb485qjQrzsRb
 pmcdqO5kM++Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9740"; a="243491827"
X-IronPort-AV: E=Sophos;i="5.76,413,1592895600"; 
   d="scan'208";a="243491827"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 18:23:45 -0700
IronPort-SDR: X6Dp6g8S2cE0f0A+KmukmVWLfIhUivuB6X95Tv+HrxeotxfMVO1PpINPp7AtTgmpgUOJUWcQtw
 XewGPcgJDBmA==
X-IronPort-AV: E=Sophos;i="5.76,413,1592895600"; 
   d="scan'208";a="449808141"
Received: from jbrandeb-desk.jf.intel.com ([10.166.244.152])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 18:23:44 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org
Subject: [RFC PATCH net-next v1 04/11] ixgbe: clean up W=1 warnings in ixgbe
Date:   Thu, 10 Sep 2020 18:23:30 -0700
Message-Id: <20200911012337.14015-5-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200911012337.14015-1-jesse.brandeburg@intel.com>
References: <20200911012337.14015-1-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Inspired by Lee Jones, this eliminates the remaining W=1 warnings in
ixgbe.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 ++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c  | 8 ++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 0b675c34ce49..02899f79f0ff 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -6175,8 +6175,9 @@ static void ixgbe_set_eee_capable(struct ixgbe_adapter *adapter)
 /**
  * ixgbe_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
+ * @txqueue: queue number that timed out
  **/
-static void ixgbe_tx_timeout(struct net_device *netdev, unsigned int txqueue)
+static void ixgbe_tx_timeout(struct net_device *netdev, unsigned int __always_unused txqueue)
 {
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
index 7980d7265e10..f77fa3e4fdd1 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
@@ -771,7 +771,7 @@ static s32 ixgbe_mii_bus_write_generic(struct ixgbe_hw *hw, int addr,
 
 /**
  *  ixgbe_mii_bus_read - Read a clause 22/45 register
- *  @hw: pointer to hardware structure
+ *  @bus: pointer to mii_bus structure which points to our driver private
  *  @addr: address
  *  @regnum: register number
  **/
@@ -786,7 +786,7 @@ static s32 ixgbe_mii_bus_read(struct mii_bus *bus, int addr, int regnum)
 
 /**
  *  ixgbe_mii_bus_write - Write a clause 22/45 register
- *  @hw: pointer to hardware structure
+ *  @bus: pointer to mii_bus structure which points to our driver private
  *  @addr: address
  *  @regnum: register number
  *  @val: value to write
@@ -803,7 +803,7 @@ static s32 ixgbe_mii_bus_write(struct mii_bus *bus, int addr, int regnum,
 
 /**
  *  ixgbe_x550em_a_mii_bus_read - Read a clause 22/45 register on x550em_a
- *  @hw: pointer to hardware structure
+ *  @bus: pointer to mii_bus structure which points to our driver private
  *  @addr: address
  *  @regnum: register number
  **/
@@ -820,7 +820,7 @@ static s32 ixgbe_x550em_a_mii_bus_read(struct mii_bus *bus, int addr,
 
 /**
  *  ixgbe_x550em_a_mii_bus_write - Write a clause 22/45 register on x550em_a
- *  @hw: pointer to hardware structure
+ *  @bus: pointer to mii_bus structure which points to our driver private
  *  @addr: address
  *  @regnum: register number
  *  @val: value to write
-- 
2.27.0

