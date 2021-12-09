Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE4446E114
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 03:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbhLIDDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 22:03:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbhLIDDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 22:03:10 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6232C061746;
        Wed,  8 Dec 2021 18:59:37 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id y12so14645970eda.12;
        Wed, 08 Dec 2021 18:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=s0iRZAJ4YKfdAHbCWbg2s44QSJbfVQdVDell+AQzpQQ=;
        b=AcljCbXq84DxP1SMjAsfM4nlekaEQe0jEbXR0eHqnmlF08NcDtXWjcd0/9mivZwKUU
         Wqb0+WkkdrYP9m2+FI0BJKbH1lVlGpIyadD+MFE+7ak02uuhhFevzkAMFaeo+C4Ipv6K
         +3JvfURLdLffYNRKXNdudJ5i0ThuzFXMRK4nvFLWGmI/JkIJ0N3PrqeklDIzhYgMf4Sx
         V+VNHtlm4xAoafvPvxBH0I96Xuy848NzKr9iklLt+QOC+kXGA/N6jkSp+zn5buvsvSv6
         posExISe+kv/vInhCKJBfAP6V9sIbU+yivETPchOScnfpRqwmfVzWljAl677FAnk8ljB
         nQYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=s0iRZAJ4YKfdAHbCWbg2s44QSJbfVQdVDell+AQzpQQ=;
        b=rBTKE2eFrlNZ2E+b2Wpc/bdXcwiTt+euWaEubVlFNOT0iICD2ibpjj9dpWG7Sn3Hr0
         /NNgBB0c1PvYCVD0+O7XssaAJ4kY9g5U4w3bizpLudpSWCnCgDPJwIDPzok9PgEMCycJ
         YcBbITUY0kRgqkjq49FoOTTHF0DElYj6ihyAccfJBuDSGm2mi0icwZiEWP9Xs4gHei2w
         1UAlvuqx1cc5WO3GDCoyg2iZL9SKxytnly0PiLW5V+ege4udjvMCc6XU9YvLKKWM9zL4
         aqw7ab+IHll8OUIMv2V1FlaCJgI8n5mhCoM59DatrfR5oqgqJ5NeZFSy8If97mTtdsaX
         TUEg==
X-Gm-Message-State: AOAM533vIJOW/0G0nCBz6OqP5+jYm7pOSS0ZMyBnu8klzEMuG36kJADk
        fw7BQoaO9PhqTykkCEx2OAMkc/et3js=
X-Google-Smtp-Source: ABdhPJwcx+23NVamz0UYD/td4FOYKfyKsT14Z0PyK5sBAansT9MNh5zDYifZpGibBubQHrTFN4Nnsg==
X-Received: by 2002:a17:906:f0d4:: with SMTP id dk20mr12154207ejb.257.1639018773762;
        Wed, 08 Dec 2021 18:59:33 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id w23sm2834208edr.19.2021.12.08.18.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 18:59:33 -0800 (PST)
Message-ID: <61b17115.1c69fb81.40795.b778@mx.google.com>
X-Google-Original-Message-ID: <YbFxE3GS/deJLstO@Ansuel-xps.>
Date:   Thu, 9 Dec 2021 03:59:31 +0100
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

Anyway just as an info, I implemented also the mib handler and it does
work correctly. Vladimir implementation works just good and it seems
pretty clean with the tagger used only to implement stuff and the driver
to do the ""dirty"" work.

But anyway for this kind of transaction, we really need a way to track
when it's possible to use it. We need to polish that. Just to not mix
things I will had my comments in the other series about tracking master
up.

-- 
	Ansuel
