Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2A321FCCD0
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 13:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbgFQLwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 07:52:12 -0400
Received: from mail.intenta.de ([178.249.25.132]:43031 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbgFQLwM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 07:52:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:CC:To:From:Date; bh=d7sPxxOBZ2bV2x84H9eQsQtpU2yKleT69ayaYTKgGH0=;
        b=rP4k0Tad0SPVJs7/bvOerU5CD6qGw2abd7Hrybe5Z7BenyUtuptDhEA4HLpRzccRkSS+zjICsb4dePP8KPUp/1XQJGPUym5TNxO0caT4LZl8wwMRGUgIzWTNPNJXJ8yUjCe266pp61uOqja2nvTloPXegwabMGhJriWC9wuUCOlIeeYhFEGWGPg0Fvdodo41g4XeWiJqbcZlr9l9unY9jmff9ot9Rb2G+0V5B+I7t4yQg5Rp8pLeGG2mWL8OnUsbZmMuRPkoxTHd3Gb1foq1KyaBuDSTz3JPGbXIz4Y31q1lhd5JA0PjLfV5+Nb2T76jCWF0RzwZqW2dgCRWpxMLVg==;
Date:   Wed, 17 Jun 2020 13:52:01 +0200
From:   Helmut Grohne <helmut.grohne@intenta.de>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: macb: reject unsupported rgmii delays
Message-ID: <20200617115201.GA30172@laureti-dev>
References: <20200616074955.GA9092@laureti-dev>
 <20200617105518.GO1551@shell.armlinux.org.uk>
 <20200617112153.GB28783@laureti-dev>
 <20200617114025.GQ1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200617114025.GQ1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ICSMA002.intenta.de (10.10.16.48) To ICSMA002.intenta.de
 (10.10.16.48)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 01:40:25PM +0200, Russell King - ARM Linux admin wrote:
> > For a fixed-link, the validation function is never called. Therefore, it
> > cannot reject PHY_INTERFACE_MODE_RGMII. It works in practice.
> 
> Hmm, I'm not so sure, but then I don't know exactly what code you're
> using.  Looking at mainline, even for a fixed link, you call
> phylink_create().  phylink_create() will spot the fixed link, and
> parse the description, calling the validation function.  If that
> fails, it will generate a warning at that point:
> 
>   "fixed link %s duplex %dMbps not recognised"
> 
> It doesn't cause an operational failure, but it means that you end up
> with a zero supported mask, which is likely not expected.
> 
> This is not an expected situation, so I'll modify your claim to "it
> works but issues a warning" which still means that it's not correct.

I do see that warning. I agree with your correction of my claim. Thank
you for your attention to detail.

So we have two good reasons for not rejecting delay configuration in the
validation function now.

The remaining open question seems to be whether configuring a delay on a
MAC to MAC connection should cause a failure or a only warning. Do you
have an opinion on that?

All in-tree bindings of the driver seem to use rmii when they specify a
phy-mode.

Helmut
