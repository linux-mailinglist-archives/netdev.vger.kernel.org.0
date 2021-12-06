Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E4246A59F
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 20:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348410AbhLFT2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 14:28:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348235AbhLFT2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 14:28:30 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3CFC061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 11:25:01 -0800 (PST)
Received: from [IPv6:2a00:23c6:c31a:b300:d843:805f:270e:3984] (unknown [IPv6:2a00:23c6:c31a:b300:d843:805f:270e:3984])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: martyn)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 85E6B1F43A93;
        Mon,  6 Dec 2021 19:24:59 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=collabora.com; s=mail;
        t=1638818699; bh=SO0kA0JIBltSQ5QjJmfW2pJDiVdDSfdZ/LUMJWYgRZw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Q74vm2EfttnUNY5xNCQYhpm2wNWBvVP3vt1P+NAg8nRN9H51PrLrBT0GbDfQZrqR9
         mwP+dfiR95WMaFndiYrAUROKZjmc+s0ltkBMlyZDZxbZryZwQcFpOP9TJpZuCHJ0wU
         Sexo07xIJ71vvy1Xh5kgmyfwV2f7XLHdih9J751YTR3HYY5Es7SCgsFfBJrYzhhdXc
         Kzed7HkNE2Bds0ygiAdt+6L7mptg1SfpYHzLr0wuK8bgQd5WJ9YvWvCzNQgZvHipHb
         JXfTxm/saIEIO8/coyoWM24++SFfnI0KAbYt6Rt6oDODHG+Vfqtz9HPMtfgY2+84KT
         G+5gMTelDDd3g==
Message-ID: <3d6c6226e47374cf92d604bc6c711e59d76e3175.camel@collabora.com>
Subject: Re: mv88e6240 configuration broken for B850v3
From:   Martyn Welch <martyn.welch@collabora.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel@collabora.com,
        Russell King <rmk+kernel@armlinux.org.uk>
Date:   Mon, 06 Dec 2021 19:24:56 +0000
In-Reply-To: <20211206185008.7ei67jborz7tx5va@skbuf>
References: <b98043f66e8c6f1fd75d11af7b28c55018c58d79.camel@collabora.com>
         <YapE3I0K4s1Vzs3w@lunn.ch>
         <b0643124f372db5e579b11237b65336430a71474.camel@collabora.com>
         <fb6370266a71fdd855d6cf4d147780e0f9e1f5e4.camel@collabora.com>
         <20211206183147.km7nxcsadtdenfnp@skbuf>
         <339f76b66c063d5d3bed5c6827c44307da2e5b9f.camel@collabora.com>
         <20211206185008.7ei67jborz7tx5va@skbuf>
Organization: Collabora Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-12-06 at 20:50 +0200, Vladimir Oltean wrote:
> On Mon, Dec 06, 2021 at 06:37:44PM +0000, Martyn Welch wrote:
> > On Mon, 2021-12-06 at 20:31 +0200, Vladimir Oltean wrote:
> > > On Mon, Dec 06, 2021 at 06:26:25PM +0000, Martyn Welch wrote:
> > > > On Mon, 2021-12-06 at 17:44 +0000, Martyn Welch wrote:
> > > > > On Fri, 2021-12-03 at 17:25 +0100, Andrew Lunn wrote:
> > > > > > > Hi Andrew,
> > > > > > 
> > > > > > Adding Russell to Cc:
> > > > > > 
> > > > > > > I'm currently in the process of updating the GE B850v3
> > > > > > > [1] to
> > > > > > > run
> > > > > > > a
> > > > > > > newer kernel than the one it's currently running. 
> > > > > > 
> > > > > > Which kernel exactly. We like bug reports against net-next,
> > > > > > or
> > > > > > at
> > > > > > least the last -rc.
> > > > > > 
> > > > > 
> > > > > I tested using v5.15-rc3 and that was also affected.
> > > > > 
> > > > 
> > > > I've just tested v5.16-rc4 (sorry - just realised I previously
> > > > wrote
> > > > v5.15-rc3, it was v5.16-rc3...) and that was exactly the same.
> > > 
> > > Just to clarify: you're saying that you're on v5.16-rc4 and that
> > > if
> > > you
> > > revert commit 3be98b2d5fbc ("net: dsa: Down cpu/dsa ports phylink
> > > will
> > > control"), the link works again?
> > > 
> > 
> > Correct
> > 
> > > It is a bit strange that the external ports negotiate at
> > > 10Mbps/Full,
> > > is that the link speed you intend the ports to work at?
> > 
> > Yes, that's 100% intentional due to what's connected to to those
> > ports
> > and the environment it works in.
> > 
> > Martyn
> 
> Just out of curiosity, can you try this change? It looks like a
> simple
> case of mismatched conditions inside the mv88e6xxx driver between
> what
> is supposed to force the link down and what is supposed to force it
> up:
> 
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index 20f183213cbc..d235270babf7 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -1221,7 +1221,7 @@ int dsa_port_link_register_of(struct dsa_port
> *dp)
>                 if (of_phy_is_fixed_link(dp->dn) || phy_np) {
>                         if (ds->ops->phylink_mac_link_down)
>                                 ds->ops->phylink_mac_link_down(ds,
> port,
> -                                       MLO_AN_FIXED,
> PHY_INTERFACE_MODE_NA);
> +                                       MLO_AN_PHY,
> PHY_INTERFACE_MODE_NA);
>                         return dsa_port_phylink_register(dp);
>                 }
>                 return 0;

Yes, that appears to also make it work.

Martyn
