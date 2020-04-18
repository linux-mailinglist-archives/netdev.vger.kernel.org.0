Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04721AEAE0
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 10:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgDRIZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 04:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgDRIZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 04:25:50 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B4ABC061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 01:25:50 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id w145so3726091lff.3
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 01:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=VoBnLgHt5ybQx6Jc1Vq2lz4psLsHO2C44rjLR27+D8o=;
        b=B7XaVz+fKT74RIj6kWVjxTNgcuPRRlk6LUrEeePiwYQXLBZATqshP7u6ClFDNuXBb0
         nRl1eDhyVW70bxuJtg288gO2giQZbwx3HnBmVmiwcHHJbzL2M1YiTaPn2s8ZFn8jT6vb
         2s0wmkpWtTlmQonWpmB4TqTmRWLb+NMBBtgFI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VoBnLgHt5ybQx6Jc1Vq2lz4psLsHO2C44rjLR27+D8o=;
        b=TWem8lx4kanGEsNzEVfHAPiA4RO9+xUlTpjq4q48krMxTH0e2UILxsCWtvgk17cCNx
         VDgefbgrMJCdhhFvtAVJQiSNHeOgTbCHQgamo8FFlD2CV1gLFS5ftDGtYRji/vRqXECV
         +C3Y2K+okk3GIRj+2ZoaeBwoGB1JBtNgaTY8Yt/x9X06xgWPLUDNVSbWsmEfEDE2LhBB
         ai/T04rZ+0bQ5tMxHE8YjZEEBeJ5mwqj8wxOxG615lYgbvOyz230F7p/4RDMTODDtejO
         RXEOKaFZb/0Xi5/iQOZ0aFnaVP+Dui3LaRaaHie0ViahnKZtlDZnIm1Q14xJsWQdaLK3
         6lcg==
X-Gm-Message-State: AGi0Pua42F4AbCRbdA4lciasdpGic8voPAXd6aMYi7U5IH5Nqy6ZF76I
        LSMx6wBWZfLFKvfZ++0PQgZUaQ==
X-Google-Smtp-Source: APiQypJCHuJhL5WVOv0b0zsVDIBi+kTx4xW+yXTH575ztE10gqd9/hZ+YzmsBJx3Sm4wnzYuadpTrA==
X-Received: by 2002:ac2:4da7:: with SMTP id h7mr4424535lfe.95.1587198348684;
        Sat, 18 Apr 2020 01:25:48 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id q16sm5997552ljj.23.2020.04.18.01.25.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 01:25:47 -0700 (PDT)
Subject: Re: [RFC net-next v5 9/9] bridge: mrp: Integrate MRP into the bridge
To:     Horatiu Vultur <horatiu.vultur@microchip.com>, davem@davemloft.net,
        jiri@resnulli.us, ivecera@redhat.com, kuba@kernel.org,
        roopa@cumulusnetworks.com, olteanv@gmail.com, andrew@lunn.ch,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, UNGLinuxDriver@microchip.com
References: <20200414112618.3644-1-horatiu.vultur@microchip.com>
 <20200414112618.3644-10-horatiu.vultur@microchip.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <48c8e196-5808-d7c8-25c3-dff8f56dea5b@cumulusnetworks.com>
Date:   Sat, 18 Apr 2020 11:25:46 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200414112618.3644-10-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/04/2020 14:26, Horatiu Vultur wrote:
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
>  net/bridge/br_if.c        |  2 ++
>  net/bridge/br_input.c     |  3 +++
>  net/bridge/br_netlink.c   |  5 +++++
>  net/bridge/br_private.h   | 35 +++++++++++++++++++++++++++++++++++
>  net/bridge/br_stp.c       |  6 ++++++
>  net/bridge/br_stp_if.c    |  5 +++++
>  8 files changed, 60 insertions(+)
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
> diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
> index 4fe30b182ee7..ca685c0cdf95 100644
> --- a/net/bridge/br_if.c
> +++ b/net/bridge/br_if.c
> @@ -333,6 +333,8 @@ static void del_nbp(struct net_bridge_port *p)
>  	br_stp_disable_port(p);
>  	spin_unlock_bh(&br->lock);
>  
> +	br_mrp_port_del(br, p);
> +
>  	br_ifinfo_notify(RTM_DELLINK, NULL, p);
>  
>  	list_del_rcu(&p->list);
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
> index 43dab4066f91..8826fcd1eb76 100644
> --- a/net/bridge/br_netlink.c
> +++ b/net/bridge/br_netlink.c
> @@ -669,6 +669,11 @@ static int br_afspec(struct net_bridge *br,
>  			if (err)
>  				return err;
>  			break;
> +		case IFLA_BRIDGE_MRP:
> +			err = br_mrp_parse(br, p, attr, cmd, extack);
> +			if (err)
> +				return err;
> +			break;
>  		}
>  	}
>  
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 1f97703a52ff..5835828320b6 100644
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
> @@ -1304,6 +1308,37 @@ unsigned long br_timer_value(const struct timer_list *timer);
>  extern int (*br_fdb_test_addr_hook)(struct net_device *dev, unsigned char *addr);
>  #endif
>  
> +/* br_mrp.c */
> +#if IS_ENABLED(CONFIG_BRIDGE_MRP)
> +int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
> +		 struct nlattr *attr, int cmd, struct netlink_ext_ack *extack);
> +int br_mrp_process(struct net_bridge_port *p, struct sk_buff *skb);
> +bool br_mrp_enabled(struct net_bridge *br);
> +void br_mrp_port_del(struct net_bridge *br, struct net_bridge_port *p);
> +#else
> +static inline int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
> +			       struct nlattr *attr, int cmd,
> +			       struct netlink_ext_ack *extack)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static inline int br_mrp_process(struct net_bridge_port *p, struct sk_buff *skb)
> +{
> +	return 0;
> +}
> +
> +static inline bool br_mrp_enabled(struct net_bridge *br)
> +{
> +	return 0;
> +}
> +
> +static inline void br_mrp_port_del(struct net_bridge *br,
> +				   struct net_bridge_port *p)
> +{
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
>  	p->state = state;
>  	err = switchdev_port_attr_set(p->dev, &attr);
>  	if (err && err != -EOPNOTSUPP)
> diff --git a/net/bridge/br_stp_if.c b/net/bridge/br_stp_if.c
> index d174d3a566aa..542b212d5033 100644
> --- a/net/bridge/br_stp_if.c
> +++ b/net/bridge/br_stp_if.c
> @@ -200,6 +200,11 @@ void br_stp_set_enabled(struct net_bridge *br, unsigned long val)
>  {
>  	ASSERT_RTNL();
>  
> +	if (br_mrp_enabled(br)) {
> +		br_warn(br, "STP can't be enabled if MRP is already enabled\n");

It'd be nice if this can be returned in an extack if this function is called from netlink.
In addition this must return an error - otherwise writing to the sysfs file would be successful
while nothing will have changed, so the user will think it worked. Check out set_stp_state().
You can drop the br_warn, just make sure to return proper extack error from netlink (it is
the preferred interface over sysfs, so simply returning an error for sysfs would be enough).

> +		return;
> +	}
> +
>  	if (val) {
>  		if (br->stp_enabled == BR_NO_STP)
>  			br_stp_start(br);
> 

