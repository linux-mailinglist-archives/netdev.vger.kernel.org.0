Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A97925B55B
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 22:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgIBUfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 16:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgIBUfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 16:35:05 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D5EC061244;
        Wed,  2 Sep 2020 13:35:04 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id v4so669691wmj.5;
        Wed, 02 Sep 2020 13:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HIxWngPr+sR5zV2PQU9/b6GK/O7pBr4xcIJNAOB++EE=;
        b=UkXei5RIwuT7P869JaZz0aPmRfdwyZgc3exQJoyGoQbcS2BRfO1aHWcpBPlHHZSbvB
         CcXd9M61OaTXzV9/55jABkdzV2S6SSuuNmlKLn8ctTNz4+Nah/6hqdfdbgWhBOSFkOp2
         POPbt0ODgeqNnG/gEvoceMpkHONf30EbnT89fj68grdnI9EpkIDsdM4cDn2jRFxoBcJM
         5M8ZZP4x3uHgnKrN5+JYtzUmQpW/WesWlY2hXHE79FzF6ujQenDhWn2LL4MTk8jlEib2
         OiG0nkfOLXk/ypJOItTd3cF6ZxYXm4ndTo3QGaHlInYyNkaJlR9AieT7ZwSmemqnmmZ5
         3V9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HIxWngPr+sR5zV2PQU9/b6GK/O7pBr4xcIJNAOB++EE=;
        b=YIovXwYVQAC0hp8Qw4H7mEb1hJtmDVNZxFCBSmafNeoGPPhr1Cs5Vwo843arhWGuX6
         aEgzOQb+3VAstu3rnxGbpSAX2OkQHQA6SDtgi0zGhqJXmWzoJnB3RPaSUmy7mpGQQt/f
         hvocbG06qqKryNnf7DT3h6gfnFUYJ0Siuu9efqfesmbFD2NMLyYDopdloAVh1Pf1w7p0
         yp/4QHM+IyyrgeL1b5rOKRFlitLNDeaU2gwqEmVAvPdG5TMlD5eiRii7KpnpIZLVOFWs
         RwQiAkU7Hefc4l/3puHy3AIpF3Fsw3Ro1MdyyFPPiOa57ePDJkAveX9CqOPS5+z3A22X
         oqiw==
X-Gm-Message-State: AOAM530bV/tnytloNvChbm7NImLJd7OL47cQTGCjCUbS7rzGOarSblTc
        0cjuCdNWYZZhxSNFl4BGrTvDgzPXO0A=
X-Google-Smtp-Source: ABdhPJxVc66FmTb2h7qoW8xOK78Hvnc2OJIxFP0wblEH8E56zZE45GVoHbq53auIN5dCgQa+3DCadg==
X-Received: by 2002:a1c:988d:: with SMTP id a135mr2318472wme.8.1599078903279;
        Wed, 02 Sep 2020 13:35:03 -0700 (PDT)
Received: from [192.168.8.147] ([37.171.70.17])
        by smtp.gmail.com with ESMTPSA id b76sm1034586wme.45.2020.09.02.13.35.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 13:35:02 -0700 (PDT)
Subject: Re: [PATCHv3 net-next] dropwatch: Support monitoring of dropped
 frames
To:     izabela.bakollari@gmail.com, nhorman@tuxdriver.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
References: <20200707171515.110818-1-izabela.bakollari@gmail.com>
 <20200902171604.109864-1-izabela.bakollari@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <0b27311f-6836-45e8-6bb3-d741d37d135b@gmail.com>
Date:   Wed, 2 Sep 2020 22:35:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200902171604.109864-1-izabela.bakollari@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/2/20 10:16 AM, izabela.bakollari@gmail.com wrote:
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
> Changes in v3:
> - Name the cloned skb "nskb"
> - Remove the error log
> - Change coding style in some if statements
> ---
>  include/uapi/linux/net_dropmon.h |  3 ++
>  net/core/drop_monitor.c          | 80 ++++++++++++++++++++++++++++++++
>  2 files changed, 83 insertions(+)
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
> index 8e33cec9fc4e..ae5ed70b6b2a 100644
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
> @@ -54,6 +56,8 @@ static bool monitor_hw;
>   */
>  static DEFINE_MUTEX(net_dm_mutex);
>  
> +static DEFINE_SPINLOCK(interface_lock);
> +
>  struct net_dm_stats {
>  	u64 dropped;
>  	struct u64_stats_sync syncp;
> @@ -217,6 +221,7 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
>  	struct nlattr *nla;
>  	int i;
>  	struct sk_buff *dskb;
> +	struct sk_buff *nskb;
>  	struct per_cpu_dm_data *data;
>  	unsigned long flags;
>  
> @@ -255,6 +260,18 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
>  
>  out:
>  	spin_unlock_irqrestore(&data->lock, flags);
> +	spin_lock_irqsave(&interface_lock, flags);
> +	nskb = skb_clone(skb, GFP_ATOMIC);

1) Why calling skb_clone() if @interface is NULL ?


