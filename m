Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863C53626E0
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 19:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242785AbhDPReC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 13:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236140AbhDPReB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 13:34:01 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBBE5C061574;
        Fri, 16 Apr 2021 10:33:34 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id f29so19662676pgm.8;
        Fri, 16 Apr 2021 10:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=876TdlxpIgolIqB7TgA6C4sSIAHeJmBjH/AC0fUWrq8=;
        b=mKb1rl39y0JzpkxwXj4mL6f6szGIyzuIKbFdNMjxe6nuMkVYGxXW93C/39DhEraJdt
         gEbYxOJ+OTkxSdjRB71o75UBGWLzK8bn9nLXenDL/Uigtoi8XiHRZ8hQ+XWdOVOIhcFt
         gEdg/sniSoty2ZKt9JQnIo8IJBnI0R2MpDbmpyIyOSBem3sl+CsysG0qeN8Mj/Juh5TC
         FeebXUajPAwsYgdda2P58WVF8pO7aQw0Lh2rzADmcrwQlmaogwU3j8ZJQIM9uadYjzOi
         ZXpmrehEe7gDeneL0xmMo0ruIbjgRhqANtI4+ES9O3iduUeb50DV0Fk/DB5zEedvc8BA
         6YSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=876TdlxpIgolIqB7TgA6C4sSIAHeJmBjH/AC0fUWrq8=;
        b=nMgfZm21c6TuFMlDbFoULB0WLzrr5ufJPXAhctIaBYyhD4ooCzpyu6kkgBxApGqIuN
         tOmIYu8iiXOgd6O2mTW40XgFxSTbwW1WXvjxi22aOzG0ObAJ+uANkULtM2sOXcP5gEkm
         GAtJQcfeQ8O2VcUOWtLESpFKzlB7UjtHPtu8biEe4oFVEFh+EYl2e2wsAXqt1dIQfVmn
         WnnWbf9YPxhxzlMxp1mhUwkj9dMalwqwq5AwIw/Bhuu2BmoU4LBhbi0HmCSXK7gmGJU9
         TlBudA+ipUl9B8iFViX1acygZK8D1agqgfdkRS8IBkrlQxRmLXfyvKRSYkW8VY/zl0qr
         T1VA==
X-Gm-Message-State: AOAM531x9YKyZg03aB8yqP2LibbQqk7AFmBLz6obuF1KN6TYWgmIArtI
        p+4ouxAax754gGFzOYimDTA=
X-Google-Smtp-Source: ABdhPJxsMditEAqpW7zYE0X2jC+ufC8elmfmlrUGGu5qb8OzU1RqvlLCacjZNEjuOMuX0e5K3xkXHQ==
X-Received: by 2002:a05:6a00:1687:b029:253:f417:4dba with SMTP id k7-20020a056a001687b0290253f4174dbamr8897443pfc.5.1618594414452;
        Fri, 16 Apr 2021 10:33:34 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id x26sm5347094pfm.134.2021.04.16.10.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 10:33:33 -0700 (PDT)
Date:   Fri, 16 Apr 2021 20:33:19 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH resend net-next 2/2] net: bridge: switchdev: include
 local flag in FDB notifications
Message-ID: <20210416173319.id4y37ecdmwd2u52@skbuf>
References: <20210414165256.1837753-1-olteanv@gmail.com>
 <20210414165256.1837753-3-olteanv@gmail.com>
 <YHmroFOPM3Hl/5uP@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHmroFOPM3Hl/5uP@shredder.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 06:22:08PM +0300, Ido Schimmel wrote:
> On Wed, Apr 14, 2021 at 07:52:56PM +0300, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > As explained in bugfix commit 6ab4c3117aec ("net: bridge: don't notify
> > switchdev for local FDB addresses") as well as in this discussion:
> > https://lore.kernel.org/netdev/20210117193009.io3nungdwuzmo5f7@skbuf/
> > 
> > the switchdev notifiers for FDB entries managed to have a zero-day bug,
> > which was that drivers would not know what to do with local FDB entries,
> > because they were not told that they are local. The bug fix was to
> > simply not notify them of those addresses.
> > 
> > Let us now add the 'is_local' bit to bridge FDB entries, and make all
> > drivers ignore these entries by their own choice.
> > 
> > Co-developed-by: Tobias Waldekranz <tobias@waldekranz.com>
> > Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Thanks!

> One comment below
> 
> > diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> > index c390f84adea2..a5e601e41cb9 100644
> > --- a/net/bridge/br_switchdev.c
> > +++ b/net/bridge/br_switchdev.c
> > @@ -114,13 +114,12 @@ br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
> >  		.addr = fdb->key.addr.addr,
> >  		.vid = fdb->key.vlan_id,
> >  		.added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags),
> > +		.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags),
> >  		.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags),
> >  	};
> >  
> >  	if (!fdb->dst)
> >  		return;
> 
> Do you plan to eventually remove this check so that entries pointing to
> the bridge device itself will be notified? For example:
> 
> # bridge fdb add 00:01:02:03:04:05 dev br0 self local
> 
> > -	if (test_bit(BR_FDB_LOCAL, &fdb->flags))
> > -		return;
> >  
> >  	switch (type) {
> >  	case RTM_DELNEIGH:

Yes I do, it's this patch over here:
https://patchwork.kernel.org/project/netdevbpf/patch/20210224114350.2791260-10-olteanv@gmail.com/

One at a time though.
