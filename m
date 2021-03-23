Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F27BB346859
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 20:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbhCWTA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 15:00:57 -0400
Received: from mga07.intel.com ([134.134.136.100]:10824 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232900AbhCWTA1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 15:00:27 -0400
IronPort-SDR: tunmgJUP8JPqwB3u5c8bADz1zXsDlP7X0L2J5f0oYsdlY79tuGtUXwPliSl23BQneWPOmVVQes
 k2gEODuMcsRQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9932"; a="254545850"
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="254545850"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 12:00:25 -0700
IronPort-SDR: u0SAjgUJck94sJzTAhWZZ6xDw08dPe4/gyNlXumRVOFfgwD5kf0fMLzQBnOPCjqgZ2XuYRgnL4
 fT2psgaNZ6ag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="381460661"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 23 Mar 2021 12:00:24 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next 06/10] fm10k: Fix fall-through warnings for Clang
Date:   Tue, 23 Mar 2021 12:01:45 -0700
Message-Id: <20210323190149.3160859-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210323190149.3160859-1-anthony.l.nguyen@intel.com>
References: <20210323190149.3160859-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
warnings by explicitly adding a couple of break statements instead of
just letting the code fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/fm10k/fm10k_mbx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c b/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c
index a2642b9b3602..30ca9ee1900b 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c
@@ -1039,6 +1039,7 @@ static s32 fm10k_mbx_create_reply(struct fm10k_hw *hw,
 	case FM10K_STATE_CLOSED:
 		/* generate new header based on data */
 		fm10k_mbx_create_disconnect_hdr(mbx);
+		break;
 	default:
 		break;
 	}
@@ -2017,6 +2018,7 @@ static s32 fm10k_sm_mbx_process_reset(struct fm10k_hw *hw,
 	case FM10K_STATE_CONNECT:
 		/* Update remote value to match local value */
 		mbx->remote = mbx->local;
+		break;
 	default:
 		break;
 	}
-- 
2.26.2

