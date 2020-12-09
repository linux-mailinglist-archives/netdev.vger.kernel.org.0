Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09F782D464F
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 17:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731035AbgLIQF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 11:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727742AbgLIQFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 11:05:25 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE029C0613CF
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 08:04:44 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id k4so2151582edl.0
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 08:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9AZC02pzyN/oiKFjJqjfH8n/hYLxQYGutmw3GHGDuCE=;
        b=Y6ln2vKeTNaxoxq6VA5EVoXwZvSfQhJIN3wmf5U3i7ry5fj7kXrRjT7ICKJ8wlde/H
         yjT2TakWYLoD9E0B/D6OPOwHPtISZOe+Jr7MMNX6HOzEkdpxX2iZwhH/jFvrWscRnKnw
         LXqQf2HDKguuBvpnHeSbuwnCUskpOpbfp/zPyyz2Zkqcmz+120xpIxNghygd7PPPitnr
         OmMkxxYuwFQzg96otTKi8qCZ7UMykDoGKRImRn4oMLvmfRC00WOPrghwhU7utkN1iNn9
         2xI8wSjRYbaimDcQ/0OxKr3toNg+NpBAaHLfc020tkao+mRqWc0HmqbgLZLSY+xklI9r
         kHFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9AZC02pzyN/oiKFjJqjfH8n/hYLxQYGutmw3GHGDuCE=;
        b=enbv23HLrpDfao/W08ejPZn/ljLGnybqrDD6wq2RoO66KEX5Po7F0+l7VqRQ1tjovX
         P1N+knRn3CeTiY3Qe7AkA509UtDLZ9V9WbtaJuA2s+EPQnCGf9tAOgg2dyhbAhbSFp28
         BgzQHH8wqRqHlb6+TQt7jwRK1j84fjY/oD7/AvfS+xEtK+Oo9UrqoKD8Ad2YGwtCr8S9
         QtbBDOML+A4jrMj7HIPZLwgVp24ba/uPvJx0oOMQnS9Jr4mS+/gOOTA76PspPW7DIRM5
         4dW4sMOWLaDW5rQDrvSsauariRWL18CK95LP7dP0LzjKdQ38vsJz/axIVIQ5SQaTkcq0
         VZwg==
X-Gm-Message-State: AOAM530euF6GyqHpKlbbi3nuwGnUBVywdU1Jl9nzgB10UgtDEK0mggtC
        uDcLc2Pj3DF6B05BLD5kGWg=
X-Google-Smtp-Source: ABdhPJzk+8+aAEeUd+IswBGfnPLHmfzTgy2HzL0mcvRlPAP3AzEeSQc0AB/Qu5fUMQyvuQknWEfpHg==
X-Received: by 2002:a05:6402:158:: with SMTP id s24mr2765729edu.19.1607529883481;
        Wed, 09 Dec 2020 08:04:43 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id n20sm1881261ejo.83.2020.12.09.08.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 08:04:42 -0800 (PST)
Date:   Wed, 9 Dec 2020 18:04:40 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201209160440.evuv26c7cnkqdb22@skbuf>
References: <20201202091356.24075-1-tobias@waldekranz.com>
 <20201202091356.24075-3-tobias@waldekranz.com>
 <20201208112350.kuvlaxqto37igczk@skbuf>
 <87mtyo5n40.fsf@waldekranz.com>
 <20201208163751.4c73gkdmy4byv3rp@skbuf>
 <87k0tr5q98.fsf@waldekranz.com>
 <20201209105326.boulnhj5hoaooppz@skbuf>
 <87eejz5asi.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eejz5asi.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 09, 2020 at 03:11:41PM +0100, Tobias Waldekranz wrote:
> On Wed, Dec 09, 2020 at 12:53, Vladimir Oltean <olteanv@gmail.com> wrote:
> > And I think that .port_lag_change passes more arguments than needed to
> > the driver.
> 
> You mean the `struct netdev_lag_lower_state_info`? Fine by me, it was
> mostly to avoid hiding state from the driver if anyone needed it.

There are two approaches really.
Either you extract the useful information from it, which you already do,
and in that case you don't need to provide the structure from the netdev
notifier to the driver, or you let the driver pick it up. Either way is
fine with me, but having both seems redundant.

> >> > I don't think the DSA switch tree is private to anyone.
> >>
> >> Well I need somewhere to store the association from LAG netdev to LAG
> >> ID. These IDs are shared by all chips in the tree. It could be
> >> replicated on each ds of course, but that does not feel quite right.
> >
> > The LAG ID does not have significance beyond the mv88e6xxx driver, does
> > it? And even there, it's just a number. You could recalculate all IDs
> > dynamically upon every join/leave, and they would be consistent by
> > virtue of the fact that you use a formula which ensures consistency
> > without storing the LAG ID anywhere. Like, say, the LAG ID is to be
> > determined by the first struct dsa_port in the DSA switch tree that has
> > dp->bond == lag_dev. The ID itself can be equal to (dp->ds->index *
> > MAX_NUM_PORTS + dp->index). All switches will agree on what is the first
> > dp in dst, since they iterate in the same way, and any LAG join/leave
> > will notify all of them. It has to be like this anyway.
> 
> This will not work for mv88e6xxx. The ID is not just an internal number
> used by the driver. If that was the case we could just as well use the
> LAG netdev pointer for this purpose. This ID is configured in hardware,
> and it is shared between blocks in the switch, we can not just
> dynamically change them. Neither can we use your formula since this is a
> 4-bit field.
> 
> Another issue is how we are going to handle this in the tagger now,
> since we can no longer call dsa_lag_dev_by_id. I.e. with `struct
> dsa_lag` we could resolve the LAG ID (which is the only source
> information we have in the tag) to the corresponding netdev. This
> information is now only available in mv88e6xxx driver. I am not sure how
> I am supposed to conjure it up. Ideas?

Yeah, ok, I get your point. I was going to say that:
(a) accessing the bonding interface in the fast path seems to be a
    mv88e6xxx problem
(b) the LAG IDs that you are making DSA fabricate are not necessarily
    the ones that other drivers will use, due to various other
    constraints (e.g. ocelot)
so basically my point was that I think you are adding a lot of infra in
core DSA that only mv88e6xxx will use.

My practical proposal would have been to keep a 16-entry bonding pointer
array private in mv88e6xxx, which you could retrieve via:

	struct dsa_port *cpu_dp = netdev->dsa_ptr;
	struct dsa_switch *ds = cpu_dp->ds;
	struct mv88e6xxx_chip *chip = ds->priv;

	skb->dev = chip->lags[source_port];

This is just how I would do it. It would not be the first tagger that
accesses driver private data prior to knowing the net device. It would,
however, mean that we know for sure that the mv88e6xxx device will
always be top-of-tree in a cascaded setup. And this is in conflict with
what I initially said, that the dst is not private to anyone.

I think that there is a low practical risk that the assumption will not
hold true basically forever. But I also see why you might like your
approach more. Maybe Vivien, Andrew, Florian could also chime in and we
can see if struct dsa_lag "bothers" anybody else except me (bothers in
the sense that it's an unnecessary complication to hold in DSA). We
could, of course, also take the middle ground, which would be to keep
the 16-entry array of bonding net_device pointers in DSA, and you could
still call your dsa_lag_dev_by_id() and pretend it's generic, and that
would just look up that table. Even with this middle ground, we are
getting rid of the port lists and of the reference counting, which is
still a welcome simplification in my book.
