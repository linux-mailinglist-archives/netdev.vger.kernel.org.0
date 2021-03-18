Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93098340811
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 15:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbhCROob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 10:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbhCROoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 10:44:24 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C16C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 07:44:24 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id u5so4358673ejn.8
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 07:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eKrCCFZgJJfBC8h7miSHzHGHAvCXjx1HSD845OoM00M=;
        b=JeYC+SxeY4UmpJ2PRRm/KLHzgeEA+ZE+rkqNsWzr6nQmSY1wXnv2vqfdF9+WMtJ5Dn
         rzOMdGly2GCPqhrSkOpRLlLIQX4zDMkFqnIFZT4TDGqV3AfR7CbaoxMDoLM0tpX5hl3I
         g1zzSCvZaWs7k0GzPN4k8+pvxWkhWHpVVOojTxFSfhI5qOLmx7gu+AmLD+dUZ/hHQByn
         sZVuJNGaunYsApkwFybLsOMpxL53/5CUm02MtW7VtwFv8y8wdqgPSBAMgeKjdyxisQ8c
         akC9IRwm1Ksp7LUKa6y15WF9reF4QnHuCtsK6YVKf6AI2lChrXGVTaRGIx0tTLG4UjwP
         aVrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eKrCCFZgJJfBC8h7miSHzHGHAvCXjx1HSD845OoM00M=;
        b=jpP23YVU7HAq083HLdqeU9heo5ayQLX/0zthydcHYv5VxPr7NWVM/aH+J/AurerxsQ
         1eEhJNkHN7yaPKcqVfaaTo8V4KFrQ7fXpaCQp4Q+BvtTXcVwQxE1Mx+e9037ZpGDOO5w
         +U7DjzTtP2AxWleXuBTyl5R/I9iRUh46gmOJED+OlavT6BnUWDKjQ5eK+X3Kf8u0gPlX
         BQyoQu5dOVXksmG21Nu1/CAuv/00BOv2mE2VH1SF8L+i4kFZs9OzPGrF7GgLJxhf+mpT
         f9gTN5glnfabnfEGvUkb5Occz49zQT3nHp5/iOLSOaCmDn4JgwXmnOmghZzrH2wH7Uwo
         PVDw==
X-Gm-Message-State: AOAM5318knkDqQp2huGJA8jyT9gATd7wEods5Sh260aE7oV4zQgHrKEr
        7uxZjbyarN8BbxsVo0b7Xso=
X-Google-Smtp-Source: ABdhPJxe5NjlMq36GaIVOHwT47KAddft98qcpEzHUosiSpt1rq8KJBWHXaBwoOBcZwYAp9b86knrbw==
X-Received: by 2002:a17:906:384e:: with SMTP id w14mr40779678ejc.285.1616078663074;
        Thu, 18 Mar 2021 07:44:23 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id t6sm2270678edq.48.2021.03.18.07.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 07:44:22 -0700 (PDT)
Date:   Thu, 18 Mar 2021 16:44:21 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/8] net: dsa: Add helper to resolve bridge
 port from DSA port
Message-ID: <20210318144421.ecnqtrlhfn6zntkx@skbuf>
References: <20210318141550.646383-1-tobias@waldekranz.com>
 <20210318141550.646383-2-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318141550.646383-2-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 03:15:43PM +0100, Tobias Waldekranz wrote:
> In order for a driver to be able to query a bridge for information
> about itself, e.g. reading out port flags, it has to use a netdev that
> is known to the bridge. In the simple case, that is just the netdev
> representing the port, e.g. swp0 or swp1 in this example:
> 
>    br0
>    / \
> swp0 swp1
> 
> But in the case of an offloaded lag, this will be the bond or team
> interface, e.g. bond0 in this example:
> 
>      br0
>      /
>   bond0
>    / \
> swp0 swp1
> 
> Add a helper that hides some of this complexity from the
> drivers. Then, redefine dsa_port_offloads_bridge_port using the helper
> to avoid double accounting of the set of possible offloaded uppers.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  include/net/dsa.h  | 14 ++++++++++++++
>  net/dsa/dsa_priv.h | 14 +-------------
>  2 files changed, 15 insertions(+), 13 deletions(-)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index dac303edd33d..5c4340ecfeb2 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -493,6 +493,20 @@ static inline bool dsa_port_is_vlan_filtering(const struct dsa_port *dp)
>  		return dp->vlan_filtering;
>  }
>  
> +static inline
> +struct net_device *dsa_port_to_bridge_port(const struct dsa_port *dp)
> +{
> +	if (!dsa_is_user_port(dp->ds, dp->index))
> +		return NULL;
> +

According to my comment from 8/8, you could have replaced this here with

	if (!dp->bridge_dev)
		return NULL;

I think it's more intuitive to not return a bridge port if there isn't
any bridge to speak of. Whether you prefer to do that or not is up to
you, here's my review tag anyway.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

> +	if (dp->lag_dev)
> +		return dp->lag_dev;
> +	else if (dp->hsr_dev)
> +		return dp->hsr_dev;
> +
> +	return dp->slave;
> +}
> +
>  typedef int dsa_fdb_dump_cb_t(const unsigned char *addr, u16 vid,
>  			      bool is_static, void *data);
>  struct dsa_switch_ops {
