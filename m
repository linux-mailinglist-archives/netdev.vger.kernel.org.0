Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD8E91374FC
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 18:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbgAJRi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 12:38:57 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45252 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgAJRi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 12:38:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Y7V9x1rxcJN0/N2QQA+GdUY1uWXlgWareYZljTBcMZQ=; b=QXvaqUgsVlHzIT3sbyJKm+Wqy
        UY3ow3kgHd6moWkUfpsPoCoSuiGJHKdsEH+8fIMfHYMG1n2AeBUuofD3MCdRDLIb5tHDehjyyNPZt
        Lb8lhrwwoBXFH2mY7vbihBqukOlUumzkKzCMSOZhMVmw6BdWR8z4JA/NwtQcRCOl1Nvaywe2brqsF
        n576mEsOSIEcQtdjyzfDtQcS9tX2qr9uQRhfVdgQSRV50o1LHcCXox1FUKzck2LNrM9X1byUO9vGk
        LiM8SEmsGlTWl75BnfobPy0f6iY5xUqhzIpu+zNIGaEDKZO+sV6zy1ZSZABb79S5+H1CfouGy0GIh
        aqf0sNH/Q==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:60700)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ipyFI-0004aT-Qp; Fri, 10 Jan 2020 17:38:52 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ipyFH-0001h2-P4; Fri, 10 Jan 2020 17:38:51 +0000
Date:   Fri, 10 Jan 2020 17:38:51 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     =?utf-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: [drivers/net/phy/sfp] intermittent failure in state machine
 checks
Message-ID: <20200110173851.GJ25745@shell.armlinux.org.uk>
References: <20200110114433.GZ25745@shell.armlinux.org.uk>
 <7b6f143a-7bdb-90be-00f6-9e81e21bde4e@gmx.net>
 <20200110125305.GB25745@shell.armlinux.org.uk>
 <b4b94498-5011-1e89-db54-04916f8ef846@gmx.net>
 <20200110150955.GE25745@shell.armlinux.org.uk>
 <e9a99276-c09d-fa8d-a280-fca2abac6602@gmx.net>
 <20200110163235.GG25745@shell.armlinux.org.uk>
 <717229a4-f7f6-837d-3d58-756b516a8605@gmx.net>
 <20200110170836.GI25745@shell.armlinux.org.uk>
 <12956566-4aa3-2c5d-be1a-8612edab3b3d@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <12956566-4aa3-2c5d-be1a-8612edab3b3d@gmx.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 05:19:35PM +0000, ѽ҉ᶬḳ℠ wrote:
> 
> On 10/01/2020 17:08, Russell King - ARM Linux admin wrote:
> > On Fri, Jan 10, 2020 at 04:53:06PM +0000, ѽ҉ᶬḳ℠ wrote:
> > > Seems that the debug avenue has been exhausted, short of running SFP.C in
> > > debug mode.
> > You're saying you never see TX_FAULT asserted other than when the
> > interface is down?
> 
> Yes, it never exhibits once the iif is up - it is rock-stable in that state,
> only ever when being transitioned from down state to up state.
> Pardon, if that has not been made explicitly clear previously.

I think if we were to have SFP debug enabled, you'll find that
TX_FAULT is being reported to SFP as being asserted.

You probably aren't running that while loop, as it will exit when
it sees TX_FAULT asserted.  So, here's another bit of shell code
for you to run:

ip li set dev eth2 down; \
ip li set dev eth2 up; \
date
while :; do
  cat /proc/uptime
  while ! grep -A5 'tx-fault.*in  hi' /sys/kernel/debug/gpio; do :; done
  cat /proc/uptime
  while ! grep -A5 'tx-fault.*in  lo' /sys/kernel/debug/gpio; do :; done
done

This will give you output such as:

Fri 10 Jan 17:31:06 GMT 2020
774869.13 1535859.48
 gpio-509 (                    |tx-fault            ) in  hi ...
774869.14 1535859.49
 gpio-509 (                    |tx-fault            ) in  lo ...
774869.15 1535859.50

The first date and "uptime" output is the timestamp when the interface
was brought up.  Subsequent "uptime" outputs can be used to calculate
the time difference in seconds between the state printed immediately
prior to the uptime output, and the first "uptime" output.

So in the above example, the tx-fault signal was hi at 10ms, and then
went low 20ms after the up.

However, bear in mind that even this will not be good enough to spot
transitory changes on TX_FAULT - as your I2C GPIO expander is interrupt
capable, watching /proc/interrupts may tell you more.

If the TX_FAULT signal is as stable as you claim it is, you should see
the interrupt count for it remaining the same.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
