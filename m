Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E228546D641
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235680AbhLHPCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 10:02:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235732AbhLHPB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 10:01:56 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C75C0698C7;
        Wed,  8 Dec 2021 06:58:24 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id x15so9405533edv.1;
        Wed, 08 Dec 2021 06:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=X3M8997nv4xlUTJpKcJO9GwVF2rNYNXc8YpfLL0n9N4=;
        b=ehXSZCA32Do3nYDYE+avDokc05jaJOqV9f6zhvuWZAEihSORdZkVBt2Bonib3nVngt
         Hzio39pKSoqZIMqTfeH/fUFXdna0zi7WvGQNzQWbMqYvYxZuU4qK9zHKXk/bixNC6jYO
         6I24wd3JfphYWyWUFcJiSMVWQXqtEb565kPNDykEK6U9YuDcx9Tq166KputxrQ0NB5x5
         TSAE0e6Y/vIrGvSx7QAi6sWFzlHMq4dS1rV//WJC9gZCXAuSMoxfx2D8dea+55xHiVZd
         XQ7kHTnw8p/YZ+mGCk+cJQHEKs8PesbF7BvmJQZ7gUJ/XBrhRqU7Mn/CejkgYd7MiQE3
         aQxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=X3M8997nv4xlUTJpKcJO9GwVF2rNYNXc8YpfLL0n9N4=;
        b=wXv6XEpJjZKpbQo6AixxxwTRXgui0W5JbJMhafnq1wiHE3DOk0cvirkTf89haGscKi
         V2b4Nk0Yv99bBYGuLgBXV0+fZJEAs2NB8fy0c8bBjnpRa86sRbz8/uGWhIAvgpEb/Oq8
         BHt97TgaeA9n86d6iUPMt3Cx4mm0EJr5PMt/qFfajzByfMOniRyO3V6QS85UbgAYIu2e
         wFkmYZQfuRtkyapRiu6dhHOYnujPezlo4/W64nrIDIXvPT+GDrzqMlkxHy/FATDOTQLW
         UmbK2MD0TRUu9IfGeHl4sN6IG4sLz01S4aOGAqIqEr7YhSv0BhcJfP/+er35kd+Ep33q
         yOwQ==
X-Gm-Message-State: AOAM531MuiVuNrmAmvhsG2A0kWx06wNqC0RE4KhrDhMOFHJWYUXLYApZ
        ABhzroFuG1HgWqlACnCWApM=
X-Google-Smtp-Source: ABdhPJzN0q2F2VXdsTnGYZ67WAwepdrY3jvP2FKbCRekKcI7y3Z+ltqbZ/0SaKF+U65pOiDAYBJdTw==
X-Received: by 2002:a05:6402:d49:: with SMTP id ec9mr19895291edb.235.1638975502609;
        Wed, 08 Dec 2021 06:58:22 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id e1sm1598746ejy.82.2021.12.08.06.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 06:58:22 -0800 (PST)
Message-ID: <61b0c80e.1c69fb81.4b5cc.5f7e@mx.google.com>
X-Google-Original-Message-ID: <YbDIDGPpFOUNJENX@Ansuel-xps.>
Date:   Wed, 8 Dec 2021 15:58:20 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH v2 0/8] Add support for qca8k mdio rw in
 Ethernet packet
References: <20211208034040.14457-1-ansuelsmth@gmail.com>
 <20211208123222.pcljtugpq5clikhq@skbuf>
 <61b0c239.1c69fb81.9dfd0.5dc2@mx.google.com>
 <20211208145341.degqvm23bxc3vo7z@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208145341.degqvm23bxc3vo7z@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 04:53:41PM +0200, Vladimir Oltean wrote:
> On Wed, Dec 08, 2021 at 03:33:27PM +0100, Ansuel Smith wrote:
> > > But there are some problems with offering a "master_going_up/master_going_down"
> > > set of callbacks. Specifically, we could easily hook into the NETDEV_PRE_UP/
> > > NETDEV_GOING_DOWN netdev notifiers and transform these into DSA switch
> > > API calls. The goal would be for the qca8k tagger to mark the
> > > Ethernet-based register access method as available/unavailable, and in
> > > the regmap implementation, to use that or the other. DSA would then also
> > > be responsible for calling "master_going_up" when the switch ports and
> > > master are sufficiently initialized that traffic should be possible.
> > > But that first "master_going_up" notification is in fact the most
> > > problematic one, because we may not receive a NETDEV_PRE_UP event,
> > > because the DSA master may already be up when we probe our switch tree.
> > > This would be a bit finicky to get right. We may, for instance, hold
> > > rtnl_lock for the entirety of dsa_tree_setup_master(). This will block
> > > potentially concurrent netdevice notifiers handled by dsa_slave_nb.
> > > And while holding rtnl_lock() and immediately after each dsa_master_setup(),
> > > we may check whether master->flags & IFF_UP is true, and if it is,
> > > synthesize a call to ds->ops->master_going_up(). We also need to do the
> > > reverse in dsa_tree_teardown_master().
> > 
> > Should we care about holding the lock for that much time? Will do some
> > test hoping the IFF_UP is sufficient to make the Ethernet mdio work.
> 
> I'm certainly not smart enough to optimize things, so I'd rather hold
> the rtnl_lock for as long as I'm comfortable is enough to avoid races.
> The reason why we must hold rtnl_lock is because during
> dsa_master_setup(), the value of netdev_uses_dsa(dp->master) changes
> from false to true.
> The idea is that if IFF_UP isn't set right now, no problem, release the
> lock and we'll catch the NETDEV_UP notifier when that will appear.
> But we want to
> (a) replay the master up state if it was already up while it wasn't a
>     DSA master
> (b) avoid a potential race where the master does go up, we receive that
>     notification, but netdev_uses_dsa() doesn't yet return true for it.
> 
> The model would be similar to what we have for the NETDEV_GOING_DOWN
> handler.
> 
> Please wait for me to finish the sja1105 conversion. There are some
> issues I've noticed in your connect/disconnect implementation that I
> haven't had a chance to comment on, yet. I've tested ocelot-8021q plus
> the tagging protocol change and these appear fine.
> I'd like to post the changes I have, to make sure that what works for me
> works for you, and what works for you works for me. I may also have some
> patches laying around that track the master up/down state (I needed
> those for some RFC DSA master change patches). I'll build a mini patch
> series and post it soon-ish.

Sure no problem. In the meantime we can also wait if Andrew notice other
problem with this new implementation. (I will work on the mib handler as
it's still wip and on fixing the error on the last patch)

-- 
	Ansuel
