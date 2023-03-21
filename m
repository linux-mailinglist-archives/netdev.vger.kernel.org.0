Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6DBB6C367E
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 17:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbjCUQDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 12:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbjCUQDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 12:03:03 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC64EE3A9;
        Tue, 21 Mar 2023 09:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=UhI5aI9t9AlQX1lyEkSQgbbBqJx4akdZKnAhh0dLnAE=; b=Gf8Qvy0U+a8VjilUEoLdKSmrpY
        4U2VlqXFZQloRFCLUYziSbHNMTAsMSYcgZ3H9q6pPL8jEfXyRZ1IhuBPI0MjS93KxKG7CZZMEEIc1
        gvAI4xSTOunBPvpQ2TwITEt6p8IkeX3iIX1ihOXWZwx4xhn99+z40C53V4+WXxXg6BtA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1peeRe-007yxn-HD; Tue, 21 Mar 2023 17:02:42 +0100
Date:   Tue, 21 Mar 2023 17:02:42 +0100
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
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH v5 04/15] leds: Provide stubs for when CLASS_LED
 is disabled
Message-ID: <c07d07b3-42bc-4433-8f8d-3bee75218df7@lunn.ch>
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
 <20230319191814.22067-5-ansuelsmth@gmail.com>
 <aa2d0a8b-b98b-4821-9413-158be578e8e0@lunn.ch>
 <64189d72.190a0220.8d965.4a1c@mx.google.com>
 <5ee3c2cf-8100-4f35-a2df-b379846a8736@lunn.ch>
 <6419c60e.df0a0220.1949a.c432@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6419c60e.df0a0220.1949a.c432@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> BTW yes I repro the problem.
> 
> Checked the makefile and led-core.c is compiled with NEW_LEDS and
> led-class is compiled with LEDS_CLASS.
> 
> led_init_default_state_get is in led-core.c and this is the problem with
> using LEDS_CLASS instead of NEW_LEDS...
> 
> But actually why we are putting led_init_default_state_get behind a
> config? IMHO we should compile it anyway.

It is pointless if you don't have any LED support. To make it always
compiled, you would probably need to move it into leds.h. And then you
bloat every user with some code which is not hot path.

      Andrew
