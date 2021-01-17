Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2042F925B
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 13:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728552AbhAQMib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 07:38:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727480AbhAQMi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 07:38:28 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01551C061573
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 04:37:48 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id ke15so12150805ejc.12
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 04:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZqfusA1LBlIXqb1USIb4NJbU7meM8egTJ8cYgiq5HzA=;
        b=CpR5yd9uEtEys9SHHRjv5WK5snsCmlVn9CLUJAFcb1GAx+yAmGZz7aJ9T9SF+yoJ5U
         w+8Q/1Z+DG0r+LUy1b+squ06WWr+ftZs03qfGryi3dtYNygz9jp2L7k9zDjL8xzmajar
         7ZCLVVWOnxOzRkqmXk1LMVZfQwm6YE3awbasFNtCymQ+oTAvEQbRPfQwYX9HY/QoSBFb
         ehUPXXJmuJRrRxckRtp098Xq2z5kVUOB8Dc261uPaxMzPhMl6PTI+ICr8Lc11lX1Fgqq
         AfXBfvjzilUbVZTFmNQNQhgxMhwil6SDmTwpc7RtflejZhkYvX3FaRPgsvLuzckDtyj9
         RERw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZqfusA1LBlIXqb1USIb4NJbU7meM8egTJ8cYgiq5HzA=;
        b=oZix4jxvDbGEFtURo41USccfaWeu/2jRnFOzIRnjttrUWge8zkpTJbGfAqQKgRen5+
         QnvO13+w9GSzrGwBS0K1a/ljH1hIy2Uz81c6XvJAJ/2vSTm+ylu2docYXleJxhzV/CYd
         q6VH99nlibGQa2+Y4z/m+rAQJP8Hhgi7m7ZwTQ3w9wMs94pWL6BZPwsV2oVRaecHgxv8
         JpsaOsGzQRoUL0mPvzZR/2vpDGujFJtC/461nj9bEz/AMGZFaSUD7TkL+eFt/Ma5li5q
         HdUu9VIuxRsdHtrjS94+yRgTX5idD1tBgqMMdaZ6KTrdbydhT6xBuau89e9uH+6HGK1T
         AeoQ==
X-Gm-Message-State: AOAM533iyCrZqf4BivaGdPfjHeOh7P8/NiGuQPYxep2DItKaGmJ4epEA
        e9DyA1jnjFMwbwOXGlP0Us4=
X-Google-Smtp-Source: ABdhPJyGdg+jq5Uk5+nyd/TJ6oOhsSfcrh4zokYY5RoOqprq/tNCkUycoqxYEumlkkV1y36hwkJzlw==
X-Received: by 2002:a17:906:410e:: with SMTP id j14mr14426608ejk.253.1610887066612;
        Sun, 17 Jan 2021 04:37:46 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id v25sm8257159ejw.21.2021.01.17.04.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 04:37:45 -0800 (PST)
Date:   Sun, 17 Jan 2021 14:37:44 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: Re: [PATCH v2 net-next 01/14] net: mscc: ocelot: allow offloading of
 bridge on top of LAG
Message-ID: <20210117123744.erw2i34oap5xkapo@skbuf>
References: <20210116005943.219479-1-olteanv@gmail.com>
 <20210116005943.219479-2-olteanv@gmail.com>
 <20210116172623.2277b86a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210116172623.2277b86a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 16, 2021 at 05:26:23PM -0800, Jakub Kicinski wrote:
> On Sat, 16 Jan 2021 02:59:30 +0200 Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > Commit 7afb3e575e5a ("net: mscc: ocelot: don't handle netdev events for
> > other netdevs") was too aggressive, and it made ocelot_netdevice_event
> > react only to network interface events emitted for the ocelot switch
> > ports.
> >
> > In fact, only the PRECHANGEUPPER should have had that check.
> >
> > When we ignore all events that are not for us, we miss the fact that the
> > upper of the LAG changes, and the bonding interface gets enslaved to a
> > bridge. This is an operation we could offload under certain conditions.
>
> I see the commit in question is in net, perhaps worth spelling out why
> this is not a fix? Perhaps add some "in the future" to the last
> sentence if it's the case that this will only matter with the following
> patches applied?

It is a fix. However, so is patch 13/14 "net: mscc: ocelot: rebalance
LAGs on link up/down events", but I didn't see an easy way to backport
that. Honestly the reasons why I did not attempt to split this series
into a part for "net" and one for "net-next" are:
(a) It would unnecessarily complicate my work for felix DSA, where this
    is considered a new feature as opposed to ocelot switchdev where it
    was supposedly already working (although.. not quite, due to the
    lack of rebalancing, a link down would throw off the LAG).
    I don't really think that anybody was seriously using LAG offload on
    ocelot so far.
(b) Even if I were to split this patch, it can only be trivially
    backported as far as commit 9c90eea310f8 ("net: mscc: ocelot: move
    net_device related functions to ocelot_net.c") from June 2020
    anyway.
(c) I cannot test the mscc_ocelot.ko switchdev driver with traffic,
    since I don't have the hardware (I just have a local patch that
    I keep rebasing on top of net-next which makes me able to at least
    probe it and access its registers on a different switch revision,
    but the traffic I/O procedure there is completely different). So I
    can not really confirm what is the state I'm leaving the mscc_ocelot
    driver in, for stable kernels. At least now, I've made the entry
    points into the control code path very similar to those of DSA, and
    I've exercised the switchdev driver in blind (without traffic), so I
    have a bit more confidence that it should work.
(d) Had the AUTOSEL guys picked up this patch, I would have probably had
    no objection (since my belief is that there's nothing to break and
    nothing to fix in stable kernels).

That being said, if we want to engage in a rigid demonstration of
procedures, sure we can do that. I have other patches anyway to fill the
pipeline until "net" is merged back into "net-next" :)
