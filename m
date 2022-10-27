Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49CFE60F332
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 11:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235209AbiJ0JHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 05:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235237AbiJ0JHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 05:07:01 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 715A7CABD7;
        Thu, 27 Oct 2022 02:06:52 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 5BB0632008FF;
        Thu, 27 Oct 2022 05:06:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 27 Oct 2022 05:06:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1666861610; x=1666948010; bh=lbTvqe1Qhg
        mw46guAJu3GHWBQbJFc8iZalauOR+hqY8=; b=W2A2XajcnjxqbGLlUUGWRT7Elj
        a+bP+DxqgomsV1AtcVVX1ZLyVF+63mnRGKspYMGKb06xaQ3bRMBw+Y97SetAF6ba
        OJSuXqsXQfnPXQFEg6wprIt19z4bg2+ahFN7yi6xlC9lVytEA/Kw+Jvx47xut1s6
        HAiDsxeTC6moECeE12D7EUvkKtJ3rIzpxGA+7y1HZPsqdDAkSS+1OE6gPrr30ABQ
        OPQtU9G/rsM330tGVTdcFnMSEWcCsXIt/jEDAKc+spVSk29DNvLDj1+gk3wLJVey
        oj0W9iXTCEyNr/MiYt4Tlh8M2N5qTE4Ri6jo/7MAQu7a5UOO5UCS2boUyWdw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1666861610; x=1666948010; bh=lbTvqe1Qhgmw46guAJu3GHWBQbJF
        c8iZalauOR+hqY8=; b=jVQS2xWst5NneyxEw0CfYlqSk9hgGqJAPfdWGy0iHaRG
        4wC6C5T8ibxf5wWOPTtDTnBrRL7BVJSzDgZPd+ktoWrQU3DNYJxi947B0UvQHieV
        gOZ1eqsGE1r2LQsWpE+MvY3fMggIeYDLF0Vqkgt5kCO8tbRlJIXEQgr6uyvMzqBo
        KsJJzA8nk53GPd8c2EAkgEDaRZCt5KPptscx7nOCzVKYbSzdd3GuMNEwkuHHQDD2
        DRYsxqPe3cebq3J95JVn3Baa92sfMR84a7oBK0S8p6ACQiVQbvVG2j29xCRWNNsO
        9DqnuJ8/K1U/pvLVnVajIw1jgkcdyMXxBgMdUVemug==
X-ME-Sender: <xms:KkpaY5zFi6cxPT-HQTVkfnBJ-lXduwowj7IfKuNGZADigtXbGuendg>
    <xme:KkpaY5Rn06WhSmBem2EbTxhi_WexsriguzDtj1Z7Df4BTGKfFiBhH1GPp_rnjv6RY
    9C1d20V--2Iu5iI0Q>
X-ME-Received: <xmr:KkpaYzVq4lV2J2F1TSKQUvsXE7bjMfMflygNkz4ecY_n-N0bsl0i7tGJ2str1bZp7S4JSUpAWmxkVWYV22Pm>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrtdeggddtlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfg
    hrlhcuvffnffculddujedmnecujfgurhepfffhvfevuffkfhggtggujgesthdtredttddt
    vdenucfhrhhomhepffgrnhhivghlucgiuhcuoegugihusegugihuuhhurdighiiiqeenuc
    ggtffrrghtthgvrhhnpeefveefhffhueeuledvhfegveelieeujeeuleffffekleeiveff
    gfejgfetgeffveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhgihhthhhusgdrtg
    homhdpnhgvthhfihhlthgvrhdrohhrghdpfihighhnvghrrdhhuhenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighi
    ii
X-ME-Proxy: <xmx:KkpaY7hCkiC7lLgpF2psVFV0qkyS-ZmLgElyvncKTuc0YKcfCV5FKg>
    <xmx:KkpaY7B8G5QLD0gxRqBmneY3SLUolkPhPDiFE4l8mq9KbL_7B_pOnw>
    <xmx:KkpaY0LT4NRZywg4ktBGLpPRGeBB6wiLjubgXhMKzu7pT4u98Eni3g>
    <xmx:KkpaY93JJViQkXHyKHi9Xv3KuhVyVpzfbkdoZBHxwuLXoOOjLknz9w>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Oct 2022 05:06:48 -0400 (EDT)
