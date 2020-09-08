Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADA32261EB8
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 21:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731087AbgIHTy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 15:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730636AbgIHPhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 11:37:36 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65677C061368
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 08:37:12 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id b6so17511910iof.6
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 08:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mqjcCvOPWxeNG4KOwOPatb8c7HQjLS+1E6RqvgTkEAE=;
        b=tnszQrdu7i0qBvDn3wTxO1FpDAhWoXERdIymbG4ZxkZgtt/YGAUnI1LMgnYUw9Q2tQ
         KNtN8chahzO7LP2lQspBdg9t8d++csT5rsqtUm/GuNltgej9ukMs0iCBKd3ua3N/kfRo
         TilBZ21e+x6F7byQbapA1QmTYv4IMBKd6pz9kPI/iuHnaL3bRS1GIp8yKhMwROVjQP1y
         GM6F6eOFLq/+9cljGpK69QFRtGe7/LI7E8x+lDLlRSaT3oRE6Zq2V2jqdcty/ReYaEsy
         RF/tnTyqpkXc4HXVmpCW0VSKqzb7slukQjfOWpWilPWUZjz6fG70X/jLW8MS3+M+B6UT
         z6pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mqjcCvOPWxeNG4KOwOPatb8c7HQjLS+1E6RqvgTkEAE=;
        b=eKR1gjkQFrox4l6wGHTRLeHxUqkFBZ1+6MVPQVhSRM9E2MmIe5TBpG1g2vUS/VZ0NA
         GhM7eMrk8e9X7gvFT+X3xJxmYkIqR6KPpb+kFBFQlKX4AXgH7vVopjWKNNSN7mL0Hj3y
         eOLgo03qjbgMegkBfPu2tYAZU5lRbkDA7QhDzdnNS2NiFpNWj8d9MLCE+kTPhnu0XJ7M
         9+nw6W02cHuujJwpjMa1KxOtdMZT29z96XyOQCtMwmN8oawxjydthhQpPdYECvNBg5ah
         m9TylyERonhMu96vLUEb8wxS8k/bNP4ri3MyWIsjISazs9ejLX6YLrBgRhr/hJ9Ov3LO
         8yyw==
X-Gm-Message-State: AOAM533qX0E+gBLO0coaYdtkLwZ3p7zn7tZom/KxNB9oIth3fSgJ8edc
        Gje0Ex0DqB2evgIbIyHxwGxgJXpd+8iL4Q==
X-Google-Smtp-Source: ABdhPJy39zbwOmBATABdcIn+AjnEnwl9Wr1JYS4qAez/E5XjJmzqJJLFxNmGoI+TepxcCGHgewDR0Q==
X-Received: by 2002:a02:9986:: with SMTP id a6mr22943772jal.28.1599579431770;
        Tue, 08 Sep 2020 08:37:11 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:ec70:7b06:eed6:6e35])
        by smtp.googlemail.com with ESMTPSA id k1sm8827938iop.42.2020.09.08.08.37.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 08:37:11 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 17/22] nexthop: Replay nexthops when
 registering a notifier
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20200908091037.2709823-1-idosch@idosch.org>
 <20200908091037.2709823-18-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8191326b-0656-e7bb-1c94-7beb9097c423@gmail.com>
Date:   Tue, 8 Sep 2020 09:37:10 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200908091037.2709823-18-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/20 3:10 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> When registering a new notifier to the nexthop notification chain,
> replay all the existing nexthops to the new notifier so that it will
> have a complete picture of the available nexthops.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 54 ++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 52 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> index b40c343ca969..6505a0a28df2 100644
> --- a/net/ipv4/nexthop.c
> +++ b/net/ipv4/nexthop.c
> @@ -156,6 +156,27 @@ static int call_nexthop_notifiers(struct net *net,
>  	return notifier_to_errno(err);
>  }
>  
> +static int call_nexthop_notifier(struct notifier_block *nb, struct net *net,
> +				 enum nexthop_event_type event_type,
> +				 struct nexthop *nh,
> +				 struct netlink_ext_ack *extack)
> +{
> +	struct nh_notifier_info info = {
> +		.net = net,
> +		.extack = extack,
> +	};
> +	int err;
> +
> +	err = nh_notifier_info_init(&info, nh);
> +	if (err)
> +		return err;
> +
> +	err = nb->notifier_call(nb, event_type, &info);
> +	nh_notifier_info_fini(&info);
> +
> +	return notifier_to_errno(err);
> +}
> +
>  static unsigned int nh_dev_hashfn(unsigned int val)
>  {
>  	unsigned int mask = NH_DEV_HASHSIZE - 1;
> @@ -2116,11 +2137,40 @@ static struct notifier_block nh_netdev_notifier = {
>  	.notifier_call = nh_netdev_event,
>  };
>  
> +static int nexthops_dump(struct net *net, struct notifier_block *nb,
> +			 struct netlink_ext_ack *extack)
> +{
> +	struct rb_root *root = &net->nexthop.rb_root;
> +	struct rb_node *node;
> +	int err = 0;
> +
> +	for (node = rb_first(root); node; node = rb_next(node)) {
> +		struct nexthop *nh;
> +
> +		nh = rb_entry(node, struct nexthop, rb_node);
> +		err = call_nexthop_notifier(nb, net, NEXTHOP_EVENT_REPLACE, nh,
> +					    extack);
> +		if (err)
> +			break;
> +	}
> +
> +	return err;
> +}
> +
>  int register_nexthop_notifier(struct net *net, struct notifier_block *nb,
>  			      struct netlink_ext_ack *extack)
>  {
> -	return blocking_notifier_chain_register(&net->nexthop.notifier_chain,
> -						nb);
> +	int err;
> +
> +	rtnl_lock();
> +	err = nexthops_dump(net, nb, extack);

can the unlock be moved here? register function below should not need it.

> +	if (err)
> +		goto unlock;
> +	err = blocking_notifier_chain_register(&net->nexthop.notifier_chain,
> +					       nb);
> +unlock:
> +	rtnl_unlock();
> +	return err;
>  }
>  EXPORT_SYMBOL(register_nexthop_notifier);
>  
> 

