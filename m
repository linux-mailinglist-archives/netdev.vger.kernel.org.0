Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDB9486BF4
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 22:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244288AbiAFVdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 16:33:41 -0500
Received: from mga06.intel.com ([134.134.136.31]:26402 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244271AbiAFVdl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 16:33:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641504821; x=1673040821;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NMTt4Yx0q1zkEtRIptRCRLajhz+oc8OsO/AZqAC+JsI=;
  b=AWCUy5SBxEfzG6Qca+SfrgeGfJ6YY8dVPZIbmIXNSrdyreQt5W4tmHpi
   y4CXmt1YSeu1vVDxoAjDqUP1NEbQS0yRUmKoZoPQgZznpe6jVyEmoNBXE
   j/YfzrETqdLjPFfZIfKYVPmcqI66PoEoWogrgH0agRx5NOYIZKurZwceZ
   Ttmmq90zyiwv1fA18vXfxvcTFeKKN7e3+FSHNzl9sa0TyPSGHnbIFLVeO
   6RY6G7H+7loQUWP6f3+yF3evLqJILhr//4o3NxoSrtT4u9nrKxmqoj95Z
   v/hZ/tLDrMmDXLRldZgKJrCFX3ADjq24nkGtxiBB1pLmeVkRm1fQBQ20C
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="303490339"
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="303490339"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 13:33:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="611972882"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Jan 2022 13:33:40 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net-next 0/7][pull request] 40GbE Intel Wired LAN Driver Updates 2022-01-06
Date:   Thu,  6 Jan 2022 13:32:54 -0800
Message-Id: <20220106213301.11392-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e and iavf drivers.

Karen limits per VF MAC filters so that one VF does not consume all
filters and adds bookkeeping of VF VLAN filters to properly remove them
for PF trunking for i40e.

Jedrzej reduces busy wait time for admin queue calls for i40e.

Mateusz updates firmware versions to reflect new supported NVM images
and renames an error to remove non-inclusive language for i40e.

Yang Li fixes a set but not used warning for i40e.

Jason Wang removes an unneeded variable for iavf.

The following are changes since commit 710ad98c363a66a0cd8526465426c5c5f8377ee0:
  veth: Do not record rx queue hint in veth_xmit
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE

Jason Wang (1):
  iavf: remove an unneeded variable

Jedrzej Jagielski (1):
  i40e: Minimize amount of busy-waiting during AQ send

Karen Sornek (2):
  i40e: Add ensurance of MacVlan resources for every trusted VF
  i40e: Add placeholder for ndo set VLANs

Mateusz Palczewski (2):
  i40e: Update FW API version
  i40e: Remove non-inclusive language

Yang Li (1):
  i40e: remove variables set but not used

 drivers/net/ethernet/intel/i40e/i40e_adminq.c |  29 +++-
 .../net/ethernet/intel/i40e/i40e_adminq_cmd.h |   4 +-
 drivers/net/ethernet/intel/i40e/i40e_common.c |  15 +-
 .../net/ethernet/intel/i40e/i40e_prototype.h  |  14 +-
 drivers/net/ethernet/intel/i40e/i40e_status.h |   2 +-
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 130 ++++++++++++++++--
 .../ethernet/intel/i40e/i40e_virtchnl_pf.h    |  10 ++
 drivers/net/ethernet/intel/iavf/iavf_adminq.c |   4 +-
 8 files changed, 168 insertions(+), 40 deletions(-)

-- 
2.31.1

