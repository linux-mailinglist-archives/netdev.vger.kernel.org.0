Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB3E9681A59
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 20:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237571AbjA3TZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 14:25:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237514AbjA3TZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 14:25:33 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D78E1206B2
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 11:25:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675106725; x=1706642725;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ozGiwxc7DMQqAJ0aTBiXF61VCeMxXyb0QE9OtSZYnaE=;
  b=GGnFS82MMTQv4SzBSMAvUwLPJ+lCFoSyy2RuDPlsgChZWW718fcaVPkY
   3OG4kU40twAt2X067XQmN5vHMbIX3gkKAO4aX9rNw286U4DRh+XO+qRQA
   x1xZWlqfH61+mT1CnOEwpzuopjUAHqyxQ/x+tTDowKdMZ1p3g7CPWOU3J
   FoHmdIBCOg62f+ZP2beYOp8WjLePqveAZqWUiiPSW96b6Z7PnhHnMDl7X
   MqKrYU8JYtObNt/YaiceNFb15GkNgVSUsLpLrffamy6EtOqrz46l5rfRv
   f3y0RvRGEHXm8iZl9+61HDyl4GaLO7MpmPUS/zd/7d22YRrRfGiqIP6XV
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="392198586"
X-IronPort-AV: E=Sophos;i="5.97,259,1669104000"; 
   d="scan'208";a="392198586"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 11:25:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="696534352"
X-IronPort-AV: E=Sophos;i="5.97,259,1669104000"; 
   d="scan'208";a="696534352"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga001.jf.intel.com with ESMTP; 30 Jan 2023 11:25:25 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        bhelgaas@google.com
Subject: [PATCH net-next 0/8][pull request] Intel Wired LAN: Remove redundant Device Control Error Reporting Enable
Date:   Mon, 30 Jan 2023 11:25:11 -0800
Message-Id: <20230130192519.686446-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bjorn Helgaas says:

Since f26e58bf6f54 ("PCI/AER: Enable error reporting when AER is native"),
the PCI core sets the Device Control bits that enable error reporting for
PCIe devices.

This series removes redundant calls to pci_enable_pcie_error_reporting()
that do the same thing from several NIC drivers.

There are several more drivers where this should be removed; I started with
just the Intel drivers here.
---
TN: Removed mention of AER driver as this was taken through PCI tree [1]
and fixed a typo.

[1] https://lore.kernel.org/all/20230126231527.GA1322015@bhelgaas/

The following are changes since commit 90e8ca0abb05ada6c1e2710eaa21688dafca26f2:
  Merge branch 'devlink-next'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 10GbE

Bjorn Helgaas (8):
  e1000e: Remove redundant pci_enable_pcie_error_reporting()
  fm10k: Remove redundant pci_enable_pcie_error_reporting()
  i40e: Remove redundant pci_enable_pcie_error_reporting()
  iavf: Remove redundant pci_enable_pcie_error_reporting()
  ice: Remove redundant pci_enable_pcie_error_reporting()
  igb: Remove redundant pci_enable_pcie_error_reporting()
  igc: Remove redundant pci_enable_pcie_error_reporting()
  ixgbe: Remove redundant pci_enable_pcie_error_reporting()

 drivers/net/ethernet/intel/e1000e/netdev.c    | 7 -------
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c  | 5 -----
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 4 ----
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 5 -----
 drivers/net/ethernet/intel/ice/ice_main.c     | 3 ---
 drivers/net/ethernet/intel/igb/igb_main.c     | 5 -----
 drivers/net/ethernet/intel/igc/igc_main.c     | 5 -----
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 5 -----
 8 files changed, 39 deletions(-)

-- 
2.38.1

