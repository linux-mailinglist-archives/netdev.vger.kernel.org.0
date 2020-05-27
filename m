Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 799C71E374B
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 06:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725843AbgE0E3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 00:29:24 -0400
Received: from mga18.intel.com ([134.134.136.126]:55099 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725265AbgE0E3X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 00:29:23 -0400
IronPort-SDR: qmeO4+nXYxGJg2a9lYtp9ZmVmqtnq4ZLsKuxdcX92yKqYypqYfdi1k1nUyQH/ZzO4RwNSNiw8O
 LaRszSl/T+jA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2020 21:29:22 -0700
IronPort-SDR: iuCpy8Fp9KodmoAPedmI1rx9Ct3biJWMK0YfCzuT7vnbkD7sr70tpR00yLj0Rm4F6d2bxZ8bQR
 DCEePkfNaJuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,440,1583222400"; 
   d="scan'208";a="468564870"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga005.fm.intel.com with ESMTP; 26 May 2020 21:29:22 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next RFC 00/15] Intel Ethernet Common Module and Data
Date:   Tue, 26 May 2020 21:29:06 -0700
Message-Id: <20200527042921.3951830-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduces both the Intel Ethernet Common Module and the Intel
Data Plane Function.  The patches also incorporate extended features and
functionality added in the virtchnl.h file.

The format of the series flow is to add the data set, then introduce
function stubs, and then introduce pieces in large cohesive subjects or
functionality.  This is to allow for more in depth understanding and
review of the bigger picture as the series is reviewed.

Alan Brady (1):
  idpf: Introduce idpf driver

Alice Michael (14):
  virtchnl: Extend AVF ops
  iecm: Add framework set of header files
  iecm: Add TX/RX header files
  iecm: Common module introduction and function stubs
  iecm: Add basic netdevice functionality
  iecm: Implement mailbox functionality
  iecm: Implement virtchnl commands
  iecm: Implement vector allocation
  iecm: Init and allocate vport
  iecm: Deinit vport
  iecm: Add splitq TX/RX
  iecm: Add singleq TX/RX
  iecm: Add ethtool
  iecm: Add iecm to the kernel build system

 .../networking/device_drivers/intel/idpf.rst  |   47 +
 .../networking/device_drivers/intel/iecm.rst  |   93 +
 MAINTAINERS                                   |    2 +
 drivers/net/ethernet/intel/Kconfig            |   15 +
 drivers/net/ethernet/intel/Makefile           |    2 +
 drivers/net/ethernet/intel/idpf/Makefile      |   14 +
 drivers/net/ethernet/intel/idpf/idpf_dev.h    |   17 +
 drivers/net/ethernet/intel/idpf/idpf_devids.h |   10 +
 drivers/net/ethernet/intel/idpf/idpf_main.c   |  139 +
 drivers/net/ethernet/intel/idpf/idpf_reg.c    |  152 +
 drivers/net/ethernet/intel/iecm/Makefile      |   21 +
 .../net/ethernet/intel/iecm/iecm_controlq.c   |  673 +++
 .../ethernet/intel/iecm/iecm_controlq_setup.c |  177 +
 .../net/ethernet/intel/iecm/iecm_ethtool.c    | 1121 +++++
 drivers/net/ethernet/intel/iecm/iecm_lib.c    | 1092 +++++
 drivers/net/ethernet/intel/iecm/iecm_main.c   |   51 +
 drivers/net/ethernet/intel/iecm/iecm_osdep.c  |   28 +
 .../ethernet/intel/iecm/iecm_singleq_txrx.c   |  889 ++++
 drivers/net/ethernet/intel/iecm/iecm_txrx.c   | 3960 +++++++++++++++++
 .../net/ethernet/intel/iecm/iecm_virtchnl.c   | 2233 ++++++++++
 drivers/net/ethernet/intel/include/iecm.h     |  432 ++
 .../net/ethernet/intel/include/iecm_alloc.h   |   29 +
 .../ethernet/intel/include/iecm_controlq.h    |   95 +
 .../intel/include/iecm_controlq_api.h         |  221 +
 .../ethernet/intel/include/iecm_lan_pf_regs.h |  120 +
 .../ethernet/intel/include/iecm_lan_txrx.h    |  636 +++
 .../net/ethernet/intel/include/iecm_osdep.h   |   24 +
 .../net/ethernet/intel/include/iecm_txrx.h    |  610 +++
 .../net/ethernet/intel/include/iecm_type.h    |   47 +
 include/linux/avf/virtchnl.h                  |  592 +++
 30 files changed, 13542 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/intel/idpf.rst
 create mode 100644 Documentation/networking/device_drivers/intel/iecm.rst
 create mode 100644 drivers/net/ethernet/intel/idpf/Makefile
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_dev.h
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_devids.h
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_main.c
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_reg.c
 create mode 100644 drivers/net/ethernet/intel/iecm/Makefile
 create mode 100644 drivers/net/ethernet/intel/iecm/iecm_controlq.c
 create mode 100644 drivers/net/ethernet/intel/iecm/iecm_controlq_setup.c
 create mode 100644 drivers/net/ethernet/intel/iecm/iecm_ethtool.c
 create mode 100644 drivers/net/ethernet/intel/iecm/iecm_lib.c
 create mode 100644 drivers/net/ethernet/intel/iecm/iecm_main.c
 create mode 100644 drivers/net/ethernet/intel/iecm/iecm_osdep.c
 create mode 100644 drivers/net/ethernet/intel/iecm/iecm_singleq_txrx.c
 create mode 100644 drivers/net/ethernet/intel/iecm/iecm_txrx.c
 create mode 100644 drivers/net/ethernet/intel/iecm/iecm_virtchnl.c
 create mode 100644 drivers/net/ethernet/intel/include/iecm.h
 create mode 100644 drivers/net/ethernet/intel/include/iecm_alloc.h
 create mode 100644 drivers/net/ethernet/intel/include/iecm_controlq.h
 create mode 100644 drivers/net/ethernet/intel/include/iecm_controlq_api.h
 create mode 100644 drivers/net/ethernet/intel/include/iecm_lan_pf_regs.h
 create mode 100644 drivers/net/ethernet/intel/include/iecm_lan_txrx.h
 create mode 100644 drivers/net/ethernet/intel/include/iecm_osdep.h
 create mode 100644 drivers/net/ethernet/intel/include/iecm_txrx.h
 create mode 100644 drivers/net/ethernet/intel/include/iecm_type.h

-- 
2.26.2

