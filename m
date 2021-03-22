Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2FB343F78
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 12:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhCVLSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 07:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbhCVLRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 07:17:41 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2EFC061762
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 04:17:36 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id s17so20527116ljc.5
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 04:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=yLTjcERgg+2Y4X+LYPJUap8s/C4btynzw92t1Wwa11c=;
        b=FnMOIrfxTVkvQEF6lOH2cxhKGYyw9yZr0+ulXzn1SfAghWAc1CBEg5tCFtceKJw4pd
         f7eYEF6qsBffOMF5ay6+oY1SPyclr2vwtHtkQjtEwdg5alT5Q4C5pn+kM8FOomaIhQbq
         POJUNQRJFVll1y7XO2UmuJuxS85HNsvni8V8s1ukgzIeBDNmL1mMqwqMyv8kI9of9qvX
         s3JztuuNGQCwJD3BJ2fcINHqO4HiREtGD1qF06LoL2syVe30C0MkCNjZDTLc4DEfwEmG
         POOEpu0043+T8nwiKErTzJ2vxFJoyiBlfj+tNeIql68FVaet5tP7+W9Gav1uznjj1NPA
         zWWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=yLTjcERgg+2Y4X+LYPJUap8s/C4btynzw92t1Wwa11c=;
        b=BVNs3HuDA4PXUCusNS4sOn7I9+uomjSluZkHmHogch2WxImF+NI2bHWrcXbOxZXQ/r
         kkzGT48y++36qiPcgUdmFci5ioO1iFuh3b7JeuNJEuDY1iJYN5qmqK3NPJLMKOuOnECK
         XuG7deQiGDKDgHt/tDU5iJtTGCQ3OETwinCt9R1ZFG6O3vwuSq2pYJR5zI6K8YwOTrva
         7BmlchYqjZFjvaggtOilKeq0bIsscTLiMnnq/xIk/BmHMqzv64dkZrjWoZsvRapguHU8
         fwTBpHBHBoTUBkapHXw2di2a6m9CiNg7gfhQ1C5FILoZ0jYbnV9N9lDMKuYO4pKVgzzL
         4zsQ==
X-Gm-Message-State: AOAM531cdwANd0a/eHlT/M12C+QZii8olzCxkJq0vGTWMOc71ApthfGg
        66+cQyitrc4LNszkx9V8tuipWA==
X-Google-Smtp-Source: ABdhPJzvMyEwoKslUtrhVLhPp7N98vi3Dw8slMT0C8rn3F3HLnLpjVwsJNf7lmCIa9QEpY1OK6J/xw==
X-Received: by 2002:a2e:9bd6:: with SMTP id w22mr9207565ljj.407.1616411854999;
        Mon, 22 Mar 2021 04:17:34 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id p11sm1543862lfr.235.2021.03.22.04.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 04:17:34 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH v2 net-next 06/16] net: dsa: sync multicast router state when joining the bridge
In-Reply-To: <20210318231829.3892920-7-olteanv@gmail.com>
References: <20210318231829.3892920-1-olteanv@gmail.com> <20210318231829.3892920-7-olteanv@gmail.com>
Date:   Mon, 22 Mar 2021 12:17:33 +0100
Message-ID: <8735wno2sy.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 01:18, Vladimir Oltean <olteanv@gmail.com> wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> Make sure that the multicast router setting of the bridge is picked up
> correctly by DSA when joining, regardless of whether there are
> sandwiched interfaces or not. The SWITCHDEV_ATTR_ID_BRIDGE_MROUTER port
> attribute is only emitted from br_mc_router_state_change.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/dsa/port.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index ac1afe182c3b..8380509ee47c 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -189,6 +189,10 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
>  	if (err && err != -EOPNOTSUPP)
>  		return err;
>  
> +	err = dsa_port_mrouter(dp->cpu_dp, br_multicast_router(br), extack);
> +	if (err && err != -EOPNOTSUPP)
> +		return err;
> +
>  	return 0;
>  }
>  
> @@ -212,6 +216,12 @@ static void dsa_port_switchdev_unsync(struct dsa_port *dp)
>  	dsa_port_set_state_now(dp, BR_STATE_FORWARDING);
>  
>  	/* VLAN filtering is handled by dsa_switch_bridge_leave */
> +
> +	/* Some drivers treat the notification for having a local multicast
> +	 * router by allowing multicast to be flooded to the CPU, so we should
> +	 * allow this in standalone mode too.
> +	 */
> +	dsa_port_mrouter(dp->cpu_dp, true, NULL);

Is this really for the DSA layer to decide? The driver has already been
notified that at least one port is now in standalone mode. So if that
particular driver then requires all multicast to be flooded towards the
CPU, it can make that decision on its own.

E.g. say that you implement standalone mode using a matchall TCAM rule
that maps all frames coming in on a particular port to the CPU. You
could still leave flooding of unknown multicast off in that case. Now
that driver has to figure out if the notification about a multicast
router on the CPU is a real router, or the DSA layer telling it
something that it can safely ignore.

Today I think that most (all?) DSA drivers treats mrouter in the same
way as the multicast flooding bridge flag. But AFAIK, the semantic
meaning of the setting is "flood IP multicast to this port because there
is a router behind it somewhere". This means unknown _IP_ multicast, but
also all known (IGMP/MLD) groups. As most smaller devices cannot
separate IP multicast from the non-IP variety, we flood everything. But
we should also make sure that the port in question receives all known
groups for the _bridge_ in question. Because this is really a bridge
setting, though that information is not carried over to the driver
today. So reusing it in this way feels like it could be problematic down
the road.

>  }
>  
>  int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
> -- 
> 2.25.1
