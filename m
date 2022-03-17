Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 088574DBBD8
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 01:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244236AbiCQAmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 20:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiCQAmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 20:42:37 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79CC762FE;
        Wed, 16 Mar 2022 17:41:21 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id qa43so7508830ejc.12;
        Wed, 16 Mar 2022 17:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=puT3IgmYzTu6AuFh52Q7IDj5+ZEUZuLDjwQ4QyI52W0=;
        b=QgXd0svzMbNIP2g2rA9c9EUijFq9dm/8soUIjK73L/NfXjS4ps3CVSug8zfay+8hHv
         rLgugrG1f/iBupGJBEpfXAvMALWrhin8tGou8GYifVo99aIZsX13g8/DAodWWxghbliR
         5FeXfzsejLgAD5ucGtMKUtCImIJUTlRiAJIuCFn1LsP3IdgAAL1sZ5JrhipoCe8VYbKf
         j67ANWCkbXB4myPbg2ZhWhjCgOOJOgaZSEjrSSe/BAhtpTRvfexagbpwHtaOND1j92oD
         ReFLZ6GjpbT+9rM+gdhV+AGzNiADUksDvG1kI0jtZAp9Gf6fuTscA2NSOySbgnM5JtrP
         nAcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=puT3IgmYzTu6AuFh52Q7IDj5+ZEUZuLDjwQ4QyI52W0=;
        b=GAlMh4QmVQMXK6XWmB2kAzJx5xyijmnH2J3+ILQ0kom6Xcw5gzmKWl6rVvVukOdnjG
         kxNoDXhCj66aXnDqaSVvLn5yFCFSe9pZE8sBA44goPSat9HuzZ4WK+mO+x1PkBuUCnEc
         hopvIbdioyZTzGWSAZq6Hju5m35FsmxJCcukCa06D/E8v5eExDYLJo0hLfTpO0wZLV1G
         TDIMSyyB7YFx0EItb9Grw51Y06k/0A4Gf22jdPTuU6nJbtW0Ew4tVGx8ri0rQm0njAZQ
         Zps81uLzT/C/gALIQqcu95IGsHPqn8p2rKkycWYW4aXQgfxJd42rJ+ImPuq+hHIwmB/H
         yyWA==
X-Gm-Message-State: AOAM530UZ4dvygmvhKv+KsiMf+lvxSBi2tBxnu5uQ/+7zaAgeOxh4GSE
        KqGVn0W0uVnVSlnTZAGRYgs=
X-Google-Smtp-Source: ABdhPJzPRk6YhBpWOdHQ0FEhwSP//JJXwdofxX9Q2WwjKdLT7SVeJhIto+QyGJvQ73CyHRGPFW2jHA==
X-Received: by 2002:a17:906:a38e:b0:6da:a1f9:f9ee with SMTP id k14-20020a170906a38e00b006daa1f9f9eemr2003763ejz.27.1647477679866;
        Wed, 16 Mar 2022 17:41:19 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id bd12-20020a056402206c00b00418c9bf71cbsm1717601edb.68.2022.03.16.17.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 17:41:19 -0700 (PDT)
Date:   Thu, 17 Mar 2022 02:41:17 +0200
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
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH v5 net-next 09/15] net: bridge: mst: Add helper to query
 a port's MST state
Message-ID: <20220317004117.sudxyvmteipz4y32@skbuf>
References: <20220316150857.2442916-1-tobias@waldekranz.com>
 <20220316150857.2442916-10-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316150857.2442916-10-tobias@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 16, 2022 at 04:08:51PM +0100, Tobias Waldekranz wrote:
> This is useful for switchdev drivers who are offloading MST states
> into hardware. As an example, a driver may wish to flush the FDB for a
> port when it transitions from forwarding to blocking - which means
> that the previous state must be discoverable.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

>  include/linux/if_bridge.h |  6 ++++++
>  net/bridge/br_mst.c       | 25 +++++++++++++++++++++++++
>  2 files changed, 31 insertions(+)
> 
> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> index 4efd5540279a..d62ef428e3aa 100644
> --- a/include/linux/if_bridge.h
> +++ b/include/linux/if_bridge.h
> @@ -121,6 +121,7 @@ int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
>  			 struct bridge_vlan_info *p_vinfo);
>  bool br_mst_enabled(const struct net_device *dev);
>  int br_mst_get_info(const struct net_device *dev, u16 msti, unsigned long *vids);
> +int br_mst_get_state(const struct net_device *dev, u16 msti, u8 *state);
>  #else
>  static inline bool br_vlan_enabled(const struct net_device *dev)
>  {
> @@ -164,6 +165,11 @@ static inline int br_mst_get_info(const struct net_device *dev, u16 msti,
>  {
>  	return -EINVAL;
>  }
> +static inline int br_mst_get_state(const struct net_device *dev, u16 msti,
> +				   u8 *state)
> +{
> +	return -EINVAL;
> +}
>  #endif
>  
>  #if IS_ENABLED(CONFIG_BRIDGE)
> diff --git a/net/bridge/br_mst.c b/net/bridge/br_mst.c
> index 830a5746479f..ee680adcee17 100644
> --- a/net/bridge/br_mst.c
> +++ b/net/bridge/br_mst.c
> @@ -48,6 +48,31 @@ int br_mst_get_info(const struct net_device *dev, u16 msti, unsigned long *vids)
>  }
>  EXPORT_SYMBOL_GPL(br_mst_get_info);
>  
> +int br_mst_get_state(const struct net_device *dev, u16 msti, u8 *state)
> +{
> +	const struct net_bridge_port *p = NULL;
> +	const struct net_bridge_vlan_group *vg;
> +	const struct net_bridge_vlan *v;
> +
> +	ASSERT_RTNL();
> +
> +	p = br_port_get_check_rtnl(dev);
> +	if (!p || !br_opt_get(p->br, BROPT_MST_ENABLED))
> +		return -EINVAL;
> +
> +	vg = nbp_vlan_group(p);
> +
> +	list_for_each_entry(v, &vg->vlan_list, vlist) {
> +		if (v->brvlan->msti == msti) {
> +			*state = v->state;
> +			return 0;
> +		}
> +	}
> +
> +	return -ENOENT;
> +}
> +EXPORT_SYMBOL_GPL(br_mst_get_state);
> +
>  static void br_mst_vlan_set_state(struct net_bridge_port *p, struct net_bridge_vlan *v,
>  				  u8 state)
>  {
> -- 
> 2.25.1
> 

