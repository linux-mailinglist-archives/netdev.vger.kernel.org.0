Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0D3D5548BC
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357331AbiFVLXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 07:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357605AbiFVLW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 07:22:58 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC76D3A71C;
        Wed, 22 Jun 2022 04:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=I+IQpUdGRvzryPiMbgvBe30v5I8PKYgMnD6LyAtMq9s=; b=j1+GJak+LXgezTk5y6Op6Hz8Oc
        gCjGb6oeibd7Z+rMixmSzNt+EVlBH77RTjCj8p6uUUtjWrJ1ZN7JGNfgu+Jc/YW5zlQ0B+38D14JJ
        xnEUEQZ1SVVSqO38mOwulyJmIKpmB5vluJ/Gr5J6Cwj1Gx33tIgT4/BMrt1jyPeRl+CU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o3yR5-007qRc-VN; Wed, 22 Jun 2022 13:22:15 +0200
Date:   Wed, 22 Jun 2022 13:22:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, vivien.didelot@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        upstream@semihalf.com
Subject: Re: [net-next: PATCH 09/12] Documentation: ACPI: DSD: introduce DSA
 description
Message-ID: <YrL7Z6/ghTO/9wlx@lunn.ch>
References: <20220620150225.1307946-1-mw@semihalf.com>
 <20220620150225.1307946-10-mw@semihalf.com>
 <YrDO05TMK8SVgnBP@lunn.ch>
 <YrGm2jmR7ijHyQjJ@smile.fi.intel.com>
 <YrGpDgtm4rPkMwnl@lunn.ch>
 <YrGukfw4uiQz0NpW@smile.fi.intel.com>
 <CAPv3WKf_2QYh0F2LEr1DeErvnMeQqT0M5t40ROP2G6HSUwKpQQ@mail.gmail.com>
 <YrL3DQD92ijLam2V@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrL3DQD92ijLam2V@smile.fi.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > It's not device on MDIO bus, but the MDIO controller's register itself
> > (this _CSR belongs to the parent, subnodes do not refer to it in any
> > way). The child device requires only _ADR (or whatever else is needed
> > for the case the DSA device is attached to SPI/I2C controllers).
> 
> More and more the idea of standardizing the MDIOSerialBus() resource looks
> plausible. The _ADR() usage is a bit grey area in ACPI specification. Maybe
> someone can also make it descriptive, so Microsoft and others won't utilize
> _ADR() in any level of weirdness.

I don't know if it makes any difference, but there are two protocols
spoken over MDIO, c22 and c45, specified in clause 22 and clause 45 of
the 802.3 specification. In some conditions, you need to specify which
protocol to speak to a device at a particular address. In DT we
indicate this with the compatible string, when maybe it should really
be considered as an extension of the address.

If somebody does produce a draft for MDIOSerialBus() i'm happy to
review it.

       Andrew
