Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD4821EBC9
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 10:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgGNIuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 04:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbgGNIuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 04:50:03 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6781C061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 01:50:02 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id rk21so20702564ejb.2
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 01:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hs1cEnkiT5RwbJT89pv3rbGp2qzB2Ni2oNnspbz8zEE=;
        b=QeUPyVNplmUXPSP9osqpQYbLFJHNHStj2haODEwFSNRjvCF+lslWyPOzuqvHXIj5oM
         quMhax9YOl+pUaYQGdLhw4KG9CFFyFISgf6JvvhYhRJKMFlgrV079liFsTI2WyMLyvD7
         U4UjPO+1EGQ4AHz6e6/+5RgLhjg5oClAkScTlKOkOTGSRLfPNVfF6S+NtDVdrJq3U9pq
         uNiHz/6DXEbHTlEFC3blOHiGA036d4Ql79110F+tfQ16+KMMkgn3Ba7hV1qqUv8TrsLZ
         fU6quwj+FMZ34zqZZDaAQg/Ix9iVcpWRKdazv57EyK/WtD+7L07bMRKIcfOLy4dVKCig
         TM7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hs1cEnkiT5RwbJT89pv3rbGp2qzB2Ni2oNnspbz8zEE=;
        b=Lladrzs2OEODKOZxXFbcp7JCT0crZgnGuAO6NL7oanCzFSwEn4F2HSGwo97tD4mL2S
         CE/BbV/bZ/JjRUrVnbYd6vo5WAXNlELs3o+dx+S78781HL6gJPJl7XZBrRTPwGGoXI8K
         QvYCLP0IBOCDxUcxLCVzl8+unmYHvLCABfTyzCAvYfnkbvHHOJgRhoUDdfuGZFankYlR
         cYJ6mlu4tsmdcQzY3KqCJhFr12wNM0j5DQanrhjBWIb4SX5KU5CZ158+3CImEy46FWg7
         u3MeRQ/UrZfd/d/QU05bBLte4anzjvIABPK0h3FcaDIS1iWxN8Z1R1noJOKY3ipVzVrt
         ctZQ==
X-Gm-Message-State: AOAM533iW37Joohq3jG32uQcR5VEziCOiFSXbqSLaVeD5ESjvW3Tnf+o
        pckEOwYtbeLjYnYNuLImcLQ=
X-Google-Smtp-Source: ABdhPJwdfw6177JgA9hJEzb5y81F8itLHRzzj5JIpngKNmIao8aaD3B396DYurtpl22iuA5GQs5x5A==
X-Received: by 2002:a17:906:dbed:: with SMTP id yd13mr3388853ejb.419.1594716601462;
        Tue, 14 Jul 2020 01:50:01 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id y7sm11948067ejd.73.2020.07.14.01.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 01:50:00 -0700 (PDT)
Date:   Tue, 14 Jul 2020 11:49:58 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "michael@walle.cc" <michael@walle.cc>, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH RFC net-next 00/13] Phylink PCS updates
Message-ID: <20200714084958.to4n52cnk32prn4v@skbuf>
References: <20200630142754.GC1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630142754.GC1551@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 03:27:54PM +0100, Russell King - ARM Linux admin wrote:
> Hi,
> 
> This series updates the rudimentary phylink PCS support with the
> results of the last four months of development of that.  Phylink
> PCS support was initially added back at the end of March, when it
> became clear that the current approach of treating everything at
> the MAC end as being part of the MAC was inadequate.
> 
> However, this rudimentary implementation was fine initially for
> mvneta and similar, but in practice had a fair number of issues,
> particularly when ethtool interfaces were used to change various
> link properties.
> 
> It became apparent that relying on the phylink_config structure for
> the PCS was also bad when it became clear that the same PCS was used
> in DSA drivers as well as in NXPs other offerings, and there was a
> desire to re-use that code.
> 
> It also became apparent that splitting the "configuration" step on
> an interface mode configuration between the MAC and PCS using just
> mac_config() and pcs_config() methods was not sufficient for some
> setups, as the MAC needed to be "taken down" prior to making changes,
> and once all settings were complete, the MAC could only then be
> resumed.
> 
> This series addresses these points, progressing PCS support, and
> has been developed with mvneta and DPAA2 setups, with work on both
> those drivers to prove this approach.  It has been rigorously tested
> with mvneta, as that provides the most flexibility for testing the
> various code paths.
> 
> To solve the phylink_config reuse problem, we introduce a struct
> phylink_pcs, which contains the minimal information necessary, and it
> is intended that this is embedded in the PCS private data structure.
> 
> To solve the interface mode configuration problem, we introduce two
> new MAC methods, mac_prepare() and mac_finish() which wrap the entire
> interface mode configuration only.  This has the additional benefit of
> relieving MAC drivers from working out whether an interface change has
> occurred, and whether they need to do some major work.
> 
> I have not yet updated all the interface documentation for these
> changes yet, that work remains, but this patch set is provided in the
> hope that those working on PCS support in NXP will find this useful.
> 
> Since there is a lot of change here, this is the reason why I strongly
> advise that everyone has converted to the mac_link_up() way of
> configuring the link parameters when the link comes up, rather than
> the old way of using mac_config() - especially as splitting the PCS
> changes how and when phylink calls mac_config(). Although no change
> for existing users is intended, that is something I no longer am able
> to test.
> 
>  drivers/net/phy/phylink.c | 365 +++++++++++++++++++++++++++++++---------------
>  include/linux/phylink.h   | 103 ++++++++++---
>  2 files changed, 337 insertions(+), 131 deletions(-)
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

Are you going to post a non-RFC version?

I think this series makes a lot of sense overall and is a good
consolidation for the type of interfaces that are already established in
Linux.

This changes the landscape of how Linux is dealing with a MAC-side
clause 37 PCS, and should constitute a workable base even for clause 49
PCSs when those use a clause 37 auto-negotiation system (like USXGMII
and its various multi-port variants). Where I have some doubts is a
clause 49 PCS which uses a clause 73 auto-negotiation system, I would
like to understand your vision of how deep phylink is going to go into
the PMD layer, especially where it is not obvious that said layer is
integrated with the MAC.

Thanks,
-Vladimir
