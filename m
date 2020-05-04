Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC6DC1C345C
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbgEDI1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:27:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:30074 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbgEDI1J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 04:27:09 -0400
IronPort-SDR: 1E4heN6NNx1YRLy6qxhaNeyfewbZ3ocLXt7VopCnOjQRPqTRELSoBUOjfiyyo7bGjdC8Ur8KJK
 qEuWo+5WCguA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2020 01:27:08 -0700
IronPort-SDR: oFnrrtyUj4o29LRlaZDl3gle5/+yD/zTVzNqDPmW7WEiy4oMTbuLsvEJVzc6h7ke5GXgwqeSnM
 808keJstRaLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,351,1583222400"; 
   d="scan'208";a="295435894"
Received: from pg-nxl3.altera.com ([10.142.129.93])
  by orsmga008.jf.intel.com with ESMTP; 04 May 2020 01:27:06 -0700
From:   Joyce Ooi <joyce.ooi@intel.com>
To:     Thor Thayer <thor.thayer@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dalon Westergreen <dalon.westergreen@intel.com>,
        Joyce Ooi <joyce.ooi@intel.com>,
        Tan Ley Foon <ley.foon.tan@intel.com>,
        See Chin Liang <chin.liang.see@intel.com>,
        Dinh Nguyen <dinh.nguyen@intel.com>
Subject: [PATCHv2 00/10] net: eth: altera: tse: Add PTP and mSGDMA prefetcher
Date:   Mon,  4 May 2020 16:25:48 +0800
Message-Id: <20200504082558.112627-1-joyce.ooi@intel.com>
X-Mailer: git-send-email 2.13.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series cleans up the Altera TSE driver and adds support
for the newer msgdma prefetcher as well as ptp support when using
the msgdma prefetcher.

v2: Rename altera_ptp to intel_fpga_tod, modify msgdma and sgdma tx_buffer
    functions to be of type netdev_tx_t, and minor suggested edits

Dalon Westergreen (10):
  net: eth: altera: tse_start_xmit ignores tx_buffer call response
  net: eth: altera: set rx and tx ring size before init_dma call
  net: eth: altera: fix altera_dmaops declaration
  net: eth: altera: add optional function to start tx dma
  net: eth: altera: Move common functions to altera_utils
  net: eth: altera: Add missing identifier names to function
    declarations
  net: eth: altera: change tx functions to type netdev_tx_t
  net: eth: altera: add support for ptp and timestamping
  net: eth: altera: add msgdma prefetcher
  net: eth: altera: update devicetree bindings documentation

 .../devicetree/bindings/net/altera_tse.txt         | 103 ++++-
 drivers/net/ethernet/altera/Kconfig                |   1 +
 drivers/net/ethernet/altera/Makefile               |   3 +-
 drivers/net/ethernet/altera/altera_msgdma.c        |   5 +-
 drivers/net/ethernet/altera/altera_msgdma.h        |  30 +-
 .../net/ethernet/altera/altera_msgdma_prefetcher.c | 428 +++++++++++++++++++++
 .../net/ethernet/altera/altera_msgdma_prefetcher.h |  30 ++
 .../ethernet/altera/altera_msgdmahw_prefetcher.h   |  87 +++++
 drivers/net/ethernet/altera/altera_sgdma.c         |  17 +-
 drivers/net/ethernet/altera/altera_sgdma.h         |  32 +-
 drivers/net/ethernet/altera/altera_tse.h           |  98 ++---
 drivers/net/ethernet/altera/altera_tse_ethtool.c   |  29 ++
 drivers/net/ethernet/altera/altera_tse_main.c      | 218 +++++++++--
 drivers/net/ethernet/altera/altera_utils.c         |  29 ++
 drivers/net/ethernet/altera/altera_utils.h         |  51 +++
 drivers/net/ethernet/altera/intel_fpga_tod.c       | 358 +++++++++++++++++
 drivers/net/ethernet/altera/intel_fpga_tod.h       |  56 +++
 17 files changed, 1422 insertions(+), 153 deletions(-)
 create mode 100644 drivers/net/ethernet/altera/altera_msgdma_prefetcher.c
 create mode 100644 drivers/net/ethernet/altera/altera_msgdma_prefetcher.h
 create mode 100644 drivers/net/ethernet/altera/altera_msgdmahw_prefetcher.h
 create mode 100644 drivers/net/ethernet/altera/intel_fpga_tod.c
 create mode 100644 drivers/net/ethernet/altera/intel_fpga_tod.h

-- 
2.13.0

