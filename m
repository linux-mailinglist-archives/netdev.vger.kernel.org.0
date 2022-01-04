Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF474484AD5
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 23:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235667AbiADWjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 17:39:22 -0500
Received: from mga12.intel.com ([192.55.52.136]:28280 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235613AbiADWjV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 17:39:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641335961; x=1672871961;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=X+q9vKPwo2dpGjR3oKglcqRb2YthA79k+InwK2rlVGU=;
  b=krPn937V8dABvF3N8fbEyqbqllxTGoEeADYq2imJlnDeHwj67cL9FMl2
   v/gyiWQMWMWM8eLsuhmjmFol6l9CY6aw6AFbJZo7PA7kt/cSbjO/nL+qq
   JunIwMWaVdVI+rguSDilxjfr2WO7zBNHCLK4nwiI5XlHvK5ELLAmiJ+Y1
   OWd6OBpPKv0I/hrQ9Fwd98J0cBl+FeF8aTq/12AWyzw87iRLOP6xDU81g
   pLDLPy98+4mwy+iwX+o7BY60SJGpbbm/Je5n9/vW2hXlGYaYfhG8DMJbU
   wUos3gEvRXl7r8SJcdmQ4sdFEOs9t+4ZhBjKkJy4lQzen3WRU23byPwiH
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="222305227"
X-IronPort-AV: E=Sophos;i="5.88,262,1635231600"; 
   d="scan'208";a="222305227"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2022 14:39:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,262,1635231600"; 
   d="scan'208";a="470312793"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 04 Jan 2022 14:39:20 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net 0/5][pull request] Intel Wired LAN Driver Updates 2022-01-04
Date:   Tue,  4 Jan 2022 14:38:37 -0800
Message-Id: <20220104223842.2325297-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e and iavf drivers.

Mateusz adjusts displaying of failed VF MAC message when the failure is
expected as well as modifying an NVM info message to not confuse the user
for i40e.

Di Zhu fixes a use-after-free issue MAC filters for i40e.

Jedrzej fixes an issue with misreporting of Rx and Tx queues during
reinitialization for i40e.

Karen correct checking of channel queue configuration to occur against
active queues for iavf.

The following are changes since commit 6f89ecf10af1396ddc34c303ae1168a11f3f04a3:
  Merge tag 'mac80211-for-net-2022-01-04' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Di Zhu (1):
  i40e: fix use-after-free in i40e_sync_filters_subtask()

Jedrzej Jagielski (1):
  i40e: Fix incorrect netdev's real number of RX/TX queues

Karen Sornek (1):
  iavf: Fix limit of total number of queues to active queues of VF

Mateusz Palczewski (2):
  i40e: Fix to not show opcode msg on unsuccessful VF MAC change
  i40e: Fix for displaying message regarding NVM version

 drivers/net/ethernet/intel/i40e/i40e_main.c   | 60 ++++++++++++++++---
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 40 ++++++++++---
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  5 +-
 3 files changed, 87 insertions(+), 18 deletions(-)

-- 
2.31.1

