Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F613BB9E2
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 11:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbhGEJMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 05:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbhGEJMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 05:12:13 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B29C061574
        for <netdev@vger.kernel.org>; Mon,  5 Jul 2021 02:09:36 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1m0Kbe-0002JL-8S; Mon, 05 Jul 2021 11:09:34 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1m0Kbd-0003q2-CK; Mon, 05 Jul 2021 11:09:33 +0200
Date:   Mon, 5 Jul 2021 11:09:33 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Pkshih <pkshih@realtek.com>
Cc:     Brian Norris <briannorris@chromium.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 04/24] rtw89: add debug files
Message-ID: <20210705090933.yasowqdel4ifnjgl@pengutronix.de>
References: <20210618064625.14131-1-pkshih@realtek.com>
 <20210618064625.14131-5-pkshih@realtek.com>
 <20210702072308.GA4184@pengutronix.de>
 <CA+ASDXNjHJoXgRAM4E7TcLuz9zBmQkaBMuhK2DEVy3dnE-3XcA@mail.gmail.com>
 <20210702175740.5cdhmfp4ldiv6tn7@pengutronix.de>
 <CA+ASDXP0_Y1x_1OixJFWDCeZX3txV+xbwXcXfTbw1ZiGjSFiCQ@mail.gmail.com>
 <f74caecfafa6479abe09bede01e801ec@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f74caecfafa6479abe09bede01e801ec@realtek.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:08:57 up 214 days, 23:15, 48 users,  load average: 0.23, 0.16,
 0.06
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 05, 2021 at 08:58:51AM +0000, Pkshih wrote:
> 
> > -----Original Message-----
> > From: Brian Norris [mailto:briannorris@chromium.org]
> > Sent: Saturday, July 03, 2021 2:38 AM
> > To: Oleksij Rempel
> > Cc: Pkshih; Kalle Valo; linux-wireless; <netdev@vger.kernel.org>; Sascha Hauer
> > Subject: Re: [PATCH 04/24] rtw89: add debug files
> > 
> > On Fri, Jul 2, 2021 at 10:57 AM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
> > > On Fri, Jul 02, 2021 at 10:08:53AM -0700, Brian Norris wrote:
> > > > On Fri, Jul 2, 2021 at 12:23 AM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
> > > > > For dynamic debugging we usually use ethtool msglvl.
> > > > > Please, convert all dev_err/warn/inf.... to netif_ counterparts
> > > >
> > > > Have you ever looked at a WiFi driver?
> > >
> > > Yes. You can parse the kernel log for my commits.
> > 
> > OK! So I see you've touched a lot of ath9k, >3 years ago. You might
> > notice that it is one such example -- it supports exactly the same
> > kind of debugfs file, with a set of ath_dbg() log types. Why doesn't
> > it use this netif debug logging?
> > 
> > > > I haven't seen a single one that uses netif_*() for logging.
> > > > On the other hand, almost every
> > > > single one has a similar module parameter or debugfs knob for enabling
> > > > different types of debug messages.
> > > >
> > > > As it stands, the NETIF_* categories don't really align at all with
> > > > the kinds of message categories most WiFi drivers support. Do you
> > > > propose adding a bunch of new options to the netif debug feature?
> > >
> > > Why not? It make no sense or it is just "it is tradition, we never do
> > > it!" ?
> > 
> > Well mainly, I don't really like people dreaming up arbitrary rules
> > and enforcing them only on new submissions. If such a change was
> > Recommended, it seems like a better first step would be to prove that
> > existing drivers (where there are numerous examples) can be converted
> > nicely, instead of pushing the work to new contributors arbitrarily.
> > Otherwise, the bar for new contributions gets exceedingly high -- this
> > one has already sat for more than 6 months with depressingly little
> > useful feedback.
> > 
> > I also know very little about this netif log level feature, but if it
> > really depends on ethtool (seems like it does?) -- I don't even bother
> > installing ethtool on most of my systems. It's much easier to poke at
> > debugfs, sysfs, etc., than to construct the relevant ethtool ioctl()s
> > or netlink messages. It also seems that these debug knobs can't be set
> > before the driver finishes coming up, so one would still need a module
> > parameter to mirror some of the same features. Additionally, a WiFi
> > driver doesn't even have a netdev to speak of until after a lot of the
> > interesting stuff comes up (much of the mac80211 framework focuses on
> > a |struct ieee80211_hw| and a |struct wiphy|), so I'm not sure your
> > suggestion really fits these sorts of drivers (and the things they
> > might like to support debug-logging for) at all.
> > 
> > Anyway, if Ping-Ke wants to paint this bikeshed for you, I won't stop him.
> 
> I encounter the problems you mentioned mostly:
> 1. no netdev to be the parameter 'dev' of 'netif_dbg(priv, type, dev, format, args...)'
> 2. predefined 'type' isn't enough for wifi application. There're many wifi- or vendor-
>    specific components, such as RF calibration, BT coexistence, DIG, CFO and so on.
> 
> So, I don't plan to change them for now.

OK, understand.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
