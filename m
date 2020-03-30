Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31DB71980BA
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 18:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbgC3QQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 12:16:24 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45576 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728162AbgC3QQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 12:16:24 -0400
Received: by mail-lj1-f194.google.com with SMTP id t17so18749327ljc.12
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 09:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=QpOIR907T/wwW05Dr6k2YR4q9EgvViup03SDjAZ1IS8=;
        b=dHFrXjAmgcscbhtftarqXEKgpHNJjgzLjsFlYUUJhkt7ypj5szHz/C0tGLKYgz1Vi3
         aADxpw2+tymWuQokvjIDaWdUsfDelM6zMTWOmVeNExCybqzT3LP7UcC5Mjn0UMj2IUXb
         nev8nr2pqUrpwP8dKOXZ4YUAjMZ+w6aO7YYIs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QpOIR907T/wwW05Dr6k2YR4q9EgvViup03SDjAZ1IS8=;
        b=NinIft/3NhNxt/QWmX1mRf0PJZ3p6qm0FDfu3A7kjdtTFcEAIwkhjEmbeZhEDfd+kN
         mUOBYqbH/AquWmttLeL/odVVlZ6Lt6CIU5VbXVzCxJs93G2p7QIPVf8FInxUIgDJR1Wo
         Mc5ugKJ8jU4H8GJrhzkfcWaTBHPOJxiPkxVNT+mrbuFwAPHWiLwp/q12ND9EQ8joxGos
         WR7SSqCbStG9ZqhSWVqf9F6XANLsEbqbcVnEok4jIDYDpqI8IvZDiDEy5SJAehe7xC3B
         9/vOR8W0XMe9o7kuDOPQ1jeQehpbS4B4LzSbzh3Uuhs8LNNY5llVQ11ZmP/1WyOYiQss
         L+rw==
X-Gm-Message-State: AGi0Pub3jNL2ckrGau9PYkww4kvtx7LDCDdw273HtpH3rPmz3PW9gbQ3
        60UUhRwVEWGwmx04LOKFgBnOsg==
X-Google-Smtp-Source: APiQypKRHK7B+ad3csMViQHoxs0tbVmW7H4M9/KVXhe2awqHXEc4j2Yy5xoqdIKOM2hWBEJ81tG9sA==
X-Received: by 2002:a2e:97cd:: with SMTP id m13mr7795367ljj.20.1585584981318;
        Mon, 30 Mar 2020 09:16:21 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id i20sm476679lja.17.2020.03.30.09.16.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2020 09:16:20 -0700 (PDT)
Subject: Re: [RFC net-next v4 8/9] bridge: mrp: Integrate MRP into the bridge
To:     Horatiu Vultur <horatiu.vultur@microchip.com>, davem@davemloft.net,
        jiri@resnulli.us, ivecera@redhat.com, kuba@kernel.org,
        roopa@cumulusnetworks.com, olteanv@gmail.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
References: <20200327092126.15407-1-horatiu.vultur@microchip.com>
 <20200327092126.15407-9-horatiu.vultur@microchip.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <17d9fb2a-cb48-7bb6-cb79-3876ca3a74b2@cumulusnetworks.com>
