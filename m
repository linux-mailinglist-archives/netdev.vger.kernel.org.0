Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFB01EA278
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 13:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgFALMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 07:12:20 -0400
Received: from smtprelay0125.hostedemail.com ([216.40.44.125]:60838 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725788AbgFALMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 07:12:17 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 116D418029122;
        Mon,  1 Jun 2020 11:12:16 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1381:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2110:2198:2199:2393:2559:2562:2736:2828:2890:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4042:4321:5007:7875:7903:7974:10004:10400:10848:11232:11658:11914:12296:12297:12740:12760:12895:13439:14180:14659:14721:21080:21433:21450:21627:21939:21972:21990:30001:30012:30054:30070:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:16,LUA_SUMMARY:none
X-HE-Tag: trees87_5606a4026d7c
X-Filterd-Recvd-Size: 3066
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Mon,  1 Jun 2020 11:12:15 +0000 (UTC)
Message-ID: <517a1ae3d93ff750263008c9807c224fb127b704.camel@perches.com>
Subject: Re: [PATCH net-next 1/1] wireguard: reformat to 100 column lines
From:   Joe Perches <joe@perches.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>, netdev@vger.kernel.org,
        davem@davemloft.net
Date:   Mon, 01 Jun 2020 04:12:14 -0700
In-Reply-To: <20200601062946.160954-2-Jason@zx2c4.com>
References: <20200601062946.160954-1-Jason@zx2c4.com>
         <20200601062946.160954-2-Jason@zx2c4.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-06-01 at 00:29 -0600, Jason A. Donenfeld wrote:
> While this sort of change is typically viewed as "trivial", "cosmetic",
> or even "bikesheddy", I think there's a very serious argument to be made
> about the readability and comprehensibility of the code as a result.

Hey Jason.

I think a lot of these changes make a good deal of sense.

I certainly prefer:

> +static u8 common_bits(const struct allowedips_node *node, const u8 *key, u8 bits)
>  {
>  	if (bits == 32)
>  		return 32U - fls(*(const u32 *)node->bits ^ *(const u32 *)key);
>  	else if (bits == 128)
> -		return 128U - fls128(
> -			*(const u64 *)&node->bits[0] ^ *(const u64 *)&key[0],
> -			*(const u64 *)&node->bits[8] ^ *(const u64 *)&key[8]);
> +		return 128U - fls128(*(const u64 *)&node->bits[0] ^ *(const u64 *)&key[0],
> +				     *(const u64 *)&node->bits[8] ^ *(const u64 *)&key[8]);
>  	return 0;
>  }

(though the different uses of nodes->bits vs &nodes->bits[0]
 and node->key vs &node->key[0] in the two blocks is just odd.

whereas:

> -static bool prefix_matches(const struct allowedips_node *node, const u8 *key,
> -			   u8 bits)
> +static bool prefix_matches(const struct allowedips_node *node, const u8 *key, u8 bits)
>  {
> -	/* This could be much faster if it actually just compared the common
> -	 * bits properly, by precomputing a mask bswap(~0 << (32 - cidr)), and
> -	 * the rest, but it turns out that common_bits is already super fast on
> -	 * modern processors, even taking into account the unfortunate bswap.
> -	 * So, we just inline it like this instead.
> +	/* This could be much faster if it actually just compared the common bits properly, by
> +	 * precomputing a mask bswap(~0 << (32 - cidr)), and the rest, but it turns out that
> +	 * common_bits is already super fast on modern processors, even taking into account the
> +	 * unfortunate bswap.  So, we just inline it like this instead.

Reformatting comments just because you get more columns in the code
makes reading the comments a bit harder.

Newspaper columns are pretty narrow for a reason.

Please remember that left to right scanning of text, especially for
comments, is not particularly improved by longer lines.

cheers, Joe

