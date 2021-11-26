Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 398DF45E669
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 04:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243692AbhKZDGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 22:06:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:53956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245633AbhKZDEO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 22:04:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E367A6104F;
        Fri, 26 Nov 2021 03:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637895662;
        bh=42Z3prBA3T0fHds5xnp4RN0xuyReiijwA0liS98YTkQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FLnF26FpY3IW78MZH5EWHlNP0V58Doj/Dg6q2xiTC9P3LTujP+uZR9go0g5HiXzCY
         O0Hgj5uBwsDEiPWCt+Xic27p6tOFuKFql0ewdskNd+gBu43PHVmRvjNITP+nBx1B6n
         MYC4/7TUBL+eEkeJ+EFKtPzNPDvlnmz7TzIVUlnux1Y3OB/9Yn54NbQElg5yRrfWla
         0JBMC9yRO8lxFPWdrKrPoZ7csk7Ys/KG9qsRk0o6E9dJ5D8wALKZIe/RP3WeSV7NKO
         Se4/85GT35W3WgWJLMQQZ7tLlnAICSDVEArjio4YCgEKoYb1Jfg6SMwEbQNgldWgni
         flbyuMb4Ym14w==
Date:   Thu, 25 Nov 2021 19:01:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Po Liu <po.liu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <atenart@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.B. Lu" <yangbo.lu@nxp.com>, Rui Sousa <rui.sousa@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>
Subject: Re: [PATCH net-next 0/4] Fix broken PTP over IP on Ocelot switches
Message-ID: <20211125190101.63f1f0a2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211125234520.2h6vtwar4hkb2knd@skbuf>
References: <20211125232118.2644060-1-vladimir.oltean@nxp.com>
        <20211125234520.2h6vtwar4hkb2knd@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Nov 2021 23:45:21 +0000 Vladimir Oltean wrote:
> On Fri, Nov 26, 2021 at 01:21:14AM +0200, Vladimir Oltean wrote:
> > Po Liu reported recently that timestamping PTP over IPv4 is broken using
> > the felix driver on NXP LS1028A. This has been known for a while, of
> > course, since it has always been broken. The reason is because IP PTP
> > packets are currently treated as unknown IP multicast, which is not
> > flooded to the CPU port in the ocelot driver design, so packets don't
> > reach the ptp4l program.
> > 
> > The series solves the problem by installing packet traps per port when
> > the timestamping ioctl is called, depending on the RX filter selected
> > (L2, L4 or both).
> 
> I don't know why I targeted these patches to "net-next". Habit I guess.
> Nonetheless, they apply equally well to "net", can they be considered
> for merging there without me resending?

Only patch 1 looks like a fix, tho? Patch 4 seems to fall into 
the "this never worked and doesn't cause a crash" category.

I'm hoping to send a PR tomorrow, so if you resend quickly it 
will be in net-next soon.
