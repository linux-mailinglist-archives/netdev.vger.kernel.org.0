Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809D53693E7
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 15:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238485AbhDWNnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 09:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbhDWNnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 09:43:16 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14FDBC061574;
        Fri, 23 Apr 2021 06:42:40 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id 20so21294835pll.7;
        Fri, 23 Apr 2021 06:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HCk6Bh6s7TtnuF0+Xf6ighUZWns2CZDYD+LvN/0ktoo=;
        b=fI+YM9MMZDe1hpY0hlfcJnDqGqZ10UfJBGwXCGfvLKy9RNPSB1+br57ehfcaZg4Oub
         m5oaGW21lTc//KHXf9Nb+2P1KdimDNqubOz7qtF8xLtv0KJ6ECQ2cMmNzJU8uVztdXfJ
         3y9FDFKmAqRfeqZlsjm5Zp9qLb7va3v72lnhh24wkjQXqrfa15oow9hiDilZrCwayE6R
         aXUksYKbFlquyi6CAbh8ivqLt9M63c5JtTKBfpr3iJKRVCeIqMaf/JcfJKyaqqnfxOQO
         7Tmi3Aw7Zvkq7zx4WeZMKLmw/d9px8kpwv6WCgK3B4NmNaL4musvrObZyJ6yA1rL+CTZ
         q4jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HCk6Bh6s7TtnuF0+Xf6ighUZWns2CZDYD+LvN/0ktoo=;
        b=OdP0f+YEHFWhCljQCxptR3s4CaYU45lgasDONmjB1rIFW0jrX0DYT+jVHK98qch4YM
         MFSB4G8cMGB+kkv782ahelGJFF2X26BeUSvK/P5oK2Uib6kdppYbmC3Kf6L9XnR5Udo4
         IKJ1BY0tLQqJR0baGdXLDnFw4TtyNUAF+mZroZIK5kXpqdpUTK2EmcqCIP/gNEstWef/
         IMbfgs8TNzuq1Gybz9DU/8vs3UXANNbCVXln2Qw46insY5TLHLsyRGxmFwGNRBp9UAAG
         bjR8rV0nQ+WhyzTr2DTN4usD+EamCCAdifnJ7yLcR+1spM6gQrnUCdVikDX0C6tyXryI
         xkXQ==
X-Gm-Message-State: AOAM531ZeadWmAWPgUjdXHeUfXPdSRJ8TxVcA5IMP1wu1/g7gbrmAu9T
        QZ6Q9J2hWjRrOv/3W0oTbQ4=
X-Google-Smtp-Source: ABdhPJy9kZ7VY08GT2njfeR+zkQI3sGkjfhiDD5VEUwHsV/cjtNrXjC7lSSVs8bATWhVcV5gbNxSvQ==
X-Received: by 2002:a17:902:ec84:b029:ea:b28d:e53e with SMTP id x4-20020a170902ec84b02900eab28de53emr3966184plg.77.1619185359545;
        Fri, 23 Apr 2021 06:42:39 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id r5sm7593558pjd.38.2021.04.23.06.42.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 06:42:39 -0700 (PDT)
Date:   Fri, 23 Apr 2021 16:42:29 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phy: nxp-c45-tja11xx: add interrupt support
Message-ID: <20210423134229.5cgxprkdcxf7kkwy@skbuf>
References: <20210423124329.993850-1-radu-nicolae.pirea@oss.nxp.com>
 <YILGp+LdyxsRhkb2@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YILGp+LdyxsRhkb2@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 03:07:51PM +0200, Andrew Lunn wrote:
> > +static irqreturn_t nxp_c45_handle_interrupt(struct phy_device *phydev)
> > +{
> > +	irqreturn_t ret = IRQ_NONE;
> > +	int irq;
> > +
> > +	irq = phy_read_mmd(phydev, MDIO_MMD_VEND1, VEND1_PHY_IRQ_STATUS);
> > +	if (irq & PHY_IRQ_LINK_EVENT) {
> > +		phy_trigger_machine(phydev);
> > +		phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_PHY_IRQ_ACK,
> > +			      PHY_IRQ_LINK_EVENT);
> 
> The ordering here is interesting. Could phy_trigger_machine() cause a
> second interrupt? Which you then clear without acting upon before
> exiting the interrupt handler? I think you should ACK the interrupt
> before calling phy_trigger_machine().

I thought that the irqchip driver keeps the interrupt line disabled
until the handler finishes, and that recursive interrupts aren't a thing
in Linux? Even with threaded interrupts, I thought this is what
IRQF_ONESHOT deals with.
