Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22BF2BB420
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731157AbgKTSkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:40:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:58696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731658AbgKTSko (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:40:44 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7294A22464;
        Fri, 20 Nov 2020 18:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897644;
        bh=GXU4AgXMBqPQpSCaCSed3HmvRQBli2f8mKyjPp8T+q0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oKioQg4ef1sKf6vVKGKs9/eFAtsmQQ1lBd2ckWXfmVVzTz+m6M0f181SFKMM99DOH
         8sXvM2FxvFFbE64OUupYFHcSNyfGTUIQwsNoA1BfcrGT+s51LUk+jp77+ovtSm7DSO
         uBtP6DZWBkVdXLXXZ4CLPo64ogEW9coXMoT/Z+JY=
Date:   Fri, 20 Nov 2020 12:40:49 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 137/141] wcn36xx: Fix fall-through warnings for Clang
Message-ID: <f932c887e013767cbdabfdddd671086e8ae63193.1605896060.git.gustavoars@kernel.org>
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
warning by replacing a /* fall through */ comment with the new
pseudo-keyword macro fallthrough; instead of letting the code fall
through to the next case.

Notice that Clang doesn't recognize /* fall through */ comments as
implicit fall-through markings.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 766400f7b61c..4c8f4a7e7085 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -2568,7 +2568,7 @@ static int wcn36xx_smd_hw_scan_ind(struct wcn36xx *wcn, void *buf, size_t len)
 	case WCN36XX_HAL_SCAN_IND_FAILED:
 	case WCN36XX_HAL_SCAN_IND_DEQUEUED:
 		scan_info.aborted = true;
-		/* fall through */
+		fallthrough;
 	case WCN36XX_HAL_SCAN_IND_COMPLETED:
 		mutex_lock(&wcn->scan_lock);
 		wcn->scan_req = NULL;
-- 
2.27.0

