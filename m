Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56E396C7159
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 20:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbjCWTxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 15:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCWTxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 15:53:19 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E29C14D;
        Thu, 23 Mar 2023 12:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=oc/iUo0lIBe+FS5WVSyueoHdxi6tsJxX0Ez4lN9w4K8=; b=yVdVBQAOM+Q4pyNSb2udc1HKJ0
        PJPKMWoeesWKoYQ3VsCuDYywal3A5xt53IIOwb0AIaGSynK+56rNvANbWobJtF7/x66vIobFT2hnO
        XXfGKYN9+lKEFnxV5Gsls/N5g1xnsjwOQjKVOquRy9QutcLVLjpeDXtWxpUVzxtbb6t4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pfQze-008EUF-F2; Thu, 23 Mar 2023 20:53:02 +0100
Date:   Thu, 23 Mar 2023 20:53:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Lee Jones <lee@kernel.org>, John Crispin <john@phrozen.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH v5 15/15] arm: mvebu: dt: Add PHY LED support
 for 370-rd WAN port
Message-ID: <d5e05e20-11e0-4718-ba76-d45412a5e78a@lunn.ch>
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
 <20230319191814.22067-16-ansuelsmth@gmail.com>
 <ZBxAZRcEBg4to132@duo.ucw.cz>
 <318f65ef-fd63-446d-bd08-1ba51b1d1f72@lunn.ch>
 <ZBykRJmkxF7zf8g8@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBykRJmkxF7zf8g8@duo.ucw.cz>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Hi Pavel
> > 
> > It is just a plain boring LED, so it will look like all other LEDs.
> > There is nothing special here.
> 
> Well, AFAICT it will end up as /sys/class/leds/WAN, which is really
> not what we want.

Why not? It is just a plain boring LED. It can be used for anything,
heartbeat, panic SOS in Morse code, shift lock, disk activity. Any of
the triggers can be applied to it.

It can be found in /sys/class/leds/f1072004.mdio-mii:00:WAN. But when
we come to using it for ledtrig-netdev, the user is more likely to follow
/sys/class/net/eth0/phydev/leds/f1072004.mdio-mii\:00\:WAN/

> (Plus the netdev trigger should be tested; we'll
> need some kind of link to the ethernet device if we want this to work
> on multi-ethernet systems).

Since this is a plain boring LED, it could actually blink for any
netdev. When we get to offloading blinking to hardware, then things
change, we need to check the netdev which is configured in the
ledtrig-netdev is the same one the PHY is associated to. But i have a
patchset for that which will appear later.

> Should documentation be added to Documentation/leds/well-known-leds.txt ?

Saying what. That there might be LEDs in your RJ45 connector, which
can be used for anything which is supported by an Linux LED trigger?

    Andrew
