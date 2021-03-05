Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A6932E52E
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 10:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhCEJrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 04:47:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:42190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229551AbhCEJqp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 04:46:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C79C364FE8;
        Fri,  5 Mar 2021 09:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614937604;
        bh=jOhOPnGpy4/jsUIFCgwn/Z7qlNd4zdeoKzMUdRXrl3E=;
        h=Date:From:To:Cc:Subject:From;
        b=J5z0r5zjbV+eQHA1prDi2AwVZ4qKzUGlS/izBiKKnehrhWwSsDiJMUELr1U2RT1yf
         HmLYQtoxwz1RYCyEwn9Ls6rrm5p8Uc256sdVqrajAMIgEvbWzqctefH9c4qTreUsru
         QFqtKanAUFjbgLP2952sKcMTqMnZgrHMPlZXLFyQkb1QWPSZKC0d2W/JV2xHQH3BL7
         N97kd5wrdrnP3f1+MAFUk9/jAlaR8mBqiA/AKtjS8r/WuhOFFieqiVD5ci5jZNkZuN
         qid91No3dbap49DswgBk+rd6mulo4jbgZlbTELe2oBrSUgMCx2+RyTeg9nJj85bVhk
         suQOETPnZEhbA==
Date:   Fri, 5 Mar 2021 03:46:42 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH RESEND][next] ixgbevf: Fix fall-through warnings for Clang
Message-ID: <20210305094642.GA141002@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
by explicitly adding a break statement instead of just letting the code
fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 449d7d5b280d..ba2ed8a43d2d 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -2633,6 +2633,7 @@ static void ixgbevf_set_num_queues(struct ixgbevf_adapter *adapter)
 			adapter->num_rx_queues = rss;
 			adapter->num_tx_queues = rss;
 			adapter->num_xdp_queues = adapter->xdp_prog ? rss : 0;
+			break;
 		default:
 			break;
 		}
-- 
2.27.0

