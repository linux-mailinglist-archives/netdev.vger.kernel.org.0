Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC47B01FD
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 18:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729196AbfIKQt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 12:49:58 -0400
Received: from mga14.intel.com ([192.55.52.115]:31944 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728794AbfIKQt5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 12:49:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Sep 2019 09:49:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="179078815"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga008.jf.intel.com with ESMTP; 11 Sep 2019 09:49:57 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net 0/2][pull request] Intel Wired LAN Driver Updates 2019-09-11
Date:   Wed, 11 Sep 2019 09:49:53 -0700
Message-Id: <20190911164955.10644-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains fixes to ixgbe.

Alex fixes up the adaptive ITR scheme for ixgbe which could result in a
value that was either 0 or something less than 10 which was causing
issues with hardware features, like RSC, that do not function well with
ITR values that low.

Ilya Maximets fixes the ixgbe driver to limit the number of transmit
descriptors to clean by the number of transmit descriptors used in the
transmit ring, so that the driver does not try to "double" clean the
same descriptors. 

The following are changes since commit f4b752a6b2708bfdf7fbe8a241082c8104f4ce05:
  mlx4: fix spelling mistake "veify" -> "verify"
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/net-queue 10GbE

Alexander Duyck (1):
  ixgbe: Prevent u8 wrapping of ITR value to something less than 10us

Ilya Maximets (1):
  ixgbe: fix double clean of Tx descriptors with xdp

 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  4 ++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 29 +++++++------------
 2 files changed, 14 insertions(+), 19 deletions(-)

-- 
2.21.0

