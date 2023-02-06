Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0F5368CAD5
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 00:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbjBFX5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 18:57:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjBFX5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 18:57:02 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C3B41B324
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 15:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675727821; x=1707263821;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/PvHh9Sxqrlk1ADJGmma028nImNw9ufm8/6RSIEN98A=;
  b=W21Q6fphO7G0sYxerYhV+eEA39CXwoD356vbPxS7PENP2V/T0vRP+loV
   RME5op+3JtnP5a0v7QWdzb5WjCh52nHKbz5O+hs8ZD0aV0X8n07LJhxUD
   +zI1+c7ZU2BLQjFBG4f66OpNvFEPK4z89/7+HU0kcV87EP4MUK23j644A
   eYkrO6zMo+vN/LU4HEIomKbk/Vx4ZftmSNS4lxBPH+1+TGNjQ8vyqi0HK
   6pNXkTE4vHAsWdLzublWx1DzNiubOk9854PIDqIdN2vUTGwM7BEegJkhW
   nQuRFKPhYgX9VGPT1bb3Rhv2ahjTOYquEMmYYzngwQg1nj88xvQV+gfzh
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="327034342"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="327034342"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 15:57:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="616606962"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="616606962"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga003.jf.intel.com with ESMTP; 06 Feb 2023 15:57:00 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/6][pull request] Intel Wired LAN Driver Updates 2023-02-06 (i40e)
Date:   Mon,  6 Feb 2023 15:56:29 -0800
Message-Id: <20230206235635.662263-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e driver only.

Sebastian adds implementation to control source pruning for VFs.

Jan removes i40e_status from the driver; replacing them with standard
kernel error codes.

Kees Cook replaces 0-length array with flexible array.

The following are changes since commit c21adf256f8dcfbc07436d45be4ba2edf7a6f463:
  Merge branch 'tuntap-socket-uid'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE

Jan Sokolowski (4):
  i40e: Remove unused i40e status codes
  i40e: Remove string printing for i40e_status
  i40e: use int for i40e_status
  i40e: use ERR_PTR error print in i40e messages

Kees Cook (1):
  net/i40e: Replace 0-length array with flexible array

Sebastian Czapla (1):
  i40e: Add flag for disabling VF source pruning

 drivers/net/ethernet/intel/i40e/i40e.h        |   10 +-
 drivers/net/ethernet/intel/i40e/i40e_adminq.c |   68 +-
 drivers/net/ethernet/intel/i40e/i40e_alloc.h  |   22 +-
 drivers/net/ethernet/intel/i40e/i40e_client.c |   12 +-
 drivers/net/ethernet/intel/i40e/i40e_common.c | 1038 +++++++----------
 drivers/net/ethernet/intel/i40e/i40e_dcb.c    |   60 +-
 drivers/net/ethernet/intel/i40e/i40e_dcb.h    |   28 +-
 drivers/net/ethernet/intel/i40e/i40e_dcb_nl.c |   16 +-
 drivers/net/ethernet/intel/i40e/i40e_ddp.c    |   14 +-
 .../net/ethernet/intel/i40e/i40e_debugfs.c    |    8 +-
 drivers/net/ethernet/intel/i40e/i40e_diag.c   |   12 +-
 drivers/net/ethernet/intel/i40e/i40e_diag.h   |    4 +-
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |   78 +-
 drivers/net/ethernet/intel/i40e/i40e_hmc.c    |   56 +-
 drivers/net/ethernet/intel/i40e/i40e_hmc.h    |   46 +-
 .../net/ethernet/intel/i40e/i40e_lan_hmc.c    |   94 +-
 .../net/ethernet/intel/i40e/i40e_lan_hmc.h    |   34 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  467 ++++----
 drivers/net/ethernet/intel/i40e/i40e_nvm.c    |  252 ++--
 drivers/net/ethernet/intel/i40e/i40e_osdep.h  |    1 -
 .../net/ethernet/intel/i40e/i40e_prototype.h  |  643 +++++-----
 drivers/net/ethernet/intel/i40e/i40e_status.h |   35 -
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    |  160 ++-
 .../ethernet/intel/i40e/i40e_virtchnl_pf.h    |    2 +
 24 files changed, 1555 insertions(+), 1605 deletions(-)

-- 
2.38.1

