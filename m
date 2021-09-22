Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6C1415160
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 22:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237595AbhIVU21 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 22 Sep 2021 16:28:27 -0400
Received: from mailer.bingner.com ([64.62.210.4]:8645 "EHLO mail.bingner.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237381AbhIVU2Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 16:28:25 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Sep 2021 16:28:25 EDT
Received: from EX01.ds.sbdhi.com (2001:470:3c:1::21) by EX01.ds.sbdhi.com
 (2001:470:3c:1::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.10; Wed, 22 Sep
 2021 10:11:52 -1000
Received: from EX01.ds.sbdhi.com ([fe80::44d3:ef59:fdca:d83]) by
 EX01.ds.sbdhi.com ([fe80::44d3:ef59:fdca:d83%3]) with mapi id 15.01.2242.010;
 Wed, 22 Sep 2021 10:11:52 -1000
From:   Sam Bingner <sam@bingner.com>
To:     Oliver Neukum <oneukum@suse.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Martin Habets <mhabets@solarflare.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matti Vuorela <matti.vuorela@bitfactor.fi>,
        Jakub Kicinski <kuba@kernel.org>,
        "Yves-Alexis Perez" <corsac@corsac.net>
Subject: RE: [PATCH] usbnet: ipheth: fix connectivity with iOS 14
Thread-Topic: [PATCH] usbnet: ipheth: fix connectivity with iOS 14
Thread-Index: AQHXCROd8ZjcASMffkmnvxDkK/JoLKuxyU/A
Date:   Wed, 22 Sep 2021 20:11:52 +0000
Message-ID: <79d05aaa5052408897aeb8039c6a1582@bingner.com>
References: <370902e520c44890a44cb5dd0cb1595f@bingner.com>
 <d61ad9565e29a07086e52bc984e8e629285ff8cf.camel@suse.com>
In-Reply-To: <d61ad9565e29a07086e52bc984e8e629285ff8cf.camel@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.150.132.238]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry I didn't have time to research this further to prove it was a regression - but there is now somebody else who has done so and created a patch.  I thought it might be good to give a link to it to you guys.  It caused problems on all iOS versions AFAIK.  The patch and discussion is available at:

https://github.com/openwrt/openwrt/pull/4084

Sam

-----Original Message-----
From: Oliver Neukum <oneukum@suse.com> 
Sent: Monday, February 22, 2021 2:10 AM
To: Sam Bingner <sam@bingner.com>; linux-usb@vger.kernel.org
Cc: David S. Miller <davem@davemloft.net>; Martin Habets <mhabets@solarflare.com>; Luc Van Oostenryck <luc.vanoostenryck@gmail.com>; Shannon Nelson <snelson@pensando.io>; Michael S. Tsirkin <mst@redhat.com>; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Matti Vuorela <matti.vuorela@bitfactor.fi>; Jakub Kicinski <kuba@kernel.org>; Yves-Alexis Perez <corsac@corsac.net>
Subject: Re: [PATCH] usbnet: ipheth: fix connectivity with iOS 14

Am Sonntag, den 21.02.2021, 10:42 +0000 schrieb Sam Bingner:
> There seems to be a problem with this patch:
> 
> Whenever the iPhone sends a packet to the tethered device that is 1500 bytes long, it gets the error "ipheth 1-1:4.2: ipheth_rcvbulk_callback: urb status: -79" on the connected device and stops passing traffic.  I am able to bring it back up by shutting and unshutting the interface, but the same thing happens very quickly.   I noticed that this patch dropped the max USB packet size from 1516 to 1514 bytes, so I decided to try lowering the MTU to 1498; this made the connection reliable and no more errors occurred.
> 
> It appears to me that the iPhone is still sending out 1516 bytes over USB for a 1500 byte packet and this patch makes USB abort when that happens?  I could duplicate reliably by sending a ping from the iphone (ping -s 1472) to the connected device, or vice versa as the reply would then break it.
> 
> I apologize if this reply doesn't end up where it should - I tried to reply to the last message in this thread but I wasn't actually *on* the thread so I had to just build it as much as possible myself.

Is this a regression? Does it work after reverting the patch? Which version of iOS?

	Regards
		Oliver


