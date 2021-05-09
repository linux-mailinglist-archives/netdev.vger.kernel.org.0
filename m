Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8403777D5
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 19:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhEIRgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 13:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbhEIRgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 13:36:38 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55568C061573
        for <netdev@vger.kernel.org>; Sun,  9 May 2021 10:35:35 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id i13so12146135pfu.2
        for <netdev@vger.kernel.org>; Sun, 09 May 2021 10:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fgdJMhILSZ0GaWX9fsMf1XcdhZB/J1PnFtKfIKNyRZg=;
        b=ovzZIxwTdk1bxjpPcDs5o6uj5xv2l6T8/KdxDkXEw0x0tUrEbEhvVN+emAAUHsDMIY
         9qLkA3N19zT3yhV5H5Q8HKjG23xTKnA1YlMfWoedEvVimWw1irf15Hi8m3B7pL6nfTap
         rDXIKSIoleGoBJNvOhQYeNp6m5oMxqxwR/xNvNWMvwYMeVrhHZ2gmjfQbiWUi+pkK0yf
         GYXe1To6C/SMJRhLqeCGJCKCFFUqG3HlMrHooaRprlb/69QHcNK/jQCkYf32y+pON9Cc
         mWMJzXbIinteEfdDbNc0I1hzTrG+vfwShcMiJbc1PHohpthByhy7+rfiDw9SD3UPYjce
         1YQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fgdJMhILSZ0GaWX9fsMf1XcdhZB/J1PnFtKfIKNyRZg=;
        b=ndtBpeeBRd4WmiiBxpvZE4MrYBIdfkLj8KwjGnk+K27KYVBuiFz4A5C3d8sUY2rw1t
         AAr9kdqJDnOvQSMDxXijJMy2bB9LQuWRTigNYguHT2i+rxljzHHxmu6GTNsmaj+QzN+B
         fG3klKwbCMG3Sca325iO5F20kEoxqqYtYnYdjzdu30covWJJqsnPD+yMizw7df1CpJkS
         41ZrXK6x6sjYytjGJFbWs+Y3idX0EXIdP5ZaGGCJgTktRK+yqXTzGzqWHUH7aQXUhcfU
         OpmI6f9opOQHyR4vsMpvZEk2z5/MLNkvTGD5fpmo+Ecs4SbyXoivoOiSrEUMatARZZGk
         +NvA==
X-Gm-Message-State: AOAM5304Ite20Ckzz9/2woMIvhxQBeNC1YHTqpKs9g0d0XfloP1JUKbY
        4t1NFmFyEviJi+KmfI+XLGE=
X-Google-Smtp-Source: ABdhPJzsAay1dXFs7E8AAWpXr1ASxpk5s8VVoXzF1uHrrLPaZS793kJWGbur9r/OX1lURbT1M4c1uQ==
X-Received: by 2002:a63:e1d:: with SMTP id d29mr21933369pgl.175.1620581734557;
        Sun, 09 May 2021 10:35:34 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f201sm9205103pfa.133.2021.05.09.10.35.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 May 2021 10:35:33 -0700 (PDT)
Subject: Re: [PATCH net] net: dsa: fix error code getting shifted with 4 in
 dsa_slave_get_sset_count
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210509115513.4121549-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <53834b37-16c5-2d1d-ab72-78f699603dca@gmail.com>
Date:   Sun, 9 May 2021 10:35:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210509115513.4121549-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/9/2021 4:55 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> DSA implements a bunch of 'standardized' ethtool statistics counters,
> namely tx_packets, tx_bytes, rx_packets, rx_bytes. So whatever the
> hardware driver returns in .get_sset_count(), we need to add 4 to that.
> 
> That is ok, except that .get_sset_count() can return a negative error
> code, for example:
> 
> b53_get_sset_count
> -> phy_ethtool_get_sset_count
>    -> return -EIO
> 
> -EIO is -5, and with 4 added to it, it becomes -1, aka -EPERM. One can
> imagine that certain error codes may even become positive, although
> based on code inspection I did not see instances of that.
> 
> Check the error code first, if it is negative return it as-is.
> 
> Based on a similar patch for dsa_master_get_strings from Dan Carpenter:
> https://patchwork.kernel.org/project/netdevbpf/patch/YJaSe3RPgn7gKxZv@mwanda/
> 
> Fixes: 91da11f870f0 ("net: Distributed Switch Architecture protocol support")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Just one nit below:

> ---
>  net/dsa/slave.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 3689ffa2dbb8..dda232a8d6f5 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -798,13 +798,15 @@ static int dsa_slave_get_sset_count(struct net_device *dev, int sset)
>  	struct dsa_switch *ds = dp->ds;
>  
>  	if (sset == ETH_SS_STATS) {
> -		int count;
> +		int err = 0;
>  
> -		count = 4;
> -		if (ds->ops->get_sset_count)
> -			count += ds->ops->get_sset_count(ds, dp->index, sset);
> +		if (ds->ops->get_sset_count) {
> +			err = ds->ops->get_sset_count(ds, dp->index, sset);
> +			if (err < 0)
> +				return err;
> +		}
>  
> -		return count;

I would have a preference for keeping the count variable and treating it
specifically in case it is negative.
-- 
Florian
