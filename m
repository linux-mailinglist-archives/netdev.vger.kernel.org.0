Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6B72175A4
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 19:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbgGGRwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 13:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728297AbgGGRwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 13:52:37 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6122FC061755;
        Tue,  7 Jul 2020 10:52:37 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id m22so9977467pgv.9;
        Tue, 07 Jul 2020 10:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GYX4tTYyxLfkm2WsVXxZPveW6hzan+/DPaAowNfvqLA=;
        b=cb585bb4ltXfoM2cMOXjwfJQzyHTR072WgUGpAWqSWdj4xJMI40dXY8q95yvnMJ3sc
         Wptvu9FnaRYyPnhwpOK/FaUC0NH6NgO8j6WOK7XsIJv8kX3XzYd+ir3kKda4JqGh4sDx
         hbK1swyt2Ukx5wocq6mXcEV52Z8qFmAQpx65ZJ6yMPcMO5cLozL4FtLcVCiKCAvJTuuU
         wV64TZIxJogEfxkFDyZtkwSQUUteJz+kFuS68FZC5uIR1vGDychH95HNgriK2Sr6JJIv
         Z4vu+W1i7WaTc5dQPH9zUgaboftpMf21wzDkBe0/e7HwPbIdFjFfXAxXV4lMa6Jb/MUw
         F0iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GYX4tTYyxLfkm2WsVXxZPveW6hzan+/DPaAowNfvqLA=;
        b=RQdU2zUmpjDHEfgxpYPgnVH0her6Owoh9inlQchPRQbVw7na+53YgB5fOX7pO5QvWd
         vx8UERq3czypWOy/CkHpphk2+4QajWl1sLaflkznDI0obJRRzg9YQ1ZphUv91rc1IRwI
         tBmCSsu+K6HqXjxDY4k5O68hz1IGgxiIdd5mjVYC6aaJa0ZmTU60Yr1sUTv6conS4vsW
         HY09t35tU2wSFOs1m6oouQNgDwhEhI0t/AzPxY/ezCsP7geinXKasC6U1VGObWl9Y7YS
         iEtyOc532lRmhfsoSLeyx5sYTdL5zAOoYa3ZzFV44g7t0kskYMFZXrQp7ZPRVnRHPeDF
         WvSw==
X-Gm-Message-State: AOAM531H+HjKk75Cas+szJqlmmXnQh7c0xt7PsYdm4xMOcywkOdVmOb4
        vYD/p5l73XH6UOEqOaCywtM=
X-Google-Smtp-Source: ABdhPJzRiRAZz9+f3HOJ8YRC8hoFKlqkglXlexmMj/JMKbuMCWnvek4e9ON5JscghSY0tb7ohV/HlQ==
X-Received: by 2002:a63:481:: with SMTP id 123mr43035507pge.2.1594144356931;
        Tue, 07 Jul 2020 10:52:36 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id f207sm23576303pfa.107.2020.07.07.10.52.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 10:52:36 -0700 (PDT)
