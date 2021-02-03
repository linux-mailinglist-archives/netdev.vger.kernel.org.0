Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F49F30D534
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 09:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232779AbhBCI30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 03:29:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbhBCI3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 03:29:24 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B02C061573
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 00:28:44 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id p21so32069766lfu.11
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 00:28:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=3B1wfRK3eiu/R5pLSYcHuDGHAwMhnM0yTMCvmb93rL8=;
        b=YJik4TeHJomKKpkXq2/uZGd2jreAF39YshcfvgQmMJLX77wkjEHKd0pgkv7R0/Fn1V
         9W24lXj1UYCdNOsiYGpiF2QBvjEU626msdkrNTV0lw8IwBBfXTFFJIxPPvGwXoyUobSK
         hdLyEqM19JweUzoHDeMESQDfW2oMc8TosojsEgzjcz++zPHoet4kKGKM9lMOeXBwqirS
         o7/laROIEIQM3Mtnz5ALPHzxdGhIKDVcrH6qhKQc07kS86mHZPwN46mRRa7S0aoglD2Z
         CUKHhvRcFJ2GWQPSZeWyaKFhIuZZoVLTLs7X55+4T1G4r2ZK9BmIrM6zRYe9AeApkOep
         VsyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=3B1wfRK3eiu/R5pLSYcHuDGHAwMhnM0yTMCvmb93rL8=;
        b=h8z0rK3n+3MntKYZmrc7ZCWPT1VbgMod6H+g9daJcx7XffpdXcI01WgnXb6n74zrx6
         W28ZomfyCFlaLY1j8h+Ws8yFuep54VYr8z1hHWVqTFta++utvz0lo3IK5mTTd8Y4wGXH
         NN5VhW51QoMNM4113O9qZPgLU9z9Kv5gwS+hBWamjjOufw664Z20Lwvj83ZLuP4lKIfR
         Darn7qJqaJfo2yK+4CifTrVS+XjjNekNK/u9O54WIuRXJ5ppoy04ylKxswBsCpXh0g29
         foqGOBP9AVOAM7BOePRy+ZjHAlapBerKCeKn6jsApI7aSeTT9DVVhvYwtZzDBveBP4ew
         zmyw==
X-Gm-Message-State: AOAM530NB/JKHFtIdGfaieVbqHqtSDk5comicui4tVWHrbMascqoLW2y
        wvChSW4BgGnnsNvEXnc/RL0NxA==
X-Google-Smtp-Source: ABdhPJymCG3irwdOCclcxBctWRBXwrol1iT7vAgdVSY+yPoWS5etZNdSEId6GMjhUG0IwX1lCrYuiA==
X-Received: by 2002:ac2:5b1b:: with SMTP id v27mr1222535lfn.260.1612340922498;
        Wed, 03 Feb 2021 00:28:42 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id q3sm168920ljp.108.2021.02.03.00.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 00:28:41 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next] net: dsa: fix SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING getting ignored
In-Reply-To: <20210202233109.1591466-1-olteanv@gmail.com>
References: <20210202233109.1591466-1-olteanv@gmail.com>
Date:   Wed, 03 Feb 2021 09:28:41 +0100
Message-ID: <875z395zd2.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 03, 2021 at 01:31, Vladimir Oltean <olteanv@gmail.com> wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> The bridge emits VLAN filtering events and quite a few others via
> switchdev with orig_dev = br->dev. After the blamed commit, these events
> started getting ignored.
>
> The point of the patch was to not offload switchdev objects for ports
> that didn't go through dsa_port_bridge_join, because the configuration
> is unsupported:
> - ports that offload a bonding/team interface go through
>   dsa_port_bridge_join when that bonding/team interface is later bridged
>   with another switch port or LAG
> - ports that don't offload LAG don't get notified of the bridge that is
>   on top of that LAG.
>
> Sadly, a check is missing, which is that the orig_dev is equal to the
> bridge device. This check is compatible with the original intention,
> because ports that don't offload bridging because they use a software
> LAG don't have dp->bridge_dev set.
>
> On a semi-related note, we should not offload switchdev objects or
> populate dp->bridge_dev if the driver doesn't implement .port_bridge_join
> either. However there is no regression associated with that, so it can
> be done separately.
>
> Fixes: 5696c8aedfcc ("net: dsa: Don't offload port attributes on standalone ports")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
Tested-by: Tobias Waldekranz <tobias@waldekranz.com>

>  net/dsa/dsa_priv.h | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index 2ce46bb87703..1c4ee741b4b8 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -182,7 +182,15 @@ static inline bool dsa_port_offloads_netdev(struct dsa_port *dp,
>  	/* Switchdev offloading can be configured on: */
>  
>  	if (dev == dp->slave)
> -		/* DSA ports directly connected to a bridge. */
> +		/* DSA ports directly connected to a bridge, and event
> +		 * was emitted for the ports themselves.
> +		 */
> +		return true;
> +
> +	if (dp->bridge_dev == dev)
> +		/* DSA ports connected to a bridge, and event was emitted
> +		 * for the bridge.
> +		 */
>  		return true;
>  
>  	if (dp->lag_dev == dev)
> -- 
> 2.25.1
