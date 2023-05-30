Return-Path: <netdev+bounces-6470-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC2F4716643
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:10:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D36D1C20D1A
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:10:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C035D23D77;
	Tue, 30 May 2023 15:09:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CA017AD4
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 15:09:27 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A2DBE;
	Tue, 30 May 2023 08:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ONi2LwfLt+xRG9bIQ5QSjdvNMAUWxk00n5O1GQIOnrk=; b=tDsBXVtnCAiKExB8uTsH5FcT1Q
	N6VzbZ20z+HfPZyq+Csfu4wFUvYbz+74B5mmuieLDkXAsjOtOcqCnOsCG2cbJLjSID7hFZCjusHzn
	wFrd23RMw7axitU8e+eBmCqugF75Pva+RCXnNESt/+vYfodWTHlhn3HzU740mFa7qLbcUlR9uaOJm
	hioXHpL7vy17P8XAcAZaEThGtYf0PZ/AA+FhqZAAIFOjagyKktqwQbPH6QIEUdbsrJ6Af9ywdh9ll
	R6gf/IQpkU9NVzxcD83jrZRG8ujwh40rbG+A1Oom9TgaIaFnXCqvuv/deTGm0zS4tZiuc2xhYeHwb
	DRdMIfag==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56642)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q40xt-000307-Ka; Tue, 30 May 2023 16:08:49 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q40xs-00088o-Ab; Tue, 30 May 2023 16:08:48 +0100
Date: Tue, 30 May 2023 16:08:48 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Lukasz Majewski <lukma@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>, Vivien Didelot <vivien.didelot@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC] net: dsa: slave: Advertise correct EEE capabilities at
 slave PHY setup
Message-ID: <ZHYRgIb6UCYq1n/Z@shell.armlinux.org.uk>
References: <20230530122621.2142192-1-lukma@denx.de>
 <ZHXzTBOtlPKqNfLw@shell.armlinux.org.uk>
 <20230530160743.2c93a388@wsk>
 <ZHYGv7zcJd/Ad4hH@shell.armlinux.org.uk>
 <35546c34-17a6-4295-b263-3f2a97d53b94@lunn.ch>
 <20230530164731.0b711649@wsk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530164731.0b711649@wsk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 04:47:31PM +0200, Lukasz Majewski wrote:
> Hi Andrew,
> 
> > > So, I'm wondering what's actually going on here... can you give
> > > any more details about the hardware setup?  
> > 
> > And what switch it actually is.
> 
> It is mv88e6071.
> 
> > I've not looked in too much detail,
> > but i think different switch families have different EEE capabilities.
> 
> Yes, some (like b53) have the ability to disable EEE in the HW.
> 
> The above one from Marvell seems to have EEE always enabled (in silicon)
> and the only possibility is to not advertise it [*].

Right, and that tells the remote end "we don't support EEE" so the
remote end should then disable EEE support.

Meanwhile the local MAC will _still_ signal LPI towards its PHY. I
have no idea whether the PHY will pass that LPI signal onwards to
the media in that case, or if it prevents entering low power mode.

It would be interesting to connect two of these switches together,
put a 'scope on the signals between the PHY and the media isolation
transformer, and see whether it's entering low power mode,
comparing when EEE is successfully negotiated vs not negotiated.

My suspicion would be that in the case where the MAC always signals
LPI to the PHY, the result of negotiation won't make a blind bit of
difference.

> > But in general, as Russell pointed out, there is no MAC support for
> > EEE in the mv88e6xxx driver.
> 
> I may be wrong, but aren't we accessing this switch PHYs via c45 ?
> (MDIO_MMD_PCS devices and e.g. MDIO_PCS_EEE_ABLE registers)?

As I've said - EEE is a MAC-to-MAC thing. The PHYs do the capability
negotiation and handle the media dependent part of EEE. However, it's
the MACs that signal to the PHY "I'm idle, please enter low power
mode" and when both ends that they're idle, the media link only then
drops into low power mode. This is the basic high-level operation of
EEE in an 802.3 compliant system.

As I've also said, there are PHYs out there which do their own thing
as an "enhancement" to allow MACs that aren't EEE capable to gain
*some* of the power savings from EEE (and I previously noted one
such example.)

The PHY EEE configuration is always done via Clause 45 - either through
proper clause 45 cycles on the MDIO bus, or through the MMD access
through a couple of clause 22 registers. There aren't the registers in
the clause 22 address space for EEE.

The MDIO_PCS_EEE_ABLE registers describe what the capabilities of the
PHY is to the management software (in this case phylib). These are not
supposed to change. The advertisements are programmed via the
autonegotiation MMD register set. There's some additional configuration
bits in the PHY which control whether the clock to the MAC is stopped
when entering EEE low-power mode.

However, even with all that, the MAC is still what is involved in
giving the PHY permission to enter EEE low-power mode.

The broad outline sequence in an 802.3 compliant setup is:

- Whenever the MAC sends a packet, it resets the LPI timer.
- When LPI timer expires, MAC signals to PHY that it can enter
  low-power mode.
- When the PHY at both ends both agree that they have permission from
  their respective MACs to enter low power mode, they initiate the
  process to put the media into low power mode.
- If the PHY has been given permission from management software to stop
  clock, the PHY will stop the clock to the MAC.
- When the MAC has a packet to send, the MAC stops signalling low-power
  mode to the PHY.
- The PHY restores the clock if it was stopped, and wakes up the link,
  thereby causing the remote PHY to also wake up.
- Normal operation resumes.

802.3 EEE is not a PHY-to-PHY thing, it's MAC-to-MAC.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

