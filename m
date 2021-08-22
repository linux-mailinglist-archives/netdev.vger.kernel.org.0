Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06BC03F425B
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 01:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbhHVX0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 19:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbhHVX0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 19:26:23 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BB9C061575;
        Sun, 22 Aug 2021 16:25:41 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a25so6384480ejv.6;
        Sun, 22 Aug 2021 16:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=oEwuxjvbqeYdRRdJDdNeLoYIGcQWDOv+hdj9rgaB0Dg=;
        b=CgWEf6H3cBXo+I9nquyuyUw8F4TmalzEvAFueTCjAvWd5K81Wn7oHWx9r3J8A4ninH
         ec/2D8HvXbEFtBz3phsnbMw6I38+8f7fERjnpP6MGJcNDXJglP3n8l77DIJTFfbTjdhp
         4TEaM644kOHqdtXyw4kGpX0/00wYAGEJUO/0FYQjv29Md5alWuZuzqORMPCHsvsr8GpD
         xsXzL3K/R85TK8r9QyMjGhf1v5+E1iUIh97Q7OTslpwZaHwtcyOdWKHcjgVJKeJ8x6aT
         /C4kwN2P1t9AKerkqrfIFxRMbhgtfhxWkRhAHb41kd4L+lQQ7eiGpqsrSFsFBbkmVKMk
         1IrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=oEwuxjvbqeYdRRdJDdNeLoYIGcQWDOv+hdj9rgaB0Dg=;
        b=fs+ubNJJt9h0jw2r3780Bl4diGrfrs+7E8/VOe53FMN4PomTAVE7IZoyhafB3PWc0l
         YBQ8cxsQTqcHka3yLdL9ZU3OsVSS3yHoINZqrK8b8bsLD+odTK4bd+lsnf24eoB5PBWv
         /yyVRdbcNHsvwABZdGSacJAX1baatSBCMinPQzwc4JmfyxhGKqh3w0xgf97hwavsDNE0
         zKB4ZRjcmtI1EcIttKEKk8EwG2I1oswkCSeFL1l7Jb2BW/c7lM9rTDBS8TwnGh/UsyMI
         5GgukOm++O4BTyKU4ux/fnw5WwFOGtO7uOZCumX3LgT6T32jcMv9Prq11ywY5KcCh3gR
         yHcA==
X-Gm-Message-State: AOAM531KaTcJVuB+J0Nuczr6AC8cJruAb1kYgHCH4PJmVscg/onqjg2L
        18cQ/S/794Gxdp2oqV0TIVg=
X-Google-Smtp-Source: ABdhPJwT5D8xOs1VfaUYEmkX2+WSvviPW0TwH3Dk4ecFx4i577n/+NyR6q1pe8t5uLkxpSdsVpnc7Q==
X-Received: by 2002:a17:906:8281:: with SMTP id h1mr34234127ejx.352.1629674740224;
        Sun, 22 Aug 2021 16:25:40 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id cq12sm8002441edb.43.2021.08.22.16.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Aug 2021 16:25:40 -0700 (PDT)
Date:   Mon, 23 Aug 2021 02:25:38 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 3/5] net: dsa: tag_rtl8_4: add realtek 8
 byte protocol 4 tag
Message-ID: <20210822232538.pkjsbipmddle5bdt@skbuf>
References: <20210822193145.1312668-1-alvin@pqrs.dk>
 <20210822193145.1312668-4-alvin@pqrs.dk>
 <20210822221307.mh4bggohdvx2yehy@skbuf>
 <9d6af614-d9f9-6e7b-b6b5-a5f5f0eb8af2@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9d6af614-d9f9-6e7b-b6b5-a5f5f0eb8af2@bang-olufsen.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 22, 2021 at 11:11:21PM +0000, Alvin Šipraga wrote:
