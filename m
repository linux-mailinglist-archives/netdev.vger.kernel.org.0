Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959F7369742
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 18:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbhDWQl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 12:41:28 -0400
Received: from mga17.intel.com ([192.55.52.151]:13567 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229691AbhDWQl2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 12:41:28 -0400
IronPort-SDR: Ac3cRIExJxKV3W7ZvlCfqIZQ40KW+3cwfopok53I469ZRHa5fv/63kuPVThPbHUek26yBr00dp
 B16FMo7hzBlg==
X-IronPort-AV: E=McAfee;i="6200,9189,9963"; a="176218632"
X-IronPort-AV: E=Sophos;i="5.82,246,1613462400"; 
   d="scan'208";a="176218632"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2021 09:40:51 -0700
IronPort-SDR: 5EoKGvwRMs4Y1s9Oy8eN1n2WR2/r1Hq6f9BSIxeItaZ+c8sM3uDfg1+3Ybm156mbZZ13IracYr
 jgVz/7MJcNXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,246,1613462400"; 
   d="scan'208";a="456285954"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 23 Apr 2021 09:40:51 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net-next 0/8][pull request] 40GbE Intel Wired LAN Driver Updates 2021-04-23
Date:   Fri, 23 Apr 2021 09:42:39 -0700
Message-Id: <20210423164247.3252913-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e and iavf drivers.

Aleksandr adds support for VIRTCHNL_VF_CAP_ADV_LINK_SPEED in i40e which
allows for reporting link speed to VF as a value instead of using an
enum; helper functions are created to remove repeated code.

Coiby Xu reduces memory use of i40e when using kdump by reducing Tx, Rx,
and admin queue to minimum values. Current use causes failure of kdump.

Stefan Assmann removes duplicated free calls in iavf.

Haiyue cleans up a loop to return directly when if the value is found
and changes some magic numbers to defines for better maintainability
in iavf.

The following are changes since commit cad4162a90aeff737a16c0286987f51e927f003a:
  Merge branch 'stmmac-swmac-desc-prefetch'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE

Aleksandr Loktionov (1):
  i40e: refactor repeated link state reporting code

Coiby Xu (3):
  i40e: use minimal Tx and Rx pairs for kdump
  i40e: use minimal Rx and Tx ring buffers for kdump
  i40e: use minimal admin queue for kdump

Haiyue Wang (3):
  iavf: change the flex-byte support number to macro definition
  iavf: enhance the duplicated FDIR list scan handling
  iavf: redefine the magic number for FDIR GTP-U header fields

Stefan Assmann (1):
  iavf: remove duplicate free resources calls

 drivers/net/ethernet/intel/i40e/i40e.h        |   2 +
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  23 +++-
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 108 +++++++++++-------
 .../net/ethernet/intel/iavf/iavf_ethtool.c    |   2 +-
 drivers/net/ethernet/intel/iavf/iavf_fdir.c   |  24 ++--
 drivers/net/ethernet/intel/iavf/iavf_fdir.h   |   9 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   |   2 -
 7 files changed, 115 insertions(+), 55 deletions(-)

-- 
2.26.2

