Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7BC063F48C
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 16:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiLAPyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 10:54:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbiLAPye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 10:54:34 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2970CAA8F0
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 07:54:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/9rpmG1HlPICYfeHlwA7HplL/Ogaz+WTaWtjq3aweDY=; b=S5+tfmxeFgFo0yNAALWI7Qspag
        V4WGrsn3bWFXtxkjaPnzygjQ4SPrRQJ+9vuZmAtvdcalNzsPV4zRJaUtE37GaOpXrhBGdcDg2yVS7
        yo+wWfDcteoB2sglHiDbbYWa6aIxjWLI8IP+Zh7XxgvWvAs46GhSFL1cCPsbN67xZ/AM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p0ltK-0044j4-KF; Thu, 01 Dec 2022 16:54:26 +0100
Date:   Thu, 1 Dec 2022 16:54:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        netdev@vger.kernel.org, Xu Liang <lxu@maxlinear.com>
Subject: Re: GPY215 PHY interrupt issue
Message-ID: <Y4jOMocoLneO8xoD@lunn.ch>
References: <fd1352e543c9d815a7a327653baacda7@walle.cc>
 <Y4DcoTmU3nWqMHIp@lunn.ch>
 <baa468f15c6e00c0f29a31253c54383c@walle.cc>
 <Y4S4EfChuo0wmX2k@lunn.ch>
 <c69e1d1d897dd7500b59c49f0873e7dd@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c69e1d1d897dd7500b59c49f0873e7dd@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> So, switching the line to GPIO input doesn't help here, which also
> means the interrupt line will be stuck the whole time.

Sounds like they totally messed up the design somehow.

Since we are into horrible hack territory.....

I assume you are using the Link state change interrupt? LSTC?

Maybe instead use Link speed change and Duplex mode change? And
disallow 10/Half. Some PHYs change to 10/Half when they loose
link. They might be enough to tell you the link has changed. You can
then read the BMSR to find out what actually happened.

This is assuming that interrupts in general are not FUBAR.

     Andrew
