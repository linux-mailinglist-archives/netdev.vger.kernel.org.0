Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83EAF32E3F9
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 09:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbhCEIxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 03:53:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:53870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229493AbhCEIxA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 03:53:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C3A264DE8;
        Fri,  5 Mar 2021 08:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614934380;
        bh=0K5gEXyiena0MlzGojgi19OmF18QgKL8tbUhZJGMau0=;
        h=Date:From:To:Cc:Subject:From;
        b=CSlU89qrCCkyru9O2mSXJ47yjCEREClQLKFyfeiDd3RjLLNEZzjs841th6ADz9nPg
         nscjWQfVNAR3BTLytPULQN81TVsTkRlKeSlblxq1wpycAGuHlj8zhNwUczvC4Ym+xa
         Xi5//86R9U+YGm3Ml7OJZ3jjcb8lzpk4dQkAzqZ49sqAboN7qZSZi9DNzU1XUOtv4M
         rGrakwKsf2HfyH+3fGWQNgeKorTZW70EDHKWWsS1c8KR8d/1CsABbyXsCW9jXIMh5u
         DxRFlT6OpJw2bQnnU9SJfmq+ZlaOogzP1+sHBXVG/OI1YMRHZNcDr0P/7AOQoypKBw
         4WCM0xO9sywoA==
Date:   Fri, 5 Mar 2021 02:52:57 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH RESEND][next] ice: Fix fall-through warnings for Clang
Message-ID: <20210305085257.GA138498@embeddedor>
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
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 02b12736ea80..207f6ee3a7f6 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -143,6 +143,7 @@ ice_rx_csum(struct ice_ring *ring, struct sk_buff *skb,
 	case ICE_RX_PTYPE_INNER_PROT_UDP:
 	case ICE_RX_PTYPE_INNER_PROT_SCTP:
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
+		break;
 	default:
 		break;
 	}
-- 
2.27.0