Date:   Mon, 30 Mar 2020 19:16:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200327092126.15407-9-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/03/2020 11:21, Horatiu Vultur wrote:
> To integrate MRP into the bridge, the bridge needs to do the following:
> - add new flag(BR_MPP_AWARE) to the net bridge ports, this bit will be set when
>   the port is added to an MRP instance. In this way it knows if the frame was
>   received on MRP ring port
> - detect if the MRP frame was received on MRP ring port in that case it would be
>   processed otherwise just forward it as usual.
> - enable parsing of MRP
> - before whenever the bridge was set up, it would set all the ports in
>   forwarding state. Add an extra check to not set ports in forwarding state if
>   the port is an MRP ring port. The reason of this change is that if the MRP
>   instance initially sets the port in blocked state by setting the bridge up it
>   would overwrite this setting.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  include/linux/if_bridge.h |  1 +
>  net/bridge/br_device.c    |  3 +++
>  net/bridge/br_input.c     |  3 +++
>  net/bridge/br_netlink.c   |  5 +++++
>  net/bridge/br_private.h   | 22 ++++++++++++++++++++++
>  net/bridge/br_stp.c       |  6 ++++++
>  6 files changed, 40 insertions(+)
> 
> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> index 9e57c4411734..10baa9efdae8 100644
> --- a/include/linux/if_bridge.h
> +++ b/include/linux/if_bridge.h
> @@ -47,6 +47,7 @@ struct br_ip_list {
>  #define BR_BCAST_FLOOD		BIT(14)
>  #define BR_NEIGH_SUPPRESS	BIT(15)
>  #define BR_ISOLATED		BIT(16)
> +#define BR_MRP_AWARE		BIT(17)
>  
>  #define BR_DEFAULT_AGEING_TIME	(300 * HZ)
>  
> diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
> index 0e3dbc5f3c34..8ec1362588af 100644
> --- a/net/bridge/br_device.c
> +++ b/net/bridge/br_device.c
> @@ -463,6 +463,9 @@ void br_dev_setup(struct net_device *dev)
>  	spin_lock_init(&br->lock);
>  	INIT_LIST_HEAD(&br->port_list);
>  	INIT_HLIST_HEAD(&br->fdb_list);
> +#if IS_ENABLED(CONFIG_BRIDGE_MRP)
> +	INIT_LIST_HEAD(&br->mrp_list);
> +#endif
>  	spin_lock_init(&br->hash_lock);
>  
>  	br->bridge_id.prio[0] = 0x80;
> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> index fcc260840028..d5c34f36f0f4 100644
> --- a/net/bridge/br_input.c
> +++ b/net/bridge/br_input.c
> @@ -342,6 +342,9 @@ rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
>  		}
>  	}
>  
> +	if (unlikely(br_mrp_process(p, skb)))
> +		return RX_HANDLER_PASS;
> +
>  forward:
>  	switch (p->state) {
>  	case BR_STATE_FORWARDING:
> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> index 43dab4066f91..77bc96745be6 100644
> --- a/net/bridge/br_netlink.c
> +++ b/net/bridge/br_netlink.c
> @@ -669,6 +669,11 @@ static int br_afspec(struct net_bridge *br,
>  			if (err)
>  				return err;
>  			break;
> +		case IFLA_BRIDGE_MRP:
> +			err = br_mrp_parse(br, p, attr, cmd);
> +			if (err)
> +				return err;
> +			break;
>  		}
>  	}
>  
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 1f97703a52ff..38894f2cf98f 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -428,6 +428,10 @@ struct net_bridge {
>  	int offload_fwd_mark;
>  #endif
>  	struct hlist_head		fdb_list;
> +
> +#if IS_ENABLED(CONFIG_BRIDGE_MRP)
> +	struct list_head		__rcu mrp_list;
> +#endif
>  };
>  
>  struct br_input_skb_cb {
> @@ -1304,6 +1308,24 @@ unsigned long br_timer_value(const struct timer_list *timer);
>  extern int (*br_fdb_test_addr_hook)(struct net_device *dev, unsigned char *addr);
>  #endif
>  
> +/* br_mrp.c */
> +#if IS_ENABLED(CONFIG_BRIDGE_MRP)
> +int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
> +		 struct nlattr *attr, int cmd);
> +int br_mrp_process(struct net_bridge_port *p, struct sk_buff *skb);
> +#else
> +static inline int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
> +			       struct nlattr *attr, int cmd)
> +{
> +	return -1;

You should return proper error here.

> +}
> +
> +static inline int br_mrp_process(struct net_bridge_port *p, struct sk_buff *skb)
> +{
> +	return -1;

The bridge can't possibly work with MRP disabled with this.

> +}
> +#endif
> +
>  /* br_netlink.c */
>  extern struct rtnl_link_ops br_link_ops;
>  int br_netlink_init(void);
> diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
> index 1f14b8455345..3e88be7aa269 100644
> --- a/net/bridge/br_stp.c
> +++ b/net/bridge/br_stp.c
> @@ -36,6 +36,12 @@ void br_set_state(struct net_bridge_port *p, unsigned int state)
>  	};
>  	int err;
>  
> +	/* Don't change the state of the ports if they are driven by a different
> +	 * protocol.
> +	 */
> +	if (p->flags & BR_MRP_AWARE)
> +		return;
> +

Maybe disallow STP type (kernel/user-space/no-stp) changing as well, force it to no-stp.

>  	p->state = state;
>  	err = switchdev_port_attr_set(p->dev, &attr);
>  	if (err && err != -EOPNOTSUPP)
> 

