Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF372EC291
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 18:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbhAFRm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 12:42:57 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:53937 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727612AbhAFRm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 12:42:56 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 739B558063E;
        Wed,  6 Jan 2021 12:42:10 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 06 Jan 2021 12:42:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=88WHMK
        ljyBvjAmh/aCTDdrfA9FdTH2QxRT2ZD5tzrNQ=; b=O76pjQU6SHaDOoRiBCj6tx
        Euvb5S05S/Bpxcz5dwR7GtWnWOCp10q4N7sCP7n10tZaXU9JTMrhbHc784erCMDn
        R7uH/LqHg6WwhQKlZq6D0SVvA/chVrxOSYDCiw1p8fJby1Fqh3P3zIczFkLhDIdo
        ylvUymegaTTmmOpH+ylfsZEcYQcdR0HCkdDMTl41xWuM0Ms2sBWTvKmNhcL0UDCa
        xeLDgSIfdRIzA1yZVCDAXQyyE/oKs6SYE552ab7oh9vlHUTe6pgoyS5bwe6uVcXA
        IoJJxxw7qY4E5GC+kFXM1NqslIGubdhTlk+6CtXMGiHVEUNHSzgUaqc0ZdEwp66w
        ==
X-ME-Sender: <xms:bfb1X_OVjNQDTZfgLzBMBBE7BGqa8uQ0VJwhVm21QRFiD1AbdCxQcA>
    <xme:bfb1X59GjgwtmtIlJMaP0tMy8PrXrHHWNUnYQvjLOUJFlKSuz04zmwKTBFWsVRdlW
    yq1inMXKj_43SM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdegtddgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:bfb1X-RD-x_lC67jTsQ_B0I7aZJRbmkzcaIE4opPlaFbq5ilm9jUjQ>
    <xmx:bfb1XzssDvAkKC42tk6zNRoYrUE5FBQ-Czmh2P14lC9Qg7zhwRYKEA>
    <xmx:bfb1X3ebbR72676W3Cg4kvigsFuTBgqsZXIQrqw_6RSXpbSDwAaEkg>
    <xmx:cvb1XwA4R9EVC9cT-z8oFuwsgX9LdNsEQmGcMf5lmCQ4mRTnHaexPA>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 04F1524005A;
        Wed,  6 Jan 2021 12:42:05 -0500 (EST)
Date:   Wed, 6 Jan 2021 19:42:02 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: Re: [PATCH v2 net-next 02/10] net: switchdev: remove the transaction
 structure from port object notifiers
Message-ID: <20210106174202.GA1082997@shredder.lan>
References: <20210106131006.577312-1-olteanv@gmail.com>
 <20210106131006.577312-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106131006.577312-3-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 06, 2021 at 03:09:58PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Since the introduction of the switchdev API, port objects were
> transmitted to drivers for offloading using a two-step transactional
> model, with a prepare phase that was supposed to catch all errors, and a
> commit phase that was supposed to never fail.
> 
> Some classes of failures can never be avoided, like hardware access, or
> memory allocation. In the latter case, merely attempting to move the
> memory allocation to the preparation phase makes it impossible to avoid
> memory leaks, since commit 91cf8eceffc1 ("switchdev: Remove unused
> transaction item queue") which has removed the unused mechanism of
> passing on the allocated memory between one phase and another.
> 
> It is time we admit that separating the preparation from the commit
> phase is something that is best left for the driver to decide, and not
> something that should be baked into the API, especially since there are
> no switchdev callers that depend on this.
> 
> This patch removes the struct switchdev_trans member from switchdev port
> object notifier structures, and converts drivers to not look at this
> member.
> 
> Where driver conversion is trivial (like in the case of the Marvell
> Prestera driver, NXP DPAA2 switch, TI CPSW, and Rocker drivers), it is
> done in this patch.
> 
> Where driver conversion needs more attention (DSA, Mellanox Spectrum),
> the conversion is left for subsequent patches and here we only fake the
> prepare/commit phases at a lower level, just not in the switchdev
> notifier itself.
> 
> Where the code has a natural structure that is best left alone as a
> preparation and a commit phase (as in the case of the Ocelot switch),
> that structure is left in place, just made to not depend upon the
> switchdev transactional model.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Jiri Pirko <jiri@nvidia.com>

This looks good to me. I think that faking the prepare/commit phase made
it easier to review.

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
