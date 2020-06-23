Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCB12062D7
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391559AbgFWUeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 16:34:36 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:17018 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391551AbgFWUed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 16:34:33 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05NKYMt7019519;
        Tue, 23 Jun 2020 13:34:23 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net 00/12] cxgb4/cxgb4vf: fix warnings reported by sparse
Date:   Wed, 24 Jun 2020 01:51:30 +0530
Message-Id: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of patches fix various warnings reported by the sparse
tool.

Patches 1 and 2 fix lock context imbalance warnings.

Patch 3 fixes cast to restricted __be64 warning when fetching
timestamp in PTP path.

Patch 4 fixes several cast to restricted __be32 warnings in TC-U32
offload parser.

Patch 5 fixes several cast from restricted __be16 warnings in parsing
L4 ports for filters.

Patch 6 fixes several restricted __be32 degrades to integer warnings
when comparing IP address masks for exact-match filters.

Patch 7 fixes cast to restricted __be64 warning when fetching SGE
queue contexts in device dump collection.

Patch 8 fixes cast from restricted __sum16 warning when saving IPv4
partial checksum.

Patch 9 fixes issue with string array scope in DCB path.

Patch 10 fixes a set but unused variable warning when DCB is disabled.

Patch 11 fixes several kernel-doc comment warnings in cxgb4 driver.

Patch 12 fixes several kernel-doc comment warnings in cxgb4vf driver.

Thanks,
Rahul

Rahul Lakkireddy (12):
  cxgb4: move handling L2T ARP failures to caller
  cxgb4: move PTP lock and unlock to caller in Tx path
  cxgb4: use unaligned conversion for fetching timestamp
  cxgb4: parse TC-U32 key values and masks natively
  cxgb4: fix endian conversions for L4 ports in filters
  cxgb4: use correct type for all-mask IP address comparison
  cxgb4: fix SGE queue dump destination buffer context
  cxgb4: remove cast when saving IPv4 partial checksum
  cxgb4: move DCB version extern to header file
  cxgb4: fix set but unused variable when DCB is disabled
  cxgb4: update kernel-doc line comments
  cxgb4vf: update kernel-doc line comments

 .../net/ethernet/chelsio/cxgb4/cudbg_lib.c    |   6 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_dcb.h    |   3 +
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    |   1 -
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    |   2 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_filter.c |  25 ++--
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  11 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_ptp.c    |   3 +-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  |  30 ++---
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c |  18 +--
 .../chelsio/cxgb4/cxgb4_tc_u32_parse.h        | 122 ++++++++++++------
 drivers/net/ethernet/chelsio/cxgb4/l2t.c      |  53 ++++----
 drivers/net/ethernet/chelsio/cxgb4/sched.c    |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c      |  47 +++----
 drivers/net/ethernet/chelsio/cxgb4/smt.c      |   2 +
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c    |  36 +++---
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   |   3 +-
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c    |   7 +-
 .../net/ethernet/chelsio/cxgb4vf/t4vf_hw.c    |   9 +-
 18 files changed, 211 insertions(+), 169 deletions(-)

-- 
2.24.0

