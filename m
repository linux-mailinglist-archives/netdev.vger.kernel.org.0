Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A1138BB3E
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 03:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236041AbhEUBFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 21:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235984AbhEUBFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 21:05:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C53C0613ED;
        Thu, 20 May 2021 18:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=sni9ETK0HEg7xDqRTRD+07GslmzE5y7OWzA5WJKcjKU=; b=u70b07TD062bdzcBCW7Xa9uMDu
        Zvi3dzeWq3DXDEzDH3xRDl6oaTR5xq5coFv6GaME2vz1KEbDa3zSXlvSB4J2oR+UjWoxvBfKQyBS7
        BBTv8m0jL9zS/zbF1qxxGoIDV9mujDnXmmc8ui/vlS3tA8T/Ewp5/aXKrIk0oOYxN1uPnfKtgTC2E
        OpLrinbzCPhKfYv/UcSNjCiHOFVaAy+K9mbZxx+RxWFwgeLV64yAOLbyjpfzjLLrQhl6jK4/xEMCk
        D+GPPpxqsYdARBIBjmbe6cSpPIzaZEKIYPcEPTqfKVZy5YMTXt6pMsw78MMxnaYxEM3JbaltbQyIc
        Xdde8GPQ==;
Received: from [2601:1c0:6280:3f0::7376]
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1ljtaL-00Gjxw-1l; Fri, 21 May 2021 01:04:17 +0000
Subject: Re: mmotm 2021-05-19-23-58 uploaded
 (net/netfilter/nft_set_pipapo_avx2.c)
To:     Stephen Rothwell <sfr@rothwell.id.au>
Cc:     akpm@linux-foundation.org, broonie@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-next@vger.kernel.org, mhocko@suse.cz,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Stefano Brivio <sbrivio@redhat.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <20210520065918.KsmugQp47%akpm@linux-foundation.org>
 <3d718861-28bd-dd51-82d4-96b040aa1ab4@infradead.org>
 <20210521090751.51afa10f@elm.ozlabs.ibm.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <6eb826b6-4279-8cf8-1c27-01aab0f83843@infradead.org>
Date:   Thu, 20 May 2021 18:04:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210521090751.51afa10f@elm.ozlabs.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/20/21 4:07 PM, Stephen Rothwell wrote:
> Hi Randy,
> 
> On Thu, 20 May 2021 15:40:54 -0700 Randy Dunlap <rdunlap@infradead.org> wrote:
>>
>> on x86_64:
>> (from linux-next, not mmotm)
> 
> Yeah, this is caused by a bad merge resolution by me.
> 
>> ../net/netfilter/nft_set_pipapo_avx2.c: In function ‘nft_pipapo_avx2_lookup’:
>> ../net/netfilter/nft_set_pipapo_avx2.c:1135:10: error: implicit declaration of function ‘nft_pipapo_lookup’; did you mean ‘nft_pipapo_avx2_lookup’? [-Werror=implicit-function-declaration]
>>    return nft_pipapo_lookup(net, set, key, ext);
>>           ^~~~~~~~~~~~~~~~~
> 
> I have added this to the merge resolution today:
> 
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
>  bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
>  		       const u32 *key, const struct nft_set_ext **ext)
>  {
> 
> It should apply on top of next-20210520 if you want to test it (I
> haven't tested it yet, but will later today).

Yes, that builds. Thanks.

-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
https://people.kernel.org/tglx/notes-about-netiquette
