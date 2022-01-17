Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEDFB4909E1
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 15:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbiAQOBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 09:01:00 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40590 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232569AbiAQOA7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jan 2022 09:00:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=YS790bExTfkh4PHW3hIrNVTP5XO0J1V7mlWfOzj2+hg=; b=kEgFdw/dWrg94oZxKo8cq/EkPK
        V5dNV7H5YZA08vwuYe98OcgpKsQuy6JuvzVs5na5hcJsPZaPaGdUQIPZm413eitLoNlK5aUCwq/HR
        FzjBO4L2dGo2JdZh7OQ//LFe9XTfQ7M2WuNHn0+6+ZxMCBtW2nBfvEuhcl3+lMfi6bQo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n9SYr-001e33-H2; Mon, 17 Jan 2022 15:00:41 +0100
Date:   Mon, 17 Jan 2022 15:00:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, madalin.bucur@nxp.com,
        robh+dt@kernel.org, mpe@ellerman.id.au, benh@kernel.crashing.org,
        paulus@samba.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH net 1/4] net/fsl: xgmac_mdio: Add workaround for erratum
 A-009885
Message-ID: <YeV2idN2wPzrHI0n@lunn.ch>
References: <20220116211529.25604-1-tobias@waldekranz.com>
 <20220116211529.25604-2-tobias@waldekranz.com>
 <YeSV67WeMTSDigUK@lunn.ch>
 <87czkqdduh.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87czkqdduh.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 17, 2022 at 08:24:22AM +0100, Tobias Waldekranz wrote:
> On Sun, Jan 16, 2022 at 23:02, Andrew Lunn <andrew@lunn.ch> wrote:
> > On Sun, Jan 16, 2022 at 10:15:26PM +0100, Tobias Waldekranz wrote:
> >> Once an MDIO read transaction is initiated, we must read back the data
> >> register within 16 MDC cycles after the transaction completes. Outside
> >> of this window, reads may return corrupt data.
> >> 
> >> Therefore, disable local interrupts in the critical section, to
> >> maximize the probability that we can satisfy this requirement.
> >
> > Since this is for net, a Fixes: tag would be nice. Maybe that would be
> > for the commit which added this driver, or maybe when the DTSI files
> > for the SOCs which have this errata we added?
> 
> Alright, I wasn't sure how to tag WAs for errata since it is more about
> the hardware than the driver.

The tag gives the backporter an idea how far back to go. If support
for this SoC has only recently been added, there is no need to
backport a long way. If it is an old SoC, then maybe more effort
should be put into the backport?

> Should I send a v2 even if nothing else
> pops up, or is this more of a if-you're-sending-a-v2-anyway type of
> comment?

If you reply with a Fixes: patchwork will automagically append it like
it does Reviewed-by, Tested-by etc.

   Andrew
