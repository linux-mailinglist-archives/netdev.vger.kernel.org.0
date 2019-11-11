Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 422D5F82CF
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 23:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbfKKWPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 17:15:31 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41523 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726923AbfKKWPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 17:15:31 -0500
Received: by mail-lf1-f68.google.com with SMTP id j14so11099747lfb.8
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 14:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JRXrodVHYhiGAfwYVYOvpqNqKsOaJKtvlzrom6mvWYM=;
        b=UysnqbJjbZklK2plaqyIEe+XW5WofM07UNZ/iralSzFfBCjam7qpOU2k0pD/PSeHMh
         6a/D31RBqtZB9pgmEoumiBOjb8orhAaDSK7pXCUApMgFV0LdjwZbELZPs+cxaiPfonUR
         2pdP//ukce48f3YrL24RkhoCF99krNL+g2GKY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JRXrodVHYhiGAfwYVYOvpqNqKsOaJKtvlzrom6mvWYM=;
        b=bfNelIOMHDDMNpZw23Em4TmV3Fqc+PWKGaY2sroAvbFPuLkP5JZZzkErpYHW0bEWbc
         FvSun5ZJby6Mrml02hzbe1b1Yqlv0MOxivlYtXtryXYVH8aMmuL2ahRQBE7jFz3VKcGI
         QHS/okaPMBFwfEzvfWnLEaxZjpe73FSqlu2uUtmp6M7HB9E/vqx0c9V7PL/9SdRACqPx
         l3sj5FwF7erdEI7Fo62euJvvlBGHhHgPIpW9ztdkPobo9n8umwdObrUwx0A1SbgrV6Ch
         BgYpE8Kv+d/GvJWwDhHbvPQAya00OwrV8j4JzoJ/CROxqnAD6eKzIwK0fgFaVxkP3W7H
         BAZQ==
X-Gm-Message-State: APjAAAXPpa48O04egoQYFCTtBNO41Qjd495LpilopR8fx9vibovb9JB7
        Ycbr/yKKqXlk3SSTKmiMc29L2g==
X-Google-Smtp-Source: APXvYqxkHnYkKqHXF33wJikEKSAcRL+wwJC3Liou9mSqBVHPdLOM/v67G69jS60uz532oU/4kZLUqQ==
X-Received: by 2002:ac2:4a8a:: with SMTP id l10mr16950312lfp.185.1573510527947;
        Mon, 11 Nov 2019 14:15:27 -0800 (PST)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id r19sm7432742lfi.13.2019.11.11.14.15.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 14:15:27 -0800 (PST)
Subject: Re: [PATCH net-next 2/2] bridge: implement get_link_ksettings ethtool
 method
To:     Matthias Schiffer <mschiffer@universe-factory.net>,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        roopa@cumulusnetworks.com
References: <cover.1573321597.git.mschiffer@universe-factory.net>
 <8e414e98928aba7f11ea997498fb18af05434f5f.1573321597.git.mschiffer@universe-factory.net>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <5da07a98-bae3-2d67-d60b-2e58be9d8377@cumulusnetworks.com>
Date:   Tue, 12 Nov 2019 00:15:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <8e414e98928aba7f11ea997498fb18af05434f5f.1573321597.git.mschiffer@universe-factory.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/11/2019 19:54, Matthias Schiffer wrote:
> We return the maximum speed of all active ports. This matches how the link
> speed would give an upper limit for traffic to/from any single peer if the
> bridge were replaced with a hardware switch.
> 
> Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>
> ---
>  net/bridge/br_device.c | 37 +++++++++++++++++++++++++++++++++++--
>  1 file changed, 35 insertions(+), 2 deletions(-)
> 
> diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
> index e804a3016902..e8a2d0c13592 100644
> --- a/net/bridge/br_device.c
> +++ b/net/bridge/br_device.c
> @@ -263,6 +263,38 @@ static void br_getinfo(struct net_device *dev, struct ethtool_drvinfo *info)
>  	strlcpy(info->bus_info, "N/A", sizeof(info->bus_info));
>  }
>  
> +static int br_get_link_ksettings(struct net_device *dev,
> +				 struct ethtool_link_ksettings *cmd)
> +{
> +	struct net_bridge *br = netdev_priv(dev);
> +	struct net_bridge_port *p;
> +
> +	cmd->base.duplex = DUPLEX_UNKNOWN;
> +	cmd->base.port = PORT_OTHER;
> +	cmd->base.speed = SPEED_UNKNOWN;
> +
> +	list_for_each_entry(p, &br->port_list, list) {
> +		struct ethtool_link_ksettings ecmd;
> +		struct net_device *pdev = p->dev;
> +
> +		if (!netif_running(pdev) || !netif_oper_up(pdev))
> +			continue;
> +
> +		if (__ethtool_get_link_ksettings(pdev, &ecmd))
> +			continue;
> +
> +		if (ecmd.base.speed == (__u32)SPEED_UNKNOWN)
> +			continue;
> +
> +		if (cmd->base.speed == (__u32)SPEED_UNKNOWN ||
> +		    cmd->base.speed < ecmd.base.speed) {
> +			cmd->base.speed = ecmd.base.speed;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  static netdev_features_t br_fix_features(struct net_device *dev,
>  	netdev_features_t features)
>  {
> @@ -365,8 +397,9 @@ static int br_del_slave(struct net_device *dev, struct net_device *slave_dev)
>  }
>  
>  static const struct ethtool_ops br_ethtool_ops = {
> -	.get_drvinfo    = br_getinfo,
> -	.get_link	= ethtool_op_get_link,
> +	.get_drvinfo		 = br_getinfo,
> +	.get_link		 = ethtool_op_get_link,
> +	.get_link_ksettings	 = br_get_link_ksettings,
>  };
>  
>  static const struct net_device_ops br_netdev_ops = {
> 

Code-wise this is ok, but it could cause potential issues because devices will suddenly
have speed (without duplex), and macvlan/8021q are examples which use the lowerdev's
get_link_ksettings. I searched for potential problems with some user-space software
but couldn't find any, so I hope it will be fine. :)
Let's see where this goes.

Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

