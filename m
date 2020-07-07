Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A90FE21753E
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 19:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728333AbgGGRdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 13:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727834AbgGGRdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 13:33:53 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01217C061755;
        Tue,  7 Jul 2020 10:33:53 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id x11so17014793plo.7;
        Tue, 07 Jul 2020 10:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OG2UGSwTtZ3JhpHjOf9/K5Mq8nGQGxILirbLiIW7/lE=;
        b=oGqcWcGzRQP3aQKmSSrH/bX1Vqjd9YWJebkVyo71vwBL5Eb/wsWmEczRasIBhPbV1E
         M5q3e8MIbFsgK6VLQG2nRHs2BPFDj7QYWvlVigEVb8v2fsSQZWZmP+UJNqIR74jYR3iB
         CIrh0ioE7wi9DHbES0JMF4R0ET1XGg2l+lfY+Q2ppedMJPSk901K1ULEOEoYkpoVWmpw
         5yC9Jg61OiJtbFGJopPVjZitLETsWRTmvEN3beNquwv7h/y7nq+UReiC6JEEWfOEvMq9
         sRIUgrsJGpZ5eVeWg1gdwOkUGiHfa+QBS5M/VUmSDKSPOZWXbOf1fU0t9B8uJUtz+0B/
         CsmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OG2UGSwTtZ3JhpHjOf9/K5Mq8nGQGxILirbLiIW7/lE=;
        b=bXBWn9ST2rXTkHcsqfwjzOhd3mTVTKF4of6NQWXJs4oQhxtEbvvSh0e6VIWje4+66J
         TI8YgfgRRWBER/WJMmj1nl7eS/0oicqUXsvIzuMhy1ns/R93LahR3DA2jW5iqvOS1qpt
         HDjubhYaQMGLEZCcOsXt717JuasCJudUjk6uzU9AMpzcG20eOZwvxni6iWmxX4OZb6y5
         j3gfAEQXIKdJ4CfgA2AaHxlF9Y+WDtJcYXmmq10qee2AWqIMOF0IALtNbszBLi1tFhbQ
         SovQOifWt8ZH2xx6Dqn1rzsmq9g16ETJZNJQxvBvSDpid2w1ETX9JTWtzZkT+ciTVY10
         xntQ==
X-Gm-Message-State: AOAM531xL8oFfg6vvNIDWXMAQnnTygYHFomkEyMlXQv/uYk1mI1XVyjG
        FBjabbK3lgtdlQ3xfyjzPzU=
X-Google-Smtp-Source: ABdhPJw6mDbNYNk2zkHO904T8LdoKcgLU8JjL9z3qxqChr8Ge4i6nLV465YRGMqYh2nB2zT4RpFsUw==
X-Received: by 2002:a17:90a:ce96:: with SMTP id g22mr5540446pju.9.1594143232494;
        Tue, 07 Jul 2020 10:33:52 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id i21sm7383950pfa.18.2020.07.07.10.33.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 10:33:51 -0700 (PDT)
Subject: Re: [PATCH net-next] dropwatch: Support monitoring of dropped frames
To:     izabela.bakollari@gmail.com, nhorman@tuxdriver.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
References: <20200707171515.110818-1-izabela.bakollari@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <8aa6bcfe-8117-0fc9-1bc5-9b6a600e0972@gmail.com>
Date:   Tue, 7 Jul 2020 10:33:50 -0700
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

This change seems unrelated ?

And also buggy, since data is essentially garbage when you call spin_lock_irqsave(&data->lock, flags);

>  	dskb = data->skb;
>  
>  	if (!dskb)
> @@ -255,6 +256,12 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
>  
>  out:
>  	spin_unlock_irqrestore(&data->lock, flags);
> +
> +	if (interface && interface != skb->dev) {
> +		skb = skb_clone(skb, GFP_ATOMIC);

skb_clone() can return NULL

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
> +		dev_hold(interface);
> +	} else {
> +		return -ENODEV;
> +	}
> +	return 0;
> +}
> +


What happens after this monitoring is started, then the admin does :

rmmod ifb


