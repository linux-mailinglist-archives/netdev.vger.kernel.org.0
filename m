Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D084364D48
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 23:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbhDSVtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 17:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbhDSVtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 17:49:43 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13050C06174A;
        Mon, 19 Apr 2021 14:49:13 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id w23so39413052ejb.9;
        Mon, 19 Apr 2021 14:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JXn3Ho4kiCXgfD9yiFqXvyQpWztZ1i1zYDQa5yNiDZc=;
        b=XYlUOBnp2/x5oRaftrKVeFxht1ldNP926XPqKRU+E/7YeckSuPEv6T0uf2FbILZTXr
         uvNZ/gblRKnjRVPnVgid9/xKUyjsO2XlgV2l/QrokTZCoYaPcnUhIrbldHu3ereccX5z
         cU2nvAs+a1hyZm6OiJx7iugB+2DT4tLuH2uzedIT7TowLxcEpczi+e23RKQM0QdsyNAH
         m+CEQCqQRS0Y4AUaWBd9kxHSki3g/eoAuWk8bNSVfBstqFQbu51WOyoPuS/A7Bw2A5De
         8vuzpFW/RXrP3Y8PclC3gCa62q65iMLNtbBvsXIazXQ+cTtK/0RMG881wSohd3FzdyBh
         g0ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JXn3Ho4kiCXgfD9yiFqXvyQpWztZ1i1zYDQa5yNiDZc=;
        b=J6WygCXQUduHm1qNQZI0Gn8hTsy6fQAgxwZa1NF9/B+abr9W6eEW9DodRSie6LPgZ9
         7Y4sgVc9/3md+VJa+xcL6gSVKsG9LbWa6fGrEp5LDmQurjU9X7SwVksVUhwFD5kUqeaI
         UIJCV5GsabdCzshjLYQBXKg4uJc/HKgygvXG5jtmXwv0TBWDiYkz3PoyV+HIN80Mwi4m
         fCUS0c2i+HSg6Vhjcbcm/YS/ftIVit/+yXC7tPaRrGgO+kjsITiFwpREFe8ioqzXbVeg
         OVOdS3F6yMIzISWF+3hWGySH58dM/xip6mPnUrtVjKose/b+6+EOH94CA+xqG7KGNc/T
         92WA==
X-Gm-Message-State: AOAM530Bj0zxlgo1ltc8urdCn8zFNmC0znciJV3fXc+4tjISh7Gy4ymd
        /EoPFEOBg6aINhOiWagM60Y=
X-Google-Smtp-Source: ABdhPJwBrVAk/GfJi5L+sXZgnSX5Ru9B38JGSNzpVli67R72dNlR9iVRpGiEX5Dsp9J/bQ8ifCbvWQ==
X-Received: by 2002:a17:906:cc88:: with SMTP id oq8mr20169472ejb.66.1618868951554;
        Mon, 19 Apr 2021 14:49:11 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id i25sm11315695edr.68.2021.04.19.14.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 14:49:11 -0700 (PDT)
Date:   Tue, 20 Apr 2021 00:49:10 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 0/5] Flow control for NXP ENETC
Message-ID: <20210419214910.hbwry2cnjn6d7crf@skbuf>
References: <20210416234225.3715819-1-olteanv@gmail.com>
 <20210419140442.79dd0ce0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419140442.79dd0ce0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Mon, Apr 19, 2021 at 02:04:42PM -0700, Jakub Kicinski wrote:
> On Sat, 17 Apr 2021 02:42:20 +0300 Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > This patch series contains logic for enabling the lossless mode on the
> > RX rings of the ENETC, and the PAUSE thresholds on the internal FIFO
> > memory.
> > 
> > During testing it was found that, with the default FIFO configuration,
> > a sender which isn't persuaded by our PAUSE frames and keeps sending
> > will cause some MAC RX frame errors. To mitigate this, we need to ensure
> > that the FIFO never runs completely full, so we need to fix up a setting
> > that was supposed to be configured well out of reset. Unfortunately this
> > requires the addition of a new mini-driver.
> 
> FWIW back in the day when I was working on more advanced devices than 
> I deal with these days I was expecting to eventually run into this as
> well and create some form of devlink umbrella. IMHO such "mini driver"
> is a natural place for a devlink instance, and not the PFs/ports.
> Is this your thinking as well? AFAICT enetc doesn't implement devlink
> today so you start from whatever model works best without worrying
> about backward compat.

Sorry, but I am not sure if I understood the central idea of what you
were trying to transmit. What is 'a devlink instance and not the PFs'?
I am not aware of how a single devlink instance can be exposed for a
piece of hardware presenting itself as multiple PFs with multiple driver
instances running asynchronously and potentially being assigned to AMP
software execution environments (other cores running non-Linux, and most
probably Linux is not even the privileged execution environment which
has write access to the FIFO parameters).
Are you suggesting that the FIFO size and partitioning characteristics
be exposed through the devlink subsystem? Isn't that what devlink-sb is
for? Also, that would not help with what the IERB driver is trying to
achieve. There isn't anything we want the user to view or fiddle with,
the reality is simply that the FIFO parameters were supposed to be
one-size-fits-all-and-nobody-cares-about-them (the memory usage scheme
of this NIC is smart enough to allow for that, or so I think) but
nonetheless, the hardware defaults need to be touched up. If LS1028A was
a new SoC today we would have probably done this from U-Boot, from the
same logic that already passes the MAC addresses to the PFs through the
IERB, but the ship has kind of sailed for that, bootloaders are stable,
and 'Linux needs this feature' is not a good reason to update them.
So this is all that I would like the IERB driver to do, notice how it's
all writes of predefined values but no reads. For next generation SoCs
with ENETC we'll try our best to not need an IERB driver in Linux at
all. Another option would have been to do these fixups in the arch init
code as a sort of erratum workaround, but I didn't find a place similar
to arch/arm/mach-* for arm64, so I assumed that the arm64 port just
doesn't want to go that route. So here I am with a driver for some
memory writes.
