Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABFD634B741
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 13:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhC0Mk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 08:40:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229582AbhC0Mk7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Mar 2021 08:40:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E64A619C9;
        Sat, 27 Mar 2021 12:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616848836;
        bh=3VV+CnI+qYEN6es0BwNT6G0L+Q81CDeO0DCIN1lsJoY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p8JnJotcN5reSX3u3jwu39BrFYw6UC2hIqpEx0c11GihYdHOV08mPJ/ouMPpYi8zV
         31KiI4TjfmtaeILHLYgmewx7jvkMkelguau719vwaj6+y/ubZsmEhMgfpZfotoIT44
         6csfU4qR2FgsJKzG6cp4gisl+S1zjiaIKt666YqI=
Date:   Sat, 27 Mar 2021 13:40:34 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Don Bollinger <don@thebollingers.org>
Cc:     'Andrew Lunn' <andrew@lunn.ch>, 'Jakub Kicinski' <kuba@kernel.org>,
        arndb@arndb.de, linux-kernel@vger.kernel.org,
        brandon_chuang@edge-core.com, wally_wang@accton.com,
        aken_liu@edge-core.com, gulv@microsoft.com, jolevequ@microsoft.com,
        xinxliu@microsoft.com, 'netdev' <netdev@vger.kernel.org>,
        'Moshe Shemesh' <moshe@nvidia.com>
Subject: Re: [PATCH v2] eeprom/optoe: driver to read/write SFP/QSFP/CMIS
 EEPROMS
Message-ID: <YF8nwvFkqrt34AGQ@kroah.com>
References: <20210315103950.65fedf2c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <001201d719c6$6ac826c0$40587440$@thebollingers.org>
 <YFJHN+raumcJ5/7M@lunn.ch>
 <009601d72023$b73dbde0$25b939a0$@thebollingers.org>
 <YFpr2RyiwX10SNbD@lunn.ch>
 <011301d7226f$dc2426f0$946c74d0$@thebollingers.org>
 <YF46FI4epRGwlyP8@lunn.ch>
 <011901d7227c$e00015b0$a0004110$@thebollingers.org>
 <YF5GA1RbaM1Ht3nl@lunn.ch>
 <011c01d72284$544c8f50$fce5adf0$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <011c01d72284$544c8f50$fce5adf0$@thebollingers.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 02:09:36PM -0700, Don Bollinger wrote:
> > You keep missing the point. I always refer to the KAPI. The driver we can
> > rework and rework, throw away and reimplement, as much as we want.
> > The KAPI cannot be changed, it is ABI. It is pretty much frozen the day
> the
> > code is first committed.
> 
> Maybe I don't understand what you mean by KAPI.  The KAPI that optoe exposes
> is in two parts.
> 
> First, it makes the EEPROM accessible via the nvmem() interface, an existing
> KAPI that I call from optoe.  at24 implemented it, I made use of it.  This
> interface exposes EEPROM data to user space through a defined sysfs() file.
> I didn't invent this, nor am I proposing it, it already exists.

Again, a "raw" interface to a device that is just memory-mapping all of
the device information directly is no sort of a real KABI at all.

It is no different from trying to use /dev/mem/ to write a networking
driver, just because you can mmap in the device's configuration space to
userspace.

That is not a real api, it is only using the kernel as a "pass-through"
which works fine for one-off devices, and other oddities, but is not a
unified user/kernel api for a class of device types at all.

thanks,

greg k-h
