Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 536E33693F9
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 15:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236660AbhDWNq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 09:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236205AbhDWNqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 09:46:54 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BDD2C061574;
        Fri, 23 Apr 2021 06:46:18 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id w10so35240831pgh.5;
        Fri, 23 Apr 2021 06:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qC5oAF0LCV2smCpG9lcsibtCqHio7VsuBKncdkX9ZQA=;
        b=p/ji8ecxIkCfR8+dpmj3R9pVQNx9MhyxKz9cR+W+cmMrXEQoYwc4/fuJwhdM2dEahn
         L8PjBwznvVfn0SfNhF5KzgttckpQaBtj+8mFzEAiifdERm1dHsM/a3ZFoM/P8u+fQQUP
         R+syYZSKIMnXkFJRdMqTzr9xP/NJjbFYyln0mXadE8M5WpdRSMOzNUtc1lXNPkKpAfC8
         r8F2v/WYvhWLBTY14v0W6ULBnOjikE9aO+sCsUMbDQUUIRg69zotVwwnkmF6UNBvgIGs
         4XGNg3vsUXXxh5gQ85TC5fGtaKcDVAqy8JnMARF3Bx2o/4jUa0QbMHHIVgHJ935dzYSA
         a9rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qC5oAF0LCV2smCpG9lcsibtCqHio7VsuBKncdkX9ZQA=;
        b=qsf0k7hAbWWzJVSG0LxLwbC9ry/hyLbNzyF7t0n8SSaTW0V4q++IJv/yek4PgqvAZZ
         L4eKhWbdc2x3OhGDbQdLi88MfEavrbHumZPrMQpN04g5O7n78Cpg72g3/C6fT9PpJRBl
         gpaCQPrHhp202IeQ+5aLh7jGPa7FLzXY38eQlCvU1b8nINSQzsTZyE9tOsesQCZNUFxD
         e/QNGsjnctNtKSV5r2299kw1Z1lrF1Y9sahcJIZUlfPs01FDRyfkN6JHYv8M2MrHhUBU
         0DYA8jnjdRsVh0Jujpond8jB06UlQAXwqVVXLe5WhVYy7P69X9lYcKkiT6DHhKXd9Zgg
         b0bQ==
X-Gm-Message-State: AOAM532RGKnqpi9o99edkMw13VUuv6A+YNzAJQ4H2k2wEXWopETfV/SI
        FGGU3hSISnehGHZeua3DYy4=
X-Google-Smtp-Source: ABdhPJzJjXMcwQ6Y+ON8FsPKJimz2DMG/XrPoYVdr7MC00LXHyK/IN+367v9LMuHfiMJs1oPjUryRQ==
X-Received: by 2002:a65:48c7:: with SMTP id o7mr4000417pgs.90.1619185577921;
        Fri, 23 Apr 2021 06:46:17 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id cv12sm4890214pjb.35.2021.04.23.06.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 06:46:17 -0700 (PDT)
Date:   Fri, 23 Apr 2021 16:46:08 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phy: nxp-c45-tja11xx: add interrupt support
Message-ID: <20210423134608.43tojxbeq36jtip2@skbuf>
References: <20210423124329.993850-1-radu-nicolae.pirea@oss.nxp.com>
 <YILGp+LdyxsRhkb2@lunn.ch>
 <20210423134229.5cgxprkdcxf7kkwy@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210423134229.5cgxprkdcxf7kkwy@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 04:42:29PM +0300, Vladimir Oltean wrote:
> On Fri, Apr 23, 2021 at 03:07:51PM +0200, Andrew Lunn wrote:
> > > +static irqreturn_t nxp_c45_handle_interrupt(struct phy_device *phydev)
> > > +{
> > > +	irqreturn_t ret = IRQ_NONE;
> > > +	int irq;
> > > +
> > > +	irq = phy_read_mmd(phydev, MDIO_MMD_VEND1, VEND1_PHY_IRQ_STATUS);
> > > +	if (irq & PHY_IRQ_LINK_EVENT) {
> > > +		phy_trigger_machine(phydev);
> > > +		phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_PHY_IRQ_ACK,
> > > +			      PHY_IRQ_LINK_EVENT);
> > 
> > The ordering here is interesting. Could phy_trigger_machine() cause a
> > second interrupt? Which you then clear without acting upon before
> > exiting the interrupt handler? I think you should ACK the interrupt
> > before calling phy_trigger_machine().
> 
> I thought that the irqchip driver keeps the interrupt line disabled
> until the handler finishes, and that recursive interrupts aren't a thing
> in Linux? Even with threaded interrupts, I thought this is what
> IRQF_ONESHOT deals with.

Ah, you mean the driver could be ACKing an event which was not the event
that triggered this IRQ. In that case, the ordering should be reversed,
sorry for the noise.
