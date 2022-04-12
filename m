Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB5FE4FE314
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356267AbiDLNwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356295AbiDLNwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:52:36 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147FC54FA7
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 06:50:17 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id l7so32034208ejn.2
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 06:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mD45Iif032GK88o1qMNo6w3/u6ggfAfX7qh5bJo8NEo=;
        b=pbFyd8R46nIcgxyDcQ26MHXU5kThNwKLbXLYWLscA9j9wGdb+CoazLFJ3Mc/IZcrMC
         Q0prBkqlCe2iJHQQIPjFNfXmn8aHvbqSVpmFAC44PhD2XkF6XQUEEShtm8Vz61Z/P4EQ
         zXaV4bD4bNqPWp0leW6jSSFe1hHGKZpopdBqpWyRIYPRPWEzkZuqW7uyxV7n0caVqDcm
         5iDSaw9skCAgUST2D0UJ2vNIHTLhYaUcc8HDcl4Pw+S4L2Euau6cTh1vv26iFFAViP8B
         FA2Pkkn45N2yC8QmoRYVZMggmR1nFu4UFRs5OAqQ3kvScVTgXQjymDDRT6L1anJ4/xTe
         1QFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mD45Iif032GK88o1qMNo6w3/u6ggfAfX7qh5bJo8NEo=;
        b=cgl9mtZ5yOg0Gsr1kUzlErluLyaCJkllpPYKBLd9KzKD8OXwUxXlh97PE2/7ZzPbo3
         hBTYyTXSaxLVumiIj9rwqiYhvrCZLuUgaZSojX5+kFMLHIAOoCCMilLJE0O45H/BRlS2
         zywckTjwlyoimYsInJRIf0b77wBzCWVe3WSD5+dxV2ZvGADTkBbFdzLikpJyI4HDUWJt
         pobgE6jPM/w9Tb6ePHP97vGYItMBgcAao1dc5bQSXkX+5GjCEMQ0uAwF75ZxGXvw4GlL
         NS7WnhQQo91nQ1oCmpSPjv8IJTi8O4Qpp8Kzlc5b0oGIWm6GIycn9HXs0Y6dhVWu0qM0
         y51w==
X-Gm-Message-State: AOAM533QqVBO5PTOlVCLJka5vM5BaMesgHq1hXag9QidOL15oPmxXW+f
        zlyvp+eDjMYri83gvH+hFB0=
X-Google-Smtp-Source: ABdhPJz+91h6oAhgO2Nk6GkNMZqOXMbEDLWuVY+g8AwnX6jjJdKtuLwjhu5miayyFkeRywG6H902Lg==
X-Received: by 2002:a17:907:1608:b0:6e8:526a:2312 with SMTP id hb8-20020a170907160800b006e8526a2312mr18954077ejc.200.1649771415282;
        Tue, 12 Apr 2022 06:50:15 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id u10-20020a50d94a000000b004131aa2525esm16925369edj.49.2022.04.12.06.50.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 06:50:14 -0700 (PDT)
Date:   Tue, 12 Apr 2022 16:50:12 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH v4 net-next 1/3] net: dsa: track whetever bridges have
 foreign interfaces in them
Message-ID: <20220412135012.czcmfurp5w2t2ocl@skbuf>
References: <20220411120633.40054-1-mattias.forsblad@gmail.com>
 <20220411120633.40054-2-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220411120633.40054-2-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 02:06:31PM +0200, Mattias Forsblad wrote:
> Track if a bridge stack has any foreign interfaces in them.
> 
> This patch is based on work done by Vlodimir Oltean.

Originally these were 2 patches which were squashed (and they were 2
patches for a reason), they're missing proper authorship (mine, my sign
off, your sign off), and my name is misspelled.

