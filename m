Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E094CC8EB
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 23:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236918AbiCCWaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 17:30:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236913AbiCCWac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 17:30:32 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B05311EF20;
        Thu,  3 Mar 2022 14:29:46 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id s1so8428921edd.13;
        Thu, 03 Mar 2022 14:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qURyynMi/HgXpmSfLyUFNqbqAu/l3MGX7Mv0yI+XyPQ=;
        b=Ep3QG/4ZU24+B32NtMclXeYMmGtv/CULxCL1Xcm8LpSfsHlwc1RTO4xFbc2BtrbqRI
         wDXQD3JBhvqiFguK4cLM0aMfivTA8qyy0+Hnf+PP/zfio3r48S7rMkJeCF35l9tWeIJ9
         mYwxrsKxnteK0lvvQUrJlMPI0Sk2yD/jrwglf9Wv3ZEk+QCLUDHd7m8QPxYd726BqHi7
         8KYmUHMI7xBVqF/1QJPn4zifeyxo/cOQYMIPV9na6+SiN3Wo5GEnLYo9GjPtjmuA9BvE
         Uzuiej//fqAXgRzjnqLsRzkRu3JqXTga+bPwZPb7aSJRoNSMim0pbBcv3PeymH4LOt94
         ClqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qURyynMi/HgXpmSfLyUFNqbqAu/l3MGX7Mv0yI+XyPQ=;
        b=i/xnce6N0pC3N+PGlROlgQkh4OOqMmILT9MJyBi0arboJXbWqKwKZoU0JMo9/c3TAf
         GN8zSsQiHVmw+Zwh73FggHJTLWRFK7HBPhD4n+K1F0REcROIHkGYWYfF5wumzJGiFAlT
         KotwGabpX8X7a4lUQS3ppN0cJgwHzCjDAw/j1g1pnkr8ZyVEZTtKYxAGxG9EvhisAyb5
         Bb5oKYVm2jM+o6yNBAA/aRqIA5pFl4xbTlzhr+7gh/3MWUSB5u8zVpYkDlLqhM4Y/Q+w
         brFYM+O6C12RCVrji1c21iv22pAqk8k8qtSErdkxsG6QquKKvdzUa1S+ogdxF4ZqAUZC
         geLQ==
X-Gm-Message-State: AOAM5335tkz8s/0muaTloTmzznakYKFQ5uL5QPln2MenACr8SgEnyo7i
        Gx93+3gSDWZYK3rqkr37UE0=
X-Google-Smtp-Source: ABdhPJycAcEdH9myQCMw6g6i+TkljUrgPIVf7+QgiP17Bb4KxbhWSFhcGDjT5Qr7OEZT7GxjdIz8hQ==
X-Received: by 2002:a05:6402:270a:b0:410:63d:a66d with SMTP id y10-20020a056402270a00b00410063da66dmr36458587edd.48.1646346584524;
        Thu, 03 Mar 2022 14:29:44 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id v2-20020a509d02000000b00412d53177a6sm1369846ede.20.2022.03.03.14.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 14:29:44 -0800 (PST)
Date:   Fri, 4 Mar 2022 00:29:42 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Cooper Lees <me@cooperlees.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH v2 net-next 06/10] net: dsa: Pass VLAN MSTI migration
 notifications to driver
Message-ID: <20220303222942.dkz7bfuagkv7hbpp@skbuf>
References: <20220301100321.951175-1-tobias@waldekranz.com>
 <20220301100321.951175-7-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301100321.951175-7-tobias@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 01, 2022 at 11:03:17AM +0100, Tobias Waldekranz wrote:
> Add the usual trampoline functionality from the generic DSA layer down
> to the drivers for VLAN MSTI migrations.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  include/net/dsa.h  |  3 +++
>  net/dsa/dsa_priv.h |  1 +
>  net/dsa/port.c     | 10 ++++++++++
>  net/dsa/slave.c    |  6 ++++++
>  4 files changed, 20 insertions(+)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index cfedcfb86350..cc8acb01bd9b 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -962,6 +962,9 @@ struct dsa_switch_ops {
>  				 struct netlink_ext_ack *extack);
>  	int	(*port_vlan_del)(struct dsa_switch *ds, int port,
>  				 const struct switchdev_obj_port_vlan *vlan);
> +	int	(*vlan_msti_set)(struct dsa_switch *ds,
> +				 const struct switchdev_attr *attr);

I would rather pass the struct switchdev_vlan_attr and the orig_dev
(bridge) as separate arguments here. Or even the struct dsa_bridge, for
consistency to the API changes for database isolation.

> +
>  	/*
>  	 * Forwarding database
>  	 */
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index 07c0ad52395a..87ec0697e92e 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -217,6 +217,7 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
>  			    struct netlink_ext_ack *extack);
>  bool dsa_port_skip_vlan_configuration(struct dsa_port *dp);
>  int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock);
> +int dsa_port_vlan_msti(struct dsa_port *dp, const struct switchdev_attr *attr);
>  int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
>  			bool targeted_match);
>  int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index d9da425a17fb..5f45cb7d70ba 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -778,6 +778,16 @@ int dsa_port_bridge_flags(struct dsa_port *dp,
>  	return 0;
>  }
>  
> +int dsa_port_vlan_msti(struct dsa_port *dp, const struct switchdev_attr *attr)
> +{
> +	struct dsa_switch *ds = dp->ds;
> +
> +	if (!ds->ops->vlan_msti_set)
> +		return -EOPNOTSUPP;
> +
> +	return ds->ops->vlan_msti_set(ds, attr);

I guess this doesn't need to be a cross-chip notifier event for all
switches, because replication to all bridge ports is handled by
switchdev_handle_port_attr_set(). Ok. But isn't it called too many times
per switch?

> +}
> +
>  int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
>  			bool targeted_match)
>  {
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 089616206b11..c6ffcd782b5a 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -314,6 +314,12 @@ static int dsa_slave_port_attr_set(struct net_device *dev, const void *ctx,
>  
>  		ret = dsa_port_bridge_flags(dp, attr->u.brport_flags, extack);
>  		break;
> +	case SWITCHDEV_ATTR_ID_VLAN_MSTI:
> +		if (!dsa_port_offloads_bridge_dev(dp, attr->orig_dev))
> +			return -EOPNOTSUPP;
> +
> +		ret = dsa_port_vlan_msti(dp, attr);
> +		break;
>  	default:
>  		ret = -EOPNOTSUPP;
>  		break;
> -- 
> 2.25.1
> 

