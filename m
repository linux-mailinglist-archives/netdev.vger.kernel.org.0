Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97D49485B98
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 23:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244927AbiAEW14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 17:27:56 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53702 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244900AbiAEW1z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 17:27:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=if/pAO/fr1I+S7a6wrzYbvKUCVdTodjuKQ1vJ7pgDks=; b=kwfd2JeoGnWngB89+ebl9ZaPmS
        GI6c0vy5NZQLbsMUPiCyXX2JJ0hlklBQ5LIoYld1m5dRu0Pt0fXlu7Ox3mSseedDu8RZUnBtovCkp
        Ew3XDnVYxflpOk+pKuKryfBIw30ZDYvvjpIUUnZP8upwef9MS8AIooD4BP22/gb2p1iU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n5El4-000bJJ-Dg; Wed, 05 Jan 2022 23:27:50 +0100
Date:   Wed, 5 Jan 2022 23:27:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Aaron Ma <aaron.ma@canonical.com>, kuba@kernel.org,
        henning.schild@siemens.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, hayeswang@realtek.com, tiwai@suse.de
Subject: Re: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough
 address
Message-ID: <YdYbZne6pBZzxSxA@lunn.ch>
References: <20220105151427.8373-1-aaron.ma@canonical.com>
 <YdXVoNFB/Asq6bc/@lunn.ch>
 <bb6d8bc4-abee-8536-ca5b-bac11d1ecd53@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb6d8bc4-abee-8536-ca5b-bac11d1ecd53@suse.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 10:49:56PM +0100, Oliver Neukum wrote:
> 
> On 05.01.22 18:30, Andrew Lunn wrote:
> > On Wed, Jan 05, 2022 at 11:14:25PM +0800, Aaron Ma wrote:
> >> When plugin multiple r8152 ethernet dongles to Lenovo Docks
> >> or USB hub, MAC passthrough address from BIOS should be
> >> checked if it had been used to avoid using on other dongles.
> >>
> >> Currently builtin r8152 on Dock still can't be identified.
> >> First detected r8152 will use the MAC passthrough address.
> > I do have to wonder why you are doing this in the kernel, and not
> > using a udev rule? This seems to be policy, and policy does not belong
> > in the kernel.
> Debatable. An ethernet NIC has to have a MAC. The kernel must
> provide one. That we should always take the one found in the
> device's ROM rather than the host's ROM is already a policy decision.

In general, it is a much longer list of places to find the MAC address
from. It could be in three different places in device tree, it could
be in ACPI in a similar number of places, it could be in NVMEM,
pointed to by device tree, the bootloader might of already programmed
the controller with its MAC address, etc, or if everything else fails,
it could be random.

So yes, the kernel will give it one. But if you want the interface to
have a specific MAC address, you probably should not be trusting the
kernel, given it has so many options.

	Andrew
