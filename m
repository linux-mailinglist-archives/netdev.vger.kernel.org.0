Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7B02BB3C1
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731263AbgKTSiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:38:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:56424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731242AbgKTSiH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:38:07 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50D3B21D91;
        Fri, 20 Nov 2020 18:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897484;
        bh=AjVdgvoWHF4+7F4kqNwapbEv2+b08/vs3SGIF6KZ0xY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0Vrw2eCEIJHv4F3Ai3KizrOhjAFnHljhFWbl7x7NUKr1xsevHhanwFpxAcJ1aCi+o
         GxglCu4RAyvHDUDgw/RwzGKusB4KqUqdrLfycVS1dB6Oe5Dx9s+jMhiihNmv0g23Bf
         QTlO/f0AfJcSAr410uJU7zsylWYUz01kgKdPCOPU=
Date:   Fri, 20 Nov 2020 12:38:09 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 108/141] netfilter: ipt_REJECT: Fix fall-through warnings for
 Clang
Message-ID: <ff4cbf9ab833a9d17306674850116693a17f2780.1605896060.git.gustavoars@kernel.org>
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
 net/ipv4/netfilter/ipt_REJECT.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index e16b98ee6266..7dbb10bbd0f5 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -57,6 +57,7 @@ reject_tg(struct sk_buff *skb, const struct xt_action_param *par)
 		break;
 	case IPT_TCP_RESET:
 		nf_send_reset(xt_net(par), skb, hook);
+		break;
 	case IPT_ICMP_ECHOREPLY:
 		/* Doesn't happen. */
 		break;
-- 
2.27.0

