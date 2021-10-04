Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D6A4205E9
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 08:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbhJDGja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 02:39:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232536AbhJDGja (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 02:39:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E126B6120F;
        Mon,  4 Oct 2021 06:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633329461;
        bh=nUn5+lxliX8C9iNQcew76Wqvp8zRRWbU1gAS2vMx6Tw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RY8bUxVwd24wkuMiaf5/1WwFCQALhuUE8dk7ypc+K2sBhVV7IdS1YCq+drJTSSbDY
         HRj1RzMqaXdRQcbqv0PhJI5L67gtuzDjpx9NyDv0bBjeaSZGBXODwE4bsUftvAV4pl
         qvl3vWo4ZOYQ+LEs3CEzf8PQDiHYBV3uJKb38kio=
Date:   Mon, 4 Oct 2021 08:37:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Pavel Machek <pavel@ucw.cz>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        netdev@vger.kernel.org,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: are device names part of sysfs ABI? (was Re: devicename part of
 LEDs under ethernet MAC / PHY)
Message-ID: <YVqhMeuDI0IZL/zY@kroah.com>
References: <20211001133057.5287f150@thinkpad>
 <YVb/HSLqcOM6drr1@lunn.ch>
 <20211001144053.3952474a@thinkpad>
 <20211003225338.76092ec3@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211003225338.76092ec3@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 03, 2021 at 10:53:38PM +0200, Marek Behún wrote:
> Hello Greg,
> 
> could you give your opinion on this discussion?

What discussion?  Top posting ruins that :(

> Are device names (as returned by dev_name() function) also part of
> sysfs ABI? Should these names be stable across reboots / kernel
> upgrades?

Stable in what exact way?

Numbering of devices (where a dynamic value is part of a name, like the
"42" in "usb42"), is never guaranteed to be stable, but the non-number
part of the name (like "usb" is in "usb42") is stable, as that is what
you have properly documented in the Documentation/ABI/ files defining
the bus and class devices, right?

The very reason we export all of this information to userspace is so
that userspace can figure it all out in ways it wants to, if it wants
to, and no naming scheme that has to be static and deterministic is
forced into the kernel, where it does NOT belong.

That is 1/2 of the reason why we created the whole "unified
device/driver model" in the kernel in the first place all those years
ago.

Does that help?  I can't figure out what the "problem" is here...

thanks,

greg k-h
