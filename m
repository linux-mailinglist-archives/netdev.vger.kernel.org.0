Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4DA46C862
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 00:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233484AbhLGXvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 18:51:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbhLGXvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 18:51:10 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F5DC061574;
        Tue,  7 Dec 2021 15:47:39 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id x6so2280114edr.5;
        Tue, 07 Dec 2021 15:47:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vA4Q0RHvLMyq79s/jfz1F7MJnsng1yXkMUoVh193Hw0=;
        b=cxyLZRQSkFFeFvc4vzgFelg4M/obbDO/IFtytxDMEI7QCgkPzIzJS5R8KBak6qLyUx
         gkv8am0icr7Y1UWU+BN//koLOCw5boprtpLXnSL3M8W6sp12ggZHne6gQatgnITOrkay
         QSoGIgJC2+aAWqbgD9LxgvYUcNmoYtr7NCgRVfjXQ15uGAGfx6anwCKGv87SPtgFHV+s
         Nus2iLOh33my+zIiFT3dMH/opp3Mwgr0xFz7Bg/lS37BbqNLGgRVuatF/lCLKgngQmDT
         2OfT/90wb4aJJRDVgLxfagEx/fCzHhkXvR4L2k1hdgHB2v+yaPcGCzxWY8aBfYcp/bIA
         u0lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vA4Q0RHvLMyq79s/jfz1F7MJnsng1yXkMUoVh193Hw0=;
        b=HvVsysYuAwLOAO7L2t5YCAMN5qDA49hDXyweaEdFf9UUYxUgiJvoXzWNDNjv52Dwgn
         a6SO4jfFu2cOGHHp7KjbbdvGHGPJA0ht7Dy0Fp2uorO4ATqwoRpo3l0o+TgHMSj690Y8
         tsZlQu4W8StpWiPKrHshF2RCryebCfrVoY1T7hP77guvcBo1HUKcCYp6FDVqF/nn/p6n
         5oNnKSTI7C9yM8abmMHW4yd2bstQylSIFsOnsDIn19kk7HQFjBGECLiNdcHnKc+m2Cro
         n5LduiT+Yzg/Uhm4U6SnbB8TxE0/xSeNbGNtO5h+nH6yrPhkxMStBtgokLca+T8eW57I
         4qTA==
X-Gm-Message-State: AOAM533MZWhJeBQL3lCmqXDYfL6LZQ3kn2nzI80OXlvJ7f/bDqRZjQh9
        pqyqskgqOR7+0ikX5nilvyE=
X-Google-Smtp-Source: ABdhPJwYP37i8uztDq9DhC+ym0z7wZVuWeXBUFGSvGV7d64JT6oFaNeaBJ23HIFlw13QJVi+h96/nQ==
X-Received: by 2002:a17:906:3489:: with SMTP id g9mr3049558ejb.17.1638920858032;
        Tue, 07 Dec 2021 15:47:38 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id hx21sm495373ejc.85.2021.12.07.15.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 15:47:37 -0800 (PST)
Date:   Wed, 8 Dec 2021 01:47:36 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/6] Add support for qca8k mdio rw in
 Ethernet packet
Message-ID: <20211207234736.vpqurmattqx4a76h@skbuf>
References: <20211207145942.7444-1-ansuelsmth@gmail.com>
 <Ya+q02HlWsHMYyAe@lunn.ch>
 <61afadb9.1c69fb81.7dfad.19b1@mx.google.com>
 <Ya+yzNDMorw4X9CT@lunn.ch>
 <61afb452.1c69fb81.18c6f.242e@mx.google.com>
 <20211207205219.4eoygea6gey4iurp@skbuf>
 <61afd6a1.1c69fb81.3281e.5fff@mx.google.com>
 <Ya/esX+GTet9PM+D@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ya/esX+GTet9PM+D@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 11:22:41PM +0100, Andrew Lunn wrote:
> > I like the idea of tagger-owend per-switch-tree private data.
> > Do we really need to hook logic?
> 
> We have two different things here.
> 
> 1) The tagger needs somewhere to store its own private data.
> 2) The tagger needs to share state with the switch driver.
> 
> We can probably have the DSA core provide 1). Add the size to
> dsa_device_ops structure, and provide helpers to go from either a
> master or a slave netdev to the private data.

We cannot "add the size to the dsa_device_ops structure", because it is
a singleton (const struct). It is not replicated at all, not per port,
not per switch, not per tree, but global to the kernel. Not to mention
const. Nobody needs state as shared as that.

Given this, do you have objections to the sja1105_port->data model for
shared state?

> 2) is harder. But as far as i know, we have an 1:N setup.  One switch
> driver can use N tag drivers. So we need the switch driver to be sure
> the tag driver is what it expects. We keep the shared state in the tag
> driver, so it always has valid data, but when the switch driver wants
> to get a pointer to it, it needs to pass a enum dsa_tag_protocol and
> if it does not match, the core should return -EINVAL or similar.

In my proposal, the tagger will allocate the memory from its side of the
->connect() call. So regardless of whether the switch driver side
connects or not, the memory inside dp->priv is there for the tagger to
use. The switch can access it or it can ignore it.
