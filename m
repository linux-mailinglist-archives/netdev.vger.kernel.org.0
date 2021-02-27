Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0966E326AB2
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 01:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhB0ARi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 19:17:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhB0ARe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 19:17:34 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BFCC06174A
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 16:16:54 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id jt13so17631957ejb.0
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 16:16:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=To/BYdeSxitLkJ0kvvJdi+2IEkk5UaJmW8nCv7113EM=;
        b=Zpu8EHvPJsDdovYuYXZpunpJB2uC/oZmTsTIZk+cV/oR6d1rNqDuU/Y1c9noC6gdFD
         AMBzauwkykyi8zXfXIBCs15uWJbqT+iCWjOHrff0zabyFLrHcW0A/6E1x/YFogzITKNe
         L3wUBGQfkyKKaaa8OEGffgaJ0I0nPpdzYgiukwM50+100P8eITPmvdNvRVdhvdB+P5CJ
         rQpw33kv9rkfT8f/+DB7g/iFDViV+kFC+ulxKtkBjXxfsKymFWrPK4GJpfyVtjeBQF/1
         YRloCIl/QbEjrJLPNo1KsiGbKzB1E3k0VertIp8hxYNsy7f57Pe17dHdy+jyDJWFTx+i
         kwjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=To/BYdeSxitLkJ0kvvJdi+2IEkk5UaJmW8nCv7113EM=;
        b=q805iHKEbIwZUpsJbjDyvHfugapJic9r37v/nBA3hiwTqnMmD0hUIDSKSteRlJ5n9Y
         7XXQMIwQFt/M3tlOm2ZcCHZfwWGbVUCoH94tQy5BwfbWKg3XJWTJHcgHL6EM5R6T8TK7
         aP99nKO9rLYLy7/4yBUQKeqhAWTe5ILBWMl7vunD8Z7wiw76WVtxB4JLzqyHNmzhxqK8
         GXAf9FcUMl7+62ed+Zz35kpVWDGuYnCa974b53hiJ/2rG9nBRoxP+rvQOwG/peyciMA9
         YoL1YtdNywM0bbpo9AXWzln5yLtOZcMQilz1OC23sncDzjkJnHgspzL394hP7PB/egD0
         DUbg==
X-Gm-Message-State: AOAM5325U0uwOz4kSjjtmIYu7RT0qST44I3wiBFNqXjkpCK3xrvFeJ+p
        ToDA0HuqVulgucSUsjF42X4=
X-Google-Smtp-Source: ABdhPJyO9zGF+m2t4X2nBmyMfa/rnN74cgFtZgZQaKHKvpRkinEkmQYlYkeYrQtDnWFQGFXgHOBX6Q==
X-Received: by 2002:a17:906:a101:: with SMTP id t1mr6148252ejy.182.1614385013260;
        Fri, 26 Feb 2021 16:16:53 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id q11sm6233344ejr.36.2021.02.26.16.16.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 16:16:52 -0800 (PST)
Date:   Sat, 27 Feb 2021 02:16:51 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Markus =?utf-8?Q?Bl=C3=B6chl?= <Markus.Bloechl@ipetronik.com>
Subject: Re: [PATCH v2 net 5/6] net: enetc: don't disable VLAN filtering in
 IFF_PROMISC mode
Message-ID: <20210227001651.geuv4pt2bxkzuz5d@skbuf>
References: <20210225121835.3864036-1-olteanv@gmail.com>
 <20210225121835.3864036-6-olteanv@gmail.com>
 <20210226152836.31a0b1bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210226234244.w7xw7qnpo3skdseb@skbuf>
 <20210226154922.5956512b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210226154922.5956512b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 03:49:22PM -0800, Jakub Kicinski wrote:
> On Sat, 27 Feb 2021 01:42:44 +0200 Vladimir Oltean wrote:
> > On Fri, Feb 26, 2021 at 03:28:36PM -0800, Jakub Kicinski wrote:
> > > I don't understand what you're fixing tho.
> > >
> > > Are we trying to establish vlan-filter-on as the expected behavior?
> >
> > What I'm fixing is unexpected behavior, according to the applicable
> > standards I could find. If I don't mark this change as a bug fix but as
> > a simple patch, somebody could claim it's a regression, since promiscuity
> > used to be enough to see packets with unknown VLANs, and now it no
> > longer is...
>
> Can we take it into net-next? What's your feeling on that option?

I see how you can view this patch as pointless, but there is some
context to it. It isn't just for tcpdump/debugging, instead NXP has some
TSN use cases which involve some asymmetric tc-vlan rules, which is how
I arrived at this topic in the first place. I've already established
that tc-vlan only works with ethtool -K eth0 rx-vlan-filter off:
https://lore.kernel.org/netdev/CA+h21hoxwRdhq4y+w8Kwgm74d4cA0xLeiHTrmT-VpSaM7obhkg@mail.gmail.com/
and that's what we recommend doing, but while adding the support for
rx-vlan-filter in enetc I accidentally created another possibility for
this to work on enetc, by turning IFF_PROMISC on. This is not portable,
so if somebody develops a solution based on that in parallel, it will
most certainly break on other non-enetc drivers.
NXP has not released a kernel based on the v5.10 stable yet, so there is
still time to change the behavior, but if this goes in through net-next,
the apparent regression will only be visible when the next LTS comes
around (whatever the number of that might be). Now, I'm going to
backport this to the NXP v5.10 anyway, so that's not an issue, but there
will still be the mild annoyance that the upstream v5.10 will behave
differently in this regard compared to the NXP v5.10, which is again a
point of potential confusion, but that seems to be out of my control.

So if you're still "yeah, don't care", then I guess I'm ok with leaving
things alone on stable kernels.
