Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B8046A5C7
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 20:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348534AbhLFTlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 14:41:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345083AbhLFTlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 14:41:07 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BABC061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 11:37:38 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id x15so47765019edv.1
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 11:37:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ZKqS/TYWFupzMaTNEqu2d9uhoBRQjCPmHgBSBzbHV4A=;
        b=MwTZtADmi0y2XAqqJI4RVs528xaMeDr70xp3gtAqvTQofKVoylzs3IPA/rNhGq8wUs
         FcO7Jg33J9VNufcSEDG4Ho1RvzywuUowa/SA44Gb2w4a5YDB7JadxvZ4m1GmipP3aCDi
         MS+1iEb1rdI9M8R6WETbOXdo2TD0wfTGX6GQ/YvF7G9LV8HJeZSkMBHo4C1NTVzCkplZ
         Sb67rnFD34FJSNrIzJsXaCurhKSnKgUepLp/t/zuFqlWdVAMMbWlNQMZ79VUT9Ux9s3v
         uhOMlIKiflWR1NoHyYuWbFE97OfS+aUr48E9x9ZJhazgG9JO59zoP9TlFXJl5vdfIALr
         40Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ZKqS/TYWFupzMaTNEqu2d9uhoBRQjCPmHgBSBzbHV4A=;
        b=LC/ouAjaP5pSGOpZQ/XCyc1Lf8PIuctwW4Jy2bQlL1+uUkuNxpSsFzOC+9agP72ByB
         uwuvG2P4ewQ+LCBrWPVrvEMpXQQEou8bQ4X7Roz5uERbCN1HPhXHyJGEcTlJAtZ/5mKD
         IoOHqjCE4lJjAgmLPRvtjp9hyWmGMEueH782lLA0RnbQcQsucxVwOO4wweHWJwknHYqa
         sd2gGiSkaXo1XhGjFU28aDTTVCA5RYIWEcSvzSwJVFFLmvo9tMVrggbNpXHozn2W2igT
         uk77f8VeW8YfrvMo/AY+HHC5vNhnrHdFwMr0OUVfDhjOoFhM+O7ZkCKrt9+pvPR+NbQz
         qkTQ==
X-Gm-Message-State: AOAM531Lb4KnfgBwWUsplkjOhuqOYOtrklwlitFotx8QROh8HhxGWQr5
        wodGX4vuIstNc3Vh31khKLXsjYZZW50=
X-Google-Smtp-Source: ABdhPJwn6L3csz8f4Z6nBwzeOQA72CXHCAIWxkteqy/iJQ/vPxYR04DBIiyvsVIUj6EwqsuBcdZ7tw==
X-Received: by 2002:a05:6402:2789:: with SMTP id b9mr1710384ede.28.1638819456937;
        Mon, 06 Dec 2021 11:37:36 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id el20sm6958641ejc.40.2021.12.06.11.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 11:37:36 -0800 (PST)
Date:   Mon, 6 Dec 2021 21:37:30 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Martyn Welch <martyn.welch@collabora.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel@collabora.com,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: mv88e6240 configuration broken for B850v3
Message-ID: <20211206193730.oubyveywniyvptfk@skbuf>
References: <b98043f66e8c6f1fd75d11af7b28c55018c58d79.camel@collabora.com>
 <YapE3I0K4s1Vzs3w@lunn.ch>
 <b0643124f372db5e579b11237b65336430a71474.camel@collabora.com>
 <fb6370266a71fdd855d6cf4d147780e0f9e1f5e4.camel@collabora.com>
 <20211206183147.km7nxcsadtdenfnp@skbuf>
 <339f76b66c063d5d3bed5c6827c44307da2e5b9f.camel@collabora.com>
 <20211206185008.7ei67jborz7tx5va@skbuf>
 <3d6c6226e47374cf92d604bc6c711e59d76e3175.camel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3d6c6226e47374cf92d604bc6c711e59d76e3175.camel@collabora.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 07:24:56PM +0000, Martyn Welch wrote:
