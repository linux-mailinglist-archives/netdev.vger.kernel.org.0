Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2315FECE93
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 13:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfKBMOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 08:14:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:42775 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbfKBMOV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Nov 2019 08:14:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Nov 2019 05:14:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,259,1569308400"; 
   d="scan'208";a="204132337"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga003.jf.intel.com with ESMTP; 02 Nov 2019 05:14:20 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 0/7][pull request] 10GbE Intel Wired LAN Driver Updates 2019-11-02
Date:   Sat,  2 Nov 2019 05:14:10 -0700
Message-Id: <20191102121417.15421-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains old Halloween candy updates, yet still sweet, to
fm10k, ixgbe and i40e.

Jake adds the missing initializers for a couple of the TLV attribute
macros.  Added support for capturing and reporting statistics for all of
the VFs in a given PF.  Lastly, bump the version of the fm10k driver to
reflect the recent changes.

Alex addresses locality issues in the ixgbe driver when it is loaded on
a system supporting multiple NUMA nodes.

Manjunath Patil provides changes to the ixgbe driver, similar to those
made to igb, to prevent transmit packets to request a hardware timestamp
when the NIC has not been setup via the SIOCSHWTSTAMP ioctl.

Alice adds support for x710 by adding the missing device id's in the
appropriate places to ensure all the features are enabled in i40e.

Jesse adds support for VF stats gathering in the i40e via the kernel
via ndo_get_vf_stats function.

The following are changes since commit c23fcbbc6aa4e0bb615e8a7f23e1f32aec235a1c:
  tc-testing: added tests with cookie for conntrack TC action
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 10GbE

Alexander Duyck (1):
  ixgbe: Make use of cpumask_local_spread to improve RSS locality

Alice Michael (1):
  i40e: enable X710 support

Jacob Keller (3):
  fm10k: add missing field initializers to TLV attributes)
  fm10k: add support for ndo_get_vf_stats operation
  fm10k: update driver version to match out-of-tree

Jesse Brandeburg (1):
  i40e: implement VF stats NDO

Manjunath Patil (1):
  ixgbe: protect TX timestamping from API misuse

 drivers/net/ethernet/intel/fm10k/fm10k.h      |  3 ++
 drivers/net/ethernet/intel/fm10k/fm10k_iov.c  | 48 +++++++++++++++++++
 drivers/net/ethernet/intel/fm10k/fm10k_main.c |  2 +-
 .../net/ethernet/intel/fm10k/fm10k_netdev.c   |  1 +
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c  |  3 ++
 drivers/net/ethernet/intel/fm10k/fm10k_tlv.h  |  6 +--
 drivers/net/ethernet/intel/fm10k/fm10k_type.h |  1 +
 drivers/net/ethernet/intel/i40e/i40e_common.c |  2 +
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  1 +
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 48 +++++++++++++++++++
 .../ethernet/intel/i40e/i40e_virtchnl_pf.h    |  2 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c  |  8 ++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  3 +-
 13 files changed, 118 insertions(+), 10 deletions(-)

-- 
2.21.0

