Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C844C2BB32A
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730509AbgKTSac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:30:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:50094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730103AbgKTSab (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:30:31 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 708EB2224C;
        Fri, 20 Nov 2020 18:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897031;
        bh=Mi6Etvvh4r8mrSIwrdOuNeq4lh4mbEd6eeO+cjJCRNI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dp/gcwZ7u7UzGFJihJ5G0NqXL5pRmOBHXbE0pha2rJNJovIh6zR6ZTvlUDtHu9MRW
         6UxNV1bi8+QCJUqprL59djGc2XXxmK4JI7ZjjNJvahvg+Qm8JP4b2LrhIlo/fyRn/d
         OaKbroMS6/McMeg8UAEoAFntPqKhz63LwrympvI0=
Date:   Fri, 20 Nov 2020 12:30:36 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 039/141] ixgbevf: Fix fall-through warnings for Clang
Message-ID: <cec560b39c59d4c6b854fbe534cbe77050d097a8.1605896059.git.gustavoars@kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1605896059.git.gustavoars@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
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
index 82fce27f682b..afab78c51be0 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -2639,6 +2639,7 @@ static void ixgbevf_set_num_queues(struct ixgbevf_adapter *adapter)
 			adapter->num_rx_queues = rss;
 			adapter->num_tx_queues = rss;
 			adapter->num_xdp_queues = adapter->xdp_prog ? rss : 0;
+			break;
 		default:
 			break;
 		}
-- 
2.27.0