> On Mon, 2021-12-06 at 20:50 +0200, Vladimir Oltean wrote:
> > On Mon, Dec 06, 2021 at 06:37:44PM +0000, Martyn Welch wrote:
> > > On Mon, 2021-12-06 at 20:31 +0200, Vladimir Oltean wrote:
> > > > On Mon, Dec 06, 2021 at 06:26:25PM +0000, Martyn Welch wrote:
> > > > > On Mon, 2021-12-06 at 17:44 +0000, Martyn Welch wrote:
> > > > > > On Fri, 2021-12-03 at 17:25 +0100, Andrew Lunn wrote:
> > > > > > > > Hi Andrew,
> > > > > > > 
> > > > > > > Adding Russell to Cc:
> > > > > > > 
> > > > > > > > I'm currently in the process of updating the GE B850v3
> > > > > > > > [1] to
> > > > > > > > run
> > > > > > > > a
> > > > > > > > newer kernel than the one it's currently running. 
> > > > > > > 
> > > > > > > Which kernel exactly. We like bug reports against net-next,
> > > > > > > or
> > > > > > > at
> > > > > > > least the last -rc.
> > > > > > > 
> > > > > > 
> > > > > > I tested using v5.15-rc3 and that was also affected.
> > > > > > 
> > > > > 
> > > > > I've just tested v5.16-rc4 (sorry - just realised I previously
> > > > > wrote
> > > > > v5.15-rc3, it was v5.16-rc3...) and that was exactly the same.
> > > > 
> > > > Just to clarify: you're saying that you're on v5.16-rc4 and that
> > > > if
> > > > you
> > > > revert commit 3be98b2d5fbc ("net: dsa: Down cpu/dsa ports phylink
> > > > will
> > > > control"), the link works again?
> > > > 
> > > 
> > > Correct
> > > 
> > > > It is a bit strange that the external ports negotiate at
> > > > 10Mbps/Full,
> > > > is that the link speed you intend the ports to work at?
> > > 
> > > Yes, that's 100% intentional due to what's connected to to those
> > > ports
> > > and the environment it works in.
> > > 
> > > Martyn
> > 
> > Just out of curiosity, can you try this change? It looks like a
> > simple
> > case of mismatched conditions inside the mv88e6xxx driver between
> > what
> > is supposed to force the link down and what is supposed to force it
> > up:
> > 
> > diff --git a/net/dsa/port.c b/net/dsa/port.c
> > index 20f183213cbc..d235270babf7 100644
> > --- a/net/dsa/port.c
> > +++ b/net/dsa/port.c
> > @@ -1221,7 +1221,7 @@ int dsa_port_link_register_of(struct dsa_port
> > *dp)
> >                 if (of_phy_is_fixed_link(dp->dn) || phy_np) {
> >                         if (ds->ops->phylink_mac_link_down)
> >                                 ds->ops->phylink_mac_link_down(ds, port,
> > -                                       MLO_AN_FIXED, PHY_INTERFACE_MODE_NA);
> > +                                       MLO_AN_PHY, PHY_INTERFACE_MODE_NA);
> >                         return dsa_port_phylink_register(dp);
> >                 }
> >                 return 0;
> 
> Yes, that appears to also make it work.
> 
> Martyn

Well, I just pointed out what the problem is, I don't know how to solve
it, honest! :)

It's clear that the code is wrong, because it's in an "if" block that
checks for "of_phy_is_fixed_link(dp->dn) || phy_np" but then it omits
the "phy_np" part of it. On the other hand we can't just go ahead and
say "if (phy_np) mode = MLO_AN_PHY; else mode = MLO_AN_FIXED;" because
MLO_AN_INBAND is also a valid option that we may be omitting. So we'd
have to duplicate part of the logic from phylink_parse_mode(), which
does not appear ideal at all. What would be ideal is if this fabricated
phylink call would not be done at all, but I don't know enough about the
systems that need it, I expect Andrew knows more.
