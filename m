Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A8346C4E5
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 21:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241258AbhLGUzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 15:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236446AbhLGUzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 15:55:53 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2ACC061574;
        Tue,  7 Dec 2021 12:52:22 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id o20so808016eds.10;
        Tue, 07 Dec 2021 12:52:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Fim7R1r0cV64FIpGYUgCJ6uujA0JMyHn3Gr0t97V2fE=;
        b=e4hahpGMgGqyeQw4rN9K3dZcb6Jd8KMNLWB9sH5YjlzmXzbNfTvPUxcTHCfBSld9qP
         hxqnTrRayGzlifFU28r9ySTX5yqkwLHJhKAmwsTKJ6SgXRosBsFGZ9k7keC2js8DeIe7
         kffYBZDi2jGJ7+oqW3Dtb1zYVeKZxrKn9NTVU5Z/DV2naVosIe1MorYaNu2+JRd3O3uy
         NgAkCPZqEWvW1nO8c7T2gavU/Kk0Y7BD1ArovYYcNRxmTMHU5L2U6dALyZy7o5++6kQn
         RELlyZgd4XKDmdhbGKNClHZj9iVSnm5WudEwPiwRvqNEvR2lOavSeiR9Mf++XuFS2t0n
         WFNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Fim7R1r0cV64FIpGYUgCJ6uujA0JMyHn3Gr0t97V2fE=;
        b=QtW3ZER/u791t1UiQW4R9JjabJwopdF8z9mc9VyQKx8I7+gJy/J0jLgql2KpzMsgzm
         nVQF12RAtu5epzXp7Y0cM1H8MfrczRI+wd9eigskbckIyEgeMmC4Y0woSTAEfNBQ5ikY
         Fr3gDd8HEzts+2XPvc5XptCOXA9ntOImFklxHrGpD7D/ungwADGn8+rjcLU03RP/RgXQ
         jBadQyS+hVTnOgqaqN/xt7lWDUxGjEpVhvxZ5zid0Zy1hjfO/GcMQQUXnxoUubM3gTRT
         almQgcM64rfRwf7Jg2kCOcO+I/ZrDZpGqqm22DeuNuThqn7+4DSEdIoA9V6XNmGcWVzq
         zvBw==
X-Gm-Message-State: AOAM531bUnlLrPm/u3UxGNaYkAD9ncNtFqWLd6DNK72Ln7jLePHQOsfX
        ile9+caD/pxlILyJennod6Y=
X-Google-Smtp-Source: ABdhPJwWoE8ZwxmAKF5fTgBjukeAPOliH+W4wfSw00nbhuZWPSUTlbEYzkyPnwH+zOwRzCeRiigXmA==
X-Received: by 2002:a17:907:60c9:: with SMTP id hv9mr2060447ejc.482.1638910341292;
        Tue, 07 Dec 2021 12:52:21 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id sg39sm351972ejc.66.2021.12.07.12.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 12:52:20 -0800 (PST)
Date:   Tue, 7 Dec 2021 22:52:19 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/6] Add support for qca8k mdio rw in
 Ethernet packet
Message-ID: <20211207205219.4eoygea6gey4iurp@skbuf>
References: <20211207145942.7444-1-ansuelsmth@gmail.com>
 <Ya+q02HlWsHMYyAe@lunn.ch>
 <61afadb9.1c69fb81.7dfad.19b1@mx.google.com>
 <Ya+yzNDMorw4X9CT@lunn.ch>
 <61afb452.1c69fb81.18c6f.242e@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61afb452.1c69fb81.18c6f.242e@mx.google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 08:21:52PM +0100, Ansuel Smith wrote:
> On Tue, Dec 07, 2021 at 08:15:24PM +0100, Andrew Lunn wrote:
> > > The qca tag header provide a TYPE value that refer to a big list of
> > > Frame type. In all of this at value 2 we have the type that tells us
> > > that is a READ_WRITE_REG_ACK (aka a mdio rw Ethernet packet)
> > > 
> > > The idea of using the tagger is to skip parsing the packet 2 times
> > > considering the qca tag header is present at the same place in both
> > > normal packet and mdio rw Ethernet packet.
> > > 
> > > Your idea would be hook this before the tagger and parse it?
> > > I assume that is the only way if this has to be generilized. But I
> > > wonder if this would create some overhead by the double parsing.
> > 
> > So it seems i remembered this incorrectly. Marvell call this Remote
> > Management Unit, RMU. And RMU makes use of bits inside the Marvell
> > Tag. I was thinking it was outside of the tag.
> > 
> > So, yes, the tagger does need to be involved in this.
> > 
> > The initial design of DSA was that the tagger and main driver were
> > kept separate. This has been causing us problems recently, we have use
> > cases where we need to share information between the tagger and the
> > driver. This looks like it is going to be another case of that.
> > 
> > 	Andrew
> 
> I mean if you check the code this is still somewhat ""separate"".
> I ""abuse"" the dsa port priv to share the required data.
> (I allocate a different struct... i put it in qca8k_priv and i set every
> port priv to this struct)
> 
> Wonder if we can add something to share data between the driver and the
> port so the access that from the tagger. (something that doesn't use the
> port priv)

The one problem relevant to this submission among those referenced by
Andrew is that dp->priv needs to be allocated by the Ethernet switch
driver, although it is used by the tagging protocol driver. So they
aren't really 'separate', nor can they be, the way dp->priv is currently
designed, it can only be "abused", not really "used".

The DSA design allows in principle for any switch driver to return any
protocol it desires in ->get_tag_protocol(). I occasionally test various
tagger submissions by hacking dsa_loop to do just that. But your
tag_qca.c driver would have a pretty unpleasant surprise if it was to be
paired to any other switch driver than qca8k, because that other driver
would either not allocate memory for dp->priv, or (worse) allocate some
other type of structure, expected to be used differently etc.

An even bigger complication is created by the fact that we can
dynamically change tagging protocols in certain cases (dsa <-> edsa,
ocelot <-> ocelot-8021q), and the current design doesn't really scale:
if any tagging protocol required its own dp->priv format, we may end up
with bugs such as the driver not freeing the old dp->priv and setting up
the new one, when the tagging protocol changes. These mistakes are all
too easy to make currently.

Another potential issue, which I don't see present here, but still
worth watching out for, is that the tagger cannot use symbols exported
by the switch, and vice versa. Otherwise the tagger cannot be inserted
into the kernel when built as module, due to missing symbols provided by
the switch. And the switch will not probe until it has a tagger.

I'm afraid we need to make a decision now whether we keep supporting the
separation between taggers and switch drivers, especially since the
tagger could become a bus provider for the switch driver. We need to
weigh the pros and cons.

I thought about what would be needed and I think we'd need tagger-owned
per-switch-tree private data. But this implies that there needs to be a
hook in the tagging protocol driver that notifies it when a certain
struct dsa_switch_tree *dst binds and unbinds to a certain tagger.
Then it could pick and choose the ports that need dp->priv configured in
a certain way: some taggers need the dp->priv of user ports to hold
something per port, others need the dp->priv of _all_ user ports to
point to something shared, others (like yours) apparently need the
dp->priv of the CPU port to hold something. This would become something
handled and owned exclusively by the tagger.

Ansuel, would something like this help you in any way?
