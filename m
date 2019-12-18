Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 811641249EC
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 15:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbfLROnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 09:43:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:43904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726856AbfLROnT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 09:43:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13E2721582;
        Wed, 18 Dec 2019 14:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576680198;
        bh=iO+tOjqXZhOe4UTZKagiax9WLTYHh3JX3Ykh8qcBQNw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cNIE+m65yGEXDIT8q1cCn6jCzz+YbLIi6jcXwozIVcrH4rjlTlTkzfQuLgEvPj5Mx
         tUJg4m3NqoDIm1arP2yEPR0bI2gfMCcN4xPRjzYU4x1rDwcNCfyV7mYfGgqiRaNq+Z
         9W7bn8XgTFtaD8dRKDtcpHfAdjF6DUYiwhpBsHWo=
Date:   Wed, 18 Dec 2019 15:43:16 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     linux-usb@vger.kernel.org,
        Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Rajmohan Mani <rajmohan.mani@intel.com>,
        Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        Lukas Wunner <lukas@wunner.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Mario.Limonciello@dell.com,
        Anthony Wong <anthony.wong@canonical.com>,
        Oliver Neukum <oneukum@suse.com>,
        Christian Kellner <ckellner@redhat.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] thunderbolt: Add support for USB4
Message-ID: <20191218144316.GA321016@kroah.com>
References: <20191217123345.31850-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217123345.31850-1-mika.westerberg@linux.intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 03:33:36PM +0300, Mika Westerberg wrote:
> Hi all,
> 
> USB4 is the public specification of Thunderbolt 3 protocol and can be
> downloaded here:
> 
>   https://www.usb.org/sites/default/files/USB4%20Specification_1.zip
> 
> USB4 is about tunneling different protocols over a single cable (in the
> same way as Thunderbolt). The current USB4 spec supports PCIe, Display Port
> and USB 3.x, and also software based protocols such as networking between
> domains (hosts).
> 
> So far PCs have been using firmware based Connection Manager (FW CM, ICM)
> and Apple systems have been using software based one (SW CM, ECM). A
> Connection Manager is the entity that handles creation of different tunnel
> types through the USB4 (and Thunderbolt) fabric. With USB4 the plan is to
> have software based Connection Manager everywhere but some early systems
> will come with firmware based connection manager.
> 
> Current Linux Thunderbolt driver supports both "modes" and can detect which
> one to use dynamically.
> 
> This series extends the Linux Thunderbolt driver to support USB4 compliant
> hosts and devices (this applies to both firmware and software based
> connection managers). USB4 Features enabled by this series include:
> 
>   - PCIe tunneling
>   - Display Port tunneling
>   - USB 3.x tunneling
>   - P2P networking (implemented in drivers/net/thunderbolt.c)
>   - Host and device NVM firmware upgrade
> 
> Power management support is still work in progress. It will be submitted
> later on once properly tested.
> 
> The previous versions of the series can be seen here:
> 
>   v1: https://lore.kernel.org/linux-usb/20191023112154.64235-1-mika.westerberg@linux.intel.com/
>   RFC: https://lore.kernel.org/lkml/20191001113830.13028-1-mika.westerberg@linux.intel.com/
> 
> Changes from v1:
> 
>   * Rebased on top of v5.5-rc2.
>   * Add a new patch to populate PG field in hotplug ack packet.
>   * Rename the networking driver Kconfig symbol to CONFIG_USB4_NET to
>     follow the driver itself (CONFIG_USB4).

At a quick glance, this looks nice and sane, good job.  I've taken all
of these into my tree, let's see if 0-day has any problems with it :)

thanks,

greg k-h
