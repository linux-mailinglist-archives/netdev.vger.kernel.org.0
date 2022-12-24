Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9B986556D1
	for <lists+netdev@lfdr.de>; Sat, 24 Dec 2022 02:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbiLXA7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 19:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiLXA7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 19:59:40 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F6C11C3C
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 16:59:38 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id u19so15227051ejm.8
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 16:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FBSmkQWC2D90EzzX9PNo0XxiDNVwP5HWGmkNWPO9CPs=;
        b=WazWPdz69OVU0kO1faSTYZVVZFXZpasyrMjZfgVt1iJDGr+HZQfu9EYxJrbYIZ1DmL
         pn4c9uxYVFmWltXV5949IisBN3ochPGkvhVMRzBGshfF4SeTIBq95ai80BD+CzEsVUB6
         WDFkbV2Z6nSTuibq/hw+DswQAJtfYnlKqXfcW54MFVQQ4ykR1vy8y5KzAzzwkgIinpud
         OOFMOQBsEKYEAxEFAsezMVLlS4ZadsIWwRKy+mZFnrr3QvGoGe3V1yvJw3zlv5894om8
         dROyupCtq30egqehv9aQAnA4HAXt6WqwoLnndfqlbfecqPYuDqBKvQ/LO/7/QL6EBv7o
         9Otg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FBSmkQWC2D90EzzX9PNo0XxiDNVwP5HWGmkNWPO9CPs=;
        b=MbNCseXnzvxNKmRFj1U/0NkqoRgS9YqKQZqB1V5qHDDOo3BoQu3fZn543ADF7Nv7D7
         gAKoeua7vyT2sI7XxGtu2uJdqThYokwU9E+LD1VNvAIUAtqaoIKCRB+y5msZK0gkuI7X
         gUmGhBGf2x8PNBM8XGSpUTOVvdCkFkW3Pe4X0F+O6Jk9yLcxtrCL1hz13fugJD6JO7sX
         QtnLuH17fZBNLY18olsaVzFzPtEg1pJaLm48+RtQd/gSTYpgvxE34q37M9uJIPDBgQ98
         ujMSS8qj+fsjEr1+5JIrAycogqanj2MbAl6Ke2aknDHitoQTldqPaCe7MDeQ9ZJEEcFA
         YXBA==
X-Gm-Message-State: AFqh2kpqB6ORJTmSjHBxw3LarHoq31KEihfmNd3e/7L34fEhp/GzZjda
        vDo9OK6iof9Fe7Y8VMf2+30=
X-Google-Smtp-Source: AMrXdXvYaT32OCIGuVciYAW+r+OociT5ebi0oWi6MT4rihnPrM7/BoU6kf4zKRMv/KzhCtik/ogKdg==
X-Received: by 2002:a17:906:e2c5:b0:81d:3231:5920 with SMTP id gr5-20020a170906e2c500b0081d32315920mr9147003ejb.61.1671843576561;
        Fri, 23 Dec 2022 16:59:36 -0800 (PST)
Received: from skbuf ([188.26.184.176])
        by smtp.gmail.com with ESMTPSA id d23-20020a05640208d700b0047f0af53d92sm2008195edz.91.2022.12.23.16.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Dec 2022 16:59:36 -0800 (PST)
Date:   Sat, 24 Dec 2022 02:59:34 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org
Subject: Re: Crosschip bridge functionality
Message-ID: <20221224005934.xndganbvzl6v5nc3@skbuf>
References: <Y6YDi0dtiKVezD8/@euler>
 <Y6YKBzDJfs8LP0ny@lunn.ch>
 <Y6YVhWSTg4zgQ6is@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6YVhWSTg4zgQ6is@euler>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Colin,

