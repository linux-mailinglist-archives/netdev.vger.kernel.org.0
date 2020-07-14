Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5858721F240
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 15:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728652AbgGNNQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 09:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728294AbgGNNQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 09:16:07 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710D9C061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 06:16:07 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id c80so3208210wme.0
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 06:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=l79f/bqNc9BYIqpkKbR40Mk7GQtal76rQ4QXD+nfL2Y=;
        b=XXQ7p8KyYKTbDMF3l/69Sv27LRV0Ka6JXcMwCu9L4rgoDD1xZOj0g6Sa/pTdCJ6hgg
         q0CobtyfA2V3NqePGjZVUF/K76bRgnbmwqSaS/qVPmy9Ii1Esh3OGkkgd7QKJr3IWX4b
         BU1EUdRloq0XZPEWE7ZjyUym1DIEBgzqp89No=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l79f/bqNc9BYIqpkKbR40Mk7GQtal76rQ4QXD+nfL2Y=;
        b=YczujuntLGzKc04guP5EI1oQDb5XkJYTuYeHrUNXY0wwg1iyYW3BLeOVDi3FzgURAg
         iet5OgF7Pm1Km07z8Z9BzH6fjxnsQSRLm0bFJP9jdB2Z2qT/RXC5XegmTjwzu+EM+loL
         m7OVGFAdAwW9xdRKw3igoFqI4G3DwzE2nyUnkB41hFeWq6E6bxxwAYf82eFHWReUkaET
         NCalp/7SbkhsmWvfoc7fUlHmn/paw8+Z2D8cdpP8bKWTvBPlYLvt+7O/UIZdZDClYVRs
         gZhG9qoPUwdyLbkLBDUlQiU8QUd2bKMJ2LZmwgIFfozQSfcbFIMSutRkHgbph/rHmu0E
         tfTg==
X-Gm-Message-State: AOAM533fS/3CfNjViWIMcJI3AfYOL/XFn0J2Jm9syOQqz0XuscIsYEsl
        vPXLZ1+Xjo9U84jjpyrSHqe11Q==
X-Google-Smtp-Source: ABdhPJyo0csAWOJYkjGH9aDpWd86z61HZ736Xs730a9WWVUCWSNiO7+k1NlWjvNJVUecf6+IffGdWQ==
X-Received: by 2002:a1c:e285:: with SMTP id z127mr4490370wmg.162.1594732566214;
        Tue, 14 Jul 2020 06:16:06 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 59sm30868395wrj.37.2020.07.14.06.16.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2020 06:16:05 -0700 (PDT)
Subject: Re: [PATCH net-next v4 06/12] bridge: mrp: Add br_mrp_in_port_open
 function
To:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        roopa@cumulusnetworks.com, davem@davemloft.net, kuba@kernel.org,
        jiri@resnulli.us, ivecera@redhat.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <20200714073458.1939574-1-horatiu.vultur@microchip.com>
 <20200714073458.1939574-7-horatiu.vultur@microchip.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <24df99ce-f81b-03f1-f235-e2c0ce5016f0@cumulusnetworks.com>
Date:   Tue, 14 Jul 2020 16:16:03 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200714073458.1939574-7-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/07/2020 10:34, Horatiu Vultur wrote:
> This function notifies the userspace when the node lost the continuity
> of MRP_InTest frames.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  net/bridge/br_mrp_netlink.c | 22 ++++++++++++++++++++++
>  net/bridge/br_private_mrp.h |  1 +
>  2 files changed, 23 insertions(+)
> 

Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

> diff --git a/net/bridge/br_mrp_netlink.c b/net/bridge/br_mrp_netlink.c
> index acce300c0cc29..4bf7aaeb29152 100644
> --- a/net/bridge/br_mrp_netlink.c
> +++ b/net/bridge/br_mrp_netlink.c
> @@ -389,3 +389,25 @@ int br_mrp_ring_port_open(struct net_device *dev, u8 loc)
>  out:
>  	return err;
>  }
> +
> +int br_mrp_in_port_open(struct net_device *dev, u8 loc)
> +{
> +	struct net_bridge_port *p;
> +	int err = 0;
> +
> +	p = br_port_get_rcu(dev);
> +	if (!p) {
> +		err = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (loc)
> +		p->flags |= BR_MRP_LOST_IN_CONT;
> +	else
> +		p->flags &= ~BR_MRP_LOST_IN_CONT;
> +
> +	br_ifinfo_notify(RTM_NEWLINK, NULL, p);
> +
> +out:
> +	return err;
> +}
> diff --git a/net/bridge/br_private_mrp.h b/net/bridge/br_private_mrp.h
> index e93c8f9d4df58..23da2f956ad0e 100644
> --- a/net/bridge/br_private_mrp.h
> +++ b/net/bridge/br_private_mrp.h
> @@ -75,5 +75,6 @@ int br_mrp_port_switchdev_set_role(struct net_bridge_port *p,
>  
>  /* br_mrp_netlink.c  */
>  int br_mrp_ring_port_open(struct net_device *dev, u8 loc);
> +int br_mrp_in_port_open(struct net_device *dev, u8 loc);
>  
>  #endif /* _BR_PRIVATE_MRP_H */
> 

