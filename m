Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B51D53DC67
	for <lists+netdev@lfdr.de>; Sun,  5 Jun 2022 16:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345333AbiFEO7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 10:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237838AbiFEO7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 10:59:50 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645801FCE4;
        Sun,  5 Jun 2022 07:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=f6ITGMVSYKdyPTaSGh9FaQu1SXHqypfqsFuH4T3wZRw=; b=op+gHEkyUQkY5emRtaZhkikPsR
        U73v1G5/wt2A1h2pSzlKabKHAD9z4Mv7V1Lhr2Z57HI8OnBRG+R5EI6AnICv906AKYNoWWFFvKmIC
        9BlphuB8QZZLGDTIRU/KxEIRC8l1SShw5540VX/TiSjacvIETW4YvdTcLBElo4caBYoQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nxrjE-005eP9-J2; Sun, 05 Jun 2022 16:59:44 +0200
Date:   Sun, 5 Jun 2022 16:59:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rob Herring <robh@kernel.org>
Cc:     Piyush Malgujar <pmalgujar@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org, cchavva@marvell.com,
        deppel@marvell.com, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v2 2/3] dt-bindings: net: cavium-mdio.txt: add
 clock-frequency attribute
Message-ID: <YpzE4A1MUYNbhKJo@lunn.ch>
References: <20220530125329.30717-1-pmalgujar@marvell.com>
 <20220530125329.30717-3-pmalgujar@marvell.com>
 <20220602150755.GA2323599-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220602150755.GA2323599-robh@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 02, 2022 at 10:07:55AM -0500, Rob Herring wrote:
> On Mon, May 30, 2022 at 05:53:27AM -0700, Piyush Malgujar wrote:
> > Add support to configure MDIO clock frequency via DTS
> > 
> > Signed-off-by: Damian Eppel <deppel@marvell.com>
> > Signed-off-by: Piyush Malgujar <pmalgujar@marvell.com>
> > ---
> >  Documentation/devicetree/bindings/net/cavium-mdio.txt | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/cavium-mdio.txt b/Documentation/devicetree/bindings/net/cavium-mdio.txt
> > index 020df08b8a30f4df80766bb90e100ae6210a777b..638c341966a80823b9eb2f33b947f38110907cc1 100644
> > --- a/Documentation/devicetree/bindings/net/cavium-mdio.txt
> > +++ b/Documentation/devicetree/bindings/net/cavium-mdio.txt
> > @@ -41,6 +41,9 @@ Properties:
> >  
> >  - reg: The PCI device and function numbers of the nexus device.
> >  
> > +- clock-frequency: MDIO bus clock frequency in Hz. It defaults to 3.125 MHz and
> > +		   and not to standard 2.5 MHz for Marvell Octeon family.

Hi Piyush

There is an ambiguity here in the English. It could be interpreted
that 2.5MHz is the standard for Marvell Octeon family. When in fact
802.3 c22 says it should be up to 2.5MHz.

    For Marvell Octeon family it defaults to 3.125 MHz and not to
    the 802.3 standard 2.5 MHz.

> 
> Already covered by mdio.yaml, so perhaps convert this to DT schema 
> format instead.

Hi Rob

Yes, this property is in mdio.yaml:

  clock-frequency:
    description:
      Desired MDIO bus clock frequency in Hz. Values greater than IEEE 802.3
      defined 2.5MHz should only be used when all devices on the bus support
      the given clock speed.

However, for some reason, this driver decides to break the standard
and defaults to 3.125MHz not 2.5MHz. So i would like that clearly
documented in the binding.

	   Andrew