On Fri, Dec 23, 2022 at 12:54:29PM -0800, Colin Foster wrote:
> On Fri, Dec 23, 2022 at 09:05:27PM +0100, Andrew Lunn wrote:
> > On Fri, Dec 23, 2022 at 11:37:47AM -0800, Colin Foster wrote:
> > > Hello,
> > > 
> > > I've been looking into what it would take to add the Distributed aspect
> > > to the Felix driver, and I have some general questions about the theory
> > > of operation and if there are any limitations I don't foresee. It might
> > > be a fair bit of work for me to get hardware to even test, so avoiding
> > > dead ends early would be really nice!
> > > 
> > > Also it seems like all the existing Felix-like hardware is all
> > > integrated into a SOC, so there's really no other potential users at
> > > this time.
> > > 
> > > For a distributed setup, it looks like I'd just need to create
> > > felix_crosschip_bridge_{join,leave} routines, and use the mv88e6xxx as a
> > > template. These routines would create internal VLANs where, assuming
> > > they use a tagging protocol that the switch can offload (your
> > > documentation specifically mentions Marvell-tagged frames for this
> > > reason, seemingly) everything should be fully offloaded to the switches.
> > > 
> > > What's the catch?
> > 
> > I actually think you need silicon support for this. Earlier versions
> > of the Marvell Switches are missing some functionality, which results
> > in VLANs leaking in distributed setups. I think the switches also
> > share information between themselves, over the DSA ports, i.e. the
> > ports between switches.
> > 
> > I've no idea if you can replicate the Marvell DSA concept with VLANs.
> > The Marvell header has D in DSA as a core concept. The SoC can request
> > a frame is sent out a specific port of a specific switch. And each
> > switch has a routing table which indicates what egress port to use to
> > go towards a specific switch. Frames received at the SoC indicate both
> > the ingress port and the ingress switch, etc.
> 
> "It might not work at all" is definitely a catch :-)
> 
> I haven't looked into the Marvell documentation about this, so maybe
> that's where I should go next. It seems Ocelot chips support
> double-tagging, which would lend itself to the SoC being able to
> determine which port and switch for ingress and egress... though that
> might imply it could only work with DSA ports on the first chip, which
> would be an understandable limitation.
> 
> > > In the Marvell case, is there any gotcha where "under these scenarios,
> > > the controlling CPU needs to process packets at line rate"?
> > 
> > None that i know of. But i'm sure Marvell put a reasonable amount of
> > thought into how to make a distributed switch. There is at least one
> > patent covering the concept. It could be that a VLAN based
> > re-implemention could have such problems. 
> 
> I'm starting to understand why there's only one user of
> crosschip_bridge_* functions. So this sounds to me like a "don't go down
> this path - you're in for trouble" scenario.

Trying to build on top of what Andrew has already replied.

Back when I was new to DSA and completely unqualified to be a DSA reviewer/
maintainer (it's debatable whether now I am), I actually had some of the
same questions about what's possible in terms of software support, given
the Vitesse architectural limitations for cross-chip bridging a la Marvell,
in this email thread:
https://patchwork.kernel.org/project/linux-arm-kernel/patch/1561131532-14860-5-git-send-email-claudiu.manoil@nxp.com/

That being said, you need to broaden your detection criteria for cross-chip
bridging; sja1105 (and tag_8021q in general) supports this too, except
it's a bit hidden from the ds->ops->crosschip_bridge_join() operation.
It all relies on the concept of cross-chip notifier chain from switch.c.
dsa_tag_8021q_bridge_join() will emit a DSA_NOTIFIER_TAG_8021Q_VLAN_ADD
event, which the other tag_8021q capable switches in the system will see
and react to.

Because felix and sja1105 each support a tagger based on tag_8021q for
different needs, there is an important difference in their implementations.
The comment in dsa_tag_8021q_bridge_join() - called by sja1105 but not
by felix - summarizes the essence of the difference.

If Felix were to gain support for tag_8021q cross-chip bridging*, the
driver would would need to look at the switch's position within the PCB topology.
On the user ports, tag_8021q would have to be implemented using the VCAP
TCAM rules, to retain support for VLAN-aware bridging and just push/pop the
VLAN that serves as make-shift tag. On the DSA "cascade" ports, tag_8021q
would have to be implemented using the VLAN table, in order to make the
switch understand the tag that's already in the packet and route based
on it, rather than push yet another one. The proper combination of VCAP
rules and VLAN table entries needs much more consideration to cover all
scenarios (CPU RX over a daisy chain; CPU TX over a daisy chain;
autonomous forwarding over 2 switches; autonomous forwarding over 3
switches; autonomous forwarding between sja1105 and felix; forwarding
done by felix for traffic originated by one sja1105 and destined to
another sja1105; forwarding done by felix for traffic originated by a
sja1105 and destined to a felix user port with no other downstream switch).

You might find some of my thoughts on this topic interesting, in the
"Switch topology changes" chapter of this PDF:
https://lpc.events/event/11/contributions/949/attachments/823/1555/paper.pdf

With that development summary in mind, you'll probably be prepared to
use "git log" to better understand some of the stages that tag_8021q
cross-chip bridging has been through.

In principle, when comparing tag_8021q cross-chip bridging to something
proprietary like Marvell, I consider it to be somewhat analogous to
Russian/SSSR engineering: it's placed on the "good" side of the diminishing
returns curve, or i.o.w., it works stupidly well for how simplistic it is.
I could be interested to help if you come up with a sound proposal that
addresses your needs and is generic enough that pieces of it are useful
to others too.

*I seriously doubt that any hw manufacturer would be crazy enough to
use Vitesse switches for an application for which they are essentially
out of spec and out of their intended use. Yet that is more or less the
one-sentence description of what we, at NXP, are doing with them, so I
know what it's like and I don't necessarily discourage it ;) Generally
I'd say they take a bit of pushing quite well (while failing at some
arguably reasonable and basic use cases, like flow control on NPI port -
go figure).
