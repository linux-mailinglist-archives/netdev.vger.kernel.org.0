Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C253349FFED
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 19:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350388AbiA1SGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 13:06:42 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60702 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349942AbiA1SGj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 13:06:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vie3/PM7S4hVbkPSRtFZY3hP76QHnHKvCYyA6kNV6dY=; b=WIuD13vxJKoUJ4eVgvTbTJ6ut+
        oAA80qW/+ZPzm03ymjDkmcDM3VyXhXp1Mosqldq2SObNh/kpPt4ESYvjzNU+6j831GaYkNXE1YTCo
        3TPDnSv9Aei2ejqrcrGbrjfoad4D3cRAjRgABBSRWBXLo4khZX+QSU6broixrELOgGVY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nDVdn-003D2u-VR; Fri, 28 Jan 2022 19:06:31 +0100
Date:   Fri, 28 Jan 2022 19:06:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Henning Schild <henning.schild@siemens.com>
Cc:     Aaron Ma <aaron.ma@canonical.com>, Mario.Limonciello@amd.com,
        kuba@kernel.org, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        davem@davemloft.net, hayeswang@realtek.com, tiwai@suse.de
Subject: Re: [PATCH v3] net: usb: r8152: Add MAC passthrough support for
 RTL8153BL
Message-ID: <YfQwpy1Kkz3wheTi@lunn.ch>
References: <20220127100109.12979-1-aaron.ma@canonical.com>
 <20220128043207.14599-1-aaron.ma@canonical.com>
 <20220128092103.1fa2a661@md1za8fc.ad001.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128092103.1fa2a661@md1za8fc.ad001.siemens.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 28, 2022 at 09:21:03AM +0100, Henning Schild wrote:
> I am still very much against any patches in that direction. The feature
> as the vendors envision it does not seem to be really understood or
> even explained.
> Just narrowing down the device matching caters for vendor lock-in and
> confusion when that pass through is happening and when not. And seems
> to lead to unmaintainable spaghetti-code. 
> People that use this very dock today will see an unexpected mac-change
> once they update to a kernel with this patch applied.

I've not yet been convinced by replies that the proposed code really
does only match the given dock, and not random USB dongles. To be
convinced i would probably like to see code which positively
identifies the dock, and that the USB device is on the correct port of
the USB hub within the dock. I doubt you can actually do that in a
sane way inside an Ethernet driver. As you say, it will likely lead to
unmaintainable spaghetti-code.

I also don't really think the vendor would be keen on adding code
which they know will get reverted as soon as it is shown to cause a
regression.

So i would prefer to NACK this, and push it to udev rules where you
have a complete picture of the hardware and really can identify with
100% certainty it really is the docks NIC.

   Andrew
