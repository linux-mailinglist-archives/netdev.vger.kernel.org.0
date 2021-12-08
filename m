Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337B846D5C0
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235189AbhLHOhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 09:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbhLHOhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 09:37:03 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B12C061746;
        Wed,  8 Dec 2021 06:33:31 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id o20so8961273eds.10;
        Wed, 08 Dec 2021 06:33:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=rrUz7BGkuQFjFV67wpl8KIMwocLRLd64AgF9R6IxDTE=;
        b=EKOqGtCCKTK9oYH3Nu+4ZeoaaG7moIZTgQrw1qeAh4m/vvSpycK43mH8JvjY+GrQ40
         LqN24G83418RKVhcPmCkqs1XfohA5MRyMWwkB8JEuczzo96qA91tkVNlvDsQ5c3DtyjF
         3yeLshL5STMJXKH4DUsPt7gnPEzg5OesjoqX51pZDsFFi06cNcM3hbXfq6fyUiVqzZaV
         +O0qN2cpnipm2IQ5XLmgAc7Ts9yYdMWYo69RiVaECwKvJhjrGD49hcgdnygoHC4kHofX
         lhQZedhazuJu9tTeve9k2U31Kw+5iGqbm4vhIX51igsLHiEmnwzjjGJrhchqSYbLsZup
         tuFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=rrUz7BGkuQFjFV67wpl8KIMwocLRLd64AgF9R6IxDTE=;
        b=kHw42F6y01Sb0kO2vW4MLsrco5E86ZVgvWtbtUkX4O+RKyFFuTJ+cMqn9lGFwKLwgm
         ROTxWDNJqi2IaeXvXLmKq00EMiW9cvlb1j8dyDNdy0jTLLqV5NyEZMRDkgYIsyrbxFX2
         9nNEC46oJf05rBNNUCkJNRpYEuEcPoQ+xOd4eOUAK9zFd+hTDurrH+mHb8ziSB1p1UI1
         tLhab56HOuAF6h4hZ3abRic6rhzIpNj6ZjKrbCB2zli+VbnWIt+My+tgqAKU6Jbm6wPA
         hmZVsS07quhKaYFiw2BRdU1J9TKareHYU4g2MdPXWGIfmz20Qrhh+zzqixzzjlQYTYCK
         uhIQ==
X-Gm-Message-State: AOAM533Z+57QeAVebL0VQiq5k8YZcQc3d8/8wgMeF1gQQxDqiAsBM6tT
        mZd0IGWvDk0wYphxNOaAvAYzMl6k208=
X-Google-Smtp-Source: ABdhPJw1Zqn0rAiN0sJXYqzuRHMKgI+CCrmV30cUwRDkuvVK0OgxKOu/zFnMTa9a7Gkr2RJqq0KRGg==
X-Received: by 2002:a17:907:94ce:: with SMTP id dn14mr8026151ejc.85.1638974009758;
        Wed, 08 Dec 2021 06:33:29 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id my2sm1586073ejc.109.2021.12.08.06.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 06:33:29 -0800 (PST)
Message-ID: <61b0c239.1c69fb81.9dfd0.5dc2@mx.google.com>
X-Google-Original-Message-ID: <YbDCNyB4UXTaRo57@Ansuel-xps.>
Date:   Wed, 8 Dec 2021 15:33:27 +0100
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208123222.pcljtugpq5clikhq@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 02:32:22PM +0200, Vladimir Oltean wrote:
> On Wed, Dec 08, 2021 at 04:40:32AM +0100, Ansuel Smith wrote:
> > I still have to find a solution to a slowdown problem and this is where
> > I would love to get some hint.
> > Currently I still didn't find a good way to understand when the tagger
> > starts to accept packets and because of this the initial setup is slow
> > as every completion timeouts. Am I missing something or is there a way
> > to check for this?
> > After the initial slowdown, as soon as the cpu port is ready and starts
> > to accept packet, every transaction is near instant and no completion
> > timeouts.
> 
> My guess is that the problem with the initial slowdown is that you try
> to use the Ethernet based register access before things are set up:
> before the master is up and ready, before the switch is minimally set
> up, etc.
> 
> I think what this Ethernet-based register access technique needs to be
> more reliable is a notification about the DSA master going up or down.
> Otherwise it won't be very efficient at all, to wait for every single
> Ethernet access attempt to time out before attempting a direct MDIO
> access.
>

Yes that is the main problem. My idea would be a notification fired as
soon as the tagger starts to send/process packet. That way we should be
certain that Ethernet mdio is ready. (then use a bool to comunicate
that the tagger is ready? And a dsa driver would use that or a helper to
understand what is the correct I/O path to use? I would love to remove
all these extra check and make something more direct but I think it
would spam the dsa ops even more)

The timeout has to stay anyway to prevent any type of breakage by the
Ethernet mdio not working.

> But there are some problems with offering a "master_going_up/master_going_down"
> set of callbacks. Specifically, we could easily hook into the NETDEV_PRE_UP/
> NETDEV_GOING_DOWN netdev notifiers and transform these into DSA switch
> API calls. The goal would be for the qca8k tagger to mark the
> Ethernet-based register access method as available/unavailable, and in
> the regmap implementation, to use that or the other. DSA would then also
> be responsible for calling "master_going_up" when the switch ports and
> master are sufficiently initialized that traffic should be possible.
> But that first "master_going_up" notification is in fact the most
> problematic one, because we may not receive a NETDEV_PRE_UP event,
> because the DSA master may already be up when we probe our switch tree.
> This would be a bit finicky to get right. We may, for instance, hold
> rtnl_lock for the entirety of dsa_tree_setup_master(). This will block
> potentially concurrent netdevice notifiers handled by dsa_slave_nb.
> And while holding rtnl_lock() and immediately after each dsa_master_setup(),
> we may check whether master->flags & IFF_UP is true, and if it is,
> synthesize a call to ds->ops->master_going_up(). We also need to do the
> reverse in dsa_tree_teardown_master().

Should we care about holding the lock for that much time? Will do some
test hoping the IFF_UP is sufficient to make the Ethernet mdio work.

-- 
	Ansuel
