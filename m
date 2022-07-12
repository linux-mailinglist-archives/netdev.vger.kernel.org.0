Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF07A572584
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 21:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233355AbiGLTTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 15:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235136AbiGLTSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 15:18:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B382A110B87;
        Tue, 12 Jul 2022 11:56:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D01B3B81B96;
        Tue, 12 Jul 2022 18:56:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950E7C3411C;
        Tue, 12 Jul 2022 18:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657652165;
        bh=+8++mmPF4oeO7kDkagulOMwZIhGJMwHoTQm+dU3sDQs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qRAubObhVb9WlnK6U7QegUe+cOdYIue8KdIFkzzfJ1Z+W1mzMm5KuCW2znasRcWUq
         a2pCzmneBX6Txz3qaTEqify6gFETbOYamVlS2KyaNX4GBp/jl8dCEvgUh7FlGC2Vm/
         Wthmt84LW8yP6GtMmcmsYuhw/0Mld+h39qgWapkLAKv8dbfj+C1pOLvaSe1cvO/AxV
         3c0afBvtFR8ohfOtDSIfyzhhtYCQOlBk2eAj7iHLXnabPKCNWkbMzF6HHSOZKW+mOP
         tWFLBZ2KN067OUtltvsfCCe6TwbmF1zOlDqiKoJ6Rzxb1kHi5PKGMRigszfomHc+yH
         /2OOMqPRXPfzw==
Date:   Tue, 12 Jul 2022 11:56:02 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Justin Stitt <justinstitt@google.com>
Cc:     pablo@netfilter.org, coreteam@netfilter.org, davem@davemloft.net,
        edumazet@google.com, fw@strlen.de, kadlec@netfilter.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, ndesaulniers@google.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pabeni@redhat.com, trix@redhat.com
Subject: Re: [PATCH] netfilter: xt_TPROXY: remove pr_debug invocations
Message-ID: <Ys3DwnYiF9eDwr2T@dev-arch.thelio-3990X>
References: <Ys0zZACWwGilTwHx@salvia>
 <20220712183452.2949361-1-justinstitt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712183452.2949361-1-justinstitt@google.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Justin,

On Tue, Jul 12, 2022 at 11:34:52AM -0700, Justin Stitt wrote:
> pr_debug calls are no longer needed in this file.
> 
> Pablo suggested "a patch to remove these pr_debug calls". This patch has
> some other beneficial collateral as it also silences multiple Clang
> -Wformat warnings that were present in the pr_debug calls.
> 
> Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Justin Stitt <justinstitt@google.com>

Thanks for the patch!

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

Couple of style comments below that probably warrant a v2, you can carry
the above tag forward for future revisions. No need to give me a
"Suggested-by".

> ---
> Suggestion here: https://lore.kernel.org/all/Ys0zZACWwGilTwHx@salvia/
> 
>  net/netfilter/xt_TPROXY.c | 19 -------------------
>  1 file changed, 19 deletions(-)
> 
> diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
> index 459d0696c91a..dc7284e6357b 100644
> --- a/net/netfilter/xt_TPROXY.c
> +++ b/net/netfilter/xt_TPROXY.c
> @@ -74,18 +74,10 @@ tproxy_tg4(struct net *net, struct sk_buff *skb, __be32 laddr, __be16 lport,
>  		/* This should be in a separate target, but we don't do multiple
>  		   targets on the same rule yet */
>  		skb->mark = (skb->mark & ~mark_mask) ^ mark_value;
> -
> -		pr_debug("redirecting: proto %hhu %pI4:%hu -> %pI4:%hu, mark: %x\n",
> -			 iph->protocol, &iph->daddr, ntohs(hp->dest),
> -			 &laddr, ntohs(lport), skb->mark);
> -
>  		nf_tproxy_assign_sock(skb, sk);
>  		return NF_ACCEPT;
>  	}
>  
> -	pr_debug("no socket, dropping: proto %hhu %pI4:%hu -> %pI4:%hu, mark: %x\n",
> -		 iph->protocol, &iph->saddr, ntohs(hp->source),
> -		 &iph->daddr, ntohs(hp->dest), skb->mark);
>  	return NF_DROP;
>  }
>  
> @@ -123,13 +115,11 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
>  
>  	tproto = ipv6_find_hdr(skb, &thoff, -1, NULL, NULL);
>  	if (tproto < 0) {

checkpatch.pl should have warned that these if statement braces here and
below are no longer necessary because there is only one statement within
them now.

	if (tproto < 0)
		return NF_DROP;

I believe it is important to do these types of style cleanups when doing
a larger change so that people do not try to do them as standalone
changes, which can irritate maintainers.

> -		pr_debug("unable to find transport header in IPv6 packet, dropping\n");
>  		return NF_DROP;
>  	}
>  
>  	hp = skb_header_pointer(skb, thoff, sizeof(_hdr), &_hdr);
>  	if (hp == NULL) {
> -		pr_debug("unable to grab transport header contents in IPv6 packet, dropping\n");
>  		return NF_DROP;
>  	}

	if (hp == NULL)
		return NF_DROP;

could even go a step farther and make it

	if (!hp)
		return NF_DROP;

if there is a warning about that.

>  
> @@ -168,19 +158,10 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
>  		/* This should be in a separate target, but we don't do multiple
>  		   targets on the same rule yet */
>  		skb->mark = (skb->mark & ~tgi->mark_mask) ^ tgi->mark_value;
> -
> -		pr_debug("redirecting: proto %hhu %pI6:%hu -> %pI6:%hu, mark: %x\n",
> -			 tproto, &iph->saddr, ntohs(hp->source),
> -			 laddr, ntohs(lport), skb->mark);
> -
>  		nf_tproxy_assign_sock(skb, sk);
>  		return NF_ACCEPT;
>  	}
>  
> -	pr_debug("no socket, dropping: proto %hhu %pI6:%hu -> %pI6:%hu, mark: %x\n",
> -		 tproto, &iph->saddr, ntohs(hp->source),
> -		 &iph->daddr, ntohs(hp->dest), skb->mark);
> -
>  	return NF_DROP;
>  }
>  
> -- 
> 2.37.0.144.g8ac04bfd2-goog
> 
