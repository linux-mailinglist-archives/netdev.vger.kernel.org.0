Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E911980ABE
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 13:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbfHDL72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 07:59:28 -0400
Received: from mga05.intel.com ([192.55.52.43]:50580 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726050AbfHDL72 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Aug 2019 07:59:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Aug 2019 04:59:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,345,1559545200"; 
   d="scan'208";a="178602017"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 04 Aug 2019 04:59:28 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 0/8][pull request] 100GbE Intel Wired LAN Driver Updates 2019-08-04
Date:   Sun,  4 Aug 2019 04:59:18 -0700
Message-Id: <20190804115926.31944-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains more updates to fm10k from Jake Keller.

Jake removes the unnecessary initialization of some variables to help
resolve static code checker warnings.  Explicitly return success during
resume, since the value of 'err' is always success.  Fixed a issue with
incrementing a void pointer, which can produce undefined behavior.  Used
the __always_unused macro for function templates that are passed as
parameters in functions, but are not used.  Simplified the code by
removing an unnecessary macro in determining the value of NON_Q_VECTORS.
Fixed an issue, using bitwise operations to prevent the low address
overwriting the high portion of the address.

The following are changes since commit 9e8fb25254f76cb483303d8e9a97ed80a65418fe:
  Merge branch 'net-l3-l4-functional-tests'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Jacob Keller (8):
  fm10k: remove unnecessary variable initializer
  fm10k: remove needless assignment of err local variable
  fm10k: remove needless initialization of size local variable
  fm10k: explicitly return 0 on success path in function
  fm10k: cast page_addr to u8 * when incrementing it
  fm10k: mark unused parameters with __always_unused
  fm10k: convert NON_Q_VECTORS(hw) into NON_Q_VECTORS
  fm10k: fix fm10k_get_fault_pf to read correct address

 drivers/net/ethernet/intel/fm10k/fm10k.h      | 10 +++-----
 .../net/ethernet/intel/fm10k/fm10k_ethtool.c  |  6 ++---
 drivers/net/ethernet/intel/fm10k/fm10k_main.c |  6 ++---
 drivers/net/ethernet/intel/fm10k/fm10k_mbx.c  |  5 ++--
 .../net/ethernet/intel/fm10k/fm10k_netdev.c   | 12 ++++-----
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c  | 11 ++++----
 drivers/net/ethernet/intel/fm10k/fm10k_pf.c   | 12 ++++-----
 drivers/net/ethernet/intel/fm10k/fm10k_tlv.c  |  9 ++++---
 drivers/net/ethernet/intel/fm10k/fm10k_type.h |  2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_vf.c   | 25 +++++++++++--------
 10 files changed, 49 insertions(+), 49 deletions(-)

-- 
2.21.0

