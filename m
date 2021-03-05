Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82BFC32E54B
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 10:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbhCEJva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 04:51:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:43080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229730AbhCEJvP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 04:51:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEA8064FE8;
        Fri,  5 Mar 2021 09:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614937874;
        bh=NeHeQJmUla3vmR7XyOy4O+i4tOPT/mQV3ZB26CkYB+k=;
        h=Date:From:To:Cc:Subject:From;
        b=jEYSdslz67T2R6ea1N5zqE2LhoHiz/UA8GWmRRLo7ssGD+mJFgFdn2CcLyTk/IBNI
         ftxb0GWclDUwmavpOwJY7bgkcqlK5o843aKsnmbxRNITMQfrfGUlUT0g5ATcbF2yn3
         jF6hAHti5maoI949Y03oEzi2h6rB513HsDJEfRWbLdVnQ3F4YVx0XJLfK6U91aQTV1
         ddyG3V6disHPgXmI5czbc6qp2ArYzaLXnh0eHgu/uPN/Gpn5WC0S44RnBzbRwaN7V/
         eIF+qQmd3c8SesYpKvUZLjEm7/0RXcvESDSvuZ8L80fLWg02NBBAn8RDBL41jGBXsv
         T560eE0nrUXBw==
Date:   Fri, 5 Mar 2021 03:51:11 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH RESEND][next] e1000: Fix fall-through warnings for Clang
Message-ID: <20210305095111.GA141480@embeddedor>
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
2.27.0