Date:   Thu, 27 Oct 2022 03:06:55 -0600
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ppenkov@aviatrix.com
Subject: Re: ip_set_hash_netiface
Message-ID: <20221027090655.r54utor2bkty3m5p@k2>
References: <9a91603a-7b8f-4c6d-9012-497335e4373b@app.fastmail.com>
 <7fcf3bbb-95d2-a286-e3a-4d4dd87f713a@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fcf3bbb-95d2-a286-e3a-4d4dd87f713a@netfilter.org>
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jozsef,

On Wed, Oct 26, 2022 at 02:26:08PM +0200, Jozsef Kadlecsik wrote:
> Hi Daniel,
> 
> On Tue, 25 Oct 2022, Daniel Xu wrote:
> 
> > I'm following up with our hallway chat yesterday about how ipset 
> > hash:net,iface can easily OOM.
> > 
> > Here's a quick reproducer (stolen from
> > https://bugzilla.kernel.org/show_bug.cgi?id=199107):
> > 
> >         $ ipset create ACL.IN.ALL_PERMIT hash:net,iface hashsize 1048576 timeout 0
> >         $ for i in $(seq 0 100); do /sbin/ipset add ACL.IN.ALL_PERMIT 0.0.0.0/0,kaf_$i timeout 0 -exist; done
> > 
> > This used to cause a NULL ptr deref panic before
> > https://github.com/torvalds/linux/commit/2b33d6ffa9e38f344418976b06 .
> > 
> > Now it'll either allocate a huge amount of memory or fail a
> > vmalloc():
> > 
> >         [Tue Oct 25 00:13:08 2022] ipset: vmalloc error: size 1073741848, exceeds total pages
> >         <...>
> >         [Tue Oct 25 00:13:08 2022] Call Trace:
> >         [Tue Oct 25 00:13:08 2022]  <TASK>
> >         [Tue Oct 25 00:13:08 2022]  dump_stack_lvl+0x48/0x60
> >         [Tue Oct 25 00:13:08 2022]  warn_alloc+0x155/0x180
> >         [Tue Oct 25 00:13:08 2022]  __vmalloc_node_range+0x72a/0x760
> >         [Tue Oct 25 00:13:08 2022]  ? hash_netiface4_add+0x7c0/0xb20
> >         [Tue Oct 25 00:13:08 2022]  ? __kmalloc_large_node+0x4a/0x90
> >         [Tue Oct 25 00:13:08 2022]  kvmalloc_node+0xa6/0xd0
> >         [Tue Oct 25 00:13:08 2022]  ? hash_netiface4_resize+0x99/0x710
> >         <...>
> > 
> > Note that this behavior is somewhat documented
> > (https://ipset.netfilter.org/ipset.man.html):
> > 
> > >  The internal restriction of the hash:net,iface set type is that the same
> > >  network prefix cannot be stored with more than 64 different interfaces
> > >  in a single set.
> > 
> > I'm not sure how hard it would be to enforce a limit, but I think it would
> > be a bit better to error than allocate many GBs of memory.
> 
> That's a bug, actually the limit is not enforced in spite of the 
> documentation. The next patch fixes it and I'm going to submit to Pablo:
> 
> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
> index 6e391308431d..3f8853ed32e9 100644
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -61,10 +61,6 @@ tune_bucketsize(u8 curr, u32 multi)
>  	 */
>  	return n > curr && n <= AHASH_MAX_TUNED ? n : curr;
>  }
> -#define TUNE_BUCKETSIZE(h, multi)	\
> -	((h)->bucketsize = tune_bucketsize((h)->bucketsize, multi))
> -#else
> -#define TUNE_BUCKETSIZE(h, multi)
>  #endif
>  
>  /* A hash bucket */
> @@ -936,7 +932,11 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
>  		goto set_full;
>  	/* Create a new slot */
>  	if (n->pos >= n->size) {
> -		TUNE_BUCKETSIZE(h, multi);
> +#ifdef IP_SET_HASH_WITH_MULTI
> +		if (h->bucketsize >= AHASH_MAX_TUNED)
> +			goto set_full;
> +		h->bucketsize = tune_bucketsize(h->bucketsize, multi);
> +#endif
>  		if (n->size >= AHASH_MAX(h)) {
>  			/* Trigger rehashing */
>  			mtype_data_next(&h->next, d);
> 
> Best regards,
> Jozsef
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics
>           H-1525 Budapest 114, POB. 49, Hungary

Thank you!

Daniel
