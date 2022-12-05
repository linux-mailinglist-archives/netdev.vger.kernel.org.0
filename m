Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 436DD64269D
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 11:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbiLEKWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 05:22:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbiLEKWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 05:22:23 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A01192A0
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 02:22:21 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1p28bz-0001Qv-C5; Mon, 05 Dec 2022 11:22:11 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1p28bx-0005bw-DV; Mon, 05 Dec 2022 11:22:09 +0100
Date:   Mon, 5 Dec 2022 11:22:09 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/4] net/ethtool: add netlink interface for
 the PLCA RS
Message-ID: <20221205102209.GA17619@pengutronix.de>
References: <fc3ac4f2d0c28d9c24b909e97791d1f784502a4a.1670204277.git.piergiorgio.beruto@gmail.com>
 <20221205060057.GA10297@pengutronix.de>
 <Y43CDqAjvlAfLK1v@gvm01>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y43CDqAjvlAfLK1v@gvm01>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 11:03:58AM +0100, Piergiorgio Beruto wrote:
> Hello Oleksij, and thank you for your review!
> Please see my comments below.
> 
> On Mon, Dec 05, 2022 at 07:00:57AM +0100, Oleksij Rempel wrote:
> > > diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
> > > index aaf7c6963d61..81e3d7b42d0f 100644
> > > --- a/include/uapi/linux/ethtool_netlink.h
> > > +++ b/include/uapi/linux/ethtool_netlink.h
> > > @@ -51,6 +51,9 @@ enum {
> > >  	ETHTOOL_MSG_MODULE_SET,
> > >  	ETHTOOL_MSG_PSE_GET,
> > >  	ETHTOOL_MSG_PSE_SET,
> > > +	ETHTOOL_MSG_PLCA_GET_CFG,
> > > +	ETHTOOL_MSG_PLCA_SET_CFG,
> > > +	ETHTOOL_MSG_PLCA_GET_STATUS,
> > >  
> > >  	/* add new constants above here */
> > >  	__ETHTOOL_MSG_USER_CNT,
> > > @@ -97,6 +100,9 @@ enum {
> > >  	ETHTOOL_MSG_MODULE_GET_REPLY,
> > >  	ETHTOOL_MSG_MODULE_NTF,
> > >  	ETHTOOL_MSG_PSE_GET_REPLY,
> > > +	ETHTOOL_MSG_PLCA_GET_CFG_REPLY,
> > > +	ETHTOOL_MSG_PLCA_GET_STATUS_REPLY,
> > > +	ETHTOOL_MSG_PLCA_NTF,
> > >  
> > >  	/* add new constants above here */
> > >  	__ETHTOOL_MSG_KERNEL_CNT,
> > > @@ -880,6 +886,25 @@ enum {
> > >  	ETHTOOL_A_PSE_MAX = (__ETHTOOL_A_PSE_CNT - 1)
> > >  };
> > >  
> > > +/* PLCA */
> > > +
> > 
> > Please use names used in the specification as close as possible and
> > document in comments real specification names.
> I was actually following the names in the OPEN Alliance SIG
> specifications which I referenced. Additionally, the OPEN names are more
> similar to those that you can find in Clause 147. As I was trying to
> explain in other threads, the names in Clause 30 were sort of a workaround
> because we were not allowed to add registers in Clause 45.
> 
> I can change the names if you really want to, but I'm inclined to keep
> it simple and "user-friendly". People using this technology are more
> used to these names, and they totally ignore Clause 30.
> 
> Please, let me know what you think.

A comment about name mapping to specification, spec version and reason
to take one variants instead of other one will be enough Somewhat similar to
what i did for PoDL. See ETHTOOL_A_PODL_* in
Documentation/networking/ethtool-netlink.rst and include/uapi/linux/ethtool.h

It will help people who use spec to review or extend this UAPI. 

> > > +
> > > +	/* add new constants above here */
> > > +	__ETHTOOL_A_PLCA_CNT,
> > > +	ETHTOOL_A_PLCA_MAX = (__ETHTOOL_A_PLCA_CNT - 1)
> > > +};
> > 
> > Should we have access to 30.16.1.2.2 acPLCAReset in user space?
> I omitted that parameter on purpose. The reason is that again, we were
> "forced" to do this in IEEE802.3cg, but it was a poor choice. I
> understand purity of the specifications, but in the real-world where
> PLCA is implemented in the PHY, resetting the PLCA layer independently
> of the PCS/PMA is all but a good idea: it does more harm than good. As a
> matter of fact, PHY vendors typically map the PLCA reset bit to the PHY
> soft reset bit, or at least to the PCS reset bit.
> 
> I'm inclined to keep this as-is and see in the future if and why someone
> would need this feature. What you think?

Ok. Sounds good.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
