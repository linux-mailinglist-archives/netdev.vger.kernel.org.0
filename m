Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE6746C6ED
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 22:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236852AbhLGVvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 16:51:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233118AbhLGVvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 16:51:51 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DB09C061574;
        Tue,  7 Dec 2021 13:48:20 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id t9so518841wrx.7;
        Tue, 07 Dec 2021 13:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=gbLwQ0m8b0pppBXMby0Mo4xSpgaAii9KJ/opI9GkC9c=;
        b=n1GpJ7iAY54wtv/TbHHSyzyg3nQUTOGAW1XsM2eHEJid9WFuM6LW4W/ZCsVrYRzo2/
         5lF4dJKn7k9/XwY4knC+9A69MGniwgAAqfuWox59oqoY4R1QJhpWekSUM+4I6u+fw7Cb
         3Q/Lvevls0aS1GOUueAKkjjlSEo827fDmL0BUPZS/j4A6MCxLHzxoJMdODJkWLxD5xkd
         G/rArx0ex5yqNNm+mXx9KdcgQGU5C6mih0FBi8myP73GX7BUnRUPZGCIsOhhxP1c4mGt
         ZNsJTjbRrJ8vf0Ccc96ofEapaGmWnAanw0jUkiSLtoF7dvLTTcF9DHruYy0mM9NjHEaj
         EHtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=gbLwQ0m8b0pppBXMby0Mo4xSpgaAii9KJ/opI9GkC9c=;
        b=BazUtyadY7gMGI6Q+XAYKFmlOwpMKfDUafZ7K/h+86/jiiYa2tImgnphlI3qsZd2dM
         CwcMRVg+/eQfnL7TExJc739JOPjGrq4zrcktLhgG+T4PKpJlr7G0juVo2xHa7RevRigg
         XieTZYFZTextX7upuTyBZHBnq9ozuyqu3UZLmbLQDKEQ3NpVxZvFrWP5NUwMhvetkSQ5
         aAioYsPaupQJCgMdlhyC1Oz8wTqdNuwXNhQ6eH/fp1BjDy2QI7omlUtr7yh4QSZZPgQ+
         4543US3TB2J/XOE04/rqNCmEvxUM1XWS9aEfmQ+F4RE9ZldpeAgkjhxlGS7WFRofvdT+
         aasw==
X-Gm-Message-State: AOAM531HjGFLxusSQfoclPGLHa3Beg9ACHFfIzircaa1MPyxSHXl1uOU
        20vDM1bROmC39AKlX3DECP6Jl65UgMI=
X-Google-Smtp-Source: ABdhPJxZPMRmyJXA2g80H3/RYM7JYFhMCa25iKrnzVF1RQ9yS9E2eJgYl4U8eZUGCX9xY5JgKT4MTw==
X-Received: by 2002:adf:b35d:: with SMTP id k29mr51986234wrd.466.1638913698308;
        Tue, 07 Dec 2021 13:48:18 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id f15sm965373wmg.30.2021.12.07.13.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 13:48:17 -0800 (PST)
Message-ID: <61afd6a1.1c69fb81.3281e.5fff@mx.google.com>
X-Google-Original-Message-ID: <Ya/Wj2lJLGOO4nly@Ansuel-xps.>
Date:   Tue, 7 Dec 2021 22:47:59 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/6] Add support for qca8k mdio rw in
 Ethernet packet
References: <20211207145942.7444-1-ansuelsmth@gmail.com>
 <Ya+q02HlWsHMYyAe@lunn.ch>
 <61afadb9.1c69fb81.7dfad.19b1@mx.google.com>
 <Ya+yzNDMorw4X9CT@lunn.ch>
 <61afb452.1c69fb81.18c6f.242e@mx.google.com>
 <20211207205219.4eoygea6gey4iurp@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207205219.4eoygea6gey4iurp@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 10:52:19PM +0200, Vladimir Oltean wrote:
