Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849372BB426
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731700AbgKTSlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:41:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:59412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731681AbgKTSlA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:41:00 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 616DE22464;
        Fri, 20 Nov 2020 18:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897660;
        bh=DkGPD/eVIrLGi6gETMe02lyDBLGJSsU1SAzPFlCWzaA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hm9KiHeB+5rgVgUX4zJgnTvpHio6F0Ew08NxyIL0xdcz8j43+uDDTe06iIdicPkvw
         6B8xVz5KBjaE65yn7lkblcQLKfVZX5zywyTEnTBe1N2jdO13b+qfI4vUMfgNPPX6JU
         iS4Kugrt9Oyf/wSNSgZpPN0gs/j9myMvtfv9aBFM=
Date:   Fri, 20 Nov 2020 12:41:05 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 140/141] zd1201: Fix fall-through warnings for Clang
Message-ID: <52931e343af25f6dab4bd1d604889d2594a861dd.1605896060.git.gustavoars@kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1605896059.git.gustavoars@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix a
warning by replacing a /* Fall through */ comment with the new
pseudo-keyword macro fallthrough; instead of letting the code fall
through to the next case.

Notice that Clang doesn't recognize /* Fall through */ comments as
implicit fall-through markings.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/zydas/zd1201.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/zydas/zd1201.c b/drivers/net/wireless/zydas/zd1201.c
index 718c4ee865ba..097805b55c59 100644
--- a/drivers/net/wireless/zydas/zd1201.c
+++ b/drivers/net/wireless/zydas/zd1201.c
@@ -966,7 +966,7 @@ static int zd1201_set_mode(struct net_device *dev,
 			 */
 			zd1201_join(zd, "\0-*#\0", 5);
 			/* Put port in pIBSS */
-			/* Fall through */
+			fallthrough;
 		case 8: /* No pseudo-IBSS in wireless extensions (yet) */
 			porttype = ZD1201_PORTTYPE_PSEUDOIBSS;
 			break;
-- 
2.27.0

