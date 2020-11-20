Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31FBE2BB364
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730804AbgKTSdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:33:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:52398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730783AbgKTSde (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:33:34 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08F3922470;
        Fri, 20 Nov 2020 18:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897213;
        bh=GDpxrV235khhu0MZ42ui52syU8pVPLwebIZCCQ4Y+fk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TLsa4OXDzJh6NZmODOPzGcbG4zswE3Yk+TXJQj6dUoFjuUqAW8huXA+i4XK/CNNnU
         v8vF0WYdYwfmVZ64/J4UrrqR+PjND2HlBzMch4Swx7f2jGxW/TDt6HLKuECXGHv/Xf
         wvfsKVFpNB9vn7HwFVXTbmML67UBGJaRXjDaV7tA=
Date:   Fri, 20 Nov 2020 12:33:39 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 065/141] airo: Fix fall-through warnings for Clang
Message-ID: <b3c0f74f5b6e6bff9f1609b310319b6fdd9ee205.1605896059.git.gustavoars@kernel.org>
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
by explicitly adding a break statement instead of letting the code fall
through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/cisco/airo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco/airo.c
index 87b9398b03fd..41a41e18b956 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -7067,6 +7067,7 @@ static int airo_set_power(struct net_device *dev,
 			local->config.rmode &= ~RXMODE_MASK;
 			local->config.rmode |= RXMODE_BC_MC_ADDR;
 			set_bit (FLAG_COMMIT, &local->flags);
+			break;
 		case IW_POWER_ON:
 			/* This is broken, fixme ;-) */
 			break;
-- 
2.27.0

