Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0C79B1BAC
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 12:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387619AbfIMKmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 06:42:21 -0400
Received: from mga06.intel.com ([134.134.136.31]:8384 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387512AbfIMKmV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 06:42:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Sep 2019 03:42:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="187784045"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.223.65])
  by orsmga003.jf.intel.com with ESMTP; 13 Sep 2019 03:42:17 -0700
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Cc:     bruce.richardson@intel.com, bpf@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, kevin.laatz@intel.com,
        Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf-next v2 0/3] AF_XDP fixes for i40e, ixgbe and xdpsock
Date:   Fri, 13 Sep 2019 10:39:45 +0000
Message-Id: <20190913103948.32053-1-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set contains some fixes for AF_XDP zero copy in the i40e and
ixgbe drivers as well as a fix for the 'xdpsock' sample application when
running in unaligned mode.

Patches 1 and 2 fix a regression for the i40e and ixgbe drivers which
caused the umem headroom to be added to the xdp handle twice, resulting in
an incorrect value being received by the user for the case where the umem
headroom is non-zero.

Patch 3 fixes an issue with the xdpsock sample application whereby the
start of the tx packet data (offset) was not being set correctly when the
application was being run in unaligned mode.

This patch set has been applied against commit a2c11b034142 ("kcm: use
BPF_PROG_RUN")

---
v2:
- Rearranged local variable order in i40e_run_xdp_zc and ixgbe_run_xdp_zc
to comply with coding standards.

Ciara Loftus (3):
  i40e: fix xdp handle calculations
  ixgbe: fix xdp handle calculations
  samples/bpf: fix xdpsock l2fwd tx for unaligned mode

 drivers/net/ethernet/intel/i40e/i40e_xsk.c   | 4 ++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 4 ++--
 samples/bpf/xdpsock_user.c                   | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

-- 
2.17.1

