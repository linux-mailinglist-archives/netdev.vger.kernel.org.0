Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFC936766B
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 02:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241919AbhDVAlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 20:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344084AbhDVAky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 20:40:54 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BCEC061345;
        Wed, 21 Apr 2021 17:39:48 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lZNNe-0000u0-3V; Thu, 22 Apr 2021 02:39:42 +0200
Date:   Thu, 22 Apr 2021 02:39:42 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phillip Potter <phil@philpotter.co.uk>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, edumazet@google.com
Subject: Re: [PATCH] net: geneve: modify IP header check in geneve6_xmit_skb
Message-ID: <20210422003942.GF4841@breakpoint.cc>
References: <20210421231100.7467-1-phil@philpotter.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421231100.7467-1-phil@philpotter.co.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Phillip Potter <phil@philpotter.co.uk> wrote:
> Modify the check in geneve6_xmit_skb to use the size of a struct iphdr
> rather than struct ipv6hdr. This fixes two kernel selftest failures
> introduced by commit 6628ddfec758
> ("net: geneve: check skb is large enough for IPv4/IPv6 header"), without
> diminishing the fix provided by that commit.

What errors?

> Reported-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> ---
>  drivers/net/geneve.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
> index 42f31c681846..a57a5e6f614f 100644
> --- a/drivers/net/geneve.c
> +++ b/drivers/net/geneve.c
> @@ -988,7 +988,7 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
>  	__be16 sport;
>  	int err;
>  
> -	if (!pskb_network_may_pull(skb, sizeof(struct ipv6hdr)))
> +	if (!pskb_network_may_pull(skb, sizeof(struct iphdr)))
>  		return -EINVAL;

Seems this is papering over some bug, this change makes no sense to
me.  Can you please explain this?
