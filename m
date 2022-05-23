Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCC7530ED0
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 15:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235368AbiEWMRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 08:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235357AbiEWMRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 08:17:16 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5456125C7B;
        Mon, 23 May 2022 05:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Qg7esZWEzWeo1cy06uHXjtqSIw4RkI4Og9wGS2CQMWs=; b=rO3ujDMNxUI/nT/C1PVeHBQKde
        NESBTlwYICi529yJ7nT5Qntrfb0yDUwS8vYUhyHb8eOYkmbyKMtM/HjGATDHkNeWQxMMGjCisNw32
        ZihIOTX4lHfaZgAEf+Gyjbn4aXEaNb7QgqRAG5rJ2T4iq7bN+3j5e6V89qDXoxUrWnQE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nt6zY-003yho-He; Mon, 23 May 2022 14:16:56 +0200
Date:   Mon, 23 May 2022 14:16:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tommaso Merciai <tommaso.merciai@amarulasolutions.com>
Cc:     michael@amarulasolutions.com, alberto.bianchi@amarulasolutions.com,
        linux-amarula@amarulasolutions.com, linuxfancy@googlegroups.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: phy: DP83822: enable rgmii mode if
 phy_interface_is_rgmii
Message-ID: <Yot7OD8MAQPttmyV@lunn.ch>
References: <20220520235846.1919954-1-tommaso.merciai@amarulasolutions.com>
 <YokxxlyFTJZ8c+5y@lunn.ch>
 <20220523065754.GJ1589864@tom-ThinkPad-T14s-Gen-2i>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523065754.GJ1589864@tom-ThinkPad-T14s-Gen-2i>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 08:57:54AM +0200, Tommaso Merciai wrote:
> On Sat, May 21, 2022 at 08:39:02PM +0200, Andrew Lunn wrote:
> > On Sat, May 21, 2022 at 01:58:46AM +0200, Tommaso Merciai wrote:
> > > RGMII mode can be enable from dp83822 straps, and also writing bit 9
> > > of register 0x17 - RMII and Status Register (RCSR).
> > > When phy_interface_is_rgmii rgmii mode must be enabled, same for
> > > contrary, this prevents malconfigurations of hw straps
> > > 
> > > References:
> > >  - https://www.ti.com/lit/gpn/dp83822i p66
> > > 
> > > Signed-off-by: Tommaso Merciai <tommaso.merciai@amarulasolutions.com>
> > > Co-developed-by: Michael Trimarchi <michael@amarulasolutions.com>
> > > Suggested-by: Alberto Bianchi <alberto.bianchi@amarulasolutions.com>
> > > Tested-by: Tommaso Merciai <tommaso.merciai@amarulasolutions.com>
> > 
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > 
> > If you want to, you could go further. If bit 9 is clear, bit 5 defines
> > the mode, either RMII or MII. There are interface modes defined for
> > these, so you could get bit 5 as well.
> 
> Hi Andrew,
> Thanks for the review and for your time.
> I'll try to go further, like you suggest :)

Hi Tomaso

This patch has been accepted, so you will need to submit an
incremental patch. I also expect net-next to close soon for the merge
window, so you might want to wait two weeks before submitting.

	Andrew
