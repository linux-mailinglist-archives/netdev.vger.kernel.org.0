Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE043ABA1F
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 18:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbhFQRBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 13:01:21 -0400
Received: from mga18.intel.com ([134.134.136.126]:63633 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231488AbhFQRBR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 13:01:17 -0400
IronPort-SDR: LknDxFcGafLMjwIAyi7iwlXrPZUNXV5KrElCX+vvgKkGX5A538SuQltdazDDftJmstkV+vqgg3
 YbgKErmmhzNw==
X-IronPort-AV: E=McAfee;i="6200,9189,10018"; a="193723048"
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="193723048"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 09:59:05 -0700
IronPort-SDR: HCd2VQB0H2X1Lyzcg9j3BnWD4gKZp4PTtVTwKEmJWHkqqOpwXSrZf5sMaH61pzJXBDHesPngLX
 zMnfjJ7rcuPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="404706814"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 17 Jun 2021 09:59:04 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net-next 7/8] net: ice: ptp: fix compilation warning if PTP_1588_CLOCK is disabled
Date:   Thu, 17 Jun 2021 10:01:44 -0700
Message-Id: <20210617170145.4092904-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210617170145.4092904-1-anthony.l.nguyen@intel.com>
References: <20210617170145.4092904-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Fix the following compilation warning if PTP_1588_CLOCK is not enabled

drivers/net/ethernet/intel/ice/ice_ptp.h:149:1:
   error: return type defaults to ‘int’ [-Werror=return-type]
   ice_ptp_request_ts(struct ice_ptp_tx *tx, struct sk_buff *skb)

Fixes: ea9b847cda647 ("ice: enable transmit timestamps for E810 devices")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
index 41e14f98f0e6..d01507eba036 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
@@ -145,7 +145,7 @@ static inline int ice_get_ptp_clock_index(struct ice_pf *pf)
 	return -1;
 }
 
-static inline
+static inline s8
 ice_ptp_request_ts(struct ice_ptp_tx *tx, struct sk_buff *skb)
 {
 	return -1;
-- 
2.26.2

