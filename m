Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDAC45CED3
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 22:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242803AbhKXVVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 16:21:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhKXVVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 16:21:47 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F223C061574
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 13:18:36 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id e3so16326098edu.4
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 13:18:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=htXiBzkAuTix+OakIter+NDcdl6a8l1D5G0rtwZaF/w=;
        b=l5FKylTKZGKnpl/6vTx7tkRz3zdxqjqSmxnpwwPHNqJlxCdU/Yvusq1lFzKbaYQA4Z
         tdJJAfkK1h2Cx7T61s+SzyeerINslDuS4L1foDHpH7c8SC+09NfHBG4aeVbOj4ONMh9H
         HNEqMaar/hCw4kD/eeQ1LbOBvFhpmIK0BGri4fLC4ru7PVC217gIIZkDxeB2ZSVVTDPl
         HYS8TIo+kMisPN1NkHKOZtaNH8GELkHX4jxqv8Hb8nIPTrJxuvFL6uvugJoUDMT1xxHm
         q/QC+c1lnSiExtyWuG7HdCg97tcn7/8a9k3+h4QNTsPL9EDijqKHOW0PsI7rqWWDwyia
         wX6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=htXiBzkAuTix+OakIter+NDcdl6a8l1D5G0rtwZaF/w=;
        b=SulBck6cobrm2wNlHiNYBxBVzYHbWaY9Y18QQN8+VFxM3rz+wsuB0BHfpOO4WINX/v
         QJ2o13HRmxC/twQj+ciigCpahlUSiJOxt4Ch1mF6SrD5Kts/GceqfHvaWNqocO9Z2Jxg
         HAN9JS3JEqLXLHKz7mQf4/pRG2qMJ2LFJ95R8hgT1NS+7wjcZA7UJjuoOncSqErYo/Ne
         fg62yUVgFAp6r/We66y+Rctfklmt/OJHjCUNnHhXk19LFgpbaH8BE1/rTNlxTOoXhZPu
         3kTpTib+ADp3WSgWtZ4MjIAvQID1KN8djRdwc33STfzgsffXgJzEayUwQ1FXd8a6BkND
         0hPQ==
X-Gm-Message-State: AOAM530+JSEjLK3w23/XONsfdAHUaZXUhBNFfxNQfrPXzEArfoHiF0DB
        FjD8GdAY4FV70Vm0o2vw258=
X-Google-Smtp-Source: ABdhPJw2QZ80MHu9MGPptspT5+fNJw2ZMV0bKVfzcgxjSlYwv+L4fyiCDlwz/iq5jiLvLxLQ6fnPNQ==
X-Received: by 2002:a05:6402:190d:: with SMTP id e13mr31097436edz.282.1637788715042;
        Wed, 24 Nov 2021 13:18:35 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id gz26sm459266ejc.100.2021.11.24.13.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 13:18:34 -0800 (PST)
Date:   Wed, 24 Nov 2021 23:18:32 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH RFC net-next 03/12] net: dsa: replace
 phylink_get_interfaces() with phylink_get_caps()
Message-ID: <20211124211832.kkfuh2v3gmzza5l7@skbuf>
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
 <E1mpwRi-00D8L8-F1@rmk-PC.armlinux.org.uk>
 <20211124181507.cqlvv3bp46grpunz@skbuf>
 <YZ6D6GESyqbduFgz@shell.armlinux.org.uk>
 <YZ6OORjbKuz8eXD5@shell.armlinux.org.uk>
 <20211124202612.iyrq3dx7nefr5zzi@skbuf>
 <YZ6nAcp+CraITcHD@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZ6nAcp+CraITcHD@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 08:56:33PM +0000, Russell King (Oracle) wrote:
