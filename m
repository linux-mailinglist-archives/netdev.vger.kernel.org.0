Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDA796AFBBF
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 02:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbjCHBHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 20:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjCHBHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 20:07:18 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8418F59E4E;
        Tue,  7 Mar 2023 17:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Pe/MXYc3tFjZ5nMyptOKaMSqaBuuKSvhU3RB/PwCPjs=; b=EdLaNLA+GDFFurmP3/PTkeqxxs
        jCzIshQ6L6LlGxgEYcbF5jV/ait6PE948jmSQpuFotMaD0uniYV7+evmBbmF1sPcv/+vnAYxDSwTf
        smvVEjZ/eWszg2ZIscJ6ZnLEneBYLpmOCtDywcSb3+bMLvRe+rTkihT//meR/VH2tgZs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pZiGo-006ix1-VA; Wed, 08 Mar 2023 02:07:06 +0100
Date:   Wed, 8 Mar 2023 02:07:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
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
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH 01/11] net: dsa: qca8k: add LEDs basic support
Message-ID: <443a5c04-4551-4a49-bc22-09a333ee82aa@lunn.ch>
References: <20230307170046.28917-1-ansuelsmth@gmail.com>
 <20230307170046.28917-2-ansuelsmth@gmail.com>
 <b03334df-4389-44b5-ac85-8b0878c64512@lunn.ch>
 <6407c6ea.050a0220.7c931.824f@mx.google.com>
 <d1226e21-8150-4959-95b0-e9df2c460b81@lunn.ch>
 <6407dd94.df0a0220.b4618.52e4@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6407dd94.df0a0220.b4618.52e4@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Just checked them, interesting concept, guess we can think of something
> also for the interval setting. That would effectively make all the
> setting of the trigger set. Just my concern is that they may be too much
> specific to netdev trigger and may be problematic for other kind of hw
> control. (one main argument that was made for this feature was that some
> stuff were too much specific and actually not that generic)

I deliberately made this API return a struct device, not a struct
net_device. That should keep it generic. The LED could then be
attached to an disk device, an mtd device, or a tty device, each of
which have an ledtrig-*.c file.

      Andrew
