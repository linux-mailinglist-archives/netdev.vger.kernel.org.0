Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF0942825B
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 17:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbhJJPzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 11:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbhJJPza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 11:55:30 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7347EC061570;
        Sun, 10 Oct 2021 08:53:31 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id t16so35404409eds.9;
        Sun, 10 Oct 2021 08:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hJMfPYSgtaDByZ//vLPk6A+gvfN7xfuU62fiTIBCntM=;
        b=A5TeKpIaF6qPWkt1c9FqlOY21mSJazz+N0HVwVyG9XG5tWE2vW15ky9Gh2axmIUPGz
         TlPDbzbYimmck7BdI5Ui8ZhDsMekLIaSaPYsfveFsARiWPxgh3bjC+PRlV7j4tTDOaTz
         nuOxR0LPIfgtUqua5bX6mKqheejuhMrZynZ/cKNQrkTs5PRCp3bYTuzIWRws7fIJi6xi
         vrVJXQynI0hTeHjXNgmzfzyZLRO21+/SthsCiB2htLwl6ecaP1jMkOoVKO+wLw1o562x
         kornRxfj0YD6QN29Almqf8uHLTjMiDzskjco1CaXkNFZu4T1y33Ze+l6QA0+NdEzwu2N
         8hvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hJMfPYSgtaDByZ//vLPk6A+gvfN7xfuU62fiTIBCntM=;
        b=Hu7Cs1s5PN7ndwhR2rvXnpGHg4LfaEHtIIvWquqk7STTeNJub6MIyowKsdk7p4wSv5
         Nc4LCeJcSkIQbdxpm6FxUdrIM7LKARwZt8V+GAgJJd2DNONq6oWW1c0Pb3NMapAH30zA
         SX+EXgHAELa+euQZ+nKCSE19bf6hppGcWUktIpZ+MZrHKFbFkobLpP9JWzfGR7zYjczj
         jk2B89E6etKFtF4m9po0948NV/+dVf0AW73VCYEiD0mu6CcArhnoMKDtQi6AJxvuv7Pv
         FWj7kGg8pangeAu4F6SmCV8DtGSr2Bp7stex1Bfv7CbfNZagLXN6NrlKuGOY1A4hKSHC
         ezSg==
X-Gm-Message-State: AOAM532N+P8ANN9/0CJHhkK/XaHXSThViH/Svf2L0GPpAQSVhpT0so90
        3r5FlR8Q5swE5AnG0eL4Dwk=
X-Google-Smtp-Source: ABdhPJy9ygC7KHEDjv1jGue3/D0SbPWbXAmBcTiXwaHr4TzTuB7enRoZ0n49vxIBrvPAm09rsbpqFA==
X-Received: by 2002:a17:906:1e43:: with SMTP id i3mr19115138ejj.313.1633881209807;
        Sun, 10 Oct 2021 08:53:29 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id r1sm2735288edp.56.2021.10.10.08.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 08:53:29 -0700 (PDT)
Date:   Sun, 10 Oct 2021 18:53:28 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v4 06/13] net: dsa: qca8k: move rgmii delay
 detection to phylink mac_config
Message-ID: <20211010155328.zwhs2vpdpddazcmq@skbuf>
References: <20211010111556.30447-1-ansuelsmth@gmail.com>
 <20211010111556.30447-7-ansuelsmth@gmail.com>
 <20211010124732.fageoraoweqqfoew@skbuf>
 <YWMEOLueatMCTS2Z@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWMEOLueatMCTS2Z@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 10, 2021 at 05:18:16PM +0200, Andrew Lunn wrote:
> > > -{
> > > -	struct device_node *port_dn;
> > > -	phy_interface_t mode;
> > > -	struct dsa_port *dp;
> > > -	u32 val;
> > > -
> > > -	/* CPU port is already checked */
> > > -	dp = dsa_to_port(priv->ds, 0);
> > > -
> > > -	port_dn = dp->dn;
> > > -
> > > -	/* Check if port 0 is set to the correct type */
> > > -	of_get_phy_mode(port_dn, &mode);
> > > -	if (mode != PHY_INTERFACE_MODE_RGMII_ID &&
> > > -	    mode != PHY_INTERFACE_MODE_RGMII_RXID &&
> > > -	    mode != PHY_INTERFACE_MODE_RGMII_TXID) {
> > > -		return 0;
> > > -	}
> > > -
> > > -	switch (mode) {
> > > -	case PHY_INTERFACE_MODE_RGMII_ID:
> > > -	case PHY_INTERFACE_MODE_RGMII_RXID:
> > 
> > Also, since you touch this area.
> > There have been tons of discussions on this topic, but I believe that
> > your interpretation of the RGMII delays is wrong.
> > Basically a MAC should not apply delays based on the phy-mode string (so
> > it should treat "rgmii" same as "rgmii-id"), but based on the value of
> > "rx-internal-delay-ps" and "tx-internal-delay-ps".
> > The phy-mode is for a PHY to use.
> 
> There is one exception to this, when the MAC is taking the place of a
> PHY, i.e. CPU port. You need delays added somewhere, and the mv88e6xxx
> driver will look at the phy-mode in this case.

Yes, and I don't think it's an actual exception, it's still back-to-back MACs.
It is true on the other hand that some drivers don't seem to behave this way.
Russell has been suggesting that the phy-mode should be treated the same
way regardless of whether a PHY is attached or not. It would be nice to
reach a common agreement so that we know what to suggest people to do.

> And i think in general, a DSA driver needs this for the CPU port.

Not saying it doesn't need it, just saying that the need for the
{rx,tx}-internal-delay-ps MAC property was not recognized at the time
and that's why the vast majority of drivers don't act upon it.
The qca8k driver is somewhat special in that it does parse these new
properties, but at the same time also parse the phy-mode, that is kind
of strange.
