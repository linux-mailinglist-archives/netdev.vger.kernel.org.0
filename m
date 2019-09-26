Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44D60BF6E5
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 18:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbfIZQp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 12:45:29 -0400
Received: from mga18.intel.com ([134.134.136.126]:60795 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727444AbfIZQp3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 12:45:29 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 09:45:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,552,1559545200"; 
   d="scan'208";a="219465097"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga002.fm.intel.com with ESMTP; 26 Sep 2019 09:45:27 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     dledford@redhat.com, jgg@mellanox.com, gregkh@linuxfoundation.org
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [RFC 00/20] Intel RDMA/IDC Driver series
Date:   Thu, 26 Sep 2019 09:44:59 -0700
Message-Id: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series is sent out as an RFC to verify that our implementation of
the MFD subsystem is correct to facilitate inner driver communication
(IDC) between the new "irdma" driver to support Intel's ice and i40e
drivers.

The changes contain the modified ice and i40e driver changes using the
MFD subsystem.  It also contains the new irdma driver which is replacing
the i40iw driver and supports both the i40e and ice drivers.

Michael J. Ruhl (1):
  RDMA/irdma: Add dynamic tracing for CM

Mustafa Ismail (14):
  i40e: Register multi-function device to provide RDMA
  RDMA/irdma: Add driver framework definitions
  RDMA/irdma: Implement device initialization definitions
  RDMA/irdma: Implement HW Admin Queue OPs
  RDMA/irdma: Add HMC backing store setup functions
  RDMA/irdma: Add privileged UDA queue implementation
  RDMA/irdma: Add QoS definitions
  RDMA/irdma: Add connection manager
  RDMA/irdma: Add PBLE resource manager
  RDMA/irdma: Implement device supported verb APIs
  RDMA/irdma: Add RoCEv2 UD OP support
  RDMA/irdma: Add user/kernel shared libraries
  RDMA/irdma: Add miscellaneous utility definitions
  RDMA/irdma: Add ABI definitions

Shiraz Saleem (3):
  RDMA/irdma: Update MAINTAINERS file
  RDMA/irdma: Add Kconfig and Makefile
  RDMA/i40iw: Mark i40iw as deprecated

Tony Nguyen (2):
  ice: Initialize and register multi-function device to provide RDMA
  ice: Implement peer communications

 MAINTAINERS                                   |   11 +-
 drivers/infiniband/Kconfig                    |    1 +
 drivers/infiniband/hw/Makefile                |    1 +
 drivers/infiniband/hw/i40iw/Kconfig           |    4 +-
 drivers/infiniband/hw/i40iw/Makefile          |    1 -
 drivers/infiniband/hw/i40iw/i40iw.h           |    2 +-
 drivers/infiniband/hw/irdma/Kconfig           |   11 +
 drivers/infiniband/hw/irdma/Makefile          |   28 +
 drivers/infiniband/hw/irdma/cm.c              | 4511 +++++++++++++
 drivers/infiniband/hw/irdma/cm.h              |  415 ++
 drivers/infiniband/hw/irdma/ctrl.c            | 5958 +++++++++++++++++
 drivers/infiniband/hw/irdma/defs.h            | 2126 ++++++
 drivers/infiniband/hw/irdma/hmc.c             |  706 ++
 drivers/infiniband/hw/irdma/hmc.h             |  219 +
 drivers/infiniband/hw/irdma/hw.c              | 2564 +++++++
 drivers/infiniband/hw/irdma/i40iw_hw.c        |  210 +
 drivers/infiniband/hw/irdma/i40iw_hw.h        |  163 +
 drivers/infiniband/hw/irdma/i40iw_if.c        |  270 +
 drivers/infiniband/hw/irdma/icrdma_hw.c       |   75 +
 drivers/infiniband/hw/irdma/icrdma_hw.h       |   63 +
 drivers/infiniband/hw/irdma/irdma.h           |  191 +
 drivers/infiniband/hw/irdma/irdma_if.c        |  436 ++
 drivers/infiniband/hw/irdma/main.c            |  531 ++
 drivers/infiniband/hw/irdma/main.h            |  639 ++
 drivers/infiniband/hw/irdma/osdep.h           |  108 +
 drivers/infiniband/hw/irdma/pble.c            |  511 ++
 drivers/infiniband/hw/irdma/pble.h            |  136 +
 drivers/infiniband/hw/irdma/protos.h          |   96 +
 drivers/infiniband/hw/irdma/puda.c            | 1693 +++++
 drivers/infiniband/hw/irdma/puda.h            |  187 +
 drivers/infiniband/hw/irdma/status.h          |   70 +
 drivers/infiniband/hw/irdma/trace.c           |  113 +
 drivers/infiniband/hw/irdma/trace.h           |    4 +
 drivers/infiniband/hw/irdma/trace_cm.h        |  459 ++
 drivers/infiniband/hw/irdma/type.h            | 1701 +++++
 drivers/infiniband/hw/irdma/uda.c             |  391 ++
 drivers/infiniband/hw/irdma/uda.h             |   65 +
 drivers/infiniband/hw/irdma/uda_d.h           |  383 ++
 drivers/infiniband/hw/irdma/uk.c              | 1739 +++++
 drivers/infiniband/hw/irdma/user.h            |  449 ++
 drivers/infiniband/hw/irdma/utils.c           | 2333 +++++++
 drivers/infiniband/hw/irdma/verbs.c           | 4346 ++++++++++++
 drivers/infiniband/hw/irdma/verbs.h           |  199 +
 drivers/infiniband/hw/irdma/ws.c              |  396 ++
 drivers/infiniband/hw/irdma/ws.h              |   40 +
 drivers/net/ethernet/intel/Kconfig            |    2 +
 drivers/net/ethernet/intel/i40e/i40e.h        |    3 +-
 drivers/net/ethernet/intel/i40e/i40e_client.c |  149 +-
 drivers/net/ethernet/intel/ice/Makefile       |    1 +
 drivers/net/ethernet/intel/ice/ice.h          |   18 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   33 +
 drivers/net/ethernet/intel/ice/ice_common.c   |  194 +
 drivers/net/ethernet/intel/ice/ice_common.h   |    9 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   65 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |    3 +
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |    1 +
 drivers/net/ethernet/intel/ice/ice_idc.c      | 1326 ++++
 drivers/net/ethernet/intel/ice/ice_idc_int.h  |  119 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |   46 +-
 drivers/net/ethernet/intel/ice/ice_lib.h      |    3 +
 drivers/net/ethernet/intel/ice/ice_main.c     |  131 +-
 drivers/net/ethernet/intel/ice/ice_sched.c    |   69 +-
 drivers/net/ethernet/intel/ice/ice_switch.c   |   27 +
 drivers/net/ethernet/intel/ice/ice_switch.h   |    4 +
 drivers/net/ethernet/intel/ice/ice_type.h     |    4 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |   25 -
 .../linux/net/intel}/i40e_client.h            |   21 +
 include/linux/net/intel/iidc.h                |  355 +
 include/uapi/rdma/irdma-abi.h                 |  159 +
 include/uapi/rdma/rdma_user_ioctl_cmds.h      |    1 +
 70 files changed, 37268 insertions(+), 55 deletions(-)
 create mode 100644 drivers/infiniband/hw/irdma/Kconfig
 create mode 100644 drivers/infiniband/hw/irdma/Makefile
 create mode 100644 drivers/infiniband/hw/irdma/cm.c
 create mode 100644 drivers/infiniband/hw/irdma/cm.h
 create mode 100644 drivers/infiniband/hw/irdma/ctrl.c
 create mode 100644 drivers/infiniband/hw/irdma/defs.h
 create mode 100644 drivers/infiniband/hw/irdma/hmc.c
 create mode 100644 drivers/infiniband/hw/irdma/hmc.h
 create mode 100644 drivers/infiniband/hw/irdma/hw.c
 create mode 100644 drivers/infiniband/hw/irdma/i40iw_hw.c
 create mode 100644 drivers/infiniband/hw/irdma/i40iw_hw.h
 create mode 100644 drivers/infiniband/hw/irdma/i40iw_if.c
 create mode 100644 drivers/infiniband/hw/irdma/icrdma_hw.c
 create mode 100644 drivers/infiniband/hw/irdma/icrdma_hw.h
 create mode 100644 drivers/infiniband/hw/irdma/irdma.h
 create mode 100644 drivers/infiniband/hw/irdma/irdma_if.c
 create mode 100644 drivers/infiniband/hw/irdma/main.c
 create mode 100644 drivers/infiniband/hw/irdma/main.h
 create mode 100644 drivers/infiniband/hw/irdma/osdep.h
 create mode 100644 drivers/infiniband/hw/irdma/pble.c
 create mode 100644 drivers/infiniband/hw/irdma/pble.h
 create mode 100644 drivers/infiniband/hw/irdma/protos.h
 create mode 100644 drivers/infiniband/hw/irdma/puda.c
 create mode 100644 drivers/infiniband/hw/irdma/puda.h
 create mode 100644 drivers/infiniband/hw/irdma/status.h
 create mode 100644 drivers/infiniband/hw/irdma/trace.c
 create mode 100644 drivers/infiniband/hw/irdma/trace.h
 create mode 100644 drivers/infiniband/hw/irdma/trace_cm.h
 create mode 100644 drivers/infiniband/hw/irdma/type.h
 create mode 100644 drivers/infiniband/hw/irdma/uda.c
 create mode 100644 drivers/infiniband/hw/irdma/uda.h
 create mode 100644 drivers/infiniband/hw/irdma/uda_d.h
 create mode 100644 drivers/infiniband/hw/irdma/uk.c
 create mode 100644 drivers/infiniband/hw/irdma/user.h
 create mode 100644 drivers/infiniband/hw/irdma/utils.c
 create mode 100644 drivers/infiniband/hw/irdma/verbs.c
 create mode 100644 drivers/infiniband/hw/irdma/verbs.h
 create mode 100644 drivers/infiniband/hw/irdma/ws.c
 create mode 100644 drivers/infiniband/hw/irdma/ws.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc_int.h
 rename {drivers/net/ethernet/intel/i40e => include/linux/net/intel}/i40e_client.h (92%)
 create mode 100644 include/linux/net/intel/iidc.h
 create mode 100644 include/uapi/rdma/irdma-abi.h

-- 
2.21.0

