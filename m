Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0FA72DEC61
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 01:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbgLSA1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 19:27:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgLSA1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 19:27:12 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC7FC0617B0
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 16:26:32 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id hk16so2252435pjb.4
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 16:26:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=4Tfr/rcPDhXfbzs2r2lL+04nNiRj8XeioXV8wvDBDhM=;
        b=g1a3oQDQKDNZk3QWVwh8+M7Mskk2m5NwROMf+yz3htAe8sLR8bPwY9V5gyCsh1yNWf
         pdlk8zFvg4m5YcO7xfYKkE9OC5Y3snm1mbJV8PlcCy0I9WGHc+hr4EEY5lEU3WqwqSu/
         UhnM0FO3z8LlXuxDEz7F0oLVn6uly1g3daSoTTpZQ9RwwPXVG4SE5MGAG7Lf9clatFXg
         VfCswGZ0wDm26hk6qyOogqZYFV8v9dh4pVEN0ePjLCmZiChRa3iQQkSaA9m+8fAyzvnt
         SDdQjTqgo612EtI1RFvV3bnI9y0UASabWc63H3YLa0AVvhwSBUlbV9NLNBmoT1S3mdQi
         ISqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4Tfr/rcPDhXfbzs2r2lL+04nNiRj8XeioXV8wvDBDhM=;
        b=Dq/50tMsel433aYZorWEj8//u1eG0VhXiuOIFnodVGOmfgiEtQToi7BKdpKyUqBe3Z
         3wDYrSuHWXlCnSG6G0dr3Qtp435nUPQK5YB1Ss25Re64/QBtO+bSfgUFiOCViMzqaMB/
         CG0YEq7oxqFhOHlPU9UCRqxGhsuAe2bF4lcwh5EbY4aGH2M2W2BgP0Oyrom2nHF0oUEx
         VQBZ4OBauux0WevBHcupBUExPb/Pfd11XzYFsX5Ra3HikyONKdEhnV2i0k/9jXaFbWMc
         GKTI8xuZ3RcGcLmmpRqNVBzK1qexYdyYueySzDVQx/fD+rHX8VMR6ZtgumoZ8wUngsGy
         bgyw==
X-Gm-Message-State: AOAM532CPAn/qJDvULnx3qq6bRfYYbIurpRryKwljV7OXCmNxu5M0oq2
        4bzEszJ6+CoCywfZfOlVGsZRb2AFIdk=
X-Google-Smtp-Source: ABdhPJyHnKvV//Xh4psnFFyXLp+ogd8eZf5JK532jkjeViXOWNR8z0EYKjMYCaloHN+BWzbW5R3JCw==
X-Received: by 2002:a17:902:eac4:b029:da:79a5:1e88 with SMTP id p4-20020a170902eac4b02900da79a51e88mr6456838pld.78.1608337591379;
        Fri, 18 Dec 2020 16:26:31 -0800 (PST)
Received: from [10.230.29.166] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l8sm8135562pjt.32.2020.12.18.16.26.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Dec 2020 16:26:30 -0800 (PST)
Subject: Re: [RFC PATCH net-next 3/4] net: systemport: use standard netdevice
 notifier to detect DSA presence
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
References: <20201218223852.2717102-1-vladimir.oltean@nxp.com>
 <20201218223852.2717102-4-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <34386add-4daf-d8f3-9176-295719095918@gmail.com>
Date:   Fri, 18 Dec 2020 16:26:28 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201218223852.2717102-4-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/18/2020 2:38 PM, Vladimir Oltean wrote:
> The SYSTEMPORT driver maps each port of the embedded Broadcom DSA switch
> port to a certain queue of the master Ethernet controller. For that it
> currently uses a dedicated notifier infrastructure which was added in
> commit 60724d4bae14 ("net: dsa: Add support for DSA specific notifiers").
> 
> However, since commit 2f1e8ea726e9 ("net: dsa: link interfaces with the
> DSA master to get rid of lockdep warnings"), DSA is actually an upper of
> the Broadcom SYSTEMPORT as far as the netdevice adjacency lists are
> concerned. So naturally, the plain NETDEV_CHANGEUPPER net device notifiers
> are emitted. It looks like there is enough API exposed by DSA to the
> outside world already to make the call_dsa_notifiers API redundant. So
> let's convert its only user to plain netdev notifiers.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/broadcom/bcmsysport.c | 76 +++++++++-------------
>  drivers/net/ethernet/broadcom/bcmsysport.h |  2 +-
>  2 files changed, 32 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
> index 82541352b1eb..c5df235975e7 100644
> --- a/drivers/net/ethernet/broadcom/bcmsysport.c
> +++ b/drivers/net/ethernet/broadcom/bcmsysport.c
> @@ -2311,33 +2311,22 @@ static const struct net_device_ops bcm_sysport_netdev_ops = {
>  	.ndo_select_queue	= bcm_sysport_select_queue,
>  };
>  
> -static int bcm_sysport_map_queues(struct notifier_block *nb,
> -				  struct dsa_notifier_register_info *info)
> +static int bcm_sysport_map_queues(struct net_device *dev,
> +				  struct net_device *slave_dev)
>  {
> +	struct dsa_port *dp = dsa_port_from_netdev(slave_dev);
> +	struct bcm_sysport_priv *priv = netdev_priv(dev);
>  	struct bcm_sysport_tx_ring *ring;
> -	struct bcm_sysport_priv *priv;
> -	struct net_device *slave_dev;
>  	unsigned int num_tx_queues;
>  	unsigned int q, qp, port;
> -	struct net_device *dev;
> -
> -	priv = container_of(nb, struct bcm_sysport_priv, dsa_notifier);
> -	if (priv->netdev != info->master)
> -		return 0;

There are systems with two SYSTEMPORT network devices registered and
therfore this check was intended to avoid programmig the incorrect
network device upon notification, however now that we have proper
upper/lower linking, and given the decisions made by bcm_sf2.c, only one
out of the two SYSTEMPORT network devices will act as a DSA master,
therefore this should no longer be necessary.

I would like to test this before giving this patch a Acked-by or
Teteed-by tag, net-next is still closed and this should only take a few
hours if there not any non-maskable real life interrupts showing up.
-- 
Florian