> +	if (!nskb) {
> +		spin_unlock_irqrestore(&interface_lock, flags);
> +		return;
> +	} else if (interface && interface != nskb->dev) {

2) Since there is no check about @interface being a dummy device,
it seems possible for a malicious user to set up another virtual
device (like bonding) so that the "interface != nskb->dev"  test
wont be able to detect a loop.

We could therefore have an infinite loop.


> +		nskb->dev = interface;
> +		spin_unlock_irqrestore(&interface_lock, flags);
> +		netif_receive_skb(nskb);



> +	} else {

 3)  nskb seems to be leaked here ? See point 1)

> +		spin_unlock_irqrestore(&interface_lock, flags);
> +	}
>  }
>  
>  static void trace_kfree_skb_hit(void *ignore, struct sk_buff *skb, void *location)
> @@ -1315,6 +1332,51 @@ static int net_dm_cmd_trace(struct sk_buff *skb,
>  	return -EOPNOTSUPP;
>  }
>  
> +static int net_dm_interface_start(struct net *net, const char *ifname)
> +{
> +	struct net_device *nd = dev_get_by_name(net, ifname);
> +
> +	if (!nd)
> +		return -ENODEV;
> +
> +	interface = nd;
> +
> +	return 0;
> +}
> +
> +static int net_dm_interface_stop(struct net *net, const char *ifname)
> +{
> +	dev_put(interface);
> +	interface = NULL;
> +
> +	return 0;
> +}
> +
> +static int net_dm_cmd_ifc_trace(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct net *net = sock_net(skb->sk);
> +	char ifname[IFNAMSIZ];
> +
> +	if (net_dm_is_monitoring())
> +		return -EBUSY;
> +
> +	memset(ifname, 0, IFNAMSIZ);
> +	nla_strlcpy(ifname, info->attrs[NET_DM_ATTR_IFNAME], IFNAMSIZ - 1);

4) info->attrs[NET_DM_ATTR_IFNAME] could be NULL at this point.

> +
> +	switch (info->genlhdr->cmd) {
> +	case NET_DM_CMD_START_IFC:

5) interface_lock is not held, this seems racy.

> +		if (interface)
> +			return -EBUSY;
> +		return net_dm_interface_start(net, ifname);
> +	case NET_DM_CMD_STOP_IFC:

6) interface_lock is not held, this seems racy.
> +		if (!interface)
> +			return -ENODEV;
> +		return net_dm_interface_stop(net, interface->name);
> +	}
> +
> +	return 0;
> +}
> +
>  static int net_dm_config_fill(struct sk_buff *msg, struct genl_info *info)
>  {
>  	void *hdr;
> @@ -1503,6 +1565,7 @@ static int dropmon_net_event(struct notifier_block *ev_block,
>  	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
>  	struct dm_hw_stat_delta *new_stat = NULL;
>  	struct dm_hw_stat_delta *tmp;
> +	unsigned long flags;
>  
>  	switch (event) {
>  	case NETDEV_REGISTER:
> @@ -1529,6 +1592,12 @@ static int dropmon_net_event(struct notifier_block *ev_block,
>  				}
>  			}
>  		}
> +		spin_lock_irqsave(&interface_lock, flags);
> +		if (interface && interface == dev) {
> +			dev_put(interface);
> +			interface = NULL;
> +		}
> +		spin_unlock_irqrestore(&interface_lock, flags);
>  		mutex_unlock(&net_dm_mutex);
>  		break;
>  	}
> @@ -1543,6 +1612,7 @@ static const struct nla_policy net_dm_nl_policy[NET_DM_ATTR_MAX + 1] = {
>  	[NET_DM_ATTR_QUEUE_LEN] = { .type = NLA_U32 },
>  	[NET_DM_ATTR_SW_DROPS]	= {. type = NLA_FLAG },
>  	[NET_DM_ATTR_HW_DROPS]	= {. type = NLA_FLAG },
> +	[NET_DM_ATTR_IFNAME] = {. type = NLA_STRING, .len = IFNAMSIZ },
>  };
>  
>  static const struct genl_ops dropmon_ops[] = {
> @@ -1570,6 +1640,16 @@ static const struct genl_ops dropmon_ops[] = {
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
