Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B08D694BE6
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 19:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbfHSRmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 13:42:46 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34466 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728251AbfHSRmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 13:42:45 -0400
Received: by mail-qk1-f196.google.com with SMTP id m10so2140463qkk.1
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 10:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dpQ+m9fFauFKcfiu/iFsTj62Kt4IUs7CkAxfpKuwSxw=;
        b=iFBTXS477Ca//GHDtQfov6tsqeeHKSTp/NPMzhqv0YXZA3d3CZOuiXYWReXAULO1dR
         6yK/OUh8ELfUxgnX87yOmfto+KplxwbiPXahQozVU4oZYcx+BWm52OzC89LjP5vwRaQN
         PWXA2Mv11w/nqBaDU2GLrRfSRujCtJ82qOXZZG6+ZJN6ySUHxCm+K59JGGMKrXpb7RZH
         J7n620jqBXkD0qPEKLlaqzusKR9kuuXpalCR6Fopo87nSdQsUdtv/q7n4QzzllypG9c1
         inJd413bQ7TbbXReq2ZNsP8g+ZvqBLA14jsZTL/77OMBNur4DGLC0VFa0wRMPeYb3J+k
         vSPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dpQ+m9fFauFKcfiu/iFsTj62Kt4IUs7CkAxfpKuwSxw=;
        b=qH7aSkWLBjwOHIFyZ8491xffZjahCga7KDNNNAu5gKwrx/NXXv9ZjwRuc7Eaw0u1R4
         qP8DFe+wlRQFuwvRckj4T7drUn0TZDhh0d/9pYj3675Wz6M9PfoZS/otL3PliM+F6/9Q
         6pWaH58hI9CY7UUps2lcZfEndte1QQBF5eOoPrMnr6UzD+LOEN8KPQMALjZOX+8uXSOd
         hixTXeUElcqVMDzMf9132qvtt9/Un/Java1IllEgW1WMQPkSxYxW4GJzrKAj1N9BS409
         knjC/PK47/tbdP3NC1MmmfvVstK+4K86QTMlJUIUXYy9d7J7F1E6UbpMsZlmrf2UcA7I
         RgsQ==
X-Gm-Message-State: APjAAAXSZJnDLkGUcuuNoMdAaAjKVZSShsnUskaE/YZtz6ZehR71Kfli
        J3FavsKibOQiMPdq/YeE0dB7vSP/g4k=
X-Google-Smtp-Source: APXvYqzUMLYWwdt/n/AskIgqvwP9D+VCMnGJEs3GAB6FfAq0b16+gmPKwsMgvS8OPOanq0V+y1uWBA==
X-Received: by 2002:a37:e306:: with SMTP id y6mr21876209qki.174.1566236564637;
        Mon, 19 Aug 2019 10:42:44 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:9612:ee2d:14b6:21a2:1362])
        by smtp.gmail.com with ESMTPSA id i62sm7236767qke.52.2019.08.19.10.42.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 10:42:43 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 577D8C1D94; Mon, 19 Aug 2019 14:42:41 -0300 (-03)
Date:   Mon, 19 Aug 2019 14:42:41 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Pravin B Shelar <pshelar@ovn.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Justin Pettit <jpettit@nicira.com>,
        Simon Horman <simon.horman@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>
Subject: Re: [PATCH net-next] net: openvswitch: Set OvS recirc_id from tc
 chain
Message-ID: <20190819174241.GE2699@localhost.localdomain>
References: <1566144059-8247-1-git-send-email-paulb@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566144059-8247-1-git-send-email-paulb@mellanox.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 18, 2019 at 07:00:59PM +0300, Paul Blakey wrote:
> What do you guys say about the following diff on top of the last one?
> Use static key, and also have OVS_DP_CMD_SET command probe/enable the feature.
> 
> This will allow userspace to probe the feature, and selectivly enable it via the
> OVS_DP_CMD_SET command.

I'm not convinced yet that we need something like this. Been
wondering, skb_ext_find() below is not that expensive if not in use.
It's just a bit check and that's it, it returns NULL.

And drivers will only be setting this if they have tc-offloading
enabled (assuming they won't be seeing it for chain 0 all the time).
On which case, with tc offloading, we need this in order to work
properly.

Is the bit checking really that worrysome?

> --- a/net/openvswitch/flow.c
> +++ b/net/openvswitch/flow.c
> @@ -853,8 +853,10 @@ int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
>  	key->mac_proto = res;
>  
>  #if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
> -	tc_ext = skb_ext_find(skb, TC_SKB_EXT);
> -	key->recirc_id = tc_ext ? tc_ext->chain : 0;
> +	if (static_branch_unlikely(&tc_recirc_sharing_support)) {
> +		tc_ext = skb_ext_find(skb, TC_SKB_EXT);
> +		key->recirc_id = tc_ext ? tc_ext->chain : 0;
> +	}
>  #else
>  	key->recirc_id = 0;
>  #endif
> -- 
> 1.8.3.1
> 
