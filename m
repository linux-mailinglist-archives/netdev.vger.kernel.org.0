Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C194532E547
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 10:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbhCEJu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 04:50:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:42952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229709AbhCEJu1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 04:50:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DD3A64FE9;
        Fri,  5 Mar 2021 09:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614937826;
        bh=Tt2go9RmbbAGrI+znzCKefo+867QQEBYhNBsCLItU6U=;
        h=Date:From:To:Cc:Subject:From;
        b=Osicut6lzbkrZcbzzGA0lzRsam+5Qi1SfP9TN3qvu4Dr9sFaOu/0+qkHf7jsle+QO
         QX0UvLS53H6ZfW3kUtlwX94/q8n7c5BwJSnXueHPF0/fNmoeqGvYAhYr+unDf/LXKp
         BR8qtzTOQYZwFJKNuXiOB7yzmbg6h0El8Q1RBkwfPX2ap+iKhHfCVH2H5z7fWcby9O
         6hAyq8+ltC3uPJSapUlSLxOXlXNtU/yQE0EA3NOv0Okn6GL1yQSIi0C0B0ynxUzmC8
         SndQofOzjP+F4JcNhhKXWleoMOO68l01n69sC3KivHQ0SnGvvf58NWkymWLUCw35Iq
         8igPpTXjlrpkA==
Date:   Fri, 5 Mar 2021 03:50:24 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH RESEND][next] bnxt_en: Fix fall-through warnings for Clang
Message-ID: <20210305095024.GA141398@embeddedor>
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
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b53a0d87371a..a34810750058 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2158,6 +2158,7 @@ static int bnxt_hwrm_handler(struct bnxt *bp, struct tx_cmp *txcmp)
 	case CMPL_BASE_TYPE_HWRM_ASYNC_EVENT:
 		bnxt_async_event_process(bp,
 					 (struct hwrm_async_event_cmpl *)txcmp);
+		break;
 
 	default:
 		break;
-- 
2.27.0

