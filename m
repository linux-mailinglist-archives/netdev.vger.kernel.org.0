Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D91223631
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 09:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbgGQHtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 03:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbgGQHtq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 03:49:46 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EBAAC061755;
        Fri, 17 Jul 2020 00:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GxSH3WgRcAs4BQXGeagIES8YCdrXCuFUlM7hGjVh35Y=; b=pCij9v6b1c9DzBtrS1BYXlN1ZU
        FbJTzahWrmUxhdKMMORQgOqP5gPLHXFbskUzmny1M2ZkQhnVdQ+w6WyCcIB7np1FHqGFAOvCupBTj
        RfD0Q4hCeQybP0qlBa5zVmma+dBvjeesHZoiuzQtITsBNEgSBFhWnTTyif4c26CFzlMoKCciEF46G
        3zc5rUO9YUl80ii83Hhcvjul89S4q/zalLNGiTDAG+Bedswam5XVk1AW5D/hsIJFBj0m5ZhMHVhCm
        dAvUMV82Li3yjSP1F2MG0qieSY1coQ5SwVzFBNYthOYna6xj8VElsZS9VdFIHwKQOMTUnU2AMsXbM
        8ixXfToA==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1jwL7f-00033F-1W; Fri, 17 Jul 2020 08:49:35 +0100
Date:   Fri, 17 Jul 2020 08:49:35 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Matthew Hagan <mnhagan88@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH 2/2] dt-bindings: net: dsa: qca8k: Add PORT0_PAD_CTRL
 properties
Message-ID: <20200717074934.GH23489@earth.li>
References: <2e1776f997441792a44cd35a16f1e69f848816ce.1594668793.git.mnhagan88@gmail.com>
 <ea0a35ed686e6dace77e25cb70a8f39fdd1ea8ad.1594668793.git.mnhagan88@gmail.com>
 <20200716150925.0f3e01b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200716223822.yptldqqn36fbp2i7@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716223822.yptldqqn36fbp2i7@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 01:38:22AM +0300, Vladimir Oltean wrote:
> On Thu, Jul 16, 2020 at 03:09:25PM -0700, Jakub Kicinski wrote:
> > On Mon, 13 Jul 2020 21:50:26 +0100 Matthew Hagan wrote:
> > > +- qca,sgmii-rxclk-falling-edge:	If present, sets receive clock phase to
> > > +				falling edge.
> > > +- qca,sgmii-txclk-falling-edge:	If present, sets transmit clock phase to
> > > +				falling edge.
> > 
> > These are not something that other vendors may implement and therefore
> > something we may want to make generic? Andrew?
> > 
> 
> It was asked before whether this device uses source-synchronous clock
> for SGMII or if it recovers the clock from the data stream. Just "pass"
> was given for a response.
> 
> https://patchwork.ozlabs.org/project/netdev/patch/8ddd76e484e1bedd12c87ea0810826b60e004a65.1591380105.git.noodles@earth.li/
> 
> One can, in principle, tell easily by examining schematics. If the SGMII
> is only connected via RX_P, RX_N, TX_P, TX_N (and optionally there might
> be external reference clocks for the SERDES lanes, but these are not
> part of the data connection itself), then the clock is recovered from
> the serial data stream, and we have no idea what "SGMII delays" are.
> 
> If the schematic shows 2 extra clock signals, one in each transmit
> direction, then this is, in Russell King's words, "a new world of RGMII
> delay pain but for SGMII". In principle I would fully expect clock skews
> to be necessary for any high-speed protocol with source-synchronous
> clocking. The problem, really, is that we aren't ready to deal with this
> properly. We aren't distinguishing "SGMII with clock" from "SGMII
> without clock" in any way. We have no idea who else is using such a
> thing. Depending on the magnitude of this new world, it may be wise to
> let these bindings go in as-is, or do something more kernel-wide...

I don't have the schematic for the device I've been working with, but
the switch data sheet just shows 2 differential pairs (input/output) for
the SerDes Interface (whereas the RGMII interfaces *are* listed with
their clocks).

J.

-- 
I just Fedexed my soul to hell. I'm *real* clever.
