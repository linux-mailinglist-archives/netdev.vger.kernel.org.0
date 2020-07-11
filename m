Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79BA921C533
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 18:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbgGKQXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 12:23:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58598 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728441AbgGKQXx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jul 2020 12:23:53 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1juII1-004dcq-1V; Sat, 11 Jul 2020 18:23:49 +0200
Date:   Sat, 11 Jul 2020 18:23:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Rowe <martin.p.rowe@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        vivien.didelot@gmail.com, linux@armlinux.org.uk
Subject: Re: bug: net: dsa: mv88e6xxx: unable to tx or rx with Clearfog GT 8K
 (with git bisect)
Message-ID: <20200711162349.GL1014141@lunn.ch>
References: <CAOAjy5T63wDzDowikwZXPTC5fCnPL1QbH9P1v+MMOfydegV30w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOAjy5T63wDzDowikwZXPTC5fCnPL1QbH9P1v+MMOfydegV30w@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 11, 2020 at 01:50:21PM +0000, Martin Rowe wrote:
> Hello,
> 
> I hope this is the right forum.
> 
> I have been troubleshooting an issue with my Clearfog GT 8Ks where I
> am unable to tx or rx on the switch interface, which uses the
> mv88e6xxx driver. Based on git bisect, I believe it is related to
> commit 34b5e6a33c1a8e466c3a73fd437f66fb16cb83ea from around the
> 5.7-rc2 era.

Hi Martin

Thanks for the bug report.

> Symptoms:
> The interface used to work, then it stopped and I didn't immediately
> notice because of life. Now the network never comes fully up. dmesg
> indicates no issues bringing the device up. Links are brought up and
> down with cable connects and disconnects. Negotiation seems to be
> working. But the interface rx counter never increases. While the tx
> counters do increase, tcpdumps on the other end of the cables never
> see any traffic. Basically, it doesn't look like any traffic is going
> out or in.

So i'm guessing it is the connection between the CPU and the switch.
Could you confirm this? Create a bridge, add two ports of the switch
to the bridge, and then see if packets can pass between switch ports.

If it is the connection between the CPU and the switch, i would then
be thinking about the comphy and the firmware. We have seen issues
where the firmware is too old. That is not something i've debugged
myself, so i don't know where the version information is, or what
version is required.

	Andrew
