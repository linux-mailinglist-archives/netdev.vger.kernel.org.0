Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A56E282A9A
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 14:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbgJDMSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 08:18:43 -0400
Received: from mslow2.mail.gandi.net ([217.70.178.242]:45368 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbgJDMSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 08:18:43 -0400
Received: from relay4-d.mail.gandi.net (unknown [217.70.183.196])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id 6E95A3AC513;
        Sun,  4 Oct 2020 12:17:31 +0000 (UTC)
X-Originating-IP: 82.255.60.242
Received: from [192.168.0.28] (lns-bzn-39-82-255-60-242.adsl.proxad.net [82.255.60.242])
        (Authenticated sender: hadess@hadess.net)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 213FCE0004;
        Sun,  4 Oct 2020 12:17:06 +0000 (UTC)
Message-ID: <04e0af8618f95a4483f5a72ba90d4f8b1d9094bd.camel@hadess.net>
Subject: Re: [PATCH] Revert "Bluetooth: Update resolving list when updating
 whitelist"
From:   Bastien Nocera <hadess@hadess.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Sathish Narsimman <sathish.narasimman@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Date:   Sun, 04 Oct 2020 14:17:06 +0200
In-Reply-To: <20201004105124.GA2429@kroah.com>
References: <20201003135449.GA2691@kroah.com>
         <A1C95238-CBCB-4FD4-B46D-A62AED0C77E5@holtmann.org>
         <20201003160713.GA1512229@kroah.com>
         <AABC2831-4E88-41A2-8A20-1BFC88895686@holtmann.org>
         <20201004105124.GA2429@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.0 (3.38.0-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-10-04 at 12:51 +0200, Greg Kroah-Hartman wrote:
> On Sat, Oct 03, 2020 at 08:33:18PM +0200, Marcel Holtmann wrote:
> > Hi Greg,
> > 
> > > > > This reverts commit 0eee35bdfa3b472cc986ecc6ad76293fdcda59e2
> > > > > as it
> > > > > breaks all bluetooth connections on my machine.
> > > > > 
> > > > > Cc: Marcel Holtmann <marcel@holtmann.org>
> > > > > Cc: Sathish Narsimman <sathish.narasimman@intel.com>
> > > > > Fixes: 0eee35bdfa3b ("Bluetooth: Update resolving list when
> > > > > updating whitelist")
> > > > > Signed-off-by: Greg Kroah-Hartman
> > > > > <gregkh@linuxfoundation.org>
> > > > > ---
> > > > > net/bluetooth/hci_request.c | 41 ++--------------------------
> > > > > ---------
> > > > > 1 file changed, 2 insertions(+), 39 deletions(-)
> > > > > 
> > > > > This has been bugging me for since 5.9-rc1, when all
> > > > > bluetooth devices
> > > > > stopped working on my desktop system.  I finally got the time
> > > > > to do
> > > > > bisection today, and it came down to this patch.  Reverting
> > > > > it on top of
> > > > > 5.9-rc7 restored bluetooth devices and now my input devices
> > > > > properly
> > > > > work.
> > > > > 
> > > > > As it's almost 5.9-final, any chance this can be merged now
> > > > > to fix the
> > > > > issue?
> > > > 
> > > > can you be specific what breaks since our guys and I also think
> > > > the
> > > > ChromeOS guys have been testing these series of patches
> > > > heavily.
> > > 
> > > My bluetooth trackball does not connect at all.  With this
> > > reverted, it
> > > all "just works".
> > > 
> > > Same I think for a Bluetooth headset, can check that again if you
> > > really
> > > need me to, but the trackball is reliable here.
> > > 
> > > > When you run btmon does it indicate any errors?
> > > 
> > > How do I run it and where are the errors displayed?
> > 
> > you can do btmon -w trace.log and just let it run like tcdpump.
> 
> Ok, attached.
> 
> The device is not connecting, and then I open the gnome bluetooth
> dialog
> and it scans for devices in the area, but does not connect to my
> existing devices at all.
> 
> Any ideas?

Use bluetoothctl instead, the Bluetooth Settings from GNOME also run a
discovery the whole time the panel is opened, and this breaks a fair
number of poor quality adapters. This is worked-around in the most
recent version, but using bluetoothctl is a better debugging option in
all cases.

Cheers

