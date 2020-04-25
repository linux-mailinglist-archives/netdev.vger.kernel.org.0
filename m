Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B245B1B87AB
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 18:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbgDYQTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 12:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbgDYQTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 12:19:17 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0A4C09B04D;
        Sat, 25 Apr 2020 09:19:14 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id i19so13977384ioh.12;
        Sat, 25 Apr 2020 09:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k+l2Dw/0DdtUd1lcg1ku8NU/TmLLMdmDMb3p6NrvwZ8=;
        b=fq1CHCG0feG/vV4mbXm4WQ2e8G50Ya0rcOTwBzJ2wUZZRrChMALbHgBPEyMGRAIhqc
         Eu70Qevd5MdWQZB44t89Hovz7ltKNqDKghFCgvrYzGhaNynD/pYvBc4QIl6WmUjwiAXD
         4kBySOO0Quqfkc53pEG4Vk7Lm7+hsP2NIcHdir+9sujyEfxYE0mS+8fyk7XSEjyKm8xf
         H0cgJGUQ6Asa7VSdx2fZKl1vFqGiW/6PWEanYq2Ri8I/Lq7kPELvQK5F5kMph0Ls98nm
         gQKLgfUMg3T23DqAINAHAKfHaEKMmTQVBhdphFBGXx6pxmIMNySrcXbHkXAL3TA5zvgr
         pGyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k+l2Dw/0DdtUd1lcg1ku8NU/TmLLMdmDMb3p6NrvwZ8=;
        b=UVUHpJc/KMveEaX/9D1pZwf7vwNrIcJpkUzpt2OULE8rKK6ge7J7j15ZufuhLagVD7
         R7G/KUujb8qNUO1FuaNMyafvfMY5FxB6YcnydFY4JzgKtVfri3uorCEYni3f5IJamOqP
         GGR0Jw78UDB6Z6M8zlUr7VEoJXYz6Yhpa9rEUeRyzY0syx7xSlOjtiq3CCtBFGV2Jqir
         5uKRGHzrEjP1NP+bRnRqDwe1GDxmdrD2srUfttr3NsepfGXY26LpN56QOhz8V8LWZWa8
         XHSL8nLkI5IxK3xTC9eRc+k0uxnGtMA2Yx+5QntGEX7Dbs6Lh+oSE/tDFGGynu5REJiY
         6jpQ==
X-Gm-Message-State: AGi0PuZ1t19Y7E/JTAossU2k2mgjZupnuRdoxolWEZNdCY3+HQbR81oi
        W2G3Y+cMqIAZ3y5JkZlQPn0=
X-Google-Smtp-Source: APiQypKy8jXL/VhrlWkqC/f7r8T4pRuZZrYoFxXhsubXRXR9ubcWrR69AiyQGuQnVB627oMQ2AL+QA==
X-Received: by 2002:a02:9f94:: with SMTP id a20mr13137782jam.40.1587831554139;
        Sat, 25 Apr 2020 09:19:14 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:7013:38e0:b27:9cc3? ([2601:282:803:7700:7013:38e0:b27:9cc3])
        by smtp.googlemail.com with ESMTPSA id o19sm3375056ild.42.2020.04.25.09.19.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Apr 2020 09:19:13 -0700 (PDT)
Subject: Re: [PATCH V5 mlx5-next 01/16] net/core: Introduce
 netdev_get_xmit_slave
To:     Maor Gottlieb <maorg@mellanox.com>, davem@davemloft.net,
        jgg@mellanox.com, dledford@redhat.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        jiri@mellanox.com, dsahern@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com
References: <20200423125555.21759-1-maorg@mellanox.com>
 <20200423125555.21759-2-maorg@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3d68acb4-b20d-ac02-1499-e4279abb9f34@gmail.com>
Date:   Sat, 25 Apr 2020 10:19:12 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200423125555.21759-2-maorg@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/23/20 6:55 AM, Maor Gottlieb wrote:
> Add new ndo to get the xmit slave of master device.
> Caller should call dev_put() when it no longer works with
> slave netdevice.

description needs to be updated.

> User can ask to get the xmit slave assume all the slaves can
> transmit by set all_slaves arg to true.
> 
> Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
> ---
>  include/linux/netdevice.h |  6 ++++++
>  net/core/dev.c            | 22 ++++++++++++++++++++++
>  2 files changed, 28 insertions(+)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 130a668049ab..d1206f08e099 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1389,6 +1389,9 @@ struct net_device_ops {
>  						 struct netlink_ext_ack *extack);
>  	int			(*ndo_del_slave)(struct net_device *dev,
>  						 struct net_device *slave_dev);
> +	struct net_device*	(*ndo_get_xmit_slave)(struct net_device *dev,
> +						      struct sk_buff *skb,
> +						      bool all_slaves);

documentation above struct net_device_ops { }; needs to be updated.

>  	netdev_features_t	(*ndo_fix_features)(struct net_device *dev,
>  						    netdev_features_t features);
>  	int			(*ndo_set_features)(struct net_device *dev,
> @@ -2731,6 +2734,9 @@ void netdev_freemem(struct net_device *dev);
>  void synchronize_net(void);
>  int init_dummy_netdev(struct net_device *dev);
>  
> +struct net_device *netdev_get_xmit_slave(struct net_device *dev,
> +					 struct sk_buff *skb,
> +					 bool all_slaves);
>  struct net_device *dev_get_by_index(struct net *net, int ifindex);
>  struct net_device *__dev_get_by_index(struct net *net, int ifindex);
>  struct net_device *dev_get_by_index_rcu(struct net *net, int ifindex);
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 9c9e763bfe0e..e6c10980abfd 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -7785,6 +7785,28 @@ void netdev_bonding_info_change(struct net_device *dev,
>  }
>  EXPORT_SYMBOL(netdev_bonding_info_change);
>  
> +/**
> + * netdev_get_xmit_slave - Get the xmit slave of master device
> + * @skb: The packet
> + * @all_slaves: assume all the slaves are active
> + *
> + * The reference counters are not incremented so the caller must be
> + * careful with locks. The caller must hold RCU lock.
> + * %NULL is returned if no slave is found.
> + */
> +
> +struct net_device *netdev_get_xmit_slave(struct net_device *dev,
> +					 struct sk_buff *skb,
> +					 bool all_slaves)
> +{
> +	const struct net_device_ops *ops = dev->netdev_ops;
> +
> +	if (!ops->ndo_get_xmit_slave)
> +		return NULL;
> +	return ops->ndo_get_xmit_slave(dev, skb, all_slaves);
> +}
> +EXPORT_SYMBOL(netdev_get_xmit_slave);
> +
>  static void netdev_adjacent_add_links(struct net_device *dev)
>  {
>  	struct netdev_adjacent *iter;
> 

