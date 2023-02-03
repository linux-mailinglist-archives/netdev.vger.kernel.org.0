Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF28468A0C6
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 18:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233080AbjBCRtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 12:49:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233255AbjBCRtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 12:49:06 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5261110404;
        Fri,  3 Feb 2023 09:48:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=7uos+Mc2JLD9U+b4knd+02QDLevvfvKGyAIjRrLhW2g=; b=JsiREVCjJi0npvy0C67Tr6vvo+
        O7tnwn6nRPTxinD6ooH/g2zpV9ulDU2Op3VTRSk6vtzO6K7P2dwAJDwUhOUhu/k7BtCWhJM2tHeyE
        ok+siDHFE17za8At6Gmfgbzt/gidoRnx1qWW6AfQFHKueHAL+Y5WfzUiPcNgACcSBf9I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pO0Ad-0041z4-4m; Fri, 03 Feb 2023 18:48:19 +0100
Date:   Fri, 3 Feb 2023 18:48:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        michael@walle.cc
Subject: Re: [PATCH net-next v2] net: micrel: Add support for lan8841 PHY
Message-ID: <Y91I45dzZyweVDiU@lunn.ch>
References: <20230203122542.436305-1-horatiu.vultur@microchip.com>
 <Y90YrXHeyR6f26Px@lunn.ch>
 <20230203152548.nqrewntwi2tyx4pz@soft-dev3-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203152548.nqrewntwi2tyx4pz@soft-dev3-1>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 04:25:48PM +0100, Horatiu Vultur wrote:
> The 02/03/2023 15:22, Andrew Lunn wrote:
> 
> Hi Andrew,
> 
> > 
> > > +{
> > > +     char *rx_data_skews[4] = {"rxd0-skew-psec", "rxd1-skew-psec",
> > > +                               "rxd2-skew-psec", "rxd3-skew-psec"};
> > > +     char *tx_data_skews[4] = {"txd0-skew-psec", "txd1-skew-psec",
> > > +                               "txd2-skew-psec", "txd3-skew-psec"};
> > 
> > Please take a read of
> > Documentation/devicetree/bindings/net/micrel-ksz90x1.txt and then add
> > a section which describes what these properties mean for this PHY,
> > since nearly every microchip PHY has a different meaning :-(
> 
> I had a closer look at the datasheet of this PHY, and these properties
> for lan8841 are the same for ksz9131, so actually I can reuse the
> function 'ksz9131_config_init', to remove some of the duplicated code.

Great.

> In this case maybe is enough to add the following change in
> 'micrel-ksz90x1.txt' not to create a totally new section.
> 
>  KSZ9131:
> +LAN8841:

Yes, that is good, and KSZ9131 is about the only one which actually
gets this right, so it is a good you can reuse it.

     Andrew
