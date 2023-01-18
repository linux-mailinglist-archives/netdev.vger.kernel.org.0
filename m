Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5138671EDB
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 15:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbjAROFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 09:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbjAROEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 09:04:40 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4757C879;
        Wed, 18 Jan 2023 05:41:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=2QcbDYHnM4a3YLo7hIdVvZnhWZb4/tSVbe2++CBXB9g=; b=SJknLVJBnEys14G+7GP/TIHz5k
        Y764E0y+eowQj/szyhxYjbR7Y9GV87ccwevhJUOpYwpGXwgg9v28drNZh1OYKrb5cUnNZo0N+sBFc
        /JZpgphtcqK9xNu3yFA71hxAeGmYXjL12fD8Hc1krI9a4mwD52WTICKXxIGZ7HOpTL8M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pI8gR-002RYT-0m; Wed, 18 Jan 2023 14:40:55 +0100
Date:   Wed, 18 Jan 2023 14:40:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Frank.Sae" <Frank.Sae@motor-comm.com>
Cc:     Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        xiaogang.fan@motor-comm.com, fei.zhang@motor-comm.com,
        hua.sun@motor-comm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/3] dt-bindings: net: Add Motorcomm yt8xxx
 ethernet phy Driver bindings
Message-ID: <Y8f254xNPdtR8gq1@lunn.ch>
References: <20230105073024.8390-1-Frank.Sae@motor-comm.com>
 <20230105073024.8390-2-Frank.Sae@motor-comm.com>
 <Y7bN4vJXMi66FF6v@lunn.ch>
 <e762c7ac-63e7-a86e-3e3f-5c8a450b25b0@motor-comm.com>
 <Y7goXXiRBE6XHuCc@lunn.ch>
 <83fd7a69-7e6a-ab93-b05a-4eba8af4d245@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83fd7a69-7e6a-ab93-b05a-4eba8af4d245@motor-comm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 05:20:18PM +0800, Frank.Sae wrote:
> Hi Andrew,
> 
> On 2023/1/6 21:55, Andrew Lunn wrote:
> >>> Why is this needed? When the MAC driver connects to the PHY, it passes
> >>> phy-mode. For RGMII, this is one of:
> >>
> >>> linux/phy.h:	PHY_INTERFACE_MODE_RGMII,
> >>> linux/phy.h:	PHY_INTERFACE_MODE_RGMII_ID,
> >>> linux/phy.h:	PHY_INTERFACE_MODE_RGMII_RXID,
> >>> linux/phy.h:	PHY_INTERFACE_MODE_RGMII_TXID,
> >>>
> >>> This tells you if you need to add a delay for the RX clock line, the
> >>> TX clock line, or both. That is all you need to know for basic RGMII
> >>> delays.
> >>>
> >>
> >> This basic delay can be controlled by hardware or the phy-mode which
> >> passes from MAC driver.
> >> Default value depends on power on strapping, according to the voltage
> >> of RXD0 pin (low = 0, turn off;   high = 1, turn on).
> >>
> >> Add this for the case that This basic delay is controlled by hardware,
> >> and software don't change this.
> > 
> > You should always do what phy-mode contains. Always. We have had
> > problems in the past where a PHY driver ignored the phy-mode, and left
> > the PHY however it was strapped. Which worked. But developers put the
> > wrong phy-mode value in DT. Then somebody had a board which actually
> > required that the DT value really did work, because the strapping was
> > wrong. So the driver was fixed to respect the PHY mode, made that
> > board work, and broke all the other boards which had the wrong
> > phy-mode in DT.
> > 
> > If the user want the driver to leave the mode alone, use the
> > strapping, they should use PHY_INTERFACE_MODE_NA. It is not well
> > documented, but it is used in a few places. However, i don't recommend
> > it.
> > 
> 
> RX delay = rx-delay-basic (0ns or 1.9ns) + x-delay-additional-ps
> (N*150ps, N = 0 ~ 15)
>  If rx-delay-basic is removed and controlled by phy-mode.
>  when phy-mode is  rgmii-id or rgmii-rxid, RX delay is 1.9ns + N*150ps.
>  But sometimes 1.9ns is still too big, we just need  0ns + N*150ps.
> 
> For this case, can we do like following ?
> rx-internal-delay-ps:
>     enum: [ 0, 150, 300, 450, 600, 750, 900, 1050, 1200, 1350, 1500,
> 1650, 1800, 1900, 1950, 2050, 2100, 2200, 2250, 2350, 2500, 2650, 2800,
> 2950, 3100, 3250, 3400, 3550, 3700, 3850, 4000, 4150 ]
>     default: 0
>  rx-internal-delay-ps is 0ns + N*150ps and  1.9ns + N*150ps.
>  And check whether need rx-delay-basic (1.9ns) by the val of
> rx-internal-delay-ps?

Please take a look at phy_get_internal_delay() and the drivers which
use it.

    Andrew
