Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BEC409662
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 16:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346148AbhIMOvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 10:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346764AbhIMOtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 10:49:07 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B20C028BA3;
        Mon, 13 Sep 2021 06:31:33 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id c22so12997860edn.12;
        Mon, 13 Sep 2021 06:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7Hugz/+OONUxuIBhoIuTQLQDjY595cqMrn5yj0K0lzM=;
        b=cR8wuHYosPSDj/uz3fuTLgksvjvk1j8FNRACyVsbGIySnNK7/+iV3qiKlleBUvIyuW
         QMcJGoao9TxQ0hZrcBwjAv0Scc+RA6IyK+fda8+/IpGogmboTd5ykH12mGHdWpvKQ+7v
         Gl5ORap11bejGGFuCZxlAPGItJ5Gy0h4l2owY+CRMKvrnVPL0WCaoEh5MYp3FPIxhezJ
         liOFdzY5s2EK5Z4xDooyxpIsTyFGRMT+Pu1SWaMVRIZLUit2X7YcIskokK5GgK+wtP4u
         oOALSyOTK7t6zOqLX8UakUGcrkPKlbVjx8lioL1/4lr4AAk1DZ5kD7LNUtXf7pMvy9qE
         w5Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7Hugz/+OONUxuIBhoIuTQLQDjY595cqMrn5yj0K0lzM=;
        b=inKmxvMXNR1hXxwhC879rZxtNXtfNDp0sFOUSroX46NiY8DkYP6uyBt5XaWQppkUeZ
         /0h9bntTdWNtVOOR57/x4qKge7btDGVyggI+xN+XHwU1EMP2EmjxL3U1AgfYcG+owWeq
         osJfAen+JHyxVffAoRq5kUT6b2wJRdtqaDpp90aAFYtuiEMJ+lTlCM+eYqeIDvAu/HqX
         DkwgXm4aYz8ISWJr6zYUjzpK2itmalgeIYtGSGDBQ06mxm1OIkb53tQibFZUvnc4KCS1
         7n8YNdFrMR+/1fjdIA6bsk5pUUiqtlIUa38uDaTb6cVDFIYGSubNTvM9n8SPw9wY9yfx
         PEGQ==
X-Gm-Message-State: AOAM531W6YjL/YeGlJN0ijYmCVUGPoWDTy0UCk0uo5O0HdBqbql+BfRz
        LRPty+X/rHnj9k+U4B2zu3k=
X-Google-Smtp-Source: ABdhPJxc8GQPCQx5zgnEkg+JeF6ykMUDFH6iyZOsu/L92kgCejBT/hWMx52SSd15euMtpiLvG9zRIg==
X-Received: by 2002:aa7:d1d3:: with SMTP id g19mr6012882edp.103.1631539892404;
        Mon, 13 Sep 2021 06:31:32 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id v13sm3458353ejh.62.2021.09.13.06.31.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 06:31:32 -0700 (PDT)
Date:   Mon, 13 Sep 2021 16:31:30 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        George McCollister <george.mccollister@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: Re: [RFC PATCH net 2/5] net: dsa: be compatible with masters which
 unregister on shutdown
Message-ID: <20210913133130.ohk4co56v4mtljyk@skbuf>
References: <20210912120932.993440-1-vladimir.oltean@nxp.com>
 <20210912120932.993440-3-vladimir.oltean@nxp.com>
 <20210912131837.4i6pzwgn573xutmo@skbuf>
 <YT9QwOA2DxaXNsfw@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YT9QwOA2DxaXNsfw@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 03:23:12PM +0200, Andrew Lunn wrote:
> > I will fix this when I send the v2 patch, but I will not send that now,
> > as I would like to get some feedback on the approach first.
> 
> It would of been nice to have less boilerplate code, but the basic
> idea seems O.K.
> 
> Have you tested it with a D in DSA system?

To various degrees.

I cannot easily patch DSA masters to just implement ->shutdown as
->remove so as to reproduce Lino's case with the Raspberry Pi, but I did
perform basic regression-testing on:

- the Bluebox 3 board with the 2x SJA1110 switches in a "real" DSA multi
  switch tree setup, with dpaa2-eth as the master and drivers/spi/spi-sc18is602.c
  as the SPI controller

- the weird board with disjoint DSA trees comprised of 2x SJA1105
  switches hanging off of the internal Felix/Ocelot switch of the
  LS1028A which in itself has the fsl-enetc driver as its master. Here I
  could test the fsl-enetc driver with and without the ->shutdown method.
  I also tested with and without dspi_shutdown so as to walk through
  both the sja1105's shutdown and remove methods.

- the Turris MOX board where I did not notice any issues during
  regression testing. The only new message is that the link of the DSA
  interfaces goes down, this is because the net devices are actually
  unregistered on shutdown.

It would be possible to have less boilerplate code, by implementing the
DSA shutdown procedure as dsa_unregister_switch itself.

For buses where the ->remove and ->shutdown have the same prototype
(they both return void), like PCI, the code added is minimal (although
we still need to add the "if this then not that" scheme, to avoid the
function body getting executed twice). For the other buses, there would
still need to be a separate shutdown method, which calls the remove
method. Although in principle, this also has functional consequences
which I am not sure whether I like or not. To walk the full-blown unbind
code path or to do a shutdown with the minimal necessities?
