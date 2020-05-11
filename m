Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 251F21CD952
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 14:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729884AbgEKMFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 08:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729609AbgEKMFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 08:05:17 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75807C061A0C;
        Mon, 11 May 2020 05:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6BY9a4o3dc19VMkNFrNKaCYN9JljLbH41xl/EE7VkJk=; b=IBzBl1ggMvRdMZdzLLRRjPTgQ
        PDrHiaPnOold/ViWrvBPTkONjO2CtKLb0YFOFlrfgvdZ11gVieckKZxgp12G3dXJcA8EmHjQfixND
        5S97RrgZCLVYAzM59/JiW5jReUZQng7aVtsBmzJDcFiwvoMoSO8hpG37Q1fyxj+L+PLCbExJb3c1e
        U9KsQF1di5AM5qVoOBi1kn8EMibLRUmzK9nI8hqZcxaHqjCs6qCuWD1DkGJPl3C35I4Medb30iNL7
        T/u5b/fZjinRVxtn/GxJ0qftK9/QsbaLRONZv/3Eb7MMDumYBY0lwFo8TjDRTZwdy3R8mrrspBp9S
        nzfSfgPAQ==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:56614)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jY7BF-00069E-VZ; Mon, 11 May 2020 13:05:10 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jY7BF-0005en-65; Mon, 11 May 2020 13:05:09 +0100
Date:   Mon, 11 May 2020 13:05:09 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 01/15] net: dsa: provide an option for drivers
 to always receive bridge VLANs
Message-ID: <20200511120509.GS1551@shell.armlinux.org.uk>
References: <20200510164255.19322-1-olteanv@gmail.com>
 <20200510164255.19322-2-olteanv@gmail.com>
 <20200511113850.GQ1551@shell.armlinux.org.uk>
 <CA+h21hpsBvjDJpRKwOj8ncN_NyE1Qh+HQfYLFu3eb_wgyS__bg@mail.gmail.com>
 <20200511115412.GR1551@shell.armlinux.org.uk>
 <CA+h21ho1NQS=9DGhXbrQA7SxKR2N-hXjyYH32SKGTwYLZ1TUMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21ho1NQS=9DGhXbrQA7SxKR2N-hXjyYH32SKGTwYLZ1TUMA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 02:59:12PM +0300, Vladimir Oltean wrote:
> On Mon, 11 May 2020 at 14:54, Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> >
> > On Mon, May 11, 2020 at 02:40:29PM +0300, Vladimir Oltean wrote:
> > > On Mon, 11 May 2020 at 14:38, Russell King - ARM Linux admin
> > > <linux@armlinux.org.uk> wrote:
> > > >
> > > > On Sun, May 10, 2020 at 07:42:41PM +0300, Vladimir Oltean wrote:
> > > > > From: Russell King <rmk+kernel@armlinux.org.uk>
> > > > >
> > > > > DSA assumes that a bridge which has vlan filtering disabled is not
> > > > > vlan aware, and ignores all vlan configuration. However, the kernel
> > > > > software bridge code allows configuration in this state.
> > > > >
> > > > > This causes the kernel's idea of the bridge vlan state and the
> > > > > hardware state to disagree, so "bridge vlan show" indicates a correct
> > > > > configuration but the hardware lacks all configuration. Even worse,
> > > > > enabling vlan filtering on a DSA bridge immediately blocks all traffic
> > > > > which, given the output of "bridge vlan show", is very confusing.
> > > > >
> > > > > Provide an option that drivers can set to indicate they want to receive
> > > > > vlan configuration even when vlan filtering is disabled. At the very
> > > > > least, this is safe for Marvell DSA bridges, which do not look up
> > > > > ingress traffic in the VTU if the port is in 8021Q disabled state. It is
> > > > > also safe for the Ocelot switch family. Whether this change is suitable
> > > > > for all DSA bridges is not known.
> > > > >
> > > > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > >
> > > > This patch was NAK'd because of objections to the "vlan_bridge_vtu"
> > > > name.  Unfortunately, this means that the bug for Marvell switches
> > > > remains unfixed to this day.
> > > >
> > >
> > > How about "accept_vlan_while_unaware"?
> >
> > It's up to DSA maintainers.
> >
> > However, I find that rather confusing. What's "unaware"? The point of
> > this boolean is to program the vlan tables while vlan filtering is
> > disabled. "accept_vlan_while_vlan_filtering_disabled" is way too long.
> >
> 
> Considering the VLAN filtering modes as "disabled", "check",
> "fallback" and "secure", I think a slight improvement over your
> wording might be "install_vlans_while_disabled". I hope that is not
> confusing and also not too long.

Well, it's not only about "installing" vlans, but also about removing
them as well.  "configure_vlans_while_disabled" would probably work
better.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
