Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76726A57C8
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 15:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730853AbfIBNh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 09:37:58 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33543 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730221AbfIBNh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 09:37:58 -0400
Received: by mail-pg1-f196.google.com with SMTP id n190so7512876pgn.0
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 06:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=R2kT+EDCjoTYtbweP2NNWxfQ/jmEjfkxLoHnyT1sMuA=;
        b=cGh364n+gbziAUl7Q9qN0WUXe46tikWYNCznBe12f0+1qCpAibSfsxZDruErVREbNn
         3q/yxXgUtDENsF2i27gePHsEWfseqd8DCEZrizvlD31zLrgHN3wkn2pcWbHYpIoFgGqE
         mqTvKliukSgpbI5V3zuvI+4Pv5LVSgw267MCHcZ952GJlHzEKeZ9Ob9BiEinq9CCdaoZ
         TQwQkosL54fIjAKdbDOs7/tsJjV2F4kP+bnoRRTgLQocWSthbCJEHTLqC1j0J0tq5gxW
         kdZqLRhz9VdcAx5eAYGJKUQxqJruqp1adIYmHhpzesckHc8epd2bkK3G3KrPE6AxDtUn
         sFOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R2kT+EDCjoTYtbweP2NNWxfQ/jmEjfkxLoHnyT1sMuA=;
        b=Fnl6hgtpqxRFQvpBlqWJnUkcgkaT3xAcN0zMUGm4rWAcF4mRK9dzAsXV64zmoAUe7+
         0izrjeMDTkdGw8RBUVGmLBDeDKv92Q2j/nlGqS0MKzryZt1s6ow7Qf7onEjvFwXNu2I5
         6+Meo7mEcYCOkQ0tO5ik74b7th3BGR1jzIpRDWz8JfVNpPmMCJo7Xw9bnM7P3ywhqln8
         S4YWIYOXyAn0R22VdwCOar8y83pUt+XeYmUDe60mqA/hVWX9ouN4Hu7JQ4ju1tDwiPML
         eBluGwB5rdBMk2b0nj1JxAiLp7gp3dgmtyUGltea7tpSXBc5oZ8NVTo97lGteOBO6fNw
         RlLQ==
X-Gm-Message-State: APjAAAX1uePLfqPqhHSJ5U3P4hdsQEpbkoEBF9kGDmXAFraI1+y2xoK+
        Kr5hB8MmmqXmz2OUlu8YJXqeBUz3
X-Google-Smtp-Source: APXvYqyTjN2MRiZfqDuuDCoxqZgqVIq72NImfux1KIhDzzY+H5o+ulxZMBHEbSWDoptYYp/9ENvfrw==
X-Received: by 2002:aa7:939c:: with SMTP id t28mr35723536pfe.111.1567431477805;
        Mon, 02 Sep 2019 06:37:57 -0700 (PDT)
Received: from [192.168.1.82] (host-184-167-6-196.jcs-wy.client.bresnan.net. [184.167.6.196])
        by smtp.googlemail.com with ESMTPSA id k5sm14345931pjs.1.2019.09.02.06.37.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Sep 2019 06:37:56 -0700 (PDT)
Subject: Re: [PATCH] net-ipv6: fix excessive RTF_ADDRCONF flag on ::1/128
 local route (and others)
To:     =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <zenczykowski@gmail.com>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20190901174759.257032-1-zenczykowski@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <565e386f-e72a-73db-1f34-fedb5190658a@gmail.com>
Date:   Mon, 2 Sep 2019 07:37:54 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190901174759.257032-1-zenczykowski@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/1/19 11:47 AM, Maciej Żenczykowski wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> There is a subtle change in behaviour introduced by:
>   commit c7a1ce397adacaf5d4bb2eab0a738b5f80dc3e43
>   'ipv6: Change addrconf_f6i_alloc to use ip6_route_info_create'
> 
> Before that patch /proc/net/ipv6_route includes:
> 00000000000000000000000000000001 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000003 00000000 80200001 lo
> 
> Afterwards /proc/net/ipv6_route includes:
> 00000000000000000000000000000001 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000002 00000000 80240001 lo
> 
> ie. the above commit causes the ::/128 local (automatic) route to be flagged with RTF_ADDRCONF (0x040000).

The ADDRCONF flag is wrong.

> 
> AFAICT, this is incorrect since these routes are *not* coming from RA's.
> 
> As such, this patch restores the old behaviour.
> 
> Fixes: c7a1ce397adacaf5d4bb2eab0a738b5f80dc3e43
> Cc: David Ahern <dsahern@gmail.com>
> Signed-off-by: Maciej Żenczykowski <maze@google.com>
> ---
>  net/ipv6/route.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 558c6c68855f..cee977e52d34 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -4365,13 +4365,14 @@ struct fib6_info *addrconf_f6i_alloc(struct net *net,
>  	struct fib6_config cfg = {
>  		.fc_table = l3mdev_fib_table(idev->dev) ? : RT6_TABLE_LOCAL,
>  		.fc_ifindex = idev->dev->ifindex,
> -		.fc_flags = RTF_UP | RTF_ADDRCONF | RTF_NONEXTHOP,
> +		.fc_flags = RTF_UP | RTF_NONEXTHOP,
>  		.fc_dst = *addr,
>  		.fc_dst_len = 128,
>  		.fc_protocol = RTPROT_KERNEL,
>  		.fc_nlinfo.nl_net = net,
>  		.fc_ignore_dev_down = true,
>  	};
> +	struct fib6_info *f6i;
>  
>  	if (anycast) {
>  		cfg.fc_type = RTN_ANYCAST;
> @@ -4381,7 +4382,9 @@ struct fib6_info *addrconf_f6i_alloc(struct net *net,
>  		cfg.fc_flags |= RTF_LOCAL;
>  	}
>  
> -	return ip6_route_info_create(&cfg, gfp_flags, NULL);
> +	f6i = ip6_route_info_create(&cfg, gfp_flags, NULL);

ip6_route_info_create can return NULL.



> +	f6i->dst_nocount = true;
> +	return f6i;
>  }
>  
>  /* remove deleted ip from prefsrc entries */
> 

