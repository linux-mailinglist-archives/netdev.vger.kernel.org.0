Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B403149AA83
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 05:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1326122AbiAYDkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 22:40:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1313536AbiAYCss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 21:48:48 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336A1C061747;
        Mon, 24 Jan 2022 16:04:43 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id p15so26021298ejc.7;
        Mon, 24 Jan 2022 16:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W71C0v5EvF5HVGKANsilC3VZ/yenGYfwtXQzi/osySw=;
        b=XglpY4J70hESr9fn8wrqXu8tX4R8GzwrZqkhwstzBzA75O4FsethTLOMOp4fXWlvKe
         sVWtKliLJl2YKRt4CXb1g9DPBpEMxJGA9DBr6oYCwDpQ/aibJB1IIpzFJX9EgQbnWF0z
         gWp3HT6XH+Gc3+3y/X+mTyH40FoN/TpRq4JLBgQ6UZJso+vP28uz6p0O/P5pBybo8pBz
         lrP21YQ98ByoEIGvu5guoLgNGPAacnTlnstwhl2novNzmyrXI/RgeYGNQuStJKIpf4Ej
         IMRIOpT9lt7IiN8gdMlSChanWXBe78gNVEMSUi/4qQSdc7pP7SgdVpnugWIIU+zm8YJv
         8E+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W71C0v5EvF5HVGKANsilC3VZ/yenGYfwtXQzi/osySw=;
        b=rPwF4J2E3RRoS/FuM3cz40TI0oI1zzzzMnaRjClWfoGAM7imiWAwX7ooWosbvtyGfe
         D3sOuDVBLc4SfrvKcOArGeTyvvjuScUern9inDZ/OvSjcpZ8a+FD2VdLjMZS2Y09DFNJ
         WPsgiU3NCkXHihWVrB62OM5Z7uPtDeBDDWZfYBEN9xHyY0wSsXS/2nDL//Ha9GQP/sdT
         86o+BaY8n6lSEFNJ2fIDM8862+eFgrbvGrIt5yW6zVDgzuItHFQonSLPTS+XVZLqH43w
         +Y6z4C5B5QfDsvvCz7t3oifugL7r9GUN6UfqqSEpkDOvRoEh03rPPtdriNWlksEcVoRi
         Yvhg==
X-Gm-Message-State: AOAM533wMywJzggjI69ApA66RxJe+VurVvUFQZOlicCisCHf8s2ZYMqf
        I47KcOjAH8REWFPSRD1nmEw=
X-Google-Smtp-Source: ABdhPJxcE7y5RNIqBzFldO7Er81oqzpsubv12PnOVaY8E5PITMD7Ye8STVzFVKLJWSPKkWdVt2wiNQ==
X-Received: by 2002:a17:907:7b8b:: with SMTP id ne11mr13945663ejc.436.1643069081571;
        Mon, 24 Jan 2022 16:04:41 -0800 (PST)
Received: from skbuf ([188.25.255.2])
        by smtp.gmail.com with ESMTPSA id g8sm5511019ejt.26.2022.01.24.16.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 16:04:41 -0800 (PST)
Date:   Tue, 25 Jan 2022 02:04:39 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 2/2] net: dsa: Avoid cross-chip syncing of VLAN
 filtering
Message-ID: <20220125000439.c4lbw3ivwunzzz23@skbuf>
References: <20220124210944.3749235-1-tobias@waldekranz.com>
 <20220124210944.3749235-3-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124210944.3749235-3-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 10:09:44PM +0100, Tobias Waldekranz wrote:
> Changes to VLAN filtering are not applicable to cross-chip
> notifications.

Yes, it seems so. In a cross-chip setup, ports will individually leave
the bridge, leaving every switch a chance to unset VLAN filtering.
We have this check in dsa_port_vlan_filtering(), so it's easy to forget
that the function is called more times than actually needed:

	if (dsa_port_is_vlan_filtering(dp) == vlan_filtering)
		return 0;

Sorry.

> On a system like this:
> 
> .-----.   .-----.   .-----.
> | sw1 +---+ sw2 +---+ sw3 |
> '-1-2-'   '-1-2-'   '-1-2-'
> 
> Before this change, upon sw1p1 leaving a bridge, a call to
> dsa_port_vlan_filtering would also be made to sw2p1 and sw3p1.
> 
> In this scenario:
> 
> .---------.   .-----.   .-----.
> |   sw1   +---+ sw2 +---+ sw3 |
> '-1-2-3-4-'   '-1-2-'   '-1-2-'
> 
> When sw1p4 would leave a bridge, dsa_port_vlan_filtering would be
> called for sw2 and sw3 with a non-existing port - leading to array
> out-of-bounds accesses and crashes on mv88e6xxx.
> 
> Fixes: d371b7c92d19 ("net: dsa: Unset vlan_filtering when ports leave the bridge")
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  net/dsa/switch.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/net/dsa/switch.c b/net/dsa/switch.c
> index 9f9b70d6070a..517cc83d13cc 100644
> --- a/net/dsa/switch.c
> +++ b/net/dsa/switch.c
> @@ -180,9 +180,11 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
>  						info->sw_index, info->port,
>  						info->bridge);
>  
> -	err = dsa_switch_sync_vlan_filtering(ds, info);
> -	if (err)
> -		return err;
> +	if (ds->dst->index == info->tree_index && ds->index == info->sw_index) {
> +		err = dsa_switch_sync_vlan_filtering(ds, info);
> +		if (err)
> +			return err;
> +	}

As net-next material, we could probably move this call to
dsa_port_switchdev_unsync_attrs() where there's even a comment that
references it, and do away with the targeted switch check.

>  
>  	return dsa_tag_8021q_bridge_leave(ds, info);
>  }
> -- 
> 2.25.1
> 

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
