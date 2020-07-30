Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922012339C2
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 22:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730477AbgG3Uhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 16:37:38 -0400
Received: from mga14.intel.com ([192.55.52.115]:30890 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726838AbgG3Uh2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 16:37:28 -0400
IronPort-SDR: LNG1g3x3yQaVeYAXCRA4GrWC/cKOYY1s9O3vqvV7ndzNq01jJW2Ya1Wlpkl1cBIHU7wS9G3lOL
 JbLmx2e8qUSw==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="150885537"
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="150885537"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 13:37:26 -0700
IronPort-SDR: 5Ff/qpCPJDAtzrDZJYXs4n/Uq3AbXD+7hkw5eYYRMouGr7A6ZApqcmdJC4GJQHW+QsFJPXPoXd
 TXNjIV2S8eOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="274324278"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga008.fm.intel.com with ESMTP; 30 Jul 2020 13:37:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Miaohe Lin <linmiaohe@huawei.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 11/12] ixgbe: use eth_zero_addr() to clear mac address
Date:   Thu, 30 Jul 2020 13:37:19 -0700
Message-Id: <20200730203720.3843018-12-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200730203720.3843018-1-anthony.l.nguyen@intel.com>
References: <20200730203720.3843018-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

Use eth_zero_addr() to clear mac address instead of memset().

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
index 23a92656821d..988db46bff0e 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
@@ -783,7 +783,7 @@ static int ixgbe_set_vf_mac(struct ixgbe_adapter *adapter,
 		memcpy(adapter->vfinfo[vf].vf_mac_addresses, mac_addr,
 		       ETH_ALEN);
 	else
-		memset(adapter->vfinfo[vf].vf_mac_addresses, 0, ETH_ALEN);
+		eth_zero_addr(adapter->vfinfo[vf].vf_mac_addresses);
 
 	return retval;
 }
-- 
2.26.2

