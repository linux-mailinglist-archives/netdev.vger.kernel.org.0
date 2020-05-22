Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974E31DE706
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 14:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729091AbgEVMiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 08:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728495AbgEVMiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 08:38:05 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22043C061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 05:38:05 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id w7so9974218wre.13
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 05:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E/p7/YgxIPIrV3x1YMuzTllK2BJk9M6Exws4LqXZYEc=;
        b=A6UaY2yCbSg1SOoXxCskj+7ohz4EuKd7ChrNqZUO8Hbs614ptYleR/a0fM+KstU1fJ
         yXWOpBrs9fb9mFjCypO0b8RK3WxXWc3gAdBIFw0EofxplsyiPFTnKU8VRPY8ruDjAuj9
         ag5yM7DTUiiqu5/HStIlY2upo/sO9R6YdhsQ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E/p7/YgxIPIrV3x1YMuzTllK2BJk9M6Exws4LqXZYEc=;
        b=f3F4km1xHYTQBl/XHcQJQP9+yvws+ixYd/CRSlSe8YW0UpGq/Jaj9KATdpNrRmvhVP
         kssTjHiVCJdtFujGxpY97WeYcBFAlAkWQY7uy+w0/2ZUoleLxE2nmnejZUjVHDfyo2bQ
         lzPoeaD1+4LzuJrLBkioz8ujVtPsMddCilvyKK0gg37mGHGs+P3pdr0g/fCI5dyfmsBU
         DzMkxEF6ty8aCk2vfvdG06b3IjyfgZBpR5q47S1dyMuxUWGS16vsNEENpa092KKgnyG8
         5V6QgAnfywASXYqimxWG1WfKqs3iAYqna+h9warDTPuOa+El3ZA0r3P3lmoU8ZMaAWuA
         I+pA==
X-Gm-Message-State: AOAM533242ed/2juPRwUzcR0A9BFcNx90pYd3cy4soZplMMsPCOZU9Cn
        1N78IJCM8JZANHMWTyIo3HxMXA==
X-Google-Smtp-Source: ABdhPJwMi39A8SqJnuVO0NnJABWDksQfXSjFSZHopyJZ25UJSfel+Hq/lrLGqOsfx15hUh2t7k8yLw==
X-Received: by 2002:adf:a396:: with SMTP id l22mr3193535wrb.76.1590151083721;
        Fri, 22 May 2020 05:38:03 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id u74sm9640328wmu.13.2020.05.22.05.38.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2020 05:38:03 -0700 (PDT)
Subject: Re: [PATCH RFC net-next 10/13] net: bridge: add port flags for host
 flooding
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        ivecera@redhat.com, netdev@vger.kernel.org,
        horatiu.vultur@microchip.com, allan.nielsen@microchip.com,
        roopa@cumulusnetworks.com
References: <20200521211036.668624-1-olteanv@gmail.com>
 <20200521211036.668624-11-olteanv@gmail.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <a906e4d4-2551-7fe6-f2fc-6a7e77be6b4e@cumulusnetworks.com>
