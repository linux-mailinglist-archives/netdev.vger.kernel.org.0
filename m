Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF8922DE18
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 13:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgGZLBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 07:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgGZLBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 07:01:12 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1613FC0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 04:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:To:From:Date:Reply-To:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ulY2I+IdqsiikALX6t9mqEgCi59mweIpsrnoUGV7vPk=; b=eZlM5gI+2y2YxuJRJU2LaUN0B
        WoL1R3rBCxJlAhJG2EdgtKwk9hosrdtevOvvV5AB2mWwTJ1qDM0aLSU2kdtkN/cpBZTIPgzHY5fWx
        I637D6Rh0KrKxI+H6SgQRpepRNzRsjg6+bc4c64QAPwxZ6b8aV+jZDGgNZJKHuueFMANNJvqt1DGz
        1ZpW8vBV9pNhIxZqlQHdLJ76BzHW3sn4SPpn6dfnHAaGCXS8iVTLHQzknjv6O4qVdoNOBT0CPu/Zo
        d+jCuanblBc7TKl8Ex0ktIScY/tnVdkMAQoiyTYS2j3FiqwqgV1aMyygZoz7ZAd91r/e4Zr8vOPSc
        ngufVqEzw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44352)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jzeOv-0001ez-Ii; Sun, 26 Jul 2020 12:01:05 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jzeOv-0002bM-2m; Sun, 26 Jul 2020 12:01:05 +0100
Date:   Sun, 26 Jul 2020 12:01:05 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: phc2sys - does it work?
Message-ID: <20200726110104.GV1605@shell.armlinux.org.uk>
References: <20200725124927.GE1551@shell.armlinux.org.uk>
 <20200725132916.7ibhnre2be3hfsrt@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200725132916.7ibhnre2be3hfsrt@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 25, 2020 at 04:29:16PM +0300, Vladimir Oltean wrote:
> Just a sanity check: do you have this patch?
> https://github.com/richardcochran/linuxptp/commit/e0580929f451e685d92cd10d80b76f39e9b09a97

I did not, as I was running Debian stable's 1.9.2 version, whereas
current git head for linuxptp appears to behave much better.  Thanks.

I've got to the bottom of stuff like:

phc2sys[7190.912]: /dev/ptp1 sys offset        81 s2 freq  -71290 delay    641
phc2sys[7191.912]: /dev/ptp1 sys offset        66 s2 freq  -71281 delay    640
phc2sys[7192.912]: /dev/ptp1 sys offset      -926 s2 freq  -72253 delay    640
phc2sys[7193.912]: /dev/ptp1 sys offset     -8124 s2 freq  -79729 delay    680
phc2sys[7194.912]: /dev/ptp1 sys offset     -7794 s2 freq  -81836 delay    641
phc2sys[7195.913]: /dev/ptp1 sys offset     -5355 s2 freq  -81735 delay    680
phc2sys[7196.913]: /dev/ptp1 sys offset     -2994 s2 freq  -80981 delay    680
phc2sys[7197.913]: /dev/ptp1 sys offset     -1336 s2 freq  -80221 delay    640
phc2sys[7198.913]: /dev/ptp1 sys offset      -422 s2 freq  -79708 delay    640
phc2sys[7199.913]: /dev/ptp1 sys offset        -9 s2 freq  -79421 delay    680
phc2sys[7200.913]: /dev/ptp1 sys offset       159 s2 freq  -79256 delay    640
phc2sys[7201.913]: /dev/ptp1 sys offset       211 s2 freq  -79156 delay    680

This is due to NTP.  Each NTP period (starting at 64s), ntpd updates
the kernel timekeeping variables with the latest information.  One of
these is the offset, which is applied to the kernel's timekeeping by
adjusting the length of a tick:

        /* Compute the phase adjustment for the next second */
        tick_length      = tick_length_base;

        delta            = ntp_offset_chunk(time_offset);
        time_offset     -= delta;
        tick_length     += delta;

This has the effect of slightly changing the length of a second to slew
small adjustments, which appears as a change of frequency compared to
the PTP clock.  As we progress through the NTP period, the amount of
adjustment is reduced (notice that time_offset is reduced.)  When
time_offset hits zero, then no further adjustment is made, and the rate
that the kernel time passes settles - and in turn phc2sys settles to
a stable "freq" figure.

What this means is that synchronising the PTP clock to the kernel time
on a second by second basis exposes the PTP clock to these properties
of the kernel NTP loop, which has the effect of throwing the PTP clock
off by a 10s of PPM.

One way around this would be to synchronise the PTP clock updates with
NTP updates, but that is difficult due to NTP selecting how often it
does its updates - it generally starts off at 64s, and the interval
increases through powers of two.  However, just specifying -R to
phc2sys does not give better results - the amount that the PTP clock
fluctuates just gets larger.

Another solution would be to avoid running NTP on any machine intending
to be the source of PTP time on a network, but that then brings up the
problem that you can't synchronise the PTP time source to a reference
time, which rather makes PTP pointless unless all that you're after is
"all my local machines say the same wrong time."

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
