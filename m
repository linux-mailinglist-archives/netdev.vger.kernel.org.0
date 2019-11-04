Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFCDEEB08
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 22:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729631AbfKDVXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 16:23:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:13954 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728634AbfKDVXt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 16:23:49 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Nov 2019 13:23:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,268,1569308400"; 
   d="scan'208";a="219715245"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Nov 2019 13:23:49 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next v2 0/7][pull request] 10GbE Intel Wired LAN Driver Updates 2019-11-04
Date:   Mon,  4 Nov 2019 13:23:41 -0800
Message-Id: <20191104212348.9625-1-jeffrey.t.kirsher@intel.com>
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

v2: Fixed up commit id references in patch 5's description to align with
    how commit id's should be referenced.

The following are changes since commit 1574cf83c7a069f5f29295170ed8a568ccebcb7b:
  Merge tag 'mlx5-updates-2019-11-01' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
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

