Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F645282A42
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 12:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgJDKw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 06:52:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725825AbgJDKw3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Oct 2020 06:52:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C549E208A9;
        Sun,  4 Oct 2020 10:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601808748;
        bh=LTFTpf96xiRnQzkHrsJDx2t7cosvHAasmQcVgfkqtmc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fTFrUfNxvhDhr1lg9I5CPHZmNPwzw7NWNw/E1IzBUMDPl3/MYvGhVKExnHinzKkK3
         g8rdJGAvgfPaxDJGQKujvh0uZJ98sioqxmbF5hRpDCuF9gUrjuNOsP2o5DgRpDxynU
         lCWCPDllVX/GvaBxJAbY8LkskvrOdwYwfXyEx+ao=
Date:   Sun, 4 Oct 2020 12:53:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Sathish Narsimman <sathish.narasimman@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "Bluetooth: Update resolving list when updating
 whitelist"
Message-ID: <20201004105314.GB2429@kroah.com>
References: <20201003135449.GA2691@kroah.com>
 <A1C95238-CBCB-4FD4-B46D-A62AED0C77E5@holtmann.org>
 <20201003160713.GA1512229@kroah.com>
 <AABC2831-4E88-41A2-8A20-1BFC88895686@holtmann.org>
 <20201004105124.GA2429@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201004105124.GA2429@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 04, 2020 at 12:51:24PM +0200, Greg Kroah-Hartman wrote:
> On Sat, Oct 03, 2020 at 08:33:18PM +0200, Marcel Holtmann wrote:
> > Hi Greg,
> > 
> > >>> This reverts commit 0eee35bdfa3b472cc986ecc6ad76293fdcda59e2 as it
> > >>> breaks all bluetooth connections on my machine.
> > >>> 
> > >>> Cc: Marcel Holtmann <marcel@holtmann.org>
> > >>> Cc: Sathish Narsimman <sathish.narasimman@intel.com>
> > >>> Fixes: 0eee35bdfa3b ("Bluetooth: Update resolving list when updating whitelist")
> > >>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > >>> ---
> > >>> net/bluetooth/hci_request.c | 41 ++-----------------------------------
> > >>> 1 file changed, 2 insertions(+), 39 deletions(-)
> > >>> 
> > >>> This has been bugging me for since 5.9-rc1, when all bluetooth devices
> > >>> stopped working on my desktop system.  I finally got the time to do
> > >>> bisection today, and it came down to this patch.  Reverting it on top of
> > >>> 5.9-rc7 restored bluetooth devices and now my input devices properly
> > >>> work.
> > >>> 
> > >>> As it's almost 5.9-final, any chance this can be merged now to fix the
> > >>> issue?
> > >> 
> > >> can you be specific what breaks since our guys and I also think the
> > >> ChromeOS guys have been testing these series of patches heavily.
> > > 
> > > My bluetooth trackball does not connect at all.  With this reverted, it
> > > all "just works".
> > > 
> > > Same I think for a Bluetooth headset, can check that again if you really
> > > need me to, but the trackball is reliable here.
> > > 
> > >> When you run btmon does it indicate any errors?
> > > 
> > > How do I run it and where are the errors displayed?
> > 
> > you can do btmon -w trace.log and just let it run like tcdpump.
> 
> Ok, attached.
> 
> The device is not connecting, and then I open the gnome bluetooth dialog
> and it scans for devices in the area, but does not connect to my
> existing devices at all.
> 

And any hints on how to read this file?  'btsnoop' has no man page, and
the --help options are pretty sparse :(

thanks,

greg k-h
