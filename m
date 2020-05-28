Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCAAE1E5D27
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 12:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387807AbgE1K2s convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 28 May 2020 06:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387740AbgE1K2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 06:28:47 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2569C05BD1E
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 03:28:47 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jeFmH-0002fj-KK; Thu, 28 May 2020 12:28:45 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jeFmH-0006JE-8T; Thu, 28 May 2020 12:28:45 +0200
Date:   Thu, 28 May 2020 12:28:45 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Petr Machata <petrm@mellanox.com>
Cc:     Amit Cohen <amitc@mellanox.com>, "andrew@lunn.ch" <andrew@lunn.ch>,
        mlxsw <mlxsw@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Link down reasons
Message-ID: <20200528102845.yvcq4bihqdedc3li@pengutronix.de>
References: <AM0PR0502MB38261D4F4F7A3BB5E0FDCD10D7B10@AM0PR0502MB3826.eurprd05.prod.outlook.com>
 <20200528084052.n7yeo2nu2vq4eibv@pengutronix.de>
 <87y2pctnvc.fsf@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <87y2pctnvc.fsf@mellanox.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:24:15 up 195 days,  1:42, 196 users,  load average: 0.89, 0.51,
 0.31
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 11:22:47AM +0200, Petr Machata wrote:
> 
> Oleksij Rempel <o.rempel@pengutronix.de> writes:
> 
> > I would add some more reasons:
> > - master slave resolution issues: both link partners are master or
> >   slave.
> 
> I guess we should send the RFC, so that we can talk particulars. We
> currently don't have anything like master/slave mismatch in the API, but
> that's just because our FW does not report this. The idea is that if MAC
> and/or PHY driver can't express some fail using the existing codes, it
> creates a new one.

ok

> > - signal quality drop. In this case driver should be extended to notify
> >   the system if SQI is under some configurable limit.
> 
> As SQI goes down, will the PHY driver eventually shut down the port?

Not in current implementation. But it is possible at least with
nxp_tja11xx PHY.

> Because if yes, that's exactly the situation when it would later report,
> yeah, the link is down because SQI was rubbish. In the proposed API, we
> would model this as "signal integrity issue", with a possible subreason
> of "low SQI", or something along those lines.
> 
> E.g., mlxsw can report module temperatures. But whether the port goes
> down is a separate mechanism. So when a port is down, the driver can
> tell you, yeah, it is down, because it was overheated. And separate from
> that you can check the module temperatures. SQI might be a similar
> issue.

nxp_tja11xx can go down or can't go up on under vlotage or over temerature
error. So, I assume this are two more possible link-down reasons.


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