> On Tue, Dec 07, 2021 at 08:21:52PM +0100, Ansuel Smith wrote:
> > On Tue, Dec 07, 2021 at 08:15:24PM +0100, Andrew Lunn wrote:
> > > > The qca tag header provide a TYPE value that refer to a big list of
> > > > Frame type. In all of this at value 2 we have the type that tells us
> > > > that is a READ_WRITE_REG_ACK (aka a mdio rw Ethernet packet)
> > > > 
> > > > The idea of using the tagger is to skip parsing the packet 2 times
> > > > considering the qca tag header is present at the same place in both
> > > > normal packet and mdio rw Ethernet packet.
> > > > 
> > > > Your idea would be hook this before the tagger and parse it?
> > > > I assume that is the only way if this has to be generilized. But I
> > > > wonder if this would create some overhead by the double parsing.
> > > 
> > > So it seems i remembered this incorrectly. Marvell call this Remote
> > > Management Unit, RMU. And RMU makes use of bits inside the Marvell
> > > Tag. I was thinking it was outside of the tag.
> > > 
> > > So, yes, the tagger does need to be involved in this.
> > > 
> > > The initial design of DSA was that the tagger and main driver were
> > > kept separate. This has been causing us problems recently, we have use
> > > cases where we need to share information between the tagger and the
> > > driver. This looks like it is going to be another case of that.
> > > 
> > > 	Andrew
> > 
> > I mean if you check the code this is still somewhat ""separate"".
> > I ""abuse"" the dsa port priv to share the required data.
> > (I allocate a different struct... i put it in qca8k_priv and i set every
> > port priv to this struct)
> > 
> > Wonder if we can add something to share data between the driver and the
> > port so the access that from the tagger. (something that doesn't use the
> > port priv)
> 
> The one problem relevant to this submission among those referenced by
> Andrew is that dp->priv needs to be allocated by the Ethernet switch
> driver, although it is used by the tagging protocol driver. So they
> aren't really 'separate', nor can they be, the way dp->priv is currently
> designed, it can only be "abused", not really "used".
> 
> The DSA design allows in principle for any switch driver to return any
> protocol it desires in ->get_tag_protocol(). I occasionally test various
> tagger submissions by hacking dsa_loop to do just that. But your
> tag_qca.c driver would have a pretty unpleasant surprise if it was to be
> paired to any other switch driver than qca8k, because that other driver
> would either not allocate memory for dp->priv, or (worse) allocate some
> other type of structure, expected to be used differently etc.
>
> An even bigger complication is created by the fact that we can
> dynamically change tagging protocols in certain cases (dsa <-> edsa,
> ocelot <-> ocelot-8021q), and the current design doesn't really scale:
> if any tagging protocol required its own dp->priv format, we may end up
> with bugs such as the driver not freeing the old dp->priv and setting up
> the new one, when the tagging protocol changes. These mistakes are all
> too easy to make currently.
> 
> Another potential issue, which I don't see present here, but still
> worth watching out for, is that the tagger cannot use symbols exported
> by the switch, and vice versa. Otherwise the tagger cannot be inserted
> into the kernel when built as module, due to missing symbols provided by
> the switch. And the switch will not probe until it has a tagger.
> 
> I'm afraid we need to make a decision now whether we keep supporting the
> separation between taggers and switch drivers, especially since the
> tagger could become a bus provider for the switch driver. We need to
> weigh the pros and cons.
> 
> I thought about what would be needed and I think we'd need tagger-owned
> per-switch-tree private data. But this implies that there needs to be a
> hook in the tagging protocol driver that notifies it when a certain
> struct dsa_switch_tree *dst binds and unbinds to a certain tagger.
> Then it could pick and choose the ports that need dp->priv configured in
> a certain way: some taggers need the dp->priv of user ports to hold
> something per port, others need the dp->priv of _all_ user ports to
> point to something shared, others (like yours) apparently need the
> dp->priv of the CPU port to hold something. This would become something
> handled and owned exclusively by the tagger.
> 
> Ansuel, would something like this help you in any way?

I agree on all the concern you pointed out. IMHO, current implementation
of the dsa port priv is a bit confusing and someone can really do bad
things with it. (like it's done in this implementation)

The main problem here is that we really need a way to have shared data
between tagger and dsa driver. I also think that it would be limiting
using this only for mdio. For example qca8k can autocast mib with
Ethernet port and that would be another feature that the tagger would
handle.

I like the idea of tagger-owend per-switch-tree private data.
Do we really need to hook logic?
Wonder if something like that would work:
1. Each tagger declare size of his private data (if any).
2. Change tag dsa helper make sure the privata data in dst gets
   allocated and freed.
3. We create some helper to get the tagger private data pointer that
   dsa driver will use. (an error is returned if no data is present)
4. Tagger will use the dst to access his own data.

In theory that way we should be able to make a ""connection"" between
dsa driver and the tagger and prevent any sort of strange stuff that
could result in bug/kernel panic.

I mean for the current task (mdio in ethernet packet) we just need to
put data, send the skb and wait for a response (and after parsing) get
the data from a response skb.

-- 
	Ansuel
