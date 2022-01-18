Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57B71492583
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 13:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241487AbiARMNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 07:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbiARMNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 07:13:33 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B570C061574;
        Tue, 18 Jan 2022 04:13:33 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id z22so78509741edd.12;
        Tue, 18 Jan 2022 04:13:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qcoPoV5JK3hzvMWgtVPAVYE7IqOH7HDeJG9d6DD2Qow=;
        b=KcKYPoqTfxlgJn7ZjfCS3QaUinF6qvRfM35m5klEH3OZcEdMa+H8GiCUUk0W44225w
         J6JFa/2idyyeIvCUy/ahmU+QfcYbE+fv4/zWxY4KNF6SmRuyESno8yuJ25W3e7jN6aNv
         NPPnTE50zCws1D/cY4h3D70p9tqSNgiyUHjp5EGwn7V+7Lt5pouXK818C62DOgpVy9z8
         f5An1c7p+sfCABgh+mVwDM06EywSWbH+QBld201GeVLNccaruK2nPWKipssPAykeEja9
         zaFK6r7qc5amwDXO1J/a1Sfz3iHAe5y/wFMm8/07Wgk4a9JC6Japg0hUU6HdzzI1UdQG
         HEug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qcoPoV5JK3hzvMWgtVPAVYE7IqOH7HDeJG9d6DD2Qow=;
        b=MayxGB9GEAdEKtFVJZZDiWu1LIl5K6WXowC3yYzJ9H89JS5ujnOsB455VOOEYxeup3
         E1pyI2uFwwuNel+NXKuGc0Q6O3lNkDS32aZ0pLZ69brKGeAlQlwNm3daLUJ8YQ+qPetx
         dxZQrg+Z0/HvtbUNh9A0Ii9HgXNIhsjZ/OuJxdjpGJtAE5ayamEJ+38IfWZbu8zjDsv7
         iK0inS9fOD8ekbE/jeppXpsyH/490Ozi8AmzH9hj2n5Tvo1P9M3KgPlMPg/hyCqmX7fo
         nxtgb9HECK+LcVI/Z8cff/Sp0wZuPrsQmO/HStB0fIPaoF3jFbWLlWcGJ/SPooNtjekP
         T09Q==
X-Gm-Message-State: AOAM531nbajvaBmQKkawhqXAroB5K6OF58fD14dPcZwSiwO6crg+uJXP
        Yf3DmmM/Txgi6YbZLN/2kKQ=
X-Google-Smtp-Source: ABdhPJxbhTd3kcaDAFkDE8hFAhFrEWRvV1pLIX7PNq/g1MJxas4pYqfj+mGIx94ZofOYHJhX8oUhvA==
X-Received: by 2002:a17:906:a216:: with SMTP id r22mr21447724ejy.457.1642508011692;
        Tue, 18 Jan 2022 04:13:31 -0800 (PST)
Received: from skbuf ([188.25.255.2])
        by smtp.gmail.com with ESMTPSA id mm28sm3019107ejb.55.2022.01.18.04.13.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 04:13:30 -0800 (PST)
Date:   Tue, 18 Jan 2022 14:13:29 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, andrew@lunn.ch,
        vivien.didelot@gmail.com, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.16 203/217] net: dsa: hold rtnl_mutex when
 calling dsa_master_{setup,teardown}
Message-ID: <20220118121329.v6inazagzduz6fyw@skbuf>
References: <20220118021940.1942199-1-sashal@kernel.org>
 <20220118021940.1942199-203-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118021940.1942199-203-sashal@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sasha,

On Mon, Jan 17, 2022 at 09:19:26PM -0500, Sasha Levin wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> [ Upstream commit c146f9bc195a9dc3ad7fd000a14540e7c9df952d ]
> 
> DSA needs to simulate master tracking events when a binding is first
> with a DSA master established and torn down, in order to give drivers
> the simplifying guarantee that ->master_state_change calls are made
> only when the master's readiness state to pass traffic changes.
> master_state_change() provide a operational bool that DSA driver can use
> to understand if DSA master is operational or not.
> To avoid races, we need to block the reception of
> NETDEV_UP/NETDEV_CHANGE/NETDEV_GOING_DOWN events in the netdev notifier
> chain while we are changing the master's dev->dsa_ptr (this changes what
> netdev_uses_dsa(dev) reports).
> 
> The dsa_master_setup() and dsa_master_teardown() functions optionally
> require the rtnl_mutex to be held, if the tagger needs the master to be
> promiscuous, these functions call dev_set_promiscuity(). Move the
> rtnl_lock() from that function and make it top-level.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

Please drop this patch from all stable branches (5.16, 5.15, 5.10).
Thanks.

>  net/dsa/dsa2.c   | 8 ++++++++
>  net/dsa/master.c | 4 ++--
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
> index 826957b6442b0..834f26539da73 100644
> --- a/net/dsa/dsa2.c
> +++ b/net/dsa/dsa2.c
> @@ -997,6 +997,8 @@ static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
>  	struct dsa_port *dp;
>  	int err;
>  
> +	rtnl_lock();
> +
>  	list_for_each_entry(dp, &dst->ports, list) {
>  		if (dsa_port_is_cpu(dp)) {
>  			err = dsa_master_setup(dp->master, dp);
> @@ -1005,6 +1007,8 @@ static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
>  		}
>  	}
>  
> +	rtnl_unlock();
> +
>  	return 0;
>  }
>  
> @@ -1012,9 +1016,13 @@ static void dsa_tree_teardown_master(struct dsa_switch_tree *dst)
>  {
>  	struct dsa_port *dp;
>  
> +	rtnl_lock();
> +
>  	list_for_each_entry(dp, &dst->ports, list)
>  		if (dsa_port_is_cpu(dp))
>  			dsa_master_teardown(dp->master);
> +
> +	rtnl_unlock();
>  }
>  
>  static int dsa_tree_setup_lags(struct dsa_switch_tree *dst)
> diff --git a/net/dsa/master.c b/net/dsa/master.c
> index e8e19857621bd..16b7dfd22bf5d 100644
> --- a/net/dsa/master.c
> +++ b/net/dsa/master.c
> @@ -267,9 +267,9 @@ static void dsa_master_set_promiscuity(struct net_device *dev, int inc)
>  	if (!ops->promisc_on_master)
>  		return;
>  
> -	rtnl_lock();
> +	ASSERT_RTNL();
> +
>  	dev_set_promiscuity(dev, inc);
> -	rtnl_unlock();
>  }
>  
>  static ssize_t tagging_show(struct device *d, struct device_attribute *attr,
> -- 
> 2.34.1
> 