Date:   Fri, 22 May 2020 15:38:00 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200521211036.668624-11-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/05/2020 00:10, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> In cases where the bridge is offloaded by a switchdev, there are
> situations where we can optimize RX filtering towards the host. To be
> precise, the host only needs to do termination, which it can do by
> responding at the MAC addresses of the slave ports and of the bridge
> interface itself. But most notably, it doesn't need to do forwarding,
> so there is no need to see packets with unknown destination address.
> 
> But there are, however, cases when a switchdev does need to flood to the
> CPU. Such an example is when the switchdev is bridged with a foreign
> interface, and since there is no offloaded datapath, packets need to
> pass through the CPU. Currently this is the only identified case, but it
> can be extended at any time.
> 
> So far, switchdev implementers made driver-level assumptions, such as:
> this chip is never integrated in SoCs where it can be bridged with a
> foreign interface, so I'll just disable host flooding and save some CPU
> cycles. Or: I can never know what else can be bridged with this
> switchdev port, so I must leave host flooding enabled in any case.
> 
> Let the bridge drive the host flooding decision, and pass it to
> switchdev via the same mechanism as the external flooding flags.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  include/linux/if_bridge.h |  3 +++
>  net/bridge/br_if.c        | 40 +++++++++++++++++++++++++++++++++++++++
>  net/bridge/br_switchdev.c |  4 +++-
>  3 files changed, 46 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> index b3a8d3054af0..6891a432862d 100644
> --- a/include/linux/if_bridge.h
> +++ b/include/linux/if_bridge.h
> @@ -49,6 +49,9 @@ struct br_ip_list {
>  #define BR_ISOLATED		BIT(16)
>  #define BR_MRP_AWARE		BIT(17)
>  #define BR_MRP_LOST_CONT	BIT(18)
> +#define BR_HOST_FLOOD		BIT(19)
> +#define BR_HOST_MCAST_FLOOD	BIT(20)
> +#define BR_HOST_BCAST_FLOOD	BIT(21)
>  
>  #define BR_DEFAULT_AGEING_TIME	(300 * HZ)
>  
> diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
> index a0e9a7937412..aae59d1e619b 100644
> --- a/net/bridge/br_if.c
> +++ b/net/bridge/br_if.c
> @@ -166,6 +166,45 @@ void br_manage_promisc(struct net_bridge *br)
>  	}
>  }
>  
> +static int br_manage_host_flood(struct net_bridge *br)
> +{
> +	const unsigned long mask = BR_HOST_FLOOD | BR_HOST_MCAST_FLOOD |
> +				   BR_HOST_BCAST_FLOOD;
> +	struct net_bridge_port *p, *q;
> +
> +	list_for_each_entry(p, &br->port_list, list) {
> +		unsigned long flags = p->flags;
> +		bool sw_bridging = false;
> +		int err;
> +
> +		list_for_each_entry(q, &br->port_list, list) {
> +			if (p == q)
> +				continue;
> +
> +			if (!netdev_port_same_parent_id(p->dev, q->dev)) {
> +				sw_bridging = true;
> +				break;
> +			}
> +		}
> +
> +		if (sw_bridging)
> +			flags |= mask;
> +		else
> +			flags &= ~mask;
> +
> +		if (flags == p->flags)
> +			continue;
> +
> +		err = br_switchdev_set_port_flag(p, flags, mask);
> +		if (err)
> +			return err;
> +
> +		p->flags = flags;
> +	}
> +
> +	return 0;
> +}
> +
>  int nbp_backup_change(struct net_bridge_port *p,
>  		      struct net_device *backup_dev)
>  {
> @@ -231,6 +270,7 @@ static void nbp_update_port_count(struct net_bridge *br)
>  		br->auto_cnt = cnt;
>  		br_manage_promisc(br);
>  	}
> +	br_manage_host_flood(br);
>  }
>  

Can we do this only at port add/del ?
Right now it will be invoked also by br_port_flags_change() upon BR_AUTO_MASK flag change.

>  static void nbp_delete_promisc(struct net_bridge_port *p)
> diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> index 015209bf44aa..360806ac7463 100644
> --- a/net/bridge/br_switchdev.c
> +++ b/net/bridge/br_switchdev.c
> @@ -56,7 +56,9 @@ bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
>  
>  /* Flags that can be offloaded to hardware */
>  #define BR_PORT_FLAGS_HW_OFFLOAD (BR_LEARNING | BR_FLOOD | \
> -				  BR_MCAST_FLOOD | BR_BCAST_FLOOD)
> +				  BR_MCAST_FLOOD | BR_BCAST_FLOOD | \
> +				  BR_HOST_FLOOD | BR_HOST_MCAST_FLOOD | \
> +				  BR_HOST_BCAST_FLOOD)
>  
>  int br_switchdev_set_port_flag(struct net_bridge_port *p,
>  			       unsigned long flags,
> 

