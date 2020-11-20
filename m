Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA792BB3DD
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731400AbgKTSjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:39:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:57338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731125AbgKTSi7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:38:59 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 377E92242B;
        Fri, 20 Nov 2020 18:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897539;
        bh=+cUDEbRC/tC/zUJPpQxbuagMeIwMosTrk8/jy3cx7ac=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RUHDjwNRNbSilV7TYP8NZkCtDguhKX1TNI0A24nsJ/Sp85M/puVaFzO1EVfOCfuN9
         6QhwaPeMedVj/tZXzMfdyzM4Fw7AkqzaJhYIOTRfLBOe/NYW20/Kfi31zGC1DXb6eP
         uj5iIl6bYLvc/IbeqbTxRxOYO+9XCAB2RVcY+I3o=
Date:   Fri, 20 Nov 2020 12:39:04 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 118/141] rtw88: Fix fall-through warnings for Clang
Message-ID: <967a171da3db43e4cdf38104876b4ec1cde46359.1605896060.git.gustavoars@kernel.org>
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
 drivers/net/wireless/realtek/rtw88/fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 042015bc8055..e2d4bb180afd 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -1473,7 +1473,7 @@ static bool rtw_fw_dump_check_size(struct rtw_dev *rtwdev,
 	case RTW_FW_FIFO_SEL_RX:
 		if ((start_addr + size) > rtwdev->chip->fw_fifo_addr[sel])
 			return false;
-		/*fall through*/
+		fallthrough;
 	default:
 		return true;
 	}
-- 
2.27.0