> 
> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
> ---
>  include/net/dsa.h  |  1 +
>  net/dsa/dsa_priv.h |  1 +
>  net/dsa/slave.c    | 88 +++++++++++++++++++++++++++++++++++++++++-----
>  3 files changed, 81 insertions(+), 9 deletions(-)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 934958fda962..52b6da7d45b3 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -242,6 +242,7 @@ struct dsa_bridge {
>  	unsigned int num;
>  	bool tx_fwd_offload;
>  	refcount_t refcount;
> +	u8 have_foreign:1;
>  };
>  
>  struct dsa_port {
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index 5d3f4a67dce1..d610776ecd76 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -320,6 +320,7 @@ void dsa_slave_setup_tagger(struct net_device *slave);
>  int dsa_slave_change_mtu(struct net_device *dev, int new_mtu);
>  int dsa_slave_manage_vlan_filtering(struct net_device *dev,
>  				    bool vlan_filtering);
> +int dsa_bridge_foreign_dev_update(struct net_device *bridge_dev);
>  
>  static inline struct dsa_port *dsa_slave_to_port(const struct net_device *dev)
>  {
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 41c69a6e7854..feaf64564c6e 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -2485,6 +2485,9 @@ static int dsa_slave_changeupper(struct net_device *dev,
>  	struct netlink_ext_ack *extack;
>  	int err = NOTIFY_DONE;
>  
> +	if (!dsa_slave_dev_check(dev))
> +		return err;
> +
>  	extack = netdev_notifier_info_to_extack(&info->info);
>  
>  	if (netif_is_bridge_master(info->upper_dev)) {
> @@ -2539,6 +2542,9 @@ static int dsa_slave_prechangeupper(struct net_device *dev,
>  {
>  	struct dsa_port *dp = dsa_slave_to_port(dev);
>  
> +	if (!dsa_slave_dev_check(dev))
> +		return NOTIFY_DONE;
> +
>  	if (netif_is_bridge_master(info->upper_dev) && !info->linking)
>  		dsa_port_pre_bridge_leave(dp, info->upper_dev);
>  	else if (netif_is_lag_master(info->upper_dev) && !info->linking)
> @@ -2559,6 +2565,9 @@ dsa_slave_lag_changeupper(struct net_device *dev,
>  	int err = NOTIFY_DONE;
>  	struct dsa_port *dp;
>  
> +	if (!netif_is_lag_master(dev))
> +		return err;
> +
>  	netdev_for_each_lower_dev(dev, lower, iter) {
>  		if (!dsa_slave_dev_check(lower))
>  			continue;
> @@ -2588,6 +2597,9 @@ dsa_slave_lag_prechangeupper(struct net_device *dev,
>  	int err = NOTIFY_DONE;
>  	struct dsa_port *dp;
>  
> +	if (!netif_is_lag_master(dev))
> +		return err;
> +
>  	netdev_for_each_lower_dev(dev, lower, iter) {
>  		if (!dsa_slave_dev_check(lower))
>  			continue;
> @@ -2605,6 +2617,18 @@ dsa_slave_lag_prechangeupper(struct net_device *dev,
>  	return err;
>  }
>  
> +static int dsa_bridge_changelower(struct net_device *dev,
> +				  struct netdev_notifier_changeupper_info *info)
> +{
> +	int err;
> +
> +	if (!netif_is_bridge_master(info->upper_dev))
> +		return NOTIFY_DONE;
> +
> +	err = dsa_bridge_foreign_dev_update(info->upper_dev);
> +	return notifier_from_errno(err);
> +}
> +
>  static int
>  dsa_prevent_bridging_8021q_upper(struct net_device *dev,
>  				 struct netdev_notifier_changeupper_info *info)
> @@ -2709,22 +2733,33 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
>  		if (err != NOTIFY_DONE)
>  			return err;
>  
> -		if (dsa_slave_dev_check(dev))
> -			return dsa_slave_prechangeupper(dev, ptr);
> +		err = dsa_slave_prechangeupper(dev, ptr);
> +		if (notifier_to_errno(err))
> +			return err;
>  
> -		if (netif_is_lag_master(dev))
> -			return dsa_slave_lag_prechangeupper(dev, ptr);
> +		err = dsa_slave_lag_prechangeupper(dev, ptr);
> +		if (notifier_to_errno(err))
> +			return err;
>  
>  		break;
>  	}
> -	case NETDEV_CHANGEUPPER:
> -		if (dsa_slave_dev_check(dev))
> -			return dsa_slave_changeupper(dev, ptr);
> +	case NETDEV_CHANGEUPPER: {
> +		int err;
>  
> -		if (netif_is_lag_master(dev))
> -			return dsa_slave_lag_changeupper(dev, ptr);
> +		err = dsa_slave_changeupper(dev, ptr);
> +		if (notifier_to_errno(err))
> +			return err;
> +
> +		err = dsa_slave_lag_changeupper(dev, ptr);
> +		if (notifier_to_errno(err))
> +			return err;
> +
> +		err = dsa_bridge_changelower(dev, ptr);
> +		if (notifier_to_errno(err))
> +			return err;
>  
>  		break;
> +	}
>  	case NETDEV_CHANGELOWERSTATE: {
>  		struct netdev_notifier_changelowerstate_info *info = ptr;
>  		struct dsa_port *dp;
> @@ -2877,6 +2912,41 @@ static bool dsa_foreign_dev_check(const struct net_device *dev,
>  	return true;
>  }
>  
> +int dsa_bridge_foreign_dev_update(struct net_device *bridge_dev)
> +{
> +	struct net_device *first_slave, *lower;
> +	struct dsa_bridge *bridge = NULL;
> +	struct dsa_switch_tree *dst;
> +	bool have_foreign = false;
> +	struct list_head *iter;
> +	struct dsa_port *dp;
> +
> +	list_for_each_entry(dst, &dsa_tree_list, list) {
> +		dsa_tree_for_each_user_port(dp, dst) {
> +			if (dsa_port_offloads_bridge_dev(dp, bridge_dev)) {
> +				bridge = dp->bridge;
> +				first_slave = dp->slave;
> +				break;
> +			}
> +		}
> +	}
> +
> +	/* Bridge with no DSA interface in it */
> +	if (!bridge)
> +		return 0;
> +
> +	netdev_for_each_lower_dev(bridge_dev, lower, iter) {
> +		if (dsa_foreign_dev_check(first_slave, lower)) {
> +			have_foreign = true;
> +			break;
> +		}
> +	}
> +
> +	bridge->have_foreign = have_foreign;
> +
> +	return 0;
> +}
> +
>  static int dsa_slave_fdb_event(struct net_device *dev,
>  			       struct net_device *orig_dev,
>  			       unsigned long event, const void *ctx,
> -- 
> 2.25.1
> 
