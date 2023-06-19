Return-Path: <netdev+bounces-12055-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E2A3735D53
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 20:11:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F54F281197
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 18:11:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB29514273;
	Mon, 19 Jun 2023 18:11:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F67013AF9
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 18:11:10 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A79127
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 11:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=TsAvA8o7PjsjYprCgGFlOZMQBXJ360yXZQT0JrbVSXg=; b=kFXA3AYRCUHnhCjgQyKHvJtBhX
	lu/Y3S94XskRqpHCHSZJxDCD/vQPkbIuLnOUWXO0+hjUl4pWFp/EznhE2rhX/Pv+v0uy/G2e0JmHm
	yABLH+Y+kT31lfUj6RHMyZajlPgZKkNjdBYPAODMC8HwoVVTcyn557dARA1A7pwr7BtWtaKHt2jZX
	WwjRGGyC1qRwh3PdsZuhL/gHuUbbFfaoCqHdjcrqdtbm8kqvxG1k2AJGDt8fd8nwNafDqEnsHIJBn
	1I2rXwJntzZaQ8YWQHPlwMtLJjbozNsxxUNfGJvga8NnA7jjJmcTzckF5UGFy2MK0SeI2hyDCjrgM
	bSg0wsUA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55088)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1qBJLF-000099-Gb; Mon, 19 Jun 2023 19:11:05 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1qBJLE-0005sN-2K; Mon, 19 Jun 2023 19:11:04 +0100
Date: Mon, 19 Jun 2023 19:11:04 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Simon Horman <simon.horman@corigine.com>
Cc: Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
	ansuelsmth@gmail.com, Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v0 2/3] net: phy: phy_device: Call into the PHY
 driver to set LED offload
Message-ID: <ZJCaODPt5cJVZqTf@shell.armlinux.org.uk>
References: <20230618173937.4016322-1-andrew@lunn.ch>
 <20230618173937.4016322-2-andrew@lunn.ch>
 <ZJBjtWTtDqsyWPXE@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJBjtWTtDqsyWPXE@corigine.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 19, 2023 at 04:18:29PM +0200, Simon Horman wrote:
> On Sun, Jun 18, 2023 at 07:39:36PM +0200, Andrew Lunn wrote:
> > Linux LEDs can be requested to perform hardware accelerated blinking
> > to indicate link, RX, TX etc. Pass the rules for blinking to the PHY
> > driver, if it implements the ops needed to determine if a given
> > pattern can be offloaded, to offload it, and what the current offload
> > is. Additionally implement the op needed to get what device the LED is
> > for.
> > 
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> 
> ...
> 
> > diff --git a/include/linux/phy.h b/include/linux/phy.h
> > index 11c1e91563d4..1db63fb905c5 100644
> > --- a/include/linux/phy.h
> > +++ b/include/linux/phy.h
> > @@ -1104,6 +1104,20 @@ struct phy_driver {
> >  	int (*led_blink_set)(struct phy_device *dev, u8 index,
> >  			     unsigned long *delay_on,
> >  			     unsigned long *delay_off);
> > +	/* Can the HW support the given rules. Return 0 if yes,
> > +	 * -EOPNOTSUPP if not, or an error code.
> > +	 */
> > +	int (*led_hw_is_supported)(struct phy_device *dev, u8 index,
> > +				   unsigned long rules);
> > +	/* Set the HW to control the LED as described by rules. */
> > +	int (*led_hw_control_set)(struct phy_device *dev, u8 index,
> > +				  unsigned long rules);
> > +	/* Get the rules used to describe how the HW is currently
> > +	 * configure.
> > +	 */
> > +	int (*led_hw_control_get)(struct phy_device *dev, u8 index,
> > +				  unsigned long *rules);
> > +
> 
> Hi Andrew,
> 
> for consistency it would be nice if the comments for
> the new members above was in kernel doc format.

Unfortunately, kerneldoc doesn't understand structures-of-function-
pointers, so one can't document each operation and its parameters
without playing games such as I've done in linux/phylink.h. It involves
listing the prototypes not as function pointers but as normal function
prototypes in a #if 0..#endif section and preceeding each with a
kerneldoc comment describing the function and its parameters in the
normal way.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

