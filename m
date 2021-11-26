Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEBF45F610
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 21:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240939AbhKZUtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 15:49:00 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54112 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231849AbhKZUrA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 15:47:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=yqBa/1dM5GMhVnLlG/PXnBAWMNB4kSm2agdyG6EOEkQ=; b=w5oe5BCNaz8x+mTBLGP0VtxNlx
        Mfe9HnWNgafhDfm+ntTdKHMMoRiltrJgEURETNga76OPMAjb7zoc3pfNUaDNUHOD9Rmj8fRwFP45g
        8KXKq1L+AN5WFwx9mC4zOX1EoO8P1Wb8quj5eZmToNk+BTFpguTWqBG7uQHR++DRtX4Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mqi4P-00EjCj-MH; Fri, 26 Nov 2021 21:43:45 +0100
Date:   Fri, 26 Nov 2021 21:43:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Holger Brunck <holger.brunck@hitachienergy.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output
 amplitude configurable
Message-ID: <YaFHAbXbEH1fokkx@lunn.ch>
References: <20211126154249.2958-1-holger.brunck@hitachienergy.com>
 <20211126154249.2958-2-holger.brunck@hitachienergy.com>
 <20211126205625.5c0e38c5@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211126205625.5c0e38c5@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +	if (chip->info->ops->serdes_set_out_amplitude && np) {
> > +		if (!of_property_read_u32(np, "serdes-output-amplitude",
> 
> Hmm. Andrew, why don't we use <linux/property.h> instead of
> <linux/of*.h> stuff in this dirver? Is there a reason or is this just
> because it wasn't converted yet?

The problem with device_property_read is that it takes a device. But
this is not actually a device scoped property, it should be considered
a port scoped property. And the port is not a device. DSA is not
likely to convert to the device API because the device API is too
limiting.

	Andrew
