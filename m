Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1934DBBDB
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 01:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345383AbiCQAnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 20:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242804AbiCQAnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 20:43:49 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C314862FE;
        Wed, 16 Mar 2022 17:42:33 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id w4so4718735edc.7;
        Wed, 16 Mar 2022 17:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=H0nknxMHezOvYCsNqm3RZDRFJz+VXWQYJZtH3Zk/57k=;
        b=ZbMebK+la9jrpPCHWvD3tQQxGQ4KzQZg2fxez0hesY7cRQoFosiRqCeEjOt6GnU0Yi
         +keXpYbNgjeTelQZrOwfk8RtCsWcCQSmhT0yK6DttJ6dylS/8sdtXb271fYLg5xG4gd7
         M/eG4A8n9mpTOeJ8rMDVx9oEZ5oJUVJKRRULKVcmg/L6fM4rIPPeIrfRevA0Nqz5am6V
         Rz7sdM9PrlUAIlQrsDHxyrr3Yx1lv4u73Qw0GnPaJp7N/EmajnHunod0MYov8qxh4fZZ
         otYuPHC8Ed9v5aqhRmiJcQreTsZnCht2VnUcPRhUhlmNCd6ah90nPlipbQEbX7+aaQPx
         X81A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H0nknxMHezOvYCsNqm3RZDRFJz+VXWQYJZtH3Zk/57k=;
        b=TnlNSoT1IXVpPpFs2YAyQ8nnOkyNtsVzzrDSASeWDyA6Aktx2zQxVuZkfgE+peGXQm
         hg+QAg9dmXWBx63TBwX0FARE8QXxlgQHjpoZCTq6zDx5ElKxW6YKw4CURqkyqc1wO67J
         W2y8HNa788DpSupC//UG7gfZyBQgHSpaxgPlrt2qV7b3UTbAB/S0I2B8j/tuKROy4wyU
         9EMD9FGms0h89vxkMr31ZccNNLrukwbpzKPEgJ397e0lpagpeYzD03BMwB5e9jm52PSs
         HhMNaNUlWgLzJNeqC4SfG2/IR/ztYg7T4LNp0Hc9ufWsnRjFjA1yHyA/NR+SnBctrLhV
         3rcw==
X-Gm-Message-State: AOAM532/Gap++aRuNnETGkhdKEL6dBOkqs1RLfBH0yGOxtfdY9rbns9I
        WeGACRJauReH6hpw+VXMkGE=
X-Google-Smtp-Source: ABdhPJw1C8yIP3Qjd3GFx4zVRMAvdLwbqbJ2QzhL6I+Of0+SDQFe383BLZw0BLZ0kl+9wgwwCz+6/w==
X-Received: by 2002:a05:6402:2065:b0:407:eb07:740 with SMTP id bd5-20020a056402206500b00407eb070740mr1918745edb.406.1647477752122;
        Wed, 16 Mar 2022 17:42:32 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id a22-20020a50ff16000000b00410d029ea5csm1716880edu.96.2022.03.16.17.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 17:42:31 -0700 (PDT)
Date:   Thu, 17 Mar 2022 02:42:29 +0200
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
Subject: Re: [PATCH v5 net-next 08/15] net: bridge: mst: Add helper to check
 if MST is enabled
Message-ID: <20220317004229.dub2qoinhur76co7@skbuf>
References: <20220316150857.2442916-1-tobias@waldekranz.com>
 <20220316150857.2442916-9-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316150857.2442916-9-tobias@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 16, 2022 at 04:08:50PM +0100, Tobias Waldekranz wrote:
> This is useful for switchdev drivers that might want to refuse to join
> a bridge where MST is enabled, if the hardware can't support it.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

>  include/linux/if_bridge.h | 6 ++++++
>  net/bridge/br_mst.c       | 9 +++++++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> index 1cf0cc46d90d..4efd5540279a 100644
> --- a/include/linux/if_bridge.h
> +++ b/include/linux/if_bridge.h
> @@ -119,6 +119,7 @@ int br_vlan_get_info(const struct net_device *dev, u16 vid,
>  		     struct bridge_vlan_info *p_vinfo);
>  int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
>  			 struct bridge_vlan_info *p_vinfo);
> +bool br_mst_enabled(const struct net_device *dev);
>  int br_mst_get_info(const struct net_device *dev, u16 msti, unsigned long *vids);
>  #else
>  static inline bool br_vlan_enabled(const struct net_device *dev)
> @@ -153,6 +154,11 @@ static inline int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
>  	return -EINVAL;
>  }
>  
> +static inline bool br_mst_enabled(const struct net_device *dev)
> +{
> +	return false;
> +}
> +
>  static inline int br_mst_get_info(const struct net_device *dev, u16 msti,
>  				  unsigned long *vids)
>  {
> diff --git a/net/bridge/br_mst.c b/net/bridge/br_mst.c
> index 00b36e629224..830a5746479f 100644
> --- a/net/bridge/br_mst.c
> +++ b/net/bridge/br_mst.c
> @@ -13,6 +13,15 @@
>  
>  DEFINE_STATIC_KEY_FALSE(br_mst_used);
>  
> +bool br_mst_enabled(const struct net_device *dev)
> +{
> +	if (!netif_is_bridge_master(dev))
> +		return false;
> +
> +	return br_opt_get(netdev_priv(dev), BROPT_MST_ENABLED);
> +}
> +EXPORT_SYMBOL_GPL(br_mst_enabled);
> +
>  int br_mst_get_info(const struct net_device *dev, u16 msti, unsigned long *vids)
>  {
>  	const struct net_bridge_vlan_group *vg;
> -- 
> 2.25.1
> 
