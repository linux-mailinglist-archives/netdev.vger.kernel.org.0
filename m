Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078F432E537
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 10:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbhCEJrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 04:47:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:42282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229573AbhCEJri (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 04:47:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C277C64F10;
        Fri,  5 Mar 2021 09:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614937658;
        bh=KOJHukpfqZzcHhBdUnWloTwirgXzIdrq3OmqZA2G4wc=;
        h=Date:From:To:Cc:Subject:From;
        b=cFHA79dt19FMChSkZj3v98sE/3QFEb+ELRczZsxYYuKxZuLw4YqwaL03nU5fIcbSH
         DM6pllhJhJtFcGjPP1rGfzYIZlDXjEvExE1VTgTyP1wk1/z25+F8g70hM8ZEa6o3QH
         8JjMmLdUo77+i1bejDGUU6cDeSPN8UMO5+aAzaaLURt7GS2Kcj0v6tuMWsRK9PBJZW
         qb2PGSb5c7EyRJIbtj3MJiDnl2s3Q//y9D4HawzoBQWN9xqKlxQ9PJxvftxUC1DOH1
         RyAHDiWvvOqz/HqF3C1pNWxBUE8L+T9jtvWw2ZP1nrmEFvzmHQ/aw5o1blYhmVnR8L
         ltT6otmr+vcEg==
Date:   Fri, 5 Mar 2021 03:47:35 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jon Mason <jdmason@kudzu.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH RESEND][next] vxge: Fix fall-through warnings for Clang
Message-ID: <20210305094735.GA141111@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
by explicitly adding a return statement instead of letting the code fall
through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/neterion/vxge/vxge-config.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-config.c b/drivers/net/ethernet/neterion/vxge/vxge-config.c
index 5162b938a1ac..b47d74743f5a 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-config.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-config.c
@@ -3784,6 +3784,7 @@ vxge_hw_rts_rth_data0_data1_get(u32 j, u64 *data0, u64 *data1,
 			VXGE_HW_RTS_ACCESS_STEER_DATA1_RTH_ITEM1_ENTRY_EN |
 			VXGE_HW_RTS_ACCESS_STEER_DATA1_RTH_ITEM1_BUCKET_DATA(
 			itable[j]);
+		return;
 	default:
 		return;
 	}
-- 
2.27.0

