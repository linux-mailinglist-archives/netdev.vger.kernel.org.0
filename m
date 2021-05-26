Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E265392204
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 23:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbhEZV1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 17:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbhEZV1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 17:27:42 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE34FC061574
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 14:26:09 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id g7so3244586edm.4
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 14:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GNcVq92v0QB/R9MHTPPVIdMqABiX2ydfnpY7zZex3mY=;
        b=I+fxpyAxCsfT6FAEaUTdEcfV6bZAkBcYvw8uauP1OnOS99ec4WP/4GD/Iiu5GfBDTN
         snHTW6ofHG00EVmv1yiX3inXHL1hc70SkFNNJDSAUcqDgZOgNO5TuXvBhpSOp+6Y4AyO
         XE+fm5NqO0hEha1W2XtZ3XPpKEczcgVX2tk1tH3fq/QEr/GmD9LUm/WtHqSfw38CxX+z
         23jm495Rdy6thxqZzFHZQCzTMnvSGbR8gvFfLAd2n7Kd74+PVwPB9yiLnPHlGESL69EX
         8xktUVxswU4RwVVm7bDVEXtiy6kYlm+6im8AGA53KPPVkMTMiKrcuKrl1ZAfv4VTxDU3
         b59Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GNcVq92v0QB/R9MHTPPVIdMqABiX2ydfnpY7zZex3mY=;
        b=mGI1a7T+WSyVRvjZBkokmEdGlOcfjHF5k3nXTHdplCa0Hma0JB1Fd51kptt38TDaOI
         av4+diQYzIwN3Yqj3J+3lXqdJzB7zujBszSLO6PRreOho/72Vtq4ssAwRl8AstRW0Vul
         uYj63P6q12cVDMvaaPMotVpqiI0fvDnuLpQOuQcSAnXh8vz0UlBdlpcj/hl11RGoANOL
         9oUs5QX/ZUzUQdUSdI2v3sb2YtcRyZImVvIvSe/mtIXHgOcqVFlRkbCvnLu5Shy6HWdq
         d8fYN7Y58xOn01pzFEMJzwJckSptlmV+3IANyRwYygUKXJMIRnv8sSr0uPtX+rpTVOsl
         /e9g==
X-Gm-Message-State: AOAM530j8TR3npVLgaKEw0Zgejx0KbbLg7zOxju6U6BMJEjfaYwy79Af
        b2nNADOE5259x2MvHUfoU5eec8tBSXg=
X-Google-Smtp-Source: ABdhPJxlsMVcmv+jfY3g/5Icf4dEiLwN4axiIlqIfa3H6fcIggJd5GuGserEht7b8zlMpJgMBjW10w==
X-Received: by 2002:a05:6402:3098:: with SMTP id de24mr209228edb.339.1622064368322;
        Wed, 26 May 2021 14:26:08 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id dk21sm113012ejb.54.2021.05.26.14.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 14:26:08 -0700 (PDT)
Date:   Thu, 27 May 2021 00:26:06 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [RFC PATCH v2 linux-next 13/14] net: dsa: sja1105: expose the
 SGMII PCS as an mdio_device
Message-ID: <20210526212606.k663iljf7a7d2wpi@skbuf>
References: <20210526135535.2515123-1-vladimir.oltean@nxp.com>
 <20210526135535.2515123-14-vladimir.oltean@nxp.com>
 <20210526152911.GH30436@shell.armlinux.org.uk>
 <20210526154102.dlp2clwqncadna2v@skbuf>
 <20210526154641.GJ30436@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526154641.GJ30436@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 04:46:41PM +0100, Russell King (Oracle) wrote:
> On Wed, May 26, 2021 at 06:41:02PM +0300, Vladimir Oltean wrote:
> > On Wed, May 26, 2021 at 04:29:11PM +0100, Russell King (Oracle) wrote:
> > > On Wed, May 26, 2021 at 04:55:34PM +0300, Vladimir Oltean wrote:
> > > > Since we touch all PCS accessors again, now it is a good time to check
> > > > for error codes from the hardware access as well. We can't propagate the
> > > > errors very far due to phylink returning void for mac_config and
> > > > mac_link_up, but at least we print them to the console.
> > >
> > > phylink doesn't have much option on what it could do if we error out at
> > > those points - I suppose we could print a non-specific error and then
> > > lock-out the interface in a similar way that phylib does, but to me that
> > > seems really unfriendly if you're remotely accessing a box and the error
> > > is intermittent.
> >
> > I would like to have intermittent errors at this level logged, because
> > to me they would be quite unexpected and I would like to have some rope
> > to pull while debugging - an error code, something.
> >
> > If there's an error of any sort, the interface won't be fully
> > initialized anyway, so not functional.
> >
> > The reason why I added error checking in this patch is because I was
> > working on the MDIO bus accessors and I wanted to make sure that the
> > errors returned there are propagated somewhere.
>
> Yes, makes sense there, but doesn't make sense if one is using the MMIO
> accessors and have no errors to check...
>
> My argument is - if you print an error at the lower levels, you can be
> more specific about what failed. If you do it in phylink, you can only
> say "oh, the blah_config() call failed" - which isn't particularly
> useful.
>
> Yes, we do this for some of the newly introduced methods, e.g. the
> pcs_config() method - and there all we can say is:
>
>                 if (err < 0)
>                         phylink_err(pl, "pcs_config failed: %pe\n",
>                                     ERR_PTR(err));

So would you like me to make any change to the code, or is it just that
I mentioned in the commit message that the phylink methods return void?
