Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6274457886A
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 19:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235629AbiGRR31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 13:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233477AbiGRR30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 13:29:26 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8106555;
        Mon, 18 Jul 2022 10:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xKnevU/94YSw3Ocux7u+8CQU8vdT2o5/n6VI6gzr4dI=; b=AIxDr+4psF5lfR3bm5dgm153bc
        c2SMjcvQ5ce1MzJy3TsI9xEe+GQ9O1hI75pjUmSUgcfTqIjguCuA7br09XH70MOsPO3hxlIXZxB7s
        yl6yr9mojJQfEfLdJotr9gz/ht0zIMqdBopCaAwGinS8v62iyNCegNw4cqKiUoRfbTTE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oDUYE-00AjbS-5Y; Mon, 18 Jul 2022 19:28:58 +0200
Date:   Mon, 18 Jul 2022 19:28:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v3 08/47] net: phylink: Support differing link
 speeds and interface speeds
Message-ID: <YtWYWhAm/n5mnw4I@lunn.ch>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-9-sean.anderson@seco.com>
 <YtMaKWZyC/lgAQ0i@lunn.ch>
 <YtWFAfu1nSE6vCfx@shell.armlinux.org.uk>
 <b1c3fc9f-71af-6610-6f58-64a0297347dd@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1c3fc9f-71af-6610-6f58-64a0297347dd@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I am rather worried that we have drivers using ->speed today in their
> > mac_config and we're redefining what that means in this patch.
> 
> Well, kind of. Previously, interface speed was defined to be link speed,
> and both were just "speed". The MAC driver doesn't really care what the
> link speed is if there is a phy, just how fast the phy interface mode
> speed is.

I'm not sure that is true. At least for SGMII, the MAC is passed the
line side speed, which can be 10, 100, or 1G. The PHY interface mode
speed is fixed at 1G, since it is SGMII, but the MAC needs to know if
it needs to repeat symbols because the line side speed is lower than
the host side speed.

     Andrew
