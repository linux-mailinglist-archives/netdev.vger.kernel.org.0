Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14CBF26787B
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 09:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbgILHQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 03:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgILHQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 03:16:17 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA5AC061573
        for <netdev@vger.kernel.org>; Sat, 12 Sep 2020 00:16:16 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id e23so16454794eja.3
        for <netdev@vger.kernel.org>; Sat, 12 Sep 2020 00:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=POB3JN0+xYVeO/fgaor5Ey125ssPX7Xk7eW44XrFwig=;
        b=s23RbvZKqRkKJhlEW20YM+fWGWVC81by3yaGqr25ftYfLKKnruiT6hpJYNz6IvwCQ9
         ugvXgOhTG5w53+v4l2jx+4vRNAVjAm50dpR38QOOvR7itNHFw853H8FzZyQm/LobAgHN
         qXS1YbgoII3g0DLPdVzUKxKzERVe1EO2IOqM0lXS3gnvFmsU1LQLoJHmUQzDOh7M7BBS
         noheo0qUBk6bXbA25pXPaItR0eLgbPxjVYTte3P4kx2Vuv6BwSztxMzMj4FHbfdQ+80J
         F/z5OU+bvM9CB3a8wzN1iMsdlFzfKNpptO350XBuQdbp5VIR/JE/GxM4bBZ8AwrCe566
         wnpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=POB3JN0+xYVeO/fgaor5Ey125ssPX7Xk7eW44XrFwig=;
        b=ZEumJiT/5gA+9BxcM4Pv3WZIh635xauaXsr/dFjI5pEsjEiE/pgyOsb+10jpDgOIj2
         AgnE4DYFuOMdsS85wgcmAJjfYZxkbPznc0UYplTslWYbKFQIXD7WvoX2+OEIfwX9FBiR
         SWwaYvfQd7IpJwCpK0Rr3pdf7x5RZYkQi82N2MJ+X8yZCgmT+pPIEzWrtIRCRmqvaxnY
         RVU1xXiVymbcia22U02Sl2jtRo/M+95U7u1FfRB8Xotm89a+0wKjW+zUi3socJjtRtq5
         q0AtRMpKCMD+bV5gCwzkIs6bv/N1uBse6Sve/bN76isr2DZ6NUBmn2QJRYyQ8lnpttAN
         jlxw==
X-Gm-Message-State: AOAM530YT5SVwXcxj8DkSX/G6lODHb0OsO9i7EvivImqiLCpDdVBzD6G
        CWMGCsGVQJMO0rr7+u/t++Al+N4S5os=
X-Google-Smtp-Source: ABdhPJx8LXVnY0Y6E2Tjt3XCsUmQ9KyWk8g9G7zzeQL2E4VMmwefXOaq+lyQU8ypHOXAhv7FU6AHMA==
X-Received: by 2002:a17:906:46c9:: with SMTP id k9mr5063878ejs.38.1599894975233;
        Sat, 12 Sep 2020 00:16:15 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id l15sm2754789ejk.50.2020.09.12.00.16.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2020 00:16:14 -0700 (PDT)
Date:   Sat, 12 Sep 2020 10:16:12 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, mkubecek@suse.cz,
        michael.chan@broadcom.com, tariqt@nvidia.com, saeedm@nvidia.com,
        alexander.duyck@gmail.com, andrew@lunn.ch
Subject: Re: [PATCH net-next v2 0/8] ethtool: add pause frame stats
Message-ID: <20200912071612.cq7adzzxxgpcauux@skbuf>
References: <20200911232853.1072362-1-kuba@kernel.org>
 <20200911234932.ncrmapwpqjnphdv5@skbuf>
 <20200911170724.4b1619d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200912001542.fqn2hcp35xkwqoun@skbuf>
 <20200911174246.76466eec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911174246.76466eec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 05:42:46PM -0700, Jakub Kicinski wrote:
> > The ethtool -S framework was nice because you could append to the
> > counters of the master interface while not losing them.
> > As for "ethtool -A", those parameters are fixed as part of the
> > fixed-link device tree node corresponding to the CPU port.
>
> I think I'm missing the problem you're trying to describe.
> Are you making a general comment / argument on ethtool stats?

No, it appears to me that you're trying to standardize some things out
of ethtool -S. I just want to make sure that, while doing so, you are
aware of some of the more subtle uses of that interface.

> Pause stats are symmetrical - as can be seen in your quote
> what's RX for the CPU is TX for the switch, and vice versa.

If things work, yes. If they don't, no.

> Since ethtool -A $cpu_mac controls whether CPU netdev generates
> and accepts pause frames, correspondingly the direction and meaning
> of pause statistics on that interface is well defined.

Well, with a fixed-link, there's not a lot you can change with "ethtool
--pause" (the link is managed with phylink). Up until now, I have mostly
only heard of links between a DSA master and the CPU port that are not
fixed-link. In theory (and in limited practice), phylink can even drive
a PHY on the CPU port, so in that case, it may make sense for DSA to try
to automatically apply the mirror pause frame configuration of the
master. However, that wasn't supported before, either, and was not what
I was talking about.

> You can still append your custom CPU port stats to ethtool -S or
> debugfs or whatnot,

I don't understand, so you're saying that DSA can keep pause stats
reporting in "ethtool -S", but the rest of devices should move to
"ethtool -a"? You know that a typical switching chip will report the
same statistics counters on all ports, including the ones that do have a
net_device, right?  So DSA gets a waiver from implementing
.get_pause_stats()?

> but those are only useful for validating that the configuration of the
> CPU port is not completely broken. Otherwise the counters are
> symmetrical. A day-to-day user of the device doesn't need to see both
> of them.

A day-to-day user shouldn't need to look at ethtool -S or any other
statistics for that matter, either. If they need to look at flow control
on the CPU port they'd better get the full story rather than half of it.

Sorry for the non-constructive answer. Like Florian said, it would be
nice to have some built-in mechanism for this new ndo that DSA could use
to keep annotating its own stats.

Thanks,
-Vladimir