Subject: Re: [PATCH net-next] dropwatch: Support monitoring of dropped frames
To:     izabela.bakollari@gmail.com, nhorman@tuxdriver.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
References: <20200707171515.110818-1-izabela.bakollari@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <647a37da-cd95-b84b-bc76-036a813c00e2@gmail.com>
Date:   Tue, 7 Jul 2020 10:52:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200707171515.110818-1-izabela.bakollari@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/7/20 10:15 AM, izabela.bakollari@gmail.com wrote:
> From: Izabela Bakollari <izabela.bakollari@gmail.com>
> 
> Dropwatch is a utility that monitors dropped frames by having userspace
> record them over the dropwatch protocol over a file. This augument
> allows live monitoring of dropped frames using tools like tcpdump.
> 
> With this feature, dropwatch allows two additional commands (start and
> stop interface) which allows the assignment of a net_device to the
> dropwatch protocol. When assinged, dropwatch will clone dropped frames,
> and receive them on the assigned interface, allowing tools like tcpdump
> to monitor for them.
> 
> With this feature, create a dummy ethernet interface (ip link add dev
> dummy0 type dummy), assign it to the dropwatch kernel subsystem, by using
> these new commands, and then monitor dropped frames in real time by
> running tcpdump -i dummy0.
> 
> Signed-off-by: Izabela Bakollari <izabela.bakollari@gmail.com>
> ---
>  include/uapi/linux/net_dropmon.h |  3 ++
>  net/core/drop_monitor.c          | 79 +++++++++++++++++++++++++++++++-
>  2 files changed, 80 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
> index 67e31f329190..e8e861e03a8a 100644
> --- a/include/uapi/linux/net_dropmon.h
> +++ b/include/uapi/linux/net_dropmon.h
> @@ -58,6 +58,8 @@ enum {
>  	NET_DM_CMD_CONFIG_NEW,
>  	NET_DM_CMD_STATS_GET,
>  	NET_DM_CMD_STATS_NEW,
> +	NET_DM_CMD_START_IFC,
> +	NET_DM_CMD_STOP_IFC,
>  	_NET_DM_CMD_MAX,
>  };
>  
> @@ -93,6 +95,7 @@ enum net_dm_attr {
>  	NET_DM_ATTR_SW_DROPS,			/* flag */
>  	NET_DM_ATTR_HW_DROPS,			/* flag */
>  	NET_DM_ATTR_FLOW_ACTION_COOKIE,		/* binary */
> +	NET_DM_ATTR_IFNAME,			/* string */
>  
>  	__NET_DM_ATTR_MAX,
>  	NET_DM_ATTR_MAX = __NET_DM_ATTR_MAX - 1
> diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
> index 8e33cec9fc4e..8049bff05abd 100644
> --- a/net/core/drop_monitor.c
> +++ b/net/core/drop_monitor.c
> @@ -30,6 +30,7 @@
>  #include <net/genetlink.h>
>  #include <net/netevent.h>
>  #include <net/flow_offload.h>
> +#include <net/sock.h>
>  
>  #include <trace/events/skb.h>
>  #include <trace/events/napi.h>
> @@ -46,6 +47,7 @@
>   */
>  static int trace_state = TRACE_OFF;
>  static bool monitor_hw;
> +struct net_device *interface;
>  
>  /* net_dm_mutex
>   *
> @@ -220,9 +222,8 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
>  	struct per_cpu_dm_data *data;
>  	unsigned long flags;
>  
> -	local_irq_save(flags);
> +	spin_lock_irqsave(&data->lock, flags);
>  	data = this_cpu_ptr(&dm_cpu_data);
> -	spin_lock(&data->lock);
>  	dskb = data->skb;
>  
>  	if (!dskb)
> @@ -255,6 +256,12 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
>  
>  out:
>  	spin_unlock_irqrestore(&data->lock, flags);
> +

What protects interface from being changed under us by another thread/cpu ?

> +	if (interface && interface != skb->dev) {
> +		skb = skb_clone(skb, GFP_ATOMIC);
> +		skb->dev = interface;
> +		netif_receive_skb(skb);
> +	}
>  }
>  
>  static void trace_kfree_skb_hit(void *ignore, struct sk_buff *skb, void *location)
> @@ -1315,6 +1322,63 @@ static int net_dm_cmd_trace(struct sk_buff *skb,
>  	return -EOPNOTSUPP;
>  }
>  
> +static int net_dm_interface_start(struct net *net, const char *ifname)
> +{
> +	struct net_device *nd;
> +
> +	nd = dev_get_by_name(net, ifname);
> +
> +	if (nd) {
> +		interface = nd;

If interface was already set, you forgot to dev_put() it.

> +		dev_hold(interface);

Note that dev_get_by_name() already did a dev_hold()

> +	} else {
> +		return -ENODEV;
> +	}
> +	return 0;
> +}
> +
> +static int net_dm_interface_stop(struct net *net, const char *ifname)
> +{
> +	struct net_device *nd;
> +
> +	nd = dev_get_by_name(net, ifname);
> +
> +	if (nd) {



> +		interface = nd;


You probably meant : interface = NULL; ?

> +		dev_put(interface);

		and dev_put(nd);


> +	} else {
> +		return -ENODEV;
> +	}
> +	return 0;
> +}
> +
> +static int net_dm_cmd_ifc_trace(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct net *net = sock_net(skb->sk);
> +	char ifname[IFNAMSIZ];
> +	int rc;
> +
> +	memset(ifname, 0, IFNAMSIZ);
> +	nla_strlcpy(ifname, info->attrs[NET_DM_ATTR_IFNAME], IFNAMSIZ - 1);
> +
> +	switch (info->genlhdr->cmd) {
> +	case NET_DM_CMD_START_IFC:
> +		rc = net_dm_interface_start(net, ifname);
> +		if (rc)
> +			return rc;
> +		break;
> +	case NET_DM_CMD_STOP_IFC:
> +		if (interface) {
> +			rc = net_dm_interface_stop(net, interface->ifname);
> +			return rc;
> +		} else {
> +			return -ENODEV;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  static int net_dm_config_fill(struct sk_buff *msg, struct genl_info *info)
>  {
>  	void *hdr;
> @@ -1543,6 +1607,7 @@ static const struct nla_policy net_dm_nl_policy[NET_DM_ATTR_MAX + 1] = {
>  	[NET_DM_ATTR_QUEUE_LEN] = { .type = NLA_U32 },
>  	[NET_DM_ATTR_SW_DROPS]	= {. type = NLA_FLAG },
>  	[NET_DM_ATTR_HW_DROPS]	= {. type = NLA_FLAG },
> +	[NET_DM_ATTR_IFNAME] = {. type = NLA_STRING, .len = IFNAMSIZ },
>  };
>  
>  static const struct genl_ops dropmon_ops[] = {
> @@ -1570,6 +1635,16 @@ static const struct genl_ops dropmon_ops[] = {
>  		.cmd = NET_DM_CMD_STATS_GET,
>  		.doit = net_dm_cmd_stats_get,
>  	},
> +	{
> +		.cmd = NET_DM_CMD_START_IFC,
> +		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
> +		.doit = net_dm_cmd_ifc_trace,
> +	},
> +	{
> +		.cmd = NET_DM_CMD_STOP_IFC,
> +		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
> +		.doit = net_dm_cmd_ifc_trace,
> +	},
>  };
>  
>  static int net_dm_nl_pre_doit(const struct genl_ops *ops,
> 
