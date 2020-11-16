Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB082B54F3
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 00:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbgKPX1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 18:27:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgKPX1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 18:27:35 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F27C0613CF;
        Mon, 16 Nov 2020 15:27:35 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id i19so26815917ejx.9;
        Mon, 16 Nov 2020 15:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wUTJnk0WNF2C1OAWXBX/8iYtXEqbW2vzqFSK0d54U9Q=;
        b=pzxQv8gobywFgQUXzIXno6VDhFKrgI9QizO0rUJSu/TexYTAadGbErSPFqdq+cZ4qf
         56crq6hU7RInP/hhi2NJKs8lomMMZirrEz1WsPGjWGXjjpxT6R9PDgpo9h55UHxGHxoc
         CP5iWYwlwR9Z+6EjEpT0YRLRhUWg1Y0x7KgAUk0foSmVsYqq9hCXVjYZPdvJIdQSjxpk
         7JcOUjjMkaMTNUwruya7K3QiJvMEgjsu1MczHQWvReCNKma/eBdgY4ebeTwAh0p++Hh7
         bA/013Ni8F/32G4B/vA8EEUKieTDexZCObQgoOPmsauQswxZqK3z7i6nzLSEBWPPCIF/
         tcxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wUTJnk0WNF2C1OAWXBX/8iYtXEqbW2vzqFSK0d54U9Q=;
        b=erXtNfjUXroivJ7HoSKBccmxyVpjfk54GXmikGK1nql1+8PoEoJB7cSWUMR/nfKUbb
         HY7Emw7/2d73IUzxnYq4IDgF6B8QFNrHEZ8HqgZEX3fxJQJbL3cxRyoYk3080AQ9F8Eb
         mZVCP5OpCgFkBUwy5YJLFc4VJT6oLRY2COlYvfHe6yaeTx/gVztveUircPUv6S2YyIyL
         WGLJWrJolMFo4hRiT/H4JncT5Bs/Zu+9FQPMHFBXbAaqgzk93AR1ER8S1enJTnhMkHVJ
         sMh3sDw26pRk2aC0JOj2bXFXH4ZNfH2UQ6kA+2Wbj1/QoxkUVClwFHwx6L4thrwu87ta
         o9rw==
X-Gm-Message-State: AOAM5310Lfv286UrU8H9SXyg1GN6H5CT/38VgdjYQX6xqHn3MDdGGwWd
        PPTZv6SCsU/OHruDpapnOfE=
X-Google-Smtp-Source: ABdhPJzys1f8xkCG4Mwiu6Pr1gdY+w0qhQp+nisMviraSzmlPkbGUQb+6IneSJyYWhaZ3L1ZGz7gEA==
X-Received: by 2002:a17:906:5017:: with SMTP id s23mr17580679ejj.359.1605569253053;
        Mon, 16 Nov 2020 15:27:33 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id mj12sm7275991ejb.117.2020.11.16.15.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 15:27:32 -0800 (PST)
Date:   Tue, 17 Nov 2020 01:27:31 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v1 net-next] net: dsa: qca: ar9331: add ethtool stats
 support
Message-ID: <20201116232731.4utpige7fguzghsi@skbuf>
References: <20201115073533.1366-1-o.rempel@pengutronix.de>
 <20201116133453.270b8db5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201116222146.znetv5u2q2q2vk2j@skbuf>
 <20201116143544.036baf58@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201116230053.ddub7p6lvvszz7ic@skbuf>
 <20201116151347.591925ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116151347.591925ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 03:13:47PM -0800, Jakub Kicinski wrote:
> On Tue, 17 Nov 2020 01:00:53 +0200 Vladimir Oltean wrote:
> > On Mon, Nov 16, 2020 at 02:35:44PM -0800, Jakub Kicinski wrote:
> > > On Tue, 17 Nov 2020 00:21:46 +0200 Vladimir Oltean wrote:
> > > > On Mon, Nov 16, 2020 at 01:34:53PM -0800, Jakub Kicinski wrote:
> > > > > You must expose relevant statistics via the normal get_stats64 NDO
> > > > > before you start dumping free form stuff in ethtool -S.
> > > >
> > > > Completely agree on the point, Jakub, but to be honest we don't give him
> > > > that possibility within the DSA framework today, see .ndo_get_stats64 in
> > > > net/dsa/slave.c which returns the generic dev_get_tstats64 implementation,
> > > > and not something that hooks into the hardware counters, or into the
> > > > driver at all, for that matter.
> > >
> > > Simple matter of coding, right? I don't see a problem.
> > >
> > > Also I only mentioned .ndo_get_stats64, but now we also have stats in
> > > ethtool->get_pause_stats.
> >
> > Yes, sure we can do that. The pause stats and packet counter ops would
> > need to be exposed to the drivers by DSA first, though. Not sure if this
> > is something you expect Oleksij to do or if we could pick that up separately
> > afterwards.
>
> Well, I feel like unless we draw the line nobody will have
> the incentive to do the work.
>
> I don't mind if it's Oleksij or anyone else doing the plumbing work,
> but the task itself seems rather trivial.

So then I'll let Oleksij show his availability.

> > > > But it's good that you raise the point, I was thinking too that we
> > > > should do better in terms of keeping the software counters in sync with
> > > > the hardware. But what would be a good reference for keeping statistics
> > > > on an offloaded interface? Is it ok to just populate the netdev counters
> > > > based on the hardware statistics?
> > >
> > > IIRC the stats on the interface should be a sum of forwarded in software
> > > and in hardware. Which in practice means interface HW stats are okay,
> > > given eventually both forwarding types end up in the HW interface
> > > (/MAC block).
> >
> > A sum? Wouldn't that count the packets sent/received by the stack twice?
>
> Note that I said _forwarded_. Frames are either forwarded by the HW or
> SW (former never hit the CPU, while the latter do hit the CPU or
> originate from it).

Ah, you were just thinking out loud, I really did not understand what
you meant by the separation between "forwarded in software" and
"forwarded in hardware".
Yes, the hardware typically only gives us MAC-level counters anyway.
Another way to look at it is that the number of packets forwarded in
hardware from a given port are equal to the total number of RX packets
on that MAC minus the packets seen by the CPU coming from that port.
So all in all, it's the MAC-level counters we should expose in
.ndo_get_stats64, I'm glad you agree. As for the error packets, I
suppose that would be a driver-specific aggregate.

What about RMON/RFC2819 style etherStatsPkts65to127Octets? We have a
number of switches supporting that style of counters, including the one
that Oleksij is adding support for, apparently (but not all switches
though). I suppose your M.O. is that anything standardizable is welcome
to be standardized via rtnetlink?

Andrew, Florian, any opinions here?
