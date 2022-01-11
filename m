Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDA848AE76
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 14:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240543AbiAKNbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 08:31:09 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:54485 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240547AbiAKNbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 08:31:07 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id B30D45C0172;
        Tue, 11 Jan 2022 08:31:05 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 11 Jan 2022 08:31:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=O30Pib
        2oFK8GNZEAuzVg4nY9Hss5r2fOjzI63dKyr2o=; b=MMx+03d08tbQd4tLMM+M2/
        mBvYDDHym4z5uMJ1U8l8G3soVTMAYHPgDwKGvpwR6X9xTuXouHntDvqynH6owGDS
        IwyMkQNgSZvTb5lTAjKrHYri4mayAen4v3UBn9phHuD5iOTOddnKtCXk9myopXt0
        DLY1nzEcPA9949KaUluhqdUmJ9NFVZ7dg/5EGX7tt1bBgk8Rl0feJettRrXW3Yma
        1Nof/MVr3pNqGh3xqdT6lCSrzlr/d4jVnZvdd5YQ4R+z09TV919V3ZxVhUAR9tuA
        mmaCpD34vgX968odnP6yrjWDdGxWuk6SXwUFkA5cQDZAGbRV3s9stfvWrLL/JYzQ
        ==
X-ME-Sender: <xms:mYbdYeME0RPrOCJHMbycvvZRaIElvG5hGKf1y5DX5qkIJVEW6lmhOA>
    <xme:mYbdYc8ind2yjOe3J87M3YoiN71-wCmzeX_wBYzVL88yOcIakM6kLjB2rOMGZy5A5
    Sg4ylXe2kfVML8>
X-ME-Received: <xmr:mYbdYVQkYhnd12q3COOB9WP-8WYS7ElkQmTHMqMv-InDIXIK5O3WRWZEhGw1-WaKjrUCPAbuzdmKlxbnVRA-Fpsp8H4uUw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrudehfedghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpefgvefgveeuudeuffeiffehieffgfejleevtdetueetueffkeevgffgtddugfek
    veenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:mYbdYetbwJWdf20b1lWsrq6FcHwYH9bPDOxNgB4dvXmnZeG2xVjvxQ>
    <xmx:mYbdYWcJZFiV_YZH4RGVNfzcZKlm6QsVvYpLY4RKhm8f4pCZzGkXew>
    <xmx:mYbdYS0n5QCLETuUO_-DqhZn0NQVuGnq3Bhf-4iO-OpBZUJGA2DJoA>
    <xmx:mYbdYaHZMCADipoTGpxJ1JdWMUJcIHk9AerJ9fWtQVfmChIGx2Lzcg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 11 Jan 2022 08:31:04 -0500 (EST)
Date:   Tue, 11 Jan 2022 15:31:01 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Stephen Hemminger <sthemmin@microsoft.com>,
        idosch@nvidia.com
Subject: Re: [PATCH iproute2-next 06/11] nexthop: fix clang warning about
 timer check
Message-ID: <Yd2GlT3SMtiF3Oc2@shredder>
References: <20220108204650.36185-1-sthemmin@microsoft.com>
 <20220108204650.36185-7-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220108204650.36185-7-sthemmin@microsoft.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 08, 2022 at 12:46:45PM -0800, Stephen Hemminger wrote:
> diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
> index 83a5540e771c..2c65df294587 100644
> --- a/ip/ipnexthop.c
> +++ b/ip/ipnexthop.c
> @@ -31,6 +31,8 @@ enum {
>  	IPNH_FLUSH,
>  };
>  
> +#define TIMER_MAX   (~(__u32)0 / 100)
> +
>  #define RTM_NHA(h)  ((struct rtattr *)(((char *)(h)) + \
>  			NLMSG_ALIGN(sizeof(struct nhmsg))))
>  
> @@ -839,8 +841,8 @@ static void parse_nh_group_type_res(struct nlmsghdr *n, int maxlen, int *argcp,
>  			__u32 idle_timer;
>  
>  			NEXT_ARG();
> -			if (get_unsigned(&idle_timer, *argv, 0) ||
> -			    idle_timer >= ~0UL / 100)
> +			if (get_u32(&idle_timer, *argv, 0) ||
> +			    idle_timer >= TIMER_MAX)
>  				invarg("invalid idle timer value", *argv);
>  
>  			addattr32(n, maxlen, NHA_RES_GROUP_IDLE_TIMER,
> @@ -849,8 +851,8 @@ static void parse_nh_group_type_res(struct nlmsghdr *n, int maxlen, int *argcp,
>  			__u32 unbalanced_timer;
>  
>  			NEXT_ARG();
> -			if (get_unsigned(&unbalanced_timer, *argv, 0) ||
> -			    unbalanced_timer >= ~0UL / 100)
> +			if (get_u32(&unbalanced_timer, *argv, 0) ||
> +			    unbalanced_timer >= TIMER_MAX)
>  				invarg("invalid unbalanced timer value", *argv);

I believe these were already addressed by:
https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=5f8bb902e14f91161f9ed214d5fc1d813af8ed88

>  
>  			addattr32(n, maxlen, NHA_RES_GROUP_UNBALANCED_TIMER,
> -- 
> 2.30.2
> 
