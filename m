Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20E693FF6D6
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 00:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347576AbhIBWGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 18:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234573AbhIBWGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 18:06:22 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CE3C061575;
        Thu,  2 Sep 2021 15:05:23 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id dm15so5113454edb.10;
        Thu, 02 Sep 2021 15:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=o+2WQogCw3igN9yPZY3CyU3pwsOStgA87+KECE2Hsrw=;
        b=oZNrS5UWuTdiBOFlEemXGuREgWM62AVbVHYFtDJIwNszbeUd9TiOkRLPsg0RUZS2RV
         5CpU3m6rZKMewfFybK9JsxLxm7R63cKKqvUN/dYhETtsyCTmZB4UortEpkBYq1NeqLO4
         wch1Pjxn4AlC0jHWXpR5L2XBChpf8H5bA3F2Q+YdtYXiVEky+/CgxSHjZgFqznzEzG+f
         +JP2XHVlbr0a+kidp4kZo4Y580c9bkPAmbUmo7DgopYS7TmIuu4SMRM1gQbBf2mLMYie
         svDvF3vV3A9fkZOYTgk/3b5ZY/W0VtpWoAk7le7NNJE8ixgXQSomBETvF4Oi0DiPaEd4
         NYlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o+2WQogCw3igN9yPZY3CyU3pwsOStgA87+KECE2Hsrw=;
        b=QUGz8hIq4HI1B2napA39W3V5QUGUDN6DQANlB7Jjj7WcwdEsyJ2X0QjIwTQrxYi2UC
         3zk41Bpzg+v3yvZXWUm7RtMDfVhvdDv0b46Eg6jeNSC6a3mDoMbcdrluZFGYCm21EBWC
         h32Eba5moZ5ouingqHGMMhdlwN4Ivj9SU0cleeobEjXNRtsmDp/OEZB02Qh4Hp00q7/8
         DjnQz7dQ5SAOYNyQrSpKW/XJaiuU5+yG7+atdPYPKkRVA8KUtfv8ZG/mAxDR95txaJOF
         AU9KfZWExsyM/HHJMkEPptu0LYib/Qf7+Iblwr9muDf38Zu6JYyHRfGox8v810WXA84C
         VAGA==
X-Gm-Message-State: AOAM533ipIU4lo1AZGQ1pGYR4YApdG6iIquiDSvfRHW6PzROsWvMungO
        DS7hKeshSJows45untkpUM8=
X-Google-Smtp-Source: ABdhPJzbn24ozn77mvSQqmBLE27jdBnE1HCcitwmPsrisAsN5WOek2/d88f9C7D+m2jjTUAb0w1PWg==
X-Received: by 2002:a05:6402:b7c:: with SMTP id cb28mr535618edb.152.1630620322289;
        Thu, 02 Sep 2021 15:05:22 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id qt23sm1674454ejb.26.2021.09.02.15.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 15:05:21 -0700 (PDT)
Date:   Fri, 3 Sep 2021 01:05:20 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Saravana Kannan <saravanak@google.com>
Cc:     netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH net-next 0/3] Make the PHY library stop being so
 greedy when binding the generic PHY driver
Message-ID: <20210902220520.hyybu6k3mjzbl7mn@skbuf>
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 01:50:50AM +0300, Vladimir Oltean wrote:
> This is a continuation of the discussion on patch "[v1,1/2] driver core:
> fw_devlink: Add support for FWNODE_FLAG_BROKEN_PARENT" from here:
> https://patchwork.kernel.org/project/netdevbpf/patch/20210826074526.825517-2-saravanak@google.com/
> 
> Summary: in a complex combination of device dependencies which is not
> really relevant to what is being proposed here, DSA ends up calling
> phylink_of_phy_connect during a period in which the PHY driver goes
> through a series of probe deferral events.
> 
> The central point of that discussion is that DSA seems "broken" for
> expecting the PHY driver to probe immediately on PHYs belonging to the
> internal MDIO buses of switches. A few suggestions were made about what
> to do, but some were not satisfactory and some did not solve the problem.
> 
> In fact, fw_devlink, the mechanism that causes the PHY driver to defer
> probing in this particular case, has some significant "issues" too, but
> its "issues" are only in quotes "because at worst it'd allow a few
> unnecessary deferred probes":
> https://patchwork.kernel.org/project/netdevbpf/patch/20210826074526.825517-2-saravanak@google.com/#24418895
> 
> So if that's the criterion by which an issue is an issue, maybe we
> should take a step back and look at the bigger picture.
> 
> There is nothing about the idea that a PHY might defer probing, or about
> the changes proposed here, that has anything with DSA. Furthermore, the
> changes done by this series solve the problem in the same way: "they
> allow a few unnecessary deferred probes" <- in this case they provoke
> this to the caller of phy_attach_direct.
> 
> If we look at commit 16983507742c ("net: phy: probe PHY drivers
> synchronously"), we see that the PHY library expectation is for the PHY
> device to have a PHY driver bound to it as soon as device_add() finishes.
> 
> Well, as it turns out, in case the PHY device has any supplier which is
> not ready, this is not possible, but that patch still seems to ensure
> that the process of binding a driver to the device has at least started.
> That process will continue for a while, and will race with
> phy_attach_direct calls, so we need to make the latter observe the fact
> that a driver is struggling to probe, and wait for it a bit more.
> 
> What I've not tested is loading the PHY module at runtime, and seeing
> how phy_attach_direct behaves then. I expect that this change set will
> not alter the behavior in that case: the genphy will still bind to a
> device with no driver, and phy_attach_direct will not return -EPROBE_DEFER
> in that case.
> 
> I might not be very versed in the device core/internals, but the patches
> make sense to me, and worked as intended from the first try on my system
> (Turris MOX with mv88e6xxx), which was modified to make the same "sins"
> as those called out in the thread above:
> 
> - use PHY interrupts provided by the switch itself as an interrupt-controller
> - call of_mdiobus_register from setup() and not from probe(), so as to
>   not circumvent fw_devlink's limitations, and still get to hit the PHY
>   probe deferral conditions.
> 
> So feedback and testing on other platforms is very appreciated.
> 
> Vladimir Oltean (3):
>   net: phy: don't bind genphy in phy_attach_direct if the specific
>     driver defers probe
>   net: dsa: destroy the phylink instance on any error in
>     dsa_slave_phy_setup
>   net: dsa: allow the phy_connect() call to return -EPROBE_DEFER
> 
>  drivers/base/dd.c            | 21 +++++++++++++++++++--
>  drivers/net/phy/phy_device.c |  8 ++++++++
>  include/linux/device.h       |  1 +
>  net/dsa/dsa2.c               |  2 ++
>  net/dsa/slave.c              | 12 +++++-------
>  5 files changed, 35 insertions(+), 9 deletions(-)
> 
> -- 
> 2.25.1
> 

Ouch, I just realized that Saravana, the person whose reaction I've been
waiting for the most, is not copied....

Saravana, you can find the thread here to sync up with what has been
discussed:
https://patchwork.kernel.org/project/netdevbpf/cover/20210901225053.1205571-1-vladimir.oltean@nxp.com/

Sorry.
