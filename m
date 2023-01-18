Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF8667117E
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 04:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjARDIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 22:08:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjARDIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 22:08:15 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195274FCC4;
        Tue, 17 Jan 2023 19:08:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=iHV7CytWlRD3302v/1nhCK0cn5pj1iojKylILrpkF5w=; b=SJahukxj2tI8oL1m0fY0hxQpVM
        mi+h1t0LeaEEFYXe1wOVyClZxbfClPY4dRXyzJMpmNbJc7TW+pJdIEC3LXtoV3B/0Z9SXGivjqsxG
        aLFlmT9X/yakTMbl71PJu7Os+8xMygLek9F+Iy1APbt93OK+e5KNzLyMIAjP9Kz7q7KA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pHyo4-002OGY-U5; Wed, 18 Jan 2023 04:08:08 +0100
Date:   Wed, 18 Jan 2023 04:08:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jerome Brunet <jbrunet@baylibre.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-amlogic@lists.infradead.org,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Da Xue <da@lessconfused.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: mdio: add amlogic gxl mdio mux support
Message-ID: <Y8dimCI7ybeL09j0@lunn.ch>
References: <20230116091637.272923-1-jbrunet@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116091637.272923-1-jbrunet@baylibre.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 10:16:34AM +0100, Jerome Brunet wrote:
> Add support for the MDIO multiplexer found in the Amlogic GXL SoC family.
> This multiplexer allows to choose between the external (SoC pins) MDIO bus,
> or the internal one leading to the integrated 10/100M PHY.
> 
> This multiplexer has been handled with the mdio-mux-mmioreg generic driver
> so far. When it was added, it was thought the logic was handled by a
> single register.
> 
> It turns out more than a single register need to be properly set.
> As long as the device is using the Amlogic vendor bootloader, or upstream
> u-boot with net support, it is working fine since the kernel is inheriting
> the bootloader settings. Without net support in the bootloader, this glue
> comes unset in the kernel and only the external path may operate properly.
> 
> With this driver (and the associated DT update), the kernel no longer relies
> on the bootloader to set things up, fixing the problem.

Ideally, you should also post an actual user of this driver, i.e. the
DT updates.

> This has been tested on the aml-s905x-cc (LePotato) for the internal path
> and the aml-s912-pc (Tartiflette) for the external path.

So these exist in mainline, which is enough for me.

   Andrew
