Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70540346861
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 20:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233097AbhCWTBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 15:01:08 -0400
Received: from mga07.intel.com ([134.134.136.100]:10824 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232944AbhCWTA3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 15:00:29 -0400
IronPort-SDR: CHCJ5UehWxX6tvMe9SM13Si86Pku04oakZMlmGBI35g1g9Y1PRwQ5v7Q1jU9wDth1fQPG0Sor1
 2hG7vBccnnwA==
X-IronPort-AV: E=McAfee;i="6000,8403,9932"; a="254545856"
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="254545856"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 12:00:26 -0700
IronPort-SDR: VRC0jWs2P8VYUZvXRURMZ9nUM916q5hlQA/THjhyOMdV8mC3rQP7ROMyVSEACscVOuXUuyyuHY
 8iitOOVxSQOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="381460675"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 23 Mar 2021 12:00:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next 10/10] e1000: Fix fall-through warnings for Clang
Date:   Tue, 23 Mar 2021 12:01:49 -0700
Message-Id: <20210323190149.3160859-11-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210323190149.3160859-1-anthony.l.nguyen@intel.com>
References: <20210323190149.3160859-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
by explicitly adding a break statement instead of just letting the code
fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000/e1000_hw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_hw.c b/drivers/net/ethernet/intel/e1000/e1000_hw.c
index 4c0c9433bd60..19cf36360933 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_hw.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_hw.c
@@ -1183,6 +1183,7 @@ static s32 e1000_copper_link_igp_setup(struct e1000_hw *hw)
 			break;
 		case e1000_ms_auto:
 			phy_data &= ~CR_1000T_MS_ENABLE;
+			break;
 		default:
 			break;
 		}
-- 
2.26.2

