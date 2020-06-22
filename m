Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1BC9204374
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 00:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731087AbgFVWSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 18:18:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:11465 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731006AbgFVWSW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 18:18:22 -0400
IronPort-SDR: g7gZNC6sVSH/i46aoiNNNyuwp2YWORpB2cFyWarGvio0DJeO6/UClbvja/2FiLVqaLAK3iq4GO
 O9IFokWAOrkw==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="161973190"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="161973190"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 15:18:20 -0700
IronPort-SDR: tpAgAJOeyJTahoOIA3EbZvSd+0vHuHexOycGDXinerWz0yPSXxLi1p9qv6FYSl3OfOXD3Ijh90
 lURx0h4/FFhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="311075796"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 22 Jun 2020 15:18:18 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Shiraz Saleem <shiraz.saleem@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 1/9] i40e: Move client header location
Date:   Mon, 22 Jun 2020 15:18:09 -0700
Message-Id: <20200622221817.2287549-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200622221817.2287549-1-jeffrey.t.kirsher@intel.com>
References: <20200622221817.2287549-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem@intel.com>

Move i40e_client.h to include/linux/net/intel/*
since its shared between i40iw and i40e.

Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/infiniband/hw/i40iw/Makefile                            | 1 -
 drivers/infiniband/hw/i40iw/i40iw.h                             | 2 +-
 drivers/net/ethernet/intel/i40e/i40e.h                          | 2 +-
 drivers/net/ethernet/intel/i40e/i40e_client.c                   | 2 +-
 .../intel/i40e => include/linux/net/intel}/i40e_client.h        | 0
 5 files changed, 3 insertions(+), 4 deletions(-)
 rename {drivers/net/ethernet/intel/i40e => include/linux/net/intel}/i40e_client.h (100%)

diff --git a/drivers/infiniband/hw/i40iw/Makefile b/drivers/infiniband/hw/i40iw/Makefile
index 8942f8229945..34da9eba8a7c 100644
--- a/drivers/infiniband/hw/i40iw/Makefile
+++ b/drivers/infiniband/hw/i40iw/Makefile
@@ -1,5 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
-ccflags-y :=  -I $(srctree)/drivers/net/ethernet/intel/i40e
 
 obj-$(CONFIG_INFINIBAND_I40IW) += i40iw.o
 
diff --git a/drivers/infiniband/hw/i40iw/i40iw.h b/drivers/infiniband/hw/i40iw/i40iw.h
index 49d92638e0db..25747b85a79c 100644
--- a/drivers/infiniband/hw/i40iw/i40iw.h
+++ b/drivers/infiniband/hw/i40iw/i40iw.h
@@ -45,6 +45,7 @@
 #include <linux/slab.h>
 #include <linux/io.h>
 #include <linux/crc32c.h>
+#include <linux/net/intel/i40e_client.h>
 #include <rdma/ib_smi.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_pack.h>
@@ -57,7 +58,6 @@
 #include "i40iw_d.h"
 #include "i40iw_hmc.h"
 
-#include <i40e_client.h>
 #include "i40iw_type.h"
 #include "i40iw_p.h"
 #include <rdma/i40iw-abi.h>
diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index e95b8da45e07..5ff0828a6f50 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -38,7 +38,7 @@
 #include <net/xdp_sock.h>
 #include "i40e_type.h"
 #include "i40e_prototype.h"
-#include "i40e_client.h"
+#include <linux/net/intel/i40e_client.h>
 #include <linux/avf/virtchnl.h>
 #include "i40e_virtchnl_pf.h"
 #include "i40e_txrx.h"
diff --git a/drivers/net/ethernet/intel/i40e/i40e_client.c b/drivers/net/ethernet/intel/i40e/i40e_client.c
index e81530ca08d0..befd3018183f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_client.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_client.c
@@ -3,10 +3,10 @@
 
 #include <linux/list.h>
 #include <linux/errno.h>
+#include <linux/net/intel/i40e_client.h>
 
 #include "i40e.h"
 #include "i40e_prototype.h"
-#include "i40e_client.h"
 
 static const char i40e_client_interface_version_str[] = I40E_CLIENT_VERSION_STR;
 static struct i40e_client *registered_client;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_client.h b/include/linux/net/intel/i40e_client.h
similarity index 100%
rename from drivers/net/ethernet/intel/i40e/i40e_client.h
rename to include/linux/net/intel/i40e_client.h
-- 
2.26.2

