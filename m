Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A51A8652A16
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 01:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234198AbiLUAAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 19:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbiLUAAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 19:00:11 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1871EAE9;
        Tue, 20 Dec 2022 16:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ZWey8MiaU6pEkm7hu7YYoSQxra2dhDL6Zkj1bzILagQ=; b=O0UxIqJ60w5HMEjz8xkTqvGuen
        ZgvW+OioAEwwWSbYrTEfGTQRzaFDdeO0WbMpEEPoPuD2Y5FBrYlc21IhfXUQ4dBrNC8nYfyHPiJua
        xdY0TG+CO5BLg1g89/zHyL4npN7OEFeEVujsCK6lHvtFUPQTJ6xU/FZa8xz30QOX1Y8w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p7mWZ-0008IM-MY; Wed, 21 Dec 2022 00:59:55 +0100
Date:   Wed, 21 Dec 2022 00:59:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH v7 06/11] leds: trigger: netdev: add hardware control
 support
Message-ID: <Y6JMe9oJDCyLkq7P@lunn.ch>
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
 <20221214235438.30271-7-ansuelsmth@gmail.com>
 <Y5tUU5zA/lkYJza+@shell.armlinux.org.uk>
 <639ca665.1c0a0220.ae24f.9d06@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <639ca665.1c0a0220.ae24f.9d06@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > One thought on this approach though - if one has a PHY that supports
> > "activity" but not independent "rx" and "tx" activity indications
> > and it doesn't support software control, how would one enable activity
> > mode? There isn't a way to simultaneously enable both at the same
> > time... However, I need to check whether there are any PHYs that fall
> > into this category.
> >
> 
> Problem is that for such feature and to have at least something working
> we need to face compromise. We really can't support each switch feature
> and have a generic API for everything.

I agree we need to make compromises. We cannot support every LED
feature of every PHY, they are simply too diverse. Hopefully we can
support some features of every PHY. In the worst case, a PHY simply
cannot be controlled via this method, which is the current state
today. So it is not worse off.

       Andrew
