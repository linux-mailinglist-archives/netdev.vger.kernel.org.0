Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9C23BBA1E
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 11:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbhGEJZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 05:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbhGEJZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 05:25:47 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0370FC061574
        for <netdev@vger.kernel.org>; Mon,  5 Jul 2021 02:23:11 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1m0Koi-0004St-Ld; Mon, 05 Jul 2021 11:23:04 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1m0Koh-0004hF-Ib; Mon, 05 Jul 2021 11:23:03 +0200
Date:   Mon, 5 Jul 2021 11:23:03 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Brian Norris <briannorris@chromium.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 04/24] rtw89: add debug files
Message-ID: <20210705092303.v37xayrsqt2ilciz@pengutronix.de>
References: <20210618064625.14131-1-pkshih@realtek.com>
 <20210618064625.14131-5-pkshih@realtek.com>
 <20210702072308.GA4184@pengutronix.de>
 <CA+ASDXNjHJoXgRAM4E7TcLuz9zBmQkaBMuhK2DEVy3dnE-3XcA@mail.gmail.com>
 <20210702175740.5cdhmfp4ldiv6tn7@pengutronix.de>
 <87k0m5i3o8.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87k0m5i3o8.fsf@codeaurora.org>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:18:17 up 214 days, 23:24, 48 users,  load average: 0.08, 0.10,
 0.08
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 05, 2021 at 11:08:07AM +0300, Kalle Valo wrote:
> Oleksij Rempel <o.rempel@pengutronix.de> writes:
> 
> > On Fri, Jul 02, 2021 at 10:08:53AM -0700, Brian Norris wrote:
> >> On Fri, Jul 2, 2021 at 12:23 AM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
> >> > On Fri, Jun 18, 2021 at 02:46:05PM +0800, Ping-Ke Shih wrote:
> >> > > +#ifdef CONFIG_RTW89_DEBUGMSG
> >> > > +unsigned int rtw89_debug_mask;
> >> > > +EXPORT_SYMBOL(rtw89_debug_mask);
> >> > > +module_param_named(debug_mask, rtw89_debug_mask, uint, 0644);
> >> > > +MODULE_PARM_DESC(debug_mask, "Debugging mask");
> >> > > +#endif
> >> >
> >> >
> >> > For dynamic debugging we usually use ethtool msglvl.
> >> > Please, convert all dev_err/warn/inf.... to netif_ counterparts
> >> 
> >> Have you ever looked at a WiFi driver?
> >
> > Yes. You can parse the kernel log for my commits.
> >
> >> I haven't seen a single one that uses netif_*() for logging.
> >> On the other hand, almost every
> >> single one has a similar module parameter or debugfs knob for enabling
> >> different types of debug messages.
> >> 
> >> As it stands, the NETIF_* categories don't really align at all with
> >> the kinds of message categories most WiFi drivers support. Do you
> >> propose adding a bunch of new options to the netif debug feature?
> >
> > Why not? It make no sense or it is just "it is tradition, we never do
> > it!" ? 
> >
> > Even dynamic printk provide even more granularity. So module parameter looks
> > like stone age against all existing possibilities.
> 
> I'm all for improving wireless driver debugging features, but let's
> please keep that as a separate thread from reviewing new drivers. I
> think there are 4-5 new drivers in the queue at the moment so to keep
> all this manageable let's have the review process as simple as possible,
> please.

Ok, there is enough work to do.

> Using a module parameter for setting the debug mask is a standard
> feature in wireless drivers so it shouldn't block rtw89. If we want a
> generic debug framework for wireless drivers, an rfc patch for an
> existing upstream wireless driver is a good way to get that discussion
> forward.

Ok, sounds good.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
