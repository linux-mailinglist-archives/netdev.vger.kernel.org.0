Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F7F3A825F
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 16:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhFOORa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 10:17:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:44564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231535AbhFOOQV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 10:16:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 493926140B;
        Tue, 15 Jun 2021 14:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623766457;
        bh=DU7+2tE+20fTRy5uTfgHapES/QrTudbXvjgI8inUDDA=;
        h=From:To:Cc:Subject:Date:From;
        b=oV3kgriqXLz8QZrqlxY1hSQ2QoOamREkuHF8BN+LZ7YjWChUqTzfEafWPZQj87y1p
         DWpMZgv0ymi9yvhCgvFFuKxt9Nh50bqhytigSytlIFM7vbtuXLakH//ceiFwUSPtpb
         DihLcz0CProKHz+qEhkk4t6QdpcmOcIeiNR1GMfcCDAnDGtgVDQZuQoHJ0fbkbP1hh
         Q7OrNRNHF1Yu2jVbcfOL1FBAl1jVi0XcSH1GYfj7WopjJiuY72qucPqB24XG8C3ntC
         7oDur62Q887D/KF8LkO24+kfwE4S4vzX4yW9yH9cpo+nM1CwV/OQLafgwPYDwNFtvY
         cAUFRXcX2jY/Q==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, jacob.e.keller@intel.com
Subject: [PATCH net-next] net: ice: ptp: fix compilation warning if PTP_1588_CLOCK is disabled
Date:   Tue, 15 Jun 2021 16:14:12 +0200
Message-Id: <a4d2c3cd609708de38ca59b75e4eb7468750af47.1623766418.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following compilation warning if PTP_1588_CLOCK is not enabled

drivers/net/ethernet/intel/ice/ice_ptp.h:149:1:
   error: return type defaults to ‘int’ [-Werror=return-type]
   ice_ptp_request_ts(struct ice_ptp_tx *tx, struct sk_buff *skb)

Fixes: ea9b847cda647 ("ice: enable transmit timestamps for E810 devices")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
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
2.31.1

