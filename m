Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24252342789
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 22:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbhCSVQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 17:16:35 -0400
Received: from mga18.intel.com ([134.134.136.126]:20600 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230145AbhCSVP7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 17:15:59 -0400
IronPort-SDR: ohSPZ2ALF+UjEIuuyH88wo4rkMXfyg1C1d/9n4JPEaQbEQlSz1ZmjOCaVo5OWTzv6uA6/8AIlf
 QhV7DrTvHAig==
X-IronPort-AV: E=McAfee;i="6000,8403,9928"; a="177554729"
X-IronPort-AV: E=Sophos;i="5.81,262,1610438400"; 
   d="scan'208";a="177554729"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 14:15:57 -0700
IronPort-SDR: r0DBg6mo8oG5VrVhyBJXNa+SRE4yvlwy2dxMmdijZL6ysG2LX3p1w5bUnKV24pVOaiaUKr2KOb
 Lag9KOKv4jiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,262,1610438400"; 
   d="scan'208";a="451005080"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 19 Mar 2021 14:15:57 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        yu.c.chen@intel.com, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next 5/5] e1000e: Mark e1000e_pm_prepare() as __maybe_unused
Date:   Fri, 19 Mar 2021 14:17:23 -0700
Message-Id: <20210319211723.1488244-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210319211723.1488244-1-anthony.l.nguyen@intel.com>
References: <20210319211723.1488244-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

The function e1000e_pm_prepare() may have no callers depending
on configuration, so it must be marked __maybe_unused to avoid
harmless warning:

drivers/net/ethernet/intel/e1000e/netdev.c:6926:12:
 warning: 'e1000e_pm_prepare' defined but not used [-Wunused-function]
 6926 | static int e1000e_pm_prepare(struct device *dev)
      |            ^~~~~~~~~~~~~~~~~

Fixes: ccf8b940e5fd ("e1000e: Leverage direct_complete to speed up s2ram")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 480f6712a3b6..39ca02b7fdc5 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6919,7 +6919,7 @@ static int __e1000_resume(struct pci_dev *pdev)
 	return 0;
 }
 
-static int e1000e_pm_prepare(struct device *dev)
+static __maybe_unused int e1000e_pm_prepare(struct device *dev)
 {
 	return pm_runtime_suspended(dev) &&
 		pm_suspend_via_firmware();
-- 
2.26.2

