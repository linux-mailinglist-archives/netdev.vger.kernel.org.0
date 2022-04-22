Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C137B50C326
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbiDVWZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 18:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232686AbiDVWZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 18:25:08 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021EA2A7429;
        Fri, 22 Apr 2022 14:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=XSpt1IJ1KFQ65bi+jyiXwQSZangsC0Zf0U2JxFg+R7I=; b=ELivqPkObppEztRJnsptUc9UsI
        akAJaMckp1HEg+hvy+lMYW1VvCWv6w8Hrj8Loib1tTVEkcEWgzuKU18Top0de6EDDJlXIQIls4rne
        6cOONwv2lRxXV3V0PDQ1YY8gESxsggllQvE+ylPsNrqH/vOexLMRLZ3+X2FfSbJ3dj5w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nhzuM-00H2Yn-4L; Fri, 22 Apr 2022 22:29:38 +0200
Date:   Fri, 22 Apr 2022 22:29:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next 0/5] net: ipqess: introduce Qualcomm IPQESS
 driver
Message-ID: <YmMQMoMcO8uU2dKN@lunn.ch>
References: <20220422180305.301882-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422180305.301882-1-maxime.chevallier@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 22, 2022 at 08:03:00PM +0200, Maxime Chevallier wrote:
> Hello everyone,
> 
> This series introduces a new driver, for the Qualcomm IPQESS Ethernet
> Controller, found on the IPQ4019.
> 
> The driver itself is pretty straightforward, but has lived out-of-tree
> for a while. I've done my best to clean-up some outdated API calls, but
> some might remain.
> 
> This controller is somewhat special, since it's part of the IPQ4019 SoC
> which also includes an QCA8K switch, and uses the IPQESS controller for
> the CPU port.

Does it exist in a form where it is not connected to a switch?

As Florian has suggested, if we assume frames are always going
to/coming from a switch, we can play around with the frame format a
little. A dummy tag could be added to the head or tail of the frame,
which the MAC driver then uses. That gives us a more normal structure.

      Andrew
