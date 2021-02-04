Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E255330E8E3
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 01:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234559AbhBDAr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 19:47:57 -0500
Received: from mga11.intel.com ([192.55.52.93]:40083 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234583AbhBDApc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 19:45:32 -0500
IronPort-SDR: Lb/ZATXfvqB/eRUT1ADKxIdizieBDYmFrj7G8+Bv107EXA8JBtXFQ5c3rvE67QylTdQwG/J2Ka
 zLg5xMfoSYjg==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="177638240"
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="177638240"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 16:42:15 -0800
IronPort-SDR: ++4gPz5MFHLEvLvMZH6r2ydQlYIxTFYcOQLDETM31w0W/cHu/+AEGvkDVGOey71rYQmWhm7Wb1
 gzv2bCLxKpew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="579687525"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 03 Feb 2021 16:42:15 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH net-next 15/15] e1000: drop unneeded assignment in e1000_set_itr()
Date:   Wed,  3 Feb 2021 16:42:59 -0800
Message-Id: <20210204004259.3662059-16-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210204004259.3662059-1-anthony.l.nguyen@intel.com>
References: <20210204004259.3662059-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>

The variable 'current_itr' is assigned to 0 before jumping to
'set_itr_now' but it has not been used after the jump. So, remove the
unneeded assignment.

Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Reviewed-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000/e1000_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 5e28cf4fa2cd..042de276e632 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -2632,7 +2632,6 @@ static void e1000_set_itr(struct e1000_adapter *adapter)
 
 	/* for non-gigabit speeds, just fix the interrupt rate at 4000 */
 	if (unlikely(adapter->link_speed != SPEED_1000)) {
-		current_itr = 0;
 		new_itr = 4000;
 		goto set_itr_now;
 	}
-- 
2.26.2

