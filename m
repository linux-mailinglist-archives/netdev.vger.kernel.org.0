Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA5E7495728
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 01:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378307AbiAUADc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 19:03:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:55926 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233910AbiAUADb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 19:03:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642723411; x=1674259411;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=h7RZ0J/AGinq4f6AFLwSV5+mqwLLNUpGS5v8IM7qPPw=;
  b=JYrku1dfHShWz5m888D8LhA5O82h1DUi8u+g3c6lZutwKz5lqwSlipE6
   n0+Gwf02wbTO9RKSHQFv0N0dKhjdSBlYjmbgYi3SIDBUD5WxcwWSUiIo1
   L7W19/LUbv9Y1MNXQeTE3FLAPg7RccZCz97dXRXegXiByeeaVbHYkMRdM
   O3+Y33RdV5CfBC6Vwd5M7HQEILsdwbmVQYKlyMFblGrKw1uRQXxZiU+Zj
   +PNJr85geJyMbaRs8Gc5oZcFdywXe839/I3rcKojKLi/zkuqtYHEvJguc
   6sN3TYpmbsZ+59uICkRXrRab/T0WpbYhzHmWRR8b+9nUobhO63vglqT+z
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10233"; a="232879173"
X-IronPort-AV: E=Sophos;i="5.88,303,1635231600"; 
   d="scan'208";a="232879173"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2022 16:03:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,303,1635231600"; 
   d="scan'208";a="478015659"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 20 Jan 2022 16:03:30 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net 0/5][pull request] Intel Wired LAN Driver Updates 2022-01-20
Date:   Thu, 20 Jan 2022 16:03:00 -0800
Message-Id: <20220121000305.1423587-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e driver only.

Jedrzej increases delay for EMP reset and adds checks to ensure a VF
request to change queues can be met.

Sylwester moves the placement of the Flow Director queue as to not
fragment the queue pile which would cause later re-allocation issues.

Karen prevents VF reset being invoked while another is still occurring
to avoid reading invalid data.

Joe Damato fixes some statistics fields to match the values of the
fields they are based on.

The following are changes since commit 57afdc0aab094b4c811b3fe030b2567812a495f3:
  Merge branch 'stmmac-fixes'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Jedrzej Jagielski (2):
  i40e: Increase delay to 1 s after global EMP reset
  i40e: Fix issue when maximum queues is exceeded

Joe Damato (1):
  i40e: fix unsigned stat widths

Karen Sornek (1):
  i40e: Fix for failed to init adminq while VF reset

Sylwester Dziedziuch (1):
  i40e: Fix queues reservation for XDP

 drivers/net/ethernet/intel/i40e/i40e.h        |   9 +-
 .../net/ethernet/intel/i40e/i40e_debugfs.c    |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  44 ++++----
 .../net/ethernet/intel/i40e/i40e_register.h   |   3 +
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 103 +++++++++++++++++-
 .../ethernet/intel/i40e/i40e_virtchnl_pf.h    |   1 +
 6 files changed, 131 insertions(+), 31 deletions(-)

-- 
2.31.1