> On Wed, Nov 24, 2021 at 08:26:13PM +0000, Vladimir Oltean wrote:
> > On Wed, Nov 24, 2021 at 07:10:49PM +0000, Russell King (Oracle) wrote:
> > > On Wed, Nov 24, 2021 at 06:26:48PM +0000, Russell King (Oracle) wrote:
> > > > On Wed, Nov 24, 2021 at 06:15:08PM +0000, Vladimir Oltean wrote:
> > > > > On Wed, Nov 24, 2021 at 05:52:38PM +0000, Russell King (Oracle) wrote:
> > > > > > Phylink needs slightly more information than phylink_get_interfaces()
> > > > > > allows us to get from the DSA drivers - we need the MAC capabilities.
> > > > > > Replace the phylink_get_interfaces() method with phylink_get_caps() to
> > > > > > allow DSA drivers to fill in the phylink_config MAC capabilities field
> > > > > > as well.
> > > > > > 
> > > > > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > > > > > ---
> > > > > 
> > > > > The effects of submitting new API without any user :)
> > > > 
> > > > It had users at the time, but they were not submitted, and the addition
> > > > of MAC capabilities was a future development. Had they been submitted at
> > > > the time, then they would have required updating too.
> > > 
> > > That was a bit rushed... to explain more fully.
> > > 
> > > Prior to the merge window, the development work was centered around
> > > only eliminating the PHY_INTERFACE_MODE_xxx checks and the complexity
> > > that the PHY_INTERFACE_MODE_NA technique brought into the many
> > > validation functions. Users of this had already been merged, and
> > > included mvneta and mvpp2. See these commits, which are all in
> > > v5.16-rc1:
> > > 
> > > b63f1117aefc net: mvpp2: clean up mvpp2_phylink_validate()
> > > 76947a635874 net: mvpp2: drop use of phylink_helper_basex_speed()
> > > 6c0c4b7ac06f net: mvpp2: remove interface checks in mvpp2_phylink_validate()
> > > 8498e17ed4c5 net: mvpp2: populate supported_interfaces member
> > > 
> > > 099cbfa286ab net: mvneta: drop use of phylink_helper_basex_speed()
> > > d9ca72807ecb net: mvneta: remove interface checks in mvneta_validate()
> > > fdedb695e6a8 net: mvneta: populate supported_interfaces member
> > > 
> > > The original commit adding phylink_get_interfaces() extended this
> > > into DSA, and the intention was to submit at least mv88e6xxx, but
> > > it was too close to the merge window to do so.
> > > 
> > > Through making that change and eventually eliminating the basex helper
> > > from all drivers that were using it, thereby making the validate()
> > > behaviour much cleaner, it then became clear that it was possible to
> > > push this cleanup further by also introducing a MAC capabilities field
> > > to phylink_config.
> > > 
> > > The addition of the supported_interfaces member and the addition of the
> > > mac_capabilities member are two entirely separate developments, but I
> > > have now chosen to combine the two after the merge window in order to
> > > reduce the number of patches. They were separate patches in my tree up
> > > until relatively recently, and still are for the mt7530 and b53 drivers
> > > currently.
> > > 
> > > So no, this is not "The effects of submitting new API without any user".
> > > 
> > > Thanks.
> > 
> > Ok, the patch is not the effect of submitting new API without any user.
> > It is just the effect of more development done to API without any user,
> > without any causal relationship between the two. My bad.
> 
> I do wonder whether you intentionally missed where I said "It had users
> at the time, but they were not submitted". This is why we don't get on
> well, you're always so confrontational.

David who applied your patch can correct me, but my understanding from
the little time I've spent on netdev is that dead code isn't a candidate
for getting accepted into the tree, even more so in the last few days
before the merge window, from where it got into v5.16-rc1. About the
only exception I know of is when introducing a function which is only to
be called later in the series, and both the caller and the callee are
subject to review. Sure, your hook isn't doing any harm there, save for
a few extra bytes of kernel .text, and I know that your intention was
for Prasanna to use that new callback for the lan937x driver, but the
truth is that there are other ways to achieve what you want, like for
example ask Prasanna to pick your patch and submit it along with his
lan937x driver, or you submit it yourself when the time comes for other
drivers to be converted, whichever comes first.

So yes, I take issue with that as a matter of principle, I very much
expect that a kernel developer of your experience does not set a
precedent and a pretext for people who submit various shady stuff to the
kernel just to make their downstream life easier.
