Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD1C2F893B
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 00:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbhAOXPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 18:15:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbhAOXPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 18:15:41 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E0DC061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 15:15:01 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id l9so9879463ejx.3
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 15:15:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=krtXa8Lvb25uL7wUhvkQBQ5wIDZy92zz7z0MvoMSqok=;
        b=KnUZaD9prwxBF3GCOz13LsWk5hMRLxAv11tDTxBCDj9jcqN5sEO+xe91NU4fYSf6Cq
         VUpfms+szB/kwkJQNGvPJACfxKoYmIC8UheK62AmYmzlgXSS++Cjco87W5Rro+WzCd2z
         DcaKOusrFroEwFBNEOZdPL7J6g7hsLhf2Wl+pS+MD3+gz2XEPpvKQ6GGV1fdfKPUAjWm
         j3mkpiXxYNiFCHmwTjGqVx590QvE9hzdWUd6NW25bKnVnjsd0PAXODLtmjhDRw+v14mF
         prDuiAsph3jr2+cQo0E7l8xciGreYOTXJw0KkYYyiljWh80bC43fAH55FpgLkELOjTc3
         l5UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=krtXa8Lvb25uL7wUhvkQBQ5wIDZy92zz7z0MvoMSqok=;
        b=Bo2XZ9WRyVdlgWjxbEcm0g2VXOIwVM8z6u6pFHEtuXkMM9MP1pmR7vtNb0SPtSzo6y
         E2gCrzyh6n8EtJ1z81cvBPpCRSsXUiH+g52+qannIuKapI0WtxEk51BHpKGbqMGtlUEN
         4IoGkajxoAPzImeXVHp4waf3L3Aj2NYyR0s2knKdYjYIleHUR7UuHydXOIT0Z6/GCWiw
         iNGVJN4Sf+0EFSeGu23JGUDx00vHp2Noj/Zh4wSHOzCoF1TgRrC7NY5zXSMMUToOAztN
         2dnm1AgMQ9W2Vqf5yLwEeP/IdCmxM4rHRktF3+IVcH1g9a+7aRJcVcKK8nmwKO1KhS+V
         TH2g==
X-Gm-Message-State: AOAM5307SteI3eZJp9j58ECobQfIQChxgHwePGAt+R0JcUBng2xFT2vc
        tJKUuYV3M8mT8B4gs14QP7U=
X-Google-Smtp-Source: ABdhPJx61syOHPImj5Bqjs0wixI7X2Upq684YzAhmCubigw3pJ/bQ3V3vFqNcCSF44Wu9Gy9q3YR6g==
X-Received: by 2002:a17:907:3e02:: with SMTP id hp2mr10284010ejc.411.1610752499827;
        Fri, 15 Jan 2021 15:14:59 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id e1sm5481862edk.51.2021.01.15.15.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 15:14:59 -0800 (PST)
Date:   Sat, 16 Jan 2021 01:14:58 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [PATCH net-next] net: dsa: set
 configure_vlan_while_not_filtering to true by default
Message-ID: <20210115231458.ush3qo5lv6zk54qj@skbuf>
References: <20210114173426.2731780-1-olteanv@gmail.com>
 <20210115150314.757c8740@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210115231248.gsebq3bqro23qz7y@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115231248.gsebq3bqro23qz7y@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 16, 2021 at 01:12:48AM +0200, Vladimir Oltean wrote:
> On Fri, Jan 15, 2021 at 03:03:14PM -0800, Jakub Kicinski wrote:
> > On Thu, 14 Jan 2021 19:34:26 +0200 Vladimir Oltean wrote:
> > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > 
> > > As explained in commit 54a0ed0df496 ("net: dsa: provide an option for
> > > drivers to always receive bridge VLANs"), DSA has historically been
> > > skipping VLAN switchdev operations when the bridge wasn't in
> > > vlan_filtering mode, but the reason why it was doing that has never been
> > > clear. So the configure_vlan_while_not_filtering option is there merely
> > > to preserve functionality for existing drivers. It isn't some behavior
> > > that drivers should opt into. Ideally, when all drivers leave this flag
> > > set, we can delete the dsa_port_skip_vlan_configuration() function.
> > 
> > No longer applies :(
> 
> What's the error?

Never mind, I know what happened. It rebased cleanly just because git is
smart. I'll resend a v2 with the updated context.
