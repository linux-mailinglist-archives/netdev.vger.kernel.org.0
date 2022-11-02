Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6CAD616EE4
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 21:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbiKBUk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 16:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbiKBUkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 16:40:23 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9C86444
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 13:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667421619; x=1698957619;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LVStPODhXXrKW8vsUIiWC01UJhtkiUWkcqjlhiqxPvM=;
  b=GN6iZpKMvg7HHmS6RNgumVFQhMKcGcL7tmONDWxLcXukuPsI8PwZYY+4
   Zz06u//7SC+euO/iz+LRuvUcYgAuos/Tp9/N76rO1VYY5ks5aGZiRU3QX
   wmmMU5ggSu8GaPj4TYK4nJcsSu0TprJkb3hA1CHSVjEXfSU3pV339CX78
   VxI33qjL26HNrEIxtaWQUpiYfW+H5+sdYaGoDMUZJdh6v72XNkiG+CmdD
   jRqPdK1pKt6IFfxLmMqJWpxfdvBvDVNPI1ibGxtlUF13d3hNVyEqfMbLt
   pFmDfq6WuOG8C2H5IHrSd4iVzKvsgm7DgY9Cu8ePuCb62ae8aHtU1NfC8
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="336202177"
X-IronPort-AV: E=Sophos;i="5.95,234,1661842800"; 
   d="scan'208";a="336202177"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 13:40:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="612385311"
X-IronPort-AV: E=Sophos;i="5.95,234,1661842800"; 
   d="scan'208";a="612385311"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 02 Nov 2022 13:40:08 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sasha.neftin@intel.com
Subject: [PATCH net-next 0/6][pull request] Intel Wired LAN Driver Updates 2022-11-02 (e1000e, e1000, igc)
Date:   Wed,  2 Nov 2022 13:39:51 -0700
Message-Id: <20221102203957.2944396-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to e1000e, e1000, and igc drivers.

For e1000e, Sasha adds a new board type to help distinguish platforms and
adds device id support for upcoming platforms. He also adds trace points
for CSME flows to aid in debugging.

Ani removes unnecessary kmap_atomic call for e1000 and e1000e.

Muhammad sets speed based transmit offsets for launchtime functionality to
reduce latency for igc.

The following are changes since commit ef2dd61af7366e5a42e828fff04932e32eb0eacc:
  Merge branch 'renesas-eswitch'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE

Anirudh Venkataramanan (2):
  e1000e: Remove unnecessary use of kmap_atomic()
  e1000: Remove unnecessary use of kmap_atomic()

Muhammad Husaini Zulkifli (1):
  igc: Correct the launchtime offset

Sasha Neftin (3):
  e1000e: Separate MTP board type from ADP
  e1000e: Add support for the next LOM generation
  e1000e: Add e1000e trace module

 drivers/net/ethernet/intel/e1000/e1000_main.c |  9 ++--
 drivers/net/ethernet/intel/e1000e/Makefile    |  3 ++
 drivers/net/ethernet/intel/e1000e/e1000.h     |  4 +-
 .../net/ethernet/intel/e1000e/e1000e_trace.h  | 42 +++++++++++++++
 drivers/net/ethernet/intel/e1000e/ethtool.c   |  2 +
 drivers/net/ethernet/intel/e1000e/hw.h        |  9 ++++
 drivers/net/ethernet/intel/e1000e/ich8lan.c   | 27 ++++++++++
 drivers/net/ethernet/intel/e1000e/netdev.c    | 51 ++++++++++---------
 drivers/net/ethernet/intel/e1000e/ptp.c       |  1 +
 drivers/net/ethernet/intel/igc/igc_defines.h  |  9 ++++
 drivers/net/ethernet/intel/igc/igc_main.c     |  7 +++
 drivers/net/ethernet/intel/igc/igc_regs.h     |  1 +
 drivers/net/ethernet/intel/igc/igc_tsn.c      | 30 +++++++++++
 drivers/net/ethernet/intel/igc/igc_tsn.h      |  1 +
 14 files changed, 166 insertions(+), 30 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/e1000e/e1000e_trace.h

-- 
2.35.1

