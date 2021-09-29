Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7415541C654
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 16:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245583AbhI2OJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 10:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbhI2OJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 10:09:13 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00B44C06161C;
        Wed, 29 Sep 2021 07:07:31 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id x7so8977940edd.6;
        Wed, 29 Sep 2021 07:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vFQqvNSnWmCJgPBVIv0fLxuJugZHZfFnjcNacnv+nUY=;
        b=XjAouqqpvPC6C2koug9Hz7fDBc3/7YafLlgxX5duBljhVHkrMyYsC5WGctm83vhmBM
         9yCwHvrKf5PD+IOlva1tkhIapVXoUrCNpHK+LIFKDHNLX58hyzi41g6Ot6sKDZlZDi7R
         hb8teSMfTuBuYseQzarBIjDQRZZxlp7fk/ach8LLVOo6RJte4qcKOVXfDTz0qraB1hK8
         X06zyBhpm+GBLfBwCkP8HBGNblVSKY6WiVaDI4RYXBnzCLrQ7uxBNCXX97JOBE34tgig
         i3r0NdCg+0UtQcMlK1LDgz8cDZ9Zi9EJ69v+dPGEkVxqN4RnTRRjUlweUCBU9KWCm0ox
         Z0rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vFQqvNSnWmCJgPBVIv0fLxuJugZHZfFnjcNacnv+nUY=;
        b=nADacH0tcO+KAdrw0StUXeGqh076uJCIcR3lTkM00d0YXFlYAwCk+x03qX54/QeBYm
         aiug3y5eUKn1qc8DYiLtvfoM2pyU2F2k6Pzszn+Io3BTObD47+DGTaSI60icO/iWCCHw
         yN2VsMN/baBzKzzlW6yx8DjBzZyqt4FMf8dTaczOOTFVFVlyX/3kmjI2grCXhnunQ8VP
         YLBgd3/5jOjvZ9ed15AasyO4F3AIHTVwJfApIDrPBl/ETqWP45A043fDQ7+R/oG+QTPF
         XY8cm5VRpjVHaLm4KQRzsGDYRfwVFCwMH6tpfx/fch7MQ3feJQHVaIc6NsXP0uEknDIi
         d16A==
X-Gm-Message-State: AOAM532VvO+lwFbFwpJNYHQNndPigruO8dnDcWC6570JIY4ToStmBWty
        CAYZVFtoMU8Q2ZuAaHRBb5ng851CGwU=
X-Google-Smtp-Source: ABdhPJwQabkM7boPK8gypnrl9CchOikh2/JF2KtFZzAunDM4dCwr3LDWRUpIvogoYCwQqih65l4kRQ==
X-Received: by 2002:a17:906:12d4:: with SMTP id l20mr13506998ejb.43.1632924432746;
        Wed, 29 Sep 2021 07:07:12 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id n25sm1765315eda.95.2021.09.29.07.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 07:07:11 -0700 (PDT)
Date:   Wed, 29 Sep 2021 17:07:10 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Circular dependency between DSA switch driver and tagging
 protocol driver
Message-ID: <20210929140710.r6l7kg2njjpreaw4@skbuf>
References: <20210908220834.d7gmtnwrorhharna@skbuf>
 <e0567cfe-d8b6-ed92-02c6-e45dd108d7d7@gmail.com>
 <20210908221958.cjwuag6oz2fmnd2n@skbuf>
 <0ce35724-336d-572e-4ba3-e5a014d035fc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ce35724-336d-572e-4ba3-e5a014d035fc@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 08, 2021 at 04:36:00PM -0700, Florian Fainelli wrote:
