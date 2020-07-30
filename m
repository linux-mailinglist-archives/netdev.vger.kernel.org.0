Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2FD92339C0
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 22:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730464AbgG3Uha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 16:37:30 -0400
Received: from mga14.intel.com ([192.55.52.115]:30885 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730419AbgG3Uh2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 16:37:28 -0400
IronPort-SDR: Q9YMHmjVdbp8GTstNOAme/BxIF02rn9wmXmlwu84wyS4/a64ab3zoAZbFpz11HVb3P/wIp1E1c
 3i5eUpqj1yRw==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="150885538"
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="150885538"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 13:37:26 -0700
IronPort-SDR: wZFo1j/IlbDzsXws0dAELHjPBgJEMa2Olm8eb9SIv6ZSEwksShTGk02k1AfUp/OoESLEs8V+Fk
 RWmsXGnnKoHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="274324281"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga008.fm.intel.com with ESMTP; 30 Jul 2020 13:37:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Miaohe Lin <linmiaohe@huawei.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 12/12] igb: use eth_zero_addr() to clear mac address
Date:   Thu, 30 Jul 2020 13:37:20 -0700
Message-Id: <20200730203720.3843018-13-anthony.l.nguyen@intel.com>
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
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index ae8d64324619..b97916b91aba 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -7159,7 +7159,7 @@ static void igb_flush_mac_table(struct igb_adapter *adapter)
 
 	for (i = 0; i < hw->mac.rar_entry_count; i++) {
 		adapter->mac_table[i].state &= ~IGB_MAC_STATE_IN_USE;
-		memset(adapter->mac_table[i].addr, 0, ETH_ALEN);
+		eth_zero_addr(adapter->mac_table[i].addr);
 		adapter->mac_table[i].queue = 0;
 		igb_rar_set_index(adapter, i);
 	}
@@ -7308,7 +7308,7 @@ static int igb_del_mac_filter_flags(struct igb_adapter *adapter,
 		} else {
 			adapter->mac_table[i].state = 0;
 			adapter->mac_table[i].queue = 0;
-			memset(adapter->mac_table[i].addr, 0, ETH_ALEN);
+			eth_zero_addr(adapter->mac_table[i].addr);
 		}
 
 		igb_rar_set_index(adapter, i);
-- 
2.26.2

