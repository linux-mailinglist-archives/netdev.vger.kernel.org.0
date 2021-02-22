Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C21C3215D6
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 13:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbhBVMKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 07:10:39 -0500
Received: from mx2.suse.de ([195.135.220.15]:56192 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230090AbhBVMKc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 07:10:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613995783; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yLeSjdAn6ytvvSZ7l1bruf6v0eYDWUB2oiRB+v/1EnM=;
        b=e/nAV+MYeJjAgiyPTwc40OITAzxjyTJR6GKilTsxVYuBh8sK8jo7wYdB+AV3weQEJR4YWY
        hZ3CT15WUxeCSGnV7dmKjSzHJx4w88Ebamntg49TLET0SNTdnFQFE3G4pHu6cTJbJv4N10
        aTyCPn+8FaTPp1cVYwCPRJ4lpv4xDYY=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1FB54AD5C;
        Mon, 22 Feb 2021 12:09:43 +0000 (UTC)
Message-ID: <d61ad9565e29a07086e52bc984e8e629285ff8cf.camel@suse.com>
Subject: Re: [PATCH] usbnet: ipheth: fix connectivity with iOS 14
From:   Oliver Neukum <oneukum@suse.com>
To:     Sam Bingner <sam@bingner.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Martin Habets <mhabets@solarflare.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matti Vuorela <matti.vuorela@bitfactor.fi>,
        Jakub Kicinski <kuba@kernel.org>,
        Yves-Alexis Perez <corsac@corsac.net>
Date:   Mon, 22 Feb 2021 13:09:38 +0100
In-Reply-To: <370902e520c44890a44cb5dd0cb1595f@bingner.com>
References: <370902e520c44890a44cb5dd0cb1595f@bingner.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Sonntag, den 21.02.2021, 10:42 +0000 schrieb Sam Bingner:
> There seems to be a problem with this patch:
> 
> Whenever the iPhone sends a packet to the tethered device that is 1500 bytes long, it gets the error "ipheth 1-1:4.2: ipheth_rcvbulk_callback: urb status: -79" on the connected device and stops passing traffic.  I am able to bring it back up by shutting and unshutting the interface, but the same thing happens very quickly.   I noticed that this patch dropped the max USB packet size from 1516 to 1514 bytes, so I decided to try lowering the MTU to 1498; this made the connection reliable and no more errors occurred.
> 
> It appears to me that the iPhone is still sending out 1516 bytes over USB for a 1500 byte packet and this patch makes USB abort when that happens?  I could duplicate reliably by sending a ping from the iphone (ping -s 1472) to the connected device, or vice versa as the reply would then break it.
> 
> I apologize if this reply doesn't end up where it should - I tried to reply to the last message in this thread but I wasn't actually *on* the thread so I had to just build it as much as possible myself.

Is this a regression? Does it work after reverting the patch? Which
version of iOS?

	Regards
		Oliver


