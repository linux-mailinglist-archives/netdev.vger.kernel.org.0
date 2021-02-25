Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464F4324FB8
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 13:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbhBYMOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 07:14:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232137AbhBYMN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 07:13:58 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0465AC06174A
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 04:13:18 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id d13so1531831edp.4
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 04:13:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yoglnqGYUUKmVDxtZu46wLtp7OK9fr7KPi08GHxGIUs=;
        b=SNP6VmGEzJBMtnUVE2kvCiaLsoMX21AtAYgPxd1HNuANcJgH4FGisPf8nvy/Gzjfg/
         xb8j1I8a1Qqkkuc3QR/zxlEzbi9ga0omYj96VPF6CTpOvI/mUTaTOvvYKn+vPCbl2iYS
         lONe/T9mqW7w4xLd+JKoGp2vy+51n8dLAgiCBuNpTX3h9Dp12VO4g62R+emld25pTINh
         VxioDoGu6kl9NOGIgftnsHHWAcEckA1vLIgs6d5JSzyxjwPk0qGFaJ7RnVU2n8MA/Aq1
         Hn85RRfZyG6OGwQZ5P+FVCtVkDCO/1PxCTkhh7iOAuYPEp69G2d1PptkOJXtEbm4dLdS
         bllg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yoglnqGYUUKmVDxtZu46wLtp7OK9fr7KPi08GHxGIUs=;
        b=i0JVb5IhqKL5fp6gmXLppXD2qhw8qVYtmKirG9zcOpcuNbHB8S+p7vYOJqEOr4mMLb
         rmwasIO9WONvCDA6A1k1k7TSUqjUOghaiba81LF3+oqEd6vtfQ2apLrbrEm3liNikSvr
         WL4iFFTDNnXmZsonuRhtrgKBTGQd1p6Q9ZdW1JGjVw8vOgxjQc69M7vmPnUbaNJkOV5j
         yxsR+plrEWNkwiQrFx8QuZ4CVeZShko/5vEwEuIqkGC4kRPvHQoUIUGfngk5YSRIlXS+
         fw2phqY4/jiCIOin3d0Zp70BZN/vqBkMSzspMQtmYfRsEbvtSX30c5XdFYPHkJUwR3xZ
         /ESQ==
X-Gm-Message-State: AOAM530xXgN96BuGKdTsC/LPNItKiOGsjOw2z8cLi1vzvrthOW1B8yOC
        n6Kib06OPll9mZnYLcw68QA=
X-Google-Smtp-Source: ABdhPJyD/Ib4BXgIm+awjRZd1UGS2IG09TsfKysGt2e2ymqaGXCD+pr5UmFS1uwQ3Lbgi3ut6Tjk+g==
X-Received: by 2002:a05:6402:c7:: with SMTP id i7mr2604146edu.328.1614255196819;
        Thu, 25 Feb 2021 04:13:16 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id h10sm3605489edk.45.2021.02.25.04.13.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 04:13:15 -0800 (PST)
Date:   Thu, 25 Feb 2021 14:13:14 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net 6/6] net: enetc: force the RGMII speed and duplex
 instead of operating in inband mode
Message-ID: <20210225121314.c3lphdy7fhoygbmi@skbuf>
References: <20210225112357.3785911-1-olteanv@gmail.com>
 <20210225112357.3785911-7-olteanv@gmail.com>
 <20210225112942.GT1463@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225112942.GT1463@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 11:29:42AM +0000, Russell King - ARM Linux admin wrote:
> On Thu, Feb 25, 2021 at 01:23:57PM +0200, Vladimir Oltean wrote:
> >  static void enetc_pl_mac_link_up(struct phylink_config *config,
> >  				 struct phy_device *phy, unsigned int mode,
> >  				 phy_interface_t interface, int speed,
> > @@ -945,6 +981,10 @@ static void enetc_pl_mac_link_up(struct phylink_config *config,
> >  		enetc_sched_speed_set(priv, speed);
> >  
> >  	enetc_mac_enable(&pf->si->hw, true);
> > +
> > +	if (!phylink_autoneg_inband(mode) &&
> > +	    phy_interface_mode_is_rgmii(interface))
> > +		enetc_force_rgmii_mac(&pf->si->hw, speed, duplex);
> 
> Does it matter that you're forcing the RGMII setup after having enabled
> the MAC?

Thanks, this is a good point. I had tested only at gigabit on the
LS1028A-QDS, but at 10/100 things seem to be broken if I update the
speed with the MAC being enabled. I'll send a v2 with this change and
also with a build failure fix for patch 4/6.