> On 9/8/2021 3:19 PM, Vladimir Oltean wrote:
> > On Wed, Sep 08, 2021 at 03:14:51PM -0700, Florian Fainelli wrote:
> > > On 9/8/2021 3:08 PM, Vladimir Oltean wrote:
> > > > Hi,
> > > >
> > > > Since commits 566b18c8b752 ("net: dsa: sja1105: implement TX
> > > > timestamping for SJA1110") and 994d2cbb08ca ("net: dsa: tag_sja1105: be
> > > > dsa_loop-safe"), net/dsa/tag_sja1105.ko has gained a build and insmod
> > > > time dependency on drivers/net/dsa/sja1105.ko, due to several symbols
> > > > exported by the latter and used by the former.
> > > >
> > > > So first one needs to insmod sja1105.ko, then insmod tag_sja1105.ko.
> > > >
> > > > But dsa_port_parse_cpu returns -EPROBE_DEFER when dsa_tag_protocol_get
> > > > returns -ENOPROTOOPT. It means, there is no DSA_TAG_PROTO_SJA1105 in the
> > > > list of tagging protocols known by DSA, try again later. There is a
> > > > runtime dependency for DSA to have the tagging protocol loaded. Combined
> > > > with the symbol dependency, this is a de facto circular dependency.
> > > >
> > > > So when we first insmod sja1105.ko, nothing happens, probing is deferred.
> > > >
> > > > Then when we insmod tag_sja1105.ko, we expect the DSA probing to kick
> > > > off where it left from, and probe the switch too.
> > > >
> > > > However this does not happen because the deferred probing list in the
> > > > device core is reconsidered for a new attempt only if a driver is bound
> > > > to a new device. But DSA tagging protocols are drivers with no struct
> > > > device.
> > > >
> > > > One can of course manually kick the driver after the two insmods:
> > > >
> > > > echo spi0.1 > /sys/bus/spi/drivers/sja1105/bind
> > > >
> > > > and this works, but automatic module loading based on modaliases will be
> > > > broken if both tag_sja1105.ko and sja1105.ko are modules, and sja1105 is
> > > > the last device to get a driver bound to it.
> > > >
> > > > Where is the problem?
> > >
> > > I'd say with 994d2cbb08ca, since the tagger now requires visibility into
> > > sja1105_switch_ops which is not great, to say the least. You could solve
> > > this by:
> > >
> > > - splitting up the sja1150 between a library that contains
> > > sja1105_switch_ops and does not contain the driver registration code
> > >
> > > - finding a different way to do a dsa_switch_ops pointer comparison, by
> > > e.g.: maintaining a boolean in dsa_port that tracks whether a particular
> > > driver is backing that port
> >
> > What about 566b18c8b752 ("net: dsa: sja1105: implement TX timestamping for SJA1110")?
> > It is essentially the same problem from a symbol usage perspective, plus
> > the fact that an skb queue belonging to the driver is accessed.
>
> I believe we will have to accept that another indirect function call must be
> made in order to avoid creating a direct symbol dependency with
> sja1110_rcv_meta() would that be acceptable performance wise?
> --
> Florian

The same circular dependency problem exists between net/dsa/tag_ocelot_8021q.c
and drivers/net/ethernet/mscc/ocelot.c, which exports ocelot_port_inject_frame
and co. This one is fundamentally even worse, I could make all of the
ocelot_port_inject_frame related functions static inline inside
include/linux/dsa/ocelot.h, but for that to do anything, I'd also need
to make the I/O functions themselves static inline, like __ocelot_write_ix
which is called by ocelot_write_rix. That doesn't sound too fun, sooner
or later I'm going to make the entire driver static inline :)

The alternative I see would be to just inject the PTP frames from a
deferred worker, a la sja1105 with its magical SPI commands. A positive
side effect of doing that would be that I can even try harder to inject
them. Currently, because DSA uses NETIF_F_LLTX, it can't return
NETDEV_TX_BUSY to ask the qdisc to requeue the packet, because the qdisc
is, well, noqueue (we talked about this before). But "ocelot_can_inject"
can return false, due to nasty stuff like egress congestion. The current
behavior is to immediately drop the PTP frame, which leads to its own
kind of nastiness - we have that skb enqueued in a list of frames
awaiting TX timestamps, but the timestamp for it will never come because
it's been silently dropped. Then we have a timestamp ID that rolls over
after it counts to 4, and since we keep counting, future PTP timestamps
might match on the skb that is still in the TX timestamping queue but
stale. And nobody will match on the real skb. It goes downhill really
fast and stinks.

What do you think, should I go ahead and make a second user of deferred
xmit (first and foremost to break the cyclic dependency between the
tagger and the driver), and try harder to enqueue the PTP packets
through register-based MMIO?
