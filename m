Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B1D5A44B1
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 10:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiH2IMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 04:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiH2IMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 04:12:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0845954659;
        Mon, 29 Aug 2022 01:12:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92BF960DB9;
        Mon, 29 Aug 2022 08:12:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 458C3C433D6;
        Mon, 29 Aug 2022 08:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661760739;
        bh=5BArqRfjqGhgY7Qi3//xqrpKpeOtRqPRGdf3w0m5HKk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aNu0cI8eRgdYWSSmRJz8qs2fJBbtgDf1eUOu8p7mGuHdlTQsgmQwkxUaVpjkgJhEz
         Gw8ZtmC7fBUWFRv9mSOgvNVyPguepE2ChTuPIfzt5gkiysGCfEvnLa8SKItZn5RmTx
         L4UdNrJU0ompVEgzWT/D1d+SmuiQ87j0v7yK6YHI=
Date:   Mon, 29 Aug 2022 10:12:15 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Sasha Levin <sashal@kernel.org>, stable-commits@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Mark Brown <broonie@kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Ferry Toth <fntoth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Andre Edich <andre.edich@microchip.com>,
        kernelci-results@groups.io, bot@kernelci.org,
        gtucker@collabora.com, stable@vger.kernel.org,
        netdev@vger.kernel.org, linux-omap@vger.kernel.org,
        Phil Elwell <phil@raspberrypi.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: Patch "usbnet: smsc95xx: Forward PHY interrupts to PHY driver to
 avoid polling" has been added to the 5.15-stable tree
Message-ID: <Ywx03wLSexKmNpqC@kroah.com>
References: <20220815061223.2484037-1-sashal@kernel.org>
 <20220826132137.GA24932@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826132137.GA24932@wunner.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 26, 2022 at 03:21:37PM +0200, Lukas Wunner wrote:
> Dear Sasha, Dear Greg,
> 
> On Mon, Aug 15, 2022 at 02:12:23AM -0400, Sasha Levin wrote:
> > This is a note to let you know that I've just added the patch titled
> > 
> >     usbnet: smsc95xx: Forward PHY interrupts to PHY driver to avoid polling
> > 
> > to the 5.15-stable tree which can be found at:
> 
> Please consider reverting upstream commit
> 
>   1ce8b37241ed291af56f7a49bbdbf20c08728e88
>   usbnet: smsc95xx: Forward PHY interrupts to PHY driver to avoid polling")
> 
> in 5.15-stable and 5.18-stable.
> 
> I have received two independent reports (from Mark Brown and Phil Elwell)
> that the commit breaks link detection on LAN95xx USB Ethernet adapters
> in those trees.
> 
> The commit works fine in v5.19, but the backports to 5.15 and 5.18 are
> apparently missing prerequisites.  Until we've figured out what those are,
> the commit should be reverted.

I had to revert 2 commits for this.

Also, 5.18 is end-of-life, no need to worry about that anymore, no one
should be using it.

thanks,

greg k-h
