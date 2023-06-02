Return-Path: <netdev+bounces-7486-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D72E720740
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:18:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 96E571C211B3
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:18:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 540421C75F;
	Fri,  2 Jun 2023 16:18:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497541C758
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 16:18:09 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49390E40
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 09:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=u7cun0H59yCApyhyXwsrgbyJ1bHtB7pjH1rhSHjse8I=; b=Z0QOOeR1YSm53aeXJa0XUsdwlI
	0hcbNNL1B2YfQKzA/urVQH8QzeR5RuUd9wdPokGQb4Bcb5QrfUA2DpfA3GUjvGNsBGEyuewSWsdeM
	eAqK0xvYvOK8/p5p0Hw9nej92Vye+U2AU6eJ7bABgvWeW6iYM0jFOjFS0VG6KM005cAe2Uudi5ZSS
	IjNayK8Mv0OdZIXmiq6I2z6HPDeGuBdluubkjBtwK52bO1l+Op/110ItFNqyPoVqez3sqeKapGnCj
	bZg/VVcntf18bc2GvAPSjUPvqoXYObFM6NfxwJ8hdkWJxlYNvjF+un4xwnveRm6twuDdBzT93XfJ9
	lrqdmDTg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41240)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q57TV-0008HM-PD; Fri, 02 Jun 2023 17:18:01 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q57TT-000366-Iy; Fri, 02 Jun 2023 17:17:59 +0100
Date: Fri, 2 Jun 2023 17:17:59 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Oleksij Rempel <linux@rempel-privat.de>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phylib: fix phy_read*_poll_timeout()
Message-ID: <ZHoWN0uO30P/y9hv@shell.armlinux.org.uk>
References: <E1q4kX6-00BNuM-Mx@rmk-PC.armlinux.org.uk>
 <20230601213345.3aaee66a@kernel.org>
 <20230601213509.7ef8f199@kernel.org>
 <ZHmt9c9VsYxcoXaI@shell.armlinux.org.uk>
 <20230602090539.6a4fa374@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602090539.6a4fa374@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 09:05:39AM -0700, Jakub Kicinski wrote:
> On Fri, 2 Jun 2023 09:53:09 +0100 Russell King (Oracle) wrote:
> > > Yes it is :)  All this to save the single line of assignment
> > > after the read_poll_timeout() "call" ?  
> > 
> > Okay, so it seems you don't like it. We can't fix it then, and we'll
> > have to go with the BUILD_BUG_ON() forcing all users to use a signed
> > varable (which better be larger than a s8 so negative errnos can fit)
> > or we just rely on Dan to report the problems.
> 
> Wait, did the version I proposed not work?
> 
> https://lore.kernel.org/all/20230530121910.05b9f837@kernel.org/

If we're into the business of throwing web URLs at each other for
messages we've already read, here's my one for you which contains
the explanation why your one is broken, and proposing my solution.

https://lore.kernel.org/all/ZHZmBBDSVMf1WQWI@shell.armlinux.org.uk/

To see exactly why yours is broken, see the paragraph starting
"The elephant in the room..."

If it needs yet more explanation, which clearly it does, then let's
look at what genphy_loopback is doing:

                ret = phy_read_poll_timeout(phydev, MII_BMSR, val,
                                            val & BMSR_LSTATUS,
                                    5000, 500000, true);

Now, with your supposed "fix" of:

+	int __ret, __val;						\
+									\
+	__ret = read_poll_timeout(phy_read, __val, __val < 0 || (cond),	\
 		sleep_us, timeout_us, sleep_before_read, phydev, regnum); \

This ends up being:

	int __ret, __val;

	__ret = read_poll_timeout(phy_read, __val, __val < 0 || (val & BMSR_LSTATUS),
 		sleep_us, timeout_us, sleep_before_read, phydev, regnum);

and that expands to something that does this:

	__val = phy_read(phydev, regnum);
	if (__val < 0 || (val & BMSR_LSTATUS))
		break;

Can you spot the bug yet? Where does "val" for the test "val & BMSR_LSTATUS"
come from?

A bigger hint. With the existing code, this would have been:

	val = phy_read(phydev, regnum);
	if (val < 0 || (val & BMSR_LSTATUS))
		break;

See the difference? val & BMSR_LSTATUS is checking the value that was
returned from phy_read() here, but in yours, it's checking an
uninitialised variable.

With my proposal, this becomes:

	val = __val = phy_read(phydev, regnum);
	if (__val < 0 || (val & BMSR_LSTATUS))
		break;

where "val" is whatever type the user chose, which has absolutely _no_
bearing what so ever on whether the test for __val < 0 can be correctly
evaluated, and makes that test totally independent of whatever type the
user chose.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