> >> + *    KEEP       | preserve packet VLAN tag format
> >
> > What does it mean to preserve packet VLAN tag format? Trying to
> > understand if the sane thing is to clear or set this bit. Does it mean
> > to strip the VLAN tag on egress if the VLAN is configured as
> > egress-untagged on the port?
>
> I suppose you mean "Does it mean _don't_ strip the VLAN tag on egress..."?
>
> I'm not sure what the semantics of this KEEP are. When I configure the
> ports to be egress-untagged, the packets leave the port untagged. When I
> configure the ports without egress-untagged, the packets leave the port
> tagged. This is with the code as you see it - so KEEP=0. If I am to
> hazard a guess, maybe it overrides any port-based egress-untagged
> setting. I will run some tests tomorrow.

Ok, then it makes sense to set KEEP=0 and not override the port settings.

> >
> >> +	*p = htons(~(1 << 15) & BIT(dp->index));
> >
> > I am deeply confused by this line.
> >
> > ~(1 << 15) is GENMASK(14, 0)
> > By AND-ing it with BIT(dp->index), what do you gain?
>
> Deliberate verbosity for the human who was engaged in writing the
> tagging driver to begin with, but obviously stupid. I'll remove.

I wouldn't say "stupid", but it's non-obvious, hard to read and at the same time pointless.
I had to take out the abacus to see if I'm missing something.

> >> +	/* Ignore FID_EN, FID, PRI_EN, PRI, KEEP, LEARN_DIS */
> >> +	p = (__be16 *)(tag + 4);
> >
> > Delete then?
>
> Deliberate verbosity again - but I figure any half-decent compiler will
> optimize this out to begin with. I thought it serves as a perfectly fine
> "add stuff here" notice together with the comment, but I can remove in v2.

Keeping just the comment is fine, but having the line of code is pretty
pointless. Just like any half-decent compiler will optimize it out, any
developer with half a brain will figure out what to do to parse
FID_EN ... LEARN_DIS thanks to the other comments.

> >
> >> +
> >> +	/* Ignore ALLOW; parse TX (switch->CPU) */
> >> +	p = (__be16 *)(tag + 6);
> >> +	tmp = ntohs(*p);
> >> +	port = tmp & 0xf; /* Port number is the LSB 4 bits */
> >> +
> >> +	skb->dev = dsa_master_find_slave(dev, 0, port);
> >> +	if (!skb->dev) {
> >> +		netdev_dbg(dev, "could not find slave for port %d\n", port);
> >> +		return NULL;
> >> +	}
> >> +
> >> +	/* Remove tag and recalculate checksum */
> >> +	skb_pull_rcsum(skb, RTL8_4_TAG_LEN);
> >> +
> >> +	dsa_strip_etype_header(skb, RTL8_4_TAG_LEN);
> >> +
> >> +	skb->offload_fwd_mark = 1;
> >
> > At the very least, please use
> >
> > 	dsa_default_offload_fwd_mark(skb);
> >
> > which does the right thing when the port is not offloading the bridge.
>
> Sure. Can you elaborate on what you mean by "at the very least"? Can it
> be improved even further?

The elaboration is right below. skb->offload_fwd_mark should be set to
zero for packets that have been forwarded only to the host (like packets
that have hit a trapping rule). I guess the switch will denote this
piece of info through the REASON code.

This allows the software bridge data path to know to not flood packets
that have already been flooded by the switch in its hardware data path.

Control packets can still be re-forwarded by the software data path,
even if the switch has trapped/not forwarded them, through the
"group_fwd_mask" option in "man ip-link").

> >
> > Also tell us more about REASON and ALLOW. Is there a bit in the RX tag
> > which denotes that the packet was forwarded only to the host?
>
> As I wrote to Andrew, REASON is undocumented and I have not investigated
> this field yet. I have addressed ALLOW upstairs in this email, but
> suffice to say I am not sure.

On xmit, you have. On rcv (switch->CPU), I am not sure whether the
switch will ever set ALLOW to 1, and what is the meaning of that.
