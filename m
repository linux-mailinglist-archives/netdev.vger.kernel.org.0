Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48555591B3A
	for <lists+netdev@lfdr.de>; Sat, 13 Aug 2022 17:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239673AbiHMPMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Aug 2022 11:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239634AbiHMPME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Aug 2022 11:12:04 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1FF13CED;
        Sat, 13 Aug 2022 08:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=WapydjWUane8f3QxMtubXs/QK0ODLAdb+vKaEJ8bjAc=; b=w+HL5WiPOhI4wdFgzMqzxODMzZ
        FaUvcyPj8Umu+d/o1TGjTG3+SNxVVsOnGM4leP0g54Quyi5u8qvypyfOjhrViRJG0iPMDNNBdt2Yi
        aHmclgf/RHGyBeOms2YKq7nd6R51Nft+lyT+qOOaczBAWZgAWLA2Gk+DzQmthbI/f31A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oMsnh-00DDzY-3j; Sat, 13 Aug 2022 17:11:45 +0200
Date:   Sat, 13 Aug 2022 17:11:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 07/10] net: dsa: microchip: warn about not
 supported synclko properties on KSZ9893 chips
Message-ID: <Yve/MSMc/4klJPFL@lunn.ch>
References: <20220729130346.2961889-1-o.rempel@pengutronix.de>
 <20220729130346.2961889-8-o.rempel@pengutronix.de>
 <20220802113633.73rxlb2kmihivwpx@skbuf>
 <20220805115601.GB10667@pengutronix.de>
 <20220805134234.ps4qfjiachzm7jv4@skbuf>
 <20220813143215.GA12534@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220813143215.GA12534@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 13, 2022 at 04:32:15PM +0200, Oleksij Rempel wrote:
> On Fri, Aug 05, 2022 at 04:42:34PM +0300, Vladimir Oltean wrote:
> > On Fri, Aug 05, 2022 at 01:56:01PM +0200, Oleksij Rempel wrote:
> > > Hm, if we will have any random not support OF property in the switch
> > > node. We won't be able to warn about it anyway. So, if it is present
> > > but not supported, we will just ignore it.
> > > 
> > > I'll drop this patch.
> > 
> > To continue, I think the right way to go about this is to edit the
> > dt-schema to say that these properties are only applicable to certain
> > compatible strings, rather than for all. Then due to the
> > "unevaluatedProperties: false", you'd get the warnings you want, at
> > validation time.
> 
> Hm, with "unevaluatedProperties: false" i have no warnings. Even if I
> create examples with random strings as properties. Are there some new
> json libraries i should use?

Try

additionalProperties: False

	Andrew
