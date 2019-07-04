Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C956D5F127
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 04:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfGDCMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 22:12:19 -0400
Received: from mga03.intel.com ([134.134.136.65]:7957 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbfGDCMT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 22:12:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jul 2019 19:12:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,449,1557212400"; 
   d="scan'208";a="315741757"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 03 Jul 2019 19:12:18 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net, dledford@redhat.com, jgg@mellanox.com
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, mustafa.ismail@intel.com,
        shiraz.saleem@intel.com, david.m.ertman@intel.com
Subject: [net-next 0/3][pull request] Intel Wired LAN ver Updates 2019-07-03
Date:   Wed,  3 Jul 2019 19:12:49 -0700
Message-Id: <20190704021252.15534-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e an ice drivers only and is required
for a series of changes being submitted to the RDMA maintainer/tree.
Vice Versa, the Intel RDMA driver patches could not be applied to
net-next due to dependencies to the changes currently in the for-next
branch of the rdma git tree.  The Intel RDMA driver patches are
available in the following git repository:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/rdma for-next
  (reference only)

Dave initializes the ice driver to support RDMA by creating and
registering a platform device for the RDMA driver to register to on a
virtual bus by utilizing the platform bus to provide this access.
Followed up by operations for the peer device/driver to communicate with
each other to request resources and manage event notification.

Shiraz does the similar work in the i40e driver, while retaining the
old global register/unregister calls exported for i40iw until that
driver is removed from the kernel.

The following are changes since commit a51df9f8da43e8bf9e508143630849b7d696e053:
  gve: fix -ENOMEM null check on a page allocation
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Shiraz Saleem (1):
  i40e: Register RDMA client devices to the virtual platform bus

Tony Nguyen (2):
  ice: Initialize and register platform device to provide RDMA
  ice: Implement peer communications

 drivers/net/ethernet/intel/i40e/i40e_client.c |  116 +-
 drivers/net/ethernet/intel/i40e/i40e_client.h |    8 +
 drivers/net/ethernet/intel/ice/Makefile       |    1 +
 drivers/net/ethernet/intel/ice/ice.h          |   15 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   33 +
 drivers/net/ethernet/intel/ice/ice_common.c   |  194 +++
 drivers/net/ethernet/intel/ice/ice_common.h   |    9 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   64 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |    2 +
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |    1 +
 drivers/net/ethernet/intel/ice/ice_idc.c      | 1354 +++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_idc.h      |  377 +++++
 drivers/net/ethernet/intel/ice/ice_idc_int.h  |   82 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |   35 +-
 drivers/net/ethernet/intel/ice/ice_lib.h      |    2 +
 drivers/net/ethernet/intel/ice/ice_main.c     |   94 +-
 drivers/net/ethernet/intel/ice/ice_sched.c    |   69 +-
 drivers/net/ethernet/intel/ice/ice_switch.c   |   27 +
 drivers/net/ethernet/intel/ice/ice_switch.h   |    4 +
 drivers/net/ethernet/intel/ice/ice_type.h     |    4 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |   25 -
 21 files changed, 2462 insertions(+), 54 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc_int.h

-- 
2.21.0

