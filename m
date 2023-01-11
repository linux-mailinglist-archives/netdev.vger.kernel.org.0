Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD6C665C21
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 14:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbjAKNHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 08:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjAKNHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 08:07:52 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE1921A;
        Wed, 11 Jan 2023 05:07:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=UXiBWiMARtUARLuVCb/C2RAQABw9gUr7NLniBV1MKfk=; b=v9Jqcagt5k7zvlgVRWSVVLCYJ9
        hMkvfw1OzI8T39q5Dat2q4A27PoXAQk+IbDHCGNspW80gZSS9jFNPfWnzvk9LRXPUjeB55cDeMhUY
        yjp3auB60Y3lJytugTAXmY1sEHuzlQBAfubNMJqFruBNcWp6bYWCTL6jY50SN/VO4jD4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pFapH-001mEh-DM; Wed, 11 Jan 2023 14:07:31 +0100
Date:   Wed, 11 Jan 2023 14:07:31 +0100
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
Message-ID: <Y760k6/pKdjwu1fU@lunn.ch>
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

Nothing says delays are only positive. So you could have rgmii-id or
rgmii-rxid and a rx-internal-delay-ps of -150, if you need less than
1.9ns.

As i said, rx-internal-delay-ps is used to fine tune the delay.

> We can't reduce this down to tx-clk-inverted.
> There are two mac and two yt8531 on their board. Each of yt8531 need
> different config in DTS. They need adjust tx clk delay in
> link_change_notify callback function according to current speed.
> 
>  They configured tx-clk-xxxx-inverted like this :
> 
>     speed     GMAC0             GMAC1
>     1000M      1                  0		tx-clk-1000-inverted
>     100M       1                  1		tx-clk-100-inverted
>     10M       0/1                0/1     	tx-clk-10-inverted

What MAC is this? It seems very oddly designed, getting close to
broken. I've not seen any other MAC/PHY combination need anything like
this. 

> Can we put tx-clk-adj-enabled, tx-clk-10-inverted, tx-clk-100-inverted
> and tx-clk-1000-inverted in tx-clk-10-inverted like bit in byte?

No, they are individual boolean properties, so should be kept as they
are. But i really think somebody should be looking deep into the MAC
design to understand why it is like this, and if the MAC can sort out
this mess itself.

	Andrew
