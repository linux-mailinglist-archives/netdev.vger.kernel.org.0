Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048B561EC20
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 08:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbiKGHfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 02:35:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiKGHfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 02:35:17 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E93559E
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 23:35:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667806516; x=1699342516;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VLTeMhwasLe4cCQju+XrCK3A2OODu5BUTEdBqfwfyu4=;
  b=eNWVtNX115y69lHrU9+hhimHNfkDkrFPhlJbTsDS2jH9rwhe8A3O0dG5
   1GfrPJ4VWNLku4aU8GM7gFK51K7cZ2m4I/I6sdTl5k70q+6+3geuTidM2
   VcYKaJEQR8Q+nkfamnj/NIiuCwEX/m1J6sSOQh5Uz1nw5SJI8JFQakAd1
   DCCINa4wuhh+yayUZXUz9Fqvn4WWP7pNq9B4MXSmbA/a21xbY1Uoh7brA
   iIhN8V5aSBmpgkl8dBgXuIjzQXrhUeZV7eFgcLTkEW9nzOWWFM1w9in9P
   vrrfC1y+eeVSIhZlVtpG9WJnXV1FocPg1np0TDLOzMWlqEpklSeJSHQfH
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="337064195"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="337064195"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2022 23:35:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="586878029"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="586878029"
Received: from bswcg005.iind.intel.com ([10.224.174.25])
  by orsmga003.jf.intel.com with ESMTP; 06 Nov 2022 23:35:12 -0800
From:   m.chetan.kumar@linux.intel.com
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, edumazet@google.com, pabeni@redhat.com,
        linuxwwan@intel.com,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Subject: [PATCH net V2 0/4] net: wwan: iosm: fixes
Date:   Mon,  7 Nov 2022 13:04:14 +0530
Message-Id: <20221107073414.1978162-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

This patch series contains iosm fixes.

PATCH1: Fix memory leak in ipc_pcie_read_bios_cfg.

PATCH2: Fix driver not working with INTEL_IOMMU disabled config.

PATCH3: Fix invalid mux header type.

PATCH4: Fix kernel build robot reported errors.

Please refer to individual commit message for details.

--
v2:
 * PATCH1: No Change
 * PATCH2: Kconfig change
           - Add dependency on PCI to resolve kernel build robot errors.
 * PATCH3: No Change
 * PATCH4: New (Fix kernel build robot errors)

M Chetan Kumar (4):
  net: wwan: iosm: fix memory leak in ipc_pcie_read_bios_cfg
  net: wwan: iosm: fix driver not working with INTEL_IOMMU disabled
  net: wwan: iosm: fix invalid mux header type
  net: wwan: iosm: fix kernel test robot reported errors

 drivers/net/wwan/Kconfig                  |  2 +-
 drivers/net/wwan/iosm/iosm_ipc_coredump.c |  1 +
 drivers/net/wwan/iosm/iosm_ipc_devlink.c  |  1 +
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c |  8 ++++++++
 drivers/net/wwan/iosm/iosm_ipc_mux.h      |  1 +
 drivers/net/wwan/iosm/iosm_ipc_pcie.c     | 18 +++++++++++++++---
 6 files changed, 27 insertions(+), 4 deletions(-)

--
2.34.1

