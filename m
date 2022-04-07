Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49464F857F
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 19:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242749AbiDGRGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 13:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiDGRGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 13:06:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777AE29C
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 10:04:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13F7861384
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 17:04:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC95C385A4;
        Thu,  7 Apr 2022 17:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649351086;
        bh=zp9bY8jl17eRULfuXCzlZtGh9uxKGx4ek5ehfxaeXso=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zf+JPi+MqJ7Ug6b1jWh3PFDi2/kWis9t+j/WBJsjbr0ggaFmxQKuH+R9Lmz+u9gF2
         ewtkt9MMrwvqYKoOJrMe18Z55MX8FWL+vT0+Hvfr8ioeuYs8tJhabDovgNkhoPXP8E
         eANGIj8/Co51097Y9Xov41yCbxZbNkSnNeupmoZA=
Date:   Thu, 7 Apr 2022 19:04:43 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH net] net: mdio: don't defer probe forever if PHY IRQ
 provider is missing
Message-ID: <Yk8Zq34LtsB9iv6t@kroah.com>
References: <20220406202323.3390405-1-vladimir.oltean@nxp.com>
 <20220406153443.51ad52f8@kernel.org>
 <20220406231956.nwe6kb6vgli2chln@skbuf>
 <20220406172550.6408c990@kernel.org>
 <Yk51TIeGfFmfusQL@kroah.com>
 <20220406223524.42fe2a8a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406223524.42fe2a8a@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 06, 2022 at 10:35:24PM -0700, Jakub Kicinski wrote:
> On Thu, 7 Apr 2022 07:23:24 +0200 Greg Kroah-Hartman wrote:
> > separate patch that I can NAK as I do not understand why this is needed
> > at all :)
> 
> Just in case you meant lack of context rather than the patch itself,
> here's the original posting from lore:
> 
> https://lore.kernel.org/all/20220406202323.3390405-1-vladimir.oltean@nxp.com/
> 
> tl;dr we can fallback to polling if we can't get the IRQ, afaiu.

Ah, ok, that seems sane.
