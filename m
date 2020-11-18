Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F062B8874
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 00:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgKRXgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 18:36:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbgKRXgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 18:36:20 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7DC6C0613D4;
        Wed, 18 Nov 2020 15:36:19 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kfWzn-0006ZI-KS; Thu, 19 Nov 2020 00:36:15 +0100
Date:   Thu, 19 Nov 2020 00:36:15 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, razor@blackwall.org,
        tobias@waldekranz.com, jeremy@azazel.net
Subject: Re: [PATCH net-next,v4 2/9] netfilter: flowtable: add xmit path types
Message-ID: <20201118233615.GD15137@breakpoint.cc>
References: <20201118223011.3216-1-pablo@netfilter.org>
 <20201118223011.3216-3-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118223011.3216-3-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> -	if (unlikely(dst_xfrm(&rt->dst))) {
> +	rt = (struct rtable *)tuplehash->tuple.dst_cache;
> +
> +	if (unlikely(tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM)) {
>  		memset(skb->cb, 0, sizeof(struct inet_skb_parm));
>  		IPCB(skb)->iif = skb->dev->ifindex;
>  		IPCB(skb)->flags = IPSKB_FORWARDED;
>  		return nf_flow_xmit_xfrm(skb, state, &rt->dst);
>  	}
[..]

> +
> +	if (unlikely(tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_NEIGH))

This needs to be XMIT_XFRM too.
