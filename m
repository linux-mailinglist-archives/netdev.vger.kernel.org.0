Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B7E38BA79
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 01:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234275AbhETXmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 19:42:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37228 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234379AbhETXmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 19:42:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621554068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jvjP3xmaPvbueW2T2LLDyRBRYPus5uAQpfJvGW5jPfA=;
        b=Yt7QBegdsp3QE6XIUpwqLzZufED8bKG9kdrzsgjN9dAVPCu23ZXK46uo4G1Xx02HJ4vFob
        er7xTfgx5s2ZjpwY+v7WVDjnlpkqfC1vovz/WigC6h9Jvz7ur2ZArzRUz0L3p8CjtZLoEj
        m4PouCZjvBtQtkyEDMw025zc8wviqWk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-I8SP1Xy4NvCfJFrlUwO-_w-1; Thu, 20 May 2021 19:41:04 -0400
X-MC-Unique: I8SP1Xy4NvCfJFrlUwO-_w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56D5B180FD65;
        Thu, 20 May 2021 23:41:02 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.36.110.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 665ED10023AF;
        Thu, 20 May 2021 23:41:01 +0000 (UTC)
Date:   Fri, 21 May 2021 01:40:58 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: manual merge of the netfilter-next tree with the
 net tree
Message-ID: <20210521014058.5c84301d@elisabeth>
In-Reply-To: <20210521091222.3112f371@canb.auug.org.au>
References: <20210519095627.7697ff12@canb.auug.org.au>
        <20210519140532.677d1bb6@canb.auug.org.au>
        <20210521091222.3112f371@canb.auug.org.au>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, 21 May 2021 09:12:22 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> On Wed, 19 May 2021 14:05:32 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > On Wed, 19 May 2021 09:56:27 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:  
> > >
> > > Today's linux-next merge of the netfilter-next tree got a conflict in:
> > > 
> > >   net/netfilter/nft_set_pipapo.c
> > > 
> > > between commit:
> > > 
> > >   f0b3d338064e ("netfilter: nft_set_pipapo_avx2: Add irq_fpu_usable() check, fallback to non-AVX2 version")
> > > 
> > > from the net tree and commit:
> > > 
> > >   b1bc08f6474f ("netfilter: nf_tables: prefer direct calls for set lookups")
> > > 
> > > from the netfilter-next tree.
> > > 
> > > I fixed it up (I just used the latter) and can carry the fix as necessary. This
> > > is now fixed as far as linux-next is concerned, but any non trivial
> > > conflicts should be mentioned to your upstream maintainer when your tree
> > > is submitted for merging.  You may also want to consider cooperating
> > > with the maintainer of the conflicting tree to minimise any particularly
> > > complex conflicts.    
> > 
> > This merge also needs the following merge resolution patch:
> > 
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Wed, 19 May 2021 13:48:22 +1000
> > Subject: [PATCH] fix up for merge involving nft_pipapo_lookup()
> > 
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > ---
> >  net/netfilter/nft_set_pipapo.h | 2 --
> >  1 file changed, 2 deletions(-)
> > 
> > diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.h
> > index d84afb8fa79a..25a75591583e 100644
> > --- a/net/netfilter/nft_set_pipapo.h
> > +++ b/net/netfilter/nft_set_pipapo.h
> > @@ -178,8 +178,6 @@ struct nft_pipapo_elem {
> >  
> >  int pipapo_refill(unsigned long *map, int len, int rules, unsigned long *dst,
> >  		  union nft_pipapo_map_bucket *mt, bool match_only);
> > -bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
> > -		       const u32 *key, const struct nft_set_ext **ext);
> >  
> >  /**
> >   * pipapo_and_field_buckets_4bit() - Intersect 4-bit buckets
> > -- 
> > 2.30.2  
> 
> Actually it appears to also need this:

Thanks for the fix, and sorry for the mess. To retain the effect of
b1bc08f6474f ("netfilter: nf_tables: prefer direct calls for set lookups")
from nf-next, though,

> diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
> index 789e9eadd76d..8652b2514e57 100644
> --- a/include/net/netfilter/nf_tables_core.h
> +++ b/include/net/netfilter/nf_tables_core.h
> @@ -89,6 +89,8 @@ extern const struct nft_set_type nft_set_bitmap_type;
>  extern const struct nft_set_type nft_set_pipapo_type;
>  extern const struct nft_set_type nft_set_pipapo_avx2_type;
>  
> +bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
> +			    const u32 *key, const struct nft_set_ext **ext);

while this looks correct to me (b1bc08f6474f adds the prototype
conditionally for CONFIG_RETPOLINE, f0b3d338064e adds it
unconditionally),

>  #ifdef CONFIG_RETPOLINE
>  bool nft_rhash_lookup(const struct net *net, const struct nft_set *set,
>  		      const u32 *key, const struct nft_set_ext **ext);
> @@ -101,8 +103,6 @@ bool nft_hash_lookup_fast(const struct net *net,
>  			  const u32 *key, const struct nft_set_ext **ext);
>  bool nft_hash_lookup(const struct net *net, const struct nft_set *set,
>  		     const u32 *key, const struct nft_set_ext **ext);
> -bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
> -			    const u32 *key, const struct nft_set_ext **ext);
>  bool nft_set_do_lookup(const struct net *net, const struct nft_set *set,
>  		       const u32 *key, const struct nft_set_ext **ext);
>  #else
> diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
> index 9addc0b447f7..dce866d93fee 100644
> --- a/net/netfilter/nft_set_pipapo.c
> +++ b/net/netfilter/nft_set_pipapo.c
> @@ -408,7 +408,6 @@ int pipapo_refill(unsigned long *map, int len, int rules, unsigned long *dst,
>   *
>   * Return: true on match, false otherwise.
>   */
> -INDIRECT_CALLABLE_SCOPE

this shouldn't be removed.

>  bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
>  		       const u32 *key, const struct nft_set_ext **ext)
>  {
> 
> 

Let me know if I should rather send a patch for linux-next (but it
might take me a bit).

-- 
Stefano

