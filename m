Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 701B96C3B32
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 21:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjCUUDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 16:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbjCUUDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 16:03:23 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF9CD2885C
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 13:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679428949; x=1710964949;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BiTX6YUVrbO2cY1HUJQI0zwNIpPDQRfS8reSQy2N5K0=;
  b=I5QUKro3sIPgJehuKxf5BbikHczevr38RlOPfTX+yKPZ4AiMrsiVbar3
   g6HAgJv1Zc08aYMDMFDP8b3jG+WvqM2kw/NsmrxXw8H3aBEIcib+b9itP
   XZexVmHG/nOcUqPUrN0dGZZS3YrrGi4gi26lcthSbM2CdJkejKM3xTld6
   d9++SGP2yaCi9GMwlHS3SS+2zzxWhfXr1AWwVRvuCSO26+emjpXaqPREt
   Htaa31Lpdq8RMD7iaS8lEmKzCp1u1n3By7KWCB3z1MQDkzQpKscUD03Jm
   4DqBvIDGLqP8FWsIqFPzUiIMwuG+XJFoZEXhEs/WgI/PNCxJGSKLokg3w
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="403934783"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="403934783"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 13:01:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="658911185"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="658911185"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga006.jf.intel.com with ESMTP; 21 Mar 2023 13:01:58 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH net-next 0/3][pull request] Intel Wired LAN Driver Updates 2023-03-21 (igb, igbvf, igc)
Date:   Tue, 21 Mar 2023 13:00:10 -0700
Message-Id: <20230321200013.2866582-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igb, igbvf, and igc drivers.

Andrii changes igb driver to utilize diff_by_scaled_ppm() implementation
over an open-coded version.

Dawid adds pci_error_handlers for reset_prepare and reset_done for
igbvf.

Sasha removes unnecessary code in igc.

The following are changes since commit c8384d4a51e7cb0e6587f3143f29099f202c5de1:
  net: pasemi: Fix return type of pasemi_mac_start_tx()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE

Andrii Staikov (1):
  igb: refactor igb_ptp_adjfine_82580 to use diff_by_scaled_ppm

Dawid Wesierski (1):
  igbvf: add PCI reset handler functions

Sasha Neftin (1):
  igc: Remove obsolete DMA coalescing code

 drivers/net/ethernet/intel/igb/igb_ptp.c     | 11 ++------
 drivers/net/ethernet/intel/igbvf/netdev.c    | 29 ++++++++++++++++++++
 drivers/net/ethernet/intel/igc/igc_defines.h |  3 --
 drivers/net/ethernet/intel/igc/igc_i225.c    | 19 ++++---------
 drivers/net/ethernet/intel/igc/igc_regs.h    |  1 -
 5 files changed, 37 insertions(+), 26 deletions(-)

-- 
2.38.1

