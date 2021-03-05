Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2FE332E40D
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 09:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbhCEI6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 03:58:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:55080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229500AbhCEI5h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 03:57:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 098A964FE6;
        Fri,  5 Mar 2021 08:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614934656;
        bh=vvxVQDPg2LZpf8LGypT9bQ076bkI8NuafNE/kPbFaAU=;
        h=Date:From:To:Cc:Subject:From;
        b=oH20cQKoI+fvxdddMmnDMrABgzGxm5m5pWPj2hGmn34/yhgi3i7r2cUsh3mG/ZsCX
         p4GVfGwAhwmxqx8bFDycdbxBapMxW5k/4Bhblw5L2n59vT6zgex8gqgogCDPSwEAJI
         if/MMb7ofBhkdd6TRqKELEXH0eihwv1HKxh7nOuKOVsB3OcG5IVVl++hcpDwQW2SAW
         Sr+etAMIx5xRZGkFOozZOjCxMAbv9bc0y5JIS9wQyI6TXKy/EQKxdOmzqhrk8/zuHx
         BcWNVnoOS3SR5zcZD+LT4C1ABxUYJeGaUEej+/32JfjxitPrS35d+vdUwaSF6n4oK1
         +CU+qcBnymFvg==
Date:   Fri, 5 Mar 2021 02:57:33 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH RESEND][next] fm10k: Fix fall-through warnings for Clang
Message-ID: <20210305085733.GA138682@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
warnings by explicitly adding a couple of break statements instead of
just letting the code fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/intel/fm10k/fm10k_mbx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c b/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c
index 8e2e92bf3cd4..3e970e20695d 100644
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
2.27.0

