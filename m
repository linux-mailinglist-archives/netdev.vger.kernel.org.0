Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5C25282549
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 18:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725801AbgJCQG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 12:06:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgJCQG3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Oct 2020 12:06:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F2E4206DD;
        Sat,  3 Oct 2020 16:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601741188;
        bh=apD0HcRmzAXNvqvvX6bN2EfAllTv35RqE/SFUkGFRSM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OYQSAgH9EK6A5wQHy1/z7+ul9pLXETvspHeJUQwrL/zoQmeK90ZYtrh4KFSD4tNS5
         g82RtwvZpLZb7bTh+7Y3ynPvwVOJo6tsEXgrAQTNZxVn/7ClHUWglB8bBKxBoXFMUX
         BQgSfb9q2ThCEbFsNmIdQgxA0cDw48la+8jbhDRA=
Date:   Sat, 3 Oct 2020 18:07:13 +0200
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
Message-ID: <20201003160713.GA1512229@kroah.com>
References: <20201003135449.GA2691@kroah.com>
 <A1C95238-CBCB-4FD4-B46D-A62AED0C77E5@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A1C95238-CBCB-4FD4-B46D-A62AED0C77E5@holtmann.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 03, 2020 at 05:51:03PM +0200, Marcel Holtmann wrote:
> Hi Greg,
> 
> > This reverts commit 0eee35bdfa3b472cc986ecc6ad76293fdcda59e2 as it
> > breaks all bluetooth connections on my machine.
> > 
> > Cc: Marcel Holtmann <marcel@holtmann.org>
> > Cc: Sathish Narsimman <sathish.narasimman@intel.com>
> > Fixes: 0eee35bdfa3b ("Bluetooth: Update resolving list when updating whitelist")
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> > net/bluetooth/hci_request.c | 41 ++-----------------------------------
> > 1 file changed, 2 insertions(+), 39 deletions(-)
> > 
> > This has been bugging me for since 5.9-rc1, when all bluetooth devices
> > stopped working on my desktop system.  I finally got the time to do
> > bisection today, and it came down to this patch.  Reverting it on top of
> > 5.9-rc7 restored bluetooth devices and now my input devices properly
> > work.
> > 
> > As it's almost 5.9-final, any chance this can be merged now to fix the
> > issue?
> 
> can you be specific what breaks since our guys and I also think the
> ChromeOS guys have been testing these series of patches heavily.

My bluetooth trackball does not connect at all.  With this reverted, it
all "just works".

Same I think for a Bluetooth headset, can check that again if you really
need me to, but the trackball is reliable here.

> When you run btmon does it indicate any errors?

How do I run it and where are the errors displayed?

> Do you have a chance to test net-next and see the LL Privacy there might have addressed this?

Have a specific set of patches I can test?  It wouldn't be good to have
5.9-final go out with this not working at all.

thanks,

greg k-h
