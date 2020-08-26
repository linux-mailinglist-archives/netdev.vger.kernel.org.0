Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08CCF2537D7
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 21:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgHZTGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 15:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbgHZTGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 15:06:36 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0ECC061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 12:06:35 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id q14so2737064ilj.8
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 12:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k2P5OZb2owdVnAKLj7tkOc5PV4ogUPUJsnuP1nV0tYE=;
        b=ck1R/JyRiZ6fkCkjIyrXZfhBCtkE7yiYbGwRWBBuZpC3UTcYf/VNTe2YSwWBvCl2Hs
         P5RUzL1Qpd6ItsJYwB2CgmbapKp4jZYkg0ehiwzOCxfu6+sqUUbHxx/ukZ0Bm16rqSHD
         krdv8x0yYVpQfz/No/Ja4qDEt0WxBtovHdSV3YFzwP/rFC0BGcBnKnS2uQ35yezF9i9+
         bjERoCki7r99LnrogqWUNlY67UQqpHt87O6VXnGlhVj6LSaWoWXgcKZsJp/L/CvaVjOT
         HUbrV74SREd8JdSgZQLYszVLIVCr+4mPC7dRWvQba6UhuflqStalcEn9aJL+Lh0NN999
         9hmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k2P5OZb2owdVnAKLj7tkOc5PV4ogUPUJsnuP1nV0tYE=;
        b=c/r3FjqT1YCNS0kd3cKXOBYEONU1FdnkAYjXC0Ujgdeq9ubGAlBWvp0TfuVPWuLTJH
         UuORjs5yQ1hy8jReKVebO0vIcNp2Eqpp3CYvQX9cBRMxJVtFnNGEa8/wc7reAwrd0d0U
         dXO48R3PP606KEjhkx0JfBARMEF9s+OQ8uBDbxcZlm58rK/5Q4ErPx+XcVqVGgACqhaR
         vn6rJzaKkZs7yMhquHYskeYxF6oNz7bvOa4behp97A+EtN3xUp85DpP5PrEplVcjl+WP
         pr4AEG5mQWqvRS5r9wbXVuIpALG3tHOiOE0PgEzPnP5VtzqfxODpYc6DessUm+8nzBC6
         WAnQ==
X-Gm-Message-State: AOAM530r8m8BTEWVgBsVUyr76PEFJzbywFzTzkFvZFJV37+eVJGB8w6S
        WgX1o5EmJKaKxnFMRs1egfrRM2bvNVvbIw==
X-Google-Smtp-Source: ABdhPJxZzMhO0b+j85NzXxNLooEo2wlphVAioaTkgUspYJ+JUKeFB1WEkQufg9KYAPrLdxvbGPn1Ag==
X-Received: by 2002:a92:295:: with SMTP id 143mr14339082ilc.240.1598468795257;
        Wed, 26 Aug 2020 12:06:35 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:305a:ae30:42e4:e2ca])
        by smtp.googlemail.com with ESMTPSA id v84sm1932208ilk.4.2020.08.26.12.06.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 12:06:34 -0700 (PDT)
Subject: Re: [PATCH net-next 1/7] ipv4: nexthop: Reduce allocation size of
 'struct nh_group'
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
References: <20200826164857.1029764-1-idosch@idosch.org>
 <20200826164857.1029764-2-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <88977c63-b4f7-991f-e0a7-b0ee420ba617@gmail.com>
Date:   Wed, 26 Aug 2020 13:06:34 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200826164857.1029764-2-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/20 10:48 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> The struct looks as follows:
> 
> struct nh_group {
> 	struct nh_group		*spare; /* spare group for removals */
> 	u16			num_nh;
> 	bool			mpath;
> 	bool			fdb_nh;
> 	bool			has_v4;
> 	struct nh_grp_entry	nh_entries[];
> };
> 
> But its offset within 'struct nexthop' is also taken into account to
> determine the allocation size.

must be a leftover from initial versions. Thanks for catching this.

> 
> Instead, use struct_size() to allocate only the required number of
> bytes.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> index 134e92382275..d13730ff9aeb 100644
> --- a/net/ipv4/nexthop.c
> +++ b/net/ipv4/nexthop.c
> @@ -133,12 +133,9 @@ static struct nexthop *nexthop_alloc(void)
>  
>  static struct nh_group *nexthop_grp_alloc(u16 num_nh)
>  {
> -	size_t sz = offsetof(struct nexthop, nh_grp)
> -		    + sizeof(struct nh_group)
> -		    + sizeof(struct nh_grp_entry) * num_nh;
>  	struct nh_group *nhg;
>  
> -	nhg = kzalloc(sz, GFP_KERNEL);
> +	nhg = kzalloc(struct_size(nhg, nh_entries, num_nh), GFP_KERNEL);
>  	if (nhg)
>  		nhg->num_nh = num_nh;
>  
> 

Reviewed-by: David Ahern <dsahern@gmail.com>
