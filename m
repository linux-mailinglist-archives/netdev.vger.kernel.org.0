Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5787214969E
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 17:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgAYQ3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 11:29:34 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:46823 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgAYQ3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 11:29:34 -0500
Received: by mail-oi1-f195.google.com with SMTP id 13so2624934oij.13
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 08:29:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4yGiKRCk0HcFvB4+iKd9bepOVAQIqMiWDinSdLo4zLg=;
        b=WydB9Nz2W+WAFayFjkIwAfOKYQcc65NFXrWuv7SqND3xHsD67X/0WjFOrL5hh42elG
         9DnKh9g4gySDzJF7tXiQftzcEnbhgm4N1RXP0T9RvffrkvJBz4pp7pOckF9a5vPGkIm7
         nv11dl0lgi45fLmgR4Sh+wn3r0joJJiafA4flzXrr5NxZuTSLziyV2ZoYXdxuHJPoPi1
         TDKjdAqZrLra+GggGFMXfiHCHVzBadvV/YIfEfD2ZCdn3aiZ7ZTLpZNwkoppATUuSqZ8
         QGTaY/rkU8j3K5wer2LeEx0ARPTE8V73e/gnJlw4H6zeofSr3ICtN075pEvnUw1fIb1C
         pbmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4yGiKRCk0HcFvB4+iKd9bepOVAQIqMiWDinSdLo4zLg=;
        b=IX1JoZ/MkchC/byLehMsvG5f/GXFzV6CocXzqEiIEOgOC+chX9KwYCeCvlHX4PyL4+
         kwytrXCcDrSjFBg307r1A85JL4zVznOj+ZvkskizzLtRj0Ejd0YFOVPUUk3NcyTQmf/M
         KXOleprXLJEwTw7Jj4Tx/C0QQYgdqU5DYg3rrRaISPuPrZA6VLd/Xbei1uqIE4W2Ttk+
         ykZTG5+tYOA1j+EPvj/N4L+SZ8ciERJ5abiErRvXUlFIbXDf+tfgPbHlRBCmxx5dkbC2
         kcsukkJuUQtCbN/YfpfZU+eEoYXylA+wu1DgYCq7g2PJGJ4s+qzvDqOj4xEbXU+1P1/r
         vh+g==
X-Gm-Message-State: APjAAAX39O4foGY56/V35rG5HM1Mh8f3DEaQfdU82DR862rVucxqUoAT
        00MCvqqOCgHCzRdjACquhYuLgamG
X-Google-Smtp-Source: APXvYqwF6opXYcd7qmowVijK3te24AOxxG9kr4W8aaFDRRpNwrPj3DKjk5JqepUvRYIOCuWve8SQEQ==
X-Received: by 2002:aca:bac3:: with SMTP id k186mr2918012oif.19.1579969773479;
        Sat, 25 Jan 2020 08:29:33 -0800 (PST)
Received: from [172.16.171.105] ([208.139.204.134])
        by smtp.googlemail.com with ESMTPSA id n16sm3295080otk.25.2020.01.25.08.29.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jan 2020 08:29:32 -0800 (PST)
Subject: Re: [PATCH] net: include struct nhmsg size in nh nlmsg size
To:     Stephen Worley <sworley@cumulusnetworks.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, sharpd@cumulusnetworks.com,
        roopa@cumulusnetworks.com
References: <20200124215327.430193-1-sworley@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d3dfaec9-59de-9002-7917-b4b5bd40090a@gmail.com>
Date:   Sat, 25 Jan 2020 09:29:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200124215327.430193-1-sworley@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/24/20 2:53 PM, Stephen Worley wrote:
> Include the size of struct nhmsg size when calculating
> how much of a payload to allocate in a new netlink nexthop
> notification message.
> 
> Without this, we will fail to fill the skbuff at certain nexthop
> group sizes.
> 

...

> 
> Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
> Signed-off-by: Stephen Worley <sworley@cumulusnetworks.com>
> ---
>  net/ipv4/nexthop.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> index 511eaa94e2d1..d072c326dd64 100644
> --- a/net/ipv4/nexthop.c
> +++ b/net/ipv4/nexthop.c
> @@ -321,7 +321,9 @@ static size_t nh_nlmsg_size_single(struct nexthop *nh)
>  
>  static size_t nh_nlmsg_size(struct nexthop *nh)
>  {
> -	size_t sz = nla_total_size(4);    /* NHA_ID */
> +	size_t sz = NLMSG_ALIGN(sizeof(struct nhmsg));
> +
> +	sz += nla_total_size(4); /* NHA_ID */
>  
>  	if (nh->is_group)
>  		sz += nh_nlmsg_size_grp(nh);
> 
> base-commit: 623c8d5c74c69a41573da5a38bb59e8652113f56
> 
Good find. Thanks for the patch:

Reviewed-by: David Ahern <dsahern@gmail.com>


