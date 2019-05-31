Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC926309F5
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 10:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbfEaIPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 04:15:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:64473 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726386AbfEaIPJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 04:15:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 May 2019 01:15:09 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 31 May 2019 01:15:08 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/13][pull request] Intel Wired LAN Driver Updates 2019-05-31
Date:   Fri, 31 May 2019 01:15:05 -0700
Message-Id: <20190531081518.16430-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to the iavf driver.

Nathan Chancellor converts the use of gnu_printf to printf.

Aleksandr modifies the driver to limit the number of RSS queues to the
number of online CPUs in order to avoid creating misconfigured RSS
queues.

Gustavo A. R. Silva converts a couple of instances where sizeof() can be
replaced with struct_size().

Alice makes the remaining changes to the iavf driver to cleanup all the
old "i40evf" references in the driver to iavf, including the file names
that still contained the old driver reference.  There was no functional
changes made, just cosmetic to reduce any confusion going forward now
that the iavf driver is the virtual function driver for both i40e and
ice drivers.

The following are changes since commit 7b3ed2a137b077bc0967352088b0adb6049eed20:
  Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 40GbE

Aleksandr Loktionov (1):
  iavf: Limiting RSS queues to CPUs

Alice Michael (8):
  iavf: Rename i40e_adminq* files to iavf_adminq*
  iavf: rename i40e functions to be iavf
  iavf: replace i40e variables with iavf
  iavf: rename iavf_status structure flags
  iavf: rename iavf_client.h defines to match driver name
  iavf: change remaining i40e defines to be iavf
  iavf: rename i40e_device to iavf_device
  iavf: update comments and file checks to match iavf

Gustavo A. R. Silva (2):
  iavf: use struct_size() in kzalloc()
  iavf: iavf_client: use struct_size() helper

Nathan Chancellor (1):
  iavf: Use printf instead of gnu_printf for iavf_debug_d

Sergey Nemov (1):
  iavf: change iavf_status_code to iavf_status

 drivers/net/ethernet/intel/iavf/Makefile      |   2 +-
 .../net/ethernet/intel/iavf/i40e_adminq_cmd.h | 530 ------------------
 drivers/net/ethernet/intel/iavf/iavf.h        |   8 +-
 .../iavf/{i40e_adminq.c => iavf_adminq.c}     | 267 ++++-----
 .../iavf/{i40e_adminq.h => iavf_adminq.h}     |  80 +--
 .../net/ethernet/intel/iavf/iavf_adminq_cmd.h | 528 +++++++++++++++++
 drivers/net/ethernet/intel/iavf/iavf_alloc.h  |  17 +-
 drivers/net/ethernet/intel/iavf/iavf_client.c | 127 +++--
 drivers/net/ethernet/intel/iavf/iavf_client.h | 104 ++--
 drivers/net/ethernet/intel/iavf/iavf_common.c | 499 +++++++++--------
 .../net/ethernet/intel/iavf/iavf_ethtool.c    |  12 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  85 +--
 drivers/net/ethernet/intel/iavf/iavf_osdep.h  |   3 +-
 .../net/ethernet/intel/iavf/iavf_prototype.h  |  58 +-
 drivers/net/ethernet/intel/iavf/iavf_status.h | 136 ++---
 drivers/net/ethernet/intel/iavf/iavf_trace.h  |   4 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.c   |  12 +-
 drivers/net/ethernet/intel/iavf/iavf_type.h   |   4 +-
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |  38 +-
 19 files changed, 1259 insertions(+), 1255 deletions(-)
 delete mode 100644 drivers/net/ethernet/intel/iavf/i40e_adminq_cmd.h
 rename drivers/net/ethernet/intel/iavf/{i40e_adminq.c => iavf_adminq.c} (77%)
 rename drivers/net/ethernet/intel/iavf/{i40e_adminq.h => iavf_adminq.h} (58%)
 create mode 100644 drivers/net/ethernet/intel/iavf/iavf_adminq_cmd.h

-- 
2.21.0

