Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 460286C3660
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 16:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbjCUP6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 11:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjCUP6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 11:58:46 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3914010A8D;
        Tue, 21 Mar 2023 08:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=URL1tZO+Mirs0erydKMklYrp3ZSfkDqzdADLJvizp6w=; b=6O7pbXHfrDLF1ERdKmcEt4/wro
        CWPWCweOhhbqISBnDZYDjlM9/2ETuYnwCYE6KeGvbwKEi8GamEsBa8qyrD1gVIb6Q184e92b1noDZ
        viurRXe3X38vQUeoz2nv+b7oD4Gt/tEjp4su8bZwanLZprQygZpFo48rLfs8OCZCWQvw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1peeNR-007yuF-79; Tue, 21 Mar 2023 16:58:21 +0100
Date:   Tue, 21 Mar 2023 16:58:21 +0100
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
Message-ID: <32202a37-270f-4503-9147-55aa2615116a@lunn.ch>
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

> Also why IS_ENABLED instead of a simple ifdef? (in leds.h there is a mix
> of both so I wonder if we should use one or the other)

/*
 * IS_ENABLED(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'y' or 'm',
 * 0 otherwise.  Note that CONFIG_FOO=y results in "#define CONFIG_FOO 1" in
 * autoconf.h, while CONFIG_FOO=m results in "#define CONFIG_FOO_MODULE 1".
 */
#define IS_ENABLED(option) __or(IS_BUILTIN(option), IS_MODULE(option))

It cleanly handles the module case, which i guess most people would
get wrong.

    Andrew


