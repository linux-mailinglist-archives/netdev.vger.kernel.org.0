Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 335E9B1593
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 22:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbfILUuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 16:50:05 -0400
Received: from mga07.intel.com ([134.134.136.100]:59558 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727811AbfILUuF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 16:50:05 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 13:50:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="197345129"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga002.jf.intel.com with ESMTP; 12 Sep 2019 13:50:04 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 0/6][pull request] 100GbE Intel Wired LAN Driver Updates 2019-09-12
Date:   Thu, 12 Sep 2019 13:49:56 -0700
Message-Id: <20190912205002.12159-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver to implement and support
loading a Dynamic Device Personalization (DDP) package from lib/firmware
onto the device.

Paul updates the way the driver version is stored in the driver so that
we can pass the driver version to the firmware.  Passing of the driver
version to the firmware is needed for the DDP package to ensure we have
the appropriate support in the driver for the features in the package.

Lukasz fixes how the firmware version is stored to align with how the
firmware stores its own version.  Also extended the log message to
display additional useful information such as NVM version, API patch
information and firmware build hash.

Tony adds the needed driver support to check, load and store the DDP
package.  Also add support for the ability to load DDP packages intended
for specific hardware devices, as well as what to do when loading of the
DDP package fails to load.

The following are changes since commit 172ca8308b0517ca2522a8c885755fd5c20294e7:
  cxgb4: Fix spelling typos
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Lukasz Czapnik (1):
  ice: Fix FW version formatting in dmesg

Paul M Stillwell Jr (1):
  ice: send driver version to firmware

Tony Nguyen (4):
  ice: Implement Dynamic Device Personalization (DDP) download
  ice: Initialize DDP package structures
  ice: Enable DDP package download
  ice: Bump version

 drivers/net/ethernet/intel/ice/Makefile       |    1 +
 drivers/net/ethernet/intel/ice/ice.h          |   16 +-
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   73 +
 drivers/net/ethernet/intel/ice/ice_common.c   |  174 +-
 drivers/net/ethernet/intel/ice/ice_common.h   |   12 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   42 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |    2 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |   52 +-
 .../net/ethernet/intel/ice/ice_flex_pipe.c    | 1549 +++++++++++++++++
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |   29 +
 .../net/ethernet/intel/ice/ice_flex_type.h    |  374 ++++
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |    2 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |  111 +-
 drivers/net/ethernet/intel/ice/ice_lib.h      |    3 +
 drivers/net/ethernet/intel/ice/ice_main.c     |  657 +++++--
 drivers/net/ethernet/intel/ice/ice_type.h     |   36 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |    6 +
 17 files changed, 2915 insertions(+), 224 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_flex_pipe.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_flex_pipe.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_flex_type.h

-- 
2.21.0

