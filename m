Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB3356B4B95
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 16:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbjCJPrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 10:47:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233814AbjCJPrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 10:47:01 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B3B2EBFA4;
        Fri, 10 Mar 2023 07:37:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=MvFhqjBn8lsfHrgXKsRvl+cKYKntZywOxeyOqBNYdjE=; b=TM
        3UJCQk0hGZKteBHnw0DOcgvkEPPN85rhLAKKF05n3myc43csiumRbPS4VkwATWqrDxI3A+KcJKEE7
        Zk9OJ0g9VvNYEouuwIfV+LMEsiolzIN+8eYRgpkPr1cbHuGk/BBytaNqbNAGX3ChjucoUXKT7+hE9
        hI4Z/BX8nNjvbo4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1paej9-006zM1-Ig; Fri, 10 Mar 2023 16:32:15 +0100
Date:   Fri, 10 Mar 2023 16:32:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-omap@vger.kernel.org,
        Michael Walle <michael@walle.cc>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>,
        thomas.petazzoni@bootlin.com, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Minghao Chi <chi.minghao@zte.com.cn>,
        Jie Wang <wangjie125@huawei.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Sean Anderson <sean.anderson@seco.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Marco Bonelli <marco@mebeim.net>
Subject: Re: [PATCH v3 3/5] net: Let the active time stamping layer be
 selectable.
Message-ID: <c0719411-4c8a-4af8-9cd1-f3386b8b8d15@lunn.ch>
References: <20230308135936.761794-1-kory.maincent@bootlin.com>
 <20230308135936.761794-4-kory.maincent@bootlin.com>
 <6408a9b3c7ae1_13061c2082a@willemb.c.googlers.com.notmuch>
 <20230310154125.696a3eb3@kmaincent-XPS-13-7390>
 <640b45e9c765e_1dc964208eb@willemb.c.googlers.com.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <640b45e9c765e_1dc964208eb@willemb.c.googlers.com.notmuch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 09:59:53AM -0500, Willem de Bruijn wrote:
> Köry Maincent wrote:
> > On Wed, 08 Mar 2023 10:28:51 -0500
> > Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
> > 
> > > >  
> > > > +	enum timestamping_layer selected_timestamping_layer;
> > > > +  
> > > 
> > > can perhaps be a single bit rather than an enum
> > 
> > I need at least two bits to be able to list the PTPs available.
> > Look at the ethtool_list_ptp function of the second patch.
> 
> In the available bitmap, yes. Since there are only two options,
> in the selected case, a single bit would suffice.

It was a bit tongue in cheek, but in an earlier thread discussing this
problem, i listed how there could be up to 7 time stampers on the path
from the RJ45 to the network stack.

We got into this problem by assuming there could only ever be one time
stamper. Lets try to avoid potential problems of assuming there can
only every be two time stampers by assuming there can be N stampers.

     Andrew
