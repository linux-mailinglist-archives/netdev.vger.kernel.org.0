Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771B52BB2EC
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730227AbgKTS1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:27:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:48216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729345AbgKTS1p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:27:45 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 102AD24137;
        Fri, 20 Nov 2020 18:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605896864;
        bh=PzUQRnrAN0ELgA9SqxL3NXdQazZeB/6txsbYX7eZgPA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K1w7rg+wZH5p4fwQQmVBNiCLUPOPN4+zY2D138B9vVOPspxlxg058eOp2ihxpjHDf
         oEWswK03Zo0WtzxF4Ang/HS6K4ptWk6QQ9AuhC+2r1cLnXjt4s/M2ztYvLsW28TOig
         rFp/Y1lpmkatNi9QZrDy+63o2b4dm4KWXkMotCw4=
Date:   Fri, 20 Nov 2020 12:27:50 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 025/141] bnxt_en: Fix fall-through warnings for Clang
Message-ID: <37e648502a1a5d8c2f4c00b8ee1a4fb264acc0c8.1605896059.git.gustavoars@kernel.org>
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
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 7975f59735d6..b593237915e3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2137,6 +2137,7 @@ static int bnxt_hwrm_handler(struct bnxt *bp, struct tx_cmp *txcmp)
 	case CMPL_BASE_TYPE_HWRM_ASYNC_EVENT:
 		bnxt_async_event_process(bp,
 					 (struct hwrm_async_event_cmpl *)txcmp);
+		break;
 
 	default:
 		break;
-- 
2.27.0

