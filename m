Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D2B287619
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 16:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730621AbgJHOcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 10:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730557AbgJHOcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 10:32:41 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EF2C061755
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 07:32:40 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id d81so6700041wmc.1
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 07:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=hWmkGRu89/ferD1B+dgO/craWcKPpi235L99RW0x100=;
        b=jTkKWuyyMAAf8Ka3bYJFz/mmO3E1hZUOSrGoGn5N3I6E+rHVvv7Bhls1R8MHE4JstR
         /DCHOM57yAogSFZ7esghGATk+OaWFGMO3lZN9TQnAWcIi+4aJ8aZxncvh1+Tnws1M0l/
         24ys+sDM10zQ/wYxYxWcc2Fw9t1cNj1P99oEWdpsZYqiXWhe/VYsjli8ToNU1fBGJpMr
         8g/adpfVBuW2qNyXrpKvJE1hV/FAjavLDF25GKwad01X9MeXwTgmjTWxn7iJJBU6kvvK
         KJcvEhLnpbRIKoUSKqJrp5yzY6t+tCYdxXAvXiFJdLxk5RDEWiE/bVaf+rwFXv9RFM8E
         DKOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hWmkGRu89/ferD1B+dgO/craWcKPpi235L99RW0x100=;
        b=UWGx73aIG2sYhbeWslYFTHfOvhEfWGhPA1XP6/+r7d157MJqAd6y6xH8S2Mg5gNQqm
         IRjXbWwzEWBZRAryMsR8EyRoqX6U/GIkRz1YO186DPeOQsr7/vy/V+aRWzq+XoyaNgPJ
         dVc0ep+73+NCHtZxKUe/7Xxm3WxCIul9jQT4IUOB2FRNeC6kZh0FG3h30qOCpKVN4a2s
         eJ6UA3jOy+k88upbYWI/XimSMvafpH9LLrBmFAvgdqHPbrhKDYHbGRq91wlMtU353SQ0
         T1bsqo611SrOK8C+NKJMNZaf6Jz1/nu71SfmW34YPbNeiNU/c8YuKDX3STbZE3bL/9Dz
         c2cQ==
X-Gm-Message-State: AOAM531ZwTXdOh8Yv5sK5WqNoCRp1LVVADAITi10t2PgrnjjYqPrJsnq
        4bFddVlB486x5youhFSrWTjpXn6oGLs=
X-Google-Smtp-Source: ABdhPJx4htr8gkkIlThRw3/75KrFxAGYXqe8MbB3S3pUmvZ9amQEfKEhLNuWIov/9e3IPT4gAH/iqA==
X-Received: by 2002:a1c:1902:: with SMTP id 2mr9617200wmz.26.1602167559173;
        Thu, 08 Oct 2020 07:32:39 -0700 (PDT)
Received: from [192.168.8.147] ([37.165.121.66])
        by smtp.gmail.com with ESMTPSA id d2sm7840588wro.34.2020.10.08.07.32.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 07:32:38 -0700 (PDT)
Subject: Re: [PATCH net-next] neigh: add netlink filtering based on LLADDR for
 dump
To:     Florent Fourcot <florent.fourcot@wifirst.fr>,
        netdev@vger.kernel.org
References: <20201008105911.28350-1-florent.fourcot@wifirst.fr>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <710c74d0-61f8-a1ae-e979-4143f26dfe75@gmail.com>
Date:   Thu, 8 Oct 2020 16:32:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201008105911.28350-1-florent.fourcot@wifirst.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/8/20 12:59 PM, Florent Fourcot wrote:
> neighbours table dump supports today two filtering:
>  * based on interface index
>  * based on master index
> 
> This patch adds a new filtering, based on layer two address. That will
> help to replace something like it:
> 
>  ip neigh show | grep aa:11:22:bb:ee:ff
> 
> by a better command:
> 
>  ip neigh show lladdr aa:11:22:bb:ee:ff
> 
> Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
> ---
>  net/core/neighbour.c | 24 ++++++++++++++++++++++--
>  1 file changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 8e39e28b0a8d..4b32bf49a005 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -2542,9 +2542,25 @@ static bool neigh_ifindex_filtered(struct net_device *dev, int filter_idx)
>  	return false;
>  }
>  
> +static bool neigh_lladdr_filtered(struct neighbour *neigh, const u8 *lladdr)
> +{
> +	if (!lladdr)
> +		return false;
> +
> +	/* Ignore all empty values when lladdr filtering is set */
> +	if (!neigh->dev->addr_len)
> +		return true;
> +
> +	if (memcmp(lladdr, neigh->ha, neigh->dev->addr_len) != 0)

Where do you check that lladdr contains exactly neigh->dev->addr_len bytes ?

> +		return true;
> +
> +	return false;
> +}
> +
>  struct neigh_dump_filter {
>  	int master_idx;
>  	int dev_idx;
> +	void *lladdr;
>  };
>  
>  static int neigh_dump_table(struct neigh_table *tbl, struct sk_buff *skb,
> @@ -2558,7 +2574,7 @@ static int neigh_dump_table(struct neigh_table *tbl, struct sk_buff *skb,
>  	struct neigh_hash_table *nht;
>  	unsigned int flags = NLM_F_MULTI;
>  
> -	if (filter->dev_idx || filter->master_idx)
> +	if (filter->dev_idx || filter->master_idx || filter->lladdr)
>  		flags |= NLM_F_DUMP_FILTERED;
>  
>  	rcu_read_lock_bh();
> @@ -2573,7 +2589,8 @@ static int neigh_dump_table(struct neigh_table *tbl, struct sk_buff *skb,
>  			if (idx < s_idx || !net_eq(dev_net(n->dev), net))
>  				goto next;
>  			if (neigh_ifindex_filtered(n->dev, filter->dev_idx) ||
> -			    neigh_master_filtered(n->dev, filter->master_idx))
> +			    neigh_master_filtered(n->dev, filter->master_idx) ||
> +			    neigh_lladdr_filtered(n, filter->lladdr))
>  				goto next;
>  			if (neigh_fill_info(skb, n, NETLINK_CB(cb->skb).portid,
>  					    cb->nlh->nlmsg_seq,
> @@ -2689,6 +2706,9 @@ static int neigh_valid_dump_req(const struct nlmsghdr *nlh,
>  		case NDA_MASTER:
>  			filter->master_idx = nla_get_u32(tb[i]);
>  			break;
> +		case NDA_LLADDR:
> +			filter->lladdr = nla_data(tb[i]);

This comes from user space, and could contains an arbitrary amount of bytes, like 0 byte.

You probably have to store the full attribute, so that you can use nla_len() and nla_data()

> +			break;
>  		default:
>  			if (strict_check) {
>  				NL_SET_ERR_MSG(extack, "Unsupported attribute in neighbor dump request");
> 
