Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A482BB3BE
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731252AbgKTSiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:38:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:56328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731242AbgKTSh6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:37:58 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D18824124;
        Fri, 20 Nov 2020 18:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897478;
        bh=7R4PtXf5LCp6UdlNr8ha3dsZONi3NhDHVN2EdWXcMj4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hjtdKwVhtYtgRNaINdslT+ko1N3bWz6WIzwjBbTnWA8SdSPOZnZyjRHcgh5CM2u7D
         0OsEuvZhrZq23fzl2ZC8tRcIVm+s+h9/ftDAU++A72Bd47kKKs0v/dUhxazyOMGb8J
         NqtIiIkAzVoZJtGTFMJaNDmlbFNI6uq6U144R1RE=
Date:   Fri, 20 Nov 2020 12:38:03 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 107/141] net: core: Fix fall-through warnings for Clang
Message-ID: <8439b30a691bef3d486f825f07f4e73f81064ec3.1605896060.git.gustavoars@kernel.org>
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
 net/core/dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 82dc6b48e45f..9efb03ce504d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5214,6 +5214,7 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 			goto another_round;
 		case RX_HANDLER_EXACT:
 			deliver_exact = true;
+			break;
 		case RX_HANDLER_PASS:
 			break;
 		default:
-- 
2.27.0

